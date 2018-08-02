unit RewriteLoginFile;
//RB 08/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords

interface

  function RewriteLoginXMLFile(var ErrorString : string) : Integer;


implementation

uses
  SQLUtils, SysUtils, Dialogs, VAOUtil, Windows, GlobVar;

function RewriteLoginXMLFile(var ErrorString : string) : Integer;
var
  lConnectionString,
  lPassword,
  lServerName,
  lDBName,
  lUserName,
  lSwitch,
  lTempHolder,
  lCommandSpec: String;
  i: Integer;
  lPassFound, lServNameFound, lDBNameFound, lUserNameFound: Boolean;
begin
  Result := 0;
  if SQLUtils.UsingSQL then
  begin
    SQLUtils.GetCommonConnectionString(lConnectionString);

    lTempHolder := '';
    lSwitch := '/S';
    lPassFound := False;
    lServNameFound := False;
    lDBNameFound := False;
    lUserNameFound := False;
    for i := 1 to Length(Trim(lConnectionString)) do
    begin
      lTempHolder := lTempHolder + lConnectionString[i];
      if (lConnectionString[i] = '=') or (lConnectionString[i] = ';') then
      begin
        if UpperCase(lTempHolder) = UpperCase('Data Source=') then
        begin
          lServNameFound := True;
          lTempHolder := '';
          Continue;
        end
        else if UpperCase(lTempHolder) = UpperCase('Initial Catalog=') then
        begin
          lDBNameFound := True;
          lTempHolder := '';
          Continue;
        end
        else if UpperCase(lTempHolder) = UpperCase('User Id=') then
        begin
          lUserNameFound := True;
          lTempHolder := '';
          Continue;
        end
        else if UpperCase(lTempHolder) = UpperCase('Password=') then
        begin
          lPassFound := True;
          lTempHolder := '';
          Continue;
        end
        else
          lTempHolder := '';
      end;

      if lServNameFound then
      begin
        if lConnectionString[i] <> ';' then
          lServerName := lServerName + lConnectionString[i]
        else
          lServNameFound := False;
      end
      else if lDbNameFound then
      begin
        if lConnectionString[i] <> ';' then
          lDBName := lDbName + lConnectionString[i]
        else
          lDBNameFound := False;
      end
      else if lUserNameFound then
      begin
        if lConnectionString[i] <> ';' then
          lUserName := lUserName + lConnectionString[i]
        else
          lUserNameFound := False;
      end
      else if lPassFound then
      begin
        if lConnectionString[i] <> ';' then
          lPassword := lPassword + lConnectionString[i]
        else
          lPassFound := False;
      end;
    end;

    lCommandSpec := IncludeTrailingBackslash(SetDrive) + 'ExchSQLCreateLogin.exe' + ' ' +
                    lSwitch + ' ' +
                    lServerName + ' ' +
                    lDBName + ' ' +
                    lUserName + ' ' +
                    lPassword;
    WinExec(PChar(lCommandSpec), SW_HIDE);
  end;
end;

end.
