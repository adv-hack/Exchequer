unit oSetup;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE04}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     GlobVar, VarConst, VarRec2U, MiscFunc, oBtrieve,
     BtrvU2, ExBtTh1U, GlobList, oContactRoles, Graphics,
     //PR: 26/11/2014 Order Payments
     CountryCodes, CountryCodeUtils, oIntrastat, ExceptIntf;

type
  TSystemSetupVAT = class(TAutoIntfObjectEx, ISystemSetupVAT)
  private
    ThisVAT : VatType;
  protected
    function  Get_svCode: WideString; safecall;
    function  Get_svDesc: WideString; safecall;
    function  Get_svRate: Double; safecall;
    function  Get_svInclude: WordBool; safecall;
  public
    Constructor Create (Const VATIdx : VATType);
  End; { TSystemSetupVAT }

  {-----------------------------------------}

  TSystemSetupCurrency = class(TAutoIntfObjectEx, ISystemSetupCurrency)
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
  End; { TSystemSetupCurrency }

  {-----------------------------------------}

  TSystemSetupReleaseCodes = class(TAutoIntfObjectEx, ISystemSetupReleaseCodes, ISystemSetupReleaseCodes2,
                                   ISystemSetupReleaseCodes3, ISystemSetupReleaseCodes4, ISystemSetupReleaseCodes5,
                                   ISystemSetupReleaseCodes6)
  protected
    function  Get_rcAccountStockAnalysis: TReleaseCodeStatus; safecall;
    function  Get_rcCommitment: TReleaseCodeStatus; safecall;
    function  Get_rcEBusiness: TReleaseCodeStatus; safecall;
    function  Get_rcJobCosting: TReleaseCodeStatus; safecall;
    function  Get_rcMultiCurrency: TReleaseCodeStatus; safecall;
    function  Get_rcOLESave: TReleaseCodeStatus; safecall;
    function  Get_rcPaperless: TReleaseCodeStatus; safecall;
    function  Get_rcReportWriter: TReleaseCodeStatus; safecall;
    function  Get_rcTelesales: TReleaseCodeStatus; safecall;
    function  Get_rcToolkitDLL: TReleaseCodeStatus; safecall;
    function  Get_rcTradeCounter: TReleaseCodeStatus; safecall;
    function  Get_rcWOPStandard: TReleaseCodeStatus; safecall;
    function  Get_rcWOPProfessional: TReleaseCodeStatus; safecall;
    function  Get_rcSentimail: TReleaseCodeStatus; safecall;
    function  Get_rcEnhancedSecurity: TReleaseCodeStatus; safecall;
    function  Get_rcCISRCT: TReleaseCodeStatus; safecall;
    function  Get_rcAppsAndVals: TReleaseCodeStatus; safecall;
    function  Get_rcFullStockControl: TReleaseCodeStatus; safecall;
    function  Get_rcVisualReportWriter: TReleaseCodeStatus; safecall;
    function  Get_rcGoodsReturns: TReleaseCodeStatus; safecall;
    function  Get_rcEBanking: TReleaseCodeStatus; safecall;
    //SSK 17/11/2016 2017-R1 ABSEXCH-13960: Implementation to get release code of Outlook Dynamic Dashboard,  Importer for ISystemSetupReleaseCodes5
    function  Get_rcOutlookDynamicDashboard: TReleaseCodeStatus; safecall;
    function  Get_rcImporter: TReleaseCodeStatus; safecall;

    //AP 22/12/2017 2018-R1 ABSEXCH-19402: Implementation to get release code of GDPR
    function  Get_rcGDPR: TReleaseCodeStatus; safecall;
    function  Get_rcPervasiveEncryption: TReleaseCodeStatus; safecall;

  public
    Constructor Create;
  End; { TSystemSetupReleaseCodes }

  {-----------------------------------------}

  //PR: 24/02/2012 Added ISystemSetupUserFields4 v6.10 ABSEXCH-12128
  TSystemSetupUserFields = class(TAutoIntfObjectEx, ISystemSetupUserFields, ISystemSetupUserFields2, ISystemSetupUserFields3,
                                  ISystemSetupUserFields4, ISystemSetupUserFields5)
  private
    function CapSet(SetNo, Index : Integer) : Integer;
    function CapAry(SetNo, Index : Integer) : Integer;
    function HidSet(SetNo, Index : Integer) : Integer;
    function HidAry(SetNo, Index : Integer) : Integer;
    function GetVal(const s : string; Val : integer) : string;
    function GetInt(const s : string; WantSet : Boolean) : integer;
  protected
  //ISystemSetupUserFields
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
    function  Get_ufLineType1: WideString; safecall;
    function  Get_ufLineType2: WideString; safecall;
    function  Get_ufLineType3: WideString; safecall;
    function  Get_ufLineType4: WideString; safecall;
    function  Get_ufLineType1Enabled: WordBool; safecall;
    function  Get_ufLineType2Enabled: WordBool; safecall;
    function  Get_ufLineType3Enabled: WordBool; safecall;
    function  Get_ufLineType4Enabled: WordBool; safecall;

  //ISystemSetupUserFields2
    function Get_ufADJDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufADJEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufADJLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufADJLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufCustDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufEmployeeDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufJobDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufLineTypeDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufNOMDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufNOMEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufNOMLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufNOMLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPINDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufPINEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPINLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufPINLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPORDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufPOREnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPORLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufPORLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPPYDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufPPYEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPPYLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufPPYLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPQUDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufPQUEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPQULineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufPQULineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSINDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufSINEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSINLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufSINLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSORDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufSOREnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSORLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufSORLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSQUDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufSQUEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSQULineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufSQULineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSRCDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufSRCEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSRCLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufSRCLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufStockDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufSuppDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufTSHDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufTSHEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufTSHLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufTSHLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufWORDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufWOREnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufWORLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufWORLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;

    //PR: 23/11/2011 v6.9 Added fields for return transactions & lines.
    function Get_ufSRNDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufSRNEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSRNLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufSRNLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPRNDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufPRNEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufPRNLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufPRNLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;

    //PR: 24/02/2012 ISystemSetupUserFields4 v6.10 Fields for Apps and Vals ABSEXCH-12128
    function Get_ufJCTDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufJCTEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufJCTLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufJCTLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufJPTDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufJPTEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufJPTLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufJPTLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufJSTDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufJSTEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufJSTLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufJSTLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufJPADesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufJPAEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufJPALineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufJPALineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufJSADesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufJSAEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufJSALineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufJSALineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;

    // MH 02/01/2015 v7.1 ABSEXCH-15948: Extended to support Customer/Supplier Credit Card Fields (11-15)
    function Get_ufCustEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSuppEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    // MH 02/01/2015 v7.1 ABSEXCH-15855: Added Address Description Fields
    function Get_ufAddressDesc(Index: TUserDefinedFieldNo): WideString; safecall;

    Function  GetUserFieldName(Index : Integer) : ShortString;
    Function  GetUserFieldEnabled(Index : Integer) : Boolean;
  public
    Constructor Create;
  End; { TSystemSetupUserFields }

  {-----------------------------------------}
  TSystemSetupJob = Class(TAutoIntfObjectEx, ISystemSetupJob, ISystemSetupJob2)
  protected
    function  Get_ssUsePPIsForTimeSheets: WordBool; safecall;
    function  Get_ssSplitJobBudgetsByPeriod: WordBool; safecall;
    function  Get_ssPPISupAccount: WideString; safecall;
    function  Get_ssJobCategory(Index: TJobCategoryType): WideString; safecall;
    function  Get_ssCheckJobBudget: WordBool; safecall;
    function  Get_ssJobCostingGLCtrlCodes(Index : TSystemSetupJobGLCtrlType): Integer; safecall;

    //SSK 12/10/2016 2017-R1 ABSEXCH-13961: Implementation to get System Setup Options for ISystemSetupJob2
    function  Get_ssIncludeUnpostedPurchasesInCommitted: WordBool; safecall;
    function  Get_ssUseApplicationDateForInvoice: WordBool; safecall;
    function  Get_ssDelayApplicationCommittedUntilCertified: WordBool; safecall;
    function  Get_ssProtectApplicationYourRef: WordBool; safecall;    //SSK 19/10/2016 2017-R1 ABSEXCH-13961: Implementation to get System Setup Options for Protect Application "Your Ref"

  public
    Constructor Create;
  End; { TSystemSetupJob }


  {-----------------------------------------}
  TSystemSetupPaperless = Class(TAutoIntfObjectEx, ISystemSetupPaperless, ISystemSetupPaperless2,
                                 ISystemSetupPaperless3)
  private
    function LoadSig(WhichSig : SmallInt) : WideString;
  protected
    function  Get_ssYourEmailName: WideString; safecall;
    function  Get_ssYourEmailAddress: WideString; safecall;
    function  Get_ssSMTPServer: WideString; safecall;
    function  Get_ssDefaultEmailPriority: TEmailPriority; safecall;
    function  Get_ssEmailUseMAPI: WordBool; safecall;
    function  Get_ssAttachMethod: TEmailAttachMethod; safecall;
    function  Get_ssFaxFromName: WideString; safecall;
    function  Get_ssFaxFromTelNo: WideString; safecall;
    function  Get_ssFaxInterfacePath: WideString; safecall;
    function  Get_ssFaxUsing: TFaxMethod; safecall;

    //ISystemSetupPaperless2 methods
    function Get_ssCompanyEmailSignature: WideString; safecall;
    function Get_ssCompanyFaxSignature: WideString; safecall;

    //ISystemSetupPaperless3 methods
    function Get_ssEmailAttachmentPrinter: WideString; safecall;
    function Get_ssFaxPrinter: WideString; safecall;
  public
    Constructor Create;
  End; { TSystemSetupPaperless }

  TSystemSetupFormDefinitionSet = Class(TBtrieveFunctions, ISystemSetupFormDefinitionSet)
  private
    FDefRec : FormDefsType;
    FIDNo : Byte;
    function TranslateIdx(Index: TFormDefinitionType) : SmallInt;
  protected
    function Get_fdNumber: Byte; safecall;
    function Get_fdDescription: WideString; safecall;
    function Get_fdForms(Index: TFormDefinitionType): WideString; safecall;
    function BuildNumberIndex(Number: Integer): WideString; safecall;

    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt;
                            Const SearchKey : String = '') : Integer; Override;

  public
    constructor Create(Const BtrIntf  : TCtkTdPostExLocalPtr);
    destructor Destroy; override;
  end;

  TCISRate = Class(TAutoIntfObject, ICISRate)
  private
    FIdx    : CISTaxType;
  protected
    function Get_cisrCode: WideString; safecall;
    function Get_cisrDescription: WideString; safecall;
    function Get_cisrRate: Double; safecall;
    function Get_cisrGLCode: Integer; safecall;
    function Get_cisrCostCentre: WideString; safecall;
    function Get_cisrDepartment: WideString; safecall;

    procedure SetIdx(Value : TCISTaxType);
  public
    property Idx : TCISTaxType write SetIdx;
  end;

  TCISVoucherCounter = Class(TAutoIntfObject, ICISVoucherCounter)
  private
    FIdx : Integer;
  protected
    function Get_cvPrefix: WideString; safecall;
    function Get_cvCounter: WideString; safecall;
    procedure SetIdx(Value : TCISVoucherType);
  public
    property Idx : TCISVoucherType write SetIdx;
  end;

  TSystemSetupCIS = Class(TAutoIntfObjectEx, ISystemSetupCIS, ISystemSetupCIS2, ISystemSetupCIS3,
                           ISystemSetupCIS4)
  protected
    function Get_cisInterval: Integer; safecall;
    function Get_cisAutoSetPeriod: WordBool; safecall;
    function Get_cisReturnDate: WideString; safecall;
    function Get_cisTaxRef: WideString; safecall;
    function Get_cisDefaultVatCode: WideString; safecall;
    function Get_cisFolioNumber: Integer; safecall;
    function Get_cisRate(TaxType: TCISTaxType): ICISRate; safecall;
    function Get_cisVoucherCounter(VoucherType: TCISVoucherType): ICISVoucherCounter; safecall;
    function Get_cisContractorCertType: TCISCertificateType; safecall;
    procedure Set_cisContractorCertType(Value: TCISCertificateType); safecall;
    function Get_cisContractorCertRef: WideString; safecall;
    procedure Set_cisContractorCertRef(const Value: WideString); safecall;
    function Get_cisContractorCertExpiry: WideString; safecall;
    procedure Set_cisContractorCertExpiry(const Value: WideString); safecall;

    //ISystemSetupCIS3
    function Get_cisCTR: WideString; safecall;
    function Get_cisUTR: WideString; safecall;
    function Get_cisContractorNINO: WideString; safecall;
    function Get_cisACOfficeRef: WideString; safecall;

    function Get_cisTaxOfficeNo: WideString; safecall;
    function Get_cisTaxOfficeRef: WideString; safecall;
    function Get_cisSenderID: WideString; safecall;
    function Get_cisSenderAuthentication: WideString; safecall;

    //ISystemSetupCIS4
    function Get_cisTestMode: WordBool; safecall;
    function Get_cisSubmitterType: TCISSubmitterType; safecall;

  end;
  {-----------------------------------------}
  TSystemSetupReturnLineReason = Class(TBtrieveFunctions, ISystemSetupReturnLineReason)
  private
    FReasonRec : rtLReasonType;
  protected
    function Get_rlrNumber: Integer; safecall;
    function Get_rlrDescription: WideString; safecall;
    function BuildNumberIndex(Number: Integer): WideString; safecall;

    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt;
                            Const SearchKey : String = '') : Integer; Override;

  public
    constructor Create(Const BtrIntf  : TCtkTdPostExLocalPtr);
    destructor Destroy; override;
  end;

  {-----------------------------------------}
  TCOMTKFontStyle = class(TAutoIntfObjectEx, IFontStyle)
  private
    FStyles : TFontStyles;
  protected
    function Get_fsBold: WordBool; safecall;
    procedure Set_fsBold(Value: WordBool); safecall;
    function Get_fsItalic: WordBool; safecall;
    procedure Set_fsItalic(Value: WordBool); safecall;
    function Get_fsUnderline: WordBool; safecall;
    procedure Set_fsUnderline(Value: WordBool); safecall;
    function Get_fsStrikeout: WordBool; safecall;
    procedure Set_fsStrikeout(Value: WordBool); safecall;
  public
    constructor Create(const AStyles : TFontStyles);
  end;

  TPPDColour = (pcGreen, pcAmber, pcRed, pcExpired);

  {-----------------------------------------}
  TSystemSetupPromptPaymentDiscounts = class(TAutoIntfObjectEx, ISystemSetupPromptPaymentDiscounts)
  private
    FStylesI : Array[pcGreen..pcExpired] of IFontStyle;
    FStylesO : Array[pcGreen..pcExpired] of TCOMTKFontStyle;
    procedure InitObjects;
    function GetFontStyle(pc : TPPDColour) : IFontStyle;
    function GetSystemFontStyle(pc : TPPDColour) : TFontStyles;
  protected
    function Get_ssPPDRedDays: Integer; safecall;
    function Get_ssPPDAmberDays: Integer; safecall;
    function Get_ssPPDExpiredBackgroundColour: Integer; safecall;
    function Get_ssPPDExpiredFontColour: Integer; safecall;
    function Get_ssPPDExpiredFontStyle: IFontStyle; safecall;
    function Get_ssPPDRedBackgroundColour: Integer; safecall;
    function Get_ssPPDRedFontColour: Integer; safecall;
    function Get_ssPPDRedFontStyle: IFontStyle; safecall;
    function Get_ssPPDAmberBackgroundColour: Integer; safecall;
    function Get_ssPPDAmberFontColour: Integer; safecall;
    function Get_ssPPDAmberFontStyle: IFontStyle; safecall;
    function Get_ssPPDGreenBackgroundColour: Integer; safecall;
    function Get_ssPPDGreenFontColour: Integer; safecall;
    function Get_ssPPDGreenFontStyle: IFontStyle; safecall;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TSystemSetupCountryDetails = Class(TAutoIntfObjectEx, ICountryDetails)
  private
    FCountryDetails : IISO3166CountryDetails;
  protected
    function Get_cdName: WideString; safecall;
    function Get_cdCode2: WideString; safecall;
    function Get_cdCode3: WideString; safecall;
    function Get_cdCodeNumeric: WideString; safecall;
  public
    constructor Create(CountryDetails : IISO3166CountryDetails);
    destructor Destroy; override;
  end;

  TSystemSetupCountryList = Class(TAutoIntfObjectEx, ICountryList)
  protected
    function Get_clCount: Integer; safecall;
    function Get_clCountry(Index: Integer): ICountryDetails; safecall;
    function IndexOf(CodeType: TCountryCodeType; const Code: WideString): Integer; safecall;
  end;

  TSystemSetupGDPR = Class(TAutoIntfObjectEx, IGDPRSetup)
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
    constructor create;
  end;


  {-----------------------------------------}
  //PR: 28/02/2014 ABSEXCH-15100 Added ISystemSetup11
  //PR: 27/05/2015 v7.0.14 Added ISystemSetup12
  //PR: 20/01/2016 ABSEXCH-17112 v2016 R1 ISystemSetup13
  //SSK: 02/11/2017 ABSEXCH-172
  //AP: 06/02/2018 ABSEXCH-19402 ISystemSetup17
  TSystemSetup = class(TAutoIntfObjectEx, ISystemSetup, ISystemSetup2, ISystemSetup3, ISystemSetup4, ISystemSetup5, ISystemSetup6,
                                       ISystemSetup7, ISystemSetup8, ISystemSetup9, ISystemSetup10, ISystemSetup11,
                                       ISystemSetup12, ISystemSetup13, ISystemSetup14,ISystemSetup15, ISystemSetup16)
  private
    // VAT sub-object Arrays
    FVATO        : Array [VATType] Of TSystemSetupVAT;
    FVATI        : Array [VATType] Of ISystemSetupVAT;

    // Release Codes sub-object
    FRelCodeO    : TSystemSetupReleaseCodes;
    FRelCodeI    : ISystemSetupReleaseCodes;

    // Currency sub-objects array
    FCurrencyO   : Array [0..CurrencyType] Of TSystemSetupCurrency;
    FCurrencyI   : Array [0..CurrencyType] Of ISystemSetupCurrency;

    // User Fields sub-object
    FUserFieldsO : TSystemSetupUserFields;
    FUserFieldsI : ISystemSetupUserFields;

    // Job sub-object
    FJobSetupO : TSystemSetupJob;
    FJobSetupI : ISystemSetupJob;

    // Paperless sub-object
    FPaperlessSetupO : TSystemSetupPaperless;
    FPaperlessSetupI : ISystemSetupPaperless;

    //ISystemSetup2
    //FormDefinitionSet sub-object
    FFormDefinitionO : TSystemSetupFormDefinitionSet;
    FFormDefinitionI : ISystemSetupFormDefinitionSet;

    FCISO  : TSystemSetupCIS;
    FCISI  : ISystemSetupCIS;

    FReturnLineReasonO : TSystemSetupReturnLineReason;
    FReturnLineReasonI : ISystemSetupReturnLineReason;

    //PR: 25/01/2014 ABSEXCH-14974 ISystemSetup10
    FContactRolesListO : TSystemSetupContactRolesList;
    FContactRolesListI : ISystemSetupContactRolesList;

    //PR: 28/05/2015 v7.0.14 ISystemSetup12
    FPPDO : TSystemSetupPromptPaymentDiscounts;
    FPPDI : ISystemSetupPromptPaymentDiscounts;

    //PR: 26/11/2014 Order Payments ISystemSetup13
    FCountryListO : TSystemSetupCountryList;
    FCountryListI : ICountryList;

    FIntrastatO : TIntrastatSetup;
    FIntrastatI : IIntrastatSetup;

    FGDPRO : TSystemSetupGDPR;
    FGDPRI : IGDPRSetup;
  protected
    function  Get_ssPeriodsInYear: Smallint; safecall;
    function  Get_ssCompanyName: WideString; safecall;
    function  Get_ssLastAuditYr: Smallint; safecall;
    function  Get_ssManUpdReorderCost: WordBool; safecall;
    function  Get_ssVATReturnCurrency: Smallint; safecall;
    function  Get_ssCostDecimals: Smallint; safecall;
    function  Get_ssShowStkPriceAsMargin: WordBool; safecall;
    function  Get_ssLiveStockCOSVal: WordBool; safecall;
    function  Get_ssSDNShowPickedOnly: WordBool; safecall;
    function  Get_ssUseLocations: WordBool; safecall;
    function  Get_ssSetBOMSerNo: WordBool; safecall;
    function  Get_ssWarnDupliYourRef: WordBool; safecall;
    function  Get_ssUseLocDelAddress: WordBool; safecall;
    function  Get_ssBudgetByCCDept: WordBool; safecall;
    function  Get_ssCurrencyTolerance: Double; safecall;
    function  Get_ssCurrencyToleranceMode: Smallint; safecall;
    function  Get_ssDebtChaseMode: Smallint; safecall;
    function  Get_ssAutoGenVariance: WordBool; safecall;
    function  Get_ssAutoGenDisc: WordBool; safecall;
    function  Get_ssCompanyCountryCode: WideString; safecall;
    function  Get_ssSalesDecimals: Smallint; safecall;
    function  Get_ssDebtChaseOverdue: Smallint; safecall;
    function  Get_ssCurrentPeriod: Smallint; safecall;
    function  Get_ssCurrentYear: Smallint; safecall;
    function  Get_ssTradeTerm: WordBool; safecall;
    function  Get_ssSeparateCurrencyStatements: WordBool; safecall;
    function  Get_ssStatementAgingMethod: Smallint; safecall;
    function  Get_ssStatementUseInvoiceDate: WordBool; safecall;
    function  Get_ssQuotesAllocateStock: WordBool; safecall;
    function  Get_ssDeductBOMComponents: WordBool; safecall;
    function  Get_ssAuthorisationMethod: WideString; safecall;
    function  Get_ssUseIntrastat: WordBool; safecall;
    function  Get_ssAnalyseDescOnly: WordBool; safecall;
    function  Get_ssDefaultStockValMethod: WideString; safecall;
    function  Get_ssDisplayUpdateCosts: WordBool; safecall;
    function  Get_ssAutoChequeNo: WordBool; safecall;
    function  Get_ssStatementIncNotDue: WordBool; safecall;
    function  Get_ssForceBatchTotalBalancing: WordBool; safecall;
    function  Get_ssDisplayStockLevelWarning: WordBool; safecall;
    function  Get_ssStatementNoteEntry: WordBool; safecall;
    function  Get_ssHideMenuOpt: WordBool; safecall;
    function  Get_ssUseCCDept: WordBool; safecall;
    function  Get_ssHoldSettlementDiscTransactions: WordBool; safecall;
    function  Get_ssSetTransPeriodByDate: WordBool; safecall;
    function  Get_ssStopOverCreditLimit: WordBool; safecall;
    function  Get_ssUseSRCPayInRef: WordBool; safecall;
    function  Get_ssUsePasswords: WordBool; safecall;
    function  Get_ssPromptToPrintReciept: WordBool; safecall;
    function  Get_ssExternalCustomers: WordBool; safecall;
    function  Get_ssQtyDecimals: Smallint; safecall;
    function  Get_ssExternalSINEntry: WordBool; safecall;
    function  Get_ssDisablePostingToPreviousPeriods: WordBool; safecall;
    function  Get_ssPercDiscounts: WordBool; safecall;
    function  Get_ssNumericAccountCodes: WordBool; safecall;
    function  Get_ssUpdateBalanceOnPosting: WordBool; safecall;
    function  Get_ssShowInvoiceDisc: WordBool; safecall;
    function  Get_ssSplitDiscountsInGL: WordBool; safecall;
    function  Get_ssDoCreditStatusCheck: WordBool; safecall;
    function  Get_ssDoCreditLimitCheck: WordBool; safecall;
    function  Get_ssAutoClearPayments: WordBool; safecall;
    function  Get_ssCurrencyRateType: TCurrencyRateType; safecall;
    function  Get_ssShowPeriodsAsMonths: WordBool; safecall;
    function  Get_ssDirectCustomer: WideString; safecall;
    function  Get_ssDirectSupplier: WideString; safecall;
    function  Get_ssSettlementDiscount: Double; safecall;
    function  Get_ssSettlementDays: Smallint; safecall;
    function  Get_ssNeedBOMCostingUpdate: WordBool; safecall;
    function  Get_ssInputPackQtyOnLine: WordBool; safecall;
    function  Get_ssDefaultVATCode: WideString; safecall;
    function  Get_ssPaymentTerms: Smallint; safecall;
    function  Get_ssStatementAgeingInterval: Smallint; safecall;
    function  Get_ssKeepQuoteDate: WordBool; safecall;
    function  Get_ssFreeStockExcludesSOR: WordBool; safecall;
    function  Get_ssSeparateDirectTransCounter: WordBool; safecall;
    function  Get_ssStatementShowMatchedInMonth: WordBool; safecall;
    function  Get_ssLiveOldestDebt: WordBool; safecall;
    function  Get_ssBatchPPY: WordBool; safecall;
    function  Get_ssDefaultBankGL: Integer; safecall;
    function  Get_ssUseDefaultBankAccount: WordBool; safecall;
    function  Get_ssYearStartDate: WideString; safecall;
    function  Get_ssLastAuditDate: WideString; safecall;
    function  Get_ssBankSortCode: WideString; safecall;
    function  Get_ssBankAccountNo: WideString; safecall;
    function  Get_ssBankAccountRef: WideString; safecall;
    function  Get_ssBankName: WideString; safecall;
    function  Get_ssCompanyPhone: WideString; safecall;
    function  Get_ssCompanyFax: WideString; safecall;
    function  Get_ssCompanyVATRegNo: WideString; safecall;
    function  Get_ssCompanyAddress(Index: Integer): WideString; safecall;
    function  Get_ssGLCtrlCodes(Index: TSystemSetupGLCtrlType): Integer; safecall;
    function  Get_ssDebtChaseDays(Index: Integer): Smallint; safecall;
    function  Get_ssTermsofTrade(Index: Integer): WideString; safecall;
    function  Get_ssVATRates(const Index: WideString): ISystemSetupVAT; safecall;
    function  Get_ssCurrency(Index: Integer): ISystemSetupCurrency; safecall;
    function  Get_ssUserFields: ISystemSetupUserFields; safecall;
    function  Get_ssPickingOrderAllocatesStock: WordBool; safecall;
    function  Get_ssReleaseCodes: ISystemSetupReleaseCodes; safecall;
    function  Get_ssDocumentNumbers(const DocType: WideString): Integer; safecall;
    function  Get_ssCurrencyVersion: TEnterpriseCurrencyVersion; safecall;
    function  Get_ssMaxCurrency: Integer; safecall;

    //SS:07/06/2017:2017-R2:ABSEXCH-18611:Currency Import Tolerance support to be added in COM Toolkit.
    function Get_ssCurrencyImportTolerance: Single; safecall;


    procedure Refresh; safecall;

    function  Get_ssUseDosKeys: WordBool; safecall;
    function  Get_ssHideEnterpriseLogo: WordBool; safecall;
    function  Get_ssConserveMemory: WordBool; safecall;
    function  Get_ssProtectYourRef: WordBool; safecall;
    function  Get_ssSDNDateIsTaxPointDate: WordBool; safecall;
    function  Get_ssAutoPostUplift: WordBool; safecall;
    function  Get_ssJobCosting: ISystemSetupJob; safecall;
    function  Get_ssPaperless: ISystemSetupPaperless; safecall;
    function  Get_ssTaxWord: WideString; safecall;

    //IsystemSetup2 methods
    function Get_ssWOPDisableWIP: WordBool; safecall;
    function Get_ssWORAllocStockOnPick: WordBool; safecall;
    function Get_ssWORCopyStkNotes: TWOPStockNotesType; safecall;
    function Get_ssFormDefinitionSet: ISystemSetupFormDefinitionSet; safecall;
    function Get_ssCISSetup: ISystemSetupCIS; safecall;

    //IsystemSetup3 methods
    function Get_ssFilterByBinLocation: WordBool; safecall;
    function Get_ssKeepBinHistory: WordBool; safecall;
    function Get_ssBinMask: WideString; safecall;
    function Get_ssBudgetByCCDeptEx: TBudgetByCCDeptType; safecall;
    function Get_ssStatementUseInvoiceDateEx: TStatementUseInvoiceDateType; safecall;

    //IsystemSetup4 methods
    function Get_ssReturnLineReason: ISystemSetupReturnLineReason; safecall;

    //IsystemSetup5 methods
    function Get_ssEnforceGLClasses: WordBool; safecall;

    //IsystemSetup6 methods
    function Get_ssCurrentVatPeriod: WideString; safecall;
    function Get_ssVATScheme: TVATSchemeType; safecall;
    function Get_ssVATReturnInterval: Integer; safecall;

    //IsystemSetup7 methods
    function Get_ssECServicesEnabled: WordBool; safecall;
    function Get_ssECSalesThreshold: Double; safecall;

    //ISystemSetup8 method
    function Get_ssEnableOverrideLocations: WordBool; safecall;

    //ISystemSetup9 method
    function Get_ssConsumersEnabled: WordBool; safecall;

    //PR: 25/01/2014 ABSEXCH-14974 ISystemSetup10
    function Get_ssContactRoles: ISystemSetupContactRolesList; safecall;

    //PR: 27/05/2015 v7.0.14 ISystemSetup12;
    function Get_ssPromptPaymentDiscounts: ISystemSetupPromptPaymentDiscounts; safecall;

    // CJS 2014-08-04 - v7.x Order Payments - T096 - ISystemSetup12 - new field
    function Get_ssEnableOrderPayments: WordBool; safecall;

    //PR: 26/11/2014 Order Payments ISystemSetup12
    function Get_ssCountryList: ICountryList; safecall;

    //PR: 20/01/2016 ABSEXCH-17112 v2016 R1 ISystemSetup13
    function Get_ssIntrastatSetup: IIntrastatSetup; safecall;

    //SSK 18/10/2016 2017-R1 ABSEXCH-13961: Implementation to get System Setup Options
    function Get_ssUseTransactionTotalDiscounts: WordBool; safecall;
    function Get_ssUseValueBasedDiscounts: WordBool; safecall;
    function Get_ssIncludeVATInCommittedBalances: WordBool; safecall;

    //SSK 02/11/2016 2017-R3 ABSEXCH-19270: Implementation for PasswordAuthentication
    function Get_ssLoginAuthenticationMode: WideString; safecall;
    
    //AP 29/11/2017 2018-R1 ABSEXCH-19402: Implementation for GDPR
    function  Get_ssGDPR: IGDPRSetup; safecall;
    Procedure InitObjects;
  public
    Constructor Create;
    Destructor Destroy; override;
  End; { TSystemSetup }

function CalcRelCode (Const RelCodeNo : SmallInt) : TReleaseCodeStatus;

implementation

uses ComServ, BTSupU1, HelpSupU, DllTH_Up, VarCnst3, VarJCstU, IntMU, ETStrU, BtSupU2,
     oUser, BTKeys1U, ETMiscU, CustomFieldsVar,
    CustomFieldsIntf,

    //PR: 10/09/2013 ABSEXCH-14598
    EncryptionUtils,

    oSystemSetup;

{-------------------------------------------------------------------------------------------------}

function CalcRelCode (Const RelCodeNo : SmallInt) : TReleaseCodeStatus;
Var
  RM : Byte;
Begin { CalcRelCode }
  RM := ModRelMode(RelCodeNo);

  If (Not Check_RelDateExp(RelCodeNo,BOff)) then
    Result := rc30Day
  Else
    If (RM = 1) Then
      Result := rcEnabled
    Else
      Result := rcDisabled;
End; { CalcRelCode }

{-------------------------------------------------------------------------------------------------}

Function CreateTSystemSetupFormDefinitionSet (Const ClientId : Integer) : TSystemSetupFormDefinitionSet;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTAccount }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by TUser object
  BtrIntf^.Open_System(SysF,  SysF);

  // Create bas TAccount object
  Result := TSystemSetupFormDefinitionSet.Create(BtrIntf);
End; { CreateTAccount }
{-------------------------------------------------------------------------------------------------}


Constructor TSystemSetup.Create;
Begin { Create }
  //PR: 28/02/2014 ABSEXCH-15100 changed to ISystemSetup11
  // CJS 2014-08-04 - v7.x Order Payments - T096 - ISystemSetup12
  //PR: 20/01/2016 ABSEXCH-17112 v2016 R1 ISystemSetup13
  //SSK 12/10/2016 2017-R1 ABSEXCH-13961: ISystemSetup14
  //SS:07/06/2017:2017-R2:ABSEXCH-18611:ISystemSetup15.
  //AP:06/02/2018:2018-R1:ABSEXCH-19402:ISystemSetup16
  Inherited Create (ComServer.TypeLib, ISystemSetup16);

  // Initialise sub-objects
  InitObjects;

  // Initialise variables

End; { Create }

{-----------------------------------------}

Destructor TSystemSetup.Destroy;
Begin { Destroy }
  { Destroy sub-objects }
  InitObjects;

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TSystemSetup.InitObjects;
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

  // Release Code sub-object
  FRelCodeO := NIL;
  FRelCodeI := NIL;

  // User Fields sub-object
  FUserFieldsO := NIL;
  FUserFieldsI := NIL;

  // Job sub-object
  FJobSetupO := nil;
  FJobSetupI := nil;

  // Paperless sub-object
  FPaperlessSetupO := nil;
  FPaperlessSetupI := nil;

  //FormDefinitionSet sub-object
  FFormDefinitionO := nil;
  FFormDefinitionI := nil;

  //CISSetup
  FCISO := nil;
  FCISI := nil;

  //Return Line Reason
  FReturnLineReasonO := nil;
  FReturnLineReasonI := nil;

  //PR: 25/01/2014 ABSEXCH-14974 ISystemSetup10 Contact Roles List
  FContactRolesListO := nil;
  FContactRolesListI := nil;

  //PR: 27/05/2015 v7.0.14 ISystemSetup12 PPD settings
  FPPDO := nil;
  FPPDI := nil;

End; { InitObjects }

{-----------------------------------------}

function TSystemSetup.Get_ssCurrencyToleranceMode: Smallint;
begin
  Result := Syss.AlTolMode
end;

function TSystemSetup.Get_ssCurrencyTolerance: Double;
begin
  Result := Syss.AlTolVal
end;

function TSystemSetup.Get_ssAnalyseDescOnly: WordBool;
begin
  Result := Syss.AnalStkDesc
end;

function TSystemSetup.Get_ssAuthorisationMethod: WideString;
begin
  Result := Syss.AuthMode
end;

function TSystemSetup.Get_ssDisplayUpdateCosts: WordBool;
begin
  Result := Syss.AutoBillUp
end;

function TSystemSetup.Get_ssAutoClearPayments: WordBool;
begin
  Result := Syss.AutoClearPay
end;

function TSystemSetup.Get_ssAutoChequeNo: WordBool;
begin
  Result := Syss.AutoCQNo
end;

function TSystemSetup.Get_ssAutoGenDisc: WordBool;
begin
  Result := Syss.AutoGenDisc
end;

function TSystemSetup.Get_ssAutoGenVariance: WordBool;
begin
  Result := Syss.AutoGenVar;
end;

function TSystemSetup.Get_ssStatementNoteEntry: WordBool;
begin
  Result := Syss.AutoNotes;
end;

function TSystemSetup.Get_ssSetTransPeriodByDate: WordBool;
begin
  Result := Syss.AutoPrCalc;
end;

function TSystemSetup.Get_ssDefaultStockValMethod: WideString;
begin
  Result := Syss.AutoStkVal;
end;

function TSystemSetup.Get_ssLiveStockCOSVal: WordBool;
begin
  Result := Syss.AutoValStk;
end;

function TSystemSetup.Get_ssBankAccountNo: WideString;
begin
  //PR: 09/09/2013 ABSEXCH-14598
  Result := DecryptBankAccountCode(Syss.ssBankAccountCode);
end;

function TSystemSetup.Get_ssBankAccountRef: WideString;
begin
  Result := Syss.UserRef;
end;

function TSystemSetup.Get_ssBankName: WideString;
begin
  Result := Syss.UserBank;
end;

function TSystemSetup.Get_ssBankSortCode: WideString;
begin
  //PR: 09/09/2013 ABSEXCH-14598
  Result := DecryptBankSortCode(Syss.ssBankSortCode);
end;

function TSystemSetup.Get_ssBatchPPY: WordBool;
begin
  Result := Syss.BatchPPY
end;

function TSystemSetup.Get_ssCompanyAddress(Index: Integer): WideString;
begin
  Result := Syss.DetailAddr[Index]
end;

function TSystemSetup.Get_ssCompanyCountryCode: WideString;
begin
  Result := Syss.USRCntryCode
end;

function TSystemSetup.Get_ssCompanyFax: WideString;
begin
  Result := Syss.DetailFax
end;

function TSystemSetup.Get_ssCompanyName: WideString;
begin
  Result := Syss.UserName
end;

function TSystemSetup.Get_ssCompanyPhone: WideString;
begin
  Result := Syss.DetailTel
end;

function TSystemSetup.Get_ssCostDecimals: Smallint;
begin
  Result := Syss.NoCosDec
end;

function TSystemSetup.Get_ssCurrentPeriod: Smallint;
begin
  Result := Syss.CPr
end;

function TSystemSetup.Get_ssCurrentYear: Smallint;
begin
  Result := Syss.CYr
end;

function TSystemSetup.Get_ssDeductBOMComponents: WordBool;
begin
  Result := Syss.DeadBOM
end;

function TSystemSetup.Get_ssDebtChaseDays(Index: Integer): Smallint;
begin
  Result := Syss.DebTrig[Index]
end;

function TSystemSetup.Get_ssDebtChaseMode: Smallint;
begin
  Result := Syss.DebtLMode
end;

function TSystemSetup.Get_ssDefaultVATCode: WideString;
begin
  Result := Syss.VATCode
end;

function TSystemSetup.Get_ssDefaultBankGL: Integer;
begin
  Result := Syss.DefBanknom
end;

function TSystemSetup.Get_ssPercDiscounts: WordBool;
begin
  Result := Syss.DefPcDisc
end;

function TSystemSetup.Get_ssSDNShowPickedOnly: WordBool;
begin
  Result := Syss.DelPickOnly
end;

function TSystemSetup.Get_ssDirectCustomer: WideString;
begin
  Result := Syss.DirectCust
end;

function TSystemSetup.Get_ssDirectSupplier: WideString;
begin
  Result := Syss.DirectSupp
end;

function TSystemSetup.Get_ssSeparateDirectTransCounter: WordBool;
begin
  Result := Syss.DirOwnCount
end;

function TSystemSetup.Get_ssShowPeriodsAsMonths: WordBool;
begin
  Result := Syss.DispPrAsMonths
end;

function TSystemSetup.Get_ssSetBOMSerNo: WordBool;
begin
  Result := Syss.EditSinSer
end;

function TSystemSetup.Get_ssExternalCustomers: WordBool;
begin
  Result := Syss.ExternCust
end;

function TSystemSetup.Get_ssExternalSINEntry: WordBool;
begin
  Result := Syss.ExternSIN
end;

function TSystemSetup.Get_ssFreeStockExcludesSOR: WordBool;
begin
  Result := Syss.FreeExAll
end;

function TSystemSetup.Get_ssGLCtrlCodes(Index: TSystemSetupGLCtrlType): Integer;
begin
  //PR: 28/05/2015 v7.0.14 If Index is one of the original control codes go to standard array,
  //                       otherwise use new business object
  if Index < ssGLSettlementWriteOff then
    Result := Syss.NomCtrlCodes[NomCtrlType(Index)]
  else
  begin
    Case Index of
      ssGLSettlementWriteOff : Result := SystemSetup.ControlCodes.ssSettlementWriteOffCtrlGL;
      else
        raise EInvalidMethod.Create('Invalid Control Code (' + IntToStr(Index) + ')');
    end; //Case
  end;
end;

function TSystemSetup.Get_ssHideMenuOpt: WordBool;
begin
  Result := Syss.HideMenuOpt
end;

function TSystemSetup.Get_ssStatementIncNotDue: WordBool;
begin
  Result := Syss.IncNotDue
end;

function TSystemSetup.Get_ssInputPackQtyOnLine: WordBool;
begin
  Result := Syss.InpPack
end;

function TSystemSetup.Get_ssUseIntrastat: WordBool;
begin
  Result := Syss.IntraStat
end;

function TSystemSetup.Get_ssLastAuditDate: WideString;
begin
  Result := Syss.AuditDate
end;

function TSystemSetup.Get_ssLastAuditYr: Smallint;
begin
  Result := Syss.AuditYr
end;

function TSystemSetup.Get_ssLiveOldestDebt: WordBool;
begin
  Result := Syss.LiveCredS
end;

function TSystemSetup.Get_ssManUpdReorderCost: WordBool;
begin
  Result := Syss.ManROCP
end;

function TSystemSetup.Get_ssNeedBOMCostingUpdate: WordBool;
begin
  Result := Syss.NeedBMUp
end;

function TSystemSetup.Get_ssHoldSettlementDiscTransactions: WordBool;
begin
  Result := Not Syss.NoHoldDisc
end;

function TSystemSetup.Get_ssPaymentTerms: Smallint;
begin
  Result := Syss.PayTerms
end;

function TSystemSetup.Get_ssPeriodsInYear: Smallint;
begin
  Result := Syss.PrinYr
end;

function TSystemSetup.Get_ssBudgetByCCDept: WordBool;
begin
  Result := Syss.PostCCNom
end;

function TSystemSetup.Get_ssDisablePostingToPreviousPeriods: WordBool;
begin
  Result := Syss.PrevPrOff
end;

function TSystemSetup.Get_ssPromptToPrintReciept: WordBool;
begin
  Result := Syss.PrintReciept
end;

function TSystemSetup.Get_ssQtyDecimals: Smallint;
begin
  Result := Syss.NoQtyDec
end;

function TSystemSetup.Get_ssQuotesAllocateStock: WordBool;
begin
  Result := Syss.QUAllocFlg
end;

function TSystemSetup.Get_ssKeepQuoteDate: WordBool;
begin
  Result := Syss.QuoOwnDate
end;

function TSystemSetup.Get_ssSalesDecimals: Smallint;
begin
  Result := Syss.NoNetDec
end;

function TSystemSetup.Get_ssSplitDiscountsInGL: WordBool;
begin
  Result := Syss.SepDiscounts
end;

function TSystemSetup.Get_ssSettlementDays: Smallint;
begin
  // MH 19/06/2015 v7.0.14: Remove old Settlement Discount fields
  Result := 0; //Syss.SettleDays
end;

function TSystemSetup.Get_ssSettlementDiscount: Double;
begin
  // MH 19/06/2015 v7.0.14: Remove old Settlement Discount fields
  Result := 0.0; //Syss.SettleDisc
end;

function TSystemSetup.Get_ssShowInvoiceDisc: WordBool;
begin
  Result := Syss.ShowInvDisc
end;

function TSystemSetup.Get_ssShowStkPriceAsMargin: WordBool;
begin
  Result := Syss.ShowStkGP
end;

function TSystemSetup.Get_ssStatementAgeingInterval: Smallint;
begin
  Result := Syss.StaAgeInt
end;

function TSystemSetup.Get_ssStatementAgingMethod: Smallint;
begin
  Result := Syss.StaAgeMthd
end;

function TSystemSetup.Get_ssSeparateCurrencyStatements: WordBool;
begin
  Result := Syss.StaSepCr
end;

function TSystemSetup.Get_ssStatementShowMatchedInMonth: WordBool;
begin
  Result := Syss.StaShowOS
end;

function TSystemSetup.Get_ssStatementUseInvoiceDate: WordBool;
begin
  Result := Syss.StaUIDate
end;

function TSystemSetup.Get_ssStopOverCreditLimit: WordBool;
begin
  Result := Syss.StopBadDr
end;

function TSystemSetup.Get_ssTermsofTrade(Index: Integer): WideString;
begin
  Result := Syss.TermsofTrade[Index]
end;

function TSystemSetup.Get_ssCurrencyRateType: TCurrencyRateType;
begin
  Case Syss.TotalConv of
    'C' : Result := rtCompany;
    'V' : Result := rtDaily;
  end;
end;

function TSystemSetup.Get_ssNumericAccountCodes: WordBool;
begin
  Result := Syss.TradCodeNum
end;

function TSystemSetup.Get_ssTradeTerm: WordBool;
begin
  Result := Syss.TradeTerm
end;

function TSystemSetup.Get_ssUpdateBalanceOnPosting: WordBool;
begin
  Result := Syss.UpBalOnPost
end;

function TSystemSetup.Get_ssForceBatchTotalBalancing: WordBool;
begin
  Result := Syss.UseBatchTot
end;

function TSystemSetup.Get_ssUseCCDept: WordBool;
begin
  Result := Syss.UseCCDep
end;

function TSystemSetup.Get_ssDoCreditStatusCheck: WordBool;
begin
  Result := Syss.UseCreditChk
end;

function TSystemSetup.Get_ssDoCreditLimitCheck: WordBool;
begin
  Result := Syss.UseCRLimitChk
end;

function TSystemSetup.Get_ssUseDefaultBankAccount: WordBool;
begin
  Result := Syss.UseDefBank
end;

function TSystemSetup.Get_ssUseLocDelAddress: WordBool;
begin
  Result := Syss.UseLocDel
end;

function TSystemSetup.Get_ssUseLocations: WordBool;
begin
  Result := Syss.UseMLoc
end;

function TSystemSetup.Get_ssUsePasswords: WordBool;
begin
  Result := Syss.UsePasswords
end;

function TSystemSetup.Get_ssUseSRCPayInRef: WordBool;
begin
  Result := Syss.UsePayIn
end;

function TSystemSetup.Get_ssCompanyVATRegNo: WideString;
begin
  Result := Syss.UserVATReg
end;

function TSystemSetup.Get_ssDisplayStockLevelWarning: WordBool;
begin
  Result := Syss.UseStock;
end;

function TSystemSetup.Get_ssVATReturnCurrency: Smallint;
begin
  Result := Syss.VATCurr;
end;

function TSystemSetup.Get_ssWarnDupliYourRef: WordBool;
begin
  Result := Syss.WarnYRef;
end;

function TSystemSetup.Get_ssDebtChaseOverdue: Smallint;
begin
  Result := Syss.WksODue;
end;

function TSystemSetup.Get_ssYearStartDate: WideString;
begin
//PR: 19/8/02 - changed as OMonWk1 was always blank
//  Result := Syss.OMonWk1;
  Result := Syss.MonWk1;
end;

function TSystemSetup.Get_ssPickingOrderAllocatesStock: WordBool;
begin
  Result := Syss.UsePick4All;
end;

{-----------------------------------------}

function TSystemSetup.Get_ssVATRates(const Index: WideString): ISystemSetupVAT;
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
      FVATO[VATIdx] := TSystemSetupVAT.Create(VATIdx);

      FVATI[VATIdx] := FVATO[VATIdx];
    End; { If (Not Assigned(FVATO[])) }

    Result := FVATI[VATIdx];;
  End { If (VATChar In VATSet) }
  Else
    Raise EUnknownValue.Create ('Invalid VAT Code ' + QuotedStr(Index));
end;

{-----------------------------------------}

function TSystemSetup.Get_ssCurrency(Index: Integer): ISystemSetupCurrency;
Var
  CcyIdx : SmallInt;
begin
  // Validate currency number (raises exception if invalid)
  CcyIdx := ValidateCurrencyNo (Index);

  If (Not Assigned(FCurrencyO[CcyIdx])) Then Begin
    { Create and initialise the Currency sub-object }
    FCurrencyO[CcyIdx] := TSystemSetupCurrency.Create(CcyIdx);

    FCurrencyI[CcyIdx] := FCurrencyO[CcyIdx];
  End; { If (Not Assigned(FCurrencyO[])) }

  Result := FCurrencyI[CcyIdx];;
end;

{-----------------------------------------}

function TSystemSetup.Get_ssUserFields: ISystemSetupUserFields;
begin
  If (Not Assigned(FUserFieldsO)) Then Begin
    { Create and initialise the User Fields Info sub-object }
    FUserFieldsO := TSystemSetupUserFields.Create;

    FUserFieldsI := FUserFieldsO;
  End; { If (Not Assigned(FUserFieldsO)) }

  Result := FUserFieldsI;
end;

{-----------------------------------------}

function TSystemSetup.Get_ssReleaseCodes: ISystemSetupReleaseCodes;
begin
  If (Not Assigned(FRelCodeO)) Then Begin
    { Create and initialise the Release Codes sub-object }
    FRelCodeO := TSystemSetupReleaseCodes.Create;

    FRelCodeI := FRelCodeO;
  End; { If (Not Assigned(FRelCodeO)) }

  Result := FRelCodeI;
end;

{-----------------------------------------}

function TSystemSetup.Get_ssDocumentNumbers(const DocType: WideString): Integer;
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
    Raise Exception.Create (LastErDesc);

  StrDispose(pNextNo);
  StrDispose(pDocType);
end;

{-----------------------------------------}

function TSystemSetup.Get_ssCurrencyVersion: TEnterpriseCurrencyVersion;
begin
  // Check configuration to determine if Single or Euro/Multi
  If ExSyss.MCMode Then Begin
    // Either Euro or Multi-Currency - Check Multi-Currency Release Code
    If (Get_ssReleaseCodes.rcMultiCurrency = rcDisabled) Then
      // No Multi-Currency release code - therefore Euro
      Result := enEuro
    Else
      // Multi-Currency release code set - therefore Global
      Result := enGlobal;
  End { If ExSyss.MCMode  }
  Else
    // Single Currency aka Professional
    Result := enProfessional;
end;

{-----------------------------------------}

function TSystemSetup.Get_ssMaxCurrency: Integer;
Var
  CcyVer : TEnterpriseCurrencyVersion;
begin
  CcyVer := Get_ssCurrencyVersion;

  Case CcyVer Of
    enProfessional : Result := 0;
    enEuro         : Result := 2;
    enGlobal       : Result := CurrencyType;
  Else
    Raise EUnknownValue.Create ('Invalid Currency Version (' + IntToStr(Ord(CcyVer)) + ')');
  End; { Case Get_ssCurrencyVersion }
end;


function TSystemSetup.Get_ssUseDosKeys: WordBool; safecall;
begin
  Result := Syss.TxLateCR;
end;

function TSystemSetup.Get_ssHideEnterpriseLogo: WordBool;
begin
  Result := Syss.HideExLogo;
end;

function TSystemSetup.Get_ssConserveMemory: WordBool;
begin
  Result := Syss.ConsvMem;
end;

function TSystemSetup.Get_ssProtectYourRef: WordBool;
begin
  Result := Syss.ProtectYRef;
end;

function TSystemSetup.Get_ssSDNDateIsTaxPointDate: WordBool;
begin
  Result := Syss.SDNOwnDate;
end;

function TSystemSetup.Get_ssAutoPostUplift: WordBool;
begin
  Result := Syss.UseUpliftNC;
end;

function TSystemSetup.Get_ssJobCosting: ISystemSetupJob;
begin
  if (Not Assigned(FJobSetupO)) then
  begin
    FJobSetupO := TSystemSetupJob.Create;

    FJobSetupI := FJobSetupO;
  end;

  Result := FJobSetupI;
end;

function TSystemSetup.Get_ssPaperless: ISystemSetupPaperless;
begin
  if (Not Assigned(FPaperlessSetupO)) then
  begin
    FPaperlessSetupO := TSystemSetupPaperless.Create;

    FPaperlessSetupI := FPaperlessSetupO;
  end;

  Result := FPaperlessSetupI;
end;

function  TSystemSetup.Get_ssTaxWord: WideString;
begin
    Result := GetIntMsg(1);
end;

function TSystemSetup.Get_ssWOPDisableWIP: WordBool;
begin
  result := Syss.UseWIss4All;
end;

function TSystemSetup.Get_ssWORAllocStockOnPick: WordBool;
begin
  Result := Syss.UseSTDWOP;
end;

function TSystemSetup.Get_ssWORCopyStkNotes: TWOPStockNotesType; safecall;
begin
  Result := TWOPStockNotesType(Syss.WOPStkCopMode);
end;

function TSystemSetup.Get_ssFormDefinitionSet: ISystemSetupFormDefinitionSet;
begin
  if (Not Assigned(FFormDefinitionO)) then
  begin
    FFormDefinitionO := CreateTSystemSetupFormDefinitionSet(25); //25 is btrieve ClientID

    FFormDefinitionI := FFormDefinitionO;
  end;

  Result := FFormDefinitionI;
end;

function TSystemSetup.Get_ssCISSetup: ISystemSetupCIS;
begin
  if not Assigned(FCISO) then
  begin
    GlobLocked := False;
    GetMultiSys(BOff,GlobLocked,CISR);
    GlobLocked := False;
    GetMultiSys(Boff, GlobLocked,CIS340R);
    FCISO := TSystemSetupCIS.Create(ComServer.TypeLib, ISystemSetupCIS4);

    FCISI := FCISO;
  end;

  Result := FCISI;
end;

function TSystemSetup.Get_ssFilterByBinLocation: WordBool;
begin
  Result := Syss.FiltSNoBinLoc;
end;

function TSystemSetup.Get_ssKeepBinHistory: WordBool;
begin
  Result := Syss.KeepBinHist;
end;

function TSystemSetup.Get_ssBinMask: WideString;
begin
  Result := Syss.BinMask;
end;

function TSystemSetup.Get_ssBudgetByCCDeptEx: TBudgetByCCDeptType;
begin
  Result := TBudgetByCCDeptType(Ord(Syss.PostCCNom) + Ord(Syss.PostCCDCombo));
end;

function TSystemSetup.Get_ssStatementUseInvoiceDateEx: TStatementUseInvoiceDateType;
begin
  Result := TStatementUseInvoiceDateType((1*Ord(Syss.StaUIDate))+(2*Ord(Syss.PurchUIDate)));
end;

{-----------------------------------------}

procedure TSystemSetup.Refresh;
begin { Refresh }
  Init_AllSys;
  SystemSetup(True); //Force refresh of fields from new system setup
end; { Refresh }


{-------------------------------------------------------------------------------------------------}

Constructor TSystemSetupVAT.Create (Const VATIdx : VATType);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ISystemSetupVAT);

  // Initialise variables
  ThisVAT := VATIdx;
End; { Create }

{-----------------------------------------}

function TSystemSetupVAT.Get_svCode: WideString;
begin
  Result := SyssVAT.VATRates.VAT[ThisVAT].Code;
end;

function TSystemSetupVAT.Get_svDesc: WideString;
begin
  Result := SyssVAT.VATRates.VAT[ThisVAT].Desc;
end;

function TSystemSetupVAT.Get_svInclude: WordBool;
begin
  Result := SyssVAT.VATRates.VAT[ThisVAT].Include;
end;

function TSystemSetupVAT.Get_svRate: Double;
begin
  Result := SyssVAT.VATRates.VAT[ThisVAT].Rate;
end;



{-------------------------------------------------------------------------------------------------}

Constructor TSystemSetupCurrency.Create (Const CcyIdx : SmallInt);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ISystemSetupCurrency);

  // Initialise variables
  ThisCcy := CcyIdx;
End; { Create }

{-----------------------------------------}

function TSystemSetupCurrency.Get_scCompanyRate: Double;
begin
  Result := SyssCurr.Currencies[ThisCcy].CRates[False];
end;

function TSystemSetupCurrency.Get_scDailyRate: Double;
begin
  Result := SyssCurr.Currencies[ThisCcy].CRates[True];
end;

function TSystemSetupCurrency.Get_scDesc: WideString;
begin
  Result := SyssCurr.Currencies[ThisCcy].Desc;
end;

function TSystemSetupCurrency.Get_scPrintSymb: WideString;
begin
  Result := SyssCurr.Currencies[ThisCcy].PSymb;
end;

function TSystemSetupCurrency.Get_scSymbol: WideString;
begin
  Result := SyssCurr.Currencies[ThisCcy].SSymb;
end;

function TSystemSetupCurrency.Get_scTriEuroCcy: Smallint;
begin
  Result := SyssGCur^.GhostRates.TriEuro[ThisCcy];
end;

function TSystemSetupCurrency.Get_scTriFloating: WordBool;
begin
  Result := SyssGCur^.GhostRates.TriFloat[ThisCcy];
end;

function TSystemSetupCurrency.Get_scTriInvert: WordBool;
begin
  Result := SyssGCur^.GhostRates.TriInvert[ThisCcy];
end;

function TSystemSetupCurrency.Get_scTriRate: Double;
begin
  Result := SyssGCur^.GhostRates.TriRates[ThisCcy];
end;

{-------------------------------------------------------------------------------------------------}

Constructor TSystemSetupUserFields.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ISystemSetupUserFields5); //PR: 21/01/2011 ABSEXCH-10392 Changed to ..userfields2
                                                                 //PR: 23/11/2011 v6.9 Changed to ...UserFields3
                                                                 //PR: 24/02/2012 v6.10 Changed to ...UserFields4 ABSEXCH-12128
                                                                 // MH 02/01/2015 v7.1 ABSEXCH-15855: Changed to 5
End; { Create }

{-----------------------------------------}
function TSystemSetupUserFields.GetUserFieldName(Index : Integer) : ShortString;
var
  newIndex, category : longint;
Begin
 // Result := SyssVAT.VATRates.UDFCaption[Index];
 newIndex := CustomFields.GetNewFieldIndex('VAT', index);
 category := Trunc(newIndex / 1000);

 //PR: 07/11/2011 Changed cfDescription to cfCaption; amended category and index as suggested by MH
 result := CustomFields[newIndex Div 1000, newIndex Mod 1000].cfCaption;
End;

Function TSystemSetupUserFields.GetUserFieldEnabled(Index : Integer) : Boolean;
Begin
  //SIN header/lines
  //PR: 07/11/2011 Removed 'not' from each line.
 case Index Of
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
  end;
end;

{-----------------------------------------}

function TSystemSetupUserFields.Get_ufAccount1: WideString;
begin
  Result := GetUserFieldName(1);
end;

function TSystemSetupUserFields.Get_ufAccount2: WideString;
begin
  Result := GetUserFieldName(2);
end;

function TSystemSetupUserFields.Get_ufAccount3: WideString;
begin
  Result := GetUserFieldName(11);
end;

function TSystemSetupUserFields.Get_ufAccount4: WideString;
begin
  Result := GetUserFieldName(12);
end;

function TSystemSetupUserFields.Get_ufJob1: WideString;
begin
  Result := GetUserFieldName(21);
end;

function TSystemSetupUserFields.Get_ufJob2: WideString;
begin
  Result := GetUserFieldName(22);
end;

function TSystemSetupUserFields.Get_ufLine1: WideString;
begin
  Result := GetUserFieldName(17);
end;

function TSystemSetupUserFields.Get_ufLine1Enabled: WordBool;
begin
  Result := GetUserFieldEnabled(5);
end;

function TSystemSetupUserFields.Get_ufLine2: WideString;
begin
  Result := GetUserFieldName(18);
end;

function TSystemSetupUserFields.Get_ufLine2Enabled: WordBool;
begin
  Result := GetUserFieldEnabled(6);
end;

function TSystemSetupUserFields.Get_ufLine3: WideString;
begin
  Result := GetUserFieldName(19);
end;

function TSystemSetupUserFields.Get_ufLine3Enabled: WordBool;
begin
  Result := GetUserFieldEnabled(7);
end;

function TSystemSetupUserFields.Get_ufLine4: WideString;
begin
  Result := GetUserFieldName(20);
end;

function TSystemSetupUserFields.Get_ufLine4Enabled: WordBool;
begin
  Result := GetUserFieldEnabled(8);
end;

function TSystemSetupUserFields.Get_ufStock1: WideString;
begin
  Result := GetUserFieldName(5);
end;

function TSystemSetupUserFields.Get_ufStock2: WideString;
begin
  Result := GetUserFieldName(6);
end;

function TSystemSetupUserFields.Get_ufStock3: WideString;
begin
  Result := GetUserFieldName(15);
end;

function TSystemSetupUserFields.Get_ufStock4: WideString;
begin
  Result := GetUserFieldName(16);
end;

function TSystemSetupUserFields.Get_ufTrans1: WideString;
begin
  Result := GetUserFieldName(3);
end;

function TSystemSetupUserFields.Get_ufTrans1Enabled: WordBool;
begin
  Result := GetUserFieldEnabled(1);
end;

function TSystemSetupUserFields.Get_ufTrans2: WideString;
begin
  Result := GetUserFieldName(4);
end;

function TSystemSetupUserFields.Get_ufTrans2Enabled: WordBool;
begin
  Result := GetUserFieldEnabled(2);
end;

function TSystemSetupUserFields.Get_ufTrans3: WideString;
begin
  Result := GetUserFieldName(13);
end;

function TSystemSetupUserFields.Get_ufTrans3Enabled: WordBool;
begin
  Result := GetUserFieldEnabled(3);
end;

function TSystemSetupUserFields.Get_ufTrans4: WideString;
begin
  Result := GetUserFieldName(14);
end;

function TSystemSetupUserFields.Get_ufTrans4Enabled: WordBool;
begin
  Result := GetUserFieldEnabled(4);
end;

function TSystemSetupUserFields.Get_ufLineType1: WideString;
begin
  result := CustomFields[cfLinetypes,1].cfCaption;
end;

function TSystemSetupUserFields.Get_ufLineType1Enabled: WordBool;
begin
  result := CustomFields[cfLinetypes,1].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufLineType2: WideString;
begin
  result := CustomFields[cfLinetypes,2].cfCaption;
end;

function TSystemSetupUserFields.Get_ufLineType2Enabled: WordBool;
begin
  result := CustomFields[cfLinetypes,2].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufLineType3: WideString;
begin
  result := CustomFields[cfLinetypes,3].cfCaption;
end;

function TSystemSetupUserFields.Get_ufLineType3Enabled: WordBool;
begin
  result := CustomFields[cfLinetypes,3].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufLineType4: WideString;
begin
    result := CustomFields[cfLinetypes,4].cfCaption;
end;

function TSystemSetupUserFields.Get_ufLineType4Enabled: WordBool;
begin
  result := CustomFields[cfLinetypes,4].cfEnabled;
end;

{$I oUserDef.pas}

{-------------------------------------------------------------------------------------------------}

Constructor TSystemSetupReleaseCodes.Create;
Begin { Create }
  //Inherited Create (ComServer.TypeLib, ISystemSetupReleaseCodes4); //PR: 21/01/2011 ABSEXCH-10392
  //SSK 17/11/2016 2017-R1 ABSEXCH-13960
  //AP 22/12/2017 2018-R1 ABSEXCH-19402
  Inherited Create (ComServer.TypeLib, ISystemSetupReleaseCodes6);

End; { Create }

{-----------------------------------------}

function TSystemSetupReleaseCodes.Get_rcAccountStockAnalysis: TReleaseCodeStatus;
begin
  Result := CalcRelCode (6);
end;

function TSystemSetupReleaseCodes.Get_rcCommitment: TReleaseCodeStatus;
begin
  Result := CalcRelCode (10);
end;

function TSystemSetupReleaseCodes.Get_rcEBusiness: TReleaseCodeStatus;
begin
  Result := CalcRelCode (7);
end;

function TSystemSetupReleaseCodes.Get_rcJobCosting: TReleaseCodeStatus;
begin
  Result := CalcRelCode (2);
end;

function TSystemSetupReleaseCodes.Get_rcMultiCurrency: TReleaseCodeStatus;
begin
  Result := CalcRelCode (1);
end;

function TSystemSetupReleaseCodes.Get_rcOLESave: TReleaseCodeStatus;
begin
  Result := CalcRelCode (9);
end;

function TSystemSetupReleaseCodes.Get_rcPaperless: TReleaseCodeStatus;
begin
  Result := CalcRelCode (8);
end;

function TSystemSetupReleaseCodes.Get_rcReportWriter: TReleaseCodeStatus;
begin
  Result := CalcRelCode (3);
end;

function TSystemSetupReleaseCodes.Get_rcTelesales: TReleaseCodeStatus;
begin
  Result := CalcRelCode (5);
end;

function TSystemSetupReleaseCodes.Get_rcToolkitDLL: TReleaseCodeStatus;
begin
  Result := CalcRelCode (4);
end;

function TSystemSetupReleaseCodes.Get_rcTradeCounter: TReleaseCodeStatus;
begin
  Result := CalcRelCode (11);
end;

function TSystemSetupReleaseCodes.Get_rcWOPStandard: TReleaseCodeStatus;
begin
  Result := CalcRelCode (12);
end;

function TSystemSetupReleaseCodes.Get_rcWOPProfessional: TReleaseCodeStatus;
begin
  Result := CalcRelCode (13);
end;

function TSystemSetupReleaseCodes.Get_rcSentimail: TReleaseCodeStatus;
begin
  Result := CalcRelCode (14);
end;

function TSystemSetupReleaseCodes.Get_rcEnhancedSecurity: TReleaseCodeStatus;
begin
  Result := CalcRelCode (15);
end;

function TSystemSetupReleaseCodes.Get_rcCISRCT: TReleaseCodeStatus;
begin
  Result := CalcRelCode (16);
end;

function TSystemSetupReleaseCodes.Get_rcAppsAndVals: TReleaseCodeStatus;
begin
  Result := CalcRelCode (17);
end;

function TSystemSetupReleaseCodes.Get_rcFullStockControl: TReleaseCodeStatus;
begin
  Result := CalcRelCode (18);
end;

function TSystemSetupReleaseCodes.Get_rcVisualReportWriter: TReleaseCodeStatus;
begin
  Result := CalcRelCode (19);
end;

function TSystemSetupReleaseCodes.Get_rcGoodsReturns: TReleaseCodeStatus;
begin
  Result := CalcRelCode (20);
end;

function TSystemSetupReleaseCodes.Get_rcEBanking: TReleaseCodeStatus;
begin
  Result := CalcRelCode (21);
end;



{-------------------------------------------------------------------------------------------------}

constructor TSystemSetupJob.Create;
Begin { Create }
  //SSK 18/10/2016 2017-R1 ABSEXCH-13961: ISystemSetupJob2
  Inherited Create (ComServer.TypeLib, ISystemSetupJob2);

End; { Create }

function  TSystemSetupJob.Get_ssUsePPIsForTimeSheets: WordBool;
begin
  Result := SyssJob.JobSetup.GenPPI;
end;

function  TSystemSetupJob.Get_ssSplitJobBudgetsByPeriod: WordBool;
begin
  Result := SyssJob.JobSetup.PeriodBud;
end;

function  TSystemSetupJob.Get_ssPPISupAccount: WideString;
begin
  Result := SyssJob.JobSetup.PPIAcCode;
end;

function  TSystemSetupJob.Get_ssJobCategory(Index: TJobCategoryType): WideString; safecall;
begin
//Convert from zero based index to 1
  Result := SyssJob.JobSetup.SummDesc[Succ(Ord(Index))]
end;

function TSystemSetupJob.Get_ssCheckJobBudget: WordBool;
begin
  Result := Syss.WarnJC;
end;

function  TSystemSetupJob.Get_ssJobCostingGLCtrlCodes(Index : TSystemSetupJobGLCtrlType): Integer;
begin
  Result := SyssJob.JobSetup.EmployeeNom[Integer(Index) + 1, Boff];
end;


{-------------------------------------------------------------------------------------------------}
constructor TSystemSetupPaperless.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ISystemSetupPaperless3);

End; { Create }


function TSystemSetupPaperless.Get_ssYourEmailName: WideString;
begin
  Result := SyssEDI2^.EDI2Value.EmName;
end;

function TSystemSetupPaperless.Get_ssYourEmailAddress: WideString;
begin
  Result := SyssEDI2^.EDI2Value.EmAddress;
end;

function TSystemSetupPaperless.Get_ssSMTPServer: WideString;
begin
  Result := SyssEDI2^.EDI2Value.EmSMTP;
end;

function TSystemSetupPaperless.Get_ssDefaultEmailPriority: TEmailPriority;
begin
  Result := TEmailPriority(SyssEDI2^.EDI2Value.EmPriority);
end;

function TSystemSetupPaperless.Get_ssEmailUseMAPI: WordBool;
begin
  Result := SyssEDI2^.EDI2Value.EmUseMAPI;
end;

function TSystemSetupPaperless.Get_ssAttachMethod: TEmailAttachMethod;
begin
  Result := SyssEDI2^.EDI2Value.emAttchMode;
end;

function TSystemSetupPaperless.Get_ssFaxFromName: WideString;
begin
  Result := SyssEDI2^.EDI2Value.FxName;
end;

function TSystemSetupPaperless.Get_ssFaxFromTelNo: WideString;
begin
  Result := SyssEDI2^.EDI2Value.FxPhone;
end;

function TSystemSetupPaperless.Get_ssFaxInterfacePath: WideString;
begin
  Result := SyssEDI2^.EDI2Value.FaxDLLPath;
end;

function TSystemSetupPaperless.Get_ssFaxUsing: TFaxMethod;
begin
  Result := SyssEDI2^.EDI2Value.FxUseMAPI;
end;

function TSystemSetupPaperless.Get_ssCompanyEmailSignature: WideString;
begin
  Result := LoadSig(0);
end;

function TSystemSetupPaperless.Get_ssCompanyFaxSignature: WideString;
begin
  Result := LoadSig(1);
end;

function TSystemSetupPaperless.LoadSig(WhichSig : SmallInt) : WideString;
var
  FileName : string;
  s : string;
  F : TextFile;
begin
  Result := '';
  FileName := SetDrive + 'DOCMASTR\COMPANY';

  if WhichSig = 0 then
    AssignFile(F, FileName + ExtEmailSig)
  else
    AssignFile(F, FileName + ExtFaxSig);

{$I-}
  Reset(F);
  if IOResult = 0 then
  while not EOF(F) do
  begin
    ReadLn(F, s);
    Result := Result + s + #13#10;
  end;
{$I+}
  if Length(Result) > 0 then
    Delete(Result, Length(Result)-1, 2);
end;

{-------------------------------------------------------------------------------------------------}

const
  FDArray : Array[fdCustSuppAccDet..fdPRN] of Byte =
                                   (1, 2, 3, 4, 5, 38, 39, 40,
                                    6, 7, 8, 9, 10, 11, 12, 13,
                                    14, 15, 16, 17, 18, 19, 20, 21,
                                    45, 22, 41, 23, 24, 25, 42,
                                    26, 27, 28, 29, 46, 30, 31, 32,
                                    35, 36, 37, 47, 51, 48, 49, 50,
                                    43, 44, 33, 34, 52, 53, 54,
                                    56, 59, 61, 55, 57, 58, 60,
                                    62, 63, 64);

  FormDefPFix = 'FR';

constructor TSystemSetupFormDefinitionSet.Create(Const BtrIntf  : TCtkTdPostExLocalPtr);
begin
  Inherited Create (ComServer.TypeLib, ISystemSetupFormDefinitionSet, BtrIntf);

  FFileNo := SysF;
  FIDNo := 0;
  FillChar(FDefRec, SizeOf(FDefRec), #0);

end;

function TSystemSetupFormDefinitionSet.Get_fdNumber: Byte;
begin
  Result := FIDNo;
end;

function TSystemSetupFormDefinitionSet.Get_fdDescription: WideString;
begin
  Result := FDefRec.Descr;
end;

function TSystemSetupFormDefinitionSet.Get_fdForms(Index: TFormDefinitionType): WideString;
begin
  Result := FDefRec.PrimaryForm[TranslateIDX(Index)];
end;

function TSystemSetupFormDefinitionSet.TranslateIdx(Index: TFormDefinitionType) : SmallInt;
begin
  Result := FDArray[Index];
end;

function TSystemSetupFormDefinitionSet.BuildNumberIndex(Number: Integer): WideString;
begin
  if Number = 0 then
    Result := 'M'
  else
  if (Number > 0) and (Number < 100) then
    Result := Char(100 + Number)
  else
    raise ERangeError.create('Form Definition Set: number must be 0 - 99');
end;

Procedure TSystemSetupFormDefinitionSet.CopyDataRecord;
begin
  FillChar(FDefRec, SizeOf(FDefRec), #0);
  Move(FbtrIntf^.LSyss.FormDefs, FDefRec, SizeOf(FDefRec));
  if Length(FKeyString) > 2 then
  begin
    if FKeyString[3] = 'M' then
      FIDNo := 0
    else
      FIDNo := Ord(FKeyString[3]) - 100;
  end;

end;

Function TSystemSetupFormDefinitionSet.GetDataRecord (Const BtrOp : SmallInt;
                        Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;

  function CheckID(const ID : string) : Boolean;
  begin
    Result := Copy(ID, 1, 2) = FormDefPFix;
  end;
Begin { GetDataRecord }
  BtrOpCode2 := 0;
  Result := 0;
  LastErDesc := '';
    With FBtrIntf^ Do
    Begin

      Loop := True;
      Case BtrOp of
        // Moving forward through file
        B_GetGEq,
        B_GetGretr,
        B_GetNext,
        B_GetFirst   : BtrOpCode2 := B_GetNext;

        // Moving backward through file
        B_GetLess,
        B_GetLessEq,
        B_GetPrev,
        B_GetLast    : BtrOpCode2 := B_GetPrev;

        // Looking for exact match - do it and finish
        B_GetEq      : Loop := False;
      Else
        Raise Exception.Create ('Invalid Btrieve Operation');
      End; { Case BtrOp}

      BtrOpCode := BtrOp;

      if BtrOpCode = B_GetFirst then
      begin
        KeyS :=  FormDefPFix + #0;
        BtrOpCode := B_GetGEq;
      end
      else
      if BtrOpCode = B_GetLast then
      begin
        KeyS :=  FormDefPFix + #255;
        BtrOpCode := B_GetLessEq;
      end
      else
        KeyS := FormDefPFix + SearchKey;

      Repeat
        Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

        BtrOpCode := BtrOpCode2;
      Until (Result <> 0) Or (Not Loop) Or (CheckID(LSyss.IDCode));

      FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If CheckID(LSyss.IDCode) Then
      begin
        // Convert to Toolkit structure
        CopyDataRecord;
      end
      Else
      //AP : 3/11/2016 : ABSEXCH-16305 GetNext returning Error 4 on Customer Object
      Begin
        If BtrOp = B_GetEq Then
          Result := 4
        else
          Result := 9;
      End;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

{  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (3, Result);}
end;

Destructor TSystemSetupFormDefinitionSet.Destroy;
begin
  Dispose (FBtrIntf, Destroy);
  inherited Destroy;
end;

{============================ TCISRate =======================================}
function TCISRate.Get_cisrCode: WideString;
begin
  Result := SyssCIS.CISRates.CISRate[FIdx].Code;
end;

function TCISRate.Get_cisrDescription: WideString;
begin
  Result := SyssCIS.CISRates.CISRate[FIdx].Desc;
end;

function TCISRate.Get_cisrRate: Double;
begin
  Result := Round_Up(SyssCIS.CISRates.CISRate[FIdx].Rate * 100, 2);
end;

function TCISRate.Get_cisrGLCode: Integer;
begin
  Result := SyssCIS.CISRates.CISRate[FIdx].GLCode;
end;

function TCISRate.Get_cisrCostCentre: WideString;
begin
  Result := SyssCIS.CISRates.CISRate[FIdx].RCCDep[True];
end;

function TCISRate.Get_cisrDepartment: WideString;
begin
  Result := SyssCIS.CISRates.CISRate[FIdx].RCCDep[False];
end;

procedure TCISRate.SetIdx(Value : TCISTaxType);
begin
  FIdx := CISTaxType(Pred(Value));
end;

//============================= TSystemSetupCIS ================================

function TSystemSetupCIS.Get_cisInterval: Integer;
begin
  Result := SyssCIS.CISRates.CISInterval;
end;

function TSystemSetupCIS.Get_cisAutoSetPeriod: WordBool;
begin
  Result := BoolToWordBool(SyssCIS.CISRates.CISAutoSetPr);
end;

function TSystemSetupCIS.Get_cisReturnDate: WideString;
begin
  Result := SyssCIS.CISRates.CISReturnDate;
end;

function TSystemSetupCIS.Get_cisTaxRef: WideString;
begin
  Result := SyssCIS.CISRates.CISTaxRef;
end;

function TSystemSetupCIS.Get_cisDefaultVatCode: WideString;
begin
  Result := SyssCIS.CISRates.CISVATCode;
end;

function TSystemSetupCIS.Get_cisFolioNumber: Integer;
begin
  Result := SyssCIS.CISRates.CISVFolio;
end;

function TSystemSetupCIS.Get_cisRate(TaxType: TCISTaxType): ICISRate;
var
  RateO : TCISRate;
begin
  if TaxType in [cisttConstruction, cisttTechnical] then
  begin
    RateO := TCISRate.Create(ComServer.TypeLib, ICISRate);
    RateO.Idx := TaxType;

    Result := RateO;
  end
  else
    Raise Exception.Create('No CIS Tax Rate is available for cisttNA');
end;

function TSystemSetupCIS.Get_cisVoucherCounter(VoucherType: TCISVoucherType): ICISVoucherCounter;
var
  CounterO : TCISVoucherCounter;
begin
  CounterO := TCISVoucherCounter.Create(ComServer.TypeLib, ICISVoucherCounter);
  CounterO.Idx := VoucherType;

  Result := CounterO;
end;

function TSystemSetupCIS.Get_cisContractorCertType: TCISCertificateType;
begin
  Result := SyssCIS.CISRates.JCISType;
end;

procedure TSystemSetupCIS.Set_cisContractorCertType(Value: TCISCertificateType);
begin
  if Value in [cisNA..cis6Group] then
    SyssCIS.CISRates.JCISType := Value
  else
    raise ERangeError.Create('Value out of range (' + IntToStr(Value) + ')');
end;

function TSystemSetupCIS.Get_cisContractorCertRef: WideString;
begin
  Result := SyssCIS.CISRates.JCertNo;
end;

procedure TSystemSetupCIS.Set_cisContractorCertRef(const Value: WideString);
begin
  SyssCIS.CISRates.JCertNo := Value;
end;

function TSystemSetupCIS.Get_cisContractorCertExpiry: WideString;
begin
  Result := SyssCIS.CISRates.JCertExpiry;
end;

procedure TSystemSetupCIS.Set_cisContractorCertExpiry(const Value: WideString);
begin
  SyssCIS.CISRates.JCertExpiry := Value;
end;

//=======================================================================================
function TCISVoucherCounter.Get_cvPrefix: WideString;
begin
  Result := SyssCIS.CISRates.CISVouchers[FIdx].Prefix;
end;

function TCISVoucherCounter.Get_cvCounter: WideString;
begin
  Result := IntToStr(SyssCIS.CISRates.CISVouchers[FIdx].Counter);
end;

procedure TCISVoucherCounter.SetIdx(Value : TCISVoucherType);
begin
  Case Value of
    cvt23 : FIdx := 5;
    cvt24 : FIdx := 6;
    cvt25 : FIdx := 4;
  end;
end;





{ TSystemSetupReturnLineReason }

function TSystemSetupReturnLineReason.BuildNumberIndex(
  Number: Integer): WideString;
begin
  Result := IntToStr(Number);
  Result := Copy('0000', 1, 4 - Length(Result)) + Result;
end;

procedure TSystemSetupReturnLineReason.CopyDataRecord;
begin
  with FBtrIntf^ do
     Move(LMiscRecs.rtReasonRec, FReasonRec, SizeOf(FReasonRec));
end;

constructor TSystemSetupReturnLineReason.Create(
  const BtrIntf: TCtkTdPostExLocalPtr);
begin
  Inherited Create (ComServer.TypeLib, ISystemSetupReturnLineReason, BtrIntf);
  FFileNo := MiscF;
  FillChar(FReasonRec, SizeOf(FReasonRec), 0);
end;

destructor TSystemSetupReturnLineReason.Destroy;
begin

  inherited;
end;

function TSystemSetupReturnLineReason.Get_rlrDescription: WideString;
begin
  Result := Trim(FReasonRec.ReasonDesc);
end;

function TSystemSetupReturnLineReason.Get_rlrNumber: Integer;
begin
  Result := FReasonRec.ReasonCount;
end;

function TSystemSetupReturnLineReason.GetDataRecord(const BtrOp: SmallInt;
  const SearchKey: String): Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, KeyChk          : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;

  With FBtrIntf^ Do Begin


    BtrOpCode := BtrOp;
    KeyS := RetRLCode + '1' + SearchKey;
    KeyChk := KeyS;

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetFirst   : Begin
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                       KeyS := RetRLCode + '1';
                     End;

      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       BtrOpCode  := B_GetLessEq;
                       BtrOpCode2 := B_GetPrev;
                       KeyS := RetRLCode + '1' + #255;
                     End;

      // Looking for exact match - do it and finish
      B_GetEq      : Loop := False;
    Else
      Raise Exception.Create ('Invalid Btrieve Operation');
    End; { Case BtrOp}

    Repeat
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      BtrOpCode := BtrOpCode2;

      //AP : 3/11/2016 : ABSEXCH-16305 GetNext returning Error 4 on Customer Object
      If (Not CheckKey(KeyS, KeyChk, Length(KeyChk), True)) and (BtrOp <> B_GetEq) Then
        // Not a Matching record - abandon operation
        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or CheckKey(KeyS, KeyChk, Length(KeyChk), True);

    FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LMiscRecs^.RecMFix = RetRLCode) And (LMiscRecs^.SubType = '1') Then
        // Take local Copy
        CopyDataRecord
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

{  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (8, Result);}
End; { GetDataRecord }


Function CreateTSystemSetupReturnLineReason (Const ClientId : Integer) : TSystemSetupReturnLineReason;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTAccount }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by TUser object
  BtrIntf^.Open_System(MiscF,  MiscF);

  // Create bas TAccount object
  Result := TSystemSetupReturnLineReason.Create(BtrIntf);
End; { CreateTAccount }


function TSystemSetup.Get_ssReturnLineReason: ISystemSetupReturnLineReason;
begin
  if (Not Assigned(FReturnLineReasonO)) then
  begin
    FReturnLineReasonO := CreateTSystemSetupReturnLineReason(48); //48 is btrieve ClientID

    FReturnLineReasonI := FReturnLineReasonO;
  end;

  Result := FReturnLineReasonI;
end;


function TSystemSetup.Get_ssEnforceGLClasses: WordBool;
begin
  Result := Syss.UseGLClass;
end;

function TSystemSetupCIS.Get_cisACOfficeRef: WideString;
begin
  Result := SyssCIS340.CIS340.CISACCONo;
end;

function TSystemSetupCIS.Get_cisContractorNINO: WideString;
begin
  Result := SyssCIS340.CIS340.CISCNINO;
end;

function TSystemSetupCIS.Get_cisCTR: WideString;
begin
  Result := SyssCIS.CISRates.JCertNo;
end;

function TSystemSetupCIS.Get_cisUTR: WideString;
begin
  Result := SyssCIS340.CIS340.CISCUTR;
end;

function TSystemSetupCIS.Get_cisSenderAuthentication: WideString;
begin
  Result :=  SyssCIS340.CIS340.IGWIRef;
end;

function TSystemSetupCIS.Get_cisSenderID: WideString;
begin
  Result := SyssCIS340.CIS340.IGWUId;
end;

function TSystemSetupCIS.Get_cisTaxOfficeNo: WideString;
begin
  Result := SyssCIS340.CIS340.IGWTO;
end;

function TSystemSetupCIS.Get_cisTaxOfficeRef: WideString;
begin
  Result := SyssCIS340.CIS340.IGWTR;
end;

function TSystemSetupCIS.Get_cisTestMode: WordBool;
begin
  Result := SyssCIS^.CISRates.ITestMode;
end;


function TSystemSetupPaperless.Get_ssEmailAttachmentPrinter: WideString;
begin
  Result := SyssEDI2^.EDI2Value.EmailPrnN;
end;

function TSystemSetupPaperless.Get_ssFaxPrinter: WideString;
begin
  Result := SyssEDI2^.EDI2Value.FaxPrnN;
end;

function TSystemSetupCIS.Get_cisSubmitterType: TCISSubmitterType;
begin
  Result := SyssCIS340.CIS340.IGSubType;
end;

function TSystemSetup.Get_ssCurrentVatPeriod: WideString;
begin
  Result := SyssVat.VATRAtes.CurrPeriod;
end;

function TSystemSetup.Get_ssVATScheme: TVATSchemeType;
begin
  if SyssVat.VATRAtes.VATScheme = VATSchC then
    Result := vsCashAccounting
  else
    Result := vsNormal;
end;

function TSystemSetup.Get_ssVATReturnInterval: Integer;
begin
  Result := SyssVat.VATRAtes.VATInterval;
end;

function TSystemSetup.Get_ssECSalesThreshold: Double;
begin
  Result := SyssVAT.VATRates.ECSalesThreshold;
end;

function TSystemSetup.Get_ssECServicesEnabled: WordBool;
begin
  Result := SyssVAT.VATRates.EnableECServices;
end;

function TSystemSetup.Get_ssEnableOverrideLocations: WordBool;
begin
  Result := Syss.EnableOverrideLocations;
end;

function TSystemSetup.Get_ssConsumersEnabled: WordBool;
begin
  Result := Syss.ssConsumersEnabled;
end;

function TSystemSetup.Get_ssContactRoles: ISystemSetupContactRolesList;
begin
  If (Not Assigned(FContactRolesListO)) Then Begin
    { Create and initialise the User Fields Info sub-object }
    FContactRolesListO := TSystemSetupContactRolesList.Create;

    FContactRolesListI := FContactRolesListO;
  End; { If (Not Assigned(FContactRolesListO)) }

  Result := FContactRolesListI;
end;

function TSystemSetup.Get_ssPromptPaymentDiscounts: ISystemSetupPromptPaymentDiscounts;
begin
  If (Not Assigned(FPPDO)) Then Begin
    { Create and initialise the User Fields Info sub-object }
    FPPDO := TSystemSetupPromptPaymentDiscounts.Create;

    FPPDI := FPPDO;
  End; { If (Not Assigned(FPPDO)) }

  Result := FPPDI;
end;

{ TCOMTKFontStyle }

//================================================================================
constructor TCOMTKFontStyle.Create(const AStyles : TFontStyles);
begin
  Inherited Create (ComServer.TypeLib, IFontStyle);
  Self.FStyles := AStyles;
end;

//================================================================================
function TCOMTKFontStyle.Get_fsBold: WordBool;
begin
  Result := fsBold in FStyles;
end;

//================================================================================
function TCOMTKFontStyle.Get_fsItalic: WordBool;
begin
  Result := fsItalic in FStyles;
end;

//================================================================================
function TCOMTKFontStyle.Get_fsStrikeout: WordBool;
begin
  Result := fsStrikeout in FStyles;
end;

//================================================================================
function TCOMTKFontStyle.Get_fsUnderline: WordBool;
begin
  Result := fsUnderline in FStyles;
end;

//================================================================================
procedure TCOMTKFontStyle.Set_fsBold(Value: WordBool);
begin
  Include(FStyles, fsBold);
end;

//================================================================================
procedure TCOMTKFontStyle.Set_fsItalic(Value: WordBool);
begin
  Include(FStyles, fsItalic);
end;

//================================================================================
procedure TCOMTKFontStyle.Set_fsStrikeout(Value: WordBool);
begin
  Include(FStyles, fsStrikeout);
end;

//================================================================================
procedure TCOMTKFontStyle.Set_fsUnderline(Value: WordBool);
begin
  Include(FStyles, fsUnderline);
end;

{ TSystemSetupPromptPaymentDiscounts }

//================================================================================
constructor TSystemSetupPromptPaymentDiscounts.Create;
begin
  Inherited Create (ComServer.TypeLib, ISystemSetupPromptPaymentDiscounts);
  InitObjects;
end;

//================================================================================
//Function to create (if necessary) and return the appropriate font style
function TSystemSetupPromptPaymentDiscounts.GetFontStyle(
  pc: TPPDColour): IFontStyle;
begin
  if not Assigned(FStylesI[pc]) then
  begin
    FStylesO[pc] := TCOMTKFontStyle.Create(GetSystemFontStyle(pc));

    FStylesI[pc] := FStylesO[pc];
  end;

  Result := FStylesI[pc];
end;

//================================================================================
destructor TSystemSetupPromptPaymentDiscounts.Destroy;
begin
  InitObjects;
  inherited;
end;

//================================================================================
//Gets the appropriate font style from system setup
function TSystemSetupPromptPaymentDiscounts.GetSystemFontStyle(
  pc: TPPDColour): TFontStyles;
begin
  Case pc of
    pcGreen   : Result := SystemSetup.PPD.PPDGreenColours.poFontStyle;
    pcAmber   : Result := SystemSetup.PPD.PPDAmberColours.poFontStyle;
    pcRed     : Result := SystemSetup.PPD.PPDRedColours.poFontStyle;
    pcExpired : Result := SystemSetup.PPD.PPDExpiredColours.poFontStyle;
  end; //case
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDAmberBackgroundColour: Integer;
begin
  Result := SystemSetup.PPD.PPDAmberColours.poBackgroundColour;
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDAmberDays: Integer;
begin
  Result := SystemSetup.PPD.PPDAmberDays;
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDAmberFontColour: Integer;
begin
  Result := SystemSetup.PPD.PPDAmberColours.poFontColour;
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDAmberFontStyle: IFontStyle;
begin
  Result := GetFontStyle(pcAmber);
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDExpiredBackgroundColour: Integer;
begin
  Result := SystemSetup.PPD.PPDExpiredColours.poBackgroundColour;
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDExpiredFontColour: Integer;
begin
  Result := SystemSetup.PPD.PPDExpiredColours.poFontColour;
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDExpiredFontStyle: IFontStyle;
begin
  Result := GetFontStyle(pcExpired);
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDGreenBackgroundColour: Integer;
begin
  Result := SystemSetup.PPD.PPDGreenColours.poBackgroundColour;
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDGreenFontColour: Integer;
begin
  Result := SystemSetup.PPD.PPDGreenColours.poFontColour;
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDGreenFontStyle: IFontStyle;
begin
  Result := GetFontStyle(pcGreen);
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDRedBackgroundColour: Integer;
begin
  Result := SystemSetup.PPD.PPDRedColours.poBackgroundColour;
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDRedDays: Integer;
begin
  Result := SystemSetup.PPD.PPDRedDays;
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDRedFontColour: Integer;
begin
  Result := SystemSetup.PPD.PPDRedColours.poFontColour;
end;

//================================================================================
function TSystemSetupPromptPaymentDiscounts.Get_ssPPDRedFontStyle: IFontStyle;
begin
  Result := GetFontStyle(pcRed);
end;

//================================================================================
procedure TSystemSetupPromptPaymentDiscounts.InitObjects;
var
  pc : TPPDColour;
begin
  for pc := pcGreen to pcExpired do
  begin
    FStylesO[pc] := nil;
    FStylesI[pc] := nil;
  end;
end;

//================================================================================
function TSystemSetup.Get_ssEnableOrderPayments: WordBool;
begin
  Result := Syss.ssEnableOrderPayments;
end;

{ TSystemSetupCountryDetails }

constructor TSystemSetupCountryDetails.Create(
  CountryDetails: IISO3166CountryDetails);
begin
  inherited Create (ComServer.TypeLib, ICountryDetails);
  FCountryDetails := CountryDetails;
end;

destructor TSystemSetupCountryDetails.Destroy;
begin
  FCountryDetails := nil;
  inherited;
end;

function TSystemSetupCountryDetails.Get_cdCode2: WideString;
begin
  Result := FCountryDetails.cdCountryCode2;
end;

function TSystemSetupCountryDetails.Get_cdCode3: WideString;
begin
  Result := FCountryDetails.cdCountryCode3;
end;

function TSystemSetupCountryDetails.Get_cdCodeNumeric: WideString;
begin
  Result := FCountryDetails.cdCountryCodeNumeric;
end;

function TSystemSetupCountryDetails.Get_cdName: WideString;
begin
  Result := FCountryDetails.cdCountryName;
end;

{ TSystemSetupCountryList }

function TSystemSetupCountryList.Get_clCount: Integer;
begin
  Result := ISO3166CountryCodes.ccCount;
end;

function TSystemSetupCountryList.Get_clCountry(
  Index: Integer): ICountryDetails;
begin
  //PR: 27/01/2015 ABSEXCH-16066 Change country list to be 1 based
  if (Index >= 1) and (Index <= Get_clCount) then
    Result := TSystemSetupCountryDetails.Create(ISO3166CountryCodes.ccCountryDetails[Index - 1])
  else
    raise EInvalidMethod.Create('Index out of range (' + IntToStr(Index) + ')');
end;

function TSystemSetupCountryList.IndexOf(CodeType: TCountryCodeType;
  const Code: WideString): Integer;
begin
  //PR: 27/01/2015 ABSEXCH-16066 Change country list to be 1 based
  Result := ISO3166CountryCodes.IndexOf(enumIndexFieldType(CodeType), Code) + 1;
end;

function TSystemSetup.Get_ssCountryList: ICountryList;
begin
  if not Assigned(FCountryListO) then
  begin
    FCountryListO := TSystemSetupCountryList.Create(ComServer.TypeLib, ICountryList);

    FCountryListI := FCountryListO;
  end;

  Result := FCountryListI;
end;


//PR: 20/01/2016 ABSEXCH-17112 v2016 R1
function TSystemSetup.Get_ssIntrastatSetup: IIntrastatSetup;
begin
  if not Assigned(FIntrastatO) then
  begin
    FIntrastatO := TIntrastatSetup.Create;

    FIntrastatI := FIntrastatO;
  end;

  Result := FIntrastatI;
end;

//SSK 18/10/2016 2017-R1 ABSEXCH-13961: Implementation to get System Setup Options
function TSystemSetup.Get_ssUseTransactionTotalDiscounts: WordBool;
begin
  Result := Syss.EnableTTDDiscounts;
end;

function TSystemSetup.Get_ssIncludeVATInCommittedBalances: WordBool;
begin
  Result := Syss.IncludeVATInCommittedBalance;
end;

function TSystemSetup.Get_ssUseValueBasedDiscounts: WordBool;
begin
  Result := Syss.EnableVBDDiscounts;
end;

function TSystemSetupJob.Get_ssDelayApplicationCommittedUntilCertified: WordBool;
begin
  Result := SyssJob.JobSetup.JADelayCert;
end;

function TSystemSetupJob.Get_ssIncludeUnpostedPurchasesInCommitted: WordBool;
begin
  Result := SyssJob.JobSetup.JCCommitPin;
end;

function TSystemSetupJob.Get_ssUseApplicationDateForInvoice: WordBool;
begin
  Result := SyssJob.JobSetup.JAInvDate;
end;

function TSystemSetupJob.Get_ssProtectApplicationYourRef: WordBool;
begin
  result := Syss.ProtectYRef;
end;

function TSystemSetupReleaseCodes.Get_rcImporter: TReleaseCodeStatus;
begin
  Result := CalcRelCode (23);
end;

function TSystemSetupReleaseCodes.Get_rcOutlookDynamicDashboard: TReleaseCodeStatus;
begin
  Result := CalcRelCode (22);
end;

//AP:22/12/2017:2018-R1:ABSEXCH-19402
function TSystemSetupReleaseCodes.Get_rcGDPR: TReleaseCodeStatus;
begin
  Result := CalcRelCode (24);
end;

function TSystemSetupReleaseCodes.Get_rcPervasiveEncryption: TReleaseCodeStatus;
begin
  Result := CalcRelCode (25);
end;

//SS:07/06/2017:2017-R2:ABSEXCH-18611:Currency Import Tolerance support to be added in COM Toolkit.
function TSystemSetup.Get_ssCurrencyImportTolerance: Single;
begin
  Result := SystemSetup.CurrencySetup.ssCurrImportTol;
end;

function TSystemSetup.Get_ssLoginAuthenticationMode: WideString;
begin
  with SystemSetup(True) do
  begin
    Result := PasswordAuthentication.AuthenticationMode;
  end;
end;

//AP: 06/02/2018 ABSEXCH-19402 v2018 R1
Constructor TSystemSetupGDPR.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, IGDPRSetup);
End; { Create }

function TSystemSetup.Get_ssGDPR: IGDPRSetup;
begin
  if (Not Assigned(FGDPRO)) then
  begin
    FGDPRO := TSystemSetupGDPR.Create;
    FGDPRI := FGDPRO;
  end;
  Result := FGDPRI;
end;

//AP 29/11/2017 2018-R1 ABSEXCH-19402: Implementation for GDPR
function TSystemSetupGDPR.Get_Anonymised: WordBool;
begin
  Result := SystemSetup.GDPR.Anonymised;
end;

function TSystemSetupGDPR.Get_AnonymisedDate: WideString;
begin
  Result := SystemSetup.GDPR.AnonymisedDate;
end;

function TSystemSetupGDPR.Get_AnonymisedTime: WideString;
begin
  Result := SystemSetup.GDPR.AnonymisedTime;
end;

function TSystemSetupGDPR.Get_GDPRTraderRetentionPeriod: Integer;
begin
  Result := SystemSetup.GDPR.GDPRTraderRetentionPeriod;
end;

function TSystemSetupGDPR.Get_GDPRTraderDisplayPIITree: WordBool;
begin
  Result := SystemSetup.GDPR.GDPRTraderDisplayPIITree;
end;

function TSystemSetupGDPR.Get_GDPRTraderAnonNotesOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPRTraderAnonNotesOption;
end;

function TSystemSetupGDPR.Get_GDPRTraderAnonLettersOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPRTraderAnonLettersOption;
end;

function TSystemSetupGDPR.Get_GDPRTraderAnonLinksOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPRTraderAnonLinksOption;
end;

function TSystemSetupGDPR.Get_GDPREmployeeRetentionPeriod: Integer;
begin
  Result := SystemSetup.GDPR.GDPREmployeeRetentionPeriod;
end;

function TSystemSetupGDPR.Get_GDPREmployeeDisplayPIITree: WordBool;
begin
  Result := SystemSetup.GDPR.GDPREmployeeDisplayPIITree;
end;

function TSystemSetupGDPR.Get_GDPREmployeeAnonNotesOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPREmployeeAnonNotesOption;
end;

function TSystemSetupGDPR.Get_GDPREmployeeAnonLettersOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPREmployeeAnonLettersOption;
end;

function TSystemSetupGDPR.Get_GDPREmployeeAnonLinksOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPREmployeeAnonLinksOption;
end;

function TSystemSetupGDPR.Get_NotificationWarningColour: Integer;
begin
  Result := SystemSetup.GDPR.NotificationWarningColour;
end;

function TSystemSetupGDPR.Get_NotificationWarningFontColour: Integer;
begin
  Result := SystemSetup.GDPR.NotificationWarningFontColour;
end;

function TSystemSetupGDPR.Get_GDPRCompanyAnonLocations: WordBool;
begin
  Result := SystemSetup.GDPR.GDPRCompanyAnonLocations;
end;

function TSystemSetupGDPR.Get_GDPRCompanyAnonCostCentres: WordBool;
begin
  Result := SystemSetup.GDPR.GDPRCompanyAnonCostCentres;
end;

function TSystemSetupGDPR.Get_GDPRCompanyAnonDepartment: WordBool;
begin
  Result := SystemSetup.GDPR.GDPRCompanyAnonDepartment;
end;

function TSystemSetupGDPR.Get_GDPRCompanyNotesOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPRCompanyNotesOption;
end;

function TSystemSetupGDPR.Get_GDPRCompanyLettersOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPRCompanyLettersOption;
end;

function TSystemSetupGDPR.Get_GDPRCompanyLinksOption: Integer;
begin
  Result := SystemSetup.GDPR.GDPRCompanyLinksOption;
end;

Initialization

  {$I SSARY.PAS}  //Initialises user defined fields array


end.
