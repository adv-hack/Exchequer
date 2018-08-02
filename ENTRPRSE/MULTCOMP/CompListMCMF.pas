unit CompListMCMF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MaintainCompaniesF, Menus, uExDatasets, uBTGlobalDataset,
  StdCtrls, ExtCtrls, uMultiList, uDBMultiList;

type
  TfrmStandardMCM = class(TfrmMaintainCompanies)
    MainMenu1: TMainMenu;
    Menu_File: TMenuItem;
    mnuOpenEnterprise: TMenuItem;
    MenuOpt_SepBar4: TMenuItem;
    mnuOpenEBusiness: TMenuItem;
    mnuOpenSentimail: TMenuItem;
    MenuOpt_SepBar7: TMenuItem;
    mnuAddCompany: TMenuItem;
    mnuEditCompany: TMenuItem;
    mnuDeleteCompany: TMenuItem;
    MenuOpt_SepBar6: TMenuItem;
    mnuModuleLicencing: TMenuItem;
    mnuEntUserCount: TMenuItem;
    mnuEntReleaseCode: TMenuItem;
    MenuOpt_SepBar8: TMenuItem;
    mnuSecurityUtilities: TMenuItem;
    MenuOpt_ResyncComps: TMenuItem;
    MenuOpt_ResetUserCounts: TMenuItem;
    MenuOpt_ResetPIUsers: TMenuItem;
    MenuOpt_SepBar1: TMenuItem;
    mnuMCMLogin: TMenuItem;
    MenuOpt_SepBar3: TMenuItem;
    MenuOpt_Exit: TMenuItem;
    mnuTools: TMenuItem;
    mnuLoggedInUserReport: TMenuItem;
    MenuOpt_SepBar9: TMenuItem;
    mnuOpenRebuild: TMenuItem;
    MenuOpt_SepBar10: TMenuItem;
    mnuRunBackup: TMenuItem;
    mnuRunRestore: TMenuItem;
    MenuOpt_SepBar5: TMenuItem;
    mnuMCMOptions: TMenuItem;
    Menu_Help: TMenuItem;
    MenuOpt_HelpCont: TMenuItem;
    MenuOpt_SepBar2: TMenuItem;
    MenuOpt_SessionInfo: TMenuItem;
    MenuOpt_About: TMenuItem;
    btnOpenEnterprise: TButton;
    btnOpenEBusiness: TButton;
    btnOpenSentimail: TButton;
    popOpenEnterprise: TMenuItem;
    N2: TMenuItem;
    popOpenEBusiness: TMenuItem;
    popOpenSentimail: TMenuItem;
    N3: TMenuItem;
    mnuUpdateLicence: TMenuItem;
    mnuOpenScheduler: TMenuItem;
    popOpenScheduler: TMenuItem;
    mnuViewCompanyDetails: TMenuItem;
    Bang1: TMenuItem;
    MenuOpt_ResetIndividualUserCounts: TMenuItem;
    N4: TMenuItem;
    mnuEncryptDataFiles: TMenuItem;
    procedure OpenEnterprise(Sender: TObject);
    procedure OpenEBusiness(Sender: TObject);
    procedure OpenSentimail(Sender: TObject);
    procedure ModuleRelCodes(Sender: TObject);
    procedure EnterpriseUserCount(Sender: TObject);
    procedure EnterpriseRelCode(Sender: TObject);
    procedure ResyncCompanies(Sender: TObject);
    procedure ResetEntUserCounts(Sender: TObject);
    procedure ResetPlugInUserCounts(Sender: TObject);
    procedure Login(Sender: TObject);
    procedure LoggedInUserReport(Sender: TObject);
    procedure OpenRebuild(Sender: TObject);
    procedure RunBackup(Sender: TObject);
    procedure RunRestore(Sender: TObject);
    procedure DisplayMCMOptions(Sender: TObject);
    procedure ShowHelpContents(Sender: TObject);
    procedure SessionInformation(Sender: TObject);
    procedure ShowAbout(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mulCompanyListRowDblClick(Sender: TObject;
      RowIndex: Integer);
    procedure FormDblClick(Sender: TObject);
    procedure mnuUpdateLicenceClick(Sender: TObject);
    procedure mnuOpenSchedulerClick(Sender: TObject);
    procedure Bang1Click(Sender: TObject);
    procedure MenuOpt_ResetIndividualUserCountsClick(Sender: TObject);
    procedure mnuEncryptDataFilesClick(Sender: TObject);
  private
    { Private declarations }

    // Stores the list of command-line parameters passed into the MCM, and which need
    // to be passed onto Enterprise
    FCmdParam : ShortString;

    // Flag indicates whether an ESN error was found when loading the MCM and checking
    // out the security systems, see CheckESNIntegrity in ESNCheck.Paf for more info
    FESNError : Boolean;

    // Window Handle of splash screen - needed so that it can be shown/hidden as reqd
    FSplashHandle : hWnd;

    // Fields for changing Windows where it has historically caused problems
    ONCMetrics : PNonClientMetrics;  // Structure for changing the scroll bar width
    NCMetrics : PNonClientMetrics;   // Structure for changing the scroll bar width
    KeybDelay : SmallInt;            // Original Keyboard Delay
    KeybSpeed : DWord;               // Original Keyboard Repeat Rate
    ScrSaveActive : Boolean;         // Records whether Screen Savers were turned on

    // Flags to indicate the logged in status
    LoggedIn : Boolean;         // Indicates whether someone logged in using the user defined MCM Password
    SysLoggedIn : Boolean;      // Indicates whether someone logged in using the Enterprise Daily MCM Password
    SecLoggedIn : Boolean;      // Indicates whether someone is logged in using the Plug-In Password

    // Flag to indicate whether running in LITE installation
    IsLITE : Boolean;
    GotSecOverride : Boolean;

    // Record the login password so that Change Password can check against it
    LoggedPass : ShortString;

    // HM 11/08/03: Added flag to control whether the scrollbar size gets reset - causes
    //              tray icon corruption under Windows XP - AOK on all other OS's
    SetXPScrollSize : Boolean;

    // Flag controls whether checks are made on user rights, etc... when opening
    // Enterprise, Exchequer, etc...
    WantChecks : Boolean;

    // Property Set method for CmdParam : ShortString
    Procedure SetCmdParam(Value : ShortString);

    // Property Set method for ESNError : Boolean
    Procedure SetESNError(Value : Boolean);

    // Update the buttons panel based on the buttons visible status
    procedure UpdateButtonsPositions;

    // Update the enabled/visible status of buttons and menu options depending on
    // the logged in status, ESN Errors, MCM Options, etc...
    procedure UpdateSecurityStatus;
  protected
    // Return value indicates whether company paths should be shown in the company list
    Function ShowCompanyPaths : Boolean; Override;
  public
    { Public declarations }

    // Stores the list of command-line parameters passed into the MCM, and which need
    // to be passed onto Enterprise
    Property CmdParam : ShortString read FCmdParam write SetCmdParam;

    // Flag indicates whether an ESN error was found when loading the MCM and checking
    // out the security systems, see CheckESNIntegrity in ESNCheck.Paf for more info
    Property ESNError : Boolean read FESNError write SetESNError;

    // Window Handle of splash screen - needed so that it can be shown/hidden as reqd
    Property SplashHandle : hWnd Read FSplashHandle Write FSplashHandle;
  end;


implementation

{$R *.dfm}

Uses GlobVar, VarConst, BtrvU2, BTKeys1U, BTSupU1,
     APIUtil,         // Misc windows API wrapper routines
     CommonMCM,       // Common functionality called by the Standard and Bureau MCM windows
     CompUtil,        // PathToShort
     Crypto,          // Encryption functions
     EntLicence,      // EnterpriseLicence Object for accessing the Enterprise Licence details
     PWordDlg,        // Password Dialog
     SavePos,         // Object encapsulating the btrieve saveposition/restoreposition functions
     UcTestF,         // User Count debug form
     {$IFNDEF NOSHMEM}
       // EntComp.Dll only
       IRISLicF,        // IRIS Licencing
     {$ENDIF}
     SecWarn2,
     LicFuncU,
     StrUtils, VarRec2U,
     SecSup2U,        // Enterprise Security routines
     MainF,           // Data Encryption form
     GroupCompFile,   // Company-Group XReference File
     GroupsFile,      // Groups File
     GroupUsersFile,  // Definition of GroupUsr.Dat (GroupUsersF) and utility functions
     uSettings;

//-------------------------------------------------------------------------

procedure TfrmStandardMCM.FormCreate(Sender: TObject);
begin
  inherited;

  // These buttons are specific to the ancestor and must ALWAYS be hidden
  btnLoggedInUsersReports.Visible := False;
  btnBackupCompany.Visible := False;
  btnRestoreCompany.Visible := False;
  btnRebuildCompany.Visible := False;

  // These columns are specific to the ancestor and must ALWAYS be hidden
  mulCompanyList.Columns[3].Visible := False;

  // MH 12/03/2009: Added Bang menu option to allow MadExcept to be tested
  Bang1.Visible := FindCmdLineSwitch('Bang', ['-', '/', '\'], True);

  // Initialise local properties and variables
  FCmdParam := '';
  FESNError := False;
  FSplashHandle := 0;
  WantChecks := True;
  LoggedPass := '';

  // Flag to indicate whether running in LITE installation
  IsLITE := (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]);
  If IsLITE Then GotSecOverride := FileExists('c:\{1DE6857D-FA42-48F5-B3E9-96EDF132378A}') Else GotSecOverride := False;

  // MH 11/05/06: Added a backdoor allowing us to get to the old Exchequer System Release code for bypassing the activation
  If IsLITE Then IAOSecOverride := FileExists('c:\{C87AD61D-0BF0-434C-B4DA-12A02297F1CB}');

  // Changes various Windows settings to get around historical problems we have experienced
  CheckforXPScrollParams (SetXPScrollSize);
  ChangeWindowsSettings (SetXPScrollSize, ONCMetrics, NCMetrics, KeybDelay, KeybSpeed, ScrSaveActive);

  // Initialise the Logged In status, if the user defined MCM Password is blank,
  // automatically log them in
  LoggedIn := (Trim(SyssCompany^.CompOpt.OptPWord) = '');
  SysLoggedIn := False;
  SecLoggedIn := False;

  // Update the enabled/visible status of buttons and menu options depending on
  // the logged in status, ESN Errors, MCM Options, etc...
  UpdateSecurityStatus;

  // Update the buttons panel based on the buttons visible status
  UpdateButtonsPositions;

  Caption := Caption + ' [' + IfThen (EnterpriseLicence.IsSQL, 'MSSQL', 'Pervasive') + ' Edition]';
end;

//-------------------------------------------------------------------------

procedure TfrmStandardMCM.FormShow(Sender: TObject);
begin
  inherited;

  // Use SendMessage to hide the Splash Screen, this will unfortunately
  // also hide the start bar icon so we then force that to be visible again.
  //
  // NOTE: Can't use PostMessage as that executes the hide after the ShowWindow
  // is done so the Start Bar icon still disappears
  SendMessage (FSplashHandle, WM_SBSFDMsg, 1, 1);
  ShowWindow (Application.Handle, SW_SHOW);
end;

//-------------------------------------------------------------------------

procedure TfrmStandardMCM.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;

  // Changes various Windows settings to get around historical problems we have experienced
  RestoreWindowsSettings (SetXPScrollSize, ONCMetrics, NCMetrics, KeybDelay, KeybSpeed, ScrSaveActive);

  // Close the splash screen
  PostMessage (FSplashHandle, WM_SBSFDMsg, 0, 0);
end;

//-------------------------------------------------------------------------

// Property Set method for CmdParam : ShortString
Procedure TfrmStandardMCM.SetCmdParam(Value : ShortString);
Begin
  FCmdParam := Value;

  WantChecks := (Pos ('/NOCHECK', UpperCase(Value)) = 0);
End;

//------------------------------

// Property Set method for ESNError : Boolean
Procedure TfrmStandardMCM.SetESNError(Value : Boolean);
Begin
  If (FESNError <> Value) Then Begin
    FESNError := Value;
    UpdateSecurityStatus;
    UpdateButtonsPositions;
  End; { If (FESNError <> Value) }
End;

//-------------------------------------------------------------------------

// Update the enabled/visible status of buttons and menu options depending on
// the logged in status, ESN Errors, MCM Options, etc...
procedure TfrmStandardMCM.UpdateSecurityStatus;
Begin // UpdateSecurityStatus
  // Open Enterprise
  mnuOpenEnterprise.Visible := (Not ESNError);
  btnOpenEnterprise.Visible := mnuOpenEnterprise.Visible;
  popOpenEnterprise.Visible := mnuOpenEnterprise.Visible;

  // Open E-Business
  mnuOpenEBusiness.Visible := (Not ESNError) And (Not IsLITE) And (EnterpriseLicence.elModules [modEBus] <> mrNone);
  btnOpenEBusiness.Visible := mnuOpenEBusiness.Visible;
  popOpenEBusiness.Visible := mnuOpenEBusiness.Visible;

  // Open Scheduler
  mnuOpenScheduler.Visible := (Not ESNError) And (Not IsLITE) And FileExists(ExtractFilePath(Application.ExeName) + 'ExSched.Exe');
  popOpenScheduler.Visible := mnuOpenScheduler.Visible;

  // Open Sentimail
  mnuOpenSentimail.Visible := (Not ESNError) And (Not IsLITE) And (EnterpriseLicence.elModules [modElerts] <> mrNone);
  btnOpenSentimail.Visible := mnuOpenSentimail.Visible;
  popOpenSentimail.Visible := mnuOpenSentimail.Visible;

  // Open Rebuild
// MH 01/06/07: Moved Rebuild for v5.71.002 so that it always requires the MCM Password
//  If IsLITE Then
//    mnuOpenRebuild.Visible := SysLoggedIn And (Not ESNError)
//  Else
//    mnuOpenRebuild.Visible := (LoggedIn Or SysLoggedIn) And (Not ESNError);
  mnuOpenRebuild.Visible := SysLoggedIn And (Not ESNError);

  // Add Company
  mnuAddCompany.Visible := (LoggedIn Or SysLoggedIn) And (Not ESNError);
  btnAddCompany.Visible := mnuAddCompany.Visible;
  popAddCompany.Visible := mnuAddCompany.Visible;

  // Edit Company
  mnuEditCompany.Visible := (LoggedIn Or SysLoggedIn) And (Not ESNError);
  btnEditCompany.Visible := mnuAddCompany.Visible;
  popEditCompany.Visible := mnuAddCompany.Visible;

  // View Company
  mnuViewCompanyDetails.Visible := (SyssCompany^.CompOpt.OptShowViewCompany Or LoggedIn Or SysLoggedIn) And (Not ESNError);
  btnViewCompany.Visible := mnuViewCompanyDetails.Visible;
  popViewCompanyDetails.Visible := mnuViewCompanyDetails.Visible;

  // Delete Company
  mnuDeleteCompany.Visible := (LoggedIn Or SysLoggedIn) And (Not ESNError);
  btnDeleteCompany.Visible := mnuAddCompany.Visible;
  popDeleteCompany.Visible := mnuAddCompany.Visible;

  // Find Company
  btnFindCompany.Visible := (Not ESNError);

  // Update Licence
  mnuUpdateLicence.Visible := (Not ESNError) And IsLITE;

  // Licencing
  mnuModuleLicencing.Visible := ((Not IsLITE) Or GotSecOverride) And (SysLoggedIn Or SecLoggedIn);
  mnuEntUserCount.Visible := ((Not IsLITE) Or GotSecOverride) And SysLoggedIn;
  mnuEntReleaseCode.Visible := ((Not IsLITE) Or GotSecOverride Or IAOSecOverride) And SysLoggedIn;

  // Security Utilities
  mnuSecurityUtilities.Visible := SysLoggedIn;
  MenuOpt_ResetPIUsers.Visible := (Not IsLITE);   // Plug-Ins not available in LITE

  // MCM Login
  mnuMCMLogin.Visible := Not SysLoggedIn;

  // Tools Menu
  mnuLoggedInUserReport.Visible := LoggedIn Or SysLoggedIn Or SyssCompany^.CompOpt.OptShowCheckUsr;
  // MH 04/06/07: Modified to hide Backup/Restore if paths not set in Company Options
  mnuRunBackup.Visible := (Trim(SyssCompany^.CompOpt.OptBackup) <> '') And (LoggedIn Or SysLoggedIn Or (Not SyssCompany^.CompOpt.OptHideBackup));
  mnuRunRestore.Visible := (Trim(SyssCompany^.CompOpt.OptRestore) <> '') And (LoggedIn Or SysLoggedIn);
  mnuMCMOptions.Visible := LoggedIn Or SysLoggedIn;

  //PR: 08/11/2017 ABSEXCH-19303
  mnuEncryptDataFiles.Visible := not EnterpriseLicence.IsSQL and
                                 // MH 21/11/2017 2018-R1 ABSEXCH-19452: Added check on new module release code
                                 (EnterpriseLicence.elModules[modPervEncrypt] > mrNone)
                                 And (LoggedIn or SysLoggedIn);

  // Hide Tools menu if all options invisible
  mnuTools.Visible := mnuMCMOptions.Visible Or mnuLoggedInUserReport.Visible Or
                      mnuRunBackup.Visible Or mnuRunRestore.Visible or
                      mnuEncryptDataFiles.Visible;
End; // UpdateSecurityStatus

//-------------------------------------------------------------------------

// Update the buttons panel based on the buttons visible status
procedure TfrmStandardMCM.UpdateButtonsPositions;
Var
  NextBtnTop : SmallInt;
  GotOpenBtn : Boolean;
Begin // UpdateButtons
  LockWindowUpdate (Handle);

  GotOpenBtn := False;
  NextBtnTop := 1;
  If btnOpenEnterprise.Visible Then
  Begin
    btnOpenEnterprise.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnOpenEnterprise.Height + 3;
    GotOpenBtn := True;
  End; // If btnOpenEnterprise.Visible
  If btnOpenEBusiness.Visible Then
  Begin
    btnOpenEBusiness.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnOpenEBusiness.Height + 3;
    GotOpenBtn := True;
  End; // If btnOpenEBusiness.Visible
  If btnOpenSentimail.Visible Then
  Begin
    btnOpenSentimail.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnOpenSentimail.Height + 3;
    GotOpenBtn := True;
  End; // If btnOpenSentimail.Visible
  If GotOpenBtn Then
  Begin
    // Insert spacer between open and maintenance buttons
    NextBtnTop := NextBtnTop + 5;
  End; // If GotOpenBtn

  If btnAddCompany.Visible Then
  Begin
    btnAddCompany.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnAddCompany.Height + 3;
  End; // If btnAddCompany.Visible
  If btnEditCompany.Visible Then
  Begin
    btnEditCompany.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnEditCompany.Height + 3;
  End; // If btnEditCompany.Visible
  If btnViewCompany.Visible Then
  Begin
    btnViewCompany.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnViewCompany.Height + 3;
  End; // If btnViewCompany.Visible
  If btnDeleteCompany.Visible Then
  Begin
    btnDeleteCompany.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnDeleteCompany.Height + 3;
  End; // If btnDeleteCompany.Visible
  If btnFindCompany.Visible Then
    btnFindCompany.Top := NextBtnTop;

  LockWindowUpdate (0);
End; // UpdateButtons

//-------------------------------------------------------------------------

procedure TfrmStandardMCM.OpenEnterprise(Sender: TObject);
Var
  CompDets : CompanyDetRec;
begin
  // Check that a company is selected in the list and the user is allowed to do this
  If (mulCompanyList.Selected > -1) And btnOpenEnterprise.Visible Then
  Begin
    // Save form position and sizing
    SetColoursUndPositions (1);

    // Load the selected record into the global GroupCompFileRec record
    bdsCompanyList.GetRecord;

    // Get the company details from the cache, this includes details of
    // directory and security checks for reporting errors in the company
    FillChar (CompDets, SizeOf(CompDets), #0);
    CompDets.CompCode := mulCompanyList.DesignColumns[0].Items[mulCompanyList.Selected];

    If RunEnterprise (CompDets, FCmdParam, FSplashHandle, WantChecks) Then
    Begin
      Close;
    End; // If RunEnterprise (...
  End; // If (mulCompanyList.Selected > -1) And btnOpenEnterprise.Visible
end;

//------------------------------

procedure TfrmStandardMCM.mulCompanyListRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  inherited;
  OpenEnterprise(Sender);
end;

//------------------------------

procedure TfrmStandardMCM.OpenEBusiness(Sender: TObject);
Var
  CompDets : CompanyDetRec;
begin
  // Check that a company is selected in the list and the user is allowed to do this
  If (mulCompanyList.Selected > -1) And btnOpenEBusiness.Visible Then
  Begin
    // Save form position and sizing
    SetColoursUndPositions (1);

    // Checks out the specified dataset and returns TRUE if OK to use it
    If CheckCompany (CompDets, mulCompanyList.DesignColumns[0].Items[mulCompanyList.Selected], WantChecks) Then
    Begin
      If RunEBus (CompDets) Then
      Begin
        Close;
      End; // If RunEBus (CompDets)
    End; // If CheckCompany (...
  End; // If (mulCompanyList.Selected > -1) And btnEBusiness.Visible
end;

//------------------------------

procedure TfrmStandardMCM.OpenSentimail(Sender: TObject);
Var
  CompDets : CompanyDetRec;
begin
  // Check that a company is selected in the list and the user is allowed to do this
  If (mulCompanyList.Selected > -1) And btnOpenSentimail.Visible Then
  Begin
    // Save form position and sizing
    SetColoursUndPositions (1);

    // Checks out the specified dataset and returns TRUE if OK to use it
    If CheckCompany (CompDets, mulCompanyList.DesignColumns[0].Items[mulCompanyList.Selected], WantChecks) Then
    Begin
      If RunSentimail (CompDets) Then
      Begin
        Close;
      End; // If RunEBus (CompDets)
    End; // If CheckCompany (...
  End; // If (mulCompanyList.Selected > -1) And btnSentimail.Visible
end;

//------------------------------

procedure TfrmStandardMCM.OpenRebuild(Sender: TObject);
begin
  // Check that a company is selected in the list and the user is allowed to do this
  If (mulCompanyList.Selected > -1) Then
  Begin
    RunRebuild (Self, mulCompanyList.DesignColumns[0].Items[mulCompanyList.Selected], SysLoggedIn);
  End; // If (mulCompanyList.Selected > -1)
end;

//------------------------------

procedure TfrmStandardMCM.ModuleRelCodes(Sender: TObject);
begin
  ModuleReleaseCodeDialog (Self, SecLoggedIn);
end;

//------------------------------

procedure TfrmStandardMCM.EnterpriseUserCount(Sender: TObject);
begin
  // Displays the Enterprise User Count dialog
  EnterpriseUserCountDialog (Self);
end;

//------------------------------

procedure TfrmStandardMCM.EnterpriseRelCode(Sender: TObject);
begin
  EntReleaseCode;
end;

//------------------------------

procedure TfrmStandardMCM.ResyncCompanies(Sender: TObject);
begin
  ResynchCompanies;

  // Clear the company cache to force each companies security to be rechecked
  // and force the list to repaint
  CompInfoCache.Clear;
  mulCompanyList.RefreshDB;
end;

//------------------------------

// MH 25/02/2013 v7.0.2 ABSEXCH-13994: Allows users to clear down individual user counts
procedure TfrmStandardMCM.MenuOpt_ResetIndividualUserCountsClick(Sender: TObject);
begin
  CommonMCM.ResetIndividualEntUserCounts(Self);
end;

//------------------------------

procedure TfrmStandardMCM.ResetEntUserCounts(Sender: TObject);
begin
  CommonMCM.ResetEntUserCounts(Self);
end;

//------------------------------

procedure TfrmStandardMCM.ResetPlugInUserCounts(Sender: TObject);
begin
  CommonMCM.ResetPlugInUserCounts;
end;

//------------------------------

procedure TfrmStandardMCM.Login(Sender: TObject);
Var
  PasswordDialog : TPasswordDialog;
  Ok             : Boolean;
begin
  PasswordDialog := TPasswordDialog.Create(Self);
  Try
    PasswordDialog.HelpContext := 17;

    LoggedIn := (Trim(SyssCompany^.CompOpt.OptPWord) = '');
    SysLoggedIn := False;
    SecLoggedIn := False;
    LoggedPass := '';

    { Get Password }
    PasswordDialog.Title := 'Password Required';
    PasswordDialog.Msg := 'Please enter the MCM Password to continue';

    Ok := PasswordDialog.Execute;

    If OK Then
    Begin
      LoggedIn := (PasswordDialog.PassWord = SyssCompany^.CompOpt.OptPWord);

      If (Not LoggedIn) Then Begin
        // HM 17/07/00: Intermittant problems with password, changed as precaution
        //SysLoggedIn := (PasswordDialog.PassWord = Encode(Get_TodaySecurity));
        // HM 07/02/02: Changed from Daily Password to MCM Password
        //SysLoggedIn := (PasswordDialog.PassWord = EncodeKey (23130, Get_TodaySecurity));
        SysLoggedIn := (PasswordDialog.PassWord = EncodeKey (23130, Generate_ESN_BaseSecurity(SyssCompany^.CompOpt.optSystemESN, 245, 0, 0)));

        If (Not SysLoggedIn) Then Begin
          // HM 24/01/02: Try new v5.00 Third-Party Security Password
          SecLoggedIn := (PasswordDialog.PassWord = EncodeKey (23130, Generate_ESN_BaseSecurity(SyssCompany^.CompOpt.optSystemESN, 248, 0, 0)));
        End; { If (Not SysLoggedIn) }
      End; { If (Not LoggedIn) }

      { Take Copy of password for options dialog }
      If LoggedIn Or SysLoggedIn Or SecLoggedIn Then
        LoggedPass := PasswordDialog.PassWord
      Else
        MessageDlg ('The password was not valid - login failed', mtWarning, [mbOk], 0);
    End; // If OK

    // Update the window to reflect the login status
    UpdateSecurityStatus;
    UpdateButtonsPositions;

    // Update the list as we may need to show paths now
    mulCompanyList.RefreshDB;
  Finally
    FreeAndNIL(PasswordDialog);
  End; // Try..Finally
end;

//------------------------------

procedure TfrmStandardMCM.LoggedInUserReport(Sender: TObject);
begin
  RunLoggedInUsersReport (Self);
end;

//------------------------------

procedure TfrmStandardMCM.RunBackup(Sender: TObject);
begin
  RunBackupOrRestore (Self, mulCompanyList.DesignColumns[0].Items[mulCompanyList.Selected], brBackup);
end;

//------------------------------

procedure TfrmStandardMCM.RunRestore(Sender: TObject);
begin
  RunBackupOrRestore (Self, mulCompanyList.DesignColumns[0].Items[mulCompanyList.Selected], brRestore);
end;

//------------------------------

procedure TfrmStandardMCM.DisplayMCMOptions(Sender: TObject);
begin
  { Update companies list }
  CommonMCM.DisplayMCMOptions(Self , LoggedPass, SysLoggedIn);
  UpdateSecurityStatus;
  SendMessage (Self.Handle, WM_CustGetRec, 300, 0);
end;

//------------------------------


procedure TfrmStandardMCM.ShowHelpContents(Sender: TObject);
begin
  Application.HelpCommand(HELP_Finder,0);
end;

//------------------------------

procedure TfrmStandardMCM.SessionInformation(Sender: TObject);
begin
  DisplaySessionInfo (Self);
end;

//------------------------------

procedure TfrmStandardMCM.ShowAbout(Sender: TObject);
begin
  // Displays the MCM Help-About dialog
  DisplayHelpAbout (Self, LoggedIn Or SysLoggedIn);
end;

//-------------------------------------------------------------------------

// Return value indicates whether company paths should be shown in the company list
Function TfrmStandardMCM.ShowCompanyPaths : Boolean;
Begin // ShowCompanyPaths
  Result := (Not SyssCompany^.CompOpt.OptHidePath) Or LoggedIn Or SysLoggedIn;
End; // ShowCompanyPaths

//-------------------------------------------------------------------------

procedure TfrmStandardMCM.FormDblClick(Sender: TObject);
begin
  inherited;

  If FileExists(ExtractFilePath(Application.ExeName) + 'ShowUserInfo') Or FileExists ('C:\6453892.TMP') Or FileExists ('C:\{9F7498F9-C695-4FDC-803B-08B07E416C9D}.TMP') Then
  Begin
    With TfrmUCountTest.Create(Self) Do
    Begin
      Try
        ShowModal;
      finally
        Free;
      End;
    End; // With TfrmUCountTest.Create(Self)
  End; // If FileExists ('C:\6453892.TMP')
end;

//-------------------------------------------------------------------------

// LITE only - displays the update licence screens allowing a user to either download their
// licence or manual enter it
procedure TfrmStandardMCM.mnuUpdateLicenceClick(Sender: TObject);
begin
  {$IFNDEF NOSHMEM}
    If IsLITE Then UpdateIRISLicence;
  {$ENDIF} // NOSHMEM
end;

//-------------------------------------------------------------------------

procedure TfrmStandardMCM.mnuOpenSchedulerClick(Sender: TObject);
Var
  CompDets : CompanyDetRec;
begin
  // Check that a company is selected in the list and the user is allowed to do this
  If (mulCompanyList.Selected > -1) And mnuOpenScheduler.Visible Then
  Begin
    // Save form position and sizing
    SetColoursUndPositions (1);

    // Checks out the specified dataset and returns TRUE if OK to use it
    If CheckCompany (CompDets, mulCompanyList.DesignColumns[0].Items[mulCompanyList.Selected], WantChecks) Then
    Begin
      If RunScheduler (CompDets) Then
      Begin
        Close;
      End; // If RunEBus (CompDets)
    End; // If CheckCompany (...
  End; // If (mulCompanyList.Selected > -1) And mnuOpenScheduler.Visible
end;

//-------------------------------------------------------------------------

//Initialization
//  ShowMessage ('NomViewRec: ' + IntToStr(SizeOf(NomViewRec)));
//  ShowMessage ('StockRec: ' + IntToStr(SizeOf(StockRec)));
procedure TfrmStandardMCM.Bang1Click(Sender: TObject);
begin
  Raise Exception.Create ('TfrmStandardMCM.Bang1Click');
end;

//=========================================================================

procedure TfrmStandardMCM.mnuEncryptDataFilesClick(Sender: TObject);
begin
  //close all open files
  Close_Files(True);
  oSettings.CloseFile;

  //Show encrypt data form
  EncryptFiles(Self);

  //Reopen files
  Open_System(CompF, CompF);
  oSettings.ReopenFile(True);
  {$IFDEF BUREAU}
    Open_System(GroupF, GroupF);
    Open_System(GroupCompXRefF, GroupCompXRefF);
    Open_System(GroupUsersF, GroupUsersF);
  {$ENDIF}
end;

end.

