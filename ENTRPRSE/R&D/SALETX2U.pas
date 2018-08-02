unit SaleTx2U;

interface

{$I DEFOVR.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Math,
  StrUtils, ExtCtrls, SBSPanel, ComCtrls, StdCtrls, TEditVal, Mask, BorBtns,
  Buttons, GlobVar, VarConst, ExWrap1U, BTSupU1, SupListU, SBSComp, SBSComp2,
  SalTxl1U, DelAddU, IntStatU, AutoTxU, TxLineU,
  {$IFDEF NP}
  NoteU,
  {$ENDIF}
  {$IFDEF RT_On}
  PayLineU,
  {$ENDIF}
  {$IFDEF Ltr}
  Letters,
  {$ENDIF}
  {$IFDEF SOP}
  TTD,
  {$ENDIF}
  ExtGetU,
  EntWindowSettings,
  Menus,
  bkgroup,
  AccelLbl,
  {$IFDEF CU}
  // 24/01/2013 PKR ABSEXCH-13449
  CustomBtnHandler,
  {$ENDIF}
  TCustom;

type
  // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  EnumSetDiscSavedPositions = (SetDiscOriginalFrameWidth = 1,
                               SetDiscOriginalFrameHeight = 2,
                               SetDiscOriginalFieldLeft = 3,
                               SetDiscOriginalLabelWidth = 4);

  //------------------------------

  { Transaction Header list }
  TTransMList = Class(TDDMList)
  Public
    DayBkListMode : Byte;
    Rnum          : Double;
    Rnum2         : Double;
    Function SetCheckKey: Str255; Override;
    Function SetFilter: Str255; Override;
    {$IFDEF STK}
    Function DelSOP_Link(IdR: IDetail): Boolean;
    {$ENDIF}
    Function Ok2Del: Boolean; Override;
    Function OutLine(Col: Byte): Str255; Override;
  end;

  { Sales/Purchases Transaction Header form }
  TSalesTBody = class(TForm)
    PageControl1: TPageControl;
    MainPage: TTabSheet;
    I1SBox: TScrollBox;
    I1QtyPanel: TSBSPanel;
    I1StkCodePanel: TSBSPanel;
    I1DescPanel: TSBSPanel;
    I1LTotPanel: TSBSPanel;
    I1UPricePanel: TSBSPanel;
    I1VATPanel: TSBSPanel;
    I1HedPanel: TSBSPanel;
    I1SCodeLab: TSBSPanel;
    I1QtyLab: TSBSPanel;
    I1UPLab: TSBSPanel;
    I1DiscLab: TSBSPanel;
    I1VATLab: TSBSPanel;
    I1DescLab: TSBSPanel;
    I1ListBtnPanel: TSBSPanel;
    I1DiscPanel: TSBSPanel;
    I1LTotLab: TSBSPanel;
    AnalPage: TTabSheet;
    I2SBox: TScrollBox;
    I2LocnPanel: TSBSPanel;
    I2StkCodePanel: TSBSPanel;
    I2DelDatePanel: TSBSPanel;
    I2NomPanel: TSBSPanel;
    I2CCPanel: TSBSPanel;
    I2HedPanel: TSBSPanel;
    I2SCodeLab: TSBSPanel;
    I2LocnLab: TSBSPanel;
    I2NomLab: TSBSPanel;
    I2MargLab: TSBSPanel;
    I2DelLab: TSBSPanel;
    I2CCLab: TSBSPanel;
    I2NetValPanel: TSBSPanel;
    I2DepPanel: TSBSPanel;
    I2DepLab: TSBSPanel;
    I2CostPanel: TSBSPanel;
    I2NValLab: TSBSPanel;
    I2CostLab: TSBSPanel;
    I2MargPanel: TSBSPanel;
    I2GPLab: TSBSPanel;
    I2GPPanel: TSBSPanel;
    QtyPPage: TTabSheet;
    I3SBox: TScrollBox;
    I3StkDPanel: TSBSPanel;
    I3HedPanel: TSBSPanel;
    I3StkDLab: TSBSPanel;
    I3QOrdPanel: TSBSPanel;
    I3QDelPanel: TSBSPanel;
    I3QWOPanel: TSBSPanel;
    I3QOSPanel: TSBSPanel;
    I3QPKPanel: TSBSPanel;
    I3QTWPanel: TSBSPanel;
    I3QOrdLab: TSBSPanel;
    I3DelLab: TSBSPanel;
    I3QWOLab: TSBSPanel;
    I3QOSLab: TSBSPanel;
    I3QPKLab: TSBSPanel;
    I3QTWLab: TSBSPanel;
    JobPage: TTabSheet;
    I4SBox: TScrollBox;
    I4JCPanel: TSBSPanel;
    I4StkDPanel: TSBSPanel;
    I4LTotPanel: TSBSPanel;
    I4HedPanel: TSBSPanel;
    I4StkDLab: TSBSPanel;
    I4JCLab: TSBSPanel;
    I4LtotLab: TSBSPanel;
    I4JAPanel: TSBSPanel;
    I4JALab: TSBSPanel;
    I4StkCPanel: TSBSPanel;
    I4StkCLab: TSBSPanel;
    Label829: Label8;
    FootPage: TTabSheet;
    pnlTaxRates: TSBSPanel;
    I1BtnPanel: TSBSPanel;
    I1BSBox: TScrollBox;
    EditI1Btn: TButton;
    DelI1Btn: TButton;
    InsI1Btn: TButton;
    MatI1Btn: TButton;
    AddI1Btn: TButton;
    FindI1Btn: TButton;
    APickI1Btn: TButton;
    BkOrdI1Btn: TButton;
    PayPage: TTabSheet;
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
    RCSBox: TScrollBox;
    RcHedPanel: TSBSPanel;
    RcNLab: TSBSPanel;
    RcBLab: TSBSPanel;
    RcDLab: TSBSPanel;
    RcPLab: TSBSPanel;
    RcQLab: TSBSPanel;
    RcRLab: TSBSPanel;
    RcPPanel: TSBSPanel;
    RcNPanel: TSBSPanel;
    RCDPanel: TSBSPanel;
    RcBPanel: TSBSPanel;
    RcQPanel: TSBSPanel;
    RcRPanel: TSBSPanel;
    RcListBtnPanel: TSBSPanel;
    I1FPanel: TSBSPanel;
    Label84: Label8;
    I1CurrLab: Label8;
    lblAcCode: Label8;
    I1ExLab: Label8;
    Label88: Label8;
    Label817: Label8;
    I1DelBtn: TSpeedButton;
    I1DueDateL: Label8;
    I1OurRefF: Text8Pt;
    I1OpoF: Text8Pt;
    I1AccF: Text8Pt;
    I1TransDateF: TEditDate;
    I1DueDateF: TEditDate;
    I1EXRateF: TCurrencyEdit;
    I1PrYrF: TEditPeriod;
    I1CurrF: TSBSComboBox;
    I1ItemPanel: TSBSPanel;
    I1ItemLab: TSBSPanel;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Find1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    Insert1: TMenuItem;
    BackOrders1: TMenuItem;
    AutoPick1: TMenuItem;
    Switch1: TMenuItem;
    SwiI1Btn: TButton;
    I1BtmPanel: TSBSPanel;
    Label813: Label8;
    I1CCLab: Label8;
    I1DepLab: Label8;
    I1LocnLab: Label8;
    Label819: Label8;
    I1VATTLab: Label8;
    Label821: Label8;
    I1NomCodeF: Text8Pt;
    I1CCF: Text8Pt;
    I1DepF: Text8Pt;
    I1LocnF: Text8Pt;
    INetTotF: TCurrencyEdit;
    IVATTotF: TCurrencyEdit;
    IGTotF: TCurrencyEdit;
    I2BtmPanel: TSBSPanel;
    I2StkDescLab: Label8;
    I2QtyLab: Label8;
    I2StkDescF: Text8Pt;
    I2QtyF: TCurrencyEdit;
    Label833: Label8;
    I1MargLab: Label8;
    I1GPLab: Label8;
    I3BtmPanel: TSBSPanel;
    I3StkCodeLab: Label8;
    I3CCLab: Label8;
    I3DepLab: Label8;
    I3LocnLab: Label8;
    Label826: Label8;
    I2VATTLab: Label8;
    Label828: Label8;
    I3StkCodeF: Text8Pt;
    I3CCF: Text8Pt;
    I3DepF: Text8Pt;
    I3LocnF: Text8Pt;
    I4BtmPanel: TSBSPanel;
    Label87: Label8;
    I3VATTLab: Label8;
    Label811: Label8;
    Label830: Label8;
    I4NomF: Text8Pt;
    I4CCF: Text8Pt;
    I4CCLab: Label8;
    I4DepLab: Label8;
    I4DepF: Text8Pt;
    I1DumPanel: TSBSPanel;
    Match1: TMenuItem;
    I6BtmPanel: TSBSPanel;
    Label83: Label8;
    Label85: Label8;
    Label86: Label8;
    Delete1: TMenuItem;
    StatI1Btn: TButton;
    Status1: TMenuItem;
    SBSAccelLabel1: TSBSAccelLabel;
    CurrLab1: Label8;
    PopupMenu2: TPopupMenu;
    AP1: TMenuItem;
    AW1: TMenuItem;
    ARW1: TMenuItem;
    DMDCNomF: Text8Pt;
    Label834: Label8;
    LnkI1Btn: TButton;
    Link1: TMenuItem;
    EntCustom3: TCustomisation;
    CustTxBtn1: TSBSButton;
    CustTxBtn2: TSBSButton;
    Custom1: TMenuItem;
    Custom2: TMenuItem;
    I5VRateF: TCurrencyEdit;
    I5VRateL: TLabel;
    FixXRF: TBorCheck;
    TransExtForm1: TSBSExtendedForm;
    I4JobCodeL: Label8;
    I4JAnalL: Label8;
    I1YrRefL: Label8;
    I1YrRef2L: Label8;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    Bevel1: TBevel;
    bevBelowJob: TBevel;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    I1YrRefF: Text8Pt;
    I1YrRef2F: Text8Pt;
    I4JobCodeF: Text8Pt;
    I4JobAnalF: Text8Pt;
    I5NBL: Label8;
    I5NBF: TCurrencyEdit;
    WORI1Btn: TButton;
    WOR1: TMenuItem;
    CISPanel1: TSBSPanel;
    Label1: TLabel;
    I5CISTaxF: TCurrencyEdit;
    I5CISManCb: TBorCheck;
    Label2: TLabel;
    I5CISDecF: TCurrencyEdit;
    I5CISPeriodF: TEditDate;
    Label3: TLabel;
    I5CISGrossF: TCurrencyEdit;
    RetI1Btn: TButton;
    Ret1: TMenuItem;
    I2ReconPanel: TSBSPanel;
    I2ReconLab: TSBSPanel;
    RcReconPanel: TSBSPanel;
    RcReconLab: TSBSPanel;
    btnApplyTTD: TButton;
    mnuApplyTTD: TMenuItem;
    lblOverrideLocation: Label8;
    edtOverrideLocation: Text8Pt;
    bevBelowOverrideLocation: TBevel;
    WkMonthLbl: Label8;
    WkMonthEdt: TCurrencyEdit;
    lblUdf5: Label8;
    edtUdf5: Text8Pt;
    lblUdf6: Label8;
    edtUdf6: Text8Pt;
    lblUdf7: Label8;
    edtUdf7: Text8Pt;
    lblUdf8: Label8;
    edtUdf8: Text8Pt;
    lblUdf9: Label8;
    edtUdf9: Text8Pt;
    lblUdf10: Label8;
    edtUdf10: Text8Pt;
    mnuSwitchNotes: TPopupMenu;
    General1: TMenuItem;
    Dated1: TMenuItem;
    AuditHistory1: TMenuItem;
    CustTxBtn3: TSBSButton;
    CustTxBtn4: TSBSButton;
    CustTxBtn5: TSBSButton;
    CustTxBtn6: TSBSButton;
    Custom3: TMenuItem;
    Custom4: TMenuItem;
    Custom5: TMenuItem;
    Custom6: TMenuItem;
    I1AddrF: TMemo;
    lvLineTypeTotals: TListView;
    nbSettleDisc: TNotebook;
    Label5: TLabel;
    I5SDPF: TCurrencyEdit;
    Label7: TLabel;
    Label6: TLabel;
    I5SDDF: TCurrencyEdit;
    SBSPanel63: TSBSPanel;
    SBSPanel62: TSBSPanel;
    I5Net1F: TCurrencyEdit;
    I5VAT1F: TCurrencyEdit;
    I5Disc1F: TCurrencyEdit;
    I5Tot1F: TCurrencyEdit;
    Label16: TLabel;
    Label15: TLabel;
    Label14: TLabel;
    Label4: TLabel;
    Label17: TLabel;
    I5Tot2F: TCurrencyEdit;
    I5Disc2F: TCurrencyEdit;
    I5VAT2F: TCurrencyEdit;
    I5Net2F: TCurrencyEdit;
    I5MVATF: TCheckBox;
    I5SDTF: TCheckBox;
    Label20: TLabel;
    Label19: TLabel;
    Label18: TLabel;
    lblPromptPaymentDiscountHeader: TLabel;
    lblPPDPercentage: TLabel;
    ccyPPDPercentage: TCurrencyEdit;
    lblPPDDays: TLabel;
    ccyPPDDays: TCurrencyEdit;
    lvTransactionTotalsPPD: TListView;
    bevPromptPaymentDiscountHeader: TBevel;
    Label22: TLabel;
    Bevel3: TBevel;
    Label13: TSBSPanel;
    Label21: TSBSPanel;
    lblPPDStatus: TLabel;
    shapePPDStatus: TShape;
    lblPPDPercentagePercent: TLabel;
    btnCancelPPD: TButton;
    Label9: TLabel;
    Bevel2: TBevel;
    Label10: TLabel;
    Bevel4: TBevel;
    lvTransactionTotals: TListView;
    OkI5Btn: TButton;
    CanI5Btn: TButton;
    ClsI5Btn: TButton;
    I1StatLab: Label8;
    OkI1Btn: TButton;
    CanI1Btn: TButton;
    ClsI1Btn: TButton;
    panOrderPayment: TSBSPanel;
    chkCreateOrderPayment: TCheckBox;
    btnOPPayment: TSBSButton;
    btnOPRefund: TSBSButton;
    mnuOrdPayPayment: TMenuItem;
    mnuOrdPayRefund: TMenuItem;
    mnuCancelPPD: TMenuItem;
    pnlIntrastat: TPanel;
    Label11: TLabel;
    Bevel5: TBevel;
    sbVATRates: TScrollBox;
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
    SBSPanel54: TSBSPanel;
    I5VATRLab: TSBSPanel;
    Label8: TSBSPanel;
    I5VATLab: TSBSPanel;
    lblTaxSummary: TLabel;
    Bevel6: TBevel;
    lblDeliveryTerms: TLabel;
    lblTransactionType: TLabel;
    lblNoTc: TLabel;
    lblModeOfTransport: TLabel;
    cbDeliveryTerms: TSBSComboBox;
    cbTransactionType: TSBSComboBox;
    cbNoTc: TSBSComboBox;
    cbModeOfTransport: TSBSComboBox;
    Label12: TLabel;
    Bevel7: TBevel;
    lblUdf11: Label8;
    edtUdf11: Text8Pt;
    lblUdf12: Label8;
    edtUdf12: Text8Pt;
    Shape1: TShape;
    pnlAnonymisationStatus: TPanel;
    shpNotifyStatus: TShape;
    lblAnonStatus: TLabel;
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ClsI1BtnClick(Sender: TObject);
    procedure I1AddrFClick(Sender: TObject);
    function I1PrYrFConvDate(Sender: TObject; const IDate: string;
                       const Date2Pr: Boolean): string;
    procedure OkI1BtnClick(Sender: TObject);
    procedure I1AccFExit(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure I1DelBtnClick(Sender: TObject);
    procedure I1TransDateFExit(Sender: TObject);
    procedure I1CurrFExit(Sender: TObject);
    procedure I5VV1FExit(Sender: TObject);
    procedure I5SDPFExit(Sender: TObject);
    procedure I5MVATFClick(Sender: TObject);
    procedure I1SCodeLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure I1SCodeLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure I1StkCodePanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure AddI1BtnClick(Sender: TObject);
    procedure DelI1BtnClick(Sender: TObject);
    procedure I4JobCodeFExit(Sender: TObject);
    procedure I4JobAnalFExit(Sender: TObject);
    procedure SwiI1BtnClick(Sender: TObject);
    procedure APickI1BtnClick(Sender: TObject);
    function I1PrYrFShowPeriod(Sender: TObject; const EPr: Byte): string;
    procedure MatI1BtnClick(Sender: TObject);
    procedure FindI1BtnClick(Sender: TObject);
    procedure StatI1BtnClick(Sender: TObject);
    procedure SBSAccelLabel1Accel(Sender: TObject; AccChar: Char);
    procedure AP1Click(Sender: TObject);
    procedure I1YrRefFExit(Sender: TObject);
    procedure DMDCNomFExit(Sender: TObject);
    procedure I1DueDateFExit(Sender: TObject);
    procedure LnkI1BtnClick(Sender: TObject);
    procedure CustTxBtn1Click(Sender: TObject);
    procedure I1EXRateFExit(Sender: TObject);
    procedure I1YrRef2FExit(Sender: TObject);
    procedure I1EXRateFEnter(Sender: TObject);
    procedure ISDelFExit(Sender: TObject);
    procedure ISTTFExit(Sender: TObject);
    procedure ISMTFExit(Sender: TObject);
    procedure TransExtForm1Enter(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure I1PrYrFExit(Sender: TObject);
    procedure I1YrRefFEnter(Sender: TObject);
    procedure I1YrRef2FEnter(Sender: TObject);
    procedure WORI1BtnClick(Sender: TObject);
    procedure I5CISManCbClick(Sender: TObject);
    procedure TransExtForm1Exit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RetI1BtnClick(Sender: TObject);
    procedure I1YrRefFChange(Sender: TObject);
    procedure TransExtForm1Resize(Sender: TObject);
    procedure I1YrRef2FChange(Sender: TObject);
    procedure btnApplyTTDClick(Sender: TObject);
    procedure ISPTFClick(Sender: TObject);
    procedure edtOverrideLocationExit(Sender: TObject);
    procedure I5SDPFKeyPress(Sender: TObject; var Key: Char);
    procedure I5SDDFKeyPress(Sender: TObject; var Key: Char);
    procedure General1Click(Sender: TObject);
    procedure Dated1Click(Sender: TObject);
    procedure AuditHistory1Click(Sender: TObject);
    procedure TransExtForm1CloseUp(Sender: TObject);
    procedure btnCancelPPDClick(Sender: TObject);
    procedure ccyPPDDaysExit(Sender: TObject);
    procedure btnOPRefundClick(Sender: TObject);
    procedure btnOPPaymentClick(Sender: TObject);
    procedure Label813Click(Sender: TObject);
  private
    { Private declarations }
//    lblOverrideLocation: Label8;
//    edtOverrideLocation: Text8Pt;
//    bevBelowOverrideLocation: TBevel;

    InPassing,
    GenSelect,
    JustCreated,
    InvStored,
    StopPageChange,
    DirectStore,
    FirstStore,
    BeingStored,
    fDoingClose,
    ReCalcTot,
    UpDateDel,
    fNeedCUpdate,
    fFrmClosing,
    FColorsChanged,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    fAutoJCPage,
    fRecordLocked,
    fRecordAuth,
    fChkYourRef,
    CanDelete    :  Boolean;

    MinHeight,
    MinWidth     :  Integer;

    OrigPnlTaxRatesHeight : Integer;
    OrigSbVATRatesHeight : Integer;

    {$IFDEF SOP}
      TransCommitPtr
                 :  Pointer;
    {$ENDIF}


    {$IFDEF NP}
      NotesCtrl  :  TNoteCtrl;
    {$ENDIF}

    {$IFDEF Rt_On}
      PayCtrl  :  TPayLine;
    {$ENDIF}

    DispCust     :  TFCustDisplay;
    VATMatrix    :  TVATMatrix;

    InvBtnList   :  TVisiBtns;

    //Extended from 26 to 38 to allow for new 6.9 udfs
    // PKR. 24/03/2016. ABSEXCH-17383. eRCT support.
    // Extended from 38 to 42 to allow for 2 new UDFs and their labels.
    ExtList      :  Array[1..42] of TControl;


    IdLine       :  TTxLine;
    IdLineActive :  Boolean;

    DelACtrl     :  TDelAddrPop;
    //ISCtrl       :  TIntStatInv;
    ASCtrl       :  TAutoTxPop;

    RecordPage   :  Byte;
    DocHed       :  DocTypes;

    OldConTot    :  Double;

    //PR: 24/08/2012 ABSEXCH-13333
    OldOrderConTot : Double;

    BackOrdPtr,
    MatchOrdPtr  :  Pointer;


    PagePoint  :  Array[0..6] of TPoint;

    {NeedCUpdate}
    StartSize,
    InitSize   :  TPoint;

    {$IFDEF Ltr}
      LetterActive: Boolean;
      LetterForm:   TLettersList;
    {$ENDIF}

    AuthBy     :  Str10;

    {$IFDEF SOP}
      TTDHelper : TTTDTransactionHelper;
    {$ENDIF}

    //PR: 09/11/2010
    FSettings : IWindowSettings;

    //PR: 20/06/2012 ABSEXCH-11528 If editing, store order o/s before any lines are changed.
    PreviousOS : Double;

    {$IFDEF CU}
    // 25/01/2013  PKR   ABSEXCH-13449/38
    // Used by the new Custom Button Handler.
    FormPurpose : TFormPurpose;
    RecordState : TRecordState;
    {$ENDIF}

    //PR: 04/10/2013 MRD 1.1.17
    WasConsumer : Boolean;

    // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    SettlementDiscountPercentage : Double;
    SettlementDiscountDays : Integer;
    SavedSettleDiscPos : Array [EnumSetDiscSavedPositions] of Integer;
    // MH 26/08/2015 2015-R1 ABSEXCH-16790: Take PPD Percentage/Days from Head Office where applicable
    PPDMode : TTraderPPDMode;
    PPDDiscountPercentage : Double;
    PPDDiscountDays : Integer;

    // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added flag for Telesales to allow the Edit SOR window
    // displayed by Telesales to display the Order Payments Take Payment window on store.
    FOrderPaymentsAutoPayment : Boolean;

    // MH 05/07/2016 2016-R2 ABSEXCH-17638: B2B POR's not printing
    FBackToBackTransaction : Boolean;

    FOldExpandedHeight : Integer;

    //PR: 13/11/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;

    // SSK 29/11/2017 ABSEXCH-19398: variable added to handle anonymisation behaviour
    FListScanningOn,
    FAnonymisationON: Boolean;

    function TransactionViewOnly : Boolean;

    procedure SetListName(PageNo : Integer);

    Procedure SetForceStore(State  :  Boolean);

    procedure Find_Page1Coord(PageNo  :  Integer);

    procedure Store_Page1Coord(UpMode  :  Boolean);

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    {$IFDEF SOP}

      procedure Create_CommitObject(Remove  :  Boolean);

      procedure Delete_LiveCommit(IdR     :  IDetail;
                                  DedMode :  SmallInt);

    {$ENDIF}

    procedure Display_Id(Mode  :  Byte);

    procedure Display_PayIn(ChangeFocus   :  Boolean);

    procedure Display_BackOrd(ChangeFocus   :  Boolean);

    Procedure Link2Nom;

    Procedure SetCurrStat;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMRefreshButtons(Var Message : TMessage); Message WM_RefreshButtons;

    {$IFDEF JC}
      Procedure AutoShowJCPage;
    {$ENDIF}

    procedure AutoPromptJC(Sender: TObject);

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;



    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure NotePageReSize;

    procedure PayIPageReSize;

    Function CheckNeedStore  :  Boolean;

    Function ConfirmQuit  :  Boolean;

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure SetFieldProperties;

    procedure SetFormProperties(SetList  :  Boolean);

    procedure SetNewFolio;

    Procedure SetCtrlNomStat;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    function ValidateOverrideLocation(PromptIfEmpty: Boolean = True): Boolean;

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    //PR: 20/10/2011 v6.9
    procedure SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);

    { CJS 2012-09-03 - ABSEXCH-12393 - Job Code Validation }
    procedure ValidateJobCode;

    // CJS 2013-11-27 - MRD1.1.17 - Consumer Support
    procedure ResizeAcCodeField(ForConsumer: Boolean);

    // CJS 2014-08-04: v7.x Order Payments - T030 - Added Order Payments panel
    Procedure ShowOrderPaymentsArea (Const ShowOrderPayment : Boolean);

    // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    procedure SetDefaultSettlementDiscount;
    Procedure ShowSettlementDiscountFields (Const ShowFields : Boolean);

    // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
    Function ShowPPDFields : Boolean;
    // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
    Procedure DisplayPPDFields;
    // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
    Procedure UpdatePPDStatusInfo;

    // CJS 2016-01-11 - ABSEXCH-17100 - Intrastat fields for Transaction Header
    procedure ArrangeFooterComponents;
    procedure PopulateIntrastatLists;

    // CJS 2016-01-20 - ABSEXCH-17168 - Hide disabled Intrastat controls
    procedure ArrangeIntrastatComponents;

    // CJS 2016-01-22 - ABSEXCH-17180 - Default NoTC on Transaction Headers & Lines
    function DefaultNoTCIndex: Integer;

    {$IFDEF SOP}
    function HandleRefunds: Boolean;
    {$ENDIF}

    // SSK 27/10/2017 ABSEXCH-19398: Set Anonymisation Banner for Trader
    procedure SetAnonymisationBanner;
    //HV 12/11/2017 ABSEXCH-19549: Anonymised Notification banner in View/Edit Record > Banner not displayed on maximise and then Restore Down.
    procedure SetAnonymisationPanel;
  public
    { Public declarations }


    LPickMode,
    fForceStore,
    fInBatchEdit
               :  Boolean;

    ExLocal    :  TdExLocal;
    ListOfSet  :  Integer;

    MULCtrlO   :  TTransMList;

    MULVisiList:  Array[0..3] of TVisiList;

    { CJS 2012-08-16 - ABSEXCH-13263 - Array of source controls to hold the
                                       font details, used by SBSComp }
    SourceListBox: array[0..3] of TStringGridEx;


    Property ForceStore  : Boolean read fForceStore write SetForceStore default False;

    // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added flag for Telesales to allow the Edit SOR window
    // displayed by Telesales to display the Order Payments Take Payment window on store.
    Property OrderPaymentsAutoPayment : Boolean Read FOrderPaymentsAutoPayment Write FOrderPaymentsAutoPayment;

    // MH 05/07/2016 2016-R2 ABSEXCH-17638: B2B POR's not printing
    Property BackToBackTransaction : Boolean Read FBackToBackTransaction Write FBackToBackTransaction;

    Function SetHelpC(PageNo :  Integer;
                      Pages  :  TIntSet;
                      Help0,
                      Help1  :  LongInt) :  LongInt;

    procedure SetHelpContextIDsForPage; //NF:
    
    procedure PrimeButtons;

    procedure PrimeExtList;

    Procedure ResetExtFL;

    Procedure ShuntExt;

    Procedure Show_IntraStat(IsVisible,
                             IsEnabled    :  Boolean);

    procedure SetUDFields(UDDocHed  :  DocTypes);

    procedure BuildDesign;

    procedure BuildMenus;

    procedure FormDesign;

    procedure HidePanels(PageNo    :  Byte);

    Procedure SetColDec(PageNo  :  Byte);

    Procedure InitVisiList(PageNo  :  Byte);

    Function Current_BarPos(Const PageNo  :  Byte)  :  Integer;

    Procedure SetCurrent_BarPos(Const PageNo  :  Byte;
                                Const NewBO   :  Integer);

    Procedure ChangeList(PageNo    :  Byte;
                         ShowLines :  Boolean);

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    Function Current_Page  :  Integer;

    Function SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

    procedure FormSetOfSet;

    procedure ShowLink(ShowLines,
                       VOMode    :  Boolean);


    Procedure ChangePage(NewPage  :  Integer);


    procedure ReFreshFooter;

    Procedure OutInvFooterTot;


    procedure ReApplyVAT(Value  :  Real);

    Procedure SetInvTotPanels(NewIndex  :  Integer);

    Procedure OutInvTotals(NewIndex  :  Integer);

    procedure SetInvFields;

    procedure OutInv;

    procedure Form2Inv;

    Procedure SetFieldFocus;

    procedure SetInvStore(EnabFlag,
                          VOMode  :  Boolean);

    procedure GetAutoSettings;

    procedure ProcessInv(Fnum,
                         KeyPAth    :  Integer;
                         Edit,
                         AutoOn     :  Boolean);

    Procedure NoteUpdate;

    Function Check_LinesOk(InvR      :  InvRec;
                       Var ShowMsg  :  Boolean;
                       Var MainStr  :  Str255)  :  Boolean;


    Function CheckCompleted(Edit  :  Boolean)  : Boolean;

    procedure StoreInv(Fnum,
                       KeyPAth    :  Integer;
                       PickMode   :  Boolean);


    procedure EditAccount(Edit,
                          AutoOn,
                          ViewOnly,
                          PickMode   :  Boolean);

    procedure CheckForECServiceLines;

    //PR: 14/11/2017 ABSEXCH-19451
    procedure EnableEditPostedFields;
    //HV 07/12/2017 ABSEXCH-19535: Anonymised Transcation > The height of the window gets increased if "Save coordinates" is ticked
    property ListScanningOn: Boolean read FListScanningOn write FListScanningOn;

  end;

Procedure Set_TransFormMode(State  :  DocTypes;
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
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,
  Tranl1u,
  {$IFDEF PF_On}

    InvLst2U,

    {$IFDEF JC}
       JChkUseU,
    {$ENDIF}

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

  {$IFDEF SOP}
    SOPCT3U,
    BOMCmpU,
    AdjCtrlU,
  {$ENDIF}

  {$IFDEF NOM}
    NLPayInU,
  {$ENDIF}

  SysU1,
  SysU2,
  SysU3,
  MiscU,
  PayF2U,
  InvFSu2U,
  InvCTSUU,
  InvCT2SU,
  InvFSU3U,
  PWarnU,
  DiscU4U,
  {$IFDEF STK}


    {$IFDEF PF_On}
      CuStkA3U,
    {$ENDIF}

  {$ENDIF}

  IntMU,

  {$IFDEF SOP}

    SALTxl2U,

    {$IFDEF POST}
       PostingU,
    {$ENDIF}

  {$ENDIF}


  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  {$IFDEF WOP}
    WORIWizU,

    WOPCT1U,
  {$ENDIF}

  {$IFDEF RET}
    RetWiz1U,
    RetSup1U,
  {$ENDIF}

  Event1U,

  {$IFDEF CU}
    CustWinU,
    CustIntU,

  {$ENDIF}

  LedgSupU,

  PassWR2U,
  GenWarnU,

  {$IFDEF SY}
    AUWarnU,

  {$ENDIF}

  ThemeFix,

  SavePos,
  Warn1U,

  // MH 11/03/2013 v7.0.2 ABSEXCH-13758: Disable UI controls to prevent people messing with
  //                                     the window whilst the transaction is saving
  DisableControlsClass,

  //PR: v.6.9
  CustomFieldsIntf,

  { CJS - 2013-08-14 - MRD2.6 - Transaction Originator }
  TransactionOriginator,

  // MH 05/09/2013 v7.XMRD MRD1.2.18: Added Auto-Receipt Support
  UA_Const,

  AuditNotes,

  {$IFDEF SOP}
    OrderPaymentsInterfaces,
    oOrderPaymentsTransactionPaymentInfo,
    oOrderPaymentsTransactionInfo,
    PaymentF,
    RefundF,

    // MH 23/09/2014 Order Payments: Extended Customisation
    OrdPayCustomisation,

    //PR: 10/08/2015 ABSEXCH-16388 for function OrderIsFullyPaid
    OrderPaymentFuncs,
  {$ENDIF SOP}

  //PR: 02/10/2013 MRD 1.1.17
  ConsumerUtils,

  // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
  PromptPaymentDiscountFuncs,

  // MH 23/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  TransactionHelperU,

  // CJS 2016-01-11 - ABSEXCH-17100 - Intrastat fields for Transaction Header
  {$IFNDEF EXDLL}
  IntrastatXML,
  oSystemSetup,
  {$ENDIF}

  // CJS 2015-01-20 - ABSEXCH-16021 - manual payments against an Order Payment
  HelpContextIds,

  //SSK 29/11/2017 ABSEXCH-19398: GDPR constants
  GDPRConst;



{$R *.DFM}
const
  ListNames : Array[0..3] of string[4] = ('Data','Anal','Pick','Job');

  SettleDiscPage = 0;
  PromptPaymentDiscountPage = 1;
  NoPromptPaymentDiscountPage = 2;

Var
  TransFormMode  :  DocTypes;
  TransFormPage  :  Byte;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_TransFormMode(State  :  DocTypes;
                            NPage  :  Byte);

Begin
  If (State<>TransFormMode) then
    TransFormMode:=State;

  If (TransFormPage<>NPage) then
    TransFormPage:=NPage;

end;


{$I SALETI1U.PAS}



procedure TSalesTBody.SetForceStore(State  :  Boolean);

Begin
  If (State<>fForceStore) then
  Begin
    fForceStore:=State;

    If (Not ExLocal.LViewOnly) then
    Begin
      ClsI1Btn.Enabled:=Not fForceStore;
      CanI1Btn.Enabled:=ClsI1Btn.Enabled;
      CanI5Btn.Enabled:=ClsI1Btn.Enabled;
      ClsI5Btn.Enabled:=ClsI1Btn.Enabled;
    end;

  end;

end;


procedure TSalesTBody.Find_Page1Coord(PageNo  :  Integer);


Var

  n       :  Integer;

  GlobComp:  TGlobCompRec;


Begin
  If (MULCtrlO<>nil) then
  With MULCtrlO do
  Begin
    SetListName(PageNo);
    if Assigned(FSettings) and not FSettings.UseDefaults then
      FSettings.SettingsToParent(MULCtrlO);
    FormResize(Self);
  end;
(*    New(GlobComp,Create(BOn));

    With GlobComp^ do
    Begin
      GetValues:=BOn;

      PrimeKey:=DocCodes[DocHed][1];

      HasCoord:=LastCoord;

      Find_ListCoord(GlobComp);

      GetbtControlCsm(VisiList.LabHedPanel);

    end; {With GlobComp..}


    Dispose(GlobComp,Destroy);

  end; *)

end;


procedure TSalesTBody.Store_Page1Coord(UpMode  :  Boolean);


Var
  n       :  Byte;
  GlobComp:  TGlobCompRec;


Begin
  if Assigned(FSettings) then
  begin
    For n:=0 to High(MULVisiList) do
    begin
      If (MULVisiList[n]<>nil) then
      begin
        With MULCtrlO do
        Begin
          SetListName(n);
          VisiList:=MULVisiList[n];
          { CJS 2012-08-16 - ABSEXCH-13263 - Make sure that SBSComp uses the
                                             correct source control for the font
                                             details. }
          MUListBox1 := SourceListBox[n];
        end;
        FSettings.ParentToSettings(MULCtrlO, MULCtrlO);
      end;
    end;
  end;
(*
  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin

    GetValues:=UpMode;

    SaveCoord:=StoreCoord;

    PrimeKey:=DocCodes[DocHed][1];

    For n:=1 to High(MULVisiList) do
    If (MULVisiList[n]<>nil) then
    With MULCtrlO do
    Begin
      VisiList:=MULVisiList[n];

      Store_ListCoord(GlobComp);

      StorebtControlCsm(VisiList.LabHedPanel); {* Move to object store *}
    end;


    If (Current_Page<=High(MULVisiList)) then
      With MULCtrlO do
      Begin
        VisiList:=MULVisiList[Current_Page];
      end;

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy); *)
    If (Current_Page<=High(MULVisiList)) then
      With MULCtrlO do
      Begin
        { CJS 2012-08-16 - ABSEXCH-13263 - Restore the source control for the
                                           current page. }
        VisiList:=MULVisiList[Current_Page];
      end;

end;

Procedure  TSalesTBody.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TSalesTBody.Find_FormCoord;


Var
  n       :  Byte;

  VL      :  Pointer;

  ThisForm:  TForm;

  VisibleRect
          :  TRect;

  GlobComp:  TGlobCompRec;


Begin
  if Assigned(FSettings) and not FSettings.UseDefaults then
  begin
    FSettings.SettingsToWindow(Self);
    FSettings.SettingsToParent(Self);
    FSettings.SettingsToParent(MulCtrlO);
  end;
(*


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

    GetbtControlCsm(I1SBox);

    GetbtControlCsm(I1BSBox);

    GetbtControlCsm(I1BtnPanel);

    GetbtControlCsm(I1ListBtnPanel);

    GetbtControlCsm(TCNScrollBox);
    GetbtControlCsm(TCNListBtnPanel);


    If GetbtControlCsm(I1AccF) then
      SetFieldProperties;



    MULCtrlO.Find_ListCoord(GlobComp);

    VL:=MULCtrlO.VisiList;


    For n:=1 to High(MULVisiList) do
    Begin
      If (MULVisiList[n]=nil) then
        InitVisiList(n);

      With MULCtrlO do
      Begin
        VisiList:=MULVisiList[n];

        Find_ListCoord(GlobComp);
      end;
    end;

    MULCtrlO.VisiList:=VL;

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
*)
  {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;


end;


procedure TSalesTBody.Store_FormCoord(UpMode  :  Boolean);
Var
  lHeight: Integer;
Begin
(*
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

    StorebtControlCsm(I1SBox);

    StorebtControlCsm(I1BSBox);

    StorebtControlCsm(I1BtnPanel);

    StorebtControlCsm(I1ListBtnPanel);

    StorebtControlCsm(I1AccF);

    StorebtControlCsm(TCNScrollBox);

    StorebtControlCsm(TCNListBtnPanel);

    MULCtrlO.Store_ListCoord(GlobComp);

    {$IFDEF NP}
      If (NotesCtrl<>nil) then
        NotesCtrl.MULCtrlO.Store_ListCoord(GlobComp);
    {$ENDIF}

    {$IFDEF Rt_On}
      If (PayCtrl<>nil) then
        PayCtrl.MULCtrlO.Store_ListCoord(GlobComp);
    {$ENDIF}

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

  *)

  Store_Page1Coord(UpMode);
  if Assigned(FSettings) then
  begin
    if Assigned(NotesCtrl) then
      FSettings.ParentToSettings(NotesCtrl.MULCtrlO, NotesCtrl.MULCtrlO); //Notes

    if Assigned(PayCtrl) then
      FSettings.ParentToSettings(PayCtrl.MULCtrlO, PayCtrl.MULCtrlO); //Pay Lines

    FSettings.ParentToSettings(Self,I1AccF);
    //HV 07/12/2017 ABSEXCH-19535: Anonymised Transaction > The height of the window gets increased if "Save coordinates" is ticked
    if pnlAnonymisationStatus.Visible then
    begin
      lHeight := 0;
      if FSettings.UseDefaults then
        lHeight := 17;
      Self.ClientHeight := (Self.ClientHeight + lHeight) - pnlAnonymisationStatus.Height;
      Self.ClientWidth := (Self.ClientWidth + lHeight)
    end;
    FSettings.WindowToSettings(Self);
    FSettings.SaveSettings(StoreCoord); 
  end;
end;




Function TSalesTBody.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;


{$IFDEF SOP}

  procedure TSalesTBody.Create_CommitObject(Remove  :  Boolean);

  {$IFDEF POST}
    Var
      PostObj  :  ^TEntPost;
    Begin
      If (Not Syss.ProtectPost) and (ExLocal.LInv.NomAuto) then
      Begin
        If (Not Assigned(TransCommitPtr)) and (DocHed In CommitLSet) and (Not Remove) then
        Begin
          New(PostObj,Create(Self));

          Try
            If (Not PostObj^.Start(50,nil,nil,BOff)) then
            Begin
              Dispose(PostObj,Destroy);
              PostObj:=nil;
            end;

          except
            Dispose(PostObj,Destroy);
            PostObj:=nil;
          end; {Try..}

          TransCommitPtr:=@PostObj^;

        end
        else
          If (Remove) and (Assigned(TransCommitPtr)) then
          Begin
            PostObj:=TransCommitPtr;

            Dispose(PostObj,Destroy);
            TransCommitPtr:=nil;

          end;
      end;
    end;
  {$ELSE}
    Begin

    end;
  {$ENDIF}


  procedure TSalesTBody.Delete_LiveCommit(IdR     :  IDetail;
                                        DedMode :  SmallInt);

  {$IFDEF POST}
    Var
      PostObj  :  ^TEntPost;

    Begin
      {$IFDEF SOP}
        Create_CommitObject(BOff);

      {$ENDIF}

      If (CommitAct) and (IdR.IdDocHed In CommitLSet) and (ExLocal.LInv.NomAuto) then
      Begin
        If (Assigned(TransCommitPtr)) then
        Begin
          PostObj:=TransCommitPtr;
          try
            PostObj^.Update_LiveCommit(IdR,DedMode);
          except
            Dispose(PostObj,Destroy);
            TransCommitPtr:=nil;
          end;
        end
        else
          AddLiveCommit2Thread(IdR,DedMode);
      end;
    end;

  {$ELSE}
    Begin


    end;
  {$ENDIF}



{$ENDIF}

procedure TSalesTBody.Display_Id(Mode  :  Byte);

Var
  CPage    :  Integer;

Begin
//PR: 24/09/2008 Disable OK buttons while line form is open
  OkI5Btn.Enabled := False;
  OKI1Btn.Enabled := False;

  CPage:=Current_Page;


  If (IdLine=nil) then
  Begin

    Set_IdFormMode(DocHed);  {*Ex 32 needs changing *}

    IdLine:=TTxLine.Create(Self);

  end;

  {$IFDEF SOP}
    If (CommitAct) then
      Create_CommitObject(BOff);
  {$ENDIF}

  Try
   if FAllowPostedEdit then
     IdLine.EnableEditPostedFields;

   With IdLine do
   Begin
      //PR: 26/06/2009 Add this so that line form can tell that header is being edited.
      TransBeingEdited := Self.ExLocal.LastEdit;

      


      //PR: 23/08/2012 ABSEXCH-13333 Pass value to line to keep track of original total on order being edited.
      PreviousOrderTotal := OldOrderConTot;
     {$IFDEF SOP}
       CommitPtr:=TransCommitPtr;

     {$ENDIF}

     If (CPage In [2]) and (((DocHed In [SOR]) and (PChkAllowed_In(160))) or ((DocHed In [POR]) and (PChkAllowed_In(170)))) then
       CPage:=Succ(CPage)
     else
       CPage:=DefaultPage;


     WindowState:=wsNormal;
     {Show;}


     If (Not IdLineActive) then
       ChangePage(CPage,BOff);

     InvBtnList.SetEnabBtn(BOff);

     {Self.Enabled:=BOff;}

     If (Mode In [1..3]) then
     Begin

       Case Mode of

         1..3  :   If (Not ExLocal.InAddEdit) then
                     EditLine(Self.ExLocal.LInv,(Mode=2),(Mode=3),Self.ExLocal.LViewOnly)
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

procedure TSalesTBody.Display_PayIn(ChangeFocus   :  Boolean);


{$IFDEF NOM}

  Var
    NomNHCtrl  :  TNHCtrlRec;

    FoundLong  :  Longint;

    PayInForm  :  TPayInWin;

    TmpId      :  Idetail;

    WasNew     :  Boolean;

  Begin

    {$IFDEF SOP}

      WasNew:=BOff;

      With EXLocal,NomNHCtrl do
      Begin
        TmpId:=Id;
      
        AssignToGlobal(InvF);

        FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

        NHMode:=1;

        Set_PIFormMode(NomNHCtrl);

      end;

      If (MatchOrdPtr=nil) then
      Begin
        WasNew:=BOn;

        PayInForm:=TPayInWin.Create(Self);

        MatchOrdPtr:=PayInForm;

      end
      else
        PayInForm:=MatchOrdPtr;

      Try

       With PayInForm do
       Begin
         Id:=TmpId;

         WindowState:=wsNormal;

         If (ChangeFocus) then
           Show;

         ShowLink(BOn);


       end; {With..}

       If (WasNew) then
       Begin
       end;

      except

       MatchOrdPtr:=nil;

       PayInForm.Free;
       PayInForm:=nil;

      end; {try..}
    {$ENDIF}

  {$ELSE}

    Begin


  {$ENDIF}

end;


procedure TSalesTBody.Display_BackOrd(ChangeFocus   :  Boolean);


{$IFDEF NOM}

  Var
    NomNHCtrl  :  TNHCtrlRec;

    FoundLong  :  Longint;

    PayInForm  :  TPayInWin;

    TmpId      :  Idetail;

    WasNew     :  Boolean;

  Begin

    {$IFDEF SOP}

      WasNew:=BOff;

      With EXLocal,NomNHCtrl do
      Begin
        TmpId:=Id;

        AssignToGlobal(InvF);

        FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

        NHMode:=2;

        Set_PIFormMode(NomNHCtrl);

      end;

      If (BackOrdPtr=nil) then
      Begin
        WasNew:=BOn;

        PayInForm:=TPayInWin.Create(Self);

        BackOrdPtr:=PayInForm;

      end
      else
        PayInForm:=BackOrdPtr;

      Try

       With PayInForm do
       Begin
         Id:=TmpId;

         WindowState:=wsNormal;

         If (ChangeFocus) then
           Show;

         ShowLink(BOn);


       end; {With..}

       If (WasNew) then
       Begin
       end;

      except

       BackOrdPtr:=nil;

       PayInForm.Free;
       PayInForm:=nil;

      end; {try..}
    {$ENDIF}
  {$ELSE}

    Begin

  {$ENDIF}

end;



Procedure TSalesTBody.Link2Nom;

Var
  FoundCode  :  LongInt;
  FoundStk   :  Str20;

Begin
  With Id do
  Begin
    If (Nom.NomCode<>NomCode) then
      GetNom(Self,Form_Int(NomCode,0),FoundCode,-1);

    I1NomCodeF.Text:=Nom.Desc;
    I4NomF.Text:=I1NomCodeF.Text;

    I1CCF.Text:=CCDep[BOn];
    I1DepF.Text:=CCDep[BOff];
    I4CCF.Text:=CCDep[BOn];
    I4DepF.Text:=CCDep[BOff];
    I3CCF.Text:=CCDep[BOn];
    I3DepF.Text:=CCDep[BOff];

    I1LocnF.Text:=MLocStk;
    I3LocnF.Text:=MLocStk;

    I2StkDescF.Text:=Desc;
    I2QtyF.Value:=Calc_IdQty(Qty,QtyMul,UsePack);

    I3StkCodeF.Text:=Id.StockCode;

    {$IFDEF STK} {* Link up for List auto search to work *}
      With ExLocal do
      If (Is_FullStkCode(StockCode)) and (LStock.StockCode<>StockCode) then
      Begin
        GetStock(Self,StockCode,FoundStk,-1);
        AssignFromGlobal(StockF);
      end;
    {$ENDIF}

  end; {With..}
end; {Proc..}


Procedure TSalesTBody.SetCurrStat;

Begin
  {$IFDEF MC_On}

    With ExLocal,LInv do
    If (Not LViewOnly) then
    Begin
      I1CurrF.ReadOnly:=((Round(TotalInvoiced)<>0) or (RunNo=BatchRunNo));
      I1ExRateF.ReadOnly:=(SyssGCuR^.GhostRates.TriEuro[Currency]<>0) or (Currency=1) or (Not CanEditTriEuro(Currency));
    end;

  {$ENDIF}
end;


Procedure TSalesTBody.WMCustGetRec(Var Message  :  TMessage);

Var
  mbRet  :  Word;

  //PR: 20/05/2014 ABSEXCH-2763
  Ok2Print : Boolean;

Begin


  With Message do
  Begin


    Case WParam of
      0,169
         :  Begin
              If (WParam=169) then
                MULCtrlO.GetSelRec(BOff);

              Case Current_Page of

                5  :  AddI1BtnClick(EditI1Btn);

                else  Begin

                        Display_Id(2);

                        If (IdLineActive) and (Not ExLocal.InAddEdit) then {*it must be readonly *}
                          IdLine.Show;
                      end;
              end; {Case..}

            end;

      1  :  Begin

              {* Show nominal/cc dep data *}
              Link2Nom;

              If (IdLine<>nil) and (IdLineActive) then
              With IdLine do
              Begin
                If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit)
                and (Id.ABSLineNo<>ExLocal.LId.ABSLineNo) then
                Begin
                  Display_Id(0);
                end;
              end;

              With Id do
                SendToObjectStkEnq(StockCode,MLocStk,CustCode,Currency,-1,0);
            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      7  :  NoteUpDate; {* Update note line count *}

      8  :  ;  {Pay in line update *}

     17  :  Begin {* Force reset of form *}
              GotCoord:=BOff;
              SetDefault:=BOn;
              Close;
            end;

     25  :  Begin
              NeedCUpdate:=BOn;
              FColorsChanged := True;
            End;

    100,
    101  :  With MULCtrlO do
            Begin
              // MH 23/03/2015 v7.0.14 ABSEXCH-16288: Moved before the update of the totals below, as that caused the list to fail to update
              AddNewRow(MUListBoxes[0].Row,(LParam=1));

              If (IdLine<>nil) then
              With ExLocal do
              Begin
                LInv:=IdLine.ExLocal.LInv;
                OutInvTotals(Current_Page);

                ReCalcTot:=BOn;

                If (LastEdit) then
                  ForceStore:=(ForceStore or (LInv.InvNetVal<>LastInv.InvNetVal) or
                                (LInv.DiscAmount<>LastInv.DiscAmount) or
                                (LInv.InvVAT<>LastInv.InvVAT) or
                                ((LId.QtyPick<>IdLine.ExLocal.LId.QtyPick) and (LInv.InvDocHed In PSOPSet)) or
                               (LInv.ILineCount<>LastInv.ILineCount));
              end;

              // MH 23/03/2015 v7.0.14 ABSEXCH-16288: Moved before the update of the totals below, as that caused the list to fail to update
              //AddNewRow(MUListBoxes[0].Row,(LParam=1));
            end;

     {$IFDEF RT_On}

       108  :  Begin

                 If (PayCtrl<>nil) then
                 With ExLocal do
                 Begin
                   LInv:=PayCtrl.ExLocal.LInv;
                   OutInvTotals(Current_Page);

                   If (LastEdit) then
                     ForceStore:=(ForceStore or (LInv.InvNetVal<>LastInv.InvNetVal) or
                                  (Linv.ILineCount<>LastInv.ILineCount) or
                                  (Linv.TotalInvoiced<>LastInv.TotalInvoiced));

                   SetCurrStat;
                 end;

                 InvBtnList.SetEnabBtn(BOn);

               end;
     {$ENDIF}

     120,121
         :  Begin

              InvBtnList.SetEnabBtn((WParam=120));

            end;

     130,
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
                OutInvTotals(Current_Page);
                ReCalcTot:=BOn;
              end;

            end;

     {$IFDEF FRM}

       170  :  Begin
                 {$B-}
                 //PR: 20/05/2014 ABSEXCH-2763 Add check for hook point 2000/151 (Print Transaction)
                 OK2Print := True;
                 If (Not ExLocal.InAddEdit) or ((Not CheckFormNeedStoreChk(Self,BOff)) and (ExLocal.LastEdit) and (Not ForceStore)) then
                 begin
                {$IFDEF CU}
                  If (EnableCustBtns(2000,151)) then
                    Ok2Print := ExecuteCustBtn(2000,151,ExLocal);
                {$ENDIF}
                  if Ok2Print then
                    PrintDocument(ExLocal,BOn);
                 end
                 {$B+}
                 else
                   mbRet:=CustomDlg(Application.MainForm,'Please note','Print Transaction',
                                    'This transaction may only be printed once it has been stored.'+#13+#13+
                                    'Please complete this transaction, and then choose print.',mtInformation,[mbOk]);

               end;

     {$ENDIF}

     171 :  Begin  {* Link for ObjectDrill *}
              MULCtrlO.GetSelRec(BOff);
              ExLocal.AssignToGlobal(InvF);
            end;

     175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

     176 :  Case LParam of
              0  :  Case Current_Page of
                      4  :  ;
                      5  :  {$IFDEF Rt_On}
                              If (Assigned(PayCtrl)) then
                                PayCtrl.MULCtrlO.SetListFocus;
                            {$ELSE}
                              ;
                            {$ENDIF}

                      6  :  {$IFDEF NP}
                              If (Assigned(NotesCtrl)) then
                                NotesCtrl.MULCtrlO.SetListFocus;
                            {$ELSE}
                              ;
                            {$ENDIF}

                      else  If (Assigned(MULCtrlO)) then
                              MULCtrlO.SetListFocus;

                    end; {Case..}
            end; {Case..}

     {$IFDEF RET}  {Message from Returns system indicating creation} {Temp turn on matching for ODrill as waiting for disk image to be updated}
       182  :      Begin
                     ExLocal.LInv.OrdMatch:=BOn;
                   end;

     {$ENDIF}
     200 :  Begin
              {* Detail Line Call *}

              {Self.Enabled:=BOn;
              Self.Show;}

              InvBtnList.SetEnabBtn(BOn);
              //PR: 24/09/2008 Re-enable OK buttons once line has been stored
              if not TransactionViewOnly then
              begin
                OkI5Btn.Enabled := True;
                OKI1Btn.Enabled := True;
              end;

              IdLine:=nil;
              IdLineActive:=BOff;


              MULCtrlO.SetListFocus;
            end;

     {$IFDEF Ltr}
       400,
       401  : Begin
                LetterActive:=Boff;
                LetterForm:=nil;
              end;
     {$ENDIF}

       1103
            : Begin {Link from Obj Stk Enq Equiv oppo hot link to auto create the line}
                If (Not Assigned(IdLine)) and (Not IdLineActive) then
                Begin
                  If (Current_Page<>0) then
                    ChangePage(0);

                  AddI1BtnClick(AddI1Btn);

                  If (Assigned(IdLine)) and (IdLineActive) then
                  Begin
                    SendMessage(IdLine.Handle,WM_CustGetRec,1101,LParam);

                  end;
                end;
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
                ShowLink(BOn,BOn);
              end;
            end;



    end; {Case..}

  end;
  Inherited;
end;

//-------------------------------------------------------------------------

Procedure TSalesTBody.WMRefreshButtons(Var Message : TMessage);
Var
  JiCInv : InvRec;
  sKey : Str255;
  Res : Integer;
Begin // WMRefreshButtons
  // Called from the Order Payments Payment and Refund dialogs after a Payment/Refund
  // is made to refresh the Payment/Refund buttons
  If ExLocal.LViewOnly Then
  Begin
    // MH 29/09/2014 ABSEXCH-15682: Reread the transaction to pickup any changes in the internal Order Payment flags

    // Save the global position as the ExLoacl uses the global posblocks
    With TBtrieveSavePosition.Create Do
    Begin
      Try
        // Save the current position in the file for the current key
        SaveFilePosition (InvF, GetPosKey);
        JiCInv := ExLocal.LInv;

        // Re-read the transaction
        sKey := FullNomKey(ExLocal.LInv.FolioNum);
        Res := Find_Rec(B_GetEq, F[InvF], InvF, ExLocal.LRecPtr[InvF]^, InvFolioK, sKey);
        If (Res <> 0) Then
          // Failed to load current version from DB, so restore original to ensure a valid record
          ExLocal.LInv := JiCInv;

        // Restore position in file
        RestoreSavedPosition;
      Finally
        Free;
      End; // Try..Finally
    End; // With TBtrieveSavePosition.Create

    // Update the buttons
    PrimeButtons;
  End; // If ExLocal.LViewOnly

  Inherited;
End; // WMRefreshButtons

//-------------------------------------------------------------------------

{$IFDEF JC}
  Procedure TSalesTBody.AutoShowJCPage;

  Begin

    If (Not fAutoJCPage) then
    Begin
      ChangePage(3);

      If (I4JobCodeF.Visible) and (I4JobCodeF.CanFocus) then
      Begin

        I4JobCodeF.SetFocus;

        fAutoJCPage:=BOn;
      end;
    end
    else
    Begin
      ChangePage(0);
      fAutoJCPage:=BOff;
      
      If (Assigned(MULCtrlO)) then
        MULCtrlO.SetListFocus;

    end;
  end;
{$ENDIF}

Procedure TSalesTBody.WMFormCloseMsg(Var Message  :  TMessage);

Var
  TmpInv  :  InvRec;

Begin


  With Message do
  Begin


    Case WParam of

      46  :  MatchOrdPtr:=nil;
      47  :  BackOrdPtr:=nil;

      {$IFDEF JC}
        //56  :  AutoShowJCPage;

      {$ENDIF}

      87  :  Begin
               I1TransDateF.DateModified:=BOn;

               I1TransDateFExit(I1AccF);
             end;

      88  :  If (ForceStore) or (ExLocal.LastEdit)  then
             Begin
               {$IFDEF STK}
                 TmpInv:=ExLocal.LInv;

                 // MH 15/06/2010 v6.4 ABSEXCH-2614: When called from the Transaction Header after changing
                 // the transaction date lines with Inclusive VAT need their net value reset so that VAT
                 // isn't deducted from the existing net value which has already had VAT taken from it -
                 // this causes the line value to drop each time the routine is run
                 //Re_CalcDocPrice(10+LParam,ExLocal.LInv);
                 Re_CalcDocPrice(10+LParam,ExLocal.LInv, False, True);

                 If (ExLocal.LastEdit) then
                   ForceStore:=(ForceStore or (ITotal(ExLocal.LInv)<>ITotal(TmpInv)));

                 MULCtrlO.PageUpDn(0,BOn);

                 OutInvTotals(Current_Page);

               {$ENDIF}


             end;


    end; {Case..}

  end;
  Inherited;
end;



Procedure TSalesTBody.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TSalesTBody.Send_UpdateList(Edit   :  Boolean;
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


procedure TSalesTBody.ShowLink(ShowLines,
                               VOMode    :  Boolean);
var
  lAnonStat: string;      // SSK 28/10/2017 ABSEXCH-19398: variable added
begin
  ExLocal.AssignFromGlobal(InvF);
  ExLocal.LGetRecAddr(InvF);

  {$IFDEF SOP}
    TTDHelper.ScanTransaction(ExLocal.LInv);
  {$ENDIF}

  With ExLocal,LInv do
  Begin
    // SSK 28/10/2017 ABSEXCH-19398: update caption for anonymisation
    lAnonStat := ' ';
    if GDPROn and (LInv.thAnonymised) then
      lAnonStat := lAnonStat + capAnonymised;
    Caption := DocNames[InvDocHed]+' Record - ' + Pr_OurRef(LInv) + lAnonStat;

    {$B-}

    LViewOnly:=SetViewOnly(ShowLines,VOMode);

    PrimeButtons;
    {$B+}

    //HV 05/12/2017 ABSEXCH-19535: Anonymised Transaction > The height of the window gets increased if "Save coordinates" is ticked
    if ShowLines or VOMode then
      FAnonymisationON := (GDPROn and (trim(LInv.OurRef) <> '') and LInv.thAnonymised)
    else
      FAnonymisationON := False;
    SetAnonymisationBanner;

    If (Not JustCreated) then {* Rebuild design based on doc type *}
    Begin
      DocHed:=LInv.InvDocHed;
      BuildDesign;
    end;

  end;


  OutInv;


  If (Not JustCreated) then {* Invoice already exisits *}
  Begin
    Case Current_Page of

      4  :  ReFreshFooter;

      else  Begin
              ChangeList(Current_Page,BOff);
              ReFreshList(ShowLines,Not JustCreated);
            end;

    end; {Case..}
  end
  else
    ReFreshList(ShowLines,Not JustCreated);




  {* Set any fields specific to doc type here *}

  {RPayF.Visible:=(Not RecordMode);
  Label833.Visible:=(Not RecordMode);}

  {$IFDEF NP}

    If (Current_Page=6) and (NotesCtrl<>nil) then {* Assume record has changed *}
    With ExLocal do
    Begin
      NotesCtrl.RefreshList(FullNomKey(LInv.FolioNum),NotesCtrl.GetNType);
      NotesCtrl.GetLineNo:=LInv.NLineCount;
    end;
  {$ENDIF}

  {$IFDEF RT_On}

    If (Current_Page=5) and (PayCtrl<>nil) then {* Assume record has changed *}
    With ExLocal do
    Begin
      PayCtrl.RefreshList(LInv.FolioNum);
    end;
  {$ENDIF}

  JustCreated:=BOff;

end;


procedure TSalesTBody.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(I1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(I1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(I1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(I1BtnPanel.Height);

  PagePoint[3].X:=I1BtnPanel.Height-(I1BSBox.Height);
  PagePoint[3].Y:=I1SBox.ClientHeight-(I1StkCodePanel.Height);

  PagePoint[4].X:=PageControl1.Width-(I1ListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(I1ListBtnPanel.Height);

  PagePoint[5].X:=PageControl1.Width-(TCNScrollBox.Width);
  PagePoint[5].Y:=PageControl1.Height-(TCNScrollBox.Height);

  PagePoint[6].X:=PageControl1.Height-(RcListBtnPanel.Height);
  PagePoint[6].Y:=PageControl1.Height-(TCNListBtnPanel.Height);


  GotCoord:=BOn;

end;


Function TSalesTBody.SetHelpC(PageNo :  Integer;
                              Pages  :  TIntSet;
                              Help0,
                              Help1  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    If (PageNo=6) then
      Result:=Help1
    else
      Result:=Help0;
  end
  else
    Result:=-1;

end;


procedure TSalesTBody.SetHelpContextIDsForPage; // NF: 07/04/06
const
  TAB_DATA_ENTRY = 0;
  TAB_ANALYSIS = 1;
  TAB_QTY_PICK = 2;
  TAB_JOB_VIEW = 3;
  TAB_FOOTER = 4;
  TAB_PAY_TO = 5;
  TAB_NOTES = 6;
  SalesTransactions = [SIN,SRC,SCR,SJI,SJC,SRF,SRI,SQU,SOR,SDN,SBT,SDG,SDT,SKF,SRN]; // NF: 08/05/06
var
  iOffSet : integer;
begin
  if DocHed in SalesTransactions // NF: 08/05/06
  then iOffSet := 5000
  else iOffSet := 0;

  {$IFDEF LTE}
    case PageControl1.ActivePage.PageIndex of
      TAB_DATA_ENTRY : begin
        PageControl1.ActivePage.HelpContext := iOffSet + 7;
        I1AccF.HelpContext := iOffSet + 238;
        I1YrRefF.HelpContext := iOffSet + 148;

//        I1YrRef2F.HelpContext := iOffSet + 240;
        I1YrRef2F.HelpContext := iOffSet + 2071; // NF: 24/07/06 NF: Changed as this was a duplicate of the SRC Your Ref Context ID

        I1AddrF.HelpContext := iOffSet + 230; // NF: 21/06/06 Sales / Purchase split
        I1EXRateF.HelpContext := iOffSet + 1846; // NF: 21/06/06 Splits it from the currency field
      end;
      TAB_ANALYSIS : begin
        PageControl1.ActivePage.HelpContext := iOffSet + 1671;
      end;
      TAB_QTY_PICK : begin
        PageControl1.ActivePage.HelpContext := iOffSet + 1672;
      end;
      TAB_JOB_VIEW : begin
        PageControl1.ActivePage.HelpContext := iOffSet + 1673;
      end;
      TAB_FOOTER : begin
        PageControl1.ActivePage.HelpContext := iOffSet + 1674;
      end;
      TAB_PAY_TO : begin
        PageControl1.ActivePage.HelpContext := iOffSet + 1675;
      end;
      TAB_NOTES : begin
        PageControl1.ActivePage.HelpContext := iOffSet + 1676;
      end;
    end;{case}

    HelpContext := PageControl1.ActivePage.HelpContext;
    PageControl1.HelpContext := PageControl1.ActivePage.HelpContext;
  {$ENDIF}

  // NF: 08/05/06 Fixes for incorrect Context IDs
  case PageControl1.ActivePage.PageIndex of
{      TAB_DATA_ENTRY : begin
      I1DelBtn.HelpContext := ?;
    end;}
    TAB_ANALYSIS : begin
      I2QtyF.HelpContext := iOffSet + 1701;
      I2StkDescF.HelpContext := iOffSet + 1702;
    end;

    TAB_FOOTER : begin
      I5Net1F.HelpContext := iOffSet + 1847;
      I5VAT1F.HelpContext := I5Net1F.HelpContext;
      I5Disc1F.HelpContext := I5Net1F.HelpContext;
      I5Tot1F.HelpContext := I5Net1F.HelpContext;
      I5Net2F.HelpContext := I5Net1F.HelpContext;
      I5VAT2F.HelpContext := I5Net1F.HelpContext;
      I5Disc2F.HelpContext := I5Net1F.HelpContext;
      I5Tot2F.HelpContext := I5Net1F.HelpContext;
    end;
  end;{case}
end;


procedure TSalesTBody.PrimeButtons;

Var
  PageNo  :  Integer;
{$IFDEF CU}
  // 25/01/2013 PKR ABSEXCH-13449
  cBtnIsEnabled : Boolean;
{$ENDIF}
  sKey : Str255;
  Res : Integer;
{$IFDEF SOP}
  iOPRefundInfo : IOrderPaymentsTransactionPaymentInfo;
  iOPPaymentInfo : IOrderPaymentsTransactionInfo;
  iOPTransactionPaymentInfo : IOrderPaymentsTransactionPaymentInfo;
{$ENDIF SOP}
Begin
  PageNo:=Current_Page;

  If (InvBtnList=nil) then
  Begin
    InvBtnList:=TVisiBtns.Create;

    try

      With InvBtnList do
        Begin
     {00} AddVisiRec(AddI1Btn,BOff);
     {01} AddVisiRec(EditI1Btn,BOff);
     {02} AddVisiRec(InsI1Btn,BOff);
     {03} AddVisiRec(DelI1Btn,BOff);
     {04} AddVisiRec(MatI1Btn,BOff);
     {05} AddVisiRec(FindI1Btn,BOff);
     {06} AddVisiRec(BkOrdI1Btn,BOff);
     {07} AddVisiRec(APickI1Btn,BOff);
     {08} AddVisiRec(SwiI1Btn,BOff);
     {09} AddVisiRec(StatI1Btn,BOff);
     {10} AddVisiRec(WORI1Btn,BOff);
     {11} AddVisiRec(RETI1Btn,BOff);
     {12} AddVisiRec(LnkI1Btn,BOff);
     {13} AddVisiRec(btnApplyTTD,BOff);

     // MH 20/05/2015 v7.0.14 ABSEXCH-16284: Added Cancel PPD button
     {14} AddVisiRec(btnCancelPPD,BOff);

     // MH 27/08/2014 v7.X Order Payments: Added Payment and Refund buttons
     {15} AddVisiRec(btnOPPayment,BOff);
     {16} AddVisiRec(btnOPRefund,BOff);

     // 29/01/2013 PKR ABSEXCH-13449.  NOTE: This form uses the button's TextId
     //  field to get its caption.  Just to be different.  It would actually make
     //  sense for all forms to do the same.
     {17} AddVisiRec(CustTxBtn1,BOff);
     {18} AddVisiRec(CustTxBtn2,BOff);
          // 17/01/2013 PKR ABSEXCH-13449
          // Custom buttons 3..6 now available
     {19} AddVisiRec(CustTxBtn3,BOff);
     {20} AddVisiRec(CustTxBtn4,BOff);
     {21} AddVisiRec(CustTxBtn5,BOff);
     {22} AddVisiRec(CustTxBtn6,BOff);
        end; {With..}

    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  try

    With InvBtnList do
    Begin
      SetHideBtn(0,((ExLocal.LViewOnly) and ((PageNo<>6) or (fRecordLocked))) ,BOff);

      SetHideBtn(1,((ExLocal.LViewOnly) and (PageNo=6) and (fRecordLocked)) ,BOff);

      {SetHideBtn(1,IdLineActive,BOff);}

      SetBtnHelp(0,SetHelpC(PageNo,[0..6],260,88));
      SetBtnHelp(1,SetHelpC(PageNo,[0..6],261,87));


      SetHideBtn(2,((Not IdButton(0).Visible) or (PageNo=5)) ,BOff);

      SetBtnHelp(2,SetHelpC(PageNo,[0..6],262,86));

      SetHideBtn(3,(Not IdButton(0).Visible) ,BOff);

      SetBtnHelp(3,SetHelpC(PageNo,[0..6],263,89));


      {$IFNDEF SOP}
        SetHideBtn(4,BOn,BOff);
      {$ELSE}
        SetHideBtn(4,((Not (DocHed In OrderSet)) or (PageNo>3)) or ((Not ExLocal.LastEdit) and (Not ExLocal.LViewOnly)) ,BOff);
      {$ENDIF}

      {$IFNDEF STK}
        SetHideBtn(5,BOn,BOff);
      {$ELSE}
        SetHideBtn(5,(PageNo>3),BOff);
      {$ENDIF}


      SetHideBtn(6,((Not (DocHed In OrderSet)) or (PageNo>3)) or (ExLocal.LViewOnly),BOff);

      {SetHideBtn(7,((Not MatI1Btn.Visible) or (ExLocal.LViewOnly)) or
                   ((Not ChkAllowed_In(160)) and (DocHed =SOR)) or
                   ((Not ChkAllowed_In(170)) and (DocHed =POR)),BOff);}

      SetHideBtn(7,((Not BkOrdI1Btn.Visible) or (ExLocal.LViewOnly)) or
                   ((Not ChkAllowed_In(160)) and (DocHed =SOR)) or
                   ((Not ChkAllowed_In(170)) and (DocHed =POR)),BOff);

      SetHideBtn(8,(PageNo<>6),BOff);

      SetHideBtn(9,(PageNo<>5),BOff);

      SetHideBtn(10,(PageNo In [4..6]) or (DocHed<>SOR) or (Not FullWOP) or
                    (Not ChkAllowed_In(354))
                    or ((Not ExLocal.LastEdit) and (Not ExLocal.LViewOnly)),BOff);

      SetHideBtn(11,(PageNo In [4..6]) or (Not (DocHed In StkRetGenSplit-[SOR,POR])) or (Not RetMOn) or
                    ((Not ChkAllowed_In(505)) and (DocHed=SIN)) or
                    ((Not ChkAllowed_In(506)) and (DocHed=PIN)) or
                    ((Not ChkAllowed_In(507)) and (DocHed=SOR)) or
                    ((Not ChkAllowed_In(508)) and (DocHed=POR)) or
                     ((Not ExLocal.LastEdit) and (Not ExLocal.LViewOnly)),BOff);

      SetHideBtn(12,(PageNo In [4..6]),BOff);

      // btnApplyTTD
      {$IFDEF SOP}
        SetHideBtn(13,(PageNo <> 0) Or (Not TTDHelper.TTDEnabled) Or ExLocal.LViewOnly, BOff);
        btnApplyTTD.Enabled := Not TTDHelper.ApplyTTD;
      {$ELSE}
        SetHideBtn(13,True,BOff);
      {$ENDIF}

      // MH 20/05/2015 v7.0.14 ABSEXCH-16284: Added Cancel PPD button
      // Hide if not on main page, PPD Not Taken or we aren't in View mode
      If (PageNo = 0) And (ExLocal.LInv.thPPDTaken <> ptPPDNotTaken) And ExLocal.LViewOnly Then
      Begin
        // Check user permissions - need to identify account type (Cust/Cons/Supp) from the trader
        // record, but this routine is called multiple times and sometimes the transaction isn't
        // loaded so we need to check what we have available
        If (Trim(ExLocal.LInv.CustCode) <> '') Then
        Begin
          If (ExLocal.LCust.CustCode <> ExLocal.LInv.CustCode) Then
          Begin
            // Have transaction (as far as we can tell), but the trader needs to be loaded
            sKey := FullCustCode(ExLocal.LInv.CustCode);
            Find_Rec(B_GetEq, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, sKey);
          End; // If (ExLocal.LCust.CustCode <> ExLocal.LInv.CustCode)

          // Check the trader is correctly loaded
          If (ExLocal.LCust.CustCode = ExLocal.LInv.CustCode) Then
          Begin
            // Check users Allocate permission for the account type
            If (ExLocal.LCust.acSubType = CUSTOMER_CHAR) Then
              SetHideBtn(14, Not ChkAllowed_In(uaCustomerAllocate), BOff)
            Else If (ExLocal.LCust.acSubType = CONSUMER_CHAR) Then
              SetHideBtn(14, Not ChkAllowed_In(uaConsumerAllocate), BOff)
            Else If (ExLocal.LCust.acSubType = SUPPLIER_CHAR) Then
              SetHideBtn(14, Not ChkAllowed_In(uaSupplierAllocate), BOff)
            Else
              // unknown type - disable button
              SetHideBtn(14, bHideButton, bDontOrganiseButtons)
          End // If (ExLocal.LCust.CustCode = ExLocal.LInv.CustCode)
          Else
            // trader not loaded
            SetHideBtn(14, bHideButton, bDontOrganiseButtons)
        End // If (ExLocal.LCust.CustCode = ExLocal.LInv.CustCode)
        Else
          // Transaction/Account not loaded - disable button
          SetHideBtn(14, bHideButton, bDontOrganiseButtons)
      End // If (PageNo = 0) And (ExLocal.LInv.thPPDTaken <> ptPPDNotTaken) And ExLocal.LViewOnly
      Else
        // Hide button
        SetHideBtn(14, bHideButton, bDontOrganiseButtons);

      {$IFDEF SOP}
      // This routine is called twice, the first time is before ExLocal.LInv has been populated so we can ignore that
      // MH 07/10/2014 ABSEXCH-15709: Modified Payment/Refund buttons to only show on the "Data Entry", "Analysis", "Qty/Pick" and "Job-View" tabs
      If (PageNo In [0..3]) And  Syss.ssEnableOrderPayments And (ExLocal.LInv.InvDocHed In [SOR, SDN, SIN]) And ExLocal.LViewOnly And (ExLocal.LInv.thOrderPaymentElement In [opeOrder, opeDeliveryNote, opeInvoice]) Then
      Begin
        // MH 19/09/2014 ABSEXCH-15639: Whoops! Check user permissions
        If ((ExLocal.LInv.InvDocHed = SOR) And PChkAllowed_In(uaSORAllowOrderPaymentsPayment)) Or
           ((ExLocal.LInv.InvDocHed = SDN) And PChkAllowed_In(uaSDNAllowOrderPaymentsPayment)) Or
           ((ExLocal.LInv.InvDocHed = SIN) And PChkAllowed_In(uaSINAllowOrderPaymentsPayment)) Then
        Begin
          // Create a Payment Info instance to determine the transactions payment state
          iOPPaymentInfo := OPTransactionInfo (ExLocal.LInv);
          Try
            // Order Payments - Payment Button
            SetHideBtn(15, Not iOPPaymentInfo.CanTakePayment, BOff);
          Finally
            iOPPaymentInfo := NIL;
          End; // Try..Finally
        End; // If ((ExLocal.LInv.InvDocHed = SOR) And PChkAllowed_In(...

        // MH 19/09/2014 ABSEXCH-15639: Whoops! Check user permissions
        // MH 29/09/2014 ABSEXCH-15682: Added check on thOrderPaymentFlags
        // MH 30/09/2014 ABSEXCH-15682: Fixed check on thOrderPaymentFlags
        If (
             ((ExLocal.LInv.InvDocHed = SOR) And ((ExLocal.LInv.thOrderPaymentFlags And thopfPaymentTaken) = thopfPaymentTaken))
             Or
             // MH 01/07/2015 2015-R1 ABSEXCH-16619: Added check for Credit Card Payments
             ((ExLocal.LInv.InvDocHed = SOR) And ((ExLocal.LInv.thOrderPaymentFlags And thopfCreditCardPaymentTaken) = thopfCreditCardPaymentTaken))
             Or
             (ExLocal.LInv.InvDocHed = SIN)
           )
           And
           (
             ((ExLocal.LInv.InvDocHed = SOR) And PChkAllowed_In(uaSORAllowOrderPaymentsRefund)) Or
             ((ExLocal.LInv.InvDocHed = SIN) And PChkAllowed_In(uaSINAllowOrderPaymentsRefund))
           ) Then
        Begin
          iOPRefundInfo := OPTransactionPaymentInfo (ExLocal.LInv);
          Try
            // Order Payments - Refund Button
            SetHideBtn(16, Not iOPRefundInfo.CanGiveRefund, BOff);
          Finally
            iOPRefundInfo := NIL;
          End; // Try..Finally
        End; // If ((ExLocal.LInv.InvDocHed = SOR) And PChkAllowed_In(...
      End // If (PageNo In [0..3]) And  Syss.ssEnableOrderPayments And (ExLocal.LInv.InvDocHed In [SOR, SDN, SIN]) And ExLocal.LViewOnly And (ExLocal.LInv.thOrderPaymentElement In [opeOrder, opeDeliveryNote, opeInvoice])
      Else
      {$ENDIF}
      Begin
        SetHideBtn(15,True,BOff);  // Order Payments Payment
        SetHideBtn(16,True,BOff);  // Order Payments Refund
      End; // Else

      // CJS 2014-09-02 - v7.x Order Payments - T111 - Edit SOR - Disable nominated TH/TL fields and buttons if payments detected
      {$IFDEF SOP}
      If Syss.ssEnableOrderPayments And (ExLocal.LInv.InvDocHed In [SOR, SDN, SIN]) And (ExLocal.LInv.thOrderPaymentElement In [opeOrder, opeDeliveryNote, opeInvoice]) Then
      begin
        iOPTransactionPaymentInfo := OPTransactionPaymentInfo(ExLocal.LInv);
        Try
          if iOPTransactionPaymentInfo.GetPaymentCount > 0 then
          begin
            if (btnApplyTTD.Visible) then
              SetHideBtn(13, True, BOff);
            if (DelI1Btn.Visible) then
              SetHideBtn(3, True, BOff);
          end;
        Finally
          iOPTransactionPaymentInfo := NIL;
        End; // Try..Finally
      end;
      {$ENDIF}

      {$IFDEF CU}
        // 24/01/2013 PKR ABSEXCH-13449
        // Use the new custom button handler.  Set up some basic information.
        if DocHed In PurchSplit then
          formPurpose := fpPurchaseTransaction
        else
          formPurpose := fpSalesTransaction;

        // 24/01/2013 PKR ABSEXCH-13449
        // Use the custom button handler to display or hide the custom buttons.
        // Determine whether we're in View or Edit mode.
        if ExLocal.LViewOnly then
          recordState := rsView
        else
          recordState := rsEdit;

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn1.Tag);
        {14}  SetHideBtn(17, not cBtnIsEnabled, BOff);

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn2.Tag);
        {15}  SetHideBtn(18, not cBtnIsEnabled, BOn);

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn3.Tag);
        {16}  SetHideBtn(19, not cBtnIsEnabled, BOn);

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn4.Tag);
        {17}  SetHideBtn(20, not cBtnIsEnabled, BOn);

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn5.Tag);
        {18}  SetHideBtn(21, not cBtnIsEnabled, BOn);

              cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustTxBtn6.Tag);
        {19}  SetHideBtn(22, not cBtnIsEnabled, BOn);


              try

                //PR: 26/02/2013 ABSEXCH-14079 Change to use button handler to get correct text ids. Moved
                //                             here from FormCreate so RecordState is set correctly

                CustTxBtn1.TextId := CustBtnHandler.GetTextID(FormPurpose, 0, RecordState, 1);
                CustTxBtn2.TextId := CustBtnHandler.GetTextID(FormPurpose, 0, RecordState, 2);
                CustTxBtn3.TextId := CustBtnHandler.GetTextID(FormPurpose, 0, RecordState, 3);
                CustTxBtn4.TextId := CustBtnHandler.GetTextID(FormPurpose, 0, RecordState, 4);
                CustTxBtn5.TextId := CustBtnHandler.GetTextID(FormPurpose, 0, RecordState, 5);
                CustTxBtn6.TextId := CustBtnHandler.GetTextID(FormPurpose, 0, RecordState, 6);

                EntCustom3.Execute;
              except
                ShowMessage('Customisation Control Failed to initialise');
              end;


      {$ELSE}
        {14}  SetHideBtn(17,BOn,BOff);
        {15}  SetHideBtn(18,BOn,BOn);
              // 24/01/2013 PKR ABSEXCH-13449
        {16}  SetHideBtn(19,BOn,BOn);
        {17}  SetHideBtn(20,BOn,BOn);
        {18}  SetHideBtn(21,BOn,BOn);
        {19}  SetHideBtn(22,BOn,BOn);

      {$ENDIF}

      If (IdLineActive) and (PageNo<>6) then {* Reset during a line edit *}
        InvBtnList.SetEnabBtn(BOff);

    end;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

procedure TSalesTBody.BuildMenus;

Begin

  {$IFDEF SOP}
    CreateSubMenu(PopUpMenu2,AutoPick1);
  {$ENDIF}

end;


procedure TSalesTBody.PrimeExtList;

Begin
  ExtList[1]:=I1YrRef2F;

  ExtList[11]:=I4JobCodeL;
  ExtList[12]:=I4JobCodeF;
  ExtList[13]:=I4JAnalL;
  ExtList[14]:=I4JobAnalF;
  ExtList[15]:=bevBelowJob;  // Keep in sync with JCBreak below

  ExtList[16]:=lblOverrideLocation;
  ExtList[17]:=edtOverrideLocation;
  ExtList[18]:=bevBelowOverrideLocation;  // Keep in sync with OLBreak below

  ExtList[19]:=UDF1L;
  ExtList[21]:=UDF2L;
  ExtList[23]:=UDF3L;
  ExtList[25]:=UDF4L;
  ExtList[20]:=THUD1F;
  ExtList[22]:=THUD2F;
  ExtList[24]:=THUD3F;
  ExtList[26]:=THUD4F;

  //v6.9 New user defined fields
  ExtList[27] := lblUdf5;
  ExtList[28] := edtUdf5;
  ExtList[29] := lblUdf6;
  ExtList[30] := edtUdf6;
  ExtList[31] := lblUdf7;
  ExtList[32] := edtUdf7;
  ExtList[33] := lblUdf8;
  ExtList[34] := edtUdf8;
  ExtList[35] := lblUdf9;
  ExtList[36] := edtUdf9;
  ExtList[37] := lblUdf10;
  ExtList[38] := edtUdf10;
  // PKR. 24/03/2016. ABSEXCH-17383. eRCT support. Add 2 more UDFs
  ExtList[39] := lblUdf11;
  ExtList[40] := edtUdf11;
  ExtList[41] := lblUdf12;
  ExtList[42] := edtUdf12;
end;


Procedure TSalesTBody.ResetExtFL;

Var
  n  :  Integer;

Begin
    {$B-}
  If (Assigned(TransExtForm1.FocusLast)) and  ((Not TransExtForm1.FocusLast.Visible)  or (Not TransExtForm1.FocusLast.Enabled)) then
    For n:=High(ExtList) downto Low(ExtList) do
    Begin

      If ((ExtList[n] is Text8pt) or (ExtList[n] is TCurrencyEdit)) and (ExtList[n].Visible) and (ExtList[n].Enabled)  then
      Begin
    {$B+}
        TransExtForm1.FocusLast:=TWinControl(ExtList[n]);
        Break;
      end;
    end;


end;


Procedure TSalesTBody.ShuntExt;

Const
  ISBreak = 10;  // Index of bevBelowIntrastat in ExtList
  JCBreak = 15;  // Index of bevBelowJob in ExtList
  OLBreak = 18;  // Index of bevBelowOverrideLocation in ExtList

Var
  n,
  Gap  :  Integer;

  FoundUD1
       :  Boolean;

  VisibleUDs : Integer;


Begin
  FoundUd1:=BOff;

  // Job Code & Analysis Code
  If (Not bevBelowJob.Visible) then
  Begin
    Gap:=bevBelowJob.Top-Bevel1.Top;

    If (Gap>0) then
    Begin
      For n:= JCBreak to High(ExtList) do
        If (Assigned(ExtList[n])) then
        Begin
          ExtList[n].Top:=ExtList[n].Top-Gap;
        end;

      TransExtForm1.ExpandedHeight:=TransExtForm1.ExpandedHeight-Gap;
    end;
  end;

  // Override Location field
  If (Not bevBelowOverrideLocation.Visible) then
  Begin
    Gap:=bevBelowOverrideLocation.Top-bevBelowJob.Top;

    If (Gap>0) then
    Begin
      For n:= OLBreak to High(ExtList) do
        If (Assigned(ExtList[n])) then
        Begin
          ExtList[n].Top:=ExtList[n].Top-Gap;
        end;

      TransExtForm1.ExpandedHeight:=TransExtForm1.ExpandedHeight-Gap;
    end;
  end;
  
  //HV 23/11/2017 2018-R1 ABSEXCH-19405: procedure to set a Highlighting PII Fields flag for GDPR
  if JustCreated then
    SetUDFields(DocHed);
  //Resize drop down thingy according to how many user defined fields are visible
  // PKR. 24/03/2016. ABSEXCH-17383. eRCT support.  Added 2 new UDFs.
  VisibleUDs := NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, edtUdf5, edtUdf6, edtUdf7, edtUdf8, edtUdf9, edtUdf10, edtUdf11, edtUdf12]);

  // PKR. 24/03/2016. ABSEXCH-17383. eRCT support.
  // Updated limit on visible UDFs.
  if VisibleUDs < 11 then
  begin
    {SS 25/04/2016 2016-R2 ABSEXCH-13462:
    When F8 Search set to 'Document' tab, headers of the drilled transactions cannot keep open the expanded view showing
    the UDF fields if fewer than all 10 fields are set to display in Utilities: System Setup.
    - While scrolling records from findrec, value of TransExtForm1.ExpandedHeight reduces everytime.}
    if FOldExpandedHeight = 0 then
      FOldExpandedHeight := TransExtForm1.ExpandedHeight
    else
      TransExtForm1.ExpandedHeight := FOldExpandedHeight;
    
    //PR: 28/10/2011 Amended algorithm for calculating expanded height
    TransExtForm1.ExpandedHeight := TransExtForm1.ExpandedHeight - (25 * (6 - ((VisibleUDs + 1) div 2)));
  end;

  // Check if any user defined fields are visible
(*  For n:=19 to High(ExtList) do
  Begin

    If (ExtList[n].Visible) then
    Begin
      FoundUD1:=BOn;
      Break;
    end;

  end;

  // Hide user defined fields
  If (Not FoundUD1) then
  Begin
    TransExtForm1.ExpandedHeight:=TransExtForm1.ExpandedHeight-50;
    bevBelowIntrastat.Visible:=BOff;
  end; *)

end;


procedure TSalesTBody.Show_IntraStat(IsVisible,
                                     IsEnabled    :  Boolean);

Begin
  ResetExtFL;
  // CJS 2016-01-20 - ABSEXCH-17153 - Hide Intrastat controls when Intrastat is disabled
  pnlIntrastat.Visible := IsVisible;
end;

//PR: 11/10/2011 Rewrote this procedure to deal with new custom fields for 6.9
//PR: 11/11/2011 Amended to use centralised function EnableUdfs in CustomFieldsIntf.pas ABSEXCH-12129
procedure TSalesTBody.SetUDFields(UDDocHed  :  DocTypes);
begin
{$IFDEF ENTER1}
  // PKR. 24/03/2016. ANSEXCH-17383. eRCT support.  Added 2 new UDFs + labels
  EnableUdfs([UDF1L, UDF2L, UDF3L, UDF4L, lblUdf5, lblUdf6, lblUdf7, lblUdf8, lblUdf9, lblUdf10, lblUdf11, lblUdf12],
             [THUD1F, THUD2F, THUD3F, THUD4F, edtUdf5, edtUdf6, edtUdf7, edtUdf8, edtUdf9, edtUdf10, edtUdf11, edtUdf12],
             DocTypeToCFCategory(UDDocHed));
{$ENDIF}
end;

// CJS 2013-11-27 - MRD1.1.17 - Consumer Support
procedure TSalesTBody.ResizeAcCodeField(ForConsumer: Boolean);
begin
  if Syss.ssConsumersEnabled and ForConsumer then
  begin
    lblAcCode.Left := 4;
    I1AccF.Left := 25;
    I1AccF.Width := 263;
    I1AddrF.Top := 33;
    I1AddrF.Height := 48;
  end
  else
  begin
    lblAcCode.Left := 184;
    I1AccF.Left := 208;
    I1AccF.Width := 80;
    I1AddrF.Top := 7;
    I1AddrF.Height := 74;
  end;
  // Force a re-positioning of the drop-down/pop-up arrows
  I1AccF.PosArrows;
end;

procedure TSalesTBody.BuildDesign;

Var
  HideCC  :  Boolean;

begin

  HideCC:=BOff;

  // CJS 2013-11-27 - MRD1.1.17 - Consumer Support
  {
  if (self.ExLocal.LastEdit) and (IsConsumer(Cust)) then
    ResizeAcCodeField(True)
  else
    ResizeAcCodeField(False);
  }
  ResizeAcCodeField(DocHed in SalesSplit);

  {* Set Version Specific Info *}

  {$IFNDEF MC_On}
    I1CurrLab.Visible:=BOff;
    I1CurrF.Visible:=BOff;
    I1ExRateF.Visible:=BOff;
    I1ExLab.Visible:=BOff;
    I5VRateL.Visible:=BOff;
    I5VRateF.Visible:=BOff;
    FixXRF.Visible:=BOff;

  {$ELSE}
    {$IFDEF LTE}
      I1ExRateF.BlockNegative:=BOn;
    {$ENDIF}
  {$ENDIF}


  JobPage.TabVisible:=(JBCostOn or JBFieldOn);

  I4JobCodeF.Visible:=JobPage.TabVisible;
  I4JobCodeL.Visible:=JobPage.TabVisible;

  I4JAnalL.Visible:=JobPage.TabVisible;
  I4JobAnalF.Visible:=JobPage.TabVisible;
  bevBelowJob.Visible:=JobPage.TabVisible;

  PayPage.TabVisible:=(DocHed In DirectSet);



  If (DocHed In DirectSet) then
    PayPage.Caption:='Pay '+PayF2Tit[(DocHed In PayF2Set)];

  {$IFNDEF PF_On}
    I1CCF.Visible:=BOff;
    I1CCLab.Visible:=BOff;

    I1DepF.Visible:=BOff;
    I1DepLab.Visible:=BOff;

    AutoPage.TabVisible:=BOff;
    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}

  I1CCLab.Visible:=Not HideCC;
  I1CCF.Visible:=Not HideCC;
  I1DepLab.Visible:=Not HideCC;
  I1DepF.Visible:=Not HideCC;

  I3CCLab.Visible:=Not HideCC;
  I3CCF.Visible:=Not HideCC;
  I3DepLab.Visible:=Not HideCC;
  I3DepF.Visible:=Not HideCC;

  I4CCLab.Visible:=Not HideCC;
  I4CCF.Visible:=Not HideCC;
  I4DepLab.Visible:=Not HideCC;
  I4DepF.Visible:=Not HideCC;

  {$IFNDEF STK}
    I2StkDescLab.Visible:=BOff;
    I2StkDescF.Visible:=BOff;
    I2QtyLab.Visible:=BOff;
    I2QtyF.Visible:=BOff;
    I3StkCodeLab.Visible:=BOff;
    I3StkCodeF.Visible:=BOff;
  {$ENDIF}

  {$IFNDEF SOP}
    I1LocnLab.Visible:=BOff;
    I1LocnF.Visible:=BOff;
    I3LocnLab.Visible:=BOff;
    I3LocnF.Visible:=BOff;

    QtyPPage.TabVisible:=BOff;
    I1LocnLab.Visible:=BOff;
    I1LocnF.Visible:=BOff;

  {$ELSE}

    QtyPPage.TabVisible:=(DocHed In OrderSet);

    If (DocHed In PurchSplit) and (QtyPPage.TabVisible) then
    Begin
      QtyPPage.Caption:='Qty/Receive';
      I3QPKLab.Caption:='Received  ';
      AP1.Caption:='R&eceive';
    end
    else
    Begin
      QtyPPage.Caption:='Qty/Pick';
      I3QPKLab.Caption:='Picked   ';
      AP1.Caption:='&Pick';
    end;

    I1DueDateF.Visible:=(Not (DocHed In DeliverSet));
    I1DueDateL.Visible:=I1DueDateF.Visible;

  {$ENDIF}

  {Find_FormCoord;}

  {$IFDEF SOP}
    // Override Location only available if enabled in System Setup and its a Purchase
    lblOverrideLocation.Visible := Syss.EnableOverrideLocations And (DocHed In PurchSplit);
    edtOverrideLocation.Visible := lblOverrideLocation.Visible;
    bevBelowOverrideLocation.Visible := lblOverrideLocation.Visible;
    //edtOverrideLocation.Enabled := lblOverrideLocation.Visible And FirstStore;  // NOTE: This can't be done here as we don't know whether it is an add/edit/etc... yet
  {$ELSE}
    lblOverrideLocation.Visible := False;
    edtOverrideLocation.Visible := False;
    bevBelowOverrideLocation.Visible := False;
  {$ENDIF}


  // Show_IntraStat(Syss.IntraStat or JBFieldOn,BOn);

  ShuntExt;

  {$IFDEF MC_On}

    Set_DefaultCurr(I1CurrF.Items,BOff,BOff);
    Set_DefaultCurr(I1CurrF.ItemsL,BOff,BOn);

    FixXRF.Visible:=(DocHed In OrderSet) and (UseCoDayRate);

  {$ENDIF}


  { Allow the user to search for a customer by name (by typing forward-slash
    followed by all or part of the name). }
  I1AccF.MaxLength := CustCompLen + 1;

  I1YrRefF.MaxLength  := DocYRef1Len;
  I1YrRef2F.MaxLength := DocYRef2Len;

  {I4JobCodeF.MaxLength:=JobKeyLen;
  I4JobAnalF.MaxLength:=AnalKeyLen;}


  If (DocHed In OrderSet) then
  Begin
    I1DueDateL.Caption:='Del';
    I5NBL.Visible:=BOn;
    I5NBF.Visible:=BOn;
  end
  else
  Begin
    I1DueDateL.Caption:='Due';

    I5NBL.Visible:=BOff;
    I5NBF.Visible:=BOff;
  end;

  {
    CJS 18/01/2011 - Added new controls for Week/Month, and activated on PINs
    and PORs (previously this re-used the Box Label fields, and was only active
    for PINs).
  }
  //if (DocHed in [PIN, POR]) then
  if (DocHed = PIN) or (WebExtEProcurementOn and (DocHed = POR)) then
  begin
    WkMonthLbl.Visible := True;
    WkMonthEdt.Visible := True;
  end
  else
  begin
    WkMonthLbl.Visible := False;
    WkMonthEdt.Visible := False;
  end;

  If (DocHed In PurchSplit) then
    I2CostLab.Caption:='Uplift'
  else
    I2CostLab.Caption:='Cost';

  I1MargLab.Visible:=Show_CMG(DocHed);
  I1GPLab.Visible:=I1MargLab.Visible;

  // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
  DisplayPPDFields;

end;

//-------------------------------------------------------------------------

// MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
Function TSalesTBody.ShowPPDFields : Boolean;
Begin // ShowPPDFields
  // Filter by transaction type
  Result := (DocHed In PPDTransactions);

  // Look at PPD Mode on account (if loaded) - need to format LInv.CustCode as it may contain exactly what the user typed, e.g. lowercase!
  If Result And (Trim(ExLocal.LCust.CustCode) <> '') And (FullCustCode(ExLocal.LCust.CustCode) = FullCustCode(ExLocal.LInv.CustCode)) Then
    // MH 26/08/2015 2015-R1 ABSEXCH-16790: Take PPD Percentage/Days from Head Office where applicable
    Result := (PPDMode <> pmPPDDisabled);
End; // ShowPPDFields

//------------------------------

// MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
Procedure TSalesTBody.DisplayPPDFields;
Begin // DisplayPPDFields
  // MH 27/05/2015 v7.0.14: Added the No-PPD Page to allow for a different listview layout
  //                        without having to do it all at runtime
  If ShowPPDFields Then
  Begin
    // Prompt Payment Discount
    nbSettleDisc.PageIndex := PromptPaymentDiscountPage;

    // Only show the status information on Invoices - you cannot take PPD against any other
    // transactions so it doesn't make sense
    shapePPDStatus.Visible := lblPromptPaymentDiscountHeader.Visible And (DocHed In [SIN, SJI, PIN, PJI]);
    lblPPDStatus.Visible := shapePPDStatus.Visible;
  End // If ShowPPDFields
  Else
    // Prompt Payment Discount Disabled by Transaction Type or Account
    nbSettleDisc.PageIndex := NoPromptPaymentDiscountPage;
End; // DisplayPPDFields

//------------------------------

// MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
Procedure TSalesTBody.UpdatePPDStatusInfo;
Begin // UpdatePPDStatusInfo
  With ExLocal.LInv Do
  Begin
    Case thPPDTaken Of
      ptPPDNotTaken          : Begin
                                 // MH 28/05/2015 v7.0.14 ABSEXCH-16468: Zero value SIN showing 'Status: Available'
                                 // PR: 03/06/2015 v7.0.14 ABSEXCH-16486 Zero vat invoice showing 'Status: Not Available'
                                 If (thPPDPercentage <> 0.0) And (thPPDGoodsValue <> 0.0) Then
                                 Begin
                                   // Check Transaction's Oustanding Value equals/exceeds the PPD Value
                                   //PR: 03/06/2015 ABSEXCH-16476 Remove sign so comparision works for Purchase transactions
                                   If (Abs(CurrencyOS(ExLocal.LInv, True {Round to 2dp}, False {Convert to Base}, False {UseCODay})) >= Round_Up(ExLocal.LInv.thPPDGoodsValue + ExLocal.LInv.thPPDVATValue, 2)) Then
                                   Begin
                                     // PPD Value is <= Outstanding Value so it could still be taken
                                     If (CalcDueDate(TransDate, thPPDDays) >= Today) Then
                                       lblPPDStatus.Caption := 'Status: Available'
                                     Else
                                       lblPPDStatus.Caption := 'Status: Expired';
                                   End // If (CurrencyOS(ExLocal.LInv, ...
                                   Else
                                     // Transaction's Outstanding value is less than the PPD Value so it can no longer be taken
                                     lblPPDStatus.Caption := 'Status: Not Taken';
                                 End // If (thPPDPercentage <> 0.0) And (thPPDGoodsValue <> 0.0) And (thPPDVATValue <> 0.0)
                                 Else
                                   lblPPDStatus.Caption := 'Status: Not Available'
                               End; // ptPPDNotTaken
      ptPPDTaken             : lblPPDStatus.Caption := 'Status: Taken';
      ptPPDTakenOutsideTerms : lblPPDStatus.Caption := 'Status: Taken/Expired';
    Else
      lblPPDStatus.Caption := 'Status: Unknown';
    End; // Case thPPDTaken
  End; // With ExLocal.LInv
End; // UpdatePPDStatusInfo

//-------------------------------------------------------------------------

procedure TSalesTBody.FormDesign;


begin

  I2QtyF.DecPlaces:=Syss.NoQtyDec;

  {I5UD1Lab.Caption:=SyssVAT.VATRates.UDFCaption[3];
  I5UD2Lab.Caption:=SyssVAT.VATRates.UDFCaption[4];
  I5UD3Lab.Caption:=SyssVAT.VATRates.UDFCaption[13];
  I5UD4Lab.Caption:=SyssVAT.VATRates.UDFCaption[14];}

  I1VATLab.Caption:=CCVATName^;
  I1VATTLab.Caption:=CCVATName^+I1VATTLab.Caption;
  I2VATTLab.Caption:=CCVATName^+I2VATTLab.Caption;
  I3VATTLab.Caption:=CCVATName^+I3VATTLab.Caption;
  I5MVATF.Caption:=CCVATName^+I5MVATF.Caption;
  I5VATRLab.Caption:=CCVATName^+I5VATRLab.Caption;
  I5VATLab.Caption:=CCVATName^;
  Label14.Caption:=CCVATName^;
  Label18.Caption:=CCVATName^;

  I5VRateL.Caption:=CCVATName^+I5VRateL.Caption;

  {$IFDEF JC}
    If (CISOn) then
      lblTaxSummary.Caption:=CCCISName^+' '+lblTaxSummary.Caption;

  {$ENDIF}

  If (Syss.WarnYRef) then
    I1YrRefF.Charcase:=ecUpperCase;

  PrimeButtons;

  BuildDesign;

  BuildMenus;

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


  {ChangePage(0); Should not be needed, as formcreate sets page 0... }

end;

procedure TSalesTBody.HidePanels(PageNo    :  Byte);

Var
  TmpBo,
  LocBo,
  DelBo,
  CCDepBo
         :  Boolean;
  n      :  Integer;

Begin
  With MULCtrlO,VisiList do
  Begin
    fBarOfSet:=Current_BarPos(PageNo);
    vUseOfSet:=BOn;

    Case PageNo of

      0
         :  Begin
              {$IFDEF STK}
                TmpBo:=BOn;
              {$ELSE}
                TmpBo:=BOff;
              {$ENDIF}
              //RJ 08/02/2016 2016-R1 ABSEXCH-14990: Hiding Panel depend upon the Panel object , Overloaded Method instead of Default Index
              SetHidePanel(I1StkCodePanel,Not TmpBo,BOff);
              SetHidePanel(I1ItemPanel,TmpBo,BOn);
              SetHidePanel(8,BOn,BOff);
              SetHidePanel(9,BOn,BOn);
              SetHidePanel(10,BOn,BOn);
            end;

      1  :  Begin
              LocBo:=BOff; CCDepBo:=BOff;

              {$IFNDEF SOP}
                LocBo:=BOn;
              {$ENDIF}

              {$IFNDEF PF_On}
                CCDepBo:=BOn;
              {$ELSE}
                CCDepBo:=Not Syss.UseCCDep;
              {$ENDIF}

              DelBo:=(Not (DocHed In PSOPSet));

              TmpBo:=(Not Show_CMG(DocHed));

              SetHidePanel(0,Not MULVisiList[0].IdPanel(0,BOff).Visible,BOff);

              SetHidePanel(1,LocBo,BOff);
              SetHidePanel(2,DelBo,BOff);

              SetHidePanel(4,CCDepBo,BOff);
              SetHidePanel(5,CCDepBo,BOff);

              SetHidePanel(7,TmpBo {$IFDEF LTE} or (DocHed In PurchSplit) {$ELSE} and (Not (DocHed In PurchSplit)){$ENDIF},BOff);
              SetHidePanel(8,TmpBo,BOff);
              SetHidePanel(9,TmpBo,BOff);
              //PR: 19/03/2009 Added functionality for Reconciliation Date
              SetHidePanel(10, not (DocHed in [SIN,SJI,SJC,SRI,SRF,SCR,PIN,PJI,PJC,PPI,PRF,PCR]), BOn);

            end;
      2..3
         :  Begin
              For n:=0 to MUTotCols do
                SetHidePanel(n,((n>6) and (PageNo=2))
                            or ((n>4) and (PageNo=3))
                            or ((n=0) and (PageNo=3) and (Not MULVisiList[0].IdPanel(0,BOff).Visible)),

                            //PR: 23/03/2009 changed to n=10
                            ((n=10) and (PageNo<>1)));
            end;
    end; {Case..}

  end;
end;

// CJS 2016-01-11 - ABSEXCH-17100 - Intrastat fields for Transaction Header
procedure TSalesTBody.ArrangeFooterComponents;
var
  yPos: Integer;
  verticalSpacing: Integer;
begin
  // CJS 2016-01-20 - ABSEXCH-17168 - Hide disabled Intrastat controls
  if pnlIntrastat.Visible then
    ArrangeIntrastatComponents;

  // Position the components, working from the bottom up.
  yPos := FootPage.Height - 2;
  verticalSpacing := 8;

  // Line the bottom up with the Totals list panel on the right-hand side of
  // the form.
  yPos :=  lvTransactionTotalsPPD.Top + lvTransactionTotalsPPD.Height + nbSettleDisc.Top + 1;

  if panOrderPayment.Visible then
  begin
    yPos := yPos - panOrderPayment.Height;
    panOrderPayment.Top := yPos;
  end;

  // The Tax Rate panel contains the VAT Rates, Intrastat, and CIS panels.
  pnlTaxRates.Height := yPos - pnlTaxRates.Top;

  // The Intrastat and CIS Panels are inside the Tax Rates panel, so adjust
  // the position to match.
  yPos := yPos - pnlTaxRates.Top - 1;

  if (pnlIntrastat.Visible) then
  begin
    yPos := yPos - pnlIntrastat.Height;
    pnlIntrastat.Top := yPos;
  end;

  if (CISPanel1.Visible) then
  begin
    yPos := yPos - (CISPanel1.Height + verticalSpacing);
    CISPanel1.Top := yPos;
  end;

  // Keep the sbVATRates box at the top of the panel, but resize it to allow
  // for any other panels visible below it.
  sbVATRates.Height := yPos - (pnlTaxRates.Top + sbVATRates.Top);

end;

// CJS 2016-01-20 - ABSEXCH-17168 - Hide disabled Intrastat controls
procedure TSalesTBody.ArrangeIntrastatComponents;
begin
  {$IFNDEF EXDLL}
  if not SystemSetup.Intrastat.isShowDeliveryTerms then
  begin
    if lblDeliveryTerms.Visible then
    begin
      // Hide the Delivery Terms components
      lblDeliveryTerms.Visible := False;
      cbDeliveryTerms.Visible := False;

      // Shuffle all the other controls up to fill in the gap (shuffle them
      // starting from the bottom).
      lblModeOfTransport.Top := lblNoTc.Top;
      cbModeOfTransport.Top  := cbNoTc.Top;

      lblNoTc.Top := lblTransactionType.Top;
      cbNoTc.Top  := cbTransactionType.Top;

      lblTransactionType.Top := lblDeliveryTerms.Top;
      cbTransactionType.Top := cbDeliveryTerms.Top;
    end;

    pnlIntrastat.Height := cbModeOfTransport.Top + cbModeOfTransport.Height;
  end;

  if not SystemSetup.Intrastat.isShowModeOfTransport then
  begin
    // Hide the Mode of Transport components
    lblModeOfTransport.Visible := False;
    cbModeOfTransport.Visible := False;

    pnlIntrastat.Height := cbNotC.Top + cbNotC.Height;
  end;
  {$ENDIF}
end;

// CJS 2016-01-12 - ABSEXCH-17100 - Intrastat fields for Transaction Header
procedure TSalesTBody.PopulateIntrastatLists;
var
  i: Integer;
  Line: string;
begin
{$IFNDEF EXDLL}
  cbDeliveryTerms.Items.Clear;
  for i := 0 to IntrastatSettings.DeliveryTermsCount - 1 do
  begin
    Line := IntrastatSettings.DeliveryTerms[i].Code + ' - ' +
            IntrastatSettings.DeliveryTerms[i].Description;
    cbDeliveryTerms.Items.Add(Line);
    cbDeliveryTerms.ItemsL.Add(Line);
  end;

  cbTransactionType.ItemsL.Assign(cbTransactionType.Items);

  cbNoTc.Items.Clear;
  for i := 0 to IntrastatSettings.NatureOfTransactionCodesCount - 1 do
  begin
    Line := IntrastatSettings.NatureOfTransactionCodes[i].Code + ' - ' +
            IntrastatSettings.NatureOfTransactionCodes[i].Description;
    cbNoTc.Items.Add(Line);
    cbNoTc.ItemsL.Add(Line);
  end;

  cbModeOfTransport.Items.Clear;
  for i := 0 to IntrastatSettings.ModesOfTransportCount - 1 do
  begin
    Line := IntrastatSettings.ModesOfTransport[i].Code + ' - ' +
            IntrastatSettings.ModesOfTransport[i].Description;
    cbModeOfTransport.Items.Add(Line);
    cbModeOfTransport.ItemsL.Add(Line);
  end;
{$ENDIF}
end;

// CJS 2016-01-22 - ABSEXCH-17180 - Default NoTC on Transaction Headers & Lines
// Credit Notes default to 16 (2 for Ireland), other transaction types
// default to 10 (1 for Ireland).
function TSalesTBody.DefaultNoTCIndex: Integer;
begin
  {$IFNDEF EXDLL}
  Result := -1;
  if CurrentCountry = IECCode then
  begin
    // Irish codes
    if ExLocal.LInv.InvDocHed in SalesCreditSet + PurchCreditSet then
      Result := IntrastatSettings.IndexOf(stNatureOfTransaction, ifCode, '2')
    else
      Result := IntrastatSettings.IndexOf(stNatureOfTransaction, ifCode, '1');
  end
  else
  begin
    if ExLocal.LInv.InvDocHed in SalesCreditSet + PurchCreditSet then
      Result := IntrastatSettings.IndexOf(stNatureOfTransaction, ifCode, '16')
    else
      Result := IntrastatSettings.IndexOf(stNatureOfTransaction, ifCode, '10');
  end;
  {$ENDIF}
end;

Procedure TSalesTBody.SetColDec(PageNo  :  Byte);

Var
  n  :  Byte;

Begin
  With MULCtrlO do
  Begin
    For n:=0 to MUTotCols do
    With ColAppear^[n] do
    Begin
      AltDefault:=BOn;

      DispFormat:=SGText;

      If ((n In [4,6]) and (PageNo In [0,3]))
        or ((n=2) and (PageNo=0))
        or ((n In [3,6,7,8,9]) and (PageNo=1))
        or ((n In [1..6]) and (PageNo=2))
        or ((n=4) and (PageNo=3)) then
      Begin
        DispFormat:=SGFloat;
        NoDecPlaces:=2;

        If (n=6) and (PageNo In [0,3]) then
        Begin
          If (DocHed In SalesSplit) then
            NoDecPlaces:=Syss.NoNetDec
          else
            NoDecPlaces:=Syss.NoCosDec;
        end
        else
          If (n=3) and (PageNo=1) then
            NoDecPlaces:=0
          else
            If ((n In [1..6]) and (PageNo=2))
              or ((n=2) and (PageNo=0)) then
              NoDecPlaces:=Syss.NoQtyDec;
      end;
    end;
  end; {With..}
end; {Proc..}


Procedure TSalesTBody.InitVisiList(PageNo  :  Byte);

Var
  Idx  :  Integer;

Begin
  If (MULVisiList[PageNo]=nil) then
  Begin
    MULVisiList[PageNo]:=TVisiList.Create;
    { CJS 2012-08-16 - ABSEXCH-13263 - Create the source control for the font
                                       details for the list on the current
                                       page. }
    SourceListBox[PageNo] := TStringGridEx.Create(MULCtrlO);
    SourceListBox[Pageno].DefaultRowHeight := abs(SourceListBox[Pageno].Font.Height) + 5;
    try

      With MULVisiList[PageNo] do
      Case PageNo of

        1  :
              Begin

                AddVisiRec(I2StkCodePanel,I2SCodeLab);
                AddVisiRec(I2LocnPanel,I2LocnLab);
                AddVisiRec(I2DelDatePanel,I2DelLab);
                AddVisiRec(I2NomPanel,I2NomLab);
                AddVisiRec(I2CCPanel,I2CCLab);
                AddVisiRec(I2DepPanel,I2DepLab);
                AddVisiRec(I2NetValPanel,I2NValLab);
                AddVisiRec(I2CostPanel,I2CostLab);
                AddVisiRec(I2MargPanel,I2MargLab);
                AddVisiRec(I2GPPanel,I2GPLab);
                AddVisiRec(I2ReconPanel,I2ReconLab); //PR: 19/03/2009 Added Reconciliation Date


                LabHedPanel:=I2HedPanel;

              end;

        2  :  Begin
                AddVisiRec(I3StkDPAnel,I3StkDLab);
                AddVisiRec(I3QOrdPanel,I3QOrdLab);
                AddVisiRec(I3QDelPanel,I3DelLab);
                AddVisiRec(I3QWOPanel,I3QWOLab);
                AddVisiRec(I3QOSPanel,I3QOSLab);
                AddVisiRec(I3QPkPanel,I3QPkLab);
                AddVisiRec(I3QTWPanel,I3QTWLab);
                AddVisiRec(I1DumPanel,I1DumPanel);
                AddVisiRec(I1DumPanel,I1DumPanel);
                AddVisiRec(I1DumPanel,I1DumPanel);
                AddVisiRec(I1DumPanel,I1DumPanel);  //PR: 19/03/2009 Added extra dummy panel

                LabHedPanel:=I3HedPanel;

              end;

        3  :  Begin
                AddVisiRec(I4StkCPanel,I4StkCLab);
                AddVisiRec(I4StkDPanel,I4StkDLab);
                AddVisiRec(I4JCPanel,I4JCLab);
                AddVisiRec(I4JAPanel,I4JALab);
                AddVisiRec(I4LTotPanel,I4LTotLab);
                AddVisiRec(I1DumPanel,I1DumPanel);
                AddVisiRec(I1DumPanel,I1DumPanel);
                AddVisiRec(I1DumPanel,I1DumPanel);
                AddVisiRec(I1DumPanel,I1DumPanel);
                AddVisiRec(I1DumPanel,I1DumPanel);
                AddVisiRec(I1DumPanel,I1DumPanel);    //PR: 19/03/2009 Added extra dummy panel

                LabHedPanel:=I4HedPanel;

              end;

      end; {Case..}

      With MULCtrlO do
      Begin
        VisiList:=MULVisiList[PageNo];
        { CJS 2012-08-16 - ABSEXCH-13263 - Make sure that SBSComp uses the
                                           correct source control for the font
                                           details. }
        MUListBox1 := SourceListBox[PageNo];
      end;

      {* Get coordinates here ? *}


      Find_Page1Coord(PageNo);

      With MULCtrlO do
        If (Assigned(MULVisiList[0])) then
          Match_VisiList(MULVisiList[0],VisiList);




    except

      MULVisiList[PageNo].Free;

      MULVisiList[PageNo]:=nil;

      { CJS 2012-08-16 - ABSEXCH-13263 - Free the source control. }
      SourceListBox[PageNo].Free;
      SourceListBox[PageNo] := nil;

    end; {try..}

  end; {already initialised}
end; {Proc..}


Function TSalesTBody.Current_BarPos(Const PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      0
         :  Result:=I1SBox.HorzScrollBar.Position;

      1  :  Result:=I2SBox.HorzScrollBar.Position;
      2  :  Result:=I3SBox.HorzScrollBar.Position;
      3  :  Result:=I4SBox.HorzScrollBar.Position;
      else  Result:=0;
    end; {Case..}


end;

Procedure TSalesTBody.SetCurrent_BarPos(Const PageNo  :  Byte;
                                        Const NewBO   :  Integer);

Begin
  Case PageNo of
      0
         :  I1SBox.HorzScrollBar.Position:=NewBO;

      1  :  I2SBox.HorzScrollBar.Position:=NewBO;
      2  :  I3SBox.HorzScrollBar.Position:=NewBO;
      3  :  I4SBox.HorzScrollBar.Position:=NewBO;
    end; {Case..}


end;


Procedure TSalesTBody.ChangeList(PageNo   :  Byte;
                                 ShowLines:  Boolean);


Var
  NewBar  :  Integer;

Begin

  NewBar:=0;


  If (PageNo<4) then
  With MULCtrlO do
  Begin
    SetCurrent_BarPos(PageNo,0);

    If (MULVisiList[PageNo]=nil) then
      InitVisiList(PageNo)
    else
    Begin
      VisiList:=MULVisiList[PageNo];
      { CJS 2012-08-16 - ABSEXCH-13263 - Make sure that SBSComp uses the
                                         correct source control for the font
                                         details. }

      //PR: 03/06/2013 ABSEXCH-14050 Preserve the position of the highlighted row.
      SourceListBox[PageNo].Row := MUListBox1.Row;
      MUListBox1 := SourceListBox[PageNo];
      SetListName(PageNo);
    end;

    I1ListBtnPanel.Parent:=PageControl1.Pages[PageNo];

    DayBkListMode:=PageNo;

    SetColDec(PageNo);

    HidePanels(PageNo);

    ReAssignCols;

    {If (PageNo In [2,3]) then
      ApplyReSizeAllCols(0,NewBar,BOn);}

    If (ShowLines) then
    Begin
      PageUpDn(0,BOn);

      VisiList.SetHedPanel(ListOfSet+NewBar);
    end;

  end; {With..}

end;


procedure TSalesTBody.RefreshList(ShowLines,
                                  IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;

Begin

  {$IFDEF DBD}
    KeyStart:=FullNomKey(EXLocal.LInv.FolioNum);

  {$ELSE}
    KeyStart:=FullIdkey(EXLocal.LInv.FolioNum,1);

  {$ENDIF}
  
  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(IdetailF,IdFolioK,KeyStart,'','',4,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;


procedure TSalesTBody.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TTransMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO do
    Begin
      SetListName(0);
      Try

        With VisiList do
        Begin
          AddVisiRec(I1StkCodePanel,I1SCodeLab);
          AddVisiRec(I1ItemPanel,I1ItemLab);
          AddVisiRec(I1QtyPanel,I1QtyLab);
          AddVisiRec(I1DescPanel,I1DescLab);
          AddVisiRec(I1LTotPanel,I1LTotLab);
          AddVisiRec(I1VATPanel,I1VATLab);
          AddVisiRec(I1UPricePanel,I1UPLab);
          AddVisiRec(I1DiscPanel,I1DiscLab);
          AddVisiRec(I1DumPanel,I1DumPanel);
          AddVisiRec(I1DumPanel,I1DumPanel);
          AddVisiRec(I1DumPanel,I1DumPanel);  //PR: 19/03/2009 Added extra dummy panel

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels(0);

          LabHedPanel:=I1HedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;

      ListOfSet:=0; //PR: 23/03/2009 With this as 10 the width of the header panel was too wide after adding the recon date column.
//      ListOfSet:=10;



      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=10; //PR: 19/03/2009 Changed from 9 to 10 to accommodate ReconDate
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      SetColDec(0);

      ListLocal:=@ExLocal;

      //PR: 19/01/2011 Moved call to FormSetOfSet from below. However, FormResize gets called so we need to set GotCoord to false
      //to avoid issue because arrow buttons haven't been created yet, then set it to true again below (after Set_Buttons).
      FormSetOfSet;
      GotCoord := False;
      Find_FormCoord;
      ListCreate;

      Filter[1,1]:='1'; {* Exclude Receipt part *}

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;

      DayBkListMode:=0;

      Set_Buttons(I1ListBtnPanel);
      GotCoord := True;

      ReFreshList(ShowLines,BOff);

      MULVisiList[0]:=VisiList;
      { CJS 2012-08-16 - ABSEXCH-13263 - Take a copy of the default source control. }
      SourceListBox[0] := MUListBox1;

    //PR: 10/11/2010
    For n:=1 to High(MULVisiList) do
    Begin
      If (MULVisiList[n]=nil) then
        InitVisiList(n);
    end;

    ChangeList(0, False);


    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;



  FormReSize(Self);

end;






procedure TSalesTBody.ReFreshFooter;
var
  Ok5BtnState: Boolean;
  Ok1BtnState: Boolean;
// CJS 2014-09-01 - v7.x Order Payments - T111 - Edit SOR - Disable nominated TH/TL fields and buttons if payments detected
{$IFDEF SOP}
  iOPTransactionPaymentInfo : IOrderPaymentsTransactionPaymentInfo;
{$ENDIF SOP}
Begin
  With ExLocal,LInv do
  Begin
    //PR: 23/09/2008 Disble OK Buttons during procedure as it can be slow in SQL, allowing user to click OK and crash.
    Screen.Cursor := crHourglass;
    // CJS 2012-05-30 - ABSEXCH-12222 - OK buttons enabled erroneously - save
    //                  and restore their original state
    OK5BtnState := OkI1Btn.Enabled;
    OK1BtnState := OKI1Btn.Enabled;
    OkI5Btn.Enabled := False;
    OKI1Btn.Enabled := False;
    Application.ProcessMessages;
    Try
      If (ForceStore) or (LastEdit) or (LViewOnly) then
      Begin
        {$IFDEF JC}
          If (CISOn) and (Not LViewOnly) then
            Calc_CISTaxInv(LInv,BOn);

        {$ENDIF}

        CalcInvTotals(LInv,ExLocal,Not ManVAT,BOn);

      end;

      VATMatrix.HideVATMatrix(LInvNetTrig);

      // CJS 2014-09-01 - v7.x Order Payments - T111 - Edit SOR - Disable nominated TH/TL fields and buttons if payments detected
      {$IFDEF SOP}
      If Syss.ssEnableOrderPayments And (ExLocal.LInv.InvDocHed In [SOR, SDN, SIN]) And (ExLocal.LInv.thOrderPaymentElement In [opeOrder, opeDeliveryNote, opeInvoice]) Then
      Begin
        // Create a Payment Info instance to determine the transactions payment state
        iOPTransactionPaymentInfo := OPTransactionPaymentInfo(ExLocal.LInv);
        Try
          // If payments found, disable controls
          VATMatrix.EnableVATMatrix((iOPTransactionPaymentInfo.GetPaymentCount = 0));
        Finally
          iOPTransactionPaymentInfo := NIL;
        End; // Try..Finally
      End; // If Syss.ssEnableOrderPayments And (ExLocal.LInv.InvDocHed = SOR) And (ExLocal.LInv.thOrderPaymentElement In [opeOrder, opeDeliveryNote, opeInvoice])
      {$ENDIF}


      OutInvFooterTot;
    Finally
      // CJS 2012-05-30 - ABSEXCH-12222 - OK buttons enabled erroneously - save
      //                  and restore their original state
      OkI5Btn.Enabled := OK5BtnState;
      OKI1Btn.Enabled := OK1BtnState;
      Screen.Cursor := crDefault;
    End;
  end; {With..}

end;

//--------------------------------------                                                                                                                                                                                                                                                                              -----------------------------------

// CJS 2014-08-04: v7.x Order Payments - T030 - Added Order Payments panel
Procedure TSalesTBody.ShowOrderPaymentsArea (Const ShowOrderPayment : Boolean);
Begin // ShowOrderPaymentsArea
  // Order Payments area should not be available in View or Edit mode, only for SOR's and Order Payments needs to be turned on
  // CJS 2016-01-11 - ABSEXCH-17100 - Intrastat fields for Transaction Header
  // Moved resizing code to ArrangeFooterComponents method.
  If ShowOrderPayment And (Not ExLocal.LViewOnly) And (Not ExLocal.LastEdit) And Syss.ssEnableOrderPayments And (ExLocal.LInv.InvDocHed = SOR) Then
  Begin
    // Check the relevant user permissions to determine if the user is allowed to change the settings
    panOrderPayment.Visible := ChkAllowed_In(uaSORAllowOrderPaymentsPayment);
    If panOrderPayment.Visible Then
      chkCreateOrderPayment.Checked := ChkAllowed_In(uaSORDefaultOrderPaymentsPaymentOn);
  End // If ShowOrderPayment And (Not ExLocal.LViewOnly) And (Not ExLocal.LastEdit) And Syss.ssEnableOrderPayments And (ExLocal.LInv.InvDocHed = SOR)
  Else
  Begin
    panOrderPayment.Visible := False;
    chkCreateOrderPayment.Checked := False;
  End; // Else
End; // ShowOrderPaymentsArea

//-------------------------------------------------------------------------

{ ==== Display Invoice Footer Totals ==== }

Procedure TSalesTBody.OutInvFooterTot;

Var
  n       :  VATType;
  DiscT, CalcTax, LOk :  Boolean;
  Tot1, Tot2, Tot3 : Double;
  lvTransTot : TListView;
  KeyS : Str255;  
Begin
  Tot1 := 0.0;
  Tot2 := 0.0;
  Tot3 := 0.0;
  CalcTax := False; //AP:05/10/2017 ABSEXCH-18533:CIS ledger

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

    {* Show remaining total fields *}

    DiscT:=DiscTaken;

    I5Net1F.Value:=InvNetVal;
    I5Net2F.Value:=InvNetVal;

    I5VAT1F.Value:=InvVAT;
    I5VAT2F.Value:=InvVAT;

    I5Disc1F.Value:=DiscAmount;

    If (JBFieldOn) then
      I5Disc2F.Value:=DiscSetAm
    else
      I5Disc2F.Value:=DiscAmount+DiscSetAm;

    DiscTaken:=BOff;
    I5Tot1F.Value:=ITotal(LInv);

    DiscTaken:=BOn;

    I5Tot2F.Value:=ITotal(LInv);

    // MH 27/05/2015 v7.0.14: Added the No-PPD Page to allow for a different listview layout
    //                        without having to do it all at runtime
    If (nbSettleDisc.PageIndex = NoPromptPaymentDiscountPage) Then
      lvTransTot := lvTransactionTotals
    Else
      lvTransTot := lvTransactionTotalsPPD;

    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
    lvTransTot.Clear;
    With lvTransTot.Items.Add Do
    Begin
      Caption := 'Net';

      Tot1 := Round_Up(InvNetVal - DiscAmount, 2);
      SubItems.Add(FormatFloat(GenRealMask, Tot1));

      // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
      If (lvTransTot = lvTransactionTotalsPPD) Then
      Begin
        Tot2 := Round_Up(thPPDGoodsValue, 2);
        SubItems.Add(FormatFloat(GenRealMask, Tot2));

        Tot3 := Round_Up(Tot1 - thPPDGoodsValue, 2);
        SubItems.Add(FormatFloat(GenRealMask, Tot3));
      End; // If (lvTransTot = lvTransactionTotalsPPD)
    End; // With lvTransTot.Items.Add
    With lvTransTot.Items.Add Do
    Begin
      Caption := CCVATName^;

      Tot1 := Round_Up(Tot1 + InvVAT, 2);
      SubItems.Add(FormatFloat(GenRealMask, InvVAT));

      // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
      If (lvTransTot = lvTransactionTotalsPPD) Then
      Begin
        Tot2 := Round_Up(Tot2 + thPPDVATValue, 2);
        SubItems.Add(FormatFloat(GenRealMask, thPPDVATValue));

        Tot3 := Round_Up(Tot3 + (InvVAT - thPPDVATValue), 2);
        SubItems.Add(FormatFloat(GenRealMask, Round_Up(InvVAT - thPPDVATValue, 2)));
      End; // If (lvTransTot = lvTransactionTotalsPPD)
    End; // With lvTransTot.Items.Add
    With lvTransTot.Items.Add Do
    Begin
      Caption := 'Total';
      SubItems.Add(FormatFloat(GenRealMask, Tot1));

      // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
      If (lvTransTot = lvTransactionTotalsPPD) Then
      Begin
        SubItems.Add(FormatFloat(GenRealMask, Tot2));
        SubItems.Add(FormatFloat(GenRealMask, Tot3));
      End; // If (lvTransTot = lvTransactionTotalsPPD)
    End; // With lvTransTot.Items.Add

    // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
    UpdatePPDStatusInfo;

    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Update Look and feel of Line Type Totals
    lvLineTypeTotals.Clear;
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Type: ' + Trim(CustomFields[cfLinetypes, 1].cfCaption);
      SubItems.Add(FormatFloat(GenRealMask, DocLSplit[1]));
    End; // With lvLineTypeTotals.Items.Add
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Type: ' + Trim(CustomFields[cfLinetypes, 2].cfCaption);
      SubItems.Add(FormatFloat(GenRealMask, DocLSplit[2]));
    End; // With lvLineTypeTotals.Items.Add
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Type: ' + Trim(CustomFields[cfLinetypes, 3].cfCaption);
      SubItems.Add(FormatFloat(GenRealMask, DocLSplit[3]));
    End; // With lvLineTypeTotals.Items.Add
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Type: ' + Trim(CustomFields[cfLinetypes, 4].cfCaption);
      SubItems.Add(FormatFloat(GenRealMask, DocLSplit[4]));
    End; // With lvLineTypeTotals.Items.Add
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Line Discount';
      SubItems.Add(FormatFloat(GenRealMask, DiscAmount));
    End; // With lvLineTypeTotals.Items.Add

    DiscTaken:=DiscT;

    // CJS 2014-08-04 - v7.X Order Payments - T030 - added Order Payments panel
    If (Not panOrderPayment.Visible) Then
    Begin
      // Order Payments disabled - clear the fields to ensure any previous values are not saved
      chkCreateOrderPayment.Checked := False;

      {$IFDEF JC}
      If (CISOn) then
      Begin
        //AP:05/10/2017 ABSEXCH-18533:CIS ledger
        if (CISEmpl <> '') then
        begin
          // Search for the Employee record
          KeyS := Strip('R', [#0], PartCCKey(JARCode, JASubAry[3]) + FullEmpCode(CISEmpl));
          LOk := CheckRecExsists(KeyS,JMiscF,JMK);

          {$B-}
            If (LOk) then
              CalcTax:=(Not (JobMisc^.EmplRec.CISType In [0]))
            else
            Begin
              CISEmpl:=Check_CISEmployee(CustCode,CalcTax);

              CalcTax:=(CISEmpl<>'') and (Not (JobMisc^.EmplRec.CISType In [0]));
            end;
          {$B+}
        end;

        if (CISEmpl <> '') and (CalcTax) then
        begin
          I5CISTaxF.Value:=CISTax;
          I5CISDecF.Value:=CISDeclared*DocCnst[InvDocHed]*DocNotCnst;

          I5CISGrossF.Value:=CISGross;
          I5CISManCb.Checked:=CISManualTax;
          I5CISPeriodF.DateValue:=CISDate;

          // PKR. 23/03/2016. ABSEXCH-17383. Changes for eRCT Plugin.
          // Hide the (RCT) Summary Panel and its contained controls (and for a change, it is
          //  actually a real panel that contains its controls) if the Plugin is installed.
          // This is the only place where CISPanel1 is made visible.
//          CISPanel1.Visible:=BOn;
          CISPanel1.Visible := (CurrentCountry <> IECCode);

          If (Round_Up(CISGross+CISTax,2)=0.0) then {Its a non taxable calc}
          Begin

            I5CISGrossF.Value:=ITotal(LInv)-CISGExclude;

            Label1.Caption:=CCCISName^+' Gross';

            If (CurrentCountry<>IECCode) then
              I5CISGrossF.Value:=I5CISGrossF.Value-InvVAT;

            I5CISManCb.Visible:=BOff;
            I5CISTaxF.Visible:=BOff;
            I5CISDecF.Left:=I5CISTaxF.Left;
            Label2.Caption:='Declared';
          end;
        end
        else
        Begin
          CISPanel1.Visible:=BOff;
        end; // if (CISEmpl ...
      end; // If (CISOn) ...
      {$ENDIF}
    end; // If (Not panOrderPayment.Visible) ...
  end; // With ExLocal,LInv ...
end;


{ ==== Display Invoice Total ==== }
Procedure TSalesTBody.SetInvTotPanels(NewIndex  :  Integer);

Var
  NewParent  :  TWinControl;

Begin

  INetTotF.Visible:=(NewIndex In [0..3,5]);

  IVatTotF.Visible:=((INetTotF.Visible) and ((NewIndex<>1) or (I1MargLab.Visible)));

  IGTotF.Visible:=(IVATTotF.Visible);

  Case NewIndex of

    1  :  With IGTotF do
          Begin
            DecPlaces:=1;
            DisplayFormat:=GenPcntMask;
          end;

    else  With IGTotF do
          Begin
            DisplayFormat:=GenRealMask;
            DecPlaces:=2;
          end;
  end; {Case..}

  If (NewIndex In [0..3,5]) then
  Begin
    Case NewIndex of
      1  :  NewParent:=I2BtmPanel;
      2  :  NewParent:=I3BtmPanel;
      3  :  NewParent:=I4BtmPanel;
      5  :  NewParent:=I6BtmPanel;
      else  NewParent:=I1BtmPanel;
    end; {Case..}

    INetTotF.Parent:=NewParent;
    IVatTotF.Parent:=NewParent;
    IGTotF.Parent:=NewParent;
  end;

end;

Procedure TSalesTBody.OutInvTotals(NewIndex  :  Integer);

Begin

  With ExLocal,LInv do
  Begin
    {$IFDEF MC_On}
      CurrLab1.Caption:=SSymb(Currency);
    {$ENDIF}

    Case NewIndex of
      1  :  Begin
              INetTotF.Value:=ITotal(LInv)-InvVAT;

              IVATTotF.Value:=INetTotF.Value-(TotalCost+TotalCost2);

              IGTotF.Value:=Calc_Pcnt(INetTotF.Value,IVATTotF.Value);
            end;

      // MH 23/03/2015 v7.0.14 ABSEXCH-16288: Footer Totals not updated after editing a line
      4  :  ReFreshFooter;

      5  :  Begin
              Form2Inv;

              INetTotF.Value:=ConvCurrITotal(LInv,BOff,BOff,BOn);

              IVATTotF.Value:=TotalInvoiced;

              IGTotF.Value:=INetTotF.Value-TotalInvoiced;

            end;

      else
            Begin
              IGTotF.Value:=ITotal(LInv);
              IVATTotF.Value:=InvVAT;

              If (Syss.ShowInvDisc) then
                INetTotF.Value:=IGTotF.Value-InvVat
              else
                INetTotF.Value:=InvNetVal;

            end;
    end; {Case..}

  end;

end;


{ ======== Display Invoice Record ========== }

procedure TSalesTBody.SetInvFields;

Var
  GenStr       :  Str255;

  n,m          :  Byte;

Begin

  With ExLocal,LInv do
  Begin
    I1OurRefF.Text:=Pr_OurRef(LInv);
    I1OpoF.Text:=OpName;

    { CJS - 2013-08-09 - MRD2.6.05 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      I1OpoF.Hint := GetOriginatorHint(LInv)
    else
      I1OpoF.Hint := '';

    //PR: 02/10/2013 MRD 1.1.17 Use long code for consumers. At this point Cust will be either set to the
    //                          correct account or will be blank.
    if IsConsumer(Cust) then
      I1AccF.Text := Trim(LCust.acLongACCode)
    else
      I1AccF.Text:=Strip('R',[#32],CustCode);

    I1PrYrF.InitPeriod(AcPr,AcYr,BOn,BOn);

    I1TransDateF.DateValue:=TransDate;

    I1DueDateF.DateValue:=DueDate;

    I1YrRefF.Text:=Trim(YourRef);
    I1YrRef2F.Text:=Trim(TransDesc);

    DMDCNomF.Text:=Form_BInt(CtrlNom,0);

    {$IFDEF MC_On}
      If (Currency>0) then
        I1CurrF.ItemIndex:=Pred(Currency);

      I1ExRateF.Value:=CXRate[BOn];

      I5VRateF.Value:=VatCRate[BOn];
    {$ENDIF}


    CustToMemo(LCust,I1AddrF,0);


    If (Not EmptyAddr(DAddr)) then
      LCust.DAddr:=DAddr
    else
      If (EmptyAddr(LCust.DAddr)) then
        LCust.DAddr:=LCust.Addr;



    If (JbCostOn) or (JbFieldOn) then
    Begin
      I4JobCodeF.Text:=DJobCode;
      I4JobAnalF.Text:=DJobAnal;
    end;

    If edtOverrideLocation.Visible Then
    Begin
      edtOverrideLocation.Enabled := FirstStore;
      edtOverrideLocation.Text := thOverrideLocation;
    End; // If edtOverrideLocation.Visible

    If (Syss.IntraStat) or JBFieldOn then
    Begin
      {$IFNDEF EXDLL}
      cbDeliveryTerms.ItemIndex := IntrastatSettings.IndexOf(stDeliveryTerms, ifCode, Trim(DelTerms));
      cbModeOfTransport.ItemIndex := IntrastatSettings.IndexOf(stModeOfTransport, ifCode, IntToStr(TransMode));
      cbNoTc.ItemIndex := IntrastatSettings.IndexOf(stNatureOfTransaction, ifCode, IntToStr(TransNat));
      {$ENDIF}

      // CJS 2016-01-22 - ABSEXCH-17180 - Default NoTC on Transaction Headers & Lines
      if cbNotc.ItemIndex < 0 then
        cbNoTc.ItemIndex := DefaultNoTCIndex;

      cbTransactionType.ItemIndex := PTtoCB(SSDProcess);
    end;

    I5NBF.Value:=NoLabels;

    {
      CJS 18/01/2011 - Added new controls for Week/Month, and activated on PINs
      and PORs (previously this re-used the Box Label fields, and was only active
      for PINs).
    }
    // if (DocHed in [PIN, POR]) then
    if (DocHed = PIN) or (WebExtEProcurementOn and (DocHed = POR)) then
      WkMonthEdt.Value := thWeekMonth;

    THUD1F.Text:=DocUser1;
    THUD2F.Text:=DocUser2;
    THUD3F.Text:=DocUser3;
    THUD4F.Text:=DocUser4;

    edtUdf5.Text  := DocUser5;
    edtUdf6.Text  := DocUser6;
    edtUdf7.Text  := DocUser7;
    edtUdf8.Text  := DocUser8;
    edtUdf9.Text  := DocUser9;
    edtUdf10.Text := DocUser10;
    // PKR. 24/03/2016. ABSEXCH-17383. eRCT support.
    edtUdf11.Text := thUserField11;
    edtUdf12.Text := thUserField12;

    I5MVATF.Checked:=ManVAT;

    {$IFDEF JC}
      If (CISOn) then
        I5CISMancb.Checked:=CISManualTax;
    {$ENDIF}


    FixXRF.Checked:=SOPKeepRate;

    // Settlement Discount
    I5SDPF.Value := Pcnt2Full(DiscSetl);
    I5SDDF.Value := DiscDays;
    I5SDTF.Checked:=(DiscTaken or (PDiscTaken and (Not InAddEdit)));

    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
    ccyPPDPercentage.Value := Pcnt2Full(thPPDPercentage);
    ccyPPDDays.Value := thPPDDays;

    // MH 05/05/2015 v7.0.14 ABSEXCH-16284: Set PPD status label here
    UpdatePPDStatusInfo;

    // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    ShowSettlementDiscountFields (TransactionHelper(@LInv).SettlementDiscountSupported);

    SetCtrlNomStat;

    If (Currency<>Syss.VATCurr) and (Not (Syss.VATCurr In [0,1])) then
    Begin
      If (Not I5VRateL.Visible) then
      Begin
        I5VRateL.Visible:=BOn;
        I5VRateF.Visible:=BOn;

        sbVATRates.Height:=sbVATRates.Height-24;
        sbVATRates.Top:=sbVATRates.Top+24;
        SBSPanel54.Top:=SBSPanel54.Top+24;
      end;
    end
    else
    Begin
      If (I5VRateL.Visible) then
      Begin
        I5VRateL.Visible:=BOff;
        I5VRateF.Visible:=BOff;

        sbVATRates.Height:=sbVATRates.Height+24;
        sbVATRates.Top:=sbVATRates.Top-24;
        SBSPanel54.Top:=SBSPanel54.Top-24;
      end;
    end;

  end; {With..}
end;


{ ======== Display Invoice Record ========== }

procedure TSalesTBody.OutInv;

Var
  GenStr       :  Str255;
  FoundCode    :  Str20;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    FoundCode:=CustCode;

    GetCust(Self,CustCode,FoundCode,IsACust(CustSupp),-1);

    ExLocal.AssignFromGlobal(CustF);

    // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    SetDefaultSettlementDiscount;

    SetInvFields;

    // CJS 2014-08-04 - v7.X Order Payments - T030 - added Order Payments panel
    ShowOrderPaymentsArea (ExLocal.LCust.acAllowOrderPayments);

    OutInvTotals(Current_Page);

    OutInvFooterTot;


    If (DispCust<>nil) then
    With DispCust do
    Begin
      If (CustActive) then
        I1AddrFClick(I1AddrF);
    end;
  end; {With..}
end;


procedure TSalesTBody.Form2Inv;

Var
  n  :  VATType;

  // CJS 2016-01-12 - ABSEXCH-17100 - Intrastat fields for Transaction Header
  // Returns the 'code' part of a string which consists of a code followed by
  // a description.
  function ExtractCodePart(FromString: string): string;
  var
    SpacePos: Integer;
  begin
    Result := '';
    SpacePos := Pos(' ', FromString);
    if Spacepos > 0 then
      Result := Copy(FromString, 1, SpacePos - 1);
  end;

  // CJS 2016-01-12 - ABSEXCH-17100 - Intrastat fields for Transaction Header
  function ExtractCodeValue(Combo: TSBSComboBox): Integer;
  var
    Code: string;
  begin
    Result := 0;
    Code := ExtractCodePart(Combo.Text);
    if (Code <> '') then
      Result := StrToIntDef(Code, 0);
  end;

Begin
  With ExLocal.LInv do
  Begin
    //PR: 02/10/2013 MRD 1.1.17 Take a/c code directly from cust record rather than from text field as that may contain long a/c code.
    CustCode:= ExLocal.LCust.CustCode;

    TransDate:=I1TransDateF.DateValue;
    DueDate:=I1DueDateF.DateValue;

    I1PrYrF.InitPeriod(AcPr,AcYr,BOff,BOff);


    YourRef:=LJVar(I1YrRefF.Text,DocYref1Len);

    If (Syss.WarnYRef) then
      YourRef:=UpCaseStr(YourRef);

    TransDesc:=LJVar(I1YrRef2F.Text,DocYref2Len);

    CtrlNom:=IntStr(DMDCNomF.Text);

    If (JBCostOn) then
    Begin
      DJobCode:=FullJobCode(I4JobCodeF.Text);
      DJobAnal:=FullJACode(I4JobAnalF.Text);
    end;

    {$IFDEF SOP}
      // If field in use then copy out, else ensure padded with spaces
      If edtOverrideLocation.Visible Then
        thOverrideLocation := Full_MLocKey(edtOverrideLocation.Text)
      Else
    {$ENDIF}
        thOverrideLocation := LJVar('', MLocKeyLen);

    {$IFDEF MC_On}

      Currency:=Succ(I1CurrF.ItemIndex);

      CXRate[BOn]:=I1ExRateF.Value;

      VATCRate[BOn]:=I5VRateF.Value;
    {$ENDIF}


    NoLabels:=Round(I5NBF.Value);

    {
      CJS 18/01/2011 - Added new controls for Week/Month, and activated on PINs
      and PORs (previously this re-used the Box Label fields, and was only active
      for PINs).
    }
//    if (DocHed in [PIN, POR]) then
    if (DocHed = PIN) or (WebExtEProcurementOn and (DocHed = POR)) then
      thWeekMonth := Round(WkMonthEdt.Value);

    DocUser1:=THUD1F.Text;
    DocUser2:=THUD2F.Text;
    DocUser3:=THUD3F.Text;
    DocUser4:=THUD4F.Text;

    //PR: 11/10/2011 New Udfs v6.9
    DocUser5  := edtUdf5.Text;
    DocUser6  := edtUdf6.Text;
    DocUser7  := edtUdf7.Text;
    DocUser8  := edtUdf8.Text;
    DocUser9  := edtUdf9.Text;
    DocUser10 := edtUdf10.Text;
    // PKR. 24/03/2016. ABSEXCH-17383. eRCT support.
    thUserField11 := edtUdf11.Text;
    thUserField12 := edtUdf12.Text;

    // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    If (nbSettleDisc.PageIndex = SettleDiscPage) Then
    Begin
      DiscSetl := Pcnt(I5SDPF.Value);
      DiscDays := Round(I5SDDF.Value);
      DiscTaken:= I5SDTF.Checked;
    End // If (nbSettleDisc.PageIndex = SettleDiscPage)
    Else
    Begin
      DiscSetl := 0.0;
      DiscDays := 0;
      DiscTaken:= False;
    End; // Else

    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
    // MH 20/05/2015 v7.0.14 ABSEXCH-16448: PPD Fields populated when PPD Disabled on Trader
    If (nbSettleDisc.PageIndex = PromptPaymentDiscountPage) And ccyPPDPercentage.Visible Then
    Begin
      // Prompt Payment Discount
      thPPDPercentage := Pcnt(ccyPPDPercentage.Value);
      thPPDDays       := Round(ccyPPDDays.Value);
    End // If (nbSettleDisc.PageIndex = PromptPaymentDiscountPage)
    Else
    Begin
      thPPDPercentage := 0.0;
      thPPDDays       := 0;
    End; // Else

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


    SOPKeepRate:=FixXRF.Checked;

    If (Syss.IntraStat) or JBFieldOn then
    Begin
      // CJS 2016-01-12 - ABSEXCH-17100 - Intrastat fields for Transaction Header
      DelTerms := ExtractCodePart(cbDeliveryTerms.Text);
      TransNat := ExtractCodeValue(cbNoTc);
      TransMode := ExtractCodeValue(cbModeOfTransport);
      SSDProcess := CBtoPT(cbTransactionType.ItemIndex);
    end
    Else
    Begin
      // MH 19/05/2016 2016-R2 ABSEXCH-17428: Reset Intrastat Fields if Intrastat disabled
      FillChar (DelTerms, SizeOf(DelTerms), #0);
      FillChar (TransNat, SizeOf(TransNat), #0);
      FillChar (TransMode, SizeOf(TransMode), #0);
      FillChar (SSDProcess, SizeOf(SSDProcess), #0);
    End; // Else

    If (ManVAT) then
    Begin
      For n:=VStart to VEnd do
      Begin

        InvVATAnal[n]:=VATMatrix.IDRec(Ord(n))^.VATD.Value;

      end;
    end;

  end; {With..}
end;

Procedure TSalesTBody.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      // CJS 2014-09-01 - v7.x Order Payments - T111 - Edit SOR - Disable nominated TH/TL fields and buttons if payments detected
      0..2:  if I1AccF.CanFocus then
               I1AccF.SetFocus
             else
               I1TransDateF.SetFocus;

      3  :  I4JobCodeF.SetFocus;

      4  :  {If (LInv.InvDocHed In OrderSet) then
              I5NBF.SetFocus
            else}
              I5MVATF.SetFocus;

    end; {Case&With..}

end; {Proc..}




Procedure TSalesTBody.ChangePage(NewPage  :  Integer);


Begin
  SetHelpContextIDsForPage; // NF: 07/04/06

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TSalesTBody.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
    LockWindowUpDate(Handle);
  end;
end;


procedure TSalesTBody.PageControl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;

  {$IFDEF NP}
    NoteSetUp :  TNotePadSetUp;
  {$ENDIF}

  {$IFDEF RT_On}
    PaySetUp :  TPayInSetUp;
  {$ENDIF}

begin
  SetHelpContextIDsForPage; // NF: 07/04/06

  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      {$B-}

        If (NewIndex=4) or ((NewIndex In [0..3]) and (MULVisiList[NewIndex]<>nil)) then
          LockWindowUpDate(0);

      {$B+}

      PrimeButtons;

      If (Not TransExtForm1.NewSetting) and (NewIndex>3) then {* Panel is open, so close it *}
        TransExtForm1.ForceClose;


      If (NewIndex=4) or (Not I1BtnPanel.Visible) then
      Begin

        I1BtnPanel.Visible:=(NewIndex<>4);
        I1BtnPanel.Enabled:=(NewIndex<>4);

        I1FPanel.Visible:=(NewIndex<>4);
      end;

      {If (NewIndex=3) or (Not I1YrRefF.Visible) then N/A now as in own panel
      Begin
        I1YrRefL.Visible:=(NewIndex<>3);
        I1YrRefF.Visible:=(NewIndex<>3);

        I1YrRef2L.Visible:=(NewIndex<>3);
        I1YrRef2F.Visible:=(NewIndex<>3);

        I4JobCodeF.Visible:=(NewIndex=3);
        I4JobCodeL.Visible:=(NewIndex=3);

        I4JAnalL.Visible:=(NewIndex=3);
        I4JobAnalF.Visible:=(NewIndex=3);
      end; }

      If (NewIndex=0) then
      Begin
        I1AddrF.Color:=I1AccF.Color;
        I1AddrF.Font.Color:=I1AccF.Font.Color;

        CustToMemo(ExLocal.LCust,I1AddrF,0);
      end
      else
      With ExLocal,LInv do
      Begin
        I1AddrF.Color:=clBtnFace;
        I1AddrF.Font.Color:=clBlack;

        If (Not EmptyAddr(DAddr)) then
          LCust.DAddr:=DAddr
        else
          If (EmptyAddr(LCust.DAddr)) then
            LCust.DAddr:=LCust.Addr;

        CustToMemo(LCust,I1AddrF,0);

      end;

      {$IFDEF Rt_On}

        {If (NewIndex=5) then  Disabled as calculation now takes place during check for completed
        With ExLocal do
        Begin
          If (InAddEdit) then
          Begin
            Form2Inv;
            CalcInvTotals(LInv,ExLocal,Not LInv.ManVAT,BOn);
            OutInv;
          end;
        end;}
      {$ENDIF}

      SetInvTotPanels(NewIndex);
      OutInvTotals(NewIndex);

      Case NewIndex of

        0..3
           :  Begin
                ChangeList(NewIndex,BOn);

              end;


        4  :  Begin
                If (ReCalcTot) then
                Begin
                  ReCalcTot:=BOff;

                  ReFreshFooter;
                end;

                // PKR. 24/02/2016. ABSEXCH-17322. Intrastat settings still showing after upgrade
                // Added FullStkSysOn
                Show_IntraStat(Syss.IntraStat and ExLocal.LCust.EECMember and FullStkSysOn, BOn);

                // CJS 2016-01-11 - ABSEXCH-17100 - Intrastat fields for Transaction Header
                ArrangeFooterComponents;

              end;


      {$IFDEF Rt_On}

        5  :  Begin

                If (PayCtrl=nil) then
                With ExLocal do
                Begin
                  PayCtrl:=TPayLine.Create(Self);

                  With PaySetUp do
                  Begin
                    ColPanels[0]:=RCNPanel; ColPanels[1]:=RCNLab;
                    ColPanels[2]:=RCDPanel; ColPanels[3]:=RCDLab;
                    ColPanels[4]:=RCQPanel; ColPanels[5]:=RCQLab;

                    ColPanels[6]:=RCPPanel; ColPanels[7]:=RCPLab;
                    ColPanels[8]:=RCBPanel; ColPanels[9]:=RcBLab;
                    ColPanels[10]:=RCRPanel; ColPanels[11]:=RCRLab;

                    ColPanels[12]:=RcHedPanel;
                    ColPanels[13]:=RcListBtnPanel;

                    //PR: 23/03/2009 Added panels to accommodate Recon Date
                    ColPanels[14]:=RcReconPanel; ColPanels[15]:=RcReconLab;

                    ScrollBox:=RcSBox;
                    PropPopUp:=StoreCoordFlg;

                    CoorPrime:=DocCodes[DocHed][1];
                    CoorHasCoor:=LastCoord;

                  end;

                  try
                    PayCtrl.WindowSettings := FSettings;
                    PayCtrl.CreateList(Self,PaySetUp,BOn,LInv);


                  except
                    PayCtrl.Free;
                    PayCtrl:=Nil
                  end;

                  MDI_UpdateParentStat;

                end
                else
                With ExLocal do
                Begin
                  If (LInv.FolioNum<>PayCtrl.GetFolio) then {* Refresh notes *}
                  with PayCtrl do
                  Begin
                    RefreshList(LInv.FolioNum);
                  end;

                  PayCtrl.ExLocal.LInv:=LInv;
                end;
              end;
      {$ELSE}

         5  :  ;

      {$ENDIF}

      {$IFDEF NP}

        6  :  If (NotesCtrl=nil) then
              With ExLocal do
              Begin
                NotesCtrl:=TNoteCtrl.Create(Self);
                //PR: 21/10/2011 v6.9 Set handler to disable/enable note buttons for Audit History Notes
                NotesCtrl.OnSwitch := SwitchNoteButtons;


             //   NotesCtrl.fParentLocked:=fRecordLocked;
                SwitchNoteButtons(Self, NotesCtrl.NoteMode);
                NotesCtrl.Caption:=Caption+' - Notes';

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

                  CoorPrime:=DocCodes[DocHed][1];
                  CoorHasCoor:=LastCoord;

                end;

                try
                  //PR: 08/11/2020 Give the Notes list a reference to the settings object to allow loading and saving of settings.
                  NotesCtrl.WindowSettings := FSettings;
                  NotesCtrl.PropFlg.OnClick := PropFlgClick;
                  NotesCtrl.CreateList(Self,NoteSetUp,NoteDCode,NoteCDCode,FullNomKey(LInv.FolioNum));
                  NotesCtrl.GetLineNo:=LInv.NLineCount;


                except
                  NotesCtrl.Free;
                  NotesCtrl:=Nil
                end;

                MDI_UpdateParentStat;

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
                //PR: 20/10/2011 v6.9
                SwitchNoteButtons(Self, NotesCtrl.NoteMode);
              end;

      {$ELSE}

         6  :  ;

      {$ENDIF}

      end; {Case..}


      MDI_UpdateParentStat;

    end;

  LockWindowUpDate(0);
end;


procedure TSalesTBody.FormActivate(Sender: TObject);
begin
  OpoLineHandle:=Self.Handle;
end;


procedure TSalesTBody.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);
  ActiveControl := nil; // PKR. 24/03/2016. Prevents weirdo-drop-down-thingy from opening by default.

  ExLocal.Create;

  {$IFDEF SOP}
    TTDHelper := TTTDTransactionHelper.Create;
  {$ENDIF}

  FOldExpandedHeight := 0;
  // Record the original sizes of the VAT Rates list to make the show/hide of the
  // Auto-Receipt section more future proof
  OrigPnlTaxRatesHeight := pnlTaxRates.Height;
  OrigSbVATRatesHeight := sbVATRates.Height;

  ForceStore:=BOff;
  fDoingClose:=BOff;

  fRecordAuth:=BOff;
  ListScanningOn := False;
  AuthBy:='';

  {Customisation1.Execute;}

  LastCoord:=BOff;
  ReCalcTot:=BOn;

  Visible:=BOff;

  InvStored:=BOff;

  UpDateDel:=BOff;

  JustCreated:=BOn;
  fChkYourRef:=BOff;

  GotCoord:=BOff;
  NeedCUpdate:=BOff;
  FColorsChanged := False;
  fFrmClosing:=BOff;

  StopPageChange:=BOff;

  InPassIng:=BOff;
  GenSelect:=BOff;
  fAutoJCPage:=BOff;

  MatchOrdPtr:=nil;
  BackOrdPtr:=nil;
  BeingStored:=BOff;

  I5SDDF.BlockNegative:=BOn;

  {$IFDEF SOP}
    TransCommitPtr:=nil;
  {$ENDIF}

  fInBatchEdit:=BOff;
  fRecordLocked:=BOff;
  FAnonymisationON := False; 
  // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  SettlementDiscountPercentage := -1;
  SettlementDiscountDays := -1;
  // MH 26/08/2015 2015-R1 ABSEXCH-16790: Take PPD Percentage/Days from Head Office where applicable
  PPDMode := pmPPDDisabled;
  PPDDiscountPercentage := -1;
  PPDDiscountDays := -1;
  // Save some co-ords for the dynamic re-shaping of the Settlement Discount section
  SavedSettleDiscPos[SetDiscOriginalFrameWidth] := nbSettleDisc.Width;
  SavedSettleDiscPos[SetDiscOriginalFrameHeight] := nbSettleDisc.Height;
  SavedSettleDiscPos[SetDiscOriginalFieldLeft] := I5Net1F.Left;
  SavedSettleDiscPos[SetDiscOriginalLabelWidth] := Label4.Width;

  MinHeight:=345; {* Page control1 H/W *}
  MinWidth:=631;

  //PR: 10/10/2011 Changed initial clientheight from 351 to 376 to accommodate new User Fields
  //HV 05/12/2017 ABSEXCH-19535: Changed initial clientheight from 380 to 422 to accommodate new Anonymised Control
  InitSize.Y := 422;
  InitSize.X:=632;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=375;
  Width:=640;}


  PageControl1.ActivePage:=MainPage;


  Left:=0;
  Top:=0;

  RecordPage:=TransFormPage;
  DocHed:=TransFormMode;

  Caption:=DocNames[DocHed];

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;



  VATMatrix:=TVATMatrix.Create;



  PrimeExtList;

  FormDesign;

  //PR: 09/11/2010 Added to use new Window Positioning system
  //PR: 27/05/2011 Change to use ClassName rather than Name as identifier - if there are
  //2 instances of the form in existence at the same time, Delphi will change the name of one to Name + '_1' (ABSEXCH-11426)
  FSettings := GetWindowSettings(Self.ClassName + '_' + DocCodes[DocHed]);
  if Assigned(FSettings) then
    FSettings.LoadSettings;

  // CJS 2016-01-12 - ABSEXCH-17100 - Intrastat fields for Transaction Header
  if Syss.Intrastat then
    PopulateIntrastatLists;

  FormBuildList(BOff);

  //PR: 04/10/2013 MRD 1.1.17 Initialise consumer indicator to false
  WasConsumer := False;

  // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added flag for Telesales to allow the Edit SOR window
  // displayed by Telesales to display the Order Payments Take Payment window on store.
  FOrderPaymentsAutoPayment := False;

  // MH 05/07/2016 2016-R2 ABSEXCH-17638: B2B POR's not printing
  FBackToBackTransaction := False;
end;


procedure TSalesTBody.NotePageReSize;

Begin
  With TCNScrollBox do
  Begin
    TCNListBtnPanel.Left:=Width+1;

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


procedure TSalesTBody.PayIPageReSize;

Begin
  With RcSBox do
  Begin
    RcListBtnPanel.Left:=Width+1;

    RcHedPanel.Width:=HorzScrollBar.Range;
    RcNPanel.Height:=RcListBtnPanel.Height;
  end;

  RcDPanel.Height:=RcNPanel.Height;
  RcQPanel.Height:=RcNPanel.Height;
  RcPPanel.Height:=RcNPanel.Height;
  RcBPanel.Height:=RcNPanel.Height;
  RcRPanel.Height:=RcNPanel.Height;

  {$IFDEF Rt_On}

    If (PayCtrl<>nil) then {* Adjust list *}
    With PayCtrl.MULCtrlO,VisiList do
    Begin
      VisiRec:=List[0];

      With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=RcNPanel.Height;

      ReFresh_Buttons;

      RefreshAllCols;
    end;

  {$ENDIF}


end;


procedure TSalesTBody.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) and (Not fDoingClose) then
  Begin
    MULCtrlO.LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    NewVal:=ClientWidth-PagePoint[0].X;
    If (NewVal<MinWidth) then
      NewVal:=MinWidth;

    PageControl1.Width:=NewVal;

    NewVal:=ClientHeight-PagePoint[0].Y;

    If (NewVal<MinHeight) then
      NewVal:=MinHeight;

    PageControl1.Height:=NewVal;


    I1SBox.Width:=PageControl1.Width-PagePoint[1].X;
    I1SBox.Height:=PageControl1.Height-PagePoint[1].Y;

    I1FPanel.Width:=PageControl1.Width-5;

    I2SBox.Width:=I1SBox.Width;
    I2SBox.Height:=I1SBox.Height;
    I3SBox.Width:=I1SBox.Width;
    I3SBox.Height:=I1SBox.Height;

    I4SBox.Width:=I1SBox.Width;
    I4SBox.Height:=I1SBox.Height;

    TCNScrollBox.Width:=PageControl1.Width-PagePoint[5].X;
    TCNScrollBox.Height:=PageControl1.Height-PagePoint[5].Y;

    RcSBox.Width:=I1SBox.Width;
    RcSBox.Height:=I1SBox.Height;


    I1BtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    I1BtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;


    I1BSBox.Height:=I1BtnPanel.Height-PagePoint[3].X;

    I1ListBtnPanel.Left:=PageControl1.Width-PagePoint[4].X;
    I1ListBtnPanel.Height:=PageControl1.Height-PagePoint[4].Y;


    TCNListBtnPanel.Height:=PageControl1.Height-PagePoint[6].Y;
    RcListBtnPanel.Height:=I1ListBtnPanel.Height;

    NotePageResize;
    PayIPageResize;


    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      For n:=High(MULVisiList) downto 0 do
      If (MULVisiList[n]<>nil) then
      Begin
        MULCtrlO.VisiList:=MULVisiList[n];
        { CJS 2012-08-16 - ABSEXCH-13263 - Make sure that SBSComp uses the
                                           correct source control for the font
                                           details. }
        MULCtrlO.MUListBox1 := SourceListBox[n];

        With MULCtrlO,VisiList do
        Begin
          VisiRec:=List[0];

          With (VisiRec^.PanelObj as TSBSPanel) do
            Height:=I1SBox.ClientHeight-PagePoint[3].Y;

          RefreshAllCols;
        end;
      end; {Loop..}

      MULCtrlO.ReFresh_Buttons;

      If (Current_Page<4) then
      With MULCtrlO do
      Begin
        VisiList:=MULVisiList[Current_Page];
        { CJS 2012-08-16 - ABSEXCH-13263 - Make sure that SBSComp uses the
                                           correct source control for the font
                                           details. }
        MUListBox1 := SourceListBox[Current_Page];
        RefreshAllCols;
      end;

      LockWindowUpDate(0);
    end;{Loop..}

    MULCtrlO.LinkOtherDisp:=BOn;

    // SSK 22/10/2017 ABSEXCH-19386: Resize the anonymisation shape
    SetAnonymisationPanel;
    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;


procedure TSalesTBody.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  {$IFDEF SOP}
    FreeAndNIL(TTDHelper);
  {$ENDIF}

  ExLocal.Destroy;
  VATMatrix.Free;


  If (Not fDoingClose) then {* Call from here as close not run *}
  Begin
    {* Note 0 is not destroyed, as this is the lists own copy *}

    With MULCtrlO do
    Begin
      VisiList:=MULVisiList[0];
      { CJS 2012-08-16 - ABSEXCH-13263 - restore the original source control. }
      MUListBox1 := SourceListBox[0];
    end;


    For n:=1 to High(MULVisiList) do
    begin
      If (MULVisiList[n]<>nil) then
        MULVisiList[n].Free;
      { CJS 2012-08-16 - ABSEXCH-13263 - free the source controls created on
                                         this form. }
      if (SourceListBox[n] <> nil) then
        SourceListBox[n].Free;
    end;
  end;

  If (InvBtnList<>nil) then
    InvBtnList.Free;

  {If (MULCtrlO<>nil) then
    MULCtrlO.Free;}

  {$IFDEF SOP}
    If (CommitAct) then
      Create_CommitObject(BOn);
  {$ENDIF}


end;

procedure TSalesTBody.FormCloseQuery(Sender: TObject;
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

        {$IFDEF Rt_On}

          If (PayCtrl<>nil) then
          Begin
            try
              PayCtrl.Free;

            finally

              PayCtrl:=nil;
            end;
          end;

        {$ENDIF}


        Send_UpdateList(BOff,100);

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;

end;

procedure TSalesTBody.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  n  :  Byte;
begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    {$IFDEF SOP}
      // MH 23/09/2014 Order Payments: Extended Customisation
      // Clear down any cached image of the transaction in the transaction tracker at the
      // end of the edit to prevent any future re-visit to the transaction seeing old
      // and incorrect details
      ResetOrderPaymentsCustomisationTransactionTracker;
    {$ENDIF SOP}

    Action:=caFree;

    {* Note 0 is not destroyed, as this is the lists own copy *}

    With MULCtrlO do
    Begin
      VisiList:=MULVisiList[0];
      { CJS 2012-08-16 - ABSEXCH-13263 - restore the original source control. }
      MUListBox1 := SourceListBox[0];
    end;


    For n:=1 to High(MULVisiList) do
    begin
      If (MULVisiList[n]<>nil) then
        MULVisiList[n].Free;
      { CJS 2012-08-16 - ABSEXCH-13263 - free the source controls created for
                                         this form. }
      if (SourceListBox[n] <> nil) then
        SourceListBox[n].Free;
    end;

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

procedure TSalesTBody.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

  If (Key=$5A) and (Shift = ([ssAlt,ssCtrl,ssShift])) and (Not ExLocal.LViewOnly) then
  Begin
    Re_SetDoc(ExLocal.LInv);
    OutInv;
    RefreshList(BOn,BOff);
  end;

end;

procedure TSalesTBody.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Function TSalesTBody.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;

procedure TSalesTBody.ClsI1BtnClick(Sender: TObject);
begin

  If (ConfirmQuit) then
    Close;
end;


function TSalesTBody.I1PrYrFConvDate(Sender: TObject; const IDate: string;
  const Date2Pr: Boolean): string;

Begin

  Result:=ConvInpPr(IDate,Date2Pr,@ExLocal);

end; {Proc..}


Function TSalesTBody.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and ((CheckNeedStore) or (ForceStore)) and (Not TransactionViewOnly) and (Not InvStored) then
  Begin
    If (Current_Page>1) then {* Force view of main page *}
      ChangePage(0);

    If (ForceStore) then
      mbRet:=MessageDlg('This Transaction must be stored',mtWarning,[mbOk],0)
    else
      mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes
           :  Begin
                StoreInv(InvF,CurrKeyPath^[InvF],LPickMode);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not TransactionViewOnly) then
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


procedure TSalesTBody.SetInvStore(EnabFlag,
                                  VOMode  :  Boolean);

Var
  Loop  :  Integer;
// CJS 2014-09-01 - v7.x Order Payments - T111 - Edit SOR - Disable nominated TH/TL fields and buttons if payments detected
{$IFDEF SOP}
  iOPTransactionPaymentInfo : IOrderPaymentsTransactionPaymentInfo;
{$ENDIF SOP}
Begin

  ExLocal.InAddEdit:=Not VOMode or FAllowPostedEdit;

  OkI1Btn.Enabled:=Not VOMode or FAllowPostedEdit;
  CanI1Btn.Enabled:=Not VOMode or FAllowPostedEdit;

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
                If (Components[Loop] is TCheckBox) then
                Begin
                  If (TCheckBox(Components[Loop]).Tag=1) then
                    TCheckBox(Components[Loop]).Enabled:= Not VOMode;
                end
                else
                  If (Components[Loop] is TSBSComboBox) then
                  Begin
                    If (TSBSComboBox(Components[Loop]).Tag=1) then
                      TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
              end;
  end; {Loop..}

  {* Set currency to readonly, if receipt part of SRI present *}

  SetCurrStat;

  // CJS 2014-09-01 - v7.x Order Payments - T111 - Edit SOR - Disable nominated TH/TL fields and buttons if payments detected
  {$IFDEF SOP}
  // If we're in View-Only mode these fields will already be disabled
  // MH 19/09/2014 ABSEXCH-15636: Explicitely checked for EDIT mode rather than by implication of thOrderPaymentElement being set
  if (not VOMode) And ExLocal.LastEdit then
  begin
    // MH 23/09/2014: Modified to share transaction tracker with customisation - they are
    // essentially doing the same thing and sharing the object eliminates any data access
    // overhead in the customisation
    // MH 06/11/2014 ABSEXCH-15798: Locked down Order Payments SDN/SIN to prevent Account/Currency being changed
    If (Not OrderPaymentsCustomisationTransactionTracker(ExLocal.LInv).cttCanEdit) Or (ExLocal.LInv.thOrderPaymentElement In [opeDeliveryNote, opeInvoice]) Then
    Begin
      // Payments found or it is an Order Payments SDN/SIN - disable controls
      I1AccF.Enabled := False;
      I1CurrF.Enabled := False;
      I5MVATF.Enabled := False;

      // MH 06/11/2014 ABSEXCH-15798: Added lock down on Settlement Discount if payments taken against the transaction
      If (Not OrderPaymentsCustomisationTransactionTracker(ExLocal.LInv).cttCanEdit) Then
      Begin
        I5SDPF.Enabled := False;  // Settlement Discount %
        I5SDDF.Enabled := False;  // Settlement Discount Days
        I5SDTF.Enabled := False;  // Settlement Discount Taken

        //PR: 27/01/2015 ABSEXCH-15964 Once payments have been taken Fixed rate is set and can't be changed.
        if (ExLocal.LInv.InvDocHed = SOR) then
          FixXRF.Enabled := False;

      End; // If (Not OrderPaymentsCustomisationTransactionTracker(ExLocal.LInv).cttCanEdit)
    End; // If (Not OrderPaymentsCustomisationTransactionTracker(ExLocal.LInv).cttCanEdit) Or (ExLocal.LInv.thOrderPaymentElement In [opeDeliveryNote, opeInvoice])
  end;
  {$ENDIF}

end;

procedure TSalesTBody.GetAutoSettings;

Var
  mrResult  :  Word;

begin
  With ExLocal,LInv do
  Begin
    ASCtrl:=TAutoTxPop.Create(Self);

    try

      With ASCtrl do
      Begin
        ASTransDate:=TransDate;
        ASAutoIncBy:=AutoIncBy;
        ASAutoInc:=AutoInc;
        ASUntilDate:=UntilDate;
        ASPr:=ACPr;
        ASYr:=ACYr;
        ASUPr:=UnPr;
        ASUYr:=UnYr;
        ASAutoPost:=AutoPost;
        ASKeepDate:=OnPickRun;

        With I1AccF do
          mrResult:=InitAS(LViewOnly,Color,Font);

        If (mrResult=mrOk) then
        Begin
          TransDate:=ASTransDate;
          AutoIncBy:=ASAutoIncBy;
          AutoInc:=ASAutoInc;
          UntilDate:=ASUntilDate;
          AcPr:=ASPr;
          ACYr:=ASYr;
          UnPr:=ASUPr;
          UnYr:=ASUYr;
          AutoPost:=ASAutoPost;
          OnPickRun:=ASKeepDate;

          If (AutoIncBy=DayInc) then
            DueDate:=CalcDueDate(TransDate,AutoInc);

          SetInvFields;
        end;


      end;
    finally

      ASCtrl.Free;

    end; {Try..}

  end; {with..}
end; {Proc..}



(*  Add is used to add Customers *)

procedure TSalesTBody.ProcessInv(Fnum,
                                 KeyPAth    :  Integer;
                                 Edit,
                                 AutoOn     :  Boolean);

Var
  KeyS       :  Str255;

  FOLDeter   :  DocTypes;

  {$IFDEF LTE}
    td,tm,ty,tyu  :  Word;

  {$ENDIF}


Begin

  Addch:=ResetKey;

  KeyS:='';

  FOLDeter:=FOL;

  Elded:=Edit;

  FirstStore:=Not Edit;

  OldConTot:=0;

  If (Edit) then
  Begin

    With ExLocal do
    Begin
      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);

      If (Not TransactionViewOnly) then
      Begin
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked);

       (* If (Ok) and (LInv.RunNo>0) then {* its posted.. }
          Ok:=BOff; *)
      end
      else
        Ok:=BOn;


      OldConTot:=ConsolITotal(LInv);

      //PR: 24/08/2012 ABSEXCH-13333
      OldOrderConTot := ConvCurrOrderTotal(LInv, UseCoDayRate, True);

      //PR: 20/06/2012 ABSEXCH-11528 Store previous OS value
      {$IFDEF SOP}
      PreviousOS := TransOSValue(LInv);
      {$ENDIF}
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


    If (Not Edit) then
    Begin
      Caption:=DocNames[DocHed]+' Record';

      LResetRec(Fnum);

      RunNo:=0+(AutoRunNo*Ord(AutoOn));

      NomAuto:=Not AutoOn;

      InvDocHed:=DocHed;

      If (InvDocHed In DirectSet) then
        CustCode:=GetProfileAccount(SalesOrPurch(DocHed));

      {$IFDEF SOP}
        If (InvDocHed In PSOPSet) then
          RunNo:=Set_OrdRunNo(InvDocHed,AutoOn,BOff);
      {$ENDIF}


      TransDate:=Today; AcPr:=GetLocalPr(0).CPr; AcYr:=GetLocalPr(0).CYr;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
        Date2Pr(TransDate,AcPr,AcYr,@ExLocal);

      // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
      ShowSettlementDiscountFields (TransactionHelper(@ExLocal.LInv).SettlementDiscountSupported);

      NLineCount:=1;
      ILineCount:=1;


      If Syss.Intrastat then
      Begin
        TransNat:=SetTransNat(InvDocHed);

        TransMode:=1;
      end;


    {$IFDEF MC_On}

      Currency:=1;

      CXrate[BOn]:=SyssCurr.Currencies[Currency].CRates[BOn];

      VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;

    {$ELSE}

      Currency:=0;

      CXrate:=SyssCurr.Currencies[Currency].CRates;


    {$ENDIF}

    {* Preserve original Co. Rate *}

    OrigRates:=SyssCurr.Currencies[Currency].CRates;

    SetTriRec(Currency,UseORate,CurrTriR);
    SetTriRec(Syss.VATCurr,UseORate,VATTriR);
    SetTriRec(Currency,UseORate,OrigTriR);
    OpName:=EntryRec^.Login;

    CustSupp:=TradeCode[(InvDocHed In SalesSplit)];

    If (InvDocHed In PSOPSet) then {* Set a separator in ledger *}
      CustSupp:=Chr(Succ(Ord(CustSupp)));


    {FRVATCode:=VATSTDCode;}


    {$IFDEF SOP}

      If (DocHed In PSOPSet+QuotesSet) then
        FOLDeter:=AFL
      else
        FOLDeter:=FOL;

      FolioNum:=GetNextCount(FOLDeter,BOff,BOff,0);

    {$ENDIF}

      If (Not AutoOn) then
      Begin

        OurRef:=FullDocNum(DocHed,BOff);

        If (Not (InvDocHed In PSOPSet)) then
          DueDate:=CalcDueDate(TransDate,30)
        else
          DueDate:=TransDate;

      end
      else
      Begin
        OurRef:=FullAutoDocNum(DocHed,BOff);

        DueDate:=TransDate;

        AutoIncBy:=DayInc;

        AutoInc:=30;

        UntilDate:=MaxUntilDate;

        UnYr:=MaxUnYr;

        {$IFDEF LTE}
          DateStr(TransDate,td,tm,ty);

          DateStr(UntilDate,td,tm,tyu);

          UntilDate:=StrDate(ty+3,tm,td);

          SimpleDate2Pr(UntilDate,UnPr,UnYr);

        {$ENDIF}


        UnPr:=Syss.PrInYr;
      end;

      OutInv;

      {$IFDEF SOP}
        TTDHelper.ScanTransaction(ExLocal.LInv);
      {$ENDIF}

      If (Not Edit) then
        ReFreshList(BOn,Not JustCreated);

    end
    else
    Begin
      {.$IFNDEF JC}

        {* Add to list as currently being edited *}

        If (Not TransactionViewOnly) then
          Add_DocEditNow(LInv.FolioNum);

      {.$ENDIF}
    end;

    LastInv:=LInv;

    DirectStore:=(InvDocHed In DirectSet);

    SetInvStore(BOn,LViewOnly);


    If (AutoOn) then {* Get Auto Settings *}
    Begin
      GetAutoSettings;
    end;

    If (LPickMode) then
      MulCtrlO.SetListFocus
    else
      SetFieldFocus;

  end {If Abort..}
  else
  Begin
    SetViewOnly(BOn,ExLocal.LViewOnly);
    PrimeButtons;
    if Assigned(NotesCtrl) then
      SwitchNoteButtons(Self, NotesCtrl.NoteMode);
  end;


end; {Proc..}

Procedure TSalesTBody.SetCtrlNomStat;


Begin

  With ExLocal do
  If (Not LViewOnly) then
  With DMDCNomF do
  Begin
    ReadOnly:=((Text='') and (LCust.DefCtrlNom=0));

    TabStop:=Not ReadOnly;

  end;
end;

//-------------------------------------------------------------------------

// MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
procedure TSalesTBody.SetDefaultSettlementDiscount;
Var
  LocalCust : CustRec;
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

  // MH 26/08/2015 2015-R1 ABSEXCH-16790: Take PPD Percentage/Days from Head Office where applicable
  PPDMode := ExLocal.LCust.acPPDMode;
  PPDDiscountPercentage := ExLocal.LCust.DefSetDisc;
  PPDDiscountDays := ExLocal.LCust.DefSetDDays;
  // MH 28/08/2015 2015-R1 ABSEXCH-16790: Only use Head-Office PPD for Quotes and Orders
  If (Trim(ExLocal.LCust.SOPInvCode) <> '') And (DocHed In [SQU, PQU, SOR, POR]) Then
  Begin
    // Load Head-Office account and get their PPD settings
    LocalCust := ExLocal.LCust;
    If ExLocal.LGetMainRecPosKey (CustF, CustCodeK, FullCustCode(ExLocal.LCust.SOPInvCode)) Then
    Begin
      PPDMode := ExLocal.LCust.acPPDMode;
      PPDDiscountPercentage := ExLocal.LCust.DefSetDisc;
      PPDDiscountDays := ExLocal.LCust.DefSetDDays;
    End; // If ExLocal.LGetMainRecPosKey (CustF, CustCodeK, FullCustCode(ExLocal.LCust.SOPInvCode))
    ExLocal.LCust := LocalCust;
  End; // If (Trim(ExLocal.LCust.SOPInvCode) <> '') And (DocHed In [SQU, PQU, SOR, POR])
End; // SetDefaultSettlementDiscount

//------------------------------

procedure TSalesTBody.I1AccFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  WTrig,
  FoundOk,
  AltMod     :  Boolean;

  BalNow     :  Double;

  TempCust   :  CustRec;
  sTempCustCode : String[6];
begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Strip('B',[#32],Text);

    AltMod:=Modified;

    //PR: 03/02/2009 Store existing Customer Code in case we're editing and it gets changed
    sTempCustCode := Cust.CustCode;

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>ClsI1Btn) and (ActiveControl<>CanI1Btn)  then
    Begin

      //PR: 04/10/2013 MRD 1.1.17 Set consumer prefix if we previously had a consumer
      // CJS 2013-11-05 - MRD1.1.47 - Consumer Support - the check for the
      // consumer prefix is no longer required, as this is now handled by the
      // Extended Search.
      //PR: 27/11/2013 Still need the code below for installations that aren't using
      //the Extended Search
      // CJS 2013-12-20 - ABSEXCH-14875 - moved this check so that it is
      // applied before calling the Extended Search, rather than just before
      // the GetCust() call below.
      if WasConsumer then
      begin
        if Copy(FoundCode, 1, 1) <> CONSUMER_PREFIX then
          FoundCode := CONSUMER_PREFIX + FoundCode;
      end;

      {$IFDEF CU} {* Call hooks here *}
      FoundCode:=TextExitHook(2000,6,FoundCode,ExLocal);
      {$ENDIF}

      StillEdit:=BOn;

      { CJS 2013-02-26 - ABSEXCH-11276 - Extended Search - ESC key handling }
      if (FoundCode <> 'EXTSEARCH CANCELLED') then
      begin
        FoundOk:=(GetCust(Self,FoundCode,FoundCode,IsACust(ExLocal.LInv.CustSupp),3));

        //PR: 06/03/2013 ABSEXCH-13976 v7.0.2 Can't add DoFocusFix in TextExitHook call as it
        //causes the exit event to be called repeatedly if esc is pressed on ExtendedSearch.
        // MH/CS 10/04/2013 v7.0.3 ABSEXCH-14206: Fixed infinite loop created by Paul's mod
        If FoundOK Then
          PostMessage(GetFocus, WM_SETFOCUS, 0, 0);
      end
      else
        FoundOk := False;

      {$IFDEF CU} {* Call hooks here *}

        If (FoundOk) and (Not ExLocal.LastEdit) then
        With ExLocal do
        Begin
          TempCust:=LCust;
          ExLocal.AssignFromGlobal(CustF);
          FoundOk:=ValidExitHook(2000,189,ExLocal,DoFocusFix);
          LCust:=TempCust;
        end;

      {$ENDIF}


      {$IFDEF JC}
        {$IFDEF PF_On}
           If (FoundOK) and (JBCostOn) and (DocHed=PPI) then
             FoundOk:=Not Cert_Expired(FoundCode,Today,BOn,BOn);
        {$ENDIF}
      {$ENDIF}


      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin
        //PR: 03/02/2009  20081113135757 If we're editing then the original transaction total is
        //stored in OldConTot and is subtracted from the account balance when we do the credit check.
        //However, if the Account Code has been changed then we don't want to do this, so set OldConTot to zero.
        if (ExLocal.LastEdit) and (Cust.CustCode <> sTempCustCode) then
          OldConTot := 0;

        AssignFromGlobal(CustF);

        CustToMemo(LCust,I1AddrF,0);

        {BalNow:=Get_CurCustBal(LCust)-OldConTot;

        FoundOk:=(Not Warn_ODCredit(BalNow,LCust,Bon,BOn,Self));}

        {$B-}

        FoundOk:=(LInv.InvDocHed In QuotesSet) or  (Not Check_AccForCredit(LCust,0,OldConTot,BOn,BOn,WTrig,Self));

        {$B+}

        SendToObjectCC(FoundCode,0);
      end;


      If (FoundOk) then
      Begin

        StopPageChange:=BOff;

        StillEdit:=BOff;

        ExLocal.LInv.TransMode := ExLocal.LCust.SSDModeTr;

        Show_IntraStat(Syss.IntraStat and ExLocal.LCust.EECMember, BOn);

        //PR: 03/10/2013 MRD Set contents of a/c code field appropriately for trader type
        if IsConsumer(ExLocal.LCust) then
        begin
          Text := Trim(ExLocal.LCust.acLongACCode);
          WasConsumer := True; //Set consumer indicator
          //ResizeAcCodeField(True);
        end
        else
        begin
          Text:=FoundCode;
          WasConsumer := False; //Set consumer indicator
          //ResizeAcCodeField(False);
        end;



        With ExLocal,LInv do
        Begin
          // MH 20/05/2015 v7.0.14: Populate LInv.CustCode with the proper code - previously it
          // would contain whatever partial code had been passed into the hook point above which
          // was then breaking the PPD Code below.
          LInv.CustCode := LCust.CustCode;

          DAddr:=LCust.DAddr;

          // MH 14/10/2013 - MRD2.5 - Delivery PostCode
          thDeliveryPostCode := LCust.acDeliveryPostCode;

          // MH 29/01/2016 2016-R1 ABSEXCH-17225: Only copy Delivery Country across if another
          // element of the Delivert Address is set - otherwise affects Intrastat To Country on
          // Sales transactions
          If (Trim(LCust.DAddr[1]) <> '') Or (Trim(LCust.DAddr[2]) <> '') Or (Trim(LCust.DAddr[3]) <> '') Or
             (Trim(LCust.DAddr[4]) <> '') Or (Trim(LCust.DAddr[5]) <> '') Or (Trim(LCust.acDeliveryPostCode) <> '') Then
            // MH 20/04/2015 2015R1 ABSEXCH-16353: Copy in Delivery Country from Trader
            thDeliveryCountry := LCust.acDeliveryCountry
          Else
            // Clear down any pre-existing Country Code
            thDeliveryCountry := '';

          {I1TransDateF.DateModified:=BOn; {* v5.61. Converted this to a post message further down as cusror was being lost

          I1TransDateFExit(Sender);}

          DMDCNomF.Text:=Form_BInt(LCust.DefCtrlNom,0);


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
          I5SDPF.Value := SettlementDiscountPercentage;
          I5SDDF.Value := SettlementDiscountDays;

          // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
          ccyPPDPercentage.Value := PPDDiscountPercentage;
          ccyPPDDays.Value := PPDDiscountDays;

          // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
          DisplayPPDFields;

          // CJS 2014-08-04 - v7.X Order Payments - T030 - added Order Payments panel
          If (InvDocHed = SOR) And Syss.ssEnableOrderPayments Then
          Begin
            ShowOrderPaymentsArea (LCust.acAllowOrderPayments);

            // Update the footer tab
            OutInvFooterTot;
          End; // If (InvDocHed = SOR) And Syss.ssEnableOrderPayments

          // PKR. 24/02/2016. ABSEXCH-17318. Intrastat settings are not pulled from the Trader record
          // after upgrading from Core to Stock.
          // Changed from {$IFDEF SOP} to {$IFDEF STK}
          {$IFDEF STK}
            // MH 19/05/2016 2016-R2 ABSEXCH-17428: Only copy in defaults if Intrastat is enabled
            If Syss.IntraStat Then
            Begin
              {$IFNDEF EXDLL}
              // CJS 2016-01-12 - ABSEXCH-17100 - Intrastat fields for Transaction Header
              cbDeliveryTerms.ItemIndex := IntrastatSettings.IndexOf(stDeliveryTerms, ifCode, Trim(LCust.SSDDelTerms));

              // CJS 2016-01-25 - ABSEXCH-17173 Mode of Transport is not being picked up from the Trader
              cbModeOfTransport.ItemIndex := IntrastatSettings.IndexOf(stModeOfTransport, ifCode, IntToStr(LCust.SSDModeTr));
              {$ENDIF}

              // CJS 2016-01-22 - ABSEXCH-17180 - Default NoTC on Transaction Headers & Lines
              if cbNotc.ItemIndex < 0 then
                cbNoTc.ItemIndex := DefaultNoTCIndex;
            End; // If Syss.IntraStat

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

            GenHooks(2000,9,ExLocal,DoFocusFix);

            I4JobCodeF.Text:=LInv.DJobCode;

            GenHooks(2000,190,ExLocal,DoFocusFix);

            I4JobAnalF.Text:=LInv.DJobAnal;
          {$ENDIF}

          {$IFDEF PF_On}

            If (Not EmptyKey(OrigValue,CustKeyLen)) and ((ExLocal.LastEdit) or (ForceStore)) then {* Re_calc discounts *}
            Begin
              {$IFDEF JC}
                If (CISOn) then
                Begin
                  LInv.CustCode:=FullCustCode(Text);
                  Reset_DOCCIS(LInv,BOn);
                end;
              {$ENDIF}

              {.$IFDEF STK} {ENv5.71, allowed so VAT codes are recalculated}

                Re_CalcDocPrice(10,LInv, (SyssVAT.VATRates.EnableECServices And (Not LCust.EECMember)));

              {.$ENDIF}

              // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
              If ((nbSettleDisc.PageIndex = SettleDiscPage) And (LInv.DiscSetl <> Pcnt(I5SDPF.Value))) Or
                 ((nbSettleDisc.PageIndex = PromptPaymentDiscountPage) And (LInv.thPPDPercentage <> Pcnt(ccyPPDPercentage.Value))) Then
                ReApplyVAT(IfThen(nbSettleDisc.PageIndex = SettleDiscPage, I5SDPF.Value, ccyPPDPercentage.Value));

              If (LastEdit) then
                ForceStore:=(ForceStore or (ITotal(LInv)<>Itotal(LastInv)));

              MULCtrlO.PageUpDn(0,BOn);

              OutInvTotals(Current_Page);

            end;

          {$ENDIF}

          {* v5.61. This post message exxecutes the TransDate Exit routine which was being
          called from above but loosing the date cursor *}
          PostMessage(Self.Handle,WM_FormCloseMsg,87,0);
        end;

        {* Weird bug when calling up a list caused the Enter/Exit methods
             of the next field not to be called. This fix sets the focus to the next field, and then
             sends a false move to previous control message ... *}
        If (IsWINNT4) then
          FieldNextFix(Self.Handle,ActiveControl,Sender); {* Added back in for NT v4? *}

      end
      else
        If (CanFocus) then
        Begin
          StopPageChange:=BOn;
          SetFocus;
        end; {If not found..}
    end;

    {$IFDEF CU} {* Call notification hook regardless of edit state *}

        GenHooks(2000,101,ExLocal,DoFocusFix);

    {$ENDIF}


  end; {with..}
end;

//-------------------------------------------------------------------------

// MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
Procedure TSalesTBody.ShowSettlementDiscountFields (Const ShowFields : Boolean);
Begin // ShowSettlementDiscountFields
  // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
  If ShowFields Then
  Begin
    nbSettleDisc.PageIndex := SettleDiscPage;   // Settlement Discount

    // MH 23/03/2015 v7.0.14 ABSEXCH-16287: Warning Message not displayed on storing a zero value transaction
    // PS 25/10/2016 2016 R3 ABSEXCH-16440 - added ExLocal.InAddEdit to control calculation of VAT
    If (ExLocal.LInv.ILineCount > 1) and (ExLocal.InAddEdit) Then
      ReApplyVAT(I5SDPF.Value);
  End // If ShowFields
  Else
  Begin
    // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
    DisplayPPDFields;

    // MH 23/03/2015 v7.0.14 ABSEXCH-16287: Warning Message not displayed on storing a zero value transaction
    // PS 25/10/2016 2016 R3 ABSEXCH-16440 - added ExLocal.InAddEdit to control calculation of VAT
    If (nbSettleDisc.PageIndex = PromptPaymentDiscountPage) And (ExLocal.LInv.ILineCount > 1) and (ExLocal.InAddEdit) Then
      ReApplyVAT(ccyPPDPercentage.Value);
  End; // Else
End; // ShowSettlementDiscountFields

//------------------------------

procedure TSalesTBody.I1TransDateFExit(Sender: TObject);
Var
  TransactionHelperIntf : ITransactionHelper_Interface;
  SettlementDiscountEligibilityChanged : Boolean;
  WasMod  :  Boolean;
begin
  TransactionHelperIntf := TransactionHelper(@ExLocal.LInv);
  Try
    With ExLocal, LInv, I1TransDateF do
    Begin
      WasMod:=Modified or DateModified or (TransDate<>DateValue);

      // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Check to see if the eligibility has changed
      SettlementDiscountEligibilityChanged := SettlementDiscountSupportedForDate (LInv.TransDate) <> SettlementDiscountSupportedForDate (I1TransDateF.DateValue);

      If {(DateModified) and} (Not LastEdit) and (ValidDate(DateValue)) then
      Begin
        TransDate:=DateValue;

        If (Not (InvDocHed In PSOPSet)) then
          I1DueDateF.DateValue:=CalcDueDate(TransDate,LCust.PayTerms);

        If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
        With I1PrYrF do
        Begin
          Date2Pr(TransDate,AcPr,AcYr,@ExLocal);

          InitPeriod(AcPr,AcYr,BOn,BOn);
        end;
      end;

      If (WasMod) and (InAddEdit)  then
      Begin
        {$IFDEF STK}
          TransDate:=DateValue;
        {* v5.61. This post message exxecutes the TransDate Exit routine which was being
            called from above but loosing the date cursor *}

          PostMessage(Self.Handle,WM_FormCloseMsg,88,1);
        {$ENDIF}

        // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
        If SettlementDiscountEligibilityChanged Then
        Begin
          ShowSettlementDiscountFields (TransactionHelperIntf.SettlementDiscountSupported);

          // MH 11/06/2015 v7.0.14 ABSEXCH-16535: Set Settlement Discount fields from PPD fields
          If TransactionHelperIntf.SettlementDiscountSupported Then
          begin
             // Set Settlement Discount fields from the PPD fields
             I5SDPF.Value := ccyPPDPercentage.Value;
             I5SDPF.FloatModified := True;
             I5SDPFExit(I5SDPF);

             I5SDDF.Value := ccyPPDDays.Value;
          End // If TransactionHelperIntf.SettlementDiscountSupported
          Else
          Begin
             // Set PPD fields from the Settlement Discount fields
             ccyPPDPercentage.Value := I5SDPF.Value;
             ccyPPDPercentage.FloatModified := True;
             I5SDPFExit(ccyPPDPercentage);

             ccyPPDDays.Value := I5SDDF.Value;
          End; // Else

          OutInvTotals(Current_Page);

          // MH 23/03/2015 v7.0.13 ABSEXCH-16287: Setting ForceStore on Add causes the OurRef not to be set properly
          If ExLocal.LastEdit Then
            ForceStore := True;
        End; // If SettlementDiscountEligibilityChanged
      end;

    end;
  Finally
    TransactionHelperIntf := NIL;
  End; // Try..Finally
end;

procedure TSalesTBody.I1PrYrFExit(Sender: TObject);
begin
  If (Not I1PrYrF.ReadOnly) and (I1PrYrF.Modified) then
  Begin
    Form2Inv;

    With ExLocal,LInv do
    Begin
      {$IFDEF CU} {* Call any pre store hooks here *}

        GenHooks(2000,8,ExLocal,DoFocusFix);

        OutInv;

      {$ENDIF}
    end;
  end;
end;

procedure TSalesTBody.I1DueDateFExit(Sender: TObject);

Var
  FoundCode
         :  Str20;

  AltMod :  Boolean;

  mbRet  :  Word;
begin
  {$IFDEF SOP}

  With ExLocal,LInv,I1DueDateF do
  Begin
    FoundCode:=Strip('B',[#32],DateValue);

    If (ActiveControl<>ClsI1Btn) and (ActiveControl<>CanI1Btn)  then
    Begin

      {$IFDEF CU} {* Call hooks here *}

          DateValue:=TextExitHook(2000,50,FoundCode,ExLocal,DoFocusFix);

      {$ENDIF}


      If (DateModified) and (ValidDate(DateValue)) then
      Begin
        If ((InvDocHed In OrderSet)) and ((ILineCount>1) or (ITotal(LInv)<>0.0)) then
          UpDateDel:=(CustomDlg(Application.MainForm,'Please Confirm...','Change Delivery Date',
                               'Do you wish to apply this delivery date to all lines?'+#13+#13+
                               '(Changes to the delivery date on each line will not be applied '+
                               'until the order is stored.)',
                               mtConfirmation,
                               [mbYes,mbNo])=mrOk)

      end
      else
      Begin
        {$IFDEF CU} {* Call hooks here *}
            If EnableCustBtns(2000,51) then
              UpDateDel:=ValidExitHook(2000,51,ExLocal,DoFocusFix);

       {$ENDIF}

      end;
    end;
  end;
  {$ENDIF}
end;

procedure TSalesTBody.I1CurrFExit(Sender: TObject);
begin
  {$IFDEF MC_On}
     With ExLocal,LInv,I1CurrF do
     If (Modified) and (OrigValue<>Text) then
     Begin
       Currency:=Succ(I1CurrF.ItemIndex);

       CXRate:=SyssCurr.Currencies[Currency].CRates;

       If (Not (InvDocHed In DirectSet)) then
         CXRate[BOff]:=0;

       VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;

       SetTriRec(Currency,UseORate,CurrTriR);

       SetTriRec(Syss.VATCurr,UseORate,VATTriR);

       I1ExRateF.Value:=CXrate[BOn];

       CurrLab1.Caption:=SSymb(Currency);

       If (Not LViewOnly) then
         I1ExRateF.ReadOnly:=(SyssGCuR^.GhostRates.TriEuro[Currency]<>0) or (Currency=1) or (Not CanEditTriEuro(Currency));
     end;
  {$ENDIF}
end;


procedure TSalesTBody.I5VV1FExit(Sender: TObject);
begin
  VATMatrix.Update_Rate(Sender,ExLocal.LInv);
  OutInvFooterTot;
  OutInvTotals(Current_Page);
end;


procedure TSalesTBody.ReApplyVAT(Value  :  Real);
Begin
  With ExLocal,LInv do
  Begin
    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
    If (nbSettleDisc.PageIndex = SettleDiscPage) Then
    Begin
      // Settlement Discount
      DiscSetl:=Pcnt(Value);
      thPPDPercentage := 0.0;
    End // If (nbSettleDisc.PageIndex = SettleDiscPage)
    Else
    Begin
      // Prompt Payment Discount
      DiscSetl:=0.0;
      // MH 20/05/2015 v7.0.14 ABSEXCH-16448: PPD Fields populated when PPD Disabled on Trader
      // MH 26/08/2015 2015-R1 ABSEXCH-16790: Take PPD Percentage/Days from Head Office where applicable
      If (PPDMode <> pmPPDDisabled) Then
        thPPDPercentage := Pcnt(Value)
      Else
        thPPDPercentage := 0.0;
    End; // Else

    Re_CalcManualVAT(LInv,ExLocal,DiscSetl);

    OutInvFooterTot;

  end;


end;

procedure TSalesTBody.I5SDPFExit(Sender: TObject);
Var
  // MH 30/06/2015 v7.0.14 ABSEXCH-16600: Limit PPD to a maximum discount percentage of 99.99%
  MaxVal : Double;
begin
  If (Sender is TCurrencyEdit) then
  With TCurrencyEdit(Sender) do
  Begin
    If (FloatModified) then
    With ExLocal,LInv do
    Begin
      // CJS 21/03/2011 ABSEXCH-11089
      // MH 30/06/2015 v7.0.14 ABSEXCH-16600: Limit PPD to a maximum discount percentage of 99.99%
      MaxVal := IfThen(Sender=I5SDPF, 100.00, 99.99);
      if Value > MaxVal then
        Value := MaxVal;

      // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
      If (ILineCount > 1) Then
        ReApplyVAT(Value);

      OutInvTotals(Current_Page);
    end;
  end;

end;


// MH 11/06/2015 v7.0.14 ABSEXCH-16521: Update PPD Status when PPD Days are changed
procedure TSalesTBody.ccyPPDDaysExit(Sender: TObject);
begin
  If (Sender is TCurrencyEdit) Then
  Begin
    With TCurrencyEdit(Sender) Do
    Begin
      If FloatModified Then
      Begin
        // MH 30/06/2015 v7.0.14 ABSEXCH-16600: Limit PPD to a maximum discount days of 999
        If (Value < 0) Then
          Value := 0
        Else If (Value > 999) Then
          Value := 999;

        ExLocal.LInv.thPPDDays := Round(Value);
        UpdatePPDStatusInfo;
      End; // If FloatModified
    End; // With TCurrencyEdit(Sender)
  End; // If (Sender is TCurrencyEdit)
end;


procedure TSalesTBody.I4JobCodeFExit(Sender: TObject);
begin
  { CJS 2012-09-03 - ABSEXCH-12393 - Job Code Validation }
  ValidateJobCode;
end;




procedure TSalesTBody.I4JobAnalFExit(Sender: TObject);

Var
  FoundCode  :  Str20;
  FoundOk, AltMod     :  Boolean;
begin
  {$IFDEF PF_On}
    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (((AltMod) or (FoundCode='')) and (Not EmptyKey(I4JobCodeF.Text,JobCodeLen))) and (ActiveControl<>ClsI1Btn) and (ActiveControl<>CanI1Btn) and (JBCostOn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,2,Anal_FiltMode(DocHed)));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          StopPageChange:=BOff;

          AssignFromGlobal(JMiscF);

          Text:=FoundCode;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

          {$IFDEF JC}
            {If (fAutoJCPage) then
              AutoPromptJC(Sender);}
          {$ENDIF}

        end
        else
        Begin
          {StopPageChange:=BOn;}

            SetFocus;
        end; {If not found..}
      end;

    end;
  {$ENDIF}

end;

procedure TSalesTBody.edtOverrideLocationExit(Sender: TObject);
(*
Var
  FoundCode : Str10;
  FoundOK : Boolean;
*)
begin
  ValidateOverrideLocation(False);
  {$IFDEF SOP}
(*
    If edtOverrideLocation.Visible And edtOverrideLocation.Enabled Then
    Begin
      // Can be left blank, if set it must be a valid Location Code
      FoundCode:=Trim(edtOverrideLocation.Text);
      If (FoundCode <> '') Then
      Begin
        FoundOk := GetMLoc(Self.Owner, FoundCode, FoundCode, '', 0);
        If FoundOK Then
        Begin
          edtOverrideLocation.Text := FoundCode;
        End // If FoundOK
        Else
        Begin
          If edtOverrideLocation.CanFocus Then
            edtOverrideLocation.SetFocus;
        End; // Else
      End; // If (FoundCode <> '')

      If (((AltMod) or (FoundCode='')) and (Not EmptyKey(I4JobCodeF.Text,JobCodeLen))) and (ActiveControl<>ClsI1Btn) and (ActiveControl<>CanI1Btn) and (JBCostOn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,2,Anal_FiltMode(DocHed)));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          StopPageChange:=BOff;

          AssignFromGlobal(JMiscF);

          Text:=FoundCode;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

          {$IFDEF JC}
            {If (fAutoJCPage) then
              AutoPromptJC(Sender);}
          {$ENDIF}

        end
        else
        Begin
          {StopPageChange:=BOn;}

            SetFocus;
        end; {If not found..}
      end;
    End; // If edtOverrideLocation.Visible And edtOverrideLocation.Enabled
*)
  {$ENDIF}
end;

function TSalesTBody.ValidateOverrideLocation(PromptIfEmpty: Boolean = True): Boolean;
var
  FoundCode : Str10;
  FoundOK : Boolean;
begin
  Result := True;
{$IFDEF SOP}
  If edtOverrideLocation.Visible And edtOverrideLocation.Enabled Then
  Begin
    // Can be left blank, if set it must be a valid Location Code
    FoundCode:=Trim(edtOverrideLocation.Text);
    If (FoundCode <> '') Then
    Begin
      FoundOk := GetMLoc(Self.Owner, FoundCode, FoundCode, '', 0);
      If FoundOK Then
      Begin
        edtOverrideLocation.Text := FoundCode;
      End // If FoundOK
      Else
      Begin
        Result := False;
        If edtOverrideLocation.CanFocus Then
          edtOverrideLocation.SetFocus;
      End; // Else
    End // If (FoundCode <> '')
    else if PromptIfEmpty then
    begin
      if MessageDlg('The Override Location has not been set. Are sure you want to add a transaction line?',
                    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Result := False;
    end;
  end;
{$ENDIF}
end;


procedure TSalesTBody.TransExtForm1Enter(Sender: TObject);
begin
  Show_IntraStat((Syss.IntraStat or JBFieldOn),ExLocal.LCust.EECMember or JBFieldOn);
end;


procedure TSalesTBody.I1YrRefFEnter(Sender: TObject);
begin
  {$IFDEF CU}
    If (Not I1YrRefF.ReadOnly) and (Sender=I1YrRefF) then
    Begin
      I1YrRefF.Text:=TextExitHook(2000,65,I1YrRefF.Text,ExLocal,DoFocusFix);
      fChkYourRef:=Syss.WarnYRef;
    end;
  {$ENDIF}

end;


procedure TSalesTBody.TransExtForm1Exit(Sender: TObject);
begin
  If (fChkYourRef) and (ExLocal.LastEdit) and (FullCustCode(I1YrRefF.Text)=FullCustCode(Exlocal.LAstInv.YourRef)) then
    fChkYourRef:=BOff;
end;


procedure TSalesTBody.I1YrRefFExit(Sender: TObject);
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

    If (ActiveControl<>ClsI1Btn) and (ActiveControl<>CanI1Btn)  then
    Begin
      If ((AltMod) and (FoundCode<>'')) and (Syss.WarnYRef) then
      Begin
        //PR: 02/10/2013 MRD 1.1.17 Take a/c code directly from cust record rather than from text field as that may contain long a/c code.
        FoundOk:=(Not Check4DupliYRef(LJVar(FoundCode,DocYref1Len),FullCustCode(ExLocal.LCust.CustCode),InvF,InvYrRefK,ExLocal.LInv,'Reference ('+FoundCode+') for this account'));

      end;


      If (FoundOk) then
        Text8pt(Sender).ExecuteHookMsg;

      fChkYourRef:=BOff;

    end;    
  end; {With..}
end;

procedure TSalesTBody.AutoPromptJC(Sender: TObject);

Begin
  {$IFDEF JC}
    {If (JBCostOn) and ((I4JobCodeF.Text='') or (Sender=I4JobAnalF)) then
      SendMessage(Self.Handle,WM_FormCloseMsg,56,0);}

  {$ENDIF}

end;


procedure TSalesTBody.I1YrRef2FEnter(Sender: TObject);
begin
  {$IFDEF CU}
    If (Not I1YrRef2F.ReadOnly) and (Sender=I1YrRef2F) then
    Begin
      I1YrRef2F.Text:=TextExitHook(2000,66,I1YrRef2F.Text,ExLocal,DoFocusFix);
    end;
  {$ENDIF}

end;


procedure TSalesTBody.I1YrRef2FExit(Sender: TObject);
begin
  I1YrRefFExit(Sender);

  {$IFNDEF MC_On}
    //AutoPromptJC(Sender);
  {$ENDIF}
end;





procedure TSalesTBody.ISDelFExit(Sender: TObject);
Var
  FoundOk,
  AltMod     :  Boolean;

begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    If (AltMod) and (ActiveControl<>ClsI1Btn) and (ActiveControl<>CanI1Btn) and (Not JBFieldOn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=ValidDelTerms(Text);

      If (Not FoundOk) and (CanFocus) then {* Credit Check *}
      Begin
        SetFocus;
        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin
        {StopPageChange:=BOn;}

      end; {If not found..}

    end;
  end;

end;



procedure TSalesTBody.ISTTFExit(Sender: TObject);
Var
  FoundOk,
  AltMod     :  Boolean;

begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit) do
  Begin
    AltMod:=Modified;

    If (AltMod) and (ActiveControl<>ClsI1Btn) and (ActiveControl<>CanI1Btn) and (Not JBFieldOn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=ValidNatTran(Round(Value));

      If (Not FoundOk) and (CanFocus) then {* Credit Check *}
      Begin
        SetFocus;
        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin
        {StopPageChange:=BOn;}

      end; {If not found..}

    end;
  end;

end;






procedure TSalesTBody.ISMTFExit(Sender: TObject);
Var
  FoundOk,
  AltMod     :  Boolean;

begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit) do
  Begin
    AltMod:=Modified;

    If (AltMod) and (ActiveControl<>ClsI1Btn) and (ActiveControl<>CanI1Btn)  and (Not JBFieldOn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=ValidModeTran(Round(Value));

      If (Not FoundOk) and (CanFocus) then {* Credit Check *}
      Begin
        SetFocus;
        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin
        {StopPageChange:=BOn;}

      end; {If not found..}

    end;
  end;

end;



procedure TSalesTBody.I1EXRateFEnter(Sender: TObject);
begin


  {$IFDEF CU} {* Call hooks here *}

    If (Not I1EXRateF.ReadOnly) and (Sender=I1EXRateF) then
    Begin
      I1EXRateF.Value:=ValueExitHook(2000,7,I1EXRateF.Value,ExLocal,DoFocusFix);
    end;

  {$ENDIF}

end;

procedure TSalesTBody.I1EXRateFExit(Sender: TObject);
begin
  {$IFDEF MC_On}

    AutoPromptJC(Sender);

  {$ENDIF}
end;


procedure TSalesTBody.THUD1FEntHookEvent(Sender: TObject);
Var
  CUUDEvent  :  Byte;
  Result     :  LongInt;

begin
  {$IFDEF CU}
    CUUDEvent := 0;
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
          If (Sender=I1YrRefF) then
          Begin
            ExLocal.LInv.YourRef:=Text;
            CUUDEvent:=120;
          end
          else
          If (Sender=I1YrRef2F) then
          Begin
            ExLocal.LInv.TransDesc:=Text;
            CUUDEvent:=121;
          end    
          else //PR: 11/10/2011 Add new UDFs - Hook points are 211-216, need to subtract 60 which is added below, so 151-156
          if Sender = edtUdf5 then
          begin
            ExLocal.LInv.DocUser5:=Text;
            CUUDEvent:=151;
          end
          else
          if Sender = edtUdf6 then
          begin
            ExLocal.LInv.DocUser6:=Text;
            CUUDEvent:=152;
          end
          else
          if Sender = edtUdf7 then
          begin
            ExLocal.LInv.DocUser7:=Text;
            CUUDEvent:=153;
          end
          else
          if Sender = edtUdf8 then
          begin
            ExLocal.LInv.DocUser8:=Text;
            CUUDEvent:=154;
          end
          else
          if Sender = edtUdf9 then
          begin
            ExLocal.LInv.DocUser9:=Text;
            CUUDEvent:=155;
          end
          else
          if Sender = edtUdf10 then
          begin
            ExLocal.LInv.DocUser10:=Text;
            CUUDEvent:=156;
          end
          else
          // PKR. 24/03/2016. ABSEXCH-17383. eRCT support.
          if Sender = edtUdf11 then
          begin
            ExLocal.LInv.thUserField11:=Text;
            CUUDEvent:=157; // Actually 217 : 60 is added later.
          end
          else
          if Sender = edtUdf12 then
          begin
            ExLocal.LInv.thUserField12:=Text;
            CUUDEvent:=158; // Actually 218 : 60 is added later.
          end;

          ExLocal.LCtrlInt:=ExLocal.LInv.RunNo;

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
            121  :  Text:=LInv.TransDesc;

            //PR: 11/10/2011 v6.9 new user fields
            151  :  Text:=LInv.DocUser5;
            152  :  Text:=LInv.DocUser6;
            153  :  Text:=LInv.DocUser7;
            154  :  Text:=LInv.DocUser8;
            155  :  Text:=LInv.DocUser9;
            156  :  Text:=LInv.DocUser10;
            // PKR. 24/03/2016. ABSEXCH-17383. eRCT support.
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


procedure TSalesTBody.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>CanI1Btn) and (ActiveControl<>ClsI1Btn) then
  Begin

    Text8pt(Sender).ExecuteHookMsg;

  end;
end;



Procedure TSalesTBody.NoteUpdate;


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
  Res : Integer;

Begin
  {$IFDEF NP}
//PR: 03/06/2010 Changes to avoid storing record that is being edited.

    KeyS:=NotesCtrl.GetFolio;

    With ExLocal do
    Begin
      If (LastEdit) then  //Editing
      Begin

        //Store current header record as LiveInv
        LiveInv:=LInv;

        //Reload record from database
        OK := Find_Rec(B_GetEq, F[FNum], FNum, LRecPtr[FNum]^, KeyPath, KeyS) = 0;
      end
      else
      Begin
        Ok:=BOn;
      end;


      If (Ok) then
      With LInv  do
      Begin
        NLineCount:=NotesCtrl.GetLineNo;

        //PR: 10/07/2012 ABSEXCH-12784 Change to check
        if HasNonAuditNotes(LInv) then
          HoldMode:=232  {* Set Hold *}
        else
          HoldMode:=233;

        SetHold(HoldMode,Fnum,Keypath,BOff,LInv);

        If (LastEdit) then
        Begin
          //Store header record with updated holdflag & notes only
          Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath);
          Report_BError(Fnum,Status);

          //Set hold status and Note line count on header record in memory
          LiveInv.HoldFlg := LInv.HoldFlg;
          LiveInv.NLineCount := LInv.NLineCount;

          //Restore Header record
          LInv := LiveInv;
        end;

      end;

    end; {With..}

  {$ENDIF}


end; {Func..}




procedure TSalesTBody.DMDCNomFExit(Sender: TObject);
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

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self,FoundCode,FoundNom,78));

      If (FoundOk) then
      Begin
        StillEdit:=BOff;

        StopPageChange:=BOff;

        Text:=Form_Int(FoundNom,0);

        {* Weird bug when calling up a list caused the Enter/Exit methods
             of the next field not to be called. This fix sets the focus to the next field, and then
             sends a false move to previous control message ... *}

        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin
        ChangePage(4);

        StopPageChange:=BOn;
        SetFocus;
      end; {If not found..}
    end;
  end; {with..}
end;



 { ====================== Function to Check ALL valid invlines (InvLTotal<>0) have a nominal =============== }

Function TSalesTBody.Check_LinesOk(InvR      :  InvRec;
                                Var ShowMsg  :  Boolean;
                                Var MainStr  :  Str255)  :  Boolean;

Const
  Fnum     =  IDetailF;
  Keypath  =  IDFolioK;



Var

  KeyS,
  KeyChk    :  Str255;
  NomOk     :  Boolean;

  ExStatus  :  Integer;

  {$IFDEF CU}

    LineCU  :  TCustomEvent;

  {$ELSE}
    LineCU  :  Pointer;

  {$ENDIF}

Begin
  NomOk:=BOn;

  ExStatus:=0;

  KeyChk:=FullNomKey(InvR.FolioNum);

  KeyS:=FullIdKey(InvR.FolioNum,1);

  ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  LineCU:=Nil;

  Try

    While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NomOk) and (Id.LineNo<>RecieptCode) do
    With Id do
    Begin
      ExLocal.AssignFromGlobal(IdetailF);

      {$IFDEF CU}
        If (Not Assigned(LineCU)) then
        Begin
          LineCU:=TCustomEvent.Create(EnterpriseBase+4000, 18);

          If (LineCU.GotEvent) then
            LineCU.BuildEvent(ExLocal);

        end;

      {$ENDIF}

      NomOk:=TxLineU.CheckCompleted(Self.ExLocal.LastEdit,BOn,BOff,BOn,ExLocal,Self,LineCU,ShowMsg,MainStr,ccStoreHeader);

      ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

  Finally

    {$IFDEF CU}
      If (Assigned(LineCU)) then
        LineCU.Free;
    {$ENDIF}

  end; {Try..}

  Result:=NomOk;
end; {Func..}


Function TSalesTBody.CheckCompleted(Edit  :  Boolean)  : Boolean;

Const
  NofMsgs      =  28;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;


Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg,
  AfterMsg :  Str255;

  Test     :  Byte;

  FoundLong:  LongInt;

  FoundCode:  Str20;

  WTrig,
  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

  BalNow   :  Double;


Begin
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='Account Code is not valid.';
  PossMsg^[2]:='Currency is not valid.';
  PossMsg^[3]:=' Date not valid.';
  PossMsg^[4]:='Transaction Date is not valid.';
  PossMsg^[5]:='Financial Period is not valid.';
  PossMsg^[6]:='For local currency the exchange rate must be 1.0';
  PossMsg^[7]:='Problem with transaction lines.';
  PossMsg^[8]:='Discount value larger than Invoice value!';
  PossMsg^[9]:='Problem with commitment limit.';
  PossMsg^[10]:='Are any windows o/s?';
  PossMsg^[11]:='Spare';
  PossMsg^[12]:='Spare';
  PossMsg^[13]:='Spare';
  PossMsg^[14]:='Job Code is not valid.';
  PossMsg^[15]:='Job Analysis Code is not valid.';
  PossMsg^[16]:='Payment part of this transaction does not balance.';
  PossMsg^[17]:='The Control G/L Code is not valid.';
  PossMsg^[18]:='An exchange rate of zero is not valid.';
  PossMsg^[19]:='A '+CCVATName^+' exchange rate of zero is not valid. This value will be amended.';
  PossMsg^[20]:='The Intrastat Delivery Term is not valid.';
  PossMsg^[21]:='The Intrastat Nature of Transaction Code is not valid.';
  PossMsg^[22]:='The Intrastat Mode of Transport is not valid.';
  PossMsg^[23]:='The Sub contractor expiry has gone off.';
  PossMsg^[24]:='The Cost of this Invoice is greater than the Sales value!';
  PossMsg^[25]:='Check Authorisation levels - make this the last one to avoid annoyance factor';
  PossMsg^[26]:='Check for duplicate your ref if exit of field not set';
  PossMsg^[27]:='An additional check is made via an external hook';
  PossMsg^[28]:='The Override Location is not valid';


  Test:=1;

  Result:=BOn;

  BalNow:=0;

  AuthBy:='';


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LInv do
  Begin
    ExtraMsg:='';
    AfterMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=((GetCust(Self,CustCode,FoundCode,IsACust(CustSupp),-1))
                      and (Cust.CustSupp=SetFilterFromDoc(InvDocHed))
                      and (Not EmptyKey(CustCode,CustKeyLen))
                      and ((Cust.AccStatus<=AccClose) or ((ExLocal.LastEdit) and (Cust.CustCode=LastInv.CustCode))));
            end;

    {$IFDEF MC_On}

      2  :  Result:=(Currency In [Succ(CurStart)..CurrencyType]);

      6  :  Begin
              Result:=((Currency=1) and (CXRate[BOn]=1.0)) or (Currency>1);

            end;

    {$ENDIF}

      3  :  Begin
              Result:=ValidDate(DueDate);

              If (InvDocHed In OrderSet) then
                ExtraMsg:='Delivery'
              else
                ExtraMsg:='Due';
            end;

      4  :  Result:=ValidDate(TransDate);

      5  :  Result:=ValidPeriod(StrPeriod(ConvTxYrVal(AcYr,BOff),AcPr),Syss.PrInYr);

      7  :  If (ForceStore) or (LastEdit) then {* Only check once you are sure folio has been allocated*}
              Result:=Check_LinesOk(LInv,ShowMsg,AfterMsg);

      8  :  Result:=((ABS(Round_Up(InvNetVal,2))>=ABS(Round_Up(DiscAmount,2))) or (DiscAmount=0)
                     or ((BoChkAllowed_In(InvDocHed In SalesSplit,310) or (Not (InvDocHed In SalesSplit)))));

      9  :   With ExLocal do
             Begin
               {BalNow:=Get_CurCustBal(LCust)-OldConTot;}

               {$B-}

               {Result:=((LPickMode) or (Not Warn_ODCredit(BalNow,LCust,BOn,BOn,Self)));}

               WTrig:=BOff;

               LGetMainRecPos(CustF,CustCode);
                                                                           {* EL: v6.01 Continue check for credit hold if hook 2000,177 present *}
               Result:=((LInv.InvDocHed In QuotesSet) or ((LPickMode) {$IFDEF CU} and (Not EnableCustBtns(2000,177)) {$ENDIF} ) or (Not Check_AccForCredit(LCust,ConsoliTotal(LInv),OldConTot,BOn,BOn,WTrig,Self)));

               {$IFDEF SOP}

                 {$IFNDEF LTE}

                   If (Result) and (InvDocHed=SOR) and (Syss.UseCreditChk) then
                   Begin
                     //PR: 10/08/2015 ABSEXCH-16388 If order has been fully paid don't put on credit hold
                     if WTrig then
                       WTrig := not OrderIsFullyPaid(ExLocal.LInv);

                     If ((HoldFlg AND HoldC)<>HoldC) and (WTrig)
                      and ((HoldFlg and HoldP)<>HoldP) then
                       HoldFlg:=((HoldFlg And (HoldSuspend+HoldNotes))+HoldC)
                    else
                      If ((HoldFlg AND HoldC)=HoldC) and (Not WTrig) then
                        HoldFlg:=(HoldFlg And (HoldSuspend+HoldNotes));

                   end;

                 {$ENDIF}

                 {$IFDEF CU} {* Call any pre store hooks here *}
                   If (Result) and (InvDocHed In OrderSet) then {*See if we need to override the hold Flag*}
                   Begin
                     HoldFlg:=IntExitHook(2000,67,HoldFlg,ExLocal);

                   end;

                 {$ENDIF}
               {$ENDIF}

               {$B+}

               ShowMsg:=BOff;
             end;

      10 :  Begin {* Check if all child windows are going to close *}
              ShowMsg:=BOff;

              GenCanClose(Self,Self,Result,BOff);

            end;

      11 :   Result:=BOn;

      13 :   Result:=BOn;

      14 :   Begin

                Result:=((Not JBCostOn) or (EmptyKey(DJobCode,JobCodeLen)));

                If (Not Result) then
                  Result:=GetJob(Self,DJobCode,FoundCode,-1);

              end;


      15 :   Begin

                Result:=((Not JBCostOn) or (EmptyKey(DJobCode,JobCodeLen)));

                If (Not Result) then
                  Result:=GetJobMisc(Self,DJobAnal,FoundCode,2,-1);

              end;

      16  :  Begin
               Result:=(Not (InvDocHed In DirectSet));

               If (Not Result) then
               Begin
                 If (ForceStore) or (LastEdit) then
                   CalcInvTotals(LInv,ExLocal,Not ManVAT,BOn);

                 RSynch_PayFromTo(LInv,6);

                 Result:=(Round_Up(PRequired(BOn,LInv),2)=0);

                 If (Not Result) then
                 Begin
                   OutInvFooterTot;
                   OutInvTotals(5);
                 end;

               end;
               
             end;

      // MH 08/11/2010 v6.5 ABSEXCH-10108: Modified check so that GetNom isn't called if the Control GL Code is 0
      //17  :  Result:=(CtrlNom=0) or (GetNom(Self,Form_Int(CtrlNom,0),FoundLong,-1));
      17  : Begin
              Result:=(CtrlNom=0);
              If (Not Result) Then
              Begin
                Result := GetNom(Self,Form_Int(CtrlNom,0),FoundLong,-1);
                // MH 08/11/2010 v6.5 ABSEXCH-10465: Modified validation to enfore a Control Code
                If Result Then
                  Result := (Nom.NomType = CtrlNHCode);
              End; // If (Not Result)
            End;


      18  :  Result:=(CXRate[BOn]<>0);

      {$IFDEF MC_On}

        19  :  Begin {* Should this number ever change, chenage the check at the end of
                        this routine, as this error should only really be a warning *}
                 Result:=(VATCRate[BOn]<>0);

                 If (Not Result) then
                 Begin
                   VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;
                   SetTriRec(Syss.VATCurr,UseORate,VATTriR);
                 end;
               end;

      {$ENDIF}

      {$IFDEF SOP}
        20  :  Begin
                 // PKR. 24/02/2016. ABSEXCH-17322. Intrastat for Full Stock Only
                 if (SystemSetup.Intrastat.isShowDeliveryTerms) and (FullStkSysOn) then
                 begin
                   Result:=(Not Syss.IntraStat) or (Not Cust.EECMember);

                   If (Not Result) then
                   begin
                     Result:=ValidDelTerms(DelTerms);
                     if not Result and cbDeliveryTerms.CanFocus then
                      cbDeliveryTerms.SetFocus;
                   end;
                 end
                 else
                  Result := True;
               end;


        21  :  Begin
                 // PKR. 24/02/2016. ABSEXCH-17322. Intrastat for Full Stock Only
                 Result:=(Not Syss.IntraStat) or (Not Cust.EECMember) or (not FullStkSysOn);

                 If (Not Result) then
                 begin
                   Result:=ValidNatTran(TransNat);
                    if not Result and cbNoTc.CanFocus then
                      cbNoTC.SetFocus;
                 end;

               end;

        22  :  Begin
                 // PKR. 24/02/2016. ABSEXCH-17322. Intrastat for Full Stock Only
                 if (SystemSetup.Intrastat.isShowModeOfTransport) and (FullStkSysOn) then
                 begin
                   Result:=(Not Syss.IntraStat) or (Not Cust.EECMember);

                   If (Not Result) then
                   begin
                     Result:=ValidModeTran(TransMode);
                     if not Result and cbModeOfTransport.CanFocus then
                      cbModeOfTransport.SetFocus;
                   end;
                 end
                 else
                  Result := True;
               end;

      {$ENDIF}

      23  :  Begin
              ShowMsg:=BOff;

              {$IFDEF JC}
                {$IFDEF PF_On}
                   If (JBCostOn) and (InvDocHed=PPI) then
                     Result:=Not Cert_Expired(CustCode,Today,BOn,BOn);
                {$ENDIF}
              {$ENDIF}

            end;

     24  :  Begin
              Result:=((Round_Up(ITotal(LInv)-LInv.InvVAT,2)>=Round_Up(LInv.TotalCost,2)) or (BoChkAllowed_In(InvDocHed In SalesSplit,309)) or (Not (InvDocHed In SalesSplit)));

              {$IFDEF SOP}
                If (Not Result) And Assigned(TTDHelper) Then
                Begin
                  // If caused by VBD then allow anyway
                  Result := TTDHelper.CheckVBDCosts(ExLocal.LInv);
                End; // If (Not Result) And Assigned(TTDHelper)
              {$ENDIF} // SOP
            End;
     25
         :   Begin
               ShowMsg:=BOff;

               {$IFDEF SY}
                 Result:=Check_UserAuthorisation(Self,LInv,AuthBy);

                 fRecordAuth:=(Result) and (AuthBy<>'');
               {$ELSE}
                 Result:=BOn
               {$ENDIF}

             end;
     26  :   If (fChkYourRef) and (Trim(YourRef)<>'') then
             Begin
               Result:=(Not Check4DupliYRef(LJVar(YourRef,DocYref1Len),FullCustCode(CustCode),InvF,InvYrRefK,ExLocal.LInv,'Reference ('+Trim(YourRef)+') for this account'));

               Result:=BOn; {Only a warning}

               ShowMsg:=BOff;

             end;
     27  :   Begin {* Opportunity for hook to validate the header as well *}
                 {$IFDEF CU}

                   Result:=ValidExitHook(2000,82,ExLocal);
                   ShowMsg:=BOff;

                 {$ENDIF}
              end;

     28   :  Begin
               {$IFDEF SOP}
                 // If set the Overide Location must be valid - read-only for edits so only need to validate when adding
                 If (Not ExLocal.LastEdit) And edtOverrideLocation.Visible And (Trim(thOverrideLocation) <> '') Then
                 Begin
                   Result := Global_GetMainRec(MLocF, Quick_MLKey(thOverrideLocation));
                 End; // If (Not ExLocal.LastEdit) And edtOverrideLocation.Visible And (Trim(thOverrideLocation) <> '')
               {$ENDIF}
             End;
    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test]+AfterMsg,mtWarning,[mbOk],0);

  If (Not Result) and (Test =19) then {* As warning force through *}
    Result:=BOn;


  Dispose(PossMsg);

end; {Func..}


procedure TSalesTBody.StoreInv(Fnum,
                               KeyPAth    :  Integer;
                               PickMode   :  Boolean);


Var
  COk  :  Boolean;
  TmpInv
       :  InvRec;
  KeyS :  Str255;

  MbRet:  Word;

  HMode,
  Mode :  Byte;

  OldDate
       :  LongDate;

  // MH 11/03/2013 v7.0.2 ABSEXCH-13758: Disable UI controls to prevent people messing with
  //                                     the window whilst the transaction is saving
  oDisableControls : TDisableControls;

  // MH 10/04/2013 b702.221 ABSEXCH-14194 : Fixed problem where non-fatal errors during the Save
  //                                        process were causing Status to be non-zero so the modified
  //                                        printing wasn't executing
  PrintTransaction : Boolean;

  //PR: 20/10/2011
  oAuditNote : TAuditNote;

  {$IFDEF SOP}
    // MH 22/07/2014 v7.X: Added Order Payment support
    iOrderPaymentsTransaction : IOrderPaymentsTransactionInfo;
  {$ENDIF}
Begin
  KeyS:='';

  Mode:=0; HMode:=232;

  BeingStored:=BOn;

  // MH 10/04/2013 b702.221 ABSEXCH-14194 : Fixed problem where non-fatal errors during the Save
  //                                        process were causing Status to be non-zero so the modified
  //                                        printing wasn't executing
  PrintTransaction := False;

  try
    Form2Inv;

    {$IFDEF SOP}
      if not ExLocal.LViewOnly then
        If (Not TTDHelper.ApplyDiscounts (Self, I1AccF, ExLocal.LInv)) Then
        {Do VBD Here};
    {$ENDIF}

    With ExLocal,LInv do
    Begin
      {$IFDEF CU} {* Call any pre store hooks here *}
        LNeedRefs:=(Not ForceStore) and (Not LastEdit); {If we enter hook with no folio assigned, let hook assign them}

        GenHooks(2000,1,ExLocal);

        If (LNeedRefs) then
          ForceStore:=(ForceStore or LSetRefs);

      {$ENDIF}


      COk:=CheckCompleted(LastEdit);


      If (COk) then
      Begin
        // MH 11/03/2013 v7.0.2 ABSEXCH-13758: Disable UI controls to prevent people messing with
        //                                     the window whilst the transaction is saving
        oDisableControls := TDisableControls.Create;
        oDisableControls.DisableActiveControls (Self);
        Try
          //PR: 20/10/2011
          oAuditNote := TAuditNote.Create(EntryRec^.Login, @F[PwrdF]);

          Cursor:=crHourGlass;

          OldDate:=DueDate;

          If (Not ForceStore) and (Not LastEdit) then {* We must set this here, as otherwise the calcinv totals will pick up and potentialy modify the lines of another transactions folionum...}
          Begin
            If (NomAuto) then
              SetNextDocNos(LInv,BOn)
            else
              SetNextAutoDocNos(LInv,BOn);

            ForceStore:=BOn;
          end;
          // MH 04/02/2016 2016-R1 ABSEXCH-16489: Cannot set 'Hold for Query' status in Before Store
          // Trans as it is already set on new transactions and automatically cleared when the transaction
          // is finally saved - setting is now cleared in SetNewFolio instead
//          else
//            If (Not LastEdit) and ((HoldFlg=HoldQ) or (HoldFlg=(HoldQ+HoldNotes))) then
//              HoldFlg:=(HoldFlg-HoldQ); {v5.61 Clear saftey hold as header about to be stored correctly}

           if not LViewOnly then
           begin
          {$IFDEF JC}
            If (CISOn) then
              Calc_CISTaxInv(LInv,BOn);
          {$ENDIF}

            CalcInvTotals(LInv,ExLocal,Not ManVAT,BOn);

          {$IFDEF SOP}
             If (UpDateDel) then
                DueDate:=OldDate;
          {$ENDIF}
          end; //if not LViewOnly

          // MH 15/01/2016 ABSEXCH-17065 2016-R1: Don't reset the Operator Name for LIVE transactions
          // as it breaks their approvals process
          If (Not WebExtEProcurementOn) Or (WebExtEProcurementOn And (ExtSource < 200)) Then
            OpName:=EntryRec^.LogIn;

          If not LViewOnly and (InvDocHed In DirectSet) then
          Begin

            Settled:=ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst;

            CurrSettled:=ITotal(LInv)*DocCnst[InvDocHed]*DocNotCnst;  {**** Full Currency Value Settled ****}

            CXRate[BOff]:=SyssCurr.Currencies[Currency].CRates[BOff];

            Addch:=ResetKey;

            If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) and
            (NomAuto)  then  {* Cash Accounting set VATdate to Current VATPeriod Non Auto Items only *}
            Begin

               // VATPostDate:=SyssVAT.VATRates.CurrPeriod;

               VATPostDate:=CalcVATDate(TransDate);  {v5.71. CA Allows jump to future period, set from period of self}

               UntilDate:=Today;

            end;

          end;

          if not LViewOnly then
          begin
            If (Not Inv.DiscTaken) and (BaseTotalOS(LInv)<>0) and (DiscSetAm<>0) and (Not Syss.NoHoldDisc) and (Not (InvDocHed In PSOPSet)) then
              Mode:=HoldSA
            else
              {$IFDEF EX601}
              If (GetHoldType(HoldFlg)=HoldA) and ((DiscSetAM=0.0) and (LastInv.DiscSetAM<>0.0)) then
                Mode:=HoldDel
              else
                Mode:=0;
              {$ELSE}
                If (GetHoldType(HoldFlg)=HoldA) then
                Mode:=HoldDel;
              {$ENDIF}

            SetHold(Mode,0,0,BOff,LInv);

            Set_DocAlcStat(LInv);  {* Set Allocation Status *}

            {$IFDEF STK}

              {$IFNDEF PF_On}

                If (LInv.InvDocHed In QuotesSet) then
                  BatchLink:=QUO_DelDate(InvDocHed,DueDate);

              {$ELSE}

                {.$IFNDEF JC}

                  If (InvDocHed In OrderSet) then
                    BatchLink:=QUO_DelDate(InvDocHed,DueDate);

                {.$ENDIF}

              {$ENDIF}

            {$ENDIF}

            CheckYRef(LInv);  {* To reset index on blank *}

            {$IFDEF NP}

              If (fRecordAuth) then {Add a note entry}
              Begin
                Add_Notes(NoteDCode,NoteCDCode,FullNomKey(LInv.FolioNum),Today,
                          LInv.OurRef+' was authorised for floor limit by '+Trim(AuthBy)+'. For '+FormatCurFloat(GenRealMask,ITotal(LInv),BOff,Currency),
                          NLineCount);

                SetHold(HMode,Fnum,Keypath,BOff,LInv);

                AuthAmnt:=ConvCurrITotal(LInv,BOff,BOn,BOn); {Record prev total in base for subsequent authorisation comparison}

              end;
            {$ENDIF}

            {* v4.32.002 Moved here from add mode so that any sbsequent edits are reflected correctly *}

            If (LastInv.Currency<>LInv.Currency) or (Not LastEdit) then
            Begin
              {* Preserve original Co. Rate *}

              OrigRates:=SyssCurr.Currencies[Currency].CRates;

              SetTriRec(Currency,UseORate,OrigTriR);
            end;

            //PR: If the transaction meets the right conditions then call function to check and process EC service lines
            if (LInv.InvDocHed in PurchSplit - [PPY, PBT]) and LCust.EECMember and (LInv.SSDProcess In [#0, #32]) and
              not VAT_CashAcc(SyssVAT.VATRates.VATScheme) then  //PR: 15/09/2009 Added check for Cash Accounting
                CheckForECServiceLines;
          end; //if not LViewOnly
          If (LastEdit) then
          Begin
            //PR: 14/11/2017 ABSEXCH-19451
            If (Not TransactionViewOnly) then
            Begin

              if not LViewOnly then
              begin
                If (InvDocHed In OrderSet) then
                  OnPickRun:=BOff;

                // MH 05/01/2015 v7.1 ABSEXCH-15831: Modified to reset Order Payments Flag if the account
                // has been changed to one with Order Payments disabled.
                // Note: Account cannot be changed if payments have been taken.
                If (LInv.thOrderPaymentElement <> opeNA) And (Not LCust.acAllowOrderPayments) Then
                  LInv.thOrderPaymentElement := opeNA;
              end;

              Status:=LSecure_InvPut(Fnum,KeyPAth,0);

              //PR: 20/10/2011 Add audit history note //ABSEXCH-11745 v6.9
              if (Status = 0) and Assigned(oAuditNote) then
                oAuditNote.AddNote(anTransaction, LInv.FolioNum, anEdit);


            end; {Don't store if view only}
          end
          else
          Begin {* Add new record *}
            If (VATCRate[BOn]=0.0) then
            Begin
              VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;
              SetTriRec(Syss.VATCurr,UseORate,VATTriR);
            end;


            If (Not ForceStore) then
            Begin
              If (NomAuto) then
                SetNextDocNos(LInv,BOn)
              else
                SetNextAutoDocNos(LInv,BOn);
            end;

            {$IFDEF SOP}
            // CJS 2014-08-04 - v7.X Order Payments - T031 - set Order Payments status on store
            If Syss.ssEnableOrderPayments And LCust.acAllowOrderPayments And (LInv.InvDocHed = SOR) Then
              LInv.thOrderPaymentElement := opeOrder
            Else
            {$ENDIF}
              LInv.thOrderPaymentElement := opeNA;

            If (Not InvStored) and (Not LForcedAdd) then
            begin
              { CJS - 2013-10-25 - MRD2.6.05 - Transaction Originator }
              TransactionOriginator.SetOriginator(LInv);

              Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
            end
            else
            begin
              Status:=LSecure_InvPut(Fnum,KeyPAth,0);
            end;

           //PR: 20/10/2011 Add audit history note //ABSEXCH-11745 v6.9; 04/11/2011 Add a new transaction could be Add_Rec or Put_Rec
           if (Status = 0) and Assigned(oAuditNote) then
              oAuditNote.AddNote(anTransaction, LInv.FolioNum, anCreate);

            CanDelete:=BOn;
          end;

          If (Not LViewOnly) then
            Report_BError(Fnum,Status);

          If (StatusOk) and (Not LViewOnly) then
          Begin
            AssignToGlobal(InvF);

            If (Not LastEdit) then {* Get record, as if daybook empty, getpos was failing *}
              LGetMainRecPosKey(Fnum,InvOurRefK,LInv.OurRef);

            LGetRecAddr(Fnum);  {* Refresh record address *}

            If (LastEdit) or (LForcedAdd) then
              Delete_DocEditNow(FolioNum);



            If (StatusOk) then
            Begin
              If (InvDocHed In QuotesSet) and (RecordPage<>1) and (NomAuto) then {* Change tab first *}
              Begin
                Send_UpdateList(LastEdit,85);
                AssignToGlobal(InvF);

              end;

              // MH 11/03/2013 v7.0.2 ABSEXCH-13758: Move printing message until after transaction store
              //                                     is completed
              //Send_UpdateList(LastEdit,RecordPage);

              // MH 10/04/2013 b702.221 ABSEXCH-14194 : Fixed problem where non-fatal errors during the Save
              //                                        process were causing Status to be non-zero so the modified
              //                                        printing wasn't executing
              PrintTransaction := True;

            end;
            If (Not (InvDocHed In QuotesSet+PSOPSet)) and (Not Syss.UpBalOnPost) and (NomAuto) then
              UpdateCustBal(LastInv,LInv);


            {If (LastEdit) then
              Check_DocChanges(LastInv,LInv);  {* Update all lines with any changes *}
            {* Disabled v4.31 as calc inv total already resets all these}


            {$IFDEF STK}  {* Generate Stock deduct lines from list based *}

              {$IFDEF SOP}

                If (UpDateDel) or ((HoldFlg and HoldC) =HoldC) then
                  UpDate_OrdDel(LInv,UpDateDel,((HoldFlg and HoldC)=HoldC),Self);

              {$ENDIF}


              If (NomAuto) and (InvDocHed In OrderSet) then {* Update customer order value *}
                UpdateCustOrdBal(LastInv, LInv{$IFDEF SOP}, PreviousOS{$ENDIF});

              If (Not PickMode) then  {* Do not re-calc BOM when in pick mode *}
              Begin
                Calc_StockDeduct(FolioNum,(Not (InvDocHed In OrderSet)),0,LInv,Syss.EditSinSer {and (Not (LInv.InvDocHed In OrderSet))});

                If (LInv.InvDocHed=POR) and (LInv.TotOrdOS<>LastInv.TotOrdOS) and (Copy(LInv.YourRef,1,3)=DocCodes[SOR]) then
                Begin
                  Update_MatchPay(LInv.OurRef,Trim(LInv.YOurRef),
                      LastInv.TotOrdOS,LastInv.TotOrdOS,BOn,DocMatchTyp[BOn]);

                  Update_MatchPay(LInv.OurRef,Trim(LInv.YOurRef),
                      LInv.TotOrdOS,LInv.TotOrdOS,BOff,DocMatchTyp[BOn]);


                end;

              end
              {$IFDEF SOP}
              else
                If (Syss.EditSinSer) and (Not (InvDoched In QuotesSet)) then
                Begin
                  Set_HiddenSer(LInv,18);

                  RetroSNBOM(LInv,IdetailF,IdFolioK,InvF,InvFolioK,18);
                end;
              {ELSE}
                ;
              {$ENDIF}


            {$ENDIF}


          end;

          If (LastEdit) or (LForcedAdd) then
          Begin
            Delete_DocEditNow(FolioNum);

            ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);
          end;


          SetInvStore(BOff,BOff);

          Cursor:=CrDefault;

          LastValueObj.UpdateAllLastValues(Self);

          InvStored:=BOn;


          SendToObjectCC(LInv.CustCode,1);

          // MH 11/03/2013 v7.0.2 ABSEXCH-13758: Move printing message until after transaction store
          //                                     is completed

          // MH 10/04/2013 b702.221 ABSEXCH-14194 : Fixed problem where non-fatal errors during the Save
          //                                        process were causing Status to be non-zero so the modified
          //                                        printing wasn't executing
          //If StatusOk And (Not LViewOnly) Then
          If PrintTransaction Then
          Begin
            // Refresh the global Inv record as that is what the daybook uses for printing
            // PS 06/04/2016 2016-R2 ABSEXCH-16205: If Filter Account code is applied in the Print Document it is printing proper Customer Details
            // PS 10/05/2016 2016-R2 ABSEXCH-16205: Added If condition to print only on new document
            // PS 19/05/2016 2016-R2 ABSEXCH-17476: Added Check_AutoPrint Validation to print document type mention in AutoPrnSet Const.
            // MH 05/07/2016 2016-R2 ABSEXCH-17638: B2B POR's not printing
            If ((not ExLocal.LastEdit) Or FBackToBackTransaction) and (Check_AutoPrint(ExLocal.LInv))  then {* Auto print *}
            Begin
              With LInv do
              begin
                Control_DefProcess(DEFDEFMode[InvDocHed],
                           IdetailF,IdFolioK,
                           FullNomKey(FolioNum),ExLocal,BOn);
              end;

              // MH 05/07/2016 2016-R2 ABSEXCH-17638: Only print it once
              If FBackToBackTransaction Then
                FBackToBackTransaction := False;
            end;
            //VA 18/05/2018 ABSEXCH-19540 S Walsh & Sons Ltd & ABSEXCH-19871 Whal UK Ltd - Sales Credit Note, Multiple Print Prompt
            //AP 03/07/2018 ABSEXCH-20888:All the transactions added in Purchase Day-book does not show up without refreshing the window.
            if  (not (owner is TFInvDisplay)) then
              Send_UpdateList(LastEdit,RecordPage);
          End; // If PrintTransaction

          {$IFDEF CU} {* Call any post store hooks here *}
            GenHooks(2000,170,ExLocal);
          {$ENDIF}

          {$IFDEF SOP}
            // MH 22/07/2014 v7X Order Payments: Display the Order Payment Payment window if the 'Create a receipt for this Order'
            // checkbox is ticked, this requires a record lock on the SOR so it needs to be done as late as possible in the Save process
            If Syss.ssEnableOrderPayments And LCust.acAllowOrderPayments And (chkCreateOrderPayment.Checked Or FOrderPaymentsAutoPayment) Then
            Begin
              // Calculate the SOR details and lock it to protect the payment operation
              iOrderPaymentsTransaction := OPTransactionInfo (LInv, LCust);
              // Check there is something to Pay and that sufficient funds are available
              If iOrderPaymentsTransaction.CanTakePayment Then
              Begin
                // Get a record lock
                If iOrderPaymentsTransaction.LockTransaction Then
                Begin
                  // Display the Create Receipt Window and bring the transaction back to the front
                  OPDisplayPaymentWindow (iOrderPaymentsTransaction, Self);
                  Self.BringToFront;
                End // If iOrderPaymentsTransaction.LockTransaction
                Else
                Begin
                  ShowMessage ('Unable to take an Order Payment at this time, as someone else is editing this Order.');
                  iOrderPaymentsTransaction := NIL;
                End; // Else
              End // If iOrderPaymentsTransaction.CanTakePayment
              Else
                iOrderPaymentsTransaction := NIL;
            End; // If Syss.ssEnableOrderPayments And LCust.acAllowOrderPayments And (chkCreateOrderPayment.Checked Or FOrderPaymentsAutoPayment)
          {$ENDIF SOP}

          //PR: 20/10/2011
          oAuditNote.Free;
        Finally
          // MH 11/03/2013 v7.0.2 ABSEXCH-13758: Restore UI controls
          oDisableControls.ReenableDisabledControls;
        End; // Try..Finally

        // MH 11/03/2013 v7.0.2 ABSEXCH-13966: Modified closing mechanism as explicitely closing the
        // form whilst code is running within it seems a bit dodgy - may explain Access Violations
        //Close;
        PostMessage (Self.Handle, WM_CLOSE, 0, 0);
        ShowWindow(Self.Handle, SW_HIDE);

        Exit;
      end // If (COk)
      else
      Begin

        {ChangePage(0);}

        SetFieldFocus;

      end;
    end; {With..}
  finally
    BeingStored:=BOff;
  end; {try..}
end;

Function TSalesTBody.SetViewOnly(SL,VO  :  Boolean)  :  Boolean;

Var
  VOMsg  : Byte;

Begin


{$B-}

  Result:=(SL and ((VO) or View_Status(ExLocal.LInv,BOff,VOMsg)));

{$B+}

  If Result then
    Result:=(Not ((VOMsg=7) and fInBatchEdit));

  If (VO) then {* Force View only msg *}
    VOMsg:=9;

  If (Result) then
  begin
    I1StatLab.Caption := GetIntMsg(VOMsg+50);
    Shape1.Shape := stRoundRect;
    Shape1.Left := 5; //I1StatLab.Left - 1;
    Shape1.Top := 5; //I1StatLab.Top - 3;
    Shape1.Width := I1btnPanel.Width - 10; //I1StatLab.Width + 4;
    Shape1.Height := I1StatLab.Height + 4;
    Shape1.Visible := True;
    Shape1.Brush.Color := RGB(0, 159, 223);
    I1StatLab.Color := Shape1.Brush.Color;
  end
  else
    I1StatLab.Caption:='';

  OkI1Btn.Visible:=Not Result or FAllowPostedEdit;
  CanI1Btn.Visible:=OkI1Btn.Visible;



  {I1BSBox.Visible:=Not Result;}
end;

procedure TSalesTBody.EditAccount(Edit,
                                  AutoOn,
                                  ViewOnly,
                                  PickMode   :  Boolean);


begin
  With ExLocal do
  Begin
    {$IFDEF SOP}
      If ViewOnly Then
        TTDHelper.TransactionMode := tmView
      Else If (Not Edit) Then
        TTDHelper.TransactionMode := tmAdd
      Else
        TTDHelper.TransactionMode := tmEdit;
    {$ENDIF}

    LastEdit:=Edit;

    LPickMode:=PickMode;

    ShowLink(Edit,ViewOnly);

    ProcessInv(InvF,CurrKeyPath^[InvF],LastEdit,AutoOn);

    //PR: 07/10/2013 MRD 1.1.17 Set WasConsumer appropriately for a/c type
    WasConsumer := IsConsumer(LCust);

  end;
end;



procedure TSalesTBody.I1AddrFClick(Sender: TObject);
begin
  With I1AccF do
   //PR: 02/10/2013 MRD 1.1.17 If consumer then we need to check the text against the long a/c code
  If (not IsConsumer(ExLocal.LCust) and CheckKey(FullCustCode(Text),ExLocal.LCust.CustCode,CustKeyLen,BOff)) or
     (IsConsumer(ExLocal.LCust) and CheckKey(FullLongAcCodeKey(Text),ExLocal.LCust.acLongACCode,CustKeyLen,BOff)) then
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

procedure TSalesTBody.I5MVATFClick(Sender: TObject);
begin
  // MH 03/11/2010 v6.5 ABSEXCH-2882: Added warning that the user is responsible for maintaining VAT Totals under Manual VAT
  If I5MVATF.Checked And (Not ExLocal.LInv.ManVAT) Then
  Begin
    MessageDlg('Please note that when Manual VAT is ticked you are responsible for the maintenance of the VAT totals.  ' + #13#10#13#10 +
               'Exchequer will not recalculate the VAT totals for changes you make to the transaction or to handle partial deliveries.',
               mtWarning, [mbOK, mbHelp], 40162);
  End; // If I5MVATF.Checked And (Not ExLocal.LInv.ManVAT)

  ExLocal.LInv.ManVAT:=I5MVATF.Checked;

  If (Not I5MVATF.Checked) then {* Force a re calc *}
    With ExLocal do
    Begin
      If (ForceStore) or (LastEdit) then
        CalcInvTotals(LInv,ExLocal,Not LInv.ManVAT,BOn);

      OutInvFooterTot;
    end;

end;

procedure TSalesTBody.I5CISManCbClick(Sender: TObject);
begin
  If (CISOn) then
  Begin
    ExLocal.LInv.CISManualTax:=I5CISMancb.Checked;

    If (Not I5CISMancb.Checked) then
      ReFreshFooter;
  end;

end;



procedure TSalesTBody.OkI1BtnClick(Sender: TObject);
Var
  TmpBo  :  Boolean;
  KeyS   :  Str255;
  bContinue : Boolean;
  Btn1State: Boolean;
  Btn5State: Boolean;
  CursorState: TCursor;
begin
  If (Sender is TButton) and (Not BeingStored) and (Not fFrmClosing) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      // Move focus to OK button to force OnExit validation/formatting to kick in
      If (ActiveControl <> OkI1Btn) And OkI1Btn.CanFocus Then
        OkI1Btn.SetFocus
      Else If (ActiveControl <> OkI5Btn) And OkI5Btn.CanFocus Then
        OkI5Btn.SetFocus;

      // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
      If (ActiveControl = OkI1Btn) Or (ActiveControl = OkI5Btn) Then
      begin
        { CJS ABSEXCH-14210 - Access violation when storing Transaction }
        Btn1State := OkI1Btn.Enabled;
        Btn5State := OkI5Btn.Enabled;
        CursorState := Cursor;
        OkI1Btn.Enabled := False;
        OkI5Btn.Enabled := False;
        Cursor := crHourGlass;
        try
          If (Not FirstStore) then
          Begin  {* If direct and already balancing *}
            If (Not DirectStore) or (Round_Up(PRequired(BOn,ExLocal.LInv),2)=0) then
              StoreInv(InvF,CurrKeyPath^[InvF],LPickMode)
            else  {* Show Last page *}
            Begin
              DirectStore:=BOff;
              ChangePage(5);
            end;
            {$IFDEF SOP}
              // MH 19/09/2014 ABSEXCH-15636: Explicitely checked for EDIT mode
              If ExLocal.LastEdit And Syss.ssEnableOrderPayments And ExLocal.LCust.acAllowOrderPayments And (ExLocal.LInv.thOrderPaymentElement In [opeOrder, opeDeliveryNote, opeInvoice]) Then
              Begin
                // MH 23/09/2014 Order Payments: Extended Customisation
                // Clear down any cached image of the transaction in the transaction tracker at the
                // end of the edit to prevent any future re-visit to the transaction seeing old
                // and incorrect details
                ResetOrderPaymentsCustomisationTransactionTracker;

                HandleRefunds;
              End; // If ExLocal.LastEdit And Syss.ssEnableOrderPayments And ExLocal.LCust.acAllowOrderPayments And (ExLocal.LInv.thOrderPaymentElement In [opeOrder, opeDeliveryNote, opeInvoice])
            {$ENDIF}
          end
          else
          Begin
            With ExLocal,LInv do
            If (ILineCount=1) and (ITotal(LInv)=0.0) then
            Begin
              TmpBo:=(CustomDlg(Application.MainForm,'Please Confirm...','Store Empty Transaction',
                                 'You are about to store this transaction but no transaction lines have been added to it.'+#13+#13+
                                 'A zero value transaction will have no effect on account balances or the General Ledger.'+#13+#13+
                                 'Do you still wish to store this transaction now?',
                                 mtConfirmation,
                                 [mbYes,mbNo])=mrOk);


            end
            else
              TmpBo:=BOn;

            If (TmpBO) then
            Begin
              FirstStore:=BOff; {*Display final page *}
              ReCalcTot:=BOn; {* Work out new totals *}

              {$IFDEF SOP}
                If (Not TTDHelper.ApplyDiscounts (Self, I1AccF, ExLocal.LInv)) Then
                  {Do VBD Here};
              {$ENDIF}

              ChangePage(4);
            end;
          end;
        finally
          Cursor := CursorState;
          OkI5Btn.Enabled := Btn5State;
          OkI1Btn.Enabled := Btn1State;
        end;
      end;
    end
    else
      If (ModalResult=mrCancel) then
      Begin
        ClsI1Btn.Click;

        Exit;
      end;
  end; {With..}
end;


procedure TSalesTBody.I1DelBtnClick(Sender: TObject);

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
          //PR: 14/07/2017 ABSEXCH-19451 Allow posted trans to be edited 
          mrResult:=InitDelAddr(LViewOnly and not I1YrRefF.AllowPostedEdit,Color,Font);

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

procedure TSalesTBody.PopupMenu1Popup(Sender: TObject);
Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  Custom1.Caption:=CustTxBtn1.Caption;
  Custom2.Caption:=CustTxBtn2.Caption;
  // 17/01/2013 PKR ABSEXCH-13449
  // Custom buttons 3..6 now available
  Custom3.Caption:=CustTxBtn3.Caption;
  Custom4.Caption:=CustTxBtn4.Caption;
  Custom5.Caption:=CustTxBtn5.Caption;
  Custom6.Caption:=CustTxBtn6.Caption;

  With InvBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end; {With..}

  {$IFDEF SOP}
    mnuApplyTTD.Checked := TTDHelper.ApplyTTD;
  {$ENDIF}
end;


procedure TSalesTBody.I1SCodeLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

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

procedure TSalesTBody.I1SCodeLabMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);

begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO<>nil) then
    Begin
      MULCtrlO.VisiList.MoveLabel(X,Y);

      NeedCUpdate:=MULCtrlO.VisiList.MovingLab;
    end;
  end;

end;




procedure TSalesTBody.I1StkCodePanelMouseUp(Sender: TObject;
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
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);
  end;

end;


procedure TSalesTBody.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    N3.Tag:=99;

    PopUp(X,Y);
  end;


end;

procedure TSalesTBody.SetFieldProperties;

Var
  n  : Integer;


Begin
  I1BtmPanel.Color:=I1FPanel.Color;
  I2BtmPanel.Color:=I1FPanel.Color;
  I3BtmPanel.Color:=I1FPanel.Color;
  I4BtmPanel.Color:=I1FPanel.Color;
  I1BtnPanel.Color:=I1FPanel.Color;
  {SBSPanel64.Color:=I1FPanel.Color;}
  pnlTaxRates.Color:=I1FPanel.Color;

  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) and (Components[n]<>I1AccF) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(I1AccF.Font);
        Color:=I1AccF.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        {CheckColor:=I1AccF.Color;}
        Color:=I1FPanel.Color;
      end;

  end; {Loop..}

  I1AddrF.Color:=I1AccF.Color;
  I1AddrF.Font.Assign(I1AccF.Font);

end;


procedure TSalesTBody.SetFormProperties(SetList  :  Boolean);

Const
  PropTit     :  Array[BOff..BOn] of Str5 = ('Form','List');



Var
  TmpPanel    :  Array[1..3] of TPanel;

  n           :  Byte;

  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;

Begin
  if Assigned(FSettings) then
  begin
    if SetList then
    begin
      if FSettings.Edit(MULCtrlO, MULCtrlO) = mrOK then
      begin
        NeedCUpdate := True;
        FColorsChanged := True;
      end;
    end
    else
    begin
      if FSettings.Edit(Self, I1AccF) = mrOK then
      begin
        NeedCUpdate := True;
        FColorsChanged := True;
      end;
    end;
  end;
(*  ResetDefaults:=BOff;

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
      TmpPanel[1].Font:=I1AccF.Font;
      TmpPanel[1].Color:=I1AccF.Color;

      TmpPanel[2].Font:=I1FPanel.Font;
      TmpPanel[2].Color:=I1FPanel.Color;
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
                  1,2  :  MULCtrlO.ReColorCol(Font,Color,(n=2));

                  3    :  MULCtrlO.ReColorBar(Font,Color);
                end; {Case..}

            MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
          end
          else
          Begin
            I1FPanel.Font.Assign(TmpPanel[2].Font);
            I1FPanel.Color:=TmpPanel[2].Color;

            I1AccF.Font.Assign(TmpPanel[1].Font);
            I1AccF.Color:=TmpPanel[1].Color;

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
  *)
end;



procedure TSalesTBody.PropFlgClick(Sender: TObject);
begin
  Case Current_Page of

  {$IFDEF RT_On}
    5  :  If (PayCtrl<>nil) then
          begin
            PayCtrl.SetFormProperties;
            FColorsChanged := True;
            NeedCUpdate := True;
          end;
  {$ELSE}

    5  :  ;

  {$ENDIF}
    6  :  begin
            NotesCtrl.SetFormProperties;
            FColorsChanged := True;
            NeedCUpdate := True;
          end


   else  Begin
           SetFormProperties((N3.Tag=99));
           N3.Tag:=0;
         end;
  end; {Case..}
end;

procedure TSalesTBody.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;


procedure TSalesTBody.SetNewFolio;

Begin

  With ExLocal,LInv do
  If (Not ForceStore) and (Not LastEdit) and (InAddEdit) and (Not LViewOnly) then {* Document commits to invoice number here *}
  Begin
    ForceStore:=BOn;

    If (NomAuto) then
      SetNextDocNos(LInv,BOn)
    else
      SetNextAutoDocNos(LInv,BOn);

    I1OurRefF.Text:=Pr_OurRef(LInv);

    HoldFlg:=HoldQ; {v5.60 auto set header on hold and clear when ok pressed so its not part of posting routine if it crashed
                     header is never stored correctly }

    { CJS - 2013-10-25 - MRD2.6.05 - Transaction Originator }
    TransactionOriginator.SetOriginator(LInv);
    I1OpoF.Hint := GetOriginatorHint(LInv);

    {* Force add of header now *}
    If (LSecure_Add(InvF,CurrKeyPath^[InvF],0)) then
      Add_DocEditNow(LInv.FolioNum);

    // MH 04/02/2016 2016-R1 ABSEXCH-16489: Cannot set 'Hold for Query' status in Before Store
    // Trans as it is already set on new transactions and automatically cleared when the transaction
    // is finally saved - If we clear the setting now then that avoids the problem
    ExLocal.LInv.HoldFlg := ExLocal.LInv.HoldFlg - HoldQ;

    {* Set new list search *}
    RefreshList(BOff,BOff);
  end;
end;


procedure TSalesTBody.AddI1BtnClick(Sender: TObject);

Var
  Mode  :  Byte;


begin
  Mode:=0;


  Case Current_Page of

    5  : {$IFDEF Rt_On}
           If ((Sender Is TButton) or (Sender Is TMenuItem)) then

           Begin

             If (Not ExLocal.LastEdit) then
               SetNewFolio;

             If (PayCtrl<>nil) then
               With ExLocal,PayCtrl do
                 If  ((MULCtrlO.ValidLine) or ((Sender=AddI1Btn) or (Sender=Add1))) then
                 Begin
                 {* Reset folio, in case it changes *}

                 If (LInv.FolioNum <> GetFolio) then
                 Begin
                   RefreshList(LInv.FolioNum);
                 end;

                 InvBtnList.SetEnabBtn(BOff);

                 //PR: 22/12/2017 ABSEXCH-19451 Allow edit posted transaction
                 if FAllowPostedEdit then
                   PayCtrl.EnableEditPostedFields;


                 PayCtrl.AddEditPay(((Sender=EditI1Btn) or (Sender=Edit1)),LViewOnly,0,0,LInv);
               end;

           end;
         {$ELSE}
           ;
         {$ENDIF}

    6  : {$IFDEF NP}
           Begin

             If (Not ExLocal.LastEdit) then
               SetNewFolio;

             If (NotesCtrl<>nil) then
             With ExLocal,NotesCtrl do
             Begin
               {* Reset folio, in case it changes *}

               If (FullNomKey(LInv.FolioNum) <> GetFolio) then
               Begin
                 RefreshList(FullNomkey(LInv.FolioNum),GetNType);
               end;

               NotesCtrl.AddEditNote((Sender=EditI1Btn),(Sender=InsI1Btn));
             end;

           end;
         {$ELSE}
           ;
         {$ENDIF}

    else   If ((Sender Is TButton) or (Sender Is TMenuItem))
              and ((MULCtrlO.ValidLine) or ((Sender=AddI1Btn) or (Sender=Add1))) then
           Begin
            if ValidateOverrideLocation(True) then
            begin
               With MULCtrlO do
                RefreshLine(MUListBoxes[0].Row,BOff);

               If (Sender=AddI1Btn) or (Sender=EditI1Btn) or (Sender=Edit1) or (Sender=Add1) or (Sender=InsI1Btn) or (Sender=Insert1) then
                 Mode:=1+(1*(Ord(Sender=EditI1Btn)+Ord(Sender=Edit1))) + (2*(Ord(Sender=InsI1Btn)+Ord(Sender=Insert1)));

               {* Transfer to record, so the line is upto date *}

               Form2Inv;

               SetNewFolio;

               // MH 12/10/10: Disable the Override Location as soon as they add a line to prevent them
               // going back and changing it to something else
               If edtOverrideLocation.Visible And edtOverrideLocation.Enabled Then
                 edtOverrideLocation.Enabled := False;

               Display_Id(Mode);
             end;
           end;

  end; {Case..}


end;



procedure TSalesTBody.DelI1BtnClick(Sender: TObject);

Const
  Fnum  =  IdetailF;

Var
  mbRet  :  Word;

  KeyS   :  Str255;

  UseFolio
         :  LongInt;

  FoundCode
         :  Str20;


begin

  Case Current_Page of

    5  :  {$IFDEF Rt_On}
            If (PayCtrl<>nil) then
              PayCtrl.DeletePayLine(ExLocal.LInv);

          {$ELSE}
             ;
          {$ENDIF}

    6  :  {$IFDEF NP}
            If (NotesCtrl<>nil) then
              NotesCtrl.Delete1Click(Sender);

          {$ELSE}
             ;
          {$ENDIF}

    else   If (MULCtrlO.ValidLine) and (MULCtrlO.Ok2Del) then
           Begin
             {$IFDEF CU}
               ExLocal.AssignFromGlobal(IdetailF);

               If (ValidExitHook(4000,80,ExLocal)) then
             {$ENDIF}
             Begin
               mbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Line',
                                 mtConfirmation,[mbYes,mbNo],0);


               If (mbRet=mrYes) then
               With ExLocal,MULCtrlO do
               Begin
                 Try
                   {$IFDEF CU}
                     If (ValidExitHook(4000,81,ExLocal)) then;
                   {$ENDIF}


                 finally

                   Self.Enabled:=BOff;

                   RefreshLine(MUListBoxes[0].Row,BOff);

                   AssignFromGlobal(Fnum);

                   LGetRecAddr(Fnum);

                   LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}


                   Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

                   Report_BError(Fnum,Status);

                   Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,GlobLocked);

                   If (Ok) and (GlobLocked) then
                   Begin

                     With LId do
                     Begin
          
                       {$IFDEF STK}

                        Deduct_AdjStk(LId,LInv,BOff);

                         // CJS 2013-02-27 v7.0.2 ABSEXCH-13376: Added this section as the order was left in history
                         // if the stock code was removed prior to deleting the line
                         {$IFDEF SOP}
                           // Delete any assoc lines
                           If (SOPLink <> 0) Then
                           Begin
                             Update_SOPFLink(LId,BOn,BOn,BOff,IDetailF,IdLinkK,KeyPath);
                           End; // If (SOPLink <> 0)
                         {$ENDIF}

                         If (Not EmptyKey(StockCode,StkKeyLen)) then {* Delete any assoc lines *}
                         Begin

                           {$IFDEF SOP}
                             // CJS 2013-02-27 v7.0.2 ABSEXCH-13376: Moved into check above
                             //Update_SOPFLink(LId,BOn,BOn,BOff,IDetailF,IdLinkK,KeyPath);
                           {$ENDIF}

                           If (Stock.StockCode<>StockCode) then
                             GetStock(Self,StockCode,Foundcode,-1);

                           UseFolio:=Stock.StockFolio;
                         end
                         else
                           UseFolio:=FolioRef;


                         Delete_Kit(UseFolio,0,LInv);



                         {$IFDEF SOP}

                           Control_SNos(Id,LInv,Stock,3,Self);

                           If (CommitAct) then
                             Delete_LiveCommit(LId,-1);

                         {$ENDIF}

                         {$IFDEF PF_On}

                           Stock_AddCustAnal(LId,BOff,1);

                         {$ENDIF}

                       {$ELSE}
                           Delete_Kit(FolioRef,0,LInv);

                       {$ENDIF}


                       {$IFDEF PF_On}

                         If (Not EmptyKey(JobCode,JobKeyLen)) then
                           Delete_JobAct(Id);

                       {$ENDIF}


                     end; {With..}

                     LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

                     Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

                     Status:=Delete_Rec(F[Fnum],Fnum,Keypath);

                     Report_BError(Fnum,Status);

                     UpdateRecBal(LId,LInv,BOn,BOn,0);

                     ForceStore:=BOn;

                   end; {If locked..}

                   Self.Enabled:=BOn;
                   Self.Show;


                   OutInvTotals(Current_Page);

                   PageUpDn(0,BOn);

                   If (PageKeys^[0]=0) then {* Update screen as we have lost them all!*}
                     InitPage
                   else
                     ValidLine;
                 end; {finally}
               end; {If delete..}
             end; {If Custom allows}
           end;
  end; {Case..}

end;


procedure TSalesTBody.SwiI1BtnClick(Sender: TObject);
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

        ListPoint := SwiI1Btn.ClientToScreen(ListPoint);

        mnuSwitchNotes.Popup(ListPoint.X, ListPoint.Y);
      end;

    end;
  {$ENDIF}
end;

procedure TSalesTBody.APickI1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  {$IFDEF SOP}
     GetCursorPos(ListPoint);
    With ListPoint do
    Begin
      X:=X-50;
      Y:=Y-15;
    end;

    PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);

  {$ENDIF}
end;


procedure TSalesTBody.AP1Click(Sender: TObject);
  //PR: 03/08/2012 ABSEXCH-12746 Function to stop picking if customer is on hold
  {$IFDEF SOP}
  function StopPick : Boolean;
  var
    CreditHold : Boolean;
    WTrigger : Boolean;
    NeedToCheck : Boolean;
    PlusTotal : Double;
    MinusTotal : Double;
  begin
    //PR: 23/01/2012 ABSEXCH-13916 Allow stop picking to be overridden if transaction is authorised.
    NeedToCheck := (TMenuItem(Sender).Tag = 1) and (ExLocal.LInv.InvDocHed = SOR) and (ExLocal.LInv.HoldFlg and 7 <> 3);
    if NeedToCheck then
    begin
      CreditHold := False;
      Result := AccountOnHold(ExLocal.LCust);
      if not Result then
      begin
        //PR: 08/02/2013 ABSEXCH-13987 Added check for Use Credit Status flag - don't stop picking unless that is set.
        CreditHold := Check_AccForCredit(ExLocal.LCust,ConvCurrOrderTotal(ExLocal.LInv, UseCoDayRate, True),
                                       OldOrderConTot, BOn, BOn, WTrigger, Self) or (WTrigger and Syss.UseCreditChk);
        Result := CreditHold;
      end;

      if Result then
        DisplayCantPickWarning(CreditHold);
    end
    else
      Result := False;
  end;
  {$ENDIF}
begin
  {$IFDEF SOP}
    //PR: 03/08/2012 ABSEXCH-12746 Add StopPick check
    if not StopPick then
    begin
      If (Control_AutoPickWOff(TMenuItem(Sender).Tag,ExLocal.LInv,Self)) then
      Begin
        ForceStore:=BOn;
        MULCtrlO.PageUpDn(0,BOn);
        MULCtrlO.SetListFocus;
      end;
    end;
  {$ENDIF}
end;


function TSalesTBody.I1PrYrFShowPeriod(Sender: TObject;
  const EPr: Byte): string;
begin
  Result:=PPr_Pr(EPr);
end;

procedure TSalesTBody.MatI1BtnClick(Sender: TObject);
begin
  If (MULCtrlO<>nil) then
  With MULCtrlO do
  If (ValidLine) then
  Begin
    RefreshLine(MUListBoxes[0].Row,BOff);

    If (Sender=MatI1Btn) or (Sender=Match1) then
      Display_PayIn(BOn)
    else
      Display_BackOrd(BOn);
  end;
end;


{$IFDEF STK}


  procedure TSalesTBody.FindI1BtnClick(Sender: TObject);


  Var
    InpOk,
    FoundOk  :  Boolean;

    FoundCode:  Str20;
    FoundLong
             :  LongInt;

    SCode    :  String;

    KeyS     :  Str255;


  Begin

    SCode:='';
    FoundOk := false;
    Repeat

      InpOk:=InputQuery('Find Stock Record','Please enter the stock code you wish to find',SCode);

      If (InpOk) then
        FoundOk:=GetStock(Self,SCode,FoundCode,0);

    Until (FoundOk) or (Not InpOk);

    If (FoundOk) and (MULCtrlO<>nil) then
    With MULCtrlO do
    Begin
      GetSelRec(Boff);
      Find_OnList(7,FoundCode);
    end;


  end;

{$ELSE}

  procedure TSalesTBody.FindI1BtnClick(Sender: TObject);

  Var
    SCode  :  String;
    
  Begin
    SCode:='';

  end;

{$ENDIF}




procedure TSalesTBody.StatI1BtnClick(Sender: TObject);
begin
  {$IFDEF RT_On}
    PayCtrl.CtrlView;
  {$ENDIF}
end;

procedure TSalesTBody.WORI1BtnClick(Sender: TObject);

Var
  WORef  :  Str10;
  mbRet  :  Word;

begin
  {$IFDEF WOP}
    If (MULCtrlO<>nil) then
    With MULCtrlO do
    If (ValidLine) then
    With ExLocal,Id do
    Begin
      If (Stock.StockCode<>StockCode) then
        If (Not Global_GetMainRec(StockF,StockCode)) then
          ResetRec(StockF);

      If (Stock.StockType=StkBillCode) then
      Begin
        {$IFDEF SOP}
          If (CheckExsiting_WOR(LInv,Id,WORef)) then
          Begin
            mbRet:=CustomDlg(Application.MainForm,'Please note','Works Order Exists',
                                    'Works Order '+WORef+' already exists for this line'+#13+#13+
                                    'Please confirm you want to create another Works Order for this line.',mtConfirmation,[mbOk,mbCancel]);
          end
          else
            mbRet:=mrOk;

          If (mbRet=mrOk) then
        {$ENDIF}

          Run_WORWizard(LInv,Id,1,Self.Parent);

        ForceStore:=BOn;
      end
      else
        ShowMessage('You can only generate a works order for a bill of material');
    end;

  {$ENDIF}
end;

procedure TSalesTBody.RetI1BtnClick(Sender: TObject);

Var
  RETRef  :  Str10;
  mbRet   :  Word;

begin
  {$IFDEF RET}
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

  {$ENDIF}

end;



procedure TSalesTBody.SBSAccelLabel1Accel(Sender: TObject; AccChar: Char);
begin
  If (I1FPanel.Visible) and (I1DelBtn.Enabled) and (I1DelBtn.Visible) then
    I1DelBtn.Click;
end;

procedure TSalesTBody.LnkI1BtnClick(Sender: TObject);
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
      LetterForm.LoadLettersFor (FullNomKey(ExLocal.LInv.FolioNum),
                                 ExLocal.LInv.OurRef,
                                 Copy(ExLocal.LInv.OurRef,1,3)+Copy(ExLocal.LInv.OurRef,5,5),
                                 LetterDocCode,
                                 @ExLocal.LCust, Nil, @ExLocal.LInv, Nil, Nil);
    Except
     LetterActive := BOff;
     LetterForm.Free;
    End;
  {$ENDIF}
end;

procedure TSalesTBody.CustTxBtn1Click(Sender: TObject);
var
  // 24/01/2013 PKR ABSEXCH-13449
  customButtonNumber : integer;
begin
  {$IFDEF CU}
    If (Assigned(MULCtrlO)) then
    With MULCtrlO,ExLocal do
    Begin
      Form2Inv;
      Begin
        If (ValidLine) then
          LId:=Id
        else
          LResetRec(IDetailF);

        // 24/01/2013 PKR ABSEXCH-13449
        // Increase the availability of custom buttons in the customisation toolkit.
        
        // The button or menu item Tag property is set to the button number.
        customButtonNumber := -1;
        if Sender is TSBSButton then
          customButtonNumber := (Sender as TSBSButton).Tag;
        if Sender is TMenuItem then
          customButtonNumber := (Sender as TMenuItem).Tag;

        // Get the Event ID
        if custBtnHandler.CustomButtonClick(formPurpose,
                                            0,
                                            recordState,
                                            customButtonNumber,
                                            ExLocal) then

//        If ExecuteCustBtn(2000,((31+(10*Ord(DocHed In PurchSplit))+(100*Ord(Not InAddEdit)))*Ord((Sender=CustTxBtn1) or (Sender=Custom1)))+
//                      ((32+(10*Ord(DocHed In PurchSplit))+(100*Ord(Not InAddEdit)))*Ord((Sender=CustTxBtn2) or (Sender=Custom2))), ExLocal) then
        Begin
          THUD1F.Text:=LInv.DocUser1;
          THUD2F.Text:=LInv.DocUser2;
          THUD3F.Text:=LInv.DocUser3;
          THUD4F.Text:=LInv.DocUser4;

          edtUdf5.Text  := LInv.DocUser5;
          edtUdf6.Text  := LInv.DocUser6;
          edtUdf7.Text  := LInv.DocUser7;
          edtUdf8.Text  := LInv.DocUser8;
          edtUdf9.Text  := LInv.DocUser9;
          edtUdf10.Text := LInv.DocUser10;
          // PKR. 24/03/2016. ABSEXCH-17383. eRCT support.
          edtUdf11.Text := LInv.thUserField11;
          edtUdf12.Text := LInv.thUserField12;
        end;

      end;
    end; {With..}
  {$ENDIF}
end;

// MHYR 25/10/07
procedure TSalesTBody.I1YrRefFChange(Sender: TObject);
begin
  I1YrRefF.Hint := I1YrRefF.Text;
end;

// MHYR 25/10/07
procedure TSalesTBody.TransExtForm1Resize(Sender: TObject);
var
  IsExpanded: Boolean;
  ShowWkMonth: Boolean;
begin
  {
    If the drop-down form is expanded, and we don't need to leave room for
    the Week/Month field, then increase the size of the YourRef field.
  }
  IsExpanded := (TransExtForm1.Height = TransExtForm1.ExpandedHeight) and
                (TransExtForm1.Width = TransExtForm1.ExpandedWidth);
  ShowWkMonth := (DocHed = PIN) or (WebExtEProcurementOn and (DocHed = POR));

  If IsExpanded and not ShowWkMonth Then
    I1YrRefF.Width := 235
  Else
    I1YrRefF.Width := 90
end;

// MHYR 25/10/07
procedure TSalesTBody.I1YrRef2FChange(Sender: TObject);
begin
  I1YrRef2F.Hint := I1YrRef2F.Text;
end;

procedure TSalesTBody.btnApplyTTDClick(Sender: TObject);
begin
  {$IFDEF SOP}
//    If Sender Is TMenuItem Then
//      TTDHelper.ApplyTTD := NOT TTDHelper.ApplyTTD
//    Else
      TTDHelper.ApplyTTD := True;
      btnApplyTTD.Enabled := False;
  {$ENDIF}
end;

//PR: 27/08/2009 Iterate through transaction lines checking for EC Service lines. If found then zero vat on line & update header.
procedure TSalesTBody.CheckForECServiceLines;
Const
  Fnum     =  IDetailF;
  Keypath  =  IDFolioK;

Var

  KeyS,
  KeyChk    :  Str255;
  VATIdx    : VATType;

  ExStatus  :  Integer;
  bAnyECServiceLine : Boolean;

  function LineBelongs : Boolean;
  begin        //Line belongs to this transaction
    Result := (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Id.LineNo<>RecieptCode);
  end;

Begin
  bAnyECServiceLine := False;

  KeyChk:=FullNomKey(ExLocal.LInv.FolioNum);

  KeyS:=FullIdKey(ExLocal.LInv.FolioNum,1);

  ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  //PR: do a quick run through all lines to see if there are any service lines - if not then no point in recalculating the
  //vat transaction. NOTE: If there is a problem with performance here in MS-SQL then we'll need to use a Pre-Fill Cache.
  while LineBelongs and not bAnyECServiceLine do
  begin
    bAnyECServiceLine := Id.ECService;

    if not bAnyECServiceLine then
      ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  end;

  //We have at least one service line so recalulate the VAT.
  if bAnyECServiceLine then
  begin
  //Clear vat then recalculate it in the iteration below.
    ExLocal.LInv.InvVAT := 0;
    FillChar(EXLocal.LInv.InvVATAnal, SizeOf(EXLocal.LInv.InvVATAnal), 0);

    ExStatus:=0;

    KeyChk:=FullNomKey(ExLocal.LInv.FolioNum);

    KeyS:=FullIdKey(ExLocal.LInv.FolioNum,1);

    ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Id.LineNo<>RecieptCode) do
    With Id do
    Begin
      VATIdx := GetVATNo(VATCode, #0);
      if ECService then
      begin
        //Recalculate VAT, move it into PurchaseServiceTax field, then zero VAT field.
        CalcVAT(Id,ExLocal.LInv.DiscSetl);
        PurchaseServiceTax := VAT;
        ExLocal.LInv.ManVAT := True;
        VAT := 0;
        ExStatus := Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);
      end
      else
      begin //Not a service line - just add VAT as normal
        ExLocal.LInv.InvVAT := ExLocal.LInv.InvVAT + VAT;
        ExLocal.LInv.InvVATAnal[VATIdx] := ExLocal.LInv.InvVATAnal[VATIdx] + VAT;
      end;


      ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}
  end;

end; {Func..}


procedure TSalesTBody.ISPTFClick(Sender: TObject);
Var
  lSSDProcess : Char;
  lStatus     : Integer;
  KeyChk, KeyS : Str255;
  ECServicesReset : Integer;
begin
  // MH 11/09/2009: If using EC Services then on change of the SSD Process Type we need to check
  //                whether to automatically remove the EC Service flgas on the line.
  If SyssVAT.VATRates.EnableECServices Then
  Begin
    // CJS 2016-01-12 - ABSEXCH-17100 - Intrastat fields for Transaction Header
    lSSDProcess := CBtoPT(cbTransactionType.ItemIndex);
    If (ExLocal.LInv.SSDProcess = ' ') And (lSSDProcess <> ' ') Then
    Begin
      // Run through lines for the transaction removing EC Service flags
      With TBtrieveSavePosition.Create Do
      Begin
        Try
          // Save the current position in the file for the current key
          SaveFilePosition (IDetailF, GetPosKey);
          SaveDataBlock (@Id, SizeOf(Id));

          ECServicesReset := 0;

          KeyS:=FullIdKey(ExLocal.LInv.FolioNum, 1);
          KeyChk:=FullNomKey(ExLocal.LInv.FolioNum);  // Want lines matching folio number

          lStatus := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IDFolioK, KeyS);
          While (lStatus = 0) and CheckKey(KeyChk, KeyS, Length(KeyChk), BOn) Do
          Begin
            If Id.ECService Then
            Begin
              ECServicesReset := ECServicesReset + 1;
              Id.ECService := False;
              lStatus:=Put_Rec(F[IDetailF], IDetailF, RecPtr[IDetailF]^, IDFolioK);
              Report_BError (IDetailF, lStatus);
            End; // If Id.ECService

            lStatus := Find_Rec(B_GetNext,F[IDetailF], IDetailF, RecPtr[IDetailF]^, IDFolioK, KeyS);
          End; // While (lStatus = 0) and CheckKey(KeyChk, KeyS, Length(KeyChk), BOn))

          If (ECServicesReset > 0) Then
          Begin
            MessageDlg ('The SSD Type has been changed from ''Normal''. ' +
                        IntToStr(ECServicesReset) + ' EC Service flag' + IfThen(ECServicesReset>1,'s have',' has') +
                        ' been disabled on the transaction line' + IfThen(ECServicesReset > 1, 's', '') + ' for services',
                        mtWarning, [mbOK], 0);
          End; // If (ECServicesReset > 0)

          // Restore position in file
          RestoreSavedPosition;
          RestoreDataBlock (@Id);
        Finally
          Free;
        End; // Try..Finally
      End; // With TBtrieveSavePosition.Create
    End; // If (lSSDProcess <> ' ')

    ExLocal.LInv.SSDProcess := lSSDProcess;
  End; // If SyssVAT.VATRates.EnableECServices
end;

procedure TSalesTBody.SetListName(PageNo : Integer);
begin
  if Assigned(MULCtrlO) then
    MulCtrlO.Name := 'List_' + ListNames[PageNo];
end;


// CJS 21/03/2011 ABSEXCH-11089
procedure TSalesTBody.I5SDPFKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = '-') then
    Key := #0;
end;

// CJS 21/03/2011 ABSEXCH-11089
procedure TSalesTBody.I5SDDFKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = '-') then
    Key := #0;
end;

//PR: 20/10/2011 Added handling for Audit Notes v6.9
procedure TSalesTBody.General1Click(Sender: TObject);
begin
  If (NotesCtrl<>nil) then
    NotesCtrl.SwitchNoteMode(nmGeneral);
end;

procedure TSalesTBody.Dated1Click(Sender: TObject);
begin
  If (NotesCtrl<>nil) then
    NotesCtrl.SwitchNoteMode(nmDated);
end;

procedure TSalesTBody.AuditHistory1Click(Sender: TObject);
begin
  If (NotesCtrl<>nil) then
    NotesCtrl.SwitchNoteMode(nmAudit);
end;

//Called when user uses Switch from pop-up menu on Notes form
procedure TSalesTBody.SwitchNoteButtons(Sender : TObject; NewMode : TNoteMode);
begin
  AddI1Btn.Enabled := NewMode <> nmAudit;
  EditI1Btn.Enabled := NewMode <> nmAudit;
  InsI1Btn.Enabled := NewMode <> nmAudit;
  DelI1Btn.Enabled := NewMode <> nmAudit;
//  RJha 21.01.206 ABSEXCH-16048 Users cann't add notes to documents already open on another workstation
  if Assigned(NotesCtrl) then
    NotesCtrl.fParentLocked :=fRecordLocked;
end;


{ CJS 2012-09-03 - ABSEXCH-12393 - Job Code Validation }
procedure TSalesTBody.TransExtForm1CloseUp(Sender: TObject);
begin
  ValidateJobCode;
end;

{ CJS 2012-09-03 - ABSEXCH-12393 - Job Code Validation }
procedure TSalesTBody.ValidateJobCode;
var
  FoundCode: Str20;
  FoundOk  : Boolean;
begin
  {$IFDEF PF_On}
  if I4JobCodeF.Modified then
  begin
    FoundCode := Strip('B', [#32], I4JobCodeF.Text);
    if (FoundCode <> '') and (ActiveControl <> ClsI1Btn) and
       (ActiveControl <> CanI1Btn) and (JBCostOn) then
    begin
      I4JobCodeF.StillEdit := BOn;
      FoundOk := (GetJob(Self, FoundCode, FoundCode, 0));
      if (FoundOk) then
      with ExLocal do
      begin
        StopPageChange := False;
        AssignFromGlobal(JobF);
        I4JobCodeF.Text := FoundCode;
      end
      else
      begin
        if I4JobCodeF.CanFocus then
          I4JobCodeF.SetFocus
        else
          I4JobCodeF.Text := I4JobCodeF.OrigValue;
      end;
    end
    else
      If (FoundCode = '') then
        I4JobAnalF.Text := '';
  end;
  {$ENDIF}
end;

// MH 20/05/2015 v7.0.14 ABSEXCH-16284: Added Cancel PPD button
procedure TSalesTBody.btnCancelPPDClick(Sender: TObject);
Var
  oAuditNote : TAuditNote;
  sKey : Str255;
  Res : Integer;
begin
  // Precautionary double-check
  If (ExLocal.LInv.thPPDTaken <> ptPPDNotTaken) And ExLocal.LViewOnly Then
  Begin
    If (MessageDlg ('Are you sure you want to mark this transaction as PPD Not Taken?' +
                    #10#13#10#13 +
                    'Note: You will have to manually adjust the PPD Credit Note matched to this transaction.', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
    Begin
      // Reread and lock the transaction
      sKey := FullOurRefKey(ExLocal.LInv.OurRef);
      Res := Find_Rec(B_GetEq + B_MultLock, F[InvF], InvF, ExLocal.LRecPtr[InvF]^, InvOurRefK, sKey);
      If (Res = 0) Then
      Begin
        // Reset the PPD Taken flag and the DB
        ExLocal.LInv.thPPDTaken := ptPPDNotTaken;
        Res := Put_Rec(F[InvF], InvF, ExLocal.LRecPtr[InvF]^, InvOurRefK);
        If (Res = 0) Then
        Begin
          // Add an audit not to record the fact
          TAuditNote.WriteCustomAuditNote(anTransaction, 'PPD Cancelled', ExLocal);
        End; // If (Res = 0)

        // Get the record address and unlock the transaction as multilocks are not free'd by the Update
        ExLocal.LGetRecAddr(InvF);
        ExLocal.UnLockMLock(InvF, ExLocal.LastRecAddr[InvF]);

        // Refresh the buttons - the Cancel PPD button should now be hidden
        PrimeButtons;

        // Display message - the process is so quick that they might think it didn't do anything unless we tell them
        MessageDlg ('The transaction has been marked as PPD Not Taken; do not forget to adjust the associated Credit Note to compensate', mtWarning, [mbOK], 0);
      End; // If (Res = 0)

      Report_BError(InvF, Res);
    End; // If (MessageDlg ('Blah...
  End; // If (ExLocal.LInv.thPPDTaken <> ptPPDNotTaken) And ExLocal.LViewOnly
end;

procedure TSalesTBody.btnOPRefundClick(Sender: TObject);
{$IFDEF SOP}
Var
  iOPPaymentInfo : IOrderPaymentsTransactionPaymentInfo;
{$ENDIF SOP}
begin
{$IFDEF SOP}
  // Precautionary check of details - button should not have been visible if this check fails
  If Syss.ssEnableOrderPayments And (ExLocal.LInv.thOrderPaymentElement <> opeNA) Then
  Begin
    // Calculate the SOR details and lock it to protect the payment operation
    iOPPaymentInfo := OPTransactionPaymentInfo (ExLocal.LInv);
    // Check there is something to Pay and that sufficient funds are available
    If iOPPaymentInfo.CanGiveRefund Then
    Begin
      // Get a record lock
      If iOPPaymentInfo.LockTransaction Then
      Begin
        // Display the Refund Window
        OPDisplayRefundWindow (iOPPaymentInfo, Self, opnNotifyOnRefund);
      End // If iOPPaymentInfo.LockTransaction
      Else
        // Record lock failed on SOR/SDN/SIN
        MessageDlg ('A Refund cannot be given against this transaction as we could not get a record lock, another user could be editing the tranaction', mtWarning, [mbOK], 0);
    End // If iOPPaymentInfo.CanGiveRefund
    Else
      MessageDlg ('A Refund cannot be given against this Transaction', mtInformation, [mbOK], 0)
  End; // If Syss.ssEnableOrderPayments
{$ENDIF SOP}
end;

procedure TSalesTBody.btnOPPaymentClick(Sender: TObject);
{$IFDEF SOP}
Var
  iOrderPaymentsTransaction : IOrderPaymentsTransactionInfo;
{$ENDIF SOP}
begin
{$IFDEF SOP}
  // Precautionary check of details - button should not have been visible if this check fails
  If Syss.ssEnableOrderPayments And ExLocal.LCust.acAllowOrderPayments And (ExLocal.LInv.thOrderPaymentElement <> opeNA) Then
  Begin
    // Calculate the SOR details and lock it to protect the payment operation
    iOrderPaymentsTransaction := OPTransactionInfo (ExLocal.LInv, ExLocal.LCust);
    // CJS 2015-01-20 - ABSEXCH-16021 - manual payments against an Order Payment:
    // Check whether any payments have been raised against this Sales Order
    // outside of the Order Payments system
    If (ExLocal.LInv.InvDocHed = SOR) and iOrderPaymentsTransaction.HasManualPayments(ExLocal.LInv.OurRef) Then
    Begin
      MessageDlg ('A payment cannot be taken against this Sales Order as manual payments have been made against it', mtInformation, [mbOK, mbHelp], OrdPay_HasManualPayments)
    end
    // Check there is something to Pay and that sufficient funds are available
    Else If iOrderPaymentsTransaction.CanTakePayment Then
    Begin
      // Get a record lock
      If iOrderPaymentsTransaction.LockTransaction Then
      Begin
        // Display the Create Receipt Window and bring the transaction back to the front
        OPDisplayPaymentWindow (iOrderPaymentsTransaction, Self, opnNotifyOnPayment);
      End // If iOrderPaymentsTransaction.LockTransaction
      Else
        // Record lock failed on SOR/SDN/SIN
        MessageDlg ('A Payment cannot be made against this transaction as we could not get a record lock, another user could be editing the transaction', mtWarning, [mbOK], 0);
    End // If (iOrderPaymentsTransaction.optOutstandingTotal > 0)
    Else
      MessageDlg ('A payment cannot be made against the Transaction', mtInformation, [mbOK], 0)
  End; // If Syss.ssEnableOrderPayments And ExLocal.LCust.acAllowOrderPayments And (ExLocal.LInv.thOrderPaymentElement <> opeNA)
{$ENDIF SOP}
end;

{$IFDEF SOP}
function TSalesTBody.HandleRefunds: Boolean;
var
  Payment : IOrderPaymentsTransactionPaymentInfo;
  i: Integer;
begin
  Result := True;

  // Retrieve payment details for SOR
  Payment := OPTransactionPaymentInfo(ExLocal.LInv);
  Try
    if Payment.NeedsRefund(False) then
    begin
//      Payment.AssignRefundToLines;
      OPDisplayRefundWindow(Payment, Application.MainForm);
    end;
  Except
    Payment := NIL;
  End; // Try..Finally

end;


{$ENDIF}


procedure TSalesTBody.Label813Click(Sender: TObject);
begin
  ShowMessage(lblUdf9.Parent.Name + ' : ' + lblUdf11.Parent.Name);
end;

//PR: 14/11/2017 ABSEXCH-19451 Procedure to set the AllowPostedEdit property
//on edit controls that can be edited after posting
procedure TSalesTBody.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;
  //YourRef & AltRef
  I1YrRefF.AllowPostedEdit := True;
  I1YrRef2F.AllowPostedEdit := True;

  //UDFs
  THUD1F.AllowPostedEdit := True;
  THUD2F.AllowPostedEdit := True;
  THUD3F.AllowPostedEdit := True;
  THUD4F.AllowPostedEdit := True;
  edtUdf5.AllowPostedEdit := True;
  edtUdf6.AllowPostedEdit := True;
  edtUdf7.AllowPostedEdit := True;
  edtUdf8.AllowPostedEdit := True;
  edtUdf9.AllowPostedEdit := True;
  edtUdf10.AllowPostedEdit := True;
  edtUdf11.AllowPostedEdit := True;
  edtUdf12.AllowPostedEdit := True;

  ClsI1Btn.Visible := False;
  ClsI1Btn.Enabled := False;
  OkI1Btn.Top := CanI1Btn.Top + 6;
  CanI1Btn.Top := ClsI1Btn.Top + 6;

end;


//PR: 13/11/2017 ABSEXCH-19451
//Returns True if the transaction is deliberately ViewOnly, rather than because
//it's posted or allocated
function TSalesTBody.TransactionViewOnly : Boolean;
begin
  Result := ExLocal.LViewOnly and not FAllowPostedEdit;
end;

// SSK 22/10/2017 ABSEXCH-19398: Implements anonymisation behaviour for trader
procedure TSalesTBody.SetAnonymisationBanner;
begin
  {$IFNDEF EXDLL}
    //HV 07/12/2017 ABSEXCH-19535: Anonymised Transcation > The height of the window gets increased if "Save coordinates" is ticked
    if FAnonymisationON then
    begin
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
      PagePoint[0].Y := 3;
    end;
    if FListScanningOn then
    begin
      if FAnonymisationON then
        PagePoint[0].Y := 45;
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
      lblAnonStatus.Caption := Format(capAnonymisedStatus, [POutDate(ExLocal.LInv.thAnonymisedDate)]); //update the anonymisation Date
      SetAnonymisationPanel;
    end;
    Self.ClientHeight := InitSize.Y;
    FormResize(nil);
  {$ENDIF EXDLL}
end;

//HV 12/11/2017 ABSEXCH-19549: Anonymised Notification banner in View/Edit Record > Banner not displayed on maximise and then Restore Down.
procedure TSalesTBody.SetAnonymisationPanel;
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
