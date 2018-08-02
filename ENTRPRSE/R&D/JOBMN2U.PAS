unit JobMn2U;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SBSPanel, StdCtrls, Mask, TEditVal, ExtCtrls, ComCtrls, BorBtns,
  GlobVar,VarConst,VarRec2U,BtrvU2,BTSupU1,ExWrap1U, SupListU,

  {$IFDEF NP}
    NoteU,
  {$ENDIF}


  SBSComp2,
  SalTxl1U,
  {Recon3U,}
  JHistDDU,

  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  ExtGetU,

  VarSortV,
  SortJob,
  ImgModu,

  {$IFDEF CU}
  CustomBtnHandler,
  {$ENDIF}
  Menus, Buttons, Grids, SBSOutl, bkgroup, TCustom,

  // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  WindowExport, ExportListIntf, oExcelExport,

  EntWindowSettings;





type
  TJLMList  =  Class(TDDMList)
  private
    function GetSortView: TJobLedgerSortView;
    procedure SetSortView(const Value: TJobLedgerSortView);

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SortView: TJobLedgerSortView read GetSortView write SetSortView;

  Public
    GlobCMode,
    LinePosted
             :  Boolean;

    StkExtRecPtr
             :  ExtNomRecPtr;

    StkExtObjPtr
             :  GetNomMode;

    LNHCtrl  :  TNHCtrlRec;


    Procedure ExtObjCreate; Override;

    Procedure ExtObjDestroy; Override;

    Function ExtFilter  :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;

    Function GetExtList(B_End      :  Integer;
                    Var KeyS       :  Str255)  :  Integer; Override;

    Procedure SetJADefaults(Const MainStr    :  Str255;
                            Var   LKeyLen    :  Integer;
                                  NomKey     :  Str255);

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Link2Inv  :  Boolean;

    Function Ok2Del :  Boolean; Override;

    Function OutALGLine(Col  :  Byte)  :  Str255;

    Function OutJRTLine(Col  :  Byte)  :  Str255;

    Function OutJALine(Col  :  Byte)  :  Str255;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;


type
  TJobRec = class(TForm)
    PageControl1: TPageControl;
    Main: TTabSheet;
    Notes: TTabSheet;
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
    CopyCP1Btn: TButton;
    ViewCP1Btn: TButton;
    PrnCP1Btn: TButton;
    InsCP1Btn: TButton;
    GenCP3Btn: TButton;
    TCMScrollBox: TScrollBox;
    JFolF: Text8Pt;
    CLSBox: TScrollBox;
    CLORefLab: TSBSPanel;
    CLDateLab: TSBSPanel;
    CLOOLab: TSBSPanel;
    CLQOLab: TSBSPanel;
    CLALLab: TSBSPanel;
    CLORefPanel: TSBSPanel;
    CLDatePanel: TSBSPanel;
    CLOOPanel: TSBSPanel;
    CLQOPanel: TSBSPanel;
    CLALPanel: TSBSPanel;
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
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    PopupMenu2: TPopupMenu;
    Copy2: TMenuItem;
    Reverse1: TMenuItem;
    I1StatLab: Label8;
    SBSBackGroup1: TSBSBackGroup;
    SBSBackGroup2: TSBSBackGroup;
    Label828: Label8;
    Label829: Label8;
    Label830: Label8;
    SBSBackGroup4: TSBSBackGroup;
    Label827: Label8;
    Label831: Label8;
    LnkCp1Btn: TButton;
    Links1: TMenuItem;
    ChkCP1Btn: TButton;
    Notes1: TMenuItem;
    Label85: Label8;
    SRCF: Text8Pt;
    Label812: Label8;
    Label813: Label8;
    JacF: Text8Pt;
    Label814: Label8;
    JDeF: Text8Pt;
    JTyF: Text8Pt;
    Label815: Label8;
    JTDF: Text8Pt;
    JACCF: Text8Pt;
    JACDF: Text8Pt;
    JCOF: Text8Pt;
    Label816: Label8;
    JMGF: Text8Pt;
    SRSPC1F: TSBSComboBox;
    SRSP1F: TCurrencyEdit;
    JSDF: TEditDate;
    JFDF: TEditDate;
    Label817: Label8;
    JRDF: TEditDate;
    Label818: Label8;
    Bevel1: TBevel;
    Label819: Label8;
    Label820: Label8;
    AddCP1Btn: TButton;
    Reten: TTabSheet;
    RTSBox: TScrollBox;
    RTHedPanel: TSBSPanel;
    RTACLab: TSBSPanel;
    RTDTLab: TSBSPanel;
    RTEXLab: TSBSPanel;
    RTAMLab: TSBSPanel;
    RTORefLab: TSBSPanel;
    RTACPanel: TSBSPanel;
    RTDTPanel: TSBSPanel;
    RTExPanel: TSBSPanel;
    RTAMPanel: TSBSPanel;
    RTORefPanel: TSBSPanel;
    RTSTPanel: TSBSPanel;
    RTStLab: TSBSPanel;
    StatCp1Btn: TButton;
    JSTF: Text8Pt;
    JSOF: Text8Pt;
    Status1: TMenuItem;
    PopupMenu3: TPopupMenu;
    Quotation1: TMenuItem;
    Active1: TMenuItem;
    Suspended1: TMenuItem;
    Completed1: TMenuItem;
    Closed1: TMenuItem;
    SalReten: TTabSheet;
    SBSPopupMenu1: TSBSPopupMenu;
    ViewR1: TMenuItem;
    ViewR2: TMenuItem;
    CustdbBtn1: TSBSButton;
    CustdbBtn2: TSBSButton;
    Custom1: TMenuItem;
    Custom2: TMenuItem;
    EntCustom1: TCustomisation;
    CLUPPanel: TSBSPanel;
    CLUPLab: TSBSPanel;
    SBSBackGroup3: TSBSBackGroup;
    SBSPopupMenu2: TSBSPopupMenu;
    PTMI1: TMenuItem;
    STMI1: TMenuItem;
    SubTerm: TTabSheet;
    Apps: TTabSheet;
    PApps: TTabSheet;
    Label82: Label8;
    JQSCodeF: Text8Pt;
    RPTMI1: TMenuItem;
    N3: TMenuItem;
    RSTMI1: TMenuItem;
    TRCP1Btn: TButton;
    imeRates1: TMenuItem;
    SBSPopupMenu3: TSBSPopupMenu;
    Chk1: TMenuItem;
    Chk2: TMenuItem;
    Chk3: TMenuItem;
    CLACCPanel: TSBSPanel;
    CLACCLab: TSBSPanel;
    SortViewPopupMenu: TPopupMenu;
    RefreshView1: TMenuItem;
    CloseView1: TMenuItem;
    N5: TMenuItem;
    SortViewOptions1: TMenuItem;
    SortViewBtn: TButton;
    SortView1: TMenuItem;
    RefreshView2: TMenuItem;
    CloseView2: TMenuItem;
    N4: TMenuItem;
    SortViewOptions2: TMenuItem;
    JUD1F: Text8Pt;
    User1Lab: Label8;
    User2Lab: Label8;
    User3Lab: Label8;
    JUD3F: Text8Pt;
    User4Lab: Label8;
    JUD4F: Text8Pt;
    JUD2F: Text8Pt;
    CurrF: TSBSComboBox;
    Label81: Label8;
    T2VATF: TSBSComboBox;
    CCLbl: Label8;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    JUD5F: Text8Pt;
    JUD6F: Text8Pt;
    JUD7F: Text8Pt;
    Label83: Label8;
    Label84: Label8;
    Label86: Label8;
    Label87: Label8;
    User5Lab: Label8;
    User6Lab: Label8;
    User7Lab: Label8;
    User8Lab: Label8;
    User9Lab: Label8;
    User10Lab: Label8;
    JUD10F: Text8Pt;
    JUD9F: Text8Pt;
    JUD8F: Text8Pt;
    PMenu_Notes: TPopupMenu;
    MenItem_General: TMenuItem;
    MenItem_Dated: TMenuItem;
    MenItem_Audit: TMenuItem;
    CustdbBtn3: TSBSButton;
    CustdbBtn4: TSBSButton;
    CustdbBtn5: TSBSButton;
    CustdbBtn6: TSBSButton;
    Custom3: TMenuItem;
    Custom4: TMenuItem;
    Custom5: TMenuItem;
    Custom6: TMenuItem;
    DeptLbl: Label8;
    VATLbl: TLabel;
    pnlAnonymisationStatus: TPanel;
    shpNotifyStatus: TShape;
    lblAnonStatus: TLabel;
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
    procedure CLORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CLORefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CLORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GenCP3BtnClick(Sender: TObject);
    procedure FindCP1BtnClick(Sender: TObject);
    procedure CopyCP1BtnClick(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure PrnCP1BtnClick(Sender: TObject);
    procedure LnkCp1BtnClick(Sender: TObject);
    procedure StatCp1BtnClick(Sender: TObject);
    procedure Quotation1Click(Sender: TObject);
    procedure SRCFExit(Sender: TObject);
    procedure JTyFExit(Sender: TObject);
    procedure JACCFExit(Sender: TObject);
    procedure JACDFDblClick(Sender: TObject);
    procedure JSOFDblClick(Sender: TObject);
    procedure JSOFExit(Sender: TObject);
    procedure ViewR1Click(Sender: TObject);
    procedure JUD1FEntHookEvent(Sender: TObject);
    procedure JUD1FExit(Sender: TObject);
    procedure CustdbBtn1Click(Sender: TObject);
    procedure ChkCP1BtnClick(Sender: TObject);
    procedure SRCFEnter(Sender: TObject);
    procedure JMGFExit(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure HistCP1BtnClick(Sender: TObject);
    procedure PTMI1Click(Sender: TObject);
    procedure SBSPopupMenu2Popup(Sender: TObject);
    procedure RPTMI1Click(Sender: TObject);
    procedure TRCP1BtnClick(Sender: TObject);
    procedure Chk1Click(Sender: TObject);
    procedure SBSPopupMenu3Popup(Sender: TObject);
    procedure SortViewBtnClick(Sender: TObject);
    procedure RefreshView1Click(Sender: TObject);
    procedure CloseView1Click(Sender: TObject);
    procedure SortViewOptions1Click(Sender: TObject);
    procedure MenItem_GeneralClick(Sender: TObject);
    procedure MenItem_DatedClick(Sender: TObject);
    procedure MenItem_AuditClick(Sender: TObject);
    function WindowExportEnableExport: Boolean;
    procedure WindowExportExecuteCommand(const CommandID: Integer;
      const ProgressHWnd: HWND);
    function WindowExportGetExportDescription: String;
    private
    { Private declarations }
    JobContract,
    HideDAdd,
    ManClose,
    InHBeen,
    StopPageChange,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    fNeedCUpdate,
    FColorsChanged,
    fFrmClosing,
    fDoingClose,
    CanDelete  :  Boolean;

    LastHMode,
    ListOfSet  :  Byte;

    SKeypath   :  Integer;
    
    FSettings : IWindowSettings; //HV 21/04/2016 2016-R2 ABSEXCH-10691: When viewing a Job Record->Ledger Tab->resizing the columns can lead to losing the column header
    {$IFDEF NP}
      NotesCtrl  :  TNoteCtrl;
    {$ENDIF}

    {$IFDEF Ltr}
      LetterActive: Boolean;
      LetterForm:   TLettersList;
    {$ENDIF}

    PageP,
    ScrollAP,
    ScrollBP,
    Misc1P,
    PanelP     :  TPoint;

    PagePoint  :  Array[0..4] of TPoint;

    StartSize,
    InitSize   :  TPoint;


    MULCtrlO   :  Array[2..7] of TJLMList;

    InvBtnList :  TVisiBtns;

    RetRecPtr  :  Array[BOff..Bon] of Pointer;
    DispTransPtr
               :  Pointer;

    EmplRecFormPtr
               :  Pointer;

    { CJS 21/08/2009 }
    LastSelectedTabSheet: TTabSheet;

    { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
    UseDefaultSortView: Boolean;

    {$IFDEF CU}
    // 25/01/2013  PKR   ABSEXCH-13449/38
    FormPurpose : TFormPurpose;
    RecordState : TRecordState;
    {$ENDIF}

    //SSK 15/12/2017 2018R1 ABSEXCH-19497: variable added to handle anonymisation behaviour
    FListScanningOn,
    FAnonymisationON: Boolean;

    
    procedure DefaultPageReSize;

    procedure NotePageReSize;

    Procedure NoteUpdate;

    Function ScanMode  :  Boolean;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;



    procedure LedgerBuildList(PageNo     :  Byte;
                              ShowLines  :  Boolean);

    procedure RetenBuildList(PageNo     :  Byte;
                             ShowLines  :  Boolean);

    procedure Display_Trans(Mode  :  Byte);

    procedure BuildDesign;

    procedure HidePanels(PageNo  :  Byte);

    procedure AddCP3BtnClick(Sender: TObject);

    procedure DelCP3BtnClick(Sender: TObject);


    procedure PrintRetCr;

    procedure SetCompRO(TC     :  TComponent;
                  Const TG     :  Integer;
                  Const EnabFlg:  Boolean);


    Procedure Set_EntryRO(PTMode  :  Char);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function CheckListFinished  :  Boolean;

    Function HasUnPosted(JCode  :  Str20;
                         Warn   :  Boolean)  :  Boolean;

    Procedure Set_JobStat(Fnum,
                          Keypath,
                          NewStat  :  Integer);

    
    procedure Display_RetRec(Mode     :  Byte;
                             IsSales  :  Boolean);

    procedure EditRetRec(Sender  : TObject;
                         IsSales : Boolean);

    procedure EditCharge(ORMode   :  Byte);


    {$IFDEF JAP}
       procedure Display_GlobalTrans(Mode  :  Byte);

       procedure Link_To_JT(SalesMode  :  Boolean);

       procedure RemoveLink_To_JT(SalesMode  :  Boolean);

    {$ENDIF}

    procedure Display_EmplAccount(Mode  :  Byte);

    //PR: 19/01/2009 Support functions for checking User Access to ledger buttons
    function AllowFunction(WhichFunc : Integer) : Boolean;
    procedure EnableLedgerButtons;

    procedure ShowSortViewDlg;

    procedure SyncUncachedRecord(ForList: TJLMList);
    procedure SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);

    //SSK 15/12/2017 2018R1 ABSEXCH-19497: routines to manage Anonymisation Behaviour for Job
    procedure SetAnonymisationBanner;              // set anonymisation banner
    procedure SetAnonymisationON(AValue: Boolean);
    procedure SetAnonymisationPanel;  // set position of anonymisation panel

  public
    { Public declarations }

    FromHist     :  Boolean;

    Level_Cr,
    Level_TxCr   :  Byte;
    Level_Commit :  Boolean;

    Level_JACode,
    Level_Code   :  Str20;

    Add_Type     :  Char;

    DDMode       :  Byte;

    DDCtrl       :  TNHCtrlRec;

    ExLocal      :  TdExLocal;

    HistFormPtr  :  Pointer;


    Function Current_BarPos(PageNo  :  Byte)  :  Integer;

    Function SetDelBtn  :  Boolean;

    Function ChkPWord(PageNo :  Integer;
                      Pages  :  TIntSet;
                      HelpS  :  LongInt) :  LongInt;

    Function SetHelpC(PageNo :  Integer;
                      Pages  :  TIntSet;
                      Help0,
                      Help1,
                      Help2,
                      Help3,
                      Help4,
                      Help5,
                      Help6,
                      Help7  :  LongInt) :  LongInt;

    procedure PrimeButtons;

    procedure SetTabs;

    procedure BuildMenus;

    procedure FormDesign;

    procedure Find_LedgCoord(PageNo  :  Integer);
    procedure Store_LedgCoord(UpMode  :  Boolean);


    procedure Find_FormCoord;
    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Function Current_Page  :  Integer;

    Procedure OutJob;
    Procedure Form2Job;


    Procedure SetFieldFocus;

    Procedure ChangePage(NewPage  :  Integer);

    Function CheckNeedStore  :  Boolean;

    Function ConfirmQuit  :  Boolean;

    Procedure SetCaption;

    procedure ShowLink;

    procedure SetJobStore(EnabFlag,
                            ButnFlg  :  Boolean);

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure ProcessJob(Fnum,
                         KeyPAth    :  Integer;
                         Edit       :  Boolean);

    Function CheckCompleted(Edit  :  Boolean)  : Boolean;


    procedure StoreJob(Fnum,
                       KeyPAth    :  Integer;
                       Edit       :  Boolean);


    procedure EditAccount(Edit  :  Boolean);

    procedure DeleteDoc;

    procedure DeleteAccount;

    procedure SetFieldProperties;

    procedure SetFormProperties;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);


    procedure ListFree;

    //SSK 13/12/2017 2018R1 ABSEXCH-19497: properties added to handle anonymisation status and ListScanning with single click
    property AnonymisationON: Boolean read FAnonymisationON write SetAnonymisationON;
    property ListScanningOn: Boolean read FListScanningOn write FListScanningOn;

  end;


Procedure Set_DDFormMode(State  :  TNHCtrlRec);

Function Auto_GetJCode(CCode    :  Str20;
                           Fnum,
                           Keypath  :  Integer)  :  Str20;

Procedure EditActCharge(Sender  :  TComponent;
                        PColor  :  TColor;
                        PFont   :  TFont;
                        ORMode  :  Byte;
                        ExLocal :  TdExLocal;
                        Fnum,
                        Keypath :  Integer;
                        NHCr    :  Byte
                        {$IFDEF EXSQL}
                        ;
                        SQLCacheID: Integer = 0
                        {$ENDIF}
                        );



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
  ComnUnit,
  ComnU2,
  CurrncyU,

  SysU1,

  InvListU,
  CLPAlU,

  {$IFDEF GF}
    FindRecU,
    FindCtlU,
  {$ENDIF}

  {$IFDEF PF_On}

    {$IFDEF STK}
      {$IFDEF SOP}
        InvLst3U,
      {$ENDIF}
    {$ENDIF}

  {$ENDIF}


  {InvCTSUU,}

  JobSup1U,

  {InvFSu3U,}

  {$IFDEF NP}
    NoteSupU,
  {$ENDIF}

  Tranl1U,
  PayF2U,

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}


  {$IFDEF Ltr}
    MSWord95,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,
  {$ENDIF}

  {$IFDEF POST}
    JobBudPU,
    JobPostU,
    PostSp2U,

  {$ENDIF}

  {$IFDEF JAP}
    JobSup2U,
    JChkUSeU,
  {$ENDIF}

  JCEmpR3U,

{$IFDEF EXSQL}
  SQLUtils,
{$ENDIF}

  SortViewOptionsF,

  ThemeFix,

  GenWarnU,
  ConvDocU,
  VarJCstU,
  ExThrd2U,
  JCRet1U,
  JClsJIU,
  PWarnU,
  JobApWzU,
  SysU2,
  UA_Const,
  APIUtil,
  CustomFieldsVar,
  CustomFieldsIntf,
  AuditNotes,
  MiscU,
  oSystemSetup,
  //SSK 29/11/2017 ABSEXCH-19497: GDPR constants
  GDPRConst;



{$R *.DFM}


{$I JLTi1U.Pas}

Const
  MainPage  =  0;
  NotesPage =  1;
  LedgerPage=  2;
  PRetenPage=  3;
  SRetenPage=  4;
  CTermPage =  5;
  PAppsPage =  6; {Not used as these items will appear in the ledger}
  SAppsPage =  7; {               "               "              "  }

  //PR constants for buttons on Ledger Tab
  lbPrint = 7;
  lbView  = 8;
  lbCopy  = 9;
  lbLinks = 10;

Var
  DDFormMode  :  TNHCtrlRec;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_DDFormMode(State  :  TNHCtrlRec);

Begin

  DDFormMode:=State;

end;



{ ============ Procedure to control the editing of the charge amount of actual records ======== }


{ ================ Procedure to input Charge value or tagged, or uplift =====================

OMode:  0  Input Charge
        1  Set tagged
        2  Input uplift}

Procedure EditActCharge(Sender  :  TComponent;
                        PColor  :  TColor;
                        PFont   :  TFont;
                        ORMode  :  Byte;
                        ExLocal :  TdExLocal;
                        Fnum,
                        Keypath :  Integer;
                        NHCr    :  Byte
                        {$IFDEF EXSQL}
                        ;
                        SQLCacheID: Integer
                        {$ENDIF}
                        );

Var
  ISCtrl  :  TCLPal;
  KeyS    :  Str255;
  LOk,
  Locked  :  Boolean;

  mrResult:  Word;

Begin
  KeyS:='';

  With ExLocal do
  Begin
    AssignFromGlobal(JDetlF);

{$IFDEF EXSQL}
    if (SQLCacheID > 0) then
      UseCustomPrefillCache(SQLCacheID);
{$ENDIF}

    LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOff,Locked);

    If (LOk) and (Locked) then
    With LJobDetl^.JobActual do
    Begin

{$IFDEF EXSQL}
    if (SQLCacheID > 0) then
      UseCustomPrefillCache(SQLCacheID);
{$ENDIF}

      LGetRecAddr(Fnum);  {* Refresh record address *}

      If (ORMode In [0,2]) then
      Begin
        ISCtrl:=TCLPAL.Create(Sender);

        try

          With ISCtrl do
          Begin
            JCChargeMode:=BOn;

            Case ORMode of
              0  :  Begin
                      Caption:='Set Charge Amount.';
                      PALab.Caption:='Charge Amount?';
                      PAValue:=Currency_ConvFT(Charge,CurrCharge,NHCr,UseCoDayRate);

                    end;
              2  :  Begin
                      Caption:='Set Uplift Amount.';
                      PALab.Caption:='Uplift Amount?';

                      PAValue:=UpliftTotal;
                    end;
            end; {Case..}



            {PAValue:=Charge; v5 altered to force into base currency}

            mrResult:=InitIS(BOff,PColor,PFont);

            If (mrResult=mrOk) then
            Begin
              Case ORMode of
                0  :  Charge:=Currency_ConvFT(PaValue,NHCr,CurrCharge,UseCoDayRate);
                2  :  Begin
                        Cost:=Cost-UpliftTotal;
                        UpliftTotal:=PaValue;
                        Cost:=Cost+UpliftTotal;
                      end;
              end; {Case..}

              {Charge:=PAValue; v5 Altered to convert back into charge currency of item}

{$IFDEF EXSQL}
    if (SQLCacheID > 0) then
      UseCustomPrefillCache(SQLCacheID);
{$ENDIF}

              Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

              Report_BError(Fnum,Status);

              LGetRecAddr(Fnum);  {* Refresh record address *}

            end;
          end;

        finally

          ISCtrl.Free;

{$IFDEF EXSQL}
    if (SQLCacheID > 0) then
      UseCustomPrefillCache(SQLCacheID);
{$ENDIF}

          UnLockMLock(Fnum,LastRecAddr[Fnum]);

        end; {Try..}
      end
      else
      Begin
        Tagged:=Not Tagged;

{$IFDEF EXSQL}
    if (SQLCacheID > 0) then
      UseCustomPrefillCache(SQLCacheID);
{$ENDIF}

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        Report_BError(Fnum,Status);

{$IFDEF EXSQL}
    if (SQLCacheID > 0) then
      UseCustomPrefillCache(SQLCacheID);
{$ENDIF}

        LGetRecAddr(Fnum);  {* Refresh record address *}

{$IFDEF EXSQL}
    if (SQLCacheID > 0) then
      UseCustomPrefillCache(SQLCacheID);
{$ENDIF}

        UnLockMLock(Fnum,LastRecAddr[Fnum]);

      end;
    end; {If locked ok..}
  end; {If valid line..}
end; {Proc..}





Function TJobRec.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PageControl1);

end;



procedure TJobRec.Find_LedgCoord(PageNo  :  Integer);
Begin
  //HV 21/04/2016 2016-R2 ABSEXCH-10691: When viewing a Job Record->Ledger Tab->resizing the columns can lead to losing the column header
  if Assigned(FSettings) and Assigned(MULCtrlO[PageNo]) then
    FSettings.SettingsToParent(MULCtrlO[PageNo]);
end;


procedure TJobRec.Store_LedgCoord(UpMode  :  Boolean);
Var
  n       :  Byte;
Begin
  //HV 21/04/2016 2016-R2 ABSEXCH-10691: When viewing a Job Record->Ledger Tab->resizing the columns can lead to losing the column header
  if Assigned(FSettings) then
  begin
    for n:=Low(MULCtrlO) to High(MULCtrlO) do
    begin
      if Assigned(MulCtrlO[n]) then
        FSettings.ParentToSettings(MULCtrlO[n], MULCtrlO[n]);
    end;
  end;
end;




Procedure  TJobRec.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TJobRec.Find_FormCoord;
Begin
  //HV 21/04/2016 2016-R2 ABSEXCH-10691: When viewing a Job Record->Ledger Tab->resizing the columns can lead to losing the column header
  if Assigned(FSettings) and not FSettings.UseDefaults then
  begin
    FSettings.SettingsToWindow(Self);
    FSettings.SettingsToParent(Main); //Main
  end;
  StartSize.X:=Width; StartSize.Y:=Height;
end;

procedure TJobRec.Store_FormCoord(UpMode  :  Boolean);
Begin
  //HV 21/04/2016 2016-R2 ABSEXCH-10691: When viewing a Job Record->Ledger Tab->resizing the columns can lead to losing the column header
  Store_LedgCoord(UpMode);
  if Assigned(FSettings) then
  begin
    //SSK 15/12/2017 2018R1 ABSEXCH-19497 : actual clientheight (- anonymisation panel) should be saved
    if pnlAnonymisationStatus.Visible then
      Self.ClientHeight := Self.ClientHeight - pnlAnonymisationStatus.Height;

    FSettings.WindowToSettings(Self);
    FSettings.ParentToSettings(Main, SRCF); //Main
    if Assigned(NotesCtrl) then
      FSettings.ParentToSettings(NotesCtrl.MULCtrlO, NotesCtrl.MULCtrlO); //Notes
    FSettings.SaveSettings(StoreCoord);
    FSettings := nil;
  end;
end;


procedure TJobRec.FormSetOfSet;


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



  GotCoord:=BOn;

end;

Function TJobRec.SetDelBtn  :  Boolean;

Begin
  With ExLocal do
    Result:=(((CanDelete or (LJobRec^.JobStat=JobClosed)) and (Not ExLocal.InAddEdit)) or (Current_Page In [NotesPage,PRetenPage,SRetenPage,CTermPage,SAppsPage]));
end;


Function TJobRec.ChkPWord(PageNo :  Integer;
                            Pages  :  TIntSet;
                            HelpS  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
    Result:=HelpS
  else
    Result:=-255;

end;

Function TJobRec.SetHelpC(PageNo :  Integer;
                            Pages  :  TIntSet;
                            Help0,
                            Help1,
                            Help2,
                            Help3,
                            Help4,
                            Help5,
                            Help6,
                            Help7  :  LongInt) :  LongInt;

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
      else
        Result := -1;
    end; {Case..}
  end
  else
    Result:=-1;

end;


procedure TJobRec.PrimeButtons;

Var
  ACFlg,
  P4Blk   :  Boolean;

  n,
  PageNo  :  Integer;

  TheCaption
          :  ShortString;

{$IFDEF CU}
  // 25/01/2013 PKR ABSEXCH-13449
  cBtnIsEnabled : Boolean;
  TextID        : integer;
{$ENDIF}
Begin
  PageNo:=Current_Page;

  TheCaption:='';

  {$IFDEF SOP}
    ACFlg:=BOff;
  {$ELSE}
    ACFlg:=BOn;

  {$ENDIF}

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
      {5} AddVisiRec(HistCP1Btn,BOff);
      {6} AddVisiRec(GenCP3Btn,BOff);
      {7} AddVisiRec(PrnCP1Btn,BOff);
      {8} AddVisiRec(ViewCP1Btn,BOff);
      {9} AddVisiRec(CopyCP1Btn,BOff);
     {10} AddVisiRec(LnkCP1Btn,BOff);
     {11} AddVisiRec(SortViewBtn, BOff);
     {12} AddVisiRec(ChkCP1Btn,BOn);
     {13} AddVisiRec(StatCP1Btn,BOff);
     {14} AddVisiRec(TRCP1Btn,BOff);

     {$IFDEF CU}
      {15}  AddVisiRec(CustdbBtn1,BOff);
      {16}  AddVisiRec(CustdbBtn2,BOff);
      // 17/01/2013 PKR ABSEXCH-13449
      {17}  AddVisiRec(CustdbBtn3,BOff);
      {18}  AddVisiRec(CustdbBtn4,BOff);
      {19}  AddVisiRec(CustdbBtn5,BOff);
      {20}  AddVisiRec(CustdbBtn6,BOff);

    {$ELSE}
      {15}  AddVisiRec(CustdbBtn1,BOn);
      {16}  AddVisiRec(CustdbBtn2,BOn);
      // 17/01/2013 PKR ABSEXCH-13449
      {17}  AddVisiRec(CustdbBtn3,BOn);
      {18}  AddVisiRec(CustdbBtn4,BOn);
      {19}  AddVisiRec(CustdbBtn5,BOn);
      {20}  AddVisiRec(CustdbBtn6,BOn);
    {$ENDIF}

        end; {With..}

    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  try

    With InvBtnList do
    Begin
      PresEnab:=ExLocal.InAddEdit ;

      //PR: 04/06/2010 Removed permissions check from Add button. (It was checking permission to Add a Stock Record.)
      SetHideBtn(0,Not (PageNo In [NotesPage,PRetenPage..SAppsPage]),BOff);
//      PWSetHideBtn(0,Not (PageNo In [NotesPage,PRetenPage..SAppsPage]),BOff,ChkPWord(PageNo,[MainPage,NotesPage],110));
      SetBtnHelp(0,SetHelpC(PageNo,[MainPage..SAppsPage],156,156,88,965,965,0,1523,0));


      If (PageNo=LedgerPage) then
        PWSetHideBtn(1,BOff,BOff,ChkPWord(PageNo,[LedgerPage],215))
      else
        PWSetHideBtn(1,BOff,BOff,ChkPWord(PageNo,[MainPage],209));


      SetBtnHelp(1,SetHelpC(PageNo,[MainPage..SAppsPage],916,155,981,1075,1075,0,1524,0));

      SetHideBtn(2,(PageNo<>NotesPage),BOff);

      Case PageNo of
        CTermPage  :  PWSetHideBtn(3,(PageNo=LedgerPage),BOff,ChkPWord(PageNo,[CTermPage],441));
        SAppsPage  :  PWSetHideBtn(3,(PageNo=LedgerPage),BOff,ChkPWord(PageNo,[SAppsPage],450));
        else          PWSetHideBtn(3,(PageNo=LedgerPage),BOff,ChkPWord(PageNo,[99],112));
      end;

      SetBtnHelp(3,SetHelpC(PageNo,[MainPage..SAppsPage],850,159,89,1077,1077,0,1516,0));

      SetHideBtn(4,(PageNo In [MainPage..SRetenPage]),BOff);

      SetBtnHelp(4,SetHelpC(PageNo,[LedgerPage],165,165,264,0,0,0,40121,0));

      SetHideBtn(5,(Not (PageNo In [MainPage])) or (Not JAPOn),BOff); {*EN560 Set password}

      SetHideBtn(6,(Not (PageNo In [NotesPage])),BOff);

      PWSetHideBtn(7,(PageNo In [NotesPage]),BOff,ChkPWord(PageNo,[0],113));

      SetBtnHelp(7,SetHelpC(PageNo,[MainPage,LedgerPage..SAppsPage],846,0,983,1078,1078,0,1525,0));

      SetHideBtn(8,(Not (PageNo In [LedgerPage..SAppsPage])),BOff);

      SetBtnHelp(8,SetHelpC(PageNo,[LedgerPage..SAppsPage],0,0,984,1079,1079,0,1524,0));

      SetHideBtn(9,(Not (PageNo In [LedgerPage,CTermPage..SAppsPage])),BOff);

      SetBtnHelp(9,SetHelpC(PageNo,[MainPage],186,0,985,0,0,0,0,0));

      SetHideBtn(10,(PageNo In [NotesPage,PRetenPage,SRetenPage]),BOff);

      SetBtnHelp(10,SetHelpC(PageNo,[MainPage,LedgerPage],81,81,81,81,81,81,81,81));

      PWSetHideBtn(11, (PageNo <> LedgerPage), BOff, ChkPWord(PageNo, [LedgerPage], 589));

      SetHideBtn(12,(PageNo<>MainPage) or ((Not SBSIn) and (Not Debug)) ,BOff);


      {$IFDEF CU}
        // 25/01/2013 PKR ABSEXCH-13449
        // 6 Custom buttons available.  Use the new custom button handler.
        formPurpose := fpJobRecord;
        recordState := rsAny;
      
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn1.Tag);
        {15}  SetHideBtn(15,(PageNo In [NotesPage,PRetenPage..SAppsPage]) or 
                             (not cBtnIsEnabled), BOff);
        
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn2.Tag);
        {16}  SetHideBtn(16,(PageNo In [NotesPage,PRetenPage..SAppsPage]) or 
                             (not cBtnIsEnabled), BOff);

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn3.Tag);
        {17}  SetHideBtn(17,(PageNo In [NotesPage,PRetenPage..SAppsPage]) or 
                             (not cBtnIsEnabled), BOff);
        
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn4.Tag);
        {18}  SetHideBtn(18,(PageNo In [NotesPage,PRetenPage..SAppsPage]) or 
                             (not cBtnIsEnabled), BOff);
        
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn5.Tag);
        {19}  SetHideBtn(19,(PageNo In [NotesPage,PRetenPage..SAppsPage]) or 
                             (not cBtnIsEnabled), BOff);
        
              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn6.Tag);
        {20}  SetHideBtn(20,(PageNo In [NotesPage,PRetenPage..SAppsPage]) or 
                             (not cBtnIsEnabled), BOff);
                             
(*        
        {15}  SetHideBtn(15,(PageNo In [NotesPage,PRetenPage..SAppsPage]) or 
                             Not EnableCustBtns(5000,10+PageNo), BOff);
        {16}  SetHideBtn(16,(PageNo In [NotesPage,PRetenPage..SAppsPage]) or 
                             Not EnableCustBtns(5000,20+PageNo), BOff);
        {17}  SetHideBtn(17,(PageNo In [NotesPage,PRetenPage..SAppsPage]) or 
                             Not EnableCustBtns(5000,140+PageNo), BOff);
        {18}  SetHideBtn(18,(PageNo In [NotesPage,PRetenPage..SAppsPage]) or 
                             Not EnableCustBtns(5000,150+PageNo), BOff);
        {19}  SetHideBtn(19,(PageNo In [NotesPage,PRetenPage..SAppsPage]) or 
                             Not EnableCustBtns(5000,160+PageNo), BOff);
        {20}  SetHideBtn(20,(PageNo In [NotesPage,PRetenPage..SAppsPage]) or 
                             Not EnableCustBtns(5000,170+PageNo), BOff);
*)

      {$ENDIF}

      PWSetHideBtn(14,(PageNo<>MainPage) or ((ExLocal.InAddEdit) and (Not ExLocal.LastEdit)),BOff,ChkPWord(PageNo,[0],222));

      PWSetHideBtn(13,(Not (PageNo In [MainPage])),BOn,ChkPWord(PageNo,[0],211));

      DelCP1Btn.Enabled:=SetDelBtn and Not PresEnab;

      OkCP1Btn.Visible:=(PageNo In [MainPage]);
      CanCP1Btn.Visible:=(PageNo In [MainPage]);



    end;


    {$IFDEF CU} {Set customised buttons caption}
    // 17/01/2013 PKR ABSEXCH-13449
    // 6 custom buttons available.  Use custom button handler to process them.
    If (CustdbBtn1.Visible) then
    Begin
      TheCaption:='';
      TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn1.tag);
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn1.Font);
      CustdbBtn1.Caption:=TheCaption;
    end;

    If (CustdbBtn2.Visible) then
    Begin
      TheCaption:='';
      TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn2.tag);
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn2.Font);

      CustdbBtn2.Caption:=TheCaption;
    end;

    // 17/01/2013 PKR ABSEXCH-13449
    If (CustdbBtn3.Visible) then
    Begin
      TheCaption:='';
      TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn3.tag);
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn3.Font);

      CustdbBtn3.Caption:=TheCaption;
    end;

    If (CustdbBtn4.Visible) then
    Begin
      TheCaption:='';
      TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn4.tag);
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn4.Font);

      CustdbBtn4.Caption:=TheCaption;
    end;

    If (CustdbBtn5.Visible) then
    Begin
      TheCaption:='';
      TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn5.tag);
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn5.Font);

      CustdbBtn5.Caption:=TheCaption;
    end;

    If (CustdbBtn6.Visible) then
    Begin
      TheCaption:='';
      TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn6.tag);
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn6.Font);

      CustdbBtn6.Caption:=TheCaption;
    end;

(*
    If (CustdbBtn1.Visible) then
    Begin
      TheCaption:='';
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, 10+PageNo, TheCaption, CustdbBtn1.Font);

      CustdbBtn1.Caption:=TheCaption;
    end;

    If (CustdbBtn2.Visible) then
    Begin
      TheCaption:='';
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, 20+PageNo, TheCaption, CustdbBtn2.Font);

      CustdbBtn2.Caption:=TheCaption;
    end;
*)

  {$ENDIF}

    // SSK 15/12/2017 2018R1 ABSEXCH-19497: Disable the status button for all the tabs for anonymised trader
    if GDPROn then
       StatCP1Btn.Enabled := not FAnonymisationON;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;


Function TJobRec.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      LedgerPage  :  Result:=CLSBox.HorzScrollBar.Position;

      PRetenPage..SAppsPage
         :  Result:=RTSBox.HorzScrollBar.Position;

      else  Result:=0;
    end; {Case..}
end;





{* Alter screen based on stock record }

procedure TJobRec.BuildDesign;

Var
  HideMC  :  Boolean;

  TabSheet: TTabSheet;
Begin
  TabSheet := PageControl1.ActivePage;
  With ExLocal,LJobRec^ do
  Begin
    JobContract:=((ExLocal.LJobRec^.JobType=JobGrpCode) and (Add_Type=#0)) or (Add_Type=JobGrpCode);

    Ledger.TabVisible:=(JobType<>JobGrpCode) and (Not HideDAdd);
    Reten.TabVisible:=(JobType<>JobGrpCode) and (Not HideDAdd) and (DDMode=0) and (ChkAllowed_In(210));
    SalReten.TabVisible:=(JobType<>JobGrpCode) and (Not HideDAdd) and (DDMode=0) and (ChkAllowed_In(210));
    Notes.TabVisible:=(Not HideDAdd) {and (ChkAllowed_In(219))};

    Apps.TabVisible:=((Not HideDAdd) and (DDMode=0))  and (PChkAllowed_In(453) and (JAPOn));
    PApps.TabVisible:=BOff; {((Not HideDAdd) and (DDMode=0))  and (PChkAllowed_In(-255) and (JAPOn));}

    SubTerm.TabVisible:=((Not HideDAdd) and (DDMode=0))  and (PChkAllowed_In(454) and (JAPOn));

    // CJS 2013-09-11 - ABSEXCH-13192 - add Job Costing to user profile rules
    Id3CCF.Visible:=Syss.UseCCDep and (Not JobContract);  // and (SBSIN);
    Id3DepF.Visible:=Id3CCF.Visible;
    CCLbl.Visible:=Id3CCF.Visible;
    DeptLbl.Visible := Id3CCF.Visible;

    {Label82.Visible:=(Not JobContract) and (SBSIN);}
    T2VATF.Visible:=(Not JobContract) and (SBSIN);
    VATLbl.Visible := T2VATF.Visible;


    If (JobContract) or (Not SBSIN)  then
      SBSBackGroup3.Caption:=''
    else
      SBSBackGroup3.Caption:='Retention Defaults';

    {$IFDEF MC_On}
      HideMC:=JobContract or (SBSIN);
    {$ELSE}
      HideMC:=BOn;
    {$ENDIF}

    CurrF.Visible:=Not HideMC and T2VATF.Visible;;
    Label81.Visible:=Not HideMC and T2VATF.Visible;;

    { CJS 21/08/2009 }
    if (LastSelectedTabSheet.TabVisible) then
      PageControl1.ActivePage := LastSelectedTabSheet
    else if (not TabSheet.TabVisible) then
      PageControl1.ActivePage := Main;

  end;

  PrimeButtons;
end;


procedure TJobRec.FormDesign;

Var
 n       :  Integer;

begin
  FormSetOfSet; //HV 21/04/2016 2016-R2 ABSEXCH-10691: When viewing a Job Record->Ledger Tab->resizing the columns can lead to losing the column header
  Find_FormCoord;


  {$IFDEF MC_On}
    Set_DefaultCurr(SRSPC1F.Items,BOff,BOff);
    Set_DefaultCurr(SRSPC1F.ItemsL,BOff,BOn);
    Set_DefaultCurr(CurrF.Items,BOff,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOff,BOn);
  {$ELSE}
    SRSPC1F.Visible:=BOff;

  {$ENDIF}

  SRCF.MaxLength:=JobKeyLen;


  With SRVMF do
  Begin
    For n:=1 to NofCHTypes do
      Items.Add(JobCHTDescL[n]);
  end;

  JacF.MaxLength:=JobKeyLen;

  JSOF.MaxLength:=DocKeyLen;

  //GS 25/10/2011 ABSEXCH-11706: retrieve settings for UDEF 1- 10

  //PR: 14/11/2011 Amended to use centralised function SetUdfCaptions in CustomFieldsIntf.pas ABSEXCH-12129
  SetUDFCaptions([User1Lab, User2Lab, User3Lab, User4Lab, User5Lab, User6Lab, User7Lab, User8Lab, User9Lab, User10Lab], cfJob);


  Set_DefaultVAT(t2VATF.Items,BOn,BOff);
  Set_DefaultVAT(t2VATF.ItemsL,BOn,BOn);


  FormSetOfSet;

  BuildDesign;

  SetTabs;

  //HV 23/11/2017 2018-R1 ABSEXCH-19405: procedure to set a Highlighting PII Fields flag for GDPR
  if GDPROn then
    SetGDPREnabled([JUD1F, JUD2F, JUD3F, JUD4F, JUD5F, JUD6F, JUD7F, JUD8F, JUD9F, JUD10F], cfJob);
end;


procedure TJobRec.SetTabs;
Begin
  PrimeButtons;
end;


procedure TJobRec.BuildMenus;

Begin
  Case Current_Page of
    MainPage  :  Begin
            CreateSubMenu(PopUpMenu3,Status1);
            CreateSubMenu(SBSPopUpMenu2,Hist1);

            If (SBSIn) or (Debug) then
              CreateSubMenu(SBSPopUpMenu3,Notes1);

          end;

    LedgerPage,
    CTermPage..SAppsPage
       :  CreateSubMenu(PopUpMenu2,Copy1);
  end; {Case..}
end;


procedure TJobRec.FormCreate(Sender: TObject);

Var
  n        :  Integer;
  ShowCC   :  Boolean;

begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  { CJS 21/08/2009 }
  LastSelectedTabSheet := Main;

  { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
  UseDefaultSortView := True;

  ExLocal.Create;

  LastCoord:=BOff;
  FListScanningOn := False;

  NeedCUpdate:=BOff;
  FColorsChanged := False;

  fFrmClosing:=BOff;
  fDoingClose:=BOff;
  Visible:=BOff;

  ManClose:=BOff;

  InitSize.Y := 396;  //354;  // SSK 22/12/2017 2018R1 ABSEXCH-19580 : InitSize.Y changed from 354 to 396
  InitSize.X := 559;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=353;
  Width:=566;}

  MDI_SetFormCoord(TForm(Self));

  //HV 21/04/2016 2016-R2 ABSEXCH-10691: When viewing a Job Record->Ledger Tab->resizing the columns can lead to losing the column header
  FSettings := GetWindowSettings(Self.ClassName);
  if Assigned(FSettings) then
    FSettings.LoadSettings;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;



  {* Set Version Specific Info *}

  InHBeen:=BOff;
  FromHist:=BOff;
  HideDAdd:=BOff;

  StopPageChange:=BOff;

  DispTransPtr:=nil;
  HistFormPtr:=nil;

  RetRecPtr[BOff]:=nil;
  RetRecPtr[BOn]:=nil;
  EmplRecFormPtr:=nil;

  LastHMode:=1;

  ListOfSet:=10;

  SKeypath:=0;
  GotCoord:=BOff;

  FormDesign;

  ChangePage(MainPage);
  BuildMenus;

end;


procedure TJobRec.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  {$IFDEF NP}
    If (NotesCtrl<>nil) and (Not fFrmclosing) then
    Begin
      try
        NotesCtrl.Free;

      finally

        NotesCtrl:=nil;
      end;
    end;
  {$ENDIF}


  ExLocal.Destroy;


  {For n:=Low(MULCtrlO) to 3 do  {* Seems to crash here if form open and you close app...
    If (MULCtrlO[n]<>nil) then
    Begin
      MULCtrlO[n].Destroy;
      MULCtrlO[n]:=nil;
    end;}
end;


procedure TJobRec.DefaultPageReSize;

Var
  n  :  Integer;

Begin

  CLSBox.Width:=PageControl1.Width-PagePoint[0].X;
  CLSBox.Height:=PageControl1.Height-PagePoint[0].Y;

  RTSBox.Width:=CLSBox.Width;
  RTSBox.Height:=CLSBox.Height;

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


procedure TJobRec.NotePageReSize;

Begin
  With TCNScrollBox do
  Begin
    TCNListBtnPanel.Left:=Width+4;

    TNHedPanel.Width:=HorzScrollBar.Range;
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




procedure TJobRec.FormResize(Sender: TObject);
Var
  n          :  Byte;


begin

  If (GotCoord) then
  Begin
    // MH 19/04/2010: Changed to use window handle to avoid extreme flickering which also affected other apps
    LockWindowUpDate({PageControl1.}Handle);

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


    {TCDScrollBox.Width:=PageControl1.Width-PagePoint[1].X;
    TCDScrollBox.Height:=(PageControl1.Height-PagePoint[1].Y)+1;}

    {TCNPanel.Left:=PageControl1.Width-PagePoint[2].X;
    TCNPanel.Height:=PageControl1.Height-PagePoint[2].Y;}


    TCNScrollBox.Width:=PageControl1.Width-PagePoint[3].X;
    TCNScrollBox.Height:=PageControl1.Height-PagePoint[3].Y;

    TCNListBtnPanel.Height:=TCNScrollBox.ClientHeight-PagePoint[4].X;

    DefaultPageReSize;

    NotePageReSize;

    LockWindowUpDate(0);

   // SSK 13/12/2017 2018R1 ABSEXCH-19497: Resize the anonymisation shape
    SetAnonymisationPanel;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end; {If time to update}
end; {Proc..}


procedure TJobRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If (Current_Page<1) or (Sender is TSBSComboBox) then
    GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TJobRec.ListFree;

Var
  n       :  Byte;

Begin
  For n:=Low(MULCtrlO) to PRetenPage do  {* Seems to crash here if form open and you close app... *}
    If (MULCtrlO[n]<>nil) then
    Begin
      MULCtrlO[n].Destroy;
      MULCtrlO[n]:=nil;
    end;

end;

procedure TJobRec.FormClose(Sender: TObject; var Action: TCloseAction);


begin


  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    ListFree;

  end;
end;


Function TJobRec.CheckListFinished  :  Boolean;

Var
  n       :  Byte;
  mbRet   :  Word;
Begin
  Result:=BOn;

  For n:=Low(MULCtrlO) to High(MULCtrlO) do
  Begin
    If (Assigned(MULCtrlO[n])) then
    begin
      Result:=Not MULCtrlO[n].ListStillBusy;
      if Result and MULCtrlO[n].SortViewEnabled then
        Result := not MULCtrlO[n].SortView.IsBuildingFile;
    end;

    If (Not Result) then
    Begin
      Set_BackThreadMVisible(BOn);

      mbRet:=MessageDlg('One of the lists is still busy.'+#13+#13+
                        'Do you wish to interrupt the list so that you can exit?',mtConfirmation,[mbYes,mbNo],0);

      If (mBRet=mrYes) then
      Begin
        MULCtrlO[n].IRQSearch:=BOn;

        if MULCtrlO[n].SortViewEnabled then
          MULCtrlO[n].SortView.CancelBuild;

        ShowMessage('Please wait a few seconds, then try closing again.');
      end;

      Set_BackThreadMVisible(BOff);

      Break;
    end;
  end;
end;


procedure TJobRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

Var
  n       :  Integer;


begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try


      CanClose:=ConfirmQuit;

      If (CanClose) then
        CanClose:=CheckListFinished;

      GenCanClose(Self,Sender,CanClose,BOff);

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


        Send_UpdateList(BOff,132);

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

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;
end;


procedure TJobRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

Begin
  If (Current_Page<1) or (Key In [VK_F1..VK_F12,VK_Prior,VK_Next])  or (Sender is TComboBox) then
    GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

end;


procedure TJobRec.ClsCP1BtnClick(Sender: TObject);
begin
  If (ConfirmQuit) then
  Begin
    Close;
  end;
end;



{ === Procedure to Output one cust record === }

Procedure TJobRec.OutJob;

Var
  Dnum       :   Double;

  n          :   LongInt;

  FoundStr   :   Str20;

  TmpJob     :   JobRecType;


Begin

  With ExLocal,LJobRec^ do
  Begin
    TmpJob:=LJobRec^;


    JFolF.Text:=SetPadNo(Form_Int(JobFolio,0),JobKeyLen);

    SRCF.Text:=Trim(JobCode);

    JaCF.Text:=Trim(JobAltCode);

    //SSK 13/12/2017 2018R1 ABSEXCH-19497: done for anonymisation
    if FAnonymisationON and jrAnonymised then
      JDeF.Text := capAnonymised
    else
      JDeF.Text := Trim(JobDesc);

    JTyF.Text:=Trim(JobAnal);

    If GetJobMisc(Self,JobAnal,FoundStr,1,-1) then
      JTDF.Text:=JobMisc^.JobTypeRec.JTypeName
    else
      JTDF.Text:='';

    JAccF.Text:=CustCode;

    If Global_GetMainRec(CustF,CustCode) then
      JACDF.Text:=Cust.Company
    else
      JACDF.Text:='';

    JCOF.Text:=Contact;

    JMGF.Text:=JobMan;

    If (ChargeType>0) then
      SRVMF.ItemIndex:=Pred(ChargeType);

    {$IFDEF MC_On}
      If (CurrPrice>0) then
        SRSPC1F.ItemIndex:=Pred(CurrPrice);

      If (DefRetCurr>0) then
        CurrF.ItemIndex:=Pred(DefRetCurr)
      else
        CurrF.ItemIndex:=0;

    {$ENDIF}

    Id3CCF.Text:=CCDep[BOn];
    Id3DepF.Text:=CCDep[BOff];

    If (VATCode In VATSet) then
      t2VATF.ItemIndex:=GetVATIndex(VATCode)
    else
      t2VATF.ItemIndex:=0;


    SRSP1F.Value:=QuotePrice;

    JSDF.DateValue:=StartDate;
    JFDF.DateValue:=EndDate;
    JRDF.DateValue:=RevEDate;

    JSTF.Text:=JobStatusL^[JobStat];

    JSOF.Text:=Trim(SORRef);

    JUD1F.Text:=UserDef1;
    JUD2F.Text:=UserDef2;
    JUD3F.Text:=UserDef3;
    JUD4F.Text:=UserDef4;
    //GS 25/10/2011 ABSEXCH-11706: put customisation values into text boxes
    JUD5F.Text:=UserDef5;
    JUD6F.Text:=UserDef6;
    JUD7F.Text:=UserDef7;
    JUD8F.Text:=UserDef8;
    JUD9F.Text:=UserDef9;
    JUD10F.Text:=UserDef10;
    
    JQSCodeF.Text:=JQSCode;


  end; {with..}

end; {Proc..}


Procedure TJobRec.Form2Job;

Var
  I,n  :  Integer;

Begin

  With ExLocal,LJobRec^ do
  Begin

    JobCode:=UpCaseStr(FullJobCode(SRCF.Text));
    JobAltCode:=UpCaseStr(FullJobCode(JACF.Text));
    JobDesc:=FullJobDesc(JDef.Text);
    JobAnal:=FullCCDepKey(JTyF.Text);
    CustCode:=FullCustCode(JAccF.Text);
    Contact:=JCOF.Text;
    JobMan:=JMGF.Text;

    I:=Succ(SRVMF.ItemIndex);

    If (I>0) then
      ChargeType:=I
    else
      ChargeType:=1;


    {$IFDEF MC_On}

      I:=Succ(SRSPC1F.ItemIndex);

      If (I>0) then
        CurrPrice:=I
      else
        CurrPrice:=1;

      If (CurrF.ItemIndex>=0) then
        DefRetCurr:=Succ(CurrF.ItemIndex);

    {$ENDIF}

    CCDep[BOn]:=Id3CCF.Text;
    CCDep[BOff]:=Id3DepF.Text;

    With t2VATF do
      If (ItemIndex>=0) then
        VATCode:=Items[ItemIndex][1];

    QuotePrice:=SRSP1F.Value;

    StartDate:=JSDF.DateValue;

    EndDate:=JFDF.DateValue;

    RevEDate:=JRDF.DateValue;

    SORRef:=FullOurRefKey(JSOF.Text);

    UserDef1:=JUD1F.Text;
    UserDef2:=JUD2F.Text;
    UserDef3:=JUD3F.Text;
    UserDef4:=JUD4F.Text;
    //GS 25/10/2011 ABSEXCH-11706: write udef field values into customisation object
    UserDef5:=JUD5F.Text;
    UserDef6:=JUD6F.Text;
    UserDef7:=JUD7F.Text;
    UserDef8:=JUD8F.Text;
    UserDef9:=JUD9F.Text;
    UserDef10:=JUD10F.Text;

    JQSCode:=JQSCodeF.Text;

  end; {with..}

end; {Proc..}


Procedure TJobRec.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      MainPage
         :  If (LastEdit) then
              JDeF.SetFocus
            else
              SRCF.SetFocus;

    end; {Case&With..}

end; {Proc..}


Procedure TJobRec.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  If (Pages[NewPage].TabVisible) then
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);


  end; {With..}
end; {Proc..}


Function TJobRec.CheckNeedStore  :  Boolean;

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
    else
      If (Components[Loop] is TCurrencyEdit) then
      With (Components[Loop] as TCurrencyEdit) do
      Begin
        Result:=((Tag=1) and (FloatModified));

        If (Result) then
          FloatModified:=BOff;
      end
      else
        If (Components[Loop] is TBorCheck) then
        With (Components[Loop] as TBorCheck) do
        Begin
          Result:=((Tag=1) and (Modified));

          If (Result) then
            Modified:=BOff;
        end
        else
          If (Components[Loop] is TSBSComboBox) then
          With (Components[Loop] as TSBSComboBox) do
          Begin
            Result:=((Tag=1) and (Modified));

            If (Result) then
              Modified:=BOff;
          end;

    Inc(Loop);
  end; {While..}
end;


Function TJobRec.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;


  If (ExLocal.InAddEdit) and (CheckNeedStore) then
  Begin
    If (Current_Page>NotesPage) then {* Force view of main page *}
      ChangePage(MainPage);

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StoreJob(JobF,SKeypath,ExLocal.LastEdit);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) then
                  Status:=UnLockMLock(JobF,LastRecAddr[JobF]);

                If (InAddEdit) then
                  SetJobStore(BOff,LastEdit);

                TmpBo:=BOn;

                InJobEdit:=BOff;
              end;

    mrCancel
           :  Begin
                TmpBo:=BOff;
                SetfieldFocus;
              end;
  end; {Case..}


  ConfirmQuit:=TmpBo;
end; {Func..}


procedure TJobRec.SetCompRO(TC     :  TComponent;
                        Const TG     :  Integer;
                        Const EnabFlg:  Boolean);


Begin
  If (TC is TMaskEdit) then
    With (TC as TMaskEdit) do
    Begin
      If (Tag=TG) then
      Begin
        ReadOnly:= Not EnabFlg;
        TabStop:=Not ReadOnly;
      end;
    end
    else
      If (TC is TCurrencyEdit ) then
      With (TC as TCurrencyEdit) do
      Begin
        If (Tag=TG) then
        Begin
          ReadOnly:= Not EnabFlg;
          TabStop:=Not ReadOnly;
        end;
      end
      else
        If (TC is TBorCheck) then
        With (TC as TBorCheck) do
        Begin
          If (Tag=TG) then
          Begin
            Enabled:=EnabFlg;
          end;
        end
        else
          If (TC is TBorRadio) then
          With (TC as TBorRadio) do
          Begin
            If (Tag=TG) then
            Begin
              Enabled:=EnabFlg;
            end;
          end
          else
            If (TC is TSBSComboBox) then
            With (TC as TSBSComboBox) do
            Begin
              If (Tag=TG) then
              Begin
                ReadOnly:=Not EnabFlg;
                TabStop:=Not ReadOnly;
              end;
            end;
end;


procedure TJobRec.SetJobStore(EnabFlag,
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

  ChkCP1Btn.Enabled:=Not EnabFlag;

  InsCP1Btn.Enabled:=Not EnabFlag;
  PrnCP1Btn.Enabled:=Not EnabFlag;
  CopyCP1Btn.Enabled:=Not EnabFlag;
  LnkCP1Btn.Enabled:=Not EnabFlag;
  //SSK 19/02/2018 2018 R1 ABSEXCH-19776: keep the status button disabled if the job is anonymised
  StatCp1Btn.Enabled:=Not EnabFlag and (not Exlocal.LastJobRec^.jrAnonymised);
  TRCp1Btn.Enabled:=Not EnabFlag;

  ExLocal.InAddEdit:=EnabFlag;

  If (ExLocal.InAddEdit) then
    Set_EntryRO(ExLocal.LJobRec^.JobType)
  else
    For Loop:=0 to ComponentCount-1 do
    Begin
      SetCompRO(Components[Loop],1,EnabFlag);
    end;

  With ExLocal do
    SRCF.ReadOnly:=(Not Enabled) or ((Not CanDelete) and ((Not InAddEdit) or (LastEdit))) ;

  JSTF.ReadOnly:=BOn;
  JSTF.TabStop:=BOff;

end;


Procedure TJobRec.Set_EntryRO(PTMode  :  Char);

Var
  Loop  :  Integer;
  TC    :  TComponent;

Begin


  For Loop:=0 to ComponentCount-1 do
  Begin
    TC:=Components[Loop];

    If (TC<>SRCF) then {* Do not change Stock code, as maybe set to readonly.. *}
      SetCompRO(TC,1,BOn); {* Reset them all first *}


    Case PTMode of
       JobJobCode  :  ;    {Product}

       {JobGrpCode  :  Begin {Description only. v4.31 all fields enabled.} 
                        {If (TC<>SRCF) and (TC<>JACF) and (TC<>JDEF) and (TC<>JSDF) and (TC<>JFDF)
                            and (TC<>JRDF) and (TC<>JUD1F) and (TC<>JUD2F) then
                          SetCompRO(TC,1,BOff);
                      end;}

    end; {Case..}
  end; {Loop..}

end; {Proc..}




(*  Add is used to add Jobs *)

procedure TJobRec.ProcessJob(Fnum,
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

    With ExLocal do
    Begin
      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);

      Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked);

    end;


    If (Not Ok) or (Not GlobLocked) then
      AddCh:=#27;
  end
  else
  Begin
    HideDAdd:=BOn;
    BuildDesign;
  end;



  If (Addch<>#27) then
  With ExLocal,LJobRec^ do
  begin


    If (Not Edit) then
    Begin
      Caption:='Add Job Record';
      LResetRec(Fnum);

      JobType:=Add_Type;

      CustCode:=FullCustCode('');

      JobFolio:=SetNextJFolio(JBF,BOff,0);

      JobCat:=Level_Code;

      JobAltCode:=JobCat;

      {$IFDEF MC_On}

        CurrPrice:=1;

      {$ENDIF}


      VATCode:=Syss.VATCode;

      NlineCount:=1;

      ALineCount:=1000; {* Offset to avoid static anal types *}

      ChargeType:=1;

      StartDate:=Today;


      JobStat:=2;

      CanDelete:=BOn;

    end;

    JobContract:=(JobType=JobGrpCode);

    OutJob;


    LastJobRec^:=LJobRec^;

    SetJobStore(BOn,BOff);

    SetFieldFocus;

  end; {If Abort..}

end; {Proc..}


Procedure TJobRec.NoteUpdate;


Const
  Fnum     =  JobF;
  Keypath  =  JobFolioK;


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
      With LJobRec^ do
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




Function TJobRec.ScanMode  :  Boolean;

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



Procedure TJobRec.WMCustGetRec(Var Message  :  TMessage);

Var
  ListPoint  :  TPoint;
  LastPage   :  TTabSheet;
  SMode      :  Integer;
  Ok2Exe     :  Boolean;

Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      0,1,169
         :  If (Current_Page In [LedgerPage,CTermPage..SAppsPage]) then
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
                 //PR: 25/02/2016 v2016 R1 ABSEXCH-17331 Ensure we have correct record
                 MULCtrlO[Current_Page].Link2Inv;

                 Ok2Exe:=ValidSecurityHook(2000,156,ExLocal);
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

              if Ok2Exe then
                Display_Trans(2+(98*WParam));

              //PR: 19/01/2009 - Set buttons on Ledger tab according to user access rights (20060614150400)
              if Current_Page = LedgerPage then
                EnableLedgerButtons;

            end
            else
              If (Current_Page In [PRetenPage,SRetenPage]) and (WParam<>1) and (MULCtrlO[Current_Page].ValidLine) then {* Get retention record..*}
              Begin
                GetCursorPos(ListPoint);
                ScreenToClient(ListPoint);

                SBSPopupMenu1.PopUp(ListPoint.X,ListPoint.Y);

              end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      7  :  NoteUpDate; {* Update note line count *}

     17  :  Begin {* Force reset of form *}
              GotCoord:=BOff;
              SetDefault:=BOn;
              Close;
            end;
     25  :  NeedCUpdate:=BOn;

     108
         :  With MULCtrlO[Current_Page] do
            Begin

              AddNewRow(MUListBoxes[0].Row,(LParam=1));

            end;



     110 :  Begin
              If (Current_Page<>MainPage) then
                ChangePage(MainPage);
              Show;
            end;



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


              Check_TabAfterPW(PageControl1,Self,WM_CustGetRec);
            end;

     200 :  DispTransPtr:=nil;

     202 :  EmplRecFormPtr:=nil;


     {$IFDEF Ltr}
       400,
       401  : Begin
                LetterActive:=Boff;
                LetterForm:=nil;
              end;
     {$ENDIF}

     {$IFDEF GF}

       3002
          : If (Assigned(FindCust)) then
              With MULCtrlO[LParam],FindCust,ReturnCtrl do
              Begin
                InFindLoop:=BOn;

                SMode:=SearchMode+10;

                Find_OnList(SMode,SearchKey);

                With MUListBoxes[0] do
                  If (CanFocus) then
                    SetFocus;

                InFindLoop:=BOff;
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


Procedure TJobRec.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      41 :  Begin
              HistFormPtr:=nil;

              If (MULCtrlO[LedgeRPage]<>nil) then
              Begin
                DDCtrl.NHNeedGExt:=BOff;
                RefreshList(BOn,BOff);
              end;
            end;


      52,53
         :  Begin
              FromHist:=BOn;

              If (Current_Page<>LedgerPage) then
                ChangePage(LedgerPage);



              If (MULCtrlO[LedgerPage]<>nil) then
              With ExLocal,MULCtrlO[LedgerPage],DDCtrl do
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

      145,
      146:  Begin
              RetRecPtr[WParam=146]:=nil;
            end;

       150,151
         :  Begin
              With MULCtrlO[WParam-147] do
              Begin

               AddNewRow(MUListBoxes[0].Row,(LParam=1));

               If (LParam=0) then
                 PrintRetCr;
              end;
            end;

       158,159
          : With MULCtrlO[WParam-155] do
            Begin

              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;

            end;


    end; {Case..}

  end;

  Inherited;
end;

Procedure TJobRec.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

{ == Procedure to Send Message to Get Record == }

Procedure TJobRec.Send_UpdateList(Edit   :  Boolean;
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



Function TJobRec.CheckCompleted(Edit  :  Boolean)  : Boolean;

Const
  NofMsgs      =  13;  //TG increasing by two to add validation for CC/DD

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  Test     :  Byte;

  ShowMsg,
  Loop     :  Boolean;
  n,
  mbRet    :  Word;

  FoundCode:  Str20;

  FoundLong:  LongInt;


Begin
  New(PossMsg);
  ShowMsg := False;
  Loop := false;
  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That Job Code already exists.';
  PossMsg^[2]:='That Job Code is not valid.';
  PossMsg^[3]:='The Quote Price currency is not valid.';
  PossMsg^[4]:='The Customer code is not valid.';
  PossMsg^[5]:='The Job Charge Type is not valid.';
  PossMsg^[6]:='The Default '+CCVATName^+' code is not valid.';
  PossMsg^[7]:='The Job Type code is not valid.';
  PossMsg^[8]:='That default Retention Cost Centre Code is not valid.';
  PossMsg^[9]:='That default Retention Department Code is not valid.';
  PossMsg^[10]:='The default Retention currency is not valid.';
  PossMsg^[11]:='An additional check is made via an external hook';
  //TG-01-06-2017- ABSEXCH-18682-No error is displayed on 'Edit' and 'OK'
  PossMsg^[12]:='Cost Centre Code not valid.';
  PossMsg^[13]:='Department Code not valid.';

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LJobRec^ do
  Begin
    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              If (Not Edit) then
                Result:=Not (CheckExsists(JobCode,JobF,JobCodeK))
              else
                Result:=BOn;
            end;

      2  :  Result:=(Not EmptyKey(JobCode,StkKeyLen));



    {$IFDEF MC_On}
      3  :
               Result:=(CurrPrice In [Succ(CurStart)..CurrencyType])  or (JobContract);
    {$ENDIF}


      4  :   Result:=Global_GetMainRec(CustF,CustCode) or (JobContract);


      5  :  Result:=ChargeType<>0;

      6  :  Result:=(VATCode In VATSet);

      7  :  Begin
              Result:=(GetJobMisc(Self,JobAnal,FoundCode,1,-1) and (JobAnal<>'')) or (JobContract);
            end;

      8,9
         :  Result:=BOn;{(Not Syss.UseCCDep) or (JobContract) or ((Not EmptyKeyS(CCDep[Test=8],CCKeyLen,BOff) and GetCCDep(Self,CCDep[Test=8],FoundCode,(Test=8),-1)));}

      {$IFDEF MC_On}
        10  :
                 Result:=BOn; {Result:=(DefRetCurr In [Succ(CurStart)..CurrencyType]) or (JobContract);}
      {$ENDIF}

      11 :  Begin {* Opportunity for hook to validate this record as well *}
              {$IFDEF CU}
                 Result:=ValidExitHook(5000,40,ExLocal);
                 ShowMsg:=BOff;

               {$ENDIF}
              end;
      //TG-01-06-2017- ABSEXCH-18682-No error is displayed on 'Edit' and 'OK'
      //AP-16-06-2017- ABSEXCH-18682 - Error even when System is not using CC/Dep
      12 : If (Syss.UseCCDep) then
             Result := ((CCDep[true] = '') or GetCCDep(Self,CCDep[true],FoundCode,true,-1));

      13 : If (Syss.UseCCDep) then
             Result := ((CCDep[false] = '') or GetCCDep(Self,CCDep[False],FoundCode,False,-1));
    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) then
    mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}






Procedure TJobRec.SetCaption;

Var
  LocTit  :  Str50;

Begin
  LocTit:='';
  With ExLocal,LJobRec^,DDCtrl do
  Begin
    if GDPROn and jrAnonymised then
      Caption:='Job Record '+dbFormatName(JobCode,' ')+capAnonymised
    else
      Caption:='Job Record '+dbFormatName(JobCode,JobDesc)+'. '+Show_TreeCur(NHCr,NHTxCr)

  end;
end;

procedure TJobRec.StoreJob(Fnum,
                           KeyPAth    :  Integer;
                           Edit       :  Boolean);

Var
  COk  :  Boolean;
  TmpJob
       :  JobRecType;
  KeyS :  Str255;

  MbRet:  Word;

  NewSCode
       :  Str20;



Begin
  KeyS:='';     NewSCode:='';

  Form2Job;

  With ExLocal,LJobRec^ do
  Begin

    If (Edit) and (LastJobRec^.JobCode<>JobCode) then
    Begin
      COk:=(Not Check4DupliGen(JobCode,Fnum,JobCodeK,'Job'));
    end
    else
      COk:=BOn;

    If (COk) then
      COk:=CheckCompleted(Edit);

    If (COk) then
    Begin
      COk:=(Not EmptyKey(JobCode,SRCF.MaxLength));

      If (Not COk) then
        mbRet:=MessageDlg('Job Code not valid!',mtError,[mbOk],0);
    end;

    If (COk) then
    Begin
      Cursor:=crHourGlass;

      If (Edit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpJob:=LJobRec^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LJobRec^:=TmpJob;

        end;


        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        //TW 07/11/2011 Add Edit audit note if update is successful.
        if(status = 0) then
          TAuditNote.WriteAuditNote(anJob, anEdit, ExLocal);
      end
      else
      Begin
        JobFolio:=SetNextJFolio(JBF,BOn,0);


        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
        CanDelete:=BOn;

        //PR: 22/11/2011 6.9 Store audit note when job record created
        if(status = 0) then
          TAuditNote.WriteAuditNote(anJob, anCreate, ExLocal);

        If (StatusOk) then
          Gen_JMajorHed(LJobRec^);

      end;

      SetCaption;

      Report_BError(Fnum,Status);

      LGetRecAddr(Fnum);  {* Refresh record address *}

      If (StatusOk) then
      Begin
        If (Edit) and (LastJobRec^.JobCode<>JobCode) then  {* Change any existing budgets *}
        Begin
          ReCode_JobBudget(LastJobRec^.JobCode,JobCode);
        end;

        Send_UpdateList(Edit,32);
      end;

      If (Edit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      

      Cursor:=CrDefault;

      LastValueObj.UpdateAllLastValues(Self);

      If (HideDAdd) then
      Begin
        HideDAdd:=BOff;
        BuildDesign;
      end;

      InAddEdit:=BOff;
      LastEdit:=BOff;

      SetJobStore(BOff,Edit);
    end
    else
    Begin

      {ChangeNBPage(1);}

      SetFieldFocus;

    end;

    InJobEdit:=BOff;
 end; {If..}

end;



procedure TJobRec.OkCP1BtnClick(Sender: TObject);

Var
  TmpBo  :  Boolean;
  KeyS   :  Str255;

begin

  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    begin
      // CJS: 05/01/2011 - Handling for ALT+O. Force focus to the Ok button,
      // to ensure that any OnExit handlers are triggered.
      if OkCP1Btn.CanFocus then
        OkCP1Btn.SetFocus;
      if ActiveControl = OkCP1Btn then
        StoreJob(JobF,SKeypath,ExLocal.LastEdit);
    end
    else
      If (ModalResult=mrCancel) then
      Begin
        
         If (Not ExLocal.LastEdit) then {* Force close..}
         Begin
           InJobEdit:=BOff;
           
           Close;
           Exit;
         end;

        If (ConfirmQuit) then
        With ExLocal do
        Begin

          If (InAddEdit) then
            LJobRec^:=LastJobRec^;
            
          OutJob;
          InJobEdit:=BOff;
          SetTabs;

          ExLocal.InAddEdit:=BOff;
          ExLocal.LastEdit:=BOff;

        end;
      end;
  end; {With..}
end;

procedure TJobRec.EditAccount(Edit  :  Boolean);
begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    InJobEdit:=Edit;

    If (Not Edit) then
      ChangePage(0);

    ProcessJob(JobF,CurrKeyPath^[JobF],LastEdit);
  end;
end;


procedure TJobRec.DeleteAccount;

Const
  Fnum  =  JobF;


Var
  MbRet  :  Word;
  KeyS   :  Str255;

  Keypath:  Integer;

  LastCursor
         :  TCursor;

  BalJRec:  JobRecType;

Begin

  MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Job Record',
                     mtConfirmation,[mbYes,mbNo],0);


  If (MbRet=MrYes) then
  With ExLocal do
  Begin
    LastCursor:=Cursor;

    Cursor:=crHourGlass;

    Self.Enabled:=BOff;

    try

      Keypath:=CurrKeyPath^[Fnum];

      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);

      Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,GlobLocked);

      If (Ok) and (GlobLocked) then
      Begin
        BalJRec:=LJobRec^;

        Status:=Delete_Rec(F[Fnum],Fnum,CurrKeyPath^[Fnum]);

        Report_BError(Fnum,Status);

        If (StatusOk) then {* Delete any dependant links etc *}
        With LJobRec^ do
        Begin
          
          {$IFDEF NP}
            Delete_Notes(NoteJCode,FullNCode(FullNomKey(LJobRec^.JobFolio))); {* Auto Delete Notes *}
          {$ENDIF}

          {$IFDEF Ltr}
            { Delete any letters/Links }
            DeleteLetters (LetterJobCode, FullNomKey(LJobRec^.JobFolio));
          {$ENDIF}

          {Delete Job Specific payrates}

          KeyS:=PartCCKey(JBRCode,JBSubAry[3])+FullEmpKey(JobCode);

          DeleteLinks(KeyS,JCtrlF,Length(KeyS),JCK,BOff);

          {Also delete other details }
          Send_UpdateList(Boff,232);

          {*EN560 Delete contract terms *}

          Cursor:=Lastcursor;

          {$IFDEF POST}
            Begin
              If (JobCat<>'') then
                AddJobPostBud2Thread(Application.MainForm,38,JobCat,nil,Application.MainForm.Handle);

              If (Not CanDelete) then
              Begin
                AddCheckNom2Thread(Application.MainForm,Nom,BalJRec,7);
              end;
            end;
          {$ENDIF}

          {* Delete all other links *}

          Delete_JobDetails(JobCode,JobType,JobFolio,CanDelete);

          Close;
        end;
      end;
    finally
      Cursor:=LastCursor;
    end;
  end;
end; {PRoc..}

procedure TJobRec.DeleteDoc;


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

      {$IFDEF CU}
        IF (ValidExitHook(2000,100,ExLocal)) then
      {$ENDIF}

      Begin
        GetSelRec(BOff);

        If Delete_Application(Inv,BOn,ScanFileNum,Keypath,ExLocal) then
        Begin
          PageUpDn(0,BOn);

          If (PageKeys^[0]=0) then {* Update screen as we have lost them all!*}
            InitPage

        end;

      end;
    end; {If confirm delete..}
  end; {If ok..}
end; {PRoc..}


procedure TJobRec.EditCharge(ORMode   :  Byte);
Begin
  If (Assigned(MULCtrlO[LedgerPage])) then
    If (MULCtrlO[LedgerPage].ValidLine) then
    With MULCtrlO[LedgerPage] do
    Begin
      if (SQLCacheID <> 0) then
        SyncUncachedRecord(MulCtrlO[LedgerPage]);

//      EditActCharge(Self,CLORefPanel.Color,CLOrefPanel.Font,ORMode,ExLocal,ScanFileNum,KeyPath,JobDetl^.JobActual.CurrCharge);
      EditActCharge(Self,CLORefPanel.Color,CLOrefPanel.Font,ORMode,ExLocal,JDetlF,KeyPath,JobDetl^.JobActual.CurrCharge);

      if (SQLCacheID <> 0) then
        RefreshCache;

      RefreshLine(MUListBoxes[0].Row,BOn);

    end;

end;


procedure TJobRec.EditCP1BtnClick(Sender: TObject);


begin

  Case Current_Page of
    NotesPage
        :  AddCP3BtnClick(Sender);

    LedgerPage
        :  EditCharge(0);

    PRetenPage,
    SRetenPage
        :  EditRetRec(Sender,Current_Page=SRetenPage);

    CTermPage,
    SAppsPage
        :  Begin
             InHBeen:=(Sender=EditCP1Btn);

             Display_Trans(1+(1*Ord((Sender=EditCP1Btn))));

           end;


    else  EditAccount((Sender=EditCP1Btn));
  end; {Case..}

end;



procedure TJobRec.ShowLink;
Var
  StartPage  :  Integer;
{$IFDEF Ltr}
  OldCust, TmpPtr : CustRecPtr;
{$ENDIF}
begin
  StartPage:=Current_Page;

  ExLocal.AssignFromGlobal(JobF);
  ExLocal.LGetRecAddr(JobF);

  SetCaption;

  OutJob;

  DDCtrl:=DDFormMode;

  CanDelete:=Ok2DelJob(0,ExLocal.LJobRec^);

  DelCP1Btn.Enabled:=SetDelBtn;

  BuildDesign;

  Case Current_Page of

    NotesPage
       :  {$IFDEF NP}
            If (NotesCtrl<>nil) then {* Assume record has changed *}
            With ExLocal do
            Begin
              NotesCtrl.RefreshList(FullNomKey(LJobRec^.JobFolio),NotesCtrl.GetNType);
              NotesCtrl.GetLineNo:=LJobRec^.NLineCount;
            end;

          {$ELSE}

            ;
          {$ENDIF}

    LedgerPage..SAppsPage:
        begin
          RefreshList(BOn,BOff);
        end;


  end; {Case..}


  {$IFDEF Ltr}
  If Assigned(LetterForm) And LetterActive Then
    If (LetterForm.WindowState <> wsMinimized) Then
      With ExLocal Do Begin
        New (OldCust);
        OldCust^ := Cust;
        If CheckRecExsists(FullCustCode(ExLocal.LJobRec^.CustCode), CustF, CustCodeK) Then
          TmpPtr := @Cust
        Else
          TmpPtr := Nil;
        LetterForm.LoadLettersFor (FullNomKey(LJobRec^.JobFolio),   { Index Key }
                                   LJobRec^.JobCode,               { Caption }
                                   CodeToFName (LJobRec^.JobCode), { FName }
                                   LetterJobCode,
                                   TmpPtr, Nil, Nil, @LJobRec^, Nil);
        Cust := OldCust^;
        Dispose(OldCust);
      End; { With }
  {$ENDIF}
end;


procedure TJobRec.SetFieldProperties;

Var
  n  : Integer;


Begin
  {SBSPanel4.Color:=SBSPanel1.Color;}

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

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        {CheckColor:=SRCF.Color;}
        Color:=TCMScrollBox.Color;
      end;

  end; {Loop..}

  {With YTDCombo do
  Begin
    Font.Assign(SRCF.Font);
    Color:=SRCF.Color;
  end;}


end;



procedure TJobRec.SetFormProperties;
Var
  ListChange :  Byte;
Begin
  //HV 21/04/2016 2016-R2 ABSEXCH-10691: When viewing a Job Record->Ledger Tab->resizing the columns can lead to losing the column header
  ListChange:=0;
  ListChange:=ListChange+(1*Ord(Current_Page In [2..4]));
  //PR: 05/11/2010 Changed to use new Window Position System
  if Assigned(FSettings) then
  begin
    Case ListChange of
      0 :
          if FSettings.Edit(Main, SRCF) = mrOK then
          begin
            NeedCUpdate := True;
            FColorsChanged := True;
          end;
      1 : if FSettings.Edit(MULCtrlO[Current_Page], MULCtrlO[Current_Page]) = mrOK then
          begin
            NeedCUpdate := True;
            FColorsChanged := True;
          end;
    end; //Case
  end;
end;



procedure TJobRec.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  {$IFDEF CU}
  // 28/01/2013 PKR ABSEXCH-13449
  Custom1.Caption := CustdbBtn1.Caption;
  Custom2.Caption := CustdbBtn2.Caption;
  Custom3.Caption := CustdbBtn3.Caption;
  Custom4.Caption := CustdbBtn4.Caption;
  Custom5.Caption := CustdbBtn5.Caption;
  Custom6.Caption := CustdbBtn6.Caption;
  {$ENDIF}
  
  If (Current_Page=MainPage) then
  Begin
    DeleteSubMenu(Copy1);

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
    if not MulCtrlO[Current_Page].SortViewEnabled then
    begin
      RefreshView2.Visible := False;
      CloseView2.Visible := False;
      N4.Visible := False;
    end
    else
    begin
      RefreshView2.Visible := True;
      CloseView2.Visible := True;
      N4.Visible := True;
    end;
  end;
end;

procedure TJobRec.SBSPopupMenu2Popup(Sender: TObject);
begin
  With ExLocal,LJobRec^ do
  Begin
    RSTMI1.Visible:=(JSTOurRef<>'') and (PChkAllowed_In(450));
    RPTMI1.Visible:=(JPTOurRef<>'') and (PChkAllowed_In(441));
    STMI1.Visible:=(PChkAllowed_In(453));
    PTMI1.Visible:=(PChkAllowed_In(452));
  end;
end;

procedure TJobRec.SBSPopupMenu3Popup(Sender: TObject);
begin
  Chk2.Visible:=(SBSIn or Debug);
  Chk3.Visible:=(SBSIn or Debug);
end;

procedure TJobRec.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;

procedure TJobRec.PropFlgClick(Sender: TObject);
begin
  {$IFDEF NP}
    If (Current_Page=NotesPage) then
    begin
      NotesCtrl.SetFormProperties;
      NeedCUpdate := True; //HV 21/04/2016 2016-R2 ABSEXCH-10691: When viewing a Job Record->Ledger Tab->resizing the columns can lead to losing the column header
    end
    else
  {$ENDIF}
      SetFormProperties;
end;

procedure TJobRec.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;

procedure TJobRec.DelCP1BtnClick(Sender: TObject);
begin
  Case Current_Page of
    NotesPage  :  DelCp3BtnClick(Sender);
    PRetenPage,
    SRetenPage:  EditRetRec(Sender,(Current_Page=SRetenPage));

    CTermPage,
    SAppsPage :  DeleteDoc;

    else  DeleteAccount;
  end; {case..}

end;

procedure TJobRec.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
    LockWindowUpDate(Handle);
  end;
end;

procedure TJobRec.HidePanels(PageNo  :  Byte);

Var
  NomDayBk  :  Boolean;

Begin
  With MULCtrlO[PageNo],VisiList do
  Begin
    {SetHidePanel(FindxColOrder(3),(PageNo>SRetenPage),BOn);}

    Case PageNo of
      PRetenPage,SRetenPage  :  Begin
                                  RTAMLab.Caption:='Retention Amount';
                                  RTExLab.Caption:='Expires';
                                  RTACLab.Caption:='A/C Code';

                                  RTACPanel.HelpContext:=0;
                                  RTORefPanel.HelpContext:=0;
                                  RTDTPanel.HelpContext:=143;
                                  RTExPanel.HelpContext:=0;
                                  RTAMPanel.HelpContext:=0;

                                end;

      CTermPage..SAppsPage   :  Begin
                                  RTAMLab.Caption:='Budget Value';
                                  RTExLab.Caption:='Ref';

                                  If (PageNo=CTermPage) then
                                    RTACLab.Caption:='S/C Code'
                                  else
                                    RTACLab.Caption:='A/C Code';

                                  RTACPanel.HelpContext:=1520;
                                  RTORefPanel.HelpContext:=1509;
                                  RTDTPanel.HelpContext:=143;
                                  RTExPanel.HelpContext:=1521;
                                  RTAMPanel.HelpContext:=1522;

                                end;
    end;{Case..}

    RefreshAllCols;

  end;
end;




procedure TJobRec.PageControl1Change(Sender: TObject);

Var
  n         :  Byte;
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

      If (Not (NewIndex In [LedgerPage..SAppsPage])) or (MULCtrlO[NewIndex]<>nil)  then
        LockWindowUpDate(0);

      {$B+}

      DeleteSubMenu(Copy1);

      If (NewIndex In [LedgerPage,CTermPage..SAppsPage]) then
        BuildMenus;

      PrimeButtons;

      If (NewIndex In [LedgerPage..SAppsPage]) then
        CListBtnPanel.Parent:=ActivePage;


      Case NewIndex of

      {$IFDEF NP}

        NotesPage
           :  If (NotesCtrl=nil) then
              With ExLocal do
              Begin
                NotesCtrl:=TNoteCtrl.Create(Self);

                //TW 26/10/2011: Add Event handler for new note functionality.
                NotesCtrl.Caption:='Job Record '+Caption;
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

                  CoorPrime:='J';
                  CoorHasCoor:=LastCoord;

                end;

                try
                  NotesCtrl.WindowSettings := FSettings; //HV 21/04/2016 2016-R2 ABSEXCH-10691: When viewing a Job Record->Ledger Tab->resizing the columns can lead to losing the column header
                  NotesCtrl.CreateList(Self,NoteSetUp,NoteJCode,NoteCDCode,FullNCode(FullNomKey(LJobRec^.JobFolio)));
                  NotesCtrl.GetLineNo:=LJobRec^.NLineCount;
                  NotesCtrl.SwitchGenMode;
				  //TG 21-04-2017 ABSEXCH-17888 - The notes on Job Records are not working correctly
                  NotesCtrl.SwitchNoteMode(nmDated);
                except
                  NotesCtrl.Free;
                  NotesCtrl:=Nil
                end;

                MDI_UpdateParentStat;

              end
              else
              With ExLocal do
              begin
                If (FullNomKey(LJobRec^.JobFolio)<>NotesCtrl.GetFolio) then {* Refresh notes *}
                with NotesCtrl do
                Begin
                  RefreshList(FullNCode(FullNomKey(LJobRec^.JobFolio)),GetNType);
                  GetLineNo:=LJobRec^.NLineCount;
                end;
                SwitchNoteButtons(Self, NotesCtrl.NoteMode);
              end;
      {$ELSE}

         1  :  ;

      {$ENDIF}

        LedgerPage..SAppsPage
           : Begin
               Case NewIndex of
                 PRetenPage..SAppsPage
                    :  Begin
                         RTSBox.Parent:=PageControl1.ActivePage;
                       end;
               end; {case..}


               If (MULCtrlO[NewIndex]=nil) then
               Begin
                 Case NewIndex of
                   LedgerPage  :  LedgerBuildList(NewIndex,BOn);
                   PRetenPage..SAppsPage
                               :  RetenBuildList(NewIndex,BOn);
                 end; {Case..}

               end
               else
                 With EXLocal do
                 Begin
                   With MULCtrlO[NewIndex] do
                   Case NewIndex of
                     PRetenPage..SRetenPage
                        :  DisplayMode:=48+NewIndex;
                     CTermPage..SAppsPage
                        :  DisplayMode:=40+(NewIndex-CTermPage);
                   end; {Case..}

                   ChkStr:=MULCtrlO[NewIndex].SetCheckKey;

                   If (Not CheckKey(ChkStr,MULCtrlO[NewIndex].KeyRef,Length(ChkStr),BOn))  or (NewIndex In [CTermPage..SAppsPage]) then
                     RefreshList(BOn,BOff);

                   MULCtrlO[NewIndex].ReFresh_Buttons;
                 end;


             MULCtrlO[NewIndex].SetListFocus;

             HidePanels(NewIndex);

           end;


      end; {Case..}

      // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
      WindowExport.ReevaluateExportStatus;

      LockWindowUpDate(0);

      { CJS 21/08/2009 }
      LastSelectedTabSheet := PageControl1.ActivePage;
    end;
end;


procedure TJobRec.AddCP3BtnClick(Sender: TObject);
begin
  {$IFDEF NP}
    If (NotesCtrl<>nil) then
      NotesCtrl.AddEditNote((Sender=EditCP1Btn),(Sender=InsCP1Btn));
  {$ENDIF}
end;


procedure TJobRec.DelCP3BtnClick(Sender: TObject);
begin
  {$IFDEF NP}
    If (NotesCtrl<>nil) then
      NotesCtrl.Delete1Click(Sender);
  {$ENDIF}
end;

procedure TJobRec.GenCP3BtnClick(Sender: TObject);
var
  ListPoint : TPoint;
begin
  Case Current_Page of

  NotesPage :
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

  end; {Case..}


end;


procedure TJobRec.LedgerBuildList(PageNo     :  Byte;
                                    ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  StartPanel := nil;
  MULCtrlO[PageNo]:=TJLMList.Create(Self);
  MULCtrlO[PageNo].Name := 'List_' + IntToStr(PageNo);  //HV 21/04/2016 2016-R2 ABSEXCH-10691: When viewing a Job Record->Ledger Tab->resizing the columns can lead to losing the column header

  Try

    With MULCtrlO[PageNo] do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(CLORefPanel,CLORefLab);
          AddVisiRec(CLDatePanel,CLDateLab);
          AddVisiRec(CLACPanel,CLACLab);
          AddVisiRec(CLQOPanel,CLQOLab);
          AddVisiRec(CLALPanel,CLALLab);
          AddVisiRec(CLOOPanel,CLOOLab);
          AddVisiRec(CLUPPanel,CLUPLab);
          AddVisiRec(CLACCPanel,CLACCLab);

          // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
          ColAppear^[1].ExportMetadata := emtDate;
          ColAppear^[3].ExportMetadata := emtQuantity;
          ColAppear^[4].ExportMetadata := emtCurrencyAmount;
          ColAppear^[5].ExportMetadata := emtCurrencyAmount;
          ColAppear^[6].ExportMetadata := emtCurrencyAmount;


          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          LabHedPanel:=CLHedPanel;


          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;



      Find_LedgCoord(PageNo);

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=7;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [3..6]) then
        Begin
          DispFormat:=SGFloat;

          Case n of
            3  :  NoDecPlaces:=Syss.NoQtyDec;
            4,6:  NoDecPlaces:=Syss.NoCosDec;
            5  :  NoDecPlaces:=Syss.NoNetDec;
          end; {Case..}
        end;
      end;

      DisplayMode:=2;

      Filter[1,0]:=#1;

      ListLocal:=@ExLocal;
      SortView.ExLocal := ListLocal;

      ListCreate;

      GlobCMode:=BOff; {Needs to be set by committed mode}
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



procedure TJobRec.RetenBuildList(PageNo     :  Byte;
                                 ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  StartPanel := nil;
  MULCtrlO[PRetenPage]:=TJLMList.Create(Self);

  For n:=SRetenPage to SAppsPage do
    MULCtrlO[n]:=MULCtrlO[PRetenPage];

  Try

    With MULCtrlO[PageNo] do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(RTACPanel,RTACLab);
          AddVisiRec(RTORefPanel,RTORefLab);
          AddVisiRec(RTDtPanel,RTDtLab);
          AddVisiRec(RTExPanel,RTExLab);
          AddVisiRec(RTAMPanel,RTAMLab);
          AddVisiRec(RTSTPanel,RTSTLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          LabHedPanel:=RTHedPanel;

          SetHedPanel(ListOfSet);


        end;
      except
        VisiList.Free;

      end;



      Find_LedgCoord(PageNo);

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=5;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [4]) then
        Begin
          DispFormat:=SGFloat;

          Case n of
            4  :  NoDecPlaces:=2;
          end; {Case..}
        end;
      end;

      DisplayMode:=48+PageNo;

      ListLocal:=@ExLocal;


      ListCreate;

      GlobCMode:=BOff;   {Needs to be set by committed mode}
      {UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;}

      HighLiteStyle[1]:=[fsBold];

      Set_Buttons(CListBtnPanel);

      ReFreshList(Not FromHist,BOff);

    end; {With}

    DefaultPageReSize;

  Except

    MULCtrlO[PageNo].Free;
    MULCtrlO[PageNo]:=Nil;
  end;


end;



procedure TJobRec.RefreshList(ShowLines,
                                IgMsg      :  Boolean);

  Function ColName(Const ColumnName : ShortString; Const Variant : ShortString = 'JE') : ShortString;
  Begin // ColName
    Result := GetDBColumnName('JobDet.Dat', ColumnName, Variant)
  End; // ColName

  function BuildQuery(JobCode: string): string;
  var
    SubResult: string;
  begin
    with MULCtrlO[Current_Page].StkExtRecPtr^ do
    begin
      Result := Format(
                  '(RecPFix = ''%s'') AND (SubType = ''%s'') AND ' +
                  'CAST(SUBSTRING(var_code1, 2, 10) AS VARCHAR) = ''%s'' AND ',
                [JBRCode, JBECode, JobCode]);

      SubResult :=
                '(' +
                   ColName('jddt') + ' IN (' +
                   // PSOPSet
                   IntToStr(Ord(SOR)) + ', ' +
                   IntToStr(Ord(POR)) + ', ' +
                   IntToStr(Ord(SDN)) + ', ' +
                   IntToStr(Ord(PDN)) + ', ' +
                   {$IFNDEF STK}
                   // QuotesSet
                   IntToStr(Ord(SQU)) + ', ' +
                   IntToStr(Ord(PQU)) + ', ' +
                   {$ENDIF}
                   // JAPSplit
                   IntToStr(Ord(JCT)) + ', ' +
                   IntToStr(Ord(JST)) +
                  ') OR ' +
                  '(' + ColName('posted_run') + ' = ' + IntToStr(OrdPPRunNo) + ')' +
                ')';

      if not Level_Commit then
        SubResult := 'NOT (' + SubResult + ')';
      Result := Result + SubResult;
    end;
  end;

Const
  JACCMode :  Array[13..19] of Byte = (13,14,15,5,5,15,15);

Var
  KeyStart    :  Str255;

  LFnum,
  LKeyLen,
  KPath,
  CPage       :  Integer;

  WhereClause: string;
Begin
  CPage:=Current_Page;

  {$B-}
  If (CPage In [LedgerPage..SAppsPage]) and (Assigned(MULCtrlO[CPage])) then
  With MULCtrlO[CPage],ExLocal,LJobRec^ do
  {$B+}
  Begin
    LNHCtrl:=DDCtrl;

    KPath:=JDLedgerK;

    LFnum:=JDetlF;

    With ExLocal,LJobRec^,LNHCtrl do
    Begin

      Case CPage of

        LedgerPage
           :  Begin
                Case DDMode of
                  5,
                  6,7,13..20
                       :  Begin
                            KeyStart:=PartCCKey(JBRCode,JBECode)+Calc_DDKey(JobCode,Level_JACode,NHDDRecon,DDMode,Level_Cr,0,0);

                            NHCr:=Level_Cr;
                            NHTxCR:=Level_TxCr;

                            If (Not (DDMode In [5,7,14])) then
                              KPAth:=JDAnalK
                            else
                              If (DDMode<>5) then
                                KPath:=JDStkK
                              else
                                KPath:=JDHedK;

                            If (DDMode<13) and (DDMode<>5) then
                              DisplayMode:=DDMode-3
                            else
                              DisplayMode:=DDMode;

                            GlobCMode:=Level_Commit;
                          end;

                  else    KeyStart:=PartCCKey(JBRCode,JBECode)+FullJobCode(JobCode)+#1;

                end; {case..}

                If (NHNeedGExt) then
                Begin
                  If (StkExtObjPtr=nil) then
                  Begin
                    ExtObjCreate;

                  end;

                  Case DDMode of
                    13..20 :  Begin
                                KeyStart:=PartCCKey(JBRCode,JBECode)+Calc_DDKey(JobCode,Level_JACode,NHDDRecon,JACCMode[DDMode],Level_Cr,NHYr,NHPr);
                                SetJADefaults(KeyStart,LKeyLen,Calc_DDKey(JobCode,Level_JACode,NHDDRecon,JACCMode[DDMode],Level_Cr,NHYr,NHPr));

                                KeyStart:=Copy(KeyStart,1,LKeyLen);

                                If (DDMode In [15..19]) then
                                  KPath:=JDHedK;
                              end;

                  end; {Case..}



                  If (Not NHNeedGExt) then
                    ExtObjDestroy; {* Remove previous link *}

                end
                else
                  If (StkExtObjPtr<>nil) then
                    ExtObjDestroy; {* Remove previous link *}
            end;

        PRetenPage,SRetenPage
           :  Begin
                KeyStart:=PartCCKey(JBRCode,JBPCode)+FullJobCode(JobCode)+TradeCode[CPage=SRetenPage];

                Case CPage of
                  PRetenPage  :  DisplayMode:=51;
                  SRetenPage  :  DisplayMode:=52;
                end; {Case..}

              end;
        CTermPage..SAppsPage
           :  Begin
                KeyStart:=FullJAPJobKey(BOff,JobCode,(CPage<>PAppsPage),(CPage=SAppsPage));

                DisplayMode:=40+(CPage-CTermPage);

                LKeyLen:=Length(KeyStart)-1;
                LFnum:=InvF;
                KPath:=InvLYRefK;
              end;

      end; {Case..}
    end;

    If (Not (DDMode In [16,17])) and (LFnum<>InvF) then
      LKeyLen:=Length(KeyStart);

    IgnoreMsg:=IgMsg;

    { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
    if UseDefaultSortView then
      UseDefaultSortView := MulCtrlO[Current_Page].SortView.LoadDefaultSortView;

    { CJS 21/08/2009 -- Current_Page might have changed. Recheck. }
    if (Current_Page = LedgerPage) and (SortViewEnabled or UseDefaultSortView) then
    begin
      { CJS - 2012-07-24: ABSEXCH-12962 - Sort View SQL Mods }
      {SS 15/03/2016 2016-R2
       ABSEXCH-14565:Job Ledger Sort View does not work.
       Set HostListSearchKey to blank for Pervasive.}
      if (SQLUtils.UsingSQL) then
        SortView.HostListSearchKey := Copy(KeyStart, 3, LKeyLen - 3)
      else
        SortView.HostListSearchKey := '';

      SortView.HostListIndexNo   := KPath;
      SortView.NHCtrl            := LNHCtrl;
      SortView.Apply;
      SortView.Enabled := True;
      MulCtrlO[Current_Page].StartList(SortTempF, STFieldK, FullNomKey(MulCtrlO[Current_Page].SortView.ListID), '', '', 0, BOff);
      if MulCtrlO[Current_Page].SortView.Sorts[1].svsAscending then
        PageControl1.Pages[Current_Page].ImageIndex := 1
      else
        PageControl1.Pages[Current_Page].ImageIndex := 2;
    end
    else
    begin
      if SQLUtils.UsingSQL and (MULCtrlO[Current_Page].StkExtRecPtr <> nil) then
        WhereClause := BuildQuery(ExLocal.LJobRec^.JobCode)
      else
        WhereClause := '';
      StartList(LFnum,KPath,KeyStart,'','',LKeyLen,(Not ShowLines), WhereClause);
    end;


    IgnoreMsg:=BOff;
  end;

end;



procedure TJobRec.CLORefPanelMouseUp(Sender: TObject;
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




procedure TJobRec.CLORefLabMouseDown(Sender: TObject;
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


procedure TJobRec.CLORefLabMouseMove(Sender: TObject; Shift: TShiftState;
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

procedure TJobRec.Display_Trans(Mode  :  Byte);

Var
  DT         :  DocTypes;

  LAC        :  Str10;

  DispTrans  :  TFInvDisplay;
  DisplayOptions : TransactionDisplayOptionsSet;

Begin
  //PR: 19/01/2009 On Ledger tab don't allow double click to display transaction unless View button is enabled.
  if (Current_Page <> LedgerPage) or (Mode = 100) or ViewCP1Btn.Enabled then
  begin
    If (Mode=1) then
      With ExLocal,LJobRec^ do
      Begin
        LAC:='';
        If (Current_Page=SAppsPage) then
        Begin
          DT:=JST;
          LAC:=CustCode;
        end
        else
          DT:=JCT;

        Set_JPAJCT(Inv,Id,DT,LAC,JobCode,1,0);

        with TJobAppWizard.Create(Self) do
          Show;
      end
    else

    Begin
      If (DispTransPtr=nil) then
      Begin
        DispTrans:=TFInvDisplay.Create(Self);
        DispTransPtr:=DispTrans;
      end
      else
        DispTrans:=DispTransPtr;

        try

          With ExLocal,DispTrans do
          Begin
            If (Current_Page In [LedgerPage,CTermPage..SAppsPage]) then
              With MULCtrlO[Current_Page] do
              Begin
                If (Current_Page=LedgerPage) then
                  Link2Inv
                else
                  GetSelRec(BOff);

                AssignFromGlobal(InvF);

              if RestrictedEditOnly(Inv) then
                DisplayOptions := [GDPR_AllowPostedEdit]
              else
                DisplayOptions := [];

              end;

            LastDocHed:=LInv.InvDocHed;

            If ((LastFolio<>LInv.FolioNum) or (Mode<>100)) and (InHBeen) then
              Display_Trans(Mode,Inv.FolioNum,BOn,(Mode<>100), DisplayOptions);

          end; {with..}

        except

          DispTrans.Free;

        end;
    end; {Edit..}
  end;
end;



procedure TJobRec.ViewCP1BtnClick(Sender: TObject);
Var
  Modus       :  Byte;

  ListPoint   :  TPoint;

begin
  Case Current_Page of
    LedgerPage,CTermPage..SAppsPage
         :  With MULCtrlO[Current_Page] do
            If (ValidLine) then
            Begin
              RefreshLine(MUListBoxes[0].Row,BOff);

              InHBeen:=BOn;

              Modus:=2;
              //PR: 12/02/2016 v2016 R1 ABSEXCH-17038 Add check for security hook point 155 (View)
              {$IFDEF CU}
              {$B-}
              if ((Modus = 2) and ValidSecurityHook(2000, 155, ExLocal)) then
              {$B+}
              {$ENDIF Customisation}
              Display_Trans(Modus);

            end;

    PRetenPage,SRetenPage
         :  Begin
              GetCursorPos(ListPoint);
              ScreenToClient(ListPoint);

              SBSPopupMenu1.PopUp(ListPoint.X,ListPoint.Y);
            end;

  end; {Case..}

end;

procedure TJobRec.HistCP1BtnClick(Sender: TObject);

Var
  ListPoint   :  TPoint;

begin
  GetCursorPos(ListPoint);
  ScreenToClient(ListPoint);

  SBSPopupMenu2.PopUp(ListPoint.X,ListPoint.Y);
end;


procedure TJobRec.PTMI1Click(Sender: TObject);
begin
  {$IFDEF JAP}

    Link_To_JT((TMenuItem(Sender).Tag=1));
  {$ENDIF}

end;

procedure TJobRec.RPTMI1Click(Sender: TObject);
begin
  {$IFDEF JAP}

    RemoveLink_To_JT((TMenuItem(Sender).Tag=1));
  {$ENDIF}

end;



procedure TJobRec.FindCP1BtnClick(Sender: TObject);

Var
  ListPoint   :  TPoint;
  ReturnCtrl  :  TReturnCtrlRec;


begin
  Case Current_Page of

   {$IFDEF GF}
    LedgerPage,CTermPage..SAppsPage
       :  With ReturnCtrl,MessageReturn do
          Begin
            FillChar(ReturnCtrl,Sizeof(ReturnCtrl),0);

            WParam:=3000;
            Msg:=WM_CustGetRec;
            DisplayxParent:=BOn;
            ShowOnly:=BOn;

            Pass2Parent:=BOn;

            LParam:=Current_Page;

            Ctrl_GlobalFind(Self,ReturnCtrl,2);

          end; {With..}
    {$ELSE}
      0  :  ;

   {$ENDIF}



  end; {Case..}
end;






procedure TJobRec.CopyCP1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  Case Current_Page of

    LedgerPage,CTermPage..SAppsPage
      : If (MULCtrlO[Current_Page]<>nil) and (Sender is TButton) then
         With MULCtrlO[Current_Page], TWinControl(Sender) do
         If (Not InListFind) then
         Begin
           ListPoint.X:=1;
           ListPoint.Y:=1;

           ListPoint:=ClientToScreen(ListPoint);

           PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
         end;

  end; {Case..}
end;


procedure TJobRec.Copy2Click(Sender: TObject);
begin
  If (Sender Is TMenuItem) then
  Begin

    Case Current_Page of
      LedgerPage,CTermPage..SAppsPage
       :  If (MULCtrlO[Current_Page]<>nil) then
            With MULCtrlO[Current_Page] do
              If (ValidLine) then
              Begin
                GetSelRec(BOff);

                if SQLCacheID <> 0 then
                  SyncUncachedRecord(MulCtrlO[Current_Page]);

                Link2Inv;
                ContraCopy_Doc(ExLocal.LInv.FolioNum,TMenuItem(Sender).Tag,'');

                if SQLCacheID <> 0 then
                  RefreshCache;

                PageUpDn(0,BOn);
              end;
    end; {Case..}
  end; {With..}

end;


procedure TJobRec.StatCp1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  Case Current_Page of

    MainPage
       : If (Sender is TButton) then
         With TWinControl(Sender) do
         Begin
           ListPoint.X:=1;
           ListPoint.Y:=1;

           ListPoint:=ClientToScreen(ListPoint);

           PopUpMenu3.PopUp(ListPoint.X,ListPoint.Y);
         end;

  end; {Case..}
end;



procedure TJobRec.PrintRetCr;
var
  //PR: 20/05/2014 ABSEXCH-2763
  Ok2Print : Boolean;
Begin
  Ok2Print := True;
  With ExLocal,JobDetl^.JobReten do
  Begin
    If LGetMainRecPosKey(InvF,InvOurRefK,RetCRDoc) then
    Begin
    {$IFDEF CU}
      If (EnableCustBtns(2000,151)) then
        Ok2Print := ExecuteCustBtn(2000,151,ExLocal);
    {$ENDIF}
      {$IFDEF FRM}
      if Ok2Print then
        With LInv do
          Control_DefProcess(DEFDEFMode[InvDocHed],
                             IdetailF,IdFolioK,
                             FullNomKey(FolioNum),ExLocal,BOn);
      {$ENDIF}
    end;
  end;
end;


procedure TJobRec.PrnCP1BtnClick(Sender: TObject);
var
  //PR: 20/05/2014 ABSEXCH-2763
  Ok2Print : Boolean;
begin
  Ok2Print := True;
  {$IFDEF FRM}
    With ExLocal do
    Case Current_Page of

      MainPage
           :  Begin
                Control_DefProcess(25,
                                   JobF,JobCodeK,
                                   FullJobCode(ExLocal.LJobRec^.JobCode),
                                   ExLocal,
                                   BOn);

              end;

      LedgerPage,CTermPage..SAppsPage
           :  With MulCtrlO[Current_Page] do
              If ValidLine then
              Begin
                GetSelRec(BOff);

                if SQLCacheID <> 0 then
                  SyncUncachedRecord(MulCtrlO[Current_Page]);

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

      PRetenPage,
      SRetenPage
            :  With MulCtrlO[Current_Page] do
                If ValidLine then
                  PrintRetCr;


    end; {Case..}

  {$ENDIF}
end;





procedure TJobRec.LnkCp1BtnClick(Sender: TObject);
{$IFDEF Ltr}
Var
  NKey    : String[4];
  OldCust : JobRecPtr;
{$ENDIF}
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

      { Save current customer record }
      New (OldCust);
      OldCust^ := JobRec^;

      With ExLocal.LJobRec^ Do Begin
        { Get Job's Customer }
        If CheckRecExsists(FullJobCode(ExLocal.LJobRec^.JobCode), JobF, JobCodeK) Then Begin
          LetterForm.LoadLettersFor (FullNomKey(JobFolio),           { Index Key }
                                     JobCode,                        { Caption }
                                     CodeToFName (JobCode),          { FName }
                                     LetterJobCode,
                                     Nil, Nil, Nil, ExLocal.LJobRec, Nil)
        End; { If }
      End; { With }

      { Restore original customer record }
      JobRec^ := OldCust^;
      Dispose(OldCust);
    Except
     LetterActive := BOff;
     LetterForm.Free;
    End;
  {$ENDIF}
end;


{ === Func to check if a job can be closed === }

Function TJobRec.HasUnPosted(JCode  :  Str20;
                             Warn   :  Boolean)  :  Boolean;


Const
  Fnum      =  JDetlF;
  Keypath   =  JDPostedK;

Var

  KeyChk,
  KeyS      :  Str255;

  Loop      :  Boolean;
  ChkRunNo  :  LongInt;


Begin
  ChkRunNo:=0; Loop:=BOff;


  Repeat
    KeyChk:=PartCCKey(JBRCode,JBECode)+FullNomKey(ChkRunNo)+FullJobCode(JCode);

    KeyS:=KeyChk;

    With ExLocal do
    Begin
      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

      Result:=(StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));

      Repeat
        Application.ProcessMessages;

        If (LJobDetl^.JobActual.JDDT In PSOPSET) and (Result) then
        Begin
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

          Result:=(StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));
        end;

      Until (Not Result) or (Not (LJobDetl^.JobActual.JDDT In PSOPSET));

    end;

    Loop:=Not Loop;

    ChkRunNo:=OrdPPRunNo;

  Until (Result) or (Not Loop);

  If (Result) and (Warn) then
  Begin
    CustomDlg(Self,'Please note!','Unposted Job entries',
                 'The Work In Progress for this Job cannot be transferred whilst'+
                 ' unposted entries exist in the job daybook for it.'+#13+#13+
                 'Please post these entries before attempting to transfer the Work In Progress.',
                 mtInformation,
                 [mbOk]);

  end;

end;


{ ==== Set Current Status ==== }

Procedure TJobRec.Set_JobStat(Fnum,
                              Keypath,
                              NewStat  :  Integer);


Var
  LOk,
  Sure     :  Boolean;

  MbRet    :  Word;

  KeyS     :  Str255;



Begin

  Sure:=BOff;  mbRet:=mrNone;

  With ExLocal do
  Begin
    LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

    Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

    Report_BError(Fnum,Status);

    LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked);


    If (LOk) And (GlobLocked) then
    Begin

      With LJobRec^ do
      Begin

        If (Not (JobStat In [JobCompl,JobClosed])) and (NewStat In [JobCompl,JobClosed]) then
        Begin
          {$IFDEF CU}
            If (ValidExitHook(5000,110,ExLocal)) then
          {$ENDIF}
            mbRet:=MessageDlg('Please Confirm you wish to transfer all Work in progress',mtConfirmation,[mbYes,mbNo,mbCancel],0);

          Sure:=(mbRet=mrYes);

          If (Sure) then
            Sure:=Not HasUnPosted(JobCode,BOn);

          If (Sure) then
            JobStat:=NewStat;
        end
        else
          JobStat:=NewStat;
      end;

      OutJob;

      {* Update last edited flag *}

      If (mbRet<>mrCancel) then
        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      UnLockMLock(Fnum,LastRecAddr[Fnum]);

      Report_Berror(Fnum,Status);

    end; {If Locked ..}

    If (Sure) then
    Begin

        Close_Job(Self,LJobRec^.JobCode);

    end;
  end; {With..}
end; {Proc..}


procedure TJobRec.Quotation1Click(Sender: TObject);
begin
  Set_JobStat(JobF,CurrKeyPath^[JobF],TMenuItem(Sender).Tag);

  //TW 07/11/2011 Add Edit audit note if status update is successful.
  if(status = 0) then
    TAuditNote.WriteAuditNote(anJob, anEdit, ExLocal);
end;


{ =============== Procedure to Find Next Availabel Code ============ }

Function Auto_GetJCode(CCode    :  Str20;
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
  TmpJob
        :  JobRecType;

  NewNo :  Str10;

  LCode :  Str20;

  PadLen,
  LLen,
  n     :  Word;



Begin


  TmpJob:=JobRec^;

  TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOff,BOff);

  LCode:=Trim(CCode);

  LLen:=Length(LCode);

  n:=IntStr(Copy(LCode,LLen-1,2));

  UseNumber:=(n<>0);

  Repeat

    KeyS:=FullJobCode(CCode);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    If (StatusOk) then
    Begin

      Inc(n);

      NewNo:=Form_Int(n,0);

      PadLen:=2+Ord(n>99);


      If (LLen<=(JobKeyLen-PadLen)) then
        CCode:=Copy(LCode,1,LLen-(2*Ord(UseNumber)))+SetPadNo(NewNo,PadLen)
      else
        CCode:=Copy(CCode,1,JobKeyLen-PadLen)+SetPadNo(NewNo,PadLen);

    end;

  Until (Not StatusOk) or (n=999);

  TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOn,BOff);

  JobRec^:=TmpJob;

  Auto_GetJCode:=FullJobCode(CCode);

end; {Func..}

procedure TJobRec.SRCFEnter(Sender: TObject);
begin
  {$IFDEF CU}
    If (Not SRCF.ReadOnly) and (Sender=SRCF) and (ActiveControl<>CanCP1Btn) and (Not ExLocal.LastEdit) then
    Begin
      SRCF.Text:=TextExitHook(5000,77,SRCF.Text,ExLocal);
    end;
  {$ENDIF}

end;

procedure TJobRec.SRCFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str20;


begin

  If (Sender is TMaskEdit) and (ActiveControl<>CanCP1Btn) then
  With (Sender as TMaskEdit),ExLocal do
  Begin
    {$IFDEF XCUX} {*For future use with a hook }
      If (Not ReadOnly) then
        Text:=TextExitHook(3000,1,Trim(Text),ExLocal);
    {$ENDIF}


    CCode:=UpCaseStr(FullJobCode(Text));

    If ((Not LastEdit) or (LastJobRec^.JobCode<>CCode)) and (InAddEdit) then
    Begin
      COk:=(Not Check4DupliGen(CCode,JobF,JobCodeK,'Record ('+Strip('B',[#32],CCode)+')'));

      If (Not COk) then
      Begin

        Text:=Auto_GetJCode(CCode,JobF,JobCodeK);

        ChangePage(0);

        SRCF.SetFocus;

        StopPageChange:=BOn;


      end
      else
        StopPageChange:=BOff;


    end;
  end;
end;



procedure TJobRec.JTyFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn)  {and (Not JobContract) v4.31} then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetJobMisc(Self.Owner,FoundCode,FoundCode,1,99));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        JTDF.Text:=JobMisc^.JobTypeRec.JTypeName;

      end;


      If (FoundOk) then
      With ExLocal,LId do
      Begin

        StillEdit:=BOff;

        Text:=Trim(FoundCode);
      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;




procedure TJobRec.JACCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Text;

    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) {and (Not JobContract)} then
    Begin

      StillEdit:=BOn;

      //PR: 26/09/2013 MRD 1.1.15/16 Set HideConsumers parameter to True.
      FoundOk:=(GetCust(Self.Owner,FoundCode,FoundCode,BOn,0, -1, HIDE_CONSUMERS));


      If (FoundOk) then
      With ExLocal do
      Begin

        StillEdit:=BOff;


        ExLocal.AssignFromGlobal(CustF);

        If (Not LastEdit) then
        Begin
          If (JCoF.Text='') then
            JCoF.Text:=LCust.Contact;

          {$IFDEF MC_On}
            If (LCust.Currency<>0) then
              SRSPC1F.ItemIndex:=Pred(LCust.Currency);
          {$ENDIF}

        end;

        JACDF.Text:=LCust.Company;
        
        Text:=FoundCode;

        SendToObjectCC(FoundCode,0);
      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;


procedure TJobRec.Id3CCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Name;

    IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (Syss.UseCCDep) and (Not ReadOnly) then
    Begin

      // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules.
      // Cost Centre / Department defaults are optional, so don't force the user
      // to enter them, but validate the input if the user does enter something.
      if (FoundCode <> '') then
      begin
        StillEdit:=BOn;
        //TG 15-05-2017 2017 R2 18699 - Access Violation message - creating Job Record using inactive CC/Dept
        // Mode 2 has to sent instead of 0
        FoundOk:=(GetCCDep(Self.Owner,FoundCode,FoundCode,IsCC,2));


        If (FoundOk) then
        Begin

          StillEdit:=BOff;

          Text:=FoundCode;


        end
        else
        Begin

          SetFocus;
        end; {If not found..}
      end;
    end
    else
      If (AltMod) and (FoundCode='') then
        Text:='';

  end; {with..}
end;



procedure TJobRec.JACDFDblClick(Sender: TObject);
begin
  JACCF.DblClick;
end;

procedure TJobRec.JSOFDblClick(Sender: TObject);
Var
  KeyI  :  Str255;

begin
  KeyI:=FullOurRefKey(JSOF.Text);

  Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyI);

  If StatusOk then
  Begin
    InHBeen:=BOn;
    Display_Trans(2);
  end;
end;

procedure TJobRec.JSOFExit(Sender: TObject);

Var
  AltMod  :  Boolean;

  FoundCode
          :  String;
          
begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn) and (Not JobContract) then
    Begin
      If (FoundCode[Length(FoundCode)] In ['0'..'9']) then
        Text:=AutoSetInvKey(FoundCode,0);
    end;
  end; {with..}
end;

procedure TJobRec.JUD1FEntHookEvent(Sender: TObject);
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
          If (Sender=JUD1F) then
          Begin
            ExLocal.LJobRec^.UserDef1:=Text;
            CUUDEvent:=1;
          end
          else
            If (Sender=JUD2F) then
            Begin
              ExLocal.LJobRec^.UserDef2:=Text;
              CUUDEvent:=2;
            end
            else
              If (Sender=JUD3F) then
              Begin
                ExLocal.LJobRec^.UserDef3:=Text;
                CUUDEvent:=3;
              end
              else
                If (Sender=JUD4F) then
                Begin
                  ExLocal.LJobRec^.UserDef4:=Text;
                  CUUDEvent:=4;
                end
                else
                //GS 25/10/2011 ABSEXCH-11706: create branches for the new UDFs
                //there is a 30 offset; event values are adjucted accordingly
                If (Sender=JUD5F) then
                Begin
                  ExLocal.LJobRec^.UserDef5:=Text;
                  CUUDEvent:=(211 - 30);
                end
                else
                  If (Sender=JUD6F) then
                  Begin
                    ExLocal.LJobRec^.UserDef6:=Text;
                    CUUDEvent:=(212 - 30);
                  end
                  else
                    If (Sender=JUD7F) then
                    Begin
                      ExLocal.LJobRec^.UserDef7:=Text;
                      CUUDEvent:=(213 - 30);
                    end
                    else
                      If (Sender=JUD8F) then
                      Begin
                        ExLocal.LJobRec^.UserDef8:=Text;
                        CUUDEvent:=(214 - 30);
                      end
                      else
                      //GS 14/12/2011 ABSEXCH-12274: fixed bug: Text value was being put into UserDef7/8
                      //should be UserDef9/10 was causing input into UDF 9 & 10 to 'disappear'
                      If (Sender=JUD9F) then
                      Begin
                        ExLocal.LJobRec^.UserDef9:=Text;
                        CUUDEvent:=(215 - 30);
                      end
                      else
                        If (Sender=JUD10F) then
                        Begin
                          ExLocal.LJobRec^.UserDef10:=Text;
                          CUUDEvent:=(216 - 30);
                        end
                else
                  If (Sender=JQSCodeF) then
                  Begin
                    ExLocal.LJobRec^.JQSCode:=Text;
                    CUUDEvent:=8;
                  end;



          Result:=IntExitHook(5000,30+CUUDEvent,-1,ExLocal);

          If (Result=0) then
            SetFocus
          else
          With ExLocal do
          If (Result=1) then
          Begin
            Case CUUDEvent of
              1  :  Text:=LJobRec^.UserDef1;
              2  :  Text:=LJobRec^.UserDef2;
              3  :  Text:=LJobRec^.UserDef3;
              4  :  Text:=LJobRec^.UserDef4;
              //GS 25/10/2011 ABSEXCH-11706: put customisation object vals into UDFs
              (211 - 30)  : Text:=LJobRec^.UserDef5;
              (212 - 30)  : Text:=LJobRec^.UserDef6;
              (213 - 30)  : Text:=LJobRec^.UserDef7;
              (214 - 30)  : Text:=LJobRec^.UserDef8;
              (215 - 30)  : Text:=LJobRec^.UserDef9;
              (216 - 30)  : Text:=LJobRec^.UserDef10;
              8  :  Text:=LJobRec^.JQSCode;
            end; {Case..}
          end;
        end;
     end; {With..}

  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;

procedure TJobRec.JUD1FExit(Sender: TObject);
begin
   If (Sender is Text8Pt)  and (ActiveControl<>CanCP1Btn) then
    Text8pt(Sender).ExecuteHookMsg;
end;

procedure TJobRec.ViewR1Click(Sender: TObject);
Var
  KeyI  :  Str255;

begin
  With MULCtrlO[Current_Page] do
  If (ValidLine) then
  With JobDetl^.JobReten do
  Begin

    If (TMenuItem(Sender).Tag=1) then
      KeyI:=RetDoc
    else
      KeyI:=RetCrDoc;

    InHBeen:=CheckRecExsists(KeyI,InvF,InvOurRefK);

    If (InHBeen) then
      ExLocal.LInv:=Inv;

    //PR: 12/02/2016 v2016 R1 ABSEXCH-17038 Add check for security hook point 155 (View)
    {$IFDEF CU}
    if ValidSecurityHook(2000, 155, ExLocal) then
    {$ENDIF Customisation}
      Display_Trans(2);

  end;
end;


{ ======= Retention based control ======= }

procedure TJobRec.Display_RetRec(Mode     :  Byte;
                                 IsSales  :  Boolean);

Var
  WasNew  :  Boolean;
  TRetRec :  TJCRetFrm;


  Begin
    WasNew:=BOff;

    With ExLocal do
    Begin
      Set_JRFormMode(IsSales);
    end;


    If (RetRecPtr[IsSales]=nil) then
    Begin
      TRetRec:=TJCRetFrm.Create(Self);

      WasNew:=BOn;

      RetRecPtr[IsSales]:=TRetRec;
    end
    else
      TRetRec:=RetRecPtr[IsSales];

    Try


     With TRetRec do
     Begin
       If (Mode=1) then
         ResetRec(JDetlF);

       ExLocal.AssignFromGlobal(JDetlF);
       ExLocal.LJobRec^:=Self.ExLocal.LJobRec^;
       ExLocal.LCust:=Self.ExLocal.LCust;

       WindowState:=wsNormal;


       Case Mode of
         1,2  :  Begin
                   If (ACFF.CanFocus) then
                     ACFF.SetFocus;

                   {FieldNextFix(Handle,ActiveControl,CompF); {* Added so that qty is auto selected *}
                 end;
       end;

       If (Mode In [1..3]) then
       Begin

         Case Mode of

           1..2  :   If (Not ExLocal.InAddEdit) then
                       EditLine((Mode=2))
                     else
                       Show;
              3  :  If (Not ExLocal.InAddEdit) then
                       DeleteBOMLine(JDetlF,JDLedgerK);
                     else
                       Show;

         end; {Case..}

       end;



     end; {With..}


    except

     TRetRec.Free;
     RetRecPtr[IsSales]:=nil;

    end;

  end;


procedure TJobRec.EditRetRec(Sender  : TObject;
                             IsSales : Boolean);

Var
  EMode  :  Byte;

Begin
  EMode:=1*Ord((Sender = AddCP1Btn) or (Sender = Add1)) +
         2*Ord((Sender = EditCP1Btn) or (Sender = Edit1))+
         3*Ord((Sender = DelCP1Btn) or (Sender = Delete1));

  {$B-}
  If (EMode=1) or (MULCtrlO[PRetenPage+Ord(IsSales)].ValidLine) then
  {$B+}
    Display_RetRec(EMode, IsSales);
end;




procedure TJobRec.CustdbBtn1Click(Sender: TObject);
Var
  PageNo  :  Integer;
  ExecuteHook        : Boolean;
  // 23/01/2013 PKR ABSEXCH-13449
  customButtonNumber : integer;
begin
  ExecuteHook := False;
  customButtonNumber := 0;

  PageNo:=Current_Page;

  {$IFDEF CU}
    {$B-}

    If (PageNo=LedgeRPage) and  (Assigned(MULCtrlO[PageNo])) then

    {$B+}

    With MULCtrlO[PageNo],ExLocal do
    Begin
      If (ValidLine) then
      Begin
        LInv:=Inv;

        If (LCust.CustCode<>Inv.CustCode) then
          LGetMainRecPos(CustF,Inv.CustCode);

        ExecuteHook:=BOn;
      end;
    end {With..}
    else
    Begin
      ExecuteHook:=(PageNo=MainPage);

      With ExLocal Do
        If (LCust.CustCode<>LJobRec.CustCode) and (ExecuteHook) then
          LGetMainRecPos(CustF,LJobRec.CustCode);

    end;

    
    If (ExecuteHook) then
    With ExLocal do
    Begin
      // 23/01/2013 PKR ABSEXCH-13449
      if Sender is TSBSButton then
        customButtonNumber := (Sender as TSBSButton).Tag;
      if Sender is TMenuItem then
        customButtonNumber := (Sender as TMenuItem).Tag;
      
      custBtnHandler.CustomButtonClick(fpJobRecord,
                                       PageNo,
                                       rsAny,
                                       customButtonNumber,
                                       ExLocal);

//      ExecuteCustBtn(5000,((10+PageNo)*Ord((Sender=CustdbBtn1) or (Sender=Custom1)))+
//                    ((20+PageNo)*Ord((Sender=CustdbBtn2) or (Sender=Custom2))), ExLocal);

    end;
  {$ENDIF}
end;


procedure TJobRec.ChkCP1BtnClick(Sender: TObject);

Var
  ListPoint   :  TPoint;

begin
    If (SBSIn) or (Debug) then
    Begin
      If (Not (Sender is TMEnuItem)) then
      Begin
        GetCursorPos(ListPoint);
        ScreenToClient(ListPoint);

        SBSPopupMenu3.PopUp(ListPoint.X,ListPoint.Y)
      end;
    end
    else
      Chk1Click(Chk1);


end;

procedure TJobRec.Chk1Click(Sender: TObject);
Var
  CMode  :  Byte;
begin
  {$IFDEF POST}
    {$IFDEF JC}
       With ExLocal do
       If (LJobRec^.JobType<>JobGrpCode) then
       Begin
         CMode:=TMenuItem(Sender).Tag;

         AddJobPost2Thread(Application.MainForm,CMode,JobRec^.JobCode,Nil,Self.Handle);

         If (CMode<>41) then {* Auto Run check to refresh job totals *}
           AddJobPost2Thread(Application.MainForm,41,JobRec^.JobCode,Nil,Self.Handle);

         SendMessage(Self.Handle,WM_Close,0,0);
       end
       else
         ShowMessage('You can only check jobs, not contracts');
    {$ENDIF}
  {$ENDIF}
end;



procedure TJobRec.JMGFExit(Sender: TObject);
Var
  Result  :  LongInt;
begin
  Result:=0;

  {$IFDEF CU} {*For future use with a hook }
      With JMGF do
      If (Not ReadOnly) then
      Begin
        ExLocal.LJobRec^.JobMan:=Trim(Text);

        Result:=IntExitHook(5000,78,-1,ExLocal);

        If (Result=0)  then
          SetFocus
        else
          With ExLocal do
            If (Result=1) then {* If this needs extending to the job code, could do with setting up a handler like CustR3U.pas has}
              Text:=LJobRec^.JobMan;

      end;
  {$ENDIF}

end;


{$IFDEF JAP}
  { ======= Link to Trans display ======== }

  procedure TJobRec.Display_GlobalTrans(Mode  :  Byte);

  Var
    KeyS  :  Str255;

  Begin

    With TFInvDisplay.Create(Application.MainForm) do
    Begin
      ExLocal.AssignToGlobal(InvF);
      try

        KeyS:=ExLocal.LInv.OurRef;

        With ExLocal do
        If (Find_Rec(B_GetEq,F[InvF],InvF,LRecPtr[InvF]^,InvOurRefK,KeyS)=0) then
        Begin

          LastDocHed:=LInv.InvDocHed;

          Display_Trans(Mode,0,BOff,BOn);

        end; {with..}

      except

        Free;

      end;
    end;

  end;


  procedure TJobRec.Link_To_JT(SalesMode  :  Boolean);

  Const
    Fnum  =  JobF;
    BudgetCaption  :  Array[BOff..BOn] of Str20 = ('Labour/Materials','Revenue');

  Var
    ShowTrans,
    LOk   :  Boolean;

    Keypath
          :  Integer;

    JobAddr
          :  LongInt;

    KeyL  :  Str255;

    UseBudget
          :  TModalResult;

    AddMode
          :  Boolean;

    JcRec :  tJAppWizRec;

  Begin
    ShowTrans:=BOff; UseBudget:=mrOk;

    With ExLocal,LJobRec^ do
    begin
      If (SalesMode) then
        KeyL:=JSTOurRef
      else
        KeyL:=JPTOurRef;

      Keypath:=CurrKeyPath^[Fnum];

      {$B-}
         AddMode:=(KeyL='') or (Find_Rec(B_GetEq,F[InvF],InvF,LRecPtr[InvF]^,InvOurRefK,KeyL)<>0);
      {$B+}

      If (AddMode) then
      Begin
        Blank(JcRec,Sizeof(JcRec));

        UseBudget:=MessageDlg({'Use Job Budgets','Base Terms on Job Budget',}
                   'Do you wish to base the '+DocGroup[1+Ord(SalesMode)]+' Term Budgets on the Job '+BudgetCaption[SalesMode]+' Budgets?',
                   mtConfirmation,
                   [mbYes,mbNo,mbCancel],0);

        If (UseBudget<>mrCancel) then
        Begin
          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          Report_BError(Fnum,Status);

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyL,KeyPAth,Fnum,BOff,GlobLocked);


          If (LOk) And (GlobLocked) then
          Begin
            With JcRec do
            Begin
              awDate:=Today;
              awPCurr:=CurrPrice;
              awJobCode:=JobCode;
              awMaster:=BOn;
              awJSTFromBudget:=(UseBudget=mrYes);

              If (SaleSMode) then
              Begin
                awACode:=CustCode;
                awDT:=JST
              end
              else
              Begin
                awDT:=JPT;
                awBasis:=0;
              end;
            end;

            If Generate_JAFromJT(1,JcRec,ExLocal) then
            Begin
              LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

              Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

              If (SalesMode) then
                JSTOurRef:=LInv.OurRef
              else
                JPTOurRef:=LInv.OurRef;

              Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

              Report_Berror(Fnum,Status);

              ShowTrans:=StatusOk;
            end;

            UnLockMLock(Fnum,LastRecAddr[Fnum]);
          end;

        end;
      end
      else
        ShowTrans:=BOn;

      If (ShowTrans) then
        Display_GlobalTrans(2);
    end;
  end;

  procedure TJobRec.RemoveLink_To_JT(SalesMode  :  Boolean);

  Const
    Fnum  =  JobF;

  Var
    ShowTrans,
    LOk   :  Boolean;

    Keypath
          :  Integer;

    JobAddr
          :  LongInt;

    KeyL  :  Str255;

    UseBudget
          :  TModalResult;

    DelMode
          :  Boolean;

    JcRec :  tJAppWizRec;

  Begin
    ShowTrans:=BOff; UseBudget:=mrOk;

    With ExLocal,LJobRec^ do
    begin
      If (SalesMode) then
        KeyL:=JSTOurRef
      else
        KeyL:=JPTOurRef;

      Keypath:=CurrKeyPath^[Fnum];

      {$B-}
         DelMode:=(KeyL<>'') and (Find_Rec(B_GetEq,F[InvF],InvF,LRecPtr[InvF]^,InvOurRefK,KeyL)=0);
      {$B+}

      If (DelMode) then
      Begin
        If (Delete_Application(LInv,BOn,InvF,InvOurRefK,ExLocal)) then
        Begin
          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          Report_BError(Fnum,Status);

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyL,KeyPAth,Fnum,BOff,GlobLocked);


          If (LOk) And (GlobLocked) then
          Begin
            If (SalesMode) then
              Blank(JSTOurRef,Sizeof(JSTOurRef))
            else
              Blank(JPTOurRef,Sizeof(JPTOurRef));

            Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

            Report_Berror(Fnum,Status);

            Status:=UnLockMLock(Fnum,LastRecAddr[Fnum]);

          end;


        end;

      end;
    end;
  end;

{$ENDIF}



procedure TJobRec.Display_EmplAccount(Mode  :  Byte);

Var
  CPage      :  Integer;

  TSBtn      :  TObject;

  EmplRecForm:  TJEmpRec;


Begin
  GlobPRateMode:=2;
  GlobJCode:=ExLocal.LJobRec^.JobCode;
  
  ExLocal.AssignToGlobal(JobF);

  If (EmplRecFormPtr=nil) then
  Begin

    {Set_CustFormMode(1-CPage);}

    EmplRecForm:=TJEmpRec.Create(Self);
    EmplRecFormPtr:=EmplRecForm;

  end
  else
    EmplRecForm:=EmplRecFormPtr;


  Try

   With EmplRecForm do
   Begin
     ExLocal.LJobRec^:=Self.ExLocal.LJobRec^;
     
     WindowState:=wsNormal;

     RateJCode:=FullJobCode(ExLocal.LJobRec^.JobCode);

     {CanDelete:=BOff;}


     Case Mode of

       8     :  ChangePage(3);

     end;



   end; {With..}


  except

   EmplRecForm.Free;
   EmplRecFormPtr:=nil;

  end;

  GlobPRateMode:=0;
end;

procedure TJobRec.TRCP1BtnClick(Sender: TObject);
begin
  Display_EmplAccount(8);
end;




function TJobRec.AllowFunction(WhichFunc: Integer): Boolean;
//This function checks which functions the user is allowed to access. It is called each time a new record is selected.
//Possible functions are View, Print, Copy.
var
  iAccess : Integer;
begin
  iAccess := 0;
  Result := not Syss.UsePasswords or (Current_Page <> LedgerPage);
  if not Result then
  begin
    Case WhichFunc of
      lbPrint : Case Inv.InvDocHed of
                SIN..SRI
                      : iAccess := uaPrintSIN;
                PIN..PPI
                      : iAccess := uaPrintPIN;
                  NMT : iAccess := uaPrintNMT;
                  ADJ : iAccess := uaPrintADJ;
                  SOR : iAccess := uaPrintSOR;
                  POR : iAccess := uaPrintPOR;
                  WOR : iAccess := uaPrintWOR;
                  SRN : iAccess := uaPrintSRN;
                  PRN : iAccess := uaPrintPRN;
                  TSH : iAccess := uaTSHDaybook;
                  else
                    Result := True;
                end;
      lbCopy  : Case Inv.InvDocHed of
                SIN..SRI
                      : iAccess := uaCopySIN;
                PIN..PPI
                      : iAccess := uaCopyPIN;
                  NMT : iAccess := uaCopyNMT;
                  ADJ : iAccess := uaCopyADJ;
                  SOR : iAccess := uaCopySOR;
                  POR : iAccess := uaCopyPOR;
                  WOR : iAccess := uaCopyWOR;
                  SRN : iAccess := uaCopySRN;
                  PRN : iAccess := uaCopyPRN;
                  TSH : iAccess := uaTSHDaybook;
                  else
                    Result := True;
                end;
      lbView,
      lbLinks : Case Inv.InvDocHed of
                SIN..SRI
                      : iAccess := uaSINDaybook;
                PIN..PPI
                      : iAccess := uaPINDaybook;
                  NMT : iAccess := uaNMTDaybook;
                  ADJ : iAccess := uaADJDaybook;
                  SOR : iAccess := uaSORDaybook;
                  POR : iAccess := uaPORDaybook;
                  WOR : iAccess := uaWORDaybook;
                  SRN : iAccess := uaSRNDaybook;
                  PRN : iAccess := uaPRNDaybook;
                  TSH : iAccess := uaTSHDaybook;
                  else
                    Result := True;
                end;
    end; //Case
    if not Result then
      Result := ChkAllowed_In(iAccess);
  end; //if not result
end;

procedure TJobRec.EnableLedgerButtons;
//PR: 19/01/2009 Enable/disable buttons on Ledger tab according to DocType and User's access rights. Buttons available are
//View, Print, Copy, Links. View checks Access to Daybook password. Print and Copy have their own passwords,
//(except for Timesheets.) If View isn't allowed then none of the others are. Links is only enabled if View is.
begin
  ViewCP1Btn.Enabled := AllowFunction(lbView);

  PrnCP1Btn.Enabled  := ViewCP1Btn.Enabled and AllowFunction(lbPrint);
  CopyCP1Btn.Enabled := ViewCP1Btn.Enabled and AllowFunction(lbCopy);
  LnkCp1Btn.Enabled  := ViewCP1Btn.Enabled;
end;

procedure TJobRec.ShowSortViewDlg;
var
  Dlg: TSortViewOptionsFrm;
begin
  Dlg := TSortViewOptionsFrm.Create(nil);
  Dlg.SortView := MULCtrlO[Current_Page].SortView;
  try
    if (Dlg.ShowModal = mrOk) then
    begin
      { CJS 2012-08-21 - ABSEXCH-12958 - Auto-Load default Sort View }
      { CJS 2013-10-04 - ABSEXCH-14566 - enable Sort View }
      MULCtrlO[Current_Page].SortView.Enabled := True;
      RefreshList(True, False);
    end
  finally
    Dlg.Free;
  end;
end;

procedure TJobRec.SortViewBtnClick(Sender: TObject);
var
  Dlg: TSortViewOptionsFrm;
  FuncRes: Integer;
  MenuPoint: TPoint;
begin
  if (not MulCtrlO[Current_Page].SortView.IsBuildingFile) then
  begin
    if (Sender is TButton) and MulCtrlO[Current_Page].SortViewEnabled then
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

procedure TJobRec.RefreshView1Click(Sender: TObject);
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

procedure TJobRec.CloseView1Click(Sender: TObject);
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
    RefreshList(True, False);
  end;
  PageControl1.Pages[Current_Page].ImageIndex := -1;
end;

procedure TJobRec.SortViewOptions1Click(Sender: TObject);
begin
  ShowSortViewDlg;
end;

procedure TJobRec.SyncUncachedRecord(ForList: TJLMList);
{
  The Job Ledger uses a prefilled cache as a replacement for Get Extended calls.
  Routines which make use of generic Btrieve access routines will bypass the
  prefilled cache used by the list. To get round this, we will get the record
  position of the current record in the prefilled cache, and then locate this
  record in the standard cache, so that the routines update the correct record.
}
var
  FuncRes: LongInt;
  RecAddr: LongInt;
begin
  with ForList do
  begin
    if (SQLCacheID <> 0) and not SortViewEnabled then
    begin
      with JobDetl^.JobActual do
      begin
        UseCustomPrefillCache(SQLCacheID);
        FuncRes := GetPos(F[JDetlF], JDetlF, RecAddr);
        if (FuncRes <> 0) then
          MessageDlg('Failed to get record address, error #' + IntToStr(FuncRes),
                     mtError, [mbOk], 0)
        else
        begin
          Move(RecAddr, ExLocal.LRecPtr[JDetlF]^, SizeOf(RecAddr));
          FuncRes := GetDirect(F[JDetlF], JDetlF, ExLocal.LRecPtr[JDetlF]^, 0, 0);
          if (FuncRes <> 0) then
            MessageDlg('Failed to set record address, error #' + IntToStr(FuncRes),
                       mtError, [mbOk], 0)
        end;
      end;
    end;
  end;
end;

procedure TJobRec.MenItem_AuditClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmAudit);
end;

procedure TJobRec.MenItem_DatedClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmDated);
end;

procedure TJobRec.MenItem_GeneralClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmGeneral);
end;

procedure TJobRec.SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
begin
  //Called when user uses Switch from pop-up menu on Notes form
  AddCP1Btn.Enabled := NewMode <> nmAudit;
  EditCP1Btn.Enabled := NewMode <> nmAudit;
  InsCP1Btn.Enabled := NewMode <> nmAudit;
  DelCP1Btn.Enabled := NewMode <> nmAudit;
end;
//set anonymisation status
procedure TJobRec.SetAnonymisationON(AValue: Boolean);
begin
  FAnonymisationON := AValue;
  SetAnonymisationBanner;
end;
// set anonymisation banner
procedure TJobRec.SetAnonymisationBanner;
begin
  {$IFNDEF EXDLL}
    if FAnonymisationON then
    begin
      PageP.Y := 44;
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

      PageP.Y := 3;
    end;

    if FListScanningOn then
    begin
      PageP.Y:= InitSize.Y - PageControl1.Height;
      FListScanningOn := False;
    end;

    pnlAnonymisationStatus.Visible := FAnonymisationON;
    StatCP1Btn.Enabled := not FAnonymisationON;  // disable the status button for anaonymised job
    if pnlAnonymisationStatus.Visible then
    begin
      //change the color of anonymisation controls
      with SystemSetup.GDPR do
      begin
        shpNotifyStatus.Brush.Color := NotificationWarningColour;
        shpNotifyStatus.Pen.Color := shpNotifyStatus.Brush.Color;
        lblAnonStatus.Font.Color := NotificationWarningFontColour;
      end;
      //update the anonymisation Date
      lblAnonStatus.Caption := Format(capAnonymisedStatus, [POutDate(JobRec^.jrAnonymisedDate)]); //update the anonymisation Date
      SetAnonymisationPanel;
    end;

    Self.ClientHeight := InitSize.Y;
    FormResize(nil);
  {$ENDIF EXDLL}

end;

// set position of anonymisation panel
procedure TJobRec.SetAnonymisationPanel;
begin
  if  GDPROn and FAnonymisationON then
  begin
    pnlAnonymisationStatus.Left := 0;
    pnlAnonymisationStatus.Top := Self.ClientHeight - (pnlAnonymisationStatus.Height);
    pnlAnonymisationStatus.Width := Self.ClientWidth;
    shpNotifyStatus.Width := pnlAnonymisationStatus.Width - 10;
    shpNotifyStatus.Left := 5;
      //center the label
    lblAnonStatus.Left := Round((pnlAnonymisationStatus.Width - lblAnonStatus.width)/2);
  end;

end;

//-------------------------------------------------------------------------

// MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
function TJobRec.WindowExportEnableExport: Boolean;
begin
  // SSK 23/05/2018 2018-R1.1 ABSEXCH-20307: modified to implement export list functionality for Notes, Ledger tab
  Result := (Current_Page In [NotesPage,
                              LedgerPage]);

  If Result Then
  Begin
    WindowExport.AddExportCommand (ecIDCurrentRow, ecdCurrentRow);
    WindowExport.AddExportCommand (ecIDCurrentPage, ecdCurrentPage);
    WindowExport.AddExportCommand (ecIDEntireList, ecdEntireList);
  End; // If Result
end;

//-----------------------------------

// MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
procedure TJobRec.WindowExportExecuteCommand(const CommandID: Integer; const ProgressHWnd: HWND);
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
      if (Current_Page = NotesPage) then
        //Notes tab
        NotesCtrl.MULCtrlO.ExportList (ListExportIntf, CommandID, ProgressHWnd)
      else
        // Get the active Btrieve List to export the data for Ledger tab
        MulCtrlO[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd);

      ListExportIntf.FinishExport;
    End; // If ListExportIntf.StartExport(sTitle)
  Finally
    ListExportIntf := NIL;
  End; // Try..Finally
end;

//-----------------------------------

// MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
function TJobRec.WindowExportGetExportDescription: String;
begin
  // SSK 23/05/2018 2018-R1.1 ABSEXCH-20307: modified to implement export list functionality for Notes, Ledger tab
  case Current_Page Of
    NotesPage     : Result := 'Job Notes';
    LedgerPage    : Result := 'Job Ledger';
  end;

  Result := Result + ' - ' + ExLocal.LJobRec^.JobCode;

end;

//-------------------------------------------------------------------------

Initialization

  FillChar(DDFormMode,Sizeof(DDFormMode),0);

end.

