unit zSetup;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU, zSetupJC;

type
  TCOMSetupPaperless = class(TAutoIntfObject, ICOMSetupPaperless)
  private
    FD5Setup   : TAbsSetup;
  protected
    function Get_ssYourEmailName: WideString; safecall;
    function Get_ssYourEmailAddress: WideString; safecall;
    function Get_ssSMTPServer: WideString; safecall;
    function Get_ssDefaultEmailPriority: Integer; safecall;
    function Get_ssEmailUseMAPI: WordBool; safecall;
    function Get_ssAttachMethod: Integer; safecall;
    function Get_ssAttachPrinter: WideString; safecall;
    function Get_ssFaxFromName: WideString; safecall;
    function Get_ssFaxFromTelNo: WideString; safecall;
    function Get_ssFaxPrinter: WideString; safecall;
    function Get_ssFaxInterfacePath: WideString; safecall;
    function Get_ssFaxUsing: Integer; safecall;
  public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure InitPaperless(D5Setup : TAbsSetup);
  End; { TCOMSetupPaperless }

  //PR: 31/01/2017 ABSEXCH-15949 Added ICOMSetupUserFields6
  TCOMSetupUserFields = class(TAutoIntfObject, ICOMSetupUserFields, ICOMSetupUserFields2,
                                               ICOMSetupUserFields3, ICOMSetupUserFields4,
                                               ICOMSetupUserFields5, ICOMSetupUserFields6)
  private
    FD5Setup   : TAbsSetup;
  protected
    function  Get_ufAccount1: WideString; safecall;
    function  Get_ufAccount2: WideString; safecall;
    function  Get_ufAccount3: WideString; safecall;
    function  Get_ufAccount4: WideString; safecall;
    function  Get_ufTrans1: WideString; safecall;
    function  Get_ufTrans2: WideString; safecall;
    function  Get_ufTrans3: WideString; safecall;
    function  Get_ufTrans4: WideString; safecall;
    function  Get_ufStock1: WideString; safecall;
    function  Get_ufStock2: WideString; safecall;
    function  Get_ufStock3: WideString; safecall;
    function  Get_ufStock4: WideString; safecall;
    function  Get_ufLine1: WideString; safecall;
    function  Get_ufLine2: WideString; safecall;
    function  Get_ufLine3: WideString; safecall;
    function  Get_ufLine4: WideString; safecall;
    function  Get_ufJob1: WideString; safecall;
    function  Get_ufJob2: WideString; safecall;
    function  Get_ufTrans1Enabled: WordBool; safecall;
    function  Get_ufTrans2Enabled: WordBool; safecall;
    function  Get_ufTrans3Enabled: WordBool; safecall;
    function  Get_ufTrans4Enabled: WordBool; safecall;
    function  Get_ufLine1Enabled: WordBool; safecall;
    function  Get_ufLine2Enabled: WordBool; safecall;
    function  Get_ufLine3Enabled: WordBool; safecall;
    function  Get_ufLine4Enabled: WordBool; safecall;

    // ICOMSetupUserFields2 properties
    function Get_ufCustDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufSuppDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufLineTypeDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufSINDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufSINEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufSINLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufSINLineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufSRCDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufSRCEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufSRCLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufSRCLineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufSQUDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufSQUEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufSQULineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufSQULineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufSORDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufSOREnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufSORLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufSORLineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufPINDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufPINEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufPINLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufPINLineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufPPYDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufPPYEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufPPYLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufPPYLineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufPQUDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufPQUEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufPQULineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufPQULineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufPORDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufPOREnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufPORLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufPORLineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufNOMDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufNOMEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufNOMLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufNOMLineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufStockDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufADJDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufADJEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufADJLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufADJLineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufWORDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufWOREnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufWORLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufWORLineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufJobDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufEmployeeDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufTSHDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufTSHEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufTSHLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufTSHLineEnabled(FieldNo: Integer): WordBool; safecall;

    // ICOMSetupUserFields3 properties
    function Get_ufLineTypeEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufSRNDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufSRNEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufSRNLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufSRNLineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufPRNDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufPRNEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufPRNLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufPRNLineEnabled(FieldNo: Integer): WordBool; safecall;

    // MH 09/03/2012 v6.10 ABSEXCH-12128: ICOMSetupUserFields4 - Added Apps and Vals Custom Fields Settings
    function Get_ufJCTDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufJCTEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufJCTLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufJCTLineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufJPTDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufJPTEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufJPTLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufJPTLineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufJSTDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufJSTEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufJSTLineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufJSTLineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufJPADesc(FieldNo: Integer): WideString; safecall;
    function Get_ufJPAEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufJPALineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufJPALineEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufJSADesc(FieldNo: Integer): WideString; safecall;
    function Get_ufJSAEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufJSALineDesc(FieldNo: Integer): WideString; safecall;
    function Get_ufJSALineEnabled(FieldNo: Integer): WordBool; safecall;

    // MH 02/01/2015 v7.1 ABSEXCH-15855: ICOMSetupUserFields5 - Added Address Description Fields
    function Get_ufAddressDesc(FieldNo: Integer): WideString; safecall;
    // MH 02/01/2015 v7.1 ABSEXCH-15949: Extended to support Customer/Supplier Credit Card Fields (11-15)
    function Get_ufCustDescEnabled(FieldNo: Integer): WordBool; safecall;
    function Get_ufSuppDescEnabled(FieldNo: Integer): WordBool; safecall;
  public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure InitUserFields(D5Setup   : TAbsSetup);
  End; { TCOMSetupUserFields }

  TCOMSetupVAT = class(TAutoIntfObject, ICOMSetupVAT)
  private
    FIdx       : cuVATIndex;
    FD5Setup   : TAbsSetup;
  protected
    function  Get_svCode: WideString; safecall;
    function  Get_svDesc: WideString; safecall;
    function  Get_svRate: Double; safecall;
    function  Get_svInclude: WordBool; safecall;
  public
    Constructor Create;

    Procedure InitVAT(Const Idx : cuVATIndex; D5Setup : TAbsSetup);
  End; { TCOMSetupVAT }

  TCOMSetupCurrency = class(TAutoIntfObject, ICOMSetupCurrency)
  private
    FIdx       : SmallInt;
    FD5Setup   : TAbsSetup;
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
    Constructor Create;

    Procedure InitCurrency(Const Idx : SmallInt; D5Setup : TAbsSetup);
  End; { TCOMSetupCurrency }

  //AP 05/12/2017 ABSEXCH-19401
  TCOMSetupGDPR = class(TAutoIntfObject, ICOMSetupGDPR)
  private
    FD5Setup   : TAbsSetup13;
  protected
    function  Get_Anonymised: WordBool; safecall;
    function  Get_AnonymisedDate: WideString; safecall;
    function  Get_AnonymisedTime: WideString; safecall;
    function  Get_GDPRTraderRetentionPeriod: Integer; safecall;
    function  Get_GDPRTraderDisplayPIITree: WordBool; safecall;
    function  Get_GDPRTraderAnonNotesOption: Integer; safecall;
    function  Get_GDPRTraderAnonLettersOption: Integer; safecall;
    function  Get_GDPRTraderAnonLinksOption: Integer; safecall;
    function  Get_GDPREmployeeRetentionPeriod: Integer; safecall;
    function  Get_GDPREmployeeDisplayPIITree: WordBool; safecall;
    function  Get_GDPREmployeeAnonNotesOption: Integer; safecall;
    function  Get_GDPREmployeeAnonLettersOption: Integer; safecall;
    function  Get_GDPREmployeeAnonLinksOption: Integer; safecall;
    function  Get_NotificationWarningColour: Integer; safecall;
    function  Get_NotificationWarningFontColour: Integer; safecall;
    function  Get_GDPRCompanyAnonLocations: WordBool; safecall;
    function  Get_GDPRCompanyAnonCostCentres: WordBool; safecall;
    function  Get_GDPRCompanyAnonDepartment: WordBool; safecall;
    function  Get_GDPRCompanyNotesOption: Integer; safecall;
    function  Get_GDPRCompanyLettersOption: Integer; safecall;
    function  Get_GDPRCompanyLinksOption: Integer; safecall;
  public
    Constructor Create;

    Procedure InitGDPR(D5Setup : TAbsSetup13);
  End; { TCOMSetupGDPR }
  {-----------------------------------------}

  TCOMSetup = class(TAutoIntfObject, ICOMSetup,  ICOMSetup2,  ICOMSetup3,  ICOMSetup4,
                                     ICOMSetup5, ICOMSetup6,  ICOMSetup7,  ICOMSetup8,
                                     ICOMSetup9, ICOMSetup10, ICOMSetup11, ICOMSetup12,
                                     ICOMSetup13, ICOMSetup14, ICOMSetup15)
  private
    // MH 10/09/2013 ABSEXCH-14598 v7.0.6: Added SEPA/IBAN fields
    //SS:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    FD5Setup  : TAbsSetup15;

    { Sub Classes - Objects }
    FCISSetupO     : TCOMSetupCIS;
    FCurrencyO     : Array [cuCurrencyType] Of TCOMSetupCurrency;
    FJobCostingO   : TCOMSetupJobCosting;
    FPaperlessO    : TCOMSetupPaperless;
    FVATO          : Array [cuVATIndex] Of TCOMSetupVAT;
    FUserFieldsO   : TCOMSetupUserFields;
    FGDPRO         : TCOMSetupGDPR;

    { Sub Classes - Interfaces }
    FCISSetupI     : ICOMSetupCIS;
    FCurrencyI     : Array [cuCurrencyType] Of ICOMSetupCurrency;
    FJobCostingI   : ICOMSetupJobCosting;
    FPaperlessI    : ICOMSetupPaperless;
    FVATI          : Array [cuVATIndex] Of ICOMSetupVAT;
    FUserFieldsI   : ICOMSetupUserFields;
    FGDPRI         : ICOMSetupGDPR;
  protected
    { Property methods }
    function  Get_ssPrinYr: Smallint; safecall;
    function  Get_ssUserName: WideString; safecall;
    function  Get_ssAuditYr: Smallint; safecall;
    function  Get_ssManROCP: WordBool; safecall;
    function  Get_ssVATCurr: Smallint; safecall;
    function  Get_ssNoCosDec: Smallint; safecall;
    function  Get_ssCurrBase: Smallint ; safecall;
    function  Get_ssShowStkGP: WordBool; safecall;
    function  Get_ssAutoValStk: WordBool; safecall;
    function  Get_ssDelPickOnly: WordBool; safecall;
    function  Get_ssUseMLoc: WordBool; safecall;
    function  Get_ssEditSinSer: WordBool; safecall;
    function  Get_ssWarnYRef: WordBool; safecall;
    function  Get_ssUseLocDel: WordBool; safecall;
    function  Get_ssPostCCGL: WordBool; safecall;
    function  Get_ssAlTolVal: Double; safecall;
    function  Get_ssAlTolMode: Smallint; safecall;
    function  Get_ssDebtLMode: Smallint; safecall;
    function  Get_ssAutoGenVar: WordBool; safecall;
    function  Get_ssAutoGenDisc: WordBool; safecall;
    function  Get_ssUSRCntryCode: WideString; safecall;
    function  Get_ssNoNetDec: Smallint; safecall;
    function  Get_ssNoInvLines: Smallint; safecall;
    function  Get_ssWksODue: Smallint; safecall;
    function  Get_ssCPr: Smallint; safecall;
    function  Get_ssCYr: Smallint; safecall;
    function  Get_ssTradeTerm: WordBool; safecall;
    function  Get_ssStaSepCr: WordBool; safecall;
    function  Get_ssStaAgeMthd: Smallint; safecall;
    function  Get_ssStaUIDate: WordBool; safecall;
    function  Get_ssQUAllocFlg: WordBool; safecall;
    function  Get_ssDeadBOM: WordBool; safecall;
    function  Get_ssAuthMode: WideString; safecall;
    function  Get_ssIntraStat: WordBool; safecall;
    function  Get_ssAnalStkDesc: WordBool; safecall;
    function  Get_ssAutoStkVal: WideString; safecall;
    function  Get_ssAutoBillUp: WordBool; safecall;
    function  Get_ssAutoCQNo: WordBool; safecall;
    function  Get_ssIncNotDue: WordBool; safecall;
    function  Get_ssUseBatchTot: WordBool; safecall;
    function  Get_ssUseStock: WordBool; safecall;
    function  Get_ssAutoNotes: WordBool; safecall;
    function  Get_ssHideMenuOpt: WordBool; safecall;
    function  Get_ssUseCCDep: WordBool; safecall;
    function  Get_ssNoHoldDisc: WordBool; safecall;
    function  Get_ssAutoPrCalc: WordBool; safecall;
    function  Get_ssStopBadDr: WordBool; safecall;
    function  Get_ssUsePayIn: WordBool; safecall;
    function  Get_ssUsePasswords: WordBool; safecall;
    function  Get_ssPrintReciept: WordBool; safecall;
    function  Get_ssExternCust: WordBool; safecall;
    function  Get_ssNoQtyDec: Smallint; safecall;
    function  Get_ssExternSIN: WordBool; safecall;
    function  Get_ssPrevPrOff: WordBool; safecall;
    function  Get_ssDefPcDisc: WordBool; safecall;
    function  Get_ssTradCodeNum: WordBool; safecall;
    function  Get_ssUpBalOnPost: WordBool; safecall;
    function  Get_ssShowInvDisc: WordBool; safecall;
    function  Get_ssSepDiscounts: WordBool; safecall;
    function  Get_ssUseCreditChk: WordBool; safecall;
    function  Get_ssUseCRLimitChk: WordBool; safecall;
    function  Get_ssAutoClearPay: WordBool; safecall;
    function  Get_ssTotalConv: WideString; safecall;
    function  Get_ssDispPrAsMonths: WordBool; safecall;
    function  Get_ssDirectCust: WideString; safecall;
    function  Get_ssDirectSupp: WideString; safecall;
    function  Get_ssGLPayFrom: Integer; safecall;
    function  Get_ssGLPayToo: Integer; safecall;
    function  Get_ssSettleDisc: Double; safecall;
    function  Get_ssSettleDays: Smallint; safecall;
    function  Get_ssNeedBMUp: WordBool; safecall;
    function  Get_ssInpPack: WordBool; safecall;
    function  Get_ssVATCode: WideString; safecall;
    function  Get_ssPayTerms: Smallint; safecall;
    function  Get_ssStaAgeInt: Smallint; safecall;
    function  Get_ssQuoOwnDate: WordBool; safecall;
    function  Get_ssFreeExAll: WordBool; safecall;
    function  Get_ssDirOwnCount: WordBool; safecall;
    function  Get_ssStaShowOS: WordBool; safecall;
    function  Get_ssLiveCredS: WordBool; safecall;
    function  Get_ssBatchPPY: WordBool; safecall;
    function  Get_ssWarnJC: WordBool; safecall;
    function  Get_ssDefBankGL: Integer; safecall;
    function  Get_ssUseDefBank: WordBool; safecall;
    function  Get_ssMonWk1: WideString; safecall;
    function  Get_ssAuditDate: WideString; safecall;
    function  Get_ssUserSort: WideString; safecall;
    function  Get_ssUserAcc: WideString; safecall;
    function  Get_ssUserRef: WideString; safecall;
    function  Get_ssUserBank: WideString; safecall;
    function  Get_ssLastExpFolio: Integer; safecall;
    function  Get_ssDetailTel: WideString; safecall;
    function  Get_ssDetailFax: WideString; safecall;
    function  Get_ssUserVATReg: WideString; safecall;
    function  Get_ssDataPath: WideString; safecall;
    function  Get_ssDetailAddr(Index: Integer): WideString; safecall;
    function  Get_ssGLCtrlCodes(Index: TNomCtrlType): Integer; safecall;
    function  Get_ssDebtChaseDays(Index: Integer): Smallint; safecall;
    function  Get_ssTermsofTrade(Index: TTermsIndex): WideString; safecall;
    function  Get_ssCurrency(Index: TCurrencyType): ICOMSetupCurrency; safecall;
    function  Get_ssVATRates(Index: TVATIndex): ICOMSetupVAT; safecall;
    function  Get_ssUserFields: ICOMSetupUserFields; safecall;

    // ICOMSetup2
    function Get_ssWORAllocStockOnPick: WordBool; safecall;
    function Get_ssWOPDisableWIP: WordBool; safecall;
    function Get_ssWORCopyStkNotes: Integer; safecall;
    function Get_ssPaperless: ICOMSetupPaperless; safecall;

    // ICOMSetup3
    function Get_ssCISSetup: ICOMSetupCIS; safecall;
    function Get_ssJobCosting: ICOMSetupJobCosting; safecall;

    // ICOMSetup4
    function Get_ssFilterSNoByBinLoc: WordBool; safecall;
    function Get_ssKeepBinHistory: WordBool; safecall;
    function Get_ssBinMask: WideString; safecall;

    // ICOMSetup5
    function Get_ssGetConnectInfo: WideString; safecall;

    // ICOMSetup6
    function Get_ssUseTransactionTotalDiscounts: WordBool; safecall;
    function Get_ssUseValueBasedDiscounts: WordBool; safecall;

    // ICOMSetup7
    function Get_ssEnableECServices: WordBool; safecall;
    function Get_ssECSalesThreshold: Double; safecall;

    // ICOMSetup8
    function Get_ssCompanyCode: WideString; safecall;

    // ICOMSetup9
    function Get_ssEnableOverrideLocation: WordBool; safecall;

    // ICOMSetup10 MH 10/09/2013 v7.0.6
    function Get_ssBankAccountCode: WideString; safecall;
    function Get_ssBankSortCode: WideString; safecall;

    // ICOMSetup11 MH 26/11/2013 v7.0.8
    function Get_ssConsumersEnabled: WordBool; safecall;

    // ICOMSetup12 MH 22/09/2014 Order Payments
    function Get_ssOrderPaymentsEnabled: WordBool; safecall;

    // ICOMSetup13 PL 23/11/2017 Order Payments
    function Get_ssCurrencyImportTolerance: Single; safecall;

    //ICOMSetup14 AP 04/12/2017 2018R1 GDPR
    function Get_ssGDPR: ICOMSetupGDPR; safecall;

    //SS:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    //ICOMSetup15
    function Get_ssConnectionPassword: WideString; safecall;
    function Get_ssConnectionString: WideString; safecall;
    
  public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure InitSetup(D5Setup : TAbsSetup);
  End; { TCOMSetup }

implementation

uses ComServ, CustIntU, oSystemSetup;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMSetupUserFields.Create;
Begin { Create }

  //PR: 31/01/2017 ABSEXCH-15949 Changed to ICOMSetupUserFields6
  Inherited Create (ComServer.TypeLib, ICOMSetupUserFields6);

  FD5Setup := Nil;
End; { Create }

{-----------------------------------------}

Destructor TCOMSetupUserFields.Destroy;
Begin { Destroy }
  Inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TCOMSetupUserFields.InitUserFields(D5Setup : TAbsSetup);
Begin { InitUserFields }
  FD5Setup := D5Setup;
End; { InitUserFields }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufAccount1: WideString;
Begin { Get_ufAccount1 }
  Result := FD5Setup.ssUserFields.ufAccount1;
End; { Get_ufAccount1 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufAccount2: WideString;
Begin { Get_ufAccount2 }
  Result := FD5Setup.ssUserFields.ufAccount2;
End; { Get_ufAccount2 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufAccount3: WideString;
Begin { Get_ufAccount3 }
  Result := FD5Setup.ssUserFields.ufAccount3;
End; { Get_ufAccount3 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufAccount4: WideString;
Begin { Get_ufAccount4 }
  Result := FD5Setup.ssUserFields.ufAccount4;
End; { Get_ufAccount4 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufTrans1: WideString;
Begin { Get_ufTrans1 }
  Result := FD5Setup.ssUserFields.ufTrans1;
End; { Get_ufTrans1 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufTrans2: WideString;
Begin { Get_ufTrans2 }
  Result := FD5Setup.ssUserFields.ufTrans2;
End; { Get_ufTrans2 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufTrans3: WideString;
Begin { Get_ufTrans3 }
  Result := FD5Setup.ssUserFields.ufTrans3;
End; { Get_ufTrans3 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufTrans4: WideString;
Begin { Get_ufTrans4 }
  Result := FD5Setup.ssUserFields.ufTrans4;
End; { Get_ufTrans4 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufStock1: WideString;
Begin { Get_ufStock1 }
  Result := FD5Setup.ssUserFields.ufStock1;
End; { Get_ufStock1 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufStock2: WideString;
Begin { Get_ufStock2 }
  Result := FD5Setup.ssUserFields.ufStock2;
End; { Get_ufStock2 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufStock3: WideString;
Begin { Get_ufStock3 }
  Result := FD5Setup.ssUserFields.ufStock3;
End; { Get_ufStock3 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufStock4: WideString;
Begin { Get_ufStock4 }
  Result := FD5Setup.ssUserFields.ufStock4;
End; { Get_ufStock4 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufLine1: WideString;
Begin { Get_ufLine1 }
  Result := FD5Setup.ssUserFields.ufLine1;
End; { Get_ufLine1 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufLine2: WideString;
Begin { Get_ufLine2 }
  Result := FD5Setup.ssUserFields.ufLine2;
End; { Get_ufLine2 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufLine3: WideString;
Begin { Get_ufLine3 }
  Result := FD5Setup.ssUserFields.ufLine3;
End; { Get_ufLine3 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufLine4: WideString;
Begin { Get_ufLine4 }
  Result := FD5Setup.ssUserFields.ufLine4;
End; { Get_ufLine4 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufJob1: WideString;
Begin { Get_ufJob1 }
  Result := FD5Setup.ssUserFields.ufJob1;
End; { Get_ufJob1 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufJob2: WideString;
Begin { Get_ufJob2 }
  Result := FD5Setup.ssUserFields.ufJob2;
End; { Get_ufJob2 }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufTrans1Enabled: WordBool;
Begin { Get_ufTrans1Enabled }
  Result := FD5Setup.ssUserFields.ufTrans1Enabled;
End; { Get_ufTrans1Enabled }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufTrans2Enabled: WordBool;
Begin { Get_ufTrans2Enabled }
  Result := FD5Setup.ssUserFields.ufTrans2Enabled;
End; { Get_ufTrans2Enabled }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufTrans3Enabled: WordBool;
Begin { Get_ufTrans3Enabled }
  Result := FD5Setup.ssUserFields.ufTrans3Enabled;
End; { Get_ufTrans3Enabled }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufTrans4Enabled: WordBool;
Begin { Get_ufTrans4Enabled }
  Result := FD5Setup.ssUserFields.ufTrans4Enabled;
End; { Get_ufTrans4Enabled }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufLine1Enabled: WordBool;
Begin { Get_ufLine1Enabled }
  Result := FD5Setup.ssUserFields.ufLine1Enabled;
End; { Get_ufLine1Enabled }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufLine2Enabled: WordBool;
Begin { Get_ufLine2Enabled }
  Result := FD5Setup.ssUserFields.ufLine2Enabled;
End; { Get_ufLine2Enabled }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufLine3Enabled: WordBool;
Begin { Get_ufLine3Enabled }
  Result := FD5Setup.ssUserFields.ufLine3Enabled;
End; { Get_ufLine3Enabled }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufLine4Enabled: WordBool;
Begin { Get_ufLine4Enabled }
  Result := FD5Setup.ssUserFields.ufLine4Enabled;
End; { Get_ufLine4Enabled }

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufADJDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufADJDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufADJEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufADJEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufADJLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufADJLineDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufADJLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufADJLineEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufCustDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufCustDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufEmployeeDesc(FieldNo: Integer): WideString;
begin
  Result := FD5Setup.ssUserFields.ufEmployeeDesc[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufJobDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufJobDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufLineTypeDesc(FieldNo: Integer): WideString;
begin
  Result := FD5Setup.ssUserFields.ufLineTypeDesc[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufNOMDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufNOMDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufNOMEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufNOMEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufNOMLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufNOMLineDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufNOMLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufNOMLineEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPINDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPINDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPINEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPINEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPINLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPINLineDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPINLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPINLineEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPORDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPORDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPOREnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPOREnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPORLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPORLineDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPORLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPORLineEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPPYDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPPYDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPPYEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPPYEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPPYLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPPYLineDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPPYLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPPYLineEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPQUDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPQUDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPQUEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPQUEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPQULineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPQULineDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufPQULineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPQULineEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSINDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSINDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSINEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSINEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSINLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSINLineDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSINLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSINLineEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSORDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSORDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSOREnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSOREnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSORLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSORLineDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSORLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSORLineEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSQUDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSQUDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSQUEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSQUEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSQULineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSQULineDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSQULineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSQULineEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSRCDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSRCDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSRCEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSRCEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSRCLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSRCLineDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSRCLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSRCLineEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufStockDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufStockDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufSuppDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSuppDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufTSHDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufTSHDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufTSHEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufTSHEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufTSHLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufTSHLineDesc10[FieldNo];
end;

{-----------------------------------------}
                             
function TCOMSetupUserFields.Get_ufTSHLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufTSHLineEnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufLineTypeEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufLineTypeEnabled[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufWORDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufWORDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufWOREnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufWOREnabled10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufWORLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufWORLineDesc10[FieldNo];
end;

{-----------------------------------------}

function TCOMSetupUserFields.Get_ufWORLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufWORLineEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufSRNDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSRNDesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufSRNEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSRNEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufSRNLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSRNLineDesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufSRNLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufSRNLineEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufPRNDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPRNDesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufPRNEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPRNEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufPRNLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPRNLineDesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufPRNLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields2(FD5Setup.ssUserFields).ufPRNLineEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufJCTDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJCTDesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufJCTEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJCTEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufJCTLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJCTLineDesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufJCTLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJCTLineEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufJPTDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJPTDesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufJPTEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJPTEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufJPTLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJPTLineDesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufJPTLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJPTLineEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufJSTDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJSTDesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufJSTEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJSTEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufJSTLineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJSTLineDesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufJSTLineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJSTLineEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufJPADesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJPADesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufJPAEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJPAEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufJPALineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJPALineDesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufJPALineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJPALineEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufJSADesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJSADesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufJSAEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJSAEnabled10[FieldNo];
end;

//------------------------------

function TCOMSetupUserFields.Get_ufJSALineDesc(FieldNo: Integer): WideString;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJSALineDesc10[FieldNo];
end;

function TCOMSetupUserFields.Get_ufJSALineEnabled(FieldNo: Integer): WordBool;
begin
  Result := TAbsUserFields3(FD5Setup.ssUserFields).ufJSALineEnabled10[FieldNo];
end;

//-------------------------------------------------------------------------

// MH 02/01/2015 v7.1 ABSEXCH-15855: ICOMSetupUserFields5 - Added Address Description Fields
function TCOMSetupUserFields.Get_ufAddressDesc(FieldNo: Integer): WideString;
Begin // Get_ufAddressDesc
  Result := TAbsUserFields4(FD5Setup.ssUserFields).ufAddressDesc[FieldNo];
End; // Get_ufAddressDesc

//-------------------------------------------------------------------------

// MH 02/01/2015 v7.1 ABSEXCH-15949: Extended to support Customer/Supplier Credit Card Fields (11-15)
function TCOMSetupUserFields.Get_ufCustDescEnabled(FieldNo: Integer): WordBool;
Begin // Get_ufCustDescEnabled
  Result := TAbsUserFields4(FD5Setup.ssUserFields).ufCustDescEnabled[FieldNo];
End; // Get_ufCustDescEnabled

function TCOMSetupUserFields.Get_ufSuppDescEnabled(FieldNo: Integer): WordBool;
Begin // Get_ufSuppDescEnabled
  Result := TAbsUserFields4(FD5Setup.ssUserFields).ufSuppDescEnabled[FieldNo];
End; // Get_ufSuppDescEnabled

{-------------------------------------------------------------------------------------------------}

Constructor TCOMSetupVAT.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMSetupVAT);

  FD5Setup := Nil;
End; { Create }

{-----------------------------------------}

Procedure TCOMSetupVAT.InitVAT(Const Idx : cuVATIndex; D5Setup : TAbsSetup);
Begin { InitVAT }
  FIdx := Idx;
  FD5Setup := D5Setup;
End; { InitVAT }

{-----------------------------------------}

function TCOMSetupVAT.Get_svCode: WideString;
Begin { Get_svCode }
  Result := FD5Setup.ssVATRates[FIdx].svCode;
End; { Get_svCode }

{-----------------------------------------}

function TCOMSetupVAT.Get_svDesc: WideString;
Begin { Get_svDesc }
  Result := FD5Setup.ssVATRates[FIdx].svDesc;
End; { Get_svDesc }

{-----------------------------------------}

function TCOMSetupVAT.Get_svRate: Double;
Begin { Get_svRate }
  Result := FD5Setup.ssVATRates[FIdx].svRate;
End; { Get_svRate }

{-----------------------------------------}

function TCOMSetupVAT.Get_svInclude: WordBool;
Begin { Get_svInclude }
  Result := FD5Setup.ssVATRates[FIdx].svInclude;
End; { Get_svInclude }

{-------------------------------------------------------------------------------------------------}

Constructor TCOMSetupCurrency.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMSetupCurrency);

  FD5Setup := Nil;
End; { Create }

{-----------------------------------------}

Procedure TCOMSetupCurrency.InitCurrency(Const Idx : SmallInt; D5Setup : TAbsSetup);
Begin { InitCurrency }
  FIdx := Idx;
  FD5Setup := D5Setup;
End; { InitCurrency }

{-----------------------------------------}

function TCOMSetupCurrency.Get_scSymbol: WideString;
Begin { Get_scSymbol }
  Result := FD5Setup.ssCurrency[FIdx].scSymbol;
End; { Get_scSymbol }

{-----------------------------------------}

function TCOMSetupCurrency.Get_scDesc: WideString;
Begin { Get_scDesc }
  Result := FD5Setup.ssCurrency[FIdx].scDesc;
End; { Get_scDesc }

{-----------------------------------------}

function TCOMSetupCurrency.Get_scCompanyRate: Double;
Begin { Get_scCompanyRate }
  Result := FD5Setup.ssCurrency[FIdx].scCompanyRate;
End; { Get_scCompanyRate }

{-----------------------------------------}

function TCOMSetupCurrency.Get_scDailyRate: Double;
Begin { Get_scDailyRate }
  Result := FD5Setup.ssCurrency[FIdx].scDailyRate;
End; { Get_scDailyRate }

{-----------------------------------------}

function TCOMSetupCurrency.Get_scPrintSymb: WideString;
Begin { Get_scPrintSymb }
  Result := FD5Setup.ssCurrency[FIdx].scPrintSymb;
End; { Get_scPrintSymb }

{-----------------------------------------}

function TCOMSetupCurrency.Get_scTriRate: Double;
Begin { Get_scTriRate }
  Result := FD5Setup.ssCurrency[FIdx].scTriRate;
End; { Get_scTriRate }

{-----------------------------------------}

function TCOMSetupCurrency.Get_scTriEuroCcy: SmallInt;
Begin { Get_scTriEuroCcy }
  Result := FD5Setup.ssCurrency[FIdx].scTriEuroCcy;
End; { Get_scTriEuroCcy }

{-----------------------------------------}

function TCOMSetupCurrency.Get_scTriInvert: WordBool;
Begin { Get_scTriInvert }
  Result := FD5Setup.ssCurrency[FIdx].scTriInvert;
End; { Get_scTriInvert }

{-----------------------------------------}

function TCOMSetupCurrency.Get_scTriFloating: WordBool;
Begin { Get_scTriFloating }
  Result := FD5Setup.ssCurrency[FIdx].scTriFloating;
End; { Get_scTriFloating }

{-------------------------------------------------------------------------------------------------}

Constructor TCOMSetup.Create;
Var
  I : SmallInt;
  J : cuVATIndex;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMSetup15);    //SS:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords

  FD5Setup := Nil;

  FCISSetupo := NIL;
  FCISSetupI := NIL;

  For I := Low(FCurrencyO) To High(FCurrencyO) Do Begin
    FCurrencyO[I] := Nil;
    FCurrencyI[I] := Nil;
  End; { For I }

  FJobCostingO := NIL;
  FJobCostingI := NIL;

  For J := Low(FVATO) To High(FVATO) Do Begin
    FVATO[J] := Nil;
    FVATI[J] := Nil;
  End; { For I }

  FPaperlessO := NIL;
  FPaperlessI := NIL;

  FUserFieldsO := Nil;
  FUserFieldsI := Nil;

  FGDPRO := Nil;
  FGDPRI := Nil;
End; { Create }

{-----------------------------------------}

Destructor TCOMSetup.Destroy;
Var
  I : SmallInt;
  J : cuVATIndex;
Begin { Destroy }
  { Destroy Sub Objects }
  For I := Low(FCurrencyO) To High(FCurrencyO) Do Begin
    FCurrencyO[I] := Nil;
    FCurrencyI[I] := Nil; { Setting Interface to Nil will cause Destroy if it was created }
  End; { For I }

  For J := Low(FVATO) To High(FVATO) Do Begin
    FVATO[J] := Nil;
    FVATI[J] := Nil; { Setting Interface to Nil will cause Destroy if it was created }
  End; { For I }

  FPaperlessO := NIL;
  FPaperlessI := NIL;

  FUserFieldsO := Nil;
  FUserFieldsI := Nil; { Setting Interface to Nil will cause Destroy if it was created }

  FD5Setup := Nil;

  Inherited Destroy;
End; { Destroy }


{-----------------------------------------}

Procedure TCOMSetup.InitSetup(D5Setup : TAbsSetup);
Var
  I : SmallInt;
  J : cuVATIndex;
Begin { InitSetup }
  FD5Setup := D5Setup As TAbsSetup15;   //SS:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords

  If Assigned(FCISSetupO) Then
    FCISSetupO.InitSetup(FD5Setup.ssCISSetup As TAbsCISSetup2);

  If Assigned(FJobCostingO) Then
    FJobCostingO.InitSetup(FD5Setup.ssJobCosting);

  { Re-Initialise any allocated Currency objects }
  For I := Low(FCurrencyO) To High(FCurrencyO) Do
    If Assigned(FCurrencyO[I]) Then
      FCurrencyO[I].InitCurrency (I, FD5Setup);

  { Re-Initialise any allocated VAT objects }
  For J := Low(FVATO) To High(FVATO) Do
    If Assigned(FVATO[J]) Then
      FVATO[J].InitVAT(J, FD5Setup);

  { Re-Initialise any allocated VAT objects }
  If Assigned(FUserFieldsO) Then
    FUserFieldsO.InitUserFields(FD5Setup);

  { Re-Initialise any allocated GDPR objects }
  If Assigned(FGDPRO) Then
    FGDPRO.InitGDPR(FD5Setup);
End; { InitSetup }

{-----------------------------------------}

function TCOMSetup.Get_ssPrinYr: SmallInt;
Begin { Get_ssPrinYr }
  Result := FD5Setup.ssPrinYr;
End; { Get_ssPrinYr }

{-----------------------------------------}

function TCOMSetup.Get_ssUserName: WideString;
Begin { Get_ssUserName }
  Result := FD5Setup.ssUserName;
End; { Get_ssUserName }

{-----------------------------------------}

function TCOMSetup.Get_ssAuditYr: SmallInt;
Begin { Get_ssAuditYr }
  Result := FD5Setup.ssAuditYr;
End; { Get_ssAuditYr }

{-----------------------------------------}

function TCOMSetup.Get_ssManROCP: WordBool;
Begin { Get_ssManROCP }
  Result := FD5Setup.ssManROCP;
End; { Get_ssManROCP }

{-----------------------------------------}

function TCOMSetup.Get_ssVATCurr: SmallInt;
Begin { Get_ssVATCurr }
  Result := FD5Setup.ssVATCurr;
End; { Get_ssVATCurr }

{-----------------------------------------}

function TCOMSetup.Get_ssNoCosDec: SmallInt;
Begin { Get_ssNoCosDec }
  Result := FD5Setup.ssNoCosDec;
End; { Get_ssNoCosDec }

{-----------------------------------------}

function TCOMSetup.Get_ssCurrBase: SmallInt;
Begin { Get_ssCurrBase }
  Result := FD5Setup.ssCurrBase;
End; { Get_ssCurrBase }

{-----------------------------------------}

function TCOMSetup.Get_ssShowStkGP: WordBool;
Begin { Get_ssShowStkGP }
  Result := FD5Setup.ssShowStkGP;
End; { Get_ssShowStkGP }

{-----------------------------------------}

function TCOMSetup.Get_ssAutoValStk: WordBool;
Begin { Get_ssAutoValStk }
  Result := FD5Setup.ssAutoValStk;
End; { Get_ssAutoValStk }

{-----------------------------------------}

function TCOMSetup.Get_ssDelPickOnly: WordBool;
Begin { Get_ssDelPickOnly }
  Result := FD5Setup.ssDelPickOnly;
End; { Get_ssDelPickOnly }

{-----------------------------------------}

function TCOMSetup.Get_ssUseMLoc: WordBool;
Begin { Get_ssUseMLoc }
  Result := FD5Setup.ssUseMLoc;
End; { Get_ssUseMLoc }

{-----------------------------------------}

function TCOMSetup.Get_ssEditSinSer: WordBool;
Begin { Get_ssEditSinSer }
  Result := FD5Setup.ssEditSinSer;
End; { Get_ssEditSinSer }

{-----------------------------------------}

function TCOMSetup.Get_ssWarnYRef: WordBool;
Begin { Get_ssWarnYRef }
  Result := FD5Setup.ssWarnYRef;
End; { Get_ssWarnYRef }

{-----------------------------------------}

function TCOMSetup.Get_ssUseLocDel: WordBool;
Begin { Get_ssUseLocDel }
  Result := FD5Setup.ssUseLocDel;
End; { Get_ssUseLocDel }

{-----------------------------------------}

function TCOMSetup.Get_ssPostCCGL: WordBool;
Begin { Get_ssPostCCGL }
  Result := FD5Setup.ssPostCCGL;
End; { Get_ssPostCCGL }

{-----------------------------------------}

function TCOMSetup.Get_ssAlTolVal: Double;
Begin { Get_ssAlTolVal }
  Result := FD5Setup.ssAlTolVal;
End; { Get_ssAlTolVal }

{-----------------------------------------}

function TCOMSetup.Get_ssAlTolMode: SmallInt;
Begin { Get_ssAlTolMode }
  Result := FD5Setup.ssAlTolMode;
End; { Get_ssAlTolMode }

{-----------------------------------------}

function TCOMSetup.Get_ssDebtLMode: SmallInt;
Begin { Get_ssDebtLMode }
  Result := FD5Setup.ssDebtLMode;
End; { Get_ssDebtLMode }

{-----------------------------------------}

function TCOMSetup.Get_ssAutoGenVar: WordBool;
Begin { Get_ssAutoGenVar }
  Result := FD5Setup.ssAutoGenVar;
End; { Get_ssAutoGenVar }

{-----------------------------------------}

function TCOMSetup.Get_ssAutoGenDisc: WordBool;
Begin { Get_ssAutoGenDisc }
  Result := FD5Setup.ssAutoGenDisc;
End; { Get_ssAutoGenDisc }

{-----------------------------------------}

function TCOMSetup.Get_ssUSRCntryCode: WideString;
Begin { Get_ssUSRCntryCode }
  Result := FD5Setup.ssUSRCntryCode;
End; { Get_ssUSRCntryCode }

{-----------------------------------------}

function TCOMSetup.Get_ssNoNetDec: SmallInt;
Begin { Get_ssNoNetDec }
  Result := FD5Setup.ssNoNetDec;
End; { Get_ssNoNetDec }

{-----------------------------------------}

function TCOMSetup.Get_ssNoInvLines: SmallInt;
Begin { Get_ssNoInvLines }
  Result := FD5Setup.ssNoInvLines;
End; { Get_ssNoInvLines }

{-----------------------------------------}

function TCOMSetup.Get_ssWksODue: SmallInt;
Begin { Get_ssWksODue }
  Result := FD5Setup.ssWksODue;
End; { Get_ssWksODue }

{-----------------------------------------}

function TCOMSetup.Get_ssCPr: SmallInt;
Begin { Get_ssCPr }
  Result := FD5Setup.ssCPr;
End; { Get_ssCPr }

{-----------------------------------------}

function TCOMSetup.Get_ssCYr: SmallInt;
Begin { Get_ssCYr }
  Result := FD5Setup.ssCYr;
End; { Get_ssCYr }

{-----------------------------------------}

function TCOMSetup.Get_ssTradeTerm: WordBool;
Begin { Get_ssTradeTerm }
  Result := FD5Setup.ssTradeTerm;
End; { Get_ssTradeTerm }

{-----------------------------------------}

function TCOMSetup.Get_ssStaSepCr: WordBool;
Begin { Get_ssStaSepCr }
  Result := FD5Setup.ssStaSepCr;
End; { Get_ssStaSepCr }

{-----------------------------------------}

function TCOMSetup.Get_ssStaAgeMthd: SmallInt;
Begin { Get_ssStaAgeMthd }
  Result := FD5Setup.ssStaAgeMthd;
End; { Get_ssStaAgeMthd }

{-----------------------------------------}

function TCOMSetup.Get_ssStaUIDate: WordBool;
Begin { Get_ssStaUIDate }
  Result := FD5Setup.ssStaUIDate;
End; { Get_ssStaUIDate }

{-----------------------------------------}

function TCOMSetup.Get_ssQUAllocFlg: WordBool;
Begin { Get_ssQUAllocFlg }
  Result := FD5Setup.ssQUAllocFlg;
End; { Get_ssQUAllocFlg }

{-----------------------------------------}

function TCOMSetup.Get_ssDeadBOM: WordBool;
Begin { Get_ssDeadBOM }
  Result := FD5Setup.ssDeadBOM;
End; { Get_ssDeadBOM }

{-----------------------------------------}

function TCOMSetup.Get_ssAuthMode: WideString;
Begin { Get_ssAuthMode }
  Result := FD5Setup.ssAuthMode;
End; { Get_ssAuthMode }

{-----------------------------------------}

function TCOMSetup.Get_ssIntraStat: WordBool;
Begin { Get_ssIntraStat }
  Result := FD5Setup.ssIntraStat;
End; { Get_ssIntraStat }

{-----------------------------------------}

function TCOMSetup.Get_ssAnalStkDesc: WordBool;
Begin { Get_ssAnalStkDesc }
  Result := FD5Setup.ssAnalStkDesc;
End; { Get_ssAnalStkDesc }

{-----------------------------------------}

function TCOMSetup.Get_ssAutoStkVal: WideString;
Begin { Get_ssAutoStkVal }
  Result := FD5Setup.ssAutoStkVal;
End; { Get_ssAutoStkVal }

{-----------------------------------------}

function TCOMSetup.Get_ssAutoBillUp: WordBool;
Begin { Get_ssAutoBillUp }
  Result := FD5Setup.ssAutoBillUp;
End; { Get_ssAutoBillUp }

{-----------------------------------------}

function TCOMSetup.Get_ssAutoCQNo: WordBool;
Begin { Get_ssAutoCQNo }
  Result := FD5Setup.ssAutoCQNo;
End; { Get_ssAutoCQNo }

{-----------------------------------------}

function TCOMSetup.Get_ssIncNotDue: WordBool;
Begin { Get_ssIncNotDue }
  Result := FD5Setup.ssIncNotDue;
End; { Get_ssIncNotDue }

{-----------------------------------------}

function TCOMSetup.Get_ssUseBatchTot: WordBool;
Begin { Get_ssUseBatchTot }
  Result := FD5Setup.ssUseBatchTot;
End; { Get_ssUseBatchTot }

{-----------------------------------------}

function TCOMSetup.Get_ssUseStock: WordBool;
Begin { Get_ssUseStock }
  Result := FD5Setup.ssUseStock;
End; { Get_ssUseStock }

{-----------------------------------------}

function TCOMSetup.Get_ssAutoNotes: WordBool;
Begin { Get_ssAutoNotes }
  Result := FD5Setup.ssAutoNotes;
End; { Get_ssAutoNotes }

{-----------------------------------------}

function TCOMSetup.Get_ssHideMenuOpt: WordBool;
Begin { Get_ssHideMenuOpt }
  Result := FD5Setup.ssHideMenuOpt;
End; { Get_ssHideMenuOpt }

{-----------------------------------------}

function TCOMSetup.Get_ssUseCCDep: WordBool;
Begin { Get_ssUseCCDep }
  Result := FD5Setup.ssUseCCDep;
End; { Get_ssUseCCDep }

{-----------------------------------------}

function TCOMSetup.Get_ssNoHoldDisc: WordBool;
Begin { Get_ssNoHoldDisc }
  Result := FD5Setup.ssNoHoldDisc;
End; { Get_ssNoHoldDisc }

{-----------------------------------------}

function TCOMSetup.Get_ssAutoPrCalc: WordBool;
Begin { Get_ssAutoPrCalc }
  Result := FD5Setup.ssAutoPrCalc;
End; { Get_ssAutoPrCalc }

{-----------------------------------------}

function TCOMSetup.Get_ssStopBadDr: WordBool;
Begin { Get_ssStopBadDr }
  Result := FD5Setup.ssStopBadDr;
End; { Get_ssStopBadDr }

{-----------------------------------------}

function TCOMSetup.Get_ssUsePayIn: WordBool;
Begin { Get_ssUsePayIn }
  Result := FD5Setup.ssUsePayIn;
End; { Get_ssUsePayIn }

{-----------------------------------------}

function TCOMSetup.Get_ssUsePasswords: WordBool;
Begin { Get_ssUsePasswords }
  Result := FD5Setup.ssUsePasswords;
End; { Get_ssUsePasswords }

{-----------------------------------------}

function TCOMSetup.Get_ssPrintReciept: WordBool;
Begin { Get_ssPrintReciept }
  Result := FD5Setup.ssPrintReciept;
End; { Get_ssPrintReciept }

{-----------------------------------------}

function TCOMSetup.Get_ssExternCust: WordBool;
Begin { Get_ssExternCust }
  Result := FD5Setup.ssExternCust;
End; { Get_ssExternCust }

{-----------------------------------------}

function TCOMSetup.Get_ssNoQtyDec: SmallInt;
Begin { Get_ssNoQtyDec }
  Result := FD5Setup.ssNoQtyDec;
End; { Get_ssNoQtyDec }

{-----------------------------------------}

function TCOMSetup.Get_ssExternSIN: WordBool;
Begin { Get_ssExternSIN }
  Result := FD5Setup.ssExternSIN;
End; { Get_ssExternSIN }

{-----------------------------------------}

function TCOMSetup.Get_ssPrevPrOff: WordBool;
Begin { Get_ssPrevPrOff }
  Result := FD5Setup.ssPrevPrOff;
End; { Get_ssPrevPrOff }

{-----------------------------------------}

function TCOMSetup.Get_ssDefPcDisc: WordBool;
Begin { Get_ssDefPcDisc }
  Result := FD5Setup.ssDefPcDisc;
End; { Get_ssDefPcDisc }

{-----------------------------------------}

function TCOMSetup.Get_ssTradCodeNum: WordBool;
Begin { Get_ssTradCodeNum }
  Result := FD5Setup.ssTradCodeNum;
End; { Get_ssTradCodeNum }

{-----------------------------------------}

function TCOMSetup.Get_ssUpBalOnPost: WordBool;
Begin { Get_ssUpBalOnPost }
  Result := FD5Setup.ssUpBalOnPost;
End; { Get_ssUpBalOnPost }

{-----------------------------------------}

function TCOMSetup.Get_ssShowInvDisc: WordBool;
Begin { Get_ssShowInvDisc }
  Result := FD5Setup.ssShowInvDisc;
End; { Get_ssShowInvDisc }

{-----------------------------------------}

function TCOMSetup.Get_ssSepDiscounts: WordBool;
Begin { Get_ssSepDiscounts }
  Result := FD5Setup.ssSepDiscounts;
End; { Get_ssSepDiscounts }

{-----------------------------------------}

function TCOMSetup.Get_ssUseCreditChk: WordBool;
Begin { Get_ssUseCreditChk }
  Result := FD5Setup.ssUseCreditChk;
End; { Get_ssUseCreditChk }

{-----------------------------------------}

function TCOMSetup.Get_ssUseCRLimitChk: WordBool;
Begin { Get_ssUseCRLimitChk }
  Result := FD5Setup.ssUseCRLimitChk;
End; { Get_ssUseCRLimitChk }

{-----------------------------------------}

function TCOMSetup.Get_ssAutoClearPay: WordBool;
Begin { Get_ssAutoClearPay }
  Result := FD5Setup.ssAutoClearPay;
End; { Get_ssAutoClearPay }

{-----------------------------------------}

function TCOMSetup.Get_ssTotalConv: WideString;
Begin { Get_ssTotalConv }
  Result := FD5Setup.ssTotalConv;
End; { Get_ssTotalConv }

{-----------------------------------------}

function TCOMSetup.Get_ssDispPrAsMonths: WordBool;
Begin { Get_ssDispPrAsMonths }
  Result := FD5Setup.ssDispPrAsMonths;
End; { Get_ssDispPrAsMonths }

{-----------------------------------------}

function TCOMSetup.Get_ssDirectCust: WideString;
Begin { Get_ssDirectCust }
  Result := FD5Setup.ssDirectCust;
End; { Get_ssDirectCust }

{-----------------------------------------}

function TCOMSetup.Get_ssDirectSupp: WideString;
Begin { Get_ssDirectSupp }
  Result := FD5Setup.ssDirectSupp;
End; { Get_ssDirectSupp }

{-----------------------------------------}

function TCOMSetup.Get_ssGLPayFrom: Integer;
Begin { Get_ssGLPayFrom }
  Result := FD5Setup.ssGLPayFrom;
End; { Get_ssGLPayFrom }

{-----------------------------------------}

function TCOMSetup.Get_ssGLPayToo: Integer;
Begin { Get_ssGLPayToo }
  Result := FD5Setup.ssGLPayToo;
End; { Get_ssGLPayToo }

{-----------------------------------------}

function TCOMSetup.Get_ssSettleDisc: Double;
Begin { Get_ssSettleDisc }
  Result := FD5Setup.ssSettleDisc;
End; { Get_ssSettleDisc }

{-----------------------------------------}

function TCOMSetup.Get_ssSettleDays: SmallInt;
Begin { Get_ssSettleDays }
  Result := FD5Setup.ssSettleDays;
End; { Get_ssSettleDays }

{-----------------------------------------}

function TCOMSetup.Get_ssNeedBMUp: WordBool;
Begin { Get_ssNeedBMUp }
  Result := FD5Setup.ssNeedBMUp;
End; { Get_ssNeedBMUp }

{-----------------------------------------}

function TCOMSetup.Get_ssInpPack: WordBool;
Begin { Get_ssInpPack }
  Result := FD5Setup.ssInpPack;
End; { Get_ssInpPack }

{-----------------------------------------}

function TCOMSetup.Get_ssVATCode: WideString;
Begin { Get_ssVATCode }
  Result := FD5Setup.ssVATCode;
End; { Get_ssVATCode }

{-----------------------------------------}

function TCOMSetup.Get_ssPayTerms: SmallInt;
Begin { Get_ssPayTerms }
  Result := FD5Setup.ssPayTerms;
End; { Get_ssPayTerms }

{-----------------------------------------}

function TCOMSetup.Get_ssStaAgeInt: SmallInt;
Begin { Get_ssStaAgeInt }
  Result := FD5Setup.ssStaAgeInt;
End; { Get_ssStaAgeInt }

{-----------------------------------------}

function TCOMSetup.Get_ssQuoOwnDate: WordBool;
Begin { Get_ssQuoOwnDate }
  Result := FD5Setup.ssQuoOwnDate;
End; { Get_ssQuoOwnDate }

{-----------------------------------------}

function TCOMSetup.Get_ssFreeExAll: WordBool;
Begin { Get_ssFreeExAll }
  Result := FD5Setup.ssFreeExAll;
End; { Get_ssFreeExAll }

{-----------------------------------------}

function TCOMSetup.Get_ssDirOwnCount: WordBool;
Begin { Get_ssDirOwnCount }
  Result := FD5Setup.ssDirOwnCount;
End; { Get_ssDirOwnCount }

{-----------------------------------------}

function TCOMSetup.Get_ssStaShowOS: WordBool;
Begin { Get_ssStaShowOS }
  Result := FD5Setup.ssStaShowOS;
End; { Get_ssStaShowOS }

{-----------------------------------------}

function TCOMSetup.Get_ssLiveCredS: WordBool;
Begin { Get_ssLiveCredS }
  Result := FD5Setup.ssLiveCredS;
End; { Get_ssLiveCredS }

{-----------------------------------------}

function TCOMSetup.Get_ssBatchPPY: WordBool;
Begin { Get_ssBatchPPY }
  Result := FD5Setup.ssBatchPPY;
End; { Get_ssBatchPPY }

{-----------------------------------------}

function TCOMSetup.Get_ssWarnJC: WordBool;
Begin { Get_ssWarnJC }
  Result := FD5Setup.ssWarnJC;
End; { Get_ssWarnJC }

{-----------------------------------------}

function TCOMSetup.Get_ssDefBankGL: Integer;
Begin { Get_ssDefBankGL }
  Result := FD5Setup.ssDefBankGL;
End; { Get_ssDefBankGL }

{-----------------------------------------}

function TCOMSetup.Get_ssUseDefBank: WordBool;
Begin { Get_ssUseDefBank }
  Result := FD5Setup.ssUseDefBank;
End; { Get_ssUseDefBank }

{-----------------------------------------}

function TCOMSetup.Get_ssMonWk1: WideString;
Begin { Get_ssMonWk1 }
  Result := FD5Setup.ssMonWk1;
End; { Get_ssMonWk1 }

{-----------------------------------------}

function TCOMSetup.Get_ssAuditDate: WideString;
Begin { Get_ssAuditDate }
  Result := FD5Setup.ssAuditDate;
End; { Get_ssAuditDate }

{-----------------------------------------}

function TCOMSetup.Get_ssUserSort: WideString;
Begin { Get_ssUserSort }
  Result := FD5Setup.ssUserSort;
End; { Get_ssUserSort }

{-----------------------------------------}

function TCOMSetup.Get_ssUserAcc: WideString;
Begin { Get_ssUserAcc }
  Result := FD5Setup.ssUserAcc;
End; { Get_ssUserAcc }

{-----------------------------------------}

function TCOMSetup.Get_ssUserRef: WideString;
Begin { Get_ssUserRef }
  Result := FD5Setup.ssUserRef;
End; { Get_ssUserRef }

{-----------------------------------------}

function TCOMSetup.Get_ssUserBank: WideString;
Begin { Get_ssUserBank }
  Result := FD5Setup.ssUserBank;
End; { Get_ssUserBank }

{-----------------------------------------}

function TCOMSetup.Get_ssLastExpFolio: Integer;
Begin { Get_ssLastExpFolio }
  Result := FD5Setup.ssLastExpFolio;
End; { Get_ssLastExpFolio }

{-----------------------------------------}

function TCOMSetup.Get_ssDetailTel: WideString;
Begin { Get_ssDetailTel }
  Result := FD5Setup.ssDetailTel;
End; { Get_ssDetailTel }

{-----------------------------------------}

function TCOMSetup.Get_ssDetailFax: WideString;
Begin { Get_ssDetailFax }
  Result := FD5Setup.ssDetailFax;
End; { Get_ssDetailFax }

{-----------------------------------------}

function TCOMSetup.Get_ssUserVATReg: WideString;
Begin { Get_ssUserVATReg }
  Result := FD5Setup.ssUserVATReg;
End; { Get_ssUserVATReg }

{-----------------------------------------}

function TCOMSetup.Get_ssDataPath: WideString;
Begin { Get_ssDataPath }
  Result := FD5Setup.ssDataPath;
End; { Get_ssDataPath }

{-----------------------------------------}

function TCOMSetup.Get_ssDetailAddr(Index: Integer): WideString;
Begin { Get_ssDetailAddr }
  Result := FD5Setup.ssDetailAddr[Index];
End; { Get_ssDetailAddr }

{-----------------------------------------}

function TCOMSetup.Get_ssGLCtrlCodes(Index: TNomCtrlType): Integer;
Begin { Get_ssGLCtrlCodes }
  Result := FD5Setup.ssGLCtrlCodes[cuNomCtrlType(Ord(Index))];
End; { Get_ssGLCtrlCodes }

{-----------------------------------------}

function TCOMSetup.Get_ssDebtChaseDays(Index: Integer): Smallint;
Begin { Get_ssDebtChaseDays }
  Result := FD5Setup.ssDebtChaseDays[Index];
End; { Get_ssDebtChaseDays }

{-----------------------------------------}

function TCOMSetup.Get_ssTermsofTrade(Index: TTermsIndex): WideString;
Begin { Get_ssTermsofTrade }
  Result := FD5Setup.ssTermsofTrade[Index];
End; { Get_ssTermsofTrade }

{-----------------------------------------}

function TCOMSetup.Get_ssWORAllocStockOnPick: WordBool;
Begin { Get_ssTermsofTrade }
  Result := FD5Setup.ssWORAllocStockOnPick;
End; { Get_ssTermsofTrade }

{-----------------------------------------}

function TCOMSetup.Get_ssWOPDisableWIP: WordBool;
Begin { Get_ssTermsofTrade }
  Result := FD5Setup.ssWOPDisableWIP;
End; { Get_ssTermsofTrade }

{-----------------------------------------}

function TCOMSetup.Get_ssWORCopyStkNotes: Integer;
Begin { Get_ssTermsofTrade }
  Result := FD5Setup.ssWORCopyStkNotes;
End; { Get_ssTermsofTrade }

{-----------------------------------------}

function TCOMSetup.Get_ssFilterSNoByBinLoc: WordBool;
Begin { Get_ssFilterSNoByBinLoc }
  Result := FD5Setup.ssFilterSNoByBinLoc;
End; { Get_ssFilterSNoByBinLoc }

function TCOMSetup.Get_ssKeepBinHistory: WordBool;
Begin { Get_ssKeepBinHistory }
  Result := FD5Setup.ssKeepBinHistory;
End; { Get_ssKeepBinHistory }

function TCOMSetup.Get_ssBinMask: WideString;
Begin { Get_ssBinMask }
  Result := FD5Setup.ssBinMask;
End; { Get_ssBinMask }

//------------------------------

function TCOMSetup.Get_ssGetConnectInfo: WideString;
Begin // Get_ssGetConnectInfo
  Result := FD5Setup.ssConnectInfo;
End; // Get_ssGetConnectInfo

//------------------------------

function TCOMSetup.Get_ssUseTransactionTotalDiscounts: WordBool;
Begin // Get_ssUseTransactionTotalDiscounts
  Result := FD5Setup.ssUseTransactionTotalDiscounts;
End; // Get_ssUseTransactionTotalDiscounts

//------------------------------

function TCOMSetup.Get_ssUseValueBasedDiscounts: WordBool;
Begin // Get_ssUseValueBasedDiscounts
  Result := FD5Setup.ssUseValueBasedDiscounts;
End; // Get_ssUseValueBasedDiscounts

//------------------------------

function TCOMSetup.Get_ssEnableECServices: WordBool;
Begin // Get_ssEnableECServices
  Result := FD5Setup.ssEnableECServices;
End; // Get_ssEnableECServices

//------------------------------

function TCOMSetup.Get_ssECSalesThreshold: Double;
Begin // Get_ssECSalesThreshold
  Result := FD5Setup.ssECSalesThreshold;
End; // Get_ssECSalesThreshold

//------------------------------

// ICOMSetup8
function TCOMSetup.Get_ssCompanyCode: WideString;
Begin // Get_ssCompanyCode
  Result := FD5Setup.ssCompanyCode;
End; // Get_ssCompanyCode

//------------------------------

// ICOMSetup9
function TCOMSetup.Get_ssEnableOverrideLocation: WordBool;
Begin // Get_ssCompanyCode
  Result := FD5Setup.ssEnableOverrideLocation;
End; // Get_ssCompanyCode

//------------------------------

// ICOMSetup10
function TCOMSetup.Get_ssBankAccountCode: WideString;
Begin // Get_ssBankAccountCode
  Result := FD5Setup.ssBankAccountCode;
End; // Get_ssBankAccountCode

//------------------------------

// ICOMSetup10
function TCOMSetup.Get_ssBankSortCode: WideString;
Begin // Get_ssBankSortCode
  Result := FD5Setup.ssBankSortCode;
End; // Get_ssBankSortCode

//-------------------------------------------------------------------------

// ICOMSetup11 MH 26/11/2013 v7.0.8
function TCOMSetup.Get_ssConsumersEnabled: WordBool;
Begin // Get_ssConsumersEnabled
  Result := FD5Setup.ssConsumersEnabled;
End; // Get_ssConsumersEnabled

//-------------------------------------------------------------------------

// ICOMSetup12 MH 22/09/2014 Order Payments
function TCOMSetup.Get_ssOrderPaymentsEnabled: WordBool;
Begin // Get_ssOrderPaymentsEnabled
  Result := TAbsSetup12(FD5Setup).ssOrderPaymentsEnabled;
End; // Get_ssOrderPaymentsEnabled

//-------------------------------------------------------------------------

function TCOMSetup.Get_ssPaperless: ICOMSetupPaperless;
Begin { Get_ssPaperless }
  If (Not Assigned(FPaperlessO)) Then Begin
    { Create and initialise Currency Details }
    FPaperlessO := TComSetupPaperless.Create;
    FPaperlessO.InitPaperless(FD5Setup);

    FPaperlessI := FPaperlessO;
  End; { If (Not Assigned(FPaperlessO)) }

  Result := FPaperlessO;
End; { Get_ssPaperless }

{-----------------------------------------}

function TCOMSetup.Get_ssCurrency(Index: TCurrencyType): ICOMSetupCurrency;
Begin { Get_ssCurrency }
  If (Not Assigned(FCurrencyO[Index])) Then Begin
    { Create and initialise Currency Details }
    FCurrencyO[Index] := TComSetupCurrency.Create;
    FCurrencyO[Index].InitCurrency(Index, FD5Setup);

    FCurrencyI[Index] := FCurrencyO[Index];
  End; { If (Not Assigned(FCurrencyO[Index])) }

  Result := FCurrencyI[Index];
End; { Get_ssCurrency }

{-----------------------------------------}

function TCOMSetup.Get_ssVATRates(Index: TVATIndex): ICOMSetupVAT;
Var
  Idx : cuVATIndex;
Begin { Get_ssVATRates }
  Idx := cuVATIndex(Ord(Index));

  If (Not Assigned(FVATO[Idx])) Then Begin
    { Create and initialise Currency Details }
    FVATO[Idx] := TComSetupVAT.Create;
    FVATO[Idx].InitVAT(Idx, FD5Setup);

    FVATI[Idx] := FVATO[Idx];
  End; { If (Not Assigned(FVATO[Index])) }

  Result := FVATO[Idx];
End; { Get_ssVATRates }

{-----------------------------------------}

function TCOMSetup.Get_ssUserFields: ICOMSetupUserFields;
Begin { Get_ssUserFields }
  If (Not Assigned(FUserFieldsO)) Then Begin
    { Create and initialise Currency Details }
    FUserFieldsO := TComSetupUserFields.Create;
    FUserFieldsO.InitUserFields(FD5Setup);

    FUserFieldsI := FUserFieldsO;
  End; { If (Not Assigned(FUserFieldsO)) }

  Result := FUserFieldsI;
End; { Get_ssUserFields }

//------------------------------

function TCOMSetup.Get_ssCISSetup: ICOMSetupCIS;
Begin
  If (Not Assigned(FCISSetupO)) Then Begin
    { Create and initialise CIS Setup Details }
    FCISSetupO := TCOMSetupCIS.Create;
    FCISSetupO.InitSetup(FD5Setup.ssCISSetup As TAbsCISSetup2);

    FCISSetupI := FCISSetupO;
  End; { If (Not Assigned(FCISSetupO)) }

  Result := FCISSetupI;
End;

//------------------------------

function TCOMSetup.Get_ssJobCosting: ICOMSetupJobCosting;
Begin
  If (Not Assigned(FJobCostingO)) Then Begin
    { Create and initialise Job costing Details }
    FJobCostingO := TCOMSetupJobCosting.Create;
    FJobCostingO.InitSetup(FD5Setup.ssJobCosting);

    FJobCostingI := FJobCostingO;
  End; { If (Not Assigned(FJobCostingO)) }

  Result := FJobCostingI;
End;

{-------------------------------------------------------------------------------------------------}

{ TCOMSetupPaperless }

constructor TCOMSetupPaperless.Create;
begin
  Inherited Create (ComServer.TypeLib, ICOMSetupPaperless);

  FD5Setup := Nil;
end;

destructor TCOMSetupPaperless.Destroy;
begin
  Inherited Destroy;
end;

{-----------------------------------------}

function TCOMSetupPaperless.Get_ssAttachMethod: Integer;
begin
  Result := FD5Setup.ssPaperless.ssAttachMethod;
end;

{-----------------------------------------}

function TCOMSetupPaperless.Get_ssAttachPrinter: WideString;
begin
  Result := TAbsPaperlessSetup2(FD5Setup.ssPaperless).ssAttachPrinter50;
end;

{-----------------------------------------}

function TCOMSetupPaperless.Get_ssDefaultEmailPriority: Integer;
begin
  Result := FD5Setup.ssPaperless.ssDefaultEmailPriority;
end;

{-----------------------------------------}

function TCOMSetupPaperless.Get_ssEmailUseMAPI: WordBool;
begin
  Result := FD5Setup.ssPaperless.ssEmailUseMAPI;
end;

{-----------------------------------------}

function TCOMSetupPaperless.Get_ssFaxFromName: WideString;
begin
  Result := FD5Setup.ssPaperless.ssFaxFromName;
end;

{-----------------------------------------}

function TCOMSetupPaperless.Get_ssFaxFromTelNo: WideString;
begin
  Result := FD5Setup.ssPaperless.ssFaxFromTelNo;
end;

{-----------------------------------------}

function TCOMSetupPaperless.Get_ssFaxInterfacePath: WideString;
begin
  Result := FD5Setup.ssPaperless.ssFaxInterfacePath;
end;

{-----------------------------------------}

function TCOMSetupPaperless.Get_ssFaxPrinter: WideString;
begin
  Result := TAbsPaperlessSetup2(FD5Setup.ssPaperless).ssFaxPrinter50;
end;

{-----------------------------------------}

function TCOMSetupPaperless.Get_ssFaxUsing: Integer;
begin
  Result := FD5Setup.ssPaperless.ssFaxUsing;
end;

{-----------------------------------------}

function TCOMSetupPaperless.Get_ssSMTPServer: WideString;
begin
  Result := FD5Setup.ssPaperless.ssSMTPServer;
end;

{-----------------------------------------}

function TCOMSetupPaperless.Get_ssYourEmailAddress: WideString;
begin
  Result := FD5Setup.ssPaperless.ssYourEmailAddress;
end;

{-----------------------------------------}

function TCOMSetupPaperless.Get_ssYourEmailName: WideString;
begin
  Result := FD5Setup.ssPaperless.ssYourEmailName;
end;

{-----------------------------------------}

procedure TCOMSetupPaperless.InitPaperless(D5Setup: TAbsSetup);
begin
  FD5Setup := D5Setup;
end;

//-------------------------------------------------------------------------

function TCOMSetup.Get_ssCurrencyImportTolerance: Single;
begin
  Result := SystemSetup.CurrencySetup.ssCurrImportTol;
end;

//AP 04/12/2017 2018R1 ABSEXCH-19401: GDPR (POST 19344) - 8.3.1.1.3 - DLL + COM Customisation Support
function TCOMSetup.Get_ssGDPR: ICOMSetupGDPR;
Begin { Get_ssGDPR }
  If (Not Assigned(FGDPRO)) Then Begin
    { Create and initialise GDPR Details }
    FGDPRO := TCOMSetupGDPR.Create;
    FGDPRO.InitGDPR(FD5Setup);

    FGDPRI := FGDPRO;
  End; { If (Not Assigned(FGDPRO)) }

  Result := FGDPRI;
End; { Get_ssGDPR }

Constructor TCOMSetupGDPR.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMSetupGDPR);

  FD5Setup := Nil;
End; { Create }

{-----------------------------------------}

Procedure TCOMSetupGDPR.InitGDPR(D5Setup : TAbsSetup13);
Begin { InitGDPR }
  FD5Setup := D5Setup;
End; { InitGDPR }

{-----------------------------------------}

function  TCOMSetupGDPR.Get_Anonymised: WordBool;
begin
  Result := FD5Setup.ssGDPR.Anonymised;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_AnonymisedDate: WideString;
begin
  Result := FD5Setup.ssGDPR.AnonymisedDate;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_AnonymisedTime: WideString;
begin
  Result := FD5Setup.ssGDPR.AnonymisedTime;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPRTraderRetentionPeriod: Integer;
begin
  Result := FD5Setup.ssGDPR.GDPRTraderRetentionPeriod;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPRTraderDisplayPIITree: WordBool;
begin
  Result := FD5Setup.ssGDPR.GDPRTraderDisplayPIITree;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPRTraderAnonNotesOption: Integer;
begin
  Result := FD5Setup.ssGDPR.GDPRTraderAnonNotesOption;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPRTraderAnonLettersOption: Integer;
begin
  Result := FD5Setup.ssGDPR.GDPRTraderAnonLettersOption;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPRTraderAnonLinksOption: Integer;
begin
  Result := FD5Setup.ssGDPR.GDPRTraderAnonLinksOption;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPREmployeeRetentionPeriod: Integer;
begin
  Result := FD5Setup.ssGDPR.GDPREmployeeRetentionPeriod;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPREmployeeDisplayPIITree: WordBool;
begin
  Result := FD5Setup.ssGDPR.GDPREmployeeDisplayPIITree;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPREmployeeAnonNotesOption: Integer;
begin
  Result := FD5Setup.ssGDPR.GDPREmployeeAnonNotesOption;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPREmployeeAnonLettersOption: Integer;
begin
  Result := FD5Setup.ssGDPR.GDPREmployeeAnonLettersOption;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPREmployeeAnonLinksOption: Integer;
begin
  Result := FD5Setup.ssGDPR.GDPREmployeeAnonLinksOption;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_NotificationWarningColour: Integer;
begin
  Result := FD5Setup.ssGDPR.NotificationWarningColour;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_NotificationWarningFontColour: Integer;
begin
  Result := FD5Setup.ssGDPR.NotificationWarningFontColour;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPRCompanyAnonLocations: WordBool;
begin
  Result := FD5Setup.ssGDPR.GDPRCompanyAnonLocations;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPRCompanyAnonCostCentres: WordBool;
begin
  Result := FD5Setup.ssGDPR.GDPRCompanyAnonCostCentres;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPRCompanyAnonDepartment: WordBool;
begin
  Result := FD5Setup.ssGDPR.GDPRCompanyAnonDepartment;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPRCompanyNotesOption: Integer;
begin
  Result := FD5Setup.ssGDPR.GDPRCompanyNotesOption;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPRCompanyLettersOption: Integer;
begin
  Result := FD5Setup.ssGDPR.GDPRCompanyLettersOption;
end;

{-----------------------------------------}

function  TCOMSetupGDPR.Get_GDPRCompanyLinksOption: Integer;
begin
  Result := FD5Setup.ssGDPR.GDPRCompanyLinksOption;
end;

//SS:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
function TCOMSetup.Get_ssConnectionPassword: WideString;
begin
  Result := FD5Setup.ssConnectionPassword;
end;
//SS:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
function TCOMSetup.Get_ssConnectionString: WideString;
begin
  Result := FD5Setup.ssConnectionString;
end;

end.

