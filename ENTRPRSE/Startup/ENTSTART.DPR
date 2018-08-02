program EntStart;

uses
  Classes,
//Dialogs,
  IniFiles,
  Registry,
  ShellAPI,
  SysUtils,
  Windows;

{$R *.res}

Type
  TPathInfo = Record
    paDirectory   : ShortString;
    paApplication : ShortString;
    paParams      : ShortString;
  End; // TPathInfo

Var
  StartupIni   : TIniFile;
  TrayAppsList : TStringList;
  IniFileName  : ShortString;
  WGEFileName  : ShortString;
  TrayFileName : ShortString;
  I            : SmallInt;

  //------------------------------

  // Calculates the drive + path for the local excheqr dir where EntStart.Ini will be
  function CalcExchLocal : ShortString;
  Begin { CalcExchLocal }
    Result := '';

    With TRegistry.Create Do
    Begin
      Try
        Access := Key_Read;
        RootKey := HKEY_LOCAL_MACHINE;

        If OpenKey ('SOFTWARE\Exchequer\Enterprise', False) Then
        Begin
          If ValueExists ('LocalDir') Then
          Begin
            Result := IncludeTrailingPathDelimiter(ReadString('LocalDir'));
          End; // If ValueExists ('LocalDir')
        End; // If OpenKey ('SOFTWARE\Exchequer\Enterprise')
      Finally
        Free;
      End; // Try..Finally
    End; // With TRegistry.Create
  End; { CalcExchLocal }

  //------------------------------

  Procedure Delay (Const DelayCode : ShortString; MilliDelay : LongInt);
  Begin // Delay
    // Check for an override of the default delay in the .INI file
    If StartupIni.ValueExists('Config', DelayCode) Then
    Begin
      MilliDelay := StartupIni.ReadInteger ('Config', DelayCode, MilliDelay);
    End; // If ValueExists('Config', 'WGEDelay')

    Sleep(MilliDelay);
  End; // Delay

  //------------------------------

  Function SplitPath (AppPath : ShortString) : TPathInfo;
  Var
    ExePos                        : SmallInt;
  Begin // SplitPath
    Result.paDirectory   := '';
    Result.paApplication := '';
    Result.paParams      := '';

    AppPath := UpperCase(Trim(AppPath));
    ExePos := Pos ('.EXE', AppPath);

    Result.paDirectory := ExtractFilePath(AppPath);
    Result.paApplication := Copy (AppPath, 1, ExePos + 3);
    If (Length(AppPath) > (ExePos + 5)) Then
    Begin
      Result.paParams := Copy (AppPath, ExePos + 5, Length(AppPath));
    End; // If (Length(AppPath) > (ExePos + 5))

//ShowMessage ('paDirectory: ' + Result.paDirectory + #13 +
//             'paApplication: ' + Result.paApplication + #13 +
//             'paParams: ' + Result.paParams);
  End; // SplitPath

  //------------------------------

  Procedure Execute (Const AppPath : ShortString);
  Var
    lpFile, lpParams, lpDirectory : ANSIString;
  Begin // Execute
    With SplitPath (AppPath) Do
    Begin
      lpFile := paApplication;
      lpParams := paParams;
      lpDirectory := paDirectory;
    End; // With SplitPath (AppPath)

//ShowMessage ('lpDirectory: ' + lpDirectory + #13 +
//             'lpFile: ' + lpFile + #13 +
//             'lpParams: ' + lpParams);

    ShellExecute (0,                  // handle to parent window
                  'open',             // pointer to string that specifies operation to perform
                  PCHAR(lpFile),      // pointer to filename or folder name string
                  PCHAR(lpParams),    // pointer to string that specifies executable-file parameters
                  PCHAR(lpDirectory), // pointer to string that specifies default directory
                  SW_ShowNormal);     // whether file is shown when opened
  End; // Execute

  //------------------------------

begin
  //Application.Initialize;
  //Application.Title := 'Exchequer Enterprise Workgroup Startup Utility';
  //Application.Run;

  // Config details are stored in an INI format file of the same name in the
  // same directory
  IniFileName := CalcExchLocal;
  If (Trim(IniFileName) <> '') And DirectoryExists(IniFileName) Then
  Begin
    IniFileName := IniFileName + 'EntStart.Ini';

    If FileExists (IniFileName) Then
    Begin
      StartupIni := TIniFile.Create(IniFileName);
      Try
        // Look for path of Workgroup Engine and execute it
        If StartupIni.ValueExists('Workgroup', 'Path') Then
        Begin
          WGEFileName := StartupIni.ReadString('Workgroup', 'Path', '');
          If FileExists (SplitPath(WGEFileName).paApplication) Then
          Begin
            // Execute the Workgroup Engine and pause to let it load
            Execute (WGEFileName);
            Delay ('WGEDelay', 3000);

            // Load the TrayApps section and execute the specified apps at 1 second intervals
            If StartupIni.SectionExists('TrayApps') Then
            Begin
              TrayAppsList := TStringList.Create;
              Try
                StartupIni.ReadSectionValues ('TrayApps', TrayAppsList);

                If (TrayAppsList.Count > 0) Then
                Begin
                  For I := 0 To Pred(TrayAppsList.Count) Do
                  Begin
                    If (I > 0) Then
                    Begin
                      // Leave small delay between executing each Tray App
                      Delay ('TrayDelay', 1000);
                    End; // If (I > 0)

                    // Extract the app details and execute it
                    TrayFileName := TrayAppsList.Values[TrayAppsList.Names[I]];
                    If FileExists (SplitPath(TrayFileName).paApplication) Then
                    Begin
                      Execute (TrayFileName);
                    End; // If FileExists (SplitPath(TrayFileName).paApplication)
                  End; // For I
                End; // If (TrayAppsList.Count > 0)
              Finally
                FreeAndNIL(TrayAppsList);
              End; // Try..Finally
            End; // If StartupIni.SectionExists('TrayApps')
          End; // If FileExists (WGEFileName)
        End; // If StartupIni.ValueExists('Workgroup', 'Path')
      Finally
        FreeAndNIL(StartupIni);
      End; // Try..Finally
    End; // If FileExists (IniFileName) 
  End; // If (Trim(IniFileName) <> '') And DirectoryExists(IniFileName) 
end.
