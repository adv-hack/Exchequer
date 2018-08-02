unit pageoptn;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PageComp, TEditVal, ExtCtrls, SBSPanel, ComCtrls, Mask,
  BorBtns, GlobType, bkgroup;

type
  TForm_PageOptions = class(TForm)
    Button_Ok: TButton;
    Button_Cancel: TButton;
    PageControl1: TPageControl;
    TabSh_General: TTabSheet;
    TabSh_Size: TTabSheet;
    SBSGrp_Orientation: TSBSGroup;
    Button_LoadPaper: TButton;
    Button_PrintTest: TButton;
    TabSh_Structure: TTabSheet;
    SBSGrp_PageHed: TSBSGroup;
    Label86: Label8;
    SBSGrp_BodyHed: TSBSGroup;
    Label87: Label8;
    SBSGrp_Body: TSBSGroup;
    Label88: Label8;
    SBSGrp_BodyFoot: TSBSGroup;
    Label89: Label8;
    SBSGrp_PageFoot: TSBSGroup;
    Label814: Label8;
    SBSPanel4: TSBSPanel;
    Label_Font: Label8;
    FontDialog1: TFontDialog;
    Memo_Description: TMemo;
    Text_Continue: Text8Pt;
    Button_SelectContinue: TButton;
    Button_Font: TButton;
    BorRadio_Portrait: TBorRadio;
    BorRadio_Landscape: TBorRadio;
    BorCheck_PageHead: TBorCheck;
    BorCheck_BodyHead: TBorCheck;
    BorCheck_Body: TBorCheck;
    BorCheck_BodyFoot: TBorCheck;
    BorCheck_PageFoot: TBorCheck;
    OpenDialog: TOpenDialog;
    Ccy_Height: TCurrencyEdit;
    Ccy_Width: TCurrencyEdit;
    Ccy_Top: TCurrencyEdit;
    Ccy_Bottom: TCurrencyEdit;
    Ccy_Left: TCurrencyEdit;
    Ccy_Right: TCurrencyEdit;
    TabSh_Strings: TTabSheet;
    Text_SV1: Text8Pt;
    Text_SV2: Text8Pt;
    Text_SV9: Text8Pt;
    Text_SV8: Text8Pt;
    Text_SV3: Text8Pt;
    Text_SV7: Text8Pt;
    Text_SV6: Text8Pt;
    Text_SV5: Text8Pt;
    Text_SV4: Text8Pt;
    Text_SV10: Text8Pt;
    SBSBackGroup1: TSBSBackGroup;
    Label815: Label8;
    Label819: Label8;
    Label820: Label8;
    Label818: Label8;
    Label816: Label8;
    Label817: Label8;
    Label821: Label8;
    Label822: Label8;
    Label823: Label8;
    Label824: Label8;
    Label82: Label8;
    Label83: Label8;
    SBSBackGroup6: TSBSBackGroup;
    Label84: Label8;
    Label85: Label8;
    SBSBackGroup7: TSBSBackGroup;
    Label811: Label8;
    Label810: Label8;
    Label813: Label8;
    Label812: Label8;
    TabSh_Printer: TTabSheet;
    SBSBackGroup5: TSBSBackGroup;
    Label826: Label8;
    Label827: Label8;
    Ccy_Copies: TCurrencyEdit;
    PrintList: TSBSComboBox;
    Label828: Label8;
    PapersList: TSBSComboBox;
    SBSBackGroup8: TSBSBackGroup;
    Label829: Label8;
    BinsList: TSBSComboBox;
    TabSh_Label: TTabSheet;
    SBSBackGroup9: TSBSBackGroup;
    Label831: Label8;
    lblTop: TCurrencyEdit;
    Label832: Label8;
    lblLeft: TCurrencyEdit;
    SBSBackGroup10: TSBSBackGroup;
    Label830: Label8;
    lblHeight: TCurrencyEdit;
    LblWidth: TCurrencyEdit;
    Label833: Label8;
    LblCols: TCurrencyEdit;
    Label834: Label8;
    Label835: Label8;
    lblColGap: TCurrencyEdit;
    PrintLblTest: TButton;
    SBSBackGroup11: TSBSBackGroup;
    lblRows: TCurrencyEdit;
    Label836: Label8;
    Label837: Label8;
    lblRowGap: TCurrencyEdit;
    SBSBackGroup12: TSBSBackGroup;
    Label838: Label8;
    List_Purpose: TSBSComboBox;
    Image_Paper: TImage;
    Image_Label: TImage;
    TabSh_Options: TTabSheet;
    SBSBackGroup13: TSBSBackGroup;
    lstShowADJBOM: TComboBox;
    Label839: Label8;
    SBSBackGroup3: TSBSBackGroup;
    Label825: Label8;
    Label81: Label8;
    CcyEdit_SnoWidth: TCurrencyEdit;
    cmbSnoFormat: TSBSComboBox;
    BCheck_ShowInSNo: TBorCheckEx;
    chkSerialNo: TBorCheck;
    chkBatchNo: TBorCheck;
    chkBins: TBorCheck;
    chkUseBy: TBorCheckEx;
    chkStockPriOrder: TBorCheckEx;
    tabshPickingList: TTabSheet;
    tabshSorting: TTabSheet;
    Label1: TLabel;
    chkPickListDescLines: TBorCheck;
    chkPickListDescOnly: TBorCheck;
    chkPickListNewLines: TBorCheck;
    Label841: Label8;
    lstSortTransLines: TComboBox;
    SBSBackGroup16: TSBSBackGroup;
    chkMarkTHOnDebtLetters: TBorCheck;
    Label842: Label8;
    SBSBackGroup2: TSBSBackGroup;
    SBSBackGroup4: TSBSBackGroup;
    SBSBackGroup14: TSBSBackGroup;
    Label840: Label8;
    chkInclHiddenBoM: TBorCheck;
    procedure Button_OkClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure EditVal_HeightChange(Sender: TObject);
    procedure EditVal_WidthChange(Sender: TObject);
    procedure EditVal_TopChange(Sender: TObject);
    procedure EditVal_BottomChange(Sender: TObject);
    procedure EditVal_LeftChange(Sender: TObject);
    procedure EditVal_RightChange(Sender: TObject);
    procedure Button_PrintTestClick(Sender: TObject);
    procedure Button_LoadPaperClick(Sender: TObject);
    procedure Button_FontClick(Sender: TObject);
    procedure BorRadio_PortraitClick(Sender: TObject);
    procedure Button_SelectContinueClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure CcyEdit_SnoWidthChange(Sender: TObject);
    procedure cmbSnoFormatClick(Sender: TObject);
    procedure Ccy_CopiesChange(Sender: TObject);
    procedure PrintListClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure lblTopExit(Sender: TObject);
    procedure lblLeftExit(Sender: TObject);
    procedure lblHeightExit(Sender: TObject);
    procedure LblWidthExit(Sender: TObject);
    procedure LblColsExit(Sender: TObject);
    procedure lblColGapExit(Sender: TObject);
    procedure lblRowsExit(Sender: TObject);
    procedure lblRowGapExit(Sender: TObject);
    procedure PrintLblTestClick(Sender: TObject);
    procedure List_PurposeClick(Sender: TObject);
    procedure chkSerialNoClick(Sender: TObject);
  private
    { Private declarations }
    FController        : TSBSController;
    DoingSaveAs        : Boolean;
    HeaderRec          : fdHeaderRecType;
    StringRec          : fdFormStringsType;
    BinMode, PaperMode : LongInt;

    Procedure ErrMsg (Const Msg : String);
    function  ContinueOk : Boolean;
    procedure ValLabelSize;

    Procedure PaintLabel(Sender: TObject);
    Procedure PaintPage(Sender: TObject);
  public
    { Public declarations }
    Ok : Boolean;
    Procedure SetControls (Controller : TSBSController;FreezeType:Boolean);
    Procedure SaveAs;
  end;

var
  Form_PageOptions: TForm_PageOptions;

implementation

{$R *.DFM}

Uses DllInt, EtStrU, FormUtil, RpDevice, EntLicence, Math;

procedure TForm_PageOptions.FormCreate(Sender: TObject);
Var
  I, incDiff : SmallInt;
  LITEMode : Boolean;

  Function StripOnP(S : ShortString) : ShortString;
  Var
    FoundOk : Boolean;
    wc,n    : Byte;
  Begin
    wc:=WordCnt(S);

    FoundOk:=False;

    For n:=1 to wc do Begin
      FoundOk:=(UpCaseStr(ExtractWords(n,1,S))='ON');

      If (FoundOk) then
        Break;
    end;

    If (FoundOk) then
      Result:=Copy(S,1,Pred(PosWord(n,S)))
    else
      Result:=S;
  end;

  Function CreatePtr(Const Id : LongInt) : Pointer;
  Begin // CreatePtr
    Result := POINTER(Id);
  End; // CreatePtr

begin
  { Create images on tab }
  PageControl1.ActivePage := TabSh_Label;
  (*
  Image_Label := TImage.Create(Self);
  With Image_Label Do Begin
    Parent := TabSh_Label;

    Align    := alLeft;
    AutoSize := True;
    Name     := 'Image_Label';
    Width    := 211;

    OnClick  := PaintLabel;
  End; { With }
  *) Image_Label.OnClick  := PaintLabel;

  PageControl1.ActivePage := TabSh_Size;
  (*
  Image_Paper := TImage.Create(Self);
  With Image_Paper Do Begin
    Parent := TabSh_Size;

    Align    := alTop;
    AutoSize := True;
    Height   := 148;
    Name     := 'Image_Paper';

    OnClick  := PaintPage;
  End; { With }
  *) Image_Paper.OnClick  := PaintPage;

  PageControl1.ActivePage := TabSh_General;

  If (RpDev.Printers.Count > 0) Then
    For I := 0 To Pred(RpDev.Printers.Count) Do Begin
      PrintList.Items.AddObject(StripOnP(RpDev.Printers[I]),Pointer(I));
      {PrintList.Items.Add (StripOnP(RpDev.Printers[I]));}
      {PrintList.ItemsL.Add (StripOnP(RpDev.Printers[I]));}
    End; { For }

  { Disable print buttons if no printers available }
  Button_PrintTest.Enabled := (RpDev.Printers.Count > 0);
  PrintLblTest.Enabled := Button_PrintTest.Enabled;

  PrintList.Enabled := Button_PrintTest.Enabled;
  PapersList.Enabled := Button_PrintTest.Enabled;
  BinsList.Enabled := Button_PrintTest.Enabled;

  // MH 08/02/06: Mods to hide Serial/Batch/Bin for LITE
  LITEMode := (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]);
  If LITEMode Then
  Begin
    // Hide Serial/Batch/Bin Section
    SBSBackGroup3.Visible := False;
    chkSerialNo.Visible := False;
    chkBatchNo.Visible := False;
    chkBins.Visible := False;
    BCheck_ShowInSNo.Visible := False;
    chkUseBy.Visible := False;
    chkStockPriOrder.Visible := False;
    Label825.Visible := False;
    cmbSnoFormat.Visible := False;
    Label81.Visible := False;
    CcyEdit_SnoWidth.Visible := False;
    Label840.Visible := False;

    IncDiff := SBSBackGroup13.Top - SBSBackGroup3.Top;

    // Move Stock Adjustments section up to cover the gap
    SBSBackGroup13.Top := SBSBackGroup13.Top - IncDiff;
    Label839.Top := Label839.Top - IncDiff;
    lstShowADJBOM.Top := lstShowADJBOM.Top - IncDiff;

    // Move Debt Chase Letters
    SBSBackGroup16.Top := SBSBackGroup16.Top - IncDiff;
    chkMarkTHOnDebtLetters.Top := chkMarkTHOnDebtLetters.Top - IncDiff;
  End; // LITEMode

  // MH 14/02/06: Filter location options out of the Stock Adjustment and Transaction
  // Line Sorting combo boxes
  lstShowADJBOM.Items.Clear;
  lstShowADJBOM.Items.AddObject ('Don''t Show hidden BOM Lines', CreatePtr(0));
  lstShowADJBOM.Items.AddObject ('Show - Build Order', CreatePtr(1));
  lstShowADJBOM.Items.AddObject ('Show - sort by Stock Code', CreatePtr(2));
  If (Not LITEMode) Then lstShowADJBOM.Items.AddObject ('Show - sort by Location and Stock Code', CreatePtr(3));
  lstShowADJBOM.Items.AddObject ('Show - sort by Bin Location and Stock Code', CreatePtr(4));
  If (Not LITEMode) Then lstShowADJBOM.Items.AddObject ('Show - sort by Location, Bin Location and Stock Code', CreatePtr(5));
  If (Not LITEMode) Then lstShowADJBOM.Items.AddObject ('Show - sort by Location and Build Order', CreatePtr(6));
  lstShowADJBOM.Items.AddObject ('Show - sort by Bin Location and Build Order', CreatePtr(7));
  If (Not LITEMode) Then lstShowADJBOM.Items.AddObject ('Show - sort by Location, Bin Location and Build Order', CreatePtr(8));
  lstShowADJBOM.Items.AddObject ('Show - sort by Component - Stock Code Order', CreatePtr(9));
  lstShowADJBOM.Items.AddObject ('Show - sort by Component - Build Order', CreatePtr(10));
  lstShowADJBOM.Items.AddObject ('Show - sort by Component - Bin Location and Stock Code Order', CreatePtr(11));
  lstShowADJBOM.Items.AddObject ('Show - sort by Component - Bin Location and Build Order', CreatePtr(12));
  If (Not LITEMode) Then lstShowADJBOM.Items.AddObject ('Show - sort by Component - Location and Stock Code Order', CreatePtr(13));
  If (Not LITEMode) Then lstShowADJBOM.Items.AddObject ('Show - sort by Component - Location and Build Order', CreatePtr(14));
  If (Not LITEMode) Then lstShowADJBOM.Items.AddObject ('Show - sort by Component - Location, Bin Location and Stock Code Order', CreatePtr(15));

  lstSortTransLines.Items.Clear;
  lstSortTransLines.Items.AddObject ('Don''t Sort', CreatePtr(0));
  lstSortTransLines.Items.AddObject ('Sort by Stock Code', CreatePtr(1));
  If (Not LITEMode) Then lstSortTransLines.Items.AddObject ('Sort by Location and Stock Code', CreatePtr(2));
  lstSortTransLines.Items.AddObject ('Sort by Bin Location and Stock Code', CreatePtr(3));
  If (Not LITEMode) Then lstSortTransLines.Items.AddObject ('Sort by Location and Bin Location and Stock Code', CreatePtr(4));
  If (Not LITEMode) Then lstSortTransLines.Items.AddObject ('Sort by Component - Stock Code Order', CreatePtr(5));
end;

procedure TForm_PageOptions.FormDestroy(Sender: TObject);
begin
  //Image_Label.Free;
end;

procedure TForm_PageOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_PageOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

Procedure TForm_PageOptions.SetControls (Controller : TSBSController;FreezeType:Boolean);
Var
  I : SmallInt;

  Procedure HideControls (ParControl : TControl;HideNum : LongInt);
  Var
    I : SmallInt;
  Begin
    With ParControl Do
      If (ComponentCount > 0) Then
        For I := 0 To Pred(ComponentCount) Do
          If (Components[I].Tag = HideNum) Then
            TControl(Components[I]).Hide;
  End;

  Procedure SelectListItem(Const List : TComboBox; Const ListId : LongInt);
  Var
    lId : LongInt;
    I : SmallInt;
  Begin // SelectListItem
    If (List.Items.Count > 0) Then
    Begin
      For I := 0 To (List.Items.Count - 1) Do
      Begin
        lId := LONGINT(List.Items.Objects[I]);
        If (ListId = lId) Then
        Begin
          List.ItemIndex := I;
          Break;
        End; // If (ListId = lId)
      End; // For I

      If (List.ItemIndex = -1) Then List.ItemIndex := 0;
    End; // If (List.Items.Count > 0)
  End; // SelectListItem


Begin
  FController := Controller;

  FController.FormDetails.DetailsToHedRec (HeaderRec);
  FController.FormDetails.DetailsToStrRec (StringRec);

  DoingSaveAs := False;

  With HeaderRec Do Begin
    If (fhFormType = ftLabel) Then Begin
      { Hide form controls }
      HideControls (Self, 1);
      TabSh_Options.TabVisible := False;
      tabshPickingList.TabVisible := False;
      tabshSorting.TabVisible := False;

      { Reposition remaining controls }
      SBSBackGroup12.Top := 90;
      Label838.Top := SBSBackGroup12.Top + 16;
      List_Purpose.Top := SBSBackGroup12.Top + 13;
      SBSPanel4.Top := 137;
      Button_Font.Top := SBSPanel4.Top + 6;

      { Add Purposes into list }
      List_Purpose.Clear;
      List_Purpose.Items.Add ('Customer Labels');
      List_Purpose.Items.Add ('Supplier Labels');
      List_Purpose.Items.Add ('Stock Labels');
    End { If }
    Else Begin
      { Hide label controls }
      HideControls (Self, 2);

      TabSh_Label.TabVisible := False;
      TabSh_Options.TabVisible := True;
      tabshPickingList.TabVisible := True;
      tabshSorting.TabVisible := True;
    End; { Else }


    Case fhFormType Of
      ftForm  : Caption := 'Form Options';
      ftLabel : Caption := 'Label Options';
    End; { Case }

    Memo_Description.Text := fhFormDescr;
    Text_Continue.Text := SplitFileName (fhContinue).Name;
    Label_Font.Font.Assign (FController.FormDetails.ftDefaultFont);

    // HM 28/08/03: Modified Serial Number section for Bins and Use By Date
//    Case fhSerialNo Of
//      0..3   : Combo_SNo.ItemIndex := fhSerialNo;
//      11..13 : Combo_SNo.ItemIndex := fhSerialNo - 7;
//    End; { Case }
    CcyEdit_SnoWidth.Value := fhSNoWidth;
    BCheck_ShowInSNo.Checked := fhInpSNo;

    If (fhSerialNo < 10) Then
      cmbSnoFormat.ItemIndex := 0  // 1 Per Line
    Else
      cmbSnoFormat.ItemIndex := 1;  // Full Line
    chkSerialNo.Checked := fhSerialNo In [1, 3, 11, 13];
    chkBatchNo.Checked := fhSerialNo In [2, 3, 12, 13];
    chkBins.Checked := fhShowBins;
    chkUseBy.Checked := fhShowUseBy;
    chkStockPriOrder.Checked := fhStockOrder;
    cmbSnoFormatClick(Self);
    chkSerialNoClick(Self);


    CCy_Copies.Value := fhCopies;

    BorRadio_Portrait.Checked  := (fhOrientation = fdoPortrait);
    BorRadio_Landscape.Checked := (fhOrientation = fdoLandscape);

    Ccy_Height.Value := fhPaperHeight;
    Ccy_Width.Value  := fhPaperWidth;
    Ccy_Top.Value    := fhTopWaste;
    Ccy_Bottom.Value := fhBottomWaste;
    Ccy_Left.Value   := fhLeftWaste;
    Ccy_Right.Value  := fhRightWaste;

    { Page format (Separator Bars) }
    With FController Do Begin
      BorCheck_PageHead.Checked := (stPageHead In fhSections);
      BorCheck_BodyHead.Checked := (stBodyHead In fhSections);
      BorCheck_Body.Checked     := (stBody     In fhSections);
      BorCheck_BodyFoot.Checked := (stBodyFoot In fhSections);
      BorCheck_PageFoot.Checked := (stPagefoot In fhSections);
    End; { With }

    { Default Printer & Bin }
    If (fhBinNo <> 0) Then
      BinMode := fhBinNo  { select pre-selected bin }
    Else
      BinMode := -1;      { Select windows default bin }
    If (fhPaperNo <> 0) Then
      PaperMode := fhPaperNo  { select pre-selected paper }
    Else
      PaperMode := -1;      { Select windows default paper }
    If (PrintList.Items.Count > 0) Then Begin
      For I := 0 To Pred(PrintList.Items.Count) Do
        If (fhPrinter = Copy(PrintList.Items[I], 1, Length(fhPrinter))) Then Begin
          PrintList.ItemIndex := I;
          Break;
        End; { If }

      PrintListClick(Self);
    End; { If }

    If (fhFormType = ftLabel) Then Begin
      { Set label specific values }
      lblTop.Value := fhLblTop;
      lblLeft.Value := fhLblLeft;
      lblWidth.Value := fhLblWidth;
      lblHeight.Value := fhLblHeight;
      lblCols.Value := fhLblCols;
      lblRows.Value := fhLblRows;
      lblColGap.Value := fhLblColGap;
      lblRowGap.Value := fhLblRowGap;

      List_Purpose.ItemIndex := fhPurpose;
    End; { If }

    // HM v4.32 06/02/01: Added support for printing hidden ADJ lines
    //lstShowADJBom.ItemIndex := fhPrintAdjBom;
    SelectListItem(lstShowADJBom, fhPrintAdjBom);

    // HM v4.32 14/02/01: Added support for sorting normal documents
    //lstSortTransLines.ItemIndex := fhDocSortMode;
    SelectListItem(lstSortTransLines, fhDocSortMode);

    // HM 14/01/04: v5.60 Added flag to control whether Additional Description Lines are shown on Picking Lists
    chkPickListDescLines.Checked := fhShowAddDesc;

    // MH 18/04/06: IAO/v55.71 - Added flag to stop the form updating the last letter info for Debt Chase Letters
    chkMarkTHOnDebtLetters.Checked := Not fhSuppressDL;

    // MH 04/09/06: IAO/v5.71 - Added additional flags for picking lists
    chkPickListDescOnly.Checked := fhShowDescOnly;  // Include non-stock/description only lines in single picking lists
    chkPickListNewLines.Checked := fhInclNewLines;  // Include TL's with 0 Picking Run Number

    // MH 13/03/09: v6.01 - Added additional additional flags for picking lists
    chkInclHiddenBoM.Checked := fhExplodeBoMs; // Explode Hidden Bill of Materials Line into Picking Lists
  End; { With }

  With StringRec Do Begin
    Text_SV1.Text := fsSVStrs[1];
    Text_SV2.Text := fsSVStrs[2];
    Text_SV3.Text := fsSVStrs[3];
    Text_SV4.Text := fsSVStrs[4];
    Text_SV5.Text := fsSVStrs[5];
    Text_SV6.Text := fsSVStrs[6];
    Text_SV7.Text := fsSVStrs[7];
    Text_SV8.Text := fsSVStrs[8];
    Text_SV9.Text := fsSVStrs[9];
    Text_SV10.Text := fsSVStrs[10];
  End; { With }

  PaintPage(Self);
End;


Procedure TForm_PageOptions.SaveAs;
begin
  DoingSaveAs := True;
end;

procedure TForm_PageOptions.Button_OkClick(Sender: TObject);
Var
  Valid    : Boolean;
  I        : SmallInt;

  Function GetValue(Const List : TComboBox) : LongInt;
  Begin // GetValue
    If (List.ItemIndex > -1) Then
      Result := LONGINT(List.Items.Objects[List.ItemIndex])
    Else
      Result := -1;
  End; // GetValue

begin
  { Validate and apply stuff here }
  Valid := ContinueOk;
  If Valid Then
    With HeaderRec, StringRec Do Begin
      { General Tab }
      fhFormDescr := Memo_Description.Text;
      FController.FormDetails.ftDefaultFont.Assign(Label_Font.Font);
      fhContinue := ANSIUpperCase (Text_Continue.Text);
      // HM 28/08/03: Modified Serial Number section for Bins and Use By Date
//      Case Combo_SNo.ItemIndex Of
//        4,
//        5,
//        6 : fhSerialNo := Combo_SNo.ItemIndex + 7;
//      Else
//        fhSerialNo := Combo_SNo.ItemIndex;
//      End; { Case }
      fhSNoWidth := Round(CcyEdit_SnoWidth.Value);
      fhInpSNo   := BCheck_ShowInSNo.Checked;

      If (cmbSnoFormat.ItemIndex = 0) Then
        fhSerialNo := 0  // 1 Per Line
      Else
        fhSerialNo := 10;  // Full Line
      If chkSerialNo.Checked Then fhSerialNo := fhSerialNo + 1;
      If chkBatchNo.Checked Then fhSerialNo := fhSerialNo + 2;
      fhShowBins := chkBins.Checked;
      fhShowUseBy := chkUseBy.Checked;
      fhStockOrder := chkStockPriOrder.Checked;

      fhCopies := Round(CCy_Copies.Value);
      If (fhCopies < 1) Then fhCopies := 1;
      If (fhCopies > 99) Then fhCopies := 99;
      fhPrinter := PrintList.Text;

      If (RpDev.Printers.Count > 0) Then
        With RpDev Do Begin
          { Printer Bin Number }
          If (Bins.Count > 0) Then
            For I := 0 To Pred (Bins.Count) Do
              If (BinsList.Text = Bins[I]) Then
                fhBinNo := LongInt(Bins.Objects[I]);

          { Printer Paper Number }
          If (Papers.Count > 0) Then
            For I := 0 To Pred (Papers.Count) Do
              If (PapersList.Text = Papers[I]) Then
                fhPaperNo := LongInt(Papers.Objects[I]);
        End; { With }

      { Structure Tab }
      fhSections := [];
      If BorCheck_PageHead.Checked Then Include (fhSections, stPageHead);
      If BorCheck_BodyHead.Checked Then Include (fhSections, stBodyHead);
      If BorCheck_Body.Checked Then Include (fhSections, stBody);
      If BorCheck_BodyFoot.Checked Then Include (fhSections, stBodyFoot);
      If BorCheck_PageFoot.Checked Then Include (fhSections, stPageFoot);

      { Strings }
      fsSVStrs[1] := Trim(Text_SV1.TexT);
      fsSVStrs[2] := Trim(Text_SV2.TexT);
      fsSVStrs[3] := Trim(Text_SV3.TexT);
      fsSVStrs[4] := Trim(Text_SV4.TexT);
      fsSVStrs[5] := Trim(Text_SV5.TexT);
      fsSVStrs[6] := Trim(Text_SV6.TexT);
      fsSVStrs[7] := Trim(Text_SV7.TexT);
      fsSVStrs[8] := Trim(Text_SV8.TexT);
      fsSVStrs[9] := Trim(Text_SV9.TexT);
      fsSVStrs[10] := Trim(Text_SV10.TexT);

      // HM v4.32 06/02/01: Added support for printing hidden ADJ lines
      //fhPrintAdjBom := lstShowADJBom.ItemIndex;
      fhPrintAdjBom := GetValue(lstShowADJBom);

      // HM v4.32 14/02/01: Added support for sorting normal documents
      //fhDocSortMode := lstSortTransLines.ItemIndex;
      fhDocSortMode := GetValue(lstSortTransLines);

      // HM 14/01/04: v5.60 Added flag to control whether Additional Description Lines are shown on Picking Lists
      fhShowAddDesc := chkPickListDescLines.Checked;

      // MH 18/04/06: IAO/v55.71 - Added flag to stop the form updating the last letter info for Debt Chase Letters
      fhSuppressDL := NOT chkMarkTHOnDebtLetters.Checked;

      // MH 04/09/06: IAO/v5.71 - Added additional flags for picking lists
      fhShowDescOnly := chkPickListDescOnly.Checked;  // Include non-stock/description only lines in single picking lists
      fhInclNewLines := chkPickListNewLines.Checked;  // Include TL's with 0 Picking Run Number

      // MH 13/03/09: v6.01 - Added additional additional flags for picking lists
      fhExplodeBoMs := chkInclHiddenBoM.Checked; // Explode Hidden Bill of Materials Line into Picking Lists

      Ok := True;

      With FController.FormDetails Do Begin
        HedRecToDetails (HeaderRec);
        StrRecToDetails (StringRec);
      End; { With }

      Close;
    End; { With }
end;

function TForm_PageOptions.ContinueOk : Boolean;
Var
  fName : String;
begin
  If (Trim(Text_Continue.Text) <> '') Then Begin
    fName := ANSIUpperCase (Text_Continue.Text + '.' + DefExtension);

    { check file already exists }
    Result := FileExists (SystemInfo.ExDataPath + FormsPath + fName);
  End { If }
  Else
    { Can be left blank }
    Result := True;

  If (Not Result) Then Begin
    If Text_Continue.CanFocus Then Text_Continue.SetFocus;

    MessageDlg ('The Continuation must be a valid definition file or be left blank. ' +
                Trim(Text_Continue.Text) + ' is not a valid definition file.',
                mtInformation, [mbOk], 0);
  End; { If }
end;

procedure TForm_PageOptions.Button_CancelClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

Procedure TForm_PageOptions.PaintPage(Sender: TObject);
Var
  TempInt,
  vImTop, hImLeft,
  ScaleHeight, ScaleWidth,
  ScaleTopMarg, ScaleBottomMarg,
  ScaleLeftMarg, ScaleRightMarg : LongInt;
  PageScale, PageScaleH         : Double;
begin
  If Self.Visible And Assigned (Image_Paper) Then
    With Image_Paper.Canvas do Begin
      { Calculate a Page Scale to map the page onto the image }
      //PageScale := Trunc (HeaderRec.fhPaperHeight / 120) + 1;


      // MH 08/11/06: Modified to use size of TImage instead of magic number and added
      // check on horizontal scaling as well otherwise it goes off the side on certain
      // combinations of size
      If BorRadio_Landscape.Checked Then
      Begin
        // For Landscape switch them around for the check
        PageScale := HeaderRec.fhPaperHeight / (Image_Paper.Width * 0.80);
        PageScaleH := HeaderRec.fhPaperWidth / (Image_Paper.Height * 0.80);
      End // If BorRadio_Landscape.Checked
      Else
      Begin
        // Portrait
        PageScale := HeaderRec.fhPaperHeight / (Image_Paper.Height * 0.80);
        PageScaleH := HeaderRec.fhPaperWidth / (Image_Paper.Width * 0.80);
      End; // Else
      If (PageScale < PageScaleH) Then PageScale := PageScaleH;


      { Calculate the scale sizes }
      ScaleHeight := Round(HeaderRec.fhPaperHeight / PageScale) + 2; { + 1 for each border }
      ScaleWidth := Round(HeaderRec.fhPaperWidth / PageScale) + 2; { + 1 for each border }
      If BorRadio_Landscape.Checked Then Begin
        TempInt     := ScaleHeight;
        ScaleHeight := ScaleWidth;
        ScaleWidth  := TempInt;
      End; { If }

      ScaleTopMarg := Round(HeaderRec.fhTopWaste / PageScale);
      ScaleBottomMarg := Round(HeaderRec.fhBottomWaste / PageScale);
      ScaleLeftMarg := Round(HeaderRec.fhLeftWaste / PageScale);
      ScaleRightMarg := Round(HeaderRec.fhRightWaste / PageScale);
      If BorRadio_Landscape.Checked Then Begin
        TempInt         := ScaleTopMarg;
        ScaleTopMarg    := ScaleLeftMarg;
        ScaleLeftMarg   := ScaleBottomMarg;
        ScaleBottomMarg := ScaleRightMarg;
        ScaleRightMarg  := TempInt;
      End; { If }

      { Fill Background }
      Pen.Color := clBtnFace;
      Brush.Color := clBtnFace;
      FillRect (ClientRect);

      vImTop  := (Image_Paper.Height - ScaleHeight) Div 2;
      hImLeft := (Image_Paper.Width - ScaleWidth) Div 2;

      { Draw Shadow }
      Pen.Color := clBtnShadow;
      Brush.Color := clBtnShadow;
      Rectangle (hImLeft + 5,
                 vImTop + 5,
                 (hImLeft  + ScaleWidth) + 5,
                 (vImTop + ScaleHeight) + 5);

      { Draw Page }
      Pen.Color := clBlack;
      If (HeaderRec.fhFormType = ftLabel) Then
        Brush.Color := clWhite
      Else
        Brush.Color := clSilver;
      {If Not HPage.Paper.psShade.Empty Then
        Brush.Bitmap := HPage.Paper.psShade;}
      Rectangle (hImLeft,
                 vImTop,
                 (hImLeft  + ScaleWidth),
                 (vImTop + ScaleHeight));

      { Draw printable area }
      Pen.Color := clWhite;
      Brush.Color := clWhite;
      Brush.Bitmap := NIL;
      Rectangle (hImLeft + 1 + ScaleLeftMarg,
                 vImTop + 1 + ScaleTopMarg,
                 (hImLeft  + ScaleWidth - 1 - ScaleRightMarg),
                 (vImTop + ScaleHeight - 1 - ScaleBottomMarg));
    End; { With }
end;

procedure TForm_PageOptions.EditVal_HeightChange(Sender: TObject);
begin
  If (Ccy_Height.Value > 10) And (Ccy_Height.Value <= 420) Then
    HeaderRec.fhPaperHeight := Round(Ccy_Height.Value)
  Else
    If Ccy_Height.CanFocus Then Begin
      Ccy_Height.Value := HeaderRec.fhPaperHeight;
      If Ccy_Height.CanFocus Then Ccy_Height.SetFocus;
      ErrMsg ('The Height must be between 10 and 420.');
    End; { Else }

  PaintPage(Self);
end;

procedure TForm_PageOptions.EditVal_WidthChange(Sender: TObject);
begin
  If (Ccy_Width.Value > 10) And (Ccy_Width.Value <= 420) Then
    HeaderRec.fhPaperWidth := Round(Ccy_Width.Value)
  Else
    If Ccy_Width.CanFocus Then Begin
      Ccy_Width.Value := HeaderRec.fhPaperWidth;
      If Ccy_Width.CanFocus Then Ccy_Width.SetFocus;
      ErrMsg ('The Width must be between 10 and 420.');
    End; { Else }

  PaintPage(Self);
end;

procedure TForm_PageOptions.EditVal_TopChange(Sender: TObject);
begin
  With HeaderRec Do Begin
    If (Ccy_Top.Value >= 0) And (Ccy_Top.Value < fhPaperHeight) Then
      fhTopWaste := Round(Ccy_Top.Value)
    Else
      If Ccy_Top.CanFocus Then Begin
        Ccy_Top.Value := fhTopWaste;
        If Ccy_Top.CanFocus Then Ccy_Top.SetFocus;
        ErrMsg ('The Top Margin must be between 0 and the Height specified.');
      End; { Else }
  End; { With }

  PaintPage(Self);
end;

procedure TForm_PageOptions.EditVal_BottomChange(Sender: TObject);
begin
  With HeaderRec do Begin
    If (Ccy_Bottom.Value >= 0) And (Ccy_Bottom.Value < (fhPaperHeight - fhTopWaste)) Then
      HeaderRec.fhBottomWaste := Round(Ccy_Bottom.Value)
    Else
      If Ccy_Bottom.CanFocus Then Begin
        Ccy_Bottom.Value := fhBottomWaste;
        If Ccy_Bottom.CanFocus Then Ccy_Bottom.SetFocus;
        ErrMsg ('The Bottom Margin must be between 0 and the Height specified less the Top Margin specified.');
      End; { Else }
  End; { With }

  PaintPage(Self);
end;

procedure TForm_PageOptions.EditVal_LeftChange(Sender: TObject);
begin
  With HeaderRec Do Begin
    If (Ccy_Left.Value >= 0) And (Ccy_Left.Value < fhPaperWidth) Then
      fhLeftWaste := Round(Ccy_Left.Value)
    Else
      If Ccy_Left.CanFocus Then Begin
        Ccy_Left.Value := fhLeftWaste;
        If Ccy_Left.CanFocus Then Ccy_Left.SetFocus;
        ErrMsg ('The Left Margin must be between 0 and the Width specified.');
      End; { Else }
  End; { With }

  PaintPage(Self);
end;

procedure TForm_PageOptions.EditVal_RightChange(Sender: TObject);
begin
  With HeaderRec Do Begin
    If (Ccy_Right.Value >= 0) And (Ccy_Right.Value < (fhPaperWidth - fhLeftWaste)) Then
      fhRightWaste := Round(Ccy_Right.Value)
    Else
      If Ccy_Right.CanFocus Then Begin
        Ccy_Right.Value := fhRightWaste;
        If Ccy_Right.Canfocus Then Ccy_Right.SetFocus;
        ErrMsg ('The Right Margin must be between 0 and the Width specified less the Left Margin specified.');
      End; { Else }
  End; { With }

  PaintPage(Self);
end;

Procedure TForm_PageOptions.ErrMsg (Const Msg : String);
begin
  MessageDlg (Msg,
              mtInformation,
              [mbOk],
              0);
end;

procedure TForm_PageOptions.Button_LoadPaperClick(Sender: TObject);
Var
  PaperSizeRec : PaperSizeType;
begin
  If SelectPaperSize (PaperSizeRec) Then Begin
    { Initialise size of page here }
    With HeaderRec, PaperSizeRec Do Begin
      Ccy_Height.Value := psHeight;
      Ccy_Width.Value  := psWidth;
      Ccy_Top.Value    := psTopWaste;
      Ccy_Bottom.Value := psBottomWaste;
      Ccy_Left.Value   := psLeftWaste;
      Ccy_Right.Value  := psRightWaste;
      fhPaperHeight := psHeight;
      fhPaperWidth := psWidth;
      fhTopWaste := psTopWaste;
      fhBottomWaste := psBottomWaste;
      fhLeftWaste := psLeftWaste;
      fhRightWaste := psRightWaste;
    End; { With }

    If Ccy_Height.CanFocus Then Ccy_Height.SetFocus;

    PaintPage (Sender);
  End; { If }
end;

{ Prints a test page which has a border outline }
procedure TForm_PageOptions.Button_PrintTestClick(Sender: TObject);
begin
  If RPDev.PrinterSetupDialog Then
    PrintPageBorders (HeaderRec, RpDev.SBSSetupInfo);
end;

procedure TForm_PageOptions.Button_FontClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(Label_Font.Font);
  FontDialog1.Execute;
  Label_Font.Font.Assign(FontDialog1.Font);
  HeaderRec.fhFont.ffName := Label_Font.Font.Name;
  HeaderRec.fhFont.ffSize := Label_Font.Font.Size;
  HeaderRec.fhFont.ffColor := Label_Font.Font.Color;
  HeaderRec.fhFont.ffStyle := Label_Font.Font.Style;
  HeaderRec.fhFont.ffPitch := Label_Font.Font.Pitch;
  HeaderRec.fhFont.ffHeight := Label_Font.Font.Height;
end;

procedure TForm_PageOptions.BorRadio_PortraitClick(Sender: TObject);
begin
  If BorRadio_Portrait.Checked Then
    HeaderRec.fhOrientation := fdoPortrait
  Else
    HeaderRec.fhOrientation := fdoLandscape;

  PaintPage (Sender);
end;

{ Use the form select dialog to get the continuation form }
procedure TForm_PageOptions.Button_SelectContinueClick(Sender: TObject);
Var
  PrevCur  : TCursor;
  FilePath : SplitFnameType;
  CurDir   : String;
begin
  CursorToHourglass (PrevCur);

  CurDir := GetCurrentDir;

  Repeat
    OpenDialog.Filename := Text_Continue.Text;
    OpenDialog.InitialDir := SystemInfo.ExDataPath + FormsPath;

    If OpenDialog.Execute Then Begin
      { put name of file into edit box }
      FilePath := SplitFileName (OpenDialog.FileName);
      If ValidFormDef (FilePath, True) Then Begin
        { check its not the one we are editing }
        If (FilePath.Name <> SplitFileName (FController.FormDetails.ftFormPath).Name) Then Begin
          { Check its in the forms directory }
          If (FilePath.Path = SplitFileName (SystemInfo.ExDataPath + FormsPath).Path) Then Begin
            Text_Continue.Text := Trim(FilePath.Name);
            Break;
          End { If }
          Else
            MessageDlg ('Only Forms in the Forms directory can be used as continuations', mtInformation, [mbOk], 0);
        End { If }
        Else
          MessageDlg ('The Form cannot be used as its own continuation', mtInformation, [mbOk], 0);
      End; { If }
    End { If }
    Else
      { Cancelled the dialog }
      Break;
  Until False;  { Don't worry, Be happy - the breaks will end the loop }

  SetCurrentDir(CurDir);

  RestoreCursor (PrevCur);
end;

{ validate serial number width }
procedure TForm_PageOptions.CcyEdit_SnoWidthChange(Sender: TObject);
begin
  With HeaderRec Do Begin
    If (CcyEdit_SnoWidth.Value >= 0) And (CcyEdit_SnoWidth.Value < fhPaperWidth) Then
      fhSNoWidth := Round(CcyEdit_SnoWidth.Value)
    Else
      If CcyEdit_SnoWidth.CanFocus Then Begin
        CcyEdit_SnoWidth.Value := fhSNoWidth;
        If CcyEdit_SnoWidth.CanFocus Then CcyEdit_SnoWidth.SetFocus;
        ErrMsg ('The Serial Number Field Width must be between 0 and the paper width specified.');
      End; { Else }
  End; { With }
end;

{ enable/disable serial number width }
procedure TForm_PageOptions.cmbSnoFormatClick(Sender: TObject);
begin
  CcyEdit_SnoWidth.Enabled := (cmbSnoFormat.ItemIndex = 1);
  //BCheck_ShowInSNo.Enabled := (cmbSnoFormat.ItemIndex > 0);
end;

procedure TForm_PageOptions.Ccy_CopiesChange(Sender: TObject);
begin
  With HeaderRec Do Begin
    If (Ccy_Copies.Value > 0) And (Ccy_Copies.Value < 100) Then
      fhCopies := Round(Ccy_Copies.Value)
    Else
      If Ccy_Copies.CanFocus Then Begin
        Ccy_Copies.Value := fhCopies;
        If Ccy_Copies.CanFocus Then Ccy_Copies.SetFocus;
        ErrMsg ('The number of copies to be printed must be from 1 to 99.');
      End; { Else }
  End; { With }
end;

procedure TForm_PageOptions.PrintListClick(Sender: TObject);
Var
  I : Integer;
begin
  { Load bins list }
  If (RpDev.Printers.Count > 0) And PrintList.Enabled Then
    If (PrintList.ItemIndex > -1) Then Begin
      With RpDev Do Begin
        DeviceIndex := LONGINT(PrintList.Items.Objects[PrintList.ItemIndex]);

        BinsList.Clear;

        If (Bins.Count > 0) Then
          For I := 0 To Pred (Bins.Count) Do Begin
            BinsList.Items.Add (Bins[I]);

            If (BinMode = -1) Then Begin
              If (DevMode.dmDefaultSource = LongInt(Bins.Objects[I])) Then
                BinsList.ItemIndex := I
            End { If }
            Else
              { Initial load }
              If (BinMode = LongInt(Bins.Objects[I])) Then
                BinsList.ItemIndex := I;
          End; { For }

        BinMode := -1;

        If (BinsList.Items.Count > 0) And (BinsList.ItemIndex = -1) Then
          BinsList.ItemIndex := 0;

        PapersList.Clear;

        If (Papers.Count > 0) Then
          For I := 0 To Pred (Papers.Count) Do Begin
            PapersList.Items.Add (Papers[I]);

            If (PaperMode = -1) Then Begin
              If (DevMode.dmPaperSize = LongInt(Papers.Objects[I])) Then
                PapersList.ItemIndex := I
            End { If }
            Else
              { Initial load }
              If (PaperMode = LongInt(Papers.Objects[I])) Then
                PapersList.ItemIndex := I;
          End; { For }

        PaperMode := -1;

        If (PapersList.Items.Count > 0) And (PapersList.ItemIndex = -1) Then
          PapersList.ItemIndex := 0;
      End; { With }
    End { If }
    Else Begin
      BinsList.Clear;
      PapersList.Clear;
    End; { Else }
end;

Procedure TForm_PageOptions.PaintLabel(Sender: TObject);
Var
  TempInt,
  TopOfs, LeftOfs,
  scLblW, scLblH,
  vImTop, hImLeft,
  ScaleHeight, ScaleWidth,
  ScaleTopMarg, ScaleBottomMarg,
  ScaleLeftMarg, ScaleRightMarg : LongInt;
  PageScale, PageScaleH         : Double;
  I, J                          : Byte;

  Function ToScale (Num, Add : LongInt) : LongInt;
  Begin
    Result := Trunc((Num / PageScale) + Add);
  End;

begin
  If Self.Visible And Assigned (Image_Paper) Then
    With Image_Label.Canvas do Begin
      { Calculate a Page Scale to map the page onto the image }
      {PageScale := Trunc (HeaderRec.fhPaperHeight / (Image_Label.Height * 0.9)) + 1;}
//      PageScale := HeaderRec.fhPaperHeight / (Image_Label.Height * 0.9);


      // MH 08/11/06: Modified to check on horizontal scaling as well otherwise it
      // goes off the side on certain combinations of size
      If BorRadio_Landscape.Checked Then
      Begin
        // For Landscape switch them around for the check
        PageScale := HeaderRec.fhPaperHeight / (Image_Label.Width * 0.80);
        PageScaleH := HeaderRec.fhPaperWidth / (Image_Label.Height * 0.80);
      End // If BorRadio_Landscape.Checked
      Else
      Begin
        // Portrait
        PageScale := HeaderRec.fhPaperHeight / (Image_Label.Height * 0.80);
        PageScaleH := HeaderRec.fhPaperWidth / (Image_Label.Width * 0.80);
      End; // Else
      If (PageScale < PageScaleH) Then PageScale := PageScaleH;

      { Calculate the scale sizes }
      ScaleHeight := Round((HeaderRec.fhPaperHeight / PageScale) + 2); { + 1 for each border }
      ScaleWidth := Round((HeaderRec.fhPaperWidth / PageScale) + 2); { + 1 for each border }

      { Fill Background }
      Pen.Color := clBtnFace;
      Brush.Color := clBtnFace;
      FillRect (ClientRect);

      vImTop  := (Image_Label.Height - ScaleHeight) Div 2;
      hImLeft := (Image_Label.Width - ScaleWidth) Div 2;

      { Draw Shadow }
      Pen.Color := clBtnShadow;
      Brush.Color := clBtnShadow;
      Rectangle (hImLeft + 5,
                 vImTop + 5,
                 (hImLeft  + ScaleWidth) + 5,
                 (vImTop + ScaleHeight) + 5);

      { Draw Page }
      Pen.Color := clBlack;
      Brush.Color := clWhite;
      Rectangle (hImLeft,
                 vImTop,
                 (hImLeft  + ScaleWidth),
                 (vImTop + ScaleHeight));

      { Draw Labels }
      Pen.Color := clRed;
      Brush.Color := clWhite;
      scLblW := ToScale (HeaderRec.fhLblWidth, 0); { + 1 for each border }
      scLblH := ToScale (HeaderRec.fhLblHeight, 0); { + 1 for each border }
      If (HeaderRec.fhOrientation = fdoPortrait) Then Begin
        TopOfs := vImTop + ToScale(HeaderRec.fhLblTop, 0);
        For I := 1 To HeaderRec.fhLblRows Do Begin
          LeftOfs := hImLeft + ToScale(HeaderRec.fhLblLeft, 0);

          For J := 1 to HeaderRec.fhLblCols Do Begin
            { Draw Label }
            Rectangle (LeftOfs,
                       TopOfs,
                       LeftOfs + scLblW,
                       TopOfs + scLblH);
            Pen.Color := clSilver;

            LeftOfs := LeftOfs + scLblW + ToScale(HeaderRec.fhLblColGap, 0);
          End; { For }

          TopOfs := TopOfs + scLblH + ToScale(HeaderRec.fhLblRowGap, 0);
        End; { For }
      End { If }
      Else Begin
        { Landscape }
        TopOfs := vImTop + ScaleHeight - ToScale(HeaderRec.fhLblLeft, 0);
        For I := 1 To HeaderRec.fhLblCols Do Begin
          LeftOfs := hImLeft + ToScale(HeaderRec.fhLblTop, 0);

          For J := 1 to HeaderRec.fhLblRows Do Begin
            { Draw Label }
            Rectangle (LeftOfs,
                       TopOfs,
                       LeftOfs + scLblH,
                       TopOfs - scLblW);
            Pen.Color := clSilver;

            LeftOfs := LeftOfs + scLblH + ToScale(HeaderRec.fhLblRowGap, 0);
          End; { For }

          TopOfs := TopOfs - scLblW - ToScale(HeaderRec.fhLblColGap, 0);
        End; { For }
      End; { Else }
    End; { With }
end;

procedure TForm_PageOptions.PageControl1Change(Sender: TObject);
begin
  If (PageControl1.ActivePage = TabSh_Label) Then
    PaintLabel(Self);

  If (PageControl1.ActivePage = TabSh_Size) Then
    PaintPage(Self);
end;

procedure TForm_PageOptions.lblTopExit(Sender: TObject);
begin
  With HeaderRec Do Begin
    If (lblTop.Value >= 0) And (lblTop.Value < fhPaperHeight) Then Begin
      fhLblTop := Round(lblTop.Value);
      ValLabelSize;
    End { If }
    Else
      If lblTop.CanFocus Then Begin
        lblTop.Value := fhLblTop;
        If lblTop.CanFocus Then lblTop.SetFocus;
        ErrMsg ('The Top Gap must be between 0 and the Paper Height specified.');
      End; { Else }
  End; { With }

  PaintLabel(Self);
end;

procedure TForm_PageOptions.lblLeftExit(Sender: TObject);
begin
  With HeaderRec Do Begin
    If (lblLeft.Value >= 0) And (lblLeft.Value < fhPaperWidth) Then Begin
      fhLblLeft := Round(lblLeft.Value);
      ValLabelSize;
    End { If }
    Else
      If lblLeft.CanFocus Then Begin
        lblLeft.Value := fhLblLeft;
        If lblLeft.CanFocus Then lblLeft.SetFocus;
        ErrMsg ('The Left Gap must be between 0 and the Paper Width specified.');
      End; { Else }
  End; { With }

  PaintLabel(Self);
end;

procedure TForm_PageOptions.lblHeightExit(Sender: TObject);
begin
  With HeaderRec Do Begin
    If (lblHeight.Value >= 0) And (lblHeight.Value < fhPaperHeight) Then Begin
      fhLblHeight := Round(lblHeight.Value);
      ValLabelSize;
    End { If }
    Else
      If lblHeight.CanFocus Then Begin
        lblHeight.Value := fhLblHeight;
        If lblHeight.CanFocus Then lblHeight.SetFocus;
        ErrMsg ('The Label Height must be between 1 and the Paper Height specified.');
      End; { Else }
  End; { With }

  PaintLabel(Self);
end;

procedure TForm_PageOptions.LblWidthExit(Sender: TObject);
begin
  With HeaderRec Do Begin
    If (lblWidth.Value >= 0) And (lblWidth.Value < fhPaperWidth) Then Begin
      fhLblWidth := Round(lblWidth.Value);
      ValLabelSize;
    End { If }
    Else
      If lblWidth.CanFocus Then Begin
        lblWidth.Value := fhLblWidth;
        If lblWidth.CanFocus Then lblWidth.SetFocus;
        ErrMsg ('The Width must be between 0 and the Paper Height specified.');
      End; { Else }
  End; { With }

  PaintLabel(Self);
end;

procedure TForm_PageOptions.LblColsExit(Sender: TObject);
begin
  With HeaderRec Do Begin
    If (lblCols.Value >= 1) And (lblCols.Value < 255) Then Begin
      fhLblCols := Round(lblCols.Value);
      ValLabelSize;
    End { If }
    Else
      If lblCols.CanFocus Then Begin
        lblCols.Value := fhLblCols;
        If lblCols.CanFocus Then lblCols.SetFocus;
        ErrMsg ('The number of columns must be greater than 0.');
      End; { Else }
  End; { With }

  PaintLabel(Self);
end;

procedure TForm_PageOptions.lblColGapExit(Sender: TObject);
begin
  With HeaderRec Do Begin
    If (lblColGap.Value >= 0) And (lblColGap.Value < 255) Then Begin
      fhLblColGap := Round(lblColGap.Value);
      ValLabelSize;
    End { If }
    Else
      If lblColGap.CanFocus Then Begin
        lblColGap.Value := fhLblColGap;
        If lblColGap.CanFocus Then lblColGap.SetFocus;
        ErrMsg ('The inter column gap must be between 0mm and 255mm.');
      End; { Else }
  End; { With }

  PaintLabel(Self);
end;

procedure TForm_PageOptions.lblRowsExit(Sender: TObject);
begin
  With HeaderRec Do Begin
    If (lblRows.Value >= 1) And (lblRows.Value < 255) Then Begin
      fhLblRows := Round(lblRows.Value);
      ValLabelSize;
    End { If }
    Else
      If lblRows.CanFocus Then Begin
        lblRows.Value := fhLblRows;
        If lblRows.CanFocus Then lblRows.SetFocus;
        ErrMsg ('The number of rows must be greater than 0.');
      End; { Else }
  End; { With }

  PaintLabel(Self);
end;

procedure TForm_PageOptions.lblRowGapExit(Sender: TObject);
begin
  With HeaderRec Do Begin
    If (lblRowGap.Value >= 0) And (lblRowGap.Value < 255) Then Begin
      fhLblRowGap := Round(lblRowGap.Value);
      ValLabelSize;
    End { If }
    Else
      If lblRowGap.CanFocus Then Begin
        lblRowGap.Value := fhLblRowGap;
        If lblRowGap.CanFocus Then lblRowGap.SetFocus;
        ErrMsg ('The inter Row gap must be between 0mm and 255mm.');
      End; { Else }
  End; { With }

  PaintLabel(Self);
end;

procedure TForm_PageOptions.ValLabelSize;
Var
  TotH, TotW, Temp : LongInt;
  ErrStr           : ShortString;
Begin
  With HeaderRec Do Begin
    TotH := fhLblTop + (fhLblHeight * fhLblRows) + (fhLblRowGap * Pred(fhLblRows));
    TotW := fhLblLeft + (fhLblWidth * fhLblCols) + (fhLblColGap * Pred(fhLblCols));

    If (HeaderRec.fhOrientation = fdoLandscape) Then Begin
      { Swap for landscape }
      Temp := TotH;
      TotH := TotW;
      TotW := Temp;
    End; { If }

    ErrStr := '';

    If (TotH > fhPaperHeight) Then Begin
      If (Trim(ErrStr) <> '') Then ErrStr := ErrStr + #10#13;
      ErrStr := ErrStr + 'The total label height is greater than the paper height';
    End; { If }

    If (TotW > fhPaperWidth) Then Begin
      If (Trim(ErrStr) <> '') Then ErrStr := ErrStr + #10#13;
      ErrStr := ErrStr + 'The total label width is greater than the paper width';
    End; { If }

    If (Trim(ErrStr) <> '') Then
      MessageDlg (ErrStr, mtWarning, [mbOk], 0);
  End; { With }
End;

procedure TForm_PageOptions.PrintLblTestClick(Sender: TObject);
begin
  If RPDev.PrinterSetupDialog Then
    PrintLabelBorders (HeaderRec, RpDev.SBSSetupInfo);
end;

procedure TForm_PageOptions.List_PurposeClick(Sender: TObject);
begin
  If (List_Purpose.ItemIndex > -1) Then
    HeaderRec.fhPurpose := List_Purpose.ItemIndex;
end;

procedure TForm_PageOptions.chkSerialNoClick(Sender: TObject);
begin
  // Disable the sorting options if the Serial Number option is in use
  lstShowADJBOM.Enabled := (Not chkSerialNo.Checked) And (Not chkBatchNo.Checked) And (Not chkBins.Checked);
  If (Not lstShowADJBOM.Enabled) Then lstShowADJBOM.ItemIndex := 0;
  SBSBackGroup13.Font.Color := IfThen(lstShowADJBOM.Enabled, clBlack, clGray);
  Label839.Font.Color := SBSBackGroup13.Font.Color;

  lstSortTransLines.Enabled := lstShowADJBOM.Enabled;
  If (Not lstSortTransLines.Enabled) Then lstSortTransLines.ItemIndex := 0;
  Label841.Font.Color := SBSBackGroup13.Font.Color;
  Label842.Font.Color := SBSBackGroup13.Font.Color;

  chkUseBy.Enabled := Not lstShowADJBOM.Enabled;
  chkUseBy.Refresh;  // BUG: Force Repaint

  BCheck_ShowInSNo.Enabled := Not lstShowADJBOM.Enabled;
  BCheck_ShowInSNo.Refresh;  // BUG: Force Repaint

  chkStockPriOrder.Enabled := Not lstShowADJBOM.Enabled;
  chkStockPriOrder.Refresh;  // BUG: Force Repaint
end;

end.
