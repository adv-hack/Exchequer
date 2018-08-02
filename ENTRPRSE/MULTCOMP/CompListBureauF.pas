unit CompListBureauF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, uExDatasets, uBTGlobalDataset, StdCtrls, ExtCtrls,
  uMultiList, uDBMultiList, BTSupU1, TCustom, CompanyCache;

type
  TfrmBureauMCM = class(TForm)
    mulCompanyList: TDBMultiList;
    panButtons: TPanel;
    CloseBtn: TButton;
    ScrollBox1: TScrollBox;
    btnFindCompany: TButton;
    btnOpenEnterprise: TButton;
    btnOpenEBusiness: TButton;
    btnOpenSentimail: TButton;
    bdsCompanyList: TBTGlobalDataset;
    MainMenu1: TMainMenu;
    Menu_File: TMenuItem;
    mnuOpenEnterprise: TMenuItem;
    MenuOpt_SepBar4: TMenuItem;
    mnuOpenEBusiness: TMenuItem;
    mnuOpenSentimail: TMenuItem;
    mnuModuleLicencing: TMenuItem;
    mnuEntUserCount: TMenuItem;
    mnuEntReleaseCode: TMenuItem;
    MenuOpt_SepBar8: TMenuItem;
    mnuSecurityUtilities: TMenuItem;
    MenuOpt_ResyncComps: TMenuItem;
    MenuOpt_ResetUserCounts: TMenuItem;
    MenuOpt_ResetPIUsers: TMenuItem;
    MenuOpt_SepBar1: TMenuItem;
    MenuOpt_Exit: TMenuItem;
    mnuOpenRebuild: TMenuItem;
    MenuOpt_SepBar10: TMenuItem;
    MenuOpt_SepBar5: TMenuItem;
    mnuMCMOptions: TMenuItem;
    Menu_Help: TMenuItem;
    MenuOpt_HelpCont: TMenuItem;
    MenuOpt_SepBar2: TMenuItem;
    MenuOpt_SessionInfo: TMenuItem;
    MenuOpt_About: TMenuItem;
    PopupMenu1: TPopupMenu;
    PopupOpt_SepBar2: TMenuItem;
    popFormProperties: TMenuItem;
    popSavePosition: TMenuItem;
    mnuAdministration: TMenuItem;
    mnuCompaniesList: TMenuItem;
    mnuGroupsList: TMenuItem;
    btnChangePWord: TSBSButton;
    mnuLicencing: TMenuItem;
    popOpenEnterprise: TMenuItem;
    popOpenEBusiness: TMenuItem;
    popOpenSentimail: TMenuItem;
    N1: TMenuItem;
    popFindCompany: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    mnuOpenScheduler: TMenuItem;
    popOpenScheduler: TMenuItem;
    N4: TMenuItem;
    popViewCompanyDetails: TMenuItem;
    mnuViewCompanyDetails: TMenuItem;
    N5: TMenuItem;
    MenuOpt_ResetIndividualUserCounts: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure bdsCompanyListGetBufferSize(Sender: TObject;
      var TheBufferSize: Integer);
    procedure bdsCompanyListGetDataRecord(Sender: TObject;
      var TheDataRecord: Pointer);
    procedure bdsCompanyListGetFileVar(Sender: TObject;
      var TheFileVar: pFileVar);
    procedure bdsCompanyListGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure OpenEnterprise(Sender: TObject);
    procedure OpenEBusiness(Sender: TObject);
    procedure OpenSentimail(Sender: TObject);
    procedure CloseMCM(Sender: TObject);
    procedure mnuCompaniesListClick(Sender: TObject);
    procedure mnuGroupsListClick(Sender: TObject);
    procedure btnChangePWordClick(Sender: TObject);
    procedure btnFindCompanyClick(Sender: TObject);
    procedure mnuMCMOptionsClick(Sender: TObject);
    procedure mnuEntReleaseCodeClick(Sender: TObject);
    procedure mnuEntUserCountClick(Sender: TObject);
    procedure mnuModuleLicencingClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mulCompanyListRowDblClick(Sender: TObject;
      RowIndex: Integer);
    procedure mnuOpenRebuildClick(Sender: TObject);
    procedure MenuOpt_ResyncCompsClick(Sender: TObject);
    procedure MenuOpt_ResetUserCountsClick(Sender: TObject);
    procedure MenuOpt_ResetPIUsersClick(Sender: TObject);
    procedure MenuOpt_HelpContClick(Sender: TObject);
    procedure MenuOpt_SessionInfoClick(Sender: TObject);
    procedure MenuOpt_AboutClick(Sender: TObject);
    procedure popFormPropertiesClick(Sender: TObject);
    procedure popSavePositionClick(Sender: TObject);
    procedure mulCompanyListCellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure mnuOpenSchedulerClick(Sender: TObject);
    procedure ViewCompanyDets(Sender: TObject);
    procedure MenuOpt_ResetIndividualUserCountsClick(Sender: TObject);
  private
    { Private declarations }
    DoneRestore : Boolean;

    // List of company details stored for performance reasons
    CompInfoCache : TCompanyInfoCache;

    // Stores the list of command-line parameters passed into the MCM, and which need
    // to be passed onto Enterprise
    FCmdParam : ShortString;

    // Flag indicates whether an ESN error was found when loading the MCM and checking
    // out the security systems, see CheckESNIntegrity in ESNCheck.Paf for more info
    FESNError : Boolean;

    // Window Handle of splash screen - needed so that it can be shown/hidden as reqd
    FSplashHandle : hWnd;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    // Flag controls whether checks are made on user rights, etc... when opening
    // Enterprise, Exchequer, etc...
    WantChecks : Boolean;

    // Controls the loading/saving of the colours and positions
    //
    // Mode   0=Load Details, 1=Save Details, 2=Delete Details
    procedure SetColoursUndPositions (Const Mode : Byte);

    // Property Set method for CmdParam : ShortString
    Procedure SetCmdParam(Value : ShortString);

    // Property Set method for ESNError : Boolean
    Procedure SetESNError(Value : Boolean);

    // Update the buttons panel based on the buttons visible status
    procedure UpdateButtonsPositions;

    // Update the enabled/visible status of buttons and menu options depending on
    // the logged in status, ESN Errors, MCM Options, etc...
    procedure UpdateSecurityStatus;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
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

Uses GlobVar, VarConst,
     BureauSecurity,     // SecurityManager Object
     ChangeUserPWord,    // Routines for changing a Group Users Password
     ChkComp,            // Routines for checking the validity of a company dataset
     CommonMCM,          // Common functionality called by the Standard and Bureau MCM windows
     EntLicence,         // EnterpriseLicence Object for accessing the Enterprise Licence details
     GroupCompFile,      // Company-Group XReference File
     GroupListF,         // Group List window
     GroupUsersFile,     // Definition of GroupUsr.Dat (GroupUsersF) and utility functions
     MaintainCompaniesF, // Maintain Companies window
     MCMFindF,           // Find Company dialog
     uSettings,          // Colour/Position editing and saving routines
     VAOUtil,
     CompDet,
     BTKeys1U, BtrvU2;

//-------------------------------------------------------------------------

procedure TfrmBureauMCM.FormCreate(Sender: TObject);
begin
  // Set Client dimensions and anchoring at runtime to get around the XP
  // vertical resizing issues
  ClientHeight := 192;
  ClientWidth := 468;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 400;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 139;      // captions into account

  // Initialise local properties and variables
  FCmdParam := '';
  FESNError := False;
  FSplashHandle := 0;
  WantChecks := True;

  // List of company details stored for performance reasons
  CompInfoCache := TCompanyInfoCache.Create;

  // Update the enabled/visible status of buttons and menu options depending on
  // the logged in status, ESN Errors, MCM Options, etc...
  UpdateSecurityStatus;

  // Update the buttons panel based on the buttons visible status
  UpdateButtonsPositions;

  Case SecurityManager.smUserType Of
    utSystem   : Caption := 'Company List (System Mode)';
    utAdmin    : Caption := 'Company List (Bureau Admin Mode)';
    utNormal   : Caption := 'Company List for ' + Trim(SecurityManager.smGroupCode);
  Else
    Raise Exception.Create ('TfrmBureauMCM.FormCreate: Unknown User Type(' + IntToStr(Ord(SecurityManager.smUserType)) + ')');
  End; // Case SecurityManager.smUserType

  // Only show the Company List if a normal user has logged in
  If (SecurityManager.smUserType = utNormal) Then
  Begin
    // Activate the list of companies for the group
    bdsCompanyList.SearchKey := SecurityManager.smGroupCode;
    mulCompanyList.Active := True;
  End; // If (SecurityManager.smUserType = utNormal)

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  SetColoursUndPositions (0);
end;

//------------------------------

procedure TfrmBureauMCM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Save colours/positions/sizes/etc...
  SetColoursUndPositions (1);

  // Close the splash screen
  PostMessage (FSplashHandle, WM_SBSFDMsg, 0, 0);
end;

//------------------------------

procedure TfrmBureauMCM.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(CompInfoCache);
end;

//------------------------------

procedure TfrmBureauMCM.FormShow(Sender: TObject);
begin
  // Hide the Splash Screen
  PostMessage (FSplashHandle, WM_SBSFDMsg, 1, 1);
end;

//-------------------------------------------------------------------------

Procedure TfrmBureauMCM.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
Begin
  With Message.MinMaxInfo^ Do
  Begin
    ptMinTrackSize.X:=MinSizeX;
    ptMinTrackSize.Y:=MinSizeY;
  End; // With Message.MinMaxInfo^

  Message.Result:=0;

  Inherited;
end;

//-------------------------------------------------------------------------

procedure TfrmBureauMCM.bdsCompanyListGetBufferSize(Sender: TObject;
  var TheBufferSize: Integer);
begin
  TheBufferSize := FileRecLen[GroupCompXRefF];
end;

//------------------------------

procedure TfrmBureauMCM.bdsCompanyListGetDataRecord(Sender: TObject;
  var TheDataRecord: Pointer);
begin
  TheDataRecord := RecPtr[GroupCompXRefF];
end;

//------------------------------

procedure TfrmBureauMCM.bdsCompanyListGetFileVar(Sender: TObject;
  var TheFileVar: pFileVar);
begin
  TheFileVar := @F[GroupCompXRefF];
end;

//------------------------------

procedure TfrmBureauMCM.bdsCompanyListGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
Var
  pCompanyXRef  : ^GroupCompaniesFileRecType;
  CompDets      : CompanyDetRec;
begin
  pCompanyXRef := pData;

  Case FieldName[1] Of
    '0'  : FieldValue := Trim(pCompanyXRef^.gcCompanyCode);
    '1'  : Begin
             // Get the company details from the cache, this includes details of
             // directory and security checks for reporting errors in the company
             FillChar (CompDets, SizeOf(CompDets), #0);
             CompDets.CompCode := pCompanyXRef.gcCompanyCode;
             CompInfoCache.GetCompanyDetails (CompDets);

             // If the analysis of the company has shown a problem the report it,
             // else shown the Company Name
             If (CompDets.CompAnal = 1) Then
             Begin
               // OK - Display Company Path
               FieldValue := Trim(CompDets.CompName);
             End // If (CompDets.CompAnal = 1)
             Else
             Begin
               // Error - display error message
               FieldValue := '*** Error: ' + GetCompDirError (CompDets.CompAnal) + '***';
             End; // Else
           End; // '2'
  End; // Case FieldName[1]
end;

//-------------------------------------------------------------------------

// Property Set method for CmdParam : ShortString
Procedure TfrmBureauMCM.SetCmdParam(Value : ShortString);
Begin
  FCmdParam := Value;

  WantChecks := (Pos ('/NOCHECK', UpperCase(Value)) = 0);
End;

//------------------------------

// Property Set method for ESNError : Boolean
Procedure TfrmBureauMCM.SetESNError(Value : Boolean);
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
procedure TfrmBureauMCM.UpdateSecurityStatus;
Begin // UpdateSecurityStatus
  // File Menu -------------------------------------------

  // Open Enterprise
  mnuOpenEnterprise.Visible := SecurityManager.smUserPermissions[upOpenEnterprise] And
                               (SecurityManager.smUserType = utNormal) And
                               (Not ESNError);
  btnOpenEnterprise.Visible := mnuOpenEnterprise.Visible;
  popOpenEnterprise.Visible := mnuOpenEnterprise.Visible;

  // Open Scheduler
  mnuOpenScheduler.Visible := SecurityManager.smUserPermissions[upOpenScheduler] And
                              (SecurityManager.smUserType = utNormal) And
                              (Not EnterpriseLicence.IsLITE) And   // IAO Bureau
                              (Not ESNError);
  popOpenScheduler.Visible := mnuOpenScheduler.Visible;

  // Open E-Business - Check E-Bus is licenced
  mnuOpenEBusiness.Visible := SecurityManager.smUserPermissions[upOpenEBusiness] And
                              (SecurityManager.smUserType = utNormal) And
                              (EnterpriseLicence.elModules [modEBus] <> mrNone) And
                              (Not ESNError);
  btnOpenEBusiness.Visible := mnuOpenEBusiness.Visible;
  popOpenEBusiness.Visible := mnuOpenEBusiness.Visible;

  // Open Sentimail - Check Sentimail is licenced
  mnuOpenSentimail.Visible := SecurityManager.smUserPermissions[upOpenSentimail] And
                              (SecurityManager.smUserType = utNormal) And
                              (EnterpriseLicence.elModules [modElerts] <> mrNone) And
                              (Not ESNError);
  btnOpenSentimail.Visible := mnuOpenSentimail.Visible;
  popOpenSentimail.Visible := mnuOpenSentimail.Visible;

  // Open Rebuild
  mnuOpenRebuild.Visible := SecurityManager.smUserPermissions[upRebuildGroup] And
                            (SecurityManager.smUserType = utNormal) And
                            (Not ESNError);

  // Security Utilities
  mnuSecurityUtilities.Visible := (SecurityManager.smUserType = utSystem);

  // Administration Menu ---------------------------------

  // Companies List
  mnuCompaniesList.Visible := SecurityManager.smUserPermissions[upAccessCompanies] And (Not ESNError);

  // Groups List
  mnuGroupsList.Visible := SecurityManager.smUserPermissions[upAccessGroups] And (Not ESNError);

  // MCM Options
  mnuMCMOptions.Visible := SecurityManager.smUserPermissions[upEditMCMOptions] And (Not ESNError);

  // Licencing & Release Codes submenu
  // HM 07/12/04: Hide Licencing options for Bureau Administrator running under VAO
  mnuLicencing.Visible := (
                           (SecurityManager.smUserType = utSystem)
                           Or
                           ((SecurityManager.smUserType = utAdmin) And (VAOInfo.vaoMode <> smVAO))
                          )
                          And (Not ESNError);

  // Hide Admin menu if all invisible
  mnuAdministration.Visible := mnuCompaniesList.Visible Or mnuGroupsList.Visible Or mnuMCMOptions.Visible Or
                               mnuLicencing.Visible;

  // Buttons, etc... -------------------------------------

  // Find Company - List only works for normal users
  btnFindCompany.Visible := (SecurityManager.smUserType = utNormal) And (Not ESNError);
  popFindCompany.Visible := btnFindCompany.Visible;

  // Change Password - only applies to normal users
  // HM 07/12/04: Extended for Bureau Administrator running under VAO
  btnChangePWord.Visible := (
                             ((SecurityManager.smUserType = utNormal) And SecurityManager.smUserPermissions[upChangeOwnPassword]) Or
                             ((SecurityManager.smUserType = utAdmin) And (VAOInfo.vaoMode = smVAO))
                            ) And (Not ESNError);
End; // UpdateSecurityStatus

//-------------------------------------------------------------------------

// Update the buttons panel based on the buttons visible status
procedure TfrmBureauMCM.UpdateButtonsPositions;
Var
  NextBtnTop : SmallInt;
  GotOpenBtn : Boolean;
Begin // UpdateButtonsPositions
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

  If btnFindCompany.Visible Then
  Begin
    btnFindCompany.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnFindCompany.Height + 3;
  End; // If btnFindCompany.Visible
  If btnChangePWord.Visible Then
    btnChangePWord.Top := NextBtnTop;

  LockWindowUpdate (0);
End; // UpdateButtonsPositions

//-------------------------------------------------------------------------

procedure TfrmBureauMCM.CloseMCM(Sender: TObject);
begin
  Close;
end;

//------------------------------

procedure TfrmBureauMCM.OpenEnterprise(Sender: TObject);
Var
  CompDets     : CompanyDetRec;
begin
  // Check a company is selected in the list
  If (mulCompanyList.Selected > -1) Then
  Begin
    // Save form position and sizing
    SetColoursUndPositions (1);

    // Setup a fake company details record for the selected row, the CheckCompany
    // call will load the full details as part of the checks
    FillChar (CompDets, SizeOf(CompDets), #0);
    CompDets.CompCode := mulCompanyList.DesignColumns[0].Items[mulCompanyList.Selected];

    // Checkout the dataset and run Enterprise if OK - Close MCM if successful
    If RunEnterprise (CompDets, FCmdParam, FSplashHandle, WantChecks, SecurityManager.smUserCode) Then
    Begin
      Close;
    End; // If RunEnterprise (...
  End; // If (mulCompanyList.Selected > -1)
end;

//------------------------------

procedure TfrmBureauMCM.OpenSentimail(Sender: TObject);
Var
  CompDets : CompanyDetRec;
begin
  // Check a company is selected in the list
  If (mulCompanyList.Selected > -1) Then
  Begin
    // Save form position and sizing
    SetColoursUndPositions (1);

    // Setup a fake company details record for the selected row, the CheckCompany
    // call will load the full details as part of the checks
    FillChar (CompDets, SizeOf(CompDets), #0);

    // Checks out the specified dataset and returns TRUE if OK to use it
    If CheckCompany (CompDets, mulCompanyList.DesignColumns[0].Items[mulCompanyList.Selected], WantChecks) Then
    Begin
      If RunSentimail (CompDets) Then
      Begin
        Close;
      End; // If RunEBus (CompDets)
    End; // If CheckCompany (...
  End; // If (mulCompanyList.Selected > -1)
end;

//------------------------------

procedure TfrmBureauMCM.OpenEBusiness(Sender: TObject);
Var
  CompDets : CompanyDetRec;
begin
  // Check a company is selected in the list
  If (mulCompanyList.Selected > -1) Then
  Begin
    // Save form position and sizing
    SetColoursUndPositions (1);

    // Setup a fake company details record for the selected row, the CheckCompany
    // call will load the full details as part of the checks
    FillChar (CompDets, SizeOf(CompDets), #0);

    // Checks out the specified dataset and returns TRUE if OK to use it
    If CheckCompany (CompDets, mulCompanyList.DesignColumns[0].Items[mulCompanyList.Selected], WantChecks) Then
    Begin
      If RunEBus (CompDets) Then
      Begin
        Close;
      End; // If RunEBus (CompDets)
    End; // If CheckCompany (...
  End; // If (mulCompanyList.Selected > -1)
end;

//------------------------------

procedure TfrmBureauMCM.btnFindCompanyClick(Sender: TObject);
Var
  CompanyRec : CompanyDetRec;
begin
  If FindGroupCompany (Self, SecurityManager.smGroupCode, CompanyRec) Then
  Begin
    mulCompanyList.SearchColumn (0, mulCompanyList.SortAsc, Trim(CompanyRec.CompCode));
  End; // If FindGroupCompany (Self, SecurityManager.smGroupCode, CompanyRec)
end;

//------------------------------

procedure TfrmBureauMCM.btnChangePWordClick(Sender: TObject);
begin
  // HM 07/12/04: Extended to handle Bureau Administrator password when running under VAO
  If (SecurityManager.smUserType = utAdmin) And (VAOInfo.vaoMode = smVAO) Then
  Begin
    ChangeBureauAdminPassword (Self);
  End // If (SecurityManager.smUserType = utAdmin) And (VAOInfo.vaoMode = smVAO)
  Else
    // Ask for the users password as this is a user specific area
    ChangeUserPassword (Self, SecurityManager.smUserCode, True);
end;

//------------------------------

procedure TfrmBureauMCM.mnuOpenRebuildClick(Sender: TObject);
begin
  // Check a company is selected in the list
  If (mulCompanyList.Selected > -1) Then
  Begin
    // Runs the rebuild module for the selected company
    RunRebuild (Self, mulCompanyList.DesignColumns[0].Items[mulCompanyList.Selected], (SecurityManager.smUserType = utSystem));
  End; // If (mulCompanyList.Selected > -1)
end;

//------------------------------

procedure TfrmBureauMCM.mnuCompaniesListClick(Sender: TObject);
begin
  MaintainCompaniesList (Self);
end;

//------------------------------

procedure TfrmBureauMCM.mnuGroupsListClick(Sender: TObject);
Var
  frmGroupList: TfrmGroupList;
begin
  frmGroupList := TfrmGroupList.Create(Self);
  Try
    frmGroupList.ShowModal;
  Finally
    FreeAndNIL(frmGroupList);
  End; // Try..Finally
end;

//------------------------------

procedure TfrmBureauMCM.mnuEntReleaseCodeClick(Sender: TObject);
begin
  EntReleaseCode;
end;

//------------------------------

procedure TfrmBureauMCM.mnuEntUserCountClick(Sender: TObject);
begin
  // Displays the Enterprise User Count dialog
  EnterpriseUserCountDialog (Self);
end;

//------------------------------

procedure TfrmBureauMCM.mnuModuleLicencingClick(Sender: TObject);
begin
{ TODO : Plug-In password not supported }
  ModuleReleaseCodeDialog (Self, False);
end;

//------------------------------

procedure TfrmBureauMCM.mnuMCMOptionsClick(Sender: TObject);
Var
  LoggedPass : ShortString;
begin
  LoggedPass := '';
  CommonMCM.DisplayMCMOptions(Self , LoggedPass, (SecurityManager.smUserType = utSystem));
  mulCompanyList.RefreshDB;
end;

//-------------------------------------------------------------------------

procedure TfrmBureauMCM.mulCompanyListRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  If btnOpenEnterprise.Visible Then
  Begin
    OpenEnterprise(Sender);
  End; // If OpenEnterprise.Visible
end;

//-------------------------------------------------------------------------

procedure TfrmBureauMCM.MenuOpt_ResyncCompsClick(Sender: TObject);
begin
  // Challenge for the Resynch Companies password and run the utility if provided
  ResynchCompanies;
end;

//------------------------------

// MH 25/02/2013 v7.0.2 ABSEXCH-13994: Allows users to clear down individual user counts
procedure TfrmBureauMCM.MenuOpt_ResetIndividualUserCountsClick(Sender: TObject);
begin
  ResetIndividualEntUserCounts(Self);
end;

//------------------------------

procedure TfrmBureauMCM.MenuOpt_ResetUserCountsClick(Sender: TObject);
begin
  // Resets the Enterprise User counts
  ResetEntUserCounts (Self);
end;

//------------------------------

procedure TfrmBureauMCM.MenuOpt_ResetPIUsersClick(Sender: TObject);
begin
  // Reset Plug-In User Counts
  ResetPlugInUserCounts;
end;

//-------------------------------------------------------------------------

procedure TfrmBureauMCM.MenuOpt_HelpContClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_Finder,0);
end;

//------------------------------

procedure TfrmBureauMCM.MenuOpt_SessionInfoClick(Sender: TObject);
begin
  // Displays the Session Info dialog
  DisplaySessionInfo (Self);
end;

//------------------------------

procedure TfrmBureauMCM.MenuOpt_AboutClick(Sender: TObject);
begin
  // Displays the MCM Help-About dialog
  DisplayHelpAbout (Self, SecurityManager.smUserType In [utSystem, utAdmin]);
end;

//-------------------------------------------------------------------------

// Controls the loading/saving of the colours and positions
//
// Mode   0=Load Details, 1=Save Details, 2=Delete Details
procedure TfrmBureauMCM.SetColoursUndPositions (Const Mode : Byte);
Var
  WantAutoSave : Boolean;
Begin // SetColoursUndPositions
  Case Mode Of
    0 : Begin
          oSettings.LoadForm (Self, WantAutoSave);
          popSavePosition.Checked := WantAutoSave;
          oSettings.LoadList (mulCompanyList, Self.Name);
        End;
    1 : If (Not DoneRestore) Then
        Begin
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm (Self, popSavePosition.Checked);
          oSettings.SaveList (mulCompanyList, Self.Name);
        End; // If (Not DoneRestore)
    2 : Begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults (Self.Name);
          oSettings.RestoreListDefaults (mulCompanyList, Self.Name);
          popSavePosition.Checked := False;
        End;
  Else
    Raise Exception.Create ('TfrmBureauMCM.SetColoursUndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  End; // Case Mode
End; // SetColoursUndPositions

//-------------------------------------------------------------------------

procedure TfrmBureauMCM.popFormPropertiesClick(Sender: TObject);
begin
  // Call the colours dialog
  Case oSettings.Edit(mulCompanyList, Self.Name, NIL) Of
    mrOK              : ; // no other controls to colour
    mrRestoreDefaults : SetColoursUndPositions (2);
  End; // Case oSettings.Edit(...
end;

//------------------------------

procedure TfrmBureauMCM.popSavePositionClick(Sender: TObject);
begin
  // ?
end;

//-------------------------------------------------------------------------

procedure TfrmBureauMCM.mulCompanyListCellPaint(Sender: TObject;
  ColumnIndex, RowIndex: Integer; var OwnerText: String;
  var TextFont: TFont; var TextBrush: TBrush; var TextAlign: TAlignment);
Var
  CompCode       : String[CompCodeLen];
begin
  // Extract the Company Code from the first column of the MultiList and
  // lookup the cached details in the Company Details cache to check whether
  // it was OK or not
  CompCode := mulCompanyList.DesignColumns[0].Items[RowIndex];
  If (CompInfoCache.CompanyCodeDetailsByCode [CompCode].CompDets.CompAnal > 1) Then
  Begin
    // Problem - highlight row in bold
    TextFont.Style := TextFont.Style + [fsBold];
  End; // If (CompInfoCache.CompanyCodeDetailsByCode [CompCode].CompAnal > 1)
end;

//-------------------------------------------------------------------------

procedure TfrmBureauMCM.FormResize(Sender: TObject);
begin
  LockWindowUpdate (Handle);

  // Resize/reposition the button containing the panels
  panButtons.Left := ClientWidth - panButtons.Width - 4;
  panButtons.Height := ClientHeight - 7;

  // Resize list component
  mulCompanyList.Height := panButtons.Height;
  mulCompanyList.Width := panButtons.Left - 7;

  LockWindowUpdate (0);
end;

//-------------------------------------------------------------------------

procedure TfrmBureauMCM.FormPaint(Sender: TObject);
begin
//  If (Not DunShow) Then Begin
//    DunShow := True;
//    ShowWindow (Application.Handle, SW_SHOW);
//  End; { If (Not DunShow) }
end;

//-------------------------------------------------------------------------

procedure TfrmBureauMCM.mnuOpenSchedulerClick(Sender: TObject);
Var
  CompDets : CompanyDetRec;
begin
  // Check a company is selected in the list
  If (mulCompanyList.Selected > -1) Then
  Begin
    // Save form position and sizing
    SetColoursUndPositions (1);

    // Setup a fake company details record for the selected row, the CheckCompany
    // call will load the full details as part of the checks
    FillChar (CompDets, SizeOf(CompDets), #0);

    // Checks out the specified dataset and returns TRUE if OK to use it
    If CheckCompany (CompDets, mulCompanyList.DesignColumns[0].Items[mulCompanyList.Selected], WantChecks) Then
    Begin
      If RunScheduler (CompDets) Then
      Begin
        Close;
      End; // If RunScheduler (CompDets)
    End; // If CheckCompany (...
  End; // If (mulCompanyList.Selected > -1)
end;

//-------------------------------------------------------------------------

procedure TfrmBureauMCM.ViewCompanyDets(Sender: TObject);
Var
  CompDets : CompanyDetRec;
begin
  // Check that a company is selected in the list and the user is allowed to do this
  If (mulCompanyList.Selected > -1) And popViewCompanyDetails.Visible Then
  Begin
    // Load the selected record into the global Company^ record and
    // display the edit company details window
    //bdsCompanyList.GetRecord;

    // Get the company details from the cache, this includes details of
    // directory and security checks for reporting errors in the company
    FillChar (Company^.CompDet, SizeOf(Company^.CompDet), #0);
    Company^.CompDet.CompCode := mulCompanyList.DesignColumns[0].Items[mulCompanyList.Selected];
    CompInfoCache.GetCompanyDetails (Company^.CompDet);

    ViewCompany (Self);
  End; // If (mulCompanyList.Selected > -1) And btnViewCompany.Visible
end;

//=========================================================================

end.
