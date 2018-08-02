unit MaintainCompaniesF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, uMultiList, uDBMultiList,
  uExDatasets, uBTGlobalDataset, BTSupU1, CompanyCache;

type
  TfrmMaintainCompanies = class(TForm)
    bdsCompanyList: TBTGlobalDataset;
    mulCompanyList: TDBMultiList;
    panButtons: TPanel;
    CloseBtn: TButton;
    ScrollBox1: TScrollBox;
    btnAddCompany: TButton;
    btnEditCompany: TButton;
    btnDeleteCompany: TButton;
    btnFindCompany: TButton;
    PopupMenu1: TPopupMenu;
    popAddCompany: TMenuItem;
    popEditCompany: TMenuItem;
    popDeleteCompany: TMenuItem;
    PopupOpt_SepBar2: TMenuItem;
    popFormProperties: TMenuItem;
    PopupOpt_SepBar3: TMenuItem;
    popSavePosition: TMenuItem;
    btnLoggedInUsersReports: TButton;
    btnBackupCompany: TButton;
    btnRestoreCompany: TButton;
    btnRebuildCompany: TButton;
    popFindCompany: TMenuItem;
    N1: TMenuItem;
    btnViewCompany: TButton;
    popViewCompanyDetails: TMenuItem;
    procedure bdsCompanyListGetBufferSize(Sender: TObject;
      var TheBufferSize: Integer);
    procedure bdsCompanyListGetDataRecord(Sender: TObject;
      var TheDataRecord: Pointer);
    procedure bdsCompanyListGetFileVar(Sender: TObject;
      var TheFileVar: pFileVar);
    procedure bdsCompanyListGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure AddCompany(Sender: TObject);
    procedure EditCompanyRec(Sender: TObject);
    procedure DeleteCompanyRec(Sender: TObject);
    procedure CloseMCM(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Find(Sender: TObject);
    procedure mulCompanyListCellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure btnLoggedInUsersReportsClick(Sender: TObject);
    procedure btnBackupCompanyClick(Sender: TObject);
    procedure btnRestoreCompanyClick(Sender: TObject);
    procedure btnRebuildCompanyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure popFormPropertiesClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ViewCompanyRec(Sender: TObject);
  private
    { Private declarations }
    DoneRestore : Boolean;

    // Update the enabled/visible status of buttons and menu options depending on
    // the logged in status, ESN Errors, MCM Options, etc...
    procedure UpdateSecurityStatus;

    // Update the buttons panel based on the buttons visible status
    procedure UpdateButtonsPositions;
  protected
    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    // List of company details stored for performance reasons
    CompInfoCache : TCompanyInfoCache;

    // Return value indicates whether company paths should be shown in the company list
    Function ShowCompanyPaths : Boolean; Virtual;

    // Controls the loading/saving of the colours and positions
    //
    // Mode   0=Load Details, 1=Save Details, 2=Delete Details
    procedure SetColoursUndPositions (Const Mode : Byte);

    Procedure WMCustGetRec(Var Message : TMessage); Message WM_CustGetRec;
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
  end;


// Displays the Maintain Companies dialog for the Bureau Module
Procedure MaintainCompaniesList (Const ParentForm : TForm);

implementation

{$R *.dfm}

Uses GlobVar, VarConst,
     BureauSecurity,  // SecurityManager Object
     ChkComp,         // Routines for checking the validity of a company dataset
     ChkDelet,        //
     CommonMCM,       // Common functionality called by the Standard and Bureau MCM windows
     CompDelt,        // Delete Company window
     CompDet,         // Company Detail Window
     CompDlg,         // Find Company Directory dialog
     CompSec,         // Company Count Security
     CompUtil,        // PathToShort function
     CompWDlg,        // Company Count warning dialog
     EntInitU,        // Auto_GetCompCode function
     GroupUsersFile,  // Definition of GroupUsr.Dat (GroupUsersF) and utility functions
     MCMFindF,        // Find Company dialog
     uSettings,       // Colour/Position editing and saving routines
     EntLicence,      // Licencing Object
     VAOUtil,
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     BTKeys1U, BtrvU2;

//-------------------------------------------------------------------------

// Displays the Maintain Companies dialog for the Bureau Module
Procedure MaintainCompaniesList (Const ParentForm : TForm);
Var
  frmMaintainCompanies : TfrmMaintainCompanies;
Begin // MaintainCompaniesList
  frmMaintainCompanies := TfrmMaintainCompanies.Create(ParentForm);
  Try
    frmMaintainCompanies.ShowModal;
  Finally
    FreeAndNIL(frmMaintainCompanies);
  End; // Try..Finally
End; // MaintainCompaniesList

//=========================================================================

procedure TfrmMaintainCompanies.FormCreate(Sender: TObject);
begin
  // List of company details stored for performance reasons
  CompInfoCache := TCompanyInfoCache.Create;

  // Set the form size to the designed size
  ClientWidth := 470;
  ClientHeight := 267;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 416;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 140;      // captions into account

  // Update the enabled/visible status of buttons and menu options depending on
  // the logged in status, ESN Errors, MCM Options, etc...
  UpdateSecurityStatus;

  // Update the buttons panel based on the buttons visible status
  UpdateButtonsPositions;

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  SetColoursUndPositions (0);

  // Activate the list of companies
  mulCompanyList.Active := True;
end;

//-------------------------------------------------------------------------

procedure TfrmMaintainCompanies.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Save colours/positions/sizes/etc...
  SetColoursUndPositions (1);
end;

//------------------------------

procedure TfrmMaintainCompanies.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(CompInfoCache);
end;

//-------------------------------------------------------------------------

Procedure TfrmMaintainCompanies.WMCustGetRec(Var Message : TMessage);
Var
  CompCode : String[CompCodeLen];
Begin // WMCustGetRec
  With Message Do
  Begin
    Case WParam of
      // Sent when an add/update has been performed
      200, 300 : Begin
                   CompCode := Company^.CompDet.CompCode;
                   mulCompanyList.RefreshDB;
                   mulCompanyList.SearchColumn (0, mulCompanyList.SortAsc, CompCode);
                 End;

    End // Case WParam
  End; // With Message
End; // WMCustGetRec

//-------------------------------------------------------------------------

Procedure TfrmMaintainCompanies.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
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

// Update the enabled/visible status of buttons and menu options depending on
// the logged in status, ESN Errors, MCM Options, etc...
procedure TfrmMaintainCompanies.UpdateSecurityStatus;
Begin // UpdateSecurityStatus
  // File Menu -------------------------------------------

  // Add Company
  btnAddCompany.Visible := SecurityManager.smUserPermissions[upAddCompany] Or
                           (SecurityManager.smUserType = utSystem);
  popAddCompany.Visible := btnAddCompany.Visible;

  // Edit Company
  btnEditCompany.Visible := SecurityManager.smUserPermissions[upEditCompany] Or
                           (SecurityManager.smUserType = utSystem);
  popEditCompany.Visible := btnEditCompany.Visible;

  // View Company
  btnViewCompany.Visible := SecurityManager.smUserPermissions[upViewCompany] Or
                           (SecurityManager.smUserType = utSystem);
  popViewCompanyDetails.Visible := btnViewCompany.Visible;

  // Delete Company
  btnDeleteCompany.Visible := SecurityManager.smUserPermissions[upDeleteCompany] Or
                           (SecurityManager.smUserType = utSystem);
  popDeleteCompany.Visible := btnDeleteCompany.Visible;

  // Find Company - always Available

  // Logged In User Report
  btnLoggedInUsersReports.Visible := SecurityManager.smUserPermissions[upLoggedInUserReport] Or
                                     (SecurityManager.smUserType In [utSystem, utAdmin]);

  // Backup
  btnBackupCompany.Visible := SecurityManager.smUserPermissions[upBackupCompany] Or
                              (SecurityManager.smUserType = utSystem);

  // Restore
  btnRestoreCompany.Visible := SecurityManager.smUserPermissions[upRestoreCompany] Or
                               (SecurityManager.smUserType = utSystem);

  // Rebuild
  btnRebuildCompany.Visible := SecurityManager.smUserPermissions[upRebuildAllComps] Or
                               (SecurityManager.smUserType In [utSystem, utAdmin]);
End; // UpdateSecurityStatus

//-------------------------------------------------------------------------

// Update the buttons panel based on the buttons visible status
procedure TfrmMaintainCompanies.UpdateButtonsPositions;
Var
  NextBtnTop : SmallInt;
  GotOpenBtn : Boolean;
Begin // UpdateButtonsPositions
  LockWindowUpdate (Handle);

  NextBtnTop := 1;
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
  // Find button always available
  btnFindCompany.Top := NextBtnTop;
  NextBtnTop := NextBtnTop + btnFindCompany.Height + 3;

  // Insert spacer between maintenance and utility buttons
  NextBtnTop := NextBtnTop + 5;

  If btnLoggedInUsersReports.Visible Then
  Begin
    btnLoggedInUsersReports.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnLoggedInUsersReports.Height + 3;
  End; // If btnLoggedInUsersReports.Visible
  If btnBackupCompany.Visible Then
  Begin
    btnBackupCompany.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnBackupCompany.Height + 3;
  End; // If btnBackupCompany.Visible
  If btnRestoreCompany.Visible Then
  Begin
    btnRestoreCompany.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnRestoreCompany.Height + 3;
  End; // If btnRestoreCompany.Visible
  If btnRebuildCompany.Visible Then
  Begin
    btnRebuildCompany.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnRebuildCompany.Height + 3;
  End; // If btnRebuildCompany.Visible

  LockWindowUpdate (0);
End; // UpdateButtonsPositions

//-------------------------------------------------------------------------

procedure TfrmMaintainCompanies.bdsCompanyListGetBufferSize(Sender: TObject;
  var TheBufferSize: Integer);
begin
  TheBufferSize := FileRecLen[CompF];
end;

//------------------------------

procedure TfrmMaintainCompanies.bdsCompanyListGetDataRecord(Sender: TObject;
  var TheDataRecord: Pointer);
begin
  TheDataRecord := RecPtr[CompF];
end;

//------------------------------

procedure TfrmMaintainCompanies.bdsCompanyListGetFileVar(Sender: TObject;
  var TheFileVar: pFileVar);
begin
  TheFileVar := @F[CompF];
end;

//------------------------------

procedure TfrmMaintainCompanies.bdsCompanyListGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
Var
  pCompany      : ^CompRec;
  iStatus       : SmallInt;
  sKey          : Str255;
begin
  pCompany := pData;

  Case FieldName[1] Of
    '0'  : FieldValue := Trim(pCompany^.CompDet.CompCode);
    '1'  : FieldValue := Trim(pCompany^.CompDet.CompName);
    '2'  : Begin
             // Get the company details from the cache, this includes details of
             // directory and security checks for reporting errors in the company
             CompInfoCache.GetCompanyDetails (pCompany.CompDet);

             // If the analysis of the company has shown a problem the report it,
             // else shown the path if that option is available
             If (pCompany^.CompDet.CompAnal = 1) Then
             Begin
               // OK - Check whether the Company Path should be shown
               If ShowCompanyPaths Then
               Begin
                 FieldValue := Trim(pCompany^.CompDet.CompPath);
               End // If ShowCompanyPaths
               Else
               Begin
                 FieldValue := '';
               End; // Else
             End // If (pCompany^.CompDet.CompAnal = 1)
             Else
             Begin
               // Error - display error message
               FieldValue := '*** Error: ' + GetCompDirError (pCompany^.CompDet.CompAnal) + '***';
             End; // Else
           End; // '2'
    '3'  : Begin
             // Get the company details from the cache, this includes details of
             // directory and security checks for reporting errors in the company
             CompInfoCache.GetCompanyDetails (pCompany.CompDet);

             With pCompany.CompDet Do
             Begin
               FieldValue := Format ('%3.3d-%3.3d-%3.3d-%3.3d-%3.3d-%3.3d',
                                  [CompSysESN[1], CompSysESN[2], CompSysESN[3],
                                   CompSysESN[4], CompSysESN[5], CompSysESN[6]]);
             End; // with pCompany.CompDet
           End; // 3
  End; // Case FieldName[1]
end;

//------------------------------

// Show rows with errors in Bold
procedure TfrmMaintainCompanies.mulCompanyListCellPaint(Sender: TObject;
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

procedure TfrmMaintainCompanies.AddCompany(Sender: TObject);
Var
  CompanyDialog : TCompanyDialog;
  CompCount     : LongInt;
  Continue      : Boolean;
begin
  If btnAddCompany.Visible Then
  Begin
    If (Not EnterpriseLicence.IsLITE) Then
    Begin
      // Exchequer - Check Company Count before allowing user to proceed
      CompCount := GetActualCompanyCount;
      Continue := (CompCount < GetLicencedCompanyCount);
      If (Not Continue) Then
        DisplayCompCountWarning (CompCount, GetLicencedCompanyCount);
    End // If (Not EnterpriseLicence.IsLITE)
    Else
      // IAO - only perform the check after a Blank company has been selected
      Continue := True;

    If Continue Then
    Begin
      CompanyDialog := TCompanyDialog.Create(Self);
      Try
        CompanyDialog.Caption := 'Find Existing Company';
        CompanyDialog.Path := PathToShort(ExtractFilePath(Application.ExeName));
        CompanyDialog.CheckDataType := True;

        If CompanyDialog.Execute Then
        Begin
          ResetRec (CompF);
          With Company^, CompDet Do Begin
            RecPFix  := cmCompDet;

            CompName := CompanyDialog.CompanyName;
            CompPath := FullCompPath(CompanyDialog.Path);

            If (CompanyDialog.CompanyCode <> '') Then
              CompCode := CompanyDialog.CompanyCode
            Else
              CompCode := Auto_GetCompCode(CompName);
          End; { With }

          { Edit new company details }
          EditCompany (Self, False);
        End; { If }
      Finally
        CompanyDialog.Free;
      End;
    End; // If Continue
  End; // If btnAddCompany.Visible
end;

//------------------------------

procedure TfrmMaintainCompanies.EditCompanyRec(Sender: TObject);
begin
  // Check that a company is selected in the list and the user is allowed to do this
  If (mulCompanyList.Selected > -1) And btnEditCompany.Visible Then
  Begin
    // Load the selected record into the global Company^ record and
    // display the edit company details window
    if (bdsCompanyList.GetRecord <> nil) then
      EditCompany (Self, True)
    else
      ShowMessage('Failed to locate company record for editing');

    // Reset the cache details and refresh the list
    CompInfoCache.Clear;
    mulCompanyList.RefreshDB;
  End; // If (mulCompanyList.Selected > -1) And btnEditCompany.Visible
end;

//------------------------------

procedure TfrmMaintainCompanies.ViewCompanyRec(Sender: TObject);
begin
  // Check that a company is selected in the list and the user is allowed to do this
  If (mulCompanyList.Selected > -1) And btnViewCompany.Visible Then
  Begin
    // Load the selected record into the global Company^ record and
    // display the edit company details window
    if (bdsCompanyList.GetRecord <> nil) then
      ViewCompany (Self)
    else
      ShowMessage('Failed to locate company record for viewing');
  End; // If (mulCompanyList.Selected > -1) And btnViewCompany.Visible
end;

//------------------------------

procedure TfrmMaintainCompanies.DeleteCompanyRec(Sender: TObject);
var
  CmpDir : ANSIString;
  OK     : Boolean;
begin
  // Check that a company is selected in the list and the user is allowed to do this
  If (mulCompanyList.Selected > -1) And btnDeleteCompany.Visible Then
  Begin
    // Load the selected record into the global Company^ record
    bdsCompanyList.GetRecord;

    // Check to see if its the main company
    CmpDir := LowerCase(CheckDirPath (Company^.CompDet.CompPath));
    If CheckForDelete (CmpDir, CmpDir, '', False) Then
    Begin
{$IFDEF EXSQL}
      if EnterpriseLicence.IsSQL then
        OK := SQLUtils.ExclusiveAccess(CmpDir)
      else
{$ENDIF}
      { HM 18/07/01: Try to access Exclusively to ensure no-one is using the company data set }
      If FileExists (CmpDir + FileNames[SysF]) Then
        { Get Data Files-  check for exlusive access }
        OK := TestExclusivity (CmpDir)
      Else
        { No files - so OK to delete MCM entry }
        OK := True;

      If OK Then
      Begin
        { Check they want to delete the company }
        With TDeleteCompany.Create (Self) Do
        Begin
          Try
            HelpContext := 1;

            If CompLocked Then
              { Company record is locked }
              ShowModal
            Else
              MessageDlg ('This company cannot be deleted as someone else is using it', mtError, [mbOk], 0);
          Finally
            Free;
          End; { Try }
        End; // With TDeleteCompany.Create (Self)
      End // If OK
      Else
      Begin
        { Someone already using Company Data Set }
        MessageDlg('Someone is currrently using this Company Data Set - Deletion Aborted', mtWarning, [mbOK], 0);
      End; // Else
    End; // If CheckForDelete (CmpDir, CmpDir, '', False)
  End; // If (mulCompanyList.Selected > -1) And btnDeleteCompany.Visible
End;

//------------------------------

procedure TfrmMaintainCompanies.Find(Sender: TObject);
Var
  CompanyRec : CompanyDetRec;
begin
  If FindCompany (Self, CompanyRec) Then
  Begin
    mulCompanyList.SearchColumn (0, mulCompanyList.SortAsc, Trim(CompanyRec.CompCode));
  End; // If FindCompany (Self, CompanyRec)
end;

//------------------------------

procedure TfrmMaintainCompanies.CloseMCM(Sender: TObject);
begin
  Close;
end;

//------------------------------

procedure TfrmMaintainCompanies.btnLoggedInUsersReportsClick(Sender: TObject);
begin
  // Print the Logged In Users Report to Preview
  RunLoggedInUsersReport (Self);
end;

//-------------------------------------------------------------------------

procedure TfrmMaintainCompanies.btnBackupCompanyClick(Sender: TObject);
begin
  // Check that a company is selected in the list and the user is allowed to do this
  If (mulCompanyList.Selected > -1) And btnBackupCompany.Visible Then
  Begin
    // Load the selected record into the global Company^ record
    bdsCompanyList.GetRecord;

    RunBackupOrRestore (Self, Trim(Company^.CompDet.CompCode), brBackup);
  End; // If (mulCompanyList.Selected > -1) And btnBackupCompany.Visible
end;

//------------------------------

procedure TfrmMaintainCompanies.btnRestoreCompanyClick(Sender: TObject);
begin
  // Check that a company is selected in the list and the user is allowed to do this
  If (mulCompanyList.Selected > -1) And btnRestoreCompany.Visible Then
  Begin
    // Load the selected record into the global Company^ record
    bdsCompanyList.GetRecord;

    RunBackupOrRestore (Self, Trim(Company^.CompDet.CompCode), brRestore);
  End; // If (mulCompanyList.Selected > -1) And btnRestoreCompany.Visible
end;

//-------------------------------------------------------------------------

procedure TfrmMaintainCompanies.btnRebuildCompanyClick(Sender: TObject);
begin
  // Check that a company is selected in the list and the user is allowed to do this
  If (mulCompanyList.Selected > -1) And btnRebuildCompany.Visible Then
  Begin
    // Load the selected record into the global Company^ record
    bdsCompanyList.GetRecord;

    // Runs the rebuild module for the selected company
    // HM 07/12/04: Extended so that Bureau Admins get the Special Functions when running under VAO
    RunRebuild (Self, Trim(Company^.CompDet.CompCode), (SecurityManager.smUserType = utSystem) Or ((SecurityManager.smUserType = utAdmin) And (VAOInfo.vaoMode = smVAO)));
  End; // If (mulCompanyList.Selected > -1) And btnRebuildCompany.Visible
end;

//-------------------------------------------------------------------------

// Controls the loading/saving of the colours and positions
//
// Mode   0=Load Details, 1=Save Details, 2=Delete Details
procedure TfrmMaintainCompanies.SetColoursUndPositions (Const Mode : Byte);
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
    Raise Exception.Create ('TfrmMaintainCompanies.SetColoursUndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  End; // Case Mode
End; // SetColoursUndPositions

//-------------------------------------------------------------------------

procedure TfrmMaintainCompanies.popFormPropertiesClick(Sender: TObject);
begin
  // Call the colours dialog
  Case oSettings.Edit(mulCompanyList, Self.Name, NIL) Of
    mrOK              : ; // no other controls to colour
    mrRestoreDefaults : SetColoursUndPositions (2);
  End; // Case oSettings.Edit(...
end;                               

//-------------------------------------------------------------------------

// Return value indicates whether company paths should be shown in the company list
Function TfrmMaintainCompanies.ShowCompanyPaths : Boolean;
Begin // ShowCompanyPaths
  Result := True;  // always show paths in the Bureau Companies List
End; // ShowCompanyPaths

//-------------------------------------------------------------------------

procedure TfrmMaintainCompanies.FormResize(Sender: TObject);
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

end.
