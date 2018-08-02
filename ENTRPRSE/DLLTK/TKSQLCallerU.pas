unit TKSQLCallerU;

interface

uses SysUtils, Dialogs, ADODB, GlobVar,ExchConnect;
  
type
  TSQLCaller = class(TObject)
  private
    FConnection: TExchConnection;
    FQuery: TADOQuery;
    FStoredProcedure: TADOStoredProc;
    FErrorMsg: string;
    FRecords: TADODataset;
    FCompanyCode : string;
    FCommand : TAdoCommand;
    procedure SetConnectionString(const Value: WideString);
    function GetConnectionString: WideString;

    procedure BeginTransComplete(
                Connection: TADOConnection; TransactionLevel: Integer;
                const Error: Error; var EventStatus: TEventStatus);

    procedure CommitTransComplete(
                Connection: TADOConnection; const Error: Error;
                var EventStatus: TEventStatus);

    function ResetConnection: Boolean;
  public
    constructor Create(const sDataPath : string);
    destructor Destroy; override;
    function ExecSQL(QueryStr: string; CompanyCode: string = ''): Integer;
    function ExecSQLWithCommand(QueryStr: string; CompanyCode: string = ''): Integer;
    procedure Close;
    procedure Select(QueryStr: string; CompanyCode: string = '');

    function Lock(const sTableName : string; iPos : longint; const Columns : string = '*') :  Boolean;
    procedure Commit;
    procedure Cancel;
    property Connection: TExchConnection read FConnection;
    property ConnectionString: WideString read GetConnectionString write SetConnectionString;
    property ErrorMsg: string read FErrorMsg;
    property StoredProcedure: TADOStoredProc read FStoredProcedure;
    property Records: TADODataset read FRecords;
    property Query: TADOQuery read FQuery;
    property CoCode : string read FCompanyCode;
  end;

  procedure StartSQLCaller(const DataPath : string; FileNum : Integer);
  procedure CloseSQLCaller(FileNum : Integer);
  procedure CloseSQLCallers;
  procedure InitSQLCallers;

  function SQLCaller(FileNum : Integer) : TSQLCaller;


implementation

uses
   SQLUtils, ADOConnect;

// =============================================================================
// TSQLCaller
// =============================================================================
const
  MaxCallers = 20;

var
  oSQLCaller : Array[1..MaxCallers] of TSQLCaller;

procedure StartSQLCaller(const DataPath : string; FileNum : Integer);
begin
  if Assigned(oSQLCaller[FileNum]) then
    CloseSQLCaller(Filenum);
  oSQLCaller[FileNum] := TSQLCaller.Create(DataPath);
end;

procedure CloseSQLCaller(FileNum : Integer);
begin
  FreeAndNil(oSQLCaller[FileNum]);
end;

function SQLCaller(FileNum : Integer) : TSQLCaller;
begin
  Result := oSQLCaller[Filenum];
end;

procedure InitSQLCallers;
var
  i : Integer;
begin
  for i := 1 to MaxCallers do
    oSQLCaller[i] := nil;
end;

procedure CloseSQLCallers;
var
  i : Integer;
begin
  for i := 1 to MaxCallers do
    if Assigned(oSQLCaller[i]) then
      CloseSQLCaller(i);
end;


// -----------------------------------------------------------------------------

procedure TSQLCaller.BeginTransComplete(
  Connection: TADOConnection; TransactionLevel: Integer;
  const Error: Error; var EventStatus: TEventStatus);
begin

end;

procedure TSQLCaller.CommitTransComplete(
  Connection: TADOConnection; const Error: Error;
  var EventStatus: TEventStatus);
begin

end;

procedure TSQLCaller.Cancel;
begin
  FConnection.RollbackTrans;
end;

procedure TSQLCaller.Close;
begin
  FRecords.Close;
end;

procedure TSQLCaller.Commit;
begin
  FConnection.CommitTrans;
end;

constructor TSQLCaller.Create(const sDataPath : string);
var
  Res : integer;
  sConnectionString,lPassword : WideString;      //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
begin
  inherited Create;
  //RB 22/08/2017 2017-R2 ABSEXCH-18933: Fix SQL connection failure issue in Toolkits
  //RB 30/08/2017 2017-R2 ABSEXCH-19177: Access Violation when selecting Sentimail on MCM manager - SQL only
  //We need to use individual connection for individual instance of TSQLcaller. If we use GlobalAdoConnection then every instance of TSQLCaller will use GlobalAdoConnection
  //and if one of the instance is destroyed then every other instance's connection becomes corrupted.
  FConnection := TExchConnection.Create(nil);
  FCompanyCode := GetCompanyCode(sDataPath);
  FConnection.CursorLocation := clUseServer;
  //Res := SQLUtils.GetConnectionString(FCompanyCode, False, sConnectionString);
  //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  Res := SQLUtils.GetConnectionStringWOPass(FCompanyCode, False, sConnectionString,lPassword);

  if Res <> 0 then
    raise Exception.Create('Toolkit SQL Connection: Unable to get Connection string');
  FConnection.ConnectionString := sConnectionString;
  FConnection.Password := lPassword;


  FQuery := TADOQuery.Create(nil);
  FQuery.Connection := FConnection;
  FQuery.CursorType := ctOpenForwardOnly;
  FQuery.CursorLocation := clUseServer;

  FStoredProcedure := TADOStoredProc.Create(nil);
  FStoredProcedure.Connection := FConnection;

  FRecords := TADODataset.Create(nil);
  FRecords.Connection := FConnection;

  FConnection.OnBeginTransComplete := BeginTransComplete;
  FConnection.OnCommitTransComplete := CommitTransComplete;

  FCommand := TAdoCommand.Create(nil);
  FCommand.Connection := FConnection;
  FCommand.CommandType := cmdText;

end;

// -----------------------------------------------------------------------------

destructor TSQLCaller.Destroy;
begin
  FConnection.Close;
  FRecords.Connection := nil;
  FreeAndNil(FRecords);
  FStoredProcedure.Connection := nil;
  FreeAndNil(FStoredProcedure);
  FQuery.Connection := nil;
  FreeAndNil(FQuery);
  FreeAndNil(FCommand);
  FreeAndNil(FConnection);
  inherited;
end;

// -----------------------------------------------------------------------------

function TSQLCaller.ExecSQL(QueryStr: string; CompanyCode: string): Integer;
var
  AdminConnectionStr: string;
begin
  FErrorMsg := '';
  // Get the Admin connection string for the current Company, and prepare the
  // ADO Connection.
{
  SQLUtils.GetConnectionString(CompanyCode, False, AdminConnectionStr);
  self.ConnectionString := AdminConnectionStr;
}
  if (not Connection.Connected) then
    Connection.Open;

  // Replace any [COMPANY] occurrences in the query string with the correct
  // Company Code, and store this in the ADO Query handler.
  if (CompanyCode <> '') then
    Query.SQL.Text := StringReplace(QueryStr, '[COMPANY]', '[' + CompanyCode + ']', [rfReplaceAll])
  else
    Query.SQL.Text := Trim(QueryStr);
  try
    // Run the query.
//    Query.Prepared := true;
//    Query.Parameters.ParseSQL(QueryStr, True);
    Result := Query.ExecSQL;
  except
    on E:Exception do
    begin
      Result := -1;
      FErrorMsg := E.message;
      //RB 22/08/2017 2017-R2 ABSEXCH-18933: Fix SQL connection failure issue in Toolkits
      if FErrorMsg = CONNECTION_FAILURE then
      begin
        if ResetConnection then
          Result := Query.ExecSQL;
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

function TSQLCaller.Lock(const sTableName: string; iPos: Integer; const Columns : string = '*'): Boolean;
const
  SQL_GETFORUPDATE = 'SELECT %s FROM [%s].[%s] WITH (ROWLOCK, UPDLOCK, NOWAIT) WHERE PositionID = %d';
var
  Res : Integer;
begin
  FConnection.IsolationLevel := ilSerializable;
  FConnection.Open;
  FConnection.BeginTrans;

  Query.CommandTimeOut := 1;
  Res := ExecSQLWithCommand(Format(SQL_GETFORUPDATE, [Columns, FCompanyCode, sTableName, iPos]));
  Result := Res = 0;
  if not Result then
    Cancel;
end;

procedure TSQLCaller.Select(QueryStr: string; CompanyCode: string = '');
var
  AdminConnectionStr: string;
  ErrorCount: Integer;
begin
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
      //RB 22/08/2017 2017-R2 ABSEXCH-18933: Fix SQL connection failure issue in Toolkits
      if E.Message = CONNECTION_FAILURE then
      begin
        if ResetConnection then
          Records.Open;
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
  if (Value <> FConnection.ConnectionString) then
    FConnection.Close;
  FConnection.ConnectionString := Value;
end;

// -----------------------------------------------------------------------------

function TSQLCaller.ExecSQLWithCommand(QueryStr,
  CompanyCode: string): Integer;
var
  AdminConnectionStr: string;
  wQueryStr : WideString;
begin
  FErrorMsg := '';
  // Get the Admin connection string for the current Company, and prepare the
  // ADO Connection.
{
  SQLUtils.GetConnectionString(CompanyCode, False, AdminConnectionStr);
  self.ConnectionString := AdminConnectionStr;
}
  if (not Connection.Connected) then
    Connection.Open;

  // Replace any [COMPANY] occurrences in the query string with the correct
  // Company Code, and store this in the ADO Query handler.
  if (CompanyCode <> '') then
    wQueryStr := Trim(StringReplace(QueryStr, '[COMPANY]', '[' + CompanyCode + ']', [rfReplaceAll]))
  else
    wQueryStr := Trim(QueryStr);
  try
{    if (CompanyCode <> '') then
      Connection.Execute(StringReplace(QueryStr, '[COMPANY]', '[' + CompanyCode + ']', [rfReplaceAll]), eoExecuteNoRecords)
    else}
      Connection.Execute(wQueryStr, cmdText, [eoExecuteNoRecords]);
//    FCommand.Execute;
    Result := 0;
  except
    on E:Exception do
    begin
      Result := -1;
      FErrorMsg := E.message;
      //RB 22/08/2017 2017-R2 ABSEXCH-18933: Fix SQL connection failure issue in Toolkits
      if FErrorMsg = CONNECTION_FAILURE then
      begin
        if ResetConnection then
        begin
          Connection.Execute(wQueryStr, cmdText, [eoExecuteNoRecords]);
          Result := 0;
        end;
      end;
    end;
  end;
  // If there were any errors, fetch the last error and store it.
  if (Result = -1) and (Connection.Errors.Count > 0) then
    FErrorMsg := Connection.Errors.Item[Connection.Errors.Count - 1].Description
  else
    Result := 0;
end;

//RB 22/08/2017 2017-R2 ABSEXCH-18933: Fix SQL connection failure issue in Toolkits
//RB 30/08/2017 2017-R2 ABSEXCH-19177: Access Violation when selecting Sentimail on MCM manager - SQL only
//Now reset individual connection instead of GlobalAdoConnection
function TSQLCaller.ResetConnection: Boolean;
var
  lCompanyCode,
  lConnectionString,
  lPassword:  WideString;
  lRes: Integer;
begin
  try
    Connection.Close;
    lCompanyCode := GetCompanyCode(SetDrive);
    //SQLUtils.GetConnectionString(lCompanyCode, False, lConnectionString);
    lRes := SQLUtils.GetConnectionStringWOPass(lCompanyCode, False, lConnectionString, lPassword);
    Connection.ConnectionString := lConnectionString;
    Connection.Password := lPassword;
    if lRes = 0 then
      Connection.Open;
  finally
    Result := Connection.Connected;
  end;
end;

initialization
  InitSQLCallers;

end.
