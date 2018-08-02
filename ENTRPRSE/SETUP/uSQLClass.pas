Unit uSQLClass;

Interface

Uses Windows, Sysutils, sqlutils, dialogs, Classes;

Const
  cDEFAULTERROR = -20;
  cERRORLOADINGDLL = -21;

Type
  TSQLClass = Class
  Private
    fUsingSql: Boolean;
    fDLLPath: String;
    fExceptionError: String;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure UpdateSQLINIFiles(Const Path: String);
    Function CreateSQLDatabase(Const pSqlServer, pDBName, pUser, pPass: String):
      Integer;
    Function CreateSQLCompany(Const pCompName, pCompCode, pCompanyPath, pSqlData,
      pSqlReadOnlyUser, pSqlReadOnlyPass: String): Integer;
    Function ImportCompData(Const pCompCode, pFileName: String): Integer;
    Function CopyData(Const pFromCompany, pToCompany: String): Integer;

  Published
    // set to overrideusingsql param
    Property UsingSql: Boolean Read fUsingSql Write fUsingSql Default True;
    // set the path from where to load the dll
    Property DLLPath: String Read fDLLPath Write fDLLPath;
    Property ExceptionError: String Read fExceptionError;
  End;

Implementation

Uses StrUtil, IniFiles, Math, strutils;

{ TSQLFuncs }

Constructor TSQLClass.Create;
Begin
  Inherited Create;
End;

Destructor TSQLClass.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateSQLINIFiles
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TSQLClass.UpdateSQLINIFiles(Const Path: String);
//Var
//  lPath: String;
//  lIni: TIniFile;
//  lStr: TStringList;
Begin
  {thse two files are used by the sql routines while creating company tables }

  (* MH 05/10/07: Removed on advice of Irfan as shouldn't be needed 
  lPath := IncludeTrailingPathDelimiter(path);
  {check tt.ini file and change its postfiles path}
  If FileExists(lPath + 'tt.ini') Then
  Begin
    lIni := TIniFile.Create(lPath + 'tt.ini');
    lIni.WriteString('FilePlaces', 'PostFiles', Path);
    lIni.Free;
  End; {if FileExists(lPath + 'tt.ini') then}

  {check tt_cont file and add the current path on it}
  If FileExists(lPath + 'TTL_CONT') Then
  Begin
    lStr := TStringList.Create;
    lStr.Add(lPath);
    lStr.SaveToFile(lPath + 'TTL_CONT');
    lStr.Free;
  End;
  *)
End; {UpdateSQLINIFiles}

{-----------------------------------------------------------------------------
  Procedure: CreateSQLCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSQLClass.CreateSQLCompany(Const pCompName, pCompCode, pCompanyPath,
  pSqlData, pSqlReadOnlyUser, pSqlReadOnlyPass: String): Integer;

// MH 05/09: Modified to use common function in SQL Utils
//  {get a randomic passaword}
//  Function GetPassword: String;
//  Const
//    Alpha: Array[1..26] Of String = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'j',
//      'i', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
//        'y', 'z');
//
//    Numeric: Array[1..10] Of String = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
//
//    AlphaUp: Array[1..26] Of String = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J',
//      'I', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
//      'Y', 'Z');
//  Begin
//    Randomize;
//    Result := '';
//
//    Result := RandomFrom(Alpha) + RandomFrom(Numeric) + RandomFrom(AlphaUp);
//    Result := Result + RandomFrom(Numeric) + RandomFrom(AlphaUp) + RandomFrom(Alpha);
//    Result := Result + RandomFrom(AlphaUp) + RandomFrom(Alpha);
//  End; {GetPassword}
//
//  {generate a randomic username}
//  Function GetUsername(CompCode: String): String;
//  Begin
//    Randomize;
//
//    Result := 'REP' + CompCode + PadString(psLeft, inttostr(Random(1000)), '0', 3)
//  End; {GetUsername}

  Function Auto_GetCompCode(CompName: ShortString): ShortString;
  Var
    sBase, sCode, lAux: String[6];
    iLoop: SmallInt;
    iMax, iId, lRes: LongInt;
  Begin // Auto_GetCompCode
    Result := '';

    lAux := StringReplace(Trim(CompName), ' ', '', [rfReplaceAll]);
    lAux := Copy(lAux, 1, 4);

    For iLoop := 4 Downto 1 Do
    Begin
      // Check we got enough chars
      If (Length(lAux) >= iLoop) Then
      Begin
        sBase := Copy(lAux, 1, iLoop);
        iMax := Trunc(Power(10, 6 - iLoop)) - 1;

        For iId := 1 To iMax Do
        Begin
          lRes := 0;
          sCode := sBase + Format('%*.*d', [6 - iLoop, 6 - iLoop, iId]);

          Result := sCode;

          {check if company exists...}
          try
            lRes := OpenCompanyByCode(Result);
          except
          end;

          if lRes <> 0 then
            Break;
        End; // For iId
      End; // If (Length(SeedText) >= iLoop)

      If (Result <> '') Then
        Break;
    End; // For iLoopend; {Func..}
  End; {Function Auto_GetCompCode(CompName: ShortString): ShortString;}

Var
  lCompCode, lUser, lPass: String;
  lError: Integer;
  lDir: string;
Begin
  Result := cDEFAULTERROR;
  fExceptionError := '';

  UpdateSQLINIFiles(fDLLPath);

  Try
    If Load_DLL(fDLLPath) Then
    Begin
      lError := 0;
      {set as using sql}
      Try
        lError := OverrideUsingSQL(fUsingSql);
      Except
      End;

      If lError = 0 Then
      Begin
        lCompCode := pCompCode;

        {check if company already exists}
//        try
//          Result := OpenCompanyByCode(lCompCode);
//        except
//        end;
//
//        {if company exists, try getting a new company code}
//        If Result = 0 Then
//          lCompCode := Auto_GetCompCode(pCompName);

        {check if username/password are ok. }
        lUser := Trim(pSqlReadOnlyUser);
        lPAss := Trim(pSqlReadOnlyPass);

        If lUser = '' Then
          // MH 05/09: Modified to use common function in SQL Utils
          //lUser := GetUsername(lCompCode);
          lUser := ReportingUser(lCompCode);

        If lPass = '' Then
          // MH 05/09: Modified to use common function in SQL Utils
          //lPass := GetPassword;
          lPass := ReportingPassword;

        {create a new company}
        Try
          lDir := GetCurrentDir;
          ChDir(fDLLPath);
          lError := CreateCompany(lCompCode, pCompName, pCompanyPath, pSqlData,
            lUser, lPass, Nil);
          ChDir(lDir);
        Except
        End;
      End; {If lError = 0 Then}

      Result := lError;

      if lError <> 0 then
        fExceptionError := sqlutils.GetSQLErrorInformation(lError);

      Unload_DLL;
    End {if Load_DLL(fDLLPath) then}
    Else
      Result := cERRORLOADINGDLL;
  Except
    On e: exception Do
      fExceptionError := 'Create MS SQL Company tables. Error: ' + e.Message
  End; {try..finally}
End;

{-----------------------------------------------------------------------------
  Procedure: CreateSQLDatabase
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSQLClass.CreateSQLDatabase(Const pSqlServer, pDBName, pUser, pPass:
  String): Integer;
var
  lError: Integer;
Begin
  Result := cDEFAULTERROR;
  fExceptionError := '';
  Try
    //ShowMessage(fDLLPath);
    If Load_DLL(fDLLPath) Then
    Begin
      lError := 0;
//      ShowMessage('Just before "override using sql"');

      {set as using sql}
      Try
        lError := OverrideUsingSQL(fUsingSql);
      Except
      End;

//      ShowMessage('Just before "create database"');

      If lError = 0 Then
      Try
        lError := CreateDatabase(pSqlServer, pDBName, pUser, pPass);
      Except
      End;

      Result := lError;

      if lError <> 0 then
        fExceptionError := sqlutils.GetSQLErrorInformation(lError);

//      ShowMessage('Create Database Result: ' + inttostr(Result));

//      ShowMessage('Just before "Unload_dll"');
      Unload_DLL;
    End {if Load_DLL(fDLLPath) then}
    Else
      Result := cERRORLOADINGDLL;
  Except
    On e: exception Do
      fExceptionError := 'Create MS SQL Database. Error: ' + E.message;
  End; {try..finally}
End;


{-----------------------------------------------------------------------------
  Procedure: ImportCompData
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSQLClass.ImportCompData(Const pCompCode,
  pFileName: String): Integer;
var
  lError: Integer;
  lDir: string;
Begin
  Result := cDEFAULTERROR;
  fExceptionError := '';

  Try
    If Load_DLL(fDLLPath) Then
    Begin
      lError := 0;

//      ShowMessage('Just before "override using sql"');

      {set as using sql}
      Try
        lError := OverrideUsingSQL(fUsingSql);
      Except
      End;

//      ShowMessage('Just before "import sql dataset". File: ' + pFileName);

      If lError = 0 Then
      Try
        lDir := GetCurrentDir;
        ChDir(fDLLPath);
        lError := ImportSQLDataset(pCompCode, pFileName);
        ChDir(lDir);
      Except
      End; {try}

      Result := lError;

      if lError <> 0 then
        fExceptionError := sqlutils.GetSQLErrorInformation(lError);

      Unload_DLL;
    End {If Load_DLL(fDLLPath) Then}
    Else
      Result := cERRORLOADINGDLL;
  Except
    On e: exception Do
      fExceptionError := 'Import Company Data Error. Error: ' + e.Message;
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: CopyData
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSQLClass.CopyData(Const pFromCompany,
  pToCompany: String): Integer;

  {create a temp file }
  Function fileTemp: String;
  Var
    Buffer: Array[0..MAX_PATH] Of Char;
    aFile: String;
  Begin
    GetTempPath(Sizeof(Buffer) - 1, Buffer);
    GetTempFileName(Buffer, 'TMP', 0, Buffer);
    SetString(aFile, Buffer, StrLen(Buffer));
    Result := ChangeFileExt(aFile, '.zip');
    RenameFile(aFile, Result);
  End; {function fileTemp: String;}

Var
  lTempFile: String;
  lError: Integer;
  lDir: string;
Begin
  Result := cDEFAULTERROR;
  fExceptionError := '';

  Try
    If Load_DLL(fDLLPath) Then
    Begin
      lError:= 0;
//      ShowMessage('Just before "override using sql"');

      lTempFile := fileTemp;

      {set as using sql}
      Try
        lError := OverrideUsingSQL(fUsingSql);
      Except
      End;

//      ShowMessage('Just before "import sql dataset". File: ' + lTempFile);

      If lError = 0 Then
      Begin
        Try
          lDir := GetCurrentDir;
          ChDir(fDLLPath);
          lError := ExportSQLDataset(pFromCompany, lTempFile);

          If lError = 0 Then
            If FileExists(lTempFile) Then
              lError := ImportSQLDataset(pToCompany, lTempFile);
        Finally
          ChDir(lDir);
          DeleteFile(lTempFile);
        End;
      End; {If Result = 0 Then}

      Result := lError;

      if lError <> 0 then
        fExceptionError := sqlutils.GetSQLErrorInformation(lError);

      Unload_DLL;
    End {If Load_DLL(fDLLPath) Then}
    Else
      Result := cERRORLOADINGDLL;
  Except
    On e: exception Do
      fExceptionError := 'Copy Company Data set Error. Error: ' + e.Message;
  End; {try}
End;

End.

