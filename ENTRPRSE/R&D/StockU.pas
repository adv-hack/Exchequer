{$A+,B-,C-,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O-,P+,Q-,R+,S+,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
unit StockU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,ADOConnect,
  SBSPanel, StdCtrls, Mask, TEditVal, ExtCtrls, ComCtrls, BorBtns,SQLUtils,SQLCallerU,StrUtils,
  GlobVar,VarConst,VarRec2U,BtrvU2,BTSupU1,ExWrap1U, SupListU, EntWindowSettings,IndeterminateProgressF,

  {$IFDEF NP}
    NoteU,
    DiarLstU,
  {$ENDIF}

  {$IFDEF PF_On}

    StkBOMIU,
    StkValU,
    StkQtyU,
    CuStkA4U,
  {$ENDIF}

  SBSComp2,
  SalTxl1U,
  Recon3U,

  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  {$IFDEF SOP}
    StkSerNU,

    AltCLs2U,

  {$ENDIF}

  StkBinU,

  StkPricU,
  ExtGetU,

  VarSortV,
  SortStk,

  {$IFDEF CU}
  // 28/01/2013 PKR ABSEXCH-13449
  // Custom buttons 3..6 now available
  CustomBtnHandler,
  {$ENDIF}

  // MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  WindowExport, ExportListIntf, oExcelExport,

  Menus, Buttons, Grids, SBSOutl, bkgroup, TCustom, AdvGlowButton,
  AdvToolBar, AdvToolBarStylers, MBDFrame, MathUtil, CheckBoxEx;


Const
    SMainPNo      =  0;
    SDefaultPNo   =  1;
    // MH 18/05/2016 2016-R2 ABSEXCH-17470: Added Tax Codes tab for MRT
    STaxPNo       =  2;
    SDef2PNo      =  3;
    SWOPPNo       =  4;
    SRETPNo       =  5;
    SNotesPNo     =  6;
    SQtyBPNo      =  7;
    SMultiBuyPNo  =  8;
    SLedgerPNo    =  9;
    SValuePNo     =  10;
    SBuildPNo     =  11;
    SSerialPNo    =  12;
    SBinPNo       =  13;




type
  TSLMList  =  Class(TDDMList)
  private
    function GetSortView: TStockLedgerSortView;
    procedure SetSortView(const Value: TStockLedgerSortView);
  Public
    TSales,
    TCost,
    TProfit  :  Real;
    CListFilt:  Str10;

    StkLIsaC,
    CCNomMode,
    FiltSet  :  Boolean;

    CCNomFilt:  Str10;

    OrigKey  :  Str255;

    StkExtRecPtr
             :  ExtStkRecPtr;

    StkExtObjPtr
             :  GetNomMode;

    LNHCtrl  :  TNHCtrlRec;

    { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
    UseDefaultSortView: Boolean;

    Procedure ExtObjCreate; Override;

    Procedure ExtObjDestroy; Override;

    Function ExtFilter  :  Boolean; Override;

    Function FindExtCuStk(B_End      :  Integer;
                      Var KeyS       :  Str255)  :  Integer;

    Function GetExtList(B_End      :  Integer;
                    Var KeyS       :  Str255)  :  Integer; Override;



    Function SetCheckKey  :  Str255; Override;

    Function CStkCCDFiltSet  :  Boolean;

    Function ChkCCDFilter(ICCDP     :  CCDepType)  :  Boolean;

    Function GetStkLBFilt(RStr  :  Str255;
                          IdR   :  Idetail)  :  Str255;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Procedure Link2Inv;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Procedure Set_CurrencyFilt;

    Procedure SetNewLIndex;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SortView: TStockLedgerSortView read GetSortView write SetSortView;

  end;


type
  TStockRec = class(TForm)
    PageControl1: TPageControl;
    Main: TTabSheet;
    Defaults: TTabSheet;
    Notes: TTabSheet;
    QtyBreaks: TTabSheet;
    Ledger: TTabSheet;
    TCMPanel: TSBSPanel;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    ClsCP1Btn: TButton;
    TCMBtnScrollBox: TScrollBox;
    EditCP1Btn: TButton;
    DelCP1Btn: TButton;
    FindCP1Btn: TButton;
    HistCP1Btn: TButton;
    AddCP1Btn: TButton;
    CopyCP1Btn: TButton;
    ViewCP1Btn: TButton;
    ChkCP1Btn: TButton;
    PrnCP1Btn: TButton;
    InsCP1Btn: TButton;
    GenCP3Btn: TButton;
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
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Insert1: TMenuItem;
    Delete1: TMenuItem;
    Find1: TMenuItem;
    Hist1: TMenuItem;
    Switch1: TMenuItem;
    Print1: TMenuItem;
    View1: TMenuItem;
    Copy1: TMenuItem;
    Check1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    PopupMenu2: TPopupMenu;
    Copy2: TMenuItem;
    Reverse1: TMenuItem;
    ValPage: TTabSheet;
    BOMPage: TTabSheet;
    SerPage: TTabSheet;
    UCP1Btn: TButton;
    Use1: TMenuItem;
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
    NLDPanel: TPanel;
    NLCrPanel: TPanel;
    NLDrPanel: TPanel;
    NLOLine: TSBSOutlineB;
    SBSPanel5: TSBSPanel;
    Bevel7: TBevel;
    Panel4: TPanel;
    OptBtn: TButton;
    PopupMenu3: TPopupMenu;
    MIRec: TMenuItem;
    Edit2: TMenuItem;
    Add2: TMenuItem;
    Del2: TMenuItem;
    Expand1: TMenuItem;
    MIETL: TMenuItem;
    MIEAL: TMenuItem;
    EntireGeneralLedger1: TMenuItem;
    MIColl: TMenuItem;
    MICTL: TMenuItem;
    EntireGeneralLedger2: TMenuItem;
    MenuItem5: TMenuItem;
    Pop1: TMenuItem;
    MenuItem7: TMenuItem;
    Save1: TMenuItem;
    N3: TMenuItem;
    WUsed2: TMenuItem;
    Build1: TMenuItem;
    Check2: TMenuItem;
    I1StatLab: Label8;
    PopupMenu4: TPopupMenu;
    SN1: TMenuItem;
    BN1: TMenuItem;
    DN1: TMenuItem;
    PopupMenu5: TPopupMenu;
    ID1: TMenuItem;
    OD1: TMenuItem;
    PopupMenu6: TPopupMenu;
    CFrom1: TMenuItem;
    CTo1: TMenuItem;
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
    VLocPanel: TSBSPanel;
    VLocLab: TSBSPanel;
    InLocPanel: TSBSPanel;
    OutLocPanel: TSBSPanel;
    InLocLab: TSBSPanel;
    OutLocLab: TSBSPanel;
    SnoSo1: TMenuItem;
    SnoPo1: TMenuItem;
    LnkCp1Btn: TButton;
    Links1: TMenuItem;
    Links2: TMenuItem;
    NteCP1Btn: TButton;
    Notes1: TMenuItem;
    YTDCombo: TSBSComboBox;
    Altdb1Btn: TButton;
    AltCodes1: TMenuItem;
    PopupMenu7: TPopupMenu;
    Account1: TMenuItem;
    OSOrders1: TMenuItem;
    PickedOrders1: TMenuItem;
    AllOrders1: TMenuItem;
    DeliveryNotes1: TMenuItem;
    Transactions1: TMenuItem;
    NoFillter1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    SalesOrdersOS1: TMenuItem;
    PurchOrdersOS1: TMenuItem;
    SalesOrders1: TMenuItem;
    PurchOrders1: TMenuItem;
    SalesDeliveryNote1: TMenuItem;
    PurchDeliveryNote1: TMenuItem;
    SalesTransactions1: TMenuItem;
    PurchTransactions1: TMenuItem;
    AdjTransactions1: TMenuItem;
    StkCuBtn1: TSBSButton;
    StkCuBtn2: TSBSButton;
    Custom1: TMenuItem;
    Custom2: TMenuItem;
    EntCustom3: TCustomisation;
    Custom3: TMenuItem;
    Custom4: TMenuItem;
    Def2Page: TTabSheet;
    Label810: Label8;
    SRLTF: TSBSComboBox;
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
    lblLineType: Label8;
    UD3Lab: Label8;
    UD3F: Text8Pt;
    UD4F: Text8Pt;
    UD4Lab: Label8;
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
    Insert2: TMenuItem;
    StkCodePanel: TSBSPanel;
    StkCodeLab: TSBSPanel;
    StockRecord1: TMenuItem;
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
    BOMTimeLab: Label8;
    BOMTimePanel: TPanel;
    Label862: Label8;
    SRMEBQF: TCurrencyEdit;
    WorksOrders1: TMenuItem;
    Image5: TImage;
    Label863: Label8;
    EditSPBtn: TSBSButton;
    SRSP1F: TCurrencyEdit;
    Label818: Label8;
    SRGP1: TCurrencyEdit;
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
    PopupMenu10: TPopupMenu;
    DelDisc1: TMenuItem;
    DelDisc2: TMenuItem;
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
    RetSRN1: TMenuItem;
    RetPRN1: TMenuItem;
    RetALL1: TMenuItem;
    CLSRPanel: TSBSPanel;
    CLPRPanel: TSBSPanel;
    CLSRLab: TSBSPanel;
    CLPRLab: TSBSPanel;
    Label864: Label8;
    SRRPGLF: Text8Pt;
    SRRGLPDF: Text8Pt;
    RetCP1Btn: TButton;
    Return1: TMenuItem;
    PopupMenu8: TPopupMenu;
    RetId1: TMenuItem;
    RetOd1: TMenuItem;
    SRRRCF: Text8Pt;
    SRGLab: Label8;
    AdvStyler: TAdvToolBarOfficeStyler;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    FullExBtn: TAdvGlowButton;
    FullColBtn: TAdvGlowButton;
    Panel7: TPanel;
    Panel8: TPanel;
    ClsI1Btn: TButton;
    Label86: Label8;
    GPLab: TPanel;
    Label87: Label8;
    CostLab: TPanel;
    tabMultiBuy: TTabSheet;
    SortViewBtn: TButton;
    SortViewPopupMenu: TPopupMenu;
    RefreshView1: TMenuItem;
    CloseView1: TMenuItem;
    MenuItem1: TMenuItem;
    SortViewOptions1: TMenuItem;
    SortView1: TMenuItem;
    RefreshView2: TMenuItem;
    CloseView2: TMenuItem;
    N6: TMenuItem;
    SortViewOptions2: TMenuItem;
    mbdFrame: TMultiBuyDiscountFrame;
    ReadOnlyView1: TMenuItem;
    UD5F: Text8Pt;
    UD6F: Text8Pt;
    UD7F: Text8Pt;
    UD8F: Text8Pt;
    UD9F: Text8Pt;
    UD10F: Text8Pt;
    UD5Lab: Label8;
    UD6Lab: Label8;
    UD7Lab: Label8;
    UD8Lab: Label8;
    UD9Lab: Label8;
    UD10Lab: Label8;
    PMenu_Notes: TPopupMenu;
    MenItem_General: TMenuItem;
    MenItem_Dated: TMenuItem;
    MenItem_Audit: TMenuItem;
    lblStockCode: Label8;
    StkCuBtn3: TSBSButton;
    StkCuBtn4: TSBSButton;
    StkCuBtn5: TSBSButton;
    StkCuBtn6: TSBSButton;
    Custom5: TMenuItem;
    Custom6: TMenuItem;
    Custom7: TMenuItem;
    Custom8: TMenuItem;
    Custom9: TMenuItem;
    Custom10: TMenuItem;
    Custom11: TMenuItem;
    Custom12: TMenuItem;
    tabshTax: TTabSheet;
    lblWebSettingsTitle: TLabel;
    bevWebSettingsTitle: TBevel;
    lblDefaultLineTypeTitle: TLabel;
    bevDefaultLineTypeTitle: TBevel;
    lblUserDefinedFieldsTitle: TLabel;
    bevUserDefinedFieldsTitle: TBevel;
    emWebF: TCheckBoxEx;
    SRMBF: TCheckBoxEx;
    SRSPF: TCheckBoxEx;
    CBCalcProdT: TCheckBoxEx;
    PriceChk: TCheckBoxEx;
    panECServices: TPanel;
    lblECServiceTitle: TLabel;
    bevECService: TBevel;
    chkECService: TCheckBoxEx;
    panIntrastatSettings: TPanel;
    lblIntrastatSettingsTitle: TLabel;
    bevIntrastatSettingsTitle: TBevel;
    Label849: Label8;
    Label850: Label8;
    Label851: Label8;
    Label852: Label8;
    Label853: Label8;
    Label847: Label8;
    Label848: Label8;
    Label819: Label8;
    CCodeF: Text8Pt;
    SSUDF: Text8Pt;
    SSDUF: TCurrencyEdit;
    SWF: TCurrencyEdit;
    PWF: TCurrencyEdit;
    SRSUP: TCurrencyEdit;
    ccyIntrastatArrivalsPerc: TCurrencyEdit;
    SRCOF: Text8Pt;
    panTaxCodes: TPanel;
    lblTaxCodeTitle: TLabel;
    Bevel5: TBevel;
    lblDefaultTaxCode: Label8;
    cbTaxCode: TSBSComboBox;
    SBSBckGrpStkGrp: TSBSBackGroup;
    lblStkGrp: TLabel;
    WindowExport: TWindowExport;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure SRCFExit(Sender: TObject);
    procedure SRMXFExit(Sender: TObject);
    procedure EditCP1BtnClick(Sender: TObject);
    procedure DelCP1BtnClick(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure ViewCP1BtnClick(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure SRTFExit(Sender: TObject);
    procedure SRTFEnter(Sender: TObject);
    procedure SRFSFExit(Sender: TObject);
    procedure SRCCFExit(Sender: TObject);
    procedure SRGSFExit(Sender: TObject);
    procedure SRJAFExit(Sender: TObject);
    procedure SRVMFExit(Sender: TObject);
    procedure SRSBox1Exit(Sender: TObject);
    procedure CLORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CLORefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CLORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GenCP3BtnClick(Sender: TObject);
    procedure HistCP1BtnClick(Sender: TObject);
    procedure FindCP1BtnClick(Sender: TObject);
    procedure CopyCP1BtnClick(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure NLOLineExpand(Sender: TObject; Index: Longint);
    procedure NLOLineNeedValue(Sender: TObject);
    procedure FullExBtnClick(Sender: TObject);
    procedure WUsed2Click(Sender: TObject);
    procedure OptBtnClick(Sender: TObject);
    procedure PopupMenu3Popup(Sender: TObject);
    procedure YTDChkClick(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure SRUQFChange(Sender: TObject);
    procedure Check2Click(Sender: TObject);
    procedure UCP1BtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SN1Click(Sender: TObject);
    procedure ID1Click(Sender: TObject);
    procedure SNoPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SNoLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SNoLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CFrom1Click(Sender: TObject);
    procedure CTo1Click(Sender: TObject);
    procedure ChkCP1BtnClick(Sender: TObject);
    procedure PrnCP1BtnClick(Sender: TObject);
    procedure MIEALClick(Sender: TObject);
    procedure SRD1FKeyPress(Sender: TObject; var Key: Char);
    procedure SRLocFExit(Sender: TObject);
    procedure PopupMenu5Popup(Sender: TObject);
    procedure LnkCp1BtnClick(Sender: TObject);
    procedure NteCP1BtnClick(Sender: TObject);
    procedure Altdb1BtnClick(Sender: TObject);
    procedure Account1Click(Sender: TObject);
    procedure StkCuBtn1Click(Sender: TObject);
    procedure SRMIFEnter(Sender: TObject);
    procedure SRMXFEnter(Sender: TObject);
    procedure SRMIFExit(Sender: TObject);
    procedure UD1FExit(Sender: TObject);
    procedure UD1FEntHookEvent(Sender: TObject);
    procedure StockRecord1Click(Sender: TObject);
    procedure NLOLineUpdateNode(Sender: TObject; var Node: TSBSOutLNode;
      Row: Integer);
    procedure DefUdFMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SRPUFExit(Sender: TObject);
    procedure EditSPBtnClick(Sender: TObject);
    procedure SRSP1FExit(Sender: TObject);
    procedure SRBLFEnter(Sender: TObject);
    procedure SRBLFMaskError(Sender: TObject);
    procedure SRBLFSetFocusBack(Sender: TObject; var bSetFocus: Boolean);
    procedure DelDisc1Click(Sender: TObject);
    procedure RetCP1BtnClick(Sender: TObject);
    procedure RetId1Click(Sender: TObject);
    procedure PopupMenu8Popup(Sender: TObject);
    procedure SRRRCFExit(Sender: TObject);
    procedure SRFSFEnter(Sender: TObject);
    procedure RefreshView1Click(Sender: TObject);
    procedure CloseView1Click(Sender: TObject);
    procedure SortViewOptions1Click(Sender: TObject);
    procedure SortViewBtnClick(Sender: TObject);
    procedure mbdFramescrMBDListDblClick(Sender: TObject);
    procedure SRASSMFChange(Sender: TObject);
    procedure SRASSHFChange(Sender: TObject);
    procedure SRASSDFChange(Sender: TObject);
    procedure SRROLTFChange(Sender: TObject);
    procedure ReadOnlyView1Click(Sender: TObject);
    procedure MenItem_GeneralClick(Sender: TObject);
    procedure MenItem_DatedClick(Sender: TObject);
    procedure MenItem_AuditClick(Sender: TObject);
    procedure SRTFChange(Sender: TObject);
    procedure PWFExit(Sender: TObject);
    procedure SRCOFExit(Sender: TObject);
    procedure cbTaxCodeExit(Sender: TObject);
    function WindowExportEnableExport: Boolean;
    procedure WindowExportExecuteCommand(const CommandID: Integer; Const ProgressHWnd : HWnd);
    function WindowExportGetExportDescription: String;
   private
    { Private declarations }

    HideDAdd,
    ManClose,
    InHBeen,
    InBOM,
    BomMode,
    InPageChanging,
    StopPageChange,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    fNeedCUpdate,
    FColorsChanged,
    fDoingClose,
    fFrmClosing,
    fSortLocBin,
    CanDelete  :  Boolean;

    LastHMode,
    ListOfSet  :  Byte;

    LastBTag,
    LastYTDII,
    LastSType,
    SKeypath   :  Integer;

    BOMKey     :  Array[BOff..BOn] of SmallInt;

    BOMFolio,
    Lab1Ofset,
    Lab2Ofset,
    Lab3Ofset,
    Lab4Ofset,
    ChrWidth     :   LongInt;

    LastQtyMin,
    LastQtyMax,
    ChrsXross    :   Double;

    ColXAry      :   Array[1..2] of LongInt;


    {$IFDEF NP}
      NotesCtrl  :  TNoteCtrl;
      SNoteCtrl  :  TDiaryList;
    {$ENDIF}

    {$IFDEF PF_On}
      BOMRec   :  TBOMRec;

      ValRec   :  TStkValEdit;
      QtyRec   :  TStkQtyRec;
      NewBomStkCode
               :  Str20;
      ShowNewBomIndex
               :  Integer;

        
    {$ENDIF}

    {$IFDEF SOP}
      SerRec   :  TStkSerNo;
      AltCList :  TAltCList;
    {$ENDIF}

    {$IFDEF Ltr}
      LetterActive: Boolean;
      LetterForm:   TLettersList;
    {$ENDIF}

    BStock     :  StockRec;

    Prices     :  TPrices;

    PageP,
    ScrollAP,
    ScrollBP,
    Misc1P     :  TPoint;

    PagePoint  :  Array[0..4] of TPoint;

    StartSize,
    InitSize   :  TPoint;


    MULCtrlO   :  Array[SQtyBPNo..SBinPNo] of TSLMList;

    MULCtrlO2  :  Array[SQtyBPNo..SBinPNo] of TSNoList;

    InvBtnList :  TVisiBtns;

    DescCList  :  TDetCtrl;

    DispTransPtr
               :  Pointer;

    {$IFDEF CU}
    // 28/01/2013  PKR   ABSEXCH-13449/38
    FormPurpose : TFormPurpose;
    RecordState : TRecordState;
    {$ENDIF}

    // MH 18/05/2016 2016-R2 ABSEXCH-17470: Record minimum sizes for MinMaxInfo
    MinWindowWidth, MinWindowHeight : Integer;

    // CJS: 14/12/2010 - Amendments for new Window Settings system
    FSettings: IWindowSettings;
    procedure LoadLedgerListSettings(ListNo: Integer);
    procedure SaveLedgerListSettings(ListNo: Integer);
    procedure LoadSerialListSettings(ListNo: Integer);
    procedure SaveSerialListSettings(ListNo: Integer);
    procedure LoadWindowSettings;
    procedure SaveWindowSettings;
    procedure EditLedgerWindowSettings(ListNo: Integer);
    procedure EditSerialWindowSettings(ListNo: Integer);

    procedure BuildCtrlLists;

    procedure DefaultPageReSize;

    {$IFDEF PF_On}
      procedure SNoPageReSize;
    {$ENDIF}

    procedure NotePageReSize;

    procedure BOMPageReSize;

    Procedure NoteUpdate;

    Function ScanMode  :  Boolean;


    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    procedure LedgerBuildList(PageNo     :  Byte;
                              ShowLines  :  Boolean);

    {$IFDEF SOP}

      procedure SNoBuildList(PageNo     :  Byte;
                             ShowLines  :  Boolean);

      //PR: 30/03/2009 Function to build list for multi-buy discounts
      procedure MultiBuyBuildList(PageNo     :  Byte;
                                  ShowLines  :  Boolean);

    {$ENDIF}

    procedure BINBuildList(PageNo     :  Byte;
                           ShowLines  :  Boolean);

    {$IFDEF PF_On}

      procedure ValBuildList(PageNo     :  Byte;
                             ShowLines  :  Boolean);

      procedure QBBuildList(PageNo     :  Byte;
                            ShowLines  :  Boolean);

      procedure RefreshValList(ShowLines,
                               IgMsg      :  Boolean);

    {$ENDIF}

    procedure Display_Trans(Mode  :  Byte);

    procedure BuildDesign;

    procedure AddCP3BtnClick(Sender: TObject);

    procedure DelCP3BtnClick(Sender: TObject);


    procedure SetCompRO(TC     :  TComponent;
                  Const TG     :  Integer;
                  Const EnabFlg:  Boolean);

    Procedure Set_MBin(PTMode  :  Byte);

    Procedure Move_BinMode;

    Procedure Set_EntryRO(PTMode  :  Byte);

    Procedure FindCustCode;

    {$IFDEF RET}
      procedure Create_Return;

    {$ENDIF}

    Procedure Copy_BOM(StockR    :  StockRec;
                       NewCode   :  Str20;
                       Fnum2,
                       Keypath2  :  Integer);

    Procedure Control_BOMCopy(Fnum,
                              KeyPath  :  Integer);


    {$IFDEF PF_On}

      Procedure ClearBOMPage;

      Function  EquivSTItem  :  Integer;

      Function GLFilterMode(Sender  :  TObject;
                            Mode    :  Byte)  :  Byte;

      Function Min_Gp  :  Double;

      Procedure OutCost;

      Function FormatLine(ONomRec  :  OutNomType;
                          LineText :  String)  :  String;

      Procedure Add_OutLines(Depth,
                             DepthLimit,
                             OIndex,
                             StkFolio      :   LongInt;
                       Const Fnum,
                             Keypath       :   Integer);


      Procedure Update_OutLines(Const Fnum,
                                      Keypath       :   Integer);

      Procedure Drill_OutLines(Depth,
                               DepthLimit,
                               PIndex      :  LongInt);

      Procedure Delete_OutLines(PIndex      :  LongInt;
                                DelSelf     :  Boolean);

      Procedure UpDateFromBOM;

      Procedure AddEditLine(Edit,
                            DelMode  :  Boolean);

      procedure Display_BomRec(Mode  :  Byte);

      Function GetSelBOM  :  Boolean;

      Procedure Re_CalcCostPrice(Ask4P :  Boolean);

      procedure Display_ValRec(Mode  :  Byte);
      procedure Display_QtyRec(Mode  :  Byte);

    {$ENDIF}

    {$IFDEF SOP}

     procedure Display_SerRec(Mode  :  Byte);

     Procedure Set_SerNoUse;

     procedure Link2AltC(ScanMode  :  Boolean);

    {$ENDIF}


    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;


    procedure Get_SNotes;


    {$IFDEF NP}
      Procedure SNoteUpdate(NewLineNo  :  LongInt);
    {$ENDIF}


    procedure OutPrices;

    procedure ShowSortViewDlg;
    procedure SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
    procedure ToggleSerialTabEditButton;

    Procedure SetECServiceVisibility (Const StockType : Char);

    // MH 18/05/2016 2016-R2 ABSEXCH-17470: Re-arrrange Web/User field to optimise user defined fields
    procedure Hide_eBusinessFields;
    // MH 18/05/2016 2016-R2 ABSEXCH-17470: Added Tax Codes tab for MRT
    procedure ReOrgTaxPanels;
  public
    { Public declarations }

    InSerModal,
    InSerFind,
    SerUseMode,
    InBINModal,
    InBINFind,
    BINUseMode,
    CQtyBMode,
    FromHist     :  Boolean;

    SerRetMode,
    SerFindMode  :  Byte;

    DocCostP,
    SerialReq    :  Double;

    SRecLocFilt  :  Str10;

    Level_Code   :  Str20;

    SerMainK     :  Str255;

    DDCtrl       :  TNHCtrlRec;

    ExLocal      :  TdExLocal;

    HistFormPtr  :  Pointer;

    BinMoveMode,
    stkStopAutoLoc
                 :  Boolean;

    BinRec       :  TStkBinNo;

    //PR: 07/02/2012 ABSEXCH-9795
    CustDiscountRec : CustDiscType;


    Function Current_BarPos(PageNo  :  Byte)  :  Integer;

    procedure HidePanels(PageNo    :  Byte);

    Function SetDelBtn  :  Boolean;

    Function ChkPWord(PageNo :  Integer;
                      Pages  :  TIntSet;
                      HelpS  :  LongInt) :  LongInt;

    Function ChkPWord3(PageNo :  Integer;
                       Pages  :  TIntSet;
                       HelpS,
                       PW2,
                       PW3,
                       PW4,
                       PW5    :  LongInt) :  LongInt;



    Function SetHelpC(PageNo :  Integer;
                      Pages  :  TIntSet;
                      Help0,
                      Help1,
                      Help2,
                      Help3,
                      Help4,
                      Help5,
                      Help6,
                      Help7,
                      Help8,
                      Help9,
                      Help10,
                      Help11   :  LongInt) :  LongInt;

    procedure PrimeButtons;

    procedure SetTabs;

    procedure BuildMenus;

    procedure FormDesign;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    procedure Find_LedgCoord(PageNo  :  Integer);
    procedure Store_LedgCoord(UpMode  :  Boolean);


    procedure Find_ValCoord(PageNo  :  Integer);
    procedure Store_ValCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Function Current_Page  :  Integer;

    Procedure SetPricing;

    Function CalcGP(BNo  :  Byte)  :  Double;

    procedure Out_GLDesc(GLCode  :  Str20;
                         OutObj  :  TObject;
                         ItsJA   :  Boolean);

    procedure Show_GLDesc(Sender: TObject);

    Procedure OutStock;
    Procedure Form2Stock;


    Function ISProdMode(ProdType  :  Char;
                        Mode      :  Char)  :  Boolean;

    Procedure SetFieldFocus;

    Procedure ChangePage(NewPage  :  Integer);

    Function CheckNeedStore  :  Boolean;

    Function AllocateOk(ShowMsg  :  Boolean)  :  Boolean;

    Function ConfirmQuit  :  Boolean;

    Function CheckListFinished  :  Boolean;

    Procedure SetCaption;

    Procedure OutSerialReq;

    procedure FiltLoc(Sender  :  TObject;
                      Mode    :  Byte);

    procedure ShowLink;

    Function Auto_GetSCode(CCode    :  Str20;
                           Fnum,
                           Keypath  :  Integer)  :  Str20;

    procedure SetStockStore(EnabFlag,
                            ButnFlg  :  Boolean);

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure ProcessStock(Fnum,
                          KeyPAth    :  Integer;
                          Edit       :  Boolean);

    Function CheckCompleted(Edit  :  Boolean)  : Boolean;


    Procedure Change_StockType(OldTyp,NewTyp  :  Char;
                           Var StockR         :  StockRec);

    {$IFDEF SOP}
      procedure Create_AutoBins;
    {$ENDIF}

    procedure StoreStock(Fnum,
                         KeyPAth    :  Integer;
                         Edit       :  Boolean);


    procedure EditAccount(Edit  :  Boolean);

    procedure DeleteAccount;

    procedure SetFieldProperties;

    procedure SetFormProperties;

    Function CheckLedgerFiltStatus  :  Boolean;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure Display_History(HistMode     :  Byte;
                              ChangeFocus  :  Boolean);

    procedure Display_BinRec(Mode  :  Byte);
    Procedure Set_BinUse;

    {$IFDEF PF_On}
      procedure BOMBuildPage;
    {$ENDIF}

    Procedure DeleteQtyBreakLinks (Code  :  AnyStr;
                                   Fnum  :  Integer;
                                   KLen  :  Integer;
                                   KeyPth:  Integer);


  end;


Procedure Set_DDFormMode(State  :  TNHCtrlRec);

Function Check_B2BStatus(IdR    :  Idetail;
                         InvR   :  InvRec;
                         MLCtrl :  MLocRec)  :  Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  CmpCtrlU,
  ColCtrlU,
  SBSComp,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  ComnUnit,
  ComnU2,
  CurrncyU,

  SysU1,

  InvListU,

  {$IFDEF GF}
    FindRecU,
    FindCtlU,
  {$ENDIF}

  {$IFDEF PF_On}

    {$IFDEF STK}
      {$IFDEF MC_On}
        DiscU3U,
      {$ENDIF}

      DiscU4U,

      {$IFDEF SOP}
        InvLst3U,
        StkSNRIU,

        BINSVCU,
      {$ENDIF}
    {$ENDIF}

  {$ENDIF}


  InvCTSUU,
  {InvFSu3U,}

  {$IFDEF NP}
    NoteSupU,
  {$ENDIF}

  {$IFDEF NOM}
    HistWinU,
  {$ENDIF}

  ConvDocU,
  Tranl1U,
  {StkIntU,}
  PayF2U,

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  {$IFDEF POST}
    ReValueU,
    PostSp2U,
  {$ENDIF}

  {$IFDEF Ltr}
    MSWord95,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,
  {$ENDIF}

  {$IFDEF VAT}
    GIRateU,
  {$ENDIF}

  {$IFDEF WOP}
    WOPCT1U,

  {$ENDIF}

  {$IFDEF RET}
    RetWiz1U,
    RetSup1U,
  {$ENDIF}

  DelQDiscU,

  SortViewOptionsF,

  ThemeFix,

  GenWarnU,
  ExThrd2U,
  PWarnU,
  SysU3,
  SysU2,
  BOMKitWarnF,
  CustomFieldsVar,
  CustomFieldsIntf,
  CustAbsU,
  AuditNotes,
  CustIntU,

  //PR: 06/02/2012 ABSEXCH-9795
  QtyBreakVar,

  JobSup1U,

  {$IFDEF SOP}
    // MH 12/11/2014 Order Payments: Added confirmation checks for Order Payment Transactions being Reversed
    PasswordAuthorisationF,
  {$ENDIF SOP}

  //PR: 17/02/2014 ABSEXCH-14477 Moved Change_Hist procedure to Funcs\HistoryFuncs.pas to allow use by COM Toolkit.
  HistoryFuncs,
  MiscU;

{$R *.DFM}

Const
  InitWidth  =  118;
  TDpth      =  70;


{$I SLTi1U.Pas}

Var
  DDFormMode  :  TNHCtrlRec;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_DDFormMode(State  :  TNHCtrlRec);

Begin

  DDFormMode:=State;

end;



Function TStockRec.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PageControl1);

end;



procedure TStockRec.Find_LedgCoord(PageNo  :  Integer);


Var
  n       :  Integer;

  GlobComp:  TGlobCompRec;


Begin
  // CJS: 14/12/2010 - Amendments for new Window Settings system
  LoadLedgerListSettings(PageNo);
  (*
  If (MULCtrlO[PageNo]<>nil) then
  With MULCtrlO[PageNo] do
  Begin

    New(GlobComp,Create(BOn));

    With GlobComp^ do
    Begin
      GetValues:=BOn;

      PrimeKey:='K';

      HasCoord:=LastCoord;


      Find_ListCoord(GlobComp);

    end; {With GlobComp..}


    Dispose(GlobComp,Destroy);

  end;
  *)
end;


procedure TStockRec.Store_LedgCoord(UpMode  :  Boolean);


Var
  n       :  Byte;
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin

    GetValues:=UpMode;

    SaveCoord:=StoreCoord;

    PrimeKey:='K';

    For n:=Low(MULCtrlO) to High(MULCtrlO) do
    If (MULCtrlO[n]<>nil) {and ((SaveCoord) or (Not UpMode))} then
      // CJS: 14/12/2010 - Amendments for new Window Settings system
      // MULCtrlO[n].Store_ListCoord(GlobComp);
      SaveLedgerListSettings(n);

  end; {With GlobComp..}

  GlobComp.Destroy;
end;


procedure TStockRec.Find_ValCoord(PageNo  :  Integer);


Var
  n       :  Integer;

  GlobComp:  TGlobCompRec;


Begin
  // CJS: 14/12/2010 - Amendments for new Window Settings system
  LoadSerialListSettings(PageNo);
  (*
  If (MULCtrlO2[PageNo]<>nil) then
  With MULCtrlO2[PageNo] do
  Begin

    New(GlobComp,Create(BOn));

    With GlobComp^ do
    Begin
      GetValues:=BOn;

      PrimeKey:='K';

      HasCoord:=LastCoord;


      Find_ListCoord(GlobComp);

    end; {With GlobComp..}


    Dispose(GlobComp,Destroy);

  end;
  *)
end;


procedure TStockRec.Store_ValCoord(UpMode  :  Boolean);


Var
  n       :  Byte;
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin

    GetValues:=UpMode;

    SaveCoord:=StoreCoord;

    PrimeKey:='K';

    For n:=Low(MULCtrlO2) to High(MULCtrlO2) do
    If (MULCtrlO2[n]<>nil) {and ((SaveCoord) or (Not UpMode))} then
      // CJS: 14/12/2010 - Amendments for new Window Settings system
      // MULCtrlO2[n].Store_ListCoord(GlobComp);
      SaveSerialListSettings(n);

  end; {With GlobComp..}

  GlobComp.Destroy;
end;


Procedure  TStockRec.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TStockRec.FormSetOfSet;


Begin
  PageP.X:=ClientWidth-(PageControl1.Width);
  PageP.Y:=ClientHeight-(PageControl1.Height);

  ScrollAP.X:=PageControl1.Width-(TCMPanel.Left);
  ScrollAP.Y:=PageControl1.Height-(TCMPanel.Height);

  ScrollBP.X:=PageControl1.Width-(TCMScrollBox.Width);
  ScrollBP.Y:=PageControl1.Height-(TCMScrollBox.Height);

  Misc1P.X:=TCMPanel.Height-(TCMBtnScrollBox.Height);

  PagePoint[0].X:=PageControl1.Width-(CLSBox.Width);
  PagePoint[0].Y:=PageControl1.Height-(CLSBox.Height);

  
  {PagePoint[1].X:=PageControl1.Width-(TCDScrollBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(TCDScrollBox.Height);}

  PagePoint[2].X:=CLSBox.Height-CLORefPanel.Height;
  PagePoint[2].Y:=PageControl1.Height-(CListBtnPanel.Height);

  PagePoint[3].X:=PageControl1.Width-(TCNScrollBox.Width);
  PagePoint[3].Y:=PageControl1.Height-(TCNScrollBox.Height);

  PagePoint[4].X:=TCNScrollBox.ClientHeight-(TCNListBtnPanel.Height);


{  Misc1P.Y:=ScrollBox5.ClientHeight-(TLAccPanel.Height);

  PanelP.X:=PageControl1.Width-(SBSPanel14.Left);
  PanelP.Y:=Panel1.Height-(SBSPanel14.Height);}


  With PageControl1 do
  Begin
    Lab1Ofset:=Width-(NLDPanel.Width);
    Lab2Ofset:=Width-NLCrPanel.Left;
    Lab3Ofset:=Width-NLDrPanel.Left;

    ChrWidth:=InitWidth;

    ChrsXRoss:=(ChrWidth/Width);
  end;



  GotCoord:=BOn;

end;

Function TStockRec.SetDelBtn  :  Boolean;

Begin
  Result:=((CanDelete and (Not ExLocal.InAddEdit)) or (Current_Page In [SNotesPNo,SQtyBPNo,SValuePNo,SSerialPNo,SBINPNo,SMultiBuyPNo]));
end;


Function TStockRec.ChkPWord(PageNo :  Integer;
                            Pages  :  TIntSet;
                            HelpS  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
    Result:=HelpS
  else
    Result:=-255;

end;


Function TStockRec.ChkPWord3(PageNo :  Integer;
                             Pages  :  TIntSet;
                             HelpS,
                             PW2,
                             PW3,
                             PW4,
                             PW5    :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    If (PageNo=SValuePNo) then
      Result:=PW2
    else
      If (PageNo=SSerialPNo) then
        Result:=PW3
      else
        If (PageNo=SQtyBPNo) or (PageNo=SMultiBuyPNo) then
          Result:=PW4
        else
          If (PageNo=SBinPNo) then
            Result:=PW5
          else
            Result:=HelpS;
  end
  else
    Result:=-255;

end;



Function TStockRec.SetHelpC(PageNo :  Integer;
                            Pages  :  TIntSet;
                            Help0,
                            Help1,
                            Help2,
                            Help3,
                            Help4,
                            Help5,
                            Help6,
                            Help7,
                            Help8,
                            Help9,
                            Help10,
                            Help11  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    Case PageNo of
      0  :  Result:=Help0;
      1  :  Result:=Help1;
      2  :  Result:=Help2;
      3  :  Result:=Help3;
      4  :  Result:=Help4;
      5  :  Result:=Help5;
      6  :  Result:=Help6;
      7  :  Result:=Help7;
      8  :  Result:=Help8;
      9  :  Result:=Help9;
     10  :  Result:=Help10;
     11  :  Result:=Help11;
     else
       Result := -1;
    end; {Case..}
  end
  else
    Result:=-1;

end;


procedure TStockRec.PrimeButtons;

Const
  // Custom Button Event IDs.  These are now in CustomButtonHandler.  This is
  //  still here for reference.
  // 23/01/2013 PKR ABSEXCH-13449
  // Changed from array of byte because we're going higher than 255.  
//  CB1EID  :  Array[0..12] of integer = ( 80, 81, 88, 87, 82, 82, 83,101, 84, 85, 86, 89, 89);
//  CB2EID  :  Array[0..12] of integer = ( 90, 91, 98, 97, 92, 92, 93,111, 94, 95, 96, 99, 99);
  // 23/01/2013 PKR ABSEXCH-13449
//  CB3EID  :  Array[0..12] of integer = (221,222,229,228,223,223,224,  0,225,226,227,230,230);
//  CB4EID  :  Array[0..12] of integer = (231,232,239,238,233,233,234,  0,235,236,237,240,240);
//  CB5EID  :  Array[0..12] of integer = (241,242,249,248,243,243,244,  0,245,246,247,250,260);
//  CB6EID  :  Array[0..12] of integer = (251,252,259,258,253,253,254,  0,255,256,257,250,260);

//  CB1TID  :  Array[0..12] of integer = (01,02,09,10,03,03,04,21,05,06,07,08,08);
//  CB2TID  :  Array[0..12] of integer = (11,12,19,20,13,13,14,31,15,16,17,18,18);
  // 23/01/2013 PKR ABSEXCH-13449
//  CB3TID  :  Array[0..12] of integer = (221,222,229,228,223,223,224,  0,225,226,227,230,230);
//  CB4TID  :  Array[0..12] of integer = (231,232,239,238,233,233,234,  0,235,236,237,240,240);
//  CB5TID  :  Array[0..12] of integer = (241,242,249,248,243,243,244,  0,245,246,247,250,260);
//  CB6TID  :  Array[0..12] of integer = (251,252,259,258,253,253,254,  0,255,256,257,250,260);

  // NF: 09/05/06
  TAB_MAIN = 0;
  TAB_DEFAULTS = 1;
  TAB_VATWEB = 2;
  TAB_WOP = 3;
  TAB_RETURNS = 4;
  TAB_NOTES = 5;
  TAB_QTYBREAKS = 6;
  TAB_MULTIBUY = 7;
  TAB_LEDGER = 8;
  TAB_VALUE = 9;
  TAB_BUILD = 10;
  TAB_SERIAL = 11;
  TAB_MULTIBINS = 12;

Var
  ACFlg,
  ChkBin,
  P4Blk   :  Boolean;

  BinPW,
  n,
  PageNo  :  Integer;

  TheCaption    :  ShortString;
{$IFDEF CU}
  // 28/01/2013 PKR ABSEXCH-13449
  cBtnIsEnabled : Boolean;
  TextID        : integer;
{$ENDIF}

Begin
  PageNo:=Current_Page;

  {$IFDEF SOP}
    ACFlg:=BOff;
  {$ELSE}
    ACFlg:=BOn;

  {$ENDIF}

  TheCaption:='';  P4Blk:=BOff;  ChkBin:=(PageNo=SBinPNo) and (BinUseMode);

  If (InvBtnList=nil) then
  Begin
    InvBtnList:=TVisiBtns.Create;

    try

      With InvBtnList do
      Begin
        PresEnab:=BOff;

      {0} AddVisiRec(AddCP1Btn,BOff);
      {1} AddVisiRec(EditCP1Btn,BOff);
      {2} AddVisiRec(InsCP1Btn,BOff);
      {3} AddVisiRec(DelCP1Btn,BOff);
      {4} AddVisiRec(FindCP1Btn,BOff);
      {5} AddVisiRec(SortViewBtn,BOff);
      {6} AddVisiRec(HistCP1Btn,BOff);
      {7} AddVisiRec(GenCP3Btn,BOff);
      {8} AddVisiRec(PrnCP1Btn,BOff);
      {9} AddVisiRec(ViewCP1Btn,BOff);
     {10} AddVisiRec(CopyCP1Btn,BOff);
     {11} AddVisiRec(ChkCP1Btn,BOff);
     {12} AddVisiRec(UCP1Btn,BOff);
     {13} AddVisiRec(RetCP1Btn,BOff);
     {14} AddVisiRec(Altdb1Btn,ACFlg);
     {15} AddVisiRec(LnkCP1Btn,BOff);
     {16} AddVisiRec(NteCP1Btn,BOff);
     {17} AddVisiRec(StkCuBtn1,BOff);
     {18} AddVisiRec(StkCuBtn2,BOff);
          // 17/01/2013 PKR ABSEXCH-13449
          // Custom buttons 3..6 now available
     {19} AddVisiRec(StkCuBtn3,BOff);
     {20} AddVisiRec(StkCuBtn4,BOff);
     {21} AddVisiRec(StkCuBtn5,BOff);
     {22} AddVisiRec(StkCuBtn6,BOff);
        end; {With..}

    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  try

    With InvBtnList do
    Begin
      PresEnab:=ExLocal.InAddEdit;

      If (ChkBin) then
        BinPW:=-255
      else
        BinPW:=431;

      //GS: 11/05/11 ABSEXCH-10146
      //the 'PageNo In..' condition controls what tabs display the 'Add' button, the tab 'SBinPNo' is included
      //in this list, meaning the 'Add' button is visible on the bin tab all the time.
      //The field InBinFind is set when a bin search is performed, this can be used to determine whether we are about
      //to display a stock record or a search result, and set the 'Add' buttons visibility accordingly

      //GS: 11/05/11 ABSEXCH-10145
      //the Serial/Batch search results form also displays an 'Add' button similar to issue ABSEXCH-10146 described avove,
      //this is also fixed below

      //added 'or (InBinFind) or (InSerFind)' clause to the arguments of the following method call,
      //meaning if we are displaying a bin / serial search result; hide the 'Add' button.
      PWSetHideBtn(0,(Not (PageNo In [{$IFDEF LTE} SMainPNo, {$ENDIF}SNotesPNo,SQtyBPNo,SMultiBuyPNo,SValuePNo,SSerialPNo,SBinPNo])) or (ICEDFM=2) or (InBinFind) or (InSerFind),BOff,ChkPWord3(PageNo,[SMainPNo..SRetPNo,SValuePNo,SSerialPNo,SQtyBPNo,SMultiBuyPNo,SBinPNo],110,278,275,297,BinPW));



      SetBtnHelp(0,SetHelpC(PageNo,[SMainPNo..SMultiBuyPNo,SValuePNo,SSerialPNo],156,156,156,-1,88,128,0,8012,0,0,1036,1460));

      If (ChkBin) then
        BinPW:=-255
      else
        BinPW:=432;


      PWSetHideBtn(1,BOff,BOff,ChkPWord3(PageNo,[SMainPNo..SRetPNo,SValuePNo,SSerialPNo,SQtyBPNo,SMultiBuyPNo,SBinPNo],111,279,276,298,BinPW));
      SetBtnHelp(1,SetHelpC(PageNo,[SMainPNo..SValuePNo,SSerialPNo],155,155,155,-1,155,129,26,8013,0,0,1036,1460));

      SetHideBtn(2,(PageNo<>SNotesPNo),BOff);

      If (ChkBin) then
        BinPW:=-255
      else
        BinPW:=433;

      PWSetHideBtn(3,(PageNo=SLedgerPNo) or (SerUseMode) or (BinUseMode) or (ICEDFM<>0),BOff,ChkPWord3(PageNo,[SMainPNo..SRetPNo ,SValuePNo,SSerialPNo,SQtyBPNo,SMultiBuyPNo,SBinPNo],112,280,277,299,BinPW));

      SetBtnHelp(3,SetHelpC(PageNo,[SMainPNo..SValuePNo,SSerialPNo],159,159,159,-1,159,130,0,8014,0,0,0,1461));

      SetHideBtn(4,(PageNo In [SNotesPNo,SQtyBPNo,SMultiBuyPNo,SValuePNo]),BOff);

      SetBtnHelp(4,SetHelpC(PageNo,[SMainPNo..SRetPNo ,SLedgerPNo],165,165,165,-1,0,0,27,-1,0,0,1047,1462));

      PWSetHideBtn(5, (PageNo <> SLedgerPNo), BOff, ChkPWord(PageNo, [SLedgerPNo], 589));

      SetHideBtn(6,(Not (PageNo In [SMainPNo..SRetPNo])),BOff);

      SetHideBtn(7,(PageNo<>SNotesPNo),BOff);

      PWSetHideBtn(8,(PageNo In [SNotesPNo,SQtyBPNo,SMultiBuyPNo,SValuePNo,SSerialPNo,SBinPNo]),BOff,ChkPWord(PageNo,[SMainPNo..SRetPNo],113));
      SetBtnHelp(8,SetHelpC(PageNo,[SMainPNo..SRetPNo,SLedgerPNo],163,163,163,0,163,0,31,-1,0,0,0,0));

      SetHideBtn(9,(Not (PageNo In [SLedgerPNo,SValuePNo,SSerialPNo,SBinPNo])) or ((PageNo=SSerialPNo) and SerUseMode) or ((PageNo=SBinPNo) and BinUseMode),BOff);
      SetBtnHelp(9,SetHelpC(PageNo,[SMainPNo..SRetPNo,SLedgerPNo],154,154,154,-1,0,0,32,-1,0,0,1048,1463));


      {SetHideBtn(9,(Not (PageNo In [SMainPNo..SDef2PNo,SQtyBPNo,SLedgerPNo])),BOff);}

      PWSetHideBtn(10,
                   (Not (PageNo In [SMainPNo..SRetPNo,SQtyBPNo,SMultiBuyPNo,SLedgerPNo]) or (ICEDFM<>0)),
                   BOff,
                   // MH 29/04/2010 v6.4 ABSEXCH-9539: Added in Returns Tab
                   ChkPWord3(PageNo,[SMainPNo..SRetPNo,SLedgerPNo,SQtyBPNo,SMultiBuyPNo],(314*Ord(PageNo=SLedgerPNo))+(472*Ord(PageNo<>SLedgerPNo)),0,0,300,0));

      SetBtnHelp(10,SetHelpC(PageNo,[SMainPNo..SRetPNo,SQtyBPNo..SValuePNo,SSerialPNo],186,186,186,-1,-1,131,28,8015,0,0,0,0));

      SetHideBtn(11,(PageNo In [SNotesPNo,SValuePNo,SSerialPNo]),BOff);

      PWSetHideBtn(11,(PageNo In [SNotesPNo,SValuePNo,SSerialPNo]) or (ICEDFM<>0),BOff,ChkPWord3(PageNo,[SMainPNo..SRetPNo,SLedgerPNo,SQtyBPNo,SMultiBuyPNo],473,0,0,301,0));

      SetBtnHelp(11,SetHelpC(PageNo,[SMainPNo..SRetPNo,SQtyBPNo..SValuePNo,SSerialPNo],187,187,187,-1,-1,132,187,8016,0,0,0,1464));

      SetHideBtn(12,((PageNo<>SSerialPNo) and (PageNo<>SBinPNo)) or ((Not SerUseMode) and (Not BINUseMode)) or (InSerFind)  or (InBINFind),BOff);

      P4Blk:=(PageNo=SSerialPNo) and ((Not ChkAllowed_In(573)) and (Not ChkAllowed_In(512)));

      PWSetHideBtn(13,(Not (PageNo In [SLedgerPNo,SSerialPNo])) or ((SerUseMode) and (Not InSerFind)) or (Not RetMOn) or (P4Blk),BOff,ChkPWord(PageNo,[SLedgerPNo],511));

      {$IFDEF SOP}
        {$IFNDEF LTE}
          //GS: 11/05/11 ABSEXCH-10145
          //The following lines control whether the 'Add Range' button is displayed on the stock record form
          //modified the arguments so if the form is being used to display a serial / batch search result, the button
          //will be hidden

          //added 'or (InSerFind)' clause to the arguments of the following method call,
          //meaning if we are displaying a serial / batch search result; hide the 'Add Range' button.
          PWSetHideBtn(14,(Not (PageNo In [SMainPNo..SRetPNo,SSerialPNo,SBinPNo]) or (InSerFind) or ((PageNo=SBinPNo) and (Not Syss.UseMLoc))),BOff,ChkPWord(PageNo,[SSerialPNo],275));

        {$ELSE}
          //added 'or (InSerFind)' clause to the arguments of the following method call,
          //meaning if we are displaying a serial / batch search result; hide the 'Add Range' button.
          PWSetHideBtn(14,(Not (PageNo In [SMainPNo..SRetPNo,SSerialPNo,SBinPNo]) or (InSerFind) or ((PageNo=SBinPNo) and (Not Syss.UseMLoc))),BOff,-254);

        {$ENDIF}

        SetBtnHelp(14,SetHelpC(PageNo,[SMainPNo..SRetPNo,SSerialPNo],596,596,596,-1,0,0,00,-1,0,0,1049,1465));

      {$ENDIF}

      SetHideBtn(15,(Not (PageNo In [SMainPNo..SRetPNo,SBinPNo ])) or (BinUseMode)  ,BOff);

      {$IFDEF CU}
        recordState := rsAny;
        formPurpose := fpStockRecord;

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, StkCuBtn1.Tag);
        {17}  SetHideBtn(17, (not cBtnIsEnabled) or (PageNo=SNotesPNo), BOff);
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, StkCuBtn2.Tag);
        {18}  SetHideBtn(18, (not cBtnIsEnabled) or (PageNo=SNotesPNo),BOff);

        // 28/01/2013 PKR ABSEXCH-13449
        // Custom buttons 3..6 now available.  Use custom button handler
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, StkCuBtn3.Tag);
        {19}  SetHideBtn(19, (not cBtnIsEnabled) or (PageNo=SNotesPNo),BOff);
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, StkCuBtn4.Tag);
        {20}  SetHideBtn(20, (not cBtnIsEnabled) or (PageNo=SNotesPNo),BOff);
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, StkCuBtn5.Tag);
        {21}  SetHideBtn(21, (not cBtnIsEnabled) or (PageNo=SNotesPNo),BOff);
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, StkCuBtn6.Tag);
        {22}  SetHideBtn(22, (not cBtnIsEnabled) or (PageNo=SNotesPNo),BOff);

(*
        {15}  SetHideBtn(17,(Not EnableCustBtns(3000,CB1EID[PageNo])) or (PageNo=SNotesPNo),BOff);
        {16}  SetHideBtn(18,(Not EnableCustBtns(3000,CB2EID[PageNo])) or (PageNo=SNotesPNo),BOff);
*)


        TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, StkCuBtn1.tag);
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, TextID, TheCaption, StkCuBtn1.Font);
        StkCuBtn1.Caption:=TheCaption;

        TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, StkCuBtn2.tag);
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, TextID, TheCaption, StkCuBtn2.Font);
        StkCuBtn2.Caption:=TheCaption;

        // 17/01/2013 PKR ABSEXCH-13449
        // Custom buttons 3..6 now available
        TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, StkCuBtn3.tag);
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, TextID, TheCaption, StkCuBtn3.Font);
        StkCuBtn3.Caption:=TheCaption;

        TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, StkCuBtn4.tag);
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, TextID, TheCaption, StkCuBtn4.Font);
        StkCuBtn4.Caption:=TheCaption;

        TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, StkCuBtn5.tag);
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, TextID, TheCaption, StkCuBtn5.Font);
        StkCuBtn5.Caption:=TheCaption;

        TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, StkCuBtn6.tag);
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, TextID, TheCaption, StkCuBtn6.Font);
        StkCuBtn6.Caption:=TheCaption;

(*
        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, CB1TID[PageNo], TheCaption, StkCuBtn1.Font);
        StkCuBtn1.Caption:=TheCaption;

        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, CB2TID[PageNo], TheCaption, StkCuBtn2.Font);
        StkCuBtn2.Caption:=TheCaption;
*)

      {$ELSE}
        {15}  SetHideBtn(17,BOn,BOff);
        {16}  SetHideBtn(18,BOn,BOff);
              // 23/01/2013 PKR ABSEXCH-13449
              // Custom buttons 3..6 now available
        {19}  SetHideBtn(19,BOn,BOff);
        {20}  SetHideBtn(20,BOn,BOff);
        {21}  SetHideBtn(21,BOn,BOff);
        {22}  SetHideBtn(22,BOn,BOff);
      {$ENDIF}


      SetHideBtn(16,PageNo<>SSerialPNo,BOn);

      DelCP1Btn.Enabled:=SetDelBtn;

      OkCP1Btn.Visible:=(PageNo In [SMainPNo..SRetPNo]);
      CanCP1Btn.Visible:=(PageNo In [SMainPNo..SRetPNo]);

      // NF: 09/05/06 Fixes for incorrect Context IDs
      case PageNo of
        TAB_MAIN : begin
          // NF: 22/06/06
          ChkCP1Btn.HelpContext := 187;
          Check1.HelpContext := ChkCP1Btn.HelpContext;


          SRSP1F.HelpContext := 2089;  // NF: 25/07/06
          SRGP1.HelpContext := 2090;  // NF: 25/07/06
        end;
        TAB_DEFAULTS : begin
          SRBCF.HelpContext := 1898; // NF: 22/06/06
        end;
        TAB_NOTES : begin
          PageControl1.ActivePage.HelpContext := 66; // NF: 22/06/06
          AddCP1Btn.HelpContext := 88;
          EditCP1Btn.HelpContext := 87;
          DelCP1Btn.HelpContext := 89;
        end;
        TAB_QTYBREAKS : begin
          PageControl1.ActivePage.HelpContext := 1870; // NF: 22/06/06
          AddCP1Btn.HelpContext := 128;
          EditCP1Btn.HelpContext := 129;
          DelCP1Btn.HelpContext := 130;
          CopyCP1Btn.HelpContext := 131;
          ChkCP1Btn.HelpContext := 119;// NF: 22/06/06
          Check1.HelpContext := ChkCP1Btn.HelpContext;// NF: 22/06/06
        end;
        TAB_LEDGER : begin
          EditCP1Btn.HelpContext := 26;
          CopyCP1Btn.HelpContext := 28;
          FindCP1Btn.HelpContext := 1899;// NF: 22/06/06
          PrnCP1Btn.HelpContext := 31;
          ViewCP1Btn.HelpContext := 32;
        end;
        TAB_VALUE : begin // NF: 22/06/06
          AddCP1Btn.HelpContext := 1866;
          EditCP1Btn.HelpContext := 1867;
          DelCP1Btn.HelpContext := 1868;
          ViewCP1Btn.HelpContext := 1869;
        end;
{        TAB_BUILD : begin
          // These fields cannot have help context ids, as they are not selectable
          GPLab.HelpContext := 1711;
          CostLab.HelpContext := 1712;
          Panel5.HelpContext := 1713;
        end;}
      end;{case}

      // NF: 22/06/06
      PageControl1.HelpContext := PageControl1.ActivePage.HelpContext;
      TCMBtnScrollBox.HelpContext := PageControl1.ActivePage.HelpContext;
      TCMPanel.HelpContext := PageControl1.ActivePage.HelpContext;
      HelpContext := PageControl1.ActivePage.HelpContext;
    end;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}




end;


Function TStockRec.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      SQtyBPNo
         :  Result:=QBSBox.HorzScrollBar.Position;

      SLedgerPNo
         :  Result:=CLSBox.HorzScrollBar.Position;

      SValuePNo
         :  Result:=VSBox.HorzScrollBar.Position;

      SSerialPNo
         :  Result:=SNSBox.HorzScrollBar.Position;

      SBINPNo
         :  Result:=MBSBox.HorzScrollBar.Position;

      else  Result:=0;
    end; {Case..}
end;

procedure TStockRec.BuildCtrlLists;


Begin

  DescCList:=TDetCtrl.Create;

  try
    With DescCList do
    Begin
      AddVisiRec(SRD1F,BOff);
      AddVisiRec(SRD2F,BOff);
      AddVisiRec(SRD3F,BOff);
      AddVisiRec(SRD4F,BOff);
      AddVisiRec(SRD5F,BOff);
      AddVisiRec(SRD6F,BOff);
    end;


  except
    DescCList.Free;
    DescCList:=nil;

  end; {try..}
end; {Proc..}


procedure TStockRec.HidePanels(PageNo    :  Byte);

Var
  TmpBo
         :  Boolean;
  n      :  Integer;

Begin

  Case PageNo of

    SLedgerPNo  :    ;

  end; {Case..}
end;


{* Alter screen based on stock record }

procedure TStockRec.BuildDesign;

Begin
  With ExLocal,LStock do
  Begin
    ValPage.TabVisible:=BoChkAllowed_In((IS_FIFO(StkValType) and (Not SerUseMode) and (Not BinUseMode) and (Not CQtyBMode) and (Not HideDAdd)),149);
    BOMPage.TabVisible:=BoChkAllowed_In(((StockType<>StkGrpCode) and (Not SerUseMode) and (Not BinUseMode) and (Not CQtyBMode) and (Not HideDAdd) and FullStkSysOn),114);
    SerPage.TabVisible:=BoChkAllowed_In(((IS_SerNo(StkValType) or (SerUseMode)) and (Not CQtyBMode) and (Not HideDAdd)),149+(-404*Ord(SerUseMode)));

    Ledger.TabVisible:=BoChkAllowed_In((Not SerUseMode) and (Not BinUseMode) and (Not CQtyBMode) and (Not HideDAdd),109);
    QtyBreaks.TabVisible:=BoChkAllowed_In((((Not SerUseMode) or (CQtyBMode)) and (Not HideDAdd) and (Not BinUseMode)),146+(-401*Ord(CQtyBMode)));
    tabMultiBuy.TabVisible := BoChkAllowed_In((((Not SerUseMode) or (CQtyBMode)) and (Not HideDAdd) and (Not BinUseMode)),146+(-401*Ord(CQtyBMode)));

    Notes.TabVisible:=(Not SerUseMode) and (Not BinUseMode) and (Not CQtyBMode) and (Not HideDAdd);
    Defaults.TabVisible:=(Not SerUseMode) and (Not BinUseMode);
    Def2Page.TabVisible:=(Not SerUseMode) and (Not BinUseMode);

    {$IFDEF SOP}
    //PR: 01/06/2009 Added checks for SerialBatch/MultiBin modes
     tabMultiBuy.TabVisible := not HideDAdd and (Not SerUseMode) and (Not BinUseMode) and (Not CQtyBMode) and (StockType<>StkGrpCode);
    {$ELSE}
     tabMultiBuy.TabVisible := False;
    {$ENDIF}

    If (Def2Page.TabVisible) then
    Begin
      // MH 18/05/2016 2016-R2 ABSEXCH-17470: Moved VAT fields to new Tax tab
      If eBusModule then
        Def2Page.Caption:='Web/User'
      Else
        Def2Page.Caption:='User Fields'
    end;

    {$IFDEF WOP} {*EN440WOP} {Final screen design will need adjusting, with password maybe new tab?}
       WOPPage.TabVisible:=(Not SerUseMode) and (Not BinUseMode) and (WOPOn);

       CBCalcProdT.Visible:=StockType=StkBillcode;

       Label856.Visible:=CBCalcProdT.Visible;
       SRASSDF.Visible:=CBCalcProdT.Visible;
       SRASSHF.Visible:=CBCalcProdT.Visible;
       SRASSMF.Visible:=CBCalcProdT.Visible;
       Label859.Visible:=CBCalcProdT.Visible;
       Label860.Visible:=CBCalcProdT.Visible;
       Label861.Visible:=CBCalcProdT.Visible;
       DefUdF.Visible:=CBCalcProdT.Visible;
       SBSUpDown1.Visible:=CBCalcProdT.Visible;
       SBSUpDown2.Visible:=CBCalcProdT.Visible;
       SRMEBQF.Visible:=CBCalcProdT.Visible;
       Label862.Visible:=CBCalcProdT.Visible;

       Label855.Visible:=Not Is_StdWOP and CBCalcProdT.Visible;
       SRGIF.Visible:=Label855.Visible;
       FGLIF.Visible:=Label855.Visible;

       If (WOPOn) then {We could be originating from a works order}
       Begin
         SnoSo1.Caption:='&Sales/Works Order';
         SnoPo1.Caption:='&Purchase/Works Order';
       end;

       WorksOrders1.Visible:=WOPOn;
       Image5.Visible:=FullWOP;
       Label863.Visible:=FullWOP;

    {$ELSE}
       WOPPage.TabVisible:=BOff;
       WorksOrders1.Visible:=BOff;
       Image5.Visible:=BOff;
       Label863.Viisble:=BOff;
    {$ENDIF}


    {$IFDEF RET}

      RETPage.TabVisible:=(Not SerUseMode) and (Not BinUseMode) and (RETMOn) and (SRTF.ItemIndex<>2);

      RetALL1.Visible:=RETMOn;
      RetSRN1.Visible:=RETMOn;
      RetPRN1.Visible:=RETMOn;


    {$ELSE}
      RetPage.TabVisible:=BOff;
      RetALL1.Visible:=BOff;
      RetSRN1.Visible:=BOff;
      RetPRN1.Visible:=BOff;


    {$ENDIF}


    {$IFNDEF SOP}
       PurchOrdersOS1.Visible:=BOff;
       SalesOrdersOS1.Visible:=BOff;
       OSOrders1.Visible:=BOff;
       PickedOrders1.Visible:=BOff;
       SalesOrders1.Visible:=BOff;
       PurchOrders1.Visible:=BOff;
       AllOrders1.Visible:=BOff;
       SalesDeliveryNote1.Visible:=BOff;
       PurchDeliveryNote1.Visible:=BOff;
       DeliveryNotes1.Visible:=BOff;

    {$ENDIF}

    BinPage.TabVisible:=BoChkAllowed_In((MultiBinMode or BinUseMode) and (Not CQtyBMode) and (Not SerUseMode) and (Not HideDAdd),-255); {*EN522 password needs checking here *}

    If (BOMPage.TabVisible) then {Check sub password options}
    Begin
      Edit2.Visible:=ChkAllowed_In(316);
      Add2.Visible:=ChkAllowed_In(315);
      Del2.Visible:=ChkAllowed_In(317);

      Insert2.Visible:=ChkAllowed_In(318);

      BOMTimeLab.Visible:=WOPOn;
      BOMTimePanel.Visible:=WOPOn;
    end;

    StockRecord1.Visible:=InSerFind;

    Main.TabVisible:=(Not SerUseMode) and (Not BinUseMode);

    // MH 06/09/2016 2016-R3 ABSEXCH-17716: Hide Tax tab when adding Serial/Batch/Bin Numbers
    tabshTax.TabVisible := Main.TabVisible;

    EditSPBtn.Visible:=ChkAllowed_In(474);

    Label818.Visible:=EditSPBtn.Visible;


    {$IFNDEF LTE}
      If (IsProdMode(StockType,StkGrpCode)) then
      Begin
        SRGSF.Text:='';
        SRGCF.Text:='';
        SRGWF.Text:='';
        SRGVF.Text:='';
        SRGPF.Text:='';
      end;
    {$ENDIF}

    
    If (Not FullStkSysOn) then
    Begin
      Label827.Visible:=BOff;
      SRMIF.Visible:=BOff;
      Label831.Visible:=BOff;
      SRMXF.Visible:=BOff;
      Bevel1.Visible:=BOff;
      Label836.Visible:=BOff;
      SRISF.Visible:=BOff;
      Label835.Visible:=BOff;
      SRPOF.Visible:=BOff;
      Label837.Visible:=BOff;
      SRALF.Visible:=BOff;
      Label838.Visible:=BOff;
      SRFRF.Visible:=BOff;
      Bevel2.Visible:=BOff;
      Label834.Visible:=BOff;
      SROOF.Visible:=BOff;
      SBSBackGroup4.Visible:=BOff;
      SBSBackGroup3.Visible:=BOff;
      Label1.Visible:=BOff;
      SRSPF.Visible:=BOff;
      SRMBF.Visible:=BOff;

    end;

  end;
end;


procedure TStockRec.FormDesign;

Var
 n  :  Integer;

begin

  Lab4Ofset:=PageControl1.Height-Panel4.Top+2;

//  Find_FormCoord;


  Set_DefaultVAT(cbTaxCode.Items,BOn,BOn);
//  Set_DefaultVAT(cbTaxCode.ItemsL,BOn,BOn);
  lblTaxCodeTitle.Caption := CCVATName^ + ' Codes ';
  lblDefaultTaxCode.Caption := 'Default ' + CCVATName^ + ' Code';

  Set_DefaultStkT(SRTF.Items,BOff,BOff);
  Set_DefaultStkT(SRTF.ItemsL,BOff,BOff);

  Set_DefaultVal(SRVMF.Items,BOff,BOff,BOn);
  Set_DefaultVal(SRVMF.ItemsL,BOff,BOff,BOn);

  Set_DefaultDocT(SRLTF.Items,BOff,BOff);
  Set_DefaultDocT(SRLTF.ItemsL,BOff,BOff);

  {$IFDEF MC_On}
     With SRCPCF do
     Begin
       Set_DefaultCurr(Items,BOff,BOff);
       Set_DefaultCurr(ItemsL,BOff,BOn);
     end;

     With SRRPCF do
     Begin
       Set_DefaultCurr(Items,BOff,BOff);
       Set_DefaultCurr(ItemsL,BOff,BOn);
     end;

  {$ELSE}
     SRCPCF.Visible:=BOff;
     SRRPCF.Visible:=BOff;

  {$ENDIF}


  SRCF.MaxLength:=StkKeyLen;


  With DescCList do
  Begin
    For n:=0 to Pred(Count) do
      Text8pt(IdWinRec(n)).MaxLength:=StkDesKLen;
  end; {With..}

  {SRFSF.MaxLength:=CustKeyLen;
  SRCCF.MaxLength:=CCKeyLen;
  SRDepF.MaxLength:=CCKeyLen;}

  SRACF.MaxLength:=StkKeyLen;
  SRJAF.MaxLength:=AnalKeyLen;
  SRBLF.MaxLength:=BinLocLen;
  SRUQF.MaxLength:=UStkLen;
  SRUSF.MaxLength:=UStkLen;
  SRUPF.MaxLength:=UStkLen;

  SRCPF.DecPlaces:=Syss.NoCosDec;
  SRRPF.DecPlaces:=Syss.NoCosDec;
  SRMIF.DecPlaces:=Syss.NoQtyDec;
  SRMXF.DecPlaces:=Syss.NoQtyDec;
  SRISF.DecPlaces:=Syss.NoQtyDec;
  SRPOF.DecPlaces:=Syss.NoQtyDec;
  SRALF.DecPlaces:=Syss.NoQtyDec;
  SRFRF.DecPlaces:=Syss.NoQtyDec;
  SROOF.DecPlaces:=Syss.NoQtyDec;
  SRAWF.DecPlaces:=Syss.NoQtyDec;
  SRIWF.DecPlaces:=Syss.NoQtyDec;
  SRPWF.DecPlaces:=Syss.NoQtyDec;
  SRMEBQF.DecPlaces:=Syss.NoQtyDec;
  SRSP1F.DecPlaces:=Syss.NoNetDec;

  //GS 24/10/2011 ABSEXCH-11706: use new CustomFields object to set UDEF
  //field visibility and captions
  //PR: 14/11/2011 Amended to use centralised function SetUdfCaptions in CustomFieldsIntf.pas ABSEXCH-12129

  SetUdfCaptions([UD1Lab, UD2Lab, UD3Lab, UD4Lab, UD5Lab, UD6Lab, UD7Lab, UD8Lab, UD9Lab, UD10Lab], cfStock);


  {$IFDEF LTE}
    SRLocF.Visible:=BOff;
    SRBLF.Left:=SRLocF.Left;
    Label810.Caption:='Bin';

    SBSBackGroup3.Visible:=BOff;

    SRMBF.Visible:=BOff;

    SRSPF.Visible:=BOff;
    Label1.Visible:=BOff;
    UD1Lab.Visible:=BOff;
    UD2Lab.Visible:=BOff;
    UD3Lab.Visible:=BOff;
    UD4Lab.Visible:=BOff;
    UD5Lab.Visible:=BOff;
    UD6Lab.Visible:=BOff;
    UD7Lab.Visible:=BOff;
    UD8Lab.Visible:=BOff;
    UD9Lab.Visible:=BOff;
    UD10Lab.Visible:=BOff;
    UD1F.Visible:=BOff;
    UD2F.Visible:=BOff;
    UD3F.Visible:=BOff;
    UD4F.Visible:=BOff;
    UD5F.Visible:=BOff;
    UD6F.Visible:=BOff;
    UD7F.Visible:=BOff;
    UD8F.Visible:=BOff;
    UD9F.Visible:=BOff;
    UD10F.Visible:=BOff;

    emWebF.Visible:=BOff;
    Label826.Visible:=BOff;
    WebCatF.Visible:=BOff;
    WebImgF.Visible:=BOff;
    Label844.Visible:=BOff;
    Bevel9.Visible:=BOff;
    SRSUF.Visible:=BOff;
    SRPUF.Visible:=BOff;
    Label843.Visible:=BOff;
    Label842.Visible:=BOff;
    SRGLab.Visible:=BOn;

    SRSBox1.Top:=SRSBox1.Top+27;
    SRSBox1.Height:=SRSBox1.Height-27;

  {$ENDIF}

  FormSetOfSet;

  PrimeButtons;

  BuildDesign;

  SetTabs;

  If (Not SerUseMode) and (Not BinUseMode) and (Not CQtyBMode) then
    ChangePage(SMainPNo);


end;


procedure TStockRec.SetTabs;

Begin
  {$IFNDEF PF_On}

    QtyBreaks.TabVisible:=BOff;
    ValPage.TabVisible:=BOff;
    BOMPage.TabVisible:=BOff;
    SerPage.TabVisible:=BOff;

    BinPage.TabVisible:=BOff;

  {$ELSE}
    QtyBreaks.TabVisible:=ChkAllowed_In(147);
    ValPage.TabVisible:=ChkAllowed_In(149);
    BOMPage.TabVisible:=ChkAllowed_In(114);
    SerPage.TabVisible:=ChkAllowed_In(149);

    BinPage.TabVisible:=BOn;
    
  {$ENDIF}

end;


procedure TStockRec.BuildMenus;

Begin
  Case Current_Page of
    SQtyBPNo    :  CreateSubMenu(PopUpMenu6,Copy1);
    SLedgerPNo  :  CreateSubMenu(PopUpMenu2,Copy1);
  end; {Case..}
end;


procedure TStockRec.FormCreate(Sender: TObject);

Var
  n        :  Integer;
  ShowCC   :  Boolean;

begin
  {$IFNDEF SOPDLL} {* v5.70, initially created as fsNormal so DLL TK can share *}
    {FormStyle:=fsMDIChild;}
  {$ENDIF}


  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;
  FColorsChanged := False;

  fFrmClosing:=BOff;
  fDoingClose:=BOff;
  Visible:=BOff;  {*v 5.70, Visible set on form as false rather then here to accomodate DLL TK need of this form to be fsNormal *}

  ManClose:=BOff;

  // MH 08/09/2014 v7.1 ABSEXCH-15052: Increased form size for new field
  InitSize.Y:=373; //385;     //TG Adjusting the window size for equal spacing
  InitSize.X:=562; // 558;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  // MH 18/05/2016 2016-R2 ABSEXCH-17470: Record minimum sizes for MinMaxInfo
  MinWindowWidth := Width;
  MinWindowHeight := Height;

  {Height:=353;
  Width:=566;}

  SerUseMode:=(DDFormMode.NHMode=5);

  InSerFind:=(DDFormMode.NHNeedGExt and (DDFormMode.NHFilterMode=0)) and (SerUseMode);

  BinUseMode:=(DDFormMode.NHMode=6);

  InBinFind:=(DDFormMode.NHNeedGExt and (DDFormMode.NHFilterMode=0)) and (BinUseMode);

  CQtyBMode:=(DDFormMode.NHMode=16);

  {$IFNDEF SOPDLL} {* v5.70, initially created as fsNormal so DLL TK can share *}
    MDI_SetFormCoord(TForm(Self));
  {$ENDIF}

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  // CJS: 13/12/2010 Added to use new Window Positioning system
  //PR: 27/05/2011 Change to use ClassName rather than Name as identifier - if there are
  //2 instances of the form in existence at the same time, Delphi will change the name of one to Name + '_1' (ABSEXCH-11426)
  FSettings := GetWindowSettings(Self.ClassName);
  LoadWindowSettings;

  {* Set Version Specific Info *}

  {$IFNDEF PF_On}
    ShowCC:=BOff;
    SRPKF.Visible:=BOff;
    SRPSF.Visible:=BOff;
    SRRUF.Visible:=BOff;
    SRPPF.Visible:=BOff;
    SRVMF.Visible:=BOff;
    ValLab.Visible:=BOff;
    ValLab2.Visible:=BOff;
    SBSPanel3.Visible:=BOff;
    WIPLab.Visible:=BOff;
    SRGPF.Visible:=BOff;

  {$ELSE}
    ShowCC:=Syss.UseCCDep;

  {$ENDIF}

  CCLab.Visible:=ShowCC;
  SRCCF.Visible:=ShowCC;
  SRDepF.Visible:=ShowCC;

  If (Not JBCostOn) then
  Begin
    JALab.Visible:=BOff;
    SRJAF.Visible:=BOff;
    JADF.Visible:=BOff;
  end;

  // MH 18/05/2016 2016-R2 ABSEXCH-17470: Re-arrrange Web/User field to optimise user defined fields
  If (Not eBusModule) then
    Hide_eBusinessFields;

  If Not Syss.IntraStat then
  Begin
    panIntrastatSettings.Visible := False;
  end
  else
  Begin
    // PKR. 13/01/2016. ABSEXCH-17099. Intrastat.
    // Country of Origin field not visible for UK users.
    If (CurrentCountry = UKCCode) then
    begin
      SRCOF.Visible := false;     // Country of Origin field
      Label848.Visible := false;  // Country of Origin label
    end;

    If (CurrentCountry<>IECCode) then
    Begin
      // Not Ireland
      SRSUP.Visible:=BOff;
      Label847.Visible:=BOff;
      Label819.Visible:=BOff;
      // MH 04/04/2012 v6.10.1 ABSEXCH-12546: Added Intrastat Uplift Arrivals% into UI for EIRE Intrastat configurations
      ccyIntrastatArrivalsPerc.Visible := BOff;
    end
    Else
    Begin
      // Ireland - Intrastat turned on
      // MH 04/04/2012 v6.10.1 ABSEXCH-12546: Added Intrastat Uplift Arrivals% into UI for EIRE Intrastat configurations
      ccyIntrastatArrivalsPerc.Visible := BOn;
    End; // Else
  end;
  // MH 18/05/2016 2016-R2 ABSEXCH-17470: Added Tax Codes tab for MRT
  ReOrgTaxPanels;

  InHBeen:=BOff;
  FromHist:=BOff;
  InBOM:=BOff;
  BOMMode:=BOff;
  BOMFolio:=0;
  HideDAdd:=BOff;
  InSerModal:=BOff;
  InBinModal:=BOff;

  InPageChanging:=BOff;
  StopPageChange:=BOff;

  DispTransPtr:=nil;
  HistFormPtr:=nil;
  {$IFDEF NP}
    SNoteCtrl:=Nil;
  {$ENDIF}

  {$IFDEF SOP}
     AltCList:=nil;
  {$ENDIF}

  LastHMode:=1;

  ListOfSet:=10;

  SerFindMode:=0;

  SerRetMode:=0;

  SerMainK:='';

  stkStopAutoLoc:=BOff;
  BinMoveMode:=BOff;
  SRecLocFilt:=DDFormMode.NHLocCode;

  LastQtyMin:=0;
  LastQtyMax:=0;
  fSortLocBin:=BOff;

  SKeypath:=0;
  LastYTDII:=0;
  LastBTag:=0;

  Prices:=nil;

  With YTDCombo do
    ItemsL.Assign(Items);

  GotCoord:=BOff;

  BuildCtrlLists;

  {$IFDEF CU}
    try
      EntCustom3.Execute;
    except
      ShowMessage('Customisation Control Failed to initialise');
    end;

  {$ENDIF}


  {$IFNDEF LTE}
    If (CQtyBMode) then
      DelDisc2.Visible:=BOff;
  {$ELSE}
     DelDisc2.Visible:=BOff;
  {$ENDIF}

  If (SerUseMode or BinUseMode or CQtyBMode or (DDFormMode.NHFilterMode<>0)) and (Current_Page<>SMainPNo) then
    ChangePage(SMainPNo);

  If (SerUseMode) then
    ChangePage(SSerialPNo)
  else
    If (CQtyBMode) then
      ChangePage(SQtyBPNo)
    else
      If (BinUseMode) then
        ChangePage(SBinPNo);

  FormDesign;

  SNoPageReSize;


  FormResize(Self);

end;


procedure TStockRec.FormDestroy(Sender: TObject);

begin
  ExLocal.Destroy;

  If (InvBtnList<>nil) then
    InvBtnList.Free;


  If (DescCList<>nil) then
    DescCList.Free;

  {$IFDEF NP}
    If (Assigned(SNoteCtrl)) then
    Begin
      SNoteCtrl.Free;
      SNoteCtrl:=nil;
    end;

  {$ENDIF}

end;


procedure TStockRec.FormActivate(Sender: TObject);
begin
  {$B-}

  If ((SerUseMode) or (CQtyBMode) or (BinUseMode) ) and (Current_Page In [SQtyBPNo..SBinPNo]) and (MULCtrlO2[Current_Page]<>nil) then

  {$B+}
    MULCtrlO2[Current_Page].SetListFocus;

end;


procedure TStockRec.DefaultPageReSize;

Var
  n  :  Integer;

Begin

  CLSBox.Width:=PageControl1.Width-PagePoint[0].X;
  CLSBox.Height:=PageControl1.Height-PagePoint[0].Y;

  CListBtnPanel.Left:=CLSBox.Width+4;

  {COSBox.Height:=CLSBox.Height;
  COSBox.Width:=CLSBox.Width;

  COListBtnPanel.Left:=COSBox.Width+4;}

  CLORefPanel.Height:=CLSBox.Height-PagePoint[2].X;

  CListBtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

  {COListBtnPanel.Height:=CListBtnPanel.Height;}


  For n:=Low(MULCtrlO) to High(MULCtrlO) do
    If (MULCtrlO[n]<>nil) then
    Begin
      With MULCtrlO[n],VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=CLORefPanel.Height;

        ReFresh_Buttons;

        RefreshAllCols;
      end;
    end;

end;



{$IFDEF PF_On}

  procedure TStockRec.SNoPageReSize;

  Var
    n  :  Integer;

  Begin
    SNSBox.Height:=CLSBox.Height;
    SNSBox.Width:=CLSBox.Width;

    MBSBox.Height:=CLSBox.Height;
    MBSBox.Width:=CLSBox.Width;

    VSBox.Height:=CLSBox.Height;
    VSBox.Width:=CLSBox.Width;
    QBSBox.Height:=CLSBox.Height;
    QBSBox.Width:=CLSBox.Width;

    SNoPanel.Height:=SNSBox.Height-PagePoint[2].X;

    For n:=Low(MULCtrlO2) to High(MULCtrlO2) do
      If (MULCtrlO2[n]<>nil) then
      Begin
        With MULCtrlO2[n],VisiList do
        Begin
          VisiRec:=List[0];

          With (VisiRec^.PanelObj as TSBSPanel) do
            Height:=SNoPanel.Height;

          ReFresh_Buttons;

          RefreshAllCols;
        end;
      end;

  end;

{$ENDIF}

procedure TStockRec.NotePageReSize;

Begin
  With TCNScrollBox do
  Begin
    TCNListBtnPanel.Left:=Width+4;
    // MH 07/08/07: Removed as it is causing weird resizing effects and doesn't appear to be necessary
    //TNHedPanel.Width:=HorzScrollBar.Range;
    NDatePanel.Height:=TCNListBtnPanel.Height;
  end;

  NDescPanel.Height:=NDatePanel.Height;
  NUserPanel.Height:=NDatePanel.Height;

  {TCNBtnScrollBox.Height:=TCMBtnScrollBox.Height;}

  {$IFDEF NP}

    If (NotesCtrl<>nil) then {* Adjust list *}
    With NotesCtrl.MULCtrlO,VisiList do
    Begin
      VisiRec:=List[0];

      With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=NDatePanel.Height;

      ReFresh_Buttons;

      RefreshAllCols;
    end;

  {$ENDIF}


end;


procedure TStockRec.BOMPageReSize;
Begin
  NLOLine.Width:=BOMPage.Width - (2 * NLOLine.Left);//ClientWidth-5;
  NLOLine.Height:=ClientHeight-140;//104;  // MH 28/08/07: New toolbars are taller

  NLDPanel.Width:=Width-Lab1Ofset;
  NLCrPanel.Left:=Width-Lab2Ofset;
  NLDrPanel.Left:=Width-Lab3Ofset;

  Bevel7.Left := NLOLine.Left;
  Bevel7.Width := NLOLine.Width;

  {$IFDEF PF_On}
    ColXAry[1]:=NLDrPanel.Width+NLDrPanel.Left-4;
    ColXAry[2]:=NLCrPanel.Width+NLCrPanel.Left-4;

    ChrWidth:=Round(Width*ChrsXRoss);

    NLOLine.HideText:=(Width<=383);

    Update_OutLines(StockF,StkCodeK);
  {$ENDIF}

end;


procedure TStockRec.FormResize(Sender: TObject);
Var
  n          :  Byte;


begin

  If (GotCoord) then
  Begin
    LockWindowUpDate(Self{PageControl1}.Handle);

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    //PageControl1.Width := ClientWidth-PageP.X;
    //PageControl1.Height := ClientHeight-PageP.Y;

    PageControl1.Width := ClientWidth - (PageControl1.Left * 2) + 1;
    PageControl1.Height := ClientHeight - (PageControl1.Top * 2) + 1;


    TCMPanel.Left:=PageControl1.Width-ScrollAP.X;
    TCMPanel.Height:=PageControl1.Height-ScrollAP.Y;


    TCMScrollBox.Width:=PageControl1.Width-ScrollBP.X;
    TCMScrollBox.Height:=PageControl1.Height-ScrollBP.Y;

    TCMBtnScrollBox.Height:=TCMPanel.Height-Misc1P.X;


    {TCDPanel.Left:=PageControl1.Width-PagePoint[0].X;
    TCDPanel.Height:=PageControl1.Height-PagePoint[0].Y;}


    {TCDScrollBox.Width:=PageControl1.Width-PagePoint[1].X;
    TCDScrollBox.Height:=(PageControl1.Height-PagePoint[1].Y)+1;}

    {TCNPanel.Left:=PageControl1.Width-PagePoint[2].X;
    TCNPanel.Height:=PageControl1.Height-PagePoint[2].Y;}


    TCNScrollBox.Width:=PageControl1.Width-PagePoint[3].X;
    TCNScrollBox.Height:=PageControl1.Height-PagePoint[3].Y;

    TCNListBtnPanel.Height:=TCNScrollBox.ClientHeight-PagePoint[4].X;

    {$IFDEF PF_On}

      BOMPageReSize;

    {$ENDIF}

    DefaultPageReSize;

    {$IFDEF PF_On}
      SNoPageReSize;
    {$ENDIF}

    NotePageReSize;

    {$IFDEF SOP}
     mbdFrame.mbdResize(TCNScrollBox.Width, TCNScrollBox.Height, TCNListBtnPanel.Height);
     //PR: 19/06/2009 On Stock Record ScrollBar wasn't showing completely
     mbdFrame.scrMBDList.Left := TCNScrollBox.Left;
     mbdFrame.scrMBDList.Top := TCNScrollBox.Top;
    {$ENDIF}

    LockWindowUpDate(0);

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end; {If time to update}
end; {Proc..}


procedure TStockRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If (Current_Page<SQtyBPNo) or (Sender is TSBSComboBox) then
    GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TStockRec.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  n       :  LongInt;

  ONomRec :  ^OutNomType;

begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    With NLOLine do {* Tidy up attached objects *}
    Begin
      For n:=1 to ItemCount do
      Begin
        ONomRec:=Items[n].Data;
        If (ONomRec<>nil) then
          Dispose(ONomRec);
      end;
    end;
    Action:=caFree;

    //PR: 21/11/2011 v6.9 If mbdFrame has been accessed then MULCtrl1O array will contain a pointer to mbdFrame.FMulCtrl. Consequently, we need
    //to set that to nil as it is destroyed, otherwise the frame might try to access it during the resize function which can get called during
    //formclose. ABSEXCH-11948
    {$IFDEF SOP}
    mbdFrame.FMulCtrl := nil;
    {$ENDIF}

    For n:=Low(MULCtrlO) to High(MULCtrlO) do
    Begin
      Try
        If (MULCtrlO[n]<>Nil) then
          MULCtrlO[n].Destroy; {* Must be destroyed here, as otherwise when form open and application is exited a GPF occurs if in form destroy}

      Finally
        MULCtrlO[n]:=Nil;

      end; {Finally..}

    end;



    For n:=Low(MULCtrlO2) to High(MULCtrlO2) do
    Begin
      Try
        If (MULCtrlO2[n]<>Nil) then
          MULCtrlO2[n].Destroy; {* Must be destroyed here,  as otherwise when form open and application is exited a GPF occurs if in form destroy}

      Finally

        MULCtrlO2[n]:=Nil;

      end; {Finally..}

    end;


  end;
end;


Function TStockRec.AllocateOk(ShowMsg  :  Boolean)  :  Boolean;

Const
  warnMessage  :  Array[1..2] of String[10] = ('serial','bin');

Var
 mrRet  :  Word;
 wmNo   :  Byte;

Begin

  Result:=((Round_Up(SerialReq,Syss.NoQtyDec)=0.00) or ((Not SerUseMode) and (Not BinUseMode)) or (InSerFind) or (InBinFind));

  If (ShowMsg) then
  Begin
    If (Not Result) then
    Begin
      wmNo:=(1*Ord(SerUseMode))+(2*Ord(BinUseMode));

      If ((ChkAllowed_In(244)) and (SerUseMode)) or ((ChkAllowed_In(430)) and (BinUseMode)) then
      Begin
        mrRet:=MessageDlg('Warning!'+#13+#13+'Not enough '+warnMessage[wmNo]+' numbers have been selected. Quit anyway?',mtConfirmation,[mbYes,mbNo],0);
        Result:=mrRet=mrYes;
      end
      else
      Begin
        Result:=BOff;
        ShowMessage('Warning!'+#13+#13+'Not enough '+warnMessage[wmNo]+' numbers have been selected. Please Correct');
      end;
    end;
  end;
end;


Function TStockRec.CheckListFinished  :  Boolean;

Var
  n       :  Byte;
  mbRet   :  Word;
Begin
  Result:=BOn;

  For n:=Low(MULCtrlO) to High(MULCtrlO) do
  Begin
    If (Assigned(MULCtrlO[n])) then
      Result:=Not MULCtrlO[n].ListStillBusy;

    If (Not Result) then
    Begin
      Set_BackThreadMVisible(BOn);

      mbRet:=MessageDlg('One of the lists is still busy.'+#13+#13+
                        'Do you wish to interrupt the list so that you can exit?',mtConfirmation,[mbYes,mbNo],0);

      If (mBRet=mrYes) then
      Begin
        MULCtrlO[n].IRQSearch:=BOn;

        ShowMessage('Please wait a few seconds, then try closing again.');
      end;

      Set_BackThreadMVisible(BOff);

      Break;
    end;
  end;
end;


procedure TStockRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

Var
  n       :  Integer;


begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try

      CanClose:=(ConfirmQuit and AllocateOk(BOn));

      If (CanClose) and (SerUseMode) and (Not InSerFind) then
        CanClose:=ManClose;

      If (CanClose) and (BinUseMode) and (Not InBinFind) then
        CanClose:=ManClose;

      If (CanClose) then
        CanClose:=CheckListFinished;

      GenCanClose(Self,Sender,CanClose,BOff);

      If (CanClose) then
        CanClose:=GenCheck_InPrint;

      ManClose:=BOff;

      If (CanClose) then
      Begin

        For n:=0 to Pred(ComponentCount) do
          If (Components[n] is TScrollBox) then
          With TScrollBox(Components[n]) do
          Begin
            VertScrollBar.Position:=0;
            HorzScrollBar.Position:=0;
          end;

        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;


        // CJS: 14/12/2010 Changed to use new Window Position System
        If (NeedCUpdate) {And (StoreCoord Or FColorsChanged)} then
          // Store_FormCoord(Not SetDefault);
          SaveWindowSettings;


        Send_UpdateList(BOff,100);

        {$IFDEF NP}
          If (NotesCtrl<>nil) then
          Begin
            try
              // MH 11/01/2011 v6.6 ABSEXCH-10718: Fix to prevent access violations if mouse moved across Notes column titles whilst form closes
              NotesCtrl.UnHookOnMouse;
              NotesCtrl.Free;

            finally

              NotesCtrl:=nil;
            end;
          end;
        {$ENDIF}

        {* Set here to avoid a call from a parent being called twice *}

        SerUseMode:=BOff;
        BinUseMode:=BOff;

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;
end;


procedure TStockRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

Begin
  If (Current_Page<SNotesPNo) or (Key In [VK_F1..VK_F12,VK_Prior,VK_Next])  or (Sender is TComboBox) then
    GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

end;


{== Display G/L descriptions ==}

procedure TStockRec.Out_GLDesc(GLCode  :  Str20;
                               OutObj  :  TObject;
                               ItsJA   :  Boolean);
Var
  FoundOk  :  Boolean;
  NomCode,
  FoundCode:  LongInt;
  FoundCode2
           :  Str20;

Begin
  {$B-}
  If (Assigned(OutObj)) and (OutObj is Text8Pt) then
  With Text8pt(OutObj) do
  Begin
    If (ItsJA) then
    Begin
      If (JBCostOn) then
      Begin
         FoundOk:=GetJobMisc(Self,GLCode,FoundCode2,2,-1);

         If (FoundOk) then
           Text:=JobMisc^.JobAnalRec.JAnalName
         else
           Text:='';
      end;

    end
    else
    Begin
      NomCode:=IntStr(Trim(GLCode));

      If (Nom.NomCode<>NomCode) and (NomCode<>0)then
        FoundOk:=GetNom(Self,Form_Int(NomCode,0),FoundCode,-1)
      else
        FoundOk:=(NomCode<>0);

      If (FoundOk) then
        Text:=Nom.Desc
      else
        Text:='';

    end;

  end;

  {$B+}
end;

procedure TStockRec.Show_GLDesc(Sender: TObject);

Var
  ShowAll  :  Boolean;

begin
  ShowAll:=Not Assigned(Sender);

  {$B-}
    If (ShowAll) or (Sender=SRGSF) then
      Out_GLDesc(SRGSF.Text,SGLDF,BOff);

    If (ShowAll) or (Sender=SRGCF) then
      Out_GLDesc(SRGCF.Text,CGLDF,BOff);

    If (ShowAll) or (Sender=SRGWF) then
      Out_GLDesc(SRGWF.Text,WGLDF,BOff);

    If (ShowAll) or (Sender=SRGVF) then
      Out_GLDesc(SRGVF.Text,KGLDF,BOff);

    If (ShowAll) or (Sender=SRGPF) then
      Out_GLDesc(SRGPF.Text,FGLDF,BOff);

    If ((ShowAll) or (Sender=SRJAF)) and (JBCostOn) then
      Out_GLDesc(SRJAF.Text,JADF,BOn);

    {$IFDEF WOP}
      If (ShowAll) or (Sender=SRGIF) then
        Out_GLDesc(SRGIF.Text,FGLIF,BOff);
    {$ENDIF}

    {$IFDEF RET}
      If (ShowAll) or (Sender=SRRGLF) then
        Out_GLDesc(SRRGLF.Text,SRRGLDF,BOff);

      If (ShowAll) or (Sender=SRRPGLF) then
        Out_GLDesc(SRRPGLF.Text,SRRGLPDF,BOff);

    {$ENDIF}

  {$B+}
end;

procedure TStockRec.ClsCP1BtnClick(Sender: TObject);
begin
  If (ConfirmQuit) then
  Begin
    ManClose:=BOn;
    Close;
  end;
end;


Procedure TStockRec.SetPricing;

Var
  LastII  :  Integer;

Begin
  With SRPComboF,Items,ExLocal,LStock do
  Begin
    Clear;
    Add('Stock Unit - '+SRUQF.Text);
    Add('Sales Unit - '+SRUSF.Text);

    {$IFNDEF LTE}
      Add('Split Pack - '+SRUSF.Text);
    {$ENDIF}
    
    ItemIndex:=StkPriceIndex(LStock);
  end;
end;

Function TStockRec.CalcGP(BNo  :  Byte)  :  Double;

Begin
  With ExLocal,LStock,SaleBands[BNo] do
  Begin

    If (SalesPrice<>0) and ChkAllowed_In(143) then
      Result:=Stock_Gp(LStock.CostPrice,Currency_ConvFT(SalesPrice,Currency,LStock.PCurrency,UseCoDayRate),
            LStock.BuyUnit,LStock.SellUnit,Ord(Syss.ShowStkGP),LStock.CalcPack)
    else
      Result:=0;

  end; {With..}
end;

{ == Massage equivalent stock type based on full release code == }

Function  TStockRec.EquivSTItem  :  Integer;

Begin
  If (Not FullStkSysOn) then
    Result:=SRTF.ItemIndex+1
  else
    Result:=SRTF.ItemIndex;

end;


// MH 08/09/2014 v7.1 ABSEXCH-15052: Added new EC Service field
Procedure TStockRec.SetECServiceVisibility (Const StockType : Char);
Begin // SetECServiceVisibility
  // MH 18/05/2016 2016-R2 ABSEXCH-17470: Moved EC Service fields to new Tax tab
                           // Only show for UK and EIRE
  panECServices.Visible := ((CurrentCountry = UKCCode) Or (CurrentCountry = IECCode))
                           // If EC Services are enabled
                           And SyssVAT.VATRates.EnableECServices
                           // For Description Only stock items
                           And (StockType = StkDescCode);
  ReOrgTaxPanels;
End; // SetECServiceVisibility


{ === Procedure to Output one Stock record === }
Procedure TStockRec.OutStock;

Var
  CrDr       :   DrCrDType;

  Cleared,
  ThisPr,
  ThisYTD,
  LastYTD,
  Budget1,
  Budget2,
  Commit,

  Dnum       :   Double;

  D,H,M      :  Extended;

  n          :   LongInt;

  TmpStk     :   StockRec;


Begin

  Blank(CrDr,Sizeof(CrDr));

  ThisPr:=0; ThisYTD:=0; LastYTD:=0;  Cleared:=0;

  Budget1:=0;

  Budget2:=0;

  Commit:=0;

  With ExLocal,LStock do
  Begin
    TmpStk:=LStock;

    {$IFDEF SOP}

      Stock_LocSubst(TmpStk,SRecLocFilt);

    {$ENDIF}


    //TG 22-05-2017 ABSEXCH-18726 UI changes on Stock Record Window
    if not(trim(StockCat) = '') then
    	lblStkGrp.Caption := trim(StockCat)
    else
			lblStkGrp.caption := '';


    SRCF.Text:=Strip('B',[#32],StockCode);
    SRTF.ItemIndex:=StkPT2I(StockType);

    For n:=1 to NofSDesc do
      Text8Pt(DescCList.IdWinRec(Pred(n))).Text:=TrimRight(Desc[n]);


    OutPrices;

    If (Assigned(Prices)) then
      EditSPBtnClick(nil);



    {$IFDEF MC_On}
      SRCPCF.ItemIndex:=Pred(PCurrency);
      SRRPCF.ItemIndex:=Pred(ROCurrency);
    {$ENDIF}


    If PChkAllowed_In(143) then
    Begin
      SRCPF.Value:=CostPrice;
      SRRPF.Value:=ROCPrice;
    end
    else
    Begin
      SRCPF.Value:=0.0;;
      SRRPF.Value:=0.0;
    end;

    SRVMF.ItemIndex:=StkVM2I(SetStkVal(StkValType,SerNoWAvg,BOn));

    SRLTF.ItemIndex:=StkLinkLT;

    LastQtyMin:=QtyMin;
    LastQtyMax:=QtyMax;

    SRMIF.Value:=CaseQty(LStock,QtyMin);
    SRMXF.Value:=CaseQty(LStock,QtyMax);

    With TmpStk do
    Begin
      Cleared:=Profit_to_Date(Calc_AltStkHCode(StockType),
                              CalcKeyHist(StockFolio,SRecLocFilt),0,GetLocalPr(0).Cyr,GetLocalPr(0).CPr,CrDr[BOff],CrDr[BOn],Commit,BOn);

      SRISF.Value:=CaseQty(TmpStk,QtyInStock);
      SRPOF.Value:=CaseQty(TmpStk,Commit);
      SRALF.Value:=CaseQty(TmpStk,AllocStock(TmpStk));
      SRFRF.Value:=CaseQty(TmpStk,FreeStock(TmpStk));
      SROOF.Value:=CaseQty(TmpStk,QtyOnOrder);

      {$IFDEF WOP}
        SRAWF.Value:=CaseQty(TmpStk,WOPAllocStock(TmpStk));
        SRIWF.Value:=CaseQty(TmpStk,QtyIssueWOR);
        SRPWF.Value:=CaseQty(TmpStk,QtyPickWOR);


      {$ENDIF}

      {$IFDEF RET}
        SRRSRF.Value:=CaseQty(TmpStk,QtyReturn);
        SRRPRF.Value:=CaseQty(TmpStk,QtyPReturn);
      {$ENDIF}


    end; {with..}

    SRFSF.Text:=TrimRight(Supplier);

    If (Supplier<>Cust.CustCode) then {* For Link to F2..}
      Global_GetMainRec(CustF,Supplier);

    SRACF.Text:=TrimRight(AltCode);

    {$IFDEF PF_On}
      SRCCF.Text:=TrimRight(CCDep[BOn]);
      SRDepF.Text:=TrimRight(CCDep[BOff]);
    {$ENDIF}

    If (VATCode In VATSet) then
      cbTaxCode.ItemIndex:=GetVATIndex(VATCode);

    If Syss.IntraStat then
    Begin
      CCodeF.Text:=CommodCode;
      SSUDF.Text:=UnitSupp;
      SSDUF.Value:=SuppSUnit;
      SWF.Value:=SWeight;
      PWF.Value:=PWeight;

      If (CurrentCountry=IECCode) then
      Begin
        SRSUP.Value:=SSDDUpLift;
        // MH 04/04/2012 v6.10.1 ABSEXCH-12546: Added Intrastat Uplift Arrivals% into UI for EIRE Intrastat configurations
        ccyIntrastatArrivalsPerc.Value := SSDAUpLift;
      End; // If (CurrentCountry=IECCode)

      SRCOF.Text:=SSDCountry;
    end;

    // MH 08/09/2014 v7.1 ABSEXCH-15052: Added new EC Service field
    SetECServiceVisibility (ExLocal.LStock.StockType);
    chkECService.Checked := stIsService;

    SRBLF.Text:=TrimRight(BinLoc);

    If (JBCostOn) then
      SRJAF.Text:=TrimRight(JAnalCode);

    SRGSF.Text:=Form_BInt(NomCodes[1],0);
    SRGCF.Text:=Form_BInt(NomCodes[2],0);
    SRGWF.Text:=Form_BInt(NomCodes[3],0);
    SRGVF.Text:=Form_BInt(NomCodes[4],0);
    SRGPF.Text:=Form_BInt(NomCodes[5],0);

    {$IFDEF WOP}
      SRGIF.Text:=Form_BInt(WOPWIPGL,0);

      Time2Mins(ProdTime,D,H,M,0);

      DefUdF.Position:=Round(D);

      SRASSDF.Value:=D;

      SBSUpDown1.Position:=Round(H);

      SRASSHF.Value:=H;

      SBSUpDown2.Position:=Round(M);

      SRASSMF.Value:=M;

      SBSUpDown3.Position:=LeadTime;

      SRROLTF.Value:=LeadTime;
      SRMEBQF.value:=MinEccQty;

      CBCalcProdT.Checked:=CalcProdTime;

      BOMTimePanel.Caption:=ProdTime2Str(BOMProdTime+ProdTime);
    {$ENDIF}

    {$IFDEF RET}
      SRRGLF.Text:=Form_BInt(ReturnGL,0);
      SRRPGLF.Text:=Form_BInt(PReturnGL,0);

      SBSUpDown4.Position:=SWarranty;
      SRRSWDF.Value:=SWarranty;

      SBSUpDown5.Position:=MWarranty;
      SRRMWDF.Value:=MWarranty;

      SRRSWMF.ItemIndex:=SWarrantyType;
      SRRSMMF.ItemIndex:=MWarrantyType;

      SRRRCF.Text:=PPR_PamountStr(ReStockPcnt,ReStockPChr);

    {$ENDIF}

    SRMBF.Checked:=MultiBinMode;

    Show_GLDesc(Nil);


    SRUQF.Text:=UnitK;
    SRUSF.Text:=UnitS;
    SRUPF.Text:=UnitP;

    SRSPF.Checked:=DPackQty;

    SetPricing;

    SRSUF.Value:=SellUnit;
    SRPUF.Value:=BuyUnit;

    UD1F.Text:=StkUser1;
    UD2F.Text:=StkUser2;
    UD3F.Text:=StkUser3;
    UD4F.Text:=StkUser4;
    //GS 24/10/2011 ABSEXCH-11706: updated to support 10 UDEFs
    UD5F.Text:=StkUser5;
    UD6F.Text:=StkUser6;
    UD7F.Text:=StkUser7;
    UD8F.Text:=StkUser8;
    UD9F.Text:=StkUser9;
    UD10F.Text:=StkUser10;


    SRBCF.Text:=Trim(BarCode);
    SRLocF.Text:=DefMLoc;

    emWebF.Checked:=(WebInclude=1);
    WebCatF.Text:=WebLiveCat;
    WebImgF.Text:=ImageFile;
  end; {with..}

end; {Proc..}


Procedure TStockRec.Form2Stock;

Var
  I,n  :  Integer;

Begin

  With ExLocal,LStock do
  Begin

    StockCode:=FullStockCode(SRCF.Text);

    StockType:=StkI2PT(SRTF.ItemIndex);

    For n:=1 to NofSDesc do
      Desc[n]:=Text8Pt(DescCList.IdWinRec(Pred(n))).Text;

    Desc[1]:=LJVar(Desc[1],StkDesKLen);

    With SRPComboF do
    Begin
      CalcPack:=(ItemIndex=0);
      PricePack:=(ItemIndex=2);
    end;



    {$IFDEF MC_On}
      If (SRCPCF.ItemIndex>-1) then
        PCurrency:=Succ(SRCPCF.ItemIndex)
      else
        PCurrency:=1;

      If (SRRPCF.ItemIndex>-1) then
        ROCurrency:=Succ(SRRPCF.ItemIndex)
      else
        ROCurrency:=1;
    {$ENDIF}

    If PChkAllowed_In(143) then
    Begin
      CostPrice:=SRCPF.Value;
      ROCPrice:=SRRPF.Value;
    end;

    StkValType:=SetStkVal(StkI2VM(SRVMF.ItemIndex),SerNoWAvg,BOff);

    If (StockType=StkDescCode) and (StkValType<>StkLCCode) and (StkValType<>'S') then
      StkValType:=StkLCCode;


    {QtyMin:=SRMIF.Value;
    QtyMax:=SRMXF.Value;}

    QtyMin:=LastQtyMin;
    QtyMax:=LastQtyMax;

    If (SRLTF.ItemIndex>=0) then
      StkLinkLT:=SRLTF.ItemIndex;

    Supplier:=FullCustCode(SRFSF.Text);
    AltCode:=FullStockCode(SRACF.Text);

    {$IFDEF PF_On}
      CCDep[BOn]:=FullCCDepKey(SRCCF.Text);
      CCDep[BOff]:=FullCCDepKey(SRDepF.Text);
    {$ENDIF}

    With cbTaxCode do
      If (ItemIndex>-1) then
        VATCode:=Items[ItemIndex][1]
      else
        VATCode:=VATSTDCode;

    If Syss.IntraStat then
    Begin
      // PKR. 05/02/2016. ABSEXCH-17261. Validation of Commodity Code if ti contains spaces.
      CommodCode:=Trim(CCodeF.Text);
      UnitSupp:=SSUDF.Text;
      SuppSUnit:=SSDUF.Value;
      SWeight:=SWF.Value;
      PWeight:=PWF.Value;

      If (CurrentCountry=IECCode) then
      Begin
        SSDDUpLift:=SRSUP.Value;
        // MH 04/04/2012 v6.10.1 ABSEXCH-12546: Added Intrastat Uplift Arrivals% into UI for EIRE Intrastat configurations
        SSDAUpLift := ccyIntrastatArrivalsPerc.Value;
      End; // If (CurrentCountry=IECCode)

      SSDCountry:=SRCOF.Text;
    end;

    // MH 08/09/2014 v7.1 ABSEXCH-15052: Added new EC Service field
    If chkECService.Visible And chkECService.Enabled And (StockType = StkDescCode) Then
      stIsService := chkECService.Checked
    Else
      stIsService := False;

    BinLoc:=LJVar(SRBLF.Text,BinLocLen);

    If (JBCostOn) then
      JAnalCode:=FullJACode(SRJAF.Text);

    NomCodes[1]:=IntStr(SRGSF.Text);
    NomCodes[2]:=IntStr(SRGCF.Text);
    NomCodes[3]:=IntStr(SRGWF.Text);
    NomCodes[4]:=IntStr(SRGVF.Text);
    NomCodes[5]:=IntStr(SRGPF.Text);

    {$IFDEF WOP}
      WOPWIPGL:=IntStr(SRGIF.Text);

      CompTime2Mins(ProdTime,SRASSDF,SRASSHF,SRASSMF,1);

      LeadTime:=Round(SRROLTF.Value);
      MinEccQty:=SRMEBQF.Value;

      CalcProdTime:=CBCalcProdT.Checked;
    {$ENDIF}

    {$IFDEF RET}
      ReturnGL:=IntStr(SRRGLF.Text);
      PReturnGL:=IntStr(SRRPGLF.Text);


      SWarranty:=Round(SRRSWDF.Value);
      MWarranty:=Round(SRRMWDF.Value);

      If (SRRSWMF.ItemIndex>=0) then
        SWarrantyType:=SRRSWMF.ItemIndex;

      If (SRRSMMF.ItemIndex>=0) then
        MWarrantyType:=SRRSMMF.ItemIndex;

      ProcessInputDPAmount(ReStockPcnt,ReStockPChr,SRRRCF.Text);

    {$ENDIF}

      If (Not (ExLocal.LStock.StkValType In ['E','R'])) then
        MultiBinMode:=SRMBF.Checked
      else
        MultiBinMode:=BOff;

    UnitK:=SRUQF.Text;
    UnitS:=SRUSF.Text;
    UnitP:=SRUPF.Text;

    SellUnit:=SRSUF.Value;
    BuyUnit:=SRPUF.Value;

    StkUser1:=UD1F.Text;
    StkUser2:=UD2F.Text;
    StkUser3:=UD3F.Text;
    StkUser4:=UD4F.Text;
    //GS 24/10/2011 ABSEXCH-11706: updated to support 10 UDEFs
    StkUser5:=UD5F.Text;
    StkUser6:=UD6F.Text;
    StkUser7:=UD7F.Text;
    StkUser8:=UD8F.Text;
    StkUser9:=UD9F.Text;
    StkUser10:=UD10F.Text;

    BarCode:=FullBarCode(SRBCF.Text);

    DPackQty:=SRSPF.Checked;

    {$IFDEF SOP}

      DefMLoc:=Full_MLocKey(SRLocF.Text);

    {$ELSE}
      DefMLoc:=SRLocF.Text;

    {$ENDIF}

    WebInclude:=Ord(emWebF.Checked);

    WebLiveCat:=WebCatF.Text;
    ImageFile:=WebImgF.Text;

  end; {with..}

end; {Proc..}


Procedure TStockRec.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      SMainPNo
         :  If (LastEdit) then
              SRD1F.SetFocus
            else
              SRCF.SetFocus;

      SDefaultPNo
         :  SRFSF.SetFocus;

      // MH 17/05/2016 2016-R2 ABSEXCH-17470: Added Tax tab for MRT
      STaxPNo
         :  cbTaxCode.SetFocus;

      SDef2PNo
         :  If (emWebF.Visible) then
              emWebF.SetFocus
            else
              SRLTF.SetFocus;

      SWOPPNo
         :  SRROLTF.SetFocus;

      SRetPNo
         :  SRRSWDF.SetFocus;

    end; {Case&With..}

end; {Proc..}


Procedure TStockRec.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  If (Pages[NewPage].TabVisible) then
  Begin
    {$IFDEF DBD}
      If (Debug) then
        DebugForm.Add('Change Page '+IntToStr(NewPage));
    {$ENDIF}

    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);


  end; {With..}
end; {Proc..}


Function TStockRec.CheckNeedStore  :  Boolean;

Var
  Loop  :  Integer;

Begin
  Result:=BOff;
  Loop:=0;

  While (Loop<=Pred(ComponentCount)) and (Not Result) do
  Begin
    If (Components[Loop] is TMaskEdit) then
      With (Components[Loop] as TMaskEdit) do
      Begin
        Result:=((Tag=1) and (Modified));

        If (Result) then
          Modified:=BOff;
      end
    else If (Components[Loop] is TCurrencyEdit) then
      With (Components[Loop] as TCurrencyEdit) do
      Begin
        Result:=((Tag=1) and (FloatModified));

        If (Result) then
          FloatModified:=BOff;
      end
    // MH 18/05/2016 2016-R2 ABSEXCH-17470: Replaced TBorCheck with TCheckBoxEx
    else If (Components[Loop] is TCheckBoxEx) then
      With (Components[Loop] as TCheckBoxEx) do
      Begin
        Result := (Tag=1) and Modified;

        If (Result) then
          Modified:=BOff;
      end
    else If (Components[Loop] is TSBSComboBox) then
      With (Components[Loop] as TSBSComboBox) do
      Begin
        Result:=((Tag=1) and (Modified));

        If (Result) then
          Modified:=BOff;
      end;

    Inc(Loop);
  end; {While..}
end;


Function TStockRec.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;


  If (ExLocal.InAddEdit) and (CheckNeedStore) then
  Begin
    If (Current_Page>SRetPNo) then {* Force view of main page *}
      ChangePage(SMainPNo);

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StoreStock(StockF,SKeypath,ExLocal.LastEdit);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) then
                Begin

                  Delete_StkEditNow(LStock.StockFolio);
                  
                  Status:=UnLockMLock(StockF,LastRecAddr[StockF]);

                end;
                If (InAddEdit) then
                  SetStockStore(BOff,LastEdit);

                TmpBo:=BOn;
              end;

    mrCancel
           :  Begin
                TmpBo:=BOff;
                SetfieldFocus;
              end;
  end; {Case..}


  ConfirmQuit:=TmpBo;
end; {Func..}


procedure TStockRec.SetCompRO(TC     :  TComponent;
                        Const TG     :  Integer;
                        Const EnabFlg:  Boolean);


Begin
  If (TC is TMaskEdit) then
    With (TC as TMaskEdit) do
    Begin
      If (Tag=TG) then
        ReadOnly:= Not EnabFlg;
    end
  else If (TC is TCurrencyEdit ) then
    With (TC as TCurrencyEdit) do
    Begin
      If (Tag=TG) then
        ReadOnly:= Not EnabFlg;
    end
  // MH 18/05/2016 2016-R2 ABSEXCH-17470: Replaced TBorCheck with TCheckBoxEx
  else If (TC is TCheckBoxEx) then
    With (TC as TCheckBoxEx) do
    Begin
      If (Tag=TG) then
        ReadOnly:= Not EnabFlg;
    end
  else If (TC is TBorRadio) then
    With (TC as TBorRadio) do
    Begin
      If (Tag=TG) then
        Enabled:=EnabFlg;
    end
  else If (TC is TUpDown) then
    With (TC as TUpDown) do
    Begin
      If (Tag=1) then
        Enabled:=EnabFlg;
    end
  else If (TC is TSBSComboBox) then
    With (TC as TSBSComboBox) do
    Begin
      If (Tag=TG) then
        ReadOnly:=Not EnabFlg;
    end;
end;


procedure TStockRec.SetStockStore(EnabFlag,
                                  ButnFlg  :  Boolean);

Var
  Loop  :  Integer;

Begin

  OkCP1Btn.Enabled:=EnabFlag;
  CanCP1Btn.Enabled:=EnabFlag;

  AddCP1Btn.Enabled:=Not EnabFlag;

  EditCP1Btn.Enabled:=Not EnabFlag;

  FindCP1Btn.Enabled:=Not EnabFlag;

  DelCP1Btn.Enabled:=((Not EnabFlag) and (SetDelBtn));

  HistCP1Btn.Enabled:=Not EnabFlag;

  InsCP1Btn.Enabled:=Not EnabFlag;
  PrnCP1Btn.Enabled:=Not EnabFlag;
  ChkCP1Btn.Enabled:=Not EnabFlag;
  CopyCP1Btn.Enabled:=Not EnabFlag;
  LnkCP1Btn.Enabled:=Not EnabFlag;
  Altdb1Btn.Enabled:=Not EnabFlag;


  ExLocal.InAddEdit:=EnabFlag;

  {IntBtn.Enabled:=Syss.IntraStat;}

  If (ExLocal.InAddEdit) then
    Set_EntryRO(EquivSTItem)
  else
    For Loop:=0 to ComponentCount-1 do
    Begin
      SetCompRO(Components[Loop],1,EnabFlag);
    end;

  With ExLocal do
    SRCF.ReadOnly:=(Not Enabled) or (((Not CanDelete) and (Not ChkAllowed_In(200))) and ((Not InAddEdit) or (LastEdit))) or ((ICEDFM<>0) and (LastEdit)) ;

end;


Procedure TStockRec.Set_MBin(PTMode  :  Byte);

Begin
  SRMBF.Enabled:=(PTMode In [0,4]) and (Not (ExLocal.LStock.StkValType In ['E','R']));
end;

Procedure TStockRec.Move_BinMode;

Begin
  If (Assigned(MULCtrlO2[Current_Page])) then
  With MULCtrlO2[Current_Page], MLocCtrl^.brBinRec do
  If (ValidLine) and (Not brBatchChild) then
  Begin
    BINUseMode:=BOn;
    BinMoveMode:=BOn;
    OutSerialReq;
    EditCP1BtnClick(Edit1);
  end;

end;





Procedure TStockRec.Set_EntryRO(PTMode  :  Byte);

Var
  Loop  :  Integer;
  TC    :  TComponent;

Begin


  For Loop:=0 to ComponentCount-1 do
  Begin
    TC:=Components[Loop];

    If (TC<>SRCF)  then {* Do not change Stock code, as maybe set to readonly.. *}
      SetCompRO(TC,1,BOn); {* Reset them all first *}

    Case PTMode of
       0  :  ;    {Product}

       1  :  Begin {Description only}
               If (TC=SRFSF) or (TC=SRUQF) or (TC=SRUSF) or (TC=SRUPF) or (TC=SRSUF) or (TC=SRPUF) then
                 SetCompRO(TC,1,BOff);
             end;
       2,3 {* Group/Desc only}
         :  If (TC<>SRTF) and (TC<>SRD1F) and (TC<>SRD2F) and (TC<>SRD3F) and (TC<>SRD4F) and (TC<>SRD5F) and (TC<>SRD6F) and (TC<>emWebF)
            {$IFDEF LTE} and (TC<>SRGSF) and (TC<>SRGCF) and (TC<>SRGWF) and (TC<>SRGVF) and (TC<>SRGPF)  and (TC<>SRGIF) and (TC<>SRRGLF) and (TC<>SRRPGLF) {$ENDIF}
            and (TC<>UD1F) and (TC<>UD2F) and (TC<>UD3F) and (TC<>UD4F)
            //GS 25/10/2011 ABSEXCH-11706: updated to support 10 UDEFs
            and (TC<>UD5F) and (TC<>UD6F) and (TC<>UD7F) and (TC<>UD8F) and (TC<>UD9F) and (TC<>UD10F)
            and (TC<>WebCatF) and ((TC<>SRCF) or (ExLocal.LastEdit)) then
              SetCompRO(TC,1,BOff);

       4  :  Begin
               If (TC=SRCPF) then
                 SetCompRO(TC,1,BOff);

             end;

    end; {Case..}

    If ((TC=SRCPF) or (TC=SRRPF)) and (Not PChkAllowed_In(143)) then {* Set Cost & Re-Order proce to R/O if GP not set *}
      SetCompRO(TC,1,BOff);

    If ((TC=SRCPF) {$IFDEF MC_On} or (TC=SRCPCF){$ENDIF}) and (Not PChkAllowed_In(313)) then {Set Cost price to R/O regardless if pw set}
      SetCompRO(TC,1,BOff);

    If ((TC=SRGSF) or (TC=SRGCF) or (TC=SRGWF)  or (TC=SRGVF) or (TC=SRGPF)  or (TC=SRGIF) or (TC=SRRGLF) or (TC=SRRPGLF)) and (Not PChkAllowed_In(570)) and (ExLocal.LastEdit) then {* Set G/L Code access to R/O if PW in Edit Mode not set *}
      SetCompRO(TC,1,BOff);

    If (TC=SRMBF) then
      Set_MBin(PTMode);
  end; {Loop..}


  SRSP1F.ReadOnly:=BOn;
  SRSP1F.TabStop:=BOn;

  SRGP1.ReadOnly:=BOn;
  SRGP1.TabStop:=BOff;

  EditSPBtn.Enabled:=(PTMode<>2);
  
end; {Proc..}



{ =============== Procedure to Find Next Availabel Code ============ }

Function TStockRec.Auto_GetSCode(CCode    :  Str20;
                                 Fnum,
                                 Keypath  :  Integer)  :  Str20;



Var
  KeyS  :  Str255;

  UseNumber
        :  Boolean;

  TmpStat
        :  Integer;

  TmpRecAddr
        :  LongInt;
  TmpStock
        :  StockRec;

  NewNo :  Str10;

  LCode :  Str20;

  PadLen,
  LLen  :  Byte;

  n     :  SmallInt;



Begin


  TmpStock:=Stock;

  TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOff,BOff);

  LCode:=Trim(CCode);

  LLen:=Length(LCode);

  n:=IntStr(Copy(LCode,LLen-1,2));

  UseNumber:=(n<>0);

  Repeat

    KeyS:=FullStockCode(CCode);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    If (StatusOk) then
    Begin

      Inc(n);

      NewNo:=Form_Int(n,0);

      PadLen:=2+Ord(n>99);


      If (LLen<=(StkKeyLen-PadLen)) then
        CCode:=Copy(LCode,1,LLen-(2*Ord(UseNumber)))+SetPadNo(NewNo,PadLen)
      else
        CCode:=Copy(CCode,1,StkKeyLen-PadLen)+SetPadNo(NewNo,PadLen);

    end;

  Until (Not StatusOk) or (n=999);

  TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOn,BOff);

  Stock:=TmpStock;

  Auto_GetSCode:=FullStockCode(CCode);

end; {Func..}


procedure TStockRec.SRCFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str20;

  { CJS 2012-08-28 - ABSEXCH-11183 - Stock Code and Time Rate clash }
  function TimeRateExists: Boolean;
  var
    Key: Str255;
    TmpStat: Integer;
    TmpKPath:  Integer;
    TmpRecAddr:  LongInt;
    Currency: Byte;
    FirstCurrency: Byte;
    LastCurrency: Byte;
  Begin
    // Store the current record position
    TmpKPath := GetPosKey;
    TmpStat  := Presrv_BTPos(JCtrlF, TmpKPath, F[JCtrlF], TmpRecAddr, False, True);

    {$IFDEF MC_On}
    FirstCurrency := 1;
    LastCurrency  := CurrencyType;
    {$ELSE}
    FirstCurrency := 0;
    LastCurrency  := 0;
    {$ENDIF}

    // Work through all the currencies
    Result := False;
    for Currency := FirstCurrency to LastCurrency do
    begin
      if IsCurrencyUsed(Currency) then
      begin
        Key    := FullJBKey('J', 'E', FullJBCode('ÿÿÿÿ', Currency, CCode));
        Status := Find_Rec(B_GetEq, F[JCtrlF], JCtrlF, RecPtr[JCtrlF]^, JCK, Key);
        Result := (Status=0);
        if Result then
          break;
      end;
    end;

    // Restore the record position
    TmpStat := Presrv_BTPos(JCtrlF, TmpKPath, F[JCtrlF], TmpRecAddr, True, True);
  end;

begin

  If (Sender is TMaskEdit) and (ActiveControl<>CanCP1Btn) then
  With (Sender as TMaskEdit),ExLocal do
  Begin
    {$IFDEF CU}
      If (Not ReadOnly) then
        Text:=TextExitHook(3000,1,Trim(Text),ExLocal);
    {$ENDIF}


    CCode:=FullStockCode(Text);

    If ((Not LastEdit) or (LastStock.StockCode<>CCode)) and (InAddEdit) then
    Begin
      COk:=(Not Check4DupliGen(CCode,StockF,StkCodeK,'Record ('+Strip('B',[#32],CCode)+')'));

      { CJS 2012-08-28 - ABSEXCH-11183 - Stock Code and Time Rate clash }
      If (COk) then
      begin
        COk := not TimeRateExists;
        if not COk then
          MessageDlg('That Stock Code already exists as a Time Rate Code.', mtWarning, [mbOk], 0);
      end;

      If (Not COk) then
      Begin

        Text:=Auto_GetSCode(CCode,StockF,StkCodeK);

        ChangePage(SMainPNo);

        SRCF.SetFocus;

        StopPageChange:=BOn;


      end
      else
        StopPageChange:=BOff;


    end;
  end;
end;

procedure TStockRec.SRMIFEnter(Sender: TObject);
begin
  With ExLocal do
    If (InAddEdit) then
    Begin
      SRMIF.Value:=LastQtyMin;
    end;
end;

procedure TStockRec.SRMIFExit(Sender: TObject);
begin
  With ExLocal do
    If (InAddEdit) then
    Begin
      LastQtyMin:=SRMIF.Value;
      SRMIF.Value:=CaseQty(LStock,LastQtyMin);
    end;
end;


procedure TStockRec.SRMXFEnter(Sender: TObject);
begin
  With ExLocal do
    If (InAddEdit) then
    Begin
      SRMXF.Value:=LastQtyMax;
    end;
end;


procedure TStockRec.SRMXFExit(Sender: TObject);
begin
  With ExLocal do
    If (InAddEdit) then
    Begin
      LastQtyMax:=SRMXF.Value;
      SRMXF.Value:=CaseQty(LStock,LastQtyMax);

      ChangePage(SDefaultPNo);
      SetFieldFocus;
    end;
end;

procedure TStockRec.SRPUFExit(Sender: TObject);
begin
  With ExLocal do
    If (InAddEdit) then
    Begin
      // MH 17/05/2016 2016-R2 ABSEXCH-17470: Added Tax tab for MRT
      ChangePage(STaxPNo);
      SetFieldFocus;
    end;

end;


{ ======= Return True if Product Type ======== }

Function TStockRec.ISProdMode(ProdType  :  Char;
                              Mode      :  Char)  :  Boolean;

Begin

  ISProdMode:=(ProdType=Mode);

end;



(*  Add is used to add Stock*)

procedure TStockRec.ProcessStock(Fnum,
                                 KeyPAth    :  Integer;
                                 Edit       :  Boolean);

Var
  KeyS     :  Str255;
  n        :  Integer;

Begin

  Addch:=ResetKey;

  KeyS:='';


  SKeypath:=Keypath;

  Elded:=Edit;

  If (Edit) then
  Begin
    HideDAdd:=BOn;
    With ExLocal do
    Begin
      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);

      Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked);

    end;


    If (Not Ok) or (Not GlobLocked) then
      AddCh:=#27
    else
      BuildDesign;
  end
  else
  Begin
    HideDAdd:=BOn;
    BuildDesign;
  end;



  If (Addch<>#27) then
  With ExLocal,LStock do
  begin


    If (Not Edit) then
    Begin
      Caption:='Add Stock Record';
      LResetRec(Fnum);


      StockType:=StkStkCode;

      LastStockType:=StkStkCode;

      StockCat:=Level_Code;

      ROCurrency:=1;


      {$IFDEF MC_On}

        PCurrency:=1;


        For n:=1 to MaxStkPBands do
          SaleBands[n].Currency:=1;


      {$ENDIF}


      VATCode:=Syss.VATCode;

      SellUnit:=1;

      BuyUnit:=1;

      SuppSUnit:=1;

      UnitS:='each';
      UnitP:=UnitS;
      UnitK:=UnitS;

      NlineCount:=1;

      BLineCount:=1;

      Supplier:=FullCustCode('');

      StkValType:=CStock^.StkValType;

      If (StkValType=#0) then
        StkValType:=SetStkVal(Syss.AutoStkVal,SerNoWAvg,BOff);

      NomCodeS:=CStock^.NomCodes;

      {$IFDEF WOP}
        MinEccQty:=1.0;
        CalcProdTime:=BOn;
      {$ENDIF}


      {* Set Cover unit , assume monthly periods *}

      CovPr:=Syss.PrInYr;

      If (Syss.PrInYr<25) then
        CovPrUnit:='M'
      else
        CovPrUnit:='W';


      {* Force Calc pack to On! *}

      CalcPack:=BOff;

      CanDelete:=BOn;

      
    end
    else
    Begin
      Add_StkEditNow(LStock.StockFolio);
    end;

    OutStock;


    LastStock:=LStock;

    SetStockStore(BOn,BOff);

    SetFieldFocus;

    BuildDesign;
  end; {If Abort..}

end; {Proc..}


Procedure TStockRec.NoteUpdate;


Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;


Var
  KeyS  :  Str255;


Begin

  GLobLocked:=BOff;

  {$IFDEF NP}

    KeyS:=NotesCtrl.GetFolio;

    With ExLocal do
    Begin
      Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPAth,Fnum,BOn,GlobLocked);

      If (Ok) and (GlobLocked) then
      With LStock do
      With NotesCtrl do
      Begin
        LGetRecAddr(Fnum);

        NLineCount:=GetLineNo;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        Report_Berror(Fnum,Status);

        {* Explicitly remove multi lock *}

        UnLockMLock(Fnum,LastRecAddr[Fnum]);
      end;

    end; {With..}

  {$ENDIF}


end; {Func..}



procedure TStockRec.Get_SNotes;

Var
  WasNew  :  Boolean;

Begin
  {$IFDEF NP}
    WasNew:=Not Assigned(SNoteCtrl);



    With ExLocal,MiscRecs^.SerialRec do
    Begin
      AssignFromGlobal(MiscF);

      If (NoteFolio=0) then {* Assign Note Folio *}
        SNoteUpDate(-1);

      Set_NFormMode(FullNomKey(NoteFolio),NoteRCode,1,NLineCount);

    end;

    If (WasNew) then
    Begin
      SNoteCtrl:=TDiaryList.Create(Self);

    end;


    try
      With SNoteCtrl do
      Begin

        If (WasNew) then
          SetRecAddr(MiscF);

        With Self.ExLocal.LMiscRecs^.SerialRec do
          SetCaption('S/No : '+dbformatName(SerialNo,BatchNo));

        Show;

      end;
    except
      SNoteCtrl.Free;
      SNoteCtrl:=nil;

    end;
  {$ENDIF}
end;

procedure TStockRec.NteCP1BtnClick(Sender: TObject);
begin
  {$IFDEF NP}

    If (Assigned(MULCtrlO2[Current_Page])) then
      If (MULCtrlO2[Current_Page].ValidLine) then
        Get_SNotes;

  {$ENDIF}
end;


{$IFDEF NP}

  Procedure TStockRec.SNoteUpdate(NewLineNo  :  LongInt);


  Const
    Fnum     =  MiscF;
    Keypath  =  MIK;


  Var
    KeyChk,
    KeyS    :  Str255;

    HoldMode:  Byte;

    B_Func  :  Integer;

    LOk,
    SetNFolio,
    Locked,
    TmpBo   :  Boolean;


  Begin

    Locked:=BOff;

    SetNFolio:=(NewLineNo<0);

    If (Assigned(SNoteCtrl)) and (Not SetNFolio) then
    Begin
      SNoteCtrl.GetRecFAddr(Fnum,Keypath);
    end;

    With ExLocal do
    Begin
      LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

      If (LOk) and (Locked) then
      With LMiscRecs^.SerialRec do
      Begin
        LGetRecAddr(Fnum);

        If (SetNFolio) then
          NoteFolio:=GetNextCount(SKF,BOn,BOff,0)
        else
          NLineCount:=NewLineNo;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath);

        Report_BError(Fnum,Status);
        {* Explicitly remove multi lock *}

        AssignToGlobal(Fnum);

        UnLockMLock(Fnum,LastRecAddr[Fnum]);
      end;

    end; {With..}

  end; {Func..}

{$ENDIF}




Function TStockRec.ScanMode  :  Boolean;

Var
  n  :  Byte;

Begin
  If (Assigned(DispTransPtr)) then
  With TFInvDisplay(DispTransPtr) do
  Begin
    For n:=Low(TransActive) to High(TransActive) do
    Begin
      Result:=TransActive[n];

      If (Result) then
        break;
    end;
  end
  else
    Result:=BOff;
end;



Procedure TStockRec.WMCustGetRec(Var Message  :  TMessage);

Var
  ListPoint  :  TPoint;
  LastPage   :  TTabSheet;
  IsAssigned: Boolean;
  OK2Exe : Boolean;

  KeyS : Str255;
  Res  : Integer;

Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      0,1,169
         :
         begin
         //GS 07/10/2011 ABSEXCH-11622:
         //disable the edit button, if selected serial record has already been used
         ToggleSerialTabEditButton;


         If (Current_Page In [SLedgerPNo]) then
            Begin
              If (WParam=169) then
              Begin
                MULCtrlO[Current_Page].GetSelRec(BOff);
                WParam:=0;
              end;

              InHBeen:=((WParam=0) or ((InHBeen) and ScanMode));

              //PR: 15/02/2016 v2016 R1 ABSEXCH-17308 Check list scan security hook
              {$IFDEF CU}
              if (InHBeen) and ScanMode and (CustomHandlers.CheckHandlerStatus (102000, 156) = 1) then
              begin
                 //PR: 19/02/2016 v2016 R1 ABSEXCH-17320 Don't necessarily have invoice at this point, so may need to find it
                 if Inv.FolioNum <> Id.FolioRef then
                 begin
                    KeyS := FullNomKey(Id.FolioRef);
                    Res := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, KeyS);
                 end;
                 Ok2Exe:=ValidSecurityHook(2000,156,ExLocal);
              end
              else
              if (WParam=0) then
              begin
              // Add check for security hook point 150 (Edit) & 155 (View)
              //PR: 19/02/2016 v2016 R1 ABSEXCH-17320 Don't necessarily have invoice at this point, so may need to find it
              if Inv.FolioNum <> Id.FolioRef then
              begin
                KeyS := FullNomKey(Id.FolioRef);
                Res := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, KeyS);
              end;
             {$B-}
               Ok2Exe:=((WParam = 0) and ValidSecurityHook(2000, 150, ExLocal)) or
                       ((Wparam = 1) and ValidSecurityHook(2000, 155, ExLocal));
             {$B+}
              end
              else
          {$ENDIF Customisation}
                OK2Exe := True;

              if Ok2Exe then
                Display_Trans(2+(98*WParam));

            end
            else //PR: 20/04/2009
            If (Current_Page In [SMultiBuyPNo]) then
            begin
            {$IFDEF SOP}
               MULCtrlO[Current_Page].GetSelRec(False);
               mbdFrame.EditDiscount;
            {$ENDIF}
            end
            else
              If (Current_Page=SSerialPNo) and (WParam<>1) and (Not InSerModal) then
              Begin
                GetCursorPos(ListPoint);
                ScreenToClient(ListPoint);

                PopupMenu5.PopUp(ListPoint.X,ListPoint.Y);
              end
              else
                If (Current_Page In [SQtyBPNo,SValuePNo]) and (WParam<>1) then
                  ViewCP1BtnClick(nil)
                 else
                   If (Current_Page=SBinPNo) and (WParam<>1) and (Not InBinModal) then
                   Begin
                     GetCursorPos(ListPoint);
                     ScreenToClient(ListPoint);

                     PopupMenu5.PopUp(ListPoint.X,ListPoint.Y);
                   end

                {$IFDEF NP}
                else

                  If (Current_Page=SSerialPNo) and (WParam=1) then
                  Begin
                    If (Assigned(SNoteCtrl)) then
                    With SNoteCtrl, MiscRecs^.SerialRec do
                    Begin
                      TNKey:=FullNomKey(NoteFolio);
                      SetCaption('S/No : '+dbFormatName(SerialNo,BatchNo));
                      ShowLink(BOff,BOff);
                      SetRecAddr(MiscF);
                    end;
                  end
                {$ENDIF};
         end;
      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      7  :  NoteUpDate; {* Update note line count *}

     17  :  Begin {* Force reset of form *}
              GotCoord:=BOff;
              SetDefault:=BOn;
              Close;
            end;

     25  :  NeedCUpdate:=BOn;

     110 :  Begin
              If (Current_Page<>SMainPNo) then
                ChangePage(SMainPNo);
              Show;
            end;

     116,117
          :  Begin
              {$IFDEF PF_On}
               With BOMRec do
               Begin
                 ExLocal.AssignToGlobal(PWrdF);

                 BStock:=StockR;
                 UpdateFromBOM;
                 OutCost;

                 AddEditLine((LParam=1),(WParam=117));
               end;
              {$ENDIF}
            end;

     {$IFDEF PF_On}

       118 :  With MULCtrlO2[Current_Page] do
              Begin
                Case Current_Page of

                {$IFDEF SOP}


                  SSerialPNo  :  Begin
                                   SerialReq:=SerRec.SerialReq;
                                   DocCostP:=SerRec.DocCostP;
                                   OutSerialReq;
                                 end;
                {$ELSE}

                    1         :    ;
                {$ENDIF}


                 SBinPNo     :  Begin
                                  SerialReq:=BinRec.BinReq;
                                  DocCostP:=BinRec.DocCostP;
                                  OutSerialReq;
                                end;


                end; {Case..}


                AddNewRow(MUListBoxes[0].Row,(LParam=1));

              end;

       119, 182
        :    If (Assigned(MULCtrlO2[Current_Page])) then
             With MULCtrlO2[Current_Page] do
             Begin
               Case Current_Page of

               {$IFDEF SOP}

                 SSerialPNo  :  Begin
                                  If (Assigned(SerRec)) then
                                  Begin
                                    SerialReq:=SerRec.SerialReq;
                                    DocCostP:=SerRec.DocCostP;
                                  end;

                                  OutSerialReq;
                                end;


               {$ELSE}

                 1          :     ;

               {$ENDIF}


                 SBinPNo  :  Begin
                               SerialReq:=BinRec.BinReq;
                               DocCostP:=BinRec.DocCostP;
                               OutSerialReq;
                             end;
                  {SS 30/06/2016 2016-R3:
	                 ABSEXCH-13487 : When using the QTY Break - Block Discount
                   Deletion option, ticking to Delete Expired within Date Range
                   and Delete for All Stock Records, the Stock Quantity Breaks are not removed.
                  - Refresh Qty Break List.}
                  SQtyBPNo:
                  begin
                    If (QtyBreaks.TabVisible) then
                      RefreshValList(BOn,BOff);
                  end;


               end; {case..}

               If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
             end
             else
             if Assigned(MULCtrlO[Current_Page]) then
             begin
               {$IFDEF SOP}
               Case Current_Page of
                 SMultiBuyPNo : MBDFrame.RefreshStockList(Stock.StockCode);
               end; //Case
               {$ENDIF}
             end;


     {$ENDIF}

     {$IFDEF FRM}

        170  :  PrnCp1BtnClick(nil);

     {$ENDIF}

     175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

     177 :  Begin
              LastPage:=PageControl1.ActivePage;

              BuildDesign;

              If (PageControl1.ActivePage<>LastPage) then
                PageControl1.ActivePage:=LastPage;

              PrimeButtons;

              Check_TabAfterPW(PageControl1,Self,WM_CustGetRec);
            end;

     200 :  DispTransPtr:=nil;

     {$IFDEF PF_On}

       202  :  BOMRec:=nil;

     {$ENDIF}

     {$IFDEF SOP}

       203  :  SerRec:=nil;

     {$ENDIF}

     {$IFDEF PF_On}

       204  :  ValRec:=nil;
       205  :  QtyRec:=nil;

     {$ENDIF}

       206  :  BinRec:=Nil;

       210  :  Begin
                 Prices:=nil;
                 ExLocal.LStock.SaleBands:=Stock.SaleBands;

                 OutPrices;
               end;

       212  :  EditSPBtnClick(Nil);

     {$IFDEF NP}
        213  :  SNoteCtrl:=nil;

        250  :  SNoteUpdate(LParam);

      {$ENDIF}


     {$IFDEF Ltr}
       400,
       401  : Begin
                LetterActive:=Boff;
                LetterForm:=nil;
              end;
     {$ENDIF}

      3003
         :  Begin

              If (Not ExLocal.InAddEdit) then
              Begin
                ShowLink;
              end;
            end;



    end; {Case..}

  end;
  Inherited;
end;


Procedure TStockRec.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      41 :  Begin
              HistFormPtr:=nil;

              If (MULCtrlO[SLedgerPNo]<>nil) then
              Begin
                DDCtrl.NHNeedGExt:=BOff;
                RefreshList(BOn,BOff);
              end;
            end;

    {$IFDEF SOP}
      48 :  AltCList:=nil;

    {$ENDIF}

      52,53
         :  Begin
              FromHist:=BOn;

              If (Current_Page<>SLedgerPNo) then
                ChangePage(SLedgerPNo);



              If (MULCtrlO[SLedgerPNo]<>nil) then
              With ExLocal,MULCtrlO[SLedgerPNo],DDCtrl do
              Begin
                ExLocal.AssignFromGlobal(NHistF);


                NHPr:=LNHist.Pr;
                NHYr:=LNHist.Yr;

                NHNeedGExt:=BOn;

                RefreshList(BOn,BOn);


              end;

              FromHist:=BOff;

            end;

      64,65
         :  Begin
              InHBeen:=((WParam=64) or (InHBeen));

              Display_Trans(2);
            end;

     

    end; {Case..}

  end;

  Inherited;
end;

Procedure TStockRec.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin
  With Message.MinMaxInfo^ do
  Begin
    // MH 18/05/2016 2016-R2 ABSEXCH-17470: Prevent user making window smaller than design-time size
    ptMinTrackSize.X:=MinWindowWidth;
    ptMinTrackSize.Y:=MinWindowHeight;
  end;

  Message.Result:=0;

  Inherited;
end;

{ == Procedure to Send Message to Get Record == }

Procedure TStockRec.Send_UpdateList(Edit   :  Boolean;
                                    Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode+100;
    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


Function TStockRec.CheckCompleted(Edit  :  Boolean)  : Boolean;

Const
  NofMsgs      =  15;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ShowMsg  :  Boolean;
  Test     :  Byte;

  n,
  mbRet    :  Word;

  FoundCode:  Str20;

  FoundLong:  LongInt;
  iCode    : integer;
  // MH 31/05/2016 2016-R2 ABSEXCH-17488: Changed to Int64 to avoid overflows with 10 digit TARIC codes > MaxLongInt
  iValue   : Int64;
  // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
  iLen     : Integer;
Begin
  New(PossMsg);
  ShowMsg := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That Stock Code already exists.';
  PossMsg^[2]:='That Stock Code is not valid.';
  PossMsg^[3]:='The Cost Price currency is not valid.';
  PossMsg^[4]:='One of the Sales Price currencies is not valid.';
  PossMsg^[5]:='The Re-Order Price currency is not valid.';
  PossMsg^[6]:='The default '+CCVATName^+' Code is not valid.';
  PossMsg^[7]:='One of the General Ledger Control Codes is not valid.';
  PossMsg^[8]:='The default Cost Centre Code is not valid.';
  PossMsg^[9]:='The default Department Code is not valid.';
  PossMsg^[10]:='The Works Orders work in progress G/L code is not valid.';
  PossMsg^[11]:='An additional check by an external hook';
  PossMsg^[12]:='The Returned Stock G/L code is not valid.';
  PossMsg^[13]:='The Default Supplier code is not valid.';
  PossMsg^[14]:='The Stock Group code is not valid.';
  // PKR. 14/01/2016. ABSEXCH-17099. Intrastat.
  // PKR. 26/01/2016. ABSEXCH-17157 - Remove comma from message.
  // PKR. 26/01/2016. ABSEXCH-17191 - Commodity Code should be numeric.
  PossMsg^[15]:='The Commodity/TARIC Code must be 8 or 10 numeric characters or blank.';

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LStock do
  Begin
    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              If (Not Edit) then
                Result:=Not (CheckExsists(StockCode,StockF,StkCodeK))
              else
                Result:=BOn;
            end;

      2  :  Result:=(Not EmptyKey(StockCode,StkKeyLen));

    {$IFDEF MC_On}

      3  :
               Result:=(PCurrency In [Succ(CurStart)..CurrencyType]);

    {$ENDIF}

    {$IFDEF MC_On}

      4  :   Begin
               Result:=IsProdMode(StockType,StkGrpCode);

               If (Not Result) then
                 For n:=1 to MaxStkPBands do
                 Begin
                   Result:=((SaleBands[n].Currency In [Succ(CurStart)..CurrencyType]));

                   If (Not Result) then
                     Break;
                 end;
             end;
    {$ENDIF}

    {$IFDEF MC_On}

      5  :
               Result:=(ROCurrency In [Succ(CurStart)..CurrencyType]);

    {$ENDIF}


      6  :  Result:=(VATCode In VATSet);

      7  :  Begin
              Result:=IsProdMode(StockType,StkGrpCode);

              If (Not Result) then
              Begin

                {$IFNDEF PF_On}

                   For n:=1 to Pred(NofSNoms) do

                {$ELSE}

                   For n:=1 to NofSNoms do

                {$ENDIF}
                   Begin
                     Result:=GetNom(Self,Form_Int(NomCodes[n],0),FoundLong,-1);

                     If (Not Result) then
                      Break;
                   end;
              end;

            end;

      8,9
         :  Result:=(EmptyKeyS(CCDep[(Test=8)],CCKeyLen,BOff) or (Not Syss.UseCCDep) or GetCCDep(Self,CCDep[(Test=8)],FoundCode,(Test=8),-1));


      10  :  Begin
               Result:=Not WOPOn or (StockType<>StkBillCode) or (Is_StdWOP);

               If (Not Result) then
               Begin

                 Result:=GetNom(Self,Form_Int(WOPWIPGL,0),FoundLong,-1);
               end;

             end;

      11  :  Begin {* Opportunity for hook to validate this line as well *}
                 {$IFDEF CU}

                   Result:=ValidExitHook(3000,40,ExLocal);
                   ShowMsg:=BOff;

                 {$ENDIF}
              end;


      12  :  Begin
               Result:=Not RETMOn or (StockType=StkDescCode) or IsProdMode(StockType,StkGrpCode);

               If (Not Result) then
               Begin

                 Result:=GetNom(Self,Form_Int(ReturnGL,0),FoundLong,-1) and GetNom(Self,Form_Int(PReturnGL,0),FoundLong,-1);


               end;

             end;

      13  :  Result:=((EmptyKey(Supplier,CustKeyLen)) or (CheckExsists(Supplier,CustF,CustCodeK)));

      {13  :  Begin
               Result:=(Not RETMOn) or (ReStockPcnt=0.0);

               If (Not Result) then
               Begin

                 Result:=GetNom(Self,Form_Int(ReStockGL,0),FoundLong,-1);
               end;

             end;}

      14  :  Begin
               {$B-}
                 Result:=(EmptyKey(StockCat,StkKeyLen) or ((StockCode<>StockCat) and (CheckExsists(StockCat,StockF,StkCodeK))));
               {$B+}
             end;

             // PKR. 14/01/2016. ABSEXCH-17099. Intrastat.
      15  :  begin
               // Validation rules for Commodity Code (CCodeF):
               // - If Intrastat is swtched on, then the Commodity Code must be blank or 8 or 10 characters.
               // - If Intrastat is switched off, then no validation.
               // PKR. 05/02/2016. ABSEXCH-17261. Validation of Commodity Code fails when it contains leading/trailing spaces
               Result := true;
               if (Syss.Intrastat) then
               begin
                 // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
                 iLen := Length(Trim(CCodeF.Text));
                 Result := (iLen = 0) or (iLen = 8) or (iLen = 10);

                 // PKR. 26/01/2016. ABSEXCH-17191. Commodity Code should be numeric.
                 // If it is 8 characters long, check it's numeric
                 // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
                 if (iLen = 8) or (iLen = 10) then
                 begin
                   // if iCode > 0 then the integer conversion failed.
                   Val(CCodeF.Text, iValue, iCode);
                   Result := (iCode = 0) and (iValue >= 0); // Check for positive integers only
                 end;
               end;
             end;

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) then
    mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}






{ =========== Procedures to Control Stock Type Changes =========== }





{ =========== Change Actual Code ========= }


Procedure TStockRec.Change_StockType(OldTyp,NewTyp  :  Char;
                                 Var StockR         :  StockRec);



Const
  Fnum    =  NHistF;
  Keypath =  NHk;

  Fnum2   =  PWrdF;
  Keypath2=  PWk;



Var

  CanChange,
  DelBOMComps,
  Abort      :  Boolean;



Begin

  CanChange:=BOff;  DelBOMComps:=BOff;

  Abort:=BOff;


  If (OldTyp<>NewTyp) then
  Begin

    CanChange:=Ok2DelStk(0,StockR);

    Case OldTyp of

      {$IFDEF PF_On}

        StkBillCode  :  Begin
                          If (NewTyp=StkDListCode) then
                          Begin
                            DelBOMComps:=(CustomDlg(Self,'Please Confirm','Remove Components',
                             'Do you wish to remove the list of components associated with this Bill of Material?'+#13+#13+
                             'Once removed the list of components would need to be added back in should you wish '+
                             'to revert this stock item back to being a Bill of Material.',
                             mtConfirmation,
                             [mbYes,mbNo])=mrOk);
                          end
                          else
                            DelBOMComps:=BOn;


                          KeyF:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,
                                             FullNomKey(StockR.StockFolio)));

                          If (DelBOMComps) then
                            DeleteLinks(KeyF,Fnum2,Length(KeyF),Keypath2,BOff);

                          If (CanChange) then
                          Begin
                            StockR.ShowasKit:=BOff;
                            StockR.KitOnPurch:=BOff;
                          end;
                        end;

      {$ENDIF}


        StkGrpCode   :  Begin

                          If (Not CanChange) then
                          Begin

                            StockR.StockType:=OldTyp;

                            Abort:=BOn;

                          end;

                        end;

    end; {Case..}


    If (Not Abort) then
    Begin

      With StockR do
      Case NewTyp of


        {$IFDEF PF_On}

          StkBillCode  :  Begin

                            CostPrice:=0;

                          end;

        {$ENDIF}

          StkDListCode :  Begin

                            Blank(Supplier,Sizeof(Supplier));
                            Blank(SuppTemp,Sizeof(SuppTemp));

                          end;


          StkGrpCode   :  Begin

                            CostPrice:=0;

                            Blank(SaleBands,Sizeof(SaleBands));

                            Blank(NomCodes,Sizeof(NomCodes));

                            Blank(VATCode,Sizeof(VATCode));

                            Blank(CCDep,Sizeof(CCDep));

                            UnitK:='';
                            UnitP:='';
                            UnitS:='';

                            Blank(Supplier,Sizeof(Supplier));
                            Blank(SuppTemp,Sizeof(SuppTemp));


                          end;

        StkDescCode    :  Begin

                            StkValType:=StkLCCode;

                          end;

      end; {Case..}


      With StockR do
        LastStockType:=StockType;


      {* Change Normal History *}

      Change_Hist(OldTyp,NewTyp,StockR.StockFolio);

      {* Change Budget / Posted History *}

      Change_Hist(Calc_AltStkHCode(OldTyp),Calc_AltStkHCode(NewTyp),StockR.StockFolio);


    end; {If Abort..}

  end; {If anything to change..}
end; {Proc..}


Procedure TStockRec.OutSerialReq;

Begin
  If ((SerUseMode) and (Not InSerFind)) or ((BinUseMode) and (Not InBinFind)) then
    I1StatLab.Caption:='Items Required:'+#13+FormatFloat(GenQtyMask,SerialReq);
end;


Procedure TStockRec.SetCaption;

Var
  LocTit  :  Str50;

Begin
  LocTit:='';
  With ExLocal,LStock,DDCtrl do
  Begin
    {$IFDEF SOP}
      If (Not EmptyKey(SRecLocFilt,LocKeyLen)) then
        LocTit:=' - Locn : '+SRecLocFilt+'. ';

    {$ENDIF}


    If (Not InSerFind) and (Not InBinFind) then
      Caption:='Stock Record '+LocTit+dbFormatName(StockCode,Desc[1])+'. '+Show_TreeCur(NHCr,NHTxCr)
    else
      If (InSerFind) then
        Caption:='Serial/Batch Record Search'+LocTit
      else
        If (InBinFind) then
          Caption:='Bin Record Search'+LocTit;


  end;
end;

{ == Dedect and offer to create bin/serial records when valuation type changes == }

{$IFDEF SOP}

  procedure TStockRec.Create_AutoBins;

    Const
      ChangeMsg  :  Array[BOff..Bon] of Str20 = ('Serial','Bin');

    Var
      SVTChange  :  Byte;

    Begin
      SVTChange:=0;

      With ExLocal,LStock do
      Begin
        SVTChange:=(1*Ord((StkValType In ['E','R']) and (Not (LastStock.StkValType In ['E','R'])) and (LastStock.MultiBinMode)))+
                   (2*Ord((Not (StkValType In ['E','R'])) and (LastStock.StkValType In ['E','R']) and (MultiBinMode)));

        If (SVTChange<>0) then
        Begin
          If (CustomDlg(Self,'Please Confirm','Create '+ChangeMsg[SVTChange=2]+' records',
                               'The Stock Valuation type has changed.'+#13+#13+
                               'Do you wish to create the '+ChangeMsg[SVTChange=2]+' records from the existing '+ChangeMsg[SVTChange=1]+' records?',
                               mtConfirmation,
                               [mbYes,mbNo])=mrOk) then
          Begin
            Case SVTChange of
              1  :  AddStkBinFill2Thread(Owner,LastStock,LStock,'',20);

              2  :  BinCreateCtrl(LastStock,LStock,Owner);
            end; {Case..}

          end;

        end;



      end;

  end;

{$ENDIF}


procedure TStockRec.StoreStock(Fnum,
                               KeyPAth    :  Integer;
                               Edit       :  Boolean);

Var
  Renumbed, COk : Boolean;
  TmpStock : StockRec;
  KeyS : Str255;
  MbRet : Word;
  NewSCode : Str20;
begin
  KeyS:='';     NewSCode:='';

  Form2Stock;  Renumbed:=BOff;

  With ExLocal,LStock do
  Begin
    {$IFDEF CU} {* Call any pre store hooks here *}

      GenHooks(3000,2,ExLocal);

    {$ENDIF}


    If (Edit) and (LastStock.StockCode<>StockCode) then
    Begin
      COk:=(Not Check4DupliGen(StockCode,Fnum,StkCodeK,'Stock'));
    end
    else
      COk:=BOn;

    If (COk) then
      COk:=CheckCompleted(Edit);

    If (COk) then
    Begin
      COk:=(Not EmptyKey(StockCode,SRCF.MaxLength));

      If (Not COk) then
        mbRet:=MessageDlg('Stock Code not valid!',mtError,[mbOk],0);
    end;

    If (COk) then
    Begin
      Cursor:=crHourGlass;

      LastUsed:=Today;
      TimeChange:=TimeNowStr;

      MinFlg:=((FreeStock(LStock)<QtyMin)) and (QtyMin<>0);

      SuppTemp:=Supplier;

      TempBLoc:=BinLoc;

      CheckStockNdx(LStock);
      
      If (Edit) then
      Begin
        {$IFDEF PF_On}

            If ((LastStock.PCurrency<>PCurrency) or (LastStock.ROCurrency<>ROCurrency)) and (StockType=StkBillCode) then
              Re_CalcCostPrice(BOff);

            {If (LastStock.StockCode<>StockCode) then  {* Account Renumber discounts
              CD_RenumbStk(LastStock.StockCode,StockCode);}

        {$ENDIF}

        {* Change associated details if stock type changes *}


        Change_StockType(LastStock.StockType,StockType,LStock);

        If (LastStock.StockCode<>StockCode) then
        Begin
          NewSCode:=StockCode;
          StockCode:=LastStock.StockCode;

          {$IFDEF POST}
            Renumbed:=BOn;

            If StockCodeChange(LStock,NewSCode,TForm(Self.Owner)) then
            Begin
              {Trigger hook to notify}

              {$IFDEF CU}
                {TextExitHook(3000,110,NewSCode,ExLocal); {*Call with pre change record, then with changed record*}
                TextExitHook(3000,111,NewSCode,ExLocal);
              {$ENDIF}
            end;


          {$ENDIF}
        end;


        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpStock:=LStock;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LStock:=TmpStock;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        //TW 27/10/2011 Add Edit audit note if update is successful.
        if(status = 0) then
          TAuditNote.WriteAuditNote(anStock, anEdit, ExLocal);

        If ((LastStock.PCurrency<>PCurrency) or (LastStock.CostPrice<>CostPrice)
           or (LastStock.ProdTime<>ProdTime)) then
          Update_UpChange(BOn);

      end
      else
      Begin
        StockFolio:=SetNextSFolio(SKF,BOn,0);

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
        CanDelete:=BOn;

        //PR: 22/11/2011 Add audit note when creating new stock record.
        if status = 0 then
          TAuditNote.WriteAuditNote(anStock, anCreate, ExLocal);

      end;

      SetCaption;

      Report_BError(Fnum,Status);

      LGetRecAddr(Fnum);  {* Refresh record address *}

      If (StatusOk) then
        Send_UpdateList(Edit,0);

      If (Edit) then
      Begin
        Delete_StkEditNow(ExLocal.LStock.StockFolio);

        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      end;

      {$IFDEF SOP}
        If (StatusOk) then
        Begin
          Shadow_StkRec(LStock);

          Create_AutoBins;
        end;
      {$ENDIF}


      SetStockStore(BOff,Edit);

      CStock^:=LStock;

      Cursor:=CrDefault;

      LastValueObj.UpdateAllLastValues(Self);

      If (HideDAdd) then
      Begin
        HideDAdd:=BOff;
        BuildDesign;
      end;


      If (Renumbed) then {Force a close}
        PostMessage(Self.Handle,WM_Close,0,0);

      InAddEdit:=BOff;
      LastEdit:=BOff;

    end
    else
    Begin

      {ChangeNBPage(1);}

      SetFieldFocus;

    end;
 end; {If..}

end;



procedure TStockRec.OkCP1BtnClick(Sender: TObject);

Var
  TmpBo  :  Boolean;
  KeyS   :  Str255;

begin

  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    begin
      // Move focus to OK button to force OnExit validation/formatting to kick in
      If OkCP1Btn.CanFocus Then
        OkCP1Btn.SetFocus;
      // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
      If (ActiveControl = OkCP1Btn) Then
      begin
        StoreStock(StockF,SKeypath,ExLocal.LastEdit);
      end;
    end
    else
      If (ModalResult=mrCancel) then
      Begin
         If (Not ExLocal.LastEdit) then {* Force close..}
         Begin
           Close;
           Exit;
         end;

        If (ConfirmQuit) then
        With ExLocal do
        Begin

          If (InAddEdit) then
            LStock:=LastStock;

          OutStock;
          
          If (HideDAdd) then
          Begin
            HideDAdd:=BOff;
            BuildDesign;
          end;

          ExLocal.InAddEdit:=BOff;
          ExLocal.LastEdit:=BOff;

        end;
      end;
  end; {With..}
end;

procedure TStockRec.EditAccount(Edit  :  Boolean);
begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    If (Not Edit) then
      ChangePage(SMainPNo);

    ProcessStock(StockF,CurrKeyPath^[StockF],LastEdit);
  end;
end;


{SS 22/03/2016 2016-R2
 ABSEXCH-17147: When deleting Trader/Stock Records from Exchequer
                quantity break discounts are not removed from QTYBREAK table.
- Delete the links assosiated with StockFolio num from the QtyBreak table with the.}

Procedure TStockRec.DeleteQtyBreakLinks ( Code  :  AnyStr;
                                          Fnum  :  Integer;
                                          KLen  :  Integer;
                                          KeyPth:  Integer);

  Function CheckQtyBreakKey(KeyRef,Key2Chk  :  AnyStr;
                            KeyLen          :  Integer;
                            AsIs            :  Boolean) :  Boolean;
  const
    cAcCodeLength = 6;
    cStockFolioLength = 4;
  Begin
    Result := False;
    If (Length(Key2Chk)>=KeyLen) then
      Result:=(UpcaseStrList(Copy(Key2Chk,cAcCodeLength,cStockFolioLength),AsIs)=UpcaseStrList(Copy(KeyRef,cAcCodeLength,cStockFolioLength),AsIs));
  end;

const
  cQryBreakTitle ='Quantity Break ';
  cProcessTitle ='Quantity Break Links delete processing.';

Var
  KeyS  :  AnyStr;     
  Locked:  Boolean;
  LAddr :  LongInt;
  lProgressForm : TIndeterminateProgressFrm;
Begin
  lProgressForm := TIndeterminateProgressFrm.Create(Self);
  lProgressForm.Start(cQryBreakTitle,cProcessTitle);

  try
    KeyS:=Code;
    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);

    While (Status=0) do
    Begin
      If CheckQtyBreakKey(Code,KeyS,Length(Code),BOn) then
      Begin
        Status:=Delete_Rec(F[Fnum],Fnum,KeyPth);
      end;
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);
    end;
  finally
    lProgressForm.Stop;    
  end;
end;



procedure TStockRec.DeleteAccount;

Const
  Fnum  =  StockF;


Var
  MbRet  :  Word;
  KeyS   :  Str255;

  Keypath:  Integer;
  lQry: String;

Begin

  MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Stock Record',
                     mtConfirmation,[mbYes,mbNo],0);


  If (MbRet=MrYes) then
  With ExLocal do
  Begin

    Keypath:=CurrKeyPath^[Fnum];

    LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

    Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

    Report_BError(Fnum,Status);

    Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,GlobLocked);

    If (Ok) and (GlobLocked) then
    Begin
      Status:=Delete_Rec(F[Fnum],Fnum,CurrKeyPath^[Fnum]);

      Report_BError(Fnum,Status);

      If (StatusOk) then {* Delete any dependant links etc *}
      Begin
        {* Delete notes & Qty breaks *}

        {$IFDEF NP}
          Delete_Notes(NoteSCode,FullNCode(FullNomKey(LStock.StockFolio))); {* Auto Delete Notes *}
        {$ENDIF}

        {$IFDEF PF_On}

          {* Delete BOM *}

          KeyF:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,
                                     FullNomKey(LStock.StockFolio)));

          DeleteLinks(KeyF,PWrdF,Length(KeyF),PWK,BOff);

          {* Delete BOM where used *}

          // MH 14/10/2015 2016R1 ABSEXCH-16964: Copied ABSEXCH-15654 into 2016 R1 -
          //                                     Corrected to use LStock.StockFolio instead of
          //                                     Stock.StockFolio which was causing the last
          //                                     sub-component from the DeleteLinks call above to
          //                                     be removed from the other BoMs in the system instead
          //                                     of the BoM actually being deleted
          KeyF:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,
                      FullNomKey(LStock.StockFolio)));

          DeleteLinks(KeyF,PWrdF,Length(KeyF),HelpNDXK,BOff);


          {* Delete Qty Discounts *}
          KeyF:=FullQDKey(QBDiscCode,QBDiscSub,FullNomKey(LStock.StockFolio));
          DeleteLinks(KeyF,MiscF,Length(KeyF),MIK,BOff);


         {SS 25/03/2016 2016-R2
          ABSEXCH-17147: When deleting Trader/Stock Records from Exchequer
                           quantity break discounts are not removed from QTYBREAK table.
          - Clear deleted stock specific data from the QTYBREAK table.}
          if SQLUtils.UsingSQL then
          begin
            lQry := 'Delete FROM [COMPANY].[QTYBREAK] where qbStockFolio = '+ InttoStr(ExLocal.LStock.StockFolio);
            ExecSQLEx(lQry,SetDrive);
          end else
          begin
            KeyF := FullCustCode('')+ FullNomKey(LStock.StockFolio);
            DeleteQtyBreakLinks(KeyF,QtyBreakF, Length(KeyF), qbAcCodeIdx);
          end;

          {* Delete Multi Bin *}

            KeyF:=FullQDKey(brRecCode,MSernSub,FullNomKey(LStock.StockFolio));
            DeleteLinks(KeyF,MLocF,Length(KeyF),MLSecK,BOff);

          {$IFDEF SOP}
            DeletesdbLinks(FullNomKey(LStock.StockFolio),MLocF,MLSecK);
            
            {* Delete equivalent records *}
            DeletesdbLinks(LStock.StockCode,MLocF,MLK);
          {$ENDIF}

        {$ENDIF}

        {$IFDEF Ltr}
          { Delete any letters/Links }
          DeleteLetters (LetterStkCode, FullNomKey(LStock.StockFolio));
        {$ENDIF}

        Send_UpdateList(Boff,200);

        Close;
      end;
    end;

  end;
end; {PRoc..}




procedure TStockRec.EditCP1BtnClick(Sender: TObject);

Var
  EditMode  :  Boolean;

begin
  EditMode:=(Sender=EditCP1Btn) or (Sender=Edit1);

  Case Current_Page of
    SNotesPNo  :  AddCP3BtnClick(Sender);
    SLedgerPNo :  ViewCP1BtnClick(Sender);

    {$IFDEF PF_On}
      SQtyBPNo,SValuePNo,SSerialPNo,SBinPNo
         :  With MULCtrlO2[Current_Page] do
            If (ValidLine) or (Sender=AddCP1Btn) or (Sender=Add1) then
            Begin
              If (ValidLine) then
                GetSelRec(BOff);

              Case Current_Page of
                SQtyBPNo  :  Display_QtyRec(1+Ord((Sender=EditCP1Btn) or (Sender=Edit1)));
                SValuePNo  :  Display_ValRec(1+Ord((Sender=EditCP1Btn) or (Sender=Edit1)));

                {$IFDEF SOP}

                  SSerialPNo
                    :  If (Not MiscRecs^.SerialRec.BatchChild) or (Not EditMode) then
                          Display_SerRec(1+Ord(EditMode))
                        else
                          ShowMessage('It is not possible to edit a batch usage line.');

                {$ENDIF}

                SBinPNo
                  :  If (Not MLocCtrl^.brBinRec.brBatchChild) or (Not EditMode) then
                        Display_BinRec(1+Ord(EditMode))
                      else
                        ShowMessage('It is not possible to edit a bin usage line.');
              end; {Case..}
            end;
      {$IFDEF SOP}
      SMultiBuyPNo
         : if (Sender = EditCP1Btn) then
           begin  //PR: 18/06/2009 Wasn't checking ValidLine (FR v6.01.073)
             if MULCtrlO[Current_Page].ValidLine then
             begin
               MULCtrlO[Current_Page].GetSelRec(False);
               mbdFrame.EditDiscount;
             end;
           end
           else
             mbdFrame.AddDiscount;
      {$ENDIF}
    {$ENDIF}


    else  EditAccount((Sender=EditCP1Btn));
  end; {Case..}

end;



procedure TStockRec.ShowLink;
Var
  StartPage  :  Integer;
{$IFDEF Ltr}
  OldCust, TmpPtr : CustRecPtr;
{$ENDIF}
begin
  StartPage:=Current_Page;

  ExLocal.AssignFromGlobal(StockF);
  ExLocal.LGetRecAddr(StockF);

  SetCaption;

  OutStock;

  DDCtrl:=DDFormMode;

  CanDelete:=Ok2DelStk(0,ExLocal.LStock) and (ICEDFM=0);

  DelCP1Btn.Enabled:=SetDelBtn;


  BuildDesign;

  If ((Not ValPage.TabVisible) and (Current_Page=SValuePNo))
   or ((Not BOMPage.TabVisible) and (Current_Page=SBuildPNo))
   or ((Not SerPage.TabVisible) and (Current_Page=SSerialPNo))
     or ((Not BinPage.TabVisible) and (Current_Page=SBinPNo))
   or ((Not PageControl1.Pages[StartPage].TabVisible)) then
     ChangePage(SMainPNo);

  Case Current_Page of

    SNotesPNo
       :  {$IFDEF NP}
            If (NotesCtrl<>nil) then {* Assume record has changed *}
            With ExLocal do
            Begin
              NotesCtrl.RefreshList(FullNomKey(LStock.StockFolio),NotesCtrl.GetNType);
              NotesCtrl.GetLineNo:=LStock.NLineCount;
            end;

          {$ELSE}

            ;
          {$ENDIF}

    SLedgerPNo
         :  RefreshList(BOn,BOff);

    {$IFDEF PF_On}
      SQtyBPNo
         :  If (QtyBreaks.TabVisible) then
              RefreshValList(BOn,BOff);


      SValuePNo
         :  If (ValPage.TabVisible) then
              RefreshValList(BOn,BOff);

      SBuildPNo
         :  If (BOMPage.TabVisible) then
              BOMBuildPAge;


    {$ENDIF}



    {$IFDEF SOP}
       SSerialPNo
          :  If (SerPage.TabVisible) then
               RefreshValList(BOn,BOff);

       SMultiBuyPNo
          :  If (tabMultiBuy.TabVisible) then
               mbdFrame.RefreshStockList(Stock.StockCode);
    {$ENDIF}

       SBinPNo
          :  If (BinPage.TabVisible) then
               RefreshValList(BOn,BOff);

  end; {Case..}


  If (HistFormPtr<>nil) then
    Display_History(LastHMode,BOff);

  {$IFDEF Ltr}
  If Assigned(LetterForm) And LetterActive Then
    If (LetterForm.WindowState <> wsMinimized) Then
      With ExLocal Do Begin
        New (OldCust);
        OldCust^ := Cust;
        If CheckRecExsists(FullCustCode(ExLocal.LStock.Supplier), CustF, CustCodeK) Then
          TmpPtr := @Cust
        Else
          TmpPtr := Nil;
        LetterForm.LoadLettersFor (FullNomKey(LStock.StockFolio),   { Index Key }
                                   LStock.StockCode,               { Caption }
                                   CodeToFName (LStock.StockCode), { FName }
                                   LetterStkCode,
                                   TmpPtr, @LStock, Nil, Nil, Nil);
        Cust := OldCust^;
        Dispose(OldCust);
      End; { With }
  {$ENDIF}
end;


procedure TStockRec.SetFieldProperties;
Var
  n  : Integer;
Begin
  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) and (Components[n]<>SRCF) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(SRCF.Font);
        Color:=SRCF.Color;
      end;
  end; {Loop..}
end;



procedure TStockRec.SetFormProperties;
var
  i: Integer;
begin
  // CJS: 14/12/2010 - Amendments for new Window Settings system
  case Current_Page of
    SMainPNo..SRetPNo: if (FSettings.Edit(self, SRCF) = mrOK) then NeedCUpdate := True;
    SQtyBPNo: EditSerialWindowSettings(SQtyBPNo);
    SMultiBuyPNo: EditLedgerWindowSettings(SMultiBuyPNo);
    SLedgerPNo: EditLedgerWindowSettings(SLedgerPNo);
    SValuePNo: EditSerialWindowSettings(SValuePNo);
    SBuildPNo: if (FSettings.Edit(BOMPage, NLOLine) = mrOK) then NeedCUpdate := True;
    SSerialPNo: EditSerialWindowSettings(SSerialPNo);
    SBinPNo: EditLedgerWindowSettings(SBinPNo);
  end;
  
end;



procedure TStockRec.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  Custom1.Caption:=StkCuBtn1.Caption;
  Custom2.Caption:=StkCuBtn2.Caption;
  // 17/01/2013 PKR ABSEXCH-13449
  // Custom buttons 3..6 now available
  // NOTE: On this form, Custom3 and Custom4 are on a different menu, so this
  //       menu uses 5,6,7,8
  Custom5.Caption:=StkCuBtn3.Caption;
  Custom6.Caption:=StkCuBtn4.Caption;
  Custom7.Caption:=StkCuBtn5.Caption;
  Custom8.Caption:=StkCuBtn6.Caption;

  If (Current_Page=SQtyBPNo) then
  Begin
    DeleteSubMenu(Copy1);

    If (ExLocal.LStock.StockType=StkGrpCode) then
      BuildMenus;
  end;

  With InvBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

    {* Set all equivalent enables *}

    Delete1.Enabled:=DelCP1Btn.Enabled;
  end; {With..}

  if (Current_Page in [Low(MulCtrlO)..High(MulCtrlO)]) then
  begin
    RefreshView2.Visible := False;
    CloseView2.Visible := False;
    N6.Visible := False;
    if Assigned(MulCtrlO[Current_Page]) then
      if MulCtrlO[Current_Page].SortViewEnabled then
      begin
        RefreshView2.Visible := True;
        CloseView2.Visible := True;
        N6.Visible := True;
      end;
  end;

end;


procedure TStockRec.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;

procedure TStockRec.PropFlgClick(Sender: TObject);
begin
  {$IFDEF NP}
    If (Current_Page=SNotesPNo) then
      NotesCtrl.SetFormProperties
    else
  {$ENDIF}
      SetFormProperties;
end;

procedure TStockRec.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;

procedure TStockRec.DelCP1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  Case Current_Page of
    SNotesPNo
           :  DelCp3BtnClick(Sender);

    {$IFDEF PF_On}

       SQtyBPNo
          :  {$IFDEF LTE}
               DelDisc1Click(DelDisc1);
             {$ELSE}
               If (Not (Sender is TMenuItem)) and (Assigned(MulCtrlO2[Current_Page])) then
               With MULCtrlO2[Current_Page] do
               Begin
                 If (Not InListFind) then
                 Begin
                   With TWinControl(Sender) do
                   Begin
                     ListPoint.X:=1;
                     ListPoint.Y:=1;

                     ListPoint:=ClientToScreen(ListPoint);

                   end;

                   PopUpMenu10.PopUp(ListPoint.X,ListPoint.Y);
                 end;
               end;{with..}
             {$ENDIF}

        SValuePNo,SSerialPNo,SBinPNo
           :  With MULCtrlO2[Current_Page] do
              If (ValidLine) then
              Begin
                GetSelRec(BOff);

                If (Current_Page=SQtyBPNo) then
                  Display_QtyRec(3)
                else
                  If (Current_Page=SValuePNo) then
                    Display_ValRec(3)
                  {$IFDEF SOP}
                    else
                      If (Current_Page=SSerialPNo) then
                        Display_SerRec(3)
                  {$ENDIF}
                    else
                      If (Current_Page=SBinPNo) then
                        Display_BinRec(3);
              end;
    {$ENDIF}
    {$IFDEF SOP}
     SMultiBuyPNo
             :  If (Not (Sender is TMenuItem)) and (Assigned(MulCtrlO[Current_Page])) then
                With MULCtrlO[Current_Page] do
                Begin
                  If (Not InListFind) then
                  Begin
                    With TWinControl(Sender) do
                    Begin
                      ListPoint.X:=1;
                      ListPoint.Y:=1;

                      ListPoint:=ClientToScreen(ListPoint);

                    end;

                    PopUpMenu10.PopUp(ListPoint.X,ListPoint.Y);
                  end;
                end;{with..}
    {$ENDIF}


    else  DeleteAccount;
  end; {case..}

end;

procedure TStockRec.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    InPageChanging:=BOn;
    { CJS 07/06/2011 - ABSEXCH-11468}
//    Release_PageHandle(Sender);
    LockWindowUpDate(Handle);

    
  end;
end;





procedure TStockRec.PageControl1Change(Sender: TObject);

Const
  MISubAry  :  Array[SQtyBPNo..SBinPNo] of Char = (QBDiscSub,#0,#0,MFIFOSub,#0,MSERNSub,MSERNSub);
  MITypAry  :  Array[SQtyBPNo..SBinPNo] of Char = (QBDiscCode,#0,#0,MFIFOCode,#0,MFIFOCode,BRRecCode);

Var
  NewIndex  :  Integer;

  {$IFDEF NP}
    NoteSetUp :  TNotePadSetUp;
  {$ENDIF}

  ChkStr    :  Str255;

begin

  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);
      {$B-}

      If (Not (NewIndex In [SQtyBPNo..SValuePNo])) or (MULCtrlO[NewIndex]<>nil) or (MULCtrlO2[NewIndex]<>nil) then
        LockWindowUpDate(0);

      {$B+}

      If (NewIndex In [SLedgerPNo]) then
        BuildMenus
      else
        DeleteSubMenu(Copy1);

      DeleteSubMenu(Find1);

      DeleteSubMenu(Delete1);

      TCMPanel.Visible:=(NewIndex<>SBuildPNo);

      PrimeButtons;

      If (NewIndex In [SQtyBPNo, SLedgerPNo, SValuePNo,SSerialPNo,SBinPNo]) then
        CListBtnPanel.Parent:=ActivePage;

      //GS 07/10/2011 ABSEXCH-11622:
      //enabling the edit button when the user changes tab, incase we have disabled it on the serial tab
      //PR: 28/08/2012 ABSEXCH-12869. Removed code to always enable Edit button - not needed and it causes
      //problems when in Add or Edit mode as button gets reenabled every time user changes tab.
//      EditCP1Btn.Enabled := True;

      Case NewIndex of

      {$IFDEF NP}

        SNotesPNo
           :  If (NotesCtrl=nil) then
              With ExLocal do
              Begin
                NotesCtrl:=TNoteCtrl.Create(Self);

                NotesCtrl.Caption:='Stock Record '+Caption;
                NotesCtrl.OnSwitch := SwitchNoteButtons;

                FillChar(NoteSetup,Sizeof(NoteSetUp),0);

                With NoteSetUp do
                Begin
                  ColPanels[0]:=NDatePanel; ColPanels[1]:=NDateLab;
                  ColPanels[2]:=NDescPanel; ColPanels[3]:=NDescLab;
                  ColPanels[4]:=NUserPanel; ColPanels[5]:=NUserLab;

                  ColPanels[6]:=TNHedPanel;
                  ColPanels[7]:=TCNListBtnPanel;

                  ScrollBox:=TCNScrollBox;
                  PropPopUp:=StoreCoordFlg;

                  CoorPrime:='K';
                  CoorHasCoor:=LastCoord;

                end;

                try
                  {
                    CJS 28/03/2011 - ABSEXCH-10683
                    NotesCtrl handles Window Settings itself, but needs a
                    reference to the correct Settings object and the Property
                    menu-click event-handler.
                  }
                  NotesCtrl.WindowSettings := FSettings;
                  NotesCtrl.PropFlg.OnClick := PropFlgClick;
                  NotesCtrl.CreateList(Self,NoteSetUp,NoteSCode,NoteCDCode,FullNCode(FullNomKey(LStock.StockFolio)));
                  NotesCtrl.GetLineNo:=LStock.NLineCount;


                except
                  NotesCtrl.Free;
                  NotesCtrl:=Nil
                end;

                MDI_UpdateParentStat;

              end
              else
              begin
                With ExLocal do
                  If (FullNomKey(LStock.StockFolio)<>NotesCtrl.GetFolio) then {* Refresh notes *}
                  with NotesCtrl do
                  Begin
                    RefreshList(FullNCode(FullNomKey(LStock.StockFolio)),GetNType);
                    GetLineNo:=LStock.NLineCount;
                end;
                SwitchNoteButtons(Self, NotesCtrl.NoteMode);
              end;

      {$ELSE}

         SNotesPNo  :  ;

      {$ENDIF}

        SLedgerPNo
           : Begin
               If (MULCtrlO[NewIndex]=nil) then
                Begin
                  Case NewIndex of
                    SLedgerPNo  :  LedgerBuildList(NewIndex,BOn);

                  end; {Case..}

                end
                else
                  With EXLocal do
                  Begin
                    If (Not CheckKey(LStock.StockCode,MULCtrlO[NewIndex].KeyRef,StkKeyLen,BOn)) then
                      RefreshList(BOn,BOff);

                    MULCtrlO[NewIndex].ReFresh_Buttons;
                  end;


             MULCtrlO[NewIndex].SetListFocus;

             DeleteSubMenu(Find1);
             CreateSubMenu(PopUpMenu7,Find1);

             SetCheckedMenuItems(Find1,-1,LastBTag);

           end;

        {$IFDEF PF_On}

          SBuildPNo  :
                Begin
                  If (Not InBOM) or (ExLocal.LStock.StockFolio<>BOMFolio) then
                  With NLOLine do
                  Begin
                    BOMBuildPage;

                    If (CanFocus) then
                      SetFocus;
                  end {With..}
                  else
                    If (InBOM) then
                      OutCost;
                end;

        {$ENDIF}
      //PR: 30/03/2009 Added handling for MultiBuy Discounts page
      {$IFDEF SOP}
          SMultiBuyPNo
           : Begin
               If (MULCtrlO[NewIndex]=nil) then
                Begin
                  MultiBuyBuildList(NewIndex, True);
                end
                else
                  With EXLocal,LStock do
                  Begin
                    ChkStr:=Strip('R',[#0],FullQDKey(CDDiscCode,'T',FullStockCode(StockCode)));

                    If (Not CheckKey(ChkStr,MULCtrlO[NewIndex].KeyRef,Length(ChkStr),BOn)) then
                      mbdFrame.RefreshStockList(FullStockCode(StockCode));

//                    MULCtrlO[NewIndex].ReFresh_Buttons;
                  end;

             If (Self.Visible) then
               MULCtrlO[NewIndex].SetListFocus;

             mbdFrame.AllowEdit := EditCP1Btn.Enabled;

           end;
       {$ENDIF}

        {$IFDEF PF_On}

          SQtyBPNo,SValuePNo,SSerialPNo,SBinPNo
           : Begin

               If (MULCtrlO2[NewIndex]=nil) then
                Begin



                  Case NewIndex of
                    SQtyBPNo   :     QBBuildList(NewIndex,BOn);

                    SValuePNo  :     ValBuildList(NewIndex,BOn);

                   {$IFDEF SOP}
                     SSerialPNo
                        :  Begin
                             SNOBuildList(NewIndex,BOn);
                           end;
                   {$ENDIF}

                     SBinPNo
                        :  Begin
                             BINBuildList(NewIndex,BOn);
                           end;

                  end; {Case..}

                end
                else
                  With EXLocal,LCust,LStock do
                  Begin
                    If (CQtyBMode) then
                      ChkStr:=Strip('R',[#0],FullQDKey(QBDiscCode,CustSupp,FullCDKey(CustCode,StockFolio)))
                    else
                      ChkStr:=Strip('R',[#0],FullQDKey(MITypAry[NewIndex],MISubAry[NewIndex],FullNomKey(StockFolio)));

                    If (Not CheckKey(ChkStr,MULCtrlO2[NewIndex].KeyRef,Length(ChkStr),BOn)) then
                      RefreshValList(BOn,BOff);

                    MULCtrlO2[NewIndex].ReFresh_Buttons;
                  end;

               If (NewIndex=SSerialPNo) then
               Begin
                 DeleteSubMenu(Find1);
                 CreateSubMenu(PopUpMenu4,Find1);
                 Altdb1Btn.Caption:='Add &Range';
                 AltCodes1.Caption:='Add &Range';
                 AltCodes1.HelpContext:=1049;
                 Altdb1Btn.HelpContext:=1049;
               end
               else
                 If (NewIndex=SBinPNo)  then
                 Begin
                   If (Syss.UseMLoc) then
                   Begin
                     Altdb1Btn.Caption:='&Location';
                     AltCodes1.Caption:='&Location';
                     AltCodes1.HelpContext:=1465;
                     Altdb1Btn.HelpContext:=1465;
                   end;

                   ChkCP1Btn.Caption:='&Sort';
                   Check1.Caption:='&Sort';
                   Check1.HelpContext:=1464;
                   ChkCP1Btn.HelpContext:=1464;

                   LnkCP1Btn.Visible:=BOff;
                   Links1.Visible:=BOff;

                   {LnkCP1Btn.Caption:='&Move';
                   Links1.Caption:='&Move';
                   Links1.HelpContext:=1492;
                   LnkCP1Btn.HelpContext:=1492;}
                 end
                 else
                 Begin
                   {$IFNDEF LTE}
                     If (NewIndex=SQtyBPNo) then
                       CreateSubMenu(PopUpMenu10,Delete1);
                   {$ENDIF}
                 end;

             If (Self.Visible) then
               MULCtrlO2[NewIndex].SetListFocus;
           end;
        {$ENDIF}
      end; {Case..}

       //adjust the availability of the edit button:
       if NewIndex = SSerialPNo then
       begin
         //GS 07/10/2011 ABSEXCH-11622:
         //we are switching to the serial / bin tab, toggle the edit button accordingly
         //RefreshValList(True, False);
         if Assigned(MulCtrlO2[SSerialPNo]) then
         begin
           //get the currently selected record (as it may not be
           //the current record loaded into the MiscRecs structure)
           MulCtrlO2[SSerialPNo].GetSelRec(False);
           //with the record data loaded, determine if the edit button should be disabled
           ToggleSerialTabEditButton;
         end;
       end;

      If (NewIndex<>SSerialPNo) and (NewIndex<>SBinPNo) then
      Begin
        Altdb1Btn.Caption:='Al&t Codes';
        AltCodes1.Caption:='Al&t Codes';
        AltCodes1.HelpContext:=596;
        Altdb1Btn.HelpContext:=596;

// MH 08/07/08: Modified as the links button was incorrectly showing up as disabled on several tabs
//        LnkCP1Btn.Visible:=BOn;
//        Links1.Visible:=BOn;
        LnkCP1Btn.Visible := (NewIndex In [SMainPNo, SDefaultPNo, SDef2PNo, SWOPPNo, SRETPNo]);
        Links1.Visible := Links1.Visible;

        LnkCP1Btn.Caption:='&Links';
        Links1.Caption:='&Links';
        Links1.HelpContext:=0;
        LnkCP1Btn.HelpContext:=0;
      end;

      If (NewIndex<>SBinPNo) then
      Begin
        ChkCP1Btn.Caption:='&Check';
        Check1.Caption:='&Check';
//        Check1.HelpContext:=187;  // NF: 22/06/06 I am setting this elsewhere now
//        ChkCP1Btn.HelpContext:=187; // NF: 22/06/06 I am setting this elsewhere now
      end;

      // MH 26/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
      WindowExport.ReevaluateExportStatus;

      LockWindowUpDate(0);

      InPageChanging:=BOff;
    end;
end;


procedure TStockRec.AddCP3BtnClick(Sender: TObject);
begin
  {$IFDEF NP}
    If (NotesCtrl<>nil) then
      NotesCtrl.AddEditNote((Sender=EditCP1Btn),(Sender=InsCP1Btn));
  {$ENDIF}
end;


procedure TStockRec.DelCP3BtnClick(Sender: TObject);
begin
  {$IFDEF NP}
    If (NotesCtrl<>nil) then
      NotesCtrl.Delete1Click(Sender);
  {$ENDIF}
end;

procedure TStockRec.GenCP3BtnClick(Sender: TObject);
var
  ListPoint : TPoint;
begin
  Case Current_Page of
      SNotesPNo:
        {$IFDEF NP}
          If (NotesCtrl<>nil) then
            With NotesCtrl do
            Begin
              If (Not MULCtrlO.InListFind) then
              begin

                //TW: 26/10/2011 v6.9 Added submenu to handle Audit History Notes
                ListPoint.X:=1;
                ListPoint.Y:=1;

                ListPoint := GenCP3Btn.ClientToScreen(ListPoint);

                PMenu_Notes.Popup(ListPoint.X, ListPoint.Y);
              end;
          end;
        {$ELSE}
          ;
        {$ENDIF}
  end;
end;


procedure TStockRec.LedgerBuildList(PageNo     :  Byte;
                                    ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  StartPanel := nil;
  MULCtrlO[PageNo]:=TSLMList.Create(Self);


  Try

    With MULCtrlO[PageNo] do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(CLORefPanel,CLORefLab);
          AddVisiRec(CLDatePanel,CLDateLab);
          AddVisiRec(CLACPanel,CLACLab);
          AddVisiRec(CLQIPanel,CLQILab);
          AddVisiRec(CLQOPanel,CLQOLab);
          AddVisiRec(CLALPanel,CLALLab);
          AddVisiRec(CLOOPanel,CLOOLab);
          AddVisiRec(CLAWPanel,CLAWLab);
          AddVisiRec(CLIWPanel,CLIWLab);
          AddVisiRec(CLSRPanel,CLSRLab);
          AddVisiRec(CLPRPanel,CLPRLab);
          AddVisiRec(CLUPPanel,CLUPLab);

          // MH 06/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
          ColAppear^[1].ExportMetadata := emtDate;
          ColAppear^[11].ExportMetadata := emtCurrencyAmount;

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {*Hide WOP Panels if not enabled*}
          SetHidePanel(FindxColOrder(7),Not WOPOn,BOff);
          SetHidePanel(FindxColOrder(8),Not WOPOn,BOff);

          {*Hide Ret Panels if not enabled*}
          SetHidePanel(FindxColOrder(9),Not RetMOn,BOff);
          SetHidePanel(FindxColOrder(10),Not RetMOn,BOn);
          
                                
          LabHedPanel:=CLHedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;



      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=11;
      Font:=StartPanel.Font;

      Find_LedgCoord(PageNo);

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [3..11]) then
        Begin
          DispFormat:=SGFloat;

          If (n=11) then
          Begin
            If (Syss.NoNetDec>Syss.NoCosDec) then
            Begin
              NoDecPlaces:=Syss.NoNetDec;
              // MH 13/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
              ColAppear^[n].ExportMetadata := ColAppear^[n].ExportMetadata + emtSalesPrice;
            End // If (Syss.NoNetDec>Syss.NoCosDec)
            else
            Begin
              NoDecPlaces:=Syss.NoCosDec;
              // MH 13/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
              ColAppear^[n].ExportMetadata := ColAppear^[n].ExportMetadata + emtCostPrice;
            End; // Else
          end
          else
          Begin
            NoDecPlaces:=Syss.NoQtyDec;
            // MH 13/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
            ColAppear^[n].ExportMetadata := emtQuantity;
          End; // Else
        end;
      end;


      ListLocal:=@ExLocal;
      SortView.ExLocal := ListLocal;

      ListCreate;

      MStkLocFilt:=@SRecLocFilt;

      {UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;}

      Set_Buttons(CListBtnPanel);

      ReFreshList(Not FromHist,BOff);

    end; {With}

    DefaultPageReSize;

  Except

    MULCtrlO[PageNo].Free;
    MULCtrlO[PageNo]:=Nil;
  end;


end;


Function TStockRec.CheckLedgerFiltStatus  :  Boolean;

Begin
  If (Assigned(MULCtrlO[SLedgerPNo])) then
    Result:=MULCtrlO[SLedgerPNo].FiltSet
  else
    Result:=BOff;
end;

procedure TStockRec.RefreshList(ShowLines,
                                IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  ESKey,
  LKeyLen     :  Integer;

Begin
  ESKey:=IdStkK;

  {$B-}
  If (Current_Page In [SQtyBPNo..SBinPNo]) and (Assigned(MULCtrlO[Current_Page])) then
  With MULCtrlO[Current_Page],ExLocal,LStock do
  {$B+}
  Begin
    LNHCtrl:=DDCtrl;

    With ExLocal,LStock,LNHCtrl do
    Begin
      KeyStart:=FullStockCode(StockCode);

      OrigKey:=KeyStart;

      If (NHFilterMode<>FilterMode) then
      Begin
        FilterMode:=NHFilterMode;
        CListFilt:=NHCuCode;
        StkLIsaC:=NHCuIsaC;
        FiltSet:=BOn;
        Filter[1,1]:=NdxWeight;
        CCNomMode:=NHCCMode;
        CCNomFilt:=NHCDCode;
        SRecLocFilt:=NHLocCode;

      end;

      Case Current_Page of

        SLedgerPNo
           :  If (NHNeedGExt) then
              Begin
                If (StkExtObjPtr=nil) then
                Begin
                  ExtObjCreate;
                  MStkLocFilt:=@SRecLocFilt;
                end;

                With StkExtRecPtr^ do
                Begin
                  FCr:=NHCr;

                  FStkCode:=StockCode;

                  If (FCr<>0) then
                    FMode:=2
                  else
                   FMode:=1;

                  FPr:=NHPr;
                  FYr:=NHYr;

                  If (FilterMode=11) then
                  Begin
                    FMode:=FMode+2;

                    FCustCode:=CListFilt;
                    FIsaC:=StkLIsaC;
                  end;
                end;
              end
              else
                If (StkExtObjPtr<>nil) then
                  ExtObjDestroy; {* Remove previous link *}

      end; {Case..}
    end;

    Set_CurrencyFilt;

    LKeyLen:=Length(KeyStart);

    IgnoreMsg:=IgMsg;

    If (Debug) then
      ESKey:=IdStkK
    else
      ESKey:=IdStkLedgK;


    { CJS 2012-12-05 - ABSEXCH-13842 - default Sort View }
    if MulCtrlO[Current_Page].SortView.LoadDefaultSortView and (Current_Page = SLedgerPNo) then
    begin
      Application.ProcessMessages;
      SetNewLIndex;
      if MulCtrlO[Current_Page].SortView.Sorts[1].svsAscending then
        PageControl1.Pages[Current_Page].ImageIndex := 1
      else
        PageControl1.Pages[Current_Page].ImageIndex := 2;
    end
    else if SortViewEnabled and (Current_Page = SLedgerPNo) then
    begin
      SetNewLIndex;
    end
    else if (ShowLines) then
    begin
      StartList(IdetailF,{$IFDEF DBD} IdStkK {$ELSE} ESKey  {$ENDIF} ,KeyStart,'','',LKeyLen,BOn);
      SetNewLIndex;
    end
    else
      StartList(IdetailF,{$IFDEF DBD} IdStkK {$ELSE} ESKey  {$ENDIF},KeyStart,'','',LKeyLen,(Not ShowLines));


    IgnoreMsg:=BOff;
  end;

end;


{$IFDEF SOP}

  procedure TStockRec.SNoBuildList(PageNo     :  Byte;
                                   ShowLines  :  Boolean);

  Var
    StartPanel  :  TSBSPanel;
    n           :  Byte;



  Begin
    StartPanel := nil;
    MULCtrlO2[PageNo]:=TSNoList.Create(Self);
    MULCtrlO2[PageNo].Name := 'SerialNoList';

    // CJS 2016-01-27 - ABSEXCH-16900 - Cannot jump to end of discount list on Traders
    MULCtrlO2[PageNo].UseAlternativeEndKey := True;

    Try

      With MULCtrlO2[PageNo] do
      Begin


        Try

          With VisiList do
          Begin
            AddVisiRec(SNoPanel,SNoLab);
            AddVisiRec(BNoPanel,BNoLab);
            AddVisiRec(InPanel,InLab);
            AddVisiRec(OutPanel,OutLab);
            AddVisiRec(ODPanel,ODLab);
            AddVisiRec(InLocPanel,InLocLab);
            AddVisiRec(OutLocPanel,OutLocLab);
            AddVisiRec(StkCodePanel,StkCodeLab);

            VisiRec:=List[0];

            SetHidePanel(7,Not InSerFind,BOn);


            StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

            LabHedPanel:=SNHedPanel;

            SetHedPanel(ListOfSet);

          end;
        except
          VisiList.Free;

        end;



        TabOrder := -1;
        TabStop:=BOff;
        Visible:=BOff;
        BevelOuter := bvNone;
        ParentColor := False;
        Color:=StartPanel.Color;
        MUTotCols:=7;
        Font:=StartPanel.Font;

        Find_ValCoord(PageNo);

        WM_ListGetRec:=WM_CustGetRec;


        Parent:=StartPanel.Parent;

        If (InSerModal) or (SerUseMode) or (BinUseMode) then
          StkCallBack:=Self
        else
          MessHandle:=Self.Handle;

        For n:=0 to MUTotCols do
        With ColAppear^[n] do
        Begin
          AltDefault:=BOn;
        end;

        LinkOtherDisp:=BOn;
        ListLocal:=@ExLocal;

        DispDocPtr:=nil;

        DisplayMode:=4;

        ListCreate;

        MStkLocFilt:=@SRecLocFilt;


        {UseSet4End:=BOn;

        NoUpCaseCheck:=BOn;}

        HighLiteStyle[1]:=[fsBold];

        Set_Buttons(CListBtnPanel);

        ReFreshValList(BOn,BOff);

      end; {With}

      SNoPageReSize;

    Except

      MULCtrlO2[PageNo].Free;
      MULCtrlO2[PageNo]:=Nil;
    end;


  end;


{$ENDIF}



procedure TStockRec.BINBuildList(PageNo     :  Byte;
                                 ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  StartPanel := nil;
  MULCtrlO2[PageNo]:=TSNoList.Create(Self);
  MULCtrlO2[PageNo].Name := 'BinBuildList';

  // CJS 2016-01-27 - ABSEXCH-16900 - Cannot jump to end of discount list on Traders
  MULCtrlO2[PageNo].UseAlternativeEndKey := True;

  Try

    With MULCtrlO2[PageNo] do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(MBCPanel,MBCLab);
          AddVisiRec(MBQPanel,MBQLab);
          AddVisiRec(MBDPanel,MBDLab);
          AddVisiRec(MBIPanel,MBILab);
          AddVisiRec(MBOPanel,MBOLab);
          AddVisiRec(MBLPanel,MBLLab);
          AddVisiRec(MBTPanel,MBTLab);
          AddVisiRec(MBKPanel,MBKLab);

          VisiRec:=List[0];

          {$IFNDEF SOP}
            SetHidePanel(5,BOn,BOff);
          {$ENDIF}

          SetHidePanel(7,Not InBINFind,BOn);


          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          LabHedPanel:=MBHedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;



      Find_ValCoord(PageNo);

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=7;
      Font:=StartPanel.Font;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      If (InBINModal) or (BINUseMode) then
        StkCallBack:=Self
      else
        MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        {If (n In [6]) then
        Begin
          DispFormat:=SGFloat;

          NoDecPlaces:=Syss.NoCosDec;
        end;}
      end;

      LinkOtherDisp:=BOn;
      ListLocal:=@ExLocal;

      DispDocPtr:=nil;

      DisplayMode:=6;

      ListCreate;

      MStkLocFilt:=@SRecLocFilt;


      {UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;}

      HighLiteStyle[1]:=[fsBold];
      HighLiteStyle[2]:=[fsBold,fsUnderline];
      HighLiteStyle[3]:=[fsUnderline];


      Set_Buttons(CListBtnPanel);

      ReFreshValList(BOn,BOff);

    end; {With}

    SNoPageReSize;

  Except

    MULCtrlO2[PageNo].Free;
    MULCtrlO2[PageNo]:=Nil;
  end;


end;

{$IFDEF PF_On}


  procedure TStockRec.ValBuildList(PageNo     :  Byte;
                                   ShowLines  :  Boolean);

  Var
    StartPanel  :  TSBSPanel;
    n           :  Byte;



  Begin
    StartPanel := nil;
    MULCtrlO2[PageNo]:=TSNoList.Create(Self);
    MULCtrlO2[PageNo].Name := 'ValBuildList';


    Try

      With MULCtrlO2[PageNo] do
      Begin


        Try

          With VisiList do
          Begin
            AddVisiRec(VOPanel,VOLab);
            AddVisiRec(VDPanel,VDLab);
            AddVisiRec(VAPanel,VALab);
            AddVisiRec(VQPanel,VQLab);
            AddVisiRec(VIPanel,VILab);
            AddVisiRec(VUPanel,VULab);
            AddVisiRec(VLocPanel,VLocLab);

            // SSK 18/05/2018 2018-R1.1 ABSEXCH-20304: Unit Cost column should be right aligned
            ColAppear^[1].ExportMetadata := emtDate;            //Date
            ColAppear^[3].ExportMetadata := emtQuantity;        //Qty
            ColAppear^[4].ExportMetadata := emtQuantity;        //In Stk
            ColAppear^[5].ExportMetadata := emtCurrencyAmount;  //Unit Cost

            VisiRec:=List[0];

            StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

            {$IF Not Defined(SOP) or Defined(LTE)}
              SetHidePanel(FindxColOrder(6),BOn,BOn);
            {$IFEND}



            LabHedPanel:=ValHedPanel;

            SetHedPanel(ListOfSet);

          end;
        except
          VisiList.Free;

        end;



        Find_ValCoord(PageNo);

        TabOrder := -1;
        TabStop:=BOff;
        Visible:=BOff;
        BevelOuter := bvNone;
        ParentColor := False;
        Color:=StartPanel.Color;
        MUTotCols:=6;
        Font:=StartPanel.Font;

        WM_ListGetRec:=WM_CustGetRec;


        Parent:=StartPanel.Parent;

        MessHandle:=Self.Handle;

        For n:=0 to MUTotCols do
        With ColAppear^[n] do
        Begin
          AltDefault:=BOn;

          If (n In [3..5]) then
          Begin
            DispFormat:=SGFloat;

            If (n=5) then
              NoDecPlaces:=Syss.NoCosDec
            else
              NoDecPlaces:=Syss.NoQtyDec;
          end;
        end;


        ListLocal:=@ExLocal;

        DispDocPtr:=nil;

        DisplayMode:=1;

        ListCreate;

        MStkLocFilt:=@SRecLocFilt;


        Set_Buttons(CListBtnPanel);

        ReFreshValList(BOn,BOff);

      end; {With}

      SNoPageReSize;

    Except

      MULCtrlO2[PageNo].Free;
      MULCtrlO2[PageNo]:=Nil;
    end;


  end;

  {$IFDEF SOP}
  procedure TStockRec.MultiBuyBuildList(PageNo     :  Byte;
                                    ShowLines  :  Boolean);
  begin
    MULCtrlO[PageNo]:= mbdFrame.BuildList('', ExLocal.LStock.StockCode, @ExLocal, Self.Handle, 'K', LastCoord, FSettings) as TSLMList;
  end;
  {$ENDIF}


  procedure TStockRec.QBBuildList(PageNo     :  Byte;
                                  ShowLines  :  Boolean);

  Var
    StartPanel  :  TSBSPanel;
    n           :  Byte;



  Begin
    StartPanel := nil;
    MULCtrlO2[PageNo]:=TSNoList.Create(Self);
    MULCtrlO2[PageNo].Name := 'QBBuildList';


    Try

      With MULCtrlO2[PageNo] do
      Begin


        Try

          With VisiList do
          Begin
            AddVisiRec(QBFPanel,QBFLab);
            AddVisiRec(QBTPanel,QBTLab);
            AddVisiRec(QBYPanel,QBYLab);
            AddVisiRec(QBUPanel,QBULab);
            AddVisiRec(QBBPanel,QBBLab);
            AddVisiRec(QBDPanel,QBDLab);
            AddVisiRec(QBVPanel,QBVLab);
            AddVisiRec(QBMPanel,QBMLab);

            AddVisiRec(QBEffPanel,QBEffLab);

            {$IFDEF LTE}
              With VisiList do
                SetHidePanel(FindxColOrder(8),BOn,BOn);
            {$ENDIF}

            // SSK 18/05/2018 2018-R1.1 ABSEXCH-20304: Discount column should be right aligned
            ColAppear^[0].ExportMetadata := emtQuantity;            //From
            ColAppear^[1].ExportMetadata := emtQuantity;            //To
            ColAppear^[3].ExportMetadata := emtCurrencyAmount;      //Unit Price(U/Price)
            ColAppear^[5].ExportMetadata := emtAlignRight;          //Disc(%)
            ColAppear^[6].ExportMetadata := emtNonCurrencyAmount;   //Disc(val)
            ColAppear^[7].ExportMetadata := emtAlignRight;          //Margin

            VisiRec:=List[0];

            StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

            LabHedPanel:=QBHedPanel;

            SetHedPanel(ListOfSet);



          end;
        except
          VisiList.Free;

        end;



        Find_ValCoord(PageNo);

        TabOrder := -1;
        TabStop:=BOff;
        Visible:=BOff;
        BevelOuter := bvNone;
        ParentColor := False;
        Color:=StartPanel.Color;

        MUTotCols:=8;
        
        Font:=StartPanel.Font;

        WM_ListGetRec:=WM_CustGetRec;


        Parent:=StartPanel.Parent;

        MessHandle:=Self.Handle;

        For n:=0 to MUTotCols do
        With ColAppear^[n] do
        Begin
          AltDefault:=BOn;

          If (Not (n In [2,4])) then
          Begin
            DispFormat:=SGFloat;

            Case n of
              0,1  :  NoDecPlaces:=Syss.NoQtyDec;
              3,6  :  NoDecPlaces:=Syss.NoNetDec;
              5,7  :  NoDecPlaces:=2;
            end; {Case..}

          end;
        end;


        ListLocal:=@ExLocal;

        DispDocPtr:=nil;

        DisplayMode:=2+Ord(CQtyBMode);

        ListCreate;


        Set_Buttons(CListBtnPanel);

        ReFreshValList(BOn,BOff);

      end; {With}

      SNoPageReSize;

    Except

      MULCtrlO2[PageNo].Free;
      MULCtrlO2[PageNo]:=Nil;
    end;


  end;


  procedure TStockRec.RefreshValList(ShowLines,
                                     IgMsg      :  Boolean);

  Const
    MISubAry  :  Array[SQtyBPNo..SBINPNo] of Char = (QBDiscSub,#0,#0,MFIFOSub,#0,MSERNSub,MSERNSub);
    MITypAry  :  Array[SQtyBPNo..SBINPNo] of Char = (QBDiscCode,#0,#0,MFIFOCode,#0,MFIFOCode,BRRecCode);
    SFNdxAry  :  Array[0..1] of SmallInt = (MiscNDXK,MiscBtcK);

  Var
    KeyStart    :  Str255;

    LFnum,
    LKeyPath,
    LKeyLen     :  SmallInt;

    PadLocFilt  :  Str10;

  Begin

    LKeyPath:=MIK;  LFnum:=MiscF;

    If (Assigned(MULCtrlO2[Current_Page])) then
    With MULCtrlO2[Current_Page],ExLocal,LStock do
    Begin
      LNHCtrl:=DDCtrl;

      With ExLocal,LStock,LCust,LNHCtrl do
      Begin
        If {(CQtyBMode)} Current_Page = SQtyBPNo then
        begin

          //PR; 07/02/2012 Amended to use new Qty Break file ABSEXCH-9795
          Case DisplayMode of
            2  :  KeyStart := QtyBreakStartKey('', StockFolio);
            3  :  KeyStart := QtyBreakStartKey(CustCode, Stock.StockFolio);
          end; //Case
          LFnum:=QtyBreakF;
          LKeyPath := 0;

          //PR: 23/02/2012 Remove zeros from end of fullnomkey to ensure that it
          //can be compared against a string returned from a Btrv call
          Filter[1, 0] := RemoveZeros(FullNomKey(CustDiscountRec.QtyBreakFolio));

        end
        else
        Begin
          If (InSerFind) then {* Switch to global sno search *}
          Begin
            KeyStart:=FullQDKey(MFIFOCode,MSERNSub,SerMainK);
            LKeypath:=SFNDXAry[SerFindMode];
          end
          else
          Begin
            KeyStart:=FullQDKey(MITypAry[Current_Page],MISubAry[Current_Page],FullNomKey(StockFolio));

            If ((SerRetMode In [23,25]) or ((SerRetMode=26) and (LInv.InvDocHed In StkRetSalesSplit))) and (Current_Page=SSerialPNo) then {* Sold Only lines *}
            Begin
              KeyStart:=KeyStart+#1;
              SLRetMode:=BOn;
            end;
          end;

          If (Current_Page=SBinPNo) then {Switch files}
          Begin
            If (InBinFind) then {* Switch to global sno search *}
            Begin
              KeyStart:=FullQDKey(MITypAry[Current_Page],MISubAry[Current_Page],SerMainK);
              LKeypath:=SerFindMode;
            end
            else
            Begin
              {$IFDEF SOP}
                If (Not Syss.UseMLoc) and (fSortLocBin) then
                  PadLocFilt:=Full_MLocKey(SRecLocFilt)
                else
              {$ENDIF}
                  PadLocFilt:=SRecLocFilt;

              If (fSortLocBin) then
              Begin
                KeyStart:=FullQDKey(MITypAry[Current_Page],MISubAry[Current_Page],PadLocFilt+FullNomKey(StockFolio));
                LKeypath:=MLSuppK;
              end
              else
              Begin
                LKeypath:=MLSecK;

                KeyStart:=KeyStart+PadLocFilt;
              end;
            end;

            LFnum:=MLocF;
          end;

        end;
      end;

      {$IFDEF SOP}
          Filter[3,0]:=SetLocFilt;
      {$ENDIF}

      LKeyLen:=Length(KeyStart);



      IgnoreMsg:=IgMsg;

      StartList(LFnum,LKeypath,KeyStart,'','',LKeyLen,(Not ShowLines));

      IgnoreMsg:=BOff;
    end;

  end;

{$ENDIF}


procedure TStockRec.CLORefPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  BarPos :  Integer;
  PanRSized
         :  Boolean;



begin

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    BarPos:=Current_BarPos(Current_Page);

    If (PanRsized) then
      MULCtrlO[Current_Page].ResizeAllCols(MULCtrlO[Current_Page].VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO[Current_Page].VisiList.MovingLab or PanRSized);
  end;

end;




procedure TStockRec.CLORefLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      If (MULCtrlO[Current_Page]<>nil) then
        MULCtrlO[Current_Page].VisiList.PrimeMove(Sender);
      NeedCUpdate:=BOn;
    end
    else
      If (Button=mbRight) then
      Begin
        ListPoint:=ClientToScreen(Point(X,Y));

        ShowRightMeny(ListPoint.X,ListPoint.Y,0);
      end;

  end;
end;


procedure TStockRec.CLORefLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO[Current_Page]<>nil) then
    Begin
      MULCtrlO[Current_Page].VisiList.MoveLabel(X,Y);

      NeedCUpdate:=MULCtrlO[Current_Page].VisiList.MovingLab;
    end;
  end;

end;

{ ======= Link to Trans display ======== }

procedure TStockRec.Display_Trans(Mode  :  Byte);

Var
  DispTrans  :  TFInvDisplay;
  DisplayOptions : TransactionDisplayOptionsSet;
Begin

  If (DispTransPtr=nil) then
  Begin
    DispTrans:=TFInvDisplay.Create(Self);
    DispTransPtr:=DispTrans;
  end
  else
    DispTrans:=DispTransPtr;

    try

      ExLocal.AssignFromGlobal(IdetailF);

      With ExLocal,DispTrans do
      Begin
        LastDocHed:=LId.IdDocHed;

        if (Mode = 2) and RestrictedEditOnly(Inv) then
          DisplayOptions := [GDPR_AllowPostedEdit]
        else
          DisplayOptions := [];

        //AP : 27/01/2017 2017-R1 ABSEXCH-17296 : view button press for the second time do not work
        If (InHBeen) then
            Display_Trans(Mode,LId.FolioRef,BOn,(Mode<>100), DisplayOptions);

      end; {with..}

    except

      DispTrans.Free;

    end;

end;



procedure TStockRec.ViewCP1BtnClick(Sender: TObject);
Var
  Modus       :  Byte;
  
  ListPoint   :  TPoint;

  KeyS : Str255;
  Res  : Integer;

begin
  Case Current_Page of
    SQtyBPNo,SValuePNo
       :  Begin
            {$IFDEF PF_On}
              Case Current_Page of
                SQtyBPNo
                  // MH 30/06/2009: Added check on user permissions
                  //:  Display_QtyRec(2);
                  :  If PChkAllowed_In (298) Then Display_QtyRec(2);
                SValuePNo
                  :  If Assigned(MULCtrlO2[SValuePNo]) then
                      With MULCtrlO2[SValuePNo] do
                      Begin
                        GetSelRec(BOff);
                        Display_StkDoc(5);
                      end;
              end; {Case..}
            {$ENDIF}
          end;

    SSerialPNo
       :  If (Not InSerModal) then
          Begin
            MULCtrlO2[Current_Page].GetSelRec(BOff);

            GetCursorPos(ListPoint);
            ScreenToClient(ListPoint);

            PopupMenu5.PopUp(ListPoint.X,ListPoint.Y);
          end;

    SBinPNo
       :  If (Not InBinModal) then
          Begin
            MULCtrlO2[Current_Page].GetSelRec(BOff);

            GetCursorPos(ListPoint);
            ScreenToClient(ListPoint);

            PopupMenu5.PopUp(ListPoint.X,ListPoint.Y);
          end;

    else  With MULCtrlO[Current_Page] do
            If (ValidLine) then
            Begin
              RefreshLine(MUListBoxes[0].Row,BOff);

              InHBeen:=BOn;

              //AP : 27/01/2017 2017-R1 ABSEXCH-17296 : View button on Stock Ledger displays transaction in Edit mode rather than View mode
              If (Sender=EditCP1Btn) or (Sender=Edit1) then
                Modus:=2
              else
                Modus:=100;   

              //PR: 12/02/2016 v2016 R1 ABSEXCH-17038 Add check for security hook point 150 (Edit) & 155 (View)
              {$IFDEF CU}
              //Don't necessarily have invoice at this point, so may need to find it
              if Inv.FolioNum <> Id.FolioRef then
              begin
                KeyS := FullNomKey(Id.FolioRef);
                Res := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, KeyS);
              end;
              {$B-}
              if ((Modus = 2) and ValidSecurityHook(2000, 150, ExLocal)) or
                 ((Modus = 100) and ValidSecurityHook(2000, 155, ExLocal)) then
              {$B+}
              {$ENDIF Customisation}
                Display_Trans(Modus);

            end;
  end; {Case..}

end;


procedure TStockRec.Display_History(HistMode     :  Byte;
                                    ChangeFocus  :  Boolean);


{$IFDEF NOM}

  Var
    NomNHCtrl  :  TNHCtrlRec;

    FoundLong  :  Longint;

    fPr,fYr    :  Byte;

    HistForm   :  THistWin;

    WasNew     :  Boolean;

  Begin
    LastHMode:=HistMode;

    WasNew:=BOff;

    With NomNHCtrl do
    Begin
      FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

      NHMode:=9;
      NBMode:=12;

      NHCr:=0;
      NHTxCr:=0;
      NHPr:=1;
      NHYr:=GetLocalPr(0).CYr;

      {NHCCode:=FullNCode(FullNomKey(ExLocal.LStock.StockFolio));}

      NHLocCode:=SRecLocFilt;
      NHCCode:=CalcKeyHist(ExLocal.LStock.StockFolio,NHLocCode);


      NHKeyLen:=NHCodeLen+2;

      With EXLocal,LStock,Nom do
      Begin
        Find_FirstHist(StockType,NomNHCtrl,fPr,fYr);
        MainK:=FullNHistKey(StockType,NHCCode,NHCr,fYr,fPr);
        AltMainK:=FullNHistKey(StockType,NHCCode,NHCr,0,0);
      end;

      Set_NHFormMode(NomNHCtrl);

      ExLocal.AssignToGlobal(StockF);

    end;

    If (HistFormPtr=nil) then
    Begin
      WasNew:=BOn;

      HistForm:=THistWin.Create(Self);

      HistFormPtr:=HistForm;

    end
    else
      HistForm:=HistFormPtr;

    Try

     With HistForm do
     Begin


       WindowState:=wsNormal;

       If (ChangeFocus) then
         Show;

       ShowLink(BOn,BOff);


     end; {With..}


    except

     HistFormPtr:=nil;

     HistForm.Free;
     HistForm:=nil;

    end; {try..}

{$ELSE}
begin
{$ENDIF}

end;


procedure TStockRec.SRTFExit(Sender: TObject);

Var
  mrRet  :  Word;

begin

  If (ExLocal.InAddEdit) then
  Begin
    If (SRTF.ItemIndex<0) then
      SRTF.ItemIndex:=0;

    Set_EntryRO(EquivSTItem);
  end;

  With SRTF do
  Begin  {* Set to read only if a group and items below *}
    If (Not ReadOnly) and (ExLocal.InAddEdit) and (Modified) and ((Not CanDelete) and (EquivSTItem=2)) then
    Begin
      StopPageChange:=BOn;

      mrRet:=MessageDlg('This Stock Record cannot be used as a Group heading',mtWarning,[mbok],0);

      ItemIndex:=LastSType;
      SetFocus;
    end
    else
    If (ExLocal.InAddEdit) then
    Begin
      Form2Stock;
      BuildDesign;
      StopPageChange:=BOff;
    end;  
  end; {With..}

end;

procedure TStockRec.SRTFEnter(Sender: TObject);
begin
  With SRTF do
  Begin  {* Set to read only if a group and items below *}
    LastSType:=ItemIndex;

    If (ExLocal.InAddEdit) and (Not ReadOnly) then
      ReadOnly:=((Not CanDelete) and (EquivSTItem=2));
  end;
end;

procedure TStockRec.SRFSFEnter(Sender: TObject);
begin
  {StopPageChange:=ExLocal.InAddEdit;}
end;


procedure TStockRec.SRFSFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  Flg,
  FoundOk,
  AltMod     :  Boolean;

  RODiscChr  : Char;
  Rnum,
  RODisc
             : Real;



begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (AltMod) and  (FoundCode<>'') and (OrigValue<>Text) and (ExLocal.InAddEdit) and (ActiveControl<>CanCP1Btn) then
    Begin
      If (Not InPageChanging) then
      Begin

        StillEdit:=BOn;

        StopPageChange:=BOn;

        FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOff,0));

        If (FoundOk) then
        Begin

          StopPageChange:=BOff;

          StillEdit:=BOff;

          Text:=FoundCode;

          {* Weird bug when calling up a list caused the Enter/Exit methods
               of the next field not to be called. This fix sets the focus to the next field, and then
               sends a false move to previous control message ... *}

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

          {$IFDEF MC_On}
            With ExLocal do
            If (LStock.ROCurrency<>Cust.Currency) then
            With LStock do
            Begin
              Form2Stock;

              Flg:=(ROCPrice=0);

              Rnum:=Currency_ConvFT(ROCPrice,LStock.ROCurrency,Cust.Currency,UseCoDayRate);

              RODisc:=0.0; RODiscChr:=#0;

              ROCurrency:=Cust.Currency;

              Calc_StockPrice(LStock,Cust,ROCurrency,ROQty,Today, Rnum,RODisc,RODiscChr,SRecLocFilt,Flg,0);

              ROCPrice:=Round_Up(Rnum-Calc_PAmount(Rnum,RODisc,RODiscChr),Syss.NoCosDec);

              OutStock;
            end;
          {$ENDIF}

        end
        else
        Begin

          ChangePage(SDefaultPNo);

          StopPageChange:=BOn;

          SetFocus;
        end; {If not found..}
      end
      else
        Text:=OrigValue;
    end
    else
      StopPageChange:=BOff;
  end; {with..}
end;



procedure TStockRec.SRCCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin

  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      FoundCode:=Name;

      IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn) and (Syss.UseCCDep) and (ExLocal.InAddEdit) then
      Begin
        If (Not InPageChanging) then
        Begin

          StillEdit:=BOn;

          StopPageChange:=BOn;


          FoundOk:=(GetCCDep(Self.Owner,FoundCode,FoundCode,IsCC,2));

          If (FoundOk) then {* Credit Check *}
          With ExLocal do
          Begin

            AssignFromGlobal(PWrdF);

          end;


          If (FoundOk) then
          Begin

            StopPageChange:=BOff;

            StillEdit:=BOff;

            Text:=FoundCode;

          end
          else
          Begin
            StopPageChange:=BOn;

            SetFocus;
          end; {If not found..}
        end
        else
          Text:=OrigValue;
      end
      else
        StopPageChange:=BOff;

    end; {with..}
  {$ENDIF}
end;


Function TStockRec.GLFilterMode(Sender  :  TObject;
                                Mode    :  Byte)  :  Byte;

Begin
  Result:=2;

  If (Syss.UseGLClass) then
  Begin
    If (Sender=SRGSF) or (Sender=SRGCF) then
      Result:=20
    else
      If (Sender=SRGWF) then
        Result:=12
      else
        If (Sender=SRGVF) then
          Result:=14
        else
          If (Sender=SRGPF) then
            Result:=13
          else
            If (Sender=SRGIF) then
              Result:=15
          else
            If (Sender=SRRGLF) then
              Result:=18
          else
            If (Sender=SRRPGLF) then
              Result:=19;
  end;
end;


procedure TStockRec.SRGSFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  FoundLong  :  LongInt;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    With ExLocal do
    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (ExLocal.InAddEdit) {$IFNDEF LTE} and (Not IsProdMode(LStock.StockType,StkGrpCode)) {$ENDIF} then
    Begin

      If (Not InPageChanging) then
      Begin

          StillEdit:=BOn;
        StopPageChange:=BOn;

        FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,GLFilterMode(Sender,0)));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          AssignFromGlobal(NomF);

        end;


        If (FoundOk) then
        Begin

          StopPageChange:=BOff;

          Text:=Form_Int(FoundLong,0);

          Show_GLDesc(Sender);

        end
        else
        Begin
          StopPageChange:=BOn;

          SetFocus;
        end; {If not found..}
      end
      else
        Text:=OrigValue;
    end
    else
      StopPageChange:=BOff;


  end; {with..}
end;



procedure TStockRec.SRJAFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn) and (ExLocal.InAddEdit) then
      Begin

        If (Not InPageChanging) then
      Begin

          StillEdit:=BOn;

          StopPageChange:=BOn;

          FoundOk:=GetJobMisc(Self.Owner,FoundCode,FoundCode,2,3);

          If (FoundOk) then {* Credit Check *}
          With ExLocal do
          Begin

            StopPageChange:=BOff;

            AssignFromGlobal(JMiscF);

            Text:=FoundCode;

            Show_GLDesc(Sender);

          end
          else
          Begin
            StopPageChange:=BOn;

            SetFocus;
          end; {If not found..}
        end
        else
          Text:=OrigValue;
      end
      else
        StopPageChange:=BOff;

    end;
  {$ENDIF}

end;


procedure TStockRec.SRVMFExit(Sender: TObject);
begin
  Form2Stock;
  BuildDesign;

  Set_MBin(EquivSTItem);
end;

procedure TStockRec.SRSBox1Exit(Sender: TObject);
begin
  If (Sender is TScrollBox) then
    TScrollBox(Sender).VertScrollBar.Position:=0;
end;


procedure TStockRec.HistCP1BtnClick(Sender: TObject);
begin
  Display_History(9,BOn);
end;


Procedure TStockRec.FindCustCode;


Var
  InpOk,
  FoundOk  :  Boolean;

  FoundCode:  Str20;

  SCode    :  String;

  KeyS     :  Str255;


Begin
  If (MULCtrlO[SLedgerPNo]<>nil) then
  Begin
    FoundOK := False;
    SCode:='';

    Repeat

      InpOk:=InputQuery('Filter by account','Please enter the account code you wish to find',SCode);

      If (InpOk) then
      Begin
        FoundOk:=(SCode='');

        If (Not FoundOk) then
          FoundOk:=GetCust(Owner,SCode,FoundCode,BOff,99);
      end;

    Until (FoundOk) or (Not InpOk);

    If (FoundOk) then
    With MULCtrlO[SLedgerPNo] do
    Begin
      CListFilt:=FoundCode;
      StkLIsaC:=IsaCust(Cust.CustSupp);

      {RefreshList(BOn,BOff);}

      SetNewLIndex;
    end;
  end;

end;


procedure TStockRec.Account1Click(Sender: TObject);

Var
  PageNo,
  BTagNo  :  Integer;

begin
  PageNo:=Current_Page;

  If (Sender is TMenuItem) then
    With TMenuItem(Sender) do
    Begin
      BTagNo:=Tag;

      Case BTagNo of
        1..15,17,
        19..21 :  If (Assigned(MulCtrlO[PageNo])) then
                   With MulCtrlO[PageNo] do
                   Begin
                     FilterMode:=BTagNo;

                     Filter[1,1]:=NdxWeight;

                     {InitPage;}

                     SetNewLIndex;
                   end;


        16    :  FindCustCode;

      end;

      SetCheckedMenuItems(Find1,-1,BTagNo);
      LastBTag:=BTagNo;
    end;
end;


procedure TStockRec.FindCP1BtnClick(Sender: TObject);

Var
  ListPoint   :  TPoint;
  ReturnCtrl  :  TReturnCtrlRec;


begin
  Case Current_Page of

   {$IFDEF GF}
    SMainPNo..SRetPNo
       :  With ReturnCtrl,MessageReturn do
          Begin
            FillChar(ReturnCtrl,Sizeof(ReturnCtrl),0);

            WParam:=3000;
            Msg:=WM_CustGetRec;
            DisplayxParent:=BOn;
            ShowOnly:=BOn;


           //PR: 04/12/2013 ABSEXCH-14824
           Ctrl_GlobalFind(Self, ReturnCtrl, tabFindStock);

          end; {With..}

   {$ENDIF}


    SLedgerPNo
       :  With TWinControl(Sender) do
          Begin
            ListPoint.X:=1;
            ListPoint.Y:=1;

            ListPoint:=ClientToScreen(ListPoint);

            SetCheckedPopUpMenu(PopUpMenu7,-1,LastBTag);

            PopUpMenu7.PopUp(ListPoint.X,ListPoint.Y);


          end;

   {$IFDEF SOP}
     SSerialPNo
       :  If (MULCtrlO2[Current_Page]<>nil) and (Sender is TButton) then
           With MULCtrlO2[Current_Page], TWinControl(Sender) do
           If (Not InListFind) then
           Begin
             ListPoint.X:=1;
             ListPoint.Y:=1;

             ListPoint:=ClientToScreen(ListPoint);

             PopUpMenu4.PopUp(ListPoint.X,ListPoint.Y);
           end;
   {$ENDIF}

     SBinPNo
       :  Begin
            If (Current_Page=SBinPNo) and (Assigned(MULCtrlO2[Current_Page])) then
            With MULCtrlO2[SBinPNo] do
            Begin
              GetMiniSERN(4);
            end;
          end;
  end; {Case..}
end;



{ ========== Procedure to Copy BOM =========== }


Procedure TStockRec.Copy_BOM(StockR    :  StockRec;
                             NewCode   :  Str20;
                             Fnum2,
                             Keypath2  :  Integer);


Var
  KeyChk,
  KeyS      :  Str255;

  RecAddr   :  LongInt;

  NewFolio  :  Str20;

  Fnum,
  Keypath   :  Integer;





Begin


  Fnum:=PWrdF;

  Keypath:=PWK;

  With ExLocal,LStock do
  Begin

    LStock:=StockR;

    StockFolio:=SetNextSFolio(SKF,BOn,0);

    StockCode:=NewCode;

    QtyInStock:=0;

    QtyPosted:=0;

    QtyAllocated:=0;

    QtyOnOrder:=0;

    QtyAllocWOR:=0.0;
    QtyIssueWOR:=0.0;
    QtyPickWOR:=0.0;
    QtyReturn:=0.0;
    QtyPReturn:=0.0;

    RoFlg:=BOff;
    MinFlg:=BOff;

    StkFlg:=BOff;

    QtyPicked:=0;
    QtyFreeze:=0;

    CovSold:=0;

    QtyTake:=0;

    Status:=Add_Rec(F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2);

    //TW 07/11/2011 Adds Stock Copy audit note.
    if(status = 0) then
      TAuditNote.WriteAuditNote(anStock, anCreate, ExLocal);

    Report_BError(Fnum2,Status);

    If (StatusOk) then
    Begin
      LGetMainRecPosKey(Fnum2,StkCodeK,StockCode);
      LGetRecAddr(Fnum2);

      CanDelete:=BOn;

      KeyS:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockR.StockFolio)));

      KeyChk:=KeyS;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);


      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With LPassword.BillMatRec do
      Begin

        Status:=GetPos(F[Fnum],Fnum,RecAddr);

        Blank(NewFolio,Sizeof(NewFolio));

        NewFolio:=Copy(StockLink,5,Length(StockLink)-4);


        StockLink:=FullNomKey(StockFolio)+NewFolio;

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

        Report_BError(Fnum,Status);

        // HM 10/05/99: Modified to call LSet... as passing in L record from ExLocal.
        //              bug was causing the GetDirect to return status 43 all the time,
        //              and was causing BOM lines to be missed at Hanworth Labs.
        //SetDataRecOfs(Fnum,RecAddr);
        LSetDataRecOfs(Fnum,RecAddr);

        Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,0);


        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);

        Application.ProcessMessages;

      end; {While..}


      {* Copy Notes .. *}

      KeyS:=FullQDKey(NoteTCode,NoteSCode,FullNCode(FullNomKey(StockR.StockFolio)));

      KeyChk:=KeyS;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);


      {$IFDEF NP}
        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
        With LPassword.NotesRec do
        Begin

            Status:=GetPos(F[Fnum],Fnum,RecAddr);

            NoteFolio:=FullNCode(FullNomKey(StockFolio));

            NoteNo:=FullRNoteKey(NoteFolio,NType,LineNo);

            {NoteNo:=NoteFolio+NType+FullNomKey(LineNo); {Replaced with call to FullRNoteKey v5.52}

            //TW: 07/11/2011 Prevent audit notes being copied from one owner to another
            if NType <> ntAudit then
            begin
            Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);
            Report_BError(Fnum,Status);

            // HM 10/05/99: Modified to call LSet... as passing in L record from ExLocal.
            //SetDataRecOfs(Fnum,RecAddr);
            LSetDataRecOfs(Fnum,RecAddr);
            end;

            Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,0);
            Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);
            Application.ProcessMessages;

        end; {While..}
      {$ENDIF}
    end; {If Header stored ok..}

  end; {With..}

end; {Proc..}




{ ===== Procedure to Control Copy BOM ===== }



Procedure TStockRec.Control_BOMCopy(Fnum,
                                    KeyPath  :  Integer);


Var
  KeyS      :  Str255;

  SCode     :  String;

  mbRet     :  Word;

  InpOk,
  DupliFlg  :  Boolean;

  MsgForm   :  TForm;


Begin

  DupliFlg:=BOff;

  SCode:='';

  mbRet:=mrNone;

  Repeat

    InpOk:=InputQuery('Copy Stock Record','Please enter the Code for the new Stock Record',SCode);

    If (InpOk) then
    Begin

      KeyS:=FullStockCode(SCode);

      DupliFlg:=CheckExsists(KeyS,StockF,StkCodeK);

      If (DupliFlg) then
        mbRet:=MessageDlg('That Stock code already exists!',mtError,[mbOk,mbCancel],0);


    end;

  Until (Not InpOk) or ((Not DupliFlg)  and (Not EmptyKey(KeyS,StkKeyLen))) or (mbRet=mrCancel);


  If (InpOk) and (Not DupliFlg) then
  Begin

    MsgForm:=CreateMessageDialog('Please Wait...Generating new Stock Record : '+SCode,mtInformation,[]);
    MsgForm.Show;
    MsgForm.Update;

    Copy_BOM(ExLocal.LStock,KeyS,Fnum,Keypath);
    MsgForm.Free;

    {* Get tree to rebuild itself *}

    SetCaption;
    
    OutStock;
    
    Send_UpdateList(BOff,0);


  end;

end; {Proc..}

procedure TStockRec.CopyCP1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  Case Current_Page of
    {$IFDEF PF_On}
      SQtyBPNo
         : With MULCtrlO2[Current_Page], TWinControl(Sender) do
           If (Not InListFind) then
           Begin
             ListPoint.X:=1;
             ListPoint.Y:=1;

             ListPoint:=ClientToScreen(ListPoint);

             If (ExLocal.LStock.StockType=StkGrpCode) then
             Begin
               If (Sender is TButton) then
                 PopUpMenu6.PopUp(ListPoint.X,ListPoint.Y);
             end
             else
               CFrom1.OnClick(Sender);
           end;
    {$ENDIF}
    SLedgerPNo
       : If (MULCtrlO[Current_Page]<>nil) and (Sender is TButton) then
         With MULCtrlO[Current_Page], TWinControl(Sender) do
         If (Not InListFind) then
         Begin
           ListPoint.X:=1;
           ListPoint.Y:=1;

           ListPoint:=ClientToScreen(ListPoint);

           PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
         end;
   {$IFDEF SOP}
    SMultiBuyPNo
       : mbdFrame.CopyDiscount(True);
   {$ENDIF}
    else Begin
           Control_BOMCopy(StockF,SKeyPath);
         end;

  end; {Case..}
end;


procedure TStockRec.Copy2Click(Sender: TObject);
Var
  bCont : Boolean;
begin
  If (Sender Is TMenuItem) then
  Begin

    Case Current_Page of
      SLedgerPNo
         :  If (MULCtrlO[Current_Page]<>nil) then
            With MULCtrlO[Current_Page] do
              If (ValidLine) then
              Begin
                GetSelRec(BOff);
                Link2Inv;

                {$IFDEF SOP}
                  // MH 14/11/2014 Order Payments: Added confirmation checks for Order Payment Transactions being Reversed
                  If (Tag = 2) Then
                    // Reverse/Contra
                    bCont := OrdPay_OKToReverse(Inv)
                  Else
                    // Copy - no additional checks required
                    bCont := True;
                {$ELSE}
                  bCont := True;
                {$ENDIF SOP}

                If bCont Then
                Begin
                  ContraCopy_Doc(ExLocal.LInv.FolioNum,TMenuItem(Sender).Tag,'');
                  PageUpDn(0,BOn);
                End; // If bCont
              end;
    end; {Case..}
  end; {With..}

end;


{$IFDEF PF_On}

  { ======== BOM Control Procedures ========== }

  Procedure TStockRec.ClearBOMPage;

  Begin
    With NLOLine do
    If (ItemCount>0) then
      Repeat

        Delete_OutLines(1,BOn);

      Until (ItemCount<=0);
  end;


  {Procedure TStockRec.UpdateBOMPage;

  Var
    Idx          :  Integer;
    ONomRec      :  ^OutNomType;

  Begin
    With NLOLine do
    Begin
      For Idx:=1 to ItemCount do
      Begin
        ONomRec:=Items[Idx].Data;

        If (ONomRec<>nil) then
        With ONomRec^ do
        Begin


        end;
      end;
    end;
  end;}


 {* Function to return Min GP *}


  Function TStockRec.Min_Gp  :  Double;

  Var
    n        :  Byte;

    LastGp,
    Rnum     :  Double;



  Begin

    LastGp:=0;

    Rnum:=0;

    For n:=1 to MaxStkPBands do
    With ExLocal,LStock do
    Begin

      With SaleBands[n] do
        If (SalesPrice<>0)  then
          Rnum:=Stock_Gp(CostPrice,Currency_ConvFT(SalesPrice,Currency,PCurrency,UseCoDayRate),
                BuyUnit,SellUnit,Ord(Syss.ShowStkGP),CalcPack)
        else
          Rnum:=0;

      If ((LastGp>Rnum) and (Round(Rnum)<>0)) or (LastGp=0)  then
        LastGp:=Rnum;

    end; {Loop..}

    Min_Gp:=LastGp;

  end; {Func..}


  Procedure TStockRec.OutCost;


  Begin
    With ExLocal,LStock do
    Begin
      If (PChkAllowed_In(143)) then
      Begin
        If (FIFO_Mode(StkValType)=4) then
          CostLab.Caption:=FormatCurFloat(GenUnitMask[BOff],ROCPrice,BOff,ROCurrency)
        else
          CostLab.Caption:=FormatCurFloat(GenUnitMask[BOff],CostPrice,BOff,PCurrency);
      end
      else
        Costlab.Caption:='';

      {$IFDEF WOP}
        BOMTimePanel.Caption:=ProdTime2Str(BOMProdTime+ProdTime);
      {$ENDIF}
    end;
  end;

  procedure TStockRec.BOMBuildPage;

  Var
    n           :  Byte;



  Begin
    With ExLocal,LStock do
    Begin
      If (Not InBOM) then
      Begin
        ColXAry[1]:=NLDrPanel.Width+NLDrPanel.Left-4;
        ColXAry[2]:=NLCrPanel.Width+NLCrPanel.Left-4;

        ChrWidth:=Round(Width*ChrsXRoss);

        BomKey[BOff]:=PWK;
        BomKey[BOn]:=HelpNdxK;
        InBOM:=BOn;

      end
      else
        ClearBOMPage;

      If (PChkAllowed_In(143)) then
        GPLab.Caption:=FormatFloat(GenPcntMask,Min_GP)
      else
        GPLab.Caption:='';

      YTDCombo.Enabled:=((StockType=StkBillCode) and (Not InAddEdit));

      OutCost;

      YTDCombo.ItemIndex:=(1*Ord(ShowAsKit))+(2*Ord(KitOnPurch));
      LastYTDII:=YTDCombo.ItemIndex;

      PriceChk.Checked:=KitPrice;

      BOMFolio:=StockFolio;

      Add_OutLines(0,2,0,StockFolio,PWrdF,BomKey[BomMode]);


    end;
  end;


  Function TStockRec.FormatLine(ONomRec  :  OutNomType;
                                LineText :  String)  :  String;

  Begin
    With ONomRec do
    Begin
      Result:=Spc(1*OutDepth)+Strip('R',[#32],LineText);

      Result:=Result+Spc(Round((Width-Canvas.TextWidth(Result))/Canvas.TextWidth(' '))-(TDpth*OutDepth));
    end;
  end;



  { ======= Procedure to Build List based on Nominal File ===== }

  Procedure TStockRec.Add_OutLines(Depth,
                                   DepthLimit,
                                   OIndex,
                                   StkFolio      :   LongInt;
                             Const Fnum,
                                   Keypath       :   Integer);

  Const
    Fnum2     =  StockF;
    Keypath2  =  StkFolioK;


  Var
    KeyS,
    KeyChk,
    KeyLenChk,
    KeyStk
            :  Str255;

    LineText
            :  String;

    SpcWidth,
    NewIdx,
    NewObj,
    TmpRecAddr
            :  LongInt;

    CKLen,
    TmpStat,
    TmpKPath
            :  Integer;

    ONomRec :  ^OutNomType;

    OldCursor
            :  TCursor;


  Begin
    TmpKPath:=Keypath;

    With NLOLine do
    Begin

      OldCursor:=Cursor;

      Cursor:=crHourGlass;

      SpcWidth:=Canvas.TextWidth(' ');

      KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StkFolio)));

      KeyLenChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,Strip('R',[#0],FullNomKey(StkFolio))));

      If (BomMode) then
        CKLen:=6   {CKLen:=Length(KeyLenChk)}  {v4.31.004. Forced to 6 as some hex values of the folio caused corruption. i.e. when searching for hex 75 00 00 00 and getting 75 01...}
      else
        CKLen:=Length(KeyChk);

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
                                                                   {v5.60. Additipnal check made for where used on components that have a zero qty,
                                                                           as unwittingly the index on the BOM record takes into account the qty field,
                                                                           which as long as is non zero pads out the key correctly } 
      While (StatusOk) and ((CheckKey(KeyChk,KeyS,CKLen,BOn)) or ((BomMode) and (FullNomKey(StkFolio)=PassWord.BillMatRec.BillLink))) do
      With PassWord.BillMatRec,Stock do
      Begin
        If (Keypath=HelpNdxK) then
          KeyStk:=StockLink
        else
          KeyStk:=BillLink;

        Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);


        If (StatusOk) then
        Begin

          New(ONomRec);
          FillChar(ONomRec^,Sizeof(ONomRec^),0);
          With ONomRec^ do
          Begin
            OutNomCode:=StockFolio;
            OutStkCode:=StockCode;
            OutStkCat:=StockCat;
            OutDepth:=Depth;
            BeenDepth:=DepthLimit;
            OutNomType:=StockType;
            StkQty:=QtyUsed;
            StkCost:=QtyCost;
            PRateMode:=FreeIssue;
            {OBOMLink:=StockLink;}

            {v4.30a alter to get record position}

            GetPos(F[Fnum],Fnum,OBOMAddr);


          end;

          LineText:=FormatLine(ONomRec^,Strip('R',[#32],Desc[1]));

          NewIdx:=AddChildObject(OIndex,LineText,ONomRec);

          If (StockCode=NewBomStkCode) and (NewBOMStkCode<>'') then
            ShowNewBomIndex:=NewIdx;

          If (StockType=StkBillCode) and (Depth<DepthLimit) then
          Begin
            TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

            Add_OutLines(Depth+1,DepthLimit,NewIdx,StockFolio,Fnum,PWK);

            TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);

          end;

          If (NewIdx>-1) and (FullWOP) then
          With Items[NewIdx] do
          Begin
            ShowCheckBox:=BOn;
          end;


        end;

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}

      Cursor:=OldCursor;

    end; {With..}

  end; {Proc..}


  Procedure TStockRec.Update_OutLines(Const Fnum,
                                            Keypath       :   Integer);


  Var
    KeyS    :  Str255;

    LineText
            :  String;

    N       :  LongInt;

    ONomRec :  ^OutNomType;


  Begin
    With NLOLine do
    Begin
      BeginUpdate;

      For n:=1 to ItemCount do
      Begin
        ONomRec:=Items[n].Data;

        If (ONomRec<>Nil) then
        With ONomRec^ do
        Begin
          KeyS:=FullStockCode(OutStkCode);

          Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

          LineText:=Strip('B',[#32],Items[n].Text);

          With Stock do
          Begin
            {LineText:=Spc(1*OutDepth)+LJVar(LineText,ChrWidth-(20*OutDepth))}

            LineText:=Spc(1*OutDepth)+Strip('R',[#32],Desc[1]);

            LineText:=LineText+Spc(Round((Width-Canvas.TextWidth(LineText))/CanVas.TextWidth(' '))-(TDpth*OutDepth));

            {LineText:=Strip('R',[#32],Desc[1]);

            LineText:=FormatLine(ONomRec^,LineText);}

          end;

          Items[n].Text:=LineText;
        end;

      end; {Loop..}

      EndUpdate;

    end; {With..}
  end; {Proc..}


  Procedure TStockRec.Drill_OutLines(Depth,
                                     DepthLimit,
                                     PIndex      :  LongInt);

  Var
    NextChild       :  LongInt;

    ONomRec         :  ^OutNomType;

    LoopCtrl        :  Boolean;


  Begin
    NextChild := 0;
    LoopCtrl:=BOff;

    With NLOLine do
    Begin
      If (Depth<DepthLimit) then
      Begin
        ONomRec:=Items[PIndex].Data;

        Repeat
          Case LoopCtrl of

            BOff  :  NextChild:=Items[PIndex].GetFirstChild;
            BOn   :  NextChild:=Items[PIndex].GetNextChild(NextChild);

          end; {Case..}

          If (ONomRec<>Nil) then
          With ONomRec^ do
          Begin
            If (NextChild<1) then {* Try and find more for this level *}
            Begin
              If (Not LoopCtrl) and (Not HedTotal) then
              Begin
                Add_OutLines(Depth,DepthLimit,PIndex,OutNomCode,PWrdF,PWK);

                ONomRec:=Items[PIndex].Data;

              end;
            end
            else
              Drill_OutLines(Depth+1,DepthLimit,NextChild);
          end;

          If (Not LoopCtrl) then
            LoopCtrl:=BOn;

        Until (NextChild<1);

      end; {If limit reached..}

    end; {With..}
  end; {Proc..}




  Procedure TStockRec.Delete_OutLines(PIndex      :  LongInt;
                                      DelSelf     :  Boolean);

  Var
    IdxParent,
    OrigChild,
    NextChild       :  LongInt;

    ONomRec         :  ^OutNomType;

    LoopCtrl        :  Boolean;


  Begin
    LoopCtrl:=BOff;
    IdxParent:=-1;


    With NLOLine do
    Begin

      Repeat
        NextChild:=Items[PIndex].GetFirstChild;

        If (NextChild>0) then {* Try and find more for this level *}
        Begin
          ONomRec:=Items[NextChild].Data;

          If (Items[NextChild].HasItems) then {* Delete lower levels *}
            Delete_OutLines(NextChild,BOff);

          Dispose(ONomRec);
          Delete(NextChild);
        end;


      Until (NextChild<1);

      If (DelSelf) then
      Begin
        ONomRec:=Items[PIndex].Data;

        IdxParent:=Items[PIndex].Parent.Index;

        Dispose(ONomRec);
        Delete(PIndex);

        If (IdxParent>0) then
        Begin
          Items[IdxParent].Collapse;
          Items[IdxParent].Expand;
          SelectedItem:=PIndex;
        end;
      end;

    end; {With..}
  end; {Proc..}


Procedure TStockRec.UpDateFromBOM;


Const
  Fnum     =  StockF;
  Keypath  =  StkCodeK;


Var
  KeyS  :  Str255;


Begin

  GLobLocked:=BOff;

  With ExLocal,LStock do
  Begin
    KeyS:=StockCode;


    Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPAth,Fnum,BOn,GlobLocked);

    If (Ok) and (GlobLocked) then
    Begin
      LGetRecAddr(Fnum);

      ShowAsKit:=(YTDCombo.ItemIndex In [1,3]);
      KitOnPurch:=(YTDCombo.ItemIndex In [2,3]);

      KitPrice:=PriceChk.Checked;
      CostPrice:=BStock.CostPrice;
      ROCPrice:=BStock.ROCPrice;
      BOMProdTime:=BStock.BOMProdTime;
      BLineCount:=BStock.BLineCount;

      LastUsed:=Today;
      TimeChange:=TimeNowStr;

      Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      Report_Berror(Fnum,Status);

      {* Explicitly remove multi lock *}

      UnLockMLock(Fnum,LastRecAddr[Fnum]);
    end;

  end; {With..}
end; {Func..}


Procedure TStockRec.AddEditLine(Edit,
                                DelMode  :  Boolean);

Var
  Depth,
  OIndex,
  NewIdx   :  Integer;
  PNode    :  TSBSOutLNode;
  NewFolio :  LongInt;
  ONomRec  :  ^OutNomType;

Begin

  With NLOLine,PassWord do
  If (Not Edit) then
  Begin
    If (ItemCount>0) then
      Repeat

        Delete_OutLines(1,BOn);

      Until (ItemCount<=0);

    NewBomStkCode:=BillMatRec.FullStkCode;
    ShowNewBomIndex:=0;

    Add_OutLines(0,2,0,ExLocal.LStock.StockFolio,PWrdF,PWK);

    NewBomStkCode:='';

    OIndex:=ShowNewBomIndex;

    If (OIndex>0) and (Not DelMode) then
      SelectedItem:=OIndex;
  end
  else
  Begin
    GetSelBOM;
    ONomRec:=Items[SelectedItem].Data;

    With ONomRec^,PassWord.BillMatRec do
    Begin
      StkQty:=QtyUsed;
      StkCost:=QtyCost;
      PRateMode:=FreeIssue;
    end;

    Items[SelectedItem].Text:=FormatLine(ONomRec^,Stock.Desc[1]);
  end;

end;


procedure TStockRec.Display_BomRec(Mode  :  Byte);


Begin


  If (BOMRec=nil) then
  Begin

    BOMRec:=TBOMRec.Create(Self);

  end;

  Try


   With BOMRec do
   Begin

     WindowState:=wsNormal;
     {Show;}


     If (Mode In [1..4]) then
     Begin

       Case Mode of

         1..2,4
               :   If (Not ExLocal.InAddEdit) then
                     EditLine(Self.ExLocal.LStock,(Mode=2),(Mode=4))
                   else
                     Show;
            3  :  If (Not ExLocal.InAddEdit) then
                     DeleteBOMLine(PWrdF,PWK,Self.ExLocal.LStock);
                   else
                     Show;

       end; {Case..}

     end;



   end; {With..}


  except

   BOMRec.Free;


  end;

end;


Function TStockRec.GetSelBOM  :  Boolean;


Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;
  Fnum2    =  StockF;
  Keypath2 =  StkFolioK;

Var
  ONomRec   :  ^OutNomType;
  KeyChk,
  KeyS      :  Str255;


begin
  Result := False;
  With NLOLine do
    If (ItemCount>0) then
    Begin

      ONomRec:=Items[SelectedItem].Data;

      With ONomRec^,PassWord.BillMatRec do
      Begin
        {KeyChk:=Strip('R',[#32,#0],FullMatchKey(BillMatTCode,BillMatSCode,OBOMLink));

        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        Result:=(StatusOk and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));}


        SetDataRecOfs(Fnum,OBOMAddr); {* Retrieve record by address Preserve position *}

        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

        Result:=StatusOk;

        If (Result) then
        Begin
          KeyS:=BillLink;

          Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);
        end;
      end;
    end; {If full list..}
end;


{ ========= Recalculate Cost Price ======= }
{*** This routine has been replicated within RevalueU.TCalcBOMCost ***}

Procedure TStockRec.Re_CalcCostPrice(Ask4P :  Boolean);



  Const
    Fnum      =  PWrdF;
    Keypath   =  PWk;

    Fnum2     =  StockF;
    Keypath2  =  StkFolioK;




  Var

    TmpKPath,
    TmpStat   :  Integer;

    TmpRecAddr
              :  LongInt;

    KeyS,
    KeyChk,
    KeyStk    :  Str255;

    mbRet     :  Word;

    MsgForm   :  TForm;



  Begin

    If (Ask4P) then
      mbRet:=MessageDlg('Please confirm you wish to recalculate the cost price.',mtConfirmation,[mbYes,mbNo],0)
    else
      mbRet:=mrYes;

    If (mbRet=mrYes) then
    With ExLocal do
    Begin
      MsgForm:=CreateMessageDialog('Please Wait...Calculating Cost.',mtInformation,[]);
      MsgForm.Show;
      MsgForm.Update;

      If (FIFO_Mode(LStock.StkValType)=4) then
        LStock.ROCPrice:=0
      else
        LStock.CostPrice:=0;

      LStock.BOMProdTime:=0;


      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOff,BOff);

      KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(LStock.StockFolio)));


      KeyS:=KeyChk;


      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);


      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With LPassword.BillMatRec do
      Begin

        {AssignFromGlobal(Fnum);}

        KeySTk:=BillLink;

        Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyStk);


        Application.ProcessMessages;

        If (StatusOk) then
        Begin

          QCurrency:=LStock.PCurrency;

          QtyCost:=Round_Up(Calc_StkCP(Currency_ConvFT(Stock.CostPrice,Stock.PCurrency,QCurrency,
                                                  UseCoDayRate),Stock.BuyUnit,Stock.CalcPack),Syss.NoCosDec);


          Calc_BillCost(QtyUsed,QtyCost,BOn,LStock,QtyTime);



          Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

        end;

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}


      ResetRec(Fnum);

      TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOn,BOff);

      MsgForm.Free;

      If (Ask4P) then
      Begin
        BStock:=LStock;
        UpDateFromBOM;
        BOMBuildPage;
        OutCost;
      end;
    end; {With..}
  end; {Proc..}


{$ENDIF}





procedure TStockRec.NLOLineExpand(Sender: TObject; Index: Longint);
Var
  Depth   :  LongInt;
  ONomRec :  ^OutNomType;

begin
  {$IFDEf PF_On}

    With (Sender as TSBSOutLineB) do
    Begin
      Depth:=Pred(Items[Index].Level);

      ONomRec:=Items[Index].Data;

      If (ONomRec<>nil) then
      With ONomRec^ do
      Begin
        If (BeenDepth<Depth+2) then
        Begin
          BeenDepth:=Depth+2;
          {BeginUpdate;}
          Drill_OutLines(Depth,Depth+2,Index);
          {EndUpdate;}
        end;
      end;

    If (Items[Index].Parent.Index=0) and (Not Items[Index].HasItems) and (ChkAllowed_In(316)) then
      Edit2Click(Edit2);

    end; {With..}


  {$ENDIF}

end;




procedure TStockRec.NLOLineNeedValue(Sender: TObject);
Var
  ONomRec      :  ^OutNomType;
  DrawIdxCode  :  LongInt;



begin
  {$IFDEf PF_On}

    With Sender as TSBSOutLineB do
    Begin
      DrawIdxCode:=CalcIdx;

      If (DrawIdxCode>0) then
      Begin
        ONomRec:=Items[DrawIdxCode].Data;

        If (ONomRec<>nil) then
        With ONomRec^ do
        Begin
          If (DrawIdxCode=SelectedItem) then
            lblStockCode.Caption:='Stock Code: ' + OutStkCode;


          ColValue:=0;

          Blank(LastDrCr,Sizeof(LastDrCr));

          LastDrCr[2]:=StkQty;

          If PChkAllowed_In(143) then
            LastDrCr[1]:=StkCost*StkQty
          else
            LastDrCr[1]:=0.0;


          With Items[DrawIdxCode] do
            Begin
              ColValue:=LastDrCr[SetCol];
              If (SetCol=1) then
                ColFmt:=GenUnitMask[BOff]
              else
                ColFmt:=GenQtyMask;
            end;

            ColsX:=ColXAry[SetCol];
        end;
      end; {If found equiv index..}
    end;
  {$ENDIF}
end;

procedure TStockRec.NLOLineUpdateNode(Sender: TObject;
  var Node: TSBSOutLNode; Row: Integer);

var
  ONomRec      :  ^OutNomType;

begin
  With Node do
  Begin
    ONomRec:=Data;

    If (ONomRec<>nil) then
    With ONomRec^ do
    Begin
      If (WOPOn) then
      Begin
        CheckBoxChecked:=PRateMode;

      end;

      Case OutNomType of
        StkDescCode  :  UseLeafX:=obLeaf2;
        else            UseLeafX:=obLeaf;
      end; {Case..}

    end;

  end;
end;


procedure TStockRec.FullExBtnClick(Sender: TObject);
begin
  If (Sender=FullExBtn) then
  Begin
    NLOLine.StopDD:=BOn;

    NLOLine.FullExpand;

    NLOLine.StopDD:=BOff;

  end
  else
  Begin
    NLOLine.StopDD:=BOn;

    NLOLine.FullCollapse;

    NLOLine.StopDD:=BOff;

  end;
end;


procedure TStockRec.MIEALClick(Sender: TObject);
begin
  If (Sender is TMenuItem) then
  With NLOLine do
  Begin
    StopDD:=BOn;

    Case TMenuItem(Sender).Tag of
      1  :  Items[SelectedItem].Expand;
      2  :  Items[SelectedItem].FullExpand;
      3  :  FullExpand;
      4  :  Items[SelectedItem].Collapse;
      5  :  FullCollapse;
    end; {case..}

    StopDD:=BOff;

  end;
end;



procedure TStockRec.WUsed2Click(Sender: TObject);

Const
  BOMTit  :  Array[Boff..BOn] of Str20 = ('Contains','Where Used');

begin
  {$IFDEF PF_On}

    With TMenuItem(Sender) do
    Begin
      If (Sender=WUsed2) then
        Build1.Visible:=BOn
      else
        WUsed2.Visible:=BOn;

      MIRec.Enabled:=(WUsed2.Visible and (ExLocal.LStock.StockType=StkBillCode));

      BOMMode:=(Sender=WUsed2);

      Visible:=BOff;
    end; {With..}

    NLDPanel.Caption:=BOMTit[BOMMode];

    BOMBuildPage;

  {$ENDIF}

end;



procedure TStockRec.OptBtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  With TWinControl(Sender) do
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    ListPoint:=ClientToScreen(ListPoint);

  end;



  PopUpMenu3.PopUp(ListPoint.X,ListPoint.Y);
end;




procedure TStockRec.PopupMenu3Popup(Sender: TObject);
begin
  Save1.Checked:=StoreCoord;



  Custom3.Caption:=StkCuBtn1.Caption;
  Custom4.Caption:=StkCuBtn2.Caption;
  // 17/01/2013 PKR ABSEXCH-13449
  // Custom buttons 3..6 now available
  // Note, Custom5..Custom8 are on another menu
  Custom9.Caption  :=StkCuBtn3.Caption;
  Custom10.Caption :=StkCuBtn4.Caption;
  Custom11.Caption :=StkCuBtn5.Caption;
  Custom12.Caption :=StkCuBtn6.Caption;

  Custom3.Visible  :=StkCuBtn1.Visible;
  Custom4.Visible  :=StkCuBtn2.Visible;
  // 17/01/2013 PKR ABSEXCH-13449
  // Custom buttons 3..6 now available
  Custom9.Visible  :=StkCuBtn3.Visible;
  Custom10.Visible :=StkCuBtn4.Visible;
  Custom11.Visible :=StkCuBtn5.Visible;
  Custom12.Visible :=StkCuBtn6.Visible;


  If (ExLocal.LStock.StockType=StkBillCode) then
  With NLOLine do
  Begin
    If (ItemCount>0) then
    With Items[SelectedItem] do
    Begin
      MIRec.Enabled:=((Parent.Index=0) and (WUsed2.Visible));
      If (MIRec.Enabled) then
      Begin
        Edit2.Enabled:=BOn;
        Del2.Enabled:=BOn;
        Check2.Enabled:=BOn;
      end;
    end
    else
    Begin {* List is empty, therefore add should be possible *}
      MIRec.Enabled:=BOn;
      Edit2.Enabled:=BOff;
      Del2.Enabled:=BOff;
      Check2.Enabled:=BOff;
    end;
  end
  else
    MIRec.Enabled:=BOff;

end;


procedure TStockRec.PopupMenu5Popup(Sender: TObject);
begin
  If (Assigned(MULCtrlO2[SSerialPNo])) then
  With MULCtrlO2[SSerialPNo] do
  Begin
    If (ValidLine) then
      With MiscRecs^.SerialRec do
      Begin
        SnoSO1.Visible:=(OutOrdDoc<>'');
        SnoPO1.Visible:=(InOrdDoc<>'');
      end;
  end;
end;


procedure TStockRec.YTDChkClick(Sender: TObject);

  //PR: 29/09/2009 Added functions to prevent kitting options being changed once a Bom has transactions against it.
  function BomHasTransactions : Boolean;
  var
    Res : Integer;
    KeyS, KeyChk : Str255;
    StoreF : FileVar;
    StoreKeyPath : Integer;
    RecAddr : longint;

    function LineHasMovement(IdR : IDetail) : Boolean;
    begin
      //PR: Changed to require password if any transaction lines exist with BOM Code.
      Result := True;
{      Result := (Not ZeroFloat(Idr.Qty)) and
                (
                  (Idr.IdDocHed in StkInSet + StkOutSet + StkAdjSplit) or
                  ((IdR.IdDocHed in [SQU, PQU]) and Syss.QuAllocFlg) or
                  (
                   (IdR.IdDocHed in [SOR, POR]) and
                   (not Syss.UsePick4All or not ZeroFloat(IdR.QtyPick + Idr.QtyDel))
                   ) or
                  (
                   (IdR.IdDocHed in [WOR]) and
                   (not Syss.UseWIss4All or not ZeroFloat(IdR.QtyPick + Idr.QtyDel))
                   )
                );}
    end;
  begin
    Result := False;

    with ExLocal do
    begin
      KeyS := FullStockCode(LStock.StockCode);
      KeyChk := KeyS;

      //Save position in Detail file
      Res := LPresrv_BTPos(IDetailF, StoreKeyPath, StoreF, RecAddr, False, False);

      //Find first line for Stock Code
      Res := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, LId, IdStkK, KeyS);

      while not Result and (Res = 0) and (CheckKey(KeyChk, KeyS, Length(KeyChk), True)) do
      begin
        Result := LineHasMovement(LId);

        if not Result then
          Res := Find_Rec(B_GetNext, F[IDetailF], IDetailF, LId, IdStkK, KeyS);
      end;

      //Restore position in Detail file
      Res := LPresrv_BTPos(IDetailF, StoreKeyPath, StoreF, RecAddr, True, True);

    end;
  end;

  function AuthoriseChange : Boolean;
  var
    iRes : Integer;
  begin
    Result := not BomHasTransactions;
    if not Result then
      Result := AuthoriseBOMKittingChange(ExLocal.LStock.StockCode, YTDCombo.Items[LastYTDII],
                                           YTDCombo.Items[YTDCombo.ItemIndex]);
  end;

begin
  {$IFDEF PF_On}
    With ExLocal,LStock do
      If (StockType=StkBillCode) and ((LastYTDII<>YTDCombo.ItemIndex) or (KitPrice<>PriceChk.Checked)) and (Not InAddEdit) then
      Begin
        if AuthoriseChange then
        begin
          BStock:=LStock;

          LastYTDII:=YTDCombo.ItemIndex;

          UpdateFromBOM;
        end
        else
          YTDCombo.ItemIndex := LastYTDII;
      end;
  {$ENDIF}

end;

procedure TStockRec.Edit2Click(Sender: TObject);
begin
  {$IFDEf PF_On}

    If (GetSelBOM) or ((NLOLine.ItemCount=0) and (TMenuItem(Sender).Tag=1)) then
      Display_BOMRec(TMenuItem(Sender).Tag);

  {$ENDIF}
end;


procedure TStockRec.SRUQFChange(Sender: TObject);
begin
  SetPricing;
end;


procedure TStockRec.Check2Click(Sender: TObject);
begin
  {$IFDEf PF_On}
    Re_CalcCostPrice(BOn);
  {$ENDIF}
end;



{$IFDEF SOP}

  procedure TStockRec.Display_SerRec(Mode  :  Byte);

  Var
    WasNew  :  Boolean;

  Begin
    WasNew:=BOff;


    If (SerRec=nil) then
    Begin
      Set_ModalMode(Self.FormStyle=fsNormal,BOn);

      SerRec:=TStkSerNo.Create(Self);
      WasNew:=BOn;

      Set_ModalMode(BOff,BOff);
    end;

    Try


     With SerRec do
     Begin

       WindowState:=wsNormal;
       {Show;}

       //GS 07/10/2011 ABSEXCH-11622:
       //expanded conditional statement to check for a 4th mode
       If (Mode In [1..4]) then
       Begin
         If (WasNew) then
         With ExLocal do
         Begin
           SerialReq:=Self.SerialReq;
           DocCostP:=Self.DocCostP;

           LInv:=Self.ExLocal.LInv;
           LId:=Self.ExLocal.LId;

           If (FormStyle=fsNormal) then
             Show;
         end;

         Case Mode of

           1..2  :   If (Not ExLocal.InAddEdit) then
                       EditLine(Self.ExLocal.LStock,(Mode=2),BOff)
                     else
                       Show;

              3  :  If (Not ExLocal.InAddEdit) then
                    Begin
                      DeleteBOMLine(MiscF,MIK,Self.ExLocal.LStock);


                    end
                    else
                      Show;
           //GS 07/10/2011 ABSEXCH-11622:
           //added a 4th display serial record mode; View-Only mode
           4:
           If (Not ExLocal.InAddEdit) then
             EditLine(Self.ExLocal.LStock,
                       True, //Display the form in edit mode (shows existing record info)
                       True) //Display the form in view only mode (user cannot change displayed info)
           else
             Show;

         end; {Case..}

       end;



     end; {With..}


    except

     SerRec.Free;


    end;

  end;

  Procedure TStockRec.Set_SerNoUse;

  Var
    UseVirgin  :  Boolean;
    WasUnSold  :  Boolean;

  Begin
    UseVirgin:=(SerialReq<0);

    With ExLocal,MULCtrlO2[SSerialPNo] do
      If (ValidLine) then
      Begin
        GetSelRec(BOff);

        WasUnSold:=Not MiscRecs^.SerialRec.Sold;

        LGetRecAddr(ScanFileNum);

        If (SerRetMode=25) or ((SerRetMode=26) and (LInv.InvDocHed In StkRetSalesSplit)) then
        Begin
          SERN_SetRet(ScanFileNum,Keypath,SerialReq,DocCostP,LInv,LId,SerRetMode);
        end
        else
        Begin
          If (MiscRecs^.SerialRec.BatchRec) then
            Batch_SetUse(ScanFileNum,Keypath,0,SerialReq,DocCostP,LInv,LId,SerRetMode)
          else
            SERN_SetUse(ScanFileNum,Keypath,SerialReq,DocCostP,LInv,LId,SerRetMode);
        end;

        LGetDirectRec(ScanFileNum,KeyPath);

        If (WasUnSold) and (LMiscRecs^.SerialRec.Sold) then
          InitPage
        else
          PageUpDn(0,BOn);

        OutSerialReq;

      end; {With..}



  end;


{$ENDIF}

{ == Function to control b2b allocation of stock == }

Function Check_B2BStatus(IdR    :  Idetail;
                         InvR   :  InvRec;
                         MLCtrl :  MLocRec)  :  Boolean;

Begin
  With MLCtrl.brBinRec do
  {$B-}
    Result:=((IdR.B2BLink=0) or (Not (IdR.IdDocHed in PurchSplit+WOPSplit)) or (Not InvR.PORPickSOR)
    or (((brInOrdDoc=IdR.DocPRef) and (IdR.ABSLineNo=brInOrdLine)) or ((brInDoc=IdR.DocPRef) and (IdR.ABSLineNo=brBuyLine))));
  {$B+}
end;


procedure TStockRec.Display_BinRec(Mode  :  Byte);

Var
  WasNew  :  Boolean;

Begin
  WasNew:=BOff;

  With ExLocal, MLocCtrl^.brBinRec do
  {$B-}
  If (Not BinUseMode) or (BinMoveMode) or (Mode<>2) or (Check_B2BStatus(LId,LInv,MLocCtrl^)) then
  {$B+} {For b2b we must have an identifiable indoc ref or it will not deduct it properly when the SOR is picked}
  Begin

    If (BinRec=nil) then
    Begin
      Set_BinModalMode(Self.FormStyle=fsNormal,BOn);

      BinRec:=TStkBinNo.Create(Self);
      WasNew:=BOn;

      Set_BinModalMode(BOff,BOff);
    end;

    Try


     With BinRec do
     Begin

       WindowState:=wsNormal;
       {Show;}

       StopAutoLoc:=stkStopAutoLoc;

       If (Mode In [1..3]) then
       Begin
         If (WasNew) then
         With ExLocal do
         Begin
           BinReq:=Self.SerialReq;
           DocCostP:=Self.DocCostP;

           LInv:=Self.ExLocal.LInv;
           LId:=Self.ExLocal.LId;

           If (FormStyle=fsNormal) then
             Show;
         end;

         Case Mode of

           1..2  :   If (Not ExLocal.InAddEdit) then
                       EditLine(Self.ExLocal.LStock,(Mode=2),BOff)
                     else
                       Show;

              3  :  If (Not ExLocal.InAddEdit) then
                    Begin
                      DeleteBOMLine(MLocF,MLSecK,Self.ExLocal.LStock);


                    end
                    else
                      Show;

         end; {Case..}

       end;



     end; {With..}


    except

     BinRec.Free;


    end;
  end
  else
  Begin
    ShowMessage('It is not possible to append stock for a back to back transaction.');

  end;
end;


Procedure TStockRec.Set_BinUse;

Var
  UseVirgin  :  Boolean;
  WasChild,
  NewParent,
  WasUnSold  :  Boolean;

Begin
  UseVirgin:=(SerialReq<0);

  With ExLocal,MULCtrlO2[SBinPNo] do
    If (ValidLine) then
    Begin
      If (Not (MLocCtrl^.brBinRec.brHoldFlg In [1,2]))
        or ((MLocCtrl^.brBinRec.brHoldFlg=2) and (((MLocCtrl^.brBinRec.brBatchChild) and (LId.IdDocHed In StkRetPurchSplit)) or (LId.IdDocHed In StkRetSalesSplit)))
      then
      Begin
        GetSelRec(BOff);

        WasUnSold:=Not MLocCtrl^.brBinRec.brSold;
        WasChild:=MLocCtrl^.brBinRec.brBatchChild;
        NewParent:=BOn;

        LGetRecAddr(ScanFileNum);

        Bin_SetUse(ScanFileNum,Keypath,0,SerialReq,DocCostP,LInv,LId,NewParent);

        Status:=LGetDirectRec(ScanFileNum,KeyPath);

        If ((WasUnSold) and (LMLocCtrl^.brBinRec.brSold)) or (Not ValidLine) and (Not NewParent) then
          InitPage
        else
        Begin
          If (WasChild) and (NewParent) then {* We have resurrected a parent so re position it *}
          Begin
            LGetRecAddr(ScanFileNum);
            PageKeys^[0]:=LastRecAddr[MLocF];
            Update_Select(0,BOn);
          end;

          PageUpDn(0,BOn);
        end;

        OutSerialReq;
      end
      else
        ShowMessage('This Bin is currently locked on hold');
    end; {With..}



end;


{$IFDEF PF_On}

  procedure TStockRec.Display_ValRec(Mode  :  Byte);

  Var
    WasNew  :  Boolean;

  Begin
    WasNew:=BOff;


    If (ValRec=nil) then
    Begin

      ValRec:=TStkValEdit.Create(Self);
      WasNew:=BOn;

    end;

    Try


     With ValRec do
     Begin

       WindowState:=wsNormal;
       {Show;}


       If (Mode In [1..3]) then
       Begin

         Case Mode of

           1..2  :   If (Not ExLocal.InAddEdit) then
                       EditLine(Self.ExLocal.LStock,(Mode=2),BOff)
                     else
                       Show;
              3  :  If (Not ExLocal.InAddEdit) then
                       DeleteBOMLine(MiscF,MIK,Self.ExLocal.LStock);
                     else
                       Show;

         end; {Case..}

       end;



     end; {With..}


    except

     ValRec.Free;


    end;

  end;


  procedure TStockRec.Display_QtyRec(Mode  :  Byte);

  Var
    WasNew  :  Boolean;

  Begin
    WasNew:=BOff;


    If (QtyRec=nil) then
    Begin
      SetQBMode(1+Ord(CQtyBMode));

      QtyRec:=TStkQtyRec.Create(Self);
      WasNew:=BOn;

    end;

    Try


     With QtyRec do
     Begin

       WindowState:=wsNormal;
       {Show;}

       StkKeyRef:=MULCtrlO2[SQtyBPNo].KeyRef;

       //PR: 08/02/2012 ABSEXCH-9795
       ParentDiscountRec := CustDiscountRec;

       If (Mode In [1..3]) then
       Begin

         Case Mode of

           1..2  :   If (Not ExLocal.InAddEdit) then
                       EditLine(Self.ExLocal.LStock,Self.ExLocal.LCust,(Mode=2),BOff)
                     else
                       Show;
              3  :  If (Not ExLocal.InAddEdit) then
                       DeleteBOMLine(MiscF,MIK,Self.ExLocal.LStock);
                     else
                       Show;

         end; {Case..}

       end;



     end; {With..}


    except

     QtyRec.Free;


    end;

  end;

{$ENDIF}

procedure TStockRec.UCP1BtnClick(Sender: TObject);
begin
  {$IFDEF SOP}
    If (Current_Page=sSerialPNo) then
      Set_SerNoUse
    else
  {$ENDIF}
      Set_BinUse;
end;

procedure TStockRec.PopupMenu8Popup(Sender: TObject);

Var
  GenStr  :  Str50;

begin
  {$IFDEF RET}
   If (Assigned(MULCtrlO2[SSerialPNo])) then
   With MULCtrlO2[SSerialPNo] do
   Begin
     If (ValidLine) then
       With MiscRecs^.SerialRec do
       Begin

         ReadOnlyView1.Visible := True;
         RetOD1.Visible:=BoChkAllowed_In((Trim(OutDoc)<>'') and ((GetDocType(OutDoc) In StkRetGenSplit)) and (Not ReturnSNo),573);
         RetID1.Visible:=BoChkAllowed_In((Trim(InDoc)<>'') and ((GetDocType(InDoc) In StkRetGenSplit)) and (Not Sold) and (Not BatchChild),512);

         GenStr:=Trim(InDoc)+' is not';

         If (Trim(OutDoc)<>'') then
           GenStr:='Neither '+Trim(InDoc)+' nor '+OutDoc+' is';

         If (Not RetOD1.Visible) and (RetId1.Visible) then
         Begin
           RetID1.Visible:=BOff;

           RetId1Click(RetId1);
         end
         else
           If (Not RetID1.Visible) and (RetOd1.Visible) then
           Begin
             RetOD1.Visible:=BOff;

             RetId1Click(RetOd1);
           end
           else
             If ((Not RetOD1.Visible) and (ChkAllowed_In(573))) and ((Not RetId1.Visible) and (ChkAllowed_In(512))) then
               CustomDlg(Application.MainForm,'Please Note','Invalid basis for a Return',
                                 GenStr+' a valid transaction from which to base a Return upon.'+#13+#13+
                                 'A Return can only be based on an account code based transaction where the Serial/Batch item is '+
                                 'unsold in the case of a Purchase Return, or sold/on another Return in the case of a Sales Return.',
                                 mtInformation,
                                 [mbOK]);

       end;
   end;
  {$ENDIF}

end;


{$IFDEF RET}
  procedure TStockRec.Create_Return;

  Var
    RETRef  :  Str10;
    mbRet   :  Word;

  Begin

    {$B-}
    If (CheckRecExsists(Strip('R',[#0],FullNomKey(Id.FolioRef)),InvF,InvFolioK)) and (Inv.InvDocHed In StkRetGenSplit-[POR,SOR]) then
    {$B+}
    Begin
      If (CheckExsiting_RET(Inv,Id,RETRef,BOff)) then
      Begin
        mbRet:=CustomDlg(Application.MainForm,'Please note','Return Exists',
                                'Return '+RETRef+' already exists for this '+DocNames[Inv.InvDocHed]+#13+#13+
                                'Please confirm you want to create another Return for this transaction.',mtConfirmation,[mbOk,mbCancel]);
      end
      else
        mbRet:=mrOk;

      If (mbRet=mrOk) then
      Begin
        Gen_RetDocWiz(Inv,Id,10,Application.MainForm);
      end;

    end;



  end;

{$ENDIF}


procedure TStockRec.RetCP1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  {$IFDEF RET}
    If (Current_Page=SLedgerPNo) then
    Begin
      If (Assigned(MULCtrlO[SLedgerPNo])) then
      With MULCtrlO[SLedgerPNo] do
      Begin
        If (ValidLine) then
          Create_Return;
      end;
    end
    else
      If (Assigned(MULCtrlO2[SSerialPNo])) then
      With MULCtrlO2[SSerialPNo] do
      If (ValidLine) then
      Begin
        GetCursorPos(ListPoint);
        ScreenToClient(ListPoint);

        PopupMenu8.PopUp(ListPoint.X,ListPoint.Y);
      end;

  {$ENDIF}
end;


procedure TStockRec.RetId1Click(Sender: TObject);
Begin
  {$IFDEF RET}
    If (Assigned(MULCtrlO2[SSerialPNo])) then
    With MULCtrlO2[SSerialPNo] do
    Begin
      If (ValidLine) then
        Gen_RetSerWiz(MiscRecs^,(Sender=RetOD1),Self);
    end;
  {$ENDIF}
end;


procedure TStockRec.SN1Click(Sender: TObject);
begin
  {$IFDEF SOP}
    MULCtrlO2[SSerialPNo].GetMiniSERN(TMenuItem(Sender).Tag);
  {$ENDIF}
end;

procedure TStockRec.ID1Click(Sender: TObject);
begin
  MULCtrlO2[Current_Page].Display_StkDoc(TMenuItem(Sender).Tag);
end;

procedure TStockRec.StockRecord1Click(Sender: TObject);
begin
  MULCtrlO2[Current_Page].Display_StkRec(1);
end;


procedure TStockRec.SNoPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  BarPos :  Integer;
  PanRSized
         :  Boolean;



begin

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    BarPos:=Current_BarPos(Current_Page);

    If (PanRsized) then
      MULCtrlO2[Current_Page].ResizeAllCols(MULCtrlO2[Current_Page].VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO2[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO2[Current_Page].VisiList.MovingLab or PanRSized);
  end;

end;



procedure TStockRec.SNoLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      If (MULCtrlO2[Current_Page]<>nil) then
        MULCtrlO2[Current_Page].VisiList.PrimeMove(Sender);
      NeedCUpdate:=BOn;
    end
    else
      If (Button=mbRight) then
      Begin
        ListPoint:=ClientToScreen(Point(X,Y));

        ShowRightMeny(ListPoint.X,ListPoint.Y,0);
      end;

  end;
end;




procedure TStockRec.SNoLabMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO2[Current_Page]<>nil) then
    Begin
      MULCtrlO2[Current_Page].VisiList.MoveLabel(X,Y);
      NeedCUpdate:=MULCtrlO2[Current_Page].VisiList.MovingLab;
    end;
  end;

end;

procedure TStockRec.CFrom1Click(Sender: TObject);
begin
  With Exlocal.LCust do
    MULCtrlO2[Current_Page].Copy_QBStock(CustCode,CustSupp, CustDiscountRec.QtyBreakFolio);
end;

procedure TStockRec.CTo1Click(Sender: TObject);
begin
  MULCtrlO2[Current_Page].QB_TreeUpdate;
end;

procedure TStockRec.ChkCP1BtnClick(Sender: TObject);
Var
  POk  :  Boolean;
  KeyS :  Str255;

begin
  POk:=BOn;

  Case Current_Page of
    SMainPNo,SDefaultPNo,SDef2PNo,SWOPPNo,SRetPNo,SLedgerPNo
       :  With ExLocal do
          Begin
            AssignToGlobal(StockF);

            {$IFDEF POST}

              Check_StockLevels(BOff,Self,StockF,SKeypath);
              // CJS 2011-10-17: 27 - v6.9 - ABSEXCH-11565 - Check All Stock
              //                 clears Posted value.
              //
              //                 Call to OutStock added to display any
              //                 recalculated values.
              OutStock;


            {$ENDIF}

          end;

    SQtyBPNo
       :  With ExLocal,LCust,LStock,MULCtrlO2[SQtyBPNo] do
          Begin
            {$IFDEF PF_On}

              //PR: 09/02/2012 Amended to use new Qty Breaks file ABSEXCH-9795
              Case DisplayMode of
                2  :  KeyS := QtyBreakStartKey('', StockFolio);
                3  :  KeyS := QtyBreakStartKey(CustCode, StockFolio);
              end; {Case..}

              Check_QBDisc(CustSupp,KeyS,QtyBreakF,qbAcCodeIdx,LStock,POk,Pred(DisplayMode));
            {$ENDIF}
          end;
    SBinPNo
      :   Begin

           If (EmptyKey(SRecLocFilt,LocKeyLen)) and (Syss.UseMLoc) and (Not fSortLocBin) then
             FiltLoc(Sender,1)
           else
           Begin
             fSortLocBin:=Not fSortLocBin;

             RefreshValList(BOn,BOff);

           end;
         end;
    {$IFDEF SOP}
    SMultiBuyPNo: begin
                    mbdFrame.CheckDiscounts;
                  end;
    {$ENDIF}


  end; {Case..}
end;


procedure TStockRec.PrnCP1BtnClick(Sender: TObject);
var
  //PR: 20/05/2014 ABSEXCH-2763
  Ok2Print : Boolean;
begin
  Ok2Print := True;
  {$IFDEF FRM}
    With ExLocal do
    Case Current_Page of

      SMainPNo..SRetPNo 
           :  Begin
                PrintStockRecord(ExLocal,BOn);
              end;

      SLedgerPNo
           :  With MulCtrlO[Current_Page] do
              If ValidLine then
              Begin
                GetSelRec(BOff);

                If (CheckRecExsists(Strip('R',[#0],FullNomKey(Id.FolioRef)),InvF,InvFolioK)) then
                Begin
                  AssignFromGlobal(InvF);
                  //PR: 20/05/2014 ABSEXCH-2763 Add check for hook point 2000/151 (Print Transaction)
                  {$IFDEF CU}
                    If (EnableCustBtns(2000,151)) then
                      Ok2Print := ExecuteCustBtn(2000,151,ExLocal);
                  {$ENDIF}
                    if Ok2Print then
                      With LInv do
                        Control_DefProcess(DEFDEFMode[InvDocHed],
                                           IdetailF,IdFolioK,
                                           FullNomKey(FolioNum),ExLocal,BOn);
                end;
              end;


    end; {Case..}

  {$ENDIF}
end;


procedure TStockRec.SRD1FKeyPress(Sender: TObject; var Key: Char);
begin
  If (Sender is Text8pt) then
    With Text8pt(Sender) do
    Begin
      If (SelStart>=MaxLength) then {* Auto wrap around *}
        SetNextLine(Self,Sender,SRD6F,Parent,Key);
    end;

end;

procedure TStockRec.SRLocFExit(Sender: TObject);
Var
  FoundCode  :  Str10;

  FoundOk,
  AltMod     :  Boolean;

begin
  {$IFDEF SOP}
    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (AltMod) and  (FoundCode<>'') and (OrigValue<>Text) and (ExLocal.InAddEdit) and (Syss.UseMLoc) and (ActiveControl<>CanCP1Btn) then
      Begin

        If (Not InPageChanging) then
        Begin

          StillEdit:=BOn;

          StopPageChange:=BOn;

          FoundOk:=(GetMLoc(Self,FoundCode,FoundCode,'',0));

          If (FoundOk) then
          Begin

            StopPageChange:=BOff;

            StillEdit:=BOff;

            Text:=FoundCode;

            {* Weird bug when calling up a list caused the Enter/Exit methods
                 of the next field not to be called. This fix sets the focus to the next field, and then
                 sends a false move to previous control message ... *}

            {FieldNextFix(Self.Handle,ActiveControl,Sender);}

          end
          else
          Begin

            ChangePage(SDefaultPNo);

            StopPageChange:=BOn;

            SetFocus;
          end; {If not found..}
        end
        else
          Text:=OrigValue;
      end
      else
        StopPageChange:=BOff;
    end; {with..}
  {$ENDIF}
end;


procedure TStockRec.SRBLFEnter(Sender: TObject);
begin
  With SRBLF do
  Begin

    If (ExLocal.InAddEdit) and (Not ReadOnly) then
    Begin
      If (SRMBF.Checked) and (Syss.BinMask<>'') then
        EditMask:=Syss.BinMask+';1;_'
      else
        EditMask:='';
    end;
  end;

end;

procedure TStockRec.SRBLFMaskError(Sender: TObject);
begin
  if (ActiveControl <> CanCp1Btn) then
    ShowMessage('That Bin Code does not match the Bin Code mask. Please re-enter');

end;

procedure TStockRec.SRBLFSetFocusBack(Sender: TObject;
  var bSetFocus: Boolean);
begin
  bSetFocus:=(ActiveControl <> CanCp1Btn);
end;

procedure TStockRec.UD1FEntHookEvent(Sender: TObject);
Var
  CUUDEvent  :  Byte;
  Result     :  LongInt;

begin
  CUUDEvent := 0;
  {$IFDEF CU}
    If (Sender is Text8Pt)then
      With (Sender as Text8pt) do
      Begin
        If (Not ReadOnly) then
        Begin
          If (Sender=UD1F) then
          Begin
            ExLocal.LStock.StkUser1:=Text;
            CUUDEvent:=1;
          end
          else
            If (Sender=UD2F) then
            Begin
              ExLocal.LStock.StkUser2:=Text;
              CUUDEvent:=2;
            end
            else
              If (Sender=UD3F) then
              Begin
                ExLocal.LStock.StkUser3:=Text;
                CUUDEvent:=3;
              end
              else
                If (Sender=UD4F) then
                Begin
                  ExLocal.LStock.StkUser4:=Text;
                  CUUDEvent:=4;
                end
                else
                //GS 25/10/2011 ABSEXCH-11706: updated to support 10 UDEFs
                If (Sender=UD5F) then
                Begin
                  ExLocal.LStock.StkUser5:=Text;
                  CUUDEvent:= (211 - 30);
                end
                else
                  If (Sender=UD6F) then
                  Begin
                    ExLocal.LStock.StkUser6:=Text;
                    CUUDEvent:=(212 - 30);
                  end
                  else
                    If (Sender=UD7F) then
                    Begin
                      ExLocal.LStock.StkUser7:=Text;
                      CUUDEvent:=(213 - 30);
                    end
                    else
                      If (Sender=UD8F) then
                      Begin
                        ExLocal.LStock.StkUser8:=Text;
                        CUUDEvent:=(214 - 30);
                      end
                      else
                      If (Sender=UD9F) then
                      Begin
                        ExLocal.LStock.StkUser9:=Text;
                        CUUDEvent:=(215 - 30);
                      end
                      else
                        If (Sender=UD10F) then
                        Begin
                          ExLocal.LStock.StkUser10:=Text;
                          CUUDEvent:=(216 - 30);
                        end;

          Result:=IntExitHook(3000,30+CUUDEvent,-1,ExLocal);

          If (Result=0) then
            SetFocus
          else
          With ExLocal do
          If (Result=1) then
          Begin
            Case CUUDEvent of
              1  :  Text:=LStock.StkUser1;
              2  :  Text:=LStock.StkUser2;
              3  :  Text:=LStock.StkUser3;
              4  :  Text:=LStock.StkUser4;
              //GS 25/10/2011 ABSEXCH-11706: updated to support 10 UDEFs
              (211 - 30) : Text:=LStock.StkUser5;
              (212 - 30) : Text:=LStock.StkUser6;
              (213 - 30) : Text:=LStock.StkUser7;
              (214 - 30) : Text:=LStock.StkUser8;
              (215 - 30) : Text:=LStock.StkUser9;
              (216 - 30) : Text:=LStock.StkUser10;
            end; {Case..}
          end;
        end;
     end; {With..}

  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;


procedure TStockRec.UD1FExit(Sender: TObject);
begin
    If (Sender is Text8Pt)  and (ActiveControl<>CanCP1Btn) then
    Text8pt(Sender).ExecuteHookMsg;
end;



procedure TStockRec.LnkCp1BtnClick(Sender: TObject);
{$IFDEF Ltr}
Var
  NKey    : String[4];
  OldCust : ^CustRec;
  StkCode : String[20];
  StkFol  : LongInt;
  StkAcc  : String[10];
  StkRec  : StockRecPtr;
{$ENDIF}
begin
  If (Current_Page = SBinPNo) then
    Move_BinMode
  else
  Begin
  {$IFDEF Ltr}
    { Create form if not already created }
    If Not Assigned (LetterForm) Then Begin
      { Create letters form }
      LetterForm := TLettersList.Create (Self);
    End; { If }

    Try
      { mark form as active }
      LetterActive := BOn;

      { Display form }
      LetterForm.WindowState := wsNormal;
      LetterForm.Show;

      If (Current_Page = SBuildPNo) And GetSelBOM Then Begin
        { Bill Of Materials }
        StkCode := Stock.StockCode;
        StkFol  := Stock.StockFolio;
        StkAcc  := Stock.Supplier;
        StkRec  := @Stock;
      End { If }
      Else Begin
        { Stock Item }
        StkCode := ExLocal.LStock.StockCode;
        StkFol  := ExLocal.LStock.StockFolio;
        StkAcc  := ExLocal.LStock.Supplier;
        StkRec  := @ExLocal.LStock;
      End; { Else }

      { Get Supplier }
      New (OldCust);
      OldCust^ := Cust;
      NKey := FullNomKey(StkFol);
      If CheckRecExsists(FullCustCode(StkAcc), CustF, CustCodeK) Then
        LetterForm.LoadLettersFor (NKey,                       { Index Key }
                                   StkCode,                    { Caption }
                                   CodeToFName (StkCode),      { FName }
                                   LetterStkCode,
                                   @Cust, StkRec, Nil, Nil, Nil)
      Else
        LetterForm.LoadLettersFor (NKey,                       { Index Key }
                                   StkCode,                    { Caption }
                                   CodeToFName (StkCode),      { FName }
                                   LetterStkCode,
                                   Nil, StkRec, Nil, Nil, Nil);
      Cust := OldCust^;
      Dispose(OldCust);
    Except
     LetterActive := BOff;
     LetterForm.Free;
    End;
  {$ENDIF}
  end;
end;


{$IFDEF SOP}

  procedure TStockRec.Link2AltC(ScanMode  :  Boolean);

  Var
    WasNew  :  Boolean;
    CMode   :  Byte;

  begin
    WasNew:=BOff;

    Begin
      CMode:=1;

      If (Not Assigned(AltCList)) then
      With ExLocal do
      Begin

        Set_ACFormMode(CMode,LStock.StockFolio,'');

        AltCList:=TAltCList.Create(Self);
        WasNew:=BOn;
      end;


      With AltCList do
      Begin
        try
          ExLocal.LStock:=Self.ExLocal.LStock;

          If (Not WasNew) then
          Begin
            RecFolio:=ExLocal.LStock.StockFolio;
            RecMode:=CMode;
            RecSupp:='';

            If (WindowState=wsMinimized) then
              WindowState:=wsNormal;

            RefreshList(BOn,BOn);

            If (Not ScanMode) then
              Show;
          end;

          SetCaption;
        except
          AltCList.Free;
          AltCList:=nil;
        end; {try..}
      end; {With..}
    end;
  end;
{$ENDIF}



procedure TStockRec.FiltLoc(Sender  :  TObject;
                            Mode    :  Byte);

Var
  InpOk,
  FoundOk  :  Boolean;


  OCode,
  SCode    :  String;

Begin

  SCode:=SRecLocFilt;
  OCode:=SCode;
  FoundOK := False;
  Repeat

    InpOk:=InputQuery('Location Filter','Enter the Location Code you wish to filter by.',SCode);

    {$IFDEF SOP}
      If (InpOk) then
        If (Not EmptyKey(SCode,LocKeyLen)) then
          FoundOk:=GetMLoc(Self,SCode,SRecLocFilt,'',0)
        else
        Begin
          SRecLocfilt:='';
          FoundOk:=BOn;
        end;
    {$ENDIF}

  Until (FoundOk) or (Not InpOk);

  If (FoundOk) and (SCode<>OCode) and (Assigned(MULCtrlO2[Current_Page])) and (Assigned(Sender)) then
  Begin
    If (Mode=1) or ((Scode='') and fSortLocBin and Syss.UseMLoc) then
      fSortLocBin:=Not fSortLocBin;

    RefreshValList(BOn,BOff);

    SetCaption;
  end;


end;


procedure TStockRec.Altdb1BtnClick(Sender: TObject);
begin
  {$IFDEF SOP}
    Case Current_Page of

        SSerialPNo  :  With ExLocal do
                       Begin
                         Start_SNRange(0,LStock.StockFolio,DocCostP,SerUseMode,ExLocal,@SerialReq,Self);

                       end;

        SBinPNo     :   FiltLoc(Sender,0);

        else           Link2AltC(BOff);

    end; {Case..}
  {$ENDIF}

end;


procedure TStockRec.StkCuBtn1Click(Sender: TObject);

//Const
//  CB1EID  :  Array[0..12] of Byte = (80,81,88,87,82,82,83,101,84,85,86,89,89);

Var
  PageNo  :  Integer;
  // 23/01/2013 PKR ABSEXCH-13449
  eventID : Integer;
  customButtonNumber : integer;
begin
  PageNo:=Current_Page;

  {$IFDEF CU}
    With ExLocal do
    Begin
      Begin
        If (PageNo=SBuildPNo) then
        Begin
          If (LStock.StockFolio<>BOMFolio) then
          Begin
            If Not LGetMainRecPosKey(StockF,StkFolioK,FullNomKey(BOMFolio)) then
              LResetRec(StockF);
          end
        end
        else
          If (PageNo=SSerialPNo) or (PageNo=SBinPNo) then
          Begin
            If ((SerUseMode) and (Not InSerFind)) or ((BinUseMode) and (Not InBinFind)) then
              LCtrlDbl:=SerialReq;

          end;

        If (LCust.CustCode<>BStock.Supplier) then
          LGetMainRecPos(CustF,BStock.Supplier);

        // 17/01/2013 PKR ABSEXCH-13449
        // The button or menu item Tag property is set to the button number.
        customButtonNumber := -1;
        if Sender is TSBSButton then
          customButtonNumber := (Sender as TSBSButton).Tag;
        if Sender is TMenuItem then
          customButtonNumber := (Sender as TMenuItem).Tag;
            
        custBtnHandler.CustomButtonClick(formPurpose,
                                         PageNo,
                                         recordState,
                                         customButtonNumber,
                                         ExLocal);
          
{
        ExecuteCustBtn(3000,((CB1EID[PageNo])*Ord((Sender=StkCuBtn1) or (Sender=Custom1) or (Sender=Custom3)))+
                      ((CB1EID[PageNo]+10)*Ord((Sender=StkCuBtn2) or (Sender=Custom2) or (Sender=Custom4))), ExLocal);
}
        If (PageNo=SSerialPNo) or (PageNo=SBinPNo)  then
        Begin
          If ((SerUseMode) and (Not InSerFind)) or ((BinUseMode) and (Not InBinFind))  then
          Begin
            SerialReq:=LCtrlDbl;

            OutSerialReq;
          end;
        end;


      end;
    end; {With..}
  {$ENDIF}
end;




procedure TStockRec.DefUdFMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Sender Is TSBSUpDown) then
    With Sender as TSBSUpDown do
    Begin
      If Associate is TCurrencyEdit then
        With Associate as TCurrencyEdit do
          Value:=StrToInt(Text);

    end;
end;

procedure TStockRec.OutPrices;

Begin
  With SRSP1F,ExLocal.LStock do
  Begin
    {* Force a change through so symbol gets updated *}
    {$IFDEF MC_On}
      If (CurrencySymb<>PSymb(SaleBands[1].Currency)) and (SaleBands[1].SalesPrice=0.0) and (Value=0.0) then
        Value:=0.01;
    {$ENDIF}

    CurrencySymb:=PSymb(SaleBands[1].Currency);



    Value:=SaleBands[1].SalesPrice;



  end;

  SRGP1.Value:=CalcGP(1);
end;



procedure TStockRec.EditSPBtnClick(Sender: TObject);

Var
  WasNew  :  Boolean;

begin
  //HV 17/05/2016 2016-R2 ABSEXCH-15302: Access rights - "access sales prices" can be overridden by double clicking into the sales price field on a stock record
  if Not PChkAllowed_In(474) then Exit;

  If (Not Assigned(Prices)) then
  Begin
    Prices:=TPrices.Create(Self);
    WasNew:=BOn;
  end
  else
    WasNew:=BOff;

  ExLocal.AssignToGlobal(StockF);

  try
    With Self.ExLocal, Prices do
      If (WasNew) then
        PrimeForm((LViewOnly or Not PChkAllowed_In(312) or Not InAddEdit), SRecLocFilt, SRCPF.Color, SRCPF.Font)
      else
        RefreshForm((LViewOnly or Not PChkAllowed_In(312) or Not InAddEdit),1);

  except
      Prices.Free;
      Prices:=nil;

  end; {try..}

end;

procedure TStockRec.SRSP1FExit(Sender: TObject);
begin
  If (Sender is TCurrencyEdit) and (ActiveControl<>CanCP1Btn) then
  With (Sender as TCurrencyEdit),ExLocal do
  Begin

    If (InAddEdit) and (EditSPBtn.Enabled) then
    Begin
      SendMessage(Self.Handle,WM_CustGetRec,212,0);
    end;

  end; {With..}

end;




procedure TStockRec.DelDisc1Click(Sender: TObject);
begin
   {$IFDEF SOP}
    if (Sender is TMenuItem) and (Current_Page = SMultiBuyPNo) and Assigned(MULCtrlO[Current_Page]) then
    begin
      MULCtrlO[Current_Page].GetSelRec(BOff);
      mbdFrame.DeleteDiscount(TMenuITem(Sender).Tag = 1);
    end
    else
   {$ENDIF}
    {$IFDEF STK}
    If (Sender is TMenuItem) and (Assigned(MULCtrlO2[Current_Page])) then
    With TMenuITem(Sender) do
    Begin
      Case Tag of
        0  :  With MULCtrlO2[Current_Page] do
              If (ValidLine) then
              Begin
                GetSelRec(BOff);

                Display_QtyRec(3)
              end;

        1  :  Del_Discount(0,ExLocal.LStock.StockCode,Self);
      end; {Case..}
    end;

  {$ENDIF}

end;




procedure TStockRec.SRRRCFExit(Sender: TObject);
begin
  Form2Stock;
  With ExLocal,LStock do
  Begin
    SRRRCF.Text:=PPR_PamountStr(ReStockPcnt,ReStockPChr);


  end; {With..}
end;

procedure TStockRec.ShowSortViewDlg;
var
  Dlg: TSortViewOptionsFrm;
  FuncRes: Integer;
begin
  Dlg := TSortViewOptionsFrm.Create(nil);
  Dlg.SortView := MULCtrlO[Current_Page].SortView;
  try
    if (Dlg.ShowModal = mrOk) then
    begin
      MulCtrlO[Current_Page].SortView.Enabled := True;
      RefreshList(True, False);
      if MulCtrlO[Current_Page].SortView.Sorts[1].svsAscending then
        PageControl1.Pages[Current_Page].ImageIndex := 1
      else
        PageControl1.Pages[Current_Page].ImageIndex := 2;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TStockRec.RefreshView1Click(Sender: TObject);
var
  FuncRes: Integer;
begin
  FuncRes := MulCtrlO[Current_Page].SortView.Refresh;
  if (FuncRes = 0) then
  begin
    MulCtrlO[Current_Page].SortView.Enabled := True;
    MulCtrlO[Current_Page].StartList(SortTempF, STFieldK, FullNomKey(MulCtrlO[Current_Page].SortView.ListID), '', '', 0, BOff);
    if MulCtrlO[Current_Page].SortView.Sorts[1].svsAscending then
      PageControl1.Pages[Current_Page].ImageIndex := 1
    else
      PageControl1.Pages[Current_Page].ImageIndex := 2;
  end
  else
    ShowMessage('Failed to refresh Sort View, error #' + IntToStr(FuncRes));
end;

procedure TStockRec.CloseView1Click(Sender: TObject);
var
  LKeyStart :  Str255;
  LKeypath,
  LKeyLen   :  Integer;
begin
  MulCtrlO[Current_Page].SortView.CloseView;
  MulCtrlO[Current_Page].SortView.Enabled := False;
  with MulCtrlO[Current_Page] do
  begin
{
    LKeyPath := InvCustLedgK;
    LKeyStart := FullCustType(ExLocal.LCust.CustCode, ExLocal.LCust.CustSupp)+Chr(Ord(ViewNorm));
    LKeyLen:=Length(LKeyStart)-Ord(Not ViewNorm);
    StartList(InvF,LKeypath,LKeyStart,'','',LKeyLen,False);
}
    { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
    MulCtrlO[Current_Page].UseDefaultSortView := False;

    RefreshList(True, False);
  end;
  PageControl1.Pages[Current_Page].ImageIndex := -1;
end;

procedure TStockRec.SortViewOptions1Click(Sender: TObject);
begin
  ShowSortViewDlg;
end;

procedure TStockRec.SortViewBtnClick(Sender: TObject);
var
  Dlg: TSortViewOptionsFrm;
  FuncRes: Integer;
  MenuPoint: TPoint;
begin
  if (not MulCtrlO[Current_Page].SortView.IsBuildingFile) then
  begin
    if (Sender is TButton) and MulCtrlO[Current_Page].SortView.Enabled then
    begin
      GetCursorPos(MenuPoint);
      with MenuPoint do
      begin
        X := X - 50;
        Y := Y - 15;
      end;
      SortViewPopupMenu.PopUp(MenuPoint.X, MenuPoint.Y);
    end
    else
      ShowSortViewDlg;
  end;
end;

procedure TStockRec.mbdFramescrMBDListDblClick(Sender: TObject);
begin
  with mbdFrame.scrMBDList do
    ShowMessage('Left = ' + IntToStr(Left) + '; Top = ' + IntToStr(Top) + '; Width = ' + IntTostr(Width) + '; Height = ' + IntToStr(Height));
end;

// -----------------------------------------------------------------------------
// CJS: 14/12/2010 - Amendments for new Window Settings system
// -----------------------------------------------------------------------------

procedure TStockRec.LoadLedgerListSettings(ListNo: Integer);
begin
  if Assigned(FSettings) and Assigned(MULCtrlO[ListNo]) and not FSettings.UseDefaults then
    FSettings.SettingsToParent(MULCtrlO[ListNo]);
end;

// -----------------------------------------------------------------------------

procedure TStockRec.SaveLedgerListSettings(ListNo: Integer);
begin
  if Assigned(MULCtrlO[ListNo]) then
    FSettings.ParentToSettings(MULCtrlO[ListNo], MULCtrlO[ListNo]);
end;

// -----------------------------------------------------------------------------

procedure TStockRec.LoadSerialListSettings(ListNo: Integer);
begin
  if Assigned(FSettings) and Assigned(MULCtrlO2[ListNo]) and not FSettings.UseDefaults then
    FSettings.SettingsToParent(MULCtrlO2[ListNo]);
end;

// -----------------------------------------------------------------------------

procedure TStockRec.SaveSerialListSettings(ListNo: Integer);
begin
  if Assigned(MULCtrlO2[ListNo]) then
    FSettings.ParentToSettings(MULCtrlO2[ListNo], MULCtrlO2[ListNo]);
end;

// -----------------------------------------------------------------------------

procedure TStockRec.LoadWindowSettings;
begin
  if Assigned(FSettings) then
  begin
    FSettings.LoadSettings;
    if not FSettings.UseDefaults then
    begin
      FSettings.SettingsToWindow(self);
      FSettings.SettingsToParent(self);
      FSettings.SettingsToParent(BOMPage);
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockRec.SaveWindowSettings;
var
  i: Integer;
begin
  if Assigned(FSettings) and NeedCUpdate then
  begin
    for i := Low(MULCtrlO) to High(MULCtrlO) do
      SaveLedgerListSettings(i);
    for i := Low(MULCtrlO2) to High(MULCtrlO2) do
      SaveSerialListSettings(i);
    FSettings.WindowToSettings(self);
    FSettings.ParentToSettings(self, SRCF);
    FSettings.ParentToSettings(BOMPage, NLOLine);
    {
      CJS 28/03/2011 - ABSEXCH-10683
      Allow the Notes columns to be stored as well.
    }
    if Assigned(NotesCtrl) then
      FSettings.ParentToSettings(NotesCtrl.MULCtrlO, NotesCtrl.MULCtrlO); //Notes
    FSettings.SaveSettings(StoreCoord);
  end;
  FSettings := nil;
end;

// -----------------------------------------------------------------------------

procedure TStockRec.EditLedgerWindowSettings(ListNo: Integer);
begin
  if Assigned(FSettings) and Assigned(MULCtrlO[ListNo]) then
    if FSettings.Edit(MULCtrlO[ListNo], MULCtrlO[ListNo]) = mrOK then
    Begin
      // CA 23/07/2012 ABSEXCH-12952 - Setting the TreeColor
      NLOLine.TreeColor   := NLOLine.Font.Color;
      NeedCUpdate := True;
    End;
end;

// -----------------------------------------------------------------------------

procedure TStockRec.EditSerialWindowSettings(ListNo: Integer);
begin
  if Assigned(FSettings) and Assigned(MULCtrlO2[ListNo]) then
    if FSettings.Edit(MULCtrlO2[ListNo], MULCtrlO2[ListNo]) = mrOK then
    Begin
      // CA 23/07/2012 ABSEXCH-12952 - Setting the TreeColor
      NLOLine.TreeColor   := NLOLine.Font.Color;
      NeedCUpdate := True;
    End;
end;

// -----------------------------------------------------------------------------

procedure TStockRec.SRASSMFChange(Sender: TObject);
var
  CurrentValue: Integer;
begin
  if not (csLoading in SRASSMF.ComponentState) then
  begin
    CurrentValue := Trunc(SRASSMF.Value);
    if (CurrentValue > SBSUpDown2.Max) then
      SRASSMF.Value := SBSUpDown2.Max
    else if (CurrentValue < SBSUpDown2.Min) then
      SRASSMF.Value := SBSUpDown2.Min;
  end;
end;

procedure TStockRec.SRASSHFChange(Sender: TObject);
var
  CurrentValue: Integer;
begin
  if not (csLoading in SRASSHF.ComponentState) then
  begin
    CurrentValue := Trunc(SRASSHF.Value);
    if (CurrentValue > SBSUpDown1.Max) then
      SRASSHF.Value := SBSUpDown1.Max
    else if (CurrentValue < SBSUpDown1.Min) then
      SRASSHF.Value := SBSUpDown1.Min;
  end;
end;

procedure TStockRec.SRASSDFChange(Sender: TObject);
var
  CurrentValue: Integer;
begin
  if not (csLoading in SRASSDF.ComponentState) then
  begin
    CurrentValue := Trunc(SRASSDF.Value);
    if (CurrentValue > DefUdF.Max) then
      SRASSDF.Value := DefUdF.Max
    else if (CurrentValue < DefUdF.Min) then
      SRASSDF.Value := DefUdF.Min;
  end;
end;

procedure TStockRec.SRROLTFChange(Sender: TObject);
var
  CurrentValue: Integer;
begin
  if not (csLoading in SRROLTF.ComponentState) then
  begin
    CurrentValue := Trunc(SRROLTF.Value);
    if (CurrentValue > SBSUpDown3.Max) then
      SRROLTF.Value := SBSUpDown3.Max
    else if (CurrentValue < SBSUpDown3.Min) then
      SRROLTF.Value := SBSUpDown3.Min;
  end;
end;

//GS 07/10/2011 ABSEXCH-11622:
//modified the method call 'Display_SerRec' to pass a 'mode = 4' argument value
procedure TStockRec.ReadOnlyView1Click(Sender: TObject);
begin
  {$IFDEF SOP}
  if Current_Page = SSerialPNo then
  begin
    //mode = 4: open record in read only mode
    Display_SerRec(4)
  end;
  {$ENDIF}
end;
procedure TStockRec.MenItem_AuditClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmAudit);
end;

procedure TStockRec.MenItem_DatedClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmDated);
end;

procedure TStockRec.MenItem_GeneralClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmGeneral);
end;

procedure TStockRec.SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
begin
  //Called when user uses Switch from pop-up menu on Notes form
  AddCP1Btn.Enabled := NewMode <> nmAudit;
  EditCP1Btn.Enabled := NewMode <> nmAudit;
  InsCP1Btn.Enabled := NewMode <> nmAudit;
  DelCP1Btn.Enabled := NewMode <> nmAudit;
end;

//GS 07/10/2011 ABSEXCH-11622:
//added code to check if the current record is emphasised (bold) as
//this indicates if a serial record is unused; toggle the 'edit' button accordingly
procedure TStockRec.ToggleSerialTabEditButton;
begin

  if (Assigned(MulCtrlO2[SSerialPNo]) and (Current_Page=SSerialPNo)) then
  begin 
    if (MulCtrlO2[SSerialPNo].CheckRowEmph = 0) then
    begin
      EditCP1Btn.Enabled := False;
    end
    else
    begin
      EditCP1Btn.Enabled := True;
    end;
  end;
end;

// MH 08/09/2014 v7.1 ABSEXCH-15052: Added new EC Service field for Description Only Stock
procedure TStockRec.SRTFChange(Sender: TObject);
begin
  SetECServiceVisibility (StkI2PT(SRTF.ItemIndex));
end;

//-------------------------------------------------------------------------

// MH 18/05/2016 2016-R2 ABSEXCH-17470: Re-arrrange Web/User field to optimise user defined fields
procedure TStockRec.Hide_eBusinessFields;
Var
  VOffs : Integer;

  //-----------------------------------

  Procedure PositionUDLabel (UDFLabel : Label8; UDFEdit : Text8pt);
  Begin // PositionUDLabel
    UDFLabel.Left := UD1Lab.Left;
    UDFLabel.Top := UDFEdit.Top + 3;
    UDFLabel.Width := UD1Lab.Width;
  End; // PositionUDLabel

  //-----------------------------------

  Procedure CalcUDFWidth (UDFEdit : Text8pt);
  Begin // CalcUDFWidth
    UDFEdit.Width := Round(UDFEdit.MaxLength * 7.5);
  End; // CalcUDFWidth

  //-----------------------------------

  Procedure PositionUDF (UDFLabel : Label8; PreviousEdit, UDFEdit : Text8pt);
  Begin // PositionUDF
    UDFEdit.Left := UD1F.Left;
    UDFEdit.Top := PreviousEdit.Top + (UD2F.Top - UD1F.Top);
    CalcUDFWidth(UDFEdit);

    PositionUDLabel (UDFLabel, UDFEdit);
  End; // PositionUDF

  //-----------------------------------

Begin // Hide_eBusinessFields
  // Hide the web settings fields
  lblWebSettingsTitle.Visible := False;
  bevWebSettingsTitle.Visible := False;

  emWebF.Visible:=BOff;
  WebCatF.Visible:=BOff;
  WebImgF.Visible:=BOff;
  Label826.Visible:=BOff;
  Label844.Visible:=BOff;

  // Move the Default Line Type fields up to fill the gap
  VOffs := lblDefaultLineTypeTitle.Top - lblWebSettingsTitle.Top;

  lblDefaultLineTypeTitle.Top := lblDefaultLineTypeTitle.Top - VOffs;
  bevDefaultLineTypeTitle.Top := bevDefaultLineTypeTitle.Top - VOffs;
  lblLineType.Top := lblLineType.Top - VOffs;
  SRLTF.Top := SRLTF.Top - VOffs;

  // Re-Organise the User Defined Fields
  lblUserDefinedFieldsTitle.Top := lblUserDefinedFieldsTitle.Top - VOffs;
  bevUserDefinedFieldsTitle.Top := bevUserDefinedFieldsTitle.Top - VOffs;
  // Manually position 1 and 2 where we want them
  UD1F.Top := UD1F.Top - VOffs;
  CalcUDFWidth(UD1F);
  PositionUDLabel (UD1Lab, UD1F);

  UD2F.Top := UD2F.Top - VOffs - 1;   // Close up the gap by 1 pixel to make room for all 10 fields
  CalcUDFWidth(UD2F);
  PositionUDLabel (UD2Lab, UD2F);

  // And then position the rest using the positions of 1 and 2
  PositionUDF (UD3Lab, UD2F, UD3F);
  PositionUDF (UD4Lab, UD3F, UD4F);
  PositionUDF (UD5Lab, UD4F, UD5F);
  PositionUDF (UD6Lab, UD5F, UD6F);
  PositionUDF (UD7Lab, UD6F, UD7F);
  PositionUDF (UD8Lab, UD7F, UD8F);
  PositionUDF (UD9Lab, UD8F, UD9F);
  PositionUDF (UD10Lab, UD9F, UD10F);
End; // Hide_eBusinessFields

//-------------------------------------------------------------------------

// MH 18/05/2016 2016-R2 ABSEXCH-17470: Added Tax Codes tab for MRT
procedure TStockRec.ReOrgTaxPanels;
Begin // ReOrgTaxPanels
  // Show panels as follows:-
  //
  //   Tax Codes          - Always at top
  //   Intrastat
  //   EC Services        - Always at bottom
  If panIntrastatSettings.Visible Then
  Begin
    panIntrastatSettings.Top := panTaxCodes.Top  + panTaxCodes.Height;

    If panECServices.Visible Then
    Begin
      panECServices.Top := panIntrastatSettings.Top + panIntrastatSettings.Height;
    End; // If panECServices.Visible
  End // If panIntrastatSettings.Visible
  Else
  Begin
    If panECServices.Visible Then
    Begin
      panECServices.Top := panTaxCodes.Top  + panTaxCodes.Height;
    End; // If panECServices.Visible
  End; // Else
End; // ReOrgTaxPanels

//-------------------------------------------------------------------------

procedure TStockRec.PWFExit(Sender: TObject);
begin
  If (Not SRCOF.Visible) And ExLocal.InAddEdit then
  Begin
    // MH 17/05/2016 2016-R2 ABSEXCH-17470: Added Tax tab for MRT
    ChangePage(SDef2PNo);
    SetFieldFocus;
  end;
end;

//-----------------------------------

procedure TStockRec.SRCOFExit(Sender: TObject);
begin
  If ExLocal.InAddEdit then
  Begin
    // MH 17/05/2016 2016-R2 ABSEXCH-17470: Added Tax tab for MRT
    ChangePage(SDef2PNo);
    SetFieldFocus;
  end;
end;

//-------------------------------------------------------------------------

procedure TStockRec.cbTaxCodeExit(Sender: TObject);
Var
  OrigVATCode : Char;
begin
  If (ExLocal.InAddEdit) and (Sender is TSBSComboBox) then
  Begin
    // Record VAT Code here to detect changes
    OrigVATCode := ExLocal.LStock.VATCode;

    // Update LStock from window
    Form2Stock;

    {$IFDEF VAT}
      If (ExLocal.LStock.VATCode = VATICode) and (ExLocal.LStock.VATCode <> OrigVATCode) Then
        With TSBSComboBox(Sender) do
          GetIRate(Parent.ClientToScreen(ClientPos(Left,Top+23)), Color, Font, Self.Parent, ExLocal.LViewOnly, ExLocal.LStock.SVATIncFlg);
    {$ENDIF}
  End; // If (ExLocal.InAddEdit) and (Sender is TSBSComboBox)
end;

//-------------------------------------------------------------------------

// MH 26/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
function TStockRec.WindowExportEnableExport: Boolean;
begin

  Result := Current_Page In [SNotesPNo,
                             SQtyBPNo,
                             SMultiBuyPNo,
                             SValuePNo,
                             SLedgerPNo];

  If Result Then
  begin
    WindowExport.AddExportCommand (ecIDCurrentRow, ecdCurrentRow);
    WindowExport.AddExportCommand (ecIDCurrentPage, ecdCurrentPage);
    WindowExport.AddExportCommand (ecIDEntireList, ecdEntireList);
  end; // If Result
end;

//-----------------------------------

// MH 26/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
procedure TStockRec.WindowExportExecuteCommand(const CommandID: Integer; Const ProgressHWnd : HWnd);
Var
  ListExportIntf : IExportListData;
begin
  // Returns a new instance of an "Export Btrieve List To Excel" object
  ListExportIntf := NewExcelListExport;
  Try
    ListExportIntf.ExportTitle := WindowExportGetExportDescription;

    // Connect to Excel
    If ListExportIntf.StartExport Then
    begin
      if (Current_Page = SNotesPNo) Then
        // Notes tab
        NotesCtrl.MulCtrlO.ExportList (ListExportIntf, CommandID, ProgressHWnd)
      else If (Current_Page = SQtyBPNo) Then
        // Qty Breaks tab
        MULCtrlO2[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd)
      else if (Current_Page In [SMultiBuyPNo, SLedgerPNo]) then
        // MultiBuy Discount, Ledger tab
        MULCtrlO[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd)
      else if (Current_Page = SValuePNo) then
        // Value tab
        MULCtrlO2[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd);

      ListExportIntf.FinishExport;
    end; // If ListExportIntf.StartExport(sTitle)
  Finally
    ListExportIntf := NIL;
  End; // Try..Finally
end;

//-----------------------------------

function TStockRec.WindowExportGetExportDescription: String;
begin
  Case Current_Page Of
    SNotesPNo     : Result := 'Notes';
    SQtyBPNo      : Result := 'Qty Breaks';
    SMultiBuyPNo  : Result := 'Multi-Buy';
    SValuePNo     : Result := 'Value';
    SLedgerPNo    : Result := 'Ledger';
  end;

  Result := 'Stock ' + Result + ' - ' + Trim(ExLocal.LStock.StockCode);
end;

//=========================================================================

Initialization
  FillChar(DDFormMode,Sizeof(DDFormMode),0);
end.
