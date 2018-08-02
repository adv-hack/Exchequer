unit MCMFindF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, uMultiList, TCustom, ExtCtrls, ComCtrls,
  VarConst, GroupsFile, Menus;

type
  TAdvancedFindMode = (afmGroup, afmCompany, afmGroupCompany);

  TfrmAdvancedFind = class(TForm)
    PageControl1: TPageControl;
    tabshSearch: TTabSheet;
    Panel1: TPanel;
    btnFindCancel: TSBSButton;
    btnGroupClose: TSBSButton;
    mulResults: TMultiList;
    Label81: Label8;
    cmbSearchFor: TSBSComboBox;
    Label82: Label8;
    cmbSearchBy: TSBSComboBox;
    PopupMenu1: TPopupMenu;
    popFormProperties: TMenuItem;
    PopupOpt_SepBar3: TMenuItem;
    popSavePosition: TMenuItem;
    procedure btnClose(Sender: TObject);
    procedure btnFindCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mulResultsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure popFormPropertiesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure Label81DblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    AbortSearch : Boolean;
    DoneRestore : Boolean;
    FCacheList : TStringList;
    FGroupCodeFilter : ShortString;  // Group Code filter for searching within groups
    FMode : TAdvancedFindMode;
    FSelectedItem : ShortString;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    // Runs through the specified file on the specified index and loads any records
    // matching FindKey into the results list
    procedure SearchFile (Const FileNo, IdxNo : SmallInt; Const StartKey, FindKey : ShortString);

    // Property Set method for CacheList - loads history items into the SearchFor combo
    Procedure SetCacheList (Const Value : TStringList);

    // Controls the loading/saving of the colours and positions
    //
    // Mode   0=Load Details, 1=Save Details, 2=Delete Details
    procedure SetColoursUndPositions (Const Mode : Byte);

    // Control the minimum size that the form can resize to - works better than constraints
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }

    // reference to the StringList instance being used for caching previous searches
    Property CacheList : TStringList Read FCacheList Write SetCacheList;

    Property GroupCodeFilter : ShortString Read FGroupCodeFilter Write FGroupCodeFilter;

    // Controls data type being selected
    Property Mode : TAdvancedFindMode Read FMode Write FMode;

    // Text of selected item from the first column
    Property SelectedItem : ShortString Read FSelectedItem;
  end;

// Displays a Find Company dialog similar to that in Enterprise and
// allows the user to search for a specific company entry.  Returns
// TRUE if a company was selected, else FALSE, the company found is
// returned in the CompanyRec parameter.  The global Company record
// and global file position are left intact
Function FindCompany (Const OwnerForm : TForm; Var CompanyRec : CompanyDetRec) : Boolean;

// Displays a Find Group dialog similar to that in Enterprise and
// allows the user to search for a specific group entry.  Returns
// TRUE if a group was selected, else FALSE, the group found is
// returned in the GroupRec parameter.  The global GroupFileRec
// and global file position are left intact
Function FindGroup (Const OwnerForm : TForm; Var GroupRec : GroupFileRecType) : Boolean;

// Displays a Find Company dialog similar to that in Enterprise and
// allows the user to search for a specific Company within the specified
// group.  Returns TRUE if a company was selected, else FALSE, the company
// found is returned in the CompanyRec parameter.  The global Company record
// and global file position are left intact
Function FindGroupCompany (Const OwnerForm : TForm; GroupCode : ShortString; Var CompanyRec : CompanyDetRec) : Boolean;


implementation

{$R *.dfm}

Uses GlobVar, BtrvU2, ETStrU,
     GroupCompFile,   // Definition of GroupCmp.Dat (GroupCompXrefF) and utility functions
     SavePos,         // Object encapsulating the btrieve saveposition/restoreposition functions
     uSettings,       // Colour/Position editing and saving routines
     BTSupu1, BTKeys1U, BTSupu2;

Const
  StopModeCaption = 'Sto&p';
  FindModeCaption = '&Find Now';

Var
  // Cache of historical group searches done during this instance of the app
  LastGroupSearchIdx   : SmallInt = 0;
  GroupSearchHistory   : TStringList;

  // Cache of historical company searches done during this instance of the app
  LastCompanySearchIdx : SmallInt = 0;
  CompanySearchHistory : TStringList;


//-------------------------------------------------------------------------

// Displays a Find Group dialog similar to that in Enterprise and
// allows the user to search for a specific group entry.  Returns
// TRUE if a group was selected, else FALSE, the group found is
// returned in the GroupRec parameter.  The global GroupFileRec
// and global file position are left intact
Function FindGroup (Const OwnerForm : TForm; Var GroupRec : GroupFileRecType) : Boolean;
var
  frmAdvancedFind : TfrmAdvancedFind;
  lStatus         : SmallInt;
  KeyS            : Str255;
Begin // FindGroup
  Result := False;
  FillChar (GroupRec, SizeOf(GroupRec), #0);

  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the group file for the current key
      SaveFilePosition (GroupF, GetPosKey);
      SaveDataBlock (@GroupFileRec, SizeOf(GroupFileRec));

      //------------------------------

      // Configure and then display the Advanced Find form
      frmAdvancedFind := TfrmAdvancedFind.Create(OwnerForm);
      Try
        frmAdvancedFind.Caption := 'Find Group';
        frmAdvancedFind.tabshSearch.Caption := 'Group';

        // Setup the link from the SearchFor field and the stringlist of previous
        // searches on the Group file
        frmAdvancedFind.CacheList := GroupSearchHistory;

        // Load the search methods and set the default
        With frmAdvancedFind.cmbSearchBy Do
        Begin
          Items.Add ('Group Code');
          Items.Add ('Group Name');
          Items.Add ('Any Field');
          ItemIndex := LastGroupSearchIdx;
        End; // With frmAdvancedFind.cmbSearchBy

        // Set the mode so the internal functions know what search we are doing
        frmAdvancedFind.Mode := afmGroup;

        // Return True if the user selected a group
        Result := (frmAdvancedFind.ShowModal = mrOK);
        If Result Then
        Begin
          // Record the search mode used for next time
          LastGroupSearchIdx := frmAdvancedFind.cmbSearchBy.ItemIndex;

          // Return the selected group code
          KeyS := FullGroupCodeKey(frmAdvancedFind.SelectedItem);
          lStatus := Find_Rec(B_GetEq, F[GroupF], GroupF, RecPtr[GroupF]^, GroupCodeK, KeyS);
          If (lStatus = 0) Then
          Begin
            GroupRec := GroupFileRec;
          End // If (lStatus = 0)
          Else
          Begin
            Result := False;
          End; // Else
        End; // If Result
      Finally
        FreeAndNIL(frmAdvancedFind);
      End; // Try..Finally

      //------------------------------

      // Restore position in group file
      RestoreSavedPosition;
      RestoreDataBlock (@GroupFileRec);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // FindGroup

//=========================================================================

// Displays a Find Company dialog similar to that in Enterprise and
// allows the user to search for a specific company entry.  Returns
// TRUE if a company was selected, else FALSE, the company found is
// returned in the CompanyRec parameter.  The global Company record
// and global file position are left intact
Function FindCompany (Const OwnerForm : TForm; Var CompanyRec : CompanyDetRec) : Boolean;
var
  frmAdvancedFind : TfrmAdvancedFind;
  lStatus         : SmallInt;
  KeyS            : Str255;
Begin // FindCompany
  Result := False;
  FillChar (CompanyRec, SizeOf(CompanyRec), #0);

  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveFilePosition (CompF, GetPosKey);
      SaveDataBlock (Company, SizeOf(Company^));

      //------------------------------

      // Configure and then display the Advanced Find form
      frmAdvancedFind := TfrmAdvancedFind.Create(OwnerForm);
      Try
        frmAdvancedFind.Caption := 'Find Company';
        frmAdvancedFind.tabshSearch.Caption := 'Company';

        // Setup the link from the SearchFor field and the stringlist of previous
        // searches on the Company file
        frmAdvancedFind.CacheList := CompanySearchHistory;

        // Load the search methods and set the default
        With frmAdvancedFind.cmbSearchBy Do
        Begin
          Items.Add ('Company Code');
          Items.Add ('Company Name');
          Items.Add ('Any Field');
          ItemIndex := LastCompanySearchIdx;
        End; // With frmAdvancedFind.cmbSearchBy

        // Set the mode so the internal functions know what search we are doing
        frmAdvancedFind.Mode := afmCompany;

        // Return True if the user selected a group
        Result := (frmAdvancedFind.ShowModal = mrOK);
        If Result Then
        Begin
          // Record the search mode used for next time
          LastCompanySearchIdx := frmAdvancedFind.cmbSearchBy.ItemIndex;

          // Return the selected group code
          KeyS := FullCompCodeKey(cmCompDet, frmAdvancedFind.SelectedItem);
          lStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
          If (lStatus = 0) Then
          Begin
            CompanyRec := Company^.CompDet;
          End // If (lStatus = 0)
          Else
          Begin
            Result := False;
          End; // Else
        End; // If Result
      Finally
        FreeAndNIL(frmAdvancedFind);
      End; // Try..Finally

      //------------------------------

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (Company);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // FindCompany

//=========================================================================

// Displays a Find Company dialog similar to that in Enterprise and
// allows the user to search for a specific Company within the specified
// group.  Returns TRUE if a company was selected, else FALSE, the company
// found is returned in the CompanyRec parameter.  The global Company record
// and global file position are left intact
Function FindGroupCompany (Const OwnerForm : TForm; GroupCode : ShortString; Var CompanyRec : CompanyDetRec) : Boolean;
var
  oCompanyPos, oGroupCompPos : TBtrieveSavePosition;
  frmAdvancedFind : TfrmAdvancedFind;
  lStatus         : SmallInt;
  KeyS            : Str255;
Begin // FindGroupCompany
  Result := False;
  FillChar (CompanyRec, SizeOf(CompanyRec), #0);

  oCompanyPos := TBtrieveSavePosition.Create;
  Try
    // Save the current position in the group file for the current key
    oCompanyPos.SaveFilePosition (CompF, GetPosKey);
    oCompanyPos.SaveDataBlock (Company, SizeOf(Company^));

    oGroupCompPos := TBtrieveSavePosition.Create;
    Try
      // Save the current position in the group file for the current key
      oGroupCompPos.SaveFilePosition (GroupCompXRefF, GetPosKey);
      oGroupCompPos.SaveDataBlock (GroupCompFileRec, SizeOf(GroupCompFileRec^));

      //------------------------------

      // Configure and then display the Advanced Find form
      frmAdvancedFind := TfrmAdvancedFind.Create(OwnerForm);
      Try
        frmAdvancedFind.Caption := 'Find Company';
        frmAdvancedFind.tabshSearch.Caption := 'Company';

        // Setup the link from the SearchFor field and the stringlist of previous
        // searches on the Company file
        frmAdvancedFind.CacheList := CompanySearchHistory;

        // Load the search methods and set the default
        With frmAdvancedFind.cmbSearchBy Do
        Begin
          Items.Add ('Company Code');
          Items.Add ('Company Name');
          Items.Add ('Any Field');
          ItemIndex := LastCompanySearchIdx;
        End; // With frmAdvancedFind.cmbSearchBy

        // Set the mode so the internal functions know what search we are doing
        frmAdvancedFind.Mode := afmGroupCompany;
        frmAdvancedFind.GroupCodeFilter := FullGroupCodeKey(GroupCode);

        // Return True if the user selected a group
        Result := (frmAdvancedFind.ShowModal = mrOK);
        If Result Then
        Begin
          // Record the search mode used for next time
          LastCompanySearchIdx := frmAdvancedFind.cmbSearchBy.ItemIndex;

          // Return the selected Company code
          KeyS := FullCompCodeKey(cmCompDet, frmAdvancedFind.SelectedItem);
          lStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
          If (lStatus = 0) Then
          Begin
            CompanyRec := Company^.CompDet;
          End // If (lStatus = 0)
          Else
          Begin
            Result := False;
          End; // Else
        End; // If Result
      Finally
        FreeAndNIL(frmAdvancedFind);
      End; // Try..Finally

      //------------------------------

      // Restore position in group file
      oGroupCompPos.RestoreSavedPosition;
      oGroupCompPos.RestoreDataBlock (GroupCompFileRec);
    Finally
      FreeAndNIL(oGroupCompPos);
    End; // Try..Finally

    // Restore position in group file
    oCompanyPos.RestoreSavedPosition;
    oCompanyPos.RestoreDataBlock (Company);
  Finally
    FreeAndNIL(oCompanyPos);
  End; // Try..Finally
End; // FindGroupCompany

//=========================================================================

procedure TfrmAdvancedFind.FormCreate(Sender: TObject);
begin
  btnFindCancel.Caption := FindModeCaption;
  FGroupCodeFilter := '';
  FSelectedItem := '';

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 385;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 240;      // captions into account

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  SetColoursUndPositions (0);
end;

//------------------------------

procedure TfrmAdvancedFind.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Save colours/positions/sizes/etc...
  SetColoursUndPositions (1);
end;

//------------------------------

procedure TfrmAdvancedFind.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

//------------------------------

procedure TfrmAdvancedFind.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

//-------------------------------------------------------------------------

// Control the minimum size that the form can resize to - works better than constraints
Procedure TfrmAdvancedFind.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
Begin // WMGetMinMaxInfo
  With Message.MinMaxInfo^ Do
  Begin
    ptMinTrackSize.X:=MinSizeX;
    ptMinTrackSize.Y:=MinSizeY;
  End; // With Message.MinMaxInfo^

  Message.Result:=0;

  Inherited;
End; // WMGetMinMaxInfo

//-------------------------------------------------------------------------

// Property Set method for CacheList - loads history items into the SearchFor combo
Procedure TfrmAdvancedFind.SetCacheList (Const Value : TStringList);
Begin // SetCacheList
  FCacheList := Value;
  cmbSearchFor.Items.Assign(FCacheList);
End; // SetCacheList

//-------------------------------------------------------------------------

procedure TfrmAdvancedFind.btnFindCancelClick(Sender: TObject);
Var
  OK : Boolean;
begin
  If (btnFindCancel.Caption = FindModeCaption) Then
  Begin
    // Find Mode - Validate the settings and do the search
    OK := (Trim(cmbSearchFor.Text) <> '');
    If (Not OK) Then
    Begin
      MessageDlg('The ''''Search For'''' field must be set before a search can be started', mtError, [mbOK], 0);
      If cmbSearchFor.CanFocus Then
      Begin
        cmbSearchFor.SetFocus;
      End; // If cmbSearchFor.CanFocus
    End; // If (Not OK)

    If OK Then
    Begin
      // Change the find button to a cancel button
      btnFindCancel.Caption := StopModeCaption;

      // Update the history cache if the string hasn't been used already
      If (cmbSearchFor.Items.IndexOf(cmbSearchFor.Text) = -1) Then
      Begin
        cmbSearchFor.Items.Insert(0, cmbSearchFor.Text);
        FCacheList.Assign(cmbSearchFor.Items);
      End; // If (cmbSearchFor.Items.IndexOf(cmbSearchFor.Text) = -1)

      // Clear the results list and then do the search
      FSelectedItem := '';
      AbortSearch := False;
      mulResults.ClearItems;
      Case FMode Of
        afmGroup        : Begin // Groups
                            Case cmbSearchBy.ItemIndex Of
                              0  : Begin // Group Code
                                     SearchFile (GroupF, GroupCodeK, '', cmbSearchFor.Text);
                                   End; // Group Code
                              1  : Begin // Group Name
                                     SearchFile (GroupF, GroupNameK, '', cmbSearchFor.Text);
                                   End; // Group Name
                              2  : Begin // Any Field
                                     SearchFile (GroupF, GroupCodeK, '', cmbSearchFor.Text);
                                   End; // Any Field
                            End; // Case cmbGroupSearchBy.ItemIndex
                          End; // Groups

        afmCompany      : Begin // Companies
                            // No Index is available on the Company Name so all three
                            // searches will be done using the Code index
                            SearchFile (CompF, CompCodeK, cmCompDet, cmbSearchFor.Text);
                          End; // Companies

        afmGroupCompany : Begin
                            // This one is complex because although we are searching the
                            // companies within a group, none of the detail is in the
                            // Group-Company XRef record but is all in the Company record.
                            // This means we will have to process the Group-Company XRef
                            // file and load the Company record for each Group-Company XRef
                            // record and search it.
                            SearchFile (GroupCompXRefF, GroupCompXRefGroupK, GroupCodeFilter, cmbSearchFor.Text);
                          End;
      Else
        Raise Exception.Create ('TfrmAdvancedFind.btnFindCancelClick: Unknown Mode');
      End; // Case FMode

      If (mulResults.ItemsCount > 0) Then
      Begin
        // Select first item in results list
        MulResults.Selected := 0;

        // Can't move focus to the list as that doesn't work properly!
      End; // If (mulResults.ItemsCount > 0)

      // Restore the find button back to a find button
      btnFindCancel.Caption := FindModeCaption;
    End; // If OK
  End // If (btnFindCancel.Caption = FindModeCaption)
  Else
  Begin
    If (btnFindCancel.Caption = StopModeCaption) Then
    Begin
      // Stop the search
      AbortSearch := True;
    End; // If (btnFindCancel.Caption = CancelModeCaption)
  End; // Else
end;

//-------------------------------------------------------------------------

// Runs through the specified file on the specified index and loads any records
// matching FindKey into the results list
procedure TfrmAdvancedFind.SearchFile (Const FileNo, IdxNo : SmallInt; Const StartKey, FindKey : ShortString);
Var
  lStatus        : SmallInt;
  KeyS, sCompKey : Str255;
  Match, NotUsed : Boolean;

  //------------------------------

  // Copied from ETStrU and modified
  Function Match_Glob(Fno         :  Integer;
                    Compare     :  Str30;
                Var CompWith;
                Var Abort       :  Boolean)  : Boolean;
  Const
    WildChar  :  CharSet = ['?','*'];
  Var
    n,Sn  :  Integer;
    Fok   :  Boolean;
    Found :  GenAry;
  Begin
    n:=1; Sn:=1; Fok:=BOff;

    Blank(Found,Sizeof(Found));

    Move(CompWith,Found,Fno);

    While (n<=Fno) and (Not Fok) do
    Begin
      // HM: Added the OR section to support wildchars at the start, e.g. ?RAVO
      If (UpCase(Compare[1])=Upcase(Found[n])) or (Compare[1] In WildChar) then
      Begin
        Sn:=1; Fok:=BOn;
        While (Sn<=Length(Compare)) and (Fok) do
        Begin
          Fok:=((Upcase(Compare[Sn])=Upcase(Found[n+Sn-1])) or (Compare[Sn] In WildChar));
          Sn:=Succ(Sn);
        end; {While..}
      end;

      n:=Succ(n);
    end; {While..}
    Match_Glob:=Fok;
  end;

  //------------------------------

  Procedure DoCompanyCompare;
  Begin // DoCompanyCompare
    Case cmbSearchBy.ItemIndex Of
      0  : Begin // Company Code
             Match := Match_Glob (Length(Company^.CompDet.CompCode), FindKey, Company^.CompDet.CompCode[1], NotUsed);
           End; // Company Code
      1  : Begin // Company Name
             Match := Match_Glob (Length(Company^.CompDet.CompName), FindKey, Company^.CompDet.CompName[1], NotUsed);
           End; // Company Name
      2  : Begin // Any Field
             Match := Match_Glob (SizeOf(Company^.CompDet), FindKey, Company^.CompDet, NotUsed);
           End; // Any Field
    End; // Case cmbGroupSearchBy.ItemIndex

    If Match Then
    Begin
      mulResults.DesignColumns[0].items.Add(Trim(Company^.CompDet.CompCode));
      mulResults.DesignColumns[1].items.Add(Trim(Company^.CompDet.CompName));
    End; // If Match
  End; // DoCompanyCompare

  //------------------------------

Begin // SearchFile
  If (Trim(StartKey) = '') Then
  Begin
    // Process entire file
    KeyS := '';
    lStatus := Find_Rec(B_GetFirst, F[FileNo], FileNo, RecPtr[FileNo]^, IdxNo, KeyS);
  End // If (Trim(StartKey) = '')
  Else
  Begin
    // Process sub-section file
    KeyS := StartKey;
    lStatus := Find_Rec(B_GetGEq, F[FileNo], FileNo, RecPtr[FileNo]^, IdxNo, KeyS);
  End; // Else

  While (lStatus = 0) And ((StartKey = '') Or CheckKey(StartKey, KeyS, Length(StartKey), True)) And (Not AbortSearch) Do
  Begin
    // For each mode check whether we want the record
    Case FMode Of
      afmGroup        : Begin
                          Case cmbSearchBy.ItemIndex Of
                            0  : Begin // Group Code
                                   Match := Match_Glob (Length(GroupFileRec.grGroupCode), FindKey, GroupFileRec.grGroupCode[1], NotUsed);
                                 End; // Group Code
                            1  : Begin // Group Name
                                   Match := Match_Glob (Length(GroupFileRec.grGroupName), FindKey, GroupFileRec.grGroupName[1], NotUsed);
                                 End; // Group Name
                            2  : Begin // Any Field
                                   Match := Match_Glob (SizeOf(GroupFileRec), FindKey, GroupFileRec, NotUsed);
                                 End; // Any Field
                          End; // Case cmbGroupSearchBy.ItemIndex

                          If Match Then
                          Begin
                            mulResults.DesignColumns[0].items.Add(Trim(GroupFileRec.grGroupCode));
                            mulResults.DesignColumns[1].items.Add(Trim(GroupFileRec.grGroupName));
                          End; // If Match
                        End;
      afmCompany      : Begin
                          DoCompanyCompare;
                        End;
      afmGroupCompany : Begin
                          // This one is complex because although we are searching the
                          // companies within a group, none of the detail is in the
                          // Group-Company XRef record but is all in the Company record.
                          // This means we will have to process the Group-Company XRef
                          // file and load the Company record for each Group-Company XRef
                          // record and search it.

                          // Get Company record
                          sCompKey := FullCompCodeKey(cmCompDet, GroupCompFileRec^.gcCompanyCode);
                          lStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sCompKey);
                          If (lStatus = 0) Then
                          Begin
                            DoCompanyCompare;
                          End; // If (lStatus = 0)
                        End;
    Else
      Raise Exception.Create ('TfrmAdvancedFind.SearchFile: Unknown Mode');
    End; // Case FMode

    lStatus := Find_Rec(B_GetNext, F[FileNo], FileNo, RecPtr[FileNo]^, IdxNo, KeyS);

    // Do this so that the user can click the 'Stop' button on longer searches, when
    // clicked the caption will
    Application.ProcessMessages;
  End; // While (lStatus = 0) And (Not AbortSearch)
End; // SearchFile

//-------------------------------------------------------------------------

procedure TfrmAdvancedFind.btnClose(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

//-------------------------------------------------------------------------

// Row double-click - if something is selected then return that as
// the result of the search
procedure TfrmAdvancedFind.mulResultsRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  FSelectedItem := mulResults.DesignColumns[0].Items[mulResults.Selected];
  ModalResult := mrOK;
end;

//-------------------------------------------------------------------------

// Controls the loading/saving of the colours and positions
//
// Mode   0=Load Details, 1=Save Details, 2=Delete Details
procedure TfrmAdvancedFind.SetColoursUndPositions (Const Mode : Byte);
Var
  WantAutoSave : Boolean;
Begin // SetColoursUndPositions
  Case Mode Of
    0 : Begin
          oSettings.LoadForm (Self, WantAutoSave);
          popSavePosition.Checked := WantAutoSave;
          oSettings.LoadList (mulResults, Self.Name);
          oSettings.LoadParentToControl (tabshSearch.Name, Self.Name, cmbSearchFor);
          oSettings.ColorFieldsFrom (cmbSearchFor, Self);
        End;
    1 : If (Not DoneRestore) Then
        Begin
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm (Self, popSavePosition.Checked);
          oSettings.SaveList (mulResults, Self.Name);
          oSettings.SaveParentFromControl (cmbSearchFor, Self.Name, tabshSearch.Name);
        End; // If (Not DoneRestore)
    2 : Begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults (Self.Name);
          oSettings.RestoreListDefaults (mulResults, Self.Name);
          oSettings.RestoreParentDefaults (tabshSearch, Self.Name);
          popSavePosition.Checked := False;
        End;
  Else
    Raise Exception.Create ('TfrmAdvancedFind.SetColoursUndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  End; // Case Mode
End; // SetColoursUndPositions

//-------------------------------------------------------------------------

procedure TfrmAdvancedFind.popFormPropertiesClick(Sender: TObject);
begin
  // Call the colours dialog
  Case oSettings.Edit(mulResults, Self.Name, cmbSearchFor) Of
    mrOK              : oSettings.ColorFieldsFrom (cmbSearchFor, Self);
    mrRestoreDefaults : SetColoursUndPositions (2);
  End; // Case oSettings.Edit(...
end;

//-------------------------------------------------------------------------

procedure TfrmAdvancedFind.FormResize(Sender: TObject);
begin
  LockWindowUpdate (Handle);

  // Resize Page Control
  PageControl1.Height := ClientHeight - 6;
  PageControl1.Width := clientWidth - 7;

  LockWindowUpdate (0);
end;

//-------------------------------------------------------------------------

procedure TfrmAdvancedFind.Label81DblClick(Sender: TObject);
begin
  ShowMessage (Format ('Client: %dx%d', [ClientWidth, ClientHeight]));
end;

Initialization
// Create and destroy the stringlists used for caching the previous
// search strings.  Supress duplicates within the StringLists
  GroupSearchHistory := TStringList.Create;
  GroupSearchHistory.Duplicates := dupIgnore;
  CompanySearchHistory := TStringList.Create;
  CompanySearchHistory.Duplicates := dupIgnore;
Finalization
  FreeAndNIL(GroupSearchHistory);
  FreeAndNIL(CompanySearchHistory);
end.
