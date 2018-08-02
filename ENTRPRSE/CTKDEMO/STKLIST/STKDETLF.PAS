unit StkDetlF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Enterprise01_TLB, StkListF, QtyBrkF,
  BOMDetF, SerDetF;

type
  TfrmStockDetail = class(TForm)
    PageControl1: TPageControl;
    tabMain: TTabSheet;
    GroupBox1: TGroupBox;
    edtAcCode: TEdit;
    tabDefaults: TTabSheet;
    panButtonIndent: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    lstStockType: TComboBox;
    edtDesc1: TEdit;
    edtDesc2: TEdit;
    edtDesc3: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtDesc4: TEdit;
    edtDesc5: TEdit;
    edtDesc6: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    GroupBox2: TGroupBox;
    edtMinStock: TEdit;
    Label8: TLabel;
    edtMaxStock: TEdit;
    Label9: TLabel;
    Bevel1: TBevel;
    Label10: TLabel;
    Label11: TLabel;
    edtQtyInStock: TEdit;
    edtQtyPosted: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    edtQtyAllocated: TEdit;
    edtQtyFree: TEdit;
    Bevel2: TBevel;
    Label14: TLabel;
    edtQtyOnOrder: TEdit;
    GroupBox3: TGroupBox;
    Label15: TLabel;
    lstPricedBy: TComboBox;
    Label16: TLabel;
    ScrollBox2: TScrollBox;
    Label17: TLabel;
    lstCcyA: TComboBox;
    edtSalesPriceA: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    lstCcyB: TComboBox;
    edtSalesPriceB: TEdit;
    Label20: TLabel;
    lstCcyC: TComboBox;
    edtSalesPriceC: TEdit;
    Label21: TLabel;
    lstCcyD: TComboBox;
    edtSalesPriceD: TEdit;
    Label22: TLabel;
    lstCcyE: TComboBox;
    edtSalesPriceE: TEdit;
    Label23: TLabel;
    lstCcyF: TComboBox;
    edtSalesPriceF: TEdit;
    Label24: TLabel;
    lstCcyG: TComboBox;
    edtSalesPriceG: TEdit;
    Label25: TLabel;
    lstCcyH: TComboBox;
    edtSalesPriceH: TEdit;
    Label26: TLabel;
    lstCcyCost: TComboBox;
    edtCostPrice: TEdit;
    Label27: TLabel;
    lstCcyReorder: TComboBox;
    edtReorderPrice: TEdit;
    Label28: TLabel;
    lstValMethod: TComboBox;
    GroupBox4: TGroupBox;
    chkShowAsPacks: TCheckBox;
    Label29: TLabel;
    Label30: TLabel;
    GroupBox5: TGroupBox;
    Label31: TLabel;
    edtSupplier: TEdit;
    Label32: TLabel;
    edtAltCode: TEdit;
    GroupBox6: TGroupBox;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label6756: TLabel;
    edtUnitStock: TEdit;
    edtUnitSale: TEdit;
    edtUnitPurchase: TEdit;
    edtSalesUnits: TEdit;
    edtPurchUnits: TEdit;
    GroupBox7: TGroupBox;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    edtGLSales: TEdit;
    edtGLCOS: TEdit;
    edtGLWO: TEdit;
    edtGLStkVal: TEdit;
    edtGLBOM: TEdit;
    Bevel3: TBevel;
    Label42: TLabel;
    edtJobAnal: TEdit;
    Label43: TLabel;
    edtCC: TEdit;
    edtDept: TEdit;
    Label44: TLabel;
    edtLocation: TEdit;
    edtBin: TEdit;
    Label45: TLabel;
    edtBarCode: TEdit;
    tabVAT: TTabSheet;
    GroupBox8: TGroupBox;
    Label46: TLabel;
    lstVATRate: TComboBox;
    GroupBox9: TGroupBox;
    Label47: TLabel;
    lblStkUser1: TLabel;
    lblStkUser2: TLabel;
    lblStkUser3: TLabel;
    lblStkUser4: TLabel;
    edtStkUser1: TEdit;
    edtStkUser2: TEdit;
    edtStkUser3: TEdit;
    edtStkUser4: TEdit;
    Bevel4: TBevel;
    lstLineType: TComboBox;
    chkInclOnWeb: TCheckBox;
    Label48: TLabel;
    edtImage: TEdit;
    edtWebCat: TEdit;
    Label49: TLabel;
    Bevel5: TBevel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    edtCommodity: TEdit;
    edtUnitDesc: TEdit;
    edtSKUnits: TEdit;
    edtSalesWeight: TEdit;
    Label54: TLabel;
    Label55: TLabel;
    edtPurchWeight: TEdit;
    edtUplift: TEdit;
    Label56: TLabel;
    edtCountry: TEdit;
    GroupBox10: TGroupBox;
    chkUseCover: TCheckBox;
    Label57: TLabel;
    edtCovPr: TEdit;
    lstCovPrUnits: TComboBox;
    Label58: TLabel;
    edtMinPr: TEdit;
    lstMinPrUnits: TComboBox;
    Label59: TLabel;
    edtMaxPr: TEdit;
    lstMaxPrUnits: TComboBox;
    Label60: TLabel;
    edtQtySold: TEdit;
    tabQtyBreaks: TTabSheet;
    lvQtyBreaks: TListView;
    Panel1: TPanel;
    btnAddQBrk: TButton;
    btnEditQBrk: TButton;
    btnViewQBrk: TButton;
    tabshBuild: TTabSheet;
    tabshWhere: TTabSheet;
    lvWhereUsed: TListView;
    lvKit: TListView;
    Panel2: TPanel;
    btnAddComp: TButton;
    btnEditComp: TButton;
    btnInsComp: TButton;
    btnDelComp: TButton;
    btnCompCheck: TButton;
    tabshSerial: TTabSheet;
    lvSerialNo: TListView;
    Panel3: TPanel;
    btnAddSerial: TButton;
    btnViewSerial: TButton;
    btnSerialNotes: TButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure Label29Click(Sender: TObject);
    procedure edtSupplierDblClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnAddQBrkClick(Sender: TObject);
    procedure btnEditQBrkClick(Sender: TObject);
    procedure btnViewQBrkClick(Sender: TObject);
    procedure btnEditCompClick(Sender: TObject);
    procedure btnInsCompClick(Sender: TObject);
    procedure btnDelCompClick(Sender: TObject);
    procedure btnAddCompClick(Sender: TObject);
    procedure btnCompCheckClick(Sender: TObject);
    procedure btnViewSerialClick(Sender: TObject);
    procedure btnAddSerialClick(Sender: TObject);
    procedure btnSerialNotesClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FStkDetail   : IStock;
    FMode        : TDialogMode;
    FNeedRefresh : Boolean;

    procedure DisplayComponent(Const Mode : TComponentDlgMode);
    procedure DisplayQtyBreak (DlgMode : TQtyBrkDlgMode);
    procedure DisplaySerial (DlgMode : TSerialDlgMode);
  protected
    Procedure SetStkDetail (Value : IStock);
    Procedure SetMode (Value : TDialogMode);
  public
    { Public declarations }
    Property StkDetail : IStock Read FStkDetail Write SetStkDetail;
    Property Mode : TDialogMode Read FMode Write SetMode;
    Property NeedRefresh : Boolean Read FNeedRefresh Write FNeedRefresh;
  end;

implementation

{$R *.DFM}

Uses NoteLstF;

procedure TfrmStockDetail.FormCreate(Sender: TObject);
Const
  VATCodeList : Array [1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
Var
  I : Byte;
begin
  // Initialise local variables
  FStkDetail   := Nil;
  fMode        := mdAdd;
  FNeedRefresh := False;

  // Load Currency Lists
  With oToolkit.SystemSetup Do Begin
    For I := 0 To 90 Do
      lstCcyA.Items.Add (ssCurrency[I].scSymbol);
    lstCcyB.Items.Assign(lstCcyA.Items);
    lstCcyC.Items.Assign(lstCcyA.Items);
    lstCcyD.Items.Assign(lstCcyA.Items);
    lstCcyE.Items.Assign(lstCcyA.Items);
    lstCcyF.Items.Assign(lstCcyA.Items);
    lstCcyG.Items.Assign(lstCcyA.Items);
    lstCcyH.Items.Assign(lstCcyA.Items);
    lstCcyCost.Items.Assign(lstCcyA.Items);
    lstCcyReorder.Items.Assign(lstCcyA.Items);

    lstVATRate.Clear;
    For I := Low(VATCodeList) To High(VatCodeList) Do
      with ssVATRates[VATCodeList[I]] Do
        lstVATRate.Items.Add (svCode);

    With ssUserFields Do Begin
      lstLineType.Clear;
      lstLineType.Items.Add('Normal');
      If ufLineType1Enabled Then lstLineType.Items.Add(ufLineType1);
      If ufLineType2Enabled Then lstLineType.Items.Add(ufLineType2);
      If ufLineType3Enabled Then lstLineType.Items.Add(ufLineType3);
      If ufLineType4Enabled Then lstLineType.Items.Add(ufLineType4);
    End; { With ssUserFields }
  End; { With oToolkit.SystemSetup }
end;

{----------------------------------------}

procedure TfrmStockDetail.FormDestroy(Sender: TObject);
begin
  // Explicitly release reference to interface
  FStkDetail := Nil;
end;

{----------------------------------------}

Procedure TfrmStockDetail.SetMode (Value : TDialogMode);
begin
  FMode := Value;

  // Enable/Disable fields according to dialog purpose
  edtAcCode.ReadOnly := (FMode <> mdAdd);
  lstStockType.Enabled := Not edtAcCode.ReadOnly;
  edtDesc1.ReadOnly := (FMode = mdView);
  edtDesc2.ReadOnly := edtDesc1.ReadOnly;
  edtDesc3.ReadOnly := edtDesc1.ReadOnly;
  edtDesc4.ReadOnly := edtDesc1.ReadOnly;
  edtDesc5.ReadOnly := edtDesc1.ReadOnly;
  edtDesc6.ReadOnly := edtDesc1.ReadOnly;

  lstCcyA.Enabled := Not edtDesc1.ReadOnly;
  edtSalesPriceA.ReadOnly := edtDesc1.ReadOnly;
  lstCcyB.Enabled := Not edtDesc1.ReadOnly;
  edtSalesPriceB.ReadOnly := edtDesc1.ReadOnly;
  lstCcyC.Enabled := Not edtDesc1.ReadOnly;
  edtSalesPriceC.ReadOnly := edtDesc1.ReadOnly;
  lstCcyD.Enabled := Not edtDesc1.ReadOnly;
  edtSalesPriceD.ReadOnly := edtDesc1.ReadOnly;
  lstCcyE.Enabled := Not edtDesc1.ReadOnly;
  edtSalesPriceE.ReadOnly := edtDesc1.ReadOnly;
  lstCcyF.Enabled := Not edtDesc1.ReadOnly;
  edtSalesPriceF.ReadOnly := edtDesc1.ReadOnly;
  lstCcyG.Enabled := Not edtDesc1.ReadOnly;
  edtSalesPriceG.ReadOnly := edtDesc1.ReadOnly;
  lstCcyH.Enabled := Not edtDesc1.ReadOnly;
  edtSalesPriceH.ReadOnly := edtDesc1.ReadOnly;
  lstCcyCost.Enabled := Not edtDesc1.ReadOnly;
  edtCostPrice.ReadOnly := edtDesc1.ReadOnly;
  lstCcyReorder.Enabled := Not edtDesc1.ReadOnly;
  edtReorderPrice.ReadOnly := edtDesc1.ReadOnly;
  lstValMethod.Enabled := Not edtDesc1.ReadOnly;

  edtMinStock.ReadOnly := edtDesc1.ReadOnly;
  edtMaxStock.ReadOnly := edtDesc1.ReadOnly;
  chkShowAsPacks.Enabled := Not edtDesc1.ReadOnly;

  // Defaults Tab
  edtSupplier.ReadOnly := edtDesc1.ReadOnly;
  edtAltCode.ReadOnly := edtDesc1.ReadOnly;
  edtCC.ReadOnly := edtDesc1.ReadOnly;
  edtDept.ReadOnly := edtDesc1.ReadOnly;
  edtLocation.ReadOnly := edtDesc1.ReadOnly;
  edtBin.ReadOnly := edtDesc1.ReadOnly;
  edtBarCode.ReadOnly := edtDesc1.ReadOnly;

  edtUnitStock.ReadOnly := edtDesc1.ReadOnly;
  edtUnitSale.ReadOnly := edtDesc1.ReadOnly;
  edtUnitPurchase.ReadOnly := edtDesc1.ReadOnly;
  edtSalesUnits.ReadOnly := edtDesc1.ReadOnly;
  edtPurchUnits.ReadOnly := edtDesc1.ReadOnly;

  edtGLSales.ReadOnly := edtDesc1.ReadOnly;
  edtGLCOS.ReadOnly := edtDesc1.ReadOnly;
  edtGLWO.ReadOnly := edtDesc1.ReadOnly;
  edtGLStkVal.ReadOnly := edtDesc1.ReadOnly;
  edtGLBOM.ReadOnly := edtDesc1.ReadOnly;

  edtJobAnal.ReadOnly := edtDesc1.ReadOnly;

  // VAT/Web Tab
  chkInclOnWeb.Enabled := Not edtDesc1.ReadOnly;
  edtWebCat.ReadOnly := edtDesc1.ReadOnly;
  edtImage.ReadOnly := edtDesc1.ReadOnly;

  lstVATRate.Enabled := Not edtDesc1.ReadOnly;
  edtCommodity.ReadOnly := edtDesc1.ReadOnly;
  edtUnitDesc.ReadOnly := edtDesc1.ReadOnly;
  edtSKUnits.ReadOnly := edtDesc1.ReadOnly;
  edtSalesWeight.ReadOnly := edtDesc1.ReadOnly;
  edtPurchWeight.ReadOnly := edtDesc1.ReadOnly;
  edtUplift.ReadOnly := edtDesc1.ReadOnly;
  edtCountry.ReadOnly := edtDesc1.ReadOnly;

  lstLineType.Enabled := Not edtDesc1.ReadOnly;
  With oToolkit.SystemSetup.ssUserFields Do Begin
    lblStkUser1.Caption := ufStock1;
    edtStkUser1.ReadOnly := edtDesc1.ReadOnly;
    lblStkUser2.Caption := ufStock2;
    edtStkUser2.ReadOnly := edtDesc1.ReadOnly;
    lblStkUser3.Caption := ufStock3;
    edtStkUser3.ReadOnly := edtDesc1.ReadOnly;
    lblStkUser4.Caption := ufStock4;
    edtStkUser4.ReadOnly := edtDesc1.ReadOnly;
  End; { With ssUserFields }

  chkUseCover.Enabled := Not edtDesc1.ReadOnly;
  edtCovPr.ReadOnly := edtDesc1.ReadOnly;
  lstCovPrUnits.Enabled := Not edtDesc1.ReadOnly;
  edtMinPr.ReadOnly := edtDesc1.ReadOnly;
  lstMinPrUnits.Enabled := Not edtDesc1.ReadOnly;
  edtMaxPr.ReadOnly := edtDesc1.ReadOnly;
  lstMaxPrUnits.Enabled := Not edtDesc1.ReadOnly;
  edtQtySold.ReadOnly := edtDesc1.ReadOnly;

  // Hide BOM Kit if Adding a new stock item - parent stock has to exist before you can add BOM Kit
  tabshBuild.TabVisible := (FMode In [mdView, mdEdit]);
  btnAddComp.Enabled := (FMode = mdEdit);
  btnEditComp.Enabled := (FMode = mdEdit);
  btnInsComp.Enabled := (FMode = mdEdit);
  btnDelComp.Enabled := (FMode = mdEdit);
  btnCompCheck.Enabled := (FMode = mdEdit);

  // Hide Serial/Batch is Adding - parent stock has to exist first!
  tabshSerial.TabVisible := (FMode In [mdView, mdEdit]);

  // Enable/Disable buttons as required
  btnSave.Enabled := (FMode In [mdAdd, mdEdit]);
  If btnSave.Enabled Then btnCancel.Caption := '&Cancel' Else btnCancel.Caption := '&Close';
end;

{----------------------------------------}

Procedure TfrmStockDetail.SetStkDetail (Value : IStock);
Var
  QtyAlloc : Double;
begin
  If (FStkDetail <> Value) Then Begin
    FStkDetail := Value;

    With FStkDetail, oToolkit, SystemSetup  Do Begin
      // Set window title
      If (FMode = mdAdd) Then
        Caption := 'Add New Stock Item'
      Else
        Caption := 'Stock Record - ' + Trim(stCode) + ', ' + Trim(stDesc[1]);

      // Always start on 'Main' tab
      PageControl1.ActivePage := tabMain;

      edtAcCode.Text := stCode;
      lstStockType.ItemIndex := Ord(stType);
      edtDesc1.Text := stDesc[1];
      edtDesc2.Text := stDesc[2];
      edtDesc3.Text := stDesc[3];
      edtDesc4.Text := stDesc[4];
      edtDesc5.Text := stDesc[5];
      edtDesc6.Text := stDesc[6];

      lstPricedBy.Clear;
      lstPricedBy.Items.Add ('Stock Unit - ' + stUnitOfStock);
      lstPricedBy.Items.Add ('Sales Unit - ' + stUnitOfSale);
      lstPricedBy.Items.Add ('Split Pack - ' + stUnitOfSale);
      lstPricedBy.ItemIndex := stPricingMethod;

      With stSalesBands['A'] Do Begin
        lstCcyA.ItemIndex := stCurrency;
        edtSalesPriceA.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['A'] }
      With stSalesBands['B'] Do Begin
        lstCcyB.ItemIndex := stCurrency;
        edtSalesPriceB.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['B'] }
      With stSalesBands['C'] Do Begin
        lstCcyC.ItemIndex := stCurrency;
        edtSalesPriceC.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['C'] }
      With stSalesBands['D'] Do Begin
        lstCcyD.ItemIndex := stCurrency;
        edtSalesPriceD.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['D'] }
      With stSalesBands['E'] Do Begin
        lstCcyE.ItemIndex := stCurrency;
        edtSalesPriceE.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['E'] }
      With stSalesBands['F'] Do Begin
        lstCcyF.ItemIndex := stCurrency;
        edtSalesPriceF.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['F'] }
      With stSalesBands['G'] Do Begin
        lstCcyG.ItemIndex := stCurrency;
        edtSalesPriceG.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['G'] }
      With stSalesBands['H'] Do Begin
        lstCcyH.ItemIndex := stCurrency;
        edtSalesPriceH.Text := Format ('%0.' + IntToStr(ssSalesDecimals) + 'f', [stPrice]);
      End; { With stSalesBands['H'] }

      lstCcyCost.ItemIndex := stCostPriceCur;
      edtCostPrice.Text := Format ('%0.' + IntToStr(ssCostDecimals) + 'f', [stCostPrice]);

      lstCcyReorder.ItemIndex := stReorder.stReorderCur;
      edtReorderPrice.Text := Format ('%0.' + IntToStr(ssCostDecimals) + 'f', [stReorder.stReorderPrice]);

      lstValMethod.ItemIndex := Ord(stValuationMethod);

      edtMinStock.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [stQtyMin]);
      edtMaxStock.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [stQtyMax]);

      // Calculate stock levels
      If ssPickingOrderAllocatesStock Then QtyAlloc := stQtyPicked Else QtyAlloc := stQtyAllocated;
      edtQtyInStock.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [stQtyInStock]);
      edtQtyPosted.Text := 'N/A';
      edtQtyAllocated.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [QtyAlloc]);
      edtQtyFree.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [stQtyFree]);
      edtQtyOnOrder.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [stQtyOnOrder]);
      chkShowAsPacks.Checked := stShowQtyAsPacks;

      // Defaults Tab
      edtSupplier.Text := stSupplier;
      edtAltCode.Text := stAltCode;
      edtCC.Text := stCostCentre;
      edtDept.Text := stDepartment;
      edtLocation.Text := stLocation;
      edtBin.Text := stBinLocation;
      edtBarCode.Text := stBarCode;

      edtUnitStock.Text := stUnitOfStock;
      edtUnitSale.Text := stUnitOfSale;
      edtUnitPurchase.Text := stUnitOfPurch;
      edtSalesUnits.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [stSalesUnits]);
      edtPurchUnits.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'f', [stPurchUnits]);

      edtGLSales.Text := IntToStr(stSalesGL);
      edtGLCOS.Text := IntToStr(stCOSGL);
      edtGLWO.Text := IntToStr(stPandLGL);
      edtGLStkVal.Text := IntToStr(stBalSheetGL);
      edtGLBOM.Text := IntToStr(stWIPGL);

      edtJobAnal.Text := stAnalysisCode;

      // VAT/Web Tab
      chkInclOnWeb.Checked := stUseForEbus;
      edtWebCat.Text := stWebLiveCatalog;
      edtImage.Text := stImageFile;

      lstVATRate.Text := stVATCode;
      edtCommodity.Text := stIntrastat.stSSDCommodityCode;
      edtUnitDesc.Text := stIntrastat.stSSDUnitDesc;
      edtSKUnits.Text := Format ('%0.2f', [stIntrastat.stSSDStockUnits]);
      edtSalesWeight.Text := Format ('%0.2f', [stIntrastat.stSSDSalesUnitWeight]);
      edtPurchWeight.Text := Format ('%0.2f', [stIntrastat.stSSDPurchaseUnitWeight]);
      edtUplift.Text := Format ('%0.2f', [stIntrastat.stSSDDespatchUplift]);
      edtCountry.Text := stIntrastat.stSSDCountry;

      lstLineType.ItemIndex := stDefaultLineType;
      edtStkUser1.Text := stUserField1;
      edtStkUser2.Text := stUserField2;
      edtStkUser3.Text := stUserField3;
      edtStkUser4.Text := stUserField4;

      chkUseCover.Checked := stCover.stUseCover;
      edtCovPr.Text := IntToStr(stCover.stCoverPeriods);
      lstCovPrUnits.Text := stCover.stCoverPeriodUnits;
      edtMinPr.Text := IntToStr(stCover.stCoverMinPeriods);
      lstMinPrUnits.Text := stCover.stCoverMinPeriodUnits;
      edtMaxPr.Text := IntToStr(stCover.stCoverMaxPeriods);
      lstMaxPrUnits.Text := stCover.stCoverMaxPeriodUnits;
      edtQtySold.Text := Format ('%0.' + IntToStR(ssQtyDecimals) + 'f', [stCover.stCoverQtySold]);

      If tabshBuild.TabVisible Then
        // Hide BOM Kit if not a BOM Stock Item
        tabshBuild.TabVisible := (stType = stTypeBillOfMaterials);

      If tabshSerial.TabVisible Then
        // Hide Serial/Batcht if not a Serial/Batch Stock Item
        tabshSerial.TabVisible := (stValuationMethod In [stValSerialAvgCost, stValSerial]);
    End; { With FStkDetail }
  End; { If (FStkDetail <> Value) }
end;

{----------------------------------------}

procedure TfrmStockDetail.btnSaveClick(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  With FStkDetail Do Begin
    // Copy detail back into StKDetail Interface
    stCode := edtAcCode.Text;
    stType := lstStockType.ItemIndex;
    stDesc[1] := edtDesc1.Text;
    stDesc[2] := edtDesc2.Text;
    stDesc[3] := edtDesc3.Text;
    stDesc[4] := edtDesc4.Text;
    stDesc[5] := edtDesc5.Text;
    stDesc[6] := edtDesc6.Text;

    // Priced By
    stPricingMethod := lstPricedBy.ItemIndex;

    // Sales Bands
    With stSalesBands['A'] Do Begin
      stCurrency := lstCcyA.ItemIndex;
      stPrice := StrToFloat(edtSalesPriceA.Text);
    End; { With stSalesBands['A'] }
    With stSalesBands['B'] Do Begin
      stCurrency := lstCcyB.ItemIndex;
      stPrice := StrToFloat(edtSalesPriceB.Text);
    End; { With stSalesBands['B'] }
    With stSalesBands['C'] Do Begin
      stCurrency := lstCcyC.ItemIndex;
      stPrice := StrToFloat(edtSalesPriceC.Text);
    End; { With stSalesBands['C'] }
    With stSalesBands['C'] Do Begin
      stCurrency := lstCcyC.ItemIndex;
      stPrice := StrToFloat(edtSalesPriceC.Text);
    End; { With stSalesBands['C'] }
    With stSalesBands['D'] Do Begin
      stCurrency := lstCcyD.ItemIndex;
      stPrice := StrToFloat(edtSalesPriceD.Text);
    End; { With stSalesBands['D'] }
    With stSalesBands['E'] Do Begin
      stCurrency := lstCcyE.ItemIndex;
      stPrice := StrToFloat(edtSalesPriceE.Text);
    End; { With stSalesBands['E'] }
    With stSalesBands['F'] Do Begin
      stCurrency := lstCcyF.ItemIndex;
      stPrice := StrToFloat(edtSalesPriceF.Text);
    End; { With stSalesBands['F'] }
    With stSalesBands['G'] Do Begin
      stCurrency := lstCcyG.ItemIndex;
      stPrice := StrToFloat(edtSalesPriceG.Text);
    End; { With stSalesBands['G'] }
    With stSalesBands['H'] Do Begin
      stCurrency := lstCcyH.ItemIndex;
      stPrice := StrToFloat(edtSalesPriceH.Text);
    End; { With stSalesBands['H'] }

    // Cost Price
    stCostPriceCur := lstCcyCost.Itemindex;
    stCostPrice := StrToFloat(edtCostPrice.Text);

    // Reorder Price
    stReorder.stReorderCur := lstCcyReorder.ItemIndex;
    stReorder.stReorderPrice := StrToFloat(edtReorderPrice.Text);

    // Valuation Method
    stValuationMethod := lstValMethod.ItemIndex;

    // Stock Levels
    stQtyMin := StrToFloat (edtMinStock.Text);
    stQtyMax := StrToFloat (edtMaxStock.Text);
    stShowQtyAsPacks := chkShowAsPacks.Checked;

    // VAT Code & Intrastat
    stVATCode := lstVATRate.Text;
    With stIntrastat Do Begin
      stSSDCommodityCode   := edtCommodity.Text;
      stSSDUnitDesc        := edtUnitDesc.Text;
      stSSDStockUnits      := StrToFloat (edtSKUnits.Text);
      stSSDSalesUnitWeight := StrToFloat (edtSalesWeight.Text);
      stSSDPurchaseUnitWeight := StrToFloat (edtPurchWeight.Text);
      stSSDDespatchUplift  := StrToFloat (edtUplift.Text);
      stSSDCountry := edtCountry.Text;
    End; { With stIntrastat }

    // GL Codes
    stSalesGL := StrToInt(edtGLSales.Text);
    stCOSGL := StrToInt(edtGLCOS.Text);
    stPandLGL := StrToInt(edtGLWO.Text);
    stBalSheetGL := StrToInt(edtGLStkVal.Text);
    stWIPGL := StrToInt(edtGLBOM.Text);

    // Analysis Code
    stAnalysisCode := edtJobAnal.Text;

    // Misc
    stSupplier := edtSupplier.Text;
    stAltCode := edtAltCode.Text;
    stCostCentre := edtCC.Text;
    stDepartment := edtDept.Text;
    stLocation := edtLocation.Text;
    stBinLocation := edtBin.Text;
    stBarCode := edtBarCode.Text;

    // Units
    stUnitOfStock := edtUnitStock.Text;
    stUnitOfSale := edtUnitSale.Text;
    stUnitOfPurch := edtUnitPurchase.Text;
    stSalesUnits := StrToFloat (edtSalesUnits.Text);
    stPurchUnits := StrToFloat (edtPurchUnits.Text);

    // Web
    stUseForEbus := chkInclOnWeb.Checked;
    stWebLiveCatalog := edtWebCat.Text;
    stImageFile := edtImage.Text;

    // Default Line Type
    stDefaultLineType := lstLineType.ItemIndex;

    // User Fields
    stUserField1 := edtStkUser1.Text;
    stUserField2 := edtStkUser2.Text;
    stUserField3 := edtStkUser3.Text;
    stUserField4 := edtStkUser4.Text;

    // Cover
    With stCover Do Begin
      stUseCover            := chkUseCover.Checked;
      stCoverPeriods        := StrToInt (edtCovPr.Text);
      stCoverPeriodUnits    := Copy (lstCovPrUnits.Text, 1, 1);
      stCoverMinPeriods     := StrToInt(edtMinPr.Text);
      stCoverMinPeriodUnits := Copy (lstMinPrUnits.Text, 1, 1);
      stCoverMaxPeriods     := StrToInt(edtMaxPr.Text);
      stCoverMaxPeriodUnits := Copy (lstMaxPrUnits.Text, 1, 1);
    End; { With stCover }

    // Save Account
    FuncRes := FStkDetail.Save;
    If (FuncRes = 0) Then Begin
      // Close dialog
      FNeedRefresh := True;
      Close;
    End { If (FuncRes = 0) }
    Else
      ShowMessage ('Status ' + IntToStr(FuncRes));
  End; { With FStkDetail }
end;

{----------------------------------------}

procedure TfrmStockDetail.btnCancelClick(Sender: TObject);
begin
  Case FMode Of
    mdAdd  : ; { No Action Required }
    mdEdit : FStkDetail.Cancel;
    mdView : ; { No Action Required }
  Else
    ShowMessage ('Unknown Mode');
  End;

  FNeedRefresh := False;
  Close;
end;

{----------------------------------------}

procedure TfrmStockDetail.Label29Click(Sender: TObject);
begin
  chkShowAsPacks.Checked := Not chkShowAsPacks.Checked
end;

{----------------------------------------}

procedure TfrmStockDetail.edtSupplierDblClick(Sender: TObject);
Var
  SuppO : IAccount;
begin
  SuppO := FStkDetail.stSupplierI;
  If Assigned(SuppO) Then
    ShowMessage (SuppO.acCode + ' - ' + SuppO.acCompany);
  SuppO := Nil;
end;

{----------------------------------------}

procedure TfrmStockDetail.PageControl1Change(Sender: TObject);
Var
  oStock  : IStock;
  I, Res  : LongInt;
begin
  If (PageControl1.ActivePage = tabQtyBreaks) Then
    With lvQtyBreaks, FStkDetail.stQtyBreaks Do Begin
      // Clear out any existing details
      Items.Clear;

      // Load Qty Breaks
      Res := GetFirst;
      While (Res = 0) Do Begin
        With Items.Add Do Begin
          // Save position of Qty Break record for later editing
          SavePosition;
          Data := Pointer(FStkDetail.stQtyBreaks.Position);

          Caption := FloatToStr(qbQuantityFrom);
          SubItems.Add (FloatToStr(qbQuantityTo));

          Case qbType Of
            DiscSpecialPrice : Begin
                                 SubItems.Add ('Price');
                                 SubItems.Add (Format ('%8.2n', [qbPrice]));
                               End;
            DiscBandPrice    : Begin
                                 SubItems.Add ('Band');
                                 SubItems.Add ('');
                                 SubItems.Add (qbPriceBand);
                                 If (qbDiscPercent <> 0) Then
                                   SubItems.Add (Format ('%8.2n%s', [qbDiscPercent, '%']))
                                 Else Begin
                                   SubItems.Add ('');
                                   SubItems.Add (Format ('%8.2n', [qbDiscValue]));
                                 End; { Else }
                               End;
            DiscMargin,
            DiscMarkup       : Begin
                                 If (qbType = DiscMarkup) Then
                                   SubItems.Add ('Mark Up')
                                 Else
                                   SubItems.Add ('Margin');

                                 SubItems.Add ('');
                                 SubItems.Add ('');
                                 SubItems.Add ('');
                                 SubItems.Add ('');
                                 SubItems.Add (Format ('%8.2n%s', [qbMarkupMarginPercent, '%']));
                               End;
          End; { Case qbType  }
        End; { With Items.Add }

        Res := GetNext;
      End; { While (Res = 0) }
    End { With lvQtyBreaks, FStkDetail.stQtyBreaks }
  Else
    // Where Used
    If (PageControl1.ActivePage = tabshWhere) Then
      With lvWhereUsed, FStkDetail.stWhereUsed Do Begin
        // Clear out any existing details
        Items.Clear;

        // Load Parent components
        Res := GetFirst;
        While (Res = 0) Do Begin
          With Items.Add Do Begin
            Caption := Trim(bmStockCode);

            oStock := bmStockCodeI;
            If Assigned(oStock) Then
              SubItems.Add (Trim(oStock.stDesc[1]))
            Else
              SubItems.Add ('');
            SubItems.Add (Format ('%0.2f', [bmQuantityUsed]));
            SubItems.Add (Format ('%8.2n', [bmUnitCost]));
          End; { With Items.Add }

          Res := GetNext;
        End; { While (Res = 0) }
      End { With lvWhereUsed, FStkDetail.stWhereUsed }
    Else
      // Bill Of Materials
      If (PageControl1.ActivePage = tabshBuild) Then Begin
        With lvKit, oToolkit, FStkDetail.stBillOfMaterials Do Begin
          // Clear out any existing details
          Items.Clear;

          // Load Sub-Components
          If (blComponentCount > 0) Then
            For I := 1 To blComponentCount Do
              With blComponent[I], Items.Add Do Begin
                // Record index for later editing
                Data := Pointer(I);

                Caption := Trim(bmStockCode);

                oStock := bmStockCodeI;
                If Assigned(oStock) Then
                  SubItems.Add (Trim(oStock.stDesc[1]))
                Else
                  SubItems.Add ('');
                SubItems.Add (Format ('%0.2f', [bmQuantityUsed]));
                SubItems.Add (Format ('%8.*n', [SystemSetup.ssCostDecimals, bmUnitCost]));
              End; { With Items.Add }
        End; { While (Res = 0) }
      End { If (PageControl1.ActivePage = tabshBuild) }
      Else
        // Serial/Batch numbers
        If (PageControl1.ActivePage = tabshSerial) Then Begin
          With lvSerialNo, oToolkit, FStkDetail.stSerialBatch Do Begin
            // Clear out any existing details
            Items.Clear;

            // Load Serial/Batch Numbers for current stock record
            Index := snIdxUsedSerialNo;
            Res := GetFirst;
            While (Res = 0) Do Begin
              With Items.Add Do Begin
                // Save position of Serial/Batch record for later editing, because
                // there is no unique key value there isn't any other easy way.
                SavePosition;
                Data := Pointer(FStkDetail.stSerialBatch.Position);

                If (snType = snTypeBatch) Then
                  // Main Batch Record - display available info
                  Caption := Format ('Avl: %0.0f/%0.0f', [snBatchQuantity-snBatchQuantitySold, snBatchQuantity])
                Else
                  If (snType = snTypeBatchSale) Then
                    // Batch Child - Display number sold
                    Caption := Format ('%0.0f used.', [snBatchQuantitySold])
                  Else
                    Caption := Trim(snSerialNo);
                If snSold Then SubItems.Add ('Y') Else SubItems.Add('N');
                SubItems.Add (Trim(snBatchNo));
                SubItems.Add (Trim(snInDocRef));
                SubItems.Add (Trim(snOutDocRef));
              End; { With Items.Add }

              Res := GetNext;
            End; { While (Res = 0) }
          End; { With lvSerialNo, oToolkit, FStkDetail.stSerialBatch }
        End; { If (PageControl1.ActivePage = tabshSerial) }
end;

{----------------------------------------}

procedure TfrmStockDetail.DisplayQtyBreak (DlgMode : TQtyBrkDlgMode);
var
  FuncRes   : LongInt;
begin
  With lvQtyBreaks, oToolkit, FStkDetail, stQtyBreaks Do
    // Check 1 item is selected for editing
    If (DlgMode = qmdAdd) Or (SelCount = 1) Then Begin
      If (DlgMode <> qmdAdd) Then Begin
        // Retrieve selected Discount Details for View/Edit using the position
        // previously stored in the list view item
        stQtyBreaks.Position := LongInt(Selected.Data);
        FuncRes := RestorePosition;

        //FuncRes := GetEqual(BuildIndex(Selected.Caption, StrToInt(Selected.SubItems[0])));
        If (FuncRes <> 0) Then
          MessageDlg ('The following error occured getting the Quantity Break Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                      mtError, [mbOk], 0);
      End { If (DlgMode <> mdAdd) }
      Else
        // Adding - no need to do anything
        FuncRes := 0;

      If (FuncRes = 0) Then Begin
        // AOK - create Qty Break Detail window
        With TfrmQtyBreak.Create(Self) Do
          Try
            // Position form nicely
            Left := Self.Left + 35;
            Top := Self.Top + 35;

            // Set window mode
            Mode := DlgMode;

            // Set Discount details for detail dialog
            StockCode := FStkDetail.stCode;
            Case DlgMode Of
              qmdAdd  : QtyBreak := stQtyBreaks.Add;
              qmdEdit : QtyBreak := stQtyBreaks.Update;
              qmdView : QtyBreak := stQtyBreaks;         // No clone object available at this time
            End; { Case }

            // Check we got a valid interface
            If Assigned (QtyBreak) Then Begin
              // Display dialog
              ShowModal;

              // Reload list if changes were made
              If NeedRefresh Then PageControl1Change(Self);
            End { If Assigned (DiscDetail) }
            Else
              ShowMessage ('The Quantity Break Detail is not available - someone else may be editing it');
          Finally
            Free;
          End;
      End; { If (FuncRes = 0) }
    End; { If (DlgMode = mdAdd) Or (SelCount = 1) }
end;

{----------------------------------------}

procedure TfrmStockDetail.btnAddQBrkClick(Sender: TObject);
begin
  DisplayQtyBreak (qmdAdd);
end;

{----------------------------------------}

procedure TfrmStockDetail.btnEditQBrkClick(Sender: TObject);
begin
  DisplayQtyBreak (qmdEdit);
end;

{----------------------------------------}

procedure TfrmStockDetail.btnViewQBrkClick(Sender: TObject);
begin
  DisplayQtyBreak (qmdView);
end;

{----------------------------------------}

procedure TfrmStockDetail.DisplayComponent(Const Mode : TComponentDlgMode);
begin
  With FStkDetail, stBillOfMaterials, TfrmBOMDetails.Create(Self) Do
    Try
      Left := Self.Left + ((Self.Width - Width) Div 2);
      Top := Self.Top + ((Self.Height - Height) Div 2);

      Case Mode Of
        cdAdd,
        cdInsert : Begin
                     edtStockCode.Text := '';
                     edtQtyUsed.Text := '0.00';
                   End; { If }
        cdEdit   : With lvKit, blComponent[LongInt(Selected.Data)] Do Begin
                     edtStockCode.Text := Trim(bmStockCode);
                     edtQtyUsed.Text := FloatToStR(bmQuantityUsed);
                   End; { With }
      Else
        Raise Exception.Create ('ComponentDlg: Invalid Dialog Mode');
      End; { Case Mode }

      ShowModal;

      If OK Then Begin
        Case Mode Of
          cdAdd    : AddComponent (edtStockCode.Text, StrToFloat(edtQtyUsed.Text));
          cdEdit   : EditComponent (LongInt(lvKit.Selected.Data), edtStockCode.Text, StrToFloat(edtQtyUsed.Text));
          cdInsert : stBillOfMaterials.InsertComponent(LongInt(lvKit.Selected.Data), edtStockCode.Text, StrToFloat(edtQtyUsed.Text));
        End; { Case Mode }

        // Reload list view
        PageControl1Change(Self)
      End; { If OK }
    Finally
      Free;
    End;
end;

{----------------------------------------}

// Add New component
procedure TfrmStockDetail.btnAddCompClick(Sender: TObject);
begin
  DisplayComponent(cdAdd);
end;

{----------------------------------------}

// Edit existing component
procedure TfrmStockDetail.btnEditCompClick(Sender: TObject);
begin
  DisplayComponent(cdEdit);
end;

{----------------------------------------}

// Insert sub-Component
procedure TfrmStockDetail.btnInsCompClick(Sender: TObject);
begin
  If Assigned(lvKit.Selected) Then
    DisplayComponent(cdInsert)
  Else
    Raise Exception.Create ('A sub-component must be selected in order to insert a new sub-component before it');
end;

{----------------------------------------}

// Delete Sub-Component
procedure TfrmStockDetail.btnDelCompClick(Sender: TObject);
begin
  With lvKit, FStkDetail.stBillOfMaterials Do
    If Assigned(Selected) Then Begin
      If (MessageDlg('Are you sure you want to delete the selected sub-component?',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then Begin
        DeleteComponent(LongInt(Selected.Data));

        // Reload list view
        PageControl1Change(Sender)
      End; {If MessageDlg ... }
    End { If Assigned(Selected) }
    Else
      Raise Exception.Create ('A sub-component must be selected in order to delete it!');
end;

{----------------------------------------}

// Check Component Prices
procedure TfrmStockDetail.btnCompCheckClick(Sender: TObject);
begin
  FStkDetail.stBillOfMaterials.CheckComponentCosts;

  // Reload list view
  PageControl1Change(Sender)
end;

{----------------------------------------}

procedure TfrmStockDetail.DisplaySerial (DlgMode : TSerialDlgMode);
var
  FuncRes   : LongInt;
begin
  With lvSerialNo, oToolkit, FStkDetail, stSerialBatch Do
    // Check 1 item is selected for editing
    If (DlgMode = sdAdd) Or (SelCount = 1) Then Begin
      If (DlgMode <> sdAdd) Then Begin
        // Retrieve selected Serial/Batch Details for View/Edit using
        // the position previously stored in the list view item
        stSerialBatch.Position := LongInt(Selected.Data);
        FuncRes := RestorePosition;
        If (FuncRes <> 0) Then
          MessageDlg ('The following error occured getting the Serial/Batch Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                      mtError, [mbOk], 0);
      End { If (DlgMode <> mdAdd) }
      Else
        // Adding - no need to do anything
        FuncRes := 0;

      If (FuncRes = 0) Then Begin
        // AOK - create Qty Break Detail window
        With TfrmSerialDet.Create(Self) Do
          Try
            // Position form nicely
            Left := Self.Left + 35;
            Top := Self.Top + 35;

            // Set window mode
            Mode := DlgMode;

            // Set Discount details for detail dialog
            Case DlgMode Of
              sdAdd  : SerDetail := stSerialBatch.Add;
              //sdEdit : SerDetail := stSerialBatch.Update;  // HM 12/03/01: Edit not supported at this time
              sdView : SerDetail := stSerialBatch.Clone;
            End; { Case }

            // Check we got a valid interface
            If Assigned (SerDetail) Then Begin
              // Display dialog
              ShowModal;

              // Reload list if changes were made
              If NeedRefresh Then PageControl1Change(Self);
            End { If Assigned (DiscDetail) }
            Else
              ShowMessage ('The Serial/Batch Detail is not available - someone else may be editing it');
          Finally
            Free;
          End;
      End; { If (FuncRes = 0) }
    End; { If (DlgMode = mdAdd) Or (SelCount = 1) }
end;

{----------------------------------------}

procedure TfrmStockDetail.btnAddSerialClick(Sender: TObject);
begin
  DisplaySerial (sdAdd);
end;

{----------------------------------------}

procedure TfrmStockDetail.btnViewSerialClick(Sender: TObject);
begin
  DisplaySerial (sdView);
end;

{----------------------------------------}

procedure TfrmStockDetail.btnSerialNotesClick(Sender: TObject);
var
  FuncRes : LongInt;
begin
  With oToolkit, FStkDetail, stSerialBatch Do
    // Check an item is selected
    If (lvSerialNo.SelCount = 1) Then Begin
      // Retrieve selected Serial/Batch Details for View/Edit using
      // the position previously stored in the list view item
      stSerialBatch.Position := LongInt(lvSerialNo.Selected.Data);
      FuncRes := RestorePosition;

      If (FuncRes = 0) Then
        // Display Notes
        DisplayNotes ('Notes for ' + Trim(snSerialNo), oToolkit, snNotes)
      Else
        MessageDlg ('The following error occured getting the Serial/Batch Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                    mtError, [mbOk], 0);
    End; { If (lvSerialNo.SelCount = 1) }
end;

{----------------------------------------}

procedure TfrmStockDetail.Button1Click(Sender: TObject);
begin
  FStkDetail.stReorder.stReorderQty := 10;
end;

end.


