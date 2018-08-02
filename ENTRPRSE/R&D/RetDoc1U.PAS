Unit RetDoc1U;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, TEditVal, BorBtns, Mask, ComCtrls, Math,

  GlobVar,VarConst,ExWrap1U,BTSupU1,SupListU,SBSComp2,

  DelAddU,
  SalTxL1U,

  ExtGetU,

  RetLineU,

  {$IFDEF NP}
    NoteU,
  {$ENDIF}

  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  Menus, Gauges, bkgroup, AccelLbl, Buttons;



type
  TRetMList  =  Class(TDDMList)

  sLineType   :  TStringList;


  Public
    aBarBkColor,
    aBarTextColor
              :  TColor;



    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;


  end;


type
  TRetDoc = class(TForm)
    PageControl1: TPageControl;
    AdjustPage: TTabSheet;
    A1SBox: TScrollBox;
    A1HedPanel: TSBSPanel;
    A1GLab: TSBSPanel;
    A1OLab: TSBSPanel;
    A1ILab: TSBSPanel;
    A1CCLab: TSBSPanel;
    A1DpLab: TSBSPanel;
    A1CPanel: TSBSPanel;
    A1BUPanel: TSBSPanel;
    A1GPanel: TSBSPanel;
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
    A1LocPanel: TSBSPanel;
    A1LocLab: TSBSPanel;
    LnkN1Btn: TButton;
    IssuedLab: Label8;
    A1UOPanel: TSBSPanel;
    A1UOLab: TSBSPanel;
    A1WOPanel: TSBSPanel;
    A1OSLab: TSBSPanel;
    A1IPanel: TSBSPanel;
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
    ChkBtn: TButton;
    Check1: TMenuItem;
    APickI1Btn: TButton;
    AutoPick1: TMenuItem;
    PopupMenu2: TPopupMenu;
    AP1: TMenuItem;
    AW1: TMenuItem;
    Ap2: TMenuItem;
    AW2: TMenuItem;
    Gauge1: TGauge;
    WORI1Btn: TButton;
    WorksOrder1: TMenuItem;
    MatI1Btn: TButton;
    Match1: TMenuItem;
    N4: TMenuItem;
    FindN1Btn: TButton;
    Find1: TMenuItem;
    TabSheet4: TTabSheet;
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
    A1FPanel: TSBSPanel;
    Label84: Label8;
    I1CurrLab: Label8;
    lblAcCode: Label8;
    I1ExLab: Label8;
    Label89: Label8;
    Label817: Label8;
    I1DelBtn: TSpeedButton;
    I1DueDateL: Label8;
    SBSAccelLabel1: TSBSAccelLabel;
    A1ORefF: Text8Pt;
    A1OpoF: Text8Pt;
    I1AccF: Text8Pt;
    A1TDateF: TEditDate;
    I1EXRateF: TCurrencyEdit;
    A1TPerF: TEditPeriod;
    I1CurrF: TSBSComboBox;
    I1DumPanel: TSBSPanel;
    FixXRF: TBorCheck;
    I1StatCB1: TSBSComboBox;
    A1OSPanel: TSBSPanel;
    A1WOLab: TSBSPanel;
    A1CLab: TSBSPanel;
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
    I5SDPF: TCurrencyEdit;
    I5SDDF: TCurrencyEdit;
    I5Net1F: TCurrencyEdit;
    I5VAT1F: TCurrencyEdit;
    I5Disc1F: TCurrencyEdit;
    I5Tot1F: TCurrencyEdit;
    I5Net2F: TCurrencyEdit;
    I5VAT2F: TCurrencyEdit;
    I5Disc2F: TCurrencyEdit;
    I5Tot2F: TCurrencyEdit;
    SBSPanel62: TSBSPanel;
    Label13: TLabel;
    SBSPanel63: TSBSPanel;
    Label21: TLabel;
    DMDCNomF: Text8Pt;
    I5VRateF: TCurrencyEdit;
    CanI5Btn: TButton;
    ClsI5Btn: TButton;
    OkI5Btn: TButton;
    I5SDTF: TBorCheck;
    AR1: TMenuItem;
    AR2: TMenuItem;
    Rep1: TMenuItem;
    Rep2: TMenuItem;
    N6: TMenuItem;
    WO1: TMenuItem;
    WO2: TMenuItem;
    TransExtForm1: TSBSExtendedForm;
    I1YrRefL: Label8;
    I1YrRef2L: Label8;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    Bevel1: TBevel;
    I5NBL: Label8;
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
    A1YRefF: Text8Pt;
    I1YrRef2F: Text8Pt;
    I5NBF: TCurrencyEdit;
    THUD5F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD10F: Text8Pt;
    mnuSwitchNotes: TPopupMenu;
    General1: TMenuItem;
    Dated1: TMenuItem;
    AuditHistory1: TMenuItem;
    I1AddrF: TMemo;
    panFooterTotals: TSBSBackGroup;
    lblTotalsNet: TLabel;
    lblTotalsVAT: TLabel;
    lblTotalsDiscount: TLabel;
    lblTotalsTotal: TLabel;
    ccyTotalsTotal: TCurrencyEdit;
    ccyTotalsDiscount: TCurrencyEdit;
    ccyTotalsVAT: TCurrencyEdit;
    ccyTotalsNet: TCurrencyEdit;
    UDF11L: Label8;
    THUD11F: Text8Pt;
    UDF12L: Label8;
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
    procedure A1CPanelClick(Sender: TObject);
    procedure I4JobCodeFExit(Sender: TObject);
    procedure I5MVATFClick(Sender: TObject);
    procedure I5VV1FExit(Sender: TObject);
    procedure I1CurrFExit(Sender: TObject);
    procedure WORI1BtnClick(Sender: TObject);
    procedure I1AddrFDblClick(Sender: TObject);
    procedure A1TPerFExit(Sender: TObject);
    procedure A1YRefFEnter(Sender: TObject);
    procedure TransExtForm1Exit(Sender: TObject);
    procedure TransExtForm1Enter(Sender: TObject);
    procedure I1DelBtnClick(Sender: TObject);
    procedure I5SDPFExit(Sender: TObject);
    procedure AP1Click(Sender: TObject);
    procedure APickI1BtnClick(Sender: TObject);
    procedure I1EXRateFEnter(Sender: TObject);
    procedure I1YrRef2FEnter(Sender: TObject);
    procedure A1YRefFChange(Sender: TObject);
    procedure TransExtForm1Resize(Sender: TObject);
    procedure I1YrRef2FChange(Sender: TObject);
    procedure I1StatCB1Enter(Sender: TObject);
    procedure I1StatCB1DropDown(Sender: TObject);
    procedure General1Click(Sender: TObject);
    procedure Dated1Click(Sender: TObject);
    procedure AuditHistory1Click(Sender: TObject);

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
    BalDone,
    fFrmClosing,
    fDoingClose,
    fRecordLocked,
    CouldIssue,
    CouldBook,
    GotCoord,
    fChkYourRef,
    CanDelete    :  Boolean;

    SKeypath,
    MinHeight,
    MinWidth     :  Integer;

    DispCust     :  TFCustDisplay;
    VATMatrix    :  TVATMatrix;

    StatusItems,
    LTDescStr    :  TStringList;

    {$IFDEF NP}
      NotesCtrl  :  TNoteCtrl;
    {$ENDIF}

    DelACtrl     :  TDelAddrPop;

    InvBtnList   :  TVisiBtns;

    IdLine       :  TRetLine;
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

    // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    SettlementDiscountPercentage : Double;
    SettlementDiscountDays : Integer;

    //PR: 13/11/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;

    // SSK 11/01/2018 ABSEXCH-19614: variable added to handle anonymisation behaviour
    FAnonymisationON: Boolean;
    FSaveAnonPanelCord: Boolean;

    function TransactionViewOnly : Boolean;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure SetBtnDisable(State  :  Boolean);

    Procedure SetForceStore(State  :  Boolean);

    procedure NotePageReSize;

    Procedure Link2Nom;

    Function ChkForceStore  :  Boolean;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;


    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Function CheckNeedStore  :  Boolean;

    Function ConfirmQuit  :  Boolean;

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure Display_Id(Mode,TBMode  :  Byte);

    procedure DeleteNTLine;

    procedure SetFormProperties(SetList  :  Boolean);

    procedure SetFieldProperties;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Function LinkEmpToSupplier(Var FoundCode  :  Str20;
                                   AutoLink   :  Boolean)  :  Boolean;


    procedure I1EmpFExit(Sender: TObject);

    procedure I1CustFExit(Sender: TObject);


    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    //PR: 20/12/2011
    procedure SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);

    // CJS 2013-11-28 - MRD1.1.17 - Consumer Support
    procedure ResizeAcCodeField(ForConsumer: Boolean);

    // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    procedure SetDefaultSettlementDiscount;
    Procedure ShowSettlementDiscountFields (Const ShowFields : Boolean);

    //SSK 11/01/2018 2018R1 ABSEXCH-19614: Routines for handling of Post Anonymisation Behaviour for SRN/PRN
    procedure SetAnonymisationBanner;
    procedure SetAnonymisationON(AValue: Boolean);
    procedure SetAnonymisationPanel;

  public
    { Public declarations }

    fForceStore:  Boolean;

    ExLocal    :  TdExLocal;
    ListOfSet  :  Integer;


    MULCtrlO   :  TRetMList;


    Property ForceStore  : Boolean read fForceStore write SetForceStore default False;

    Function CheckOverride(PageNo  :  Integer)  :  Boolean;


    Procedure SetCtrlNomStat;

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

    procedure HideListColumns(PageNo  :  Integer);


    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

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

    procedure ReApplyVAT(Value  :  Real);

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
  end;

  Procedure Set_RetFormMode(State  :  DocTypes;
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
  Warn1U,

  InvFSu2U,

  {$IFDEF FRM}
    DefProcU,                       
  {$ENDIF}

  {$IFDEF SOP}
    Saltxl2U,

  {$ENDIF}

  InvCTSuU,

  InvCT2SU,
  JobSup2U,
  Event1U,
  PWarnU,
  RetSup1U,
  GenWarnU,
  ThemeFix,
  RetWiz1U,

  //PR: 23/11/2011
  CustomFieldsIntf,

  { CJS - 2013-10-25 - MRD2.6.13 - Transaction Originator }
  TransactionOriginator,

  // MH 23/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  TransactionHelperU,

  //PR: 20/12/2011
  AuditNotes,
  // SSK 11/01/2018 ABSEXCH-19614:
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
  RetFormMode  :  DocTypes;
  RetFormPage  :  Byte;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_RetFormMode(State  :  DocTypes;
                          NPage  :  Byte);

Begin
  If (State<>RetFormMode) then
    RetFormMode:=State;

  If (RetFormPage<>NPage) then
    RetFormPage:=NPage;

end;




{$I RETI1U.PAS}



Procedure  TRetDoc.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TRetDoc.Find_FormCoord;


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

    PrimeKey:=DocCodes[DocHed][2];

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

    GetbtControlCsm(A1BtnPanel);

    GetbtControlCsm(A1ListBtnPanel);

    GetbtControlCsm(TCNScrollBox);
    GetbtControlCsm(TCNListBtnPanel);


    If GetbtControlCsm(A1YrefF) then
      SetFieldProperties;

    //SSK 11/01/2018 2018R1 ABSEXCH-19614:
    if GetbtControlCsm(pnlAnonymisationStatus) then
      FSaveAnonPanelCord := True;


    MULCtrlO.Find_ListCoord(GlobComp);


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


procedure TRetDoc.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:=DocCodes[DocHed][2];

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(A1SBox);

    StorebtControlCsm(A1BtnPanel);

    StorebtControlCsm(A1ListBtnPanel);

    StorebtControlCsm(A1YrefF);

    StorebtControlCsm(TCNScrollBox);

    StorebtControlCsm(TCNListBtnPanel);

    // SSK 11/01/2018 ABSEXCH-19614:
    StorebtControlcsm(pnlAnonymisationStatus);

    MULCtrlO.Store_ListCoord(GlobComp);


    {$IFDEF NP}
      If (NotesCtrl<>nil) then
        NotesCtrl.MULCtrlO.Store_ListCoord(GlobComp);
    {$ENDIF}

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

end;


procedure TRetDoc.SetBtnDisable(State  :  Boolean);

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

    {cbCert.Enabled:=State;}

  end;
end;

procedure TRetDoc.SetForceStore(State  :  Boolean);

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


Function TRetDoc.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;


Procedure TRetDoc.Link2Nom;

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

Function TRetDoc.ChkForceStore  :  Boolean;

Begin
  With ExLocal do
  Begin
    Result:=((LInv.ILineCount<>LastInv.ILineCount) or
             (Linv.TotalCost<>LastInv.TotalCost) or
             (Linv.TotalInvoiced<>LastInv.TotalInvoiced) or
             (LInv.TotalReserved<>LastInv.TotalReserved) or
             (LInv.InvNetVal<>LastInv.InvNetVal) or
             (LInv.DiscAmount<>LastInv.DiscAmount) or
             (LInv.DiscSetAm<>LastInv.DiscSetAm)
             );


  end;
end;

Procedure TRetDoc.WMCustGetRec(Var Message  :  TMessage);
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

                        Display_Id(2,0);

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
            end;

      7  :  NoteUpDate; {* Update note line count *}

     17  :  Begin {* Force reset of form *}
              GotCoord:=BOff;
              SetDefault:=BOn;
              Close;
            end;

      25  :  NeedCUpdate:=BOn;


     108  :
             Begin
               With MULCtrlO do
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));

               If (IdLine<>nil) then
               With ExLocal do
               Begin
                 LInv:=IdLine.ExLocal.LInv;

                 CouldIssue:=(CouldIssue or (IdLine.ExLocal.LId.QtyPWOff+IdLine.ExLocal.LId.SSDUplift<>0.0));
                 CouldBook:=(CouldBook or (IdLine.ExLocal.LId.QtyPWoff<>0.0));


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


     65536 : If Assigned(I1StatCB1) And I1StatCB1.CanFocus Then
               I1StatCB1.BringToFront;
    end; {Case..}

  end;
  Inherited;
end;



Procedure TRetDoc.WMFormCloseMsg(Var Message  :  TMessage);
Begin


  With Message do
  Begin


    Case WParam of


      48  :  MatchOrdPtr:=nil;


    end; {Case..}

  end;
  Inherited;
end;


Procedure TRetDoc.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TRetDoc.Send_UpdateList(Edit   :  Boolean;
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


procedure TRetDoc.ShowLink(ShowLines,
                               VOMode    :  Boolean);
var
  lAnonStat: string;      //SSK 11/01/2018 2018R1 ABSEXCH-19614: variable added
begin
  ExLocal.AssignFromGlobal(InvF);
  ExLocal.LGetRecAddr(InvF);

  With ExLocal,LInv do
  Begin

    //SSK 11/01/2018 2018R1 ABSEXCH-19614: update caption for anonymisation
    lAnonStat := ' ';
    if GDPROn and (thAnonymised) then
      lAnonStat := lAnonStat + capAnonymised;
    Caption := DocNames[InvDocHed]+' Record - ' + Pr_OurRef(LInv) + lAnonStat;

    {$B-}

    LViewOnly:=SetViewOnly(ShowLines,VOMode);


    PrimeButtons;

    {$B+}

    {If (Not LViewOnly) and (InvDocHed In JAPJAPSplit) then
    Begin {OVerride some read only behaviour}
      {If (DeliverRef='') then
      Begin
        J1BASISF.Tag:=1;
        J1BASISF.Color:=A1YRefF.Color;
        J1BASISF.ReadOnly:=BOff;

      end;

    end;}

    //SSK 11/01/2018 2018R1 ABSEXCH-19614: Anonymisation status determined here
    if ShowLines or VOMode then
      FAnonymisationON := (GDPROn and (trim(OurRef) <> '') and thAnonymised)
    else
      FAnonymisationON := False;

    SetAnonymisationBanner;

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


procedure TRetDoc.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(A1SBox.Width);
  PagePoint[1].Y:={PageControl1.Height-}(A1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(A1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(A1BtnPanel.Height);

  PagePoint[3].X:=A1BtnPanel.Height-(A1BSBox.Height);
  PagePoint[3].Y:=A1SBox.ClientHeight-(A1CPanel.Height);

  PagePoint[4].X:=PageControl1.Width-(A1ListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(A1ListBtnPanel.Height);

  PagePoint[5].X:=PageControl1.Width-(TCNScrollBox.Width);
  PagePoint[5].Y:=PageControl1.Height-(TCNScrollBox.Height);

  PagePoint[6].Y:=PageControl1.Height-(TCNListBtnPanel.Height);
  PagePoint[6].X:=PageControl1.Height;

  GotCoord:=BOn;

end;

Function TRetDoc.CheckOverride(PageNo  :  Integer)  :  Boolean;

Begin
   Result:=BOff;

  {Result:=(MActiveList and (DocHed In JAPJAPSplit) and
        (((PageNo=MainPage) and (Not PChkAllowed_In((458*Ord(DocHed In JAPSalesSplit))+(461*Ord(DocHed In JAPPurchSplit)))))
        or
        ((PageNo=AnalPage) and (Not PChkAllowed_In((459*Ord(DocHed In JAPSalesSplit))+(462*Ord(DocHed In JAPPurchSplit)))))));}
end;

Function TRetDoc.SetHelpC(PageNo :  Integer;
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

procedure TRetDoc.PrimeButtons;

Var
  PageNo        :  Integer;
  SetOverride   :  Boolean;

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
      {* EN570 Will need new passwords and help ids *}

      SetOverride:=CheckOverride(PageNo);

      SetHideBtn(0,((ExLocal.LViewOnly) and ((PageNo<>NotePage) or (fRecordLocked))) or (Not PChkAllowed_In(SetHelpC(PageNo,[MainPage..NotePage],-255,-255))) or (SetOverride) or (PageNo In [FootPage,PayPage]),BOff);
      SetHideBtn(1,((ExLocal.LViewOnly) and (PageNo=NotePage) and (fRecordLocked)) or (Not PChkAllowed_In(SetHelpC(PageNo,[MainPage..NotePage],-255,-255))) or (SetOverride) or (PageNo In [FootPage,PayPage]),BOff);



      {SetBtnHelp(0,SetHelpC(PageNo,[MainPage..NotePage],0,88));
      SetBtnHelp(1,SetHelpC(PageNo,[MainPage..NotePage],0,87));}


      SetHideBtn(2,((ExLocal.LViewOnly) and ((PageNo<>NotePage) or (fRecordLocked))) or (Not PChkAllowed_In(SetHelpC(PageNo,[MainPage..NotePage],-255,-255))) or (SetOverride) or (PageNo In [FootPage,PayPage]),BOff);

      {SetBtnHelp(2,SetHelpC(PageNo,[MainPage..NotePage],0,89));}


      SetHideBtn(3,(ExLocal.LViewOnly) or (fRecordLocked) and (PageNo<>NotePage) or (Not PChkAllowed_In(SetHelpC(PageNo,[MainPage..NotePage],-255,-255))) or (SetOverride) or (PageNo In [FootPage,PayPage]),BOff);

      SetHideBtn(5,(PageNo<>NotePage),BOff);

      SetHideBtn(6,((ExLocal.LViewOnly) or (fRecordLocked)) or (PageNo In [NotePage]) or (Not PChkAllowed_In(SetHelpC(PageNo,[MainPage..NotePage],-255,-255))),BOff);

      SetHideBtn(7,(PageNo In [NotePage,FootPage,PayPage]) or ((Not ExLocal.LastEdit) and (Not ExLocal.LViewOnly)) or (DocHed In StkRetPurchSplit) or (Not PChkAllowed_In(SetHelpC(PageNo,[MainPage..NotePage],-255,-255))),BOff);

      {SetHideBtn(6,BOn,BOff);}

      {SetHideBtn(8,(PageNo In [NotePage]) or ((Not ExLocal.LastEdit) and (Not ExLocal.LViewOnly)),BOff);}
      SetHideBtn(8,BOn,BOff);


      SetHideBtn(9,((ExLocal.LViewOnly) or (fRecordLocked)) or (PageNo In [NotePage,FootPage,PayPage]),BOff);
      SetHideBtn(10,(PageNo In [NotePage]),BOn);

    end;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

procedure TRetDoc.SetTransHelp;

Begin
  Case DocHed of {*EN570 Set help ids *}
    SRN  :  Begin
              Self.HelpContext:=1594;
              I1AccF.HelpContext:=0;
            end;

    PRN  :  Begin
              Self.HelpContext:=1594;
              I1AccF.HelpContext:=0;
            end;


  end; {Case..}
end;

// CJS 2013-11-28 - MRD1.1.17 - Consumer Support
procedure TRetDoc.ResizeAcCodeField(ForConsumer: Boolean);
begin
  if Syss.ssConsumersEnabled and ForConsumer then
  begin
    lblAcCode.Left := 4;
    I1AccF.Left := 26;
    I1AccF.Width := 263;
    I1AddrF.Top := 33;
    I1AddrF.Height := 48;
  end
  else
  begin
    lblAcCode.Left := 186;
    I1AccF.Left := 208;
    I1AccF.Width := 80;
    I1AddrF.Top := 7;
    I1AddrF.Height := 74;
  end;
  // Force a re-positioning of the drop-down/pop-up arrows
  I1AccF.PosArrows;
end;

procedure TRetDoc.BuildDesign;

Var
  HideCC,
  HideLoc  :  Boolean;

  UDDocHed : DocTypes;

begin

  // CJS 2013-11-27 - MRD1.1.17 - Consumer Support
  ResizeAcCodeField(DocHed in StkRetSalesSplit);

  {* Set Version Specific Info *}

  TabSheet3.TabVisible:=BOff;

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

  TransExtform1.ReAssignFocusLast;



  {$IFNDEF MC_On}
    I1CurrF.Visible:=BOff;
    I1ExRateF.Visible:=BOff;
    Label89.Visible:=BOff;
    FixXRF.Visible:=BOff;
  {$ELSE}
    Set_DefaultCurr(I1CurrF.Items,BOff,BOff);
    Set_DefaultCurr(I1CurrF.ItemsL,BOff,BOn);

    FixXRF.Visible:=(UseCoDayRate);

    {I5Tot1F.ShowCurrency:=BOn;
    I5Tot2F.ShowCurrency:=BOn;}

  {$ENDIF}


  Set_DefaultRetStat(I1StatCB1.ITems,(DocHed In StkRetSalesSplit),BOff);
  Set_DefaultRetStat(I1StatCB1.ITemsL,(DocHed In StkRetSalesSplit),BOn);

  //PR: 23/11/2011 v6.9 Added handling for new custom fields.
  {$IFDEF ENTER1}
    EnableUdfs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L, UDF11L, UDF12L],
               [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F],
               DocTypeToCFCategory(DocHed));
    ResizeUDFParentContainer(NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F]),
                             2,
                             TransExtForm1,
                             0,     // RowHeightOverRide
                             12);   // UDF_Count
  {$ENDIF}

(*  //GS 17/10/2011 ABSEXCH-11706: if any of the user defined fields are hidden..
  If (Not THUD1F.Visible) or (Not THUD2F.Visible) or (Not THUD3F.Visible) or (Not THUD4F.Visible)
  or (Not THUD5F.Visible) or (Not THUD6F.Visible) or (Not THUD7F.Visible) or (Not THUD8F.Visible)
  or (Not THUD9F.Visible) or (Not THUD10F.Visible)then
  With TransExtForm1 do
  Begin
    //..then check if all the fields are hidden..
    //..if all the fields are hidden..
    If ((Not THUD1F.Visible) and (Not THUD2F.Visible) and (Not THUD3F.Visible) and (Not THUD4F.Visible)
    and (Not THUD5F.Visible) and (Not THUD6F.Visible) and (Not THUD7F.Visible) and (Not THUD8F.Visible)
    and (Not THUD9F.Visible) and (Not THUD10F.Visible)) then
      //..resize the extension form (is it is not displaying a large blank form where the fields would be)
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


  I5MVATF.Caption:=CCVATName^+I5MVATF.Caption;
  I5VATRLab.Caption:=CCVATName^+I5VATRLab.Caption;
  I5VATLab.Caption:=CCVATName^;
  Label14.Caption:=CCVATName^;
  Label18.Caption:=CCVATName^;

  // MH 27/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  lblTotalsVAT.Caption:=CCVATName^;

  I5VRateL.Caption:=CCVATName^+I5VRateL.Caption;

  If (Syss.WarnYRef) then
    I1YrRef2F.Charcase:=ecUpperCase;

  If (DocHed In StkRetSalesSplit) then
  Begin
    {A1OSLab.Caption:='Issued';
    CrReqdTit.Caption:=A1OSLab.Caption;
    {Label812.Caption:='%Issued: ';}

  end;

  CreateSubMenu(PopUpMenu2,AutoPick1);

end;


procedure TRetDoc.FormDesign;


begin

  PrimeButtons;

  BuildDesign;

  SetTransHelp;
end;

procedure TRetDoc.HidePanels(PageNo    :  Byte);

Var
  TmpBo  :  Boolean;
  n      :  Integer;

Begin
  With MULCtrlO,VisiList do
  Begin
    fBarOfSet:=Current_BarPos(PageNo,1);

    DisplayMode:=PageNo;

    Case PageNo of

      MainPage
         :  Begin
              For n:=2 to 12 do
                SetHidePanel(FindxColOrder(n),(n>=9),(n=12));

              With ColAppear^[6] do
              Begin
                NoDecPlaces:=2;
              end;

              A1ILab.Caption:='Line Total';
              A1WOLab.Caption:='O/S ';

              A1ILab.HelpContext:=1628;

              A1WOLab.HelpContext:=1626;

            end;


      AnalPage
         :  Begin
              For n:=2 to 12 do
                SetHidePanel(FindxColOrder(n),(((n<=9) and (n>5))) and (n<>6),BOff);

              A1WOLab.Caption:='Written Off';
              {$IFNDEF PF_On}
                TmpBo:=BOn;
              {$ELSE}
                TmpBo:=Not Syss.UseCCDep;
              {$ENDIF}

              {SetHidePanel(FindxColOrder(9),Not PChkAllowed_In(143),BOff); {Hide Cost if hide gp set}
              {SetHidePanel(FindxColOrder(10),Not Syss.UseMLoc,BOff);}
              SetHidePanel(FindxColOrder(11),TmpBo,BOff);
              SetHidePanel(FindxColOrder(12),TmpBo,BOn);

              With ColAppear^[6] do
              Begin
                NoDecPlaces:=Syss.NoCosDec;
              end;

              A1ILab.Caption:='Cost Price';

              A1ILab.HelpContext:=1632;

              A1WOLab.HelpContext:=1631;

            end;


    end; {Case..}

    A1IPanel.HelpContext:=A1ILab.HelpContext;
    A1WOPanel.HelpContext:=A1WOLab.HelpContext;
  end; {with..}

end;



Function TRetDoc.Current_BarPos(PageNo,LNo  :  Byte)  :  Integer;

Begin
  Result := 0;
  Case PageNo of
      MainPage
         :  Case LNo of
               1  :  Result:=A1SBox.HorzScrollBar.Position;
            end; {Case..}

      else  Result:=0;
    end; {Case..}


end;




procedure TRetDoc.RefreshList(ShowLines,
                                 IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;

Begin
  KeyStart:=FullIdkey(EXLocal.LInv.FolioNum,1);

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(IdetailF,IdFolioK,KeyStart,'','',4,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;


end;


procedure TRetDoc.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TRetMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO do
    Begin

      Try

        With VisiList do
        Begin
          {00} AddVisiRec(A1CPanel,A1CLab);
          {01} AddVisiRec(A1BPanel,A1BLab);
          {02} AddVisiRec(A1UOPanel,A1UOLab);
          {03} AddVisiRec(A1OSPanel,A1OSLab);
          {04} AddVisiRec(A1WOPanel,A1WOLab);
          {05} AddVisiRec(A1IssPanel,A1IssLab);
          {06} AddVisiRec(A1IPanel,A1ILab);
          {07} AddVisiRec(A1BUPanel,A1BULab);
          {08} AddVisiRec(A1OPanel,A1OLab);
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

        If (n In [1..4,6..7]) then
        Begin
          DispFormat:=SGFloat;

          Case n of
            1..4 :  NoDecPlaces:=Syss.NoQtyDec;
            6    :  NoDecPlaces:=2;
            7
                 :  If (DocHed In StkRetSalesSplit) then
                      NoDecPlaces:=Syss.NoNetDec
                    else
                      NoDecPlaces:=Syss.NoCosDec;

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
      HighLiteStyle[2]:=[fsUnderline];
      HighLiteStyle[3]:=[fsUnderline,fsBold];

      aBarBkColor:=ColAppear^[0].HBkColor;
      aBarTextColor:=ColAppear^[0].HTextColor;


    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;


  FormSetOfSet;

  FormReSize(Self);

end;




procedure TRetDoc.ReFreshFooter(CalcMode  :  Byte);
Begin
  With ExLocal,LInv do
  Begin
    SetBtnDisable(BOff);
    If (ForceStore) or (LastEdit) or (LViewOnly) then
    Begin


      CalcInvTotals(LInv,ExLocal,Not ManVAT,BOn);

    end;

    VATMatrix.HideVATMatrix(LInvNetTrig);

  end; {With..}

  OutNTxfrTotals;

  SetBtnDisable(BOn);
end;


Procedure TRetDoc.OutNTxfrTotals;

Var
  Dnum    :  Double;
  NTDrCr  :  DrCrType;
  n       :  VATType;
  i       :  Integer;
  DiscT   :  Boolean;



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


    CostLab.Caption:=FormatFloat(GenRealMask,InvNetVal-DiscAmount);

    IssuedLab.Caption:=FormatFloat(GenRealMask,DocLSplit[6]);

    DiscT:=DiscTaken;

    I5Net1F.Value:=InvNetVal;
    I5Net2F.Value:=InvNetVal;
    // MH 27/02/2015 v7.0.13 ABSEXCH-15298: Added duplicate totals for when Settlement Discount hidden
    ccyTotalsNet.Value := I5Net1F.Value;

    I5VAT1F.Value:=InvVAT;
    I5VAT2F.Value:=InvVAT;
    // MH 27/02/2015 v7.0.13 ABSEXCH-15298: Added duplicate totals for when Settlement Discount hidden
    ccyTotalsVAT.Value := I5VAT1F.Value;

    I5Disc1F.Value:=DiscAmount;
    // MH 27/02/2015 v7.0.13 ABSEXCH-15298: Added duplicate totals for when Settlement Discount hidden
    ccyTotalsDiscount.Value := I5Disc1F.Value;

    If (JBFieldOn) then
      I5Disc2F.Value:=DiscSetAm
    else
      I5Disc2F.Value:=DiscAmount+DiscSetAm;

    DiscTaken:=BOff;
    I5Tot1F.Value:=ITotal(LInv);
    // MH 27/02/2015 v7.0.13 ABSEXCH-15298: Added duplicate totals for when Settlement Discount hidden
    ccyTotalsTotal.Value := I5Tot1F.Value;

    DiscTaken:=BOn;

    I5Tot2F.Value:=ITotal(LInv);


    DiscTaken:=DiscT;


    Gauge1.Progress:=Round(DivWChk(Round_Up(DocLSplit[3]+DocLSplit[4],2),Round_Up(DocLSplit[1],2))*100);


    {$IFDEF MC_On}
      I5Tot3F.ShowCurrency:=BOn;
      I5Tot3F.CurrencySymb:=SSymb(Currency);

    {$ENDIF}

    I5Tot3F.Value:=I5Tot1F.Value;

  end; {With..}

end;




{ ======== Display Receipt Record ========== }

procedure TRetDoc.SetNTxfrFields;

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

    { CJS - 2013-10-25 - MRD2.6.13 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      A1OpoF.Hint := GetOriginatorHint(LInv)
    else
      A1OpoF.Hint := '';

    A1TPerF.InitPeriod(AcPr,AcYr,BOn,BOn);

    A1TDateF.DateValue:=TransDate;
    // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    ShowSettlementDiscountFields (TransactionHelper(@LInv).SettlementDiscountSupported);

    {I1DueDateF.DateValue:=DueDate;}


    I1AccF.Text:=CustCode;

    If Global_GetMainRec(CustF,CustCode) and ((Not JustCreated) or (LastEdit or LViewOnly)) then
    Begin
      AssignFromGlobal(CustF);

      CustToMemo(LCust,I1AddrF,0);

      // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
      SetDefaultSettlementDiscount;
    end;


    A1YRefF.Text:=YourRef;
    I1YrRef2F.Text:=Trim(TransDesc);

    {I1YrRef2F.Text:=TransDesc;}

    THUd1F.Text:=DocUser1;
    THUd2F.Text:=DocUser2;
    THUd3F.Text:=DocUser3;
    THUd4F.Text:=DocUser4;
    //GS 17/10/2011 ABSEXCH-11706: put customisation values into text boxes
    THUd5F.Text:=DocUser5;
    THUd6F.Text:=DocUser6;
    THUd7F.Text:=DocUser7;
    THUd8F.Text:=DocUser8;
    THUd9F.Text:=DocUser9;
    THUd10F.Text:=DocUser10;

    // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
    THUd11F.Text:=thUserField11;
    THUd12F.Text:=thUserField12;

    {$IFDEF MC_On}
      If (Currency>0) then
        I1CurrF.ItemIndex:=Pred(Currency);

      I1ExRateF.Value:=CXRate[BOn];

      FixXRF.Checked:=SOPKeepRate;
    {$ENDIF}

//    If (TransMode>=0) then
      I1StatCB1.ItemIndex:=TransMode;

    I5MVATF.Checked:=ManVAT;


    If (DispCust<>nil) then
    With DispCust do
    Begin
      If (CustActive) then
        I1AddrFDblClick(I1AddrF);
    end;

    I5SDPF.Value:=Pcnt2Full(DiscSetl);

    I5SDDF.Value:=DiscDays;

    I5SDTF.Checked:=(DiscTaken or (PDiscTaken and (Not InAddEdit)));

    // MH 11/03/2010: Added line to display the Control GL code - field was previously not populated when an Invoice was returned
    DMDCNomF.Text:=Form_BInt(CtrlNom,0);
    SetCtrlNomStat;

    If (Currency<>Syss.VATCurr) and (Not (Syss.VATCurr In [0,1])) then
    Begin
      If (Not I5VRateL.Visible) then
      Begin
        I5VRateL.Visible:=BOn;
        I5VRateF.Visible:=BOn;

        ScrollBox8.Height:=ScrollBox8.Height-24;
        ScrollBox8.Top:=ScrollBox8.Top+24;
        SBSPanel54.Top:=SBSPanel54.Top+24;
      end;
    end
    else
    Begin
      If (I5VRateL.Visible) then
      Begin
        I5VRateL.Visible:=BOff;
        I5VRateF.Visible:=BOff;

        ScrollBox8.Height:=ScrollBox8.Height+24;
        ScrollBox8.Top:=ScrollBox8.Top-24;
        SBSPanel54.Top:=SBSPanel54.Top-24;
      end;
    end;


  end; {With..}
end;



{ ======== Display Invoice Record ========== }

procedure TRetDoc.OutNTxfr;

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


procedure TRetDoc.Form2NTxfr;

Var
  n  :  VATType;
Begin
  With ExLocal,LInv do
  Begin
    TransDate:=A1TDateF.DateValue;
    {DueDate:=I1DueDateF.DateValue;}

    A1TPerF.InitPeriod(AcPr,AcYr,BOff,BOff);

    YourRef:=A1YRefF.Text;

    If (Syss.WarnYRef) then
      YourRef:=UpCaseStr(YourRef);

    YourRef:=LJVar(YourRef,DocYref1Len);

    TransDesc:=LJVar(I1YrRef2F.Text,DocYref2Len);


    CustCode:=I1AccF.Text;


    DocUser1:=THUd1F.Text;
    DocUser2:=THUd2F.Text;
    DocUser3:=THUd3F.Text;
    DocUser4:=THUd4F.Text;
    //GS 17/10/2011 ABSEXCH-11706:write udef field values into customisation object
    DocUser5:=THUd5F.Text;
    DocUser6:=THUd6F.Text;
    DocUser7:=THUd7F.Text;
    DocUser8:=THUd8F.Text;
    DocUser9:=THUd9F.Text;
    DocUser10:=THUd10F.Text;

    // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
    thUserField11 := THUd11F.Text;
    thUserField12 := THUd12F.Text;

    {$IFDEF MC_On}
      If (I1CurrF.ItemIndex>=0) then
        Currency:=Succ(I1CurrF.ItemIndex);

      CXRate[BOn]:=I1ExRateF.Value;

      SOPKeepRate:=FixXRF.Checked;
    {$ENDIF}

    If (I1StatCB1.ItemIndex>=0) then
      TransMode:=I1StatCB1.ItemIndex;

    // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    If I5SDPF.Visible Then
      DiscSetl := Pcnt(I5SDPF.Value)
    Else
      DiscSetl := 0.0;
    If I5SDDF.Visible Then
      DiscDays := Round(I5SDDF.Value)
    Else
      DiscDays := 0;
    If I5SDTF.Visible Then
      DiscTaken:= I5SDTF.Checked
    Else
      DiscTaken:= False;

    ManVAT:=I5MVATF.Checked;

    // MH 11/03/2010: Removed this (added by CS on 05/03/2010) as editing the Control GL is VERY bad news
    //CtrlNom := StrToIntDef(DMDCNomF.Text, 0);

    If (ManVAT) then
    Begin
      For n:=VStart to VEnd do
      Begin

        InvVATAnal[n]:=VATMatrix.IDRec(Ord(n))^.VATD.Value;

      end;
    end;

  end; {With..}
end;


Procedure TRetDoc.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      MainPage
         :  If (I1AccF.CanFocus) and (I1AccF.Visible) then
            Begin
              With I1AccF do
                If CanFocus then
                  SetFocus;
            end
              else
              With A1YRefF do
              If CanFocus then
                SetFocus;



    end; {Case&With..}

end; {Proc..}




Procedure TRetDoc.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TRetDoc.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
  end;
end;

procedure TRetDoc.HideListColumns(PageNo  :  Integer);


Begin
   With A1SBox do
      HorzScrollBar.Position:=0;


  If (Assigned(MULCtrlO)) and (PageNo<>NotePage) then
  With MULCtrlO,VisiList do
  Begin
    HidePanels(PageNo);

    ReAssignCols;

    PageUpDn(0,BOn);

    SetHedPanel(ListOfSet);


  end;


end;

procedure TRetDoc.PageControl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;

  {$IFDEF NP}
    NoteSetUp :  TNotePadSetUp;
  {$ENDIF}

begin
  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      PrimeButtons;

      If (NewIndex In [FootPage]) and (A1FPanel.Visible) then
        A1FPanel.Visible:=BOff
      else
        If (Not A1FPanel.Visible) and (Not (NewIndex In [FootPage])) then
          A1FPanel.Visible:=BOn;

      A1BtnPanel.Visible:=A1FPanel.Visible;
      
      MULCtrlO.DisplayMode:=NewIndex;

      HideListColumns(NewIndex);

      If (Not TransExtForm1.NewSetting) and (NewIndex>AnalPage) then {* Panel is open, so close it *}
        TransExtForm1.ForceClose;

      Case NewIndex of
        MainPage,
        AnalPage
           :  Begin
                A1SBox.Parent:=ActivePage;
                A1ListBtnPanel.Parent:=ActivePage;
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

                //PR: 20/12/2011 v6.9 Set handler to disable/enable note buttons for Audit History Notes
                NotesCtrl.OnSwitch := SwitchNoteButtons;

                NotesCtrl.fParentLocked:=fRecordLocked;

                NotesCtrl.Caption:=Caption+' - Notes';
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
                If (FullNomKey(LInv.FolioNum)<>NotesCtrl.GetFolio) then {* Refresh notes *}
                with NotesCtrl do
                Begin
                  RefreshList(FullNomkey(LInv.FolioNum),GetNType);
                  GetLineNo:=LInv.NLineCount;
                end;

      {$ENDIF}



      end; {Case..}


      MDI_UpdateParentStat;

    end; {With..}
end;




procedure TRetDoc.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  fFrmClosing:=BOff;
  fDoingClose:=BOff;

  ExLocal.Create;

  ForceStore:=BOff;

  LastCoord:=BOff;
  ReCalcTot:=BOn;
  NeedCUpdate:=BOff;
  BalDone:=BOff;

  Visible:=BOff;

  InvStored:=BOff;
  CouldIssue:=BOff;
  CouldBook:=BOff;

  JustCreated:=BOn;

  fRecordLocked:=BOff;

  StopPageChange:=BOff;

  fChkYourRef:=BOff;

  // SSK 11/01/2018 ABSEXCH-19614:
  FAnonymisationON := False;
  FSaveAnonPanelCord := False;

  SKeypath:=0;

  // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  SettlementDiscountPercentage := -1;
  SettlementDiscountDays := -1;

  MinHeight:=351;
  MinWidth:=630;

  InitSize.Y:=419; //376;
  InitSize.X:=636;

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

  RecordPage:=RetFormPage;
  DocHed:=RetFormMode;

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

  Set_JAPDefaultDocT(LTDescStr,0); { *EN570 }

  VATMatrix:=TVATMatrix.Create;

  FormDesign;

  FormBuildList(BOff);

end;
                                           


procedure TRetDoc.FormDestroy(Sender: TObject);

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

end;

procedure TRetDoc.FormCloseQuery(Sender: TObject;
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

        If (NeedCUpdate) then
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

        Send_UpdateList(BOff,109);

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;

end;

procedure TRetDoc.FormClose(Sender: TObject; var Action: TCloseAction);
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


  end;
end;


procedure TRetDoc.NotePageReSize;

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


procedure TRetDoc.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) and (Not fDoingClose) then
  Begin
    MULCtrlO.LinkOtherDisp:=BOff;


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


    TCNScrollBox.Width:=PageControl1.Width-PagePoint[5].X;
    TCNScrollBox.Height:=PageControl1.Height-PagePoint[5].Y;

    A1BtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    A1BtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    A1BSBox.Height:=A1BtnPanel.Height-PagePoint[3].X;

    A1ListBtnPanel.Left:=PageControl1.Width-PagePoint[4].X;
    A1ListBtnPanel.Height:={PageControl1.Height-PagePoint[4].Y;} A1SBox.Height;



    TCNListBtnPanel.Height:=PageControl1.Height-PagePoint[6].Y;

    NotePageResize;

    With A1SBox do
      A1HedPanel.Width:=HorzScrollBar.Range;


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

    //SSK 11/01/2018 2018R1 ABSEXCH-19614: set size/position of anonymisation panel on form resize
    SetAnonymisationPanel;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end; {If time to update}
end;


procedure TRetDoc.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

  If (Key=$5A) and (Shift = ([ssAlt,ssCtrl,ssShift])) and (Not ExLocal.LViewOnly) then
  Begin
    Re_SetDoc(ExLocal.LInv);
    OutNtxfr;
    MULCtrlO.PageUpDn(0,BOn);
  end;

end;

procedure TRetDoc.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Function TRetDoc.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;




procedure TRetDoc.ClsN1BtnClick(Sender: TObject);
begin
  If ConfirmQuit then
    Close;
end;

function TRetDoc.A1TPerFConvDate(Sender: TObject; const IDate: string;
  const Date2Pr: Boolean): string;
begin
  Result:=ConvInpPr(IDate,Date2Pr,@ExLocal);
end;


Function TRetDoc.ConfirmQuit  :  Boolean;

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


procedure TRetDoc.SetNTxfrStore(EnabFlag,
                                VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode or FAllowPostedEdit;

  OkN1Btn.Enabled:=Not VOMode or FAllowPostedEdit;
  CanN1Btn.Enabled:=Not VOMode or FAllowPostedEdit;

  OkI5Btn.Enabled:=Not VOMode or FAllowPostedEdit;
  CanI5Btn.Enabled:=Not VOMode or FAllowPostedEdit;


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

  {If (I4JobAnalF.Text<>'') then   EN570 need equiv?
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
    WORI1Btn.Enabled:=(DJobCode<>'') and ((Trim(CISEmpl+CustCode)<>'') or (DocHed=JPT));}

end;


Procedure TRetDoc.NoteUpdate;


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



Function TRetDoc.SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

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

procedure TRetDoc.ProcessNtxfr(Fnum,
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

  OldConTot:=0;
  
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

      RunNo:=Set_RetRunNo(InvDocHed,AutoOn,BOff);

      TransDate:=Today; AcPr:=GetLocalPr(0).CPr; AcYr:=GetLocalPr(0).CYr;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
        Date2Pr(TransDate,AcPr,AcYr,@ExLocal);

      DueDate:=CalcDueDate(TransDate,30);

      NLineCount:=1;

      ILineCount:=1;

      CustSupp:=Ret_CustSupp(InvDocHed);

      OpName:=EntryRec^.Login;

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

    end;


    SetNtxfrStore(BOn,LViewOnly);


    SetFieldFocus;

  end {If Abort..}
  else
  Begin
    SetViewOnly(BOn,ExLocal.LViewOnly);
    PrimeButtons;
  end;


end; {Proc..}



 { ====================== Function to Check ALL valid invlines (InvLTotal<>0) have a nominal =============== }

Function TRetDoc.Check_LinesOk(InvR  :  InvRec)  :  Boolean;

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

  KeyS:=FullIdKey(InvR.FolioNum,1);

  TmpKPath:=KeyPath;

  ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


  While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NomOk) do
  With Id do
  Begin
    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    ExLocal.AssignFromGlobal(IdetailF);


    NomOk:=RetLineU.CheckCompleted(Self.ExLocal.LastEdit,BOn,BOff,BOn,ExLocal,Self,IdLine);

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Result:=NomOk;
end; {Func..}

{ == Routines to execute list specific tasks, depending on which list has focus == }

Function TRetDoc.GrpValidLine(MLNo  :  Byte)  : Boolean;

Begin
  Result:=MULCtrlO.ValidLine;
end; {Func..}


Procedure TRetDoc.GrpRefreshLine(MLNo  :  Byte);
Begin
  With MULCtrlO do
    RefreshLine(MUListBoxes[0].Row,BOff);
end; {Func..}


Function TRetDoc.CheckCompleted(Edit  :  Boolean)  : Boolean;

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
  PossMsg^[5]:='';
  PossMsg^[6]:='Transaction Date is not valid.';
  PossMsg^[7]:='';
  PossMsg^[8]:='Currency is not valid.';
  PossMsg^[9]:='For local currency the exchange rate must be 1.0';
  PossMsg^[10]:='That Account is not valid';
  PossMsg^[11]:='';
  PossMsg^[12]:='';
  PossMsg^[13]:='General Ledger Code is not valid.';
  PossMsg^[14]:='';
  PossMsg^[15]:='';
  PossMsg^[16]:='';
  PossMsg^[17]:='';
  PossMsg^[18]:='';
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


      6  :  Result:=ValidDate(TransDate);


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




      19 :   Begin {* Opporty for hook to validate the header as well *}
                 {$IFDEF CU}

                   Result:=ValidExitHook(2000,82,ExLocal);
                   ShowMsg:=BOff;

                 {$ENDIF}
              end;

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}




procedure TRetDoc.StoreNtxfr(Fnum,
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

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transactions }
  Button1State: Boolean;
  Button5State: Boolean;
  CursorState: TCursor;

Begin
  KeyS:='';

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transactions }
  Button1State := OkN1Btn.Enabled;
  Button5State := OkI5Btn.Enabled;
  CursorState := Cursor;

  OkN1Btn.Enabled := False;
  OkI5Btn.Enabled := False;
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

      //Don't recalc if posted
      if not LViewOnly then
        CalcInvTotals(LInv,ExLocal,Not LInv.ManVAT,BOn);


      COk:=CheckCompleted(LastEdit);


      If (COk) then
      Begin

        Cursor:=crHourGlass;


        OpName:=EntryRec^.LogIn;

        CheckYRef(LInv);  {* To reset index on blank *}


        If (LastEdit) then
        Begin
          If (Not TransactionViewOnly) then
          Begin

            Status:=LSecure_InvPut(Fnum,KeyPAth,0);

          //PR 20/12/2011 Add audit note
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
            { CJS - 2013-10-25 - MRD2.6.13 - Transaction Originator }
            TransactionOriginator.SetOriginator(LInv);
            Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
          end
          else
            Status:=LSecure_InvPut(Fnum,KeyPAth,0);

          //PR 20/12/2011 Add audit note
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


          Check_DocChanges(LastInv,LInv);  {* Update all lines with any changes *}

          {$IFDEF DONTUSE}
            If (CouldBook) then {Prompt to issue it}
            Begin
              If (PChkAllowed_In(-255) and PChkAllowed_In(-255)) then 
                PostMessage((Owner as TForm).Handle,WM_FormCloseMsg,100,LastRecAddr[InvF]);
            end
            else
          {$ENDIF}
            If (CouldIssue) then
            Begin
              If ((PChkAllowed_In(524) and (DocHed In StkRetSalesSplit)) or  (PChkAllowed_In(538) and (DocHed In StkRetPurchSplit))) then
                PostMessage((Owner as TForm).Handle,WM_FormCloseMsg,101-Ord(CouldBook),LastRecAddr[InvF]);
            end


        end;

        If (LastEdit) or (LForcedAdd) then
        Begin
          Delete_DocEditNow(LInv.FolioNum);

          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

        end;

        SetNtxfrStore(BOff,BOff);

        { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transactions }
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

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transactions }
  finally
    Cursor := CursorState;
    OkN1Btn.Enabled := Button1State;
    OkI5Btn.Enabled := Button5State;
  end;

end;




procedure TRetDoc.EditAccount(Edit,
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




procedure TRetDoc.A1CPanelMouseUp(Sender: TObject; Button: TMouseButton;
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



procedure TRetDoc.A1CLabMouseDown(Sender: TObject; Button: TMouseButton;
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



procedure TRetDoc.A1CLabMouseMove(Sender: TObject; Shift: TShiftState;
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






procedure TRetDoc.A1CPanelClick(Sender: TObject);
Var
  n      :  Byte;
  UseRP  :  Boolean;

begin
  {$B-}
  If (Assigned(MULCtrlO)) then
  {$B+}
  Begin
    With MULCtrlO do
    Begin

      {For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        HBkColor:=aBarBkColor;
        HTextColor:=aBarTextColor;
      end;}

      If (PageKeys^[MUListBox1.Row]=0) then {* Empty line!}
      Begin
        Update_Select(0,BOff);
        RePaint_Row;
      end
      else
        If (ValidLine) then
          Set_Row(MUListBox1.Row);


    end;

    PrimeButtons;
  end;

end;

procedure TRetDoc.AddN1BtnClick(Sender: TObject);

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
              and ((GrpValidLine(0)) or ((Sender=AddN1Btn) or (Sender=Add1))) then
           Begin
             GrpRefreshLine(0);

             If (Sender=AddN1Btn) or (Sender=EditN1Btn) or (Sender=Edit1) or (Sender=Add1) or (Sender=InsN1Btn) or (Sender=Insert1) then
               Mode:=1+(1*(Ord(Sender=EditN1Btn)+Ord(Sender=Edit1)))+ (2*(Ord(Sender=InsN1Btn)+Ord(Sender=Insert1)));


             {* Transfer to record, so the line is upto date *}

             Form2Ntxfr;

             SetNewFolio;

             Display_Id(Mode,0);

           end;

  end; {Case..}

end;





procedure TRetDoc.DelN1BtnClick(Sender: TObject);
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

procedure TRetDoc.SwiN1BtnClick(Sender: TObject);
var
  ListPoint : TPoint;
begin
  {$IFDEF NP}

    If (NotesCtrl<>nil) then
    With NotesCtrl do
    Begin

      If (Not MULCtrlO.InListFind) then
      begin
//        SwitchGenMode;

        //PR: 19/10/2011 v6.9 Added submenu to handle Audit History Notes
        ListPoint.X:=1;
        ListPoint.Y:=1;

        ListPoint := SwiN1Btn.ClientToScreen(ListPoint);

        mnuSwitchNotes.Popup(ListPoint.X, ListPoint.Y);
      end;

    end;
  {$ENDIF}

end;


procedure TRetDoc.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    N3.Tag:=99;

    PopUp(X,Y);
  end;


end;

procedure TRetDoc.PopupMenu1Popup(Sender: TObject);
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


function TRetDoc.A1TPerFShowPeriod(Sender: TObject;
  const EPr: Byte): string;
begin
  Result:=PPr_Pr(EPr);
end;


procedure TRetDoc.SetNewFolio;

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

    { CJS - 2013-10-25 - MRD2.6.13 - Transaction Originator }
    TransactionOriginator.SetOriginator(LInv);
    A1OpoF.Hint := GetOriginatorHint(LInv);

        {* Force add of header now *}
    If (LSecure_Add(InvF,SKeypath,0)) then
      Add_DocEditNow(LInv.FolioNum);


    RefreshList(BOff,BOff);
  end;
end;

Function TRetDoc.LinkEmpToSupplier(Var FoundCode  :  Str20;
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


procedure TRetDoc.I4JobCodeFExit(Sender: TObject);
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


procedure TRetDoc.I1EmpFExit(Sender: TObject);

begin

end;


Procedure TRetDoc.SetCtrlNomStat;


Begin

  With ExLocal do
  If (Not LViewOnly) then
  With DMDCNomF do
  Begin
    ReadOnly:=((Text='') and (LCust.DefCtrlNom=0));

    TabStop:=Not ReadOnly;

  end;
end;

procedure TRetDoc.I1CustFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  WTrig,
  FoundOk,
  AltMod     :  Boolean;

  BalNow     :  Double;

  TempCust   :  CustRec;

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
      {$IFDEF CU} {* Call hooks here *}

        FoundCode:=TextExitHook(2000,6,FoundCode,ExLocal);

      {$ENDIF}



      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,(DocHed In StkRetSalesSplit),3));

      If (FoundOk) then
        ExLocal.AssignFromGlobal(CustF);

      {$IFDEF CU} {* Call hooks here *}

        If (FoundOk) and (Not ExLocal.LastEdit) then
        With ExLocal do
        Begin
          TempCust:=LCust;
          ExLocal.AssignFromGlobal(CustF);
          FoundOk:=ValidExitHook(2000,189,ExLocal);
          LCust:=TempCust;
        end;

      {$ENDIF}


      If (FoundOk) then
      With ExLocal,LInv do
      Begin


        StillEdit:=BOff;

        Text:=FoundCode;

        A1TDateF.DateModified:=BOn;

        A1TDateFExit(Sender);

        CustToMemo(LCust,I1AddrF,0);

        FoundOk:=Not Check_AccForCredit(LCust,0,OldConTot,BOn,BOn,WTrig,Self);


        // MH 11/03/2010: Modified to set Ctrl NOM in record directly as the edit field isn't processed on store
        CtrlNom := LCust.DefCtrlNom;
        DMDCNomF.Text:=Form_BInt(CtrlNom,0);

        (*
        If (LCust.DefSetDisc<>0) or (LCust.DefSetDDays<>0) then
        Begin
          I5SDPF.Value:=LCust.DefSetDisc;


          I5SDDF.Value:=LCust.DefSetDDays;
        end
        else
        Begin
          I5SDPF.Value:=Syss.SettleDisc;
          I5SDDF.Value:=Syss.SettleDays;
        end;
        *)

        // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
        SetDefaultSettlementDiscount;
        If TransactionHelper(@ExLocal.LInv).SettlementDiscountSupported Then
        Begin
          I5SDPF.Value := SettlementDiscountPercentage;
          I5SDDF.Value := SettlementDiscountDays;
        End // If TransactionHelper(@ExLocal.LInv).SettlementDiscountSupported
        Else
        Begin
          I5SDPF.Value := 0.0;
          I5SDDF.Value := 0;
        End; // Else

        {$IFDEF SOP}
          If (InvDocHed In OrderSet) and (LCust.DefTagNo>0) then
            Tagged:=LCust.DefTagNo;

        {$ENDIF}



        SetCtrlNomStat;

        {$IFDEF MC_On}

          If (Not I1CurrF.ReadOnly) then
          Begin
            Currency:=LCust.Currency;

            If (Currency>0) then
              I1CurrF.ItemIndex:=Pred(Currency);

            I1CurrF.Modified:=BOn;
            I1CurrFExit(Sender);
          end;

        {$ENDIF}


        {$IFDEF CU} {* Call Delivery address hook here. v5.61. Hook also allows write to job & anal code *}

          GenHooks(2000,9,ExLocal);

        {$ENDIF}

        {$IFDEF PF_On}

          If (Not EmptyKey(OrigValue,CustKeyLen)) and ((ExLocal.LastEdit) or (ForceStore)) then {* Re_calc discounts *}
          Begin

            {$IFDEF STK}

              //Re_CalcDocPrice(10,LInv);

            {$ENDIF}

            If (LInv.DiscSetl<>Pcnt(I5SDPF.Value)) then {Work out new Settlement VAT}
              ReApplyVAT(I5SDPF.Value);

            If (LastEdit) then
              ForceStore:=(LInv.InvNetVal<>LastInv.InvNetVal);

            MULCtrlO.PageUpDn(0,BOn);

            OutNTxfrTotals;

          end;

        {$ENDIF}


        SendToObjectCC(FoundCode,0);

      end
      else
      Begin
        If (CanFocus) then
          SetFocus;
      end; {If not found..}
    end;

    {$IFDEF CU} {* Call notification hook regardless of edit state *}

      GenHooks(2000,101,ExLocal);

    {$ENDIF}

  end; {with..}
end;


procedure TRetDoc.I1AccFExit(Sender: TObject);


begin
  Inherited;
    I1CustFExit(Sender);
end;


procedure TRetDoc.THUD1FEntHookEvent(Sender: TObject);
Var
  CUUDEvent  :  Byte;
  Result     :  LongInt;

begin
  CUUDEvent  := 0;
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
                //GS 17/10/2011 ABSEXCH-11706: create branches for the new UDFs
                //there is a 60 offset; event values are adjucted accordingly
                else
                  If (Sender=THUD5F) then
                  Begin
                    ExLocal.LInv.DocUser5:=Text;
                    CUUDEvent:=(211 - 60);
                  end
                  else
                    If (Sender=THUD6F) then
                    Begin
                      ExLocal.LInv.DocUser6:=Text;
                      CUUDEvent:=(212 - 60);
                    end
                    else
                      If (Sender=THUD7F) then
                      Begin
                        ExLocal.LInv.DocUser7:=Text;
                        CUUDEvent:=(213 - 60);
                      end
                      else
                        If (Sender=THUD8F) then
                        Begin
                          ExLocal.LInv.DocUser8:=Text;
                          CUUDEvent:=(214 - 60);
                        end
                        else
                          If (Sender=THUD9F) then
                          Begin
                            ExLocal.LInv.DocUser9:=Text;
                            CUUDEvent:=(215 - 60);
                          end
                          else
                            If (Sender=THUD10F) then
                            Begin
                              ExLocal.LInv.DocUser10:=Text;
                              CUUDEvent:=(216 - 60);
                            end
                            else
                              // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
                              If (Sender=THUD11F) then
                              Begin
                                ExLocal.LInv.thUserField11:=Text;
                                CUUDEvent:=(217 - 60);
                              end
                              else
                                If (Sender=THUD12F) then
                                Begin
                                  ExLocal.LInv.thUserField12:=Text;
                                  CUUDEvent:=(218 - 60);
                                end
                                else
                                  If (Sender=A1YRefF) then
                                  Begin
                                    ExLocal.LInv.YourRef:=Text;
                                    CUUDEvent:=120;
                                  end
                                  else
                                    If (Sender=I1YrRef2F) then
                                    Begin
                                      ExLocal.LInv.TransDesc:=Text;
                                      CUUDEvent:=121;
                                    end;


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
              //GS 17/10/2011 ABSEXCH-11706: put customisation object vals into UDFs
              (211 - 60) :  Text:=LInv.DocUser5;
              (212 - 60) :  Text:=LInv.DocUser6;
              (213 - 60) :  Text:=LInv.DocUser7;
              (214 - 60) :  Text:=LInv.DocUser8;
              (215 - 60) :  Text:=LInv.DocUser9;
              (216 - 60) :  Text:=LInv.DocUser10;
              // MH 25/05/2016 Exch2016-R2: Add new TH User Defined Fields
              (217 - 60) :  Text:=LInv.thUserField11;
              (218 - 60) :  Text:=LInv.thUserField12;
              120  :  Text:=LInv.YourRef;
              121  :  Text:=LInv.TransDesc;

            end; {Case..}
          end;
        end;
     end; {With..}

  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;


procedure TRetDoc.THUD1FExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

begin
  If (Sender is Text8pt)  then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    Modified:=BOff;  FoundOk:=BOn;

    FoundCode:=Strip('B',[#32],Text);

    If (ActiveControl<>ClsN1Btn) and (ActiveControl<>CanN1Btn)  then
    Begin
      If ((AltMod) and (FoundCode<>'')) and (Syss.WarnYRef) then
      Begin

        FoundOk:=(Not Check4DupliYRef(LJVar(FoundCode,DocYref1Len),FullCustCode(I1AccF.Text),InvF,InvYrRefK,ExLocal.LInv,'Reference ('+FoundCode+') for this account'));

      end;


      If (FoundOk) then
        Text8pt(Sender).ExecuteHookMsg;

      fChkYourRef:=BOff;

    end;
  end; {With..}

end;



procedure TRetDoc.OkN1BtnClick(Sender: TObject);
begin

  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult = mrOk) Then
      Begin
        // MH 15/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
        //                                   fields which processes the text and updates the value
        If (ActiveControl <> OkN1Btn) And OkN1Btn.CanFocus Then
          // Move focus to OK button to force any OnExit validation to occur
          OkN1Btn.SetFocus
        Else
          // Different OK button on Footer tab!
          If (ActiveControl <> OkI5Btn) And OkI5Btn.CanFocus Then
            OkI5Btn.SetFocus;

        // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
        If (ActiveControl = OkN1Btn) Or (ActiveControl = OkI5Btn) Then
          StoreNtxfr(InvF,SKeypath)
      End // If (ModalResult = mrOk)
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




procedure TRetDoc.Display_Id(Mode,TBMode  :  Byte);


Begin

  If (IdLine=nil) then
  Begin

    IdLine:=TRetLine.Create(Self);

  end;

  Try

   if FAllowPostedEdit then
     IdLine.EnableEditPostedFields;

   With IdLine do
   Begin

     WindowState:=wsNormal;
     {Show;}


     InvBtnList.SetEnabBtn(BOff);



     If (Mode In [1..3]) then
     Begin

       Case Mode of

         1..3  :   If (Not ExLocal.InAddEdit) then
                     EditLine(Self.ExLocal.LInv,(Mode=2),(Mode=3),Self.ExLocal.LViewOnly,(Current_Page=1))
                   else
                     Show;


       end; {Case..}

     end
     else
       If (Not ExLocal.InAddEdit) then
         ShowLink(Self.ExLocal.LInv,Self.ExLocal.LViewOnly);



   end; {With..}

   IdLineActive:=BOn;


  except

   IdLineActive:=BOff;

   IdLine.Free;

   InvBtnList.SetEnabBtn(BOn);

  end;


end;



procedure TRetDoc.DeleteNTLine;

Var
  MbRet  :  Word;
  KeyS   :  Str255;

  UseFolio
         :  LongInt;

  FoundCode
         :  Str20;

  IdR    :  Idetail;


Begin
  {$IFDEF CU}
    ExLocal.AssignFromGlobal(IdetailF);

    {$B-}
    If (MULCtrlO.ValidLine) and (MULCtrlO.Ok2Del) and (ValidExitHook(4000,80,ExLocal)) then
    {$B+}
 {$ENDIF}
  With ExLocal do
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
          Try
            {$IFDEF CU}
              If (ValidExitHook(4000,81,ExLocal)) then;
            {$ENDIF}


          finally

            ForceStore:=BOn;

            RefreshLine(MUListBoxes[0].Row,BOff);

            Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,ScanFileNum,BOn,GlobLocked);

            AssignFromGlobal(IdetailF);

            If (Ok) and (GlobLocked) then
            With LId do
            Begin
              IdR:=LId;

              If (Not EmptyKey(StockCode,StkKeyLen)) then {* Delete any assoc lines *}
              Begin


                If (Stock.StockCode<>StockCode) then
                  GetStock(Self,StockCode,Foundcode,-1);

                UseFolio:=Stock.StockFolio;


              end
              else
                UseFolio:=FolioRef;


              Delete_Kit(UseFolio,0,LInv);


              Status:=Delete_Rec(F[ScanFileNum],ScanFilenum,KeyPath);

              Report_BError(ScanFileNum,Status);
            end;

            If (StatusOk) then
            Begin
              Deduct_ADJStk(IdR,LInv,BOff);

              CalcInvVATTotals(LInv,ExLocal,Not LInv.ManVAT);

              {$IFDEF SOP}

                Self.Enabled:=BOff;

                Control_SNos(IdR,LInv,Stock,3+(20*Ord(LId.IdDocHed in StkRetSalesSplit)),Self);

                If (LId.IdDocHed In StkRetSalesSplit) then
                  Control_SNos(IdR,LInv,Stock,33,Self);


                Self.Enabled:=BOn;
                Self.Show;

              {$ENDIF}

              With MULCtrlO do
              Begin
                If (MUListBox1.Row<>0) then
                  PageUpDn(0,BOn)
                else
                  InitPage;
              end;

              OutNTxfrTotals;
            end;
          end; {try..}
        end;
      end;
    end; {If line is valid for deletion..}
  end;
end; {PRoc..}


procedure TRetDoc.A1TDateFExit(Sender: TObject);
Var
  TransactionHelperIntf : ITransactionHelper_Interface;
  SettlementDiscountEligibilityChanged : Boolean;
begin
  TransactionHelperIntf := TransactionHelper(@ExLocal.LInv);
  Try
    With ExLocal, LInv, A1TDateF do
      If ValidDate(DateValue) Then
      Begin
        // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Check to see if the eligibility has changed
        SettlementDiscountEligibilityChanged := SettlementDiscountSupportedForDate (LInv.TransDate) <> SettlementDiscountSupportedForDate (A1TDateF.DateValue);

        TransDate := DateValue;

        If (Not LastEdit) And Syss.AutoPrCalc Then
        Begin
          {* Set Pr from input date *}
          Date2Pr(TransDate, AcPr, AcYr, @ExLocal);
          A1TPerF.InitPeriod(AcPr, AcYr, BOn, BOn);
        End; // If (Not LastEdit) And Syss.AutoPrCalc

        // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
        If SettlementDiscountEligibilityChanged Then
        Begin
          ShowSettlementDiscountFields (TransactionHelperIntf.SettlementDiscountSupported);
          If TransactionHelperIntf.SettlementDiscountSupported Then
          Begin
            // Re-instate the default settlement discount (REv said so!)
            I5SDPF.Value := SettlementDiscountPercentage;
            I5SDDF.Value := SettlementDiscountDays;
            ReApplyVAT(I5SDPF.Value)
          End // If TransactionHelperIntf.SettlementDiscountSupported
          Else
            ReApplyVAT(0.0);
          OutNTxfrTotals;

          // MH 20/05/2015 v7.0.14 ABSEXCH-16441: Only force store on Edits, on adds it causes the
          //                                      OurRef/Folio to not be incremented unless transaction
          //                                      lines are added
          If ExLocal.LastEdit Then
            ForceStore := True;
        End; // If SettlementDiscountEligibilityChanged
      end;
  Finally
    TransactionHelperIntf := NIL;
  End; // Try..Finally
end;


procedure TRetDoc.SetFieldProperties;

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


procedure TRetDoc.SetFormProperties(SetList  :  Boolean);

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

        If (BeenChange) and (not ResetDefaults) then
        Begin

          If (SetList) then
          Begin
            For n:=1 to 3 do
              With TmpPanel[n] do
                Case n of
                  1,2  :  Begin
                            MULCtrlO.ReColorCol(Font,Color,(n=2));
                          end;

                  3    :  Begin
                            MULCtrlO.ReColorBar(Font,Color);
                          end;
                end; {Case..}

            MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
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


procedure TRetDoc.PropFlgClick(Sender: TObject);
begin
  SetFormProperties((N3.Tag=99));
  N3.Tag:=0;
end;



procedure TRetDoc.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;






procedure TRetDoc.LnkN1BtnClick(Sender: TObject);
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



procedure TRetDoc.ChkBtnClick(Sender: TObject);
Var
  ThisTotal,
  LastTotal  :  Double;

begin
  With ExLocal,LInv do
  Begin
    SetBtnDisable(BOff);

    LastTotal:=ITotal(LInv);

    CalcInvVATTotals(LInv,ExLocal,Not LInv.ManVAT);

    ThisTotal:=ITotal(LInv);

    ForceStore:=(ForceStore or (LastTotal<>ThisTotal));



  OutNTxfrTotals;

  SetBtnDisable(BOn);
  end; {With..}
end;


procedure TRetDoc.WORI1BtnClick(Sender: TObject);
Var
  RETRef  :  Str10;
  mbRet   :  Word;

begin
  If (MULCtrlO<>nil) then
  With MULCtrlO do
  If (ValidLine) then
  With ExLocal,Id do
  Begin
    If (Stock.StockCode<>StockCode) then
      If (Not Global_GetMainRec(StockF,StockCode)) then
        ResetRec(StockF);

    If (CheckExsiting_RET(LInv,Id,RETRef,BOn)) then
    Begin
      mbRet:=CustomDlg(Application.MainForm,'Please note','Return Exists',
                              'Return '+RETRef+' already exists for this line.'+#13+#13+
                              'Please confirm you want to create another Return for this line.',mtConfirmation,[mbOk,mbCancel]);
    end
    else
      mbRet:=mrOk;

    If (mbRet=mrOk) then
      Gen_RetDocWiz(LInv,Id,10,Self);
  end;

end;


procedure TRetDoc.FindN1BtnClick(Sender: TObject);
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




procedure TRetDoc.I5MVATFClick(Sender: TObject);
begin
  ExLocal.LInv.ManVAT:=I5MVATF.Checked;

  If (Not I5MVATF.Checked) then {* Force a re calc *}
  With ExLocal do
  Begin
    If (ForceStore) or (LastEdit) then
      CalcInvVATTotals(LInv,ExLocal,Not LInv.ManVAT);

    OutNTxfrTotals;
  end;

end;

procedure TRetDoc.I5VV1FExit(Sender: TObject);
begin
  VATMatrix.Update_Rate(Sender,ExLocal.LInv);
  OutNTxfrTotals;
end;

procedure TRetDoc.I1CurrFExit(Sender: TObject);
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

procedure TRetDoc.I1EXRateFEnter(Sender: TObject);
begin
  {$IFDEF CU} {* Call hooks here *}

    If (Not I1EXRateF.ReadOnly) and (Sender=I1EXRateF) and (I1CurrF.ItemIndex>=1) then
    Begin
      I1EXRateF.Value:=ValueExitHook(2000,7,I1EXRateF.Value,ExLocal);
    end;

  {$ENDIF}

end;


procedure TRetDoc.I1AddrFDblClick(Sender: TObject);
begin
  With I1AccF do
   If (CheckKey(FullCustCode(Text),ExLocal.LCust.CustCode,CustKeyLen,BOff)) then
  Begin {* Check we are not being called from inside customer ledger! *}
    If (Not MatchOwner('CustRec3',Self.Owner)) then
    Begin

      If (DispCust=nil) then
        DispCust:=TFCustDisplay.Create(Self);

      try

        ExLocal.AssignToGlobal(CustF);

        With DispCust do
          Display_Account(IsACust(ExLocal.LCust.CustSupp),0,ExLocal.LInv);

      except

        DispCust.Free;
        DispCust:=nil;
      end;
    end
    else  {* We are being called via custrec3, hence double click should inform custrec *}
    Begin
      Send_UpdateList(BOff,10);
    end;
  end
  else
    I1AccFExit(I1AccF);


end;

procedure TRetDoc.A1TPerFExit(Sender: TObject);
begin
  If (Not A1TPerF.ReadOnly) and (A1TPerF.Modified) then
  Begin
    Form2NTxfr;

    With ExLocal,LInv do
    Begin
      {$IFDEF CU} {* Call any pre store hooks here *}

        GenHooks(2000,8,ExLocal);

        OutNTxfr;

      {$ENDIF}
    end;
  end;

end;

procedure TRetDoc.A1YRefFEnter(Sender: TObject);
begin
  {$IFDEF CU}
    If (Not A1YRefF.ReadOnly) and (Sender=A1YRefF) then
    Begin
      A1YRefF.Text:=TextExitHook(2000,65,A1YRefF.Text,ExLocal);
      fChkYourRef:=Syss.WarnYRef;
    end;
  {$ENDIF}


end;

procedure TRetDoc.TransExtForm1Exit(Sender: TObject);
begin
  If (fChkYourRef) and (ExLocal.LastEdit) and (FullCustCode(A1YRefF.Text)=FullCustCode(Exlocal.LAstInv.YourRef)) then
    fChkYourRef:=BOff;

end;

procedure TRetDoc.TransExtForm1Enter(Sender: TObject);
begin
  {$IFDEF CU}
    If (Not A1YRefF.ReadOnly) and (Sender=A1YRefF) then
    Begin
      A1YRefF.Text:=TextExitHook(2000,65,A1YRefF.Text,ExLocal);
      fChkYourRef:=Syss.WarnYRef;
    end;
  {$ENDIF}


end;

procedure TRetDoc.I1YrRef2FEnter(Sender: TObject);
begin
  {$IFDEF CU}
    If (Not I1YrRef2F.ReadOnly) and (Sender=I1YrRef2F) then
    Begin
      I1YrRef2F.Text:=TextExitHook(2000,66,I1YrRef2F.Text,ExLocal);
    end;
  {$ENDIF}

end;

procedure TRetDoc.I1DelBtnClick(Sender: TObject);
Var
  mrResult  :  Word;

begin
  With ExLocal,LInv do
  Begin
    DelACtrl:=TDelAddrPop.Create(Self);

    try

      With DelACtrl do
      Begin
        PopAddr:=DAddr;
        { CJS 2013-08-07 - MRD2.5 - Delivery PostCode }
        PostCode := thDeliveryPostCode;
        // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
        Country := thDeliveryCountry;


        With I1AccF do
          mrResult:=InitDelAddr(LViewOnly,Color,Font);

        If (mrResult=mrOk) then
        begin
          DAddr:=POPAddr;
          { CJS 2013-08-07 - MRD2.5 - Delivery PostCode }
          thDeliveryPostCode := PostCode;
          // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
          thDeliveryCountry := Country;
        end;

      end;
    finally

      DelACtrl.Free;

    end; {Try..}

  end; {with..}

end;

procedure TRetDoc.ReApplyVAT(Value  :  Real);
Begin
  With ExLocal,LInv do
  Begin
    DiscSetl:=Pcnt(Value);

    Re_CalcManualVAT(LInv,ExLocal,DiscSetl);

    RefreshFooter(0);

  end;


end;


procedure TRetDoc.I5SDPFExit(Sender: TObject);
begin
  If (Sender is TCurrencyEdit) then
  With TCurrencyEdit(Sender) do
  Begin
    If (FloatModified) then
    With ExLocal,LInv do
    Begin
      ReApplyVAT(Value);

    end;
  end;

end;

procedure TRetDoc.AP1Click(Sender: TObject);
begin
  With ExLocal do
  With TMenuItem(Sender) do
  Begin
    RetAuto_PickQty(LInv,Tag,CouldIssue,CouldBook,Self);

    If (Assigned(MULCtrlO)) then
      MULCtrlO.PageUpDn(0,BOn);

  end;
end;

procedure TRetDoc.APickI1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  GetCursorPos(ListPoint);
  With ListPoint do
  Begin
    X:=X-50;
    Y:=Y-15;
  end;

  PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
end;

// MHYR 25/10/07
procedure TRetDoc.A1YRefFChange(Sender: TObject);
begin
  A1YRefF.Hint := A1YRefF.Text;
end;

// MHYR 25/10/07
procedure TRetDoc.TransExtForm1Resize(Sender: TObject);
begin
  If (TransExtForm1.Height = TransExtForm1.ExpandedHeight) And (TransExtForm1.Width = TransExtForm1.ExpandedWidth) Then
    A1YRefF.Width := 235
  Else
    A1YRefF.Width := 90
end;

// MHYR 25/10/07
procedure TRetDoc.I1YrRef2FChange(Sender: TObject);
begin
  I1YrRef2F.Hint := I1YrRef2F.Text;
end;

procedure TRetDoc.I1StatCB1Enter(Sender: TObject);
begin
  // MH 16/12/2010 v6.6: Added bring to front call as the weirdo drop down thingie always
  //                     brings itself to the front so this combo was going behind it when
  //                     it automatically widened itself.
  PostMessage(Self.Handle, WM_CustGetRec, 65536, 0);
end;

procedure TRetDoc.I1StatCB1DropDown(Sender: TObject);
begin
  // MH 16/12/2010 v6.6: Added bring to front call as the weirdo drop down thingie always
  //                     brings itself to the front so this combo was going behind it when
  //                     it automatically widened itself.
  PostMessage(Self.Handle, WM_CustGetRec, 65536, 0);
end;

procedure TRetDoc.General1Click(Sender: TObject);
begin
  If (NotesCtrl<>nil) then
    NotesCtrl.SwitchNoteMode(nmGeneral);
end;

procedure TRetDoc.Dated1Click(Sender: TObject);
begin
  If (NotesCtrl<>nil) then
    NotesCtrl.SwitchNoteMode(nmDated);
end;

procedure TRetDoc.AuditHistory1Click(Sender: TObject);
begin
  If (NotesCtrl<>nil) then
    NotesCtrl.SwitchNoteMode(nmAudit);
end;

procedure TRetDoc.SwitchNoteButtons(Sender: TObject; NewMode: TNoteMode);
begin
  AddN1Btn.Enabled := NewMode <> nmAudit;
  EditN1Btn.Enabled := NewMode <> nmAudit;
  InsN1Btn.Enabled := NewMode <> nmAudit;
  DelN1Btn.Enabled := NewMode <> nmAudit;
end;

//-------------------------------------------------------------------------

// MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
procedure TRetDoc.SetDefaultSettlementDiscount;
Begin // SetDefaultSettlementDiscount
  If (ExLocal.LCust.DefSetDisc<>0) or (ExLocal.LCust.DefSetDDays<>0) then
  Begin
    SettlementDiscountPercentage := ExLocal.LCust.DefSetDisc;
    SettlementDiscountDays := ExLocal.LCust.DefSetDDays;
  End // If (ExLocal.LCust.DefSetDisc<>0) or (ExLocal.LCust.DefSetDDays<>0)
  Else
  Begin
    // MH 20/05/2015 v7.0.14 ABSEXCH-16284: Removed reference to obsolete fields
    // SettlementDiscountPercentage := Syss.SettleDisc;
    SettlementDiscountPercentage := 0.0;
    // SettlementDiscountDays := Syss.SettleDays;
    SettlementDiscountDays := 0;
  End; // Else
End; // SetDefaultSettlementDiscount

//------------------------------

// MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
Procedure TRetDoc.ShowSettlementDiscountFields (Const ShowFields : Boolean);
Begin // ShowSettlementDiscountFields
  // Settlement Discount Frame
  SBSPanel55.Visible := ShowFields;

  // Settlement Discount / Days / Taken -----------------------
  Label5.Visible := ShowFields;
  I5SDPF.Visible := ShowFields;
  Label6.Visible := ShowFields;
  I5SDDF.Visible := ShowFields;
  I5SDTF.Visible := ShowFields;

  // Settlement Discount Not Taken ----------------------------
  SBSPanel62.Visible := ShowFields;
  Label4.Visible := ShowFields;
  I5Net1F.Visible := ShowFields;
  Label14.Visible := ShowFields;
  I5VAT1F.Visible := ShowFields;
  Label15.Visible := ShowFields;
  I5Disc1F.Visible := ShowFields;
  Label16.Visible := ShowFields;
  I5Tot1F.Visible := ShowFields;

  // Settlement Discount Taken --------------------------------
  SBSPanel63.Visible := ShowFields;
  Label17.Visible := ShowFields;
  I5Net2F.Visible := ShowFields;
  Label18.Visible := ShowFields;
  I5VAT2F.Visible := ShowFields;
  Label19.Visible := ShowFields;
  I5Disc2F.Visible := ShowFields;
  Label20.Visible := ShowFields;
  I5Tot2F.Visible := ShowFields;

  // MH 27/02/2015 v7.0.13 ABSEXCH-15298: Added duplicate totals for when Settlement Discount hidden
  // Alternate Totals
  panFooterTotals.Visible := Not ShowFields;
  lblTotalsNet.Visible := panFooterTotals.Visible;
  ccyTotalsNet.Visible := panFooterTotals.Visible;
  lblTotalsVAT.Visible := panFooterTotals.Visible;
  ccyTotalsVAT.Visible := panFooterTotals.Visible;
  lblTotalsDiscount.Visible := panFooterTotals.Visible;
  ccyTotalsDiscount.Visible := panFooterTotals.Visible;
  lblTotalsTotal.Visible := panFooterTotals.Visible;
  ccyTotalsTotal.Visible := panFooterTotals.Visible;
End; // ShowSettlementDiscountFields

//-------------------------------------------------------------------------

procedure TRetDoc.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;
  //YourRef & AltRef
  A1YRefF.AllowPostedEdit := True;
  I1YrRef2F.AllowPostedEdit := True;
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
  THUD11F.AllowPostedEdit := True;
  THUD12F.AllowPostedEdit := True;

  ClsN1Btn.Visible := False;
  ClsN1Btn.Enabled := False;
  OkN1Btn.Top := CanN1Btn.Top + 6;
  CanN1Btn.Top := ClsN1Btn.Top + 6;
end;

function TRetDoc.TransactionViewOnly: Boolean;
begin
  Result := ExLocal.LViewOnly and not FAllowPostedEdit;
end;
//SSK 11/01/2018 2018R1 ABSEXCH-19614: Implements anonymisation behaviour for SRN/PRN
procedure TRetDoc.SetAnonymisationON(AValue: Boolean);
begin
  FAnonymisationON := AValue;
  SetAnonymisationBanner;
end;

procedure TRetDoc.SetAnonymisationBanner;
var
  lAnonymised: Boolean;
begin
  if FAnonymisationON then
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
    lblAnonStatus.Caption := Format(capAnonymisedStatus, [POutDate(ExLocal.LInv.thAnonymisedDate)]); //update the anonymisation Date
    SetAnonymisationPanel;
  end;

  Self.ClientHeight := InitSize.Y;
  FormResize(nil);
end;

procedure TRetDoc.SetAnonymisationPanel;
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



Initialization

end.

