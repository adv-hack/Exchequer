unit RptWizardF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, EnterToTab, ImgList, ExtCtrls, StdCtrls, uMultiList,
  ComCtrls, BorBtns, TEditVal, GlobalTypes, Mask, StrUtils,
  GlobVar, VarConst, RWOpenF, SelectDBFieldF, RptWizardTypes;

type
  TValidateReportName = Procedure(Const ReportName: ShortString; Var IsValid: Boolean) Of Object;

  //------------------------------

  TfrmRepWizard = class(TForm)
    PageControl1: TPageControl;
    tabshInitialParams: TTabSheet;
    tabshMainFile: TTabSheet;
    tabshSelectDBFields: TTabSheet;
    tabshSortBreaks: TTabSheet;
    tabshFilters: TTabSheet;
    tabshReportSections: TTabSheet;
    btnBack: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    pnlImage: TPanel;
    imgPanelImage: TImage;
    pmTableNamesMenu: TPopupMenu;
    EnterToTab1: TEnterToTab;
    memReportDesc: TMemo;
    lblReportType: TLabel;
    lblReportDesc: TLabel;
    edtReportName: Text8Pt;
    Label82: Label8;
    radReport: TBorRadio;
    radGroup: TBorRadio;
    cbMainFile: TComboBox;
    cbIndex: TComboBox;
    Label81: Label8;
    lblIndex: TLabel;
    mulDBFields: TMultiList;
    btnFieldUp: TButton;
    btnFieldDown: TButton;
    Label83: Label8;
    btnAddDBField: TButton;
    btnDeleteDBField: TButton;
    btnAddOne: TButton;
    btnRemoveOne: TButton;
    mulUnsorted: TMultiList;
    mulSorted: TMultiList;
    btnSortUp: TButton;
    btnSortDown: TButton;
    btnPageBreak: TButton;
    Label84: Label8;
    btnEditProperties: TButton;
    btnSortOrder: TButton;
    Label85: Label8;
    mulFieldFilters: TMultiList;
    btnEditFilter: TButton;
    lbSections: TListBox;
    btnShowSection: TButton;
    btnHideSection: TButton;
    btnShowAllSections: TButton;
    Label86: Label8;
    procedure btnBackClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure radGroupClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbMainFileClick(Sender: TObject);
    procedure btnAddDBFieldClick(Sender: TObject);
    procedure btnDeleteDBFieldClick(Sender: TObject);
    procedure btnFieldUpClick(Sender: TObject);
    procedure btnFieldDownClick(Sender: TObject);
    procedure edtReportNameKeyPress(Sender: TObject; var Key: Char);
    procedure btnEditPropertiesClick(Sender: TObject);
    procedure btnAddOneClick(Sender: TObject);
    procedure btnRemoveOneClick(Sender: TObject);
    procedure mulUnsortedRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnPageBreakClick(Sender: TObject);
    procedure btnSortUpClick(Sender: TObject);
    procedure btnSortDownClick(Sender: TObject);
    procedure btnSortOrderClick(Sender: TObject);
    procedure mulFieldFiltersRowDblClick(Sender: TObject;
      RowIndex: Integer);
    procedure btnEditFilterClick(Sender: TObject);
    procedure lbSectionsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnShowSectionClick(Sender: TObject);
    procedure btnHideSectionClick(Sender: TObject);
    procedure btnShowAllSectionsClick(Sender: TObject);
    procedure lbSectionsClick(Sender: TObject);
    procedure lbSectionsDblClick(Sender: TObject);
    procedure mulDBFieldsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mulDBFieldsRowDblClick(Sender: TObject; RowIndex: Integer);
  private
    { Private declarations }
    FOnValidateReportName: TValidateReportName;
    FWizardReport : TReportWizardParams;

    // Cache'd Select DB Field dialog
    frmSelectField : TfrmSelectDBField;

    procedure AddDBField(Const FieldRec : DataVarType);
    procedure BuildRegionsList;
    procedure LoadFilterList;
    procedure LoadList;
    procedure LoadSectionsTree;
    procedure LoadSortLists;
    Function ValidateTab (Const TabNo : Byte) : Boolean;
  public
    { Public declarations }
    Property WizardReport : TReportWizardParams Read FWizardReport Write FWizardReport;

    property OnValidateReportName: TValidateReportName read FOnValidateReportName write FOnValidateReportName;
  end;


implementation

{$R *.dfm}

Uses BtrvU2, VarFPosU, BTSupU1, ETStrU, ctrlFormulaProperties, VRWReportIF,
  frmVRWDBFieldPropertiesU, Brand, EntLicence;

Const
  FinishCaption = '&Finish';
  NextCaption = '&Next >>';

var
  IsLite: Boolean;

//=========================================================================

procedure TfrmRepWizard.FormCreate(Sender: TObject);
begin
  frmSelectField := NIL;

  tabshInitialParams.TabVisible := True;
  tabshMainFile.TabVisible := False;
  tabshSelectDBFields.TabVisible := False;
  tabshSortBreaks.TabVisible := False;
  tabshFilters.TabVisible := False;
  tabshReportSections.TabVisible := False;
  PageControl1Change(Sender);

  ActiveControl := edtReportName;
  self.HelpContext := PageControl1.ActivePage.HelpContext;
End;

//------------------------------

procedure TfrmRepWizard.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(frmSelectField);
end;

//-------------------------------------------------------------------------

Function TfrmRepWizard.ValidateTab (Const TabNo : Byte) : Boolean;
Var
  oRegionData : TRegionInfo;
  bValidName  : Boolean;
  I           : SmallInt;
Begin // ValidateTab
  Result := True;

  If (TabNo In [0, 1]) Then
  Begin
    // Validate Report Name & Type
    If (Trim(edtReportName.Text) <> '') Then
    Begin
      If Assigned(FOnValidateReportName) Then
      Begin
        FOnValidateReportName(UpperCase(Trim(edtReportName.Text)), bValidName);
        If bValidName Then
        Begin
          FWizardReport.wrReportName := UpperCase(Trim(edtReportName.Text));
          FWizardReport.wrReportDesc := memReportDesc.Text;
          If radReport.Checked Then FWizardReport.wrType := wrtReport Else FWizardReport.wrType := wrtGroup;
        End // If bValidName
        Else
        Begin
          MessageDlg('A Report or Group already exists with this Name', mtError, [mbOK], 0);
          If edtReportName.CanFocus Then edtReportName.SetFocus;
          Result := False;
        End; // Else
      End // If Assigned(FOnValidateReportName)
      Else
        Raise Exception.Create('TfrmRepWizard.ValidateTab: OnValidateReportName Not Assigned');
    End // If (Trim(edtReportName.Text) <> '')
    Else
    Begin
      MessageDlg('The Report/Group Name cannot be left blank', mtError, [mbOK], 0);
      If edtReportName.CanFocus Then edtReportName.SetFocus;
      Result := False;
    End; // Else
  End; // If (TabNo In [0, 1])

  If Result And (TabNo In [0, 2]) Then
  Begin
    // Validate File & Index
    If (cbMainFile.ItemIndex >= 0) Then
    Begin
      FWizardReport.wrMainFileName := cbMainFile.Text;
      FWizardReport.wrMainDbFile := LongInt(cbMainFile.Items.Objects[cbMainFile.ItemIndex]);

      // Check whether the index is in use for the selected file
      If cbIndex.Enabled Then
      Begin
        If (cbIndex.ItemIndex >= 0) Then
        Begin
          FWizardReport.wrIndex := cbIndex.ItemIndex
        End // If (cbIndex.ItemIndex >= 0)
        Else
        Begin
          MessageDlg('The reports Index must be set', mtError, [mbOK], 0);
          If cbIndex.CanFocus Then cbIndex.SetFocus;
          Result := False;
        End; // Else
      End // If cbIndex.Enabled
      Else
        FWizardReport.wrIndex := 0;
    End // If (cbMainFile.ItemIndex >= 0)
    Else
    Begin
      MessageDlg('The reports Data File must be set', mtError, [mbOK], 0);
      If cbMainFile.CanFocus Then cbMainFile.SetFocus;
      Result := False;
    End; // Else
  End; // If Result And (TabNo In [0, 2])

  If Result And (TabNo In [0, 3]) Then
  Begin
    // Validate DB Fields
    If (FWizardReport.wrDBFieldList.Count = 0) Then
    Begin
      MessageDlg('At least one Database Field must be selected for printing on the report', mtError, [mbOK], 0);
      If btnAddDBField.CanFocus Then btnAddDBField.SetFocus;
      Result := False;
    End; // If (FWizardReport.wrDBFieldList.Count = 0)
  End; // If Result And (TabNo In [0, 3])

  If Result And (TabNo In [0, 4]) Then
  Begin
    // Validate Sorts

    // Rebuild Regions List to take into account the sorted fields
    BuildRegionsList;
  End; // If Result And (TabNo In [0, 4])

  If Result And (TabNo In [0, 6]) Then
  Begin
    // Validate Sections
    Result := False;
    If (FWizardReport.wrSections.Count > 0) Then
    Begin
      For I := 0 To (FWizardReport.wrSections.Count - 1) Do
      Begin
        oRegionData := TRegionInfo(FWizardReport.wrSections[I]);
        If oRegionData.RegionVisible Then
        Begin
          Result := True;
          Break;
        End; // If oRegionData.RegionVisible
      End; // For I
    End; // If (FWizardReport.wrSections.Count > 0)

    If (Not Result) Then
    Begin
      MessageDlg('At least one Section must be visible on the report', mtError, [mbOK], 0);
      If lbSections.CanFocus Then lbSections.SetFocus;
    End; // If (Not Result)
  End; // If Result And (TabNo In [0, 6])
End; // ValidateTab

//-------------------------------------------------------------------------

procedure TfrmRepWizard.btnBackClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  Try
    If (PageControl1.ActivePage = tabshInitialParams) Then
    Begin
      Raise Exception.Create ('TfrmRepWizard.btnBackClick: Back button clicked on Initial Tab')
    End // If (PageControl1.ActivePage = tabshInitialParams)
    Else If (PageControl1.ActivePage = tabshMainFile) Then
    Begin
      tabshInitialParams.TabVisible := True;
      PageControl1.ActivePage := tabshInitialParams;
      tabshMainFile.TabVisible := False;
    End // If (PageControl1.ActivePage = tabshMainFile)
    Else If (PageControl1.ActivePage = tabshSelectDBFields) Then
    Begin
      tabshMainFile.TabVisible := True;
      PageControl1.ActivePage := tabshMainFile;
      tabshSelectDBFields.TabVisible := False;
    End // If (PageControl1.ActivePage = tabshSelectDBFields)
    Else If (PageControl1.ActivePage = tabshSortBreaks) Then
    Begin
      tabshSelectDBFields.TabVisible := True;
      PageControl1.ActivePage := tabshSelectDBFields;
      tabshSortBreaks.TabVisible := False;
    End // If (PageControl1.ActivePage = tabshSortBreaks)
    Else If (PageControl1.ActivePage = tabshFilters) Then
    Begin
      tabshSortBreaks.TabVisible := True;
      PageControl1.ActivePage := tabshSortBreaks;
      tabshFilters.TabVisible := False;
    End // If (PageControl1.ActivePage = tabshFilters)
    Else If (PageControl1.ActivePage = tabshReportSections) Then
    Begin
      tabshFilters.TabVisible := True;
      PageControl1.ActivePage := tabshFilters;
      tabshReportSections.TabVisible := False;
    End // If (PageControl1.ActivePage = tabshReportSections)
    Else
      Raise Exception.Create ('TfrmRepWizard.btnBackClick: Unhandled Page');

    // Manually call as wasn't working otherwise
    PageControl1Change(Sender);
  Finally
    LockWindowUpdate(0);
  End; // Try..Finally
end;

//------------------------------

procedure TfrmRepWizard.btnNextClick(Sender: TObject);
begin
  LockWindowUpdate(Self.Handle);
  Try
    If (PageControl1.ActivePage = tabshInitialParams) Then
    Begin
      If ValidateTab(1) Then
      Begin
        If (btnNext.Caption = NextCaption) Then
        Begin
          tabshMainFile.TabVisible := True;
          PageControl1.ActivePage := tabshMainFile;
          tabshInitialParams.TabVisible := False;
        End // If (btnNext.Caption = NextCaption)
        Else
        Begin
          ModalResult := mrOK;
        End; // Else
      End; // If ValidateTab(1)
    End // If (PageControl1.ActivePage = tabshInitialParams)
    Else If (PageControl1.ActivePage = tabshMainFile) Then
    Begin
      If ValidateTab(2) Then
      Begin
        tabshSelectDBFields.TabVisible := True;
        PageControl1.ActivePage := tabshSelectDBFields;
        tabshMainFile.TabVisible := False;
      End; // If ValidateTab(2)
    End // If (PageControl1.ActivePage = tabshMainFile)
    Else If (PageControl1.ActivePage = tabshSelectDBFields) Then
    Begin
      If ValidateTab(3) Then
      Begin
        tabshSortBreaks.TabVisible := True;
        PageControl1.ActivePage := tabshSortBreaks;
        tabshSelectDBFields.TabVisible := False;
      End; // If ValidateTab(3)
    End // If (PageControl1.ActivePage = tabshSelectDBFields)
    Else If (PageControl1.ActivePage = tabshSortBreaks) Then
    Begin
      If ValidateTab(4) Then
      Begin
        tabshFilters.TabVisible := True;
        PageControl1.ActivePage := tabshFilters;
        tabshSortBreaks.TabVisible := False;
      End; // If ValidateTab(4)
    End // If (PageControl1.ActivePage = tabshSortBreaks)
    Else If (PageControl1.ActivePage = tabshFilters) Then
    Begin
      tabshReportSections.TabVisible := True;
      PageControl1.ActivePage := tabshReportSections;
      tabshFilters.TabVisible := False;
    End // If (PageControl1.ActivePage = tabshFilters)
    Else If (PageControl1.ActivePage = tabshReportSections) Then
    Begin
      If ValidateTab(6) Then
      Begin
        ModalResult := mrOK;
      End; // If ValidateTab(6)
    End // If (PageControl1.ActivePage = tabshReportSections)
    Else
      Raise Exception.Create ('TfrmRepWizard.btnNextClick: Unhandled Page');

    // Manually call as wasn't working otherwise
    PageControl1Change(Sender);
  Finally
    LockWindowUpdate(0);
  End; // Try..Finally
end;

//------------------------------

procedure TfrmRepWizard.btnCancelClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to cancel this report?',
                mtConfirmation,
                [mbYes, mbNo],
                0) = mrYes then
    Close;
end;

//-------------------------------------------------------------------------

procedure TfrmRepWizard.PageControl1Change(Sender: TObject);
Var
  I : LongInt;
  WantF : Boolean;
  VRWVers : Byte;

  procedure SetPicture(WhichPic : Byte);
  begin
//    imgPanelImage.Picture.Bitmap.LoadFromResourceID(HInstance, WhichPic);
    if Branding.BrandingFileExists(ebfVRW) then
    begin
      Branding.BrandingFile(ebfVRW).ExtractImage(imgPanelImage, Format('Wiz%d_256', [WhichPic]));
      imgPanelImage.Repaint;
      Application.ProcessMessages;
    end;

  end;

begin
  self.HelpContext := PageControl1.ActivePage.HelpContext;
  If (PageControl1.ActivePage = tabshInitialParams) Then
  Begin
    SetPicture (1);
  End // If (PageControl1.ActivePage = tabshInitialParams)
  Else If (PageControl1.ActivePage = tabshMainFile) Then
  Begin
    SetPicture (2);

    // First time through load the list of files
    If (cbMainFile.Items.Count = 0) Then
    Begin
      VRWVers := VRWVersionNo;

      // Load Data Files combo
      For I := 1 To High(DataFilesL^) Do
      Begin
        Case I Of
          // Stock File
          6                  : WantF := (VRWVers In [2,4,5,6,8,9,11]);
          // Cost Centre and Departments
          7, 8               : WantF := (VRWVers >= 3);
          // Not Used or Form Designer Only
          9, 11, 12, 13      : WantF := False;
          // Bill Of Materials
          10                 : WantF := (VRWVers In [2,4,5,6,8,9,11]);
          // Discount Matrix
          14                 : WantF := (VRWVers In [2,4,5,6,8,9,11]);
          // Serial Number DB
          16                 : WantF := (VRWVers In [5, 6, 9, 11]) and not IsLITE;
          // Job Costing files - Job Costing versions only
          15, 17..19, 21..25 : WantF := (VRWVers In [6,11]);
          // FIFO
          20                 : WantF := (VRWVers In [2,4,5,6,8,9,11]);
          // Stock location files - SPOP versions only
          26, 27             : WantF := (VRWVers In [5,6,9,11]) and not IsLITE;
          // Matched Payments
          28                 : WantF := True;
          // Stock Notes
          31                 : WantF := (VRWVers In [2,4,5,6,8,9,11]);
          // CIS Vouchers
          33                 : WantF := (VRWVers In [6,11]) and CISOn;
          // Multi-Bins
          34                 : WantF := not IsLite;
          35                  : WantF := (VRWVers In [2,4,5,6,8,9,11]);
          //PR: 10/06/2009 Added Multi-Buy Discounts
          36                 : WantF :=  (VRWVers In [5,6,9,11]) and not IsLITE;
        Else
          WantF := True;
        End; { Case }

        If WantF Then
        Begin
          cbMainFile.Items.AddObject(DataFilesL^[I], Pointer(I));
        End; // If WantF
      End; // For I

      If (cbMainFile.Items.Count > 0) Then
      Begin
        // Auto-select the first data file and update the index fields
        cbMainFile.ItemIndex := 0;
        cbMainFileClick(cbMainFile);
      End; // If (cbMainFile.Items.Count > 0)
    End; // If (cbMainFile.Items.Count = 0)
  End // If (PageControl1.ActivePage = tabshMainFile) Then
  Else If (PageControl1.ActivePage = tabshSelectDBFields) Then
  Begin
    SetPicture (3);
  End // If (PageControl1.ActivePage = tabshSelectDBFields) Then
  Else If (PageControl1.ActivePage = tabshSortBreaks) Then
  Begin
    SetPicture (4);
    LoadSortLists;
  End // If (PageControl1.ActivePage = tabshSortBreaks) Then
  Else If (PageControl1.ActivePage = tabshFilters) Then
  Begin
    SetPicture (5);
    LoadFilterList;
  End // If (PageControl1.ActivePage = tabshFilters) Then
  Else If (PageControl1.ActivePage = tabshReportSections) Then
  Begin
    SetPicture (6);
    LoadSectionsTree;
  End // If (PageControl1.ActivePage = tabshReportSections) Then
  Else
    Raise Exception.Create ('TfrmRepWizard.pcPageControlChange: Unhandled Page');

  btnBack.Enabled := (PageControl1.ActivePage <> tabshInitialParams);
  If (PageControl1.ActivePage = tabshReportSections) Then
  Begin
    btnNext.Caption := FinishCaption;
  End // If (PageControl1.ActivePage = tabshReportSections)
  Else If (PageControl1.ActivePage = tabshInitialParams) Then
  Begin
    radGroupClick(Self);
  End // If (PageControl1.ActivePage = tabshInitialParams)
  Else
    btnNext.Caption := NextCaption;
end;

//-------------------------------------------------------------------------

procedure TfrmRepWizard.edtReportNameKeyPress(Sender: TObject; var Key: Char);
begin
  If (Not (Key In [#8, #9, #10, #13, '0'..'9', 'A'..'Z', 'a'..'z'])) Then
  Begin
    Key := #0;
  End; // If (Not (Key In [#8, #9, #10, #13, '0'..'9', 'A'..'Z', 'a'..'z']))
end;

//-------------------------------------------------------------------------

procedure TfrmRepWizard.radGroupClick(Sender: TObject);
begin
  If radGroup.Checked Then
  Begin
    btnNext.Caption := FinishCaption;
  End // If radGroup.Checked
  Else
    btnNext.Caption := NextCaption;
end;

//-------------------------------------------------------------------------

procedure TfrmRepWizard.cbMainFileClick(Sender: TObject);
Var
  I, FileNo : LongInt;
begin
  // Load the index list
  FileNo := LongInt(cbMainFile.Items.Objects[cbMainFile.ItemIndex]);

  // Do any changes to the search list required by selected file }
  cbIndex.Enabled := (FileNo In [3, 4, 23]);
  lblIndex.Enabled := cbIndex.Enabled;

  cbIndex.Items.Clear;
  If cbIndex.Enabled Then
  Begin
    For I := Low (FastNDXHedL^[FileNo]) To High(FastNDXHedL^[FileNo]) Do
    Begin
      If ((FileNo = 3) And (I In [0..15])) Or
         ((FileNo = 4) And (I In [0..20])) Or
         ((FileNo = 23) And (I In [0..18])) Then
      Begin
        cbIndex.Items.Add (FastNDXHedL^[FileNo,I]);
      End; // If ((FileNo = ...
    End; // For I

    If (cbIndex.Items.Count > 0) Then
    Begin
      cbIndex.ItemIndex := 0;
    End; // If (cbIndex.Items.Count > 0)
  End; // If cbIndex.Enabled
end;

//-------------------------------------------------------------------------

procedure TfrmRepWizard.LoadList;
Var
  pDBField : TDBFieldColumn;
  I        : SmallInt;
Begin // LoadList
  mulDBFields.ClearItems;

  If (FWizardReport.wrDBFieldList.Count > 0) Then
  Begin
    For I := 0 To (FWizardReport.wrDBFieldList.Count - 1) Do
    Begin
      pDBField := FWizardReport.wrDBFieldList[I];
      mulDBFields.DesignColumns[0].Items.Add (Trim(pDBField.DictRec.VarName));
      mulDBFields.DesignColumns[1].Items.Add (Trim(pDBField.DictRec.VarDesc));
      mulDBFields.DesignColumns[2].Items.Add (Trim(pDBField.Caption));
      if (pDBField.SubTotal) then
        mulDBFields.DesignColumns[3].Items.Add('Yes')
      else
        mulDBFields.DesignColumns[3].Items.Add('');
    End; // For I
  End; // If (FWizardReport.wrDBFieldList.Count > 0)
End; // LoadList

//------------------------------

procedure TfrmRepWizard.mulDBFieldsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If (Key = VK_DELETE) Then
  Begin
    btnDeleteDBFieldClick(Sender);
  End // If (Key = VK_DELETE)
  Else If (Key = VK_UP) And (ssCtrl In Shift) Then
  Begin
    btnFieldUpClick(Sender);
    Key := 0;
  End // If (Key = VK_UP) And (ssCtrl In Shift)
  Else If (Key = VK_DOWN) And (ssCtrl In Shift) Then
  Begin
    btnFieldDownClick(Sender);
    Key := 0;
  End; // If (Key = VK_DOWN) And (ssCtrl In Shift)
end;

//------------------------------

procedure TfrmRepWizard.AddDBField(Const FieldRec : DataVarType);
Var
  pDBField : TDBFieldColumn;
Begin // AddDBField
  pDBField := TDBFieldColumn.Create;

  pDBField.DictRec := FieldRec;
  pDBField.Caption := Trim(FieldRec.RepDesc);

  FWizardReport.wrDBFieldList.Add (pDBField);
  LoadList;
End; // AddDBField

//------------------------------

procedure TfrmRepWizard.btnAddDBFieldClick(Sender: TObject);
Var
  I               : SmallInt;
  lStatus, RecPos : LongInt;
  sKey            : Str255;
begin
  If (Not Assigned(frmSelectField)) Then
  Begin
    frmSelectField := TfrmSelectDBField.Create(Self);

    // Allow the user to select multiple fields in one go
    frmSelectField.AllowMultiSelect := True;

  End; // If (Not Assigned(frmSelectField))

  // Link the report detail to DB Field dialog - if the file has changed
  // this will cause the cache'd list to be updated
  frmSelectField.ReportFile := FWizardReport.wrMainDbFile;

  // Remove any multi-selected fields from previous 'Add's
  frmSelectField.ClearMultiSelect;

  // Don't remember the previous field.
  frmSelectField.RememberCode := False;

  If (frmSelectField.ShowModal = mrOK) Then
  Begin
    // Extract Fields from selection window
    If (frmSelectField.DBMultiList1.MultiSelected.Count > 0) Then
    Begin
      For I := 0 To (frmSelectField.DBMultiList1.MultiSelected.Count - 1) Do
      Begin
        RecPos := StrToIntDef(frmSelectField.DBMultiList1.MultiSelected[I], 0);
        If (RecPos <> 0) Then
        Begin
          SetDataRecOfs(DictF, RecPos);
          lStatus := GetDirect(F[DictF],DictF,RecPtr[DictF]^,0,0);
          If (lStatus = 0) Then
          Begin
            AddDBField(DictRec.DataVarRec);
          End; // If (lStatus = 0)
        End; // If (RecPos <> 0)
      End; // For I
    End // If (frmSelectField.DBMultiList1.MultiSelected.Count > 0)
    Else
    Begin
      sKey := 'DV' + LJVar(frmSelectField.DBMultiList1.DesignColumns[0].Items[frmSelectField.DBMultiList1.Selected], 8);
      lStatus := Find_Rec (B_GetEq, F[DictF], DictF, RecPtr[DictF]^, 0, sKey);
      If (lStatus = 0) Then
      Begin
        AddDBField(DictRec.DataVarRec);
      End; // If (lStatus = 0)
    End; // Else
  End; // If (frmSelectField.ShowModal = mrOK)
end;

//------------------------------

procedure TfrmRepWizard.mulDBFieldsRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  btnEditPropertiesClick(Sender);
end;

procedure TfrmRepWizard.btnEditPropertiesClick(Sender: TObject);
var
  pDBField : TDBFieldColumn;
  Dlg: TfrmVRWDBFieldProperties;
begin
  if (mulDBFields.Selected >= 0) then
  begin
    pDBField := FWizardReport.wrDBFieldList[mulDBFields.Selected];
    Dlg := TfrmVRWDBFieldProperties.Create(nil);
    try
      Dlg.edtTitle.Text := pDBField.Caption;
      Dlg.chkSubtotals.Checked := pDBField.SubTotal;
      Dlg.ShowModal;
      if (Dlg.ModalResult = mrOk) then
      begin
        pDBField.Caption := Dlg.edtTitle.Text;
        pDBField.SubTotal := Dlg.chkSubtotals.Checked;
        mulDBFields.DesignColumns[2].Items[mulDBFields.Selected] := pDBField.Caption;
        if (pDBField.SubTotal) then
          mulDBFields.DesignColumns[3].Items[mulDBFields.Selected] := 'Yes'
        else
          mulDBFields.DesignColumns[3].Items[mulDBFields.Selected] := '';
      end;
    finally
      Dlg.Free;
    end;
  end; // If (mulDBFields.Selected >= 0)
end;

//------------------------------

procedure TfrmRepWizard.btnDeleteDBFieldClick(Sender: TObject);
Var
  pDBField : TDBFieldColumn;
begin
  If (mulDBFields.Selected >= 0) Then
  Begin
    If (MessageDlg ('Are you sure you want to delete the DB Field ' + QuotedStr(mulDBFields.DesignColumns[0].Items[mulDBFields.Selected]),
        mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
    Begin
      // Free the memory from the item and then delete the item
      pDBField := FWizardReport.wrDBFieldList[mulDBFields.Selected];
      pDBField.Destroy;
      FWizardReport.wrDBFieldList.Delete(mulDBFields.Selected);
      LoadList;
    End; // If (MessageDlg ('Are you sure ...
  End; // If (mulDBFields.Selected >= 0)
end;

//------------------------------

procedure TfrmRepWizard.btnFieldUpClick(Sender: TObject);
begin
  If (mulDBFields.Selected >= 1) Then
  Begin
    FWizardReport.wrDBFieldList.Exchange (mulDBFields.Selected - 1, mulDBFields.Selected);
    LoadList;
    mulDBFields.Selected := mulDBFields.Selected - 1;
  End; // If (mulDBFields.Selected >= 0)
end;

//------------------------------

procedure TfrmRepWizard.btnFieldDownClick(Sender: TObject);
begin
  If (mulDBFields.Selected > -1) and
     (mulDBFields.Selected <= (FWizardReport.wrDBFieldList.Count - 2)) Then
  Begin
    FWizardReport.wrDBFieldList.Exchange (mulDBFields.Selected, mulDBFields.Selected + 1);
    LoadList;
    mulDBFields.Selected := mulDBFields.Selected + 1;
  End; // If (mulDBFields.Selected >= 0)
end;

//-------------------------------------------------------------------------

procedure TfrmRepWizard.LoadSortLists;
Var
  pDBField : TDBFieldColumn;
  I        : SmallInt;
Begin // LoadSortLists
  // NOTE: ClearItems will destroy the objects so we need to remove the references from
  // the list to keep them intact
  If (mulUnsorted.DesignColumns[0].Items.Count > 0) Then
  Begin
    For I := 0 To (mulUnsorted.DesignColumns[0].Items.Count - 1) Do
    Begin
      mulUnsorted.DesignColumns[0].Items.Objects[I] := NIL;
    End; // For I
  End; // If (mulUnsorted.DesignColumns[0].Items.Count > 0)
  mulUnsorted.ClearItems;

  If (mulSorted.DesignColumns[0].Items.Count > 0) Then
  Begin
    For I := 0 To (mulSorted.DesignColumns[0].Items.Count - 1) Do
    Begin
      mulSorted.DesignColumns[0].Items.Objects[I] := NIL;
    End; // For I
  End; // If (mulSorted.DesignColumns[0].Items.Count > 0)
  mulSorted.ClearItems;

  // Load sorted items first
  If (FWizardReport.wrSortedFields.Count > 0) Then
  Begin
    For I := 0 To (FWizardReport.wrSortedFields.Count - 1) Do
    Begin
      pDBField := FWizardReport.wrSortedFields[I];
      mulSorted.DesignColumns[0].Items.AddObject (Trim(pDBField.DictRec.VarName), pDBField);
      mulSorted.DesignColumns[1].Items.Add (IfThen(pDBField.SortAscending, 'Ascending', 'Descending'));
      mulSorted.DesignColumns[2].Items.Add (IfThen(pDBField.PageBreak, 'Yes', 'No'));

      // Reset the SortOrder so that they come out correctly in the designer
      pDBField.SortIdx := I + 1;
    End; // For I
  End; // If (FWizardReport.wrSortedFields.Count > 0)

  // Now load unsorted items
  If (FWizardReport.wrDBFieldList.Count > 0) Then
  Begin
    For I := 0 To (FWizardReport.wrDBFieldList.Count - 1) Do
    Begin
      pDBField := FWizardReport.wrDBFieldList[I];
      If (pDBField.SortIdx = 0) Then
      Begin
        mulUnsorted.DesignColumns[0].Items.AddObject (Trim(pDBField.DictRec.VarName), pDBField);
      End; // If (pDBField^.SortIdx = 0)
    End; // For I
  End; // If (FWizardReport.wrDBFieldList.Count > 0)
End; // LoadSortLists

//------------------------------

procedure TfrmRepWizard.mulUnsortedRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  btnAddOneClick(Sender);
end;

//------------------------------

procedure TfrmRepWizard.btnAddOneClick(Sender: TObject);
Var
  pDBField : TDBFieldColumn;
begin
  If (mulUnsorted.Selected >= 0) Then
  Begin
    pDBField := TDBFieldColumn(mulUnsorted.DesignColumns[0].Items.Objects[mulUnsorted.Selected]);
    pDBField.SortIdx := 1;
    pDBField.SortAscending := True;
    pDBField.PageBreak := False;
    FWizardReport.wrSortedFields.Add(pDBField);
    LoadSortLists;
  End; // If (mulUnsorted.Selected >= 0)
end;

//------------------------------

procedure TfrmRepWizard.btnRemoveOneClick(Sender: TObject);
Var
  pDBField : TDBFieldColumn;
begin
  If (mulSorted.Selected >= 0) Then
  Begin
    // Turn off the sort flag and remove from the list of sorted columns
    pDBField := TDBFieldColumn(mulSorted.DesignColumns[0].Items.Objects[mulSorted.Selected]);
    pDBField.SortIdx := 0;
    FWizardReport.wrSortedFields.Delete(mulSorted.Selected);
    LoadSortLists;
  End; // If (mulUnsorted.Selected >= 0)
end;

//------------------------------

procedure TfrmRepWizard.btnSortOrderClick(Sender: TObject);
Var
  pDBField : TDBFieldColumn;
begin
  If (mulSorted.Selected >= 0) Then
  Begin
    // Swap the sort order flag
    pDBField := TDBFieldColumn(mulSorted.DesignColumns[0].Items.Objects[mulSorted.Selected]);
    pDBField.SortAscending := Not pDBField.SortAscending;
    LoadSortLists;
  End; // If (mulUnsorted.Selected >= 0)
end;

//------------------------------

procedure TfrmRepWizard.btnPageBreakClick(Sender: TObject);
Var
  pDBField : TDBFieldColumn;
begin
  If (mulSorted.Selected >= 0) Then
  Begin
    // Swap the sort order flag
    pDBField := TDBFieldColumn(mulSorted.DesignColumns[0].Items.Objects[mulSorted.Selected]);
    pDBField.PageBreak := Not pDBField.PageBreak;
    LoadSortLists;
  End; // If (mulUnsorted.Selected >= 0)
end;

//------------------------------

procedure TfrmRepWizard.btnSortUpClick(Sender: TObject);
begin
  If (mulSorted.Selected >= 1) Then
  Begin
    FWizardReport.wrSortedFields.Exchange (mulSorted.Selected - 1, mulSorted.Selected);
    LoadSortLists;
    mulSorted.Selected := mulSorted.Selected - 1;
  End; // If (mulSorted.Selected >= 0)
end;

//------------------------------

procedure TfrmRepWizard.btnSortDownClick(Sender: TObject);
begin
  If (mulSorted.Selected > -1) and
     (mulSorted.Selected <= (FWizardReport.wrSortedFields.Count - 2)) Then
  Begin
    FWizardReport.wrSortedFields.Exchange (mulSorted.Selected, mulSorted.Selected + 1);
    LoadSortLists;
    mulSorted.Selected := mulSorted.Selected + 1;
  End; // If (mulSorted.Selected >= 0)
end;

//-------------------------------------------------------------------------

procedure TfrmRepWizard.LoadFilterList;
Var
  pDBField : TDBFieldColumn;
  I        : SmallInt;
Begin // LoadFilterList
  mulFieldFilters.ClearItems;

  If (FWizardReport.wrDBFieldList.Count > 0) Then
  Begin
    For I := 0 To (FWizardReport.wrDBFieldList.Count - 1) Do
    Begin
      pDBField := FWizardReport.wrDBFieldList[I];
      mulFieldFilters.DesignColumns[0].Items.Add (Trim(pDBField.DictRec.VarName));
      mulFieldFilters.DesignColumns[1].Items.Add (Trim(pDBField.Filter));
    End; // For I
  End; // If (FWizardReport.wrDBFieldList.Count > 0)
End; // LoadFilterList

//------------------------------

procedure TfrmRepWizard.mulFieldFiltersRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  btnEditFilterClick(Sender);
end;

//------------------------------

procedure TfrmRepWizard.btnEditFilterClick(Sender: TObject);
Var
  pDBField : TDBFieldColumn;
begin
  If (mulFieldFilters.Selected >= 0) Then
  Begin
    pDBField := FWizardReport.wrDBFieldList[mulFieldFilters.Selected];
    If DisplayWizardFilter (FWizardReport, pDBField) Then
    Begin
      LoadFilterList;
    End; // If DisplayWizardFilter (FWizardReport, pDBField)
  End; // If (mulFieldFilters.Selected >= 0)
end;

//-------------------------------------------------------------------------

procedure TfrmRepWizard.BuildRegionsList;
Var
  oRegion : TRegionInfo;
  oDBField : TDBFieldColumn;
  I : Byte;
Begin // BuildRegionsList
  FWizardReport.ClearSections;

  FWizardReport.wrSections.Add(TRegionInfo.Create (rtRepHdr, 0, 1, 'Report Header'));

  FWizardReport.wrSections.Add(TRegionInfo.Create (rtPageHdr, 0, 2, 'Page Header'));

  If (FWizardReport.wrSortedFields.Count > 0) Then
  Begin
    // Section Headers
    For I := 0 To (FWizardReport.wrSortedFields.Count - 1) Do
    Begin
      oDBField := TDBFieldColumn(FWizardReport.wrSortedFields[I]);
//      FWizardReport.wrSections.Add(TRegionInfo.Create (rtSectionHdr, I + 1, 3 + I, 'Section ' + IntToStr(I + 1) + ' Header  [' + Trim(oDBField.DictRec.VarName) + ']'));
      FWizardReport.wrSections.Add(TRegionInfo.Create (rtSectionHdr, I + 1, 3 + I, 'Section Header '  + IntToStr(I + 1) + ' [' + Trim(oDBField.DictRec.VarName) + ']'));
    End; // For I

    // Report Lines
    FWizardReport.wrSections.Add(TRegionInfo.Create (rtRepLines, 0, 3 + FWizardReport.wrSortedFields.Count, 'Report Line'));

    // Section Footers (in reverse order)
    For I := (FWizardReport.wrSortedFields.Count - 1) DownTo 0 Do
    Begin
      oDBField := TDBFieldColumn(FWizardReport.wrSortedFields[I]);
      FWizardReport.wrSections.Add(TRegionInfo.Create (rtSectionFtr, I + 1, 3 + I, 'Section Footer ' + IntToStr(I + 1) + ' [' + Trim(oDBField.DictRec.VarName) + ']'));
    End; // For I
  End //
  Else
  Begin
    FWizardReport.wrSections.Add(TRegionInfo.Create (rtRepLines, 0, 3, 'Report Line'));
  End; // Else

  FWizardReport.wrSections.Add(TRegionInfo.Create (rtPageFtr, 0, 2, 'Page Footer'));
  FWizardReport.wrSections.Add(TRegionInfo.Create (rtRepFtr, 0, 1, 'Report Footer'));
End; // BuildRegionsList

//------------------------------

procedure TfrmRepWizard.LoadSectionsTree;
Var
  oRegInfo : TRegionInfo;
  I : Byte;
Begin // LoadSectionsTree
  // Rebuild sections list to pickup and changes
  lbSections.Clear;

  If (FWizardReport.wrSections.Count > 0) Then
  Begin
    For I := 0 To (FWizardReport.wrSections.Count - 1) Do
    Begin
      oRegInfo := TRegionInfo(FWizardReport.wrSections.Items[I]);
      lbSections.Items.AddObject(oRegInfo.RegionDesc, oRegInfo);
    End; // For I

    lbSections.ItemIndex := 0;
    lbSectionsClick(Self);
  End; // If (FWizardReport.wrSections.Count > 0)
End; // LoadSectionsTree

//------------------------------

procedure TfrmRepWizard.lbSectionsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  oRegionData : TRegionInfo;
  sTxt    : ANSIString;
  lRect   : TRect;
  siObjIdx : SmallInt;
begin
  with lbSections.Canvas do
  begin
    oRegionData := TRegionInfo(lbSections.Items.Objects[Index]);

    lRect := Rect;
    FillRect(lRect);
    Rect.Left := Rect.Left + 3 + ((oRegionData.Indent - 1) * 10);

    // Paint in the text for this column
    sTxt := lbSections.Items[Index];

    // set font colour depending upon current state of selected text
    if oRegionData.RegionVisible then
      Font.Color := clDefault
    else
      Font.Color := clBtnFace; // clBtnFace, for disabled/invisable section

    if (Font.Color = clDefault) then
      if (odSelected in State) then
        Font.Color := clHighLightText;

    // DrawTextEx() is a Windows API call
    DrawTextEx (Handle,       // handle of device context
                PCHAR(sTxt),  // address of string to draw
                Length(sTxt), // length of string to draw
                Rect,         // address of rectangle coordinates
                DT_Left or DT_MODIFYSTRING or DT_END_ELLIPSIS,   // formatting options
                nil);	        // address of structure for more options
  end; // with lbSections.Canvas do...
end;

//------------------------------

// Enable/Disable the buttons according to the status of the current item
procedure TfrmRepWizard.lbSectionsClick(Sender: TObject);
var
  oRegionData : TRegionInfo;
begin
  oRegionData := TRegionInfo(lbSections.Items.Objects[lbSections.ItemIndex]);
  btnShowSection.Enabled := Not oRegionData.RegionVisible;
  btnHideSection.Enabled := oRegionData.RegionVisible;
end;

//------------------------------

// Switch the status of the current item
procedure TfrmRepWizard.lbSectionsDblClick(Sender: TObject);
var
  oRegionData : TRegionInfo;
begin
  oRegionData := TRegionInfo(lbSections.Items.Objects[lbSections.ItemIndex]);
  oRegionData.RegionVisible := Not oRegionData.RegionVisible;
  lbSections.Invalidate;
  lbSectionsClick(Sender);
end;

//------------------------------

procedure TfrmRepWizard.btnShowSectionClick(Sender: TObject);
var
  oRegionData : TRegionInfo;
begin
  oRegionData := TRegionInfo(lbSections.Items.Objects[lbSections.ItemIndex]);
  oRegionData.RegionVisible := True;
  lbSections.Invalidate;
  lbSectionsClick(Sender);
end;

//------------------------------

procedure TfrmRepWizard.btnHideSectionClick(Sender: TObject);
var
  oRegionData : TRegionInfo;
begin
  oRegionData := TRegionInfo(lbSections.Items.Objects[lbSections.ItemIndex]);
  oRegionData.RegionVisible := False;
  lbSections.Invalidate;
  lbSectionsClick(Sender);
end;

//------------------------------

procedure TfrmRepWizard.btnShowAllSectionsClick(Sender: TObject);
var
  oRegionData : TRegionInfo;
  I           : SmallInt;
begin
  For I := 0 To (lbSections.Items.Count - 1) Do
  Begin
    oRegionData := TRegionInfo(lbSections.Items.Objects[I]);
    oRegionData.RegionVisible := True;
  End; // For I
  lbSections.Invalidate;
  lbSectionsClick(Sender);
end;

//-------------------------------------------------------------------------

initialization

  IsLITE := (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]);

end.
