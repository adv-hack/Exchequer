unit SQLTk;

interface

uses
  SQLCallerU;

function StartSQLCaller(CompanyPath: PChar): Integer;
procedure EndSQLCaller;

var
  oSQLCaller: TSQLCaller;

implementation

uses
  SQLUtils;

function StartSQLCaller(CompanyPath: PChar): Integer;
var
  CompanyCode: string;
  ConnectionStr,
  lPassword: WideString;
  BufferSize: Integer;
begin
  try
    CompanyCode := FindCompanyCode(CompanyPath);
  { Prepare a buffer to hold the returned connection string }

    BufferSize := 256;
    ConnectionStr := StrAlloc(256);
    //SS:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    GetCommonConnectionStringWOPass(ConnectionStr, BufferSize, lPassword, nil);

    oSQLCaller := TSQLCaller.Create;
    oSQLCaller.ConnectionString := ConnectionStr;
    oSQLCaller.Connection.Password := lPassword;
    Result := 0;
  Except
    Result := -1;
  end;
end;

procedure EndSQLCaller;
begin
  if Assigned(oSQLCaller) then
    FreeAndNil(oSQLCaller);
end;

Initialization
  oSQLCaller := nil;

end.
