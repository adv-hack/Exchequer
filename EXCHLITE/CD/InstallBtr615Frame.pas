unit InstallBtr615Frame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, LicDets, WizdMsg, ComCtrls, PreReqs;

type
  TfraInstallBtrieve615 = class(TFrame)
    lblTitle: TLabel;
    lblIntro: TLabel;
    lblInfo: TLabel;
    Animate1: TAnimate;
  public
    Procedure Init;
  end;

implementation

{$R *.dfm}

Uses Brand, PervInfo, Registry, APIUtil;

//=========================================================================

Procedure TfraInstallBtrieve615.Init;

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
  begin
    StrPCopy(zAppName,AppPath);
    GetDir(0,WorkDir);
    StrPCopy(zCurDir,WorkDir);
    FillChar(Start,Sizeof(StartupInfo),#0);
    Start.cb := Sizeof(StartupInfo);
    Start.dwFlags := STARTF_USESHOWWINDOW;
    Start.wShowWindow := 1;

    CreateProcess(nil,
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

    While (WaitForSingleObjectEx(Proc.hProcess, 100, False) = WAIT_TIMEOUT) Do
    Begin
      Application.ProcessMessages;
    End;

    Result := Proc.hProcess;
  end;

Begin // Init
  // Update Branding
  lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<APPTITLE>', Branding.pbProductName);

  // Run the IAO Btrieve v6.15 Pre-Installer to put Btrieve in place
  RunApp(ExtractFilePath(Application.ExeName) + 'Utils\Btrieve v6.15\IAOBtrv6.EXE', True);

  // Restart the OS, Btrieve and Pre-Req checks
  PostMessage ((Owner As TForm).Handle, WM_RestartChecks, 0, 0);
End; // Init

//-------------------------------------------------------------------------

end.
