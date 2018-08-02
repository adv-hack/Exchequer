unit EParentU;


interface

{$I DEFOvr.Inc}

uses
  Test,
  ShareMem,
  Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus, Math,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls,
  Statusbr, Gauges, SBSPanel,TEditVal, GlobVar, IniFiles, FileUtil,
  Clipbrd,

  {$IFDEF C_On}
    CustLst2,
    {$IFDEF MHALTCUSTLIST}
      CustListML,
    {$ENDIF}
  {$ENDIF}

  {$IFDEF NP}
    DiarLstU,
  {$ENDIF}

  {$IFDEF DBk_On}
    DayBk2,

    {$IFDEF JC}
        JobDbk2U,

    {$ENDIF}


  {$ENDIF}

  {$IFDEF NOM}
    Nominl1U,

    NomView1,
  {$ENDIF}

  {$IFDEF POST}
    CredPopU,
  {$ENDIF}

   BTSupU2,

  {$IFDEF STK}
    Saltxl2U,
    {$IFDEF SKL}
      StkTreeU,
      StkLstU,
    {$ENDIF}

    {$IFDEF SOP}
      MLoc0U,
      CuStkL1U,
    {$ENDIF}

    {$IFDEF RET}
      RetLTL1U,
    {$ENDIF}

    StkWarnU,
    CuStkA4U,
    ObjPrceU,

    {$IFDEF LTE}
      MoveTL1U,
    {$ENDIF}


  {$ENDIF}

  {$IFDEF JC}
    JobTreeU,
    Saltxl3U,
    JCEmpl1U,
    JCSSet1U,

    SetCISU,
    CISInp1U,
  {$ENDIF}

  {$IFDEF INV}
    STxMenU,
  {$ENDIF}

  {$IFDEF Frm}
    GlobType,
  {$ENDIF}

  {$IFDEF PF_On}
    {$IFDEF CC}
      CCListU,
    {$ENDIF}
  {$ENDIF}

  SetPrU,

  {$IFDEF VAT}
    SetVATU,

    VATEDIWU,
  {$ENDIF}


  {$IFDEF MC_On}
    SetCurrU,
  {$ENDIF}

  {$IFDEF S2}
    UsersListF,
    PassWR2U,
    SetModU,
    {$IFDEF SEC500}
      oMCMSec,
    {$ENDIF}
  {$ENDIF}

  ExThrd2U,

  SalTxl1U,

  {$IFDEF SY}
    SysSetU,
    DocNumLU,
    SetNCC,
    Excep2U,
  {$ENDIF}

  APIUTIL,
  antLabel,

  {$IFDEF PERIODFIX}
    PeriodObj,
  {$ENDIF}

  BTSupU1, sbsprint, RPBase, RPFiler, DebugBox, ImgList, ToolWin,
  AdvToolBar, AdvGlowButton, AdvToolBarStylers, ThemeMgr, EntWindowSettings,

  // MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  WindowExport

  //PR: 24/07/2012 ABSEXCH-12956
  {$IFDEF MC_ON}
  ,CurrencyListF
  {$ENDIF}
  ;





type
  {$I CustMenu.Pas}

  PHWND = ^HWND;

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    About1: TMenuItem;
    XXXEdit1: TMenuItem;
    XXXCutItem: TMenuItem;
    XXXCopyItem: TMenuItem;
    XXXPasteItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    Print1: TMenuItem;
    XXXSDebug: TMenuItem;
    XXXRPos: TMenuItem;
    N2: TMenuItem;
    SBSPanel1: TSBSPanel;
    StatusBar: TStatusBar;
    SBSPanel2: TSBSPanel;
    Gauge1: TGauge;
    SBSPanel3: TSBSPanel;
    Gauge2: TGauge;
    Reports1: TMenuItem;
    Utilities1: TMenuItem;
    Search1: TMenuItem;
    Daybooks1: TMenuItem;
    Records1: TMenuItem;
    Sales1: TMenuItem;
    Purch1: TMenuItem;
    Nom1: TMenuItem;
    Stock1: TMenuItem;
    Cust1: TMenuItem;
    Supp1: TMenuItem;
    NominalLedger1: TMenuItem;
    STree1: TMenuItem;
    SList1: TMenuItem;
    QFCust1: TMenuItem;
    QFSupp1: TMenuItem;
    QFTrans1: TMenuItem;
    CreditControl1: TMenuItem;
    NominalBased1: TMenuItem;
    GeneralReports1: TMenuItem;
    DaybookReports1: TMenuItem;
    FormDesigner1: TMenuItem;
    DataReuild1: TMenuItem;
    PayDueRep1: TMenuItem;
    RepDueRep1: TMenuItem;
    AgedDebtors1: TMenuItem;
    AgedCreditors1: TMenuItem;
    Statements1: TMenuItem;
    ChaseLetters1: TMenuItem;
    TrialBalance1: TMenuItem;
    ProfitLoss1: TMenuItem;
    BalanceSheet1: TMenuItem;
    SApp1: TMenuItem;
    NomHist1: TMenuItem;
    NomCode1: TMenuItem;
    CCDepRep1: TMenuItem;
    Fulltb1: TMenuItem;
    SimTB1: TMenuItem;
    SBased1: TMenuItem;
    SalesAnal1: TMenuItem;
    PriceList1: TMenuItem;
    SList2: TMenuItem;
    ReOrderList1: TMenuItem;
    StkHist1: TMenuItem;
    Backlog1: TMenuItem;
    OnOrder1: TMenuItem;
    StkTakeList1: TMenuItem;
    Labels1: TMenuItem;
    PrAnal1: TMenuItem;
    CCAnal1: TMenuItem;
    StkPRep1: TMenuItem;
    StkCRep1: TMenuItem;
    ValuationReport1: TMenuItem;
    ValRep2: TMenuItem;
    OrdBkRep1: TMenuItem;
    KitBKRep1: TMenuItem;
    OrdShort1: TMenuItem;
    KitShortRep1: TMenuItem;
    DocAnal1: TMenuItem;
    BankRec1: TMenuItem;
    CustRep1: TMenuItem;
    SuppRep1: TMenuItem;
    VRep1: TMenuItem;
    mnuPrintDocuments1: TMenuItem;
    SalesDaybook1: TMenuItem;
    PurchaseDaybook1: TMenuItem;
    ReceiptsDaybook1: TMenuItem;
    PaymentsDaybook1: TMenuItem;
    SORDBook1: TMenuItem;
    PORDBook1: TMenuItem;
    List1: TMenuItem;
    AccDet1: TMenuItem;
    TradLed1: TMenuItem;
    Labels2: TMenuItem;
    TradingHistory1: TMenuItem;
    VATRegList1: TMenuItem;
    List2: TMenuItem;
    AccDet2: TMenuItem;
    TradLedg2: TMenuItem;
    Labels3: TMenuItem;
    TradingHistory2: TMenuItem;
    VATRegList2: TMenuItem;
    VRet1: TMenuItem;
    ECSalesList1: TMenuItem;
    ISReport1: TMenuItem;
    PrintSetup1: TMenuItem;
    FileCompList: TMenuItem;
    SBSPanel_Print: TSBSPanel;
    Gauge3: TGauge;
    Label_PrntProg: TLabel;
    CC1: TMenuItem;
    Dep1: TMenuItem;
    XXXCAcc1: TMenuItem;
    VS1: TMenuItem;
    CS1: TMenuItem;
    SS1: TMenuItem;
    GS1: TMenuItem;
    mniUserManagement: TMenuItem;
    XXXMUO1: TMenuItem;
    HBG1: TMenuItem;
    XXXCASL1: TMenuItem;
    XXXDisHKey1: TMenuItem;
    QFStk1: TMenuItem;
    QFSerialF: TMenuItem;
    HelpT1: TMenuItem;
    N4: TMenuItem;
    What1: TMenuItem;
    Arrivals1: TMenuItem;
    Dispatches1: TMenuItem;
    SODT1: TMenuItem;
    PODT1: TMenuItem;
    XXXMULic1: TMenuItem;
    XXXRSetMU1: TMenuItem;
    Proc1: TMenuItem;
    ChnagePr1: TMenuItem;
    GLRecon1: TMenuItem;
    PostingMenu1: TMenuItem;
    PADBk1: TMenuItem;
    PRep1: TMenuItem;
    G1: TMenuItem;
    DocBased1: TMenuItem;
    AutoDbkPost1: TMenuItem;
    SV1: TMenuItem;
    RGL1: TMenuItem;
    DocNum1: TMenuItem;
    CCodes1: TMenuItem;
    AddN1: TMenuItem;
    ObjectDrill1: TMenuItem;
    imgCentreLeft: TImage;
    Sess1: TMenuItem;
    XXXdbClear1: TMenuItem;
    RWSepBar: TMenuItem;
    RWriter: TMenuItem;
    ST1: TMenuItem;
    IRO1: TMenuItem;
    MLoc1: TMenuItem;
    FileCompSepBar: TMenuItem;
    Batches1: TMenuItem;
    BPPY1: TMenuItem;
    BSRC1: TMenuItem;
    BPRep1: TMenuItem;
    BPRun1: TMenuItem;
    BPRep2: TMenuItem;
    BPRun2: TMenuItem;
    PRep2: TMenuItem;
    DocBased2: TMenuItem;
    G2: TMenuItem;
    GLRec1: TMenuItem;
    GLRec2: TMenuItem;
    ADCons1: TMenuItem;
    ADMDC1: TMenuItem;
    ACCons1: TMenuItem;
    ACMDC1: TMenuItem;
    XXXLicMod1: TMenuItem;
    XXXErrLogs1: TMenuItem;
    Diary1: TMenuItem;
    Timer1: TTimer;
    HelpSearchItem: TMenuItem;
    HelpHowToUse: TMenuItem;
    ObjectCC1: TMenuItem;
    ObjectStk1: TMenuItem;
    ObjPrice1: TMenuItem;
    TeleSales1: TMenuItem;
    JobCosting1: TMenuItem;
    JobCostR1: TMenuItem;
    JCRBS1: TMenuItem;
    JCEL1: TMenuItem;
    JCJH1: TMenuItem;
    JCCE1: TMenuItem;
    JCBA1: TMenuItem;
    JCAA1: TMenuItem;
    JCWIP1: TMenuItem;
    JCBR1: TMenuItem;
    JobCosting2: TMenuItem;
    Empl1: TMenuItem;
    JAnal1: TMenuItem;
    QFJobF: TMenuItem;
    JCEL2: TMenuItem;
    JCEL3: TMenuItem;
    Export1: TMenuItem;
    VATEDI1: TMenuItem;
    VEDIECSL1: TMenuItem;
    VECSSDD1: TMenuItem;
    VECSSDA1: TMenuItem;
    XXXSysLic1: TMenuItem;
    Accruals1: TMenuItem;
    PAccruals: TMenuItem;
    SAccruals: TMenuItem;
    Commitment1: TMenuItem;
    RemoveCommit: TMenuItem;
    PAccrualRep: TMenuItem;
    SAccrualRep: TMenuItem;
    Accruals2: TMenuItem;
    PAccrualRep2: TMenuItem;
    SAccrualRep2: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    AgingReport1: TMenuItem;
    mniChangeMyPassword: TMenuItem;
    LockScreen1: TMenuItem;
    WOP1: TMenuItem;
    WOPRep1: TMenuItem;
    WOPF1: TMenuItem;
    WOPF2: TMenuItem;
    WOPWIP1: TMenuItem;
    WOPF3: TMenuItem;
    KitBKRep2: TMenuItem;
    XXXCACCDL1: TMenuItem;
    XXXPartialUnpost1: TMenuItem;
    XXXTotalUnpost1: TMenuItem;
    XXXCAJT1: TMenuItem;
    XXXRestJA1: TMenuItem;
    DelAudit1: TMenuItem;
    Purge1: TMenuItem;
    Purge2: TMenuItem;
    N11: TMenuItem;
    XXXAllocSRC1: TMenuItem;
    XXXAllocPPY1: TMenuItem;
    XXXAllocSRC2: TMenuItem;
    XXXAllocPPY2: TMenuItem;
    XXXUnalocate1: TMenuItem;
    XXXRAlloc1: TMenuItem;
    XXXSAlloc1: TMenuItem;
    XXXPAlloc1: TMenuItem;
    CIS1: TMenuItem;
    XXXSPAccess1: TMenuItem;
    XXXCISGen1: TMenuItem;
    XXXCIS2: TMenuItem;
    XXXCISL1: TMenuItem;
    XXXCISG1: TMenuItem;
    XXXCISG2: TMenuItem;
    Suby1: TMenuItem;
    Suby2: TMenuItem;
    RCTRet1: TMenuItem;
    CISEDI1: TMenuItem;
    CISEDI2: TMenuItem;
    CISEDI3: TMenuItem;
    XXXPartialUnpost2: TMenuItem;
    XXXPartialUnpost3: TMenuItem;
    XXXReCalcGLHed1: TMenuItem;
    XXXCAGLT1: TMenuItem;
    NominalDaybook1: TMenuItem;
    XXXTranCradle1: TMenuItem;
    Bins1: TMenuItem;
    StockbyBin1: TMenuItem;
    StockHistorybyBin1: TMenuItem;
    QFBinF: TMenuItem;
    N12: TMenuItem;
    AppsRep1: TMenuItem;
    AppsRep2: TMenuItem;
    AppsRep4: TMenuItem;
    AppsRep20: TMenuItem;
    AppsRep21: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    mniN18: TMenuItem;
    N17: TMenuItem;
    XXXVerifyJA1: TMenuItem;
    ValRep3: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    SRN1: TMenuItem;
    PRN1: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    PRAccrual1: TMenuItem;
    SRAccrual1: TMenuItem;
    N27: TMenuItem;
    XXXResetbusylock1: TMenuItem;
    N28: TMenuItem;
    Returns1: TMenuItem;
    SalesRetAnal1: TMenuItem;
    PurchRetAnal1: TMenuItem;
    RetReasons1: TMenuItem;
    N29: TMenuItem;
    NominalLedger2: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N36: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    MoveStk1: TMenuItem;
    N40: TMenuItem;
    SpellCheck1: TMenuItem;
    BankReconciliation: TMenuItem;
    BankRecReport: TMenuItem;
    N41: TMenuItem;
    eBankingSetup: TMenuItem;
    CISRet2: TMenuItem;
    CISXML1: TMenuItem;
    CISXML2: TMenuItem;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    AdvStyler: TAdvToolBarOfficeStyler;
    FAddBtn: TAdvGlowButton;
    Bevel0: TAdvToolBarSeparator;
    MainSDBkBtn: TAdvGlowButton;
    MainPDBkBtn: TAdvGlowButton;
    MainNDBkBtn: TAdvGlowButton;
    MainADBkBtn: TAdvGlowButton;
    MainJDBkBtn: TAdvGlowButton;
    MainWOBkBtn: TAdvGlowButton;
    Bevel1: TAdvToolBarSeparator;
    MainSODBkBtn: TAdvGlowButton;
    MainTSBtn: TAdvGlowButton;
    MainPODBkBtn: TAdvGlowButton;
    Bevel2: TAdvToolBarSeparator;
    MainCustBtn: TAdvGlowButton;
    MainSuppBtn: TAdvGlowButton;
    MainSListBtn: TAdvGlowButton;
    Bevel3: TAdvToolBarSeparator;
    MainNomBtn: TAdvGlowButton;
    MainStockBtn: TAdvGlowButton;
    MainJobBtn: TAdvGlowButton;
    Bevel4: TAdvToolBarSeparator;
    DDn1Btn: TAdvGlowButton;
    DDa1Btn: TAdvGlowButton;
    QFBtn: TAdvGlowButton;
    Bevel5: TAdvToolBarSeparator;
    DiaryBtn: TAdvGlowButton;
    PrintBtn: TAdvGlowButton;
    ExitBtn: TAdvGlowButton;
    WhatTBtn: TAdvGlowButton;
    ReportWriters1: TMenuItem;
    VisualReportWriter1: TMenuItem;
    tmPeriodDebug: TTimer;
    XXXCGBOM1: TMenuItem;
    XXXBang: TMenuItem;
    NewECSalesListJan10Onwards: TMenuItem;
    NewECSalesListRepJan10Onwards: TMenuItem;
    XXXmnuCustomerPortal: TMenuItem;
    ThemeManager1: TThemeManager;
    mnuTraderBankCardAudit: TMenuItem;
    MenItem_SaveCoordinates: TMenuItem;
    MenItem_ResetToDefault: TMenuItem;
    ScreenPosition1: TMenuItem;
    MenItem_UserFields: TMenuItem;
    AuditNotesReport: TMenuItem;
    Customers1: TMenuItem;
    Suppliers1: TMenuItem;
    transactions1: TMenuItem;
    Stock2: TMenuItem;
    Jobs1: TMenuItem;
    UpdateInformationDetails1: TMenuItem;
    VATCSV1: TMenuItem;
    DispatchesECSSD1: TMenuItem;
    ArrivalsECSSD1: TMenuItem;
    btnOpenConsumersList: TAdvGlowButton;
    mnuConsumers: TMenuItem;
    forConsumer1: TMenuItem;
    mnuoptCreditCardPaymentGateway: TMenuItem;
    mnuUnallocateAllTransactions: TMenuItem;
    mnuUnallocateCustomers: TMenuItem;
    mnuUnallocateConsumers: TMenuItem;
    mnuUnallocateSuppliers: TMenuItem;
    mnuoptEndofDayPaymentsReport: TMenuItem;
    CheckCustomerStockAnalysis1: TMenuItem;
    mnuoptOrderPaymentsTracker: TMenuItem;
    mnuoptOrderPaymentsTrackerSep: TMenuItem;
    N42: TMenuItem;
    IntrastatControlCentre1: TMenuItem;
    ECSalesList2: TMenuItem;
    NewECSalesList2: TMenuItem;
    eRCT1: TMenuItem;
    imgTopRight: TImage;
    mnuCustTransOnHoldRep: TMenuItem;
    mnuSuppTransOnHoldRep: TMenuItem;
    mnuTradersonHoldRep: TMenuItem;
    mniOrdersStatus: TMenuItem;
    mniOrdersStatus1: TMenuItem;
    mniOrdersDeliverednotInvoiced: TMenuItem;
    mniOrdersReceivednotInvoiced: TMenuItem;
    mniOrdersnotFullyAllocated: TMenuItem;
    mniOrdersPartReceived: TMenuItem;
    mniVATReconciliation1: TMenuItem;
    mniStockAdjustmentsDaybook: TMenuItem;
    mniJobDaybook: TMenuItem;
    mniSalesPurchaseOrders: TMenuItem;
    mniSalesOrders: TMenuItem;
    mniPurchaseOrders: TMenuItem;
    mniNegativeStock: TMenuItem;
    mniStockSalesHistory: TMenuItem;
    mniStockPurchaseHistory: TMenuItem;
    mniBOMReports: TMenuItem;
    mniComponentusage: TMenuItem;
    mniBOMComponents: TMenuItem;
    mniBOMbuild: TMenuItem;
    mniProfitLossPeriodYear: TMenuItem;
    mniProfitLossPriorYearComparison: TMenuItem;
    mniBalanceSheetPeriodYear: TMenuItem;
    mniBalanceSheetPriorYearComparison: TMenuItem;
    mniGLMonthlyBreakdown: TMenuItem;
    mniPrePostingReport: TMenuItem;
    mniNominalswithVAT: TMenuItem;
    mniVATTransactions: TMenuItem;
    mniVATTransactions1: TMenuItem;
    mniSubContractorsUnverified: TMenuItem;
    mniValuationReportLIVE: TMenuItem;
    mniCustomReports: TMenuItem;
    mniN13: TMenuItem;
    mniN14: TMenuItem;
    mniN15: TMenuItem;
    mniN16: TMenuItem;
    mniN17: TMenuItem;
    mniN19: TMenuItem;
    mniN20: TMenuItem;
    mniDocAudit1: TMenuItem;
    mniAuditTrail1: TMenuItem;
    mniNomAuditTrail1: TMenuItem;
    ECSalesDetailsRep: TMenuItem;
    mniMyUserProfile: TMenuItem;
    XXXCAllGLYTDBal: TMenuItem;
    N13: TMenuItem;
    mnuoptAnonymisationControlCentre: TMenuItem;
    mniSummaryReport: TMenuItem;
    mniDetailedReport: TMenuItem;
    N16: TMenuItem;
    mnuCheckSQLPostingCompatibility: TMenuItem;
    agbExportToExcel: TAdvGlowButton;
    popExportList: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure WindowCascadeItemClick(Sender: TObject);
    procedure UpdateMenuItems(Sender: TObject);
    procedure WindowTileItemClick(Sender: TObject);
    procedure WindowArrangeItemClick(Sender: TObject);
    procedure FileExitItemClick(Sender: TObject);
    procedure XXXCopyItemClick(Sender: TObject);
    procedure XXXPasteItemClick(Sender: TObject);
    procedure WindowMinimizeItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure XXXSDebugClick(Sender: TObject);
    procedure XXXRPosClick(Sender: TObject);
    procedure CustQFBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MainSDBkBtnClick(Sender: TObject);
    procedure MainNomBtnClick(Sender: TObject);
    procedure FAddBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DDn1BtnClick(Sender: TObject);
    procedure DDa1BtnClick(Sender: TObject);
    procedure MainStockBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure About1Click(Sender: TObject);
    procedure SList1Click(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure Label_PrntProgDblClick(Sender: TObject);
    procedure CC1Click(Sender: TObject);
    procedure PrintSetup1Click(Sender: TObject);
    procedure ChangePr1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpeedButton5Click(Sender: TObject);
    procedure XXXCAcc1Click(Sender: TObject);
    procedure RGL1Click(Sender: TObject);
    procedure CS1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure HBG1Click(Sender: TObject);
    procedure XXXCASL1Click(Sender: TObject);
    procedure SV1Click(Sender: TObject);
    procedure VS1Click(Sender: TObject);
    procedure XXXDisHKey1Click(Sender: TObject);
    procedure AgedDebtors1Click(Sender: TObject);
    procedure List1Click(Sender: TObject);
    procedure HelpT1Click(Sender: TObject);
    procedure WhatTBtnClick(Sender: TObject);
    procedure Statements1Click(Sender: TObject);
    procedure PostingReport1Click(Sender: TObject);
    procedure PADBk1Click(Sender: TObject);
    procedure DocAnal1Click(Sender: TObject);
    procedure BankRec1Click(Sender: TObject);
    procedure Fulltb1Click(Sender: TObject);
    procedure CCDepRep1Click(Sender: TObject);
    procedure PrAnal1Click(Sender: TObject);
    procedure VRet1Click(Sender: TObject);
    procedure mniUserManagementClick(Sender: TObject);
    procedure FormDesigner1Click(Sender: TObject);
    procedure GS1Click(Sender: TObject);
    procedure StkPRep1Click(Sender: TObject);
    procedure ValRep2Click(Sender: TObject);
    procedure SList2Click(Sender: TObject);
    procedure StkHist1Click(Sender: TObject);
    procedure XXXMULic1Click(Sender: TObject);
    procedure GLRecon1Click(Sender: TObject);
    procedure DocNum1Click(Sender: TObject);
    procedure CCodes1Click(Sender: TObject);
    procedure PQBtn1Click(Sender: TObject);
    procedure XXXdbClear1Click(Sender: TObject);
    procedure KitBKRep1Click(Sender: TObject);
    procedure RWriterClick(Sender: TObject);
    procedure FCLClick(Sender: TObject);
    procedure MLoc1Click(Sender: TObject);
    procedure BPPY1Click(Sender: TObject);
    procedure BPRep1Click(Sender: TObject);
    procedure XXXLicMod1Click(Sender: TObject);
    procedure XXXErrLogs1Click(Sender: TObject);
    procedure DiaryBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure HelpSearchItemClick(Sender: TObject);
    procedure HelpHowToUseClick(Sender: TObject);
    procedure ObjectCC1Click(Sender: TObject);
    procedure ObjectStk1Click(Sender: TObject);
    procedure ObjPrice1Click(Sender: TObject);
    procedure TeleSales1Click(Sender: TObject);
    procedure JobCosting1Click(Sender: TObject);
    procedure JobCosting2Click(Sender: TObject);
    procedure JCRBS1Click(Sender: TObject);
    procedure Empl1Click(Sender: TObject);
    procedure JAnal1Click(Sender: TObject);
    procedure JCEL2Click(Sender: TObject);
    procedure JCJH1Click(Sender: TObject);
    procedure JCCE1Click(Sender: TObject);
    procedure JCBA1Click(Sender: TObject);
    procedure JCAA1Click(Sender: TObject);
    procedure JCWIP1Click(Sender: TObject);
    procedure JCBR1Click(Sender: TObject);
    procedure VEDIECSL1Click(Sender: TObject);
    procedure XXXSysLic1Click(Sender: TObject);
    procedure PAccrualsClick(Sender: TObject);
    procedure RemoveCommitClick(Sender: TObject);
    procedure PAccrualRepClick(Sender: TObject);
    procedure mniChangeMyPasswordClick(Sender: TObject);
    procedure LockScreen1Click(Sender: TObject);
    procedure WOPF1Click(Sender: TObject);
    procedure WOPWIP1Click(Sender: TObject);
    procedure XXXCACCDL1Click(Sender: TObject);
    procedure XXXTotalUnpost1Click(Sender: TObject);
    procedure PartialUnpost1Click(Sender: TObject);
    procedure XXXCAJT1Click(Sender: TObject);
    procedure XXXRestJA1Click(Sender: TObject);
    procedure Purge1Click(Sender: TObject);
    procedure XXXAllocSRC1Click(Sender: TObject);
    procedure XXXUnalocate1Click(Sender: TObject);
    procedure CIS1Click(Sender: TObject);
    procedure XXXCISGen1Click(Sender: TObject);
    procedure Suby2Click(Sender: TObject);
    procedure CISRet1Click(Sender: TObject);
    procedure CISEDI2Click(Sender: TObject);
    procedure XXXReCalcGLHed1Click(Sender: TObject);
    procedure XXXTranCradle1Click(Sender: TObject);
    procedure StockbyBin1Click(Sender: TObject);
    procedure AppsRep2Click(Sender: TObject);
    procedure PRAccrual1Click(Sender: TObject);
    procedure XXXResetbusylock1Click(Sender: TObject);
    procedure SalesRetAnal1Click(Sender: TObject);
    procedure RetReasons1Click(Sender: TObject);
    procedure NominalLedger2Click(Sender: TObject);
    procedure MoveStk1Click(Sender: TObject);
    procedure SpellCheck1Click(Sender: TObject);
    procedure BankReconciliationClick(Sender: TObject);
    procedure BankRecReportClick(Sender: TObject);
    procedure eBankingSetupClick(Sender: TObject);
    procedure CISXML2Click(Sender: TObject);
    procedure VisualReportWriter1Click(Sender: TObject);
    procedure tmPeriodDebugTimer(Sender: TObject);
    procedure XXXCGBOM1Click(Sender: TObject);
    procedure XXXBangClick(Sender: TObject);
    procedure NewECSalesListJan10OnwardsClick(Sender: TObject);
    procedure NewECSalesListRepJan10OnwardsClick(Sender: TObject);
    procedure XXXmnuCustomerPortalClick(Sender: TObject);
    procedure mnuTraderBankCardAuditClick(Sender: TObject);
    procedure MenItem_SaveCoordinatesClick(Sender: TObject);
    procedure MenItem_ResetToDefaultClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenItem_UserFieldsClick(Sender: TObject);
    procedure Customer1Click(Sender: TObject);
    procedure Supplier1Click(Sender: TObject);
    procedure transactions1Click(Sender: TObject);
    procedure Stock2Click(Sender: TObject);
    procedure Jobs1Click(Sender: TObject);
    procedure UpdateInformationDetails1Click(Sender: TObject);
    procedure DispatchesECSSD1Click(Sender: TObject);
    procedure ArrivalsECSSD1Click(Sender: TObject);
    procedure mnuoptCreditCardPaymentGatewayClick(Sender: TObject);
    procedure mnuUnallocateCustomersClick(Sender: TObject);
    procedure mnuoptEndofDayPaymentsReportClick(Sender: TObject); {* EL BoM Check implementation from DOS code *}
    procedure CheckCustomerStockAnalysis1Click(Sender: TObject);
    procedure mnuoptOrderPaymentsTrackerClick(Sender: TObject);
    procedure IntrastatControlCentre1Click(Sender: TObject);
    procedure eRCT1Click(Sender: TObject);
    procedure mnuTransactionsOnHoldRepClick(Sender: TObject);
    procedure mnuTradersonHoldRepClick(Sender: TObject);
    procedure mniOrdersStatusClick(Sender: TObject);
    procedure mniMyUserProfileClick(Sender: TObject);
    procedure XXXCAllGLYTDBalClick(Sender: TObject);
    procedure mnuoptAnonymisationControlCentreClick(Sender: TObject);
    procedure mnuCheckSQLPostingCompatibilityClick(Sender: TObject);
    procedure popExportListPopup(Sender: TObject);
    procedure ExportToExcelMenuItemsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }

    // MH 03/10/2016 2016-R3 ABSEXCH-17754: Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    // CA  04/06/2012   v7.0  ABSEXCH-12302:    Startup Upgrade Info Window
    PostedUpgradeInfoMsg      : Boolean;

    // MH 08/01/2018 2017-R1 ABSEXCH-19316: Changed display mechanism for SQL Posting Prompt Dialog
    ShownSQLPostingPrompt : Boolean;

    {$IFDEF C_On}
      CustList        :  TTradList;
      HotCust         :  TFCustDisplay;

    {$ENDIF}

    {$IFDEF DBk_On}
      SPDayBkList     :  Array[0..{$IFDEF RET} 6 {$ELSE} 4 {$ENDIF}] of TDayBk1;

      {$IFDEF JC}
        JCDayBk       :  TJobDayBk;
        InJCDayBk     :  Byte;
      {$ENDIF}
    {$ENDIF}

    {$IFDEF Nom}
      NomView         :  TNomView;

      GLViews       :  TNViews;

    {$ENDIF}

    {$IFDEF PF_On}
      {$IFDEF CC}
        CCDepList       :  Array[BOff..BOn] of TCCDepList;
      {$ENDIF}
    {$ENDIF}

    {$IFDEF Stk}
      HotStock          :  TFStkDisplay;
      {$IFDEF SKL}
        StkView         :  TStkView;
        StkList         :  TStkList;
      {$ENDIF}
       {$IFDEF SOP}
         MLocList       :  TLocnList;

       {$ENDIF}

       {$IFDEF RET}
          RetLTList     :  TRetLTList;
       {$ENDIF}


        ObjectStkEnq
                      :  TStkWarn;

        ObjectPrice
                      :  TObjPrice;
        {$IFDEF LTE}
          StkMoveList :  TMoveLTList;
        {$ENDIF}
    {$ENDIF}

    {$IFDEF JC}
      JobView         :  TJobView;
      HotJob          :  TFJobDisplay;
      EmplList        :  TEmplList;
      JAnalList       :  TJAnalList;

      ChangeCIS       :  TSetCISRate;
      InCISObjDrill,
      InCISVoucher    :  Boolean;
      CISObjDrillPtr  : Pointer;
      RepDrillDownPtr : Pointer;
    {$ENDIF}


    {$IFDEF INV}
      AddInvForm      :  TInvAddForm;
    {$ENDIF}

    {$IFDEF Frm}
      PrintHwnd     : HWnd;
    {$ENDIF}

    ChangePer       :  TSetPerRec;

    {$IFDEF VAT}
      ChangeVAT       :  TSetVATRate;
    {$ENDIF}

    {$IFDEF MC_On}
      //PR: 24/07/2012 ABSEXCH-12956 Replace old currency form with new currency list
      ChangeCurr      :  TfrmCurrencyList;
    {$ENDIF}

    {$IFDEF NP}
       GlobDiary      :  TDiaryList;
    {$ENDIF}

    {$IFDEF POST}
        ObjectCC
                      :  TCredPopUp;
    {$ENDIF}

    {$IFDEF S2}
      ChangeMod       :  TSetModRec;
    {$ENDIF}

    {$IFDEF SY}
      SysGenSet       :  TSysSet;
      DNCtrl          :  TDocNoList;
      GLCCCtrl        :  TSetGLCC;
      ErrLogFrm       :  TErrorLogFrm;
    {$ENDIF}
    FSettings : IWindowSettings;

    CheckedDiary,
    FromReLogOn,
    FSaveCoords,
    CompManOn : Boolean;

    LastActionTime    : Cardinal;

    FClientInstance,
    FPrevClientProc   : TFarProc;


    InSPDayBk       : Array[0..{$IFDEF RET} 6 {$ELSE} 4 {$ENDIF}] of Byte;

    InBatchPay,
    InCCDep         : Array[BOff..BOn] of Boolean;


    EntInCloseQ,
    EntBeenTidy,
    Ignore_HT,
    HideBkGnd,
    InObjDrill,
    InAddInv,
    InNominal,

    InNomView,
    InWarnLowMem,
    InStkTree,
    InReLogin,
        // HM 11/08/03: Added flag to control whether the scrollbar size gets reset - causes
    //              tray icon corruption under Windows XP - AOK on all other OS's
    SetXPScrollSize : Boolean;

    InJobTree       : Boolean;

    InTradeList,
    InStkList       : Byte;

    ObjDrillPtr     : Pointer;

    fDriveNo,
    fDiskSize,
    fDiskFree       : Int64;

    KeybDelay       :  SmallInt;
    KeybSpeed       :  DWord;

    ONCMetrics,
    NCMetrics       : PNonClientMetrics;

    OrigCaption     : ShortString;

      { Structure passed into Custom Menus }
    EntInfo         : ptrEntCustomInfo;

    SysHandle       :  THandle;

    Replace_Image   :  Function (INo     :  Byte;
                                Unload  :  Boolean)  :  Pointer; stdcall;

    NextInfoLabelTop : SmallInt;  // IAO RO

    DripFeedLbl : TantLabel;

    {$IFDEF LTE} // IAO RO
    ReadOnlyLbl : TantLabel;
    {$ENDIF}

    { CJS 2012-09-07 ABSEXCH-12952 - Rebranding - Background bitmap handling }
    BackgroundLoaded: Boolean;

    Procedure DrawBkGnd(Var Message : TMessage);
    procedure ResetPalette(Var Message  : TMessage);

    procedure ClientWndProc(VAR Message: TMessage);
    procedure CreateMDIChild(const Name: string);

    Procedure Update_DriveResource;

    procedure ApplicationActive(Sender  :  TObject);

    procedure FormTidy(Sender: TObject; Const EndSession : Boolean = False);

    procedure FormDesign;

    procedure ShowHint(Sender: TObject);

    procedure Change_Period;

    {$IFDEF VAT}
      procedure Change_VAT;
    {$ENDIF}

    {$IFDEF MC_On}
      procedure Change_Currency;
    {$ENDIF}


    {$IFDEF S2}
      procedure Change_Modules;
    {$ENDIF}

    {$IFDEF STK}
      procedure HotLinkStock(CCode  :  Str20);

      procedure UseObjectStkEnq(CCode     :  Str20;
                                LCode,
                                CuCode    :  Str10;
                                ScanMode  :  Boolean);

      {$IFDEF SOP}
        procedure Set_StkSuperOpo(Mode  :  Byte;
                                  ORec  :  tObjectSERec);

      {$ENDIF}

      procedure UseObjectPrice(CKAnal    :  CKAnalType;
                               ScanMode  :  Boolean);

      procedure ObjPriceLink(CCode2  :  Str10;
                             SCode2  :  Str20;
                             LCode2  :  Str5;
                             Curr2,
                             TCurr   :  SmallInt;
                             ScanMode,
                             Ok2Create:  Boolean);

    {$ENDIF}

    {$IFDEF C_On}
      procedure HotLinkCust(CCode  :  Str20);
    {$ENDIF}

    {$IFDEF POST}

      procedure UseObjectCC(CCode     :  Str10;
                            ScanMode,
                            UpdateBal :  Boolean);
    {$ENDIF}

    {$IFDEF JC}
      procedure HotLinkJob(CCode  :  Str20);

      procedure Change_CIS;

    {$ENDIF}


    Procedure Print_File(SetAddr  :  LongInt);

    {$IFDEF FRM}
      Procedure Fax_File(SetAddr  :  LongInt);

      Procedure Report_DrillDown(RepDataRec : EntCopyDataRecType);

    {$ENDIF}

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMCallViaComp(Var Message  :  TMessage); Message WM_CallViaComp;

    Procedure WMKeyDown(Var Message  :  TMessage); Message WM_KeyDown;

    Procedure WMQueryNewPalette(Var Message  :  TMessage); Message WM_QueryNewPalette;

    Procedure WMPaletteChanged(Var Message  :  TMessage); Message WM_PaletteChanged;

    procedure WMCopyData(var Msg: TWMCopyData);  Message WM_CopyData;

    // CA  03/06/2012   v7.0  ABSEXCH-12302:    Startup Upgrade Info Window
    Procedure WMUpgradeForm(Var Message  :  TMessage); Message WM_UpgradeForm;

    // HM 03/01/02: Added End Session tracking

    {$IFDEF DONOTUSE}
    procedure WMQueryEndSession(var Msg: TWMQueryEndSession); Message WM_QueryEndSession;
    {$ENDIF}
    {$IFDEF HM} // EndSession
      procedure WMQueryEndSession(var Msg: TWMQueryEndSession); Message WM_QueryEndSession;
      procedure WMEndSession(var Msg: TWMQueryEndSession); Message WM_EndSession;
    {$ENDIF}

    Procedure Send_UpdateList(WMMsg  :  LongInt;
                              Mode   :  Integer);

    Procedure Send_PWordUpDate(WMMsg  :  LongInt;
                               Mode   :  Integer);

    procedure Display_ObjectDrill;

    {$IFDEF JC}
       procedure Display_CISObjectDrill;
    {$ENDIF}


    {$IFDEF Frm}
      procedure PrintProgress(var Msg: TMessage); message WM_PrintProgress;
    {$ENDIF}

    procedure Release_Modules(LogoNo  :  Byte);

    procedure ChangeCompany(var Message: TMessage); message WM_ChangeComp;

    // MH 08/01/2018 2017-R1 ABSEXCH-19316: Changed display mechanism for SQL Posting Prompt Dialog
    procedure ShowSQLPostingPrompt(var Message: TMessage); message WM_ShowSQLPostingPrompt;

    // MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
    procedure ReevaluateListExportStatus(var Message: TMessage); message WM_ReevaluateListExportStatus;
    // MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
    procedure EvaluateListExportButtonStatus;

    Procedure Out_Period;

    Procedure Reset_NonClientInfo;
    Procedure Set_NonClientInfo;

    //procedure Load_ThemeLogo(LNo  :  Byte);
    //procedure Load_Logo(LNo  :  Byte);
    procedure Load_TileLogo(LNo  :  Byte);
    procedure LoadCoordinates();
    procedure SaveCoordinates();

    {$IFDEF SY}
      procedure EntException(Sender  :  TObject; E  :  Exception);
      Procedure EntDeActivate(Sender  :  TObject);

    {$ENDIF}

    procedure Display_AutoDiary;

    procedure SetLastActionTime;

    function ThreadIsBusy  :  Boolean;

    procedure ReLogIn;

    procedure CheckEntIdle(Sender: TObject; var Done: Boolean);

    procedure AppMessage (var Msg: TMsg; var Handled: Boolean);

    procedure AllocWizard(Sender: TObject);

    //GS 03/10/2011 ABSEXCH-11531 added method definitions for
    //determining if there is a print preview window open (TForm_PrintPreview)
    //and for closing down any open print preview forms
    Procedure ClosePrintPreviews;

    function GetBatchPayInUse(aIndex : Boolean) : Boolean;
    procedure SetBatchPayInUse(aIndex : Boolean; Value : Boolean);
    //PR: 13/05/2016 ABSEXCH-17450 New message handler to kick off CheckAllAccounts after revaluation
    Procedure WMThreadFinished(Var Message  :  TMessage); Message WM_THREADFINISHED;

    //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Release process lock
    Procedure WMLockedProcessFinished(Var Message  :  TMessage); Message WM_LOCKEDPROCESSFINISHED;



    // CJS 2016-06-29 - ABSEXCH-17383 - eRCT
    procedure PrepareRCT;

    // MH 03/10/2016 2016-R3 ABSEXCH-17754: Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    //TG 11/09/2017 - Show User Profile tab when User has not set its security question or answer.
    procedure SetSecurityQuestionAnswer;

    //RB 07/06/2017 2017-R2 ABSEXCH-14156: Temporary Data Files limited to 255 files- Causing Form Printing to Crash (Exch365)
    Procedure CleanUpSwap;
  public
    { Public declarations }

    Procedure SetCaption;

    Function  NewMenuItem (MenCap, MenName : ShortString) : TMenuItem;

    Procedure Update_DripFeed;

    {$IFDEF LTE}
    Procedure SetIAOReadOnly; // IAO RO
    {$ENDIF}

    {$IFDEF PERIODDEBUG}
    procedure CheckPeriods(Const Source : ShortString);
    {$ENDIF}

    Property BatchPayInUse[aIndex : Boolean]: Boolean read GetBatchPayInUse write SetBatchPayInUse;
  end;

var
  MainForm: TMainForm;

function EnumWndProc (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
function EnumWndProcRW (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
function EnumWndProcVisualRW (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;

procedure StartLogIn;
procedure DisplayLoginDialog;

{$IFDEF PERIODDEBUG}
Var
  PD_Enabled : Boolean;
  PD_InGetMultiSys : SmallInt;
  PD_InPutMultiSys : SmallInt;
  PD_Syss_Period : Byte;
  PD_Syss_Year : Byte;
  PD_Syss_DispAsMonths : Boolean;
  PD_User_Period : Byte;
  PD_User_Year : Byte;
  PD_User_DispAsMonths : Boolean;
{$ENDIF}

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}
{$R WinXPMan.Res}     // Windows XP Embedded Manifest File

uses ChildWin,
     StrUtils,
     EtMiscU,
     ETDateU,
     VarConst,
     VARFPosU,
     ETStrU,
     {$IFDEF DBD}
       DebugU,
     {$ENDIF}


     BTSupU3,
     ComnUnit,
     BTKeys1U,
     ColCtrlU,
     ComnU2,
     PWarnU,

     {$IFDEF GF}
       FindRecU,
       FindCtlU,
     {$ENDIF}


     {$IFDEF INV}
       SaleTx2U,
       RecepU,

       NomTfr2U,

     {$ENDIF}

     ObjDrilU,
     ExWrap1U,

     QtyBreakVar,

     ShellAPI,

     {$IFDEF SY}
       LoginF,
       AboutU,  
     {$ENDIF}

     SysU1,
     SysU2,

     {$IFDEF S2}
       SecSup2U,
       HelpSupU,
       SecureU,
       MURelU,
       SysU3,
     {$ENDIF}

     IntMU,

     {$IFDEF Frm}
       DllInt,
       PrintFrm,
       FaxIntO,
       rpDevice,

       SalTXL4U,
     {$ENDIF}

     {$IFDEF Rp}
       RepInp2U,
       RepInp3U,
       RepInp4U,
       RepInp5U,
       RepInp6U,
       RepInp7U,
       RepInp8U,
       RepInp9U,
       RepInpQU,
       RepInpSU,
       ReportU,
       Report2U,
       Report3U,
       Report4U,
       TraderTransOnHoldReport,
       TradersOnHoldReport,
       TradersOrderReport,

       {$IFDEF STK}
         ReportDU,

         {$IFDEF WOP}
         {$ENDIF}
       {$ENDIF}

       {$IFDEF JC}
          RepIJCEU,
          RepICI1U,
          RepICI3U,
          CISEDIWU,

          CISXMLWU,
       {$ENDIF}
     {$ENDIF}

     { IFDEF MH
       BtKeys1U,
       RepCustU,
     {$ENDIF}

     SpellUtil,
     Brand,
     EntLicence,
     uIceDripFeed,

     {$IFDEF LTE}
       IAOReadO, // MH RO
     {$ENDIF}

     {$IFDEF POST}
       PostInpU,
       PostingU,
       PostSp2U,
       ReValueU,

       BACSIU,
       BPyItemU,

       SQL_CheckAllAccounts,

       {$IFDEF SOP}
         SOPCT4U,

       {$ENDIF}

       UnPostU,
       UnPostIU,

       UnPostRU,

       {$IFDEF JC}
          JobPostU,

          CISVch2U,
          ObjCISMU,
          JobSup1U,
       {$ENDIF}

     {$ENDIF}

     {$IFDEF Nom}
       GLBnkRIU,

     {$ENDIf}

     {$IFDEF JC}
       JobTS1U,
     {$ENDIF}

     {$IFDEF STK}
       StkAdjU,

        {$IFDEF SOP}
          AltCRe2U,
        {$ENDIF}

        {$IFDEF RET}
          RetDoc1U,
          RetSup2U,
        {$ENDIF}
     {$ENDIF}

     {$IFDEF WOP}
      WORDoc2U,
     {$ENDIF}

     ExBtTh1U,

     {$IFNDEF BCS}
       ChkBCSU,
     {$ENDIF}

     {$IFDEF SY}
       ChngComp,
       PathUtil,

       {$IFDEF Bureau}
         CompLstF,

       {$ENDIF}
     {$ENDIF}

     GenWarnU,

     {$IFDEF CU}
       CustIntU,
       ComServ,
       Event1U,
       CustWinU,
     {$ENDIF}

     {$IFDEF MEMMAP}
       MemMap,
     {$ENDIF}

     BtrvU2,

     {$IFDEF JAP}
       JCAPPD2U,
       JobApWzU,
       RepIJCPU,
     {$ENDIF}

     {FaxIntO,}

     {$IFDEF HM} // EndSession
       Dbg,
     {$ENDIF}

     {$IFDEF ENAL503}
       AllcWizU, {Do we need this as not accessed from EparentU}
       LedgSu2U, {Do we need this as it is for PayRight which would not get called from here when the new alloc routine is finished}
       CurrncyU, {Do we need this as it is for PayRight which would not get called from here when the new alloc routine is finished}
     {$ENDIF}

    //PR 21/03/06 Added for eBanking & Bank Reconciliation
    {$IFDEF EBANK}
      BankList,
      RecInp,
      RecReprt,
    {$ENDIF}

    {$IFDEF GLCCDEBUG}
      SQLUtils,
    {$ENDIF}

    {$IFDEF EXSQL}
      SQLUtils,
      ADOConnect,
    {$ENDIF}

    {$IFDEF MADEXCEPT}
      MadExceptSupport,
    {$ENDIF}

     ECSalesCriteriaDlgU,

     // MH 04/11/2010 v6.5 ABSEXCH-9521: Rewrote Change My Password process as it was shockingly shoddy
     ChangePwordF,

     // MH 01/03/2011 v6.7 ABSEXCH-10687: Added Trader Audit Trail
     AuditIntf,
     AuditF,

     Diary,

     ECBUtil,
     CmpCtrlU,

     // MH 02/09/2011 v6.8 - Added Internal Logging Subsystem
     EntLoggerClass,

     //PR: Added user access constants file
     UA_Const,
     UserFieldConfig,

     CustomFieldsIntf,
     AuditNoteReportDialog,
     UpgradeInfo,

     // MH 17/10/2014 ABSEXCH-13403: Force the Settings.Dat subsystem to look in the correct directory
     uSettings,

     // MH 29/10/2013 v7.X MRD1.1: Split Customer/Supplier Account Details out to own dalog for consumer mods
     RepInp_AccountDetails,

     // CJS 2012-03-19 - ABSEXCH-12203 - Check All Accounts, SQL improvements
     SQLRep_Config,

     {$IFDEF SOP}
       // MH 22/07/2014 v7.X Order Payments: Check for presence of Credit Card Payment Gateway Plug-In
       oCreditCardGateway,
       VATReturnWizardU,

       // MH 06/08/2015 2015-R1 ABSEXCH-16664: Added ObjectNorbert aka Order Payments Tracker window
       OrderPaymentsTrackerF,

       // MH 12/06/2015 Exch-R1 ABSEXCH-16494: Added Order Payments End of Day Payments Report
       RepInp_EndOfDayPayments,
     {$ENDIF}

     // PKR. 22/03/2016. Addition of RCT for Ireland.
//     oRCTGateway,

     { CJS 2013-08-09 - ABSEXCH-14525 - VAT100 form opens unnecessarily }
     VATSub,

     // CJS 2015-02-23 - ABSEXCH-16133 - SQL version of Check All Job Totals
     SQLCheckAllJobsFrmU,

     //PR: 05/01/2015 ABSEXCH-15961
     UnallocateInputForm,

     {$IFDEF STK}
       SQL_CheckCustomerStockAnalysis,
     {$ENDIF}

     // MH 10/01/2017 2017R1 ABSEXCH-17996: Added support for Information Table
     oInformationTable, InformationTableFuncs,

     VarRec2U,
     oUserIntf,
     oUserDetail,

     // CJS 2015-12-16 - ABSEXCH-xxxxx - Intrastat amendments for 2016 R1
     WM_Const,
     IntrastatControlCentreF,
     // TG: 10/02/2017- R1 ABSEXCH-17026 - pop up for accurals report filter
     {$IFDEF RP}
       AccrualRepDlg,
     {$ENDIF}
     // CJS 2016-06-29 - ABSEXCH-17383 - eRCT
     oRCTGateway,
     AuthenticateUserUtil,
     oProcessLock,
     UserProfileF,
     PasswordComplexityConst,
     ChangePasswordF,
     oSystemSetup,
     AnonymisationControlCentreF,

     oPIIScanner,

     // MH 26/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
     oExcelExport, ExportProgressF,

     // MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
     SQLPostingPromptF;

{$I SecCode.Pas}

Const
  RepWrtExe = 'EnRepWrt.Exe';

Var
  ExitSave  :  Pointer;
  ICCFrm: TfrmIntrastatControlCentre;


  { Declaration of Customisation function in the DLL }
  Procedure CustomMenus (EntInfo : ptrEntCustomInfo); External 'EntCustm.Dll';
  Procedure CloseCustomMenus; External 'EntCustm.Dll';

Procedure TMainForm.DrawBkGnd(Var Message  :  TMessage);
Var
  MyDC       : hDC;
//  Ro, Co     : Word;
  OldPalette : HPalette;
  BackgroundRect: TRect;
//  X, Y,
  bgHeight, bgWidth, clTop, clRight, trLeft, trBottom: Integer;
//  BlitResult: Boolean;
Begin
  MyDC := TWMEraseBkGnd(Message).DC;

  OldPalette:=SelectPalette(MyDC,imgCentreLeft.Picture.BitMap.Palette,False);
  try
    RealizePalette(MyDC);

    (***
    { CJS 2012-09-07 ABSEXCH-12952 - Rebranding - Background bitmap handling }
    X := 0;
    Y := self.ClientHeight - StatusBar.Height - AdvToolbar.Height - 6 - Image1.Picture.Height;
    if (Y < 0) then
      Y := 0;

    BackgroundRect := Rect(0, 0, ClientWidth, Y);
    FillRect(MyDC, BackgroundRect, clWhite);

    BackgroundRect := Rect(Image1.Picture.Width, Y, ClientWidth, ClientHeight - StatusBar.Height - 6 - AdvToolbar.Height);
    FillRect(MyDC, BackgroundRect, clWhite);

    BlitResult := BitBlt(MyDC, 0, Y, Image1.Picture.Width, Image1.Picture.Height,
                         Image1.Picture.Bitmap.Canvas.Handle, 0, 0, SRCCOPY);
    if not BlitResult then
      OutputDebugString('BitBlt failed');
    ***)

    //
    // To avoid flickering the background is painted in 6 blocks
    //
    //    +----------+--------+--------+
    //    |          |        |   TR   |
    //    |    B1    |        +--------+
    //    |          |        |        |
    //    +----------+        |        |
    //    |    CL    |   B3   |        |
    //    +----------+        |   B4   |
    //    |          |        |        |
    //    |    B2    |        |        |
    //    |          |        |        |
    //    +----------+--------+--------+
    //

    // Calculate the height of the area we are putting the background in
    bgHeight := self.ClientHeight - StatusBar.Height - AdvToolbar.Height - 6; // WTF does 6 come from?
    bgWidth := Self.ClientWidth; // - GetSystemMetrics(SM_CXVSCROLL) - 4;

    // Calculate the position of the Centre-Left bitmap (CL)
    clTop := (bgHeight - imgCentreLeft.Picture.Height) Div 2;
    clRight := imgCentreLeft.Picture.Width;

    // Calculate the position of the Top-Right bitmap (TR)
    trLeft := bgWidth - imgTopRight.Picture.Width;
    trBottom := imgTopRight.Picture.Height;

    // Paint in background B1 above Centre-Left bitmap
    BackgroundRect := Rect(0, 0, clRight, clTop);  // LTRB
    FillRect(MyDC, BackgroundRect, clRed);//clWhite);

    // Paint in background B2 below Centre-Left bitmap
    BackgroundRect := Rect(0, clTop + imgCentreLeft.Picture.Height, clRight, bgHeight);  // LTRB
    FillRect(MyDC, BackgroundRect, clWhite);

    // Paint in Centre-Left bitmap (CL)
    BitBlt(MyDC, 0, clTop, imgCentreLeft.Picture.Width, imgCentreLeft.Picture.Height,
           imgCentreLeft.Picture.Bitmap.Canvas.Handle, 0, 0, SRCCOPY);

    If ((clRight + 1) < trLeft) Then
    Begin
      // Paint in central background column B3
      BackgroundRect := Rect(clRight, 0, trLeft, bgHeight);  // LTRB
      FillRect(MyDC, BackgroundRect, clWhite);
    End; // If ((clRight + 1) < trLeft)

    // Paint in Top-Right bitmap (TR)
    BitBlt(MyDC, trLeft, 0, imgTopRight.Picture.Width, imgTopRight.Picture.Height,
           imgTopRight.Picture.Bitmap.Canvas.Handle, 0, 0, SRCCOPY);

    // Paint in background B4 below Top-Right bitmap
    BackgroundRect := Rect(trLeft, imgTopRight.Picture.Height, bgWidth, bgHeight);  // LTRB
    FillRect(MyDC, BackgroundRect, clWhite);
  finally
    SelectPalette(MyDC,OldPalette,true);
  end; {try..}
end;


procedure TMainForm.ResetPalette(Var Message  : TMessage);

Var
  MyDC       : hDC;
  OldPalette : HPalette;


Begin

  MyDC:=GetDC(Self.Handle);

  try
    OldPalette:=SelectPalette(MyDC,imgCentreLeft.Picture.BitMap.Palette,False);

    try
      Message.Result:=RealizePalette(MyDC);

    finally

      SelectPalette(MyDC,OldPalette,true);
    end;

  finally

    ReleaseDC(Self.Handle,MyDC);

  end;

end;


procedure TMainForm.ClientWndProc(VAR Message: TMessage);


begin
  with Message do
  Begin
    {ReDrawBk:=((Msg=WM_HSCROLL) or (Msg=WM_VSCROLL));}


    If (Not HideBkGnd) and (Not Syss.HideEXLogo) and (Not NoXLogo) then
    Begin
      case Msg of
        WM_ERASEBKGND:
          begin
            DrawBkGnd(Message);
            Result := 1;
          end;
        WM_KeyDown:
          begin
            WMKeyDown(Message);

          end;

        WM_VSCROLL, WM_HSCROLL :
          begin
            InvalidateRect(ClientHandle, nil, True);
            Result := CallWindowProc(FPrevClientProc, ClientHandle, Msg, wParam, lParam);
          end;

        WM_QUERYNEWPALETTE  :
          ResetPalette(Message);

        WM_PALETTECHANGED  :
          If (LongWord(WParam)<>Self.Handle) then
            ResetPalette(Message);

      else
      Begin
        If (Assigned(FPrevClientProc)) then
          Result := CallWindowProc(FPrevClientProc, ClientHandle, Msg, wParam, lParam);
      end;
      end;
    end
    else
    Begin
      case Msg of
        WM_KeyDown:
          begin
            WMKeyDown(Message);

          end;

      else
        Result := CallWindowProc(FPrevClientProc, ClientHandle, Msg, wParam, lParam);
      end;


    end;



  end; {With..}
end;


Procedure TMainForm.WMQueryNewPalette(Var Message  :  TMessage);

Begin
  ResetPalette(Message);
end;

Procedure TMainForm.WMPaletteChanged(Var Message  :  TMessage);

Begin
  If (LongWord(Message.WParam)<>Self.Handle) then
    ResetPalette(Message);
end;

procedure TMainForm.WMCopyData(var Msg: TWMCopyData);
{$IFDEF FRM}
  Var
    CopyDataRec : EntCopyDataRecType;
  Begin { WMCopyData }
    // Move the Drill-down info from the message into a local record
    With Msg.CopyDataStruct^ Do
      Move (lpData^, CopyDataRec, cbData);

    // Check the generic structure to determine the data type
    With CopyDataRec Do
      Case DataId Of
        // Drill Down
        1   : Begin
                //Display_ReportDrillDown(CopyDataRec,Self);

                Report_DrillDown(CopyDataRec);
              End; { Drill-Down }
      End; { Case DataId  }
{$ELSE}
  Begin
{$ENDIF}
End; { WMCopyData }


{$IFDEF FRM}
  Procedure TMainForm.Report_DrillDown(RepDataRec : EntCopyDataRecType);

  Var
    RepDrillDown  :  TFRepDisplay;
  Begin
    If (Not Assigned(RepDrillDownPtr)) then
    Begin
      RepDrillDown:=TFRepDisplay.Create(Self);
      RepDrillDownPtr:=RepDrillDown;
    end
    else
      RepDrillDown:=RepDrillDownPtr;

    Try
      RepDrillDown.LinkDDToDisplay(RepDataRec);
    except
      RepDrillDown.Free;
      RepDrillDownPtr:=nil;
    end; {try..}

  end; {Proc..}

{$ENDIF}



procedure TMainForm.ApplicationActive(Sender  :  TObject);

Var
  Message  :  TMessage;
Begin

  FillChar(Message,Sizeof(Message),0);

  ResetPalette(Message);

  MDI_ForceParentBKGnd(BOn);


  Application.Title:=Branding.pbProductName+'.'+Syss.UserName



end;

{$IFDEF NONVISTA}


  Procedure TMainForm.Set_NonClientInfo;

  Var

    MCCancel   :  Boolean;
    SBW,SBH    :  Integer;


  Begin
    MCCancel:=BOff;

    KeybDelay:=-1;
    KeybSpeed:=65535;

    // HM 11/08/03: Added flag to control whether the scrollbar size gets reset - causes
    //              tray icon corruption under Windows XP - AOK on all other OS's
    If SetXPScrollSize Then
    Begin

      New(NCMetrics);
      New(ONCMetrics);

      FillChar(ONCMetrics^,Sizeof(ONCMetrics^),0);


      ONCMetrics^.cbSize:=Sizeof(ONCMetrics^);


      If (SystemParametersInfo(SPI_GETNONCLIENTMETRICS,0,ONCMETRICS,0)) then
      Begin
        With ONCMetrics^ do
        Begin
          Move(iScrollWidth,SBW,Sizeof(SBW));
          Move(iScrollHeight,SBH,Sizeof(SBH));
        end;

        If (SBW<>16) or (SBH<>16) then
        With NCMetrics^ do
        Begin
          NCMetrics^:=ONCMetrics^;

          SBW:=16;
          SBH:=16;

          Move(SBW,iScrollWidth,Sizeof(SBW));
          Move(SBH,iScrollHeight,Sizeof(SBH));

          MCCancel:=Not SystemParametersInfo(SPI_SETNONCLIENTMETRICS,0,NCMETRICS,{SPIF_SENDWININICHANGE}0);
        end
        else
          MCCancel:=BOn;

      end
      else
        MCCancel:=BOn;

      If (MCCancel) then
      Begin
        Dispose(ONCMetrics);
        ONCMetrics:=nil;

        Dispose(NCMetrics);
        NCMetrics:=nil;
      end;
    end; {If XPScrollSize set}

    If (Not Debug) then
    Begin
      If (SystemParametersInfo(SPI_GETKEYBOARDDELAY,0,@KeybDelay,0)) then
      Begin
        MCCancel:=SystemParametersInfo(SPI_SETKEYBOARDDELAY,2,nil,0);

        {If (MCCancel) then
          SystemParametersInfo(SPI_GETKEYBOARDDELAY,0,@KeybDelay,0)}

      end;

      If (SystemParametersInfo(SPI_GETKEYBOARDSPEED,0,@KeybSpeed,0)) then
      Begin
        MCCancel:=SystemParametersInfo(SPI_SETKEYBOARDSPEED,15,nil,0);

        {If (MCCancel) then
          SystemParametersInfo(SPI_GETKEYBOARDSPEED,0,@KeybSpeed,0)}

      end;
    end; {If only set if not in debug mode }

  end;
{$ENDIF}


Procedure TMainForm.Set_NonClientInfo;

Var

  MCCancel   :  Boolean;
  SBW,SBH    :  Integer;


Begin
  MCCancel:=BOff;

  KeybDelay:=-1;
  KeybSpeed:=65535;

  // HM 11/08/03: Added flag to control whether the scrollbar size gets reset - causes
  //              tray icon corruption under Windows XP - AOK on all other OS's

  // MH 13/11/06: Disabled for Vista as it causes unpainted gaps to appear, which get bigger
  //              and BIGGER every time Exchequer is run
  // MH 08/05/2013 v7.0.4 ABSEXCH-12022: Added support for Windows 7, Windows 8 and Windows Server 2012
  If (GetWindowsVersion < wvVista) And SetXPScrollSize Then
  Begin

    New(NCMetrics);
    New(ONCMetrics);

    FillChar(ONCMetrics^,Sizeof(ONCMetrics^),0);


    ONCMetrics^.cbSize:=Sizeof(ONCMetrics^);


    If (SystemParametersInfo(SPI_GETNONCLIENTMETRICS,0,ONCMETRICS,0)) then
    Begin
      With ONCMetrics^ do
      Begin
        Move(iScrollWidth,SBW,Sizeof(SBW));
        Move(iScrollHeight,SBH,Sizeof(SBH));
      end;

      If (SBW<>16) or (SBH<>16) then
      With NCMetrics^ do
      Begin
        NCMetrics^:=ONCMetrics^;

        SBW:=16;
        SBH:=16;

        Move(SBW,iScrollWidth,Sizeof(SBW));
        Move(SBH,iScrollHeight,Sizeof(SBH));

        MCCancel:=Not SystemParametersInfo(SPI_SETNONCLIENTMETRICS,0,NCMETRICS,{SPIF_SENDWININICHANGE}0);
      end
      else
        MCCancel:=BOn;

    end
    else
      MCCancel:=BOn;

    If (MCCancel) then
    Begin
      Dispose(ONCMetrics);
      ONCMetrics:=nil;

      Dispose(NCMetrics);
      NCMetrics:=nil;
    end;
  End; // If (GetWindowsVersion < wvVista) And SetXPScrollSize

  If (Not Debug) then
  Begin
    // MH 13/11/06: Disabled for Vista as under the guidelines this counts as malware
    //If (GetWindowsVersion <> wvVista) Or (FindCmdLineSwitch('DoKBDelay', ['/', '-'], True)) Then
    // MH 04/11/06: Disabled as standard as slows down ability to scroll in lists
    If (FindCmdLineSwitch('DoKBDelay', ['/', '-'], True)) Then
    Begin
      If (SystemParametersInfo(SPI_GETKEYBOARDDELAY,0,@KeybDelay,0)) then
      Begin
        MCCancel:=SystemParametersInfo(SPI_SETKEYBOARDDELAY,2,nil,0);

        {If (MCCancel) then
          SystemParametersInfo(SPI_GETKEYBOARDDELAY,0,@KeybDelay,0)}
      end;
    End; // If (GetWindowsVersion <> wvVista) Or (FindCmdLineSwitch('DoKBDelay', ['/', '-'], True))

    // MH 13/11/06: Disabled for Vista as under the guidelines this counts as malware
    //If (GetWindowsVersion <> wvVista) Or (FindCmdLineSwitch('DoKBSpeed', ['/', '-'], True)) Then
    // MH 04/11/06: Disabled as standard as slows down ability to scroll in lists
    If (FindCmdLineSwitch('DoKBSpeed', ['/', '-'], True)) Then
    Begin
      If (SystemParametersInfo(SPI_GETKEYBOARDSPEED,0,@KeybSpeed,0)) then
      Begin
        MCCancel:=SystemParametersInfo(SPI_SETKEYBOARDSPEED,15,nil,0);

        {If (MCCancel) then
          SystemParametersInfo(SPI_GETKEYBOARDSPEED,0,@KeybSpeed,0)}
      end;
    End; // If (GetWindowsVersion <> wvVista) Or (FindCmdLineSwitch('DoKBSpeed', ['/', '-'], True))
  end; {If only set if not in debug mode }
end;



Procedure TMainForm.Reset_NonClientInfo;

Begin
  If (Assigned(ONCMetrics)) And SetXPScrollSize then
  Begin
    SystemParametersInfo(SPI_SETNONCLIENTMETRICS,0,ONCMETRICS,{SPIF_SENDWININICHANGE}0);

    Dispose(ONCMetrics);
    ONCMetrics:=nil;

    Dispose(NCMetrics);
    NCMetrics:=nil;
  end;

  If (KeybDelay<>-1) then
    SystemParametersInfo(SPI_SETKEYBOARDDELAY,KeybDelay,nil,0);

  If (KeybSpeed<>65535) then
    SystemParametersInfo(SPI_SETKEYBOARDSPEED,KeybSpeed,nil,0);
end;

(*
procedure TMainForm.Load_ThemeLogo(LNo  :  Byte);
// Load background bitmap from ECB File
var
  EuroImage  : TBitMap;
  RectD      : TRect;
  sECBFile : string;
  iBitmapNo : byte;
begin
  try
    iBitmapNo := LNo;

    //sECBFile := GetECBFilename(waEnterprise, iBitmapNo, Self, SBSPanel1.Height + SpeedPanel.Height);
    sECBFile := GetECBFilename(waEnterprise, iBitmapNo, Self, SBSPanel1.Height + AdvDockPanel.Height);
    EuroImage := GetBitmapFromECB(sECBFile);
    //GetCentreOfBitmap(EuroImage, Self, SBSPanel1.Height + SpeedPanel.Height);
    GetCentreOfBitmap(EuroImage, Self, SBSPanel1.Height + AdvDockPanel.Height);

    if (Assigned(EuroImage)) then
    begin
      with EuroImage do
      begin
        RectD:=Rect(0,0,Width,Height);
      end;{with}

      with Image1.Picture.Bitmap do
      begin
        Width:=RectD.Right;
        Height:=RectD.Bottom;

        DeleteObject(Image1.Picture.BitMap.Palette);
        Image1.Picture.BitMap.Palette:=CopyPalette(EuroImage.Palette);
        Image1.Picture.Bitmap.Canvas.CopyRect(RectD,EuroImage.Canvas,RectD);
      end;{with}

    end;{if}
  finally
      if (Assigned(EuroImage)) then
        EuroImage.Free;

      { CJS 2012-09-07 ABSEXCH-12952 - Rebranding - Background bitmap handling }
      BackgroundLoaded := True;

      SysHandle:=0;
  end;{try}
end;
*)

(*
{* Load other logo bitmaps from DLL *}
procedure TMainForm.Load_Logo(LNo  :  Byte);

Var
  EuroImage  : TBitMap;
  RectD      : TRect;
  L          : Pointer;
  DLLNo      : Byte;
  DLLName    : PChar;

  {SysHandle  :  THandle;}
  {Replace_Image  :  Function (INo     :  Byte;
                              Unload  :  Boolean)  :  Pointer; stdcall;}

begin
  If (LNo=0) then
    DLLNo:=1
  else
    DLLNo:=LNo;

  {* All bit maps were taken out to 4 seperate DLL's (ENTSM1-4) in v4.30a to reduce size of exe *}
  {* A small peice of the bit map has been retained to initialise the palette properly *}

  DLLName:=StrAlloc(255);

  StrPCopy(DLLName,'ENTSM'+Form_Int(DLLNo,0)+'.DLL');

  SysHandle:=LoadLibrary(DLLName);

  If (SysHandle<>0) then
  Begin
    Replace_Image:=GetProcAddress(SysHandle,'GET_IMAGE');

    try
      L:=Replace_Image(LNo,FALSE);

      EuroImage:=TBitMap(L);

      If (Assigned(L)) then
      Begin
        With EuroImage do
          RectD:=Rect(0,0,Width,Height);

        With Image1.Picture.Bitmap do
        Begin
          Width:=RectD.Right;
          Height:=RectD.Bottom;

          DeleteObject(Image1.Picture.BitMap.Palette);

          Image1.Picture.BitMap.Palette:=CopyPalette(EuroImage.Palette);

          Image1.Picture.Bitmap.Canvas.CopyRect(RectD,EuroImage.Canvas,RectD);

        end;
      end;
    Finally
      HideBkGnd:=(Not Assigned(L));

      If (Not Assigned(L)) then {* It has failed so unload}
      Begin

        {* v4.31 The call to Replace_Image to destroy the temp bitmap was taken out of here as it crashed due to
           a timing conflict with the background tiler.  It now gets called from inside the timer event upon loading
           and this is alsowhere the DLL is unloaded.

           We stopped unloading the DLL in v4.24 as there seemed to be a connection between the graph crashing
           and the unloading of the DLL, if the graph starts crashing again then remove it *}

        Replace_Image:=nil;

        {* This was taken out v4.24b as it caused the graph to crash! on some machines, mainly with IE4/Win98 installed. *}
        {* Reinstated in v4.31 to be called if the whol process fails. *}
        FreeLibrary(SysHandle);

        SysHandle:=0;
      end;
    end;

  end
  else
    ShowMessage(SysErrorMessage(GetLastError));

  StrDispose(DLLName);

end;
*)

{* Load other logo bitmaps from DLL *}
procedure TMainForm.Load_TileLogo(LNo  :  Byte);
Begin
{ CJS 2012-09-07 ABSEXCH-12952 - Rebranding - Background bitmap handling }
(*
  {$IFDEF DBD}
    {$B-}
    If (FileExists(GetECBFilename(waEnterprise, Syss.BKThemeNo, Self, SBSPanel1.Height + AdvToolbar.Height))) then
    {$B+}
      Load_ThemeLogo(Syss.BKThemeNo)
    else
      Load_Logo(LNo);
  {$ELSE}
      // MH 04/10/07: Always use Theme's for v6.00 as the old ENTSM DLL's are not supported
      Load_ThemeLogo(Syss.BKThemeNo);
  {$ENDIF}
*)
end;

procedure SetEnSecurity;

Begin
  {$IFNDEF DBD}
    EnSecurity:=Debug or Check_ModRel(15,BOn); {*Get release code*}
  {$ELSE}
    EnSecurity:=BOn;
  {$ENDIF}


end;


procedure TMainForm.Release_Modules(LogoNo  :  Byte);

Begin
  {$IFDEF S2}

    {* Check if EuroVersion *}

    {$IFDEF MC_On}

      EuroVers:=Not Check_ModRel(1,BOn); {* Full MC not set *}

      Ver:=Set_EuroVer;

      If (EuroVers) then {* Set Euro Background bit map *}
      Begin
        StdCurrList.Free;

        Init_STDCurrList;

        If (LogoNo=0) then { Its an 800 screen }
          LogoNo:=3
        else
          If (LogoNo=5) then {Its 1024}
            LogoNo:=6
          else
            LogoNo:=4;  {Its 640 }
      end;

    {$ELSE}

      EuroVers:=BOff;

    {$ENDIF}

    {$IFDEF PF_On}

      {$IFNDEF JC}
        If (JBCostOn) then
      {$ENDIF}

        JBCostOn:=Check_ModRel(2,BOn);


      {$IFDEF JC}
        If (JBCostOn) then
        Begin
          {$IFNDEF DBD}
            CISOn:=(Check_ModRel(16,BOn) or Debug);
          {$ELSE}
            CISOn:=BOn;
          {$ENDIF}

          GlobLocked:=BOff;

          {Initialise CIS Page}
          If GetMultiSys(BOff,GlobLocked,CISR) then
            Init_STDCISList;

          {$IFDEF JAP}

             {$IFNDEF DBD}
               FullJAP:=(Check_ModRel(17,BOn) or Debug);
             {$ELSE}
               FullJAP:=BOn;
             {$ENDIF}

             {STDJAP:=Check_ModRel(12,BOn);}

             JAPOn:=FullJAP { or StdJAP};

          {$ENDIF}


        end;
      {$ENDIF}

      {$IFDEF SOP}

        TeleSModule:=Check_ModRel(5,BOn);

        {$IFNDEF DBD}
          CommitAct:=Check_ModRel(10,BOn);  {*EX431*}
        {$ENDIF}

      {$ENDIF}

      {$IFDEF STK}
        If (TeleSModule) then {* Auto Release *}
          AnalCuStk:=TeleSModule
        else
          AnalCuStk:=Check_ModRel(6,BOn);

        CheckCustomerStockAnalysis1.Visible := AnalCuStk;

        {$IFDEF WOP}

           FullWOP:=Debug or Check_ModRel(13,BOn);
           STDWOP:=Check_ModRel(12,BOn);

           WOPOn:=FullWOP or StdWOP;

        {$ENDIF}

         {$IFDEF DBD}

           RetMOn:=BOn;
           {WOPOn:=BOn;}
         {$ELSE}

           RetMOn:=Check_ModRel(20,BOn) or Debug;

         {$ENDIF}


        {$IFNDEF DBD}
            FullStkSysOn:=(Check_ModRel(18,BOn) or Debug or WOPOn);
        {$ELSE}
            FullStkSysOn:=BOn;
        {$ENDIF}

        If (Not FullStkSysOn) then
        Begin
          Try
            STDStkTList.Free;
            STDStkTList:=nil;

            Init_STDStkTList;
          except;

          end; {try..}

        end;

      {$ENDIF}

      {$IFNDEF DBD}
        eBusModule:=Check_ModRel(7,BOn);
        eCommsModule:=Check_ModRel(8,BOn);

      {$ELSE}

      {$ENDIF}

      SetEnSecurity;

    {$ENDIF}

    If (RepWrtOn) then
      RepWrtOn:=Check_ModRel(3,BOn);

    If VRWOn Then
      VRWOn := Check_ModRel(19,BOn);

    // MH 10/01/07: Added checks on eBanking and Outlook Dynamic Dashboard modules as otherwise a
    // 30-day code may never expire
    {$IFDEF EBANK}
      EBankOn:=Check_ModRel(21,BOn);
    {$ENDIF}
    ODDOn:=Check_ModRel(22,BOn);

    // MH 24/04/07: Added check on Importer release code as otherwise the 30-day code may never expire
    Check_ModRel(23,BOn);

    // MH 16/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
    GDPROn:=Check_ModRel(24,BOn);
  {$ENDIF}

  //HV 09/11/2017 2018-R1: Highlighting PII Fields flag for GDPR
  GDPRColor := UserProfile.HighlightPIIColour;
  IsGDPROn := GDPROn and UserProfile.HighlightPIIFields;

  // MH 10/01/2017 2017R1 ABSEXCH-17996: Added support for Information Table
  If SQLUtils.UsingSQL Then
  Begin
    // Update the Information Table from the Global SyssMod^ record that could have been changed above
    InformationTableFuncs.CheckModuleReleaseCodes (True);
    InformationTableFuncs.CheckExchequerModuleLevel (True);
  End; // If SQLUtils.UsingSQL

  {If (LogoNo<>0) then}


  //{$IFNDEF DBD}  {*EN431}
      If (Not Syss.HideEXLogo) and (Not NoXLogo) then
      Begin
        If (Not CheckedDiary) or (FromReLogOn) then {Do not bother replacing the screen on company re-open unless it is a theme}
          Load_TileLogo(LogoNo)
      end
      else
        HideBkGnd:=BOn;
  //{$ELSE}

  //{$ENDIF}

end;


procedure TMainForm.FormCreate(Sender: TObject);

Var
  CDir  :  Str255;

  LogoNo:  Byte;
  n     :  Integer;
begin
  // MH 03/10/2016 2016-R3 ABSEXCH-17754: Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := 700 + (Self.Width - Self.ClientWidth);  // Adjust for variable border widths
  MinSizeY := 400 + (Self.Height - Self.ClientHeight);  // Adjust for variable border widths

  { CJS 2012-09-07 ABSEXCH-12952 - Rebranding - Background bitmap handling }
  BackgroundLoaded := False;
  DoubleBuffered := True;

  EntBeenTidy:=BOff;

  EntInCloseQ:=BOff;
  InWarnLowMem:=BOff;
  InReLogin:=BOff;

    {$IFDEF DBD}
      InitBranding(SetDrive); // Not Necessary at run time taken from Main Co direct not data set directory
    {$ENDIF}

    // MH 05/04/2017 2017-R1 ABSEXCH-18571: Different icon for core Exchequer
    If (Branding.pbProductName <> 'Exchequer') Then
      Application.Icon:=Branding.pbProductIcon;
    Application.Title:=Branding.pbProductName;

    // MH 20/11/2012 v7.0 ABSEXCH-13736: Moved background bitmap out to branding files to allow SBE customisation
    With Branding.BrandingFile('E8263') Do
    Begin
      ExtractImageCD (imgCentreLeft, 'back-centre-left');
      ExtractImageCD (imgTopRight, 'back-top-right');
    End; // With Branding.BrandingFile('E8263')

  {$IFDEF SY}
    Application.OnException:=EntException;

    Application.OnDeactivate:=EntDeActivate;
    Application.OnMinimize:=EntDeActivate;
    Application.OnRestore:=ApplicationActive;
  {$ENDIF}

  Application.OnHint := ShowHint;
  {Application.HintColor:=clAqua;}
  Application.Hintpause:=500;

  Application.OnActivate:=ApplicationActive;

  Application.UpdateFormatSettings:=BOff;

  {Application.OnIdle:=CheckEntIdle; No good for auto log out as only gets called once}

  Application.OnMessage := AppMessage;

  {$IFDEF HTMLHELP}
    Application.HelpFile := ExtractFileDir(ParamStr(0))+'\ENTRPRSE.CHM';
  {$ELSE}
  {$IFDEF HU}
    Application.HelpFile := ExtractFileDir(ParamStr(0))+'\ENTRPRSE.HLP';
  {$ENDIF}
  {$ENDIF}

  Screen.OnActiveFormChange := UpdateMenuItems;

  HideBkGnd:=BOff;

  SysHandle:=0;

  Replace_Image:=nil;

  LogoNo:=0;

  // HM 11/08/03: Added flag to control whether the scrollbar size gets reset - causes
  //              tray icon corruption under Windows XP - AOK on all other OS's
  //If (IS_WINXPStyle) Then
  // MH 08/05/2013 v7.0.4 ABSEXCH-12022: Modified to use standard function / set in APIUtil to
  //                                     determine whether to mess around with the UI.  This includes
  //                                     support for Windows 7, Windows 8 and Windows Server 2012
  If (GetWindowsVersion In wvXPStyle) Then
    SetXPScrollSize := FindCmdLineSwitch('XPSCROLL', ['-', '/', '\'], True) Or
                       FindCmdLineSwitch('XPSCROLL:', ['-', '/', '\'], True)
  Else
    SetXPScrollSize := True;
{$WARN SYMBOL_DEPRECATED OFF}
  FClientInstance := MakeObjectInstance(ClientWndProc);
{$WARN SYMBOL_DEPRECATED ON}

  FPrevClientProc := Pointer(GetWindowLong(ClientHandle, GWL_WNDPROC));
  SetWindowLong(ClientHandle, GWL_WNDPROC, LongInt(FClientInstance));

  // HM 09/10/00: Set Tag to 1011, so window can be ID'd uniquely from other programs.
  //              Used by SBSFORM.DLL to Id Enterprise for notification messages
  SetWindowLong (Handle, GWL_USERDATA, 1011);


  { Call menu customisation }
  GetMem (EntInfo, SizeOf (EntInfo^));
  FillChar (EntInfo^, SizeOf (EntInfo^), #0);
  With EntInfo^ Do Begin
    AppInst  := Application;      { Enterprise Application Instance }
    EntMenus := MainMenu1;        { Enterprise Main Menu object }
    NewMenu  := NewMenuItem;      { Function to return new menu option }
    ScrnInst := Screen;           { Enterprise Screen Instance }
  End; { With }

  // MH 02/09/2011 v6.8 - Start Internal Logging Subsystem
  StartLogging(SetDrive);

  {$IFDEF CU} {* Initialise customisation DLL *}
    CustomMenus (EntInfo);

    InitCustomisation;
  {$ENDIF}

  {$IFDEF DBD}
    Begin
      DeBugForm:=TDebugForm.Create(Self);

      {For n:=0 to Pred(Printer.Printers.Count) do
        DebugForm.Add(SetN(n)+' '+Printer.Printers[n]);}

      DebugForm.Add('Main Height'+InttoStr(Self.Height));
      DebugForm.Add('Screen width '+InttoStr(Screen.Width));
      DebugForm.Add('Screen height '+InttoStr(Screen.Height));

    end;

  {$ENDIF}

  Set_NONClientInfo;

  XXXRPos.Visible:=Debug;

  {$IFDEF DBD} {OTC_Hang}
    XXXSDebug.Visible:=BOn;
  {$ELSE}
    XXXSDebug.Visible:=Debug;

  {$ENDIF}

  // MH 12/03/09: Added to enable testing of MadExcept error handling
  XXXBang.Visible := FindCmdLineSwitch('Bang', ['\','/','-'], True);

  if (SetDrive='') then
  Begin
    GetDir(0,Cdir);

  end
  else
    Cdir:=SetDrive;

    fDriveNo:=Ord(UPCase(CDir[1]))-64;

  fDiskSize:=DiskSize(fDriveNo);


  If (fDiskSize<-1) then
    fDiskSize:=MaxLongInt+fDiskSize;

  UpDate_DriveResource;

  InTradeList:=0;

  InObjDrill:=BOff;
  ObjDrillPtr:=nil;
  InStkTree:=BOff;
  InJobTree:=BOff;
  InStkList:=0;

  Ignore_HT:=BOff;

  {$IFDEF C_On}
    HotCust:=nil;
  {$ENDIF}

  {$IFDEF Stk}
    HotStock:=nil;

    {$IFDEF SOP}
      MLocList:=nil;
    {$ENDIF}

    {$IFDEF RET}
      RetLTList:=nil;
    {$ENDIF}

    {$IFDEF LTE}
      StkMoveList :=nil;
    {$ENDIF}

    ObjectStkEnq:=nil;
    ObjectPrice:=nil;
  {$ENDIF}


  {$IFDEF NP}
    GlobDiary:=nil;
  {$ENDIF}

  {$IFDEF POST}
      ObjectCC:=nil;
  {$ENDIF}

  {$IFDEF JC}
    HotJob:=nil;
    EmplList:=nil;
    JAnalList:=nil;

  {$ENDIF}

  InCISVoucher:=BOff;
  InCISObjDrill:=BOff;
  CISObjDrillPtr:=nil;
  RepDrillDownPtr:=nil;

  FillChar(InSPDayBk,Sizeof(InSPDayBk),0);

  FillChar(InCCDep,Sizeof(InCCDep),0);

  { Check to see if Report Writer is available }
  RepWrtOn := FileExists(ExtractFilePath(Application.ExeName) + RepWrtExe);
  VRWOn := FileExists(ExtractFilePath(Application.ExeName) + 'EntRW.Exe');

  { Check if Multi-Company Manager is installed }

  {$IFDEF BUREAU}
    CompManOn := FileExists(ExtractFilePath(Application.ExeName) + 'enbureau.dll');
  {$ELSE}
    CompManOn :=BOff;
  {$ENDIF}

  If (Screen.Width<800) then
    LogoNo:=2
  else
    If (Screen.Width>800) then
      LogoNo:=5;

  { ======================== Enable Modules ================= }
  Release_Modules(LogoNo);
  { ============================================================ }


  {$IFDEF LTE}
    OrigCaption := Application.Title; {Iris Accounts Office';}
  {$ELSE}
    OrigCaption := Caption;
  {$ENDIF}

  NextInfoLabelTop := 0;  // IAO RO

  {$IF Defined(LTE) }


    {$IFDEF LTE}
      SetIAOReadOnly; // IAO RO
    {$ENDIF}

    Update_DripFeed;  //CS: Moved dripfeed code to routine as needs to be rerun on change of company

  {$IFEND}


  SetCaption;

  {$IFDEF MADEXCEPT}
    MadExceptSupport.AddLicenceInfo;
    // CJS 14/03/2011 - ABSEXCH-10885 - Extended Error Handling
    MadExceptSupport.PrepareErrorList(ExtractFilePath(Application.ExeName) + 'ErrorInfo.ini');
  {$ENDIF}

//  If (GetMaxColors(Self.Canvas.Handle)<2) or (Syss.UseClassToolB) then {Assign 16 bit speed buttons}
//  Begin
//    ToolBar.Images := ilTBar16Colour;
//    ToolBar.HotImages := nil;

//    FreeandNil(ilTBar24Bit);
//    FreeandNil(ilTBar24BitHot);
//    FreeandNil(ilMenu24Bit);

    //MainMenu1.Images:=IlMenu16Col;
//  end
//  else
//  Begin
//    ToolBar.Images := ilTBar24bit;
//    ToolBar.HotImages := ilTBar24BitHot;
    //MainMenu1.Images:=IlMenu24Bit;

//    FreeandNil(ilTBar16Colour);
//    FreeandNil(IlMenu16Col);

//  end;


  FormDesign;

  { Set tag height for preview form }
  //Tag := SpeedPanel.Height + StatusBar.Height;
  Tag := AdvDockPanel.Height + StatusBar.Height;

  { Load Forms DLL }


  {$IFDEF Frm}
    {PrintHwnd := -1;  Delphi 2 declaration}
    PrintHwnd := 0;

    With SystemInfo Do Begin
      ExVersionNo      := Which_ExVerNo;
      MainForm         := Self;
      AppHandle        := Application;
      ExDataPath       := SetDrive;
      ControllerHandle := Nil;
      DefaultFont      := Nil;
      DebugOpen        := False;
      {$IFDEF HM}
        {AppPrinter := Screen;}
      {$ENDIF}
    End; { With }

    If (Not sbsForm_Initialise(SystemInfo, Syss.TxLateCR)) Then Begin
      { Have failed to load the form designer dll }
      { Oh Dear! }
    End; { If }

    {*EN560 Issue notification event Co changed *}
    PostMessage(Self.Handle,WM_FormCloseMsg,222,0);

  {$ENDIF}

  {* Set Param version here for RW *}
  ExVersParam^:=Which_ExVers;

  {$IFDEF SY}
    (* HM 01/03/99: Removed so we can load ENTCOMP.DLL dynamically to reduce memory usage
    If CompManOn Then
      InitCompDll(Application);
    *)
  {$ENDIF}

   // CA  04/06/2012   v7.0  ABSEXCH-12302:    Startup Upgrade Info Window
   PostedUpgradeInfoMsg     := BOff;

   // MH 08/01/2018 2017-R1 ABSEXCH-19316: Changed display mechanism for SQL Posting Prompt Dialog
   ShownSQLPostingPrompt := False;

   CheckedDiary:=BOff;
   FromReLogOn:=BOff;

  // Initialise the last action time to prevent the check going off straight away
  SetLastActionTime;

  Gauge2.Visible:=Not IsAnyWINNT;

  If (Not Gauge2.Visible) then
  Begin
    Gauge3.Parent:=Gauge2.Parent;
    Gauge3.Visible:=BOn;
  end;

  {$IFDEF EXSQL}
  If SQLUtils.UsingSQL Then
    InitialiseGlobalADOConnection (SetDrive);
  {$ENDIF}

  PrepareRCT;
  
  //TW 04/08/2011: Loads window size/position if settings are present.
  LoadCoordinates();

  //RB 07/06/2017 2017-R2 ABSEXCH-14156: Temporary Data Files limited to 255 files - Causing Form Printing to Crash (Exch365)
  if Not UsingSQL then
    CleanUpSwap;
end;


//CS:
Procedure TMainForm.Update_DripFeed;
Begin // Update_DripFeed
  // Moved in from FormCreate as Dripfeed is company specific and this needs
  // to be re-run every time we change company
  With GetDripFeed do {* Check for Dripfeed status in ICE sync engine *}
    try
      If (IsActive) then {Set by external class to indicate drip feed mode is on }
      Begin
        If (IAOEdition=ptExchequer) then
          ICEDFM:=1
        else
          ICEDFM:=Ord(IAOEdition);

        // MH: Copied the following section in from FormDesign as not sure if it is
        // safe to call FormDesign multiple times.

        {$IFDEF STK}
          MoveStk1.Visible:=ChkAllowed_In(200) and (ICEDFM=0);
          N39.Visible:=MoveStk1.Visible;
        {$ENDIF}

        //CS: Added drip-feed mode label
        If Not Assigned(DripFeedLbl) Then
        Begin
          DripFeedLbl := TAntLabel.Create(self);
          with DripFeedLbl do
          begin
            Transparent := True;
            Top  := NextInfoLabelTop; // IAO RO
            Left := 5;

            ColorFront.Normal := clRed;
            HighlightColor.Normal := clBlack;
            HighlightXDepth := 2;
            HighlightYDepth := 2;

            with Font do
            begin
              Name  := 'Arial';
              Color := clRed;
              Style := [fsBold];
              Size  := 18;
            end;

            // Need to set the caption so we can get a size so we can adjust the next Top setting (IAO RO)
            Caption := 'Drip-Feed activated for period/year range:';
            NextInfoLabelTop := NextInfoLabelTop + DripFeedLbl.Height + 5;
          end;

          InsertControl(DripFeedLbl);
        End; // If Not Assigned(DripFeedLbl)

        DripFeedLbl.Caption := Format('Drip-Feed activated for period/year range: %s to %s', [PPR_OutPr(StartPeriod, StartYear), PPR_OutPr(EndPeriod, EndYear)]);
        DripFeedLbl.Visible := True;
      end
      else
      begin
         // MH 25/10/06: If you used Change Company from an Active to Inactive company then this wasn't reset

        ICEDFM:=0;

 


        if Assigned(DripFeedLbl) Then
          DripFeedLbl.Visible := False;
      end;
    finally
      Free;
    end; {try..}
End; // Update_DripFeed     

{$IFDEF LTE}
Procedure TMainForm.SetIAOReadOnly; // IAO RO
Begin // SetIAOReadOnly
  // MH 17/07/06: Extended for IAO Grace Period notification (MH GP)
  If Not Assigned(ReadOnlyLbl) And (InIAOReadOnlyMode Or InIAOGracePeriod) Then  // MH RO - only create label if needed
  Begin
    ReadOnlyLbl := TAntLabel.Create(self);
    with ReadOnlyLbl do
    begin
      Transparent := True;
      Top  := NextInfoLabelTop;
      Left := 5;

      ColorFront.Normal := clRed;
      HighlightColor.Normal := clBlack;
      HighlightXDepth := 2;
      HighlightYDepth := 2;

      with Font do
      begin
        Name  := 'Arial';
        Color := clRed;
        Style := [fsBold];
        Size  := 18;
      end;

      // Need to set the caption so we can get a size so we can adjust the next Top setting
      If (Not SBSIn) Then
      Begin
        // MH GP: Check whether Read-Only or Grace Period
        If InIAOReadOnlyMode Then
          Caption := 'Licence Expired - Read-Only access'
        Else
          Caption := 'Licence Expired - Grace Period'
      End // If (Not SBSIn)
      Else
        Caption := 'Licence Expired';
      NextInfoLabelTop := NextInfoLabelTop + ReadOnlyLbl.Height + 5;
    end;

    InsertControl(ReadOnlyLbl);
  End; // If Not Assigned(ReadOnlyLbl) And (InIAOReadOnlyMode Or InIAOGracePeriod)

  If Assigned(ReadOnlyLbl) Then                // MH RO
    ReadOnlyLbl.Visible := (InIAOReadOnlyMode Or InIAOGracePeriod);  // MH RO / MH GP
End; // SetIAOReadOnly
{$ENDIF} // LTE

{ ======== Function to Check Drive status ========== }

Procedure TMainForm.Update_DriveResource;

Var
  MemInfo  :  TMemoryStatus;
  FLoad    :  Integer;

Begin
  //PR: 24/08/2016 ABSEXCH-14065 If we're destroying the main form then don't update anything
  if csDestroying in ComponentState then
    Exit;
    
  fDiskFree:=DiskFree(fdriveNo);

  If (fDiskFree<-1) then
    fDiskFree:=MaxLongInt+fDiskFree;

  //PR: 24/08/2016 ABSEXCH-14065 Check that we're not in the process of destroying the gauge components before updating them
  if not (csDestroying in Gauge1.ComponentState) then
  With Gauge1 do
  Begin
    Progress:=Round(FreeDiskSpacePcnt);

    ForeColor:=Color_ResourceMon(Progress);
  end;

  //PR: 24/08/2016 ABSEXCH-14065 Check that we're not in the process of destroying the gauge components before updating them
  If not (csDestroying in Gauge2.ComponentState) and (Gauge2.Visible) then
  With Gauge2 do
  Begin
    Progress:=Get_FreeResources;
    ForeColor:=Color_ResourceMon(Progress);

    If (Progress<=20) and (Not InWarnLowMem) then
    Begin
      Set_BackThreadMVisible(BOn);

      InWarnLowMem:=BOn;

      CustomDlg(Application.MainForm,'WARNING!','Low Resource Memory',
                 'This workstation is running very low on resource memory.'+#13+#13+
                 OrigCaption+' will become unstable unless additonal memory becomes available'+#13+
                 'You must try to free up more memory by either closing down other applications,'+
                 'or closing any other open windows in '+OrigCaption+'.',
                 mtWarning,
                 [mbOk]);

      InWarnLowMem:=BOff;

      Set_BackThreadMVisible(BOff);

    end;
  end;

  {$IFDEF DBD}

    {If (Debug) then
    Begin
      MemInfo.dwLength:=Sizeof(MemInfo);
      GLobalMemoryStatus(MemInfo);

      With MemInfo do
      Begin
        DebugForm.Add('~~~~~~~~~~~~~~~');

        DebugForm.Add('dwmemoryload '+inttoStr(dwmemoryload));
        DebugForm.Add('dwTotalphys '+inttoStr(dwtotalphys));
        DebugForm.Add('dwAvailphys '+inttoStr(dwAvailphys));

        DebugForm.Add('dwTotalPageFile '+inttoStr(dwTotalPageFile));
        DebugForm.Add('dwAvailPageFile '+inttoStr(dwAvailPageFile));

        DebugForm.Add('dwTotalVirtual'+inttoStr(dwTotalVirtual));
        DebugForm.Add('dwAvailVirtual'+inttoStr(dwAvailVirtual));

        DebugForm.Add('Resources'+inttoStr(Gauge2.Progress));

      end; With..

    end; {debug..}
  {$ENDIF}

end;




procedure TMainForm.FormDesign;

Var
  HideCC  :  Boolean;
  // PKR. 12/01/2016. Renamed HideIS to ShowIntrastat as it was being set to true to show the item.
  ShowIntrastat  :  Boolean;
  SB_Ctrl :  TCBCtrl;
  THelpID :  Integer;
  Path    :  string;

  UseNewECSalesList: Boolean;

Begin
  Path := GetEnterpriseDirectory;
  If (Not Self.Visible) then
  Begin

    {$IFNDEF STK}
      Stock1.Visible:=BOff;
      STree1.Visible:=BOff;
      SList1.Visible:=BOff;
      {FStkR.Visible:=BOff;}
      SBased1.Visible:=BOff;
      XXXCASL1.Visible:=BOff;
      XXXCGBOM1.Visible:=BOff; {* EL BoM Check implementation from DOS code *}
      SV1.Visible:=BOff;
      QFStk1.Visible:=BOff;
      QFBinF.Visible:=BOff;
      QFSerialF.Visible:=BOff;
      MainStockBtn.Visible:=BOff;
      MainSListBtn.Visible:=BOff;
      MainADBkBtn.Visible:=BOff;
      IRO1.Visible:=BOff;
      ST1.Visible:=BOff;
      ObjectStk1.Visible:=BOff;
      ObjPrice1.Visible:=BOff;
    {$ELSE}
      {$IFDEF LTE}
        ObjectStk1.Visible:=BOff;
        ObjectStk1.ShortCut:=0;
        MainStockBtn.Visible:=BOff;
        STree1.Shortcut:=0;
        QFBinF.Visible:=BOff;
        QFSerialF.Visible:=BOff;

      {$ELSE}
        ObjectStk1.Visible:=FullStkSysOn;
      {$ENDIF}

    {$ENDIF}

    {$IFNDEF SOP}
      QFSerialF.Visible:=BOff;
      SORDBook1.Visible:=BOff;
      PORDBook1.Visible:=BOff;
      MainSODBkBtn.Visible:=BOff;
      MainPODBkBtn.Visible:=BOff;
      SODT1.Visible:=BOff;
      PODT1.Visible:=BOff;

      BackLog1.Visible:=BOff;
      //PL 13/04/2017 2017-R1 ABSEXCH-18497 Std. Report:  menuitem Shortages1 has been removed
      //Shortages1.Visible:=BOff;
      OrdShort1.Visible:=BOff;
      KitShortRep1.Visible:=BOff;
      OnOrder1.Visible:=BOff;
      MLoc1.Visible:=BOff;
      IRO1.Visible:=BOff;
      ST1.Visible:=BOff;
      TeleSales1.Visible:=BOff;
      MainTSBtn.Visible:=BOff;
      RetReasons1.Visible:=BOff;
    {$ENDIF}

    {$IFNDEF JC}
      MainJobBtn.Visible:=BOff;
      MainJDBkBtn.Visible:=BOff;
      JobCosting1.Visible:=BOff;
      JobCosting2.Visible:=BOff;
      Empl1.Visible:=BOff;
      JAnal1.Visible:=BOff;
      QFJobF.Visible:=BOff;

    {$ENDIF}

    {$IFNDEF WOP}
      MainWOBkBtn.Visible:=BOff;
      WOP1.Visible:=BOff;

    {$ENDIF}

    {$IFNDEF RET}
      SRN1.Visible:=BOff;
      PRN1.Visible:=BOff;

    {$ENDIF}

    CISRet2.Visible:=CIS340;
  end;

  // MH 14/01/2014 v7.0.8 ABSEXCH-14944: Hide ObjectFind for Consumers if Consumers disabled
  forConsumer1.Visible := Syss.ssConsumersEnabled;

  VRep1.Caption:='&'+CCVatName^+' Reports';
  VRet1.Caption:='&'+CCVatName^+' Return';

  VS1.Caption:='&'+CCVatName^+' Setup';

  // CA ABSEXCH-13184. Menu option should only display if HTM file exists
  If FileExists (Path+ '\DocMastr\UpgradeInfo\UpgradeInfo.HTM') Then
     UpdateInformationDetails1.Visible:=BOn;

  {$IFDEF POST}
     {$IFDEF LTE}
       ObjectCC1.Visible:=BOff;
       ObjectCC1.ShortCut:=0;
     {$ELSE}

       ObjectCC1.Visible:=ChkAllowed_In(427);
     {$ENDIF}
  {$ELSE}
     ObjectCC1.Visible:=BOff;
  {$ENDIF}

  {$IFDEF JC}
     CIS1.Caption:=CCCISName^+' Se&tup';
     CIS1.Visible:=CISOn and ChkAllowed_In(422); {And passwords}

     XXXCISGen1.Visible:=Debug;

     XXXCIS2.Visible:={CISOn;}BOff; {Moved to job tree}

     {CISL1.Caption:='&'+CCCISName^+' Ledger';

     CISL1.Visible:=CISOn and ChkAllowed_In(246);
     CISG1.Visible:=CISOn and ChkAllowed_In(247);


     If (CurrentCountry=IECCode) then
     Begin
       CISG1.Caption:='&Generate RCTDC && RCT47';
       CISG2.Visible:=BOff;
     end
     else
       CISG2.Visible:=CISG1.Visible;

     CIS2.Visible:=CanShowPMenu(CIS2);}

     Suby1.Visible:=JBCostOn; {+Passwords}

     // PKR. 23/03/2016. ABSEXCH-17383. RCT Changes
     // 5.2 RCT Reports menu item to be removed for Ireland.
//     CISRep1.Visible:=CISOn;
     //PL 18/04/2017 2017-R1 ABSEXCH-18497 Std. Report: Removed the menu item "Report" and the sub option return
    { CISRep1.Visible := CISOn and (CurrentCountry <> IECCode);
     CISRep1.Caption:=CCCISName^+' Repor&ts';
     CISRet1.Caption:='&'+CCCISName^+' Return';
     CISRet1.Visible:=CISOn and ChkAllowed_In(248); }

     RCTRet1.Visible:=(CurrentCountry=IECCode);// and (CISRet1.Visible); {And password}

     //PL 18/04/2017 2017-R1 ABSEXCH-18497 Std. Report: Removed the menu item "Report" and the sub option return
    //CISRep1.Visible:=CanShowPMenu(CISRep1);

     CISEDI1.Visible:=CISOn and (CurrentCountry=DefaultCountry) and ChkAllowed_In(429);

     CISXML1.Visible:=CISOn and (CurrentCountry=DefaultCountry) and ChkAllowed_In(429) and CIS340;

     AppsRep1.Visible:=JAPOn and ChkAllowed_In(468);

  {$ELSE}
    CIS1.Visible:=BOff;
    CIS2.Visible:=BOff;
    Suby1.Visible:=BOff;
    CISEDI1.Visible:=BOff;
  {$ENDIF}

  // PKR. 12/01/2016. Renamed HideIS to ShowIntrastat as it was being used in reverse.
  ShowIntrastat := false;

  HideCC:=BOff;

  {$IFDEF PF_On}
    {$IFDEF CC}
      HideCC:=Syss.UseCCDep;
    {$ENDIF}
  {$ENDIF}

  CC1.Visible:=HideCC;
  Dep1.Visible:=HideCC;

  {$IFNDEF MC_On}
    CS1.Visible:=BOff;
    RGL1.Visible:=BOff;
  {$ENDIF}

  {$IFDEF PF_On}
    {$IFDEF STK}
      // PKR. 12/01/2016. ABSEXCH-17093. Intrastat - 4.6 Enter1 Menus.
      // Hide the Intrastat Report menu item for UK companies.  Moved to Intrastat Control Centre.
      ShowIntrastat := (Syss.IntraStat and (FullStkSysOn) and (CurrentCountry <> UKCcode));

      {$IFDEF LTE}
        ObjPrice1.Visible:=BOff;
        ObjPrice1.ShortCut:=0;

      {$ELSE}
        ObjPrice1.Visible:=AnalCuStk;

      {$ENDIF}

      TeleSales1.Visible:=TeleSModule and ChkAllowed_In(245);

      // v6.2 - EC Sales List should be available for all Stock Versions
      ECSalesList1.Visible := True;
    {$ELSE}
      // v6.2 - EC Sales List should be available for Non-Stock Versions if EC Services are enabled
      ECSalesList1.Visible := SyssVAT.VATRates.EnableECServices;
    {$ENDIF}

    // CJS 10/03/2011 - ABSEXCH-10902
    UseNewECSalesList := (CurrentCountry = UKCcode) And ECSalesList1.Visible;
    NewECSalesListRepJan10Onwards.Visible := UseNewECSalesList;
    If UseNewECSalesList Then
      ECSalesList1.Visible := False
    Else
      ECSalesList1.Caption := IfThen((CurrentCountry=IECCode), 'VI&ES Statement', '&EC Sales List');
  {$ELSE}
    // MH: As far as I am aware this code will never be used
    ECSalesList1.Visible:=BOff;
  {$ENDIF}

  // PKR. 12/01/2016. Renamed HideIS to ShowIntrastat as it was being used in reverse.
  ISReport1.Visible := ShowIntrastat;

  {$IFDEF LTE}
    DDa1Btn.Visible:=BOff;
    ObjectDrill1.Visible:=BOff;
    ObjectDrill1.ShortCut:=0;

    {$IFDEF STK}

      MoveStk1.Visible:=ChkAllowed_In(200) and (ICEDFM=0);  // CS: Duplicated in Update_DripFeed
      N39.Visible:=MoveStk1.Visible;
    {$ELSE}
      N39.Visible:=BOff;
      MoveStk1.Visible:=BOff;
    {$ENDIF}
  {$ELSE}
    N39.Visible:=BOff;
    MoveStk1.Visible:=BOff;

  {$ENDIF}

  SB_Ctrl:=TCBCtrl.Create;

  try
    With SB_Ctrl do
    Begin
      If (ChkAllowed_In(02) or ChkAllowed_In(11)) then
        THelpId:=-255
      else
        THelpId:=-254;

      AddSBRec(FAddBtn,THelpID);

      AddSBRec(Bevel0,THelpID);


      If (ChkAllowed_In(01) or ChkAllowed_In(303) or ChkAllowed_In(304)) then
        THelpId:=-255
      else
        THelpId:=-254;

      AddSBRec(MainSDBkBtn,THelpId);

      If (ChkAllowed_In(10) or ChkAllowed_In(305) or ChkAllowed_In(306)) then
        THelpId:=-255
      else
        THelpId:=-254;

      AddSBRec(MainPDBkBtn,THelpId);

      If (ChkAllowed_In(24) or ChkAllowed_In(338)) then
        THelpId:=-255
      else
        THelpId:=-254;

      AddSBRec(MainNDBkBtn,THelpId);

      {$IFDEF STK}
        If (FullStkSysOn) then
          AddSBRec(MainADBkBtn,116)
        else
          AddSBRec(MainADBkBtn,-254);
      {$ELSE}
        AddSBRec(MainADBkBtn,-254);
      {$ENDIF}

      {$IFDEF JC}
        If (JBCostOn) then
          AddSBRec(MainJDbkBtn,213)
        else
          AddSBRec(MainJDBkBtn,-254);
      {$ELSE}
        AddSBRec(MainJDBkBtn,-254);
      {$ENDIF}


      {$IFDEF WOP}
        If (WOPOn) then
        Begin
          If (ChkAllowed_In(373) or ChkAllowed_In(374)) then
            THelpId:=-255
          else
            THelpId:=-254;

          AddSBRec(MainWOBkBtn,THelpId);
        end
        else
          AddSBRec(MainWOBKBtn,-254);
      {$ELSE}
        AddSBRec(MainWOBKBtn,-254);
      {$ENDIF}

      AddSBRec(Bevel1,-255);

      {$IFDEF SOP}
        AddSBRec(MainSODBkBtn,144);

        If TeleSModule then
          AddSBRec(MainTSBtn,245)
        else
          AddSBRec(MainTSBtn,-254);

        AddSBRec(MainPODBkBtn,164);

        // MH 26/01/2016 2016-R1: Show the bevel for SOP versions if any buttons are available
        If ChkAllowed_In(144) Or (TeleSModule And ChkAllowed_In(245)) Or ChkAllowed_In(164) then
          THelpId := -255       // Show
        else
          THelpId := -254;      // Hide
        AddSBRec(Bevel2, THelpId);  // -254 = Hide, -255 = Show, >0 = check user permission
      {$ELSE}
        AddSBRec(MainSODBkBtn,-254);
        AddSBRec(MainPODBkBtn,-254);
        AddSBRec(MainTSBtn,-254);

        // MH 26/01/2016 2016-R1: Hide the bevel for non-SOP versions
        AddSBRec(Bevel2,-254);  // -254 = Hide, -255 = Show, >0 = check user permission
      {$ENDIF}



      AddSBRec(MainCustBtn,30);
      // MH 05/09/2013 MRD1.1.11: Added Consumer List button
      If Syss.ssConsumersEnabled Then
        // MH 18/02/2014 v7.0.9 ABSEXCH-15065: Corrected User Permission lookup
        AddSBRec(btnOpenConsumersList, uaConsumerDetailsAccess)
      Else
        AddSBRec(btnOpenConsumersList, -254);
      AddSBRec(MainSuppBtn,40);

      {$IFDEF STK}
        AddSBRec(MainSListBtn,115);
      {$ELSE}
        AddSBRec(MainSListBtn,-254);
      {$ENDIF}

      AddSBRec(Bevel3,-255);

      AddSBRec(MainNomBtn,20);

      {$IFDEF STK}

        AddSBRec(MainStockBtn,{$IFDEF LTE} -254 {$ELSE}  108 {$ENDIF});
      {$ELSE}
        AddSBRec(MainStockBtn,-254);
      {$ENDIF}

      {$IFDEF JC}
        If (JBCostOn) then
          AddSBRec(MainJobBtn,205)
        else
          AddSBRec(MainJobBtn,-254);
      {$ELSE}
        AddSBRec(MainJobBtn,-254);
      {$ENDIF}

      // PKR. 21/01/2016. ABSEXCH-17179. Intrastat Control Centre only available when Stock included.
      {$IFDEF STK}
      // PKR. 20/01/2016. ABSEXCH-17169. Respect User permissions.
      // PKR. 21/01/2016. ABSEXCH-17174. ICC for UK companies only.
      // PKR. 23/02/2016. ABSEXCH-17322. ICC only available for full stock system (FullStkSysOn).
      IntrastatControlCentre1.Visible := (ChkAllowed_in(uaIntrastatAccessIntrastatControlCentre)) and
                                         (FullStkSysOn) and
                                         (CurrentCountry = UKCCode);
      {$ELSE}
      IntrastatControlCentre1.Visible := false;
      {$ENDIF}

      // MH 16/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
      mnuoptAnonymisationControlCentre.Visible := GDPROn and ChkAllowed_in(uaAccessToAnonymisationControlCentre);

      AddSBRec(Bevel4,-255);
      AddSBRec(DDn1Btn,-254);
      AddSBRec(DDa1Btn,{$IFDEF LTE} -254 {$ELSE}  -255 {$ENDIF});
      AddSBRec(QFBtn,53);
      AddSBRec(Bevel5,-255);

      AddSBRec(DiaryBtn,201);

      AddSBRec(PrintBtn,52);

      {* Disable until implemented * AddSBRec(PQBtn1,52);
      AddSBRec(PQBtn1,-254);}

      // MH 26/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
      AddSBRec(agbExportToExcel, IfThen (ExcelInstalled And ExcelWrapperInstalled, -255, -254));


      AddSBRec(ExitBtn,-255);
      AddSBRec(WhatTBtn,-255);

      If (Self.Visible) then
      Begin
        //Toolbar.Transparent:=BOff;

        Reset_MainMenu;
      end;

      Set_MainMenu;

      //Toolbar.Transparent:=True;

      AdvToolBar.Update;
    end;
  finally
    SB_Ctrl.Free;
    SB_Ctrl:=nil

  end;

  AddN1.Visible:=FAddBtn.Visible;
  Sales1.Visible:=MainSDBkBtn.Visible;
  Purch1.Visible:=MainPDBkBtn.Visible;
  Nom1.Visible:=MainNDBkBtn.Visible;
  Cust1.Visible:=MainCustBtn.Visible;
  // MH 05/09/2013 MRD1.1.11: Added Consumer List button
  mnuConsumers.Visible:=btnOpenConsumersList.Visible;
  Supp1.Visible:=MainSuppBtn.Visible;
  NominalLedger1.Visible:=MainNomBtn.Visible;

  {$IFNDEF LTE}
    NominalLedger2.Visible:=ChkAllowed_In(546);
  {$ELSE}
    NominalLedger2.Visible:=BOff;
    NominalLedger2.ShortCut:=0;
    LockScreen1.Caption:='Loc&k IRIS Accounts Office';
  {$ENDIF}

  CC1.Visible:=ChkAllowed_In(98) and (Syss.UseCCDep);
  Dep1.Visible:=ChkAllowed_In(99) and (Syss.UseCCDep);

  Search1.Visible:=QFBtn.Visible;
  Reports1.Visible:=ChkAllowed_In(54);
  Diary1.Visible:=ChkAllowed_In(201);

  ChnagePr1.Visible:=ChkAllowed_In(51);
  VS1.Visible:=ChkAllowed_In(50);
  SS1.Visible:=ChkAllowed_In(88);
  GS1.Visible:=ChkAllowed_In(89);

  CCodes1.Visible:=ChkAllowed_In(90);

  DocNum1.Visible:=ChkAllowed_In(91);
  //TG 18220
  mniUserManagement.Visible := ChkAllowed_In(92);
  mniMyUserProfile.Visible := not mniUserManagement.Visible;
  mniChangeMyPassword.Visible:=ChkAllowed_In(350) and
                     (SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Exchequer);
  LockScreen1.Visible:=ChkAllowed_In(351);


  PostingMenu1.Visible:=ChkAllowed_In(78);
  PADbk1.Visible:=ChkAllowed_In(79);
  XXXTotalUnpost1.Visible:=SBSIn or Debug;
  XXXPartialUnpost1.Visible:=XXXTotalUnpost1.Visible;

  XXXPartialUnpost3.Visible:=SBSIn or Debug;

  {$IFDEF DBD}
    XXXResetbusylock1.Visible:=BOn;
  {$ELSE}
    XXXResetbusylock1.Visible:=Debug;
  {$ENDIF}

  PRep1.Visible:=ChkAllowed_In(80);
  PRep2.Visible:=ChkAllowed_In(80);
  AutoDBkPost1.Visible:=ChkAllowed_In(97);
  FormDesigner1.Visible:=ChkAllowed_In(83);

  XXXCAcc1.Visible:=ChkAllowed_In(81) ;

  CreditControl1.Visible:=ChkAllowed_In(55);
  PayDueRep1.Visible:=ChkAllowed_In(56);
  RepDueRep1.Visible:=ChkAllowed_In(57);
  AgedDebtors1.Visible:=ChkAllowed_In(58);
  AgedCreditors1.Visible:=ChkAllowed_In(59);
  // MH 17/06/2015 Exch-R1 ABSEXCH-16543: Added permissions for End of Day Payments Report
  mnuoptEndofDayPaymentsReport.Visible:=ChkAllowed_In(uaAccessEndOfDayPaymentsReport);

  Statements1.Visible:=ChkAllowed_In(60);
  ChaseLetters1.Visible:=ChkAllowed_In(61);


  NominalBased1.Visible:=ChkAllowed_In(62);
  TrialBalance1.Visible:=ChkAllowed_In(63);
  ProfitLoss1.Visible:=ChkAllowed_In(64);
  BalanceSheet1.Visible:=ChkAllowed_In(65);
  SApp1.Visible:=ChkAllowed_In(66);
  NomHist1.Visible:=ChkAllowed_In(67);
  NomCode1.Visible:=ChkAllowed_In(68);

  {$IFDEF LTE}
    CCDepRep1.Visible:=BOff;

  {$ELSE}
    CCDepRep1.Visible:=ChkAllowed_In(100);

  {$ENDIF}



  GeneralReports1.Visible:=ChkAllowed_In(69);
  DocAnal1.Visible:=ChkAllowed_In(71);
  BankRec1.Visible:=ChkAllowed_In(72);
  CustRep1.Visible:=ChkAllowed_In(73);
  SuppRep1.Visible:=ChkAllowed_In(74);
  VRep1.Visible:=ChkAllowed_In(75);
  mniAuditTrail1.Visible:=ChkAllowed_In(76);

  DayBookReports1.Visible:=ChkAllowed_In(70);

  {$IFDEF STK}
    SalesRetAnal1.Visible:=BOChkAllowed_In(RETMOn,528) ;
    PurchRetAnal1.Visible:=BOChkAllowed_In(RETMOn,541) ;
    Returns1.Visible:=BOn;
    Returns1.Visible:=CanShowPMenu(Returns1);
  {$ENDIF}

  {MUO1.Visible:=SBSIn; v5, disabled as all now accessed via MCM}

  XXXMUO1.Visible:=Debug; {*EN440*} {Needs to be switched off}

  {$IFDEF S2}
    {SysLic1.Visible:=(SBSIn) and (Not FullyReleased) or (Debug);}

    XXXSysLic1.Visible:=BOff;

  {$ELSE}

    {SysLic1.Visible:=(SBSIn) or (Debug);}

    XXXSysLic1.Visible:=BOff;

  {$ENDIF}

  XXXErrLogs1.Visible:=(SBSIn or Debug);

  {$IFDEF LTE}
    GLRec2.Visible:=Debug;
  {$ENDIF}

  {.$IFDEF LTE}
    //PR 21/03/06 Menu items for Bank Reconciliation/eBanking
    BankReconciliation.Visible := BOn;
    BankRecReport.Visible := BOn;
    eBankingSetup.Visible := BOn;
  {.$ENDIF}

  GLRecon1.Visible:=ChkAllowed_In(106);

  {$IFDEF DBD} {OTC_Hang}
    XXXSDebug.Visible:=BOn;
  {$ELSE}
    XXXSDebug.Visible:=(SBSIn or Debug);

  {$ENDIF}


  {$IFNDEF LTE}
{  if not EBankOn then
  begin
    eBankingSetup.Visible := False;
    N10.Visible := False;
  end;}
  //PR: 02/06/2010 Added user permission for access to eBanking.
  eBankingSetup.Visible := EBankOn and ChkAllowed_In(uaAccessEBanking);
  N10.Visible := eBankingSetup.Visible;
  {$ENDIF}

  // MH 28/02/2011 v6.7 ABSEXCH-10687; Added Trader Bank/Card Audit menu option
  mnuTraderBankCardAudit.Visible := ChkAllowed_In(uaAccessTraderAudit);
  MenItem_UserFields.Visible := ChkAllowed_In(uaAccessCustomFields);

  XXXRPos.Visible:=(SBSIn or Debug);
  XXXDisHKey1.Visible:=(SBSIn or Debug);
  XXXdbClear1.Visible:=XXXSDebug.Visible;

  JobCosting1.Visible:=JBCostOn and (ChkAllowed_In(205) or (Debug));
  JobCostR1.Visible:=JBCostOn and (ChkAllowed_In(225) or (Debug));
  JobCosting2.Visible:=JBCostOn and (ChkAllowed_In(213) or (Debug));

  JCRBS1.Visible:=ChkAllowed_In(226);
  JCEL1.Visible:=ChkAllowed_In(227);
  JCJH1.Visible:=ChkAllowed_In(228);
  JCCE1.Visible:=ChkAllowed_In(229);
  JCBA1.Visible:=ChkAllowed_In(230);
  JCAA1.Visible:=ChkAllowed_In(231);
  JCWIP1.Visible:=ChkAllowed_In(232);
  JCBR1.Visible:=ChkAllowed_In(233);


  Empl1.Visible:=JBCostOn and (ChkAllowed_In(221) or (Debug));
  JAnal1.Visible:=JBCostOn and (ChkAllowed_In(236) or (Debug) or ChkAllowed_In(237));
  QFJobF.Visible:=JBCostOn;

  WOP1.Visible:=(MainWOBkBtn.Visible or (Debug));
  WOPRep1.Visible:=(BOChkAllowed_In(WOPOn,389) or (Debug));
  WOPF1.Visible:=(BOChkAllowed_In(WOPOn,390) or (Debug));
  WOPF2.Visible:=(BOChkAllowed_In(WOPOn,392) or (Debug));
  WOPWIP1.Visible:=(BOChkAllowed_In(WOPOn and Not Is_StdWOP,393) or (Debug));
  WOPF3.Visible:=(BoChkAllowed_In(FullWOP,391) or (Debug));

  Export1.Visible:=(ChkAllowed_In(126) or (Debug)) and ((CurrentCountry=UKCcode) or (CurrentCountry=IECCode));

  {$IFDEF VAT}
    // v6.2 - For UK display new and old versions of the EC Sales Export
    If UseNewECSalesList Then
    begin
      NewECSalesListJan10Onwards.Visible := true;
      VEDIECSL1.Visible := False;
    end
    Else
    begin
      NewECSalesListJan10Onwards.Visible := false;
      VEDIECSL1.Visible := true;
      VEDIECSL1.Caption := IfThen((CurrentCountry=IECCode), 'VI&ES Statement', '&EC Sales List');
    end;

    // PKR. 26/02/2016. ABSEXCH-17321. Fix up Export menu options.
    NewECSalesList2.Visible := UseNewECSalesList;
    ECSalesList2.Visible := not NewECSalesList2.Visible;
    ArrivalsECSSD1.Visible := false;
    DispatchesECSSD1.Visible := false;

    {$IFDEF STK}
      // PKR. 12/01/2016. ABSEXCH-17093. Intrastat.
      // For UK companies, in the existing Procedures-Export-VAT EDI sub-menu, the options
      // for Arrivals and Dispatches EC SSD will be removed as the EDI submission will no longer be supported.
      VECSSDD1.Visible:=(Syss.IntraStat and (CurrentCountry <> UKCCode));
      VECSSDA1.Visible:=(Syss.IntraStat and (CurrentCountry <> UKCCode));
    {$ELSE}
      // MH 26/01/2016 2016-R1 ABSEXCH-17193: Suppress EC SSD Exports for non-Stock versions
      VECSSDD1.Visible := False;
      VECSSDA1.Visible := False;
    {$ENDIF}

    // MH 16/09/2009: Modified conditions under which EC Sales List Export is visible
    VATEDI1.Visible := (UseNewECSalesList Or VECSSDD1.Visible Or VECSSDA1.Visible) and (CurrentCountry <> UKCCode);
    // PKR. 26/02/2016. ABSEXCH-17321. Export menus for Intrastat
    VATEDI1.Caption:='&'+CCVatName^ + IfThen((CurrentCountry=IECCode), ' XML', ' EDI');

    // PKR. 12/01/2016. ABSEXCH-17093. Intrastat.
    // For UK companies, the existing Procedures-Export-VAT CSV sub-menu will be
    // removed as the CSV Export will now be accessed through the Intrastat Control Centre.
    // PKR. 26/02/2016. ABSEXCH-17321. VAT CSV menu reinstated and EC Sales List added to it, as this is in CSV format.
    VATCSV1.Visible := (CurrentCountry = UKCCode);
  {$ENDIF}

  {$IFDEF DBD}
    XXXSPAccess1.Visible:=BOn;
  {$ELSE}
    XXXSPAccess1.Visible:=Debug;
  {$ENDIF}

  {$IFDEF ENAL503}
    AllocSRC1.Visible:=Debug;
    AllocPPY1.Visible:=Debug;
    AllocSRC2.Visible:=Debug;
    AllocPPY2.Visible:=Debug;
    Unalocate1.Visible:=Debug;
    SAlloc1.Visible:=Debug and ChkAllowed_In(410);
    PAlloc1.Visible:=Debug and ChkAllowed_In(413);
  {$ENDIF}

  XXXRAlloc1.Visible:=CanShowPMenu(XXXRAlloc1);


  {$IFDEF MC_On}
    CS1.Visible:=ChkAllowed_In(199);
    RGL1.Visible:=ChkAllowed_In(82) and (ICEDFM=0) ;
  {$ENDIF}

  XXXCACCDL1.Visible:=(SBSIn or Debug) and (Syss.PostCCNom) and (Syss.UseCCDep);

  XXXCAGLT1.Visible:=(SBSIn or Debug);

  NominalDaybook1.Visible:=BOn;

  XXXCAJT1.Visible:=(SBSIn or Debug) and (JBCostOn);

  XXXRestJA1.Visible:=(SBSIn or Debug) and (JBCostOn);

  XXXVerifyJA1.Visible:=(SBSIn or Debug) and (JBCostOn);

  //PR: 05/01/2015 New menu options for Unallocate All Transactions

  mnuUnallocateCustomers.Visible := PChkAllowed_In(uaUnallocateAllCustomerTransactions);
  mnuUnallocateConsumers.Visible := PChkAllowed_In(uaUnallocateAllConsumerTransactions) and Syss.ssConsumersEnabled;
  mnuUnallocateSuppliers.Visible := PChkAllowed_In(uaUnallocateAllSupplierTransactions);

  mnuUnallocateAllTransactions.Visible := mnuUnallocateCustomers.Visible or
                                          mnuUnallocateConsumers.Visible or
                                          mnuUnallocateSuppliers.Visible;

  //PR: 02/05/2017 v2017R1 ABSEXCH-18635
  {$IFDEF STK}
   ValRep2.Visible := PChkAllowed_In(uaReconciliationValuationReport);
   ValRep3.Visible := PChkAllowed_In(uaFinishedGoodsReport);
   AgingReport1.Visible := PChkAllowed_In(uaStockAgingReport);
  {$ELSE}
   ValRep2.Visible := False;
   ValRep3.Visible := False;
   AgingReport1.Visible := False;
  {$ENDIF}

  Suby2.Visible := JBCostOn and PChkAllowed_In(uaSubContractorsReport);




  {$IFDEF STK}
    Stock1.Visible:=MainADBkBtn.Visible;
    STree1.Visible:=MainStockBtn.Visible;
    SList1.Visible:=MainSListBtn.Visible;
    SV1.Visible:=ChkAllowed_In(124) and (Not Syss.AutoValStk) and (ICEDFM=0);
    XXXCASL1.Visible:=ChkAllowed_In(81) and (ICEDFM=0);
    XXXCGBOM1.Visible:=XXXCASL1.Visible and (SBSIn or Debug); {* EL BoM Check implementation from DOS code *}
    SBased1.Visible:=ChkAllowed_In(131);
    SalesAnal1.Visible:=ChkAllowed_In(132);
    PriceList1.Visible:=ChkAllowed_In(133);
    SList2.Visible:=ChkAllowed_In(134);
    ReOrderList1.Visible:=ChkAllowed_In(135)  and (FullStkSysOn) ;

    {PL 13/04/2017 2017-R1 ABSEXCH-18497 Std. Report: Stock valuation menuitem
     splited into two menuitems, so added visibility condition for both }
    ValuationReport1.Visible:=ChkAllowed_In(136) and (FullStkSysOn) ;
    mniValuationReportLIVE.Visible:=ChkAllowed_In(136) and (FullStkSysOn) ;
    StkHist1.Visible:=ChkAllowed_In(137) and (FullStkSysOn) ;

    SRN1.Visible:=(BOChkAllowed_In(RETMOn,575) {or (Debug)});
    PRN1.Visible:=(BOChkAllowed_In(RETMOn,529) {or (Debug)});

    {$IFDEF LTE}
      ValRep2.Visible:=BOff;
      ValRep3.Visible:=BOff;


    {$ENDIF}


    {AgingReport1.Visible:=(CurrentCountry=SingCCode) or (Debug);}

    {$IFDEF SOP}
      BackLog1.Visible:=ChkAllowed_In(138) and (FullStkSysOn) ;
      {PL 13/04/2017 2017-R1 ABSEXCH-18497 Std. Report:  menuitem Shortages1 has been removed
      so added visibility condition for two submenuitems }
      OrdShort1.Visible:=ChkAllowed_In(139) and (FullStkSysOn) ;
      KitShortRep1.Visible:=ChkAllowed_In(139) and (FullStkSysOn) ;
      OnOrder1.Visible:=ChkAllowed_In(416);

      MLoc1.Visible:=UseEMLocStk and ChkAllowed_In(423);

      ST1.Visible:=(ChkAllowed_In(176) and ChkAllowed_In(115));
      IRO1.Visible:=(ChkAllowed_In(174) and ChkAllowed_In(115));

      RemoveCommit.Visible:=(CommitAct) and (ChkAllowed_In(274));

      PAccruals.Visible:=ChkAllowed_In(273);



      SAccruals.Visible:=ChkAllowed_In(271);



      Commitment1.Visible:=BOn;

      Commitment1.Visible:=CanShowPMenu(Commitment1);

      Accruals1.Visible:=BOn;

      Accruals1.Visible:=CanShowPMenu(Accruals1);

      // MH 22/07/2014 v7.X Order Payments: Check for presence of Credit Card Payment Gateway Plug-In
      // Check user permission 'Utilities - Access to Credit Card Payment Gateway'
      // PKR. 24/11/2014. ABSEXCH-15842. Added check for Licenced
      mnuoptCreditCardPaymentGateway.Visible := CreditCardPaymentGateway.ccpgInstalled And
                                                CreditCardPaymentGateway.ccpgLicenced and
                                                ChkAllowed_In(uaAccessToCCPaymentGateway);
    {$ELSE}
      Commitment1.Visible:=BOff;

      Accruals1.Visible:=BOff;

      Accruals2.Visible:=BOff;

      PAccruals.Visible:=BOff;
      SAccruals.Visible:=BOff;

      // MH 22/07/2014 v7.X Order Payments: Hide the Credit Card Payment Gateway Setup option for non-SPOP
      mnuoptCreditCardPaymentGateway.Visible := False;
    {$ENDIF}


    PAccrualRep.Visible:=PAccruals.Visible;
    SAccrualRep.Visible:=SAccruals.Visible;
    StkTakeList1.Visible:=ChkAllowed_In(141);

    {$IFDEF LTE}
      Bins1.Visible:= BOff ;

    {$ELSE}
      Bins1.Visible:= (FullStkSysOn) ; {Set to password}

    {$ENDIF}



    N28.Visible:=Returns1.Visible;

  {$ELSE}
    SalesRetAnal1.Visible:=BOff;
    PurchRetAnal1.Visible:=BOff;

    Returns1.Visible:=BOff;

    // MH 16/06/2015 Exch-R1 ABSEXCH-16540: Hide the Credit Card Payment Gateway Setup option for non-Stock systems
    mnuoptCreditCardPaymentGateway.Visible := False;
  {$ENDIF}

  // MH 06/08/2015 2015-R1 ABSEXCH-16664: Added ObjectNorbert aka Order Payments Tracker window
  {$IFDEF SOP}
    mnuoptOrderPaymentsTracker.Visible := Syss.ssEnableOrderPayments;
  {$ELSE}
    mnuoptOrderPaymentsTracker.Visible := False;
  {$ENDIF}
  mnuoptOrderPaymentsTracker.Enabled := mnuoptOrderPaymentsTracker.Visible;
  mnuoptOrderPaymentsTrackerSep.Visible := mnuoptOrderPaymentsTracker.Visible;

  {$IFDEF RET}
    PRAccrual1.Visible:=BOChkAllowed_In(RETMOn,542) ;
    SRAccrual1.Visible:=BOChkAllowed_In({RETMOn}BOff,543) ;

    N27.Visible:=(Accruals1.Visible);

    Accruals1.Visible:=Accruals2.Visible or (RETMOn);

    Accruals1.Visible:=CanShowPMenu(Accruals1);

    RetReasons1.Visible:=BOChkAllowed_In(RETMOn,545) ;
  {$ELSE}
    PRAccrual1.Visible:=BOff;
    SRAccrual1.Visible:=BOff;
    N27.Visible:=BOff;

    RetReasons1.Visible:=BOff;
  {$ENDIF}


  {$IFDEF SOP}
    SODT1.Visible:=MainSODBkBtn.Visible;
    PODT1.Visible:=MainPODBkBtn.Visible;

  {$ELSE}
    Commitment1.Visible:=BOff;

    {$IFDEF RET}

      Accruals1.Visible:=RETMOn;

      Accruals1.Visible:=CanShowPMenu(Accruals1);
    {$ELSE}
      Accruals1.Visible:=BOff;
    {$ENDIF}

    Purge2.Visible:=BOff;

  {$ENDIF}

   BSRC1.Visible:=ChkAllowed_In(151);
   BPPY1.Visible:=ChkAllowed_In(151);

   BPRep1.Visible:=ChkAllowed_In(152);
   BPRep2.Visible:=ChkAllowed_In(152);

   BPRun1.Visible:=ChkAllowed_In(153);
   BPRun2.Visible:=ChkAllowed_In(153);


   {* v4.30, do not combine these statements, as CanShowPmenu checks status, and fails if parent is not already visible}
   Batches1.Visible:=ChkAllowed_In(150);
   Batches1.Visible:=CanShowPMenu(Batches1);

   DayBooks1.Visible:=BOn;

   DayBooks1.Visible:=CanShowPMenu(DayBooks1);


   Records1.Visible:=BOn;
   Records1.Visible:=CanShowPMenu(Records1);


   Reports1.Visible:=ChkAllowed_In(54);

   Reports1.Visible:=CanShowPMenu(Reports1);

   DataReuild1.Visible:=ChkAllowed_In(195);

   DataReuild1.Visible:=CanShowPMenu(DataReuild1);

   Utilities1.Visible:=ChkAllowed_In(77);
   Utilities1.Visible:=CanShowPMenu(Utilities1);

   Proc1.Visible:=BOn;
   Proc1.Visible:=CanShowPMenu(Proc1);

   N6.Visible:=(STree1.Visible or SList1.Visible);
   N7.Visible:=(MLoc1.Visible or CC1.Visible or Dep1.Visible);

   {$IFDEF LTE}
     DelAudit1.Visible:=BOff;

   {$ELSE}

     { CJS 2012-07-16: ABSEXCH-12955 - Removed check for SQL }
       DelAudit1.Visible:=ChkAllowed_In(87);
       
   {$ENDIF}


   
   N11.Visible:=((FormDesigner1.Visible) and (DelAudit1.Visible or DataReuild1.Visible));

   N17.Visible:=SBased1.Visible;
   mniN18.Visible:=N17.Visible;

   N14.Visible:=JobCostR1.Visible;
   N15.Visible:=WOPRep1.Visible;

   N24.Visible:=(Sales1.Visible) or (SODT1.Visible) or (SRN1.Visible);
   N25.Visible:=(Purch1.Visible) or (PODT1.Visible) or (PRN1.Visible);
   N26.Visible:=(Nom1.Visible);


   If (ISWinNT) then
   Begin
     Proc1.Caption:='&Procs';
     DayBooks1.Caption:='&Trans';
     Utilities1.Caption:='&Utils';
   end;

   RWriter.Visible := RepWrtOn And ChkAllowed_In(193);
   VisualReportWriter1.Visible := VRWOn And ChkAllowed_In(193);

   // If only one RW is available then move it onto the Reports menu and hide the sub-menu
   ReportWriters1.Visible := RWriter.Visible And VisualReportWriter1.Visible;
   If (Not ReportWriters1.Visible) Then
   Begin
     If RWriter.Visible And (RWriter.Parent = ReportWriters1) Then
     Begin
       ReportWriters1.Delete(RWriter.MenuIndex);
       Reports1.Add(RWriter);
     End; // If RWriter.Visible
     If VisualReportWriter1.Visible And (VisualReportWriter1.Parent = ReportWriters1) Then
     Begin
       ReportWriters1.Delete(VisualReportWriter1.MenuIndex);
       Reports1.Add(VisualReportWriter1);
     End; // If VisualReportWriter1.Visible
   End; // If (Not ReportWriters1.Visible)
   RWSepBar.Visible := ReportWriters1.Visible;

   If CompManOn Then Begin
     FileCompSepBar.Visible := True;
     FileCompList.Visible := True;
   End; { If }

  { CJS 2012-10-18 - ABSEXCH-13547 - Password-protect Purge routines }
  DelAudit1.Visible := SBSIn or Debug;

  //PL 18/04/2017 2017-R1 ABSEXCH-18497 : Visibility of separator depands on Stock Based-BOM Reports menuitem
  mniN19.Visible := mniBOMReports.Visible;

  // MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
  {$If Defined(EXSQL) And Defined(POST)}
    If SQLUtils.UsingSQL Then
      // Check user permissions to see if they are allowed to see the SQL Prompt dialog and
      // lookup SQL Posting Status in SQLConfig.Ini to see if the Prompt dialog is required
      mnuCheckSQLPostingCompatibility.Visible := CheckSQLPostingStatus And
                     (SQLReportsConfiguration.SQLPostingStatus[SQLUtils.GetCompanyCode(SetDrive)] In [psPending, psFailed]);
  {$IfEnd}
end;

procedure TMainForm.ShowHint(Sender: TObject);
begin
  StatusBar.Panels[1].Text:= Application.Hint;
end;

{$IFDEF Frm}
procedure TMainForm.PrintProgress(var Msg: TMessage);

Var
  Locked  :  Boolean;

begin
  Locked:=BOff;

  With Msg Do Begin
    { Mode passes in WParam }
    Case WParam Of
      0 : Begin

          End;

      { Set Progress percentage within threads bar graph}

      1 : Begin
            {InPrint:=BOn;}

            If (LParam < 0) Then LParam := 0;
            If (LParam > 100) Then LParam := 100;

            If (Assigned(BackThread)) then
            Begin
              If (Not BackThread.Suspended) then  {* avoids interferrance from non threaded print jobs *}
                BackThread.UpdatePrintProgress(LParam);
            end;

          End;

      { Set HWnd }
      2 : PrintHwnd := LParam;

      { Set InPrint Flag }
      3 : InPrint := (LParam = 1);

      { Check InPrint Flag }
      4 : SendMessage(LParam,WM_InPrint,Ord(InPrint),0);

       { Clear Progress }
     10 : Begin
            {InPrint:=BOff;}
            Gauge3.Progress := 0;

            If (Gauge3.Visible) and (Gauge2.Visible) then
            Begin

              Gauge3.Visible := False;
              Out_Period;
            end;

            {$IFDEF FRM}
              If (Assigned(RepDrillDownPtr)) then {Tidy up any open forms claled via preview drill down}
              Begin
                Try
                  TFRepDisplay(RepDrillDownPtr).Free;
                finally
                  RepDrillDownPtr:=nil;
                end; {try..}
              end;
            {$ENDIF}
          End;

      { Set Progress percentage }
     11 : Begin
            {InPrint:=BOn;}
            If (Not Gauge3.Visible) Then Begin
              Gauge3.Progress := 0;
              Gauge3.Visible := True;
              Out_Period;
            End; { If }

            If (LParam < 0) Then LParam := 0;
            If (LParam > 100) Then LParam := 100;
            Gauge3.Progress := LParam;
          End;

     // HM 09/10/00: Change Notification for Form Definition Sets
     90 : Begin
            If (LParam=0) then {Go get form defs 0 as they have been resaved}
              GetMultiSys(BOff,Locked,FormR);
          End;
   End; { Case }
  End; { With }
end;
{$ENDIF}


procedure TMainForm.CreateMDIChild(const Name: string);
var
  Child: TMDIChild;
begin
  { create a new MDI child window }
  Child := TMDIChild.Create(Application);
  Child.Caption := Name;
end;

//GS 03/10/2011 ABSEXCH-11531: closes any open print preview forms
Procedure TMainForm.ClosePrintPreviews;
var
  i: Integer;
begin
  //initialisation
  i := 0;
  //iterate through the applications component array
  While i < Application.ComponentCount do
  begin
    //if a component of 'TForm_PrintPreview' is found..
    if Trim(Application.Components[i].ClassName) = 'TForm_PrintPreview' then
    begin
      //..close the form
      TForm(Application.Components[i]).Close;
    end;//end if
    i := i + 1;
  end;//end while
end;//end ClosePrintPreviews


procedure TMainForm.FileExitItemClick(Sender: TObject);
begin
  //GS 03/10/2011 ABSEXCH-11531: before we close the application;
  //determine if there are any print preview windows open, if so,
  //close any open print previews.
  ClosePrintPreviews;
  //all preview windows should now be closed; go ahead and close the application
  Close;
end;

procedure TMainForm.XXXCopyItemClick(Sender: TObject);
begin
  {copy selection to clipboard}
end;

procedure TMainForm.XXXPasteItemClick(Sender: TObject);
begin
  {paste from clipboard}
end;

procedure TMainForm.WindowCascadeItemClick(Sender: TObject);
begin
  Cascade;
end;

procedure TMainForm.WindowTileItemClick(Sender: TObject);
begin
  Tile;
end;

procedure TMainForm.WindowArrangeItemClick(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TMainForm.WindowMinimizeItemClick(Sender: TObject);
var
  I: Integer;
begin
  { Must be done backwards through the MDIChildren array }
  for I := MDIChildCount - 1 downto 0 do
    MDIChildren[I].WindowState := wsMinimized;
end;

procedure TMainForm.XXXSDebugClick(Sender: TObject);

Var
  TBo  :  Boolean;

begin          
  {$IFDEF DBD}
    {If (Debug) then}
    Begin
      Tbo:=DebugForm.DebugBox1.Visible;
      Tbo:=Not Tbo;
      DebugForm.Switch(Tbo);
      XXXSDebug.Checked:=Tbo;

     {$IFDEF DBD} {OTC_Hang}
      If (Assigned(BackThread)) then {* Force thread busy flag to be idle *}
      With BackThread do
        FillChar(DebugMarker,Sizeof(DebugMarker),#0);
     {$ENDIF}
    end;
  {$ENDIF}
end;

procedure TMainForm.XXXRPosClick(Sender: TObject);
begin
  Delete_PosRecs;
end;

procedure TMainForm.UpdateMenuItems(Sender: TObject);
begin
  // MH 23/02/2018 2018-R2 ABSEXCH-19172: Determine whether the Export to Excel button should be enabled
  EvaluateListExportButtonStatus;

  WindowCascadeItem.Enabled := MDIChildCount > 0;
  WindowTileItem.Enabled := MDIChildCount > 0;
  WindowArrangeItem.Enabled := MDIChildCount > 0;
  WindowMinimizeItem.Enabled := MDIChildCount > 0;

  Update_DriveResource;
  Out_Period;
end;


procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
{$IFDEF HM} // EndSession
WriteDbgMsg ('Start.EParentU.FormCloseQuery');
{$ENDIF}
  If (Assigned(BackThread)) and (Not EntInCloseQ) then
  With BackThread do
  Begin
    EntInCloseQ:=BOn;

    Try
      If (IdleMode) then
      Begin
        If (Suspended) then
          Resume;

        Terminate;

        CanClose:=WaitForTerminate;

        If (CanClose) and (Not ExecuteOff) then {* For some reason, thread never terminated correctly, so suspend it b4 exiting }
          Suspend;
      end;

    finally
      EntInCloseQ:=BOff;

    end; {Try..}
  end {With..}
  else
    CanClose:=(Not EntInCloseQ);

    {else
    Begin
      CanClose:=BOff;
      BackThread.ProgTForm.BringToFront;
      ShowMessage('A background task is still running. Please wait for this to finish before exiting.');
    end;
  end; {With..}

  If (CanClose) and (Not EntBeenTidy) then
    FormTidy(Sender);
{$IFDEF HM} // EndSession
WriteDbgMsg ('Fini.EParentU.FormCloseQuery');
{$ENDIF}
end;




procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {* Placing anything here does not seem to get called if Windows closes Ent... *}

{$IFDEF GLCCDEBUG}
  If Assigned(GLCCMonitor) Then GLCCMonitor.Terminate;
{$ENDIF}

{$IFDEF HM} // EndSession
WriteDbgMsg ('Start.EParentU.FormClose');
{$ENDIF}

  If (Not EntBeenTidy) then
    FormTidy(Sender);
{$IFDEF HM} // EndSession
WriteDbgMsg ('Fini.EParentU.FormClose');
{$ENDIF}

  //GS 03/10/2011 ABSEXCH-11531: before we close the application;
  //determine if there are any print preview windows open, if so,
  //close any open print previews.
  ClosePrintPreviews;
end;


procedure TMainForm.FormTidy(Sender: TObject; Const EndSession : Boolean = False);
Var
  Res    :  LongInt;

  Locked :  Boolean;

  MCDLLPath
         :  Str255;

  //PR: 07/04/2016 ABSEXCH-10802
  I      :  Integer;

{$IFDEF HM} // EndSession
  KeyS : Str255;
{$ENDIF}
begin
{$IFDEF HM} // EndSession
WriteDbgMsg ('Start.EParentU.FormTidy');
{$ENDIF}
  EntBeenTidy:=BOn;
  MCDLLPath:='';
   //TG: 24/01/2017- R1 ABSEXCH-18117 Closed Dataset Error Closing Exchequer SQL Edition
  //Reformatting of the FormTidy method.
  for I := MDIChildCount-1 downto 0 do
    MDIChildren[I].Close;
  //TW 04/08/2011: Saves window size/position if save position is checked.
  SaveCoordinates;
  FSettings := nil;

  If (Assigned(BackThread)) then
  Begin
    BackThread.Free;
    BackThread:=nil;
  end;

  {$IFDEF S2}
    If (GotUserLic) then
    begin
      // Need to remove user count reference
      {$IFNDEF SEC500}
        // pre-v5.00 Security
        GotUserLic:=Update_Users(-1,BOff);
      {$ELSE}
        // v5.00 Security
{$IFDEF HM} // EndSession
If (Not EndSession) Then Begin
WriteDbgMsg ('Start.EParentU.FormTidy.v5Security');
{$ENDIF}
{$IFDEF HM} // EndSession
WriteDbgMsg ('Start.EParentU.FormTidy.v5Security.CreateTMCMSecurity');
{$ENDIF}

        If (Debug) then
          MCDLLPath:=SetDrive  {* This is required only for my test rig as it points to the data dir, should be blank *}
        else
          MCDLLPath:='';

        With TMCMSecurity.Create (ssEnterprise, SyssMod^.ModuleRel.CompanyID {$IFDEF DBD},MCDLLPath{$ENDIF}) Do
          Try
{$IFDEF HM} // EndSession
WriteDbgMsg ('Fini.EParentU.FormTidy.v5Security.CreateTMCMSecurity');
{$ENDIF}
            // Get and Lock SysR
            Locked := BOn;
            If GetMultiSys(BOn, Locked, SysR) And Locked Then Begin
              Res := RemoveLoginRefEx;
              If (Res = 0) Then
                // Only change the User Count if the MCM bit worked - better chance of
                // keeping the system consistent if either fails
                If (Syss.EntULogCount > 0) Then Dec (Syss.EntULogCount);

              // Always do update - as need to unlock record
              PutMultiSys(SysR, BOn);
            End { If (Res = 0) }
            Else
              Res := 32767;

            If (Res <> 0) Then Begin
              // Error - Write a log and inform the user
              AddErrorLog('Error Updating User Count',
                          'An error ' + IntToStr(Res) + ' occurred decrementing the Logged-In User Count',
                          0);         // System generated error
{$IFDEF HM} // EndSession
WriteDbgMsg ('Start.EParentU.FormTidy.v5Security.MessageDlg (' + IntToStr(Res) + ')');
{$ENDIF}
              MessageDlg ('An error ' + IntToStr(Res) + ' occurred decrementing the Logged-In User Count, ' +
                          'Please contact your Technical Support', mtError, [mbOk], 0);
{$IFDEF HM} // EndSession
WriteDbgMsg ('Fini.EParentU.FormTidy.v5Security.MessageDlg');
{$ENDIF}

              // Close Enterprise
              GotPassword := False;
            End; { Else }
          Finally
            Free;
          End;
{$IFDEF HM} // EndSession
WriteDbgMsg ('Fini.EParentU.FormTidy.v5Security');
End; { If (Not EndSession) }
{$ENDIF}
      {$ENDIF}
    end;
  {$ENDIF}

{$IFDEF HM} // EndSession
WriteDbgMsg ('Start.EParentU.FormTidy.Close_Files');
{$ENDIF}
  Close_Files(BOn);
{$IFDEF HM} // EndSession
WriteDbgMsg ('Fini.EParentU.FormTidy.Close_Files');
{$ENDIF}

  {$IFDEF EXSQL}
    If SQLUtils.UsingSQL Then
      TerminateGlobalADOConnection;
  {$ENDIF}

  {$IFDEF SY}

    Reset_EntLogOn;
  {$ENDIF}


  {$IFDEF CU} {* Deinitialise customisation DLL *}
    TerminateCustomisation;
  {$ENDIF}

  { Closedown menu customisation }
  CloseCustomMenus;
  FreeMem (EntInfo, SizeOf (EntInfo^));


  Reset_NONClientInfo;

  {$IFDEF Frm}

    If (NumPrevWins>0) then {* For non thread based preview windows, auto close them *}
      NFClosePrevWindows;

    sbsForm_DeInitialise;

  {$ENDIF}

  {$IFDEF SY}
    (* HM 01/03/99: Removed so we can load ENTCOMP.DLL dynamically to reduce memory usage
    If CompManOn Then
    Begin
      TermCompDll;
    end;
    *)
  {$ENDIF}
  Screen.OnActiveFormChange := nil;

  Free_ResourceMon;

  //PR: 07/04/2016 ABSEXCH-10802 Close all mdi child windows to avoid avs in destroy events
//  for I := MDIChildCount-1 downto 0 do
//    MDIChildren[I].Close;

{$IFDEF HM} // EndSession
WriteDbgMsg ('Fini.EParentU.FormTidy');
{$ENDIF}
end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
{$IFDEF HM} // EndSession
WriteDbgMsg ('Start.EParentU.FormDestroy');
{$ENDIF}

  If (Not EntBeenTidy) then {* Second chance to tidy up, in case FormClose is not called.*}
    FormTidy(Sender);
{$IFDEF HM} // EndSession
WriteDbgMsg ('Fini.EParentU.FormDestroy');
{$ENDIF}
end;

procedure TMainForm.OpenBtnClick(Sender: TObject);

Var
  TradPage  :  Byte;
  UserPermission : Integer;
  EntryCust :  CustRec;

begin
{$IFDEF MHALTCUSTLIST}
  TfrmCustListML.Create(Self);
{$ELSE}

  EntryCust:=Cust;

  // MH 05/09/2013 MRD1.1.11: Added Consumer List button
  If (Sender = MainCustBtn) Or (Sender = Cust1) Then
  Begin
    // Customer List
    TradPage := 0;
    UserPermission := 30;
  End // If (Sender = MainCustBtn) Or (Sender = Cust1)
  Else If (Sender = MainSuppBtn) Or (Sender = Supp1) Then
  Begin
    // Supplier List
    TradPage := 2;
    UserPermission := 40;
  End // If (Sender = MainSuppBtn) Or (Sender = Supp1)
  Else
  Begin
    // Consumers List
    TradPage := 1;
    UserPermission := uaConsumerDetailsAccess;
  End; // Else

  //TradPage:=Ord((Sender=MainSuppBtn) or (Sender=Supp1));

  //If Allowed_In((AllowHotKey) and (Not Ignore_HT),30+(10*TradPage)) then
  If Allowed_In((AllowHotKey) and (Not Ignore_HT), UserPermission) then
  Begin
  {$IFDEF C_On}

    If (InTradeList<>1) then
    Begin

      Set_TradListFormMode(TradPage);

      If (InTradeList=0) and (CustList=nil) then
      Begin
        InTradeList:=1;
        CustList:=TTradList.Create(Self);
        InTradeList:=2;
      end;

      If (CustList<>nil) and (InTradeList=2) then
      With CustList do
      Begin
        If (WindowState=wsMinimized) then
          WindowState:=wsNormal;

        ChangePage(TradPage);

        Show;

        {* Restore Global Cust before list was created *}

        Cust:=EntryCust;

        If (Cust.CustCode<>ExLocal.LCust.CustCode) and (Not EmptyKey(Cust.CustCode,CustKeyLen)) Then
        Begin
          // MH 05/09/2013 MRD1.1.11: Added Consumer List button
          If ((Cust.acSubType = 'C') And (TradPage = 0)) Or
             ((Cust.acSubType = 'U') And (TradPage = 1)) Or
             ((Cust.acSubType = 'S') And (TradPage = 2)) Then
            SendMessage(CustList.Handle,WM_CustGetRec,3100+TradPage,0); {* Re-Position List *}

          //If (Ord(Not IsACust(Cust.CustSupp))=TradPage) then
          //  SendMessage(CustList.Handle,WM_CustGetRec,3100+TradPage,0); {* Re-Position List *}
        End; // If (Cust.CustCode<>ExLocal.LCust.CustCode) and (Not EmptyKey(Cust.CustCode,CustKeyLen))
      end;
    end;
  {$ENDIF}

  end;

{$ENDIF}
end;

procedure TMainForm.MainSDBkBtnClick(Sender: TObject);

Var
  DayBkType  :  DocTypes;

  DayBkIdx,
  DayBkPage  :  Byte;

begin

  {$IFDEF DBk_On}

    DayBkIdx:=Ord((Sender=MainPDBkBtn) or (Sender=MainPODBkBtn) or (Sender=Purch1) or (Sender=PODT1));

    DayBkType:=DocTypes((DayBkIdx*Ord(PIN))+(Ord((Sender=MainNDBkBtn) or (Sender=Nom1))*Ord(NMT))+
                         (Ord((Sender=Stock1) or (Sender=MainADBkBtn))*Ord(ADJ))+
                         (Ord((Sender=WOP1) or (Sender=MainWOBkBtn))*Ord(WOR))
                         {$IFDEF RET}
                           +Ord((Sender=SRN1))*Ord(SRN) + Ord((Sender=PRN1))*Ord(PRN)
                         {$ENDIF}
                         );

    If (DayBkType=NMT) then
      DayBkIdx:=2
    else
      If (DayBkType=ADJ) then
        DayBkIdx:=3
      else
        If (DayBkType=WOR) then
          DayBkIdx:=4
        {$IFDEF RET}
          else
            If (DayBkType=SRN) then
              DayBkIdx:=5
            else
              If (DayBkType=PRN) then
                DayBkIdx:=6;
        {$ELSE}
        ;
        {$ENDIF}


    If (Sender=MainSODBkBtn) or (Sender=MainPODBkBtn) or (Sender=SODT1) or (Sender=PODT1) then
      DayBkPage:=4
    else
      DayBkPage:=0;

    If (InSPDayBk[DayBkIdx]<>1)  then
    Begin

      Set_DayBkFormMode(DayBkType,DayBkPage);

      Try

        If (InSPDayBk[DayBkIdx]=0) then
        Begin
          InSPDayBk[DayBkIdx]:=1;

          SPDayBkList[DayBkIdx]:=TDayBk1.Create(Self);

          InSPDayBk[DayBkIdx]:=2;

        end
        else
        With SPDayBkList[DayBkIdx] do
        Begin
          If (WindowState=wsMinimized) then
            WindowState:=wsNormal;

          If (DPageCtrl1.Pages[DayBkPage].TabVisible) then
            ChangePage(DayBkPage);

          Show;
        end;
      Finally

      end;
    end;
  {$ENDIF}
end;


procedure TMainForm.MainNomBtnClick(Sender: TObject);
begin
  If Allowed_In((AllowHotKey) and (Not Ignore_HT),20) then
  Begin
  {$IFDEF NOM}

    If (Not InNominal) then
      NomView:=TNomView.Create(Self)
    else
    With NomView do
    Begin
      If (WindowState=wsMinimized) then
        WindowState:=wsNormal;

      Show;
    end;

    InNominal:=BOn;

  {$ENDIF}
  end;
end;

procedure TMainForm.NominalLedger2Click(Sender: TObject);
begin
  If Allowed_In((AllowHotKey) and (Not Ignore_HT),546) then
  Begin
  {$IFDEF NOM}

    If (Not InNomView) then
      GLViews:=TNViews.Create(Self)
    else
    With GLViews do
    Begin
      If (WindowState=wsMinimized) then
        WindowState:=wsNormal;

      Show;
    end;

    InNomView:=BOn;

  {$ENDIF}
  end;
end;

procedure TMainForm.MainStockBtnClick(Sender: TObject);
begin
  If Allowed_In((AllowHotKey) and (Not Ignore_HT),108) then
  Begin
  {$IFDEF STK}
    {$IFDEF SKL}

      If (Not InStkTree) then
        StkView:=TStkView.Create(Self)
      else
      With StkView do
      Begin
        If (WindowState=wsMinimized) then
          WindowState:=wsNormal;

        Show;
      end;

      InStkTree:=BOn;

    {$ENDIF}
  {$ENDIF}
  end;
end;


procedure TMainForm.SList1Click(Sender: TObject);
Var
  EntryStk  :  StockRec;
  DayBkPage :  Byte;
  WasNew    :  Boolean;


begin
  WasNew:=BOff;

  If Allowed_In((AllowHotKey) and (Not Ignore_HT),115) then
  Begin
    DayBkPage:=TComponent(Sender).Tag;

  {$IFDEF STK}
    {$IFDEF SKL}

    If (InStkList<>1) then {* Still being created *}
    Begin
      EntryStk:=Stock;

      If (InStkList=0) then
      Begin
        InStkList:=1;

        Set_SListFormMode(DayBkPage);
        StkList:=TStkList.Create(Self);

        WasNew:=BOn;
      end
      else
      With StkList do
      Begin
        If (WindowState=wsMinimized) then
          WindowState:=wsNormal;

        ChangePage(DayBkPage);

        Show;
      end;

      {* Restore Global Stock before list was created *}

      Stock:=EntryStk;

      With StkList do
        If (Stock.StockCode<>ExLocal.LStock.StockCode) and (Not EmptyKey(Stock.StockCode,StkKeyLen)) then
        With Stock do
        Begin
          SendMessage(StkList.Handle,WM_CustGetRec,3103,0); {* Re-Position List *}
        end;

      If (WasNew) then
        InStkList:=2;
    end;


    {$ENDIF}
  {$ENDIF}

  end;
end;


procedure TMainForm.JobCosting1Click(Sender: TObject);
begin
  If Allowed_In((AllowHotKey) and (Not Ignore_HT),205) and (JBCostOn) then
  Begin
  {$IFDEF JC}
      If (Not InJobTree) then
        JobView:=TJobView.Create(Self)
      else
      With JobView do
      Begin
        If (WindowState=wsMinimized) then
          WindowState:=wsNormal;

        Show;
      end;

      InJobTree:=BOn;

  {$ENDIF}
  end;
end;


procedure TMainForm.JobCosting2Click(Sender: TObject);
begin
  If Allowed_In(BOn,213) and (JBCostOn) then
  Begin
  {$IFDEF JC}
    {$IFDEF DBk_On}
      If (InJCDayBk<>1) then
      Begin
        If (Not Assigned(JCDayBk)) then
        Begin
          SetForApps:=BOff;

          InJCDayBk:=1;
          JCDayBk:=TJobDayBk.Create(Self);
          InJCDayBk:=2;
        end
        else
        With JCDayBk do
        Begin
          If (WindowState=wsMinimized) then
            WindowState:=wsNormal;

          Show;
        end;
      end;
    {$ENDIF}
  {$ENDIF}
  end;
end;



procedure TMainForm.Empl1Click(Sender: TObject);

begin
  {$IFDEF JC}

    If (Not Assigned(EmplList)) then
    Begin
      EmplList:=TEmplList.Create(Self);
    end
    else
      With EmplList do
      Begin
        try
          If (WindowState=wsMinimized) then
            WindowState:=wsNormal;

          Show;

        except
          EmplList.Free;
          EmplList:=nil;
        end;
      end;


  {$ENDIF}
end;

procedure TMainForm.JAnal1Click(Sender: TObject);
begin
  {$IFDEF JC}

    If (Not Assigned(JAnalList)) then
    Begin
      JAnalList:=TJAnalList.Create(Self);
    end
    else
      With JAnalList do
      Begin
        try
          If (WindowState=wsMinimized) then
            WindowState:=wsNormal;

          Show;

        except
          JAnalList.Free;
          JAnalList:=nil;
        end;
      end;


  {$ENDIF}

end;



procedure TMainForm.CC1Click(Sender: TObject);
Var
  CCDepMode  :  Boolean;

begin
  {$IFDEF Pf_On}
    {$IFDEF CC}
      CCDepMode:=(Sender=CC1);

      If (Not InCCDep[CCDepMode]) then
      Begin
        InCCDep[CCDepMode]:=BOn;

        Set_CCFormMode(CCDepMode);
        CCDepList[CCDepMode]:=TCCDepList.Create(Self)
      end
      else
        With CCDepList[CCDepMode] do
        Begin
          try
            If (WindowState=wsMinimized) then
              WindowState:=wsNormal;

            Show;

            InCCDep[CCDepMode]:=BOn;

          except
            InCCDep[CCDepMode]:=BOff;
            CCDepList[CCDepMode].Free;
            CCDepList[CCDepMode]:=nil;
          end;
        end;


    {$ENDIF}
  {$ENDIF}
end;

procedure TMainForm.MLoc1Click(Sender: TObject);
begin
  {$IFDEF STK}
    {$IFDEF SOP}

      If (Not Assigned(MLocList)) then
      Begin
        Set_MLFormMode(1);
        MLocList:=TLocnList.Create(Self);
      end
      else
        With MLocList do
        Begin
          try
            If (WindowState=wsMinimized) then
              WindowState:=wsNormal;

            Show;

          except
            MLocList.Free;
            MLocList:=nil;
          end;
        end;


    {$ENDIF}
  {$ENDIF}
end;


procedure TMainForm.TeleSales1Click(Sender: TObject);

{$IFDEF STK}
  {$IFDEF SOP}

Var
   CKAnal     :  CKAnalType;
   TeleSList  :  TTeleSFrm;

  {$ENDIF}
{$ENDIF}

begin
  {$IFDEF STK}
    {$IFDEF SOP}
      TeleSList:=Nil;

      If (Not Assigned(TeleSList)) then
      Begin
        Blank(CKAnal,Sizeof(CKAnal));
        {CKAnal.CCode:='ASASA ';

        CKAnal.DispMode:=2;
        CKAnal.ScanMode:=1;
        CKAnal.ScaleMode:=1;

        CKAnal.IsaC:=BOn;}
        CKAnal.IsTeleS:=BOn;


        Set_TSFormMode(CKAnal);

        TeleSList:=TTeleSFrm.Create(Self);
      end
      else
        With TeleSList do
        Begin
          try
            If (WindowState=wsMinimized) then
              WindowState:=wsNormal;

            Show;

          except
            TeleSList.Free;
            TeleSList:=nil;
          end;
        end;


    {$ENDIF}
  {$ENDIF}

end;

procedure TMainForm.RetReasons1Click(Sender: TObject);
begin
  {$IFDEF STK}
    {$IFDEF RET}

      If (Not Assigned(RetLTList)) then
      Begin
        RetLTList:=TRetLTList.Create(Self);
      end
      else
        With RetLTList do
        Begin
          try
            If (WindowState=wsMinimized) then
              WindowState:=wsNormal;

            Show;

          except
            RetLTList.Free;
            RetLTList:=nil;
          end;
        end;


    {$ENDIF}
  {$ENDIF}

end;


procedure TMainForm.Change_Period;

Var
  WasNew  :  Boolean;
begin
  If Allowed_In((AllowHotKey) and (Not Ignore_HT),51) then
  Begin
    //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
    if not GetProcessLock(plChangePeriod) then
      EXIT;

    //PR: 15/11/2010 Add warning if Bank Reconciliation Wizard is currently running.
    if BankReconciliationInProgress then
    begin
      msgBox('Please be advised that changing the local period setting'#10'can affect the values displayed ' +
             'on Trader Balances,'#10'and the cleared status of reconciled / un-reconciled transactions.', mtWarning, [mbOK], mbOK, 'Warning');
    end;
    WasNew:=BOff;

    If (Not InMainThread) then
    Begin

      {$IFDEF PERIODDEBUG}
        tmPeriodDebug.Enabled := False;
      {$ENDIF}

      If (Not Assigned(ChangePer)) then
      Begin
        ChangePer:=TSetPerRec.Create(Self);
        WasNew:=BOn;
      end;

      try
        With ChangePer do
        Begin

          If (WindowState=wsMinimized) then
            WindowState:=wsNormal;

          If (WasNew) then
            ProcessSyss
          else
            Show;
        end; {With..}

      except
        ChangePer.Free;
        ChangePer:=nil;
      end; {try..}
    end
    else
    Begin
      Set_BackThreadMVisible(BOn);

      ShowMessage('Change Period is unavailable whilst a background thread is running.');

      Set_BackThreadMVisible(BOff);

    end;
  end;
end;


{$IFDEF VAT}
  procedure TMainForm.Change_VAT;

  Var
    WasNew  :  Boolean;

  begin
    WasNew:=BOff;

    If (Not InMainThread) then
    Begin

      If (Not Assigned(ChangeVAT)) then
      Begin
        ChangeVAT:=TSetVATRate.Create(Self);
        WasNew:=BOn;
      end;

      try
        With ChangeVAT do
        Begin

          If (WindowState=wsMinimized) then
            WindowState:=wsNormal;

          If (WasNew) then
            ProcessSyss
          else
            Show;
        end; {With..}

      except
        ChangeVAT.Free;
        ChangeVAT:=nil;
      end; {try..}
    end
    else
    Begin
      Set_BackThreadMVisible(BOn);

      ShowMessage('The '+CCVATName^+' Rates are unavailable whilst a background thread is running.');

      Set_BackThreadMVisible(BOff);
    end;
  end;

{$ENDIF}



{$IFDEF JC}
  procedure TMainForm.Change_CIS;

  Var
    WasNew  :  Boolean;

  begin
    WasNew:=BOff;

    If (Not InMainThread) then
    Begin

      If (Not Assigned(ChangeCIS)) then
      Begin
        ChangeCIS:=TSetCISRate.Create(Self);
        WasNew:=BOn;
      end;

      try
        With ChangeCIS do
        Begin

          If (WindowState=wsMinimized) then
            WindowState:=wsNormal;

          If (WasNew) then
            ProcessSyss
          else
            Show;
        end; {With..}

      except
        ChangeCIS.Free;
        ChangeCIS:=nil;
      end; {try..}
    end
    else
    Begin
      Set_BackThreadMVisible(BOn);

      ShowMessage('The '+CCCISName^+' Rates are unavailable whilst a background thread is running.');

      Set_BackThreadMVisible(BOff);
    end;
  end;
{$ENDIF}

//-------------------------------------------------------------------------

// Event handler for OLD UK EC Sales list and for non-UK companies
procedure TMainForm.VEDIECSL1Click(Sender: TObject);
{$IFDEF VAT}
Var
  VATEDIWizard : TVATEDIWizard;
{$ENDIF}
begin
{$IFDEF VAT}
  If (Sender is TMenuItem) then
  Begin
    VEDIMode:=TMenuItem(Sender).Tag;

    VATEDIWizard:=TVATEDIWizard.Create(Self);
  end;
{$ENDIF}
end;

//------------------------------

// New menu option for new v6.2 UK EC Sales Export
procedure TMainForm.NewECSalesListJan10OnwardsClick(Sender: TObject);
begin
{$IFDEF VAT}
  ECSalesExport(self);
//  ShowMessage ('EParentU.NewECSalesListJan10OnwardsClick Not Coded - Have a nice day!');
{$ENDIF}
end;

//-------------------------------------------------------------------------


procedure TMainForm.CISEDI2Click(Sender: TObject);
{$IFDEF JC}
  Var
    CISEDIWizard  :  TCISEDIWizard;
  begin

    If (Sender is TMenuItem) then
    Begin
      CEDIMode:=TMenuItem(Sender).Tag;

      CISEDIWizard:=TCISEDIWizard.Create(Self);
    end;
{$ELSE}
  Begin

{$ENDIF}

end;


procedure TMainForm.CISXML2Click(Sender: TObject);
{$IFDEF JC}

  Var
    CISXMLWizard  :  TCISXMLWizard;
  begin

    If (Sender is TMenuItem) then
    Begin
      CEDIMode:=TMenuItem(Sender).Tag;

      CISXMLWizard:=TCISXMLWizard.Create(Self);
    end;
{$ELSE}
  Begin

{$ENDIF}

end;


procedure TMainForm.AllocWizard(Sender: TObject);

Var
  SalesMode,
  GetTrans  :  Boolean;

{$IFDEF ENAL503}

  begin

      If (Sender is TMenuItem) then
      Begin
        GetTrans:=(Sender=AllocPPY2) or (Sender=AllocSRC2);

        Set_alSales(TMenuItem(Sender).Tag=1,GetTrans);


        SalesMode:=(Sender=AllocSRC2);

        If (Not GetTrans) or (((Inv.InvDocHed In SalesSplit) and SalesMode) or ((Inv.InvDocHed In PurchSplit) and (Not SalesMode)) and
           (PayRight(Inv,SalesMode)) and (BaseTotalOS(Inv)<>0.0)) then
        Begin
          With TAllocateWiz.Create(Self) do
          Try
            If (GetTrans) then
            Begin
              Set_UpTransAlloc;

            end;

          except
            Free;

          end; {try..}
        end
        else
          ShowMessage('It is not possible to allocate '+Inv.OurRef);
      end;


  end;

{$ELSE}
  Begin


  end;
{$ENDIF}


procedure TMainForm.XXXCISGen1Click(Sender: TObject);


begin

    If (Sender is TMenuItem) then
    Begin
      If (Not InCISVoucher) then
      Begin
        InCISVoucher:=BOn;

        SetFMode(TMenuItem(Sender).Tag);

        With TCISVInp.Create(Self) do
        Try

        except
          Free;

        end; {try..}
      end
      else
      Begin
        Set_BackThreadMVisible(BOn);
        ShowMessage('The '+CCCISName^+' '+GetIntMsg(4)+' Ledger is currently in use.');
        Set_BackThreadMVisible(BOff);
      end;

    end

end;


procedure TMainForm.MoveStk1Click(Sender: TObject);
begin
  {$IFDEF LTE}
    {$IFDEF STK}

      If (Not Assigned(StkMoveList)) then
      Begin
        Set_LocalMode(2);

        StkMoveList:=TMoveLTList.Create(Self);
      end;

      try
        StkMoveList.Show;
      except

        FreeAndNil(StkMoveList);

      end; {try..}
    {$ENDIF}
  {$ENDIF}
end;


procedure TMainForm.XXXTranCradle1Click(Sender: TObject);


{$IFDEF NOM}
{$IFDEF EN571}
{Var
  NomVForm  :  TMoveLTList;}

Begin
  {Set_LocalMode(1);

  NomVForm:=TMoveLTList.Create(Self);


  Set_LocalMode(2);

  NomVForm:=TMoveLTList.Create(Self);}



{$ELSE}
  Begin

{$ENDIF}

{$ELSE}


{$IFDEF RETXX}
  Var
    RetForm  :  TRetDoc;
  begin
    Set_RETFormMode(SRN,0);

    RETForm:=TRetDoc.Create(Self);

    With RetForm do
      EditAccount(BOff,BOff,BOff);

{$ELSE}

{$IFDEF TRANCRADLE}
  {$IFDEF JAP}
  Var
    JAPForm  :  TJobAppWizard;
  begin
    Set_JPAJCT(Inv,Id,JPA,'','',0,0);
    JAPForm:=TJobAppWizard.Create(Self);

    With JAPForm do
      Show;

  {$ELSE}

    Begin
  {$ENDIF}

{$ENDIF}
{$ENDIF}

Begin

{$ENDIF}
end;


procedure TMainForm.XXXReCalcGLHed1Click(Sender: TObject);
begin
  {$IFDEF POST}
    AddCheckNom2Thread(Self,Nom,JobRec^,3);
  {$ENDIF}

end;




procedure TMainForm.XXXAllocSRC1Click(Sender: TObject);
begin
  AllocWizard(Sender);
end;

procedure TMainForm.XXXUnalocate1Click(Sender: TObject);
begin
  {$IFDEF DBD}
      {$IFDEF POST}
    {$IFDEF JC}
        Run_Test512

    {$ENDIF}
  {$ENDIF}


  {$ENDIF}
end;

procedure TMainForm.PAccrualsClick(Sender: TObject);
begin
  {$IFDEF SOP}
    {$IFDEF POST}
        AddAcruDel2Thread(Self,(Sender=SAccruals));
    {$ENDIF}
  {$ENDIF}
end;

procedure TMainForm.PRAccrual1Click(Sender: TObject);
begin
  {$IFDEF RET}
    {$IFDEF POST}
        AddAcruRet2Thread(Self,(Sender=SRAccrual1));
    {$ENDIF}
  {$ENDIF}

end;


procedure TMainForm.RemoveCommitClick(Sender: TObject);
begin
  {$IFDEF SOP}
    {$IFDEF POST}
        AddRemCommit2Thread(Self,BOff);
    {$ENDIF}
  {$ENDIF}

end;


procedure TMainForm.PAccrualRepClick(Sender: TObject);
Const
  SPRunNo  :  Array[BOff..BOn] of LongInt = (OrdUPRunNo,OrdUSRunNo);
var
  lAccrualRepDlg: TfrmAccrualRepDlg;
begin
  // TG: 10/02/2017- R1 ABSEXCH-17026 - A pop up dialog is added to give user the option to include the hold transactions or not.
  {$IFDEF RP}
    lAccrualRepDlg := TfrmAccrualRepDlg.create(nil);
    try
      if lAccrualRepDlg.ShowModal = mrOk then
        AddPostRep2Thread(2,SPRunNo[(Sender=SAccrualRep) or (Sender=SAccrualRep2)],0,Nil,BOn,Self, lAccrualRepDlg.chkInclude.Checked);
    Finally
      FreeAndNil(lAccrualRepDlg);
    end;
  {$ENDIF}
end;



{$IFDEF MC_On}

  procedure TMainForm.Change_Currency;

  Var
    WasNew  :  Boolean;

  begin
    If Allowed_In((AllowHotKey) and (Not Ignore_HT),199) then
    Begin
      WasNew:=BOff;

      If (Not InMainThread) then
      Begin

        If (Not Assigned(ChangeCurr)) then
        Begin
          //PR: 24/07/2012 ABSEXCH-12956 Replace old currency form with new currency list
          ChangeCurr:=TfrmCurrencyList.CreateWithMode(Self, clmNormal);
          WasNew:=BOn;
        end;

        try
          With ChangeCurr do
          Begin

            If (WindowState=wsMinimized) then
              WindowState:=wsNormal;

            If (WasNew) then
              LoadCurrencies //PR: 24/07/2012 ABSEXCH-12956
            else
              Show;
          end; {With..}

        except
          ChangeCurr.Free;
          ChangeCurr:=nil;
        end; {try..}
      end
      else
      Begin
        Set_BackThreadMVisible(BOn);

        ShowMessage('Currency Setup is unavailable whilst a background thread is running.');

        Set_BackThreadMVisible(BOff);
      end;

    end;
  end;

{$ENDIF}


{$IFDEF S2}

  procedure TMainForm.Change_Modules;

  Var
    WasNew  :  Boolean;

  begin
    If (AllowHotKey) and (Not Ignore_HT) then
    Begin
      WasNew:=BOff;

      If (Not Assigned(ChangeMod)) then
      Begin
        ChangeMod:=TSetModRec.Create(Self);
        WasNew:=BOn;
      end;

      try
        With ChangeMod do
        Begin

          If (WindowState=wsMinimized) then
            WindowState:=wsNormal;

          If (WasNew) then
            ProcessSyss
          else
            Show;
        end; {With..}

      except
        ChangeMod.Free;
        ChangeMod:=nil;
      end; {try..}
    end;
  end;

{$ENDIF}


{$IFDEF POST}

 procedure TMainForm.UseObjectCC(CCode     :  Str10;
                                 ScanMode,
                                 UpdateBal :  Boolean);

  Var
    WasNew  :  Boolean;
    LastFormFocus
            :  TForm;

  begin
    LastFormFocus:=Application.MainForm.ActiveMDIChild;


    Begin
      WasNew:=BOff;

      Begin

        If (Not Assigned(ObjectCC)) then
        Begin
          ObjectCC:=TCredPopUp.Create(Self);
          WasNew:=BOn;

          If (Assigned(LastFormFocus)) and (LastFormFocus<>ObjectCC) then
             LastFormFocus.Show;
        end;

        try
          With ObjectCC do
          Begin

            If (WindowState=wsMinimized) then
              WindowState:=wsNormal;

            If ((CCode<>ExLocal.LCust.CustCode) or (UpdateBal)) and (Not Freeze) then
              SetUpAccount(CCode);

            If (Not WasNew) and (Not ScanMode) then
              Show;
          end; {With..}

        except
          ObjectCC.Free;
          ObjectCC:=nil;
        end; {try..}
      end
    end;
  end;
{$ENDIF}


procedure TMainForm.ObjectCC1Click(Sender: TObject);
Var
  CCode  :  Str10;

begin
  {$IFDEF POST}
  If Allowed_In((AllowHotKey) and (Not Ignore_HT),427) then
  Begin
    IF (EmptyKey(Cust.CustCode,CustKeyLen)) then
      CCode:=Inv.CustCode
    else
      CCode:=Cust.CustCode;

    UseObjectCC(CCode,BOff,BOff);
  end;  
  {$ENDIF}

end;



{$IFDEF STK}

  procedure TMainForm.UseObjectStkEnq(CCode     :  Str20;
                                      LCode,
                                      CuCode    :  Str10;
                                      ScanMode  :  Boolean);

   Var
     WasNew  :  Boolean;
     LastFormFocus
             :  TForm;

   begin
     LastFormFocus:=Application.MainForm.ActiveMDIChild;

     Begin
       WasNew:=BOff;

       Begin

         If (Not Assigned(ObjectStkEnq)) then
         Begin
           ObjectStkEnq:=TStkWarn.Create(Self);
           WasNew:=BOn;

         end;

         try
           With ObjectStkEnq do
           Begin

             If (WindowState=wsMinimized) then
               WindowState:=wsNormal;

               InitObjectMode(CCode,LCode,CUCode);

             If (WasNew) and (Assigned(LastFormFocus)) and (LastFormFocus<>ObjectStkEnq) then
               LastFormFocus.Show;

             If (Not WasNew) and (Not ScanMode) then
               Show;
           end; {With..}

         except
           ObjectStkEnq.Free;
           ObjectStkEnq:=nil;
         end; {try..}
       end
     end;
   end;


   procedure TMainForm.UseObjectPrice(CKAnal    :  CKAnalType;
                                      ScanMode  :  Boolean);

   Var
     WasNew  :  Boolean;
     LastFormFocus
             :  TForm;


   begin
     LastFormFocus:=Application.MainForm.ActiveMDIChild;

     Begin
       WasNew:=BOff;

       Begin

         If (Not Assigned(ObjectPrice)) then
         Begin
           ObjectPrice:=TObjPrice.Create(Self);
           WasNew:=BOn;

           If (Assigned(LastFormFocus)) and (LastFormFocus<>ObjectPrice) then
             LastFormFocus.Show;
         end;

         try
           With ObjectPrice do
           Begin

             If (WindowState=wsMinimized) then
               WindowState:=wsNormal;

             If (Not Freeze) then
               InitObjectMode(CKAnal);

             If (Not WasNew) and (Not ScanMode) then
               Show;
           end; {With..}

         except
           ObjectPrice.Free;
           ObjectPrice:=nil;
         end; {try..}
       end
     end;
   end;


   procedure TMainForm.ObjPriceLink(CCode2  :  Str10;
                                    SCode2  :  Str20;
                                    LCode2  :  Str5;
                                    Curr2,
                                    TCurr   :  SmallInt;
                                    ScanMode,
                                    Ok2Create:  Boolean);
   Var
     CKAnal  :  CKAnalType;

   Begin
     If (Assigned(ObjectPrice)) or (Ok2Create) then
     Begin
       If (Assigned(ObjectPrice)) then
         CKAnal:=ObjectPrice.OPCKAnal
       else
         Blank(CKAnal,Sizeof(CKAnal));

       If (CCode2<>'') then
         CKAnal.CCode:=CCode2;

       If (SCode2<>'') then
         CKAnal.SCode:=SCode2;

       If (LCode2<>CKAnal.LocFilt) then
         CKAnal.LocFilt:=LCode2;

       If (Curr2<>CKAnal.RCr) and (Curr2>=0) then
         CKAnal.RCr:=Curr2;

       If (TCurr<>CKAnal.RTxCr) and (TCurr>=0) then
         CKAnal.RTxCr:=TCurr;

       UseObjectPrice(CKAnal,ScanMode);
     end;
   end;

{$ENDIF}

procedure TMainForm.ObjectStk1Click(Sender: TObject);
Var
  CCode  :  Str20;

begin
  {$IFDEF STK}
    If (FullStkSysOn) then
    Begin
      IF (EmptyKey(Stock.StockCode,StkKeyLen)) then
        CCode:=Id.StockCode
      else
        CCode:=Stock.StockCode;

      UseObjectStkEnq(CCode,'','',BOff);
    end;
  {$ENDIF}

end;


{$IFDEF SOP}
  procedure TMainForm.Set_StkSuperOpo(Mode  :  Byte;
                                      ORec  :  tObjectSERec);

  Var
    OpoMode  :  Byte;

  Begin
    If (ORec.OSCode<>Stock.StockCode) then
      Global_GetMainRec(StockF,ORec.OSCode);

    If (Stock.StockFolio<>0) then
    Begin
      OpoMode:=Stock_HasSuperOpo(Stock.StockFolio);

      If (OpoMode<>0) then
      Begin
        If (Not Assigned(ObjectStkEnq)) then
        With ORec do
          UseObjectStkEnq(OSCode,OLCode,OCCode,BOff);

        If (Assigned(ObjectStkEnq)) then
          ObjectStkEnq.SetEquivView(OpoMode);

      end;
    end;
  end;

{$ENDIF}

procedure TMainForm.ObjPrice1Click(Sender: TObject);

{$IFDEF STK}

  Var
    CKAnal  :  CKAnalType;

{$ENDIF}

begin
  {$IFDEF STK}
    Blank(CKAnal,Sizeof(CKAnal));

    With CKAnal do
    Begin

      IF (EmptyKey(Stock.StockCode,StkKeyLen)) then
        SCode:=Id.StockCode
      else
        SCode:=Stock.StockCode;

      IF (EmptyKey(Cust.CustCode,CustKeyLen)) then
        CCode:=Inv.CustCode
      else
        CCode:=Cust.CustCode;
     end;

    UseObjectPrice(CKAnal,BOff);
  {$ENDIF}

end;



{* Control final stage of print job *}

Procedure TMainForm.Print_File(SetAddr  :  LongInt);

Var
  TParam,
  PParam  :  ^TPrintParam;

Begin
  {$IFDEF DONOTUSE}
    TParam:=Pointer(SetAddr);

    New(PParam);

    PParam^:=TParam^;

    {$IFDEF FRM}
      With PParam^ do
        If (PBatch) then
          pfPrintBatch(RepCaption,PDevRec.NoCopies,BOff, PDevRec.feJobtitle)
        else
          PrintFileTo(PDevRec,FileName,RepCaption);
    {$ENDIF}

    Dispose(PParam);
  {$ELSE}
     If (Assigned(BackThread)) then
     Try
        BackThread.PrintJobAddr:=SetAddr;
        BackThread.Print_ThJob;
     except;

     end; {Try..}

  {$ENDIF}
end;



{* Control final stage of print job *}
{$IFDEF FRM}
  Procedure TMainForm.Fax_File(SetAddr  :  LongInt);

  Var
    EntFaxO : TEntFaxInt;
    Res     : SmallInt;

  Begin
    EntFaxO:=Pointer(SetAddr);

    Try
      With EntFaxO do
      Begin
        {$IFDEF DBD}
          ShowMEssage('Call Created within EparentU');
        {$ENDIF}
        Res := StoreDetails;
      end;
    Finally
      EntFaxO.Destroy;
    end;
  end;
{$ENDIF}

// CA  04/06/2012   v7.0  ABSEXCH-12302:    Startup Upgrade Info Window
Procedure TMainForm.WMUpgradeForm(Var Message : TMessage);
Var
  WINLogIn              : String;
  Path                  : string;
  Ini                   : TIniFile;
  DisplayUpgradeInfo    : Boolean;
Begin
  Path     := GetEnterpriseDirectory;
  WinLogIn := '';
  WinLogIn := UpCaseStr(WinGetUserName);
  DisplayUpgradeInfo := BOff;
  If FileExists (Path+ '\DocMastr\UpgradeInfo\UpgradeInfo.HTM') Then
  Begin
    If FileExists (Path+ '\MISC\UpgradeInfo.INI') Then
    Begin
      With TIniFile.Create (Path+ '\MISC\UpgradeInfo.INI') Do
      Try
        if ReadBool( 'UpgradeWindow', WinLogIn, True ) then
           DisplayUpgradeInfo := BOn;
      finally
      end;
    End
    Else
      DisplayUpgradeInfo := BOn;
    If DisplayUpgradeInfo Then
    Begin
      // Bringing Up Upgrade Details HTML
      TUpgradeForm.Create(Application.MainForm);
    End;
  End; 
End;

Procedure TMainForm.WMFormCloseMsg(Var Message  :  TMessage);

Const
  MsgOrd  :  Array[11..15] of Byte = (1,0,2,3,4);

Var
  CCode  :  ^Str20;

  {$IFDEF DBD} {OTC_Hang}
    OTCName  :  ^Str100;
  {$ENDIF}

  ORec   :  ^tObjectSERec;

  {$IFDEF CU}
    ExLocal  :  TdExLocal;

  {$ENDIF}


Begin
  Update_DriveResource;

  With Message do
  Begin

    Case WParam of

      0  :  ;  {Dummy sent by update stats}
               {Messages 0,1 could be sent by the global posting routine, although very unlikely as the messages
                are sent whilst waiting for another machine to post, which would not happen for global post as it locks }

      1  :  Begin
              {$IFDEF C_On}
                InTradeList:=0;
                CustList:=nil;
              {$ENDIF}
            end;

      11..15
         :  InSPDayBk[MsgOrd[WParam]]:=0;

      {$IFDEF JC}
        {$IFDEF DBk_On}

          17  :  Begin
                   JCDayBk:=Nil;
                   InJCDayBk:=0;
                 end;
        {$ENDIF}
      {$ENDIF}

      18 :  Begin
              {$IFDEF C_On}
                HotCust:=nil;
              {$ENDIF}
            end;



      20 :  InAddInv:=BOff;

      21 :  Begin
              {$IFDEF Stk}
                HotStock:=nil;
              {$ENDIF}
            end;

      {$IFDEF RET}
        25,26
          :  InSPDayBk[WParam-20]:=0;
      {$ENDIF}

      36 :  Begin
              {$IFDEF JC}
                HotJob:=nil;
              {$ENDIF}
            end;

      40 :  InNominal:=BOff;

      41 :  InNomView:=BOff;

      {$IFDEF SOP}
        43 :  MLocList:=nil;
      {$ENDIF}

      {$IFDEF RET}
        44 :  RetLTList:=nil;
      {$ENDIF}


      45 :  Begin
              InObjDrill:=BOff;
              ObjDrillPtr:=nil;
            end;

      46 :  InStkTree:=BOff;
      47 :  InStkList:=0;

      {$IFDEF PF_On}
        {$IFDEF CC}

          48,49
             :  Begin
                  InCCDep[(WParam=49)]:=BOff;
                  CCDepList[(WParam=49)]:=nil;
                end;
        {$ENDIF}
      {$ENDIF}

      50  :  ChangePer:=nil;

      {$IFDEF MC_On}
        51  :  ChangeCurr:=nil;
      {$ENDIF}

      {$IFDEF VAT}
        52  :  ChangeVAT:=nil;
      {$ENDIF}

      {$IFDEF SY}
        53  :  SysGenSet:=nil;
      {$ENDIF}

      {$IFDEF S2}
        54  :  ChangeMod:=nil;
      {$ENDIF}

       55  :  InJobTree:=BOff;

       {$IFDEF JC}
         56  :  EmplList:=nil;
         57  :  JAnalList:=nil;

         65  :  ChangeCIS:=nil;
         66  :  InCISVoucher:=BOff;

        179 :  Begin
                 InCISObjDrill:=BOff;
                 CISObjDrillPtr:=nil;
               end;

       {$ENDIF}

      {$IFDEF MC_On}
        60  :  {* Revaluation stopped, force active window to close *}
               PostMessage(Screen.ActiveForm.Handle,WM_Close,0,0);

      {$ENDIF}

      {$IFDEF SY}

        62  :  DNCtrl:=nil;
        63  :  GLCCCtrl:=nil;
        64  :  ErrLogFrm:=nil;

        {65 :  JC CIS}
        {66 :  CIS Voucher List}
        {67 :  From Report drill down}


      {$ENDIF}

      70,71  :  Begin
                  InBatchPay[(WParam=71)]:=BOff;
                end;

        74   :  ; {Sent by posting thread to re-enable daybooks, not applicable to main form}

      {$IFDEF POST}
          75  :  ObjectCC:=nil;

          76,77
              :  If (LParam<>0) then
                 Begin
                   CCode:=Pointer(LParam);

                   If (Assigned(ObjectCC)) then
                   Begin
                     UseObjectCC(CCode^,BOn,(WParam=77));
                   end;

                   {$IFDEF STK}
                     If (Assigned(ObjectPrice)) then
                       ObjPriceLink(CCode^,'','',-1,-1,BOn,BOff);

                   {$ENDIF}

                   Dispose(CCode);
                 end;
      {$ENDIF}

      84     :  ; {* Sent by posting thread to disable daybook, not applicabale when post all ledgers used *}

      {* Sent by thread once report job has been completed, and ready for output *}

      98  :  Print_File(LParam);

      {$IFDEF  FRM}
        67  :  ; {Holder for report drill down. Never gets used as display auto closes}

       99  :  Fax_File(LParam);

      {$ENDIF}

      101,
      102 :  Begin
               FormDesign;  {* Sent by closure of passowrd list, so any new passwords can take effect *}

               If (WParam=102) then {* Update any other open forms.. *}
               begin
                 Send_PWordUpDate(WM_CustGetRec,177);
                 //RB 26/12/2017 2018-R1 ABSEXCH-19586: User permission implementation related to Anonymisation Control Centre window 
                 Send_PWordUpDate(WM_AnonControlCentreMsg, 1);
               end;

               SetIntMessage;
              end;

      //RB 26/12/2017 2018-R1 ABSEXCH-19586: User permission implementation related to Anonymisation Control Centre window 
      103 :  Begin
               Send_PWordUpDate(WM_AnonControlCentreMsg, 2);
             end;
             
      120  :  Begin
                Try
                  FromReLogOn:=BOn;
                  Release_Modules(LParam);
                finally
                  FromReLogOn:=BOff;
                end; {try}
              end;

      130  :  Display_AutoDiary;

      {$IFDEF POST}
        140  :  ObjectCC:=nil;
      {$ENDIF}



      { 179  :  CIS Obj Drill }
      {$IFDEF STK}
        211  :  ObjectStkEnq:=nil;

        212,218
             : If (LParam<>0) then
               Begin
                 ORec:=Pointer(LParam);

                 If (Assigned(ObjectStkEnq)) then
                 Begin

                   UseObjectStkEnq(ORec^.OSCode,ORec^.OLCode,ORec^.OCCode,BOn);

                 end;

                 If (Assigned(ObjectPrice)) or (WParam=218) then
                   ObjPriceLink(ORec^.OCCode,ORec^.OSCode,ORec^.OLCode,ORec^.OCurr,ORec^.OTCurr,BOn,(WParam=218));

                 Dispose(ORec);

               end;

        217  :  ObjectPrice:=nil;


        {$IFDEF SOP}
          229  :  Begin
                    If (LParam<>0) then
                    Begin
                      ORec:=Pointer(LParam);

                      Set_StkSuperOpo(0,ORec^);

                      Dispose(ORec);
                    end;
                  end;
        {$ENDIF}

        {$IFDEF LTE}
          277  :  StkMoveList :=nil;
        {$ENDIF}

      {$ENDIF}

      {$IFDEF NP}
        213  :  begin
                  GlobDiary:=nil;
                  DiaryFrm := nil;
                end;
      {$ENDIF}
        214  :  Begin
                  Timer1.Free;
                  Timer1:=Nil;
                  Application.OnMessage:=nil;
                end;

      {$IFDEF CU}
        222  :  Begin
                  ExLocal.Create;
                  Try
                    ExecuteCustBtn(MiscBase+2,10,ExLocal);
                  Finally
                    ExLocal.Destroy;
                  end; {Try..}
                end;

      {$ENDIF}

      250  :  Begin {Can we show the menu option top copy to G/L View}
                If (InNominal and InNomView) and (Assigned(GLViews)) and (Assigned(NomView)) then
                Begin
                  NomView.N8.Visible:=(GLViews.ViewCb1.ItemIndex>0);
                  NomView.CopyToGLView1.Visible:=NomView.N8.Visible;
                end;
              end;

      251  :  If (InNominal and InNomView) and (Assigned(GLViews)) and (Assigned(NomView)) and (LParam<>0) then
              Begin
                GLViews.CopyFromGLNo:=LParam;
                GLViews.Copy1Click(GLViews.Show1);
              end;

      252    :  {Thread Controller has detected a crash, and bombed, release it and reset it, in an attempt to auto recover}
                Begin
                  {$B-}
                  If (Assigned(BackThread)) and (BackThread.ExecuteOff) then
                  {$B+}
                  Begin
                    try
                      BackThread:=nil;
                    finally {* We did it the nice way, abort *}
                      CustomDlg(Application.MainForm,'Error!','ObjectThread Controller Failure',
                                'A problem has been detected within the ObjectThread Controller.'+#13+#13+
                                OrigCaption+' may become unstable if you continue using it now.'+#13+
                                'Please exit the system now, and contact your support provider if this problem persists.',
                                mtError,
                                [mbOk]);

                    end; {try..}
                  end;
                end;

      { CJS 2013-08-09 - ABSEXCH-14525 - VAT100 form opens unnecessarily }
      253:  begin
              VatSubForm := TVatSubForm.Create(Application.MainForm);
            end;

      {$IFDEF DBD} {OTC_Hang}
         500,501
              :  Begin
                   OTCName:=Pointer(LParam);

                   DebugForm.Add(OTCName^);

                 end;

      {$ENDIF}

      // The Intrastat Control Centre form has been closed, so release the
      // variable
      WP_CLOSE_ICC_FORM:
        begin
          ICCFrm := nil;
        end;




    end; {Case..}

  end;
  Inherited;
end;


Procedure TMainForm.WMKeyDown(Var Message  :  TMessage);


Begin

  If (AllowHotKey) then
  With Message do
  Begin

    Case WParam of

      1  :  ;

    end; {Case..}

  end;
  Inherited;
end;



procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {* This entry not really necessary, as WMKeydown also gets called,
     however, not sure if shift states get passed to WMKeydown.. *}

  If (AllowHotKey) and (Not Ignore_HT) then
  Begin

    Case Key of

      // NF: 15/05/06 brings up the help contents / index window.
      // Otherwise For some reason F1 does not work when you first open IAO / Exchequer
      VK_F1  :  if (Shift = []) then Application.HelpCommand(HELP_Finder,0);

      VK_F2  :Begin
                OpenBtnClick(Cust1);

              end;

      VK_F3  :Begin
                OpenBtnClick(Supp1);
              end;

      VK_F4  :Begin
                If (Not (ssCtrl In Shift)) and (Not (ssAlt In Shift)) and (Not (ssShift In Shift)) then

                  MainNomBtnClick(nil)
                {$IFNDEF LTE}
                  else
                    If (ssCtrl In Shift) then
                      NominalLedger2Click(nil);
                {$ELSE}
                  ;
                {$ENDIF}
              end;

      VK_F5  :  VS1Click(nil);

      VK_F6  :  Change_Period;

      VK_F8  :  If (ssShift In Shift) then
                  DDa1BtnClick(nil)
                else
                  CustQFBtnClick(nil);

      VK_F11 :Begin

                {$IFNDEF LTE}

                  If (ssShift In Shift) then
                    MainStockBtnClick(nil)
                  else
                    {$IFDEF XMC_OnX}
                      If (ssCtrl In Shift) then
                        Change_Currency
                      else
                    {$ENDIF}

                {$ENDIF}
                SList1Click(Sender);

              end;
    end; {Case..}

  end;

end;



Procedure TMainForm.WMCallViaComp(Var Message  :  TMessage);

Var
  CCode  :  ^Str20;

Begin

  With Message do
  Begin
    If (LParam<>0) then
    Begin
      CCode:=Pointer(LParam);

      Case WParam of

      {$IFDEF C_On}

        1  :  HotLinkCust(FullCustCode(CCode^));

      {$ELSE}
        1  :  ;
      {$ENDIF}

      {$IFDEF STK}

        2  :  HotLinkStock(FullStockCode(CCode^));

      {$ENDIF}

      {$IFDEF JC}

        3  :  HotLinkJob(FullJobCode(CCode^));

      {$ENDIF}

      end; {Case..}

      Dispose(CCode);
    end;
  end;

  Inherited;
end;

procedure TMainForm.CustQFBtnClick(Sender: TObject);

Var
  TradPage    :  Byte;

  ReturnCtrl  :  TReturnCtrlRec;


begin
  If Allowed_In((AllowHotKey) and (Not Ignore_HT),53) then
  Begin
  {$IFDEF GF}

    If (Sender is TMenuItem) then
      TradPage:=TMenuItem(Sender).Tag
    else
      TradPage:=Ord((Sender=QFSupp1));

    FillChar(ReturnCtrl,Sizeof(ReturnCtrl),0);

    Ctrl_GlobalFind(Self,ReturnCtrl,TradPage);

  {$ENDIF}
  end;
end;

//-------------------------------------------------------------------------

// MH 03/10/2016 2016-R3 ABSEXCH-17754: Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
Procedure TMainForm.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin // WMGetMinMaxInfo
  With Message.MinMaxInfo^ Do
  Begin
    ptMinTrackSize.X := MinSizeX;
    ptMinTrackSize.Y := MinSizeY;
  End; // With Message.MinMaxInfo^

  Message.Result:=0;

  Inherited;
End; // WMGetMinMaxInfo

//-------------------------------------------------------------------------
//RB 07/06/2017 2017-R2 ABSEXCH-14156: Temporary Data Files limited to 255 files - Causing Form Printing to Crash (Exch365)
procedure TMainForm.CleanUpSwap;
var
  lParam: AnsiString;
begin
  {Param[0] :- Executable path
   Param[1] :- Path of folder to clean up in Company Directory //eg --//companydir/Swap
   Param[2] :- How many no. of days older files to be deleted}

  lParam := ExtractFilePath(Application.ExeName) + 'ExchDeleteTempFiles.exe' + ' ' +
            IncludeTrailingPathDelimiter(SetDrive) + 'SWAP' + ' ' +
            '7';
  WinExec(PCHAR(lParam), SW_HIDE);
end;

//-------------------------------------------------------------------------

procedure TMainForm.FormResize(Sender: TObject);
begin
  StatusBar.Sizegrip:=(WindowState<>wsMaximized);

  { Set Tag to height of toolbars, footers, etc}
  { not including menu's or scrollbars         }
  //Tag := SpeedPanel.Height + StatusBar.Height;
  Tag := AdvDockPanel.Height + StatusBar.Height;

  InvalidateRect(ClientHandle, nil, True);
end;

//-------------------------------------------------------------------------

procedure TMainForm.FAddBtnClick(Sender: TObject);
begin

  {$IFDEF Inv}

    If (Not InAddInv) then
    Begin
      AddInvForm:=TInvAddForm.Create(Self);

      try
        AddInvForm.FormStyle:=fsMdiChild;
        AddInvForm.Show;

      except

        AddInvForm:=nil;

      end;{try..}
    end
    else
    With AddInvForm do
    Begin
      If (WindowState=wsMinimized) then
        WindowState:=wsNormal;

      Show_Current;
      
    end;

    InAddInv:=(AddInvForm<>nil);

  {$ENDIF}

end;

{ == Procedure to Send Message to Get Record == }

Procedure TMainForm.Send_UpdateList(WMMsg  :  LongInt;
                                    Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WMMsg;
    WParam:=Mode;
  end;

  If (ActiveMDIChild<>nil) then
  With Message1 do
  Begin
    MessResult:=SendMEssage(ActiveMDIChild.Handle,Msg,WParam,LParam);
    If (InObjDrill) and (ObjDrillPtr<>nil) then
      MessResult:=SendMEssage(TObjDFrm(ObjDrillPtr).Handle,Msg,WParam,LParam);
  end;


end; {Proc..}



{ == Procedure to Send Message to Get Record == }

Procedure TMainForm.Send_PWordUpDate(WMMsg  :  LongInt;
                                     Mode   :  Integer);

Var
  Message1 :  TMessage;
  I,
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WMMsg;
    WParam:=Mode;
  end;

  If (ActiveMDIChild<>nil) then
  With Message1 do
  Begin
    for I := 0 to Pred(MDIChildCount) do
      If (MDIChildren[I]<>ActiveMDIChild) then
        MessResult:=SendMEssage(MDIChildren[I].Handle,Msg,WParam,LParam);
  end;


end; {Proc..}



procedure TMainForm.DDn1BtnClick(Sender: TObject);
begin
  Send_UpdateList(WM_CustGetRec,169);
end;


procedure TMainForm.Display_ObjectDrill;

Var
  ObjectDrill  :  TObjDFrm;
  NewNow       :  Boolean;

Begin
  NewNow:=BOff;

  Send_UpdateList(WM_CustGetRec,171);

  If (Not InObjDrill) then
  Begin
    {*EN431MB2B*}
    Set_ODDMode(0);

    ObjectDrill:=TObjDFrm.Create(Self);
    ObjDrillPtr:=ObjectDrill;
    NewNow:=BOn;
    InObjDrill:=BOn;
  end
  else
    ObjectDrill:=ObjDrillPtr;

  try
    With ObjectDrill do
    Begin
      If (Not NewNow) then
        BuildObjectDrill;

      Show;

    end;

  except

    ObjectDrill.Free;
    ObjDrillPtr:=nil;
    InObjDrill:=BOff;

  end; {try..}

end;

{$IFDEF JC}
  procedure TMainForm.Display_CISObjectDrill;

  Var
    ObjectDrill  :  TObjCFrm;
    NewNow       :  Boolean;
    NewLeft      :  Integer;
    ListPoint  :  TPoint;


  Begin
    NewNow:=BOff;

    Send_UpdateList(WM_CustGetRec,171);

    If (Not InCISObjDrill) then
    Begin
      SetOCMMode(2);

      ObjectDrill:=TObjCFrm.Create(Self);
      CISObjDrillPtr:=ObjectDrill;
      NewNow:=BOn;
      InCISObjDrill:=BOn;

    end
    else
      ObjectDrill:=CISObjDrillPtr;

    try
      With ObjectDrill do
      Begin
        NewLeft:=Succ(Application.MainForm.ActiveMDIChild.Left+Application.MainForm.ActiveMDIChild.Width);

        ListPoint:=Application.MainForm.ActiveMDIChild.ClientToScreen(Point(0,0));

        ObjectDrill.Left:=NewLeft;
        ObjectDrill.Top:=ListPoint.Y-(Height-ClientHeight)+3;

        If (Not NewNow) then
          BuildObjectDrill;

        Show;
        BringToFront;

      end;

    except

      ObjectDrill.Free;
      CISObjDrillPtr:=nil;
      InCISObjDrill:=BOff;

    end; {try..}

  end;
{$ENDIF}


procedure TMainForm.DDa1BtnClick(Sender: TObject);
begin
  {$IFDEF INV}

    {$B-}
      If (ActiveMDIChild<>nil)
      and ((ActiveMDIChild Is TSalesTBody)
      or  (ActiveMDIChild Is TRecepForm)
      {$IFDEF JC}
        or  (ActiveMDIChild Is TTSheetForm)
      {$ENDIF}
      {$IFDEF WOP}
        or  (ActiveMDIChild Is TWOR)
      {$ENDIF}
      {$IFDEF RET}
        or  (ActiveMDIChild Is TRETDoc)
      {$ENDIF}
      {$IFDEF JAP}
        or  (ActiveMDIChild Is TJCAPP)
      {$ENDIF}

      {$IFDEF STK}
        or  (ActiveMDIChild Is TStkAdj)
      {$ENDIF}

      or  (ActiveMDIChild Is TNTxfrForm)) then {* its an invoice *}
    {$B+}
      Begin
        Display_ObjectDrill;
      end
      else
        If (CISOn) and (ActiveMDIChild Is TCISVoucher) then
          Display_CISObjectDrill;

  {$ENDIF}

end;


{ Callback function to identify the form designer window }
function EnumWndProc (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
var
  ClassName : string;
  Tag       : THandle;
begin
  Result := True;
  SetLength (ClassName, 100);
  GetClassName (Hwnd, PChar (ClassName), Length (ClassName));
  ClassName := PChar (Trim(ClassName));

  If (AnsiCompareText (ClassName, 'TForm_Designer') = 0) then begin
    Tag := GetWindowLong (Hwnd, GWL_USERDATA);
    If (Tag = 1010) Then Begin
      FoundWnd^ := Hwnd;
      Result := False;
    End; { If }
  End; { If }
end;

{ Callback function to identify the form designer window }
function EnumWndProcRW (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
var
  ClassName : string;
  Tag       : THandle;
begin
  Result := True;
  SetLength (ClassName, 100);
  GetClassName (Hwnd, PChar (ClassName), Length (ClassName));
  ClassName := PChar (Trim(ClassName));

  If (AnsiCompareText (ClassName, 'TForm_RWMain') = 0) then begin
    Tag := GetWindowLong (Hwnd, GWL_USERDATA);
    If (Tag = 1010) Then Begin
      FoundWnd^ := Hwnd;
      Result := False;
    End; { If }
  End; { If }
end;

{ Callback function to identify the Visual Report Writer window }
function EnumWndProcVisualRW (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
var
  ClassName : string;
  Tag       : THandle;
begin
  Result := True;
  SetLength (ClassName, 100);
  GetClassName (Hwnd, PChar (ClassName), Length (ClassName));
  ClassName := PChar (Trim(ClassName));

  If (AnsiCompareText (ClassName, 'TfrmReportTree') = 0) then
  begin
    Tag := GetWindowLong (Hwnd, GWL_USERDATA);
    If (Tag = 1010) Then Begin
      FoundWnd^ := Hwnd;
      Result := False;
    End; { If }
  End; { If }
end;

(********
procedure TMainForm.FormDesigner1Click(Sender: TObject);

Var
  Cmd,
  ClassNme,
  EXEName,
  CDir,
  LNull    : Array [0..255] Of Char;


  n,
  DRes     :  Integer;

  LStr     :  Str255;

  FDHWND   :  HWnd;
  Message  :  TMessage;
  StartI   :  TStartupInfo;
  ProcessInformation: TProcessInformation;
begin

  Blank (LNull, SizeOf (LNull));

  StrPCopy(ClassNme,'TForm_Designer'+#0);

  StrPCopy(EXEName,'Form Designer - Exchequer Enterprise'+#0);

  FDHWnd:=FindWindow(ClassNme,EXEName);

  If (FDHWND<>0) then Begin
    Windows.SetFocus(FDHWND);
    ShowWindow(FDHWnd,SW_Show);
    SendMessage(FDHWnd,WM_SBSFDMsg,0,0);
  end
  else Begin
    { Not already running - run a new copy }
****)
(********
    {$IFNDEF MH}
      StrPCopy(EXEName,'FORMDES.EXE');

      LStr:='';
      Blank (LNull, SizeOf (LNull));

      If (RemDirOn) then
        LStr:=RemDirSwitch+' '+SetDrive;

      LStr:=LStr+SBSParam+LoginParam+' '+ExVersParam^;

      StrPCopy(LNull,LStr);

      StrPCopy(Cmd,'open');

      {$IFDEF SY}
        StrPCopy(CDir,''); {* should always be run via same dir as enterprise *}
      {$ELSE}
        {$IFNDEF MH}
          StrPCopy(CDir,SetDrive); {* during development, run from /dir path *}
        {$ELSE}
          StrPCopy(CDir,'');
        {$ENDIF}
      {$ENDIF}

      DRes:=ShellExecute(Self.Handle,Cmd,EXEName,LNull,CDir,SW_ShowNormal);
    {$ELSE}
**********)(*****
      Blank (LNull, SizeOf (LNull));
      LStr:=ExtractFilePath(Application.EXEName)+'FormDes.Exe ';
      If (RemDirOn) then
        LStr:=LStr+RemDirSwitch+' '+SetDrive;
      LStr:=LStr+SBSParam+LoginParam+' '+ExVersParam^;
      StrPCopy(LNull,LStr);

      WinExec(LNull, SW_SHOW);
    { ENDIF}
  end;


end;
*****)

procedure TMainForm.FormDesigner1Click(Sender: TObject);
Var
  OldHWnd : HWnd;
  LNull   : Array [0..255] Of Char;
  LStr    : Str255;
begin
  OldHwnd := 0;
  EnumWindows (@EnumWndProc, Longint(@OldHwnd));
  If (OldHwnd <> 0) Then Begin
    If (Not IsWindowVisible (OldHWnd)) Then
      PostMessage (OldHwnd, WM_SBSFDMsg, 0, 0);
    SetForeGroundWindow (OldHwnd);
    (*
    Windows.SetFocus(OldHwnd);
    ShowWindow  (OldHwnd, SW_Show);
    SendMessage (OldHwnd, WM_SBSFDMsg, 0, 0);
    *)
  End { If }
  Else Begin
    { Not already running - run a new copy }
    Blank (LNull, SizeOf (LNull));
    LStr:=ExtractFilePath(Application.EXEName)+'FormDes.Exe ';
    If (RemDirOn) then
      LStr:=LStr+RemDirSwitch+' '+SetDrive;
    LStr:=LStr+SBSParam+LoginParam+' '+ExVersParam^ + ' ' + FDesStartCode;
    StrPCopy(LNull,LStr);

    WinExec(LNull, SW_SHOW);
  End; { Else }
end;

procedure TMainForm.Purge1Click(Sender: TObject);
Var
  OldHWnd : HWnd;
  LNull   : Array [0..255] Of Char;
  LStr    : Str255;
  GetMode : Integer;
begin
  OldHwnd := 0; GetMode:=0;

  EnumWindows (@EnumWndProc, Longint(@OldHwnd));
  If (OldHwnd <> 0) Then Begin
    If (Not IsWindowVisible (OldHWnd)) Then
      PostMessage (OldHwnd, WM_SBSFDMsg, 0, 0);
    SetForeGroundWindow (OldHwnd);
    (*
    Windows.SetFocus(OldHwnd);
    ShowWindow  (OldHwnd, SW_Show);
    SendMessage (OldHwnd, WM_SBSFDMsg, 0, 0);
    *)
  End { If }
  Else
  Begin
    If (Sender is TMenuItem) then
      GetMode:=TMenuItem(SEnder).Tag;

    If (GetMode In [1,2]) then
    Begin
      { Not already running - run a new copy }
      Blank (LNull, SizeOf (LNull));
      LStr:=ExtractFilePath(Application.EXEName)+'SPECFUNC.EXE ';

      If (RemDirOn) then
        LStr:=LStr+RemDirSwitch+' '+SetDrive;
      LStr:=LStr+' /RP: '+IntToStr(GeTMode);
      StrPCopy(LNull,LStr);

      WinExec(LNull, SW_SHOW);

      SendMessage(Self.Handle,WM_Close,0,0);
    end;
  End; { Else }
end;

procedure DisplayLoginDialog;
var
  lLoginDialog: TfrmLogin;
  lLocked: Boolean;
  Res, lRes: LongInt;
  lUserCountCaption: String;
  {$IFDEF SEC500}
    oMCMSecurity: TMCMSecurity;
  {$ENDIF}
begin
  lLoginDialog := TfrmLogin.Create(Application);
  try
    with lLoginDialog do
    begin
      LoginDialog := ldExchequerCore;
      ProcessSecurity(lUserCountCaption{$IFDEF SEC500}, oMCMSecurity {$ENDIF}); {Perform security checks for exclusivity etc}
      lblUserCount.Caption := lUserCountCaption;
      {$IFDEF S2}
        SetEnSecurity;
      {$ENDIF}
      InitDefaults; {Init Defaults values}
      ShowModal; 
      GotPassword := (ModalResult=mrOk);
      Application.Title := Branding.pbProductName+'.' + Syss.UserName;
      SetLogInParams;
      {Enterprise v5.00 Security}
      {$IFDEF SEC500}
        if GotPassword then
        begin
          // Add a login reference record for this login
          lLocked := True;
          if GetMultiSys(BOn, lLocked, SysR) and lLocked then
          begin
            Res := oMCMSecurity.AddLoginRefEx;
            if Res = 0 then
            begin
              { Only change the User Count if the MCM bit worked - better chance of
                keeping the system consistent if either fails }
              Inc(Syss.EntULogCount);

              {$IFDEF CU}
                {MH 18/01/2010; Copy Company Code into Customisation for use from Hook Points}
                SetCustomisationCompanyCode (oMCMSecurity.msCompanyCode);
              {$ENDIF}

              //PR: 02/02/2018 Set the company code for the PII Scanner - needed for Contacts plug-in
              CompanyCodeForPIIScanner := oMCMSecurity.msCompanyCode;

              {$IFDEF EXSQL}
                {MH 08/02/2010: Check for Web Extensions licence - doing it here to minimise overhead during startup}
                if SQLUtils.UsingSQL then
                begin
                  lRes := oMCMSecurity.CheckPlugInLicence('EXCHQRLIVE999000'); // LIVE TSH
                  WebExtensionsOn := (lRes = 1) or (lRes = 2);
                  lRes := oMCMSecurity.CheckPlugInLicence('EXCHQRLIVE999002');
                  WebExtEProcurementOn := (lRes = 1) or (lRes = 2);

                  {GS 30/03/2012 silently modify the 'Use Override Locations' flag:
                   if it is set to false, and the user has the EProcurement plugin enabled }
                  if (WebExtEProcurementOn = True) and (syss.EnableOverrideLocations = False) then
                    syss.EnableOverrideLocations := True;
                end; {if SQLUtils.UsingSQL then}
              {$ENDIF}

              {$IFDEF SOP}
                {MH 22/07/2014 v7.X Order Payments: Check for presence of Credit Card Payment Gateway Plug-In}
                lRes := oMCMSecurity.CheckPlugInLicence (CreditCardGatewayPlugInCode);
                CreditCardPaymentGateway.ccpgLicenced := ((lRes = 1) or (lRes = 2));

                if CreditCardPaymentGateway.ccpgInstalled and CreditCardPaymentGateway.ccpgLicenced then
                  CreditCardPaymentGateway.ccpgCompanyCode := oMCMSecurity.msCompanyCode;
              {$ENDIF}
            end; {if Res = 0 then}
            PutMultiSys(SysR, BOn); // Always do update - as need to unlock record
          end { if GetMultiSys(BOn, lLocked, SysR) and lLocked then }
          else
            Res := 32767;

          if Res <> 0 then
          begin
            if Res = 1002 then // User Count Exceeded
              MessageDlg ('The licenced User Count has already been fully used by other users, you cannot ' +
                          'log in until someone else has logged out of the Accounts system.', mtInformation, [mbOk, mbHelp], 0)
            else
            begin // Error - Write a log and inform the user
              AddErrorLog('Error Updating User Count',
                          'An error ' + IntToStr(Res) + ' occurred incrementing the Logged-In User Count', 0);         // System generated error
              MessageDlg ('The following error occurred incrementing the Logged-In User Count:- ' + #13#13 +
                           QuotedStr(oMCMSecurity.AddLoginRefErr(Res)) + #13#13 +
                          'Please contact your Technical Support', mtError, [mbOk], 0);
            end; { Else }
            // Close Enterprise
            GotPassword := False;
          end { if Res <> 0 then }
        end; { If GotPassword }
      {$ENDIF}
    end; {with lLoginDialog do}
  finally
    {$IFDEF SEC500}
    if Assigned(oMCMSecurity) then     // Destroy MCM Security Object
      FreeAndNIL(oMCMSecurity);
    {$ENDIF}
    FreeAndNil(lLoginDialog);
  end;

  if not GotPassword then {* Force abort..}
    Halt;
end;


procedure StartLogIn;
{$IFDEF SY}
  Var
    PrevHState:  Boolean;
    LNull,
    CDir,
    Cmd,
    ClassNme,
    EXEName  :  PChar;
    n,
    DRes     :  Integer;
    FDHWND   :  HWnd;
    Message  :  TMessage;
 begin                   
    LNull:='';
    ClassNme:='TEnterSplash'+#0;
    EXEName:='Enterprise Splash'+#0;


    FDHWnd:=FindWindow(ClassNme,EXEName);

    If (FDHWND<>0) then
    Begin
      Windows.SetFocus(FDHWND);
      ShowWindow(FDHWnd,SW_Show);
      SendMessage(FDHWnd,WM_SBSFDMsg,0,0);
    end;

    SetAllowHotKey(BOff,PrevHState);

    {$IFNDEF BCS}
      { DEFINE IAODC}

      // MH 10/05/07: Skip check for IAO Datacentre compilations
      {$IFNDEF IAODC}
      CheckClientServer;
      {$ENDIF}
    {$ENDIF}

    {$IFDEF S2}
      If Not CompareVSecure(BOn,BOn) then
         Beep;
      GotSecurity:=Get_Security;
    {$ELSE}
      GotSecurity:=BOn;
      GotUserLic:=BOn;          
    {$ENDIF}


    {$IFDEF SY}
      if (Not GotPassword) and (GotSecurity)  then
        DisplayLoginDialog;

      {* Register login *}
      UserLogFN:=GetTempLogFName(LogDirN+'E');
      AddLog('','',ExtractFileName(UserLogFN),1);

      {$IFDEF MEMMAP}
        If Assigned(GlobalEntMap) Then GlobalEntMap.UserName := EntryRec^.Login;
      {$ENDIF}
    {$ENDIF}

    {$IFDEF S2}
      If ((GotPassWord) and (GotSecurity))  then
      Begin
       {$IFNDEF SEC500}
          // pre-v5.00 Security - Update user counts
          If (Not SBSIn) then
          Begin
            If (ULFirstIn) and (Syss.EntULogCount<>0) then {* Only one in, reset user count *}
              GotUserLic:=Update_Users(0,BOff);

            GotUserLic:=Update_Users(1,BOn);
          end
          else
            GotUserLic:=Update_Users(99,BOff);
        {$ELSE}
          // v5.00 Security - If user daily password then update DP Tracking
          If SBSIn then
            GotUserLic:=Update_Users(99,BOff)
          Else
            // need this or the following check fails and Enterprise don't run!
            GotUserLic:=True;
        {$ENDIF}
      end;
    {$ENDIF}

    If (Not GotPassWord) or (Not GotSecurity) or ((Not GotUserLic) and (Not SBSIn)) then
      Halt;

    // MH 17/10/2014 ABSEXCH-13403: Force the Settings.Dat subsystem to look in the correct directory
    uSettings.sMiscDirLocation := SetDrive;

    SetAllowHotKey(BOn,PrevHState);

    // MH 01/03/2011 v6.7 ABSEXCH-10687: Added Trader Audit Trail
    With AuditSystemInformation Do
    Begin
      asApplicationDescription := 'Exchequer';
      asApplicationVersion := CurrVersion;
      {RB 30/11/2017 2018-R1 ABSEXCH-19522: GDPR (POST 19352) - Windows Auth Company > Auditing GDPR configuration
        > Windows user ID is not populating in "Exchequer User" field.}
      //setting username to 'asExchequerUser' was overriding the original value set from Login dialog box. Hence, removed.
      asCompanyDirectory := SetDrive;
      asCompanyName := Syss.UserName;
    End; // With AuditSystemInformation
    NewAuditInterface(atMissingLog).WriteAuditEntry;
  {$ELSE}

  Begin

    GotPassWord:=BOn;

    {SBSIn:=On;}

  {$ENDIF}


end;



procedure TMainForm.About1Click(Sender: TObject);

{$IFDEF SY}
  Var
    AboutFrm   :  TAboutFrm;
    PrevHState :  Boolean;

  begin


    ABMode:=TMenuItem(Sender).Tag;

    AboutFrm:=TAboutFrm.Create(Self);

    try
      SetAllowHotKey(BOff,PrevHState);

      AboutFrm.ShowModal;

      SetAllowHotKey(BOn,PrevHState);

    finally

      AboutFrm.Free;

      MDI_ForceParentBKGnd(BOn);

    end;
  end;

{$ELSE}

  Begin
    MessageBeep(0);
  end;

{$ENDIF}



{ ========= Generic procedure to close down all files ========= }

Procedure Ex_Abort;  far;

Begin
  

  ExitProc:=ExitSave;

  Close_Files(BOn);

  Destroy_ThreadFiles;

end;



{$IFDEF XEX32}
{ Callback function to identify the Print preview window }
function EnumWndProcPP (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
var
  ClassName : string;
  Tag       : THandle;
begin
  Result := True;
  SetLength (ClassName, 100);
  GetClassName (Hwnd, PChar (ClassName), Length (ClassName));
  ClassName := PChar (Trim(ClassName));

  If (AnsiCompareText (ClassName, 'TForm_PrintPreview') = 0) then begin
    Tag := GetWindowLong (Hwnd, GWL_USERDATA);
    If (Tag = 1010) Then Begin
      FoundWnd^ := Hwnd;
      Result := False;
    End; { If }
  End; { If }
end;


Function TMainForm.HasPrintPreview  :  Boolean;
Var
  OldHWnd : HWnd;
begin
  OldHwnd := 0;
  EnumWindows (@EnumWndProcPP, Longint(@OldHwnd));

  Result:=(OldHwnd<>0)
end;

{$ENDIF}

procedure TMainForm.PrintBtnClick(Sender: TObject);
{$IFDEF MH}
Var
  FName, KeyStr : Str255;

{$ENDIF}
begin
{$IFDEF MH}
  {$IFDEF Frm}
      {FName := PrintCustSuppRep (1);
      If (Trim(FName) <> '') Then
        PreviewPrintFile (FName, '');}

      (*
      If pfInitNewBatch (pfProcessErr) Then Begin
        {KeyStr := FullNomKey(279);
        pfAddBatchForm (0, True, fmAllDocs, 'SIN',
                        InvF, InvOurRefK, FullOurRefKey('SIN000053'),
                        IDetailF, IdFolioK, KeyStr,
                        'Sales Invoice',
                        pfProcessErr);}
        {pfAddBatchForm (0, True, fmRemitAdv, 'REMIT',
                        InvF,  InvOurRefK, FullOurRefKey('PPY000033'),
                        PwrdF, HelpNdxK,   FullOurRefKey('PPY000033'),
                        'Remittance Test',
                        pfProcessErr);}
        {pfAddBatchForm (0, True, fmStatemLay, 'STATE',
                        CustF, CustCodeK, FullCustCode('ACCO01'),
                        InvF,  InvCDueK,  FullCustType('ACCO01','C'),
                        'Statement Layout',
                        pfProcessErr);}
        {pfAddBatchForm (0, True, fmDebtChaseL, 'DEBT',
                        CustF, CustCodeK, FullCustCode('ACCO01'),
                        InvF,  InvCDueK,  FullCustType('ACCO01','C'),
                        'Debt Chase',
                        pfProcessErr);}
        {pfAddBatchForm (0, True, fmTradeHist, 'TRADHIST',
                        CustF, CustCodeK, FullCustCode('ACCO01'),
                        InvF,  InvCDueK,  FullCustType('ACCO01','C'),
                        'Trading History',
                        pfProcessErr);}
        {pfAddBatchForm (0, True, fmBatchDoc, 'BATCH',
                        InvF, InvOurRefK, FullOurRefKey('SBT000001'),
                        InvF, InvBatchK, FullOurRefKey('SBT000001'),
                        'Batch Entry',
                        pfProcessErr);}
        {KeyStr := FullNomKey(278);
        pfAddBatchForm (0, True, fmNomTxfr, 'NOMTXFR',
                        InvF, InvOurRefK, FullOurRefKey('NOM000028'),
                        IDetailF, IdFolioK, KeyStr,
                        'Nominal Transfer',
                        pfProcessErr);}
        {pfAddBatchForm (0, True, fmAccDets, 'ACCDETS',
                        CustF, CustCodeK, FullCustCode('ACCO01'),
                        PwrdF, PWK, NoteTCode+NoteCCode+FullCustCode('ACCO01'),
                        'Account Details',
                        pfProcessErr);}
        {pfAddBatchForm (0, True, fmStockRec, 'STOCKREC',
                        StockF, StkCodeK, FullStockCode('PC/486D/500'),
                        PwrdF, PWK, Strip ('R', [#32], FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(72))),
                        'Stock Record',
                        pfProcessErr);}
        {KeyStr := FullNomKey(-2147482919);
        pfAddBatchForm (0, True, fmStockAdj, 'STOCKADJ',
                        InvF, InvOurRefK, FullOurRefKey('ADJ000016'),
                        IDetailF, IdFolioK, KeyStr,
                        'Stock Adjustment',
                        pfProcessErr);}
        {pfAddBatchForm (0, True, fmStockNote, 'STOCKNOT',
                        StockF, StkCodeK, FullStockCode('PC/486D/500'),
                        PwrdF, PWK, FullQDKey(NoteTCode,NoteSCode,FullNCode(FullNomKey(72))),
                        'Stock Notes',
                        pfProcessErr);}
        {KeyStr := FullNomKey(-2147482918);
        pfAddBatchForm (0, True, fmTimeSheet, 'TIMESHT',
                        InvF, InvOurRefK, FullOurRefKey('TSH000001'),
                        IDetailF, IdFolioK, KeyStr,
                        'Timesheet',
                        pfProcessErr);}
        KeyStr := FullNomKey(279);
        pfAddBatchForm (0, True, fmAllDocs, 'DOCSERNO',
                        InvF, InvOurRefK, FullOurRefKey('SIN000053'),
                        IDetailF, IdFolioK, KeyStr,
                        'Document with Serial Numbers',
                        pfProcessErr);

        pfPrintBatch ('Test Batch', pfProcessErr);
      End; { If }
      *)
  {$ENDIF}

{$ELSE}
  {$IFDEF FRM}
    Send_UpdateList(WM_CustGetRec,170);
  {$ENDIF}
{$ENDIF}

end;

procedure TMainForm.Label_PrntProgDblClick(Sender: TObject);
begin
  {$IFDEF Frm}
    If (Gauge3.Visible) and (Gauge2.Visible) then
    Begin
      If (PrintHwnd <> 0) Then
        PostMessage (PrintHwnd, WM_PrintAbort, 0, 0);
    end
    else
      Change_Period;
  {$ENDIF}
end;


procedure TMainForm.PrintSetup1Click(Sender: TObject);
begin
  {$IFDEF Frm}
  
    {$OPTIMIZATION OFF}
      RPDev.DeviceIndex := RPDev.DeviceIndex;
    {$OPTIMIZATION ON}


    If (RpDev.Printers.Count > 0) Then
      RPDev.PrinterSetUpDialog
    else
    Begin
      Set_BackThreadMVisible(BOn);
      MessageDlg ('A printer must be defined before anything can be printed!', mtWarning, [mbOk], 0);
      Set_BackThreadMVisible(BOff);
    end;
  {$ENDIF}
end;

procedure TMainForm.ChangePr1Click(Sender: TObject);
begin
  Change_Period;
end;


procedure TMainForm.SpeedButton5Click(Sender: TObject);
begin
  Create_BackThread;
end;

procedure TMainForm.XXXCAcc1Click(Sender: TObject);
var
  Confirm: Boolean;
begin
  {$IFDEF POST}
    // CJS 2012-03-19 - ABSEXCH-12203 - Check All Accounts, SQL improvements
    // CJS 2015-03-31 - ABSEXCH-16163 - Check All Accounts, SQL improvements
    Confirm := ConfirmCheckAccount;
    if Confirm then
    begin
      //PR: 18/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
      if not GetProcessLock(plCheckAccounts) then
       EXIT;

      if SQLUtils.UsingSQLAlternateFuncs and SQLReportsConfiguration.UseSQLCheckAllAccounts then
        CheckAllAccounts(self, False)
      else
        AddCheckCust2Thread(Self,'',BOn,BOn,BOff);
    end;
  {$ENDIF}
end;

procedure TMainForm.RGL1Click(Sender: TObject);
begin
  {$IFDEF POST}
    {$IFDEF MC_On}
    //PR: 24/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
    if not GetProcessLock(plRevaluation) then
      EXIT;
    Revalue_Currency;
    {$ENDIF}
  {$ENDIF}
end;

procedure TMainForm.CS1Click(Sender: TObject);

begin
  {$IFDEF MC_On}
    //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
    if not GetProcessLock(plCurrency) then
      EXIT;
    Change_Currency;
  {$ENDIF}

end;

procedure TMainForm.XXXLicMod1Click(Sender: TObject);
begin
  {$IFDEF S2}
    Change_Modules;
  {$ENDIF}
end;


procedure TMainForm.XXXSysLic1Click(Sender: TObject);
begin
  {$IFDEF S2}
    Get_Release;
  {$ENDIF}
end;


procedure TMainForm.Help1Click(Sender: TObject);
begin
  HBG1.Checked:=HideBkGnd;
end;

procedure TMainForm.HBG1Click(Sender: TObject);
begin
  HideBkGnd:=Not HideBkGnd;

  InvalidateRect(0, nil, True);
end;


procedure TMainForm.XXXDisHKey1Click(Sender: TObject);
begin
  If (Debug) then
    Ignore_HT:=Not Ignore_HT;
end;

procedure TMainForm.XXXCASL1Click(Sender: TObject);
begin
  {$IFDEF POST}
    {$IFDEF STK}
      Check_StockLevels(BOn,Self,0,0);
    {$ENDIF}
  {$ENDIF}

end;

procedure TMainForm.XXXCGBOM1Click(Sender: TObject); {* EL BoM Check implementation from DOS code *}
begin
  {$IFDEF PF_On}
    {$IFDEF POST}
      {$IFDEF STK}
        AddBOMUpdate2Thread(Self,1);
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

end;


procedure TMainForm.XXXCACCDL1Click(Sender: TObject);
begin
  {$IFDEF POST}
    AddCheckCCDep2Thread(Self);
  {$ENDIF}

end;

procedure TMainForm.XXXCAJT1Click(Sender: TObject);
begin
  {$IFDEF POST}
    {$IFDEF JC}
       If (JBCostOn) then
         // CJS 2015-02-23 - ABSEXCH-16133 - SQL version of Check All Job Totals
         If SQLUtils.UsingSQLAlternateFuncs And SQLReportsConfiguration.UseSQLCheckAllJobs Then
           SQLCheckAllJobs(self)
         else
           AddJobPost2Thread(Self,40,'',Nil,Self.Handle);
    {$ENDIF}
  {$ENDIF}
end;


procedure TMainForm.XXXRestJA1Click(Sender: TObject);
begin
  {$IFDEF POST}
    {$IFDEF JC}
      If (JBCostOn) then
       AddJobPost2Thread(Self,TMenuItem(Sender).Tag,'',Nil,Self.Handle);

    {$ENDIF}
  {$ENDIF}
end;


procedure TMainForm.SV1Click(Sender: TObject);
begin
  {$IFDEF POST}
    {$IFDEF STK}
         {$IFDEF Rp}
           If (Syss.UseMLoc) then
             SList_Report(10,Self)
           else
         {$ENDIF}
           AddStkValue2Thread(Self,'');
    {$ENDIF}
  {$ENDIF}
end;

procedure TMainForm.VS1Click(Sender: TObject);
begin
  If Allowed_In((AllowHotKey) and (Not Ignore_HT),50) then
  {$IFDEF VAT}
  begin
    //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
    if not GetProcessLock(plVATSetup) then
      EXIT;

      Change_VAT;
  end;
  {$ENDIF}
end;

procedure TMainForm.CIS1Click(Sender: TObject);
begin
  {$IFDEF JC}
    //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
    if not GetProcessLock(plCISSetup) then
      EXIT;
    Change_CIS;
  {$ENDIF}
end;


Procedure TMainForm.Out_Period;


Begin
  With Label_PrntProg do
  Begin
    If (Gauge3.Visible) and (Gauge2.Visible) then
    Begin
      {ShowHint:=BOn;}
      Caption:='';
      Gauge3.Hint:='|Shows the progress of the ObjectThread Controller. Double click on the bar graph to abort.';
    end
    else
    Begin
      Hint:='|Shows the current financial period '+OrigCaption+' is set to. Double click here, or use F6 to change.';

      {ShowHint:=BOn;}

      Caption:=PPR_OutPr(GetLocalPr(0).CPr,GetLocalPr(0).CYr);
    end;
  end;
end;

//HV 21/03/2017 2017-R1 ABSEXCH-18434: New Standard Report - Customer Transactions on Hold
procedure TMainForm.mnuTransactionsOnHoldRepClick(Sender: TObject);
begin
  {$IFDEF Rp}
    if Assigned(Sender) and (Sender is TMenuItem) then
    begin
      case TMenuItem(Sender).Tag of
        1:  TraderTransactionOnHold_Report(Self, thrCustomer, nil);
        2:  TraderTransactionOnHold_Report(Self, thrSupplier, nil);
      end; {Case..}
    end;
  {$ENDIF}
end;

procedure TMainForm.AgedDebtors1Click(Sender: TObject);
begin
  With TMenuItem(Sender) do
  Begin
  {$IFDEF Rp}

    Case Tag of
      1,2  :  Payment_Report((Tag=2),Self);
      3,4,
      13,14
           :  Aged_Report((Tag In [3,13]),(Tag In [13,14]),Self);

      else    AddADebRep2Thread((0*Ord(Tag In [1,2]))+(1*Ord(Tag In [3,4])),(Tag In [2,3]),nil,Self);
    end; {Case..}
    
  {$ENDIF}
  end;
end;

procedure TMainForm.List1Click(Sender: TObject);

Var
  RepMode  :  Byte;
begin
  RepMode := 0; // Initialised to stop a compiler warning
  If (Sender is TMenuItem) then
    With TMenuItem(Sender) do
      RepMode:=Tag;

  {$IFDEF Rp}
  AddGenRep2Thread(RepMode,Self);
  {$ENDIF}
end;

procedure TMainForm.HelpT1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_Finder,0);
end;

procedure TMainForm.WhatTBtnClick(Sender: TObject);
begin
  PostMessage(Self.Handle,WM_SysCommand,SC_CONTEXTHELP,0);
end;

procedure TMainForm.Statements1Click(Sender: TObject);
begin
  With TMenuItem(Sender) do
  Begin
    {$IFDEF Rp}
      Case Tag of
        // MH 30/10/2013 v7.X MRD1.1: Split Customer List Report out to own dialog for consumer mods
        // MH 14/01/2014 v7.0.8 ABSEXCH-14941: bypass report parameters duialog if Consumers turned off
        0  : If Syss.ssConsumersEnabled Then
               RunAccountReport (Self, artCustomerList)
             Else
               List1Click(Sender);

        2  : Statement_Run(Self);

        3  : Debt_Run(Self,Tag,(Sender=TradLed1) or (Sender=AccDet1) or (Sender=ChaseLetters1) or (Sender=Labels2));

        // MH 29/10/2013 v7.X MRD1.1: Split Customer/Supplier Trading Ledger out to own dialog for consumer mods
        5  : If (Sender = TradLed1) Then
               RunAccountReport (Self, artCustomerTradingLedger)
             Else
               RunAccountReport (Self, artSupplierTradingLedger);

        // MH 29/10/2013 v7.X MRD1.1: Split Customer/Supplier Account Details out to own dialog for consumer mods
        8  : If (Sender = AccDet1) Then
               RunAccountReport (Self, artCustomerAccountDetails)
             Else
               RunAccountReport (Self, artSupplierAccountDetails);

        // MH 29/10/2013 v7.X MRD1.1: Split Customer/Supplier Account Details out to own dialog for consumer mods
        10 : If (Sender = Labels2) Then
               RunAccountReport (Self, artCustomerLabels)
             Else
               RunAccountReport (Self, artSupplierLabels);

        {$IFDEF STK}
        11 : StkLab_Report(Self);
        {$ENDIF}

        88 : PrintRangeDocs(Self);
      end; {Case..}
    {$ENDIF}
  end;

end;

procedure TMainForm.PostingReport1Click(Sender: TObject);
begin
  {$IFDEF Rp}

    Posting_Report(Self,(Sender=DocBased1) or (Sender=DocBased2));

  {$ENDIF}
end;

procedure TMainForm.JCRBS1Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF JC}

      RePrint_Backing(Self);

    {$ENDIF}
  {$ENDIF}

end;


procedure TMainForm.JCEL2Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF JC}

      EmplList_Report(TMenuItem(Sender).Tag,Self);

    {$ENDIF}
  {$ENDIF}

end;


procedure TMainForm.JCJH1Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF JC}
      JobHist_Report(2,Self);
    {$ENDIF}
  {$ENDIF}
end;

procedure TMainForm.JCCE1Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF JC}
      JobCustXPose_Report(4,Self);
    {$ENDIF}
  {$ENDIF}

end;


procedure TMainForm.JCBA1Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF JC}
      JobBudg_Report(1,Self);
    {$ENDIF}
  {$ENDIF}

end;

procedure TMainForm.JCAA1Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF JC}
      JobAnal_Report(2,Self);
    {$ENDIF}
  {$ENDIF}

end;


procedure TMainForm.JCWIP1Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF JC}
      JobWIP_Report(2,Self);
    {$ENDIF}
  {$ENDIF}

end;

procedure TMainForm.JCBR1Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF JC}
      JobBill_Report(1,Self);
    {$ENDIF}
  {$ENDIF}

end;

procedure TMainForm.Suby2Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF JC}
      SubCEmplList_Report(TMenuItem(Sender).Tag,Self);
    {$ENDIF}
  {$ENDIF}

end;

//PL 18/04/2017 2017-R1 ABSEXCH-18497 Std. Report: Removed the menu item "Report" and the sub option return
procedure TMainForm.CISRet1Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF JC}
      SubCEOYList_Report(TMenuItem(Sender).Tag,Self);
    {$ENDIF}
  {$ENDIF}

end;

procedure TMainForm.AppsRep2Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF JAP}
      JAApps1_Report(TMenuItem(Sender).Tag,Self);
    {$ENDIF}
  {$ENDIF}

end;


procedure TMainForm.PADBk1Click(Sender: TObject);
begin
  {$IFDEF POST}
    PrePostInput(Self,TMenuItem(Sender).Tag,BOn,nil);
      {AddPost2Thread(TMenuItem(Sender).Tag,Self,BOn,nil,nil);}
  {$ENDIF}
end;

procedure TMainForm.XXXTotalUnpost1Click(Sender: TObject);
begin
  {$IFDEF POST}
    //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
    if not GetProcessLock(plUnpost) then
      EXIT;
    AddTUnpost2Thread(Self);
  {$ENDIF}
end;

procedure TMainForm.PartialUnpost1Click(Sender: TObject);
begin
  {$IFDEF POST}
    //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
    if not GetProcessLock(plUnpost) then
      EXIT;
    Case TMenuItem(Sender).Tag of
      1  :  UnPostxRunNo(Self);
      else  UnPostIt(Self);
    end; {Case..}
  {$ENDIF}

end;

procedure TMainForm.DocAnal1Click(Sender: TObject);

Var
  MenItem  :  Integer;

begin
  {$IFDEF Rp}

    MenItem:=TMenuItem(Sender).Tag;

    Case MenItem of
      2,3,
      7..9
           :  ANH_Report(MenItem,Self);

      else    Doc_Report(MenItem,Self);
    end; {Case..}

  {$ENDIF}
end;

procedure TMainForm.BankRec1Click(Sender: TObject);
begin
  {$IFDEF Rp}

    Recon_Report(0,Self);

  {$ENDIF}
end;

procedure TMainForm.Fulltb1Click(Sender: TObject);
begin
  {$IFDEF Rp}

    With TMenuItem(Sender) do
      Nom_Report(Tag,Self);

  {$ENDIF}
end;

procedure TMainForm.CCDepRep1Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF Pf_On}

      CCDep_Report(Self);

    {$ENDIF}
  {$ENDIF}
end;

procedure TMainForm.PrAnal1Click(Sender: TObject);

Var
  RT  :  Word;

begin
  {$IFDEF Rp}
    {$IFDEF STK}
      RT:=TMenuItem(Sender).Tag;

      Case RT of
        1,2
           :  Stk_Report(RT,Self);
        8  :  PriceL_Report(Self);
      end; {Case..}

    {$ENDIF}
  {$ENDIF}

end;


procedure TMainForm.StkPRep1Click(Sender: TObject);
Var
  RT  :  Word;

begin
  {$IFDEF Rp}
    {$IFDEF Stk}

      RT:=TMenuItem(Sender).Tag;

      PBreak_Report(RT,Self);
    {$ENDIF}

  {$ENDIF}

end;


procedure TMainForm.ValRep2Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF Stk}
      SRecon_Report(15+TMenuItem(Sender).Tag,Self);
    {$ENDIF}

  {$ENDIF}

end;

procedure TMainForm.SList2Click(Sender: TObject);
Var
  RT  :  Word;

begin
  {$IFDEF Rp}
    {$IFDEF Stk}

      RT:=TMenuItem(Sender).Tag;

      Case RT of
        {$IFNDEF SOP}
          1  :  AddSListRep2Thread(1,nil,Self);
        {$ELSE}
          1,
        {$ENDIF}
        2,3
           :  SList_Report(RT,Self);
        { PL 13/04/2017 2017-R1 ABSEXCH-18497 : added Case-5 to execute valuation
        report as Posted and existing case-4 is used for Valuation Live report
        since the requirement is to split existing report in two }
        4,5,44
           :  SVal_Report(Rt,Self);

      end;{Case..}

    {$ENDIF}

  {$ENDIF}

end;


procedure TMainForm.KitBKRep1Click(Sender: TObject);
Var
  RT  :  Word;

begin
  {$IFDEF Rp}
    {$IFDEF Stk}

      RT:=TMenuItem(Sender).Tag;



      Case RT of
        1..4  : SKit_Report(RT,Self);
        5     : SBOrd_Report(RT,Self);

        11,12
              : SShort_Report(RT-10,Self);

      end;{Case..}

    {$ENDIF}

  {$ENDIF}

end;


procedure TMainForm.StkHist1Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF Stk}

        SHist_Report(2,Self);

    {$ENDIF}
  {$ENDIF}

end;

procedure TMainForm.StockbyBin1Click(Sender: TObject);
begin
  {$IFDEF STK}
    Bin_Report(TMenuItem(Sender).Tag,'',Self);
  {$ENDIF}
end;

//-------------------------------------------------------------------------

// Old UK EC Sales List Report / report for non-UK
procedure TMainForm.VRet1Click(Sender: TObject);
Var
  RT  :  Word;
begin
  {$IFDEF Rp}

    RT:=TMenuItem(Sender).Tag;
    
    Case RT of

      0     :  If (CurrentCountry=IECCode) then
                 VAT_ReportIE(RT,Self)
               else
                 If (CurrentCountry=NZCCode) then
                   VAT_ReportNZ(RT,Self)
                 else
                   // CJS 2014-11: Order Payments - Phase 5 - VAT Return
                   // For non-cash-accounting systems run the new VAT Returns
                   // Wizard, otherwise run the original VAT Return report
                   {$IFDEF SOP}
                   // CJS 2015-09-29 - ABSEXCH-16930 - VAT Wizard enabled for non UK licenced countries
                   if (CurrentCountry = UKCCode) and not (VAT_CashAcc(SyssVat.VATRates.VATScheme)) then
                     VATReturn(self)
                   else
                   {$ENDIF}
                   VAT_Report(RT,self);

      1..2  :  VAT_Report(RT,Self);

      {$IFDEF PF_On}

        4  :  ECVAT_Report(Self);

      {$ENDIF}

    end;

  {$ENDIF}
end;

//------------------------------

// New v6.2 UK EC Sales List Report
procedure TMainForm.NewECSalesListRepJan10OnwardsClick(Sender: TObject);
begin
{$IFDEF Rp}
  //AP:20/07/2017-ABSEXCH-15994:EC Sales List Summary - No standard report showing what makes these figures up
  ECSalesReport(TMenuItem(Sender));
//  ShowMessage ('EParentU.NewECSalesListRepJan10OnwardsClick Not Coded - Have a Nice Day!');
{$ENDIF}
end;

//-------------------------------------------------------------------------

procedure TMainForm.WOPF1Click(Sender: TObject);
Begin
  {$IFDEF Rp}
    {$IFDEF WOP}
      WOP_Report(TMenuItem(Sender).Tag,Self);
    {$ENDIF}
  {$ENDIF}
end;
procedure TMainForm.WOPWIP1Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF WOP}
      WOPWIP_Report(3,Self);
    {$ENDIF}
  {$ENDIF}

end;

procedure TMainForm.SalesRetAnal1Click(Sender: TObject);
begin
  {$IFDEF Rp}
    {$IFDEF RET}
      RET_Report(1,(TMenuItem(Sender).Tag=1),Self);

    {$ENDIF}
  {$ENDIF}
end;


procedure TMainForm.mniUserManagementClick(Sender: TObject);
var
  lCreateNew: Boolean;
  i: Integer;
begin
  {$IFDEF S2}
    lCreateNew := True;
    for I := 0 to (Application.MainForm.MDIChildCount - 1) do
    begin
      if (Application.MainForm.MDIChildren[I] is TfrmUserManagement) then
      begin
        Application.MainForm.MDIChildren[I].Show;
        lCreateNew := False;
        Break;
      end;
    end;
    if lCreateNew then
      TfrmUserManagement.Create(Self).Show;
  {$ENDIF}
end;

procedure TMainForm.mniChangeMyPasswordClick(Sender: TObject);
var
  lUserDetailObj: TUserDetail;
  lUserPassDetailRec: tPassDefType;
  lIUserDetails: IUserDetails;
begin
  FillChar(lUserPassDetailRec, SizeOf(lUserPassDetailRec), #0);
  lUserPassDetailRec.Login := EntryRec^.Login;
  lUserDetailObj := CreateUser(0, umUpdate, lUserPassDetailRec);
  lIUserDetails := lUserDetailObj;
  if Assigned(lIUserDetails) then
    DisplayChangePasswordDlg(Self, lIUserDetails);
end;

procedure TMainForm.LockScreen1Click(Sender: TObject);
Var
  Done  :  Boolean;

begin
  Done:=BOff; {Force a relogin}

  If (Not ThreadIsBusy) and (not InSysSS) then
    CheckEntIdle(Sender,Done)
  else
  Begin
    Set_BackThreadMVisible(BOn);

    ShowMessage('It is not possible to lock '+OrigCaption+' whilst a background thread is running, or System Setup is open'+#13+
                'Please try again once the thread has finished or System Setup has been closed.');

    Set_BackThreadMVisible(BOff);


  end;
end;


procedure TMainForm.BPPY1Click(Sender: TObject);
Var
  SPMode  :  Boolean;
begin
  {$IFDEF POST}

    SPMode:=(Sender=BSRC1) or (Sender=BPRun2);

    If (Not InBatchPay[SPMode]) then
    Begin
      InBatchPay[SPMode]:=BOn;
      BACS_CtrlRun(SPMode,((Sender=BPRun1) or (Sender=BPRun2)),Self);
    end
    else
    Begin
      Set_BackThreadMVisible(BOn);
      ShowMessage('The '+BatchPTit(SPMode)+' List is currently in use.');
      Set_BackThreadMVisible(BOff);
    end;
  {$ENDIF}
end;

procedure TMainForm.BPRep1Click(Sender: TObject);
begin
  {$IFDEF Rp}
    Batch_Report(Sender=BPRep2,Self);
  {$ENDIF}
end;


procedure TMainForm.GS1Click(Sender: TObject);
Var
  WasNew  :  Boolean;

begin
  {$IFDEF SY}
    If Allowed_In((AllowHotKey) and (Not Ignore_HT),89) then
    Begin
      WasNew:=BOff;

      If (Not InMainThread) then
      Begin
        //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
        if not GetProcessLock(plSystemSetup) then
          EXIT;

        If (Not Assigned(SysGenSet)) then
        Begin
          SysGenSet:=TSysSet.Create(Self);
          WasNew:=BOn;
        end;

        try
          With SysGenSet do
          Begin


            If (WindowState=wsMinimized) then
              WindowState:=wsNormal;

            If (WasNew) then
              ProcessSyss
            else
              Show;
          end; {With..}

        except
          SysGenSet.Free;
          SysGenSet:=nil;
        end; {try..}
      end
      else
      Begin
        Set_BackThreadMVisible(BOn);
        ShowMessage('System Setup is unavailable whilst a background thread is running.');

        Set_BackThreadMVisible(BOff);
      end;

    end;

  {$ENDIF}
end;


procedure TMainForm.XXXMULic1Click(Sender: TObject);
Var
  RT  :  Word;


begin
  RT:=TMenuItem(Sender).Tag;

  {$IFDEF S2}

     Case RT of
       1  :  Control_USRLine;
       2  :  If (Update_Users(0,BOff)) then
             Begin
               Set_BackThreadMVisible(BOn);
               ShowMessage('The User Count has been reset.'+#13+#13+'Please exit and login normally.');
               Set_BackThreadMVisible(BOff);
             end;
     end; {Case..}

  {$ENDIF}
end;

procedure TMainForm.GLRecon1Click(Sender: TObject);
begin
  {$IFDEF Nom}
    Recon_BankGL(Self,(Sender=GLRec2));
  {$ENDIF}
end;

procedure TMainForm.DocNum1Click(Sender: TObject);
begin
  {$IFDEF SY}
    If (Not Assigned(DNCtrl)) then
    Begin
      DNCtrl:=TDocNoList.Create(Self)
    end
    else
      With DNCtrl do
      Begin
        try
          If (WindowState=wsMinimized) then
            WindowState:=wsNormal;

          Show;

        except
          DNCtrl:=nil;
          DNCtrl.Free;
        end;
      end;
  {$ENDIF}

end;

procedure TMainForm.CCodes1Click(Sender: TObject);
begin

  {$IFDEF SY}
    //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
    if not GetProcessLock(plControlCodes) then
      EXIT;

    If (Not Assigned(GLCCCtrl)) then
    Begin
      GLCCCtrl:=TSetGLCC.Create(Self);

      try
        GLCCCtrl.ProcessSyss;
      except
        GLCCCtrl:=nil;
        GLCCCtrl.Free;
      end; {try..}
    end
    else
      With GLCCCtrl do
      Begin
        try
          If (WindowState=wsMinimized) then
            WindowState:=wsNormal;

          Show;

        except
          GLCCCtrl:=nil;
          GLCCCtrl.Free;
        end;
      end;
  {$ENDIF}

end;

procedure TMainForm.PQBtn1Click(Sender: TObject);
begin
  {If (Debug) then
  Begin
    DebugForm.Add('Width'+inttoStr(ClientWidth));
    DebugForm.Add('Height'+inttoStr(ClientHeight));
  end;}
end;

procedure TMainForm.XXXdbClear1Click(Sender: TObject);

Var
  n  :  Integer;

begin


  {$IFDEF DBD}
     DebugForm.Clear('');

     DebugForm.Add('MDI Children '+SetN(MDIChildCount-1));

     For n:=0 to Pred(MDIChildCount) do
        DebugForm.Add(SetN(n)+' '+MDIChildren[n].Name+', '+MDIChildren[n].Caption);

     DebugForm.Add('Forms '+SetN(Screen.FormCount-1));

     For n:=0 to Pred(Screen.FormCount) do
     With Screen do
        DebugForm.Add(SetN(n)+' '+Forms[n].Name+', '+Forms[n].Caption);


  {$ENDIF}
end;


procedure TMainForm.RWriterClick(Sender: TObject);
Var
  OldHWnd : HWnd;
  LNull   : Array [0..255] Of Char;
  LStr    : Str255;
begin
  OldHwnd := 0;
  EnumWindows (@EnumWndProcRW, Longint(@OldHwnd));
  If (OldHwnd <> 0) Then Begin
    If (Not IsWindowVisible (OldHWnd)) Then
      PostMessage (OldHwnd, WM_SBSFDMsg, 0, 0);
    SetForeGroundWindow (OldHwnd);
    (*
    Windows.SetFocus(OldHwnd);
    ShowWindow  (OldHwnd, SW_Show);
    SendMessage (OldHwnd, WM_SBSFDMsg, 0, 0);
    *)
  End { If }
  Else Begin
    { Not already running - run a new copy }
    Blank (LNull, SizeOf (LNull));
    LStr:=ExtractFilePath(Application.EXEName) + RepWrtExe + ' ';
    If (RemDirOn) then
      LStr:=LStr+RemDirSwitch+' '+SetDrive;
    LStr:=LStr+SBSParam+LoginParam+' '+ExVersParam^ + ' ' + RWStartCode;
    StrPCopy(LNull,LStr);

    WinExec(LNull, SW_SHOW);
  End; { Else }
end;


{$IFDEF C_On}

  procedure TMainForm.HotLinkCust(CCode  :  Str20);
                                                                                      
  Var
    FoundOk   :  Boolean;
    FoundCode :  Str20;

  begin
    FoundOk:=(Not EmptyKey(CCode,CustKeyLen));

    If (CCode<>Cust.CustCode) then
      FoundOk:=Global_GetMainRec(CustF,CCode);

    If (FoundOk) then
    Begin
      If (HotCust=nil) then
        HotCust:=TFCustDisplay.Create(Self);

      try

        With HotCust do
          Display_Account(IsACust(Cust.CustSupp),0,Inv);

        except

          HotCust.Free;
          HotCust:=nil;

      end; {try..}
    end
    else
      MessageBeep(0);
  end; {Proc..}

{$ENDIF}



{$IFDEF STK}

  procedure TMainForm.HotLinkStock(CCode  :  Str20);

  Var
    FoundOk   :  Boolean;
    FoundCode :  Str20;

  begin
    FoundOk:=(Not EmptyKey(CCode,StkKeyLen));

    If (CCode<>Stock.StockCode) then
      FoundOk:=Global_GetMainRec(StockF,CCode);

    If (FoundOk) then
    Begin
      If (HotStock=nil) then
        HotStock:=TFStkDisplay.Create(Self);

      try

        With HotStock do
          Display_Account(0);

        except

          HotStock.Free;
          HotStock:=nil;

      end; {try..}
    end
    else
      MessageBeep(0);
  end; {Proc..}
{$ENDIF}


{$IFDEF JC}

  procedure TMainForm.HotLinkJob(CCode  :  Str20);

  Var
    FoundOk   :  Boolean;
    FoundCode :  Str20;

  begin
    FoundOk:=(Not EmptyKey(CCode,JobKeyLen));

    If (CCode<>JobRec^.JobCode) then
      FoundOk:=Global_GetMainRec(JobF,CCode);

    If (FoundOk) then
    Begin
      If (HotJob=nil) then
        HotJob:=TFJobDisplay.Create(Self);

      try

        With HotJob do
          Display_Account(0,CCode,'',0,0,BOff,nil);

        except

          HotJob.Free;
          HotJob:=nil;

      end; {try..}
    end
    else
      MessageBeep(0);
  end; {Proc..}
{$ENDIF}


{ Display Multi-Company Manager }
procedure TMainForm.FCLClick(Sender: TObject);
begin
  {$IFDEF SY}
    {$IFDEF BUREAU}
      If CompManOn Then
        TfrmCompanyList.Create(Self);
      //local_MDICompMan(Self.Handle);
    {$ENDIF}  
  {$ENDIF}
end;

{ Processes Change Company message sent by Multi-Company Manager }
procedure TMainForm.ChangeCompany(var Message: TMessage);
Begin
  {$IFDEF SY}
     {$IFDEF BUREAU}
       If CompManOn Then
       Begin
         //TW 04/08/2011: Used for saving window size/position if save checked and then
         //               the user switches companies.
         SaveCoordinates;

         // MH 08/01/2018 2017-R1 ABSEXCH-19316: Changed display mechanism for SQL Posting Prompt Dialog
         ShownSQLPostingPrompt := False;

         ChangeCurrCompany(Message);
         Update_DripFeed; //CS:

         //PR: 19/10/2011 v6.9 Clear custom fields object so it can be reloaded for the new company.
         ClearCustomFields;

         {$IFDEF LTE}
           // MH 28/06/06: Added missing update for IAO Read-Only label on change of company
           SetIAOReadOnly; // IAO RO
           Invalidate;  // Force repaint otherwise the background doesn't repaint so you can still see it even though it may not be visible
         {$ENDIF}
       End;
      {$ENDIF}
      {MDI_ForceParentBKGnd(BOn);}
       { If }
  {$ENDIF}

  Inherited;
End;

Procedure TMainForm.SetCaption;

Var
  EuroStr  :  Str10;
Begin
  EuroStr:=' - ';

  {$IFNDEF LTE}
    {$IFDEF MC_On}
      If (EuroVers) then
        EuroStr:=' Euro - '
      else
        EuroStr:=' Global - ';
    {$ENDIF}

    Caption:=OrigCaption+EuroStr+Syss.UserName;
  {$ELSE}
    Caption:=OrigCaption+' '+EnterpriseLicence.elLongVersionDesc+' - '+Syss.UserName;

  {$ENDIF}

  {$IFDEF DBD}

    {$IFNDEF LTE}
      Caption:='v6.00 : '+Caption;
    {$ELSE}
      Caption:='v1.00 : '+Caption;
    {$ENDIF}
  {$ENDIF}
End;

{ Called by customisation dll to create menu options }
Function TMainForm.NewMenuItem (MenCap, MenName : ShortString) : TMenuItem;
Var
  NewMenu : TMenuItem;
Begin
  { Create new menu item }
  NewMenu := TMenuItem.Create(Self);

  { Copy menu into return value }
  Result := NewMenu;

  { Set properties of menu item }
  With Result Do Begin
    Caption := MenCap;
    Name    := MenName;
  End; { With }
End;



{ ================== Enterprise Exception handling routines ================ }


{$IFDEF SY}
  procedure TMainForm.EntException(Sender  :  TObject; E  :  Exception);

  Var
    Msg  :  String;

  Begin
    Try
      {Application.ShowException(E);

      AddErrorLog(E.Message,'',0);}

      Msg := E.Message;   //RTLICreateExceptionMsg(E,ExceptAddr,Ver);    // SSK 02/05/2017 2017-R1 ABSEXCH-18637: RTLICreateExceptionMsg function commented

      MessageBox(0, PChar(Msg), 'Application Error', mb_Ok or mb_IconStop or mb_TaskModal);

      AddErrorLog(Msg,'',0);

    except
      On E: Exception do
        Begin
          Application.ShowException(E);
        end;
    end;
  end; {PRoc..}


  procedure TMainForm.EntDeActivate(Sender  :  TObject);

  Begin
    Application.Title:=Syss.UserName+'.'+Branding.pbProductName
  end;




{$ENDIF}


procedure TMainForm.XXXErrLogs1Click(Sender: TObject);
begin

  {$IFDEF SY}
    If (Not Assigned(ErrLogFrm)) then
    Begin
      ErrLogFrm:=TErrorLogFrm.Create(Self);
    end
    else
      With ErrLogFrm do
      Begin
        try
          If (WindowState=wsMinimized) then
            WindowState:=wsNormal;

          Show;

        except
          ErrLogFrm:=nil;
          ErrLogFrm.Free;
        end;
      end;
  {$ENDIF}

end;


procedure TMainForm.XXXResetbusylock1Click(Sender: TObject);

Var
  n  :  Byte;
  Bo :  Boolean;

begin
  {$IFDEF DBD} {OTC_Hang}
    If (Assigned(BackThread)) then {* Force thread busy flag to be idle *}
    With BackThread do
    Begin
      DebugForm.Add('LockListUpdate : '+YesNoBo(LockListUpdate));

      LockListUpDate:=BOff;

      If (Assigned(ThreadList)) then
        DebugForm.Add('ThreadList.Count: '+Form_Int(ThreadList.Count,0));


      DebugForm.Add('IdleMode: '+YesNoBo(IdleMode));
      DebugForm.Add('FlipFlop: '+YesNoBo(FlipFlop));
      DebugForm.Add('Stayvisible: '+YesNoBo(Stayvisible));
      DebugForm.Add('Modalvisible: '+YesNoBo(Modalvisible));
      DebugForm.Add('StillPreview: '+YesNoBo((NumPrevWins>0)));
      DebugForm.Add('Suspended: '+YesNoBo((BackThread.Suspended)));
      DebugForm.Add('ThreadNowIdle: '+YesNoBo((ThreadNowIdle)));
      DebugForm.Add('ExecuteOff: '+YesNoBo((ExecuteOff)));
      BackThread.Resume;

      Bo:=Not CheckHotKeyStat(Nil);

      DebugForm.Add('Check Hot Key fail: '+YesNoBo(Bo));

      If (Bo) then
      Begin
        If (InCurr) then
          DebugForm.Add('In Curr: '+YesNoBo(InCurr));

        If (InPrint) then
          DebugForm.Add('In Print: '+YesNoBo(InPrint));

        If (InChangePr) then
          DebugForm.Add('In Change Pr: '+YesNoBo(InChangePr));

        If (InVATP) then
          DebugForm.Add('In VAT P: '+YesNoBo(InVATP));

        If (InSyssS) then
          DebugForm.Add('In Syss: '+YesNoBo(InSyssS));

        If (InDocNum) then
          DebugForm.Add('In DocNum: '+YesNoBo(InDocNum));

        If (InGLCC) then
          DebugForm.Add('In GLCC: '+YesNoBo(InGLCC));

      end;

      For n:=Low(MainThreads) to High(MainThreads) do
        If (Assigned(MainThreads[n])) then
          DebugForm.Add('Main Thread '+Form_Int(n,0)+' : '+YesNoBo(Assigned(MainThreads[n])));

      For n:=Low(DebugMarker) to High(DebugMarker) do
        If (DebugMarker[n]) then
          DebugForm.Add('Marker '+Form_Int(n,0)+' : '+YesNoBo(DebugMarker[n]));



    end;
  {$ENDIF}
end;


procedure TMainForm.DiaryBtnClick(Sender: TObject);
begin
  {$IFDEF NP}
    if SQLUtils.UsingSQL then
    begin
      if (DiaryFrm = nil) then
        //PS 11/05/2016 2016-R2 ABSEXCH-17364: Passed False to constructor so that all the notes entries can be seen in Diary
        DiaryFrm := TDiaryFrm.Create(self,BOff);
      DiaryFrm.WindowState := wsNormal;
    end
    else
      Create_Diary(Self,GlobDiary,4);
  {$ENDIF}
end;


procedure TMainForm.Display_AutoDiary;

Begin
  CheckedDiary:=BOn;
  {$IFDEF NP}
  {$B-}
    if SQLUtils.UsingSQL then
    begin
      if ChkAllowed_In(201) and (Diary.HasExpiredNotes(Today)) then
      begin
        //PS 11/05/2016 2016-R2 ABSEXCH-17364: Pass True to constructor if Diary should show notes till today
        DiaryFrm := TDiaryFrm.Create(self,BOn);
        DiaryFrm.Show;
      end;
    end
    else if ChkAllowed_In(201) and (Check_Diary(Today)) then
      Create_Diary(Self,GlobDiary,3);


  {$B+}
  {$ENDIF}
  
end;


procedure TMainForm.SpellCheck1Click(Sender: TObject);
begin
  SpellCheckControl(Screen.ActiveControl);
end;


procedure TMainForm.FormActivate(Sender: TObject);
begin
  If (Not CheckedDiary) then
  {$IFDEF NP}
    Timer1.Enabled:=BOn;
  {$ELSE}
    Timer1.Free;
  {$ENDIF}

  // CA  03/06/2012   v7.0  ABSEXCH-12302:    Startup Upgrade Info Window
  If (Not PostedUpgradeInfoMsg) Then
  Begin
    PostMessage(Self.Handle,WM_UpgradeForm,1,0);
    // This must be set here to prevent this postmessage from running multiple times
    PostedUpgradeInfoMsg := BOn;
  End;

  // MH 08/01/2018 2017-R1 ABSEXCH-19316: Changed display mechanism for SQL Posting Prompt Dialog
  If (Not ShownSQLPostingPrompt) Then
  Begin
    PostMessage(Self.Handle, WM_ShowSQLPostingPrompt, 1, 0);
    // This must be set here to prevent this postmessage from running multiple times
    ShownSQLPostingPrompt := BOn;
  End;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);

Var
  Done  :  Boolean;

begin
  Timer1.Enabled:=BOff;  Done:=BOn;

   If (Not CheckedDiary) then
   Begin
    Display_AutoDiary;

    If (Assigned(Replace_Image)) and (SysHandle<>0) then
    Begin
      Replace_Image(0,TRUE);

      FreeLibrary(SysHandle);
      SysHandle:=0;
      Replace_Image:=nil;
    end;

    {$IFDEF POST}
      If GlobPostLockCtrl(0) then
        GlobMoveLockCtrl;
    {$ENDIF}

    {* Destroy Timer After Use, unless we need it for automatic logout *}
      If (UserProfile^.PWTimeOut=0) or (Not Syss.UsePasswords) then
        PostMessage(Self.Handle,WM_FormCloseMsg,214,0)
      else
      Begin {Timer now used to control automatic logout, increase interval to minimise impact on UI}
        Timer1.Interval:=Round(25E3);
        Timer1.Enabled:=BOn;
      end;

     {$IFDEF GLCCDEBUG}
       ShowMessage ('GLCC Debug Enabled');
       SetMemCallback(CheckMemCallback);
       CopyGLLCC_JCGLS;
       //tmPeriodDebug.Enabled := True;
       //GLCCMonitor := TMonitorThread.Create;
     {$ENDIF}
   end
   else
   If (UserProfile^.PWTimeOut>0) and (Syss.UsePasswords) then
   Begin
     CheckEntIdle(Sender,Done);

     Timer1.Enabled:=BOn;
   end
   else {We have relogged in with a user who does not have  auto logout after a user who did, so shut it down}
     PostMessage(Self.Handle,WM_FormCloseMsg,214,0)

end;

procedure TMainForm.HelpSearchItemClick(Sender: TObject);
const
  EmptyString: PChar = '';
begin
  Application.HelpCommand(HELP_PARTIALKEY, Longint(EmptyString));
end;


procedure TMainForm.HelpHowToUseClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;



procedure TMainForm.ReLogIn;
{$IFDEF SY}
  var
    PrevHState:  Boolean;
    lfrmLogin: TfrmLogin;
begin
    SetAllowHotKey(BOff,PrevHState);
    {$IFDEF SY}
      if (Not GotPassword) and (GotSecurity)  then
      begin
        lfrmLogin := TfrmLogin.Create(Application);
        try
          with lfrmLogin do
          begin
            LoginDialog := ldExchequerCore;
            InitDefaults;
            if SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Exchequer then
              SetReLogin(EntryRec^.Login)
            else
              SetReLogin(UserProfile^.WindowUserId);
            repeat
              ShowModal;
              GotPassword := ModalResult=mrOk;
            until GotPassword;
          end;
        finally
          freeandnil(lfrmLogin);
        end;
      end;
    {$ENDIF}
    SetAllowHotKey(BOn,PrevHState);
  {$ELSE}
  Begin
    GotPassWord:=BOn;
    {SBSIn:=On;}
  {$ENDIF}           
end;


// Retrieve time in Milliseconds since windows was started
procedure TMainForm.SetLastActionTime;
begin
  LastActionTime := GetTickCount;
end;

function TMainForm.ThreadIsBusy  :  Boolean;

Begin
  If (Assigned(BackThread)) then
    Result:=Not BackThread.IdleMode
  else
    Result:=BOff;
end;

procedure TMainForm.CheckEntIdle(Sender: TObject; var Done: Boolean);
Var
  CurrTime, ElapsedTime : Cardinal;

begin

  If ((UserProfile^.PWTimeOut>0) or (Not Done)) and (Not InReLogin) and (Not EntInCLoseQ) then
  Begin

    If (Not ThreadIsBusy) and (Not InSysSS) then
    Begin
    // Retrieve current time in Milliseconds since windows was started
      CurrTime := GetTickCount;

      // Calculate elapsed time since last action in mins
      ElapsedTime := Round(DivWChk(CurrTime - LastActionTime,60E3));

      // Check if elapsed time with no actions is >= 1 minute
      If (ElapsedTime >= Cardinal(UserProfile^.PWTimeOut)) or (Not Done) Then
      Begin
        InReLogIn:=BOn;
        // PS - 30-11-2015 - ABSEXCH-11759
        //                   FIX : Added condition to restore application if Application is minimixed (Iconic)
        If IsIconic(Application.Handle) Then
          Application.Restore;

        {$B-}
          If (Assigned(Timer1)) and (Timer1.Enabled) and (Not Done) then {If its called here from a manual option stop the timer}
            Timer1.Enabled:=BOff;

        {$B+}

        GotPassWord:=BOff;

        // Hide entire application

        Application.Mainform.Visible:=BOff;

        ReLogin;

        // Reset LastActionTime to prevent time-out going off straight away
        SetLastActionTime;

        // Restore window to preious state.

        Application.Mainform.Visible:=BOn;

        {$B-}
          If (Assigned(Timer1)) and (Not Timer1.Enabled) and (Not Done) then {If its called here from a manual option stop the timer}
            Timer1.Enabled:=BOn;

        {$B+}

        InReLogin:=BOff;
      End; { If }
    end
    else
      // Reset LastActionTime as we are in a thread or System set-up.
      SetLastActionTime;

  end;
end;


procedure TMainForm.AppMessage (var Msg: TMsg; var Handled: Boolean);
begin
  If (UserProfile^.PWTimeOut>0) and (Not InReLogin) and (Not EntInCLoseQ) then
  Begin
     // KeyPress
    If (Msg.message = WM_KEYDOWN) Or (Msg.message = WM_KEYUP) Or
       // Any mouse button/wheel click
       ((Msg.message >= WM_LBUTTONDOWN) and (Msg.message <= WM_MOUSELAST)) Then
       Begin
        // Retrieve time in Milliseconds since windows was started
        SetLastActionTime;
       End; { If }
  end;
end;

//--------------------------------------------------------------

// HM 03/01/02: Added EndSession tracking

{$IFDEF DONOTUSE}
procedure TMainForm.WMQueryEndSession(var Msg: TWMQueryEndSession);
Var
  CanShutWin  :  Boolean;

begin
  Try

    CanShutWin:=BOn;

    {$IFDEF BCS}

  {   This routine was used in attempt to stop windows shutting down when com clients or the threading was present.
      Unfortunetly under multi user W32MKDE gets unloaded regardless of whether we unload or not, and so we will crash if we stop windows
      shutting down. We do not think the c/s connection would suffer from this as all access is DLL based, so we are not doing this
      for mu.

  }
     If (Not Check4SABtrv(F[CustF])) then {If it is not stand alone Btrieve, attempt to block}
     Begin
       {$IFDEF DBD}
         ShowMessage('Not local');
       {$ENDIF}

       CanShutWin:=(Not ThreadIsBusy)
         {$IFDEF CU}
           {$IFDEF COMCU}
             and (Not ActiveCOMClients)

           {$ENDIF}
         {$ENDIF}
         ;

       If (Not CanShutWin) then {Show Appropriate message}
       Begin
         CustomDlg(Application.MainForm,'WARNING!','Windows Shutdown',
                                  'Please exit '+OrigCaption+' normally before attempting to close Windows, otherwise data maybe lost.',
                                  mtWarning,[mbOK]);

       end;
     end;
  {$ENDIF}

  finally
    // Prevent shutdown of Windows whilst Enterprise is running
    LongBool(Msg.Result) := CanShutWin;
  end; {Try..}

  {$IFDEF DBD}
    ShowMessage('Can shut down = '+IntToStr(Ord(CanShutWin)));
  {$ENDIF}


  {$IFDEF CU}
    (*  Doesn't Work!!!
    // Shutdown the customisation sub-system
    TerminateCustomisation;

    // Wait a bit to allow clients to shutdown
    Delay (2000, False);
    *)
  {$ENDIF}
end;
{$ENDIF}

//--------------------------------------------------------------

{$IFDEF HM} // EndSession
procedure TMainForm.WMQueryEndSession(var Msg: TWMQueryEndSession);
Begin
  WriteDbgMsg ('EParentU.WM_QueryEndSession');
  LongBool(Msg.Result) := True;
End;

procedure TMainForm.WMEndSession(var Msg: TWMQueryEndSession);
Begin
  WriteDbgMsg ('EParentU.WM_EndSession');
  FormTidy(Self, True);
  Msg.Result := 0;
End;
{$ENDIF}

//--------------------------------------------------------------



(*
procedure TMainForm.Button1Click(Sender: TObject);
var
  EntFaxO : TEntFaxInt;
  Res     : LongInt;
begin
  { Faxing via Enterprise }
  EntFaxO := TEntFaxInt.Create;

  Try
    With EntFaxO Do Begin
      fxDocName := 'Exchequer Enterprise Fax';

      fxRecipName := 'Herman Munster';
      fxRecipNumber := '01202 298001';

      fxSenderName := 'Small John';
      fxSenderEmail := 'SJohn@exchequer.com';

      fxUserDesc := 'test fax';

      //fxPriority := 'N';
      //InitFromPrnInfo (PDevRec);

      fxFaxDir:=SyssEDI2^.EDI2Value.FaxDLLPath;

      Res := StoreDetails;

      If (Res <> 0) Then
        ShowMessage ('Res: ' + IntToStr(Res));
    End; { With }
  Finally
    EntFaxO.Destroy;
  End;
end;
*)





















procedure TMainForm.BankReconciliationClick(Sender: TObject);
begin
//PR 21/03/06 Added call to Bank Reconciliation "Wizard"
{$IFDEF EBANK}
  ReconcileBankAccount;
{$ENDIF}
end;

procedure TMainForm.BankRecReportClick(Sender: TObject);
begin
//PR 21/03/06 Added call to Bank Reconciliation Report
{$IFDEF EBank}
  BankReconciliationReport;
{$ENDIF}
end;

procedure TMainForm.eBankingSetupClick(Sender: TObject);
begin
//PR 21/03/06 Added call to EBanking admin
{$IFDEF EBANK}
  ShowEBankList;
{$ENDIF}
end;

procedure TMainForm.VisualReportWriter1Click(Sender: TObject);
Var
  OldHWnd : HWnd;
  LStr    : ANSIString;
  cmdFile, cmdPath, cmdParams : ANSIString;
  lWindowsLogin: Boolean;
begin
  // First check to see if it is already running and if so set focus to it
  OldHwnd := 0;
  EnumWindows (@EnumWndProcVisualRW, Longint(@OldHwnd));
  If (OldHwnd <> 0) Then
  Begin
    If (Not IsWindowVisible (OldHWnd)) Then
      PostMessage (OldHwnd, WM_SBSFDMsg, 0, 0);
    SetForeGroundWindow (OldHwnd);
  End { If }
  Else Begin
    // Not already running - run a new copy
    (*
    cmdFile   := ExtractFilePath(Application.ExeName) + 'ENTRW.EXE';
    cmdParams := '/DIR: '+IncludeTrailingPathDelimiter(SetDrive)+' /USER: '+Trim(EntryRec^.Login)+' /JLHABB' + IfThen(NoXLogo, ' /NL:', '');
    cmdPath   := ExtractFilePath(Application.ExeName);

    ShellExecute(Application.MainForm.Handle, NIL, PCHAR(cmdFile), PCHAR(cmdParams), PCHAR(cmdPath), SW_SHOWNORMAL);
    *)

    // MH 18/09/07: Modified to use WinExec as ShellExecute queries whether the user wants to run it
    // under VISTA
    lWindowsLogin := SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows;
    cmdFile   := ExtractFilePath(Application.ExeName) + 'ENTRW.EXE /DIR: ' +
                 IncludeTrailingPathDelimiter(SetDrive)+ ' /USER: ' + IfThen(lWindowsLogin, Trim(UserProfile.Login), Trim(UserProfile.Login)) +
                 ' /JLHABB' + IfThen(NoXLogo, ' /NL:', '');
    WinExec (PCHAR(cmdFile), SW_SHOWNORMAL);

  End; { Else }
end;

procedure TMainForm.tmPeriodDebugTimer(Sender: TObject);
begin
  {$IFDEF PERIODDEBUG}
    CheckPeriods ('Timer');
  {$ENDIF}
  {$IFDEF GLCCDEBUG}
//    tmPeriodDebug.Enabled := False;
//    If CheckGLLCC_JCGLS Then
//      tmPeriodDebug.Enabled := True;

    tmPeriodDebug.Enabled := False;
    CheckGlobalStrings;
    tmPeriodDebug.Enabled := True;
  {$ENDIF}
end;

{$IFDEF PERIODDEBUG}
procedure TMainForm.CheckPeriods(Const Source : ShortString);
begin
  If PD_Enabled And
     (
       (PD_Syss_Period <> Syss.CPr) Or
       (PD_Syss_Year <> Syss.CYr) Or
       (PD_Syss_DispAsMonths <> Syss.DispPrAsMonths) Or
       {$IFDEF PERIODFIX}
       (PD_User_Period <> oUserPeriod.Period) Or
       (PD_User_Year <> oUserPeriod.Year) Or
       (PD_User_DispAsMonths <> oUserPeriod.DisplayAsMonths)
       {$ELSE}
       (PD_User_Period <> UserProfile^.UCPr) Or
       (PD_User_Year <> UserProfile^.UCYr) Or
       (PD_User_DispAsMonths <> UserProfile^.UDispPrMnth)
       {$ENDIF}
     ) Then
  Begin
    tmPeriodDebug.Enabled := False;

    ShowMessage ('Period Information Change Detected at ' + FormatDateTime('hh:nn.ss.zzz', Now) + ' by ' + Source + #13 +
                 'InGetMultiSys: ' + IntToStr(Ord(PD_InGetMultiSys)) + ' - InPutMultiSys: ' + IntToStr(Ord(PD_InPutMultiSys)) + #13 +
                 Format('Global Period: %d (Was %d) - Year %d (Was %d) - DispAsMonths %d (Was %d)', [Syss.CPr, PD_Syss_Period, Syss.CYr, PD_Syss_Year, Ord(Syss.DispPrAsMonths), Ord(PD_Syss_DispAsMonths)]) + #13 +
                 {$IFDEF PERIODFIX}
                 Format('User Period: %d (Was %d) - Year %d (Was %d) - DispAsMonths %d (Was %d)', [oUserPeriod.Period, PD_User_Period, oUserPeriod.Year, PD_User_Year, Ord(oUserPeriod.DisplayAsMonths), Ord(PD_User_DispAsMonths)]));
                 {$ELSE}
                 Format('User Period: %d (Was %d) - Year %d (Was %d) - DispAsMonths %d (Was %d)', [UserProfile^.UCPr, PD_User_Period, UserProfile^.UCYr, PD_User_Year, Ord(UserProfile^.UDispPrMnth), Ord(PD_User_DispAsMonths)]));
                 {$ENDIF}

    PD_Syss_Period := Syss.CPr;
    PD_Syss_Year := Syss.CYr;
    PD_Syss_DispAsMonths := Syss.DispPrAsMonths;

    {$IFDEF PERIODFIX}
      PD_User_Period := oUserPeriod.Period;
      PD_User_Year := oUserPeriod.Year;
      PD_User_DispAsMonths := oUserPeriod.DisplayAsMonths;
    {$ELSE}
      PD_User_Period := UserProfile^.UCPr;
      PD_User_Year := UserProfile^.UCYr;
      PD_User_DispAsMonths := UserProfile^.UDispPrMnth;
    {$ENDIF}

    tmPeriodDebug.Enabled := True;
  End; // If
end;
{$ENDIF}

procedure TMainForm.XXXBangClick(Sender: TObject);
begin
  Raise Exception.Create ('TMainForm.XXXBangClick: MadExcept Test');
end;

procedure TMainForm.XXXmnuCustomerPortalClick(Sender: TObject);
begin
  //TW 05/08/2011: Changed button name to hide it from the options menu.
  //AP : 21/03/2017 2017-R1 ABSEXCH-18460 : Change MyExchequer Link
  ShellExecute(Application.MainForm.Handle, 'open', 'https://customers.oneadvanced.com/login', '', '', SW_SHOWNORMAL);
end;

procedure TMainForm.mnuTraderBankCardAuditClick(Sender: TObject);
begin
  DisplayAuditTrail;
end;

procedure TMainForm.MenItem_SaveCoordinatesClick(Sender: TObject);
begin
 FSaveCoords := not FSaveCoords;

 TMenuItem(Sender).Checked := FSaveCoords;
end;

procedure TMainForm.MenItem_ResetToDefaultClick(Sender: TObject);
begin
 FSettings.DeleteWindowSettings;

 MenItem_SaveCoordinates.Checked := false;
 MenItem_SaveCoordinates.Enabled := false;

 MenItem_ResetToDefault.Enabled := false;
 FSaveCoords := false;

 MessageBox(0, PChar('Default settings will be applied next time you open this window.'),
  'Information', +mb_OK + MB_ICONASTERISK);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  //TW 04/08/2011: Loads window size/position if settings are present after
  //               user changes companies.
  LoadCoordinates;
  //TG Open UserProfile when the security question or answer is not set.
  SetSecurityQuestionAnswer;
end;

procedure TMainForm.LoadCoordinates();
var
  currMonitor : TMonitor;
begin
  //TW 04/08/2011: Loads window size/position
  //   01/09/2011: Added code to compensate for dual monitor setups
  FSettings := GetWindowSettings(Self.Name);
  MenItem_SaveCoordinates.Enabled := true;
  MenItem_ResetToDefault.Enabled := true;
  FSaveCoords := false;

  if Assigned(FSettings) then
  begin
   FSettings.LoadSettings;

   if not FSettings.UseDefaults then
   begin
     //If the user saves the size/position after the form has been maximised
     //the windowstate is changed to prevent the next load from being maximised.
     if self.WindowState = wsMaximized then
       self.WindowState := wsNormal;                                             

     //Settings are loaded after the window state change otherwise the window will
     //be set to the previous un-maximised size/position.
     FSettings.SettingsToWindow(self);

     if(screen.MonitorCount > 1) then
     begin
       //Retrieves current monitor on which the majority of the form resides
       currMonitor := nil;
       currMonitor := Screen.MonitorFromWindow(self.WindowHandle, mdNearest);

       //Smart Resize > you
       if (currMonitor <> nil) then
       begin
        if(self.Left < currMonitor.Left) then
         self.Left := currMonitor.Left;
       
        if(self.Top < currMonitor.Top) then
         self.Top := currMonitor.Top;

        if (self.Width > currMonitor.Width) then
         self.Width := currMonitor.Width;

        if (self.Height > currMonitor.WorkareaRect.Bottom) then
         self.Height := currMonitor.WorkareaRect.Bottom;

        if(self.Left + self.Width > (currMonitor.WorkareaRect.Left + currmonitor.Width)) then
         self.Left := (currMonitor.WorkareaRect.Left + currmonitor.Width) - self.Width;

        if(self.Top + self.height > currMonitor.WorkareaRect.Bottom) then
         self.Top := currMonitor.WorkareaRect.Bottom - self.Height;
       end;
     end;

     MenItem_ResetToDefault.Enabled := true;
   end
   else
   begin
     //If no settings are present maximise the window(default behavior)
     self.Left := screen.WorkAreaLeft;
     self.Top := screen.WorkAreaTop;
     self.WindowState := wsMaximized;
   end;
  end;
end;

procedure TMainForm.SaveCoordinates();
begin
  //TW 04/08/2011: Main Size/position save method.
  if FSaveCoords then
  begin
    FSettings.WindowToSettings(Self);
    FSettings.SaveSettings(true);
    MenItem_SaveCoordinates.Checked := false;
  end;
end;

procedure TMainForm.MenItem_UserFieldsClick(Sender: TObject);
var
  index : integer;
  formFound : boolean;
begin
  //TW 17/11/11: Check if user fields config is already open and if not open it!
  formFound := false;

  for index := 0 to Screen.FormCount - 1 do
  begin
    if (screen.Forms[index] is TFrm_UserFieldConfig) then
      formFound := true;
  end;

  if (not formFound) then
    TFrm_UserFieldConfig.Create(Application);
end;

procedure TMainForm.Customer1Click(Sender: TObject);
var
  OptionsDialog: TRepInpMsg2;
begin
  OptionsDialog := TRepInpMsg2.Create(anrCustomer, Self);
  OptionsDialog.Show;
end;

procedure TMainForm.Supplier1Click(Sender: TObject);
var
  OptionsDialog: TRepInpMsg2;
begin
  OptionsDialog := TRepInpMsg2.Create(anrSupplier, Self);
  OptionsDialog.Show;
end;

procedure TMainForm.transactions1Click(Sender: TObject);
var
  OptionsDialog: TRepInpMsg2;
begin
  OptionsDialog := TRepInpMsg2.Create(anrTransaction, Self);
  OptionsDialog.Show;
end;

procedure TMainForm.Stock2Click(Sender: TObject);
var
  OptionsDialog: TRepInpMsg2;
begin
  OptionsDialog := TRepInpMsg2.Create(anrStock, Self);
  OptionsDialog.Show;
end;

procedure TMainForm.Jobs1Click(Sender: TObject);
var
  OptionsDialog: TRepInpMsg2;
begin
  OptionsDialog := TRepInpMsg2.Create(anrJob, Self);
  OptionsDialog.Show;
end;

procedure TMainForm.UpdateInformationDetails1Click(Sender: TObject);
begin
  TUpgradeForm.Create(Application.MainForm);
end;

procedure TMainForm.DispatchesECSSD1Click(Sender: TObject);
Var
  RT  :  Word;
begin
  RT:=100;  // For Dispatches

  VAT_Report(RT,Self);
end;

procedure TMainForm.ArrivalsECSSD1Click(Sender: TObject);
Var
  RT  :  Word;
begin
  RT:=200;  // For Arrivals

  VAT_Report(RT,Self);
end;

// CJS 2015-04-28 - ABSEXCH-16163 - Check All Accounts, SQL improvements
procedure TMainForm.CheckCustomerStockAnalysis1Click(Sender: TObject);
begin
{$IFDEF STK}
  CheckCustomerStockAnalysis(self);
{$ENDIF}
end;


procedure TMainForm.mnuoptCreditCardPaymentGatewayClick(Sender: TObject);
begin
  {$IFDEF SOP}
    // MH 22/07/2014 v7.X Order Payments: Call out to Credit Card Payment Gateway Plug-In Configuration method
    CreditCardPaymentGateway.DisplayConfigurationWindow;
  {$ENDIF SOP}
end;


procedure TMainForm.mnuUnallocateCustomersClick(Sender: TObject);
begin
  //Tag on menu items is set to appropriate account type
  if Sender is TMenuItem then
    with Sender as TMenuItem do
     UnallocateAllTransactions(Tag);
end;

procedure TMainForm.mnuoptEndofDayPaymentsReportClick(Sender: TObject);
begin
  // MH 12/06/2015 Exch-R1 ABSEXCH-16494: Added Order Payments End of Day Payments Report
  {$IFDEF SOP}
    RunEndOfDayPaymentsReport (Self);
  {$ENDIF SOP}
end;

procedure TMainForm.mnuoptOrderPaymentsTrackerClick(Sender: TObject);
begin
  {$IFDEF SOP}
    // MH 06/08/2015 2015-R1 ABSEXCH-16664: Added ObjectNorbert aka Order Payments Tracker window
    DisplayOrderPaymentsTracker;
  {$ENDIF}
end;

// Creates (if necessary) the Intrastat Control Centre form and displays it
procedure TMainForm.IntrastatControlCentre1Click(Sender: TObject);
begin
  if (ICCFrm = nil) then
    ICCFrm := TfrmIntrastatControlCentre.Create(self);
  ICCFrm.Show;
end;

//------------------------------------------------------------------------------
// PKR. 12/04/2016. ABSEXCH-17383. eRCT support
// Need access to the private InBatchPay array, so added these to service the Properties
function TMainForm.GetBatchPayInUse(aIndex : Boolean) : Boolean;
begin
  Result := InBatchPay[aIndex];
end;

procedure TMainForm.SetBatchPayInUse(aIndex : Boolean; Value : Boolean);
begin
  InBatchPay[aIndex] := Value;
end;

//------------------------------------------------------------------------------
//PR: 13/05/2016 ABSEXCH-17450 New message handler to kick off CheckAllAccounts after revaluation
Procedure TMainForm.WMThreadFinished(Var Message  :  TMessage);
var
  ProcessLockType : TProcessLockType;
begin
  // CJS 2016-05-23 - ABSEXCH-17491 - Check All Accounts fails at end of Total Unpost
  // Added Total Unpost message handling
  if (Message.WParam = PID_POSTING_AFTER_REVAL) or
     (Message.WParam = PID_TOTAL_UNPOST_FINISHED) then
  begin
    //PR: 24/07/2017 ABSEXCH-18683 release the appropriate lock
    if Message.WParam = PID_POSTING_AFTER_REVAL then
      ProcessLockType := plRevaluation
    else
      ProcessLockType := plUnpost;

    if SQLUtils.UsingSQLAlternateFuncs and SQLReportsConfiguration.UseSQLCheckAllAccounts then
      CheckAllAccounts(Application.MainForm, False, ProcessLockType)
    else
      AddCheckCust2Thread(Application.MainForm, '', BOn, BOn, BOff);
  end
  else if (Message.WParam = PID_BACS_SCAN_FINISHED) then
  begin
    if RCTGateway.IsRunning then
      RCTGateway.Process;
  end
  else if (Message.WParam = PID_BATCH_PAYMENTS_FINISHED) then
  begin
    if RCTGateway.IsRunning then
      RCTGateway.Finish;
  end;
end;

//PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Release process lock
Procedure TMainForm.WMLockedProcessFinished(Var Message  :  TMessage);
begin
  if SQLUtils.UsingSQLAlternateFuncs and (TProcessLockType(Message.WParam) <> plNone) then
    RemoveCurrentProcessLock(TProcessLockType(Message.WParam));
end;

//------------------------------------------------------------------------------

// CJS 2016-06-29 - ABSEXCH-17383 - eRCT
procedure TMainForm.eRCT1Click(Sender: TObject);
begin
  if RCTGateway.HasActivePlugin then
    RCTGateway.Start;
end;

//------------------------------------------------------------------------------

// CJS 2016-06-29 - ABSEXCH-17383 - eRCT
procedure TMainForm.PrepareRCT;
var
  Gateway: TRCTGateway;
begin
  Gateway := TRCTGateway.Create;
  try
    if Gateway.HasActivePlugin then
      eRCT1.Caption := Gateway.MenuCaption
    else
      eRCT1.Visible := False;
  finally
    Gateway.Free;
  end;
end;

//------------------------------------------------------------------------------
//HV 23/03/2017 2017-R1 ABSEXCH-18436: New Standard Report - Traders on Hold
procedure TMainForm.mnuTradersonHoldRepClick(Sender: TObject);
begin
  {$IFDEF Rp}
    if Assigned(Sender) and (Sender is TMenuItem) then
      TradersOnHold_Report(Self, nil);
  {$ENDIF}
end;

//HV 24/03/2017 2017-R1 ABSEXCH-18498: Standard Reports - List of current status of all Purchase Orders
procedure TMainForm.mniOrdersStatusClick(Sender: TObject);
var
  lAccrualRepDlg: TfrmAccrualRepDlg;
  lReportParameters: DocRepPtr;
begin
  {$IFDEF Rp}
    if Assigned(Sender) and (Sender is TMenuItem) then
    begin
      case TMenuItem(Sender).Tag of
        1:  TradersOrder_Report(Self, torSalesOrders, nil);
        2:  TradersOrder_Report(Self, torPurchaseOrders, nil);
        3:  TradersOrder_Report(Self, torSalesDeliveryNote, nil);
        4:  TradersOrder_Report(Self, torPurchaseDeliveryNote, nil);
        5:  TradersOrder_Report(Self, torSalesOrdersPartialDelivered, nil);
        6:  TradersOrder_Report(Self, torPurchaseOrdersPartialDelivered, nil);
        //PL 27/10/2017 2017-R2	ABSEXCH-19369 Enhancements to Picked Sales Order Report
        7:  begin
              lReportParameters.Summary := true;
              TradersOrder_Report(Self, torSalesOrdersPicked, lReportParameters);
            end;

        8:  TradersOrder_Report(Self, torSalesOrdersPicked, nil);
      end; {Case..}
    end;
  {$ENDIF}
end;

procedure TMainForm.mniMyUserProfileClick(Sender: TObject);
var
  lUserProfile: TfrmUserProfile;
  lUserDetailIntf: IUserDetails;
  lUserDetailObj: TUserDetail;
  lUserPassDetailRec: tPassDefType;
begin
  FillChar(lUserPassDetailRec, SizeOf(lUserPassDetailRec), #0);
  lUserPassDetailRec.Login := EntryRec^.Login;
  lUserDetailObj := CreateUser(0, umUpdate, lUserPassDetailRec);
  if Assigned(lUserDetailObj) then
  begin
    try
      lUserDetailIntf := lUserDetailObj;
      lUserProfile := TfrmUserProfile.Create(Self, umUpdate, lUserDetailIntf);
      lUserProfile.Show;
    except
      if Assigned(lUserProfile) then
        Freeandnil(lUserProfile);
    end;
  end; 
end;

//------------------------------------------------------------------------------

procedure TMainForm.SetSecurityQuestionAnswer;
var
  lUserProfile: TfrmUserProfile;
  lUserDetailIntf: IUserDetails;
  lUserDetailObj: TUserDetail;
  lUserPassDetailRec: tPassDefType;
begin
  if SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows then
    exit;

  if (UserProfile.Loaded = True) and ((UserProfile^.SecurityQuestionId = 0) or (UserProfile^.SecurityAnswer = EmptyStr)) then
  begin
    FillChar(lUserPassDetailRec, SizeOf(lUserPassDetailRec), #0);
    lUserPassDetailRec.Login := EntryRec^.Login;

    lUserDetailObj := CreateUser(0, umUpdate, lUserPassDetailRec);
    lUserDetailIntf := lUserDetailObj;
    try
      if Assigned(lUserDetailIntf) then
      begin
        if MessageDlg(msgSetQuesAns, mtWarning, [mbOK], 0) = mrOk then
        begin
          lUserDetailIntf := lUserDetailIntf.EditUser;
          lUserProfile := TfrmUserProfile.Create(Self, umUpdate, lUserDetailIntf);
          lUserProfile.btnCancel.Visible := False;
          lUserProfile.Show;
        end
        else
          lUserDetailIntf := nil;
      end
      else
        lUserDetailIntf := nil;
    except
      if Assigned(lUserProfile) then
        FreeAndNil(lUserProfile);
    end;
  end;
end;

//------------------------------------------------------------------------------
//AP: 29/09/2017 ABSEXCH-16645 Built-in Cumulative cleared balance recalc
procedure TMainForm.XXXCAllGLYTDBalClick(Sender: TObject);
begin
  AddCheckAllNom2Thread(self);
end;

//------------------------------------------------------------------------------

procedure TMainForm.mnuoptAnonymisationControlCentreClick(Sender: TObject);
var
  lCreateNew: Boolean;
  i: Integer;
begin
  lCreateNew := True;
  for I := 0 to (Application.MainForm.MDIChildCount - 1) do
  begin
    if (Application.MainForm.MDIChildren[I] is TfrmAnonymisationControlCentre) then
    begin
      Application.MainForm.MDIChildren[I].Show;
      lCreateNew := False;
      Break;
    end;
  end;
  if lCreateNew then
    TfrmAnonymisationControlCentre.Create(Self).Show;
end;

//-------------------------------------------------------------------------

// MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
procedure TMainForm.mnuCheckSQLPostingCompatibilityClick(Sender: TObject);
begin
  DisplaySQLPostingPrompt (dmManual);
end;

//-----------------------------------

// MH 08/01/2018 2017-R1 ABSEXCH-19316: Changed display mechanism for SQL Posting Prompt Dialog
procedure TMainForm.ShowSQLPostingPrompt(var Message: TMessage);
Begin // ShowSQLPostingPrompt
  {$IFDEF POST}
    // MH 04/01/2018 2017-R1 ABSEXCH-19316: Check SQL Posting Status if user has Posting Permission
    If SQLUtils.UsingSQLAlternateFuncs And CheckSQLPostingStatus Then
    Begin
      If (SQLReportsConfiguration.SQLPostingStatus[SQLUtils.GetCompanyCode(SetDrive)] = psPending) Then
        // Pending - Display Prompt Dialog and menu option
        DisplaySQLPostingPrompt (dmAuto);
    End; // If SQLUtils.UsingSQLAlternateFuncs And CheckSQLPostingStatus
  {$ENDIF}
End; // ShowSQLPostingPrompt

//-------------------------------------------------------------------------

// MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
procedure TMainForm.EvaluateListExportButtonStatus;
Var
  WindowExportComp : TComponent;
Begin // EvaluateListExportButtonStatus
  // MH 23/02/2018 2018-R2 ABSEXCH-19172: Determine whether the Export to Excel button should be enabled
  If agbExportToExcel.Visible Then
  Begin
    If Assigned(Screen.ActiveForm) Then
    Begin
      If (Screen.ActiveForm.FormStyle = fsMDIChild) Then
      Begin
        // Check the active form for a 'WindowExport' component and determine whether to show the export button
        WindowExportComp := Screen.ActiveForm.FindComponent('WindowExport');
        If Assigned(WindowExportComp) Then
          agbExportToExcel.Enabled := TWindowExport(WindowExportComp).EnableExport
        Else
          agbExportToExcel.Enabled := False;
      End // If agbExportToExcel.Enabled
      Else
        agbExportToExcel.Enabled := False;
    End // If Assigned(Screen.ActiveForm)
    Else
      agbExportToExcel.Enabled := False;
  End; // If agbExportToExcel.Visible
End; // EvaluateListExportButtonStatus

//-----------------------------------

// MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
procedure TMainForm.ReevaluateListExportStatus(var Message: TMessage);
Begin // ReevaluateListExportStatus
  EvaluateListExportButtonStatus;
End; // ReevaluateListExportStatus

//-----------------------------------

// MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
procedure TMainForm.popExportListPopup(Sender: TObject);
Var
  WindowExportComp : TComponent;
  NewItem : TMenuItem;
  I : Integer;
begin
  // Clear out any existing menu items
  While (popExportList.Items.Count > 0) Do
    popExportList.Items[0].Free;

  // Look for the export component
  WindowExportComp := NIL;
  If Assigned(Screen.ActiveForm) Then
    If (Screen.ActiveForm.FormStyle = fsMDIChild) Then
      WindowExportComp := Screen.ActiveForm.FindComponent('WindowExport');

  If Assigned(WindowExportComp) Then
    With TWindowExport(WindowExportComp) Do
    Begin
      For I := 0 To (ExportCommandCount - 1) Do
        With ExportCommands[I] Do
        Begin
          NewItem := TMenuItem.Create(Self);
          NewItem.Caption := wecCommandDescription;
          NewItem.OnClick := ExportToExcelMenuItemsClick;
          NewItem.Tag := wecCommandID;
          popExportList.Items.Add(NewItem);
        End; // With ExportCommands[I]
    End; // With TWindowExport(WindowExportComp)
end;

//-----------------------------------

// MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
procedure TMainForm.ExportToExcelMenuItemsClick(Sender: TObject);
Var
  WindowExportComp : TComponent;
begin
  // Look for the export component
  WindowExportComp := NIL;
  If Assigned(Screen.ActiveForm) Then
    If (Screen.ActiveForm.FormStyle = fsMDIChild) Then
    Begin
      WindowExportComp := Screen.ActiveForm.FindComponent('WindowExport');

      If Assigned(WindowExportComp) Then
        //TWindowExport(WindowExportComp).ExecuteCommand(TMenuItem(Sender).Tag);
        ExecuteListExport (TWindowExport(WindowExportComp), TMenuItem(Sender).Tag);
    End; // If (Screen.ActiveForm.FormStyle = fsMDIChild)
end;

//-------------------------------------------------------------------------

procedure TMainForm.Button1Click(Sender: TObject);
var
  lFrmObj: TForm1;
begin
  lFrmObj := TForm1.Create(Self);
  lFrmObj.Show();
end;

Initialization
  ExitSave:=ExitProc;
  ExitProc:=@Ex_Abort;

  {$IFDEF PERIODDEBUG}
    PD_Enabled := False;
    PD_InGetMultiSys := 0;
    PD_InPutMultiSys := 0;
  {$ENDIF}

  { Create thread files }

  {$IFDEF HTMLHELP}
    Application.HelpFile := ExtractFileDir(ParamStr(0))+'\ENTRPRSE.CHM';
  {$ENDIF}

  { HM 01/02/00: Modified as was preventing the COM Server being registered }
  {              without the user logging in.                               }
  {$IFDEF CU}
    {$IFDEF COMCU}
      { Check to see if Regsitering/unregistering the COM Server }
      If Not (ComServer.StartMode In [smRegServer, smUnregServer]) Then
        { Not Registering/UnRegistering the COM Server - Carry on as normal }
        StartLogIn;
    {$ELSE}
      StartLogIn;
    {$ENDIF}
  {$ELSE}
    StartLogIn;
  {$ENDIF}

  //HV 09/11/2017 2018-R1: Highlighting PII Fields flag for GDPR
  GDPRColor := UserProfile.HighlightPIIColour;
  IsGDPROn := GDPROn and UserProfile.HighlightPIIFields;
Finalization

end.

