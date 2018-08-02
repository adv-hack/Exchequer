unit LinkCompaniesF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, TCustom, ExtCtrls, uMultiList, uDBMultiList,
  bkgroup, StrUtils, Menus;

type
  TCompanyDetails = Class(TObject)
  Private
    FCode    : ShortString;
    FName    : ShortString;
    FInGroup : Boolean;
    FSaved   : Boolean;
  Public
    Property cxCode : ShortString Read FCode Write FCode;
    Property cxName : ShortString Read FName Write FName;
    Property cxInGroup : Boolean Read FInGroup Write FInGroup;
    Property cxSaved : Boolean Read FSaved Write FSaved;

    Constructor Create;
  End; // TCompanyDetails

  //------------------------------

  TCompanyList = Class(TObject)
  Private
    ListByCode : TStringList;
    ListByName : TStringList;

    Function GetCompanyCodeDetails (Index : SmallInt) : TCompanyDetails;
    Function GetCompanyNameDetails (Index : SmallInt) : TCompanyDetails;
    Function GetCompanyCodeDetailsByCode (Index : ShortString) : TCompanyDetails;
    Function GetCount : SmallInt;
  Public
    // Returns a company details object from the code ordered list
    Property CompanyCodeDetails [Index : SmallInt] : TCompanyDetails Read GetCompanyCodeDetails;

    // Returns a company details object from the name ordered list
    Property CompanyNameDetails [Index : SmallInt] : TCompanyDetails Read GetCompanyNameDetails;

    // Returns a company details object from the code ordered list with the specified code
    Property CompanyCodeDetailsByCode [Index : ShortString] : TCompanyDetails Read GetCompanyCodeDetailsByCode;

    // The number of company details objects
    Property Count : SmallInt Read GetCount;

    Constructor Create;
    Destructor Destroy; Override;

    // Loads the companies
    Procedure LoadCompanyList (Const GroupCode : ShortString);
  End; // TCompanyList

  //------------------------------

  TfrmLinkCompanies = class(TForm)
    btnDeselectOne: TSBSButton;
    btnDeselectMultiple: TSBSButton;
    btnDeselectAll: TSBSButton;
    btnSelectOne: TSBSButton;
    btnSelectMultiple: TSBSButton;
    btnSelectAll: TSBSButton;
    lblNotInGroup: Label8;
    lblInGroup: Label8;
    SBSBackGroup1: TSBSBackGroup;
    mulInGroup: TMultiList;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    btnFindCompany: TSBSButton;
    mulNotInGroup: TMultiList;
    PopupMenu1: TPopupMenu;
    popFormProperties: TMenuItem;
    PopupOpt_SepBar3: TMenuItem;
    popSavePosition: TMenuItem;
    procedure btnFindCompanyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnSelectOneClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mulNotInGroupRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnDeselectOneClick(Sender: TObject);
    procedure mulInGroupRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnSelectMultipleClick(Sender: TObject);
    procedure btnDeselectMultipleClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnDeselectAllClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure popFormPropertiesClick(Sender: TObject);
  private
    { Private declarations }
    ChangedGroups : Boolean;

    DoneRestore : Boolean;

    ResizeCoords : Array [1..5] Of LongInt;

    FCompanyList : TCompanyList;

    FGroupCode : ShortString;

    // Loads a specified company list with the details from the internal cache
    Procedure LoadGroupList (Const DestList : TMultiList; Const WantInGroup : Boolean);

    // Moves aa companies from one list to the other
    procedure MoveAll(Const FromGroupList, ToGroupList : TMultiList; Const InGroupStatus : Boolean);

    // Moves multiple selected entries from one list to the other
    procedure MoveMultiple(Const FromGroupList, ToGroupList : TMultiList; Const InGroupStatus : Boolean);

    // Moves the selected entry from one list to the other
    Procedure MoveSingle (Const FromGroupList, ToGroupList : TMultiList; Const InGroupStatus : Boolean);

    // Loads both lists using LoadGroupList
    Procedure ReloadGroupLists;

    // Controls the loading/saving of the colours and positions
    //
    // Mode   0=Load Details, 1=Save Details, 2=Delete Details
    procedure SetColoursUndPositions (Const Mode : Byte);

    Procedure SetGroupCode(Const Value : ShortString);

    // Control the minimum size that the form can resize to - works better than constraints
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
    Property GroupCode : ShortString Read FGroupCode Write SetGroupCode;

    // Called to load the company lists for the GroupCode
    Procedure LoadLists;
  end;


// Displays the LinkCompanies dialog for the specified Group, returns
// TRUE if changes were made
Function LinkCompanies (Const OwnerForm : TForm; Const GroupCode : ShortString) : Boolean;


implementation

{$R *.dfm}

Uses GlobVar, VarConst, BtrvU2, MCMFindF, SavePos, IIFFuncs, BTSupU1, BTKeys1U,
     GroupsFile,      // Definition of Groups.Dat (GroupF) and utility functions
     GroupCompFile,   // Definition of GroupCmp.Dat (GroupCompXrefF) and utility functions
     uSettings;       // Colour/Position editing and saving routines


//-------------------------------------------------------------------------

// Displays the LinkCompanies dialog for the specified Group, returns
// TRUE if changes were made
Function LinkCompanies (Const OwnerForm : TForm; Const GroupCode : ShortString) : Boolean;
var
  frmLinkCompanies: TfrmLinkCompanies;
Begin // LinkCompanies
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveFilePosition (CompF, GetPosKey);
      SaveDataBlock (Company, SizeOf(Company^));

      //------------------------------

      frmLinkCompanies := TfrmLinkCompanies.Create(OwnerForm);
      Try
        frmLinkCompanies.GroupCode := Trim(GroupCode);
        frmLinkCompanies.LoadLists;

        Result := (frmLinkCompanies.ShowModal = mrOK);
      Finally
        FreeAndNIL(frmLinkCompanies);
      End; // Try..Finally

      //------------------------------

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (Company);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // LinkCompanies

//=========================================================================

Constructor TCompanyDetails.Create;
Begin // Create
  Inherited Create;

  FCode    := '';
  FName    := '';
  FInGroup := False;
  FSaved   := False;
End; // Create

//=========================================================================

// Loads the list with the company details
Constructor TCompanyList.Create;
Begin // Create
  Inherited Create;

  // Create the internal lists that store the Company Objects indexed by
  // code and name
  ListByCode := TStringList.Create;
  ListByCode.Sorted := True;
  ListByName := TStringList.Create;
  ListByName.Sorted := True;
End; // Create

//------------------------------

Destructor TCompanyList.Destroy;
Var
  CompObj : TCompanyDetails;
Begin // Destroy
  // Run through the Code list and remove all the objects from the list, as the
  // objects are shared by both lists don't do the same for the name list
  While (ListByCode.Count > 0) Do
  Begin
    CompObj := TCompanyDetails(ListByCode.Objects[0]);
    CompObj.Free;
    ListByCode.Delete(0);
  End; // While (ListByCode.Count > 0)

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Loads the companies
Procedure TCompanyList.LoadCompanyList (Const GroupCode : ShortString);
Var
  CompObj      : TCompanyDetails;
  iStatus      : SmallInt;
  sKey, sCheck : Str255;
Begin // Create
  // Step 1: Run through the company database loading the details for all
  // companies into the internal lists sharing a common object
  sKey := cmCompDet;
  iStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
  While (iStatus = 0) And (Company^.RecPFix = cmCompDet) Do
  Begin
    // Create an object to store the details about the company for the
    // life of the Link To Companies dialog
    CompObj := TCompanyDetails.Create;
    CompObj.cxCode := Trim(Company^.CompDet.CompCode);
    CompObj.cxName := Trim(Company^.CompDet.CompName);

    // Add the object into the list sorted by Company Code
    ListByCode.AddObject (CompObj.cxCode, CompObj);
    // Also add the object into the list sorted by Company Name
    ListByName.AddObject (CompObj.cxName, CompObj);

    iStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
  End; // While (iStatus = 0) And (Company^.RecPFix = cmCompDet)


  // Step 2: Run through the Group-Company XRef table setting the InGroup
  // flags on the Company objects for those companies already in the group
  sKey := FullGroupCodeKey (GroupCode);
  sCheck := sKey;
  iStatus := Find_Rec(B_GetGEq, F[GroupCompXRefF], GroupCompXRefF, RecPtr[GroupCompXRefF]^, GroupCompXRefGroupK, sKey);
  While (iStatus = 0) And (GroupCompFileRec^.gcGroupCode = sCheck) Do
  Begin
    // Set the In Group status to True for the company
    Try
      CompanyCodeDetailsByCode[Trim(GroupCompFileRec^.gcCompanyCode)].cxInGroup := True;
    Except
      // This is likely to be caused by the company being deleted and the
      // group-Company xref being left undeleted
      On Exception Do
        ;
    End; // Try..Except

    iStatus := Find_Rec(B_GetNext, F[GroupCompXRefF], GroupCompXRefF, RecPtr[GroupCompXRefF]^, GroupCompXRefGroupK, sKey);
  End; // While (iStatus = 0) And (...
End; // LoadCompanyList

//-------------------------------------------------------------------------

// The number of company details objects
Function TCompanyList.GetCount : SmallInt;
Begin // GetCount
  Result := ListByCode.Count;
End; // GetCount

//-------------------------------------------------------------------------

// Returns the specified Company object from the code ordered list
Function TCompanyList.GetCompanyCodeDetails (Index : SmallInt) : TCompanyDetails;
Begin // GetCompanyCodeDetails
  If (Index >= 0) And (Index < ListByCode.Count) Then
  Begin
    Result := TCompanyDetails(ListByCode.Objects[Index]);
  End // If (Index >= 0) And (Index < ListByCode.Count)
  Else
  Begin
    Raise Exception.Create ('TCompanyList.GetCompanyCodeDetails: Invalid Index when reading CompanyDetails array');
  End; // Else
End; // GetCompanyCodeDetails

//-------------------------------------------------------------------------

// Returns the specified Company object from the name ordered list
Function TCompanyList.GetCompanyNameDetails (Index : SmallInt) : TCompanyDetails;
Begin // GetCompanyNameDetails
  If (Index >= 0) And (Index < ListByName.Count) Then
  Begin
    Result := TCompanyDetails(ListByName.Objects[Index]);
  End // If (Index >= 0) And (Index < Count)
  Else
  Begin
    Raise Exception.Create ('TCompanyList.GetCompanyNameDetails: Invalid Index when reading CompanyDetails array');
  End; // Else
End; // GetCompanyNameDetails

//-------------------------------------------------------------------------

// Finds and returns the Company object for the specified Code
Function TCompanyList.GetCompanyCodeDetailsByCode (Index : ShortString) : TCompanyDetails;
Var
  CompIdx : SmallInt;
Begin // GetCompanyCodeDetailsByCode
  CompIdx := ListByCode.IndexOf (Trim(Index));
  If (CompIdx >= 0) Then
  Begin
    Result := GetCompanyCodeDetails (CompIdx);
  End // If (CompIdx >= 0)
  Else
  Begin
    Raise Exception.Create ('TCompanyList.GetCompanyCodeDetailsByCode: Invalid Code when reading CompanyDetails array');
  End; // Else
End; // GetCompanyCodeDetailsByCode

//=========================================================================

procedure TfrmLinkCompanies.FormCreate(Sender: TObject);
begin // FormCreate
  // Store co-ordinates used when resizing the form
//  ResizeCoords[1] := ClientWidth - mulNotInGroup.Width - mulInGroup.Width;
  ResizeCoords[1] := SBSBackGroup1.Width - mulNotInGroup.Width - mulInGroup.Width;
  ResizeCoords[2] := mulInGroup.Left - mulNotInGroup.Width;
  ResizeCoords[3] := mulInGroup.Left - btnSelectOne.Left;
//  ResizeCoords[4] := ClientHeight - mulNotInGroup.Height;
  ResizeCoords[4] := SBSBackGroup1.Height - mulNotInGroup.Height;
  ResizeCoords[5] := mulNotInGroup.Width - lblNotInGroup.Width;

  // This flag records whether the user has made changes to the company
  // selection for the group
  ChangedGroups := False;

  // Create the company list which stores all the company details indexed
  // on Company Code
  FCompanyList := TCompanyList.Create;

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  SetColoursUndPositions (0);
end; // FormCreate

//------------------------------

Procedure TfrmLinkCompanies.FormDestroy(Sender: TObject);
Begin // FormDestroy
  // Save colours/positions/sizes/etc...
  SetColoursUndPositions (1);

  FreeAndNIL(FCompanyList);
End; // FormDestroy

//-------------------------------------------------------------------------

// Called to load the company lists for the GroupCode
Procedure TfrmLinkCompanies.LoadLists;
Begin // LoadLists
  // Load the internal companies list
  FCompanyList.LoadCompanyList(FGroupCode);

  // Load the 'not in Group' and 'in Group' multilists and set them to sort
  // on the Company Code
  LoadGroupList (mulNotInGroup, False);
  mulNotInGroup.SortColumn (0, True);

  LoadGroupList (mulInGroup, True);
  mulInGroup.SortColumn (0, True);
End; // LoadLists

//-------------------------------------------------------------------------

// Control the minimum size that the form can resize to - works better than constraints
Procedure TfrmLinkCompanies.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
Begin // WMGetMinMaxInfo
  With Message.MinMaxInfo^ Do
  Begin
    ptMinTrackSize.X := 580;
    ptMinTrackSize.Y := 289;
  End; // With Message.MinMaxInfo^

  Message.Result:=0;

  Inherited;
End; // WMGetMinMaxInfo

//-------------------------------------------------------------------------

// Have to manually resize/reposition the controls as we want both
// MultiLists to grow equally as the form grows bigger which standard
// Delphi handling can't do (AFAIK)
procedure TfrmLinkCompanies.FormResize(Sender: TObject);
begin
  // Lock the screen updating for this window to prevent flickering
  LockWindowUpdate(Self.Handle);
  Try
    SBSBackGroup1.Height := ClientHeight - 31;
    SBSBackGroup1.Width := ClientWidth - 8;

    // Reset the size of the 'not in Group' list
    mulNotInGroup.Width := (SBSBackGroup1.Width - ResizeCoords[1]) Div 2;
    mulNotInGroup.Height := SBSBackGroup1.Height - ResizeCoords[4];

    // Reset the size of the 'in Group' list
    mulInGroup.Left  := mulNotInGroup.Width + ResizeCoords[2];
    mulInGroup.Width := SBSBackGroup1.Width - ResizeCoords[1] - mulNotInGroup.Width;
    mulInGroup.Height := mulNotInGroup.Height;

    // Reset the position/size of the list labels
    lblNotInGroup.Left := mulNotInGroup.Left;
    lblNotInGroup.Width := mulNotInGroup.Width - ResizeCoords[5];
    lblInGroup.Left := mulInGroup.Left;
    lblInGroup.Width := mulInGroup.Width - ResizeCoords[5];

    // Reposition the button column between the two lists
    btnSelectOne.Left := mulInGroup.Left - ResizeCoords[3];
    btnSelectMultiple.Left := btnSelectOne.Left;
    btnSelectAll.Left := btnSelectOne.Left;
    btnDeselectOne.Left := btnSelectOne.Left;
    btnDeselectMultiple.Left := btnSelectOne.Left;
    btnDeselectAll.Left := btnSelectOne.Left;
    btnFindCompany.Left := btnSelectOne.Left;

    // Vertically center the buttons between the lists
    btnSelectOne.Top := mulInGroup.Top + ((mulInGroup.Height - (btnFindCompany.Top + btnFindCompany.Height - btnSelectOne.Top)) Div 2);
    btnSelectMultiple.Top := btnSelectOne.Top + btnSelectOne.Height + 3;
    btnSelectAll.Top := btnSelectMultiple.Top + btnSelectMultiple.Height + 3;
    btnDeselectOne.Top := btnSelectAll.Top + btnSelectAll.Height + 8;
    btnDeselectMultiple.Top := btnDeselectOne.Top + btnDeselectOne.Height + 3;
    btnDeselectAll.Top := btnDeselectMultiple.Top + btnDeselectMultiple.Height + 3;
    btnFindCompany.Top := btnDeselectAll.Top + btnDeselectAll.Height + 8;

    // Re-centre the OK/Cancel buttons at the bottom
    btnOK.Top := ClientHeight - 25;
    btnOK.Left := (ClientWidth - (btnCancel.Left + btnCancel.Width - btnOk.Left)) Div 2;
    btnCancel.Top := btnOK.Top;
    btnCancel.Left := btnOK.Left + btnOK.Width + 6;
  Finally
    LockWindowUpdate(0);
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

Procedure TfrmLinkCompanies.SetGroupCode(Const Value : ShortString);
Begin // SetGroupCode
  FGroupCode := Trim(Value);
  Caption := 'Link Companies to Group ' + FGroupCode;
End; // SetGroupCode

//-------------------------------------------------------------------------

// Loads a specified company list with the details from the internal cache
Procedure TfrmLinkCompanies.LoadGroupList (Const DestList : TMultiList; Const WantInGroup : Boolean);
Var
  CompObj : TCompanyDetails;
  I       : SmallInt;
Begin // LoadGroupList
  // Remove any existing items from the list
  DestList.ClearItems;

  // run through the company list loading the details into
  // the 'not in Group' lists
  If (FCompanyList.Count > 0) Then
  Begin
    If (DestList.SortedAsc) Then
    Begin
      // List is sorted in ascending order
      For I := 0 To FCompanyList.Count - 1 Do
      Begin
        Case DestList.SortedIndex Of
          -1, 0 : CompObj := FCompanyList.CompanyCodeDetails[I];
          1     : CompObj := FCompanyList.CompanyNameDetails[I];
        Else
          CompObj := NIL;
        End; // Case DestList.SortedCol

        If Assigned(CompObj) And (CompObj.cxInGroup = WantInGroup) Then
        Begin
          DestList.DesignColumns[0].Items.Add (CompObj.cxCode);
          DestList.DesignColumns[1].Items.Add (CompObj.cxName);
        End; // If Assigned(CompObj) And (CompObj.cxInGroup = WantInGroup)
      End; // For I
    End // If (DestList.SortedAsc)
    Else
    Begin
      // List is sorted in descending order
      For I := FCompanyList.Count - 1 DownTo 0 Do
      Begin
        Case DestList.SortedIndex Of
          -1, 0 : CompObj := FCompanyList.CompanyCodeDetails[I];
          1     : CompObj := FCompanyList.CompanyNameDetails[I];
        Else
          CompObj := NIL;
        End; // Case DestList.SortedCol

        If Assigned(CompObj) And (CompObj.cxInGroup = WantInGroup) Then
        Begin
          DestList.DesignColumns[0].Items.Add (CompObj.cxCode);
          DestList.DesignColumns[1].Items.Add (CompObj.cxName);
        End; // If Assigned(CompObj) And (CompObj.cxInGroup = WantInGroup) 
      End; // For I
    End; // Else
  End; // If (FCompanyList.Count > 0)
End; // LoadGroupList

//------------------------------

// Loads both lists using LoadGroupList
Procedure TfrmLinkCompanies.ReloadGroupLists;
Begin // ReloadGroupLists
  LoadGroupList (mulNotInGroup, False);
  LoadGroupList (mulInGroup, True);
End; // ReloadGroupLists

//-------------------------------------------------------------------------

procedure TfrmLinkCompanies.btnFindCompanyClick(Sender: TObject);
Var
  CompanyRec : ^CompanyDetRec;
  RowIdx     : SmallInt;
begin
  New (CompanyRec);
  Try
    If FindCompany (Self, CompanyRec^) Then
    Begin
      // Look in the 'not in Group' list for the company
      RowIdx := mulNotInGroup.DesignColumns[0].Items.IndexOf(Trim(CompanyRec^.CompCode));
      If (RowIdx >= 0) Then
      Begin
        // Company has been found in the 'not in Group' list - select and change focus
        mulNotInGroup.Selected := RowIdx;
        If mulNotInGroup.CanFocus Then
        Begin
          mulNotInGroup.SetFocus;
        End; // If mulNotInGroup.CanFocus
      End // If (RowIdx >= 0)
      Else
      Begin
        // Company SHOULD be in the 'in Group' list
        RowIdx := mulInGroup.DesignColumns[0].Items.IndexOf(Trim(CompanyRec^.CompCode));
        If (RowIdx >= 0) Then
        Begin
          // Company has been found in the 'not in Group' list
          mulInGroup.Selected := RowIdx;
          If mulInGroup.CanFocus Then
          Begin
            mulInGroup.SetFocus;
          End; // If mulInGroup.CanFocus
        End // If (RowIdx >= 0)
      End; // Else
    End; // If FindGroup (Self, GroupRec^)
  Finally
    Dispose(CompanyRec);
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

// Moves the selected entry from one list to the other
Procedure TfrmLinkCompanies.MoveSingle (Const FromGroupList, ToGroupList : TMultiList; Const InGroupStatus : Boolean);
Var
  CompCode : ShortString;
  CompIdx  : SmallInt;
begin
  If (FromGroupList.Selected >= 0) Then
  Begin
    // Extract the Company Code of the selected item
    CompCode := FromGroupList.DesignColumns[0].Items[FromGroupList.Selected];

    // Reset its 'in group' status
    FCompanyList.CompanyCodeDetailsByCode[CompCode].cxInGroup := InGroupStatus;

    // Update the lists to reflect the changes
    ReloadGroupLists;

    // Position on the moved company in the 'in Group' list
    CompIdx := ToGroupList.DesignColumns[0].Items.IndexOf(CompCode);
    If (CompIdx >= 0) Then
    Begin
      ToGroupList.Selected := CompIdx;
    End; // If (CompIdx >= 0)

    // Mark the company selection as changed
    ChangedGroups := True;
  End; // If (GroupList.Selected >= 0)
end;

//------------------------------

// Double Click on 'Not In Group' List - moves the selected item from the 'not in Group'
// list to the 'in Group' list
procedure TfrmLinkCompanies.mulNotInGroupRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  MoveSingle (mulNotInGroup, mulInGroup, True);
end;

//------------------------------

// '>' button - moves the selected item from the 'not in Group' list to the 'in Group' list
procedure TfrmLinkCompanies.btnSelectOneClick(Sender: TObject);
begin
  MoveSingle (mulNotInGroup, mulInGroup, True);
end;

//------------------------------

// Double Click on 'In Group' List - moves the selected item from the 'in Group'
// list to the 'Not in Group' list
procedure TfrmLinkCompanies.mulInGroupRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  MoveSingle (mulInGroup, mulNotInGroup, False);
end;

//------------------------------

// '<' button - moves the selected item from the 'in Group' list to the 'not in Group' list
procedure TfrmLinkCompanies.btnDeselectOneClick(Sender: TObject);
begin
  MoveSingle (mulInGroup, mulNotInGroup, False);
end;

//-------------------------------------------------------------------------

// Moves multiple selected entries from one list to the other
procedure TfrmLinkCompanies.MoveMultiple(Const FromGroupList, ToGroupList : TMultiList; Const InGroupStatus : Boolean);
Var
  CompIdx, I : SmallInt;
  CompCode   : ShortString;
begin
  // Run through the MultiSelect array reclassifying the selected companies
  For I := Low(FromGroupList.MultiSelected) To High(FromGroupList.MultiSelected) Do
  Begin
    If FromGroupList.MultiSelected[I] Then
    Begin
      // Extract the Company Code of the selected item
      CompCode := FromGroupList.DesignColumns[0].Items[I];

      // Reset its 'in group' status
      FCompanyList.CompanyCodeDetailsByCode[CompCode].cxInGroup := InGroupStatus;
    End; // If FromGroupList.MultiSelected[I]
  End; // For I

  // Update the lists to reflect the changes
  ReloadGroupLists;

  // Position on the moved company in the 'in Group' list
  CompIdx := ToGroupList.DesignColumns[0].Items.IndexOf(CompCode);
  If (CompIdx >= 0) Then
  Begin
    ToGroupList.Selected := CompIdx;
  End; // If (CompIdx >= 0)
End; //

//------------------------------

procedure TfrmLinkCompanies.btnSelectMultipleClick(Sender: TObject);
begin
  MoveMultiple (mulNotInGroup, mulInGroup, True);
end;

//------------------------------

procedure TfrmLinkCompanies.btnDeselectMultipleClick(Sender: TObject);
begin
  MoveMultiple (mulInGroup, mulNotInGroup, False);
end;

//-------------------------------------------------------------------------

// Moves aa companies from one list to the other
procedure TfrmLinkCompanies.MoveAll(Const FromGroupList, ToGroupList : TMultiList; Const InGroupStatus : Boolean);
Var
  I : SmallInt;
Begin // MoveAll
  // Run through the full company list setting the InGroup status
  If (FCompanyList.Count > 0) Then
  Begin
    For I := 0 To FCompanyList.Count - 1 Do
    Begin
      FCompanyList.CompanyCodeDetails[I].cxInGroup := InGroupStatus;
    End; // For I

    // Update the lists to reflect the changes
    ReloadGroupLists;

    // Position on the first company
    ToGroupList.Selected := 0;

    // Mark the company selection as changed
    ChangedGroups := True;
  End; // If (FCompanyList.Count > 0)
End; // MoveAll

//------------------------------

procedure TfrmLinkCompanies.btnSelectAllClick(Sender: TObject);
begin
  MoveAll (mulNotInGroup, mulInGroup, True);
end;

//------------------------------

procedure TfrmLinkCompanies.btnDeselectAllClick(Sender: TObject);
begin
  MoveAll (mulInGroup, mulNotInGroup, False);
end;

//-------------------------------------------------------------------------

procedure TfrmLinkCompanies.btnOKClick(Sender: TObject);
Var
  oCompDets    : TCompanyDetails;
  iStatus, I   : SmallInt;
  sKey, sCheck : Str255;
  sError       : ANSIString;
  bGotError    : Boolean;
begin
  bGotError := False;

  // Step 1: Run through all the existing Group-Company XRef records for the
  // Group removing those not in the group any more
  sKey := FullGroupCodeKey (FGroupCode);
  sCheck := sKey;
  iStatus := Find_Rec(B_GetGEq, F[GroupCompXRefF], GroupCompXRefF, RecPtr[GroupCompXRefF]^, GroupCompXRefGroupK, sKey);
  While (iStatus = 0) And (GroupCompFileRec^.gcGroupCode = sCheck) Do
  Begin
    // Lookup the company code in the internal companies list and check its In Group status
    Try
      oCompDets := FCompanyList.CompanyCodeDetailsByCode[Trim(GroupCompFileRec^.gcCompanyCode)];
    Except
      // This is likely to be caused by the company being deleted and the
      // group-Company xref being left undeleted, this handler will cause
      // the entry to be deleted
//      On Exception Do
        oCompDets := NIL;
    End; // Try..Except

    If Assigned(oCompDets) And oCompDets.cxInGroup Then
    Begin
      // Still in group - mark as saved so we don't try to save it later
      oCompDets.cxSaved := True;
    End // If Assigned(oCompDets) And oCompDets.cxInGroup
    Else
    Begin
      // Removed from group - delete the record
      iStatus := Delete_Rec (F[GroupCompXRefF], GroupCompXRefF, GroupCompXRefGroupK);
      If (iStatus <> 0) Then
      Begin
        sError := Format('Error %d deleting Company-Group Xref entry for %s-%s'#13#13,
                         [iStatus, Trim(GroupCompFileRec^.gcGroupCode), Trim(GroupCompFileRec^.gcCompanyCode)]);
        MessageDlg (sError, mtError, [mbOk], 0);

        // Set error flag so window doesn't close losing the settings
        bGotError := True;
      End; // If (iStatus <> 0)
    End; // Else

    // Move to next Group-Company Xref record
    iStatus := Find_Rec(B_GetNext, F[GroupCompXRefF], GroupCompXRefF, RecPtr[GroupCompXRefF]^, GroupCompXRefGroupK, sKey);
  End; // While (iStatus = 0) And (GroupCompFileRec^.gcGroupCode = sCheck)


  // Step 2: Run through the internal Companies List saving Xref records for
  // the companies in the group
  If (FCompanyList.Count > 0) Then
  Begin
    For I := 0 To FCompanyList.Count - 1 Do
    Begin
      // Extract the company details from the internal companies list and check whether it needs saving
      oCompDets := FCompanyList.CompanyCodeDetails[I];
      If oCompDets.cxInGroup And (Not oCompDets.cxSaved) Then
      Begin
        // Company is in the group and a Xref record doesn't already exist for it
        FillChar (GroupCompFileRec^, SizeOf(GroupCompFileRec^), #0);
        GroupCompFileRec^.gcGroupCode := FullGroupCodeKey(FGroupCode);
        GroupCompFileRec^.gcCompanyCode := FullCompCode (oCompDets.cxCode);

        iStatus := Add_Rec (F[GroupCompXRefF], GroupCompXRefF, RecPtr[GroupCompXRefF]^, GroupCompXRefGroupK);
        If (iStatus <> 0) Then
        Begin
          sError := Format('Error %d adding a new Company-Group Xref entry for %s-%s'#13#13,
                           [iStatus, Trim(GroupCompFileRec^.gcGroupCode), Trim(GroupCompFileRec^.gcCompanyCode)]);
          MessageDlg (sError, mtError, [mbOk], 0);

          // Set error flag so window doesn't close losing the settings
          bGotError := True;
        End; // If (iStatus <> 0)
      End; // If oCompDets.cxInGroup And (Not oCompDets.cxSaved)
    End; // For I
  End; // If (FCompanyList.Count > 0)


  // Only close the dialog if the saving all went Ok
  If (Not bGotError) Then
  Begin
    ModalResult := mrOK;
  End; // If (Not bGotError)
end;

//-------------------------------------------------------------------------

procedure TfrmLinkCompanies.btnCancelClick(Sender: TObject);
begin
  If ChangedGroups Then
  Begin
    // Changes made - confirm before abandoning
    If (MessageDlg('Are you sure you want to close the ''Link Companies'' window without ' +
                   'saving the changes?',
                   mtConfirmation, [mbYes,mbNo], 0) = mrYes) Then
    Begin
      // Yes - close dialog without saving changes
      ModalResult := mrCancel;
    End; // If (MessageDlg('Are you sure ...
  End // If ChangedGroups
  Else
  Begin
    // No changes made - close
    ModalResult := mrCancel;
  End; // Else
end;

//-------------------------------------------------------------------------

// Controls the loading/saving of the colours and positions
//
// Mode   0=Load Details, 1=Save Details, 2=Delete Details
procedure TfrmLinkCompanies.SetColoursUndPositions (Const Mode : Byte);
Var
  WantAutoSave : Boolean;
Begin // SetColoursUndPositions
  Case Mode Of
    0 : Begin
          oSettings.LoadForm (Self, WantAutoSave);
          popSavePosition.Checked := WantAutoSave;
          oSettings.LoadList (mulNotInGroup, Self.Name);
          oSettings.LoadList (mulInGroup, Self.Name);   // load column pos/size - ignore colours
          oSettings.CopyList(mulNotInGroup, mulInGroup);
        End;
    1 : If (Not DoneRestore) Then
        Begin
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm (Self, popSavePosition.Checked);
          oSettings.SaveList (mulNotInGroup, Self.Name);
          oSettings.SaveList (mulInGroup, Self.Name);
        End; // If (Not DoneRestore)
    2 : Begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults (Self.Name);
          oSettings.RestoreListDefaults (mulNotInGroup, Self.Name);
          oSettings.RestoreListDefaults (mulInGroup, Self.Name);
          popSavePosition.Checked := False;
        End;
  Else
    Raise Exception.Create ('TfrmLinkCompanies.SetColoursUndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  End; // Case Mode
End; // SetColoursUndPositions

//-------------------------------------------------------------------------

procedure TfrmLinkCompanies.popFormPropertiesClick(Sender: TObject);
begin
  // Call the colours dialog
  Case oSettings.Edit(mulNotInGroup, Self.Name, NIL) Of
    mrOK              : Begin
                          oSettings.CopyList(mulNotInGroup, mulInGroup);
                        End;
    mrRestoreDefaults : SetColoursUndPositions (2);
  End; // Case oSettings.Edit(...
end;

//-------------------------------------------------------------------------

end.

