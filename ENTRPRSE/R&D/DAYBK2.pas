unit Daybk2;

interface

{$I DEFOVR.Inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ComCtrls, ExtCtrls, SBSPanel, Math, cxGridDBDataDefinitions,
  GlobVar,VarConst,SBSComp,SBSComp2,ExWrap1U,BTSupU1,ColCtrlU,
  CmpCtrlU,SupListU, Menus, EntWindowSettings,IndeterminateProgressF,

  {$IFDEF Inv}

    SaleTx2U,
    RecepU,

    NomTfr2U,

    BatchEnU,

    {$IFDEF STK}

      StkAdjU,

      {$IFDEF WOP}
        WORDoc2U,

      {$ENDIF}

      {$IFDEF RET}
        RETDoc1U,

      {$ENDIF}


    {$ENDIF}

    {$IFDEF JC}
      JobTS1U,
    {$ENDIF}

  {$ENDIF}

  ConvDocU,

  ExtGetU,

  {$IFDEF CU}
  // 23/01/2013 PKR ABSEXCH-13449
  CustomBtnHandler,
  {$ENDIF}

  DocSupU1, TCustom,

  { CJS - 2013-08-20 - ABSEXCH-14558 - Daybook SortViews }
  VarSortV,
  SortViewU,
  SortDaybook,
  ImgModU,

  // MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  WindowExport, ExportListIntf, oExcelExport,

  // CJS 2013-11-28 - MRD1.1.23 - Filter by Customer/Consumer
  ConsumerUtils,

  //Rahul002
  dmMainDaybk2, BaseFrame, GridFrame
  ;


type
  {=== Daybook List ===}

  TDayBkMList  =  Class(TDDMList)
  private
    { CJS - 2013-08-20 - ABSEXCH-14558 - Daybook SortViews }
    UseDefaultSortView: Boolean;
    function GetSortView: TBaseSortView;
    procedure SetSortView(const Value: TBaseSortView);
  Public
    DocExtRecPtr       :  ExtDocRecPtr;

    DocExtObjPtr       :  GetExtDocHist;

    DayBkDocHed        :  DocTypes;

    OKLen,
    DayBkListMode      :  Byte;

    OrigKey            :  Str255;

    GotCustomMode      :  Byte;


    // CA  08/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location). New filter field required
    FilteredLocation   :  Str255;

    { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
    FilteredOriginator: Str255;

    // CJS 2013-10-02 - MRD1.1.23 - Sales Daybook - Customer/Consumer filter
    // SubType ('C' or 'U') to filter by
    FilteredTrader: Char;

    // Cache of Customer/Consumer codes and Subtypes
    TraderCache: TTraderCache;

    Procedure ExtObjCreate; Override;

    Procedure ExtObjDestroy; Override;

    Function ExtFilter  :  Boolean; Override;

    Function GetExtList(B_End      :  Integer;
                    Var KeyS       :  Str255)  :  Integer; Override;

    Function SetCheckKey  :  Str255; Override;

    Function GetOrdFilter(InvR  :  InvRec)  :  Str255;

    Procedure SetNewLIndex;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function FindxOurRef(KeyChk  :  Str255)  :  Boolean;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Function ShowUDF  :  Boolean;

    Procedure LocateRecord(RecMainKey  :  Str255;KeyPath : Integer);

    { CJS - 2013-08-20 - ABSEXCH-14558 - Daybook SortViews }
    // MH 29/06/2015 Exch2015-R1 ABSEXCH-15991: Set Sort View Window Caption
    procedure CreateSortView(ForListType: TSortViewListType; Const ListDesc : String);
    property SortView: TBaseSortView read GetSortView write SetSortView;
  end;



  TDaybk1 = class(TForm)
    DPageCtrl1: TPageControl;
    MainPage: TTabSheet;
    QuotesPage: TTabSheet;
    db1SBox: TScrollBox;
    db1HedPanel: TSBSPanel;
    db1ORefLab: TSBSPanel;
    db1DateLab: TSBSPanel;
    db1AccLab: TSBSPanel;
    db1AMtLab: TSBSPanel;
    db1StatLab: TSBSPanel;
    db1PrLab: TSBSPanel;
    AutoPage: TTabSheet;
    OrdersPage: TTabSheet;
    db1OrefPanel: TSBSPanel;
    db1DatePanel: TSBSPanel;
    db1PrPanel: TSBSPanel;
    db1AccPanel: TSBSPanel;
    db1AmtPanel: TSBSPanel;
    db1StatPanel: TSBSPanel;
    db2SBox: TScrollBox;
    db2DatePanel: TSBSPanel;
    db2ORefPanel: TSBSPanel;
    db2PrPanel: TSBSPanel;
    db2AccPanel: TSBSPanel;
    db2AmtPanel: TSBSPanel;
    db2StatPanel: TSBSPanel;
    db2HedPanel: TSBSPanel;
    db2OrefLab: TSBSPanel;
    db2DateLab: TSBSPanel;
    db2AccLab: TSBSPanel;
    db2AmtLab: TSBSPanel;
    db2StatLab: TSBSPanel;
    db2PrLab: TSBSPanel;
    db3SBox: TScrollBox;
    db3DatePanel: TSBSPanel;
    db3ORefPanel: TSBSPanel;
    db3PrPanel: TSBSPanel;
    db3AccPanel: TSBSPanel;
    db3AmtPanel: TSBSPanel;
    db3StatPanel: TSBSPanel;
    db3HedPanel: TSBSPanel;
    db3ORefLab: TSBSPanel;
    db3DateLab: TSBSPanel;
    db3AccLab: TSBSPanel;
    db3AmtLab: TSBSPanel;
    db3StatLab: TSBSPanel;
    db3PrLab: TSBSPanel;
    db5SBox: TScrollBox;
    db4DatePanel: TSBSPanel;
    db4ORefPanel: TSBSPanel;
    db4PrPanel: TSBSPanel;
    db4AccPanel: TSBSPanel;
    db4AmtPanel: TSBSPanel;
    db4StatPanel: TSBSPanel;
    db4HedPanel: TSBSPanel;
    db4ORefLab: TSBSPanel;
    db4DateLab: TSBSPanel;
    db4AccLab: TSBSPanel;
    db4AmtLab: TSBSPanel;
    db4StatLab: TSBSPanel;
    db4PrLab: TSBSPanel;
    HistoryPage: TTabSheet;
    OrdHistoryPage: TTabSheet;
    db4SBox: TScrollBox;
    db5DatePanel: TSBSPanel;
    db5ORefPanel: TSBSPanel;
    db5PrPanel: TSBSPanel;
    db5AccPanel: TSBSPanel;
    db5AmtPanel: TSBSPanel;
    db5StatPanel: TSBSPanel;
    db5HedPanel: TSBSPanel;
    db5ORefLab: TSBSPanel;
    db5DateLab: TSBSPanel;
    db5AccLab: TSBSPanel;
    db5AmtLab: TSBSPanel;
    db5StatLab: TSBSPanel;
    db5PrLab: TSBSPanel;
    db6SBox: TScrollBox;
    db6DatePanel: TSBSPanel;
    db6ORefPanel: TSBSPanel;
    db6PrPanel: TSBSPanel;
    db6AccPanel: TSBSPanel;
    db6AmtPanel: TSBSPanel;
    db6StatPanel: TSBSPanel;
    db6HedPanel: TSBSPanel;
    db6ORefLab: TSBSPanel;
    db6DateLab: TSBSPanel;
    db6AccLab: TSBSPanel;
    db6AmtLab: TSBSPanel;
    db6StatLab: TSBSPanel;
    db6PrLab: TSBSPanel;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Find1: TMenuItem;
    Notes1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    Hold1: TMenuItem;
    Copy1: TMenuItem;
    Convert1: TMenuItem;
    Post1: TMenuItem;
    Print1: TMenuItem;
    Remove1: TMenuItem;
    Match1: TMenuItem;
    Pick1: TMenuItem;
    db1DescPanel: TSBSPanel;
    db1DescLab: TSBSPanel;
    db3DescPanel: TSBSPanel;
    db3DescLab: TSBSPanel;
    db5DescPanel: TSBSPanel;
    db5DescLab: TSBSPanel;
    db2DescPanel: TSBSPanel;
    db2DescLab: TSBSPanel;
    db4DescPanel: TSBSPanel;
    db4DescLab: TSBSPanel;
    db6DescPanel: TSBSPanel;
    db6DescLab: TSBSPanel;
    db1ListBtnPanel: TSBSPanel;
    db2ListBtnPanel: TSBSPanel;
    db3ListBtnPanel: TSBSPanel;
    db5ListBtnPanel: TSBSPanel;
    db4ListBtnPanel: TSBSPanel;
    db6ListBtnPanel: TSBSPanel;
    Tag1: TMenuItem;
    Receive1: TMenuItem;
    db1BtnPanel: TSBSPanel;
    db1BSBox: TScrollBox;
    Adddb1Btn: TButton;
    Editdb1Btn: TButton;
    Finddb1Btn: TButton;
    Printdb1Btn: TButton;
    Holddb1Btn: TButton;
    Convdb1Btn: TButton;
    CopyDb1Btn: TButton;
    Notedb1Btn: TButton;
    Postdb1Btn: TButton;
    Pickdb1Btn: TButton;
    Recdb1Btn: TButton;
    Matdb1Btn: TButton;
    Remdb1Btn: TButton;
    Tagdb1Btn: TButton;
    Clsdb1Btn: TButton;
    Viewdb1Btn: TButton;
    View1: TMenuItem;
    PopupMenu2: TPopupMenu;
    Copy2: TMenuItem;
    Reverse1: TMenuItem;
    Back1: TMenuItem;
    N4: TMenuItem;
    PopupMenu3: TPopupMenu;
    HQ1: TMenuItem;
    HU1: TMenuItem;
    MenuItem3: TMenuItem;
    HC1: TMenuItem;
    HA1: TMenuItem;
    N5: TMenuItem;
    HSP1: TMenuItem;
    HR1: TMenuItem;
    PopupMenu4: TPopupMenu;
    QuoI1: TMenuItem;
    QuoO1: TMenuItem;
    PopupMenu5: TPopupMenu;
    GLPP1: TMenuItem;
    DPP1: TMenuItem;
    DO1: TMenuItem;
    DPO1: TMenuItem;
    DRO1: TMenuItem;
    ITD1: TMenuItem;
    IAD1: TMenuItem;
    IGD1: TMenuItem;
    SDT1: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    PD1: TMenuItem;
    RDR1: TMenuItem;
    RIR1: TMenuItem;
    PopupMenu6: TPopupMenu;
    PrintDoc1: TMenuItem;
    GenPick1: TMenuItem;
    HQS1: TMenuItem;
    HQS2: TMenuItem;
    db1YRefPanel: TSBSPanel;
    db1YRefLab: TSBSPanel;
    db2YRefPanel: TSBSPanel;
    db2YRefLab: TSBSPanel;
    db3YRefPanel: TSBSPanel;
    db3YRefLab: TSBSPanel;
    db5YRefPanel: TSBSPanel;
    db5YRefLab: TSBSPanel;
    db4YRefPanel: TSBSPanel;
    db4YRefLab: TSBSPanel;
    db6YRefLab: TSBSPanel;
    db6YRefPanel: TSBSPanel;
    HCR1: TMenuItem;
    PopupMenu7: TPopupMenu;
    Tag2: TMenuItem;
    Untag1: TMenuItem;
    PopupFindBtn: TPopupMenu;
    Orders1: TMenuItem;
    Deliveries1: TMenuItem;
    Tagged1: TMenuItem;
    NotTagged1: TMenuItem;
    OnPickingRun1: TMenuItem;
    NotOnPickingRun1: TMenuItem;
    WaitStock1: TMenuItem;
    NotWaitStock1: TMenuItem;
    WaitforallStock1: TMenuItem;
    NotWaitforallStock1: TMenuItem;
    CreditHold1: TMenuItem;
    NotCreditHold1: TMenuItem;
    Query1: TMenuItem;
    NotQuery1: TMenuItem;
    AccountCode1: TMenuItem;
    NoFilter1: TMenuItem;
    TransactionRef1: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    EntCustom1: TCustomisation;
    CustdbBtn1: TSBSButton;
    CustdbBtn2: TSBSButton;
    Custom1: TMenuItem;
    Custom2: TMenuItem;
    ITWO1: TMenuItem;
    IAWO1: TMenuItem;
    BTWO1: TMenuItem;
    BAWO1: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    RPWI1: TMenuItem;
    RPWB1: TMenuItem;
    DRO2: TMenuItem;
    ITRT1: TMenuItem;
    IART1: TMenuItem;
    BTRT1: TMenuItem;
    BART1: TMenuItem;
    RPRet1: TMenuItem;
    Returndb1Btn: TButton;
    Returns1: TMenuItem;
    CustdbBtn3: TSBSButton;
    CustdbBtn4: TSBSButton;
    CustdbBtn5: TSBSButton;
    CustdbBtn6: TSBSButton;
    Custom3: TMenuItem;
    Custom4: TMenuItem;
    Custom5: TMenuItem;
    Custom6: TMenuItem;
    Filterdb1Btn: TButton;
    Filter1: TMenuItem;
    SortViewBtn: TButton;
    SortViewPopupMenu: TPopupMenu;
    RefreshView2: TMenuItem;
    CloseView2: TMenuItem;
    MenuItem1: TMenuItem;
    SortViewOptions2: TMenuItem;
    SortView1: TMenuItem;
    RefreshView1: TMenuItem;
    CloseView1: TMenuItem;
    N14: TMenuItem;
    SortViewOptions1: TMenuItem;
    PopupMenu9: TPopupMenu;
    FList1: TMenuItem;
    ClearFilterItem1: TMenuItem;
    FilterSeparator1: TMenuItem;
    FilterbyTransactionOriginator1: TMenuItem;
    ClearTransactionOriginator1: TMenuItem;
    FilterSeparator2: TMenuItem;
    FilterbyCustomer1: TMenuItem;
    FilterbyConsumer1: TMenuItem;
    ClearCustomerConsumerFilter1: TMenuItem;
    db4OrdPayPanel: TSBSPanel;
    db4OrdPayLab: TSBSPanel;
    db1OwnerPanel: TSBSPanel;
    db1OwnerLab: TSBSPanel;
    db2OwnerPanel: TSBSPanel;
    db2OwnerLab: TSBSPanel;
    db3OwnerPanel: TSBSPanel;
    db3OwnerLab: TSBSPanel;
    db5OwnerPanel: TSBSPanel;
    db5OwnerLab: TSBSPanel;
    db4OwnerPanel: TSBSPanel;
    db4OwnerLab: TSBSPanel;
    db6OwnerPanel: TSBSPanel;
    db6OwnerLab: TSBSPanel;
    N15: TMenuItem;
    PostTransactionWithReport: TMenuItem;
    PostTransactionOnly: TMenuItem;
    mnuFindOptions: TMenuItem;
    mnuTransactionRef1: TMenuItem;
    mnuN8: TMenuItem;
    mnuOrders1: TMenuItem;
    mnuDeliveries1: TMenuItem;
    mnuTagged1: TMenuItem;
    mnuNotTagged1: TMenuItem;
    mnuOnPickingRun1: TMenuItem;
    mnuNotOnPickingRun1: TMenuItem;
    mnuWaitStock1: TMenuItem;
    mnuNotWaitStock1: TMenuItem;
    mnuWaitforallStock1: TMenuItem;
    mnuNotWaitforallStock1: TMenuItem;
    mnuN9: TMenuItem;
    mnuCreditHold1: TMenuItem;
    mnuNotCreditHold1: TMenuItem;
    mnuQuery1: TMenuItem;
    mnuNotQuery1: TMenuItem;
    mnuN10: TMenuItem;
    mnuAccountCode1: TMenuItem;
    mnuN11: TMenuItem;
    mnuNoFilter1: TMenuItem;
    WindowExport: TWindowExport;
    pnlGridBackground: TPanel;
    frDaybkGrid: TfrDataGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure DPageCtrl1Change(Sender: TObject);
    procedure Clsdb1BtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure db1OrefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure db1ORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure db1ORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure DPageCtrl1Changing(Sender: TObject;
                               var AllowChange: Boolean);
    procedure FormDeactivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Pickdb1BtnClick(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure CopyDb1BtnClick(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure Tagdb1BtnClick(Sender: TObject);
    procedure Holddb1BtnClick(Sender: TObject);
    procedure HQ1Click(Sender: TObject);
    procedure Matdb1BtnClick(Sender: TObject);
    procedure Postdb1BtnClick(Sender: TObject);
    procedure Printdb1BtnClick(Sender: TObject);
    procedure Convdb1BtnClick(Sender: TObject);
    procedure Convert1Click(Sender: TObject);
    procedure QuoI1Click(Sender: TObject);
    procedure Remdb1BtnClick(Sender: TObject);
    procedure SDT1Click(Sender: TObject);
    procedure PD1Click(Sender: TObject);
    procedure GLPP1Click(Sender: TObject);
    procedure Finddb1BtnClick(Sender: TObject);
    procedure PrintDoc1Click(Sender: TObject);
    procedure GenPick1Click(Sender: TObject);
    procedure DO1Click(Sender: TObject);
    procedure Tag2Click(Sender: TObject);
    procedure Untag1Click(Sender: TObject);
    procedure Orders1Click(Sender: TObject);
    procedure CustdbBtn1Click(Sender: TObject);
    procedure ITWO1Click(Sender: TObject);
    procedure IAWO1Click(Sender: TObject);
    procedure ITRT1Click(Sender: TObject);
    procedure BART1Click(Sender: TObject);
    procedure RPRet1Click(Sender: TObject);
    procedure Returndb1BtnClick(Sender: TObject);
    procedure Adddb1BtnClick(Sender: TObject);
    procedure Filterdb1BtnClick(Sender: TObject);
    procedure FList1Click(Sender: TObject);
    procedure ClearFilterItem1Click(Sender: TObject);
    procedure SortViewBtnClick(Sender: TObject);
    procedure RefreshView2Click(Sender: TObject);
    procedure CloseView2Click(Sender: TObject);
    procedure SortViewOptions2Click(Sender: TObject);
    procedure FilterbyTransactionOriginator1Click(Sender: TObject);
    procedure ClearTransactionOriginator1Click(Sender: TObject);
    procedure FilterbyCustomer1Click(Sender: TObject);
    procedure FilterbyConsumer1Click(Sender: TObject);
    procedure ClearCustomerConsumerFilter1Click(Sender: TObject);
	//PL 09/02/2017 2017-R1 ABSEXCH-13159 :  added ability to post Single Transaction on Daybook posting 
    procedure PopupMenu5Popup(Sender: TObject);
    procedure PostTransactionWithReportClick(Sender: TObject);
    procedure PostTransactionOnlyClick(Sender: TObject);
    function WindowExportEnableExport: Boolean;
    procedure WindowExportExecuteCommand(const CommandID: Integer; Const ProgressHWnd : HWnd);
    function WindowExportGetExportDescription: String;
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }

    //Rahul002
    FdmMain: TMainDataModule;

    UpDateFromPost,
    ListActive,
    KeepLive,
    fNeedCUpdate,
    fFrmClosing,
    fDoingClose,
    fDisableFormClose,
    StoreCoord,
    LastCoord,
    SetDefault,
    InBuildPostMenu,
    UseAddInv,
    GotCoord   :  Boolean;

    // CA  10/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location). Main Caption
    MainCaption : String;

    LastBTag  :  Array[0..5] of LongInt;

    // CA  13/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location) : FilterMCount added
    FilterMCount,
    HoldMCount,
    PostMCount :  LongInt;

    PagePoint  :  Array[0..4] of TPoint;

    StartSize,
    InitSize   :  TPoint;

    LastDocHed,
    PSOPDocHed,
    DocHed     :  DocTypes;

    PrintInvImage
               :  InvRec;

    CustBtnList:  Array[0..5] of TVisiBtns;

    FormBitMap :  TBitMap;

    {$IFDEF Inv}

      TransForm  :  Array[0..5] of TSalesTBody;

      RecepForm  :  TRecepForm;
      NTxfrForm  :  TNTxfrForm;
      BatchForm  :  TBatchEntry;



      {$IFDEF STK}

        SAdjForm :  TStkAdj;

        {$IFDEF WOP}
          WORForm :  TWOR;

        {$ENDIF}


        {$IFDEF RET}
          RETForm :  TRetDoc;

        {$ENDIF}

      {$ENDIF}

      {$IFDEF JC}
        TShtForm :  TTSheetForm;
      {$ENDIF}


    {$ENDIF}

    MatchFormPtr :  Pointer;

    DayBkTotPtr  :  Pointer;

    TransActive  :  Array[0..9] of Boolean;

    SysMenuH     :  HWnd;

    FColorsChanged : Boolean;

    //PR: 05/11/2010
    FSettings :IWindowSettings;

    {$IFDEF CU}
    // 25/01/2013  PKR   ABSEXCH-13449/38
    FormPurpose : TFormPurpose;
    RecordState : TRecordState;
    {$ENDIF}
    
    procedure Find_Page1Coord(PageNo  :  Integer);

    procedure Store_Page1Coord(UpMode  :  Boolean);

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Function ChkPWord(PageNo :  Integer;
                      HelpS,
                      HelpP,
                      HelpN,
                      HelpA,
                      HelpSO,
                      HelpPO,
                      HelpWO,
                      HelpSR,
                      HelpPR
                        :  LongInt) :  LongInt;

    Function SetHelpC(PageNo :  Integer;
                      Pages  :  TIntSet;
                      Help0,
                      Help1  :  LongInt) :  LongInt;

    procedure PrimeButtons(PageNo  :  Integer;
                           PWRef   :  Boolean);

    procedure SetTabs2;

    // CA  10/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location) : Setting the Caption
    procedure SetMainCaption;

    // CA  13/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location)
    procedure BuildFilterMenu(NewPage  :  Integer);

    procedure BuildHoldMenu(NewPage  :  Integer);

    procedure BuildPostMenu(NewPage  :  Integer);

    procedure BuildMenus;

    Procedure Send_ParentMsg(Mode   :  Integer);

    procedure HidePanels(PageNo  :  Byte);

    procedure Page1Create(Sender   : TObject;
                          NewPage  : Byte);

    procedure PrintDoc(Sender: TObject; LP  :  LongInt);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure SetFormProperties;

    Function CheckListFinished  :  Boolean;

    // MH 05/07/2016 2016-R2 ABSEXCH-17638: B2B POR's not printing
    //PR: 15/11/2017 2018-R2 ABSEXCH-19451 Allow edit of posted transactions
    procedure Display_Inv(      Mode            : Byte;
                                CPage           : Integer;
                          Const BackToBackTrans : Boolean = False;
                          const AllowPostedEdit : Boolean = False);

    procedure Display_Recep(Mode  :  Byte;
                            CPage :  Integer;
                            const AllowPostedEdit : Boolean = False);

    procedure Display_NTxfr(Mode  :  Byte;
                            CPage :  Integer;
                            const AllowPostedEdit : Boolean = False);

    procedure Display_SAdj(Mode  :  Byte;
                           CPage :  Integer);

    procedure Display_WOR(Mode  :  Byte;
                          CPage :  Integer;
                     const AllowPostedEdit : Boolean = False);

    procedure Display_RET(Mode  :  Byte;
                          CPage :  Integer;
                     const AllowPostedEdit : Boolean = False);

    procedure Display_TSht(Mode  :  Byte;
                           CPage :  Integer;
                     const AllowPostedEdit : Boolean = False);

    procedure Display_Batch(Mode  :  Byte;
                            CPage :  Integer);

    // MH 05/07/2016 2016-R2 ABSEXCH-17638: B2B POR's not printing
    //PR: 15/11/2017 2018-R2 ABSEXCH-19451 Allow edit of posted transactions
    procedure Display_Trans(Mode : Byte; Const BackToBackTrans : Boolean = False;
                            const AllowPostedEdit : Boolean = False);

    Procedure WMDayBkGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure UpdatePostStatus(PageNo  :  Integer);

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMSetFocus(Var Message  :  TMessage); Message WM_SetFocus;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;



    {$IFDEF DBD}
      Procedure DebugProc;
    {$ENDIF}

    function GetSupplier(Var SCode  :  String;
                         Var CCMode :  Integer)  :  Boolean;


    procedure Display_Match(ChangeFocus,
                            MatchMode     :  Boolean);

    procedure Display_DTotals;


    Function GetTagNo(Var TNo  :  Byte;
                          Mode :  Byte)  :  Boolean;

    procedure TagTrans(Sender: TObject);

    Function FindAccCode(Var  KeyS  :  Str255)  :  Boolean;

    procedure SendObjectCC;

    procedure Conv_Quote(ConvMode  :  Byte);

    {$IFDEF GF}
      procedure FindDbItem(Sender: TObject);
    {$ENDIF}

    procedure DeleteDoc;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Procedure Add_WOR;

    Procedure RecepWiz;

    procedure AddButtonExecute(Sender: TObject; bDoNomWizard : boolean);

    { CJS - 2013-08-20 - ABSEXCH-14558 - Daybook SortViews }
    procedure ShowSortViewDlg;
    procedure ApplySortView;
    procedure RefreshList;
	//PL 09/02/2017 2017-R1 ABSEXCH-13159 :  added ability to post Single Transaction on Daybook posting 
    function SingleDaybkVisible()  :  Boolean;
    function ValidTrans() : Boolean;
    function UserPerCheck() : Boolean;
    procedure UpdateSubMenuItemCaption(Const Source  :  TPopUpMenu;
                                         RefCount:  LongInt;
                                   Var   Dest    :  TMenuItem;
                                         Extended: Boolean = False);
    procedure SingleDaybookPost(WithReport : Boolean);

    procedure OnSetDetail(Sender: TObject);
  public
    { Public declarations }

    ExLocal    :  TdExLocal;

    LastHRunNo :  LongInt;

    {$IFDEF SOP}

      LastHCommP
               :  Boolean;

    {$ENDIF}

    ListOfSet  :  Integer;

    MULCtrlO   :  Array[0..5] of TDayBkMList;
    MULAddr    :  Array[0..5] of LongInt;


    Function Current_Page  :  Integer;

    Procedure SetPageHelp(NewIndex  :  Integer);

    Procedure ChangePage(NewPage  :  Integer);

    procedure HistModeScan(NewRunNo    :  LongInt;
                           DCPMode     :  Boolean);

    // MH 08/10/2014 ABSEXCH-15698: Added method to allow the Payment and Refund dialogs
    //                              for Order Payments to refresh the daybooks
    Procedure UpdateForOrderPaymentsTransactions (Const OurRef : String);


  end;


Procedure Set_DayBkFormMode(State       :  DocTypes;
                            StagePage   :  Byte);

Procedure Set_DayBkHistMode(DRunNo      :  LongInt;
                            DCPMode     :  Boolean);

{$IFDEF SOP}
Procedure OrdPay_UpdateDaybooks (Const OurRef : String);
{$ENDIF}

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  BTSupU3,
  PrintFrm,
  RPDefine,
  SQL_DaybookPosting,
  BtKeys1U,
  ETMiscU,
  ComnUnit,
  ComnU2,
  PWarnU,
  CurrncyU,
  SysU1,
  SalTxl1U,

  {$IFDEF GF}
    FindCtlU,
  {$ENDIF}

  {$IFDEF INV}
    STxMenu,
    MiscU,
  {$ENDIF}

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  SysU2,

  {$IFDEF SOP}


    PickInpU,
    DelvInpU,

  {$ENDIF}

  {$IFDEF Frm}
    DefProcU,
  {$ENDIF}

  {$IFDEF STK}

     SOPCT1U,
     InvCTSuU,

     {$IFDEF SOP}
       InvFSu2U,

       {*EN431MB2B*}
       SOPB2BWU,


     {$ENDIF}

     {$IFDEF RET}
       RETInpU,

     {$ENDIF}

   {$ENDIF}


  {$IFDEF C_On}
     NoteSupU,

  {$ENDIF}

  {$IFDEF SY}
    AUWarnU,
  {$ENDIF}


  {$IFDEF POST}
    PostingU,
    PostInpU,
  {$ENDIF}

  {$IFDEF Rp}
    Report2U,
    Report3U,

  {$ENDIF}

  InvListU,
  MatchU,

  {$IFDEF CU}
    CustIntU,
    CustWinU,
    Event1U,
  {$ENDIF}

  {$IFDEF WOP}
    WOPInpU,
    WORInpU,
    WORIWizU,
  {$ENDIF}

  {$IFDEF RET}
    RetWiz1U,
    RetSup1U,
    GenWarnU,
  {$ENDIF}

  {$IFDEF LTR}
    Letters,
  {$ENDIF}

  {$IFDEF ADDNOMWIZARD}
    AddNomWizard,
  {$ENDIF}

  {$IFDEF SOP}
    // MH 12/11/2014 Order Payments: Added confirmation checks for Order Payment Transactions being Reversed
    PasswordAuthorisationF,
    // MH 25/06/2015 Exch-R1 ABSEXCH-16459: Added Order Payments Payment Status column
    OrderPaymentFuncs,
    // MH 06/08/2015 2015-R1 ABSEXCH-16664: Added Order Payments Tracker window
    OrderPaymentsTrackerF,
  {$ENDIF SOP}

  AllcWizU,
  LedgSupU,
  TagInpU,
  ExThrd2U,
  {$IFDEF EXSQL}
  SQLUtils,
  SQLRep_GLPrePosting,
  SQLRep_Config,
  {$ENDIF}
  DayBks2U,
  AuditNotes,
  { CJS - 2013-08-20 - ABSEXCH-14558 - Daybook SortViews }
  SortViewOptionsF,
  { CJS - 2013-10-28 - MRD2.6 - Transaction Originator }
  TransactionOriginatorDlg,
  UA_Const,    //  RJ 17/02/2016 2016-R1 ABSEXCH-17035: Check user Permission  before print actions.

  oProcessLock, cxGridDBTableView, cxGridCustomTableView
  ;






{$R *.DFM}


Const
  DbOrdersPage  =  4;

  NoOfLists = 6;
  ListNames : Array[0..NoOfLists-1] of String[7] = ('Main', 'Quotes', 'Auto', 'History', 'Orders', 'OrdHist');
  cPostConfirmation = 'Are you sure you want to post %s ?'; //PL 09/02/2017 2017-R1 ABSEXCH-13159 :  added ability to post Single Transaction on Daybook posting
Var
  {$IFDEF SOP}
    DayBkHistCommP :  Boolean;
  {$ENDIF}

  DayBkFormMode  :  DocTypes;
  DayBkFormPage  :  Byte;
  DayBkHistRunNo :  LongInt;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_DayBkFormMode(State       :  DocTypes;
                            StagePage   :  Byte);
Begin
  If (State<>DayBkFormMode) then
    DayBkFormMode:=State;

  If (StagePage<>DayBkFormPage) then
    DayBkFormPage:=StagePage;

  DayBkHistRunNo:=0;
end;


{* This to be called from G/L Run recon *}
Procedure Set_DayBkHistMode(DRunNo      :  LongInt;
                            DCPMode     :  Boolean);


Begin
  DayBkFormMode:=ADJ;

  DayBkFormPage:=3; {* History }

  DayBkHistRunNo:=DRunNo;

  {$IFDEF SOP}
    DayBkHistCommP:=DCPMode;

  {$ENDIF}
end;


{ ============== TDayBkMList Methods =============== }



{ ======= Extended search routines ========= }


procedure TDayBkMList.ExtObjCreate;

Begin
  Inherited;

  DocExtRecPtr:=nil;
  DocExtObjPtr:=nil;

  GotCustomMode:=0;

  If (DayBkListMode=3) then
  Begin
    New(DocExtRecPtr);

    FillChar(DocExtRecPtr^,Sizeof(DocExtRecPtr^),0);

    New(DocExtObjPtr,Init);

    ExtRecPtr:=DocExtRecPtr;
    ExtObjPtr:=DocExtObjPtr;
  end;

  // CJS 2013-10-02 - MRD1.1.23 - Sales Daybook - Customer/Consumer filter
  if Syss.ssConsumersEnabled then
    TraderCache := TTraderCache.Create(True);
end;

procedure TDayBkMList.ExtObjDestroy;

Begin
  If (DocExtRecPtr<>nil) then
    Dispose(DocExtRecPtr);

  If (DocExtObjPtr<>nil) then
    Dispose(DocExtObjPtr,Done);

  // CJS 2013-10-02 - MRD1.1.23 - Sales Daybook - Customer/Consumer filter
  if (TraderCache <> nil) then
    FreeAndNil(TraderCache);

  Inherited;
end;


Function TDayBkMList.ExtFilter  :  Boolean;

Begin
  With Inv do
    Result:=(((RunNo>0) or ((InvDocHed=ADJ) and (RunNo=StkAdjRunNo)) or ((InvDocHed=WOR) and (RunNo=WORPPRunNo)) {$IFDEF RET} or ((InvDocHed In StkRetSplit) and (RunNo=Set_RETRunNo(InvDocHed,BOff,BOn))) {$ENDIF} )
             and (OurRef[1]=DocExtRecPtr^.FDocType[1]));
end;

Function  TDayBkMList.GetExtList(B_End      :  Integer;
                             Var KeyS       :  Str255)  :  Integer;

Var
  TmpStat   :  Integer;


Begin

  TmpStat:=0;

  Begin

    With DocExtRecPtr^ do
    Begin

      If (B_End In [B_GetPrev,B_GetNext]) and (DocExtObjPtr<>nil) then
      Begin

        DispExtMsg(BOn);

        TmpStat:=DocExtObjPtr^.GetSearchRec2(B_End+30,InvF,KeyPath,KeyS,FDocType[1]);

        DispExtMsg(BOff);

      end
      else

        TmpStat:=Find_Rec(B_End,F[InvF],InvF,RecPtr[InvF]^,KeyPath,KeyS);

    end;{With..}

  end; {With..}

  Result:=TmpStat;

end; {Func..}



Function TDayBkMList.SetCheckKey  :  Str255;


Var
  DumStr    :  Str255;

  TmpRunNo,
  TmpFolio  :  LongInt;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);
  //Fix for ABSEXCH-17503
  TmpRunNo := Maxint;


  With Inv do
  Begin

    Case Keypath of

      InvOurRefK
               :  If (UseSet4End) and (CalcEndKey) then  {* If A special end key calculation is needed *}
                  Begin
                    DumStr:=DocCodes[InvDocHed]+NDXWeight;
                  end
                  else
                    DumStr:=OurRef;

      InvRNoK  :  Begin
                    If (UseSet4End) and (CalcEndKey) then  {* If A special end key calculation is needed *}
                    Begin
                      TmpFolio:=LastAddrD;

                      If (DayBkListMode=3) then
                      Begin
                        If (DayBkDocHed In NomSplit) then
                          TmpRunNo:=MaxInt
                        else
                          If (DayBkDocHed In StkAdjSplit) then
                            TmpRunNo:=StkAdjRunNo
                          else
                            If (DayBkDocHed In WOPSplit{$IFDEF RET}  + StkRetSplit {$ENDIF}) then
                              TmpRunNo:=RunNo;

                      end
                      else
                        TmpRunNo:=RunNo;
                    end
                    else
                    Begin
                      TmpFolio:=FolioNum;
                      TmpRunNo:=RunNo;
                    end;

                    DumStr:=FullDayBkKey(TmpRunNo,TmpFolio,DocCodes[DayBkDocHed]);
                  end;
    end; {Case..}

  end;

  SetCheckKey:=DumStr;
end;

  Function TDayBkMList.GetOrdFilter(InvR  :  InvRec)  :  Str255;


  Begin
      Case DisplayMode of
         1  :   Begin
                  Result:=Chr(Ord(Inv.NomAuto)+1);
                end;
         else   Result:=InvR.OurRef;
      end; {case..}

    With InvR do
    Case FilterMode of
           {Orders}
      1  : If (Not (InvDocHed In OrderSet)) then
             Result:=NdxWeight;

           {Delivery notes}
      2  : If (Not (InvDocHed In DeliverSet)) then
             Result:=NdxWeight;

           {Tagged}
      3  : If (Tagged=0) then
             Result:=NdxWeight;

           {Not Tagged}
      4  : If (Tagged<>0) then
             Result:=NdxWeight;

           {Picked}
      5  : If (Not OnPickRun) then
             Result:=NdxWeight;

            {Not Picked}
      6  : If (OnPickRun) then
             Result:=NdxWeight;

            {WaitStk }
      7  : If (HoldFlg AND HoldS<>HoldS) then
             Result:=NdxWeight;

            {Not WaitStk }
      8  : If (HoldFlg AND HoldS =HoldS) then
             Result:=NdxWeight;

            {Wait All Stk }
      9  : If (HoldFlg AND HoldO<>HoldO) then
             Result:=NdxWeight;

            {Not Wait All Stk }
     10  : If (HoldFlg AND HoldO =HoldO) then
             Result:=NdxWeight;
           {Credit Hold}
     11  : If (HoldFlg AND HoldC<>HoldC) then
             Result:=NdxWeight;

            {Not Credit Hold}
     12  : If (HoldFlg AND HoldC =HoldC) then
             Result:=NdxWeight;

           {Query}
     13  : If (HoldFlg AND HoldQ<>HoldQ) or (HoldFlg AND HoldO=HoldO) then
             Result:=NdxWeight;

            {Not Query}
     14  : If (HoldFlg AND HoldQ=HoldQ) then
             Result:=NdxWeight;


     15  : If (CustCode<>KeyFind) and (KeyFind<>'') then
             Result:=NdxWeight;

     16  :  Begin
              KeyFind:='';
              FilterMode:=0;
            end;
    end;
  end;


  { === Proc to set Stock Ledger Key === }

Procedure TDayBkMList.SetNewLIndex;

Var
  LTKey       :  Str255;
  CSMode      :  Boolean;
  ReDMode     :  Byte;
  KeyStart,
  OKeyFind    :  Str255;
  LKeyLen,
  LKeyPath    :  Integer;



Begin
  ReDMode:=0;
  LKeyPath:=KeyPath;
  KeyStart:=KeyRef;
  LKeyLen:=OKLen;
  OKeyFind:=KeyFind;

  Begin
    If (Not (FilterMode In [2])) then
    Begin
      If (LKeyPath<>InvRNoK) and (DisplayMode<>1) then
      Begin
        KeyStart:=OrigKey;
        LKeyPath:=InvRNoK;
        LKeyLen:=OKLen;
        ReDMode:=0;
      end
      else
        ReDMode:=4;

    end
    else
    Begin
      CSMode:=DayBkDocHed in SalesSplit;


      If (CSMode) then
        LTKey:=DocCodes[SDN]
      else
        LTKey:=DocCodes[PDN];


      KeyStart:=LTKey;

      LKeyPath:=InvOurRefK;

      ReDMode:=0;

      LKeyLen:=Length(KeyStart);
    end;

    StartList(InvF,LKeypath,KeyStart,'','',LKeyLen,BOff);

    KeyFind:=OKeyFind;

    If (FilterMode=15) then
      InitPage;

  end; {With..}
end;



(*Function TDayBkMList.SetFilter  :  Str255;

Begin

  Case DisplayMode of
     1  :   Begin
              If (FilterMode=15) then
                SetFilter:=GetOrdFilter(Inv)
              else
                SetFilter:=Chr(Ord(Inv.NomAuto)+1);
            end;
     {$IFNDEF SOP}
       else   SetFilter:=Inv.OurRef;
     {$ELSE}
       else   SetFilter:=GetOrdFilter(Inv);

     {$ENDIF}
  end; {Case..}

end;
*)

Function TDayBkMList.SetFilter  :  Str255;
Begin
  Result := '';

  // CA  08/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location). To cater for new filter
  if (FilteredLocation <> '') then
    if (Inv.thOverrideLocation <> FilteredLocation) then
      Result := NdxWeight;

  // CJS - 2013-10-25 - MRD2.6 - Transaction Originator
  if (FilteredOriginator <> '') then
    if (Trim(Inv.thOriginator) <> FilteredOriginator) then
      Result := NdxWeight;

  // CJS 2013-10-02 - MRD1.1.23 - Sales Daybook - Customer/Consumer filter
  if (FilteredTrader <> #0) and (TraderCache <> nil) then
    if (FilteredTrader <> TraderCache.GetSubType(Inv.CustCode)) then
      Result := NdxWeight;

  if (Result = '') then
  begin
    Case DisplayMode of
       1  :   Begin
                If (FilterMode=15) then
                  SetFilter:=GetOrdFilter(Inv)
                else
                  SetFilter:=Chr(Ord(Inv.NomAuto)+1);
              end;
       {$IFNDEF SOP}
         else   SetFilter:=Inv.OurRef;
       {$ELSE}
         else   SetFilter:=GetOrdFilter(Inv);

       {$ENDIF}
    end; {Case..}
  end;

end;


Function TDayBkMList.FindxOurRef(KeyChk  :  Str255)  :  Boolean;

Const
  OFnum     =  InvF;
  OKeypath  =  InvOurRefK;

Var
  OKeyS  :  Str255;

Begin

  OKeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[OFnum],OFnum,RecPtr[OFnum]^,OKeyPath,OKeyS);

  If (Status=0) and (CheckKey(KeyChk,OKeyS,Length(KeyChk),BOff)) and (LineOk(SetCheckKey)) then
  Begin
    Result:=BOn;
    Status:=GetPos(F[OFnum],OFnum,PageKeys^[0]);

    MUListBoxes[0].Row:=0;
    PageUpDn(0,BOn);
  end
  else
    Result:=BOff;

end;


Function TDayBkMList.Ok2Del :  Boolean;

Begin
  With Inv do
    Result:=((InvDocHed In QuotesSet) or (Not NomAuto) and (Not (InvDocHed In BatchSet)));
end;

{ == To check for presence of custom == }

Function TDayBkMList.ShowUDF  :  Boolean;

Var
  n  :  Byte;

  {$IFDEF Cu}

    CustomEvent  :  TCustomEvent;

  {$ENDIF}


Begin
  Result:=BOff;

  If (GotCustomMode=0) then
  Begin
    {$IFDEF Cu}
       CustomEvent:=TCustomEvent.Create(EnterpriseBase+2000,183);

      Result:=BOn;

       Try
         If (CustomEvent.GotEvent) then
           GotCustomMode:=2
         else
           GotCustomMode:=1;

       Finally
         CustomEvent.Free;

       end;
    {$ENDIF}
  end;
end;

{ ========== Generic Function to Return Formatted Display for List ======= }


Function TDayBkMList.OutLine(Col  :  Byte)  :  Str255;

Const
  GenPcnt0Mask   =  ' #0%;-#0%';

Var
  FoundCode  :  Str10;
  FoundOk,
  OrdView,
  AutoOn     :  Boolean;
  TCr        :  Byte;
  Dnum       :  Double;
  GenStr     :  Str255;

  RetStr     :  TStrings;

  //------------------------------

  Function CalcStatusCol : String;
  Begin // CalcStatusCol
    With Inv Do
    Begin
      Result:=Disp_HoldPStat(HoldFlg,Tagged,PrintedDoc,BOff,(OnPickRun and (Not AutoOn)));

      {$IFDEF RET}
        If (InvDocHed In StkRetSplit) and (TransMode>0) then
        Begin
          If (Result<>'') then
            Result:=Result+'/';

          RetStr:=TStringList.Create;

          Try
            Set_DefaultRetStat(RetStr,(InvDocHed In StkRetSalesSplit),BOff);

            If (TransMode<RetStr.Count) then
              Result:=Result+RetStr.Strings[TransMode];
          finally
            RetStr.Free;
          end;{Try..}
        end;
      {$ENDIF}
    End; // With Inv
  End; // CalcStatusCol

  //------------------------------

  Function CalcYourRefCol : String;
  Begin // CalcYourRefCol
    With Inv Do
    Begin
       If (GotCustomMode<>2) or (Not OrdView) then
       Begin
         If (InvDocHed In StkRetSplit) then
           Result:=dbFormatName(TransDesc,YourRef)
         else
           Result:=YourRef;
       end
       else
         Result:=DocUser1;
    End; // With Inv
  End; // CalcYourRefCol

  //------------------------------
  
  // PKR. 17/11/2015. ABSEXCH-16318. Add Transaction Ownder (User name) column.
  Function CalcOwnerCol : String;
  begin
    with Inv do
    begin
      Result := OpName;
    end;
  end; // CalcOwnerCol

  //------------------------------

Begin

  OrdView:=(DayBkListMode=4);
  AutoOn:=(DayBkListMode=2);

  If (OrdView) then {Check if we need to show ud1 instead of yourref}
    ShowUDF;

   With Inv do
     Case Col of

       0  :  Begin
               Result:=Pr_OurRef(Inv);

               If (DayBkListMode In [0,3]) then
                 Result:=' '+Result;
             end;
       1  :  If (Not AutoOn) then
               OutLine:=PoutDate(TransDate)
             else
               OutLine:=Pr_AutoDue(Inv);

       2  :  If (Not OrdView) or (Not SWBentlyOn) then
             Begin
               If (Not AutoOn) then
                 OutLine:=PPR_OutPr(AcPr,AcYr)
               else
                 OutLine:=Pr_Interval(AutoIncBy,AutoInc);
             end
             else
               Result:=DocUser2;

       3  :  begin
               // CJS 2013-11-28 - MRD1.1 - Amendments for Consumers
               if (InvDocHed in SalesSplit) and (Syss.ssConsumersEnabled) then
                Outline := TraderCache.GetCode(CustCode)
               else
                 OutLine := CustCode;
             end;

       4  :  OutLine:=TransDesc;

       5  :  Begin

               TCr:=0;

               {$IFDEF MC_On}

                 TCr:=Currency;

               {$ENDIF}

               If (OrdView) then
                 Dnum:=TotOrdOS
               else
                 If (DaybkDocHed In WOPSplit) then
                 Begin
                   If (PChkAllowed_In(143)) then
                   Begin
                     Case DayBkListMode of
                       3  :  Dnum:=TotalCost;

                       else  Dnum:=WORTotal(Inv);
                     end; {Case..}
                   end
                   else
                     Dnum:=0.0;

                   If (DayBkListMode=0) then
                   Begin
                     GenStr:=FormatFloat(GenPcnt0Mask,(DivWChk(TotalInvoiced,TotalCost)*100));
                   end;

                 end
                 else
                  If (DaybkDocHed In StkRetSplit) and (DayBkListMode=0) then
                  Begin
                    If (PChkAllowed_In(143)) then
                    Begin
                      Dnum:=Itotal(Inv)-InvVAT-DocLSplit[6];
                    end
                    else
                      Dnum:=0.0;

                    If (DayBkListMode=0) then
                    Begin
                      GenStr:=FormatFloat(GenPcnt0Mask,(Round(DivWChk(Round_Up(DocLSplit[3]+DocLSplit[4],2),Round_Up(DocLSplit[1],2))*100)));
                    end;

                  end
                  else
                   Dnum:=Itotal(Inv);

               If (InvDocHed In CreditSet+RecieptSet) then
                 Dnum:=Dnum*DocNotCnst;

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,TCr);

               If (DaybkDocHed In WOPSplit+ StkRetSplit ) and (DayBkListMode=0) then
               Begin
                 Result:=GenStr+' / '+Result;
               end;

             end;

       // MH 25/06/2015 Exch-R1 ABSEXCH-16459: Added Order Payments Payment Status column - this means
       // the Sales Orders tab now has different columns to the other tabs, so move column calculations
       // out to local subroutines
       6  :  Begin
               If OrdView Then
                 {$IFDEF SOP}
                   Result := CalcOrderPaymentStatus (Inv.thOrderPaymentElement, Inv.thOrderPaymentFlags)
                 {$ELSE}
                   Result := ''  // Shouldn't ever hit this code at runtime
                 {$ENDIF SOP}
               Else
                 Result := CalcStatusCol;
             end;

       7  :  Begin
               If OrdView Then
                 // Sales or Purchase Order Daybook
                 Result := CalcStatusCol
               Else
                 Result := CalcYourRefCol;
             end;

       8  :  Begin
               If OrdView Then
                 // Sales or Purchase Order Daybook
                 Result := CalcYourRefCol
               Else
                 Result := CalcOwnerCol;
             end;

             // PKR. 17/11/2015. ABSEXCH-16318.  Add Transaction Owner (User Name) column
       9  :  Begin
               If OrdView Then
                 // Sales or Purchase Order Daybook
                 Result := CalcOwnerCol
               Else
                 Result := '';
             end;

       else
             OutLine:='';
     end; {Case..}
end;

function TDayBkMList.GetSortView: TBaseSortView;
begin
  Result := FSortView;
end;

procedure TDayBkMList.SetSortView(const Value: TBaseSortView);
begin
  inherited SetSortView(Value);
end;



{ =================================================================================== }


{ =================================================================================== }




Function TDayBk1.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(DPageCtrl1);

end;



procedure TDayBk1.Find_Page1Coord(PageNo  :  Integer);
Begin
  //PR: 05/11/2010 Changed to use new Window Position System
  if Assigned(FSettings) and Assigned(MULCtrlO[PageNo]) and not FSettings.UseDefaults then
    FSettings.SettingsToParent(MULCtrlO[PageNo]);
end;


procedure TDayBk1.Store_Page1Coord(UpMode  :  Boolean);
Begin
end;


Procedure  TDayBk1.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TDayBk1.Find_FormCoord;
Begin
  //PR: 05/11/2010 Changed to use new Window Position System

  //Put this here to get original offsets of controls
  FormSetOfSet;

  //Read in window and first list settings.
  if Assigned(FSettings) and not FSettings.UseDefaults then
  begin
    FSettings.SettingsToWindow(Self);
    FSettings.SettingsToParent(MULCtrlO[0]);
  end;

  StartSize.X:=Width; StartSize.Y:=Height;

  //Needed by FormResize method
  GotCoord := True;
end;


procedure TDayBk1.Store_FormCoord(UpMode  :  Boolean);
Begin
end;



procedure TDayBk1.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(DPageCtrl1.Width);
  PagePoint[0].Y:=ClientHeight-(DPageCtrl1.Height);

  PagePoint[1].X:=DPageCtrl1.Width-(pnlGridBackground.Width);
  PagePoint[1].Y:=DPageCtrl1.Height-(pnlGridBackground.Height);

  PagePoint[2].X:=DPageCtrl1.Width-(db1BtnPanel.Left);
  PagePoint[2].Y:=DPageCtrl1.Height-(db1BtnPanel.Height);

  PagePoint[3].X:=db1BtnPanel.Height-(db1BSBox.Height);
  PagePoint[3].Y:=pnlGridBackground.ClientHeight-(db1ORefPanel.Height);

  PagePoint[4].X:=DPageCtrl1.Width-(db1ListBtnPanel.Left);
  PagePoint[4].Y:=DPageCtrl1.Height-(db1ListBtnPanel.Height); 

//  GotCoord:=BOn;

end;




Function TDayBk1.ChkPWord(PageNo :  Integer;
                          HelpS,
                          HelpP,
                          HelpN,
                          HelpA,
                          HelpSO,
                          HelpPO,
                          HelpWO,
                          HelpSR,
                          HelpPR
                                :  LongInt) :  LongInt;


Begin
  Result:=-255;

  Case PageNo of
    4,5
       :  Case PSOPDocHed of
            SOR  :  Result:=HelpSO;
            POR  :  Result:=HelpPO;
          end; {case..}

    else  Begin
            Case DocHed of
              SIN  :  Result:=HelpS;
              PIN  :  Result:=HelpP;
              NMT  :  Result:=HelpN;
              ADJ  :  Result:=HelpA;
              WOR  :  Result:=HelpWO;

              SRN  :  Result:=HelpSR;
              PRN  :  Result:=HelpPR;
            end;

          end;
  end;

end;


Function TDayBk1.SetHelpC(PageNo :  Integer;
                          Pages  :  TIntSet;
                          Help0,
                          Help1  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    If (PageNo In [4,5]) then
      Result:=Help1
    else
      Result:=Help0;
  end
  else
    Result:=-1;

end;


procedure TDayBk1.PrimeButtons(PageNo  :  Integer;
                               PWRef   :  Boolean);

Const
  // NF: 09/05/06
  TAB_MAIN = 0;
  TAB_QUOTES = 1;
  TAB_AUTO = 2;
  TAB_HISTORY = 3;
  TAB_ORDERS = 4;
  TAB_ORDERHISTORY = 5;
Var
  LastPage    :  TTabSheet;
  TheCaption  :  ShortString;
  {$IFDEF CU}
  // 25/01/2013 PKR ABSEXCH-13449
  cBtnIsEnabled : Boolean;
  TextID        : integer;
  {$ENDIF}
Begin

  TheCaption:='';

  If (PWRef) and (Assigned(CustBtnList[PageNo])) then
  Begin
    LockWindowUpDate(Handle);

    LastPage:=DPageCtrl1.ActivePage;

    SetTabs2;

    If (DPageCtrl1.ActivePage<>LastPage) then
      DPageCtrl1.ActivePage:=LastPage;

    CustBtnList[PageNo].ResetButtons;
    CustBtnList[PageNo].Free;
    CustBtnList[PageNo]:=nil;

  end;


  If (CustBtnList[PageNo]=nil) then
  Begin
    CustBtnList[PageNo]:=TVisiBtns.Create;

    try

      With CustBtnList[PageNo] do
        Begin
    {00}  PWAddVisiRec(Adddb1Btn,(PageNo In [3,5]) or ((PageNo=0) and (ICEDFM=2) and (DocHed<>NMT)),ChkPWord(PageNo,02,11,25,117,145,165,375,577,531));
          //PR: 14/11/2017 ABSEXCH-19451 Editing Posted Transactions - Edit button always visible
    {01}  PWAddVisiRec(Editdb1Btn,False,ChkPWord(PageNo,03,12,26,118,156,166,376,578,532));
    {02}  PWAddVisiRec(Finddb1Btn,BOff,ChkPWord(PageNo,05,14,-255,-255,158,168,378,580,534));
    {03}  PWAddVisiRec(Holddb1Btn,(PageNo In [1,3,5]),ChkPWord(PageNo,06,15,28,121,159,169,379,521,535));
    {04}  PWAddVisiRec(Copydb1Btn,BOff,ChkPWord(PageNo,101,102,140,123,163,173,380,522,536));

    {05}  If ((Not ChkAllowed_In(283) and Not ChkAllowed_In(07)) and (DocHed In SalesSplit)) or
             ((Not ChkAllowed_In(284) and Not ChkAllowed_In(16)) and (DocHed In PurchSplit)) then
            PWAddVisiRec(Convdb1Btn,(Not (PageNo In [1])),-254)
          else
            PWAddVisiRec(Convdb1Btn,(Not (PageNo In [1])),-255);



          {v4.31.005 - Normal daybooks forced there, and sub menu checked for access}

    {06}  {PWAddVisiRec(Postdb1Btn,(PageNo In [1,3,5]),ChkPWord(PageNo,08,17,29,122,161,171));}

    {06} PWAddVisiRec(Postdb1Btn,(PageNo In [1,3,5]),ChkPWord(PageNo,-255,-255,-255,122,161,171,-255,540,544));

    { CJS - 2013-08-21 - ABSEXCH-14558 - Daybook SortViews }
    { CJS - 2013-08-30 - ABSEXCH-14585 - Sort Views appearing on invalid
      daybooks - added check for Daybook type (DocHed) }
    AddVisiRec(SortViewBtn, (PageNo in [2, 3, 5]) or not (DocHed in [SIN, PIN]));

    {07}  AddVisiRec(Notedb1Btn,BOff);
    {08}  PWAddVisiRec(Printdb1Btn,BOff,ChkPWord(PageNo,04,13,103,119,157,167,377,579,533));
    {09}  PWAddVisiRec(Pickdb1Btn,(Not (PageNo In [4])) or (DocHed In PurchSplit),160);
    {10}  PWAddVisiRec(Recdb1Btn,(Not (PageNo In [4])) or (DocHed In SalesSplit),170);
    {11}  AddVisiRec(Matdb1Btn,(Not (PageNo In [4,5])) and ((Not (PageNo In [0,3])) or (Not (DocHed In [NMT,{$IFNDEF LTE} ADJ, {$ENDIF}WOR]))));
    {12}  PWAddVisiRec(Remdb1Btn,(Not (PageNo In [1,2])),ChkPWord(PageNo,09,18,-255*Ord(PageNo=2),00,00,00,-255,-255,-255));
    {13}  PWAddVisiRec(Tagdb1Btn,(Not (PageNo In [4])) and ((Not (PageNo In [1])) or Not SWBentlyOn) and ((PageNo<>0) or (Not (DocHed In [WOR]+StkRetSplit)) ),ChkPWord(PageNo,162,00,00,00,162,172,-255,-255,-255));
    {14}  AddVisiRec(Viewdb1Btn,BOff);

    {15}  PWAddVisiRec(Returndb1Btn,(Not (PageNo In [0,3,4])) or (Not (DocHed In StkRetGenSplit-[POR])) or (Not RetMOn),ChkPWord(PageNo,505,506,00,00,507,508,-254,527,-254));

    // CA  10/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location)
    // Will re-number all the comments as a new filter button has been added and have removed remarked out code.
    // {16}  AddVisiRec(Filterdb1Btn,(Not (PageNo In [0,1,4])) or (DocHed In [NMT, SIN, ADJ, WOR]) or (Not (Syss.EnableOverrideLocations)));

    // CJS 2013-10-28 - MRD2.6 - amendments for Transaction Originator
    if (DocHed = SIN) then
    {16}  // AddVisiRec(Filterdb1Btn, Not (PageNo In [4,5]))
    {16}  AddVisiRec(Filterdb1Btn, not (Syss.ssConsumersEnabled or (PageNo in [4, 5])))
    else
    {16}  AddVisiRec(Filterdb1Btn,(Not (PageNo In [0,1,4,5])) or (DocHed In [NMT, ADJ, WOR]));

    {$IFDEF CU}
          // 25/01/2013 PKR ABSEXCH-13449
          // 6 custom buttons available.
          // Use the custom button handler to manipulate them.

          if (DocHed in SalesSplit) then
            formPurpose := fpSalesDaybook
          else if (DocHed in PurchSplit) then
            formPurpose := fpPurchaseDaybook
          else if (DocHed in NOMSplit) then
            formPurpose := fpNominalDaybook
          // PKR. 04/11/2015. ABSEXCH-16348. Add Custom Buttons to Works Order Daybook
          else if (DocHed in WOPSplit) then
            formPurpose := fpWorksOrderDaybook
          else
            formPurpose := fpInvalid;

          recordState := rsAny;

          if formPurpose <> fpInvalid then
          begin
            cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn1.Tag);
      {17}  AddVisiRec(CustdbBtn1, not cBtnIsEnabled);

            cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn2.Tag);
      {18}  AddVisiRec(CustdbBtn2, not cBtnIsEnabled);

            cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn3.Tag);
      {19}  AddVisiRec(CustdbBtn3, not cBtnIsEnabled);

            cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn4.Tag);
      {20}  AddVisiRec(CustdbBtn4, not cBtnIsEnabled);

            cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn5.Tag);
      {21}  AddVisiRec(CustdbBtn5, not cBtnIsEnabled);

            cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn6.Tag);
      {22}  AddVisiRec(CustdbBtn6, not cBtnIsEnabled);
          end
          else
          begin
            // Disable custom buttons
      {17}  AddVisiRec(CustdbBtn1, BOn);
      {18}  AddVisiRec(CustdbBtn2, BOn);
      {19}  AddVisiRec(CustdbBtn3, BOn);
      {20}  AddVisiRec(CustdbBtn4, BOn);
      {21}  AddVisiRec(CustdbBtn5, BOn);
      {22}  AddVisiRec(CustdbBtn6, BOn);
          end;

    {$ELSE}
      // CU NOT defined
      {17}  AddVisiRec(CustdbBtn1,BOn);
      {18}  AddVisiRec(CustdbBtn2,BOn);
            // 17/01/2013 PKR ABSEXCH-13449
      {19}  AddVisiRec(CustdbBtn3,BOn);
      {20}  AddVisiRec(CustdbBtn4,BOn);
      {21}  AddVisiRec(CustdbBtn5,BOn);
      {22}  AddVisiRec(CustdbBtn6,BOn);
    {$ENDIF}
          HideButtons;
        end; {With..}

    except

      CustBtnList[PageNo].Free;
      CustBtnList[PageNo]:=nil;
    end; {Try..}



    If (PWRef) then
      LockWindowUpDate(0);

  end {If needs creating }
  else
  Begin

    CustBtnList[PageNo].RefreshButtons;
  end;

  If (Assigned(CustBtnList[PageNo])) then
    CustBtnList[PageNo].SetBtnHelp(6,SetHelpC(PageNo,[0..5],29,375));

  If (PageNo=4) or (DocHed In WOPSplit+StkAdjSplit+StkRetSplit) then
    Postdb1Btn.Caption:='&Daybk Process'
  else
    Postdb1Btn.Caption:='&Daybook Post';

  Post1.Caption:=Postdb1Btn.Caption;


  // SSK 28/10/2017 ABSEXCH-19398: Implements anonymisation behaviour for Transaction
  CopyDb1Btn.Enabled := not (GDPROn and (trim(Inv.OurRef) <> '') and Inv.thAnonymised);
  Convdb1Btn.Enabled := CopyDb1Btn.Enabled;

  {$IFDEF CU} {Set customised buttons caption}
    if (CustDbBtn1.visible) then
    begin
      TheCaption:='';
      TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn1.tag);
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn1.Font);
      CustdbBtn1.Caption := TheCaption;
    end;

    if (CustDbBtn2.visible) then
    begin
      TheCaption:='';
      TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn2.tag);
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn2.Font);
      CustdbBtn2.Caption := TheCaption;
    end;

    if (CustDbBtn3.visible) then
    begin
      TheCaption:='';
      TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn3.tag);
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn3.Font);
      CustdbBtn3.Caption := TheCaption;
    end;

    if (CustDbBtn4.visible) then
    begin
      TheCaption:='';
      TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn4.tag);
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn4.Font);
      CustdbBtn4.Caption := TheCaption;
    end;

    if (CustDbBtn5.visible) then
    begin
      TheCaption:='';
      TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn5.tag);
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn5.Font);
      CustdbBtn5.Caption := TheCaption;
    end;

    if (CustDbBtn6.visible) then
    begin
      TheCaption:='';
      TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn6.tag);
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn6.Font);
      CustdbBtn6.Caption := TheCaption;
    end;

  {$ENDIF}

  // NF: 22/06/06 - Help Context ID fixes
  case PageNo of
    TAB_MAIN : begin
    end;
    TAB_QUOTES : begin
    end;
    TAB_AUTO : begin
      Postdb1Btn.HelpContext := 1901;
    end;
    TAB_HISTORY : begin
    end;
    TAB_ORDERS : begin
    end;
    TAB_ORDERHISTORY : begin
    end;
  end;{case}
end;

// CA  13/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location) : FilterMCount added
procedure TDayBk1.BuildFilterMenu(NewPage  :  Integer);
Begin
  if ((Syss.EnableOverrideLocations) and (DocHed In PurchSplit) and
       (MainPage.Visible) or (QuotesPage.Visible) or (OrdersPage.Visible)) Then
  Begin
    if MULCtrlO[Current_Page].FilteredLocation = '' Then
       ClearFilterItem1.Visible := False
    else
       ClearFilterItem1.Visible := True;
  end;

  { CJS - 2013-10-28 - MRD2.6 - Transaction Originator }
  if MULCtrlO[Current_Page].FilteredOriginator = '' then
    ClearTransactionOriginator1.Visible := False
  else
    ClearTransactionOriginator1.Visible := True;

  UpdateSubMenu(PopUpMenu9,FilterMCount,Filter1);
End;

procedure TDayBk1.BuildHoldMenu(NewPage  :  Integer);
Begin

  HQS1.Visible:=((NewPage=4) or (DocHed=WOR));
  HQS2.Visible:=((NewPage=4) or (DocHed=WOR));
  HCR1.Visible:=(NewPage=4);
  HU1.Visible:=(DocHed<>WOR);

  {* Control status of authorisation *}  
  HA1.Visible:=ChkAllowed_In(ChkPWord(NewPage,342,343,-255,-254,344,345,-255,-254,-254));
  HSP1.Visible:=ChkAllowed_In(ChkPWord(NewPage,-255,-255,27,120,-255,-255,-255,-254,-254));
  HR1.Visible:=HSP1.Visible;

  UpdateSubMenu(PopUpMenu3,HoldMCount,Hold1);
end;

procedure TDayBk1.BuildMenus;

Begin
  CreateSubMenu(PopUpMenu2,Copy1);
  CreateSubMenu(PopUpMenu3,Hold1);

  // CA  13/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location). Added Sub Menu
  FilterMCount:=Pred(PopUpMenu9.Items.Count);
  CreateSubMenu(PopUpMenu9,Filter1);
  BuildFilterMenu(Current_Page);

  //GS: 09/05/11 ABSEXCH-10801: modified the 'Find menu count' code to use the Delphi API
  //instead of using Windows API calls (GetMenuItemCount) on Hold / Post / FindMCount
  HoldMCount:=Pred(PopUpMenu3.Items.Count);
  
  {CreateSubMenu(PopUpMenu5,Post1);}

  PostMCount:=Pred(PopUpMenu5.Items.Count);


  BuildPostMenu(Current_Page);

  BuildHoldMenu(Current_Page);

  {$IFDEF STK}
    Untag1.Visible:=(PChkAllowed_In(ChkPWord(Current_Page,425,426,00,00,425,426,-255,-255,-255)));

   // PS - 01-12-2015 - ABSEXCH-14466 - Able to untag all orders despite password option.
   //                   FIX : Corrected call to CreateSubMenu Function
    CreateSubMenuSuffix(PopUpMenu7,Tag1,'X',BOn);
    {$IFDEF SOP}


      CreateSubMenu(PopUpMenu4,Convert1);

    {$ENDIF}
  {$ENDIF}

  // CA  13/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location). Added Sub Menu
  Filter1.Visible := ((Syss.EnableOverrideLocations) and (DocHed In PurchSplit) and
                     (MainPage.Visible) or (QuotesPage.Visible) or (OrdersPage.Visible));

  QuoI1.Visible:=(ChkAllowed_In(07) and (DocHed In SalesSplit)) or
                         (ChkAllowed_In(16) and (DocHed In PurchSplit));

  QuoO1.Visible:=(ChkAllowed_In(283) and (DocHed In SalesSplit)) or
                         (ChkAllowed_In(284) and (DocHed In PurchSplit));

  {$IFDEF SOP}
    UpdateSubMenu(PopUpMenu4,1,Convert1);
  {$ENDIF}

  {$IFDEF WOP}
    If (DocHed In WOPSplit) and (MainPage.Visible) then
    Begin
      QuotesPage.Caption:='Issue Notes';

      CreateSubMenu(PopUpMenu6,Print1);
    end;


  {$ENDIF}


  {$IFDEF RET}
    If (DocHed In StkRetSplit) and (MainPage.Visible) then
    Begin
      QuotesPage.Caption:='Return Notes';

      If (DocHed In StkRetPurchSplit) then
      Begin
        BTRT1.Caption:='&Send this Return';
        BART1.Caption:='Send all Returns';


      end;

    end;
  {$ENDIF}

end;



procedure TDaybk1.SetTabs2;

Begin
  QuotesPage.TabVisible:=(Not (DocHed In NomSplit+StkAdjSplit+WOPSplit{$IFDEF RET}+StkRetSplit{$ENDIF} ));

  {$IFDEF SOP}

    {If (DocHed In SalesSplit) then
      PSOPDocHed:=SOR
    else
      PSOPDocHed:=POR;}

    OrdersPage.TabVisible:=BoChkAllowed_In((Not (DocHed In NomSplit+StkAdjSplit+WOPSplit{$IFDEF RET}+StkRetSplit{$ENDIF})),144+(20*Ord(PSOPDocHed=POR)));

    OrdHistoryPage.TabVisible:=BoChkAllowed_In(OrdersPage.TabVisible,ChkPWord(DbOrdersPage,-254,-254,-254,-254,307,308,-254,-254,-254));


  {$ELSE}

    OrdersPage.TabVisible:=BOff;

    OrdHistoryPage.TabVisible:=BOff;

  {$ENDIF}


  MainPage.TabVisible:=ChkAllowed_In(ChkPWord(0,01,10,24,116,0,0,373,-255,-255)) and (LastHRunNo=0);
  QuotesPage.TabVisible:=(QuotesPage.TabVisible and (LastHRunNo=0) and ChkAllowed_In(ChkPWord(0,303,305,-254,-254,-254,-254,-255,-254,-254)));

  HistoryPage.TabVisible:=(LastHRunNo<>0) or ChkAllowed_In(ChkPWord(0,304,306,338,-255,-255,-255,374,576,530));

  AutoPage.TabVisible:=BoChkAllowed_In({$IFDEF RET} (Not (DocHed In [ADJ]+STkRetSplit)) {$ELSE} (DocHed<>ADJ) {$ENDIF},ChkPWord(0,94,95,96,0,0,0,-254,-254,-254));


end;




procedure TDaybk1.FormCreate(Sender: TObject);
Var
  DKeyLen,
  n  :  Byte;

  StartPanel
     :  TSBSPanel;

  KeyStart,
  KeyEnd,
  KeyPrime
     :  Str255;
begin
  StartPanel := nil;
  ListActive:=BOff;

  LastCoord:=BOff;

  GotCoord:=BOff;
  NeedCUpdate:=BOff;
  FColorsChanged := False;
  UpdateFromPost:=BOff;

  fDoingClose:=BOff;
  fFrmClosing:=BOff;
  InBuildPostMenu:=BOff;
  UseAddInv:=BOff;

  Blank(PrintInvImage,Sizeof(PrintInvImage));

  ExLocal.Create;

  MatchFormPtr:=nil;
  DayBkTotPtr:=nil;

  DocHed:=DayBkFormMode;
  LastDocHed:=DocHed;
  LastHRunNo:=DayBkHistRunNo;

  {$IFDEF SOP}
    LastHCommP:=DayBkHistCommP;
  {$ENDIF}

  //Rahul001-Disabling multilist
  db1SBox.Visible := False;
  db1ListBtnPanel.Visible := False;

  //Rahul002-dataModule stuff
  if (DocHed in SalesSplit) then
    FdmMain := TMainDataModule.Create(Self,mtSales)
  else
    FdmMain := TMainDataModule.Create(Self,mtPurchase);

  frDaybkGrid.vMain.DataController.DataSource := FdmMain.dsDaybkFetchData;
  frDaybkGrid.InitGridColumns;
  frDaybkGrid.OnSetDetail := OnSetDetail;

  //Stop Find and Sortview
  Finddb1Btn.Enabled := false;
  SortViewBtn.enabled := false;

  MULCtrlO[0]:=TDayBkMList.Create(Self);
  MULCtrlO[0].IsDataFramework := True;

  db1SBox.HorzScrollBar.Position:=0;
  db1SBox.VertScrollBar.Position:=0;
  db1BSBox.HorzScrollBar.Position:=0;
  db1BSBox.VertScrollBar.Position:=0;

  DPageCtrl1.ActivePage:=MainPage;

    //PR: 25/10/2010 The SOP ifdef here was preventing the menus from being set correctly for non-SPOP versions,
    //               leading to crashes on the quotes tab (ABSEXCH-2561).
  {.$IFDEF SOP}

    If (DocHed In SalesSplit) then
      PSOPDocHed:=SOR
    else
      PSOPDocHed:=POR;

  {.$ENDIF}



  { CJS - 2013-08-21 - ABSEXCH-14558 - Daybook SortViews }
  If (DocHed In SalesSplit) then
    // MH 29/06/2015 Exch2015-R1 ABSEXCH-15991: Set Sort View Window Caption
    MULCtrlO[0].CreateSortView(svltSalesDaybookMain, 'Sales Daybook')
  else if (DocHed In PurchSplit) then
    // MH 29/06/2015 Exch2015-R1 ABSEXCH-15991: Set Sort View Window Caption
    MULCtrlO[0].CreateSortView(svltPurchaseDaybookMain, 'Purchase Daybook');

  // CA  08/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location). Clearing the field
  MULCtrlO[0].FilteredLocation := '';

  //PR: 05/11/2010 Added to use new Window Positioning system
  //PR: 27/05/2011 Change to use ClassName rather than Name as identifier - if there are
  //2 instances of the form in existence at the same time, Delphi will change the name of one to Name + '_1' (ABSEXCH-11426)
  FSettings := GetWindowSettings(Self.ClassName + '_' + DocCodes[DocHed]);
  if Assigned(FSettings) then
    FSettings.LoadSettings;

  MulCtrlO[0].Name := ListNames[0];

  Try


    With MULCtrlO[0] do
    Begin

      Try

        With VisiList do
        Begin
          AddVisiRec(db1ORefPanel,db1ORefLab);
          AddVisiRec(db1DatePanel,db1DateLab);
          AddVisiRec(db1PrPanel,db1PrLab);
          AddVisiRec(db1AccPanel,db1AccLab);
          AddVisiRec(db1DescPanel,db1DescLab);
          AddVisiRec(db1AmtPanel,db1AmtLab);
          AddVisiRec(db1StatPanel,db1StatLab);
          AddVisiRec(db1YRefPanel,db1YRefLab);

          // PKR. 16/11/2015. ABSEXCH-16318. Add a Transaction Owner column.
          AddVisiRec(db1OwnerPanel,db1OwnerLab);

          // MH 05/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
          ColAppear^[1].ExportMetadata := emtDate;
          ColAppear^[2].ExportMetadata := emtPeriod;
          If (DocHed <> WOR) Then
            ColAppear^[5].ExportMetadata := emtCurrencyAmount
          Else
            // WOR Amount column contains a % on the front, so leave as text, but right align
            ColAppear^[5].ExportMetadata := emtAlignRight;

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels(0);

          LabHedPanel:=db1HedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;   

      {InitSize.Y:=368;
      InitSize.X:=530;

      Self.Height:=InitSize.Y;
      Self.Width:=InitSize.X;}

      InitSize.Y:=341;
      InitSize.X:=522;

      Self.ClientHeight:=InitSize.Y;
      Self.ClientWidth:=InitSize.X;

      MDI_SetFormCoord(TForm(Self));

      HoldMCount:=0;
      PostMCount:=0;
      // CA  13/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location) : FilterMCount asigned
      FilterMCount:=0;

      Blank(LastBTag,Sizeof(LastBTag));


      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      // PKR 16/11/2015. ABSEXCH-16318. Add Transaction Owner column.
      MUTotCols:=8;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        {HBkColor:=ClHighLight;
        HTextColor:=ClHighLightText;}


        If (n=5) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=2;
        end;
      end;


      Find_FormCoord;



      ListCreate;

      Filter[1,1]:='*QU'; {* Exclude all quotes *}

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;

      DayBkListMode:=0;
      DayBkDocHed:=DocHed;

      Set_Buttons(db1ListBtnPanel);

      {* Include all including batches *}

      DKeyLen:=5;


      KeyStart:=FullDayBkKey(0,FirstAddrd,DocCodes[DocHed]);

      If (SWBentlyOn) and (DocHed In SalesSplit) then {* Due to big quotes list, it was real slow coming up with this list *}
                                                        {* Perhaps long Term, Batches should be in the Quotes Tab? *}
      Begin
        KeyPrime:=FullDayBkKey(0,0,DocCodes[DocHed]);
        StartLess:=BOn;
      end;

      {else
      Begin
        If (DocHed<>ADJ) then
          KeyStart:=FullDayBkKey(0,1,DocCodes[DocHed])
        else
          KeyStart:=FullDayBkKey(0,FirstAddrd,DocCodes[DocHed]);
      end;}

      KeyEnd:=FullDayBkKey(0,MaxInt,DocCodes[DocHed]);

      {$IFDEF WOP}
        If (DocHed In WOPSplit) then
        Begin
          KeyStart:=FullDayBkKey(WORUPRunNo,FirstAddrd,DocCodes[DocHed]);
          KeyEnd:=FullDayBkKey(WORUPRunNo,MaxInt,DocCodes[DocHed]);


        end;
      {$ENDIF}


      {$IFDEF RET}
        If (DocHed In StkRetSplit) then
        Begin
          KeyStart:=FullDayBkKey(Set_RETRunNo(DocHed,BOff,BOff),FirstAddrd,DocCodes[DocHed]);
          KeyEnd:=FullDayBkKey(Set_RETRunNo(DocHed,BOff,BOff),MaxInt,DocCodes[DocHed]);
        end;

      {$ENDIF}

      OrigKey:=KeyStart;
      OKLen:=DKeyLen;

      if MulCtrlO[0].UseDefaultSortView then
        MulCtrlO[0].UseDefaultSortView := MulCtrlO[0].SortView.LoadDefaultSortView;

      //Rahul001- LoadingList
      {if MulCtrlO[0].UseDefaultSortView then
        RefreshList
      else
        StartList(InvF,InvRNoK,KeyStart,KeyEnd,KeyPrime,DKeyLen,BOff);}

      ListOfSet:=10;



    end {With}


  Except

    MULCtrlO[0].Free;
    MULCtrlO[0]:=Nil;
  end; 


  If (LastHRunNo=0) then
    Caption:=DocGroup[GetDocGroup(DocHed)]+' Transactions'
  else
    Caption:='Posted Transactions for Run No. '+Form_Int(LastHRunNo,0);

  // CA  10/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location). Setting the Main Caption
  MainCaption := Caption;

  If (DocHed In NomSplit) then
    HelpContext:=12
  else
    If (DocHed In StkAdjSplit) then
      HelpContext:=390
    else
      If (DocHed In WOPSplit) then
        HelpContext:=1327

      {$IFDEF RET}
        else
          If (DocHed In StkRETSplit) then
            HelpContext:=1652;

      {$ELSE}
        ;
      {$ENDIF}

  DPageCtrl1.HelpContext:=Self.HelpContext;

  SetPageHelp(0);

//  FormSetOfSet;

  FormReSize(Self);


  PrimeButtons(DayBkFormPage,BOff);

  BuildMenus;

  ChangePage(DayBkFormPage);

  SetTabs2;

  If (DayBkFormPage<>Current_Page) and (DayBkFormPage=0) then {Main form must be hidden}
  Begin
    DayBkFormPage:=Current_Page;
    ChangePage(0);

    ChangePage(DayBkFormPage);

  end;

  {$IFDEF CU}
  (* HM 13/07/00: Now done in PrimeButtons, this is interferring
  try
    If (DocHed In PurchSplit) then
    Begin
      CustdbBtn1.TextId:=3;
      CustdbBtn2.TextId:=4;
    end;

    EntCustom1.Execute;
  except
    ShowMessage('Customisation Control Failed to initialise');
  end;
  *)
  {$ENDIF}

end;


procedure TDaybk1.FormActivate(Sender: TObject);
begin

  If (Assigned(FormBitMap)) then
    FormResize(nil);
    
  If (Assigned(MULCtrlO[0])) then
  Begin
    If (Assigned(MULCtrlO[Current_Page]))  {and (Not ListActive)} then
      MULCtrlO[Current_Page].SetListFocus;
  end;

  ListActive:=BOn;
end;


{* These routines free up resources, by freeing up the handle for DPageCtrl1
   as soon as the focus is lost. To give the illusion of continuity, a bit map is created
   of the image of the form, and this is displayed instead of the form.
   Whilst this is a good idea, no updating can go on of the form whilst it does not have the
   focus.

   Routines used: FormDeactivate, Formpaint, FormActivate, WMSendFocus FormResize Formmouse down
                  Apparently, if the focus is returned from a form which is not an MDI
                  child, OnActivate does not get called, so we rely on the user clicking
                  crude, and gives the impresion that the firat click is ignored.

*}

procedure TDaybk1.FormDeactivate(Sender: TObject);
begin
  If (Not KeepLive) and (Syss.ConsvMem) then
  Begin
    FormBitMap:=GetFormImage;
    LockWindowUpDate(Handle);
    THintWindow(DPageCtrl1).ReleaseHandle;
    LockWindowUpDate(0);
  end;
end;

procedure TDaybk1.FormPaint(Sender: TObject);
begin
  If (Assigned(FormBitMap)) then
    Canvas.Draw(0,0,FormBitMap);
end;

procedure TDaybk1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Assigned(FormBitMap)) then
    FormResize(nil);
end;

procedure TDaybk1.FormResize(Sender: TObject);

Var
  n           :  Byte;
  ParentForm  :  TCustomForm;


begin
  If (Assigned(FormBitMap)) then
  Begin
    FormBitMap.Free;
    FormBitMap:=nil;

    LockWindowUpdate(Handle);
    DPageCtrl1.HandleNeeded;
    ParentForm:=GetParentForm(DPageCtrl1);
    ParentForm.ActiveControl:=DPageCtrl1;
    With DPageCtrl1 do
    Begin
      BringToFront;
      Visible:=BOff;
      Visible:=BOn;
    end;

    With db1BtnPanel do
    Begin
      BringToFront;
      Visible:=BOff;
      Visible:=BOn;
    end;

    LockWindowUpdate(0);

  end;


  If (GotCoord) and (Not fDoingClose) then
  Begin

    If (Assigned(MULCtrlO[Current_Page])) then
      MULCtrlO[Current_Page].LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    DPageCtrl1.Width:=ClientWidth-PagePoint[0].X;
    DPageCtrl1.Height:=ClientHeight-PagePoint[0].Y;


    pnlGridBackground.Width:=DPageCtrl1.Width-PagePoint[1].X;
    pnlGridBackground.Height:=DPageCtrl1.Height-PagePoint[1].Y;

    db2SBox.Width:=DPageCtrl1.Width-PagePoint[1].X;
    db2SBox.Height:=DPageCtrl1.Height-PagePoint[1].Y;

    db3SBox.Width:=DPageCtrl1.Width-PagePoint[1].X;
    db3SBox.Height:=DPageCtrl1.Height-PagePoint[1].Y;

    db4SBox.Width:=DPageCtrl1.Width-PagePoint[1].X;
    db4SBox.Height:=DPageCtrl1.Height-PagePoint[1].Y;

    db5SBox.Width:=DPageCtrl1.Width-PagePoint[1].X;
    db5SBox.Height:=DPageCtrl1.Height-PagePoint[1].Y;

    db6SBox.Width:=DPageCtrl1.Width-PagePoint[1].X;
    db6SBox.Height:=DPageCtrl1.Height-PagePoint[1].Y;

    db1BtnPanel.Left:=DPageCtrl1.Width-PagePoint[2].X;
    db1BtnPanel.Height:=DPageCtrl1.Height-PagePoint[2].Y;


    db1BSBox.Height:=db1BtnPanel.Height-PagePoint[3].X;

    db1ListBtnPanel.Left:=DPageCtrl1.Width-PagePoint[4].X;
    db1ListBtnPanel.Height:=DPageCtrl1.Height-PagePoint[4].Y;

    db2ListBtnPanel.Left:=DPageCtrl1.Width-PagePoint[4].X;
    db2ListBtnPanel.Height:=DPageCtrl1.Height-PagePoint[4].Y;

    db3ListBtnPanel.Left:=DPageCtrl1.Width-PagePoint[4].X;
    db3ListBtnPanel.Height:=DPageCtrl1.Height-PagePoint[4].Y;

    db4ListBtnPanel.Left:=DPageCtrl1.Width-PagePoint[4].X;
    db4ListBtnPanel.Height:=DPageCtrl1.Height-PagePoint[4].Y;

    db5ListBtnPanel.Left:=DPageCtrl1.Width-PagePoint[4].X;
    db5ListBtnPanel.Height:=DPageCtrl1.Height-PagePoint[4].Y;

    db6ListBtnPanel.Left:=DPageCtrl1.Width-PagePoint[4].X;
    db6ListBtnPanel.Height:=DPageCtrl1.Height-PagePoint[4].Y;


    For n:=0 to 5 do
    If (MULCtrlO[n]<>nil) then
    Begin
      With MULCtrlO[n].VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=pnlGridBackground.ClientHeight-PagePoint[3].Y;
      end;


      With MULCtrlO[n] do
      Begin
        ReFresh_Buttons;

        RefreshAllCols;
      end;
    end;{Loop..}

    If (Assigned(MULCtrlO[Current_Page])) then
      MULCtrlO[Current_Page].LinkOtherDisp:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));


  end; {If time to update}


end;



Procedure TDayBk1.Send_ParentMsg(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=Mode;

  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}

Function TDaybk1.CheckListFinished  :  Boolean;

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

procedure TDaybk1.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  n  :  Byte;
  SortView: TBaseSortView;
begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    Send_ParentMsg(10+GetDocGroup(DocHed)); {Form closing..}

    //PR: 05/11/2010 Changed to use new Window Position System
    if Assigned(FSettings) and NeedCUpdate then
    begin
      if Assigned(MULCtrlO[0]) then
        FSettings.ParentToSettings(MULCtrlO[0], MULCtrlO[0]);
      For n:=1 to High(MULCtrlO) do
        If (MULCtrlO[n]<>nil) then
          FSettings.ParentToSettings(MULCtrlO[n], MULCtrlO[n]);
      FSettings.WindowToSettings(Self);
      FSettings.SaveSettings(StoreCoord);
      FSettings := nil;
    end;


    For n:=Low(MULCtrlO) to High(MULCtrlO) do  {* Seems to crash here if form open and you close app... *}
      If (MULCtrlO[n]<>nil) then
      Begin
        { CJS - 2013-08-27 - ABSEXCH-14558 - Daybook SortViews }
        if (MulCtrlO[n].SortView <> nil) then
        begin
          MulCtrlO[n].SortView.CancelBuild;
          MulCtrlO[n].SortView.Enabled := False;
          SortView := MulCtrlO[n].SortView;
          SortView.Free;
          MulCtrlO[n].SortView := nil;
        end;

        //PR: 26/05/2016 Change to use FreeAndNil so that the component is set to nil before destroy is called.
        //               Destroy ends up posting a set focus message to the form which calls FormActivate
        //               which tries to access the component if it isn't nil.
        FreeAndNil(MULCtrlO[n]);

{        MULCtrlO[n].Destroy;
        MULCtrlO[n]:=nil;}
      end;

    //PR: 05/11/2010
  end;
end;

procedure TDaybk1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  {Sanjay Sonani 08/02/2016 2016-R1
  ABSEXCH-15747: Window should not be close till the "Conv_Quote" completed.}
  if fDisableFormClose then
  begin
    CanClose := False;
    Exit;
  end;

  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try

      GenCanClose(Self,Sender,CanClose,BOn);

      If (CanClose) then
        CanClose:=CheckListFinished;

      If (CanClose) then
        CanClose:=GenCheck_InPrint and (Not UpdateFromPost);

      If (CanClose) then
      Begin
        db1SBox.HorzScrollBar.Position:=0;
        db1SBox.VertScrollBar.Position:=0;
        db1BSBox.HorzScrollBar.Position:=0;
        db1BSBox.VertScrollBar.Position:=0;

        db2SBox.HorzScrollBar.Position:=0;
        db2SBox.VertScrollBar.Position:=0;

        db3SBox.HorzScrollBar.Position:=0;
        db3SBox.VertScrollBar.Position:=0;

        db4SBox.HorzScrollBar.Position:=0;
        db4SBox.VertScrollBar.Position:=0;

        db5SBox.HorzScrollBar.Position:=0;
        db5SBox.VertScrollBar.Position:=0;

        db6SBox.HorzScrollBar.Position:=0;
        db6SBox.VertScrollBar.Position:=0;

{        If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
          Store_FormCoord(Not SetDefault);}
      end;
    finally
      fFrmClosing:=BOff;
    end; {Try..}
  end
  else
    CanClose:=BOff;

end;

procedure TDaybk1.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin

  ExLocal.Destroy;

  For n:=Low(CustBtnList) to High(CustBtnList) do
    If (CustBtnList[n]<>nil) then
      CustBtnList[n].Free;

  {$IFDEF Inv}

    For n:=0 to High(TransForm) do
      If (TransForm[n]<>nil) then
      Begin
        TransForm[n].Free;
        TransActive[n]:=BOff;
      end;

    If (RecepForm<>nil) then
    Begin
      RecepForm.Free;
      TransActive[1]:=BOff;
    end;

    If (NTxfrForm<>nil) then
    Begin
      NTxfrForm.Free;
      TransActive[2]:=BOff;
    end;

    If (BatchForm<>nil) then
    Begin
      BatchForm.Free;
      TransActive[4]:=BOff;
    end;

    {$IFDEF STK}

      If (SAdjForm<>nil) then
      Begin
        SAdjForm.Free;
        TransActive[3]:=BOff;
      end;

      {$IFDEF WOP}
        If (WORForm<>nil) then
        Begin
          WORForm.Free;
          TransActive[7]:=BOff;
        end;

      {$ENDIF}

      {$IFDEF RET}
        If (RETForm<>nil) then
        Begin
          RETForm.Free;
          TransActive[9]:=BOff;
        end;

      {$ENDIF}

        {If (WINForm<>nil) then  {* EN440WOP
        Begin
          WINForm.Free;
          TransActive[7]:=BOff;
        end;}


      
    {$ENDIF}

    {$IFDEF JC}

      If (TShtForm<>nil) then
      Begin
        TShtForm.Free;
        TransActive[8]:=BOff;
      end;

    {$ENDIF}


  {$ENDIF}

end;


procedure TDaybk1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


// MH 05/07/2016 2016-R2 ABSEXCH-17638: B2B POR's not printing
//PR: 15/11/2017 2018-R2 ABSEXCH-19451 Allow edit of posted transactions
procedure TDayBk1.Display_Inv(      Mode            : Byte;
                                    CPage           : Integer;
                              Const BackToBackTrans : Boolean = False;
                              const AllowPostedEdit : Boolean = False);

Begin

  {$IFDEF Inv}

    If (TransForm[0]=nil) then
    Begin

      Set_TransFormMode(LastDocHed,CPage);  {*Ex 32 needs changing *}

      TransForm[0]:=TSalesTBody.Create(Self);

    end
    else //HV 07/12/2017 ABSEXCH-19535: Anonymised Transcation > The height of the window gets increased if "Save coordinates" is ticked
      TransForm[0].ListScanningOn := True;

    Try

     TransActive[0]:=BOn;

     With TransForm[0] do
     Begin
       // MH 05/07/2016 2016-R2 ABSEXCH-17638: B2B POR's not printing
       BackToBackTransaction := BackToBackTrans;

       //PR: 15/11/2017 ABSEXCH-19451 Set editable fields on transaction
       if AllowPostedEdit then
         EnableEditPostedFields;

       WindowState:=wsNormal;
       Show;



       If (Mode In [1..3,7,9]) and (Not ExLocal.InAddEdit) then
       Begin
         ChangePage(0+(2*Ord(Mode=9))+(6*Ord(Mode=7)));

         Case Mode of

           1,2,7,9
              :   EditAccount((Mode<>1),(CPage=2),((Inv.HoldFlg and HoldC) =HoldC) and (Mode=9),(Mode=9));

         end; {Case..}

       end
       else
         If (Not ExLocal.InAddEdit) then
           ShowLink(BOn,BOn);


       {If (Mode=5) then
         ChangePage(2);}

     end; {With..}


    except

     TransActive[0]:=BOff;

     TransForm[0].Free;

    end;

  {$ENDIF}

end;


procedure TDayBk1.Display_Recep(Mode  :  Byte;
                                CPage :  Integer;
                                const AllowPostedEdit : Boolean = False);

Begin

  {$IFDEF Inv}

    If (RecepForm=nil) then
    Begin

      Set_RecepFormMode(LastDocHed,CPage);

      RecepForm:=TRecepForm.Create(Self);

    end
    else //AP 07/12/2017 2018R1 ABSEXCH-19538: Anonymised Transactions > Notification banner is not displayed for SRC, PPY, xBT.
      RecepForm.ListScanningOn := True;

    Try

     TransActive[1]:=BOn;

     With RecepForm do
     Begin

       WindowState:=wsNormal;
       Show;

       //PR: 16/11/2017 ABSEXCH-19451 Set editable fields on transaction
       if AllowPostedEdit then
         EnableEditPostedFields;

       If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
       Begin
         ChangePage(0+(1*Ord(Mode=7)));

         Case Mode of

           1,2,7
              :   EditAccount((Mode<>1),(CPage=2),BOff);

         end; {Case..}

       end
       else
         If (Not ExLocal.InAddEdit) then
         begin
             if AllowPostedEdit then
               EditAccount((Mode<>1),(CPage=2),True)
             else
               ShowLink(BOn,BOn);
          end;



     end; {With..}


    except

     TransActive[1]:=BOff;

     RecepForm.Free;

    end;

  {$ENDIF}

end;


procedure TDayBk1.Display_NTxfr(Mode  :  Byte;
                                CPage :  Integer;
                                const AllowPostedEdit : Boolean = False);

Begin

  {$IFDEF Inv}

    If (NTxfrForm=nil) then
    Begin

      Set_NTxfrFormMode(LastDocHed,CPage);  

      NTxfrForm:=TNTxfrForm.Create(Self);

    end;

    Try

     TransActive[2]:=BOn;

     With NTxfrForm do
     Begin

       WindowState:=wsNormal;
       Show;

       //PR: 15/11/2017 ABSEXCH-19451 Set editable fields on transaction
       if AllowPostedEdit then
         EnableEditPostedFields;


       If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
       Begin
         ChangePage(0+(2*Ord(Mode=7)));

         Case Mode of

           1,2,7
              :   EditAccount((Mode<>1),(CPage=2),BOff);

         end; {Case..}

       end
       else
         If (Not ExLocal.InAddEdit) then
           ShowLink(BOn,BOn);



     end; {With..}


    except

     TransActive[2]:=BOff;

     NTxfrForm.Free;

    end;

  {$ENDIF}

end;


procedure TDayBk1.Display_SAdj(Mode  :  Byte;
                               CPage :  Integer);

Begin

  {$IFDEF Inv}

    {$IFDEF STK}

     If (SAdjForm=nil) then
     Begin

       Set_SAdjFormMode(LastDocHed,CPage);

       SAdjForm:=TStkAdj.Create(Self);

     end;

     Try

      TransActive[3]:=BOn;

      With SAdjForm do
      Begin

        WindowState:=wsNormal;
        Show;



        If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
        Begin
          ChangePage(0+(1*Ord(Mode=7)));

          Case Mode of

            1,2,7
               :   EditAccount((Mode<>1),(CPage=2),BOff);

          end; {Case..}

        end
        else
          If (Not ExLocal.InAddEdit) then
            ShowLink(BOn,BOn);



      end; {With..}


     except

      TransActive[3]:=BOff;

      SAdjForm.Free;

     end;

    {$ENDIF}
  {$ENDIF}

end;


procedure TDayBk1.Display_WOR(Mode  :  Byte;
                              CPage :  Integer;
                     const AllowPostedEdit : Boolean = False);

Begin

  {$IFDEF Inv}

    {$IFDEF STK}

      {$IFDEF WOP}

       If (WORForm=nil) then
       Begin

         Set_WORFormMode(LastDocHed,CPage);

         WORForm:=TWOR.Create(Self);

       end;

       Try

        TransActive[7]:=BOn;

        With WORForm do
        Begin

         //PR: 16/11/2017 ABSEXCH-19451 Set editable fields on transaction
         if AllowPostedEdit then
           EnableEditPostedFields;


          WindowState:=wsNormal;
          Show;



          If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
          Begin
            ChangePage(0+(4*Ord(Mode=7)));

            Case Mode of

              1,2,7
                 :   EditAccount((Mode<>1),(CPage=2),BOff);

            end; {Case..}

          end
          else
            If (Not ExLocal.InAddEdit) then
              ShowLink(BOn,BOn);



        end; {With..}


       except

        TransActive[7]:=BOff;

        WORForm.Free;

       end;
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

end;


procedure TDayBk1.Display_RET(Mode  :  Byte;
                              CPage :  Integer;
                     const AllowPostedEdit : Boolean = False);

Begin

  {$IFDEF Inv}

    {$IFDEF STK}

      {$IFDEF RET}

       If (RETForm=nil) then
       Begin

         Set_RETFormMode(LastDocHed,CPage);

         RETForm:=TRetDoc.Create(Self);

       end;

       Try

       //PR: 21/11/2017 ABSEXCH-19451 Set editable fields on transaction
       if AllowPostedEdit then
         RETForm.EnableEditPostedFields;

        TransActive[9]:=BOn;


        With RETForm do
        Begin

          WindowState:=wsNormal;
          Show;



          If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
          Begin
            ChangePage(0+(5*Ord(Mode=7)));

            Case Mode of

              1,2,7
                 :   EditAccount((Mode<>1),(CPage=2),BOff);

            end; {Case..}

          end
          else
            If (Not ExLocal.InAddEdit) then
              ShowLink(BOn,BOn);



        end; {With..}


       except

        TransActive[9]:=BOff;

        RETForm.Free;

       end;
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

end;


{$IFDEF WORWIN} {*EN440WOP *}

procedure TDayBk1.Display_WIN(Mode  :  Byte;
                              CPage :  Integer);

Begin

  {$IFDEF Inv}

    {$IFDEF STK}

      {$IFDEF WOP}

       If (WINForm=nil) then
       Begin

         Set_WINFormMode(LastDocHed,CPage);

         WINForm:=TWIN.Create(Self);

       end;

       Try

        TransActive[7]:=BOn;

        With WINForm do
        Begin

          WindowState:=wsNormal;
          Show;



          If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
          Begin
            ChangePage(0+(1*Ord(Mode=7)));

            Case Mode of

              1,2,7
                 :   EditAccount((Mode<>1),(CPage=2),BOff);

            end; {Case..}

          end
          else
            If (Not ExLocal.InAddEdit) then
              ShowLink(BOn,BOn);



        end; {With..}


       except

        TransActive[7]:=BOff;

        WINForm.Free;

       end;
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

end;





{$ENDIF}


procedure TDayBk1.Display_TSht(Mode  :  Byte;
                               CPage :  Integer;
                         const AllowPostedEdit : Boolean = False);


Begin
  {$IFDEF Inv}

    {$IFDEF JC}

     If (TShtForm=nil) then
     Begin
       Set_TSheetFormMode(LastDocHed,108);

       TShtForm:=TTSheetForm.Create(Self);

     end;

     Try

      TransActive[8]:=BOn;

      With TShtForm do
      Begin

        WindowState:=wsNormal;

        Show;


        If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
        Begin
          ChangePage(0+(1*Ord(Mode=7)));

          Case Mode of

            1,2,7
               :   EditAccount((Mode<>1),(CPage=2),BOff);

          end; {Case..}

        end
        else
          If (Not ExLocal.InAddEdit) then
            ShowLink(BOn,BOn);



      end; {With..}


     except

      TransActive[8]:=BOff;

      TShtForm.Free;
      TShtForm:=nil;

     end;

    {$ENDIF}
  {$ENDIF}
end;



procedure TDayBk1.Display_Batch(Mode  :  Byte;
                                CPage :  Integer);

Begin

  {$IFDEF Inv}

    If (BatchForm=nil) then
    Begin

      Set_BatchFormMode(LastDocHed,CPage);

      BatchForm:=TBatchEntry.Create(Self);

    end
    else //AP 07/12/2017 2018R1 ABSEXCH-19538: Anonymised Transactions > Notification banner is not displayed for SRC, PPY, xBT.
      BatchForm.ListScanningOn := True;

    Try

     TransActive[4]:=BOn;

     With BatchForm do
     Begin

       WindowState:=wsNormal;
       Show;



       If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
       Begin
         ChangePage(0+(2*Ord(Mode=7)));

         Case Mode of

           1,2,7
              :   EditAccount((Mode<>1),(CPage=2),BOff);

         end; {Case..}

       end
       else
         If (Not ExLocal.InAddEdit) then
           ShowLink(BOn,BOn);



     end; {With..}


    except

     TransActive[4]:=BOff;

     BatchForm.Free;

    end;

  {$ENDIF}

end;

// MH 05/07/2016 2016-R2 ABSEXCH-17638: B2B POR's not printing
//PR: 15/11/2017 2018-R2 ABSEXCH-19451 Allow edit of posted transactions
procedure TDayBk1.Display_Trans(Mode : Byte; Const BackToBackTrans : Boolean = False;
                                const AllowPostedEdit : Boolean = False);

Var
  CPage    :  Integer;

Begin

  {$IFDEF Inv}

    CPage:=Current_Page;

    If (LastDocHed In RecieptSet) then
      Display_Recep(Mode,CPage, AllowPostedEdit)
    else
      If (LastDocHed In NomSplit) then
        Display_NTxfr(Mode,CPage, AllowPostedEdit)
      else
        If (LastDocHed In StkAdjSplit) then
          Display_SAdj(Mode,CPage)
        else
          If (LastDocHed=WOR) then
            Display_WOR(Mode,CPage, AllowPostedEdit)
          {else
            If (LastDocHed=WIN) then {*EN440WOP
              Display_WIN(Mode,CPage)}
            else
            {$IFDEF RET}
              If (LastDocHed In StkRetSplit) then
                Display_RET(Mode,CPage, AllowPostedEdit)
              else
            {$ENDIF}

              If (LastDocHed In BatchSet) then
                Display_Batch(Mode,CPage)
               else
                 If (LastDocHed In TSTSplit ) then
                  Display_TSht(Mode,CPage, AllowPostedEdit)
              else
                // MH 05/07/2016 2016-R2 ABSEXCH-17638: B2B POR's not printing
                Display_Inv(Mode,CPage, BackToBackTrans, AllowPostedEdit);


  {$ENDIF}

end;


procedure TDayBk1.Display_Match(ChangeFocus,
                                MatchMode     :  Boolean);


Var
  NomNHCtrl  :  TNHCtrlRec;

  FoundLong  :  Longint;

  MatchForm  :  TMatchWin;

  WasNew     :  Boolean;

Begin

  WasNew:=BOff;

  With EXLocal,NomNHCtrl do
  Begin
    AssignFromGlobal(InvF);

    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

    NHMode:=4-Ord(MatchMode);

    NHCr:=0;

    MainK:=FullMatchKey(MatchTCode,MatchSCode,LInv.OurRef);

    NHKeyLen:=Length(MainK);

    Set_MAFormMode(NomNHCtrl);

  end;

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

   If (WasNew) then
   Begin
   end;

  except

   MatchFormPtr:=nil;

   MatchForm.Free;
   MatchForm:=nil;

  end; {try..}


end;


procedure TDayBk1.SendObjectCC;

Begin
  SendToObjectCC(Inv.CustCode,0);
end;


Procedure TDayBk1.WMDayBkGetRec(Var Message  :  TMessage);


Var
  OK2Exe,
  UseFONL  :  Boolean;

  DummySender
           :  TObject;

  DisplayMode : Integer;
Begin
  UseFONL:=BOff;  OK2Exe:=BOn;   DummySender:=nil;


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      0,169
         :  Begin
              If (WParam=169) then
                MULCtrlO[Current_Page].GetSelRec(BOff);

              LastDocHed:=Inv.InvDocHed;

              If (MULCtrlO[Current_Page].ValidLine) then
              Begin
                // MH 14/11/2014 Order Payments: Prevent editing of Order Payments Payments and Refunds
                DisplayMode := 2;
                {$IFDEF SOP}
                If (DocHed In SalesSplit) And (Inv.thOrderPaymentElement In OrderPayment_PaymentAndRefundSet) Then
                  // Change to View mode - after discussion with QA it was decided not to have an annoying popup message
                  DisplayMode := 0;
                {$ENDIF SOP}

                {$IFDEF CU}
                  ExLocal.AssignFromGlobal(InvF);
                  Ok2Exe:=ExecuteCustBtn(2000,IfThen(DisplayMode=2,150,155),ExLocal);
                {$ENDIF}

                If (Ok2Exe) then
                  Display_Trans(DisplayMode);
              end;
            end;


      1  :  Begin
              {$IFDEF Inv}

              // SSK 28/10/2017 ABSEXCH-19398: Implements anonymisation behaviour for Transaction
              CopyDb1Btn.Enabled := not (GDPROn and (trim(Inv.OurRef) <> '') and Inv.thAnonymised);
              Convdb1Btn.Enabled := CopyDb1Btn.Enabled;

              If (Inv.InvDocHed In RecieptSet) then
              Begin
                If (RecepForm<>nil) and (TransActive[1]) then
                With RecepForm do
                Begin
                  If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) and (Inv.OurRef<>ExLocal.LInv.OurRef) then
                  Begin
                    KeepLive:=BOn;
                    //AP 07/12/2017 2018R1 ABSEXCH-19538:Anonymised Transactions > Notification banner is not displayed for SRC, PPY, xBT.
                    ListScanningOn := True;
                    ShowLink(BOn,BOn);
                  end;
                end;
              end
              else
              {$IFDEF WOP}
                 If (Inv.InvDocHed In WOPSplit) then
                 Begin
                   If (WORForm<>nil) and (TransActive[7]) then
                   With WORForm do
                   Begin
                     If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) and (Inv.OurRef<>ExLocal.LInv.OurRef) then
                     Begin
                       KeepLive:=BOn;
                       ShowLink(BOn,BOn);
                     end;
                   end;
                 end
                 else
              {$ENDIF}
              {$IFDEF RET}
                 If (Inv.InvDocHed In StkRetSplit) then
                 Begin
                   If (RETForm<>nil) and (TransActive[9]) then
                   With RETForm do
                   Begin
                     If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) and (Inv.OurRef<>ExLocal.LInv.OurRef) then
                     Begin
                       KeepLive:=BOn;
                       ShowLink(BOn,BOn);
                     end;
                   end;
                 end
                 else
              {$ENDIF}

              Begin
                If (TransForm[0]<>nil) and (TransActive[0]) then
                With TransForm[0] do
                Begin

                  If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) and (Inv.OurRef<>ExLocal.LInv.OurRef) then
                  Begin
                    {$IFDEF CU}
                      ExLocal.AssignFromGlobal(InvF);
                      Ok2Exe:=ExecuteCustBtn(2000,156,ExLocal);
                    {$ENDIF}

                    If (Ok2Exe) then
                    Begin
                      KeepLive:=BOn;
                      //HV 07/12/2017 ABSEXCH-19535: Anonymised Transcation > The height of the window gets increased if "Save coordinates" is ticked
                      ListScanningOn := True;
                      ShowLink(BOn,BOn);
                    end;
                  end;
                end;

                //AP : 09/08/2017 : ABSEXCH-18652 : Rayner - Viewing transactions on the Nominal Daybook
                If (NTxfrForm<>nil) and (TransActive[2]) then
                With NTxfrForm do
                Begin
                  If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) and (Inv.OurRef<>ExLocal.LInv.OurRef) then
                  Begin
                    KeepLive:=BOn;
                    ShowLink(BOn,BOn);
                  end;
                end;
              end;



              {$ENDIF}

              If (MatchFormPtr<>nil) then
                Display_Match(BOff,((Inv.RemitNo<>'') or (Inv.OrdMatch)));

              SendObjectCC;

              {$IFDEF SOP}
                // Update the Order Payments Tracker - need to pass across all transactions so
                // that the details can be blanked when a non-Order Payments transaction is
                // selected, so as not to mislead the user.
                If Syss.ssEnableOrderPayments And (Inv.InvDocHed In [SOR, SDN]) Then
                  UpdateOrderPaymentsTracker(Inv);
              {$ENDIF}
            end;


      2  :  ShowRightMeny(LParamLo,LParamHi,1);

            {* This siwtch used here to stop the screen from freeing up memory
            while the please wait message is shown, otherwise the list is not
            updated *}

     20,    {* Do not disable screen whilst please wait message is on *}
     21  :  KeepLive:=(WParam=20);

     25  :  NeedCUpdate:=BOn;


    100..109
         :

          With MULCtrlO[WParam-100] do
          Begin
            if IsDataFramework then
            begin
              frDaybkGrid.RefreshGrid;
              Exit;
            end;
              If ((DocHed In SalesSplit) and (Inv.InvDocHed In SalesSplit)) or ((DocHed In PurchSplit) and (Inv.InvDocHed In PurchSplit))
              or ((DocHed In WOPSplit) and (Inv.InvDocHed In WOPSplit))
              {$IFDEF RET}  or ((DocHed In StkRETSplit) and (Inv.InvDocHed In StkRetSplit)) {$ENDIF}
                or (LParam=0) or ((LParam=1) and (DocHed In [NMT,ADJ])) then
                Begin
                  PrintInvImage:=Inv; {v5.52. Take snapshot of new invoice incase a filter is in place which will prevent the list from displaying it and hence printing it}
                  { CJS - 2013-08-22 - ABSEXCH-14558 - Daybook SortViews }
                  // HV  15/03/2016 2016-R2 ABSEXCH-15705: If Sort view applied to Main Daybook then Print Dialog shows incorrect details after adding new Transaction
                  if SortViewEnabled then
                  begin
                    RefreshList;
                    Inv:=PrintInvImage;
                    {SS:22/09/2016:ABSEXCH-17352:Applying a sort view and then adding a transaction,the system automatically highlights the top transaction rather
                    than the newly created one.
                    :Locate newly added record from the stored record list.
                    :For pervasive and SQL server both have different key formation for the Sorted temp file.}
                    if UsingSQL then
                      LocateRecord(FullNomKey(SortView.ListID)+#9 + Inv.OurRef,STLinkStrK)
                    else
                      LocateRecord(FullNomKey(SortView.ListID) + Inv.OurRef,STLinkStrK);
                  end
                  else
                    AddNewRow(MUListBoxes[0].Row,(LParam=1));
                end;

              If (LParam=1) then
                DummySender:=EntCustom1;


              If ((LParam=0) or ((DocHed In SalesSplit+WOPSplit{$IFDEF RET}+StkRetSplit{$ENDIF}) and (Inv.InvDocHed In PurchSplit))) and (Check_AutoPrint(Inv)) and (Current_Page<>2) then
              Begin
                If (AddUpdateFail) then
                Begin
                  UseAddInv:=BOn;
                end;

              end;

            end;

    121  :  ; {Reserved for call back from Allocation wizard, not required from this list}


    170  :  If (Current_Page<>2) and (Assigned(MULCtrlO[Current_Page])) then
            Begin
              Printdb1BtnClick(nil);
            end;

    175  :  With DPageCtrl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

    177  :  Begin
              PrimeButtons(Current_Page,BOn);

              Check_TabAfterPW(DPageCtrl1,Self,WM_CustGetRec);
            end;

    182  :  With MULCtrlO[Current_Page] do
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
            end;

    185  :  Begin {* Force a change to quote page, if quote being added, but not by auto *}
              ChangePage(1);
            end;

    200..209
         :  Begin
              {$IFDEF Inv}

                Case WParam of

                  200  :  TransForm[0]:=nil;
                  201  :  RecepForm:=nil;
                  202  :  NTxfrForm:=nil;

                  {$IFDEF STK}
                    203:  SAdjForm:=nil;

                    {$IFDEF WOP}
                      207  :  WORForm:=nil;
                      {206  :  WINForm:=nil;} {*EN440WOP*}
                    {$ENDIF}

                    {$IFDEF RET}
                      209  :  RETForm:=nil;
                    {$ENDIF}
                  {$ENDIF}

                  204  :  BatchForm:=nil;

                  {$IFDEF JC}
                    208  :  TShtForm:=nil;

                  {$ENDIF}

                end; {Case..}

              {$ENDIF}

              TransActive[WParam-200]:=BOff;

              {* Cancel keep line whilst scanning *}

              KeepLive:=BOff;

            end;


    {300,
    301  :  With MULCtrlO[WParam-300] do
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
            end;     }


  {$IFDEF GF}

    3002
          : If (Assigned(FindCust)) then
              With MULCtrlO[LParam],FindCust,ReturnCtrl do
              Begin
                InFindLoop:=BOn;

                If (SearchMode=5) then
                Begin
                  UseFONL:=Not FindxOurRef(SearchKey);

                  If (UseFONL) then
                    ShowMessage('Unable to locate '+SearchKey);
                end
                else
                Begin
                  UseFONL:=BOn;

                  If (UseFONL) then
                    // CJS 2013-11-08 - ABSEXCH-14744 - Access Violation on Find in Daybook
                    if MULCtrlO[LParam].SortViewEnabled then
                      Find_OnActualList(InvF, FullNomKey(Inv.FolioNum), InvFolioK)
                    else
                      Find_OnList(SearchMode,SearchKey);
                end;

                With MUListBoxes[0] do
                  If (CanFocus) then
                    SetFocus;

                InFindLoop:=BOff;
              end;

  {$ENDIF}

    {$IFDEF ADDNOMWIZARD}
      30000 : begin
        if lParam = 1
        then ChangePage(AutoPage.PageIndex);
        AddButtonExecute(Adddb1Btn, FALSE);
      end;
    {$ENDIF}

    end; {Case..}

  end;
  Inherited;
end;


Procedure TDayBk1.UpdatePostStatus(PageNo  :  Integer);

Begin
  If (Assigned(MULCtrlO[PageNo])) then {* Update list from posting Thread *}
  With MULCtrlO[PageNo] do
  Begin
    PageUpDn(0,BOn);

    If (PageKeys^[0]=0) then
      InitPage;
  end;
end;


Procedure TDayBk1.WMFormCloseMsg(Var Message  :  TMessage);

{$IFDEF ADDNOMWIZARD}
Var
  KeyI   :  Str255;
{$ENDIF}


Begin

  With Message do
  Begin

    Case WParam of

      {0,1 Reserved for posting notification - not sure why?}

      44 :  Begin
              MatchFormPtr:=nil;
            end;
      46 :  Begin
              DayBkTotPtr:=nil;
            end;


      64,66
         :  Begin
              LastDocHed:=Inv.InvDocHed;

              // MH 05/07/2016 2016-R2 ABSEXCH-17638: B2B POR's not printing
              Display_Trans(0+(2*Ord(WParam=66)), (WParam=66)); {* Set to 0 from 2 here, as editing not allowed via a match,
                                                      Mode 66 comes from back to back wizard *}
            end;

      74  :  Begin {* Update list from posting Thread *}
               UpDatePostStatus(Current_Page);

               If (Current_Page<>3) then {* Update history as well *}
                 UpDatePostStatus(3);

               UpdateFromPost:=BOff;
               Clsdb1Btn.Enabled:=BOn;
             end;

      {$IFDEF WOP}
        80  :  ITWO1Click(ITWO1);

        81  :  ITWO1Click(BTWO1);
      {$ENDIF}

      84  :  Begin {* Update list from posting Thread *}
               UpdateFromPost:=BOn;
               Clsdb1Btn.Enabled:=BOff;
             end;

       87 :  Begin
               Add_WOR;
             end;


     {$IFDEF RET}
       100  :  ITRT1Click(BTRT1);

       101  :  ITRT1Click(ITRT1);
     {$ENDIF}

     {$IFDEF ADDNOMWIZARD} {* Used to update list from Nominal Wizard *}

        129:  If (LParam<>0) then
              Begin
                KeyI:=FullNomKey(LParam);

                Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvFolioK,KeyI);

                If (StatusOk) then
                  SendMessage(Self.Handle,WM_CustGetRec,100,0);
              end;
     {$ENDIF}


    end; {Case..}

  end;

  Inherited;
end;


Procedure TDayBk1.WMSetFocus(Var Message  :  TMessage);
Begin

  FormActivate(nil);

end;


Procedure TDayBk1.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

procedure TDayBk1.HidePanels(PageNo  :  Byte);

Var
  NomDayBk,
  WOPDayBk  :  Boolean;

Begin
  With MULCtrlO[PageNo],VisiList do
  Begin
    NomDayBk:=(DocHed In [NMT,ADJ]) and (LastHRunNo=0);
    WOPDayBk:=(DocHed In [WOR]) and (LastHRunNo=0);

    SetHidePanel(3,NomDayBk or WOPDayBk,BOff);
    SetHidePanel(5,NomDayBk,BOff);

    SetHidePanel(4,Not NomDayBk,BOn);

    // MH 25/06/2015 Exch-R1 ABSEXCH-16459: Added Order Payments Payment Status column - Hide for
    // Purchase and if Order Payments is not enabled
    If (PageNo = DbOrdersPage) Then
    Begin
      // SOR / POR Daybook
      SetHidePanel(6, (DocHed = PIN) Or (Not Syss.ssEnableOrderPayments), BOn);
    End; // If (PageNo = DbOrdersPage)
  end;
end;


procedure TDayBk1.Page1Create(Sender   : TObject;
                              NewPage  : Byte);

Var
  n           :  Byte;

  StartPanel  :  TSBSPanel;

  TKeyLen,
  TKeypath    :  Integer;

  KeyStart,
  KeyPrime,
  KeyEnd      :  Str255;

begin

   TKeyLen:=5;
   TKeyPath:=InvRNoK;

   KeyStart:='';
   KeyEnd:='';
   KeyPrime:='';
   StartPanel := nil;

   MULCtrlO[NewPage]:=TDayBkMList.Create(Self);

   // CA  08/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location). Clearing the field
   MULCtrlO[NewPage].FilteredLocation := '';

   //PR: 05/2010
   MULCtrlO[NewPage].Name := ListNames[NewPage];

   Try

     With MULCtrlO[NewPage] do
     Begin

       Try

         With VisiList do
         Begin
           Case NewPage of
             1  :  Begin
                     AddVisiRec(db2ORefPanel,db2ORefLab);
                     AddVisiRec(db2DatePanel,db2DateLab);
                     AddVisiRec(db2PrPanel,db2PrLab);
                     AddVisiRec(db2AccPanel,db2AccLab);
                     AddVisiRec(db2DescPanel,db2DescLab);
                     AddVisiRec(db2AmtPanel,db2AmtLab);
                     AddVisiRec(db2StatPanel,db2StatLab);
                     AddVisiRec(db2YRefPanel,db2YRefLab);
                     // PKR. 16/11/2015. ABSEXCH-16318. Add Transaction Owner column.
                     AddVisiRec(db2OwnerPanel,db2OwnerLab);

                     // MH 05/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
                     ColAppear^[1].ExportMetadata := emtDate;
                     ColAppear^[2].ExportMetadata := emtPeriod;
                     ColAppear^[5].ExportMetadata := emtCurrencyAmount;
                   end;
             2  :  Begin
                     AddVisiRec(db3ORefPanel,db3ORefLab);
                     AddVisiRec(db3DatePanel,db3DateLab);
                     AddVisiRec(db3PrPanel,db3PrLab);
                     AddVisiRec(db3AccPanel,db3AccLab);
                     AddVisiRec(db3DescPanel,db3DescLab);
                     AddVisiRec(db3AmtPanel,db3AmtLab);
                     AddVisiRec(db3StatPanel,db3StatLab);
                     AddVisiRec(db3YRefPanel,db3YRefLab);
                     // PKR. 16/11/2015. ABSEXCH-16318. Add Transaction Owner column.
                     AddVisiRec(db3OwnerPanel,db3OwnerLab);

                     // MH 05/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
                     ColAppear^[1].ExportMetadata := emtDate;
                     ColAppear^[1].ExportMetadata := emtForceText;  // Column contains date or period
                     ColAppear^[5].ExportMetadata := emtCurrencyAmount;
                   end;
             3  :  Begin
                     AddVisiRec(db5ORefPanel,db5ORefLab);
                     AddVisiRec(db5DatePanel,db5DateLab);
                     AddVisiRec(db5PrPanel,db5PrLab);
                     AddVisiRec(db5AccPanel,db5AccLab);
                     AddVisiRec(db5DescPanel,db5DescLab);
                     AddVisiRec(db5AmtPanel,db5AmtLab);
                     AddVisiRec(db5StatPanel,db5StatLab);
                     AddVisiRec(db5YRefPanel,db5YRefLab);
                     // PKR. 17/11/2015. ABSEXCH-16318. Add Transaction Owner column.
                     AddVisiRec(db5OwnerPanel,db5OwnerLab);

                     // MH 05/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
                     ColAppear^[1].ExportMetadata := emtDate;
                     ColAppear^[2].ExportMetadata := emtPeriod;
                     ColAppear^[5].ExportMetadata := emtCurrencyAmount;
                   end;

             {$IFDEF SOP}

               4  :  Begin
                       AddVisiRec(db4ORefPanel,db4ORefLab);
                       AddVisiRec(db4DatePanel,db4DateLab);
                       AddVisiRec(db4PrPanel,db4PrLab);
                       AddVisiRec(db4AccPanel,db4AccLab);
                       AddVisiRec(db4DescPanel,db4DescLab);
                       AddVisiRec(db4AmtPanel,db4AmtLab);
                       AddVisiRec(db4OrdPayPanel,db4OrdPayLab);
                       AddVisiRec(db4StatPanel,db4StatLab);
                       AddVisiRec(db4YRefPanel,db4YRefLab);
                       // PKR. 17/11/2015. ABSEXCH-16318. Add Transaction Owner column.
                       AddVisiRec(db4OwnerPanel,db4OwnerLab);

                       // MH 05/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
                       ColAppear^[1].ExportMetadata := emtDate;
                       ColAppear^[2].ExportMetadata := emtPeriod;
                       ColAppear^[5].ExportMetadata := emtCurrencyAmount;
                     end;

               5  :  Begin
                       AddVisiRec(db6ORefPanel,db6ORefLab);
                       AddVisiRec(db6DatePanel,db6DateLab);
                       AddVisiRec(db6PrPanel,db6PrLab);
                       AddVisiRec(db6AccPanel,db6AccLab);
                       AddVisiRec(db6DescPanel,db6DescLab);
                       AddVisiRec(db6AmtPanel,db6AmtLab);
                       AddVisiRec(db6StatPanel,db6StatLab);
                       AddVisiRec(db6YRefPanel,db6YRefLab);
                       // PKR. 17/11/2015. ABSEXCH-16318. Add Transaction Owner column.
                       AddVisiRec(db6OwnerPanel,db6OwnerLab);

                       // MH 05/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
                       ColAppear^[1].ExportMetadata := emtDate;
                       ColAppear^[2].ExportMetadata := emtPeriod;
                       ColAppear^[5].ExportMetadata := emtCurrencyAmount;
                     end;

             {$ENDIF}

           end; {Case..}


           HidePanels(NewPage);

           VisiRec:=List[0];

           StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

         end;
       except
         VisiList.Free;

       end;


       Match_VisiList(MULCtrlO[0].VisiList,VisiList);

       TabOrder := -1;
       TabStop:=BOff;
       Visible:=BOff;
       BevelOuter := bvNone;
       ParentColor := False;
       Color:=StartPanel.Color;
       // MH 25/06/2015 Exch-R1 ABSEXCH-16459: Added Order Payments Payment Status column
       If (NewPage = 4 {Orders}) Then
         // Radical - use the total number of columns to set the total number of columns!
         MUTotCols := VisiList.Count - 1
       Else
         // PKR. 16/11/2015. ABSEXCH-16318. Add Transaction Owner (User Name) column.
         MuTotCols := 8;
           
       Font:=StartPanel.Font;
       LinkOtherDisp:=Bon;

       WM_ListGetRec:=WM_CustGetRec;


       Parent:=StartPanel.Parent;

       MessHandle:=Self.Handle;

       StartLess:=BOff;

       DayBkDocHed:=DocHed;

       For n:=0 to MUTotCols do
       With ColAppear^[n] do
       Begin
         AltDefault:=BOn;

         {HBkColor:=ClHighLight;
         HTextColor:=ClHighLightText;}


         If (n=5) then
         Begin
           DispFormat:=SGFloat;
           NoDecPlaces:=2;
         end;
       end;

       If (LastHRunNo=0) then
       Begin
         DayBkListMode:=NewPage;
         Filter[1,0]:=DocCodes[DocHed][1];
       end;

       Find_Page1Coord(NewPage);

       //SSK 27/10/2016 2017-R1 ABSEXCH-17042: ReSizeAll(0) routine is called again to remove strange saved coordinates
       VisiList.ReSizeAll(0);

       ListCreate;

       UseSet4End:=BOn;

       NoUpCaseCheck:=BOn;

       Case NewPage of

         1  :  Begin
                 VisiList.LabHedPanel:=db2HedPanel;

                 Set_Buttons(db2ListBtnPanel);

                 Filter[1,0]:=#2; {* exlude any auto daybook items *}

                 Filter[1,1]:=NdxWeight; {* exlude any auto daybook items *}

                 db2SBox.HorzScrollBar.Position:=0;
                 db2SBox.VertScrollBar.Position:=0;

                 DisplayMode:=NewPage;


                 If (DocHed In SalesSplit) then
                   KeyStart:=DocCodes[SQU]
                 else
                   KeyStart:=DocCodes[PQU];


                 TKeypath:=InvOurRefK;

                 TKeyLen:=Length(KeyStart);

                 UseSet4End:=BOff;

                 NoUpCaseCheck:=BOff;

                 { CJS - 2013-08-20 - ABSEXCH-14558 - Daybook SortViews }
                 if (DocHed in SalesSplit) then
                   // MH 29/06/2015 Exch2015-R1 ABSEXCH-15991: Set Sort View Window Caption
                   MULCtrlO[NewPage].CreateSortView(svltSalesDaybookQuotes, 'Sales Quotes Daybook')
                 else if (DocHed in PurchSplit) then
                   // MH 29/06/2015 Exch2015-R1 ABSEXCH-15991: Set Sort View Window Caption
                   MULCtrlO[NewPage].CreateSortView(svltPurchaseDaybookQuotes, 'Purchase Quotes Daybook');

               end;
         2  :  Begin
                 VisiList.LabHedPanel:=db3HedPanel;

                 Set_Buttons(db3ListBtnPanel);

                 KeyStart:=FullDayBkKey(AutoRunNo,FirstAddrD,DocCodes[DocHed])+NdxWeight;

                 KeyEnd:=FullDayBkKey(AutoRunNo,MaxInt,DocCodes[DocHed])+NdxWeight;

                 db3SBox.HorzScrollBar.Position:=0;
                 db3SBox.VertScrollBar.Position:=0;

               end;
         3  :  Begin
                 VisiList.LabHedPanel:=db5HedPanel;

                 Set_Buttons(db5ListBtnPanel);

                 If (DocHed=WOR) then
                 Begin
                   KeyStart:=FullNomKey(WORPPRunNo);
                   KeyEnd:=FullDayBkKey(WORPPRunNo,MaxInt,DocCodes[DocHed]);
                   TKeyLen:=Length(KeyEnd);
                 end
                 {$IFDEF RET}
                   else
                     If (DocHed In StkRetSplit) then
                     Begin
                       KeyStart:=FullNomKey(Set_RETRunNo(DocHed,BOff,BOn));

                       KeyEnd:=FullDayBkKey(Set_RETRunNo(DocHed,BOff,BOn),MaxInt,DocCodes[DocHed]);

                       TKeyLen:=Length(KeyEnd);
                     end
                 {$ENDIF}
                 else
                   If (DocHed<>ADJ) then
                   Begin
                     Blank(KeyStart,Sizeof(KeyStart));

                     Blank(KeyPrime,Sizeof(KeyPrime));

                     {* v4.30c We have to use a prime key because a start key of run number 1, = ASCII
                     01 00 00 00, and yet a run number of 256 = ASCII
                     00 01 00 00 which failes checkey, so to get round it the db is started by looking at run number 1,
                     but the comaprison is done against 16777216 which in ASCII is
                     00 00 00 01 *}

                     KeyStart:=Strip('R',[#0],FullDayBkKey(16777216,0,DocCodes[DocHed]));

                     KeyPrime:=Strip('R',[#0],FullDayBkKey(1,0,DocCodes[DocHed]));

                     KeyEnd:=FullDayBkKey(MaxInt,MaxInt,DocCodes[DocHed]);

                     TKeyLen:=Length(KeyStart);

                     StartLess:=BOn;

                   end
                   else
                   Begin
                     {KeyStart:=Strip('R',[#0],FullDayBkKey(StkADJRunNo,FirstAddrD,DocCodes[DocHed]))};

                     If (LastHRunNo=0) then
                     Begin
                       KeyStart:=FullNomKey(StkADJRunNo);
                       KeyEnd:=FullDayBkKey(StkAdjRunNo,MaxInt,DocCodes[DocHed]);
                       TKeyLen:=Length(KeyEnd);

                     end
                     else
                     Begin
                       {$IFDEF SOP}
                         If (LastHRunNo=CommitOrdRunNo) then {* We need to display o/s orders*}
                         Begin
                           LastHRunNo:=OrdUSRunNo-(10*Ord(LastHCommP));

                         end;
                       {$ENDIF}


                       KeyStart:=FullNomKey(LastHRunNo);


                       KeyEnd:=FullDayBkKey(LastHRunNo,MaxInt,'');

                       TKeyLen:=4;
                       DayBkDocHed:=SIN;
                     end;
                   end;

                 db5SBox.HorzScrollBar.Position:=0;
                 db5SBox.VertScrollBar.Position:=0;


                 Filter[1,1]:='*QU'; {* Exclude any quotes... *}

                 {* Prime get extended *}

                 Self.UpDate;

                 If (LastHRunNo=0) then
                   DocExtRecPtr^.FDocType:=DocCodes[DocHed];

               end;

         {$IFDEF SOP}

           4
              :  Begin
                   VisiList.LabHedPanel:=db4HedPanel;

                   Set_Buttons(db4ListBtnPanel);

                   KeyStart:=FullDayBkKey(Set_OrdRunNo(PSOPDocHed,BOff,BOff),FirstAddrD,DocCodes[PSOPDocHed]);

                   db4SBox.HorzScrollBar.Position:=0;
                   db4SBox.VertScrollBar.Position:=0;

                   { CJS - 2013-08-20 - ABSEXCH-14558 - Daybook SortViews }
                   if (DocHed in SalesSplit) then
                     // MH 29/06/2015 Exch2015-R1 ABSEXCH-15991: Set Sort View Window Caption
                     MULCtrlO[NewPage].CreateSortView(svltSalesDaybookOrders, 'Sales Orders Daybook')
                   else if (DocHed in PurchSplit) then
                     // MH 29/06/2015 Exch2015-R1 ABSEXCH-15991: Set Sort View Window Caption
                     MULCtrlO[NewPage].CreateSortView(svltPurchaseDaybookOrders, 'Purchase Orders Daybook');

                 end;

           5  :  Begin
                   VisiList.LabHedPanel:=db6HedPanel;

                   Set_Buttons(db6ListBtnPanel);

                   KeyStart:=FullDayBkKey(Set_OrdRunNo(PSOPDocHed,BOff,BOn),FirstAddrD,DocCodes[PSOPDocHed]);

                   db6SBox.HorzScrollBar.Position:=0;
                   db6SBox.VertScrollBar.Position:=0;

                 end;

         {$ENDIF}


       end; {Case..}

       With VisiList do
       Begin
         LabHedPanel.Color:=IdPanel(0,BOn).Color;

         SetHedPanel(ListOfSet);
       end;

       OrigKey:=KeyStart;
       OKLen:=TKeyLen;

      if MulCtrlO[NewPage].UseDefaultSortView then
        MulCtrlO[NewPage].UseDefaultSortView := MulCtrlO[NewPage].SortView.LoadDefaultSortView;

      if MulCtrlO[NewPage].UseDefaultSortView then
        RefreshList
      else
       StartList(InvF,TKeyPath,KeyStart,KeyEnd,KeyPrime,TKeyLen,BOff);

       If (MULAddr[NewPage]<>0) then {* Attempt to re-establish position *}
       Begin
         Status:=Presrv_BTPos(InvF,Keypath,F[InvF],MULAddr[NewPage],BOn,BOn);

         If (StatusOk) then
           AddNewRow(1,BOn)
       end;

     end {With}


   Except

     MULCtrlO[NewPage].Free;
     MULCtrlO[NewPage]:=Nil;
   end;

   MDI_UpdateParentStat;

end;

procedure TDaybk1.DPageCtrl1Changing(Sender: TObject;
  var AllowChange: Boolean);

Var
  OldIndex  :  Integer;

begin

  OldIndex:=pcLivePage(DPageCtrl1);

  If (OldIndex<>0) and (MULCtrlO[OldIndex]<>nil) and (Syss.ConsvMem) then
  With MULCtrlO[OldIndex] do
  Begin
    {* Preserve Last position *}

    {* This was disabled as when on formActivate is called, for some reason the
       list being destroyed here is not being recognised as nil, and causes a GPF
       when trying to SetListFocus *}

    {MULAddr[OldIndex]:=PageKeys^[MUListBoxes[0].Row];

    Destroy;

    MULCtrlO[OldIndex]:=nil;}
  end;

  Release_PageHandle(Sender);

end;

(*
Procedure TDaybk1.SetPageHelp(NewIndex  :  Integer);

Begin
  With DPageCtrl1 do
    Case NewIndex of
      0  :  Case DocHed of
              NMT  :  ActivePage.HelpContext:=12;
              ADJ  :  ActivePage.HelpContext:=390;
              WOR  :  ActivePage.HelpContext:=1327;
              else    ActivePage.HelpContext:=1;
            end;
      1  :  Case DocHed of
              NMT   :  ;
              {WIN  :  ActivePage.HelpContext:=0; {*EN440WOP*}
              else    ActivePage.HelpContext:=1;
            end;

      2  :  Case DocHed of
              NMT  :  ActivePage.HelpContext:=307;
              else    ActivePage.HelpContext:=51;
            end;

      3  :  Case DocHed of
              NMT  :  ActivePage.HelpContext:=308;
              ADJ  :  ActivePage.HelpContext:=390;
              WOR  :  ActivePage.HelpContext:=1327; 
              else    ActivePage.HelpContext:=64;
            end;
      4  :  Begin
              ActivePage.HelpContext:=496;
            end;
      5  :  Begin
              ActivePage.HelpContext:=497;
            end;
    end; {Case..}

    db1BtnPanel.HelpContext:=DPageCtrl1.ActivePage.HelpContext;
end;
*)

Procedure TDaybk1.SetPageHelp(NewIndex  :  Integer);
Begin
  // NF: 07/04/06
  with DPageCtrl1 do
  begin
    {$IFDEF LTE}

      // IAO
      Matdb1Btn.HelpContext:=498;

      Case NewIndex of
        // Main Tab
        0  : begin
          Case DocHed of

            // Nominal Daybook
            NMT : begin
              ActivePage.HelpContext:=12;
              Matdb1Btn.HelpContext:=1667;
            end;

            // Stock Daybook
            ADJ : begin
              ActivePage.HelpContext:=390;
              Matdb1Btn.HelpContext:=1667;
            end;

            WOR : ActivePage.HelpContext:=1327;
            SIN : ActivePage.HelpContext:=1;
            PIN : ActivePage.HelpContext:=5001;
            else ActivePage.HelpContext:=1;
          end;{case}
        end;

        // Quotes Tab
        1  : begin
          Case DocHed of
            SIN  :  ActivePage.HelpContext:=1668;
            PIN  :  ActivePage.HelpContext:=6668;
            else    ActivePage.HelpContext:=1;
          end;{case}
        end;

        // Auto Tab
        2  : begin
          Case DocHed of
            NMT  :  ActivePage.HelpContext:=307;
            SIN  :  ActivePage.HelpContext:=51;
            PIN  :  ActivePage.HelpContext:=5051;
            else    ActivePage.HelpContext:=51;
          end;{case}
        end;

        // History Tab
        3  : begin
          Case DocHed of
            // Nominal Daybook
            NMT : begin
              ActivePage.HelpContext:=1669;
              Matdb1Btn.HelpContext:=1667;
            end;

            // Stock Daybook / Posted Stock Transactions History
            ADJ : begin
              Matdb1Btn.HelpContext:=1667;

              // NF: 24/07/06
              // ActivePage.HelpContext := 1670
              if LastHRunNo = 0 then
              begin
                // Stock Daybook
                ActivePage.HelpContext := 1670
              end else
              begin
                // Posted Stock Transactions History
                ActivePage.HelpContext := 2083;
              end;{if}
            end;

            WOR : ActivePage.HelpContext:=1327;
            SIN : ActivePage.HelpContext:=64;
            PIN : ActivePage.HelpContext:=5064;
            else ActivePage.HelpContext:=64;
          end;{case}
        end;

        // Order Tab
        4  :  Begin
          Case DocHed of

            // Sales Daybook
            SIN  :  ActivePage.HelpContext:=496;

            // Purchase Daybook
            PIN  : begin
              ActivePage.HelpContext := 5496;
              Recdb1Btn.HelpContext := 1700; // NF: 08/05/06 Fix. New Topic.
            end;

            else    ActivePage.HelpContext:=496;
          end;{case}
        end;

        // Order History Tab
        5  :  Begin
          Case DocHed of
            SIN  :  ActivePage.HelpContext:=497;
            PIN  :  ActivePage.HelpContext:=5497;
            else    ActivePage.HelpContext:=497;
          end;{case}
        end;

      end;{Case}
    {$ELSE}

      // Exchequer
      Case NewIndex of

        // Main Tab
        0  : begin
          Case DocHed of
            NMT  :  ActivePage.HelpContext:=12;
            ADJ  :  ActivePage.HelpContext:=390;
            WOR  :  ActivePage.HelpContext:=1327;
            else    ActivePage.HelpContext:=1;
          end;{case}
        end;

        // Quotes Tab
        1  : begin
          Case DocHed of
            NMT   :  ;
            {WIN  :  ActivePage.HelpContext:=0; {*EN440WOP*}
            else    ActivePage.HelpContext:=1;
          end;{case}
        end;

        // Auto Tab
        2  : begin
          Case DocHed of
            NMT  :  ActivePage.HelpContext:=307;
            else    ActivePage.HelpContext:=51;
          end;{case}
        end;

        // History Tab
        3  : begin
          Case DocHed of
            //NMT  :  ActivePage.HelpContext:=308;
            NMT  :  ActivePage.HelpContext:=180;
            ADJ  :  ActivePage.HelpContext:=390;
            WOR  :  ActivePage.HelpContext:=1327;
            else    ActivePage.HelpContext:=64;
          end;{case}
        end;

        // Order Tab
        4  :  begin
          ActivePage.HelpContext:=496;

          Case DocHed of
            // Purchase Daybook
            PIN  : Recdb1Btn.HelpContext := 1700; // NF: 08/05/06 Fix. New Topic.
          end;{case}
        end;

        // Order History Tab
        5  :  begin
          ActivePage.HelpContext:=497;
        end;
      end; {Case..}
    {$ENDIF}
  end;{with}

  // NF: 21/06/06 Fix
  db1BtnPanel.HelpContext:=DPageCtrl1.ActivePage.HelpContext;
  DPageCtrl1.HelpContext:=DPageCtrl1.ActivePage.HelpContext;
  HelpContext:=DPageCtrl1.ActivePage.HelpContext;
end;

procedure TDaybk1.DPageCtrl1Change(Sender: TObject);
var
  NewIndex: Integer;
  HideFilt: Boolean;

  //HV 08/03/2017 2017-R1 ABSEXCH-17695: Crash in Daybooks, Find menu items have been moved to PopUp1 at design time
  procedure SetFindMenuVis(HState: Boolean);
  var
    i: Integer;
  begin
    for i:=0 to PopupFindBtn.Items.Count-1 do
    begin
      if PopupFindBtn.Items[i].Tag in [0, 15,16,17] then // Quotes Tab menu items
        PopupFindBtn.Items[i].Visible := Bon
      else
        PopupFindBtn.Items[i].Visible := HState;
    end;
    for i:=0 to mnuFindOptions.Count-1 do
    begin
      if mnuFindOptions.Items[i].Tag in [0, 15,16,17] then // Quotes Tab menu items
        mnuFindOptions.Items[i].Visible := Bon
      else
        mnuFindOptions.Items[i].Visible := HState;
    end;
  end;
begin
  NewIndex := pcLivePage(DPageCtrl1);
  Case NewIndex of
    1..5 :  begin
              if (MULCtrlO[NewIndex] = nil) then
                Page1Create(Sender, NewIndex);
            end;
  end; {Case..}

  SetPageHelp(NewIndex);

  if (MULCtrlO[NewIndex] <> nil) and (ListActive) then
  with MULCtrlO[NewIndex] do
  begin
    {If (Not (NewIndex In [3,5])) then}
    //Begin
    if (MUListBox1.Row <> 0) then
      PageUpDn(0,BOn)
    else
      InitPage;
    //end;
    SetListFocus;
  end;

  {$IFDEF WOP}
    if (NewIndex = 0) and (DocHed In WOPSplit) then
    begin
      DeleteSubMenu(Print1);
      CreateSubMenu(PopUpMenu6,Print1);
    end
    else
    begin
      if (DocHed In WOPSplit) then
        DeleteSubMenu(Print1);
    end;
  {$ENDIF}

  {$IFDEF SOP}
    HideFilt := (NewIndex<>1);
  {$ELSE}
    HideFilt := BOff;
  {$ENDIF}

  //PR: 07/06/2010 The SOP ifdef here was preventing the menus from being set correctly for non-SPOP versions,
  //               leading to crashes on the quotes tab.
  {.$IFDEF SOP}
    if (NewIndex In [1,4]) then
    begin
      if (PSOPDocHed In SalesSplit) and (NewIndex=4) then
      begin
        DeleteSubMenu(Print1);
        CreateSubMenu(PopUpMenu6,Print1);
      end;
      //HV 08/03/2017 2017-R1 ABSEXCH-17695: Crash in Daybooks, Find menu items have been moved to PopUp1 at design time
      SetCheckedMenuItems(mnuFindOptions,-1,LastBTag[NewIndex]);
      SetFindMenuVis(HideFilt);
    end //if (NewIndex In [1,4]) then
    else
    begin
      if (PSOPDocHed In SalesSplit) and (Not (DocHed In WOPSplit)) then
        DeleteSubMenu(Print1);
    end;
    BuildHoldMenu(NewIndex);
  {.$ENDIF}

  // SSK 28/10/2017 ABSEXCH-19398: added this to fill the structure with transaction data as soon as the page chages
  With MULCtrlO[newindex] do
    RefreshLine(MUListBoxes[newindex].Row,BOff);

 
  BuildPostMenu(NewIndex);
  PrimeButtons(NewIndex,BOff);
  
  // CA  10/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location) : Setting the Main Caption
  SetMainCaption;
end;



procedure TDaybk1.HistModeScan(NewRunNo    :  LongInt;
                               DCPMode     :  Boolean);


Var
  KeyStart,
  KeyEnd  :  Str255;

begin
  If (MULCtrlO[3]<>nil) and (ListActive) then
  With MULCtrlO[3] do
  Begin
    LastHRunNo:=NewRunNo;

    {$IFDEF SOP}
      LastHCommP:=DCPMode;
    {$ENDIF}


    {$IFDEF SOP}
      If (LastHRunNo=CommitOrdRunNo) then {* We need to display o/s orders*}
      Begin
        LastHRunNo:=OrdUSRunNo-(10*Ord(LastHCommP));

      end;
    {$ENDIF}

    Self.Caption:='Posted Transactions for Run No. '+Form_Int(LastHRunNo,0);

    // CA  09/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location). Setting the Main Caption
    MainCaption := Self.Caption;

    KeyStart:=FullNomKey(LastHRunNo);
    KeyEnd:=FullDayBkKey(LastHRunNo,MaxInt,'');

    StartList(ScanFilenum,KeyPath,KeyStart,KeyEnd,'',KeyLen,BOff);


  end;

end;

Procedure TDayBk1.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With DPageCtrl1 do
  Begin
    Case NewPage of

      0  :  ActivePage:=MainPage;
      1  :  ActivePage:=QuotesPage;
      2  :  ActivePage:=AutoPage;
      3  :  ActivePage:=HistoryPage;

      {$IFDEF SOP}
        4  :  ActivePage:=OrdersPage;
        5  :  ActivePage:=OrdHistoryPage;
      {$ENDIF}

    end; {Case..}

    DPageCtrl1Change(ActivePage);


  end; {With..}
end; {Proc..}

procedure TDaybk1.Clsdb1BtnClick(Sender: TObject);
begin
  If (Not MULCtrlO[Current_Page].InListFind) then
    Close;
end;

procedure TDaybk1.db1OrefPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  BarPos :  Integer;
  PanRSized
         :  Boolean;



begin
  BarPos:=0;

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    Case Current_Page of
      0  :  BarPos:=db1SBox.HorzScrollBar.Position;
      1  :  BarPos:=db2SBox.HorzScrollBar.Position;
      2  :  BarPos:=db3SBox.HorzScrollBar.Position;
      3  :  BarPos:=db4SBox.HorzScrollBar.Position;
      4  :  BarPos:=db5SBox.HorzScrollBar.Position;
      5  :  BarPos:=db6SBox.HorzScrollBar.Position;
    end;

      If (PanRsized) then
        MULCtrlO[Current_Page].ResizeAllCols(MULCtrlO[Current_Page].VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO[Current_Page].VisiList.MovingLab or PanRSized);
  end;

end;

procedure TDayBk1.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin
    LastDocHed:=Inv.InvDocHed;

    // SSK 30/11/2017 ABSEXCH-19398: Implements anonymisation behaviour for Transaction
    Copy1.Enabled := not (GDPROn and (trim(Inv.OurRef) <> '') and Inv.thAnonymised);
    Convert1.Enabled := Copy1.Enabled;
    PopUp(X,Y);

  end;


end;


procedure TDayBk1.SetFormProperties;
Begin
  //PR: 05/11/2010 Changed to use new Window Position System
  if Assigned(FSettings) and Assigned(MULCtrlO[Current_Page]) then
    if FSettings.Edit(MULCtrlO[Current_Page], MULCtrlO[Current_Page]) = mrOK then
      NeedCUpdate := True;
end;

procedure TDayBk1.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TDayBk1.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;


procedure TDayBk1.PopupMenu1Popup(Sender: TObject);
var
  n,
  lBtnIndex: Integer;
begin
  StoreCoordFlg.Checked:=StoreCoord;

  Custom1.Caption:=CustdbBtn1.Caption;
  Custom2.Caption:=CustdbBtn2.Caption;
  // 17/01/2013 PKR ABSEXCH-13449
  // Custom buttons 3..6 now available
  Custom3.Caption:=CustdbBtn3.Caption;
  Custom4.Caption:=CustdbBtn4.Caption;
  Custom5.Caption:=CustdbBtn5.Caption;
  Custom6.Caption:=CustdbBtn6.Caption;

  With CustBtnList[Current_Page] do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);
    //HV 08/03/2017 2017-R1 ABSEXCH-17695: Crash in Daybooks, Find menu items have been moved to PopUp1 at design time
    lBtnIndex := 0;
    with PopUpMenu1 do
    begin
      for n:=0 to Pred(Items.Count) do
      begin
        if Items[n] <> mnuFindOptions then
        begin
          SetMenuFBtn(Items[n], lBtnIndex);
          Inc(lBtnIndex)
        end;
      end;
    end;

    mnuFindOptions.Visible := False;
    if Finddb1Btn.Visible then
    begin
      //For Order and Quote Tab
      mnuFindOptions.Visible := Current_Page In [1,4];
      mnuFindOptions.Enabled := (Finddb1Btn.Enabled and mnuFindOptions.Enabled);
      mnuFindOptions.HelpContext := Finddb1Btn.HelpContext;
      Find1.Visible := not mnuFindOptions.Visible;
    end;

    { CJS - 2013-08-20 - ABSEXCH-14558 - Daybook SortViews }
    if not MulCtrlO[Current_Page].SortViewEnabled then
    begin
      RefreshView1.Visible := False;
      CloseView1.Visible := False;
      N14.Visible := False;
    end
    else
    begin
      RefreshView1.Visible := True;
      CloseView1.Visible := True;
      N14.Visible := True;
    end;

  end; {With..}

  PopUpMenu2PopUp(Sender);
  // CA  13/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location) : BuildFilterMenu called
  BuildFilterMenu(Current_Page);          
end;




procedure TDaybk1.db1ORefLabMouseDown(Sender: TObject;
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

procedure TDaybk1.db1ORefLabMouseMove(Sender: TObject; Shift: TShiftState;
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

{$IFDEF DBD}

Procedure TDayBk1.DebugProc;

Begin


end;


{$ENDIF}



Procedure TDayBk1.RecepWiz;

Begin
  Set_alSales((DocHed In SalesSplit),BOff);


  With TAllocateWiz.Create(Self) do
  Try

  except
    Free;

  end; {try..}

end;


procedure TDaybk1.AddButtonExecute(Sender: TObject; bDoNomWizard : boolean);

Var
  Mode  :  Byte;
  UseRecepWiz,
  OkShow,
  Ok2Exe:  Boolean;

  //PR: 15/11/2017 ABSEXCH-19451
  AllowPostedEdit : Boolean;
  DocStatus : Byte;
begin
  Mode:=0;
  OkShow:=BOn;  Ok2Exe:=BOn; UseRecepWiz:=BOff;

  //PR: 30/01/2018 ABSEXCH-19702 Initialise AllowPostedEdit
  AllowPostedEdit := False;

  If ((Sender Is TButton) or (Sender Is TMenuItem)) and (Not MULCtrlO[Current_Page].InListFind)
     and ((MULCtrlO[Current_Page].ValidLine) or (Sender=Adddb1Btn) or (Sender=Add1)  ) then
  Begin
    if (not MULCtrlO[Current_Page].IsDataFrameWork) then
      With MULCtrlO[Current_Page] do
        RefreshLine(MUListBoxes[0].Row,BOff);

    If (Sender=Adddb1Btn) or (Sender=Editdb1Btn) or (Sender=Edit1) or (Sender=Add1) then
      Mode:=1+Ord(Sender=Editdb1Btn)+Ord(Sender=Edit1);

    //PR: 15/11/2017 ABSEXCH-19451
    if Mode = 2 then
    begin
      AllowPostedEdit := RestrictedEditOnly(Inv);
    end;

    // MH 14/11/2014 Order Payments: Prevent editing of Order Payments Payments and Refunds
    If (DocHed In SalesSplit) And (Mode = 2 {Edit}) And (Inv.thOrderPaymentElement In OrderPayment_PaymentAndRefundSet) Then
    Begin
      // Change to View mode - after discussion with QA it was decided not to have an annoying popup message
      Mode := 0;
    End; // If (DocHed In SalesSplit) And (Mode = 2 {Edit})

    {$IFDEF CU}
      If (Mode In [0,2]) then
      Begin
        ExLocal.AssignFromGlobal(InvF);
        Ok2Exe:=ExecuteCustBtn(2000,(150*Ord(Mode=2))+(155*Ord(Mode=0)),ExLocal);
        LastDocHed:=Inv.InvDocHed;
      end
      else begin
{        If (Mode = 1) and (DocHed In NomSplit) then
        Begin
          ExLocal.AssignFromGlobal(InvF);
          Ok2Exe:=ExecuteCustBtn(2000,157,ExLocal);
          LastDocHed:=Inv.InvDocHed;
        end;}

        {$IFDEF ADDNOMWIZARD}
          if bDoNomWizard then
          begin
            // Check password (user permission) to see whether or not to use the Add Nom Wizard
            bDoNomWizard := not ChkAllowed_In(572);
          end;{if}

          If (Mode = 1) and (DocHed In NomSplit) and bDoNomWizard and (Current_Page=0) then
          Begin
            // Show Add Nom Wizard
            ShowAddNomWizard(self.Handle);

            // Do not open standard dialog
            Ok2Exe := FALSE;
          end; {if}
        {$ENDIF}
      end;
    {$ENDIF}

    If (Ok2Exe) then
    Begin

      Case Mode of

       {$IFDEF INV}
         1  :  If (DocHed In SalesSplit+PurchSplit) then
               Begin
                 Case Current_Page of

                   0,2  :  Begin
                             OkShow:=AddDayBook(Self,(DocHed In SalesSplit),LastDocHed,0+(2*Ord(Current_Page=2)));

                             UseRecepWiz:=(Current_Page=0) and (LastDocHed In RecieptSet) and (PChkAllowed_In((410*Ord(DocHed In SalesSplit))+(413*Ord(DocHed In PurchSplit))));
                           end;

                   1    :  LastDocHed:=DocSplit[(DocHed In SalesSplit),8];

                   4    :  If (DocHed In SalesSplit) then
                             LastDocHed:=SOR
                           else
                             LastDocHed:=POR;
                 end;{Case..}
               end
               else
               Begin
                 LastDocHed:=DocHed;

                 {$IFDEF WOP}
                    If (DocHed in WOPSplit) then
                    Begin
                      OkShow:=BOff;
                      SendMessage(Self.Handle,WM_FormCloseMsg,87,0);

                    end;
                 {$ENDIF}
               end;
       {$ELSE}
         1  :  LastDocHed:=DocHed;
       {$ENDIF}

        2  :  Begin
                LastDocHed:=Inv.InvDocHed;
                OKShow:=MULCtrlO[Current_Page].ValidLine;
              end;
      end; {Case..}

      If (OkShow) then
      Begin
        If (UseRecepWiz) then
          RecepWiz
        else
          Display_Trans(Mode, False, AllowPostedEdit);

      end;
    end;
  end;

end;


procedure TDaybk1.Pickdb1BtnClick(Sender: TObject);

Var
  Mode   :  Byte;
  Ok2Exe :  Boolean;
begin
  If ((Sender Is TButton) or (Sender Is TMenuItem)) and (Not MULCtrlO[Current_Page].InListFind)  and (MULCtrlO[Current_Page].ValidLine) then
  Begin
    With MULCtrlO[Current_Page] do
      RefreshLine(MUListBoxes[0].Row,BOff);


    {$IFDEF CU}
      ExLocal.AssignFromGlobal(InvF);

      If (Sender<>Notedb1Btn) and (Sender<>Notes1) then
        // Pick/Receive
        Ok2Exe:=ExecuteCustBtn(2000,152,ExLocal)
      Else
        // Notes
        Ok2Exe:=ExecuteCustBtn(2000,161,ExLocal);
    {$ELSE}
      Ok2Exe := True;
    {$ENDIF}

    If (Ok2Exe) then
    Begin

      LastDocHed:=Inv.InvDocHed;

      If (Sender=Notedb1Btn) or (Sender=Notes1) then
        Mode:=7
      else
        Mode:=9;

      If (LastDocHed in OrderSet) or (Mode=7) then
        Display_Trans(Mode);
    end;
  end;

end;


procedure TDaybk1.PopupMenu2Popup(Sender: TObject);
begin
  Back1.Visible:=(LastDocHed In [SOR,WOR]);

  Reverse1.Visible:=(Not (LastDocHed In PSOPSet+StkRetSplit));

  Copy1.Items[Pred(Copy1.Count)].Visible:=Back1.Visible;
  Copy1.Items[1].Visible:=Reverse1.Visible;
end;


procedure TDaybk1.CopyDb1BtnClick(Sender: TObject);
Var
  ListPoint : TPoint;
begin
  With MULCtrlO[Current_Page] do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);
      LastDocHed:=Inv.InvDocHed;

      ListPoint := TWinControl(Sender).ClientToScreen(Point(1,1));
      PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
    end;
  end;{with..}
end;

function TDaybk1.GetSupplier(Var SCode  :  String;
                             Var CCMode :  Integer)  :  Boolean;

Var
  InpOk,
  FoundOk,
  AutoPickSOR
             :  Boolean;
  FoundCode  :  Str20;

Begin

  FoundOk:=BOff;  AutoPickSOR:=BOff;

  FoundCode:='';

  Repeat

    InpOk:=InputQuery('Back to Back Order','Please enter the supplier code for this purchase order',SCode);

    If (InpOk) then
      FoundOk:=GetCust(Self,SCode,FoundCode,BOff,0);

  Until (FoundOk) or (Not InpOk);

  Result:=(FoundOk and InpOk);

  If (Result) then
  Begin
    AutoPickSOR:=(MessageDlg('Auto pick Sales Order when Purchase Order received?',mtConfirmation,[mbYes,mbNo],0)=mrYes);

  end;

  SCode:=FoundCode;

  CCMode:=CCMode+(2*Ord(AutoPickSOR));

end;

procedure TDaybk1.Copy2Click(Sender: TObject);
Const
  HookPoints : Array [1..3] Of Byte = (160,162,163);
Var
  Ok2Cont  :  Boolean;
  SCode    :  String;
  CCMode   :  Integer;
  Continue : Boolean;
begin
  SCode:='';

  If (Sender Is TMenuItem) and (Not TransActive[0]) Then
    With TMenuItem(Sender) do
    Begin
      CCMode:=Tag;

      {$IFDEF CU}
        // Transaction Security Hooks - Copy/Reverse/Back2Back
        If EnableCustBtns(2000, HookPoints[CCMode]) Then
        Begin
          ExLocal.AssignFromGlobal(InvF);
          Continue := ExecuteCustBtn(2000, HookPoints[CCMode], ExLocal);
        End // If EnableCustBtns(2000, HookPoints[CCMode])
        Else
          Continue := True;
      {$ELSE}
        Continue := True;
      {$ENDIF}

      If Continue Then
      Begin
        If (CCMode=3) then
        Begin
          {$IFDEF SOP}
            Run_B2BWizard(Inv,Self);

            Ok2Cont:=BOff;
            {Ok2Cont:=GetSupplier(SCode,CCMode);}
          {$ELSE}
            Ok2Cont:=GetSupplier(SCode,CCMode);
          {$ENDIF}
        End // If (CCMode=3)
        Else
          {$IFDEF SOP}
            // MH 12/11/2014 Order Payments: Added confirmation checks for Order Payment Transactions being Reversed
            If (CCMode = 2) Then
              // Reverse
              Ok2Cont := OrdPay_OKToReverse(Inv)
            Else
              // Copy
              Ok2Cont:=BOn;
          {$ELSE}
            Ok2Cont:=BOn;
          {$ENDIF SOP}

        If Ok2Cont then
        Begin
          ContraCopy_Doc(Inv.FolioNum,CCMode,SCode);
          frDaybkGrid.RefreshGrid;

          LastDocHed:=Inv.InvDocHed;

          If (CCMode In [3,5]) and (LastDocHed=POR) then
            Display_Trans(2)
          else
            If (Assigned(MULCtrlO[Current_Page])) then
              MULCtrlO[Current_Page].PageUpDn(0,BOn);
        End; // If Ok2Cont
      End; // If Continue
    End; // With TMenuItem(Sender)


end;


Function TDaybk1.GetTagNo(Var TNo  :  Byte;
                              Mode :  Byte)  :  Boolean;

Var
  ISCtrl         :  TSetTagNo;
  mrResult       :  TModalResult;

Begin
  Result:=BOff;

  ISCtrl:=TSetTagNo.Create(Self);

  try

    With ISCtrl do
    Begin
      PAValue:=TNo;

      mrResult:=InitIS(TNo,Mode);

      If (mrResult=mrOk) then
      Begin
        TNo:=PAValue;

        Result:=BOn;
      end;
    end;

  finally

    ISCtrl.Free;

  end; {Try..}


end;


  procedure TDaybk1.TagTrans(Sender: TObject);

  Var
    KeyS   :  Str255;
    LOk,
    LLocked:  Boolean;

    TagNo  :  Byte;

  begin
    
      With MULCtrlO[Current_Page],ExLocal do
      Begin
        TagNo:=LInv.Tagged;

        If (TagNo=0) then
          TagNo:=1
        else
          TagNo:=0;

        {$IFDEF STK}

          {$B-}
          If (ValidLine) and (Not InListFind) and (GetTagNo(TagNo,0)) then

          {$B+}
          Begin
            RefreshLine(MUListBoxes[0].Row,BOff);

            AssignFromGLobal(InvF);

            LGetRecAddr(InvF);

            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,InvF,BOff,LLocked);

            If (LOk) and (LLocked) then
            Begin
              Set_OrderTag(InvF,Keypath,LastRecAddr[InvF],TagNo);

              Set_Row(MUListBoxes[0].Row);
            end;
          end; {If ok..}

        {$ENDIF}
        
      end;{with..}
  end;


procedure TDaybk1.Tagdb1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;
  Ok2Exe     :  Boolean;


begin
  Ok2Exe:=BOn;


  With MULCtrlO[Current_Page] do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);
      LastDocHed:=Inv.InvDocHed;

      {$IFDEF CU}
        ExLocal.AssignFromGlobal(InvF);
        Ok2Exe:=ExecuteCustBtn(2000,154,ExLocal);
      {$ENDIF}


       With TWinControl(Sender) do
       Begin
         ListPoint.X:=1;
         ListPoint.Y:=1;

         ListPoint:=ClientToScreen(ListPoint);

       end;


       If (Ok2Exe) then
       Begin
         If (PChkAllowed_In(ChkPWord(Current_Page,00,00,00,00,425,426,-255,-255,-255))) then
           PopUpMenu7.PopUp(ListPoint.X,ListPoint.Y)
         else
           TagTrans(Sender);
       end;
    end;
  end;{with..}
end;


procedure TDaybk1.Tag2Click(Sender: TObject);
begin
  {$IFDEF STK}
    TagTrans(Sender);
  {$ENDIF}
end;

procedure TDaybk1.Untag1Click(Sender: TObject);

Var
  TagNo  :  Byte;
begin
  TagNo:=0;
  {$IFDEF STK}
    {$IFDEF POST}
       With MULCtrlO[Current_Page] do
         If GetTagNo(TagNo,1) then
           AddUnTagSOP2Thread(Self,KeyRef,KeyLen,InvF,Keypath,TagNo);
    {$ENDIF}
  {$ENDIF}
end;


procedure TDaybk1.Holddb1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  With MULCtrlO[Current_Page] do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);
      LastDocHed:=Inv.InvDocHed;


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


procedure TDaybk1.HQ1Click(Sender: TObject);

Var
  AuthBy : Str10;
  KeyS : Str255;
  HoldMode, NotesMode : Byte;
  Ok2Cont,Authorised : Boolean;
  auditNote : TAuditNote;
begin
  Ok2Cont:=BOn;
  Authorised:=BOff;
  AuthBy:='';
  NotesMode:=232;

  With MULCtrlO[Current_Page],ExLocal do
  Begin
    If (ValidLine) and (Sender is TMenuItem) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);

      AssignFromGLobal(InvF);
      LGetRecAddr(InvF);

      // MH 02/02/2016 2016-R1 ABSEXCH-16488: Add new transaction security hook points on Hold for Query / Cancel Hold
      {$IFDEF CU}
      If (TMenuItem(Sender).Tag In [1 {Hold for Query}, 5 {Cancel Hold}]) Then
      Begin
        Ok2Cont := ExecuteCustBtn(2000, IfThen(TMenuItem(Sender).Tag = 1, 164, 165), ExLocal);  // Transaction Security - Hold for Query / Cancel Hold
      End // If (TMenuItem(Sender).Tag In [1 {Hold for Query}, 5 {Cancel Hold}])
      Else
      {$ENDIF}
        Ok2Cont := True;

      If Ok2Cont Then
      Begin
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

      { CJS 2013-03-11 - ABSEXCH-14112 - Hold for Query on LIVE transactions }
      // For LIVE transactions, do not allow the Hold For Query flag to be cleared
      // unless the LIVE status is Approved or Authorised.
      // CJS 2013-08-02 - ABSEXCH-14408 - Added password check
      if (TMenuItem(Sender).Tag = 5) and SQLUtils.UsingSQL and (WebExtEProcurementOn and ChkAllowed_In(600)) then
      begin
        if (LInv.InvDocHed in [POR, PIN, PDN, PCR]) and (LInv.ExtSource >= 200) then
        begin
          if (GetHoldType(LInv.HoldFlg) = HoldQ) and not (LInv.thWorkflowState in [3, 5]) then
          begin
            MessageDlg('The Hold for Query status cannot be removed because ' +
                       'the transaction has not been approved or authorised ' +
                       'in the eProcurement module of Exchequer LIVE.',
                       mtError, [mbOk], 0);
            OK2Cont := False;
          end;
        end;
      end;
      End; // If Ok2Cont

      If (Ok2Cont) then
      Begin
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,InvF,BOff,GlobLocked);

        If (Ok) and (GlobLocked) then
        Begin

          With TMenuItem(Sender) do
            Case Tag of

              // 1 = Hold for Query
              // 2 = Hold Until Allocated
              // 3 = Authorise
              0..3  :  HoldMode:=Tag+200;

              // Cancel Hold
              5     :  HoldMode:=HoldDel;

              // 4 = Stop Posting Here
              // 6 = Remove Suspend
              4,6   :  HoldMode:=Tag+217;

              // 7 = Hold for Stock
              // 8 = Hold for All Stock
              7,8   :  HoldMode:=Tag+197;

              // 10 = Hold for Credit
              10    :  HoldMode:=HoldSC;

              else     HoldMode:=Tag+200;

            end; {Case..}

          If (Authorised) and (Not (LInv.InvDocHed In WOPSplit)) then
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

          {$IFDEF INV}
            If (HoldMode=HoldDel) and (Inv.InvNetVal=0.0) and (Not (Inv.InvDocHed In [NMT,ADJ]+WOPSplit)) then {* v5.60 Just in case it is a corrupted incomplete transaction re calc *}
              Def_InvCalc;
          {$ENDIF}

          SetHold(HoldMode,InvF,Keypath,BOn,Inv);

          {$IFDEF STK}  {* Generate Stock deduct lines from list based *}
            {$IFDEF SOP}
              If (Inv.HoldFlg=HoldC) and (Not (LInv.InvDocHed In WOPSplit)) then
                UpDate_OrdDel(Inv,BOff,BOn,Self);
            {$ENDIF}
          {$ENDIF}

          UnLockMLock(InvF,LastRecAddr[InvF]);

          Set_Row(MUListBoxes[0].Row);
        end;

        //TW 27/10/2011 Add Edit audit note if update is successful.
        //PR: 23/11/2011 Moved create from start of function and added Try/Finally

        if(status = 0) then
        begin
          auditNote := TAuditNote.Create(EntryRec^.Login, @F[PwrdF]);
          Try
            auditNote.AddNote(anTransaction, Inv.FolioNum, anEdit);
          Finally
            auditNote.Free;
          End;
        end;
      end;
    end; {If ok..}
  end;{with..}
end;




procedure TDaybk1.Matdb1BtnClick(Sender: TObject);

Var
  Ok2Exe :  Boolean;

begin
  Ok2Exe:=BOn;


  If (MULCtrlO[Current_Page]<>nil)  then
  With MULCtrlO[Current_Page],EXLocal do
  Begin
    If (ValidLine) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);

      {$IFDEF CU}
        ExLocal.AssignFromGlobal(InvF);
        Ok2Exe:=ExecuteCustBtn(2000,153,ExLocal);
      {$ENDIF}

      If (Ok2Exe) then
        Display_Match(BOn,((Inv.RemitNo<>'') or (Inv.OrdMatch) or (Inv.InvDocHed=ADJ)));

    end;
  end;
end;



procedure TDayBk1.Display_DTotals;


Var
  DTotForm  :  TDBkTotals;

  WasNew     :  Boolean;

Begin

  WasNew:=BOff;


  If (DayBkTotPtr=nil) then
  Begin
    WasNew:=BOn;

    DTMode:=1+Ord(Current_Page>=4);
    DTType:=DocHed;

    DTotForm:=TDBkTotals.Create(Self);

    DayBkTotPtr:=DTotForm;

  end
  else
    DTotForm:=DayBkTotPtr;

  Try

   If (MULCtrlO[Current_Page]<>nil) then
     With MULCtrlO[Current_Page],DTotForm do
     Begin

       WindowState:=wsNormal;


       If (WasNew) then
       Begin

         SetKey(KeyRef,KeyLen);

         CalcTotals;
       end
       else
         Show;

     end; {With..}


  except

   DayBkTotPtr:=nil;

   DTotForm.Free;
   DTotForm:=nil;

  end; {try..}


end;

//PL 09/02/2017 2017-R1 ABSEXCH-13159 :  added ability to post Single Transaction on Daybook posting
//Added this function to check whether the user has permision to post the day book or not.
function TDaybk1.UserPerCheck() : Boolean;
begin
  Result := False;
  if Inv.InvDocHed in [SIN..SBT] then
  begin
    Result := ChkAllowed_In(8);
  end
  else
  if Inv.InvDocHed in [PIN..PBT] then
  begin
    Result :=  ChkAllowed_In(17);
  end
  else
  if Inv.InvDocHed in [NMT] then
  begin
    Result := chkallowed_in(29);
  end;

end;

{Added this function to check whether the selected transactio is on hold or
  is dated in a future period or is dated in a previous period
(dependant on system setting) or User Permissions (dependant of password setup)}
function TDaybk1.ValidTrans() : Boolean;
var
  lRes : Boolean;
begin
  lRes := not OnHold(Inv.HoldFlg);
  lRes := lRes and (((Pr2Fig(Inv.AcYr,Inv.AcPr)<=Pr2Fig(GetLocalPr(0).CYr,GetLocalPr(0).CPr)) and (Not Syss.PrevPrOff))
            or ((Pr2Fig(Inv.AcYr,Inv.AcPr)=Pr2Fig(GetLocalPr(0).CYr,GetLocalPr(0).CPr)) and (Syss.PrevPrOff)));
  lRes := lRes and UserPerCheck ;
                                  

  Result := lRes;
end;

//Added this function to decide whether the options for single transaction posting should be visible or not.
function TDaybk1.SingleDaybkVisible()  :  Boolean;
begin
  Result := (Current_Page = 0) and Assigned(MULCtrlO[Current_Page]) and (MULCtrlO[Current_Page].ValidLine) and
             //SS 24/02/2017 2017-R1:ABSEXCH-18399:SBT and PBT transctions should be excluded from single daybook posting.
            // MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
            SQLUtils.UsingSQLAlternateFuncs and (SQLReportsConfiguration.SQLPostingStatus [SQLUtils.GetCompanyCode(SetDrive)] = psPassed) and (not(Inv.InvDocHed in BatchSet))
            //PL 17/03/2017 2017-R1 ABSEXCH-18494 Single Transaction posting option incorrectly showing on Works Order Daybook.
             and ((Inv.InvDocHed in SalesSplit) or (Inv.InvDocHed in PurchSplit) or (Inv.InvDocHed in NomSplit));

  //PR: 21/06/2017 ABSEXCH-18831 Check if any hook points will be triggered during posting. If they
  //will then we can't use SQL posting and hence can't do single transaction posting.           
  Result := Result and not PostingHookEnabled;
end;


//PL 09/02/2017 2017-R1 ABSEXCH-13159 :  added ability to post Single Transaction on Daybook posting
procedure TDaybk1.UpdateSubMenuItemCaption(Const Source  :  TPopUpMenu;
                                         RefCount:  LongInt;
                                   Var   Dest    :  TMenuItem;
                                         Extended: Boolean = False);
Var
  n        :  Integer;
begin
  For n:=0 to RefCount do
  Begin
    if (Dest.Items[n].Name) = 'PostTransactionOnlyX' then
    begin
      if (frDaybkGrid.vMain.Controller.SelectedRowCount >= 2) then
        Dest.Items[n].Caption := 'Post Selected only'
      else
        Dest.Items[n].Caption := 'Post '+ Inv.OurRef+' only';
    end
    else
    if (Dest.Items[n].Name) = 'PostTransactionWithReportX' then
    begin
      if (frDaybkGrid.vMain.Controller.SelectedRowCount >= 2) then
        Dest.Items[n].Caption := 'Post Selected with Posting Report'
      else
        Dest.Items[n].Caption := 'Post '+ Inv.OurRef+' with Posting Report';
    end;

  end;
end;


procedure TDaybk1.Postdb1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;
  lValidTrans:  Boolean;

begin
  If (DocHed In StkAdjSplit) or (Current_Page=2) then
  Begin
    PD1Click(Sender);
  end
  else
  If (Sender is TButton) then
  Begin

    GetCursorPos(ListPoint);
    With ListPoint do
    Begin
      X:=X-50;
      Y:=Y-15;
    end;   
    PopUpMenu5.PopUp(ListPoint.X,ListPoint.Y);
  end
  //PL 09/02/2017 2017-R1 ABSEXCH-13159 :  added ability to post Single Transaction on Daybook posting
  else
  if Sender is TMenuItem then
  begin
    if SingleDaybkVisible then
    begin
      PostTransactionOnly.Visible := True ;
      PostTransactionWithReport.Visible := True ;

      lValidTrans := ValidTrans;

      PostTransactionOnly.Enabled := lValidTrans ;
      PostTransactionWithReport.Enabled := lValidTrans ;

      UpdateSubMenuItemCaption(PopUpMenu5,PostMCount,Post1);
    end
    else
    begin
      PostTransactionOnly.Visible := False ;
      PostTransactionWithReport.Visible := False ;
    end;

    UpdateSubMenu(PopUpMenu5,PostMCount,Post1,True);

  end;
end;


procedure TDaybk1.PrintDoc(Sender: TObject;  LP  :  LongInt);

{$IFDEF Frm}
  begin
    With MulCtrlO[Current_Page],ExLocal Do
    {$B-}  {*b571.001. Its coming from a B2B, so do not refresh yet until after print *}
    If ((DocHed In SalesSplit) and (Inv.InvDocHed In [POR])) or (ValidLine) then
    {$B+}
    Begin
      //AP:31/07/2017:ABSEXCH-18764 : When Sort View applied, Print options are not picked up from Trader Records
      if (SortViewEnabled) then
        PrintInvImage := Inv;

      If ((DocHed In SalesSplit) and (Inv.InvDocHed In SalesSplit)) or ((DocHed In PurchSplit) and (Inv.InvDocHed In PurchSplit)) or (LP=0) then
        GetSelRec(BOff);

      // HV  15/03/2016 2016-R2 ABSEXCH-15705: If Sort view applied to Main Daybook then Print Dialog shows incorrect details after adding new Transaction
      If (UseAddInv) or (SortViewEnabled) then {v5.52. We have a filter on the list in place so the invoice we have just added is not on the list, repalce with memory copy}
        Inv:=PrintInvImage;

      AssignFromGlobal(InvF);

      With LInv do
        Control_DefProcess(DEFDEFMode[InvDocHed],
                           IdetailF,IdFolioK,
                           FullNomKey(FolioNum),ExLocal,BOn);

    End; { With }
{$ELSE}
  Begin
{$ENDIF}
end;


procedure TDaybk1.Printdb1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;
  Ok2Exe     :  Boolean;
  Odisabled  :  Boolean;
Begin
  Ok2Exe:=BOn;
  //RJ 17/02/2016 2016-R1 ABSEXCH-17035: Check user Permission  before print actions.
  if not (Printdb1Btn.Visible)  then
  begin
    Showmessage('You are not authorised to print the transaction');
    Exit;
  end;
  
  {$IFDEF CU}
    If (EnableCustBtns(2000,151)) then
    Begin
      With MulCtrlO[Current_Page] Do
        If ((DocHed In SalesSplit) and (Inv.InvDocHed In SalesSplit)) or ((DocHed In PurchSplit) and (Inv.InvDocHed In PurchSplit)) then
          GetSelRec(BOff);
      ExLocal.AssignFromGlobal(InvF);

      Ok2Exe:=ExecuteCustBtn(2000,151,ExLocal);

    end;
  {$ENDIF}


  If (Ok2Exe) then
  Begin


      If {(Not (Sender is TMenuItem)) or (Current_Page<>4)} (Current_Page=4) or (Current_Page<>4) then
      Begin
        If ((Current_Page=4) and (Assigned(Sender)) and (PSOPDocHed In SalesSplit) and (Sender<>EntCustom1)) or
           ((Current_Page=0) and  (Assigned(Sender)) and (DocHed In WOPSplit) and (Sender<>EntCustom1)) then
        Begin
          With TWinControl(Sender) do
          Begin
            ListPoint.X:=1;
            ListPoint.Y:=1;

            ListPoint:=ClientToScreen(ListPoint);

          end;

          PopUpMenu6.PopUp(ListPoint.X,ListPoint.Y);
        end
        else
          PrintDoc(Sender,Ord(Sender=EntCustom1));

      end
      else
        PrintDoc(Sender,Ord(Sender=EntCustom1));
  end;
end;

procedure TDaybk1.PrintDoc1Click(Sender: TObject);
begin
  PrintDoc(Sender,0);
end;


procedure TDaybk1.GenPick1Click(Sender: TObject);
begin
  {$IFDEF WOP}
    If (DocHed In WOPSplit) then
      Start_WORPickRun(DocHed,Owner)

  {$ENDIF}

  {$IFDEF SOP}
    {$IFDEF WOP}
      else
    {$ENDIF}
      Start_PickRun(PSOPDocHed,Owner);
  {$ELSE}
    {$IFDEF WOP}
      ;
    {$ENDIF}
  {$ENDIF}
end;

procedure TDaybk1.Conv_Quote(ConvMode  :  Byte);

Var
  mrRet  :  Word;

  Ok2Conv:  Boolean;

  //PR: 20/05/2014 ABSEXCH-2763
  Ok2Print : Boolean;

Begin
  Ok2Conv:=BOn;

  With MULCtrlO[Current_Page],ExLocal do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin
      mrRet:=MessageDlg('Please confirm you wish to convert this transaction.',mtConfirmation,[mbYes,mbNo],0);



      If (mrRet=mrYes) then

      Begin
        {Sanjay Sonani 08/02/2016 2016-R1
         ABSEXCH-15747:Access Violation when hitting ESC before Print Setup
                       window is presented.}
        fDisableFormClose := True;
        try
        GetSelRec(Boff);

        AssignFromGlobal(InvF);

        {$IFDEF CU}

        Ok2Conv:=ValidExitHook(2000,83+Ord(ConvMode=14),ExLocal);

        {$ENDIF}

        {$B-}

        //ABSEXCH-15747:Access Violation when hitting ESC before Print Setup window is presented.
        If (Ok2Conv) and  Quo_To_Inv(InvF,Keypath,ConvMode, @ExLocal) and (not fDoingClose) then 
        {$B+}
        Begin

          AssignFromGlobal(InvF);

          {$IFDEF CU}

            Ok2Conv:=ValidExitHook(2000,85,ExLocal);

          {$ENDIF}


          {$IFDEF Frm}
          //PR: 20/05/2014 ABSEXCH-2763 Add check for hook point 2000/151 (Print Transaction)
          {$IFDEF CU}
            If (EnableCustBtns(2000,151)) then
              Ok2Print := ExecuteCustBtn(2000,151,ExLocal)
            else
              Ok2Print := True;

            if Ok2Print then
          {$ENDIF}
            With LInv do
              Control_DefProcess(DEFDEFMode[InvDocHed],
                                 IdetailF,IdFolioK,
                                 FullNomKey(FolioNum),ExLocal,BOn);
          {$ENDIF}

          PageUpDn(0,BOn);

          If (PageKeys^[0]=0) then {* Update screen as we have lost them all!*}
            InitPage;
        end;
        finally
          fDisableFormClose := False;
        end;


      end;
    end; {If val;id line etc..}
  end; {With..}
end;

procedure TDaybk1.Convdb1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  {$IFDEF SOP}

    With TWinControl(Sender) do
    Begin
      ListPoint.X:=1;
      ListPoint.Y:=1;

      ListPoint:=ClientToScreen(ListPoint);

    end;

    PopUpMenu4.PopUp(ListPoint.X,ListPoint.Y);

  {$ELSE}

    If (Found_DocEditNow(Inv.FolioNum)=0) then
      Conv_Quote(6)
    else
      Warn_DocEditNow;

  {$ENDIF}
end;


procedure TDaybk1.Convert1Click(Sender: TObject);
begin
  {$IFNDEF SOP}
     Convdb1BtnClick(Sender);
  {$ENDIF}
end;

procedure TDaybk1.QuoI1Click(Sender: TObject);
begin
  {$IFDEF SOP}
    If (Found_DocEditNow(Inv.FolioNum)=0) then
      Conv_Quote(TMenuItem(Sender).Tag)
    else
      Warn_DocEditNow;

  {$ENDIF}
end;


procedure TDayBk1.DeleteDoc;


Var
  MbRet  :  Word;
  KeyS   :  Str255;

  Keypath:  Integer;

  LAddr  :  LongInt;


Begin
  With MULCtrlO[Current_Page] do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin

      MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Transaction',
                         mtConfirmation,[mbYes,mbNo],0);



      {$IFDEF CU}
        {$B-}

        ExLocal.AssignFromGlobal(InvF);

        If (MbRet=MrYes) and (ValidExitHook(2000,100,ExLocal)) then

      {$B+}

      {$ENDIF}

      With ExLocal do
      Begin
        GetSelRec(BOff);

        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,Keypath,InvF,BOff,GlobLocked,LAddr);

        If (Ok) and (GlobLocked) then
        Begin
          Status:=Delete_Rec(F[InvF],InvF,Keypath);

          Report_BError(InvF,Status);

          If (StatusOk) then {* Delete any dependant links etc *}
          Begin
            {$IFDEF STK}

              {$IFDEF Inv}

                  Delete_StockLinks(FullIdkey(Inv.FolioNum,StkLineNo),IdetailF,
                                    Sizeof(Inv.FolioNum),IdFolioK,BOn,Inv,0);

              {$ENDIF}

            {$ELSE}

              DeleteLinks(FullIdkey(Inv.FolioNum,StkLineNo),IdetailF,Sizeof(Inv.FolioNum),IdFolioK,BOff);

            {$ENDIF}



            {$IFDEF C_On}

              Delete_Notes(NoteDCode,FullNomKey(Inv.FolioNum)); {* Auto Delete Notes *}

            {$ENDIF}

            {$IFDEF LTR}
              DeleteLetters (LetterDocCode,FullNomKey(Inv.FolioNum));

            {$ENDIF}

            PageUpDn(0,BOn);

            If (PageKeys^[0]=0) then {* Update screen as we have lost them all!*}
              InitPage

          end;
        end;
      end;
    end; {If confirm delete..}
  end; {If ok..}
end; {PRoc..}




procedure TDaybk1.Remdb1BtnClick(Sender: TObject);
begin
  DeleteDoc;
end;

procedure TDaybk1.BuildPostMenu(NewPage  :  Integer);

Var
  ActVis1,
  ActVis2,
  ActVis3,
  ActVis4,
  ActVis5  :  Boolean;

begin
  If (Not InBuildPostMenu) then
  Begin
    InBuildPostMenu:=BOn;
    DeleteIdxSubMenu(Post1,PostMCount);

    If (Not (DocHed In StkAdjSplit)) and  (Not (Current_Page In [1..3,5])) then
    Begin
      CreateIdxSubMenu(PopUpMenu5,PostMCount,Post1,'X',BOff);

      ActVis1:=(NewPage=4);
      ActVis2:=((NewPage=4) and (DOCHed In SalesSplit));
      ActVis3:=((NewPage=4) and (DOCHed In PurchSplit));
      ActVis4:=((NewPage=0) and (DOCHed In WOPSplit));

      ActVis5:=((NewPage=0) and (DOCHed In StkRetSplit));


      GLPP1.Visible:=(NewPage=0) and (Not (DocHed In WOPSplit+StkRetSplit));
      DPP1.Visible:=GLPP1.Visible;
      DO1.Visible:=BoChkAllowed_In(ActVis1,183+(5*Ord(DocHed In PurchSplit)));
      DPO1.Visible:=BoChkAllowed_In(ActVis2,184);
      DRO1.Visible:=BoChkAllowed_In(ActVis3,189);
      DRO2.Visible:=BoChkAllowed_In(ActVis3,189);

      ITD1.Visible:=BoChkAllowed_In(ActVis1,185+(5*Ord(DocHed In PurchSplit)));

      IAD1.Visible:=BoChkAllowed_In(ActVis2,186);
      IGD1.Visible:=BoChkAllowed_In(ActVis3,191);

      {PD1.Visible:=DPP1.Visible; Altered v4.31.005 so preposting reports always available.}

      PD1.Visible:=BoChkAllowed_In(DPP1.Visible,ChkPWord(NewPage,08,17,29,122,161,171,-255,-254,-254));

      SDT1.Visible:=BoChkAllowed_In((NewPage In [0,4]) and (Not (DocHed In NomSplit+WOPSplit+StkRetSplit )),187+(5*Ord(DocHed In PurchSplit)));
      RDR1.Visible:=ActVis2;
      RIR1.Visible:=ActVis2;
      N6.Visible:=(NewPage<>2) and ((PD1.Visible) or (SDT1.Visible));
      N7.Visible:=N6.Visible or ActVis2;

      ITWO1.Visible:=BoChkAllowed_In(ActVis4 and (Not Is_StdWOP),381);
      IAWO1.Visible:=BoChkAllowed_In(ActVis4 and (Not Is_StdWOP),383);

      BTWO1.Visible:=BoChkAllowed_In(ActVis4,384);
      BAWO1.Visible:=BoChkAllowed_In(ActVis4,386);

      ITRT1.Visible:=BoChkAllowed_In(ActVis5,ChkPWord(NewPage,-254,-254,-254,-254,-254,-254,-254,523,537));
      IART1.Visible:=BoChkAllowed_In(ActVis5,ChkPWord(NewPage,-254,-254,-254,-254,-254,-254,-254,525,539));

      BTRT1.Visible:=BoChkAllowed_In(ActVis5,-254);
      BART1.Visible:=BoChkAllowed_In(ActVis5,-254);

      RPRet1.Visible:=BoChkAllowed_In(ActVis5 and (DocHed In StkRetSalesSplit),526);


      N12.Visible:=((ITWO1.Visible) or (IAWO1.Visible)) and
                   ((BTWO1.Visible) or (BAWO1.Visible)) or
                   ((ITRT1.Visible) or (IART1.Visible)) and
                   ((BTRT1.Visible) or (BART1.Visible));

      RPWI1.Visible:=BoChkAllowed_In(ActVis4 and (Not Is_StdWOP),387);

      RPWB1.Visible:=BoChkAllowed_In(ActVis4,388);

      N13.Visible:=(RPWI1.Visible or RPWB1.Visible or RPRet1.Visible);

      UpdateSubMenu(PopUpMenu5,PostMCount,Post1);
    end;

    InBuildPostMenu:=BOff;
  end;
end;


{procedure TDaybk1.PopupMenu5Popup(Sender: TObject);

Var
  ActVis1,
  ActVis2,
  ActVis3  :  Boolean;

begin
  ActVis1:=(Current_Page=4);
  ActVis2:=((Current_Page=4) and (DOCHed In SalesSplit));
  ActVis3:=((Current_Page=4) and (DOCHed In PurchSplit));

  GLPP1.Visible:=(Current_Page=0);
  DPP1.Visible:=GLPP1.Visible;
  DO1.Visible:=BoChkAllowed_In(ActVis1,183+(5*Ord(DocHed In PurchSplit)));
  DPO1.Visible:=BoChkAllowed_In(ActVis2,184);
  DRO1.Visible:=BoChkAllowed_In(ActVis3,189);

  ITD1.Visible:=BoChkAllowed_In(ActVis1,185+(5*Ord(DocHed In PurchSplit)));

  IAD1.Visible:=BoChkAllowed_In(ActVis2,186);
  IGD1.Visible:=BoChkAllowed_In(ActVis3,191);
  PD1.Visible:=DPP1.Visible;
  SDT1.Visible:=BoChkAllowed_In((Current_Page In [0,4]),187+(5*Ord(DocHed In PurchSplit)));
  RDR1.Visible:=ActVis2;
  RIR1.Visible:=ActVis2;
  N6.Visible:=(Current_Page<>2);
  N7.Visible:=N6.Visible;


end;}

procedure TDaybk1.SDT1Click(Sender: TObject);
begin
  Display_DTotals;
end;

procedure TDaybk1.PD1Click(Sender: TObject);
begin
  {$IFDEF POST}
    PrePostInput(Self,SetPostMode(DocHed)+(20*Ord(Current_Page=2)),BOn,nil);

    {AddPost2Thread(SetPostMode(DocHed)+(20*Ord(Current_Page=2)),Self,BOn,Nil,Nil);}
  {$ENDIF}
end;


procedure TDaybk1.GLPP1Click(Sender: TObject);
var
  ReportParameters: PostRepParam;
begin
  {$IFDEF Rp}
    {$IFDEF POST}
      If (Sender is TMenuItem) then
      Begin
        If (Sender=GLPP1) or  (TMenuItem(Sender).Name='GLPP1X') then
          {$IFDEF EXSQL}
          if SQLUtils.UsingSQLAlternateFuncs and SQLReportsConfiguration.UseSQLGLPrePosting then
            SQLReport_PrintGLPrePosting(0, SetPostMode(DocHed), Owner, ReportParameters)
          else
          {$ENDIF}
            AddPostRep2Thread(2,0,SetPostMode(DocHed),nil,BOn,Owner)
        else
          AddDocRep2Thread(5,SetPostMode(DocHed),nil,Owner);
      end;
    {$ENDIF}
  {$ENDIF}
end;


{$IFDEF GF}

  procedure TDaybk1.FindDbItem(Sender: TObject);

  Var
    ReturnCtrl  :  TReturnCtrlRec;

  begin

    If (Not MULCtrlO[Current_Page].InListFind)  then
    Begin

      With ReturnCtrl,MessageReturn do
      Begin
        FillChar(ReturnCtrl,Sizeof(ReturnCtrl),0);

        WParam:=3000;
        LParam:=Current_Page;
        Msg:=WM_CustGetRec;
        DisplayxParent:=BOn;
        ShowOnly:=BOn;
        Pass2Parent:=BOn;

        //PR: 04/12/2013 ABSEXCH-14824
        Ctrl_GlobalFind(Self, ReturnCtrl, tabFindDocument);

      end;
    end; {If in list find..}

  end;

{$ENDIF}

procedure TDaybk1.Finddb1BtnClick(Sender: TObject);
var
  ListPoint: TPoint;
begin
  if (not (Current_Page In [1,4])) then
  begin
    {$IFDEF GF}
      FinddbItem(Sender);
    {$ENDIF}
  end
  else
  if (Sender is TButton) then
  begin
    GetCursorPos(ListPoint);
    with ListPoint do
    begin
      X:=X-50;
      Y:=Y-15;
    end;
    //HV 08/03/2017 2017-R1 ABSEXCH-17695: Crash in Daybooks, Find menu items have been moved to PopUp1 at design time
    SetCheckedPopUpMenu(PopupFindBtn, -1, LastBTag[Current_Page]);
    PopupFindBtn.PopUp(ListPoint.X,ListPoint.Y);
  end;
end;


  Function TDaybk1.FindAccCode(Var  KeyS  :  Str255)  :  Boolean;


  Var
    InpOk,
    FoundOk  :  Boolean;

    FoundCode: Str20;

    SCode    : String;

  Begin

    SCode:=KeyS;

    FoundOk:=BOff;

    FoundCode:='';

    Repeat

      InpOk:=InputQuery('Filter by Account Code','Please enter the account code you wish to filter by',SCode);

      If (InpOk) then
        FoundOk:=GetCust(Self,SCode,FoundCode,(PSOPDocHed In SalesSplit),0);

    Until (FoundOk) or (Not InpOk);

    Result:=FoundOk;

    KeyS:=FoundCode;

  end;



procedure TDaybk1.Orders1Click(Sender: TObject);

Var
  BTagNo,
  PageNo  :  Integer;
  mbRet   :  Word;

begin
  //HV 10/03/2016 2016-R2 ABSEXCH-16889: Sort view + find on orders daybook results in duplicating first transaction (display issue)
  LockWindowUpdate(Self.Handle);
  try
   If (Sender is TMenuItem) then
     With TMenuItem(Sender) do
     Begin
       BTagNo:=Tag;
       PageNo:=Current_Page;

       Case BTagNo of
         1..16  :  If (Assigned(MulCtrlO[PageNo])) then
                     With MulCtrlO[PageNo] do
                     Begin
                       FilterMode:=BTagNo;

                       {$B-}
                         If (BTagNo<>15) or (FindAccCode(KeyFind)) then
                         Begin
                           If (Not ListStillBusy) then
                             SetNewLIndex
                           else
                           Begin
                             Set_BackThreadMVisible(BOn);

                             mbRet:=MessageDlg('The list is still busy.'+#13+#13+
                                    'Do you wish to interrupt the list so that you can apply a new find?',mtConfirmation,[mbYes,mbNo],0);

                             If (mBRet=mrYes) then
                             Begin
                               IRQSearch:=BOn;

                               ShowMessage('Please wait a few seconds, then try find again.');
                             end;

                             Set_BackThreadMVisible(BOff);
                           end;

                         end;
                           {InitPage;}

                       {$B+}

                     end;

         {$IFDEF GF}
           17     :  FindDbItem(Sender);

         {$ENDIF}


       end; {Case..}

      SetCheckedMenuItems(mnuFindOptions,-1,BTagNo);

       LastBTag[PageNo]:=BTagNo;
	   //HV 18/03/2016 2016-R2 ABSEXCH-16889: Sort view + find on orders daybook results in duplicating first transaction (display issue)     
       if MulCtrlO[PageNo].SortViewEnabled then 
         RefreshList; 
     end; {With..}
  finally
     LockWindowUpdate(0); //HV 10/03/2016 2016-R2 ABSEXCH-16889: Sort view + find on orders daybook results in duplicating first transaction (display issue)
  end; 
end;


procedure TDaybk1.DO1Click(Sender: TObject);

Var
  DATFlg,
  DFlg,
  PORRFlg,
  TFlg,
  SetPOR2PIN,
  FoundOk  :  Boolean;

  PTagNo   :  Byte;

  mbResult :  Word;

begin
  FoundOk:=BOff;  SetPOR2PIN:=BOff; PTagNo:=1;

  With TMenuItem(Sender) do
  Begin
    DFlg:=((Name='DO1') or (Name='DO1X'));
    TFlg:=((Name='ITD1') or (Name='ITD1X'));
    SetPOR2PIN:=((Name='DRO2') or (Name='DRO2X'));
    PORRFlg:=((Name='DRO1') or (Name='DRO1X')) or SetPOR2PIN;

    DATFlg:=DFlg or TFlg;

  end;

  {$IFDEF SOP}
     If (DATFlg) and (Assigned(MULCtrlO[Current_Page])) then
     With MULCtrlO[Current_Page] do
     Begin
       If (ValidLine) then
         FoundOk:=((DFlg) and (Inv.InvDocHed In OrderSet)) or ((TFlg) and (Inv.InvDocHed In DeliverSet));


     end
     else
       FoundOk:=BOn;

     If (DatFlg or (not TFlg)) and (FoundOk) and (PORRFlg) then
     Begin

       {mbResult:=MessageDlg('Do you wish to convert Purchase Orders (POR) directly to a Purchase Invoices (PIN)?',mtConfirmation,[mbYes,mbNo,mbCancel],0);

       SetPOR2PIN:=(mbResult=mrYes);

       FoundOk:=(mbResult<>mrCancel);}


     end;

     With TMenuItem(Sender) do
     If (Tag=2) and ((Name='IGD1') or (Name='IGD1X')) then
     Begin
       FoundOk:=GetTagNo(PTagNo,0);

     end;


     If (FoundOk) then
     Begin
       //PR: 23/05/2017 ABSEXCH-18683 v2017 R1 Try to get a process lock
       if GetProcessLock(plInvoiceDeliveries) then
       Start_SOPRun(PSOPDocHed,TMenuItem(Sender).Tag,PTagNo,DATFlg,SetPOR2PIN, Self);

     end;
  {$ENDIF}
end;


procedure TDaybk1.ITWO1Click(Sender: TObject);
Var
  FoundOk  :  Boolean;

begin
  FoundOk:=BOff;

  {$IFDEF WOP}
     If (TMenuItem(Sender).Tag In [80,81]) and (Assigned(MULCtrlO[Current_Page])) then
     With MULCtrlO[Current_Page] do
     Begin
       FoundOk:=ValidLine;
     end
     else
       FoundOk:=BOn;

     If (FoundOk) then
       Start_WOPRun(DocHed,TMenuItem(Sender).Tag-Ord(Is_StdWOP),(TMenuItem(Sender).Tag In [80,81]),Self);
  {$ENDIF}
end;


procedure TDaybk1.IAWO1Click(Sender: TObject);

begin

  {$IFDEF WOP}
     If (TMenuItem(Sender).Tag In [80,81,90,91]) then
       Start_WOPRun(DocHed,TMenuItem(Sender).Tag-Ord(Is_StdWOP),BOff,Self);
  {$ENDIF}
end;

procedure TDaybk1.RPRet1Click(Sender: TObject);

{$IFDEF RET}
  Var
   DRetWizRec  :  tRetWizRec;

  Begin
    Blank(DRetWizRec,Sizeof(DRetWizRec));

    If (TMenuItem(Sender).Tag In [102]) then
      Start_RetRun(DocHed,TMenuItem(Sender).Tag,BOff,DRetWizRec,Self);

{$ELSE}
  Begin
{$ENDIF}

end;


Procedure TDaybk1.Add_WOR;

Var
  LocalInv  :  InvRec;
  LocalId   :  Idetail;
Begin
  {$IFDEF WOP}
    Blank(LocalInv,SizeOf(LocalInv));
    Blank(LocalId,SizeOf(LocalId));

    Run_WORWizard(LocalInv,LocalId,0,Self);

  {$ENDIF}
end;


procedure TDaybk1.ITRT1Click(Sender: TObject);
Var
  FoundOk  :  Boolean;

begin
  FoundOk:=BOff;

  {$IFDEF RET}
     If (TMenuItem(Sender).Tag In [100,101,102]) and (Assigned(MULCtrlO[Current_Page])) then
     With MULCtrlO[Current_Page] do
     Begin
       FoundOk:=ValidLine;
     end
     else
       FoundOk:=BOn;

     If (FoundOk) then
       Case  TMenuItem(Sender).Tag of
         {100  :  Start_RETRun(DocHed,TMenuItem(Sender).Tag,(TMenuItem(Sender).Tag In [100,101]),Self);}
         100,101,102
               :  Begin
                   Set_RetWiz(Inv,Id,DocHed,'',1+(Ord(TMenuItem(Sender).Tag=102)),0);

                   with TRetWizard.Create(Self) do
                   Begin
                     Show;

                     If (TMenuItem(Sender).Tag=100) then
                     Begin
                       A1PActionCB.ItemIndex:=2;
                       A1PActionCB.OnChange(nil);
                     end;
                   end;
                 end;
       end; {Case..}
  {$ENDIF}
end;

procedure TDaybk1.BART1Click(Sender: TObject);

{$IFDEF RET}
  Var
    DRetWizRec  :  tRetWizRec;
  Begin
     Blank(DRetWizRec,Sizeof(DRetWizRec));

     If (TMenuItem(Sender).Tag In [100,101]) then
       Start_RETRun(DocHed,TMenuItem(Sender).Tag,BOff,DRetWizRec,Self);

{$ELSE}
  Begin

{$ENDIF}
end;

procedure TDaybk1.Returndb1BtnClick(Sender: TObject);
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
    If (ValidLine) and (Inv.InvDocHed In StkRetGenSplit-[SOR,POR]) then
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


procedure TDaybk1.CustdbBtn1Click(Sender: TObject);

Var
  PageNo  :  Integer;
  HandlerId : LongInt;
  // 23/01/2013 PKR ABSEXCH-13449
  customButtonNumber : integer;
begin
  PageNo:=Current_Page;

  {$IFDEF CU}
    If (Assigned(MULCtrlO[PageNo])) then
    With MULCtrlO[PageNo],ExLocal do
    Begin
      If (ValidLine) then
      Begin
        LInv:=Inv;

        If (LCust.CustCode<>Inv.CustCode) then
          LGetMainRecPos(CustF,Inv.CustCode);

        // 23/01/2013 PKR ABSEXCH-13449
        // Get the event ID for the button
        customButtonNumber := -1;
        if Sender is TSBSButton then
          customButtonNumber := (Sender as TSBSButton).Tag;
        if Sender is TMenuItem then
          customButtonNumber := (Sender as TMenuItem).Tag;

        // Get the button event ID and fire the event
        custBtnHandler.CustomButtonClick(formPurpose,
                                         PageNo,
                                         rsAny,
                                         customButtonNumber,
                                         ExLocal);
          
(*          
        // MH 17/08/2012 v7.0 ABSEXCH-12600: Added support for Custom Buttons on Nom Daybook - rewrote mechanism for executing the buttons
        //                                   to make it maintainable and easy to understand
        HandlerId := -1;
        If (Sender=CustdbBtn1) Or (Sender=Custom1) Then
        Begin
          // Custom Button 1 -------------------------------------------------------------------------
          If (DocHed In SalesSplit) Then
            //  10-15  Custom Button 1 on Sales daybook event - 16-19  Reserved for Custom Button 1 on future tabs 6-9
            HandlerId := 10 + PageNo
          Else If (DocHed In PurchSplit) Then
            // 110-115  Custom Button 1 on Purchase daybook event - 116-119  Reserved for Custom Button 1 on future tabs 6-9
            HandlerId := 110 + PageNo
          Else If (DocHed In NOMSplit) Then
            // 301-306  Custom Button 1 on Nominal Daybooks (Tabs 1-6) - 307-310  Reserved for Custom Button 1 on future tabs 6-9
            HandlerId := 301 + PageNo;
        End // If (Sender=CustdbBtn1) Or (Sender=Custom1)
        Else If (Sender=CustdbBtn2) Or (Sender=Custom2) Then
        Begin
          // Custom Button 2 -------------------------------------------------------------------------
          If (DocHed In SalesSplit) Then
            //  20-25  Custom Button 2 on Sales daybook event - 26-29  Reserved for Custom Button 2 on future tabs 6-9
            HandlerId := 20 + PageNo
          Else If (DocHed In PurchSplit) Then
            // 120-125  Custom Button 2 on Purchase daybook event - 126-129  Reserved for Custom Button 2 on future tabs 6-9
            HandlerId := 120 + PageNo
          Else If (DocHed In NOMSplit) Then
            // 311-316  Custom Button 2 on Nominal Daybooks (Tabs 1-6) - 317-320  Reserved for Custom Button 2 on future tabs 6-9
            HandlerId := 311 + PageNo;
        End; // If (Sender=CustdbBtn2) Or (Sender=Custom2)

        If (HandlerId <> -1) Then
          ExecuteCustBtn(2000, HandlerId, ExLocal);

//        ExecuteCustBtn(2000,((10+PageNo+(100*Ord(DocHed In PurchSplit)))*Ord((Sender=CustdbBtn1) or (Sender=Custom1)))+
//                      ((20+PageNo+(100*Ord(DocHed In PurchSplit)))*Ord((Sender=CustdbBtn2) or (Sender=Custom2))), ExLocal);
*)
      end;
    end; {With..}
  {$ENDIF}
end;

procedure TDaybk1.Adddb1BtnClick(Sender: TObject);
begin
  AddButtonExecute(Sender, TRUE);
end;

// CA  10/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location) : Setting the Caption
Procedure TDaybk1.SetMainCaption;
Begin
   if MULCtrlO[Current_Page].FilteredLocation <> '' Then
      Caption := MainCaption+' - Override Location : '  + MULCtrlO[Current_Page].FilteredLocation
   else
      Caption := MainCaption;
End;

// CA  08/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location)
procedure TDaybk1.Filterdb1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;
  PageNo: Integer;
begin
  PageNo := Current_Page;
  If (Not MULCtrlO[Current_Page].InListFind) then
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    With TWinControl(Sender) do
      ListPoint:=ClientToScreen(ListPoint);

    {
      CJS - 2013-08-29 - MRD2.6 - Transaction Originator - amend the menu
      items so that we only show the relevant ones.

      The FilteredLocation menu items only appear on the Main, Quotes, and
      Orders tabs of the Purchase Daybook, and the Clear Filtered Location
      option only appears if a Location Filter is active.

      The FilteredOriginator menu items only appear on the Orders and Order
      History tabs of the Purchase and Sales Daybooks, and the Clear Originator
      option only appears if an Originator Filter is active.
    }

    // For non-Purchase Daybooks, always hide the Location Filter options
    if (DocHed <> PIN) then
    begin
      FList1.Visible := False;
      ClearFilterItem1.Visible := False;
    end
    // Otherwise, show the menu items on the Main, Quotes, and Orders tabs
    else if (PageNo in [0, 1, 4]) then
    begin
      FList1.Visible := True;
      if MULCtrlO[Current_Page].FilteredLocation = '' Then
         ClearFilterItem1.Visible := False
      else
         ClearFilterItem1.Visible := True;
    end;

    if (PageNo in [4, 5]) then
    begin
      // If the Filter Location menu items are visible as well, show the
      // separator
      FilterSeparator1.Visible := FList1.Visible;

      FilterbyTransactionOriginator1.Visible := True;

      // Only display the 'Clear' menu option if an Originator filter is set.
      if MULCtrlO[Current_Page].FilteredOriginator = '' then
        ClearTransactionOriginator1.Visible := False
      else
        ClearTransactionOriginator1.Visible := True;

      // Hide the Filter Location menu items if we are on the Order History tab
      if (PageNo = 5) and (FList1.Visible) then
      begin
        FList1.Visible := False;
        ClearFilterItem1.Visible := False;
      end;
    end
    else
    begin
      // Hide the Filter Originator menu items if we are not on the Orders or
      // Order History tabs
      FilterSeparator1.Visible := False;
      FilterbyTransactionOriginator1.Visible := False;
      ClearTransactionOriginator1.Visible := False;
    end;

    // CJS 2013-10-02 - MRD1.1.23 - Sales Daybook - Customer/Consumer filter
    if Syss.ssConsumersEnabled then
    begin
      // For non-Sales Daybooks, always hide the Customer/Consumer filter options
      if (DocHed <> SIN) then
      begin
        FilterSeparator2.Visible := False;
        FilterbyCustomer1.Visible := False;
        FilterbyConsumer1.Visible := False;
        ClearCustomerConsumerFilter1.Visible := False;
      end
      else
      begin
        // If either of the other filter options are visible, show the separator
        if (FList1.Visible) or (FilterbyTransactionOriginator1.Visible) then
          FilterSeparator2.Visible := True;
        // Only display the 'Clear' menu option a Customer/Consumer filter is set.
        ClearCustomerConsumerFilter1.Visible := MULCtrlO[Current_Page].FilteredTrader<> '';
        FilterByCustomer1.Checked := MULCtrlO[Current_Page].FilteredTrader = 'C';
        FilterByConsumer1.Checked := MULCtrlO[Current_Page].FilteredTrader = 'U';
      end;
    end
    else
    begin
      FilterSeparator2.Visible := False;
      FilterbyCustomer1.Visible := False;
      FilterbyConsumer1.Visible := False;
      ClearCustomerConsumerFilter1.Visible := False;
    end;

    PopUpMenu9.PopUp(ListPoint.X,ListPoint.Y);
  end;

end;

// CA  08/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location)
procedure TDaybk1.FList1Click(Sender: TObject);
Var
  InpOk,
  FoundOk  :  Boolean;
  OCode    :  String;
  SCode    :  Str10;
Begin

  SCode := MULCtrlO[Current_Page].FilteredLocation;  // Getting the current page filter
  OCode := SCode;
  FoundOK := False;
  Repeat

    InpOk:=InputQuery('Override Location Filter','Enter the Override Location you wish to filter by.',OCode);

    {$IFDEF SOP}
      If (InpOk) then
        If (Not EmptyKey(OCode,LocKeyLen)) then
          FoundOk:=GetMLoc(Self,OCode,SCode,'',0)
        else
        Begin
          SCode:='';
          FoundOk:=BOn;
        end;
    {$ENDIF}

  Until (FoundOk) or (Not InpOk);

  If (FoundOk) and (Assigned(MULCtrlO[Current_Page])) and (Assigned(Sender)) then
  With MULCtrlO[Current_Page] do
  Begin
    // Here I initialise the FilteredLocation with the user requirment
    FilteredLocation  := SCode;

    // Main tab caption set with new filter
    SetMainCaption;

    // This ensures all the appropriate records are displayed
    InitPage;
  end;
end;

// CA  10/05/2013 v7.0.4  ABSEXCH-14273: Purchase daybook filter (override location). Clearing the page filter
procedure TDaybk1.ClearFilterItem1Click(Sender: TObject);
begin
  With MULCtrlO[Current_Page] do
  Begin
    // FilterLocation is cleared
    FilteredLocation  := '';

    // Main Tab caption is set correctly
    SetMainCaption;

    // This ensures all the records are displayed and top record is highlighted
    InitPage;
  end;
end;

{ CJS - 2013-08-20 - ABSEXCH-14558 - Daybook SortViews }
procedure TDayBk1.ApplySortView;
{
  Creates the Sort View and re-displays the list, either when the Sort View is
  first applied, or when it is refreshed (from the menu option).
}
var
  PageNo: Integer;
  SortView: TBaseSortView;
begin
  PageNo := Current_Page;
  SortView := MulCtrlO[PageNo].SortView;

  case SortView.ListType of
    // Main tab -- scan by Run Number to locate all unposted records (i.e. those
    // with a run number of zero) for the relevant Sales or Purchase type
    svltSalesDaybookMain, svltPurchaseDaybookMain:
      begin
        SortView.HostListSearchKey := Copy(FullDayBkKey(0, MaxInt, DocCodes[DocHed]), 1, 5);
        SortView.HostListIndexNo   := InvRNoK;
      end;
    // Quote tab -- scan by the first three characters of the OurRef, to include
    // SQU/PQU transactions only
    svltSalesDaybookQuotes, svltPurchaseDaybookQuotes:
      begin
        If (DocHed In SalesSplit) then
          SortView.HostListSearchKey := DocCodes[SQU]
        else
          SortView.HostListSearchKey := DocCodes[PQU];
        SortView.HostListIndexNo := InvOurRefK;
      end;
{$IFDEF SOP}
    // Orders tab -- scan by Run Number to locate all unposted Orders (i.e.
    // those with a run number of -40 (Sales) or -50 (Purchase) as required)
    svltSalesDaybookOrders, svltPurchaseDaybookOrders:
      begin
        SortView.HostListSearchKey := FullNomKey(Set_OrdRunNo(PSOPDocHed,BOff,BOff));
        SortView.HostListIndexNo   := InvRNoK;
      end;
{$ENDIF}
  end;

  if (SQLUtils.UsingSQL) then
    // For SQL we don't need a search key, because all the searching and
    // filtering is handled by the Stored Procedure. Attempting to supply
    // a search key simply confuses it.
    SortView.HostListSearchKey := '';

  // Build the temporary Sort View file
  SortView.Apply;
  SortView.Enabled := True;

  // Display the list, using the Sort View
  MULCtrlO[PageNo].StartList(SortTempF, STFieldK, FullNomKey(MULCtrlO[PageNo].SortView.ListID), '', '', 0, BOff);

  // Apply the 'Sorted' image to the tabe
  if MulCtrlO[PageNo].SortView.Sorts[1].svsAscending then
    DPageCtrl1.Pages[PageNo].ImageIndex := 1
  else
    DPageCtrl1.Pages[PageNo].ImageIndex := 2;
end;

procedure TDayBk1.RefreshList;
var
  TKeyLen,
  TKeypath    :  Integer;

  KeyStart,
  KeyPrime,
  KeyEnd      :  Str255;
begin
  KeyPrime := '';
  KeyEnd   := '';
  TKeyLen  := 5;
  TKeyPath := 0;
  
  if MulCtrlO[Current_Page].SortViewEnabled or MulCtrlO[Current_Page].UseDefaultSortView then
  begin
    ApplySortView;
  end
  else
  begin
    case Current_Page of
      0: begin
            KeyStart := FullDayBkKey(0,FirstAddrd,DocCodes[DocHed]);
            TKeyPath := InvRNoK;

            If (SWBentlyOn) and (DocHed In SalesSplit) then
            Begin
              KeyPrime := FullDayBkKey(0,0,DocCodes[DocHed]);
              MulCtrlO[0].StartLess := BOn;
            end;
            KeyEnd := FullDayBkKey(0, MaxInt, DocCodes[DocHed]);
         end;

     1  :  Begin
             If (DocHed In SalesSplit) then
               KeyStart:=DocCodes[SQU]
             else
               KeyStart:=DocCodes[PQU];

             TKeypath:=InvOurRefK;
             TKeyLen:=Length(KeyStart);

             MulCtrlO[Current_Page].UseSet4End:=BOff;
             MulCtrlO[Current_Page].NoUpCaseCheck:=BOff;
           end;
     2  :  Begin
             KeyStart:=FullDayBkKey(AutoRunNo,FirstAddrD,DocCodes[DocHed])+NdxWeight;
             KeyEnd:=FullDayBkKey(AutoRunNo,MaxInt,DocCodes[DocHed])+NdxWeight;
           end;
     {$IFDEF SOP}
       4
          :  Begin
               TKeyPath := InvRNoK;
               KeyStart:=FullDayBkKey(Set_OrdRunNo(PSOPDocHed,BOff,BOff),FirstAddrD,DocCodes[PSOPDocHed]);
             end;
     {$ENDIF}
    end; {Case..}
    MulCtrlO[Current_Page].OrigKey := KeyStart;
    MulCtrlO[Current_Page].OKLen := TKeyLen;

    MulCtrlO[Current_Page].StartList(InvF,TKeyPath,KeyStart,KeyEnd,KeyPrime,TKeyLen,BOff);
  end;
end;

procedure TDaybk1.ShowSortViewDlg;
var
  Dlg: TSortViewOptionsFrm;
  FuncRes: Integer;
  PageNo: Integer;
  SortView: TBaseSortView;
begin
  PageNo := Current_Page;
  SortView := MulCtrlO[PageNo].SortView;
  Dlg := TSortViewOptionsFrm.Create(nil);
  Dlg.SortView := SortView;
  try
    if (Dlg.ShowModal = mrOk) then
    begin
      ApplySortView;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TDaybk1.SortViewBtnClick(Sender: TObject);
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

procedure TDaybk1.RefreshView2Click(Sender: TObject);
var
  FuncRes: Integer;
begin
  FuncRes := MulCtrlO[Current_Page].SortView.Refresh;
  if (FuncRes = 0) then
  begin
    MulCtrlO[Current_Page].SortView.Enabled := True;
    RefreshList;
    if MulCtrlO[Current_Page].SortView.Sorts[1].svsAscending then
      DPageCtrl1.Pages[Current_Page].ImageIndex := 1
    else
      DPageCtrl1.Pages[Current_Page].ImageIndex := 2;
  end
  else
    ShowMessage('Failed to refresh Sort View, error #' + IntToStr(FuncRes));
end;

procedure TDaybk1.CloseView2Click(Sender: TObject);
begin
  MulCtrlO[Current_Page].SortView.Enabled := False;
  MulCtrlO[Current_Page].SortView.CloseView;
  MulCtrlO[Current_Page].UseDefaultSortView := False;
  DPageCtrl1.Pages[Current_Page].ImageIndex := -1;
  RefreshList;
end;

procedure TDaybk1.SortViewOptions2Click(Sender: TObject);
begin
  ShowSortViewDlg;
end;

// MH 29/06/2015 Exch2015-R1 ABSEXCH-15991: Set Sort View Window Caption
procedure TDayBkMList.CreateSortView(ForListType: TSortViewListType; Const ListDesc : String);
begin
  UseDefaultSortView := True;
  SortView := TDaybookSortView.Create(ForListType);
  // MH 29/06/2015 Exch2015-R1 ABSEXCH-15991: Set Sort View Window Caption
  SortView.ListDesc := ListDesc;
end;

{ CJS - 2013-10-28 - MRD2.6 - Transaction Originator }
procedure TDaybk1.FilterbyTransactionOriginator1Click(Sender: TObject);
var
  Dlg: TTransactionOriginatorDlg;
begin
  Dlg := TTransactionOriginatorDlg.Create(nil);
  try
    Dlg.Prepare;
    if (Dlg.ShowModal = mrOk) then
    begin
      // Set the new filter value
      MULCtrlO[Current_Page].FilteredOriginator := Dlg.User;
      // Update the window caption
      SetMainCaption;
      // Refresh the list of records
      MULCtrlO[Current_Page].InitPage;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TDaybk1.ClearTransactionOriginator1Click(Sender: TObject);
begin
  with MULCtrlO[Current_Page] do
  begin
    // Clear the filter
    FilteredOriginator := '';

    // Main Tab caption is set correctly
    SetMainCaption;

    // This ensures all the records are displayed and top record is highlighted
    InitPage;
  end;
end;

procedure TDaybk1.FilterbyCustomer1Click(Sender: TObject);
begin
  FilterbyCustomer1.Checked := True;
  FilterbyConsumer1.Checked := False;
  MULCtrlO[Current_Page].FilteredTrader := 'C';
  MULCtrlO[Current_Page].InitPage;
end;

procedure TDaybk1.FilterbyConsumer1Click(Sender: TObject);
begin
  FilterbyConsumer1.Checked := True;
  FilterbyCustomer1.Checked := False;
  MULCtrlO[Current_Page].FilteredTrader := 'U';
  MULCtrlO[Current_Page].InitPage;
end;

procedure TDaybk1.ClearCustomerConsumerFilter1Click(Sender: TObject);
begin
  FilterbyCustomer1.Checked := False;
  FilterbyConsumer1.Checked := False;
  MULCtrlO[Current_Page].FilteredTrader := #0;
  MULCtrlO[Current_Page].InitPage;
end;

//-------------------------------------------------------------------------

// MH 08/10/2014 ABSEXCH-15698: Added method to allow the Payment and Refund dialogs
//                              for Order Payments to refresh the daybooks
Procedure TDaybk1.UpdateForOrderPaymentsTransactions (Const OurRef : String);
Var
  sKey : Str255;
  iStatus : Integer;
Begin // UpdateForOrderPaymentsTransactions
  // MH 28/10/2014 ABSEXCH-15696: Extended to refresh the Sales Orders Daybook as well as it
  // can be holding an old version of the SOR from before a payment was taken, causing the
  // Refund button to be hidden if you view the SOR before the SQL cache expires
  If (DocHed = SIN) And (Current_Page In [0 {Main}, 4 {Orders}]) Then
  Begin
// If we want to automatically position on the new transaction we would need to load it into the
// global Inv record - however this was found to be annoying and potentially a useability nightmare
// for users

//    // Need to position on the new transaction in the global files for the list refresh to work
//    sKey := FullOurRefKey(OurRef);
//    iStatus := Find_Rec(B_GetEq,F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, sKey);
//    If (iStatus = 0) Then

    Begin
      If SQLUtils.UsingSQL Then
        // Clear the cache - otherwise the transaction might not show due to the 10 second cache timeout
        SQLUtils.DiscardCachedData(FileNames[InvF]);

      if MulCtrlO[Current_Page].SortViewEnabled then
        RefreshList
      else
      Begin
        // MH 13/08/2015 2015-R1 ABSEXCH-16724: Modified Update code as calling AddNewRow was
        // picking up whatever was in the global Inv record causing an ADJ to appear in the SOR
        // window for example  
        MulCtrlO[Current_Page].RefreshLine(MulCtrlO[Current_Page].MUListBoxes[0].Row,True);

        {$IFDEF SOP}
          // Update the Order Payments Tracker - need to pass across all transactions so
          // that the details can be blanked when a non-Order Payments transaction is
          // selected, so as not to mislead the user.
          If Syss.ssEnableOrderPayments And (Inv.InvDocHed In [SOR, SDN]) Then
            UpdateOrderPaymentsTracker(Inv);
        {$ENDIF}
      End; // Else
    End; // If (iStatus = 0)
  End; // If (DocHed = SIN) And (Current_Page In [0 {Main}, 4 {Orders}])
End; // UpdateForOrderPaymentsTransactions

//-------------------------------------------------------------------------

{$IFDEF SOP}
Procedure OrdPay_UpdateDaybooks (Const OurRef : String);
Var
  frmDayBook : TDaybk1;
  I : Integer;
Begin // OrdPay_UpdateDaybooks
  Try
    // Run through all the open MDI Children within EParentU
    For I := 0 To (Application.MainForm.MDIChildCount - 1) Do
    Begin
      // Look for an instance of the Daybook window
      If (Application.MainForm.MDIChildren[I].ClassName = 'TDaybk1') Then
      Begin
        frmDayBook := TDaybk1(Application.MainForm.MDIChildren[I]);
        If (Not (csDestroying In frmDayBook.ComponentState)) Then
          frmDayBook.UpdateForOrderPaymentsTransactions(OurRef);
      End; // If (Application.MainForm.MDIChildren[I].ClassName = 'TDaybk1')
    End; // For I
  Except
    // Bury any exceptions
    On e:Exception Do
      ;
  End; // Try..ExceptTry
End; // OrdPay_UpdateDaybooks
{$ENDIF}


{SS:22/09/2016:ABSEXCH-17352:Applying a sort view and then adding a transaction,the system automatically highlights the top transaction rather  than the newly created one.
:Locate record from the stored record list.}  

procedure TDayBkMList.LocateRecord(RecMainKey: Str255; KeyPath : Integer);
Var
  RecNo: Integer;
Begin  
  RecNo := 0;
  
  {$IFDEF EXSQL}
  if UsingSQL then PrepareSQLCall;
  {$ENDIF}

  Status:=Find_Rec(B_GetEq,F[SortTempF],SortTempF,RecPtr[SortTempF]^,KeyPath,RecMainKey);

  If (StatusOk) then
  Begin
    if SortViewEnabled then
    begin
      {$IFDEF EXSQL}
      if UsingSQL then PrepareSQLCall;
      {$ENDIF}    
      Status:=GetPos(F[SortTempF],SortTempF,RecNo);
      PageKeys^[0] := RecNo;
      PageUpDn(0,BOn);
      Update_Select(0,BOn);                            
    end;
  end;
end;


//PL 09/02/2017 2017-R1 ABSEXCH-13159 :  added ability to post Single Transaction on Daybook posting
procedure TDaybk1.PopupMenu5Popup(Sender: TObject);
var
  lValidTrans : Boolean;
begin
  if SingleDaybkVisible then
  begin
    if (frDaybkGrid.vMain.Controller.SelectedRowCount >= 2) then
    begin
      PostTransactionOnly.Caption := 'Post Selected only';
      PostTransactionWithReport.Caption := 'Post Selected with Posting Report';
    end
    else
    begin
      PostTransactionOnly.Caption := 'Post '+ Inv.OurRef+' only';
      PostTransactionWithReport.Caption := 'Post '+ Inv.OurRef +' with Posting Report';
    end;

    PostTransactionOnly.Visible := BOn;
    PostTransactionWithReport.Visible := BOn;

    lValidTrans := ValidTrans;

    PostTransactionOnly.Enabled := lValidTrans;
    PostTransactionWithReport.Enabled := lValidTrans;

  end
  else
  begin
    PostTransactionOnly.Visible := BOff ;
    PostTransactionWithReport.Visible := BOff ;
  end;
end;


procedure TDaybk1.OnSetDetail(Sender: TObject);
begin
  frDaybkGrid.vDetail.DataController.MasterKeyFieldNames := 'thFolioNum';
  frDaybkGrid.vDetail.DataController.KeyFieldNames := 'tlFolioNum';
  frDaybkGrid.vDetail.DataController.DetailKeyFieldNames := 'tlFolioNum';
  frDaybkGrid.vDetail.DataController.DataSource := FdmMain.dsDaybookDetail;
  FdmMain.InitDetailQuery;
  frDaybkGrid.InitColumns(frDaybkGrid.vDetail);
  frDaybkGrid.vDetail.ApplyBestFit();   
end;

//PL 09/02/2017 2017-R1 ABSEXCH-13159 :  added ability to post Single Transaction on Daybook posting
procedure TDaybk1.SingleDaybookPost(WithReport: Boolean);
var
  lPostRunNo : Integer;
  lRes : Integer;
  lPostSummary  :  PostingSummaryArray;
  saleson: Boolean;
  lSQLDayBookPosting : TSQLDayBookPosting;
  lMsg,lErrormsg,lExcludeLog : string;
  PostRepCtrl:  PostRepPtr;
  lProgressFrm: TIndeterminateProgressFrm;
  lStrList: TStringList;
  i,K: Integer;
  //PL 22/03/2017 2017-R1 ABSEXCH-18516 Need exception raised when attempting to post a single transaction underneath a suspension
  //Prepare posting log for the transactions which are excluded.
  function GetPostLog(aRunNO: Integer; aSQLDayBookPosting: TSQLDayBookPosting): String;
  var
    lExculdedList: TStringList;
    lRes,
    I: Integer;
    lOurRef: String;
  begin
    Result := EmptyStr;
    lExculdedList := TStringList.Create;
    try
      lRes := aSQLDayBookPosting.ExecPostRunExclusionReport(aRunNo, lExculdedList);
      if lRes = 0 then
      begin
        for I := 0 to lExculdedList.Count - 1 do
        begin
          lOurRef := lExculdedList.Names[I];
          Result := lExculdedList.Values[lOurRef] + #13;
        end;
      end;
    finally
      FreeAndNil(lExculdedList);
    end;
  end;

begin
  //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
  if not GetProcessLock(plDaybookPost) then
    EXIT;
  Try
  lPostRunNo := 0;
  if (frDaybkGrid.vMain.Controller.SelectedRowCount >= 2) then
    lMsg := 'Are you sure you want to post Selected transactions?'
  else
    lMsg := Format(cPostConfirmation, [Inv.OurRef]);

  if MessageDlg(lMsg, mtConfirmation, [mbOK,mbCancel], 0) = mrOK  then
  begin
    //SS:17/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
    lProgressFrm := TIndeterminateProgressFrm.Create(Application);

    lSQLDayBookPosting := TSQLDayBookPosting.Create;
    try
      //SS:17/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
      lProgressFrm.HideProgressBar := True;
      lProgressFrm.Start('Single Daybook Posting', 'Posting '+ Inv.OurRef+'...');
      Application.ProcessMessages;

      if (frDaybkGrid.vMain.Controller.SelectedRowCount >= 2) then
      begin
        with frDaybkGrid,vMain,DataController do
        begin
          if not Assigned(TcxGridDBDataController(DataController).GetItemByFieldName('thOurRef')) then Exit;

          k := TcxGridDBDataController(DataController).GetItemByFieldName('thOurRef').Index;
          lStrList := TStringList.Create;
          for i := 0 to frDaybkGrid.vMain.Controller.SelectedRecordCount - 1 do
          begin
            lStrList.Add(frDaybkGrid.vMain.Controller.SelectedRows[i].Values[k]);
          end;
        end;
        lRes := lSQLDayBookPosting.ExecTransactionPost(lStrList.DelimitedText, lPostRunNo, GetLocalPr(0).CYr,
                                                     GetLocalPr(0).CPr, Ord(Syss.SepRunPost), EntryRec^.LogIn);
      end
      else
        lRes := lSQLDayBookPosting.ExecTransactionPost(Inv.OurRef, lPostRunNo, GetLocalPr(0).CYr,
                                                     GetLocalPr(0).CPr, Ord(Syss.SepRunPost), EntryRec^.LogIn);

      if (lRes = 0) and (lPostRunNo <> 0) then
      begin
        //PL 22/03/2017 2017-R1 ABSEXCH-18516 Need exception raised when attempting to post a single transaction underneath a suspension
        lExcludeLog := GetPostLog(lPostRunNo,lSQLDayBookPosting);
        if lExcludeLog = EmptyStr then
        begin
          if WithReport then
          begin
            Blank(lPostSummary, Sizeof(lPostSummary));
            lRes := lSQLDayBookPosting.ExecPostRunSummaryReport(lPostRunNo, lPostSummary);
            if lRes = 0 then
            begin
              New(PostRepCtrl);
              try
                FillChar(PostRepCtrl^,Sizeof(PostRepCtrl^),0);
                with PostRepCtrl^.PParam do
                begin
                  UFont := TFont.Create;
                  UFont.Size := 7;
                  PDevRec.NoCopies := 1;
                  Orient := RPDefine.poLandscape;
                  try
                    UFont.Assign(Application.MainForm.Font);
                  except
                    UFont.Free;
                    UFont:=nil;
                  end;
                end;
              except
                Dispose(PostRepCtrl);
                PostRepCtrl := nil;
              end;

              with PostRepCtrl^.PParam do
              begin
                pfSelectPrinter(PDevRec,UFont,Orient);
              end;

              //SS:17/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
              if Assigned(lProgressFrm) then
              begin
                lProgressFrm.Stop;
                lProgressFrm := nil;
              end;

              {$IFDEF Rp}
                PostRepCtrl^.PostSummary:=lPostSummary;
                AddPostRep2Thread(2,lPostRunNo,SetPostMode(Inv.InvDocHed),PostRepCtrl,BOff,Owner);
              {$ENDIF}

              if Assigned(PostRepCtrl) then
              begin
                PostRepCtrl^.PParam.UFont.Free;
                Dispose(PostRepCtrl);
                PostRepCtrl := nil;
              end;
            end;
          end
          else
          begin
            //SS:17/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
            if Assigned(lProgressFrm) then
            begin
              lProgressFrm.Stop;
              lProgressFrm := nil;
            end;

            if (frDaybkGrid.vMain.Controller.SelectedRowCount >= 2) then
              ShowMessage('Selected transactions have been posted successfully')
            else
              ShowMessage('Transaction '+Inv.OurRef+' has been posted successfully');
          end;
          RefreshList;
          frDaybkGrid.RefreshGrid;
        end //if lExcludeLog = EmptyStr
        else
          MessageDlg(lExcludeLog, mtError, [mbOK], 0);
      end //if (lRes = 0) and (lPostRunNo <> 0) then
      else
      begin
        {PL 13/02/2017 2017-R1 ABSEXCH-18331 :  added a msg to show the handled
        exception Which is created when execution of stored procedure throws error in SQL_DaybookPosting.}
        lErrormsg :='The following error occurred whilst posting '+ Inv.OurRef+'.'+#13+lSQLDayBookPosting.errormsg;
        MessageDlg(lErrormsg, mtError, [mbOK], 0);
      end;

      //SS:16/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
      if Assigned(lProgressFrm) then
        lProgressFrm.Stop;

    finally
      lSQLDayBookPosting.Free;
      if Assigned(lProgressFrm) then
        lProgressFrm := nil;

    end; //try lSQLDayBookPosting := TSQLDayBookPosting.Create;
  end;
  Finally
    //PR: 16/05/2017 ABSEXCH-18683 v2017 R1 Release process lock
    if Assigned(Application.Mainform) then
      SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plDaybookPost), 0);
  End;
end;


//PL 09/02/2017 2017-R1 ABSEXCH-13159 :  added ability to post Single Transaction on Daybook posting
procedure TDaybk1.PostTransactionWithReportClick(Sender: TObject);
begin
  SingleDaybookPost(True);
end;

//PL 09/02/2017 2017-R1 ABSEXCH-13159 :  added ability to post Single Transaction on Daybook posting
procedure TDaybk1.PostTransactionOnlyClick(Sender: TObject);
begin
  SingleDaybookPost(False);
end;

//-------------------------------------------------------------------------

// MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
function TDaybk1.WindowExportEnableExport: Boolean;
begin
  // Enable to Export to Excel button on the Toolbar for the following Daybook windows
  Result := (DocHed In [SIN,     // Sales - all tabs
                        PIN,     // Purchase - all tabs
                        NMT,     // Nominal - all tabs
                        ADJ,     // Stock - all tabs
                        WOR,     // Works Orders - all tabs
                        SRN,     // Sales Returns - all tabs
                        PRN]);   // Purchase Returns - all tabs

  // Note currently the enabled daybooks support all tabs for the export, if this changes
  // then the PageControl's OnChange event will need to call WindowExport.ReevaluateExportStatus
  // to dynamically enable the toolbar button as the tab changes

  If Result Then
  Begin
    WindowExport.AddExportCommand (ecIDCurrentRow, ecdCurrentRow);
    WindowExport.AddExportCommand (ecIDCurrentPage, ecdCurrentPage);
    WindowExport.AddExportCommand (ecIDEntireList, ecdEntireList);
  End; // If Result
end;

//-----------------------------------

// MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
procedure TDaybk1.WindowExportExecuteCommand(const CommandID: Integer; Const ProgressHWnd : HWnd);
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
      MulCtrlO[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd);

      ListExportIntf.FinishExport;
    End; // If ListExportIntf.StartExport(sTitle)
  Finally
    ListExportIntf := NIL;
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

// MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
function TDaybk1.WindowExportGetExportDescription: String;
begin
  Result := '';

  Case DocHed Of
    SIN : Result := 'Sales';
    PIN : Result := 'Purchase';
    NMT : Result := 'Nominal';
    ADJ : Result := 'Stock';
    WOR : Result := 'Works Orders';
    SRN : Result := 'Sales Returns';
    PRN : Result := 'Purchase Returns';
  End; // Case DocHed

  Result := Result + ' ' + DPageCtrl1.ActivePage.Caption + ' Daybook';
end;

//=========================================================================

procedure TDaybk1.FormShow(Sender: TObject);
begin
  frDaybkGrid.aBestFitExecute(Sender);
end;

Initialization

  DayBkFormMode:=SIN;
  DayBkFormPage:=0;
  DayBkHistRunNo:=0;
  {$IFDEF SOP}
    DayBkHistCommP:=BOff;
  {$ENDIF}
end.

