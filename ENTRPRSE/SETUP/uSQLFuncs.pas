Unit uSQLFuncs;

Interface

Uses Windows, SysUtils, WiseUtil{SetupU,}, computil, Classes, strutil;

Function IsSQLVersion(DLLParams: ParamRec): Boolean;
Function SCD_CreateSQLDatabase(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SCD_CreateSQLCompany(Var DLLParams: ParamRec): LongBool; StdCall; export;
Function SCD_ImportCompData(Var DLLParams: ParamRec): LongBool; StdCall; export;

Implementation

Uses IniFiles, {dialogs,} uSqlClass, Math, SQLUtils;

{-----------------------------------------------------------------------------
  Procedure: GetDBLicenceVersion
  Author:    vmoura

  just checking which version of the database is being installed...
-----------------------------------------------------------------------------}
Function IsSQLVersion(DLLParams: ParamRec): Boolean;
Var
  lVersion: String;
Begin
  GetVariable(DLLParams, 'L_DBTYPE', lVersion);
  Result := lVersion = '1';
End;

{-----------------------------------------------------------------------------
  Procedure: SCD_CreateSQLDatabase
  Author:    vmoura
-----------------------------------------------------------------------------}
Function SCD_CreateSQLDatabase(Var DLLParams: ParamRec): LongBool;
Var
  lSQLSERVER, W_MainDir, ChkState, lDBName, lSQLProtocol : String;
  lRes: Integer;
  lErrorMessage: String;
Begin
  Result := False;
  {checking database version}
  If IsSQLVersion(DLLParams) Then
  Begin
    {load setup variables}
    GetVariable(DLLParams, 'SQLSERVER', lSQLSERVER);
    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
    GetVariable(DLLParams, 'V_DEMODATA', ChkState);
    GetVariable(DLLParams, 'V_SQLDBNAME', lDBName);
    ChkState := Trim(ChkState);

    FixPath(W_MainDir);

    lSQLSERVER := Trim(lSQLSERVER);

    { the "server" parameter should contain server\instance which is required for the sql commands  }
    {06/09/2007  it can be blank or '.'}
    //If lSQLSERVER <> '' Then
    //Begin
      Try
        With TSQLClass.Create Do
        Begin
          DLLPath := W_MainDir;
          UsingSql := True;
          {call create database where the user name will be the database name + _admin word}
          Try
            lRes := CreateSQLDatabase(lSQLSERVER, lDBName, lDBName + '_ADMIN', AdminPassword);
          Finally
            if lRes <> 0 then
              lErrorMessage := ExceptionError;

            Free;
          End; {try..finally}
        End; {with TSQLClass.Create do}

        {check if database already exists and a new company or a demo company is trying to be installed}
        If (lRes = 16) And (ChkState = 'Y') Then
          lRes := 0;

        Result := lRes = 0;

        {set errors variables}
        SetVariable(DLLParams, 'V_SQLCREATEDB', lErrorMessage);
        SetVariable(DLLParams, 'V_DLLERROR', InttoStr(lRes));

        // MH 22/10/2013 v7.0.7 ABSEXCH-14684: Added support for SQL protocol
        If Result Then
        Begin
          GetVariable(DLLParams, 'V_SQLPROTOCOL', lSQLProtocol);
          With TStringList.Create Do
          Begin
            Try
              Add ('<ExchequerSQLSettings>');
              Add ('    <Protocol>' + lSQLProtocol + '</Protocol>');
              Add ('</ExchequerSQLSettings>');
              SaveToFile (W_MainDir + 'ExchSQLSettings.xml');
            Finally
              Free;
            End; // Try..Finally
          End; // With TStringList.Create
        End; // If Result
      Finally
      End; {try..finally}
    //End; {if lSQLSERVER <> '' then}
  End; {if GetDBLicenceVersion(DLLParams) = '1' then}
End;

{-----------------------------------------------------------------------------
  Procedure: SCD_CreateSQLCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function SCD_CreateSQLCompany(Var DLLParams: ParamRec): LongBool;
Var
  lCompCode, lCompName, W_MainDir, lCompDir, lSqlData, lLoginUser, lLoginPass:
  String;

  lRes: Integer;

  lErrorMessage: String;
Begin {SCD_CreateSQLCompany}
  Result := False;
  {checking database version}
  If IsSQLVersion(DLLParams) Then
  Begin
    {load the setup variables}
    GetVariable(DLLParams, 'V_GETCOMPCODE', lCompCode);
    GetVariable(DLLParams, 'V_GETCOMPNAME', lCompName);
    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
    GetVariable(DLLParams, 'SQL_DATA', lSqlData);
    GetVariable(DLLParams, 'V_COMPDIR', lCompDir);

    GetVariable(DLLParams, 'SQL_USERLOGIN', lLoginUser);
    GetVariable(DLLParams, 'SQL_USERPASS', lLoginPass);

    FixPath(W_MainDir);

    lCompCode := Trim(lCompCode);
    lCompName := Trim(lCompName);

   {company name and could should be typed be the user after selection the directory to install exchequer files dialog}
    If (lCompName <> '') And (lCompName <> '') Then
    Begin
      lRes := -1;

      Try

        With TSQLClass.Create Do
        Begin
         {update emulator ini files}
          DLLPath := W_MainDir;
          UsingSql := True;
          {call create company where the sqldata is the file to be imported}
          Try
            lRes := CreateSQLCompany(lCompName, lCompCode, lCompDir, lSqlData,
              lLoginUser, lLoginPass);
          Finally
            if lRes <> 0 then
              lErrorMessage := ExceptionError;

            Free;
          End; {try..finally}
        End; {with TSQLClass.Create do}

        Result := lRes = 0;
        {set errors variables}
        SetVariable(DLLParams, 'V_SQLCREATECOMP', lErrorMessage);
        SetVariable(DLLParams, 'V_DLLERROR', InttoStr(lRes));
      Finally
      End; {try..finally}
    End; {if (lCompName <> '') and (lCompName <> '') then}
  End; {If IsSQLVersion(DLLParams) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: SCD_ImportCompData
  Author:    vmoura
-----------------------------------------------------------------------------}
Function SCD_ImportCompData(Var DLLParams: ParamRec): LongBool;
Var
  W_MainDir, lCompCode, lSqlData: String;
  lRes: Integer;
  lErrorMessage: String;
Begin {SCD_ImportCompData}
  Result := False;
  {checking database version}
  If IsSQLVersion(DLLParams) Then
  Begin
    {laod setup variables}
    GetVariable(DLLParams, 'V_GETCOMPCODE', lCompCode);
    GetVariable(DLLParams, 'SQL_DATA', lSqlData);
    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);

    lCompCode := Trim(lCompCode);

    If (lCompCode <> '') Then
    Begin
      lRes := -1;

      Try
        With TSQLClass.Create Do
        Begin
         {update emulator ini files}
          DLLPath := W_MainDir;
          UsingSql := True;
          {call import data where lsqldata is the file to be imported}
          Try
            lRes := ImportCompData(lCompCode, lSqlData)
          Finally
            if lRes <> 0 then
              lErrorMessage := ExceptionError;
            Free;
          End; {try..finally}
        End; {with TSQLClass.Create do}

        Result := lRes = 0;
        {set errors variables}
        SetVariable(DLLParams, 'V_SQLIMPORTDATA', lErrorMessage);
        SetVariable(DLLParams, 'V_DLLERROR', InttoStr(lRes));
      Finally
      End; {try..finally}
    End; {If (lCompName <> '')  Then}
  End; {If IsSQLVersion(DLLParams) Then}
End; {SCD_ImportCompData}

End.

