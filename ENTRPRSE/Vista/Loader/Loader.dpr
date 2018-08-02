program Loader;

uses
  Windows,
  ShellAPI, ShFolder,
  SysUtils;

{$R *.res}
{$R loader.exe.RES}

// NOTE: Deliberately written to be minimalistic in size

//-------------------------------------------------------------------------

Procedure MessageBox(Const Text : ANSIString);
Begin // MessageBox
  Windows.MessageBox (0, PCHAR(Text), 'Error', MB_OK Or MB_ICONSTOP Or MB_APPLMODAL);
End; // MessageBox

//-------------------------------------------------------------------------

Function IsWindowsVista : Boolean;
Var
  OSVerIRec : TOSVersionInfo;
Begin // IsWindowsVista
  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);
  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);
  GetVersionEx(OSVerIRec);
  Result := (OSVerIRec.dwPlatformId = VER_PLATFORM_WIN32_NT) And (OSVerIRec.dwMajorVersion = 6);
End; // IsWindowsVista

//-------------------------------------------------------------------------

// Returns the path in the File Virtualistation store for specified file
Function VirtualStorePath (Const Filename : ANSIString) : ANSIString;
Const
  SHGFP_TYPE_CURRENT = 0;
Var
  Path : Array[0..Max_Path] Of Char;
Begin // VirtualStorePath
  // Get Local Application Data path from the shell
  FillChar(Path, SizeOf(Path), #0);
  SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, Path);
  Result := IncludeTrailingPathDelimiter(Path);

  // Append the path of the file as well
  Result := Result + 'VirtualStore\' + Copy(Filename, 4, Length(Filename));
End; // VirtualStorePath

//-------------------------------------------------------------------------

// Returns the command line of the app to run to elevate the process
Function ElevationCommandLine : ShortString;
Begin // ElevationCommandLine
  Result := ChangeFileExt(ParamStr(0), 'V.Exe');
End; // ElevationCommandLine

//-------------------------------------------------------------------------

// Returns the name of the final app to run
Function FinalName : ShortString;
Begin // FinalName
  Result := ChangeFileExt(ParamStr(0), 'X.Exe');
End; // FinalName

//-------------------------------------------------------------------------

Procedure RunApp(AppPath, Params: AnsiString);
var
  cmdFile, cmdPath, cmdParams : ANSIString;
  Res, I                      : LongInt;
begin
  cmdFile := AppPath;
  cmdPath := ExtractFilePath(AppPath);

  cmdParams := '';
  If (ParamCount > 0) Then
    For I := 1 To ParamCount Do
    Begin
      cmdParams := CmdParams + ParamStr(I) + ' ';
    End; // For I
  cmdParams := cmdParams + '/Path:"' + Params + '" /VirtualStore:"' + VirtualStorePath(cmdPath) + '"';

  If FindCmdLineSwitch('Debug', ['/', '-'], True) Then
    MessageBox ('Loader File=' + cmdFile + ', Path=' + cmdPath + ', Params=' + cmdParams + ')');

  // NOTE: This cannot use WinExec as WinExec doesn't support elevation
  Res := ShellExecute (0, NIL, PCHAR(cmdFile), PCHAR(cmdParams), PCHAR(cmdPath), SW_SHOWNORMAL);
end;

//-------------------------------------------------------------------------

begin
  If IsWindowsVista Then
    // Vista
    RunApp (ElevationCommandLine, ExtractFilePath(ParamStr(0)))
  Else
    // Don't care - just run the app
    RunApp (FinalName, '');
end.
