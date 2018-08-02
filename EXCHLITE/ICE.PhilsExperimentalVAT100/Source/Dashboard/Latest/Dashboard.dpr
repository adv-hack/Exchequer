Program Dashboard;

uses
  Forms,
  Sysutils,
  Controls,
  Windows,
  uConsts,
  uCommon,
  uMailBoxBaseFrame in 'BaseFrames\uMailBoxBaseFrame.pas' {frmMailBoxBaseFrame: TFrame},
  uInboxFrame in 'BaseFrames\uInboxFrame.pas' {frmInboxFrame: TFrame},
  uOutboxFrame in 'BaseFrames\uOutboxFrame.pas' {frmOutboxFrame: TFrame},
  uDailyFrame in 'BaseFrames\uDailyFrame.pas' {frmDailyFrame: TFrame},
  uDailyScheduleTask in 'uDailyScheduleTask.pas' {frmDailyScheduleTask},
  uExportFrame in 'BaseFrames\uExportFrame.pas' {frmExportFrame: TFrame},
  uRequestSync in 'uRequestSync.pas' {frmRequestSync},
  uSync in 'uSync.pas' {frmLink},
  uDashboard in 'uDashBoard.pas' {frmDashboard},
  uDashSettings in 'uDashSettings.pas',
  uLogin in 'uLogin.pas' {frmLogin},
  uCompany in 'uCompany.pas' {frmCompanyManager},
  uUsers in 'uUsers.pas' {frmUser},
  uDashConfig in 'uDashConfig.pas' {frmConfiguration},
  uAddressBook in 'uAddressBook.pas' {frmAddressBook},
  uCompImport in 'uCompImport.pas' {frmCompImport},
  uBulkExport in 'uBulkExport.pas' {frmBulkExport},
  uAddContact in 'uAddContact.pas' {frmAddContact},
  uDashGlobal in 'uDashGlobal.pas',
  uAddUserLogin in 'uAddUserLogin.pas' {frmAddUserLogin},
  uAbout in 'uAbout.pas' {frmAbout},
  uUpdateManagerPwd in 'uUpdateManagerPwd.pas' {frmUpdateManagerPwd},
  uRecycleFrame in 'BaseFrames\uRecycleFrame.pas' {frmRecycleFrame: TFrame},
  uDSRConfigFrame in 'BaseFrames\uDSRConfigFrame.pas' {frmDSRConfigFrame: TFrame},
  uEndofSyncRequest in 'uEndofSyncRequest.pas' {frmEndofSyncRequest},
  uAddOnExport in 'uAddOnExport.pas' {frmAddonExport},
  uAddOnExportFrame in 'BaseFrames\uAddOnExportFrame.pas' {frmAddOnExportFrame: TFrame},
  uCISResponse in 'uCISResponse.pas' {frmCISResponse},
  uPasswordDialog in 'uPasswordDialog.pas' {frmPasswordDlg},
  uEMailDLLWizard in 'uEMailDLLWizard.pas' {frmEmailDllWizard},
  uPopSmtpWiz in '..\Config\uPopSmtpWiz.pas' {frmPOPSMTPWiz},
  uDashReminder in 'uDashReminder.pas' {frmReminder},
  uWait in 'uWait.pas' {frmWait},
  uSubcontractorVerification in 'uSubcontractorVerification.pas' {frmSubVerification};

{$R *.res}

Var
  lMutex: Cardinal;
//  lError: Cardinal;

Begin
  If OpenMutex(MUTEX_ALL_ACCESS, False, PChar('DASHBOARD ICE')) = 0 Then
  Begin
    lMutex := CreateMutex(Nil, False, PChar('DASHBOARD ICE'));

//    lError := SetErrorMode(SEM_FAILCRITICALERRORS Or SEM_NOOPENFILEERRORBOX);

    Application.Initialize;
    Application.Title := 'Dashboard';

{$IFNDEF DEBUG}
    Application.CreateForm(TfrmLogin, frmLogin);
  If frmLogin.ShowModal = mrOk Then
    Begin
      FreeAndNil(frmLogin);
{$ENDIF}
      Application.CreateForm(TfrmDashboard, frmDashboard);

      Try
        Application.Run;
      Finally
      End;

{$IFNDEF DEBUG}
    End
    Else
      Application.Terminate;
{$ENDIF}

//    SetErrorMode(lError);

    Closehandle(lMutex);
  End;

End.

