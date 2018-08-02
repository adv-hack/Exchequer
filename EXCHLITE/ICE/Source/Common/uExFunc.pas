{-----------------------------------------------------------------------------
 Unit Name: uExFunc
 Author:    vmoura
 Purpose: exchequer functionalities using the toolkit
 History:

Form: x:\entrprse\multcomp\compwiz1.pas

Auto_GetCompCode in x:\entrprse\multcomp\entinitu.pas

-----------------------------------------------------------------------------}

Unit uExFunc;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses Windows, Sysutils, Variants, Classes, EntLicence, Enterprise01_TLB
  ;
(*
{$I ExDllBt.Inc}
{$I ExchDll.Inc}
*)

Const
  cUDPERIOD = 'UDPeriod.dll';

Type
  TUseUDPeriods = Function(pDataPath: pChar): smallint; stdcall;
  TSuppressErrorMessages = Procedure(iSetTo: smallint); stdcall;
  TGetEndDateOfUDPY = Function(pDataPath: pChar; Var pDate: PChar; iPeriod, iYear:
    smallint): smallint; stdcall;
  TGetUDPeriodYear_Ext = Function(pDataPath, pDate: pChar; Var iPeriod: smallint; Var
    iYear: smallint): smallint; stdcall;

function _SetServiceDriveStrings(oToolkit: IToolkit): string;

Function _LoadUseUDPeriods(pLibrary: Cardinal): TUseUDPeriods;
Function _LoadSuppressErrorMessages(pLibrary: Cardinal): TSuppressErrorMessages;
Function _LoadGetEndDateOfUDPY(pLibrary: Cardinal): TGetEndDateOfUDPY;
Function _LoadGetUDPeriodYear_Ext(pLibrary: Cardinal): TGetUDPeriodYear_Ext;

Function _GetExCompanyPath(Const pExCode: String): String;
Function _GetExPath: String;
Function _GetExDataPath: String;
Function _CheckExCompCode(Const pExCode: String): Boolean;
Function _LoadExCompanies: Olevariant;
Function _GetExCompanies: Olevariant;
Function _GetVAOCompanies: Olevariant;
Function _ExProductType: TelProductType;
Function _ExCISInstalled: Boolean;

Function _GetExMaxPeriods(Const pExCode: String): Integer;
Function _CheckExDripFeed(Const pPath: String): Boolean;
Procedure _GetDripFeedPeriod(Const pPath: String; Out pPeriod1, pPeriod2:
  String);
Procedure _SetLastAuditDate(Const pPath: String; pNewDate: TDateTime); overload;
Procedure _SetLastAuditDate(Const pPath: String; Const pNewDate: String);
overload;
//Function _GetLastAuditDatePeriod(Const pPath: String): String;
Function _GetFirstDripFeedPeriodYear(Const pPath: String): String;
Function _GetLastDripFeedPeriodYear(Const pPath: String): String;
Function _GetLastAuditDate(Const pPath: String): String;
Function _GetLastSyncPeriodDate(Const pPath: String): String;

Function _RemoveDripFeed(Const pPath: String): Boolean;
Procedure _ApplyDripFeed(Const pPath: String);
Procedure _SetDripFeedPeriod(Const pPath: String; pPeriod1, pYear1, pPeriod2,
  pYear2: Byte);
Function _LocaliseExPath(Const APath: String): String;
Function _CheckExCompanyCount: Boolean;
Function _CheckTransaction(Const pPath: String): Boolean;

Function _IsVAO: Boolean;
function _GetExVersion: String;

Function EX_UPDATEAUDITDATE(NEWDATE: PCHAR): SMALLINT; stdcall; External
'EntDll32.Dll';

(*
Function UseUDPeriods(pDataPath: pChar): smallint; stdcall; external 'UDPeriod.dll';
Procedure SuppressErrorMessages(iSetTo: smallint) Stdcall; external 'UDPeriod.dll';
Function GetEndDateOfUDPY(pDataPath: pChar; Var pDate: PChar; iPeriod, iYear:
  smallint): smallint; stdcall; external 'UDPeriod.dll';
Function GetUDPeriodYear_Ext(pDataPath, pDate: pChar; Var iPeriod: smallint; Var
  iYear: smallint): smallint; stdcall; external 'UDPeriod.dll';
*)

var
  DriveMapped : Boolean;

Implementation

Uses math, Dateutils, strutils, ApiUtil,
  UseDLLU, TKUtil, CTKUTIL, uHistory,
  uICEDripFeed, uCommon, uconsts, VAOUtil, registry,

  //PR: 13/12/2013 ABSEXCH-14680
  ServiceDrive;

Var
  glMappedDrive, glLocalPath: String;

Function _LoadUseUDPeriods(pLibrary: Cardinal): TUseUDPeriods;
Begin
  Result := Nil;

  If pLibrary > 32 Then
    Result := GetProcAddress(pLibrary, 'UseUDPeriods');
End;

Function _LoadSuppressErrorMessages(pLibrary: Cardinal): TSuppressErrorMessages;
Begin
  Result := Nil;

  If pLibrary > 32 Then
    Result := GetProcAddress(pLibrary, 'SuppressErrorMessages');
End;

Function _LoadGetEndDateOfUDPY(pLibrary: Cardinal): TGetEndDateOfUDPY;
Begin
  Result := Nil;

  If pLibrary > 32 Then
    Result := GetProcAddress(pLibrary, 'GetEndDateOfUDPY');
End;

Function _LoadGetUDPeriodYear_Ext(pLibrary: Cardinal): TGetUDPeriodYear_Ext;
Begin
  Result := Nil;

  If pLibrary > 32 Then
    Result := GetProcAddress(pLibrary, 'GetUDPeriodYear_Ext');
End;
(*  //PR: 13/12/2013 ABSEXCH-14680 Moved to ServiceDrive.pas.
function ConnectDrive(_drvLetter: string; _netPath: string; _showError: Boolean;
  _reconnect: Boolean): DWORD;
var
  nRes: TNetResource;
  errCode: DWORD;
  dwFlags: DWORD;
Begin // ConnectDrive
  { Fill NetRessource with #0 to provide uninitialized values }
  { NetRessource mit #0 füllen => Keine unitialisierte Werte }
  FillChar(NRes, SizeOf(NRes), #0);
  nRes.dwType := RESOURCETYPE_DISK;
  { Set Driveletter and Networkpath }
  { Laufwerkbuchstabe und Netzwerkpfad setzen }
  nRes.lpLocalName  := PChar(_drvLetter);
  nRes.lpRemoteName := PChar(_netPath); { Example: \\Test\C }
  { Check if it should be saved for use after restart and set flags }
  { Überprüfung, ob gespeichert werden soll }
  if _reconnect then
    dwFlags := CONNECT_UPDATE_PROFILE and CONNECT_INTERACTIVE
  else
    dwFlags := CONNECT_INTERACTIVE;

  //errCode := WNetAddConnection3(Form1.Handle, nRes, nil, nil, dwFlags);
  errCode := WNetAddConnection2(nRes, nil, nil, dwFlags);

  { Show Errormessage, if flag is set }
  { Fehlernachricht aneigen }
  {
  if (errCode <> NO_ERROR) and (_showError) then
  begin
    Application.MessageBox(PChar('An error occured while connecting:' + #13#10 +
      SysErrorMessage(GetLastError)),
      'Error while connecting!',
      MB_OK);
  end;
  }
  Result := errCode; { NO_ERROR }
End; // ConnectDrive
*)

function _SetServiceDriveStrings(oToolkit: IToolkit): string;
var
  s, NetPath : string;
  i, j, Res : integer;
  LocalPath: string;
  MappedDrive: string;
begin
  LocalPath := UpperCase(WinGetShortPathName(ExtractFilePath(ParamStr(0))));
  _LogMSG('LocalPath: ' + LocalPath);
  with oToolkit.Company do
  begin
    for i := 1 to cmCount do
    begin
      s := UpperCase(Trim(cmCompany[i].coPath));
      MappedDrive := Copy(s, 1, 3);
      _LogMSG('MappedDrive: ' + MappedDrive);
      s := Copy(s, 4, Length(s));
      j := Pos(s, LocalPath);
      if j > 0 then
      begin
        LocalPath := IncludeTrailingBackslash(Copy(LocalPath, 1, j - 1));
        _LogMSG('LocalPath: ' + LocalPath);
        Break;
      end;
    end;
  end;
  NetPath := LocalPath;
  if (Copy(NetPath, 1, 1) <> Copy(MappedDrive, 1, 1)) then
  begin
    // CJS 13/09/2011 - Deal with shares which do not match the original path
    // Delete(NetPath, 1, 2); // Remove drive letter + ':'
    if NetPath[Length(NetPath)] = '\' then
      Delete(NetPath, Length(NetPath), 1);
    // NetPath := '\\' + WinGetComputerName + NetPath;
    NetPath := '\\' + WinGetComputerName + '\' + GetShareNameFromPath(NetPath);

    //PR: 13/12/2013 ABSEXCH-14680 Changed to use ConnectNetworkDrive in ServiceDrive.pas
    Res := ConnectNetworkDrive(Copy(MappedDrive, 1, 2), NetPath);
    _LogMSG('Network Path = ' + QuotedStr(NetPath));
    if (Res in [NO_ERROR, ERROR_ALREADY_ASSIGNED]) then
    begin
      _LogMSG(NetPath + ' mapped to ' + Copy(MappedDrive, 1, 2)) ;
    end
    else
    begin
      _LogMSG('Error: ConnectDrive returned  ' + IntToStr(Res));
    end;
  end
  else
    _LogMSG('No drive-mapping required');
end;

{-----------------------------------------------------------------------------
  Procedure: _GetExCompanyPath
  Author:    vmoura
  Arguments: Const pExCode: String
  Result:    String

  returns an exchequer company path
-----------------------------------------------------------------------------}
Function _GetExCompanyPath(Const pExCode: String): String;
Var
  oToolKit: IToolkit;
  lCont: Integer;
Begin
  Result := '';
  _CallDebugLog('open toolkit with back door');

  {open  the toolkit}
  Try
    oToolKit := CreateToolkitWithBackdoor;
  Except
    On e: exception Do
    Begin
      _LogMSG('_GetExCompanyPath :- Error creating the toolkit. Error: ' +
        e.message);
      If Assigned(oToolKit) Then
        _LogMSG('_GetExCompanyPath :- Toolkit error message: ' +
          oToolKit.LastErrorString);
    End; {begin}
  End; {try}

  { check if the toolkit is ok.}
  If Assigned(oToolKit) Then
  Begin
    _CallDebugLog('loading company path');
    Try
      With oToolKit, oToolKit.Company Do
      Begin
        If cmCount > 0 Then
          For lCont := 1 To cmCount Do
          Begin
            If Lowercase(Trim(cmCompany[lCont].coCode)) =
              Lowercase(Trim(pExCode))
              Then
            Begin
              //Result := Trim(cmCompany[lCont].coPath);
              Result := _LocaliseExPath(Trim(cmCompany[lCont].coPath));
              Break;
            End; // if cmCompany[lcont] = pExcode
          End; // for lCont

//        oToolKit := Nil;
      End; { with oToolkit.company}
    Except
      On E: Exception Do
        _LogMSG('_GetExCompanyPath :- Error getting company path. Error: ' +
          e.Message);
    End; { if assigned(otoolkit) }

    oToolKit := Nil;
  End
  Else
    _LogMSG('_GetExCompanyPath :- Could not create COM Toolkit instance');
End;

{-----------------------------------------------------------------------------
  Procedure: _LoadExCompanies
  Author:    vmoura

  return a list of exchequer companies as shown on MCM
-----------------------------------------------------------------------------}
Function _LoadExCompanies: Olevariant;
Begin
  Result := null;

  If _IsVAO Then
  begin
    _CallDebugLog('Loading IAOO companies...');
    Result := _GetVAOCompanies;
  end
  Else
  begin
    _CallDebugLog('Loading companies...');
    Result := _GetExCompanies;
  end
End;

{-----------------------------------------------------------------------------
  Procedure: _GetExCompanies
  Author:    vmoura
-----------------------------------------------------------------------------}
(*
Function _GetExCompanies: Olevariant;

  function _LastPos(SubStr, S: string): Integer;
  var
    Found, Len, Pos: integer;
  begin
    Pos := Length(S);
    Len := Length(SubStr);
    Found := 0;
    while (Pos > 0) and (Found = 0) do
    begin
      if Copy(S, Pos, Len) = SubStr then
        Found := Pos;
      Dec(Pos);
    end;
    Result := Found;
  end;

Var
  oToolKit: IToolkit;
  lRes,
    lCont, lValid, lPos: Integer;
  lAux, lLocal: String;
Begin
  Result := null;

  {open  the toolkit}
  Try
    oToolKit := CreateToolkitWithBackdoor;
  Except
    On e: exception Do
    Begin
      _LogMSG('_GetExCompanies :- Error creating the toolkit. Error: ' +
        e.message);
      If Assigned(oToolKit) Then
        _LogMSG('_GetExCompanies :- Toolkit error message: ' +
          oToolKit.LastErrorString);
    End; {begin}
  End; {try}

  { check if the toolkit is ok.}
  If Assigned(oToolKit) Then
  Begin
    Try
      With oToolKit Do
        If Company.cmCount > 0 Then
        Begin
          lValid := 0;

          _SetServiceDriveStrings(oToolkit);

          {check local path against network path}
          lLocal := UpperCase(ExtractFilePath(ParamStr(0)));

          if Trim(lLocal) = '' then
            lLocal := UpperCase(_GetApplicationPath);

          For lCont := 0 To Company.cmCount - 1 Do
          Begin
            lAux := UpperCase(Trim(Company.cmCompany[lCont + 1].coPath));
            glMappedDrive := Copy(lAux, 1, 3);
            lAux := Copy(lAux, 4, Length(lAux));

            { 26/04/2007
              we have a problem where some sites are installing exchequer in local drives
              as "e:\exch\exch" and that is causing to wrongly localise the drive because it
              tries to match the first instance of "exch", for example... normaly, according to qa,
              it should be something like "e:\exch\enterpse" or similar...
              so, the solution was to get the last occurrence of the "drive"
              i want to map, i.e, "exch" for example
              the example, e:\exch\exch, should return e:\exch\ and then use this directory as
              base for the mapped drivers...

            }
            //lPos := Pos(lAux, lLocal);
            lPos := _LastPos(lAux, lLocal);

            If lPos > 0 Then
            Begin
              glLocalPath := IncludeTrailingPathDelimiter(Copy(lLocal, 1, lPos - 1));
              Break;
            End; {If lPos > 0 Then}
          End; {For lCont := 0 To cmCount - 1 Do}

          _CallDebugLog('1) Local Path: ' + glLocalPath + ' Network Path: ' + glMappedDrive);

          If glLocalPath = '' Then
            glLocalPath := glMappedDrive;

          _CallDebugLog('2) Local Path: ' + glLocalPath + ' Network Path: ' + glMappedDrive);

          {check if all company paths exist}
          For lCont := 0 To Company.cmCount - 1 Do
          Try
            _CallDebugLog('Checking company ' + Company.cmCompany[lCont + 1].coName +
              ' Path: ' + Trim(Company.cmCompany[lCont + 1].coPath) +
              ' Local: ' + _LocaliseExPath(Trim(Company.cmCompany[lCont + 1].coPath)));

            {check if the company path is valid}
            If _DirExists(_LocaliseExPath(Trim(Company.cmCompany[lCont + 1].coPath))) Then
              Inc(lValid);
          Except
          End; {for lCont:= 0 to cmCount - 1 do}

        {create array according to the valid number of companies}
          Result := VarArrayCreate([0, lValid], varVariant);

          lValid := 0;
          For lCont := 0 To Company.cmCount - 1 Do
            If _DirExists(_LocaliseExPath(Trim(Company.cmCompany[lCont + 1].coPath))) Then
            Begin
              Configuration.DataDirectory := _LocaliseExPath(Trim(Company.cmCompany[lCont +
                1].coPath));

              Try
                lRes := 0;

                Try
                  lRes := oToolKit.OpenToolkit;
                Except
                  On e: exception Do
                    _LogMSG('_GetExCompanies :- Error opening the Toolkit. Error: '
                      + e.message);
                End; {try}

                {if everything is ok, load company details}
                If lRes = 0 Then
                Begin
                  Result[lValid] := VarArrayOf([
                    Trim(Company.cmCompany[lCont + 1].coCode),
                      Trim(Company.cmCompany[lCont + 1].coName),
                      _LocaliseExPath(Trim(Company.cmCompany[lCont + 1].coPath)),
                      oToolKit.SystemSetup.ssPeriodsInYear
                      ]);
                  Inc(lValid);
                End; {If lRes = 0 Then}
              Finally
                If lRes = 0 Then
                  oToolKit.CloseToolkit;
              End; {try}
            End; {_DirExists(_LocaliseExPath(Trim(cmCompany[lCont + 1].coPath)))}
        End; {If cmCount > 0 Then}
    Except
      On E: Exception Do
        _LogMSG('_GetExCompanies :- Error loading Exchequer companies . Error: ' +
          e.Message);
    End;

    oToolKit := Nil;
  End { if assigned(otoolkit) }
  Else
    _LogMSG('_GetExCompanies :- Could not create COM Toolkit instance');
End;
*)
Function _GetExCompanies: Olevariant;

  function _LastPos(SubStr, S: string): Integer;
  var
    Found, Len, Pos: integer;
  begin
    Pos := Length(S);
    Len := Length(SubStr);
    Found := 0;
    while (Pos > 0) and (Found = 0) do
    begin
      if Copy(S, Pos, Len) = SubStr then
        Found := Pos;
      Dec(Pos);
    end;
    Result := Found;
  end;

Var
  oToolKit: IToolkit;
  lRes, lCont, lValid, lPos: Integer;
  lAux, lLocal: String;
Begin
  Result := null;

  {open  the toolkit}
  Try
    oToolKit := CreateToolkitWithBackdoor;
  Except
    On e: exception Do
    Begin
      _LogMSG('_GetExCompanies :- Error creating the toolkit. Error: ' +
        e.message);
      If Assigned(oToolKit) Then
        _LogMSG('_GetExCompanies :- Toolkit error message: ' +
          oToolKit.LastErrorString);
    End; {begin}
  End; {try}

  { check if the toolkit is ok.}
  If Assigned(oToolKit) Then
  Begin
    Try
      With oToolKit Do
        If Company.cmCount > 0 Then
        Begin
          lValid := 0;

          //PR: 13/12/2013 ABSEXCH-14680 Don't bother if drive is already mapped.
          if not DriveMapped then
            _SetServiceDriveStrings(oToolkit);

          {check if all company paths exist}
          For lCont := 0 To Company.cmCount - 1 Do
          Try
            _CallDebugLog('Checking company ' + Company.cmCompany[lCont + 1].coName +
              ' Path: ' + Trim(Company.cmCompany[lCont + 1].coPath) +
              ' Local: ' + _LocaliseExPath(Trim(Company.cmCompany[lCont + 1].coPath)));

            {check if the company path is valid}
            If _DirExists(Trim(Company.cmCompany[lCont + 1].coPath)) Then
              Inc(lValid);
          Except
          End; {for lCont:= 0 to cmCount - 1 do}

        {create array according to the valid number of companies}
          Result := VarArrayCreate([0, lValid], varVariant);

          lValid := 0;
          For lCont := 0 To Company.cmCount - 1 Do
            If _DirExists(Trim(Company.cmCompany[lCont + 1].coPath)) Then
            Begin
              Configuration.DataDirectory := Trim(Company.cmCompany[lCont + 1].coPath);

              Try
                lRes := 0;

                Try
                  lRes := oToolKit.OpenToolkit;
                Except
                  On e: exception Do
                    _LogMSG('_GetExCompanies :- Error opening the Toolkit. Error: '
                      + e.message);
                End; {try}

                {if everything is ok, load company details}
                If lRes = 0 Then
                Begin
                  Result[lValid] := VarArrayOf([
                    Trim(Company.cmCompany[lCont + 1].coCode),
                      Trim(Company.cmCompany[lCont + 1].coName),
                      Trim(Company.cmCompany[lCont + 1].coPath),
                      oToolKit.SystemSetup.ssPeriodsInYear
                      ]);
                  Inc(lValid);
                End; {If lRes = 0 Then}
              Finally
                If lRes = 0 Then
                  oToolKit.CloseToolkit;
              End; {try}
            End; {_DirExists(_LocaliseExPath(Trim(cmCompany[lCont + 1].coPath)))}
        End; {If cmCount > 0 Then}
    Except
      On E: Exception Do
        _LogMSG('_GetExCompanies :- Error loading Exchequer companies . Error: ' +
          e.Message);
    End;

    oToolKit := Nil;
  End { if assigned(otoolkit) }
  Else
    _LogMSG('_GetExCompanies :- Could not create COM Toolkit instance');
End;

{-----------------------------------------------------------------------------
  Procedure: _GetVAOCompanies
  Author:    vmoura

  these functions are very similar with Thread1.pas and worksta2.pas units used
  by sentimail
-----------------------------------------------------------------------------}
Function _GetVAOCompanies: Olevariant;
  {load VAO entry info via sentimail}
  Procedure _LoadVaoEntries(Var pDirMask, pSubDir: String);
  Var
    lAux: String;
  Begin
    With TRegistry.Create Do
    Try
      RootKey := HKEY_LOCAL_MACHINE;
      If OpenKey(ElertKey, False) Then
      Begin
        Try
          {load vao entry prefix}
          lAux := '';
          lAux := Trim(ReadString(ElVAODirPrefix));

          {get the correct mask for searching directories}
          If lAux <> '' Then
            pDirMask := lAux + '*';

          lAux := '';
          lAux := Trim(ReadString(ElVAOSubdir));

          If lAux <> '' Then
            pSubDir := IncludeTrailingPathDelimiter(lAux);
        Except
          pDirMask := '';
          pSubDir := '';
        End; {try}
      End; {If OpenKey(ElertKey, False) Then}

      if (pDirMask = '') or (pSubDir = '') then
      begin
        RootKey := HKEY_CURRENT_USER;
        If OpenKey(ElertKey, False) Then
        Begin
          Try
            {load vao entry prefix}
            lAux := '';
            lAux := Trim(ReadString(ElVAODirPrefix));

            {get the correct mask for searching directories}
            If lAux <> '' Then
              pDirMask := lAux + '*';

            lAux := '';
            lAux := Trim(ReadString(ElVAOSubdir));

            If lAux <> '' Then
              pSubDir := IncludeTrailingPathDelimiter(lAux);
          Except
            pDirMask := '';
            pSubDir := '';
          End; {try}
        End; {If OpenKey(ElertKey, False) Then}
      end; {if (pDirMask = '') or (pSubDir = '') then}

        
    Finally
      Free;
    End; {With TRegistry.Create Do}
  End; {function _GetVaoEntry: String;}
Var
  lDirMask, lSubDir: String;
  lRec: TSearchRec;
  lDirList: TStringlist;
  lAux: String;
  lCont, lCont2, lTotal, {lActualSize,} lPos: Integer;
  lCompList: Olevariant;
Begin
  {get vao directories - Base on sentimail entries}
  _LoadVaoEntries(lDirMask, lSubDir);
  _CallDebugLog('Dir Mask = ' + lDirMask + ' SubDir = ' + lSubDir);

  If (lDirMask <> '') And (lSubDir <> '') Then
  Begin
    {load a list of exchequer directories}
    lDirList := TStringlist.Create;

    If FindFirst(lDirMask, faDirectory, lRec) = 0 Then
    Begin
      Repeat
        lAux := Copy(lDirMask, 1, 3) + IncludeTrailingPathDelimiter(lRec.Name);
        If FileExists(lAux + lSubDir + 'Company.Dat') Then
        Begin
          lDirList.Add(lAux + lSubDir);
          _CallDebugLog('Ex Directory = ' + lAux + lSubDir);
        End; {If FileExists(lAux + lSubDir + 'Company.Dat') Then}
      Until FindNext(lRec) <> 0;
    End; {if FindFirst(lDirMask, faDirectory, lRec) = 0 then}

    FindClose(lRec);

    {check the result list and load the companies parameters}
    If lDirList.Count > 0 Then
    Begin
      _CallDebugLog('VAO directories found ' + inttostr(lDirList.Count));
      lPos := 0;

      For lCont := 0 To lDirList.Count - 1 Do
      Begin
        _CallDebugLog('Setting dir ' + lDirList[lCont]);
        {set enterprise directory and load the companies}
        _SetEnterpriseDir(lDirList[lCont]);
        lCompList := null;
        {load companies as usual}
        lCompList := _GetExCompanies;
        lTotal := _GetOlevariantArraySize(lCompList);
        If lTotal > 0 Then
        Try
          {resize the list}
//          lActualSize := _GetOlevariantArraySize(Result);
          If _GetOlevariantArraySize(Result) > 0 Then
          Begin
            VarArrayRedim(Result, _GetOlevariantArraySize(Result) + lTotal);
              // reset this variable to put values in the right position of the array
            //Inc(lActualSize);

          End
          Else
            Result := VarArrayCreate([0, lTotal], varVariant);

          {add company details to the final list}
          For lCont2 := 0 To lTotal - 1 Do
          Begin
            //_CallDebugLog('Filling company ' + inttostr(lActualSize + lCont2));
            _CallDebugLog('Filling company ' + inttostr(lPos));

            //Result[lActualSize + lCont2] := VarArrayOf([
            Result[lPos] := VarArrayOf([
              lCompList[lCont2][0],
                lCompList[lCont2][1],
                lCompList[lCont2][2],
                lCompList[lCont2][3]
                ]);

            inc(lPos);
          End; {for lCont2:= 0 to lTotal - 1 do}
        Except
          On e: Exception Do
          Begin
            _LogMSG('_GetVAOCompanies :- Error loading VAO companies. Error: ' +
              E.message);
            Result := null;
          End;
        End; {if lTotal > 0 then}
      End; {for lCont:= 0 to lDirList.Count - 1 do}
    End; {if lDirList.Count > 0 then}

    lDirList.Free;
  End; {if (lDirMask <> '') and (lSubDir <> '') then}
End;

{-----------------------------------------------------------------------------
  Procedure: _ExProductType
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _ExProductType: TelProductType;
Var
  lLic: TEnterpriseLicence;
Begin
  Result := ptExchequer;
  lLic := Nil;

  Try
    lLic := TEnterpriseLicence.Create('');
  Except
    On e: exception Do
    Begin
      lLic := Nil;
      _LogMSG('_ExProductType :- Error loading Exchequer version object. Error: '
        + e.message);
    End; {begin}
  End; {try}

  If Assigned(lLic) Then
  Begin
    Result := lLic.elProductType;

    FreeAndNil(lLic);
  End {If Assigned(lLic) Then}
  Else
    _LogMSG('_ExProductType :- Object not assigned...');
End;

{-----------------------------------------------------------------------------
  Procedure: _ExCISInstalled
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _ExCISInstalled: Boolean;
Var
  lLic: TEnterpriseLicence;
Begin
  Result := False;
  lLic := Nil;
  Try
    lLic := TEnterpriseLicence.Create('');
  Except
    On e: exception Do
    Begin
      lLic := Nil;
      _LogMSG('_ExCISInstalled :- Error loading Exchequer version object. Error: '
        + e.message);
    End; {begin}
  End; {try}

  If Assigned(lLic) Then
  Begin
    Result := lLic.elModules[modCISRCT] <> mrNone;
    FreeAndNil(lLic);
  End {If Assigned(lLic) Then}
  Else
    _LogMSG('_ExCISInstalled :- Object not assigned...');
End;

{-----------------------------------------------------------------------------
  Procedure: _IsVAO
  Author:    vmoura

  check if vao system is installed
-----------------------------------------------------------------------------}
Function _IsVAO: Boolean;
Var
  lVAO: IVAOInformation;
Begin
  Result := False;
  Try
    lVAO := VAOInfo;
  Except
    On e: exception Do
    Begin
      _LogMSG('_IsVAO :- Error loading VAO info. Error: ' + e.Message);
      lVAO := Nil;
    End; {begin}
  End; {try}

  If Assigned(lVAO) Then
  Begin
    {check vao version}
    Result := lVAO.vaoMode = smVAO;
    lVAO := Nil;
  End; {if Assigned(lVAO) then}
End;

function _GetExVersion: String;
begin
end;

{-----------------------------------------------------------------------------
  Procedure: _GetExPath
  Author:    vmoura

  return the exchequer path
-----------------------------------------------------------------------------}
Function _GetExPath: String;
Var
  oToolKit: IToolkit;
Begin
  Result := '';

  {open  the toolkit}
  Try
    oToolKit := CreateToolkitWithBackdoor;
  Except
    On e: exception Do
    Begin
      _LogMSG('_GetExPath :- Error creating the toolkit. Error: ' + e.message);
      If Assigned(oToolKit) Then
        _LogMSG('_GetExPath :- Toolkit error message: ' + oToolKit.LastErrorString);
    End; {begin}
  End; {try}

  { check if the toolkit is ok.}
  If Assigned(oToolKit) Then
  Begin
    With oToolKit Do
      Result := Configuration.EnterpriseDirectory;

    oToolKit := Nil;
  End { if assigned(otoolkit)}
  Else
    _LogMSG('_GetExPath :- Could not create COM Toolkit instance!');
End;

{-----------------------------------------------------------------------------
  Procedure: _GetExDataPath
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetExDataPath: String;
Var
  oToolKit: IToolkit;
Begin
  Result := '';

  {open  the toolkit}
  Try
    oToolKit := CreateToolkitWithBackdoor;
  Except
    On e: exception Do
    Begin
      _LogMSG('_GetExDataPath :- Error creating the toolkit. Error: ' + e.message);
      If Assigned(oToolKit) Then
        _LogMSG('_GetExDataPath :- Toolkit error message: ' +
          oToolKit.LastErrorString);
    End; {begin}
  End; {try}

  { check if the toolkit is ok.}
  If Assigned(oToolKit) Then
  Begin
    With oToolKit Do
      Result := _LocaliseExPath(Configuration.DataDirectory);

    oToolKit := Nil;
  End { if assigned(otoolkit)}
  Else
    _LogMSG('_GetExDataPath :- Could not create COM Toolkit instance');
End;

{-----------------------------------------------------------------------------
  Procedure: _CheckExCompCode
  Author:    vmoura

  Look for a company with matching code
-----------------------------------------------------------------------------}
Function _CheckExCompCode(Const pExCode: String): Boolean;
Var
  oToolKit: IToolkit;
  lCont: Integer;
Begin
  Result := False;

  {open  the toolkit}
  Try
    oToolKit := CreateToolkitWithBackdoor;
  Except
    On e: exception Do
    Begin
      _LogMSG('_CheckExCompCode :- Error creating the toolkit. Error: ' +
        e.message);
      If Assigned(oToolKit) Then
        _LogMSG('_CheckExCompCode :- Toolkit error message: ' +
          oToolKit.LastErrorString);
    End; {begin}
  End; {try}

  { check if the toolkit is ok.}
  If Assigned(oToolKit) Then
  Begin
    Try
      With oToolKit, oToolKit.Company Do
      Begin
        If cmCount > 0 Then
          For lCont := 1 To cmCount Do
            If Lowercase(Trim(cmCompany[lCont].coCode)) =
              Lowercase(Trim(pExCode))
              Then
            Begin
              Result := True;
              Break;
            End; { if cmCompany[lcont] = pCode}
      End; { with oToolkit.company}
    Except
      On E: Exception Do
        _LogMSG('_CheckExCompCode :- Error checking EX companies code. Error: ' +
          e.Message);
    End;

    oToolKit := Nil;
  End { if assigned(otoolkit)}
  Else
    _LogMSG('_CheckExCompCode :- Could not create COM Toolkit instance!');
End;

{-----------------------------------------------------------------------------
  Procedure: _GetExMaxPeriods
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetExMaxPeriods(Const pExCode: String): Integer;
Var
  oToolKit: IToolkit;
  lCont,
    lRes: Integer;
Begin
  Result := 0;

  {open  the toolkit}
  Try
    oToolKit := CreateToolkitWithBackdoor;
  Except
    On e: exception Do
    Begin
      _LogMSG('_GetExMaxPeriods :- Error creating the toolkit. Error: ' +
        e.message);
      If Assigned(oToolKit) Then
        _LogMSG('_GetExMaxPeriods :- Toolkit error message: ' +
          oToolKit.LastErrorString);
    End; {begin}
  End; {try}

  { check if the toolkit is ok.}
  If Assigned(oToolKit) Then
  Begin
    Try
      With oToolKit, oToolKit.Company Do
      Begin
        If cmCount > 0 Then
          For lCont := 1 To cmCount Do
            If Lowercase(Trim(cmCompany[lCont].coCode)) =
              Lowercase(Trim(pExCode)) Then
            Begin
              oToolKit.Configuration.DataDirectory :=
                _LocaliseExPath(cmCompany[lCont].coPath);

              lRes := 0;
              Try
                lRes := oToolKit.OpenToolkit;
              Except
                On e: exception Do
                  _LogMSG('_GetExMaxPeriods :- Error opening the Toolkit. Error: '
                    + e.message);
              End; {try}

              If lRes = 0 Then
                Result := oToolKit.SystemSetup.ssPeriodsInYear;

              Break;
            End; { if cmCompany[lcont] = pCode}
      End; { with oToolkit.company}
    Finally
      oToolKit.CloseToolkit;
      oToolKit := Nil;
    End;
  End { if assigned(otoolkit)}
  Else
    _LogMSG('_GetExMaxPeriods :- Could not create COM Toolkit instance!');
End;

{-----------------------------------------------------------------------------
  Procedure: _GetTransactionCount
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CheckTransaction(Const pPath: String): Boolean;
Var
  oToolKit: IToolkit;
  lRes: Integer;
Begin
  Result := False;

  {open  the toolkit}
  Try
    oToolKit := CreateToolkitWithBackdoor;
  Except
    On e: exception Do
    Begin
      _LogMSG('_CheckTransaction :- Error creating the toolkit. Error: ' +
        e.message);
      If Assigned(oToolKit) Then
        _LogMSG('_CheckTransaction :- Toolkit error message: ' +
          oToolKit.LastErrorString);
    End; {begin}
  End; {try}

  { check if the toolkit is ok.}
  If Assigned(oToolKit) Then
  Begin
    Try
      With oToolKit Do
      Begin
        Configuration.DataDirectory := _LocaliseExPath(pPath);

        lRes := 0;
        Try
          lRes := OpenToolkit;
        Except
          On e: exception Do
            _LogMSG('_CheckTransaction :- Error opening the Toolkit. Error: ' +
              e.message);
        End;

        If lRes = 0 Then
        Begin
          lRes := Transaction.GetFirst;
          Result := lRes = 0;
        End; {If lRes = 0 Then}
      End; { with oToolkit.company}
    Finally
      oToolKit.CloseToolkit;
      oToolKit := Nil;
    End;
  End { if assigned(otoolkit)}
  Else
    _LogMSG('_CheckTransaction :- Could not create COM Toolkit instance!');
End;

{-----------------------------------------------------------------------------
  Procedure: _GetFirstDripFeedPeriodYear
  Author:    vmoura

  it loads the lastaudit date, add one and convert it to a period year

Function UseUDPeriods(pDataPath: pChar): smallint; stdcall; external 'UDPeriod.dll';
Procedure SuppressErrorMessages(iSetTo: smallint) Stdcall; external 'UDPeriod.dll';
Function GetEndDateOfUDPY(pDataPath: pChar; Var pDate: PChar; iPeriod, iYear:
  smallint): smallint; stdcall; external 'UDPeriod.dll';
Function GetUDPeriodYear_Ext(pDataPath, pDate: pChar; Var iPeriod: smallint; Var
  iYear: smallint): smallint; stdcall; external 'UDPeriod.dll';

-----------------------------------------------------------------------------}
//Function _GetLastAuditDatePeriod(Const pPath: String): String;
Function _GetFirstDripFeedPeriodYear(Const pPath: String): String;

  Function _IncreaseLastAuditDate(Const pLastDate: String): String;
  Var
    lAux: String;
    lDate: TDatetime;
  Begin
    lAux := pLastDate;
     // yyyymmdd
    //lAux := copy(lAux, 7, 2) + '/' + copy(lAux, 5, 2) + '/' + copy(lAux, 1, 4);
    lAux := copy(lAux, 7, 2) + DateSeparator + copy(lAux, 5, 2) + DateSeparator +
      copy(lAux, 1, 4);

     {try to convert to a real date value}
    Try
      lDate := StrToDateDef(lAux, 0);
    Except
      lDate := 0;
    End;

     {if everytihing is ok, add one day to it and format it again}
    If lDate > 0 Then
    Begin
      ldate := IncDay(lDAte, 1);
      lAux := FormatDateTime('yyyymmdd', lDate);
    End; {If lDate > 0 Then}

    Result := lAux;
  End; {Function _IncreaseLastAuditDate(Const pLastDate: String): String;}

Var
  oToolkit: IToolkit;
  Res: Longint;
  lYear, lPeriod: Smallint;
  lYearEx, lPeriodEx: Integer;
  lLastDatestr: String;
  lUseUDPeriods: TUseUDPeriods;
  lSuppress: TSuppressErrorMessages;
  lGetUD: TGetUDPeriodYear_Ext;
  lHandle: Cardinal;
Begin
  Result := '';

  lHandle := LoadLibrary(cUDPERIOD);

  If lHandle > 32 Then
  Begin
    lUseUDPeriods := _LoadUseUDPeriods(lHandle);

    If Assigned(lUseUDPeriods) Then
    Begin
      {open  the toolkit}
      Try
        oToolkit := CreateToolkitWithBackdoor;
      Except
        On e: exception Do
        Begin
          _LogMSG('_GetFirstDripFeedPeriodYear :- Error creating the toolkit. Error: '
            +
            e.message);
          If Assigned(oToolKit) Then
            _LogMSG('_GetFirstDripFeedPeriodYear :- Toolkit error message: ' +
              oToolKit.LastErrorString);
        End; {begin}
      End; {try}

      If Assigned(oToolKit) Then
      Begin
        Try
          With oToolKit Do
          Begin
            {set the company datapath}
            Configuration.DataDirectory := _LocaliseExPath(pPath);

            Res := 0;
            Try
              Res := OpenToolkit;
            Except
              On e: exception Do
                _LogMSG('_GetFirstDripFeedPeriodYear :- Error opening the Toolkit. Error: '
                  + e.message);
            End; {try}

            If Res = 0 Then
            Begin
              { yyyymmdd get the last audti date}
              lLastDateStr := _IncreaseLastAuditDate(SystemSetup.ssLastAuditDate);

              {check use defined periods}
              //If UseUDPeriods(pChar(_LocaliseExPath(pPath))) = 1 Then
              If lUseUDPeriods(pChar(_LocaliseExPath(pPath))) = 1 Then
              Begin
                //SuppressErrorMessages(1);
                lSuppress := _LoadSuppressErrorMessages(lHandle);
                If Assigned(lSuppress) Then
                  lSuppress(1)
                Else
                  _LogMSG('_GetFirstDripFeedPeriodYear :- Could not load "SuppressErrorMessages" function!');

                //GetUDPeriodYear_Ext(pChar(_LocaliseExPath(pPath)), pChar(lLastDate),
                //  lPeriod, lYear);

                lGetUD := _LoadGetUDPeriodYear_Ext(lHandle);
                If Assigned(lGetUD) Then
                Try
                  lGetUD(pChar(_LocaliseExPath(pPath)), pChar(lLastDateStr),
                    lPeriod, lYear)
                Except
                  On e: exception Do
                    _LogMSG('_GetFirstDripFeedPeriodYear :- Error calling "GetUDPeriodYear_Ext". Error: '
                      + e.Message);
                End
                Else
                  _LogMSG('_GetFirstDripFeedPeriodYear :- Could not load "GetUDPeriodYear_Ext" function!');

                Result := _FormatPeriod(lPeriod, ifthen(lYear < 1900, 1900 + lYear,
                  lYear));
              End
              Else
              Begin
                Res := oToolKit.Functions.entConvertDateToPeriod(lLastDateStr,
                  lPeriodEx, lYearEx);
                  
              {if something goes wrong with the increased date, use the lastauditdate instead}
                If Res <> 0 Then
                  oToolKit.Functions.entConvertDateToPeriod(SystemSetup.ssLastAuditDate,
                    lPeriodEx, lYearEx);

                Result := _FormatPeriod(lPeriodEx, ifthen(lYearEx < 1900, 1900 +
                  lYearEx, lYearEx));
              End;
            End; {If lRes = 0 Then}
          End; { with oToolkit.company}
        Finally
          oToolKit.CloseToolkit;
          oToolKit := Nil;
        End;
      End {If Assigned(oToolKit) Then}
      Else
        _LogMSG('_GetFirstDripFeedPeriodYear :- Could not load Toolkit!');
    End
    Else
      _LogMSG('_GetFirstDripFeedPeriodYear :- Could not load "UseUDPeriods" function!');

    FreeLibrary(lHandle);
  End
  Else
    _LogMSG('_GetFirstDripFeedPeriodYear :- Could not dynamically load ' +
      cUDPERIOD);
End;

{-----------------------------------------------------------------------------
  Procedure: _GetLastDripFeedPeriodYear
  Author:    vmoura

  load the last period year set to the drip feed file
-----------------------------------------------------------------------------}
Function _GetLastDripFeedPeriodYear(Const pPath: String): String;
Var
  lp1, lP2: String;
Begin
  _GetDripFeedPeriod(pPath, lp1, lP2);

  Result := lP2;
End;

{-----------------------------------------------------------------------------
  Procedure: _GetLastSyncPeriodDate
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetLastSyncPeriodDate(Const pPath: String): String;
  Procedure DateStr(Smond: String;
    Var tdd, tmm, tyy: Word);

  Var
    P: Integer;

  Begin
    val(copy(Smond, 1, 4), tyy, p);
    val(copy(Smond, 5, 2), tmm, p);
    val(copy(Smond, 7, 2), tdd, p);

  End;

Var
  oToolkit: IToolkit;
  Res: Longint;
  lDate: TDatetime;
  lPer1, lPer2: String;
  {lStartPer,}lEndPer, {lStartYear,} lEndYear: smallint;
  lPerAux, lYearAux: Integer;
  ldateBuff: pChar;
  ldd, lmm, lyy: Word;
  lHandle: Cardinal;
  lUD: TUseUDPeriods;
  lSuppress: TSuppressErrorMessages;
  lGED: TGetEndDateOfUDPY;
Begin
  Result := '';

  lHandle := LoadLibrary(cUDPERIOD);

  If lhandle > 32 Then
  Begin
    lUD := _LoadUseUDPeriods(lHandle);

    If Assigned(lUD) Then
    Begin
      {load the dripfeed params previous set by the dsr/dashboard}
      _GetDripFeedPeriod(pPath, lPer1, lPer2);
      lEndPer := strtoint(_GetPeriod(lPer2));
      lEndYear := strtoint(_GetYear(lPer2));

              {check user defined periods}
      //If (UseUDPeriods(PChar(_LocaliseExPath(pPath))) = 1) Then
      If lUD(PChar(_LocaliseExPath(pPath))) = 1 Then
      Begin
        // SuppressErrorMessages(1);
        lSuppress := _LoadSuppressErrorMessages(lHandle);
        If Assigned(lSuppress) Then
          lSuppress(1)
        Else
          _LogMSG('_GetLastSyncPeriodDate :- Could not load "SuppressErrorMessages" function!');

        ldateBuff := StrAlloc(10);
        DecodeDate(now, lyy, lmm, ldd);
        If lEndYear > 1900 Then
          lYearAux := lEndYear - 1900
        Else
          lYearAux := lEndYear;

        Try
(*          Try
            If GetEndDateOfUDPY(pChar(_LocaliseExPath(pPath)), lDateBuff,
              lEndPer, lYearAux) = 0 Then
              DateStr(lDateBuff, ldd, lmm, lyy);
          Except
          End;*)

          lGED := _LoadGetEndDateOfUDPY(lHandle);
          If Assigned(lGED) Then
          Begin
            Try
              If lGED(pChar(_LocaliseExPath(pPath)), lDateBuff,
                lEndPer, lYearAux) = 0 Then
                DateStr(lDateBuff, ldd, lmm, lyy);
            Except
              on e:exception do
                _LogMSG('_GetLastSyncPeriodDate :- Error calling "GetEndDateOfUDPY" function. Error: ' + e.Message);
            End;
          End
          Else
            _LogMSG('_GetLastSyncPeriodDate :- Could not load "GetEndDateOfUDPY" function!');

          lDate := EncodeDate(lyy, lmm, ldd);
        Finally
          StrDispose(ldateBuff);
        End;
      End {If (UseUDPeriods(PChar(_LocaliseExPath(pPath))) = 1) Then}
      Else
      Begin
         {open  the toolkit}
        Try
          oToolkit := CreateToolkitWithBackdoor;
        Except
          On e: exception Do
          Begin
            _LogMSG('_GetLastSyncPeriodDate :- Error creating the toolkit. Error: '
              + e.message);
            If Assigned(oToolKit) Then
              _LogMSG('_GetLastSyncPeriodDate :- Toolkit error message: ' +
                oToolKit.LastErrorString);
          End; {begin}
        End; {try}

        If Assigned(oToolKit) Then
        Begin
          With oToolKit Do
          Begin
            Try
              {set company path}
              Configuration.DataDirectory := _LocaliseExPath(pPath);
              Res := 0;

              Try
                Res := OpenToolkit;
              Except
                On e: exception Do
                  _LogMSG('_GetLastSyncPeriodDate :- Error opening the Toolkit. Error: '
                    + e.message);
              End; {try}

              If Res = 0 Then
              Begin

                {user defined periods off}
                If lEndYear = YearOf(Now) Then
                  lDate := StartOfTheYear(Now)
                Else If lEndYear > YearOf(Now) Then
                  lDate := StartOfTheYear(IncYear(Now, lEndYear - YearOf(Now)))
                Else
                  lDate := StartOfTheYear(IncYear(Now, -(YearOf(Now) - lEndYear)));

              {get the first period and year}
                Functions.entConvertDateToPeriod(FormatDateTime('yyyymmdd', lDate),
                  lPerAux, lYearAux);

                {locate the righ period}
                While lPerAux <> lEndPer Do
                Begin
                  ldate := IncDay(lDate, 1);
                  Functions.entConvertDateToPeriod(FormatDateTime('yyyymmdd',
                    lDate), lPerAux, lYearAux);

                  {got the right period}
                  If lPerAux = lEndPer Then
                  Begin
                    {locate the last valid date}
                    While lPerAux = lEndPer Do
                    Begin
                      ldate := IncDay(lDate, 1);
                      Functions.entConvertDateToPeriod(FormatDateTime('yyyymmdd',
                        lDate), lPerAux, lYearAux);
                      {when period change again, the last date is known}
                      If lPerAux <> lEndPer Then
                        Break;
                    End; {while lPerAux = lEndPer do}

                    Break;
                  End;
                End; {While lPerAux <> lEndPer Do}

                lDate := IncDay(lDate, -1);
              End; {If lRes = 0 Then}
            Finally
              oToolKit.CloseToolkit;
              oToolKit := Nil;
            End;
          End; { with oToolkit.company}
        End {If Assigned(oToolKit) Then}
        Else
          _LogMSG('_GetLastSyncPeriodDate :- Could not create COM Toolkit instance');
      End; {else begin}

      Result := FormatDateTime('yyyymmdd', lDate);

      _CallDebugLog('_GetLastSyncPeriodDate :- Company Path: ' + pPath +
        '. Last audit date: ' + DateToStr(lDate));
    End
    Else
      _LogMSG('_GetLastSyncPeriodDate :- Could not load "UseUDPeriods" function!');

    FreeLibrary(lHandle);  
  End
  Else
    _LogMSG('_GetLastSyncPeriodDate :- Could not dynamically load ' + cUDPERIOD);
End;

{-----------------------------------------------------------------------------
  Procedure: _GetLastAuditDate
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _GetLastAuditDate(Const pPath: String): String;
Var
  oToolkit: IToolkit;
  Res: Longint;
Begin
  Result := '';

  {open  the toolkit}
  Try
    oToolkit := CreateToolkitWithBackdoor;
  Except
    On e: exception Do
    Begin
      _LogMSG('_GetLastAuditDate :- Error creating the toolkit. Error: ' +
        e.message);
      If Assigned(oToolKit) Then
        _LogMSG('_GetLastAuditDate :- Toolkit error message: ' +
          oToolKit.LastErrorString);
    End; {begin}
  End; {try}

  If Assigned(oToolKit) Then
  Begin
    Try
      With oToolKit Do
      Begin
        {set company path}
        Configuration.DataDirectory := _LocaliseExPath(pPath);

        Res := 0;

        Try
          Res := OpenToolkit;
        Except
          On e: exception Do
            _LogMSG('_GetLastAuditDate :- Error opening the Toolkit. Error: ' +
              e.message);
        End;

        If Res = 0 Then
        Begin
          // yyyymmdd
          Result := SystemSetup.ssLastAuditDate;
        End; {If lRes = 0 Then}
      End; { with oToolkit.company}
    Finally
      oToolKit.CloseToolkit;
      oToolKit := Nil;
    End;
  End {If Assigned(oToolKit) Then}
  Else
    _LogMSG('_GetLastAuditDate :- Could not create COM Toolkit instance');
End;

{-----------------------------------------------------------------------------
  Procedure: _SetLastAuditDate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _SetLastAuditDate(Const pPath: String; Const pNewDate: String);
Var
  Res: SmallInt;
  lPath,
    lDate: PChar;
  oToolkit: IToolkit;
  lVersion: Boolean;
Begin
  {open  the toolkit}
  Try
    oToolkit := CreateToolkitWithBackdoor;
  Except
    On e: exception Do
    Begin
      _LogMSG('_SetLastAuditDate :- Error creating the toolkit. Error: ' +
        e.message);
      If Assigned(oToolKit) Then
        _LogMSG('_SetLastAuditDate :- Toolkit error message: ' +
          oToolKit.LastErrorString);
    End; {begin}
  End; {try}

  If Assigned(oToolKit) Then
  Begin
    {check exchequer version}
    lVersion := oToolkit.Enterprise.enCurrencyVersion <> enProfessional;
    oToolkit := Nil;
  End
  Else
    _LogMSG('_SetLastAuditDate :- Could not create COM Toolkit instance');

  {open dll toolkit with backdoor}
  ToolKitOK;
  GetMem(lPath, MAX_PATH);
  StrpCopy(lpath, ppath);
  {load dll with the company path}
  Try
    Res := Ex_InitDllPath(lPath, lVersion);
  Finally
    freemem(lpath);
  End;

  If Res = 0 Then
  Begin
    {init dll }
    Res := Ex_InitDll;
    If Res = 0 Then
    Begin
      GetMem(lDate, 25);
      Try
        {apply last audit date}
        //StrPCopy(lDate, FormatDateTime('yyyymmdd', pNewDate));
        StrPCopy(lDate, pNewDate);

        Res := EX_UPDATEAUDITDATE(lDate);
      Finally
        FreeMem(lDate);
      End;

      If Res <> 0 Then
        _LogMSG('_SetLastAuditDate :- Could not change last audit date. Error: '
          + inttostr(Res));

      Ex_CloseData;
      //EX_CLOSEDLL;
    End {If Res = 0 Then}
    Else
      _LogMSG('_SetLastAuditDate :- Could not init dll. Error: ' +
        inttostr(Res));
  End {If Res = 0 Then}
  Else
    _LogMSG('_SetLastAuditDate :- Could not init dll path. Error: ' +
      inttostr(Res) + ' Path: ' + pPath);
End;

{-----------------------------------------------------------------------------
  Procedure: _SetLastAuditDate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _SetLastAuditDate(Const pPath: String; pNewDate: TDateTime);
Begin
  _SetLastAuditDate(pPath, FormatDateTime('yyyymmdd', pNewDate));
End;

{-----------------------------------------------------------------------------
  Procedure: _CheckExDripFeed
  Author:    vmoura

  check if the specified company is in drip feed mode
-----------------------------------------------------------------------------}
Function _CheckExDripFeed(Const pPath: String): Boolean;
Var
  lDrip: TICEDripFeed;
Begin
  Result := False;
  lDrip := GetDripFeed;

  {check the object and the path}
  If Assigned(lDrip) Then
  Begin
    If (Trim(pPath) <> '') Then
    Begin
      lDrip.Datapath := IncludeTrailingPathDelimiter(pPath) + cICEFOLDER;
    {check the drip feed file}
      If _FileSize(lDrip.Datapath + DRIPFEED_FILE) > 0 Then
        If lDrip.Load Then
          Result := lDrip.IsActive;
      FreeAndNil(lDrip);
    End
    Else
      _LogMSG('_CheckExDripFeed :- Invalid path - ' + pPath);

  End; {If Assigned(lDrip) And (Trim(pCompanyPath) <> '') Then }
End;

{-----------------------------------------------------------------------------
  Procedure: _GetExPeriod
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _GetDripFeedPeriod(Const pPath: String; Out pPeriod1, pPeriod2:
  String);
Var
  lDrip: TICEDripFeed;
Begin
  pPeriod1 := '';
  pPeriod2 := '';
  lDrip := GetDripFeed;

  {check the object and the path}
  If Assigned(lDrip) And (Trim(pPath) <> '') Then
  Begin
    lDrip.Datapath := IncludeTrailingPathDelimiter(pPath) + cICEFOLDER;
    {check the drip feed file}

    If _FileSize(lDrip.Datapath + DRIPFEED_FILE) > 0 Then
      If lDrip.Load Then
        {if lDrip.IsValid then}
      Begin
        pPeriod1 := FormatFloat('00', lDrip.StartPeriod) + inttostr(1900 +
          lDrip.StartYear);
        pPeriod2 := FormatFloat('00', lDrip.EndPeriod) + inttostr(1900 +
          lDrip.EndYear);
      End;
    FreeAndNil(lDrip);
  End; {If Assigned(lDrip) And (Trim(pCompanyPath) <> '') Then }
End;

{-----------------------------------------------------------------------------
  Procedure: _RemoveDripFeed
  Author:    vmoura

  remove drip feed mode from the specified company
-----------------------------------------------------------------------------}
Function _RemoveDripFeed(Const pPath: String): Boolean;
Var
  lDrip: TICEDripFeed;
Begin
  Result := False;
  lDrip := GetDripFeed;

  If Assigned(lDrip) And (Trim(pPath) <> '') Then
  Begin
    lDrip.Datapath := IncludeTrailingPathDelimiter(pPath) + cICEFOLDER;
    With lDrip Do
    Begin
      Load;
      IsActive := False;
(*      StartYear := 0;
      StartPeriod := 0;
      EndYear := 0;
      EndPeriod := 0;*)

      Result := Save;
    End; { With lDrip Do}

    FreeAndNil(lDrip);
  End {If Assigned(lDrip) And (Trim(pCompanyPath) <> '') Then}
  Else
    _LogMSG('_RemoveDripFeed :- Invalid object or path - ' + pPath);
End;

{-----------------------------------------------------------------------------
  Procedure: _ApplyDripFeed
  Author:    vmoura
  20060823
-----------------------------------------------------------------------------}
Procedure _ApplyDripFeed(Const pPath: String);
Var
  lDrip: TICEDripFeed;
Begin
  lDrip := GetDripFeed;

  If Assigned(lDrip) Then
  Begin
    If (Trim(pPath) <> '') Then
    Begin
      lDrip.Datapath := IncludeTrailingPathDelimiter(pPath) + cICEFOLDER;
      With lDrip Do
      Begin
        Load;
        IsActive := True;
        Save;
      End; { With lDrip Do}
    End
    Else
      _LogMSG('_ApplyDripFeed :- Invalid path - ' + pPath);

    FreeAndNil(lDrip);
  End {If Assigned(lDrip) And (Trim(pCompanyPath) <> '') Then}
  Else
    _LogMSG('_ApplyDripFeed :- Invalid Dripfeed object!');
End;

{-----------------------------------------------------------------------------
  Procedure: _SetDripFeedPeriod
  Author:    vmoura

  set values to dipfeed.dat file
-----------------------------------------------------------------------------}
Procedure _SetDripFeedPeriod(Const pPath: String; pPeriod1, pYear1, pPeriod2,
  pYear2: Byte);
Var
  lDrip: TICEDripFeed;
Begin
  lDrip := GetDripFeed;

  If Assigned(lDrip) Then
  Begin
    If (Trim(pPath) <> '') Then
    Begin
      lDrip.Datapath := IncludeTrailingPathDelimiter(pPath) + cICEFOLDER;
      With lDrip Do
      Begin
        Load;
        StartPeriod := pPeriod1;
        // 1900 +- year
        StartYear := pYear1 - 1900;

        EndPeriod := pPeriod2;
        EndYear := pYear2 - 1900;

        Save;
      End; { With lDrip Do}
    End
    Else
      _LogMSG('_SetDripFeedPeriod :- Invalid path - ' + pPath);

    FreeAndNil(lDrip);
  End {If Assigned(lDrip) And (Trim(pCompanyPath) <> '') Then}
  Else
    _LogMSG('_SetDripFeedPeriod :- Invalid Dripfeed object!');
End;

{-----------------------------------------------------------------------------
  Procedure: _LocaliseExPath
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _LocaliseExPath(Const APath: String): String;
var
  lAux: String;
Begin
  lAux := APath;
  lAux := AnsiReplaceStr(Uppercase(lAux), Uppercase(glMappedDrive), Uppercase(glLocalPath));
  Try
    Result := WinGetShortPathName(lAux);
  except
  End;

  if Trim(Result) = '' then
    if FileExists(lAux) or DirectoryExists(lAux) then
      Result := lAux;
End;

{-----------------------------------------------------------------------------
  Procedure: _CheckExCompanyCount
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _CheckExCompanyCount: Boolean;
Const
  DLLCOMPName = 'ENTCOMP2.DLL';

Type
  TInitCompDllEx = Procedure(DataPath: ShortString);
  TTermCompDll = Procedure;
  TGetActualCompanyCount = Function: LongInt;
  TGetLicencedCompanyCount = Function: LongInt;

Var
  lDataPath, lDllPath: String;
  lIni: TInitCompDllEx;
  lTerm: TTermCompDll;
  lGetActual: TGetActualCompanyCount;
  lGetLicence: TGetLicencedCompanyCount;
  lHandle: THandle;
Begin

{
  Procedure InitCompDllEx (DataPath : ShortString);
  Procedure TermCompDll;
  Function GetActualCompanyCount : LongInt; StdCall; export;
  Function GetLicencedCompanyCount : LongInt; StdCall; export;

Call InitCompDllEx first to open the MCM Database, then use GetActualCompanyCount
to find out how many are in use, GetLicencedCompanyCount to find out how many
are licenced and then TermCompDll to shut it all down again.
}

  {check the datapath and the dll path}
  Result := False;
  lDataPath := IncludeTrailingPathDelimiter(_GetExDataPath);
  If _FileSize(lDataPath + 'COMPANY.DAT') = 0 Then
    lDatapath := IncludeTrailingPathDelimiter(_GetExPath);

  lDllPath := IncludeTrailingPathDelimiter(_GetExPath);
  If _FileSize(lDllPath + DLLCOMPName) = 0 Then
    lDllPath := lDataPath;

  lHandle := LoadLibrary(PCHAR(lDllPath + DLLCOMPName));
  If (lHandle > HInstance_Error) Then
  Try
    Try
      {loading functions}
      lIni := GetProcAddress(lHandle, 'InitCompDllEx');
      lTerm := GetProcAddress(lHandle, 'TermCompDll');
      lGetActual := GetProcAddress(lHandle, 'GetActualCompanyCount');
      lGetLicence := GetProcAddress(lHandle, 'GetLicencedCompanyCount');

    {open the MCM database}
      If Assigned(lIni) Then
      Begin
        lIni(lDataPath);
        {check the licence numbers}
        If Assigned(lGetActual) And Assigned(lGetLicence) Then
          Result := lGetActual < lGetLicence;

        If Assigned(lTerm) Then
          lTerm;
      End; {if Assigned(lIni) then}
    Except
      On e: exception Do
        _LogMSG('_CheckExCompanyCount :- Checking company licence. Error: ' +
          e.Message);
    End;
  Finally
    FreeLibrary(lHandle);
  End; { If (lHandle > HInstance_Error) }
End;

(*

procedure SetServiceDriveStrings;
var
  s : string;
  i, j : integer;
begin
  LocalPath := UpperCase(ExtractFilePath(ParamStr(0)));
  with FToolkit.Company do
  begin
    for i := 1 to cmCount do
    begin
      s := UpperCase(Trim(cmCompany[i].coPath));
      FMappedDrive := Copy(s, 1, 3);
      ServiceMappedDrive := FMappedDrive;
      s := Copy(s, 4, Length(s));
      j := Pos(s, LocalPath);
      if j > 0 then
      begin
        FLocalPath := IncludeTrailingBackslash(Copy(LocalPath, 1, j - 1));
        ServiceLocalDir := FLocalPath;
        Break;
      end;
    end;
  end;
end;
*)

Initialization
  DriveMapped := False;

End.

