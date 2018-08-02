unit oEntSys;

Interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, DLLInc, SysUtils, UseDllU
  , VarConst, CustomP, BTSupU1, VarRec2U, IntMU, BTSupU2, ETStrU;

const
  lnkCustomer            = 10;
  lnkSupplier            = 20;
  lnkLineType            = 35;

  lnkSIN                 = 45;
  lnkSINLine             = 60;
  lnkSRC                 = 65;
  lnkSRCLine             = 70;
  lnkSQU                 = 75;
  lnkSQULine             = 80;
  lnkSOR                 = 85;
  lnkSORLine             = 90;

  lnkPIN                 = 100;
  lnkPINLine             = 110;
  lnkPPY                 = 120;
  lnkPPYLine             = 130;
  lnkPQU                 = 135;
  lnkPQULine             = 140;
  lnkPOR                 = 145;
  lnkPORLine             = 150;

  lnkNom                 = 155;
  lnkNomLine             = 157;

  lnkStockRec            = 170;
  lnkADJ                 = 180;
  lnkADJLine             = 190;

  lnkWOR                 = 200;
  lnkWORLine             = 210;

  lnkJobRec              = 280;
  lnkEmployee            = 285;
  lnkTSH                 = 290;
  lnkTSHLine             = 300;

type
  TTradeSystemSetupVAT = class(TAutoIntfObject, ITradeSystemSetupVAT)
  private
    ThisVAT : VatType;
  protected
    function  Get_svCode: WideString; safecall;
    function  Get_svDesc: WideString; safecall;
    function  Get_svRate: Double; safecall;
    function  Get_svInclude: WordBool; safecall;
  public
    Constructor Create (Const VATIdx : VATType);
  End; { TTradeSystemSetupVAT }

  {-----------------------------------------}

  TTradeSystemSetupCurrency = class(TAutoIntfObject, ITradeSystemSetupCurrency)
  Private
    ThisCcy : SmallInt;
  protected
    function  Get_scSymbol: WideString; safecall;
    function  Get_scDesc: WideString; safecall;
    function  Get_scCompanyRate: Double; safecall;
    function  Get_scDailyRate: Double; safecall;
    function  Get_scPrintSymb: WideString; safecall;
    function  Get_scTriRate: Double; safecall;
    function  Get_scTriEuroCcy: Smallint; safecall;
    function  Get_scTriInvert: WordBool; safecall;
    function  Get_scTriFloating: WordBool; safecall;
  public
    Constructor Create (Const CcyIdx : SmallInt);
  End; { TTradeSystemSetupCurrency }

  {-----------------------------------------}

  TTradeSystemSetupUserFields = class(TAutoIntfObject, ITradeSystemSetupUserFields)
  private
    function CapSet(SetNo, Index : Integer) : Integer;
    function CapAry(SetNo, Index : Integer) : Integer;
    function HidSet(SetNo, Index : Integer) : Integer;
    function HidAry(SetNo, Index : Integer) : Integer;
    function GetVal(const s : string; Val : integer) : string;
    function GetInt(const s : string; WantSet : Boolean) : integer;
  protected
    function  Get_ufAccount1: WideString; safecall;
    function  Get_ufAccount2: WideString; safecall;
    function  Get_ufAccount3: WideString; safecall;
    function  Get_ufAccount4: WideString; safecall;
    function  Get_ufStock1: WideString; safecall;
    function  Get_ufStock2: WideString; safecall;
    function  Get_ufStock3: WideString; safecall;
    function  Get_ufStock4: WideString; safecall;
    function  Get_ufJob1: WideString; safecall;
    function  Get_ufJob2: WideString; safecall;

    function Get_ufADJDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufADJEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufADJLineDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufADJLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufCustDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufEmployeeDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufJobDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufLineTypeDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufNOMDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufNOMEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufNOMLineDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufNOMLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPINDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufPINEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPINLineDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufPINLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPORDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufPOREnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPORLineDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufPORLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPPYDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufPPYEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPPYLineDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufPPYLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPQUDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufPQUEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPQULineDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufPQULineEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSINDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufSINEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSINLineDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufSINLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSORDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufSOREnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSORLineDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufSORLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSQUDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufSQUEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSQULineDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufSQULineEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSRCDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_usSRCEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSRCLineDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufSRCLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufStockDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufSuppDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufTSHDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufTSHEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufTSHLineDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufTSHLineDescEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufWORDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufWOREnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;
    function Get_ufWORLineDesc(Index: TTradeUserDefinedFieldNo): WideString; safecall;
    function Get_ufWORLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool; safecall;

    Function  GetUserFieldName(Index : Integer) : ShortString;
    Function  GetUserFieldEnabled(Index : Integer) : Boolean;
  public
    Constructor Create;
  End; { TTradeSystemSetupUserFields }

  {-----------------------------------------}
  TTradeSystemSetupJob = Class(TAutoIntfObject, ITradeSystemSetupJob)
  protected
    function  Get_ssUsePPIsForTimeSheets: WordBool; safecall;
    function  Get_ssSplitJobBudgetsByPeriod: WordBool; safecall;
    function  Get_ssPPISupAccount: WideString; safecall;
    function  Get_ssJobCategory(Index: TTradeJobCategoryType): WideString; safecall;
    function  Get_ssCheckJobBudget: WordBool; safecall;
    function  Get_ssJobCostingGLCtrlCodes(Index : TTradeSystemSetupJobGLCtrlType): Integer; safecall;
  public
    Constructor Create;
  End; { TTradeSystemSetupJob }

  TTradeEntSetup = class(TAutoIntfObject, ITradeEntSetup)
  private
//    FTillsO : TTradeEntSetupTills;
//    FTillsI : ITradeEntSetupTills;

    // VAT sub-object Arrays
    FVATO        : Array [VATType] Of TTradeSystemSetupVAT;
    FVATI        : Array [VATType] Of ITradeSystemSetupVAT;

    // Currency sub-objects array
    FCurrencyO   : Array [0..CurrencyType] Of TTradeSystemSetupCurrency;
    FCurrencyI   : Array [0..CurrencyType] Of ITradeSystemSetupCurrency;

    // User Fields sub-object
    FUserFieldsO : TTradeSystemSetupUserFields;
    FUserFieldsI : ITradeSystemSetupUserFields;

    // Job sub-object
    FJobSetupO : TTradeSystemSetupJob;
    FJobSetupI : ITradeSystemSetupJob;

  protected
    Procedure InitObjects;

    function Get_ssPeriodsInYear: Smallint; safecall;
    function Get_ssCompanyName: WideString; safecall;
    function Get_ssLastAuditYr: Smallint; safecall;
    function Get_ssManUpdReorderCost: WordBool; safecall;
    function Get_ssVATReturnCurrency: Smallint; safecall;
    function Get_ssCostDecimals: Smallint; safecall;
    function Get_ssShowStkPriceAsMargin: WordBool; safecall;
    function Get_ssLiveStockCOSVal: WordBool; safecall;
    function Get_ssSDNShowPickedOnly: WordBool; safecall;
    function Get_ssUseLocations: WordBool; safecall;
    function Get_ssSetBOMSerNo: WordBool; safecall;
    function Get_ssWarnDupliYourRef: WordBool; safecall;
    function Get_ssUseLocDelAddress: WordBool; safecall;
    function Get_ssBudgetByCCDept: WordBool; safecall;
    function Get_ssCurrencyTolerance: Double; safecall;
    function Get_ssCurrencyToleranceMode: Smallint; safecall;
    function Get_ssDebtChaseMode: Smallint; safecall;
    function Get_ssAutoGenVariance: WordBool; safecall;
    function Get_ssAutoGenDisc: WordBool; safecall;
    function Get_ssCompanyCountryCode: WideString; safecall;
    function Get_ssSalesDecimals: Smallint; safecall;
    function Get_ssDebtChaseOverdue: Smallint; safecall;
    function Get_ssCurrentPeriod: Smallint; safecall;
    function Get_ssCurrentYear: Smallint; safecall;
    function Get_ssTradeTerm: WordBool; safecall;
    function Get_ssSeparateCurrencyStatements: WordBool; safecall;
    function Get_ssStatementAgingMethod: Smallint; safecall;
    function Get_ssStatementUseInvoiceDate: WordBool; safecall;
    function Get_ssQuotesAllocateStock: WordBool; safecall;
    function Get_ssDeductBOMComponents: WordBool; safecall;
    function Get_ssAuthorisationMethod: WideString; safecall;
    function Get_ssUseIntrastat: WordBool; safecall;
    function Get_ssAnalyseDescOnly: WordBool; safecall;
    function Get_ssDefaultStockValMethod: WideString; safecall;
    function Get_ssDisplayUpdateCosts: WordBool; safecall;
    function Get_ssAutoChequeNo: WordBool; safecall;
    function Get_ssStatementIncNotDue: WordBool; safecall;
    function Get_ssForceBatchTotalBalancing: WordBool; safecall;
    function Get_ssDisplayStockLevelWarning: WordBool; safecall;
    function Get_ssStatementNoteEntry: WordBool; safecall;
    function Get_ssHideMenuOpt: WordBool; safecall;
    function Get_ssUseCCDept: WordBool; safecall;
    function Get_ssHoldSettlementDiscTransactions: WordBool; safecall;
    function Get_ssSetTransPeriodByDate: WordBool; safecall;
    function Get_ssStopOverCreditLimit: WordBool; safecall;
    function Get_ssUseSRCPayInRef: WordBool; safecall;
    function Get_ssUsePasswords: WordBool; safecall;
    function Get_ssPromptToPrintReceipt: WordBool; safecall;
    function Get_ssExternalCustomers: WordBool; safecall;
    function Get_ssQtyDecimals: Smallint; safecall;
    function Get_ssExternalSINEntry: WordBool; safecall;
    function Get_ssDisablePostingToPreviousPeriods: WordBool; safecall;
    function Get_ssPercDiscounts: WordBool; safecall;
    function Get_ssNumericAccountCodes: WordBool; safecall;
    function Get_ssUpdateBalanceOnPosting: WordBool; safecall;
    function Get_ssShowInvoiceDisc: WordBool; safecall;
    function Get_ssSplitDiscountsInGL: WordBool; safecall;
    function Get_ssDoCreditStatusCheck: WordBool; safecall;
    function Get_ssDoCreditLimitCheck: WordBool; safecall;
    function Get_ssAutoClearPayments: WordBool; safecall;
    function Get_ssCurrencyRateType: TTradeCurrencyRateType; safecall;
    function Get_ssShowPeriodsAsMonths: WordBool; safecall;
    function Get_ssDirectCustomer: WideString; safecall;
    function Get_ssDirectSupplier: WideString; safecall;
    function Get_ssSettlementDiscount: Double; safecall;
    function Get_ssSettlementDays: Smallint; safecall;
    function Get_ssNeedBOMCostingUpdate: WordBool; safecall;
    function Get_ssInputPackQtyOnLine: WordBool; safecall;
    function Get_ssDefaultVATCode: WideString; safecall;
    function Get_ssPaymentTerms: Smallint; safecall;
    function Get_ssStatementAgeingInterval: Smallint; safecall;
    function Get_ssKeepQuoteDate: WordBool; safecall;
    function Get_ssFreeStockExcludesSOR: WordBool; safecall;
    function Get_ssSeparateDirectTransCounter: WordBool; safecall;
    function Get_ssStatementShowMatchedInMonth: WordBool; safecall;
    function Get_ssLiveOldestDebt: WordBool; safecall;
    function Get_ssBatchPPY: WordBool; safecall;
    function Get_ssDefaultBankGL: Integer; safecall;
    function Get_ssUseDefaultBankAccount: WordBool; safecall;
    function Get_ssYearStartDate: WideString; safecall;
    function Get_ssLastAuditDate: WideString; safecall;
    function Get_ssBankSortCode: WideString; safecall;
    function Get_ssBankAccountNo: WideString; safecall;
    function Get_ssBankAccountRef: WideString; safecall;
    function Get_ssBankName: WideString; safecall;
    function Get_ssCompanyPhone: WideString; safecall;
    function Get_ssCompanyFax: WideString; safecall;
    function Get_ssCompanyVATRegNo: WideString; safecall;
    function Get_ssCompanyAddress(Index: Integer): WideString; safecall;
    function Get_ssGLCtrlCodes(Index: TTradeSystemSetupGLCtrlType): Integer; safecall;
    function Get_ssDebtChaseDays(Index: Integer): Smallint; safecall;
    function Get_ssTermsofTrade(Index: Integer): WideString; safecall;
    function Get_ssVATRates(const Index: WideString): ITradeSystemSetupVAT; safecall;
    function Get_ssCurrency(Index: Integer): ITradeSystemSetupCurrency; safecall;
    function Get_ssUserFields: ITradeSystemSetupUserFields; safecall;
    function Get_ssPickingOrderAllocatesStock: WordBool; safecall;
    function Get_ssDocumentNumbers(const DocType: WideString): Integer; safecall;
//    function Get_ssCurrencyVersion: TTradeEnterpriseCurrencyVersion; safecall;
    function Get_ssMaxCurrency: Integer; safecall;
    procedure Refresh; safecall;
    function Get_ssUseDosKeys: WordBool; safecall;
    function Get_ssHideEnterpriseLogo: WordBool; safecall;
    function Get_ssConserveMemory: WordBool; safecall;
    function Get_ssProtectYourRef: WordBool; safecall;
    function Get_ssSDNDateIsTaxPointDate: WordBool; safecall;
    function Get_ssAutoPostUplift: WordBool; safecall;
    function Get_ssJobCosting: ITradeSystemSetupJob; safecall;
    function Get_ssTaxWord: WideString; safecall;
    function Get_ssMainCompanyDir: WideString; safecall;
  public
    Constructor Create;
    Destructor Destroy; override;
  End; { TTradeEntSetup }

implementation

uses
  ComServ, EPOSProc, oVersion, LicUtil,
  CustomFieldsVar,
  CustomFieldsIntf,

  //PR: 11/09/2013 ABSEXCH-14598
  EncryptionUtils;

type
  {copied from SysSetU}
  tSSTreeGrpRec  =  Record
                      tCaption  :  String;
                      IsChild   :  Byte;
                      CaptionLink
                                :  String;
                      HideLink  :  String;

                      Exclude   :  Boolean;
                    end;

  tSSTreeGrpAry  =  Array[1..300] of tSSTreeGrpRec;
{----}


var
  SSTreeGrpAry : tSSTreeGrpAry;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeEntSetup.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEntSetup);

  InitObjects;

End; { Create }

Destructor TTradeEntSetup.Destroy;
Begin { Destroy }

  InitObjects;

  Inherited;
End; { Destroy }


function TTradeEntSetup.Get_ssCurrencyToleranceMode: Smallint;
begin
  Result := Syss.AlTolMode
end;

function TTradeEntSetup.Get_ssCurrencyTolerance: Double;
begin
  Result := Syss.AlTolVal
end;

function TTradeEntSetup.Get_ssAnalyseDescOnly: WordBool;
begin
  Result := Syss.AnalStkDesc
end;

function TTradeEntSetup.Get_ssAuthorisationMethod: WideString;
begin
  Result := Syss.AuthMode
end;

function TTradeEntSetup.Get_ssDisplayUpdateCosts: WordBool;
begin
  Result := Syss.AutoBillUp
end;

function TTradeEntSetup.Get_ssAutoClearPayments: WordBool;
begin
  Result := Syss.AutoClearPay
end;

function TTradeEntSetup.Get_ssAutoChequeNo: WordBool;
begin
  Result := Syss.AutoCQNo
end;

function TTradeEntSetup.Get_ssAutoGenDisc: WordBool;
begin
  Result := Syss.AutoGenDisc
end;

function TTradeEntSetup.Get_ssAutoGenVariance: WordBool;
begin
  Result := Syss.AutoGenVar;
end;

function TTradeEntSetup.Get_ssStatementNoteEntry: WordBool;
begin
  Result := Syss.AutoNotes;
end;

function TTradeEntSetup.Get_ssSetTransPeriodByDate: WordBool;
begin
  Result := Syss.AutoPrCalc;
end;

function TTradeEntSetup.Get_ssDefaultStockValMethod: WideString;
begin
  Result := Syss.AutoStkVal;
end;

function TTradeEntSetup.Get_ssLiveStockCOSVal: WordBool;
begin
  Result := Syss.AutoValStk;
end;

function TTradeEntSetup.Get_ssBankAccountNo: WideString;
begin
  //PR: 11/09/2013 ABSEXCH-14598 Changed to use new field
  Result := DecryptBankAccountCode(Syss.ssBankAccountCode);
end;

function TTradeEntSetup.Get_ssBankAccountRef: WideString;
begin
  Result := Syss.UserRef;
end;

function TTradeEntSetup.Get_ssBankName: WideString;
begin
  Result := Syss.UserBank;
end;

function TTradeEntSetup.Get_ssBankSortCode: WideString;
begin
  //PR: 11/09/2013 ABSEXCH-14598 Changed to use new field
  Result := DecryptBankSortCode(Syss.ssBankSortCode);
end;

function TTradeEntSetup.Get_ssBatchPPY: WordBool;
begin
  Result := Syss.BatchPPY
end;

function TTradeEntSetup.Get_ssCompanyAddress(Index: Integer): WideString;
begin
  Result := Syss.DetailAddr[Index]
end;

function TTradeEntSetup.Get_ssCompanyCountryCode: WideString;
begin
  Result := Syss.USRCntryCode;
end;

function TTradeEntSetup.Get_ssCompanyFax: WideString;
begin
  Result := Syss.DetailFax;
end;

function TTradeEntSetup.Get_ssCompanyName: WideString;
begin
  Result := Syss.UserName;
end;

function TTradeEntSetup.Get_ssCompanyPhone: WideString;
begin
  Result := Syss.DetailTel;
end;

function TTradeEntSetup.Get_ssCostDecimals: Smallint;
begin
  Result := Syss.NoCosDec;
end;

function TTradeEntSetup.Get_ssCurrentPeriod: Smallint;
begin
  Result := Syss.CPr;
end;

function TTradeEntSetup.Get_ssCurrentYear: Smallint;
begin
  Result := Syss.CYr;
end;

function TTradeEntSetup.Get_ssDeductBOMComponents: WordBool;
begin
  Result := Syss.DeadBOM
end;

function TTradeEntSetup.Get_ssDebtChaseDays(Index: Integer): Smallint;
begin
  Result := Syss.DebTrig[Index]
end;

function TTradeEntSetup.Get_ssDebtChaseMode: Smallint;
begin
  Result := Syss.DebtLMode
end;

function TTradeEntSetup.Get_ssDefaultVATCode: WideString;
begin
  Result := Syss.VATCode
end;

function TTradeEntSetup.Get_ssDefaultBankGL: Integer;
begin
  Result := Syss.DefBanknom
end;

function TTradeEntSetup.Get_ssPercDiscounts: WordBool;
begin
  Result := Syss.DefPcDisc
end;

function TTradeEntSetup.Get_ssSDNShowPickedOnly: WordBool;
begin
  Result := Syss.DelPickOnly
end;

function TTradeEntSetup.Get_ssDirectCustomer: WideString;
begin
  Result := Syss.DirectCust
end;

function TTradeEntSetup.Get_ssDirectSupplier: WideString;
begin
  Result := Syss.DirectSupp
end;

function TTradeEntSetup.Get_ssSeparateDirectTransCounter: WordBool;
begin
  Result := Syss.DirOwnCount
end;

function TTradeEntSetup.Get_ssShowPeriodsAsMonths: WordBool;
begin
  Result := Syss.DispPrAsMonths
end;

function TTradeEntSetup.Get_ssSetBOMSerNo: WordBool;
begin
  Result := Syss.EditSinSer
end;

function TTradeEntSetup.Get_ssExternalCustomers: WordBool;
begin
  Result := Syss.ExternCust
end;

function TTradeEntSetup.Get_ssExternalSINEntry: WordBool;
begin
  Result := Syss.ExternSIN
end;

function TTradeEntSetup.Get_ssFreeStockExcludesSOR: WordBool;
begin
  Result := Syss.FreeExAll;
end;

function TTradeEntSetup.Get_ssGLCtrlCodes(Index: TTradeSystemSetupGLCtrlType): Integer;
begin
  Result := Syss.NomCtrlCodes[NomCtrlType(Index)];
end;

function TTradeEntSetup.Get_ssHideMenuOpt: WordBool;
begin
  Result := Syss.HideMenuOpt;
end;

function TTradeEntSetup.Get_ssStatementIncNotDue: WordBool;
begin
  Result := Syss.IncNotDue;
end;

function TTradeEntSetup.Get_ssInputPackQtyOnLine: WordBool;
begin
  Result := Syss.InpPack;
end;

function TTradeEntSetup.Get_ssUseIntrastat: WordBool;
begin
  Result := Syss.IntraStat;
end;

function TTradeEntSetup.Get_ssLastAuditDate: WideString;
begin
  Result := Syss.AuditDate;
end;

function TTradeEntSetup.Get_ssLastAuditYr: Smallint;
begin
  Result := Syss.AuditYr;
end;

function TTradeEntSetup.Get_ssLiveOldestDebt: WordBool;
begin
  Result := Syss.LiveCredS;
end;

function TTradeEntSetup.Get_ssManUpdReorderCost: WordBool;
begin
  Result := Syss.ManROCP;
end;

function TTradeEntSetup.Get_ssNeedBOMCostingUpdate: WordBool;
begin
  Result := Syss.NeedBMUp;
end;

function TTradeEntSetup.Get_ssHoldSettlementDiscTransactions: WordBool;
begin
  Result := Not Syss.NoHoldDisc;
end;

function TTradeEntSetup.Get_ssPaymentTerms: Smallint;
begin
  Result := Syss.PayTerms;
end;

function TTradeEntSetup.Get_ssPeriodsInYear: Smallint;
begin
  Result := Syss.PrinYr;
end;

function TTradeEntSetup.Get_ssBudgetByCCDept: WordBool;
begin
  Result := Syss.PostCCNom;
end;

function TTradeEntSetup.Get_ssDisablePostingToPreviousPeriods: WordBool;
begin
  Result := Syss.PrevPrOff;
end;

function TTradeEntSetup.Get_ssPromptToPrintReceipt: WordBool;
begin
  Result := Syss.PrintReciept;
end;

function TTradeEntSetup.Get_ssQtyDecimals: Smallint;
begin
  Result := Syss.NoQtyDec;
end;

function TTradeEntSetup.Get_ssQuotesAllocateStock: WordBool;
begin
  Result := Syss.QUAllocFlg;
end;

function TTradeEntSetup.Get_ssKeepQuoteDate: WordBool;
begin
  Result := Syss.QuoOwnDate;
end;

function TTradeEntSetup.Get_ssSalesDecimals: Smallint;
begin
  Result := Syss.NoNetDec;
end;

function TTradeEntSetup.Get_ssSplitDiscountsInGL: WordBool;
begin
  Result := Syss.SepDiscounts;
end;

function TTradeEntSetup.Get_ssSettlementDays: Smallint;
begin
  // MH 19/06/2015 v7.0.14: Removed obsolete fields
  Result := 0; //Syss.SettleDays;
end;

function TTradeEntSetup.Get_ssSettlementDiscount: Double;
begin
  // MH 19/06/2015 v7.0.14: Removed obsolete fields
  Result := 0; //Syss.SettleDisc;
end;

function TTradeEntSetup.Get_ssShowInvoiceDisc: WordBool;
begin
  Result := Syss.ShowInvDisc;
end;

function TTradeEntSetup.Get_ssShowStkPriceAsMargin: WordBool;
begin
  Result := Syss.ShowStkGP;
end;

function TTradeEntSetup.Get_ssStatementAgeingInterval: Smallint;
begin
  Result := Syss.StaAgeInt;
end;

function TTradeEntSetup.Get_ssStatementAgingMethod: Smallint;
begin
  Result := Syss.StaAgeMthd;
end;

function TTradeEntSetup.Get_ssSeparateCurrencyStatements: WordBool;
begin
  Result := Syss.StaSepCr;
end;

function TTradeEntSetup.Get_ssStatementShowMatchedInMonth: WordBool;
begin
  Result := Syss.StaShowOS;
end;

function TTradeEntSetup.Get_ssStatementUseInvoiceDate: WordBool;
begin
  Result := Syss.StaUIDate;
end;

function TTradeEntSetup.Get_ssStopOverCreditLimit: WordBool;
begin
  Result := Syss.StopBadDr;
end;

function TTradeEntSetup.Get_ssTermsofTrade(Index: Integer): WideString;
begin
  Result := Syss.TermsofTrade[Index];
end;

function TTradeEntSetup.Get_ssCurrencyRateType: TTradeCurrencyRateType;
begin
  Case Syss.TotalConv of
    'C' : Result := rtCompany;
    'V' : Result := rtDaily;
  end;
end;

function TTradeEntSetup.Get_ssNumericAccountCodes: WordBool;
begin
  Result := Syss.TradCodeNum
end;

function TTradeEntSetup.Get_ssTradeTerm: WordBool;
begin
  Result := Syss.TradeTerm
end;

function TTradeEntSetup.Get_ssUpdateBalanceOnPosting: WordBool;
begin
  Result := Syss.UpBalOnPost
end;

function TTradeEntSetup.Get_ssForceBatchTotalBalancing: WordBool;
begin
  Result := Syss.UseBatchTot
end;

function TTradeEntSetup.Get_ssUseCCDept: WordBool;
begin
  Result := Syss.UseCCDep
end;

function TTradeEntSetup.Get_ssDoCreditStatusCheck: WordBool;
begin
  Result := Syss.UseCreditChk
end;

function TTradeEntSetup.Get_ssDoCreditLimitCheck: WordBool;
begin
  Result := Syss.UseCRLimitChk
end;

function TTradeEntSetup.Get_ssUseDefaultBankAccount: WordBool;
begin
  Result := Syss.UseDefBank
end;

function TTradeEntSetup.Get_ssUseLocDelAddress: WordBool;
begin
  Result := Syss.UseLocDel
end;

function TTradeEntSetup.Get_ssUseLocations: WordBool;
begin
  Result := Syss.UseMLoc
end;

function TTradeEntSetup.Get_ssUsePasswords: WordBool;
begin
  Result := Syss.UsePasswords
end;

function TTradeEntSetup.Get_ssUseSRCPayInRef: WordBool;
begin
  Result := Syss.UsePayIn
end;

function TTradeEntSetup.Get_ssCompanyVATRegNo: WideString;
begin
  Result := Syss.UserVATReg
end;

function TTradeEntSetup.Get_ssDisplayStockLevelWarning: WordBool;
begin
  Result := Syss.UseStock;
end;

function TTradeEntSetup.Get_ssVATReturnCurrency: Smallint;
begin
  Result := Syss.VATCurr;
end;

function TTradeEntSetup.Get_ssWarnDupliYourRef: WordBool;
begin
  Result := Syss.WarnYRef;
end;

function TTradeEntSetup.Get_ssDebtChaseOverdue: Smallint;
begin
  Result := Syss.WksODue;
end;

function TTradeEntSetup.Get_ssYearStartDate: WideString;
begin
  Result := Syss.OMonWk1;
end;

function TTradeEntSetup.Get_ssPickingOrderAllocatesStock: WordBool;
begin
  Result := Syss.UsePick4All;
end;

{-----------------------------------------}

function TTradeEntSetup.Get_ssVATRates(const Index: WideString): ITradeSystemSetupVAT;
Var
  VATIdx  : VATType;
  VATChar : Char;
begin
  // Extract first character from string and check its a valid VAT Code
  VATChar := ExtractChar(Index, #255);
  If (VATChar In VATSet) Then Begin
    // Convert Character to VATType value
    VATIdx := GetVATNo(VATChar, #0);

    If (Not Assigned(FVATO[VATIdx])) Then Begin
      { Create and initialise the VAT sub-object }
      FVATO[VATIdx] := TTradeSystemSetupVAT.Create(VATIdx);

      FVATI[VATIdx] := FVATO[VATIdx];
    End; { If (Not Assigned(FVATO[])) }

    Result := FVATI[VATIdx];;
  End { If (VATChar In VATSet) }
  Else
    Raise EUnknownValue.Create ('Invalid VAT Code ' + QuotedStr(Index));
end;

{-----------------------------------------}

function TTradeEntSetup.Get_ssCurrency(Index: Integer): ITradeSystemSetupCurrency;
Var
  FVersionO : TTradeVersion;
  CcyIdx : SmallInt;
begin
  // Validate currency number (raises exception if invalid)
  FVersionO := TTradeVersion.Create;
  CcyIdx := FVersionO.ValidateCurrencyNo (Index);
  FVersionO := nil;

  If (Not Assigned(FCurrencyO[CcyIdx])) Then Begin
    { Create and initialise the Currency sub-object }
    FCurrencyO[CcyIdx] := TTradeSystemSetupCurrency.Create(CcyIdx);

    FCurrencyI[CcyIdx] := FCurrencyO[CcyIdx];
  End; { If (Not Assigned(FCurrencyO[])) }

  Result := FCurrencyI[CcyIdx];;
end;

{-----------------------------------------}

function TTradeEntSetup.Get_ssUserFields: ITradeSystemSetupUserFields;
begin
  If (Not Assigned(FUserFieldsO)) Then Begin
    { Create and initialise the User Fields Info sub-object }
    FUserFieldsO := TTradeSystemSetupUserFields.Create;

    FUserFieldsI := FUserFieldsO;
  End; { If (Not Assigned(FUserFieldsO)) }

  Result := FUserFieldsI;
end;

{-----------------------------------------}

function TTradeEntSetup.Get_ssDocumentNumbers(const DocType: WideString): Integer;
Var
  pDocType, pNextNo : PChar;
  Res      : SmallInt;
begin
  pDocType := StrAlloc(255);
  pNextNo := StrAlloc(255);

  StrPCopy (pDocType, DocType);

  Res := EX_GETNEXTTRANSNO(pDocType, pNextNo, False);
  If (Res = 0) Then
    // Return Document Number
    Result := StrToInt(Copy (pNextNo, 4, StrLen(pNextNo)))
  Else
    // Error - raise exception
    Raise Exception.Create ('EX_GETNEXTTRANSNO : ' + IntToStr(Res));

  StrDispose(pNextNo);
  StrDispose(pDocType);
end;

{-----------------------------------------}

function TTradeEntSetup.Get_ssMaxCurrency: Integer;
Var
  CcyVer : TTradeEnterpriseCurrencyVersion;
  FVersionO : TTradeVersion;
begin
  // Validate currency number (raises exception if invalid)
  FVersionO := TTradeVersion.Create;
  CcyVer := FVersionO.GetCurrencyVersion;
  FVersionO := nil;

  Case CcyVer Of
    enProfessional : Result := 0;
    enEuro         : Result := 2;
    enGlobal       : Result := CurrencyType;
  Else
    Raise EUnknownValue.Create ('Invalid Currency Version (' + IntToStr(Ord(CcyVer)) + ')');
  End; { Case Get_ssCurrencyVersion }
end;


function TTradeEntSetup.Get_ssUseDosKeys: WordBool; safecall;
begin
  Result := Syss.TxLateCR;
end;

function TTradeEntSetup.Get_ssHideEnterpriseLogo: WordBool;
begin
  Result := Syss.HideExLogo;
end;

function TTradeEntSetup.Get_ssConserveMemory: WordBool;
begin
  Result := Syss.ConsvMem;
end;

function TTradeEntSetup.Get_ssProtectYourRef: WordBool;
begin
  Result := Syss.ProtectYRef;
end;

function TTradeEntSetup.Get_ssSDNDateIsTaxPointDate: WordBool;
begin
  Result := Syss.SDNOwnDate;
end;

function TTradeEntSetup.Get_ssAutoPostUplift: WordBool;
begin
  Result := Syss.UseUpliftNC;
end;

function TTradeEntSetup.Get_ssJobCosting: ITradeSystemSetupJob;
begin
  if (Not Assigned(FJobSetupO)) then
  begin
    FJobSetupO := TTradeSystemSetupJob.Create;

    FJobSetupI := FJobSetupO;
  end;

  Result := FJobSetupI;
end;

function  TTradeEntSetup.Get_ssTaxWord: WideString;
begin
    Result := GetIntMsg(1);
end;

{-----------------------------------------}

procedure TTradeEntSetup.Refresh;
begin { Refresh }
  Init_AllSys;
end; { Refresh }

{-------------------------------------------------------------------------------------------------}

Constructor TTradeSystemSetupVAT.Create (Const VATIdx : VATType);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeSystemSetupVAT);

  // Initialise variables
  ThisVAT := VATIdx;
End; { Create }

{-----------------------------------------}

function TTradeSystemSetupVAT.Get_svCode: WideString;
begin
  Result := SyssVAT.VATRates.VAT[ThisVAT].Code;
end;

function TTradeSystemSetupVAT.Get_svDesc: WideString;
begin
  Result := SyssVAT.VATRates.VAT[ThisVAT].Desc;
end;

function TTradeSystemSetupVAT.Get_svInclude: WordBool;
begin
  Result := SyssVAT.VATRates.VAT[ThisVAT].Include;
end;

function TTradeSystemSetupVAT.Get_svRate: Double;
begin
  Result := SyssVAT.VATRates.VAT[ThisVAT].Rate;
end;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeSystemSetupCurrency.Create (Const CcyIdx : SmallInt);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeSystemSetupCurrency);

  // Initialise variables
  ThisCcy := CcyIdx;
End; { Create }

{-----------------------------------------}

function TTradeSystemSetupCurrency.Get_scCompanyRate: Double;
begin
  Result := SyssCurr.Currencies[ThisCcy].CRates[False];
end;

function TTradeSystemSetupCurrency.Get_scDailyRate: Double;
begin
  Result := SyssCurr.Currencies[ThisCcy].CRates[True];
end;

function TTradeSystemSetupCurrency.Get_scDesc: WideString;
begin
  Result := SyssCurr.Currencies[ThisCcy].Desc;
end;

function TTradeSystemSetupCurrency.Get_scPrintSymb: WideString;
begin
  Result := SyssCurr.Currencies[ThisCcy].PSymb;
end;

function TTradeSystemSetupCurrency.Get_scSymbol: WideString;
begin
  Result := SyssCurr.Currencies[ThisCcy].SSymb;
end;

function TTradeSystemSetupCurrency.Get_scTriEuroCcy: Smallint;
begin
  Result := SyssGCur^.GhostRates.TriEuro[ThisCcy];
end;

function TTradeSystemSetupCurrency.Get_scTriFloating: WordBool;
begin
  Result := SyssGCur^.GhostRates.TriFloat[ThisCcy];
end;

function TTradeSystemSetupCurrency.Get_scTriInvert: WordBool;
begin
  Result := SyssGCur^.GhostRates.TriInvert[ThisCcy];
end;

function TTradeSystemSetupCurrency.Get_scTriRate: Double;
begin
  Result := SyssGCur^.GhostRates.TriRates[ThisCcy];
end;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeSystemSetupUserFields.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeSystemSetupUserFields);

End; { Create }

{-----------------------------------------}

Function TTradeSystemSetupUserFields.GetUserFieldName(Index : Integer) : ShortString;
var
  newIndex, category : longint;
Begin
 // Result := SyssVAT.VATRates.UDFCaption[Index];

 newIndex := CustomFields.GetNewFieldIndex('VAT', index);
 //GS 16/11/2011 ABSEXCH-12082: adjusted caption retrieval code
 //category := Trunc(newIndex / 1000);
 //result := CustomFields[category,index].cfDescription;

 result := CustomFields[newIndex Div 1000, newIndex Mod 1000].cfCaption;
End;

Function TTradeSystemSetupUserFields.GetUserFieldEnabled(Index : Integer) : Boolean;
begin
  case Index Of
      //GS 16/11/2011 ABSEXCH-12082: adjusted enabled property retrieval code
      1 : Result := CustomFields[cfSINHeader, 1].cfEnabled;
      2 : Result := CustomFields[cfSINHeader, 2].cfEnabled;
      3 : Result := CustomFields[cfSINHeader, 3].cfEnabled;
      4 : Result := CustomFields[cfSINHeader, 4].cfEnabled;
      5 : Result := CustomFields[cfSINLine, 1].cfEnabled;
      6 : Result := CustomFields[cfSINLine, 2].cfEnabled;
      7 : Result := CustomFields[cfSINLine, 3].cfEnabled;
      8 : Result := CustomFields[cfSINLine, 4].cfEnabled;
  else
    Result := False;
  End;
end;

{-----------------------------------------}

function TTradeSystemSetupUserFields.Get_ufAccount1: WideString;
begin
  Result := GetUserFieldName(1);
end;

function TTradeSystemSetupUserFields.Get_ufAccount2: WideString;
begin
  Result := GetUserFieldName(2);
end;

function TTradeSystemSetupUserFields.Get_ufAccount3: WideString;
begin
  Result := GetUserFieldName(11);
end;

function TTradeSystemSetupUserFields.Get_ufAccount4: WideString;
begin
  Result := GetUserFieldName(12);
end;

function TTradeSystemSetupUserFields.Get_ufJob1: WideString;
begin
  Result := GetUserFieldName(21);
end;

function TTradeSystemSetupUserFields.Get_ufJob2: WideString;
begin
  Result := GetUserFieldName(22);
end;

function TTradeSystemSetupUserFields.Get_ufStock1: WideString;
begin
  Result := GetUserFieldName(5);
end;

function TTradeSystemSetupUserFields.Get_ufStock2: WideString;
begin
  Result := GetUserFieldName(6);
end;

function TTradeSystemSetupUserFields.Get_ufStock3: WideString;
begin
  Result := GetUserFieldName(15);
end;

function TTradeSystemSetupUserFields.Get_ufStock4: WideString;
begin
  Result := GetUserFieldName(16);
end;

function  TTradeSystemSetupUserFields.Get_ufADJDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkADJ, Ord(Index)), CapAry(lnkADJ, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufADJEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkADJ, Ord(Index)), HidAry(lnkADJ, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufADJLineDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkADJLine, Ord(Index)), CapAry(lnkADJ, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufADJLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkADJLine, Ord(Index)), HidAry(lnkADJ, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufCustDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkCustomer, Ord(Index)), CapAry(lnkCustomer, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufEmployeeDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkEmployee, Ord(Index)), CapAry(lnkEmployee, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufJobDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkJobRec, Ord(Index)), CapAry(lnkJobRec, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufLineTypeDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkLineType, Ord(Index)), CapAry(lnkLineType, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufNOMDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkNom, Ord(Index)), CapAry(lnkNom, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufNOMEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkNOM, Ord(Index)), HidAry(lnkNOM, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufNOMLineDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkNomLine, Ord(Index)), CapAry(lnkNomLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufNOMLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkNOMLine, Ord(Index)), HidAry(lnkNOMLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPINDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkPIN, Ord(Index)), CapAry(lnkPIN, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPINEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkPIN, Ord(Index)), HidAry(lnkPIN, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPINLineDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkPINLine, Ord(Index)), CapAry(lnkPINLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPINLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkPINLine, Ord(Index)), HidAry(lnkPINLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPORDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkPOR, Ord(Index)), CapAry(lnkPOR, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPOREnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkPOR, Ord(Index)), HidAry(lnkPOR, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPORLineDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkPORLine, Ord(Index)), CapAry(lnkPORLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPORLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkPORLine, Ord(Index)), HidAry(lnkPORLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPPYDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkPPY, Ord(Index)), CapAry(lnkPPY, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPPYEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkPPY, Ord(Index)), HidAry(lnkPPY, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPPYLineDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkPPYLine, Ord(Index)), CapAry(lnkPPYLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPPYLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkPPYLine, Ord(Index)), HidAry(lnkPPYLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPQUDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkPQU, Ord(Index)), CapAry(lnkPQU, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPQUEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkPQU, Ord(Index)), HidAry(lnkPQU, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPQULineDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkPQULine, Ord(Index)), CapAry(lnkPQULine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufPQULineEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkPQULine, Ord(Index)), HidAry(lnkPQULine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSINDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkSIN, Ord(Index)), CapAry(lnkSIN, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSINEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkSIN, Ord(Index)), HidAry(lnkSIN, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSINLineDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkSINLine, Ord(Index)), CapAry(lnkSINLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSINLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkSINLine, Ord(Index)), HidAry(lnkSINLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSORDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkSOR, Ord(Index)), CapAry(lnkSOR, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSOREnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkSOR, Ord(Index)), HidAry(lnkSOR, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSORLineDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkSORLine, Ord(Index)), CapAry(lnkSORLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSORLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkSORLine, Ord(Index)), HidAry(lnkSORLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSQUDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkSQU, Ord(Index)), CapAry(lnkSQU, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSQUEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkSQU, Ord(Index)), HidAry(lnkSQU, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSQULineDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkSQULine, Ord(Index)), CapAry(lnkSQULine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSQULineEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkSQULine, Ord(Index)), HidAry(lnkSQULine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSRCDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkSRC, Ord(Index)), CapAry(lnkSRC, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_usSRCEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkSRC, Ord(Index)), HidAry(lnkSRC, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSRCLineDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkSRCLine, Ord(Index)), CapAry(lnkSRCLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSRCLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkSRCLine, Ord(Index)), HidAry(lnkSRCLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufStockDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkStockRec, Ord(Index)), CapAry(lnkStockRec, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufSuppDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkSupplier, Ord(Index)), CapAry(lnkSupplier, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufTSHDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkTSH, Ord(Index)), CapAry(lnkTSH, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufTSHEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkTSH, Ord(Index)), HidAry(lnkTSH, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufTSHLineDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkTSHLine, Ord(Index)), CapAry(lnkTSHLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufTSHLineDescEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkTSHLine, Ord(Index)), HidAry(lnkTSHLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufWORDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkWOR, Ord(Index)), CapAry(lnkWOR, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufWOREnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkWOR, Ord(Index)), HidAry(lnkWOR, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufWORLineDesc(Index: TTradeUserDefinedFieldNo): WideString;
begin
  Result := Get_CustmFieldCaption(CapSet(lnkWORLine, Ord(Index)), CapAry(lnkWORLine, Ord(Index)));
end;

function  TTradeSystemSetupUserFields.Get_ufWORLineEnabled(Index: TTradeUserDefinedFieldNo): WordBool;
begin
  Result := not Get_CustmFieldHide(HidSet(lnkWORLine, Ord(Index)), HidAry(lnkWORLine, Ord(Index)));
end;

function TTradeSystemSetupUserFields.GetVal(const s : string; Val : integer) : string;
var
  Offset : integer;
begin
  if Length(s) = 0 then
    Result := ''
  else
  begin
    //inc(Val);
    if s[1] = 'X' then
      Offset := 1
    else
      Offset := 0;

    Result := ExtractWords(Val + Offset, 1, s);
  end;
end;

function TTradeSystemSetupUserFields.GetInt(const s : string; WantSet : Boolean) : integer;
begin
  if Length(s) = 0 then
    Result := -1
  else
  begin
    if WantSet then
      Result := StrToInt(Copy(s, 1, 3))
    else
      Result := StrToInt(Copy(s, 4, 3));
  end;
end;

function TTradeSystemSetupUserFields.CapSet(SetNo, Index : Integer) : Integer;
begin
  Result := GetInt(GetVal(SSTreeGrpAry[SetNo].CaptionLink, Index), True);
end;

function TTradeSystemSetupUserFields.CapAry(SetNo, Index : Integer) : Integer;
begin
  Result := GetInt(GetVal(SSTreeGrpAry[SetNo].CaptionLink, Index), False);
end;

function TTradeSystemSetupUserFields.HidSet(SetNo, Index : Integer) : Integer;
begin
  Result := GetInt(GetVal(SSTreeGrpAry[SetNo].HideLink, Index), True);
end;

function TTradeSystemSetupUserFields.HidAry(SetNo, Index : Integer) : Integer;
begin
  Result := GetInt(GetVal(SSTreeGrpAry[SetNo].HideLink, Index), False);
end;

{-------------------------------------------------------------------------------------------------}

constructor TTradeSystemSetupJob.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeSystemSetupJob);

End; { Create }

function  TTradeSystemSetupJob.Get_ssUsePPIsForTimeSheets: WordBool;
begin
  Result := SyssJob.JobSetup.GenPPI;
end;

function  TTradeSystemSetupJob.Get_ssSplitJobBudgetsByPeriod: WordBool;
begin
  Result := SyssJob.JobSetup.PeriodBud;
end;

function  TTradeSystemSetupJob.Get_ssPPISupAccount: WideString;
begin
  Result := SyssJob.JobSetup.PPIAcCode;
end;

function  TTradeSystemSetupJob.Get_ssJobCategory(Index: TTradeJobCategoryType): WideString; safecall;
begin
//Convert from zero based index to 1
  Result := SyssJob.JobSetup.SummDesc[Succ(Ord(Index))]
end;

function TTradeSystemSetupJob.Get_ssCheckJobBudget: WordBool;
begin
  Result := Syss.WarnJC;
end;

function  TTradeSystemSetupJob.Get_ssJobCostingGLCtrlCodes(Index : TTradeSystemSetupJobGLCtrlType): Integer;
begin
  Result := SyssJob.JobSetup.EmployeeNom[Integer(Index) + 1, FALSE];
end;

Procedure TTradeEntSetup.InitObjects;
Var
  I : VATType;
  J : SmallInt;
Begin { InitObjects }
  // VAT Rate sub-objects
  For I := Low(FVatO) To High(FVatO) Do Begin
    FVATO[I] := Nil;
    FVATI[I] := Nil;
  End; { For I }

  // Currency sub-objects
  For J := Low(FCurrencyO) To High(FCurrencyO) Do Begin
    FCurrencyO[J] := Nil;
    FCurrencyI[J] := Nil;
  End; { For I }

  // User Fields sub-object
  FUserFieldsO := NIL;
  FUserFieldsI := NIL;
End; { InitObjects }

function TTradeEntSetup.Get_ssMainCompanyDir: WideString;
begin
  Result := GetTCMEnterpriseDirectory;
end;

initialization
  {$I SSARY.PAS}  //Initializes user defined fields array

end.
