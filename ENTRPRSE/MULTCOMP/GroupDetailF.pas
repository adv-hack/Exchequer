unit GroupDetailF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uMultiList, StdCtrls, Mask, TEditVal, SBSPanel, TCustom, ExtCtrls,
  ComCtrls, bkgroup,
  CompanyCache,    // Cache of company details stored for the list
  GroupsFile,      // Definition of Groups.Dat (GroupF) and utility functions
  GroupUsersFile,  // Definition of GroupUsr.Dat (GroupUsersF) and utility functions
  BTSupU1, uBTGlobalDataset, uExDatasets, uBtrieveDataset, uDBMultiList,
  Menus;

type
  TGroupDetailMode = (gdmAdd, gdmEdit, gdmDelete, gdmView);

  TfrmGroupDetail = class(TForm)
    PageControl1: TPageControl;
    tabshGroupCompanies: TTabSheet;
    tabshGroupUsers: TTabSheet;
    panButtons: TPanel;
    btnCancel: TSBSButton;
    btnClose: TSBSButton;
    tabshMain: TTabSheet;
    edtName: Text8Pt;
    Label1: TLabel;
    edtCode: Text8Pt;
    Label2: TLabel;
    btnOK: TSBSButton;
    mulCompanies: TDBMultiList;
    ScrollBox1: TScrollBox;
    btnAdd: TSBSButton;
    btnEdit: TSBSButton;
    btnDelete: TSBSButton;
    mulGroupUsers: TDBMultiList;
    bdsCompanies: TBTGlobalDataset;
    bdsGroupUsers: TBTGlobalDataset;
    btnView: TSBSButton;
    btnChangePWord: TSBSButton;
    PopupMenu1: TPopupMenu;
    popAddUser: TMenuItem;
    popEditUser: TMenuItem;
    popDeleteUser: TMenuItem;
    popViewUser: TMenuItem;
    popLinkCompanies: TMenuItem;
    PopupOpt_SepBar2: TMenuItem;
    popFormProperties: TMenuItem;
    PopupOpt_SepBar3: TMenuItem;
    popSavePosition: TMenuItem;
    N1: TMenuItem;
    popChangePassword: TMenuItem;
    SBSBackGroup1: TSBSBackGroup;
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure bdsCompaniesGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure bdsCompaniesGetBufferSize(Sender: TObject;
      var TheBufferSize: Integer);
    procedure bdsCompaniesGetFileVar(Sender: TObject;
      var TheFileVar: pFileVar);
    procedure bdsCompaniesGetDataRecord(Sender: TObject;
      var TheDataRecord: Pointer);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure bdsGroupUsersGetBufferSize(Sender: TObject;
      var TheBufferSize: Integer);
    procedure bdsGroupUsersGetDataRecord(Sender: TObject;
      var TheDataRecord: Pointer);
    procedure bdsGroupUsersGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure bdsGroupUsersGetFileVar(Sender: TObject;
      var TheFileVar: pFileVar);
    procedure btnViewClick(Sender: TObject);
    procedure mulCompaniesRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mulGroupUsersRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnChangePWordClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure popFormPropertiesClick(Sender: TObject);
    procedure mulCompaniesCellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    DoneRestore : Boolean;

    // List of company details stored for performance reasons
    CompInfoCache : TCompanyInfoCache;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    FLockPos : LongInt;
    FMode    : TGroupDetailMode;

    procedure CheckRecLock;

    // Optionally updates the list and repositions within the list on the
    // passed record
    Procedure FindAndPosition (Const UserRec : GroupUsersFileRecType; Const DoDBRefresh : Boolean);

    // Update the data record with the contents of the windows fields
    procedure FormToDataRec (Var DataRec : GroupFileRecType);

    // Controls the loading/saving of the colours and positions
    //
    // Mode   0=Load Details, 1=Save Details, 2=Delete Details
    procedure SetColoursUndPositions (Const Mode : Byte);

    procedure SetMode (Const Mode : TGroupDetailMode);

    // Update the buttons panel based on the buttons visible status
    procedure UpdateButtonsPositions;

    Procedure WMCustGetRec(Var Message : TMessage); Message WM_CustGetRec;
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
    Property LockPos : LongInt Read FLockPos Write FLockPos;
    Property Mode : TGroupDetailMode Read FMode Write SetMode;

    // Puts the data record into the windows fields
    procedure DisplayData (Const DataRec : GroupFileRecType);
  end;

// Adds a new group record, returns True if a group was added, else False
Function AddGroup (Const ParentForm : TForm) : Boolean;

// Edits the group record loaded in the global GroupFileRec structure, it
// is assumed that the record is already locked in the DB
Procedure EditGroup (Const ParentForm : TForm; Const LockPos : LongInt);

// Views an existing group record
Procedure ViewGroup (Const ParentForm : TForm);


implementation

{$R *.dfm}

Uses GlobVar, VarConst, BtrvU2, BTKeys1U, BTSupU2, ETStrU, SavePos,
     BureauSecurity,  // SecurityManager Object
     ChangeUserPWord, // Routines for changing a Group Users Password
     ChkComp,         // Routines for checking the validity of a company dataset
     GroupCompFile,   // Definition of GroupCmp.Dat (GroupCompXrefF) and utility functions
     UserDetailF,     // User detail window
     uSettings,       // Colour/Position editing and saving routines
     LinkCompaniesF;

//=========================================================================

// Adds a new group record, returns True if a group was added, else False
Function AddGroup (Const ParentForm : TForm) : Boolean;
var
  frmGroupDetail: TfrmGroupDetail;
Begin // AddGroup
  frmGroupDetail := TfrmGroupDetail.Create (ParentForm);
  Try
    // Reconfigure the form for adding a new Group
    frmGroupDetail.Mode := gdmAdd;

    // Initialise the group record
    FillChar (GroupFileRec, SizeOf (GroupFileRec), #0);
    frmGroupDetail.DisplayData (GroupFileRec);

    frmGroupDetail.Caption := 'Add New Group';

    Result := (frmGroupDetail.ShowModal = mrOk);
    If Result Then
    Begin
      // Reconfigure the form for viewing the group so that
      // Companies/Users can be added if required
      frmGroupDetail.Mode := gdmView;
    End; // If Result
  Finally
    FreeAndNIL(frmGroupDetail);
  End; // Try..Finally
End; // AddGroup

//=========================================================================

// Edits the group record loaded in the global GroupFileRec structure, it
// is assumed that the record is already locked in the DB
Procedure EditGroup (Const ParentForm : TForm; Const LockPos : LongInt);
var
  frmGroupDetail: TfrmGroupDetail;
Begin // EditGroup
  frmGroupDetail := TfrmGroupDetail.Create (ParentForm);
  Try
    // Reconfigure the form for the mode
    frmGroupDetail.LockPos := LockPos;
    frmGroupDetail.Mode := gdmEdit;
    frmGroupDetail.DisplayData (GroupFileRec);
    frmGroupDetail.Caption := 'Edit Group ' + Trim(GroupFileRec.grGroupCode);

    frmGroupDetail.ShowModal;
  Finally
    FreeAndNIL(frmGroupDetail);
  End; // Try..Finally
End; // EditGroup

//=========================================================================

// Views an existing group record
Procedure ViewGroup (Const ParentForm : TForm);
var
  frmGroupDetail: TfrmGroupDetail;
Begin // ViewGroup
  frmGroupDetail := TfrmGroupDetail.Create (ParentForm);
  Try
    // Reconfigure the form for the mode
    frmGroupDetail.Mode := gdmView;
    frmGroupDetail.DisplayData (GroupFileRec);

    // Intelligently decide on the active tab - if no companies then select
    // the companies tab, else select the users tab
    If GroupHasCompanies (GroupFileRec.grGroupCode) Then
    Begin
      frmGroupDetail.PageControl1.ActivePage := frmGroupDetail.tabshGroupUsers;
    End // If GroupHasCompanies (GroupFileRec.grGroupCode)
    Else
    Begin
      frmGroupDetail.PageControl1.ActivePage := frmGroupDetail.tabshGroupCompanies;
    End; // Else
    frmGroupDetail.PageControl1.OnChange(frmGroupDetail);

    frmGroupDetail.Caption := 'View Group ' + Trim(GroupFileRec.grGroupCode);
    frmGroupDetail.ShowModal;
  Finally
    FreeAndNIL(frmGroupDetail);
  End; // Try..Finally
End; // ViewGroup

//=========================================================================

procedure TfrmGroupDetail.FormCreate(Sender: TObject);
begin
  ClientHeight := 244;
  ClientWidth := 526;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 460;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 172;      // captions into account

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  SetColoursUndPositions (0);

  // List of company details stored for performance reasons
  CompInfoCache := TCompanyInfoCache.Create;

  PageControl1.ActivePage := tabshMain;
end;

//------------------------------

procedure TfrmGroupDetail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Save colours/positions/sizes/etc...
  SetColoursUndPositions (1);

  // Remove any record lock that has been set and still remains
  CheckRecLock;

  FreeAndNIL(CompInfoCache);
end;

//------------------------------

procedure TfrmGroupDetail.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

//------------------------------

procedure TfrmGroupDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

//-------------------------------------------------------------------------

Procedure TfrmGroupDetail.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
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

procedure TfrmGroupDetail.SetMode (Const Mode : TGroupDetailMode);
Begin // InitForMode
  FMode := Mode;

  // Hide Companies/Users tabs for certain modes
  tabshGroupCompanies.Tabvisible := (Mode In [gdmView]);
  tabshGroupUsers.Tabvisible     := tabshGroupCompanies.Tabvisible;

  // OK/Cancel buttons only enabled in Add/Edit Mode
  btnOK.Enabled := (Mode in [gdmAdd, gdmEdit]);
  btnCancel.Enabled := btnOK.Enabled;

  // Close button hidden in Add/Edit Mode
  btnClose.Visible := (Not btnOK.Enabled);

  // Set the correct MaxLength for the indexed fields
  edtCode.MaxLength := GroupCodeLen;
  edtName.MaxLength := GroupNameLen;

  // Enable the Group header fields depending on the mode
  edtCode.ReadOnly := (Mode <> gdmAdd);
  edtName.ReadOnly := (Not (Mode In [gdmAdd, gdmEdit]));

  PageControl1Change(Self);
End; // InitForMode

//-------------------------------------------------------------------------

// Puts the data record into the windows fields
procedure TfrmGroupDetail.DisplayData (Const DataRec : GroupFileRecType);
Begin // DisplayData
  edtCode.Text := Trim(DataRec.grGroupCode);
  edtName.Text := Trim(DataRec.grGroupName);

  If tabshGroupCompanies.Tabvisible Then
  Begin
    // Companies List is visible - configure the btrieve list and activate it
    bdsCompanies.SearchKey := FullGroupCodeKey(DataRec.grGroupCode);
    mulCompanies.Active := True;
  End; // If tabshGroupCompanies.Tabvisible

  If tabshGroupUsers.Tabvisible Then
  Begin
    // Companies List is visible - configure the btrieve list and activate it
    bdsGroupUsers.SearchKey := FullGroupCodeKey(DataRec.grGroupCode);
    mulGroupUsers.Active := True;
  End; // If tabshGroupUsers.Tabvisible
End; // DisplayData

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.bdsCompaniesGetBufferSize(Sender: TObject;
  var TheBufferSize: Integer);
begin
  TheBufferSize := FileRecLen[GroupCompXrefF];
end;

//------------------------------

procedure TfrmGroupDetail.bdsCompaniesGetFileVar(Sender: TObject;
  var TheFileVar: pFileVar);
begin
  TheFileVar := @F[GroupCompXrefF];
end;

//------------------------------

procedure TfrmGroupDetail.bdsCompaniesGetDataRecord(Sender: TObject;
  var TheDataRecord: Pointer);
begin
  TheDataRecord := RecPtr[GroupCompXrefF];
end;

//------------------------------

procedure TfrmGroupDetail.bdsCompaniesGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
Var
  pCompanyXRef : ^GroupCompaniesFileRecType;
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
           End;
  End; // Case FieldName[1]
end;

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.bdsGroupUsersGetBufferSize(Sender: TObject;
  var TheBufferSize: Integer);
begin
  TheBufferSize := FileRecLen[GroupUsersF];
end;

//------------------------------

procedure TfrmGroupDetail.bdsGroupUsersGetDataRecord(Sender: TObject;
  var TheDataRecord: Pointer);
begin
  TheDataRecord := RecPtr[GroupUsersF];
end;

//------------------------------

procedure TfrmGroupDetail.bdsGroupUsersGetFileVar(Sender: TObject;
  var TheFileVar: pFileVar);
begin
  TheFileVar := @F[GroupUsersF];
end;

//------------------------------

procedure TfrmGroupDetail.bdsGroupUsersGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
Var
  pGroupUser : ^GroupUsersFileRecType;
begin
  pGroupUser := pData;
  Case FieldName[1] Of
    '0'  : FieldValue := Trim(pGroupUser^.guUserCode);
    '1'  : FieldValue := Trim(pGroupUser^.guUserName);
  End; // Case FieldName[1]
end;

//-------------------------------------------------------------------------

// Update the data record with the contents of the windows fields
procedure TfrmGroupDetail.FormToDataRec (Var DataRec : GroupFileRecType);
Begin // FormToDataRec
  // Copy the Code/Name fields from the form to the record and pad out to the
  // full indexed length of the strings with spaces
  DataRec.grGroupCode := FullGroupCodeKey(edtCode.Text);
  DataRec.grGroupName := FullGroupNameKey(edtName.Text);
End; // FormToDataRec

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.btnOKClick(Sender: TObject);
Var
  lStatus  : SmallInt;
  KeyS     : Str255;
  Ok       : Boolean;
begin
  OK := True;

  // Copy the fields out of the form and Validate the record
  FormToDataRec (GroupFileRec);

  If (FMode = gdmAdd) Then
  Begin
    // Check the Code is unique
    OK := Not GroupCodeExists(GroupFileRec.grGroupCode);
    If (Not OK) Then
    Begin
      MessageDlg('A Group with the code ' + QuotedStr(Trim(GroupFileRec.grGroupCode)) + ' already exists', mtError, [mbOK], 0);
    End; // If (Not OK)
  End; // If (FMode = gdmAdd)

  If OK Then
  Begin
    // Check the Name is unique
    OK := Not GroupNameExists(GroupFileRec.grGroupCode, GroupFileRec.grGroupName);
    If (Not OK) Then
    Begin
      MessageDlg('A Group with the name ' + QuotedStr(Trim(GroupFileRec.grGroupName)) + ' already exists', mtError, [mbOK], 0);
    End; // If (Not OK)
  End; // If OK

  If OK Then
  Begin
    Case FMode Of
      gdmAdd   : Begin
                   // Add the group into the DB
                   lStatus := Add_Rec (F[GroupF], GroupF, RecPtr[GroupF]^, GroupCodeK);
                   If (lStatus = 0) Then
                   Begin
                     // Update the Groups List window
                     SendMessage (TForm(Self.Owner).Handle, WM_CustGetRec, 100, 0);

                     // Switch this window to view mode so that the companies and
                     // users can be defined
                     Mode := gdmView;

                     // Activate the lists
                     DisplayData (GroupFileRec);
                   End // If (lStatus = 0)
                   Else
                   Begin
                     Report_BError (GroupF, lStatus);
                   End; // Else
                 End;
      gdmEdit  : Begin
                   // Reposition on the group being edited
                   KeyS := FullGroupCodeKey (GroupFileRec.grGroupCode);
                   lStatus := Find_Rec(B_GetEq+B_KeyOnly, F[GroupF], GroupF, RecPtr[GroupF]^, GroupCodeK, KeyS);
                   If (lStatus = 0) Then
                   Begin
                     // Update the DB
                     lStatus := Put_Rec (F[GroupF], GroupF, RecPtr[GroupF]^, GroupCodeK);
                     If (lStatus = 0) Then
                     Begin
                       // No need to unlock the record now that the update has been done
                       FLockPos := 0;

                       // Update the Groups List window
                       SendMessage (TForm(Self.Owner).Handle, WM_CustGetRec, 200, 0);

                       // Close window
                       ModalResult := mrOK;
                     End; // If (lStatus = 0)
                   End; // If (lStatus = 0)
                   Report_BError (GroupF, lStatus);
                 End;
    End; // Case FMode
  End; // If OK
end;

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.CheckRecLock;
Var
  lStatus : SmallInt;
  KeyS    : Str255;
Begin // CheckRecLock
  If (FLockPos <> 0) Then
  Begin
    With TBtrieveSavePosition.Create Do
    Begin
      Try
        // Save the current position in the file for the current key
        SaveFilePosition (GroupF, GetPosKey);
        SaveDataBlock (@GroupFileRec, SizeOf(GroupFileRec));

        // Move the record address into the record structure and use the
        // unlock command to free the record lock
        KeyS := '';
        Move (FLockPos, GroupFileRec, SizeOf(FLockPos));
        lStatus := Find_Rec(B_Unlock, F[GroupF], GroupF, RecPtr[GroupF]^, GroupCodeK, KeyS);
        If (lStatus = 0) Then
        Begin
          // Unlocked - reset lock flag
          FLockPos := 0;
        End; // If (lStatus = 0)

        // Restore position in file
        RestoreSavedPosition;
        RestoreDataBlock (@GroupFileRec);
      Finally
        Free;
      End; // Try..Finally
    End; // With TBtrieveSavePosition.Create
  End; // If (FLockPos <> 0)
End; // CheckRecLock

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.btnCancelClick(Sender: TObject);
begin
  If (FMode = gdmEdit) Then
  Begin
    // Remove any record lock that has been set
    CheckRecLock;
  End; // If (FMode = gdmEdit)

  ModalResult := mrCancel;
end;

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

//-------------------------------------------------------------------------

// Update the buttons panel based on the buttons visible status
procedure TfrmGroupDetail.UpdateButtonsPositions;
Var
  NextBtnTop : SmallInt;
  GotOpenBtn : Boolean;
Begin // UpdateButtonsPositions
  NextBtnTop := 4;
  If btnAdd.Visible Then
  Begin
    btnAdd.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnAdd.Height + 3;
  End; // If btnAdd.Visible
  If btnEdit.Visible Then
  Begin
    btnEdit.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnEdit.Height + 3;
  End; // If btnEdit.Visible
  If btnDelete.Visible Then
  Begin
    btnDelete.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnDelete.Height + 3;
  End; // If btnDelete.Visible
  If btnView.Visible Then
  Begin
    btnView.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnView.Height + 3;
  End; // If btnView.Visible
  If btnChangePWord.Visible Then
  Begin
    btnChangePWord.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnChangePWord.Height + 3;
  End; // If btnChangePWord.Visible
End; // UpdateButtonsPositions

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.PageControl1Change(Sender: TObject);
begin
  LockWindowUpdate (Handle);

  btnEdit.Visible := (PageControl1.ActivePage = tabshGroupUsers);
  btnDelete.Visible := (PageControl1.ActivePage = tabshGroupUsers);
  btnView.Visible := (PageControl1.ActivePage = tabshGroupUsers);
  btnChangePWord.Visible := (PageControl1.ActivePage = tabshGroupUsers);

  // Change the role of btnAdd depending on the tab sheet
  If (PageControl1.ActivePage = tabshGroupCompanies) Then
  Begin
    // Companies Tab - change to Link Companies
    btnAdd.Caption := 'Lin&k Companies';
    btnAdd.Visible := SecurityManager.smUserPermissions[upGrpLinkCompanies] Or (SecurityManager.smUserType In [utSystem, utAdmin]);
  End // If (PageControl1.ActivePage = tabshGroupCompanies)
  Else
  Begin
    If (PageControl1.ActivePage = tabshMain) Then
    Begin
      // Main tab
      btnAdd.Visible := False;
    End // If (PageControl1.ActivePage = tabshMain)
    Else
    Begin
      // Users Tab
      btnAdd.Caption := '&Add';
      btnAdd.Visible := SecurityManager.smUserPermissions[upGrpAddUser] Or (SecurityManager.smUserType In [utSystem, utAdmin]);
      btnEdit.Visible := SecurityManager.smUserPermissions[upGrpEditUser] Or (SecurityManager.smUserType In [utSystem, utAdmin]);
      btnDelete.Visible := SecurityManager.smUserPermissions[upGrpDeleteUser] Or (SecurityManager.smUserType In [utSystem, utAdmin]);
      btnChangePWord.Visible := SecurityManager.smUserPermissions[upGrpChangeUserPword] Or (SecurityManager.smUserType In [utSystem, utAdmin]);
    End;
  End; // Else

  // Popup Menu
  popAddUser.Visible := (PageControl1.ActivePage = tabshGroupUsers) And SecurityManager.smUserPermissions[upGrpAddUser];
  popEditUser.Visible := (PageControl1.ActivePage = tabshGroupUsers) And SecurityManager.smUserPermissions[upGrpEditUser];
  popDeleteUser.Visible := (PageControl1.ActivePage = tabshGroupUsers) And SecurityManager.smUserPermissions[upGrpDeleteUser];
  popViewUser.Visible := (PageControl1.ActivePage = tabshGroupUsers);
  popChangePassword.Visible := (PageControl1.ActivePage = tabshGroupUsers) And SecurityManager.smUserPermissions[upGrpChangeUserPword];
  popLinkCompanies.Visible := (PageControl1.ActivePage = tabshGroupCompanies) And SecurityManager.smUserPermissions[upGrpLinkCompanies];

  // Reposition the buttons
  UpdateButtonsPositions;

  LockWindowUpdate (0);
end;

//-------------------------------------------------------------------------

// Dual use button - Link Companies on Companies Tab and Add on Users Tab
procedure TfrmGroupDetail.btnAddClick(Sender: TObject);
begin
  If btnAdd.Visible Then
  Begin
    If (btnAdd.Caption = 'Lin&k Companies') Then
    Begin
      // Link Companies to Group
      If LinkCompanies (Self, Trim(GroupFileRec.grGroupCode)) Then
      Begin
        // Changes made - update company list
        mulCompanies.RefreshDB;
      End; // If LinkCompanies (...
    End // If (btnAdd.Caption = 'Lin&k Companies')
    Else
    Begin
      // Add User
      AddGroupUser (Self, Trim(GroupFileRec.grGroupCode));
    End; // Else
  End; // If btnAdd.Visible
end;

//------------------------------

procedure TfrmGroupDetail.mulCompaniesRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  btnAddClick(Sender);
end;

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.btnEditClick(Sender: TObject);
Var
  lStatus : SmallInt;
  Locked  : Boolean;
  KeyS    : Str255;
  LPos    : LongInt;
begin
  If (mulGroupUsers.Selected > -1) And btnEdit.Visible Then
  Begin
    // Load the selected record into the global record
    bdsGroupUsers.GetRecord;

    // Read and Lock the current group
    Locked := False;
    KeyS := FullUserCode (GroupUsersFileRec^.guUserCode);
    If GetMultiRec(B_GetEq, B_SingLock, KeyS, GroupUsersCodeK, GroupUsersF, True, Locked) And Locked Then
    Begin
      GetPos (F[GroupUsersF], GroupUsersF, LPos);
      EditGroupUser (Self, LPos);
    End; // If GetMultiRec(...
  End; // If (mulGroupUsers.Selected > -1) And btnEdit.Visible
end;

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.btnDeleteClick(Sender: TObject);
begin
  If (mulGroupUsers.Selected > -1) And btnDelete.Visible Then
  Begin
    // Load the selected record into the global record
    bdsGroupUsers.GetRecord;

    If (MessageDlg('Please click the ''Yes'' button to confirm that you wish to delete the user ' +
                   QuotedStr(Trim(GroupUsersFileRec^.guUserCode) + ' - ' + Trim(GroupUsersFileRec^.guUserName)) +
                   ' in the group ' + QuotedStr(Trim(GroupUsersFileRec^.guGroupCode)),
                   mtConfirmation, [mbYes,mbNo], 0) = mrYes) Then
    Begin
      // Delete the user and reload the list
      DeleteGroupUser (GroupUsersFileRec.guUserCode);
      mulGroupUsers.RefreshDB;
    End; // If (MessageDlg('Please ...
  End; // If (mulGroupUsers.Selected > -1) And btnDelete.Visible
end;

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.btnViewClick(Sender: TObject);
begin
  If (mulGroupUsers.Selected > -1) And btnView.Visible Then
  Begin
    // Load the selected record into the global record
    bdsGroupUsers.GetRecord;

    ViewGroupUser (Self);
  End; // If (mulGroupUsers.Selected > -1) And btnView.Visible
end;

procedure TfrmGroupDetail.mulGroupUsersRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  If btnEdit.Visible Then
  Begin
    btnEditClick(Sender);
  End // If btnEdit.Visible
  Else
  Begin
    If btnView.Visible Then
    Begin
      btnViewClick(Sender);
    End // If btnView.Visible
  End; // Else
end;

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.btnChangePWordClick(Sender: TObject);
begin
  If (mulGroupUsers.Selected > -1) And btnChangePWord.Visible Then
  Begin
    // Load the selected record into the global record
    bdsGroupUsers.GetRecord;

    // Don't ask for the users password as this is an administration area
    ChangeUserPassword (Self, GroupUsersFileRec^.guUserCode, False);
  End; // If (mulGroupUsers.Selected > -1) And btnChangePWord.Visible
end;

//-------------------------------------------------------------------------

// Optionally updates the list and repositions within the list on the
// passed record
Procedure TfrmGroupDetail.FindAndPosition (Const UserRec : GroupUsersFileRecType; Const DoDBRefresh : Boolean);
Var
  sKey       : ShortString;
  ColIdx     : SmallInt;
  SortAscend : Boolean;
Begin // FindAndPosition
  // Store data in local vars as RefreshDB overwrites some of it
  ColIdx := mulGroupUsers.SortColIndex;
  SortAscend := mulGroupUsers.SortAsc;
  Case ColIdx Of
    0 : Begin // Code
          sKey := Trim(UserRec.guUserCode);
        End; // 0 - Code
    1 : Begin // Name
          sKey := Trim(UserRec.guUserName);
        End // 1 - Name
  End; // Case ColIdx

  If DoDBRefresh Then
  Begin
    // Refresh the list and find the record we want
    mulGroupUsers.RefreshDB;
  End; // If DoDBRefresh

  mulGroupUsers.SearchColumn (ColIdx, SortAscend, sKey);
End; // FindAndPosition

//-------------------------------------------------------------------------

Procedure TfrmGroupDetail.WMCustGetRec(Var Message : TMessage);
Begin // WMCustGetRec
  With Message Do
  Begin
    Case WParam of
      // User Record Added - refresh and find record in global record
      100 : Begin
              FindAndPosition (GroupUsersFileRec^, True);
            End; // 100
      // User Record Edited - refresh and find record in global record
      200 : Begin
              FindAndPosition (GroupUsersFileRec^, True);
            End; // 200
    End // Case WParam
  End; // With Message
End; // WMCustGetRec

//-------------------------------------------------------------------------

// Controls the loading/saving of the colours and positions
//
// Mode   0=Load Details, 1=Save Details, 2=Delete Details
procedure TfrmGroupDetail.SetColoursUndPositions (Const Mode : Byte);
Var
  WantAutoSave : Boolean;
Begin // SetColoursUndPositions
  Case Mode Of
    0 : Begin
          oSettings.LoadForm (Self, WantAutoSave);
          popSavePosition.Checked := WantAutoSave;
          oSettings.LoadList (mulCompanies, Self.Name);
          oSettings.LoadList (mulGroupUsers, Self.Name);   // load column pos/size - ignore colours as
          oSettings.CopyList(mulCompanies, mulGroupUsers); // will copy them in from the Companies list

          oSettings.LoadParentToControl (tabshMain.Name, Self.Name, edtCode);
          oSettings.ColorFieldsFrom (edtCode, Self);
        End;
    1 : If (Not DoneRestore) Then
        Begin
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm (Self, popSavePosition.Checked);
          oSettings.SaveList (mulCompanies, Self.Name);
          oSettings.SaveList (mulGroupUsers, Self.Name);
          oSettings.SaveParentFromControl (edtCode, Self.Name, tabshMain.Name);
        End; // If (Not DoneRestore)
    2 : Begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults (Self.Name);
          oSettings.RestoreListDefaults (mulCompanies, Self.Name);
          oSettings.RestoreListDefaults (mulGroupUsers, Self.Name);
          oSettings.RestoreParentDefaults (tabshMain, Self.Name);
          popSavePosition.Checked := False;
        End;
  Else
    Raise Exception.Create ('TfrmGroupDetail.SetColoursUndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  End; // Case Mode
End; // SetColoursUndPositions

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.popFormPropertiesClick(Sender: TObject);
begin
  // Call the colours dialog
  Case oSettings.Edit(mulCompanies, Self.Name, edtCode) Of
    mrOK              : Begin
                          oSettings.ColorFieldsFrom (edtCode, Self);
                          oSettings.CopyList(mulCompanies, mulGroupUsers);
                        End;
    mrRestoreDefaults : SetColoursUndPositions (2);
  End; // Case oSettings.Edit(...
end;

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.mulCompaniesCellPaint(Sender: TObject;
  ColumnIndex, RowIndex: Integer; var OwnerText: String;
  var TextFont: TFont; var TextBrush: TBrush; var TextAlign: TAlignment);
Var
  CompCode       : String[CompCodeLen];
begin
  // Extract the Company Code from the first column of the MultiList and
  // lookup the cached details in the Company Details cache to check whether
  // it was OK or not
  CompCode := mulCompanies.DesignColumns[0].Items[RowIndex];
  If (CompInfoCache.CompanyCodeDetailsByCode [CompCode].CompDets.CompAnal > 1) Then
  Begin
    // Problem - highlight row in bold
    TextFont.Style := TextFont.Style + [fsBold];
  End; // If (CompInfoCache.CompanyCodeDetailsByCode [CompCode].CompAnal > 1)
end;

//-------------------------------------------------------------------------

procedure TfrmGroupDetail.FormResize(Sender: TObject);
begin
  LockWindowUpdate (Handle);

  // Resize Page Control
  PageControl1.Height := ClientHeight - 5;
  PageControl1.Width := clientWidth - 6;

  // Reposition & resize common button panel
  panButtons.Left := ClientWidth - 123;
  panButtons.Height := PageControl1.Height - 35;
  //panButtons.Height := ClientHeight - panButtons.Top - (PageControl1.Height;

  LockWindowUpdate (0);
end;

//-------------------------------------------------------------------------

end.
