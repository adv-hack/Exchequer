unit FrameworkUtils;

interface

uses
  ADOdb;

procedure SetupSQLConnection(const Connection: TADOConnection);

implementation

Uses
  SQLUtils, SysUtils;

//Configure connection to use Windows Authorisation and allow access to all databases
procedure SetupSQLConnection(const Connection: TADOConnection);
var
  Res : Integer;
  sConn : AnsiString;
begin
  Res := SQLUtils.GetCommonConnectionString(sConn);
  if Res = 0 then
  begin
    Res := Pos('Initial Catalog', sConn);
    if Res > 0 then
      Delete(sConn, Res, Length(sConn));
    Connection.ConnectionString := sConn + 'Trusted_Connection=yes;';
    Connection.LoginPrompt := False;
  end
  else
    raise Exception.Create('Unable to load connection string: ' + IntToStr(Res));
end;


end.
