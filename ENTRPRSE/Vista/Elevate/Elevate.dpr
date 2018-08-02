program Elevate;

uses
  ComObj,
  ShlObj,
  SysUtils,
  Windows;

{$R *.res}
{$R Elevate.exe.RES}

Var
  sPath, sOutParams : ANSIString;
  bDebug : Boolean;

//-------------------------------------------------------------------------

Procedure MessageBox(Const Text : ANSIString);
Begin // MessageBox
  Windows.MessageBox (0, PCHAR(Text), 'Error', MB_OK Or MB_ICONSTOP Or MB_APPLMODAL);
End; // MessageBox

//-------------------------------------------------------------------------

// MH 08/05/2013 v7.0.4 ABSEXCH-13350: Added support for Windows 8
Function IsWindows8 : Boolean;
Var
  OSVerIRec : TOSVersionInfo;
Begin // IsWindows8
  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);
  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);
  GetVersionEx(OSVerIRec);
  Result := (OSVerIRec.dwPlatformId = VER_PLATFORM_WIN32_NT)
            And
            (
              // v6.2 or later
              ((OSVerIRec.dwMajorVersion = 6) And (OSVerIRec.dwMinorVersion >= 2))
              Or
              (OSVerIRec.dwMajorVersion > 6)
            );

If bDebug Then
  MessageBox ('IsWindows8: ' + IntToStr(Ord(Result)));
End; // IsWindows8

//-------------------------------------------------------------------------

Procedure RunApp (Const AppPath : ShortString);
var
  zAppName:array[0..512] of char;
  zCurDir:array[0..255] of char;
  WorkDir: String;
  Proc: PROCESS_INFORMATION;
  start: STARTUPINFO;
Begin // RunApp
  StrPCopy(zAppName,AppPath);
  GetDir(0,WorkDir);
  StrPCopy(zCurDir,WorkDir);
  FillChar(Start,Sizeof(StartupInfo),#0);
  Start.cb := Sizeof(StartupInfo);
  Start.dwFlags := STARTF_USESHOWWINDOW;
  Start.wShowWindow := 1;
  CreateProcess (nil,
                 zAppName,                      { pointer to command line string }
                 nil,                           { pointer to process security attributes }
                 nil,                           { pointer to thread security attributes }
                 false,                         { handle inheritance flag }
                 CREATE_NEW_CONSOLE or          { creation flags }
                 NORMAL_PRIORITY_CLASS,
                 nil,                           { pointer to new environment block }
                 nil,                           { pointer to current directory name }
                 Start,                         { pointer to STARTUPINFO }
                 Proc);
End; // RunApp

//-------------------------------------------------------------------------

Procedure ReconnectDrive;
Var
  P: PWideChar;
  Flags, NumChars, HR: LongWord;
  NewPIDL: PItemIDList;
  SF: IShellFolder;
  EnumList: IEnumIDList;

  function DesktopShellFolder: IShellFolder;
  begin
    OleCheck(SHGetDesktopFolder(Result));
  end;

Begin // ReconnectDrive
  Flags := 0;

  NumChars := 3;
  P := StringToOleStr(ExtractFileDrive(sPath));

  HR := DesktopShellFolder.ParseDisplayName(0, nil, P, NumChars, NewPIDL, Flags);
  if HR = S_OK then
  Begin
    // Get IShellFolder object
    HR := DesktopShellFolder.BindToObject(NewPIDL, nil, IID_IShellFolder, Pointer(SF));
    if HR = S_OK then
    Begin
      HR := SF.EnumObjects(0, (SHCONTF_FOLDERS Or SHCONTF_NONFOLDERS Or SHCONTF_INCLUDEHIDDEN), EnumList);
      if HR = S_OK then
      Begin

      End // if HR = S_OK
      Else
        MessageBox(ExtractFileName(ParamStr(0)) + ': EnumObjects Error ' + IntToStr(HR));
    End // if HR = S_OK
    Else
      MessageBox(ExtractFileName(ParamStr(0)) + ': DesktopShellFolder.BindToObject Error ' + IntToStr(HR));
  End // if HR = S_OK
  Else
    MessageBox(ExtractFileName(ParamStr(0)) + ': DesktopShellFolder.ParseDisplayName Error ' + IntToStr(HR));
End; // ReconnectDrive


//-------------------------------------------------------------------------

// MH 08/05/2013 v7.0.4 ABSEXCH-13350: Added support for Windows 8
Procedure ReconnectDrive_Win8;
Var
  sDrive, sUNCPath : ShortString;
  iPos : Integer;

  //------------------------------

  function ConnectDrive(_drvLetter: string; _netPath: string; _showError: Boolean; _reconnect: Boolean): DWORD;
  var
    nRes: TNetResource;
    errCode: DWORD;
    dwFlags: DWORD;
  Begin // ConnectDrive
    If bDebug Then
      MessageBox('ConnectDrive(_drvLetter=' + _drvLetter + ', _netPath= ' + _netPath + ')');

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
    if (errCode <> NO_ERROR) and (_showError) then
    begin
      MessageBox('An error occured while connecting:' + #13#10 + SysErrorMessage(GetLastError));
    end;
    Result := errCode; { NO_ERROR }
  End; // ConnectDrive

  //------------------------------

Begin // ReconnectDrive_Win8
  If bDebug Then
    MessageBox('ReconnectDrive_Win8 (Application.ExeName=' + ParamStr(0) + ', sPath=' + sPath + ')');

  // Copy drive from start of sPath e.g. X:\ExchW8.SQL\
  sDrive := Copy(sPath, 1, 2);

  // Determine path from path of current .exe,
  //
  //   e.g. \\BMTDev1\MHigginson\ExchW8.SQL\EntREgV.Exe
  //
  // Correct UNC path would be \\BMTDev1\MHigginson
  //
  sUNCPath := ParamStr(0);
  // look for directory part of path and delete everything from that point to get the base UNC drive
  iPos := Pos(Copy(sPath, 3, 255), sUNCPath);
  If (Length(sPath) > 3) And (iPos > 0) Then
    Delete(sUNCPath, iPos, 255)
  Else
  Begin
    // Path not found - remove .EXE off end as we may be running in the root
    sUNCPath := ExtractFilePath(sUNCPath);

    If (sUNCPath[Length(sUNCPath)] = '\') Then
      Delete(sUNCPath, Length(sUNCPath), 1);
  End; // Else

  If bDebug Then
    MessageBox('ReconnectDrive_Win8 (Drive=' + sDrive + ', UNCPath=' + sUNCPath + ')');

  ConnectDrive(sDrive, sUNCPath, True, False);
End; // ReconnectDrive_Win8

//-------------------------------------------------------------------------

Procedure RunApplication;
Var
  AppPath : ANSIString;
Begin // RunApplication
  // Build path based on the Drive\Dir path passed in as parameter 1 and the name of this .EXE
  AppPath := IncludeTrailingPathDelimiter(sPath) + ExtractFileName(ParamStr(0));

  // Modify the name of the .EXE to run the next .EXE in the chain
  AppPath := StringReplace(AppPath, 'V.Exe', 'X.Exe', [rfIgnoreCase, rfReplaceAll]);

  // Append any additional parameters
  AppPath := AppPath + ' ' + Trim(sOutParams);

If bDebug Then MessageBox('Elevate (Path='+AppPath +')');
  RunApp (AppPath);
End; // RunApplication

//-------------------------------------------------------------------------

Procedure CheckParams;
Var
  sParam : ShortString;
  sVirtualStore : ShortString;
  I : SmallInt;
Begin // CheckParams
  bDebug := False;
  sOutParams := '';
  sPath := '';

  If (ParamCount > 1) Then
  Begin
    For I := 1 To ParamCount Do
    Begin
      sParam := ParamStr(I);

      If (Pos('DEBUG', UpperCase(sParam)) = 2) Then
      Begin
        bDebug := True;
        sOutParams := sOutParams + sParam + ' ';
      End // If (Pos('DEBUG', UpperCase(sParam)) = 2)
      Else If (Pos('/PATH:', UpperCase(sParam)) = 1) Then
      Begin
        sPath := Copy (sParam, 7, Length(sParam));
        sOutParams := sOutParams + '/Path:"' + sParam + '" ';
      End // If (Pos('/PATH:', UpperCase(sParam)) = 1)
      Else If (Pos('/VIRTUALSTORE:', UpperCase(sParam)) = 1) Then
      Begin
        sVirtualStore := Copy (sParam, 15, Length(sParam));
        sOutParams := sOutParams + '/VirtualStore:"' + sVirtualStore + '" ';
      End // If (Pos('/VIRTUALSTORE:', UpperCase(sParam)) = 1)
      Else
        sOutParams := sOutParams + sParam + ' ';
    End; // For I
  End; // If (ParamCount > 1)
End; // CheckParams

//-------------------------------------------------------------------------

begin
  // Example incoming command line:-  (scroll across as it is long!)
  //
  //  "C:\Users\Obi Wan Kenobi\AppData\Roaming\Exch600.2\entregV.Exe" -debug /Path:"C:\Users\Obi Wan Kenobi\AppData\Roaming\Exch600.2\" /VirtualStore:"C:\Users\Obi Wan Kenobi\AppData\Local\VirtualStore\Users\Obi Wan Kenobi\AppData\Roaming\Exch600.2\"
  //
  // ParamStr:-
  //
  //   1: -debug
  //   2: /Path:C:\Users\Obi Wan Kenobi\AppData\Roaming\Exch600.2\
  //   3: /VirtualStore:C:\Users\Obi Wan Kenobi\AppData\Local\VirtualStore\Users\Obi Wan Kenobi\AppData\Roaming\Exch600.2\
  //

  CheckParams;

  If (sPath <> '') Then
  Begin
    // Check whether directory exists
    If (Not DirectoryExists(sPath)) Then
    Begin
      // Bugger
      // MH 08/05/2013 v7.0.4 ABSEXCH-13350: Added support for Windows 8
      If IsWindows8 Then
        // In Windows 8 the mapped drives do not appear to be present unless they were previously
        // mapped during the session in something running as Administrator, whether that is a DOS
        // box with Net Use or another application.  So we need to actually map the drive rather
        // than just cause an existing drive to reconnect like we do on Vista/Win7 
        ReconnectDrive_Win8
      Else
        // Windows Vista / 7
      ReconnectDrive;

      If (Not DirectoryExists(ExtractFilePath(sPath))) Then
        MessageBox(ExtractFileName(ParamStr(0)) + ': Unable to see mapped drive, please contact your technical support')
      Else
        RunApplication;
    End // If (Not DirectoryExists(sPath))
    Else
      // AOK - go for it
      RunApplication;
  End // If (ParamStr(1) <> '')
  Else
    MessageBox(ExtractFileName(ParamStr(0)) + ': Invalid Path, please contact your technical support');
end.
