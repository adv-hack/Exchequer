///////////////////////////////////////
// Wrapper Unit for common API calls //
///////////////////////////////////////
unit APIUtil;

interface
uses
  Dialogs, Windows, Forms, Classes, FileCtrl;

type
  TWindowsVersion = (wv31, wv95, wv98, wvME, wvNT3, wvNT4, wvNT4TerminalServer, wv2000
  , wv2000TerminalServer, wvXP, wvXPTerminalServer, wvNTOther, wvUnknown,
  wv2003Server, wv2003TerminalServer);

const
  wvXPStyle = [wvXP, wvXPTerminalServer];

  function msgbox(scaption: string; etype: TMsgDlgType; sButtons: TMsgDlgButtons;
  eDefault: TmsgDlgBtn; stitle: string): byte;
  function WinGetUserName : Ansistring;
  function WinGetComputerName : Ansistring;
  function WinGetWindowsDir : Ansistring;
  function IsAppAlreadyRunning(sAppName : string) : boolean;
  function RunApp(AppPath: String; bWait : boolean) : THandle;
  function GetWindowsVersion : TWindowsVersion; overload;
  function GetWindowsVersion(var iServicePack : integer) : TWindowsVersion; overload;
  function WinGetWindowsSystemDir : Ansistring;
  Procedure RunFile(sFileName : string);
  function WinGetWindowsTempDir : Ansistring;
  function WinGetShortPathName(LongName : AnsiString) : Ansistring;

const
  wvNTVersions = [wvNT3, wvNT4, wvNT4TerminalServer, wv2000, wv2000TerminalServer
  , wvXP, wvXPTerminalServer, wvNTOther];

  wv95Versions = [wv95, wv98, wvME];

  wvTSVersions = [wvNT4TerminalServer, wv2000TerminalServer, wvXPTerminalServer];


implementation
uses
  ShellAPI, Controls, SysUtils, Registry;

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
begin
  nSize := SizeOf(lpBuffer) - 1;
  if GetUserName(lpBuffer, nSize) then Result := lpBuffer
  else Result := 'User';
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
  lpBuffer : Array [0..255] of Char;
  nSize : uint;
begin
  nSize := SizeOf(lpBuffer) - 1;
  GetWindowsDirectory(lpBuffer, nSize);
  Result := lpBuffer;
  Result := IncludeTrailingBackslash(Result);
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
  Result := IncludeTrailingBackslash(Result);
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

function RunApp(AppPath: String; bWait : boolean) : THandle;
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
  Start.wShowWindow := 1;
  Ret := CreateProcess(nil,
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

function GetWindowsVersion(var iServicePack : integer) : TWindowsVersion; overload;
// Wraps the Windows API call : GetVersionEx
// Returns the version of Windows that you are running
var
  OSVerIRec : TOSVersionInfo;
  sServicePack : string;
begin
  Result := wvUnknown;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);
  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);
  GetVersionEx(OSVerIRec);

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
      end;{case}

      {check for terminal server}
      if Result in [wvNT4, wv2000, wvXP] then begin
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

Procedure RunFile(sFileName : string);
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
  StrPCopy (cmdParams, '');
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
  Result := IncludeTrailingBackslash(Result);
end;

function WinGetShortPathName(LongName : AnsiString) : Ansistring;
// Wraps the Windows API call : GetShortPathName
// Gets the 8.3 path of the LongName param. LongName must exist, otherwise an empty string is returned
var
  lpBuffer :PChar;
  nSize : uint;
  Res : Integer;
begin
  Result := '';
//  if FileExists(LongName) or DirectoryExists(LongName) then
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



end.
