unit SQLReorder;

interface

uses VarConst, GlobVar, SQLReorderQuery, SQLCallerU, SQLRep_Config, SQLUtils;

function ReorderTransactions(CompanyCode: string): string;

implementation

// Amends the 'raw' order of transactions (i.e. based on PositionId) so that
// it matches the Transaction Date order.
//
// On error the returned string will hold the error message. If the routine
// finishes successfully the returned string will be blank.
function ReorderTransactions(CompanyCode: string): string;
var
  Qry: string;
  SQLCaller: TSQLCaller;
  ConnectionString,
  lPassword: WideString;
  i: Integer;
begin
  Result := '';
  // Build the query string
  Qry := '';
  for i := Low(SQL_REORDER_TRANSACTIONS) to High(SQL_REORDER_TRANSACTIONS) do
    Qry := Qry + SQL_REORDER_TRANSACTIONS[i] + ' ' + #13#10;

  // Set up the SQL Caller
  //GetConnectionString(CompanyCode, False, ConnectionString);
  //SS:28/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  GetConnectionStringWOPass(CompanyCode, False, ConnectionString, lPassword);
  SQLCaller := TSQLCaller.Create;
  SQLCaller.ConnectionString := ConnectionString;
  SQLCaller.Connection.Password := lPassword;
  SQLCaller.Connection.CommandTimeout := SQLReportsConfiguration.ReorderTransactionsTimeoutInSeconds;
  SQLCaller.Query.CommandTimeout := SQLReportsConfiguration.ReorderTransactionsTimeoutInSeconds;

  // Run the query and report any errors
  try
    if (SQLCaller.ExecSQL(Qry, CompanyCode) <> 0) or (SQLCaller.ErrorMsg <> '') then
      Result := 'Error running SQL query: ' + SQLCaller.ErrorMsg;
  finally
    SQLCaller.Free;
  end;
end;

end.
 