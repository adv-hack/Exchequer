unit TransactionForm;

{$ALIGN 1}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TCustom, Menus, ExtCtrls, SBSPanel, StdCtrls, TEditVal,
  AccelLbl, Buttons, BorBtns, bkgroup, Mask, ComCtrls,
  Enterprise01_TLB, EnterpriseBeta_TLB, ExchTypes,
  TransactionLineForm, uExDatasets, uComTKDataset, uMultiList, uDBMultiList;

type
  TVATControls = record
    RateEdt: Text8pt;
    GoodsEdt: TCurrencyEdit;
    VATEdt: TCurrencyEdit;
  end;
  TTransactionFrm = class(TForm)
    PageControl1: TPageControl;
    MainPage: TTabSheet;
    I1BtmPanel: TSBSPanel;
    Label813: Label8;
    I1CCLab: Label8;
    I1DepLab: Label8;
    I1LocnLab: Label8;
    Label819: Label8;
    I1VATTLab: Label8;
    Label821: Label8;
    CurrLab1: Label8;
    I1NomCodeF: Text8Pt;
    I1CCF: Text8Pt;
    I1DepF: Text8Pt;
    I1LocnF: Text8Pt;
    INetTotF: TCurrencyEdit;
    IVATTotF: TCurrencyEdit;
    IGTotF: TCurrencyEdit;
    AnalPage: TTabSheet;
    I2BtmPanel: TSBSPanel;
    I2StkDescLab: Label8;
    I2QtyLab: Label8;
    Label833: Label8;
    I1MargLab: Label8;
    I2StkDescF: Text8Pt;
    I2QtyF: TCurrencyEdit;
    QtyPPage: TTabSheet;
    I3SBox: TScrollBox;
    I3StkDPanel: TSBSPanel;
    I3HedPanel: TSBSPanel;
    I3StkDLab: TSBSPanel;
    I3QOrdLab: TSBSPanel;
    I3DelLab: TSBSPanel;
    I3QWOLab: TSBSPanel;
    I3QOSLab: TSBSPanel;
    I3QPKLab: TSBSPanel;
    I3QTWLab: TSBSPanel;
    I3QOrdPanel: TSBSPanel;
    I3QDelPanel: TSBSPanel;
    I3QWOPanel: TSBSPanel;
    I3QOSPanel: TSBSPanel;
    I3QPKPanel: TSBSPanel;
    I3QTWPanel: TSBSPanel;
    I3BtmPanel: TSBSPanel;
    I3StkCodeLab: Label8;
    I3CCLab: Label8;
    I3DepLab: Label8;
    I3LocnLab: Label8;
    Label826: Label8;
    I2VATTLab: Label8;
    Label828: Label8;
    I3StkCodeF: Text8Pt;
    I3CCF: Text8Pt;
    I3DepF: Text8Pt;
    I3LocnF: Text8Pt;
    JobPage: TTabSheet;
    I4BtmPanel: TSBSPanel;
    Label87: Label8;
    I3VATTLab: Label8;
    Label811: Label8;
    Label830: Label8;
    I4CCLab: Label8;
    I4DepLab: Label8;
    I4NomF: Text8Pt;
    I4CCF: Text8Pt;
    I4DepF: Text8Pt;
    FootPage: TTabSheet;
    SBSPanel58: TSBSBackGroup;
    I5LTLab1: TLabel;
    I5LTLab2: TLabel;
    I5LTLab3: TLabel;
    I5LTLab4: TLabel;
    SBSPanel55: TSBSBackGroup;
    Label5: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label20: TLabel;
    Label19: TLabel;
    Label18: TLabel;
    Label17: TLabel;
    SBSPanel53: TSBSPanel;
    Label834: Label8;
    I5VRateL: TLabel;
    SBSPanel54: TSBSPanel;
    I5VATRLab: TLabel;
    Label8: TLabel;
    I5VATLab: TLabel;
    CISPanel1: TSBSPanel;
    CISBackGroup1: TSBSBackGroup;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    I5CISTaxF: TCurrencyEdit;
    I5CISManCb: TBorCheck;
    I5CISDecF: TCurrencyEdit;
    I5CISPeriodF: TEditDate;
    I5CISGrossF: TCurrencyEdit;
    SBSPanel5: TSBSPanel;
    ClsI5Btn: TButton;
    ScrollBox8: TScrollBox;
    I5VR1F: Text8Pt;
    I5VR2F: Text8Pt;
    I5VR3F: Text8Pt;
    I5VR4F: Text8Pt;
    I5VR5F: Text8Pt;
    I5VR6F: Text8Pt;
    I5VR7F: Text8Pt;
    I5VG1F: TCurrencyEdit;
    I5VG2F: TCurrencyEdit;
    I5VG3F: TCurrencyEdit;
    I5VG4F: TCurrencyEdit;
    I5VG5F: TCurrencyEdit;
    I5VG6F: TCurrencyEdit;
    I5VG7F: TCurrencyEdit;
    I5VV1F: TCurrencyEdit;
    I5VV2F: TCurrencyEdit;
    I5VV3F: TCurrencyEdit;
    I5VV4F: TCurrencyEdit;
    I5VV5F: TCurrencyEdit;
    I5VV6F: TCurrencyEdit;
    I5VV7F: TCurrencyEdit;
    I5VR8F: Text8Pt;
    I5VG8F: TCurrencyEdit;
    I5VV8F: TCurrencyEdit;
    I5Vr9F: Text8Pt;
    I5VG9F: TCurrencyEdit;
    I5VV9F: TCurrencyEdit;
    I5Vr10F: Text8Pt;
    I5VG10F: TCurrencyEdit;
    I5VV10F: TCurrencyEdit;
    I5Vr11F: Text8Pt;
    I5VG11F: TCurrencyEdit;
    I5VV11F: TCurrencyEdit;
    I5VR12F: Text8Pt;
    I5VG12F: TCurrencyEdit;
    I5VV12F: TCurrencyEdit;
    I5Vr13F: Text8Pt;
    I5VG13F: TCurrencyEdit;
    I5VV13F: TCurrencyEdit;
    I5Vr14F: Text8Pt;
    I5VG14F: TCurrencyEdit;
    I5VV14F: TCurrencyEdit;
    I5Vr15F: Text8Pt;
    I5VG15F: TCurrencyEdit;
    I5VV15F: TCurrencyEdit;
    I5VV16F: TCurrencyEdit;
    I5VG16F: TCurrencyEdit;
    I5Vr16F: Text8Pt;
    I5Vr17F: Text8Pt;
    I5VG17F: TCurrencyEdit;
    I5VV17F: TCurrencyEdit;
    I5VV18F: TCurrencyEdit;
    I5VG18F: TCurrencyEdit;
    I5Vr18F: Text8Pt;
    I5Vr19F: Text8Pt;
    I5VG19F: TCurrencyEdit;
    I5VV19F: TCurrencyEdit;
    I5Vr20F: Text8Pt;
    I5VG20F: TCurrencyEdit;
    I5VV20F: TCurrencyEdit;
    I5Vr21F: Text8Pt;
    I5VG21F: TCurrencyEdit;
    I5VV21F: TCurrencyEdit;
    I5MVATF: TBorCheck;
    I5LT1F: TCurrencyEdit;
    I5SDPF: TCurrencyEdit;
    I5SDDF: TCurrencyEdit;
    I5SDTF: TBorCheck;
    I5Net1F: TCurrencyEdit;
    I5VAT1F: TCurrencyEdit;
    I5Disc1F: TCurrencyEdit;
    I5Tot1F: TCurrencyEdit;
    I5Net2F: TCurrencyEdit;
    I5VAT2F: TCurrencyEdit;
    I5Disc2F: TCurrencyEdit;
    I5Tot2F: TCurrencyEdit;
    I5LT2F: TCurrencyEdit;
    I5LT3F: TCurrencyEdit;
    I5LT4F: TCurrencyEdit;
    SBSPanel62: TSBSPanel;
    Label13: TLabel;
    SBSPanel63: TSBSPanel;
    Label21: TLabel;
    DMDCNomF: Text8Pt;
    I5VRateF: TCurrencyEdit;
    PayPage: TTabSheet;
    RCSBox: TScrollBox;
    RcHedPanel: TSBSPanel;
    RcNLab: TSBSPanel;
    RcBLab: TSBSPanel;
    RcDLab: TSBSPanel;
    RcPLab: TSBSPanel;
    RcQLab: TSBSPanel;
    RcRLab: TSBSPanel;
    RcPPanel: TSBSPanel;
    RcNPanel: TSBSPanel;
    RCDPanel: TSBSPanel;
    RcBPanel: TSBSPanel;
    RcQPanel: TSBSPanel;
    RcRPanel: TSBSPanel;
    RcListBtnPanel: TSBSPanel;
    I6BtmPanel: TSBSPanel;
    Label83: Label8;
    Label85: Label8;
    Label86: Label8;
    I1BtnPanel: TSBSPanel;
    I1StatLab: Label8;
    I1BSBox: TScrollBox;
    btnViewLine: TButton;
    ClsI1Btn: TButton;
    I1FPanel: TSBSPanel;
    Label84: Label8;
    I1CurrLab: Label8;
    lblAcCode: Label8;
    I1ExLab: Label8;
    Label88: Label8;
    Label817: Label8;
    I1DelBtn: TSpeedButton;
    I1DueDateL: Label8;
    SBSAccelLabel1: TSBSAccelLabel;
    I1OurRefF: Text8Pt;
    I1OpoF: Text8Pt;
    I1AccF: Text8Pt;
    I1TransDateF: TEditDate;
    I1DueDateF: TEditDate;
    I1EXRateF: TCurrencyEdit;
    I1PrYrF: TEditPeriod;
    I1CurrF: TSBSComboBox;
    I1DumPanel: TSBSPanel;
    FixXRF: TBorCheck;
    TransExtForm1: TSBSExtendedForm;
    I4JobCodeL: Label8;
    I4JAnalL: Label8;
    I1YrRefL: Label8;
    I1YrRef2L: Label8;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    Label822: Label8;
    Label823: Label8;
    Label824: Label8;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    I5NBL: Label8;
    bevBelowOverrideLocation: TBevel;
    lblOverrideLocation: Label8;
    UDF5L: Label8;
    UDF7L: Label8;
    UDF9L: Label8;
    UDF6L: Label8;
    UDF8L: Label8;
    UDF10L: Label8;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    ISDelF: Text8Pt;
    ISTTF: TCurrencyEdit;
    ISMTF: TCurrencyEdit;
    ISPTF: TSBSComboBox;
    I1YrRefF: Text8Pt;
    I1YrRef2F: Text8Pt;
    I4JobCodeF: Text8Pt;
    I4JobAnalF: Text8Pt;
    I5NBF: TCurrencyEdit;
    edtOverrideLocation: Text8Pt;
    THUD5F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD10F: Text8Pt;
    TransLineList: TDBMultiList;
    TransLineDataset: TComTKDataset;
    AnalysisList: TDBMultiList;
    I1GPLab: Label8;
    JobViewList: TDBMultiList;
    I1AddrF: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure ClsI1BtnClick(Sender: TObject);
    procedure btnViewLineClick(Sender: TObject);
    procedure DatasetGetFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure TransLineListRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure TransLineListChangeSelection(Sender: TObject);
  private
    { Private declarations }
    IdLine      : TTransactionLineFrm; // Standard transaction Line form
    oTransaction: ITransaction9;
    oAccount   : IAccount;
    FUserName:    WideString;

    GotCoord    : Boolean;
    InitSize    : TPoint;
    LastCoord   : Boolean;
    ListOfSet   : Integer;
    NeedCUpdate : Boolean;
    PagePoint   : Array[0..6] of TPoint;
    ReCalcTot   : Boolean;
    SetDefault  : Boolean;
    StartSize   : TPoint;
    StoreCoord  : Boolean;

    DayBkListMode: Integer;

    FDataPath:    WideString;
    FToolkit:     IToolkit2;
    FToolkitOpen: boolean;
    FVATControlList: array of TVATControls;

    function  OpenCOMToolkit: boolean;
    procedure CustToMemo(var Target: TMemo);
    procedure HideUnusedVATRates;
    procedure SetUDFields(UDDocHed  :  TDocTypes);

    // CJS 2013-11-29 - MRD1.1.46 - Amendments for Consumers
    procedure ResizeAcCodeField(ForConsumer: Boolean);

    procedure BuildDesign;
    procedure ChangeList (PageNo : Byte; ShowLines : Boolean);
    Function  Current_Page : Integer;
    procedure Display_Id;
    procedure FormBuildList (ShowLines : Boolean);
    procedure FormDesign;
    procedure FormSetOfSet;
    procedure HidePanels (PageNo : Byte);
    function OutLine(PageNo: Byte; Col: Byte): ShortString;
    Procedure OutInvFooterTot;
    Procedure OutInvTotals (Const NewIndex : Integer);
    procedure ReFreshFooter;
    procedure SetInvFields;
    Procedure SetInvTotPanels (Const NewIndex : Integer);
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;
  public
    { Public declarations }
    procedure DisplayTrans (DataPath: WideString; OurRef: WideString);
    property DataPath: WideString read FDataPath write FDataPath;
  end;

procedure ShowTransactionForm(DataPath: WideString; OurRef: WideString);

var
  TransactionFrm: TTransactionFrm;

implementation

{$R *.dfm}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  CTKUtil,
  CustomFieldFuncs;

// =============================================================================

function GetOriginatorHint(Originator, CreationDate, CreationTime: string): string;
var
  Hour, Minute: string;
begin
  Hour := Copy(CreationTime, 1, 2);
  Minute := Copy(CreationTime, 3, 2);
  Result := 'Added by ' + Trim(Originator) + ' on ' +
            POutDate(CreationDate) + ' at ' +
            Hour + ':' + Minute;
end;

// =============================================================================

procedure ShowTransactionForm(DataPath: WideString; OurRef: WideString);
begin
  if not Assigned(TransactionFrm) then
    TransactionFrm := TTransactionFrm.Create(Application);
  try
    TransactionFrm.DisplayTrans(DataPath, OurRef);
    TransactionFrm.Show;
  except
    TransactionFrm.Free;
  end;
end;

// =============================================================================

Function FullNomKey(ncode  :  Longint)  :  Str20;
var
  TmpStr: string[20];
Begin
  FillChar(TmpStr, Sizeof(TmpStr), 0);
  Move(ncode, TmpStr[1], Sizeof(ncode));
  TmpStr[0] := Chr(Sizeof(ncode));
  Result := TmpStr;
end;

// =============================================================================

procedure TTransactionFrm.HideUnusedVATRates;
var
  n: Integer;
  Gap: Integer;
  Pos: Integer;
begin
  Gap := FVATControlList[1].RateEdt.Top - FVATControlList[0].RateEdt.Top;
  Pos := FVATControlList[0].RateEdt.Top;

  for n := Low(VATCodeList) to High(VATCodeList) do
  begin
    FVATControlList[n - 1].RateEdt.Visible  := False;
    FVATControlList[n - 1].VATEdt.Visible   := False;
    FVATControlList[n - 1].GoodsEdt.Visible := False;
  end;

  for n := Low(VATCodeList) to High(VATCodeList) do
  begin
    if (oTransaction.thGoodsAnalysis[VATCodeList[n]] > 0) or
       (oTransaction.thVATAnalysis[VATCodeList[n]] > 0) then
    begin
      FVATControlList[n - 1].RateEdt.Top  := Pos;
      FVATControlList[n - 1].VATEdt.Top   := Pos;
      FVATControlList[n - 1].GoodsEdt.Top := Pos;
      Pos := Pos + Gap;

      FVATControlList[n - 1].RateEdt.Visible  := True;
      FVATControlList[n - 1].VATEdt.Visible   := True;
      FVATControlList[n - 1].GoodsEdt.Visible := True;
      FVATControlList[n - 1].RateEdt.Text     := FToolkit.SystemSetup.ssVATRates[VATCodeList[n]].svDesc;
      FVATControlList[n - 1].GoodsEdt.Value   := oTransaction.thGoodsAnalysis[VATCodeList[n]];
      FVATControlList[n - 1].VATEdt.Value     := oTransaction.thVATAnalysis[VATCodeList[n]];
    end;
  end;

end;

// -----------------------------------------------------------------------------

function TTransactionFrm.OutLine(PageNo: Byte; Col: Byte): ShortString;
var
  GenStr: ShortString;
  HasQty: Boolean;
  oDetails: ITransactionLine5;

  function FormatBFloat(Fmask: ShortString; Value: Double; HasQty: Boolean): ShortString;
  begin
    if (Value <> 0.0) or (HasQty) then
      Result := FormatFloat(Fmask, Value)
    else
      Result := '';
  end;

  function FormatBChar(C: Char; HasQty: Boolean): ShortString; overload;
  begin
    If (Ord(C) > 32) and (HasQty) then
      Result := C
    else
      Result := '';
  end;

  function FormatBChar(S: ShortString; HasQty: Boolean): ShortString; overload;
  begin
    If (S <> '') and (HasQty) then
      Result := S
    else
      Result := '';
  end;

  function FormatQty: ShortString;
  var
    Qty: Double;
    QtyMul: Double;
    UsePack: Boolean;
    GenQtyMask: string;
  begin
    GenQtyMask := FormatDecStrSD(FToolkit.SystemSetup.ssQtyDecimals, GenRealMask, False);
    Qty        := oDetails.tlQty;
    QtyMul     := oDetails.tlQtyMul;
    if (oDetails.tlStockCodeI <> nil) then
      UsePack  := oDetails.tlStockCodeI.stShowQtyAsPacks
    else
      UsePack  := False;
    Result := FormatBFloat(GenQtyMask, CaseQty(FToolkit, Calc_IdQty(Qty, QtyMul, UsePack)),True)
  end;

  function FormatLineTotal(HasQty: Boolean): ShortString;
  var
    Total: Double;
  begin
    Total := oDetails.entLineTotal(FToolkit.SystemSetup.ssShowInvoiceDisc, oDetails.tlDiscount);
    Result := FormatBFloat(GenRealMask, Total, HasQty);
  end;

  function FormatVAT(HasQty: Boolean): ShortString;
  var
    VATCode: Char;
    IncVATCode: Char;
  begin
    IncVATCode := ExtractChar(oDetails.tlInclusiveVATCode, ' ');
    VATCode    := ExtractChar(oDetails.tlVATCode, ' ');
    if (IncVATCode in VATSet) and (VATCode in VATEqStd) then
      GenStr := VATCode + IncVATCode
    else
      GenStr := VATCode;
    Result := FormatBChar(GenStr, HasQty);
  end;

  function FormatUnitPrice(HasQty: Boolean): ShortString;
  var
    GenUnitMask: array[False..True] of ShortString;  {True=Sales, False=Purch}
    Mask: ShortString;
    Value: Double;
    DecPlaces: Integer;
  begin
    DecPlaces := FToolkit.SystemSetup.ssSalesDecimals;
    GenUnitMask[True]  := FormatDecStrSD(DecPlaces, GenRealMask, False);

    DecPlaces := FToolkit.SystemSetup.ssCostDecimals;
    GenUnitMask[False] := FormatDecStrSD(DecPlaces, GenRealMask, False);

    Mask  := GenUnitMask[oDetails.tlDocType in SalesSplit];
    Value := oDetails.tlNetValue;
    Result := FormatBFloat(Mask, Value, HasQty);
  end;

  function FormatDiscount: ShortString;
  var
    Discount1, Discount2, Discount3: Double;
    Discount1Chr, Discount2Chr, Discount3Chr: Char;
  begin
    Discount1 := oDetails.tlDiscount;
    Discount1Chr := ExtractChar(oDetails.tlDiscFlag, ' ');

    if FToolkit.Enterprise.enModuleVersion = enModSPOP then
    begin
      Discount2 := oDetails.tlMultiBuyDiscount;
      Discount2Chr := ExtractChar(oDetails.tlMultiBuyDiscountFlag, ' ');

      Discount3 := oDetails.tlTransValueDiscount;
      Discount3Chr := ExtractChar(oDetails.tlTransValueDiscountFlag, ' ');

      Result:= PPR_PamountStr(Discount1, Discount1Chr)  + '/' +
               PPR_PamountStr(Discount2, Discount2Chr) + '/' +
               PPR_PamountStr(Discount3, Discount3Chr);

      if Result = '//' then
        Result := '';
    end
    else
      Result := PPR_PamountStr(Discount1, Discount1Chr);
  end;

  function CalcNetValue: Double;
  var
    Discount: Double;
  begin
    Discount := oTransaction.thSettleDiscAmount * Ord(oTransaction.thSettleDiscTaken);
    Result   := oDetails.entLineTotal(FToolkit.SystemSetup.ssShowInvoiceDisc, Discount);
  end;

  function FormatNetValue(HasQty: Boolean): ShortString;
  begin
    Result := FormatBFloat(GenRealMask, CalcNetValue, HasQty);
  end;

  function CalcLineCost: Double;
  var
    Rnum: Double;
    LineQty: Double;
    CostPrice: Double;
    UsePack: Boolean;
  begin
    if (oDetails.tlStockCodeI <> nil) then
      UsePack  := oDetails.tlStockCodeI.stShowQtyAsPacks
    else
      UsePack  := False;
    LineQty := Calc_IdQty(oDetails.tlQty, oDetails.tlQtyMul, UsePack);
    CostPrice := oDetails.tlCost;
    Result := Round_Up(Round_Up(LineQty,   FToolkit.SystemSetup.ssQtyDecimals) *
                       Round_Up(CostPrice, FToolkit.SystemSetup.ssCostDecimals), 2);
  end;

  function FormatLineCost(HasQty: Boolean): ShortString;
  begin
    Result := FormatBFloat(GenRealMask, CalcLineCost, HasQty);
  end;

begin { OutLine }
  Result := '';
  oDetails := FToolkit.TransactionDetails as ITransactionLine5;
  HasQty := oDetails.tlQty <> 0.0;
  case PageNo of
    0:  case Col of
           0: Result := oDetails.tlStockCode;
           1: Result := oDetails.tlItemNo;
           2: Result := FormatQty;
           3: Result := oDetails.tlDescr;
           4: Result := FormatLineTotal(HasQty);
           5: Result := FormatVAT(HasQty);
           6: Result := FormatUnitPrice(HasQty);
           7: Result := FormatDiscount;
        else
          Result := '';
        end;
    1:  case Col of
           0: Result := oDetails.tlStockCode;
           1: Result := oDetails.tlLocation;              // MLocStk
           2: Result := POutDate(oDetails.tlLineDate);    // PDate
           3: Result := Form_BInt(oDetails.tlGLCode, 0);  // NomCode
           4: Result := oDetails.tlCostCentre;            // CCDep[True];
           5: Result := oDetails.tlDepartment;            // CCDep[False]
           6: Result := FormatBFloat(GenRealMask, CalcNetValue, HasQty);
           7: Result := FormatBFloat(GenRealMask, CalcLineCost, HasQty);
           8: Result := FormatBFloat(GenRealMask, CalcNetValue - CalcLineCost, HasQty);
           9: Result := FormatBFloat(GenPcntMask, Calc_Pcnt(CalcNetValue, (CalcNetValue - CalcLineCost)), HasQty);
         end; {Case..}
    3:  case Col of
           0: Result := oDetails.tlStockCode;
           1: Result := oDetails.tlDescr;
           2: Result := oDetails.tlJobCode;
           3: Result := oDetails.tlAnalysisCode;
           4: Result := FormatLineTotal(HasQty);
         end; {Case..}
  end;
end; { OutLine }

// -----------------------------------------------------------------------------

procedure TTransactionFrm.FormCreate(Sender: TObject);
Var
  n : Integer;
begin
  // Always display main tab first
  PageControl1.ActivePage := MainPage;

  // Initialise scroll-bar positions
  For N := 0 To Pred(ComponentCount) Do
    If (Components[n] is TScrollBox) Then
      With TScrollBox(Components[N]) Do Begin
        VertScrollBar.Position := 0;
        HorzScrollBar.Position := 0;
      End; { With TScrollBox(Components[n]) }
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  // Initialise Form Sizes
  InitSize.Y := 355;
  InitSize.X := 638;
  Self.ClientHeight := InitSize.Y;
  Self.ClientWidth  := InitSize.X;
  Constraints.MinHeight := InitSize.Y - 1;
  Constraints.MinWidth  := InitSize.X - 1;

  // Setup misc internal variables
  LastCoord   := False;
  NeedCUpdate := False;
  ReCalcTot   := True;
  SetDefault  := False;
  StoreCoord  := False;
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FToolkit := nil;
  if Assigned(IdLine) then
    IdLine.Free;
  TransactionFrm := nil;
  Action:=caFree;
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.FormResize(Sender: TObject);
Var
  n       : Byte;
  NewVal  : Integer;
begin
  If GotCoord {and (Not fDoingClose)} Then
  Begin
    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    NewVal:=ClientWidth-PagePoint[0].X;
    PageControl1.Width:=NewVal;

    NewVal:=ClientHeight-PagePoint[0].Y;
    PageControl1.Height:=NewVal;

    TransLineList.Width:=PageControl1.Width-PagePoint[1].X;
    TransLineList.Height:=PageControl1.Height-PagePoint[1].Y;

    I1FPanel.Width:=PageControl1.Width-5;

    AnalysisList.Width:=TransLineList.Width;
    AnalysisList.Height:=TransLineList.Height;

    JobViewList.Width := TransLineList.Width;
    JobViewList.Height := TransLineList.Height;

    I1BtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    I1BtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    I1BSBox.Height:=I1BtnPanel.Height-PagePoint[3].X;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end;
end;

// -----------------------------------------------------------------------------

function TTransactionFrm.OpenCOMToolkit: boolean;
begin
  FToolkit := OpenToolkit(FDataPath, true) as IToolkit2; // use backdoor
  Result := Assigned(FToolkit);
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.DisplayTrans(DataPath: WideString; OurRef: WideString);
var
  res: integer;
begin
  FDataPath := DataPath;
  if not OpenCOMToolkit then exit;
  with FToolkit, Transaction do
  begin
    Index := thIdxOurRef;
    res := GetEqual(BuildOurRefIndex(OurRef));
    if res <> 0 then
    begin
      ShowMessage(format('The transaction with OurRef %s was not found', [OurRef]));
      Exit;
    end;
  end;
  oTransaction := (FToolkit.Transaction) as ITransaction9;
  if (oTransaction.thAcCodeI = nil) then
  begin
    ShowMessage(format('The Customer/Supplier could not be found for Transaction %s', [OurRef]));
    Exit;
  end
  else
    oAccount := oTransaction.thAcCodeI;

  FormDesign;
  FormBuildList (False);

  // Update Form Caption
  Caption := CTKUtil.CompanyCodeFromPath(FToolkit, FToolkit.Configuration.DataDirectory) + ', ' +
             oTransaction.thOurRef;

  // Update form layout for licencing and document type
  BuildDesign;

  // Update user defined field captions and availability
  SetUDFields(oTransaction.thDocType);

  // Display Invoice
  SetInvFields;

  // Display Invoice Footer Totals
  OutInvTotals(Current_Page);

  if (Current_Page = 4) then
    // Display VAT/Discount details
    RefreshFooter
  else
  begin
    ChangeList (Current_Page, False);
  end;
end;

// -----------------------------------------------------------------------------

// CJS 2013-11-27 - MRD1.1.17 - Consumer Support
procedure TTransactionFrm.ResizeAcCodeField(ForConsumer: Boolean);
begin
  if (FToolkit.SystemSetup as ISystemSetup9).ssConsumersEnabled and ForConsumer then
  begin
    lblAcCode.Left := 4;
    I1AccF.Left := 25;
    I1AccF.Width := 263;
    I1AddrF.Top := 33;
    I1AddrF.Height := 48;
  end
  else
  begin
    lblAcCode.Left := 184;
    I1AccF.Left := 208;
    I1AccF.Width := 80;
    I1AddrF.Top := 7;
    I1AddrF.Height := 74;
  end;
  // Force a re-positioning of the drop-down/pop-up arrows
  I1AccF.PosArrows;
end;

procedure TTransactionFrm.BuildDesign;
Var
  HideCC : Boolean;
  Show_CMG: Boolean;
begin
  I1StatLab.Caption := 'STATUS:'#13'View Only';

  TransLineDataset.ToolkitObject := FToolkit.TransactionDetails as IDatabaseFunctions;
  TransLineDataset.SearchKey := FullNomKey(oTransaction.thFolioNum);

  TransLineList.Active := True;
  AnalysisList.Active := True;
  JobViewList.Active := True;

  // Set Version Specific Info
  if (FToolkit.SystemSetup.ssReleaseCodes.rcMultiCurrency <> rcDisabled) then
  begin
    // Single-Currency
    I1CurrLab.Visible:=False;
    I1CurrF.Visible:=False;
    I1ExRateF.Visible:=False;
    I1ExLab.Visible:=False;
    I5VRateL.Visible:=False;
    I5VRateF.Visible:=False;
    FixXRF.Visible:=False;
  end;

  JobPage.TabVisible := FToolkit.SystemSetup.ssReleaseCodes.rcJobCosting <> rcDisabled;

  I4JobCodeF.Visible:=JobPage.TabVisible;
  I4JobCodeL.Visible:=JobPage.TabVisible;

  I4JAnalL.Visible:=JobPage.TabVisible;
  I4JobAnalF.Visible:=JobPage.TabVisible;
  Bevel3.Visible:=JobPage.TabVisible;

  if FToolkit.Enterprise.enModuleVersion = enModSPOP then
  begin
    // Override Location only available if enabled in System Setup and its a Purchase
    lblOverrideLocation.Visible := (FToolkit.SystemSetup as ISystemSetup8).ssEnableOverrideLocations
                                   and (oTransaction.thDocType In PurchSplit);
    edtOverrideLocation.Visible := lblOverrideLocation.Visible;
    bevBelowOverrideLocation.Visible := lblOverrideLocation.Visible;
  end;

  HideCC := not FToolkit.SystemSetup.ssUseCCDept;

  I1CCLab.Visible  := not HideCC;
  I1CCF.Visible    := not HideCC;
  I1DepLab.Visible := not HideCC;
  I1DepF.Visible   := not HideCC;

  I4CCLab.Visible  := not HideCC;
  I4CCF.Visible    := not HideCC;
  I4DepLab.Visible := not HideCC;
  I4DepF.Visible   := not HideCC;

  if not (FToolkit.Enterprise.enModuleVersion in [enModStock, enModSPOP]) Then
  begin
    I2StkDescLab.Visible := False;
    I2StkDescF.Visible   := False;
    I2QtyLab.Visible     := False;
    I2QtyF.Visible       := False;
  end;

  if not (FToolkit.Enterprise.enModuleVersion = enModSPOP) Then
  begin
    // Not SPOP
    I1LocnLab.Visible := False;
    I1LocnF.Visible   := False;
  end
  else
  begin
    // SPOP
    I1DueDateF.Visible := (not (oTransaction.thDocType In DeliverSet));
    I1DueDateL.Visible := I1DueDateF.Visible;
  end;

  if (FToolkit.SystemSetup.ssReleaseCodes.rcMultiCurrency <> rcDisabled) then
  begin
    FixXRF.Visible:=(oTransaction.thDocType In OrderSet) and
                    (FToolkit.SystemSetup.ssCurrencyRateType = rtDaily);
  end;

  if (oTransaction.thDocType in OrderSet) then
  begin
    I1DueDateL.Caption := 'Del';
    I5NBL.Visible      := True;
    I5NBF.Visible      := True;
  end
  else
  begin
    I1DueDateL.Caption := 'Due';
    I5NBL.Visible      := False;
    I5NBF.Visible      := False;
  end;

  // CJS 2013-11-29 - MRD1.1.46 - Amendments for Consumers
  ResizeAcCodeField(oTransaction.thDocType in SalesSplit);

  if (oTransaction.thDocType in PurchSplit) then
    AnalysisList.Columns[8].Caption := 'Uplift'
  else
    AnalysisList.Columns[8].Caption := 'Cost';

  Show_CMG := ((oTransaction.thDocType In SalesSplit) and
               (FToolkit.Functions.entCheckSecurity(FUserName, 143) = 0));

  I1MargLab.Visible := Show_CMG;
  I1GPLab.Visible   := Show_CMG;

end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.FormDesign;

  procedure AddVATControls(RateEdt: Text8pt; GoodsEdt: TCurrencyEdit; VATEdt: TCurrencyEdit);
  var
    Entry: Integer;
  begin
    Entry := Length(FVATControlList);
    SetLength(FVATControlList, Entry + 1);
    FVATControlList[Entry].RateEdt  := RateEdt;
    FVATControlList[Entry].GoodsEdt := GoodsEdt;
    FVATControlList[Entry].VATEdt   := VATEdt;
  end;

begin
  QtyPPage.TabVisible := False;
  PayPage.TabVisible  := False;

  I2QtyF.DecPlaces := FToolkit.SystemSetup.ssQtyDecimals;

  I5LTLab1.Caption  := FToolkit.SystemSetup.ssUserFields.ufLineType1;
  I5LTLab2.Caption  := FToolkit.SystemSetup.ssUserFields.ufLineType2;
  I5LTLab3.Caption  := FToolkit.SystemSetup.ssUserFields.ufLineType3;
  I5LTLab4.Caption  := FToolkit.SystemSetup.ssUserFields.ufLineType4;
  I1VATTLab.Caption := FToolkit.SystemSetup.ssTaxWord + I1VATTLab.Caption;
  I3VATTLab.Caption := FToolkit.SystemSetup.ssTaxWord + I3VATTLab.Caption;
  I5MVATF.Caption   := FToolkit.SystemSetup.ssTaxWord + I5MVATF.Caption;
  I5VATRLab.Caption := FToolkit.SystemSetup.ssTaxWord + I5VATRLab.Caption;
  I5VATLab.Caption  := FToolkit.SystemSetup.ssTaxWord;
  Label14.Caption   := FToolkit.SystemSetup.ssTaxWord;
  Label18.Caption   := FToolkit.SystemSetup.ssTaxWord;
  I5VRateL.Caption  := FToolkit.SystemSetup.ssTaxWord + I5VRateL.Caption;

  if (FToolkit.SystemSetup.ssReleaseCodes as ISystemSetupReleaseCodes2).rcCISRCT = rcDisabled then
    CISPanel1.Visible := False;

  if FToolkit.SystemSetup.ssWarnDupliYourRef then
    I1YrRefF.Charcase := ecUpperCase;

  {* Build VAT Matrix *}
  AddVATControls( I5VR1F,  I5VG1F,  I5VV1F);
  AddVATControls( I5VR2F,  I5VG2F,  I5VV2F);
  AddVATControls( I5VR3F,  I5VG3F,  I5VV3F);
  AddVATControls( I5VR4F,  I5VG4F,  I5VV4F);
  AddVATControls( I5VR5F,  I5VG5F,  I5VV5F);
  AddVATControls( I5VR6F,  I5VG6F,  I5VV6F);
  AddVATControls( I5VR7F,  I5VG7F,  I5VV7F);
  AddVATControls( I5VR8F,  I5VG8F,  I5VV8F);
  AddVATControls( I5VR9F,  I5VG9F,  I5VV9F);
  AddVATControls(I5VR10F, I5VG10F, I5VV10F);
  AddVATControls(I5VR11F, I5VG11F, I5VV11F);
  AddVATControls(I5VR12F, I5VG12F, I5VV12F);
  AddVATControls(I5VR13F, I5VG13F, I5VV13F);
  AddVATControls(I5VR14F, I5VG14F, I5VV14F);
  AddVATControls(I5VR15F, I5VG15F, I5VV15F);
  AddVATControls(I5VR16F, I5VG16F, I5VV16F);
  AddVATControls(I5VR17F, I5VG17F, I5VV17F);
  AddVATControls(I5VR18F, I5VG18F, I5VV18F);
  AddVATControls(I5VR19F, I5VG19F, I5VV19F);
  AddVATControls(I5VR20F, I5VG20F, I5VV20F);
  AddVATControls(I5VR21F, I5VG21F, I5VV21F);

end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.FormBuildList (ShowLines : Boolean);
begin
  HidePanels(0);
  FormSetOfSet;
  FormReSize(Self);
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.CustToMemo(var Target: TMemo);
var
  n: Byte;
begin
  Target.Text := Trim(oAccount.acCompany);

  for n := 1 to 5 do
    If (Trim(oAccount.acAddress[n]) <> '') then
      Target.Text := Target.Text + #13#10 + Trim(oAccount.acAddress[n]);

  if (oAccount.acContact <> '') then
    Target.Text := Target.Text + #13#10 + 'Contact : ' + Trim(oAccount.acContact);

  if (oAccount.acPhone <> '') then
    Target.Text := Target.Text + #13#10 + 'Tel: '+Trim(oAccount.acPhone);

  if (oAccount.acPhone2 <> '') then
    Target.Text := Target.Text + #13#10 + 'Tel: '+Trim(oAccount.acPhone2);

  if (oAccount.acFax <> '') then
    Target.Text:=Target.Text + #13#10 + 'Fax: '+ Trim(oAccount.acFax);

end;

//-------------------------------------------------------------------------

// Display Invoice Record
procedure TTransactionFrm.SetInvFields;
var
  GenStr:  ShortString;
  n:  Byte;
  m:  Byte;
  Pr: Byte;
  Yr: Byte;
begin
  I1OurRefF.Text := oTransaction.thOurRef;
  I1OpoF.Text    := oTransaction.thOperator;

  if ((oAccount As IAccount7).acSubType = asConsumer) then
    I1AccF.Text := (oAccount As IAccount7).acLongACCode
  else
    I1AccF.Text := Strip('R', [#32], oTransaction.thAcCode);

  Pr := oTransaction.thPeriod;
  Yr := oTransaction.thYear;
  I1PrYrF.InitPeriod(Pr, Yr, True, True);

  I1TransDateF.DateValue := oTransaction.thTransDate;
  I1DueDateF.DateValue   := oTransaction.thDueDate;

  I1YrRefF.Text  := Trim(oTransaction.thYourRef);
  I1YrRef2F.Text := oTransaction.thLongYourRef;

  DMDCNomF.Text := Form_BInt(oTransaction.thControlGL, 0);

  if FToolkit.SystemSetup.ssCurrencyVersion in [enEuro, enGlobal] then
  begin
    if (oTransaction.thCurrency > 0) then
      I1CurrF.ItemIndex := Pred(oTransaction.thCurrency);
    I1ExRateF.Value := oTransaction.thDailyRate;
    I5VRateF.Value  := oTransaction.thVATDailyRate;
  end;

  CustToMemo(I1AddrF);

  if FToolkit.SystemSetup.ssReleaseCodes.rcJobCosting <> rcDisabled then
  begin
    // (JbCostOn) or (JbFieldOn)
    I4JobCodeF.Text := oTransaction.thJobCode;
    I4JobAnalF.Text := oTransaction.thAnalysisCode;
  end;

  if FToolkit.SystemSetup.ssUseIntrastat then
  begin
    ISDelF.Text     := Trim(oTransaction.thDeliveryTerms);
    ISTTF.Value     := oTransaction.thTransportNature;
    ISMTF.Value     := oTransaction.thTransportMode;
    ISPTF.ItemIndex := Ord(oTransaction.thProcess);
  end;

  I5NBF.Value := oTransaction.thNoLabels;

  THUD1F.Text  := oTransaction.thUserField1;
  THUD2F.Text  := oTransaction.thUserField2;
  THUD3F.Text  := oTransaction.thUserField3;
  THUD4F.Text  := oTransaction.thUserField4;
  THUd5F.Text  := oTransaction.thUserField5;
  THUd6F.Text  := oTransaction.thUserField6;
  THUd7F.Text  := oTransaction.thUserField7;
  THUd8F.Text  := oTransaction.thUserField8;
  THUd9F.Text  := oTransaction.thUserField9;
  THUd10F.Text := oTransaction.thUserField10;

  I5MVATF.Checked := oTransaction.thManualVAT;
  FixXRF.Checked  := oTransaction.thFixedRate;

  I5SDPF.Value   := oTransaction.thSettleDiscPerc * 100;
  I5SDDF.Value   := oTransaction.thSettleDiscDays;
  I5SDTF.Checked := oTransaction.thPostDiscTaken;

  if (oTransaction.thCurrency <> FToolkit.SystemSetup.ssVATReturnCurrency) and
     (not (FToolkit.SystemSetup.ssVATReturnCurrency in [0, 1])) then
  begin
    if (not I5VRateL.Visible) then
    begin
      I5VRateL.Visible := True;
      I5VRateF.Visible := True;

      ScrollBox8.Height := ScrollBox8.Height - 24;
      ScrollBox8.Top    := ScrollBox8.Top + 24;
      SBSPanel54.Top    := SBSPanel54.Top + 24;
    end;
  end
  else
  begin
    if (I5VRateL.Visible) then
    begin
      I5VRateL.Visible := False;
      I5VRateF.Visible := False;

      ScrollBox8.Height := ScrollBox8.Height+24;
      ScrollBox8.Top    := ScrollBox8.Top-24;
      SBSPanel54.Top    := SBSPanel54.Top-24;
    end;
  end;
end;

//-------------------------------------------------------------------------

procedure TTransactionFrm.OutInvTotals(const NewIndex : Integer);
begin
  if FToolkit.SystemSetup.ssCurrencyVersion in [enEuro, enGlobal] then
    // $IFDEF MC_On
    CurrLab1.Caption := CurrencySymbol(FToolkit, oTransaction.thCurrency);

  case NewIndex Of
    1: begin
         INetTotF.Value := oTransaction.thTotals[TransTotNetInCcy];
         IVATTotF.Value := INetTotF.Value - oTransaction.thTotalCost;
         IGTotF.Value   := Calc_Pcnt(INetTotF.Value, IVATTotF.Value);
       end;
  else
    begin
      IGTotF.Value   := oTransaction.thTotals[TransTotInCcy];
      IVATTotF.Value := oTransaction.thTotalVAT;

      if FToolkit.SystemSetup.ssShowInvoiceDisc then
        INetTotF.Value := IGTotF.Value - oTransaction.thTotalVAT
      else
        INetTotF.Value := oTransaction.thNetValue;
    end;
  end;
end;

// -----------------------------------------------------------------------------

// Display Invoice Footer Totals
Procedure TTransactionFrm.OutInvFooterTot;
var
  n: Integer;

  function TransactionTotal(withDiscount: Boolean): Real;
  begin
    Result := oTransaction.thTotals[TransTotInCcy];
    // thTotals will return the value including discount. If we don't need
    // the discount, we have to add it back in again.
    if oTransaction.thSettleDiscTaken and not withDiscount then
      Result := Result + oTransaction.thSettleDiscAmount;
  end;

begin
  I5Net1F.Value := oTransaction.thNetValue; // InvNetVal;
  I5Net2F.Value := oTransaction.thNetValue; // InvNetVal;

  I5VAT1F.Value := oTransaction.thTotalVAT; // InvVAT;
  I5VAT2F.Value := oTransaction.thTotalVAT; // InvVAT;

  I5Disc1F.Value := oTransaction.thTotalLineDiscount; // DiscAmount;
  I5Disc2F.Value := oTransaction.thTotalLineDiscount +
                    oTransaction.thSettleDiscAmount;  // DiscAmount+DiscSetAm;

  // Calculate the amounts for discount taken and not taken
  I5Tot1F.Value := TransactionTotal(False);
  I5Tot2F.Value := TransactionTotal(True);

  I5LT1F.Value := oTransaction.thLineTypeAnalysis[1]; // DocLSplit[1];
  I5LT2F.Value := oTransaction.thLineTypeAnalysis[2]; // DocLSplit[2];
  I5LT3F.Value := oTransaction.thLineTypeAnalysis[3]; // DocLSplit[3];
  I5LT4F.Value := oTransaction.thLineTypeAnalysis[4]; // DocLSplit[4];

  if (FToolkit.SystemSetup.ssReleaseCodes as ISystemSetupReleaseCodes2).rcCISRCT <> rcDisabled then
  begin
    if oTransaction.thCISEmployee <> '' then
    begin
      I5CISTaxF.Value := oTransaction.thCISTaxDue; // CISTax;
      I5CISDecF.Value := oTransaction.thCISTaxDeclared;

      I5CISGrossF.Value      := oTransaction.thCISTotalGross; // CISGross;
      I5CISManCb.Checked     := oTransaction.thCISManualTax;  // CISManualTax;
      I5CISPeriodF.DateValue := oTransaction.thCISDate;       // CISDate;

      If (I5VRateF.Visible) then
        ScrollBox8.Height := 121
      else
        ScrollBox8.Height := 145;

      CISPanel1.Visible := True;

      If (Round_Up(oTransaction.thCISTotalGross + oTransaction.thCISTaxDue, 2) = 0.0) then {Its a non taxable calc}
      Begin
        I5CISGrossF.Value := TransactionTotal(True);

        Label1.Caption := 'Gross';

        // If (CurrentCountry<>IECCode) then
        if FToolkit.SystemSetup.ssCompanyCountryCode <> '353' {Ireland} then
          I5CISGrossF.Value := I5CISGrossF.Value - oTransaction.thTotalVAT; // - InvVAT;

        I5CISManCb.Visible := False;
        I5CISTaxF.Visible  := False;
        I5CISDecF.Left     := I5CISTaxF.Left;
        Label2.Caption     := 'Declared';
      end;
    end
    else
    Begin
      ScrollBox8.Height := 244;
      CISPanel1.Visible := False;
    end;
  end;
end;

// -----------------------------------------------------------------------------

// Display Invoice Total
procedure TTransactionFrm.SetInvTotPanels(const NewIndex : Integer);
var
  NewParent: TWinControl;
begin
  INetTotF.Visible := (NewIndex in [0..3, 5]);
  IVatTotF.Visible := ((INetTotF.Visible) and ((NewIndex<>1) or (I1MargLab.Visible)));
  IGTotF.Visible   := (IVATTotF.Visible);

  case NewIndex of
    1  :  With IGTotF do
          Begin
            DisplayFormat := GenPcntMask;
            DecPlaces     := 1;
          end;
    else  With IGTotF do
          Begin
            DisplayFormat := GenRealMask;
            DecPlaces     := 2;
          end;
  end;

  if (NewIndex in [0..3, 5]) then
  begin
    case NewIndex of
      1:  NewParent := I2BtmPanel;
      2:  NewParent := I3BtmPanel;
      3:  NewParent := I4BtmPanel;
      5:  NewParent := I6BtmPanel;
    else  NewParent := I1BtmPanel;
    end;
    INetTotF.Parent := NewParent;
    IVatTotF.Parent := NewParent;
    IGTotF.Parent   := NewParent;
  end;
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.ReFreshFooter;
Begin
  HideUnusedVATRates;
  OutInvFooterTot;
end;

// -----------------------------------------------------------------------------

function TTransactionFrm.Current_Page: Integer;
begin
  Result := PageControl1.ActivePage.PageIndex;
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.PageControl1Change(Sender: TObject);
var
  NewIndex  : Integer;
begin
  if (Sender is TPageControl) then
  begin
    with Sender as TPageControl do
    begin
      NewIndex := Current_Page;

      if (NewIndex in [0..4]) then
        LockWindowUpDate(0);

      if (not TransExtForm1.NewSetting) and (NewIndex>3) then {* Panel is open, so close it *}
        TransExtForm1.ForceClose;

      if (NewIndex=4) or (not I1BtnPanel.Visible) then
      begin
        I1BtnPanel.Visible := (NewIndex<>4);
        I1BtnPanel.Enabled := (NewIndex<>4);
        I1FPanel.Visible   := (NewIndex<>4);
      end;

      CustToMemo(I1AddrF);

      SetInvTotPanels(NewIndex);
      OutInvTotals(NewIndex);

      case NewIndex of
        0..3  : ChangeList(NewIndex,True);
        4     : if (ReCalcTot) then
                begin
                  ReCalcTot:=False;
                  ReFreshFooter;
                end;
      end;
    end;
  end;
  LockWindowUpDate(0);
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  LockWindowUpDate(Handle);
end;

// -----------------------------------------------------------------------------

// IMPORTANT NOTE: This message handler is required to ensure the form stays
// on top, as it has a habit of losing its Stay-On-Top'ness at runtime.
procedure TTransactionFrm.WMWindowPosChanged(var Msg : TMessage);
var
  TopWindow : TWinControl;
begin
  // Do standard message processing
  inherited;

  // HM 22/10/03: Added Visible check as it hangs under win 98 otherwise
  if self.Visible Then
  begin
    // Check to see if the TopMost window is a Drill-Down window
    TopWindow := FindControl(PWindowPos(Msg.LParam).hwndInsertAfter);
    If Not Assigned(TopWindow) Then
      // Restore TopMost back to window
      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
  End; // If Self.Visible
End;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.HidePanels (PageNo : Byte);
var
  TmpBo, LocBo, DelBo, CCDepBo : Boolean;
  n                            : Integer;
begin
  case PageNo of
    0: begin
        if FToolkit.Enterprise.enModuleVersion in [enModStock, enModSPOP] then
          // IFDEF STK
          TmpBo := True
        else
          TmpBo := False;
        TransLineList.Columns[1].Visible := TmpBo;
        TransLineList.Columns[2].Visible := not TmpBo;
       end;
    1: begin
        if FToolkit.Enterprise.enModuleVersion in [enModStock, enModSPOP] then
          // IFDEF STK
          TmpBo := True
        else
          TmpBo := False;
        AnalysisList.Columns[1].Visible := TmpBo;

        if FToolkit.Enterprise.enModuleVersion <> enModSPOP then
          // IFNDEF SOP
          TmpBo := True
        else
          TmpBo := False;
        AnalysisList.Columns[2].Visible := TmpBo;

        TmpBo := (oTransaction.thDocType In PSOPSet);
        AnalysisList.Columns[3].Visible := TmpBo;

        TmpBo := FToolkit.SystemSetup.ssUseCCDept;
        AnalysisList.Columns[5].Visible := TmpBo;
        AnalysisList.Columns[6].Visible := TmpBo;

        TmpBo := ((oTransaction.thDocType In SalesSplit) and
                  (FToolkit.Functions.entCheckSecurity(FUserName, 143) = 0));

        AnalysisList.Columns[8].Visible := TmpBo or (oTransaction.thDocType In PurchSplit);
        AnalysisList.Columns[9].Visible := TmpBo;
        AnalysisList.Columns[10].Visible := TmpBo;
       end;
    3: begin
        if FToolkit.Enterprise.enModuleVersion in [enModStock, enModSPOP] then
          // IFDEF STK
          TmpBo := True
        else
          TmpBo := False;
        JobViewList.Columns[1].Visible := TmpBo;
       end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.ChangeList (PageNo : Byte; ShowLines : Boolean);
begin
  TransLineList.Active := False;
  AnalysisList.Active  := False;
  JobViewList.Active   := False;
  case PageNo of
    0: TransLineList.Active := True;
    1: AnalysisList.Active  := True;
    3: JobViewList.Active   := True;
  end;
  HidePanels(PageNo);
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.FormSetOfSet;
begin
  PagePoint[0].X := ClientWidth - (PageControl1.Width);
  PagePoint[0].Y := ClientHeight - (PageControl1.Height);

  PagePoint[1].X := PageControl1.Width - (TransLineList.Width);
  PagePoint[1].Y := PageControl1.Height - (TransLineList.Height);

  PagePoint[2].X := PageControl1.Width - (I1BtnPanel.Left);
  PagePoint[2].Y := PageControl1.Height - (I1BtnPanel.Height);

  PagePoint[3].X := I1BtnPanel.Height - (I1BSBox.Height);

  PagePoint[6].X := PageControl1.Height - (RcListBtnPanel.Height);

  GotCoord := True;
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.ClsI1BtnClick(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------------------------------

procedure TTransactionFrm.btnViewLineClick(Sender: TObject);
begin
  Display_Id;
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.Display_Id;
begin { Display_Id }
  if (FToolkit.TransactionDetails.tlLineNo = ReceiptCode) then
  begin

  end
  else
  begin
    // Sales/Purchase Line
    // Create form if required
    if (not Assigned(IdLine)) then
    begin
      IDLine := TTransactionLineFrm.Create(Self);
      IDLine.Toolkit := FToolkit;
    end;

    if Assigned(IdLine) then
      // Display Transaction Line
      IdLine.DisplayId;
  end;
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.SetUDFields(UDDocHed  :  TDocTypes);
Var
  LabelArray: Array[1..10] of TLabel;
  FieldArray: Array[1..10] of TCustomEdit;
  UpperBound, LowerBound: Integer;
  PNo,n  :  Byte;
  Counter: Integer;
  UDAry,
  HDAry  :  Array[1..4] of Byte;
Begin
  PNo:=1;

  Case UDDocHed of
      dtSOR,dtSDN  :  Begin
                    For n:=1 to 4 do
                      UDAry[n]:=10+n;

                    HDAry:=UDAry;
                  end;
      dtPOR,dtPDN  :  Begin
                    For n:=1 to 4 do
                      UDAry[n]:=34+n;

                    HDAry:=UDAry;
                  end;
      dtSQU      :  Begin
                    PNo:=2;
                    For n:=1 to 4 do
                      UDAry[n]:=24+n;

                    HDAry:=UDAry;
                  end;
      dtPQU      :  Begin
                    PNo:=2;

                    For n:=1 to 4 do
                      UDAry[n]:=32+n;

                    HDAry:=UDAry;
                  end;

      else        Begin
                    If (UDDocHed In SalesSplit) then
                    Begin
                      PNo:=0;
                      UDAry[1]:=3;
                      UDAry[2]:=4;
                      UDAry[3]:=13;
                      UDAry[4]:=14;

                      HDAry[1]:=0;
                      HDAry[2]:=5;
                      HDAry[3]:=6;
                      HDAry[4]:=7;

                    end
                    else
                    Begin
                      For n:=1 to 4 do
                        UDAry[n]:=18+n;

                      HDAry:=UDAry;
                    end;

                  end;
  end; {Case..}

  //GS 17/11/2011 ABSEXCH-12037: modifed UDF settings code to use the new "CustomFieldsIntF" unit
  LabelArray[1] := UDF1L;
  LabelArray[2] := UDF2L;
  LabelArray[3] := UDF3L;
  LabelArray[4] := UDF4L;
  LabelArray[5] := UDF5L;
  LabelArray[6] := UDF6L;
  LabelArray[7] := UDF7L;
  LabelArray[8] := UDF8L;
  LabelArray[9] := UDF9L;
  LabelArray[10] := UDF10L;

  FieldArray[1] := THUD1F;
  FieldArray[2] := THUD2F;
  FieldArray[3] := THUD3F;
  FieldArray[4] := THUD4F;
  FieldArray[5] := THUD5F;
  FieldArray[6] := THUD6F;
  FieldArray[7] := THUD7F;
  FieldArray[8] := THUD8F;
  FieldArray[9] := THUD9F;
  FieldArray[10] := THUD10F;

  EnableUDFs(FToolkit, LabelArray, FieldArray, oTransaction.thDocType, True);

  if lblOverrideLocation.Visible = False then
  begin
    //move the UDF controls to cover up the gap left behind by the over-ride field when it is hidden
    for Counter := Low(LabelArray) to High(LabelArray) do
    begin
      LabelArray[Counter].Top := LabelArray[Counter].Top - 40;
      FieldArray[Counter].Top := FieldArray[Counter].Top - 40;
    end;
    TransExtForm1.ExpandedHeight := TransExtForm1.ExpandedHeight - 40
  end;

  ResizeUDFParentContainer(NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]),
                           2,
                           TransExtForm1);

end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.DatasetGetFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
begin
  if FieldName <> 'x' then
  begin
    FieldValue := Outline(PageControl1.ActivePageIndex, StrToInt(FieldName));
  end;
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.TransLineListRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  Display_Id;
end;

// -----------------------------------------------------------------------------

procedure TTransactionFrm.TransLineListChangeSelection(Sender: TObject);
var
  Key: string;
  Status: Integer;
begin
  if IdLine <> nil then
  begin
    IdLine.DisplayId(True);
  end;
  Key := FToolkit.GeneralLedger.BuildCodeIndex(fToolkit.TransactionDetails.tlGLCode);
  Status := FToolkit.GeneralLedger.GetEqual(Key);
  if Status = 0 then
  begin
    I1NomCodeF.Text := FToolkit.GeneralLedger.glName;
    I4NomF.Text := FToolkit.GeneralLedger.glName;
  end;
  I1CCF.Text := FToolkit.TransactionDetails.tlCostCentre;
  I4CCF.Text := FToolkit.TransactionDetails.tlCostCentre;
  I1DepF.Text := FToolkit.TransactionDetails.tlDepartment;
  I4DepF.Text := FToolkit.TransactionDetails.tlDepartment;
  I2QtyF.Value := FToolkit.TransactionDetails.tlQty;
  I2StkDescF.Text := FToolkit.TransactionDetails.tlDescr;
  I1LocnF.Text := FToolkit.TransactionDetails.tlLocation;
end;

// -----------------------------------------------------------------------------

end.

