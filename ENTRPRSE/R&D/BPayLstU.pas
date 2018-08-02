unit BPayLstU;

interface

{$I DEFOVR.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, Menus,
  GlobVar,VarConst,BTSupU1,ExWrap1U, BorBtns,SupListU,
  {$IFDEF POST}
    Recon3U,
    PostingU,
  {$ENDIF}
  DB,
  ADODB,
  SQLCallerU,
  BPyItemU, TCustom;


type

  // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date
  TransactionTagMode = (eTagDoNothing           = 0,
                        eTagModeDue             = -1,
                        eTagModeNotDue          = 2,
                        eTagMode1Week           = 3,
                        eTagMode2Week           = 4,
                        eTagMode3WeekPlus       = 5,
                        eTagModeTotal           = -2,
                        eTagModeTransactionDate = 6,
                        eTagModeDueDate         = 7);


  TBPMList  =  Class(TGenList)
   Public
    BatchCtrl  :  BACSCType;

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Procedure Find_CustOnList(RecMainKey  :  Str255);

  end;


{$IFDEF POST}

  TScanBatch      =  Object(TEntPost)

                     private
                       BatchCtrl  :  PassWordRec;
                       CustAlObj  :  GetExNObjCid;
                       ExtCustRec :  ExtCusRecPtr;
                       CallBackH  :  THandle;
                       HookOk,
                       Scan1Mode  :  Boolean;

                       { CJS - 2012-07-19: ABSEXCH-12220 - SQL Optimisation }
                       SQLCaller: TSQLCaller;
                       // Pointers to field objects returned from query.
                       fldFolioNum: TIntegerField;
                       fldCustSupp: TStringField;
                       fldAcCode: TStringField;
                       fldRunNo: TIntegerField;
                       fldOutstanding: TStringField;
                       fldControlGL: TIntegerField;
                       fldYear: TIntegerField;
                       fldPeriod: TIntegerField;
                       fldRemitNo: TStringField;
                       fldBatchDiscAmount: TFloatField;
                       fldSettleDiscTaken: TBooleanField;
                       fldTransDate: TStringField;
                       fldSettleDiscAmount: TFloatField;
                       fldCompanyRate: TFloatField;
                       fldDailyRate: TFloatField;
                       fldCurrency: TIntegerField;
                       fldUseOriginalRates: TIntegerField;
                       fldPostDiscAm: TFloatField;
                       fldDocType: TIntegerField;
                       fldCurrSettled: TFloatField;
                       fldNetValue: TFloatField;
                       fldTotalVAT: TFloatField;
                       fldTotalLineDiscount: TFloatField;
                       fldNomAuto: TBooleanField;
                       fldAmountSettled: TFloatField;
                       fldRevalueAdj: TFloatField;
                       fldTagged: TIntegerField;
                       fldUntagged: TBooleanField;
                       fldSettledVAT: TFloatField;
                       fldVATPostDate: TStringField;
                       fldUntilDate: TStringField;
                       fldDueDate: TStringField;
                       fldOurRef: TStringField;
                       fldTotalOrderOS: TFloatField;
                       fldTotalCost: TFloatField;
                       fldTotalOrdered: TFloatField;
                       fldDeliveryNoteRef: TStringField;
                       fldVariance: TFloatField;
                       fldHoldFlag: TIntegerField;

                       fldPPDPercentage: TFloatField;
                       fldPPDDays: TIntegerField;
                       fldPPDGoodsValue: TFloatField;
                       fldPPDVATValue: TFloatField;
                       fldPPDTaken: TIntegerField;
                       fldPPDCreditNote: TBooleanField;
                       fldBatchPayPPDStatus: TIntegerField;

                       fldPositionId: TIntegerField;
                       // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date
                       fTagDate: LongDate ;  
                       fTagMode: TransactionTagMode;
                       {SS 16/01/2016 2017-R1: ABSEXCH-15752: Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date.}
                       fCustSupp : Str255;
                       ScanBatchTransMode : Boolean;

                       // Reads the pointers to the fields returned from the SQL recordset
                       procedure PrepareFields;
                       // Creates and executes the SQL query
                       procedure ReadRecords;
                       // Reads the values from the record returned from SQL into the Inv global
                       // record.
                       procedure ReadRecord(var InvR: InvRec);

                       procedure UpdateTransaction(var InvR: InvRec);

                       Function LCert_Expired(EmplCode  :  Str20;
                                              ViaSupp,
                                              ShowErr   :  Boolean)  :  Boolean;

                       Procedure BACS_CalcDoc(BFnum,BKeypath  :  Integer; ATagDate : LongDate = '');
                       
                       {SS 16/01/2016 2017-R1: ABSEXCH-15752: Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date.}
                       Procedure ResetTaggedTrans(aCustSupp:Str255);

                       Procedure SetExtSearch;

                       Function LBACSHook(HID     :  LongInt)  :  Boolean;

                       // CJS 2012-04-04: ABSEXCH-12545 - Batch Payment Tagging hook-points
                       function LBACSHook2(HID: LongInt): Boolean;

                       Procedure BACS_Scan(BFnum,BKeypath  :  Integer);

                     public
                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function Start(BCtrl    :  PassWordRec;
                                      InpWinH  :  THandle)  :  Boolean;

                   end; {Class..}

    TScan1Batch      =  Object(TScanBatch)
                     public
                       Constructor Create(AOwner  :  TObject);

                       Procedure Process; Virtual;

                   end; {Class..}

    {SS 16/01/2016 2017-R1: ABSEXCH-15752: Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date.}
    TScanBatchTrans   =  Object(TScanBatch)
                 public
                   Constructor Create(AOwner  :  TObject);

                   Procedure Process; Virtual;
                 end; {Class..}




{$ENDIF}


type
  TBatchPay = class(TForm)
    CSBox: TScrollBox;
    CHedPanel: TSBSPanel;
    CLORefLab: TSBSPanel;
    CLDateLab: TSBSPanel;
    CLAmtLab: TSBSPanel;
    CLOSLab: TSBSPanel;
    CLTotLab: TSBSPanel;
    CLOrigLab: TSBSPanel;
    CLORefPanel: TSBSPanel;
    CLDatePanel: TSBSPanel;
    CLAMTPanel: TSBSPanel;
    CLOSPAnel: TSBSPanel;
    CLTotPanel: TSBSPanel;
    CLOrigPanel: TSBSPanel;
    CBtnPanel: TSBSPanel;
    ClsCP1Btn: TButton;
    CCBSBox: TScrollBox;
    EditCP1Btn: TButton;
    DelCP1Btn: TButton;
    HistCP1Btn: TButton;
    AddCP1Btn: TButton;
    InsCP3Btn: TButton;
    GenCP3Btn: TButton;
    CListBtnPanel: TSBSPanel;
    PopupMenu1: TPopupMenu;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    UnTAG1: TMenuItem;
    Tag1: TMenuItem;
    WildTag1: TMenuItem;
    Clear1: TMenuItem;
    Process1: TMenuItem;
    ReCalc1: TMenuItem;
    Find1: TMenuItem;
    SBSPanel1: TSBSPanel;
    Label81: Label8;
    Label82: Label8;
    Bevel1: TBevel;
    Label83: Label8;
    CompF: Text8Pt;
    CBalF: TCurrencyEdit;
    M3Tot: TCurrencyEdit;
    M2Tot: TCurrencyEdit;
    M1Tot: TCurrencyEdit;
    NDTot: TCurrencyEdit;
    TagTot: TCurrencyEdit;
    PopupMenu2: TPopupMenu;
    Due1: TMenuItem;
    NotDue1: TMenuItem;
    Wk1: TMenuItem;
    Wk2: TMenuItem;
    Wk3: TMenuItem;
    Total1: TMenuItem;
    BPCustBtn1: TSBSButton;
    Custom1: TMenuItem;
    EntCustom1: TCustomisation;
    PopupMenu3: TPopupMenu;
    RC1: TMenuItem;
    RC2: TMenuItem;
    pnlTraderPPD: TSBSPanel;
    lblTraderPPD: TSBSPanel;
    FindCP1Btn: TButton;
    Bevel2: TBevel;
    Bevel3: TBevel;
    mniTransactionDate: TMenuItem;           // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date
    mniDueDate: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure CLORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CLORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CLORefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AddCP1BtnClick(Sender: TObject);
    procedure InsCP3BtnClick(Sender: TObject);
    procedure Due1Click(Sender: TObject);
    procedure WildTag1Click(Sender: TObject);
    procedure HistCP1BtnClick(Sender: TObject);
    procedure GenCP3BtnClick(Sender: TObject);
    procedure FindCP1BtnClick(Sender: TObject);
    procedure BPCustBtn1Click(Sender: TObject);
    procedure RC1Click(Sender: TObject);
  private
    { Private declarations }
    TagClearMode,
    RecMode,
    BeenIn,
    JustCreated,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    fFrmClosing,
    fDoingClose,
    Scan1Acc,

    InMsg71,
    GotCoord,
    CanDelete    :  Boolean;

    PagePoint    :  Array[0..4] of TPoint;

    BPTots       :  Array[0..4] of TCurrencyEdit;

    BPBtns       :  Array[0..9] of TButton;

    AgeBACSTit   :  AgedTitType;

    WTagMode     :  TransactionTagMode;      // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date

    ThisRunNo    :  LongInt;

    StartSize,
    InitSize     :  TPoint;

    BItemList    :  TBatchItems;

    FDateValue   :  Longdate;        // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date

    procedure Find_FormCoord;

    procedure Store_FormCoord;

    procedure FormSetOfSet;

    procedure Show_ItemList(ScanMode  :  Boolean);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;



    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure Link2Tot;


    Procedure SetButtons(State  :  Boolean);

    {SS 16/01/2016 2017-R1: ABSEXCH-15752: Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date.}
    Procedure Set_TaggedStat(TagNo   :  TransactionTagMode;
                             Toggle  :  Byte;
                             Fnum,
                             Keypath :  Integer;
                             Update  :  Boolean;
                             CallFromList:Boolean=False);

    Procedure BACS_WildTag(TagNo     :  TransactionTagMode;
                           Toggle    :  Byte;
                           Fnum,
                           Keypath   :  Integer;
                           MainK     :  Str255);



    Function Check4NegBATCH(Fnum,
                            Keypath  :  Integer;
                            Warn     :  Boolean)  :  Boolean;

    Function Check_OnlyUser  :  Boolean;

    procedure ReCalcOneAcc;
    procedure ReCalcAllAccs;

    procedure SetHelpContextIDs; // NF: 20/06/06
    // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date
    function InputQueryEx(const ACaption, APrompt: string;var Value: LongDate): Boolean;

  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    BatchCtrl    :  PassWordRec;

    ListOfSet    :  Integer;

    MULCtrlO     :  TBPMList;

    MyUsrNo,
    MyUsrAddr    :  LongInt;



    procedure FormDesign;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure SetListLabels;

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure SetCaption;

    procedure SetFormProperties;

  end;


Procedure Set_BPFormMode(State  :  Boolean;
                         TRNo   :  LongInt);


{$IFDEF POST}
  Procedure AddBACSScan2Thread(AOwner   :  TObject;
                               BCtrl    :  PassWordRec;
                               MyHandle :  THandle;
                               ATagDate :  LongDate='';
                               ATagMode :  TransactionTagMode=eTagDoNothing);

{$ENDIF}


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
  SBSComp,
  VarJCstU,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  SysU1,
  SysU2,

  {$IFDEF GF}
    FindRecU,
    FindCtlU,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,

  {$ENDIF}

  {$IFDEF Rp}
    BACS3U,
  {$ENDIF}

  DocSupU1,
  SalTxl1U,
  Warn1U,
  GenWarnU,
  PWarnU,
  BPWarnUU,

  {$IFDEF JC}
    JobSup1U,
  {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}
  StrUtil, // PS 21/11/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date
  ExThrd2U,
  EntWindowSettings,

  PromptPaymentDiscountFuncs,
  
  ADOConnect;

{$R *.DFM}



Var
  BPFormMode  :  Boolean;
  BPRunNo     :  LongInt;
  WindowSettings: IWindowSettings;

{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_BPFormMode(State  :  Boolean;
                         TRNo   :  LongInt);


Begin

  BPFormMode:=State;
  BPRunNo:=TRNo;

end;


{$I BPTI1U.PAS}


{$IFDEF POST}

  { ========== TScanBatch methods =========== }

  Constructor TScanBatch.Create(AOwner  :  TObject);
  var
    CompanyCode: string;
    ConnectionString: string;
  Begin
    Inherited Create(AOwner);

    fTQNo:=3;
    fCanAbort:=BOn;

    IsParentTo:=BOn;

    fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;

    New(CustAlObj,Init);
    New(ExtCustRec);

    FillChar(ExtCustRec^,Sizeof(ExtCustRec^),0);

    Scan1Mode:=BOff; HookOk:=BOn;
    ScanBatchTransMode := BOff;

    { CJS - 2012-07-19: ABSEXCH-12220 - SQL Optimisation }
    if SQLUtils.UsingSQLAlternateFuncs then
    begin
      //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
      SQLCaller := TSQLCaller.Create(GlobalAdoConnection);
      CompanyCode := SQLUtils.GetCompanyCode(SetDrive);
    end;
  end;

  Destructor TScanBatch.Destroy;

  Begin
    { CJS - 2012-07-19: ABSEXCH-12220 - SQL Optimisation }
    FreeAndNil(SQLCaller);

    Dispose(CustAlObj,Done);
    Dispose(ExtCustRec);

    Inherited Destroy;
  end;

{ CJS - 2012-07-19: ABSEXCH-12220 - SQL Optimisation }
procedure TScanBatch.PrepareFields;
begin
  fldFolioNum          := SQLCaller.Records.FieldByName('thFolioNum') as TIntegerField;
  fldCustSupp          := SQLCaller.Records.FieldByName('thCustSupp') as TStringField;
  fldAcCode            := SQLCaller.Records.FieldByName('thAcCode') as TStringField;
  fldRunNo             := SQLCaller.Records.FieldByName('thRunNo') as TIntegerField;
  fldOutstanding       := SQLCaller.Records.FieldByName('thOutstanding') as TStringField;
  fldControlGL         := SQLCaller.Records.FieldByName('thControlGL') as TIntegerField;
  fldYear              := SQLCaller.Records.FieldByName('thYear') as TIntegerField;
  fldPeriod            := SQLCaller.Records.FieldByName('thPeriod') as TIntegerField;
  fldRemitNo           := SQLCaller.Records.FieldByName('thRemitNo') as TStringField;
  fldBatchDiscAmount   := SQLCaller.Records.FieldByName('thBatchDiscAmount') as TFloatField;
  fldSettleDiscTaken   := SQLCaller.Records.FieldByName('thSettleDiscTaken') as TBooleanField;
  fldTransDate         := SQLCaller.Records.FieldByName('thTransDate') as TStringField;
  fldSettleDiscAmount  := SQLCaller.Records.FieldByName('thSettleDiscAmount') as TFloatField;
  fldCompanyRate       := SQLCaller.Records.FieldByName('thCompanyRate') as TFloatField;
  fldDailyRate         := SQLCaller.Records.FieldByName('thDailyRate') as TFloatField;
  fldCurrency          := SQLCaller.Records.FieldByName('thCurrency') as TIntegerField;
  fldUseOriginalRates  := SQLCaller.Records.FieldByName('thUseOriginalRates') as TIntegerField;
  fldPostDiscAm        := SQLCaller.Records.FieldByName('PostDiscAm') as TFloatField;
  fldDocType           := SQLCaller.Records.FieldByName('thDocType') as TIntegerField;
  fldCurrSettled       := SQLCaller.Records.FieldByName('thCurrSettled') as TFloatField;
  fldNetValue          := SQLCaller.Records.FieldByName('thNetValue') as TFloatField;
  fldTotalVAT          := SQLCaller.Records.FieldByName('thTotalVAT') as TFloatField;
  fldTotalLineDiscount := SQLCaller.Records.FieldByName('thTotalLineDiscount') as TFloatField;
  fldNomAuto           := SQLCaller.Records.FieldByName('thNomAuto') as TBooleanField;
  fldAmountSettled     := SQLCaller.Records.FieldByName('thAmountSettled') as TFloatField;
  fldRevalueAdj        := SQLCaller.Records.FieldByName('thRevalueAdj') as TFloatField;
  fldTagged            := SQLCaller.Records.FieldByName('thTagged') as TIntegerField;
  fldUntagged          := SQLCaller.Records.FieldByName('thUntagged') as TBooleanField;
  fldSettledVAT        := SQLCaller.Records.FieldByName('thSettledVAT') as TFloatField;
  fldVATPostDate       := SQLCaller.Records.FieldByName('thVATPostDate') as TStringField;
  fldUntilDate         := SQLCaller.Records.FieldByName('thUntilDate') as TStringField;
  fldDueDate           := SQLCaller.Records.FieldByName('thDueDate') as TStringField;
  fldOurRef            := SQLCaller.Records.FieldByName('thOurRef') as TStringField;
  fldTotalOrderOS      := SQLCaller.Records.FieldByName('thTotalOrderOS') as TFloatField;
  fldTotalCost         := SQLCaller.Records.FieldByName('thTotalCost') as TFloatField;
  fldTotalOrdered      := SQLCaller.Records.FieldByName('thTotalOrdered') as TFloatField;
  fldDeliveryNoteRef   := SQLCaller.Records.FieldByName('thDeliveryNoteRef') as TStringField;
  fldVariance          := SQLCaller.Records.FieldByName('thVariance') as TFloatField;
  fldHoldFlag          := SQLCaller.Records.FieldByName('thHoldFlag') as TIntegerField;

  fldPPDPercentage     := SQLCaller.Records.FieldByName('thPPDPercentage') as TFloatField;
  fldPPDDays           := SQLCaller.Records.FieldByName('thPPDDays') as TIntegerField;
  fldPPDGoodsValue     := SQLCaller.Records.FieldByName('thPPDGoodsValue') as TFloatField;
  fldPPDVATValue       := SQLCaller.Records.FieldByName('thPPDVATValue') as TFloatField;
  fldPPDTaken          := SQLCaller.Records.FieldByName('thPPDTaken') as TIntegerField;
  fldPPDCreditNote     := SQLCaller.Records.FieldByName('thPPDCreditNote') as TBooleanField;
  fldBatchPayPPDStatus := SQLCaller.Records.FieldByName('thBatchPayPPDStatus') as TIntegerField;

  fldPositionId        := SQLCaller.Records.FieldByName('PositionId') as TIntegerField;
end;

{ CJS - 2012-07-19: ABSEXCH-12220 - SQL Optimisation }
procedure TScanBatch.ReadRecord(var InvR: InvRec);

  function SafeCharFromString(Str: string; Position: Integer): Char;
  begin
    if (Position > Length(Str)) then
      Result := ' '
    else
      Result := Str[Position];
  end;

begin
  InvR.FolioNum      := fldFolioNum.Value;
  InvR.CustSupp      := SafeCharFromString(fldCustSupp.Value, 1);
  InvR.CustCode      := fldAcCode.Value;
  InvR.RunNo         := fldRunNo.Value;
  InvR.AllocStat     := SafeCharFromString(fldOutstanding.Value, 1);
  InvR.CtrlNom       := fldControlGL.Value;
  InvR.AcYr          := fldYear.Value;
  InvR.AcPr          := fldPeriod.Value;
  InvR.RemitNo       := fldRemitNo.Value;
  InvR.BDiscount     := fldBatchDiscAmount.Value;
  InvR.DiscTaken     := fldSettleDiscTaken.Value;
  InvR.TransDate     := fldTransDate.Value;
  InvR.DiscSetAm     := fldSettleDiscAmount.Value;
  InvR.CXrate[False] := fldCompanyRate.Value;
  InvR.CXRate[True]  := fldDailyRate.Value;
  InvR.Currency      := fldCurrency.Value;
  InvR.UseORate      := fldUseOriginalRates.Value;
  InvR.PostDiscAm    := fldPostDiscAm.Value;
  InvR.InvDocHed     := DocTypes(fldDocType.Value);
  InvR.CurrSettled   := fldCurrSettled.Value;
  InvR.InvNetVal     := fldNetValue.Value;
  InvR.InvVat        := fldTotalVAT.Value;
  InvR.DiscAmount    := fldTotalLineDiscount.Value;
  InvR.NomAuto       := fldNomAuto.Value;
  InvR.Settled       := fldAmountSettled.Value;
  InvR.ReValueAdj    := fldRevalueAdj.Value;
  InvR.Tagged        := fldTagged.Value;
  InvR.Untagged      := fldUntagged.Value;
  InvR.SettledVAT    := fldSettledVAT.Value;
  InvR.VATPostDate   := fldVATPostDate.Value;
  InvR.UntilDate     := fldUntilDate.Value;
  InvR.DueDate       := fldDueDate.Value;
  InvR.OurRef        := fldOurRef.Value;
  InvR.TotOrdOS      := fldTotalOrderOS.Value;
  InvR.TotalCost     := fldTotalCost.Value;
  InvR.TotalOrdered  := fldTotalOrdered.Value;
  InvR.DeliverRef    := fldDeliveryNoteRef.Value;
  InvR.Variance      := fldVariance.Value;
  InvR.thPPDPercentage      := fldPPDPercentage.Value;    
  InvR.thPPDDays            := fldPPDDays.Value;          
  InvR.thPPDGoodsValue      := fldPPDGoodsValue.Value;    
  InvR.thPPDVATValue        := fldPPDVATValue.Value;
  InvR.thPPDTaken           := TTransactionPPDTakenStatus(fldPPDTaken.Value);
  InvR.thPPDCreditNote      := fldPPDCreditNote.Value;    
  InvR.thBatchPayPPDStatus  := fldBatchPayPPDStatus.Value;
  InvR.HoldFlg       := fldHoldFlag.Value;
end;

{ CJS - 2012-07-19: ABSEXCH-12220 - SQL Optimisation }
procedure TScanBatch.ReadRecords;
var
  CompanyCode: string;
  Qry: string;
begin
  CompanyCode := GetCompanyCode(SetDrive);
  // CJS 2015-03-02 - ABSEXCH-16164 - Exclude Order Payment SRCs from Batch Receipts
  // Amended query to exclude Order Payments Sales Receipts
  Qry := Format('SELECT thFolioNum                      ' +
                '      ,thCustSupp                      ' +
                '      ,thAcCode                        ' +
                '      ,thRunNo                         ' +
                '      ,thControlGL                     ' +
                '      ,thYear                          ' +
                '      ,thPeriod                        ' +
                '      ,thRemitNo                       ' +
                '      ,thOutstanding                   ' +
                '      ,thBatchDiscAmount               ' +
                '      ,thSettleDiscTaken               ' +
                '      ,thTransDate                     ' +
                '      ,thSettleDiscAmount              ' +
                '      ,thCompanyRate                   ' +
                '      ,thDailyRate                     ' +
                '      ,thCurrency                      ' +
                '      ,thUseOriginalRates              ' +
                '      ,PostDiscAm                      ' +
                '      ,thDocType                       ' +
                '      ,thCurrSettled                   ' +
                '      ,thNetValue                      ' +
                '      ,thTotalVAT                      ' +
                '      ,thTotalLineDiscount             ' +
                '      ,thNomAuto                       ' +
                '      ,thAmountSettled                 ' +
                '      ,thRevalueAdj                    ' +
                '      ,thTagged                        ' +
                '      ,thUntagged                      ' +
                '      ,thSettledVAT                    ' +
                '      ,thVATPostDate                   ' +
                '      ,thUntilDate                     ' +
                '      ,thDueDate                       ' +
                '      ,thOurRef                        ' +
                '      ,thTotalOrderOS                  ' +
                '      ,thTotalCost                     ' +
                '      ,thTotalOrdered                  ' +
                '      ,thDeliveryNoteRef               ' +
                '      ,thVariance                      ' +
                '      ,thHoldFlag                      ' +
                '      ,thPPDPercentage                 ' +
                '      ,thPPDDays                       ' +
                '      ,thPPDGoodsValue                 ' +
                '      ,thPPDVATValue                   ' +
                '      ,thPPDTaken                      ' +
                '      ,thPPDCreditNote                 ' +
                '      ,thBatchPayPPDStatus             ' +
                '      ,PositionId                      ' +
                'FROM [COMPANY].[DOCUMENT]              ' +
                'WHERE                                  ' +
                '      thAcCode = ''%s''                ' +
                '  AND thOutstanding = ''%s''           ' +
                '  AND ((thCurrency = %d) OR (%d = 0))  ' +
                '  AND thNomAuto = %d                   ' +
                '  AND ((thOrderPaymentElement = %d) OR (thDocType <> %d)) ',
                [
                  ExtCustRec^.FCusCode,
                  ExtCustRec^.FAlCode,
                  ExtCustRec^.FCr,
                  ExtCustRec^.FCr,
                  Ord(ExtCustRec^.FNomAuto),
                  Ord(opeNA),
                  Ord(SRC)
                ]);
  SQLCaller.Select(Qry, CompanyCode);
  if (SQLCaller.ErrorMsg <> '') then
  begin

  end;
  PrepareFields;
end;

{ CJS - 2012-07-19: ABSEXCH-12220 - SQL Optimisation }
procedure TScanBatch.UpdateTransaction(var InvR: InvRec);
var
  Qry: string;
  FuncRes: Integer;
begin
  { CJS 2012-11-09 - ABSEXCH-13670 - Included thBatchDiscAmount in update }
  { CJS 2015-05-07 - v7.0.14 - PPD - Batch Paymt/Recpt - Included thBatchPayPPDStatus }
  Qry := Format('UPDATE [COMPANY].DOCUMENT  ' +
                'SET                        ' +
                '  thTagged = %d,           ' +
                '  thUntagged = %d,         ' +
                '  thBatchThen = %f,        ' +
                '  thBatchNow = %f,         ' +
                '  thBatchDiscAmount = %f,  ' +
                '  thBatchPayPPDStatus = %d ' +
                'WHERE PositionId = %d      ',
                [
                  InvR.Tagged,
                  Ord(InvR.UnTagged),
                  InvR.BatchThen,
                  InvR.BatchNow,
                  InvR.BDiscount,
                  InvR.thBatchPayPPDStatus,
                  fldPositionID.Value
                ]);
  FuncRes := SQLUtils.ExecSQL(Qry, SetDrive);
  if FuncRes <> 0 then
  begin

  end;
end;

// PS 26/10/2016 2017 R1 ABSEXCH-15752 - Added AtagDate to hold Date for tagging
Procedure TScanBatch.BACS_CalcDoc(BFnum,BKeypath  :  Integer;  ATagDate : LongDate = '');


Const
  Fnum     =  InvF;

Var

  KeyS2,
  KeyChk :  Str255;

  LOk,
  FoundOk,
  UseOsKey,
  WasSDSet,
  Locked      :  Boolean;

  DocThen     :  Real;

  TUseDate    :  LongDate;

  n           :  Byte;

  KeyPath     :  Integer;

  EndInv      :  LongInt;

  EInv        :  InvRec;

  // CJS 2012-04-04: ABSEXCH-12545 - Batch Payment Tagging hook-points
  // ID of the Hook Point (178 or 179)
  HookId: Integer;
  // Flag to indicate that the Hook Point has asked for the transation to be
  // automatically tagged.
  AutoTag: Boolean;
  // Aging interval position
  Age: Integer;
  // Flag to indicate that the transaction should be saved because the PPD
  // status has changed
  PPDHasChanged: Boolean;
  // Temporary store for the PPD Status to be set on the current transaction
  PPDStatus: Integer;

  //SS:15/12/2017:2017-R2:ABSEXCH-19170:When wild tagging on more than 1 column, System appears to be untagging and retagging transactions.
  //Check weather transaction is tagged ot not. 
  function IsTransTagged(): Boolean;
  var
    lDiff  :  Integer;
    lDate :  LongDate;
  begin
    Result := False;
    if ATagDate = EmptyStr then Exit;

    if (fTagMode <> eTagModeTransactionDate) and (fTagMode <> eTagModeDueDate) then Exit;

    {
    if fTagMode = eTagModeTransactionDate then
      lDate := MtExLocal.LInv.TransDate
    else if fTagMode = eTagModeDueDate then
      lDate := MtExLocal.LInv.DueDate;
    }
    
    lDate := Get_StaChkDate(MtExLocal.LInv);

    with MTExLocal.LMiscRecs^.BACSSRec do
    begin
      lDiff:=AgedPos(lDate,DateTimeAsLongDate(Now),BatchCtrl.BACSCRec.AgeType,BatchCtrl.BACSCRec.AgeInt);
      lDiff := lDiff+1;
      Result := (HasTagged[lDiff]) or (MtExLocal.LInv.Tagged = 1);
    end;

  end;


  //SS:15/12/2017:2017-R2:ABSEXCH-19170:When wild tagging on more than 1 column, System appears to be untagging and retagging transactions.
  function IsValidRecord: Boolean;
  var
    lKeyPayList,lKeyChkPaylist  :  Str255;
  begin
    Result := False;
    if (fTagMode in [eTagModeTransactionDate,eTagModeDueDate]) then
    begin
      lKeyPayList := PartCCKey(MBACSCode,MBACSSub)+FullNomKey(BatchCtrl.BACSCRec.TagRunNo)+MTExLocal^.LCust.CustCode;
      lKeyChkPaylist  := lKeyPayList;

      MTExLocal^.LStatus := MTExLocal^.LFind_Rec(B_GetGEq,BFnum,0,lKeyPayList);
      
      Result := (MTExLocal^.LStatusOk) and (CheckKey(lKeyChkPaylist,lKeyPayList,Length(lKeyChkPaylist),BOn))
    end;                                                                                                    
  end;


  { CJS - 2012-07-19: ABSEXCH-12220 - Batch Payments - SQL Optimisation }
  function HasMoreRecords: Boolean;
  begin
    if SQLUtils.UsingSQLAlternateFuncs then
      Result := not SQLCaller.Records.Eof
    else
      Result := (MTExLocal^.LStatusOk) and (CheckKey(KeyChk,KeyS2,Length(KeyChk),BOn));
  end;


  function PromptPaymentDaysRemaining: Integer;
  begin
    Result := NoDays(BatchCtrl.BACSCRec.IntendedPaymentDate,
                     CalcDueDate(MTExLocal.LInv.TransDate, MTExLocal.LInv.thPPDDays));
  end;

  // CJS 2015-05-07 - v7.0.14 - PPD - Batch Payments/Sales Receipts - Build Process
  function AdjustOutstandingForPPD(OutstandingAmount: Double; Status: Integer): Double;
  var
    CanTakePPD: Boolean;
    PPDAvailable: Double;
  begin
    Result := OutstandingAmount;
    // CJS 2015-06-24 - ABSEXCH-16519 - Batch Payments after taking PPD via ledger
    CanTakePPD  := ValidPPDAvailable(MTExLocal.LInv,
                                     BatchCtrl.BACSCRec.IntendedPaymentDate,
                                     BatchCtrl.BACSCRec.PPDExpiryToleranceDays);
    if CanTakePPD and (Status = PPD_BATCHPAY_SET) then
    begin
      // CJS 2015-01-07 - ABSEXCH-16612 - allow expired PPD to be taken
      if (PromptPaymentDaysRemaining >= (-1 * Abs(BatchCtrl.BACSCRec.PPDExpiryToleranceDays))) then
      begin
        // Calculate the PPD Available in the Invoice currency
        PPDAvailable := MTExLocal.LInv.thPPDGoodsValue + MTExLocal.LInv.thPPDVATValue;
        // If the Payments are to be made in a different currency...
        if BatchCtrl.BACSCRec.PayCurr <> MTExLocal.LInv.Currency then
        begin
          // ... convert the PPD Available to the base currency ...
          PPDAvailable := Conv_TCurr(PPDAvailable, XRate(MTExLocal.LInv.CXRate, BOff, MTExLocal.LInv.Currency), MTExLocal.LInv.Currency, 0, BOff);
          // CJS 2015-08-25 - ABSEXCH-16782 - Batch Payments does not convert currency
          // ... and then convert the result to the Payment currency
          PPDAvailable := Conv_TCurr(PPDAvailable, SyssCurr^.Currencies[BatchCtrl.BACSCRec.PayCurr].CRates[UseCoDayRate], BatchCtrl.BACSCRec.PayCurr, 0, BOn);
        end;
        Result := Result - (PPDAvailable*DocCnst[MTExLocal.LInv.InvDocHed]*DocNotCnst);
      end;
    end;
  end;

Begin

  FoundOk:=BOff;

  DocThen:=0;

  Locked:=BOff;

  n:=0;

  WasSDSet:=BOff;
  EInv:=Inv;

  EndInv:=0;

  UseOSKey:=BatchCtrl.BacsCRec.UseOsNdx;

  If (UseOSKey) then
    KeyPath:=InvOSK
  else
    KeyPath:=InvCustK;

  FillChar(KeyChk,Sizeof(KeyChk),#0);
  FillChar(KeyS2,Sizeof(KeyS2),#0);

  With MTExLocal^ do
  Begin

    With LCust do
    Begin

      If (UseOSKey) then
        KeyChk:=TradeCode[BatchCtrl.BacsCRec.SalesMode]+FullCustCode(CustCode)
      else
        KeyChk:=FullCustType(CustCode,CustSupp)+#1;  {* Ignore Nom Ledger Items *}

    end;

    KeyS2:=KeyChk;
    {$IFDEF EXSQL}
    If SQLUtils.UsingSQLAlternateFuncs Then
      { CJS - 2012-07-19: ABSEXCH-12220 - Batch Payments - SQL Optimisation }
      ReadRecords
    Else
    {$ENDIF}
    Begin
      LStatus:=GetExtCusALCid(ExtCustRec,CustAlObj,Fnum,Keypath,B_GetGEq,1,KeyS2);  // Effectively a GetGEq
    End;

    While HasMoreRecords and (Not ThreadRec^.THAbort) do
    With LInv do
    Begin
      if SQLUtils.UsingSQLAlternateFuncs then
        ReadRecord(MTExLocal^.LInv);

      // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Override useDate with Tag transaction date
      TUseDate:=Get_StaChkDate(LInv);

      // CJS 2015-05-07 - v7.0.14 - PPD - Batch Payments/Sales Receipts - Build Process
      if ((thPPDPercentage <> 0.0) and (thPPDTaken <> ptPPDTaken)) and
         ((LCust.CustSupp = 'S') and (LCust.acPPDMode = pmPPDDisabled)) then
      begin
        // This is a Supplier with disabled PPD, but there is PPD available on
        // the Transaction. Exclude this transaction, and report the reason.
        if Assigned(PostLog) then
          Write_PostLogDD('Transaction ' + LInv.OurRef +
                          ' excluded although it has PPD specified, as PPD is disabled for account ' +
                          dbFormatName(LCust.CustCode, LCust.Company), True,
                          CustCode, 1);
      end
      else if (ExtCusFiltCid(0,ExtCustRec,CustAlObj)) and (Not SettledFull(LInv)) and LBACSHook(174+Ord(BatchCtrl.BACSCRec.SalesMode))
        and ((LInv.thOrderPaymentElement = opeNA) or (LInv.InvDocHed <> SRC)) then
      Begin
        If (FolioNum>EndInv) then
          EndInv:=FolioNum;

        If (Not FoundOk) then
        begin
          FoundOk:=BOn;


          //SS:15/12/2017:2017-R2:ABSEXCH-19170:When wild tagging on more than 1 column, System appears to be untagging and retagging transactions.
          // To gain the performance we are not reset each records which are not changed.
          if not IsValidRecord then
          begin
            With LMiscRecs^ do
            Begin

              LResetRec(BFnum);

              LMiscRecs^.RecMfix:=MBACSCode;
              LMiscRecs^.Subtype:=MBACSSub;

              With LMiscRecs^.BACSSRec do
              Begin
                TagRunNo:=BatchCtrl.BACSCRec.TagRunNo;

                TagCustCode:=LCust.CustCode;

                SalesCust:=IsACust(LCust.CustSupp);

                TagSuppK:=FullBACSKey(TagCustCode,TagRunNo);

                TagBal:=LCust.Balance;

                // CJS 2015-05-07 - v7.0.14 - PPD - Batch Paymt/Recpt - Build Process
                if (LCust.acPPDMode <> pmPPDDisabled) then
                begin
                  TraderPPDPercentage := LCust.DefSetDisc;
                  TraderPPDDays := LCust.DefSetDDays;
                end;

              end;
            end;  //With LMiscRecs^ do
            
          end;  // if not IsValidRecord then

        end; //If (Not FoundOk) then
        
        With BatchCtrl.BACSCRec do
        Begin
          WasSDSet:=(BDiscount<>0.0);

          ForceInvSDisc(LInv,EInv,BatchCtrl,0);

          {$IFDEF MC_On}

            If (Currency=PayCurr) then {* We are paying off the own currency equivalent *}
              DocThen:=CurrencyOS(EInv,BOff,BOff,BOff)
            else
              DocThen:=Currency_ConvFT(BaseTotalOS(EInv),0,PayCurr,UseCoDayRate);

          {$ELSE}

              DocThen:=BaseTotalOS(EInv);

          {$ENDIF}

          // CJS 2015-05-07 - v7.0.14 - PPD - Batch Paymt/Recpt - Build Process
          PPDHasChanged := False;
          // CJS 2015-06-26 - ABSEXCH-16583 - duplicate PPD lines on auto-generated credits
          PPDStatus := MTExLocal.LInv.thBatchPayPPDStatus;
          if PPDFieldsPopulated(MTExLocal.LInv) and BatchCtrl.BACSCRec.ApplyPPD then
          begin
            // CJS 2015-06-29 - ABSEXCH-16612 - allow expired PPD to be taken
            // If the PPD has expired, don't automatically take it
            if ValidPPDAvailable(MTExLocal.LInv,
                                 BatchCtrl.BACSCRec.IntendedPaymentDate,
                                 BatchCtrl.BACSCRec.PPDExpiryToleranceDays) then
              PPDStatus := PPD_BATCHPAY_SET
            else
              // PPD has expired -- don't automatically take it
              PPDStatus := PPD_BATCHPAY_UNSET;
            DocThen := AdjustOutstandingForPPD(DocThen, PPDStatus);
            PPDHasChanged := True;
          end
          else if (PPDStatus = 1) then
          begin
            PPDStatus := 0;
            PPDHasChanged := True;
          end;


          //SS:15/12/2017:2017-R2:ABSEXCH-19170:When wild tagging on more than 1 column, System appears to be untagging and retagging transactions.
          if ((fTagMode <> eTagModeTransactionDate) and (fTagMode <> eTagModeDueDate)) then
            BPYItemU.MasterAged(LMiscRecs^.BACSSRec.TotalOS,TUseDate,TagASDate,DocThen,AgeType,AgeInt);


          //SS:15/12/2017:2017-R2:ABSEXCH-19170:When wild tagging on more than 1 column, System appears to be untagging and retagging transactions.
          // Code before ABSEXCH-19170 changes.

          // PS 21/11/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date
          //                                       Calculate Age till today
          {if ((fTagMode = eTagModeTransactionDate) or (fTagMode = eTagModeDueDate)) then
            BPYItemU.MasterAged(LMiscRecs^.BACSSRec.TotalOS,TUseDate,DateTimeAsLongDate(Now),DocThen,AgeType,AgeInt)
          else
            BPYItemU.MasterAged(LMiscRecs^.BACSSRec.TotalOS,TUseDate,TagASDate,DocThen,AgeType,AgeInt);
           }

          // CJS 2012-04-04: ABSEXCH-12545 - Batch Payment Tagging hook-points
          if BatchCtrl.BACSCRec.SalesMode = True then
            HookId := 179  // Sales Transaction
          else
            HookId := 178; // Purchase Transaction
          // Check the hook point to find out if we should automatically tag
          // this transaction.
          AutoTag := LBACSHook2(HookId);
          // Reset/update tagged status

          // PS 26/10/2016 2017 R1 ABSEXCH-15752 - AutoTag is true for following tab type
          //   All Existing tagged transaction and who TransDate or Duedate is less then Tagdate Entered  will be tag and recalculated
          if (((fTagMode = eTagModeTransactionDate) and (MtExLocal.LInv.TransDate <= ATagDate))  //TagAsDate
             or ((fTagMode = eTagModeDueDate) and (MtExLocal.LInv.DueDate  <= ATagDate))
             or ((MtExLocal.LInv.Tagged = 1 ) and (fTagMode in [eTagModeTransactionDate,eTagModeDueDate]  ))
             )then   //TagAsDate
          begin
            AutoTag := True ;
          end;

          // CJS 2015-05-07 - v7.0.14 - PPD - Batch Paymt/Recpt - Build Process
          // Include transactions which have PPD, so that the updated status
          // flag is actually saved to the database.

          //SS:15/12/2017:2017-R2:ABSEXCH-19170:When wild tagging on more than 1 column, System appears to be untagging and retagging transactions.
          // "(not IsTransTagged)" : Only process the transactions which are not tagged.
          if (PPDHasChanged or AutoTag or (Tagged = 1) or (UnTagged) or (BDiscount <> 0.0) or (WasSDSet)) and (not IsTransTagged) then
          Begin

            LOk:=BOff;

            { CJS - 2012-07-19: ABSEXCH-12220 - Batch Payments - SQL Optimisation }
            { CJS - 2012-08-02: ABSEXCH-13214 - Batch Payments - Recalc failing }
            {$IFDEF EXSQL}
            if SQLUtils.UsingSQLAlternateFuncs then
            begin
              LOk := True;
              Locked := True;
            end
            else
            {$ENDIF}
            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS2,Keypath,Fnum,BOn,Locked);

            If (LOk) and (Locked) then
            Begin
              LGetRecAddr(Fnum);

              {* Recalculate as get direct will reset *}

              ForceInvSDisc(LInv,EInv,BatchCtrl,0);

              // CJS 2015-06-26 - ABSEXCH-16583 - duplicate PPD lines on auto-generated credits
              // The LGetMultiRec above will have re-read the transaction
              // record, so we can't update the Batch Payment Status on it until
              // after that has been done.
              MtExLocal.LInv.thBatchPayPPDStatus := PPDStatus;

              // CJS 2012-04-04: ABSEXCH-12545 - Batch Payment Tagging hook-points
              if AutoTag or (Tagged = 1) or (UnTagged) or (BDiscount <> 0.0) or (WasSDSet) then
              begin
                if AutoTag then
                begin
                  LInv.Tagged := 1;
                  // Determine the correct 'aging' column
                  Age := AgedPos(TUseDate, TagASDate, AgeType, AgeInt);

                  //SS:15/12/2017:2017-R1:ABSEXCH-19170:When wild tagging on more than 1 column, System appears to be untagging and retagging transactions.
                  if ((fTagMode = eTagModeTransactionDate) or (fTagMode = eTagModeDueDate))  then
                    Age := Age + 1;

                  // PS 24/11/2016 2017 R1 ABSEXCH-15752 - AutoTag is true for following tab type
                  // if Age =0 and Trans date / Due date is greater then today. update tag amount to not due column.

                  {SS 06/01/2016 2017-R1:
	                 ABSEXCH-15752: Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date.
                  - if Age =0 and Trans date / Due date is greater or equal to today. update tag amount to not due column.}
                  if (Age=0)
                     and(((fTagMode = eTagModeTransactionDate) and (MtExLocal.LInv.TransDate >= DateTimeAsLongDate(Now)))
                       or ((fTagMode = eTagModeDueDate) and (MtExLocal.LInv.DueDate >= DateTimeAsLongDate(Now)))) then
                  begin
                    Age := 1;
                  end;

                  {SS 18/01/2016 2017-R1: ABSEXCH-15752: Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date.
                  - if Age =0 and Trans date / Due date is within the same month of today then update tag amount to not due column.}
                  if (Age = 0) and ((fTagMode = eTagModeTransactionDate) or (fTagMode = eTagModeDueDate))  then
                    Age := 1;


                  // Update the tagged amount against the Customer/Supplier
                  LMiscRecs^.BACSSRec.TotalTagged[0] := LMiscRecs^.BACSSRec.TotalTagged[0] + DocThen;
                  LMiscRecs^.BACSSRec.TotalTagged[Age] := LMiscRecs^.BACSSRec.TotalTagged[Age] + DocThen;


                  // CJS 2015-05-07 - v7.0.14 - PPD - Batch Paymt/Recpt - Build Process
                  // Applied PPD to recalculated amounts (DocThen already holds
                  // the correct value)

                  // Update the 'tagged' amounts on the Transaction
                  LInv.BatchThen := AdjustOutstandingForPPD(BaseTotalOS(EInv), PPDStatus); // Base currency
                  {$IFDEF MC_On}
                  LInv.BatchNow := AdjustOutstandingForPPD(CurrencyOS(EInv, BOff, BOff, BOff), PPDStatus); // In-currency
                  {$ENDIF}

                  // Update the total tagged amount on the control header
                  BatchCtrl.BACSCRec.TotalTag[0] := BatchCtrl.BACSCRec.TotalTag[0] + DocThen;
                end
                else
                begin
                  // PS 21/11/2016 2017 R1 ABSEXCH-15752 - Untag transaction if tag selected is not in following
                  //                    if Tag mode is other then Trans Date or Due date . untag it. 
                  if (fTagMode <> eTagModeTransactionDate) and (fTagMode <> eTagModeDueDate) then
                    Tagged:=0;
                end;

                UnTagged:=BOff;

              end;

              { CJS - 2012-07-19: ABSEXCH-12220 - Batch Payments - SQL Optimisation }
              {$IFDEF EXSQL}
              if SQLUtils.UsingSQLAlternateFuncs then
                UpdateTransaction(LInv)
              else
              {$ENDIF}
              begin
                LStatus:=LPut_Rec(Fnum,KeyPath);

                LReport_BError(Fnum,LStatus);

                LStatus:=LUnLockMLock(Fnum);
              end;

            end;

          end;

        end; {With..}

      end; {If Doc Ok..}

      If (Not ThreadRec^.THAbort) then
        {$IFDEF EXSQL}
        If SQLUtils.UsingSQLAlternateFuncs Then
        Begin
          { CJS - 2012-07-19: ABSEXCH-12220 - Batch Payments - SQL Optimisation }
          SQLCaller.Records.Next;
        End // If SQLUtils.UsingSQLAlternateFuncs
        Else
        {$ENDIF}
          LStatus:=GetExtCusALCid(ExtCustRec,CustAlObj,Fnum,Keypath,B_GetNext,1,KeyS2);
    end; {While..}

    if SQLUtils.UsingSQLAlternateFuncs then
      SQLCaller.Close;

    If (FoundOk) then
    Begin
      {SS 06/01/2016 2017-R1:
	    ABSEXCH-15752: Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date.
      - Set HasTagged status to true when Total Tagged is not zero.}
      if (fTagMode in [eTagModeTransactionDate,eTagModeDueDate]) then
      begin
        LMiscRecs^.BACSSRec.HasTagged[0] := LMiscRecs^.BACSSRec.TotalTagged[0] <>0;
      end;

      //SS:15/12/2017:2017-R1:ABSEXCH-19170:When wild tagging on more than 1 column, System appears to be untagging and retagging transactions.
      if not (fTagMode in [eTagModeTransactionDate,eTagModeDueDate]) then
      begin
        LStatus:=LAdd_Rec(BFnum,BKeyPath);

        LReport_BError(BFnum,LStatus);

        For n:=1 to NoBACSTOT do
        Begin
          BatchCtrl.BACSCRec.TotalTag[n]:=BatchCtrl.BACSCRec.TotalTag[n]+LMiscRecs^.BACSSRec.TotalOS[n];
        end;
      end else
      begin
        LStatus:=LPut_Rec(BFnum,BKeyPath);

        LReport_BError(BFnum,LStatus);
      end;



      With BatchCtrl.BACSCRec do
      Begin
        TagStatus:=BOn;

        Inc(TagCount);

        If (LastInv<EndInv) then
          LastInv:=EndInv;
      end; {With..}

      {* Update, but do not unlock *}
      BACS_CtrlPut(PWrdF,PWK,BatchCtrl,MTExLocal,2);
    end;
  end; {With..}
end; {Proc..}


{ == Function to Reset the Tagged trasactions. ====}

{SS 16/01/2016 2017-R1: ABSEXCH-15752: Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date.}

Procedure TScanBatch.ResetTaggedTrans(aCustSupp:Str255);

Const
  Fnum     =  InvF;
Var

  KeyS2,
  KeyChk      :  Str255;

  LOk,
  FoundOk,
  UseOsKey,
  Locked      :  Boolean;
  KeyPath     :  Integer;   


  function HasMoreRecords: Boolean;
  begin
    Result := (MTExLocal^.LStatusOk) and (CheckKey(KeyChk,KeyS2,Length(KeyChk),BOn));
  end;

  {SS 16/01/2016 2017-R1: ABSEXCH-15752: Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date.
  -SQL Optimisation }

  procedure UpdateTaggedStatus();
  var
    Qry: string;
  begin
    Qry := Format('UPDATE [COMPANY].DOCUMENT  ' +
                  'SET                        ' +
                  '  thTagged = 0,           ' +
                  '  thUntagged = 0          ' +
                  'WHERE                                  ' +
                  '      thTagged = 1                     ' +
                  '  AND thAcCode = ''%s''                ' +
                  '  AND thOutstanding = ''%s''           ' +
                  '  AND ((thCurrency = %d) OR (%d = 0))  ' +
                  '  AND thNomAuto = %d                   ' +
                  '  AND ((thOrderPaymentElement = %d) OR (thDocType <> %d)) ',
                  [
                    ExtCustRec^.FCusCode,
                    ExtCustRec^.FAlCode,
                    ExtCustRec^.FCr,
                    ExtCustRec^.FCr,
                    Ord(ExtCustRec^.FNomAuto),
                    Ord(opeNA),
                    Ord(SRC)
                  ]);


    SQLUtils.ExecSQL(Qry, SetDrive);
  end;

Begin
  Locked := BOff;


  UseOSKey := BatchCtrl.BacsCRec.UseOsNdx;

  If (UseOSKey) then
    KeyPath := InvOSK
  else
    KeyPath := InvCustK;

  FillChar(KeyChk, Sizeof(KeyChk), #0);
  FillChar(KeyS2, Sizeof(KeyS2), #0);

  With MTExLocal^ do
  Begin
    SetExtSearch;

    LStatus:=LFind_Rec(B_GetGEq,CustF,CustCodeK,aCustSupp);

    if LStatusOk then
    begin


      With LCust do
      Begin
        With ExtCustRec^ do
        Begin
          FCusCode:=CustCode;
          FCSCode:=CustSupp;
        end;

        {$IFNDEF EXSQL}
        If (UseOSKey) then
          KeyChk := TradeCode[BatchCtrl.BacsCRec.SalesMode] + FullCustCode(CustCode)
        else
          KeyChk := FullCustType(CustCode, CustSupp) + #1; { * Ignore Nom Ledger Items * }
        {$ENDIF}
      end;

      {$IFDEF EXSQL}
      if SQLUtils.UsingSQLAlternateFuncs Then
        UpdateTaggedStatus()
      else
      {$ENDIF}
      begin
        
        KeyS2 := KeyChk;

        LStatus := GetExtCusALCid(ExtCustRec, CustAlObj, Fnum, KeyPath, B_GetGEq, 1, KeyS2); // Effectively a GetGEq


        While HasMoreRecords and (Not ThreadRec^.THAbort) do
        begin
          With LInv do
          Begin
            if SQLUtils.UsingSQLAlternateFuncs then
              ReadRecord(MTExLocal^.LInv);

            if (Tagged = 1) then
            Begin

              LOk := LGetMultiRec(B_GetDirect, B_MultLock, KeyS2, KeyPath, Fnum, BOn, Locked);

              If (LOk) and (Locked) then
              Begin
                LGetRecAddr(Fnum);

                Tagged := 0;
                UnTagged := BOff;

                LStatus := LPut_Rec(Fnum, KeyPath);

                LReport_BError(Fnum, LStatus);

                LStatus := LUnLockMLock(Fnum);


              end; // If (LOk) and (Locked) then

            end; // if (Tagged = 1) then

          end; { With LInv do }

          If (Not ThreadRec^.THAbort) then
            LStatus := GetExtCusALCid(ExtCustRec, CustAlObj, Fnum, KeyPath, B_GetNext, 1, KeyS2);
        end; { While HasMoreRecords and (Not ThreadRec^.THAbort) do }

      end;

    end;  {if LStatusOk then}

    if SQLUtils.UsingSQLAlternateFuncs then
      SQLCaller.Close;
  end; { With.. }

end; { Proc.. }



{ == Function to determine if a supplier has any expired cert ==}

{!!!! Note this routine is replicated for non thread safe operation within JChkUseU & Replicated in AllocS2U !!!!}

Function TScanBatch.LCert_Expired(EmplCode  :  Str20;
                                  ViaSupp,
                                  ShowErr   :  Boolean)  :  Boolean;


Const
  Fnum     =  JMiscF;
  Keypath  =  JMTrdK;

Var
  KeyChk,
  KeyS       : Str255;

  LOk        : Boolean;


Begin
  Result:=BOff;  LOk:=BOff;

  KeyS:=''; KeyChk:='';

  With MTExLocal^ do
  Begin
    If (ViaSupp) then
    Begin
      KeyChk:=PartCCKey(JARCode,JASubAry[3])+FullCustCode(EmplCode);
      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not Result) and (Not ThreadRec^.THAbort) do
      With LJobMisc^,EmplRec do
      Begin
        Result:=LCert_Expired(EmpCode,BOff,ShowErr);

        If (Not Result) then
          LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);

      end;

    end
    else
    With LJobMisc^,EmplRec do
    Begin
      KeyS:=PartCCKey(JARCode,JASubAry[3])+FullEmpCode(EmplCode);

      If (EmplCode<>EmpCode) then
        LOk:=LCheckRecExsists(KeyS,Fnum,JMK)
      else
        LOk:=BOn;

      If (LOk) then
      Begin
        Result:=(CertExpiry<Today) and (Trim(CertExpiry)<>'') and (Etype=EmplSubCode) and (CISType<>4) and (Not CIS340) ;
      end;

    end;

  end; {With..}
end;




Procedure TScanBatch.SetExtSearch;

Begin
  With ExtCustRec^ do
  Begin

    FCr:=BatchCtrl.BACSCRec.InvCurr;

    FNomAuto:=BOn;

    FMode:=3;

    FAlCode:=TradeCode[BatchCtrl.BACSCRec.SalesMode];

    FCtrlNom:=BatchCtrl.BACSCRec.TagCtrlCode;


    FDirec:=BOn;

    FB_Func[BOff]:=B_GetPrev;
    FB_Func[BOn]:=B_GetNext;

    {$IFDEF FRM}
      If (BatchCtrl.BACSCRec.ShowLog) and (Assigned(PostLog)) then
        FLogPtr:=PostLog
      else
        FLogPtr:=nil;
    {$ELSE}
      FLogPtr:=nil;
    {$ENDIF}
  end;
end;




  Function TScanBatch.LBACSHook(HID     :  LongInt)  :  Boolean;


  Var
    NewObject  :  Boolean;

  Begin
    Result:=BOn;

    {$IFDEF CU}
      If (LHaveHookEvent(2050,HID,NewObject)) then
      Begin
        try
          Result:=LExecuteHookEvent(2050,HId,MTExLocal^);

        except
          Result:=BOn;
        end; {try..}
      end;
    {$ENDIF}
  end;

// CJS 2012-04-04: ABSEXCH-12545 - Batch Payment Tagging hook-points
function TScanBatch.LBACSHook2(HID: Integer): Boolean;
var
  NewObject: Boolean;
Begin
  Result := False;
  {$IFDEF CU}
  if (LHaveHookEvent(2050, HID, NewObject)) then
  begin
    try
      Result := LExecuteHookEvent(2050, HId, MTExLocal^);
    except
      Result := False;
    end;
  end;
  {$ENDIF}
end;

{ ======== Procedure to Scan All Accounts and Re-Calc Payment Screen ======= }


Procedure TScanBatch.BACS_Scan(BFnum,
                               BKeypath  :  Integer);


Const
  Fnum     =  CustF;
  KeyPath  =  CustCodeK;



Var
  IncCustom,
  BadEmpl     :  Boolean;
  KeyS,
  KeyChk      :  Str255;


  ItemCount,
  ItemTotal   :  LongInt;

  Sales,
  Purch,
  Cleared     :  Double;


Begin

  ItemCount:=0;

  BadEmpl:=BOff;  IncCustom:=BOff;

  Sales:=0;
  Purch:=0;
  Cleared:=0;

  With MTExLocal^ do
  Begin
    InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId));


    With BatchCtrl.BACSCRec do
    Begin
      //SS:15/12/2017:2017-R1:ABSEXCH-19170:When wild tagging on more than 1 column, System appears to be untagging and retagging transactions.
      //Batch transaction should not be deleted for Transaction Date and Due Date option.
      if (fTagMode <> eTagModeTransactionDate) and (fTagMode <> eTagModeDueDate) then
      begin
        Blank(TotalTag,Sizeof(TotalTag));

        TagCount:=0;

        TagStatus:=BOff;

        TagRunDate:=Today;
        TagRunYr:=GetLocalPr(0).CYr;
        TagRunPr:=GetLocalPr(0).CPr;

        TagAsDate:=Today;
        LastInv:=0;

        {Lock and leave locked}
        BACS_CtrlPut(PWrdF,PWK,BatchCtrl,MTExLocal,2);

        KeyS:=PartCCKey(MBACSCode,MBACSSub)+FullNomKey(TagRunNo);

        LDeleteLinks(KeyS,BFnum,Length(KeyS),BKeyPath,BOff);
      end;
    end;

    If (BatchCtrl.BACSCRec.ShowLog) then
      Write_PostLog('',BOff); {Initialise the exceptions log}


    SetExtSearch;

    KeyS:='';

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    While (LStatusOk) and (Not ThreadRec^.THAbort) do
    With LCust do
    Begin
      // CJS 2013-11-28 - MRD1.1 - Consumers - exclude Consumers from Batch
      if acSubType <> 'U' then
      begin             

      {$IFDEF PF_On}
        {$B-}
        { CJS - 2012-07-23: ABSEXCH-12220 - Batch Payments - Optimisation }
        { Only perform the check for expired CIS Certificates if CIS is in use
          and if we are NOT using the new CIS340 rules. For all other cases,
          assume that the employee certificate is valid (or irrelevant) }
        if (CISOn and not CIS340) then
          BadEmpl:=((JBCostOn) and (Not BatchCtrl.BACSCRec.SalesMode) and (LCert_Expired(CustCode,BOn,BOff)))
        else
          BadEmpl := False;
        {$B+}

      {$ENDIF}

      If (AcSubType=TradeCode[BatchCtrl.BACSCRec.SalesMode]) and (PayType=BatchCtrl.BACSCRec.PayType) and (Not BadEmpl) then
      Begin
        IncCustom:=LBACSHook(172+Ord(BatchCtrl.BACSCRec.SalesMode));

        If (IncCustom) then
        Begin
          ShowStatus(1,'Processing '+dbFormatName(CustCode,Company));



          Balance:=LProfit_to_Date(CustHistCde,CustCode,0,150,Syss.PrinYr,Sales,Purch,Cleared,BOn);

          With BatchCtrl.BACSCRec do
            If ((Balance<0) and (Not SalesMode)) or ((Balance>0) and (SalesMode)) or (((PayType=BACS2Code) or (PayType=BACS3Code)) and (Balance<>0.0)) then
            Begin

              With ExtCustRec^ do
              Begin

                FCusCode:=CustCode;
                FCSCode:=CustSupp;

              end;

              BACS_CalcDoc(BFnum,BKeypath,fTagDate);

            end; {* If Amount OS..}
            {else Too many possible entries here
              Write_PostLog('Account '+dbFormatName(CustCode,Company)+' excluded as is has a zero balance.',BOn);}
        end {If Custom..}
        else
        Begin
          {$IFDEF FRM}

            Write_PostLogDD('Account '+dbFormatName(CustCode,Company)+' excluded as an external plug-in has rejected it',BOn,CustCode,1)
          {$ENDIF}

        end;

      end {If Supplier & Right Type}
      else
      Begin
        {$IFDEF FRM}
            If (BadEmpl) and (BatchCtrl.BACSCRec.ShowLog) and (Assigned(PostLog)) then
            Begin
              Write_PostLogDD('Supplier '+dbFormatName(CustCode,Company)+' excluded as one of the employee sub contract certificates has expired.',BOn,CustCode,1);
            end;

        If (CustSupp=TradeCode[BatchCtrl.BACSCRec.SalesMode]) and (PayType<>BatchCtrl.BACSCRec.PayType) and (BatchCtrl.BACSCRec.ShowLog) and (Assigned(PostLog)) then
          Write_PostLogDD('Account '+dbFormatName(CustCode,Company)+' excluded as the payment type does not match the type requested for this run.',BOn,CustCode,1);
        {$ENDIF}

      end;

      end; { if acSubType <> 'U'... }

      Inc(ItemCount);

      UpdateProgress(ItemCount);

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

    end; {While..}


    {unLock Totals}
    BACS_CtrlPut(PWrdF,PWK,BatchCtrl,MTExLocal,0);


  end; {With..}
end; {Proc..}





  Procedure TScanBatch.Process;

  Begin
    InMainThread:=BOn;

    Inherited Process;

    ShowStatus(0,'Batch '+BatchPTit(BatchCtrl.BACSCRec.SalesMode)+' Update');

    With MTExLocal^ do
    Begin

      CustAlObj.MTExLocal := MTExLocal;

      If (Not Scan1Mode) and (not ScanBatchTransMode) and (HookOk) then
        BACS_Scan(MiscF,MIK);
    end;

  end;


  Procedure TScanBatch.Finish;
  Begin
    Inherited Finish;

    {$IFDEF Rp}
      {$IFDEF FRM}
        If (Assigned(PostLog)) then
          PostLog.PrintLog(PostRepCtrl,'Batch '+BatchPTit(BatchCtrl.BACSCRec.SalesMode)+' omissions and exception log.');

      {$ENDIF}
    {$ENDIF}


    {Overridable method}

    InMainThread:=BOff;

    {* Inform input window batch has been calculated *}

    SendMessage(CallBackH,WM_CustGetRec,55,0);

    // Also post a message to the main form, in case the eRCT Gateway needs to
    // know
    PostMessage(Application.MainForm.Handle, WM_THREADFINISHED, PID_BACS_SCAN_FINISHED, 0);

  end;



  Function TScanBatch.Start(BCtrl    :  PassWordRec;
                            InpWinH  :  THandle)  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Result:=BOn; 

    Begin
      If (Not Assigned(MTExLocal)) then { Open up files here }
      Begin
      {$IFDEF EXSQL}
      if SQLUtils.UsingSQL then
      begin
        // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
        if (not Assigned(LPostLocal)) then
          Result := Create_LocalThreadFiles;

        If (Result) then
          MTExLocal := LPostLocal;

      end
      else
     {$ENDIF}
        New(MTExLocal,Create(15));

        try
          With MTExLocal^ do
          Begin
            Open_System(CustF,JMiscF);

            {$IFDEF CU}
              HookOk:=LBACSHook(170+Ord(BCtrl.BACSCRec.SalesMode));
            {$ENDIF}
          end;

        except
          Dispose(MTExLocal,Destroy);
          MTExLocal:=nil;

        end; {Except}

        Result:=Assigned(MTExLocal);
      end;
      If (Result) then
      Begin
        BatchCtrl:=BCtrl;
        CallBackH:=InpWinH;
      end;
    end;
    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      MTExLocal^.Close_Files;
      CloseClientIdSession(MTExLocal^.ExClientID, False);
    end;
    {$ENDIF}

  end;

{ ============== }

Procedure AddTransScan2Thread(AOwner    : TObject;
                              BCtrl     : PassWordRec;
                              MyHandle  : THandle;
                              aCustSupp : Str255);
  Var
    LCheck_Trans :  ^TScanBatchTrans;
begin
  If (Create_BackThread) then
  Begin
    New(LCheck_Trans,Create(AOwner));

    try
      With LCheck_Trans^ do
      Begin
        If (Start(BCtrl,MyHandle)) and (Create_BackThread) then
        Begin
          fCustSupp := aCustSupp;
          With BackThread do
            AddTask(LCheck_Trans,'Untag Transaction');
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(LCheck_Trans,Destroy);
        end;
      end; {with..}

    except
      Dispose(LCheck_Trans,Destroy);

    end; {try..}
  end; {If process got ok..}
end;



// PS 26/10/2016 2017 R1 ABSEXCH-15752 - Added two parameter
Procedure AddBACSScan2Thread(AOwner   :  TObject;
                             BCtrl    :  PassWordRec;
                             MyHandle :  THandle;
                             ATagDate :  LongDate='';
                             ATagMode :  TransactionTagMode=eTagDoNothing);


  Var
    LCheck_Batch :  ^TScanBatch;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Batch,Create(AOwner));

      try
        With LCheck_Batch^ do
        Begin
          // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date
          fTagDate := ATagDate;
          fTagMode := ATagMode;
          If (Start(BCtrl,MyHandle)) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LCheck_Batch,'Batch PPY/SRC');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Batch,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Batch,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;


  { ========== TScan1Batch methods =========== }

  Constructor TScan1Batch.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    Scan1Mode:=BOn;

  end;

  Procedure TScan1Batch.Process;

  Var
    Sales,
    Purch,
    Cleared     :  Double;

  Begin
    Inherited Process;

    With MTExLocal^,BatchCtrl.BACSCRec do
    If (LGetMainRec(CustF,Spare3K)) then
    With LCust do
    Begin
      ShowStatus(0,'Batch '+dbFormatName(CustCode,Company)+' Update');

      {Lock and leave locked}
      BACS_CtrlPut(PWrdF,PWK,BatchCtrl,MTExLocal,2);

      SetExtSearch;

      Balance:=LProfit_to_Date(CustHistCde,CustCode,0,150,Syss.PrinYr,Sales,Purch,Cleared,BOn);

      With ExtCustRec^ do
      Begin

        FCusCode:=CustCode;
        FCSCode:=CustSupp;

      end;


      BACS_CalcDoc(MiscF,MIK);

      {unLock Totals}
      BACS_CtrlPut(PWrdF,PWK,BatchCtrl,MTExLocal,0);

    end;

  end;

  // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Added two parameter
  Procedure AddAccScan2Thread(AOwner   :  TObject;
                              BCtrl    :  PassWordRec;
                              MyHandle :  THandle;
                              ATagDate :  LongDate='';
                              ATagMode :  TransactionTagMode=eTagDoNothing);


  Var
    LCheck_Batch :  ^TScan1Batch;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Batch,Create(AOwner));

      try
        With LCheck_Batch^ do
        Begin
          // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date
          fTagDate := ATagDate;
          fTagMode := ATagMode;
          If (Start(BCtrl,MyHandle)) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LCheck_Batch,'Batch PPY/SRC');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Batch,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Batch,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;



{$ENDIF}


Procedure  TBatchPay.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TBatchPay.Find_FormCoord;
begin
  //GS: 05/04/11 ABSEXCH-10804 changed the load form settings code to use the new IWindowSettings interface object
  //populate the object with setting data stored in the database
  WindowSettings.LoadSettings;
  //extract the form settings and apply them to the given form object
  WindowSettings.SettingsToWindow(self);
  //extract the multi list settings and apply them to the multi control object
  WindowSettings.SettingsToParent(MULCtrlO);
  //'SettingsToWindow' resizing the form with non default coords will trigger the FormResize event, inadvertently
  //making 'NeedCUpdate' true, so, force 'need coordinate update' to false, we only want it true when the user resizes the form
  fNeedCUpdate := False;
  //record the new form dimensions that 'SettingsToWindow' has just loaded
  //so the program can determine if the form has been resized or not
  StartSize.X := Self.Width;
  StartSize.Y := Self.Height;
end;//end Find_FormCoord

procedure TBatchPay.Store_FormCoord;
begin
  //GS: 05/05/11 ABSEXCH-10804 changed old 'store form settings' code to use the new IWindowSettings interface object
  //load the form, and the multi list controls settings into the IWindowSettings object
  WindowSettings.WindowToSettings(self);
  WindowSettings.ParentToSettings(MULCtrlO,MULCtrlO);
  //store the settings inside the database; coordinate settings
  //are saved if the user selected the 'save' popup menu command
  WindowSettings.SaveSettings(StoreCoord);
end;//end Store_FormCoord

procedure TBatchPay.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(CBtnPanel.Left);
  PagePoint[0].Y:=ClientHeight-(CBtnPanel.Height);

  PagePoint[1].X:=ClientWidth-(CSBox.Width);
  PagePoint[1].Y:=ClientHeight-(CSBox.Height);

  PagePoint[3].X:=CBtnPanel.Height-(CCBSBox.Height);
  PagePoint[3].Y:=CSBox.ClientHeight-(CLORefPanel.Height);

  PagePoint[4].Y:=CBtnPanel.Height-(CListBtnPanel.Height);

  GotCoord:=BOn;

end;


procedure TBatchPay.Link2Tot;

Var
  n    :  Byte;
  COrd : Integer;

Begin

  {$B-} {If we are the only logged in user don't refresh record}
//  If (BatchCtrl.BACSCRec.LIUCount<=1) or (Refresh_BACSCtrl(BatchCtrl)) then
  If (Refresh_BACSCtrl(BatchCtrl)) then
  {$B+}
  With BatchCtrl.BACSCRec do
  Begin
    With MiscRecs^.BACSSRec do
    If (ExLocal.LCust.CustCode<>TagCustCode) then
    Begin
      Global_GetMainRec(CustF,TagCustCode);

      ExLocal.AssignFromGlobal(CustF);

      CompF.Text:=ExLocal.LCust.Company;
    end;

    For n:=Low(BPTots) to High(BPTots) do
    With MULCtrlO.VisiList do
    Begin
      COrd:=Pred(FindxColOrder(n+1));

      If (COrd>=0) then
      With BPTots[COrd] do
      Begin
        {$IFDEF MC_On}
          CurrencySymb:=SSymb(PayCurr);
        {$ELSE}
          ShowCurrency:=BOff;

        {$ENDIF}

        Value:=BatchDocSign(SalesMode,TotalTag[n]);
      end;
    end;

    {$IFDEF MC_On}
      CBalF.CurrencySymb:=SSymb(0);
    {$ELSE}
      CBalF.ShowCurrency:=BOff;

    {$ENDIF}

    With MiscRecs^.BACSSRec do
      CBalF.Value:=BatchDocSign(SalesCust,TagBal);

  end; {With..}
end;


Procedure TBatchPay.SetButtons(State  :  Boolean);

Var
  n  :  Byte;

Begin
  For n:=Low(BPBtns) to High(BPBtns) do
    BPBtns[n].Enabled:=State;

  If (State) then
    FindCP1Btn.Enabled:=ChkAllowed_In(155) and (ICEDFM=0);

  Process1.Enabled:=FindCP1Btn.Enabled;

end;


procedure TBatchPay.Show_ItemList(ScanMode  :  Boolean);

Var
  WasNew  :  Boolean;

  ThisCol :  SmallInt;

  TagStatus
          :  Boolean;

Begin
  WasNew:=BOff;

  Set_BIFormMode(RecMode);

  ExLocal.LGetRecAddr(MiscF);  {* Refresh record address *}

  ThisCol:=Self.MULCtrlO.SelectCol^.CurrentCol.Tag;

  Case ThisCol of
    // CJS 2015-05-26 - v7.0.14 - PPD - T2-157 - Trader PPD Column (6)
    0,1,6  :  TagStatus:=MiscRecs^.BACSSRec.HasTagged[0];
    else    TagStatus:=MiscRecs^.BACSSRec.HasTagged[Pred(ThisCol)];
  end; {Case..}

  If (Not Assigned(BItemList)) then
  Begin
    BItemList:=TBatchItems.Create(Self);
    WasNew:=BOn;
  end;


  try

    With BItemList do
    If (WasNew) or (ExLocal.LCust.CustCode<>Cust.CustCode) or (MULCtrlO.CurrCol<>ThisCol) then
    With MulCtrlO do
    Begin

      BatchCtrl:=Self.BatchCtrl;

      With MiscRecs^.BACSSRec do
        If (Cust.CustCode<>TagCustCode) then
          Global_GetMainRec(CustF,TagCustCode);

      CCode:=Cust.CustCode;

      ExLocal.LCust:=Cust;
      CurrCol:=ThisCol;

      ExLocal.LastRecAddr[MiscF]:=Self.ExLocal.LastRecAddr[MiscF];  {* Refresh record address *}

      Case CurrCol of
        0,1,6  :  DDownTitle:='All O/S transactions';
            2  :  DDownTitle:='Not Due';
        else     DDownTitle:=AgeBACSTit[ThisCol-2];
      end;

      TaggedByAccount := TagStatus;

      SetCaption;

      RefreshList(BOn,BOn);

    end
    else
      Show;
  except
    BItemList.Free;
    BItemList:=Nil;
  end;

end;


Procedure TBatchPay.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin
              If (WParam In [169]) then
                MULCtrlO.GetSelRec(BOff);

              {$B-}
              If (WParam = 169) or (MulCtrlO.ValidLine) then
              {$B+}
                Show_ItemList(BOff);

            end;

      1  :  Begin
              {If (BeenIn) and (MULCtrlO.Link2Inv) then
              Begin
                Send_UpdateList(65);
              end;}


               Link2Tot;

              If (Assigned(BItemList)) and (Not InMsg71) then
                Show_ItemList(BOn);
            end;


      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      25 :  NeedCUpdate:=BOn;

      55 :  Begin
              Enabled:=BOn;

              Self.BringtoFront;

              If (Assigned(BItemList)) then
                BItemList.Enabled:=BOn;

              SetButtons(BOn);

              BACS_CtrlGet(PWrdF,PWK,BatchCtrl,RecMode,nil);

              if WTagMode in [eTagModeTransactionDate,eTagModeDueDate] then
              begin
                Link2Tot;// PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date
              end;

              If (Scan1Acc) then
              Begin
                Scan1Acc:=BOff;

                With MULCtrlO do
                Begin
                  If (MUListBox1.Row<>0) then
                    PageUpDn(0,BOn)
                   else
                     InitPage;
                end;

                Link2Tot;
              end
              else
                RefreshList(BOn,BOn);

            end;

      56 :  Begin
              SendMessage(Self.Handle,WM_Close,0,0);

            end;

      70 :  Begin
              BItemList:=Nil;
            end;

      71 :  Begin
              InMsg71:=BOn;

              If (Assigned(BItemList)) then
              With BItemList,ExLocal do
              Begin
                LSetDataRecOfs(MiscF,LastRecAddr[MiscF]); {* Retrieve record by address Preserve position *}

                Status:=GetDirect(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK,0); {* Re-Establish Position *}

                AssignToGlobal(MiscF);

                Set_TaggedStat(eTagMode2Week,99,MiscF,MIK,BOn);   //TagMode 4  // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date
              end;

              With MULCtrlO do
                AddNewRow(MUListBoxes[0].Row,BOn);

              Link2Tot;      // PS 24/11/2016 2017 R1 ABSEXCH-15752 - Updating Total
              InMsg71:=BOff;
            end;

       77,78
          :  If (Assigned(BItemList)) then
             Begin
               If (WPAram=77) then
                 BItemList.MULCtrlO.BatchCtrl:=BatchCtrl
               else
               Begin
                 BatchCtrl:=BItemList.MULCtrlO.BatchCtrl;
                 Link2Tot;
               end;

             end;

      116
          :  Begin
               With MULCtrlO do
               Begin
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));
               end;
            end;

      117 :  With MULCtrlO do
             Begin
               If (MUListBox1.Row<>0) then
                 PageUpDn(0,BOn)
                else
                  InitPage;
             end;

  {$IFDEF GF}

    3000..3002  //PR: 05/12/2013 ABSEXCH-14824 Extend range
          : If (Assigned(FindCust)) then
              With MULCtrlO,FindCust,ReturnCtrl do
              Begin
                InFindLoop:=BOn;

                Case ActiveFindPage of
                  0..2  :  Find_CustOnList(RecMainKey);
                end; {Case..}

                InFindLoop:=BOff;
              end;

   {$ENDIF}




    end; {Case..}

  end;
  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TBatchPay.Send_UpdateList(Mode   :  Integer);

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
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


Procedure TBatchPay.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

Begin

  With Message.MinMaxInfo^ do
  Begin

    ptMinTrackSize.X:=200;
    ptMinTrackSize.Y:=210;

    {ptMaxSize.X:=ClientWidth;
    ptMaxSize.Y:=ClientHeight;

    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}

  end;

  Message.Result:=0;

  Inherited;

end;

procedure TBatchPay.SetCaption;

Var
  LevelStr  :  Str255;

Begin

  Caption := 'Batch '+BatchPTit(RecMode)+' List ';
  Caption := Caption + 'as at ' + POutDate(Password.BACSCRec.TagAsDate) + '. ';
  Caption := Caption + 'Run No. : '+Form_Int(ThisRunNo,0);

end;



procedure TBatchPay.FormDesign;


begin


end;





procedure TBatchPay.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeypath,
  LKeyLen     :  Integer;

Begin

  KeyStart:=PartCCKey(MBACSCode,MBACSSub)+FullNomKey(BatchCtrl.BACSCRec.TagRunNo);

  LKeyLen:=Length(KeyStart);

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    InitSelectCol;

    StartList(MiscF,MIK,KeyStart,'','',LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;


procedure TBatchPay.SetListLabels;


Begin
  With BatchCtrl.BACSCRec do
  Begin
    Set_AgedStr(AgeBACSTit,3,AgeType,AgeInt);

    CLOSLab.Caption:=AgeBACSTit[1];
    CLTotLab.Caption:=AgeBACSTit[2];
    CLOrigLab.Caption:=AgeBACSTit[3];

    Wk1.Caption:='&'+AgeBACSTit[1];
    Wk2.Caption:='&'+AgeBACSTit[2];
    Wk3.Caption:='&'+AgeBACSTit[3];

    CreateSubMenu(PopUpMenu2,WildTag1);
    CreateSubMenuSuffix(PopUpMenu2,Clear1,'Y',BOff);

    CreateSubMenu(PopUpMenu3,ReCalc1);
  end;
end;

procedure TBatchPay.FormBuildList(ShowLines  :  Boolean);
Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;
Begin
  MULCtrlO:=TBPMList.Create(Self);
  StartPanel := nil;
  Try

    With MULCtrlO do
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
          AddVisiRec(pnlTraderPPD, lblTraderPPD);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=CHedPanel;

          ListOfSet:=10;

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
      MUTotCols:=6;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      ChooseXCol:=BOn;
      CXColNo:=3;

      WM_ListGetRec:=WM_CustGetRec;

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;
      //SS:15/12/2017:2017-R1:ABSEXCH-19170:When wild tagging on more than 1 column, System appears to be untagging and retagging transactions.
      //Added begin..end 
      For n:=0 to MUTotCols do
      begin
        With ColAppear^[n] do
        Begin
          AltDefault:=BOn;

          // CJS 2015-05-08 - v7.0.14 - PPD - T2-157 - PPD Column
          If (n>0) and (n<6) then
          Begin
            DispFormat:=SGFloat;
            NoDecPlaces:=2;
          end;
        end;
      end;


      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOff;

      NoUpCaseCheck:=BOn;

      HighLiteStyle[1]:=[fsBold];

      Set_Buttons(CListBtnPanel);

      ReFreshList(ShowLines,BOff);

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;

  FormSetOfSet;
  Find_FormCoord;
  FormReSize(Self);

  {RefreshList(BOn,BOn);}

end;


procedure TBatchPay.FormCreate(Sender: TObject);

Var
  n  :  Integer;

  TheCaption
     :  ShortString;

begin

  //GS: 05/05/11 ABSEXCH-10804 get an instance of the IWindowSettings interface object, used for storing the forms settings
  WindowSettings := EntWindowSettings.GetWindowSettings(self.Name);

  fFrmClosing:=BOff;
  fDoingClose:=BOff;
  ExLocal.Create;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;

  JustCreated:=BOn;

  InitSize.Y:=374;
  InitSize.X:=728;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=244;
  Width:=370;}

  WTagMode:=eTagDoNothing; // 0 // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date
  TagClearMode:=BOff;

  BeenIn:=BOff;

  RecMode:=BPFormMode;

  ThisRunNo:=BPRunNo;

  InMsg71:=BOff;

  Scan1Acc:=BOff;


  SetCaption;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;


  {CCDepRec:=nil;}

  BPTots[0]:=TagTot;
  BPTots[1]:=NDTot;
  BPTots[2]:=M1Tot;
  BPTots[3]:=M2Tot;
  BPTots[4]:=M3Tot;

  BPBtns[0]:=ClsCP1Btn;
  BPBtns[1]:=AddCP1Btn;
  BPBtns[2]:=EditCP1Btn;
  BPBtns[3]:=InsCP3Btn;
  BPBtns[4]:=DelCP1Btn;
  BPBtns[5]:=FindCP1Btn;
  BPBtns[6]:=HistCP1Btn;
  BPBtns[7]:=GenCP3Btn;
  BPBtns[8]:=ClsCP1Btn;
  BPBtns[9]:=BPCustBtn1;


  {$IFDEF CU}
    BPBtns[9].Visible:=EnableCustBtns(1000,25-(10*Ord(RecMode)));

    If (BPBtns[9].Visible) then
    Begin
      EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, 25-(10*Ord(RecMode)), TheCaption, BPBtns[9].Font);

      BPBtns[9].Caption:=TheCaption;
    end;

  {$ELSE}
    BPBtns[9].Visible:=BOff;

  {$ENDIF}

  Custom1.Visible:=BPBtns[9].Visible;

  SetButtons(BOn);

  FormDesign;

  FillChar(AgeBACSTit,Sizeof(AgeBACSTit),0);

  FormBuildList(BOff);

  SetHelpContextIDs; // NF: 20/06/06 Fix for incorrect Context IDs
end;



procedure TBatchPay.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;


end;

procedure TBatchPay.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n  : Integer;

begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try
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
        Store_FormCoord;

      {* Remove user *}
      BACS_UsrUnLock(MyUsrAddr,MyUsrNo,RecMode,BOn);

      {Update logged in user count}
      BACS_CtrlPut(PWrdF,PWK,BatchCtrl,nil,1);

      Dec(BatchCtrl.BACSCRec.LIUCount);

      {Lock Totals}
      BACS_CtrlPut(PWrdF,PWK,BatchCtrl,nil,0);


      Send_UpdateList(70+Ord(RecMode));
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;


end;

procedure TBatchPay.FormClose(Sender: TObject; var Action: TCloseAction);
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
        //GS: 05/05/11 ABSEXCH-10804 Dereference IWindowSettings interface object
        WindowSettings := NIL;
      end;
    end;

  end;
end;


procedure TBatchPay.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) then
  Begin

    CBtnPanel.Left:=ClientWidth-PagePoint[0].X;

    CBtnPanel.Height:=ClientHeight-PagePoint[0].Y;


    CSBox.Width:=ClientWidth-PagePoint[1].X;
    CSBox.Height:=ClientHeight-PagePoint[1].Y;

    CCBSBox.Height:=CBtnPanel.Height-PagePoint[3].X;

    CListBtnPanel.Height:=CBtnPanel.Height-PagePoint[4].Y;
    CListBtnPanel.Left:=Pred(CBtnPanel.Left-CListBtnPanel.Width);

    Bevel1.Width:=SBSPanel1.Width-2;

    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=CSBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      LockWindowUpDate(0);

      MULCtrlO.ReFresh_Buttons;
      MULCtrlO.LinkOtherDisp:=BOn;
    end;{Loop..}

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;





procedure TBatchPay.SetFormProperties;


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


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Caption+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin

          For n:=1 to 3 do
            With TmpPanel[n] do
              Case n of
                1,2  :  MULCtrlO.ReColorCol(Font,Color,(n=2));

                3    :  MULCtrlO.ReColorBar(Font,Color);
              end; {Case..}

          MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
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

procedure TBatchPay.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure TBatchPay.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;
  
  Custom1.Caption:=BpCustBtn1.Caption;
end;



procedure TBatchPay.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TBatchPay.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;





procedure TBatchPay.ClsCP1BtnClick(Sender: TObject);
begin
  {$B-}
  If (Not Assigned(MULCtrlO)) or (Not MULCtrlO.InListFind)  then
  {$B+}
    Close;
end;


procedure TBatchPay.CLORefPanelMouseUp(Sender: TObject;
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

    BarPos:=CSBox.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);

    If (NeedCUpdate) then
      Link2Tot;
  end;

end;


procedure TBatchPay.CLORefLabMouseMove(Sender: TObject; Shift: TShiftState;
                                               X, Y: Integer);
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


procedure TBatchPay.CLORefLabMouseDown(Sender: TObject;
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




procedure TBatchPay.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO))  then
    MULCtrlO.SetListFocus;

end;


{ ===== Procedure to Update Tagged Status ===== }

Procedure TBatchPay.Set_TaggedStat(TagNo   :  TransactionTagMode;
                                   Toggle  :  Byte;
                                   Fnum,
                                   Keypath :  Integer;
                                   Update  :  Boolean;
                                   CallFromList:Boolean);



Var
  N,Ns,Ne  :  Byte;

  OldTag   :  Double;  // PS 21/11/2016 2017 R1 ABSEXCH-15752 - Changed Real to Double to avoid exception

  LOk,
  Locked   :  Boolean;

  LAddr    :  LongInt;

  KeyS     :  Str255;

  
Begin

  LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked,LAddr);

  If (LOk) and (Locked) then
  Begin

    With MiscRecs^.BACSSRec do
    Begin

      OldTag:=TotalTagged[0];

      // CJS 2015-05-08 - v7.0.14 - PPD - T2-157 - PPD Column
      // If the PPD Column is selected when tagging, treat it as if the
      // first column was selected (so that it tags the whole row).
      // PS 26/10/2016 2017 R1 ABSEXCH-15752 - changes code from smallint to enumerator
      if (Ord(TagNo) - 1) > NOBACSTOT then
        TagNo := eTagDoNothing; //0

      If (Ord(TagNo)<=1) then
      Begin

        Ns:=1; Ne:=NOBACSTot;

        If (Ord(TagNo)=-1) then {* Ignore Not Due *}
          Ns:=2;

      end
      else
      Begin

        Ns:=Pred(Ord(TagNo)); Ne:=Ns;

      end;

      For N:=Ns to Ne do
      Begin

        Case Toggle of

          0  :  HasTagged[N]:=Not HasTagged[N];
          1,2
             :  HasTagged[N]:=(Toggle=1);

        end;

      end; {Loop..}

      TotalTagged[0]:=0;


      {SS 11/01/2016 2017-R1: ABSEXCH-15752: Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date.}

      //SS:15/12/2017:2017-R1:ABSEXCH-19170:When wild tagging on more than 1 column, System appears to be untagging and retagging transactions.
      // As we are not deleting the batch transaction for  Transaction Date or Due Date so TotalTagged array  should not be reset.
     { if CallFromList then
      begin
        for N:=1 to NOBACSTot do
        begin
          TotalTagged[N] := 0;
        end;
      end;
      }

      For N:=1 to NOBACSTot do
      Begin
        If (HasTagged[N]) then
          TotalTagged[0]:=TotalTagged[0]+TotalOS[N] - TotalEx[N]
        else
          TotalTagged[0]:=TotalTagged[0]+TotalTagged[N];
      end;

      If (Toggle<>99) then
        HasTagged[0]:=(TotalTagged[0]<>0);      


      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);


      If (UpDate) then {Lock totals}
        BACS_CtrlPut(PWrdF,PWK,BatchCtrl,nil,1);


      With BatchCtrl.BACSCRec do
        TotalTag[0]:=Round_Up(TotalTag[0]-OldTag+TotalTagged[0],2);


      If (UpDate) then
        BACS_CtrlPut(PWrdF,PWK,BatchCtrl,nil,0);

    end; {With..}
  end; {If Locked..}
end; {Proc..}



{ ======== Procedure to Scan All Payment Records and mass Tag.Untag ======= }


Procedure TBatchPay.BACS_WildTag(TagNo     :  TransactionTagMode;
                                 Toggle    :  Byte;
                                 Fnum,
                                 Keypath   :  Integer;
                                 MainK     :  Str255);
Var
  KeyS,
  KeyChk     :  Str255;

  NoAbort    :  Boolean;
  mbRet      :  TModalResult;

  MsgForm    :  TForm;
  sTitleBarCaption : string ;
Begin
  KeyChk:=MainK;

  KeyS:=KeyChk;

  Set_BackThreadMVisible(BOn);

  FDateValue:=DateTimeAsLongDate(Now);

  if Toggle = 1 then
  begin
    if TagNo in [eTagModeTransactionDate,eTagModeDueDate] then
    begin
      sTitleBarCaption := 'Tag transactions ';
      if TagNo = eTagModeTransactionDate then
        sTitleBarCaption := sTitleBarCaption + 'on Transaction Date'
      else if TagNo = eTagModeDueDate then
        sTitleBarCaption := sTitleBarCaption + 'on Due Date';

      if InputQueryEx(sTitleBarCaption, 'Tag all transactions up to:',FDateValue) then
      begin
        FDateValue := copy(FDateValue, 5, 4) + copy(FDateValue, 3, 2) + copy(FDateValue, 1, 2);
        ReCalcAllAccs;  {Recalc all transaction }
      end;

      Exit;
    end;
    MsgForm:=CreateMessageDialog('Please wait... Tagging.',mtInformation,[mbAbort]);
  end
  else
  begin
    MsgForm:=CreateMessageDialog('Please wait... Clearing Tag.',mtInformation,[mbAbort]);
  end;

  MsgForm.Show;
  MsgForm.Update;

  NoAbort:=BOn;
  
  {Lock Totals}
  BACS_CtrlPut(PWrdF,PWK,BatchCtrl,nil,1);

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (NoAbort) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  Begin

    Application.ProcessMessages;

    {SS 16/01/2016 2017-R1: ABSEXCH-15752: Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date.
     - Reset tagged trasactions.}
   //SS:15/12/2017:2017-R1:ABSEXCH-19170:When wild tagging on more than 1 column, System appears to be untagging and retagging transactions.
   { if (MiscRecs^.BACSSRec.TotalTagged[0] <> 0) and (not(TagNo in [eTagModeTransactionDate,eTagModeDueDate])) then
      AddTransScan2Thread(Application.MainForm,Self.BatchCtrl,Self.Handle,MiscRecs^.BACSSRec.TagCustCode);
    }
    Set_TaggedStat(TagNo,Toggle,Fnum,Keypath,BOff,True);

    mbRet:=MsgForm.ModalResult;
    Loop_CheckKey(NoAbort,mbRet);
    MsgForm.ModalResult:=mbRet;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}


  BACS_CtrlPut(PWrdF,PWK,BatchCtrl,Nil,0);

  MsgForm.Free;

  Set_BackThreadMVisible(BOff);


end; {Proc..}




procedure TBatchPay.AddCP1BtnClick(Sender: TObject);

Var
  TMode  :  Byte;
begin
  TMode:=0;
  If (Sender is TButton) then
    TMode:=TButton(Sender).Tag
  else
    If (Sender is TMenuItem) then
      TMode:=TMenuItem(Sender).Tag;


  If (TMode<>0) then
  With MULCtrlO do
  If (Not InListFind) then
  Begin
    Case TMode of
      1,2   :  If (ValidLine) then
               Begin
                 GetSelRec(BOff);

                 {SS 16/01/2016 2017-R1: ABSEXCH-15752: Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date.
                 - Reset tagged trasactions.}

                 //SS:15/12/2017:2017-R1:ABSEXCH-19170:When wild tagging on more than 1 column, System appears to be untagging and retagging transactions.
                { if (MiscRecs^.BACSSRec.TotalTagged[0] <> 0) then
                   AddTransScan2Thread(Application.MainForm,Self.BatchCtrl,Self.Handle,MiscRecs^.BACSSRec.TagCustCode);
                }   
                 Set_TaggedStat(TransactionTagMode(SelectCol^.CurrentCol.Tag),TMode,ScanFileNum,Keypath,BOn,True);
                 AddNewRow(MUListBoxes[0].Row,BOn);

               end;

      4,5   : Begin
                BACS_WildTag(WTagMode,(TMode-3),ScanFileNum,Keypath,KeyRef);
                PageUpDn(0,BOn);
              end;
    end; {Case..}
    // PS 23/11/2016 2017 R1 ABSEXCH-15752 - Only update total non  eTagModeTransactionDate or eTagModeDueDate
    //                                       For eTagModeTransactionDate or eTagModeDueDate total will be link after running thread
    if (WTagMode <> eTagModeTransactionDate) and (WTagMode <> eTagModeDueDate) then
    begin
      Link2Tot;
    end;
  end;
end;

procedure TBatchPay.InsCP3BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  With MULCtrlO do
  Begin
    If (Not InListFind) then
    Begin

       With TWinControl(Sender) do
       Begin
         ListPoint.X:=1;
         ListPoint.Y:=1;

         ListPoint:=ClientToScreen(ListPoint);

       end;
       // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date       
       If (Sender is TButton) then
       Begin
         if TButton(Sender).Tag = 5 then
         begin
           mniTransactionDate.Visible := False;
           mniDueDate.Visible := False;
         end
         else
         begin
           mniTransactionDate.Visible := True;
           mniDueDate.Visible := True;
         end;
       end;

       TagClearMode:=(Sender=DelCp1Btn);

       PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);

    end;
  end;{with..}

end;

procedure TBatchPay.Due1Click(Sender: TObject);
begin
  // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date
  WTagMode:=TransactionTagMode(TMenuItem(Sender).Tag);

  If (Not TagClearMode) then
    AddCp1BtnClick(InsCp3Btn)
  else
    AddCp1BtnClick(DelCp1Btn);

end;

procedure TBatchPay.WildTag1Click(Sender: TObject);
begin
  TagClearMode:=(Sender=Clear1);
end;



procedure TBatchPay.ReCalcOneAcc;
Var
  mbRet  :  Word;
  n      :  Byte;

  LOk,LLocked
         :  Boolean;

  KeyS2  :  Str255;

begin
  {$B-}
  If (Assigned(MULCtrlO)) and (Not MULCtrlO.InListFind) and (Check_OnlyUser) and (MULCtrlO.ValidLine) then
  {$B+}
  Begin
    KeyS2:='';

    Set_BackThreadMVisible(BOn);

    With MiscRecs^.BACSSRec do
      mbRet:=CustomDlg(Self,'Please note!','Recalculate account '+Trim(TagCustCode),
                 'Recalculating account '+Trim(TagCustCode)+' will reset any tagged items contained within it to zero.'+#13+#13+
                 'In addition this account will be re-scanned for new transactions which could now be included.'+#13+#13+
                 'Please confirm you wish recalculate the '+BatchPTit(RecMode)+' for '+Trim(TagCustCode),
                 mtConfirmation,
                 [mbYes,mbNo]);

    Set_BackThreadMVisible(BOff);

    {$IFDEF POST}

      If (mbRet=mrOK) then
      With MULCtrlO,ExLocal do
      Begin
        GetSelRec(Boff);

        LOk:=BOff; LLocked:=BOff;

        LOk:=GetMultiRec(B_GetDirect,B_MultLock,KeyS2,Keypath,ScanFilenum,BOn,LLocked);

        If (LOk and LLocked) then
        With MiscRecs^.BACSSRec do
        Begin
          {Lock Totals}
          BACS_CtrlPut(PWrdF,PWK,Self.BatchCtrl,nil,1);

          For n:=1 to NoBACSTot do
          Begin
            Self.BatchCtrl.BACSCRec.TotalTag[n]:=Self.BatchCtrl.BACSCRec.TotalTag[n]-MiscRecs^.BACSSRec.TotalOS[n];
          end;

          Self.BatchCtrl.BACSCRec.TotalTag[0]:=Self.BatchCtrl.BACSCRec.TotalTag[0]-MiscRecs^.BACSSRec.TotalTagged[0];

          Dec(Self.BatchCtrl.BACSCRec.TagCount);

          Self.BatchCtrl.BACSCRec.Spare3K:=TagCustCode;

          Status:=Delete_Rec(F[ScanFilenum],ScanFilenum,Keypath);

          Report_BError(ScanFilenum,Status);

          {unLock Totals}
          BACS_CtrlPut(PWrdF,PWK,Self.BatchCtrl,nil,0);

          AddAccScan2Thread(Application.MainForm,Self.BatchCtrl,Self.Handle);

          SetButtons(BOff);
          Enabled:=BOff;
          Scan1Acc:=BOn;

          If (Assigned(BItemList)) then
            BItemList.Enabled:=BOff;
        end;

      end;
    {$ENDIF}
  end;
end;

procedure TBatchPay.ReCalcAllAccs;
Var
  mbRet  :  Word;
begin
  {$B-}
  If (Assigned(MULCtrlO)) and (Not MULCtrlO.InListFind) and (Check_OnlyUser)  then
  {$B+}
  Begin
    // PS 26/10/2016 2017 R1 ABSEXCH-15752 - Batch Payments - Add Ability to Tag up to a given Transaction Date or Due Date
    if (WTagMode=eTagModeTransactionDate) or (WTagMode=eTagModeDueDate)then
    begin
      mbRet:=mrOK;
      Set_BackThreadMVisible(BOff);   // PS 21/11/2016 2017 R1 ABSEXCH-15752 - close Thread controller
    end
    else
    begin
      Set_BackThreadMVisible(BOn);

      mbRet:=CustomDlg(Self,'Please note!','Recalculate this screen.',
                   'Recalculating this screen will reset all the tagged items to zero.'+#13+#13+
                   'In addition all accounts will be re-scanned for new transactions which could now be included.'+#13+#13+
                   'Please confirm you wish recalculate the '+BatchPTit(RecMode)+' screen.',
                   mtConfirmation,
                   [mbYes,mbNo]);

      Set_BackThreadMVisible(BOff);
      WTagMode:=eTagDoNothing; //0
    end;

    {$IFDEF POST}

      If (mbRet=mrOK) then
      Begin
        AddBACSScan2Thread(Application.MainForm,BatchCtrl,Self.Handle,FDateValue,WTagMode);

        SetButtons(BOff);
        Enabled:=BOff;

        If (Assigned(BItemList)) then
          BItemList.Enabled:=BOff;

      end;
    {$ENDIF}
  end;
end;


procedure TBatchPay.HistCP1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  With MULCtrlO do
  Begin
    If (Not InListFind) and (Not (Sender is TMenuItem)) then
    Begin

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




procedure TBatchPay.RC1Click(Sender: TObject);
begin
  WTagMode := eTagDoNothing; //0
  If Sender is TMenuItem then
  With TMEnuItem(Sender) do
  Case Tag of
    0  :  ReCalcAllAccs;
    1  :  ReCalcOneAcc;
  end; {Case..}
end;


procedure TBatchPay.GenCP3BtnClick(Sender: TObject);
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
        {Pass2Parent:=BOn;}
        ShowSome:=BOff;

        If (ShowSome) then
          DontHide:=[1-Ord(RecMode)];

        //PR: 04/12/2013 ABSEXCH-14824. For receipts we need to allow Customers & Consumers
        if RecMode then
        begin
          DontHide := [tabFindCustomer, tabFindConsumer];
          Ctrl_GlobalFind(Self,ReturnCtrl,tabFindCustomer);
        end
        else
          Ctrl_GlobalFind(Self,ReturnCtrl,tabFindSupplier);

      end;
    end; {If in list find..}

  {$ENDIF}
end;


{ === Func to check if there are any negative values === }

Function TBatchPay.Check4NegBATCH(Fnum,
                                  Keypath  :  Integer;
                                  Warn     :  Boolean)  :  Boolean;

  Var
    KeyS,
    KeyIS,
    KeyChk     :  Str255;


  Begin
    Result:=BOff;

    With ExLocal,BatchCtrl.BACSCRec do
    Begin
      KeyChk:=PartCCKey(MBACSCode,MBACSSub)+FullNomKey(TagRunNo);

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not Result) do
      With LMiscRecs^.BACSSRec do
      Begin
        Result:=(BatchDocSign(SalesCust,TotalTagged[0])<0.0);

        If (Not Result) then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}
    end; {With..}

    If (Result) and (Warn) then
    With ExLocal,LMiscRecs^.BACSSRec do
    Begin
      KeyIS:=TagCustCode;

      Global_GetMainRec(CustF,KeyIS);


      CustomDlg(Self,'Please note!','Negative Balance Detected!',
                 'The tagged balance of '+
                 FormatCurFloat(GenRealMask,BatchDocSign(SalesCust,TotalTagged[0]),BOff,BatchCtrl.BACSCRec.PayCurr)+' for '+
                 dbFormatName(Cust.CustCode,Cust.Company) +
                 ' is negative. Only positive values may be processed.'+#13+#13+
                 'Please correct before attempting to process.',
                 mtInformation,
                 [mbOk]);


    end;
  end;



{ == Function to check we are the only user == }

Function TBatchPay.Check_OnlyUser  :  Boolean;


Begin
  Result:=Not BACS_HasUsers(BatchCtrl.BacsCRec.SalesMode,BOn,MyUsrNo);

  If (Not Result) then
  Begin
    {Ideally show list of users}
    Show_LIUsers(BatchCtrl.BacsCRec.SalesMode,MyUsrNo);


  end;

end;

procedure TBatchPay.FindCP1BtnClick(Sender: TObject);

begin
  {$IFDEF Rp}

  {$B-}
  If (Assigned(MULCtrlO)) and (Not MULCtrlO.InListFind) and (Check_OnlyUser) then
  {$B+}

  Begin {$B-}
    If ((BatchCtrl.BACSCRec.PayType=BACS2Code) or (BatchCtrl.BACSCRec.PayType=BACS2Code)) or  (Not Check4NegBatch(MiscF,MIK,BOn)) then
    {$B+}
    Begin
      BACSCtrl(BOff,BatchCtrl,Self);

      SetButtons(BOff);
      Enabled:=BOff;

      If (Assigned(BItemList)) then
        BItemList.Enabled:=BOff;
    end;                               
  end;
  {$ENDIF}

end;

procedure TBatchPay.BPCustBtn1Click(Sender: TObject);
begin

  {$IFDEF CU}
    If (Assigned(MULCtrlO)) then
    With MULCtrlO,ExLocal do
    Begin
      If (ValidLine) then
      Begin
        LCust:=Cust;

        ExecuteCustBtn(1000,25-(10*Ord(RecMode)),ExLocal);

      end;
    end; {With..}
  {$ENDIF}
end;

procedure TBatchPay.SetHelpContextIDs;
// NF: 20/06/06 Fix for incorrect Context IDs and support for different IDs for Sales and Purchase.

  procedure IncHelpContextIDs(iInc : integer; TheControl : TControl);
  var
    iPos : integer;

    procedure SetContextID(AControl : TControl; iNewID : integer);
    begin{SetContextID}
      // Exceptions
//      if AControl.Name = 'ClsCP1Btn' then exit;

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
      and (not (Thecontrol.Components[iPos] is TForm))
      then IncHelpContextIDs(iInc, TControl(TheControl.Components[iPos]));
    end;{for}
  end;{IncHelpContextIDs}

var
  bSales : boolean;
begin
  // Fix incorrect IDs
  CompF.HelpContext := 1841;

  bSales := RecMode;
  {$IFDEF LTE}
    // Set Correct Tab IDs
    if bSales then IncHelpContextIDs(5000, Self);
  {$ELSE}
    // Exchequer
  {$ENDIF}
end;

// PS 26/10/2016 2017 R1 ABSEXCH-15752 - Added function to display date and accept date value

function TBatchPay.InputQueryEx(const ACaption, APrompt: string;
  var Value: LongDate): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEditDate;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;

begin
  Result := False;
  Form := TForm.Create(nil);
  with Form do
  begin
    try
      ClientWidth := 250;
      ClientHeight := 100;
      Form.Left := (Screen.Width - ClientWidth) Div 2;
      Form.Top := (Screen.Height - ClientHeight - GetSystemMetrics(SM_CYCAPTION)) Div 2;

      Canvas.Font := Font;
      BorderStyle := bsDialog;
      Caption := ACaption;
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := APrompt;
        Left := 20;
        Top := ClientHeight + 8;
        with Font do
        begin
          Name  := 'Arial';
          Color := clBlack;
          Size  := 8;
        end;
      end;
      Edit := TEditDate.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Width + 25 ;
        Top := ClientHeight ;
        Width := 80;
        MaxLength := 3;
        DateValue := Value ;
        SelectAll;
      end;

      ButtonWidth := 80;
      ButtonHeight := 21;
      ButtonTop := Form.Height - (ButtonHeight * 3 );
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'OK';
        ModalResult := mrOk;
        Default := True;
        SetBounds((Form.Width div 2) - 90, ButtonTop, ButtonWidth, ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'Cancel';
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds((Form.Width div 2), ButtonTop, ButtonWidth, ButtonHeight);
      end;
      if ShowModal = mrOk then
      begin
        Value := Edit.Text;
        Result := True;
      end
      else
      begin
        Value := '';
      end;
    finally
      Form.Free;
    end;
  end;
end;

{ TScanBatchTrans }

constructor TScanBatchTrans.Create(AOwner: TObject);
begin
  Inherited Create(AOwner);
  ScanBatchTransMode := BOn;
end;

procedure TScanBatchTrans.Process;
begin
  Inherited Process;

  ResetTaggedTrans(fCustSupp);
end;

Initialization

  BPFormMode:=BOff;
  BPRunNo:=0;
end.
