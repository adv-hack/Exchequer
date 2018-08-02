unit SQLCallerU;

interface

uses SysUtils, Dialogs, ADODB,ExchConnect;

type
  TSQLCaller = class(TObject)
  private
    FConnection: TExchConnection;
    FQuery: TADOQuery;
    FStoredProcedure: TADOStoredProc;
    FErrorMsg: string;
    FRecords: TADODataset;
    FUsingLocalConnection: Boolean;
    procedure SetConnectionString(const Value: WideString);
    function GetConnectionString: WideString;
  public
    constructor Create (Const ExistingConnection : TExchConnection = NIL);
    destructor Destroy; override;
    function ExecSQL(QueryStr: string; CompanyCode: string = ''): Integer;
    procedure Close;
    procedure Select(QueryStr: string; CompanyCode: string = '');
    property Connection: TExchConnection read FConnection;
    property ConnectionString: WideString read GetConnectionString write SetConnectionString;
    property ErrorMsg: string read FErrorMsg;
    property StoredProcedure: TADOStoredProc read FStoredProcedure;
    property Records: TADODataset read FRecords;
    property Query: TADOQuery read FQuery;
  end;

implementation

// =============================================================================
// TSQLCaller
// =============================================================================

procedure TSQLCaller.Close;
begin
  FRecords.Close;
end;

// -----------------------------------------------------------------------------

constructor TSQLCaller.Create (Const ExistingConnection : TExchConnection = NIL);
begin
  inherited Create;

  FUsingLocalConnection := Not Assigned(ExistingConnection);
  If FUsingLocalConnection Then
    FConnection := TExchConnection.Create(nil)  //VA:27/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  Else
    FConnection := ExistingConnection;

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
    on Exception do
    ;
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

end.
