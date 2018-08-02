unit UserDetailF;

// User detail window

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, SBSOutl, StdCtrls, TCustom, ExtCtrls, Mask,
  TEditVal, bkgroup, Menus, ImgList,
  GroupUsersFile, ComCtrls;  // Definition of GroupUsr.Dat (GroupUsersF) and utility functions

type
  TUserDetailMode = (udmAdd, udmEdit, udmDelete, udmView);

  TfrmUserDetail = class(TForm)
    PageControl1: TPageControl;
    tabshMain: TTabSheet;
    LMGroupBox1: TGroupBox;
    edtCode: Text8Pt;
    edtName: Text8Pt;
    btnPanel: TPanel;
    btnCancel: TSBSButton;
    btnClose: TSBSButton;
    btnOK: TSBSButton;
    NLOLine: TSBSOutlineB;
    Image5: TImage;
    Label826: Label8;
    btnChangePassword: TSBSButton;
    PopupMenu1: TPopupMenu;
    popFormProperties: TMenuItem;
    PopupOpt_SepBar3: TMenuItem;
    popSavePosition: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure NLOLineExpand(Sender: TObject; Index: Integer);
    procedure NLOLineUpdateNode(Sender: TObject; var Node: TSBSOutLNode;
      Row: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnChangePasswordClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure popFormPropertiesClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }

    DoneRestore : Boolean;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    FLockPos : LongInt;
    FMode    : TUserDetailMode;

    procedure CheckRecLock;

    // Adds a security node into the outline control
    Function AddTreeNode(ParentIdx  : SmallInt;
                         LineText   : String;
                         PWNo       : TUserPermissions = upUndefined) : SmallInt;

    // Update the data record with the contents of the windows fields
    procedure FormToDataRec (Var DataRec : GroupUsersFileRecType);

    // Controls the loading/saving of the colours and positions
    //
    // Mode   0=Load Details, 1=Save Details, 2=Delete Details
    procedure SetColoursUndPositions (Const Mode : Byte);

    procedure SetMode (Const Mode : TUserDetailMode);

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
    Property LockPos : LongInt Read FLockPos Write FLockPos;
    Property Mode : TUserDetailMode Read FMode Write SetMode;

    // Puts the data record into the windows fields
    procedure DisplayData (Const DataRec : GroupUsersFileRecType);

  end;


// Adds a new User record for the Group, returns True if a user was added, else False
Procedure AddGroupUser (Const ParentForm : TForm; Const GroupCode : ShortString);

// Edits the user record loaded in the global GroupUsersFileRec structure, it
// is assumed that the record is already locked in the DB
Procedure EditGroupUser (Const ParentForm : TForm; Const LockPos : LongInt);

// Views an existing User record
Procedure ViewGroupUser (Const ParentForm : TForm);


implementation

{$R *.dfm}

Uses GlobVar, VarConst,
     ChangeUserPWord, // Routines for changing a Group Users Password
     GroupsFile,      // Groups File
     SavePos,         // TBtrieveSavePosition
     uSettings,       // Colour/Position editing and saving routines
     VAOUtil,
     Brand,
     EntLicence,
     BtrvU2, BTKeys1U, BTSupU1, BTSupU2;

//=========================================================================

// Adds a new User record for the Group
Procedure AddGroupUser (Const ParentForm : TForm; Const GroupCode : ShortString);
var
  frmUserDetail : TfrmUserDetail;
  I             : SmallInt;
Begin // AddGroupUser
  frmUserDetail := TfrmUserDetail.Create (ParentForm);
  Try
    // Reconfigure the form for adding a new Group
    frmUserDetail.Mode := udmAdd;

    // Initialise the group record
    FillChar (GroupUsersFileRec^, SizeOf (GroupUsersFileRec^), #0);
    GroupUsersFileRec^.guGroupCode := FullGroupCodeKey(GroupCode);
    If (MessageDlg('Would you like to create a group user with all the password ' +
                   'access settings set to Yes', mtConfirmation, [mbYes,mbNo], 0) = mrYes) Then
    Begin
      For I := Low(GroupUsersFileRec^.guPermissions) To High(GroupUsersFileRec^.guPermissions) Do
      Begin
        GroupUsersFileRec^.guPermissions[I] := True;
      End; // For I
    End;
    frmUserDetail.DisplayData (GroupUsersFileRec^);

    frmUserDetail.Caption := 'Add New User for Group ' + Trim(GroupCode);

    frmUserDetail.ShowModal;
  Finally
    FreeAndNIL(frmUserDetail);
  End; // Try..Finally
End; // AddGroupUser

//=========================================================================

// Edits the user record loaded in the global GroupUsersFileRec structure, it
// is assumed that the record is already locked in the DB
Procedure EditGroupUser (Const ParentForm : TForm; Const LockPos : LongInt);
var
  frmUserDetail : TfrmUserDetail;
Begin // EditGroupUser
  frmUserDetail := TfrmUserDetail.Create (ParentForm);
  Try
    // Reconfigure the form for the mode
    frmUserDetail.LockPos := LockPos;
    frmUserDetail.Mode := udmEdit;
    frmUserDetail.DisplayData (GroupUsersFileRec^);
    frmUserDetail.Caption := 'Edit User ' + Trim(GroupUsersFileRec^.guUserCode);
    frmUserDetail.ShowModal;
  Finally
    FreeAndNIL(frmUserDetail);
  End; // Try..Finally
End; // EditGroupUser

//=========================================================================

// Views an existing User record
Procedure ViewGroupUser (Const ParentForm : TForm);
var
  frmUserDetail: TfrmUserDetail;
Begin // ViewGroupUser
  frmUserDetail := TfrmUserDetail.Create (ParentForm);
  Try
    // Reconfigure the form for the mode
    frmUserDetail.Mode := udmView;
    frmUserDetail.DisplayData (GroupUsersFileRec^);
    frmUserDetail.Caption := 'View User ' + Trim(GroupUsersFileRec^.guUserCode);
    frmUserDetail.ShowModal;
  Finally
    FreeAndNIL(frmUserDetail);
  End; // Try..Finally
End; // ViewGroupUser

//=========================================================================

procedure TfrmUserDetail.FormCreate(Sender: TObject);
Var
  RootIdx, AdminIdx, Idx : SmallInt;
begin
  ClientHeight := 400;
  ClientWidth := 514;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 395;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 312;      // captions into account

  // Load the outline control with the security entries
  RootIdx  := AddTreeNode (0,       'Bureau Module');
  If (Not EnterpriseLicence.IsLITE) Then // IAO Bureau
              AddTreeNode (RootIdx,    'Open eBusiness Module',                       upOpenEBusiness);
              AddTreeNode (RootIdx,    'Open ' + Branding.pbProductName,              upOpenEnterprise);
              AddTreeNode (RootIdx,    'Open Rebuild Module',                         upRebuildGroup);
  If (Not EnterpriseLicence.IsLITE) Then // IAO Bureau
              AddTreeNode (RootIdx,    'Open Scheduler',                              upOpenScheduler);
  If (Not EnterpriseLicence.IsLITE) Then // IAO Bureau
              AddTreeNode (RootIdx,    'Open Sentimail',                              upOpenSentimail);
              AddTreeNode (RootIdx,    'Change Own Password',                         upChangeOwnPassword);
  AdminIdx := AddTreeNode (RootIdx,    'Administration');
  // HM 07/12/04: Limit Bureau Users options under VAO
  If (VAOInfo.vaoMode <> smVAO) Then
  Begin
              AddTreeNode (AdminIdx,      'Allow Access to MCM Options',              upEditMCMOptions);
  End; // If (VAOInfo.vaoMode <> smVAO)
       IDx := AddTreeNode (AdminIdx,      'Companies List');
              AddTreeNode (Idx,               'Allow Access To Companies List',       upAccessCompanies);
  // HM 07/12/04: Limit Bureau Users options under VAO
  If (VAOInfo.vaoMode <> smVAO) Then
  Begin
              AddTreeNode (Idx,               'Company Record - Allow Attach'         upAddCompany);
              AddTreeNode (Idx,               'Company Record - Allow Backup',        upBackupCompany);
              AddTreeNode (Idx,               'Company Record - Allow Detach',        upDeleteCompany);
              AddTreeNode (Idx,               'Company Record - Allow Edit',          upEditCompany);
              AddTreeNode (Idx,               'Company Record - Allow View',          upViewCompany);
  End; // If (VAOInfo.vaoMode <> smVAO)
              AddTreeNode (Idx,               'Company Record - Allow Rebuild',       upRebuildAllComps);
  // HM 07/12/04: Limit Bureau Users options under VAO
  If (VAOInfo.vaoMode <> smVAO) Then
  Begin
              AddTreeNode (Idx,               'Company Record - Allow Restore',       upRestoreCompany);
  End; // If (VAOInfo.vaoMode <> smVAO)
              AddTreeNode (Idx,               'Print Logged-In User Report',          upLoggedInUserReport);
       IDx := AddTreeNode (AdminIdx,      'Groups List');
              AddTreeNode (Idx,               'Allow Access To Groups List',          upAccessGroups);
              AddTreeNode (Idx,               'Group Records - Allow Add',            upAddGroup);
              AddTreeNode (Idx,               'Group Records - Allow Delete',         upDeleteGroup);
              AddTreeNode (Idx,               'Group Records - Allow Edit',           upEditGroup);
              AddTreeNode (Idx,               'Group Records - Allow Print',          upPrintGroup);
              AddTreeNode (Idx,               'Group Detail - Allow Add User',        upGrpAddUser);
              AddTreeNode (Idx,               'Group Detail - Allow Change Password', upGrpChangeUserPword);
              AddTreeNode (Idx,               'Group Detail - Allow Delete User',     upGrpDeleteUser);
              AddTreeNode (Idx,               'Group Detail - Allow Edit User',       upGrpEditUser);
              AddTreeNode (Idx,               'Group Detail - Allow Link Companies',  upGrpLinkCompanies);

  // Automatically expand all the entries
  NLOLine.FullExpand;

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  SetColoursUndPositions (0);
end;

//------------------------------

procedure TfrmUserDetail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Save colours/positions/sizes/etc...
  SetColoursUndPositions (1);

  // Remove any record lock that has been set and still remains
  CheckRecLock;
end;

//------------------------------

procedure TfrmUserDetail.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

//------------------------------

procedure TfrmUserDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

//-------------------------------------------------------------------------

Procedure TfrmUserDetail.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
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

// Adds a security node into the outline control
Function TfrmUserDetail.AddTreeNode(ParentIdx  : SmallInt;
                                    LineText   : String;
                                    PWNo       : TUserPermissions = upUndefined)  :  SmallInt;
Var
  ONomRec : ^OutNomType;
Begin
  With NLOLine Do
  Begin
    // Create a new instance of OutNomType on the heap to be attached to the tree item
    New(ONomRec);
    FillChar(ONomRec^,Sizeof(ONomRec^),0);
    // LastPr stores the index of the security item within the guPermissions array, 0=structural item
    ONomRec^.LastPr := Ord(PWNo);

    // Add the new tree item onto the outline and enable the checkbox where applicable
    Result:=AddChildObject(ParentIdx, LineText, ONomRec);
    If (Result > -1) Then
    Begin
      // Show a Checkbox against the item if it represents a security item
      // rather than part of the tree's organisational structure
      Items[Result].ShowCheckBox := (PWNo > upUndefined);
    End; // If (Result > -1)
  End; // With NLOLine
end;

//-------------------------------------------------------------------------

procedure TfrmUserDetail.NLOLineExpand(Sender: TObject; Index: Integer);
Var
  oNomRec : ^OutNomType;
begin
  With (Sender as TSBSOutLineB) Do
  Begin
    oNomRec := Items[Index].Data;
    If Assigned(oNomRec) Then
    Begin
      // Check to see if it is a security item rather than part of the tree structure and only change
      // if we are adding or editing
      {$WARNINGS OFF}
      If (ONomRec^.LastPR > Ord(upUndefined)) And (FMode In [udmAdd, udmEdit]) Then
      {$WARNINGS ON}
      Begin
        // Change value of password
        GroupUsersFileRec.guPermissions[ONomRec^.LastPR] := Not GroupUsersFileRec.guPermissions[ONomRec^.LastPR];

        // To get it to repaint instantly we need to change the selection and then change it back - bodgarama!
        SelectedItem := SelectedItem - 1;     // NOTE: This relies on the fact that the
        SelectedItem := SelectedItem + 1;     // first item is part of the tree structure
      End; // If (ONomRec^.LastPR > Ord(upUndefined)) And (FMode In [udmAdd, udmEdit])
    End; // If Assigned(oNomRec)
  End; // With (Sender as TSBSOutLineB)
end;

//-------------------------------------------------------------------------

procedure TfrmUserDetail.NLOLineUpdateNode(Sender: TObject;
  var Node: TSBSOutLNode; Row: Integer);
Var
  oNomRec : ^OutNomType;
begin
  oNomRec := Node.Data;
  If Assigned(oNomRec) Then
  Begin
    // Check to see if it is a security item rather than part of the tree structure
    {$WARNINGS OFF}
    If (ONomRec^.LastPR > Ord(upUndefined)) Then
    {$WARNINGS ON}
    Begin
      // Set the checkbox status from the permissions array on global user record
      Node.CheckBoxChecked := GroupUsersFileRec.guPermissions[ONomRec^.LastPR];

      // Define the bitmap to be displayed against the node
      If Node.CheckBoxChecked then
      Begin
        Node.UseLeafX := obLeaf2
      End // If Node.CheckBoxChecked
      Else
      Begin
        Node.UseLeafX := obLeaf;
      End; // Else
    End; // If (ONomRec^.LastPR > Ord(upUndefined))
  End; // If Assigned(oNomRec)
end;

//-------------------------------------------------------------------------

procedure TfrmUserDetail.SetMode (Const Mode : TUserDetailMode);
Begin // SetMode
  FMode := Mode;

  // OK/Cancel buttons only enabled in Add/Edit Mode
  btnOK.Enabled := (Mode in [udmAdd, udmEdit]);
  btnCancel.Enabled := btnOK.Enabled;

  // Close and Change Password buttons hidden in Add/Edit Mode
  btnClose.Visible := (Not btnOK.Enabled);
  btnChangePassword.Visible := (Not btnOK.Enabled);

  // Enable the Group header fields depending on the mode
  edtCode.ReadOnly := (Mode <> udmAdd);
  edtName.ReadOnly := (Not (Mode In [udmAdd, udmEdit]));
End; // SetMode

//-------------------------------------------------------------------------

// Puts the data record into the windows fields
procedure TfrmUserDetail.DisplayData (Const DataRec : GroupUsersFileRecType);
Begin // DisplayData
  edtCode.Text := Trim(DataRec.guUserCode);
  edtName.Text := Trim(DataRec.guUserName);
End; // DisplayData

//-------------------------------------------------------------------------

// Update the data record with the contents of the windows fields
procedure TfrmUserDetail.FormToDataRec (Var DataRec : GroupUsersFileRecType);
Begin // FormToDataRec
  // Copy the Code/Name fields from the form to the record and pad out to the
  // full indexed length of the strings with spaces
  DataRec.guUserCode := FullUserCode(edtCode.Text);
  DataRec.guUserName := FullUserName(edtName.Text);
End; // FormToDataRec

//-------------------------------------------------------------------------

procedure TfrmUserDetail.CheckRecLock;
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
        SaveFilePosition (GroupUsersF, GetPosKey);
        SaveDataBlock (GroupUsersFileRec, SizeOf(GroupUsersFileRec^));

        // Move the record address into the record structure and use the
        // unlock command to free the record lock
        KeyS := '';
        Move (FLockPos, GroupUsersFileRec^, SizeOf(FLockPos));
        lStatus := Find_Rec(B_Unlock, F[GroupUsersF], GroupUsersF, RecPtr[GroupUsersF]^, GroupUsersCodeK, KeyS);
        If (lStatus = 0) Then
        Begin
          // Unlocked - reset lock flag
          FLockPos := 0;
        End; // If (lStatus = 0)

        // Restore position in file
        RestoreSavedPosition;
        RestoreDataBlock (GroupUsersFileRec);
      Finally
        Free;
      End; // Try..Finally
    End; // With TBtrieveSavePosition.Create
  End; // If (FLockPos <> 0)
End; // CheckRecLock

//-------------------------------------------------------------------------

procedure TfrmUserDetail.btnOKClick(Sender: TObject);
Var
  lStatus  : SmallInt;
  KeyS     : Str255;
  Ok       : Boolean;
begin
  OK := True;

  // Copy the fields out of the form and Validate the record
  FormToDataRec (GroupUsersFileRec^);

  If (FMode = udmAdd) Then
  Begin
    // Check the User Code is globally unique
    OK := Not UserCodeExists(GroupUsersFileRec^.guUserCode);
    If (Not OK) Then
    Begin
      MessageDlg('A User with the code ' + QuotedStr(Trim(GroupUsersFileRec^.guUserCode)) + ' already exists', mtError, [mbOK], 0);
    End; // If (Not OK)
  End; // If (FMode = gdmAdd)

  If OK And (FMode = udmAdd) Then
  Begin
    // Ask for password
    OK := ProcessUserPasswordEntry (Self, GroupUsersFileRec^.guPassword, False);
  End; // If OK And (FMode = udmAdd)

  If OK Then
  Begin
    Case FMode Of
      udmAdd   : Begin
                   // Add the group into the DB
                   lStatus := Add_Rec (F[GroupUsersF], GroupUsersF, RecPtr[GroupUsersF]^, GroupUsersGroupCodeK);
                   If (lStatus = 0) Then
                   Begin
                     // Update the Groups List window
                     SendMessage (TForm(Self.Owner).Handle, WM_CustGetRec, 100, 0);
                     Close;
                   End // If (lStatus = 0)
                   Else
                   Begin
                     Report_BError (GroupUsersF, lStatus);
                   End; // Else
                 End;
      udmEdit  : Begin
                   // Reposition on the group being edited
                   KeyS := FullGroupCodeKey (GroupUsersFileRec^.guGroupCode) + FullUserCode (GroupUsersFileRec^.guUserCode);
                   lStatus := Find_Rec(B_GetEq+B_KeyOnly, F[GroupUsersF], GroupUsersF, RecPtr[GroupUsersF]^, GroupUsersGroupCodeK, KeyS);
                   If (lStatus = 0) Then
                   Begin
                     // Update the DB
                     lStatus := Put_Rec (F[GroupUsersF], GroupUsersF, RecPtr[GroupUsersF]^, GroupUsersGroupCodeK);
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
                   Report_BError (GroupUsersF, lStatus);
                 End;
    End; // Case FMode
  End; // If OK
end;

//-------------------------------------------------------------------------

procedure TfrmUserDetail.btnCancelClick(Sender: TObject);
begin
  If (FMode = udmEdit) Then
  Begin
    // Remove any record lock that has been set
    CheckRecLock;
  End; // If (FMode = udmEdit)

  Close;
end;

//-------------------------------------------------------------------------

procedure TfrmUserDetail.btnChangePasswordClick(Sender: TObject);
begin
  // Don't ask for the users password as this is an administration area
  ChangeUserPassword (Self, GroupUsersFileRec^.guUserCode, False);
end;

//-------------------------------------------------------------------------

procedure TfrmUserDetail.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

//-------------------------------------------------------------------------

// Controls the loading/saving of the colours and positions
//
// Mode   0=Load Details, 1=Save Details, 2=Delete Details
procedure TfrmUserDetail.SetColoursUndPositions (Const Mode : Byte);
Var
  WantAutoSave : Boolean;
Begin // SetColoursUndPositions
  Case Mode Of
    0 : Begin
          oSettings.LoadForm (Self, WantAutoSave);
          popSavePosition.Checked := WantAutoSave;
          oSettings.LoadParentToControl (tabshMain.Name, Self.Name, edtCode);
          oSettings.ColorFieldsFrom (edtCode, Self);
        End;
    1 : If (Not DoneRestore) Then
        Begin
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm (Self, popSavePosition.Checked);
          oSettings.SaveParentFromControl (edtCode, Self.Name, tabshMain.Name);
        End; // If (Not DoneRestore)
    2 : Begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults (Self.Name);
          oSettings.RestoreParentDefaults (tabshMain, Self.Name);
          popSavePosition.Checked := False;
        End;
  Else
    Raise Exception.Create ('TfrmUserDetail.SetColoursUndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  End; // Case Mode
End; // SetColoursUndPositions

//-------------------------------------------------------------------------

procedure TfrmUserDetail.popFormPropertiesClick(Sender: TObject);
begin
  // Call the colours dialog
  Case oSettings.Edit(NIL, Self.Name, edtCode) Of
    mrOK              : oSettings.ColorFieldsFrom (edtCode, tabshMain);
    mrRestoreDefaults : SetColoursUndPositions (2);
  End; // Case oSettings.Edit(...
end;

//-------------------------------------------------------------------------

procedure TfrmUserDetail.FormResize(Sender: TObject);
begin
  LockWindowUpdate (Handle);

  // Resize Page Control
  PageControl1.Height := ClientHeight - 5;
  PageControl1.Width := clientWidth - 6;

  LockWindowUpdate (0);
end;

//-------------------------------------------------------------------------

end.
