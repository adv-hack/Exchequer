unit SQLFuncs;

interface

uses SysUtils, Dialogs, GlobVar, VarConst, SQLUtils, ADODB;

{
  Returns the number of users currently logged-in to Exchequer.
}
// function LoggedInUsers(CompanyCode: string): Integer;

{
  Clears all the Custom Window Settings records for the specified User. If
  no user is supplied, all the settings for all users will be deleted. Returns
  0 if successful, otherwise returns an error code.
}
function ResetCustomSettings(CompanyPath, UserID: string): Integer;

const
  // Constants to define the length of time to wait for a Prefill Cache
  CUSTSUPP_CACHE_TIME: Integer = 10;

implementation

function ResetCustomSettings(CompanyPath, UserID: string): Integer;
var
  WhereClause: string;
  BinaryCode: string;
  CodeField: string;
  CompanyCode: string;
begin
  { Get the correct column name, based on the fixed fieldname in the XML Schema }
  CodeField := SQLUtils.GetDBColumnName('EXSTKCHK.DAT', 'exstchk_var2', '');
  if (UserID <> '') then
  begin
    WhereClause := 'RecMFix=''%s'' and SubType=''%s'' and SUBSTRING(%s, 2, 10) = %s';
    { Convert the user name to the binary equivalent }
    BinaryCode := StringToHex(UserID, 10);
    { Insert the values into the Where clause }
    WhereClause := Format(WhereClause, [btCustTCode, btCustSCode, CodeField, BinaryCode]);
  end
  else
  begin
    WhereClause := Format('RecMFix=''%s'' and SubType=''%s''', [btCustTCode, btCustSCode]);
  end;
  { Get the current Company Code }
  CompanyCode := SQLUtils.GetCompanyCode(CompanyPath);
  { Delete the records }
  Result := SQLUtils.DeleteRows(CompanyCode, 'EXSTKCHK.DAT', WhereClause);
end;

// -----------------------------------------------------------------------------

end.
