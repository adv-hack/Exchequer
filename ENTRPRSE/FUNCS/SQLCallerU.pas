unit SQLCallerU;

interface

uses SysUtils, Dialogs, ADODB, Classes, AdoConnect, ComObj, SQLUtils, GlobVar,ExchConnect;

//RB 25/07/2017 2017-R2 ABSEXCH-18914: Redeclared Connection constants because many projects use GlobVar with conditional defines
const
  CONNECTION_FAILURE = 'Connection failure';
  ERR_CONN_FAILURE = -2147467259;

type
  TSQLCaller = class(TObject)
  private
    FConnection: TExchConnection;  //VA:27/10/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    FQuery: TADOQuery;
    FStoredProcedure: TADOStoredProc;
    FErrorMsg: string;
    FRecords: TADODataset;
    FUsingLocalConnection: Boolean;
    FLastRecordCount: Integer;

    //SS:09/06/2017:2017-R1:ABSEXCH-18759:If an error occurs during posting, the error is not returned to Exchequer and depending on the error nothing is posted.
    FRaiseSuppressedException : Boolean;

    procedure SetConnectionString(const Value: WideString);
    function GetConnectionString: WideString;
    //RB 29/06/2017 2017-R2 ABSEXCH-18914: SQL connection fixes from Delphi end.
    function ResetLocalConnection: Boolean;
  public
    constructor Create (Const ExistingConnection : TExchConnection = NIL);
    destructor Destroy; override;
    //RB 25/07/2017 2017-R2 ABSEXCH-18914: Alternate way to get DrivePath because many projects uses GlobVar with Conditional Define
    function GetDrivePath: String;
    function ExecSQL(QueryStr: string; CompanyCode: string = ''): Integer;
    {SS 31/01/2016 2017-R1:ABSEXCH-13159:Ability to post single items from Daybook without putting other transactions on Hold.}
    function ExecStoredProcedure(SqlProcedureName : string; aParamList : TStringList): Integer;

    //GS 28/02/2012 ABSEXCH-11785: added function to replace quotes with double quotes in a given string
    class function CompatibilityFormat(SQLInput:AnsiString): AnsiString;
    procedure Close;
    procedure Select(QueryStr: string; CompanyCode: string = '');
    property Connection: TExchConnection read FConnection;
    property ConnectionString: WideString read GetConnectionString write SetConnectionString;
    property ErrorMsg: string read FErrorMsg;
    property StoredProcedure: TADOStoredProc read FStoredProcedure;
    property Records: TADODataset read FRecords;
    property Query: TADOQuery read FQuery;
    property LastRecordCount: Integer read FLastRecordCount;
    //SS:09/06/2017:2017-R1:ABSEXCH-18759:If an error occurs during posting, the error is not returned to Exchequer and depending on the error nothing is posted.
    property RaiseSuppressedException : Boolean read FRaiseSuppressedException write FRaiseSuppressedException;
  end;

implementation

// =============================================================================
// TSQLCaller
// =============================================================================

Uses
  StrUtils, DB; //GS 28/02/2012 ABSEXCH-11785: for 'AnsiReplaceStr'

// =============================================================================

procedure TSQLCaller.Close;
begin
  FRecords.Close;
end;

// -----------------------------------------------------------------------------
//GS 28/02/2012 ABSEXCH-11785: added function to replace quotes with double quotes in a given string
class function TSQLCaller.CompatibilityFormat(SQLInput: AnsiString): AnsiString;
begin
  //if the given string contains a single quote char:'
  //then replace this char with '' (two single quotes)
  //two single quotes in an escape char sequence in SQL that translates to a literal single quote
  Result := AnsiReplaceStr(SQLInput, chr(39), chr(39) + chr(39));
end;
        
constructor TSQLCaller.Create (Const ExistingConnection : TExchConnection = NIL);
begin
  inherited Create;

  //SS:09/06/2017:2017-R1:ABSEXCH-18759:If an error occurs during posting, the error is not returned to Exchequer and depending on the error nothing is posted.
  FRaiseSuppressedException := False;

  FUsingLocalConnection := Not Assigned(ExistingConnection);
  If FUsingLocalConnection Then
    FConnection := TExchConnection.Create(nil)  //VA:27/10/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  Else
    FConnection := ExistingConnection;
  FConnection.LoginPrompt := False;

  FQuery := TADOQuery.Create(nil);
  FQuery.Connection := FConnection;

  FStoredProcedure := TADOStoredProc.Create(nil);
  FStoredProcedure.Connection := FConnection;

  FRecords := TADODataset.Create(nil);
  FRecords.Connection := FConnection;
end;

// -----------------------------------------------------------------------------

destructor TSQLCaller.Destroy;
begin
  If FUsingLocalConnection Then
    FConnection.Close;
  FRecords.Connection := nil;
  FreeAndNil(FRecords);
  FStoredProcedure.Connection := nil;
  FreeAndNil(FStoredProcedure);
  FQuery.Connection := nil;
  FreeAndNil(FQuery);
  If FUsingLocalConnection Then
    FreeAndNil(FConnection);
  inherited;
end;
                                                        

{SS 31/01/2016 2017-R1:ABSEXCH-13159:Ability to post single items from Daybook without putting other transactions on Hold.}
function TSQLCaller.ExecStoredProcedure(SqlProcedureName : string; aParamList : TStringList): Integer;
var
  I : Integer;
  lParam : TParameter;
  lParamName : String;
  lRecordset : _Recordset;
  lRecordsAffected: Integer;
  lInTransaction,
  lConnected,
  lSQLException: Boolean;
begin
  //Check if the connection is in transaction then after reconnection we need to set transactionState
  lInTransaction := Connection.InTransaction;
  lSQLException := False;

  Result := -1;
  FErrorMsg := EmptyStr;

  if not Assigned(aParamList) then Exit;

  if (not Connection.Connected) then
    Connection.Open;

  if FStoredProcedure.Active then FStoredProcedure.Close;

  FStoredProcedure.ProcedureName := SqlProcedureName;
  FStoredProcedure.Parameters.Refresh;

  // Assign value to parameters.
  for I :=0 to aParamList.Count - 1 do
  begin
    lParamName := aParamList.Names[I];
    lParam :=  FStoredProcedure.Parameters.FindParam(lParamName);
    if Assigned(lParam) then
    begin
      lParam.Value := aParamList.Values[lParamName];
    end;
  end;

  try
    FLastRecordCount := 0;
    FStoredProcedure.Open;

    //SS:09/06/2017:2017-R1:ABSEXCH-18759:If an error occurs during posting, the error is not returned to Exchequer and depending on the error nothing is posted.
    // Whenever exception is supressed at ADO framework and Storedprocedure does not raise it. The moment we call for NextRecordset it will raise the exception.
    // NextRecordset should bre called only if StoredProcedure is empty and does not raise any exception.
    if (FRaiseSuppressedException) and  (FStoredProcedure.IsEmpty) then
      lRecordset := FStoredProcedure.NextRecordset(lRecordsAffected);

    Result := 0;
  except
    on E:Exception do
    begin
      Result := -1;
      //RB 29/06/2017 2017-R2 ABSEXCH-18914: SQL connection fixes from Delphi end.
      //ABSEXCH-18914: if there is some connection failure then try to Reset the Global Connection
      if (E is EOleException) and (EOleException(E).ErrorCode = ERR_CONN_FAILURE) then
      begin
        if Connection = GlobalADOConnection then
          lConnected := ResetConnection(SetDrive)
        else
          lConnected := ResetLocalConnection;

        //ABSEXCH-18914: if reconnection successfull then continue
        if lConnected then
        begin
          try
            //ABSEXCH-18914: If the connection was in transaction then begin transaction
            if lInTransaction then
              Connection.BeginTrans;

            FStoredProcedure.Open;
            if (FRaiseSuppressedException) and  (FStoredProcedure.IsEmpty) then
              lRecordset := FStoredProcedure.NextRecordset(lRecordsAffected);
            Result := 0;
          except
            on E: Exception do
            begin
              lSQLException := True;
              if (E.message <> '') then
                FErrorMsg := E.message
              else
                FErrorMsg := 'General SQL query error';
            end;
          end;
        end;
      end;
      //We don't want to override the exception
      if Not lSQLException then
      begin
        if (E.message <> '') then
          FErrorMsg := E.message
        else
          FErrorMsg := 'General SQL query error';
      end;
    end;
  end;

  // If there were any errors, fetch the last error and store it.
  if (Result = -1) and (Connection.Errors.Count > 0) then
    FErrorMsg := Connection.Errors.Item[Connection.Errors.Count - 1].Description
  else
    Result := 0;
end;



// -----------------------------------------------------------------------------

function TSQLCaller.ExecSQL(QueryStr: string; CompanyCode: string): Integer;
var
  AdminConnectionStr: string;
  lInTransaction,
  lConnected,
  lSQLException: Boolean;
begin
  lInTransaction := Connection.InTransaction;
  lSQLException := False;
  FErrorMsg := '';
  // Get the Admin connection string for the current Company, and prepare the
  // ADO Connection.
  if (not Connection.Connected) then
    Connection.Open;

  // Replace any [COMPANY] occurrences in the query string with the correct
  // Company Code, and store this in the ADO Query handler.
  if (CompanyCode <> '') then
    Query.SQL.Text := StringReplace(QueryStr, '[COMPANY]', '[' + CompanyCode + ']', [rfReplaceAll])
  else
    Query.SQL.Text := Trim(QueryStr);

  try
    { CJS 2012-07-16: ABSEXCH-12955 - 84.02  - Added LastRecordCount property }
    FLastRecordCount := 0;
    Result := Query.ExecSQL;
    FLastRecordCount := Result;
  except
    on E: Exception do
    begin
      Result := -1;
      //RB 29/06/2017 2017-R2 ABSEXCH-18914: SQL connection fixes from Delphi end.
      //if there is some connection failure then try to Reset the Global Connection
      if (E is EOleException) and (EOleException(E).ErrorCode = ERR_CONN_FAILURE) then
      begin
        if Connection = GlobalADOConnection then
          lConnected := ResetConnection(SetDrive)
        else
          lConnected := ResetLocalConnection;

        //ABSEXCH-18914: if reconnection successfull then continue
        if lConnected then
        begin
          try
            //ABSEXCH-18914: If the connection was in transaction then begin transaction
            if lInTransaction then
              Connection.BeginTrans;
            Result := Query.ExecSQL;
            FLastRecordCount := Result;
          except
            on E: Exception do
            begin
              lSQLException := true;
              if (E.message <> '') then
                FErrorMsg := E.message
              else
                FErrorMsg := 'General SQL query error';
            end;
          end;
        end;
      end;
      { CJS 2012-07-16: ABSEXCH-12955 - 84.02  - Added default error message }
      if Not lSQLException then
      begin
        if (E.message <> '') then
          FErrorMsg := E.message
        else
          FErrorMsg := 'General SQL query error';
      end;
    end;
  end;
  // If there were any errors, fetch the last error and store it.
  if (Result = -1) and (Connection.Errors.Count > 0) then
    FErrorMsg := Connection.Errors.Item[Connection.Errors.Count - 1].Description
  else
    Result := 0;
end;

// -----------------------------------------------------------------------------



function TSQLCaller.GetConnectionString: WideString;
begin
  Result := FConnection.ConnectionString;
end;

// -----------------------------------------------------------------------------

procedure TSQLCaller.Select(QueryStr: string; CompanyCode: string = '');
var
  AdminConnectionStr: string;
  ErrorCount: Integer;
  lInTransaction,
  lConnected: Boolean;
begin
  lInTransaction := Connection.InTransaction;

  FErrorMsg := '';
  ErrorCount := Connection.Errors.Count;
  if (not Connection.Connected) then
    Connection.Open;

  // Replace any [COMPANY] occurrences in the query string with the correct
  // Company Code, and store this in the ADO Query handler.
  if (CompanyCode <> '') then
    Records.CommandText := StringReplace(QueryStr, '[COMPANY]', '[' + CompanyCode + ']', [rfReplaceAll])
  else

    Records.CommandText := QueryStr;
  // Run the query.
  Records.CommandType := cmdText;
  try
    Records.Open;
  except
    on E: Exception do
    begin
      //RB 29/06/2017 2017-R2 ABSEXCH-18914: SQL connection fixes from Delphi end.
      //ABSEXCH-18914: if there is some connection failure then try to Reset the Connection
      if (E is EOleException) and (EOleException(E).ErrorCode = ERR_CONN_FAILURE) then
      begin
        if Connection = GlobalADOConnection then
          lConnected := ResetConnection(SetDrive)
        else
          lConnected := ResetLocalConnection;

        //ABSEXCH-18914: If the connection established carry forward
        if lConnected then
        begin
          //ABSEXCH-18914: If the connection was in transaction then begin transaction
          if lInTransaction then
            Connection.BeginTrans;
          Records.Open;
        end;
      end;
    end;
  end;


  // If there were any errors, fetch the last error and store it.
  if (Connection.Errors.Count > ErrorCount) then
  begin
    FErrorMsg := Connection.Errors.Item[Connection.Errors.Count - 1].Description;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLCaller.SetConnectionString(const Value: WideString);
begin
  //RB 10/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
  //Only modify FConnection if using LocalConnection.
  if FUsingLocalConnection then
  begin
    if (Value <> FConnection.ConnectionString) then
      FConnection.Close;
    FConnection.ConnectionString := Value;
  end;
end;

// -----------------------------------------------------------------------------

//RB 13/06/2017 2017-R2 ABSEXCH-18914: SQL connection fixes from Delphi end.
function TSQLCaller.ResetLocalConnection: Boolean;
var
  lCompanyCode,
  lConnectionString,
  lPassword: WideString;
  lRes: Integer;
begin
  try
    Connection.Close;
    lCompanyCode := GetCompanyCode(SetDrive);
    //SQLUtils.GetConnectionString(lCompanyCode, False, lConnectionString);
    //VA:27/10/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    lRes := SQLUtils.GetConnectionStringWOpass(lCompanyCode, False, lConnectionString, lPassword);
    Connection.ConnectionString := lConnectionString;
    Connection.Password := lPassword;
    if lRes = 0 then
      Connection.Open;
  finally
    Result := Connection.Connected;
  end;
end;

function TSQLCaller.GetDrivePath: String;
begin
  Result := SetDrive;
end;

end.
