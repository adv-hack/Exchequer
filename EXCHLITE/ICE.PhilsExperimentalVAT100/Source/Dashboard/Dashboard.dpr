Program Dashboard;

{$REALCOMPATIBILITY ON}

uses
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  Sysutils,
  Controls,
  Windows,
  uConsts,
  uCommon,
  WinSvc,
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
  uPopSmtpWiz in '..\Config\uPopSmtpWiz.pas' {frmPOPSMTPWiz},
  uDashReminder in 'uDashReminder.pas' {frmReminder},
  uWait in 'uWait.pas' {frmWait},
  uSubcontractorVerification in 'uSubcontractorVerification.pas' {frmSubVerification},
  uEmailSettings in 'uEmailSettings.pas' {frmEmailSettings},
  uFrmBase in 'uFrmBase.pas' {frmBase},
  uDashHistory in 'uDashHistory.pas',
  uDashMiniSetup in 'uDashMiniSetup.pas' {frmMiniSetup},
  uADODSR in '..\Common\uADODSR.pas',
  DSR_TLB in 'C:\Develop\Borland\Delphi6\Imports\DSR_TLB.pas',
  uVAT100Response in '\\Bmtdevgov\v700\SourceCode\EXCHLITE\ICE\Source\Dashboard\uVAT100Response.pas' {frmVAT100Response},
  RemotingClientLib_TLB in 'C:\Develop\Borland\Delphi6\Imports\RemotingClientLib_TLB.pas';

{$R *.res}

Var
  lMutex: Cardinal;
//  lError: Cardinal;
  lTick: Cardinal;
  lResult: Integer;
  lDbOk: Boolean;
Begin
  If OpenMutex(MUTEX_ALL_ACCESS, False, PChar('DASHBOARD ICE')) = 0 Then
  Begin
    lMutex := CreateMutex(Nil, False, PChar('DASHBOARD ICE'));

//    lError := SetErrorMode(SEM_FAILCRITICALERRORS Or SEM_NOOPENFILEERRORBOX);

    Application.Initialize;

    Application.Title := '';

    lDbOk := False;

    if Uppercase(ParamStr(1)) <> '/NOCHECK' then
      // checking if the database info is correct
      if _DashboardGetDBServer <> '' then
      begin
        frmWait := TfrmWait.Create(Nil);

        try
          frmWait.Start('Checking database connection...');
          Application.ProcessMessages;
          lDbOk := checkdbok(_DashboardGetDBServer);
        finally
          frmWait.Stop;
          FreeAndNil(frmWait);
        end;
      end; {if _DashboardGetDBServer <> ''  then}

    // checking main dashboard parameters
    if (Uppercase(ParamStr(1)) <> '/NOCHECK') and ( (_DashboardGetDBServer = '') or
    (_DashboardGetDSRServer = '') or (_DashboardGetDSRPort = 0) or (not lDbOk) ) then
    begin
      Application.Title := 'Setup';
      Application.CreateForm(TfrmMiniSetup, frmMiniSetup);
  Application.CreateForm(TfrmVAT100Response, frmVAT100Response);
  lResult := frmMiniSetup.ShowModal;
      frmMiniSetup.Free;

      if lResult = mrOK then
        _fileExec(application.ExeName, False, False);

      Application.Terminate;
    end
    else
    begin
      Application.Title := 'Login';
      frmWait := TfrmWait.Create(Nil);

      {check if the service is running or it is in a state of loading...}
      Try
        frmWait.Start('Checking service status...');

        Application.ProcessMessages;

        If _ServiceStatus(cDSRSERVICE, _DashboardGetDSRServer, False, False) =
          SERVICE_STOPPED Then
          _ServiceStatus(cDSRSERVICE, _DashboardGetDSRServer, True, False);

        lTick := GetTickCount;

        Repeat
          _Delay(2);
        Until (_ServiceStatus(cDSRSERVICE, _DashboardGetDSRServer, False, False) =
          SERVICE_RUNNING) Or (GetTickCount - lTick > 45000);

      Finally
        frmWait.Stop;
        FreeAndNil(frmWait);
      End;

      CheckCIS(_DashboardGetDBServer);

      //Application.Initialize;

  {$IFNDEF DEBUG}
      Application.CreateForm(TfrmLogin, frmLogin);
    If frmLogin.ShowModal = mrOk Then
      Begin
        FreeAndNil(frmLogin);
  {$ENDIF}
        Application.CreateForm(TfrmDashboard, frmDashboard);

        frmDashboard.SetIsCIS(glISCIS);

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
      end;

    Closehandle(lMutex);
  End;

End.

