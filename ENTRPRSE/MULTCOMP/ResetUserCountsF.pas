unit ResetUserCountsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, GlobVar, VarConst;

type
  TfrmResetUserCounts = class(TForm)
    lvUserCounts: TListView;
    btnClose: TButton;
    btnRemove: TButton;
    btnRefresh: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvUserCountsColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure lvUserCountsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormResize(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    { Private declarations }
    Descending : Boolean;
    SortedColumn : Integer;
    MinSizeX, MinSizeY : Integer;

    // Returns a string description of the user count
    Function UserCountTypeString (Const UserCountType : Char) : ShortString;

    // Adds a User Count record into the list view
    procedure AddUserCount (Const UserCount : CompRec; Const UCSearchKey : Str255);
    // Empties the list view of any loaded user counts
    procedure ClearList;
    // Run through the User Count Records in Company.Dat loading them into the list
    procedure LoadList;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses BtrvU2, BTSupU1, ResetWorkstationUserCounts;

Type
  TUserCountDataType = Record
    SearchKey : Str255;
  End; // TUserCountDataType
  PUserCountDataType = ^TUserCountDataType;

//=========================================================================

procedure TfrmResetUserCounts.FormCreate(Sender: TObject);
begin
  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 540;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 150;      // captions into account

  Descending := False;
  SortedColumn := 0;
  LoadList;
end;

//------------------------------

procedure TfrmResetUserCounts.FormDestroy(Sender: TObject);
begin
  // Remove any items in the list
  ClearList;
end;

//-------------------------------------------------------------------------

Procedure TfrmResetUserCounts.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin // WMGetMinMaxInfo
  With Message.MinMaxInfo^ Do
  Begin
    ptMinTrackSize.X := MinSizeX;
    ptMinTrackSize.Y := MinSizeY;
  End; // With Message.MinMaxInfo^

  Message.Result:=0;

  Inherited;
End; // WMGetMinMaxInfo

//------------------------------

procedure TfrmResetUserCounts.FormResize(Sender: TObject);
begin
  // Note: Wrote custom FormResize as Anchors kept screwing the vertical height of the ListView
  btnClose.Top := 5;
  btnClose.Left := ClientWidth - 5 - btnClose.Width;
  btnRefresh.Left := btnClose.Left;
  btnRemove.Left := btnClose.Left;

  lvUserCounts.Left := 5;
  lvUserCounts.Width := btnClose.Left - 10;

  lvUserCounts.Top := 5;
  lvUserCounts.Height := ClientHeight - 10;
end;

//-------------------------------------------------------------------------

procedure TfrmResetUserCounts.lvUserCountsColumnClick(Sender: TObject; Column: TListColumn);
begin
  TListView(Sender).SortType := stNone;
  If (Column.Index <> SortedColumn) Then
  Begin
    SortedColumn := Column.Index;
    Descending := False;
  End
  Else
    Descending := not Descending;

  TListView(Sender).SortType := stText;
End;

//------------------------------

procedure TfrmResetUserCounts.lvUserCountsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  If (SortedColumn = 0) Then
    Compare := CompareText(Item1.Caption, Item2.Caption)
  Else
    Compare := CompareText(Item1.SubItems[SortedColumn-1], Item2.SubItems[SortedColumn-1]);

  If Descending Then
    Compare := -Compare;
end;

//-------------------------------------------------------------------------

// Returns a string description of the user count
Function TfrmResetUserCounts.UserCountTypeString (Const UserCountType : Char) : ShortString;
Begin // UserCountTypeString
  Case UserCountType Of
    cmUserCount      : Result := 'Exchequer';
    cmTKUserCount    : Result := 'Toolkit';
    cmTradeUserCount : Result := 'Trade Counter';
  Else
    Result := 'Unknown';
  End; // Case UserCountType
End; // UserCountTypeString

//------------------------------

// Empties the list view of any loaded user counts
procedure TfrmResetUserCounts.ClearList;
Var
  UserCountData : ^TUserCountDataType;
Begin // ClearList
  // Turn off sorting to reduce overhead
  lvUserCounts.SortType := stNone;

  While (lvUserCounts.Items.Count > 0) Do
  Begin
    UserCountData := lvUserCounts.Items[0].Data;
    FreeMem (UserCountData, SizeOf(UserCountData^));
    lvUserCounts.Items.Delete(0);
  End; // While (lvUserCounts.Items.Count > 0)
End; // ClearList

//------------------------------

// Adds a User Count record into the list view
procedure TfrmResetUserCounts.AddUserCount (Const UserCount : CompRec; Const UCSearchKey : Str255);
Var
  UserCountData : ^TUserCountDataType;
Begin // AddUserCount
  With lvUserCounts.Items.Add Do
  Begin
    // Type of User Count
    Caption := UserCountTypeString (UserCount.RecPFix);

    // Company
    SubItems.Add(Trim(UserCount.UserRef.ucName));

    // Workstation - Computer Name or TS Session
    SubItems.Add(Trim(UserCount.UserRef.ucWstationId));

    // Windows User Name that user is logged in on }
    SubItems.Add(Trim(UserCount.UserRef.ucUserId));

    // Reference Count
    SubItems.Add (IntToStr(UserCount.UserRef.ucRefCount));

    // Attach copy of record for later reference
    GetMem (UserCountData, SizeOf(UserCountData^));
    FillChar (UserCountData^, SizeOf(UserCountData^), #0);
    UserCountData.SearchKey := UCSearchKey;
    Data := UserCountData;
  End; // With lvUserCounts.Items.Add
End; // AddUserCount

//------------------------------

// Run through the User Count Records in Company.Dat loading them into the list
procedure TfrmResetUserCounts.LoadList;
Const
  RecPrefixes : Array [1..3] of Char = (cmUserCount, cmTKUserCount, cmTradeUserCount);
Var
  sKey : Str255;
  I, lStatus : Integer;
Begin // LoadList
  ClearList;

  // Turn off sorting otherwise it tries to sort the data once the caption of the
  // row is set, which causes it to crash with a Lsit Index Out of Bounds if the
  // sort is on one of the other (unpopulated) columns
  lvUserCounts.SortType := stNone;

  For I := Low(RecPrefixes) To High(RecPrefixes) Do
  Begin
    sKey := RecPrefixes[I];
    lStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
    While (lStatus = 0) And (Company^.RecPFix = RecPrefixes[I]) Do
    Begin
      AddUserCount (Company^, sKey);
      lStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
    End; // While (lStatus = 0) And (Company^.RecPFix = RecPrefixes[I])
  End; // For I

  // Re-instate the sorting
  lvUserCounts.SortType := stText;
End; // LoadList

//-------------------------------------------------------------------------

procedure TfrmResetUserCounts.btnRemoveClick(Sender: TObject);
Var
  sKey : Str255;
  lStatus, Res : Integer;
begin
  If Assigned(lvUserCounts.Selected) Then
  Begin
    With lvUserCounts.Selected Do
    Begin
      // Retrieve the search key for the record
      sKey := PUserCountDataType(Data)^.SearchKey;
      lStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
      If (lStatus = 0) And CheckKey(sKey, PUserCountDataType(Data)^.SearchKey, Length(PUserCountDataType(Data)^.SearchKey), True) Then
      Begin
        // Confirm
        If (MessageDlg ('Are you sure you want to remove the ' + UserCountTypeString (Company.RecPFix) +
                        ' User Count entry for user ' + Trim(Company.UserRef.ucUserId) +
                        ' on workstation ' + Trim(Company.UserRef.ucWStationId) + '?',
                        mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
        Begin
          // Remove the supplied User Count record - assumes we are currently positioned on it
          Res := RemoveWorkstationUserCount (Company^);
          If (Res = 0) Then
          Begin
            // 0 - AOK - refresh the list
            btnRefreshClick(Self);
          End // If (Res = 0)
          Else If (Res = 1) Then
          Begin
            // 1 - Invalid Company
            MessageDlg ('The User Count could not be removed as the Company Code is ' +
                        'not valid, please use the Reset System User Counts process to clear down ' +
                        'this User Count', mtError, [mbOK], 0);
          End // If (Res = 1)
          Else If (Res = 2) Then
          Begin
            // 2 - Invalid Company Path
            MessageDlg ('The User Count could not be removed as the Company Path is ' +
                        'not valid, please use the Reset System User Counts process to clear down ' +
                        'this User Count', mtError, [mbOK], 0);
          End // If (Res = 2)
          Else
          Begin
            // 100000+  Error opening company ExchqSS.Dat
            // 200000+  Error starting DB Transaction
            // 300000+  Error Reading/Locking ExchqSS record
            // 400000+  Error Reading/Locking User Count record
            // 500000+  Error Updating ExchqSS record
            // 600000+  Error Deleting ExchqSS record
            // 700000+  Error Ending DB Transaction
            // 800000+  Error Aborting DB Transaction
            MessageDlg ('An error ' + IntToStr(Res) + ' occurred whilst trying to remove the User Count ' +
                        'record', mtError, [mbOK], 0);
          End; // If (Res = 2)
        End; // If (MessageDlg ('Are you sure ...
      End; // If (lStatus = 0) And CheckKey(sKey, PUserCountDataType(Data)^.SearchKey, Length(PUserCountDataType(Data)^.SearchKey), True)
    End; // With lvUserCounts.Selected
  End; // If Assigned(lvUserCounts.Selected)
end;

//-------------------------------------------------------------------------

procedure TfrmResetUserCounts.btnRefreshClick(Sender: TObject);
Var
  Idx : Integer;
begin
  // Save the current position and refresh the list
  Idx := lvUserCounts.ItemIndex;

  LoadList;

  // Try to restore the position
  If (lvUserCounts.Items.Count > 0) Then
  Begin
    // If the saved position is within the list range then select it again -
    // this will position us on the row after the one we have just cleared,
    // otherwise just position on the last row
    If (Idx < lvUserCounts.Items.Count) Then
      lvUserCounts.ItemIndex := Idx
    Else
      lvUserCounts.ItemIndex := (lvUserCounts.Items.Count - 1);
  End; // If (lvUserCounts.Items.Count > 0)
end;

//=========================================================================

end.
