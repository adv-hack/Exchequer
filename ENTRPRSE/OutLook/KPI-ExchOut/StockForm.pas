unit StockForm;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SBSPanel, StdCtrls, Mask, TEditVal, ExtCtrls, ComCtrls, BorBtns, Grids,
  SBSOutl, Buttons, TCustom, bkgroup, Enterprise01_TLB, KPICommon;

type
  TfrmStock = class(TForm)
    PageControl: TPageControl;
    Main: TTabSheet;
    Defaults: TTabSheet;
    Notes: TTabSheet;
    QtyBreaks: TTabSheet;
    Ledger: TTabSheet;
    TCMPanel: TSBSPanel;
    ClsCP1Btn: TButton;
    SRGSF: Text8Pt;
    SRGCF: Text8Pt;
    SRGVF: Text8Pt;
    SRGWF: Text8Pt;
    SRGPF: Text8Pt;
    SRDepF: Text8Pt;
    SRCCF: Text8Pt;
    SRJAF: Text8Pt;
    SRFSF: Text8Pt;
    SRACF: Text8Pt;
    SRBLF: TExMaskEdit;
    TCMScrollBox: TScrollBox;
    SROOF: TCurrencyEdit;
    SRCF: Text8Pt;
    SRSBox1: TScrollBox;
    Label812: Label8;
    Label813: Label8;
    Label814: Label8;
    Label815: Label8;
    Label816: Label8;
    Label817: Label8;
    SRD1F: Text8Pt;
    SRD2F: Text8Pt;
    SRD3F: Text8Pt;
    SRD4F: Text8Pt;
    SRD5F: Text8Pt;
    SRD6F: Text8Pt;
    SRISF: TCurrencyEdit;
    SRPOF: TCurrencyEdit;
    SRALF: TCurrencyEdit;
    SRFRF: TCurrencyEdit;
    SRCPF: TCurrencyEdit;
    SRRPF: TCurrencyEdit;
    SRTF: TSBSComboBox;
    SRCPCF: TSBSComboBox;
    SRRPCF: TSBSComboBox;
    SRMIF: TCurrencyEdit;
    SRMXF: TCurrencyEdit;
    SRUQF: Text8Pt;
    SRUSF: Text8Pt;
    SRUPF: Text8Pt;
    SRSUF: TCurrencyEdit;
    SRPUF: TCurrencyEdit;
    CLSBox: TScrollBox;
    CLORefLab: TSBSPanel;
    CLDateLab: TSBSPanel;
    CLUPLab: TSBSPanel;
    CLOOLab: TSBSPanel;
    CLQOLab: TSBSPanel;
    CLALLab: TSBSPanel;
    CLQILab: TSBSPanel;
    CLORefPanel: TSBSPanel;
    CLDatePanel: TSBSPanel;
    CLUPPanel: TSBSPanel;
    CLOOPanel: TSBSPanel;
    CLQOPanel: TSBSPanel;
    CLALPanel: TSBSPanel;
    CLQIPanel: TSBSPanel;
    CListBtnPanel: TSBSPanel;
    CLAcPanel: TSBSPanel;
    CLACLab: TSBSPanel;
    CLHedPanel: TSBSPanel;
    TCNScrollBox: TScrollBox;
    TNHedPanel: TSBSPanel;
    NDateLab: TSBSPanel;
    NDescLab: TSBSPanel;
    NUserLab: TSBSPanel;
    NDatePanel: TSBSPanel;
    NDescPanel: TSBSPanel;
    NUserPanel: TSBSPanel;
    TCNListBtnPanel: TSBSPanel;
    QBSBox: TScrollBox;
    QBHedPanel: TSBSPanel;
    QBFLab: TSBSPanel;
    QBYLab: TSBSPanel;
    QBULab: TSBSPanel;
    QBBLab: TSBSPanel;
    QBDLab: TSBSPanel;
    QBVLab: TSBSPanel;
    QBMLab: TSBSPanel;
    QBFPanel: TSBSPanel;
    QBYPanel: TSBSPanel;
    QBDPanel: TSBSPanel;
    QBVPanel: TSBSPanel;
    QBMPanel: TSBSPanel;
    QBUPanel: TSBSPanel;
    QBBPAnel: TSBSPanel;
    QBTPanel: TSBSPanel;
    QBTLab: TSBSPanel;
    SRVMF: TSBSComboBox;
    ValPage: TTabSheet;
    BOMPage: TTabSheet;
    SerPage: TTabSheet;
    VSBox: TScrollBox;
    ValHedPanel: TSBSPanel;
    VOLab: TSBSPanel;
    VDLab: TSBSPanel;
    VILab: TSBSPanel;
    VULab: TSBSPanel;
    VQLab: TSBSPanel;
    VALab: TSBSPanel;
    VOPanel: TSBSPanel;
    VDPanel: TSBSPanel;
    VUPAnel: TSBSPanel;
    VIPanel: TSBSPanel;
    VQPanel: TSBSPanel;
    VAPanel: TSBSPanel;
    SNSBox: TScrollBox;
    SNHedPanel: TSBSPanel;
    SNoLab: TSBSPanel;
    OutLab: TSBSPanel;
    ODLab: TSBSPanel;
    InLab: TSBSPanel;
    BNoLab: TSBSPanel;
    OutPanel: TSBSPanel;
    ODPanel: TSBSPanel;
    SNoPanel: TSBSPanel;
    BNoPanel: TSBSPanel;
    InPanel: TSBSPanel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    NLDPanel: TPanel;
    NLCrPanel: TPanel;
    NLDrPanel: TPanel;
    FullExBtn: TSpeedButton;
    FullColBtn: TSpeedButton;
    NLOLine: TSBSOutlineB;
    SBSPanel5: TSBSPanel;
    Bevel7: TBevel;
    Panel4: TPanel;
    Panel5: TPanel;
    Bevel8: TBevel;
    Label86: Label8;
    GPLab: TPanel;
    Label87: Label8;
    CostLab: TPanel;
    SBSBackGroup1: TSBSBackGroup;
    Label85: Label8;
    SBSBackGroup2: TSBSBackGroup;
    Label828: Label8;
    Label829: Label8;
    Label830: Label8;
    SBSBackGroup3: TSBSBackGroup;
    ValLab: Label8;
    ValLab2: Label8;
    SBSBackGroup4: TSBSBackGroup;
    Label836: Label8;
    Label837: Label8;
    Label838: Label8;
    Label834: Label8;
    Label835: Label8;
    Label827: Label8;
    Label831: Label8;
    Bevel1: TBevel;
    Bevel2: TBevel;
    SBSBackGroup5: TSBSBackGroup;
    Label88: Label8;
    Label89: Label8;
    CCLab: Label8;
    SBSBackGroup7: TSBSBackGroup;
    Label839: Label8;
    Label840: Label8;
    Label841: Label8;
    Label842: Label8;
    Label843: Label8;
    SRBCF: Text8Pt;
    Label811: Label8;
    SRPComboF: TSBSComboBox;
    Label832: Label8;
    SRLocF: Text8Pt;
    Label1: TLabel;
    SRSPF: TBorCheck;
    VLocPanel: TSBSPanel;
    VLocLab: TSBSPanel;
    InLocPanel: TSBSPanel;
    OutLocPanel: TSBSPanel;
    InLocLab: TSBSPanel;
    OutLocLab: TSBSPanel;
    PriceChk: TBorCheck;
    YTDCombo: TSBSComboBox;
    Def2Page: TTabSheet;
    Label810: Label8;
    SRLTF: TSBSComboBox;
    SRVCF: TSBSComboBox;
    VATLab: Label8;
    UD1Lab: Label8;
    UD1F: Text8Pt;
    UD2F: Text8Pt;
    UD2Lab: Label8;
    SGLDF: Text8Pt;
    CGLDF: Text8Pt;
    WGLDF: Text8Pt;
    KGLDF: Text8Pt;
    FGLDF: Text8Pt;
    JADF: Text8Pt;
    Label833: Label8;
    UD3Lab: Label8;
    UD3F: Text8Pt;
    UD4F: Text8Pt;
    UD4Lab: Label8;
    emWebF: TBorCheck;
    Label849: Label8;
    CCodeF: Text8Pt;
    SSUDF: Text8Pt;
    Label850: Label8;
    Label851: Label8;
    SSDUF: TCurrencyEdit;
    SWF: TCurrencyEdit;
    Label852: Label8;
    PWF: TCurrencyEdit;
    Label853: Label8;
    Label847: Label8;
    SRSUP: TCurrencyEdit;
    SRCOF: Text8Pt;
    Label848: Label8;
    SBSBackGroup8: TSBSBackGroup;
    SBSBackGroup9: TSBSBackGroup;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    WIPLab: Label8;
    JALab: Label8;
    SBSBackGroup6: TSBSBackGroup;
    WebCatF: Text8Pt;
    WebImgF: Text8Pt;
    Label826: Label8;
    Label844: Label8;
    Bevel9: TBevel;
    StkCodePanel: TSBSPanel;
    StkCodeLab: TSBSPanel;
    CLAWPanel: TSBSPanel;
    CLIWPanel: TSBSPanel;
    CLAWLab: TSBSPanel;
    CLIWLab: TSBSPanel;
    WOPPage: TTabSheet;
    SBSBackGroup10: TSBSBackGroup;
    Label854: Label8;
    SRPWF: TCurrencyEdit;
    SRIWF: TCurrencyEdit;
    Label845: Label8;
    Label846: Label8;
    SRAWF: TCurrencyEdit;
    Label855: Label8;
    SRGIF: Text8Pt;
    FGLIF: Text8Pt;
    Label856: Label8;
    SBSBackGroup11: TSBSBackGroup;
    Bevel10: TBevel;
    Label857: Label8;
    SRROLTF: TCurrencyEdit;
    Label858: Label8;
    SRASSDF: TCurrencyEdit;
    DefUdF: TSBSUpDown;
    Label859: Label8;
    Label860: Label8;
    SRASSHF: TCurrencyEdit;
    SBSUpDown1: TSBSUpDown;
    Label861: Label8;
    SRASSMF: TCurrencyEdit;
    SBSUpDown2: TSBSUpDown;
    SBSUpDown3: TSBSUpDown;
    CBCalcProdT: TBorCheck;
    BOMTimeLab: Label8;
    BOMTimePanel: TPanel;
    Label862: Label8;
    SRMEBQF: TCurrencyEdit;
    Image5: TImage;
    Label863: Label8;
    EditSPBtn: TSBSButton;
    SRSP1F: TCurrencyEdit;
    Label818: Label8;
    SRGP1: TCurrencyEdit;
    SRMBF: TBorCheck;
    BinPage: TTabSheet;
    MBSBox: TScrollBox;
    MBHedPanel: TSBSPanel;
    MBCLab: TSBSPanel;
    MBILab: TSBSPanel;
    MBOLab: TSBSPanel;
    MBDLab: TSBSPanel;
    MBQLab: TSBSPanel;
    MBLLab: TSBSPanel;
    MBTLab: TSBSPanel;
    MBKLab: TSBSPanel;
    MBIPanel: TSBSPanel;
    MBOPanel: TSBSPanel;
    MBCPanel: TSBSPanel;
    MBQPanel: TSBSPanel;
    MBDPanel: TSBSPanel;
    MBLPanel: TSBSPanel;
    MBTPanel: TSBSPanel;
    MBKPanel: TSBSPanel;
    QBEffPanel: TSBSPanel;
    QBEffLab: TSBSPanel;
    RetPage: TTabSheet;
    SBSBackGroup12: TSBSBackGroup;
    SBSBackGroup13: TSBSBackGroup;
    Label820: Label8;
    Label821: Label8;
    Label822: Label8;
    Label823: Label8;
    SRRPRF: TCurrencyEdit;
    SRRSRF: TCurrencyEdit;
    SRRGLF: Text8Pt;
    SRRGLDF: Text8Pt;
    SRRSWDF: TCurrencyEdit;
    SBSUpDown4: TSBSUpDown;
    SRRMWDF: TCurrencyEdit;
    SBSUpDown5: TSBSUpDown;
    SRRSWMF: TSBSComboBox;
    SRRSMMF: TSBSComboBox;
    Label824: Label8;
    SBSBackGroup14: TSBSBackGroup;
    Label825: Label8;
    CLSRPanel: TSBSPanel;
    CLPRPanel: TSBSPanel;
    CLSRLab: TSBSPanel;
    CLPRLab: TSBSPanel;
    Label864: Label8;
    SRRPGLF: Text8Pt;
    SRRGLPDF: Text8Pt;
    SRRRCF: Text8Pt;
    SRGF: Text8Pt;
    SRGLab: Label8;
    pnlDLLDetails: TPanel;
    lblNoteText: TLabel;
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure pnlDLLDetailsDblClick(Sender: TObject);
  private
    FStock:     IStock2;
    FStockCode: WideString;
    FDataPath:    WideString;
    FToolkit:     IToolkit;
    FToolkitOpen: boolean;
    FCurrency: integer;
    FNoteText: WideString;
    procedure ChangeCaption;
    function  FindStock: boolean;
    procedure HideTabs;
    function  OpenCOMToolkit: boolean;
    procedure PopulateMainTab;
  public
    property Currency: integer read FCurrency write FCurrency;
    property StockCode: WideString read FStockCode write FStockCode;
    property DataPath: WideString read FDataPath write FDataPath;
    property NoteText: WideString read FNoteText write FNoteText;
  end;

procedure ShowStockForm(ADataPath: WideString; AStockCode: WideString; ACurrency: integer; ANoteText: WideString);

Implementation

uses CTKUtil, Math;

Const
    TAB_MAIN      =  0;
    SDefaultPNo   =  1;
    SDef2PNo      =  2;
    SWOPPNo       =  3;
    SRETPNo       =  4;
    SNotesPNo     =  5;
    SQtyBPNo      =  6;
    SLedgerPNo    =  7;
    SValuePNo     =  8;
    SBuildPNo     =  9;
    SSerialPNo    =  10;
    SBinPNo       =  11;

var
  frmStock: TfrmStock;

{$R *.DFM}

procedure ShowStockForm(ADataPath: WideString; AStockCode: WideString; ACurrency: integer; ANoteText: WideString);
begin
  if not assigned(frmStock) then
    frmStock := TfrmStock.Create(nil);

  with frmStock do begin
    DataPath  := ADataPath;
    StockCode := AStockCode;
    Currency  := ACurrency;
    NoteText  := ANoteText;
    PopulateMainTab;
    Show;
  end;
end;

procedure TfrmStock.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action   := caFree;
  frmStock := nil;
end;

procedure TfrmStock.FormCreate(Sender: TObject);
begin
  HideTabs;
end;

procedure TfrmStock.HideTabs;
// All tabs have been left intact. As soon as one is removed it will be requested !
// Instead, we just hide the ones not yet in use....
var
  i: integer;
begin
  for i := 0 to PageControl.PageCount - 1 do
    PageControl.Pages[i].TabVisible := false;

  PageControl.Pages[TAB_MAIN].TabVisible := true; // ...and show the one we need
end;

procedure TfrmStock.ChangeCaption;
begin
  caption := format('Stock Record - %s, %s', [trim(FStock.stCode), trim(FStock.stDesc[1])]);
end;

function TfrmStock.OpenCOMToolkit: boolean;
begin
  if not FToolkitOpen then begin
    FToolkit := OpenToolkit(FDataPath, true); // use backdoor
    if assigned(FToolkit) then
      FToolkitOpen := true
    else
      ShowMessage('Unable to open COM Toolkit');
  end;
  result := FToolkitOpen;
end;

procedure TfrmStock.PopulateMainTab;
var
  i: integer;
  CurrencySymbol: WideString;
  QtyAlloc: double;
  margin: string;

  function Convert(Value: double): double;
  begin
    if FCurrency = 0 then
      result := Value
    else
      with FToolkit.Functions do
        result := entConvertAmount(Value, 0, FCurrency, 0);
  end;
begin
  if not OpenCOMToolkit then exit;
  if not FindStock      then exit;

  ChangeCaption;

  lblNoteText.Caption := FNoteText;

  with FStock, FToolkit, SystemSetup do begin
    SRCF.Text := stCode;                                                        // Stock Code
    SRTF.ItemIndex := Ord(stType);                                              // Stock Type - types hardcoded in items at design-time
    SRD1F.Text := stDesc[1];                                                    // description
    SRD2F.Text := stDesc[2];
    SRD3F.Text := stDesc[3];
    SRD4F.Text := stDesc[4];
    SRD5F.Text := stDesc[5];
    SRD6F.Text := stDesc[6];

    SRPComboF.Clear;
    SRPComboF.Items.Add ('Stock Unit - ' + stUnitOfStock);                      // Priced By
    SRPComboF.Items.Add ('Sales Unit - ' + stUnitOfSale);
    SRPComboF.Items.Add ('Split Pack - ' + stUnitOfSale);
    SRPComboF.ItemIndex := stPricingMethod;

    with stSalesBands['A'] do begin
      CurrencySymbol := ssCurrency[FCurrency].scSymbol; // ssCurrency[stCurrency].scSymbol;
      if trim(CurrencySymbol) = #156 then
        CurrencySymbol := '£';
      SRSP1F.Text := CurrencySymbol + Format ('%0.' + IntToStr(ssSalesDecimals) + 'n', [convert(stPrice)]); // Sales price
      margin := Format ('%0.*n',[ssSalesDecimals, convert(RoundTo(((stPrice - stCostPrice) / stPrice) * 100, -2))]);
      while margin[length(margin)] = '0' do // removing trailing zeroes, alla Exchequer
        delete(margin, length(margin), 1);
      SRGP1.Text :=  margin;                                                    // price margin
    end;


    SRCPCF.Clear;
    for i := 0 to 89 do
      if trim(ssCurrency[i].scSymbol) = #156 then                                     // cost price currency symbols
        SRCPCF.Items.Add ('£')
      else
        SRCPCF.Items.Add (ssCurrency[i].scSymbol);

    SRCPCF.ItemIndex := FCurrency; // stCostPriceCur;                                         // cost price currency
    SRCPF.Text := Format ('%0.' + IntToStr(ssCostDecimals) + 'n', [convert(stCostPrice)]); // cost price

    SRRPCF.Items.Assign(SRCPCF.Items);                                          // reorder price currency symbols
    SRRPCF.ItemIndex := FCurrency ; // stReorder.stReorderCur;                                 // reorder price currency
    SRRPF.Text := Format ('%0.' + IntToStr(ssCostDecimals) + 'n', [convert(stReorder.stReorderPrice)]); // reorder price

    SRVMF.ItemIndex := ord(stValuationMethod);                                  // valuation method - hardcode in items at design-time

    SRMBF.Checked := stUsesBins;                                                // use multi-bins

    SRMIF.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'n', [stQtyMin]);   // Minimum Stock Qty
    SRMXF.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'n', [stQtyMax]);   // Maximum Stock Qty

    // Calculate stock levels
    If ssPickingOrderAllocatesStock Then QtyAlloc := stQtyPicked Else QtyAlloc := stQtyAllocated;
    SRISF.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'n', [stQtyInStock]); // Qty in Stock
    SRPOF.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'n', [stQtyPosted]);  // Qty Posted
    SRALF.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'n', [QtyAlloc]);     // Qty Allocated
    SRFRF.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'n', [stQtyFree]);    // Qty Free
    SROOF.Text := Format ('%0.' + IntToStr(ssQtyDecimals) + 'n', [stQtyOnOrder]); // Qty on Order

    SRSPF.Checked := stShowQtyAsPacks;                                          // Show Stock Qty as packs
  end;

  FToolkit.CloseToolkit;
  FStock   := nil;
  FToolkit := nil;
  FToolkitOpen := false;
end;

function TfrmStock.FindStock: boolean;
var
  res: integer;
begin
  FStock := FToolkit.Stock as IStock2;

  with FStock do begin
    Index := stIdxCode;
    res := GetEqual(BuildCodeIndex(FStockCode));
    if res <> 0 then begin
      ShowMessage(format('Unable to access stock record for %s', [FStockCode]));
      result := false;
    end
    else
      result := true;
  end;
end;

procedure TfrmStock.ClsCP1BtnClick(Sender: TObject);
begin
  close;
end;

procedure TfrmStock.pnlDLLDetailsDblClick(Sender: TObject);
begin
  Height := Height + 10;
  PageControl.Height := PageControl.Height + 10;
  pnlDLLDetails.Height := pnlDLLDetails.Height + 10;
  ShowDLLDetails(Sender, pnlDLLDetails.Color, true);
  if lblNoteText.Caption <> '' then lblNoteText.Visible := false;
end;

Initialization
  frmStock := nil;

end.
