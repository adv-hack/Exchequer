unit Enterprise01_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.130.3.0.1.0  $
// File generated on 02/10/2002 14:30:34 from Type Library described below.

// ************************************************************************  //
// Type Lib: M:\Dev500\ENTTOOLK.DLL (1)
// LIBID: {B7D657C0-37AB-11D4-A992-0050DA3DF9AD}
// LCID: 0
// Helpfile: X:\ENTRPRSE\COMTK\ENTCOMTK.HLP
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
// Parent TypeLibrary:
//   (0) v1.0 EnterpriseForms, (X:\ENTRPRSE\FormTK\ENTFORMS.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  Enterprise01MajorVersion = 1;
  Enterprise01MinorVersion = 0;

  LIBID_Enterprise01: TGUID = '{B7D657C0-37AB-11D4-A992-0050DA3DF9AD}';

  IID_IToolkit: TGUID = '{F9C1BB21-3625-11D4-A992-0050DA3DF9AD}';
  CLASS_Toolkit: TGUID = '{F9C1BB23-3625-11D4-A992-0050DA3DF9AD}';
  IID_IAccount: TGUID = '{FF16609E-53F0-11D4-A997-0050DA3DF9AD}';
  IID_ITransaction: TGUID = '{B7D657CD-37AB-11D4-A992-0050DA3DF9AD}';
  IID_IAddress: TGUID = '{DC6692C0-3DE2-11D4-A992-0050DA3DF9AD}';
  IID_IAccountBalance: TGUID = '{3D6C20E3-87D4-11D4-A998-0050DA3DF9AD}';
  IID_IFunctions: TGUID = '{8EAA86A8-8A3F-11D4-A998-0050DA3DF9AD}';
  IID_ITransactionLines: TGUID = '{7F01D062-8EE4-11D4-A998-0050DA3DF9AD}';
  IID_ITransactionLine: TGUID = '{7F01D064-8EE4-11D4-A998-0050DA3DF9AD}';
  IID_ISystemSetup: TGUID = '{824D7D3F-9065-11D4-A998-0050DA3DF9AD}';
  IID_ISystemSetupCurrency: TGUID = '{729B93A2-92C8-11D4-A998-0050DA3DF9AD}';
  IID_ISystemSetupReleaseCodes: TGUID = '{D155AD20-9AB8-11D4-A998-0050DA3DF9AD}';
  IID_ISystemSetupUserFields: TGUID = '{729B93A4-92C8-11D4-A998-0050DA3DF9AD}';
  IID_ISystemSetupVAT: TGUID = '{729B93A0-92C8-11D4-A998-0050DA3DF9AD}';
  IID_IStock: TGUID = '{E42A0800-95EB-11D4-A998-0050DA3DF9AD}';
  IID_IStockCover: TGUID = '{E42A0ABE-95EB-11D4-A998-0050DA3DF9AD}';
  IID_IStockIntrastat: TGUID = '{E42A0AC0-95EB-11D4-A998-0050DA3DF9AD}';
  IID_IStockReorder: TGUID = '{E42A0AC2-95EB-11D4-A998-0050DA3DF9AD}';
  IID_IStockSalesBand: TGUID = '{E42A0AC4-95EB-11D4-A998-0050DA3DF9AD}';
  IID_IConfiguration: TGUID = '{D8FFA280-9DF4-11D4-A998-0050DA3DF9AD}';
  IID_IEnterprise: TGUID = '{E55AB740-B591-11D4-A998-0050DA3DF9AD}';
  IID_IGeneralLedger: TGUID = '{517AF840-BEF7-11D4-A99A-0050DA3DF9AD}';
  IID_ILocation: TGUID = '{C6021740-C12A-11D4-A99D-0050DA3DF9AD}';
  IID_ICCDept: TGUID = '{904B9E00-C21A-11D4-A99D-0050DA3DF9AD}';
  IID_ICompanyManager: TGUID = '{6BEE79E0-C447-11D4-A99D-0050DA3DF9AD}';
  IID_ICompanyDetail: TGUID = '{6BEE79E2-C447-11D4-A99D-0050DA3DF9AD}';
  IID_IStockLocation: TGUID = '{AA0B2440-C47D-11D4-A99D-0050DA3DF9AD}';
  IID_INotes: TGUID = '{9C7385A0-CB91-11D4-A99D-0050DA3DF9AD}';
  IID_IJobCosting: TGUID = '{AEDD67E0-D025-11D4-A99D-0050DA3DF9AD}';
  IID_IJob: TGUID = '{27DD7520-D046-11D4-A99D-0050DA3DF9AD}';
  IID_IMatching: TGUID = '{9F578D00-E60F-11D4-A99D-0050DA3DF9AD}';
  IID_IAccountDiscount: TGUID = '{1F48FEA0-EAD8-11D4-A99D-0050DA3DF9AD}';
  IID_IEBusiness: TGUID = '{1EA22040-85BB-4E12-A061-B68F7163CAF2}';
  IID_IQuantityBreak: TGUID = '{985AEDBF-3998-4C71-8334-165AE77C0277}';
  IID_ISystemSetupJob: TGUID = '{BA8037CE-A4D6-4A2F-B12F-C09BB13B3916}';
  IID_ISystemSetupPaperless: TGUID = '{03EBB14E-7774-4501-87C1-F1B7767C1D4B}';
  IID_IJobType: TGUID = '{EC687B21-AC15-43F1-A031-4B4A8FD7DEC0}';
  IID_IJobAnalysis: TGUID = '{05D4346A-D608-4B22-A111-C5C892CE19C7}';
  IID_IStockBOMComponent: TGUID = '{F3385C2A-C16E-483D-B05D-D45AF6480E5A}';
  IID_IStockBOMList: TGUID = '{89740FE6-BAE4-4CD7-A361-99F8515DE772}';
  IID_IStockWhereUsed: TGUID = '{04E4114B-D6FE-4725-9652-15F4C16033A6}';
  IID_IEmployee: TGUID = '{098A6D33-08B3-40E6-A803-3B07B7AED954}';
  IID_ITimeRates: TGUID = '{9D4BD33D-A272-4958-9E4A-773F50AC93A9}';
  IID_ISerialBatchDetails: TGUID = '{AA23C9A5-3DB6-4C3C-8A8D-52B2FE344C8E}';
  IID_ISerialBatch: TGUID = '{0834B7FA-A2F0-48AA-ABA6-1E5832CB175C}';
  IID_ITransactionLineSerialBatch: TGUID = '{CEF58474-422A-482D-9474-3C37C64E445B}';
  IID_IInternalDebug: TGUID = '{1C16D217-DB7F-4D29-8E60-7537AB13741D}';
  IID_IUserProfile: TGUID = '{AD907C7D-C3D8-40BD-9D9B-CCE19F1E0558}';
  IID_IToolkit2: TGUID = '{B52C7B92-50E3-4602-9B8C-0F6E05622304}';
  IID_ITransactionDetails: TGUID = '{F91F7E18-641C-4600-A4C2-18D756559BD4}';
  IID_ISystemSetupUserFields2: TGUID = '{AF7BDC08-BFC4-499B-AA0A-185E16A7280D}';
  IID_ISystemSetup2: TGUID = '{712B8CB0-9B76-415C-AE26-A5A60F987C49}';
  IID_ISystemSetupPaperless2: TGUID = '{1AC29FCE-0BDF-4F59-890C-1123DDCF8521}';
  IID_ISystemSetupFormDefinitionSet: TGUID = '{EB635BB7-E282-4A94-B2EC-1C7630E922BF}';
  IID_ITransaction2: TGUID = '{EB5E465C-E90B-4D7C-BF3F-EA1B3A398C84}';
  IID_IPrintJob: TGUID = '{73050723-DEFE-4ED1-8FAD-B488315E6E0E}';
  IID_IPrintJobPrinterInfo: TGUID = '{E645C8D0-0472-44E3-88D8-EB0B2613BB97}';
  IID_IPrintJobEmailInfo: TGUID = '{4C8C6D88-1BDC-4BE8-85D6-584B3C02970A}';
  IID_IPrintJobFaxInfo: TGUID = '{89124927-CB4F-4EC8-B5AC-EFFD301D35C4}';
  IID_ITransactionAsNOM: TGUID = '{DE890BE4-B279-4DCE-8E71-9A9B8FBAFD4F}';
  IID_ITransactionAsTSH: TGUID = '{8DE6DBFD-16DA-46FA-8FA8-B426DEACC327}';
  IID_ITransactionLineAsNOM: TGUID = '{D9E5B9E2-D4F8-4BEC-AD69-5A7955C34503}';
  IID_ITransactionLine2: TGUID = '{B0155989-B2A5-4966-BD10-00E52604A7D7}';
  IID_ITransactionLineAsTSH: TGUID = '{48A2DB49-F3CA-4E4F-A2D2-3097D8B24A84}';
  IID_ITransactionAsADJ: TGUID = '{26EFB79B-2850-47C7-8652-40F3C54B26EB}';
  IID_ITransactionLineAsADJ: TGUID = '{5D9D845C-0D73-4F8D-8464-31C95AA9267C}';
  IID_ITransactionAsWOR: TGUID = '{9161D394-AF47-426C-9F6A-5940EE80E167}';
  IID_ITransactionLineAsWOR: TGUID = '{2F2EB85B-4454-4AAA-AC81-D0F4160AE181}';
  IID_ILinks: TGUID = '{867DDF64-B570-4A37-A813-E738641C02A2}';
  IID_IJob2: TGUID = '{9760EDF5-D06C-47BE-B6F7-4663E7D3D885}';
  IID_IAutoTransactionSettings: TGUID = '{23571D0C-3F7A-40BE-84F7-0089D1B1D197}';
  IID_IPrinterDetail: TGUID = '{8BAC23C1-720D-446D-A59B-822943C9FAE5}';
  IID_IStringListReadOnly: TGUID = '{933CF587-FF14-44FF-906D-297551AE00F4}';
  IID_IStringArrayRW: TGUID = '{C45C2238-F3B2-4201-90F5-606CD55C18CF}';
  IID_IConvert: TGUID = '{E5DA8BA0-3D7F-4529-8280-D77DD949BE9F}';
  IID_ISingleConvert: TGUID = '{726389C6-B772-41AC-A193-CBA3BB01EDDA}';
  IID_IConvertList: TGUID = '{F35EF421-66A7-4BE7-A397-A915F213C280}';
  IID_ISystemProcesses: TGUID = '{5E2F72CA-792A-4832-9B30-ED095E7C5D1D}';
  IID_IEmailAddress: TGUID = '{696D9F72-2157-4045-B165-4832F34714D4}';
  IID_IEmailAddressArray: TGUID = '{EE8122D5-6624-490E-8250-E8DFE46A6336}';
  IID_IBackToBackOrder: TGUID = '{689697DA-91B1-4735-A920-69A4FA0F2FF8}';
  IID_ITransactionAsBatch: TGUID = '{BA1F00BA-2309-4640-9335-911DE000B4EB}';
  IID_IPrinters: TGUID = '{BB1DDDC1-4094-46E6-9E0F-7A4DAF4C2DA7}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TAccountStatus
type
  TAccountStatus = TOleEnum;
const
  asOpen = $00000000;
  asNotes = $00000001;
  asOnHold = $00000002;
  asClosed = $00000003;

// Constants for enum TToolkitStatus
type
  TToolkitStatus = TOleEnum;
const
  tkClosed = $00000000;
  tkOpen = $00000001;

// Constants for enum TDocTypes
type
  TDocTypes = TOleEnum;
const
  dtSIN = $00000000;
  dtSRC = $00000001;
  dtSCR = $00000002;
  dtSJI = $00000003;
  dtSJC = $00000004;
  dtSRF = $00000005;
  dtSRI = $00000006;
  dtSQU = $00000007;
  dtSOR = $00000008;
  dtSDN = $00000009;
  dtSBT = $0000000A;
  dtPIN = $0000000B;
  dtPPY = $0000000C;
  dtPCR = $0000000D;
  dtPJI = $0000000E;
  dtPJC = $0000000F;
  dtPRF = $00000010;
  dtPPI = $00000011;
  dtPQU = $00000012;
  dtPOR = $00000013;
  dtPDN = $00000014;
  dtPBT = $00000015;
  dtNMT = $00000016;
  dtADJ = $00000017;
  dtTSH = $00000018;
  dtWOR = $00000019;

// Constants for enum TIntrastatProcess
type
  TIntrastatProcess = TOleEnum;
const
  ipNormal = $00000000;
  ipTriangulation = $00000001;
  ipProcess = $00000002;

// Constants for enum TAccountIndex
type
  TAccountIndex = TOleEnum;
const
  acIdxCode = $00000000;
  acIdxName = $00000001;
  acIdxAltCode = $00000002;
  acIdxVATRegNo = $00000003;
  acIdxEmail = $00000004;
  acIdxPhone = $00000005;
  acIdxPostCode = $00000006;
  acIdxOurCode = $00000007;
  acIdxInvTo = $00000008;

// Constants for enum TTransactionIndex
type
  TTransactionIndex = TOleEnum;
const
  thIdxOurRef = $00000000;
  thIdxFolio = $00000001;
  thIdxAccount = $00000002;
  thIdxYourRef = $00000003;
  thIdxLongYourRef = $00000004;
  thIdxRunNo = $00000005;
  thIdxAccountDue = $00000006;
  thIdxPostedDate = $00000007;
  thIdxBatchLink = $00000008;
  thIdxTransDate = $00000009;
  thIdxYearPeriod = $0000000A;
  thIdxOutstanding = $0000000B;

// Constants for enum TStockIndex
type
  TStockIndex = TOleEnum;
const
  stIdxCode = $00000000;
  stIdxFolio = $00000001;
  stIdxParent = $00000002;
  stIdxDesc = $00000003;
  stIdxSupplier = $00000004;
  stIdxPandLGL = $00000005;
  stIdxAltCode = $00000006;
  stIdxBinLoc = $00000007;
  stIdxBarCode = $00000008;

// Constants for enum TStockType
type
  TStockType = TOleEnum;
const
  stTypeGroup = $00000000;
  stTypeProduct = $00000001;
  stTypeDescription = $00000002;
  stTypeBillOfMaterials = $00000003;
  stTypeDiscontinued = $00000004;

// Constants for enum TStockValuationType
type
  TStockValuationType = TOleEnum;
const
  stValStandard = $00000000;
  stValLastCost = $00000001;
  stValFIFO = $00000002;
  stValLIFO = $00000003;
  stValAverage = $00000004;
  stValSerial = $00000005;
  stValSerialAvgCost = $00000006;

// Constants for enum TReleaseCodeStatus
type
  TReleaseCodeStatus = TOleEnum;
const
  rcDisabled = $00000000;
  rc30Day = $00000001;
  rcEnabled = $00000002;

// Constants for enum TStockPricingMethod
type
  TStockPricingMethod = TOleEnum;
const
  spmByStockUnit = $00000000;
  spmBySalesUnit = $00000001;
  spmBySplitPack = $00000002;

// Constants for enum TEnterpriseCurrencyVersion
type
  TEnterpriseCurrencyVersion = TOleEnum;
const
  enProfessional = $00000000;
  enEuro = $00000001;
  enGlobal = $00000002;

// Constants for enum TGeneralLedgerIndex
type
  TGeneralLedgerIndex = TOleEnum;
const
  glIdxCode = $00000000;
  glIdxName = $00000001;
  glIdxParent = $00000002;
  glIdxAltCode = $00000003;

// Constants for enum TGeneralLedgerType
type
  TGeneralLedgerType = TOleEnum;
const
  glTypeProfitLoss = $00000000;
  glTypeBalanceSheet = $00000001;
  glTypeControl = $00000002;
  glTypeCarryFwd = $00000003;
  glTypeHeading = $00000004;

// Constants for enum TLocationIndex
type
  TLocationIndex = TOleEnum;
const
  loIdxCode = $00000000;
  loIdxName = $00000001;

// Constants for enum TCCDeptIndex
type
  TCCDeptIndex = TOleEnum;
const
  cdIdxCode = $00000000;
  cdIdxName = $00000001;

// Constants for enum TNotesType
type
  TNotesType = TOleEnum;
const
  ntTypeGeneral = $00000000;
  ntTypeDated = $00000001;

// Constants for enum TJobChargeType
type
  TJobChargeType = TOleEnum;
const
  JChrgTimeMaterials = $00000000;
  JChrgFixedPrice = $00000001;
  JChrgCostPlus = $00000002;
  JChrgNonProductive = $00000003;

// Constants for enum TJobStatusType
type
  TJobStatusType = TOleEnum;
const
  JStatusQuotation = $00000000;
  JStatusActive = $00000001;
  JStatusSuspended = $00000002;
  JStatusCompleted = $00000003;
  JStatusClosed = $00000004;

// Constants for enum TJobIndex
type
  TJobIndex = TOleEnum;
const
  jrIdxCode = $00000000;
  jrIdxFolio = $00000001;
  jrIdxParent = $00000002;
  jrIdxDesc = $00000003;
  jrIdxCompletedCode = $00000004;
  jrIdxCompletedDesc = $00000005;
  jrIdxAltCode = $00000006;
  jrIdxAccount = $00000007;

// Constants for enum TJobTypeType
type
  TJobTypeType = TOleEnum;
const
  JTypeContract = $00000000;
  JTypeJob = $00000001;
  JTypePhase = $00000002;

// Constants for enum TTransTotalsType
type
  TTransTotalsType = TOleEnum;
const
  TransTotInCcy = $00000000;
  TransTotInBase = $00000001;
  TransTotSettledInBase = $00000002;
  TransTotOutstandingInCcy = $00000003;
  TransTotOutstandingInBase = $00000004;
  TransTotNetInCcy = $00000005;
  TransTotNetInBase = $00000006;
  TransTotCostInBase = $00000007;
  TransTotSignedInCcy = $00000008;
  TransTotSignedInBase = $00000009;
  TransTotVarianceSignedInBase = $0000000A;
  TransTotRevalAdjustSignedInBase = $0000000B;

// Constants for enum TMatchingSubType
type
  TMatchingSubType = TOleEnum;
const
  maTypeFinancial = $00000000;
  maTypeSPOP = $00000001;

// Constants for enum TDiscountType
type
  TDiscountType = TOleEnum;
const
  DiscSpecialPrice = $00000000;
  DiscBandPrice = $00000001;
  DiscMargin = $00000002;
  DiscMarkup = $00000003;
  DiscQtyBreak = $00000004;

// Constants for enum TCurrencyRateType
type
  TCurrencyRateType = TOleEnum;
const
  rtCompany = $00000000;
  rtDaily = $00000001;

// Constants for enum TEmailPriority
type
  TEmailPriority = TOleEnum;
const
  epLow = $00000000;
  epNormal = $00000001;
  epHigh = $00000002;

// Constants for enum TEmailAttachMethod
type
  TEmailAttachMethod = TOleEnum;
const
  eamInternal = $00000000;
  eamAcrobat = $00000001;
  eamInternalPDF = $00000002;

// Constants for enum TFaxMethod
type
  TFaxMethod = TOleEnum;
const
  fmEnterprise = $00000000;
  fmMAPI = $00000001;
  fmThirdParty = $00000002;

// Constants for enum TJobCategoryType
type
  TJobCategoryType = TOleEnum;
const
  jcRevenue = $00000000;
  jcLabour = $00000001;
  jcDirectExpense1 = $00000002;
  jcDirectExpense2 = $00000003;
  jcStockIssues = $00000004;
  jcOverheads = $00000005;
  jcReceipts = $00000006;
  jcWorkInProgress = $00000007;
  jcRetentionsSL = $00000008;
  jcRetentionsPL = $00000009;

// Constants for enum TJobTypeIndex
type
  TJobTypeIndex = TOleEnum;
const
  jtIdxCode = $00000000;
  jtIdxName = $00000001;

// Constants for enum TAnalysisType
type
  TAnalysisType = TOleEnum;
const
  anTypeRevenue = $00000000;
  anTypeOverheads = $00000001;
  anTypeMaterials = $00000002;
  anTypeLabour = $00000003;

// Constants for enum TAnalysisCategory
type
  TAnalysisCategory = TOleEnum;
const
  anCatSales = $00000000;
  anCatTime = $00000001;
  anCatDisbursement = $00000002;
  anCatNRDisbursements = $00000003;
  anCatStockIssues = $00000004;
  anCatOverheads = $00000005;
  anCatReceipts = $00000006;
  anCatWorkInProgress = $00000007;
  anCatRetentionSL = $00000008;
  anCatRetentionPL = $00000009;

// Constants for enum TTransactionLineType
type
  TTransactionLineType = TOleEnum;
const
  tlTypeNormal = $00000000;
  tlTypeLabour = $00000001;
  tlTypeMaterials = $00000002;
  tlTypeFreight = $00000003;
  tlTypeDiscount = $00000004;

// Constants for enum TJobAnalysisIndex
type
  TJobAnalysisIndex = TOleEnum;
const
  anIdxCode = $00000000;
  anIdxDescription = $00000001;

// Constants for enum TEmployeeType
type
  TEmployeeType = TOleEnum;
const
  emTypeProduction = $00000000;
  emTypeSubContract = $00000001;
  emTypeOverhead = $00000002;

// Constants for enum TEmployeeIndex
type
  TEmployeeIndex = TOleEnum;
const
  emIdxCode = $00000000;
  emIdxSupplier = $00000001;

// Constants for enum TSerialBatchType
type
  TSerialBatchType = TOleEnum;
const
  snTypeSerial = $00000000;
  snTypeBatch = $00000001;
  snTypeBatchSale = $00000002;

// Constants for enum TSerialBatchIndex
type
  TSerialBatchIndex = TOleEnum;
const
  snIdxUsedSerialNo = $00000000;
  snIdxSerialNo = $00000001;
  snIdxBatchNo = $00000002;

// Constants for enum TSystemSetupGLCtrlType
type
  TSystemSetupGLCtrlType = TOleEnum;
const
  ssGLVatInput = $00000000;
  ssGLVatOutput = $00000001;
  ssGLDebtors = $00000002;
  ssGLCreditors = $00000003;
  ssGLSettleDiscountGiven = $00000004;
  ssGLSettleDiscountTaken = $00000005;
  ssGLLineDiscountGiven = $00000006;
  ssGLLineDiscountTaken = $00000007;
  ssGLProfitLossBF = $00000008;
  ssGLCurrencyVariance = $00000009;
  ssGLUnrealisedCurrencyDifference = $0000000A;
  ssGLProfitAndLossStart = $0000000B;
  ssGLProfitAndLossEnd = $0000000C;
  ssGLFreightUplift = $0000000D;
  ssGLSalesAccrual = $0000000E;
  ssGLPurchaseAccrual = $0000000F;

// Constants for enum TSystemSetupJobGLCtrlType
type
  TSystemSetupJobGLCtrlType = TOleEnum;
const
  ssjGLOverhead = $00000000;
  ssjGLProdution = $00000001;
  ssjGLSubContract = $00000002;

// Constants for enum TEmailAttachmentZIPType
type
  TEmailAttachmentZIPType = TOleEnum;
const
  emZIPNone = $00000000;
  emZIPPKZIP = $00000001;
  emZIPEDZ = $00000002;

// Constants for enum TEnterpriseModuleVersion
type
  TEnterpriseModuleVersion = TOleEnum;
const
  enModStandard = $00000000;
  enModStock = $00000001;
  enModSPOP = $00000002;

// Constants for enum TPasswordExpiryType
type
  TPasswordExpiryType = TOleEnum;
const
  pxNever = $00000000;
  pxPeriodic = $00000001;
  pxExpired = $00000002;

// Constants for enum TUserIndexType
type
  TUserIndexType = TOleEnum;
const
  usIdxLogin = $00000000;

// Constants for enum TPriorityRuleType
type
  TPriorityRuleType = TOleEnum;
const
  prStkAccOp = $00000000;
  prAccStkOp = $00000001;
  prOpAccStk = $00000002;
  prOpStkAcc = $00000003;

// Constants for enum TSecurityResultType
type
  TSecurityResultType = TOleEnum;
const
  srNoAccess = $00000000;
  srAccess = $00000001;

// Constants for enum TTransactionDetailIndex
type
  TTransactionDetailIndex = TOleEnum;
const
  tdIdxFolio = $00000000;
  tdIdxPostRunNo = $00000001;
  tdIdxNomCode = $00000002;
  tdIdxStockCode = $00000003;
  tdIdxLineClass = $00000004;
  tdIdxFolioAbsLineNo = $00000005;
  tdIdxLineClassCust = $00000006;
  tdIdxReconcile = $00000007;

// Constants for enum TReconcileStatusType
type
  TReconcileStatusType = TOleEnum;
const
  rsCleared = $00000001;
  rsCancelled = $00000002;
  rsReturned = $00000003;

// Constants for enum TNominalModeType
type
  TNominalModeType = TOleEnum;
const
  nmPayIn = $00000001;
  nmStockAdj = $00000002;
  nmTimeSheet = $00000003;

// Constants for enum TUserDefinedFieldNo
type
  TUserDefinedFieldNo = TOleEnum;
const
  uf1 = $00000001;
  uf2 = $00000002;
  uf3 = $00000003;
  uf4 = $00000004;

// Constants for enum TWOPStockNotesType
type
  TWOPStockNotesType = TOleEnum;
const
  wnBoth = $00000000;
  wnGeneral = $00000001;
  wnDated = $00000002;

// Constants for enum TFormDefinitionType
type
  TFormDefinitionType = TOleEnum;
const
  fdCustSuppAccDet = $00000000;
  fdCustSuppTradingHistory = $00000001;
  fdCustSuppLabels = $00000002;
  fdCustSuppSalesStatement = $00000003;
  fdSuppRemittanceAdvice = $00000004;
  fdDebtChase1 = $00000005;
  fdDebtChase2 = $00000006;
  fdDebtChase3 = $00000007;
  fdSIN = $00000008;
  fdSRI = $00000009;
  fdSCR = $0000000A;
  fdSRF = $0000000B;
  fdSQU = $0000000C;
  fdSOR = $0000000D;
  fdProForma = $0000000E;
  fdSDN = $0000000F;
  fdSRC = $00000010;
  fdSJI = $00000011;
  fdSJC = $00000012;
  fdConsPickingList = $00000013;
  fdIndPickingList = $00000014;
  fdSalesConsignmentNote = $00000015;
  fdSalesDeliveryLabel = $00000016;
  fdProductLabels = $00000017;
  fdSrcDetails = $00000018;
  fdPIN = $00000019;
  fdPPY = $0000001A;
  fdPCR = $0000001B;
  fdPQU = $0000001C;
  fdPOR = $0000001D;
  fdPDN = $0000001E;
  fdPJI = $0000001F;
  fdPJC = $00000020;
  fdPPI = $00000021;
  fdPRF = $00000022;
  fdPurchPayDebitNote = $00000023;
  fdStockWBOM = $00000024;
  fdStockWNotes = $00000025;
  fdADJ = $00000026;
  fdTSH = $00000027;
  fdJCBackingSheet = $00000028;
  fdJobRecord = $00000029;
  fdSelfBillSubContractorInv = $0000002A;
  fdConsWorksPickingList = $0000002B;
  fdWorksIssueNote = $0000002C;
  fdWOR = $0000002D;
  fdWorksPickingList = $0000002E;
  fdEmailCover = $0000002F;
  fdFaxCover = $00000030;
  fdNOM = $00000031;
  fdSalesPurchBatchEntry = $00000032;

// Constants for enum TPrintJobOutputMethods
type
  TPrintJobOutputMethods = TOleEnum;
const
  pjomPrinter = $00000000;
  pjomEmail = $00000001;
  pjomFax = $00000002;

// Constants for enum TLinkType
type
  TLinkType = TOleEnum;
const
  lkTypeLetter = $00000000;
  lkTypeLink = $00000001;

// Constants for enum TLinkObjectType
type
  TLinkObjectType = TOleEnum;
const
  lkoTypeDoc = $00000000;
  lkoTypeFax = $00000001;
  lkoTypeImage = $00000002;
  lkoTypePresentation = $00000003;
  lkoTypeProgram = $00000004;
  lkoTypeSound = $00000005;
  lkoTypeVideo = $00000006;
  lkoTypeOther = $00000007;
  lkoTypeSpreadSheet = $00000008;
  lkoTypeInternetDoc = $00000009;

// Constants for enum TAutoIncrementType
type
  TAutoIncrementType = TOleEnum;
const
  aiDays = $00000000;
  aiPeriods = $00000001;

// Constants for enum TPrintJobOutputToModes
type
  TPrintJobOutputToModes = TOleEnum;
const
  pjotDevice = $00000000;
  pjotPreview = $00000001;

// Constants for enum TB2BQtyModeType
type
  TB2BQtyModeType = TOleEnum;
const
  b2bOriginalOrder = $00000000;
  b2bLessDelivered = $00000001;
  b2bMaxStockLevel = $00000002;
  b2bLessPicked = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IToolkit = interface;
  IToolkitDisp = dispinterface;
  IAccount = interface;
  IAccountDisp = dispinterface;
  ITransaction = interface;
  ITransactionDisp = dispinterface;
  IAddress = interface;
  IAddressDisp = dispinterface;
  IAccountBalance = interface;
  IAccountBalanceDisp = dispinterface;
  IFunctions = interface;
  IFunctionsDisp = dispinterface;
  ITransactionLines = interface;
  ITransactionLinesDisp = dispinterface;
  ITransactionLine = interface;
  ITransactionLineDisp = dispinterface;
  ISystemSetup = interface;
  ISystemSetupDisp = dispinterface;
  ISystemSetupCurrency = interface;
  ISystemSetupCurrencyDisp = dispinterface;
  ISystemSetupReleaseCodes = interface;
  ISystemSetupReleaseCodesDisp = dispinterface;
  ISystemSetupUserFields = interface;
  ISystemSetupUserFieldsDisp = dispinterface;
  ISystemSetupVAT = interface;
  ISystemSetupVATDisp = dispinterface;
  IStock = interface;
  IStockDisp = dispinterface;
  IStockCover = interface;
  IStockCoverDisp = dispinterface;
  IStockIntrastat = interface;
  IStockIntrastatDisp = dispinterface;
  IStockReorder = interface;
  IStockReorderDisp = dispinterface;
  IStockSalesBand = interface;
  IStockSalesBandDisp = dispinterface;
  IConfiguration = interface;
  IConfigurationDisp = dispinterface;
  IEnterprise = interface;
  IEnterpriseDisp = dispinterface;
  IGeneralLedger = interface;
  IGeneralLedgerDisp = dispinterface;
  ILocation = interface;
  ILocationDisp = dispinterface;
  ICCDept = interface;
  ICCDeptDisp = dispinterface;
  ICompanyManager = interface;
  ICompanyManagerDisp = dispinterface;
  ICompanyDetail = interface;
  ICompanyDetailDisp = dispinterface;
  IStockLocation = interface;
  IStockLocationDisp = dispinterface;
  INotes = interface;
  INotesDisp = dispinterface;
  IJobCosting = interface;
  IJobCostingDisp = dispinterface;
  IJob = interface;
  IJobDisp = dispinterface;
  IMatching = interface;
  IMatchingDisp = dispinterface;
  IAccountDiscount = interface;
  IAccountDiscountDisp = dispinterface;
  IEBusiness = interface;
  IEBusinessDisp = dispinterface;
  IQuantityBreak = interface;
  IQuantityBreakDisp = dispinterface;
  ISystemSetupJob = interface;
  ISystemSetupJobDisp = dispinterface;
  ISystemSetupPaperless = interface;
  ISystemSetupPaperlessDisp = dispinterface;
  IJobType = interface;
  IJobTypeDisp = dispinterface;
  IJobAnalysis = interface;
  IJobAnalysisDisp = dispinterface;
  IStockBOMComponent = interface;
  IStockBOMComponentDisp = dispinterface;
  IStockBOMList = interface;
  IStockBOMListDisp = dispinterface;
  IStockWhereUsed = interface;
  IStockWhereUsedDisp = dispinterface;
  IEmployee = interface;
  IEmployeeDisp = dispinterface;
  ITimeRates = interface;
  ITimeRatesDisp = dispinterface;
  ISerialBatchDetails = interface;
  ISerialBatchDetailsDisp = dispinterface;
  ISerialBatch = interface;
  ISerialBatchDisp = dispinterface;
  ITransactionLineSerialBatch = interface;
  ITransactionLineSerialBatchDisp = dispinterface;
  IInternalDebug = interface;
  IInternalDebugDisp = dispinterface;
  IUserProfile = interface;
  IUserProfileDisp = dispinterface;
  IToolkit2 = interface;
  IToolkit2Disp = dispinterface;
  ITransactionDetails = interface;
  ITransactionDetailsDisp = dispinterface;
  ISystemSetupUserFields2 = interface;
  ISystemSetupUserFields2Disp = dispinterface;
  ISystemSetup2 = interface;
  ISystemSetup2Disp = dispinterface;
  ISystemSetupPaperless2 = interface;
  ISystemSetupPaperless2Disp = dispinterface;
  ISystemSetupFormDefinitionSet = interface;
  ISystemSetupFormDefinitionSetDisp = dispinterface;
  ITransaction2 = interface;
  ITransaction2Disp = dispinterface;
  IPrintJob = interface;
  IPrintJobDisp = dispinterface;
  IPrintJobPrinterInfo = interface;
  IPrintJobPrinterInfoDisp = dispinterface;
  IPrintJobEmailInfo = interface;
  IPrintJobEmailInfoDisp = dispinterface;
  IPrintJobFaxInfo = interface;
  IPrintJobFaxInfoDisp = dispinterface;
  ITransactionAsNOM = interface;
  ITransactionAsNOMDisp = dispinterface;
  ITransactionAsTSH = interface;
  ITransactionAsTSHDisp = dispinterface;
  ITransactionLineAsNOM = interface;
  ITransactionLineAsNOMDisp = dispinterface;
  ITransactionLine2 = interface;
  ITransactionLine2Disp = dispinterface;
  ITransactionLineAsTSH = interface;
  ITransactionLineAsTSHDisp = dispinterface;
  ITransactionAsADJ = interface;
  ITransactionAsADJDisp = dispinterface;
  ITransactionLineAsADJ = interface;
  ITransactionLineAsADJDisp = dispinterface;
  ITransactionAsWOR = interface;
  ITransactionAsWORDisp = dispinterface;
  ITransactionLineAsWOR = interface;
  ITransactionLineAsWORDisp = dispinterface;
  ILinks = interface;
  ILinksDisp = dispinterface;
  IJob2 = interface;
  IJob2Disp = dispinterface;
  IAutoTransactionSettings = interface;
  IAutoTransactionSettingsDisp = dispinterface;
  IPrinterDetail = interface;
  IPrinterDetailDisp = dispinterface;
  IStringListReadOnly = interface;
  IStringListReadOnlyDisp = dispinterface;
  IStringArrayRW = interface;
  IStringArrayRWDisp = dispinterface;
  IConvert = interface;
  IConvertDisp = dispinterface;
  ISingleConvert = interface;
  ISingleConvertDisp = dispinterface;
  IConvertList = interface;
  IConvertListDisp = dispinterface;
  ISystemProcesses = interface;
  ISystemProcessesDisp = dispinterface;
  IEmailAddress = interface;
  IEmailAddressDisp = dispinterface;
  IEmailAddressArray = interface;
  IEmailAddressArrayDisp = dispinterface;
  IBackToBackOrder = interface;
  IBackToBackOrderDisp = dispinterface;
  ITransactionAsBatch = interface;
  ITransactionAsBatchDisp = dispinterface;
  IPrinters = interface;
  IPrintersDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Toolkit = IToolkit;


// *********************************************************************//
// Interface: IToolkit
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F9C1BB21-3625-11D4-A992-0050DA3DF9AD}
// *********************************************************************//
  IToolkit = interface(IDispatch)
    ['{F9C1BB21-3625-11D4-A992-0050DA3DF9AD}']
    function CloseToolkit: Integer; safecall;
    function Get_Company: ICompanyManager; safecall;
    function Get_Configuration: IConfiguration; safecall;
    function Get_CostCentre: ICCDept; safecall;
    function Get_Customer: IAccount; safecall;
    function Get_Department: ICCDept; safecall;
    function Get_eBusiness: IEBusiness; safecall;
    function Get_Enterprise: IEnterprise; safecall;
    function Get_Functions: IFunctions; safecall;
    function Get_GeneralLedger: IGeneralLedger; safecall;
    function Get_JobCosting: IJobCosting; safecall;
    function Get_LastErrorString: WideString; safecall;
    function Get_Location: ILocation; safecall;
    function OpenToolkit: Integer; safecall;
    function Get_Status: TToolkitStatus; safecall;
    function Get_Stock: IStock; safecall;
    function Get_Supplier: IAccount; safecall;
    function Get_SystemSetup: ISystemSetup; safecall;
    function Get_Transaction: ITransaction; safecall;
    function Get_Version: WideString; safecall;
    property Company: ICompanyManager read Get_Company;
    property Configuration: IConfiguration read Get_Configuration;
    property CostCentre: ICCDept read Get_CostCentre;
    property Customer: IAccount read Get_Customer;
    property Department: ICCDept read Get_Department;
    property eBusiness: IEBusiness read Get_eBusiness;
    property Enterprise: IEnterprise read Get_Enterprise;
    property Functions: IFunctions read Get_Functions;
    property GeneralLedger: IGeneralLedger read Get_GeneralLedger;
    property JobCosting: IJobCosting read Get_JobCosting;
    property LastErrorString: WideString read Get_LastErrorString;
    property Location: ILocation read Get_Location;
    property Status: TToolkitStatus read Get_Status;
    property Stock: IStock read Get_Stock;
    property Supplier: IAccount read Get_Supplier;
    property SystemSetup: ISystemSetup read Get_SystemSetup;
    property Transaction: ITransaction read Get_Transaction;
    property Version: WideString read Get_Version;
  end;

// *********************************************************************//
// DispIntf:  IToolkitDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F9C1BB21-3625-11D4-A992-0050DA3DF9AD}
// *********************************************************************//
  IToolkitDisp = dispinterface
    ['{F9C1BB21-3625-11D4-A992-0050DA3DF9AD}']
    function CloseToolkit: Integer; dispid 1;
    property Company: ICompanyManager readonly dispid 2;
    property Configuration: IConfiguration readonly dispid 3;
    property CostCentre: ICCDept readonly dispid 4;
    property Customer: IAccount readonly dispid 5;
    property Department: ICCDept readonly dispid 6;
    property eBusiness: IEBusiness readonly dispid 7;
    property Enterprise: IEnterprise readonly dispid 8;
    property Functions: IFunctions readonly dispid 9;
    property GeneralLedger: IGeneralLedger readonly dispid 10;
    property JobCosting: IJobCosting readonly dispid 11;
    property LastErrorString: WideString readonly dispid 12;
    property Location: ILocation readonly dispid 13;
    function OpenToolkit: Integer; dispid 14;
    property Status: TToolkitStatus readonly dispid 15;
    property Stock: IStock readonly dispid 16;
    property Supplier: IAccount readonly dispid 17;
    property SystemSetup: ISystemSetup readonly dispid 18;
    property Transaction: ITransaction readonly dispid 19;
    property Version: WideString readonly dispid 20;
  end;

// *********************************************************************//
// Interface: IAccount
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF16609E-53F0-11D4-A997-0050DA3DF9AD}
// *********************************************************************//
  IAccount = interface(IDispatch)
    ['{FF16609E-53F0-11D4-A997-0050DA3DF9AD}']
    function Get_acCode: WideString; safecall;
    procedure Set_acCode(const Value: WideString); safecall;
    function Get_acCompany: WideString; safecall;
    procedure Set_acCompany(const Value: WideString); safecall;
    function Get_acArea: WideString; safecall;
    procedure Set_acArea(const Value: WideString); safecall;
    function Get_acAccType: WideString; safecall;
    procedure Set_acAccType(const Value: WideString); safecall;
    function Get_acStatementTo: WideString; safecall;
    procedure Set_acStatementTo(const Value: WideString); safecall;
    function Get_acVATRegNo: WideString; safecall;
    procedure Set_acVATRegNo(const Value: WideString); safecall;
    function Get_acAddress: IAddress; safecall;
    function Get_acDelAddress: IAddress; safecall;
    function Get_acContact: WideString; safecall;
    procedure Set_acContact(const Value: WideString); safecall;
    function Get_acPhone: WideString; safecall;
    procedure Set_acPhone(const Value: WideString); safecall;
    function Get_acFax: WideString; safecall;
    procedure Set_acFax(const Value: WideString); safecall;
    function Get_acTheirAcc: WideString; safecall;
    procedure Set_acTheirAcc(const Value: WideString); safecall;
    function Get_acOwnTradTerm: WordBool; safecall;
    procedure Set_acOwnTradTerm(Value: WordBool); safecall;
    function Get_acTradeTerms(Index: Integer): WideString; safecall;
    procedure Set_acTradeTerms(Index: Integer; const Value: WideString); safecall;
    function Get_acCurrency: Smallint; safecall;
    procedure Set_acCurrency(Value: Smallint); safecall;
    function Get_acVATCode: WideString; safecall;
    procedure Set_acVATCode(const Value: WideString); safecall;
    function Get_acPayTerms: Smallint; safecall;
    procedure Set_acPayTerms(Value: Smallint); safecall;
    function Get_acCreditLimit: Double; safecall;
    procedure Set_acCreditLimit(Value: Double); safecall;
    function Get_acDiscount: Double; safecall;
    procedure Set_acDiscount(Value: Double); safecall;
    function Get_acCreditStatus: Smallint; safecall;
    procedure Set_acCreditStatus(Value: Smallint); safecall;
    function Get_acCostCentre: WideString; safecall;
    procedure Set_acCostCentre(const Value: WideString); safecall;
    function Get_acDiscountBand: WideString; safecall;
    procedure Set_acDiscountBand(const Value: WideString); safecall;
    function Get_acDepartment: WideString; safecall;
    procedure Set_acDepartment(const Value: WideString); safecall;
    function Get_acECMember: WordBool; safecall;
    procedure Set_acECMember(Value: WordBool); safecall;
    function Get_acStatement: WordBool; safecall;
    procedure Set_acStatement(Value: WordBool); safecall;
    function Get_acSalesGL: Integer; safecall;
    procedure Set_acSalesGL(Value: Integer); safecall;
    function Get_acLocation: WideString; safecall;
    procedure Set_acLocation(const Value: WideString); safecall;
    function Get_acAccStatus: TAccountStatus; safecall;
    procedure Set_acAccStatus(Value: TAccountStatus); safecall;
    function Get_acPayType: WideString; safecall;
    procedure Set_acPayType(const Value: WideString); safecall;
    function Get_acBankSort: WideString; safecall;
    procedure Set_acBankSort(const Value: WideString); safecall;
    function Get_acBankAcc: WideString; safecall;
    procedure Set_acBankAcc(const Value: WideString); safecall;
    function Get_acBankRef: WideString; safecall;
    procedure Set_acBankRef(const Value: WideString); safecall;
    function Get_acLastUsed: WideString; safecall;
    function Get_acPhone2: WideString; safecall;
    procedure Set_acPhone2(const Value: WideString); safecall;
    function Get_acUserDef1: WideString; safecall;
    procedure Set_acUserDef1(const Value: WideString); safecall;
    function Get_acUserDef2: WideString; safecall;
    procedure Set_acUserDef2(const Value: WideString); safecall;
    function Get_acInvoiceTo: WideString; safecall;
    procedure Set_acInvoiceTo(const Value: WideString); safecall;
    function Get_acSOPAutoWOff: WordBool; safecall;
    procedure Set_acSOPAutoWOff(Value: WordBool); safecall;
    function Get_acBookOrdVal: Double; safecall;
    procedure Set_acBookOrdVal(Value: Double); safecall;
    function Get_acCOSGL: Integer; safecall;
    procedure Set_acCOSGL(Value: Integer); safecall;
    function Get_acDrCrGL: Integer; safecall;
    procedure Set_acDrCrGL(Value: Integer); safecall;
    function Get_acDirDebMode: Smallint; safecall;
    procedure Set_acDirDebMode(Value: Smallint); safecall;
    function Get_acCCStart: WideString; safecall;
    procedure Set_acCCStart(const Value: WideString); safecall;
    function Get_acCCEnd: WideString; safecall;
    procedure Set_acCCEnd(const Value: WideString); safecall;
    function Get_acCCName: WideString; safecall;
    procedure Set_acCCName(const Value: WideString); safecall;
    function Get_acCCNumber: WideString; safecall;
    procedure Set_acCCNumber(const Value: WideString); safecall;
    function Get_acCCSwitch: WideString; safecall;
    procedure Set_acCCSwitch(const Value: WideString); safecall;
    function Get_acDefSettleDays: Integer; safecall;
    procedure Set_acDefSettleDays(Value: Integer); safecall;
    function Get_acDefSettleDisc: Double; safecall;
    procedure Set_acDefSettleDisc(Value: Double); safecall;
    function Get_acFormSet: Smallint; safecall;
    procedure Set_acFormSet(Value: Smallint); safecall;
    function Get_acStateDeliveryMode: Integer; safecall;
    procedure Set_acStateDeliveryMode(Value: Integer); safecall;
    function Get_acEmailAddr: WideString; safecall;
    procedure Set_acEmailAddr(const Value: WideString); safecall;
    function Get_acSendReader: WordBool; safecall;
    procedure Set_acSendReader(Value: WordBool); safecall;
    function Get_acEBusPword: WideString; safecall;
    procedure Set_acEBusPword(const Value: WideString); safecall;
    function Get_acAltCode: WideString; safecall;
    procedure Set_acAltCode(const Value: WideString); safecall;
    function Get_acPostCode: WideString; safecall;
    procedure Set_acPostCode(const Value: WideString); safecall;
    function Get_acUseForEbus: Integer; safecall;
    procedure Set_acUseForEbus(Value: Integer); safecall;
    function Get_acZIPAttachments: TEmailAttachmentZIPType; safecall;
    procedure Set_acZIPAttachments(Value: TEmailAttachmentZIPType); safecall;
    function Get_acUserDef3: WideString; safecall;
    procedure Set_acUserDef3(const Value: WideString); safecall;
    function Get_acUserDef4: WideString; safecall;
    procedure Set_acUserDef4(const Value: WideString); safecall;
    function Get_acTimeStamp: WideString; safecall;
    function Get_acSSDDeliveryTerms: WideString; safecall;
    procedure Set_acSSDDeliveryTerms(const Value: WideString); safecall;
    function Get_acInclusiveVATCode: WideString; safecall;
    procedure Set_acInclusiveVATCode(const Value: WideString); safecall;
    function Get_acSSDModeOfTransport: Integer; safecall;
    procedure Set_acSSDModeOfTransport(Value: Integer); safecall;
    function Get_acLastOperator: WideString; safecall;
    procedure Set_acLastOperator(const Value: WideString); safecall;
    function Get_acDocDeliveryMode: Integer; safecall;
    procedure Set_acDocDeliveryMode(Value: Integer); safecall;
    function Get_acSendHTML: WordBool; safecall;
    procedure Set_acSendHTML(Value: WordBool); safecall;
    function Get_acWebLiveCatalog: WideString; safecall;
    procedure Set_acWebLiveCatalog(const Value: WideString); safecall;
    function Get_acWebPrevCatalog: WideString; safecall;
    procedure Set_acWebPrevCatalog(const Value: WideString); safecall;
    function Get_acHistory: IAccountBalance; safecall;
    function Save: Integer; safecall;
    function Add: IAccount; safecall;
    function Clone: IAccount; safecall;
    function Update: IAccount; safecall;
    procedure Cancel; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_Index: TAccountIndex; safecall;
    procedure Set_Index(Value: TAccountIndex); safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function BuildCodeIndex(const AccountCode: WideString): WideString; safecall;
    function BuildNameIndex(const AccountName: WideString): WideString; safecall;
    function BuildAltCodeIndex(const AlternateCode: WideString): WideString; safecall;
    function BuildVatRegIndex(const VatRegNo: WideString; const AccountCode: WideString): WideString; safecall;
    function BuildEmailIndex(const EmailAddr: WideString): WideString; safecall;
    function BuildPhoneIndex(const PhoneNo: WideString): WideString; safecall;
    function BuildPostCodeIndex(const PostCode: WideString): WideString; safecall;
    function BuildOurCodeIndex(const OurCode: WideString): WideString; safecall;
    function BuildInvoiceToIndex(const AccountCode: WideString): WideString; safecall;
    function Get_acNotes: INotes; safecall;
    function Get_acDiscounts: IAccountDiscount; safecall;
    property acCode: WideString read Get_acCode write Set_acCode;
    property acCompany: WideString read Get_acCompany write Set_acCompany;
    property acArea: WideString read Get_acArea write Set_acArea;
    property acAccType: WideString read Get_acAccType write Set_acAccType;
    property acStatementTo: WideString read Get_acStatementTo write Set_acStatementTo;
    property acVATRegNo: WideString read Get_acVATRegNo write Set_acVATRegNo;
    property acAddress: IAddress read Get_acAddress;
    property acDelAddress: IAddress read Get_acDelAddress;
    property acContact: WideString read Get_acContact write Set_acContact;
    property acPhone: WideString read Get_acPhone write Set_acPhone;
    property acFax: WideString read Get_acFax write Set_acFax;
    property acTheirAcc: WideString read Get_acTheirAcc write Set_acTheirAcc;
    property acOwnTradTerm: WordBool read Get_acOwnTradTerm write Set_acOwnTradTerm;
    property acTradeTerms[Index: Integer]: WideString read Get_acTradeTerms write Set_acTradeTerms;
    property acCurrency: Smallint read Get_acCurrency write Set_acCurrency;
    property acVATCode: WideString read Get_acVATCode write Set_acVATCode;
    property acPayTerms: Smallint read Get_acPayTerms write Set_acPayTerms;
    property acCreditLimit: Double read Get_acCreditLimit write Set_acCreditLimit;
    property acDiscount: Double read Get_acDiscount write Set_acDiscount;
    property acCreditStatus: Smallint read Get_acCreditStatus write Set_acCreditStatus;
    property acCostCentre: WideString read Get_acCostCentre write Set_acCostCentre;
    property acDiscountBand: WideString read Get_acDiscountBand write Set_acDiscountBand;
    property acDepartment: WideString read Get_acDepartment write Set_acDepartment;
    property acECMember: WordBool read Get_acECMember write Set_acECMember;
    property acStatement: WordBool read Get_acStatement write Set_acStatement;
    property acSalesGL: Integer read Get_acSalesGL write Set_acSalesGL;
    property acLocation: WideString read Get_acLocation write Set_acLocation;
    property acAccStatus: TAccountStatus read Get_acAccStatus write Set_acAccStatus;
    property acPayType: WideString read Get_acPayType write Set_acPayType;
    property acBankSort: WideString read Get_acBankSort write Set_acBankSort;
    property acBankAcc: WideString read Get_acBankAcc write Set_acBankAcc;
    property acBankRef: WideString read Get_acBankRef write Set_acBankRef;
    property acLastUsed: WideString read Get_acLastUsed;
    property acPhone2: WideString read Get_acPhone2 write Set_acPhone2;
    property acUserDef1: WideString read Get_acUserDef1 write Set_acUserDef1;
    property acUserDef2: WideString read Get_acUserDef2 write Set_acUserDef2;
    property acInvoiceTo: WideString read Get_acInvoiceTo write Set_acInvoiceTo;
    property acSOPAutoWOff: WordBool read Get_acSOPAutoWOff write Set_acSOPAutoWOff;
    property acBookOrdVal: Double read Get_acBookOrdVal write Set_acBookOrdVal;
    property acCOSGL: Integer read Get_acCOSGL write Set_acCOSGL;
    property acDrCrGL: Integer read Get_acDrCrGL write Set_acDrCrGL;
    property acDirDebMode: Smallint read Get_acDirDebMode write Set_acDirDebMode;
    property acCCStart: WideString read Get_acCCStart write Set_acCCStart;
    property acCCEnd: WideString read Get_acCCEnd write Set_acCCEnd;
    property acCCName: WideString read Get_acCCName write Set_acCCName;
    property acCCNumber: WideString read Get_acCCNumber write Set_acCCNumber;
    property acCCSwitch: WideString read Get_acCCSwitch write Set_acCCSwitch;
    property acDefSettleDays: Integer read Get_acDefSettleDays write Set_acDefSettleDays;
    property acDefSettleDisc: Double read Get_acDefSettleDisc write Set_acDefSettleDisc;
    property acFormSet: Smallint read Get_acFormSet write Set_acFormSet;
    property acStateDeliveryMode: Integer read Get_acStateDeliveryMode write Set_acStateDeliveryMode;
    property acEmailAddr: WideString read Get_acEmailAddr write Set_acEmailAddr;
    property acSendReader: WordBool read Get_acSendReader write Set_acSendReader;
    property acEBusPword: WideString read Get_acEBusPword write Set_acEBusPword;
    property acAltCode: WideString read Get_acAltCode write Set_acAltCode;
    property acPostCode: WideString read Get_acPostCode write Set_acPostCode;
    property acUseForEbus: Integer read Get_acUseForEbus write Set_acUseForEbus;
    property acZIPAttachments: TEmailAttachmentZIPType read Get_acZIPAttachments write Set_acZIPAttachments;
    property acUserDef3: WideString read Get_acUserDef3 write Set_acUserDef3;
    property acUserDef4: WideString read Get_acUserDef4 write Set_acUserDef4;
    property acTimeStamp: WideString read Get_acTimeStamp;
    property acSSDDeliveryTerms: WideString read Get_acSSDDeliveryTerms write Set_acSSDDeliveryTerms;
    property acInclusiveVATCode: WideString read Get_acInclusiveVATCode write Set_acInclusiveVATCode;
    property acSSDModeOfTransport: Integer read Get_acSSDModeOfTransport write Set_acSSDModeOfTransport;
    property acLastOperator: WideString read Get_acLastOperator write Set_acLastOperator;
    property acDocDeliveryMode: Integer read Get_acDocDeliveryMode write Set_acDocDeliveryMode;
    property acSendHTML: WordBool read Get_acSendHTML write Set_acSendHTML;
    property acWebLiveCatalog: WideString read Get_acWebLiveCatalog write Set_acWebLiveCatalog;
    property acWebPrevCatalog: WideString read Get_acWebPrevCatalog write Set_acWebPrevCatalog;
    property acHistory: IAccountBalance read Get_acHistory;
    property Index: TAccountIndex read Get_Index write Set_Index;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
    property acNotes: INotes read Get_acNotes;
    property acDiscounts: IAccountDiscount read Get_acDiscounts;
  end;

// *********************************************************************//
// DispIntf:  IAccountDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF16609E-53F0-11D4-A997-0050DA3DF9AD}
// *********************************************************************//
  IAccountDisp = dispinterface
    ['{FF16609E-53F0-11D4-A997-0050DA3DF9AD}']
    property acCode: WideString dispid 1;
    property acCompany: WideString dispid 2;
    property acArea: WideString dispid 3;
    property acAccType: WideString dispid 4;
    property acStatementTo: WideString dispid 5;
    property acVATRegNo: WideString dispid 6;
    property acAddress: IAddress readonly dispid 7;
    property acDelAddress: IAddress readonly dispid 8;
    property acContact: WideString dispid 9;
    property acPhone: WideString dispid 10;
    property acFax: WideString dispid 11;
    property acTheirAcc: WideString dispid 12;
    property acOwnTradTerm: WordBool dispid 13;
    property acTradeTerms[Index: Integer]: WideString dispid 14;
    property acCurrency: Smallint dispid 15;
    property acVATCode: WideString dispid 16;
    property acPayTerms: Smallint dispid 17;
    property acCreditLimit: Double dispid 18;
    property acDiscount: Double dispid 19;
    property acCreditStatus: Smallint dispid 20;
    property acCostCentre: WideString dispid 21;
    property acDiscountBand: WideString dispid 22;
    property acDepartment: WideString dispid 23;
    property acECMember: WordBool dispid 24;
    property acStatement: WordBool dispid 25;
    property acSalesGL: Integer dispid 26;
    property acLocation: WideString dispid 27;
    property acAccStatus: TAccountStatus dispid 28;
    property acPayType: WideString dispid 29;
    property acBankSort: WideString dispid 30;
    property acBankAcc: WideString dispid 31;
    property acBankRef: WideString dispid 32;
    property acLastUsed: WideString readonly dispid 33;
    property acPhone2: WideString dispid 34;
    property acUserDef1: WideString dispid 35;
    property acUserDef2: WideString dispid 36;
    property acInvoiceTo: WideString dispid 37;
    property acSOPAutoWOff: WordBool dispid 38;
    property acBookOrdVal: Double dispid 39;
    property acCOSGL: Integer dispid 40;
    property acDrCrGL: Integer dispid 41;
    property acDirDebMode: Smallint dispid 42;
    property acCCStart: WideString dispid 43;
    property acCCEnd: WideString dispid 44;
    property acCCName: WideString dispid 45;
    property acCCNumber: WideString dispid 46;
    property acCCSwitch: WideString dispid 47;
    property acDefSettleDays: Integer dispid 49;
    property acDefSettleDisc: Double dispid 50;
    property acFormSet: Smallint dispid 51;
    property acStateDeliveryMode: Integer dispid 52;
    property acEmailAddr: WideString dispid 53;
    property acSendReader: WordBool dispid 54;
    property acEBusPword: WideString dispid 55;
    property acAltCode: WideString dispid 56;
    property acPostCode: WideString dispid 57;
    property acUseForEbus: Integer dispid 58;
    property acZIPAttachments: TEmailAttachmentZIPType dispid 59;
    property acUserDef3: WideString dispid 60;
    property acUserDef4: WideString dispid 61;
    property acTimeStamp: WideString readonly dispid 62;
    property acSSDDeliveryTerms: WideString dispid 63;
    property acInclusiveVATCode: WideString dispid 64;
    property acSSDModeOfTransport: Integer dispid 65;
    property acLastOperator: WideString dispid 66;
    property acDocDeliveryMode: Integer dispid 67;
    property acSendHTML: WordBool dispid 68;
    property acWebLiveCatalog: WideString dispid 69;
    property acWebPrevCatalog: WideString dispid 70;
    property acHistory: IAccountBalance readonly dispid 71;
    function Save: Integer; dispid 72;
    function Add: IAccount; dispid 74;
    function Clone: IAccount; dispid 75;
    function Update: IAccount; dispid 76;
    procedure Cancel; dispid 77;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property Index: TAccountIndex dispid 16777221;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    function BuildCodeIndex(const AccountCode: WideString): WideString; dispid 78;
    function BuildNameIndex(const AccountName: WideString): WideString; dispid 79;
    function BuildAltCodeIndex(const AlternateCode: WideString): WideString; dispid 48;
    function BuildVatRegIndex(const VatRegNo: WideString; const AccountCode: WideString): WideString; dispid 73;
    function BuildEmailIndex(const EmailAddr: WideString): WideString; dispid 80;
    function BuildPhoneIndex(const PhoneNo: WideString): WideString; dispid 81;
    function BuildPostCodeIndex(const PostCode: WideString): WideString; dispid 82;
    function BuildOurCodeIndex(const OurCode: WideString): WideString; dispid 83;
    function BuildInvoiceToIndex(const AccountCode: WideString): WideString; dispid 84;
    property acNotes: INotes readonly dispid 85;
    property acDiscounts: IAccountDiscount readonly dispid 86;
  end;

// *********************************************************************//
// Interface: ITransaction
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B7D657CD-37AB-11D4-A992-0050DA3DF9AD}
// *********************************************************************//
  ITransaction = interface(IDispatch)
    ['{B7D657CD-37AB-11D4-A992-0050DA3DF9AD}']
    function Get_thOurRef: WideString; safecall;
    procedure Set_thOurRef(const Value: WideString); safecall;
    function Get_thYourRef: WideString; safecall;
    procedure Set_thYourRef(const Value: WideString); safecall;
    function Get_thAcCode: WideString; safecall;
    procedure Set_thAcCode(const Value: WideString); safecall;
    function Get_thRunNo: Integer; safecall;
    function Get_thFolioNum: Integer; safecall;
    procedure Set_thFolioNum(Value: Integer); safecall;
    function Get_thCurrency: Smallint; safecall;
    procedure Set_thCurrency(Value: Smallint); safecall;
    function Get_thYear: Smallint; safecall;
    procedure Set_thYear(Value: Smallint); safecall;
    function Get_thPeriod: Smallint; safecall;
    procedure Set_thPeriod(Value: Smallint); safecall;
    function Get_thTransDate: WideString; safecall;
    procedure Set_thTransDate(const Value: WideString); safecall;
    function Get_thDueDate: WideString; safecall;
    procedure Set_thDueDate(const Value: WideString); safecall;
    function Get_thCompanyRate: Double; safecall;
    procedure Set_thCompanyRate(Value: Double); safecall;
    function Get_thDailyRate: Double; safecall;
    procedure Set_thDailyRate(Value: Double); safecall;
    function Get_thDocType: TDocTypes; safecall;
    function Get_thVATAnalysis(const Index: WideString): Double; safecall;
    procedure Set_thVATAnalysis(const Index: WideString; Value: Double); safecall;
    function Get_thNetValue: Double; safecall;
    procedure Set_thNetValue(Value: Double); safecall;
    function Get_thTotalVAT: Double; safecall;
    procedure Set_thTotalVAT(Value: Double); safecall;
    function Get_thSettleDiscPerc: Double; safecall;
    procedure Set_thSettleDiscPerc(Value: Double); safecall;
    function Get_thSettleDiscAmount: Double; safecall;
    procedure Set_thSettleDiscAmount(Value: Double); safecall;
    function Get_thTotalLineDiscount: Double; safecall;
    procedure Set_thTotalLineDiscount(Value: Double); safecall;
    function Get_thSettleDiscDays: Smallint; safecall;
    procedure Set_thSettleDiscDays(Value: Smallint); safecall;
    function Get_thSettleDiscTaken: WordBool; safecall;
    procedure Set_thSettleDiscTaken(Value: WordBool); safecall;
    function Get_thAmountSettled: Double; safecall;
    function Get_thTransportNature: Smallint; safecall;
    procedure Set_thTransportNature(Value: Smallint); safecall;
    function Get_thTransportMode: Smallint; safecall;
    procedure Set_thTransportMode(Value: Smallint); safecall;
    function Get_thHoldFlag: Smallint; safecall;
    procedure Set_thHoldFlag(Value: Smallint); safecall;
    function Get_thTotalWeight: Double; safecall;
    procedure Set_thTotalWeight(Value: Double); safecall;
    function Get_thDelAddress: IAddress; safecall;
    function Get_thTotalCost: Double; safecall;
    procedure Set_thTotalCost(Value: Double); safecall;
    function Get_thPrinted: WordBool; safecall;
    function Get_thManualVAT: WordBool; safecall;
    procedure Set_thManualVAT(Value: WordBool); safecall;
    function Get_thDeliveryTerms: WideString; safecall;
    procedure Set_thDeliveryTerms(const Value: WideString); safecall;
    function Get_thOperator: WideString; safecall;
    procedure Set_thOperator(const Value: WideString); safecall;
    function Get_thJobCode: WideString; safecall;
    procedure Set_thJobCode(const Value: WideString); safecall;
    function Get_thAnalysisCode: WideString; safecall;
    procedure Set_thAnalysisCode(const Value: WideString); safecall;
    function Get_thTotalOrderOS: Double; safecall;
    procedure Set_thTotalOrderOS(Value: Double); safecall;
    function Get_thUserField1: WideString; safecall;
    procedure Set_thUserField1(const Value: WideString); safecall;
    function Get_thUserField2: WideString; safecall;
    procedure Set_thUserField2(const Value: WideString); safecall;
    function Get_thUserField3: WideString; safecall;
    procedure Set_thUserField3(const Value: WideString); safecall;
    function Get_thUserField4: WideString; safecall;
    procedure Set_thUserField4(const Value: WideString); safecall;
    function Get_thTagged: WordBool; safecall;
    procedure Set_thTagged(Value: WordBool); safecall;
    function Get_thNoLabels: Smallint; safecall;
    procedure Set_thNoLabels(Value: Smallint); safecall;
    function Get_thControlGL: Integer; safecall;
    procedure Set_thControlGL(Value: Integer); safecall;
    function Get_thProcess: TIntrastatProcess; safecall;
    procedure Set_thProcess(Value: TIntrastatProcess); safecall;
    function Get_thSource: Integer; safecall;
    function Get_thPostedDate: WideString; safecall;
    function Get_thPORPickSOR: WordBool; safecall;
    procedure Set_thPORPickSOR(Value: WordBool); safecall;
    function Get_thBatchDiscAmount: Double; safecall;
    procedure Set_thBatchDiscAmount(Value: Double); safecall;
    function Get_thPrePost: Integer; safecall;
    procedure Set_thPrePost(Value: Integer); safecall;
    function Get_thOutstanding: WideString; safecall;
    function Get_thFixedRate: WordBool; safecall;
    procedure Set_thFixedRate(Value: WordBool); safecall;
    function Get_thLongYourRef: WideString; safecall;
    procedure Set_thLongYourRef(const Value: WideString); safecall;
    function Get_thAcCodeI: IAccount; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_Index: TTransactionIndex; safecall;
    procedure Set_Index(Value: TTransactionIndex); safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function StepFirst: Integer; safecall;
    function StepPrevious: Integer; safecall;
    function StepNext: Integer; safecall;
    function StepLast: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function Get_thLines: ITransactionLines; safecall;
    function Get_thGoodsAnalysis(const Index: WideString): Double; safecall;
    function Get_thLineTypeAnalysis(Index: Integer): Double; safecall;
    function entCanUpdate: WordBool; safecall;
    function Add(TransactionType: TDocTypes): ITransaction; safecall;
    function Update: ITransaction; safecall;
    function Save(CalculateTotals: WordBool): Integer; safecall;
    procedure Cancel; safecall;
    function Clone: ITransaction; safecall;
    function Get_SaveErrorLine: Integer; safecall;
    function BuildOurRefIndex(const OurRef: WideString): WideString; safecall;
    function BuildFolioIndex(Folio: Integer): WideString; safecall;
    function BuildAccountIndex(const AccountCode: WideString): WideString; safecall;
    function Get_thEmployeeCode: WideString; safecall;
    procedure Set_thEmployeeCode(const Value: WideString); safecall;
    procedure ImportDefaults; safecall;
    procedure UpdateTotals; safecall;
    function BuildYourRefIndex(const YourRef: WideString): WideString; safecall;
    function BuildLongYourRefIndex(const LongYourRef: WideString): WideString; safecall;
    function BuildRunNoIndex(RunNo: Integer; const DocChar: WideString): WideString; safecall;
    function BuildAccountDueIndex(const AccountType: WideString; const AccountCode: WideString; 
                                  const DueDate: WideString): WideString; safecall;
    function BuildPostedDateIndex(const PostedDate: WideString; const OurRef: WideString): WideString; safecall;
    function BuildTransDateIndex(const TransDate: WideString): WideString; safecall;
    function BuildYearPeriodIndex(AccountingYear: Integer; AccountingPeriod: Integer): WideString; safecall;
    function BuildOutstandingIndex(const StatusChar: WideString): WideString; safecall;
    procedure AllocateTransNo; safecall;
    function Get_thNotes: INotes; safecall;
    function Get_thTotals(TotalType: TTransTotalsType): Double; safecall;
    function Get_thMatching: IMatching; safecall;
    function Get_thAnalysisCodeI: IJobAnalysis; safecall;
    function Get_thJobCodeI: IJob; safecall;
    property thOurRef: WideString read Get_thOurRef write Set_thOurRef;
    property thYourRef: WideString read Get_thYourRef write Set_thYourRef;
    property thAcCode: WideString read Get_thAcCode write Set_thAcCode;
    property thRunNo: Integer read Get_thRunNo;
    property thFolioNum: Integer read Get_thFolioNum write Set_thFolioNum;
    property thCurrency: Smallint read Get_thCurrency write Set_thCurrency;
    property thYear: Smallint read Get_thYear write Set_thYear;
    property thPeriod: Smallint read Get_thPeriod write Set_thPeriod;
    property thTransDate: WideString read Get_thTransDate write Set_thTransDate;
    property thDueDate: WideString read Get_thDueDate write Set_thDueDate;
    property thCompanyRate: Double read Get_thCompanyRate write Set_thCompanyRate;
    property thDailyRate: Double read Get_thDailyRate write Set_thDailyRate;
    property thDocType: TDocTypes read Get_thDocType;
    property thVATAnalysis[const Index: WideString]: Double read Get_thVATAnalysis write Set_thVATAnalysis;
    property thNetValue: Double read Get_thNetValue write Set_thNetValue;
    property thTotalVAT: Double read Get_thTotalVAT write Set_thTotalVAT;
    property thSettleDiscPerc: Double read Get_thSettleDiscPerc write Set_thSettleDiscPerc;
    property thSettleDiscAmount: Double read Get_thSettleDiscAmount write Set_thSettleDiscAmount;
    property thTotalLineDiscount: Double read Get_thTotalLineDiscount write Set_thTotalLineDiscount;
    property thSettleDiscDays: Smallint read Get_thSettleDiscDays write Set_thSettleDiscDays;
    property thSettleDiscTaken: WordBool read Get_thSettleDiscTaken write Set_thSettleDiscTaken;
    property thAmountSettled: Double read Get_thAmountSettled;
    property thTransportNature: Smallint read Get_thTransportNature write Set_thTransportNature;
    property thTransportMode: Smallint read Get_thTransportMode write Set_thTransportMode;
    property thHoldFlag: Smallint read Get_thHoldFlag write Set_thHoldFlag;
    property thTotalWeight: Double read Get_thTotalWeight write Set_thTotalWeight;
    property thDelAddress: IAddress read Get_thDelAddress;
    property thTotalCost: Double read Get_thTotalCost write Set_thTotalCost;
    property thPrinted: WordBool read Get_thPrinted;
    property thManualVAT: WordBool read Get_thManualVAT write Set_thManualVAT;
    property thDeliveryTerms: WideString read Get_thDeliveryTerms write Set_thDeliveryTerms;
    property thOperator: WideString read Get_thOperator write Set_thOperator;
    property thJobCode: WideString read Get_thJobCode write Set_thJobCode;
    property thAnalysisCode: WideString read Get_thAnalysisCode write Set_thAnalysisCode;
    property thTotalOrderOS: Double read Get_thTotalOrderOS write Set_thTotalOrderOS;
    property thUserField1: WideString read Get_thUserField1 write Set_thUserField1;
    property thUserField2: WideString read Get_thUserField2 write Set_thUserField2;
    property thUserField3: WideString read Get_thUserField3 write Set_thUserField3;
    property thUserField4: WideString read Get_thUserField4 write Set_thUserField4;
    property thTagged: WordBool read Get_thTagged write Set_thTagged;
    property thNoLabels: Smallint read Get_thNoLabels write Set_thNoLabels;
    property thControlGL: Integer read Get_thControlGL write Set_thControlGL;
    property thProcess: TIntrastatProcess read Get_thProcess write Set_thProcess;
    property thSource: Integer read Get_thSource;
    property thPostedDate: WideString read Get_thPostedDate;
    property thPORPickSOR: WordBool read Get_thPORPickSOR write Set_thPORPickSOR;
    property thBatchDiscAmount: Double read Get_thBatchDiscAmount write Set_thBatchDiscAmount;
    property thPrePost: Integer read Get_thPrePost write Set_thPrePost;
    property thOutstanding: WideString read Get_thOutstanding;
    property thFixedRate: WordBool read Get_thFixedRate write Set_thFixedRate;
    property thLongYourRef: WideString read Get_thLongYourRef write Set_thLongYourRef;
    property thAcCodeI: IAccount read Get_thAcCodeI;
    property Index: TTransactionIndex read Get_Index write Set_Index;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
    property thLines: ITransactionLines read Get_thLines;
    property thGoodsAnalysis[const Index: WideString]: Double read Get_thGoodsAnalysis;
    property thLineTypeAnalysis[Index: Integer]: Double read Get_thLineTypeAnalysis;
    property SaveErrorLine: Integer read Get_SaveErrorLine;
    property thEmployeeCode: WideString read Get_thEmployeeCode write Set_thEmployeeCode;
    property thNotes: INotes read Get_thNotes;
    property thTotals[TotalType: TTransTotalsType]: Double read Get_thTotals;
    property thMatching: IMatching read Get_thMatching;
    property thAnalysisCodeI: IJobAnalysis read Get_thAnalysisCodeI;
    property thJobCodeI: IJob read Get_thJobCodeI;
  end;

// *********************************************************************//
// DispIntf:  ITransactionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B7D657CD-37AB-11D4-A992-0050DA3DF9AD}
// *********************************************************************//
  ITransactionDisp = dispinterface
    ['{B7D657CD-37AB-11D4-A992-0050DA3DF9AD}']
    property thOurRef: WideString dispid 1;
    property thYourRef: WideString dispid 2;
    property thAcCode: WideString dispid 3;
    property thRunNo: Integer readonly dispid 4;
    property thFolioNum: Integer dispid 5;
    property thCurrency: Smallint dispid 6;
    property thYear: Smallint dispid 7;
    property thPeriod: Smallint dispid 8;
    property thTransDate: WideString dispid 9;
    property thDueDate: WideString dispid 10;
    property thCompanyRate: Double dispid 11;
    property thDailyRate: Double dispid 12;
    property thDocType: TDocTypes readonly dispid 13;
    property thVATAnalysis[const Index: WideString]: Double dispid 14;
    property thNetValue: Double dispid 15;
    property thTotalVAT: Double dispid 16;
    property thSettleDiscPerc: Double dispid 17;
    property thSettleDiscAmount: Double dispid 18;
    property thTotalLineDiscount: Double dispid 19;
    property thSettleDiscDays: Smallint dispid 20;
    property thSettleDiscTaken: WordBool dispid 21;
    property thAmountSettled: Double readonly dispid 22;
    property thTransportNature: Smallint dispid 23;
    property thTransportMode: Smallint dispid 24;
    property thHoldFlag: Smallint dispid 25;
    property thTotalWeight: Double dispid 26;
    property thDelAddress: IAddress readonly dispid 27;
    property thTotalCost: Double dispid 28;
    property thPrinted: WordBool readonly dispid 29;
    property thManualVAT: WordBool dispid 30;
    property thDeliveryTerms: WideString dispid 31;
    property thOperator: WideString dispid 32;
    property thJobCode: WideString dispid 33;
    property thAnalysisCode: WideString dispid 34;
    property thTotalOrderOS: Double dispid 35;
    property thUserField1: WideString dispid 36;
    property thUserField2: WideString dispid 37;
    property thUserField3: WideString dispid 38;
    property thUserField4: WideString dispid 39;
    property thTagged: WordBool dispid 40;
    property thNoLabels: Smallint dispid 41;
    property thControlGL: Integer dispid 42;
    property thProcess: TIntrastatProcess dispid 43;
    property thSource: Integer readonly dispid 44;
    property thPostedDate: WideString readonly dispid 45;
    property thPORPickSOR: WordBool dispid 46;
    property thBatchDiscAmount: Double dispid 47;
    property thPrePost: Integer dispid 48;
    property thOutstanding: WideString readonly dispid 49;
    property thFixedRate: WordBool dispid 50;
    property thLongYourRef: WideString dispid 51;
    property thAcCodeI: IAccount readonly dispid 52;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property Index: TTransactionIndex dispid 16777221;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function StepFirst: Integer; dispid 16777233;
    function StepPrevious: Integer; dispid 16777234;
    function StepNext: Integer; dispid 16777235;
    function StepLast: Integer; dispid 16777236;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    property thLines: ITransactionLines readonly dispid 53;
    property thGoodsAnalysis[const Index: WideString]: Double readonly dispid 55;
    property thLineTypeAnalysis[Index: Integer]: Double readonly dispid 56;
    function entCanUpdate: WordBool; dispid 57;
    function Add(TransactionType: TDocTypes): ITransaction; dispid 58;
    function Update: ITransaction; dispid 59;
    function Save(CalculateTotals: WordBool): Integer; dispid 60;
    procedure Cancel; dispid 61;
    function Clone: ITransaction; dispid 62;
    property SaveErrorLine: Integer readonly dispid 63;
    function BuildOurRefIndex(const OurRef: WideString): WideString; dispid 64;
    function BuildFolioIndex(Folio: Integer): WideString; dispid 65;
    function BuildAccountIndex(const AccountCode: WideString): WideString; dispid 66;
    property thEmployeeCode: WideString dispid 67;
    procedure ImportDefaults; dispid 68;
    procedure UpdateTotals; dispid 69;
    function BuildYourRefIndex(const YourRef: WideString): WideString; dispid 70;
    function BuildLongYourRefIndex(const LongYourRef: WideString): WideString; dispid 71;
    function BuildRunNoIndex(RunNo: Integer; const DocChar: WideString): WideString; dispid 72;
    function BuildAccountDueIndex(const AccountType: WideString; const AccountCode: WideString; 
                                  const DueDate: WideString): WideString; dispid 73;
    function BuildPostedDateIndex(const PostedDate: WideString; const OurRef: WideString): WideString; dispid 74;
    function BuildTransDateIndex(const TransDate: WideString): WideString; dispid 75;
    function BuildYearPeriodIndex(AccountingYear: Integer; AccountingPeriod: Integer): WideString; dispid 76;
    function BuildOutstandingIndex(const StatusChar: WideString): WideString; dispid 77;
    procedure AllocateTransNo; dispid 78;
    property thNotes: INotes readonly dispid 79;
    property thTotals[TotalType: TTransTotalsType]: Double readonly dispid 80;
    property thMatching: IMatching readonly dispid 54;
    property thAnalysisCodeI: IJobAnalysis readonly dispid 81;
    property thJobCodeI: IJob readonly dispid 82;
  end;

// *********************************************************************//
// Interface: IAddress
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DC6692C0-3DE2-11D4-A992-0050DA3DF9AD}
// *********************************************************************//
  IAddress = interface(IDispatch)
    ['{DC6692C0-3DE2-11D4-A992-0050DA3DF9AD}']
    function Get_Lines(Index: Integer): WideString; safecall;
    procedure Set_Lines(Index: Integer; const Value: WideString); safecall;
    function Get_Street1: WideString; safecall;
    procedure Set_Street1(const Value: WideString); safecall;
    function Get_Street2: WideString; safecall;
    procedure Set_Street2(const Value: WideString); safecall;
    function Get_Town: WideString; safecall;
    procedure Set_Town(const Value: WideString); safecall;
    function Get_County: WideString; safecall;
    procedure Set_County(const Value: WideString); safecall;
    function Get_PostCode: WideString; safecall;
    procedure Set_PostCode(const Value: WideString); safecall;
    procedure AssignAddress(const Address: IAddress); safecall;
    property Lines[Index: Integer]: WideString read Get_Lines write Set_Lines; default;
    property Street1: WideString read Get_Street1 write Set_Street1;
    property Street2: WideString read Get_Street2 write Set_Street2;
    property Town: WideString read Get_Town write Set_Town;
    property County: WideString read Get_County write Set_County;
    property PostCode: WideString read Get_PostCode write Set_PostCode;
  end;

// *********************************************************************//
// DispIntf:  IAddressDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DC6692C0-3DE2-11D4-A992-0050DA3DF9AD}
// *********************************************************************//
  IAddressDisp = dispinterface
    ['{DC6692C0-3DE2-11D4-A992-0050DA3DF9AD}']
    property Lines[Index: Integer]: WideString dispid 0; default;
    property Street1: WideString dispid 1;
    property Street2: WideString dispid 2;
    property Town: WideString dispid 3;
    property County: WideString dispid 4;
    property PostCode: WideString dispid 5;
    procedure AssignAddress(const Address: IAddress); dispid 6;
  end;

// *********************************************************************//
// Interface: IAccountBalance
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3D6C20E3-87D4-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IAccountBalance = interface(IDispatch)
    ['{3D6C20E3-87D4-11D4-A998-0050DA3DF9AD}']
    function Get_acCurrency: Integer; safecall;
    procedure Set_acCurrency(Value: Integer); safecall;
    function Get_acPeriod: Integer; safecall;
    procedure Set_acPeriod(Value: Integer); safecall;
    function Get_acYear: Integer; safecall;
    procedure Set_acYear(Value: Integer); safecall;
    function Get_acBalance: Double; safecall;
    function Get_acSales: Double; safecall;
    function Get_acCosts: Double; safecall;
    function Get_acMargin: Double; safecall;
    function Get_acDebits: Double; safecall;
    function Get_acCredits: Double; safecall;
    function Get_acBudget: Double; safecall;
    function Get_acCommitted: Double; safecall;
    property acCurrency: Integer read Get_acCurrency write Set_acCurrency;
    property acPeriod: Integer read Get_acPeriod write Set_acPeriod;
    property acYear: Integer read Get_acYear write Set_acYear;
    property acBalance: Double read Get_acBalance;
    property acSales: Double read Get_acSales;
    property acCosts: Double read Get_acCosts;
    property acMargin: Double read Get_acMargin;
    property acDebits: Double read Get_acDebits;
    property acCredits: Double read Get_acCredits;
    property acBudget: Double read Get_acBudget;
    property acCommitted: Double read Get_acCommitted;
  end;

// *********************************************************************//
// DispIntf:  IAccountBalanceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3D6C20E3-87D4-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IAccountBalanceDisp = dispinterface
    ['{3D6C20E3-87D4-11D4-A998-0050DA3DF9AD}']
    property acCurrency: Integer dispid 1;
    property acPeriod: Integer dispid 2;
    property acYear: Integer dispid 3;
    property acBalance: Double readonly dispid 4;
    property acSales: Double readonly dispid 5;
    property acCosts: Double readonly dispid 6;
    property acMargin: Double readonly dispid 7;
    property acDebits: Double readonly dispid 8;
    property acCredits: Double readonly dispid 9;
    property acBudget: Double readonly dispid 10;
    property acCommitted: Double readonly dispid 11;
  end;

// *********************************************************************//
// Interface: IFunctions
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8EAA86A8-8A3F-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IFunctions = interface(IDispatch)
    ['{8EAA86A8-8A3F-11D4-A998-0050DA3DF9AD}']
    function entFormatDate(const EntDateStr: WideString; const DateFormat: WideString): WideString; safecall;
    function entRound(Value: Double; Decs: Integer): Double; safecall;
    function entFormatPeriodYear(Period: Integer; Year: Integer): WideString; safecall;
    function entConvertAmount(Amount: Double; FromCurrency: Integer; ToCurrency: Integer; 
                              RateType: Integer): Double; safecall;
    function entConvertDateToPeriod(const DateString: WideString; var FinancialPeriod: Integer; 
                                    var FinancialYear: Integer): Integer; safecall;
    function entConvertAmountWithRates(Amount: Double; ConvertToBase: WordBool; 
                                       RateCurrency: Integer; CompanyRate: Double; DailyRate: Double): Double; safecall;
    procedure entBrowseObject(const ObjectToBrowse: IDispatch; ShowModal: WordBool); safecall;
    function entCheckPassword(const UserName: WideString; const UserPassword: WideString): Integer; safecall;
    function entCheckSecurity(const UserName: WideString; AreaCode: Integer): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IFunctionsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8EAA86A8-8A3F-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IFunctionsDisp = dispinterface
    ['{8EAA86A8-8A3F-11D4-A998-0050DA3DF9AD}']
    function entFormatDate(const EntDateStr: WideString; const DateFormat: WideString): WideString; dispid 1;
    function entRound(Value: Double; Decs: Integer): Double; dispid 2;
    function entFormatPeriodYear(Period: Integer; Year: Integer): WideString; dispid 3;
    function entConvertAmount(Amount: Double; FromCurrency: Integer; ToCurrency: Integer; 
                              RateType: Integer): Double; dispid 4;
    function entConvertDateToPeriod(const DateString: WideString; var FinancialPeriod: Integer; 
                                    var FinancialYear: Integer): Integer; dispid 5;
    function entConvertAmountWithRates(Amount: Double; ConvertToBase: WordBool; 
                                       RateCurrency: Integer; CompanyRate: Double; DailyRate: Double): Double; dispid 6;
    procedure entBrowseObject(const ObjectToBrowse: IDispatch; ShowModal: WordBool); dispid 7;
    function entCheckPassword(const UserName: WideString; const UserPassword: WideString): Integer; dispid 8;
    function entCheckSecurity(const UserName: WideString; AreaCode: Integer): Integer; dispid 9;
  end;

// *********************************************************************//
// Interface: ITransactionLines
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F01D062-8EE4-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ITransactionLines = interface(IDispatch)
    ['{7F01D062-8EE4-11D4-A998-0050DA3DF9AD}']
    function Get_thLine(Index: Integer): ITransactionLine; safecall;
    function Get_thLineCount: Integer; safecall;
    procedure Delete(Index: Integer); safecall;
    function Add: ITransactionLine; safecall;
    property thLine[Index: Integer]: ITransactionLine read Get_thLine; default;
    property thLineCount: Integer read Get_thLineCount;
  end;

// *********************************************************************//
// DispIntf:  ITransactionLinesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F01D062-8EE4-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ITransactionLinesDisp = dispinterface
    ['{7F01D062-8EE4-11D4-A998-0050DA3DF9AD}']
    property thLine[Index: Integer]: ITransactionLine readonly dispid 0; default;
    property thLineCount: Integer readonly dispid 1;
    procedure Delete(Index: Integer); dispid 2;
    function Add: ITransactionLine; dispid 4;
  end;

// *********************************************************************//
// Interface: ITransactionLine
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F01D064-8EE4-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ITransactionLine = interface(IDispatch)
    ['{7F01D064-8EE4-11D4-A998-0050DA3DF9AD}']
    function Get_tlLineNo: Integer; safecall;
    procedure Set_tlLineNo(Value: Integer); safecall;
    function Get_tlGLCode: Integer; safecall;
    procedure Set_tlGLCode(Value: Integer); safecall;
    function Get_tlCurrency: Integer; safecall;
    procedure Set_tlCurrency(Value: Integer); safecall;
    function Get_tlCompanyRate: Double; safecall;
    procedure Set_tlCompanyRate(Value: Double); safecall;
    function Get_tlDailyRate: Double; safecall;
    procedure Set_tlDailyRate(Value: Double); safecall;
    function Get_tlCostCentre: WideString; safecall;
    procedure Set_tlCostCentre(const Value: WideString); safecall;
    function Get_tlDepartment: WideString; safecall;
    procedure Set_tlDepartment(const Value: WideString); safecall;
    function Get_tlStockCode: WideString; safecall;
    procedure Set_tlStockCode(const Value: WideString); safecall;
    function Get_tlQty: Double; safecall;
    procedure Set_tlQty(Value: Double); safecall;
    function Get_tlQtyMul: Double; safecall;
    procedure Set_tlQtyMul(Value: Double); safecall;
    function Get_tlNetValue: Double; safecall;
    procedure Set_tlNetValue(Value: Double); safecall;
    function Get_tlDiscount: Double; safecall;
    procedure Set_tlDiscount(Value: Double); safecall;
    function Get_tlDiscFlag: WideString; safecall;
    procedure Set_tlDiscFlag(const Value: WideString); safecall;
    function Get_tlVATCode: WideString; safecall;
    procedure Set_tlVATCode(const Value: WideString); safecall;
    function Get_tlVATAmount: Double; safecall;
    procedure Set_tlVATAmount(Value: Double); safecall;
    function Get_tlPayment: WordBool; safecall;
    procedure Set_tlPayment(Value: WordBool); safecall;
    function Get_tlQtyWOFF: Double; safecall;
    procedure Set_tlQtyWOFF(Value: Double); safecall;
    function Get_tlQtyDel: Double; safecall;
    procedure Set_tlQtyDel(Value: Double); safecall;
    function Get_tlCost: Double; safecall;
    procedure Set_tlCost(Value: Double); safecall;
    function Get_tlLineDate: WideString; safecall;
    procedure Set_tlLineDate(const Value: WideString); safecall;
    function Get_tlItemNo: WideString; safecall;
    procedure Set_tlItemNo(const Value: WideString); safecall;
    function Get_tlDescr: WideString; safecall;
    procedure Set_tlDescr(const Value: WideString); safecall;
    function Get_tlJobCode: WideString; safecall;
    procedure Set_tlJobCode(const Value: WideString); safecall;
    function Get_tlAnalysisCode: WideString; safecall;
    procedure Set_tlAnalysisCode(const Value: WideString); safecall;
    function Get_tlUnitWeight: Double; safecall;
    procedure Set_tlUnitWeight(Value: Double); safecall;
    function Get_tlLocation: WideString; safecall;
    procedure Set_tlLocation(const Value: WideString); safecall;
    function Get_tlChargeCurrency: Integer; safecall;
    procedure Set_tlChargeCurrency(Value: Integer); safecall;
    function Get_tlAcCode: WideString; safecall;
    function Get_tlLineType: TTransactionLineType; safecall;
    procedure Set_tlLineType(Value: TTransactionLineType); safecall;
    function Get_tlFolioNum: Integer; safecall;
    function Get_tlLineClass: WideString; safecall;
    function Get_tlRecStatus: Smallint; safecall;
    procedure Set_tlRecStatus(Value: Smallint); safecall;
    function Get_tlSOPFolioNum: Integer; safecall;
    procedure Set_tlSOPFolioNum(Value: Integer); safecall;
    function Get_tlSOPABSLineNo: Integer; safecall;
    procedure Set_tlSOPABSLineNo(Value: Integer); safecall;
    function Get_tlABSLineNo: Integer; safecall;
    function Get_tlUserField1: WideString; safecall;
    procedure Set_tlUserField1(const Value: WideString); safecall;
    function Get_tlUserField2: WideString; safecall;
    procedure Set_tlUserField2(const Value: WideString); safecall;
    function Get_tlUserField3: WideString; safecall;
    procedure Set_tlUserField3(const Value: WideString); safecall;
    function Get_tlUserField4: WideString; safecall;
    procedure Set_tlUserField4(const Value: WideString); safecall;
    function Get_tlSSDUpliftPerc: Double; safecall;
    procedure Set_tlSSDUpliftPerc(Value: Double); safecall;
    function Get_tlSSDCommodCode: WideString; safecall;
    procedure Set_tlSSDCommodCode(const Value: WideString); safecall;
    function Get_tlSSDSalesUnit: Double; safecall;
    procedure Set_tlSSDSalesUnit(Value: Double); safecall;
    function Get_tlSSDUseLineValues: WordBool; safecall;
    procedure Set_tlSSDUseLineValues(Value: WordBool); safecall;
    function Get_tlPriceMultiplier: Double; safecall;
    procedure Set_tlPriceMultiplier(Value: Double); safecall;
    function Get_tlQtyPicked: Double; safecall;
    procedure Set_tlQtyPicked(Value: Double); safecall;
    function Get_tlQtyPickedWO: Double; safecall;
    procedure Set_tlQtyPickedWO(Value: Double); safecall;
    function Get_tlSSDCountry: WideString; safecall;
    procedure Set_tlSSDCountry(const Value: WideString); safecall;
    function Get_tlInclusiveVATCode: WideString; safecall;
    procedure Set_tlInclusiveVATCode(const Value: WideString); safecall;
    function Get_tlBOMKitLink: Integer; safecall;
    procedure Set_tlBOMKitLink(Value: Integer); safecall;
    function Get_tlOurRef: WideString; safecall;
    function entLineTotal(ApplyDiscounts: WordBool; SettleDiscPerc: Double): Double; safecall;
    procedure Save; safecall;
    procedure Cancel; safecall;
    function entDefaultVATCode(const AccountVATCode: WideString; const StockVATCode: WideString): WideString; safecall;
    procedure CalcVATAmount; safecall;
    procedure CalcStockPrice; safecall;
    function Get_tlStockCodeI: IStock; safecall;
    procedure ImportDefaults; safecall;
    function Get_tlAnalyisCodeI: IJobAnalysis; safecall;
    function Get_tlJobCodeI: IJob; safecall;
    function Get_tlSerialBatch: ITransactionLineSerialBatch; safecall;
    property tlLineNo: Integer read Get_tlLineNo write Set_tlLineNo;
    property tlGLCode: Integer read Get_tlGLCode write Set_tlGLCode;
    property tlCurrency: Integer read Get_tlCurrency write Set_tlCurrency;
    property tlCompanyRate: Double read Get_tlCompanyRate write Set_tlCompanyRate;
    property tlDailyRate: Double read Get_tlDailyRate write Set_tlDailyRate;
    property tlCostCentre: WideString read Get_tlCostCentre write Set_tlCostCentre;
    property tlDepartment: WideString read Get_tlDepartment write Set_tlDepartment;
    property tlStockCode: WideString read Get_tlStockCode write Set_tlStockCode;
    property tlQty: Double read Get_tlQty write Set_tlQty;
    property tlQtyMul: Double read Get_tlQtyMul write Set_tlQtyMul;
    property tlNetValue: Double read Get_tlNetValue write Set_tlNetValue;
    property tlDiscount: Double read Get_tlDiscount write Set_tlDiscount;
    property tlDiscFlag: WideString read Get_tlDiscFlag write Set_tlDiscFlag;
    property tlVATCode: WideString read Get_tlVATCode write Set_tlVATCode;
    property tlVATAmount: Double read Get_tlVATAmount write Set_tlVATAmount;
    property tlPayment: WordBool read Get_tlPayment write Set_tlPayment;
    property tlQtyWOFF: Double read Get_tlQtyWOFF write Set_tlQtyWOFF;
    property tlQtyDel: Double read Get_tlQtyDel write Set_tlQtyDel;
    property tlCost: Double read Get_tlCost write Set_tlCost;
    property tlLineDate: WideString read Get_tlLineDate write Set_tlLineDate;
    property tlItemNo: WideString read Get_tlItemNo write Set_tlItemNo;
    property tlDescr: WideString read Get_tlDescr write Set_tlDescr;
    property tlJobCode: WideString read Get_tlJobCode write Set_tlJobCode;
    property tlAnalysisCode: WideString read Get_tlAnalysisCode write Set_tlAnalysisCode;
    property tlUnitWeight: Double read Get_tlUnitWeight write Set_tlUnitWeight;
    property tlLocation: WideString read Get_tlLocation write Set_tlLocation;
    property tlChargeCurrency: Integer read Get_tlChargeCurrency write Set_tlChargeCurrency;
    property tlAcCode: WideString read Get_tlAcCode;
    property tlLineType: TTransactionLineType read Get_tlLineType write Set_tlLineType;
    property tlFolioNum: Integer read Get_tlFolioNum;
    property tlLineClass: WideString read Get_tlLineClass;
    property tlRecStatus: Smallint read Get_tlRecStatus write Set_tlRecStatus;
    property tlSOPFolioNum: Integer read Get_tlSOPFolioNum write Set_tlSOPFolioNum;
    property tlSOPABSLineNo: Integer read Get_tlSOPABSLineNo write Set_tlSOPABSLineNo;
    property tlABSLineNo: Integer read Get_tlABSLineNo;
    property tlUserField1: WideString read Get_tlUserField1 write Set_tlUserField1;
    property tlUserField2: WideString read Get_tlUserField2 write Set_tlUserField2;
    property tlUserField3: WideString read Get_tlUserField3 write Set_tlUserField3;
    property tlUserField4: WideString read Get_tlUserField4 write Set_tlUserField4;
    property tlSSDUpliftPerc: Double read Get_tlSSDUpliftPerc write Set_tlSSDUpliftPerc;
    property tlSSDCommodCode: WideString read Get_tlSSDCommodCode write Set_tlSSDCommodCode;
    property tlSSDSalesUnit: Double read Get_tlSSDSalesUnit write Set_tlSSDSalesUnit;
    property tlSSDUseLineValues: WordBool read Get_tlSSDUseLineValues write Set_tlSSDUseLineValues;
    property tlPriceMultiplier: Double read Get_tlPriceMultiplier write Set_tlPriceMultiplier;
    property tlQtyPicked: Double read Get_tlQtyPicked write Set_tlQtyPicked;
    property tlQtyPickedWO: Double read Get_tlQtyPickedWO write Set_tlQtyPickedWO;
    property tlSSDCountry: WideString read Get_tlSSDCountry write Set_tlSSDCountry;
    property tlInclusiveVATCode: WideString read Get_tlInclusiveVATCode write Set_tlInclusiveVATCode;
    property tlBOMKitLink: Integer read Get_tlBOMKitLink write Set_tlBOMKitLink;
    property tlOurRef: WideString read Get_tlOurRef;
    property tlStockCodeI: IStock read Get_tlStockCodeI;
    property tlAnalyisCodeI: IJobAnalysis read Get_tlAnalyisCodeI;
    property tlJobCodeI: IJob read Get_tlJobCodeI;
    property tlSerialBatch: ITransactionLineSerialBatch read Get_tlSerialBatch;
  end;

// *********************************************************************//
// DispIntf:  ITransactionLineDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F01D064-8EE4-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ITransactionLineDisp = dispinterface
    ['{7F01D064-8EE4-11D4-A998-0050DA3DF9AD}']
    property tlLineNo: Integer dispid 1;
    property tlGLCode: Integer dispid 2;
    property tlCurrency: Integer dispid 3;
    property tlCompanyRate: Double dispid 4;
    property tlDailyRate: Double dispid 51;
    property tlCostCentre: WideString dispid 6;
    property tlDepartment: WideString dispid 7;
    property tlStockCode: WideString dispid 8;
    property tlQty: Double dispid 9;
    property tlQtyMul: Double dispid 10;
    property tlNetValue: Double dispid 11;
    property tlDiscount: Double dispid 12;
    property tlDiscFlag: WideString dispid 13;
    property tlVATCode: WideString dispid 14;
    property tlVATAmount: Double dispid 15;
    property tlPayment: WordBool dispid 16;
    property tlQtyWOFF: Double dispid 17;
    property tlQtyDel: Double dispid 18;
    property tlCost: Double dispid 19;
    property tlLineDate: WideString dispid 20;
    property tlItemNo: WideString dispid 21;
    property tlDescr: WideString dispid 22;
    property tlJobCode: WideString dispid 23;
    property tlAnalysisCode: WideString dispid 24;
    property tlUnitWeight: Double dispid 25;
    property tlLocation: WideString dispid 26;
    property tlChargeCurrency: Integer dispid 27;
    property tlAcCode: WideString readonly dispid 28;
    property tlLineType: TTransactionLineType dispid 29;
    property tlFolioNum: Integer readonly dispid 30;
    property tlLineClass: WideString readonly dispid 31;
    property tlRecStatus: Smallint dispid 32;
    property tlSOPFolioNum: Integer dispid 33;
    property tlSOPABSLineNo: Integer dispid 34;
    property tlABSLineNo: Integer readonly dispid 35;
    property tlUserField1: WideString dispid 36;
    property tlUserField2: WideString dispid 37;
    property tlUserField3: WideString dispid 38;
    property tlUserField4: WideString dispid 39;
    property tlSSDUpliftPerc: Double dispid 40;
    property tlSSDCommodCode: WideString dispid 41;
    property tlSSDSalesUnit: Double dispid 42;
    property tlSSDUseLineValues: WordBool dispid 43;
    property tlPriceMultiplier: Double dispid 44;
    property tlQtyPicked: Double dispid 45;
    property tlQtyPickedWO: Double dispid 46;
    property tlSSDCountry: WideString dispid 47;
    property tlInclusiveVATCode: WideString dispid 48;
    property tlBOMKitLink: Integer dispid 49;
    property tlOurRef: WideString readonly dispid 5;
    function entLineTotal(ApplyDiscounts: WordBool; SettleDiscPerc: Double): Double; dispid 50;
    procedure Save; dispid 54;
    procedure Cancel; dispid 52;
    function entDefaultVATCode(const AccountVATCode: WideString; const StockVATCode: WideString): WideString; dispid 53;
    procedure CalcVATAmount; dispid 55;
    procedure CalcStockPrice; dispid 56;
    property tlStockCodeI: IStock readonly dispid 57;
    procedure ImportDefaults; dispid 68;
    property tlAnalyisCodeI: IJobAnalysis readonly dispid 58;
    property tlJobCodeI: IJob readonly dispid 59;
    property tlSerialBatch: ITransactionLineSerialBatch readonly dispid 60;
  end;

// *********************************************************************//
// Interface: ISystemSetup
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {824D7D3F-9065-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ISystemSetup = interface(IDispatch)
    ['{824D7D3F-9065-11D4-A998-0050DA3DF9AD}']
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
    function Get_ssPromptToPrintReciept: WordBool; safecall;
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
    function Get_ssCurrencyRateType: TCurrencyRateType; safecall;
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
    function Get_ssGLCtrlCodes(Index: TSystemSetupGLCtrlType): Integer; safecall;
    function Get_ssDebtChaseDays(Index: Integer): Smallint; safecall;
    function Get_ssTermsofTrade(Index: Integer): WideString; safecall;
    function Get_ssVATRates(const Index: WideString): ISystemSetupVAT; safecall;
    function Get_ssCurrency(Index: Integer): ISystemSetupCurrency; safecall;
    function Get_ssUserFields: ISystemSetupUserFields; safecall;
    function Get_ssPickingOrderAllocatesStock: WordBool; safecall;
    function Get_ssReleaseCodes: ISystemSetupReleaseCodes; safecall;
    function Get_ssDocumentNumbers(const DocType: WideString): Integer; safecall;
    function Get_ssCurrencyVersion: TEnterpriseCurrencyVersion; safecall;
    function Get_ssMaxCurrency: Integer; safecall;
    procedure Refresh; safecall;
    function Get_ssUseDosKeys: WordBool; safecall;
    function Get_ssHideEnterpriseLogo: WordBool; safecall;
    function Get_ssConserveMemory: WordBool; safecall;
    function Get_ssProtectYourRef: WordBool; safecall;
    function Get_ssSDNDateIsTaxPointDate: WordBool; safecall;
    function Get_ssAutoPostUplift: WordBool; safecall;
    function Get_ssJobCosting: ISystemSetupJob; safecall;
    function Get_ssPaperless: ISystemSetupPaperless; safecall;
    function Get_ssTaxWord: WideString; safecall;
    property ssPeriodsInYear: Smallint read Get_ssPeriodsInYear;
    property ssCompanyName: WideString read Get_ssCompanyName;
    property ssLastAuditYr: Smallint read Get_ssLastAuditYr;
    property ssManUpdReorderCost: WordBool read Get_ssManUpdReorderCost;
    property ssVATReturnCurrency: Smallint read Get_ssVATReturnCurrency;
    property ssCostDecimals: Smallint read Get_ssCostDecimals;
    property ssShowStkPriceAsMargin: WordBool read Get_ssShowStkPriceAsMargin;
    property ssLiveStockCOSVal: WordBool read Get_ssLiveStockCOSVal;
    property ssSDNShowPickedOnly: WordBool read Get_ssSDNShowPickedOnly;
    property ssUseLocations: WordBool read Get_ssUseLocations;
    property ssSetBOMSerNo: WordBool read Get_ssSetBOMSerNo;
    property ssWarnDupliYourRef: WordBool read Get_ssWarnDupliYourRef;
    property ssUseLocDelAddress: WordBool read Get_ssUseLocDelAddress;
    property ssBudgetByCCDept: WordBool read Get_ssBudgetByCCDept;
    property ssCurrencyTolerance: Double read Get_ssCurrencyTolerance;
    property ssCurrencyToleranceMode: Smallint read Get_ssCurrencyToleranceMode;
    property ssDebtChaseMode: Smallint read Get_ssDebtChaseMode;
    property ssAutoGenVariance: WordBool read Get_ssAutoGenVariance;
    property ssAutoGenDisc: WordBool read Get_ssAutoGenDisc;
    property ssCompanyCountryCode: WideString read Get_ssCompanyCountryCode;
    property ssSalesDecimals: Smallint read Get_ssSalesDecimals;
    property ssDebtChaseOverdue: Smallint read Get_ssDebtChaseOverdue;
    property ssCurrentPeriod: Smallint read Get_ssCurrentPeriod;
    property ssCurrentYear: Smallint read Get_ssCurrentYear;
    property ssTradeTerm: WordBool read Get_ssTradeTerm;
    property ssSeparateCurrencyStatements: WordBool read Get_ssSeparateCurrencyStatements;
    property ssStatementAgingMethod: Smallint read Get_ssStatementAgingMethod;
    property ssStatementUseInvoiceDate: WordBool read Get_ssStatementUseInvoiceDate;
    property ssQuotesAllocateStock: WordBool read Get_ssQuotesAllocateStock;
    property ssDeductBOMComponents: WordBool read Get_ssDeductBOMComponents;
    property ssAuthorisationMethod: WideString read Get_ssAuthorisationMethod;
    property ssUseIntrastat: WordBool read Get_ssUseIntrastat;
    property ssAnalyseDescOnly: WordBool read Get_ssAnalyseDescOnly;
    property ssDefaultStockValMethod: WideString read Get_ssDefaultStockValMethod;
    property ssDisplayUpdateCosts: WordBool read Get_ssDisplayUpdateCosts;
    property ssAutoChequeNo: WordBool read Get_ssAutoChequeNo;
    property ssStatementIncNotDue: WordBool read Get_ssStatementIncNotDue;
    property ssForceBatchTotalBalancing: WordBool read Get_ssForceBatchTotalBalancing;
    property ssDisplayStockLevelWarning: WordBool read Get_ssDisplayStockLevelWarning;
    property ssStatementNoteEntry: WordBool read Get_ssStatementNoteEntry;
    property ssHideMenuOpt: WordBool read Get_ssHideMenuOpt;
    property ssUseCCDept: WordBool read Get_ssUseCCDept;
    property ssHoldSettlementDiscTransactions: WordBool read Get_ssHoldSettlementDiscTransactions;
    property ssSetTransPeriodByDate: WordBool read Get_ssSetTransPeriodByDate;
    property ssStopOverCreditLimit: WordBool read Get_ssStopOverCreditLimit;
    property ssUseSRCPayInRef: WordBool read Get_ssUseSRCPayInRef;
    property ssUsePasswords: WordBool read Get_ssUsePasswords;
    property ssPromptToPrintReciept: WordBool read Get_ssPromptToPrintReciept;
    property ssExternalCustomers: WordBool read Get_ssExternalCustomers;
    property ssQtyDecimals: Smallint read Get_ssQtyDecimals;
    property ssExternalSINEntry: WordBool read Get_ssExternalSINEntry;
    property ssDisablePostingToPreviousPeriods: WordBool read Get_ssDisablePostingToPreviousPeriods;
    property ssPercDiscounts: WordBool read Get_ssPercDiscounts;
    property ssNumericAccountCodes: WordBool read Get_ssNumericAccountCodes;
    property ssUpdateBalanceOnPosting: WordBool read Get_ssUpdateBalanceOnPosting;
    property ssShowInvoiceDisc: WordBool read Get_ssShowInvoiceDisc;
    property ssSplitDiscountsInGL: WordBool read Get_ssSplitDiscountsInGL;
    property ssDoCreditStatusCheck: WordBool read Get_ssDoCreditStatusCheck;
    property ssDoCreditLimitCheck: WordBool read Get_ssDoCreditLimitCheck;
    property ssAutoClearPayments: WordBool read Get_ssAutoClearPayments;
    property ssCurrencyRateType: TCurrencyRateType read Get_ssCurrencyRateType;
    property ssShowPeriodsAsMonths: WordBool read Get_ssShowPeriodsAsMonths;
    property ssDirectCustomer: WideString read Get_ssDirectCustomer;
    property ssDirectSupplier: WideString read Get_ssDirectSupplier;
    property ssSettlementDiscount: Double read Get_ssSettlementDiscount;
    property ssSettlementDays: Smallint read Get_ssSettlementDays;
    property ssNeedBOMCostingUpdate: WordBool read Get_ssNeedBOMCostingUpdate;
    property ssInputPackQtyOnLine: WordBool read Get_ssInputPackQtyOnLine;
    property ssDefaultVATCode: WideString read Get_ssDefaultVATCode;
    property ssPaymentTerms: Smallint read Get_ssPaymentTerms;
    property ssStatementAgeingInterval: Smallint read Get_ssStatementAgeingInterval;
    property ssKeepQuoteDate: WordBool read Get_ssKeepQuoteDate;
    property ssFreeStockExcludesSOR: WordBool read Get_ssFreeStockExcludesSOR;
    property ssSeparateDirectTransCounter: WordBool read Get_ssSeparateDirectTransCounter;
    property ssStatementShowMatchedInMonth: WordBool read Get_ssStatementShowMatchedInMonth;
    property ssLiveOldestDebt: WordBool read Get_ssLiveOldestDebt;
    property ssBatchPPY: WordBool read Get_ssBatchPPY;
    property ssDefaultBankGL: Integer read Get_ssDefaultBankGL;
    property ssUseDefaultBankAccount: WordBool read Get_ssUseDefaultBankAccount;
    property ssYearStartDate: WideString read Get_ssYearStartDate;
    property ssLastAuditDate: WideString read Get_ssLastAuditDate;
    property ssBankSortCode: WideString read Get_ssBankSortCode;
    property ssBankAccountNo: WideString read Get_ssBankAccountNo;
    property ssBankAccountRef: WideString read Get_ssBankAccountRef;
    property ssBankName: WideString read Get_ssBankName;
    property ssCompanyPhone: WideString read Get_ssCompanyPhone;
    property ssCompanyFax: WideString read Get_ssCompanyFax;
    property ssCompanyVATRegNo: WideString read Get_ssCompanyVATRegNo;
    property ssCompanyAddress[Index: Integer]: WideString read Get_ssCompanyAddress;
    property ssGLCtrlCodes[Index: TSystemSetupGLCtrlType]: Integer read Get_ssGLCtrlCodes;
    property ssDebtChaseDays[Index: Integer]: Smallint read Get_ssDebtChaseDays;
    property ssTermsofTrade[Index: Integer]: WideString read Get_ssTermsofTrade;
    property ssVATRates[const Index: WideString]: ISystemSetupVAT read Get_ssVATRates;
    property ssCurrency[Index: Integer]: ISystemSetupCurrency read Get_ssCurrency;
    property ssUserFields: ISystemSetupUserFields read Get_ssUserFields;
    property ssPickingOrderAllocatesStock: WordBool read Get_ssPickingOrderAllocatesStock;
    property ssReleaseCodes: ISystemSetupReleaseCodes read Get_ssReleaseCodes;
    property ssDocumentNumbers[const DocType: WideString]: Integer read Get_ssDocumentNumbers;
    property ssCurrencyVersion: TEnterpriseCurrencyVersion read Get_ssCurrencyVersion;
    property ssMaxCurrency: Integer read Get_ssMaxCurrency;
    property ssUseDosKeys: WordBool read Get_ssUseDosKeys;
    property ssHideEnterpriseLogo: WordBool read Get_ssHideEnterpriseLogo;
    property ssConserveMemory: WordBool read Get_ssConserveMemory;
    property ssProtectYourRef: WordBool read Get_ssProtectYourRef;
    property ssSDNDateIsTaxPointDate: WordBool read Get_ssSDNDateIsTaxPointDate;
    property ssAutoPostUplift: WordBool read Get_ssAutoPostUplift;
    property ssJobCosting: ISystemSetupJob read Get_ssJobCosting;
    property ssPaperless: ISystemSetupPaperless read Get_ssPaperless;
    property ssTaxWord: WideString read Get_ssTaxWord;
  end;

// *********************************************************************//
// DispIntf:  ISystemSetupDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {824D7D3F-9065-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ISystemSetupDisp = dispinterface
    ['{824D7D3F-9065-11D4-A998-0050DA3DF9AD}']
    property ssPeriodsInYear: Smallint readonly dispid 1;
    property ssCompanyName: WideString readonly dispid 2;
    property ssLastAuditYr: Smallint readonly dispid 3;
    property ssManUpdReorderCost: WordBool readonly dispid 4;
    property ssVATReturnCurrency: Smallint readonly dispid 5;
    property ssCostDecimals: Smallint readonly dispid 6;
    property ssShowStkPriceAsMargin: WordBool readonly dispid 8;
    property ssLiveStockCOSVal: WordBool readonly dispid 9;
    property ssSDNShowPickedOnly: WordBool readonly dispid 10;
    property ssUseLocations: WordBool readonly dispid 11;
    property ssSetBOMSerNo: WordBool readonly dispid 12;
    property ssWarnDupliYourRef: WordBool readonly dispid 13;
    property ssUseLocDelAddress: WordBool readonly dispid 14;
    property ssBudgetByCCDept: WordBool readonly dispid 15;
    property ssCurrencyTolerance: Double readonly dispid 16;
    property ssCurrencyToleranceMode: Smallint readonly dispid 17;
    property ssDebtChaseMode: Smallint readonly dispid 18;
    property ssAutoGenVariance: WordBool readonly dispid 19;
    property ssAutoGenDisc: WordBool readonly dispid 20;
    property ssCompanyCountryCode: WideString readonly dispid 21;
    property ssSalesDecimals: Smallint readonly dispid 22;
    property ssDebtChaseOverdue: Smallint readonly dispid 24;
    property ssCurrentPeriod: Smallint readonly dispid 25;
    property ssCurrentYear: Smallint readonly dispid 26;
    property ssTradeTerm: WordBool readonly dispid 27;
    property ssSeparateCurrencyStatements: WordBool readonly dispid 28;
    property ssStatementAgingMethod: Smallint readonly dispid 29;
    property ssStatementUseInvoiceDate: WordBool readonly dispid 30;
    property ssQuotesAllocateStock: WordBool readonly dispid 31;
    property ssDeductBOMComponents: WordBool readonly dispid 32;
    property ssAuthorisationMethod: WideString readonly dispid 33;
    property ssUseIntrastat: WordBool readonly dispid 34;
    property ssAnalyseDescOnly: WordBool readonly dispid 35;
    property ssDefaultStockValMethod: WideString readonly dispid 36;
    property ssDisplayUpdateCosts: WordBool readonly dispid 37;
    property ssAutoChequeNo: WordBool readonly dispid 38;
    property ssStatementIncNotDue: WordBool readonly dispid 39;
    property ssForceBatchTotalBalancing: WordBool readonly dispid 40;
    property ssDisplayStockLevelWarning: WordBool readonly dispid 41;
    property ssStatementNoteEntry: WordBool readonly dispid 42;
    property ssHideMenuOpt: WordBool readonly dispid 43;
    property ssUseCCDept: WordBool readonly dispid 44;
    property ssHoldSettlementDiscTransactions: WordBool readonly dispid 45;
    property ssSetTransPeriodByDate: WordBool readonly dispid 46;
    property ssStopOverCreditLimit: WordBool readonly dispid 47;
    property ssUseSRCPayInRef: WordBool readonly dispid 48;
    property ssUsePasswords: WordBool readonly dispid 49;
    property ssPromptToPrintReciept: WordBool readonly dispid 50;
    property ssExternalCustomers: WordBool readonly dispid 51;
    property ssQtyDecimals: Smallint readonly dispid 52;
    property ssExternalSINEntry: WordBool readonly dispid 53;
    property ssDisablePostingToPreviousPeriods: WordBool readonly dispid 54;
    property ssPercDiscounts: WordBool readonly dispid 55;
    property ssNumericAccountCodes: WordBool readonly dispid 56;
    property ssUpdateBalanceOnPosting: WordBool readonly dispid 57;
    property ssShowInvoiceDisc: WordBool readonly dispid 58;
    property ssSplitDiscountsInGL: WordBool readonly dispid 59;
    property ssDoCreditStatusCheck: WordBool readonly dispid 60;
    property ssDoCreditLimitCheck: WordBool readonly dispid 61;
    property ssAutoClearPayments: WordBool readonly dispid 62;
    property ssCurrencyRateType: TCurrencyRateType readonly dispid 63;
    property ssShowPeriodsAsMonths: WordBool readonly dispid 64;
    property ssDirectCustomer: WideString readonly dispid 65;
    property ssDirectSupplier: WideString readonly dispid 66;
    property ssSettlementDiscount: Double readonly dispid 69;
    property ssSettlementDays: Smallint readonly dispid 70;
    property ssNeedBOMCostingUpdate: WordBool readonly dispid 71;
    property ssInputPackQtyOnLine: WordBool readonly dispid 72;
    property ssDefaultVATCode: WideString readonly dispid 73;
    property ssPaymentTerms: Smallint readonly dispid 74;
    property ssStatementAgeingInterval: Smallint readonly dispid 75;
    property ssKeepQuoteDate: WordBool readonly dispid 76;
    property ssFreeStockExcludesSOR: WordBool readonly dispid 77;
    property ssSeparateDirectTransCounter: WordBool readonly dispid 78;
    property ssStatementShowMatchedInMonth: WordBool readonly dispid 79;
    property ssLiveOldestDebt: WordBool readonly dispid 80;
    property ssBatchPPY: WordBool readonly dispid 81;
    property ssDefaultBankGL: Integer readonly dispid 83;
    property ssUseDefaultBankAccount: WordBool readonly dispid 84;
    property ssYearStartDate: WideString readonly dispid 85;
    property ssLastAuditDate: WideString readonly dispid 86;
    property ssBankSortCode: WideString readonly dispid 87;
    property ssBankAccountNo: WideString readonly dispid 88;
    property ssBankAccountRef: WideString readonly dispid 89;
    property ssBankName: WideString readonly dispid 90;
    property ssCompanyPhone: WideString readonly dispid 92;
    property ssCompanyFax: WideString readonly dispid 93;
    property ssCompanyVATRegNo: WideString readonly dispid 94;
    property ssCompanyAddress[Index: Integer]: WideString readonly dispid 96;
    property ssGLCtrlCodes[Index: TSystemSetupGLCtrlType]: Integer readonly dispid 97;
    property ssDebtChaseDays[Index: Integer]: Smallint readonly dispid 98;
    property ssTermsofTrade[Index: Integer]: WideString readonly dispid 99;
    property ssVATRates[const Index: WideString]: ISystemSetupVAT readonly dispid 95;
    property ssCurrency[Index: Integer]: ISystemSetupCurrency readonly dispid 100;
    property ssUserFields: ISystemSetupUserFields readonly dispid 101;
    property ssPickingOrderAllocatesStock: WordBool readonly dispid 102;
    property ssReleaseCodes: ISystemSetupReleaseCodes readonly dispid 103;
    property ssDocumentNumbers[const DocType: WideString]: Integer readonly dispid 104;
    property ssCurrencyVersion: TEnterpriseCurrencyVersion readonly dispid 7;
    property ssMaxCurrency: Integer readonly dispid 23;
    procedure Refresh; dispid 67;
    property ssUseDosKeys: WordBool readonly dispid 91;
    property ssHideEnterpriseLogo: WordBool readonly dispid 105;
    property ssConserveMemory: WordBool readonly dispid 106;
    property ssProtectYourRef: WordBool readonly dispid 107;
    property ssSDNDateIsTaxPointDate: WordBool readonly dispid 108;
    property ssAutoPostUplift: WordBool readonly dispid 112;
    property ssJobCosting: ISystemSetupJob readonly dispid 113;
    property ssPaperless: ISystemSetupPaperless readonly dispid 68;
    property ssTaxWord: WideString readonly dispid 82;
  end;

// *********************************************************************//
// Interface: ISystemSetupCurrency
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {729B93A2-92C8-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ISystemSetupCurrency = interface(IDispatch)
    ['{729B93A2-92C8-11D4-A998-0050DA3DF9AD}']
    function Get_scSymbol: WideString; safecall;
    function Get_scDesc: WideString; safecall;
    function Get_scCompanyRate: Double; safecall;
    function Get_scDailyRate: Double; safecall;
    function Get_scPrintSymb: WideString; safecall;
    function Get_scTriRate: Double; safecall;
    function Get_scTriEuroCcy: Smallint; safecall;
    function Get_scTriInvert: WordBool; safecall;
    function Get_scTriFloating: WordBool; safecall;
    property scSymbol: WideString read Get_scSymbol;
    property scDesc: WideString read Get_scDesc;
    property scCompanyRate: Double read Get_scCompanyRate;
    property scDailyRate: Double read Get_scDailyRate;
    property scPrintSymb: WideString read Get_scPrintSymb;
    property scTriRate: Double read Get_scTriRate;
    property scTriEuroCcy: Smallint read Get_scTriEuroCcy;
    property scTriInvert: WordBool read Get_scTriInvert;
    property scTriFloating: WordBool read Get_scTriFloating;
  end;

// *********************************************************************//
// DispIntf:  ISystemSetupCurrencyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {729B93A2-92C8-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ISystemSetupCurrencyDisp = dispinterface
    ['{729B93A2-92C8-11D4-A998-0050DA3DF9AD}']
    property scSymbol: WideString readonly dispid 1;
    property scDesc: WideString readonly dispid 2;
    property scCompanyRate: Double readonly dispid 3;
    property scDailyRate: Double readonly dispid 4;
    property scPrintSymb: WideString readonly dispid 5;
    property scTriRate: Double readonly dispid 6;
    property scTriEuroCcy: Smallint readonly dispid 7;
    property scTriInvert: WordBool readonly dispid 8;
    property scTriFloating: WordBool readonly dispid 9;
  end;

// *********************************************************************//
// Interface: ISystemSetupReleaseCodes
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D155AD20-9AB8-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ISystemSetupReleaseCodes = interface(IDispatch)
    ['{D155AD20-9AB8-11D4-A998-0050DA3DF9AD}']
    function Get_rcAccountStockAnalysis: TReleaseCodeStatus; safecall;
    function Get_rcCommitment: TReleaseCodeStatus; safecall;
    function Get_rcEBusiness: TReleaseCodeStatus; safecall;
    function Get_rcJobCosting: TReleaseCodeStatus; safecall;
    function Get_rcMultiCurrency: TReleaseCodeStatus; safecall;
    function Get_rcOLESave: TReleaseCodeStatus; safecall;
    function Get_rcPaperless: TReleaseCodeStatus; safecall;
    function Get_rcReportWriter: TReleaseCodeStatus; safecall;
    function Get_rcTelesales: TReleaseCodeStatus; safecall;
    function Get_rcToolkitDLL: TReleaseCodeStatus; safecall;
    property rcAccountStockAnalysis: TReleaseCodeStatus read Get_rcAccountStockAnalysis;
    property rcCommitment: TReleaseCodeStatus read Get_rcCommitment;
    property rcEBusiness: TReleaseCodeStatus read Get_rcEBusiness;
    property rcJobCosting: TReleaseCodeStatus read Get_rcJobCosting;
    property rcMultiCurrency: TReleaseCodeStatus read Get_rcMultiCurrency;
    property rcOLESave: TReleaseCodeStatus read Get_rcOLESave;
    property rcPaperless: TReleaseCodeStatus read Get_rcPaperless;
    property rcReportWriter: TReleaseCodeStatus read Get_rcReportWriter;
    property rcTelesales: TReleaseCodeStatus read Get_rcTelesales;
    property rcToolkitDLL: TReleaseCodeStatus read Get_rcToolkitDLL;
  end;

// *********************************************************************//
// DispIntf:  ISystemSetupReleaseCodesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D155AD20-9AB8-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ISystemSetupReleaseCodesDisp = dispinterface
    ['{D155AD20-9AB8-11D4-A998-0050DA3DF9AD}']
    property rcAccountStockAnalysis: TReleaseCodeStatus readonly dispid 1;
    property rcCommitment: TReleaseCodeStatus readonly dispid 2;
    property rcEBusiness: TReleaseCodeStatus readonly dispid 3;
    property rcJobCosting: TReleaseCodeStatus readonly dispid 4;
    property rcMultiCurrency: TReleaseCodeStatus readonly dispid 5;
    property rcOLESave: TReleaseCodeStatus readonly dispid 6;
    property rcPaperless: TReleaseCodeStatus readonly dispid 7;
    property rcReportWriter: TReleaseCodeStatus readonly dispid 8;
    property rcTelesales: TReleaseCodeStatus readonly dispid 9;
    property rcToolkitDLL: TReleaseCodeStatus readonly dispid 10;
  end;

// *********************************************************************//
// Interface: ISystemSetupUserFields
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {729B93A4-92C8-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ISystemSetupUserFields = interface(IDispatch)
    ['{729B93A4-92C8-11D4-A998-0050DA3DF9AD}']
    function Get_ufAccount1: WideString; safecall;
    function Get_ufAccount2: WideString; safecall;
    function Get_ufAccount3: WideString; safecall;
    function Get_ufAccount4: WideString; safecall;
    function Get_ufTrans1: WideString; safecall;
    function Get_ufTrans2: WideString; safecall;
    function Get_ufTrans3: WideString; safecall;
    function Get_ufTrans4: WideString; safecall;
    function Get_ufStock1: WideString; safecall;
    function Get_ufStock2: WideString; safecall;
    function Get_ufStock3: WideString; safecall;
    function Get_ufStock4: WideString; safecall;
    function Get_ufLine1: WideString; safecall;
    function Get_ufLine2: WideString; safecall;
    function Get_ufLine3: WideString; safecall;
    function Get_ufLine4: WideString; safecall;
    function Get_ufJob1: WideString; safecall;
    function Get_ufJob2: WideString; safecall;
    function Get_ufTrans1Enabled: WordBool; safecall;
    function Get_ufTrans2Enabled: WordBool; safecall;
    function Get_ufTrans3Enabled: WordBool; safecall;
    function Get_ufTrans4Enabled: WordBool; safecall;
    function Get_ufLine1Enabled: WordBool; safecall;
    function Get_ufLine2Enabled: WordBool; safecall;
    function Get_ufLine3Enabled: WordBool; safecall;
    function Get_ufLine4Enabled: WordBool; safecall;
    function Get_ufLineType1: WideString; safecall;
    function Get_ufLineType2: WideString; safecall;
    function Get_ufLineType3: WideString; safecall;
    function Get_ufLineType4: WideString; safecall;
    function Get_ufLineType1Enabled: WordBool; safecall;
    function Get_ufLineType2Enabled: WordBool; safecall;
    function Get_ufLineType3Enabled: WordBool; safecall;
    function Get_ufLineType4Enabled: WordBool; safecall;
    property ufAccount1: WideString read Get_ufAccount1;
    property ufAccount2: WideString read Get_ufAccount2;
    property ufAccount3: WideString read Get_ufAccount3;
    property ufAccount4: WideString read Get_ufAccount4;
    property ufTrans1: WideString read Get_ufTrans1;
    property ufTrans2: WideString read Get_ufTrans2;
    property ufTrans3: WideString read Get_ufTrans3;
    property ufTrans4: WideString read Get_ufTrans4;
    property ufStock1: WideString read Get_ufStock1;
    property ufStock2: WideString read Get_ufStock2;
    property ufStock3: WideString read Get_ufStock3;
    property ufStock4: WideString read Get_ufStock4;
    property ufLine1: WideString read Get_ufLine1;
    property ufLine2: WideString read Get_ufLine2;
    property ufLine3: WideString read Get_ufLine3;
    property ufLine4: WideString read Get_ufLine4;
    property ufJob1: WideString read Get_ufJob1;
    property ufJob2: WideString read Get_ufJob2;
    property ufTrans1Enabled: WordBool read Get_ufTrans1Enabled;
    property ufTrans2Enabled: WordBool read Get_ufTrans2Enabled;
    property ufTrans3Enabled: WordBool read Get_ufTrans3Enabled;
    property ufTrans4Enabled: WordBool read Get_ufTrans4Enabled;
    property ufLine1Enabled: WordBool read Get_ufLine1Enabled;
    property ufLine2Enabled: WordBool read Get_ufLine2Enabled;
    property ufLine3Enabled: WordBool read Get_ufLine3Enabled;
    property ufLine4Enabled: WordBool read Get_ufLine4Enabled;
    property ufLineType1: WideString read Get_ufLineType1;
    property ufLineType2: WideString read Get_ufLineType2;
    property ufLineType3: WideString read Get_ufLineType3;
    property ufLineType4: WideString read Get_ufLineType4;
    property ufLineType1Enabled: WordBool read Get_ufLineType1Enabled;
    property ufLineType2Enabled: WordBool read Get_ufLineType2Enabled;
    property ufLineType3Enabled: WordBool read Get_ufLineType3Enabled;
    property ufLineType4Enabled: WordBool read Get_ufLineType4Enabled;
  end;

// *********************************************************************//
// DispIntf:  ISystemSetupUserFieldsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {729B93A4-92C8-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ISystemSetupUserFieldsDisp = dispinterface
    ['{729B93A4-92C8-11D4-A998-0050DA3DF9AD}']
    property ufAccount1: WideString readonly dispid 1;
    property ufAccount2: WideString readonly dispid 2;
    property ufAccount3: WideString readonly dispid 3;
    property ufAccount4: WideString readonly dispid 4;
    property ufTrans1: WideString readonly dispid 5;
    property ufTrans2: WideString readonly dispid 6;
    property ufTrans3: WideString readonly dispid 7;
    property ufTrans4: WideString readonly dispid 8;
    property ufStock1: WideString readonly dispid 9;
    property ufStock2: WideString readonly dispid 10;
    property ufStock3: WideString readonly dispid 11;
    property ufStock4: WideString readonly dispid 12;
    property ufLine1: WideString readonly dispid 13;
    property ufLine2: WideString readonly dispid 14;
    property ufLine3: WideString readonly dispid 15;
    property ufLine4: WideString readonly dispid 16;
    property ufJob1: WideString readonly dispid 17;
    property ufJob2: WideString readonly dispid 18;
    property ufTrans1Enabled: WordBool readonly dispid 20;
    property ufTrans2Enabled: WordBool readonly dispid 21;
    property ufTrans3Enabled: WordBool readonly dispid 22;
    property ufTrans4Enabled: WordBool readonly dispid 23;
    property ufLine1Enabled: WordBool readonly dispid 24;
    property ufLine2Enabled: WordBool readonly dispid 25;
    property ufLine3Enabled: WordBool readonly dispid 26;
    property ufLine4Enabled: WordBool readonly dispid 27;
    property ufLineType1: WideString readonly dispid 28;
    property ufLineType2: WideString readonly dispid 29;
    property ufLineType3: WideString readonly dispid 30;
    property ufLineType4: WideString readonly dispid 31;
    property ufLineType1Enabled: WordBool readonly dispid 32;
    property ufLineType2Enabled: WordBool readonly dispid 33;
    property ufLineType3Enabled: WordBool readonly dispid 34;
    property ufLineType4Enabled: WordBool readonly dispid 35;
  end;

// *********************************************************************//
// Interface: ISystemSetupVAT
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {729B93A0-92C8-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ISystemSetupVAT = interface(IDispatch)
    ['{729B93A0-92C8-11D4-A998-0050DA3DF9AD}']
    function Get_svCode: WideString; safecall;
    function Get_svDesc: WideString; safecall;
    function Get_svRate: Double; safecall;
    function Get_svInclude: WordBool; safecall;
    property svCode: WideString read Get_svCode;
    property svDesc: WideString read Get_svDesc;
    property svRate: Double read Get_svRate;
    property svInclude: WordBool read Get_svInclude;
  end;

// *********************************************************************//
// DispIntf:  ISystemSetupVATDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {729B93A0-92C8-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  ISystemSetupVATDisp = dispinterface
    ['{729B93A0-92C8-11D4-A998-0050DA3DF9AD}']
    property svCode: WideString readonly dispid 1;
    property svDesc: WideString readonly dispid 2;
    property svRate: Double readonly dispid 3;
    property svInclude: WordBool readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IStock
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E42A0800-95EB-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IStock = interface(IDispatch)
    ['{E42A0800-95EB-11D4-A998-0050DA3DF9AD}']
    function Get_stCode: WideString; safecall;
    procedure Set_stCode(const Value: WideString); safecall;
    function Get_stDesc(Index: Integer): WideString; safecall;
    procedure Set_stDesc(Index: Integer; const Value: WideString); safecall;
    function Get_stAltCode: WideString; safecall;
    procedure Set_stAltCode(const Value: WideString); safecall;
    function Get_stType: TStockType; safecall;
    procedure Set_stType(Value: TStockType); safecall;
    function Get_stSalesGL: Integer; safecall;
    procedure Set_stSalesGL(Value: Integer); safecall;
    function Get_stCOSGL: Integer; safecall;
    procedure Set_stCOSGL(Value: Integer); safecall;
    function Get_stPandLGL: Integer; safecall;
    procedure Set_stPandLGL(Value: Integer); safecall;
    function Get_stBalSheetGL: Integer; safecall;
    procedure Set_stBalSheetGL(Value: Integer); safecall;
    function Get_stWIPGL: Integer; safecall;
    procedure Set_stWIPGL(Value: Integer); safecall;
    function Get_stBelowMinLevel: WordBool; safecall;
    procedure Set_stBelowMinLevel(Value: WordBool); safecall;
    function Get_stFolioNum: Integer; safecall;
    function Get_stParentCode: WideString; safecall;
    procedure Set_stParentCode(const Value: WideString); safecall;
    function Get_stSuppTemp: WideString; safecall;
    procedure Set_stSuppTemp(const Value: WideString); safecall;
    function Get_stUnitOfStock: WideString; safecall;
    procedure Set_stUnitOfStock(const Value: WideString); safecall;
    function Get_stUnitOfSale: WideString; safecall;
    procedure Set_stUnitOfSale(const Value: WideString); safecall;
    function Get_stUnitOfPurch: WideString; safecall;
    procedure Set_stUnitOfPurch(const Value: WideString); safecall;
    function Get_stCostPriceCur: Integer; safecall;
    procedure Set_stCostPriceCur(Value: Integer); safecall;
    function Get_stCostPrice: Double; safecall;
    procedure Set_stCostPrice(Value: Double); safecall;
    function Get_stSalesUnits: Double; safecall;
    procedure Set_stSalesUnits(Value: Double); safecall;
    function Get_stPurchUnits: Double; safecall;
    procedure Set_stPurchUnits(Value: Double); safecall;
    function Get_stVATCode: WideString; safecall;
    procedure Set_stVATCode(const Value: WideString); safecall;
    function Get_stCostCentre: WideString; safecall;
    procedure Set_stCostCentre(const Value: WideString); safecall;
    function Get_stDepartment: WideString; safecall;
    procedure Set_stDepartment(const Value: WideString); safecall;
    function Get_stQtyInStock: Double; safecall;
    function Get_stQtyPosted: Double; safecall;
    function Get_stQtyAllocated: Double; safecall;
    function Get_stQtyOnOrder: Double; safecall;
    function Get_stQtyMin: Double; safecall;
    procedure Set_stQtyMin(Value: Double); safecall;
    function Get_stQtyMax: Double; safecall;
    procedure Set_stQtyMax(Value: Double); safecall;
    function Get_stBinLocation: WideString; safecall;
    procedure Set_stBinLocation(const Value: WideString); safecall;
    function Get_stCover: IStockCover; safecall;
    function Get_stIntrastat: IStockIntrastat; safecall;
    function Get_stReorder: IStockReorder; safecall;
    function Get_stAnalysisCode: WideString; safecall;
    procedure Set_stAnalysisCode(const Value: WideString); safecall;
    function Get_stSalesBands(const Band: WideString): IStockSalesBand; safecall;
    function Get_stTimeChange: WideString; safecall;
    function Get_stInclusiveVATCode: WideString; safecall;
    procedure Set_stInclusiveVATCode(const Value: WideString); safecall;
    function Get_stOperator: WideString; safecall;
    procedure Set_stOperator(const Value: WideString); safecall;
    function Get_stSupplier: WideString; safecall;
    procedure Set_stSupplier(const Value: WideString); safecall;
    function Get_stSupplierI: IAccount; safecall;
    function Get_stDefaultLineType: TTransactionLineType; safecall;
    procedure Set_stDefaultLineType(Value: TTransactionLineType); safecall;
    function Get_stValuationMethod: TStockValuationType; safecall;
    procedure Set_stValuationMethod(Value: TStockValuationType); safecall;
    function Get_stQtyPicked: Double; safecall;
    function Get_stLastUsed: WideString; safecall;
    function Get_stBarCode: WideString; safecall;
    procedure Set_stBarCode(const Value: WideString); safecall;
    function Get_stLocation: WideString; safecall;
    procedure Set_stLocation(const Value: WideString); safecall;
    function Get_stPricingMethod: TStockPricingMethod; safecall;
    procedure Set_stPricingMethod(Value: TStockPricingMethod); safecall;
    function Get_stShowQtyAsPacks: WordBool; safecall;
    procedure Set_stShowQtyAsPacks(Value: WordBool); safecall;
    function Get_stUseKitPrice: WordBool; safecall;
    procedure Set_stUseKitPrice(Value: WordBool); safecall;
    function Get_stUserField1: WideString; safecall;
    procedure Set_stUserField1(const Value: WideString); safecall;
    function Get_stUserField2: WideString; safecall;
    procedure Set_stUserField2(const Value: WideString); safecall;
    function Get_stUserField3: WideString; safecall;
    procedure Set_stUserField3(const Value: WideString); safecall;
    function Get_stUserField4: WideString; safecall;
    procedure Set_stUserField4(const Value: WideString); safecall;
    function Get_stShowKitOnPurchase: WordBool; safecall;
    procedure Set_stShowKitOnPurchase(Value: WordBool); safecall;
    function Get_stImageFile: WideString; safecall;
    procedure Set_stImageFile(const Value: WideString); safecall;
    function Get_stWebLiveCatalog: WideString; safecall;
    procedure Set_stWebLiveCatalog(const Value: WideString); safecall;
    function Get_stWebPrevCatalog: WideString; safecall;
    procedure Set_stWebPrevCatalog(const Value: WideString); safecall;
    function Get_stUseForEbus: WordBool; safecall;
    procedure Set_stUseForEbus(Value: WordBool); safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_Index: TStockIndex; safecall;
    procedure Set_Index(Value: TStockIndex); safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function StepFirst: Integer; safecall;
    function StepPrevious: Integer; safecall;
    function StepNext: Integer; safecall;
    function StepLast: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function Add: IStock; safecall;
    function Update: IStock; safecall;
    function Clone: IStock; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function BuildCodeIndex(const StockCode: WideString): WideString; safecall;
    function BuildFolioIndex(Folio: Integer): WideString; safecall;
    function BuildParentIndex(const ParentCode: WideString; const ChildCode: WideString): WideString; safecall;
    function BuildDescIndex(const Desc: WideString): WideString; safecall;
    function Get_stLocationList: IStockLocation; safecall;
    function BuildSupplierIndex(const AccountCode: WideString; CostCurrency: Integer; 
                                const StockCode: WideString): WideString; safecall;
    function BuildPandLIndex(PandLGL: Integer; const StockCode: WideString): WideString; safecall;
    function BuildAltCodeIndex(const AlternateCode: WideString): WideString; safecall;
    function BuildBinLocIndex(const BinLocation: WideString): WideString; safecall;
    function BuildBarCodeIndex(const BarCode: WideString): WideString; safecall;
    function Get_stNotes: INotes; safecall;
    function Get_stQtyFree: Double; safecall;
    function Get_stQtyBreaks: IQuantityBreak; safecall;
    function Get_stAnalysisCodeI: IJobAnalysis; safecall;
    function Get_stWhereUsed: IStockWhereUsed; safecall;
    function Get_stBillOfMaterials: IStockBOMList; safecall;
    function Get_stSerialBatch: ISerialBatch; safecall;
    property stCode: WideString read Get_stCode write Set_stCode;
    property stDesc[Index: Integer]: WideString read Get_stDesc write Set_stDesc;
    property stAltCode: WideString read Get_stAltCode write Set_stAltCode;
    property stType: TStockType read Get_stType write Set_stType;
    property stSalesGL: Integer read Get_stSalesGL write Set_stSalesGL;
    property stCOSGL: Integer read Get_stCOSGL write Set_stCOSGL;
    property stPandLGL: Integer read Get_stPandLGL write Set_stPandLGL;
    property stBalSheetGL: Integer read Get_stBalSheetGL write Set_stBalSheetGL;
    property stWIPGL: Integer read Get_stWIPGL write Set_stWIPGL;
    property stBelowMinLevel: WordBool read Get_stBelowMinLevel write Set_stBelowMinLevel;
    property stFolioNum: Integer read Get_stFolioNum;
    property stParentCode: WideString read Get_stParentCode write Set_stParentCode;
    property stSuppTemp: WideString read Get_stSuppTemp write Set_stSuppTemp;
    property stUnitOfStock: WideString read Get_stUnitOfStock write Set_stUnitOfStock;
    property stUnitOfSale: WideString read Get_stUnitOfSale write Set_stUnitOfSale;
    property stUnitOfPurch: WideString read Get_stUnitOfPurch write Set_stUnitOfPurch;
    property stCostPriceCur: Integer read Get_stCostPriceCur write Set_stCostPriceCur;
    property stCostPrice: Double read Get_stCostPrice write Set_stCostPrice;
    property stSalesUnits: Double read Get_stSalesUnits write Set_stSalesUnits;
    property stPurchUnits: Double read Get_stPurchUnits write Set_stPurchUnits;
    property stVATCode: WideString read Get_stVATCode write Set_stVATCode;
    property stCostCentre: WideString read Get_stCostCentre write Set_stCostCentre;
    property stDepartment: WideString read Get_stDepartment write Set_stDepartment;
    property stQtyInStock: Double read Get_stQtyInStock;
    property stQtyPosted: Double read Get_stQtyPosted;
    property stQtyAllocated: Double read Get_stQtyAllocated;
    property stQtyOnOrder: Double read Get_stQtyOnOrder;
    property stQtyMin: Double read Get_stQtyMin write Set_stQtyMin;
    property stQtyMax: Double read Get_stQtyMax write Set_stQtyMax;
    property stBinLocation: WideString read Get_stBinLocation write Set_stBinLocation;
    property stCover: IStockCover read Get_stCover;
    property stIntrastat: IStockIntrastat read Get_stIntrastat;
    property stReorder: IStockReorder read Get_stReorder;
    property stAnalysisCode: WideString read Get_stAnalysisCode write Set_stAnalysisCode;
    property stSalesBands[const Band: WideString]: IStockSalesBand read Get_stSalesBands;
    property stTimeChange: WideString read Get_stTimeChange;
    property stInclusiveVATCode: WideString read Get_stInclusiveVATCode write Set_stInclusiveVATCode;
    property stOperator: WideString read Get_stOperator write Set_stOperator;
    property stSupplier: WideString read Get_stSupplier write Set_stSupplier;
    property stSupplierI: IAccount read Get_stSupplierI;
    property stDefaultLineType: TTransactionLineType read Get_stDefaultLineType write Set_stDefaultLineType;
    property stValuationMethod: TStockValuationType read Get_stValuationMethod write Set_stValuationMethod;
    property stQtyPicked: Double read Get_stQtyPicked;
    property stLastUsed: WideString read Get_stLastUsed;
    property stBarCode: WideString read Get_stBarCode write Set_stBarCode;
    property stLocation: WideString read Get_stLocation write Set_stLocation;
    property stPricingMethod: TStockPricingMethod read Get_stPricingMethod write Set_stPricingMethod;
    property stShowQtyAsPacks: WordBool read Get_stShowQtyAsPacks write Set_stShowQtyAsPacks;
    property stUseKitPrice: WordBool read Get_stUseKitPrice write Set_stUseKitPrice;
    property stUserField1: WideString read Get_stUserField1 write Set_stUserField1;
    property stUserField2: WideString read Get_stUserField2 write Set_stUserField2;
    property stUserField3: WideString read Get_stUserField3 write Set_stUserField3;
    property stUserField4: WideString read Get_stUserField4 write Set_stUserField4;
    property stShowKitOnPurchase: WordBool read Get_stShowKitOnPurchase write Set_stShowKitOnPurchase;
    property stImageFile: WideString read Get_stImageFile write Set_stImageFile;
    property stWebLiveCatalog: WideString read Get_stWebLiveCatalog write Set_stWebLiveCatalog;
    property stWebPrevCatalog: WideString read Get_stWebPrevCatalog write Set_stWebPrevCatalog;
    property stUseForEbus: WordBool read Get_stUseForEbus write Set_stUseForEbus;
    property Index: TStockIndex read Get_Index write Set_Index;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
    property stLocationList: IStockLocation read Get_stLocationList;
    property stNotes: INotes read Get_stNotes;
    property stQtyFree: Double read Get_stQtyFree;
    property stQtyBreaks: IQuantityBreak read Get_stQtyBreaks;
    property stAnalysisCodeI: IJobAnalysis read Get_stAnalysisCodeI;
    property stWhereUsed: IStockWhereUsed read Get_stWhereUsed;
    property stBillOfMaterials: IStockBOMList read Get_stBillOfMaterials;
    property stSerialBatch: ISerialBatch read Get_stSerialBatch;
  end;

// *********************************************************************//
// DispIntf:  IStockDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E42A0800-95EB-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IStockDisp = dispinterface
    ['{E42A0800-95EB-11D4-A998-0050DA3DF9AD}']
    property stCode: WideString dispid 1;
    property stDesc[Index: Integer]: WideString dispid 2;
    property stAltCode: WideString dispid 3;
    property stType: TStockType dispid 4;
    property stSalesGL: Integer dispid 5;
    property stCOSGL: Integer dispid 6;
    property stPandLGL: Integer dispid 7;
    property stBalSheetGL: Integer dispid 8;
    property stWIPGL: Integer dispid 9;
    property stBelowMinLevel: WordBool dispid 10;
    property stFolioNum: Integer readonly dispid 11;
    property stParentCode: WideString dispid 12;
    property stSuppTemp: WideString dispid 13;
    property stUnitOfStock: WideString dispid 14;
    property stUnitOfSale: WideString dispid 15;
    property stUnitOfPurch: WideString dispid 16;
    property stCostPriceCur: Integer dispid 17;
    property stCostPrice: Double dispid 18;
    property stSalesUnits: Double dispid 19;
    property stPurchUnits: Double dispid 20;
    property stVATCode: WideString dispid 21;
    property stCostCentre: WideString dispid 22;
    property stDepartment: WideString dispid 23;
    property stQtyInStock: Double readonly dispid 24;
    property stQtyPosted: Double readonly dispid 25;
    property stQtyAllocated: Double readonly dispid 26;
    property stQtyOnOrder: Double readonly dispid 27;
    property stQtyMin: Double dispid 28;
    property stQtyMax: Double dispid 29;
    property stBinLocation: WideString dispid 36;
    property stCover: IStockCover readonly dispid 37;
    property stIntrastat: IStockIntrastat readonly dispid 38;
    property stReorder: IStockReorder readonly dispid 39;
    property stAnalysisCode: WideString dispid 40;
    property stSalesBands[const Band: WideString]: IStockSalesBand readonly dispid 41;
    property stTimeChange: WideString readonly dispid 42;
    property stInclusiveVATCode: WideString dispid 43;
    property stOperator: WideString dispid 44;
    property stSupplier: WideString dispid 45;
    property stSupplierI: IAccount readonly dispid 46;
    property stDefaultLineType: TTransactionLineType dispid 47;
    property stValuationMethod: TStockValuationType dispid 52;
    property stQtyPicked: Double readonly dispid 53;
    property stLastUsed: WideString readonly dispid 54;
    property stBarCode: WideString dispid 55;
    property stLocation: WideString dispid 56;
    property stPricingMethod: TStockPricingMethod dispid 57;
    property stShowQtyAsPacks: WordBool dispid 58;
    property stUseKitPrice: WordBool dispid 59;
    property stUserField1: WideString dispid 60;
    property stUserField2: WideString dispid 61;
    property stUserField3: WideString dispid 62;
    property stUserField4: WideString dispid 63;
    property stShowKitOnPurchase: WordBool dispid 64;
    property stImageFile: WideString dispid 65;
    property stWebLiveCatalog: WideString dispid 66;
    property stWebPrevCatalog: WideString dispid 67;
    property stUseForEbus: WordBool dispid 68;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property Index: TStockIndex dispid 16777221;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function StepFirst: Integer; dispid 16777233;
    function StepPrevious: Integer; dispid 16777234;
    function StepNext: Integer; dispid 16777235;
    function StepLast: Integer; dispid 16777236;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    function Add: IStock; dispid 30;
    function Update: IStock; dispid 31;
    function Clone: IStock; dispid 32;
    function Save: Integer; dispid 33;
    procedure Cancel; dispid 34;
    function BuildCodeIndex(const StockCode: WideString): WideString; dispid 35;
    function BuildFolioIndex(Folio: Integer): WideString; dispid 48;
    function BuildParentIndex(const ParentCode: WideString; const ChildCode: WideString): WideString; dispid 49;
    function BuildDescIndex(const Desc: WideString): WideString; dispid 50;
    property stLocationList: IStockLocation readonly dispid 51;
    function BuildSupplierIndex(const AccountCode: WideString; CostCurrency: Integer; 
                                const StockCode: WideString): WideString; dispid 69;
    function BuildPandLIndex(PandLGL: Integer; const StockCode: WideString): WideString; dispid 70;
    function BuildAltCodeIndex(const AlternateCode: WideString): WideString; dispid 71;
    function BuildBinLocIndex(const BinLocation: WideString): WideString; dispid 72;
    function BuildBarCodeIndex(const BarCode: WideString): WideString; dispid 73;
    property stNotes: INotes readonly dispid 74;
    property stQtyFree: Double readonly dispid 75;
    property stQtyBreaks: IQuantityBreak readonly dispid 76;
    property stAnalysisCodeI: IJobAnalysis readonly dispid 77;
    property stWhereUsed: IStockWhereUsed readonly dispid 78;
    property stBillOfMaterials: IStockBOMList readonly dispid 79;
    property stSerialBatch: ISerialBatch readonly dispid 80;
  end;

// *********************************************************************//
// Interface: IStockCover
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E42A0ABE-95EB-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IStockCover = interface(IDispatch)
    ['{E42A0ABE-95EB-11D4-A998-0050DA3DF9AD}']
    function Get_stUseCover: WordBool; safecall;
    procedure Set_stUseCover(Value: WordBool); safecall;
    function Get_stCoverPeriods: Smallint; safecall;
    procedure Set_stCoverPeriods(Value: Smallint); safecall;
    function Get_stCoverPeriodUnits: WideString; safecall;
    procedure Set_stCoverPeriodUnits(const Value: WideString); safecall;
    function Get_stCoverMinPeriods: Smallint; safecall;
    procedure Set_stCoverMinPeriods(Value: Smallint); safecall;
    function Get_stCoverMinPeriodUnits: WideString; safecall;
    procedure Set_stCoverMinPeriodUnits(const Value: WideString); safecall;
    function Get_stCoverQtySold: Double; safecall;
    procedure Set_stCoverQtySold(Value: Double); safecall;
    function Get_stCoverMaxPeriods: Smallint; safecall;
    procedure Set_stCoverMaxPeriods(Value: Smallint); safecall;
    function Get_stCoverMaxPeriodUnits: WideString; safecall;
    procedure Set_stCoverMaxPeriodUnits(const Value: WideString); safecall;
    property stUseCover: WordBool read Get_stUseCover write Set_stUseCover;
    property stCoverPeriods: Smallint read Get_stCoverPeriods write Set_stCoverPeriods;
    property stCoverPeriodUnits: WideString read Get_stCoverPeriodUnits write Set_stCoverPeriodUnits;
    property stCoverMinPeriods: Smallint read Get_stCoverMinPeriods write Set_stCoverMinPeriods;
    property stCoverMinPeriodUnits: WideString read Get_stCoverMinPeriodUnits write Set_stCoverMinPeriodUnits;
    property stCoverQtySold: Double read Get_stCoverQtySold write Set_stCoverQtySold;
    property stCoverMaxPeriods: Smallint read Get_stCoverMaxPeriods write Set_stCoverMaxPeriods;
    property stCoverMaxPeriodUnits: WideString read Get_stCoverMaxPeriodUnits write Set_stCoverMaxPeriodUnits;
  end;

// *********************************************************************//
// DispIntf:  IStockCoverDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E42A0ABE-95EB-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IStockCoverDisp = dispinterface
    ['{E42A0ABE-95EB-11D4-A998-0050DA3DF9AD}']
    property stUseCover: WordBool dispid 1;
    property stCoverPeriods: Smallint dispid 2;
    property stCoverPeriodUnits: WideString dispid 3;
    property stCoverMinPeriods: Smallint dispid 4;
    property stCoverMinPeriodUnits: WideString dispid 5;
    property stCoverQtySold: Double dispid 6;
    property stCoverMaxPeriods: Smallint dispid 7;
    property stCoverMaxPeriodUnits: WideString dispid 8;
  end;

// *********************************************************************//
// Interface: IStockIntrastat
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E42A0AC0-95EB-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IStockIntrastat = interface(IDispatch)
    ['{E42A0AC0-95EB-11D4-A998-0050DA3DF9AD}']
    function Get_stSSDCommodityCode: WideString; safecall;
    procedure Set_stSSDCommodityCode(const Value: WideString); safecall;
    function Get_stSSDSalesUnitWeight: Double; safecall;
    procedure Set_stSSDSalesUnitWeight(Value: Double); safecall;
    function Get_stSSDPurchaseUnitWeight: Double; safecall;
    procedure Set_stSSDPurchaseUnitWeight(Value: Double); safecall;
    function Get_stSSDUnitDesc: WideString; safecall;
    procedure Set_stSSDUnitDesc(const Value: WideString); safecall;
    function Get_stSSDStockUnits: Double; safecall;
    procedure Set_stSSDStockUnits(Value: Double); safecall;
    function Get_stSSDDespatchUplift: Double; safecall;
    procedure Set_stSSDDespatchUplift(Value: Double); safecall;
    function Get_stSSDCountry: WideString; safecall;
    procedure Set_stSSDCountry(const Value: WideString); safecall;
    property stSSDCommodityCode: WideString read Get_stSSDCommodityCode write Set_stSSDCommodityCode;
    property stSSDSalesUnitWeight: Double read Get_stSSDSalesUnitWeight write Set_stSSDSalesUnitWeight;
    property stSSDPurchaseUnitWeight: Double read Get_stSSDPurchaseUnitWeight write Set_stSSDPurchaseUnitWeight;
    property stSSDUnitDesc: WideString read Get_stSSDUnitDesc write Set_stSSDUnitDesc;
    property stSSDStockUnits: Double read Get_stSSDStockUnits write Set_stSSDStockUnits;
    property stSSDDespatchUplift: Double read Get_stSSDDespatchUplift write Set_stSSDDespatchUplift;
    property stSSDCountry: WideString read Get_stSSDCountry write Set_stSSDCountry;
  end;

// *********************************************************************//
// DispIntf:  IStockIntrastatDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E42A0AC0-95EB-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IStockIntrastatDisp = dispinterface
    ['{E42A0AC0-95EB-11D4-A998-0050DA3DF9AD}']
    property stSSDCommodityCode: WideString dispid 1;
    property stSSDSalesUnitWeight: Double dispid 2;
    property stSSDPurchaseUnitWeight: Double dispid 3;
    property stSSDUnitDesc: WideString dispid 4;
    property stSSDStockUnits: Double dispid 5;
    property stSSDDespatchUplift: Double dispid 6;
    property stSSDCountry: WideString dispid 7;
  end;

// *********************************************************************//
// Interface: IStockReorder
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E42A0AC2-95EB-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IStockReorder = interface(IDispatch)
    ['{E42A0AC2-95EB-11D4-A998-0050DA3DF9AD}']
    function Get_stReorderQty: Double; safecall;
    procedure Set_stReorderQty(Value: Double); safecall;
    function Get_stReorderCur: Smallint; safecall;
    procedure Set_stReorderCur(Value: Smallint); safecall;
    function Get_stReorderPrice: Double; safecall;
    procedure Set_stReorderPrice(Value: Double); safecall;
    function Get_stReorderDate: WideString; safecall;
    procedure Set_stReorderDate(const Value: WideString); safecall;
    function Get_stReorderCostCentre: WideString; safecall;
    procedure Set_stReorderCostCentre(const Value: WideString); safecall;
    function Get_stReorderDepartment: WideString; safecall;
    procedure Set_stReorderDepartment(const Value: WideString); safecall;
    property stReorderQty: Double read Get_stReorderQty write Set_stReorderQty;
    property stReorderCur: Smallint read Get_stReorderCur write Set_stReorderCur;
    property stReorderPrice: Double read Get_stReorderPrice write Set_stReorderPrice;
    property stReorderDate: WideString read Get_stReorderDate write Set_stReorderDate;
    property stReorderCostCentre: WideString read Get_stReorderCostCentre write Set_stReorderCostCentre;
    property stReorderDepartment: WideString read Get_stReorderDepartment write Set_stReorderDepartment;
  end;

// *********************************************************************//
// DispIntf:  IStockReorderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E42A0AC2-95EB-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IStockReorderDisp = dispinterface
    ['{E42A0AC2-95EB-11D4-A998-0050DA3DF9AD}']
    property stReorderQty: Double dispid 1;
    property stReorderCur: Smallint dispid 2;
    property stReorderPrice: Double dispid 3;
    property stReorderDate: WideString dispid 4;
    property stReorderCostCentre: WideString dispid 5;
    property stReorderDepartment: WideString dispid 6;
  end;

// *********************************************************************//
// Interface: IStockSalesBand
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E42A0AC4-95EB-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IStockSalesBand = interface(IDispatch)
    ['{E42A0AC4-95EB-11D4-A998-0050DA3DF9AD}']
    function Get_stPrice: Double; safecall;
    procedure Set_stPrice(Value: Double); safecall;
    function Get_stCurrency: Integer; safecall;
    procedure Set_stCurrency(Value: Integer); safecall;
    property stPrice: Double read Get_stPrice write Set_stPrice;
    property stCurrency: Integer read Get_stCurrency write Set_stCurrency;
  end;

// *********************************************************************//
// DispIntf:  IStockSalesBandDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E42A0AC4-95EB-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IStockSalesBandDisp = dispinterface
    ['{E42A0AC4-95EB-11D4-A998-0050DA3DF9AD}']
    property stPrice: Double dispid 1;
    property stCurrency: Integer dispid 2;
  end;

// *********************************************************************//
// Interface: IConfiguration
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D8FFA280-9DF4-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IConfiguration = interface(IDispatch)
    ['{D8FFA280-9DF4-11D4-A998-0050DA3DF9AD}']
    function Get_AllowTransactionEditing: WordBool; safecall;
    procedure Set_AllowTransactionEditing(Value: WordBool); safecall;
    function Get_AutoSetPeriod: WordBool; safecall;
    procedure Set_AutoSetPeriod(Value: WordBool); safecall;
    function Get_AutoSetStockCost: WordBool; safecall;
    procedure Set_AutoSetStockCost(Value: WordBool); safecall;
    function Get_AutoSetTransCurrencyRates: WordBool; safecall;
    procedure Set_AutoSetTransCurrencyRates(Value: WordBool); safecall;
    function Get_DataDirectory: WideString; safecall;
    procedure Set_DataDirectory(const Value: WideString); safecall;
    function Get_DeductBOMStock: WordBool; safecall;
    procedure Set_DeductBOMStock(Value: WordBool); safecall;
    function Get_DeductMultiLocationStock: WordBool; safecall;
    procedure Set_DeductMultiLocationStock(Value: WordBool); safecall;
    function Get_DefaultCostCentre: WideString; safecall;
    procedure Set_DefaultCostCentre(const Value: WideString); safecall;
    function Get_DefaultCurrency: Integer; safecall;
    procedure Set_DefaultCurrency(Value: Integer); safecall;
    function Get_DefaultDepartment: WideString; safecall;
    procedure Set_DefaultDepartment(const Value: WideString); safecall;
    function Get_DefaultNominalCode: Integer; safecall;
    procedure Set_DefaultNominalCode(Value: Integer); safecall;
    function Get_DefaultVATCode: WideString; safecall;
    procedure Set_DefaultVATCode(const Value: WideString); safecall;
    function Get_EnterpriseDirectory: WideString; safecall;
    procedure Set_EnterpriseDirectory(const Value: WideString); safecall;
    function Get_OverwriteNotepad: WordBool; safecall;
    procedure Set_OverwriteNotepad(Value: WordBool); safecall;
    function Get_OverwriteTransactionNumbers: WordBool; safecall;
    procedure Set_OverwriteTransactionNumbers(Value: WordBool); safecall;
    function Get_UpdateAccountBalances: WordBool; safecall;
    procedure Set_UpdateAccountBalances(Value: WordBool); safecall;
    function Get_UpdateStockLevels: WordBool; safecall;
    procedure Set_UpdateStockLevels(Value: WordBool); safecall;
    function Get_ValidateJobCostingFields: WordBool; safecall;
    procedure Set_ValidateJobCostingFields(Value: WordBool); safecall;
    function SetDebugMode(Param1: Integer; Param2: Integer; Param3: Integer): OleVariant; safecall;
    function Get_ToolkitPath: WideString; safecall;
    property AllowTransactionEditing: WordBool read Get_AllowTransactionEditing write Set_AllowTransactionEditing;
    property AutoSetPeriod: WordBool read Get_AutoSetPeriod write Set_AutoSetPeriod;
    property AutoSetStockCost: WordBool read Get_AutoSetStockCost write Set_AutoSetStockCost;
    property AutoSetTransCurrencyRates: WordBool read Get_AutoSetTransCurrencyRates write Set_AutoSetTransCurrencyRates;
    property DataDirectory: WideString read Get_DataDirectory write Set_DataDirectory;
    property DeductBOMStock: WordBool read Get_DeductBOMStock write Set_DeductBOMStock;
    property DeductMultiLocationStock: WordBool read Get_DeductMultiLocationStock write Set_DeductMultiLocationStock;
    property DefaultCostCentre: WideString read Get_DefaultCostCentre write Set_DefaultCostCentre;
    property DefaultCurrency: Integer read Get_DefaultCurrency write Set_DefaultCurrency;
    property DefaultDepartment: WideString read Get_DefaultDepartment write Set_DefaultDepartment;
    property DefaultNominalCode: Integer read Get_DefaultNominalCode write Set_DefaultNominalCode;
    property DefaultVATCode: WideString read Get_DefaultVATCode write Set_DefaultVATCode;
    property EnterpriseDirectory: WideString read Get_EnterpriseDirectory write Set_EnterpriseDirectory;
    property OverwriteNotepad: WordBool read Get_OverwriteNotepad write Set_OverwriteNotepad;
    property OverwriteTransactionNumbers: WordBool read Get_OverwriteTransactionNumbers write Set_OverwriteTransactionNumbers;
    property UpdateAccountBalances: WordBool read Get_UpdateAccountBalances write Set_UpdateAccountBalances;
    property UpdateStockLevels: WordBool read Get_UpdateStockLevels write Set_UpdateStockLevels;
    property ValidateJobCostingFields: WordBool read Get_ValidateJobCostingFields write Set_ValidateJobCostingFields;
    property ToolkitPath: WideString read Get_ToolkitPath;
  end;

// *********************************************************************//
// DispIntf:  IConfigurationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D8FFA280-9DF4-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IConfigurationDisp = dispinterface
    ['{D8FFA280-9DF4-11D4-A998-0050DA3DF9AD}']
    property AllowTransactionEditing: WordBool dispid 14;
    property AutoSetPeriod: WordBool dispid 3;
    property AutoSetStockCost: WordBool dispid 8;
    property AutoSetTransCurrencyRates: WordBool dispid 13;
    property DataDirectory: WideString dispid 2;
    property DeductBOMStock: WordBool dispid 9;
    property DeductMultiLocationStock: WordBool dispid 10;
    property DefaultCostCentre: WideString dispid 5;
    property DefaultCurrency: Integer dispid 16;
    property DefaultDepartment: WideString dispid 6;
    property DefaultNominalCode: Integer dispid 4;
    property DefaultVATCode: WideString dispid 7;
    property EnterpriseDirectory: WideString dispid 1;
    property OverwriteNotepad: WordBool dispid 12;
    property OverwriteTransactionNumbers: WordBool dispid 11;
    property UpdateAccountBalances: WordBool dispid 17;
    property UpdateStockLevels: WordBool dispid 18;
    property ValidateJobCostingFields: WordBool dispid 19;
    function SetDebugMode(Param1: Integer; Param2: Integer; Param3: Integer): OleVariant; dispid 20;
    property ToolkitPath: WideString readonly dispid 15;
  end;

// *********************************************************************//
// Interface: IEnterprise
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E55AB740-B591-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IEnterprise = interface(IDispatch)
    ['{E55AB740-B591-11D4-A998-0050DA3DF9AD}']
    function Get_enRunning: WordBool; safecall;
    function Get_enEnterpriseVersion: WideString; safecall;
    function Get_enAppPath: WideString; safecall;
    function Get_enCompanyPath: WideString; safecall;
    function Get_enUserName: WideString; safecall;
    function Get_enCurrencyVersion: TEnterpriseCurrencyVersion; safecall;
    function Get_enModuleVersion: TEnterpriseModuleVersion; safecall;
    function Get_enClientServer: WordBool; safecall;
    property enRunning: WordBool read Get_enRunning;
    property enEnterpriseVersion: WideString read Get_enEnterpriseVersion;
    property enAppPath: WideString read Get_enAppPath;
    property enCompanyPath: WideString read Get_enCompanyPath;
    property enUserName: WideString read Get_enUserName;
    property enCurrencyVersion: TEnterpriseCurrencyVersion read Get_enCurrencyVersion;
    property enModuleVersion: TEnterpriseModuleVersion read Get_enModuleVersion;
    property enClientServer: WordBool read Get_enClientServer;
  end;

// *********************************************************************//
// DispIntf:  IEnterpriseDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E55AB740-B591-11D4-A998-0050DA3DF9AD}
// *********************************************************************//
  IEnterpriseDisp = dispinterface
    ['{E55AB740-B591-11D4-A998-0050DA3DF9AD}']
    property enRunning: WordBool readonly dispid 1;
    property enEnterpriseVersion: WideString readonly dispid 2;
    property enAppPath: WideString readonly dispid 3;
    property enCompanyPath: WideString readonly dispid 4;
    property enUserName: WideString readonly dispid 5;
    property enCurrencyVersion: TEnterpriseCurrencyVersion readonly dispid 6;
    property enModuleVersion: TEnterpriseModuleVersion readonly dispid 7;
    property enClientServer: WordBool readonly dispid 8;
  end;

// *********************************************************************//
// Interface: IGeneralLedger
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {517AF840-BEF7-11D4-A99A-0050DA3DF9AD}
// *********************************************************************//
  IGeneralLedger = interface(IDispatch)
    ['{517AF840-BEF7-11D4-A99A-0050DA3DF9AD}']
    function Get_glCode: Integer; safecall;
    procedure Set_glCode(Value: Integer); safecall;
    function Get_glName: WideString; safecall;
    procedure Set_glName(const Value: WideString); safecall;
    function Get_glParent: Integer; safecall;
    procedure Set_glParent(Value: Integer); safecall;
    function Get_glType: TGeneralLedgerType; safecall;
    procedure Set_glType(Value: TGeneralLedgerType); safecall;
    function Get_glAltCode: WideString; safecall;
    procedure Set_glAltCode(const Value: WideString); safecall;
    function Get_glPage: WordBool; safecall;
    procedure Set_glPage(Value: WordBool); safecall;
    function Get_glSubtotal: WordBool; safecall;
    procedure Set_glSubtotal(Value: WordBool); safecall;
    function Get_glTotal: WordBool; safecall;
    procedure Set_glTotal(Value: WordBool); safecall;
    function Get_glCarryFwd: Integer; safecall;
    procedure Set_glCarryFwd(Value: Integer); safecall;
    function Get_glRevalue: WordBool; safecall;
    procedure Set_glRevalue(Value: WordBool); safecall;
    function Get_glCurrency: Smallint; safecall;
    procedure Set_glCurrency(Value: Smallint); safecall;
    function Add: IGeneralLedger; safecall;
    function Update: IGeneralLedger; safecall;
    function Clone: IGeneralLedger; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function Get_glParentI: IGeneralLedger; safecall;
    function BuildCodeIndex(glCode: Integer): WideString; safecall;
    function BuildNameIndex(const Name: WideString): WideString; safecall;
    function BuildParentIndex(ParentCode: Integer; ChildCode: Integer): WideString; safecall;
    function BuildAltCodeIndex(const AltCode: WideString): WideString; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_Index: TGeneralLedgerIndex; safecall;
    procedure Set_Index(Value: TGeneralLedgerIndex); safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function StepFirst: Integer; safecall;
    function StepPrevious: Integer; safecall;
    function StepNext: Integer; safecall;
    function StepLast: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    property glCode: Integer read Get_glCode write Set_glCode;
    property glName: WideString read Get_glName write Set_glName;
    property glParent: Integer read Get_glParent write Set_glParent;
    property glType: TGeneralLedgerType read Get_glType write Set_glType;
    property glAltCode: WideString read Get_glAltCode write Set_glAltCode;
    property glPage: WordBool read Get_glPage write Set_glPage;
    property glSubtotal: WordBool read Get_glSubtotal write Set_glSubtotal;
    property glTotal: WordBool read Get_glTotal write Set_glTotal;
    property glCarryFwd: Integer read Get_glCarryFwd write Set_glCarryFwd;
    property glRevalue: WordBool read Get_glRevalue write Set_glRevalue;
    property glCurrency: Smallint read Get_glCurrency write Set_glCurrency;
    property glParentI: IGeneralLedger read Get_glParentI;
    property Index: TGeneralLedgerIndex read Get_Index write Set_Index;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
  end;

// *********************************************************************//
// DispIntf:  IGeneralLedgerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {517AF840-BEF7-11D4-A99A-0050DA3DF9AD}
// *********************************************************************//
  IGeneralLedgerDisp = dispinterface
    ['{517AF840-BEF7-11D4-A99A-0050DA3DF9AD}']
    property glCode: Integer dispid 1;
    property glName: WideString dispid 2;
    property glParent: Integer dispid 3;
    property glType: TGeneralLedgerType dispid 4;
    property glAltCode: WideString dispid 5;
    property glPage: WordBool dispid 6;
    property glSubtotal: WordBool dispid 7;
    property glTotal: WordBool dispid 8;
    property glCarryFwd: Integer dispid 9;
    property glRevalue: WordBool dispid 10;
    property glCurrency: Smallint dispid 11;
    function Add: IGeneralLedger; dispid 12;
    function Update: IGeneralLedger; dispid 13;
    function Clone: IGeneralLedger; dispid 14;
    function Save: Integer; dispid 15;
    procedure Cancel; dispid 16;
    property glParentI: IGeneralLedger readonly dispid 18;
    function BuildCodeIndex(glCode: Integer): WideString; dispid 17;
    function BuildNameIndex(const Name: WideString): WideString; dispid 19;
    function BuildParentIndex(ParentCode: Integer; ChildCode: Integer): WideString; dispid 20;
    function BuildAltCodeIndex(const AltCode: WideString): WideString; dispid 21;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property Index: TGeneralLedgerIndex dispid 16777221;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function StepFirst: Integer; dispid 16777233;
    function StepPrevious: Integer; dispid 16777234;
    function StepNext: Integer; dispid 16777235;
    function StepLast: Integer; dispid 16777236;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
  end;

// *********************************************************************//
// Interface: ILocation
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C6021740-C12A-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  ILocation = interface(IDispatch)
    ['{C6021740-C12A-11D4-A99D-0050DA3DF9AD}']
    function Get_loCode: WideString; safecall;
    procedure Set_loCode(const Value: WideString); safecall;
    function Get_loName: WideString; safecall;
    procedure Set_loName(const Value: WideString); safecall;
    function Get_loAddress: IAddress; safecall;
    function Get_loPhone: WideString; safecall;
    procedure Set_loPhone(const Value: WideString); safecall;
    function Get_loFax: WideString; safecall;
    procedure Set_loFax(const Value: WideString); safecall;
    function Get_loEmailAddr: WideString; safecall;
    procedure Set_loEmailAddr(const Value: WideString); safecall;
    function Get_loModem: WideString; safecall;
    procedure Set_loModem(const Value: WideString); safecall;
    function Get_loContact: WideString; safecall;
    procedure Set_loContact(const Value: WideString); safecall;
    function Get_loCurrency: Smallint; safecall;
    procedure Set_loCurrency(Value: Smallint); safecall;
    function Get_loArea: WideString; safecall;
    procedure Set_loArea(const Value: WideString); safecall;
    function Get_loRep: WideString; safecall;
    procedure Set_loRep(const Value: WideString); safecall;
    function Get_loTagged: WordBool; safecall;
    procedure Set_loTagged(Value: WordBool); safecall;
    function Get_loCostCentre: WideString; safecall;
    procedure Set_loCostCentre(const Value: WideString); safecall;
    function Get_loDepartment: WideString; safecall;
    procedure Set_loDepartment(const Value: WideString); safecall;
    function Get_loOverrideSalesPrice: WordBool; safecall;
    procedure Set_loOverrideSalesPrice(Value: WordBool); safecall;
    function Get_loOverrideGLCodes: WordBool; safecall;
    procedure Set_loOverrideGLCodes(Value: WordBool); safecall;
    function Get_loOverrideCCDept: WordBool; safecall;
    procedure Set_loOverrideCCDept(Value: WordBool); safecall;
    function Get_loOverrideSupplier: WordBool; safecall;
    procedure Set_loOverrideSupplier(Value: WordBool); safecall;
    function Get_loOverrideBinLocation: WordBool; safecall;
    procedure Set_loOverrideBinLocation(Value: WordBool); safecall;
    function Get_loSalesGL: Integer; safecall;
    procedure Set_loSalesGL(Value: Integer); safecall;
    function Get_loCostOfSalesGL: Integer; safecall;
    procedure Set_loCostOfSalesGL(Value: Integer); safecall;
    function Get_loPandLGL: Integer; safecall;
    procedure Set_loPandLGL(Value: Integer); safecall;
    function Get_loBalSheetGL: Integer; safecall;
    procedure Set_loBalSheetGL(Value: Integer); safecall;
    function Get_loWIPGL: Integer; safecall;
    procedure Set_loWIPGL(Value: Integer); safecall;
    function BuildCodeIndex(const Code: WideString): WideString; safecall;
    function BuildNameIndex(const Name: WideString): WideString; safecall;
    function Add: ILocation; safecall;
    function Update: ILocation; safecall;
    function Clone: ILocation; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_Index: TLocationIndex; safecall;
    procedure Set_Index(Value: TLocationIndex); safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function Get_loStockList: IStockLocation; safecall;
    property loCode: WideString read Get_loCode write Set_loCode;
    property loName: WideString read Get_loName write Set_loName;
    property loAddress: IAddress read Get_loAddress;
    property loPhone: WideString read Get_loPhone write Set_loPhone;
    property loFax: WideString read Get_loFax write Set_loFax;
    property loEmailAddr: WideString read Get_loEmailAddr write Set_loEmailAddr;
    property loModem: WideString read Get_loModem write Set_loModem;
    property loContact: WideString read Get_loContact write Set_loContact;
    property loCurrency: Smallint read Get_loCurrency write Set_loCurrency;
    property loArea: WideString read Get_loArea write Set_loArea;
    property loRep: WideString read Get_loRep write Set_loRep;
    property loTagged: WordBool read Get_loTagged write Set_loTagged;
    property loCostCentre: WideString read Get_loCostCentre write Set_loCostCentre;
    property loDepartment: WideString read Get_loDepartment write Set_loDepartment;
    property loOverrideSalesPrice: WordBool read Get_loOverrideSalesPrice write Set_loOverrideSalesPrice;
    property loOverrideGLCodes: WordBool read Get_loOverrideGLCodes write Set_loOverrideGLCodes;
    property loOverrideCCDept: WordBool read Get_loOverrideCCDept write Set_loOverrideCCDept;
    property loOverrideSupplier: WordBool read Get_loOverrideSupplier write Set_loOverrideSupplier;
    property loOverrideBinLocation: WordBool read Get_loOverrideBinLocation write Set_loOverrideBinLocation;
    property loSalesGL: Integer read Get_loSalesGL write Set_loSalesGL;
    property loCostOfSalesGL: Integer read Get_loCostOfSalesGL write Set_loCostOfSalesGL;
    property loPandLGL: Integer read Get_loPandLGL write Set_loPandLGL;
    property loBalSheetGL: Integer read Get_loBalSheetGL write Set_loBalSheetGL;
    property loWIPGL: Integer read Get_loWIPGL write Set_loWIPGL;
    property Index: TLocationIndex read Get_Index write Set_Index;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
    property loStockList: IStockLocation read Get_loStockList;
  end;

// *********************************************************************//
// DispIntf:  ILocationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C6021740-C12A-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  ILocationDisp = dispinterface
    ['{C6021740-C12A-11D4-A99D-0050DA3DF9AD}']
    property loCode: WideString dispid 1;
    property loName: WideString dispid 2;
    property loAddress: IAddress readonly dispid 3;
    property loPhone: WideString dispid 4;
    property loFax: WideString dispid 5;
    property loEmailAddr: WideString dispid 6;
    property loModem: WideString dispid 7;
    property loContact: WideString dispid 8;
    property loCurrency: Smallint dispid 9;
    property loArea: WideString dispid 10;
    property loRep: WideString dispid 11;
    property loTagged: WordBool dispid 12;
    property loCostCentre: WideString dispid 13;
    property loDepartment: WideString dispid 14;
    property loOverrideSalesPrice: WordBool dispid 15;
    property loOverrideGLCodes: WordBool dispid 16;
    property loOverrideCCDept: WordBool dispid 17;
    property loOverrideSupplier: WordBool dispid 18;
    property loOverrideBinLocation: WordBool dispid 19;
    property loSalesGL: Integer dispid 20;
    property loCostOfSalesGL: Integer dispid 21;
    property loPandLGL: Integer dispid 22;
    property loBalSheetGL: Integer dispid 23;
    property loWIPGL: Integer dispid 24;
    function BuildCodeIndex(const Code: WideString): WideString; dispid 25;
    function BuildNameIndex(const Name: WideString): WideString; dispid 26;
    function Add: ILocation; dispid 27;
    function Update: ILocation; dispid 28;
    function Clone: ILocation; dispid 29;
    function Save: Integer; dispid 30;
    procedure Cancel; dispid 31;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property Index: TLocationIndex dispid 16777221;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    property loStockList: IStockLocation readonly dispid 32;
  end;

// *********************************************************************//
// Interface: ICCDept
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {904B9E00-C21A-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  ICCDept = interface(IDispatch)
    ['{904B9E00-C21A-11D4-A99D-0050DA3DF9AD}']
    function Get_cdCode: WideString; safecall;
    function Get_cdName: WideString; safecall;
    function BuildCodeIndex(const Code: WideString): WideString; safecall;
    function BuildNameIndex(const Name: WideString): WideString; safecall;
    function Clone: ICCDept; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_Index: TCCDeptIndex; safecall;
    procedure Set_Index(Value: TCCDeptIndex); safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    property cdCode: WideString read Get_cdCode;
    property cdName: WideString read Get_cdName;
    property Index: TCCDeptIndex read Get_Index write Set_Index;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
  end;

// *********************************************************************//
// DispIntf:  ICCDeptDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {904B9E00-C21A-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  ICCDeptDisp = dispinterface
    ['{904B9E00-C21A-11D4-A99D-0050DA3DF9AD}']
    property cdCode: WideString readonly dispid 1;
    property cdName: WideString readonly dispid 2;
    function BuildCodeIndex(const Code: WideString): WideString; dispid 3;
    function BuildNameIndex(const Name: WideString): WideString; dispid 4;
    function Clone: ICCDept; dispid 5;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property Index: TCCDeptIndex dispid 16777221;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
  end;

// *********************************************************************//
// Interface: ICompanyManager
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6BEE79E0-C447-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  ICompanyManager = interface(IDispatch)
    ['{6BEE79E0-C447-11D4-A99D-0050DA3DF9AD}']
    function Get_cmCount: Integer; safecall;
    function Get_cmCompany(Index: Integer): ICompanyDetail; safecall;
    property cmCount: Integer read Get_cmCount;
    property cmCompany[Index: Integer]: ICompanyDetail read Get_cmCompany;
  end;

// *********************************************************************//
// DispIntf:  ICompanyManagerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6BEE79E0-C447-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  ICompanyManagerDisp = dispinterface
    ['{6BEE79E0-C447-11D4-A99D-0050DA3DF9AD}']
    property cmCount: Integer readonly dispid 1;
    property cmCompany[Index: Integer]: ICompanyDetail readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ICompanyDetail
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6BEE79E2-C447-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  ICompanyDetail = interface(IDispatch)
    ['{6BEE79E2-C447-11D4-A99D-0050DA3DF9AD}']
    function Get_coCode: WideString; safecall;
    function Get_coName: WideString; safecall;
    function Get_coPath: WideString; safecall;
    property coCode: WideString read Get_coCode;
    property coName: WideString read Get_coName;
    property coPath: WideString read Get_coPath;
  end;

// *********************************************************************//
// DispIntf:  ICompanyDetailDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6BEE79E2-C447-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  ICompanyDetailDisp = dispinterface
    ['{6BEE79E2-C447-11D4-A99D-0050DA3DF9AD}']
    property coCode: WideString readonly dispid 1;
    property coName: WideString readonly dispid 2;
    property coPath: WideString readonly dispid 3;
  end;

// *********************************************************************//
// Interface: IStockLocation
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AA0B2440-C47D-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  IStockLocation = interface(IDispatch)
    ['{AA0B2440-C47D-11D4-A99D-0050DA3DF9AD}']
    function Get_slStockCode: WideString; safecall;
    procedure Set_slStockCode(const Value: WideString); safecall;
    function Get_slLocationCode: WideString; safecall;
    procedure Set_slLocationCode(const Value: WideString); safecall;
    function Get_slStockCodeI: IStock; safecall;
    function Get_slLocationCodeI: ILocation; safecall;
    function Get_slQtyInStock: Double; safecall;
    function Get_slQtyOnOrder: Double; safecall;
    function Get_slQtyAllocated: Double; safecall;
    function Get_slQtyPicked: Double; safecall;
    function Get_slQtyMin: Double; safecall;
    procedure Set_slQtyMin(Value: Double); safecall;
    function Get_slQtyMax: Double; safecall;
    procedure Set_slQtyMax(Value: Double); safecall;
    function Get_slQtyFreeze: Double; safecall;
    function Get_slReorderQty: Double; safecall;
    procedure Set_slReorderQty(Value: Double); safecall;
    function Get_slReorderCur: Smallint; safecall;
    procedure Set_slReorderCur(Value: Smallint); safecall;
    function Get_slReorderPrice: Double; safecall;
    procedure Set_slReorderPrice(Value: Double); safecall;
    function Get_slReorderDate: WideString; safecall;
    procedure Set_slReorderDate(const Value: WideString); safecall;
    function Get_slReorderCostCentre: WideString; safecall;
    procedure Set_slReorderCostCentre(const Value: WideString); safecall;
    function Get_slReorderDepartment: WideString; safecall;
    procedure Set_slReorderDepartment(const Value: WideString); safecall;
    function Get_slCostCentre: WideString; safecall;
    procedure Set_slCostCentre(const Value: WideString); safecall;
    function Get_slDepartment: WideString; safecall;
    procedure Set_slDepartment(const Value: WideString); safecall;
    function Get_slBinLocation: WideString; safecall;
    procedure Set_slBinLocation(const Value: WideString); safecall;
    function Get_slCostPriceCur: Integer; safecall;
    procedure Set_slCostPriceCur(Value: Integer); safecall;
    function Get_slCostPrice: Double; safecall;
    procedure Set_slCostPrice(Value: Double); safecall;
    function Get_slBelowMinLevel: WordBool; safecall;
    procedure Set_slBelowMinLevel(Value: WordBool); safecall;
    function Get_slSuppTemp: WideString; safecall;
    procedure Set_slSuppTemp(const Value: WideString); safecall;
    function Get_slSupplier: WideString; safecall;
    procedure Set_slSupplier(const Value: WideString); safecall;
    function Get_slSupplierI: IAccount; safecall;
    function Get_slLastUsed: WideString; safecall;
    function Get_slQtyPosted: Double; safecall;
    function Get_slQtyStockTake: Double; safecall;
    procedure Set_slQtyStockTake(Value: Double); safecall;
    function Get_slTimeChange: WideString; safecall;
    function Get_slSalesGL: Integer; safecall;
    procedure Set_slSalesGL(Value: Integer); safecall;
    function Get_slCostOfSalesGL: Integer; safecall;
    procedure Set_slCostOfSalesGL(Value: Integer); safecall;
    function Get_slPandLGL: Integer; safecall;
    procedure Set_slPandLGL(Value: Integer); safecall;
    function Get_slBalSheetGL: Integer; safecall;
    procedure Set_slBalSheetGL(Value: Integer); safecall;
    function Get_slWIPGL: Integer; safecall;
    procedure Set_slWIPGL(Value: Integer); safecall;
    function Get_slSalesBands(const Band: WideString): IStockSalesBand; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function Get_slQtyFree: Double; safecall;
    function BuildCodeIndex(const Code: WideString): WideString; safecall;
    function Add: IStockLocation; safecall;
    function Update: IStockLocation; safecall;
    function Clone: IStockLocation; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    property slStockCode: WideString read Get_slStockCode write Set_slStockCode;
    property slLocationCode: WideString read Get_slLocationCode write Set_slLocationCode;
    property slStockCodeI: IStock read Get_slStockCodeI;
    property slLocationCodeI: ILocation read Get_slLocationCodeI;
    property slQtyInStock: Double read Get_slQtyInStock;
    property slQtyOnOrder: Double read Get_slQtyOnOrder;
    property slQtyAllocated: Double read Get_slQtyAllocated;
    property slQtyPicked: Double read Get_slQtyPicked;
    property slQtyMin: Double read Get_slQtyMin write Set_slQtyMin;
    property slQtyMax: Double read Get_slQtyMax write Set_slQtyMax;
    property slQtyFreeze: Double read Get_slQtyFreeze;
    property slReorderQty: Double read Get_slReorderQty write Set_slReorderQty;
    property slReorderCur: Smallint read Get_slReorderCur write Set_slReorderCur;
    property slReorderPrice: Double read Get_slReorderPrice write Set_slReorderPrice;
    property slReorderDate: WideString read Get_slReorderDate write Set_slReorderDate;
    property slReorderCostCentre: WideString read Get_slReorderCostCentre write Set_slReorderCostCentre;
    property slReorderDepartment: WideString read Get_slReorderDepartment write Set_slReorderDepartment;
    property slCostCentre: WideString read Get_slCostCentre write Set_slCostCentre;
    property slDepartment: WideString read Get_slDepartment write Set_slDepartment;
    property slBinLocation: WideString read Get_slBinLocation write Set_slBinLocation;
    property slCostPriceCur: Integer read Get_slCostPriceCur write Set_slCostPriceCur;
    property slCostPrice: Double read Get_slCostPrice write Set_slCostPrice;
    property slBelowMinLevel: WordBool read Get_slBelowMinLevel write Set_slBelowMinLevel;
    property slSuppTemp: WideString read Get_slSuppTemp write Set_slSuppTemp;
    property slSupplier: WideString read Get_slSupplier write Set_slSupplier;
    property slSupplierI: IAccount read Get_slSupplierI;
    property slLastUsed: WideString read Get_slLastUsed;
    property slQtyPosted: Double read Get_slQtyPosted;
    property slQtyStockTake: Double read Get_slQtyStockTake write Set_slQtyStockTake;
    property slTimeChange: WideString read Get_slTimeChange;
    property slSalesGL: Integer read Get_slSalesGL write Set_slSalesGL;
    property slCostOfSalesGL: Integer read Get_slCostOfSalesGL write Set_slCostOfSalesGL;
    property slPandLGL: Integer read Get_slPandLGL write Set_slPandLGL;
    property slBalSheetGL: Integer read Get_slBalSheetGL write Set_slBalSheetGL;
    property slWIPGL: Integer read Get_slWIPGL write Set_slWIPGL;
    property slSalesBands[const Band: WideString]: IStockSalesBand read Get_slSalesBands;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
    property slQtyFree: Double read Get_slQtyFree;
  end;

// *********************************************************************//
// DispIntf:  IStockLocationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AA0B2440-C47D-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  IStockLocationDisp = dispinterface
    ['{AA0B2440-C47D-11D4-A99D-0050DA3DF9AD}']
    property slStockCode: WideString dispid 1;
    property slLocationCode: WideString dispid 2;
    property slStockCodeI: IStock readonly dispid 3;
    property slLocationCodeI: ILocation readonly dispid 4;
    property slQtyInStock: Double readonly dispid 5;
    property slQtyOnOrder: Double readonly dispid 6;
    property slQtyAllocated: Double readonly dispid 7;
    property slQtyPicked: Double readonly dispid 8;
    property slQtyMin: Double dispid 9;
    property slQtyMax: Double dispid 10;
    property slQtyFreeze: Double readonly dispid 11;
    property slReorderQty: Double dispid 12;
    property slReorderCur: Smallint dispid 13;
    property slReorderPrice: Double dispid 14;
    property slReorderDate: WideString dispid 15;
    property slReorderCostCentre: WideString dispid 16;
    property slReorderDepartment: WideString dispid 17;
    property slCostCentre: WideString dispid 18;
    property slDepartment: WideString dispid 19;
    property slBinLocation: WideString dispid 20;
    property slCostPriceCur: Integer dispid 21;
    property slCostPrice: Double dispid 22;
    property slBelowMinLevel: WordBool dispid 23;
    property slSuppTemp: WideString dispid 24;
    property slSupplier: WideString dispid 25;
    property slSupplierI: IAccount readonly dispid 26;
    property slLastUsed: WideString readonly dispid 27;
    property slQtyPosted: Double readonly dispid 28;
    property slQtyStockTake: Double dispid 29;
    property slTimeChange: WideString readonly dispid 30;
    property slSalesGL: Integer dispid 31;
    property slCostOfSalesGL: Integer dispid 32;
    property slPandLGL: Integer dispid 33;
    property slBalSheetGL: Integer dispid 34;
    property slWIPGL: Integer dispid 35;
    property slSalesBands[const Band: WideString]: IStockSalesBand readonly dispid 36;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    property slQtyFree: Double readonly dispid 37;
    function BuildCodeIndex(const Code: WideString): WideString; dispid 38;
    function Add: IStockLocation; dispid 39;
    function Update: IStockLocation; dispid 40;
    function Clone: IStockLocation; dispid 41;
    function Save: Integer; dispid 42;
    procedure Cancel; dispid 43;
  end;

// *********************************************************************//
// Interface: INotes
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9C7385A0-CB91-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  INotes = interface(IDispatch)
    ['{9C7385A0-CB91-11D4-A99D-0050DA3DF9AD}']
    function Get_ntDate: WideString; safecall;
    procedure Set_ntDate(const Value: WideString); safecall;
    function Get_ntText: WideString; safecall;
    procedure Set_ntText(const Value: WideString); safecall;
    function Get_ntType: TNotesType; safecall;
    procedure Set_ntType(Value: TNotesType); safecall;
    function Get_ntAlarmDate: WideString; safecall;
    procedure Set_ntAlarmDate(const Value: WideString); safecall;
    function Get_ntAlarmSet: WordBool; safecall;
    procedure Set_ntAlarmSet(Value: WordBool); safecall;
    function Get_ntLineNo: Integer; safecall;
    procedure Set_ntLineNo(Value: Integer); safecall;
    function Get_ntOperator: WideString; safecall;
    procedure Set_ntOperator(const Value: WideString); safecall;
    function Get_ntAlarmDays: Integer; safecall;
    procedure Set_ntAlarmDays(Value: Integer); safecall;
    function Get_ntAlarmUser: WideString; safecall;
    procedure Set_ntAlarmUser(const Value: WideString); safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function BuildIndex(LineNo: Integer): WideString; safecall;
    function Get_KeyString: WideString; safecall;
    function Add: INotes; safecall;
    function Update: INotes; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    property ntDate: WideString read Get_ntDate write Set_ntDate;
    property ntText: WideString read Get_ntText write Set_ntText;
    property ntType: TNotesType read Get_ntType write Set_ntType;
    property ntAlarmDate: WideString read Get_ntAlarmDate write Set_ntAlarmDate;
    property ntAlarmSet: WordBool read Get_ntAlarmSet write Set_ntAlarmSet;
    property ntLineNo: Integer read Get_ntLineNo write Set_ntLineNo;
    property ntOperator: WideString read Get_ntOperator write Set_ntOperator;
    property ntAlarmDays: Integer read Get_ntAlarmDays write Set_ntAlarmDays;
    property ntAlarmUser: WideString read Get_ntAlarmUser write Set_ntAlarmUser;
    property Position: Integer read Get_Position write Set_Position;
    property KeyString: WideString read Get_KeyString;
  end;

// *********************************************************************//
// DispIntf:  INotesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9C7385A0-CB91-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  INotesDisp = dispinterface
    ['{9C7385A0-CB91-11D4-A99D-0050DA3DF9AD}']
    property ntDate: WideString dispid 1;
    property ntText: WideString dispid 2;
    property ntType: TNotesType dispid 3;
    property ntAlarmDate: WideString dispid 4;
    property ntAlarmSet: WordBool dispid 5;
    property ntLineNo: Integer dispid 6;
    property ntOperator: WideString dispid 7;
    property ntAlarmDays: Integer dispid 8;
    property ntAlarmUser: WideString dispid 9;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    function BuildIndex(LineNo: Integer): WideString; dispid 33554439;
    property KeyString: WideString readonly dispid 16777222;
    function Add: INotes; dispid 27;
    function Update: INotes; dispid 28;
    function Save: Integer; dispid 30;
    procedure Cancel; dispid 31;
  end;

// *********************************************************************//
// Interface: IJobCosting
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AEDD67E0-D025-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  IJobCosting = interface(IDispatch)
    ['{AEDD67E0-D025-11D4-A99D-0050DA3DF9AD}']
    function Get_Job: IJob; safecall;
    function Get_JobType: IJobType; safecall;
    function Get_JobAnalysis: IJobAnalysis; safecall;
    function Get_Employee: IEmployee; safecall;
    function Get_TimeRates: ITimeRates; safecall;
    property Job: IJob read Get_Job;
    property JobType: IJobType read Get_JobType;
    property JobAnalysis: IJobAnalysis read Get_JobAnalysis;
    property Employee: IEmployee read Get_Employee;
    property TimeRates: ITimeRates read Get_TimeRates;
  end;

// *********************************************************************//
// DispIntf:  IJobCostingDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AEDD67E0-D025-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  IJobCostingDisp = dispinterface
    ['{AEDD67E0-D025-11D4-A99D-0050DA3DF9AD}']
    property Job: IJob readonly dispid 1;
    property JobType: IJobType readonly dispid 2;
    property JobAnalysis: IJobAnalysis readonly dispid 3;
    property Employee: IEmployee readonly dispid 4;
    property TimeRates: ITimeRates readonly dispid 5;
  end;

// *********************************************************************//
// Interface: IJob
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27DD7520-D046-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  IJob = interface(IDispatch)
    ['{27DD7520-D046-11D4-A99D-0050DA3DF9AD}']
    function Get_jrCode: WideString; safecall;
    procedure Set_jrCode(const Value: WideString); safecall;
    function Get_jrDesc: WideString; safecall;
    procedure Set_jrDesc(const Value: WideString); safecall;
    function Get_jrFolio: Integer; safecall;
    function Get_jrAcCode: WideString; safecall;
    procedure Set_jrAcCode(const Value: WideString); safecall;
    function Get_jrParent: WideString; safecall;
    procedure Set_jrParent(const Value: WideString); safecall;
    function Get_jrAltCode: WideString; safecall;
    procedure Set_jrAltCode(const Value: WideString); safecall;
    function Get_jrCompleted: WordBool; safecall;
    procedure Set_jrCompleted(Value: WordBool); safecall;
    function Get_jrContact: WideString; safecall;
    procedure Set_jrContact(const Value: WideString); safecall;
    function Get_jrManager: WideString; safecall;
    procedure Set_jrManager(const Value: WideString); safecall;
    function Get_jrChargeType: TJobChargeType; safecall;
    procedure Set_jrChargeType(Value: TJobChargeType); safecall;
    function Get_jrQuotePrice: Double; safecall;
    procedure Set_jrQuotePrice(Value: Double); safecall;
    function Get_jrQuotePriceCurr: Smallint; safecall;
    procedure Set_jrQuotePriceCurr(Value: Smallint); safecall;
    function Get_jrStartDate: WideString; safecall;
    procedure Set_jrStartDate(const Value: WideString); safecall;
    function Get_jrEndDate: WideString; safecall;
    procedure Set_jrEndDate(const Value: WideString); safecall;
    function Get_jrRevisedEndDate: WideString; safecall;
    procedure Set_jrRevisedEndDate(const Value: WideString); safecall;
    function Get_jrSORNumber: WideString; safecall;
    procedure Set_jrSORNumber(const Value: WideString); safecall;
    function Get_jrVATCode: WideString; safecall;
    procedure Set_jrVATCode(const Value: WideString); safecall;
    function Get_jrJobType: WideString; safecall;
    procedure Set_jrJobType(const Value: WideString); safecall;
    function Get_jrType: TJobTypeType; safecall;
    procedure Set_jrType(Value: TJobTypeType); safecall;
    function Get_jrStatus: TJobStatusType; safecall;
    procedure Set_jrStatus(Value: TJobStatusType); safecall;
    function Get_jrUserField1: WideString; safecall;
    procedure Set_jrUserField1(const Value: WideString); safecall;
    function Get_jrUserField2: WideString; safecall;
    procedure Set_jrUserField2(const Value: WideString); safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_Index: TJobIndex; safecall;
    procedure Set_Index(Value: TJobIndex); safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function StepFirst: Integer; safecall;
    function StepPrevious: Integer; safecall;
    function StepNext: Integer; safecall;
    function StepLast: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function BuildCodeIndex(const JobCode: WideString): WideString; safecall;
    function BuildFolioIndex(Folio: Integer): WideString; safecall;
    function BuildParentIndex(const ParentCode: WideString; const JobCode: WideString): WideString; safecall;
    function Add: IJob; safecall;
    function Update: IJob; safecall;
    function Clone: IJob; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function BuildDescIndex(const Description: WideString): WideString; safecall;
    function BuildCompletedCodeIndex(Completed: WordBool; const JobCode: WideString): WideString; safecall;
    function BuildCompletedDescIndex(Completed: WordBool; const Description: WideString): WideString; safecall;
    function BuildAltCodeIndex(const AlternateCode: WideString): WideString; safecall;
    function BuildAccountIndex(const AccountCode: WideString): WideString; safecall;
    function Get_jrNotes: INotes; safecall;
    function Get_jrJobTypeI: IJobType; safecall;
    property jrCode: WideString read Get_jrCode write Set_jrCode;
    property jrDesc: WideString read Get_jrDesc write Set_jrDesc;
    property jrFolio: Integer read Get_jrFolio;
    property jrAcCode: WideString read Get_jrAcCode write Set_jrAcCode;
    property jrParent: WideString read Get_jrParent write Set_jrParent;
    property jrAltCode: WideString read Get_jrAltCode write Set_jrAltCode;
    property jrCompleted: WordBool read Get_jrCompleted write Set_jrCompleted;
    property jrContact: WideString read Get_jrContact write Set_jrContact;
    property jrManager: WideString read Get_jrManager write Set_jrManager;
    property jrChargeType: TJobChargeType read Get_jrChargeType write Set_jrChargeType;
    property jrQuotePrice: Double read Get_jrQuotePrice write Set_jrQuotePrice;
    property jrQuotePriceCurr: Smallint read Get_jrQuotePriceCurr write Set_jrQuotePriceCurr;
    property jrStartDate: WideString read Get_jrStartDate write Set_jrStartDate;
    property jrEndDate: WideString read Get_jrEndDate write Set_jrEndDate;
    property jrRevisedEndDate: WideString read Get_jrRevisedEndDate write Set_jrRevisedEndDate;
    property jrSORNumber: WideString read Get_jrSORNumber write Set_jrSORNumber;
    property jrVATCode: WideString read Get_jrVATCode write Set_jrVATCode;
    property jrJobType: WideString read Get_jrJobType write Set_jrJobType;
    property jrType: TJobTypeType read Get_jrType write Set_jrType;
    property jrStatus: TJobStatusType read Get_jrStatus write Set_jrStatus;
    property jrUserField1: WideString read Get_jrUserField1 write Set_jrUserField1;
    property jrUserField2: WideString read Get_jrUserField2 write Set_jrUserField2;
    property Index: TJobIndex read Get_Index write Set_Index;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
    property jrNotes: INotes read Get_jrNotes;
    property jrJobTypeI: IJobType read Get_jrJobTypeI;
  end;

// *********************************************************************//
// DispIntf:  IJobDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27DD7520-D046-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  IJobDisp = dispinterface
    ['{27DD7520-D046-11D4-A99D-0050DA3DF9AD}']
    property jrCode: WideString dispid 1;
    property jrDesc: WideString dispid 2;
    property jrFolio: Integer readonly dispid 3;
    property jrAcCode: WideString dispid 4;
    property jrParent: WideString dispid 5;
    property jrAltCode: WideString dispid 6;
    property jrCompleted: WordBool dispid 7;
    property jrContact: WideString dispid 8;
    property jrManager: WideString dispid 9;
    property jrChargeType: TJobChargeType dispid 10;
    property jrQuotePrice: Double dispid 11;
    property jrQuotePriceCurr: Smallint dispid 12;
    property jrStartDate: WideString dispid 13;
    property jrEndDate: WideString dispid 14;
    property jrRevisedEndDate: WideString dispid 15;
    property jrSORNumber: WideString dispid 16;
    property jrVATCode: WideString dispid 17;
    property jrJobType: WideString dispid 20;
    property jrType: TJobTypeType dispid 21;
    property jrStatus: TJobStatusType dispid 22;
    property jrUserField1: WideString dispid 23;
    property jrUserField2: WideString dispid 24;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property Index: TJobIndex dispid 16777221;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function StepFirst: Integer; dispid 16777233;
    function StepPrevious: Integer; dispid 16777234;
    function StepNext: Integer; dispid 16777235;
    function StepLast: Integer; dispid 16777236;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    function BuildCodeIndex(const JobCode: WideString): WideString; dispid 18;
    function BuildFolioIndex(Folio: Integer): WideString; dispid 19;
    function BuildParentIndex(const ParentCode: WideString; const JobCode: WideString): WideString; dispid 25;
    function Add: IJob; dispid 26;
    function Update: IJob; dispid 27;
    function Clone: IJob; dispid 28;
    function Save: Integer; dispid 29;
    procedure Cancel; dispid 30;
    function BuildDescIndex(const Description: WideString): WideString; dispid 31;
    function BuildCompletedCodeIndex(Completed: WordBool; const JobCode: WideString): WideString; dispid 32;
    function BuildCompletedDescIndex(Completed: WordBool; const Description: WideString): WideString; dispid 33;
    function BuildAltCodeIndex(const AlternateCode: WideString): WideString; dispid 34;
    function BuildAccountIndex(const AccountCode: WideString): WideString; dispid 35;
    property jrNotes: INotes readonly dispid 36;
    property jrJobTypeI: IJobType readonly dispid 37;
  end;

// *********************************************************************//
// Interface: IMatching
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F578D00-E60F-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  IMatching = interface(IDispatch)
    ['{9F578D00-E60F-11D4-A99D-0050DA3DF9AD}']
    function Get_maDocRef: WideString; safecall;
    procedure Set_maDocRef(const Value: WideString); safecall;
    function Get_maPayRef: WideString; safecall;
    procedure Set_maPayRef(const Value: WideString); safecall;
    function Get_maType: TMatchingSubType; safecall;
    function Get_maDocCurrency: Smallint; safecall;
    procedure Set_maDocCurrency(Value: Smallint); safecall;
    function Get_maDocValue: Double; safecall;
    procedure Set_maDocValue(Value: Double); safecall;
    function Get_maPayCurrency: Smallint; safecall;
    procedure Set_maPayCurrency(Value: Smallint); safecall;
    function Get_maPayValue: Double; safecall;
    procedure Set_maPayValue(Value: Double); safecall;
    function Get_maBaseValue: Double; safecall;
    procedure Set_maBaseValue(Value: Double); safecall;
    function Get_maDocYourRef: WideString; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function Get_KeyString: WideString; safecall;
    function Add: IMatching; safecall;
    function Save: Integer; safecall;
    property maDocRef: WideString read Get_maDocRef write Set_maDocRef;
    property maPayRef: WideString read Get_maPayRef write Set_maPayRef;
    property maType: TMatchingSubType read Get_maType;
    property maDocCurrency: Smallint read Get_maDocCurrency write Set_maDocCurrency;
    property maDocValue: Double read Get_maDocValue write Set_maDocValue;
    property maPayCurrency: Smallint read Get_maPayCurrency write Set_maPayCurrency;
    property maPayValue: Double read Get_maPayValue write Set_maPayValue;
    property maBaseValue: Double read Get_maBaseValue write Set_maBaseValue;
    property maDocYourRef: WideString read Get_maDocYourRef;
    property Position: Integer read Get_Position write Set_Position;
    property KeyString: WideString read Get_KeyString;
  end;

// *********************************************************************//
// DispIntf:  IMatchingDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F578D00-E60F-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  IMatchingDisp = dispinterface
    ['{9F578D00-E60F-11D4-A99D-0050DA3DF9AD}']
    property maDocRef: WideString dispid 1;
    property maPayRef: WideString dispid 2;
    property maType: TMatchingSubType readonly dispid 3;
    property maDocCurrency: Smallint dispid 4;
    property maDocValue: Double dispid 5;
    property maPayCurrency: Smallint dispid 6;
    property maPayValue: Double dispid 7;
    property maBaseValue: Double dispid 8;
    property maDocYourRef: WideString readonly dispid 10;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    property KeyString: WideString readonly dispid 16777222;
    function Add: IMatching; dispid 9;
    function Save: Integer; dispid 11;
  end;

// *********************************************************************//
// Interface: IAccountDiscount
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F48FEA0-EAD8-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  IAccountDiscount = interface(IDispatch)
    ['{1F48FEA0-EAD8-11D4-A99D-0050DA3DF9AD}']
    function Get_adStockCode: WideString; safecall;
    procedure Set_adStockCode(const Value: WideString); safecall;
    function Get_adType: TDiscountType; safecall;
    procedure Set_adType(Value: TDiscountType); safecall;
    function Get_adCurrency: Smallint; safecall;
    procedure Set_adCurrency(Value: Smallint); safecall;
    function Get_adPrice: Double; safecall;
    procedure Set_adPrice(Value: Double); safecall;
    function Get_adDiscPercent: Double; safecall;
    procedure Set_adDiscPercent(Value: Double); safecall;
    function Get_adDiscValue: Double; safecall;
    procedure Set_adDiscValue(Value: Double); safecall;
    function Get_adMarkupMarginPercent: Double; safecall;
    procedure Set_adMarkupMarginPercent(Value: Double); safecall;
    function Get_adStockCodeI: IStock; safecall;
    function BuildIndex(const StockCode: WideString; Currency: Smallint): WideString; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function Get_adPriceBand: WideString; safecall;
    procedure Set_adPriceBand(const Value: WideString); safecall;
    function Add: IAccountDiscount; safecall;
    function Update: IAccountDiscount; safecall;
    function Clone: IAccountDiscount; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function Get_adQtyBreaks: IQuantityBreak; safecall;
    property adStockCode: WideString read Get_adStockCode write Set_adStockCode;
    property adType: TDiscountType read Get_adType write Set_adType;
    property adCurrency: Smallint read Get_adCurrency write Set_adCurrency;
    property adPrice: Double read Get_adPrice write Set_adPrice;
    property adDiscPercent: Double read Get_adDiscPercent write Set_adDiscPercent;
    property adDiscValue: Double read Get_adDiscValue write Set_adDiscValue;
    property adMarkupMarginPercent: Double read Get_adMarkupMarginPercent write Set_adMarkupMarginPercent;
    property adStockCodeI: IStock read Get_adStockCodeI;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
    property adPriceBand: WideString read Get_adPriceBand write Set_adPriceBand;
    property adQtyBreaks: IQuantityBreak read Get_adQtyBreaks;
  end;

// *********************************************************************//
// DispIntf:  IAccountDiscountDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F48FEA0-EAD8-11D4-A99D-0050DA3DF9AD}
// *********************************************************************//
  IAccountDiscountDisp = dispinterface
    ['{1F48FEA0-EAD8-11D4-A99D-0050DA3DF9AD}']
    property adStockCode: WideString dispid 2;
    property adType: TDiscountType dispid 3;
    property adCurrency: Smallint dispid 4;
    property adPrice: Double dispid 5;
    property adDiscPercent: Double dispid 6;
    property adDiscValue: Double dispid 7;
    property adMarkupMarginPercent: Double dispid 8;
    property adStockCodeI: IStock readonly dispid 9;
    function BuildIndex(const StockCode: WideString; Currency: Smallint): WideString; dispid 10;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    property adPriceBand: WideString dispid 11;
    function Add: IAccountDiscount; dispid 12;
    function Update: IAccountDiscount; dispid 13;
    function Clone: IAccountDiscount; dispid 14;
    function Save: Integer; dispid 15;
    procedure Cancel; dispid 16;
    property adQtyBreaks: IQuantityBreak readonly dispid 1;
  end;

// *********************************************************************//
// Interface: IEBusiness
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1EA22040-85BB-4E12-A061-B68F7163CAF2}
// *********************************************************************//
  IEBusiness = interface(IDispatch)
    ['{1EA22040-85BB-4E12-A061-B68F7163CAF2}']
  end;

// *********************************************************************//
// DispIntf:  IEBusinessDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1EA22040-85BB-4E12-A061-B68F7163CAF2}
// *********************************************************************//
  IEBusinessDisp = dispinterface
    ['{1EA22040-85BB-4E12-A061-B68F7163CAF2}']
  end;

// *********************************************************************//
// Interface: IQuantityBreak
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {985AEDBF-3998-4C71-8334-165AE77C0277}
// *********************************************************************//
  IQuantityBreak = interface(IDispatch)
    ['{985AEDBF-3998-4C71-8334-165AE77C0277}']
    function Get_qbQuantityFrom: Double; safecall;
    procedure Set_qbQuantityFrom(Value: Double); safecall;
    function Get_qbQuantityTo: Double; safecall;
    procedure Set_qbQuantityTo(Value: Double); safecall;
    function Get_qbType: TDiscountType; safecall;
    procedure Set_qbType(Value: TDiscountType); safecall;
    function Get_qbPrice: Double; safecall;
    procedure Set_qbPrice(Value: Double); safecall;
    function Get_qbDiscPercent: Double; safecall;
    procedure Set_qbDiscPercent(Value: Double); safecall;
    function Get_qbDiscValue: Double; safecall;
    procedure Set_qbDiscValue(Value: Double); safecall;
    function Get_qbMarkupMarginPercent: Double; safecall;
    procedure Set_qbMarkupMarginPercent(Value: Double); safecall;
    function Get_qbCurrency: Smallint; safecall;
    procedure Set_qbCurrency(Value: Smallint); safecall;
    function Get_qbPriceBand: WideString; safecall;
    procedure Set_qbPriceBand(const Value: WideString); safecall;
    function Add: IQuantityBreak; safecall;
    function Update: IQuantityBreak; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    property qbQuantityFrom: Double read Get_qbQuantityFrom write Set_qbQuantityFrom;
    property qbQuantityTo: Double read Get_qbQuantityTo write Set_qbQuantityTo;
    property qbType: TDiscountType read Get_qbType write Set_qbType;
    property qbPrice: Double read Get_qbPrice write Set_qbPrice;
    property qbDiscPercent: Double read Get_qbDiscPercent write Set_qbDiscPercent;
    property qbDiscValue: Double read Get_qbDiscValue write Set_qbDiscValue;
    property qbMarkupMarginPercent: Double read Get_qbMarkupMarginPercent write Set_qbMarkupMarginPercent;
    property qbCurrency: Smallint read Get_qbCurrency write Set_qbCurrency;
    property qbPriceBand: WideString read Get_qbPriceBand write Set_qbPriceBand;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
  end;

// *********************************************************************//
// DispIntf:  IQuantityBreakDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {985AEDBF-3998-4C71-8334-165AE77C0277}
// *********************************************************************//
  IQuantityBreakDisp = dispinterface
    ['{985AEDBF-3998-4C71-8334-165AE77C0277}']
    property qbQuantityFrom: Double dispid 1;
    property qbQuantityTo: Double dispid 2;
    property qbType: TDiscountType dispid 3;
    property qbPrice: Double dispid 5;
    property qbDiscPercent: Double dispid 6;
    property qbDiscValue: Double dispid 7;
    property qbMarkupMarginPercent: Double dispid 8;
    property qbCurrency: Smallint dispid 9;
    property qbPriceBand: WideString dispid 10;
    function Add: IQuantityBreak; dispid 11;
    function Update: IQuantityBreak; dispid 12;
    function Save: Integer; dispid 13;
    procedure Cancel; dispid 14;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
  end;

// *********************************************************************//
// Interface: ISystemSetupJob
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA8037CE-A4D6-4A2F-B12F-C09BB13B3916}
// *********************************************************************//
  ISystemSetupJob = interface(IDispatch)
    ['{BA8037CE-A4D6-4A2F-B12F-C09BB13B3916}']
    function Get_ssUsePPIsForTimeSheets: WordBool; safecall;
    function Get_ssSplitJobBudgetsByPeriod: WordBool; safecall;
    function Get_ssPPISupAccount: WideString; safecall;
    function Get_ssJobCategory(Index: TJobCategoryType): WideString; safecall;
    function Get_ssCheckJobBudget: WordBool; safecall;
    function Get_ssJobCostingGLCtrlCodes(Inde: TSystemSetupJobGLCtrlType): Integer; safecall;
    property ssUsePPIsForTimeSheets: WordBool read Get_ssUsePPIsForTimeSheets;
    property ssSplitJobBudgetsByPeriod: WordBool read Get_ssSplitJobBudgetsByPeriod;
    property ssPPISupAccount: WideString read Get_ssPPISupAccount;
    property ssJobCategory[Index: TJobCategoryType]: WideString read Get_ssJobCategory;
    property ssCheckJobBudget: WordBool read Get_ssCheckJobBudget;
    property ssJobCostingGLCtrlCodes[Inde: TSystemSetupJobGLCtrlType]: Integer read Get_ssJobCostingGLCtrlCodes;
  end;

// *********************************************************************//
// DispIntf:  ISystemSetupJobDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA8037CE-A4D6-4A2F-B12F-C09BB13B3916}
// *********************************************************************//
  ISystemSetupJobDisp = dispinterface
    ['{BA8037CE-A4D6-4A2F-B12F-C09BB13B3916}']
    property ssUsePPIsForTimeSheets: WordBool readonly dispid 109;
    property ssSplitJobBudgetsByPeriod: WordBool readonly dispid 110;
    property ssPPISupAccount: WideString readonly dispid 111;
    property ssJobCategory[Index: TJobCategoryType]: WideString readonly dispid 1;
    property ssCheckJobBudget: WordBool readonly dispid 82;
    property ssJobCostingGLCtrlCodes[Inde: TSystemSetupJobGLCtrlType]: Integer readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ISystemSetupPaperless
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {03EBB14E-7774-4501-87C1-F1B7767C1D4B}
// *********************************************************************//
  ISystemSetupPaperless = interface(IDispatch)
    ['{03EBB14E-7774-4501-87C1-F1B7767C1D4B}']
    function Get_ssYourEmailName: WideString; safecall;
    function Get_ssYourEmailAddress: WideString; safecall;
    function Get_ssSMTPServer: WideString; safecall;
    function Get_ssDefaultEmailPriority: TEmailPriority; safecall;
    function Get_ssEmailUseMAPI: WordBool; safecall;
    function Get_ssAttachMethod: TEmailAttachMethod; safecall;
    function Get_ssFaxFromName: WideString; safecall;
    function Get_ssFaxFromTelNo: WideString; safecall;
    function Get_ssFaxInterfacePath: WideString; safecall;
    function Get_ssFaxUsing: TFaxMethod; safecall;
    property ssYourEmailName: WideString read Get_ssYourEmailName;
    property ssYourEmailAddress: WideString read Get_ssYourEmailAddress;
    property ssSMTPServer: WideString read Get_ssSMTPServer;
    property ssDefaultEmailPriority: TEmailPriority read Get_ssDefaultEmailPriority;
    property ssEmailUseMAPI: WordBool read Get_ssEmailUseMAPI;
    property ssAttachMethod: TEmailAttachMethod read Get_ssAttachMethod;
    property ssFaxFromName: WideString read Get_ssFaxFromName;
    property ssFaxFromTelNo: WideString read Get_ssFaxFromTelNo;
    property ssFaxInterfacePath: WideString read Get_ssFaxInterfacePath;
    property ssFaxUsing: TFaxMethod read Get_ssFaxUsing;
  end;

// *********************************************************************//
// DispIntf:  ISystemSetupPaperlessDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {03EBB14E-7774-4501-87C1-F1B7767C1D4B}
// *********************************************************************//
  ISystemSetupPaperlessDisp = dispinterface
    ['{03EBB14E-7774-4501-87C1-F1B7767C1D4B}']
    property ssYourEmailName: WideString readonly dispid 1;
    property ssYourEmailAddress: WideString readonly dispid 2;
    property ssSMTPServer: WideString readonly dispid 3;
    property ssDefaultEmailPriority: TEmailPriority readonly dispid 4;
    property ssEmailUseMAPI: WordBool readonly dispid 5;
    property ssAttachMethod: TEmailAttachMethod readonly dispid 6;
    property ssFaxFromName: WideString readonly dispid 7;
    property ssFaxFromTelNo: WideString readonly dispid 8;
    property ssFaxInterfacePath: WideString readonly dispid 9;
    property ssFaxUsing: TFaxMethod readonly dispid 10;
  end;

// *********************************************************************//
// Interface: IJobType
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EC687B21-AC15-43F1-A031-4B4A8FD7DEC0}
// *********************************************************************//
  IJobType = interface(IDispatch)
    ['{EC687B21-AC15-43F1-A031-4B4A8FD7DEC0}']
    function Get_jtCode: WideString; safecall;
    procedure Set_jtCode(const Value: WideString); safecall;
    function Get_jtName: WideString; safecall;
    procedure Set_jtName(const Value: WideString); safecall;
    function Get_Index: TJobTypeIndex; safecall;
    procedure Set_Index(Value: TJobTypeIndex); safecall;
    function Clone: IJobType; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function BuildCodeIndex(const Code: WideString): WideString; safecall;
    function BuildNameIndex(const Name: WideString): WideString; safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function SavePosition: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function RestorePosition: Integer; safecall;
    property jtCode: WideString read Get_jtCode write Set_jtCode;
    property jtName: WideString read Get_jtName write Set_jtName;
    property Index: TJobTypeIndex read Get_Index write Set_Index;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
  end;

// *********************************************************************//
// DispIntf:  IJobTypeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EC687B21-AC15-43F1-A031-4B4A8FD7DEC0}
// *********************************************************************//
  IJobTypeDisp = dispinterface
    ['{EC687B21-AC15-43F1-A031-4B4A8FD7DEC0}']
    property jtCode: WideString dispid 1;
    property jtName: WideString dispid 2;
    property Index: TJobTypeIndex dispid 3;
    function Clone: IJobType; dispid 4;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    function BuildCodeIndex(const Code: WideString): WideString; dispid 5;
    function BuildNameIndex(const Name: WideString): WideString; dispid 6;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function SavePosition: Integer; dispid 16777232;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    function RestorePosition: Integer; dispid 16777225;
  end;

// *********************************************************************//
// Interface: IJobAnalysis
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {05D4346A-D608-4B22-A111-C5C892CE19C7}
// *********************************************************************//
  IJobAnalysis = interface(IDispatch)
    ['{05D4346A-D608-4B22-A111-C5C892CE19C7}']
    function Get_anCode: WideString; safecall;
    procedure Set_anCode(const Value: WideString); safecall;
    function Get_anDescription: WideString; safecall;
    procedure Set_anDescription(const Value: WideString); safecall;
    function Get_anType: TAnalysisType; safecall;
    procedure Set_anType(Value: TAnalysisType); safecall;
    function Get_anCategory: TAnalysisCategory; safecall;
    procedure Set_anCategory(Value: TAnalysisCategory); safecall;
    function Get_anWIPGL: Integer; safecall;
    procedure Set_anWIPGL(Value: Integer); safecall;
    function Get_anPandLGL: Integer; safecall;
    procedure Set_anPandLGL(Value: Integer); safecall;
    function Get_anLineType: TTransactionLineType; safecall;
    procedure Set_anLineType(Value: TTransactionLineType); safecall;
    function Get_Index: TJobAnalysisIndex; safecall;
    procedure Set_Index(Value: TJobAnalysisIndex); safecall;
    function Clone: IJobAnalysis; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function BuildCodeIndex(const Code: WideString): WideString; safecall;
    function BuildDescriptionIndex(const Description: WideString): WideString; safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function Get_anTypeString: WideString; safecall;
    function Get_anCategoryString: WideString; safecall;
    function Get_anLineTypeString: WideString; safecall;
    property anCode: WideString read Get_anCode write Set_anCode;
    property anDescription: WideString read Get_anDescription write Set_anDescription;
    property anType: TAnalysisType read Get_anType write Set_anType;
    property anCategory: TAnalysisCategory read Get_anCategory write Set_anCategory;
    property anWIPGL: Integer read Get_anWIPGL write Set_anWIPGL;
    property anPandLGL: Integer read Get_anPandLGL write Set_anPandLGL;
    property anLineType: TTransactionLineType read Get_anLineType write Set_anLineType;
    property Index: TJobAnalysisIndex read Get_Index write Set_Index;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
    property anTypeString: WideString read Get_anTypeString;
    property anCategoryString: WideString read Get_anCategoryString;
    property anLineTypeString: WideString read Get_anLineTypeString;
  end;

// *********************************************************************//
// DispIntf:  IJobAnalysisDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {05D4346A-D608-4B22-A111-C5C892CE19C7}
// *********************************************************************//
  IJobAnalysisDisp = dispinterface
    ['{05D4346A-D608-4B22-A111-C5C892CE19C7}']
    property anCode: WideString dispid 1;
    property anDescription: WideString dispid 2;
    property anType: TAnalysisType dispid 3;
    property anCategory: TAnalysisCategory dispid 4;
    property anWIPGL: Integer dispid 5;
    property anPandLGL: Integer dispid 6;
    property anLineType: TTransactionLineType dispid 7;
    property Index: TJobAnalysisIndex dispid 8;
    function Clone: IJobAnalysis; dispid 9;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    function BuildCodeIndex(const Code: WideString): WideString; dispid 10;
    function BuildDescriptionIndex(const Description: WideString): WideString; dispid 11;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    property anTypeString: WideString readonly dispid 12;
    property anCategoryString: WideString readonly dispid 13;
    property anLineTypeString: WideString readonly dispid 14;
  end;

// *********************************************************************//
// Interface: IStockBOMComponent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F3385C2A-C16E-483D-B05D-D45AF6480E5A}
// *********************************************************************//
  IStockBOMComponent = interface(IDispatch)
    ['{F3385C2A-C16E-483D-B05D-D45AF6480E5A}']
    function Get_bmStockCode: WideString; safecall;
    function Get_bmStockCodeI: IStock; safecall;
    function Get_bmQuantityUsed: Double; safecall;
    function Get_bmUnitCost: Double; safecall;
    function Get_bmUnitCostCurrency: Smallint; safecall;
    property bmStockCode: WideString read Get_bmStockCode;
    property bmStockCodeI: IStock read Get_bmStockCodeI;
    property bmQuantityUsed: Double read Get_bmQuantityUsed;
    property bmUnitCost: Double read Get_bmUnitCost;
    property bmUnitCostCurrency: Smallint read Get_bmUnitCostCurrency;
  end;

// *********************************************************************//
// DispIntf:  IStockBOMComponentDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F3385C2A-C16E-483D-B05D-D45AF6480E5A}
// *********************************************************************//
  IStockBOMComponentDisp = dispinterface
    ['{F3385C2A-C16E-483D-B05D-D45AF6480E5A}']
    property bmStockCode: WideString readonly dispid 1;
    property bmStockCodeI: IStock readonly dispid 2;
    property bmQuantityUsed: Double readonly dispid 3;
    property bmUnitCost: Double readonly dispid 4;
    property bmUnitCostCurrency: Smallint readonly dispid 5;
  end;

// *********************************************************************//
// Interface: IStockBOMList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {89740FE6-BAE4-4CD7-A361-99F8515DE772}
// *********************************************************************//
  IStockBOMList = interface(IDispatch)
    ['{89740FE6-BAE4-4CD7-A361-99F8515DE772}']
    function Get_blComponentCount: Integer; safecall;
    function Get_blComponent(Index: Integer): IStockBOMComponent; safecall;
    procedure AddComponent(const StockCode: WideString; QuantityUsed: Double); safecall;
    procedure EditComponent(Index: Integer; const StockCode: WideString; QuantityUsed: Double); safecall;
    procedure InsertComponent(Index: Integer; const StockCode: WideString; QuantityUsed: Double); safecall;
    procedure DeleteComponent(Index: Integer); safecall;
    procedure SwitchComponents(Index1: Integer; Index2: Integer); safecall;
    procedure CheckComponentCosts; safecall;
    property blComponentCount: Integer read Get_blComponentCount;
    property blComponent[Index: Integer]: IStockBOMComponent read Get_blComponent;
  end;

// *********************************************************************//
// DispIntf:  IStockBOMListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {89740FE6-BAE4-4CD7-A361-99F8515DE772}
// *********************************************************************//
  IStockBOMListDisp = dispinterface
    ['{89740FE6-BAE4-4CD7-A361-99F8515DE772}']
    property blComponentCount: Integer readonly dispid 1;
    property blComponent[Index: Integer]: IStockBOMComponent readonly dispid 2;
    procedure AddComponent(const StockCode: WideString; QuantityUsed: Double); dispid 3;
    procedure EditComponent(Index: Integer; const StockCode: WideString; QuantityUsed: Double); dispid 4;
    procedure InsertComponent(Index: Integer; const StockCode: WideString; QuantityUsed: Double); dispid 5;
    procedure DeleteComponent(Index: Integer); dispid 6;
    procedure SwitchComponents(Index1: Integer; Index2: Integer); dispid 7;
    procedure CheckComponentCosts; dispid 8;
  end;

// *********************************************************************//
// Interface: IStockWhereUsed
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {04E4114B-D6FE-4725-9652-15F4C16033A6}
// *********************************************************************//
  IStockWhereUsed = interface(IStockBOMComponent)
    ['{04E4114B-D6FE-4725-9652-15F4C16033A6}']
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
  end;

// *********************************************************************//
// DispIntf:  IStockWhereUsedDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {04E4114B-D6FE-4725-9652-15F4C16033A6}
// *********************************************************************//
  IStockWhereUsedDisp = dispinterface
    ['{04E4114B-D6FE-4725-9652-15F4C16033A6}']
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    property bmStockCode: WideString readonly dispid 1;
    property bmStockCodeI: IStock readonly dispid 2;
    property bmQuantityUsed: Double readonly dispid 3;
    property bmUnitCost: Double readonly dispid 4;
    property bmUnitCostCurrency: Smallint readonly dispid 5;
  end;

// *********************************************************************//
// Interface: IEmployee
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {098A6D33-08B3-40E6-A803-3B07B7AED954}
// *********************************************************************//
  IEmployee = interface(IDispatch)
    ['{098A6D33-08B3-40E6-A803-3B07B7AED954}']
    function Get_emCode: WideString; safecall;
    procedure Set_emCode(const Value: WideString); safecall;
    function Get_emSupplier: WideString; safecall;
    procedure Set_emSupplier(const Value: WideString); safecall;
    function Get_emName: WideString; safecall;
    procedure Set_emName(const Value: WideString); safecall;
    function Get_emAddress: IAddress; safecall;
    function Get_emPhone: WideString; safecall;
    procedure Set_emPhone(const Value: WideString); safecall;
    function Get_emFax: WideString; safecall;
    procedure Set_emFax(const Value: WideString); safecall;
    function Get_emMobile: WideString; safecall;
    procedure Set_emMobile(const Value: WideString); safecall;
    function Get_emType: TEmployeeType; safecall;
    procedure Set_emType(Value: TEmployeeType); safecall;
    function Get_emPayrollNumber: WideString; safecall;
    procedure Set_emPayrollNumber(const Value: WideString); safecall;
    function Get_emCertificateNumber: WideString; safecall;
    procedure Set_emCertificateNumber(const Value: WideString); safecall;
    function Get_emCertificateExpiry: WideString; safecall;
    procedure Set_emCertificateExpiry(const Value: WideString); safecall;
    function Get_emUserField1: WideString; safecall;
    procedure Set_emUserField1(const Value: WideString); safecall;
    function Get_emUserField2: WideString; safecall;
    procedure Set_emUserField2(const Value: WideString); safecall;
    function Get_emTimeRates: ITimeRates; safecall;
    function Get_emCostCentre: WideString; safecall;
    procedure Set_emCostCentre(const Value: WideString); safecall;
    function Get_emDepartment: WideString; safecall;
    procedure Set_emDepartment(const Value: WideString); safecall;
    function Get_emOwnTimeRatesOnly: WordBool; safecall;
    procedure Set_emOwnTimeRatesOnly(Value: WordBool); safecall;
    function Clone: IEmployee; safecall;
    function BuildCodeIndex(const Code: WideString): WideString; safecall;
    function BuildSupplierIndex(const Supplier: WideString): WideString; safecall;
    function Get_Index: TEmployeeIndex; safecall;
    procedure Set_Index(Value: TEmployeeIndex); safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_KeyString: WideString; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function Get_Position: Integer; safecall;
    function Get_emNotes: INotes; safecall;
    property emCode: WideString read Get_emCode write Set_emCode;
    property emSupplier: WideString read Get_emSupplier write Set_emSupplier;
    property emName: WideString read Get_emName write Set_emName;
    property emAddress: IAddress read Get_emAddress;
    property emPhone: WideString read Get_emPhone write Set_emPhone;
    property emFax: WideString read Get_emFax write Set_emFax;
    property emMobile: WideString read Get_emMobile write Set_emMobile;
    property emType: TEmployeeType read Get_emType write Set_emType;
    property emPayrollNumber: WideString read Get_emPayrollNumber write Set_emPayrollNumber;
    property emCertificateNumber: WideString read Get_emCertificateNumber write Set_emCertificateNumber;
    property emCertificateExpiry: WideString read Get_emCertificateExpiry write Set_emCertificateExpiry;
    property emUserField1: WideString read Get_emUserField1 write Set_emUserField1;
    property emUserField2: WideString read Get_emUserField2 write Set_emUserField2;
    property emTimeRates: ITimeRates read Get_emTimeRates;
    property emCostCentre: WideString read Get_emCostCentre write Set_emCostCentre;
    property emDepartment: WideString read Get_emDepartment write Set_emDepartment;
    property emOwnTimeRatesOnly: WordBool read Get_emOwnTimeRatesOnly write Set_emOwnTimeRatesOnly;
    property Index: TEmployeeIndex read Get_Index write Set_Index;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
    property emNotes: INotes read Get_emNotes;
  end;

// *********************************************************************//
// DispIntf:  IEmployeeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {098A6D33-08B3-40E6-A803-3B07B7AED954}
// *********************************************************************//
  IEmployeeDisp = dispinterface
    ['{098A6D33-08B3-40E6-A803-3B07B7AED954}']
    property emCode: WideString dispid 1;
    property emSupplier: WideString dispid 2;
    property emName: WideString dispid 3;
    property emAddress: IAddress readonly dispid 4;
    property emPhone: WideString dispid 5;
    property emFax: WideString dispid 6;
    property emMobile: WideString dispid 7;
    property emType: TEmployeeType dispid 8;
    property emPayrollNumber: WideString dispid 9;
    property emCertificateNumber: WideString dispid 10;
    property emCertificateExpiry: WideString dispid 11;
    property emUserField1: WideString dispid 12;
    property emUserField2: WideString dispid 13;
    property emTimeRates: ITimeRates readonly dispid 14;
    property emCostCentre: WideString dispid 15;
    property emDepartment: WideString dispid 16;
    property emOwnTimeRatesOnly: WordBool dispid 17;
    function Clone: IEmployee; dispid 18;
    function BuildCodeIndex(const Code: WideString): WideString; dispid 19;
    function BuildSupplierIndex(const Supplier: WideString): WideString; dispid 20;
    property Index: TEmployeeIndex dispid 21;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    property emNotes: INotes readonly dispid 22;
  end;

// *********************************************************************//
// Interface: ITimeRates
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9D4BD33D-A272-4958-9E4A-773F50AC93A9}
// *********************************************************************//
  ITimeRates = interface(IDispatch)
    ['{9D4BD33D-A272-4958-9E4A-773F50AC93A9}']
    function Get_trRateCode: WideString; safecall;
    procedure Set_trRateCode(const Value: WideString); safecall;
    function Get_trEmployeeCode: WideString; safecall;
    procedure Set_trEmployeeCode(const Value: WideString); safecall;
    function Get_trCostCurrency: Smallint; safecall;
    procedure Set_trCostCurrency(Value: Smallint); safecall;
    function Get_trTimeCost: Double; safecall;
    procedure Set_trTimeCost(Value: Double); safecall;
    function Get_trChargeCurrency: Smallint; safecall;
    procedure Set_trChargeCurrency(Value: Smallint); safecall;
    function Get_trTimeCharge: Double; safecall;
    procedure Set_trTimeCharge(Value: Double); safecall;
    function Get_trAnalysisCode: WideString; safecall;
    procedure Set_trAnalysisCode(const Value: WideString); safecall;
    function Get_trPayrollCode: Integer; safecall;
    procedure Set_trPayrollCode(Value: Integer); safecall;
    function Get_trDescription: WideString; safecall;
    procedure Set_trDescription(const Value: WideString); safecall;
    function Clone: ITimeRates; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function Get_trPayFactor: Smallint; safecall;
    procedure Set_trPayFactor(Value: Smallint); safecall;
    function Get_trPayRate: Smallint; safecall;
    procedure Set_trPayRate(Value: Smallint); safecall;
    property trRateCode: WideString read Get_trRateCode write Set_trRateCode;
    property trEmployeeCode: WideString read Get_trEmployeeCode write Set_trEmployeeCode;
    property trCostCurrency: Smallint read Get_trCostCurrency write Set_trCostCurrency;
    property trTimeCost: Double read Get_trTimeCost write Set_trTimeCost;
    property trChargeCurrency: Smallint read Get_trChargeCurrency write Set_trChargeCurrency;
    property trTimeCharge: Double read Get_trTimeCharge write Set_trTimeCharge;
    property trAnalysisCode: WideString read Get_trAnalysisCode write Set_trAnalysisCode;
    property trPayrollCode: Integer read Get_trPayrollCode write Set_trPayrollCode;
    property trDescription: WideString read Get_trDescription write Set_trDescription;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
    property trPayFactor: Smallint read Get_trPayFactor write Set_trPayFactor;
    property trPayRate: Smallint read Get_trPayRate write Set_trPayRate;
  end;

// *********************************************************************//
// DispIntf:  ITimeRatesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9D4BD33D-A272-4958-9E4A-773F50AC93A9}
// *********************************************************************//
  ITimeRatesDisp = dispinterface
    ['{9D4BD33D-A272-4958-9E4A-773F50AC93A9}']
    property trRateCode: WideString dispid 7;
    property trEmployeeCode: WideString dispid 6;
    property trCostCurrency: Smallint dispid 9;
    property trTimeCost: Double dispid 2;
    property trChargeCurrency: Smallint dispid 10;
    property trTimeCharge: Double dispid 3;
    property trAnalysisCode: WideString dispid 4;
    property trPayrollCode: Integer dispid 5;
    property trDescription: WideString dispid 8;
    function Clone: ITimeRates; dispid 11;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    property trPayFactor: Smallint dispid 14;
    property trPayRate: Smallint dispid 15;
  end;

// *********************************************************************//
// Interface: ISerialBatchDetails
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AA23C9A5-3DB6-4C3C-8A8D-52B2FE344C8E}
// *********************************************************************//
  ISerialBatchDetails = interface(IDispatch)
    ['{AA23C9A5-3DB6-4C3C-8A8D-52B2FE344C8E}']
    function Get_snSerialNo: WideString; safecall;
    procedure Set_snSerialNo(const Value: WideString); safecall;
    function Get_snBatchNo: WideString; safecall;
    procedure Set_snBatchNo(const Value: WideString); safecall;
    function Get_snType: TSerialBatchType; safecall;
    procedure Set_snSold(Value: WordBool); safecall;
    function Get_snSold: WordBool; safecall;
    function Get_snUseByDate: WideString; safecall;
    procedure Set_snUseByDate(const Value: WideString); safecall;
    procedure Set_snInDate(const Value: WideString); safecall;
    function Get_snInDate: WideString; safecall;
    function Get_snInOrderRef: WideString; safecall;
    procedure Set_snInOrderRef(const Value: WideString); safecall;
    function Get_snInOrderLine: Integer; safecall;
    procedure Set_snInOrderLine(Value: Integer); safecall;
    function Get_snInDocRef: WideString; safecall;
    procedure Set_snInDocRef(const Value: WideString); safecall;
    function Get_snInDocLine: Integer; safecall;
    procedure Set_snInDocLine(Value: Integer); safecall;
    function Get_snInLocation: WideString; safecall;
    procedure Set_snInLocation(const Value: WideString); safecall;
    procedure Set_snOutDate(const Value: WideString); safecall;
    function Get_snOutDate: WideString; safecall;
    function Get_snOutOrderRef: WideString; safecall;
    procedure Set_snOutOrderRef(const Value: WideString); safecall;
    function Get_snOutOrderLine: Integer; safecall;
    procedure Set_snOutOrderLine(Value: Integer); safecall;
    function Get_snOutDocRef: WideString; safecall;
    procedure Set_snOutDocRef(const Value: WideString); safecall;
    function Get_snOutDocLine: Integer; safecall;
    procedure Set_snOutDocLine(Value: Integer); safecall;
    function Get_snOutLocation: WideString; safecall;
    procedure Set_snOutLocation(const Value: WideString); safecall;
    function Get_snCostPrice: Double; safecall;
    procedure Set_snCostPrice(Value: Double); safecall;
    function Get_snCostPriceCurrency: Smallint; safecall;
    procedure Set_snCostPriceCurrency(Value: Smallint); safecall;
    function Get_snSalesPrice: Double; safecall;
    procedure Set_snSalesPrice(Value: Double); safecall;
    function Get_snSalesPriceCurrency: Smallint; safecall;
    procedure Set_snSalesPriceCurrency(Value: Smallint); safecall;
    function Get_snBatchQuantity: Double; safecall;
    procedure Set_snBatchQuantity(Value: Double); safecall;
    function Get_snBatchQuantitySold: Double; safecall;
    procedure Set_snBatchQuantitySold(Value: Double); safecall;
    function Get_snDailyRate: Double; safecall;
    procedure Set_snDailyRate(Value: Double); safecall;
    function Get_snCompanyRate: Double; safecall;
    procedure Set_snCompanyRate(Value: Double); safecall;
    function Get_snNotes: INotes; safecall;
    property snSerialNo: WideString read Get_snSerialNo write Set_snSerialNo;
    property snBatchNo: WideString read Get_snBatchNo write Set_snBatchNo;
    property snType: TSerialBatchType read Get_snType;
    property snSold: WordBool read Get_snSold write Set_snSold;
    property snUseByDate: WideString read Get_snUseByDate write Set_snUseByDate;
    property snInDate: WideString read Get_snInDate write Set_snInDate;
    property snInOrderRef: WideString read Get_snInOrderRef write Set_snInOrderRef;
    property snInOrderLine: Integer read Get_snInOrderLine write Set_snInOrderLine;
    property snInDocRef: WideString read Get_snInDocRef write Set_snInDocRef;
    property snInDocLine: Integer read Get_snInDocLine write Set_snInDocLine;
    property snInLocation: WideString read Get_snInLocation write Set_snInLocation;
    property snOutDate: WideString read Get_snOutDate write Set_snOutDate;
    property snOutOrderRef: WideString read Get_snOutOrderRef write Set_snOutOrderRef;
    property snOutOrderLine: Integer read Get_snOutOrderLine write Set_snOutOrderLine;
    property snOutDocRef: WideString read Get_snOutDocRef write Set_snOutDocRef;
    property snOutDocLine: Integer read Get_snOutDocLine write Set_snOutDocLine;
    property snOutLocation: WideString read Get_snOutLocation write Set_snOutLocation;
    property snCostPrice: Double read Get_snCostPrice write Set_snCostPrice;
    property snCostPriceCurrency: Smallint read Get_snCostPriceCurrency write Set_snCostPriceCurrency;
    property snSalesPrice: Double read Get_snSalesPrice write Set_snSalesPrice;
    property snSalesPriceCurrency: Smallint read Get_snSalesPriceCurrency write Set_snSalesPriceCurrency;
    property snBatchQuantity: Double read Get_snBatchQuantity write Set_snBatchQuantity;
    property snBatchQuantitySold: Double read Get_snBatchQuantitySold write Set_snBatchQuantitySold;
    property snDailyRate: Double read Get_snDailyRate write Set_snDailyRate;
    property snCompanyRate: Double read Get_snCompanyRate write Set_snCompanyRate;
    property snNotes: INotes read Get_snNotes;
  end;

// *********************************************************************//
// DispIntf:  ISerialBatchDetailsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AA23C9A5-3DB6-4C3C-8A8D-52B2FE344C8E}
// *********************************************************************//
  ISerialBatchDetailsDisp = dispinterface
    ['{AA23C9A5-3DB6-4C3C-8A8D-52B2FE344C8E}']
    property snSerialNo: WideString dispid 1;
    property snBatchNo: WideString dispid 2;
    property snType: TSerialBatchType readonly dispid 3;
    property snSold: WordBool dispid 4;
    property snUseByDate: WideString dispid 5;
    property snInDate: WideString dispid 9;
    property snInOrderRef: WideString dispid 10;
    property snInOrderLine: Integer dispid 11;
    property snInDocRef: WideString dispid 12;
    property snInDocLine: Integer dispid 13;
    property snInLocation: WideString dispid 14;
    property snOutDate: WideString dispid 21;
    property snOutOrderRef: WideString dispid 22;
    property snOutOrderLine: Integer dispid 23;
    property snOutDocRef: WideString dispid 24;
    property snOutDocLine: Integer dispid 25;
    property snOutLocation: WideString dispid 26;
    property snCostPrice: Double dispid 27;
    property snCostPriceCurrency: Smallint dispid 28;
    property snSalesPrice: Double dispid 29;
    property snSalesPriceCurrency: Smallint dispid 30;
    property snBatchQuantity: Double dispid 31;
    property snBatchQuantitySold: Double dispid 32;
    property snDailyRate: Double dispid 33;
    property snCompanyRate: Double dispid 34;
    property snNotes: INotes readonly dispid 35;
  end;

// *********************************************************************//
// Interface: ISerialBatch
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0834B7FA-A2F0-48AA-ABA6-1E5832CB175C}
// *********************************************************************//
  ISerialBatch = interface(ISerialBatchDetails)
    ['{0834B7FA-A2F0-48AA-ABA6-1E5832CB175C}']
    function BuildUsedSerialIndex(Sold: WordBool; const SerialNo: WideString): WideString; safecall;
    function Add: ISerialBatch; safecall;
    function Clone: ISerialBatch; safecall;
    function Save: Integer; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function BuildSerialIndex(const SerialNo: WideString): WideString; safecall;
    function BuildBatchIndex(const BatchNo: WideString): WideString; safecall;
    function Get_Index: TSerialBatchIndex; safecall;
    procedure Set_Index(Value: TSerialBatchIndex); safecall;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
    property Index: TSerialBatchIndex read Get_Index write Set_Index;
  end;

// *********************************************************************//
// DispIntf:  ISerialBatchDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0834B7FA-A2F0-48AA-ABA6-1E5832CB175C}
// *********************************************************************//
  ISerialBatchDisp = dispinterface
    ['{0834B7FA-A2F0-48AA-ABA6-1E5832CB175C}']
    function BuildUsedSerialIndex(Sold: WordBool; const SerialNo: WideString): WideString; dispid 257;
    function Add: ISerialBatch; dispid 258;
    function Clone: ISerialBatch; dispid 260;
    function Save: Integer; dispid 261;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    function BuildSerialIndex(const SerialNo: WideString): WideString; dispid 6;
    function BuildBatchIndex(const BatchNo: WideString): WideString; dispid 7;
    property Index: TSerialBatchIndex dispid 8;
    property snSerialNo: WideString dispid 1;
    property snBatchNo: WideString dispid 2;
    property snType: TSerialBatchType readonly dispid 3;
    property snSold: WordBool dispid 4;
    property snUseByDate: WideString dispid 5;
    property snInDate: WideString dispid 9;
    property snInOrderRef: WideString dispid 10;
    property snInOrderLine: Integer dispid 11;
    property snInDocRef: WideString dispid 12;
    property snInDocLine: Integer dispid 13;
    property snInLocation: WideString dispid 14;
    property snOutDate: WideString dispid 21;
    property snOutOrderRef: WideString dispid 22;
    property snOutOrderLine: Integer dispid 23;
    property snOutDocRef: WideString dispid 24;
    property snOutDocLine: Integer dispid 25;
    property snOutLocation: WideString dispid 26;
    property snCostPrice: Double dispid 27;
    property snCostPriceCurrency: Smallint dispid 28;
    property snSalesPrice: Double dispid 29;
    property snSalesPriceCurrency: Smallint dispid 30;
    property snBatchQuantity: Double dispid 31;
    property snBatchQuantitySold: Double dispid 32;
    property snDailyRate: Double dispid 33;
    property snCompanyRate: Double dispid 34;
    property snNotes: INotes readonly dispid 35;
  end;

// *********************************************************************//
// Interface: ITransactionLineSerialBatch
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CEF58474-422A-482D-9474-3C37C64E445B}
// *********************************************************************//
  ITransactionLineSerialBatch = interface(IDispatch)
    ['{CEF58474-422A-482D-9474-3C37C64E445B}']
    function Get_tlCount: Integer; safecall;
    function Get_tlUsedSerialBatch(Index: Integer): ISerialBatchDetails; safecall;
    function Get_tlUsesSerialBatchNo: WordBool; safecall;
    function Add: ISerialBatch; safecall;
    procedure Refresh; safecall;
    function UseSerialBatch(const SerialBatch: ISerialBatchDetails): Integer; safecall;
    property tlCount: Integer read Get_tlCount;
    property tlUsedSerialBatch[Index: Integer]: ISerialBatchDetails read Get_tlUsedSerialBatch;
    property tlUsesSerialBatchNo: WordBool read Get_tlUsesSerialBatchNo;
  end;

// *********************************************************************//
// DispIntf:  ITransactionLineSerialBatchDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CEF58474-422A-482D-9474-3C37C64E445B}
// *********************************************************************//
  ITransactionLineSerialBatchDisp = dispinterface
    ['{CEF58474-422A-482D-9474-3C37C64E445B}']
    property tlCount: Integer readonly dispid 1;
    property tlUsedSerialBatch[Index: Integer]: ISerialBatchDetails readonly dispid 2;
    property tlUsesSerialBatchNo: WordBool readonly dispid 3;
    function Add: ISerialBatch; dispid 4;
    procedure Refresh; dispid 6;
    function UseSerialBatch(const SerialBatch: ISerialBatchDetails): Integer; dispid 5;
  end;

// *********************************************************************//
// Interface: IInternalDebug
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1C16D217-DB7F-4D29-8E60-7537AB13741D}
// *********************************************************************//
  IInternalDebug = interface(IDispatch)
    ['{1C16D217-DB7F-4D29-8E60-7537AB13741D}']
    function SetDebugMode(Param1: Integer; Param2: Integer; Param3: Integer): OleVariant; safecall;
  end;

// *********************************************************************//
// DispIntf:  IInternalDebugDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1C16D217-DB7F-4D29-8E60-7537AB13741D}
// *********************************************************************//
  IInternalDebugDisp = dispinterface
    ['{1C16D217-DB7F-4D29-8E60-7537AB13741D}']
    function SetDebugMode(Param1: Integer; Param2: Integer; Param3: Integer): OleVariant; dispid 1;
  end;

// *********************************************************************//
// Interface: IUserProfile
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AD907C7D-C3D8-40BD-9D9B-CCE19F1E0558}
// *********************************************************************//
  IUserProfile = interface(IDispatch)
    ['{AD907C7D-C3D8-40BD-9D9B-CCE19F1E0558}']
    function Get_Index: TUserIndexType; safecall;
    procedure Set_Index(Value: TUserIndexType); safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function BuildUserIDIndex(const UserID: WideString): WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function Get_KeyString: WideString; safecall;
    function Get_upUserID: WideString; safecall;
    function Get_upName: WideString; safecall;
    function Get_upPWordExpiryMode: TPasswordExpiryType; safecall;
    function Get_upPWordExpiryDays: Integer; safecall;
    function Get_upPWordExpiryDate: WideString; safecall;
    function Get_upLockOutMins: Integer; safecall;
    function Get_upEmail: WideString; safecall;
    function Get_upDefSRICust: WideString; safecall;
    function Get_upDefPPISupp: WideString; safecall;
    function Get_upMaxSalesAuth: Double; safecall;
    function Get_upMaxPurchAuth: Double; safecall;
    function Get_upDefSalesBankGL: Integer; safecall;
    function Get_upDefPurchBankGL: Integer; safecall;
    function Get_upReportPrinter: WideString; safecall;
    function Get_upFormPrinter: WideString; safecall;
    function Get_upEmailSignature: WideString; safecall;
    function Get_upFaxSignature: WideString; safecall;
    function Get_upCCDeptRule: TPriorityRuleType; safecall;
    function Get_upDefCostCentre: WideString; safecall;
    function Get_upDefDepartment: WideString; safecall;
    function Get_upDefLocation: WideString; safecall;
    function Get_upDefLocRule: TPriorityRuleType; safecall;
    function Get_upSecurityFlags(Index: Integer): TSecurityResultType; safecall;
    property Index: TUserIndexType read Get_Index write Set_Index;
    property Position: Integer read Get_Position write Set_Position;
    property KeyString: WideString read Get_KeyString;
    property upUserID: WideString read Get_upUserID;
    property upName: WideString read Get_upName;
    property upPWordExpiryMode: TPasswordExpiryType read Get_upPWordExpiryMode;
    property upPWordExpiryDays: Integer read Get_upPWordExpiryDays;
    property upPWordExpiryDate: WideString read Get_upPWordExpiryDate;
    property upLockOutMins: Integer read Get_upLockOutMins;
    property upEmail: WideString read Get_upEmail;
    property upDefSRICust: WideString read Get_upDefSRICust;
    property upDefPPISupp: WideString read Get_upDefPPISupp;
    property upMaxSalesAuth: Double read Get_upMaxSalesAuth;
    property upMaxPurchAuth: Double read Get_upMaxPurchAuth;
    property upDefSalesBankGL: Integer read Get_upDefSalesBankGL;
    property upDefPurchBankGL: Integer read Get_upDefPurchBankGL;
    property upReportPrinter: WideString read Get_upReportPrinter;
    property upFormPrinter: WideString read Get_upFormPrinter;
    property upEmailSignature: WideString read Get_upEmailSignature;
    property upFaxSignature: WideString read Get_upFaxSignature;
    property upCCDeptRule: TPriorityRuleType read Get_upCCDeptRule;
    property upDefCostCentre: WideString read Get_upDefCostCentre;
    property upDefDepartment: WideString read Get_upDefDepartment;
    property upDefLocation: WideString read Get_upDefLocation;
    property upDefLocRule: TPriorityRuleType read Get_upDefLocRule;
    property upSecurityFlags[Index: Integer]: TSecurityResultType read Get_upSecurityFlags;
  end;

// *********************************************************************//
// DispIntf:  IUserProfileDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AD907C7D-C3D8-40BD-9D9B-CCE19F1E0558}
// *********************************************************************//
  IUserProfileDisp = dispinterface
    ['{AD907C7D-C3D8-40BD-9D9B-CCE19F1E0558}']
    property Index: TUserIndexType dispid 20;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    function BuildUserIDIndex(const UserID: WideString): WideString; dispid 21;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    property KeyString: WideString readonly dispid 16777222;
    property upUserID: WideString readonly dispid 1;
    property upName: WideString readonly dispid 2;
    property upPWordExpiryMode: TPasswordExpiryType readonly dispid 4;
    property upPWordExpiryDays: Integer readonly dispid 5;
    property upPWordExpiryDate: WideString readonly dispid 6;
    property upLockOutMins: Integer readonly dispid 7;
    property upEmail: WideString readonly dispid 8;
    property upDefSRICust: WideString readonly dispid 26;
    property upDefPPISupp: WideString readonly dispid 27;
    property upMaxSalesAuth: Double readonly dispid 28;
    property upMaxPurchAuth: Double readonly dispid 29;
    property upDefSalesBankGL: Integer readonly dispid 30;
    property upDefPurchBankGL: Integer readonly dispid 31;
    property upReportPrinter: WideString readonly dispid 32;
    property upFormPrinter: WideString readonly dispid 33;
    property upEmailSignature: WideString readonly dispid 34;
    property upFaxSignature: WideString readonly dispid 35;
    property upCCDeptRule: TPriorityRuleType readonly dispid 36;
    property upDefCostCentre: WideString readonly dispid 37;
    property upDefDepartment: WideString readonly dispid 38;
    property upDefLocation: WideString readonly dispid 39;
    property upDefLocRule: TPriorityRuleType readonly dispid 40;
    property upSecurityFlags[Index: Integer]: TSecurityResultType readonly dispid 41;
  end;

// *********************************************************************//
// Interface: IToolkit2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B52C7B92-50E3-4602-9B8C-0F6E05622304}
// *********************************************************************//
  IToolkit2 = interface(IToolkit)
    ['{B52C7B92-50E3-4602-9B8C-0F6E05622304}']
    function Get_UserProfile: IUserProfile; safecall;
    function Get_TransactionDetails: ITransactionDetails; safecall;
    function Get_SystemProcesses: ISystemProcesses; safecall;
    property UserProfile: IUserProfile read Get_UserProfile;
    property TransactionDetails: ITransactionDetails read Get_TransactionDetails;
    property SystemProcesses: ISystemProcesses read Get_SystemProcesses;
  end;

// *********************************************************************//
// DispIntf:  IToolkit2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B52C7B92-50E3-4602-9B8C-0F6E05622304}
// *********************************************************************//
  IToolkit2Disp = dispinterface
    ['{B52C7B92-50E3-4602-9B8C-0F6E05622304}']
    property UserProfile: IUserProfile readonly dispid 21;
    property TransactionDetails: ITransactionDetails readonly dispid 22;
    property SystemProcesses: ISystemProcesses readonly dispid 23;
    function CloseToolkit: Integer; dispid 1;
    property Company: ICompanyManager readonly dispid 2;
    property Configuration: IConfiguration readonly dispid 3;
    property CostCentre: ICCDept readonly dispid 4;
    property Customer: IAccount readonly dispid 5;
    property Department: ICCDept readonly dispid 6;
    property eBusiness: IEBusiness readonly dispid 7;
    property Enterprise: IEnterprise readonly dispid 8;
    property Functions: IFunctions readonly dispid 9;
    property GeneralLedger: IGeneralLedger readonly dispid 10;
    property JobCosting: IJobCosting readonly dispid 11;
    property LastErrorString: WideString readonly dispid 12;
    property Location: ILocation readonly dispid 13;
    function OpenToolkit: Integer; dispid 14;
    property Status: TToolkitStatus readonly dispid 15;
    property Stock: IStock readonly dispid 16;
    property Supplier: IAccount readonly dispid 17;
    property SystemSetup: ISystemSetup readonly dispid 18;
    property Transaction: ITransaction readonly dispid 19;
    property Version: WideString readonly dispid 20;
  end;

// *********************************************************************//
// Interface: ITransactionDetails
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F91F7E18-641C-4600-A4C2-18D756559BD4}
// *********************************************************************//
  ITransactionDetails = interface(ITransactionLine)
    ['{F91F7E18-641C-4600-A4C2-18D756559BD4}']
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function StepFirst: Integer; safecall;
    function StepPrevious: Integer; safecall;
    function StepNext: Integer; safecall;
    function StepLast: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function BuildPostRunNoIndex(RunNo: Integer; NomCode: Integer): WideString; safecall;
    function BuildNomCodeIndex(NomCode: Integer; NomMode: TNominalModeType; Currency: Integer; 
                               Year: Integer; Period: Integer; PostRun: Integer): WideString; safecall;
    function BuildStockCodeIndex(const StockCode: WideString): WideString; safecall;
    function BuildLineClassIndex(const LineType: WideString; const StockCode: WideString; 
                                 const LineDate: WideString): WideString; safecall;
    function BuildFolioIndex(FolioNo: Integer; LineNo: Integer): WideString; safecall;
    function BuildFolioAbsLineNoIndex(Folio: Integer; AbsLineNo: Integer): WideString; safecall;
    function BuildLineClassAcIndex(const LineClass: WideString; const acCode: WideString; 
                                   const StockCode: WideString; const LineDate: WideString): WideString; safecall;
    function BuildReconcileIndex(NomCode: Integer; NomMode: TNominalModeType; 
                                 Reconcile: TReconcileStatusType; Currency: Integer; Year: Integer; 
                                 Period: Integer): WideString; safecall;
    function Get_Index: TTransactionDetailIndex; safecall;
    procedure Set_Index(Value: TTransactionDetailIndex); safecall;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
    property Index: TTransactionDetailIndex read Get_Index write Set_Index;
  end;

// *********************************************************************//
// DispIntf:  ITransactionDetailsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F91F7E18-641C-4600-A4C2-18D756559BD4}
// *********************************************************************//
  ITransactionDetailsDisp = dispinterface
    ['{F91F7E18-641C-4600-A4C2-18D756559BD4}']
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function StepFirst: Integer; dispid 16777233;
    function StepPrevious: Integer; dispid 16777234;
    function StepNext: Integer; dispid 16777235;
    function StepLast: Integer; dispid 16777236;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    function BuildPostRunNoIndex(RunNo: Integer; NomCode: Integer): WideString; dispid 61;
    function BuildNomCodeIndex(NomCode: Integer; NomMode: TNominalModeType; Currency: Integer; 
                               Year: Integer; Period: Integer; PostRun: Integer): WideString; dispid 62;
    function BuildStockCodeIndex(const StockCode: WideString): WideString; dispid 63;
    function BuildLineClassIndex(const LineType: WideString; const StockCode: WideString; 
                                 const LineDate: WideString): WideString; dispid 64;
    function BuildFolioIndex(FolioNo: Integer; LineNo: Integer): WideString; dispid 65;
    function BuildFolioAbsLineNoIndex(Folio: Integer; AbsLineNo: Integer): WideString; dispid 67;
    function BuildLineClassAcIndex(const LineClass: WideString; const acCode: WideString; 
                                   const StockCode: WideString; const LineDate: WideString): WideString; dispid 69;
    function BuildReconcileIndex(NomCode: Integer; NomMode: TNominalModeType; 
                                 Reconcile: TReconcileStatusType; Currency: Integer; Year: Integer; 
                                 Period: Integer): WideString; dispid 70;
    property Index: TTransactionDetailIndex dispid 66;
    property tlLineNo: Integer dispid 1;
    property tlGLCode: Integer dispid 2;
    property tlCurrency: Integer dispid 3;
    property tlCompanyRate: Double dispid 4;
    property tlDailyRate: Double dispid 51;
    property tlCostCentre: WideString dispid 6;
    property tlDepartment: WideString dispid 7;
    property tlStockCode: WideString dispid 8;
    property tlQty: Double dispid 9;
    property tlQtyMul: Double dispid 10;
    property tlNetValue: Double dispid 11;
    property tlDiscount: Double dispid 12;
    property tlDiscFlag: WideString dispid 13;
    property tlVATCode: WideString dispid 14;
    property tlVATAmount: Double dispid 15;
    property tlPayment: WordBool dispid 16;
    property tlQtyWOFF: Double dispid 17;
    property tlQtyDel: Double dispid 18;
    property tlCost: Double dispid 19;
    property tlLineDate: WideString dispid 20;
    property tlItemNo: WideString dispid 21;
    property tlDescr: WideString dispid 22;
    property tlJobCode: WideString dispid 23;
    property tlAnalysisCode: WideString dispid 24;
    property tlUnitWeight: Double dispid 25;
    property tlLocation: WideString dispid 26;
    property tlChargeCurrency: Integer dispid 27;
    property tlAcCode: WideString readonly dispid 28;
    property tlLineType: TTransactionLineType dispid 29;
    property tlFolioNum: Integer readonly dispid 30;
    property tlLineClass: WideString readonly dispid 31;
    property tlRecStatus: Smallint dispid 32;
    property tlSOPFolioNum: Integer dispid 33;
    property tlSOPABSLineNo: Integer dispid 34;
    property tlABSLineNo: Integer readonly dispid 35;
    property tlUserField1: WideString dispid 36;
    property tlUserField2: WideString dispid 37;
    property tlUserField3: WideString dispid 38;
    property tlUserField4: WideString dispid 39;
    property tlSSDUpliftPerc: Double dispid 40;
    property tlSSDCommodCode: WideString dispid 41;
    property tlSSDSalesUnit: Double dispid 42;
    property tlSSDUseLineValues: WordBool dispid 43;
    property tlPriceMultiplier: Double dispid 44;
    property tlQtyPicked: Double dispid 45;
    property tlQtyPickedWO: Double dispid 46;
    property tlSSDCountry: WideString dispid 47;
    property tlInclusiveVATCode: WideString dispid 48;
    property tlBOMKitLink: Integer dispid 49;
    property tlOurRef: WideString readonly dispid 5;
    function entLineTotal(ApplyDiscounts: WordBool; SettleDiscPerc: Double): Double; dispid 50;
    procedure Save; dispid 54;
    procedure Cancel; dispid 52;
    function entDefaultVATCode(const AccountVATCode: WideString; const StockVATCode: WideString): WideString; dispid 53;
    procedure CalcVATAmount; dispid 55;
    procedure CalcStockPrice; dispid 56;
    property tlStockCodeI: IStock readonly dispid 57;
    procedure ImportDefaults; dispid 68;
    property tlAnalyisCodeI: IJobAnalysis readonly dispid 58;
    property tlJobCodeI: IJob readonly dispid 59;
    property tlSerialBatch: ITransactionLineSerialBatch readonly dispid 60;
  end;

// *********************************************************************//
// Interface: ISystemSetupUserFields2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF7BDC08-BFC4-499B-AA0A-185E16A7280D}
// *********************************************************************//
  ISystemSetupUserFields2 = interface(ISystemSetupUserFields)
    ['{AF7BDC08-BFC4-499B-AA0A-185E16A7280D}']
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
    function Get_usSRCEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufSRCLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufSRCLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufStockDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufSuppDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufTSHDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufTSHEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufTSHLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufTSHLineDescEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufWORDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufWOREnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    function Get_ufWORLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
    function Get_ufWORLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
    property ufADJDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufADJDesc;
    property ufADJEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufADJEnabled;
    property ufADJLineDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufADJLineDesc;
    property ufADJLineEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufADJLineEnabled;
    property ufCustDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufCustDesc;
    property ufEmployeeDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufEmployeeDesc;
    property ufJobDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufJobDesc;
    property ufLineTypeDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufLineTypeDesc;
    property ufNOMDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufNOMDesc;
    property ufNOMEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufNOMEnabled;
    property ufNOMLineDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufNOMLineDesc;
    property ufNOMLineEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufNOMLineEnabled;
    property ufPINDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufPINDesc;
    property ufPINEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufPINEnabled;
    property ufPINLineDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufPINLineDesc;
    property ufPINLineEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufPINLineEnabled;
    property ufPORDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufPORDesc;
    property ufPOREnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufPOREnabled;
    property ufPORLineDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufPORLineDesc;
    property ufPORLineEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufPORLineEnabled;
    property ufPPYDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufPPYDesc;
    property ufPPYEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufPPYEnabled;
    property ufPPYLineDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufPPYLineDesc;
    property ufPPYLineEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufPPYLineEnabled;
    property ufPQUDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufPQUDesc;
    property ufPQUEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufPQUEnabled;
    property ufPQULineDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufPQULineDesc;
    property ufPQULineEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufPQULineEnabled;
    property ufSINDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufSINDesc;
    property ufSINEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufSINEnabled;
    property ufSINLineDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufSINLineDesc;
    property ufSINLineEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufSINLineEnabled;
    property ufSORDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufSORDesc;
    property ufSOREnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufSOREnabled;
    property ufSORLineDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufSORLineDesc;
    property ufSORLineEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufSORLineEnabled;
    property ufSQUDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufSQUDesc;
    property ufSQUEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufSQUEnabled;
    property ufSQULineDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufSQULineDesc;
    property ufSQULineEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufSQULineEnabled;
    property ufSRCDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufSRCDesc;
    property usSRCEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_usSRCEnabled;
    property ufSRCLineDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufSRCLineDesc;
    property ufSRCLineEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufSRCLineEnabled;
    property ufStockDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufStockDesc;
    property ufSuppDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufSuppDesc;
    property ufTSHDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufTSHDesc;
    property ufTSHEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufTSHEnabled;
    property ufTSHLineDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufTSHLineDesc;
    property ufTSHLineDescEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufTSHLineDescEnabled;
    property ufWORDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufWORDesc;
    property ufWOREnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufWOREnabled;
    property ufWORLineDesc[Index: TUserDefinedFieldNo]: WideString read Get_ufWORLineDesc;
    property ufWORLineEnabled[Index: TUserDefinedFieldNo]: WordBool read Get_ufWORLineEnabled;
  end;

// *********************************************************************//
// DispIntf:  ISystemSetupUserFields2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF7BDC08-BFC4-499B-AA0A-185E16A7280D}
// *********************************************************************//
  ISystemSetupUserFields2Disp = dispinterface
    ['{AF7BDC08-BFC4-499B-AA0A-185E16A7280D}']
    property ufADJDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 19;
    property ufADJEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 36;
    property ufADJLineDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 37;
    property ufADJLineEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 38;
    property ufCustDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 39;
    property ufEmployeeDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 40;
    property ufJobDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 41;
    property ufLineTypeDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 42;
    property ufNOMDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 43;
    property ufNOMEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 44;
    property ufNOMLineDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 45;
    property ufNOMLineEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 46;
    property ufPINDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 47;
    property ufPINEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 48;
    property ufPINLineDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 49;
    property ufPINLineEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 50;
    property ufPORDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 51;
    property ufPOREnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 52;
    property ufPORLineDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 53;
    property ufPORLineEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 54;
    property ufPPYDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 55;
    property ufPPYEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 56;
    property ufPPYLineDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 57;
    property ufPPYLineEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 58;
    property ufPQUDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 59;
    property ufPQUEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 60;
    property ufPQULineDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 61;
    property ufPQULineEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 62;
    property ufSINDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 63;
    property ufSINEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 64;
    property ufSINLineDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 65;
    property ufSINLineEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 66;
    property ufSORDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 67;
    property ufSOREnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 68;
    property ufSORLineDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 69;
    property ufSORLineEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 70;
    property ufSQUDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 71;
    property ufSQUEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 72;
    property ufSQULineDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 73;
    property ufSQULineEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 74;
    property ufSRCDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 75;
    property usSRCEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 76;
    property ufSRCLineDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 77;
    property ufSRCLineEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 78;
    property ufStockDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 79;
    property ufSuppDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 80;
    property ufTSHDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 81;
    property ufTSHEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 82;
    property ufTSHLineDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 83;
    property ufTSHLineDescEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 84;
    property ufWORDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 85;
    property ufWOREnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 86;
    property ufWORLineDesc[Index: TUserDefinedFieldNo]: WideString readonly dispid 87;
    property ufWORLineEnabled[Index: TUserDefinedFieldNo]: WordBool readonly dispid 88;
    property ufAccount1: WideString readonly dispid 1;
    property ufAccount2: WideString readonly dispid 2;
    property ufAccount3: WideString readonly dispid 3;
    property ufAccount4: WideString readonly dispid 4;
    property ufTrans1: WideString readonly dispid 5;
    property ufTrans2: WideString readonly dispid 6;
    property ufTrans3: WideString readonly dispid 7;
    property ufTrans4: WideString readonly dispid 8;
    property ufStock1: WideString readonly dispid 9;
    property ufStock2: WideString readonly dispid 10;
    property ufStock3: WideString readonly dispid 11;
    property ufStock4: WideString readonly dispid 12;
    property ufLine1: WideString readonly dispid 13;
    property ufLine2: WideString readonly dispid 14;
    property ufLine3: WideString readonly dispid 15;
    property ufLine4: WideString readonly dispid 16;
    property ufJob1: WideString readonly dispid 17;
    property ufJob2: WideString readonly dispid 18;
    property ufTrans1Enabled: WordBool readonly dispid 20;
    property ufTrans2Enabled: WordBool readonly dispid 21;
    property ufTrans3Enabled: WordBool readonly dispid 22;
    property ufTrans4Enabled: WordBool readonly dispid 23;
    property ufLine1Enabled: WordBool readonly dispid 24;
    property ufLine2Enabled: WordBool readonly dispid 25;
    property ufLine3Enabled: WordBool readonly dispid 26;
    property ufLine4Enabled: WordBool readonly dispid 27;
    property ufLineType1: WideString readonly dispid 28;
    property ufLineType2: WideString readonly dispid 29;
    property ufLineType3: WideString readonly dispid 30;
    property ufLineType4: WideString readonly dispid 31;
    property ufLineType1Enabled: WordBool readonly dispid 32;
    property ufLineType2Enabled: WordBool readonly dispid 33;
    property ufLineType3Enabled: WordBool readonly dispid 34;
    property ufLineType4Enabled: WordBool readonly dispid 35;
  end;

// *********************************************************************//
// Interface: ISystemSetup2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {712B8CB0-9B76-415C-AE26-A5A60F987C49}
// *********************************************************************//
  ISystemSetup2 = interface(ISystemSetup)
    ['{712B8CB0-9B76-415C-AE26-A5A60F987C49}']
    function Get_ssWOPDisableWIP: WordBool; safecall;
    function Get_ssWORAllocStockOnPick: WordBool; safecall;
    function Get_ssWORCopyStkNotes: TWOPStockNotesType; safecall;
    function Get_ssFormDefinitionSet: ISystemSetupFormDefinitionSet; safecall;
    property ssWOPDisableWIP: WordBool read Get_ssWOPDisableWIP;
    property ssWORAllocStockOnPick: WordBool read Get_ssWORAllocStockOnPick;
    property ssWORCopyStkNotes: TWOPStockNotesType read Get_ssWORCopyStkNotes;
    property ssFormDefinitionSet: ISystemSetupFormDefinitionSet read Get_ssFormDefinitionSet;
  end;

// *********************************************************************//
// DispIntf:  ISystemSetup2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {712B8CB0-9B76-415C-AE26-A5A60F987C49}
// *********************************************************************//
  ISystemSetup2Disp = dispinterface
    ['{712B8CB0-9B76-415C-AE26-A5A60F987C49}']
    property ssWOPDisableWIP: WordBool readonly dispid 109;
    property ssWORAllocStockOnPick: WordBool readonly dispid 110;
    property ssWORCopyStkNotes: TWOPStockNotesType readonly dispid 111;
    property ssFormDefinitionSet: ISystemSetupFormDefinitionSet readonly dispid 114;
    property ssPeriodsInYear: Smallint readonly dispid 1;
    property ssCompanyName: WideString readonly dispid 2;
    property ssLastAuditYr: Smallint readonly dispid 3;
    property ssManUpdReorderCost: WordBool readonly dispid 4;
    property ssVATReturnCurrency: Smallint readonly dispid 5;
    property ssCostDecimals: Smallint readonly dispid 6;
    property ssShowStkPriceAsMargin: WordBool readonly dispid 8;
    property ssLiveStockCOSVal: WordBool readonly dispid 9;
    property ssSDNShowPickedOnly: WordBool readonly dispid 10;
    property ssUseLocations: WordBool readonly dispid 11;
    property ssSetBOMSerNo: WordBool readonly dispid 12;
    property ssWarnDupliYourRef: WordBool readonly dispid 13;
    property ssUseLocDelAddress: WordBool readonly dispid 14;
    property ssBudgetByCCDept: WordBool readonly dispid 15;
    property ssCurrencyTolerance: Double readonly dispid 16;
    property ssCurrencyToleranceMode: Smallint readonly dispid 17;
    property ssDebtChaseMode: Smallint readonly dispid 18;
    property ssAutoGenVariance: WordBool readonly dispid 19;
    property ssAutoGenDisc: WordBool readonly dispid 20;
    property ssCompanyCountryCode: WideString readonly dispid 21;
    property ssSalesDecimals: Smallint readonly dispid 22;
    property ssDebtChaseOverdue: Smallint readonly dispid 24;
    property ssCurrentPeriod: Smallint readonly dispid 25;
    property ssCurrentYear: Smallint readonly dispid 26;
    property ssTradeTerm: WordBool readonly dispid 27;
    property ssSeparateCurrencyStatements: WordBool readonly dispid 28;
    property ssStatementAgingMethod: Smallint readonly dispid 29;
    property ssStatementUseInvoiceDate: WordBool readonly dispid 30;
    property ssQuotesAllocateStock: WordBool readonly dispid 31;
    property ssDeductBOMComponents: WordBool readonly dispid 32;
    property ssAuthorisationMethod: WideString readonly dispid 33;
    property ssUseIntrastat: WordBool readonly dispid 34;
    property ssAnalyseDescOnly: WordBool readonly dispid 35;
    property ssDefaultStockValMethod: WideString readonly dispid 36;
    property ssDisplayUpdateCosts: WordBool readonly dispid 37;
    property ssAutoChequeNo: WordBool readonly dispid 38;
    property ssStatementIncNotDue: WordBool readonly dispid 39;
    property ssForceBatchTotalBalancing: WordBool readonly dispid 40;
    property ssDisplayStockLevelWarning: WordBool readonly dispid 41;
    property ssStatementNoteEntry: WordBool readonly dispid 42;
    property ssHideMenuOpt: WordBool readonly dispid 43;
    property ssUseCCDept: WordBool readonly dispid 44;
    property ssHoldSettlementDiscTransactions: WordBool readonly dispid 45;
    property ssSetTransPeriodByDate: WordBool readonly dispid 46;
    property ssStopOverCreditLimit: WordBool readonly dispid 47;
    property ssUseSRCPayInRef: WordBool readonly dispid 48;
    property ssUsePasswords: WordBool readonly dispid 49;
    property ssPromptToPrintReciept: WordBool readonly dispid 50;
    property ssExternalCustomers: WordBool readonly dispid 51;
    property ssQtyDecimals: Smallint readonly dispid 52;
    property ssExternalSINEntry: WordBool readonly dispid 53;
    property ssDisablePostingToPreviousPeriods: WordBool readonly dispid 54;
    property ssPercDiscounts: WordBool readonly dispid 55;
    property ssNumericAccountCodes: WordBool readonly dispid 56;
    property ssUpdateBalanceOnPosting: WordBool readonly dispid 57;
    property ssShowInvoiceDisc: WordBool readonly dispid 58;
    property ssSplitDiscountsInGL: WordBool readonly dispid 59;
    property ssDoCreditStatusCheck: WordBool readonly dispid 60;
    property ssDoCreditLimitCheck: WordBool readonly dispid 61;
    property ssAutoClearPayments: WordBool readonly dispid 62;
    property ssCurrencyRateType: TCurrencyRateType readonly dispid 63;
    property ssShowPeriodsAsMonths: WordBool readonly dispid 64;
    property ssDirectCustomer: WideString readonly dispid 65;
    property ssDirectSupplier: WideString readonly dispid 66;
    property ssSettlementDiscount: Double readonly dispid 69;
    property ssSettlementDays: Smallint readonly dispid 70;
    property ssNeedBOMCostingUpdate: WordBool readonly dispid 71;
    property ssInputPackQtyOnLine: WordBool readonly dispid 72;
    property ssDefaultVATCode: WideString readonly dispid 73;
    property ssPaymentTerms: Smallint readonly dispid 74;
    property ssStatementAgeingInterval: Smallint readonly dispid 75;
    property ssKeepQuoteDate: WordBool readonly dispid 76;
    property ssFreeStockExcludesSOR: WordBool readonly dispid 77;
    property ssSeparateDirectTransCounter: WordBool readonly dispid 78;
    property ssStatementShowMatchedInMonth: WordBool readonly dispid 79;
    property ssLiveOldestDebt: WordBool readonly dispid 80;
    property ssBatchPPY: WordBool readonly dispid 81;
    property ssDefaultBankGL: Integer readonly dispid 83;
    property ssUseDefaultBankAccount: WordBool readonly dispid 84;
    property ssYearStartDate: WideString readonly dispid 85;
    property ssLastAuditDate: WideString readonly dispid 86;
    property ssBankSortCode: WideString readonly dispid 87;
    property ssBankAccountNo: WideString readonly dispid 88;
    property ssBankAccountRef: WideString readonly dispid 89;
    property ssBankName: WideString readonly dispid 90;
    property ssCompanyPhone: WideString readonly dispid 92;
    property ssCompanyFax: WideString readonly dispid 93;
    property ssCompanyVATRegNo: WideString readonly dispid 94;
    property ssCompanyAddress[Index: Integer]: WideString readonly dispid 96;
    property ssGLCtrlCodes[Index: TSystemSetupGLCtrlType]: Integer readonly dispid 97;
    property ssDebtChaseDays[Index: Integer]: Smallint readonly dispid 98;
    property ssTermsofTrade[Index: Integer]: WideString readonly dispid 99;
    property ssVATRates[const Index: WideString]: ISystemSetupVAT readonly dispid 95;
    property ssCurrency[Index: Integer]: ISystemSetupCurrency readonly dispid 100;
    property ssUserFields: ISystemSetupUserFields readonly dispid 101;
    property ssPickingOrderAllocatesStock: WordBool readonly dispid 102;
    property ssReleaseCodes: ISystemSetupReleaseCodes readonly dispid 103;
    property ssDocumentNumbers[const DocType: WideString]: Integer readonly dispid 104;
    property ssCurrencyVersion: TEnterpriseCurrencyVersion readonly dispid 7;
    property ssMaxCurrency: Integer readonly dispid 23;
    procedure Refresh; dispid 67;
    property ssUseDosKeys: WordBool readonly dispid 91;
    property ssHideEnterpriseLogo: WordBool readonly dispid 105;
    property ssConserveMemory: WordBool readonly dispid 106;
    property ssProtectYourRef: WordBool readonly dispid 107;
    property ssSDNDateIsTaxPointDate: WordBool readonly dispid 108;
    property ssAutoPostUplift: WordBool readonly dispid 112;
    property ssJobCosting: ISystemSetupJob readonly dispid 113;
    property ssPaperless: ISystemSetupPaperless readonly dispid 68;
    property ssTaxWord: WideString readonly dispid 82;
  end;

// *********************************************************************//
// Interface: ISystemSetupPaperless2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1AC29FCE-0BDF-4F59-890C-1123DDCF8521}
// *********************************************************************//
  ISystemSetupPaperless2 = interface(ISystemSetupPaperless)
    ['{1AC29FCE-0BDF-4F59-890C-1123DDCF8521}']
    function Get_ssCompanyEmailSignature: WideString; safecall;
    function Get_ssCompanyFaxSignature: WideString; safecall;
    property ssCompanyEmailSignature: WideString read Get_ssCompanyEmailSignature;
    property ssCompanyFaxSignature: WideString read Get_ssCompanyFaxSignature;
  end;

// *********************************************************************//
// DispIntf:  ISystemSetupPaperless2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1AC29FCE-0BDF-4F59-890C-1123DDCF8521}
// *********************************************************************//
  ISystemSetupPaperless2Disp = dispinterface
    ['{1AC29FCE-0BDF-4F59-890C-1123DDCF8521}']
    property ssCompanyEmailSignature: WideString readonly dispid 11;
    property ssCompanyFaxSignature: WideString readonly dispid 12;
    property ssYourEmailName: WideString readonly dispid 1;
    property ssYourEmailAddress: WideString readonly dispid 2;
    property ssSMTPServer: WideString readonly dispid 3;
    property ssDefaultEmailPriority: TEmailPriority readonly dispid 4;
    property ssEmailUseMAPI: WordBool readonly dispid 5;
    property ssAttachMethod: TEmailAttachMethod readonly dispid 6;
    property ssFaxFromName: WideString readonly dispid 7;
    property ssFaxFromTelNo: WideString readonly dispid 8;
    property ssFaxInterfacePath: WideString readonly dispid 9;
    property ssFaxUsing: TFaxMethod readonly dispid 10;
  end;

// *********************************************************************//
// Interface: ISystemSetupFormDefinitionSet
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EB635BB7-E282-4A94-B2EC-1C7630E922BF}
// *********************************************************************//
  ISystemSetupFormDefinitionSet = interface(IDispatch)
    ['{EB635BB7-E282-4A94-B2EC-1C7630E922BF}']
    function Get_fdNumber: Byte; safecall;
    function Get_fdDescription: WideString; safecall;
    function Get_fdForms(Index: TFormDefinitionType): WideString; safecall;
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_KeyString: WideString; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function BuildNumberIndex(Number: Integer): WideString; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    property fdNumber: Byte read Get_fdNumber;
    property fdDescription: WideString read Get_fdDescription;
    property fdForms[Index: TFormDefinitionType]: WideString read Get_fdForms;
    property KeyString: WideString read Get_KeyString;
    property Position: Integer read Get_Position write Set_Position;
  end;

// *********************************************************************//
// DispIntf:  ISystemSetupFormDefinitionSetDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EB635BB7-E282-4A94-B2EC-1C7630E922BF}
// *********************************************************************//
  ISystemSetupFormDefinitionSetDisp = dispinterface
    ['{EB635BB7-E282-4A94-B2EC-1C7630E922BF}']
    property fdNumber: Byte readonly dispid 1;
    property fdDescription: WideString readonly dispid 2;
    property fdForms[Index: TFormDefinitionType]: WideString readonly dispid 27;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function BuildNumberIndex(Number: Integer): WideString; dispid 3;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
  end;

// *********************************************************************//
// Interface: ITransaction2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EB5E465C-E90B-4D7C-BF3F-EA1B3A398C84}
// *********************************************************************//
  ITransaction2 = interface(ITransaction)
    ['{EB5E465C-E90B-4D7C-BF3F-EA1B3A398C84}']
    function Print: IPrintJob; safecall;
    function Get_thAsNOM: ITransactionAsNOM; safecall;
    function Get_thAsTSH: ITransactionAsTSH; safecall;
    function Get_thAsADJ: ITransactionAsADJ; safecall;
    function Get_thAsWOR: ITransactionAsWOR; safecall;
    function Get_thLinks: ILinks; safecall;
    function Get_thAutoSettings: IAutoTransactionSettings; safecall;
    function Copy: ITransaction2; safecall;
    function Reverse: ITransaction2; safecall;
    function Convert(DestDocType: TDocTypes): ISingleConvert; safecall;
    function Get_thBackToBackOrder: IBackToBackOrder; safecall;
    function Get_thAsBatch: ITransactionAsBatch; safecall;
    property thAsNOM: ITransactionAsNOM read Get_thAsNOM;
    property thAsTSH: ITransactionAsTSH read Get_thAsTSH;
    property thAsADJ: ITransactionAsADJ read Get_thAsADJ;
    property thAsWOR: ITransactionAsWOR read Get_thAsWOR;
    property thLinks: ILinks read Get_thLinks;
    property thAutoSettings: IAutoTransactionSettings read Get_thAutoSettings;
    property thBackToBackOrder: IBackToBackOrder read Get_thBackToBackOrder;
    property thAsBatch: ITransactionAsBatch read Get_thAsBatch;
  end;

// *********************************************************************//
// DispIntf:  ITransaction2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EB5E465C-E90B-4D7C-BF3F-EA1B3A398C84}
// *********************************************************************//
  ITransaction2Disp = dispinterface
    ['{EB5E465C-E90B-4D7C-BF3F-EA1B3A398C84}']
    function Print: IPrintJob; dispid 83;
    property thAsNOM: ITransactionAsNOM readonly dispid 84;
    property thAsTSH: ITransactionAsTSH readonly dispid 85;
    property thAsADJ: ITransactionAsADJ readonly dispid 86;
    property thAsWOR: ITransactionAsWOR readonly dispid 87;
    property thLinks: ILinks readonly dispid 88;
    property thAutoSettings: IAutoTransactionSettings readonly dispid 89;
    function Copy: ITransaction2; dispid 90;
    function Reverse: ITransaction2; dispid 91;
    function Convert(DestDocType: TDocTypes): ISingleConvert; dispid 92;
    property thBackToBackOrder: IBackToBackOrder readonly dispid 93;
    property thAsBatch: ITransactionAsBatch readonly dispid 94;
    property thOurRef: WideString dispid 1;
    property thYourRef: WideString dispid 2;
    property thAcCode: WideString dispid 3;
    property thRunNo: Integer readonly dispid 4;
    property thFolioNum: Integer dispid 5;
    property thCurrency: Smallint dispid 6;
    property thYear: Smallint dispid 7;
    property thPeriod: Smallint dispid 8;
    property thTransDate: WideString dispid 9;
    property thDueDate: WideString dispid 10;
    property thCompanyRate: Double dispid 11;
    property thDailyRate: Double dispid 12;
    property thDocType: TDocTypes readonly dispid 13;
    property thVATAnalysis[const Index: WideString]: Double dispid 14;
    property thNetValue: Double dispid 15;
    property thTotalVAT: Double dispid 16;
    property thSettleDiscPerc: Double dispid 17;
    property thSettleDiscAmount: Double dispid 18;
    property thTotalLineDiscount: Double dispid 19;
    property thSettleDiscDays: Smallint dispid 20;
    property thSettleDiscTaken: WordBool dispid 21;
    property thAmountSettled: Double readonly dispid 22;
    property thTransportNature: Smallint dispid 23;
    property thTransportMode: Smallint dispid 24;
    property thHoldFlag: Smallint dispid 25;
    property thTotalWeight: Double dispid 26;
    property thDelAddress: IAddress readonly dispid 27;
    property thTotalCost: Double dispid 28;
    property thPrinted: WordBool readonly dispid 29;
    property thManualVAT: WordBool dispid 30;
    property thDeliveryTerms: WideString dispid 31;
    property thOperator: WideString dispid 32;
    property thJobCode: WideString dispid 33;
    property thAnalysisCode: WideString dispid 34;
    property thTotalOrderOS: Double dispid 35;
    property thUserField1: WideString dispid 36;
    property thUserField2: WideString dispid 37;
    property thUserField3: WideString dispid 38;
    property thUserField4: WideString dispid 39;
    property thTagged: WordBool dispid 40;
    property thNoLabels: Smallint dispid 41;
    property thControlGL: Integer dispid 42;
    property thProcess: TIntrastatProcess dispid 43;
    property thSource: Integer readonly dispid 44;
    property thPostedDate: WideString readonly dispid 45;
    property thPORPickSOR: WordBool dispid 46;
    property thBatchDiscAmount: Double dispid 47;
    property thPrePost: Integer dispid 48;
    property thOutstanding: WideString readonly dispid 49;
    property thFixedRate: WordBool dispid 50;
    property thLongYourRef: WideString dispid 51;
    property thAcCodeI: IAccount readonly dispid 52;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property Index: TTransactionIndex dispid 16777221;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function StepFirst: Integer; dispid 16777233;
    function StepPrevious: Integer; dispid 16777234;
    function StepNext: Integer; dispid 16777235;
    function StepLast: Integer; dispid 16777236;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    property thLines: ITransactionLines readonly dispid 53;
    property thGoodsAnalysis[const Index: WideString]: Double readonly dispid 55;
    property thLineTypeAnalysis[Index: Integer]: Double readonly dispid 56;
    function entCanUpdate: WordBool; dispid 57;
    function Add(TransactionType: TDocTypes): ITransaction; dispid 58;
    function Update: ITransaction; dispid 59;
    function Save(CalculateTotals: WordBool): Integer; dispid 60;
    procedure Cancel; dispid 61;
    function Clone: ITransaction; dispid 62;
    property SaveErrorLine: Integer readonly dispid 63;
    function BuildOurRefIndex(const OurRef: WideString): WideString; dispid 64;
    function BuildFolioIndex(Folio: Integer): WideString; dispid 65;
    function BuildAccountIndex(const AccountCode: WideString): WideString; dispid 66;
    property thEmployeeCode: WideString dispid 67;
    procedure ImportDefaults; dispid 68;
    procedure UpdateTotals; dispid 69;
    function BuildYourRefIndex(const YourRef: WideString): WideString; dispid 70;
    function BuildLongYourRefIndex(const LongYourRef: WideString): WideString; dispid 71;
    function BuildRunNoIndex(RunNo: Integer; const DocChar: WideString): WideString; dispid 72;
    function BuildAccountDueIndex(const AccountType: WideString; const AccountCode: WideString; 
                                  const DueDate: WideString): WideString; dispid 73;
    function BuildPostedDateIndex(const PostedDate: WideString; const OurRef: WideString): WideString; dispid 74;
    function BuildTransDateIndex(const TransDate: WideString): WideString; dispid 75;
    function BuildYearPeriodIndex(AccountingYear: Integer; AccountingPeriod: Integer): WideString; dispid 76;
    function BuildOutstandingIndex(const StatusChar: WideString): WideString; dispid 77;
    procedure AllocateTransNo; dispid 78;
    property thNotes: INotes readonly dispid 79;
    property thTotals[TotalType: TTransTotalsType]: Double readonly dispid 80;
    property thMatching: IMatching readonly dispid 54;
    property thAnalysisCodeI: IJobAnalysis readonly dispid 81;
    property thJobCodeI: IJob readonly dispid 82;
  end;

// *********************************************************************//
// Interface: IPrintJob
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {73050723-DEFE-4ED1-8FAD-B488315E6E0E}
// *********************************************************************//
  IPrintJob = interface(IDispatch)
    ['{73050723-DEFE-4ED1-8FAD-B488315E6E0E}']
    function Get_pjForms: IStringArrayRW; safecall;
    function Get_pjOutputMethod: TPrintJobOutputMethods; safecall;
    procedure Set_pjOutputMethod(Value: TPrintJobOutputMethods); safecall;
    function Get_pjOutputTo: TPrintJobOutputToModes; safecall;
    procedure Set_pjOutputTo(Value: TPrintJobOutputToModes); safecall;
    function Get_pjCopies: Integer; safecall;
    procedure Set_pjCopies(Value: Integer); safecall;
    function Get_pjTestMode: WordBool; safecall;
    procedure Set_pjTestMode(Value: WordBool); safecall;
    function Get_pjPrinterInfo: IPrintJobPrinterInfo; safecall;
    function Get_pjEmailInfo: IPrintJobEmailInfo; safecall;
    function Get_pjFaxInfo: IPrintJobFaxInfo; safecall;
    function Execute: Integer; safecall;
    procedure ImportDefaults; safecall;
    property pjForms: IStringArrayRW read Get_pjForms;
    property pjOutputMethod: TPrintJobOutputMethods read Get_pjOutputMethod write Set_pjOutputMethod;
    property pjOutputTo: TPrintJobOutputToModes read Get_pjOutputTo write Set_pjOutputTo;
    property pjCopies: Integer read Get_pjCopies write Set_pjCopies;
    property pjTestMode: WordBool read Get_pjTestMode write Set_pjTestMode;
    property pjPrinterInfo: IPrintJobPrinterInfo read Get_pjPrinterInfo;
    property pjEmailInfo: IPrintJobEmailInfo read Get_pjEmailInfo;
    property pjFaxInfo: IPrintJobFaxInfo read Get_pjFaxInfo;
  end;

// *********************************************************************//
// DispIntf:  IPrintJobDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {73050723-DEFE-4ED1-8FAD-B488315E6E0E}
// *********************************************************************//
  IPrintJobDisp = dispinterface
    ['{73050723-DEFE-4ED1-8FAD-B488315E6E0E}']
    property pjForms: IStringArrayRW readonly dispid 1;
    property pjOutputMethod: TPrintJobOutputMethods dispid 2;
    property pjOutputTo: TPrintJobOutputToModes dispid 3;
    property pjCopies: Integer dispid 4;
    property pjTestMode: WordBool dispid 5;
    property pjPrinterInfo: IPrintJobPrinterInfo readonly dispid 6;
    property pjEmailInfo: IPrintJobEmailInfo readonly dispid 7;
    property pjFaxInfo: IPrintJobFaxInfo readonly dispid 8;
    function Execute: Integer; dispid 9;
    procedure ImportDefaults; dispid 10;
  end;

// *********************************************************************//
// Interface: IPrintJobPrinterInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E645C8D0-0472-44E3-88D8-EB0B2613BB97}
// *********************************************************************//
  IPrintJobPrinterInfo = interface(IDispatch)
    ['{E645C8D0-0472-44E3-88D8-EB0B2613BB97}']
    function Get_prCount: Integer; safecall;
    function Get_prPrinters(Index: Integer): IPrinterDetail; safecall;
    function Get_prDefaultPrinter: Integer; safecall;
    function Get_prPrinterIndex: Integer; safecall;
    procedure Set_prPrinterIndex(Value: Integer); safecall;
    function Get_prBinIndex: Integer; safecall;
    procedure Set_prBinIndex(Value: Integer); safecall;
    function Get_prPaperIndex: Integer; safecall;
    procedure Set_prPaperIndex(Value: Integer); safecall;
    function PrinterSetupDialog: WordBool; safecall;
    property prCount: Integer read Get_prCount;
    property prPrinters[Index: Integer]: IPrinterDetail read Get_prPrinters;
    property prDefaultPrinter: Integer read Get_prDefaultPrinter;
    property prPrinterIndex: Integer read Get_prPrinterIndex write Set_prPrinterIndex;
    property prBinIndex: Integer read Get_prBinIndex write Set_prBinIndex;
    property prPaperIndex: Integer read Get_prPaperIndex write Set_prPaperIndex;
  end;

// *********************************************************************//
// DispIntf:  IPrintJobPrinterInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E645C8D0-0472-44E3-88D8-EB0B2613BB97}
// *********************************************************************//
  IPrintJobPrinterInfoDisp = dispinterface
    ['{E645C8D0-0472-44E3-88D8-EB0B2613BB97}']
    property prCount: Integer readonly dispid 1;
    property prPrinters[Index: Integer]: IPrinterDetail readonly dispid 2;
    property prDefaultPrinter: Integer readonly dispid 3;
    property prPrinterIndex: Integer dispid 4;
    property prBinIndex: Integer dispid 5;
    property prPaperIndex: Integer dispid 6;
    function PrinterSetupDialog: WordBool; dispid 7;
  end;

// *********************************************************************//
// Interface: IPrintJobEmailInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4C8C6D88-1BDC-4BE8-85D6-584B3C02970A}
// *********************************************************************//
  IPrintJobEmailInfo = interface(IDispatch)
    ['{4C8C6D88-1BDC-4BE8-85D6-584B3C02970A}']
  end;

// *********************************************************************//
// DispIntf:  IPrintJobEmailInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4C8C6D88-1BDC-4BE8-85D6-584B3C02970A}
// *********************************************************************//
  IPrintJobEmailInfoDisp = dispinterface
    ['{4C8C6D88-1BDC-4BE8-85D6-584B3C02970A}']
  end;

// *********************************************************************//
// Interface: IPrintJobFaxInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {89124927-CB4F-4EC8-B5AC-EFFD301D35C4}
// *********************************************************************//
  IPrintJobFaxInfo = interface(IDispatch)
    ['{89124927-CB4F-4EC8-B5AC-EFFD301D35C4}']
  end;

// *********************************************************************//
// DispIntf:  IPrintJobFaxInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {89124927-CB4F-4EC8-B5AC-EFFD301D35C4}
// *********************************************************************//
  IPrintJobFaxInfoDisp = dispinterface
    ['{89124927-CB4F-4EC8-B5AC-EFFD301D35C4}']
  end;

// *********************************************************************//
// Interface: ITransactionAsNOM
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DE890BE4-B279-4DCE-8E71-9A9B8FBAFD4F}
// *********************************************************************//
  ITransactionAsNOM = interface(IDispatch)
    ['{DE890BE4-B279-4DCE-8E71-9A9B8FBAFD4F}']
    function Get_tnOurRef: WideString; safecall;
    procedure Set_tnOurRef(const Value: WideString); safecall;
    function Get_tnDescription: WideString; safecall;
    procedure Set_tnDescription(const Value: WideString); safecall;
    function Get_tnTransDate: WideString; safecall;
    procedure Set_tnTransDate(const Value: WideString); safecall;
    function Get_tnYear: Smallint; safecall;
    procedure Set_tnYear(Value: Smallint); safecall;
    function Get_tnPeriod: Integer; safecall;
    procedure Set_tnPeriod(Value: Integer); safecall;
    function Get_tnLastEditedBy: WideString; safecall;
    procedure Set_tnLastEditedBy(const Value: WideString); safecall;
    function Get_tnAutoReversing: WordBool; safecall;
    procedure Set_tnAutoReversing(Value: WordBool); safecall;
    function Get_tnYourRef: WideString; safecall;
    procedure Set_tnYourRef(const Value: WideString); safecall;
    function Get_tnUserField1: WideString; safecall;
    procedure Set_tnUserField1(const Value: WideString); safecall;
    function Get_tnUserField2: WideString; safecall;
    procedure Set_tnUserField2(const Value: WideString); safecall;
    function Get_tnUserField3: WideString; safecall;
    procedure Set_tnUserField3(const Value: WideString); safecall;
    function Get_tnUserField4: WideString; safecall;
    procedure Set_tnUserField4(const Value: WideString); safecall;
    property tnOurRef: WideString read Get_tnOurRef write Set_tnOurRef;
    property tnDescription: WideString read Get_tnDescription write Set_tnDescription;
    property tnTransDate: WideString read Get_tnTransDate write Set_tnTransDate;
    property tnYear: Smallint read Get_tnYear write Set_tnYear;
    property tnPeriod: Integer read Get_tnPeriod write Set_tnPeriod;
    property tnLastEditedBy: WideString read Get_tnLastEditedBy write Set_tnLastEditedBy;
    property tnAutoReversing: WordBool read Get_tnAutoReversing write Set_tnAutoReversing;
    property tnYourRef: WideString read Get_tnYourRef write Set_tnYourRef;
    property tnUserField1: WideString read Get_tnUserField1 write Set_tnUserField1;
    property tnUserField2: WideString read Get_tnUserField2 write Set_tnUserField2;
    property tnUserField3: WideString read Get_tnUserField3 write Set_tnUserField3;
    property tnUserField4: WideString read Get_tnUserField4 write Set_tnUserField4;
  end;

// *********************************************************************//
// DispIntf:  ITransactionAsNOMDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DE890BE4-B279-4DCE-8E71-9A9B8FBAFD4F}
// *********************************************************************//
  ITransactionAsNOMDisp = dispinterface
    ['{DE890BE4-B279-4DCE-8E71-9A9B8FBAFD4F}']
    property tnOurRef: WideString dispid 1;
    property tnDescription: WideString dispid 2;
    property tnTransDate: WideString dispid 3;
    property tnYear: Smallint dispid 4;
    property tnPeriod: Integer dispid 5;
    property tnLastEditedBy: WideString dispid 6;
    property tnAutoReversing: WordBool dispid 7;
    property tnYourRef: WideString dispid 8;
    property tnUserField1: WideString dispid 9;
    property tnUserField2: WideString dispid 10;
    property tnUserField3: WideString dispid 11;
    property tnUserField4: WideString dispid 12;
  end;

// *********************************************************************//
// Interface: ITransactionAsTSH
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8DE6DBFD-16DA-46FA-8FA8-B426DEACC327}
// *********************************************************************//
  ITransactionAsTSH = interface(IDispatch)
    ['{8DE6DBFD-16DA-46FA-8FA8-B426DEACC327}']
    function Get_ttEmployee: WideString; safecall;
    procedure Set_ttEmployee(const Value: WideString); safecall;
    function Get_ttTransDate: WideString; safecall;
    procedure Set_ttTransDate(const Value: WideString); safecall;
    function Get_ttPeriod: Integer; safecall;
    procedure Set_ttPeriod(Value: Integer); safecall;
    function Get_ttYear: Integer; safecall;
    procedure Set_ttYear(Value: Integer); safecall;
    function Get_ttDescription: WideString; safecall;
    procedure Set_ttDescription(const Value: WideString); safecall;
    function Get_ttWeekMonth: Integer; safecall;
    procedure Set_ttWeekMonth(Value: Integer); safecall;
    function Get_ttOurRef: WideString; safecall;
    procedure Set_ttOurRef(const Value: WideString); safecall;
    function Get_ttOperator: WideString; safecall;
    procedure Set_ttOperator(const Value: WideString); safecall;
    function Get_ttUserField1: WideString; safecall;
    procedure Set_ttUserField1(const Value: WideString); safecall;
    function Get_ttUserField2: WideString; safecall;
    procedure Set_ttUserField2(const Value: WideString); safecall;
    function Get_ttUserField3: WideString; safecall;
    procedure Set_ttUserField3(const Value: WideString); safecall;
    function Get_ttUserField4: WideString; safecall;
    procedure Set_ttUserField4(const Value: WideString); safecall;
    property ttEmployee: WideString read Get_ttEmployee write Set_ttEmployee;
    property ttTransDate: WideString read Get_ttTransDate write Set_ttTransDate;
    property ttPeriod: Integer read Get_ttPeriod write Set_ttPeriod;
    property ttYear: Integer read Get_ttYear write Set_ttYear;
    property ttDescription: WideString read Get_ttDescription write Set_ttDescription;
    property ttWeekMonth: Integer read Get_ttWeekMonth write Set_ttWeekMonth;
    property ttOurRef: WideString read Get_ttOurRef write Set_ttOurRef;
    property ttOperator: WideString read Get_ttOperator write Set_ttOperator;
    property ttUserField1: WideString read Get_ttUserField1 write Set_ttUserField1;
    property ttUserField2: WideString read Get_ttUserField2 write Set_ttUserField2;
    property ttUserField3: WideString read Get_ttUserField3 write Set_ttUserField3;
    property ttUserField4: WideString read Get_ttUserField4 write Set_ttUserField4;
  end;

// *********************************************************************//
// DispIntf:  ITransactionAsTSHDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8DE6DBFD-16DA-46FA-8FA8-B426DEACC327}
// *********************************************************************//
  ITransactionAsTSHDisp = dispinterface
    ['{8DE6DBFD-16DA-46FA-8FA8-B426DEACC327}']
    property ttEmployee: WideString dispid 1;
    property ttTransDate: WideString dispid 2;
    property ttPeriod: Integer dispid 3;
    property ttYear: Integer dispid 4;
    property ttDescription: WideString dispid 5;
    property ttWeekMonth: Integer dispid 6;
    property ttOurRef: WideString dispid 7;
    property ttOperator: WideString dispid 8;
    property ttUserField1: WideString dispid 9;
    property ttUserField2: WideString dispid 10;
    property ttUserField3: WideString dispid 11;
    property ttUserField4: WideString dispid 12;
  end;

// *********************************************************************//
// Interface: ITransactionLineAsNOM
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D9E5B9E2-D4F8-4BEC-AD69-5A7955C34503}
// *********************************************************************//
  ITransactionLineAsNOM = interface(IDispatch)
    ['{D9E5B9E2-D4F8-4BEC-AD69-5A7955C34503}']
    function Get_tlnDescription: WideString; safecall;
    procedure Set_tlnDescription(const Value: WideString); safecall;
    function Get_tlnGLCode: Integer; safecall;
    procedure Set_tlnGLCode(Value: Integer); safecall;
    function Get_tlnJobCode: WideString; safecall;
    procedure Set_tlnJobCode(const Value: WideString); safecall;
    function Get_tlnJobAnalysis: WideString; safecall;
    procedure Set_tlnJobAnalysis(const Value: WideString); safecall;
    function Get_tlnCurrency: Integer; safecall;
    procedure Set_tlnCurrency(Value: Integer); safecall;
    function Get_tlnExchangeRate: Double; safecall;
    procedure Set_tlnExchangeRate(Value: Double); safecall;
    function Get_tlnDebit: Double; safecall;
    procedure Set_tlnDebit(Value: Double); safecall;
    function Get_tlnCredit: Double; safecall;
    procedure Set_tlnCredit(Value: Double); safecall;
    function Get_tlnUserField1: WideString; safecall;
    procedure Set_tlnUserField1(const Value: WideString); safecall;
    function Get_tlnUserField2: WideString; safecall;
    procedure Set_tlnUserField2(const Value: WideString); safecall;
    function Get_tlnUserField3: WideString; safecall;
    procedure Set_tlnUserField3(const Value: WideString); safecall;
    function Get_tlnUserField4: WideString; safecall;
    procedure Set_tlnUserField4(const Value: WideString); safecall;
    function Get_tlnCostCentre: WideString; safecall;
    procedure Set_tlnCostCentre(const Value: WideString); safecall;
    function Get_tlnDepartment: WideString; safecall;
    procedure Set_tlnDepartment(const Value: WideString); safecall;
    property tlnDescription: WideString read Get_tlnDescription write Set_tlnDescription;
    property tlnGLCode: Integer read Get_tlnGLCode write Set_tlnGLCode;
    property tlnJobCode: WideString read Get_tlnJobCode write Set_tlnJobCode;
    property tlnJobAnalysis: WideString read Get_tlnJobAnalysis write Set_tlnJobAnalysis;
    property tlnCurrency: Integer read Get_tlnCurrency write Set_tlnCurrency;
    property tlnExchangeRate: Double read Get_tlnExchangeRate write Set_tlnExchangeRate;
    property tlnDebit: Double read Get_tlnDebit write Set_tlnDebit;
    property tlnCredit: Double read Get_tlnCredit write Set_tlnCredit;
    property tlnUserField1: WideString read Get_tlnUserField1 write Set_tlnUserField1;
    property tlnUserField2: WideString read Get_tlnUserField2 write Set_tlnUserField2;
    property tlnUserField3: WideString read Get_tlnUserField3 write Set_tlnUserField3;
    property tlnUserField4: WideString read Get_tlnUserField4 write Set_tlnUserField4;
    property tlnCostCentre: WideString read Get_tlnCostCentre write Set_tlnCostCentre;
    property tlnDepartment: WideString read Get_tlnDepartment write Set_tlnDepartment;
  end;

// *********************************************************************//
// DispIntf:  ITransactionLineAsNOMDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D9E5B9E2-D4F8-4BEC-AD69-5A7955C34503}
// *********************************************************************//
  ITransactionLineAsNOMDisp = dispinterface
    ['{D9E5B9E2-D4F8-4BEC-AD69-5A7955C34503}']
    property tlnDescription: WideString dispid 1;
    property tlnGLCode: Integer dispid 2;
    property tlnJobCode: WideString dispid 3;
    property tlnJobAnalysis: WideString dispid 4;
    property tlnCurrency: Integer dispid 5;
    property tlnExchangeRate: Double dispid 6;
    property tlnDebit: Double dispid 7;
    property tlnCredit: Double dispid 8;
    property tlnUserField1: WideString dispid 9;
    property tlnUserField2: WideString dispid 10;
    property tlnUserField3: WideString dispid 11;
    property tlnUserField4: WideString dispid 12;
    property tlnCostCentre: WideString dispid 13;
    property tlnDepartment: WideString dispid 14;
  end;

// *********************************************************************//
// Interface: ITransactionLine2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B0155989-B2A5-4966-BD10-00E52604A7D7}
// *********************************************************************//
  ITransactionLine2 = interface(ITransactionLine)
    ['{B0155989-B2A5-4966-BD10-00E52604A7D7}']
    function Get_tlAsNOM: ITransactionLineAsNOM; safecall;
    function Get_tlAsTSH: ITransactionLineAsTSH; safecall;
    function Get_tlAsADJ: ITransactionLineAsADJ; safecall;
    function Get_tlAsWOR: ITransactionLineAsWOR; safecall;
    property tlAsNOM: ITransactionLineAsNOM read Get_tlAsNOM;
    property tlAsTSH: ITransactionLineAsTSH read Get_tlAsTSH;
    property tlAsADJ: ITransactionLineAsADJ read Get_tlAsADJ;
    property tlAsWOR: ITransactionLineAsWOR read Get_tlAsWOR;
  end;

// *********************************************************************//
// DispIntf:  ITransactionLine2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B0155989-B2A5-4966-BD10-00E52604A7D7}
// *********************************************************************//
  ITransactionLine2Disp = dispinterface
    ['{B0155989-B2A5-4966-BD10-00E52604A7D7}']
    property tlAsNOM: ITransactionLineAsNOM readonly dispid 61;
    property tlAsTSH: ITransactionLineAsTSH readonly dispid 62;
    property tlAsADJ: ITransactionLineAsADJ readonly dispid 63;
    property tlAsWOR: ITransactionLineAsWOR readonly dispid 64;
    property tlLineNo: Integer dispid 1;
    property tlGLCode: Integer dispid 2;
    property tlCurrency: Integer dispid 3;
    property tlCompanyRate: Double dispid 4;
    property tlDailyRate: Double dispid 51;
    property tlCostCentre: WideString dispid 6;
    property tlDepartment: WideString dispid 7;
    property tlStockCode: WideString dispid 8;
    property tlQty: Double dispid 9;
    property tlQtyMul: Double dispid 10;
    property tlNetValue: Double dispid 11;
    property tlDiscount: Double dispid 12;
    property tlDiscFlag: WideString dispid 13;
    property tlVATCode: WideString dispid 14;
    property tlVATAmount: Double dispid 15;
    property tlPayment: WordBool dispid 16;
    property tlQtyWOFF: Double dispid 17;
    property tlQtyDel: Double dispid 18;
    property tlCost: Double dispid 19;
    property tlLineDate: WideString dispid 20;
    property tlItemNo: WideString dispid 21;
    property tlDescr: WideString dispid 22;
    property tlJobCode: WideString dispid 23;
    property tlAnalysisCode: WideString dispid 24;
    property tlUnitWeight: Double dispid 25;
    property tlLocation: WideString dispid 26;
    property tlChargeCurrency: Integer dispid 27;
    property tlAcCode: WideString readonly dispid 28;
    property tlLineType: TTransactionLineType dispid 29;
    property tlFolioNum: Integer readonly dispid 30;
    property tlLineClass: WideString readonly dispid 31;
    property tlRecStatus: Smallint dispid 32;
    property tlSOPFolioNum: Integer dispid 33;
    property tlSOPABSLineNo: Integer dispid 34;
    property tlABSLineNo: Integer readonly dispid 35;
    property tlUserField1: WideString dispid 36;
    property tlUserField2: WideString dispid 37;
    property tlUserField3: WideString dispid 38;
    property tlUserField4: WideString dispid 39;
    property tlSSDUpliftPerc: Double dispid 40;
    property tlSSDCommodCode: WideString dispid 41;
    property tlSSDSalesUnit: Double dispid 42;
    property tlSSDUseLineValues: WordBool dispid 43;
    property tlPriceMultiplier: Double dispid 44;
    property tlQtyPicked: Double dispid 45;
    property tlQtyPickedWO: Double dispid 46;
    property tlSSDCountry: WideString dispid 47;
    property tlInclusiveVATCode: WideString dispid 48;
    property tlBOMKitLink: Integer dispid 49;
    property tlOurRef: WideString readonly dispid 5;
    function entLineTotal(ApplyDiscounts: WordBool; SettleDiscPerc: Double): Double; dispid 50;
    procedure Save; dispid 54;
    procedure Cancel; dispid 52;
    function entDefaultVATCode(const AccountVATCode: WideString; const StockVATCode: WideString): WideString; dispid 53;
    procedure CalcVATAmount; dispid 55;
    procedure CalcStockPrice; dispid 56;
    property tlStockCodeI: IStock readonly dispid 57;
    procedure ImportDefaults; dispid 68;
    property tlAnalyisCodeI: IJobAnalysis readonly dispid 58;
    property tlJobCodeI: IJob readonly dispid 59;
    property tlSerialBatch: ITransactionLineSerialBatch readonly dispid 60;
  end;

// *********************************************************************//
// Interface: ITransactionLineAsTSH
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {48A2DB49-F3CA-4E4F-A2D2-3097D8B24A84}
// *********************************************************************//
  ITransactionLineAsTSH = interface(IDispatch)
    ['{48A2DB49-F3CA-4E4F-A2D2-3097D8B24A84}']
    function Get_tltJobCode: WideString; safecall;
    procedure Set_tltJobCode(const Value: WideString); safecall;
    function Get_tltRateCode: WideString; safecall;
    procedure Set_tltRateCode(const Value: WideString); safecall;
    function Get_tltAnalysisCode: WideString; safecall;
    procedure Set_tltAnalysisCode(const Value: WideString); safecall;
    function Get_tltHours: Double; safecall;
    procedure Set_tltHours(Value: Double); safecall;
    function Get_tltNarrative: WideString; safecall;
    procedure Set_tltNarrative(const Value: WideString); safecall;
    function Get_tltChargeOutRate: Double; safecall;
    procedure Set_tltChargeOutRate(Value: Double); safecall;
    function Get_tltCostPerHour: Double; safecall;
    procedure Set_tltCostPerHour(Value: Double); safecall;
    function Get_tltUserField1: WideString; safecall;
    procedure Set_tltUserField1(const Value: WideString); safecall;
    function Get_tltUserField2: WideString; safecall;
    procedure Set_tltUserField2(const Value: WideString); safecall;
    function Get_tltUserField3: WideString; safecall;
    procedure Set_tltUserField3(const Value: WideString); safecall;
    function Get_tltUserField4: WideString; safecall;
    procedure Set_tltUserField4(const Value: WideString); safecall;
    function Get_tltCurrency: Integer; safecall;
    procedure Set_tltCurrency(Value: Integer); safecall;
    function Get_tltCostCentre: WideString; safecall;
    procedure Set_tltCostCentre(const Value: WideString); safecall;
    function Get_tltDepartment: WideString; safecall;
    procedure Set_tltDepartment(const Value: WideString); safecall;
    property tltJobCode: WideString read Get_tltJobCode write Set_tltJobCode;
    property tltRateCode: WideString read Get_tltRateCode write Set_tltRateCode;
    property tltAnalysisCode: WideString read Get_tltAnalysisCode write Set_tltAnalysisCode;
    property tltHours: Double read Get_tltHours write Set_tltHours;
    property tltNarrative: WideString read Get_tltNarrative write Set_tltNarrative;
    property tltChargeOutRate: Double read Get_tltChargeOutRate write Set_tltChargeOutRate;
    property tltCostPerHour: Double read Get_tltCostPerHour write Set_tltCostPerHour;
    property tltUserField1: WideString read Get_tltUserField1 write Set_tltUserField1;
    property tltUserField2: WideString read Get_tltUserField2 write Set_tltUserField2;
    property tltUserField3: WideString read Get_tltUserField3 write Set_tltUserField3;
    property tltUserField4: WideString read Get_tltUserField4 write Set_tltUserField4;
    property tltCurrency: Integer read Get_tltCurrency write Set_tltCurrency;
    property tltCostCentre: WideString read Get_tltCostCentre write Set_tltCostCentre;
    property tltDepartment: WideString read Get_tltDepartment write Set_tltDepartment;
  end;

// *********************************************************************//
// DispIntf:  ITransactionLineAsTSHDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {48A2DB49-F3CA-4E4F-A2D2-3097D8B24A84}
// *********************************************************************//
  ITransactionLineAsTSHDisp = dispinterface
    ['{48A2DB49-F3CA-4E4F-A2D2-3097D8B24A84}']
    property tltJobCode: WideString dispid 1;
    property tltRateCode: WideString dispid 4;
    property tltAnalysisCode: WideString dispid 5;
    property tltHours: Double dispid 6;
    property tltNarrative: WideString dispid 7;
    property tltChargeOutRate: Double dispid 8;
    property tltCostPerHour: Double dispid 9;
    property tltUserField1: WideString dispid 10;
    property tltUserField2: WideString dispid 11;
    property tltUserField3: WideString dispid 12;
    property tltUserField4: WideString dispid 13;
    property tltCurrency: Integer dispid 2;
    property tltCostCentre: WideString dispid 3;
    property tltDepartment: WideString dispid 14;
  end;

// *********************************************************************//
// Interface: ITransactionAsADJ
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {26EFB79B-2850-47C7-8652-40F3C54B26EB}
// *********************************************************************//
  ITransactionAsADJ = interface(IDispatch)
    ['{26EFB79B-2850-47C7-8652-40F3C54B26EB}']
    function Get_taOurRef: WideString; safecall;
    procedure Set_taOurRef(const Value: WideString); safecall;
    function Get_taDescription: WideString; safecall;
    procedure Set_taDescription(const Value: WideString); safecall;
    function Get_taDate: WideString; safecall;
    procedure Set_taDate(const Value: WideString); safecall;
    function Get_taYear: Integer; safecall;
    procedure Set_taYear(Value: Integer); safecall;
    function Get_taPeriod: Integer; safecall;
    procedure Set_taPeriod(Value: Integer); safecall;
    function Get_taYourRef: WideString; safecall;
    procedure Set_taYourRef(const Value: WideString); safecall;
    function Get_taLastEditedBy: WideString; safecall;
    procedure Set_taLastEditedBy(const Value: WideString); safecall;
    function Get_taUserField1: WideString; safecall;
    procedure Set_taUserField1(const Value: WideString); safecall;
    function Get_taUserField2: WideString; safecall;
    procedure Set_taUserField2(const Value: WideString); safecall;
    function Get_taUserField3: WideString; safecall;
    procedure Set_taUserField3(const Value: WideString); safecall;
    function Get_taUserField4: WideString; safecall;
    procedure Set_taUserField4(const Value: WideString); safecall;
    property taOurRef: WideString read Get_taOurRef write Set_taOurRef;
    property taDescription: WideString read Get_taDescription write Set_taDescription;
    property taDate: WideString read Get_taDate write Set_taDate;
    property taYear: Integer read Get_taYear write Set_taYear;
    property taPeriod: Integer read Get_taPeriod write Set_taPeriod;
    property taYourRef: WideString read Get_taYourRef write Set_taYourRef;
    property taLastEditedBy: WideString read Get_taLastEditedBy write Set_taLastEditedBy;
    property taUserField1: WideString read Get_taUserField1 write Set_taUserField1;
    property taUserField2: WideString read Get_taUserField2 write Set_taUserField2;
    property taUserField3: WideString read Get_taUserField3 write Set_taUserField3;
    property taUserField4: WideString read Get_taUserField4 write Set_taUserField4;
  end;

// *********************************************************************//
// DispIntf:  ITransactionAsADJDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {26EFB79B-2850-47C7-8652-40F3C54B26EB}
// *********************************************************************//
  ITransactionAsADJDisp = dispinterface
    ['{26EFB79B-2850-47C7-8652-40F3C54B26EB}']
    property taOurRef: WideString dispid 1;
    property taDescription: WideString dispid 2;
    property taDate: WideString dispid 3;
    property taYear: Integer dispid 4;
    property taPeriod: Integer dispid 5;
    property taYourRef: WideString dispid 6;
    property taLastEditedBy: WideString dispid 7;
    property taUserField1: WideString dispid 8;
    property taUserField2: WideString dispid 9;
    property taUserField3: WideString dispid 10;
    property taUserField4: WideString dispid 11;
  end;

// *********************************************************************//
// Interface: ITransactionLineAsADJ
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5D9D845C-0D73-4F8D-8464-31C95AA9267C}
// *********************************************************************//
  ITransactionLineAsADJ = interface(IDispatch)
    ['{5D9D845C-0D73-4F8D-8464-31C95AA9267C}']
    function Get_tlaStockCode: WideString; safecall;
    procedure Set_tlaStockCode(const Value: WideString); safecall;
    function Get_tlaLocation: WideString; safecall;
    procedure Set_tlaLocation(const Value: WideString); safecall;
    function Get_tlaPackQty: Double; safecall;
    procedure Set_tlaPackQty(Value: Double); safecall;
    function Get_tlaQtyIn: Double; safecall;
    procedure Set_tlaQtyIn(Value: Double); safecall;
    function Get_tlaQtyOut: Double; safecall;
    procedure Set_tlaQtyOut(Value: Double); safecall;
    function Get_tlaBuild: WordBool; safecall;
    procedure Set_tlaBuild(Value: WordBool); safecall;
    function Get_tlaUnitCost: Double; safecall;
    procedure Set_tlaUnitCost(Value: Double); safecall;
    function Get_tlaGLCode: Integer; safecall;
    procedure Set_tlaGLCode(Value: Integer); safecall;
    function Get_tlaCostCentre: WideString; safecall;
    procedure Set_tlaCostCentre(const Value: WideString); safecall;
    function Get_tlaDepartment: WideString; safecall;
    procedure Set_tlaDepartment(const Value: WideString); safecall;
    function Get_tlaUserField1: WideString; safecall;
    procedure Set_tlaUserField1(const Value: WideString); safecall;
    function Get_tlaUserField2: WideString; safecall;
    procedure Set_tlaUserField2(const Value: WideString); safecall;
    function Get_tlaUserField3: WideString; safecall;
    procedure Set_tlaUserField3(const Value: WideString); safecall;
    function Get_tlaUserField4: WideString; safecall;
    procedure Set_tlaUserField4(const Value: WideString); safecall;
    property tlaStockCode: WideString read Get_tlaStockCode write Set_tlaStockCode;
    property tlaLocation: WideString read Get_tlaLocation write Set_tlaLocation;
    property tlaPackQty: Double read Get_tlaPackQty write Set_tlaPackQty;
    property tlaQtyIn: Double read Get_tlaQtyIn write Set_tlaQtyIn;
    property tlaQtyOut: Double read Get_tlaQtyOut write Set_tlaQtyOut;
    property tlaBuild: WordBool read Get_tlaBuild write Set_tlaBuild;
    property tlaUnitCost: Double read Get_tlaUnitCost write Set_tlaUnitCost;
    property tlaGLCode: Integer read Get_tlaGLCode write Set_tlaGLCode;
    property tlaCostCentre: WideString read Get_tlaCostCentre write Set_tlaCostCentre;
    property tlaDepartment: WideString read Get_tlaDepartment write Set_tlaDepartment;
    property tlaUserField1: WideString read Get_tlaUserField1 write Set_tlaUserField1;
    property tlaUserField2: WideString read Get_tlaUserField2 write Set_tlaUserField2;
    property tlaUserField3: WideString read Get_tlaUserField3 write Set_tlaUserField3;
    property tlaUserField4: WideString read Get_tlaUserField4 write Set_tlaUserField4;
  end;

// *********************************************************************//
// DispIntf:  ITransactionLineAsADJDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5D9D845C-0D73-4F8D-8464-31C95AA9267C}
// *********************************************************************//
  ITransactionLineAsADJDisp = dispinterface
    ['{5D9D845C-0D73-4F8D-8464-31C95AA9267C}']
    property tlaStockCode: WideString dispid 1;
    property tlaLocation: WideString dispid 2;
    property tlaPackQty: Double dispid 3;
    property tlaQtyIn: Double dispid 4;
    property tlaQtyOut: Double dispid 5;
    property tlaBuild: WordBool dispid 6;
    property tlaUnitCost: Double dispid 7;
    property tlaGLCode: Integer dispid 8;
    property tlaCostCentre: WideString dispid 9;
    property tlaDepartment: WideString dispid 10;
    property tlaUserField1: WideString dispid 11;
    property tlaUserField2: WideString dispid 12;
    property tlaUserField3: WideString dispid 13;
    property tlaUserField4: WideString dispid 14;
  end;

// *********************************************************************//
// Interface: ITransactionAsWOR
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9161D394-AF47-426C-9F6A-5940EE80E167}
// *********************************************************************//
  ITransactionAsWOR = interface(IDispatch)
    ['{9161D394-AF47-426C-9F6A-5940EE80E167}']
    function Get_twOurRef: WideString; safecall;
    procedure Set_twOurRef(const Value: WideString); safecall;
    function Get_twAcCode: WideString; safecall;
    procedure Set_twAcCode(const Value: WideString); safecall;
    function Get_twStartDate: WideString; safecall;
    procedure Set_twStartDate(const Value: WideString); safecall;
    function Get_twCompleteDate: WideString; safecall;
    procedure Set_twCompleteDate(const Value: WideString); safecall;
    function Get_twYourRef: WideString; safecall;
    procedure Set_twYourRef(const Value: WideString); safecall;
    function Get_twAltRef: WideString; safecall;
    procedure Set_twAltRef(const Value: WideString); safecall;
    function Get_twOperator: WideString; safecall;
    procedure Set_twOperator(const Value: WideString); safecall;
    function Get_twPeriod: Integer; safecall;
    procedure Set_twPeriod(Value: Integer); safecall;
    function Get_twYear: Integer; safecall;
    procedure Set_twYear(Value: Integer); safecall;
    function Get_twLocation: WideString; safecall;
    procedure Set_twLocation(const Value: WideString); safecall;
    function Get_twUserField1: WideString; safecall;
    procedure Set_twUserField1(const Value: WideString); safecall;
    function Get_twUserField2: WideString; safecall;
    procedure Set_twUserField2(const Value: WideString); safecall;
    function Get_twUserField3: WideString; safecall;
    procedure Set_twUserField3(const Value: WideString); safecall;
    function Get_twUserField4: WideString; safecall;
    procedure Set_twUserField4(const Value: WideString); safecall;
    property twOurRef: WideString read Get_twOurRef write Set_twOurRef;
    property twAcCode: WideString read Get_twAcCode write Set_twAcCode;
    property twStartDate: WideString read Get_twStartDate write Set_twStartDate;
    property twCompleteDate: WideString read Get_twCompleteDate write Set_twCompleteDate;
    property twYourRef: WideString read Get_twYourRef write Set_twYourRef;
    property twAltRef: WideString read Get_twAltRef write Set_twAltRef;
    property twOperator: WideString read Get_twOperator write Set_twOperator;
    property twPeriod: Integer read Get_twPeriod write Set_twPeriod;
    property twYear: Integer read Get_twYear write Set_twYear;
    property twLocation: WideString read Get_twLocation write Set_twLocation;
    property twUserField1: WideString read Get_twUserField1 write Set_twUserField1;
    property twUserField2: WideString read Get_twUserField2 write Set_twUserField2;
    property twUserField3: WideString read Get_twUserField3 write Set_twUserField3;
    property twUserField4: WideString read Get_twUserField4 write Set_twUserField4;
  end;

// *********************************************************************//
// DispIntf:  ITransactionAsWORDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9161D394-AF47-426C-9F6A-5940EE80E167}
// *********************************************************************//
  ITransactionAsWORDisp = dispinterface
    ['{9161D394-AF47-426C-9F6A-5940EE80E167}']
    property twOurRef: WideString dispid 1;
    property twAcCode: WideString dispid 2;
    property twStartDate: WideString dispid 3;
    property twCompleteDate: WideString dispid 4;
    property twYourRef: WideString dispid 5;
    property twAltRef: WideString dispid 6;
    property twOperator: WideString dispid 7;
    property twPeriod: Integer dispid 8;
    property twYear: Integer dispid 9;
    property twLocation: WideString dispid 10;
    property twUserField1: WideString dispid 11;
    property twUserField2: WideString dispid 12;
    property twUserField3: WideString dispid 13;
    property twUserField4: WideString dispid 14;
  end;

// *********************************************************************//
// Interface: ITransactionLineAsWOR
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2F2EB85B-4454-4AAA-AC81-D0F4160AE181}
// *********************************************************************//
  ITransactionLineAsWOR = interface(IDispatch)
    ['{2F2EB85B-4454-4AAA-AC81-D0F4160AE181}']
    function Get_tlwStockCode: WideString; safecall;
    procedure Set_tlwStockCode(const Value: WideString); safecall;
    function Get_tlwLocation: WideString; safecall;
    procedure Set_tlwLocation(const Value: WideString); safecall;
    function Get_tlwQtyRequired: Double; safecall;
    procedure Set_tlwQtyRequired(Value: Double); safecall;
    function Get_tlwUndersOvers: Double; safecall;
    procedure Set_tlwUndersOvers(Value: Double); safecall;
    function Get_tlwBuildOrPickQty: Double; safecall;
    procedure Set_tlwBuildOrPickQty(Value: Double); safecall;
    function Get_tlwCostCentre: WideString; safecall;
    procedure Set_tlwCostCentre(const Value: WideString); safecall;
    function Get_tlwDepartment: WideString; safecall;
    procedure Set_tlwDepartment(const Value: WideString); safecall;
    function Get_tlwUserField1: WideString; safecall;
    procedure Set_tlwUserField1(const Value: WideString); safecall;
    function Get_tlwUserField2: WideString; safecall;
    procedure Set_tlwUserField2(const Value: WideString); safecall;
    function Get_tlwUserField3: WideString; safecall;
    procedure Set_tlwUserField3(const Value: WideString); safecall;
    function Get_tlwUserField4: WideString; safecall;
    procedure Set_tlwUserField4(const Value: WideString); safecall;
    function Get_tlwQtyPerBOM: Double; safecall;
    procedure Set_tlwQtyPerBOM(Value: Double); safecall;
    function ExplodeBOM: Integer; safecall;
    property tlwStockCode: WideString read Get_tlwStockCode write Set_tlwStockCode;
    property tlwLocation: WideString read Get_tlwLocation write Set_tlwLocation;
    property tlwQtyRequired: Double read Get_tlwQtyRequired write Set_tlwQtyRequired;
    property tlwUndersOvers: Double read Get_tlwUndersOvers write Set_tlwUndersOvers;
    property tlwBuildOrPickQty: Double read Get_tlwBuildOrPickQty write Set_tlwBuildOrPickQty;
    property tlwCostCentre: WideString read Get_tlwCostCentre write Set_tlwCostCentre;
    property tlwDepartment: WideString read Get_tlwDepartment write Set_tlwDepartment;
    property tlwUserField1: WideString read Get_tlwUserField1 write Set_tlwUserField1;
    property tlwUserField2: WideString read Get_tlwUserField2 write Set_tlwUserField2;
    property tlwUserField3: WideString read Get_tlwUserField3 write Set_tlwUserField3;
    property tlwUserField4: WideString read Get_tlwUserField4 write Set_tlwUserField4;
    property tlwQtyPerBOM: Double read Get_tlwQtyPerBOM write Set_tlwQtyPerBOM;
  end;

// *********************************************************************//
// DispIntf:  ITransactionLineAsWORDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2F2EB85B-4454-4AAA-AC81-D0F4160AE181}
// *********************************************************************//
  ITransactionLineAsWORDisp = dispinterface
    ['{2F2EB85B-4454-4AAA-AC81-D0F4160AE181}']
    property tlwStockCode: WideString dispid 1;
    property tlwLocation: WideString dispid 2;
    property tlwQtyRequired: Double dispid 3;
    property tlwUndersOvers: Double dispid 4;
    property tlwBuildOrPickQty: Double dispid 5;
    property tlwCostCentre: WideString dispid 6;
    property tlwDepartment: WideString dispid 7;
    property tlwUserField1: WideString dispid 8;
    property tlwUserField2: WideString dispid 9;
    property tlwUserField3: WideString dispid 10;
    property tlwUserField4: WideString dispid 11;
    property tlwQtyPerBOM: Double dispid 12;
    function ExplodeBOM: Integer; dispid 13;
  end;

// *********************************************************************//
// Interface: ILinks
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {867DDF64-B570-4A37-A813-E738641C02A2}
// *********************************************************************//
  ILinks = interface(IDispatch)
    ['{867DDF64-B570-4A37-A813-E738641C02A2}']
    function Get_lkType: TLinkType; safecall;
    function Get_lkDate: WideString; safecall;
    procedure Set_lkDate(const Value: WideString); safecall;
    function Get_lkTime: WideString; safecall;
    procedure Set_lkTime(const Value: WideString); safecall;
    function Get_lkUser: WideString; safecall;
    procedure Set_lkUser(const Value: WideString); safecall;
    function Get_lkFileName: WideString; safecall;
    procedure Set_lkFileName(const Value: WideString); safecall;
    function Get_lkDescription: WideString; safecall;
    procedure Set_lkDescription(const Value: WideString); safecall;
    function Get_lkObjectType: TLinkObjectType; safecall;
    procedure Set_lkObjectType(Value: TLinkObjectType); safecall;
    function GetFirst: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function Add: ILinks; safecall;
    function Save: Integer; safecall;
    function Update: ILinks; safecall;
    procedure Cancel; safecall;
    function Delete: Integer; safecall;
    property lkType: TLinkType read Get_lkType;
    property lkDate: WideString read Get_lkDate write Set_lkDate;
    property lkTime: WideString read Get_lkTime write Set_lkTime;
    property lkUser: WideString read Get_lkUser write Set_lkUser;
    property lkFileName: WideString read Get_lkFileName write Set_lkFileName;
    property lkDescription: WideString read Get_lkDescription write Set_lkDescription;
    property lkObjectType: TLinkObjectType read Get_lkObjectType write Set_lkObjectType;
  end;

// *********************************************************************//
// DispIntf:  ILinksDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {867DDF64-B570-4A37-A813-E738641C02A2}
// *********************************************************************//
  ILinksDisp = dispinterface
    ['{867DDF64-B570-4A37-A813-E738641C02A2}']
    property lkType: TLinkType readonly dispid 3;
    property lkDate: WideString dispid 4;
    property lkTime: WideString dispid 5;
    property lkUser: WideString dispid 6;
    property lkFileName: WideString dispid 7;
    property lkDescription: WideString dispid 8;
    property lkObjectType: TLinkObjectType dispid 9;
    function GetFirst: Integer; dispid 10;
    function GetNext: Integer; dispid 11;
    function GetLast: Integer; dispid 12;
    function GetPrevious: Integer; dispid 13;
    function Add: ILinks; dispid 14;
    function Save: Integer; dispid 15;
    function Update: ILinks; dispid 17;
    procedure Cancel; dispid 18;
    function Delete: Integer; dispid 1;
  end;

// *********************************************************************//
// Interface: IJob2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9760EDF5-D06C-47BE-B6F7-4663E7D3D885}
// *********************************************************************//
  IJob2 = interface(IJob)
    ['{9760EDF5-D06C-47BE-B6F7-4663E7D3D885}']
    function Get_jrLinks: ILinks; safecall;
    property jrLinks: ILinks read Get_jrLinks;
  end;

// *********************************************************************//
// DispIntf:  IJob2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9760EDF5-D06C-47BE-B6F7-4663E7D3D885}
// *********************************************************************//
  IJob2Disp = dispinterface
    ['{9760EDF5-D06C-47BE-B6F7-4663E7D3D885}']
    property jrLinks: ILinks readonly dispid 38;
    property jrCode: WideString dispid 1;
    property jrDesc: WideString dispid 2;
    property jrFolio: Integer readonly dispid 3;
    property jrAcCode: WideString dispid 4;
    property jrParent: WideString dispid 5;
    property jrAltCode: WideString dispid 6;
    property jrCompleted: WordBool dispid 7;
    property jrContact: WideString dispid 8;
    property jrManager: WideString dispid 9;
    property jrChargeType: TJobChargeType dispid 10;
    property jrQuotePrice: Double dispid 11;
    property jrQuotePriceCurr: Smallint dispid 12;
    property jrStartDate: WideString dispid 13;
    property jrEndDate: WideString dispid 14;
    property jrRevisedEndDate: WideString dispid 15;
    property jrSORNumber: WideString dispid 16;
    property jrVATCode: WideString dispid 17;
    property jrJobType: WideString dispid 20;
    property jrType: TJobTypeType dispid 21;
    property jrStatus: TJobStatusType dispid 22;
    property jrUserField1: WideString dispid 23;
    property jrUserField2: WideString dispid 24;
    function GetFirst: Integer; dispid 16777217;
    function GetPrevious: Integer; dispid 16777218;
    function GetNext: Integer; dispid 16777219;
    function GetLast: Integer; dispid 16777220;
    property Index: TJobIndex dispid 16777221;
    property KeyString: WideString readonly dispid 16777222;
    property Position: Integer dispid 16777224;
    function RestorePosition: Integer; dispid 16777225;
    function SavePosition: Integer; dispid 16777232;
    function StepFirst: Integer; dispid 16777233;
    function StepPrevious: Integer; dispid 16777234;
    function StepNext: Integer; dispid 16777235;
    function StepLast: Integer; dispid 16777236;
    function GetLessThan(const SearchKey: WideString): Integer; dispid 16777238;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; dispid 16777239;
    function GetEqual(const SearchKey: WideString): Integer; dispid 16777240;
    function GetGreaterThan(const SearchKey: WideString): Integer; dispid 16777241;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; dispid 16777242;
    function BuildCodeIndex(const JobCode: WideString): WideString; dispid 18;
    function BuildFolioIndex(Folio: Integer): WideString; dispid 19;
    function BuildParentIndex(const ParentCode: WideString; const JobCode: WideString): WideString; dispid 25;
    function Add: IJob; dispid 26;
    function Update: IJob; dispid 27;
    function Clone: IJob; dispid 28;
    function Save: Integer; dispid 29;
    procedure Cancel; dispid 30;
    function BuildDescIndex(const Description: WideString): WideString; dispid 31;
    function BuildCompletedCodeIndex(Completed: WordBool; const JobCode: WideString): WideString; dispid 32;
    function BuildCompletedDescIndex(Completed: WordBool; const Description: WideString): WideString; dispid 33;
    function BuildAltCodeIndex(const AlternateCode: WideString): WideString; dispid 34;
    function BuildAccountIndex(const AccountCode: WideString): WideString; dispid 35;
    property jrNotes: INotes readonly dispid 36;
    property jrJobTypeI: IJobType readonly dispid 37;
  end;

// *********************************************************************//
// Interface: IAutoTransactionSettings
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {23571D0C-3F7A-40BE-84F7-0089D1B1D197}
// *********************************************************************//
  IAutoTransactionSettings = interface(IDispatch)
    ['{23571D0C-3F7A-40BE-84F7-0089D1B1D197}']
    function Get_atIncrementType: TAutoIncrementType; safecall;
    procedure Set_atIncrementType(Value: TAutoIncrementType); safecall;
    function Get_atIncrement: Integer; safecall;
    procedure Set_atIncrement(Value: Integer); safecall;
    function Get_atAutoCreateOnPost: WordBool; safecall;
    procedure Set_atAutoCreateOnPost(Value: WordBool); safecall;
    function Get_atStartDate: WideString; safecall;
    procedure Set_atStartDate(const Value: WideString); safecall;
    function Get_atStartPeriod: Integer; safecall;
    procedure Set_atStartPeriod(Value: Integer); safecall;
    function Get_atStartYear: Integer; safecall;
    procedure Set_atStartYear(Value: Integer); safecall;
    function Get_atEndDate: WideString; safecall;
    procedure Set_atEndDate(const Value: WideString); safecall;
    function Get_atEndPeriod: Integer; safecall;
    procedure Set_atEndPeriod(Value: Integer); safecall;
    function Get_atEndYear: Integer; safecall;
    procedure Set_atEndYear(Value: Integer); safecall;
    function Get_atAutoTransaction: WordBool; safecall;
    procedure Set_atAutoTransaction(Value: WordBool); safecall;
    property atIncrementType: TAutoIncrementType read Get_atIncrementType write Set_atIncrementType;
    property atIncrement: Integer read Get_atIncrement write Set_atIncrement;
    property atAutoCreateOnPost: WordBool read Get_atAutoCreateOnPost write Set_atAutoCreateOnPost;
    property atStartDate: WideString read Get_atStartDate write Set_atStartDate;
    property atStartPeriod: Integer read Get_atStartPeriod write Set_atStartPeriod;
    property atStartYear: Integer read Get_atStartYear write Set_atStartYear;
    property atEndDate: WideString read Get_atEndDate write Set_atEndDate;
    property atEndPeriod: Integer read Get_atEndPeriod write Set_atEndPeriod;
    property atEndYear: Integer read Get_atEndYear write Set_atEndYear;
    property atAutoTransaction: WordBool read Get_atAutoTransaction write Set_atAutoTransaction;
  end;

// *********************************************************************//
// DispIntf:  IAutoTransactionSettingsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {23571D0C-3F7A-40BE-84F7-0089D1B1D197}
// *********************************************************************//
  IAutoTransactionSettingsDisp = dispinterface
    ['{23571D0C-3F7A-40BE-84F7-0089D1B1D197}']
    property atIncrementType: TAutoIncrementType dispid 1;
    property atIncrement: Integer dispid 2;
    property atAutoCreateOnPost: WordBool dispid 3;
    property atStartDate: WideString dispid 4;
    property atStartPeriod: Integer dispid 5;
    property atStartYear: Integer dispid 6;
    property atEndDate: WideString dispid 7;
    property atEndPeriod: Integer dispid 8;
    property atEndYear: Integer dispid 9;
    property atAutoTransaction: WordBool dispid 10;
  end;

// *********************************************************************//
// Interface: IPrinterDetail
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8BAC23C1-720D-446D-A59B-822943C9FAE5}
// *********************************************************************//
  IPrinterDetail = interface(IDispatch)
    ['{8BAC23C1-720D-446D-A59B-822943C9FAE5}']
    function Get_pdName: WideString; safecall;
    function Get_pdPapers: IStringListReadOnly; safecall;
    function Get_pdBins: IStringListReadOnly; safecall;
    function Get_pdDefaultPaper: Integer; safecall;
    function Get_pdDefaultBin: Integer; safecall;
    function Get_pdSupportsPapers: WordBool; safecall;
    function Get_pdSupportsBins: WordBool; safecall;
    property pdName: WideString read Get_pdName;
    property pdPapers: IStringListReadOnly read Get_pdPapers;
    property pdBins: IStringListReadOnly read Get_pdBins;
    property pdDefaultPaper: Integer read Get_pdDefaultPaper;
    property pdDefaultBin: Integer read Get_pdDefaultBin;
    property pdSupportsPapers: WordBool read Get_pdSupportsPapers;
    property pdSupportsBins: WordBool read Get_pdSupportsBins;
  end;

// *********************************************************************//
// DispIntf:  IPrinterDetailDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8BAC23C1-720D-446D-A59B-822943C9FAE5}
// *********************************************************************//
  IPrinterDetailDisp = dispinterface
    ['{8BAC23C1-720D-446D-A59B-822943C9FAE5}']
    property pdName: WideString readonly dispid 0;
    property pdPapers: IStringListReadOnly readonly dispid 1;
    property pdBins: IStringListReadOnly readonly dispid 2;
    property pdDefaultPaper: Integer readonly dispid 3;
    property pdDefaultBin: Integer readonly dispid 4;
    property pdSupportsPapers: WordBool readonly dispid 5;
    property pdSupportsBins: WordBool readonly dispid 6;
  end;

// *********************************************************************//
// Interface: IStringListReadOnly
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {933CF587-FF14-44FF-906D-297551AE00F4}
// *********************************************************************//
  IStringListReadOnly = interface(IDispatch)
    ['{933CF587-FF14-44FF-906D-297551AE00F4}']
    function Get_Strings(Index: Integer): WideString; safecall;
    function Get_Count: Integer; safecall;
    function IndexOf(const SearchText: WideString): Integer; safecall;
    property Strings[Index: Integer]: WideString read Get_Strings; default;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IStringListReadOnlyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {933CF587-FF14-44FF-906D-297551AE00F4}
// *********************************************************************//
  IStringListReadOnlyDisp = dispinterface
    ['{933CF587-FF14-44FF-906D-297551AE00F4}']
    property Strings[Index: Integer]: WideString readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    function IndexOf(const SearchText: WideString): Integer; dispid 2;
  end;

// *********************************************************************//
// Interface: IStringArrayRW
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C45C2238-F3B2-4201-90F5-606CD55C18CF}
// *********************************************************************//
  IStringArrayRW = interface(IDispatch)
    ['{C45C2238-F3B2-4201-90F5-606CD55C18CF}']
    function Get_Strings(Index: Integer): WideString; safecall;
    procedure Set_Strings(Index: Integer; const Value: WideString); safecall;
    function Get_Count: Integer; safecall;
    procedure Add(const AddString: WideString); safecall;
    procedure Delete(Index: Integer); safecall;
    property Strings[Index: Integer]: WideString read Get_Strings write Set_Strings; default;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IStringArrayRWDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C45C2238-F3B2-4201-90F5-606CD55C18CF}
// *********************************************************************//
  IStringArrayRWDisp = dispinterface
    ['{C45C2238-F3B2-4201-90F5-606CD55C18CF}']
    property Strings[Index: Integer]: WideString dispid 0; default;
    property Count: Integer readonly dispid 1;
    procedure Add(const AddString: WideString); dispid 2;
    procedure Delete(Index: Integer); dispid 3;
  end;

// *********************************************************************//
// Interface: IConvert
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E5DA8BA0-3D7F-4529-8280-D77DD949BE9F}
// *********************************************************************//
  IConvert = interface(IDispatch)
    ['{E5DA8BA0-3D7F-4529-8280-D77DD949BE9F}']
    function Get_cvStartTransaction: WideString; safecall;
    function Get_cvProcessed: Integer; safecall;
    function Get_cvEndTransaction: WideString; safecall;
    function Get_cvStartTransactionI: ITransaction; safecall;
    function Get_cvEndTransactionI: ITransaction; safecall;
    property cvStartTransaction: WideString read Get_cvStartTransaction;
    property cvProcessed: Integer read Get_cvProcessed;
    property cvEndTransaction: WideString read Get_cvEndTransaction;
    property cvStartTransactionI: ITransaction read Get_cvStartTransactionI;
    property cvEndTransactionI: ITransaction read Get_cvEndTransactionI;
  end;

// *********************************************************************//
// DispIntf:  IConvertDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E5DA8BA0-3D7F-4529-8280-D77DD949BE9F}
// *********************************************************************//
  IConvertDisp = dispinterface
    ['{E5DA8BA0-3D7F-4529-8280-D77DD949BE9F}']
    property cvStartTransaction: WideString readonly dispid 1;
    property cvProcessed: Integer readonly dispid 2;
    property cvEndTransaction: WideString readonly dispid 4;
    property cvStartTransactionI: ITransaction readonly dispid 5;
    property cvEndTransactionI: ITransaction readonly dispid 6;
  end;

// *********************************************************************//
// Interface: ISingleConvert
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {726389C6-B772-41AC-A193-CBA3BB01EDDA}
// *********************************************************************//
  ISingleConvert = interface(IConvert)
    ['{726389C6-B772-41AC-A193-CBA3BB01EDDA}']
    function Check: Integer; safecall;
    function Execute: Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  ISingleConvertDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {726389C6-B772-41AC-A193-CBA3BB01EDDA}
// *********************************************************************//
  ISingleConvertDisp = dispinterface
    ['{726389C6-B772-41AC-A193-CBA3BB01EDDA}']
    function Check: Integer; dispid 3;
    function Execute: Integer; dispid 7;
    property cvStartTransaction: WideString readonly dispid 1;
    property cvProcessed: Integer readonly dispid 2;
    property cvEndTransaction: WideString readonly dispid 4;
    property cvStartTransactionI: ITransaction readonly dispid 5;
    property cvEndTransactionI: ITransaction readonly dispid 6;
  end;

// *********************************************************************//
// Interface: IConvertList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F35EF421-66A7-4BE7-A397-A915F213C280}
// *********************************************************************//
  IConvertList = interface(IDispatch)
    ['{F35EF421-66A7-4BE7-A397-A915F213C280}']
    function Get_clConversions(Index: Integer): IConvert; safecall;
    function Get_clCount: Integer; safecall;
    procedure Add(const OurRef: WideString); safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Clear; safecall;
    function Check(var ProblemIndex: Integer): Integer; safecall;
    function Execute: Integer; safecall;
    function Get_clConsolidate: WordBool; safecall;
    procedure Set_clConsolidate(Value: WordBool); safecall;
    property clConversions[Index: Integer]: IConvert read Get_clConversions;
    property clCount: Integer read Get_clCount;
    property clConsolidate: WordBool read Get_clConsolidate write Set_clConsolidate;
  end;

// *********************************************************************//
// DispIntf:  IConvertListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F35EF421-66A7-4BE7-A397-A915F213C280}
// *********************************************************************//
  IConvertListDisp = dispinterface
    ['{F35EF421-66A7-4BE7-A397-A915F213C280}']
    property clConversions[Index: Integer]: IConvert readonly dispid 1;
    property clCount: Integer readonly dispid 2;
    procedure Add(const OurRef: WideString); dispid 3;
    procedure Delete(Index: Integer); dispid 4;
    procedure Clear; dispid 5;
    function Check(var ProblemIndex: Integer): Integer; dispid 6;
    function Execute: Integer; dispid 7;
    property clConsolidate: WordBool dispid 8;
  end;

// *********************************************************************//
// Interface: ISystemProcesses
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5E2F72CA-792A-4832-9B30-ED095E7C5D1D}
// *********************************************************************//
  ISystemProcesses = interface(IDispatch)
    ['{5E2F72CA-792A-4832-9B30-ED095E7C5D1D}']
    function ConvertToPDN: IConvertList; safecall;
    function ConvertToPIN: IConvertList; safecall;
    function ConvertToPOR: IConvertList; safecall;
    function ConvertToSDN: IConvertList; safecall;
    function ConvertToSIN: IConvertList; safecall;
    function ConvertToSOR: IConvertList; safecall;
  end;

// *********************************************************************//
// DispIntf:  ISystemProcessesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5E2F72CA-792A-4832-9B30-ED095E7C5D1D}
// *********************************************************************//
  ISystemProcessesDisp = dispinterface
    ['{5E2F72CA-792A-4832-9B30-ED095E7C5D1D}']
    function ConvertToPDN: IConvertList; dispid 3;
    function ConvertToPIN: IConvertList; dispid 4;
    function ConvertToPOR: IConvertList; dispid 5;
    function ConvertToSDN: IConvertList; dispid 6;
    function ConvertToSIN: IConvertList; dispid 7;
    function ConvertToSOR: IConvertList; dispid 8;
  end;

// *********************************************************************//
// Interface: IEmailAddress
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {696D9F72-2157-4045-B165-4832F34714D4}
// *********************************************************************//
  IEmailAddress = interface(IDispatch)
    ['{696D9F72-2157-4045-B165-4832F34714D4}']
    function Get_emlName: WideString; safecall;
    procedure Set_emlName(const Value: WideString); safecall;
    function Get_emlAddress: WideString; safecall;
    procedure Set_emlAddress(const Value: WideString); safecall;
    property emlName: WideString read Get_emlName write Set_emlName;
    property emlAddress: WideString read Get_emlAddress write Set_emlAddress;
  end;

// *********************************************************************//
// DispIntf:  IEmailAddressDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {696D9F72-2157-4045-B165-4832F34714D4}
// *********************************************************************//
  IEmailAddressDisp = dispinterface
    ['{696D9F72-2157-4045-B165-4832F34714D4}']
    property emlName: WideString dispid 1;
    property emlAddress: WideString dispid 2;
  end;

// *********************************************************************//
// Interface: IEmailAddressArray
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EE8122D5-6624-490E-8250-E8DFE46A6336}
// *********************************************************************//
  IEmailAddressArray = interface(IDispatch)
    ['{EE8122D5-6624-490E-8250-E8DFE46A6336}']
    function Get_eaItems(Index: Integer): IEmailAddress; safecall;
    function Get_eaCount: Integer; safecall;
    procedure AddAddress(const Name: WideString; const Address: WideString); safecall;
    procedure Delete(Index: Integer); safecall;
    property eaItems[Index: Integer]: IEmailAddress read Get_eaItems; default;
    property eaCount: Integer read Get_eaCount;
  end;

// *********************************************************************//
// DispIntf:  IEmailAddressArrayDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EE8122D5-6624-490E-8250-E8DFE46A6336}
// *********************************************************************//
  IEmailAddressArrayDisp = dispinterface
    ['{EE8122D5-6624-490E-8250-E8DFE46A6336}']
    property eaItems[Index: Integer]: IEmailAddress readonly dispid 0; default;
    property eaCount: Integer readonly dispid 1;
    procedure AddAddress(const Name: WideString; const Address: WideString); dispid 2;
    procedure Delete(Index: Integer); dispid 3;
  end;

// *********************************************************************//
// Interface: IBackToBackOrder
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {689697DA-91B1-4735-A920-69A4FA0F2FF8}
// *********************************************************************//
  IBackToBackOrder = interface(IDispatch)
    ['{689697DA-91B1-4735-A920-69A4FA0F2FF8}']
    function Get_bbMultipleSuppliers: WordBool; safecall;
    procedure Set_bbMultipleSuppliers(Value: WordBool); safecall;
    function Get_bbIncludeNormalLines: WordBool; safecall;
    procedure Set_bbIncludeNormalLines(Value: WordBool); safecall;
    function Get_bbIncludeLabourLines: WordBool; safecall;
    procedure Set_bbIncludeLabourLines(Value: WordBool); safecall;
    function Get_bbIncludeMaterialLines: WordBool; safecall;
    procedure Set_bbIncludeMaterialLines(Value: WordBool); safecall;
    function Get_bbIncludeFreightLines: WordBool; safecall;
    procedure Set_bbIncludeFreightLines(Value: WordBool); safecall;
    function Get_bbIncludeDiscountLines: WordBool; safecall;
    procedure Set_bbIncludeDiscountLines(Value: WordBool); safecall;
    function Get_bbQtyMode: TB2BQtyModeType; safecall;
    procedure Set_bbQtyMode(Value: TB2BQtyModeType); safecall;
    function Get_bbDefaultSupplier: WideString; safecall;
    procedure Set_bbDefaultSupplier(const Value: WideString); safecall;
    function Get_bbAutoPick: WordBool; safecall;
    procedure Set_bbAutoPick(Value: WordBool); safecall;
    function Get_bbPORCount: Integer; safecall;
    function Get_bbPORs(Index: Integer): WideString; safecall;
    function Execute: Integer; safecall;
    property bbMultipleSuppliers: WordBool read Get_bbMultipleSuppliers write Set_bbMultipleSuppliers;
    property bbIncludeNormalLines: WordBool read Get_bbIncludeNormalLines write Set_bbIncludeNormalLines;
    property bbIncludeLabourLines: WordBool read Get_bbIncludeLabourLines write Set_bbIncludeLabourLines;
    property bbIncludeMaterialLines: WordBool read Get_bbIncludeMaterialLines write Set_bbIncludeMaterialLines;
    property bbIncludeFreightLines: WordBool read Get_bbIncludeFreightLines write Set_bbIncludeFreightLines;
    property bbIncludeDiscountLines: WordBool read Get_bbIncludeDiscountLines write Set_bbIncludeDiscountLines;
    property bbQtyMode: TB2BQtyModeType read Get_bbQtyMode write Set_bbQtyMode;
    property bbDefaultSupplier: WideString read Get_bbDefaultSupplier write Set_bbDefaultSupplier;
    property bbAutoPick: WordBool read Get_bbAutoPick write Set_bbAutoPick;
    property bbPORCount: Integer read Get_bbPORCount;
    property bbPORs[Index: Integer]: WideString read Get_bbPORs;
  end;

// *********************************************************************//
// DispIntf:  IBackToBackOrderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {689697DA-91B1-4735-A920-69A4FA0F2FF8}
// *********************************************************************//
  IBackToBackOrderDisp = dispinterface
    ['{689697DA-91B1-4735-A920-69A4FA0F2FF8}']
    property bbMultipleSuppliers: WordBool dispid 1;
    property bbIncludeNormalLines: WordBool dispid 2;
    property bbIncludeLabourLines: WordBool dispid 3;
    property bbIncludeMaterialLines: WordBool dispid 4;
    property bbIncludeFreightLines: WordBool dispid 5;
    property bbIncludeDiscountLines: WordBool dispid 6;
    property bbQtyMode: TB2BQtyModeType dispid 7;
    property bbDefaultSupplier: WideString dispid 8;
    property bbAutoPick: WordBool dispid 9;
    property bbPORCount: Integer readonly dispid 11;
    property bbPORs[Index: Integer]: WideString readonly dispid 12;
    function Execute: Integer; dispid 13;
  end;

// *********************************************************************//
// Interface: ITransactionAsBatch
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA1F00BA-2309-4640-9335-911DE000B4EB}
// *********************************************************************//
  ITransactionAsBatch = interface(IDispatch)
    ['{BA1F00BA-2309-4640-9335-911DE000B4EB}']
    function Get_btTotal: Double; safecall;
    function Get_btBankGL: Integer; safecall;
    procedure Set_btBankGL(Value: Integer); safecall;
    function Get_btBatchCount: Integer; safecall;
    function Get_btBatchMembers(Index: Integer): ITransaction; safecall;
    function AddBatchMember(TransactionType: TDocTypes): ITransaction; safecall;
    function UpdateBatchMember(Index: Integer): ITransaction; safecall;
    function Get_btChequeNoStart: Integer; safecall;
    procedure Set_btChequeNoStart(Value: Integer); safecall;
    property btTotal: Double read Get_btTotal;
    property btBankGL: Integer read Get_btBankGL write Set_btBankGL;
    property btBatchCount: Integer read Get_btBatchCount;
    property btBatchMembers[Index: Integer]: ITransaction read Get_btBatchMembers;
    property btChequeNoStart: Integer read Get_btChequeNoStart write Set_btChequeNoStart;
  end;

// *********************************************************************//
// DispIntf:  ITransactionAsBatchDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA1F00BA-2309-4640-9335-911DE000B4EB}
// *********************************************************************//
  ITransactionAsBatchDisp = dispinterface
    ['{BA1F00BA-2309-4640-9335-911DE000B4EB}']
    property btTotal: Double readonly dispid 1;
    property btBankGL: Integer dispid 2;
    property btBatchCount: Integer readonly dispid 4;
    property btBatchMembers[Index: Integer]: ITransaction readonly dispid 5;
    function AddBatchMember(TransactionType: TDocTypes): ITransaction; dispid 7;
    function UpdateBatchMember(Index: Integer): ITransaction; dispid 8;
    property btChequeNoStart: Integer dispid 10;
  end;

// *********************************************************************//
// Interface: IPrinters
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BB1DDDC1-4094-46E6-9E0F-7A4DAF4C2DA7}
// *********************************************************************//
  IPrinters = interface(IDispatch)
    ['{BB1DDDC1-4094-46E6-9E0F-7A4DAF4C2DA7}']
    function Get_prPrinters(Index: Integer): IPrinterDetail; safecall;
    function Get_prCount: Integer; safecall;
    function Get_prDefaultPrinter: Integer; safecall;
    function IndexOf(const SearchText: WideString): Integer; safecall;
    property prPrinters[Index: Integer]: IPrinterDetail read Get_prPrinters; default;
    property prCount: Integer read Get_prCount;
    property prDefaultPrinter: Integer read Get_prDefaultPrinter;
  end;

// *********************************************************************//
// DispIntf:  IPrintersDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BB1DDDC1-4094-46E6-9E0F-7A4DAF4C2DA7}
// *********************************************************************//
  IPrintersDisp = dispinterface
    ['{BB1DDDC1-4094-46E6-9E0F-7A4DAF4C2DA7}']
    property prPrinters[Index: Integer]: IPrinterDetail readonly dispid 0; default;
    property prCount: Integer readonly dispid 1;
    property prDefaultPrinter: Integer readonly dispid 2;
    function IndexOf(const SearchText: WideString): Integer; dispid 3;
  end;

// *********************************************************************//
// The Class CoToolkit provides a Create and CreateRemote method to          
// create instances of the default interface IToolkit exposed by              
// the CoClass Toolkit. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoToolkit = class
    class function Create: IToolkit;
    class function CreateRemote(const MachineName: string): IToolkit;
  end;

implementation

uses ComObj;

class function CoToolkit.Create: IToolkit;
begin
  Result := CreateComObject(CLASS_Toolkit) as IToolkit;
end;

class function CoToolkit.CreateRemote(const MachineName: string): IToolkit;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Toolkit) as IToolkit;
end;

end.
