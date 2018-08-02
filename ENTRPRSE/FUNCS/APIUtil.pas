///////////////////////////////////////
// Wrapper Unit for common API calls //
///////////////////////////////////////
unit APIUtil;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  OLE2,
  Dialogs, Windows, Forms, Classes;

type
  TWindowsVersion = (wv31, wv95, wv98, wvME, wvNT3, wvNT4, wvNT4TerminalServer, wv2000,
                     wv2000TerminalServer, wvXP, wvXPTerminalServer, wvNTOther, wvUnknown,
                     wv2003Server, wv2003TerminalServer, wvVista,
                     // MH 08/05/2013 v7.0.4 ABSEXCH-12022: Added support for Windows 7, Windows 8 and Windows Server 2012
                     wvWindows7, wvWindowsServer2008R2, wvWindows8, wvWindowsServer2012,
                     // MH 01/09/2015 2015-R1 ABSEXCH-16810: Addes support for Windows 8.1 and 10
                     wvWindows81, wvWindows10);

  function msgbox(scaption: string; etype: TMsgDlgType; sButtons: TMsgDlgButtons;
  eDefault: TmsgDlgBtn; stitle: string): byte;
  function WinGetUserName : Ansistring;
  function WinGetUserNameEx(iFormat : Byte) : Ansistring;
  function WinGetComputerName : Ansistring;
  function WinGetWindowsDir : Ansistring;
  function IsAppAlreadyRunning(sAppName : string) : boolean;
  function RunApp(AppPath: AnsiString; bWait : boolean; ShowWindow: Integer = 1) : THandle;
  function GetWindowsVersion : TWindowsVersion; overload;
  function GetWindowsVersion(var iServicePack : integer) : TWindowsVersion; overload;
  function GetWindowsVersionString : string;
  function WinGetWindowsSystemDir : Ansistring;
  Procedure RunFile(sFileName : string; sParams : string = '');
  function WinGetWindowsTempDir : Ansistring;
  function WinGetShortPathName(LongName : AnsiString) : Ansistring;
  function GetFileType(sFilename : string) : string;
  function IsWow64: Boolean;
  function KillTask(ExeFileName: string; CloseCleanly : Boolean = True): Boolean;
  function TaskIsRunning(ExeFileName: string): Boolean;
  function RunAppEx(AppPath: AnsiString; bWait : boolean; ShowWindow: Integer = 1) : PROCESS_INFORMATION;
  procedure Wait(dwMilliseconds: Longint);
  function GetShareNameFromPath(const APath : string) : string;

  function GetFileVersion(sFileName : AnsiString): string;
  function EntGetModuleFileName : string;

  // Deletes a directory and all subdirectories, optionally deletes to Recycle Bin or displays
  // progress / confirmation dialogs
  Function DeleteDirectory (Const ItemName: string;
                            Const DeleteToRecycle : Boolean=False;
                            Const ShowConfirm : Boolean= False;
                            Const TotalSilence : Boolean=True): Boolean;


const
  // This set appears to be used to suppress Eduardo's weirdo UI mods
  wvXPStyle = [wvXP, wvXPTerminalServer, wvVista,
               // MH 08/05/2013 v7.0.4 ABSEXCH-12022: Added support for Windows 7, Windows 8 and Windows Server 2012
               wvWindows7, wvWindowsServer2008R2, wvWindows8, wvWindowsServer2012,
               // MH 01/09/2015 2015-R1 ABSEXCH-16810: Addes support for Windows 8.1 and 10
               wvWindows81, wvWindows10];

  wvNTVersions = [wvNT3, wvNT4, wvNT4TerminalServer, wv2000, wv2000TerminalServer,
                  wvXP, wvXPTerminalServer, wvNTOther, wv2003Server, wv2003TerminalServer, wvVista,
                  // MH 08/05/2013 v7.0.4 ABSEXCH-12022: Added support for Windows 7, Windows 8 and Windows Server 2012
                  wvWindows7, wvWindowsServer2008R2, wvWindows8, wvWindowsServer2012,
                  // MH 01/09/2015 2015-R1 ABSEXCH-16810: Addes support for Windows 8.1 and 10
                  wvWindows81, wvWindows10];

  wv95Versions = [wv95, wv98, wvME];

  wvTSVersions = [wvNT4TerminalServer, wv2000TerminalServer, wvXPTerminalServer, wv2003TerminalServer];


  // Note that this DLL is only available from Win 2K onmwards
  // This means that from version 6, we will not support win 95/98/me etc.
  procedure GetUserNameEx(NameFormat: DWORD; lpNameBuffer: LPSTR; nSize: PULONG); stdcall;
  external 'secur32.dll' Name 'GetUserNameExA';



implementation
uses
  ShellAPI, Controls, SysUtils, Registry, tlHelp32, Messages, RegistryEx;


// MH 08/05/2013 v7.0.4 ABSEXCH-12022: Added external for extended version of GetVersionEx as
//                                     we need the ProductType in order to distinguish between
//                                     Server and Workstation versions as MS is duplicating the
//                                     version numbers now
const
  VER_NT_WORKSTATION    :Integer = 1;
  VER_NT_SERVER         :Integer = 3;

type
  _OSVERSIONINFOEX = record
    dwOSVersionInfoSize : DWORD;
    dwMajorVersion      : DWORD;
    dwMinorVersion      : DWORD;
    dwBuildNumber       : DWORD;
    dwPlatformId        : DWORD;
    szCSDVersion        : array[0..127] of AnsiChar;
    wServicePackMajor   : WORD;
    wServicePackMinor   : WORD;
    wSuiteMask          : WORD;
    wProductType        : BYTE;
    wReserved           : BYTE;
  end;
  TOSVERSIONINFOEX = _OSVERSIONINFOEX;

  function GetVersionExtended(var lpVersionInformationEx: TOSVERSIONINFOEX): BOOL; stdcall; overload; external kernel32 name 'GetVersionExA';



function msgbox(scaption: string; etype: TMsgDlgType; sButtons: TMsgDlgButtons;
eDefault: TmsgDlgBtn; stitle: string): byte;
// Replacement for delphi's MsgDlg.
// Allows you to additionally specify a default button, and a caption for the window
var
  msgType: word;
  msgCaption, msgTitle: AnsiString;
  BeepType: integer;
  OldCursor : TCursor;

  procedure ErrorinMsgBox;
  begin
    msgBox('The combination of buttons passed to this procedure are incorrect, please check the code',
    mtError, [mbOK], mbOK, 'Error in MsgBox');
  end;

begin
  OldCursor := screen.cursor;
  screen.cursor := crDefault;
  msgType := 8192;
  BeepType := -1;
  {Set Type of message}
  case etype of
    mtinformation: begin
      msgType := msgType + 64;
      BeepType := 64;
    end;

    mtWarning: begin
      msgType := msgType + 48;
      BeepType := 64;
    end;

    mtError: begin
      msgType := msgType + 16;
      BeepType := 16;
    end;

    mtconfirmation: begin
      msgType := msgType + 32;
      BeepType := 32;
    end;
  end;{case}

  {Get which buttons are in set, and if more than one button is selected then set the default button}
  if ((mbYes in sButtons) and (mbNo in sButtons) and (mbCancel in sButtons)) then begin
    msgType := msgType + 3;
    case eDefault of
      mbNo: msgType := msgType + 256;
      mbCancel: msgType := msgType + 512;
    end;{case}
  end
  else if ((mbYes in sButtons) and (mbNo in sButtons)) then begin
    msgType := msgType + 4;
    if eDefault = mbNo then msgType := msgType + 256;
  end
  else if ((mbOK in sButtons) and (mbCancel in sButtons)) then begin
    msgType := msgType + 1;
    if eDefault = mbCancel then msgType := msgType + 256;
  end
  else if (mbOK in sButtons) then begin
    msgType := msgType + 0;
  end
  else if ((mbAbort in sButtons) and (mbRetry in sButtons) and
  (mbCancel in sButtons)) then begin
    msgType := msgType + 2;
    case eDefault of
      mbRetry: msgType := msgType + 256;
      mbCancel: msgType := msgType + 512;
    end;{case}
  end
  else if ((mbRetry in sButtons) and (mbCancel in sButtons)) then begin
    msgType := msgType + 5;
    if eDefault = mbCancel then msgType := msgType + 256;
  end
  else begin
    ErrorInMsgbox;
    msgbox := 0;
    exit;
  end;
  msgCaption := sCaption;
  msgTitle := sTitle;
  MessageBeep(BeepType);
  msgbox := messagebox(0, PChar(msgCaption), PChar(msgTitle), msgType);
  screen.cursor := OldCursor;
end;

function WinGetUserName : Ansistring;
// Wraps the Windows API call : GetUserName
// Gets the name of the currently logged in user
var
  lpBuffer : Array [0..255] of Char;
  nSize : DWORD;

  function TrimExUserName(sUserName : ANSIstring) : ANSIstring;
  var
    iPos : integer;
    bInText : boolean;
  begin{TrimExUserName}
    bInText := FALSE;
    Result := '';
    For iPos := Length(sUserName) downto 0 do
    begin
      if sUserName[iPos] in ['\', '/'] then
      begin
        if bInText then Break;
      end else
      begin
        bInText := TRUE;
        Result := sUserName[iPos] + Result;
      end;{if}
    end;{for}
  end;{TrimExUserName}

begin
  // MH 08/05/2013 v7.0.4 ABSEXCH-12022: Added support for Windows 7, Windows 8 and Windows Server 2012,
  //                                     this check should be more future proof
  //if GetWindowsVersion in [wvVista] then
  if (GetWindowsVersion >= wvVista) then
  begin
    Result := TrimExUserName(WinGetUserNameEx(2));
  end else
  begin
    nSize := SizeOf(lpBuffer) - 1;
    if GetUserName(lpBuffer, nSize) then Result := lpBuffer
    else Result := 'User';
  end;{if}
end;

(*
function WinGetUserName : Ansistring;
// Wraps the Windows API call : GetUserName
// Gets the name of the currently logged in user
var
  szBuffer: PChar;
  iSize: DWORD;
begin
  Result := 'User';
  szBuffer := nil;
  // get the necessary size of the buffer.
  // set "iSize" to small, so the function fails and returns the size.
  iSize := 0;
  GetUserName(szBuffer, iSize);
  // allocate the memory, the #0 is included in "iSize"
  szBuffer := StrAlloc(iSize);
  try
    // call the function again
    GetUserName(szBuffer, iSize);
    Result := szBuffer;
  finally // free the memory
    StrDispose(szBuffer);
  end;
end;


function WinGetUserName : Ansistring;
const
  cnMaxUserNameLen = 254;
var
  sUserName     : string;
  dwUserNameLen : DWord;
begin
  dwUserNameLen := cnMaxUserNameLen-1;
  SetLength( sUserName, cnMaxUserNameLen );
  GetUserName(
    PChar( sUserName ),
    dwUserNameLen );
  SetLength( sUserName, dwUserNameLen );
  Result := sUserName;
end;


function WinGetUserNameEx(iFormat : Byte) : Ansistring;
// Wraps the Windows API call : GetUserName
// Gets the name of the currently logged in user
var
//  GetUserNameEx : function (NameFormat: DWORD; lpNameBuffer: LPSTR; nSize: PULONG) : BOOLEAN; stdcall;
  GetUserNameEx : procedure (NameFormat: DWORD; lpNameBuffer: LPSTR; nSize: PULONG); stdcall;
  hSecur32DLL : THandle;
  UserName: array[0..250] of char;
  Size: DWORD;
  asSecur32DLLPath : ANSIString;
begin
  if GetWindowsVersion in [wv31, wv95, wv98, wvME, wvNT3, wvNT4, wvNT4TerminalServer] then
  begin
    Result := 'User';
  end else
  begin
    asSecur32DLLPath := IncludeTrailingPathDelimiter(WinGetWindowsDir) + 'System32\Secur32.dll';
    hSecur32DLL := LoadLibrary(PChar(asSecur32DLLPath));

    if hSecur32DLL > HInstance_Error then GetUserNameEx := GetProcAddress(hSecur32DLL, 'GetUserNameExA');
    if Assigned(GetUserNameEx) then
    begin
      Size := 250;
      {if }GetUserNameEx(iFormat, @UserName, @Size);
      {then }Result := UserName;
//      else Result := 'User';
    end;{if}
    FreeLibrary(hSecur32DLL);
  end;{if}
end;
*)

function WinGetUserNameEx(iFormat : Byte) : Ansistring;
// Wraps the Windows API call : GetUserName
// Gets the name of the currently logged in user
var
  UserName: array[0..250] of char;
  Size: DWORD;
begin
  if GetWindowsVersion in [wv31, wv95, wv98, wvME, wvNT3, wvNT4, wvNT4TerminalServer] then
  begin
    Result := 'User'
  end else
  begin
    Size := 250;
    GetUserNameEx(iFormat, @UserName, @Size);
    Result := UserName;
  end;{if}
end;


function WinGetComputerName : Ansistring;
// Wraps the Windows API call : GetComputerName
// Gets the name of the computer the program is being run on.
var
  lpBuffer : Array [0..255] of Char;
  nSize : DWORD;
begin
  nSize := SizeOf(lpBuffer) - 1;
  if GetComputerName(lpBuffer, nSize) then Result := lpBuffer
  else Result := 'Computer';
end;

function WinGetWindowsDir : Ansistring;
// Wraps the Windows API call : GetWindowsDir
// Gets the Current Windows Directory
var
//  lpBuffer : Array [0..255] of Char;
//  nSize : uint;
  TempStr : ANSIString;
begin
// MH 21/02/07: Modified as under Windows 2003 with Terminal Services installed this gives us
// the users profile\windows directory instead of the proper windows directory
//  nSize := SizeOf(lpBuffer) - 1;
//  GetWindowsDirectory(lpBuffer, nSize);
//  Result := lpBuffer;
//  Result := IncludeTrailingPathDelimiter(Result);

  // The System Directory function still appears to work correctly so we will use that instead
  // and strip off the System\System32 section.
  TempStr := WinGetWindowsSystemDir;
  Delete(TempStr, Pos('SYSTEM', UpperCase(TempStr)), Length(TempStr));
  Result := TempStr;
end;

function WinGetWindowsSystemDir : Ansistring;
// Wraps the Windows API call : GetSystemDir
// Gets the Current Windows\System Directory
var
  lpBuffer : Array [0..255] of Char;
  nSize : uint;
begin
  nSize := SizeOf(lpBuffer) - 1;
  GetSystemDirectory(lpBuffer, nSize);
  Result := lpBuffer;
  Result := IncludeTrailingPathDelimiter(Result);
end;

function IsAppAlreadyRunning(sAppName : string) : boolean;
// Function to work out whether the application is already running
// It creates a semaphore in memory to store this.
// Call this function on startup of your application if it returns false, you can run your application.
//
// sAppName : this must be a unique string for each application.
var
  hSem : THandle;
  semNm : Array[0..256] of Char;
begin
  IsAppAlreadyRunning := False;
  StrPCopy(semNm, 'Exchequer.ApplicationRunning.' + sAppName);

  {Create a Semaphore in memory - If this is the first instance, then it should be 0.}
  hSem := CreateSemaphore(nil, 0, 1, semNm);

  {Now, check to see if the semaphore exists}
  if ((hSem <> 0) and (GetLastError() = ERROR_ALREADY_EXISTS)) then begin
    CloseHandle(hSem);
    IsAppAlreadyRunning := True;{it Does}
  end;{if}
end;

function RunApp(AppPath: AnsiString; bWait : boolean; ShowWindow: Integer) : THandle;
// Wraps the Windows API call : CreateProcess
// This will run the given application and dependant on the flag, wait until it has finished executing
//
// AppPath : The full path of the exe required to run.
// bWait : whether to wait until the exe has finished running, before passing back control.
var
  zAppName:array[0..512] of char;
  zCurDir:array[0..255] of char;
  WorkDir: String;
  Proc: PROCESS_INFORMATION;
  start: STARTUPINFO;
  Ret2: Cardinal;
  Ret: Boolean;
begin
  StrPCopy(zAppName,AppPath);
  GetDir(0,WorkDir);
  StrPCopy(zCurDir,WorkDir);
  FillChar(Start,Sizeof(StartupInfo),#0);
  Start.cb := Sizeof(StartupInfo);
  Start.dwFlags := STARTF_USESHOWWINDOW;
  Start.wShowWindow := ShowWindow;
  Ret := CreateProcess (nil,
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

  if Ret then
    begin
      Result := Proc.hProcess;
      if bWait then begin
        Ret2 := WaitforSingleObject(Proc.hProcess,INFINITE);
        GetExitCodeProcess(Proc.hProcess,Ret2);
      end;{if}
    end
  else Result := 0;
end;

//PR: 02/03/2011 Added extra function to allow return of all Process_Information structure
function RunAppEx(AppPath: AnsiString; bWait : boolean; ShowWindow: Integer = 1) : PROCESS_INFORMATION;
// Wraps the Windows API call : CreateProcess
// This will run the given application and dependant on the flag, wait until it has finished executing
//
// AppPath : The full path of the exe required to run.
// bWait : whether to wait until the exe has finished running, before passing back control.
var
  zAppName:array[0..512] of char;
  zCurDir:array[0..255] of char;
  WorkDir: String;
  start: STARTUPINFO;
  Ret2: Cardinal;
  Ret: Boolean;
begin
  StrPCopy(zAppName,AppPath);
  GetDir(0,WorkDir);
  StrPCopy(zCurDir,WorkDir);
  FillChar(Start,Sizeof(StartupInfo),#0);
  Start.cb := Sizeof(StartupInfo);
  Start.dwFlags := STARTF_USESHOWWINDOW;
  Start.wShowWindow := ShowWindow;
  Ret := CreateProcess (nil,
                        zAppName,                      { pointer to command line string }
                        nil,                           { pointer to process security attributes }
                        nil,                           { pointer to thread security attributes }
                        false,                         { handle inheritance flag }
                        CREATE_NEW_CONSOLE or          { creation flags }
                        NORMAL_PRIORITY_CLASS,
                        nil,                           { pointer to new environment block }
                        nil,                           { pointer to current directory name }
                        Start,                         { pointer to STARTUPINFO }
                        Result);

  if Ret then
    begin
      if bWait then begin
        Ret2 := WaitforSingleObject(Result.hProcess,INFINITE);
        GetExitCodeProcess(Result.hProcess,Ret2);
      end;{if}
      //We don't need these handles, so should close them to allow the agent to terminate completely
      CloseHandle(Result.hProcess);
      CloseHandle(Result.hThread);
    end
  else FillChar(Result, SizeOf(Result), 0);
end;

function GetWindowsVersion(var iServicePack : integer) : TWindowsVersion; overload;
// Wraps the Windows API call : GetVersionEx
// Returns the version of Windows that you are running
// NOTE: When this function is updated for new windows versions, GetWindowsVersionString below should also be updated.
var
  OSVerIRec : TOSVersionInfoEx;
  //OSVerIRec : TOSVersionInfo;
  sServicePack, sCurrentVersion : string;
  oRegistry : TRegistry;
begin
  Result := wvUnknown;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);
  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);

  // MH 08/05/2013 v7.0.4 ABSEXCH-12022: Added external for extended version of GetVersionEx as
  //                                     we need the ProductType in order to distinguish between
  //                                     Server and Workstation versions as MS is duplicating the
  //                                     version numbers now
  GetVersionExtended(OSVerIRec);

  iServicePack := 0;
  sServicePack := OSVerIRec.szCSDVersion;
  if Length(sServicePack) > 13 then iServicePack := StrToIntDef(sServicePack[14],0);

  case OSVerIRec.dwPlatformId of
    VER_PLATFORM_WIN32s : Result := wv31;

    VER_PLATFORM_WIN32_WINDOWS : begin
      case OSVerIRec.dwMinorVersion of
        0 : Result := wv95;
        10 : Result := wv98;
        90 : Result := wvME;
      end;{case}
    end;

    VER_PLATFORM_WIN32_NT : begin
      Result := wvNTOther;
      case OSVerIRec.dwMajorVersion of
        3 : Result := wvNT3;
        4 : Result := wvNT4;

        5 : begin
          case OSVerIRec.dwMinorVersion of
            0 : Result := wv2000;
            1 : Result := wvXP;
            // HM 04/05/04: Added support for 2003 Server
            2 : Result := wv2003Server;
          end;{case}
        end;

        6 : begin
          case OSVerIRec.dwMinorVersion of
            0 : Result := wvVista;
            // MH 08/05/2013 v7.0.4 ABSEXCH-12022: Added support for Windows 7, Windows 8 and Windows Server 2012
            1 : Begin
                  If (OSVerIRec.wProductType = VER_NT_WORKSTATION) Then
                    Result := wvWindows7
                  Else
                    Result := wvWindowsServer2008R2;
                End; // 6.1
            2 : Begin
                  If (OSVerIRec.wProductType = VER_NT_WORKSTATION) Then
                  Begin
                    // Assume Windows 8 and look for further information
                    Result := wvWindows8;

                    // MH 01/09/2015 2015-R1 ABSEXCH-16810: Addes support for Windows 8.1 and 10
                    // Due to Windows 8.1 and Windows 10 lying about the version we need to
                    // look in the registry to try and identify the correct version
                    oRegistry := TRegistry.Create;
                    Try
                      oRegistry.Access := KEY_READ;
                      oRegistry.RootKey := HKEY_LOCAL_MACHINE;
                      If oRegistry.KeyExists('SOFTWARE\Microsoft\Windows NT\CurrentVersion') Then
                      Begin
                        If oRegistry.OpenKey('SOFTWARE\Microsoft\Windows NT\CurrentVersion', False) Then
                        Begin
                          // Look for the Major/Minor version properties - these were added in Windows 10
                          If oRegistry.ValueExists('CurrentMajorVersionNumber') And oRegistry.ValueExists('CurrentMinorVersionNumber') Then
                          Begin
                            // Currently only Windows 10 has these - longer term we'll need to
                            // actually look at the values to distinguish between future versions
                            //ReadInteger('CurrentMajorVersionNumber')
                            //ReadInteger('CurrentMinorVersionNumber')
                            Result := wvWindows10;
                          End // If oRegistry.ValueExists('CurrentMajorVersionNumber') And oRegistry.ValueExists('CurrentMinorVersionNumber')
                          Else
                          Begin
                            // Look at the CurrentVersion field instead
                            sCurrentVersion := oRegistry.ReadString('CurrentVersion');
                            If (sCurrentVersion = '6.3') Then
                              Result := wvWindows81;
                          End; // Else
                        End; // If OpenKey('SOFTWARE\Microsoft\Windows NT\CurrentVersion', False)
                      End; // If KeyExists('SOFTWARE\Microsoft\Windows NT\CurrentVersion')
                    Finally
                      oRegistry.Free;
                    End; // Try..Finally
                  End // If (OSVerIRec.wProductType = VER_NT_WORKSTATION)
                  Else
                    Result := wvWindowsServer2012;
                End; // 6.2
          else
            Result := wvVista;
          end;{case}
        end;
      end;{case}

      {check for terminal server}
      if Result in [wvNT4, wv2000, wvXP, wv2003Server] then begin
        with TRegistry.create do begin
          try
            Access := KEY_READ;
            RootKey := HKEY_LOCAL_MACHINE;
            if OpenKey('System\CurrentControlSet\Control\Terminal Server', False) then begin
              if Result = wvNT4 then Result := wvNT4TerminalServer
              else begin
                if ValueExists('TSEnabled') then begin
                  if (ReadInteger('TSEnabled') = 1) then begin
                    case Result of
                      wv2000       : Result := wv2000TerminalServer;
  {                    wvXP        : Result := wvXPTerminalServer;}
                      wv2003Server : Result := wv2003TerminalServer;
                    end;{case}
                  end;{if}
                end;{if}
              end;{if}
            end;{if}
          finally
            CloseKey;
            Free;
          end;{try}
        end;{with}
      end;{if}

    end;
  end;{case}
end;

function GetWindowsVersion : TWindowsVersion; overload;
var
  iBuildNo : integer;
begin
  Result := GetWindowsVersion(iBuildNo);
end;

function GetWindowsVersionString : string;
//Calls GetWindowsVersion and returns a string specifying the version (+ service pack if any)
var
  iServicePack : Integer;
begin
  Case GetWindowsVersion(iServicePack) of
    wv95                  : Result := '95';
    wv98                  : Result := '98';
    wvME                  : Result := 'ME';
    wvNT3                 : Result := 'NT3';
    wvNT4                 : Result := 'NT4';
    wvNT4TerminalServer   : Result := 'NT4 Terminal Server';
    wv2000                : Result := '2000';
    wv2000TerminalServer  : Result := '2000 Terminal Server';
    wvXP                  : Result := 'XP';
    wvXPTerminalServer    : Result := 'XP Terminal Server';
    wvNTOther             : Result := 'Other';
    wv2003Server          : Result := '2003 Server';
    wv2003TerminalServer  : Result := '2003 Terminal Server';
    wvVista               : Result := 'Vista';
    // MH 08/05/2013 v7.0.4 ABSEXCH-12022: Added support for Windows 7, Windows 8 and Windows Server 2012
    wvWindows7            : Result := '7';
    wvWindowsServer2008R2 : Result := 'Server 2008 R2';
    wvWindows8            : Result := '8';
    wvWindowsServer2012   : Result := 'Server 2012';
    // MH 01/09/2015 2015-R1 ABSEXCH-16810: Addes support for Windows 8.1 and 10
    wvWindows81           : Result := '8.1';
    wvWindows10           : Result := '10';
  else
    Result := 'Version Unknown';
  end; //Case

  if iServicePack = 0 then
    Result := Format('Windows %s', [Result])
  else
    Result := Format('Windows %s Service Pack %d', [Result, iServicePack]);
end;


Procedure RunFile(sFileName : string; sParams : string = '');
Var
  cmdFile, cmdPath, cmdParams          : PChar;
//  Flags                                : SmallInt;
  iResult : integer;
begin
  // Shell text file
  cmdFile   := StrAlloc(255);
  cmdPath   := StrAlloc(255);
  cmdParams := StrAlloc(255);
  StrPCopy (cmdFile,   sFileName);
  StrPCopy (cmdParams, sParams);
  StrPCopy (cmdPath, ExtractFilePath(sFileName));

//  Flags := SW_SHOWNORMAL;
  iResult := ShellExecute(Application.MainForm.Handle, 'open', cmdFile, cmdParams, cmdPath, SW_SHOWNORMAL);
  if iResult <=32 then ShowMessage('ShellExecute Error ' + IntToStr(iResult) + ' : ' + cmdFile);
//  ShellExecute(0, NIL, cmdFile, cmdParams, cmdPath, Flags);

  StrDispose(cmdFile);
  StrDispose(cmdPath);
  StrDispose(cmdParams);
end;

function WinGetWindowsTempDir : Ansistring;
// Wraps the Windows API call : GetTempPath
// Gets the Current Windows Temp Directory
var
  lpBuffer : Array [0..255] of Char;
  nSize : uint;
begin
  nSize := SizeOf(lpBuffer) - 1;
  GetTempPath(nSize, lpBuffer);
  Result := lpBuffer;
  Result := IncludeTrailingPathDelimiter(Result);
end;

function WinGetShortPathName(LongName : AnsiString) : Ansistring;
// Wraps the Windows API call : GetShortPathName
// Gets the 8.3 path of the LongName param. LongName must exist, otherwise an empty string is returned
var
  lpBuffer :PChar;
  nSize, Res : uint;
begin
  Result := '';
  if FileExists(LongName) or DirectoryExists(LongName) then
  begin
    nSize := 255;
    lpBuffer := StrAlloc(nSize + 1);
    Try
      Res := GetShortPathName(PChar(LongName), lpBuffer, nSize);
      if Res > nSize then //Buffer too short - reallocate at required size
      begin
        StrDispose(lpBuffer);
        lpBuffer := StrAlloc(Res + 1);
        Res := GetShortPathName(PChar(LongName), lpBuffer, nSize);
      end;
      if (Res = 0) then //Error
        raise Exception.Create('Error in GetShortPathName: ' + IntToStr(GetLastError));
      Result := lpBuffer;
    Finally
      StrDispose(lpBuffer);
    End;
  end;
end;

function GetFileType(sFilename : string) : string;
Var
  RegO   : TRegistry;
  TmpStr : ShortString;
begin
  Result := '';
  If FileExists (sFilename) Then Begin
    RegO := TRegistry.Create;
    Try
      RegO.RootKey := HKEY_CLASSES_ROOT;

      { Open association details for extension }
      If RegO.OpenKey(ExtractFileExt(sFilename), False) Then Begin
        { defaults are stored as null strings }
        If RegO.KeyExists('') Then Begin
          { Get redirection string and check it exists in the classes }
          TmpStr := RegO.ReadString('');

          { Close initial entry and open redirection entry }
          RegO.CloseKey;
          If RegO.KeyExists(TmpStr) Then Begin
            If RegO.OpenKey(TmpStr, False) Then Begin
              Result := RegO.ReadString('');
            End { If }
            Else Begin
              Result := TmpStr;
            End; { Else }
          End { If RegO.KeyExists(RegO.ReadString('')) }
          Else Begin
            Result := TmpStr;
          End; { Else }
        End { If RegO.KeyExists(ExtractFileExt(edPath.Text)) }
        Else Begin
          Result := 'Unknown';
        End; { Else }
      End { If RegObj.OpenKey(ExtractFileExt(edPath.Text)) }
      Else Begin
        Result := 'Unknown';
      End; { Else }

      RegO.CloseKey;
    Finally
      RegO.Destroy;
    End;
  End { If FileExists (edPath.Text) }
  Else Begin
    { No valid file specified }
    Result := '';
  End; { Else }
end;

//-------------------------------------------------------------------------

function IsWow64: Boolean;
type
  TIsWow64Process = function( // Type of IsWow64Process API fn
    Handle: Windows.THandle; var Res: Windows.BOOL
  ): Windows.BOOL; stdcall;
var
  IsWow64Result: Windows.BOOL;      // Result from IsWow64Process
  IsWow64Process: TIsWow64Process;  // IsWow64Process fn reference
begin
  // Try to load required function from kernel32
  IsWow64Process := Windows.GetProcAddress(
    Windows.GetModuleHandle('kernel32.dll'), 'IsWow64Process'
  );
  if Assigned(IsWow64Process) then
  begin
    // Function is implemented: call it
    if not IsWow64Process(
      Windows.GetCurrentProcess, IsWow64Result
    ) then
      raise SysUtils.Exception.Create('IsWow64: bad process handle');
    // Return result of function
    Result := IsWow64Result;
  end
  else
    // Function not implemented: can't be running on Wow64
    Result := False;
end;

type   
   PTokenUser = ^TTokenUser;
   TTokenUser = packed record
     User: SID_AND_ATTRIBUTES;
   end;

function GetProcessUserName(ProcessID: Cardinal; out DomainName, UserName: string): Boolean;
var
   ProcessHandle, ProcessToken: THandle;
   InfoSize, UserNameSize, DomainNameSize: Cardinal;
   User: PTokenUser;
   Use: SID_NAME_USE;
   _DomainName, _UserName: array[0..255] of Char;
begin
   Result := False;
   DomainName := '';
   UserName := '';
   ProcessHandle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, ProcessID);
   if ProcessHandle = 0 then
     Exit;
    try
     if not OpenProcessToken(ProcessHandle, TOKEN_QUERY, ProcessToken) then
       Exit;
      try
       GetTokenInformation(ProcessToken, TokenUser, nil, 0, InfoSize);
       User := AllocMem(InfoSize * 2);
       try
         if GetTokenInformation(ProcessToken, TokenUser, User, InfoSize * 2, InfoSize) then
         begin
           DomainNameSize := SizeOf(_DomainName);
           UserNameSize := SizeOf(_UserName);
            Result := LookupAccountSid(nil, User^.User.Sid, _UserName, UserNameSize, _DomainName, DomainNameSize, Use);
            if Result then
           begin
             SetString(DomainName, _DomainName, StrLen(_DomainName));
             SetString(UserName, _UserName, StrLen(_UserName));
           end;
         end;
       finally
         FreeMem(User);
       end;
     finally
       CloseHandle(ProcessToken);
     end;
   finally
     CloseHandle(ProcessHandle);
   end;
end;

//-------------------------------------------------------------------------
//Callback procedure for EnumWindows. lParam will contain the ProcessId of the App we're trying
//to close. We check if it's the same as the ProcessId of the current window - if it is then
//we send a close message to the window.
function EnumProcess(hHwnd: HWND; lParam : integer): boolean; stdcall;
const
  iTimeout = 10000;
var
  pPid : DWORD;
  title, ClassName : string;
  Res : Integer;
  dwRes : DWord;
begin
  //if the returned value in null the
  //callback has failed, so set to false and exit.
  if (hHwnd=0) then
  begin
    result := false;
  end
  else
  begin
    GetWindowThreadProcessId(hHwnd,pPid);

    if pPid = DWord(lParam) then //Belongs to the process
    {$IFDEF WIN64}
      SendMessageTimeout(hHWND, WM_CLOSE, 0, 0, SMTO_NORMAL, iTimeout, @dwRes);
    {$ELSE}
      SendMessageTimeout(hHWND, WM_CLOSE, 0, 0, SMTO_NORMAL, iTimeout, dwRes);
    {$ENDIF}

    Result := true;
  end;
end;


//Function to find and terminate a running process. Code from www.delphitricks.com (no author listed)
//As written, will terminate all instances of the named Exe.
//Returns True if successful

//PR: 04/02/2011 Changed to terminate more cleanly by finding the main window and sending a close message.
// If CloseCleanly is false then a first call hasn't worked and we go back to TerminateProcess
function KillTask(ExeFileName: string; CloseCleanly : Boolean = True): Boolean;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  Res : Integer;
  sUserName : string;
  sDomainName : string;

  procedure WaitForClose;
  var
    iCount : Integer;
  begin
    iCount := 1;
    while (iCount < 11) and TaskIsRunning(ExeFileName) do
    begin
      SleepEx(1000, True);
      inc(iCount);
    end;
  end;
begin
  Res := 1;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      begin
        if GetProcessUserName(FProcessEntry32.th32ProcessId, sDomainName, sUserName) then
        begin
          if Trim(UpperCase(sUserName)) = Trim(UpperCase(WinGetUserName)) then
          begin
            if CloseCleanly then
            begin
              EnumWindows(@EnumProcess, FProcessEntry32.th32ProcessId);
              WaitForClose;
            end
            else
            begin
              TerminateProcess(OpenProcess(PROCESS_TERMINATE,
                               BOOL(0),
                               FProcessEntry32.th32ProcessID),
                               0);
              WaitForClose;
            end;
          end
        end;
      end;
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
  Result := not TaskIsRunning(ExeFileName);
end;

function TaskIsRunning(ExeFileName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  sUserName : string;
  sDomainName : string;
begin
  Result := False;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      begin
        if GetProcessUserName(FProcessEntry32.th32ProcessId, sDomainName, sUserName) then
        begin
          if Trim(UpperCase(sUserName)) = Trim(UpperCase(WinGetUserName)) then
          begin
            Result := True;
            Break;
          end;
        end;
      end;
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;


//PR: 04/03/2011 Replacement for Sleep, allowing message processing to continue
procedure Wait(dwMilliseconds: Longint);
var
  iStart, iStop: DWORD;
begin
  iStart := GetTickCount;
  repeat
    iStop := GetTickCount;
    Application.ProcessMessages;
    Sleep(10);
  until (iStop - iStart) >= DWord(dwMilliseconds);
end;


//PR: 16/08/2011 Added function to allow the name of a network share to be found from its local path by reading the registry.
//Users TRegistryEx to read a stringlist from the registry.
function GetShareNameFromPath(const APath : string) : string;
var
  AList : TStringList;
  ShareList : TStringList;
  Reg : TRegistryEx;
  i, j : integer;
  Found : Boolean;
begin
  Result := '';
  Found := False;
  Reg := TRegistryEx.Create(KEY_QUERY_VALUE);
  Try
    ReG.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('SYSTEM\CurrentControlSet\services\LanmanServer\Shares', False) then
    begin
      AList := TSTringList.Create;
      ShareList := TSTringList.Create;
      Try
        Reg.GetValueNames(ShareList);
        i := 0;
        while not Found and (i < ShareList.Count) do
        begin
          Reg.ReadMultiString(ShareList[i], AList);
          j := 0;
          while not Found and (j < AList.Count) do
          begin
            if UpperCase(Trim('Path=' + APath)) = UpperCase(Trim(AList[j])) then
            begin
              Found := True;
              Result := ShareList[i];
            end
            else
              inc(j);
          end;
          inc(i);
        end;
      Finally
        ShareList.Free;
        AList.Free;
      End;
    end;
  Finally
    Reg.Free;
  End;
end;

//PR: Added function to get the version number from a file
//Code found on www.delphitricks.com
function GetFileVersion(sFileName : Ansistring): string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(sFileName), Dummy);
  // MH 26/10/2011 v6.9: Mod'd to handle 0 size being returned - this happened when running
  // EnterMh.Exe from \\Hades-Srv2\Apps\TBatch and caused the logging to crash on creation
  If (VerInfoSize > 0) Then
  Begin
    GetMem(VerInfo, VerInfoSize);
    GetFileVersionInfo(PChar(sFileName), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    with VerValue^ do
    begin
      Result := IntToStr(dwFileVersionMS shr 16);
      Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
      Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
      Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
    end;
    FreeMem(VerInfo, VerInfoSize);
  End // If (VerInfoSize > 0)
  Else
    Result := '0.0.0.0';
end;

function EntGetModuleFileName : string;
var
  Buffer : array[0..255] of Char;
  Len    : SmallInt;
begin
  Len := GetModuleFileName(HInstance, Buffer, SizeOf(Buffer));
  if (Len > 0) Then Begin
    Result := StrPas(Buffer);
  end
  else
    Result := '';
end;

//-------------------------------------------------------------------------

// Deletes a directory and all subdirectories, optionally deletes to Recycle Bin or displays
// progress / confirmation dialogs
//
// Copied from http://stackoverflow.com/questions/16336761/delete-directory-with-non-empty-subdirectory-and-files
//
Function DeleteDirectory (Const ItemName: string;
                          Const DeleteToRecycle : Boolean=False;
                          Const ShowConfirm : Boolean=False;
                          Const TotalSilence : Boolean=True): Boolean;
Const
  // Following constants not declared in the Delphi 6 version of ShellAPI so I've copied them in from the Delphi XE source
  FOF_NO_UI = FOF_SILENT or FOF_NOCONFIRMATION or FOF_NOERRORUI or FOF_NOCONFIRMMKDIR; // don't display any UI at all
VAR
  SHFileOpStruct: TSHFileOpStruct;
Begin // DeleteDirectory
  FillChar(SHFileOpStruct, SizeOf(SHFileOpStruct), #0);
  //PR: 24/10/2016 v2017 R1 Mainform isn't assigned in SentRepEngine
  if Assigned(Application.MainForm) then
    SHFileOpStruct.wnd           := Application.MainForm.Handle                                   { Others are using 0. But Application.MainForm.Handle is better because otherwise, the 'Are you sure you want to delete' will be hidden under program's window }
  else
    SHFileOpStruct.wnd := 0;
  SHFileOpStruct.wFunc         := FO_DELETE;
  SHFileOpStruct.pFrom         := PChar(ItemName+ #0);
  SHFileOpStruct.pTo           := NIL;
  SHFileOpStruct.hNameMappings := NIL;

  If DeleteToRecycle Then
    SHFileOpStruct.fFlags := SHFileOpStruct.fFlags OR FOF_ALLOWUNDO;

  If TotalSilence Then
    SHFileOpStruct.fFlags := SHFileOpStruct.fFlags OR FOF_NO_UI
  Else
    If (NOT ShowConfirm) Then
      SHFileOpStruct.fFlags := SHFileOpStruct.fFlags OR FOF_NOCONFIRMATION;

  Result := SHFileOperation(SHFileOpStruct)= 0;
End; // DeleteDirectory

//-------------------------------------------------------------------------

end.
