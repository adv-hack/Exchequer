unit InstallPervFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, LicDets, WizdMsg, ComCtrls, PreReqs;

type
  TfraInstallPerv = class(TFrame)
    lblTitle: TLabel;
    lblIntro: TLabel;
    lblInfo: TLabel;
    Animate1: TAnimate;
  private
    { Private declarations }
    FLicence  : TLicenceDetails;
    FReturnTo : TAutoRunMode;
  public
    // Dialog to reutnr to once the Pervasive.Workgroup Engine has successfully installed
    Property ReturnTo : TAutoRunMode Read FReturnTo Write FReturnTo;

    Procedure InitLicence (Licence : TLicenceDetails; PreRequisits : TPreRequisites);
  end;

implementation

{$R *.dfm}

Uses Brand, PervInfo, Registry, APIUtil;

//=========================================================================

Procedure TfraInstallPerv.InitLicence (Licence : TLicenceDetails; PreRequisits : TPreRequisites);

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

Begin // InitLicence
  FLicence := Licence;

  If (Not PervasiveInfo.WorkgroupInstalled) Then
  Begin
    // Install
    lblTitle.Caption := 'Install Pervasive.SQL Workgroup Engine';
  End // If (Not PervasiveInfo.WorkgroupInstalled)
  Else
  Begin
    // Upgrade
    lblTitle.Caption := 'Upgrade Pervasive.SQL Workgroup Engine';
  End; // Else

  Parent.Refresh;

  // Install the WGE
  RunApp(ExtractFilePath(Application.ExeName) + 'PreReqs\Pervasive.SQL WGE v8.7\Setup.Exe -s -SMS', True);

  // Pervasive Licence Key installed after the licence has been downloaded (see DisplayDetailsFrame) 

  // Redo the Pre-Req checks as we may be able to install now
  PreRequisits.CheckPreReqs;
  If PreRequisits.AllChecksPassed Then
    // Go to main Options page
    PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amOptions))
  Else
    // Return back to Pre-Reqs frame so the pre-reqs can be installed
    PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amPreReqs));
End; // InitLicence

//-------------------------------------------------------------------------

end.
