unit JCAPPD2U;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, TEditVal, BorBtns, Mask, ComCtrls,

  GlobVar,VarConst,ExWrap1U,BTSupU1,SupListU,SBSComp2,

  SalTxL1U,

  ExtGetU,

  JAPLne2U,

  {$IFDEF NP}
    NoteU,
  {$ENDIF}

  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  Menus, Gauges, bkgroup;



type

  TJAPPMList  =  Class(TDDMList)

  sLineType   :  TStringList;


  Public
    AppliedTotalFound: Boolean;
    aBarBkColor,
    aBarTextColor
              :  TColor;


    Procedure ExtObjCreate; Override;

    Procedure ExtObjDestroy; Override;


    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    { CJS 2012-08-17 - ABSEXCH-12317 - JST Delete Check }
    function CalcApplied: Double;


  end;

  TJDedMList  =  Class(TJAPPMList)

  sDedLineType,
  sRetLineType:  TStringList;


  Public
    Procedure ExtObjCreate; Override;

    Procedure ExtObjDestroy; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;


  end;


type
  TJCAPP = class(TForm)
    PageControl1: TPageControl;
    AdjustPage: TTabSheet;
    A1SBox: TScrollBox;
    A1HedPanel: TSBSPanel;
    A1CLab: TSBSPanel;
    A1GLab: TSBSPanel;
    A1OLab: TSBSPanel;
    A1DLab: TSBSPanel;
    A1ILab: TSBSPanel;
    A1CCLab: TSBSPanel;
    A1DpLab: TSBSPanel;
    A1CPanel: TSBSPanel;
    A1IPanel: TSBSPanel;
    A1GPanel: TSBSPanel;
    A1DPanel: TSBSPanel;
    A1OPanel: TSBSPanel;
    A1CCPanel: TSBSPanel;
    A1DpPanel: TSBSPanel;
    A1BtmPanel: TSBSPanel;
    CCPanel: TSBSPanel;
    CCTit: Label8;
    DepTit: Label8;
    CCLab: Label8;
    CostPanel: TSBSPanel;
    DrReqdTit: Label8;
    IssuePanel: TSBSPanel;
    CrReqdTit: Label8;
    A1ListBtnPanel: TSBSPanel;
    NotesPage: TTabSheet;
    TCNScrollBox: TScrollBox;
    TNHedPanel: TSBSPanel;
    NDateLab: TSBSPanel;
    NDescLab: TSBSPanel;
    NUserLab: TSBSPanel;
    NDatePanel: TSBSPanel;
    NDescPanel: TSBSPanel;
    NUserPanel: TSBSPanel;
    TCNListBtnPanel: TSBSPanel;
    A1BtnPanel: TSBSPanel;
    OkN1Btn: TButton;
    CanN1Btn: TButton;
    ClsN1Btn: TButton;
    A1BSBox: TScrollBox;
    AddN1Btn: TButton;
    EditN1Btn: TButton;
    DelN1Btn: TButton;
    InsN1Btn: TButton;
    SwiN1Btn: TButton;
    A1BPanel: TSBSPanel;
    A1BLab: TSBSPanel;
    DepLab: Label8;
    CostLab: Label8;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label85: Label8;
    Label86: Label8;
    A1StatLab: Label8;
    A1FPanel: TSBSPanel;
    Label817: Label8;
    Label84: Label8;
    Label88: Label8;
    A1OrefF: Text8Pt;
    A1OpoF: Text8Pt;
    A1TPerF: TEditPeriod;
    A1LocPanel: TSBSPanel;
    A1LocLab: TSBSPanel;
    LnkN1Btn: TButton;
    I1AccF: Text8Pt;
    Bevel1: TBevel;
    IssuedLab: Label8;
    A1UOPanel: TSBSPanel;
    A1UOLab: TSBSPanel;
    A1OSPanel: TSBSPanel;
    A1OSLab: TSBSPanel;
    A1BUPanel: TSBSPanel;
    A1BULab: TSBSPanel;
    A1IssPanel: TSBSPanel;
    A1IssLab: TSBSPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    Insert1: TMenuItem;
    Switch1: TMenuItem;
    Links1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    FinPanel: TSBSPanel;
    Label812: Label8;
    IssLab: Label8;
    ChkBtn: TButton;
    Check1: TMenuItem;
    APickI1Btn: TButton;
    AutoPick1: TMenuItem;
    PopupMenu2: TPopupMenu;
    AP1: TMenuItem;
    AW1: TMenuItem;
    Ap2: TMenuItem;
    AW2: TMenuItem;
    Label813: Label8;
    Gauge1: TGauge;
    Gauge2: TGauge;
    Label814: Label8;
    Label818: Label8;
    A1IssF: TCurrencyEdit;
    WORI1Btn: TButton;
    WorksOrder1: TMenuItem;
    MatI1Btn: TButton;
    Match1: TMenuItem;
    Build1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    FindN1Btn: TButton;
    Find1: TMenuItem;
    A2SBox: TScrollBox;
    A2HedPanel: TSBSPanel;
    A2CLab: TSBSPanel;
    A2OLab: TSBSPanel;
    A2DLab: TSBSPanel;
    A2ILab: TSBSPanel;
    A2BLab: TSBSPanel;
    A2CPanel: TSBSPanel;
    A2IPanel: TSBSPanel;
    A2DPanel: TSBSPanel;
    A2OPanel: TSBSPanel;
    A2BPanel: TSBSPanel;
    A2ListBtnPanel: TSBSPanel;
    I4JobCodeL: Label8;
    I4JobCodeF: Text8Pt;
    I4JAnalL: Label8;
    I4JobAnalF: Text8Pt;
    J1BASISF: TSBSComboBox;
    ATRCB: TBorCheckEx;
    DefVATCB: TBorCheckEx;
    StatusF: Text8Pt;
    I1CurrF: TSBSComboBox;
    A2ValPanel: TSBSPanel;
    A2ValLab: TSBSPanel;
    TabSheet4: TTabSheet;
    SBSPanel55: TSBSBackGroup;
    SBSPanel63: TSBSPanel;
    Label21: TLabel;
    Label4: TLabel;
    I5Net1F: TCurrencyEdit;
    LabelCert: TLabel;
    I5Cert1F: TCurrencyEdit;
    Label15: TLabel;
    I5Disc1F: TCurrencyEdit;
    Label16: TLabel;
    I5Ret1F: TCurrencyEdit;
    Label20: TLabel;
    I5Ret2F: TCurrencyEdit;
    I5Disc2F: TCurrencyEdit;
    Label19: TLabel;
    I5Cert2F: TCurrencyEdit;
    Label18: TLabel;
    I5Net2F: TCurrencyEdit;
    Label17: TLabel;
    SBSPanel62: TSBSPanel;
    Label13: TLabel;
    TotLab: TLabel;
    I5Tot1F: TCurrencyEdit;
    I5Tot2F: TCurrencyEdit;
    YTDTotLab: TLabel;
    SBLT1: TScrollBox;
    I5LT1F: Text8Pt;
    I5LT2F: Text8Pt;
    I5LT3F: Text8Pt;
    I5LT4F: Text8Pt;
    I5LT5F: Text8Pt;
    I5LT6F: Text8Pt;
    I5LT7F: Text8Pt;
    I5LV1F: TCurrencyEdit;
    I5LV2F: TCurrencyEdit;
    I5LV3F: TCurrencyEdit;
    I5LV4F: TCurrencyEdit;
    I5LV5F: TCurrencyEdit;
    I5LV6F: TCurrencyEdit;
    I5LV7F: TCurrencyEdit;
    I5LT8F: Text8Pt;
    I5LV8F: TCurrencyEdit;
    I5LT9F: Text8Pt;
    I5LV9F: TCurrencyEdit;
    I5LT10F: Text8Pt;
    I5LV10F: TCurrencyEdit;
    I5LT11F: Text8Pt;
    I5LV11F: TCurrencyEdit;
    I5LT12F: Text8Pt;
    I5LV12F: TCurrencyEdit;
    I5LT13F: Text8Pt;
    I5LV13F: TCurrencyEdit;
    I5LT14F: Text8Pt;
    I5LV14F: TCurrencyEdit;
    I5LT15F: Text8Pt;
    I5LV15F: TCurrencyEdit;
    I5LV16F: TCurrencyEdit;
    I5LT16F: Text8Pt;
    I5LT17F: Text8Pt;
    I5LV17F: TCurrencyEdit;
    SBSPanel2: TSBSPanel;
    Label5: TLabel;
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
    SBSPanel3: TSBSPanel;
    Label6: TLabel;
    Label3: TLabel;
    I5VAT1F: TCurrencyEdit;
    I5LT18F: Text8Pt;
    I5LV18F: TCurrencyEdit;
    cbCert: TBorCheckEx;
    I5MVATF: TBorCheck;
    CISPanel1: TSBSPanel;
    CISBackGroup1: TSBSBackGroup;
    I5CISManCb: TBorCheck;
    Label1: TLabel;
    I5CISGrossF: TCurrencyEdit;
    I5CISTaxF: TCurrencyEdit;
    Label14: TLabel;
    Label2: TLabel;
    I5CISTotF: TCurrencyEdit;
    I5ContraF: TCurrencyEdit;
    Label8: TLabel;
    SBSBackGroup1: TSBSBackGroup;
    A2JPanel: TSBSPanel;
    A2JLab: TSBSPanel;
    TransExtForm1: TSBSExtendedForm;
    I1YrRefL: Label8;
    I1YrRef2L: Label8;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    Label89: Label8;
    IDueDateL: Label8;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    A1YRefF: Text8Pt;
    A1TDateF: TEditDate;
    I1EXRateF: TCurrencyEdit;
    FixXRF: TBorCheck;
    I1DueDateF: TEditDate;
    Bevel2: TBevel;
    cbPayAppsF: TBorCheckEx;
    PINAF: Text8Pt;
    PICQF: Text8Pt;
    PIPIF: Text8Pt;
    PICCF: Text8Pt;
    PIDepF: Text8Pt;
    PIAmtF: TCurrencyEdit;
    Label810: Label8;
    Label815: Label8;
    PILab: Label8;
    Label816: Label8;
    Label819: Label8;
    PINDF: Text8Pt;
    SBSBackGroup2: TSBSBackGroup;
    Label7: TLabel;
    I5Tot3F: TCurrencyEdit;
    PIJAF: Text8Pt;
    Label87: Label8;
    CertifiedLbl: TSBSPanel;
    lblUdf5: Label8;
    THUD5F: Text8Pt;
    lblUdf6: Label8;
    THUD6F: Text8Pt;
    lblUdf7: Label8;
    THUD7F: Text8Pt;
    lblUdf8: Label8;
    THUD8F: Text8Pt;
    lblUdf9: Label8;
    THUD9F: Text8Pt;
    lblUdf10: Label8;
    THUD10F: Text8Pt;
    PMenu_Notes: TPopupMenu;
    MenItem_General: TMenuItem;
    MenItem_Dated: TMenuItem;
    MenItem_Audit: TMenuItem;
    lblUdf11: Label8;
    THUD11F: Text8Pt;
    lblUdf12: Label8;
    THUD12F: Text8Pt;
    Shape1: TShape;
    pnlAnonymisationStatus: TPanel;
    shpNotifyStatus: TShape;
    lblAnonStatus: TLabel;
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    function A1TPerFConvDate(Sender: TObject; const IDate: string;
      const Date2Pr: Boolean): string;
    procedure A1CPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A1CLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A1CLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AddN1BtnClick(Sender: TObject);
    procedure DelN1BtnClick(Sender: TObject);
    procedure SwiN1BtnClick(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    function A1TPerFShowPeriod(Sender: TObject; const EPr: Byte): string;
    procedure OkN1BtnClick(Sender: TObject);
    procedure ClsN1BtnClick(Sender: TObject);
    procedure A1TDateFExit(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure LnkN1BtnClick(Sender: TObject);
    procedure I1AccFExit(Sender: TObject);
    procedure ChkBtnClick(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure FindN1BtnClick(Sender: TObject);
    procedure A2CLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2CLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2CPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2CPanelClick(Sender: TObject);
    procedure A1CPanelClick(Sender: TObject);
    procedure I4JobCodeFExit(Sender: TObject);
    procedure cbCertClick(Sender: TObject);
    procedure I5CISManCbClick(Sender: TObject);
    procedure I5MVATFClick(Sender: TObject);
    procedure I5VV1FExit(Sender: TObject);
    procedure I1CurrFExit(Sender: TObject);
    procedure WORI1BtnClick(Sender: TObject);
    procedure PINAFExit(Sender: TObject);
    procedure PICCFExit(Sender: TObject);
    procedure cbPayAppsFClick(Sender: TObject);
    procedure PIJAFExit(Sender: TObject);
    procedure cbCertMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A1YRefFChange(Sender: TObject);
    procedure I5CISManCbMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenItem_AuditClick(Sender: TObject);
    procedure MenItem_DatedClick(Sender: TObject);
    procedure MenItem_GeneralClick(Sender: TObject);

  private
    JustCreated,
    InvStored,
    StopPageChange,
    FirstStore,
    ReCalcTot,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    FColorsChanged,
    BalDone,
    fFrmClosing,
    fDoingClose,
    fRecordLocked,
    CouldIssue,
    GotCoord,
    CanDelete    :  Boolean;

    SKeypath,
    MinHeight,
    MinWidth     :  Integer;

    VATMatrix    :  TVATMatrix;
    LTMatrix     :  TLTMatrix;

    StatusItems,
    LTDescStr    :  TStringList;

    {$IFDEF NP}
      NotesCtrl  :  TNoteCtrl;
    {$ENDIF}

    InvBtnList   :  TVisiBtns;

    IdLine       :  TJAPLine;
    IdLineActive :  Boolean;

    RecordPage   :  Byte;
    DocHed       :  DocTypes;

    OldConTot    :  Double;

    MatchOrdPtr  :  Pointer;

    PagePoint    :  Array[0..6] of TPoint;

    StartSize,
    InitSize     :  TPoint;

    {$IFDEF Ltr}
      LetterActive: Boolean;
      LetterForm:   TLettersList;
    {$ENDIF}

    // CJS 18/11/2010 - Flag to determine whether the CIS Tax should be
    // recalculated after displaying the Line dialog. This is normally true,
    // but is set to False before displaying the Line dialog from the Manual
    // Tax checkbox on the footer tab (because under those circumstances the
    // CIS Tax will automatically be recalculated).
    CISTaxRecalcRequired: Boolean;

    //PR: 21/06/2012 ABSEXCH-11528 If editing, store o/s before any lines are changed.
    PreviousOS : Double;

    //PR: 13/12/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;

    //SSK 08/01/2018 2018R1 ABSEXCH-19613: variables for post anonymisation
    FAnonymisationON: Boolean;
    FSaveAnonPanelCord: Boolean;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure SetBtnDisable(State  :  Boolean);

    Procedure SetForceStore(State  :  Boolean);

    procedure NotePageReSize;

    Procedure Link2Nom;

    Function ChkForceStore  :  Boolean;

    // Handler for messages to the Application Lines list
    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    // Handler for messages to the Deductions list
    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;


    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;



    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Function CheckNeedStore  :  Boolean;

    Function ConfirmQuit  :  Boolean;

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure Display_Id(Mode, TBMode: Byte);

    procedure DeleteNTLine;

    procedure SetFormProperties(SetList  :  Boolean);

    procedure SetFieldProperties;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Function LinkEmpToSupplier(Var FoundCode  :  Str20;
                                   AutoLink   :  Boolean)  :  Boolean;


    procedure I1EmpFExit(Sender: TObject);

    procedure I1CustFExit(Sender: TObject);


    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure PaintListBar(MList  :  TJAPPMList);

    function FindCISLine(BInv: InvRec): Boolean;
    procedure SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);

    //SSK 08/01/2018 2018R1 ABSEXCH-19613: Routines for handling of Post Anonymisation Behaviour for JCT/JPT/JST/JPA/JSA
    procedure SetAnonymisationBanner;
    procedure SetAnonymisationON(AValue: Boolean);
    procedure SetAnonymisationPanel;

  public
    { Public declarations }

    fForceStore:  Boolean;

    ExLocal    :  TdExLocal;
    ListOfSet  :  Integer;

    MActiveList:  Boolean;

    MULCtrlO   :  TJAPPMList;
    MULCtrlO2  :  TJDedMList;


    Property ForceStore  : Boolean read fForceStore write SetForceStore default False;

    Function CheckOverride(PageNo  :  Integer)  :  Boolean;


    Function SetHelpC(PageNo :  Integer;
                      Pages  :  TIntSet;
                      Help0,
                      Help1  :  LongInt) :  LongInt;

    procedure PrimeButtons;

    procedure SetTransHelp;

    procedure BuildDesign;

    procedure FormDesign;

    Function Current_BarPos(PageNo,LNo  :  Byte)  :  Integer;

    procedure HidePanels(PageNo    :  Byte);

    procedure HidePanels2(PageNo    :  Byte);

    procedure HideListColumns(PageNo  :  Integer);

    procedure RefreshList2(ShowLines,
                           IgMsg      :  Boolean);

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure FormBuildDedList(ShowLines  :  Boolean);

    Function Current_Page  :  Integer;

    Function SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

    procedure ShowLink(ShowLines,
                       VOMode    :  Boolean);


    procedure FormSetOfSet;


    procedure SetNTxfrStore(EnabFlag,
                            VOMode  :  Boolean);

    Procedure ChangePage(NewPage  :  Integer);

    procedure SetNTxfrFields;

    procedure OutNTxfr;

    procedure ReFreshFooter(CalcMode  :  Byte);

    Procedure OutNTxfrTotals;

    procedure Form2NTxfr;

    Procedure SetFieldFocus;

    Procedure NoteUpdate;

    procedure SetNewFolio;

    procedure ProcessNtxfr(Fnum,
                           KeyPAth    :  Integer;
                           Edit,
                           AutoOn     :  Boolean);

    Function GrpValidLine(MLNo  :  Byte)  : Boolean;
    Procedure GrpRefreshLine(MLNo  :  Byte);

    Function CheckCompleted(Edit  :  Boolean)  : Boolean;

    Function Check_LinesOk(InvR  :  InvRec)  :  Boolean;

    procedure StoreNtxfr(Fnum,
                         KeyPAth    :  Integer);

    procedure EditAccount(Edit,
                          AutoOn,
                          ViewOnly   :  Boolean);
    //PR: 14/11/2017 ABSEXCH-19451
    procedure EnableEditPostedFields;

    // SSK 22/10/2017 ABSEXCH-19386: set anonymisation mode
    property AnonymisationON: Boolean read FAnonymisationON write SetAnonymisationON;
    

  end;

  Procedure Set_JAPFormMode(State  :  DocTypes;
                            NPage  :  Byte);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  CmpCtrlU,
  ColCtrlU,
  VarRec2U,
  VarJCSTU,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,

  SBSComp,

  {$IFDEF PF_On}

    InvLst2U,

  {$ENDIF}

  {$IFDEF GF}
    FindRecU,
    FindCtlU,
  {$ENDIF}

  {$IFDEF NP}
    NoteSupU,
  {$ENDIF}

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  {InvCTSUU,}

  SysU1,
  SysU2,
  SysU3,
  IntMU,
  MiscU,
  PayF2U,

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  InvCT2SU,
  JobSup2U,
  Event1U,
  PWarnU,
  JChkUseU,
  JobApWzU,
  ThemeFix,
  GenWarnU,
  AuditNotes,

  { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
  TransactionOriginator,

  CustomFieldsIntf,
  oSystemSetup,
  GDPRConst;


{$R *.DFM}


Const
  MainPage  =  0;
  AnalPage  =  1;
  BuildPage =  2;
  PayPage   =  4;
  FootPage  =  3;
  NotePage  =  5;


Var
  JAPFormMode  :  DocTypes;
  JAPFormPage  :  Byte;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_JAPFormMode(State  :  DocTypes;
                          NPage  :  Byte);

Begin
  If (State<>JAPFormMode) then
    JAPFormMode:=State;

  If (JAPFormPage<>NPage) then
    JAPFormPage:=NPage;

end;




{$I JAPI1U.PAS}



Procedure  TJCAPP.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TJCAPP.Find_FormCoord;


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

    PrimeKey:=DocCodes[DocHed][1];

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

    GetbtControlCsm(A1SBox);

    GetbtControlCsm(A1BSBox);

    GetbtControlCsm(A1BtnPanel);

    GetbtControlCsm(A1ListBtnPanel);

    GetbtControlCsm(TCNScrollBox);
    GetbtControlCsm(TCNListBtnPanel);


    If GetbtControlCsm(A1YrefF) then
      SetFieldProperties;

    if GetbtControlCsm(pnlAnonymisationStatus) then
      FSaveAnonPanelCord := True;

    MULCtrlO.Find_ListCoord(GlobComp);

    If (Assigned(MULCtrlO2)) then
      MULCtrlO2.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

      {* Check form is within current visible range *}

  With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;

  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TJCAPP.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:=DocCodes[DocHed][1];

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(A1SBox);

    StorebtControlCsm(A1BSBox);

    StorebtControlCsm(A1BtnPanel);

    StorebtControlCsm(A1ListBtnPanel);

    StorebtControlCsm(A1YrefF);

    StorebtControlCsm(TCNScrollBox);

    StorebtControlCsm(TCNListBtnPanel);

    StorebtControlcsm(pnlAnonymisationStatus);

    PaintListBar(MULCtrlO);

    MULCtrlO.Store_ListCoord(GlobComp);

    PaintListBar(MULCtrlO2);

    If (Assigned(MULCtrlO2)) then
      MULCtrlO2.Store_ListCoord(GlobComp);

    {$IFDEF NP}
      If (NotesCtrl<>nil) then
        NotesCtrl.MULCtrlO.Store_ListCoord(GlobComp);
    {$ENDIF}

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

end;


procedure TJCAPP.SetBtnDisable(State  :  Boolean);

Begin
  If (Not ExLocal.LViewOnly) then
  Begin

    If (State) then
    Begin
      ClsN1Btn.Enabled:=Not ForceStore;
      CanN1Btn.Enabled:=ClsN1Btn.Enabled;
      OkN1Btn.Enabled:=State;
    end
    else
    Begin
      ClsN1Btn.Enabled:=State;
      CanN1Btn.Enabled:=ClsN1Btn.Enabled;
      OkN1Btn.Enabled:=State;
    end;

    InvBtnList.SetEnabBtn(State);

    { CJS 2012-08-17 - ABSEXCH-12317 - JST Delete Check }
    DelN1Btn.Enabled := State and (MULCtrlO.CalcApplied = 0.0);

    {cbCert.Enabled:=State;}

  end;
end;

procedure TJCAPP.SetForceStore(State  :  Boolean);

Begin
  If (State<>fForceStore) then
  Begin
    fForceStore:=State;

    If (Not ExLocal.LViewOnly) then
    Begin
      ClsN1Btn.Enabled:=Not fForceStore;
      CanN1Btn.Enabled:=ClsN1Btn.Enabled;
    end;
  end;
end;


Function TJCAPP.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;


Procedure TJCAPP.Link2Nom;

Var
  FoundOk   :  Boolean;
  FoundLong :  LongInt;
  FoundStk  :  Str20;

Begin
  With Id do
  Begin

    {$IFDEF PF_On}

      If (Syss.UseCCDep) then
      Begin
        CCLab.Caption:=CCDep[BOn];
        DepLab.Caption:=CCDep[BOff];
      end;



    {$ENDIF}


  end;
end;

{ == Set Force store conditions == }

Function TJCAPP.ChkForceStore  :  Boolean;

Begin
  With ExLocal do
  Begin
    Result:=((LInv.ILineCount<>LastInv.ILineCount) or
             (Linv.TotalCost<>LastInv.TotalCost) or
             (Linv.TotalInvoiced<>LastInv.TotalInvoiced) or
             (LInv.TotalReserved<>LastInv.TotalReserved) or
             (LInv.InvNetVal<>LastInv.InvNetVal) or
             (LInv.DiscAmount<>LastInv.DiscAmount) or
             (LInv.DiscSetAm<>LastInv.DiscSetAm) or
             (LInv.PDiscTaken<>LastInv.PDiscTaken)
             );


  end;
end;

// Handler for messages to the Application Lines list
Procedure TJCAPP.WMCustGetRec(Var Message  :  TMessage);
Var
  mbRet  :  Word;

Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin

              If (WParam=169) then
                MULCtrlO.GetSelRec(BOff);

              Case Current_Page of

                NotePage
                       :  AddN1BtnClick(EditN1Btn);

                else  If Not CheckOverride(Current_Page) then
                      Begin

                        Display_Id(2, 0);

                        If (IdLineActive) and (Not ExLocal.InAddEdit) then {*it must be readonly *}
                          IdLine.Show;
                      end;
              end; {Case..}
            end;

      1  :  Begin

              {* Show nominal/cc dep data *}

              Link2Nom;

              { CJS 2012-08-17 - ABSEXCH-12317 - JST Delete Check }
              DelN1Btn.Enabled := (MULCtrlO.CalcApplied = 0.0);

            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      3  :  Begin

              If (Not JustCreated) then
                A1CPanelClick(Nil);
              { CJS 2012-08-17 - ABSEXCH-12317 - JST Delete Check }
              GrpRefreshLine(Ord(MActiveList));
              DelN1Btn.Enabled := (MULCtrlO.CalcApplied = 0.0);
            end;

      7  :  NoteUpDate; {* Update note line count *}

     17  :  Begin {* Force reset of form *}
              GotCoord:=BOff;
              SetDefault:=BOn;
              Close;
            end;

      25  :  Begin
              NeedCUpdate:=BOn;
              FColorsChanged := True;
            End;


     CANCEL_MSG_PARAM :
          if Boolean(lParam) then
          begin
            if (not ExLocal.LId.LiveUplift) then
            begin
              ExLocal.LInv.CISManualTax := False;
              I5CISManCb.Checked := False;
            end;
            CISTaxRecalcRequired := True;
          end;

     108  :
             Begin
               With MULCtrlO do
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));

               If (IdLine<>nil) then
               With ExLocal do
               Begin
                 LInv:=IdLine.ExLocal.LInv;
                 LJAPLineTotal:=IdLine.ExLocal.LJAPLineTotal;

                 OutNTxfrTotals;

                 If (LastEdit) and (Not LViewOnly) and (Not ForceStore) then
                   ForceStore:=ChkForceStore;

                 ReCalcTot:=(ReCalcTot or ForceStore);

                 If (Assigned(MULCtrlO2)) then
                 With MULCtrlO2 do
                 Begin
                   If (PageKeys^[0]<>0) then
                   Begin
                     PageUpDn(0,BOn);
                   end;

                   If (PageKeys^[0]=0) then  {Sometimes a ghost line 1 exists which PaheUpDn will reset, so we have another go}
                     InitPage;

                  end;
               end;

            end;

    120,121
         :  Begin

              InvBtnList.SetEnabBtn((WParam=120));

              { CJS 2012-08-17 - ABSEXCH-12317 - JST Delete Check }
              GrpRefreshLine(Ord(MActiveList));
              DelN1Btn.Enabled := (WParam=120) and (MULCtrlO.CalcApplied = 0.0);

            end;

       131 :  With MULCtrlO do
              Begin
                If (PageKeys^[0]<>0) then
                Begin
                  PageUpDn(0,BOn);
                end;

                If (PageKeys^[0]=0) then  {Sometimes a ghost line 1 exists which PaheUpDn will reset, so we have another go}
                  InitPage;

                If (IdLine<>nil) then
                With ExLocal do
                Begin
                  LInv:=IdLine.ExLocal.LInv;
                  LJAPLineTotal:=IdLine.ExLocal.LJAPLineTotal;

                  OutNTxfrTotals;
                  ReCalcTot:=BOn;
                end;

              end;

     {$IFDEF FRM}

       170  :  Begin
                 {$B-}
                 If (Not ExLocal.InAddEdit) or ((Not CheckFormNeedStoreChk(Self,BOff)) and (ExLocal.LastEdit) and (Not ForceStore)) then
                   PrintDocument(ExLocal,BOn)
                 {$B+}
                 else
                   mbRet:=CustomDlg(Application.MainForm,'Please note','Print Transaction',
                                    'This transaction may only be printed once it has been stored.'+#13+#13+
                                    'Please complete this transaction, and then choose print.',mtInformation,[mbOk]);

               end;


     {$ENDIF}

    //GS: 16/05/11 ABSEXCH-11356
    //added a 'wParam = 171' (opening the object drill) branch, now when the object drill is opened
    //and the active MDI form is TRecepForm (Sales Recipt / Purchase Payment record) the global invoice record
    //is refreshed beforehand, instead of using the last available global invoice record; which may not be
    //the record currently being displayed.

    171 :  Begin  // Link for ObjectDrill
              MULCtrlO.GetSelRec(BOff);
              ExLocal.AssignToGlobal(InvF);
            end;

     175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);


     176 :  Case LParam of
              0  :  Case Current_Page of
                      NotePage
                         :  {$IFDEF NP}
                              If (Assigned(NotesCtrl)) then
                                NotesCtrl.MULCtrlO.SetListFocus;
                            {$ELSE}
                              ;
                            {$ENDIF}

                      else  If (Assigned(MULCtrlO)) then
                              MULCtrlO.SetListFocus;

                    end; {Case..}
            end; {Case..}



     200 :  Begin

              IdLine:=nil;
              IdLineActive:=BOff;

              InvBtnList.SetEnabBtn(BOn);

              { CJS 2012-08-17 - ABSEXCH-12317 - JST Delete Check }
              DelN1Btn.Enabled := (MULCtrlO.CalcApplied = 0.0);

              MULCtrlO.SetListFocus;
            end;

     {$IFDEF Ltr}
       400,
       401  : Begin
                LetterActive:=Boff;
                LetterForm:=nil;
              end;
     {$ENDIF}

     {$IFDEF GF}

     3003
           : If (Assigned(FindCust)) then
               With MULCtrlO,FindCust,ReturnCtrl do
               Begin
                 InFindLoop:=BOn;

                 Find_OnList(7,Trim(RecMainKey));


                 InFindLoop:=BOff;
               end;

    {$ENDIF}


      {3000,
      3001,
      3010,
      3011
         :  Begin
              If (WParam<3010) and (WindowState=wsMinimized) then
                WindowState:=wsNormal;

              If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) then
              Begin
                ShowLink(BOn,BOn);
              end;
            end;}



    end; {Case..}

  end;
  Inherited;
end;


// Handler for messages to the Deductions list
Procedure TJCAPP.WMFormCloseMsg(Var Message  :  TMessage);
Begin


  With Message do
  Begin


    Case WParam of

      0,169
         :  Begin

              If (WParam=169) then
                MULCtrlO2.GetSelRec(BOff);

              Case Current_Page of  {* EN560. This appears to be duplicated, but not sure how notes will be handled with the split display. *}

                NotePage
                       :  AddN1BtnClick(EditN1Btn);

                else  If Not CheckOverride(Current_Page) then
                      Begin

                        Display_Id(2,1+Ord(Current_Page=AnalPage));

                        If (IdLineActive) and (Not ExLocal.InAddEdit) then {*it must be readonly *}
                          IdLine.Show;
                      end;
              end; {Case..}
            end;

      1  :  Begin

              {* Show nominal/cc dep data *}

              Link2Nom;


            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      3  :  Begin
              If (Not JustCreated) then
                A2CPanelClick(Nil);
            end;

      7  :  NoteUpDate; {* Update note line count *}


      25  :  Begin
              NeedCUpdate:=BOn;
              FColorsChanged := True;
            End;


      48  :  MatchOrdPtr:=nil;


     108  :
             Begin
               if (CISTaxRecalcRequired) then
                 Calc_CISTaxInv(Idline.ExLocal.LInv, True)
               else
                // Set the flag ready for next time (True should be the
                // default).
                CISTaxRecalcRequired := True;
               With MULCtrlO2 do
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));

               If (IdLine<>nil) then
               With ExLocal do
               Begin
                 LInv:=IdLine.ExLocal.LInv;
                 LJAPLineTotal:=IdLine.ExLocal.LJAPLineTotal;

                 OutNTxfrTotals;

                 If (LastEdit) and (Not LViewOnly) and (Not ForceStore) then
                   ForceStore:=ChkForceStore;

                 ReCalcTot:=(ReCalcTot or ForceStore);
               end;


            end;

    120,121
         :  Begin

              InvBtnList.SetEnabBtn((WParam=120));

            end;

       131 :  With MULCtrlO2 do
              Begin
                If (PageKeys^[0]<>0) then
                Begin
                  PageUpDn(0,BOn);
                end;

                If (PageKeys^[0]=0) then  {Sometimes a ghost line 1 exists which PaheUpDn will reset, so we have another go}
                  InitPage;

                If (IdLine<>nil) then
                With ExLocal do
                Begin
                  LInv:=IdLine.ExLocal.LInv;
                  LJAPLineTotal:=IdLine.ExLocal.LJAPLineTotal;

                  OutNTxfrTotals;
                  ReCalcTot:=BOn;
                end;

              end;





     176 :  Case LParam of
              0  :  Case Current_Page of
                      NotePage
                         :  {$IFDEF NP}
                              If (Assigned(NotesCtrl)) then
                                NotesCtrl.MULCtrlO.SetListFocus;
                            {$ELSE}
                              ;
                            {$ENDIF}

                      else  If (Assigned(MULCtrlO2)) then
                              MULCtrlO2.SetListFocus;

                    end; {Case..}
            end; {Case..}




    end; {Case..}

  end;
  Inherited;
end;


Procedure TJCAPP.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

Begin

  With Message.MinMaxInfo^ do
  Begin

    ptMinTrackSize.X:=MinWidth;
    ptMinTrackSize.Y:=MinHeight;

    {ptMaxSize.X:=530;
    ptMaxSize.Y:=368;
    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}

  end;

  Message.Result:=0;

  Inherited;

end;

{ == Procedure to Send Message to Get Record == }

Procedure TJCAPP.Send_UpdateList(Edit   :  Boolean;
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


procedure TJCAPP.ShowLink(ShowLines,
                               VOMode    :  Boolean);
var
  lAnonStat: string;      //SSK 08/01/2018 2018R1 ABSEXCH-19613: variable added

begin
  ExLocal.AssignFromGlobal(InvF);
  ExLocal.LGetRecAddr(InvF);

  With ExLocal,LInv do
  Begin

    //SSK 08/01/2018 2018R1 ABSEXCH-19613: update caption for anonymisation
    lAnonStat := ' ';
    if GDPROn and (thAnonymised) and (InvDocHed <> JPT) then
      lAnonStat := lAnonStat + capAnonymised;

    Caption := DocNames[InvDocHed]+' Record - ' + Pr_OurRef(LInv) + lAnonStat;

    {$B-}

    LViewOnly:=SetViewOnly(ShowLines,VOMode);


    PrimeButtons;

    {$B+}

    //SSK 08/01/2018 2018R1 ABSEXCH-19613: determine anonymisation status of the trans.
    //HV 30/01/2018 2018R1 ABSEXCH-19683: Remove Post Anon behaviour and Remove custom field 'Contains PII data' check box for JPT.
    if (ShowLines or VOMode) and (InvDocHed <> JPT)  then
      FAnonymisationON := (GDPROn and (trim(OurRef) <> '') and thAnonymised)
    else
      FAnonymisationON := False;

    SetAnonymisationBanner;

    If (Not LViewOnly) and (InvDocHed In JAPJAPSplit) then
    Begin {OVerride some read only behaviour}
      If (DeliverRef='') then
      Begin
        J1BASISF.Tag:=1;
        J1BASISF.Color:=A1YRefF.Color;
        J1BASISF.ReadOnly:=BOff;

      end;

    end;


  end;


  OutNTxfr;



  ReFreshList(ShowLines,Not JustCreated);

  {$IFDEF NP}

    If (Current_Page=NotePage) and (NotesCtrl<>nil) then {* Assume record has changed *}
    With ExLocal do
    Begin
      NotesCtrl.RefreshList(FullNomKey(LInv.FolioNum),NotesCtrl.GetNType);
      NotesCtrl.GetLineNo:=LInv.NLineCount;
    end;
  {$ENDIF}

  JustCreated:=BOff;

end;


procedure TJCAPP.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(A1SBox.Width);
  PagePoint[1].Y:={PageControl1.Height-}(A1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(A1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(A1BtnPanel.Height);

  PagePoint[3].X:=A1BtnPanel.Height-(A1BSBox.Height);
  PagePoint[3].Y:=A1SBox.ClientHeight-(A1DPanel.Height);

  PagePoint[4].X:=PageControl1.Width-(A1ListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(A1ListBtnPanel.Height);

  PagePoint[5].X:=PageControl1.Width-(TCNScrollBox.Width);
  PagePoint[5].Y:=PageControl1.Height-(TCNScrollBox.Height);

  PagePoint[6].Y:=PageControl1.Height-(TCNListBtnPanel.Height);
  PagePoint[6].X:=PageControl1.Height;

  GotCoord:=BOn;

end;

Function TJCAPP.CheckOverride(PageNo  :  Integer)  :  Boolean;

Begin
  Result:=(MActiveList and (DocHed In JAPJAPSplit) and
        (((PageNo=MainPage) and (Not PChkAllowed_In((458*Ord(DocHed In JAPSalesSplit))+(461*Ord(DocHed In JAPPurchSplit)))))
        or
        ((PageNo=AnalPage) and (Not PChkAllowed_In((459*Ord(DocHed In JAPSalesSplit))+(462*Ord(DocHed In JAPPurchSplit)))))));
end;

Function TJCAPP.SetHelpC(PageNo :  Integer;
                             Pages  :  TIntSet;
                             Help0,
                             Help1  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    If (PageNo=NotePage) then
      Result:=Help1
    else
      Result:=Help0;
  end
  else
    Result:=-1;

end;

procedure TJCAPP.PrimeButtons;

Var
  PageNo        :  Integer;
  SetOverride   :  Boolean;
  ViewOnly      :  Boolean;
  HelpID        :  Integer;
  CanModify     :  Boolean;
Begin
  PageNo:=Current_Page;

  SetOverride:=BOff;

  If (InvBtnList=nil) then
  Begin
    InvBtnList:=TVisiBtns.Create;

    try

      With InvBtnList do
        Begin
    {00}  AddVisiRec(AddN1Btn,BOff);
    {01}  AddVisiRec(EditN1Btn,BOff);
    {02}  AddVisiRec(DelN1Btn,BOff);
    {03}  AddVisiRec(InsN1Btn,BOff);
    {04}  AddVisiRec(FindN1Btn,BOn);
    {05}  AddVisiRec(SwiN1Btn,BOff);
    {06}  AddVisiRec(APickI1Btn,BOff);
    {07}  AddVisiRec(WORI1Btn,BOff);
    {08}  AddVisiRec(MATI1Btn,BOff);
    {09}  AddVisiRec(ChkBtn,BOff);
    {10}  AddVisiRec(LnkN1Btn,BOff);
        end; {With..}

    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  try

    With InvBtnList do
    Begin
      {* EN560 Will need new passwords and help ids *}

      SetOverride:=CheckOverride(PageNo);

      if (not SetOverride) and (cbCert.Checked) and (PageNo <> NotePage) then
        SetOverride := True;

      ViewOnly := (ExLocal.LViewOnly or cbCert.Checked);

      HelpID := SetHelpC(PageNo, [MainPage..NotePage], -255, -255);
      if SetOverride or (PageNo In [FootPage, PayPage]) or not PChkAllowed_In(HelpID) then
        CanModify := False
      else
        CanModify := (not fRecordLocked and not ViewOnly) or (PageNo = NotePage);

      SetHideBtn(0, not CanModify, BOff); // Add
      if CanModify then
        EditN1Btn.Caption := '&Edit'
      else
        EditN1Btn.Caption := '&View';

      SetBtnHelp(0, SetHelpC(PageNo,[MainPage..NotePage],0,88));
      SetBtnHelp(1, SetHelpC(PageNo,[MainPage..NotePage],0,87));

      SetHideBtn(2, not CanModify, BOff); // Delete
      SetBtnHelp(2, SetHelpC(PageNo,[MainPage..NotePage],0,89));

      SetHideBtn(3, not CanModify, BOff); // Insert

      SetHideBtn(5, (PageNo <> NotePage), BOff); // Switch

      SetHideBtn(7, (PageNo In [NotePage,FootPage,PayPage]) or
                    ((Not ExLocal.LastEdit) and (Not ExLocal.LViewOnly)) or
                    (DocHed In JAPJAPSplit) or (Not PChkAllowed_In(HelpID)),
                    BOff);

      SetHideBtn(6, BOn, BOff);
      SetHideBtn(8, BOn, BOff);

      SetHideBtn(9, (ViewOnly or fRecordLocked) or (PageNo In [NotePage, FootPage, PayPage]), BOff);
      SetHideBtn(10, (PageNo In [NotePage]), BOn);

    end;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

procedure TJCAPP.SetTransHelp;

Begin
  Case DocHed of
    JPT  :  Begin
              Self.HelpContext:=1527;
              J1BasisF.HelpContext:=1510;
              I1AccF.HelpContext:=1520;
            end;

    JCT  :  Begin
              Self.HelpContext:=1519;
              I1AccF.HelpContext:=1520;
            end;

    JPA  :  Begin
              J1BasisF.HelpContext:=1530;
              I1AccF.HelpContext:=1520;
              Self.HelpContext:=1526;
            end;
    JST  :  Begin
              I1AccF.HelpContext:=1541;
              Self.HelpContext:=1540;
            end;

    JSA  :  Begin
              Self.HelpContext:=1551;
              J1BasisF.HelpContext:=1530;
              I1AccF.HelpContext:=1541;
            end;

  end; {Case..}
end;


procedure TJCAPP.BuildDesign;

Var
  HideCC,
  HideLoc  :  Boolean;
  Category: Integer;
  VisibleFieldCount: Integer;
begin

  {* Set Version Specific Info *}

  TabSheet3.TabVisible:=(DocHed In JapSalesSplit);

  A1YRefF.MaxLength:=DocYRef2Len;

  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}


  {CCPanel.Visible:=Not HideCC;}


  If (HideCC ) then
    CCPanel.Visible:=BOff
  else
    If HideCC then
    Begin
      CCTit.Visible:=BOff;
      CCLab.Visible:=BOff;
      DepTit.Visible:=BOff;
      DepLab.Visible:=BOff;
      Label815.Visible:=BOff;
      PICCF.Visible:=BOff;
      PIDepF.Visible:=BOff;

      Label87.Left:=Label815.Left;
      PIJAF.Left:=PICCF.Left;
    end;

  {CreateSubMenu(PopUpMenu2,AutoPick1);}


  CostPanel.Visible:=PChkAllowed_In(143);
  IssuePanel.Visible:=CostPanel.Visible;

  {UDF1L.Caption:=Get_CustmFieldCaption(2,9);
  UDF1L.Visible:=Not Get_CustmFieldHide(2,9);

  THUD1F.Visible:=UDF1L.Visible;

  UDF2L.Caption:=Get_CustmFieldCaption(2,10);
  UDF2L.Visible:=Not Get_CustmFieldHide(2,10);

  THUD2F.Visible:=UDF2L.Visible;


  UDF3L.Caption:=Get_CustmFieldCaption(2,11);
  UDF3L.Visible:=Not Get_CustmFieldHide(2,11);

  THUD3F.Visible:=UDF3L.Visible;


  UDF4L.Caption:=Get_CustmFieldCaption(2,12);
  UDF4L.Visible:=Not Get_CustmFieldHide(2,12);

  THUD4F.Visible:=UDF4L.Visible;} {*EN560. Needs to be given its own custom fields *}

  //GS 14/03/2012 ABSEXCH-12128: determine what record type we are showing
  //then retrieve the labels for that record types UDFs
  Case DocHed of
    JCT:
    begin
      Category := cfJCTHeader;
    end;
    JPT:
    begin
      Category := cfJPTHeader;
    end;
    JST:
    begin
      Category := cfJSTHeader;
    end;
    JPA:
    begin
      Category := cfJPAHeader;
    end;
    JSA:
    begin
      Category := cfJSAHeader;
    end;
    else //PR: 23/03/2016 v2016 R1 ABSEXCH-17390
      raise Exception.Create('Invalid DocType in TJCAPP.BuildDesign: ' + DocCodes[DocHed]);
  end;//end case

  //set captions of labels, and visibility of edit boxes for UDF fields
  // PKR. 24/03/2016. ABSEXCH-17383. Add UDFs 11 and 12 for eRCT support
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, lblUDF5, lblUDF6, lblUDF7, lblUDF8, lblUDF9, lblUDF10, lblUDF11, lblUDF12],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F]
             Category);

  //get a count of the number of enabled UDFs
  // PKR. 24/03/2016. ABSEXCH-17383. Add UDFs 11 and 12 for eRCT support
  VisibleFieldCount := NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F]);
  //adjust proceeding controls to cover up any space left unoccupied by hidden fields:
  //resize the UDF dropdown form:
  ResizeUDFParentContainer(VisibleFieldCount,
                           2,
                           TransExtForm1,
                           0,     // RowHeightOverRide
                           12);   // UDF_Count

  TransExtform1.ReAssignFocusLast;

  Label14.Caption:=CCCISName^+' Tax';
  Label2.Caption:=CCCISName^+' Tax';
  A1ILab.Caption:=CCVATName^;

  CISBackGroup1.Caption:=CCCISName^+' '+CISBackGroup1.Caption;

  Label3.Caption:=CCVATName^;
  Label6.Caption:=CCVATName^+' '+Label6.Caption;
  I5MVATF.Caption:=CCVATName^+I5MVATF.Caption;


  {$IFNDEF MC_On}
    I1CurrF.Visible:=BOff;
    A1IssF.Left:=I1CurrF.Left;
    I1ExRateF.Visible:=BOff;
    Label89.Visible:=BOff;
    FixXRF.Visible:=BOff;
  {$ELSE}
    Set_DefaultCurr(I1CurrF.Items,BOff,BOff);
    Set_DefaultCurr(I1CurrF.ItemsL,BOff,BOn);

    FixXRF.Visible:=(Not (DocHed In [JPA,JSA])) and (UseCoDayRate);

    {I5Tot1F.ShowCurrency:=BOn;
    I5Tot2F.ShowCurrency:=BOn;}

  {$ENDIF}

  If (Not (DocHed In JAPJAPSplit)) then
  With J1BASISF do
  Begin
    Items.Clear;
    Items.Add('Incremental');
    Items.Add('Gross Incremntl');
    Items.Add('Gross');

    If (DocHed=JPT) then
    Begin
      I4JAnalL.Visible:=BOff;
      I4JobAnalF.Visible:=BOff;
    end;

    IDueDateL.Visible:=BOff;
    I1DueDateF.Visible:=BOff;

    Set_DefaultJARet(StatusItems,BOn,BOff);

    Label818.Caption:='Currency';

    {I1CurrF.Visible:=BOff;}
    A1IssF.Visible:=BOff;

    DrReqdTit.Caption:='Budget';
    CrReqdTit.Caption:='Deductions';


    LabelCert.Visible:=BOff;
    I5Cert1F.Visible:=BOff;
    cbCert.Visible:=BOff;

    Label3.Caption:='Total';
    TotLab.Caption:='B. O/S';

    ScrollBox8.Visible:=BOff;
    Label6.Visible:=BOff;
    I5MVATF.Visible:=BOff;
    SBSPanel3.Visible:=BOff;

    {Label8.Visible:=BOff;
    I5ContraF.Visible:=BOff;}


    If (DocHed In [JPT,JST]) then
    Begin
      I4JobCodeF.Tag:=0;
      I4JobCodeF.Color:=clBtnFace;

      If (DocHed In [JPT]) then
      Begin
        Label84.Visible:=BOff;
        I1AccF.Visible:=BOff;
        {J1BasisF.Visible:=BOff;}
        Label814.Visible:=BOff;
        StatusF.Visible:=BOff;
      end
      else
        If (DocHed In [JST]) then
        Begin
          PICQF.Visible:=BOff;
          PIPIF.Visible:=BOff;
          PIAMTF.Visible:=BOff;
          Label816.Visible:=BOff;
          PILab.Visible:=BOff;
          Label810.Visible:=BOff;
          Label7.Visible:=BOff;
          I5Tot3F.Visible:=BOff;

        end;

    end;
  end
  else
  Begin
    Set_DefaultJARet(J1BASISF.ITems,BOn,BOff);

    If (DocHed In JAPJAPSplit) then
    Begin
      J1BASISF.Tag:=0;
      J1BASISF.Color:=clBtnFace;
    end
    else
      J1BASISF.ItemIndex:=1;

    If (DocHed=JSA) then
      I4JAnalL.Caption:='JST';

    Label4.Caption:='Applied';

    Label21.Caption:='Previous Totals';

    Gauge1.Visible:=BOff;
    Gauge2.Visible:=BOff;

    Label812.Visible:=BOff;
    Label813.Visible:=BOff;

    Label814.Caption:='Basis';

  end;

  If (DocHed In [JSA,JST]) or (Not CISOn) then
  Begin
    Label14.Visible:=BOff;
    I5CISTaxF.Visible:=BOff;
    I5CISTotF.Visible:=BOff;
    Label2.Visible:=BOff;

    If (DocHed In [JSA,JST]) then
    Begin
      Label84.Caption:='A/C';

    end;
  end;

  //GS 16/04/2012 ABSEXCH-12808: removed redundant resise code
  (*
  If (Not THUD1F.Visible) or (Not THUD2F.Visible) or (Not THUD3F.Visible) or (Not THUD4F.Visible) then
  With TransExtForm1 do
  Begin
    If ((Not THUD1F.Visible) and (Not THUD2F.Visible) and (Not THUD3F.Visible) and (Not THUD4F.Visible)) then
      ExpandedHeight:=Height;

  end;
  *)

  {* Build VAT Matrix *}

  try

    With VATMatrix do
    Begin
      AddVisiRec(I5VR1F,I5VV1F,I5VG1F);
      AddVisiRec(I5VR2F,I5VV2F,I5VG2F);
      AddVisiRec(I5VR3F,I5VV3F,I5VG3F);
      AddVisiRec(I5VR4F,I5VV4F,I5VG4F);
      AddVisiRec(I5VR5F,I5VV5F,I5VG5F);
      AddVisiRec(I5VR6F,I5VV6F,I5VG6F);
      AddVisiRec(I5VR7F,I5VV7F,I5VG7F);
      AddVisiRec(I5VR8F,I5VV8F,I5VG8F);
      AddVisiRec(I5VR9F,I5VV9F,I5VG9F);
      AddVisiRec(I5VR10F,I5VV10F,I5VG10F);
      AddVisiRec(I5VR11F,I5VV11F,I5VG11F);
      AddVisiRec(I5VR12F,I5VV12F,I5VG12F);
      AddVisiRec(I5VR13F,I5VV13F,I5VG13F);
      AddVisiRec(I5VR14F,I5VV14F,I5VG14F);
      AddVisiRec(I5VR15F,I5VV15F,I5VG15F);
      AddVisiRec(I5VR16F,I5VV16F,I5VG16F);
      AddVisiRec(I5VR17F,I5VV17F,I5VG17F);
      AddVisiRec(I5VR18F,I5VV18F,I5VG18F);
      AddVisiRec(I5VR19F,I5VV19F,I5VG19F);
      AddVisiRec(I5VR20F,I5VV20F,I5VG20F);
      AddVisiRec(I5VR21F,I5VV21F,I5VG21F);
    end;

  except

    VATMatrix:=nil

  end;


  {* Build LT Matrix *}

  try

    With LTMatrix do
    Begin
      AddVisiRec(I5LT1F,I5LV1F,LTDescStr.Strings[0]);
      AddVisiRec(I5LT2F,I5LV2F,LTDescStr.Strings[1]);
      AddVisiRec(I5LT3F,I5LV3F,LTDescStr.Strings[2]);
      AddVisiRec(I5LT4F,I5LV4F,LTDescStr.Strings[3]);
      AddVisiRec(I5LT5F,I5LV5F,LTDescStr.Strings[4]);
      AddVisiRec(I5LT6F,I5LV6F,LTDescStr.Strings[5]);
      AddVisiRec(I5LT7F,I5LV7F,LTDescStr.Strings[6]);
      AddVisiRec(I5LT8F,I5LV8F,LTDescStr.Strings[7]);
      AddVisiRec(I5LT9F,I5LV9F,LTDescStr.Strings[8]);
      AddVisiRec(I5LT10F,I5LV10F,LTDescStr.Strings[9]);
      AddVisiRec(I5LT11F,I5LV11F,LTDescStr.Strings[10]);
      AddVisiRec(I5LT12F,I5LV12F,LTDescStr.Strings[11]);
      AddVisiRec(I5LT13F,I5LV13F,LTDescStr.Strings[12]);
      AddVisiRec(I5LT14F,I5LV14F,LTDescStr.Strings[13]);
      AddVisiRec(I5LT15F,I5LV15F,LTDescStr.Strings[14]);
      AddVisiRec(I5LT16F,I5LV16F,LTDescStr.Strings[15]);
      AddVisiRec(I5LT17F,I5LV17F,LTDescStr.Strings[16]);
      AddVisiRec(I5LT18F,I5LV18F,LTDescStr.Strings[16]);
    end;

  except

    LTMatrix:=nil

  end;


end;


procedure TJCAPP.FormDesign;


begin

  PrimeButtons;

  BuildDesign;

  SetTransHelp;
end;

procedure TJCAPP.HidePanels(PageNo    :  Byte);

Var
  TmpBo  :  Boolean;
  n      :  Integer;

Begin
  With MULCtrlO,VisiList do
  Begin
    fBarOfSet:=Current_BarPos(PageNo,1);

    Case PageNo of

      MainPage
         :  Begin
              For n:=2 to 12 do
                SetHidePanel(FindxColOrder(n),(n>=9) or ((Not (DocHed In JAPJAPSplit)) and (n=6)),(n=12));

            end;
      AnalPage
         :  Begin
              For n:=2 to 12 do
                SetHidePanel(FindxColOrder(n),(((n<=10) and (n>5)) or (n=2)),BOff);

              {$IFNDEF PF_On}
                TmpBo:=BOn;
              {$ELSE}
                TmpBo:=Not Syss.UseCCDep;
              {$ENDIF}

              {SetHidePanel(FindxColOrder(9),Not PChkAllowed_In(143),BOff); {Hide Cost if hide gp set}
              {SetHidePanel(FindxColOrder(10),Not Syss.UseMLoc,BOff);}
              SetHidePanel(FindxColOrder(11),TmpBo,BOff);
              SetHidePanel(FindxColOrder(12),TmpBo,BOn);

            end;


    end; {Case..}

  end; {with..}

end;


procedure TJCAPP.HidePanels2(PageNo    :  Byte);

Var
  TmpBo  :  Boolean;
  n      :  Integer;

Begin

  With MULCtrlO2,VisiList do
  Begin
    fBarOfSet:=Current_BarPos(PageNo,2);

    Case PageNo of

      MainPage
         :  Begin
              For n:=5 to 5 do
                SetHidePanel(FindxColOrder(n),BOff,(n=5));

              A2CLab.Caption:='Deduction Code';
              A2ILab.Caption:='Deduction';

            end;

      AnalPage
         :  Begin
              For n:=5 to 5 do
                SetHidePanel(FindxColOrder(n),BOn,(n=5));

              A2CLab.Caption:='Retention Code';
              A2ILab.Caption:='Retention';

            end;


    end; {Case..}

  end; {with..}
end;


Function TJCAPP.Current_BarPos(PageNo,LNo  :  Byte)  :  Integer;

Begin
  Result := 0;
  Case PageNo of
      MainPage
         :  Case LNo of
               1  :  Result:=A1SBox.HorzScrollBar.Position;
               2  :  Result:=A2SBox.HorzScrollBar.Position;
            end; {Case..}

      else  Result:=0;
    end; {Case..}


end;


procedure TJCAPP.RefreshList2(ShowLines,
                              IgMsg      :  Boolean);

Var
  KeyStart2   :  Str255;

Begin

  With MULCtrlO2 do
  Begin
    IgnoreMsg:=IgMsg;

    KeyStart2:=FullIdkey(EXLocal.LInv.FolioNum,JALDedLineNo+(-1*Ord(Current_Page=AnalPage))); {* EN560 prime with separate key for bottom list *}

    StartList(IdetailF,IdFolioK,KeyStart2,'','',5,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;


end;


procedure TJCAPP.RefreshList(ShowLines,
                                 IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;

Begin
  KeyStart:=FullIdkey(EXLocal.LInv.FolioNum,1);

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    AppliedTotalFound := False;
    StartList(IdetailF,IdFolioK,KeyStart,'','',4,(Not ShowLines));
    if AppliedTotalFound then
    begin
//      J1BasisF.Enabled := False;
      J1BasisF.ReadOnly := True;
//      J1BasisF.Font.Color := Font.Color;
      J1BasisF.SelLength := 0;
    end
    else
      J1BasisF.ReadOnly := False;

    IgnoreMsg:=BOff;
  end;

  RefreshList2(ShowLines,IgMsg);

end;


procedure TJCAPP.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TJAPPMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO do
    Begin

      Try

        With VisiList do
        Begin
          {00} AddVisiRec(A1CPanel,A1CLab);
          {01} AddVisiRec(A1DPanel,A1DLab);
          {02} AddVisiRec(A1BPanel,A1BLab);
          {03} AddVisiRec(A1UOPanel,A1UOLab);
          {04} AddVisiRec(A1OSPanel,A1OSLab);
          {05} AddVisiRec(A1BUPanel,A1BULab);
          {06} AddVisiRec(A1IPanel,A1ILab);
          {07} AddVisiRec(A1OPanel,A1OLab);
          {08} AddVisiRec(A1IssPanel,A1IssLab);
          {09} AddVisiRec(A1LocPanel,A1LocLab);
          {10} AddVisiRec(A1GPanel,A1GLab);
          {11} AddVisiRec(A1CCPanel,A1CCLab);
          {12} AddVisiRec(A1DpPanel,A1DpLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels(MainPage);

          LabHedPanel:=A1HedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;


      ListOfSet:=10;


      Find_FormCoord;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=12;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [2..6,10]) then
        Begin
          DispFormat:=SGFloat;

          Case n of
            2    :  NoDecPlaces:=Syss.NoQtyDec;
            3..9
                 :  NoDecPlaces:=2;

            else    NoDecPlaces:=0;
          end; {Case..}
        end;
      end;

      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;

      Filter[1,1]:=NdxWeight;

      Set_Buttons(A1ListBtnPanel);

      HighLiteStyle[1]:=[fsBold];
      HighLiteStyle[2]:=[fsUnderline,fsBold];

      aBarBkColor:=ColAppear^[0].HBkColor;
      aBarTextColor:=ColAppear^[0].HTextColor;

      FormBuildDedList(ShowLines);


    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;


  FormSetOfSet;

  FormReSize(Self);

  A1CPanelClick(Nil);

end;


procedure TJCAPP.FormBuildDedList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO2:=TJDedMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO2 do
    Begin

      Try

        With VisiList do
        Begin
          {00} AddVisiRec(A2CPanel,A2CLab);
          {01} AddVisiRec(A2DPanel,A2DLab);
          {02} AddVisiRec(A2IPanel,A2ILab);
          {03} AddVisiRec(A2ValPanel,A2ValLab);
          {04} AddVisiRec(A2OPanel,A2OLab);
          {05} AddVisiRec(A2BPanel,A2BLab);
          {06} AddVisiRec(A2JPanel,A2JLab);


          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels2(MainPage);

          LabHedPanel:=A2HedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;


      ListOfSet:=10;


      Find_FormCoord;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=6;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_FormCloseMsg;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [2,3]) then
        Begin
          DispFormat:=SGFloat;

          Case n of
            2  :  Begin
                    NoDecPlaces:=3;
                  end;
            3
               :  NoDecPlaces:=2;

               
            else    NoDecPlaces:=0;
          end; {Case..}
        end;
      end;

      ListLocal:=@ExLocal;  {*EN560 prob needs its own exlocal}

      ListCreate;

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;


      Set_Buttons(A2ListBtnPanel);

      HighLiteStyle[1]:=[fsBold];
      HighLiteStyle[2]:=[fsUnderline,fsBold];

      aBarBkColor:=ColAppear^[0].HBkColor;
      aBarTextColor:=ColAppear^[0].HTextColor;

      ReFreshList(ShowLines,BOff);

      MActiveList:=BOn;

    end {With}


  Except

    MULCtrlO2.Free;
    MULCtrlO2:=Nil;
  end;


end;


procedure TJCAPP.ReFreshFooter(CalcMode  :  Byte);
Begin
  With ExLocal,LInv do
  Begin
    SetBtnDisable(BOff);
    If (ForceStore) or (LastEdit) or (LViewOnly) then
    Begin

      CalcJAPVATTotals(LInv,ExLocal,Not LInv.ManVAT,CalcMode);

      {$IFDEF JC}
        If (CISOn) and ((Not LViewOnly) or (Debug))  then
          Calc_CISTaxInv(LInv,BOn);

      {$ENDIF}

        If (CalcMode=3) then {* refresh CIS values without recalc *}
        CalcJAPVATTotals(LInv,ExLocal,Not LInv.ManVAT,0);


    end;

    VATMatrix.HideVATMatrix(LInvNetTrig);
    LTMatrix.HideLTMatrix(LJAPLineTotal);

  end; {With..}

  OutNTxfrTotals;

  SetBtnDisable(BOn);
end;


Procedure TJCAPP.OutNTxfrTotals;

Var
  Dnum    :  Double;
  NTDrCr  :  DrCrType;
  n       :  VATType;
  i       :  Integer;


Begin
  With ExLocal,LInv do
  Begin
    If (VATMatrix<>nil) then
    With VATMatrix do
    Begin
      For n:=VStart to VEnd do
      Begin
        IdRec(Ord(n))^.GoodsD.Value:=LInvNetAnal[n];
        IdRec(Ord(n))^.VATD.Value:=InvVATAnal[n];
      end;
    end;

    If (LTMatrix<>nil) then
    With LTMatrix do
    Begin
      For i:=Low(tJALLTTypes) to High(tJALLTTypes) do
      Begin
        IdRec(i)^.GoodsD.Value:=LJAPLineTotal[i];
      end;
    end;

    // If this transaction is not an application (neither JPA nor JSA)
    If (Not (DocHed In JAPJAPSplit)) then
    Begin
      CostLab.Caption:=FormatFloat(GenRealMask,TotalCost);

      IssuedLab.Caption:=FormatFloat(GenRealMask,DiscAmount);

      I5Net1F.Value:=TotalCost;

      I5Disc1F.Value:=DiscAmount;
      I5Ret1F.Value:=DiscSetAm;
      I5Tot1F.Value:=(TotalCost-TotalOrdered);

      I5VAT1f.Value:=Calc_JAPDocTotal(LInv,BOff,0);

      I5Net2F.Value:=TotalReserved;
      I5Cert2F.Value:=TotalOrdered;
      I5Disc2F.Value:=PostDiscAm;
      I5Ret2F.Value:=TotOrdOS;

      I5Tot2F.Value:=Calc_JAPDocTotal(LInv,(TotalOrdered<>0.0),1);
    end
    else
    // If this transaction is a Job Application (JSA or JPA
    Begin
      // Display the amount applied on this transaction
      CostLab.Caption:=FormatFloat(GenRealMask,TotalCost);

      // Display the amount certified on this transaction
      IssuedLab.Caption:=FormatFloat(GenRealMask,InvNetVal);

      I5Net1F.Value:=TotalCost;   // Budget on this transaction
      I5Cert1f.Value:=InvNetVal;  // Certified amount on this transaction
      I5VAT1f.Value:=InvVAT;      // VAT on this transaction
      I5Disc1F.Value:=DiscAmount; // Deduction amount on this transaction
      I5Ret1F.Value:=DiscSetAm;   // Retention amount on this transaction
      I5CISTotF.Value:=CISTax;    // CIS tax on this transaction
      I5ContraF.Value:=BDiscount; // Contra amount on this transaction

      // Calculate the total for this transaction only, using Certified values
      // if PDiscTaken is True
      I5Tot1F.Value:=Calc_JAPDocTotal(LInv,PDiscTaken,0);

      // For Incremental and Gross Incremental application types, display
      // previous values. For Gross applications, display cumulative totals.
      If (JAbMode(LInv)<=1) then
      Begin
        I5Net2F.Value:=TotalReserved; // Total Applied YTD
        I5Cert2F.Value:=TotalOrdered; // Total Certified YTD
        I5Disc2F.Value:=PostDiscAm;   // Total Deduction YTD
        I5Ret2F.Value:=TotOrdOS;      // Total Retention YTD

        // Calculate the YTD total, using Certified values
        I5Tot2F.Value:=Calc_JAPDocTotal(LInv,BOn,1);

        Label21.Caption:='Previous Totals';
      end
      else
      Begin
        I5Net2F.Value:=TotalReserved+TotalCost; // Total Applied YTD + Total Budget/Applied on this transaction
        I5Cert2F.Value:=TotalOrdered+InvNetVal; // Total Certified YTD + Certified on this transaction
        I5Disc2F.Value:=PostDiscAm+DiscAmount;  // Total Deduction YTD + Deduction on this transaction
        I5Ret2F.Value:=TotOrdOS+DiscSetAm;      // Total Retention YTD + Retention on this transaction

        // Calculate YTD total, using Certified values, adding on the total from
        // this transaction and subtracting VAT, to give the YTD total value
        I5Tot2F.Value:=Calc_JAPDocTotal(LInv,BOn,1)+I5Tot1F.Value-InvVAT;

        Label21.Caption:='Cumulative Totals';
      end;

      {$IFDEF MC_On}
        TotLab.Caption:=SSymb(Currency);
      {$ELSE}
        If (PDiscTaken) then
        Begin
          TotLab.Caption:='Cert Total';
        end
        else
        Begin
          TotLab.Caption:='App Total';
        end;
      {$ENDIF}

      YTDTotLab.Caption:=TotLab.Caption;
    end;

    {IssLab.Caption:=FormatFloat(GenPcntMask,(DivWChk(TotalInvoiced,TotalCost)*100));

    FinLab.Caption:=FormatFloat(GenPcntMask,(DivWChk(TotalReserved,TotalInvoiced)*100));}

    If (Not (DocHed In [JPA,JSA])) then
    Begin
      Gauge1.Progress:=Round(DivWChk(Round_Up(TotalReserved,2),Round_Up(TotalCost,2))*100);
      Gauge2.Progress:=Round(DivWChk(Round_Up(TotalOrdered,2),Round_Up(TotalCost,2))*100);
    end;

    {$IFDEF JC}
      If (CISOn) and (DocHed In JAPJAPSplit) then
      Begin
        If (CISEmpl<>'') or (SyssCIS^.CISRates.JCISType In [1,4])  then
        Begin
          I5CISTaxF.Value:=CISTax;

          I5CISGrossF.Value:=CISGross;
          I5CISManCb.Checked:=CISManualTax;

          SBLT1.Height:=188;


          CISPanel1.Visible:=BOn;
          Label2.Visible:=BOn;
          I5CISTotF.Visible:=BOn;

          If (Round_Up(CISGross+CISTax,2)=0.0) then {Its a non taxable calc}
          Begin

            I5CISGrossF.Value:=Calc_JAPDocTotal(LInv,BOff,0);

            Label1.Caption:=CCCISName^+' Gross';

            If (CurrentCountry<>IECCode) then
              I5CISGrossF.Value:=I5CISGrossF.Value-InvVAT;

            I5CISManCb.Visible:=BOff;
            I5CISTaxF.Visible:=BOff;
            Label14.Visible:=BOff;
          end
          else
          Begin
            I5CISManCb.Visible:=BOn;
            I5CISTaxF.Visible:=BOn;
            Label14.Visible:=BOn;
          end;
        end
        else
        Begin
          SBLT1.Height:=312;
          CISPanel1.Visible:=BOff;
        end;
      end;

      {$IFDEF MC_On}
        I5Tot3F.ShowCurrency:=BOn;
        I5Tot3F.CurrencySymb:=SSymb(Currency);
        
      {$ENDIF}

      I5Tot3F.Value:=I5Tot1F.Value;

    {$ENDIF}

    CertifiedLbl.Visible := (not LViewOnly) and cbCert.Checked;
  end; {With..}

end;




{ ======== Display Receipt Record ========== }

procedure TJCAPP.SetNTxfrFields;

Var
  FoundLong    :  LongInt;
  FoundCode    :  Str20;

  GenStr       :  Str255;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    A1ORefF.Text:=Pr_OurRef(LInv);
    A1OpoF.Text:=OpName;

    { CJS - 2013-10-25 - MRD2.6.10 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      A1OpoF.Hint := GetOriginatorHint(LInv)
    else
      A1OpoF.Hint := '';

    A1TPerF.InitPeriod(AcPr,AcYr,BOn,BOn);

    A1TDateF.DateValue:=TransDate;
    I1DueDateF.DateValue:=DueDate;


    If (DocHed In [JSA,JST]) then
    Begin
      I1AccF.Text:=CustCode;
      Global_GetMainRec(CustF,CustCode);
      AssignFromGlobal(CustF);
    end
    else
    Begin
      I1AccF.Text:=CISEmpl;

      FoundCode:=CISEmpl;

      LinkEmpToSupplier(FoundCode,BOn);
    end;

    I4JobCodeF.Text:=DJobCode;
    I4JobAnalF.Text:=DeliverRef;

    If (DocHed In JAPJAPSplit) and (NoLabels<>0) then
      I4JobAnalF.Text:=I4JobAnalF.Text+' / '+Form_BInt(NoLabels,0);

    A1YRefF.Text:=YourRef;

    {I1YrRef2F.Text:=TransDesc;}

    THUd1F.Text:=DocUser1;
    THUd2F.Text:=DocUser2;
    THUd3F.Text:=DocUser3;
    THUd4F.Text:=DocUser4;

    //PR: 11/10/2011 New UDFs for v6.9
    THUD5F.Text  := DocUser5;
    THUD6F.Text  := DocUser6;
    THUD7F.Text  := DocUser7;
    THUD8F.Text  := DocUser8;
    THUD9F.Text  := DocUser9;
    THUD10F.Text := DocUser10;
    // PKR. 24/03/2016. ABSEXCH-17383. Add UDFs 11 and 12 for eRCT support
    THUD11F.Text := thUserField11;
    THUD12F.Text := thUserField12;


    J1BASISF.ItemIndex:=TransMode;
    DefVATCB.Checked:=AutoPost;
    ATRCB.Checked:=OnPickRun;

    If (Not (DocHed In [JPA,JSA])) then
      StatusF.Text:=StatusItems.Strings[TransNat]
    else
      StatusF.Text:=JAGiStatus(LInv);

    {$IFDEF MC_On}
      If (Currency>0) then
        I1CurrF.ItemIndex:=Pred(Currency);

      I1ExRateF.Value:=CXRate[BOn];

      FixXRF.Checked:=SOPKeepRate;
    {$ENDIF}

    A1IssF.Value:=TotalInvoiced;

    cbCert.Checked:=PDiscTaken;

    I5MVATF.Checked:=ManVAT;

    {$IFDEF JC}
      If (CISOn) then
        I5CISMancb.Checked:=CISManualTax;
    {$ENDIF}


     PINAF.Text:=Form_BInt(BatchNom,0);
     PICQF.Text:=DAddr[1];
     PIPIF.Text:=DAddr[2];
     PIJAF.Text:=DAddr[3];
     PICCF.Text:=FRCCDep[BOn];
     PIDepF.Text:=FRCCDep[BOff];
     PIAMTF.Value:=CurrSettled;

     If (BatchNom<>0) then
     Begin
       FoundCode:=PINAF.Text;

      If GetNom(Self,FoundCode,FoundLong,-1) then
        PINDF.Text:=Nom.Desc;
     end;
     cbPayAppsF.Checked:=PORPickSOR;

     cbPayAppsFClick(Nil);

    CertifiedLbl.Visible := (not LViewOnly) and cbCert.Checked;
  end; {With..}
end;



{ ======== Display Invoice Record ========== }

procedure TJCAPP.OutNTxfr;

Var
  GenStr       :  Str255;
  FoundCode    :  Str20;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    OutNTxfrTotals;

    SetNTxfrFields;
  end; {With..}
end;


procedure TJCAPP.Form2NTxfr;

Var
  n  :  VATType;
Begin
  With ExLocal,LInv do
  Begin
    TransDate:=A1TDateF.DateValue;
    DueDate:=I1DueDateF.DateValue;

    A1TPerF.InitPeriod(AcPr,AcYr,BOff,BOff);

    YourRef:=A1YRefF.Text;



    If (DocHed In [JSA,JST]) then
    Begin
      CustCode:=I1AccF.Text;


      PORPickSOR:=cbPayAppsF.Checked;

      BatchNom:=IntStr(PINAF.Text);
      DAddr[1]:=PICQF.Text;
      DAddr[2]:=PIPIF.Text;
      DAddr[3]:=PIJAF.Text;
      FRCCDep[BOn]:=PICCF.Text;
      FRCCDep[BOff]:=PIDepF.Text;
      CurrSettled:=PIAMTF.Value;

    end
    else
    Begin
      CISEmpl:=I1AccF.Text;

      CustCode:=FullCustCode(LCust.CustCode);

    end;


    DJobCode:=I4JobCodeF.Text;
    DeliverRef:=I4JobAnalF.Text;

    DocUser1:=THUd1F.Text;
    DocUser2:=THUd2F.Text;
    DocUser3:=THUd3F.Text;
    DocUser4:=THUd4F.Text;

    //PR: 11/10/2011 New Udfs for v6.9
    DocUser5  := THUD5F.Text;
    DocUser6  := THUD6F.Text;
    DocUser7  := THUD7F.Text;
    DocUser8  := THUD8F.Text;
    DocUser9  := THUD9F.Text;
    DocUser10 := THUD10F.Text;
    // PKR. 24/03/2016. ABSEXCH-17383. Add UDFs 11 and 12 for eRCT support
    thUserField11 := THUD11F.Text;
    thUserField12 := THUD12F.Text;


    TransMode:=J1BASISF.ItemIndex;
    AutoPost:=DefVATCB.Checked;
    OnPickRun:=ATRCB.Checked;

    {$IFDEF MC_On}
      If (I1CurrF.ItemIndex>=0) then
        Currency:=Succ(I1CurrF.ItemIndex);

      CXRate[BOn]:=I1ExRateF.Value;

      SOPKeepRate:=FixXRF.Checked;
    {$ENDIF}

    TotalInvoiced:=A1IssF.Value;

    PDiscTaken:=cbCert.Checked;

    ManVAT:=I5MVATF.Checked;


    {$IFDEF JC}
      If (CISOn) then
      Begin
        CISManualTax:=I5CISMancb.Checked;

        If (CISManualTax) then
        Begin
          CISTax:=I5CISTaxF.Value;
          CISGross:=I5CISGrossF.Value;
        end;
      end;
    {$ENDIF}


    If (ManVAT) then
    Begin
      For n:=VStart to VEnd do
      Begin

        InvVATAnal[n]:=VATMatrix.IDRec(Ord(n))^.VATD.Value;

      end;
    end;

  end; {With..}
end;


Procedure TJCAPP.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      MainPage
         :  If (I4JobCodeF.Text='') then
            Begin
              With I4JobCodeF do
                If CanFocus then
                  SetFocus;
            end
            else
              If (I1AccF.Text='') and (I1AccF.Visible) then
              Begin
                With I1AccF do
                  If CanFocus then
                    SetFocus;
              end
              else
                If (J1BasisF.Enabled) and (J1BasisF.Visible) and ((Not J1BasisF.ReadOnly) or (LViewOnly)) then
                Begin
                  With J1BasisF do
                    If CanFocus then
                      SetFocus;
                end
                else
                  With DefVATCB do
                    If CanFocus then
                      SetFocus
                  else
//                    With A1YRefF do
                    With A1TPerF do
                      If CanFocus then
                        SetFocus;



    end; {Case&With..}

end; {Proc..}




Procedure TJCAPP.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TJCAPP.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
  end;
end;

procedure TJCAPP.HideListColumns(PageNo  :  Integer);


Begin
   With A1SBox do
      HorzScrollBar.Position:=0;

    With A2SBox do
      HorzScrollBar.Position:=0;

  If (Assigned(MULCtrlO)) then
  With MULCtrlO,VisiList do
  Begin
    HidePanels(PageNo);

    ReAssignCols;

    PageUpDn(0,BOn);

    SetHedPanel(ListOfSet);


  end;

  If (Assigned(MULCtrlO2)) then
  With MULCtrlO2,VisiList do
  Begin
    HidePanels2(PageNo);

    ReAssignCols;

    RefreshList2(BOn,BOff);

    SetHedPanel(ListOfSet);


  end;
end;

procedure TJCAPP.PageControl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;

  {$IFDEF NP}
    NoteSetUp :  TNotePadSetUp;
  {$ENDIF}

begin
  NewIndex := 0;
  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      PrimeButtons;

      If (NewIndex In [FootPage]) and (A1FPanel.Visible) then
      begin
        //GS 26/03/2012 ABSEXCH-12702: toggle visibility of the dropdown form
        A1FPanel.Visible:=BOff;
        TransEXTForm1.visible := False;
      end
      else
        If (Not A1FPanel.Visible) and (Not (NewIndex In [FootPage])) then
        begin
          A1FPanel.Visible:=BOn;
          TransEXTForm1.visible := True;
        end;

      MULCtrlO.DisplayMode:=NewIndex;

      HideListColumns(NewIndex);

      If (Not TransExtForm1.NewSetting) and (NewIndex>AnalPage) then {* Panel is open, so close it *}
        TransExtForm1.ForceClose;

      Case NewIndex of
        MainPage,
        AnalPage
           :  Begin
                A1SBox.Parent:=ActivePage;
                A2SBox.Parent:=ActivePage;
                A1ListBtnPanel.Parent:=ActivePage;
                A2ListBtnPanel.Parent:=ActivePage;
                A1BtmPanel.Parent:=ActivePage;


              end;
        FootPage
           :  Begin
                If (ReCalcTot) then
                Begin
                  ReCalcTot:=BOff;

                  ReFreshFooter( 3 );
                end;

              end;

      {$IFDEF NP}


        NotePage
           :  If (NotesCtrl=nil) then
              With ExLocal do
              Begin
                NotesCtrl:=TNoteCtrl.Create(Self);

                //TW 26/10/2011: Add Event handler for new note functionality.
                NotesCtrl.OnSwitch := SwitchNoteButtons;
                NotesCtrl.Caption:=Caption+' - Notes';
                NotesCtrl.fParentLocked:=fRecordLocked;

                FillChar(NoteSetup,Sizeof(NoteSetUp),0);
                With NoteSetUp do
                Begin
                  ColPanels[0]:=NDatePanel; ColPanels[1]:=NDateLab;
                  ColPanels[2]:=NDescPanel; ColPanels[3]:=NDescLab;
                  ColPanels[4]:=NUserPanel; ColPanels[5]:=NUserLab;

                  ColPanels[6]:=TNHedPanel;
                  ColPanels[7]:=TcNListBtnPanel;

                  ScrollBox:=TCNScrollBox;
                  PropPopUp:=StoreCoordFlg;

                  CoorPrime:=DocCodes[DocHed][1];
                  CoorHasCoor:=LastCoord;

                end;

                try
                  NotesCtrl.CreateList(Self,NoteSetUp,NoteDCode,NoteCDCode,FullNomKey(LInv.FolioNum));
                  NotesCtrl.GetLineNo:=LInv.NLineCount;


                except
                  NotesCtrl.Free;
                  NotesCtrl:=Nil
                end;


              end
              else
              With ExLocal do
              begin
                If (FullNomKey(LInv.FolioNum)<>NotesCtrl.GetFolio) then {* Refresh notes *}
                with NotesCtrl do
                Begin
                  RefreshList(FullNomkey(LInv.FolioNum),GetNType);
                  GetLineNo:=LInv.NLineCount;
                end;
                SwitchNoteButtons(Self, NotesCtrl.NoteMode);
              end;
      {$ENDIF}



      end; {Case..}


      MDI_UpdateParentStat;

    end; {With..}

    { CJS 2012-11-13 - ABSEXCH-13662 - Delete button enabled when switching tabs }
    if (NewIndex < 2) then
    begin
      GrpRefreshLine(Ord(MActiveList));
      DelN1Btn.Enabled := (MULCtrlO.CalcApplied = 0.0);
    end;

end;




procedure TJCAPP.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);
  ActiveControl := nil;

  CISTaxRecalcRequired := True;

  fFrmClosing:=BOff;
  fDoingClose:=BOff;

  ExLocal.Create;

  ForceStore:=BOff;

  LastCoord:=BOff;
  ReCalcTot:=BOn;
  NeedCUpdate:=BOff;
  FColorsChanged := False;
  BalDone:=BOff;

  Visible:=BOff;

  InvStored:=BOff;
  CouldIssue:=BOff;

  JustCreated:=BOn;

  fRecordLocked:=BOff;

  StopPageChange:=BOff;
  FAnonymisationON := False;

  SKeypath:=0;

  MinHeight:=392;
  MinWidth:=634;

  InitSize.Y := 441; //392;
  InitSize.X := 634;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=382;
  Width:=640;}

  PageControl1.ActivePage:=AdjustPage;


  With TForm(Owner) do
  Begin
    Self.Left:=0;
    Self.Top:=0;
  end;

  RecordPage:=JAPFormPage;
  DocHed:=JAPFormMode;

  MatchOrdPtr:=nil;

  Caption:=DocNames[DocHed];

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  LTDescStr:=TStringList.Create;
  StatusItems:=TStringList.Create;

  Set_JAPDefaultDocT(LTDescStr,0);

  VATMatrix:=TVATMatrix.Create;

  LTMatrix:=TLTMatrix.Create;

  FormDesign;

  FormBuildList(BOff);

end;



procedure TJCAPP.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  If (InvBtnList<>nil) then
    InvBtnList.Free;

  {If (MULCtrlO<>nil) then
    MULCtrlO.Free;}

  If (Assigned(LTDescStr)) then
    FreeandNil(LTDescStr);

  If (Assigned(StatusItems)) then
    FreeandNil(StatusItems);

  VATMatrix.Free;
  LTMatrix.Free;

end;

procedure TJCAPP.FormCloseQuery(Sender: TObject;
                                 var CanClose: Boolean);
Var
  n  : Integer;

begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try
      CanClose:=ConfirmQuit;

      GenCanClose(Self,Sender,CanClose,BOn);

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

        If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
          Store_FormCoord(Not SetDefault);


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

        Send_UpdateList(BOff,108);

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;

end;

procedure TJCAPP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    If (MULCtrlO<>nil) then
    Begin
      try
        MULCtrlO.Destroy;
      finally
        MULCtrlO:=nil;
      end;
    end;

    If (MULCtrlO2<>nil) then
    Begin
      try
        MULCtrlO2.Destroy;
      finally
        MULCtrlO2:=nil;
      end;
    end;

  end;
end;


procedure TJCAPP.NotePageReSize;

Begin
  With TCNScrollBox do
  Begin
    TCNListBtnPanel.Left:=Width+5;

    TNHedPanel.Width:=HorzScrollBar.Range;
    NDatePanel.Height:=TCNListBtnPanel.Height;
  end;

  NDescPanel.Height:=NDatePanel.Height;
  NUserPanel.Height:=NDatePanel.Height;


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


procedure TJCAPP.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) and (Not fDoingClose) then
  Begin
    MULCtrlO.LinkOtherDisp:=BOff;

    If (Assigned(MULCtrlO2)) then
      MULCtrlO2.LinkOtherDisp:=BOff;

    NewVal:=ClientWidth-PagePoint[0].X;
    If (NewVal<MinWidth) then
      NewVal:=MinWidth;

    PageControl1.Width:=NewVal;

    NewVal:=ClientHeight-PagePoint[0].Y;

    If (NewVal<MinHeight) then
      NewVal:=MinHeight;

    PageControl1.Height:=NewVal;


    A1SBox.Width:=PageControl1.Width-PagePoint[1].X;
    {A1SBox.Height:=Round((PageControl1.Height-PagePoint[1].Y)/2);}

    A1SBox.Height:=Round((PageControl1.Height-PagePoint[6].X)/2)+PagePoint[1].Y;

    A2SBox.Top:=A1SBox.Top+A1SBox.Height+1;
    A2SBox.Width:=A1SBox.Width;
    A2SBox.Height:=A1SBox.Height;


    TCNScrollBox.Width:=PageControl1.Width-PagePoint[5].X;
    TCNScrollBox.Height:=PageControl1.Height-PagePoint[5].Y;

    A1BtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    A1BtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    A1BSBox.Height:=A1BtnPanel.Height-PagePoint[3].X;

    A1ListBtnPanel.Left:=PageControl1.Width-PagePoint[4].X;
    A1ListBtnPanel.Height:={PageControl1.Height-PagePoint[4].Y;} A1SBox.Height;

    A2ListBtnPanel.Top:=A2SBox.Top;
    A2ListBtnPanel.Left:=A1ListBtnPanel.Left;
    A2ListBtnPanel.Height:=A2SBox.Height;


    TCNListBtnPanel.Height:=PageControl1.Height-PagePoint[6].Y;

    NotePageResize;

    With A1SBox do
      A1HedPanel.Width:=HorzScrollBar.Range;

    With A2SBox do
      A2HedPanel.Width:=HorzScrollBar.Range;



    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=A1SBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      MULCtrlO.ReFresh_Buttons;

      LockWindowUpDate(0);
    end;{Loop..}

    MULCtrlO.LinkOtherDisp:=BOn;


    If (MULCtrlO2<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO2,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=A2SBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      MULCtrlO2.ReFresh_Buttons;

      LockWindowUpDate(0);

      MULCtrlO2.LinkOtherDisp:=BOn;

    end;{Loop..}

    CertifiedLbl.Left := ClientWidth - CertifiedLbl.Width - 8;
    //SSK 08/01/2018 2018R1 ABSEXCH-19613: set size/position of anonymisation panel on form resize
    SetAnonymisationPanel;


        NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end; {If time to update}
end;


procedure TJCAPP.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

  If (Key=$5A) and (Shift = ([ssAlt,ssCtrl,ssShift])) and (Not ExLocal.LViewOnly) then
  Begin
    Re_SetDoc(ExLocal.LInv);
    OutNtxfr;
    MULCtrlO.PageUpDn(0,BOn);
    MULCtrlO2.PageUpDn(0,BOn);
  end;

end;

procedure TJCAPP.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Function TJCAPP.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;




procedure TJCAPP.ClsN1BtnClick(Sender: TObject);
begin
  If ConfirmQuit then
    Close;
end;

function TJCAPP.A1TPerFConvDate(Sender: TObject; const IDate: string;
  const Date2Pr: Boolean): string;
begin
  Result:=ConvInpPr(IDate,Date2Pr,@ExLocal);
end;


Function TJCAPP.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and ((CheckNeedStore) or (ForceStore)) and (Not ExLocal.LViewOnly) and (Not InvStored) then
  Begin
    If (Current_Page>NotePage) then {* Force view of main page *}
      ChangePage(0);

    If (ForceStore) then
      mbRet:=MessageDlg('This '+DocNames[DocHed]+' must be stored',mtWarning,[mbOk],0)
    else
      mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes
           :  Begin
                StoreNtxfr(InvF,SKeypath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) then
                Begin
                  Delete_DocEditNow(LInv.FolioNum);

                  Status:=UnLockMLock(InvF,LastRecAddr[InvF]);
                end;

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


procedure TJCAPP.SetNTxfrStore(EnabFlag,
                                VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode or FAllowPostedEdit;

  OkN1Btn.Enabled:=Not VOMode or FAllowPostedEdit;
  CanN1Btn.Enabled:=Not VOMode or FAllowPostedEdit;


  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    with Text8Pt(Components[Loop]) do
    Begin
      If (Tag=1) then
        ReadOnly:= VOMode and not AllowPostedEdit;
    end
      else
        If (Components[Loop] is TEditDate) then
        Begin
          If (TEditDate(Components[Loop]).Tag=1) then
            TEditDate(Components[Loop]).ReadOnly:= VOMode;
        end
        else
          If (Components[Loop] is TEditPeriod) then
          Begin
            If (TEditPeriod(Components[Loop]).Tag=1) then
              TEditPeriod(Components[Loop]).ReadOnly:= VOMode;
          end
          else
            If (Components[Loop] is TCurrencyEdit) then
            Begin
              If (TCurrencyEdit(Components[Loop]).Tag=1) then
                TCurrencyEdit(Components[Loop]).ReadOnly:= VOMode;
            end
            else
              If (Components[Loop] is TBorCheck) then
              Begin
                If (TBorCheck(Components[Loop]).Tag=1) then
                  TBorCheck(Components[Loop]).Enabled:= Not VOMode;
              end
              else
                If (Components[Loop] is TSBSComboBox) then
                Begin
                  If (TSBSComboBox(Components[Loop]).Tag=1) then
                    TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
              end;
  end; {Loop..}

  if (not J1BasisF.ReadOnly and MulCtrlO.AppliedTotalFound) then
    J1BasisF.ReadOnly := True;

  If (I4JobAnalF.Text<>'') then
  Begin
    I4JobCodeF.Tag:=0;
    I4JobCodeF.Color:=clBtnFace;
    I4JobCodeF.ReadOnly:=BOn;

    If (I1AccF.Text<>'') and (DocHed<>JST) then
    Begin
      I1AccF.Tag:=0;
      I1AccF.Color:=clBtnFace;
      I1AccF.ReadOnly:=BOn;
    end;

  end;

  If (WORI1Btn.Visible) then
  With ExLocal,LInv do
    WORI1Btn.Enabled:=(DJobCode<>'') and ((Trim(CISEmpl+CustCode)<>'') or (DocHed=JPT));

end;


Procedure TJCAPP.NoteUpdate;


Const
  Fnum     =  InvF;
  Keypath  =  InvFolioK;


Var
  KeyChk,
  KeyS    :  Str255;

  HoldMode:  Byte;
  
  B_Func  :  Integer;

  TmpBo   :  Boolean;

  LiveInv :  InvRec;



Begin

  GLobLocked:=BOff;

  {$IFDEF NP}

    KeyS:=NotesCtrl.GetFolio;

    With ExLocal do
    Begin
      If (LastEdit) then
      Begin
        LiveInv:=LInv;
        Ok:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPAth,Fnum,BOn,GlobLocked);

        LInv:=LiveInv;
      end
      else
      Begin
        Ok:=BOn; GlobLocked:=BOn;
      end;



      If (Ok) and (GlobLocked) then
      With LInv  do
      Begin
        If (LastEdit) then
          LGetRecAddr(Fnum);


        NLineCount:=NotesCtrl.GetLineNo;

        //PR: 10/07/2012 ABSEXCH-12784 Change to check for non-audit notes.
        if HasNonAuditNotes(LInv) then
          HoldMode:=232  {* Set Hold *}
        else
          HoldMode:=233;

        SetHold(HoldMode,Fnum,Keypath,BOff,LInv);

        If (LastEdit) then
        Begin
          Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath);

          Report_BError(Fnum,Status);
          {* Explicitly remove multi lock *}

          UnLockMLock(Fnum,LastRecAddr[Fnum]);
        end;

      end;

    end; {With..}

  {$ENDIF}

end; {Func..}



Function TJCAPP.SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

Var
  VOMsg  : Byte;

Begin


{$B-}

  Result:=(SL and ((VO) or View_Status(ExLocal.LInv,BOff,VOMsg)));

{$B+}

  If (VO) then {* Force View only msg *}
    VOMsg:=9;

  If (Result) then
  begin
    A1StatLab.Caption := GetIntMsg(VOMsg+50);
    Shape1.Shape := stRoundRect;
    Shape1.Left := 5; //I1StatLab.Left - 1;
    Shape1.Top := 5; //I1StatLab.Top - 3;
    Shape1.Width := A1btnPanel.Width - 10; //I1StatLab.Width + 4;
    Shape1.Height := A1StatLab.Height + 4;
    Shape1.Visible := True;
    Shape1.Brush.Color := RGB(0, 159, 223);
    A1StatLab.Color := Shape1.Brush.Color;
  end
  else
    A1StatLab.Caption:='';

  OkN1Btn.Visible:=Not Result or FAllowPostedEdit;
  CanN1Btn.Visible:=OkN1Btn.Visible;

end;





(*  Add is used to add Customers *)

procedure TJCAPP.ProcessNtxfr(Fnum,
                               KeyPAth    :  Integer;
                               Edit,
                               AutoOn     :  Boolean);

Var
  KeyS       :  Str255;


Begin

  Addch:=ResetKey;

  KeyS:='';

  Elded:=Edit;

  SKeyPath:=Keypath;

  If (Edit) then
  Begin

    With ExLocal do
    Begin
      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);

      If (Not LViewOnly) then
      Begin
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked);

        If (Ok) and (LInv.RunNo>0) then {* its posted.. }
          Ok:=BOff;
      end
      else
        Ok:=BOn;


    end;


    If (Not Ok) or (Not GlobLocked) then
    Begin
      AddCh:=#27;
      ExLocal.LViewOnly:=BOn;
      fRecordLocked:=BOn;
    end;
  end;



  If (Addch<>#27) then
  With ExLocal,LInv do
  begin

    LastInv:=LInv;

    If (Not Edit) then
    Begin
      Caption:=DocNames[DocHed]+' Record';

      LResetRec(Fnum);


      NomAuto:=Not AutoOn;

      InvDocHed:=DocHed;

      RunNo:=Set_JAPRunNo(InvDocHed,AutoOn,BOff);

      TransDate:=Today; AcPr:=GetLocalPr(0).CPr; AcYr:=GetLocalPr(0).CYr;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
        Date2Pr(TransDate,AcPr,AcYr,@ExLocal);

      DueDate:=CalcDueDate(TransDate,30);

      NLineCount:=1;

      ILineCount:=1;

      If (DocHed In JAPJAPSplit) then
        CustSupp:='J' {Filter from normal ledger}
      else
        CustSupp:='K';

      OpName:=EntryRec^.Login;

      If (DocHed In [JPA,JSA]) then
      Begin

      end
      else
      Begin
        TransNat:=0; {Assume all templetes are interims}

      end;


      {$IFDEF MC_On}

        Currency:=1;

        CXrate:=SyssCurr.Currencies[Currency].CRates;

        CXRate[BOff]:=0;
      {$ELSE}

        Currency:=0;

        CXrate:=SyssCurr.Currencies[Currency].CRates;


      {$ENDIF}

      SetTriRec(Currency,UseORate,CurrTriR);


      If (Not AutoOn) then
        SetNextDocNos(LInv,BOff)
      else
      Begin
        SetNextAutoDocNos(LInv,BOff);

        AutoIncBy:=DayInc;

        AutoInc:=30;

        UntilDate:=MaxUntilDate;

        UnYr:=MaxUnYr;

        UnPr:=Syss.PrInYr;
      end;


      OutNtxfr;

      If (Not Edit) then
        ReFreshList(BOn,Not JustCreated);

    end
    else
    Begin
      {* Add to list as currently being edited *}

      If (Not LViewOnly) then
        Add_DocEditNow(LInv.FolioNum);


      //PR: 20/06/2012 ABSEXCH-11528 Store previous OS value
      PreviousOS := JAPTransOSValue(LInv);
    end;


    SetNtxfrStore(BOn, (LViewOnly or cbCert.Checked));
    if not LViewOnly then
      cbCert.Enabled := True;


    SetFieldFocus;

  end {If Abort..}
  else
  Begin
    SetViewOnly(BOn,ExLocal.LViewOnly);
    PrimeButtons;
  end;


end; {Proc..}



 { ====================== Function to Check ALL valid invlines (InvLTotal<>0) have a nominal =============== }

Function TJCAPP.Check_LinesOk(InvR  :  InvRec)  :  Boolean;

Const
  Fnum     =  IDetailF;
  Keypath  =  IDFolioK;



Var

  KeyS,
  KeyChk    :  Str255;
  NomOk     :  Boolean;

  ExStatus,
  TmpKPath,
  TmpStat   :  Integer;

  TmpRecAddr
            :  LongInt;


 {$IFDEF PF_On}
  Loop     :  Boolean;
 {$ENDIF}




Begin
  NomOk:=BOn;

  ExStatus:=0;  Loop:=BOn;

  KeyChk:=FullNomKey(InvR.FolioNum);

  KeyS:=FullIdKey(InvR.FolioNum,JALRetLineNo);

  TmpKPath:=KeyPath;

  ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


  While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NomOk) do
  With Id do
  Begin
    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    ExLocal.AssignFromGlobal(IdetailF);


    NomOk:=JAPLne2U.LineCheckCompleted(Id,InvR,Self.ExLocal.LastEdit,BOn,Loop,Self);

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Result:=NomOk;
end; {Func..}

{ == Routines to execute list specific tasks, depending on which list has focus == }

Function TJCAPP.GrpValidLine(MLNo  :  Byte)  : Boolean;

Begin
  Case MLNo of
    1  :  Result:=MULCtrlO2.ValidLine;
    else  Result:=MULCtrlO.ValidLine;
  end; {Case..}
end; {Func..}


Procedure TJCAPP.GrpRefreshLine(MLNo  :  Byte);
Begin
  Case MLNo of
    1  :  With MULCtrlO2 do
            RefreshLine(MUListBoxes[0].Row,BOff);
    else  With MULCtrlO do
            RefreshLine(MUListBoxes[0].Row,BOff);
  end; {Case..}
end; {Func..}


Function TJCAPP.CheckCompleted(Edit  :  Boolean)  : Boolean;

Const
  NofMsgs      =  19;

Type
  PossMsgType  = Array[1..NofMsgs] of Str255;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  Test     :  Byte;

  SCode    :  Str10;

  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

  BalNow   :  Double;

  FoundLong:  LongInt;

Begin
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='The current transaction line has not been stored yet.';
  PossMsg^[2]:='Financial Period is not valid.';
  PossMsg^[3]:='Check child windows';
  PossMsg^[4]:='Problem with transaction lines.';
  PossMsg^[5]:='That Job code is not valid.';
  PossMsg^[6]:='Transaction Date is not valid.';
  PossMsg^[7]:='The gross applied amount does not match the applied line total';
  PossMsg^[8]:='Currency is not valid.';
  PossMsg^[9]:='For local currency the exchange rate must be 1.0';
  PossMsg^[10]:='That Account is not valid';
  PossMsg^[11]:='The Sub contractor expiry has gone off.';
  PossMsg^[12]:='A Final Application can only be used for the return of practical retention.'+#13+
                'It must have zero Labour and material costs.'+#13+
                'Please use additional Practical Applications to process any remaining costs.';
  PossMsg^[13]:='General Ledger Code is not valid.';
  PossMsg^[14]:='The Receipt Cost Centre/ Department Code is not valid.';
  PossMsg^[15]:='The Receipt G/L and currency combination are not allowed.';
  PossMsg^[16]:='A valid Job code must be present for that Receipt G/L Code.';
  PossMsg^[17]:='This Application has been marked to generate a Receipt, it cannot have a zero Receipt value.';
  PossMsg^[18]:='The Receipt Job Analysis Code is not Valid.';
  PossMsg^[19]:='An additional check is made via an external hook';



  Test:=1;

  Result:=BOn;

  BalNow:=0;
  ShowMsg := False;

  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LInv do
  Begin
    LResetRec(IDetailF);

    With LId do {Manufacture artificial LId so payment validity lines work}
    Begin
      CCDep:=FRCCdep;
      NomCode:=BatchNom;
      NetValue:=CurrSettled;
      JobCode:=DJobCode;
      AnalCode:=DAddr[3];
      LId.Currency:=LInv.Currency;
    end;


    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=Not IdLineActive;

              If Assigned(IdLine) and (IdLineActive) then
                IdLine.Show;
            end;


      2  :  Result:=ValidPeriod(StrPeriod(ConvTxYrVal(AcYr,BOff),AcPr),Syss.PrInYr);

      3  :  Begin {* Check if all child windows are gojng to close *}
              ShowMsg:=BOff;

              GenCanClose(Self,Self,Result,BOff);

            end;

      4  :  Result:=Check_LinesOk(LInv);

      5  :  Begin

                Result:=GetJob(Self,DJobCode,FoundCode,-1);

              end;

      6  :  Result:=ValidDate(TransDate);

      7  :  Begin

              Result:=(InvDocHed <> JPA);

              If (Not Result) then
                Case TransNat of
                  2   :  Result:=(Round_Up(TotalInvoiced-(TotalReserved+TotalCost),2)=0.0) or (TotalInvoiced=0.0);
                  else   Result:=(Round_Up(TotalInvoiced-TotalCost,2)=0.0) or (TotalInvoiced=0.0);
                end; {Case..}

            end;

    {$IFDEF MC_On}

      8  :  Result:=(Currency In [Succ(CurStart)..CurrencyType]);

      9  :  Begin
              Result:=((Currency=1) and (CXRate[BOn]=1.0)) or (Currency>1);

            end;

    {$ENDIF}

     10  :  Begin
              {$B-}
                Result:=(Not (DocHed In JAPSalesSplit)) or (((GetCust(Self,CustCode,FoundCode,IsACust(CustSupp),-1))
                        and (Not EmptyKey(CustCode,CustKeyLen))
                        and ((Cust.AccStatus<=AccClose) or ((ExLocal.LastEdit) and (Cust.CustCode=LastInv.CustCode)))));
              {$B+}
            end;

     11  :  Begin
              ShowMsg:=BOff;

              {$IFDEF JC}
                {$IFDEF PF_On}
                   If (JBCostOn) and (DocHed=JPA) then
                     Result:=Not Cert_Expired(CustCode,Today,BOn,BOn);
                {$ENDIF}
              {$ENDIF}

            end;

      12  :  Begin
               {$B-}
                Result:=(Not (DocHed In JAPJapSplit)) or  (TransMode<>3) or (Round_Up(TotalCost+InvNetVal,2)=0.0);
               {$B+}


            end;

     13  :  Begin
              Result:=(CurrSettled=0) or (Not PORPickSOR);

              If (Not Result) then
              Begin
                Result:=GetNom(Self,Form_Int(BatchNom,0),FoundLong,-1);

                If (Result) and (Not SBSIn) then
                  Result:=(Nom.NomType In BankSet+ProfitBFSet);
              end;

            end;

     14   :  Begin
                {$B-}
                Result:=((Not Syss.UseCCDep) or (Not PORPickSOR) or (Not PDiscTaken) or (Not LComplete_CCDep(LId,CurrSettled)));
                {$B+}
                If (Not Result) then
                Begin
                  Result:=BOn;
                  For Loop:=BOff to BOn do
                  Begin

                    Result:=(GetCCDep(Self,FRCCDep[Loop],FoundCode,Loop,-1) and (Result));

                  end;
                end;

              end;

      15  :  Begin
               {$B-}
               Result:=(Not PORPickSOR) or (Not PDiscTaken) or Check_GLCurr(LInv,LId,0);
               {$B+}
             end;

      16  :  {$B-}
               Result:=(Not PORPickSOR) or (Not PDiscTaken) or Check_GLJC(LInv,LId,0);
             {$B+}

      17 :  Begin
              {$B-}
                Result:=(InvDocHed<>JSA) or (Not PORPickSOR) or (Not PDiscTaken) or (CurrSettled<>0.0) or (Not PDiscTaken);
              {$B+}
            end;

      18   :  Begin

                {$B-}
                  Result:=(Not PORPickSOR) or (Not PDiscTaken) or (Not LComplete_JobAnl(LId,CurrSettled));
                {$B+}

                If (Not Result) and (Trim(DAddr[3])<>'') then
                  Result:=GetJobMisc(Self,DAddr[3],FoundCode,2,-1);

              end;




      19 :   Begin {* Opportunity for hook to validate the header as well *}
                 {$IFDEF CU}

                   Result:=ValidExitHook(2000,82,ExLocal);
                   ShowMsg:=BOff;

                 {$ENDIF}
              end;
      else //PR: 23/03/2016 v2016 R1 ABSEXCH-17390
        Result := True;

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}




procedure TJCAPP.StoreNtxfr(Fnum,
                             KeyPAth    :  Integer);


Var
  COk  :  Boolean;
  TmpInv
       :  InvRec;
  KeyS :  Str255;

  MbRet:  Word;

  Mode :  Byte;

  COwnSet,
  ResOrFull  :  Real;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState: Boolean;
  CursorState: TCursor;

Begin
  KeyS:='';

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState := OkN1Btn.Enabled;
  CursorState := Cursor;

  OkN1Btn.Enabled := False;
  try

    Form2Ntxfr;

    COwnSet:=0;

    ResOrFull:=0;


    With ExLocal,LInv do
    Begin
      {$IFDEF CU} {* Call any pre store hooks here *}

        LNeedRefs:=(Not ForceStore) and (Not LastEdit); {If we enter hook with no folio assigned, let hook assign them}

        GenHooks(2000,1,ExLocal);

        If (LNeedRefs) then
          ForceStore:=LSetRefs;

      {$ENDIF}

      CalcJAPVATTotals(LInv,ExLocal,Not LInv.ManVAT,0);

      {$IFDEF JC}
        If (CISOn) then
          Calc_CISTaxInv(LInv,BOn);
      {$ENDIF}


      COk:=CheckCompleted(LastEdit);


      If (COk) then
      Begin

        Cursor:=crHourGlass;


        OpName:=EntryRec^.LogIn;

        CheckYRef(LInv);  {* To reset index on blank *}

        If (DocHed In [JPA,JCT]) then
        Begin
          COk:=(RunNo=JPAUPRunNo);

          BatchLink:=FullJAPEmplKey(COk,CISEmpl,(Not (DocHed In [JPA,JSA])));
        end;

        If (Not (DocHed In [JPT,JST])) then {* Deliberately don't set one here, as this line gets called on master JST only which we do not want to list*}
          TransDesc:=FullJAPJobKey(COk,DJobCode,(Not (DocHed In [JPA,JSA])),(DocHed In JAPSalesSplit));

        If (LastEdit) then
        Begin
          If (Not LViewOnly) then
          Begin
            TmpInv:=LInv;

            If LGetMainRecPosKey(Fnum,InvOurRefK,LInv.OurRef) then
            Begin
              TmpInv.NoLabels:=LInv.NoLabels; {* In case any Apps are created via the applications button, refresh counter *}
            end;

            LInv:=TmpInv;

            Status:=LSecure_InvPut(Fnum,KeyPAth,0);

            //PR: 22/11/2011 Add audit note
            if Status = 0 then
              TAuditNote.WriteAuditNote(anTransaction, anEdit, ExLocal);


          end; {Don't store if view only}
        end
        else
        Begin {* Add new record *}

          If (Not LastEdit) and ((HoldFlg AND HoldQ)=HoldQ) then
            HoldFlg:=(HoldFlg-HoldQ); {v5.60 Clear saftey hold as header about to be stored correctly}


          If (Not ForceStore) then
          Begin
            If (NomAuto) then
              SetNextDocNos(LInv,BOn)
            else
              SetNextAutoDocNos(LInv,BOn);
          end;

          If (Not InvStored) and (Not LForcedAdd) then
          begin
            { CJS - 2013-10-25 - MRD2.6.10 - Transaction Originator }
            TransactionOriginator.SetOriginator(LInv);

            Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
          end
          else
            Status:=LSecure_InvPut(Fnum,KeyPAth,0);

          //PR: 22/11/2011 Add audit note
          if Status = 0 then
            TAuditNote.WriteAuditNote(anTransaction, anCreate, ExLocal);
        end;

        If (Not LViewOnly) then
          Report_BError(Fnum,Status);

        If (StatusOk) and (Not LViewOnly) then
        Begin
          AssignToGlobal(InvF);

          If (Not LastEdit) then {* Get record, as if daybook empty, getpos was failing *}
            LGetMainRecPosKey(Fnum,InvOurRefK,LInv.OurRef);

          LGetRecAddr(Fnum);  {* Refresh record address *}

          If (StatusOk) then
          Begin

            Send_UpdateList(LastEdit,RecordPage);

          end;

          Check_DocChanges(LastInv,LInv);  {* Update all lines with any changes *} {* EN560 Modify to allow for JAP's *}

          If (NomAuto) and (InvDocHed In JAPOrdSplit)  and ((InvDocHed<>JST) or EmptyKey(LInv.DeliverRef,DocKeyLen)) then {* Update customer comitted value *}
            UpdateCustAppBal(LastInv,LInv, PreviousOS);

        end;

        If (LastEdit) or (LForcedAdd) then
        Begin
          Delete_DocEditNow(LInv.FolioNum);

          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

        end;

        SetNtxfrStore(BOff, cbCert.Checked);
        cbCert.Enabled := True;

        { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
        Cursor := CursorState;

        InvStored:=BOn;

        LastValueObj.UpdateAllLastValues(Self);

        {$IFDEF CU} {* Call any post store hooks here *}

            GenHooks(2000,170,ExLocal);


        {$ENDIF}


        Close;

        Exit;

      end {* If ok2 store (}
      else
      Begin

        {ChangePage(0);}

        SetFieldFocus;

      end;


    end; {With..}

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  finally
    Cursor := CursorState;
    OkN1Btn.Enabled := ButtonState;
  end;

end;




procedure TJCAPP.EditAccount(Edit,
                              AutoOn,
                              ViewOnly   :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ShowLink(Edit,ViewOnly);

    ProcessNtxfr(InvF,CurrKeyPath^[InvF],LastEdit,AutoOn);
  end;
end;




procedure TJCAPP.A1CPanelMouseUp(Sender: TObject; Button: TMouseButton;
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

    BarPos:=Current_BarPos(Current_Page,1);

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);
  end;
end; {Proc..}



procedure TJCAPP.A1CLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      If (MULCtrlO<>nil) then
        MULCtrlO.VisiList.PrimeMove(Sender);

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



procedure TJCAPP.A1CLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO<>nil) then
      MULCtrlO.VisiList.MoveLabel(X,Y);

    NeedCUpdate:=MULCtrlO.VisiList.MovingLab;
  end;

end;




procedure TJCAPP.A2CLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      If (MULCtrlO2<>nil) then
        MULCtrlO2.VisiList.PrimeMove(Sender);

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


procedure TJCAPP.A2CLabMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO2<>nil) then
      MULCtrlO2.VisiList.MoveLabel(X,Y);

    NeedCUpdate:=MULCtrlO2.VisiList.MovingLab;
  end;

end;

procedure TJCAPP.A2CPanelMouseUp(Sender: TObject; Button: TMouseButton;
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

    BarPos:=Current_BarPos(Current_Page,2);

    If (PanRsized) then
      MULCtrlO2.ResizeAllCols(MULCtrlO2.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO2.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO2.VisiList.MovingLab or PanRSized);
  end;

end;


procedure TJCAPP.A2CPanelClick(Sender: TObject);


Var
  n      :  Byte;
  UseRP  :  Boolean;

begin
  {$B-}
  If (Assigned(MULCtrlO)) and (Assigned(MULCtrlO2)) and (Not MActiveList) then
  {$B+}
  Begin
    MActiveList:=BOn;
    With MULCtrlO2 do
    Begin
      PaintListBar(MULCtrlO2);

      {For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        HBkColor:=aBarBkColor;
        HTextColor:=aBarTextColor;
      end;}

      UseRP:=Not MULCtrlO.ValidLine;

      MULCtrlO.ReColorBar(A1CPanel.Font,A1CPanel.Color);

      If (UseRP) then
        MULCtrlO.RePaint_Row;


      If (PageKeys^[MUListBox1.Row]=0) then {* Empty line!}
      Begin
        Update_Select(0,BOff);
        RePaint_Row;
      end
      else
        If (ValidLine) then
          Set_Row(MUListBox1.Row);

      {A1ListBtnPanel.Visible:=BOff;
      A2ListBtnPanel.Visible:=BOn;}

      {For n:=1 to TotBtns do
      Begin
        BitBtns[n].Visible:=BOn;
        MULCtrlO.BitBtns[n].Visible:=BOff;
      end;}
    end;
    PrimeButtons;

  end;
end;

procedure TJCAPP.PaintListBar(MList  :  TJAPPMList);

Var
  n      :  Byte;

Begin
  With MList do
  Begin
    For n:=0 to MUTotCols do
    With ColAppear^[n] do
    Begin
      HBkColor:=aBarBkColor;
      HTextColor:=aBarTextColor;
    end;
  end;
end;


procedure TJCAPP.A1CPanelClick(Sender: TObject);
Var
  n      :  Byte;
  UseRP  :  Boolean;

begin
  {$B-}
  If (Assigned(MULCtrlO)) and (Assigned(MULCtrlO2)) and (MActiveList) then
  {$B+}
  Begin
    MActiveList:=BOff;
    With MULCtrlO do
    Begin
      PaintListBar(MULCtrlO);

      {For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        HBkColor:=aBarBkColor;
        HTextColor:=aBarTextColor;
      end;}

      UseRP:=Not MULCtrlO2.ValidLine;

      MULCtrlO2.ReColorBar(A2CPanel.Font,A2CPanel.Color);

      If (UseRP) then
        MULCtrlO2.RePaint_Row;

      If (PageKeys^[MUListBox1.Row]=0) then {* Empty line!}
      Begin
        Update_Select(0,BOff);
        RePaint_Row;
      end
      else
        If (ValidLine) then
          Set_Row(MUListBox1.Row);

      {A2ListBtnPanel.Visible:=BOff;
      A1ListBtnPanel.Visible:=BOn;}

      {For n:=1 to TotBtns do
      Begin
        BitBtns[n].Visible:=BOn;
        MULCtrlO2.BitBtns[n].Visible:=BOff;
      end;}
    end;

    PrimeButtons;
  end;

end;

procedure TJCAPP.AddN1BtnClick(Sender: TObject);

Var
  Mode  :  Byte;

begin
  Mode:=0;

  Case Current_Page of

    NotePage
         : {$IFDEF NP}
           Begin

             SetNewFolio;

             If (NotesCtrl<>nil) then
             With ExLocal,NotesCtrl do
             Begin
               {* Reset folio, in case it changes *}

               If (FullNomKey(LInv.FolioNum) <> GetFolio) then
               Begin
                 RefreshList(FullNomkey(LInv.FolioNum),GetNType);
               end;

               NotesCtrl.AddEditNote((Sender=EditN1Btn),(Sender=InsN1Btn));
             end;

           end;
         {$ELSE}
           ;
         {$ENDIF}

    else   If ((Sender Is TButton) or (Sender Is TMenuItem))
              and ((GrpValidLine(Ord(MActiveList))) or ((Sender=AddN1Btn) or (Sender=Add1))) then
           Begin
             GrpRefreshLine(Ord(MActiveList));

             If (Sender=AddN1Btn) or (Sender=EditN1Btn) or (Sender=Edit1) or (Sender=Add1) or (Sender=InsN1Btn) or (Sender=Insert1) then
               Mode:=1+(1*(Ord(Sender=EditN1Btn)+Ord(Sender=Edit1)))+ (2*(Ord(Sender=InsN1Btn)+Ord(Sender=Insert1)));


             {* Transfer to record, so the line is upto date *}

             {* EN560. If second list deny insert *}
             If (Mode<>3) or (Not MActiveList) then
             Begin
               Form2Ntxfr;

               SetNewFolio;

               Display_Id(Mode,Ord(MActiveList)+(1*Ord(MActiveList and (Current_Page=AnalPage))));

             end
             else
             Begin
               ShowMessage('It is not possible to insert a line into the deduction block');

             end;

           end;

  end; {Case..}

end;





procedure TJCAPP.DelN1BtnClick(Sender: TObject);
begin
  Case Current_Page of

    NotePage
        :  {$IFDEF NP}
            If (NotesCtrl<>nil) then
              NotesCtrl.Delete1Click(Sender);

          {$ELSE}
             ;
          {$ENDIF}

    else   DeleteNTLine;

  end; {Case..}
end;

procedure TJCAPP.SwiN1BtnClick(Sender: TObject);
var
  ListPoint : TPoint;
begin
  {$IFDEF NP}
      If (NotesCtrl<>nil) then
      With NotesCtrl do
      Begin

        If (Not MULCtrlO.InListFind) then
        begin
          //TW: 26/10/2011 v6.9 Added submenu to handle Audit History Notes
          ListPoint.X:=1;
          ListPoint.Y:=1;

          ListPoint := SwiN1Btn.ClientToScreen(ListPoint);

          PMenu_Notes.Popup(ListPoint.X, ListPoint.Y);
        end;
      end;
  {$ENDIF}
end;


procedure TJCAPP.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    N3.Tag:=99;

    PopUp(X,Y);
  end;


end;

procedure TJCAPP.PopupMenu1Popup(Sender: TObject);
Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;


  With InvBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end; {With..}

end;


function TJCAPP.A1TPerFShowPeriod(Sender: TObject;
  const EPr: Byte): string;
begin
  Result:=PPr_Pr(EPr);
end;


procedure TJCAPP.SetNewFolio;

Begin
  With ExLocal,LInv do
  If (Not ForceStore) and (Not LastEdit) and (InAddEdit) and (Not LViewOnly) then {* Document commits to invoice number here *}
  Begin
    ForceStore:=BOn;


    If (NomAuto) then
      SetNextDocNos(LInv,BOn)
    else
      SetNextAutoDocNos(LInv,BOn);
    {* Set new list search *}

    A1ORefF.Text:=Pr_OurRef(LInv);

    HoldFlg:=HoldQ; {v5.60 auto set header on hold and clear when ok pressed so its not part of posting routine if it crashed
                     header is never stored correctly }

    { CJS - 2013-10-25 - MRD2.6.10 - Transaction Originator }
    TransactionOriginator.SetOriginator(LInv);
    A1OpoF.Hint := GetOriginatorHint(LInv);

        {* Force add of header now *}
    If (LSecure_Add(InvF,SKeypath,0)) then
      Add_DocEditNow(LInv.FolioNum);


    RefreshList(BOff,BOff);
  end;
end;

Function TJCAPP.LinkEmpToSupplier(Var FoundCode  :  Str20;
                                      AutoLink   :  Boolean)  :  Boolean;

Var
  FoundCode2  :  Str20;
  SMode       :  Integer;

Begin
  If (AutoLink) then
    SMode:=-1
  else
    SMode:=11;

  Result:=(GetJobMisc(Self,FoundCode,FoundCode,3,SMode));


  If (Result) then
  With ExLocal do
  Begin

    AssignFromGlobal(JMiscF);

    With LJobMisc^.EmplRec do
    Begin

      If (GetCust(Self,Supplier,FoundCode2,BOn,-1)) then {*EN560 Get employee *}
      Begin
        AssignFromGlobal(CustF);

        SendToObjectCC(FoundCode2,0);
      end;
    end;
  end;
end;


procedure TJCAPP.I4JobCodeFExit(Sender: TObject);
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

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanN1Btn) and (ActiveControl<>ClsN1Btn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJob(Self,FoundCode,FoundCode,5));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin
          AssignFromGlobal(JobF);

          Text:=FoundCode;

        end
        else
        Begin
          If (CanFocus) then
            SetFocus;
        end; {If not found..}

      end;

    end;
  {$ENDIF}
end;


procedure TJCAPP.I1EmpFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  mbRet      :  Word;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanN1Btn) and (ActiveControl<>ClsN1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=LinkEmpToSupplier(FoundCode,BOff);


      If (FoundOk) then
      Begin
        FoundOk:=(Not Cert_Expired(ExLocal.LJobMisc^.EmplRec.EmpCode,A1TDateF.DateValue,BOff,BOn)) or (Not (DocHed In [JSA,JPA])); {Just warn here}

      end;



      If (FoundOk) then
      With ExLocal do
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;


      end
      else
      Begin
        If (CanFocus) then
          SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;

procedure TJCAPP.I1CustFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  mbRet      :  Word;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanN1Btn) and (ActiveControl<>ClsN1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,3));



      If (FoundOk) then
      With ExLocal do
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

        A1TDateF.DateModified:=BOn;

        A1TDateFExit(Sender);

      end
      else
      Begin
        If (CanFocus) then
          SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;


procedure TJCAPP.I1AccFExit(Sender: TObject);


begin
  Inherited;

  If (Not (DocHed In [JSA,JST])) then
    I1EmpFExit(Sender)
  else
    I1CustFExit(Sender);
end;





procedure TJCAPP.THUD1FEntHookEvent(Sender: TObject);
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
          If (Sender=THUD1F) then
          Begin
            ExLocal.LInv.DocUser1:=Text;
            CUUDEvent:=1;
          end
          else
          If (Sender=THUD2F) then
          Begin
            ExLocal.LInv.DocUser2:=Text;
            CUUDEvent:=2;
          end
          else
          If (Sender=THUD3F) then
          Begin
            ExLocal.LInv.DocUser3:=Text;
            CUUDEvent:=3;
          end
          else
          If (Sender=THUD4F) then
          Begin
            ExLocal.LInv.DocUser4:=Text;
            CUUDEvent:=4;
          end
          else
          If (Sender=A1YRefF) then
          Begin
            ExLocal.LInv.YourRef:=Text;
            CUUDEvent:=120;
          end
          else //PR: 11/10/2011 Add new UDFs - Hook points are 211-216, need to subtract 60 which is added below, so 151-156
          if Sender = THUD5F then
          begin
            ExLocal.LInv.DocUser5:=Text;
            CUUDEvent:=151;
          end
          else
          if Sender = THUD6F then
          begin
            ExLocal.LInv.DocUser6:=Text;
            CUUDEvent:=152;
          end
          else
          if Sender = THUD7F then
          begin
            ExLocal.LInv.DocUser7:=Text;
            CUUDEvent:=153;
          end
          else
          if Sender = THUD8F then
          begin
            ExLocal.LInv.DocUser8:=Text;
            CUUDEvent:=154;
          end
          else
          if Sender = THUD9F then
          begin
            ExLocal.LInv.DocUser9:=Text;
            CUUDEvent:=155;
          end
          else
          if Sender = THUD10F then
          begin
            ExLocal.LInv.DocUser10:=Text;
            CUUDEvent:=156;
          end
          // PKR. 24/03/2016. ABSEXCH-17383 Add UDFs 11 and 12 for eRCT support.
          else
          if Sender = THUD11F then
          begin
            ExLocal.LInv.thUserField11 := Text;
            CUUDEvent := 157;
          end
          else
          if Sender = THUD12F then
          begin
            ExLocal.LInv.thUserField12 := Text;
            CUUDEvent := 158;
          end
          else
            raise Exception.Create('Invalid Sender in TJCAPP.THUD1FEntHookEvent: ' + (Sender as Text8pt).Name);


          Result:=IntExitHook(2000,60+CUUDEvent,-1,ExLocal);

          If (Result=0) then
            SetFocus
          else
          With ExLocal do
          If (Result=1) then
          Begin
            Case CUUDEvent of
              1  :  Text:=LInv.DocUser1;
              2  :  Text:=LInv.DocUser2;
              3  :  Text:=LInv.DocUser3;
              4  :  Text:=LInv.DocUser4;
            120  :  Text:=LInv.YourRef;
            {121  :  Text:=LInv.TransDesc;}

            //PR: 11/10/2011 v6.9 new user fields
            151  :  Text:=LInv.DocUser5;
            152  :  Text:=LInv.DocUser6;
            153  :  Text:=LInv.DocUser7;
            154  :  Text:=LInv.DocUser8;
            155  :  Text:=LInv.DocUser9;
            156  :  Text:=LInv.DocUser10;
            // PKR. 24/03/2016. ABSEXCH-17383. Add UDFs 11 and 12 for eRCT support.
            157  :  Text:=LInv.thUserField11;
            158  :  Text:=LInv.thUserField12;

            end; {Case..}
          end;
        end;
     end; {With..}

  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;


procedure TJCAPP.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>CanN1Btn) and (ActiveControl<>ClsN1Btn) then
  Begin
    Text8pt(Sender).ExecuteHookMsg;
  end;

end;



procedure TJCAPP.OkN1BtnClick(Sender: TObject);
begin

  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    begin
      if OkN1Btn.CanFocus then
        OkN1Btn.SetFocus;
      if (ActiveControl = OkN1Btn) then
        StoreNtxfr(InvF,SKeypath);
    end
    else
      If (ModalResult=mrCancel) then
      Begin

        Begin
          Close;
          Exit;
        end;
      end;
  end; {With..}
end;




procedure TJCAPP.Display_Id(Mode, TBMode: Byte);


Begin
  JATabMode:=TbMode;
  JADocHed:=DocHed;

  If (IdLine=nil) then
  Begin

    IdLine:=TJAPLine.Create(Self);

  end;

  Try


   With IdLine do
   Begin

     WindowState:=wsNormal;
     {Show;}


     InvBtnList.SetEnabBtn(BOff);

     If ((DocHed In [JSA,JST,JPT])) then
     With Self.ExLocal do
     Begin
       LResetRec(JMiscF);

       If (DocHed<>JPT) then
       Begin
         LJobMisc^.EmplRec.CCDep[BOff]:=LCust.CustDep;
         LJobMisc^.EmplRec.CCDep[BOn]:=LCust.CustCC;
       end;

     end;

     If (Mode In [1..3]) then
     Begin
       //PR: 16/11/2017 ABSEXCH-19451 Allow edit posted transaction
      if FAllowPostedEdit then
        IdLine.EnableEditPostedFields;

       Case Mode of

         1..3  :   If (Not ExLocal.InAddEdit) then
                     EditLine(Self.ExLocal.LInv,Self.ExLocal.LJobMisc^,(Mode=2),(Mode=3),
                              (Self.ExLocal.LViewOnly or cbCert.Checked))
                   else
                     Show;


       end; {Case..}

     end
     else
       If (Not ExLocal.InAddEdit) then
         ShowLink(Self.ExLocal.LInv,Self.ExLocal.LJobMisc^,Self.ExLocal.LViewOnly);

   end; {With..}

   IdLineActive:=BOn;


  except

   IdLineActive:=BOff;

   IdLine.Free;

   InvBtnList.SetEnabBtn(BOn);
   { CJS 2012-08-17 - ABSEXCH-12317 - JST Delete Check }
   DelN1Btn.Enabled := (MULCtrlO.CalcApplied = 0.0);

  end;


end;



procedure TJCAPP.DeleteNTLine;

Var
  MbRet  :  Word;
  KeyS   :  Str255;

Begin

  With ExLocal do
  If (Not MActiveList) then
  With MULCtrlO do
  Begin
    If (PageKeys^[MUListBoxes[0].Row]<>0) and (ValidLine) and (Not InListFind) and (Ok2Del) then
    Begin
      {* EN560. Check line does not have YTD totals on it before deleting *}
      Begin
        MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Line',
                           mtConfirmation,[mbYes,mbNo],0);

        If (MbRet=MrYes) then
        Begin

          ForceStore:=BOn;

          RefreshLine(MUListBoxes[0].Row,BOff);

          Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,ScanFileNum,BOn,GlobLocked);

          AssignFromGlobal(IdetailF);

          If (Ok) and (GlobLocked) then
          Begin

            Status:=Delete_Rec(F[ScanFileNum],ScanFilenum,KeyPath);

            Report_BError(ScanFileNum,Status);
          end;

          If (StatusOk) then
          Begin
            Delete_JobAct(LId);

            Update_JTLink(LId,LInv,BOn,BOn,ScanFileNum,IdLinkK,Keypath,0);

            CalcJAPVATTotals(LInv,ExLocal,Not LInv.ManVAT,3);


            With MULCtrlO do
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
            end;

            OutNTxfrTotals;
          end;
        end;
      end;
    end; {If line is valid for deletion..}
  end
  else
  With MULCtrlO2 do
  Begin
    If (PageKeys^[MUListBoxes[0].Row]<>0) and (ValidLine) and (Not InListFind) and (Ok2Del) then
    Begin
      {* EN560. Check line does not have YTD totals on it before deleting *}
      Begin
        MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Line',
                           mtConfirmation,[mbYes,mbNo],0);

        If (MbRet=MrYes) then
        Begin

          ForceStore:=BOn;

          RefreshLine(MUListBoxes[0].Row,BOff);

          Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,ScanFileNum,BOn,GlobLocked);

          AssignFromGlobal(IdetailF);

          If (Ok) and (GlobLocked) then
          Begin

            Status:=Delete_Rec(F[ScanFileNum],ScanFilenum,KeyPath);

            Report_BError(ScanFileNum,Status);
          end;

          If (StatusOk) then
          Begin
            Delete_JobAct(LId);
            
            Update_JTLink(LId,LInv,BOn,BOn,ScanFileNum,IdLinkK,Keypath,0);

            CalcJAPVATTotals(LInv,ExLocal,Not LInv.ManVAT,Ord(LId.Reconcile<>0));

            With MULCtrlO2 do
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
            end;

            OutNTxfrTotals;
          end;
        end;
      end;
    end; {If line is valid for deletion..}
  end;
end; {PRoc..}


procedure TJCAPP.A1TDateFExit(Sender: TObject);
begin
  With ExLocal,LInv,A1TDateF do
    If {(DateModified) and} (Not LastEdit) and (ValidDate(DateValue)) then
    Begin
      TransDate:=DateValue;

      If ((InvDocHed In JAPJAPSplit)) then
        I1DueDateF.DateValue:=CalcDueDate(TransDate,LCust.PayTerms);


      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
      With A1TPerF do
      Begin
        Date2Pr(TransDate,AcPr,AcYr,@ExLocal);

        InitPeriod(AcPr,AcYr,BOn,BOn);
      end;

    end;

end;


procedure TJCAPP.SetFieldProperties;

Var
  n  : Integer;


Begin
  A1BtmPanel.Color:=A1FPanel.Color;
  A1BtnPanel.Color:=A1FPanel.Color;

  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) and (Components[n]<>A1YrefF) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(A1YrefF.Font);
        Color:=A1YrefF.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        {CheckColor:=A1YrefF.Color;}
        Color:=A1FPanel.Color;
      end;

  end; {Loop..}

end;


procedure TJCAPP.SetFormProperties(SetList  :  Boolean);

Const
  PropTit     :  Array[BOff..BOn] of Str5 = ('Form','List');



Var
  TmpPanel    :  Array[1..3] of TPanel;

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


  try

    If (SetList) then
    Begin
      With MULCtrlO.VisiList do
      Begin
        VisiRec:=List[0];

        TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
        TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

        TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
        TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


        TmpPanel[3].Color:=MULCtrlO.ColAppear^[0].HBKColor;
      end;

      TmpPanel[3].Font.Assign(TmpPanel[1].Font);

      TmpPanel[3].Font.Color:=MULCtrlO.ColAppear^[0].HTextColor;
    end
    else
    Begin
      TmpPanel[1].Font:=A1YrefF.Font;
      TmpPanel[1].Color:=A1YrefF.Color;

      TmpPanel[2].Font:=A1FPanel.Font;
      TmpPanel[2].Color:=A1FPanel.Color;
    end;


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],Ord(SetList),Self.Caption+' '+PropTit[SetList]+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);
        FColorsChanged := NeedCUpdate;

        If (BeenChange) and (not ResetDefaults) then
        Begin

          If (SetList) then
          Begin
            For n:=1 to 3 do
              With TmpPanel[n] do
                Case n of
                  1,2  :  Begin
                            MULCtrlO.ReColorCol(Font,Color,(n=2));
                            MULCtrlO2.ReColorCol(Font,Color,(n=2));
                          end;

                  3    :  Begin
                            MULCtrlO.ReColorBar(Font,Color);
                            MULCtrlO2.ReColorBar(Font,Color);
                          end;
                end; {Case..}

            MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
            MULCtrlO2.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
          end
          else
          Begin
            A1FPanel.Font.Assign(TmpPanel[2].Font);
            A1FPanel.Color:=TmpPanel[2].Color;

            A1YrefF.Font.Assign(TmpPanel[1].Font);
            A1YrefF.Color:=TmpPanel[1].Color;

            SetFieldProperties;
          end;
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


procedure TJCAPP.PropFlgClick(Sender: TObject);
begin
  SetFormProperties((N3.Tag=99));
  N3.Tag:=0;
end;



procedure TJCAPP.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;






procedure TJCAPP.LnkN1BtnClick(Sender: TObject);
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
      LetterForm.LoadLettersFor (FullNomKey(ExLocal.LInv.FolioNum),
                                 ExLocal.LInv.OurRef,
                                 Copy(ExLocal.LInv.OurRef,1,3)+Copy(ExLocal.LInv.OurRef,5,5),
                                 LetterDocCode,
                                 Nil, Nil, @ExLocal.LInv, Nil, Nil);
    Except
     LetterActive := BOff;
     LetterForm.Free;
    End;
  {$ENDIF}
end;



procedure TJCAPP.ChkBtnClick(Sender: TObject);
Var
  ThisTotal,
  LastTotal  :  Double;

begin
  With ExLocal,LInv do
  Begin
    SetBtnDisable(BOff);

    LastTotal:=TotalCost+TotalInvoiced+InvNetVal+TotalReserved+InvNetVal+DiscAmount+DiscSetAm;

    CalcJAPVATTotals(LInv,ExLocal,Not LInv.ManVAT,3);

    ThisTotal:=TotalCost+TotalInvoiced+InvNetVal+TotalReserved+InvNetVal+DiscAmount+DiscSetAm;

    ForceStore:=(ForceStore or (LastTotal<>ThisTotal));


    If (Assigned(MULCtrlO2)) then
    With MULCtrlO2 do
    Begin
      If (PageKeys^[0]<>0) then
      Begin
        PageUpDn(0,BOn);
      end;

      If (PageKeys^[0]=0) then  {Sometimes a ghost line 1 exists which PaheUpDn will reset, so we have another go}
        InitPage;

     end;

  end;

  OutNTxfrTotals;

  SetBtnDisable(BOn);
end;


procedure TJCAPP.WORI1BtnClick(Sender: TObject);
Var
  WizDT  :  DocTypes;
begin
  If (DocHed=JST) then
    WizDT:=JSA
  else
    WizDT:=JPA;

  With ExLocal do
    Set_JPAJCT(LInv,LId,WizDT,LInv.CISEmpl,'',2,0);

    with TJobAppWizard.Create(Self) do
      Show;

end;


procedure TJCAPP.cbCertClick(Sender: TObject);

Var
  mbRet  :  Word;

begin
  If (Not JustCreated) then
  Begin
    {$B-}
    If (Not ExLocal.LInv.PDiscTaken) and (Not CheckUpdate_CertYTD(ExLocal,IdetailF,IdFolioK,0)) then
    {$B+}  {* v5.70 ENJACERTFIX If certification happens out of sequence, then give opportunity to refresh CTD on gross based applications *}
    Begin
      mbRet:=CustomDlg(Application.MainForm,'Warning','Cumulative Totals No Longer Match.',
                                    'The cumulative totals on this Application do not match the contract totals.'+#13+
                                    'The Retention and Deduction calcualtions are based on previously certified Applications.'+#13+
                                    'If you wish to base this Application on the latest cumulative totals, choose &OK,'+
                                    ' or if you wish to base it on the previous totals which are currently shown, choose &Cancel',mtWarning,[mbOk,mbCancel]);

      If (mbRet=mrOk) then
        CheckUpdate_CertYTD(ExLocal,IdetailF,IdFolioK,1);
    end;


    Form2NTxfr;

    { CJS - 04/05/2010 : Disable the form when the application is certified,
      and re-enable it if the application is uncertified. If the application
      has been posted, it will not be possible to get here, as the checkbox
      will be disabled. }
    SetNtxfrStore(BOn, cbCert.Checked);
    cbCert.Enabled := True;
    cbCert.Refresh;

    ReFreshFooter(3);

    ForceStore:=(ForceStore or ChkForceStore);
  end;

  TabSheet3.TabVisible:=(DocHed In JAPSalesSplit) and ((DocHed=JST) or (cbCert.Checked));
end;


procedure TJCAPP.FindN1BtnClick(Sender: TObject);
Var
  ReturnCtrl  :  TReturnCtrlRec;

begin

  {$IFDEF GF}

    If (Not MULCtrlO.InListFind)  then
    Begin

      With ReturnCtrl,MessageReturn do
      Begin
        FillChar(ReturnCtrl,Sizeof(ReturnCtrl),0);

        WParam:=3000;
        LParam:=0;
        Msg:=WM_CustGetRec;
        DisplayxParent:=BOn;
        ShowOnly:=BOn;
        Pass2Parent:=BOff;
        ShowSome:=BOff;

        If (ShowSome) then
          DontHide:=[1,3];

        Ctrl_GlobalFind(Self,ReturnCtrl,3);

      end;
    end; {If in list find..}

  {$ENDIF}
end;




procedure TJCAPP.I5CISManCbClick(Sender: TObject);
begin
(*
  If (CISOn) then
  Begin
    ExLocal.LInv.CISManualTax:=I5CISMancb.Checked;

    If (Not I5CISMancb.Checked) then
      ReFreshFooter(0);
  end;
*)
end;

procedure TJCAPP.I5MVATFClick(Sender: TObject);
begin
  ExLocal.LInv.ManVAT:=I5MVATF.Checked;

  If (Not I5MVATF.Checked) then {* Force a re calc *}
  With ExLocal do
  Begin
    If (ForceStore) or (LastEdit) then
      CalcJAPVATTotals(LInv,ExLocal,Not LInv.ManVAT,0);

    OutNTxfrTotals;
  end;

end;

procedure TJCAPP.I5VV1FExit(Sender: TObject);
begin
  VATMatrix.Update_Rate(Sender,ExLocal.LInv);
  OutNTxfrTotals;
end;

procedure TJCAPP.I1CurrFExit(Sender: TObject);
begin
  {$IFDEF MC_On}
     With ExLocal,LInv,I1CurrF do
     If (Modified)  and (OrigValue<>Text) then
     Begin
       Currency:=Succ(I1CurrF.ItemIndex);

       CXRate:=SyssCurr.Currencies[Currency].CRates;

       If (Not (InvDocHed In DirectSet)) then
         CXRate[BOff]:=0;

       VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;

       SetTriRec(Currency,UseORate,CurrTriR);

       SetTriRec(Syss.VATCurr,UseORate,VATTriR);

       I1ExRateF.Value:=CXrate[BOn];

       If (Not LViewOnly) then
         I1ExRateF.ReadOnly:=(SyssGCuR^.GhostRates.TriEuro[Currency]<>0) or (Currency=1) or (Not CanEditTriEuro(Currency));
     end;
  {$ENDIF}

end;


procedure TJCAPP.PINAFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanN1Btn) and (ActiveControl<>OkN1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Owner,FoundCode,FoundLong,2));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(NomF);



      end;


      If (FoundOk) then
      With ExLocal,LId do
      Begin

        StillEdit:=BOff;

        Text:=Form_Int(FoundLong,0);

        PINDF.Text:=Nom.Desc;

      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;

procedure TJCAPP.PICCFExit(Sender: TObject);
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


      If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanN1Btn) and (Syss.UseCCDep) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetCCDep(Self,FoundCode,FoundCode,IsCC,2));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          AssignFromGlobal(PWrdF);

        end;


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

    end; {with..}
  {$ENDIF}
end;

procedure TJCAPP.cbPayAppsFClick(Sender: TObject);
begin

  PINAF.Enabled:=cbPayAppsF.Checked;
  PICQF.Enabled:=cbPayAppsF.Checked;
  PIPIF.Enabled:=cbPayAppsF.Checked;
  PICCF.Enabled:=cbPayAppsF.Checked;
  PIDepF.Enabled:=cbPayAppsF.Checked;
  PIAMTF.Enabled:=cbPayAppsF.Checked;
  PIJAF.Enabled:=cbPayAppsF.Checked;

  If (cbPayAppsF.Checked) then
  Begin
    If (PIAMTF.Value=0.0) then
     PIAMTF.Value:=Calc_JAPDocTotal(ExLocal.LInv,BOn,0);
  end
  else
    PIAMTF.Value:=0.0;

end;

procedure TJCAPP.PIJAFExit(Sender: TObject);
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

      If (((AltMod) or (FoundCode='')) and (ActiveControl<>CanN1Btn)) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Owner,FoundCode,FoundCode,2,Anal_FiltMode(SRC)));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          AssignFromGlobal(JMiscF);

          Text:=FoundCode;

        end
        else
        Begin
          SetFocus;
        end; {If not found..}
      end;

    end;
  {$ENDIF}

end;


procedure TJCAPP.cbCertMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  cbCertClick(Sender);
end;

// MHYR 25/10/07
procedure TJCAPP.A1YRefFChange(Sender: TObject);
begin
  A1YRefF.Hint := A1YRefF.Text;
end;

procedure TJCAPP.I5CISManCbMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If (CISOn) and (Button = mbLeft) then
  Begin
    ExLocal.LInv.CISManualTax:=I5CISMancb.Checked;

    If (Not I5CISMancb.Checked) then
      ReFreshFooter(0)
    else
    // CJS 17/11/2010 - If the user overrides the CIS Tax, display the line
    // dialog so that they can enter the new value.
    begin
      if FindCISLine(ExLocal.LInv) then
      begin
        CISTaxRecalcRequired := False;
        Display_Id(2, 1);
        If (IdLineActive) and (Not ExLocal.InAddEdit) then {*it must be readonly *}
          IdLine.Show;
      end;
    end;
  end;
end;

function TJCAPP.FindCISLine(BInv: InvRec): Boolean;
const
  Fnum    = IDetailF;
  Keypath = IDFolioK;
var
  KeyChk: Str255;
  KeyS: Str255;
begin
  KeyChk := FullNomKey(BInv.FolioNum);
  KeyS := FullIdKey(BInv.FolioNum, JALRetLineNo);
  Result := False;
  Status := Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
  while (StatusOk) and (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) do
  begin
    if (Id.AutoLineType = 2) then
    begin
      Result := True;
      break;
    end;
    Status := Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
  end;
end;

procedure TJCAPP.MenItem_AuditClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmAudit);
end;

procedure TJCAPP.MenItem_DatedClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmDated);
end;

procedure TJCAPP.MenItem_GeneralClick(Sender: TObject);
begin
  If (NotesCtrl <> nil) then
    NotesCtrl.SwitchNoteMode(nmGeneral);
end;

procedure TJCAPP.SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
begin
  //Called when user uses Switch from pop-up menu on Notes form
  AddN1Btn.Enabled := NewMode <> nmAudit;
  EditN1Btn.Enabled := NewMode <> nmAudit;
  InsN1Btn.Enabled := NewMode <> nmAudit;
  DelN1Btn.Enabled := NewMode <> nmAudit;
end;

procedure TJCAPP.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;
  //YourRef & AltRef
  A1YRefF.AllowPostedEdit := True;
  PIPIF.AllowPostedEdit := True;

  //UDFs
  THUD1F.AllowPostedEdit := True;
  THUD2F.AllowPostedEdit := True;
  THUD3F.AllowPostedEdit := True;
  THUD4F.AllowPostedEdit := True;
  THUD5F.AllowPostedEdit := True;
  THUD6F.AllowPostedEdit := True;
  THUD7F.AllowPostedEdit := True;
  THUD8F.AllowPostedEdit := True;
  THUD9F.AllowPostedEdit := True;
  THUD10F.AllowPostedEdit := True;

  ClsN1Btn.Visible := False;
  ClsN1Btn.Enabled := False;
  OkN1Btn.Top := CanN1Btn.Top + 6;
  CanN1Btn.Top := ClsN1Btn.Top + 6;
end;

//SSK 08/01/2018 2018R1 ABSEXCH-19613: Implements anonymisation behaviour for Job related transactions
procedure TJCAPP.SetAnonymisationON(AValue: Boolean);
begin
  FAnonymisationON := AValue;
  SetAnonymisationBanner;
end;

procedure TJCAPP.SetAnonymisationBanner;
var
  lAnonymised: Boolean;
begin
  //HV 30/01/2018 2018R1 ABSEXCH-19683: Remove Post Anon behaviour and Remove custom field 'Contains PII data' check box for JPT.
  if FAnonymisationON and (ExLocal.LInv.InvDocHed <> JPT) then
  begin
    if (pnlAnonymisationStatus.Visible or FSaveAnonPanelCord) then
      InitSize.Y := Self.ClientHeight
    else
      InitSize.Y := Self.ClientHeight + pnlAnonymisationStatus.Height;
  end
  else
  begin
    if (pnlAnonymisationStatus.Visible or FSaveAnonPanelCord) then
      InitSize.Y := Self.ClientHeight - pnlAnonymisationStatus.Height
    else
      InitSize.Y := Self.ClientHeight;
    PagePoint[0].Y:= 3;
  end;

  //HV 30/01/2018 2018R1 ABSEXCH-19683: Remove Post Anon behaviour and Remove custom field 'Contains PII data' check box for JPT.
  pnlAnonymisationStatus.Visible := FAnonymisationON and (ExLocal.LInv.InvDocHed <> JPT); 
  if pnlAnonymisationStatus.Visible then
  begin
    //change the color of anonymisation controls
    with SystemSetup.GDPR do
    begin
      shpNotifyStatus.Brush.Color := NotificationWarningColour;
      shpNotifyStatus.Pen.Color := shpNotifyStatus.Brush.Color;
      lblAnonStatus.Font.Color := NotificationWarningFontColour;
    end;
    lblAnonStatus.Caption := Format(capAnonymisedStatus, [POutDate(ExLocal.LInv.thAnonymisedDate)]); //update the anonymisation Date
    SetAnonymisationPanel;
  end;

  Self.ClientHeight := InitSize.Y;
  FormResize(nil);
end;

procedure TJCAPP.SetAnonymisationPanel;
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

Initialization

end.
