unit CustR3U;

interface

{$I DEFOVR.Inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, CheckBoxEx,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Buttons,QtyBreakVar,
  GlobVar,VarConst,BtrvU2,BTSupU1,ExWrap1U, BorBtns,SupListU,Math,SQLUtils,


  {$IFDEF NP}
    NoteU,
  {$ENDIF}

  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  {$IFDEF Frm}
    PrintFrm,
  {$ENDIF}

  SBSComp2,

  Recon3U,
  ExtGetU,
  CustSupU,

  {$IFDEF PF_On}
    {$IFDEF STK}
      StkQtyU,

    {$ENDIF}
  {$ENDIF}

  AuditIntf,

  VarSortV,
  SortCust,
  ImgModU,

  {$IFDEF CU}
  // 17/01/2013 PKR ABSEXCH-13449
  // Custom buttons 3..6 now available
  CustomBtnHandler,
  {$ENDIF}

  // 02/10/2013. PKR. MRD 7.X Item 2.4 - Ledger Multi-Contacts
  // Added to 7.0.9 20/01/2014.
  CustRolesFrame,

  Menus,
  MBDFrame,
  EntWindowSettings, TCustom,

  // MH 06/03/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  WindowExport, ExportListIntf, oExcelExport,

  // PKR. 13/01/2016. ABSEXCH-17098. Intrastat fields.
  oSystemSetup,
  IntrastatXML;


Const
  MainPNo        =  0;
  DefaultPNo     =  1;
  eCommPNo       =  2;
  RolesPNo       =  3;
  NotesPNo       =  4;
  DiscPNo        =  5;
  MultiBuyPNo    =  6;  //PR: 30/09/2009 Inserted constant for MultiBuy page and adjusted later page nos
  LedgerPNo      =  7;
  OrdersPNo      =  8;
  WOROrdersPNo   =  9;

  JAPPSPNo       =  10;
  RetPNo         = 11 ;

  ListNames : Array[4..11] of String[8] = ('Notes', 'Discount', 'MultiBuy', 'Ledger',
                                           'Orders', 'WOR', 'JAP', 'RET');

  // CJS 2013-09-27 - MRD1.1.14 - Trader List
  // Constants for use by the user access permission routines
  MAIN_PAGES     = [MainPNo, DefaultPNo, eCommPNo];
  DISCOUNT_PAGES = [DiscPNo, MultiBuyPNo];
  LEDGER_PAGES   = [LedgerPNo];
  ORDERS_PAGES   = [OrdersPNo, WOROrdersPNo];
  JOB_PAGES      = [JAPPSPNo];
  RETURNS_PAGES  = [RetPNo];
  // PKR 2013-10-10 - MRD 7.X Item 2.4 - Ledger Multi-Contacts
  // Added the Roles page
  ROLES_PAGES    = [RolesPNo];

  //PR: 22/03/2017 ABSEXCH-18143 v2017 Set of tabs where we have a transaction
  TRANS_PAGES = LEDGER_PAGES + ORDERS_PAGES + JOB_PAGES + RETURNS_PAGES;

  

type
  TCustPW2  =  Array[Boff..BOn,1..2] of LongInt;

  // CJS 2013-09-27 - MRD1.1.14 - Trader List
  // Array for passing to GetUserAccessCode() (replacement for ChkPWord3), to
  // return the appropriate access-permission code for the different tabs and
  // trader types
  // PKR 19/02/2014. Extended to include Roles tab.
  TAccessCodeList = array[0..6] of Integer;

  TCustRec3 = class(TForm)
    PageControl1: TPageControl;
    // CJS 2013-09-23 - added support for Consumers (updated Tab Sheet names to
    // make them more identifiable; also added Roles page)
    MainPage: TTabSheet;
    DefaultsPage: TTabSheet;
    RolesPage: TTabSheet;
    NotesPage: TTabSheet;
    eCommPage: TTabSheet;
    DiscountsPage: TTabSheet;
    MultiBuyDiscountsPage: TTabSheet;
    OrdersPage: TTabSheet;
    LedgerPage: TTabSheet;
    WorksOrdersPage: TTabSheet;
    JobApplicationsPage: TTabSheet;
    ReturnsPage: TTabSheet;
    TCNScrollBox: TScrollBox;
    TNHedPanel: TSBSPanel;
    NDateLab: TSBSPanel;
    NDescLab: TSBSPanel;
    NUserLab: TSBSPanel;
    NDatePanel: TSBSPanel;
    NDescPanel: TSBSPanel;
    NUserPanel: TSBSPanel;
    CDSBox: TScrollBox;
    CDHedPanel: TSBSPanel;
    CDSLab: TSBSPanel;
    CDTLab: TSBSPanel;
    CDULab: TSBSPanel;
    CDBLab: TSBSPanel;
    CDDLab: TSBSPanel;
    CDVLab: TSBSPanel;
    CDMLab: TSBSPanel;
    CDMPanel: TSBSPanel;
    CLSBox: TScrollBox;
    CLHedPanel: TSBSPanel;
    CLORefLab: TSBSPanel;
    CLDateLab: TSBSPanel;
    CLAmtLab: TSBSPanel;
    CLOSLab: TSBSPanel;
    CLTotLab: TSBSPanel;
    CLYRefLab: TSBSPanel;
    CLDueLab: TSBSPanel;
    CLORefPanel: TSBSPanel;
    CLDatePanel: TSBSPanel;
    CLAMTPanel: TSBSPanel;
    CLOSPAnel: TSBSPanel;
    CLTotPanel: TSBSPanel;
    CLYRefPanel: TSBSPanel;
    CLDuePanel: TSBSPanel;
    CListBtnPanel: TSBSPanel;
    CDListBtnPanel: TSBSPanel;
    TCNListBtnPanel: TSBSPanel;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    SBSPanel1: TSBSPanel;
    TCMScrollBox: TScrollBox;
    SBSPanel2: TSBSPanel;
    Label86: Label8;
    Label87: Label8;
    ContactF: Text8Pt;
    Addr1F: Text8Pt;
    Addr2F: Text8Pt;
    Addr3F: Text8Pt;
    Addr4F: Text8Pt;
    Addr5F: Text8Pt;
    PhoneF: Text8Pt;
    FaxF: Text8Pt;
    MobileF: Text8Pt;
    SBSPanel3: TSBSPanel;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    Label89: Label8;
    Label810: Label8;
    Label811: Label8;
    Label812: Label8;
    Label813: Label8;
    Label814: Label8;
    Label815: Label8;
    Label816: Label8;
    Label818: Label8;
    Label819: Label8;
    Label841: Label8;
    PayTF: TCurrencyEdit;
    CredStatF: TCurrencyEdit;
    TPrTO: TCurrencyEdit;
    TYTDTO: TCurrencyEdit;
    LYTDTO: TCurrencyEdit;
    CurrBalF: TCurrencyEdit;
    CrLimitF: TCurrencyEdit;
    CommitLF: TCurrencyEdit;
    CredAvailF: TCurrencyEdit;
    StatusF: Text8Pt;
    SBSPanel8: TSBSPanel;
    lblCompanyName: Label8;
    Label85: Label8;
    CompF: Text8Pt;
    ACCodeF: Text8Pt;
    SBSPanel4: TSBSPanel;
    TCDScrollBox: TScrollBox;
    SBSPanel6: TSBSPanel;
    Label822: Label8;
    Label823: Label8;
    InvoiceToLbl: Label8;
    DAddr1F: Text8Pt;
    DAddr2F: Text8Pt;
    DAddr3F: Text8Pt;
    DAddr4F: Text8Pt;
    DAddr5F: Text8Pt;
    TOurF: Text8Pt;
    InvTF: Text8Pt;
    SBSPanel7: TSBSPanel;
    Label827: Label8;
    Label829: Label8;
    Label831: Label8;
    Label832: Label8;
    CDRCurrLab: Label8;
    CDRCCLab: Label8;
    Label842: Label8;
    DiscF: Text8Pt;
    CCF: Text8Pt;
    DNomF: Text8Pt;
    AreaF: Text8Pt;
    DepF: Text8Pt;
    DCNomF: Text8Pt;
    CurrF: TSBSComboBox;
    Bevel1: TBevel;
    RepF: Text8Pt;
    CLOrigPanel: TSBSPanel;
    CLOrigLab: TSBSPanel;
    COSBox: TScrollBox;
    COHedPanel: TSBSPanel;
    COORefLab: TSBSPanel;
    CODateLab: TSBSPanel;
    COAMTLab: TSBSPanel;
    COCosLab: TSBSPanel;
    CODisLab: TSBSPanel;
    COMarLab: TSBSPanel;
    COGPLab: TSBSPanel;
    COORefPanel: TSBSPanel;
    CODatePanel: TSBSPanel;
    COAmtPanel: TSBSPanel;
    COCosPanel: TSBSPanel;
    CODisPanel: TSBSPanel;
    COMarPanel: TSBSPanel;
    COGPPanel: TSBSPanel;
    COListBtnPanel: TSBSPanel;
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
    MACP1Btn: TButton;
    JmpCp1Btn: TButton;
    CopyCP1Btn: TButton;
    ViewCP1Btn: TButton;
    ChkCP1Btn: TButton;
    HldCP1Btn: TButton;
    PrnCP1Btn: TButton;
    UACP1Btn: TButton;
    PACP1Btn: TButton;
    AlCP1Btn: TButton;
    InsCP3Btn: TButton;
    GenCP3Btn: TButton;
    CDSPanel: TSBSPanel;
    CDTPanel: TSBSPanel;
    CDUPanel: TSBSPanel;
    CDBPanel: TSBSPanel;
    CDDPanel: TSBSPanel;
    CDVPanel: TSBSPanel;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Insert1: TMenuItem;
    Delete1: TMenuItem;
    Find1: TMenuItem;
    Hist1: TMenuItem;
    Switch1: TMenuItem;
    All1: TMenuItem;
    PartAll1: TMenuItem;
    Unall1: TMenuItem;
    Output1: TMenuItem;
    Hold1: TMenuItem;
    Match1: TMenuItem;
    Jump1: TMenuItem;
    View1: TMenuItem;
    Copy1: TMenuItem;
    Check1: TMenuItem;
    N2: TMenuItem;
    CurCP1Btn: TButton;
    Currency1: TMenuItem;
    PopupMenu4: TPopupMenu;
    Copy2: TMenuItem;
    Reverse1: TMenuItem;
    PopupMenu6: TPopupMenu;
    SN1: TMenuItem;
    OH1: TMenuItem;
    CL1: TMenuItem;
    MenuItem3: TMenuItem;
    Op1: TMenuItem;
    PopupMenu2: TPopupMenu;
    Bal1: TMenuItem;
    Profit1: TMenuItem;
    LettrBtn: TButton;
    Letters1: TMenuItem;
    SetCP1Btn: TButton;
    Settle1: TMenuItem;
    CLBotPanel: TSBSPanel;
    TotValPanel: TSBSPanel;
    Label817: Label8;
    TotLab: Label8;
    SBSPanel11: TSBSPanel;
    DueTit: Label8;
    DueLab: Label8;
    SBSPanel13: TSBSPanel;
    StatusTit: Label8;
    StatusLab: Label8;
    AllocPanel: TSBSPanel;
    TotTit: Label8;
    UnalLab: Label8;
    PopupMenu5: TPopupMenu;
    CFrom1: TMenuItem;
    CTo1: TMenuItem;
    StatCP1Btn: TButton;
    DisCP1Btn: TButton;
    Discount1: TMenuItem;
    Status1: TMenuItem;
    PopupMenu3: TPopupMenu;
    HQ1: TMenuItem;
    HU1: TMenuItem;
    HA1: TMenuItem;
    MenuItem5: TMenuItem;
    HC1: TMenuItem;
    FiltCP1Btn: TButton;
    Filter1: TMenuItem;
    Label834: Label8;
    DMDCNomF: Text8Pt;
    PopupMenu7: TPopupMenu;
    Account1: TMenuItem;
    N4: TMenuItem;
    OSOrders1: TMenuItem;
    AllOrders1: TMenuItem;
    DeliveryNotes1: TMenuItem;
    N5: TMenuItem;
    NoFillter1: TMenuItem;
    CLStatPanel: TSBSPanel;
    CLStatLab: TSBSPanel;
    StkCCP1Btn: TButton;
    TeleSCP1Btn: TButton;
    StockAnalysis1: TMenuItem;
    TeleSales1: TMenuItem;
    Label852: Label8;
    AltCodeF: Text8Pt;
    EMailF: Text8Pt;
    Label836: Label8;
    PostCF: Text8Pt;
    Bevel4: TBevel;
    Bevel3: TBevel;
    Bevel2: TBevel;
    ConsFLab: TLabel;
    ConsolOrd: TSBSComboBox;
    pnlSend: TSBSPanel;
    pnlBankDets: TSBSPanel;
    Label838: Label8;
    Label839: Label8;
    lblBankRef: Label8;
    lblPayMethod: Label8;
    BankAF: Text8Pt;
    BankSF: Text8Pt;
    BankRF: Text8Pt;
    RPayF: TSBSComboBox;
    DDModeF: TSBSComboBox;
    SBSPanel12: TSBSPanel;
    VATRNoF: Label8;
    VATNoF: Text8Pt;
    lblDefaultTaxCode: Label8;
    cbDefaultTaxCode: TSBSComboBox;
    StatementToLbl: Label8;
    StaF: Text8Pt;
    DCLocnF: Text8Pt;
    Label826: Label8;
    FrmDefF: TCurrencyEdit;
    FSetNamF: Text8Pt;
    DefUdF: TSBSUpDown;
    Label828: Label8;
    pnlCardDets: TSBSPanel;
    User14Lab: Label8;
    User11Lab: Label8;
    User15Lab: Label8;
    User12Lab: Label8;
    User13Lab: Label8;
    CCDNameF: Text8Pt;
    CCDCardNoF: Text8Pt;
    CCDIssF: Text8Pt;
    CCDSDateF: TEditDate;
    CCDEDateF: TEditDate;
    cbSendSta: TSBSComboBox;
    cbSendInv: TSBSComboBox;
    Label860: Label8;
    Label862: Label8;
    Label863: Label8;
    Label865: Label8;
    DeliveryTermsLabel: Label8;
    ModeOfTransportLabel: Label8;
    SBSPanel16: TSBSPanel;
    User1F: Text8Pt;
    User2F: Text8Pt;
    User3F: Text8Pt;
    User4F: Text8Pt;
    User1Lab: Label8;
    User2Lab: Label8;
    User3Lab: Label8;
    User4Lab: Label8;
    AutoCP1Btn: TButton;
    ShowAuto1: TMenuItem;
    TagNF: TCurrencyEdit;
    PopupMenu8: TPopupMenu;
    Unal1: TMenuItem;
    UnAl2: TMenuItem;
    CISCP1Btn: TButton;
    CISLedger1: TMenuItem;
    CustdbBtn1: TSBSButton;
    CustdbBtn2: TSBSButton;
    Custom1: TMenuItem;
    Custom2: TMenuItem;
    EntCustom1: TCustomisation;
    PopupMenu9: TPopupMenu;
    SCCIS1: TMenuItem;
    SC1: TMenuItem;
    ASC1: TMenuItem;
    CDEFFPanel: TSBSPanel;
    CDEFFLab: TSBSPanel;
    PopupMenu10: TPopupMenu;
    DelDisc1: TMenuItem;
    DelDisc2: TMenuItem;
    RetCP1Btn: TButton;
    Return1: TMenuItem;
    SortCP1Btn: TButton;
    SortViewPopupMenu: TPopupMenu;
    RefreshView1: TMenuItem;
    CloseView1: TMenuItem;
    MenuItem1: TMenuItem;
    SortViewOptions1: TMenuItem;
    N6: TMenuItem;
    Cancel1: TMenuItem;
    mbdFrame: TMultiBuyDiscountFrame;
    SortView1: TMenuItem;
    RefreshView2: TMenuItem;
    CloseView2: TMenuItem;
    N3: TMenuItem;
    SortViewOptions2: TMenuItem;
    emZipF: TSBSComboBox;
    mnuSwitchNotes: TPopupMenu;
    General1: TMenuItem;
    Dated1: TMenuItem;
    AuditHistory1: TMenuItem;
    SBSPanel17: TSBSPanel;
    Label830: Label8;
    CTrad1F: Text8Pt;
    CTrad2F: Text8Pt;
    User5F: Text8Pt;
    User6F: Text8Pt;
    User7F: Text8Pt;
    User8F: Text8Pt;
    User9F: Text8Pt;
    User10F: Text8Pt;
    User5Lab: Label8;
    User6Lab: Label8;
    User7Lab: Label8;
    User8Lab: Label8;
    User9Lab: Label8;
    User10Lab: Label8;
    CustdbBtn3: TSBSButton;
    CustdbBtn4: TSBSButton;
    CustdbBtn5: TSBSButton;
    CustdbBtn6: TSBSButton;
    Custom3: TMenuItem;
    Custom4: TMenuItem;
    Custom5: TMenuItem;
    Custom6: TMenuItem;
    pnlEbus: TSBSPanel;
    Label843: Label8;
    emWebPWrdF: Text8Pt;
    edtMandateID: Text8Pt;
    lblMandateId: Label8;
    edMandateDate: TEditDate;
    lblMandateDate: Label8;
    lblDirectDebit: Label8;
    DeptLbl: Label8;
    edtPostCode: Text8Pt;
    panOrderPayments: TSBSPanel;
    Label820: Label8;
    edtOrderPaymentsGLCode: Text8Pt;
    AcShortCodeTxt: TLabel;
    lstAddressCountry: TSBSComboBox;
    Label81: Label8;
    Label821: Label8;
    lstDeliveryCountry: TSBSComboBox;
    lblLine1: TLabel;
    lblLine2: TLabel;
    lblLine3: TLabel;
    lblLine4: TLabel;
    lblLine5: TLabel;
    Label1: TLabel;
    Label824: Label8;
    Label825: Label8;
    Label833: Label8;
    Bevel5: TBevel;
    lblDelLine1: TLabel;
    lblDelLine2: TLabel;
    lblDelLine3: TLabel;
    lblDelLine4: TLabel;
    lblDelLine5: TLabel;
    Label7: TLabel;
    Label88: Label8;
    btnPPDLedger: TButton;
    panPPDValueHed: TSBSPanel;
    panPPDExpiryHed: TSBSPanel;
    panPPDValue: TSBSPanel;
    panPPDExpiry: TSBSPanel;
    panPPD: TSBSPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cbPPDOptions: TSBSComboBox;
    cePPDPercent: TCurrencyEdit;
    cePPDDays: TCurrencyEdit;
    mnuoptPPDLedger: TMenuItem;
    DefaultDeliveryTerms: TSBSComboBox;
    DefaultModeOfTransport: TSBSComboBox;
    PStaF: TCheckBoxEx;
    AWOF: TCheckBoxEx;
    HOACF: TCheckBoxEx;
    chkAllowOrderPayments: TCheckBoxEx;
    chkECMember: TCheckBoxEx;
    chkDefaultToQR: TCheckBoxEx;
    emSendRF: TCheckBoxEx;
    emSendHF: TCheckBoxEx;
    emEbF: TCheckBoxEx;
    pnlAnonymisationStatus: TPanel;
    shpNotifyStatus: TShape;
    lblAnonStatus: TLabel;
    btnPIITree: TSBSButton;
    PIITree1: TMenuItem;
    WindowExport: TWindowExport;
    procedure FormCreate(Sender: TObject);

    procedure OkCP1BtnClick(Sender: TObject);
    procedure EditCP1BtnClick(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ACCodeFExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure DelCP1BtnClick(Sender: TObject);
    procedure PayTFExit(Sender: TObject);
    procedure InvTFExit(Sender: TObject);
    procedure DNomFExit(Sender: TObject);
    procedure CCFExit(Sender: TObject);
    procedure AreaFExit(Sender: TObject);
    procedure FindCP1BtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure AddCP3BtnClick(Sender: TObject);
    procedure DelCP3BtnClick(Sender: TObject);
    procedure GenCP3BtnClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure ViewCP1BtnClick(Sender: TObject);
    procedure CLORefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CLORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CLORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CurCP1BtnClick(Sender: TObject);
    procedure HldCP1BtnClick(Sender: TObject);
    procedure SN1Click(Sender: TObject);
    procedure CopyCP1BtnClick(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure JmpCp1BtnClick(Sender: TObject);
    procedure HistCP1BtnClick(Sender: TObject);
    procedure Bal1Click(Sender: TObject);
    procedure MACP1BtnClick(Sender: TObject);
    procedure LettrBtnClick(Sender: TObject);
    procedure AlCP1BtnClick(Sender: TObject);
    procedure SetCP1BtnClick(Sender: TObject);
    procedure ChkCP1BtnClick(Sender: TObject);
    procedure CFrom1Click(Sender: TObject);
    procedure CTo1Click(Sender: TObject);
    procedure CDSPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CDSLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CDSLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PrnCP1BtnClick(Sender: TObject);
    procedure StatCP1BtnClick(Sender: TObject);
    procedure HQ1Click(Sender: TObject);
    procedure DisCP1BtnClick(Sender: TObject);
    procedure Addr1FKeyPress(Sender: TObject; var Key: Char);
    procedure DAddr1FKeyPress(Sender: TObject; var Key: Char);
    procedure FiltCP1BtnClick(Sender: TObject);
    procedure FrmDefFChange(Sender: TObject);
    procedure DefUdFMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DCLocnFExit(Sender: TObject);
    procedure DDModeFEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Account1Click(Sender: TObject);
    procedure StkCCP1BtnClick(Sender: TObject);
    procedure emWebPWrdFEnter(Sender: TObject);
    procedure VATNoFExit(Sender: TObject);
    procedure DefaultDeliveryTermsExit(Sender: TObject);
    procedure DefaultModeOfTransportExit(Sender: TObject);
    procedure emEbFClick(Sender: TObject);
    procedure User1FEntHookEvent(Sender: TObject);
    procedure User1FExit(Sender: TObject);
    procedure AutoCP1BtnClick(Sender: TObject);
    procedure emZipFClick(Sender: TObject);
    procedure RepFExit(Sender: TObject);
    procedure PostCFExit(Sender: TObject);
    procedure ACCodeFEnter(Sender: TObject);
    procedure UACP1BtnClick(Sender: TObject);
    procedure Unal1Click(Sender: TObject);
    procedure CISCP1BtnClick(Sender: TObject);
    procedure CustdbBtn1Click(Sender: TObject);
    procedure SCCIS1Click(Sender: TObject);
    procedure SC1Click(Sender: TObject);
    procedure DelDisc1Click(Sender: TObject);
    procedure PopupMenu4Popup(Sender: TObject);
    procedure RetCP1BtnClick(Sender: TObject);
    procedure RefreshView1Click(Sender: TObject);
    procedure CloseView1Click(Sender: TObject);
    procedure SortViewOptions1Click(Sender: TObject);
    procedure SortCP1BtnClick(Sender: TObject);
    procedure Label85Click(Sender: TObject);
    procedure General1Click(Sender: TObject);
    procedure Dated1Click(Sender: TObject);
    procedure AuditHistory1Click(Sender: TObject);
    //GS 24/10/2011 ABSEXCH-11706: function for loading UDEF settings
    procedure SetUDFields(AccountType  :  Char);
    procedure edtOrderPaymentsGLCodeExit(Sender: TObject);
    procedure chkAllowOrderPaymentsClick(Sender: TObject);
    procedure btnPPDLedgerClick(Sender: TObject);
    procedure cbPPDOptionsChange(Sender: TObject);
    procedure chkECMemberClick(Sender: TObject);
    procedure cbDefaultTaxCodeExit(Sender: TObject);
    procedure btnPIITreeClick(Sender: TObject);
    function WindowExportEnableExport: Boolean;
    procedure WindowExportExecuteCommand(const CommandID: Integer;
      const ProgressHWnd: HWND);
    function WindowExportGetExportDescription: String;
  private
    { Private declarations }

    bHelpContextInc, //NF: 11/04/06
    HideDAdd,
    SetUpOk,
    SDDMode,
    UpdateCS,
    ManUnal,
    CQBMode,
    InHBeen,
    StopPageChange,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    fFrmClosing,
    fFrmClosed,
    fDoingClose,
    StartThread,
    GotCoord,
    ListBusy,
    ViewNorm,
    UseOSNdx,
    FColorsChanged,

    CanJAP,
    CanCIS,
    InCISVch,
    {$IFDEF JAP}
      InSCLedger,
    {$ENDIF}

    CanDelete  :  Boolean;


    PanelIdx,
    Last_Page,
    LastBTag,
    SKeypath   :  Integer;

    PM9Cnt,
    LastHMode,
    ListOfSet  :  Byte;

    {$IFDEF NP}
      NotesCtrl  :  TNoteCtrl;
    {$ENDIF}

    {$IFDEF PF_On}
      {$IFDEF STK}
        QtyRec   :  TStkQtyRec;

        TeleSList:  Array[BOff..BOn] of Pointer;


      {$ENDIF}
    {$ENDIF}



    PageP,
    ScrollAP,
    ScrollBP,
    Misc1P     :  TPoint;

    PagePoint  :  Array[0..4] of TPoint;

    StartSize,
    InitSize   :  TPoint;


    MULCtrlO   :  Array[DiscPNo..RetPNo] of TCLMList;

    {$IFDEF STK}
      MULCtrlO2  :  Array[DiscPNo..DiscPNo] of TSNoList;
    {$ENDIF}

    InvBtnList :  TVisiBtns;

    DispOUPtr,
    DispTransPtr
               :  Pointer;

    {$IFDEF Ltr}
      LetterActive: Boolean;
      LetterForm:   TLettersList;
    {$ENDIF}

    //PR: 08/11/2010
    FSettings :IWindowSettings;

    // MH 01/03/2011 v6.7 ABSEXCH-10687: Added Trader Audit Trail
    TraderAudit : IBaseAudit;

    // CJS 18/03/2011 - ABSEXCH-9646
    // This has to be done as a pointer, because we cannot include the
    // ObjUnallocateF unit in the interface 'uses' clause, as it would result
    // in a circular reference. Instead, this is typecast to the correct class
    // when required.
    MatchingFrm : Pointer;

    { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
    UseDefaultSortView: Boolean;

    {$IFDEF CU}
    // 25/01/2013  PKR   ABSEXCH-13449/38
    // Used by the new Custom Button Handler.
    FormPurpose : TFormPurpose;
    RecordState : TRecordState;
    {$ENDIF}

    // CJS 2013-09-23 - MRD1.1.14 - added support for Consumers
    CustFormMode: Byte; // Internal flag for Customer/Consumer/Supplier type
    IsSales: Boolean; // True for Customers & Consumers, False for Suppliers

    // PKR 02/10/2013. - MRD 7.X Item 2.4 - Ledger Multi-Contacts
    rolesframe : TframeCustRoles;
    IsLedgerPageActivate : Boolean;
    FAnonymisationON: Boolean;
    FListScanningOn: Boolean;

    procedure SetFormCaption(IncludeTraderName: Boolean = True);

    function GetUserAccessCode(PageNo: Byte; ValidPages: TIntSet;
                               CustomerCodes, ConsumerCodes,
                               SupplierCodes: TAccessCodeList): Integer;

    procedure DefaultPageReSize;

    procedure NotePageReSize;

    procedure RolesPageReSize;

    {$IFDEF PF_On}
      {$IFDEF STK}
        procedure QBPageReSize;
      {$ENDIF}
    {$ENDIF}

    Procedure NoteUpdate;

    Procedure Link2Footer;

    Function ScanMode  :  Boolean;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;

    procedure LedgerBuildList(PageNo     :  Byte;
                              ShowLines  :  Boolean);
    {$IFDEF SOP}

      procedure OrdersBuildList(PageNo     :  Byte;
                                ShowLines  :  Boolean);

      //PR: 30/03/2009 Function to build list for multi-buy discounts
      procedure MultiBuyBuildList(PageNo     :  Byte;
                                  ShowLines  :  Boolean);

    {$ENDIF}

    {$IFDEF PF_On}
      {$IFDEF STK}
        procedure CDBuildList(PageNo     :  Byte;
                              ShowLines  :  Boolean);

        procedure RefreshValList(ShowLines,
                                 IgMsg      :  Boolean);

        procedure Display_QtyRec(Mode  :  Byte);

        procedure WOROrdersBuildList(PageNo     :  Byte;
                                     ShowLines  :  Boolean);

        {$IFDEF RET}
          procedure RetBuildList(PageNo     :  Byte;
                                 ShowLines  :  Boolean);
        {$ENDIF}

      {$ENDIF}

      {$IFDEF JAP}
        procedure JAppsBuildList(PageNo     :  Byte;
                                     ShowLines  :  Boolean);


      {$ENDIF}

    {$ENDIF}


    //PR: 12/12/2017 ABSEXCH-19451 Add AllowPostedEdit param
    procedure Display_Trans(Mode  :  Byte; const AllowPostedEdit : Boolean = False);

    Procedure SetButnPanelHeight(PNo  :  Integer);

    procedure FindLedItem(Sender: TObject);

    Procedure Allocate(AlMode  :  Byte);

    Function CheckListFinished  :  Boolean;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    procedure SetJAPOptions;

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;


    procedure ShowSortViewDlg;

    procedure SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);

    procedure LoadPPDOptionList;

    // PKR. 13/01/2016. ABSEXCH-17098. Intrastat field validation.
    function CountryIsECMemberState(aCountry : string) : Boolean;
    function ValidateECMemberField : Boolean;
    function DeliveryTermsFieldIsValid : Boolean;
    function ModeOfTransportFieldIsValid : Boolean;
    // SSK 27/10/2017 ABSEXCH-19386: Set Anonymisation Banner for Trader
    procedure SetAnonymisationBanner;
    procedure SetAnonymisationON(AValue: Boolean);
    //HV 12/11/2017 ABSEXCH-19549: Anonymised Notification banner in View/Edit Record > Banner not displayed on maximise and then Restore Down.
    procedure SetAnonymisationPanel;
    procedure SetAnonymisationStatusDate;
    //SSK 21/02/2018 2018 R1 ABSEXCH-19778: this will take care of caption for Anonymised and non-Anonymised Trader
    function GetCompanyDescription: string;
  public
    { Public declarations }

    InOSFilt,
    CanAllocate,
    SRCAlloc,
    RecordMode   :  Boolean;


    ExLocal      :  TdExLocal;

    SRCInv       :  InvRec;

    MatchFormPtr,
    HistFormPtr  :  Pointer;

    Function Current_BarPos(PageNo  :  Byte)  :  Integer;

    procedure RenamePanels(PageNo    :  Byte);

    procedure HidePanels(PageNo    :  Byte);

    Function SetDelBtn  :  Boolean;

    Function ChkPWord3(PageNo :  Integer;
                       Pages  :  TIntSet;
                       PWList :  TCustPW2) :  LongInt;

    Function SetPW3(E1,E2,E3,E4  :  LongInt)  :  TCustPw2;

    Function ChkPWord(PageNo :  Integer;
                      Pages  :  TIntSet;
                      HelpC,
                      HelpS  :  LongInt ):  LongInt;

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
                      Help8  :  LongInt) :  LongInt;

    procedure SetHelpContextIDsForPage(bInc : boolean); //NF:

    procedure PrimeButtons;



    procedure SetTabs2;

    procedure SetTabs;

    procedure BuildMenus;

    procedure FormDesign;

    procedure Find_LedgCoord(PageNo  :  Integer);
    procedure Store_LedgCoord(UpMode  :  Boolean);

    procedure Find_ValCoord(PageNo  :  Integer);
    procedure Store_ValCoord(UpMode  :  Boolean);

    procedure Find_FormCoord;
    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Function Current_Page  :  Integer;

    procedure OutAlloc;

    Procedure ManageSendInv(SetMode  :  Boolean;
                        Var InvMode  :  Byte);

    Function SetSendSta(OutMode  :  Boolean;
                        StaOpt   :  Integer)  :  Integer;

    Function SetSendInv(OutMode  :  Boolean;
                        StaOpt   :  Integer)  :  Integer;


    Procedure OutCust;
    Procedure Form2Cust;

    Procedure SetFieldFocus;

    Procedure ChangePage(NewPage  :  Integer);

    Function CheckNeedStore  :  Boolean;

    Function ConfirmQuit  :  Boolean;

    procedure ShowLink;

    procedure ExecuteLFilter(Sender  : TObject;
                             PageNo,
                             BTagNo  :  Integer);


    Function Auto_GetCCode(CCode    :  Str10;
                           Fnum,
                           Keypath  :  Integer)  :  Str10;

    procedure SetCustStore(EnabFlag,
                           ButnFlg  :  Boolean);

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure ProcessCust(Fnum,
                          KeyPAth    :  Integer;
                          Edit       :  Boolean;
                          IsCust     :  Boolean);


    Function SRCTol  :  Double;

    Function Within_SRCTol:  Boolean;

    Function AllocateOk(ShowMsg  :  Boolean)  :  Boolean;

    // MH 26/06/2015 v7.0.14 ABSEXCH-16600: Added validation of PPD Percentage and Days
    Function CheckCompleted(Const Edit : Boolean; Var SetFocusOnError : Boolean)  : Boolean;

    // CJS 2013-09-27 - MRD1.1.14 - Trader List - Consumers Record -
    // removed redundant 'IsCust' parameter
    procedure StoreCust(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);


    procedure EditAccount(Edit  :  Boolean);

    procedure DeleteAccount;

    procedure DeleteDoc;

    procedure SetFieldProperties;

    procedure SetFormProperties;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure SetAllocBtns;

    procedure Display_History(HistMode     :  Byte;
                              ChangeFocus  :  Boolean);

    procedure Display_Match(ChangeFocus,
                            MatchMode     :  Boolean);

    // CJS 18/03/2011 - ABSEXCH-9646
    procedure Show_Matching(ChangeFocus: Boolean);

    procedure UseAllocWiz;

    procedure Block_Unalocate;

    procedure Give_UnalOptions;

    // SSK 22/10/2017 ABSEXCH-19386: set anonymisation mode
    property AnonymisationON: Boolean read FAnonymisationON write SetAnonymisationON;
    property ListScanningOn: Boolean read FListScanningOn write FListScanningOn;

    //PR: 12/02/2013 ABSEXCH-13752 v7.0.2 Add procedure to call hook points 161-164 on allocation of transaction
    {$IFDEF CU}
    procedure TriggerAllocatedHook(UnAllocate : Boolean);
    {$ENDIF}
  end;

Procedure Set_CustFormMode(State  :  Byte);


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

  SBSCOmp,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}
  VarRec2U,
  ComnUnit,
  ComnU2,
  CurrncyU,

  SysU1,
  SysU3,

  InvListU,

  {$IFDEF GF}
    FindCtlU,
  {$ENDIF}

  {$IFDEF PF_On}

    {$IFDEF STK}
      DiscU4U,
      SalTxl2U,
      CuStkA2U,
      CuStkA4U,
      CuStkL1U,

      DelQDiscU,

      {$IFDEF RET}
        RetWiz1U,
        RetSup1U,
      {$ENDIF}

    {$ENDIF}

  {$ENDIF}

  {$IFDEF MC_On}
    LedCuU,
  {$ENDIF}


  InvFSu3U,
  SalTxl1U,
  NoteSupU,

  GenWarnU,
  {$IFDEF NOM}
    HistWinU,
  {$ENDIF}

  LedgSupU,

  ConvDocU,
  Tranl1U,
  SysU2,
  MatchU,

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  {$IFDEF POST}
    PostingU,

    PostSp2U,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,
  {$ENDIF}

  AllcWizU,
  LedgSu2U,
  //ObjUnalU,
  ObjUnallocateF,

  {$IFDEF VAT}
    GIRateU,
  {$ENDIF}

  {$IFDEF HM}
    //CustTest,
  {$ENDIF}

  {$IFDEF JC}
    JChkUseU,
    CISVch1U,

    {$IFDEF JAP}
      {$IFNDEF SOPDLL} // HM 07/12/04: Added for PR / EntDllSP.Dll
        JASCLnkU,
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF SY}
    AUWarnU,
  {$ENDIF}

  SortViewOptionsF,

  ThemeFix,

  UA_Const,

  SavePos,

  PWarnU,
  ExThrd2U,
  Crypto,
  SetCtrlU,
  //PR: 18/10/2011
  AuditNotes,
  //GS 24/10/2011 ABSEXCH-11706: access to the new user defined fields interface
  CustomFieldsIntF,

  //PR: 25/07/2103 SEPA changes
  EncryptionUtils,

  // CJS 2013-09-23 - MRD1.1.14 - added support for Consumers
  ConsumerUtils,

  // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  CountryCodes, CountryCodeUtils,

  {$IFDEF SOP}
    PasswordAuthorisationF,
  {$ENDIF SOP}

  //PR: 14/02/2014 ABSEXCH-15038
  ContactsManager,

  // MH 12/05/2015 v7.0.14 ABSEXCH-16284: Added PPD Ledger
  PPDLedgerF,
  GDPRConst,
  //PR: 14/07/2015 ABSEXCH-16660
  APIUtil, PromptPaymentDiscountFuncs,
  //HV 29/03/2016 2016-R2 ABSEXCH-14347: Currently System doesn't 'Calculate Oldest Debt when leaving Ledger'
  SQL_CheckAllAccounts,SQLRep_Config,
  MiscU,
  //RB 22/12/2017 2018-R1 ABSEXCH-19510: GDPR (POST 19346) - 6.3.1 -Trader Open/Close behaviour - Anonymisation diary section.
  oAnonymisationDiaryObjIntf,
  oAnonymisationDiaryObjDetail,
  oAnonymisationDiaryBtrieveFile,

  PIITreeF,
  PIIScannerIntf;


{$R *.DFM}

Var
  // See Set_CustFormMode()
  TemporaryCustFormMode: Byte;


{
  Sets the Trader type for the form, to allow this to be set before the form
  is actually created.

    0: Customer (ConsumerUtils.CUSTOMER_TYPE)
    1: Consumer (ConsumerUtils.CONSUMER_TYPE)
    2: Supplier (ConsumerUtils.SUPPLIER_TYPE)

}
Procedure Set_CustFormMode(State  :  Byte);
Begin
  If (State <> TemporaryCustFormMode) then
    TemporaryCustFormMode := State;
end;

{
  Builds and applies the form caption, based on the current Trader type, and
  optionally including the Trader Code and Name from the current record in
  Cust (IncludeTraderName defaults to True).
}

//SSK 21/02/2018 2018 R1 ABSEXCH-19778: this will take care of caption for Anonymised and non-Anonymised Trader
function TCustRec3.GetCompanyDescription: string;
begin
  if GDPROn and FAnonymisationON and (ExLocal.LCust.acAnonymisationStatus = asAnonymised) then
    Result := capAnonymised
  else
    Result := ExLocal.LCust.Company;
end;

procedure TCustRec3.SetFormCaption(IncludeTraderName: Boolean);
var
  lTraderName: String;
begin
  Caption := TraderTypeNameFromSubType(SubTypeFromTraderType(CustFormMode)) + ' Record';
  if IncludeTraderName then
  begin
    if (CustFormMode = CONSUMER_TYPE) then
      Caption := Caption + ' - ' + dbFormatName(ExLocal.LCust.AcLongAcCode, GetCompanyDescription)
    else
      Caption := Caption + ' - ' + dbFormatName(ExLocal.LCust.CustCode, GetCompanyDescription);
  end;
end;

{
  Returns the page number of the currently active page. Returns 0 if there
  is no active page.
}
Function TCustRec3.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PAgeControl1);

end;



procedure TCustRec3.Find_LedgCoord(PageNo  :  Integer);
Begin
  if Assigned(FSettings) and Assigned(MULCtrlO[PageNo]) then
    FSettings.SettingsToParent(MULCtrlO[PageNo]);
end;


procedure TCustRec3.Store_LedgCoord(UpMode  :  Boolean);
Var
  n       :  Byte;
Begin
  if Assigned(FSettings) then
    for n:=Low(MULCtrlO) to High(MULCtrlO) do
      if Assigned(MulCtrlO[n]) then
        FSettings.ParentToSettings(MULCtrlO[n], MULCtrlO[n]);
end;


procedure TCustRec3.Find_ValCoord(PageNo  :  Integer);
Begin
  {$IFDEF STK}
  if Assigned(FSettings) and Assigned(MULCtrlO2[PageNo]) then
    FSettings.SettingsToParent(MULCtrlO2[PageNo]);
  {$ENDIF}
end;


procedure TCustRec3.Store_ValCoord(UpMode  :  Boolean);
Var
  n       :  Byte;
Begin
  {$IFDEF STK}
  if Assigned(FSettings) then
    for n:=Low(MULCtrlO2) to High(MULCtrlO2) do
      if Assigned(MulCtrlO2[n]) then
        FSettings.ParentToSettings(MULCtrlO2[n], MULCtrlO2[n]);
  {$ENDIF}
end;

Procedure  TCustRec3.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TCustRec3.Find_FormCoord;
Begin
  if Assigned(FSettings) and not FSettings.UseDefaults then
  begin
    FSettings.SettingsToWindow(Self);
    FSettings.SettingsToParent(MainPage); //Main
    FSettings.SettingsToParent(DefaultsPage); //Defaults
    FSettings.SettingsToParent(eCommPage);  //eComm
    if Assigned(rolesFrame) then
    begin
      FSettings.SettingsToParent(RolesPage);  // Roles
      rolesFrame.CalcRoleBoxSize;
    end;
  end;

  StartSize.X:=Width; StartSize.Y:=Height;
end;

procedure TCustRec3.Store_FormCoord(UpMode  :  Boolean);
Begin
  Store_LedgCoord(UpMode); //Ledger & Orders
  Store_ValCoord(UpMode); //Discounts(!)
  if Assigned(FSettings) then
  begin
    //HV 05/12/2017 ABSEXCH-19535: Anonymised Trader > The height of the window gets increased if "Save coordinates" is ticked
    if pnlAnonymisationStatus.Visible then
      Self.ClientHeight := Self.ClientHeight - pnlAnonymisationStatus.Height;
    FSettings.WindowToSettings(Self);
    FSettings.ParentToSettings(MainPage, ACCodeF); //Main
    FSettings.ParentToSettings(DefaultsPage, ACCodeF); //Defaults
    FSettings.ParentToSettings(eCommPage, ACCodeF);  //eComm
    if Assigned(rolesFrame) then
    begin
      FSettings.ParentToSettings(RolesPage, ACCodeF); // Roles
    end;

    if Assigned(NotesCtrl) then
      FSettings.ParentToSettings(NotesCtrl.MULCtrlO, NotesCtrl.MULCtrlO); //Notes
    FSettings.SaveSettings(StoreCoord);
    FSettings := nil;
  end;
end;


procedure TCustRec3.FormSetOfSet;


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

  PagePoint[1].X:=PageControl1.Width-(TCDScrollBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(TCDScrollBox.Height);

  PagePoint[2].X:=CLSBox.Height-CLORefPanel.Height;
  PagePoint[2].Y:=PageControl1.Height-(CListBtnPanel.Height);

  PagePoint[3].X:=PageControl1.Width-(TCNScrollBox.Width);
  PagePoint[3].Y:=PageControl1.Height-(TCNScrollBox.Height);

  PagePoint[4].X:=TCNScrollBox.ClientHeight-(TCNListBtnPanel.Height);

  GotCoord:=BOn;

end;


Function TCustRec3.SetDelBtn  :  Boolean;

Begin
  Result:=(CanDelete or (Current_Page >=NotesPNo)) and (Not ExLocal.InAddEdit);
end;



Function TCustRec3.ChkPWord3(PageNo :  Integer;
                             Pages  :  TIntSet;
                             PWList :  TCustPW2) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    If (PageNo=DiscPNo) or (PageNo=MultiBuyPNo) then
      Result:=PWList[RecordMode,2]
    else
      Result:=PWList[RecordMode,1];
  end
  else
    Result:=-255;

end;

Function TCustRec3.SetPW3(E1,E2,E3,E4  :  LongInt)  :  TCustPw2;


Begin
  Result[BOff,1]:=E1; Result[BOff,2]:=E2;
  Result[BOn,1]:=E3; Result[BOn,2]:=E4;
end;

Function TCustRec3.ChkPWord(PageNo :  Integer;
                            Pages  :  TIntSet;
                            HelpC,
                            HelpS  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    If (RecordMode) then
      Result:=HelpC
    else
      Result:=HelpS;
  end
  else
    Result:=-255;

end;


Function TCustRec3.SetHelpC(PageNo :  Integer;
                            Pages  :  TIntSet;
                            Help0,
                            Help1,
                            Help2,
                            Help3,
                            Help4,
                            Help5,
                            Help6,
                            Help7,
                            Help8  :  LongInt) :  LongInt;

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
    Else
      Result:=-1;
    end; {Case..}
  end
  else
    Result:=-1;
end;


procedure TCustRec3.SetHelpContextIDsForPage(bInc : boolean); //NF: 16/04/06
const
  TAB_MAIN = 0;
  TAB_DEFAULTS = 1;
  TAB_ECOMMS = 2;
  TAB_NOT_USED = 3;
  TAB_NOTES = 4;
  TAB_DISCOUNTS = 5;
  TAB_LEDGER = 6;
  TAB_ORDERS = 7;
  TAB_WORKS_ORDERS = 8;
  TAB_JOB_APPLICATIONS = 9;
  TAB_RETURNS = 10;
  
var
  iOffSet : integer;
  bCustomer : boolean;

  procedure IncHelpContextIDs(iInc : integer; TheControl : TControl);
  var
    iPos : integer;

    procedure SetContextID(AControl : TControl; iNewID : integer);
    begin{SetContextID}
      // Exceptions
      if AControl is TTabSheet then exit;
//      if AControl.Name = 'OkCP1Btn' then exit; // NF: 09/05/06
//      if AControl.Name = 'CanCP1Btn' then exit; // NF: 09/05/06
      if AControl.Name = 'ClsCP1Btn' then exit;

      // Set Context ID
      if AControl.HelpContext > 0
      then AControl.HelpContext := iNewID;
    end;{SetContextID}

  begin{IncHelpContextIDs}
    // Inc the control's Context ID
    SetContextID(TheControl, TheControl.HelpContext + iInc);

    // Inc the Context IDs of the controls in the control
    For iPos := 0 to Thecontrol.ComponentCount -1 do
    begin
      if Thecontrol.Components[iPos] is TControl
      and (not (Thecontrol.Components[iPos] is TForm))  // NF: 08/05/06 - Fixed so that it does not itterate through other Forms
      then IncHelpContextIDs(iInc, TControl(TheControl.Components[iPos]));
    end;{for}
  end;{IncHelpContextIDs}

begin
   bCustomer := RecordMode;
  {$IFDEF LTE}
    if (not bHelpContextInc) and (not bInc) then exit;

    if bCustomer then iOffSet := 0
    else begin
      if bInc then
      begin
        iOffSet := 5000;
        bHelpContextInc := TRUE;
      end else
      begin
        iOffSet := -5000;
        bHelpContextInc := FALSE;
      end;{if}
    end;{if}

    // Set Correct Tab IDs
    if (bInc) then
    begin
      case PageControl1.ActivePage.PageIndex of
        TAB_MAIN : begin
          if bCustomer then PageControl1.ActivePage.HelpContext := 16
          else PageControl1.ActivePage.HelpContext := 85;
          TPrTO.HelpContext := 98;
          TYTDTO.HelpContext := 98;
          LYTDTO.HelpContext := 98;
          CurrBalF.HelpContext := 98;
          CommitLF.HelpContext := 2093; // NF: 25/07/06
        end;
        TAB_DEFAULTS : begin
          if bCustomer then PageControl1.ActivePage.HelpContext := 555
          else PageControl1.ActivePage.HelpContext := 1677;
          AltCode2F.HelpContext := 1159;
        end;
        TAB_ECOMMS : begin
          if bCustomer then PageControl1.ActivePage.HelpContext := 1693
          else PageControl1.ActivePage.HelpContext := 1678;
          AltCode3F.HelpContext := 1159;
        end;
        TAB_NOTES : begin
          if bCustomer then PageControl1.ActivePage.HelpContext := 66
          else PageControl1.ActivePage.HelpContext := 1679;
        end;
        TAB_DISCOUNTS : begin
          if bCustomer then PageControl1.ActivePage.HelpContext := 67
          else PageControl1.ActivePage.HelpContext := 1680;
        end;
        TAB_LEDGER : begin
          if bCustomer then PageControl1.ActivePage.HelpContext := 69
          else PageControl1.ActivePage.HelpContext := 1681;

          // CLORefPanel.HelpContext := 142;
          CLORefPanel.HelpContext := 2073; // NF: 25/07/06

          CLDatePanel.HelpContext := 143;
          CLAMTPanel.HelpContext := 144;
          CLOSPAnel.HelpContext := 145;
          CLTotPanel.HelpContext := 146;
          CLOrigPanel.HelpContext := 147;
          CLYRefPanel.HelpContext := 148;
          CLDuePanel.HelpContext := 149;
        end;
        TAB_ORDERS : begin
          if bCustomer then PageControl1.ActivePage.HelpContext := 70
          else PageControl1.ActivePage.HelpContext := 1682;
        end;
        TAB_WORKS_ORDERS : begin
          if bCustomer then PageControl1.ActivePage.HelpContext := 133
          else PageControl1.ActivePage.HelpContext := 1683;
        end;
        TAB_JOB_APPLICATIONS : begin
          if bCustomer then PageControl1.ActivePage.HelpContext := 1694
          else PageControl1.ActivePage.HelpContext := 1684;
        end;
        TAB_RETURNS : begin
          if bCustomer then PageControl1.ActivePage.HelpContext := 1695
          else PageControl1.ActivePage.HelpContext := 1685;
        end;
      end;{case}
    end;{if}

    // NF: 16/05/06 Fixes for incorrect Context ID
    OkCP1Btn.HelpContext := 1708;
    CanCP1Btn.HelpContext := 1709;
    DAddr1F.HelpContext := 1811;
    DAddr2F.HelpContext := DAddr1F.HelpContext;
    DAddr3F.HelpContext := DAddr1F.HelpContext;
    DAddr4F.HelpContext := DAddr1F.HelpContext;
    DAddr5F.HelpContext := DAddr1F.HelpContext;
    { CJS 2013-08-08 - MRD2.5 - Delivery PostCode }
    edtPostCode.HelpContext := DAddr1F.HelpContext;
    DDModeF.HelpContext :=  1812;

    if (iOffSet <> 0) then IncHelpContextIDs(iOffSet, Self);

    HelpContext := PageControl1.ActivePage.HelpContext;
    PageControl1.HelpContext := PageControl1.ActivePage.HelpContext;
  {$ELSE}
    // Exchequer
    // NF: 16/05/06 Fixes for incorrect Context IDs

    if bCustomer then iOffSet := 0
    else iOffSet := 5000;

    OkCP1Btn.HelpContext := 1708 + iOffSet;
    CanCP1Btn.HelpContext := 1709 + iOffSet;
    DAddr1F.HelpContext := 1811 + iOffSet;
    DAddr2F.HelpContext := DAddr1F.HelpContext;
    DAddr3F.HelpContext := DAddr1F.HelpContext;
    DAddr4F.HelpContext := DAddr1F.HelpContext;
    DAddr5F.HelpContext := DAddr1F.HelpContext;
    { CJS 2013-08-08 - MRD2.5 - Delivery PostCode }
    edtPostCode.HelpContext := DAddr1F.HelpContext;
    DDModeF.HelpContext :=  1812 + iOffSet;
  {$ENDIF}
end;

// CJS 2013-09-24 - MRD1.1.14 - Amendments for Consumers
{
  Returns the User Access Code for the specified tab page, based on the current
  form type (Customer, Consumer, or Supplier)

  Parameters:
    PageNo        = current tab page index
    ValidPages    = set of page indexes that are valid for this option
    CustomerCodes = array of Main Code, Discount Code, Ledger Code, Orders Code, Jobs Code, and Returns Code, with -255 for invalid options
    ConsumerCodes = array of Main Code, Discount Code, Ledger Code, Orders Code, Jobs Code, and Returns Code, with -255 for invalid options
    SupplierCodes = array of Main Code, Discount Code, Ledger Code, Orders Code, Jobs Code, and Returns Code, with -255 for invalid options
}
function TCustRec3.GetUserAccessCode(PageNo: Byte; ValidPages: TIntSet;
                                     CustomerCodes, ConsumerCodes,
                                     SupplierCodes: TAccessCodeList): Integer;
var
  Entry: Integer;
begin
  Result := -255;
  Entry := 0;
  if (PageNo in ValidPages) then
  begin

    if (PageNo in MAIN_PAGES) then
      Entry := 0
    else if (PageNo in DISCOUNT_PAGES) then
      Entry := 1
    else if (PageNo in LEDGER_PAGES) then
      Entry := 2
    else if (PageNo in ORDERS_PAGES) then
      Entry := 3
    else if (PageNo in JOB_PAGES) then
      Entry := 4
    else if (PageNo in RETURNS_PAGES) then
      Entry := 5
    else if (PageNo in ROLES_PAGES) then
      Entry := 6;

    case CustFormMode of
      CUSTOMER_TYPE: Result := CustomerCodes[Entry];
      CONSUMER_TYPE: Result := ConsumerCodes[Entry];
      SUPPLIER_TYPE: Result := SupplierCodes[Entry];
    end;

  end;
end;

procedure TCustRec3.PrimeButtons;
const
  CustomButtonStart = 31;
Var
  P4Blk       :  Boolean;
  n,
  PageNo      :  Integer;
  TheCaption  :  ShortString;
{$IFDEF CU}
  // 25/01/2013 PKR ABSEXCH-13449
  cBtnIsEnabled : Boolean;
  TextID        : integer;
{$ENDIF}

  // CJS 2013-09-24 - MRD1.1.14 - Amendments for Consumers
  {
    Returns the supplied list of access codes as an array (this is so that they
    can be passed to the GetUserAccessCode() method as a single array).
  }
  function CodeList(MainCode, DiscountsCode, LedgerCode, OrdersCode, JobsCode, ReturnsCode, RolesCode: Integer): TAccessCodeList;
  begin
    Result[0] := MainCode;
    Result[1] := DiscountsCode;
    Result[2] := LedgerCode;
    Result[3] := OrdersCode;
    Result[4] := JobsCode;
    Result[5] := ReturnsCode;
    // PKR. 19/02/2014.  ABSEXCH-15059.  Added support for Roles tab.
    Result[6] := RolesCode;
  end;

Begin
  TheCaption:='';

  PageNo:=Current_Page;

  If (InvBtnList=nil) then
  Begin
    InvBtnList:=TVisiBtns.Create;

    try

      With InvBtnList do
      Begin
        PresEnab:=BOff;

      {0} AddVisiRec(AddCP1Btn,BOff);
      {1} AddVisiRec(EditCP1Btn,BOff);
      {2} AddVisiRec(InsCP3Btn,BOff);
      {3} AddVisiRec(DelCP1Btn,BOff);
      {4} AddVisiRec(FindCP1Btn,BOff);
      {5} AddVisiRec(SortCP1Btn,BOff);
      {6} AddVisiRec(HistCP1Btn,BOff);
      {7} AddVisiRec(GenCP3Btn,BOff);

     //PR: 06/05/2015 ABSEXCH-16284 T2-122 Add PPD Ledger button and renumber references to later buttons
      {8}  AddVisiRec(btnPPDLedger, False);
      {9} AddVisiRec(ALCP1Btn,BOff);
     {10} AddVisiRec(PACP1Btn,BOff);
     {11} AddVisiRec(UACP1Btn,BOff);
     {12} AddVisiRec(LettrBtn,BOff);
     {13} AddVisiRec(PrnCP1Btn,BOff);
     {14} AddVisiRec(HldCP1Btn,BOff);
     {15} AddVisiRec(MACP1Btn,BOff);
     {16} AddVisiRec(JmpCP1Btn,BOff);
     {17} AddVisiRec(ViewCP1Btn,BOff);
     {18} AddVisiRec(CopyCP1Btn,BOff);
     {19} AddVisiRec(SetCP1Btn,BOff);
     {20} AddVisiRec(ChkCP1Btn,BOff);
     {21} AddVisiRec(StatCP1Btn,BOff);
     {22} AddVisiRec(DisCP1Btn,BOff);
     {23} AddVisiRec(CurCP1Btn,BOff);
     {24} AddVisiRec(FiltCP1Btn,BOff);
     {25} AddVisiRec(AutoCP1Btn,BOff);
     {26} AddVisiRec(StkCCP1Btn,BOff);
     {27} AddVisiRec(TeleSCP1Btn,BOff);

     {28} AddVisiRec(CISCP1Btn,BOff);
     {29} AddVisiRec(RETCP1Btn,BOff);
     {30} AddVisiRec(btnPIITree,BOff); //PR: 01/12/2017 ABSEXCH-19479

     {$IFDEF CU}
       {31}  AddVisiRec(CustdbBtn1,BOn);
       {32}  AddVisiRec(CustdbBtn2,BOn);
             // 17/01/2013 PKR ABSEXCH-13449
       {33}  AddVisiRec(CustdbBtn3,BOn);
       {34}  AddVisiRec(CustdbBtn4,BOn);
       {35}  AddVisiRec(CustdbBtn5,BOn);
       {36}  AddVisiRec(CustdbBtn6,BOn);
     {$ENDIF}


      end; {With..}
    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  try

    // CJS 2013-09-24 - MRD1.1.14 - Amendments for Consumers -- amended most of
    // the PWSetHideBtn() calls to accommodate Consumer access-rights codes.

    With InvBtnList do
    Begin
      SetHelpContextIDsForPage(FALSE); //NF: 11/04/06

      PresEnab:=(ExLocal.InAddEdit);

      P4Blk:=((PageNo=LedgerPNo) and (Not Show_CMG(DocSplit[IsSales,1])));

      // PKR. 19/02/2014.  ABSEXCH-15059.  Added Roles tab code to all calls to CodeList.
      PWSetHideBtn(0, // Add Account or Discount
                    (PageNo In [LedgerPNo, OrdersPNo, WOROrdersPNo, JAppsPNo, RetPNo]) or
                    ((PageNo In MAIN_PAGES) and Syss.ExternCust and IsSales) or
                    (ICEDFM=2),
                    BOff,
                    GetUserAccessCode(PageNo, MAIN_PAGES + DISCOUNT_PAGES + ROLES_PAGES,
                                      CodeList(uaAddCustomer, uaAddCustomerDiscount, -255, -255, -255, -255, uaEditCustomerRoles),
                                      CodeList(uaAddConsumer, uaAddConsumerDiscount, -255, -255, -255, -255, -255),
                                      CodeList(uaAddSupplier, uaAddSupplierDiscount, -255, -255, -255, -255, uaEditSupplierRoles)
                                     )
                  );

      //PR: 18/03/2014 ABSEXCH-15166 Add add help context id for Roles tab
      SetBtnHelp(0, SetHelpC(PageNo, MAIN_PAGES + DISCOUNT_PAGES + ROLES_PAGES, 76, 76, 76, 8101, 88, 116, 8012, -1, -1));

      PWSetHideBtn(1, // Edit Account or Discount
                    ((PageNo in MAIN_PAGES) and Syss.ExternCust and IsSales),
                    BOff,
                    GetUserAccessCode(PageNo, MAIN_PAGES + DISCOUNT_PAGES + ROLES_PAGES,
                                      CodeList(uaEditCustomer, uaEditCustomerDiscount, -255, -255, -255, -255, uaEditCustomerRoles),
                                      CodeList(uaEditConsumer, uaEditConsumerDiscount, -255, -255, -255, -255, -255),
                                      CodeList(uaEditSupplier, uaEditSupplierDiscount, -255, -255, -255, -255, uaEditSupplierRoles)
                                     )
                  );

      //PR: 18/03/2014 ABSEXCH-15166 Add add help context id for Roles tab
      SetBtnHelp(1,SetHelpC(PageNo,[MainPno..OrdersPNo] + ROLES_PAGES,75,75,75,8101,87, 68, 8013, 26, 26));

      {$IFDEF SOP}
      if (PageNo = MultiBuyPNo) then
        mbdFrame.AllowEdit := EditCP1Btn.Enabled;
      {$ENDIF}

      SetHideBtn(2, // Insert Note
                  (PageNo<>NotesPNo),
                  BOff
                );

      // CJS 2014-01-28 - ABSEXCH-14967 - Delete button is erroneously available on the Ledger tab
      PWSetHideBtn(3, // Delete Account, Discount, or Job Application
                    (PageNo in LEDGER_PAGES + ORDERS_PAGES + RETURNS_PAGES),  // SSK 01/02/2017 2017-R1 ABSEXCH-18021: JOB_PAGES commented to display delete button on Job Applications tab
                    // ((PageNo in MAIN_PAGES) and Syss.ExternCust and IsSales),
                    BOff,
                    GetUserAccessCode(PageNo, MAIN_PAGES + DISCOUNT_PAGES + JOB_PAGES + ROLES_PAGES,
                                      CodeList(uaDeleteCustomer, uaDeleteCustomerDiscount, -255, -255,  uaDeleteJobSalesApplication, -255, uaEditCustomerRoles),
                                      CodeList(uaDeleteConsumer, uaDeleteConsumerDiscount, -255, -255, -255, -255, -255),
                                      CodeList(uaDeleteSupplier, uaDeleteSupplierDiscount, -255, -255,  uaDeleteJobPurchaseApplication, -255, uaEditSupplierRoles)
                                     )
                  );

      //PR: 18/03/2014 ABSEXCH-15166 Add add help context id for Roles tab
      SetBtnHelp(3,SetHelpC(PageNo,[MainPno..MultiBuyPNo] + ROLES_PAGES,77,77,77,8102,89,117,8014,-1,-1));

      PWSetHideBtn(4, // Find Account, Ledger, Order, Job Application, or Return
                    (PageNo in [NotesPNo, DiscPNo, MultiBuyPNo, RolesPNo]),
                    BOff,
                    GetUserAccessCode(PageNo, MAIN_PAGES,
                                      CodeList(uaFindCustomer, -255, -255, -255, -255, -255, -255),
                                      CodeList(uaFindConsumer, -255, -255, -255, -255, -255, -255),
                                      CodeList(uaFindSupplier, -255, -255, -255, -255, -255, -255)
                                     )
                  );
      SetBtnHelp(4,SetHelpC(PageNo,[MainPno..eCommPNo,LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo],72,72,72,-1,-1,-1,-1,27,27));

      // CJS 2014-01-28 - ABSEXCH-14967 - Sort View button ignores user access rights
      PWSetHideBtn(5, // Sort View (on Ledger)
                    (not(PageNo in LEDGER_PAGES)),
                    BOff,
                    GetUserAccessCode(PageNo, LEDGER_PAGES,
                                      CodeList(-255, -255,  uaAccessSortView, -255, -255, -255, -255),
                                      CodeList(-255, -255,  uaAccessSortView, -255, -255, -255, -255),
                                      CodeList(-255, -255,  uaAccessSortView, -255, -255, -255, -255)
                                     )
                  );

      PWSetHideBtn(6, // View History
                    (Not (PageNo In MAIN_PAGES)),
                    BOff,
                    GetUserAccessCode(PageNo, MAIN_PAGES,
                                      CodeList(uaCustomerViewHistory, -255, -255, -255, -255, -255, -255),
                                      CodeList(uaConsumerViewHistory, -255, -255, -255, -255, -255, -255),
                                      CodeList(uaSupplierViewHistory, -255, -255, -255, -255, -255, -255)
                                     )
                  );

      SetHideBtn(7, // Switch View
                  ((Not (PageNo In [NotesPNo,LedgerPNo])) and (Not P4Blk)),
                  BOff
                );
      SetBtnHelp(7,SetHelpC(PageNo,[NotesPNo,LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo],-1,-1,-1,-1,90,0,-1,134,134));

      //PR: 06/05/2015 ABSEXCH-16284 T2-122 Set PPD Ledger button visibility
      SetHideBtn(8, (PageNo <> LedgerPNo) or (ExLocal.LCust.acPPDMode = pmPPDDisabled) or not CanAllocate , False);

      //PR: 27/05/2015 ABSEXCH-16445 PPD Ledger button should check Allocate permission
      PWSetHideBtn(8, // Allocate
                    ((PageNo <> LedgerPNo) or (ExLocal.LCust.acPPDMode = pmPPDDisabled) or not CanAllocate),
                    BOff,
                    GetUserAccessCode(PageNo, LEDGER_PAGES,
                                      CodeList(-255, -255, uaCustomerAllocate, -255, -255, -255, -255),
                                      CodeList(-255, -255, uaConsumerAllocate, -255, -255, -255, -255),
                                      CodeList(-255, -255, uaSupplierAllocate, -255, -255, -255, -255)
                                     )
                  );

      SetHideBtn(9,((PageNo<>LedgerPNo) or (Not CanAllocate)),BOff);

      PWSetHideBtn(9, // Allocate
                    ((PageNo<>LedgerPNo) or (Not CanAllocate)),
                    BOff,
                    GetUserAccessCode(PageNo, LEDGER_PAGES,
                                      CodeList(-255, -255, uaCustomerAllocate, -255, -255, -255, -255),
                                      CodeList(-255, -255, uaConsumerAllocate, -255, -255, -255, -255),
                                      CodeList(-255, -255, uaSupplierAllocate, -255, -255, -255, -255)
                                     )
                  );



      SetHideBtn(10,(Not ALCP1Btn.Visible) or ((ChkAllowed_In(ChkPWord(PageNo,[LedgerPNo],411,414)) and (Not SBSIn)) and (Not SRCAlloc)) ,BOff);

      PWSetHideBtn(11, // Unallocate
                    ((PageNo <> LedgerPNo) or (not CanAllocate)),
                    BOff,
                    GetUserAccessCode(PageNo, LEDGER_PAGES,
                                      CodeList(-255, -255, uaCustomerUnallocTrans, -255, -255, -255, -255),
                                      CodeList(-255, -255, uaConsumerUnallocTrans, -255, -255, -255, -255),
                                      CodeList(-255, -255, uaSupplierUnallocTrans, -255, -255, -255, -255)
                    )
                  );

      PWSetHideBtn(12, // Letters & Links
                    (not (PageNo in MAIN_PAGES)),
                    BOff,
                    GetUserAccessCode(PageNo, MAIN_PAGES,
                                      // Note: Customers & Suppliers use the 'Print'
                                      // access code, as there doesn't appear to be
                                      // a code for Letters & Links
                                      CodeList(uaCustomerAccessLinks, -255, -255, -255, -255, -255, -255),
                                      CodeList(uaConsumerAccessLinks, -255, -255, -255, -255, -255, -255),
                                      CodeList(uaSupplierAccessLinks, -255, -255, -255, -255, -255, -255)
                    )
                  );

      // CJS 2014-01-21 - ABSEXCH-14969 - Output button missing from Trader records
      // CJS 2014-01-31 - ABSEXCH-14984 - Output button appearing on Roles tab
      PWSetHideBtn(13, // Print / Output
                    (PageNo in [RolesPNo, NotesPNo, DiscPNo, MultiBuyPNo]),
                    BOff,
                    GetUserAccessCode(PageNo, MAIN_PAGES,
                                      CodeList(uaPrintCustomer, -255, -255, -255, -255, -255, -255),
                                      CodeList(uaPrintConsumer, -255, -255, -255, -255, -255, -255),
                                      CodeList(uaPrintSupplier, -255, -255, -255, -255, -255, -255)
                    )
                  );
      SetBtnHelp(13,SetHelpC(PageNo,[MainPno..eCommPNo,LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo],82,82,82,-1,-1,-1,-1,31,31));

      PWSetHideBtn(14, // Hold
                    (Not (PageNo In [LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo])),
                    BOff,
                    GetUserAccessCode(PageNo, LEDGER_PAGES + ORDERS_PAGES + JOB_PAGES + RETURNS_PAGES,
                                      // This is the generic 'Hold' option, for Sales
                                      // or Purchases, so Consumers use the Sales
                                      // option.
                                      CodeList(-255, -255, 06, 06, 06, 06, -255),
                                      CodeList(-255, -255, 06, 06, 06, 06, -255),
                                      CodeList(-255, -255, 15, 15, 15, 15, -255)
                    )
                  );

      For n:=15 to 17 do
        SetHideBtn(n,(Not (PageNo In [LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo])),BOff);


      SetHideBtn(16,(Not (PageNo In [LedgerPNo])),BOff);

      // CJS 2014-01-28 - ABSEXCH-14967 - Ledger Copy button ignores user access rights
      PWSetHideBtn(18, // Copy
                    (not (PageNo in DISCOUNT_PAGES + LEDGER_PAGES + ORDERS_PAGES + JOB_PAGES) or (ICEDFM=2)),
                    BOff,
                    GetUserAccessCode(PageNo, DISCOUNT_PAGES + LEDGER_PAGES + ORDERS_PAGES + JOB_PAGES,
                                      CodeList(-255, uaCopyCustomerDiscount, uaCustomerCopyReverse, uaCustomerCopyReverse, -255, -255, -255),
                                      CodeList(-255, uaCopyConsumerDiscount, uaConsumerCopyReverse, uaConsumerCopyReverse, -255, -255, -255),
                                      CodeList(-255, uaCopySupplierDiscount, uaSupplierCopyReverse, uaSupplierCopyReverse, -255, -255, -255)
                                     )
                  );
      SetBtnHelp(18,SetHelpC(PageNo,[DiscPNo..WOROrdersPNo,JAppsPNo,MultiBuyPNo],-1,-1,-1,-1,-1,118,8015,28,28));

      PWSetHideBtn(19, // Settle
                    (Not ALCP1Btn.Visible),
                    BOff,
                    GetUserAccessCode(PageNo, LEDGER_PAGES,
                                      CodeList(-255, -255, uaCustomerSettle, -255, -255, -255, -255),
                                      CodeList(-255, -255, uaConsumerSettle, -255, -255, -255, -255),
                                      CodeList(-255, -255, uaSupplierSettle, -255, -255, -255, -255)
                                     )
                  );

      PWSetHideBtn(20, // Check
                    (not (PageNo in DISCOUNT_PAGES) ) or (ICEDFM<>0),
                    BOff,
                    GetUserAccessCode(PageNo, DISCOUNT_PAGES,
                                      CodeList(-255, uaCheckCustomerDiscounts, -255, -255, -255, -255, -255),
                                      CodeList(-255, uaCheckConsumerDiscounts, -255, -255, -255, -255, -255),
                                      CodeList(-255, uaCheckSupplierDiscounts, -255, -255, -255, -255, -255)
                                     )
                  );
      SetBtnHelp(20,SetHelpC(PageNo,[DiscPNo,MultiBuyPNo],-1,-1,-1,-1,-1,119,8016,-1,-1));

      PWSetHideBtn(21, // Status
                    (Not (PageNo In MAIN_PAGES)),
                    BOff,
                    GetUserAccessCode(PageNo, MAIN_PAGES,
                                      CodeList(uaCustomerStatus, -255, -255, -255, -255, -255, -255),
                                      CodeList(uaConsumerStatus, -255, -255, -255, -255, -255, -255),
                                      CodeList(uaSupplierStatus, -255, -255, -255, -255, -255, -255)
                                     )
                  );

      SetHideBtn(22,(PageNo<>LedgerPNo),BOff);

      {$IFDEF MC_On}
        SetHideBtn(23,(Not ViewCP1Btn.Visible) or (PageNo In [WOROrdersPNo,JAppsPNo]),BOff);
      {$ELSE}
        SetHideBtn(23,BOn,BOff);
      {$ENDIF}

      SetHideBtn(24,(PageNo<>LedgerPNo),BOn);

      PWSetHideBtn(25,(PageNo<>LedgerPNo) or (SRCAlloc) or (HideDAdd),BOff,94+Ord(Not IsSales));

      SetHideBtn(26,(Not (PageNo In [MainPno..eCommPNo])) or (Not AnalCuStk),BOff);

      PWSetHideBtn(28,(Not (PageNo In [MainPno..eCommPNo])) or (RecordMode) or (Not CISOn) ,BOff,249);

      PWSetHideBtn(29, // Return
                    (Not (PageNo In LEDGER_PAGES + RETURNS_PAGES)) or ((Not RecordMode) and (PageNo=RetPNo)) or (Not RetMOn),
                    BOff,
                    GetUserAccessCode(PageNo, LEDGER_PAGES + RETURNS_PAGES,
                                      CodeList(-255, -255, uaCustomerReturns, -255, -255, uaCustomerReturns, -255),
                                      CodeList(-255, -255, uaConsumerReturns, -255, -255, uaConsumerReturns, -255),
                                      CodeList(-255, -255, uaSupplierReturns, -255, -255, uaSupplierReturns, -255)
                                     )
                  );

      //PR: 01/12/2017 ABSEXCH-19427 PII Tree button
      //RB 07/12/2017 ABSEXCH-19538: User permission implementation related to Employee Status button and PII tree button in Entity Record window
      if IsSales then
        PWSetHideBtn(30,(Not GDPRON or Not (PageNo In [MainPno..eCommPNo])),BOff, uaAccessForCustomerConsumer)
      else
        PWSetHideBtn(30,(Not GDPRON or Not (PageNo In [MainPno..eCommPNo])),BOff, uaAccessForSupplier);

      {$IFDEF CU}
        // 25/01/2013 PKR ABSEXCH-13449
        // 6 Custom Buttons available.
        // Use the new custom button handler.  Set up some basic information.
        if IsSales then
          formPurpose := fpCustomerRecord
        else
          formPurpose := fpSupplierRecord;

        recordState := rsAny;

        // Enable/Disable the custom buttons
        //PR: 01/12/2017 ABSEXCH-19427 Renumbered Custom buttons and added constant to make adding future buttons easier
        cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustdbBtn1.Tag);
        SetHideBtn(CustomButtonStart, (not cBtnIsEnabled), BOff);

        cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustdbBtn2.Tag);
        SetHideBtn(CustomButtonStart + 1, (not cBtnIsEnabled), BOff);

        cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustdbBtn3.Tag);
        SetHideBtn(CustomButtonStart + 2, (not cBtnIsEnabled), BOff);

        cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustdbBtn4.Tag);
        SetHideBtn(CustomButtonStart + 3, (not cBtnIsEnabled), BOff);

        cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustdbBtn5.Tag);
        SetHideBtn(CustomButtonStart + 4, (not cBtnIsEnabled), BOff);

        cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustdbBtn6.Tag);
        SetHideBtn(CustomButtonStart + 5, (not cBtnIsEnabled), BOff);
      {$ENDIF}


      // MH 28/05/2015 v7.0.14: Moved check out of ShowLink for consistency
      //PWSetHideBtn(27,(Not (PageNo In [MainPno..eCommPNo])) or (Not RecordMode) or (Not TeleSModule) or (ExLocal.LCust.AccStatus>1),BOn,245);
      PWSetHideBtn(27,(Not (PageNo In [MainPno..eCommPNo])) or (Not RecordMode) or (Not TeleSModule) or (ExLocal.LCust.AccStatus=3),BOn,245);

      DelCP1Btn.Enabled:=SetDelBtn;


      {$IFDEF CU} {Set customised buttons caption}

        // 29/01/2013 PKR ABSEXCH-13449
        // 6 Custom Buttons available.
        // Use the new custom button handler.  Set up some basic information.
      If (CustdbBtn1.Visible) then
      Begin
        TheCaption:='';
        TextID := custBtnHandler.GetTextId(FormPurpose, PageNo, recordState, CustdbBtn1.Tag);
        EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn1.Font);
//        EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, 130-(10*Ord(RecordMode)), TheCaption, CustdbBtn1.Font);

        CustdbBtn1.Caption:=TheCaption;
      end;

      If (CustdbBtn2.Visible) then
      Begin
        TheCaption:='';
        TextID := custBtnHandler.GetTextId(FormPurpose, PageNo, recordState, CustdbBtn2.Tag);
        EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn2.Font);
//        EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, 131-(10*Ord(RecordMode)), TheCaption, CustdbBtn2.Font);

        CustdbBtn2.Caption:=TheCaption;
      end;

      //------------------------------------------------------------------------
      // 29/01/2013 PKR ABSEXCH-13449
      // Now have custom buttons 3..6
      If (CustdbBtn3.Visible) then
      Begin
        TheCaption:='';
        TextID := custBtnHandler.GetTextId(FormPurpose, PageNo, recordState, CustdbBtn3.Tag);
        EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn3.Font);
        CustdbBtn3.Caption:=TheCaption;
      end;

      If (CustdbBtn4.Visible) then
      Begin
        TheCaption:='';
        TextID := custBtnHandler.GetTextId(FormPurpose, PageNo, recordState, CustdbBtn4.Tag);
        EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn4.Font);
        CustdbBtn4.Caption:=TheCaption;
      end;

      If (CustdbBtn5.Visible) then
      Begin
        TheCaption:='';
        TextID := custBtnHandler.GetTextId(FormPurpose, PageNo, recordState, CustdbBtn5.Tag);
        EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn5.Font);
        CustdbBtn5.Caption:=TheCaption;
      end;

      If (CustdbBtn6.Visible) then
      Begin
        TheCaption:='';
        TextID := custBtnHandler.GetTextId(FormPurpose, PageNo, recordState, CustdbBtn6.Tag);
        EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn6.Font);
        CustdbBtn6.Caption:=TheCaption;
      end;
      //------------------------------------------------------------------------

    {$ENDIF}

    {$IFDEF SOP}
//     if PageNo = MultiBuyPNo then
//     mbdFrame.SetButtons(InvBtnList);
    {$ENDIF}

    // SSK 22/10/2017 ABSEXCH-19386: Disable the status button for all the tabs for anonymised trader
    if GDPROn then
    begin
      StatCP1Btn.Enabled := (Exlocal.LCust.acAnonymisationStatus <> asAnonymised) and StatCP1Btn.Enabled ;
      // SSK 04/12/2017 ABSEXCH-19536: Copy Button should be disabled from Trader's Ledgers other tabs
      CopyCP1Btn.Enabled := StatCP1Btn.Enabled;
      Copy1.Enabled := CopyCP1Btn.Enabled;
    end;

    SetHelpContextIDsForPage(TRUE); //NF: 11/04/06

    end;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

Function TCustRec3.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      DiscPNo  :  Result:=CDSBox.HorzScrollBar.Position;
      LedgerPNo:  Result:=CLSBox.HorzScrollBar.Position;
      OrdersPNo,
      WOROrdersPNo,
      JAppsPNo,
      RetPNo
               :  Result:=COSBox.HorzScrollBar.Position;

      else  Result:=0;
    end; {Case..}


end;



procedure TCustRec3.HidePanels(PageNo    :  Byte);
Var
  TmpBo : Boolean;
Begin
  Case PageNo of
    LedgerPNo
       :    With MULCtrlO[PageNo],VisiList do
            Begin
              fBarOfSet:=Current_BarPos(PageNo);

            {$IFNDEF MC_On}
              TmpBo:=BOn;
            {$ELSE}
              TmpBo:=BOff;
            {$ENDIF}

            SetHidePanel(5,(TmpBo and (DisplayMode=0)),BOn);

            //PR: 06/05/2015 ABSEXCH-16284 T2-120 Show/hide PPD columns according to whether account has PPD enabled
            SetHidePanel(9, ExLocal.LCust.acPPDMode = pmPPDDisabled, True);
            SetHidePanel(10, ExLocal.LCust.acPPDMode = pmPPDDisabled, True);
          end;

    OrdersPNo,
    WOROrdersPNo,
    JAppsPNo,
    RetPNo
       :  With MULCtrlO[PageNo],VisiList do
          Begin
            {SetHidePanel(FindxColOrder(3),(PageNo In [JAppsPNo]),BOff);}
            SetHidePanel(FindxColOrder(4),(PageNo In [WOROrdersPNo,JAppsPNo,RetPNo]),BOff);
            SetHidePanel(FindxColOrder(5),(PageNo In [WOROrdersPNo]),BOff);
            SetHidePanel(FindxColOrder(6),(PageNo In [WOROrdersPNo]),BOn);
          end;

  end; {Case..}
end;


procedure TCustRec3.RenamePanels(PageNo    :  Byte);
Begin
  Case PageNo of
    LedgerPNo
       :    With MULCtrlO[PageNo],VisiList do
            Begin
              Case DisplayMode of
                0  :  Begin
                        IdPanel(FindxColOrder(2),BOn).Caption:='Amount Settled';
                        IdPanel(FindxColOrder(3),BOn).Caption:='Outstanding';
                        IdPanel(FindxColOrder(4),BOn).Caption:='Total Value';
                        IdPanel(FindxColOrder(5),BOn).Caption:='Original Value';

                      end;

                6  :  Begin
                        IdPanel(FindxColOrder(2),BOn).Caption:='Total Value';
                        IdPanel(FindxColOrder(3),BOn).Caption:='Cost';
                        IdPanel(FindxColOrder(4),BOn).Caption:='Margin';
                        IdPanel(FindxColOrder(5),BOn).Caption:='GP%';
                      end;
              end; {Case..}

            end;
    OrdersPNo,
    WOROrdersPNo
       :    With MULCtrlO[PageNo],VisiList do
            Begin
              IdPanel(FindxColOrder(0),BOn).Caption:='OurRef';
              IdPanel(FindxColOrder(1),BOn).Caption:='Date';
              IdPanel(FindxColOrder(2),BOn).Caption:='Value';
              IdPanel(FindxColOrder(3),BOn).Caption:='%';
              IdPanel(FindxColOrder(4),BOn).Caption:='Status';
              IdPanel(FindxColOrder(5),BOn).Caption:='Margin';

              IdPanel(FindxColOrder(6),BOn).Caption:='Cost';
            end;

    {$IFDEF RET}
      RetPNo
         :    With MULCtrlO[PageNo],VisiList do
              Begin
                IdPanel(FindxColOrder(2),BOn).Caption:='O/S Value';
                IdPanel(FindxColOrder(3),BOn).Caption:='% Comp';
                IdPanel(FindxColOrder(5),BOn).Caption:='Ref';

                IdPanel(FindxColOrder(6),BOn).Caption:='Status';
              end;
    {$ENDIF}

    JAppsPNo
       :    With MULCtrlO[PageNo],VisiList do
            Begin
              Case DisplayMode of
                9  :  Begin
                        IdPanel(FindxColOrder(2),BOn).Caption:='Applied';
                        IdPanel(FindxColOrder(3),BOn).Caption:='JC';

                        IdPanel(FindxColOrder(5),BOn).Caption:='Certified';
                        IdPanel(FindxColOrder(6),BOn).Caption:='Status';

                      end;
              end; {Case..}

            end;
  end; {Case..}

end;

// CJS 2013-09-27 - MRD1.1.14 - Trader Record - amended to include Consumers
procedure TCustRec3.SetTabs2;
var
  LedgerAccessCode: Integer;
  DiscountAccessCode: Integer;
  ReturnsAccessCode: Integer;
  JobApplicationsAccessCode: Integer;
  OrdersAccessCode: Integer;
  NotesAccessCode: Integer;
Begin
  //PR: 24/03/2016 v2016 R2 ABSEXCH-17390 Unnecessary initialisation to remove warnings
  LedgerAccessCode := uaCustomerViewLedger;
  DiscountAccessCode := uaViewCustomerDiscounts;
  ReturnsAccessCode := uaCustomerReturns;
  JobApplicationsAccessCode := uaCustomerViewJobApplications;
  OrdersAccessCode := uaCustomerViewOrderLedger;
  NotesAccessCode := uaCustomerAccessNotes;

  case CustFormMode of
    CUSTOMER_TYPE:
      begin
        LedgerAccessCode := uaCustomerViewLedger;
        DiscountAccessCode := uaViewCustomerDiscounts;
        ReturnsAccessCode := uaCustomerReturns;
        JobApplicationsAccessCode := uaCustomerViewJobApplications;
        OrdersAccessCode := uaCustomerViewOrderLedger;
        NotesAccessCode := uaCustomerAccessNotes;
      end;
    CONSUMER_TYPE:
      begin
        LedgerAccessCode := uaConsumerViewLedger;
        DiscountAccessCode := uaViewConsumerDiscounts;
        ReturnsAccessCode := uaConsumerReturns;
        JobApplicationsAccessCode := uaNoAccess;
        OrdersAccessCode := uaConsumerViewOrderLedger;
        NotesAccessCode := uaConsumerAccessNotes;
      end;
    SUPPLIER_TYPE:
      begin
        LedgerAccessCode := uaSupplierViewLedger;
        DiscountAccessCode := uaViewSupplierDiscounts;
        ReturnsAccessCode := uaSupplierReturns;
        JobApplicationsAccessCode := uaSupplierViewJobApplications;
        OrdersAccessCode := uaSupplierViewOrderLedger;
        NotesAccessCode := uaSupplierAccessNotes;
      end;
  end;

  LedgerPage.TabVisible:=BoChkAllowed_In(((Not InSRC[IsSales]) or (SRCAlloc)) and (Not HideDAdd), LedgerAccessCode);
//  LedgerPage.TabVisible:=BoChkAllowed_In(((Not InSRC[IsSales]) or (SRCAlloc)), 43-(10*Ord(IsSales)));

  // PKR 20/01/2014 - Ledger Multi-Contacts
  // Only display the Roles tab for Customers and Suppliers.  Not for Consumers.
  RolesPage.TabVisible := (CustFormMode <> CONSUMER_TYPE) and (not HideDAdd);


  {$IFDEF PF_On}
    {$IFDEF STK}
      DiscountsPage.TabVisible:=ChkAllowed_In(DiscountAccessCode) and (Not HideDAdd);
      MultiBuyDiscountsPage.TabVisible := ChkAllowed_In(DiscountAccessCode) and (Not HideDAdd);

      WorksOrdersPage.TabVisible:=WOPOn and IsSales and ChkAllowed_In(353) and (Not HideDAdd);

      {$IFDEF RET}
        ReturnsPage.TabVisible:=(RetMOn and ChkAllowed_In(ReturnsAccessCode) and (Not HideDAdd));
      {$ELSE}
        RetPage.TabVisible:=BOff;

      {$ENDIF}

    {$ELSE}
      DiscountsPage.TabVisible:=BOff;
      MultiBuyDiscountsPage.TabVisible := BOff;
      WorksOrdersPage.TabVisible:=BOff;
      ReturnsPage.TabVisible:=BOff;

    {$ENDIF}
    {$IFDEF JAP}
      JobApplicationsPage.TabVisible:=((CanJAP and (Not IsSales)) or (JapOn and IsSales)) and ChkAllowed_In(JobApplicationsAccessCode) and (Not HideDAdd);
    {$ELSE}
      JobApplicationsPage.TabVisible:=BOff;
    {$ENDIF}


  {$ELSE}
    DiscountsPage.TabVisible:=BOff;
  {$ENDIF}

  NotesPage.TabVisible:=ChkAllowed_In(NotesAccessCode) and (Not HideDAdd);

  {$IFNDEF SOP}
    OrdersPage.TabVisible:=BOff;
    MultiBuyDiscountsPage.TabVisible := False;
  {$ELSE}
    OrdersPage.TabVisible:=ChkAllowed_In(OrdersAccessCode) and (Not HideDAdd);


    If (Not IsSales) then
      OrdersPage.Caption:='Purchase Orders'
    else
      OrdersPage.Caption:='Sales Orders';

    //PR: 20/04/2009
    //MultiBuyDiscountsPage.TabVisible :=  not HideDAdd;

  {$ENDIF}

  PrimeButtons;

end;


procedure TCustRec3.FormDesign;

Const
  CapAry  :  Array[BOff..BOn,1..4] of Byte = ((51,52,53,54),(1,2,11,12));
  //PR: 09/09/2013 ABSEXCH-14598 - distance to move panels up to cover for hidden Direct Debit Mandate fields;
  DistanceToMove = 40;


Var
 n  :  Byte;

 HideTag
    :  Boolean;


begin
  //Put this here to get original offsets of controls
  FormSetOfSet;

  Find_FormCoord;

  HideTag:=Not WOPOn;

  Set_DefaultCVAT(cbDefaultTaxCode.Items,  BOn);
  //Set_DefaultCVAT(DefVATF.ItemsL, BOn);

  {$IFDEF MC_On}
    Set_DefaultCurr(CurrF.Items,BOff,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOff,BOn);
  {$ENDIF}

  // CJS 2013-09-30 - MRD1.1.14 - Trader List - Consumers Record
  if CustFormMode = CONSUMER_TYPE then
  begin
    // Resize for the long account code, and display the short account code
    // label
    AcCodeF.Width := CompF.Width;
    AcCodeF.MaxLength := LongCustCodeLen;
    AcShortCodeTxt.Visible := True;

    // Hide the Invoice To and Head Office controls (not relevant for Consumers)
    InvoiceToLbl.Visible := False;
    InvTF.Visible := False;
    HOACF.Visible := False;

    // Hide the Print Statement controls (not relevant for Consumers)
    PStaF.Visible := False;
    StatementToLbl.Visible := False;
    StaF.Visible := False;

    // Change the Company label caption
    lblCompanyName.Caption := 'Name';
  end
  else
  begin
    AcCodeF.Width := 64;
    AcCodeF.MaxLength:=CustKeyLen;
    AcShortCodeTxt.Visible := False;
  end;

  AltCodeF.MaxLength:=CustKey2Len;
  CompF.MaxLength:=CustCompLen;

  {StaF.MaxLength:=CustKeyLen;}

  VatNoF.MaxLength:=CustVatLen;

  {CCF.MaxLength:=CCKeyLen;
  DepF.MaxLength:=CCKeyLen;}

  {DNomF.MaxLength:=NomKeyLen;}

  {PayF.MaxLength:=1;}

  BankAF.MaxLength:=BankALen;
  BankSF.MaxLength:=BankSLen;
  BankRF.MaxLength:=BankRLen;
  CTrad1F.MaxLength:=CustTTLen;
  CTrad2F.MaxLength:=CustTTLen;

  With DDModeF do
    ItemsL.Assign(Items);

  VATRNoF.Caption:=CCVATName^+VATRNoF.Caption;
  lblDefaultTaxCode.Caption := 'Default ' + CCVATName^ + ' Code';

  {$IFDEF SOP}
    HideTag:=BOff;

  {$ENDIF}

  {$IFDEF STK}
    If (Not Syss.IntraStat) then
  {$ENDIF}
  Begin
    DefaultDeliveryTerms.Visible   := false;
    DeliveryTermsLabel.Visible     := DefaultDeliveryTerms.Visible;
    DefaultModeOfTransport.Visible := false;
    ModeOfTransportLabel.Visible   := DefaultModeOfTransport.Visible;
  // PKR. 12/01/2016. ABSEXCH-17098. Intrastat - 4.2 Trader Record.
  // Show the Delivery Terms and Mode of Transport fields if configured in the Intrastat Control Centre.
  {$IFDEF STK}
  end
  else
  begin
    // PKR. 24/02/2016. ABSEXCH-17322. Intrastat fields only if Full Stock System
    DefaultDeliveryTerms.Visible   := SystemSetup.Intrastat.isShowDeliveryTerms and (FullStkSysOn);
    DeliveryTermsLabel.Visible     := DefaultDeliveryTerms.Visible;

    DefaultModeOfTransport.Visible := SystemSetup.Intrastat.isShowModeOfTransport and (FullStkSysOn);
    ModeOfTransportLabel.Visible   := DefaultModeOfTransport.Visible;
  {$ENDIF}
  end;

  // Default to QR only visible if Intrastat enabled.
  // PKR. 15/01/2016. ABSEXCH-17150. Default to QR checkbox not available for Suppliers.
  // PKR. 24/02/2016. ABSEXCH-17322. Intrastat fields only if Full Stock System
  chkDefaultToQR.Visible           := Syss.IntraStat and (Cust.CustSupp <> 'S') and (FullStkSysOn);

  //GS 24/10/2011 ABSEXCH-11706: removed existing UDF setup code; replaced with calling pauls new method
  SetUDFields(Cust.CustSupp);


  If (UseDebtWeeks(Syss.DebtLMode)) then
    Label819.Caption:='weeks'
  else
    Label819.Caption:='days';


  {$IF Not Defined(SOP) or Defined(LTE)}
    AWOf.Visible:=BOff;
    ConsFLab.Visible:=BOff;
    ConsolOrd.Visible:=BOff;
    HOACF.Visible:=BOff;


  {$ELSE}
    With ConsolOrd do
    Begin
      ItemsL.Clear;

      ItemsL.Add('Use Default Settings');
      ItemsL.Add('Consolidate Deliveries');
      ItemsL.Add('Consolidate Invoices');
      ItemsL.Add('Consolidate Deliveries + Invoices');
      ItemsL.Add('Never Consolidate Deliveries');
      ItemsL.Add('Never Consolidate Invoices');
      ItemsL.Add('Never Cons Deliveries or Invoices');
      ItemsL.Add('Cons Deliveries, Never Invoices');
      ItemsL.Add('Cons Invoices, Never Deliveries');

    end;

    // CJS 2013-12-04 - MRD1.1.14 - Trader List - Consumers Record
    if CustFormMode <> CONSUMER_TYPE then
      HOACF.Visible:=BOn;

  {$IFEND}

  {$IFDEF LTE}
     Label823.Visible:=BOff;
     TOurF.Visible:=BOff;
     Label826.Visible:=BOff;
     DCLocnF.Visible:=BOff;
     InvoiceToLbl.Visible:=BOff;
     InvTF.Visible:=BOff;
     Label828.Visible:=BOff;
     FrmDefF.Visible:=BOff;
     DefUdF.Visible:=BOff;
     FSetNamF.Visible:=BOff;
     {Label813.Visible:=BOff;
     CommitLF.Visible:=BOff;}

     With cbSendSta.Items do
     Begin
       Delete(3);
       Delete(1);
     end;


     With cbSendInv.Items do
     Begin
       Delete(3);
       Delete(1);
     end;

  {$ENDIF}


  If (HideTag) then
  Begin
    Label831.Caption:='Area';
    TagNF.Visible:=BOff;
    AreaF.Width:=98;
  end;

  If (Not eBusModule) then
  Begin
    emEbF.Visible:=BOff;
    emWebPWrdF.Visible:=BOff;
    Label843.Visible:=BOff;

    cbSendInv.Items.Delete(5); {* Remove XML Option *}

    emSendHF.Visible:=BOff;
  end
  else
    If (Not eCommsModule) then
    Begin
      {EmailF.Visible:=BOff;}
      emSendRF.Visible:=BOff;

      emZipF.Visible:=BOff;
      cbSendSta.Visible:=BOff;
      {cbSendInv.Visible:=BOff; Is available to either ebis or paperless}


      For n:=1 to 4 do {Remove all other options except XML}
        cbSendInv.Items.Delete(1);

      Label865.Visible:=BOff;
      Label862.Visible:=BOff;
      {Label863.Visible:=BOff;}
    end;

  //PR: 25/07/2013 Changed name from Panel10 to pnlEbus for clarity as we refer to it a few times below
  pnlEbus.Visible:=(eBusModule or eCommsModule);

  If (Not IsSales) then
  Begin
    {Label825.Visible:=BOff;}
//    Label861.Visible:=BOff;
    {StaF.Visible:=BOff;}
    PStaF.Caption:='Print Remittance';
    Label865.Caption:='Remittance';
    {AWOf.Visible:=BOff;  Restored v5.50.001. as it does get used for suppliers!
    ConsFLab.Visible:=BOff;   Restored v4.31.003 as it does get used for suppliers!
    ConsolOrd.Visible:=BOff;}
    Label829.Caption:='Cost GL Code';
    Label842.Visible:=BOff;
    DcNomF.Visible:=BOff;

  //PR: 09/09/2013 ABSEXCH-14598 Hide d/d mandate fields if we're looking at a Supplier
  //PR: 17/09/2013 ABSEXCH-14628 Moved here to avoid problem of repeated calls.
    lblDirectDebit.Visible := False;
    edMandateDate.Visible := False;
    edtMandateId.Visible := False;

    lblMandateDate.Visible := False;
    lblMandateId.Visible := False;


    //Move BankRef field up
    lblBankRef.Top := lblMandateId.Top;
    BankRF.Top := edtMandateId.Top;

    //Reduce bank panel height and move other panels up.
    pnlBankDets.Height := pnlBankDets.Height - DistanceToMove;
    pnlCardDets.Top := pnlCardDets.Top - DistanceToMove;
    pnlSend.Top := pnlCardDets.Top;
    pnlEbus.Top := pnlEbus.Top - DistanceToMove;


    If (CISOn) then
    Begin
      SCCIS1.Caption:=CCCISName^+' Ledger';
      {CISCp1Btn.Caption:=CISLedger1.Caption;}
    end;

    HelpContext:=85;
  end;



  SetTabs2;

//  FormSetOfSet;


  BuildMenus;

  //PR: 06/05/2015 ABSEXCH-16284 T2-120
  LoadPPDOptionList;

  //PR: 27/05/2015 ABSEXCH-16444
  cbPPDOptionsChange(cbPPDOptions);

  ChangePage(0);
end;


//GS 18/10/2011 ABSEXCH-11706: a copy of pauls user fields function
//PR: 14/11/2011 Amended to use centralised function SetUdfCaptions in CustomFieldsIntf.pas ABSEXCH-12129
procedure TCustRec3.SetUDFields(AccountType  :  Char);
var
  udCat : Integer;
begin
  //Set UDF category for this Account Type
  if AccountType = 'C' then
  begin
    udCat := cfCustomer;
  end
  else
  begin
    udCat := cfSupplier;
  end;

  // MH 10/11/2014 Order Payments: Rebadged Credit Card Fields as User Defined Fields 11-15
  SetUdfCaptions([User1Lab, User2Lab, User3Lab, User4Lab, User5Lab, User6Lab, User7Lab, User8Lab, User9Lab, User10Lab, User11Lab, User12Lab, User13Lab, User14Lab, User15Lab], udCat);
  User11Lab.Visible := CustomFields.Field[udCat, 11].cfEnabled;
  CCDCardNoF.Visible := User11Lab.Visible;
  User12Lab.Visible := CustomFields.Field[udCat, 12].cfEnabled;
  CCDSDateF.Visible := User12Lab.Visible;
  User13Lab.Visible := CustomFields.Field[udCat, 13].cfEnabled;
  CCDEDateF.Visible := User13Lab.Visible;
  User14Lab.Visible := CustomFields.Field[udCat, 14].cfEnabled;
  CCDNameF.Visible := User14Lab.Visible;
  User15Lab.Visible := CustomFields.Field[udCat, 15].cfEnabled;
  CCDIssF.Visible := User15Lab.Visible;
  //HV 23/11/2017 2018-R1 ABSEXCH-19405: procedure to set a Highlighting PII Fields flag for GDPR
  if GDPROn then
    SetGDPREnabled([User1F, User2F, User3F, User4F, User5F, User6F, User7F, User8F, User9F, User10F, CCDCardNoF, CCDSDateF, CCDEDateF, CCDNameF, CCDIssF], udCat);
end;

// CJS 2013-09-27 - MRD1.1.14 - Trader Record - amended to include Consumers
procedure TCustRec3.SetTabs;
var
  LedgerAccessCode: Integer;
Begin
  case CustFormMode of
    CUSTOMER_TYPE: LedgerAccessCode := uaCustomerViewLedger;
    CONSUMER_TYPE: LedgerAccessCode := uaConsumerViewLedger;
    SUPPLIER_TYPE: LedgerAccessCode := uaSupplierViewLedger;
    else
      LedgerAccessCode := uaCustomerViewLedger;
  end;

  LedgerPage.TabVisible:=BoChkAllowed_In(((Not InSRC[IsSales]) or (SRCAlloc)), LedgerAccessCode);

  AllocPanel.Visible:=CanAllocate;

  PrimeButtons;
end;


procedure TCustRec3.BuildMenus;

Begin
  //HA1 is the menu item 'Authorise' in the popup menu control 'PopupMenu3'
  //display the 'Authorise' menu item, if the user is allowed access to it
  HA1.Visible:=ChkAllowed_In(ChkPWord(0,[0],342,343));

  //Hold1 is the menu item 'Hold' in the popup menu control 'PopupMenu1'
  //take the 'PopupMenu3' control and make it a submenu of the 'Hold' menu item
  CreateSubMenuSuffix(PopUpMenu3,Hold1,'X',BOn);

  //RecordMode determines what type of record the form is displaying
  //  True = Customer Record, False = Supplier Record
  //Hist1 is the menu item 'History' in the popup menu control 'PopupMenu1'

  //if we are displaying a customer or consumer record..
  If (IsSales) then
    //then add 'PopupMenu2' to the menu option 'History' as a sub-menu
    CreateSubMenu(PopUpMenu2,Hist1);

  //Status1 is the menu item 'Status' in the popup menu control 'PopupMenu1'
  //take the 'PopupMenu6' control and make it a submenu of the 'Hold' menu item
  CreateSubMenu(PopUpMenu6,Status1);

  //GS 01/08/2011 ABSEXCH-10801:
  //count the number of items in 'PopupMenu9', decrement it, and store the result
  //according to received error logs, this sometimes causes a range check errors, possibly due to WinAPI call
  //old WinAPI code:
  //PM9Cnt:=Pred(GetMenuItemCount(PopUpMenu9.Handle));
  //new code using Delphi API:
  PM9Cnt := Pred(PopupMenu9.Items.Count);

  //CISLedger1 is the menu item 'Sub Contractor Record' in the popup menu control 'PopupMenu1'

  //if we are displaying a supplier record..
  If (Not IsSales) then
    //then add 'PopupMenu9' to the menu option 'Sub Contractor Record' as a sub-menu
    CreateSubMenu(PopUpMenu9,CISLedger1);

end;


procedure TCustRec3.FormCreate(Sender: TObject);

Var
  n       :  Integer;
  ShowCC  :  Boolean;

begin
  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
  UseDefaultSortView := True;

  ExLocal.Create;

  bHelpContextInc := FALSE; //NF: 11/04/06

  TraderAudit := NIL;

  LastCoord:=BOff;

  Visible:=BOff;

  NeedCUpDate:=BOff;
  FColorsChanged := False;

  fFrmClosing:=BOff;
  fFrmClosed:=BOff;
  fDoingClose:=BOff;
  StartThread:=BOff;
  FListScanningOn := False;
  PanelIdx:=-1;

  SetUpOk:=BOff;
  HideDAdd:=BOff;

  ManUnal:=BOff;

  {InitSize.Y:=366;
  InitSize.X:=515;

  Self.Height:=InitSize.Y;
  Self.Width:=InitSize.X;}

  ViewNorm:=BOn;

  {UseOSNdx:=UseV5OSNdx; Keep it swtiched off}

  UseOSNdx:=BOff;

  //GS 24/10/2011 ABSEXCH-11706: adjusted the height to accomodate the new form design
  //InitSize.Y:=375;
  // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom labelling for address fields
  InitSize.Y:=PageControl1.Height + (2 * PageControl1.Top) + pnlAnonymisationStatus.Height; //450; //436;
  InitSize.X:=PageControl1.Width + (2 * PageControl1.Left); //512; //506;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  UpdateCS:=BOff;

  MDI_SetFormCoord(TForm(Self));

  // CJS 2013-09-23 - MRD1.1.14 - added support for Consumers. IsSales largely replaces
  // RecordMode.

  // RecordMode:=(CustFormMode=1); // 0 = Suppliers, 1 = Customers
  CustFormMode := TemporaryCustFormMode;
  RecordMode := not (CustFormmode = 2); // 0 = Customers, 1 = Consumers, 2 = Suppliers
  IsSales := (CustFormMode in [ConsumerUtils.CUSTOMER_TYPE, ConsumerUtils.CONSUMER_TYPE]);
  SetFormCaption(False);

  //PR: 08/11/2010 Added to use new Window Positioning system
  //PR: 27/05/2011 Change to use ClassName rather than Name as identifier - if there are
  //2 instances of the form in existence at the same time, Delphi will change the name of one to Name + '_1' (ABSEXCH-11426)
  // CJS 2013-09-23 - MRD1.1.14 - added support for Consumers.
  FSettings := GetWindowSettings(Self.ClassName + '_' + SubTypeFromTraderType(CustFormMode));
  if Assigned(FSettings) then
    FSettings.LoadSettings;

  // PKR 02/10/2013  - MRD 7.X Item 2.4 - Ledger Multi-Contacts
  // Create the Roles frame.
  // Only want Roles for Customers and Suppliers - not for Consumers
  // The Roles tab will not be displayed for Consumers.
  rolesFrame := TframeCustRoles.Create(self);
  try
    rolesFrame.Parent := RolesPage;
    rolesFrame.Name   := 'RolesFrame';
    rolesFrame.ParentForm := self;
    rolesFrame.Align  := alLeft;
    rolesFrame.Width  := TCMPanel.Left - 16;
    rolesFrame.SetCustFormMode(CustFormMode);
    rolesFrame.HelpType := htContext;
    rolesFrame.lbContacts.HelpContext := 8100;
  except
    FreeAndNil(rolesFrame);
    raise;
  end;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;


  PayTF.BlockNegative:=BOn;
  cePPDDays.BlockNegative:=BOn;
  TagNF.BlockNegative:=BOn;

  Last_Page:=0;

  {* Set Version Specific Info *}

  {$IFNDEF MC_On}
    CDRCurrLab.Visible:=BOff;
    CurrF.Visible:=BOff;
  {$ENDIF}

  {$IFNDEF PF_On}
    ShowCC:=BOff;

    NotesPage.TabVisible:=BOff;

  {$ELSE}
    {$IFNDEF STK}
      NotesPage.TabVisible:=BOff;
    {$ENDIF}

    ShowCC:=Syss.UseCCDep;
  {$ENDIF}


  CDRCCLab.Visible:=ShowCC;
  DeptLbl.Visible:=ShowCC; //HV 02/02/2016 2016-R1 ABSEXCH-15393: Word Department showing on Trader Record though CC/Dept disabled 
  CCF.Visible:=ShowCC;
  DepF.Visible:=ShowCC;

  {$IFNDEF SOP}
    LedgerPage.TabVisible:=BOff;
  {$ENDIF}

  // MH 21/07/2014: Order Payments
  panOrderPayments.Visible := Syss.ssEnableOrderPayments And (CustFormMode in [ConsumerUtils.CUSTOMER_TYPE, ConsumerUtils.CONSUMER_TYPE]);

  // MH 30/07/2015 2015-R1 ABSEXCH-16711: Move PPD panel up to fill Order Payments gap
  If (Not panOrderPayments.Visible) Then
  Begin
    panPPD.Top := panOrderPayments.Top;
  End; // If (Not panOrderPayments.Visible)

  // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
  LoadCountryCodes (lstAddressCountry);
  LoadCountryCodes (lstDeliveryCountry);
  // MH 26/01/2015 v7.1 ABSEXCH-16063: Modified country fields to use long names
  lstAddressCountry.Items.Assign(lstAddressCountry.ItemsL);
  lstDeliveryCountry.Items.Assign(lstDeliveryCountry.ItemsL);

  // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom labelling for address fields
  SetUDFCaptions([lblLine1, lblLine2, lblLine3, lblLine4, lblLine5], cfAddressLabels);
  SetUDFCaptions([lblDelLine1, lblDelLine2, lblDelLine3, lblDelLine4, lblDelLine5], cfAddressLabels);

  CanCIS:=BOff;
  CanJap:=BOff;
  InCISVch:=BOff;

  {$IFDEF JAP}
    InSCLedger:=BOff;
  {$ENDIF}

  InHBeen:=BOff;

  SRCAlloc:=BOff;
  CanAllocate:=BOff;
  CQBMode:=BOff;
  SDDMode:=BOff;
  ListBusy:=BOff;

  Blank(SRCInv,Sizeof(SRCInv));

  StopPageChange:=BOff;

  DispTransPtr:=nil;
  DispOUPtr:=nil;

  HistFormPtr:=nil;
  MatchFormPtr:=nil;
  LastHMode:=1;

  ListOfSet:=10;

  SKeypath:=0;
  LastBTag:=0;

  PM9Cnt:=0;

  GotCoord:=BOff;

  {$IFNDEF SOP}
  MultiBuyDiscountsPage.Visible := False;
  MultiBuyDiscountsPage.TabVisible := False;
  {$ENDIF}
  FormDesign;

  // PKR. 11/01/2016. ABSEXCH-17098. Instrastat changes.
  if (DefaultDeliveryTerms.Visible) then
  begin
    DefaultDeliveryTerms.Items.Clear;
    for n := 0 to IntrastatSettings.DeliveryTermsCount-1 do
    begin
      DefaultDeliveryTerms.Items.Add(Format('%s - %s', [IntrastatSettings.DeliveryTerms[n].Code, IntrastatSettings.DeliveryTerms[n].Description]));
      DefaultDeliveryTerms.ItemsL.Add(Format('%s - %s', [IntrastatSettings.DeliveryTerms[n].Code, IntrastatSettings.DeliveryTerms[n].Description]));
    end;
  end;

  if (DefaultModeOfTransport.Visible) then
  begin
    DefaultModeOfTransport.Items.Clear;
    for n := 0 to IntrastatSettings.ModesOfTransportCount-1 do
    begin
      DefaultModeOfTransport.Items.Add(Format('%s - %s', [IntrastatSettings.ModesOfTransport[n].Code, IntrastatSettings.ModesOfTransport[n].Description]));
      DefaultModeOfTransport.ItemsL.Add(Format('%s - %s', [IntrastatSettings.ModesOfTransport[n].Code, IntrastatSettings.ModesOfTransport[n].Description]));
    end;
  end;

  {$IFDEF HM}
    //Custom_FormLoad (Self);
  {$ENDIF}
end;


procedure TCustRec3.FormDestroy(Sender: TObject);
begin
  TraderAudit := NIL;

  // CJS 18/03/2011 - ABSEXCH-9646
  if Assigned(MatchingFrm) then
    FreeAndNil(MatchingFrm);

  ExLocal.Destroy;

  If (InvBtnList<>nil) then
    InvBtnList.Free;

end;


procedure TCustRec3.DefaultPageReSize;
Var
  n  :  Integer;
Begin
  CLSBox.Width:=PageControl1.Width-PagePoint[0].X;
  CLSBox.Height:=PageControl1.Height-PagePoint[0].Y;

  // MH 26/01/2015 v7.1 ABSEXCH-16063: Debugged resizing
  CListBtnPanel.Left := CLSBox.Left + CLSBox.Width + 3;

  COSBox.Height:=CDSBox.Height;
  COSBox.Width:=CDSBox.Width;

  COListBtnPanel.Left:=COSBox.Width+4;

  CLORefPanel.Height:=CLSBox.Height-PagePoint[2].X;

  CListBtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

  // MH 26/01/2015 v7.1 ABSEXCH-16063: Don't resize button panel on Sales Order tab to height of
  // Ledger version which has a shorter list
  //COListBtnPanel.Height:=CListBtnPanel.Height;

// MH 14/07/2015 v7.0.14 ABSEXCH-16597: Removed resizing of the column caption panel as it is handled
//                                      internally by the list andd this just screws things up
//  With CLSBox do
//    CLHedPanel.Width:=HorzScrollBar.Range;

// MH 14/07/2015 v7.0.14 ABSEXCH-16597: Removed resizing of the column caption panel as it is handled
//                                      internally by the list andd this just screws things up
//  With COSBox do
//    COHedPanel.Width:=HorzScrollBar.Range;


  For n:=Low(MULCtrlO) to High(MULCtrlO) do
    If (MULCtrlO[n]<>nil) then
    Begin
      With MULCtrlO[n],VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
        Begin
          // MH 23/01/2015 v7.1 ABSEXCH-16063: Resize columns appropriately
          //Height:=CLORefPanel.Height;
          Height := Parent.Height - Top - GetSystemMetrics(SM_CXHSCROLL) - 4;

          If (Name = 'COORefPanel') Then
            // MH 26/01/2015 v7.1 ABSEXCH-16063: Resize button panel on Sales Order tab based on
            // the column height of the Sales Order list panels - must be done before Refresh_Buttons
            COListBtnPanel.Height := Height;
        End;

        ReFresh_Buttons;

        If ((Not (n In [OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo])) or (n=Current_Page)) then
          RefreshAllCols;
      end;
    end;
end;


procedure TCustRec3.NotePageReSize;
Begin
  With TCNScrollBox do
  Begin
    TCNListBtnPanel.Left:=Width+4;

    {TNHedPanel.Width:=HorzScrollBar.Range;}
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

      TNHedPanel.Width:=(IdPanel(MUTotCols,BOff).Left+IdPanel(MUTotCols,BOff).Width);
    end;

  {$ENDIF}
end;

//------------------------------------------------------------------------------
// PKR. 11/10/2013 - Ledger Multi-Contacts
// Migrated to 7.0.9 on 20/01/2014.
procedure TCustRec3.RolesPageReSize;
begin
  // MH 29/10/2013: rolesFrame is only created for Customers and Suppliers
  If Assigned(rolesFrame) Then
  Begin
    // Due to the slightly bizarre floating buttons panel, we can't make the
    //  CustRolesFrame align to Client, so we have to manually set its width.
    rolesFrame.Width  := TCMPanel.Left - 16;
    rolesFrame.CalcRoleBoxSize;
  End; // If Assigned(rolesFrame)
end;

//------------------------------------------------------------------------------

{$IFDEF PF_On}
  {$IFDEF STK}

    procedure TCustRec3.QBPageReSize;

    Var
      n  :  Integer;

    Begin
      CDSBox.Height:=TCNScrollBox.Height;
      CDSBox.Width:=TCNScrollBox.Width;

      CDListBtnPanel.Left:=TCNListBtnPanel.Left;
      CDListBtnPanel.Height:=TCNListBtnPanel.Height;

// MH 14/07/2015 v7.0.14 ABSEXCH-16597: Removed resizing of the column caption panel as it is handled
//      With CDSBox do
//        CDHedPanel.Width:=HorzScrollBar.Range;

      CDSPanel.Height:=NDatePanel.Height;

      For n:=Low(MULCtrlO2) to High(MULCtrlO2) do
        If (MULCtrlO2[n]<>nil) then
        Begin
          With MULCtrlO2[n],VisiList do
          Begin
            VisiRec:=List[0];

            With (VisiRec^.PanelObj as TSBSPanel) do
              Height:=CDSPanel.Height;

            ReFresh_Buttons;

            RefreshAllCols;
          end;
        end;

    end;
  {$ENDIF}
{$ENDIF}



procedure TCustRec3.FormResize(Sender: TObject);
begin
  If (GotCoord) then
  Begin
    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    PageControl1.Width:=ClientWidth-PageP.X;
    PageControl1.Height:=ClientHeight-PageP.Y;


    TCMPanel.Left:=PageControl1.Width-ScrollAP.X;
    TCMPanel.Height:=PageControl1.Height-ScrollAP.Y;


    TCMScrollBox.Width:=PageControl1.Width-ScrollBP.X;
    TCMScrollBox.Height:=PageControl1.Height-ScrollBP.Y;

    TCMBtnScrollBox.Height:=TCMPanel.Height-Misc1P.X;


    {TCDPanel.Left:=PageControl1.Width-PagePoint[0].X;
    TCDPanel.Height:=PageControl1.Height-PagePoint[0].Y;}


    TCDScrollBox.Width:=PageControl1.Width-PagePoint[1].X;
    TCDScrollBox.Height:=(PageControl1.Height-PagePoint[1].Y)+1;

    {TCNPanel.Left:=PageControl1.Width-PagePoint[2].X;
    TCNPanel.Height:=PageControl1.Height-PagePoint[2].Y;}


    TCNScrollBox.Width:=PageControl1.Width-PagePoint[3].X;
    TCNScrollBox.Height:=PageControl1.Height-PagePoint[3].Y;

    TCNListBtnPanel.Height:=TCNScrollBox.ClientHeight-PagePoint[4].X;

    // MH 18/12/2014 v7.1 ABSEXCH-15855: Re-ordered resizing as DefaultPageResize relies on stuff
    // in QBPageReSize which relies on stuff in NotePageReSize, etc... - a total clusterf***
    NotePageReSize;

    {$IFDEF PF_On}
      {$IFDEF STK}
        QBPageReSize;
      {$ENDIF}
    {$ENDIF}
    SetButnPanelHeight(Current_Page);

    DefaultPageReSize;

    // PKR. 11/10/2013.  - MRD 7.X Item 2.4 - Ledger Multi-Contacts
    // Added to 7.0.9 20/01/2014.
    RolesPageReSize;

    {$IFDEF SOP}
    //GS
     //mbdFrame.mbdResize((TCMScrollBox.Width - TCNListBtnPanel.Width), TCMScrollBox.Height, TCNListBtnPanel.Height);
     mbdFrame.mbdResize((TCNScrollBox.Width - TCNListBtnPanel.Width) , TCNScrollBox.Height, TCNListBtnPanel.Height);
    {$ENDIF}

    // SSK 22/10/2017 ABSEXCH-19386: Resize the anonymisation shape
    SetAnonymisationPanel;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end; {Proc..}


procedure TCustRec3.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If (Current_Page<NotesPNo) then
    GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TCustRec3.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  n  :  Byte;

begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    For n:=Low(MULCtrlO) to High(MULCtrlO) do
    Begin
      Try
        If (MULCtrlO[n]<>Nil) then
          MULCtrlO[n].Destroy; {* Must be destroyed here, as otherwise when form open and application is exited a GPF occurs if in form destroy}

      Finally

        MULCtrlO[n]:=Nil;

      end; {Finally..}

    end;

    //PR: 01/12/2011 v6.9 If mbdFrame has been accessed then MULCtrl1O array will contain a pointer to mbdFrame.FMulCtrl. Consequently, we need
    //to set that to nil as it is destroyed, otherwise the frame might try to access it during the resize function which can get called during
    //formclose. ABSEXCH-11948
    {$IFDEF SOP}
    mbdFrame.FMulCtrl := nil;
    {$ENDIF}


    {$IFDEF STK}
      For n:=Low(MULCtrlO2) to High(MULCtrlO2) do
      Begin
        Try
          If (MULCtrlO2[n]<>Nil) then
            MULCtrlO2[n].Destroy; {* Must be destroyed here,  as otherwise when form open and application is exited a GPF occurs if in form destroy}

        Finally

          MULCtrlO2[n]:=Nil;

        end; {Finally..}

      end;
    {$ENDIF}

    Action:=caFree;

  end;

    
end;


procedure TCustRec3.FormActivate(Sender: TObject);
begin
  If (SRCAlloc) then {* Update unallocated in case it has changed *}
    OutAlloc;
end;


Function TCustRec3.SRCTol  :  Double;

Begin
  Case Syss.AlTolMode of
    1  :  Result:=Syss.AlTolVal;
    2  :  Result:=Round_Up(Pcnt(Syss.AlTolVal)*ConvCurrItotal(SRCInv,BOff,BOn,BOn),2);
    else  Result:=0;
  end; {Case..}

  Result:=Result*DocCnst[SRCInv.InvDocHed]*DocNotCnst;
end;


Function TCustRec3.Within_SRCTol:  Boolean;

Var
  Equiv,
  EquivDNC,
  MaxEq  :  Double;

Begin

  With GlobalAllocRec^[IsSales] do
  Begin
    If (LUnallocated<>0.0) or (JBFieldOn) then
      EQuiv:=LUnallocated-LFullDisc
    else
      Equiv:=LUnallocated;

    EquivDNC:=SRCTol*DocNotCnst;

    If (JBFieldOn) then {*Ex32, this could probably do with being a seperate switch, or mode? put in for Heinz *}
      MaxEq:=0
    else
      MaxEq:=ConvCurrItotal(SRCInv,BOff,BOn,BOn)*DocCnst[SRCInv.InvDocHed]*DocNotCnst;

    If (SRCInv.InvDocHed In SalesSplit) then
      Result:=(((Round_Up(Equiv,2)<=EquivDNC) and (Round_Up(Equiv,2)>=(MaxEq+SRCTol))) or (SBSIn) or (Syss.AlTolMode=0))
    else
      Result:=(((Round_Up(Equiv,2)>=EquivDNC) and (Round_Up(Equiv,2)<=(MaxEq+SRCTol))) or (SBSIn) or (Syss.AlTolMode=0));
      {Result:=(((Round_Up(LUnallocated,2)>=EQuiv) and (Round_Up(LUnallocated,2)<=(EQuivDNC+MaxEq))) or (SBSIn) or (Syss.AlTolMode=0));}
  end; {With..}
end;



Function TCustRec3.AllocateOk(ShowMsg  :  Boolean)  :  Boolean;

Begin

  If (Not SRCAlloc) or (Not CanAllocate) then
  Begin
    Result:=((Round_Up(GlobalAllocRec^[IsSales].LUnallocated,2)=0.00) or (SBSIn) or (SRCAlloc) or (Not LedgerPage.TabVisible) or (Not CanAllocate));    // SSK 21/03/2017 2017-R1 ABSEXCH-15992: reinstated 'or (SBSIn)' condition

    // TG: 14/03/2017 ABSEXCH- 15992 to not allow allocation of transactions that are sitting on different Trader records from system user
    //Result:=((Round_Up(GlobalAllocRec^[IsSales].LUnallocated,2)=0.00) or (SRCAlloc) or (Not LedgerPage.TabVisible) or (Not CanAllocate));
    // SSK 04/06/2018 2018-R1.1 ABSEXCH-19640: above line removed to solve the problem due to which Unable to unallocate single items when logged in as System User

    If (Not Result) and (ShowMsg) then
      ShowMessage('There is an amount unallocated within the ledger. This must be corrected before you may exit.');
  end
  else
  Begin
    Result:=Within_SRCTol;

    If (Not Result) and (ShowMsg) then
    With GlobalAllocRec^[IsSales] do
      ShowMessage('The total amount unallocated within the ledger must not exceed '+FormatCurFloat(GenRealMask,(SRCTol)*DocNotCnst,Bon,0)+' before you may exit.');
  end;
end;

Function TCustRec3.CheckListFinished  :  Boolean;

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


procedure TCustRec3.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

Var
  n  :  Integer;

  //------------------------------

  Procedure AddWorkflowDiaryNote (Const AcCode : ShortString);
  Var
    CustSavePos, NotesSavePos : TBtrieveSavePosition;
    KeyS : Str255;
    LockPos : LongInt;
    iStatus : SmallInt;
  Begin // AddWorkflowDiaryNote
    CustSavePos := TBtrieveSavePosition.Create;
    NotesSavePos := TBtrieveSavePosition.Create;
    Try
      // Save the current position in the file for the current key
      CustSavePos.SaveFilePosition (CustF, GetPosKey);
      CustSavePos.SaveDataBlock (@Cust, SizeOf(Cust));

      NotesSavePos.SaveFilePosition (PwrdF, GetPosKey);
      NotesSavePos.SaveDataBlock (@Password, SizeOf(Password));

      //------------------------------

      // Get and Lock the Customer/Supplier record so we can add a new note - don't wait for the lock
      KeyS := FullCustCode(ExLocal.LCust.CustCode);
      iStatus := Find_Rec(B_GetEq+B_MultLock, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, KeyS);
      If (iStatus = 0) Then
      Begin
        GetPos(F[CustF], CustF, LockPos);

        Cust.NLineCount := Cust.NLineCount + 1;

        // Update and unlock account
        iStatus := Put_Rec(F[CustF], CustF, RecPtr[CustF]^, CustCodeK);
        iStatus := UnlockMultiSing(F[CustF], CustF, LockPos);

        If (iStatus = 0) Then
        Begin
          // Add the note
          FillChar(Password, SizeOf(Password), #0);

          Password.RecPFix := NoteTCode;
          Password.SubType := NoteCCode;

          With Password.NotesRec Do
          Begin
            LineNo := Cust.NLineCount - 1;
            NoteFolio := Cust.CustCode;
            NType := NoteCDCode;
            NoteDate:=Today;
            NoteAlarm := Today;
            NoteUser:=EntryRec^.Login;
            ShowDate := True;
            NoteLine := 'Recalc Oldest Debt not performed - Ledger closed unexpectedly';

            NoteNo := FullRNoteKey(NoteFolio, NType, LineNo);
          End; // With Password.NotesRec

          iStatus := Add_Rec(F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWk);
          Report_BError(PwrdF, iStatus);
        End; // If (iStatus = 0)
      End; // If (iStatus = 0)

      //------------------------------

      // Restore position in file
      NotesSavePos.RestoreDataBlock (@Password);
      NotesSavePos.RestoreSavedPosition;

      CustSavePos.RestoreDataBlock (@Cust);
      CustSavePos.RestoreSavedPosition;
    Finally
      CustSavePos.Free;
      NotesSavePos.Free;
    End; // Try..Finally
  End; // AddWorkflowDiaryNote

  //------------------------------

begin
  If (Not fFrmClosing) and (Not fFrmClosed) then
  Begin
    fFrmClosing:=BOn;

    Try
      //HV 29/03/2016 2016-R2 ABSEXCH-14347: Currently System doesn't 'Calculate Oldest Debt when leaving Ledger'
      if Syss.LiveCredS and IsLedgerPageActivate then
      begin
        //HV 20/05/2016 2016-R2 ABSEXCH-17430: Recalculate Trader Oldest Debt Correctly
        if SQLUtils.UsingSQLAlternateFuncs and SQLReportsConfiguration.UseSQLCheckAllAccounts then
          CheckOldestDebt(self,Cust.CustCode,False)
        else
          AddCheckCust2Thread(Self,Cust.CustCode,BOff,BOn,BOff,BOn,Cust.acSubType);
      end;

      CanClose:=(ConfirmQuit and AllocateOk(BOn) and Not ListBusy) {$IFDEF JC} {$IFDEF JAP} {$IFNDEF SOPDLL} and (Not InSCLedger) {$ENDIF} {$ENDIF} {$ENDIF} ;

      GenCanClose(Self,Sender,CanClose,BOff);

      If (CanClose) then
        CanClose:=CheckListFinished;

      If (CanClose) then
        CanClose:=GenCheck_InPrint;

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


        If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
          Store_FormCoord(Not SetDefault);

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

        {$IFDEF Post}
          {* Update Credit status Flg customers only *}
          If (UpdateCS) and (Syss.LiveCredS) Then
          Begin
            // MH 05/04/2011 v6.7 ABSEXCH-10717: Modified to write Workflow Diary not if not possible to run thread object
            If (StartThread) {and (RecordMode)} then
            Begin
              UpdateCS:=BOff;
              If (Not SRCAlloc) then
                AddChkCAlloc2Thread(Self.Owner,ExLocal.LCust.CustCode)
              else {During live allocation defer checking of ldger to storage of src}
              Begin
                {$B-}
                If (Assigned(Self.Owner)) and (Assigned(Self.Owner.Owner)) then
                {$B+}
                  SendMessage(TWinControl(Self.Owner.Owner).Handle,WM_CustGetRec,30,1);

              end;
            End // If (StartThread) {and (RecordMode)}
            Else
            Begin
              AddWorkflowDiaryNote (ExLocal.LCust.CustCode);
            End; // Else
          End; // If (UpdateCS) and (Syss.LiveCredS)
        {$ENDIF}

      end;
    finally
      fFrmClosing:=BOff;

      fFrmClosed:=CanClose;

    end;
  end
  else
    CanClose:=fFrmClosed;
end;


procedure TCustRec3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

Begin
  If (Current_Page<NotesPNo) or (Key In [VK_F1..VK_F12,VK_Prior,VK_Next]) then
    GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


procedure TCustRec3.ClsCP1BtnClick(Sender: TObject);
begin
  If (ConfirmQuit) then
  Begin
    StartThread:=BOn; {Flag set here to avoid thread starting as Enterprise is closing}
    Close;

  end;
end;


Procedure TCustRec3.ManageSendInv(SetMode  :  Boolean;
                              Var InvMode  :  Byte);

Begin
  If (eBusModule or eCommsModule) then
  With cbSendInv do
  Begin
    If (Not eCommsModule) then
    Begin
      If (SetMode) then
      Begin
        If (ItemIndex=1) then
          InvMode:=5
        else
          InvMode:=0;
      end
      else
      Begin
        If (InvMode=5) then
          ItemIndex:=1
        else
          ItemIndex:=0;

      end;
    end
    else
    Begin
      If (SetMode) then
      Begin
        If (ItemIndex>=0) and (ITemIndex<=5) then
          InvMode:=SetSendInv(Not SetMode,ItemIndex)
        else
          InvMode:=0;
      end
      else
      Begin
        If (SetSendInv(Not SetMode,InvMode)<=Pred(Items.Count)) then
          ItemIndex:=SetSendInv(Not SetMode,InvMode)
        else
          ItemIndex:=0;

      end;
    end;
  end; {With..}
end;


Function TCustRec3.SetSendSta(OutMode  :  Boolean;
                              StaOpt   :  Integer)  :  Integer;

Begin
  Result:=StaOpt;

  Case OutMode of
    BOff  :  Begin
               {$IFDEF LTE}
                 Case StaOpt of
                   1  :  Result:=2;
                   2  :  Result:=4;
                 end;{Case..}
               {$ENDIF}
             end;

    BOn   :  Begin
               {$IFDEF LTE}
                 Case StaOpt of
                   2  :  Result:=1;
                   3,4
                      :  Result:=2;
                 end;{Case..}
               {$ENDIF}

             end;
  end; {Case..}


end; {Func..}

Function TCustRec3.SetSendInv(OutMode  :  Boolean;
                              StaOpt   :  Integer)  :  Integer;

Begin
  Result:=StaOpt;

  Case OutMode of
    BOff  :  Begin
               {$IFDEF LTE}
                 Case StaOpt of
                   1  :  Result:=2;
                   2,3
                      :  Result:=StaOpt+2;
                 end;{Case..}
               {$ENDIF}
             end;

    BOn   :  Begin
               {$IFDEF LTE}
                 Case StaOpt of
                   2  :  Result:=1;
                   3..5
                      :  Result:=StaOpt-2;
                 end;{Case..}
               {$ENDIF}

             end;
  end; {Case..}

end; {Func..}


{ === Procedure to Output one cust record === }

Procedure TCustRec3.OutCust;

Var
  CrDr       :   DrCrDType;

  BalYTD     :   Byte;
  HistCode   :   Char;

  Cleared,
  ThisPr,
  ThisYTD,
  LastYTD,
  Budget1,
  Budget2,
  Commit,

  BV1,BV2    :   Double;

  listIndex : integer;
Begin

  Blank(CrDr,Sizeof(CrDr));

  ThisPr:=0; ThisYTD:=0; LastYTD:=0;  Cleared:=0;

  Budget1:=0;

  Budget2:=0;

  Commit:=0; BV1:=0; BV2:=0;

  With ExLocal.LCust do
  Begin

    // CJS 2013-09-30 - MRD1.1.14 - Consumers Record
    if CustFormMode = CONSUMER_TYPE then
    begin
      AcCodeF.Text := Strip('B', [#32], AcLongAcCode);
      AcShortCodeTxt.Caption := '(Short Code: ' + Strip('B', [#32], CustCode) + ')';
    end
    else
    AcCodeF.Text:=Strip('B',[#32],CustCode);

{    AcCode2F.Text:=CustCode;
    AcCode3F.Text:=CustCode;}

    if FAnonymisationON and (acAnonymisationStatus = asAnonymised) then
      CompF.Text := capAnonymised
    else
      CompF.Text := Strip('R',[#32],Company);

{    Comp2F.Text:=Company;
    Comp3F.Text:=Company;}
    AltCodeF.Text:=CustCode2;
{    AltCode2F.Text:=CustCode2;
    AltCode3F.Text:=CustCode2;}


    Addr1F.Text:=Addr[1];
    Addr2F.Text:=Addr[2];
    Addr3F.Text:=Addr[3];
    Addr4F.Text:=Addr[4];
    Addr5F.Text:=Addr[5];

    ContactF.Text:=Contact;
    PhoneF.Text:=Trim(Phone);
    FaxF.Text:=Fax;
    CrLimitF.Value:=CreditLimit;
    MobileF.Text:=Phone2;

    PayTF.Value:=PayTerms;

    CredStatF.Value:=CreditStatus;

    StatusF.Text:=Show_AccStatus(AccStatus);

    With Syss do
    Begin
      If (IsACust(CustSupp)) then
      Begin
        BalYTD:=YTDNCF;
        HistCode:=CustHistGPCde;
      end
      else
      Begin
        BalYTD:=YTDNCF;
        HistCode:=CustHistGPCde;

      end;

      {$B-}

      // CJS 2013-10-01 - MRD1.1.14 - Consumers Record
      if ((CustFormMode = CUSTOMER_TYPE) and PChkAllowed_In(uaCustomerViewBalance)) or
         ((CustFormMode = CONSUMER_TYPE) and PChkAllowed_In(uaConsumerViewBalance)) or
         ((CustFormMode = SUPPLIER_TYPE) and PChkAllowed_In(uaSupplierViewBalance)) then
      {$B+}
      Begin
        Balance:=Total_Profit_to_Date(HistCode,CustCode,0,AdjYr(GetLocalPr(0).Cyr,BOff),Pred(BalYTD),
                                      CrDr[BOff],CrDr[BOn],Cleared,Budget1,Budget2,BV1,BV2,BOn);

        LastYTD:=CrDr[BOff];

        Balance:=Profit_to_Date(HistCode,CustCode,0,GetLocalPr(0).CYr,GetLocalPr(0).CPr,CrDr[BOff],CrDr[BOn],Cleared,BOff);

        ThisPr:=CrDr[BOff];

        Balance:=Profit_to_Date(HistCode,CustCode,0,GetLocalPr(0).Cyr,GetLocalPr(0).CPr,CrDr[BOff],CrDr[BOn],Cleared,BOn);

        ThisYTD:=CrDr[BOff];

        {* Get balance & comitted from normal history *}
        Balance:=Profit_to_Date(CustHistCde,CustCode,0,GetLocalPr(0).Cyr,GetLocalPr(0).CPr,CrDr[BOff],CrDr[BOn],Commit,BOn);

        {If (IsACust(CustSupp)) then {* Get baalnce from normal history *}
          {Balance:=Profit_to_Date(CustHistCde,CustCode,0,Cyr,CPr,CrDr[BOff],CrDr[BOn],Cleared,BOn);}


        {$IFNDEF SOP} {* Substitute History committed with imported value *}
          Commit:=BOrdVal;
        {$ENDIF}
      end
      else
        Balance:=0;

    end;

    TPrTo.Value:=ThisPr;
    TYTDTo.Value:=ThisYTD;
    LYTDTo.Value:=LastYTD;
    CurrBalF.Value:=Balance*TradeConst[IsaCust(CustSupp)];

    CommitLF.Value:=(Commit*TradeConst[IsACust(CustSupp)]);

    CredAvailF.Value:=(CreditLimit-(CurrBalF.Value+CommitLF.Value));

    DAddr1F.Text:=DAddr[1];
    DAddr2F.Text:=DAddr[2];
    DAddr3F.Text:=DAddr[3];
    DAddr4F.Text:=DAddr[4];
    DAddr5F.Text:=DAddr[5];
    { CJS 2013-08-08 - MRD2.5 - Delivery PostCode }
    edtPostCode.Text := acDeliveryPostCode;

    TOurF.Text:=Trim(RefNo);

    StaF.Text:=Strip('R',[#32],RemitCode);
    InvTF.Text:=SOPInvCode;

    PStaF.Checked:=IncStat;
    chkECMember.Checked:=EECMember;

    IF (VATCode In VATSet) then
      cbDefaultTaxCode.ItemIndex:=GetVATCIndex(VATCode,BOn);

    {$IFDEF MC_On}

      If (Currency>0) then
        CurrF.ItemIndex:=Pred(Currency);

    {$ENDIF}

    VATNoF.Text:=Strip('R',[#32],VATRegNo);

    DiscF.Text:=PPR_PamountStr(Discount,CDiscCh);

    CCF.Text:=CustCC;
    DepF.Text:=CustDep;

    DNomF.Text:=Form_BInt(DefNomCode,0);
    DCNomF.Text:=Form_BInt(DefCOSNom,0);
    DMDCNomF.Text:=Form_BInt(DefCtrlNom,0);

    cePPDPercent.Value:=DefSetDisc;
    cePPDDays.Value:=DefSetDDays;

    AreaF.Text:=AreaCode;
    RepF.Text:=RepCode;

    RPayF.ItemIndex:=CPayType2Index(PayType);

    DDModeFEnter(RPayF);


    DDModeF.ItemIndex:=DirDeb;

    TagNF.Value:=DefTagNo;

    {RPayF.Text:=PayType;}

    // MH 31/03/2011 v6.7 ABSEXCH-10689: Added check on View Bank/Card Details permission
    // CJS 2013-10-30 - MRD1.1.14 - Added user-permissions for Consumers
    if ((CustFormMode = CUSTOMER_TYPE) and PChkAllowed_In(uaCustomerViewBankDets)) or
       ((CustFormMode = CONSUMER_TYPE) and PChkAllowed_In(uaViewConsumerBank)) or
       ((CustFormMode = SUPPLIER_TYPE) and PChkAllowed_In(uaSupplierViewBankDets)) then
    Begin
      //PR: 25/07/2013 Changed to use new SEPA fields
      BankAF.Text:=DecryptBankAccountCode(acBankAccountCode);
      BankSF.Text:=DecryptBankSortCode(acBankSortCode);
      BankRF.Text:=BankRef;

      if IsSales then
      begin
        //Mandate fields
        edtMandateID.Text := DecryptBankMandateId(acMandateID);
        edMandateDate.DateValue := acMandateDate;
      end;
    End // If (RecordMode and PChkAllowed_In(uaCustomerViewBankDets)) Or ((Not RecordMode) and PChkAllowed_In(uaSupplierViewBankDets))
    Else
    Begin
      BankAF.Text := StringOfChar('*', BankAF.MaxLength);
      BankSF.Text := StringOfChar('*', BankSF.MaxLength);
      BankRF.Text := StringOfChar('*', BankRF.MaxLength);

      //PR: 13/09/2013 ABSEXCH-14613 Hide contents of mandate fields.
      if RecordMode then
      begin
        //Mandate fields
        edtMandateID.Text :=  StringOfChar('*', edtMandateID.MaxLength);
        edMandateDate.DateValue := '';
      end;
    End; // Else

    // MH 10/11/2014 Order Payments: Rebadged Credit Card Fields as User Defined Fields 11-15
    CCDCardNoF.Text:=CCDCardNo;
    CCDSDateF.DateValue:=CCDSDate;
    CCDEDateF.DateValue:=CCDEDate;
    CCDNameF.Text:=CCDName;
    CCDIssF.Text:=CCDSARef;

    User1F.Text:=UserDef1;
    User2F.Text:=UserDef2;

    User3F.Text:=UserDef3;
    User4F.Text:=UserDef4;
    //GS 24/10/2011 ABSEXCH-11706: put customisation values into text boxes
    User5F.Text:=UserDef5;
    User6F.Text:=UserDef6;
    User7F.Text:=UserDef7;
    User8F.Text:=UserDef8;
    User9F.Text:=UserDef9;
    User10F.Text:=UserDef10;

    {$IF Defined(SOP) and Not Defined(LTE)}
      AWOF.Checked:=SOPAutoWOFF;

      HOACF.Checked:=(SOPConsHO=1);

      // CJS 2013-12-04 - MRD1.1.14 - Trader List - Consumers Record
      if CustFormMode <> CONSUMER_TYPE then
        HOACF.Visible:=(Trim(InvTF.Text)='');

      ConsolOrd.ItemIndex:=OrdConsMode;
    {$IFEND}

    DefUDF.Position:=FDefPageNo;

    FrmDefF.Value:=FDefPageNo;
    FrmDefF.Text:=Form_Int(FDefPageNo,0);

    {$IFDEF Frm}
      FSetNamF.Text:=pfGetMultiFrmDesc(FDefPageNo);
    {$ENDIF}

    {If (AccStatus In [2,3]) then
    Begin
      AcAcStatus.Color:=clRed;
      AcAcStatus.Font.Color:=clWhite;
    end
    else
    Begin
      AcAcStatus.Color:=clSilver;
      AcAcStatus.Font.Color:=clBlack;
    end;

    AcAcStatus.Caption:=LJVar(AccStatMess[AccStatus],17);}

    
    CTrad1F.Text:=STerms[1];
    CTrad2F.Text:=STerms[2];
    DCLocnF.Text:=Trim(DefMLocStk);

    EmailF.Text:=Trim(EmailAddr);
    emSendRF.Checked:=EmlSndRdr;
    emSendHF.Checked:=EmlSndHTML;

    emZipF.ItemIndex:=EmlZipAtc;
    emEbF.Checked:=(AllowWeb=1);

    ChangeCryptoKey (23130);

    emWebPWrdF.Text:=Decode(ebusPwrd);

    emWebPwrdFEnter(Nil);

    cbSendSta.ItemIndex:=SetSendSta(BOn,StatDMode);

    ManageSendInv(BOff,InvDMode);

    {cbSendInv.ItemIndex:=InvDMode;}

    User3F.Text:=UserDef3;
    User4F.Text:=UserDef4;
    PostCF.Text:=Trim(PostCode);

    // PKR. 14/01/2016. ABSEXCH-17099. Set the values of the Intrastat fields.
    if (Syss.Intrastat) then
    begin
      // PKR. 12/01/2016. ABSEXCH-17098. Intrastat.
      // Delivery Terms and Mode of Transport changed to drop-down lists.
      // Find the Delivery Terms entry in the list
      DefaultDeliveryTerms.ItemIndex := -1;
      for listIndex := 0 to DefaultDeliveryTerms.Items.Count-1 do
      begin
        if Uppercase(Trim(ExLocal.LCust.SSDDelTerms)) = Copy(DefaultDeliveryTerms.Items[listIndex], 1, 3) then
        begin
          DefaultDeliveryTerms.ItemIndex := listIndex;
          break;
        end;
      end;

      // Find the Mode of Transport in the list
      DefaultModeOfTransport.ItemIndex := -1;
      for listIndex := 0 to DefaultModeOfTransport.Items.count-1 do
      begin
        if Trim(IntToStr(ExLocal.LCust.SSDModeTr)) = Copy(DefaultModeOfTransport.Items[listIndex], 1, 1) then
        begin
          DefaultModeOfTransport.ItemIndex := listindex;
          break;
        end;
      end;

      // Added Default to QR checkbox.
      // PKR. 15/01/2016. Correction.  Changed Cust to ExLocal.LCust
      chkDefaultToQR.Checked := ExLocal.LCust.acDefaultToQR;
    end;

    // MH 05/09/2013 v7.XMRD MRD1.2.17: Added Auto-Receipt Support
    // MH 21/07/2014: Updated for Order Payments
    If panOrderPayments.Visible Then
    Begin
      chkAllowOrderPayments.Checked := acAllowOrderPayments;
      edtOrderPaymentsGLCode.Text := Form_BInt(acOrderPaymentsGLCode, 0);
    End; // If panOrderPayments.Visible

    // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
    lstAddressCountry.ItemIndex := ISO3166CountryCodes.IndexOf(ifCountry2, acCountry);
    lstDeliveryCountry.ItemIndex := ISO3166CountryCodes.IndexOf(ifCountry2, acDeliveryCountry);

    // PKR 19/11/2013. - MRD 7.X Item 2.4 - Ledger Multi-Contacts
    // Added to 7.0.9 20/01/2014.
    // MH 09/01/2014 v7.1 ABSEXCH-16008: Default the Country Code when adding a new role

    //PR: 09/03/2016 v2016 R1 ABSEXCH-17359 Remove this call as it isn't needed here and in some circumstances is
    //                                      wrongly enabling the delete button
    // CJS 2016-03-09 2016 R2 ABSEXCH-17367 - Replaced the call to the Roles
    // Frame, because it is needed to update the display. Ensured that it is
    // only called when the Roles tab is active.
    if (Current_Page = RolesPNo) then
    rolesframe.SetCustomerRecord(ExLocal.LCust.CustCode, ExLocal.LCust.acCountry);

    //PR: 06/05/2015 ABSEXCH-16284 v7.0.14 PPD T2-120 Select correct option on PPD list
    Case acPPDMode of
      pmPPDDisabled                         : cbPPDOptions.ItemIndex := 0;
      pmPPDEnabledWithAutoJournalCreditNote : cbPPDOptions.ItemIndex := 1;
      pmPPDEnabledWithAutoCreditNote,
      pmPPDEnabledWithManualCreditNote      : cbPPDOptions.ItemIndex := 2;
    end;

    SetUpOk:=BOn;

  end; {with..}

end; {Proc..}


Procedure TCustRec3.Form2Cust;

Begin

  With ExLocal.LCust do
  Begin

    // CJS 2013-10-01 - MRD1.1.14 - Trader List - Consumers Record
    if CustFormMode = CONSUMER_TYPE then
    begin
      acLongAcCode := FullLongAcCodeKey(AcCodeF.Text);
    end
    else
    CustCode:=FullCustCode(AcCodeF.Text);
    Company:=FullCompKey(CompF.Text);
    CustCode2:=FullCustCode2(AltCodeF.Text);

    Addr[1]:=Addr1F.Text;
    Addr[2]:=Addr2F.Text;
    Addr[3]:=Addr3F.Text;
    Addr[4]:=Addr4F.Text;
    Addr[5]:=Addr5F.Text;

    Contact:=ContactF.Text;
    Phone:=FullCustPhone(PhoneF.Text);

    Fax:=FaxF.Text;
    CreditLimit:=CrLimitF.Value;

    Phone2:=MobileF.Text;

    PayTerms:=Round(PayTF.Value);

    DAddr[1]:=DAddr1F.Text;
    DAddr[2]:=DAddr2F.Text;
    DAddr[3]:=DAddr3F.Text;
    DAddr[4]:=DAddr4F.Text;
    DAddr[5]:=DAddr5F.Text;
    { CJS 2013-08-08 - MRD2.5 - Delivery PostCode }
    acDeliveryPostCode := edtPostCode.Text;

    RefNo:=FullRefNo(TOurF.Text);

    RemitCode:=FullCustCode(StaF.Text);
    SOPInvCode:=FullCustCode(InvTF.Text);

    IncStat:=PStaF.Checked;
    EECMember:=chkECMember.Checked;

    With cbDefaultTaxCode do
      If (ItemIndex>=0) then
        VATCode:=Items[ItemIndex][1];

    {$IFDEF MC_On}

      Currency:=Succ(CurrF.ItemIndex);

    {$ENDIF}


    VATRegNo:=FullCVATKey(VATNoF.Text);

    ProcessInputPAmount(Discount,CDiscCH,DiscF.Text);


    CustCC:=CCF.Text;
    CustDep:=DepF.Text;

    DefNomCode:=IntStr(DNomF.Text);
    DefCOSNom:=IntStr(DCNomF.Text);
    DefCtrlNom:=IntStr(DMDCNomF.Text);

    AreaCode:=AreaF.Text;
    RepCode:=RepF.Text;

    DefTagNo:=Round(TagNF.Value);

    With RPayF do
      If (ItemIndex>=0) then
      Begin
        PayType:=Items[ItemIndex][1];
      end;

    DirDeb:=DDModeF.ItemIndex;

    {PayType:=RPayF.Text[1];}

    // MH 31/03/2011 v6.7 ABSEXCH-10689: Added check on View Bank/Card Details permission
    // CJS 2013-09-27 - MRD1.1.14 - Added support for Consumers
    // If (IsSales and PChkAllowed_In(uaCustomerViewBankDets)) Or ((Not IsSales) and PChkAllowed_In(uaSupplierViewBankDets)) Then
    if ((CustFormMode = CUSTOMER_TYPE) and PChkAllowed_In(uaCustomerViewBankDets)) or
       ((CustFormMode = CONSUMER_TYPE) and PChkAllowed_In(uaViewConsumerBank)) or
       ((CustFormMode = SUPPLIER_TYPE) and PChkAllowed_In(uaSupplierViewBankDets)) then
    Begin
      //PR: 09/09/2013 ABSEXCH-14598 Extend to encrypt SEPA fields
      acBankAccountCode  := EncryptBankAccountCode(BankAF.Text);
      acBankSortCode := EncryptBankSortCode(BankSF.Text);
      BankRef  := BankRF.Text;

      if IsSales then
      begin
        // D/D mandate fields
        acMandateDate := edMandateDate.DateValue;
        acMandateId := EncryptBankMandateId(edtMandateId.Text);
      end;
    End; // if ((CustFormMode = CUSTOMER_TYPE...

    // MH 10/11/2014 Order Payments: Rebadged Credit Card Fields as User Defined Fields 11-15
    CCDCardNo := CCDCardNoF.Text;
    CCDSDate  := CCDSDateF.DateValue;
    CCDEDate  := CCDEDateF.DateValue;
    CCDName   := CCDNameF.Text;
    CCDSARef  := CCDIssF.Text;

    UserDef1:=User1F.Text;
    UserDef2:=User2F.Text;

    UserDef3:=User3F.Text;
    UserDef4:=User4F.Text;
    //GS 24/10/2011 ABSEXCH-11706: write udef field values into customisation object
    UserDef5:=User5F.Text;
    UserDef6:=User6F.Text;
    UserDef7:=User7F.Text;
    UserDef8:=User8F.Text;
    UserDef9:=User9F.Text;
    UserDef10:=User10F.Text;

    {$IF Defined(SOP) and Not Defined(LTE)}
      SOPAutoWOff:=AWOF.Checked;
      SOPConsHO:=Ord(HOACF.Checked);
      OrdConsMode:=ConsolOrd.ItemIndex;
      DefMLocStk:=Full_MLocKey(DCLocnF.Text);
    {$ELSE}

      DefMLocStk:=DCLocnF.Text;
    {$IFEND}

    FDefPageNo:=DefUDF.Position;

    STerms[1]:=CTrad1F.Text;

    STerms[2]:=CTrad2F.Text;

    EmailAddr:=FullEmailAddr(EmailF.Text);
    EmlSndRdr:=emSendRF.Checked;
    EmlSndHTML:=emSendHF.Checked;

    EmlZipAtc:=emZipF.ItemIndex;
    AllowWeb:=Ord(emEbF.Checked);

    ChangeCryptoKey (23130);

    ebusPwrd:=Encode(emWebPWrdF.Text);

    If (cbSendSta.ItemIndex>-1) then
      StatDMode:=SetSendSta(BOff,cbSendSta.ItemIndex);

    {If (cbSendInv.ItemIndex>-1) then
      InvDMode:=cbSendInv.ItemIndex;}

    ManageSendInv(BOn,InvDMode);


    UserDef3:=User3F.Text;
    UserDef4:=User4F.Text;
    PostCode:=FullPostCode(PostCF.Text);

    // PKR. 14/01/2016. ABSEXCH-17098. Intrastat.
    // The Delivery Terms field now contains the Code and Description (or is blank)
    // We need to extract the Code for storage in the field.
    // If the field previously contained an invalid value, it will now be a null string.
    if (chkECMember.Checked) then
    begin
      if (Length(Trim(DefaultDeliveryTerms.Text)) > 2) then
      begin
        SSDDelTerms := Copy(Trim(DefaultDeliveryTerms.Text), 1, 3);
      end
      else
      begin
        // <3 chars, so it must either blank or invalid, so force it to blank.
        SSDDelTerms := '';
      end;

      // PKR. 11/01/2016. ABSEXCH-17098. Intrastat - 4.2 Trader Record.
      // Changed VATTMF to combo box, so we now have to convert the string value.
      // The field contains the Code and Description (or is blank), so we need to extract the Code.
      if (Length(Trim(DefaultModeOfTransport.Text)) > 0) then
      begin
        SSDModeTr := Round(StrToIntDef(Copy(DefaultModeOfTransport.Text, 1, 1), 0));
      end
      else
      begin
        SSDModeTr := 0;
      end;

      // Added "Default to QR" check box.
      acDefaultToQR := chkDefaultToQR.Checked
    end
    else
    begin
      // EC Member switched off, so set blanks.
      SSDDelTerms   := '';
      SSDModeTr     := 0;
      acDefaultToQR := false;
    end;

    //PR: 06/05/2015 ABSEXCH-16284 v7.0.14 PPD T2-120 Write back correct mode
    Case cbPPDOptions.ItemIndex of
      0 : acPPDMode := pmPPDDisabled;
      1 : acPPDMode := pmPPDEnabledWithAutoJournalCreditNote;
      2 : if IsSales then
            acPPDMode := pmPPDEnabledWithAutoCreditNote
          else
            acPPDMode := pmPPDEnabledWithManualCreditNote;
    end;

    // MH 26/06/2015 v7.0.14 ABSEXCH-16600: Added validation of PPD Percentage and Days
    If (acPPDMode <> pmPPDDisabled) Then
    Begin
      DefSetDisc := cePPDPercent.Value;
      DefSetDDays := Round(cePPDDays.Value);
    End // If (acPPDMode <> pmPPDDisabled)
    Else
    Begin
      DefSetDisc := 0.0;
      DefSetDDays := 0;
    End; // Else

    // MH 05/09/2013 v7.XMRD MRD1.2.17: Added Auto-Receipt Support
    // MH 21/07/2014: Updated for Order Payments
    If panOrderPayments.Visible Then
    Begin
      acAllowOrderPayments := chkAllowOrderPayments.Checked;
      acOrderPaymentsGLCode := IfThen (acAllowOrderPayments, IntStr(edtOrderPaymentsGLCode.Text), 0);
    End // If panOrderPayments.Visible
    // MH 30/07/2015 2015-R1 ABSEXCH-16702: Order Payments settings not validated on store
    Else
    Begin
      acAllowOrderPayments := False;
      acOrderPaymentsGLCode := 0;
    End; // Else

    // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
    // MH 26/01/2015 v7.1 ABSEXCH-16063: Modified country fields to use long names
    If (lstAddressCountry.ItemIndex >= 0) Then
      acCountry := ISO3166CountryCodes.ccCountryDetails[lstAddressCountry.ItemIndex].cdCountryCode2
    Else
      acCountry := '  ';
    If (lstDeliveryCountry.ItemIndex >= 0) Then
      acDeliveryCountry := ISO3166CountryCodes.ccCountryDetails[lstDeliveryCountry.ItemIndex].cdCountryCode2
    Else
      acDeliveryCountry := '  ';
  end; {with..}
end; {Proc..}


Procedure TCustRec3.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      MainPno
         :  If (LastEdit) then
            Begin
              If (CompF.CanFocus) then
                CompF.SetFocus
            end
            else
            Begin
              If (AcCodeF.CanFocus) then
                AcCodeF.SetFocus;
            end;

      DefaultPNo
         :  If (DAddr1F.CanFocus) then
              DAddr1F.SetFocus;

      eCommPNo
         :  If (RPayF.CanFocus) then
              RPayF.SetFocus;

    end; {Case&With..}

end; {Proc..}


Procedure TCustRec3.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  If (Pages[NewPage].TabVisible) then
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


Function TCustRec3.CheckNeedStore  :  Boolean;

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
    else If (Components[Loop] is TCheckBoxEx) then
      With (Components[Loop] as TCheckBoxEx) do
      Begin
        Result:=((Tag=1) and Modified);

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


Function TCustRec3.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;


  If (ExLocal.InAddEdit) and (CheckNeedStore) then
  Begin
    If (Current_Page>eCommPNo) then {* Force view of main page *}
      ChangePage(MainPno);

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                // CJS 2013-09-27 - MRD1.1.14 - Trader List - Consumers Record -
                // removed redundant 'IsCust' parameter
                StoreCust(CustF,CurrKeyPath^[CustF],ExLocal.LastEdit);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) then
                  Status:=UnLockMLock(CustF,LastRecAddr[CustF]);
              // SSK 09/03/2016 ABSEXCH–9455: Not resetting User Defined fields after cancelling an edit of Customer/Supplier record
               // bring the original values of the present customer
                LCust:=LastCust;
                SetCustStore(BOff,LastEdit);

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



procedure TCustRec3.SetCustStore(EnabFlag,
                                 ButnFlg  :  Boolean);

Var
  Loop : Integer;
  bAllowView, bAllowEdit : Boolean;
Begin
  OkCP1Btn.Enabled:=EnabFlag;
  CanCP1Btn.Enabled:=EnabFlag;

  AddCP1Btn.Enabled:=Not EnabFlag;
  EditCP1Btn.Enabled:=Not EnabFlag;
  FindCP1Btn.Enabled:=Not EnabFlag;
  DelCP1Btn.Enabled:=((Not EnabFlag) and (SetDelBtn));
  CISCP1Btn.Enabled:=((Not EnabFlag) and (CanCIS));
  HistCP1Btn.Enabled:=Not EnabFlag;
  InsCP3Btn.Enabled:=Not EnabFlag;
  PrnCP1Btn.Enabled:=Not EnabFlag;
  LettrBtn.Enabled:=Not EnabFlag;
  StatCP1Btn.Enabled:=Not EnabFlag;
  StkCCP1Btn.Enabled:=Not EnabFlag;
  TeleSCP1Btn.Enabled:=Not EnabFlag;
  ExLocal.InAddEdit:=EnabFlag;
  btnPIITree.Enabled := GDPRON and not EnabFlag; //PR: 01/12/2017 ABSEXCH-19479

  For Loop:=0 to ComponentCount-1 do
  Begin
    if Components[Loop].Tag = 1 then
    begin
    If (Components[Loop] is TMaskEdit) then
     TMaskEdit(Components[Loop]).ReadOnly := Not EnabFlag
    else If (Components[Loop] is TCurrencyEdit ) then
     TCurrencyEdit(Components[Loop]).ReadOnly := Not EnabFlag
    else If (Components[Loop] is TSBSComboBox) then
     TSBSComboBox(Components[Loop]).ReadOnly := Not EnabFlag
    else If (Components[Loop] is TEditDate) then
     TEditDate(Components[Loop]).ReadOnly := Not EnabFlag
    else If (Components[Loop] is TCheckBoxEx) then
     TCheckBoxEx(Components[Loop]).ReadOnly := Not EnabFlag
    else if (Components[Loop] is TUpDown) then
     TControl(Components[Loop]).Enabled := EnabFlag;
    end;
  end;

  With ExLocal do
    // CJS 2013-09-27 - MRD1.1.14 - amended for Consumers
    ACCodeF.ReadOnly := (
        (Not Enabled) or
        ((Not CanDelete) and
         (((CustFormMode = CUSTOMER_TYPE) and not PChkAllowed_In(uaDeleteCustomer)) or
          ((CustFormMode = CONSUMER_TYPE) and not PChkAllowed_In(uaDeleteConsumer)) or
          ((CustFormMode = SUPPLIER_TYPE) and not PChkAllowed_In(uaDeleteSupplier)))) and
        ((Not InAddEdit) or (LastEdit)) or
        ((ICEDFM<>0) and (LastEdit))
    );

(*
  If (ExLocal.InAddEdit) and (((RecordMode) and (Not PChkAllowed_In(240))) or ((Not RecordMode) and (Not PChkAllowed_In(242)))) then
  Begin
    BankAF.ReadOnly:=BOn;
    BankSF.ReadOnly:=BOn;
    BankRF.ReadOnly:=BOn;

  end;
*)

  // MH 31/03/2011 v6.7 ABSEXCH-10689: Added check on View Bank/Card Details permission
  If ExLocal.InAddEdit Then
  Begin
    // Add or Edit mode

    // Check whether user is allowed to view the Bank/Card Details
    // CJS 2013-09-27 - MRD1.1.14 - amended for Consumers
    bAllowView := ((CustFormMode = CUSTOMER_TYPE) and PChkAllowed_In(uaCustomerViewBankDets)) Or
                  ((CustFormMode = CONSUMER_TYPE) and PChkAllowed_In(uaViewConsumerBank)) or
                  ((CustFormMode = SUPPLIER_TYPE) and PChkAllowed_In(uaSupplierViewBankDets));

    // Check whether user is allowed to edit the Bank/Card Details
    // CJS 2013-09-27 - MRD1.1.14 - amended for Consumers
    bAllowEdit := bAllowView And
                  (((CustFormMode = CUSTOMER_TYPE) and PChkAllowed_In(uaCustomerEditBankDets)) Or
                   ((CustFormMode = CONSUMER_TYPE) and PChkAllowed_In(uaEditConsumerBank)) Or
                   ((CustFormMode = SUPPLIER_TYPE) and PChkAllowed_In(uaSupplierEditBankDets)));

    If (Not bAllowView) Then
    Begin
      // Not allowed to view - Disable fields and remove from tab order
      BankAF.TabStop := False;
      BankSF.TabStop := False;
      BankRF.TabStop := False;

      // CJS 2013-10-30 - MRD1.1 - User-permissions for Consumer Ledger - fix
      // for mandate fields
      edtMandateID.TabStop := False;
      edMandateDate.TabStop := False;
      edMandateDate.AllowBlank := True;
    End; // If (Not bAllowView)

    If (Not bAllowEdit) Then
    Begin
      // Not allowed to edit - make read-only
      BankAF.ReadOnly := BOn;
      BankSF.ReadOnly := BOn;
      BankRF.ReadOnly := BOn;

      // CJS 2013-10-30 - MRD1.1 - User-permissions for Consumer Ledger - fix
      // for mandate fields
      edtMandateID.ReadOnly := True;
      edMandateDate.ReadOnly := True;
      edMandateDate.AllowBlank := True;
    End; // If (Not bAllowEdit)

    // MH 05/09/2013 v7.XMRD MRD1.2.17: Added Auto-Receipt Support
    If panOrderPayments.Visible Then
    Begin
      // User only allowed to set Auto-Receipt details if user permission is set
      // CJS 2013-09-27 - MRD1.1.14 - amended for Consumers
      // MH 21/07/2014: Updated for Order Payments
      chkAllowOrderPayments.Enabled :=
        ((CustFormMode = CUSTOMER_TYPE) and PChkAllowed_In(uaCustomerAllowOrderPaymentsEdit)) or
        ((CustFormMode = CONSUMER_TYPE) and PChkAllowed_In(uaConsumerAllowOrderPaymentsEdit));

      // Auto-Receipts GL Code should only be enabled if the user has permissions and the checkbox is ticked
      edtOrderPaymentsGLCode.Enabled := chkAllowOrderPayments.Enabled And chkAllowOrderPayments.Checked
    End; // If panOrderPayments.Visible
  End; // If ExLocal.InAddEdit

  // CJS 2013-09-27 - MRD1.1.14 - amended for Consumers
  If (ExLocal.InAddEdit) and
     (
        ((CustFormMode = CUSTOMER_TYPE) and (Not PChkAllowed_In(uaEditCustomerCreditLimit))) or
        ((CustFormMode = CONSUMER_TYPE) and (Not PChkAllowed_In(uaEditConsumerCreditLimit))) or
        ((CustFormMode = SUPPLIER_TYPE) and (Not PChkAllowed_In(uaEditSupplierCreditLimit)))
     ) then
  Begin
    CRLimitF.ReadOnly:=BOn;
  end;

  If (EnabFlag) then
    DDModeFEnter(nil);

  //PR: 29/05/2015 ABSEXCH-16444
  cePPDPercent.Enabled := EnabFlag and (cbPPDOptions.ItemIndex > 0);
  cePPDDays.Enabled := cePPDPercent.Enabled;
end;


{ =============== Procedure to Find Next Availabel Code ============ }

Function TCustRec3.Auto_GetCCode(CCode    :  Str10;
                                 Fnum,
                                 Keypath  :  Integer)  :  Str10;



Var
  KeyS  :  Str255;

  TmpStat
        :  Integer;

  TmpRecAddr
        :  LongInt;
  TmpCust
        :  CustRec;

  NewNo :  Str10;

  PadLen:  Byte;

  n     :  SmallInt;



Begin


  TmpCust:=Cust;

  TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOff,BOff);

  n:=IntStr(Copy(CCode,5,2));

  Repeat

    KeyS:=FullCustCode(CCode);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    If (StatusOk) then
    Begin

      Inc(n);

      NewNo:=Form_Int(n,0);

      PadLen:=2+Ord(n>99);

      CCode:=Copy(CCode,1,CustKeyLen-PadLen)+SetPadNo(NewNo,PadLen);

    end;

  Until (Not StatusOk) or (n=999);

  TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOn,BOff);

  Cust:=TmpCust;

  Auto_GetCCode:=FullCustCode(CCode);

end; {Func..}


procedure TCustRec3.ACCodeFEnter(Sender: TObject);
begin
  {$IFDEF CU}
    If (Not ACCodeF.ReadOnly) and (Sender=ACCodeF) and (ActiveControl<>CanCP1Btn) and (Not ExLocal.LastEdit) then
    Begin
      ACCodeF.Text:=TextExitHook(1000,107+(1*Ord(Not IsSales)),ACCodeF.Text,ExLocal);
    end;
  {$ENDIF}

end;


procedure TCustRec3.ACCodeFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str255;
begin

  If (Sender is TMaskEdit) then
  With (Sender as TMaskEdit),ExLocal do
  Begin
    // CJS 2013-09-27 - MRD1.1.14 - Trader List - Consumers Record
    if CustFormMode = CONSUMER_TYPE then
    begin
      CCode := Trim(Text);
      if ((not LastEdit) or (Trim(LastCust.acLongAcCode) <> CCode)) and InAddEdit then
      begin
        COk := (not Check4DupliGen('U' + CCode, CustF, CustLongACCodeK, 'Account ('+Strip('B', [#32], CCode)+')'));
        if not COk then
        begin
          // If we're editing an existing record, restore the original code
          if LastEdit then
            Text := LastCust.acLongAcCode;
          ChangePage(0);
          AcCodeF.SetFocus;
          StopPageChange := BOn;
        end;
      end
      else
        StopPageChange := False;
    end
    else
    begin
    CCode:=FullCustCode(Text);

    If ((Not LastEdit) or (LastCust.CustCode<>CCode)) and (InAddEdit) then
    Begin
      COk:=(Not Check4DupliGen(CCode,CustF,CustCodeK,'Account ('+Strip('B',[#32],CCode)+')'));

      If (Not COk) then
      Begin

        Text:=Auto_GetCCode(CCode,CustF,CustCodeK);

        ChangePage(0);

        AcCodeF.SetFocus;

        StopPageChange:=BOn;
      end
      else
        StopPageChange:=BOff;


    end;
    end; { if CustFormMode... }
  end;
end;



procedure TCustRec3.PayTFExit(Sender: TObject);
begin
  If (ExLocal.InAddEdit) then
  Begin
    ChangePage(DefaultPNo);
    SetFieldFocus;
  end;
end;


(*  Add is used to add Customers *)

procedure TCustRec3.ProcessCust(Fnum,
                                KeyPAth    :  Integer;
                                Edit       :  Boolean;
                                IsCust     :  Boolean);

Var
  KeyS     :  Str255;

Begin

  Addch:=ResetKey;

  KeyS:='';

  SKeypath:=Keypath;

  Elded:=Edit;

  If (Edit) then
  Begin

    With ExLocal do
    Begin
      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      // MH 01/03/2011 v6.7 ABSEXCH-10687: Added Trader Audit Trail
      If (Status = 0) Then
      Begin
        TraderAudit := NewAuditInterface(atTrader);
        TraderAudit.BeforeData := LRecPtr[Fnum];
      End; // If (Status = 0)

      Report_BError(Fnum,Status);

      Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked);
    end;


    If (Not Ok) or (Not GlobLocked) then
      AddCh:=#27;
  end;



  If (Addch<>#27) then
  With ExLocal,LCust do
  begin

    LastCust:=LCust;

    If (Not Edit) then
    Begin
      // CJS 2013-09-30 - MRD1.1.14 - Consumers Record
      Caption := 'Add ' + TraderTypeNameFromSubType(SubTypeFromTraderType(CustFormMode)) + ' Record';

      LResetRec(CustF);

      CustSupp:=TradeCode[IsCust];
      case CustFormMode of
        CUSTOMER_TYPE: acSubType := 'C';
        CONSUMER_TYPE: acSubType := 'U';
        SUPPLIER_TYPE: acSubType := 'S';
      end;


      VATCode:=Syss.VATCode;
      STerms:=Syss.TermsofTrade;
      PayTerms:=Syss.PayTerms;

      // MH 19/06/2015 v7.0.14: Remove old Settlement Discount fields
      DefSetDisc:=0.0;//Syss.SettleDisc;
      DefSetDDays:=0;//Syss.SettleDays;

      PayType:=BACSCCode;

      IncStat:=ISCust;

      NLineCount:=1;

      EmlSndRdr:=BOn;

      {$IFDEF MC_On}

        Currency:=1;

      {$ENDIF}

      // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code - default
      // to country matching installation company code
      acCountry := DefaultCountryCode (CurrentCountry);
      acDeliveryCountry := DefaultCountryCode (CurrentCountry);
    end;

    OutCust;

    SetCustStore(BOn,BOff);

    SetFieldFocus;

  end; {If Abort..}

end; {Proc..}



Procedure TCustRec3.NoteUpdate;


Const
  Fnum     =  CustF;
  Keypath  =  CustCodeK;


Var
  KeyS  :  Str255;


Begin

  GLobLocked:=BOff;

  {$IFDEF NP}

    KeyS:=FullCustCode(NotesCtrl.GetFolio);

    {$IFDEF CU}
      If (Not EnableCustBtns(1000,62)) then
    {$ENDIF}
    With ExLocal do
    Begin
      Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPAth,Fnum,BOn,GlobLocked);

      If (Ok) and (GlobLocked) then
      With LCust do
      With NotesCtrl do
      Begin
        If (AccStatus=0) and (NLineCount<>GetLineNo) and (GetLineNo>1) then
        Begin
          AccStatus:=1;

          StatusF.Text:=Show_AccStatus(AccStatus);
        end;

        NLineCount:=GetLineNo;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        Report_Berror(Fnum,Status);

        {* Explicitly remove multi lock *}

        UnLockMLock(Fnum,0);
      end;

    end; {With..}

  {$ENDIF}


end; {Func..}



Procedure TCustRec3.Link2Footer;

Var
  Rnum    :  Double;
  GenStr  :  Str255;
  n       :  Byte;

Begin
  With Inv do
  Begin
    StatusLab.Caption:=Disp_HoldPStat(HoldFlg,Tagged,PrintedDoc,BOff,OnPickRun);

    // MH 24/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
    n := 0 +
         (1 * Ord((DiscSetAm<>0) Or (Inv.thPPDGoodsValue <> 0.0) Or (Inv.thPPDVATValue <> 0.0))) +
         (1 * Ord((DiscTaken=True) or (PDiscTaken=True) Or (Inv.thPPDTaken <> ptPPDNotTaken)));
         
    GenStr:=DiscStatus[n];

    If (Trim(GenStr)<>'') then
      StatusLab.Caption:=GenStr+' ! '+StatusLab.Caption;

    DueLab.Caption:=POutDate(DueDate);
    Rnum:=(Itotal(Inv)*DocCnst[InvDocHed]*DocNotCnst);
    TotLab.Caption:=FormatCurFloat(GenRealMask,Rnum,BOff,Currency);
  end;
end;


Function TCustRec3.ScanMode  :  Boolean;

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



Procedure TCustRec3.WMCustGetRec(Var Message  :  TMessage);


Var
  LastPage     :  TTabSheet;
  ReturnCtrl2  :  TReturnCtrlRec;
  DisplayMode  : Integer;
  Ok2Exe       : Boolean;
Begin
  Blank(ReturnCtrl2,Sizeof(ReturnCtrl2));

  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      0,1,169
         :  If (Current_Page In [LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo]) then
            Begin
              If (WParam=169) then
              Begin
                MULCtrlO[Current_Page].GetSelRec(BOff);
                WParam:=0;
              end;

              InHBeen:=((WParam=0) or ((InHBeen) and ScanMode));

              //PR: 15/02/2016 v2016 R1 ABSEXCH-17308 Check list scan security hook
              {$IFDEF CU}
              if (InHBeen) and ScanMode then
              begin
                 ExLocal.AssignFromGlobal(InvF);
                 Ok2Exe:=ExecuteCustBtn(2000,156,ExLocal);
              end
              else
              if (WParam=0) then
              begin
              // Add check for security hook point 150 (Edit) & 155 (View)
             {$B-}
               Ok2Exe:=((WParam = 0) and ValidSecurityHook(2000, 150, ExLocal)) or
                       ((Wparam = 1) and ValidSecurityHook(2000, 155, ExLocal));
             {$B+}
              end
              else
          {$ENDIF Customisation}
                OK2Exe := True;

              DisplayMode := 2 + (98*WParam);

              {$IFDEF SOP}
                // MH 12/11/2014 Order Payments: Prevent editing of Order Payments Paymetns and Refunds
                If (WParam = 0) And (Inv.thOrderPaymentElement In OrderPayment_PaymentAndRefundSet) Then
                  // Change to View mode - after discussion with QA it was decided not to have an annoying popup message
                  DisplayMode := 100;
              {$ENDIF SOP}

              //PR: 15/02/2016 v2016 R1 ABSEXCH-17308 Check list scan security hook
              if Ok2Exe then
                Display_Trans(DisplayMode);

              // CJS 18/03/2011 - ABSEXCH-9646
              If (MatchingFrm <> nil) and (WParam=1) then
                Display_Match(BOff,((Inv.RemitNo<>'') or (Inv.OrdMatch)));

              If (WParam=1) then
                Link2Footer;

              {$IFDEF JAP}  // SSK 02/02/2017 2017-R1 ABSEXCH-18021: disable delete button if Applied(Inv.InvNetVal) and Certified(Inv.TotalCost) amount is 0
                if (WParam = 1) and (Current_Page = JAppsPNo) then
                  DelCP1Btn.enabled := (Inv.InvNetVal = 0.0) and (Inv.TotalCost = 0.0);
              {$ENDIF}

              // SSK 04/12/2017 ABSEXCH-19536: Implements anonymisation behaviour for Transaction
              if (WParam = 1) and GDPROn then
              begin
                CopyCP1Btn.Enabled := not (Cust.acAnonymisationStatus = asAnonymised);
                Copy1.Enabled := CopyCP1Btn.Enabled;
              end;
            end
            else
              If (Current_Page=DiscPNo) then
              Begin
                {$IFDEF PF_On}
                  {$IFDEF STK}
                     // MH 30/06/2009 (20070903020954/20080625092406): Added check on password security
                     // CJS 2013-09-27 - MRD1.1.14 - amended for Consumers
                     if ((CustFormMode = CUSTOMER_TYPE) and PChkAllowed_In(uaEditCustomerDiscount)) or
                        ((CustFormMode = CONSUMER_TYPE) and PChkAllowed_In(uaEditConsumerDiscount)) or
                        ((CustFormMode = SUPPLIER_TYPE) and PChkAllowed_In(uaEditSupplierDiscount)) then
                       Display_QtyRec(2);
                  {$ENDIF}
                {$ENDIF}
              end
            else //PR: 20/04/2009
            If (Current_Page=MultiBuyPNo) then
            begin
              {$IFDEF SOP}
               MULCtrlO[Current_Page].GetSelRec(False);
               mbdFrame.EditDiscount;
              {$ENDIF}
            end;


      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      7  :  NoteUpDate; {* Update note line count *}

     17  :  Begin {* Force reset of form *}
              GotCoord:=BOff;
              SetDefault:=BOn;
              Close;
            end;


     25  :  NeedCUpdate:=BOn;

     18  :  Begin
              {$IFDEF STK}

                {If (Current_Page=DiscPNo) and (LParam=0) then
                  CQBMode:=BOff
                else}

              {$ENDIF}

              If (Current_Page In [LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo]) and (LParam=1) then {* Only refresh after an OK *}
              With MULCtrlO[Current_Page] do
              Begin

                AddNewRow(MUListBoxes[0].Row,(Bon));


              end;

            end;  

     110 :  Begin
              If (Current_Page<>MainPno) then
                ChangePage(MainPno);
              Show;
            end;

     170 :  PrnCp1BtnClick(nil);
     175
         :  If AllocateOk(BOff) and (Not SRCAlloc) then
            begin
              // RJ 29/03/2016 2016-R2 ABSEXCH-12296: Ctrl_PageUP and PageDwn issues fixed in the customer/Supplier Sales order/WorkBook Screen
              Last_Page:= PageControl1.ActivePageIndex;
              With PageControl1 do
                ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);
              {ChangePage(GetNewTabIdx(PageControl1,LParam));}
            end;

     177 :  Begin
              LastPage:=PageControl1.ActivePage;

              SetTabs2;

              If (PageControl1.ActivePage<>LastPage) then
                PageControl1.ActivePage:=LastPage;

              Check_TabAfterPW(PageControl1,Self,WM_CustGetRec);
            end;

     179 :  DispOUPtr:=nil;

     180 :  MatchingFrm := nil;

     200 :  DispTransPtr:=nil;



     {$IFDEF PF_On}
       {$IFDEF STK}

         118 :  With MULCtrlO2[Current_Page] do
                Begin

                  AddNewRow(MUListBoxes[0].Row,(LParam=1));

                  GetSelRec(BOff);


                  With MiscRecs^.CustDiscRec do
                  If (QBType=QBQtyBCode) and (Not CQBMode) then
                  Begin
                    Blank(LastQtyB,Sizeof(LastQtyB));

                    //PR: 08/02/2012 Use new Qty Breaks file ABSEXCH-9795
                    LastQtyB.qbCurrency := QBCurr; {* Force any qty breaks here to be of the same currency *}

                    CQBMode:=BOn;

                    Control_CQtyB(ExLocal.LCust,QStkCode,Self, MiscRecs.CustDiscRec);
                  end;

                end;

         119 : if Assigned(MULCtrlO2[Current_Page]) then
               With MULCtrlO2[Current_Page] do
               Begin
                 If (MUListBox1.Row<>0) then
                  PageUpDn(0,BOn)
                else
                  InitPage;
               end;

         120 : if Assigned(MULCtrlO[Current_Page]) then
               begin
                 {$IFDEF SOP}
                 Case Current_Page of
                   MultiBuyPNo : MBDFrame.RefreshCustList(ExLocal.LCust.CustCode);
                 end; //Case
                 {$ENDIF}
               end;


               {$B-}
         121 : If (Assigned(MULCtrlO[LedgerPNo])) and (Current_Page=LedgerPNo) then
               {$B+}
               With MULCtrlO[LEdgerPNo] do
               Begin
                 If (MUListBox1.Row<>0) then
                  PageUpDn(0,BOn)
                else
                  InitPage;
               end
               {$IFDEF SOP}
               else
               If (Assigned(MULCtrlO[MultiBuyPNo])) and (Current_Page=MultiBuyPNo) then
               {$B+}
               With MULCtrlO[MultiBuyPNo] do
               Begin
                 If (MUListBox1.Row<>0) then
                  PageUpDn(0,BOn)
                else
                  InitPage;
               end
               {$ENDIF}
               ;

         128  :  CQBMode:=BOff;

         205  :  Begin
                   QtyRec:=nil;
                 end;
       {$ENDIF}
     {$ENDIF}


     400,
     401  : Begin
              {$IFDEF Ltr}
                LetterActive:=Boff;
                LetterForm:=nil;
              {$ENDIF}
            end;

      3000,
      3001,
      3010,
      3011
         :  Begin
              If (WParam<3010) and (WindowState=wsMinimized) then
                WindowState:=wsNormal;

              If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) then
              Begin
                ShowLink;
              end;
            end;


     {$IFDEF GF}

       3002
          : If (Assigned(FindCust)) and (InFindDoc) then
              With MULCtrlO[LParam] do
              Begin
                ReturnCtrl2:=FindCust.ReturnCtrl;

                If (Assigned(FindCust)) then
                  FindCust.ReturnCtrl.InFindLoop:=BOn;

                With ReturnCtrl2 do
                Case SearchMode of
                  5  :  If Not FindxCode(SearchKey,SearchMode) then
                          if (SortViewEnabled) then
                            Find_OnLedger(SearchMode, SearchKey)
                          else
                            Find_OnList(SearchMode,SearchKey);
                  else
                    if (SortViewEnabled) then
                      Find_OnLedger(SearchMode, SearchKey)
                    else
                      Find_OnList(SearchMode,SearchKey);
                end; {Case..}

                With MUListBoxes[0] do
                  If (CanFocus) then
                    SetFocus;

                If (Assigned(FindCust)) then
                  FindCust.ReturnCtrl.InFindLoop:=BOff;

                {FreeandNil(FindCust);}
              end;
      {$IFDEF STK}
         3013
           :  With MULCtrlO2[LParam],ExLocal,LCust do
              Begin
                If FindxDiscCode(FullQDKey(CDDiscCode,CustSupp,FullCustCode(CustCode))+Trim(Stock.StockCode),0) then
                With MUListBoxes[0] do
                  If (CanFocus) then
                    SetFocus;

              end;
      {$ENDIF}



     {$ENDIF}

    end; {Case..}

  end;
  Inherited;
end;


Procedure TCustRec3.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      41 :  Begin
              HistFormPtr:=nil;

              If (MULCtrlO[LedgerPNo]<>nil) then
                MULCtrlO[LedgerPNo].LNHCtrl.NHNeedGExt:=BOff;
            end;

      44 :  Begin
              MatchFormPtr:=nil;
            end;

      52,53
         :  Begin
              If (Current_Page<>LedgerPNo) then
                ChangePage(LedgerPNo);



              If (MULCtrlO[LedgerPNo]<>nil) then
              With ExLocal,MULCtrlO[LedgerPNo],LNHCtrl do
              Begin
                ExLocal.AssignFromGlobal(NHistF);


                NHPr:=LNHist.Pr;
                NHYr:=LNHist.Yr;

                NHNeedGExt:=BOn;
                SDDMode:=BOn;

                RefreshList(BOn,BOn);


              end;

            end;

      64,65
         :  Begin
              InHBeen:=((WParam=64) or (InHBeen));

              Display_Trans(2);
            end;

    {$IFDEF JC}
         66  :  InCISVch:=BOff;

    {$ENDIF}

    {$IFDEF STK}
      145,146
         :  TeleSList[WParam=146]:=Nil;

    {$ENDIF}

    end; {Case..}

  end;

  Inherited;
end;


Procedure TCustRec3.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

Begin

  With Message.MinMaxInfo^ do
  Begin

    ptMinTrackSize.X:=200;
    ptMinTrackSize.Y:=210;

    {ptMaxSize.X:=530;
    ptMaxSize.Y:=368;
    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}

  end;

  Message.Result:=0;

  Inherited;

end;

Procedure TCustRec3.WMSysCommand(Var Message  :  TMessage);
Begin
  With Message do
    Case WParam of
      SC_Close    : Begin
                      // MH 04/04/2011 v6.7 ABSEXCH-10717: Recalc oldest dest if user uses Ctrl-F4, Close on the system menu or the caption close button to close the window
                      StartThread:=BOn; {Flag set here to avoid thread starting as Enterprise is closing}
                    End;
    end; {Case..}

  Inherited;
end;

{ == Procedure to Send Message to Get Record == }

Procedure TCustRec3.Send_UpdateList(Edit   :  Boolean;
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
    // CJS 24/09/2013 - MRD1.1.14 - Trader List - Consumers Record
    WParam:=Mode+100+CustFormMode;
    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}

// MH 26/06/2015 v7.0.14 ABSEXCH-16600: Added validation of PPD Percentage and Days
Function TCustRec3.CheckCompleted(Const Edit : Boolean; Var SetFocusOnError : Boolean)  : Boolean;

Const
  NofMsgs = 22;

Type
  PossMsgType  = Array[1..NofMsgs] of ANSIString;

Var
  PossMsg  :  ^PossMsgType;

  ShowMsg  :  Boolean;

  Test     :  Byte;

  mbRet    :  Word;

  FoundCode:  Str20;

  FoundLong:  LongInt;


Begin
  ShowMsg := True;
  New(PossMsg);

  PossMsg^[1]:='That Account Code already exists.';
  PossMsg^[2]:='That Account Code is not valid.';
  PossMsg^[3]:='The Account Code must end in a number.';
  PossMsg^[4]:='The ''Statement To'' Account Code is the same'+#13+'as the Account Code.';
  PossMsg^[5]:='The ''Statement To'' Account Code'+#13+'does not exist.';
  PossMsg^[6]:='The default Cost Centre Code is not valid.';
  PossMsg^[7]:='The default Department Code is not valid.';
  PossMsg^[8]:='The default Currency is not valid.';
  PossMsg^[9]:='The default G/L Code is not valid.';
  PossMsg^[10]:='The default Cost of Sales G/L Code'+#13+'is not valid.';
  PossMsg^[11]:='The default '+CCVATName^+' Code is not valid.';
  PossMsg^[12]:='The default Control G/L Code'+#13+'is not valid.';
  PossMsg^[13]:='The default EC '+CCVATName^+' Code is not valid for this type of account.';
  PossMsg^[14]:='The ''Invoice To'' Account Code is the same'+#13+'as the Account Code.';
  PossMsg^[15]:='The ''Invoice To'' Account Code'+#13+'does not exist.';
  // MH 30/07/2015 2015-R1 ABSEXCH-16702: Order Payments settings not validated on store
  PossMsg^[16]:='The Order Payments GL Code is not valid';
  // MH 12/09/2014 ABSEXCH-15625: Removed Auto-Receipt phrasing
  PossMsg^[17]:='The Currency for the Order Payments GL Code doesn''t match the Currency for this Account';
  PossMsg^[18]:='The Main Address Country is not valid';
  PossMsg^[19]:='The Delivery Address Country is not valid';
  PossMsg^[20]:='The Prompt Payment Discount Percentage must be between 0.00 and 99.99';
  PossMsg^[21]:='The Prompt Payment Discount Days must be between 0 and 999 days';
  PossMsg^[22]:='An additional check is made via an external hook';

  Test:=1;

  Result:=BOn;
  // MH 26/06/2015 v7.0.14 ABSEXCH-16600: Added validation of PPD Percentage and Days
  SetFocusOnError := True;

  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LCust do
  Begin
    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              // CJS 2013-09-27 - MRD1.1.14 - Trader List - Consumers Record
              if CustFormMode = CONSUMER_TYPE then
              begin
                if Trim(LastCust.acLongAcCode) <> Trim(acLongAcCode) then
                  Result:=Not (CheckExsists('U' + acLongAcCode, CustF, CustLongACCodeK))
              end
              else If (Not Edit) then
                Result:=Not (CheckExsists(CustCode,CustF,CustCodeK))
              else
                Result:=BOn;
            end;

      2  :  Result:=(Not EmptyKey(CustCode,CustKeyLen));

      3  :  Result:=((Not Syss.TradCodeNum) or (EINum(CustCode)));

      4  :  Result:=(RemitCode<>Custcode);

      5  :  Result:=((EmptyKey(RemitCode,CustKeyLen)) or (CheckExsists(RemitCode,CustF,CustCodeK)));

            //AP-27-06-2017- ABSEXCH-18682 - Error even when System is not using CC/Dep
      6  :  if (Syss.UseCCDep) then
              Result:=(EmptyKeyS(CustCC,CCKeyLen,BOff) or GetCCDep(Self,CustCC,FoundCode,BOn,-1));

            //AP-27-06-2017- ABSEXCH-18682 - Error even when System is not using CC/Dep
      7  :  if (Syss.UseCCDep) then
              Result:=(EmptyKeyS(CustDep,CCKeyLen,BOff) or GetCCDep(Self,CustDep,FoundCode,BOff,-1));

    {$IFDEF MC_On}
      8  :
               Result:=(Currency In [Succ(CurStart)..CurrencyType]);
    {$ENDIF}

      9  :   Result:=(DefNomCode=0) or (GetNom(Self,Form_Int(DefNomCode,0),FoundLong,-1));

      10 :   Result:=(DefCOSNom=0) or (GetNom(Self,Form_Int(DefCOSNom,0),FoundLong,-1));

      11 :   Result:=(VATCode In VATSet);

      12 :   Result:=(DefCtrlNom=0) or (GetNom(Self,Form_Int(DefCtrlNom,0),FoundLong,-1));

      13 :   Result:=(((IsaCust(CustSupp) and (VATCode = VATECDCode)) or
                     (Not IsaCust(CustSupp) and (VATCode = VATEECCode))) and (EECMember)) or
                     (Not (VATCode In VATEECSet));

      14 :  Result:=(SOPInvCode<>Custcode);

      15 :  Result:=((EmptyKey(SOPInvCode,CustKeyLen)) or (CheckExsists(SOPInvCode,CustF,CustCodeK)));

      // MH 05/09/2013 v7.XMRD MRD1.2.17: Added Auto-Receipt Support
      // MH 30/07/2015 2015-R1 ABSEXCH-16702: Order Payments settings not validated on store
      16 :  Begin
              // AOK if turned Off
              Result := (Not acAllowOrderPayments) And (acOrderPaymentsGLCode = 0);
              If (Not Result) Then
              Begin
                Result := GetNom (Self, Form_Int(acOrderPaymentsGLCode,0), FoundLong, -1, SUPPRESS_INACTIVE_GLCODES);

                // Must be Balance Sheet
                If Result Then
                  Result := (Nom.NomType = BankNHCode);

                // If GL Classes are turned on then it must also be a Bank Account
                If Result And Syss.UseGLClass Then
                  Result := (Nom.NomClass = 10); // 10 = Bank Account
              End; // If (Not Result)

              If (Not Result) And edtOrderPaymentsGLCode.CanFocus Then
              Begin
                edtOrderPaymentsGLCode.SetFocus;
                SetFocusOnError := False;
              End; // If (Not Result) And edtOrderPaymentsGLCode.CanFocus
            End; // 16

      // MH 21/07/2014: Updated for Order Payments
      17 :  Result := (acOrderPaymentsGLCode = 0)
                      Or
                      (GetNom(Self,Form_Int(acOrderPaymentsGLCode,0),FoundLong,-1)
                       {$IFDEF MC_On}
                       // MH 10/09/2014 ABSEXCH-15610: Added check for GL Code beign Consolidated
                       and ((Nom.DefCurr = 0) Or (Nom.DefCurr = Currency))
                       {$ENDIF}
                      );

      // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code - default
     18 :   Begin // Address Country
              Result := (Trim(acCountry) <> '') And ValidCountryCode (ifCountry2, acCountry);
              If (Not Result) And lstAddressCountry.CanFocus Then
              Begin
                lstAddressCountry.SetFocus;
                SetFocusOnError := False;
              End; // If (Not Result) And lstAddressCountry.CanFocus
            End;
     19 :   Begin // Delivery Address Country
              // Validate Delivery Postcode if any part of the delivery address is set
              If (Trim(DAddr[1]) <> '') Or (Trim(DAddr[2]) <> '') Or (Trim(DAddr[3]) <> '') Or
                 (Trim(DAddr[4]) <> '') Or (Trim(DAddr[5]) <> '') Or (Trim(acDeliveryPostCode) <> '') Then
              Begin
                Result := (Trim(acDeliveryCountry) <> '') And ValidCountryCode (ifCountry2, acDeliveryCountry);
                If (Not Result) And lstDeliveryCountry.CanFocus Then
                Begin
                  lstDeliveryCountry.SetFocus;
                  SetFocusOnError := False;
                End; // If (Not Result) And lstAddressCountry.CanFocus
              End // If (Trim(DAddr[1]) <> '') Or (
              Else
                Result := True;
            End;

      // MH 26/06/2015 v7.0.14 ABSEXCH-16600: Added validation of PPD Percentage and Days
      // 'The Prompt Payment Discount Percentage must be between 0.00 and 99.99';
      20 :  Begin
              Result := (DefSetDisc >= 0.0) And (DefSetDisc <= 99.99);
              If (Not Result) And cePPDPercent.CanFocus Then
              Begin
                cePPDPercent.SetFocus;
                SetFocusOnError := False;
              End; // If (Not Result) And cePPDPercent.CanFocus
            End; // 17

      // 'The Prompt Payment Discount Days must be between 0 and 999 days';
      21 :  Begin
              Result := (DefSetDDays >= 0) And (DefSetDDays <= 999);
              If (Not Result) And cePPDDays.CanFocus Then
              Begin
                cePPDDays.SetFocus;
                SetFocusOnError := False;
              End; // If (Not Result) And cePPDPercent.CanFocus
            End; // 18

      22 :  Begin {* Opportunity for hook to validate this line as well *}
                 {$IFDEF CU}

                   Result:=ValidExitHook(1000,60+Ord(IsSales),ExLocal);
                   ShowMsg:=BOff;

                 {$ENDIF}
              end;
    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) then
    mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}



// CJS 2013-09-27 - MRD1.1.14 - Trader List - Consumers Record -
// removed redundant 'IsCust' parameter
procedure TCustRec3.StoreCust(Fnum,
                              KeyPAth    :  Integer;
                              Edit       :  Boolean);
Var

  COk  :  Boolean;
  TmpCust
       :  CustRec;
  KeyS :  Str255;

  MbRet:  Word;

  Renumbed
       :  Boolean;
  NewCCode
       :  Str10;

  //PR: 18/10/2011
  oAuditNote : TAuditNote;

  //PR: 14/02/2014 ABSEXCH-15038
  oContactsManager : TContactsManager;

  // MH 26/06/2015 v7.0.14 ABSEXCH-16600: Added validation of PPD Percentage and Days
  SetFocusOnError : Boolean;
Begin
  KeyS:='';

  // MH 26/06/2015 v7.0.14 ABSEXCH-16600: Added validation of PPD Percentage and Days
  SetFocusOnError := True;

  Renumbed:=BOff;

  Form2Cust;

  With ExLocal,LCust do
  Begin
    {$IFDEF CU} {* Call any pre store hooks here *}

      GenHooks(1000,2,ExLocal);
      {Refresh cust in case any updates have taken place}
      OutCust;

    {$ENDIF}

    // CJS 2013-09-27 - MRD1.1.14 - Trader List - Consumers Record - create
    // the new Consumer code
    if not Edit and (CustFormMode = CONSUMER_TYPE) then
      LCust.CustCode := NextConsumerCode;

    If (Edit) and (LastCust.CustCode<>CustCode) then
    Begin
      COk:=(Not Check4DupliGen(CustCode,Fnum,CustCodeK,'Account'));
    end
    else
      COk:=BOn;

    If (COk) then
      // MH 26/06/2015 v7.0.14 ABSEXCH-16600: Added validation of PPD Percentage and Days
      COk:=CheckCompleted(Edit, SetFocusOnError);

    If (COk) then
    Begin
      COk:=(Not EmptyKey(CustCode,AcCodeF.MaxLength));

      If (Not COk) then
        mbRet:=MessageDlg('Account Code not valid!',mtError,[mbOk],0);
    end;

    If (COk) then
    Begin
      //PR: 18/10/2011
      oAuditNote := TAuditNote.Create(EntryRec^.Login, @F[PwrdF]);

      Cursor:=crHourGlass;

      LastUsed:=Today;
      TimeChange:=TimeNowStr;

      CheckCustNdx(LCust);

      If (Edit) then
      Begin
        If (LastCust.CustCode<>CustCode) then
        Begin
          NewCCode:=CustCode;
          CustCode:=LastCust.CustCode;

          {$IFDEF POST}
            Renumbed:=BOn;

            //PR: 14/02/2014 ABSEXCH-15038 Pass a reference to the contact manager through to the AccountCodeChange function
            if Assigned(rolesFrame) then
              oContactsManager := rolesFrame.ContactsManager
            else
              oContactsManager := nil;

            If AccountCodeChange(LCust,NewCCode,TForm(Self.Owner){$IFNDEF SCHEDULER}, oContactsManager{$ENDIF}) then
            Begin
              {Trigger hook to notify}

              {$IFDEF CU}
              {TextExitHook(1000,110,NewCCode,ExLocal); {*Call with pre change record, then with changed record*}
              TextExitHook(1000,111,NewCCode,ExLocal);
              {$ENDIF}
            end;
          {$ENDIF}
        end;

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpCust:=LCust;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LCust:=TmpCust;

        end;


        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        // MH 01/03/2011 v6.7 ABSEXCH-10687: Added Trader Audit Trail
        If (Status = 0) And Assigned(TraderAudit) Then
        Begin
          TraderAudit.AfterData := LRecPtr[Fnum];
          TraderAudit.WriteAuditEntry;
          TraderAudit := NIL;
        End; // If (Status = 0)

        //PR: 18/10/2011 Add audit history note //ABSEXCH-11745 v6.9
        if (Status = 0) and Assigned(oAuditNote) then
          oAuditNote.AddNote(anAccount, LCust.CustCode, anEdit);
      end
      else
      Begin
        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
        CanDelete:=BOn;

        //PR: 18/10/2011 Add audit history note //ABSEXCH-11745 v6.9
        if (Status = 0) and Assigned(oAuditNote) then
          oAuditNote.AddNote(anAccount, LCust.CustCode, anCreate);
      end;

      // CJS 2013-11-26 MRD1.1.14 - amendments for Consumer Ledger
      if CustFormMode = CONSUMER_TYPE then
      begin
        AcCodeF.Text := Strip('B', [#32], AcLongAcCode);
        AcShortCodeTxt.Caption := '(Short Code: ' + Strip('B', [#32], CustCode) + ')';
      end;

      oAuditNote.Free;

      // CJS 2013-09-23 - added support for Consumers
      SetFormCaption;

      Report_BError(Fnum,Status);

      LGetRecAddr(Fnum);  {* Refresh record address *}

      If (StatusOk) then
      Begin
        Send_UpdateList(Edit,0);


      end;

      If (Edit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      {$IFDEF CU} {* Call any pre store hooks here *}
        GenHooks(1000,3,ExLocal);
      {$ENDIF}

      SetCustStore(BOff,Edit);

      Cursor:=CrDefault;

      LastValueObj.UpdateAllLastValues(Self);


      If (HideDAdd) then
      Begin
        HideDAdd:=BOff;
        SetTabs2;
      end;

      If (Renumbed) then {Force a close}
        PostMessage(Self.Handle,WM_Close,0,0);

      InAddEdit:=BOff;
      LastEdit:=BOff;


    end
    else
    Begin

      {ChangeNBPage(1);}

      // MH 26/06/2015 v7.0.14 ABSEXCH-16600: Added validation of PPD Percentage and Days
      If SetFocusOnError Then
        SetFieldFocus;

    end;
 end; {If..}

end;



procedure TCustRec3.OkCP1BtnClick(Sender: TObject);

Var
  ISValid : Boolean; // Instrastat is valid
begin

  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult=mrOk) then
      Begin
        // MH 20/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
        //                                   fields which processes the text and updates the value
        If (ActiveControl <> OkCP1Btn) Then
          // Move focus to OK button to force any OnExit validation to occur
          OkCP1Btn.SetFocus;

        // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
        If (ActiveControl = OkCP1Btn) Then
        begin
          // PKR. 13/01/2016. ABSEXCH-17098. Intrastat - Trader Record.
          // Validate the EC Member flag setting against the Address Country
          // PKR. 18/01/2016. ABSEXCH-17152. ONly validate if Intrastat switched on.
          ISValid := true;
          if (Syss.IntraStat) then
          begin
            ISValid := ValidateECMemberField;
          end;

          // PKR. 14/01/2016. Following code-review, it was decided that there is no need to validate
          // The Delivery Terms and Mode of Transport fields, because:
          // 1) The field is now a drop-down list, so no invalid entries can be entered.
          // 2) The field is a default value only, so it can be left blank.
          // 3) If an invalid value exists, it will be converted to blank by virtue of the fact that
          //    the value could not be found in the list when it is loaded in the form.
          // Validate the Delivery Terms
          {
          if (ISValid) then
          begin
            ISValid := DeliveryTermsFieldIsValid;
          end;

          if (ISValid) then
          begin
            ISValid := ModeOfTransportFieldIsValid;
          end;
          }

          if (ISValid) then
          begin
            // CJS 2013-09-27 - MRD1.1.14 - Trader List - Consumers Record -
            // removed redundant 'IsCust' parameter
            StoreCust(CustF,CurrKeyPath^[CustF],ExLocal.LastEdit);
          end;
        end
      End // If (ModalResult=mrOk)
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
              LCust:=LastCust;

            OutCust;

            If (HideDAdd) then
            Begin
              HideDAdd:=BOff;
              SetTabs2;
            end;

            ExLocal.InAddEdit:=BOff;
            ExLocal.LastEdit:=BOff;

          end;
        end;
    end; {With..}
end;

procedure TCustRec3.EditAccount(Edit  :  Boolean);
begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    HideDAdd:=BOn;

    If (HideDAdd) then
      SetTabs2;

    If (Not Edit) then
      ChangePage(MainPno);

    ProcessCust(CustF,CurrKeyPath^[CustF],LastEdit,RecordMode);

  end;
end;


procedure TCustRec3.DeleteAccount;

Const
  Fnum  =  CustF;


Var
  MbRet  :  Word;
  KeyS   :  Str255;
  lRes,
  Keypath:  Integer;
  lAnonDiaryDetail: IAnonymisationDiaryDetails;
  lAnonEntityType: TAnonymisationDiaryEntity;
Begin

  MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Account',
                     mtConfirmation,[mbYes,mbNo],0);


  If (MbRet=MrYes) then
  With ExLocal do
  Begin

    Keypath:=CurrKeyPath^[Fnum];

    LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

    Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

    Report_BError(Fnum,Status);

    Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOff,GlobLocked);

    If (Ok) and (GlobLocked) then
    Begin

      //PR: 14/02/2014 ABSEXCH-15040 Delete all contacts for this account. Must delete before deleting the account to
      //                             avoid SQL Server error
      if Assigned(rolesFrame) then
        rolesFrame.ContactsManager.DeleteAllContacts;

      Status:=Delete_Rec(F[CustF],CustF,CurrKeyPath^[CustF]);

      Report_BError(CustF,Status);

      If (StatusOk) then {* Delete any dependant links etc *}
      Begin
        {* Delete notes & Qty breaks *}

        Delete_Notes(NoteCCode,LCust.CustCode) ; {* Auto Delete Notes *}

        {$IFDEF STK}

          {$IFDEF PF_On} {* Delete Discount Matrix & Qty Break *}

            KeyF:=FullQDKey(QBDiscCode,LCust.CustSupp,FullCustCode(LCust.CustCode));
            DeleteLinks(KeyF,MiscF,Length(KeyF),MIK,BOff);

            
            
     		   {SS 21/03/2016 2016-R2
            ABSEXCH-17147: When deleting Trader/Stock Records from Exchequer
                           quantity break discounts are not removed from QTYBREAK table.
            - Clear deleted Customer/Supplier specific data from the QTYBREAK table.}

            KeyF := FullCustCode(LCust.CustCode);
            DeleteLinks(KeyF,QtyBreakF, Length(KeyF), qbAcCodeIdx, BOff);

            KeyF:=FullQDKey(CDDiscCode,LCust.CustSupp,FullCustCode(LCust.CustCode));

            DeleteLinks(KeyF,MiscF,Length(KeyF),MIK,BOff);

            {* Delete CuStk History *}

            KeyF:=PartCCKey(MatchTCode,MatchSCode)+FullCustCode(LCust.CustCode);

            DeleteLinks(KeyF,MLocF,Length(KeyF),MLK,BOff);

            cu_DeleteHistory(LCust.CustCode,BOff);


          {$ENDIF}

        {$ENDIF}

        {$IFDEF Ltr}
          { Delete any letters }
          DeleteLetters (TradeCode [IsACust(LCust.CustSupp)], LCust.CustCode);
        {$ENDIF}

        //HV ABSEXCH-19607:Delete record from exchequer should remove Data from Anon. Control centre window.
        //Record Delete from Anon. Diary Table
        if GDPROn then
        begin
          lAnonDiaryDetail := CreateSingleAnonObj;
          if Assigned(lAnonDiaryDetail) then
          begin
            if IsACust(LCust.CustSupp) then
              lAnonEntityType := adeCustomer
            else
              lAnonEntityType := adeSupplier;

            lRes := lAnonDiaryDetail.RemoveEntity(lAnonEntityType, LCust.CustCode);
            if lRes = 0 then
              SendMessage(Application.MainForm.Handle, WM_FormCloseMsg, 103, 0);
          end;
        end;

        Send_UpdateList(Boff,200);

        {$IFDEF CU} {* Call any pre store hooks here *}
          GenHooks(1000,4,ExLocal);
        {$ENDIF}


        Close;
      end;
    end;

  end;
end; {PRoc..}




procedure TCustRec3.EditCP1BtnClick(Sender: TObject);
begin

  Case Current_Page of
    NotesPNo
         :  AddCP3BtnClick(Sender);

    {$IFDEF PF_On}
      {$IFDEF STK}
        DiscPNo
         :  With MULCtrlO2[Current_Page] do
            If (ValidLine) or (Sender=AddCP1Btn) or (Sender=Add1) then
            Begin
              If (ValidLine) then
                GetSelRec(BOff);

              Case Current_Page of
                DiscPNo  :  Display_QtyRec(1+Ord((Sender=EditCP1Btn) or (Sender=Edit1)));
              end; {Case..}
            end;
      {$ENDIF}
    {$ENDIF}

    // PKR 03/10/2013  - MRD 7.X Item 2.4 - Ledger Multi-Contacts
    // Edit or Add a Contact
    // Added to 7.0.9 20/01/2014.
    RolesPNo :
      begin
        if (Sender = AddCP1Btn) or (Sender = Add1) then
        begin
          rolesFrame.AddNewContact;
        end
        else
        begin
          if (Sender = EditCP1Btn) or (Sender = Edit1) then
          begin
            rolesFrame.EditCurrentContact;
          end;
        end;
      end;

    LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo
       :  ViewCP1BtnClick(Sender);
    {$IFDEF SOP}
    MultiBuyPNo
       : if (Sender = EditCP1Btn) then
         begin //PR: 18/06/2009 Wasn't checking ValidLine (FR v6.01.073)
           if MULCtrlO[Current_Page].ValidLine then
           begin
             MULCtrlO[Current_Page].GetSelRec(False);
             mbdFrame.EditDiscount;
           end;
         end
         else
           mbdFrame.AddDiscount;
    {$ENDIF}
    else
    begin
      FListScanningOn := True;
      AnonymisationON := FAnonymisationON and (Sender=EditCP1Btn);
      EditAccount((Sender=EditCP1Btn));
    end;
  end; {Case..}

end;


procedure TCustRec3.SetJAPOptions;


Var
  TmpCISBo  :  Boolean;


begin
  {$IFDEF JC}
     {$B-}
     If (Not IsSales) then
     Begin
       TmpCISBo:=BOff;

       ASC1.Visible:=(Check_AnyEmployee(ExLocal.LCust.CustCode)='') and ChkAllowed_In(221);

       CanCIS:=(CISOn) and (Not IsSales) and (Check_CISEmployee(ExLocal.LCust.CustCode,TmpCISBo)<>'');

       CanJAP:=(JAPOn) and (Not IsSales) and (Not ASC1.Visible);

       CISCP1Btn.Enabled:=CanCIS or CanJAP or (ASC1.Visible);;

       SCCIS1.Visible:=CanCIS;
       SC1.Visible:=CanJAP and ChkAllowed_In(221);

       JobApplicationsPage.TabVisible:=CanJAP and (Not IsSales) and ChkAllowed_In(464) and (Not HideDAdd);

       UpdateSubMenu(PopUpMenu9,PM9Cnt,CISLedger1);
     end;
     {$B+}
  {$ENDIF}
end;

procedure TCustRec3.ShowLink;
const
  //PR: 25/07/2013 SEPA - distance to move panels up to cover for hidden Direct Debit Mandate fields;
  DistanceToMove = 40;

begin
  ExLocal.AssignFromGlobal(CustF);
  ExLocal.LGetRecAddr(CustF);

  // CJS 2013-09-23 - MRD1.1.14 - added support for Consumers
  SetFormCaption;

  // CJS 21/05/2010 - Changed Telesales button to only disable on 'Closed' status
  // MH 28/05/2015 v7.0.14: Moved into PrimeButton for consistency now that this routine is calling PrimeButtons
  //TeleSCP1Btn.Enabled := not (ExLocal.LCust.AccStatus=3);

  OutCust;

  // MH 28/05/2015 v7.0.14 ABSEXCH-16439: Re-enable/disable buttons based on new account record
  PrimeButtons;

  // MH 18/06/2015 v7.0.14 ABSEXCH-16559: Show/Hide the Ledger PPD columns as account changes
  If Assigned(MULCtrlO[LedgerPNo]) Then
  Begin
    // Lock the window to make the painting appear snappier
    LockWindowUpdate(Self.Handle);
    Try
      // Hide/Show the PPD Columns - this affects the panels and header labels
      HidePanels(LedgerPNo);

      // RefreshAllCols will cause the grids in the columns to be shown/hidden and the data
      // refreshed - this is a little sluggish. Calling ReSizeOneCol instead performs better
      // but you do briefly see whatever data was in the column the last time it was visible
//      MULCtrlO[LedgerPNo].RefreshAllCols;

      // Calling ReSizeOneCol actually hides/shows the grids in the columns
      MULCtrlO[LedgerPNo].MUListBoxes[9].Cols[0].Clear;
      MULCtrlO[LedgerPNo].ReSizeOneCol(9);
      MULCtrlO[LedgerPNo].MUListBoxes[10].Cols[0].Clear;
      MULCtrlO[LedgerPNo].ReSizeOneCol(10);

      // Resize the column header panel
      MULCtrlO[LedgerPNo].VisiList.SetHedPanel(ListOfSet);
    Finally
      LockWindowUpdate(0);
    End; // Try..Finally
  End; // If Assigned(MULCtrlO[LedgerPNo])

  CanDelete:=Ok2DelAcc(ExLocal.LCust.CustCode);

  {$IFDEF JC}
    {$IFDEF JAP}
      {$IFNDEF SOPDLL}
         If (CanDelete and JBCostOn) then
           CanDelete:=(Check_AnyEmployee(ExLocal.LCust.CustCode)='');

      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  SetJapOptions;


  DelCP1Btn.Enabled:=SetDelBtn;

  DDModeF.Visible:=RecordMode;




  {Label833.Visible:=(Not RecordMode);}

  Case Current_Page of

    NotesPNo
       :  {$IFDEF NP}
            If (NotesCtrl<>nil) then {* Assume record has changed *}
            With ExLocal do
            Begin
              NotesCtrl.RefreshList(LCust.CustCode,NotesCtrl.GetNType);
              NotesCtrl.GetLineNo:=LCust.NLineCount;
            end;

          {$ELSE}

            ;
          {$ENDIF}

    {$IFDEF PF_On}
      {$IFDEF STK}
       DiscPNo
         :   RefreshValList(BOn,BOff);
      {$ENDIF}
    {$ENDIF}

    //PR: 02/04/2009 Added MultiBuy Discounts
    {$IFDEF SOP}
    MultiBuyPNo
        : mbdFrame.RefreshCustList(ExLocal.LCust.CustCode);
    {$ENDIF}

    LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo
         :  begin
              if Current_Page = LedgerPNo then      // SSK 31/03/2017 2017-R1 ABSEXCH-15992: need to reset the GlobalAllocRec when trader account is changed
                if not SBSIN then                   // SSK 12/06/2018 2018-R1.1 ABSEXCH-19640: if condition added to prevent 'The Warning message' when debit transaction is allocated after Trader Record Switch
                  ResetGlobAlloc(IsSales);
              RefreshList(BOn,BOff);
            end;
  end; {Case..}

  SetAnonymisationStatusDate;
  
  If (HistFormPtr<>nil) then
    Display_History(LastHMode,BOff);

  {$IFDEF Ltr}
    { Check for link to letters }
    If Assigned(LetterForm) And LetterActive Then
      If (LetterForm.WindowState <> wsMinimized) Then Begin
        {ShowLink(True);}
        LetterForm.LoadLettersFor (ExLocal.LCust.CustCode,
                                   ExLocal.LCust.CustCode,
                                   Trim(ExLocal.LCust.CustCode),
                                   TradeCode[IsACust(ExLocal.LCust.CustSupp)],
                                   @Exlocal.LCust, Nil, Nil, Nil, Nil);
      End; { If }
  {$ENDIF}


  {$IFDEF STK}
    If (Assigned(TeleSList[BOff])) then
    Begin
      StkCCP1BtnClick(Nil);
    end;

    {If (Assigned(TeleSList[BOn])) then Do not allow list scan of #TeleSales, too dodgey!
    Begin
      StkCCP1BtnClick(TeleSales1);
    end;}

  {$ENDIF}

  {$IFDEF CU} {* Call any pre store hooks here *}

    GenHooks(1000,08,ExLocal);

  {$ENDIF}


end;


procedure TCustRec3.SetFieldProperties;
Var
  n  : Integer;
Begin
  SBSPanel4.Color:=SBSPanel1.Color;

  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) and (Components[n]<>AcCodeF) then
    With TGlobControl(Components[n]) do
      If (Tag>0) or ((Self.Components[n]=CCDSDateF) or (Self.Components[n]=CCDEDateF)) then
      Begin
        Font.Assign(AcCodeF.Font);
        Color:=AcCodeF.Color;
      end;
  end; {Loop..}
end;


procedure TCustRec3.SetFormProperties;

//Const
//  PropTit     :  Array[0..2] of Str10 = ('Record','Ledger','Discount List');

Var
  TmpPanel    :  Array[1..3] of TPanel;

  ListChange  :  Byte;

Begin
  ListChange:=Ord(Current_Page In [DiscPNo..RetPNo]);

  ListChange:=ListChange+Ord(Current_Page=DiscPNo);

  //PR: 05/11/2010 Changed to use new Window Position System
  if Assigned(FSettings) then
  begin
    Case ListChange of
      0 :
          if FSettings.Edit(MainPage, ACCodeF) = mrOK then
          begin
            NeedCUpdate := True;
            FColorsChanged := True;
            FSettings.ParentToSettings(DefaultsPage, ACCodeF);
            FSettings.ParentToSettings(eCommPage, ACCodeF);
            if (rolesPage <> nil) then
            begin
              FSettings.ParentToSettings(RolesPage, ACCodeF);
            end;
            FSettings.SettingsToParent(DefaultsPage);
            FSettings.SettingsToParent(eCommPage);
            if Assigned(rolesFrame) then
            begin
              FSettings.SettingsToParent(RolesPage);
              rolesFrame.OnResize(self); //  .CalcRoleBoxSize;
            end;
          end;
      1 : if FSettings.Edit(MULCtrlO[Current_Page], MULCtrlO[Current_Page]) = mrOK then
          begin
            NeedCUpdate := True;
            FColorsChanged := True;
          end;
      {$IFDEF STK}
      2 : if FSettings.Edit(MULCtrlO2[Current_Page], MULCtrlO2[Current_Page]) = mrOK then
          begin
            NeedCUpdate := True;
            FColorsChanged := True;
          end;
      {$ENDIF STK}
    end; //Case
  end;
end;



procedure TCustRec3.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;
  Filter1.Checked:=InOSFilt;

  Custom1.Caption:=CustdbBtn1.Caption;
  Custom2.Caption:=CustdbBtn2.Caption;
  // 17/01/2013 PKR ABSEXCH-13449
  Custom3.Caption:=CustdbBtn3.Caption;
  Custom4.Caption:=CustdbBtn4.Caption;
  Custom5.Caption:=CustdbBtn5.Caption;
  Custom6.Caption:=CustdbBtn6.Caption;

  With InvBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

    {* Set all equivalent enables *}

    Delete1.Enabled:=DelCP1Btn.Enabled;
    All1.Enabled:=ALCp1Btn.Enabled;
    PartAll1.Enabled:=ALCp1Btn.Enabled;
    UnAll1.Enabled:=ALCp1Btn.Enabled;

  if (Current_Page in [Low(MulCtrlO)..High(MulCtrlO)]) then
    begin
      RefreshView2.Visible := False;
      CloseView2.Visible := False;
      N3.Visible := False;
      if (Assigned(MulCtrlO[Current_Page])) then
        if (MulCtrlO[Current_Page].SortViewEnabled) then
        begin
          RefreshView2.Visible := True;
          CloseView2.Visible := True;
          N3.Visible := True;
        end;
    end;

  end; {With..}

end;


procedure TCustRec3.PopupMenu4Popup(Sender: TObject);
begin
  {$IFDEF RET}
     Reverse1.Visible:=(Current_Page<>RetPNo);
  {$ENDIF}
end;


procedure TCustRec3.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;

procedure TCustRec3.PropFlgClick(Sender: TObject);
begin
  {$IFDEF NP}
    If (Current_Page=NotesPNo) then
    begin
      NotesCtrl.SetFormProperties;
      FColorsChanged := True;
      NeedCUpdate := True;
    end
    else
  {$ENDIF}
      SetFormProperties;
end;

procedure TCustRec3.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;

procedure TCustRec3.DeleteDoc;
Begin
  With MULCtrlO[Current_Page] do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin

      {$IFDEF CU}
        IF (ValidExitHook(2000,100,ExLocal)) then
      {$ENDIF}

      Begin
        GetSelRec(BOff);

        If Delete_Application(Inv,BOn,ScanFileNum,Keypath,ExLocal) then
        Begin
          PageUpDn(0,BOn);

          If (PageKeys^[0]=0) then {* Update screen as we have lost them all!*}
            InitPage;

          { SSK 09/02/2017 2017-R1 ABSEXCH-18021: these 2 lines added to avoid the situation which occurrs if we select a transaction with applied n certified
           with 0 val and click on delete button the cursor moves to next transaction in the list and delete button still remain enabled}
          GetSelRec(BON);
          DelCP1Btn.enabled := (Inv.InvNetVal = 0.0) and (Inv.TotalCost = 0.0);

        end;

      end;
    end; {If confirm delete..}
  end; {If ok..}
end; {PRoc..}


procedure TCustRec3.DelCP1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  Case Current_Page of
    // PKR. 10/10/2013.  - MRD 7.X Item 2.4 - Ledger Multi-Contacts
    // Added Delete Contact on Roles tab
    // Added to 7.0.9 on 24/01/2014.
    RolesPNo:
      begin
        rolesFrame.DeleteCurrentContact;
      end;

    NotesPNo
           :  DelCp3BtnClick(Sender);
    {$IFDEF PF_On}
      {$IFDEF stk}
          DiscPNo
             :  If (Not (Sender is TMenuItem)) and (Assigned(MulCtrlO2[Current_Page])) then
                With MULCtrlO2[Current_Page] do
                Begin
                  {$IFDEF LTE}
                    DelDisc1Click(DelDisc1);
                  {$ELSE}
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
                  {$ENDIF}  
                end;{with..}
        
      {$ENDIF}
    {$ENDIF}
    {$IFDEF JAP}
      JAppsPNo
        :   DeleteDoc;

    {$ENDIF}
    {$IFDEF SOP}
     MultiBuyPNo
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


procedure TCustRec3.FindLedItem(Sender: TObject);
Var
  ReturnCtrl  :  TReturnCtrlRec;

begin
  {$IFDEF GF}

    With ReturnCtrl,MessageReturn do
    Begin
      FillChar(ReturnCtrl,Sizeof(ReturnCtrl),0);

      WParam:=3000;
      Msg:=WM_CustGetRec;
      DisplayxParent:=BOn;
      ShowOnly:=BOn;


      Case Current_Page of
        MainPno..eCommPNo
             :  Begin
                  {ReturnCtrl.ManualClose:=BOn;}
                  //PR: 04/12/2013 ABSEXCH-14824
                  Ctrl_GlobalFind(Self,ReturnCtrl,CustFormMode);
                end;

          {$IFDEF PF_On}
            {$IFDEF stk}
              DiscPNo  : Begin
                           LParam:=Current_Page;

                           //PR: 04/12/2013 ABSEXCH-14824
                           Ctrl_GlobalFind(Self, ReturnCtrl, tabFindStock);
                         end;
            {$ENDIF}
          {$ENDIF}

        LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo
             :  Begin
                  Pass2Parent:=BOn;

                  LParam:=Current_Page;

                 //PR: 04/12/2013 ABSEXCH-14824
                 Ctrl_GlobalFind(Self, ReturnCtrl, tabFindDocument);
                end;

      end; {case..}

    end; {With..}

  {$ENDIF}

end;


procedure TCustRec3.FindCP1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin

  If (Not (Current_Page In [OrdersPNo])) then
  Begin
    {$IFDEF GF}
      FindLedItem(Sender);
    {$ENDIF}
  end
  {$IFDEF SOP}
  else
    If (Sender is TButton) then
    Begin

      GetCursorPos(ListPoint);
      With ListPoint do
      Begin
        X:=X-50;
        Y:=Y-15;
      end;

      SetCheckedPopUpMenu(PopUpMenu7,-1,LastBTag);

      PopUpMenu7.PopUp(ListPoint.X,ListPoint.Y);
    end;
  {$ENDIF}

end;



procedure TCustRec3.ExecuteLFilter(Sender  : TObject;
                                   PageNo,
                                   BTagNo  :  Integer);

Begin
  If (Assigned(MulCtrlO[PageNo])) then
  With MulCtrlO[PageNo] do
  Begin
    FilterMode:=BTagNo;

    Filter[1,1]:=NdxWeight;

    InitPage;
  end;
end;


procedure TCustRec3.Account1Click(Sender: TObject);
Var
  PageNo,
  BTagNo  :  Integer;

begin
  BTagNo := 0;
  {$IFDEF SOP}

    PageNo:=Current_Page;

    If (Sender is TMenuItem) then
      With TMenuItem(Sender) do
      Begin
        BTagNo:=Tag;

        Case BTagNo of
          1..4  :  ExecuteLFilter(Sender,PageNo,BTagNo);

          5     :  FindLedItem(Sender);

        end;
      end;

    SetCheckedMenuItems(Find1,0,BTagNo);
    LastBTag:=BTagNo;
    
  {$ENDIF}
end;


procedure TCustRec3.InvTFExit(Sender: TObject);

Var
  FoundCode  :  Str20;

  AltMod,
  FoundOk    :  Boolean;

begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (AltMod) and  (FoundCode<>'') and (OrigValue<>Text) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,RecordMode,0));

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

        ChangePage(DefaultPNo);

        StopPageChange:=BOn;

        SetFocus;
      end; {If not found..}
    end
    //GS: 05/05/11 ABSEXCH-10796 added a clause where if the user exits a 'GL code' field on the Default tab while
    //leaving it blank, the PageChange lock will be turned off; allowing the user to switch tabs
    else if FoundCode = '' then
      StopPageChange := BOff;

    {$IF Defined(SOP) and Not Defined(LTE)}
      // CJS 2013-12-04 - MRD1.1.14 - Trader List - Consumers Record
      If (Not ReadOnly) and (ExLocal.InAddEdit) and (CustFormMode <> CONSUMER_TYPE) then
          HOACF.Visible:=(Trim(Text)='');
    {$IFEND}


  end; {with..}
end;


procedure TCustRec3.DNomFExit(Sender: TObject);

Var
  FoundCode  :  Str20;
  FoundNom   :  LongInt;

  FoundOk,
  MDCFlg,
  AltMod     :  Boolean;

begin

  MDCFlg:=(Sender=DMDCNomF);

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundNom:=0;

    FoundCode:=Text;

    If (AltMod) and  (FoundCode<>'') and (OrigValue<>Text) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self,FoundCode,FoundNom,2+(76*Ord(MDCFlg))));

      If (FoundOk) then
      Begin
        StillEdit:=BOff;

        StopPageChange:=BOff;

        Text:=Form_BInt(FoundNom,0);

        {* Weird bug when calling up a list caused the Enter/Exit methods
             of the next field not to be called. This fix sets the focus to the next field, and then
             sends a false move to previous control message ... *}

        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin
        ChangePage(DefaultPNo);
        //TW 17/08/2011: fix for tab locking.
        StopPageChange := false;
        SetFocus;
      end; {If not found..}
    end
    //GS: 05/05/11 ABSEXCH-10796 added a clause where if the user exits a 'GL code' field on the Default tab while
    //leaving it blank, the PageChange lock will be turned off; allowing the user to switch tabs
    else if FoundCode = '' then
      StopPageChange := BOff;

  end; {with..}
end;


procedure TCustRec3.CCFExit(Sender: TObject);
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

      If (AltMod) and  (FoundCode<>'') and (OrigValue<>Text) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetCCDep(Self,FoundCode,FoundCode,(Sender=CCF),2));

        If (FoundOk) then
        Begin
          StillEdit:=BOff;

          StopPageChange:=BOff;

          Text:=FoundCode;

          {* Weird bug when calling up a list caused the Enter/Exit methods
               of the next field not to be called. This fix sets the focus to the next field, and then
               sends a false move to previous control message ... *}


          {FieldNextFix(Self.Handle,ActiveControl,Sender);}
        end
        else
        Begin
          ChangePage(DefaultPNo);

          StopPageChange:=BOn;

          SetFocus;
        end; {If not found..}
      end
      //GS: 05/05/11 ABSEXCH-10796 added a clause where if the user exits a 'GL code' field on the Default tab while
      //leaving it blank, the PageChange lock will be turned off; allowing the user to switch tabs
      else if FoundCode = '' then
        StopPageChange := BOff;
    end; {with..}
  {$ENDIF}
end;

procedure TCustRec3.AreaFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

begin
  {$IFDEF CU}

    If (Not AreaF.ReadOnly) then
    With AreaF do
    Begin
      ExLocal.LCust.AreaCode:=Text;

      If Not ValidExitHook(1000,1+(4*Ord(Not IsSales)),ExLocal) then
        SetFocus
      else
        If (Sender is Text8Pt)  and (ActiveControl<>CanCP1Btn) then
          Text8pt(Sender).ExecuteHookMsg;
    end;
  {$ENDIF}
end;

procedure TCustRec3.RepFExit(Sender: TObject);
begin
  {$IFDEF CU}

    If (Not RepF.ReadOnly) then
    With RepF do
    If (Sender is Text8Pt)  and (ActiveControl<>CanCP1Btn) then
    Begin
      Text8pt(Sender).ExecuteHookMsg;
    end;
  {$ENDIF}
end;

procedure TCustRec3.PostCFExit(Sender: TObject);
begin
  If (Not PostCF.ReadOnly) and (PostCF.Modified) and (ActiveControl<>CanCP1Btn) then
  Begin
    Form2Cust;

    With ExLocal,LInv do
    Begin
      {$IFDEF CU} {* Call any pre store hooks here *}

        GenHooks(1000,105+(1*Ord(Not IsSales)),ExLocal);

        OutCust;

      {$ENDIF}
    end;
  end;
end;


procedure TCustRec3.User1FEntHookEvent(Sender: TObject);

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
          If (Sender=User1F) then
          Begin
            ExLocal.LCust.UserDef1:=Text;
            CUUDEvent:=1;
          end
          else
            If (Sender=User2F) then
            Begin
              ExLocal.LCust.UserDef2:=Text;
              CUUDEvent:=2;
            end
            else
              If (Sender=User3F) then
              Begin
                ExLocal.LCust.UserDef3:=Text;
                CUUDEvent:=3;
              end
              else
                If (Sender=User4F) then
                Begin
                  ExLocal.LCust.UserDef4:=Text;
                  CUUDEvent:=4;
                end
                //GS 24/10/2011 ABSEXCH-11706: create branches for the new UDFs
                //there is a numerical offset which needs to be calculated; event values are adjusted accordingly
                else
                  If (Sender=User5F) then
                  Begin
                    ExLocal.LCust.UserDef5:=Text;
                    CUUDEvent:=(211 - 30);
                  end
                  else
                    If (Sender=User6F) then
                    Begin
                      ExLocal.LCust.UserDef6:=Text;
                      CUUDEvent:=(212 - 30);
                    end
                    else
                      If (Sender=User7F) then
                      Begin
                        ExLocal.LCust.UserDef7:=Text;
                        CUUDEvent:=(213 - 30);
                      end
                      else
                        If (Sender=User8F) then
                        Begin
                          ExLocal.LCust.UserDef8:=Text;
                          CUUDEvent:=(214 - 30);
                        end
                        else
                          If (Sender=User9F) then
                          Begin
                            ExLocal.LCust.UserDef9:=Text;
                            CUUDEvent:=(215 - 30);
                          end
                          else
                            If (Sender=User10F) then
                            Begin
                              ExLocal.LCust.UserDef10:=Text;
                              CUUDEvent:=(216 - 30);
                            end
                            else
                              If (Sender=RepF) then
                              Begin
                                ExLocal.LCust.RepCode:=Text;
                                CUUDEvent:=5;
                              end
                              else
                              If (Sender=AreaF) then
                              Begin
                                ExLocal.LCust.AreaCode:=Text;
                                CUUDEvent:=6;
                              end;



          //GS 24/10/2011 ABSEXCH-11706: added a condition to adjust event id vals when record is a supplier
          //Result:=IntExitHook(1000,30+CUUDEvent+(10*Ord(Not RecordMode)),-1,ExLocal);

          if (ExLocal.LCust.CustSupp = 'S') and
             (CUUDEvent >= (211 - 30)) and
             (CUUDEvent <= (216 - 30)) then
          begin
            //add +10 to the event ID when record is of type 'supplier' and the field is UDEF 6-10
            Result:=IntExitHook(1000,30+CUUDEvent+(10*Ord(Not IsSales) + 10),-1,ExLocal);
          end
          else
          begin
            Result:=IntExitHook(1000,30+CUUDEvent+(10*Ord(Not IsSales)),-1,ExLocal);
          end;

          If (Result=0) then
            SetFocus
          else
          With ExLocal do
          If (Result=1) then
          Begin
            Case CUUDEvent of
              1  :  Text:=LCust.UserDef1;
              2  :  Text:=LCust.UserDef2;
              3  :  Text:=LCust.UserDef3;
              4  :  Text:=LCust.UserDef4;
              5  :  Text:=LCust.RepCode;
              6  :  Text:=LCust.AreaCode;
              //GS 24/10/2011 ABSEXCH-11706: put customisation object vals into UDFs
              (211 - 30) :  Text:=LCust.UserDef5;
              (212 - 30) :  Text:=LCust.UserDef6;
              (213 - 30) :  Text:=LCust.UserDef7;
              (214 - 30) :  Text:=LCust.UserDef8;
              (215 - 30) :  Text:=LCust.UserDef9;
              (216 - 30) :  Text:=LCust.UserDef10;
            end; {Case..}
          end;
        end;
     end; {With..}

  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;

procedure TCustRec3.User1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>CanCP1Btn) then
    Text8pt(Sender).ExecuteHookMsg;
end;

procedure TCustRec3.VATNoFExit(Sender: TObject);
begin
  If (Not VATNoF.ReadOnly) then
    With VATNoF do
    Begin
      Check_ValidVATNo(Text);
    end;
end;

procedure TCustRec3.DefaultDeliveryTermsExit(Sender: TObject);
begin
  // PKR. 14/01/2016. ABSEXCH-17099. Intrastat.
  // This control is now a drop-down list.  Existing blank values are supported
  // so validation is no longer required.
{
  If (Not DefaultDeliveryTerms.ReadOnly) then
    With DefaultDeliveryTerms do
    Begin
      Check_ValidDelTerms(Text);
    end;
}
end;

procedure TCustRec3.DefaultModeOfTransportExit(Sender: TObject);
begin
  // PKR. 14/01/2016. ABSEXCH-17099. Intrastat.
  // This control is now a drop-down list.  Existing blank values are supported
  // so validation is no longer required.
{
  If (Not DefaultModeOfTransport.ReadOnly) then
    With DefaultModeOfTransport do
    Begin
      // PKR. 11/01/2016. ABSEXCH-17098.  Intrastat.  Changed field to combo box
      Check_ValidModeTran(Round(StrToIntDef(Text, 0)));
    end;
}
end;


procedure TCustRec3.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
//    Release_PageHandle(Sender);
    LockWindowUpDate(Handle);
    Last_Page:=Current_Page;
  end;
end;


Procedure TCustRec3.SetButnPanelHeight(PNo  :  Integer);

Begin
  Case PNo of

    LedgerPNo
       :  With TCMPanel do
            Height:=Height-TotValPanel.Height;

    else  TCMPanel.Height:=PageControl1.Height-ScrollAP.Y;

  end; {Case..}

  TCMBtnScrollBox.Height:=TCMPanel.Height-Misc1P.X;

end;


procedure TCustRec3.OutAlloc;
Begin
  With GlobalAllocRec^[IsSales] do
    UnalLab.Caption:=FormatFloat(GenRealMask,LUnallocated+(LFullDisc*DocNotCnst));
end;


procedure TCustRec3.PageControl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;

  {$IFDEF NP}
    NoteSetUp :  TNotePadSetUp;
  {$ENDIF}

  ChkStr      :  Str255;
begin

  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      {$B-}

      // MH 26/01/2015 v7.1 ABSEXCH-16063: Leave LockWindowUpDate in place for Notes tab,
      // otherwise can get horrible part-painting effect if window has been resized since
      // co-ords have been saved
      If (NewIndex <> NotesPNo) Then
        // Note: MulCtrlO only goes from DiscPNo..RetPNo
        If (Not (NewIndex In [DiscPNo..RetPNo])) or (MULCtrlO[NewIndex]<>nil) then
          LockWindowUpDate(0);

      {$B+}

      PrimeButtons;

      DeleteSubMenu(Copy1);

      DeleteSubMenu(Delete1);

      {$IFDEF SOP}
        DeleteSubMenu(Find1);
      {$ENDIF}


      {Sanjay Sonani  10/03/2016 2016-R2
       ABSEXCH-16067:Trader Record - Works Order columns in Wrong Place.
       Reset scroll bar position before save the columns posiotion.}
      {$B-}
      If (Last_Page In [OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo]) and (Assigned(MULCtrlO[Last_Page])) then
      {$B+}
      begin
        COSBox.HorzScrollBar.Position := 0;
      end;

      Case NewIndex of

        {$IFDEF PF_On}
          {$IFDEF STK}
            DiscPNo
            {$IFDEF SOP}
            ,MultiBuyPNo
            {$ENDIF}
              :  Begin
                          CreateSubMenu(PopUpMenu5,Copy1);

                          {$IFNDEF LTE}
                            CreateSubMenu(PopUpMenu10,Delete1);
                          {$ENDIF}
                        end;
          {$ENDIF}
        {$ENDIF}

        LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo
             :  Begin
                  //HV 20/05/2016 2016-R2 ABSEXCH-17430:Calculate Oldest Debt when leaving Ledger
                  if NewIndex = LedgerPNo then
                    IsLedgerPageActivate := True;
                  CreateSubMenu(PopUpMenu4,Copy1);

                  {$IFDEF SOP}
                    If (NewIndex In [OrdersPNo]) then
                    Begin
                      CreateSubMenu(PopUpMenu7,Find1);
                      SetCheckedMenuItems(Find1,-1,LastBTag);
                    end;
                  {$ENDIF}
                end;

        RolesPNo:
          begin
            // PKR 14/10/2013. - MRD 7.X Item 2.4 - Ledger Multi-Contacts
            // Added to 7.0.9 20/01/2014.
            if (Assigned(rolesFrame)) then
            begin
			  // MH 09/01/2014 v7.1 ABSEXCH-16008: Default the Country Code when adding a new role
              rolesframe.SetCustomerRecord(ExLocal.LCust.CustCode, ExLocal.LCust.acCountry);
              // PKR. 19/02/2014. ABSEXCH-15059. Respect Password settings for
              //  editing Roles/Contacts.
              rolesFrame.SetCanEditContacts(EditCP1Btn.Enabled);
            end;
          end;

        {else  If (Last_Page In [OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo]) then
              Begin
                MULCtrlO[Last_Page].HideAllCols(BOn);
              end;}

      end; {Case..}

      {$B-}
      If (Last_Page In [OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo]) and (Assigned(MULCtrlO[Last_Page])) then
      {$B+}
      Begin
        MULCtrlO[Last_Page].HideAllCols(BOn);
        MULCtrlO[Last_Page].VisiList.StoreXPos(BOff);
      end;

      SetButnPanelHeight(NewIndex);

      Case NewIndex of

      {$IFDEF NP}

        NotesPNo
          :  If (NotesCtrl=nil) then
              With ExLocal do
              Begin
                NotesCtrl:=TNoteCtrl.Create(Self);
                //PR: 21/10/2011 v6.9 Set handler to disable/enable note buttons for Audit History Notes
                NotesCtrl.OnSwitch := SwitchNoteButtons;


                NotesCtrl.Caption:=TradeType[RecordMode]+' '+Caption;
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

                  CoorPrime:=TradeCode[RecordMode];
                  CoorHasCoor:=LastCoord;

                end;

                try
                  //PR: 08/11/2020 Give the Notes list a reference to the settings object to allow loading and saving of settings.
                  NotesCtrl.WindowSettings := FSettings;
                  NotesCtrl.PropFlg.OnClick := PropFlgClick;
                  NotesCtrl.CreateList(Self,NoteSetUp,NoteCCode,NoteCDCode,LCust.CustCode);
                  NotesCtrl.GetLineNo:=LCust.NLineCount;


                except
                  NotesCtrl.Free;
                  NotesCtrl:=Nil
                end;

                // MH 26/01/2015 v7.1 ABSEXCH-16063: Force resize of Notes List panels - otherwise
                // if the window has been resized since the co-ords were saved the list panels are
                // sized based on the old size
                NotePageReSize;

                MDI_UpdateParentStat;

              end
              else
              With ExLocal do
              begin
                If (LCust.CustCode<>NotesCtrl.GetFolio) then {* Refresh notes *}
                with NotesCtrl do
                Begin
                  RefreshList(LCust.CustCode,GetNType);
                  GetLineNo:=LCust.NLineCount;
                end;
                //PR: 19/10/2011 v6.9
                SwitchNoteButtons(Self, NotesCtrl.NoteMode);
              end;



      {$ELSE}

         NotesPNo  :  ;

      {$ENDIF}

      {$IFDEF PF_On}
        {$IFDEF STK}
          DiscPNo
           : Begin
               If (MULCtrlO2[NewIndex]=nil) then
                Begin


                  Case NewIndex of
                    DiscPNo  :     CDBuildList(NewIndex,BOn);

                  end; {Case..}

                end
                else
                  With EXLocal,LCust do
                  Begin
                    ChkStr:=Strip('R',[#0],FullQDKey(CDDiscCode,CustSupp,FullCustCode(CustCode)));

                    If (Not CheckKey(ChkStr,MULCtrlO2[NewIndex].KeyRef,Length(ChkStr),BOn)) then
                      RefreshValList(BOn,BOff);

                    MULCtrlO2[NewIndex].ReFresh_Buttons;
                  end;

             If (Self.Visible) then
               MULCtrlO2[NewIndex].SetListFocus;
           end;

        {$ENDIF}
      {$ENDIF}

      //PR: 30/03/2009 Added handling for MultiBuy Discounts page
      {$IFDEF SOP}
          MultiBuyPNo
           : Begin
               If (MULCtrlO[NewIndex]=nil) then
                Begin
                  MultiBuyBuildList(NewIndex, True);
                end
                else
                  With EXLocal,LCust do
                  Begin
                    ChkStr:=FullCustCode(CustCode);

                    If (Not CheckKey(ChkStr,MULCtrlO[NewIndex].KeyRef,Length(ChkStr),BOn)) then
                      mbdFrame.RefreshCustList(FullCustCode(ExLocal.LCust.CustCode));

//                    MULCtrlO[NewIndex].ReFresh_Buttons;
                  end;

             If (Self.Visible) then
               MULCtrlO[NewIndex].SetListFocus;
           end;
       {$ENDIF}

        LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo
           : Begin
               Case NewIndex of
                    {$IFDEF SOP}

                      OrdersPNo  :  COSBox.Parent:=OrdersPage;

                    {$ELSE}

                      OrdersPNo  :  ;

                    {$ENDIF}


                    {$IFDEF STK}

                      WOROrdersPNo
                                 :  COSBox.Parent := WorksOrdersPage;
                    {$ELSE}

                      WOROrdersPNo
                                 :  ;

                    {$ENDIF}

                    {$IFDEF JAP}

                      JAPPsPNo
                                 :  COSBox.Parent := JobApplicationsPage;
                    {$ELSE}

                      JAppsPNo
                                 :  ;

                    {$ENDIF}

                    {$IFDEF RET}

                      RetPNo
                                 :  COSBox.Parent := ReturnsPage
                    {$ELSE}

                      RetPNo
                                 :  ;

                    {$ENDIF}


               end; {Case..}

               COListBtnPanel.Parent:=COSBox.Parent;


               If (MULCtrlO[NewIndex]=nil) then
               Begin
                  {$B-}
                    If (NewIndex In [OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo]) and (PanelIdx<>-1) and (NewIndex<>PanelIdx) then
                    Begin
                      If  (Assigned(MULCtrlO[PanelIdx])) then
                  {$B+}
                        MULCtrlO[PanelIdx].VisiList.ReStoreXPos(BOn);
                    end;

                  Case NewIndex of
                    LedgerPNo    :  LedgerBuildList(NewIndex,BOn);

                    {$IFDEF SOP}

                      OrdersPNo  :  OrdersBuildList(NewIndex,BOn);

                    {$ENDIF}

                    {$IFDEF STK}

                      WOROrdersPNo
                                 :  WOROrdersBuildList(NewIndex,BOn);
                    {$ENDIF}

                    {$IFDEF JAP}

                      JAppsPNo
                                 :  JAppsBuildList(NewIndex,BOn);
                    {$ENDIF}

                    {$IFDEF Ret}

                      RetPNo
                                 :  RetBuildList(NewIndex,BOn);
                    {$ENDIF}


                  end; {Case..}


                  {$B-}
                    If (NewIndex In [OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo]) and (Assigned(MULCtrlO[NewIndex])) then
                    Begin
                  {$B+}
                      If (PanelIdx=-1) then
                      Begin
                        MULCtrlO[NewIndex].VisiList.StoreXPos(BOn);
                        PanelIdx:=NewIndex;
                      end;
                    end;
                end
                else
                  With EXLocal do
                    If (Not CheckKey(LCust.CustCode,MULCtrlO[NewIndex].KeyRef,CustKeyLen,BOn))
                    or ((WorksOrdersPage.TabVisible) and (Not (NewIndex In [LedgerPNo,JAppsPNo,RetPNo])))
                    or ((JobApplicationsPage.TabVisible) and (Not (NewIndex In [LedgerPNo,WOROrdersPNo,RetPNo])))
                    or ((OrdersPage.TabVisible) and (Not (NewIndex In [LedgerPNo,WOROrdersPNo,RetPNo,JAppsPNo])))
                    or ((ReturnsPage.TabVisible) and (Not (NewIndex In [LedgerPNo,WOROrdersPNo,JAppsPNo]))) then
                    Begin
                      If (Last_Page In [OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo]) then
                        MULCtrlO[Last_Page].HideAllCols(BOn);

                      MULCtrlO[NewIndex].HideAllCols(BOff);



                      If (Not CheckKey(LCust.CustCode,MULCtrlO[NewIndex].KeyRef,CustKeyLen,BOn)) then
                        RefreshList(BOn,BOff);
                    end;

             If ((WorksOrdersPage.TabVisible) and (Not (NewIndex In [LedgerPNo,JAppsPNo,RetPNo])))
                    or ((JobApplicationsPage.TabVisible) and (Not (NewIndex In [LedgerPNo,WOROrdersPNo,RetPNo]))
                    or ((OrdersPage.TabVisible) and (Not (NewIndex In [LedgerPNo,WOROrdersPNo,RetPNo,JAppsPNo])))
                    or ((ReturnsPage.TabVisible) and (Not (NewIndex In [LedgerPNo,WOROrdersPNo,JAppsPNo]))))
                    then
             Begin
               MULCtrlO[NewIndex].VisiList.ReStoreXPos(BOff);
                 
               HidePanels(NewIndex);
               RenamePanels(NewIndex);
               MULCtrlO[NewIndex].RefreshAllCols;
               MULCtrlO[NewIndex].VisiList.SetHedPanel(ListOfset);

             end;

             If (NewIndex=LedgerPNo) then
             Begin
               If (Not SRCAlloc) then
                 ResetGlobAlloc(IsSales);

               OutAlloc;
             end;

             MULCtrlO[NewIndex].SetListFocus;
             {$IFDEF JAP}     // SSK 02/02/2017 2017-R1 ABSEXCH-18021: change the state of the delete button as per the last selected transaction in the list
               If (NewIndex=JAppsPNo) then
                 DelCP1Btn.enabled := (Inv.InvNetVal = 0.0) and (Inv.TotalCost = 0.0);
             {$ENDIF}
           end;

      end; {Case..}

      // MH 26/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
      WindowExport.ReevaluateExportStatus;

      LockWindowUpDate(0);

      //PR: 18/03/2014 ABSEXCH-15166 Set context Ids from individual pages.
      if (TabIndex > -1) then
        if Assigned(Pages[TabIndex]) then
          HelpContext := Pages[TabIndex].HelpContext;
    end;

end;


procedure TCustRec3.AddCP3BtnClick(Sender: TObject);
begin
  {$IFDEF NP}
    If (NotesCtrl<>nil) then
    begin
      {$IFDEF EX601}
      //PR: 03/02/2009 20080910141934 Caption of Notes dialog was only set on Tab change, so if Notes tab was already visible
      //and user changed Customer/Supplier in the list, wrong Ac would be displayed in Notes dialog caption.
      if Sender=EditCP1Btn then
        NotesCtrl.Caption := Caption + ' - Edit Note'
      else
        NotesCtrl.Caption := Caption + ' - Add Note';
      {$ENDIF}
      NotesCtrl.AddEditNote((Sender=EditCP1Btn),(Sender=InsCP3Btn));
    end;
  {$ENDIF}
end;


procedure TCustRec3.DelCP3BtnClick(Sender: TObject);
begin
  {$IFDEF NP}
    If (NotesCtrl<>nil) then
      NotesCtrl.Delete1Click(Sender);
  {$ENDIF}
end;

procedure TCustRec3.GenCP3BtnClick(Sender: TObject);
var
  ListPoint : TPoint;
begin

  Case Current_Page of

    NotesPNo
        :  {$IFDEF NP}
            If (NotesCtrl<>nil) then
            With NotesCtrl do
            Begin

              If (Not MULCtrlO.InListFind) then
              begin

                //PR: 19/10/2011 v6.9 Added submenu to handle Audit History Notes
                ListPoint.X:=1;
                ListPoint.Y:=1;

                ListPoint := GenCP3Btn.ClientToScreen(ListPoint);

                mnuSwitchNotes.Popup(ListPoint.X, ListPoint.Y);
              end;
            end;
          {$ELSE}

            ;
          {$ENDIF}

    LedgerPNo
       :  With MULCtrlO[Current_Page] do
          Begin
            // MH 22/05/2018 ABSEXCH-20620: The Switch To button changes the Original Value column to a % and back again,
            //                              so we need to adjust the Lsit Export Metadata to compensate.
            If (DisplayMode=0) then
            begin
              // GP%
              DisplayMode:=6;
              ColAppear^[5].ExportMetadata := emtAlignRight;
            End // If (DisplayMode=0)
            else
            Begin
              // Original Value
              DisplayMode:=0;
              ColAppear^[5].ExportMetadata := emtCurrencyAmount;
            End; // Else

            SortView.DisplayMode := DisplayMode;
            
            RenamePanels(LedgerPNo);
            HidePanels(LedgerPNo);

            PageUpDn(0,BOn);

          end;

  end; {Case..}


end;



procedure TCustRec3.LedgerBuildList(PageNo     :  Byte;
                                    ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  StartPanel := nil;
  MULCtrlO[PageNo]:=TCLMList.Create(Self);

  MULCtrlO[PageNo].Name := 'List_' + ListNames[PageNo];
  Try

    With MULCtrlO[PageNo] do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(CLORefPanel,CLORefLab);
          AddVisiRec(CLDatePanel,CLDateLab);
          AddVisiRec(CLAMTPanel,CLAMTLab);
          AddVisiRec(CLOSPanel,CLOSLab);
          AddVisiRec(CLTotPanel,CLTotLab);
          AddVisiRec(CLOrigPanel,CLOrigLab);
          AddVisiRec(CLYRefPanel,CLYRefLab);
          AddVisiRec(CLDuePanel,CLDueLab);
          AddVisiRec(CLStatPanel,CLStatLab);

          //PR: 06/05/2015 ABSEXCH-16284 T2-120 Add PPD columns
          AddVisiRec(panPPDValue,panPPDValueHed);
          AddVisiRec(panPPDExpiry,panPPDExpiryHed);

          // MH 06/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
          ColAppear^[1].ExportMetadata := emtDate;
          ColAppear^[2].ExportMetadata := emtCurrencyAmount;
          ColAppear^[3].ExportMetadata := emtCurrencyAmount;
          ColAppear^[4].ExportMetadata := emtCurrencyAmount;
          ColAppear^[5].ExportMetadata := emtCurrencyAmount;
          ColAppear^[7].ExportMetadata := emtDate;

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels(LedgerPNo);

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

      //PR: 06/05/2015 ABSEXCH-16284 T2-120 Set total number of columns to include PPD columns
      MUTotCols:=10;

      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [2..5, 9]) then
        Begin
          DispFormat:=SGFloat;

          NoDecPlaces:=2;
        end;
      end;


      ListLocal:=@ExLocal;

      Find_LedgCoord(PageNo); //PR: 10/11/2010
      ListCreate;

      {UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;}

      Set_Buttons(CListBtnPanel);

      LNHCtrl.NHNeedGExt:=SRCAlloc;
      LNHCtrl.NHosFilt:=SRCAlloc;

      if (PageNo = LedgerPNo) then
      begin
        MULCtrlO[PageNo].SortView.ExLocal := ListLocal;
        MULCtrlO[PageNo].SortView.NHCtrl := LNHCtrl;
      end;

      ReFreshList(BOn,BOff);

    end; {With}

    DefaultPageReSize;

  Except

    MULCtrlO[PageNo].Free;
    MULCtrlO[PageNo]:=Nil;
  end;


end;


{$IFDEF SOP}

  procedure TCustRec3.OrdersBuildList(PageNo     :  Byte;
                                      ShowLines  :  Boolean);

  Var
    StartPanel  :  TSBSPanel;
    n           :  Byte;



  Begin
    StartPanel := nil;
    MULCtrlO[PageNo]:=TCLMList.Create(Self);
    MULCtrlO[PageNo].Name := 'List_' + ListNames[PageNo];

    Try

      With MULCtrlO[PageNo] do
      Begin


        Try

          With VisiList do
          Begin
            AddVisiRec(COORefPanel,COORefLab);
            AddVisiRec(CODatePanel,CODateLab);
            AddVisiRec(COAMTPanel,COAMTLab);
            AddVisiRec(COGPPanel,COGPLab);
            AddVisiRec(CODisPanel,CODisLab);
            AddVisiRec(COMarPanel,COMarLab);
            AddVisiRec(COCosPanel,COCosLab);

            // MH 06/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
            ColAppear^[1].ExportMetadata := emtDate;
            ColAppear^[2].ExportMetadata := emtCurrencyAmount;
            ColAppear^[5].ExportMetadata := emtCurrencyAmount;
            ColAppear^[6].ExportMetadata := emtCurrencyAmount;
            // MH 17/05/2018 2018-R1.1 ABSEXCH-20532: Force right alignment for column title/data
            ColAppear^[3].ExportMetadata := emtAlignRight;

            COHedPanel.Width:=521;

            VisiRec:=List[0];

            StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

            LabHedPanel:=COHedPanel;

            SetHedPanel(ListOfset);

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
        MUTotCols:=6;
        Font:=StartPanel.Font;

        LinkOtherDisp:=BOn;

        WM_ListGetRec:=WM_CustGetRec;


        Parent:=StartPanel.Parent;

        MessHandle:=Self.Handle;

        For n:=0 to MUTotCols do
        With ColAppear^[n] do
        Begin
          AltDefault:=BOn;

          If (n In [2,3,5,6]) then
          Begin
            DispFormat:=SGFloat;

            NoDecPlaces:=2;
          end;
        end;

        DisplayMode:=7;

        ListLocal:=@ExLocal;

        Find_LedgCoord(PageNo); //PR: 10/11/2010 Moved from above
        ListCreate;

        {UseSet4End:=BOn;

        NoUpCaseCheck:=BOn;}

        Set_Buttons(COListBtnPanel);

        ReFreshList(BOn,BOff);

      end; {With}

      DefaultPageReSize;

    Except

      MULCtrlO[PageNo].Free;
      MULCtrlO[PageNo]:=Nil;
    end;

    If (Assigned(MULCtrlO[RetPNo])) then {Disable order cols}
      MULCtrlO[RetPNo].HideAllCols(BOn);

    If (Assigned(MULCtrlO[JAppsPNo])) then {Disable order cols}
      MULCtrlO[JAppsPNo].HideAllCols(BOn);

    If (Assigned(MULCtrlO[WOROrdersPNo])) then {Disable order cols}
      MULCtrlO[WOROrdersPNo].HideAllCols(BOn);

  end;

procedure TCustRec3.MultiBuyBuildList(PageNo     :  Byte;
                                    ShowLines  :  Boolean);
begin
  //TW 15/11/2011: Changed buildlist to reference LCust.
  MULCtrlO[PageNo]:= mbdFrame.BuildList(ExLocal.LCust.CustCode, Stock.StockCode, @ExLocal, Self.Handle,
            TradeCode[RecordMode], LastCoord, FSettings) as TCLMList;
            //GS
//  mbdFrame.mbdResize((TCMScrollBox.Width - TCNListBtnPanel.Width) , TCMScrollBox.Height, TCNListBtnPanel.Height);
  mbdFrame.mbdResize((TCNScrollBox.Width - TCNListBtnPanel.Width) , TCNScrollBox.Height, TCNListBtnPanel.Height);
end;


{$ENDIF}


{$IFDEF PF_On}
  {$IFDEF STK}
    procedure TCustRec3.CDBuildList(PageNo     :  Byte;
                                    ShowLines  :  Boolean);

  Var
    StartPanel  :  TSBSPanel;
    n           :  Byte;



  Begin
    StartPanel := nil;
    MULCtrlO2[PageNo]:=TSNoList.Create(Self);
    MULCtrlO2[PageNo].Name := 'List_' + ListNames[PageNo];

    Try
      With MULCtrlO2[PageNo] do
      Begin
        Try
          With VisiList do
          Begin
            AddVisiRec(CDSPanel,CDSLab);
            AddVisiRec(CDTPanel,CDTLab);
            AddVisiRec(CDUPanel,CDULab);
            AddVisiRec(CDBPanel,CDBLab);
            AddVisiRec(CDDPanel,CDDLab);
            AddVisiRec(CDVPanel,CDVLab);
            AddVisiRec(CDMPanel,CDMLab);

            AddVisiRec(CDEffPanel,CDEffLab);

            // MH 06/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
            ColAppear^[2].ExportMetadata := emtCurrencyAmount;
            ColAppear^[5].ExportMetadata := emtNonCurrencyAmount;

            {$IFDEF LTE}
              With VisiList do
                SetHidePanel(FindxColOrder(7),BOn,BOn);
            {$ENDIF}

            VisiRec:=List[0];

            StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

            LabHedPanel:=CDHedPanel;

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

        WM_ListGetRec:=WM_CustGetRec;


        Parent:=StartPanel.Parent;

        MessHandle:=Self.Handle;

        For n:=0 to MUTotCols do
        With ColAppear^[n] do
        Begin
          AltDefault:=BOn;

          If (Not (n In [0,1,3])) then
          Begin
            DispFormat:=SGFloat;

            Case n of
              2,5 :  NoDecPlaces:=Syss.NoNetDec;
              // MH 04/11/2011 v6.9 ABSEXCH-11563: Increased DP to 3 to allow space for 2dp + % character
              4,6   :  NoDecPlaces := 3;
            end; {Case..}
          end;
        end;


        ListLocal:=@ExLocal;

        DispDocPtr:=nil;

        DisplayMode:=9;

        Find_ValCoord(PageNo); //PR: 10/11/2010
        ListCreate;



        Set_Buttons(CDListBtnPanel);

        ReFreshValList(BOn,BOff);

      end; {With}

      QBPageReSize;

    Except

      MULCtrlO2[PageNo].Free;
      MULCtrlO2[PageNo]:=Nil;
    end;


  end;


  procedure TCustRec3.RefreshValList(ShowLines,
                                     IgMsg      :  Boolean);

  Var
    KeyStart    :  Str255;
    LKeyLen     :  Integer;

  Begin
    ListBusy:=BOn;

    Try

      With MULCtrlO2[Current_Page],ExLocal,LStock do
      Begin

        With ExLocal,LCust,LNHCtrl do
        Begin
          KeyStart:=FullQDKey(CDDiscCode,CustSupp,FullCustCode(CustCode));
        end;

        LKeyLen:=Length(KeyStart);

        IgnoreMsg:=IgMsg;

        StartList(MiscF,MIK,KeyStart,'','',LKeyLen,(Not ShowLines));

        IgnoreMsg:=BOff;
      end;
    finally
      ListBusy:=BOff;
    end; {Try..}

  end;

  procedure TCustRec3.Display_QtyRec(Mode  :  Byte);

  Var
    WasNew  :  Boolean;

  Begin
    WasNew:=BOff;


    If (QtyRec=nil) then
    Begin
      SetQBMode(3);

      QtyRec:=TStkQtyRec.Create(Self);
      WasNew:=BOn;

    end;

    Try


     With QtyRec do
     Begin

       WindowState:=wsNormal;
       {Show;}

       StkKeyRef:=MULCtrlO2[DiscPNo].KeyRef;

       If (Mode In [1..3]) then
       Begin

         Case Mode of

           1..2  :   If (Not ExLocal.InAddEdit) then
                       EditLine(Self.ExLocal.LStock,Self.ExLocal.LCust,(Mode=2),BOff)
                     else
                       Show;
              3  :  If (Not ExLocal.InAddEdit) then
                    Begin
                      ExLocal.LCust:=Self.ExLocal.LCust;
                      DeleteBOMLine(MiscF,MIK,Self.ExLocal.LStock);
                    end
                     else
                       Show;

         end; {Case..}

       end;



     end; {With..}


    except

     QtyRec.Free;


    end;

  end;



  procedure TCustRec3.WOROrdersBuildList(PageNo     :  Byte;
                                         ShowLines  :  Boolean);

  Var
    StartPanel  :  TSBSPanel;
    n           :  Byte;



  Begin
    StartPanel := nil;
    MULCtrlO[PageNo]:=TCLMList.Create(Self);
    MULCtrlO[PageNo].Name := 'List_' + ListNames[PageNo];


    Try

      With MULCtrlO[PageNo] do
      Begin


        Try

          With VisiList do
          Begin
            AddVisiRec(COORefPanel,COORefLab);
            AddVisiRec(CODatePanel,CODateLab);
            AddVisiRec(COAMTPanel,COAMTLab);
            AddVisiRec(COGPPanel,COGPLab);
            AddVisiRec(CODisPanel,CODisLab);
            AddVisiRec(COMarPanel,COMarLab);
            AddVisiRec(COCosPanel,COCosLab);

            // MH 06/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
            ColAppear^[1].ExportMetadata := emtDate;
            ColAppear^[2].ExportMetadata := emtCurrencyAmount;
            // MH 17/05/2018 2018-R1.1 ABSEXCH-20532: Force right alignment for column title/data
            ColAppear^[3].ExportMetadata := emtAlignRight;

            VisiRec:=List[0];

            StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

            LabHedPanel:=COHedPanel;

            SetHedPanel(ListOfset);

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
        MUTotCols:=6;
        Font:=StartPanel.Font;

        LinkOtherDisp:=BOn;

        WM_ListGetRec:=WM_CustGetRec;


        Parent:=StartPanel.Parent;

        MessHandle:=Self.Handle;

        For n:=0 to MUTotCols do
        With ColAppear^[n] do
        Begin
          AltDefault:=BOn;

          If (n In [2,3,5,6]) then
          Begin
            DispFormat:=SGFloat;

            NoDecPlaces:=2;
          end;
        end;

        DisplayMode:=8;

        ListLocal:=@ExLocal;

        Find_LedgCoord(PageNo);

        ListCreate;

        {UseSet4End:=BOn;

        NoUpCaseCheck:=BOn;}

        Set_Buttons(COListBtnPanel);

        ReFreshList(BOn,BOff);

      end; {With}

      DefaultPageReSize;

    Except

      MULCtrlO[PageNo].Free;
      MULCtrlO[PageNo]:=Nil;
    end;

    If (Assigned(MULCtrlO[OrdersPNo])) then {Disable order cols}
      MULCtrlO[OrdersPNo].HideAllCols(BOn);

    If (Assigned(MULCtrlO[JAppsPNo])) then {Disable order cols}
      MULCtrlO[JAppsPNo].HideAllCols(BOn);

    If (Assigned(MULCtrlO[RetPNo])) then {Disable order cols}
      MULCtrlO[RetPNo].HideAllCols(BOn);

  end;



  {$ENDIF}
{$ENDIF}

{$IFDEF JAP}
  procedure TCustRec3.JAppsBuildList(PageNo     :  Byte;
                                         ShowLines  :  Boolean);

  Var
    StartPanel  :  TSBSPanel;
    n           :  Byte;



  Begin
    StartPanel := nil;
    MULCtrlO[PageNo]:=TCLMList.Create(Self);
    MULCtrlO[PageNo].Name := 'List_' + ListNames[PageNo];


    Try

      With MULCtrlO[PageNo] do
      Begin


        Try

          With VisiList do
          Begin
            AddVisiRec(COORefPanel,COORefLab);
            AddVisiRec(CODatePanel,CODateLab);
            AddVisiRec(COAMTPanel,COAMTLab);
            AddVisiRec(COGPPanel,COGPLab);
            AddVisiRec(CODisPanel,CODisLab);
            AddVisiRec(COMarPanel,COMarLab);
            AddVisiRec(COCosPanel,COCosLab);

            // MH 06/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
            ColAppear^[1].ExportMetadata := emtDate;
            ColAppear^[2].ExportMetadata := emtCurrencyAmount;
            ColAppear^[5].ExportMetadata := emtCurrencyAmount;

            VisiRec:=List[0];

            StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

            LabHedPanel:=COHedPanel;

            SetHedPanel(ListOfset);

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
        MUTotCols:=6;
        Font:=StartPanel.Font;

        LinkOtherDisp:=BOn;

        WM_ListGetRec:=WM_CustGetRec;


        Parent:=StartPanel.Parent;

        MessHandle:=Self.Handle;

        For n:=0 to MUTotCols do
        With ColAppear^[n] do
        Begin
          AltDefault:=BOn;

          If (n In [2,5]) then
          Begin
            DispFormat:=SGFloat;

            NoDecPlaces:=2;
          end;
        end;

        DisplayMode:=9;
        Filter[1,1]:=NdxWeight;



        ListLocal:=@ExLocal;

        Find_LedgCoord(PageNo);

        ListCreate;

        {UseSet4End:=BOn;

        NoUpCaseCheck:=BOn;}

        RenamePanels(JAppsPNo);

        HighLiteStyle[1]:=[fsBold];
        Set_Buttons(COListBtnPanel);

        ReFreshList(BOn,BOff);

      end; {With}

      DefaultPageReSize;

    Except

      MULCtrlO[PageNo].Free;
      MULCtrlO[PageNo]:=Nil;
    end;

    If (Assigned(MULCtrlO[OrdersPNo])) then {Disable order cols}
      MULCtrlO[OrdersPNo].HideAllCols(BOn);

    If (Assigned(MULCtrlO[WOROrdersPNo])) then {Disable order cols}
      MULCtrlO[WOROrdersPNo].HideAllCols(BOn);

    If (Assigned(MULCtrlO[RetPNo])) then {Disable order cols}
      MULCtrlO[RetPNo].HideAllCols(BOn);


  end;
{$ENDIF}


{$IFDEF RET}
  procedure TCustRec3.RetBuildList(PageNo     :  Byte;
                                   ShowLines  :  Boolean);

  Var
    StartPanel  :  TSBSPanel;
    n           :  Byte;



  Begin
    StartPanel := nil;
    MULCtrlO[PageNo]:=TCLMList.Create(Self);
    MULCtrlO[PageNo].Name := 'List_' + ListNames[PageNo];


    Try

      With MULCtrlO[PageNo] do
      Begin


        Try

          With VisiList do
          Begin
            AddVisiRec(COORefPanel,COORefLab);
            AddVisiRec(CODatePanel,CODateLab);
            AddVisiRec(COAMTPanel,COAMTLab);
            AddVisiRec(COGPPanel,COGPLab);
            AddVisiRec(CODisPanel,CODisLab);
            AddVisiRec(COMarPanel,COMarLab);
            AddVisiRec(COCosPanel,COCosLab);

            // MH 06/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
            ColAppear^[1].ExportMetadata := emtDate;
            ColAppear^[2].ExportMetadata := emtCurrencyAmount;

            VisiRec:=List[0];

            StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

            LabHedPanel:=COHedPanel;

            SetHedPanel(ListOfset);

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
        MUTotCols:=6;
        Font:=StartPanel.Font;

        LinkOtherDisp:=BOn;

        WM_ListGetRec:=WM_CustGetRec;


        Parent:=StartPanel.Parent;

        MessHandle:=Self.Handle;

        For n:=0 to MUTotCols do
        With ColAppear^[n] do
        Begin
          AltDefault:=BOn;

          If (n In [2]) then
          Begin
            DispFormat:=SGFloat;

            NoDecPlaces:=2;
          end;
        end;

        DisplayMode:=10;
        Filter[1,1]:=NdxWeight;



        ListLocal:=@ExLocal;

        Find_LedgCoord(PageNo);

        ListCreate;

        {UseSet4End:=BOn;

        NoUpCaseCheck:=BOn;}

        RenamePanels(RetPNo);

        HighLiteStyle[1]:=[fsBold];
        Set_Buttons(COListBtnPanel);

        ReFreshList(BOn,BOff);

      end; {With}

      DefaultPageReSize;

    Except

      MULCtrlO[PageNo].Free;
      MULCtrlO[PageNo]:=Nil;
    end;

    If (Assigned(MULCtrlO[OrdersPNo])) then {Disable order cols}
      MULCtrlO[OrdersPNo].HideAllCols(BOn);

    If (Assigned(MULCtrlO[WOROrdersPNo])) then {Disable order cols}
      MULCtrlO[WOROrdersPNo].HideAllCols(BOn);

    If (Assigned(MULCtrlO[JappsPNo])) then {Disable order cols}
      MULCtrlO[JAppsPNo].HideAllCols(BOn);


  end;
{$ENDIF}


procedure TCustRec3.RefreshList(ShowLines,
                                IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeypath,
  LKeyLen     :  Integer;


Begin
  ListBusy:=BOn;

  {$IFDEF DBD}
    LKeyPath:=InvCustK;

  {$ELSE}
    If (Debug) then
      LKeyPath:=InvCustK
    else
      LKeyPath:=InvCustLedgK; //InvCustK; MHCL
  {$ENDIF}

  Try
    With MULCtrlO[Current_Page],ExLocal,LCust do
    Begin

      Case DisplayMode of
        7  :  KeyStart:=FullCustType(CustCode,Char(Succ(Ord(CustSupp))))+Chr(1);
        8  :  KeyStart:=FullCustType(CustCode,'W')+Chr(1);
        9  :  KeyStart:=FullCustType(CustCode,'J')+Chr(1);
        {$IFDEF RET}
          10  :  Begin
                   If (IsACust(CustSupp)) then
                     KeyStart:=FullCustType(CustCode,Ret_CustSupp(SRN))+Chr(1)
                   else
                     KeyStart:=FullCustType(CustCode,Ret_CustSupp(PRN))+Chr(1);
                 End;
        {$ENDIF}
        else  KeyStart:=FullCustType(CustCode,CustSupp)+Chr(Ord(ViewNorm));
      end; {Case..}

      With LNHCtrl do
      Case Current_Page of

        LedgerPNo  :
              If (NHNeedGExt) then
              Begin
                If (CusExtObjPtr=nil) then
                  ExtObjCreate;

                With CusExtRecPtr^ do
                Begin

                  FCusCode:=FullCustCode(CustCode);

                  FNomAuto:=BOn;

                  FAlCode:=TradeCode[RecordMode];
                  FAlDate:=Today;

                  FPr:=NHPr;
                  FYr:=NHYr;

                  {If (UseOSNdx) and (SRCAlloc) then {* v5.00 only use this mode if src being created as otherwise allocated today would be lost.
                                                        Decided this was no good as even when allocating, using this index would mean
                                                        items started dissapearing as you allocated...

                  Begin
                    LKeypath:=InvOSK;
                    KeyStart:=FALCode+FCusCode;
                  end;}

                  If (Not NHOSFilt) then
                  Begin
                    If (FCr<>0) then
                       FMode:=2
                     else
                       FMode:=1;
                  end
                  else
                    FMode:=4;

                end;
              end
              else
              Begin
                If (CusExtObjPtr<>nil) then
                  ExtObjDestroy; {* Remove previous link *}

                ViewingAuto:=Not ViewNorm;

                UseSet4End:=ViewingAuto;
              end;

      end; {Case..}

      LKeyLen:=Length(KeyStart)-Ord(Not ViewNorm);

      IgnoreMsg:=IgMsg;

      { CJS 2012-10-19 - ABSEXCH-13603 - Sort View access violation on Trader ledger }
      if (Current_Page = LedgerPNo) and UseDefaultSortView then
      begin
        { CJS 2012-11-02 - ABSEXCH-13653 - incorrect default Sort View on trader
                                           ledgers }
        case CustFormMode of
          CUSTOMER_TYPE: MULCtrlO[Current_Page].SortViewType(0);
          CONSUMER_TYPE: MULCtrlO[Current_Page].SortViewType(1);
          SUPPLIER_TYPE: MULCtrlO[Current_Page].SortViewType(2);
        end;
        UseDefaultSortView := SortView.LoadDefaultSortView;
      end;

      { CJS 2012-10-19 - ABSEXCH-13603 - Sort View access violation on Trader ledger }
      if (Current_Page = LedgerPNo) and (SortViewEnabled or UseDefaultSortView) then
      begin
        SortView.HostListSearchKey := KeyStart;
        SortView.HostListIndexNo   := LKeyPath;
        SortView.Apply;
        SortView.Enabled := True;
        MulCtrlO[Current_Page].StartList(SortTempF, STFieldK, FullNomKey(MulCtrlO[Current_Page].SortView.ListID), '', '', 0, BOff);
        if MulCtrlO[Current_Page].SortView.Sorts[1].svsAscending then
          PageControl1.Pages[Current_Page].ImageIndex := 1
        else
          PageControl1.Pages[Current_Page].ImageIndex := 2;
      end
      else
        StartList(InvF,LKeypath,KeyStart,'','',LKeyLen,(Not ShowLines));



      IgnoreMsg:=BOff;
    end;
  finally
    ListBusy:=BOff;
  end; {Try..}
end;


procedure TCustRec3.FiltCP1BtnClick(Sender: TObject);
begin
  With MULCtrlO[Current_Page].LNHCtrl do
  Begin
    NHOSFilt:=Not NHOSFilt;

    InOSFilt:=NHOSFilt;

    NHNeedGExt:=(NHOSFilt or SDDMode);

    AutoCP1Btn.Enabled:=Not InOSFilt;
    ShowAuto1.Enabled:=AutoCP1Btn.Enabled;

    If (InOSFilt) then {* Reset Auto filter *}
    Begin
      ViewNorm:=BOn;

      AutoCP1BtnClick(Sender);
    end;

    RefreshList(BOn,BOn);


  end;
end;

procedure TCustRec3.AutoCP1BtnClick(Sender: TObject);

Const
  ButCaption  :  Array[BOff..BOn] of Str10 = ('Hide','Show');
begin
  If (Not InOSFilt) then
  Begin
    ViewNorm:=Not ViewNorm;


    RefreshList(BOn,BOn);
  end;

  AutoCP1Btn.Caption:=ButCaption[ViewNorm]+' A&uto';
  ShowAuto1.Caption:=AutoCP1Btn.Caption;

end;

{ ======= Link to Trans display ======== }
//PR: 12/12/2017 ABSEXCH-19451 Add AllowPostedEdit param
procedure TCustRec3.Display_Trans(Mode  :  Byte; const AllowPostedEdit : Boolean = False);

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

      ExLocal.AssignFromGlobal(InvF);

      With ExLocal,DispTrans do
      Begin
        LastDocHed:=LInv.InvDocHed;

        if AllowPostedEdit then
          DisplayOptions := [GDPR_AllowPostedEdit]
        else
          DisplayOptions := [];


        //PS 15820 : view button press (second time) do not work
        If (InHBeen) then
          Display_Trans(Mode,LInv.FolioNum,BOff,(Mode<>100), DisplayOptions);

        If (Mode<>100) then
          UpdateCS:=BOn;

      end; {with..}

    except

      DispTrans.Free;

    end;

end;



procedure TCustRec3.ViewCP1BtnClick(Sender: TObject);
Var
  Modus  :  Byte;

  //PR: 12/12/2017 ABSEXCH-19451
  AllowPostedEdit : Boolean;
begin
  With MULCtrlO[Current_Page] do
    If (ValidLine) then
    Begin
      //Initialise AllowPostedEdit
      AllowPostedEdit := False;

      RefreshLine(MUListBoxes[0].Row,BOff);

      InHBeen:=BOn;

      If (Sender=EditCP1Btn) or (Sender=Edit1) then
      begin
         AllowPostedEdit := True;
        {$IFDEF SOP}
          // MH 12/11/2014 Order Payments: Prevent editing of Order Payments Paymetns and Refunds
          If (Inv.thOrderPaymentElement In OrderPayment_PaymentAndRefundSet) Then
            // Change to View mode - after discussion with QA it was decided not to have an annoying popup message
            Modus := 100
          Else
            Modus:=2;
        {$ELSE}
          Modus:=2;
        {$ENDIF SOP}
      end
      else
        Modus:=100;

       //PR: 12/02/2016 v2016 R1 ABSEXCH-17038 Add check for security hook point 150 (Edit) & 155 (View)
      {$IFDEF CU}
      {$B-}
      //PR: 17/02/2016 v2016 R1 ABSEXCH-17314 Was checking mode rather than modus - D'oh!
      if ((Modus = 2) and ValidSecurityHook(2000, 150, ExLocal)) or
         ((Modus = 100) and ValidSecurityHook(2000, 155, ExLocal)) then
      {$B+}
      {$ENDIF Customisation}
      Display_Trans(Modus, AllowPostedEdit);

    end;
end;



procedure TCustRec3.CLORefPanelMouseUp(Sender: TObject;
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




procedure TCustRec3.CLORefLabMouseDown(Sender: TObject;
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


procedure TCustRec3.CLORefLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO[Current_Page]<>nil) then
      MULCtrlO[Current_Page].VisiList.MoveLabel(X,Y);

    NeedCUpdate:=MULCtrlO[Current_Page].VisiList.MovingLab;
  end;

end;

procedure TCustRec3.CurCP1BtnClick(Sender: TObject);

{$IFDEF MC_On}

  Var
    LedCur  :  TLCForm;

    mrRet   :  Word;
{$ENDIF}

begin
  {$IFDEF MC_On}

    LedCur:=TLCForm.Create(Self);

    try

      With MULCtrlO[Current_Page],VisiList do
      Begin
        mrRet:=LedCur.InitAS(LNHCtrl.NHCr,0,IdPanel(0,BOff).Color,IdPanel(0,BOff).Font);

        If (mrRet=mrOk) then
        Begin
          Set_CurrencyFilt;
          SetAllocBtns;
        end;
      end;

    finally

      LedCur.Free;

    end; {try..}

  {$ENDIF}
end;

procedure TCustRec3.SetAllocBtns;

Begin
  If (MULCtrlO[LedgerPNo]<>nil) then
  With MULCtrlO[LedgerPNo].LNHCtrl do
  Begin

    ALCp1Btn.Enabled:=(NHCr=0);
    PACp1Btn.Enabled:=ALCp1Btn.Enabled;
    UACp1Btn.Enabled:=ALCp1Btn.Enabled;

  end;

end;


procedure TCustRec3.HldCP1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  With MULCtrlO[Current_Page] do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);


       With TWinControl(Sender) do
       Begin
         ListPoint.X:=1;
         ListPoint.Y:=1;

         ListPoint:=ClientToScreen(ListPoint);

       end;



       PopUpMenu3.PopUp(ListPoint.X,ListPoint.Y);
    end;
  end;{with..}
end;




procedure TCustRec3.HQ1Click(Sender: TObject);
Var
  AuthBy:  Str10;
  KeyS  :  Str255;

  HoldMode,
  NotesMode
        :  Byte;

  Ok2Cont,Authorised
        :  Boolean;


begin
  // CJS 2014-05-06 - ABSEXCH-15170 - Sort View AV when changing Hold Flag
  //
  // Replaced ScanFileNum with InvF throughout this function, as ScanFileNum
  // holds the file number of the Sort View temporary file when a Sort View is
  // active, rather than the file number of the Transaction file.

  Ok2Cont:=BOn; Authorised:=BOff; AuthBy:=''; NotesMode:=232;

  With MULCtrlO[Current_Page],ExLocal do
  Begin
    If (ValidLine) and (Sender is TMenuItem) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);

      AssignFromGLobal(InvF);

      LGetRecAddr(InvF);


      {$IFDEF SY}
        If (TMenuItem(Sender).Tag=3) then
        Begin
          Ok2Cont:=Check_UserAuthorisation(Self,LInv,AuthBy);
          Authorised:=Ok2Cont;

          {$IFDEF CU}
            If (Ok2Cont) then {Check Hook happy}
              Ok2Cont:=ValidExitHook(2000,86,ExLocal);

          {$ENDIF}

        end;
      {$ENDIF}

      //PR: 24/02/2016 v2016 R1 ABSEXCH-17329 Add hold for query/cancel hold hook points. Copied from Daybk2.pas
      {$IFDEF CU}
      If (TMenuItem(Sender).Tag In [1 {Hold for Query}, 5 {Cancel Hold}]) Then
      Begin
        Ok2Cont := ExecuteCustBtn(2000, IfThen(TMenuItem(Sender).Tag = 1, 164, 165), ExLocal);  // Transaction Security - Hold for Query / Cancel Hold
      End // If (TMenuItem(Sender).Tag In [1 {Hold for Query}, 5 {Cancel Hold}])
      Else
      {$ENDIF}
        Ok2Cont := True;



      If (Ok2Cont) then
      Begin
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,InvF,BOff,GlobLocked);

        If (Ok) and (GlobLocked) then
        Begin

          With TMenuItem(Sender) do
            Case Tag of

              0..3  :  HoldMode:=Tag+200;

              5     :  HoldMode:=HoldDel;

              4,6   :  HoldMode:=Tag+217;

              else     HoldMode:=Tag+200;

            end; {Case..}

          If (Authorised) then
          With LInv do
          Begin
            AuthAmnt:=ConvCurrITotal(LInv,BOff,BOn,BOn); {Record prev total in base for subsequent authorisation comparison}

            {$IFDEF C_On}
              If (AuthBy<>'') then {Make a note}
              Begin
                Add_Notes(NoteDCode,NoteCDCode,FullNomKey(LInv.FolioNum),Today,
                          LInv.OurRef+' was authorised by '+Trim(AuthBy)+'. For '+FormatCurFloat(GenRealMask,ITotal(LInv),BOff,Currency),
                          NLineCount);

                SetHold(NotesMode,InvF,Keypath,BOff,LInv);
              end;
            {$ENDIF}
          end;

          AssignToGLobal(InvF);

          SetHold(HoldMode,InvF,Keypath,BOn,Inv);

          UnLockMLock(InvF,LastRecAddr[InvF]);

          Set_Row(MUListBoxes[0].Row);
        end;
      end; {If Authorise ok..}
    end; {If ok..}
  end;{with..}
end;


procedure TCustRec3.SN1Click(Sender: TObject);
Var
  KeyS  :  Str255;
  bExecuteHook,
  bIsShowPIITree : Boolean;
  LockPos : LongInt;
  iStatus : SmallInt;
  CustSavePos : TBtrieveSavePosition;
  lAnonDiaryDetail: IAnonymisationDiaryDetails;
  lAnonEntityType: TAnonymisationDiaryEntity;
  lRes,
  lEmpRes: Integer;
begin
  KeyS:='';

  With ExLocal do
  Begin
    CustSavePos := TBtrieveSavePosition.Create;
    Try
      // PS - 29-10-2015 - ABSEXCH-16275  // Save the current position in the file for the current key
      CustSavePos.SaveFilePosition (CustF, GetPosKey);
      CustSavePos.SaveDataBlock (@Cust, SizeOf(Cust));

      // PS - 29-10-2015 - ABSEXCH-16275  // Get and Lock the Customer/Supplier record
      KeyS := FullCustCode(ExLocal.LCust.CustCode);
      iStatus := Find_Rec(B_GetEq+B_MultNWLock, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, KeyS);      //B_GetEq+B_MultLock

      LGetRecAddr(CustF);

      //PR: 13/11/2015 Removed call to LGetMultiRec - no longer needed as we're locking the record in the Find_Rec call
      If iStatus = 0 then
      Begin
        LCust.AccStatus:=TMenuItem(Sender).Tag;

        {* Update last edited flag *}

        LCust.LastUsed:=Today;
        LCust.TimeChange:=TimeNowStr;

        //AP:29/11/2017 2018 R1 : ABSEXCH-19385:Trader Open/Close behaviour
        lRes := -1;
        lAnonEntityType := adeCustomer;
        if GDPROn then
        begin                          
          case CustFormMode of
            CUSTOMER_TYPE,
            CONSUMER_TYPE : lAnonEntityType := adeCustomer;
            SUPPLIER_TYPE : lAnonEntityType := adeSupplier;
          end;
          lAnonDiaryDetail := CreateSingleAnonObj;
          if Assigned(lAnonDiaryDetail) then
          begin
            case LCust.AccStatus of
              0, 1, 2 :
                  begin 
                    //Remove Entry from AnonymisationDiary Table
                    lRes := lAnonDiaryDetail.RemoveEntity(lAnonEntityType, LCust.CustCode);
                    if lRes = 0 then
                    begin
                      LCust.acAnonymisationStatus := asNotRequested;
                      LCust.acAnonymisedDate := '';
                      LCust.acAnonymisedTime := '';
                      FListScanningOn := True;
                      AnonymisationON := False;
                    end;
                  end;
              3:  begin {Close Status}
                   //Add Entry into AnonymisationDiary Table
                    lAnonDiaryDetail.adEntityType := lAnonEntityType;
                    lAnonDiaryDetail.adEntityCode := LCust.CustCode;
                    lRes := lAnonDiaryDetail.AddEntity;
                    if lRes = 0 then
                    begin
                      LCust.acAnonymisationStatus := asPending;
                      LCust.acAnonymisedDate :=  lAnonDiaryDetail.adAnonymisationDate;
                      LCust.acAnonymisedTime := TimeNowStr;
                      FListScanningOn := True;
                      AnonymisationON := True;
                    end;
                  end;
            end;
          end; //if Assigned(lAnonDiaryDetail) then
        end; // if GDPROn then

        Status:=Put_Rec(F[CustF],CustF,LRecPtr[CustF]^,SKeyPAth);

        //RB 09/01/2018 ABSEXCH-19555: Trader Open/Close behaviour impact on Employee and Jobs.
        if (StatusOk) and (LCust.AccStatus = 3) and (CustFormMode = SUPPLIER_TYPE) then
        begin
          //Search sub contractor and closed them as well
          KeyS := PartCCKey(JARCode, JASubAry[3]);
          lEmpRes := Find_Rec(B_GetFirst, F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK, KeyS);
          with JobMisc.EmplRec do
          begin
            while (lEmpRes = 0) do
            begin
              if (EType = 2) and (emStatus <> emsClosed) and
                 (emAnonymisationStatus <> asAnonymised) and
                 (Trim(Supplier) = Trim(LCust.CustCode)) then
              begin
                emStatus := emsClosed;    {1: close the sub-contractor}
                emAnonymisationStatus := asPending;
                emAnonymisedDate := LCust.acAnonymisedDate;
                emAnonymisedTime := TimeNowStr;
                lEmpRes := Put_Rec(F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK);
              end;
              lEmpRes := Find_Rec(B_GetNext, F[JMiscF], JMiscF, RecPtr[JMiscF]^, JMK, KeyS);
            end;
          end;
        end;

        //AP 16/01/2018 ABSEXCH-19569:"Anonymisation Pending Date" and "Anonymised Date" implementation in Trader, Employee and their transactions
        if (lRes = 0) and GDPROn then
        begin
          if (not StatusOk) and (LCust.AccStatus = 3) then
            lAnonDiaryDetail.RemoveEntity(lAnonEntityType, LCust.CustCode);
          if StatusOk then
            SendMessage(Application.MainForm.Handle, WM_FormCloseMsg, 103, 0);
        end;

        // MH 16/03/2015 v7.0.10 ABSEXCH-15482: Added hook points for change of Customer/Supplier Status
        bExecuteHook := (Status = 0);

        //TW 27/10/2011 Add Edit audit note if status update is successful.
        if (status = 0) then
          TAuditNote.WriteAuditNote(anAccount, anEdit, ExLocal);

        Report_Berror(CustF,Status);

        Status:=UnLockMLock(CustF,LastRecAddr[CustF]);

        {$IF Defined(CU)}
        // MH 16/03/2015 v7.0.10 ABSEXCH-15482: Added hook points for change of Customer/Supplier Status
        If bExecuteHook Then
        Begin
          // 200 = Customer Status Changed, 201 = Supplier Status Changed
          GenHooks(1000, IfThen(LCust.CustSupp = TradeCode[BOn], 200, 201), ExLocal);
        End; // if bExecuteHook
        {$IFEND}

        OutCust;

        PrimeButtons;

        //SSK 30/01/2018 2018-R1 ABSEXCH-19686: Show PII Tree, on Close status if "Display the PII Information Window..." option is ticked
        if (StatusOk) and (LCust.AccStatus = 3) and SystemSetup.GDPR.GDPRTraderDisplayPIITree and GDPROn then
        begin
          if (CustFormMode = SUPPLIER_TYPE)  then
            bIsShowPIITree := ChkAllowed_In(uaAccessForSupplier)
          else
            bIsShowPIITree := ChkAllowed_In(uaAccessForCustomerConsumer);

          if bIsShowPIITree then
            btnPIITreeClick(SN1);
        end;

      end; {If Locked ..}
      CustSavePos.RestoreDataBlock (@Cust);
      CustSavePos.RestoreSavedPosition;
    Finally
      CustSavePos.Free;
    End; // Try..Finally
  end; {With..}
end; {Proc..}





procedure TCustRec3.CopyCP1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  Case Current_Page of

    {$IFDEF PF_On}
      {$IFDEF STK}
        DiscPNo
           :  With MULCtrlO2[Current_Page] do
              Begin
                If (Not InListFind) then
                Begin
                  With TWinControl(Sender) do
                  Begin
                    ListPoint.X:=1;
                    ListPoint.Y:=1;

                    ListPoint:=ClientToScreen(ListPoint);

                  end;

                  PopUpMenu5.PopUp(ListPoint.X,ListPoint.Y);
                end;
              end;{with..}

      {$ENDIF}
    {$ENDIF}

    LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo
       :  With MULCtrlO[Current_Page] do
          Begin
            If (ValidLine) and (Not InListFind) then
            Begin
              RefreshLine(MUListBoxes[0].Row,BOff);


               With TWinControl(Sender) do
               Begin
                 ListPoint.X:=1;
                 ListPoint.Y:=1;

                 ListPoint:=ClientToScreen(ListPoint);

               end;



               PopUpMenu4.PopUp(ListPoint.X,ListPoint.Y);
            end;
          end;{with..}
      {$IFDEF SOP}
       MultiBuyPNo
           :  With MULCtrlO[Current_Page] do
              Begin
                If (Not InListFind) then
                Begin
                  With TWinControl(Sender) do
                  Begin
                    ListPoint.X:=1;
                    ListPoint.Y:=1;

                    ListPoint:=ClientToScreen(ListPoint);

                  end;

                  PopUpMenu5.PopUp(ListPoint.X,ListPoint.Y);
                end;
              end;{with..}
      {$ENDIF}

  end; {Case..}
end;

procedure TCustRec3.HistCP1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  If (RecordMode) or (Debug) then
  Begin
    If (Sender<>Hist1) then
    Begin
      With TWinControl(Sender) do
      Begin
        ListPoint.X:=1;
        ListPoint.Y:=1;

        ListPoint:=ClientToScreen(ListPoint);

      end;

      PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
    end;
  end
  else
    Bal1Click(Bal1);

end;


procedure TCustRec3.Copy2Click(Sender: TObject);
Var
  bCont : Boolean;
begin
  If (Sender Is TMenuItem) then
    With TMenuItem(Sender) do
    Begin
      {$IFDEF SOP}
        // MH 12/11/2014 Order Payments: Added confirmation checks for Order Payment Transactions being Reversed
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
        ContraCopy_Doc(Inv.FolioNum,Tag,'');
        UpdateCS:=BOn;

        SendMessage(Self.Handle,WM_CustGetRec,121,0);
      End; // If bCont
    end;
end;



procedure TCustRec3.JmpCp1BtnClick(Sender: TObject);
begin
  If (MULCtrlO[LedgerPNo]<>nil) then
    With MULCtrlO[LedgerPNo] do
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);
      Find_OnList(0,'');
    end;
end;


procedure TCustRec3.DisCP1BtnClick(Sender: TObject);

Var
  LAddr  :  LongInt;
  KeyS   :  Str255;

begin
  KeyS:='';

  If (Assigned(MULCtrlO[LedgerPNo])) then
  With MULCtrlO[LedgerPNo] do
  Begin
    GetSelRec(Boff);

    If (ValidLine) and (Not InListFind) and (Found_DocEditNow(Inv.FolioNum)=0) then
    Begin
      
      Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,ScanFileNum,BOff,GlobLocked,LAddr);

      If (Ok) And (GlobLocked) then
      Begin
        SetDocDisc(ScanFileNum,Keypath,(Sender=ALCP1Btn),SRCAlloc);

        Set_Row(MUListBoxes[0].Row);

        Status:=UnLockMultiSing(F[ScanFileNum],ScanFileNum,LAddr);

        OutAlloc;
      end;

    end
    else
    Begin
      If (Found_DocEditNow(Inv.FolioNum)<>0) then
        Warn_DocEditNow;
    end;

  end;{with..}
end;

procedure TCustRec3.Display_History(HistMode     :  Byte;
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

      NHMode:=8+(11*Ord(HistMode=3));
      NBMode:=11;

      NHCr:=0;
      NHTxCr:=0;
      NHPr:=1;
      NHYr:=GetLocalPr(0).CYr;

      NHCCode:=FullNCode(ExLocal.LCust.CustCode);

      NHKeyLen:=NHCodeLen+2;

      With Nom do
      Begin
        Find_FirstHist(CustHistAry[HistMode],NomNHCtrl,fPr,fYr);
        MainK:=FullNHistKey(CustHistAry[HistMode],NHCCode,NHCr,fYr,fPr);
        AltMainK:=FullNHistKey(CustHistAry[HistMode],NHCCode,NHCr,0,0);
      end;

      Set_NHFormMode(NomNHCtrl);

      ExLocal.AssignToGlobal(CustF);

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

     If (WasNew) then
     Begin
       If (Current_Page=LedgerPNo) then
       With MULCtrlO[LedgerPNo],LNHCtrl do
       Begin

          If ((DisplayMode<>6) and (HistForm.NHCtrl.NHMode=19))
          or ((DisplayMode<>0) and (HistForm.NHCtrl.NHMode<>19)) then
            GenCP3BtnClick(nil);

       end; {With..}
     end;

    except

     HistFormPtr:=nil;

     HistForm.Free;
     HistForm:=nil;

    end; {try..}

{$ELSE}
begin
{$ENDIF}

end;


procedure TCustRec3.Display_Match(ChangeFocus,
                                  MatchMode     :  Boolean);

Var
  NomNHCtrl  :  TNHCtrlRec;

  FoundLong  :  Longint;

  MatchForm  :  TMatchWin;
  WasNew     :  Boolean;
Begin
  //sNew:=BOff;

  // CJS 18/03/2011 - ABSEXCH-9646
  With EXLocal,NomNHCtrl do
  Begin
    AssignFromGlobal(InvF);

    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

    NHMode:=4-Ord(MatchMode);

    NHCr:=MULCtrlO[Current_Page].LNHCtrl.NHCr;

    MainK:=FullMatchKey(MatchTCode,MatchSCode,LInv.OurRef);

    NHKeyLen:=Length(MainK);

    Set_MAFormMode(NomNHCtrl);

  end;

  // CJS 2011-06-30 - Reinstate original processing for Sales & Works Orders
  if (PageControl1.ActivePageIndex = LedgerPNo) then
  begin
    Show_Matching(ChangeFocus);
  end
  else
  begin
    If (MatchFormPtr=nil) then
    Begin
      WasNew:=BOn;

      MatchForm:=TMatchWin.Create(Self);

      MatchFormPtr:=MatchForm;

    end
    else
      MatchForm:=MatchFormPtr;

    Try

     With MatchForm do
     Begin

       WindowState:=wsNormal;

       If (ChangeFocus) then
         Show;

       ShowLink(BOn);


     end; {With..}

    except

     MatchFormPtr:=nil;

     MatchForm.Free;
     MatchForm:=nil;

    end; {try..}
  end;

end;

// CJS 18/03/2011 - ABSEXCH-9646
procedure TCustRec3.Show_Matching(ChangeFocus: Boolean);
var
  Frm : TFrmObjectUnallocate;
  // CJS 27/05/2011 - ABSEXCH-9646 correction - only load the tree if the
  // tree view is already open. If it has to be created, it will be loaded
  // automatically.
  AlreadyLoaded: Boolean;
begin
  AlreadyLoaded := False;
  if (not Assigned(MatchingFrm)) then
  begin
    // Create new form and cache for future reference
    Frm := TFrmObjectUnallocate.Create(self, oufMatching);
    MatchingFrm := Frm;
    // The tree is automatically loaded when the
    // form is first created.
    AlreadyLoaded := True;
  end;
  try
    Frm := TFrmObjectUnallocate(MatchingFrm);
    Frm.WindowState := wsNormal;
    if not AlreadyLoaded then
      Frm.LoadTree(True);
    Frm.Show;
    if not ChangeFocus then
      self.Show;
  except
    FreeAndNil(Frm);
    MatchingFrm := nil;
  end;
end;

procedure TCustRec3.Bal1Click(Sender: TObject);
begin
  If (Sender is TMenuItem) then
  With TMenuItem(Sender) do
  Begin
    Display_History(Tag,BOn);
  end;
end;


procedure TCustRec3.MACP1BtnClick(Sender: TObject);
begin
  If (MULCtrlO[Current_Page]<>nil) then
  With MULCtrlO[Current_Page],EXLocal do
  Begin
    If (ValidLine) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);

      //PR: 12/02/2016 v2016 R1 ABSEXCH-17038 Add check for security hook point 155 (View)
      {$IFDEF CU}
      if ValidSecurityHook(2000, 153, ExLocal) then
      {$ENDIF Customisation}
        Display_Match(BOn,((Inv.RemitNo<>'') or (Inv.OrdMatch)));

    end;
  end;
end;

{ Create / update the linked letter list }
procedure TCustRec3.LettrBtnClick(Sender: TObject);
begin
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
      LetterForm.LoadLettersFor (ExLocal.LCust.CustCode,
                                 ExLocal.LCust.CustCode,
                                 Trim(ExLocal.LCust.CustCode),
                                 TradeCode[IsACust(ExLocal.LCust.CustSupp)],
                                 @ExLocal.LCust, Nil, Nil, Nil, Nil);
    Except
     LetterActive := BOff;
     LetterForm.Free;
    End;
  {$ENDIF}
end;


{ ============================ Allocation Control methods ========================== }


{ ============ Allocate Documents ============ }

Procedure TCustRec3.Allocate(AlMode  :  Byte);


Var
  UOR,
  HMode   :  Byte;

  AlCnst  :  Integer;
  AddThen,
  AddNow,
  AddOwnC,
  UseTRate:  Real;
  Ok2Store,
  Ok2Match,
  Ok2Round:  Boolean;
  OCust   :  CustRec;
  TmpInv  :  InvRec;
  SwitchFileNum: Boolean;
  FileNumBackup: Integer;

  KeyS    :  Str255;

  //PR: 15/05/2015 ABSEXCH-16284 Dummy variable added for call to PartAllocate
  TakePPD : Boolean;

Begin
  FileNumBackup := 0;
  KeyS:=''; UOR:=0;

  With MULCtrlO[LedgerPNo],ExLocal,LInv do
  Begin
    AssignFromGlobal(InvF);

    //GS 08/08/2011 ABSEXCH-10823: if the 'scan file' is targeting the 'temp sort' table,
    //then adjust it to point to the 'invoices' table
    if ScanFileNum = SortTempF then
    begin
      //keep a backup of the orig value
      FileNumBackup := ScanFileNum;
      //set the file number
      ScanFileNum := InvF;
      //set a boolean to indicate we have switched the file number;
      //can be used to revert the switch later
      SwitchFileNum := True;
    end
    // MH 23/10/2014 Order-Payments ABSEXCH-15756: Ininitialised var was causing the ScanFileNum to be set to 4 million+
    Else
      SwitchFileNum := False;

    //GS 08/08/2011 ABSEXCH-10823: this is causing the crash; attempting to get the
    //local record address of the SortTempF (ScanFileNum = 24) file, but the local record structure does not
    //have a 'SortTemp' record.. returns nil in the record address array (LRecPtr[24]) which eventually gets
    //read and causes a crash
    LGetRecAddr(ScanFileNum);

    Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,ScanFileNum,BOff,GlobLocked);


    If (Ok) and (GlobLocked) then
    With SyssCurr.Currencies[Currency],GlobalAllocRec^[SalesOrPurch(InvdocHed)] do
    Begin
      AlCnst:=1; AddThen:=0;  AddNow:=0;

      UseTRate:=CRates[UseCoDayRate]; {* Use the current rate for own currency conversions *}

      AddOwnC:=0;

      Ok2Store:=BOff;

      Ok2Match:=BOff;

      Ok2Round:=BOff;

      OCust:=LCust;

      Case AlMode of
        3,5   :  Begin
                   Ok2Store:=((Not SettledFull(LInv)) or (SBSIn));

                   If (Ok2Store) and (Not Master_Allocate(LInv)) and (LRemitDoc='') then
                   Begin
                     CustomDlg(Self,'WARNING!','Incorrect Allocation',
                             'The payment part has not been allocated.'+#13+#13+
                             'In order for the matching information to be applied correctly '+
                             'the payment part of an allocation must be allocated first.',
                             mtWarning,
                             [mbOk]);

                     Ok2Store:=(SBSIn);{ or (Not SRCAlloc);}
                   end;

                   If (Ok2Store) then
                   Begin
                     If (Master_Allocate(LInv)) then
                     Begin
                       LRemitDoc:=OurRef;

                       LLastMDoc:=InvDocHed;    {* Store Last Matched part *}

                       LCADate:=TransDate;      {* v5.71 Set master receipt date for subsequent invoices *}
                     end
                     else
                       RemitNo:=LRemitDoc;



                     If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* Cash Accounting set VATdate to Current
                                                                           VATPeriod *}
                     Begin
                       // VATPostDate:=SyssVAT.VATRates.CurrPeriod;

                       VATPostDate:=CalcVATDate(LCADate);  {v5.71. CA Allows jump to future period, set from period of receipt part}

                     end;

                     If (AlMode=3) then {* Can only set date for full allocate, part allocate must remain OS *}
                                      {* This means the date will be unavailable on part allocated cash accounting *}
                       UntilDate:=Today;



                     

                     Ok2Match:=(RemitNo<>'');  {* Flag to set up multiple matching on invoice part only *}



                     If (AlMode=5) then
                       With CLORefPanel do
                         AddThen:=PartAlloc(LInv,SRCInv.Currency,Color,Font,Self,AddNow,AddOwnC,Ok2Store, TakePPD)
                     else
                     Begin
                       AddThen:=BaseTotalOs(LInv);

                       AddNow:=CurrencyOs(LInv,BOff,BOn,BOff);  {* Allocated straight conversion *}

                       AddOwnC:=CurrencyOs(LInv,BOff,BOn,UseCoDayRate{BOff});  {* Allocated straight conversion *}

                       If (CXRate[BOff]=0) then
                       Begin
                         CXrate[BOff]:=CRates[BOff];

                       end;


                       If (Not (InvDocHed In RecieptSet)) then
                       Begin


                         If (GetHoldType(HoldFlg)=HoldA) then
                           HMode:=HoldDel;

                         SetHold(HMode,ScanFileNum,KeyPAth,BOff,LInv);
                       end;
                     end;
                   end;

                   AlCnst:=1;
                 end;

        4     :  Begin

                   Ok2Store:=((Settled<>0) and (Not ReValued(LInv)));

                   If (Ok2Store) or (SBSIn) then
                   Begin

                     Ok2Match:=(RemitNo<>'');


                     RemitNo:='';


                     If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* Cash Accounting set Blank VATdate &
                                                                           Until Date *}
                     Begin
                       If (SettledVAT=0) then
                       Begin

                         Blank(VATPostDate,Sizeof(VATPostDate));

                         UntilDate:=NdxWeight;

                         {Blank(UntilDate,Sizeof(UntilDate));}

                       end
                       else
                       Begin

                         VATPostDate:=SyssVAT.VATRates.CurrPeriod;

                         UntilDate:=Today;

                       end;
                     end
                     else
                       {Blank(UntilDate,Sizeof(UntilDate));}
                       UntilDate:=NdxWeight;



                     AddThen:=Settled;

                     {$IFDEF WAS430}
                       XXX Do not compile!

                       UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                       AddNow:=Conv_TCurr(CurrSettled,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

                       UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

                       AddOwnC:=Conv_TCurr(CurrSettled,XRate(CXRate,UseCoDayRate{BOff},Currency),Currency,UOR,BOff);
                     {$ELSE}
                        UOR:=fxUseORate(Not UseCoDayRate,BOn,CXRate,UseORate,Currency,0);

                        AddNow:=Conv_TCurr(CurrSettled,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

                        AddOwnC:=Conv_TCurr(CurrSettled,UseTRate,Currency,0,BOff);

                     {$ENDIF}

                     If (SettledFull(LInv)) then
                     Begin
                                                         {* v4.32 Don't reset this if its been purged *}
                       If (Not (InvDocHed In DirectSet)) and (AfterPurge(AcYr,0)) then
                         CXRate[BOff]:=0;


                       {$B- * As from v1.17 this is now recalculated in the actual revaluation
                              because you are effectively changing the header value making required <>0

                       If (InvDocHed In RecieptSet) and ((ConvCurrITotal(Inv,Off,Off,Off)-TotalInvoiced)<>0) then
                       Begin

                       {$B+

                         TotalInvoiced:=ConvCurrITotal(Inv,Off,Off,Off);

                       end;}


                     end;

                   end
                   else
                     If (Settled<>0) then
                       Warn_Revalued;

                   AlCnst:=-1;

                 end;
      end; {Case..}


      If (Ok2Store) then
      Begin
        AddThen:=(AddThen*AlCnst);

        AddNow:=(AddNow*AlCnst);

        AddOwnC:=(AddOwnC*AlCnst);


        Settled:=Settled+Round_Up(AddThen,2);

        If (Not UseCoDayRate) then {* Own currency will shadow Fullunallocated *}
          AddOwnC:=AddNow;

        {$IFDEF WAS430}
          XXX!!!

          UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

          CurrSettled:=CurrSettled+Round_Up(Conv_TCurr(AddOwnC,XRate(CXRate,UseCoDayRate{BOff},Currency),Currency,UOR,BOn),2);
        {$ELSE}
          UOR:=0;

          CurrSettled:=CurrSettled+Round_Up(Conv_TCurr(AddOwnC,UseTRate,Currency,UOR,BOn),2);
        {$ENDIF}

        Set_DocAlcStat(LInv);  {* Set Allocation Status *}

        {$IFDEF JC}
          Set_DocCISDate(LInv,(AlMode=4));
        {$ENDIF}

        If (LastRecAddr[Scanfilenum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpInv:=LInv;

          LSetDataRecOfs(Scanfilenum,LastRecAddr[Scanfilenum]);

          Status:=GetDirect(F[Scanfilenum],Scanfilenum,LRecPtr[Scanfilenum]^,KeyPAth,0); {* Re-Establish Position *}

          LInv:=TmpInv;

        end;

        Status:=Put_Rec(F[Scanfilenum],Scanfilenum,LRecptr[Scanfilenum]^,keypath);

        AssignToGlobal(ScanFileNum);

        Report_BError(ScanFileNum,Status);

        If (StatusOk) then
        Begin
          UpdateAllBal(AddThen,AddNow,AddOwnC,BOn,InvdocHed);

          StopPageChange:=((Round_Up(LUnallocated,2)<>0.00) and (Not SBSIn));

          OutAlloc;

          {$IFDEF MC_On}

              {$IFDEF WAS430}
                XXX!!!

                If (Ok2Match) then
                Begin
                  UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

                  Match_Payment(LInv,AddThen,Round_Up(Conv_TCurr(AddOwnC,XRate(CXRate,UseCoDayRate{BOff},Currency),Currency,UOR,BOn),2),AlMode);
                end;
              {$ELSE}

                If (Ok2Match) then
                Begin
                  Match_Payment(LInv,AddThen,Round_Up(Conv_TCurr(AddOwnC,UseTRate,Currency,UOR,BOn),2),AlMode);
                end;


              {$ENDIF}

          {$ELSE}  {* Just in case AddNow causes problems on SC *}

            If (Ok2Match) then
              Match_Payment(LInv,AddThen,Round_Up(Conv_TCurr(AddThen,XRate(CXRate,BOff,Currency),Currency,0,BOn),2),AlMode);

          {$ENDIF}

          {$IFDEF CU}
             if Ok2Match then
               TriggerAllocatedHook(AlMode = 4);
          {$ENDIF}
        end
        else
          LCust:=OCust;

      end;

      Set_Row(MUListBoxes[0].Row);

      UnLockMLock(ScanFileNum,LastRecAddr[ScanFileNum]);
      //GS 08/08/2011 ABSEXCH-10823: if the file num has been modified; revert its value
      if SwitchFileNum = True then
      begin
        ScanFileNum := FileNumBackup;
        SwitchFileNum := False;
      end;
    end; {With..}
  end;
end;


procedure TCustRec3.UseAllocWiz;

Var
  IsCredit,IsOS  :  Boolean;

  GenStr         :  Str255;

Begin
  Set_alSales(RecordMode,BOn);

  With ExLocal do
  Begin
    AssignFromGlobal(InvF);

    IsCredit:=PayRight(LInv,RecordMode);
    IsOS:=(BaseTotalOS(LInv)<>0.0);

    If (IsOS) and (IsCredit) then
    Begin
      With TAllocateWiz.Create(Self) do
      Try
        Set_UpTransAlloc;

      except
        Free;

      end; {try..}
    end
    else
    Begin
      If (IsOS) then
        GenStr:='all allocations must start with a credit.'
      else
        GenStr:='this transaction is not outstanding.';

      CustomDlg(Self,'Please Note!','Incorrect Allocation',
                           'It is not possible to allocate '+LInv.OurRef+' because '+GenStr+#13+#13+
                           'Please choose a different transaction to allocate.',
                           mtInformation,
                           [mbOk]);

    end;

  end; {With..}
end;


procedure TCustRec3.AlCP1BtnClick(Sender: TObject);
var
  OK2Continue : Boolean;
begin
  If (MULCtrlO[LedgerPNo]<>nil) and ((Sender is TButton) or (Sender Is TMenuItem)) then
  With MULCtrlO[LedgerPNo],TWincontrol(Sender) do
    If (ValidLine) and (Not InListFind) and ((Not InSRC[RecordMode]) or (SRCAlloc)) and (CanAllocate) and (Not (Inv.InvDocHed In DirectSet) and (Inv.NomAuto)) then
    Begin
      UpdateCS:=BOn;

      GetSelRec(BOff);

      If (Found_DocEditNow(Inv.FolioNum)=0) and (Autho_Doc(Inv)) then
      Begin
        {$IFDEF SOP}
        // MH 24/10/2014 Order Payments: Added check on whether user can Allocate/Unallacate an Order Payments transaction
        // MH 07/11/2014 ABSEXCH-15803: Modified to always display the dialog for Order Payments transactions, even if OrdPay is turned off
        If OrdPay_OKToAllocate(Self, Inv, Tag In [3, 5]) Then
        {$ENDIF SOP}
        Begin
          {$B-}
            If (Tag<>4) and (ChkAllowed_In(ChkPWord(LedgerPNo,[LedgerPNo],411,414))) and (Not SBSIn) and (Not SRCAlloc) then
          {$B+}
              UseAllocWiz
            else
            Begin
              If ((Tag In [3,5]) and (Not Inv.PDiscTaken) and ((Inv.RunNo>0) or (Not Inv.DiscTaken))) or ((Tag=4) and (Inv.PDiscTaken)) then
                DisCP1BtnClick(ALCP1Btn);

              //PR: 14/07/2015 ABSEXCH-16660 Warn the user if trying to full allocate when PPD is available
              //               part allocation is handled in the Part Allocation form (CLPAlMCU.pas) where we know what the value is
              //PR: 19/08/2015 ABSEXCH-16772 Add PayRight to check for trying to allocate Inv before SCR/PPY
              if (Inv.InvDocHed in PPDTransactions) and (Cust.acPPDMode <> pmPPDDisabled) and
                 (Inv.thPPDTaken = ptPPDNotTaken) and
                 (PayRight(Inv,RecordMode) or (Round_Up(GlobalAllocRec^[IsSales].LUnallocated, 2) <> 0.00)) then
              begin
                if Tag = 3  then //Full allocation
                begin
                  if (Cust.acPPDMode = pmPPDEnabledWithManualCreditNote) and
                  (Abs(CurrencyOS(Inv, True, False, False)) =  Round_Up(Inv.thPPDGoodsValue + Inv.thPPDVATValue, 2)) then
                    Ok2Continue := True
                else
                  OK2Continue := msgBox('This transaction has PPD available. You won''t be able to ' + PPDGiveTakeWord(Inv.CustSupp, False) +
                                        ' the PPD if you continue.'#10#10'Are you sure you want to continue?', mtConfirmation,
                                        [mbYes, mbNo], mbNo, 'PPD Available') = mrYes;
                end
                else
                  Ok2Continue := True; //Part allocation - handled in ClPalmcU
              end
              else
                OK2Continue := True;

              if OK2Continue then
                 Allocate(Tag)
            end;
        End; // IFDEF SOP ...
      end
      else
        If (Not Autho_Doc(Inv)) then
          ShowMessage('This transaction has not been authorised!')
        else
          Warn_DocEditNow;

    end;
end;


procedure TCustRec3.Block_Unalocate;
Var
  ObjUnallocateF : TFrmObjectUnallocate;
Begin
  {$IFDEF SOP}
  // MH 24/10/2014 Order Payments: Added check on whether user can Allocate/Unallacate an Order Payments transaction
  // MH 07/11/2014 ABSEXCH-15803: Modified to always display the dialog for Order Payments transactions, even if OrdPay is turned off
  If OrdPay_OKToAllocate(Self, Inv, False) Then
  {$ENDIF SOP}
  Begin
    If (Not Assigned(DispOUPtr)) Then
    Begin
      // Create new form and cache for future reference
      ObjUnallocateF := TFrmObjectUnallocate.Create(Self, oufUnallocate);
      DispOUPtr := ObjUnallocateF;
    End // If (Not Assigned(DispOUPtr))
    Else
      // Use existing reference
      ObjUnallocateF := DispOUPtr;

    Try
      ObjUnallocateF.Show;
    Except
      ObjUnallocateF.Free;
      DispOUPtr := NIL;
    End;
  End; // If OrdPay_OKToAllocate(Self, Inv, False) 
end;



procedure TCustRec3.Unal1Click(Sender: TObject);
begin
  If (Sender is TMenuItem) then
    Case TMenuITem(Sender).Tag of
      1  :  Begin
              ManUnal:=BOn;
              AlCP1BtnClick(UACP1Btn);
            end;
      2  :  Block_Unalocate;
    end; {Case..}
end;


procedure TCustRec3.Give_UnalOptions;

Var
  ListPoint  :  TPoint;

Begin
  GetCursorPos(ListPoint);

  With ListPoint do
  Begin
    X:=X-50;
    Y:=Y-15;
  end;

  {$IFDEF CU}
    ExLocal.AssignFromGlobal(InvF);

    UnAl1.Enabled:=ExecuteCustBtn(2000,159,ExLocal);
  {$ENDIF}


  PopUpMenu8.PopUp(ListPoint.X,ListPoint.Y);

end;


procedure TCustRec3.UACP1BtnClick(Sender: TObject);
begin

  If (MULCtrlO[LedgerPNo]<>nil) and ((Sender is TButton) or (Sender Is TMenuItem)) then
  With MULCtrlO[LedgerPNo],TWincontrol(Sender) do
    If (ValidLine) and (Not InListFind) and ((Not InSRC[RecordMode]) or (SRCAlloc)) and (CanAllocate) and (Not (Inv.InvDocHed In DirectSet) and (Inv.NomAuto)) then
    Begin {Block unallocate assumed if specificialy set, or if wizard unallocate being used *}
      If ((Not (ChkAllowed_In(ChkPWord(LedgerPNo,[LedgerPNo],412,415)))) and (Not ChkAllowed_In(ChkPWord(LedgerPNo,[LedgerPNo],411,414))))
          {or (ManUnal)} or (Inv.Settled=0.0) or (SRCAlloc) then
        AlCP1BtnClick(Sender)
      else
        If (ChkAllowed_In(ChkPWord(LedgerPNo,[LedgerPNo],411,414))) and (Not SBSIn) then
          Block_Unalocate
        else
          Give_UnalOptions;
    end;
end;

procedure TCustRec3.SetCP1BtnClick(Sender: TObject);

Var
  mrResult  :  Word;

  SetForm   :  TSettleForm;

begin

  If (CanAllocate) then
  Begin

    mrResult:=MessageDlg('Please confirm you wish to automatically allocate transactions',
                          mtConfirmation,[mbYes,mbNo],0);

    If (mrResult=mrYes) then
    With MULCtrlO[LedgerPNo] do
    If (ValidLine) then
    Begin
      SetForm:=TSettleForm.Create(Self);

      try
        With SetForm do
        Begin
          GetSelRec(Boff);

          Prime_Settle(ScanFileNum,Keypath,KeyRef,SRCInv,(2*Ord(SRCAlloc)));

          OutAlloc;

          PageUpDn(0,BOn);

          UpdateCS:=BOn;
        end;
      finally


        SetForm.Free;

      end; {try..}


    end;
  end;
end;

procedure TCustRec3.ChkCP1BtnClick(Sender: TObject);
begin
  Case Current_Page of

    {$IFDEF PF_On}
      {$IFDEF STK}
        DiscPNo
             :  With EXLocal,LCust do
                  Check_CDDisc(CustSupp,CustCode,MiscF,MIK,2);

      {$ENDIF}
    {$ENDIF}

    LedgerPNo  :  ;

    {$IFDEF SOP}
    MultiBuyPNo:   With EXLocal.LCust do
                    mbdFrame.CheckDiscounts(CustCode, CustSupp);
    {$ENDIF}

  end {case..}
end;

procedure TCustRec3.CFrom1Click(Sender: TObject);
begin
   {$IFDEF SOP}
    if Current_Page = MultiBuyPNo then
      mbdFrame.CopyDiscount(True)
    else
   {$ENDIF}
   {$IFDEF STK}
      With Exlocal.LCust do
        MULCtrlO2[Current_Page].Copy_CDStock(CustCode,CustSupp);
   {$ENDIF}
end;

procedure TCustRec3.CTo1Click(Sender: TObject);
begin
   {$IFDEF SOP}
    if Current_Page = MultiBuyPNo then
      mbdFrame.CopyDiscount(False)
    else
   {$ENDIF}
  {$IFDEF STK}
    With Exlocal.LCust do
      MULCtrlO2[Current_Page].CD_AccUpdate(CustSupp);
  {$ENDIF}
end;


procedure TCustRec3.CDSPanelMouseUp(Sender: TObject; Button: TMouseButton;
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

    {$IFDEF STK}

      If (PanRsized) then
        MULCtrlO2[Current_Page].ResizeAllCols(MULCtrlO2[Current_Page].VisiList.FindxHandle(Sender),BarPos);

      MULCtrlO2[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

      NeedCUpdate:=(MULCtrlO2[Current_Page].VisiList.MovingLab or PanRSized);
    {$ENDIF}
  end;

end;



procedure TCustRec3.CDSLabMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  {$IFDEF STK}

    If (Sender is TSBSPanel) then
    With (Sender as TSBSPanel) do
    Begin

      If (MULCtrlO2[Current_Page]<>nil) then
        MULCtrlO2[Current_Page].VisiList.MoveLabel(X,Y);

      NeedCUpdate:=MULCtrlO2[Current_Page].VisiList.MovingLab;
    end;
  {$ENDIF}
end;


procedure TCustRec3.CDSLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin
    {$IFDEF STK}

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
    {$ENDIF}
  end;
end;



procedure TCustRec3.PrnCP1BtnClick(Sender: TObject);

Var
  PrintMode  :  Byte;
  ListPoint  :  TPoint;
   //PR: 20/05/2014 ABSEXCH-2763
  Ok2Print : Boolean;
begin
  Ok2Print := True;
  {$IFDEF FRM}
    With ExLocal do
    Case Current_Page of

      MainPno..eCommPNo
           :  Begin
                If (Sender is TButton) then
                With TWinControl(Sender) do
                Begin
                  ListPoint.X:=1;
                  ListPoint.Y:=1;

                  ListPoint:=ClientToScreen(ListPoint);
                end
                else
                Begin
                  GetCursorPos(ListPoint);
                  With ListPoint do
                  Begin
                    X:=X-50;
                    Y:=Y-15;
                  end;
                end;

                PrintMode:=Get_CustPrint(Self,ListPoint,1);

                If (PrintMode>0) then
                Begin
                  Control_DefProcess(PrintMode,
                                     InvF,InvCustK,
                                     FullCustType(LCust.CustCode,LCust.CustSupp),
                                     ExLocal,
                                     BOn);
                end;
              end;

      LedgerPNo,OrdersPNo,WOROrdersPNo,JAppsPNo,RetPNo
           :  With MulCtrlO[Current_Page] do
              Begin
                GetSelRec(BOff);
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


    end; {Case..}

  {$ENDIF}
end;

procedure TCustRec3.StatCP1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  With TWinControl(Sender) do
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    ListPoint:=ClientToScreen(ListPoint);

  end;

  PopUpMenu6.PopUp(ListPoint.X,ListPoint.Y);

end;





procedure TCustRec3.Addr1FKeyPress(Sender: TObject; var Key: Char);
begin
  If (Sender is Text8pt) then
  With Text8pt(Sender) do
  Begin
    If (SelStart>=MaxLength) then {* Auto wrap around *}
      SetNextLine(Self,Sender,Addr5F,Parent,Key);
  end;
end;

procedure TCustRec3.DAddr1FKeyPress(Sender: TObject; var Key: Char);
begin
  If (Sender is Text8pt) then
  With Text8pt(Sender) do
  Begin
    If (SelStart>=MaxLength) then {* Auto wrap around *}
      SetNextLine(Self,Sender,DAddr5F,Parent,Key);
  end;

end;


procedure TCustRec3.FrmDefFChange(Sender: TObject);
Var
  TVal  :   Integer;

begin
  If (SetUpOk) then
  Begin
    TVal:=IntStr(FrmDefF.Text);

    If (Sender<>DefUdF) then
      DefUdF.Position:=TVal;

    {$IFDEF Frm}
       FSetNamF.Text:=pfGetMultiFrmDesc(TVal);
    {$ENDIF}
  end;
end;

procedure TCustRec3.DDModeFEnter(Sender: TObject);
begin

  With DDModeF do
  Begin
    ReadOnly:=(RPayF.ItemIndex<>1);
    Enabled:=Not ReadOnly;
  end;
end;

procedure TCustRec3.DefUdFMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FrmDefFChange(Sender);
end;


procedure TCustRec3.DCLocnFExit(Sender: TObject);
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

      If (AltMod) and  (FoundCode<>'') and (OrigValue<>Text) and (Syss.UseMLoc) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetMLoc(Self,FoundCode,FoundCode,'',0));

        If (FoundOk) then
        Begin
          StillEdit:=BOff;

          StopPageChange:=BOff;

          Text:=FoundCode;

          {* Weird bug when calling up a list caused the Enter/Exit methods
               of the next field not to be called. This fix sets the focus to the next field, and then
               sends a false move to previous control message ... *}


          {FieldNextFix(Self.Handle,ActiveControl,Sender);}
        end
        else
        Begin
          ChangePage(DefaultPNo);

          StopPageChange:=BOn;

          SetFocus;
        end; {If not found..}
      end
      //GS: 05/05/11 ABSEXCH-10796 added a clause where if the user exits a 'GL code' field on the Default tab while
      //leaving it blank, the PageChange lock will be turned off; allowing the user to switch tabs
      else if FoundCode = '' then
        StopPageChange := BOff;
    end; {with..}
  {$ENDIF}
end;


procedure TCustRec3.emWebPWrdFEnter(Sender: TObject);
begin
  If (ExLocal.InAddEdit) then
  With emWebPWrdF do
  Begin
    ReadOnly:=(Not emEBF.Checked);
    Enabled:=Not ReadOnly;
  end;
end;

procedure TCustRec3.emEbFClick(Sender: TObject);
begin
  emWebPwrdFEnter(Sender);
end;


procedure TCustRec3.StkCCP1BtnClick(Sender: TObject);
{$IFDEF STK}

Var
   CKAnal  :  CKAnalType;

   TelMode :  Boolean;

   LTeleSF :  TTeleSFrm;

{$ENDIF}

begin
  {$IFDEF STK}
      TelMode:=(Sender=TeleSCP1Btn) or (Sender=TeleSales1);

      If (Not Assigned(TeleSList[TelMode])) then
      With ExLocal do
      Begin
        Blank(CKAnal,Sizeof(CKAnal));
        CKAnal.CCode:=LCust.CustCode;
        CKAnal.DispMode:=1;
        CKAnal.ScanMode:=1;
        CKAnal.ScaleMode:=4;
        CKAnal.IsTeleS:=TelMode;

        CKAnal.IsaC:=IsaCust(LCust.CustSupp);

        Set_TSFormMode(CKAnal);

        LTeleSF:=TTeleSFrm.Create(Self);

        TeleSList[TelMode]:=LTeleSF;
      end
      else
      Begin
        LTeleSF:=TeleSList[TelMode];

        With LTeleSF do
        Begin
          try
            If (WindowState=wsMinimized) then
              WindowState:=wsNormal;

            CKAnal:=ListCSAnal^;


            With Self.ExLocal do
            If (LCust.CustCode<>CKAnal.CCode) then
            Begin


              CKAnal.CCode:=LCust.CustCode;

              CKAnal.IsaC:=IsaCust(LCust.CustSupp);

              ListCSAnal^:=CKAnal;

              SetCaption;

              RefreshList(BOn,BOff);

            end;


          except
            LTeleSF.Free;
            TeleSList[TelMode]:=nil;
          end;
        end;
      end;


  {$ENDIF}

end;

procedure TCustRec3.emZipFClick(Sender: TObject);
begin
  With ExLocal do
  If (InAddEdit) and (SetUpOK) and (Not emSendRF.Checked) then
  Begin
    If  ((emZipF.ItemIndex In [2]) and (Not (LCust.EmlZipAtc In [2]))
      and ((cbSendSta.ItemIndex In [2,4]) or (cbSendInv.ItemIndex In [2,4]))) then
      emSendRF.Checked:=BOn;


  end;

end;



procedure TCustRec3.SCCIS1Click(Sender: TObject);
{$IFDEF JC}
Var
  CRepParam  :  CVATRepParam;

begin
  Blank(CRepParam,Sizeof(CRepParam));

  {$B-}
  Begin
    If (Not InCISVch) then

  {$B+}
    With ExLocal, CRepParam do
    Begin
      InCISVch:=BOn;
      VATStartD:='19800101';
      VATEndD:=MaxUntilDate;
      VSig:=ExLocal.LCust.CustCode;
      CISSMode:=1;

      Show_CISList(Self,CRepParam);

    end;
  end;
{$ELSE}
  Begin
{$ENDIF}
end;


procedure TCustRec3.SC1Click(Sender: TObject);
begin
{$IFDEF JC}
  {$IFDEF JAP}
    {$IFNDEF SOPDLL} // HM 07/12/04: Added for PR / EntDllSP.Dll
      If (Not InSCLedger) then
      Begin
        InSCLedger:=BOn;
        Show_SCEmployee(Cust.CustCode,TMenuItem(Sender).Tag);
        InSCLedger:=BOff;
        SetJapOptions;
      end;
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
end;

procedure TCustRec3.CISCP1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  If (Not RecordMode) then
  Begin
    If (Sender<>CISLedger1) then
    Begin
      With TWinControl(Sender) do
      Begin
        ListPoint.X:=1;
        ListPoint.Y:=1;

        ListPoint:=ClientToScreen(ListPoint);

      end;

      PopUpMenu9.PopUp(ListPoint.X,ListPoint.Y);
    end;
  end;
end;

procedure TCustRec3.CustdbBtn1Click(Sender: TObject);

Var
  PageNo  :  Integer;
  // 23/01/2013 PKR ABSEXCH-13449
  customButtonNumber : integer;
  OKToContinue : Boolean;
begin
  PageNo:=Current_Page;
  customButtonNumber := 0;

  OKToContinue := False;
  if not (PageNo in TRANS_PAGES) then
    OKToContinue := True
  else
  if (Assigned(MULCtrlO[PageNo])) then
    if MULCtrlO[PageNo].ValidLine then
      OKToContinue := True;

  {$IFDEF CU}
  //PR: 22/03/2017 ABSEXCH-18143 v2017 Add Custom buttons for all tabs - only require
  //valid line if we're on a tab with transactions - Ledger, Orders, WOP, Applications, Returns
    If OKToContinue  then
    With ExLocal do
      Begin
        // 23/01/2013 PKR ABSEXCH-13449
        if Sender is TSBSButton then
          customButtonNumber := (Sender as TSBSButton).Tag;
        if Sender is TMenuItem then
          customButtonNumber := (Sender as TMenuItem).Tag;
        
        custBtnHandler.CustomButtonClick(formPurpose,
                                         PageNo,
                                         rsAny,
                                         customButtonNumber,
                                         ExLocal);
    end; {With..}
  {$ENDIF}
end;



procedure TCustRec3.DelDisc1Click(Sender: TObject);
begin
   {$IFDEF SOP}
    if (Sender is TMenuItem) and (Current_Page = MultiBuyPNo) and Assigned(MULCtrlO[Current_Page]) then
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

        1  :  Del_Discount(1,ExLocal.LCust.CustCode,Self);
      end; {Case..}
    end;

    {$ENDIF}
end;


procedure TCustRec3.RetCP1BtnClick(Sender: TObject);
Var
  PageNo  :  Integer;
  RETRef  :  Str10;
  mbRet   :  Word;

begin
  PageNo:=Current_Page;

{$IFDEF RET}
  If (Assigned(MULCtrlO[PageNo])) then
  With MULCtrlO[PageNo],ExLocal do
  Begin
    If (ValidLine) and (Inv.InvDocHed In StkRetGenSplit-[POR]) then
    Begin
      Id.FolioRef:=Inv.FolioNum;
      If (CheckExsiting_RET(Inv,Id,RETRef,BOff)) then
      Begin
        mbRet:=CustomDlg(Application.MainForm,'Please note','Return Exists',
                                'Return '+RETRef+' already exists for this '+DocNames[Inv.InvDocHed]+#13+#13+
                                'Please confirm you want to create another Return for this transaction.',mtConfirmation,[mbOk,mbCancel]);
      end
      else
        mbRet:=mrOk;

      If (mbRet=mrOk) then
        Gen_RetDocWiz(Inv,Id,0,Self);

    end;

  end;
{$ENDIF}
end;

procedure TCustRec3.ShowSortViewDlg;
var
  Dlg: TSortViewOptionsFrm;
  FuncRes: Integer;
begin
  case CustFormMode of
    CUSTOMER_TYPE: MULCtrlO[Current_Page].SortViewType(0);
    CONSUMER_TYPE: MULCtrlO[Current_Page].SortViewType(1);
    SUPPLIER_TYPE: MULCtrlO[Current_Page].SortViewType(2);
  end;
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

procedure TCustRec3.RefreshView1Click(Sender: TObject);
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

procedure TCustRec3.CloseView1Click(Sender: TObject);
var
  LKeyStart :  Str255;
  LKeypath,
  LKeyLen   :  Integer;
begin
  MulCtrlO[Current_Page].SortView.CloseView;
  MulCtrlO[Current_Page].SortView.Enabled := False;
  UseDefaultSortView := False;
  with MulCtrlO[Current_Page] do
  begin
    LKeyPath := InvCustLedgK;
    LKeyStart := FullCustType(ExLocal.LCust.CustCode, ExLocal.LCust.CustSupp)+Chr(Ord(ViewNorm));
    LKeyLen:=Length(LKeyStart)-Ord(Not ViewNorm);
    StartList(InvF,LKeypath,LKeyStart,'','',LKeyLen,False);
  end;
  PageControl1.Pages[Current_Page].ImageIndex := -1;
end;

procedure TCustRec3.SortViewOptions1Click(Sender: TObject);
begin
  ShowSortViewDlg;
end;

procedure TCustRec3.SortCP1BtnClick(Sender: TObject);
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

procedure TCustRec3.Label85Click(Sender: TObject);
begin
  ShowMessage(SBSPanel1.Parent.Name);
end;

//PR: 19/10/2011 Added Handling for switching notes to include Audit notes v6.9
procedure TCustRec3.General1Click(Sender: TObject);
begin
  If (NotesCtrl<>nil) then
    NotesCtrl.SwitchNoteMode(nmGeneral);
end;

procedure TCustRec3.Dated1Click(Sender: TObject);
begin
  If (NotesCtrl<>nil) then
    NotesCtrl.SwitchNoteMode(nmDated);
end;

procedure TCustRec3.AuditHistory1Click(Sender: TObject);
begin
  If (NotesCtrl<>nil) then
    NotesCtrl.SwitchNoteMode(nmAudit);
end;

//Callback function to pick up note switch
procedure TCustRec3.SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
begin
  AddCp1Btn.Enabled := NewMode <> nmAudit;
  EditCp1Btn.Enabled := NewMode <> nmAudit;
  InsCp3Btn.Enabled := NewMode <> nmAudit;
  DelCp1Btn.Enabled := NewMode <> nmAudit;
end;

//PR: 12/02/2013 ABSEXCH-13752 v7.0.2 Add procedure to call hook points 161-164 on allocation/unallocation of transaction
//PR: 27/02/2013 Amended Ids to 171-174 as 161-163 are already in use
{$IFDEF CU}
procedure TCustRec3.TriggerAllocatedHook(UnAllocate : Boolean);
const
  // Array for handler id
  //
  //          Cust Supp
  //Alloc      171  172
  //Unalloc    173  174
  IDs : Array[False..True, False..True] of Integer = ( (171, 172),
                                                       (173, 174) );
var
  HandlerID : Integer;
begin
  //Set appropriate handler id:
  HandlerID := Ids[ UnAllocate, ExLocal.LCust.CustSupp = 'S'];

  //GenHooks takes care of checking whether the hook point is enabled.
  GenHooks(2000, HandlerID, ExLocal);
end;
{$ENDIF}


// MH 05/09/2013 v7.XMRD MRD1.2.17: Added Auto-Receipt Support
procedure TCustRec3.edtOrderPaymentsGLCodeExit(Sender: TObject);
Var
  FoundCode  :  Str20;
  FoundNom   :  LongInt;
  FoundOk,
  AltMod     :  Boolean;
begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundNom:=0;

    FoundCode:=Text;

    If (AltMod) and  (FoundCode<>'') and (OrigValue<>Text) then
    Begin

      StillEdit:=BOn;  // Prevents the edit field recopying the original value on return from a popup window

      // MH: As far as I can tell we need to use different modes if GL Classes are on:-
      //   11 = Bank Accounts if GL Classes are ON, but everything if they are OFF
      //   77 = Balance Sheet Only
      // MH 19/09/2014 ABSEXCH-15652: Suppress Inactive GL Codes
      FoundOk := GetNom (Self, FoundCode, FoundNom, IfThen(Syss.UseGLClass, 11, 77), SUPPRESS_INACTIVE_GLCODES);

      {$IFDEF MC_ON}
      If (FoundOk) then
      Begin
        // Check the currency matches that defined for the account
        // MH 10/09/2014 ABSEXCH-15610: Added check for GL Code beign Consolidated
        FoundOK := (Nom.DefCurr = 0) Or (Nom.DefCurr = (CurrF.ItemIndex + 1));
        If (Not FoundOK) Then
          // MH 12/09/2014 ABSEXCH-15625: Changed to Warning
          MessageDlg('The Currency for the GL Code doesn''t match the Currency for this Account', mtWarning, [mbOk], 0);
      End; // If (FoundOk)
      {$ENDIF}

      If (FoundOk) then
      Begin
        StillEdit:=BOff;

        StopPageChange:=BOff;

        Text:=Form_BInt(FoundNom,0);

        {* Weird bug when calling up a list caused the Enter/Exit methods
             of the next field not to be called. This fix sets the focus to the next field, and then
             sends a false move to previous control message ... *}

        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin
        ChangePage(DefaultPNo);
        //TW 17/08/2011: fix for tab locking.
        StopPageChange := false;
        SetFocus;
      end; {If not found..}
    end
    //GS: 05/05/11 ABSEXCH-10796 added a clause where if the user exits a 'GL code' field on the Default tab while
    //leaving it blank, the PageChange lock will be turned off; allowing the user to switch tabs
    else if FoundCode = '' then
      StopPageChange := BOff;

  end; {with..}
end;

procedure TCustRec3.chkAllowOrderPaymentsClick(Sender: TObject);
begin
  // Auto-Receipts GL Code should only be enabled if the user has permissions and the checkbox is ticked
  // MH 21/07/2014: Updated for Order Payments
  edtOrderPaymentsGLCode.Enabled := chkAllowOrderPayments.Enabled And chkAllowOrderPayments.Checked
end;

//PR: 06/05/2015 ABSEXCH-16284 T2-120 Procedure to load list with PPD Options
procedure  TCustRec3.LoadPPDOptionList;
begin
  cbPPDOptions.Items.Clear;
  cbPPDOptions.Items.Add('Disabled');
  if IsSales then
  begin
    cbPPDOptions.Items.Add('Enabled - Auto SJC');
    cbPPDOptions.Items.Add('Enabled - Auto SCR');
  end
  else
  begin
    cbPPDOptions.Items.Add('Enabled - Auto PJC');
    cbPPDOptions.Items.Add('Enabled - Manual PCR');
  end;

end;

// MH 12/05/2015 v7.0.14 ABSEXCH-16284: Added PPD Ledger
// PR: 21/05/2015 Added handle parameter
procedure TCustRec3.btnPPDLedgerClick(Sender: TObject);
begin
  DisplayPPDLedger(ExLocal.LCust, Handle);
end;

procedure TCustRec3.cbPPDOptionsChange(Sender: TObject);
begin
  //PR: 27/05/2015 ABSEXCH-16444 Disable ppd fields if ppd not enabled for customer.
  cePPDPercent.Enabled := cbPPDOptions.ItemIndex > 0;
  cePPDDays.Enabled := cePPDPercent.Enabled;
end;

//------------------------------------------------------------------------------
procedure TCustRec3.chkECMemberClick(Sender: TObject);
begin
  // PKR. 11/01/2016. ABSEXCH-17098. Intrastat settings.
  // Delivery Terms and Mode of Transport only available if EC Member is checked.
  if (DefaultDeliveryTerms.Visible) then
  begin
    DefaultDeliveryTerms.Enabled := chkECMember.Checked;
    DeliveryTermsLabel.Enabled := DefaultDeliveryTerms.Enabled;
  end;

  if (DefaultModeOfTransport.Visible) then
  begin
    DefaultModeOfTransport.Enabled := chkECMember.Checked;
    ModeOfTransportLabel.Enabled := DefaultModeOfTransport.Enabled;
  end;

  // Default to QR enabled only if EC Member is checked, and for UK companies.
  chkDefaultToQR.Enabled := chkECMember.Checked and (CurrentCountry = UKCCode);
end;

//------------------------------------------------------------------------------
// PKR. 13/01/2016. ABSEXCH-17098. Intrastat. 4.2 Trader Record.
// Validate EC Member flag against the Address Country.
function TCustRec3.ValidateECMemberField : Boolean;
var
  addrCountryIsECMember : Boolean;
  dlgResult      : integer;
  errMsg         : string;
  acCountry      : string;
  userCountry    : string;
  intrastatCountry : string;
  suppMessage    : string;
begin
  Result := true;

  if (Syss.IntraStat) then
  begin
    addrCountryIsECMember := CountryIsECMemberState(lstAddressCountry.Text);

    // PKR. 19/01/2016. ABSEXCH-17155. Don't display warning if the trader country
    //  is the same as the user country, as they are likely to be covered by local
    //  VAT/GST rules rather than Intrastat.

    // PKR. 08/03/2016. ABSEXCH-17361. Prevent exception being raised if no country selected.
    // This can happen if an old database is upgraded.
    If (lstAddressCountry.ItemIndex < 0) Then
    begin
      MessageDlg('The Main Address Country is not valid', mtWarning, [mbOk], 0);
      Result := false;
    end
    else
    begin
      acCountry := ISO3166CountryCodes.ccCountryDetails[lstAddressCountry.ItemIndex].cdCountryCode2;

      // PKR. 28/01/2016. ABSEXCH-17214. Add Intrastat Country Code
      // Modify the message slightly so that if a non-EC Member, which is considered an EC Member
      //  for Intrastat purposes is selected (Eg, Isle of Man, Monaco), it will include the
      //  qualifier "for Intrastat purposes ".
      // This will also happen for Greece, which IS an EC Member, because of its Intrastat Country code.
      intrastatCountry := ISO3166CountryCodes.ccCountryDetails[lstAddressCountry.ItemIndex].cdIntrastatCountry;
      suppMessage := '';
      if intrastatCountry <> acCountry then
        suppMessage := 'for Intrastat purposes ';

      // Get the ISO 2-letter code from the Exchequer code.
      userCountry := DefaultCountryCode(CurrentCountry);

      if (chkECMember.Checked <> addrCountryIsECMember) and
         (userCountry <> acCountry) then
      begin
        // Mis-match between the EC Member checkbox and the Address Country
        Result := false;
        // Ask the user if they want to continue
        errMsg := 'This trader''s Country field is set to ' + lstAddressCountry.Text;
        if chkECMember.Checked then
          errMsg := errMsg + ' which is not an EC Member State, but EC Member is ticked.'
        else
          errMsg := errMsg + ' which ' + suppMessage + #13#10'is an EC Member State, but EC Member is not ticked.';

        errMsg := errMsg + #13#10#13#10'Do you want to continue?';

        // PKR. 201/01/2016. Changed from Yes/No/Cancel to Yes/No
        dlgResult := MessageDlg(errMsg, mtWarning, [mbYes, mbNo], 0);
        if dlgResult = mrYes then
          Result := true;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
function TCustRec3.DeliveryTermsFieldIsValid : Boolean;
var
  errMsg : string;
begin
  Result := true;

  // Only need to validate if EC Member checked
  if (chkECMember.Checked) then
  begin
    if IntrastatSettings.IndexOf(stDeliveryTerms, ifCode, DefaultDeliveryTerms.Text) < 0 then
    begin
      Result := false;

      errMsg := 'Delivery Terms must be set for EC Members';

      if (not DefaultDeliveryTerms.Visible) then
        errMsg := errMsg + #13#10#13#10'To show Delivery Terms, change the settings in the Intrastat Control Centre.';
      MessageDlg(errMsg, mtWarning, [mbOK], 0);

      // If the field is visible, set focus to it
      if (DefaultDeliveryTerms.Visible) and (not DefaultDeliveryTerms.Readonly) then
      begin
        DefaultDeliveryTerms.SetFocus;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
function TCustRec3.ModeOfTransportFieldIsValid : Boolean;
var
  errMsg : string;
begin
  Result := true;

  // Only need to validate if EC Member checked
  if (chkECMember.Checked) then
  begin
    if IntrastatSettings.IndexOf(stModeOfTransport, ifCode, DefaultModeOfTransport.Text) < 0 then
    begin
      Result := false;

      errMsg := 'Mode of Transport must be set for EC Members.';

      if (not DefaultModeOfTransport.Visible) then
        errMsg := errMsg + #13#10#13#10'To show Mode of Transport, change the settings in the Intrastat Control Centre.';
      MessageDlg(errMsg, mtWarning, [mbOK], 0);

      // If the field is visible, set focus to it
      if (DefaultModeOfTransport.Visible) and (not DefaultModeOfTransport.Readonly) then
      begin
        DefaultModeOfTransport.SetFocus;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// PKR. 13/01/2016. ABSEXCH-17098.
// Returns true if the passed-in string contains the 2-letter code for an EC Member state.
// Will also accept and recognise strings with the code contained in parentheses,
// such as 'United Kingdom (GB)'.
function TCustRec3.CountryIsECMemberState(aCountry : string) : Boolean;
var
  parenPos       : integer;
begin
  Result := false;

  if Length(aCountry) < 2 then
  begin
    exit;
  end;

  if Length(aCountry) = 2 then
  begin
    Result := IsECMember(aCountry);
  end
  else
  begin
    // Longer than 2 chars, so see if there is a code in parentheses.
    parenPos := Pos('(', aCountry);
    if parenPos > 0 then
    begin
      // Found parenthesis.  Assume the next 2 characters are a country code and test it.
      Result := IsECMember(Copy(aCountry, parenPos+1, 2));
    end;
  end;
end;

procedure TCustRec3.cbDefaultTaxCodeExit(Sender: TObject);
Var
  OrigVATCode : Char;
begin
  If ExLocal.InAddEdit and (Sender is TSBSComboBox) then
  Begin
    // Record VAT Code here to detect changes
    OrigVATCode := ExLocal.LCust.VATCode;

    // Update LCust from window
    Form2Cust;

    {$IFDEF VAT}
      If (ExLocal.LCust.VATCode = VATICode) and (ExLocal.LCust.VATCode <> OrigVATCode) Then
        With TSBSComboBox(Sender) do
          GetIRate(Parent.ClientToScreen(ClientPos(Left,Top+23)), Color, Font, Self.Parent, ExLocal.LViewOnly, ExLocal.LCust.CVATIncFlg);
    {$ENDIF}
  End; // If ExLocal.InAddEdit and (Sender is TSBSComboBox)
end;

// SSK 22/10/2017 ABSEXCH-19386: set anonymisation mode
procedure TCustRec3.SetAnonymisationON(AValue: Boolean);
begin
  FAnonymisationON := AValue;
  SetAnonymisationBanner;
end;

// SSK 22/10/2017 ABSEXCH-19386: Implements anonymisation behaviour for trader
procedure TCustRec3.SetAnonymisationBanner;
begin
  //HV 06/12/2017 ABSEXCH-19535: Anonymised Trader > The height of the window gets increased if "Save coordinates" is ticked
  if FAnonymisationON then
  begin
    PageP.Y:= 51;
    if (FListScanningOn and pnlAnonymisationStatus.Visible) or (FSettings.UseDefaults and (not FListScanningOn)) then
      InitSize.Y := Self.ClientHeight
    else
      InitSize.Y := Self.ClientHeight + pnlAnonymisationStatus.Height;
  end
  else
  begin
    if (FListScanningOn and pnlAnonymisationStatus.Visible) or (FSettings.UseDefaults and (not FListScanningOn)) then
      InitSize.Y := Self.ClientHeight - pnlAnonymisationStatus.Height
    else
      InitSize.Y := Self.ClientHeight;
    PageP.Y:= ClientHeight - (PageControl1.Height + pnlAnonymisationStatus.Height);
  end;
  if FListScanningOn then
  begin
    PageP.Y:= InitSize.Y - PageControl1.Height;
    FListScanningOn := False;
  end;

  pnlAnonymisationStatus.Visible := FAnonymisationON;
  if pnlAnonymisationStatus.Visible then
  begin
    //change the color of anonymisation controls
    with SystemSetup.GDPR do
    begin
      shpNotifyStatus.Brush.Color := NotificationWarningColour;
      shpNotifyStatus.Pen.Color := shpNotifyStatus.Brush.Color;
      lblAnonStatus.Font.Color := NotificationWarningFontColour;
    end;
    SetAnonymisationStatusDate;
  end;
  Self.ClientHeight := InitSize.Y;
  FormResize(nil);
end;

//HV 12/11/2017 ABSEXCH-19549: Anonymised Notification banner in View/Edit Record > Banner not displayed on maximise and then Restore Down.
procedure TCustRec3.SetAnonymisationPanel;
begin
  if GDPROn and FAnonymisationON then
  begin
    pnlAnonymisationStatus.Left := 0;
    pnlAnonymisationStatus.Top := Self.ClientHeight - (pnlAnonymisationStatus.Height+1);
    pnlAnonymisationStatus.Width := Self.ClientWidth;
    shpNotifyStatus.Width := pnlAnonymisationStatus.Width - 10;
    shpNotifyStatus.Left := 5;
      //center the label
    lblAnonStatus.Left := Round((pnlAnonymisationStatus.Width - lblAnonStatus.width)/2);
  end;
end;

procedure TCustRec3.SetAnonymisationStatusDate;
var
  lAnonymised: Boolean;
begin
  if GDPROn and FAnonymisationON then
  begin
    //update the anonymisation Date
    lAnonymised := ExLocal.LCust.acAnonymisationStatus = asAnonymised;
    StatCP1Btn.Enabled := not lAnonymised;      // disable the status button for
    if lAnonymised then
      lblAnonStatus.Caption := Format(capAnonymisedStatus, [POutDate(ExLocal.LCust.acAnonymisedDate)])
    else
      lblAnonStatus.Caption := Format(capAnonymisedPendingStatus, [POutDate(ExLocal.LCust.acAnonymisedDate)]);
    SetAnonymisationPanel;
  end;
end;

procedure TCustRec3.btnPIITreeClick(Sender: TObject);
var
  lCaption: string;
begin
  //SSK 21/02/2018 2018 R1 ABSEXCH-19778: to correct the caption Display in PII Tree Window
  if (CustFormMode = CONSUMER_TYPE) then
    lCaption := dbFormatName(ExLocal.LCust.AcLongAcCode, GetCompanyDescription)
  else
    lCaption := dbFormatName(ExLocal.LCust.CustCode, GetCompanyDescription);
  TfrmPIITree.CreateWithScanType(Application.MainForm, pstTrader, lCaption, ExLocal);
end;

//-------------------------------------------------------------------------

function TCustRec3.WindowExportEnableExport: Boolean;
begin
  Result := Current_Page In [NotesPNo,
                             DiscPNo,
                             MultiBuyPNo,
                             LedgerPNo,
                             OrdersPNo,
                             WOROrdersPNo,
                             JAPPSPNo,
                             RetPNo];
  If Result Then
  Begin
    WindowExport.AddExportCommand (ecIDCurrentRow, ecdCurrentRow);
    WindowExport.AddExportCommand (ecIDCurrentPage, ecdCurrentPage);
    WindowExport.AddExportCommand (ecIDEntireList, ecdEntireList);
  End; // If Result
end;

//-------------------------------------------------------------------------

// MH 06/03/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
procedure TCustRec3.WindowExportExecuteCommand(const CommandID: Integer; const ProgressHWnd: HWND);
Var
  ListExportIntf : IExportListData;
begin
  // Returns a new instance of an "Export Btrieve List To Excel" object
  ListExportIntf := NewExcelListExport;
  Try
    ListExportIntf.ExportTitle := WindowExportGetExportDescription;

    // Connect to Excel
    If ListExportIntf.StartExport Then
    Begin
      // Get the active Btrieve List to export the data
      If (Current_Page = DiscPNo) Then
        // Discounts tab
        {$IFDEF STK}
        MULCtrlO2[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd)
        {$ENDIF STK}
      Else If (Current_Page = NotesPNo) Then
        // Notes tab
        NotesCtrl.MulCtrlO.ExportList (ListExportIntf, CommandID, ProgressHWnd)
      Else
        // Everything else
        MulCtrlO[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd);

      ListExportIntf.FinishExport;
    End; // If ListExportIntf.StartExport(sTitle)
  Finally
    ListExportIntf := NIL;
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

function TCustRec3.WindowExportGetExportDescription: String;
begin
  Result := TraderTypeNameFromSubType(ExLocal.LCust.acSubType) + ' ';

  Case Current_Page Of
    NotesPNo     : Result := Result + 'Notes';
    DiscPNo      : Result := Result + 'Discounts';
    MultiBuyPNo  : Result := Result + 'Multi-Buys';
    LedgerPNo    : Result := Result + 'Ledger';
    OrdersPNo    : Result := Result + 'Orders';
    WOROrdersPNo : Result := Result + 'Works Oders';
    JAPPSPNo     : Result := Result + 'Applications';
    RetPNo       : Result := Result + 'Returns';
  Else
    Result := Result + '???';
  End; // Case Current_Page

  Result := Result + ' - ' + Trim(ExLocal.LCust.CustCode);
end;

//-------------------------------------------------------------------------

Initialization
  TemporaryCustFormMode:=0;

end.



