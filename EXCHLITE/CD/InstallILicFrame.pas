unit InstallILicFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, LicDets, WizdMsg, ComCtrls, PreReqs;

type
  TfraInstallIRISLic = class(TFrame)
    lblTitle: TLabel;
    lblIntro: TLabel;
    lblInfo: TLabel;
    Animate1: TAnimate;
  private
    { Private declarations }
    FLicence  : TLicenceDetails;
  public
    // Dialog to return to once the Pervasive.Workgroup Engine has successfully installed
    Procedure InitLicence (Licence : TLicenceDetails; PreRequisits : TPreRequisites);
  end;

implementation

{$R *.dfm}

Uses Brand, PervInfo, Registry, APIUtil, ELITE_COM_TLB;

//=========================================================================

Procedure TfraInstallIRISLic.InitLicence (Licence : TLicenceDetails; PreRequisits : TPreRequisites);
Var
  {$Warnings Off}
  FLicencingInterface : IEliteCom;
  {$Warnings On}

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

  Parent.Refresh;

  // Install IRIS Licencing Database
  RunApp('MSIEXEC.EXE /I "' + ExtractFilePath(Application.ExeName) + 'PreReqs\IRIS Licensing\Network Setup.msi" /qn AllUsers=1', True);

  // Create IRIS Licencing COM OBject (wrapper of .NET class) and Configure Database
  FLicencingInterface := CoLicensingInterface.Create;
  Try
    // Update the scripts with the Server Instance Name
    lblInfo.Caption := 'Configuring Servers, Please Wait...';
    If FLicencingInterface.SaveSQLServerNameForLocalDB(WinGetComputerName + '\IRISSOFTWARE', '') Then
    Begin
      // Create the Licencing DB
      lblInfo.Caption := 'Configuring Licencing Database, Please Wait...';
      If (Not FLicencingInterface.InitialiseLicenceMasterDB) Then
        MessageDlg ('An error occurred creating the IRIS Licensing Database', mtError, [mbOK], 0);

// MH 23/11/06: ICE DB Creation is now done by the Dashboard Service when it first loads        
//      // Create the ICE DB
//      lblInfo.Caption := 'Configuring Client-Sync Database, Please Wait...';
//      If (Not FLicencingInterface.InitialiseICEDB) Then
//        MessageDlg ('An error occurred creating the IRIS Client Synchronisation Database', mtError, [mbOK], 0);

      // Setup the LIVE web-service for licensing
      lblInfo.Caption := 'Configuring Web-Service, Please Wait...';
      If (Not FLicencingInterface.SaveWebServiceURL('https://www.e-iris-software.co.uk/licensingwebservice/service.asmx')) Then
        MessageDlg ('An error occurred specifying the address of the Licensing Server', mtError, [mbOK], 0);
    End // If FLicencingInterface.SaveSQLServerNameForLocalDB(WinGetComputerName + '\IRISSOFTWARE', '')
    Else
      MessageDlg ('An error occurred updating the Server Name for the IRIS Licensing Database', mtError, [mbOK], 0);
  Finally
    FLicencingInterface := NIL;
  End; // Try..Finally

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
