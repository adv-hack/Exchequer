unit BespokeFuncsInterface;

interface
uses
  Dialogs, APIUtil, SysUtils, SpecialPassword;

const
   iKey = 26;

  // Delphi Wrappers for the DLL Functions
  function SQLBuildBespokeConnectionStringD6(asPlugInCode : ANSIString; bReadOnly : boolean; var asConnectionString : ANSIString) : LongInt;
  function SQLGetExchequerDatabasePropertiesD6(var asExchDatabaseName : ANSIString; var asServerName : ANSIString) : LongInt;
  function SQLExecuteD6(bWindowsAuth : boolean; asSQLUserName, asSQLPassword, asDatabaseName, asSQL : ANSIString; bShowErrors : boolean) : integer;
  function SQLGetUserPasswordD6(var asUserPassword : ANSIString; bReadOnly : boolean; asSpecialPassword : ANSIString) : LongInt;
  function SQLGetUserD6(var asUser : ANSIString; bReadOnly : boolean; asSpecialPassword : ANSIString) : LongInt;

  {EXTERNAL FUNCTIONS LOCATED IN 'BespokeSQL.Dll'}
  function SQLGetExchequerDatabaseProperties(var pDatabaseName : pChar; var pServerName : pChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 1;
  function SQLSetUsername(pUserName : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 2;
  function SQLSetUserPassword(pUserPassword : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 3;
  function SQLGetUsername(var pUserName : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 4;
  function SQLGetUserPassword(var pUserPassword : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 5;
  function SQLGetBespokeDatabaseNameForCode(pCode : PChar; var pDatabase : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 6;
  function SQLBuildBespokeConnectionString(pPlugInCode : PChar; bReadOnly : wordbool; var pConnectionString : PChar; pSpecialPassword : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 7;
  function SQLBuildAdminConnectionString(bWindowsAuth : WordBool; pUserName, pPassword, pDatabaseName : PChar; var pConnectionString : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 8;
  function SQLBuildStandardConnectionString(bReadOnly : wordbool; var pConnectionString : PChar; pSpecialPassword : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 9;
  function SQLAddDefaultUser(bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 10;
  function SQLDatabaseExists(pDatabaseName : PChar; var bExists : WordBool) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 11;
  function SQLTableExists(pPlugInCode, pTableName : PChar; var bExists : WordBool) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 12;
  function SQLDatabaseDelete(bWindowsAuth : WordBool; pUserName, pPassword, pDatabaseName : PChar; pSpecialPassword  : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 13;
  function SQLDatabaseCreate(bWindowsAuth : WordBool; pUserName, pPassword, pDatabaseName : PChar; pSpecialPassword  : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 14;
  function SQLLoginExists(pLogin : PChar; var bExists : WordBool) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 15;
  function SQLUserExistsForDatabase(pUser, pDatabaseName : PChar; var bExists : WordBool) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 16;
  function SQLLoginCreate(bWindowsAuth : WordBool; pUserName, pPassword, pLoginName, pLoginPassword, pSpecialPassword  : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 17;
  function SQLAddDatabaseUser(bWindowsAuth : WordBool; pSQLUserName, pSQLPassword, pUser, pDatabaseName : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 18;
  function SQLExecute(bWindowsAuth : WordBool; pSQLUserName, pSQLPassword, pDatabaseName, pSQL : PChar; bShowErrors : WordBool; pSpecialPassword : PChar) : LongInt; stdCall; external 'BespokeFuncs.Dll' index 19;
  procedure SQLGetServerNamePervasive(var pServerName : PChar); stdCall; external 'BespokeFuncs.Dll' index 20;
  function SQLExchVersionSQL : WordBool; stdCall; external 'BespokeFuncs.Dll' index 21;

implementation

function SQLBuildBespokeConnectionStringD6(asPlugInCode : ANSIString; bReadOnly : boolean; var asConnectionString : ANSIString) : LongInt;
var
  pSpecialPassword, pPlugInCode, pConnectionString : PChar;
begin
  // Save Read Only User Password

  // Initialise
  pPlugInCode := StrAlloc(255);
  pConnectionString := StrAlloc(255);
  pSpecialPassword := StrAlloc(255);

  StrPCopy(pSpecialPassword, GetPassword{(iKey)});
  StrPCopy(pPlugInCode, asPlugInCode);

  Result := SQLBuildBespokeConnectionString(pPlugInCode, bReadOnly, pConnectionString, pSpecialPassword);
  if Result = 0 then
  begin
    asConnectionString := pConnectionString;
  end
  else
  begin
    MsgBox('An error occurred when calling SQLBuildBespokeConnectionString :'#13#13'Error : '
    + IntToStr(Result), mtError, [mbOK], mbOK, 'SQLBuildBespokeConnectionString Error');
  end;{if}

  // clear up
  StrDispose(pPlugInCode);
  StrDispose(pConnectionString);
  StrDispose(pSpecialPassword);
end;

function SQLGetExchequerDatabasePropertiesD6(var asExchDatabaseName : ANSIString; var asServerName : ANSIString) : LongInt;
var
  pDatabaseName, pServerName : pChar;
begin
  // initialise
  pDatabaseName := StrAlloc(255);
  pServerName := StrAlloc(255);

  Result := SQLGetExchequerDatabaseProperties(pDatabaseName, pServerName); // call DLL Function
  if Result = 0 then
  begin
    asExchDatabaseName := pDatabaseName;
    asServerName := pServerName;
  end
  else
  begin
    MsgBox('An error occurred when calling SQLGetExchequerDatabaseProperties :'#13#13'Error : '
    + IntToStr(Result), mtError, [mbOK], mbOK, 'SQLGetExchequerDatabaseProperties Error');
  end;{if}

  // clear up
  StrDispose(pDatabaseName);
  StrDispose(pServerName);
end;

function SQLExecuteD6(bWindowsAuth : boolean; asSQLUserName, asSQLPassword, asDatabaseName, asSQL : ANSIString; bShowErrors : boolean) : integer;
var
  pSQL, pSQLUserName, pSQLPassword, pSpecialPassword, pDatabaseName : PChar;
begin
  // initialise
  pSpecialPassword := StrAlloc(255);
  StrPCopy(pSpecialPassword, GetPassword{(iKey)});
  pSQLUserName := StrAlloc(255);
  StrPCopy(pSQLUserName, asSQLUsername);
  pSQLPassword := StrAlloc(255);
  StrPCopy(pSQLPassword, asSQLPassword);
  pDatabaseName := StrAlloc(255);
  StrPCopy(pDatabaseName, asDatabaseName);
  pSQL := StrAlloc(1000);
  StrPCopy(pSQL, asSQL);

  Result := SQLExecute(bWindowsAuth, pSQLUserName, pSQLPassword, pDatabaseName, pSQL, TRUE, pSpecialPassword);
  if (Result = 0) then
  begin
    //
  end
  else
  begin
    MsgBox('An error occurred when calling ExecuteSQL :'#13#13'Error : '
    + IntToStr(Result), mtError, [mbOK], mbOK, 'ExecuteSQL Error');
  end;{if}

  // clear up
  StrDispose(pSQL);
  StrDispose(pDatabaseName);
  StrDispose(pSpecialPassword);
  StrDispose(pSQLUserName);
  StrDispose(pSQLPassword);
end;

function SQLGetUserPasswordD6(var asUserPassword : ANSIString; bReadOnly : boolean; asSpecialPassword : ANSIString) : LongInt;
var
  pUserPassword, pSpecialPassword : PChar;
begin
  pSpecialPassword := StrAlloc(255);
  StrPCopy(pSpecialPassword, GetPassword);
  pUserPassword := StrAlloc(255);
  StrPCopy(pUserPassword, asUserPassword);

  Result := SQLGetUserPassword(pUserPassword, bReadOnly, pSpecialPassword);
  if Result = 0 then
  begin
    asUserPassword := pUserPassword;
  end
  else
  begin
    MsgBox('An error occurred when calling SQLGetUserPassword :'#13#13'Error : '
    + IntToStr(Result), mtError, [mbOK], mbOK, 'SQLGetUserPassword Error');
  end;{if}

  StrDispose(pUserPassword);
  StrDispose(pSpecialPassword);
end;

function SQLGetUserD6(var asUser : ANSIString; bReadOnly : boolean; asSpecialPassword : ANSIString) : LongInt;
var
  pUser, pSpecialPassword : PChar;
begin
  pSpecialPassword := StrAlloc(255);
  StrPCopy(pSpecialPassword, GetPassword);
  pUser := StrAlloc(255);
  StrPCopy(pUser, asUser);

  Result := SQLGetUsername(pUser, bReadOnly, pSpecialPassword);
  if Result = 0 then
  begin
    asUser := pUser;
  end
  else
  begin
    MsgBox('An error occurred when calling SQLGetUsername :'#13#13'Error : '
    + IntToStr(Result), mtError, [mbOK], mbOK, 'SQLGetUsername Error');
  end;{if}

  StrDispose(pUser);
  StrDispose(pSpecialPassword);
end;


end.
