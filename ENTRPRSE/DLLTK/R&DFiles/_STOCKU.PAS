unit StockU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SBSPanel, StdCtrls, Mask, TEditVal, ExtCtrls, ComCtrls, BorBtns,
  GlobVar,VarConst,VarRec2U,BtrvU2,BTSupU1,ExWrap1U, SupListU,

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

  Menus, Buttons, Grids, SBSOutl, bkgroup, TCustom;




Const

    SMainPNo      =  0;
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




type
  TSLMList  =  Class(TDDMList)

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
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    NLDPanel: TPanel;
    NLCrPanel: TPanel;
    NLDrPanel: TPanel;
    FullExBtn: TSpeedButton;
    FullColBtn: TSpeedButton;
    ClsI1Btn: TButton;
    NLOLine: TSBSOutlineB;
    SBSPanel5: TSBSPanel;
    Bevel7: TBevel;
    Panel4: TPanel;
    Panel5: TPanel;
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
    Bevel8: TBevel;
    Label86: Label8;
    GPLab: TPanel;
    Label87: Label8;
    CostLab: TPanel;
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
    SRSPF: TBorCheck;
    VLocPanel: TSBSPanel;
    VLocLab: TSBSPanel;
    InLocPanel: TSBSPanel;
    OutLocPanel: TSBSPanel;
    InLocLab: TSBSPanel;
    OutLocLab: TSBSPanel;
    PriceChk: TBorCheck;
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
    CBCalcProdT: TBorCheck;
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
    SRRRCF: TCurrencyEdit;
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
    procedure SRVCFExit(Sender: TObject);
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
  private
    { Private declarations }

    HideDAdd,
    ManClose,
    InHBeen,
    InBOM,
    BomMode,
    StopPageChange,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    fNeedCUpdate,
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
    Misc1P,
    PanelP     :  TPoint;

    PagePoint  :  Array[0..4] of TPoint;

    StartSize,
    InitSize   :  TPoint;


    MULCtrlO   :  Array[SQtyBPNo..SBinPNo] of TSLMList;

    MULCtrlO2  :  Array[SQtyBPNo..SBinPNo] of TSNoList;

    InvBtnList :  TVisiBtns;

    DescCList  :  TDetCtrl;

    DispTransPtr
               :  Pointer;

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

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;

    procedure LedgerBuildList(PageNo     :  Byte;
                              ShowLines  :  Boolean);

    {$IFDEF SOP}

      procedure SNoBuildList(PageNo     :  Byte;
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

      function FindNode(NCode  :  LongInt)  :  Integer;

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

    {$IFDEF EN570}
      SerRetMode,
    {$ENDIF}
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
                      Help10   :  LongInt) :  LongInt;

    procedure PrimeButtons;

    procedure SetTabs;

    procedure BuildMenus;

    procedure FormDesign;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    procedure Find_LedgCoord(PageNo  :  Integer);
    procedure Store_LedgCoord(UpMode  :  Boolean);


    procedure Find_ValCoord(PageNo  :  Integer);
    procedure Store_ValCoord(UpMode  :  Boolean);

    procedure Find_FormCoord;
    procedure Store_FormCoord(UpMode  :  Boolean);

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

    Procedure Change_Hist(OldTyp,NewTyp  :  Char;
                          SFolio         :  LongInt);

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

  GenWarnU,
  ExThrd2U,
  PWarnU,
  SysU3,
  SysU2;


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
      MULCtrlO[n].Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  GlobComp.Destroy;
end;


procedure TStockRec.Find_ValCoord(PageNo  :  Integer);


Var
  n       :  Integer;

  GlobComp:  TGlobCompRec;


Begin

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
      MULCtrlO2[n].Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  GlobComp.Destroy;
end;


Procedure  TStockRec.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TStockRec.Find_FormCoord;


Var
  ThisForm:  TForm;

  VisibleRect
          :  TRect;

  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do
  Begin
    GetValues:=BOn;
    PrimeKey:='K';

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;

      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    GetbtControlCsm(PageControl1);

    GetbtControlCsm(TCMPanel);


    With TCMBtnScrollBox do
    Begin

      Height:=TCMPanel.ClientHeight-Top;

    end;

    GetbtControlCsm(TCMScrollBox);
    GetbtControlCsm(TCNScrollBox);
    GetbtControlCsm(TCNListBtnPanel);

    If (GetbtControlCsm(CListBtnPanel)) then
    Begin
      CLOrefPanel.Height:=CListBtnPanel.Height;
      SNoPanel.Height:=CListBtnPanel.Height;
    end;

    GetbtControlCsm(CLSBox);

    TCMScrollBox.Color:=TCMPanel.Color;
    {SBSGroup1.Color:=TCMPanel.Color;
    SBSGroup2.Color:=TCMPanel.Color;
    SBSPanel4.Color:=TCMPanel.Color;}


    If GetbtControlCsm(NLOLine) then
      NLOLine.BarColor:=ColOrd;

    If GetbtControlCsm(NLDPanel) then
      NLOLine.BarTextColor:=ColOrd;

    GetbtControlCsm(NLCrPanel);

    GetbtControlCsm(NLDrPanel);

    {DefaultPageReSize;}
    NotePageReSize;

    If (GetbtControlCsm(SRCF)) then
      SetFieldProperties;

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

      {* Check form is within current visible range
         Find some way of getting to parent form visible area *}

  {With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;}

    {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;


end;

procedure TStockRec.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin

    PrimeKey:='K';

    GetValues:=UpMode;

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(TCMPanel);


    StorebtControlCsm(TCMScrollBox);
    StorebtControlCsm(TCNScrollBox);

    StorebtControlCsm(TCNListBtnPanel);

    StorebtControlCsm(SRCF);

    StorebtControlCsm(CListBtnPanel);
    StorebtControlCsm(CLSBox);

    {BOM Page}

    ColOrd:=NLOLine.BarColor;

    StorebtControlCsm(NLOLine);

    ColOrd:=NLOLine.BarTextColor;

    StorebtControlCsm(NLDPanel);

    StorebtControlCsm(NLDrPanel);

    StorebtControlCsm(NLCrPanel);



    {$IFDEF NP}
      If (NotesCtrl<>nil) then
        NotesCtrl.MULCtrlO.Store_ListCoord(GlobComp);
    {$ENDIF}

    Store_LedgCoord(UpMode);
    Store_ValCoord(UpMode);

  end; {With GlobComp..}

  GlobComp.Destroy;


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
  Result:=((CanDelete and (Not ExLocal.InAddEdit)) or (Current_Page In [SNotesPNo,SQtyBPNo,SValuePNo,SSerialPNo,SBINPNo]));
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
        If (PageNo=SQtyBPNo) then
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
                            Help10  :  LongInt) :  LongInt;

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
    end; {Case..}
  end
  else
    Result:=-1;

end;


procedure TStockRec.PrimeButtons;

Const
    CB1EID  :  Array[0..11] of Byte = (80,81,88,87,82,83,84,85,86,89,89,99); {* EN570.. set own event codes *}
    CB2EID  :  Array[0..11] of Byte = (90,91,98,97,92,93,94,95,96,99,99,89);
    CB1TID  :  Array[0..11] of Byte = (1,2,9,10,3,4,5,6,7,8,8,8);
    CB2TID  :  Array[0..11] of Byte = (11,12,19,20,13,14,15,16,17,18,18,18);



Var
  ACFlg,
  P4Blk   :  Boolean;

  n,
  PageNo  :  Integer;

  TheCaption
          :  ShortString;

Begin
  PageNo:=Current_Page;

  {$IFDEF SOP}
    ACFlg:=BOff;
  {$ELSE}
    ACFlg:=BOn;

  {$ENDIF}

  TheCaption:='';  P4Blk:=BOff;

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
     {10} AddVisiRec(ChkCP1Btn,BOff);
     {11} AddVisiRec(UCP1Btn,BOff);
     {12} AddVisiRec(RetCP1Btn,{$IFDEF EN570} BOff  {$ELSE} BON {$ENDIF});
     {13} AddVisiRec(Altdb1Btn,ACFlg);
     {14} AddVisiRec(LnkCP1Btn,BOff);
     {15} AddVisiRec(NteCP1Btn,BOff);
     {16} AddVisiRec(StkCuBtn1,BOff);
     {17} AddVisiRec(StkCuBtn2,BOff);

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

      PWSetHideBtn(0,Not (PageNo In [SNotesPNo,SQtyBPNo,SValuePNo,SSerialPNo,SBinPNo]),BOff,ChkPWord3(PageNo,[SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF},SValuePNo,SSerialPNo,SQtyBPNo,SBinPNo],110,278,275,297,431));

      SetBtnHelp(0,SetHelpC(PageNo,[SMainPNo..SQtyBPNo,SValuePNo,SSerialPNo],156,156,156,-1,88,128,0,0,0,1036,1460));

      PWSetHideBtn(1,BOff,BOff,ChkPWord3(PageNo,[SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF},SValuePNo,SSerialPNo,SQtyBPNo,SBinPNo],111,279,276,298,432));
      SetBtnHelp(1,SetHelpC(PageNo,[SMainPNo..SValuePNo,SSerialPNo],155,155,155,-1,87,129,26,0,0,1036,1460));

      SetHideBtn(2,(PageNo<>SNotesPNo),BOff);

      PWSetHideBtn(3,(PageNo=SLedgerPNo) or (SerUseMode) or (BinUseMode),BOff,ChkPWord3(PageNo,[SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF},SValuePNo,SSerialPNo,SQtyBPNo,SBinPNo],112,280,277,299,433));

      SetBtnHelp(3,SetHelpC(PageNo,[SMainPNo..SValuePNo,SSerialPNo],159,159,159,-1,89,130,0,0,0,0,1461));

      SetHideBtn(4,(PageNo In [SNotesPNo,SQtyBPNo,SValuePNo]),BOff);

      SetBtnHelp(4,SetHelpC(PageNo,[SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF},SLedgerPNo],165,165,165,-1,0,0,27,0,0,1047,1462));

      SetHideBtn(5,(Not (PageNo In [SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF}])),BOff);

      SetHideBtn(6,(PageNo<>SNotesPNo),BOff);

      PWSetHideBtn(7,(PageNo In [SNotesPNo,SQtyBPNo,SValuePNo,SSerialPNo,SBinPNo]),BOff,ChkPWord(PageNo,[SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF}],113));
      SetBtnHelp(7,SetHelpC(PageNo,[SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF},SLedgerPNo],163,163,163,0,0,0,31,0,0,0,0));

      SetHideBtn(8,(Not (PageNo In [SLedgerPNo,SValuePNo,SSerialPNo,SBinPNo])) or ((PageNo=SSerialPNo) and SerUseMode) or ((PageNo=SBinPNo) and BinUseMode),BOff);
      SetBtnHelp(8,SetHelpC(PageNo,[SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF},SLedgerPNo],154,154,154,-1,0,0,32,0,0,1048,1463));


      {SetHideBtn(9,(Not (PageNo In [SMainPNo..SDef2PNo,SQtyBPNo,SLedgerPNo])),BOff);}

      PWSetHideBtn(9,(Not (PageNo In [SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF},SQtyBPNo,SLedgerPNo])),BOff,ChkPWord3(PageNo,[SMainPNo..SWOPPNo,SLedgerPNo,SQtyBPNo],(314*Ord(PageNo=SLedgerPNo))+(472*Ord(PageNo<>SLedgerPNo)),0,0,300,0));

      SetBtnHelp(9,SetHelpC(PageNo,[SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF},SQtyBPNo..SValuePNo,SSerialPNo],186,186,186,-1,-1,131,28,0,0,0,0));

      SetHideBtn(10,(PageNo In [SNotesPNo,SValuePNo,SSerialPNo]),BOff);

      PWSetHideBtn(10,(PageNo In [SNotesPNo,SValuePNo,SSerialPNo]),BOff,ChkPWord3(PageNo,[SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF},SLedgerPNo,SQtyBPNo],473,0,0,301,0));

      SetBtnHelp(10,SetHelpC(PageNo,[SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF},SQtyBPNo..SValuePNo,SSerialPNo],187,187,187,-1,-1,132,187,0,0,0,1464));

      SetHideBtn(11,((PageNo<>SSerialPNo) and (PageNo<>SBinPNo)) or ((Not SerUseMode) and (Not BINUseMode)) or (InSerFind)  or (InBINFind),BOff);

      {$IFDEF EN570}
        P4Blk:=(PageNo=SSerialPNo) and ((Not ChkAllowed_In(513)) and (Not ChkAllowed_In(512)));

        PWSetHideBtn(12,(Not (PageNo In [SLedgerPNo,SSerialPNo])) or (SerUseMode) or (InSerFind) or (Not RetMOn) or (P4Blk),BOff,ChkPWord(PageNo,[SLedgerPNo],511));
      {$ENDIF}

      {$IFDEF SOP}
        PWSetHideBtn(13,(Not (PageNo In [SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF},SSerialPNo,SBinPNo]) or ((PageNo=SBinPNo) and (Not Syss.UseMLoc))),BOff,ChkPWord(PageNo,[SSerialPNo],275));

        SetBtnHelp(13,SetHelpC(PageNo,[SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF},SSerialPNo],596,596,596,-1,0,0,00,0,0,1049,1465));

      {$ENDIF}

      SetHideBtn(14,(Not (PageNo In [SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF},SBinPNo ])) or (BinUseMode)  ,BOff);

      {$IFDEF CU}
        {15}  SetHideBtn(16,(Not EnableCustBtns(3000,CB1EID[PageNo])) or (PageNo=SNotesPNo),BOff);

        {16}  SetHideBtn(17,(Not EnableCustBtns(3000,CB2EID[PageNo])) or (PageNo=SNotesPNo),BOff);

        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, CB1TID[PageNo], TheCaption, StkCuBtn1.Font);

        StkCuBtn1.Caption:=TheCaption;

        EntCustom3.FCustDLL.GetCustomise(EntCustom3.WindowId, CB2TID[PageNo], TheCaption, StkCuBtn2.Font);

        StkCuBtn2.Caption:=TheCaption;


      {$ELSE}
        {15}  SetHideBtn(16,BOn,BOff);
        {16}  SetHideBtn(17,BOn,BOff);
      {$ENDIF}


      SetHideBtn(15,PageNo<>SSerialPNo,BOn);

      DelCP1Btn.Enabled:=SetDelBtn;

      OkCP1Btn.Visible:=(PageNo In [SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF}]);
      CanCP1Btn.Visible:=(PageNo In [SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF}]);

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
    Notes.TabVisible:=(Not SerUseMode) and (Not BinUseMode) and (Not CQtyBMode) and (Not HideDAdd);
    Defaults.TabVisible:=(Not SerUseMode) and (Not BinUseMode);
    Def2Page.TabVisible:=(Not SerUseMode) and (Not BinUseMode);

    If (Def2Page.TabVisible) then
    Begin
      Def2Page.Caption:=CCVATName^;

      If eBusModule then
        Def2Page.Caption:=Def2Page.Caption+'/Web';
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

      RETPage.TabVisible:=(Not SerUseMode) and (Not BinUseMode) and (RETMOn);

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

    EditSPBtn.Visible:=ChkAllowed_In(474);

    Label818.Visible:=EditSPBtn.Visible;


    If (IsProdMode(StockType,StkGrpCode)) then
    Begin
      SRGSF.Text:='';
      SRGCF.Text:='';
      SRGWF.Text:='';
      SRGVF.Text:='';
      SRGPF.Text:='';
    end;

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

  Find_FormCoord;


  Set_DefaultVAT(SRVCF.Items,BOn,BOff);
  Set_DefaultVAT(SRVCF.ItemsL,BOn,BOn);

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

  WebCatF.MaxLength:=20;
  WebImgF.MaxLength:=30;

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





  VATLab.Caption:=CCVATname^+VATLab.Caption;

  UD1Lab.Caption:=SyssVAT.VATRates.UDFCaption[5];
  UD2Lab.Caption:=SyssVAT.VATRates.UDFCaption[6];
  UD3Lab.Caption:=SyssVAT.VATRates.UDFCaption[15];
  UD4Lab.Caption:=SyssVAT.VATRates.UDFCaption[16];


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
  ExLocal.Create;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;

  fFrmClosing:=BOff;
  fDoingClose:=BOff;
  Visible:=BOff;

  ManClose:=BOff;

  InitSize.Y:=335;
  InitSize.X:=558;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=353;
  Width:=566;}

  SerUseMode:=(DDFormMode.NHMode=5);

  InSerFind:=(DDFormMode.NHNeedGExt and (DDFormMode.NHFilterMode=0)) and (SerUseMode);

  BinUseMode:=(DDFormMode.NHMode=6);

  InBinFind:=(DDFormMode.NHNeedGExt and (DDFormMode.NHFilterMode=0)) and (BinUseMode);

  CQtyBMode:=(DDFormMode.NHMode=16);


//  MDI_SetFormCoord(TForm(Self));

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

  If (Not eBusModule) then
  Begin
    emWebF.Visible:=BOff;
    WebCatF.Visible:=BOff;
    WebImgF.Visible:=BOff;
    Label826.Visible:=BOff;
    Label844.Visible:=BOff;
  end;

  If Not Syss.IntraStat then
  Begin
    Label849.Visible:=BOff;
    Label848.Visible:=BOff;
    Label847.Visible:=BOff;
    Label850.Visible:=BOff;
    Label851.Visible:=BOff;
    Label852.Visible:=BOff;
    Label853.Visible:=BOff;
    CCodeF.Visible:=BOff;
    SSUDF.Visible:=BOff;
    SSDUF.Visible:=BOff;
    SWF.Visible:=BOff;
    PWF.Visible:=BOff;
    SRSUP.Visible:=BOff;
    SRCOF.Visible:=BOff;

  end
  else
  Begin
    If (CurrentCountry<>IECCode) then
    Begin
      SRSUP.Visible:=BOff;
      Label847.Visible:=BOff;
    end;

  end;


  InHBeen:=BOff;
  FromHist:=BOff;
  InBOM:=BOff;
  BOMMode:=BOff;
  BOMFolio:=0;
  HideDAdd:=BOff;
  InSerModal:=BOff;
  InBinModal:=BOff;

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

  {$IFDEF EN570}
    SerRetMode:=0;
  {$ENDIF}

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


  If (CQtyBMode) then
    DelDisc2.Visible:=BOff;

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

//  FormDesign;

  SNoPageReSize;

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


procedure TStockRec.BOMPageReSize;
Begin
  NLOLine.Width:=ClientWidth-5;
  NLOLine.Height:=ClientHeight-104;
  NLDPanel.Width:=Width-Lab1Ofset;
  NLCrPanel.Left:=Width-Lab2Ofset;
  NLDrPanel.Left:=Width-Lab3Ofset;

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
    LockWindowUpDate(PageControl1.Handle);

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

    {$IFDEF PF_On}

      BOMPageReSize;

    {$ENDIF}

    DefaultPageReSize;

    {$IFDEF PF_On}
      SNoPageReSize;
    {$ENDIF}

    NotePageReSize;

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


        If (NeedCUpdate) then
          Store_FormCoord(Not SetDefault);


        Send_UpdateList(BOff,100);

        {$IFDEF NP}
          If (NotesCtrl<>nil) then
          Begin
            try
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
    Add('Split Pack - '+SRUSF.Text);

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
      SRVCF.ItemIndex:=GetVATIndex(VATCode);

    If Syss.IntraStat then
    Begin
      CCodeF.Text:=CommodCode;
      SSUDF.Text:=UnitSupp;
      SSDUF.Value:=SuppSUnit;
      SWF.Value:=SWeight;
      PWF.Value:=PWeight;

      If (CurrentCountry=IECCode) then
        SRSUP.Value:=SSDDUpLift;

      SRCOF.Text:=SSDCountry;
    end;

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

      SRRRCF.Value:=ReStockPcnt;

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


    SRBCF.Text:=BarCode;
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

    With SRVCF do
      If (ItemIndex>-1) then
        VATCode:=Items[ItemIndex][1]
      else
        VATCode:=VATSTDCode;

    If Syss.IntraStat then
    Begin
      CommodCode:=CCodeF.Text;
      UnitSupp:=SSUDF.Text;
      SuppSUnit:=SSDUF.Value;
      SWeight:=SWF.Value;
      PWeight:=PWF.Value;

      If (CurrentCountry=IECCode) then
        SSDDUpLift:=SRSUP.Value;

      SSDCountry:=SRCOF.Text;
    end;

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

      If (SRRSWMF.ItemIndex>0) then
        SWarrantyType:=SRRSWMF.ItemIndex;

      If (SRRSMMF.ItemIndex>0) then
        MWarrantyType:=SRRSMMF.ItemIndex;

      ReStockPcnt:=SRRRCF.Value;

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

    BarCode:=SRBCF.Text;

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

      SDef2PNo
         :  If (emWebF.Visible) then
              emWebF.SetFocus
            else
              SRVCF.SetFocus;

      SWOPPNo
         :  SRROLTF.SetFocus;

      {$IFDEF EN570}
        SRetPNo
         :  SRRSWDF.SetFocus;
      {$ENDIF}

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


Function TStockRec.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;


  If (ExLocal.InAddEdit) and (CheckNeedStore) then
  Begin
    If (Current_Page>{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF}) then {* Force view of main page *}
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
    else
      If (TC is TCurrencyEdit ) then
      With (TC as TCurrencyEdit) do
      Begin
        If (Tag=TG) then
          ReadOnly:= Not EnabFlg;
      end
      else
        If (TC is TBorCheck) then
        With (TC as TBorCheck) do
        Begin
          If (Tag=TG) then
            Enabled:=EnabFlg;
        end
        else
          If (TC is TBorRadio) then
          With (TC as TBorRadio) do
          Begin
            If (Tag=TG) then
              Enabled:=EnabFlg;
          end
          else
            If (TC is TUpDown) then
            With (TC as TUpDown) do
            Begin
              If (Tag=1) then
                Enabled:=EnabFlg;
            end
            else
              If (TC is TSBSComboBox) then
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
    SRCF.ReadOnly:=(Not Enabled) or (((Not CanDelete) and (Not ChkAllowed_In(200))) and ((Not InAddEdit) or (LastEdit))) ;


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

    If (TC<>SRCF) then {* Do not change Stock code, as maybe set to readonly.. *}
      SetCompRO(TC,1,BOn); {* Reset them all first *}


    Case PTMode of
       0  :  ;    {Product}

       1  :  Begin {Description only}
               If (TC=SRFSF) or (TC=SRUQF) or (TC=SRUSF) or (TC=SRUPF) or (TC=SRSUF) or (TC=SRPUF) then
                 SetCompRO(TC,1,BOff);
             end;
       2,3 {* Group/Desc only}
         :  If (TC<>SRTF) and (TC<>SRD1F) and (TC<>SRD2F) and (TC<>SRD3F) and (TC<>SRD4F) and (TC<>SRD5F) and (TC<>SRD6F) and (TC<>emWebF)
            and (TC<>UD1F) and (TC<>UD2F) and (TC<>UD3F) and (TC<>UD4F) and (TC<>WebCatF) then
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
      ChangePage(SDef2PNo);
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


Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      0,1,169
         :  If (Current_Page In [SLedgerPNo]) then
            Begin
              If (WParam=169) then
              Begin
                MULCtrlO[Current_Page].GetSelRec(BOff);
                WParam:=0;
              end;

              InHBeen:=((WParam=0) or ((InHBeen) and ScanMode));

              Display_Trans(2+(98*WParam));

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

       119
       {$IFDEF EN570}
       , 182
       {$ENDIF}
        : With MULCtrlO2[Current_Page] do
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

               
               end; {case..}

               If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
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


Procedure TStockRec.WMSysCommand(Var Message  :  TMessage);


Begin
  With Message do
    Case WParam of

      SC_Maximize  :  Begin
                        Self.ClientHeight:=InitSize.Y;
                        Self.ClientWidth:=InitSize.X;

                        WParam:=0;
                      end;

    end; {Case..}

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
  NofMsgs      =  12;

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


Begin
  New(PossMsg);

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
  {PossMsg^[13]:='The Returned Stock Restock charge G/L code is not valid.';}

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

      4  :
             For n:=1 to MaxStkPBands do
             Begin
               Result:=((SaleBands[n].Currency In [Succ(CurStart)..CurrencyType]));

               If (Not Result) then
                 Break;
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
      {$IFDEF EN570}


        12  :  Begin
                 Result:=Not RETMOn or (StockType=StkDescCode);

                 If (Not Result) then
                 Begin

                   Result:=GetNom(Self,Form_Int(ReturnGL,0),FoundLong,-1) and GetNom(Self,Form_Int(PReturnGL,0),FoundLong,-1);


                 end;

               end;

        {13  :  Begin
                 Result:=(Not RETMOn) or (ReStockPcnt=0.0);

                 If (Not Result) then
                 Begin

                   Result:=GetNom(Self,Form_Int(ReStockGL,0),FoundLong,-1);
                 end;

               end;}

      {$ENDIF}

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) then
    mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}






{ =========== Procedures to Control Stock Type Changes =========== }


Procedure TStockRec.Change_Hist(OldTyp,NewTyp  :  Char;
                                SFolio         :  LongInt);


Const
  Fnum    =  NHistF;

  Keypath =  NHk;


Var

  KeyChk,
  KeyS    :  Str255;

  NeedYTD,
  Loop,
  UOk,
  Locked  :  Boolean;

  LRecAddr
          :  LongInt;

  LastCr,
  LastYr  :  Byte;

  TPurch,
  TSales,
  TCleared
          :  Real;

  LastNHist
          :  HistoryRec;


Begin

  Loop:=BOff;  LastCr:=0; LastYr:=0; NeedYTD:=BOff;

  TPurch:=0.0; TSales:=0.0; TCleared:=0.0;


  Repeat
    UOk:=BOff; Locked:=BOff;

    If (Loop) then {* Change Stk loc hist as well *}
      KeyChk:=OldTyp+'L'+FullNomKey(SFolio)
    else
    Begin
      KeyChk:=PartNHistKey(OldTyp,FullNomKey(SFolio),0);
      KeyChk:=Copy(KeyChk,1,Pred(Length(KeyChk)));  {* Search for all matches ignoring currency *}
    end;

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    With NHist do
    Begin
      LastCr:=Cr;
      LastYr:=Yr;
      LastNHist:=NHist;
    end;


    While (StatusOk) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) do
    With NHist do
    Begin
      If (NewTyp In YTDSet) then
      Begin
        If (LastCr<>Cr) or (LastYr<>Yr) then
        Begin
          LastCr:=Cr;

          LastYr:=Yr;

          If (NeedYTD) then
          Begin
            Status:=GetPos(F[Fnum],Fnum,LRecAddr);

            NHist:=LastNHist;
            Pr:=YTD;
            Purchases:=TPurch;
            Sales:=TSales;
            Cleared:=TCleared;

            Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

            Report_BError(Fnum,Status);

            SetDataRecOfs(Fnum,LRecAddr);

            Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,0); {* Re-Establish Position *}

          end;

          TPurch:=0.0;
          TSales:=0.0;
          TCleared:=0.0;

        end
        else
        Begin
          TPurch:=TPurch+Purchases;
          TSales:=TSales+Sales;

          TCleared:=TCleared+Cleared;

        end;


      end;

      NeedYTD:=(Pr<>YTD);

      UOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOn,Locked,LRecAddr);

      If (UOk) and (Locked) then
      Begin

        ExClass:=NewTyp;

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        Report_BError(Fnum,Status);

        Status:=UnLockMultiSing(F[Fnum],Fnum,LRecAddr);
      end; {If Locked Ok..}

      If (StatusOk) then
        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    end; {While..}
    Loop:=Not Loop;

  Until (Not Loop);
end; {Proc..}



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
  Renumbed,
  COk  :  Boolean;
  TmpStock
       :  StockRec;
  KeyS :  Str255;

  MbRet:  Word;

  NewSCode
       :  Str20;



Begin
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

         If ((LastStock.PCurrency<>PCurrency) or (LastStock.CostPrice<>CostPrice)
           or (LastStock.ProdTime<>ProdTime)) then
            Update_UpChange(BOn);

      end
      else
      Begin
        StockFolio:=SetNextSFolio(SKF,BOn,0);

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
        CanDelete:=BOn;
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
      StoreStock(StockF,SKeypath,ExLocal.LastEdit)
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


procedure TStockRec.DeleteAccount;

Const
  Fnum  =  StockF;


Var
  MbRet  :  Word;
  KeyS   :  Str255;

  Keypath:  Integer;

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

          KeyF:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,
                      FullNomKey(Stock.StockFolio)));

          DeleteLinks(KeyF,PWrdF,Length(KeyF),HelpNDXK,BOff);


          {* Delete Qty Discounts *}

          KeyF:=FullQDKey(QBDiscCode,QBDiscSub,FullNomKey(LStock.StockFolio));

          DeleteLinks(KeyF,MiscF,Length(KeyF),MIK,BOff);

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

  CanDelete:=Ok2DelStk(0,ExLocal.LStock);

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



procedure TStockRec.SetFormProperties;

Const
  PropTit     :  Array[0..3] of Str10 = ('Record','Ledger','Build List','List');

Var
  TmpPanel    :  Array[1..3] of TPanel;

  ListChange,
  n           :  Byte;


  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;


Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do
  Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;

  ListChange:=0;

  ListChange:=ListChange+(1*Ord(Current_Page In [SQtyBPNo..SBinPNo]));

  ListChange:=ListChange+(1*Ord(Current_Page In [SQtyBPNo,SValuePNo..SBinPNo]));

  ListChange:=ListChange+(1*Ord(Current_Page In [SQtyBPNo,SValuePNo,SBinPNo]));


  try

    Case ListChange of
      0  :  Begin
              TmpPanel[1].Font:=SRCF.Font;
              TmpPanel[1].Color:=SRCF.Color;

              TmpPanel[2].Font:=PageControl1.Font;
              TmpPanel[2].Color:=TCMScrollBox.Color;
            end;

      1  :  Begin
              With MULCtrlO[Current_Page].VisiList do
              Begin
                VisiRec:=List[0];

                TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
                TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

                TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
                TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


                TmpPanel[3].Color:=MULCtrlO[Current_Page].ColAppear^[0].HBKColor;
              end;

              TmpPanel[3].Font.Assign(TmpPanel[1].Font);

              TmpPanel[3].Font.Color:=MULCtrlO[Current_Page].ColAppear^[0].HTextColor;
            end;

      2  :  With NLOLine do
            Begin
              TmpPanel[1].Font:=Font;
              TmpPanel[1].Color:=Color;

              TmpPanel[2].Font:=NLDPanel.Font;
              TmpPanel[2].Color:=NLDPanel.Color;

              TmpPanel[3].Color:=BarColor;
              TmpPanel[3].Font.Assign(TmpPanel[1].Font);
              TmpPanel[3].Font.Color:=BarTextColor;
            end;

      3  :  Begin
              With MULCtrlO2[Current_Page].VisiList do
              Begin
                VisiRec:=List[0];

                TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
                TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

                TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
                TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


                TmpPanel[3].Color:=MULCtrlO2[Current_Page].ColAppear^[0].HBKColor;
              end;

              TmpPanel[3].Font.Assign(TmpPanel[1].Font);

              TmpPanel[3].Font.Color:=MULCtrlO2[Current_Page].ColAppear^[0].HTextColor;
            end;


    end; {Case..}



    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],Ord(ListChange<>0),
                      'Stock '+PropTit[ListChange]+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin
          Case ListChange of
            0  :  Begin
                    PageControl1.Font.Assign(TmpPanel[2].Font);
                    TCMScrollBox.Color:=TmpPanel[2].Color;

                    SRCF.Font.Assign(TmpPanel[1].Font);
                    SRCF.Color:=TmpPanel[1].Color;

                    SetFieldProperties;
                  end;
            1  :  Begin
                    For n:=1 to 3 do
                      With TmpPanel[n] do
                        Case n of
                          1,2  :  MULCtrlO[Current_Page].ReColorCol(Font,Color,(n=2));

                          3    :  MULCtrlO[Current_Page].ReColorBar(Font,Color);
                        end; {Case..}

                    MULCtrlO[Current_Page].VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
                  end;

            2  :  With NLOLine do
                  Begin
                    Font.Assign(TmpPanel[1].Font);
                    Color:=TmpPanel[1].Color;

                    NLDPanel.Font.Assign(TmpPanel[2].Font);
                    NLDPanel.Color:=TmpPanel[2].Color;


                    BarColor:=TmpPanel[3].Color;
                    BarTextColor:=TmpPanel[3].Font.Color;

                    NLCrPanel.Font.Assign(TmpPanel[2].Font);
                    NLCrPanel.Color:=TmpPanel[2].Color;

                    NLDrPanel.Font.Assign(TmpPanel[2].Font);
                    NLDrPanel.Color:=TmpPanel[2].Color;
                  end;

            3  :  Begin
                    For n:=1 to 3 do
                      With TmpPanel[n] do
                        Case n of
                          1,2  :  MULCtrlO2[Current_Page].ReColorCol(Font,Color,(n=2));

                          3    :  MULCtrlO2[Current_Page].ReColorBar(Font,Color);
                        end; {Case..}

                    MULCtrlO2[Current_Page].VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
                  end;


          end; {case..}

        end;

      end;

    finally

      ColourCtrl.Free;

    end;

  Finally

    For n:=1 to 3 do
      TmpPanel[n].Free;

  end;

  If (ResetDefaults) then
  Begin
    SetDefault:=BOn;
    Close;
  end;

end;



procedure TStockRec.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  Custom1.Caption:=StkCuBtn1.Caption;
  Custom2.Caption:=StkCuBtn2.Caption;

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
          :  If (Not (Sender is TMenuItem)) and (Assigned(MulCtrlO2[Current_Page])) then
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

    else  DeleteAccount;
  end; {case..}

end;

procedure TStockRec.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
    LockWindowUpDate(Handle);
  end;
end;





procedure TStockRec.PageControl1Change(Sender: TObject);

Const
  MISubAry  :  Array[SQtyBPNo..SBinPNo] of Char = (QBDiscSub,#0,MFIFOSub,#0,MSERNSub,MSERNSub);
  MITypAry  :  Array[SQtyBPNo..SBinPNo] of Char = (QBDiscCode,#0,MFIFOCode,#0,MFIFOCode,BRRecCode);

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

      If (NewIndex In [SQtyBPNo..SValuePNo,SSerialPNo,SBinPNo]) then
        CListBtnPanel.Parent:=ActivePage;


      Case NewIndex of

      {$IFDEF NP}

        SNotesPNo
           :  If (NotesCtrl=nil) then
              With ExLocal do
              Begin
                NotesCtrl:=TNoteCtrl.Create(Self);

                NotesCtrl.Caption:='Stock Record '+Caption;

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
                  NotesCtrl.CreateList(Self,NoteSetUp,NoteSCode,NoteCDCode,FullNCode(FullNomKey(LStock.StockFolio)));
                  NotesCtrl.GetLineNo:=LStock.NLineCount;


                except
                  NotesCtrl.Free;
                  NotesCtrl:=Nil
                end;

                MDI_UpdateParentStat;

              end
              else
              With ExLocal do
                If (FullNomKey(LStock.StockFolio)<>NotesCtrl.GetFolio) then {* Refresh notes *}
                with NotesCtrl do
                Begin
                  RefreshList(FullNCode(FullNomKey(LStock.StockFolio)),GetNType);
                  GetLineNo:=LStock.NLineCount;
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

                   LnkCP1Btn.Caption:='&Move';
                   Links1.Caption:='&Move';
                   Links1.HelpContext:=1492;
                   LnkCP1Btn.HelpContext:=1492;
                 end
                 else
                 Begin
                   If (NewIndex=SQtyBPNo) then
                     CreateSubMenu(PopUpMenu10,Delete1);
                 end;

             If (Self.Visible) then
               MULCtrlO2[NewIndex].SetListFocus;
           end;
        {$ENDIF}

      end; {Case..}

      If (NewIndex<>SSerialPNo) and (NewIndex<>SBinPNo) then
      Begin
        Altdb1Btn.Caption:='Al&t Codes';
        AltCodes1.Caption:='Al&t Codes';
        AltCodes1.HelpContext:=596;
        Altdb1Btn.HelpContext:=596;

        LnkCP1Btn.Caption:='&Links';
        Links1.Caption:='&Links';
        Links1.HelpContext:=0;
        LnkCP1Btn.HelpContext:=0;
      end;

      If (NewIndex<>SBinPNo) then
      Begin
        ChkCP1Btn.Caption:='&Check';
        Check1.Caption:='&Check';
        Check1.HelpContext:=187;
        ChkCP1Btn.HelpContext:=187;
      end;

      LockWindowUpDate(0);

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
begin

  Case Current_Page of

    SNotesPNo
       :  {$IFDEF NP}
            If (NotesCtrl<>nil) then
            With NotesCtrl do
            Begin

              If (Not MULCtrlO.InListFind) then
                SwitchGenMode;

            end;
          {$ELSE}

            ;
          {$ENDIF}

  end; {Case..}


end;


procedure TStockRec.LedgerBuildList(PageNo     :  Byte;
                                    ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
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

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {*Hide WOP Panels if not enabled*}
          SetHidePanel(FindxColOrder(7),Not WOPOn,BOff);
          SetHidePanel(FindxColOrder(8),Not WOPOn,BOff);

          {$IFDEF EN570}
            {*Hide Ret Panels if not enabled*}
            SetHidePanel(FindxColOrder(9),Not RetMOn,BOff);
            SetHidePanel(FindxColOrder(10),Not RetMOn,BOn);
          {$ELSE}
            {*Hide Ret Panels if not enabled*}
            SetHidePanel(FindxColOrder(9),BOn,BOff);
            SetHidePanel(FindxColOrder(10),BOn,BOn);

          {$ENDIF}
          

                                
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
      MUTotCols:=11;
      Font:=StartPanel.Font;

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
              NoDecPlaces:=Syss.NoNetDec
            else
              NoDecPlaces:=Syss.NoCosDec;
          end
          else
            NoDecPlaces:=Syss.NoQtyDec;
        end;
      end;


      ListLocal:=@ExLocal;

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
  LKeyLen     :  Integer;

Begin
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

    If (ShowLines) then
    Begin
      StartList(IdetailF,IdStkK,KeyStart,'','',LKeyLen,BOn);
      SetNewLIndex;
    end
    else
      StartList(IdetailF,IdStkK,KeyStart,'','',LKeyLen,(Not ShowLines));


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
    MULCtrlO2[PageNo]:=TSNoList.Create(Self);


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
  MULCtrlO2[PageNo]:=TSNoList.Create(Self);


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
    MULCtrlO2[PageNo]:=TSNoList.Create(Self);


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

            VisiRec:=List[0];

            StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

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




  procedure TStockRec.QBBuildList(PageNo     :  Byte;
                                  ShowLines  :  Boolean);

  Var
    StartPanel  :  TSBSPanel;
    n           :  Byte;



  Begin
    MULCtrlO2[PageNo]:=TSNoList.Create(Self);


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
    MISubAry  :  Array[SQtyBPNo..SBINPNo] of Char = (QBDiscSub,#0,MFIFOSub,#0,MSERNSub,MSERNSub);
    MITypAry  :  Array[SQtyBPNo..SBINPNo] of Char = (QBDiscCode,#0,MFIFOCode,#0,MFIFOCode,BRRecCode);
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
        If (CQtyBMode) then
          KeyStart:=FullQDKey(QBDiscCode,CustSupp,FullCDKey(CustCode,StockFolio))
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

            {$IFDEF EN570}
              If ((SerRetMode In [23,25]) or ((SerRetMode=26) and (LInv.InvDocHed In StkRetSalesSplit))) and (Current_Page=SSerialPNo) then {* Sold Only lines *}
              Begin
                KeyStart:=KeyStart+#1;
                SLRetMode:=BOn;
              end;
            {$ENDIF}
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

        If ((LastFolio<>LId.FolioRef) or (Mode<>100)) and (InHBeen) then
          Display_Trans(Mode,LId.FolioRef,BOn,(Mode<>100));

      end; {with..}

    except

      DispTrans.Free;

    end;

end;



procedure TStockRec.ViewCP1BtnClick(Sender: TObject);
Var
  Modus       :  Byte;
  
  ListPoint   :  TPoint;

begin
  Case Current_Page of
    SQtyBPNo,SValuePNo
       :  Begin
            {$IFDEF PF_On}
              Case Current_Page of
                SQtyBPNo
                  :  Display_QtyRec(2);
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

              Modus:=2;

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
    Set_EntryRO(EquivSTItem);

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

      StillEdit:=BOn;

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

            Rnum:=0;

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
    end;
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

        StillEdit:=BOn;

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
      end;

    end; {with..}
  {$ENDIF}
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
    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (ExLocal.InAddEdit) and (Not IsProdMode(LStock.StockType,StkGrpCode)) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,2));

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
    end;


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

        StillEdit:=BOn;

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
      end;

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
    SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF}
       :  With ReturnCtrl,MessageReturn do
          Begin
            FillChar(ReturnCtrl,Sizeof(ReturnCtrl),0);

            WParam:=3000;
            Msg:=WM_CustGetRec;
            DisplayxParent:=BOn;
            ShowOnly:=BOn;


            Ctrl_GlobalFind(Self,ReturnCtrl,3);

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

    RoFlg:=BOff;
    MinFlg:=BOff;

    StkFlg:=BOff;

    QtyPicked:=0;
    QtyFreeze:=0;

    CovSold:=0;

    QtyTake:=0;

    Status:=Add_Rec(F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2);

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


          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          // HM 10/05/99: Modified to call LSet... as passing in L record from ExLocal.
          //SetDataRecOfs(Fnum,RecAddr);
          LSetDataRecOfs(Fnum,RecAddr);

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
        mbRet:=MessageDlg('That Stock code already exisits!',mtError,[mbOk,mbCancel],0);


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
    else Begin
           Control_BOMCopy(StockF,SKeyPath);
         end;

  end; {Case..}
end;


procedure TStockRec.Copy2Click(Sender: TObject);
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

                ContraCopy_Doc(ExLocal.LInv.FolioNum,TMenuItem(Sender).Tag,'');
                PageUpDn(0,BOn);
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


{ ======= Function to find the note a nominal code resides at ======= }

function TStockRec.FindNode(NCode  :  LongInt)  :  Integer;

Var
  n          :  Integer;
  FoundOk    :  Boolean;


Begin
  FoundOk:=BOff;

  With NLOLine do
    For n:=1 to ItemCount do
    Begin
      FoundOk:=(OutNomType(Items[n].Data^).OutNomCode=NCode);

      If (FoundOk) then
        Break;
    end;

  If (FoundOk) then
    Result:=n
  else
    Result:=-1;

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
            Panel5.Caption:=OutStkCode;


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
  Custom3.Visible:=StkCuBtn1.Visible;
  Custom4.Visible:=StkCuBtn2.Visible;


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
begin
  {$IFDEF PF_On}
    With ExLocal,LStock do
      If (StockType=StkBillCode) and ((LastYTDII<>YTDCombo.ItemIndex) or (KitPrice<>PriceChk.Checked)) and (Not InAddEdit) then
      Begin
        BStock:=LStock;

        LastYTDII:=YTDCombo.ItemIndex;
        
        UpdateFromBOM;
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


       If (Mode In [1..3]) then
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

        {$IFDEF EN570}
          If (SerRetMode=25) or ((SerRetMode=26) and (LInv.InvDocHed In StkRetSalesSplit)) then
          Begin
            SERN_SetRet(ScanFileNum,Keypath,SerialReq,DocCostP,LInv,LId,SerRetMode);
          end
          else
          Begin
            If (MiscRecs^.SerialRec.BatchRec) then
              Batch_SetUse(ScanFileNum,Keypath,0,SerialReq,DocCostP,LInv,LId{$IFDEF EN570},SerRetMode{$ENDIF})
            else
              SERN_SetUse(ScanFileNum,Keypath,SerialReq,DocCostP,LInv,LId{$IFDEF EN570},SerRetMode{$ENDIF});
          end;

        {$ELSE}
          If (MiscRecs^.SerialRec.BatchRec) then
            Batch_SetUse(ScanFileNum,Keypath,0,SerialReq,DocCostP,LInv,LId)
          else
            SERN_SetUse(ScanFileNum,Keypath,SerialReq,DocCostP,LInv,LId);

        {$ENDIF}
        
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
      {$IFDEF EN570}
        or ((MLocCtrl^.brBinRec.brHoldFlg=2) and (((MLocCtrl^.brBinRec.brBatchChild) and (LId.IdDocHed In StkRetPurchSplit)) or (LId.IdDocHed In StkRetSalesSplit)))
      {$ENDIF} then
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

         RetOD1.Visible:=BoChkAllowed_In((Trim(OutDoc)<>'') and ((GetDocType(OutDoc) In StkRetGenSplit)) and (Not ReturnSNo),513);
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
             If ((Not RetOD1.Visible) and (ChkAllowed_In(513))) and ((Not RetId1.Visible) and (ChkAllowed_In(512))) then
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
    If (CheckRecExsists(Strip('R',[#0],FullNomKey(Id.FolioRef)),InvF,InvFolioK)) and (Inv.InvDocHed In StkRetGenSplit-[POR]) then
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
        Gen_RetDocWiz(Inv,Id,10,Self);

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
    MULCtrlO2[Current_Page].Copy_QBStock(CustCode,CustSupp);
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
    SMainPNo,SDefaultPNo,SDef2PNo,SWOPPNo,{$IFDEF EN570} SRetPNo, {$ENDIF} SLedgerPNo
       :  With ExLocal do
          Begin
            AssignToGlobal(StockF);

            {$IFDEF POST}

              Check_StockLevels(BOff,Self,StockF,SKeypath);


            {$ENDIF}

          end;

    SQtyBPNo
       :  With ExLocal,LCust,LStock,MULCtrlO2[SQtyBPNo] do
          Begin
            {$IFDEF PF_On}

              Case DisplayMode of
                2  :  KeyS:=FullNomKey(StockFolio);
                3  :  KeyS:=FullCDKey(CustCode,StockFolio);
              end; {Case..}

              Check_QBDisc(CustSupp,KeyS,ScanFileNum,Keypath,LStock,POk,Pred(DisplayMode));
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


  end; {Case..}
end;


procedure TStockRec.PrnCP1BtnClick(Sender: TObject);

begin
  {$IFDEF FRM}
    With ExLocal do
    Case Current_Page of

      SMainPNo..{$IFDEF EN570} SRetPNo {$ELSE} SWOPPNo {$ENDIF}
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

        StillEdit:=BOn;

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
      end;
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


procedure TStockRec.SRVCFExit(Sender: TObject);
begin
  With ExLocal do
  Begin
    If (InAddEdit) and (Sender is TSBSComboBox) then
    Begin
      Form2Stock;

      {$IFDEF VAT}
        If (LStock.VATCode=VATICode) and (TSBSComboBox(Sender).Modified) then
          With TSBSComboBox(Sender) do
            GetIRate(Parent.ClientToScreen(ClientPos(Left,Top+23)),Color,Font,Self.Parent,LViewOnly,LStock.SVATIncFlg);
      {$ENDIF}

    end;
  end;

end;

procedure TStockRec.UD1FEntHookEvent(Sender: TObject);
Var
  CUUDEvent  :  Byte;
  Result     :  LongInt;

begin
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

Const
  CB1EID  :  Array[0..10] of Byte = (80,81,88,87,82,83,84,85,86,89,89);

Var
  PageNo  :  Integer;
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

        ExecuteCustBtn(3000,((CB1EID[PageNo])*Ord((Sender=StkCuBtn1) or (Sender=Custom1) or (Sender=Custom3)))+
                      ((CB1EID[PageNo]+10)*Ord((Sender=StkCuBtn2) or (Sender=Custom2) or (Sender=Custom4))), ExLocal);

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
    CurrencySymb:=PSymb(SaleBands[1].Currency);

    Value:=SaleBands[1].SalesPrice;
    
  end;

  SRGP1.Value:=CalcGP(1);
end;



procedure TStockRec.EditSPBtnClick(Sender: TObject);

Var
  WasNew  :  Boolean;

begin
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




Initialization

  FillChar(DDFormMode,Sizeof(DDFormMode),0);

end.
