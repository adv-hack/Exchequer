unit GroupListF;

// Group List window for maintaining groups

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExDatasets, uBTGlobalDataset, ExtCtrls, uMultiList,
  uDBMultiList, GroupsFile, StdCtrls, TCustom, BTSupU1, uBtrieveDataset,
  Menus;

type
  TfrmGroupList = class(TForm)
    mulGroups: TDBMultiList;
    bdsGroups: TBTGlobalDataset;
    panButtons: TPanel;
    btnClose: TSBSButton;
    ScrollBox1: TScrollBox;
    btnAddGroup: TSBSButton;
    btnEditGroup: TSBSButton;
    btnDeleteGroup: TSBSButton;
    btnViewGroup: TSBSButton;
    btnFindGroup: TSBSButton;
    btnPrintGroup: TSBSButton;
    PopupMenu1: TPopupMenu;
    popAddGroup: TMenuItem;
    popEditGroup: TMenuItem;
    popDeleteGroup: TMenuItem;
    N1: TMenuItem;
    popFindGroup: TMenuItem;
    PopupOpt_SepBar2: TMenuItem;
    popFormProperties: TMenuItem;
    PopupOpt_SepBar3: TMenuItem;
    popSavePosition: TMenuItem;
    popViewGroup: TMenuItem;
    procedure bdsGroupsGetFieldValue(Sender: TObject;
      PData: Pointer; FieldName: String; var FieldValue: String);
    procedure bdsGroupsGetFileVar(Sender: TObject;
      var TheFileVar: pFileVar);
    procedure bdsGroupsGetDataRecord(Sender: TObject;
      var TheDataRecord: Pointer);
    procedure bdsGroupsGetBufferSize(Sender: TObject;
      var TheBufferSize: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddGroupClick(Sender: TObject);
    procedure btnEditGroupClick(Sender: TObject);
    procedure btnFindGroupClick(Sender: TObject);
    procedure btnDeleteGroupClick(Sender: TObject);
    procedure btnViewGroupClick(Sender: TObject);
    procedure mulGroupsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnPrintGroupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure popFormPropertiesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    DoneRestore : Boolean;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    // Optionally updates the list and repositions within the list on the
    // passed record
    Procedure FindAndPosition (Const GroupRec : GroupFileRecType; Const DoDBRefresh : Boolean);

    // Controls the loading/saving of the colours and positions
    //
    // Mode   0=Load Details, 1=Save Details, 2=Delete Details
    procedure SetColoursUndPositions (Const Mode : Byte);

    // Update the enabled/visible status of buttons and menu options depending on
    // the logged in status, ESN Errors, MCM Options, etc...
    procedure UpdateSecurityStatus;

    // Update the buttons panel based on the buttons visible status
    procedure UpdateButtonsPositions;

    Procedure WMCustGetRec(Var Message : TMessage); Message WM_CustGetRec;
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses GlobVar,
     BureauSecurity,   // SecurityManager Object
     GroupCompFile,   // Definition of GroupCmp.Dat (GroupCompXrefF) and utility functions
     GroupDetailF,     // Group Detail window
     GroupUsersFile,   // Definition of GroupUsr.Dat (GroupUsersF) and utility functions
     MCMFindF,         // Find Company dialog
     RepGroupsInputF,  // Contains the Groups Report
     uSettings,        // Colour/Position editing and saving routines
     BtrvU2;

//-------------------------------------------------------------------------

procedure TfrmGroupList.FormCreate(Sender: TObject);
begin
  ClientHeight := 188;
  ClientWidth := 558;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 450;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 116;      // captions into account

  // Update the enabled/visible status of buttons and menu options depending on
  // the logged in status, ESN Errors, MCM Options, etc...
  UpdateSecurityStatus;

  // Update the buttons panel based on the buttons visible status
  UpdateButtonsPositions;

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  SetColoursUndPositions (0);
end;

//------------------------------

procedure TfrmGroupList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Save colours/positions/sizes/etc...
  SetColoursUndPositions (1);
end;

//-------------------------------------------------------------------------

Procedure TfrmGroupList.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
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
procedure TfrmGroupList.UpdateSecurityStatus;
Begin // UpdateSecurityStatus
  // File Menu -------------------------------------------

  // Add Group
  btnAddGroup.Visible := SecurityManager.smUserPermissions[upAddGroup] Or
                           (SecurityManager.smUserType In [utSystem, utAdmin]);
  popAddGroup.Visible := btnAddGroup.Visible;

  // Edit Group
  btnEditGroup.Visible := SecurityManager.smUserPermissions[upEditGroup] Or
                           (SecurityManager.smUserType In [utSystem, utAdmin]);
  popEditGroup.Visible := btnEditGroup.Visible;

  // Delete Group
  btnDeleteGroup.Visible := SecurityManager.smUserPermissions[upDeleteGroup] Or
                           (SecurityManager.smUserType In [utSystem, utAdmin]);
  popDeleteGroup.Visible := btnDeleteGroup.Visible;

  // View Group - always Available

  // Find Group - always available

  // Print Group
  btnPrintGroup.Visible := SecurityManager.smUserPermissions[upPrintGroup] Or
                           (SecurityManager.smUserType In [utSystem, utAdmin]);
End; // UpdateSecurityStatus

//-------------------------------------------------------------------------

// Update the buttons panel based on the buttons visible status
procedure TfrmGroupList.UpdateButtonsPositions;
Var
  NextBtnTop : SmallInt;
  GotOpenBtn : Boolean;
Begin // UpdateButtonsPositions
  LockWindowUpdate (Handle);

  NextBtnTop := 1;
  If btnAddGroup.Visible Then
  Begin
    btnAddGroup.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnAddGroup.Height + 3;
  End; // If btnAddGroup.Visible
  If btnEditGroup.Visible Then
  Begin
    btnEditGroup.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnEditGroup.Height + 3;
  End; // If btnEditGroup.Visible
  If btnDeleteGroup.Visible Then
  Begin
    btnDeleteGroup.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnDeleteGroup.Height + 3;
  End; // If btnDeleteGroup.Visible
  // View Group button always available
  btnViewGroup.Top := NextBtnTop;
  NextBtnTop := NextBtnTop + btnViewGroup.Height + 3;
  // Find Group button always available
  btnFindGroup.Top := NextBtnTop;
  NextBtnTop := NextBtnTop + btnFindGroup.Height + 3;
  If btnPrintGroup.Visible Then
  Begin
    btnPrintGroup.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnPrintGroup.Height + 3;
  End; // If btnPrintGroup.Visible

  LockWindowUpdate (0);
End; // UpdateButtonsPositions

//-------------------------------------------------------------------------

procedure TfrmGroupList.bdsGroupsGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
Var
  pGroupRec : ^GroupFileRecType;
begin
  pGroupRec := pData;
  Case FieldName[1] Of
    '0' : FieldValue := Trim(pGroupRec^.grGroupCode);
    '1' : FieldValue := Trim(pGroupRec^.grGroupName);
  Else
    FieldValue := '?';
  End; // Case FieldName[1]
end;

//-------------------------------------------------------------------------

procedure TfrmGroupList.bdsGroupsGetFileVar(Sender: TObject;
  var TheFileVar: pFileVar);
begin
  TheFileVar := @F[GroupF];
end;

//------------------------------

procedure TfrmGroupList.bdsGroupsGetDataRecord(Sender: TObject;
  var TheDataRecord: Pointer);
begin
  TheDataRecord := RecPtr[GroupF];
end;

//------------------------------

procedure TfrmGroupList.bdsGroupsGetBufferSize(Sender: TObject;
  var TheBufferSize: Integer);
begin
  TheBufferSize := FileRecLen[GroupF];
end;

//-------------------------------------------------------------------------

procedure TfrmGroupList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------------------------------

procedure TfrmGroupList.btnAddGroupClick(Sender: TObject);
begin
  AddGroup(Self);
end;

//-------------------------------------------------------------------------

procedure TfrmGroupList.btnEditGroupClick(Sender: TObject);
Var
  Locked  : Boolean;
  KeyS    : Str255;
  LPos    : LongInt;
begin
  // Check a group is selected in the list
  If (mulGroups.Selected > -1) Then
  Begin
    // Load the selected record into the global record
    bdsGroups.GetRecord;

    // Read and Lock the current group
    Locked := False;
    KeyS := FullGroupCodeKey (GroupFileRec.grGroupCode);
    If GetMultiRec(B_GetEq, B_SingLock, KeyS, GroupCodeK, GroupF, True, Locked) And Locked Then
    Begin
      GetPos (F[GroupF], GroupF, LPos);
      EditGroup (Self, LPos);
    End; // If GetMultiRec(...
  End; // If (mulGroups.Selected > -1)
end;

//-------------------------------------------------------------------------

procedure TfrmGroupList.btnDeleteGroupClick(Sender: TObject);
Var
  OKToDelete : Boolean;
begin
  // Check a group is selected in the list
  If (mulGroups.Selected > -1) Then
  Begin
    // Load the selected record into the global record
    bdsGroups.GetRecord;

    // Check there are no companies in the group
    OKToDelete := Not GroupHasCompanies (GroupFileRec.grGroupCode);
    If OKToDelete Then
    Begin
      // check there are no users in the group
      OKToDelete := Not GroupHasUsers (GroupFileRec.grGroupCode);
      If OKToDelete Then
      Begin
        // Ask for confirmation before deleting the group
        If (MessageDlg('Please click the ''Yes'' button to confirm that you wish to delete the group ' +
                       QuotedStr(Trim(GroupFileRec.grGroupCode) + ' - ' + Trim(GroupFileRec.grGroupName)),
                       mtConfirmation, [mbYes,mbNo], 0) = mrYes) Then
        Begin
          // Delete the group and reload the list
          DeleteGroup (GroupFileRec.grGroupCode);
          mulGroups.RefreshDB;
        End; // If (MessageDlg('Please ...
      End // If OKToDelete
      Else
      Begin
        MessageDlg('The group ' + QuotedStr(Trim(GroupFileRec.grGroupCode)) + ' cannot be deleted ' +
                   'because it has users.  You must delete the users before you can delete the group',
                   mtError, [mbOK], 0);
      End; // Else
    End // If OKToDelete
    Else
    Begin
      MessageDlg('The group ' + QuotedStr(Trim(GroupFileRec.grGroupCode)) + ' cannot be deleted ' +
                 'because there are Companies linked to it.  You must remove the links to the companies ' +
                 'and delete any users in the group before you can delete the group', mtError, [mbOK], 0);
    End; // Else
  End; // If (mulGroups.Selected > -1)
end;

//-------------------------------------------------------------------------

procedure TfrmGroupList.btnFindGroupClick(Sender: TObject);
Var
  GroupRec : GroupFileRecType;
begin
  If FindGroup (Self, GroupRec) Then
  Begin
    FindAndPosition (GroupRec, False);
  End; // If FindGroup (Self, GroupRec^)
end;

//-------------------------------------------------------------------------

procedure TfrmGroupList.btnViewGroupClick(Sender: TObject);
begin
  // Check a group is selected in the list
  If (mulGroups.Selected > -1) Then
  Begin
    // Load the selected record into the global record
    bdsGroups.GetRecord;
    ViewGroup (Self);
  End; // If (mulGroups.Selected > -1)
end;

//------------------------------

procedure TfrmGroupList.mulGroupsRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnViewGroupClick(Sender);
end;

//-------------------------------------------------------------------------

// Optionally updates the list and repositions within the list on the
// passed record
Procedure TfrmGroupList.FindAndPosition (Const GroupRec : GroupFileRecType; Const DoDBRefresh : Boolean);
Var
  sKey       : ShortString;
  ColIdx     : SmallInt;
  SortAscend : Boolean;
Begin // FindAndPosition
  // Store data in local vars as RefreshDB overwrites some of it
  ColIdx := mulGroups.SortColIndex;
  SortAscend := mulGroups.SortAsc;
  Case ColIdx Of
    0 : Begin // Code
          sKey := GroupRec.grGroupCode;
        End; // 0 - Code
    1 : Begin // Name
          sKey := GroupRec.grGroupName;
        End // 1 - Name
  End; // Case ColIdx

  If DoDBRefresh Then
  Begin
    // Refresh the list and find the record we want
    mulGroups.RefreshDB;
  End; // If DoDBRefresh

  mulGroups.SearchColumn (ColIdx, SortAscend, sKey);
End; // FindAndPosition

//-------------------------------------------------------------------------

Procedure TfrmGroupList.WMCustGetRec(Var Message : TMessage);
Begin // WMCustGetRec
  With Message Do
  Begin
    Case WParam of
      // Record Added - refresh and find record in global record
      100 : Begin
              FindAndPosition (GroupFileRec, True);
            End; // 100
      // Record Edited - refresh and find record in global record
      200 : Begin
              FindAndPosition (GroupFileRec, True);
            End; // 200
    End // Case WParam
  End; // With Message
End; // WMCustGetRec

//-------------------------------------------------------------------------

procedure TfrmGroupList.btnPrintGroupClick(Sender: TObject);
Var
  DefaultGroup : String[GroupCodeLen];
begin
  // Work out the default for the report
  DefaultGroup := '';
  If (mulGroups.Selected > -1) Then
  Begin
    DefaultGroup := mulGroups.DesignColumns[0].Items[mulGroups.Selected];
  End; // If (mulGroups.Selected > -1)

  PrintGroupsReport(Self, DefaultGroup);
end;

//-------------------------------------------------------------------------

// Controls the loading/saving of the colours and positions
//
// Mode   0=Load Details, 1=Save Details, 2=Delete Details
procedure TfrmGroupList.SetColoursUndPositions (Const Mode : Byte);
Var
  WantAutoSave : Boolean;
Begin // SetColoursUndPositions
  Case Mode Of
    0 : Begin
          oSettings.LoadForm (Self, WantAutoSave);
          popSavePosition.Checked := WantAutoSave;
          oSettings.LoadList (mulGroups, Self.Name);
        End;
    1 : If (Not DoneRestore) Then
        Begin
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm (Self, popSavePosition.Checked);
          oSettings.SaveList (mulGroups, Self.Name);
        End; // If (Not DoneRestore)
    2 : Begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults (Self.Name);
          oSettings.RestoreListDefaults (mulGroups, Self.Name);
          popSavePosition.Checked := False;
        End;
  Else
    Raise Exception.Create ('TfrmGroupList.SetColoursUndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  End; // Case Mode
End; // SetColoursUndPositions

//-------------------------------------------------------------------------

procedure TfrmGroupList.popFormPropertiesClick(Sender: TObject);
begin
  // Call the colours dialog
  Case oSettings.Edit(mulGroups, Self.Name, NIL) Of
    mrOK              : ; // no other controls to colour
    mrRestoreDefaults : SetColoursUndPositions (2);
  End; // Case oSettings.Edit(...
end;

//-------------------------------------------------------------------------

procedure TfrmGroupList.FormResize(Sender: TObject);
begin
  LockWindowUpdate (Handle);

  // Resize/reposition the button containing the panels
  panButtons.Left := ClientWidth - panButtons.Width - 4;
  panButtons.Height := ClientHeight - 7;

  // Resize list component
  mulGroups.Height := panButtons.Height;
  mulGroups.Width := panButtons.Left - 7;

  LockWindowUpdate (0);
end;

//-------------------------------------------------------------------------

end.
