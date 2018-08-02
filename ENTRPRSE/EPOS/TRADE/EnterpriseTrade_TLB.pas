unit EnterpriseTrade_TLB;

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
// File generated on 30/06/2009 09:47:05 from Type Library described below.

// ************************************************************************  //
// Type Lib: W:\Exchequer\entrprse\EPOS\TRADE\TRADE.tlb (1)
// LIBID: {AEAD9E18-FC21-48F7-B716-8ABA1A4CB77C}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
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
  EnterpriseTradeMajorVersion = 1;
  EnterpriseTradeMinorVersion = 0;

  LIBID_EnterpriseTrade: TGUID = '{AEAD9E18-FC21-48F7-B716-8ABA1A4CB77C}';

  IID_ITradeConnectionPoint: TGUID = '{8AE10444-4EE7-4487-89B1-1995B5D06C2E}';
  IID_ITradeFunctions: TGUID = '{51A850EC-D45D-4D7A-BF98-692AB243F31F}';
  IID_ITradeSystemSetup: TGUID = '{E5797518-DC56-4CB3-AFE1-2C250CF6C1EB}';
  IID_ITradeVersion: TGUID = '{59CBCFF0-E3CD-4FD2-9FD0-8960432675B3}';
  IID_IDummy: TGUID = '{9FB0ED62-92CD-4E37-963F-FFC2BCB0CB89}';
  IID_ITradeClient: TGUID = '{DBE4FF07-1118-450F-8D83-5A2426115F36}';
  IID_ITradeEventData: TGUID = '{C3D93895-03AC-4FFE-A117-7948A6E53377}';
  IID_ITradeCustomText: TGUID = '{F6F696FF-1872-4748-9876-52395B64E4B1}';
  CLASS_Customisation: TGUID = '{C79C869B-1EA7-4E4D-93B0-9026BC56DC7B}';
  IID_ITradeEventTransaction: TGUID = '{41D740ED-BCED-4E0A-B3C2-37186F9BBC2A}';
  IID_ITradeConfiguration: TGUID = '{7B6B2EE4-A062-461A-9734-0E541F7A5172}';
  IID_ITradeUserProfile: TGUID = '{93037A36-68A8-49E5-8350-C2FE526CB0A1}';
  IID_ITradeEventTransLines: TGUID = '{A96A96BD-E733-4176-A59C-B1FBC8982F1E}';
  IID_ITradeEventTransLine: TGUID = '{2674E74B-B701-4C4B-B0E2-0A72FCFF7B8D}';
  IID_ITradeEventCustomer: TGUID = '{3AB7DFE7-0574-4AFA-9BCA-F4EBE9724CC2}';
  IID_ITradeEventTender: TGUID = '{88DFC251-C075-490A-BA6E-2226AFF8A241}';
  IID_ITradeAddress: TGUID = '{B695FE74-5AF1-4DD7-BDFE-1C627F781329}';
  IID_ITradeAccountBalance: TGUID = '{B23633AB-A1C7-42CB-81F4-5006B72E4DD3}';
  IID_ITradeStockCover: TGUID = '{695C8C69-4090-47CE-80D0-5228119CE62F}';
  IID_ITradeStockIntrastat: TGUID = '{A0E237EB-7E47-466D-82F0-FBAA7142D9FC}';
  IID_ITradeStockReorder: TGUID = '{199FCABB-9714-43C1-8523-B62052899E95}';
  IID_ITradeStockSalesBand: TGUID = '{DA37E764-11CB-4E20-ABE7-625AB7EEDDBB}';
  IID_ITradeEventStock: TGUID = '{5B25CC13-0431-4EC0-AE85-C4002AD36436}';
  IID_ITradeEventSerialNumbers: TGUID = '{479ADA2C-5B7E-44B9-B43B-86FB62C25BEB}';
  IID_ITradeEventSerialNo: TGUID = '{B4B2E301-4ABF-4FA3-9DA2-3A8E5E8F5413}';
  IID_ITradeEventLocation: TGUID = '{2CEAF9AB-0FE5-4F0A-A43A-D7BC16E39670}';
  IID_ITradeCardDetails: TGUID = '{06F68D04-5782-458A-8512-6F481039B062}';
  IID_ITradeTCMSetup: TGUID = '{2976A615-68BE-410D-BC23-CB7E5202703E}';
  IID_ITradeEntSetup: TGUID = '{C2019D7B-ED91-4B7E-92E7-6913B620B6EA}';
  IID_ITradeTCMSetupTill: TGUID = '{A5B26E62-9536-4BBB-8CB2-FCE7019A610A}';
  IID_ITradeTCMSetupCashDrawer: TGUID = '{FE26B9C3-D1BD-4338-A16A-C5A78199F0EB}';
  IID_ITradeTCMSetupPrinting: TGUID = '{4CDFB008-A9BB-4289-BF02-5618493A9AB7}';
  IID_ITradeTCMSetupPrintDet: TGUID = '{06765765-7111-4795-BD01-ACAD7D30E1B1}';
  IID_ITradeTCMSetupCreditCards: TGUID = '{C62095BE-ED82-4C84-A1D0-002A6412C1BB}';
  IID_ITradeTCMSetupCreditCard: TGUID = '{5A05DD1F-7FBE-4BCE-BC8B-4C62D8327F04}';
  IID_ITradeLocation: TGUID = '{10968605-850D-403C-84F2-8B1472E0115D}';
  IID_ITradeCompany: TGUID = '{5FFB42F5-1AFB-4490-BD07-9D70E3C073FB}';
  IID_ITradeSystemSetupVAT: TGUID = '{01B9893E-952E-42A3-9143-72349CA4DBD8}';
  IID_ITradeSystemSetupCurrency: TGUID = '{9241557C-B198-4D37-9C47-B2CEAD7F4C4B}';
  IID_ITradeSystemSetupUserFields: TGUID = '{E8905360-5A1D-43A2-ADF0-D3DEE9DB39FE}';
  IID_ITradeSystemSetupJob: TGUID = '{7B6ABABE-2A15-4414-9EFC-4E5F01E7AE54}';
  IID_ITradeEventPaymentLine: TGUID = '{8580C6DC-D7E8-47D1-A679-191BBE9B7F32}';
  IID_ITradeEventPaymentLines: TGUID = '{479DAFA4-3F69-4512-B3F8-E66436A851F6}';
  IID_ITradeEventTender2: TGUID = '{9F8A005F-17D1-4BB4-A7EA-9E4D09E83F17}';
  IID_ITradeEventSerialNo2: TGUID = '{07CFBE13-F7D4-4532-B1FD-7F1D571BB73E}';
  IID_ITradeEventTransLine2: TGUID = '{6DA20229-75BA-4E84-A5C7-18C50463638C}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TTradeWindowIds
type
  TTradeWindowIds = TOleEnum;
const
  twiSystem = $00000000;
  twiLogin = $00000001;
  twiTransaction = $00000002;
  twiTransactionLine = $00000003;
  twiNonStock = $00000004;
  twiSerialNumbers = $00000005;
  twiTender = $00000006;
  twiCreditCard = $00000007;

// Constants for enum TTradeHookStatus
type
  TTradeHookStatus = TOleEnum;
const
  thsDisabled = $00000000;
  thsEnabled = $00000001;
  thsEnabledOther = $00000002;

// Constants for enum TTradeTransLineType
type
  TTradeTransLineType = TOleEnum;
const
  tlTypeNormal = $00000000;
  tlTypeLabour = $00000001;
  tlTypeMaterials = $00000002;
  tlTypeFreight = $00000003;
  tlTypeDiscount = $00000004;

// Constants for enum TTradeDocTypes
type
  TTradeDocTypes = TOleEnum;
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

// Constants for enum TTradeIntrastatProcess
type
  TTradeIntrastatProcess = TOleEnum;
const
  ipNormal = $00000000;
  ipTriangulation = $00000001;
  ipProcess = $00000002;

// Constants for enum TTradeAccountStatus
type
  TTradeAccountStatus = TOleEnum;
const
  asOpen = $00000000;
  asNotes = $00000001;
  asOnHold = $00000002;
  asClosed = $00000003;

// Constants for enum TTradeEmailAttachmentZIPType
type
  TTradeEmailAttachmentZIPType = TOleEnum;
const
  emZIPNone = $00000000;
  emZIPPKZIP = $00000001;
  emZIPEDZ = $00000002;

// Constants for enum TTradeStockType
type
  TTradeStockType = TOleEnum;
const
  stTypeGroup = $00000000;
  stTypeProduct = $00000001;
  stTypeDescription = $00000002;
  stTypeBillOfMaterials = $00000003;
  stTypeDiscontinued = $00000004;

// Constants for enum TTradeStockValuationType
type
  TTradeStockValuationType = TOleEnum;
const
  stValStandard = $00000000;
  stValLastCost = $00000001;
  stValFIFO = $00000002;
  stValLIFO = $00000003;
  stValAverage = $00000004;
  stValSerial = $00000005;
  stValSerialAvgCost = $00000006;

// Constants for enum TTradeStockPricingMethod
type
  TTradeStockPricingMethod = TOleEnum;
const
  spmByStockUnit = $00000000;
  spmBySalesUnit = $00000001;
  spmBySplitPack = $00000002;

// Constants for enum TTradeSerialBatchType
type
  TTradeSerialBatchType = TOleEnum;
const
  snTypeSerial = $00000000;
  snTypeBatch = $00000001;
  snTypeBatchSale = $00000002;

// Constants for enum TTradeAfterTender
type
  TTradeAfterTender = TOleEnum;
const
  atNewTransaction = $00000000;
  atReturnToLogin = $00000001;

// Constants for enum TTradeCreateTXType
type
  TTradeCreateTXType = TOleEnum;
const
  ctSINSRI = $00000000;
  ctPickedSOR = $00000001;
  ctUnpickedSOR = $00000002;

// Constants for enum TTradeCreateNegTXType
type
  TTradeCreateNegTXType = TOleEnum;
const
  cnSINSRI = $00000000;
  cnSRFSCR = $00000001;

// Constants for enum TTradeDiscountType
type
  TTradeDiscountType = TOleEnum;
const
  dtAdditionalTCMDiscounts = $00000000;
  dtEnterpriseDiscounts = $00000001;

// Constants for enum TTradeTakeNonStockDefaultFrom
type
  TTradeTakeNonStockDefaultFrom = TOleEnum;
const
  nsSystemSetup = $00000000;
  nsStockItem = $00000001;

// Constants for enum TTradeCCDeptMode
type
  TTradeCCDeptMode = TOleEnum;
const
  ccCustomer = $00000000;
  ccEnterpriseRules = $00000001;
  ccSystemSetupDefaults = $00000002;

// Constants for enum TTradeBaudRate
type
  TTradeBaudRate = TOleEnum;
const
  br9600 = $00000000;
  br19200 = $00000001;
  br38400 = $00000002;
  br57600 = $00000003;
  br115200 = $00000004;

// Constants for enum TTradeCurrencyRateType
type
  TTradeCurrencyRateType = TOleEnum;
const
  rtCompany = $00000000;
  rtDaily = $00000001;

// Constants for enum TTradeEnterpriseCurrencyVersion
type
  TTradeEnterpriseCurrencyVersion = TOleEnum;
const
  enProfessional = $00000000;
  enEuro = $00000001;
  enGlobal = $00000002;

// Constants for enum TTradeJobCategoryType
type
  TTradeJobCategoryType = TOleEnum;
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

// Constants for enum TTradeEmailPriority
type
  TTradeEmailPriority = TOleEnum;
const
  epLow = $00000000;
  epNormal = $00000001;
  epHigh = $00000002;

// Constants for enum TTradeEmailAttachMethod
type
  TTradeEmailAttachMethod = TOleEnum;
const
  eamInternal = $00000000;
  eamAcrobat = $00000001;
  eamInternalPDF = $00000002;

// Constants for enum TTradeFaxMethod
type
  TTradeFaxMethod = TOleEnum;
const
  fmEnterprise = $00000000;
  fmMAPI = $00000001;
  fmThirdParty = $00000002;

// Constants for enum TTradeSystemSetupGLCtrlType
type
  TTradeSystemSetupGLCtrlType = TOleEnum;
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

// Constants for enum TTradeSystemSetupJobGLCtrlType
type
  TTradeSystemSetupJobGLCtrlType = TOleEnum;
const
  ssjGLOverhead = $00000000;
  ssjGLProdution = $00000001;
  ssjGLSubContract = $00000002;

// Constants for enum TTradeEntModuleVersion
type
  TTradeEntModuleVersion = TOleEnum;
const
  enModStandard = $00000000;
  enModStock = $00000001;
  enModSPOP = $00000002;

// Constants for enum TTradeLicenceType
type
  TTradeLicenceType = TOleEnum;
const
  ltCustomer = $00000000;
  ltResellerDemo = $00000001;
  ltStandardDemo = $00000002;

// Constants for enum TTradeModule
type
  TTradeModule = TOleEnum;
const
  modAccountStockAnalysis = $00000000;
  modImportModule = $00000001;
  modJobCosting = $00000002;
  modODBC = $00000003;
  modReportWriter = $00000004;
  modTeleSales = $00000005;
  modToolDLLDev = $00000006;
  modToolDLLRunTime = $00000007;
  modEBusiness = $00000008;
  modPaperless = $00000009;
  modOLESaveFunctions = $0000000A;
  modCommitment = $0000000B;
  modTradeCounter = $0000000C;
  modStandardWOP = $0000000D;
  modProfessionalWOP = $0000000E;
  modSentimail = $0000000F;
  modEnhancedSecurity = $00000010;

// Constants for enum TTradeModuleRelease
type
  TTradeModuleRelease = TOleEnum;
const
  mrDisabled = $00000000;
  mr30Day = $00000001;
  mrEnabled = $00000002;

// Constants for enum TTradePriorityRuleType
type
  TTradePriorityRuleType = TOleEnum;
const
  prStkAccOp = $00000000;
  prAccStkOp = $00000001;
  prOpAccStk = $00000002;
  prOpStkAcc = $00000003;

// Constants for enum TTradeSecurityResultType
type
  TTradeSecurityResultType = TOleEnum;
const
  srNoAccess = $00000000;
  srAccess = $00000001;

// Constants for enum TTradeUserDefinedFieldNo
type
  TTradeUserDefinedFieldNo = TOleEnum;
const
  uf1 = $00000001;
  uf2 = $00000002;
  uf3 = $00000003;
  uf4 = $00000004;

// Constants for enum TTradeTXHeadHookPoint
type
  TTradeTXHeadHookPoint = TOleEnum;
const
  hpTXHeadCustom1 = $00000001;
  hpTXHeadCustom2 = $00000002;
  hpTXExitCustCodeBeforeVal = $00000003;
  hpTXExitCustCodeAfterVal = $00000004;
  hpTXBeforeTenderScreen = $00000005;
  hpTXInitialise = $00000006;

// Constants for enum TTradeTXLineHookPoint
type
  TTradeTXLineHookPoint = TOleEnum;
const
  hpTXLineCustom1 = $00000001;
  hpTXLineCustom2 = $00000002;
  hpTXLineInitialise = $00000003;
  hpTXLineEnterQuantity = $00000004;
  hpTXLineBeforeStore = $00000005;
  hpTXLineBeforeCalcStockPrice = $00000006;

// Constants for enum TTradeNonStockHookPoint
type
  TTradeNonStockHookPoint = TOleEnum;
const
  hpNonStockCustom1 = $00000001;
  hpNonStockCustom2 = $00000002;
  hpNonStockEnterQuantity = $00000003;
  hpNonStockBeforeStore = $00000004;

// Constants for enum TTradeSerialHookPoint
type
  TTradeSerialHookPoint = TOleEnum;
const
  hpSerialCustom1 = $00000001;
  hpSerialCustom2 = $00000002;

// Constants for enum TTradeTenderHookPoint
type
  TTradeTenderHookPoint = TOleEnum;
const
  hpTenderCustom1 = $00000001;
  hpTenderCustom2 = $00000002;
  hpOnFireCashDrawer = $00000003;
  hpTenderOnTender = $00000004;
  hpTenderOnShow = $00000005;
  hpTenderOnShowChange = $00000006;
  hpTenderBeforePrint = $00000007;

// Constants for enum TTradeCreditCardHookPoint
type
  TTradeCreditCardHookPoint = TOleEnum;
const
  hpCreditCardCustom1 = $00000001;
  hpCreditCardCustom2 = $00000002;
  hpCreditCardBeforeShow = $00000003;

// Constants for enum TTradeTXHeadCustomText
type
  TTradeTXHeadCustomText = TOleEnum;
const
  ctTXHeadCustomButton1 = $00000001;
  ctTXHeadCustomButton2 = $00000002;

// Constants for enum TTradeTXLineCustomText
type
  TTradeTXLineCustomText = TOleEnum;
const
  ctTXLineCustomButton1 = $00000001;
  ctTXLineCustomButton2 = $00000002;

// Constants for enum TTradeNonStockCustomText
type
  TTradeNonStockCustomText = TOleEnum;
const
  ctNonStockCustomButton1 = $00000001;
  ctNonStockCustomButton2 = $00000002;

// Constants for enum TTradeSerialCustomText
type
  TTradeSerialCustomText = TOleEnum;
const
  ctSerialCustomButton1 = $00000001;
  ctSerialCustomButton2 = $00000002;

// Constants for enum TTradeTenderCustomText
type
  TTradeTenderCustomText = TOleEnum;
const
  ctTenderCustomButton1 = $00000001;
  ctTenderCustomButton2 = $00000002;
  ctTenderMOPButton1 = $00000003;
  ctTenderMOPButton2 = $00000004;
  ctTenderMOPButton3 = $00000005;

// Constants for enum TTradeCreditCardCustomText
type
  TTradeCreditCardCustomText = TOleEnum;
const
  ctCreditCardCustomButton1 = $00000001;
  ctCreditCardCustomButton2 = $00000002;

// Constants for enum TTradePrintTo
type
  TTradePrintTo = TOleEnum;
const
  ptReceiptPrinter = $00000000;
  ptInvoicePrinter = $00000001;
  ptOrderPrinter = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ITradeConnectionPoint = interface;
  ITradeConnectionPointDisp = dispinterface;
  ITradeFunctions = interface;
  ITradeFunctionsDisp = dispinterface;
  ITradeSystemSetup = interface;
  ITradeSystemSetupDisp = dispinterface;
  ITradeVersion = interface;
  ITradeVersionDisp = dispinterface;
  IDummy = interface;
  IDummyDisp = dispinterface;
  ITradeClient = interface;
  ITradeClientDisp = dispinterface;
  ITradeEventData = interface;
  ITradeEventDataDisp = dispinterface;
  ITradeCustomText = interface;
  ITradeCustomTextDisp = dispinterface;
  ITradeEventTransaction = interface;
  ITradeEventTransactionDisp = dispinterface;
  ITradeConfiguration = interface;
  ITradeConfigurationDisp = dispinterface;
  ITradeUserProfile = interface;
  ITradeUserProfileDisp = dispinterface;
  ITradeEventTransLines = interface;
  ITradeEventTransLinesDisp = dispinterface;
  ITradeEventTransLine = interface;
  ITradeEventTransLineDisp = dispinterface;
  ITradeEventCustomer = interface;
  ITradeEventCustomerDisp = dispinterface;
  ITradeEventTender = interface;
  ITradeEventTenderDisp = dispinterface;
  ITradeAddress = interface;
  ITradeAddressDisp = dispinterface;
  ITradeAccountBalance = interface;
  ITradeAccountBalanceDisp = dispinterface;
  ITradeStockCover = interface;
  ITradeStockCoverDisp = dispinterface;
  ITradeStockIntrastat = interface;
  ITradeStockIntrastatDisp = dispinterface;
  ITradeStockReorder = interface;
  ITradeStockReorderDisp = dispinterface;
  ITradeStockSalesBand = interface;
  ITradeStockSalesBandDisp = dispinterface;
  ITradeEventStock = interface;
  ITradeEventStockDisp = dispinterface;
  ITradeEventSerialNumbers = interface;
  ITradeEventSerialNumbersDisp = dispinterface;
  ITradeEventSerialNo = interface;
  ITradeEventSerialNoDisp = dispinterface;
  ITradeEventLocation = interface;
  ITradeEventLocationDisp = dispinterface;
  ITradeCardDetails = interface;
  ITradeCardDetailsDisp = dispinterface;
  ITradeTCMSetup = interface;
  ITradeTCMSetupDisp = dispinterface;
  ITradeEntSetup = interface;
  ITradeEntSetupDisp = dispinterface;
  ITradeTCMSetupTill = interface;
  ITradeTCMSetupTillDisp = dispinterface;
  ITradeTCMSetupCashDrawer = interface;
  ITradeTCMSetupCashDrawerDisp = dispinterface;
  ITradeTCMSetupPrinting = interface;
  ITradeTCMSetupPrintingDisp = dispinterface;
  ITradeTCMSetupPrintDet = interface;
  ITradeTCMSetupPrintDetDisp = dispinterface;
  ITradeTCMSetupCreditCards = interface;
  ITradeTCMSetupCreditCardsDisp = dispinterface;
  ITradeTCMSetupCreditCard = interface;
  ITradeTCMSetupCreditCardDisp = dispinterface;
  ITradeLocation = interface;
  ITradeLocationDisp = dispinterface;
  ITradeCompany = interface;
  ITradeCompanyDisp = dispinterface;
  ITradeSystemSetupVAT = interface;
  ITradeSystemSetupVATDisp = dispinterface;
  ITradeSystemSetupCurrency = interface;
  ITradeSystemSetupCurrencyDisp = dispinterface;
  ITradeSystemSetupUserFields = interface;
  ITradeSystemSetupUserFieldsDisp = dispinterface;
  ITradeSystemSetupJob = interface;
  ITradeSystemSetupJobDisp = dispinterface;
  ITradeEventPaymentLine = interface;
  ITradeEventPaymentLineDisp = dispinterface;
  ITradeEventPaymentLines = interface;
  ITradeEventPaymentLinesDisp = dispinterface;
  ITradeEventTender2 = interface;
  ITradeEventTender2Disp = dispinterface;
  ITradeEventSerialNo2 = interface;
  ITradeEventSerialNo2Disp = dispinterface;
  ITradeEventTransLine2 = interface;
  ITradeEventTransLine2Disp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Customisation = IDummy;


// *********************************************************************//
// Interface: ITradeConnectionPoint
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8AE10444-4EE7-4487-89B1-1995B5D06C2E}
// *********************************************************************//
  ITradeConnectionPoint = interface(IDispatch)
    ['{8AE10444-4EE7-4487-89B1-1995B5D06C2E}']
    function Get_piCustomisationSupport: WideString; safecall;
    procedure Set_piCustomisationSupport(const Value: WideString); safecall;
    function Get_piName: WideString; safecall;
    procedure Set_piName(const Value: WideString); safecall;
    function Get_piVersion: WideString; safecall;
    procedure Set_piVersion(const Value: WideString); safecall;
    function Get_piAuthor: WideString; safecall;
    procedure Set_piAuthor(const Value: WideString); safecall;
    function Get_piSupport: WideString; safecall;
    procedure Set_piSupport(const Value: WideString); safecall;
    function Get_piCopyright: WideString; safecall;
    procedure Set_piCopyright(const Value: WideString); safecall;
    function Get_piHookPoints(WindowId: TTradeWindowIds; HandlerId: Integer): TTradeHookStatus; safecall;
    procedure Set_piHookPoints(WindowId: TTradeWindowIds; HandlerId: Integer; 
                               Value: TTradeHookStatus); safecall;
    function Get_piCustomText(WindowId: TTradeWindowIds; TextId: Integer): TTradeHookStatus; safecall;
    procedure Set_piCustomText(WindowId: TTradeWindowIds; TextId: Integer; Value: TTradeHookStatus); safecall;
    function Get_Functions: ITradeFunctions; safecall;
    function Get_SystemSetup: ITradeSystemSetup; safecall;
    function Get_Version: ITradeVersion; safecall;
    function Get_UserProfile: ITradeUserProfile; safecall;
    property piCustomisationSupport: WideString read Get_piCustomisationSupport write Set_piCustomisationSupport;
    property piName: WideString read Get_piName write Set_piName;
    property piVersion: WideString read Get_piVersion write Set_piVersion;
    property piAuthor: WideString read Get_piAuthor write Set_piAuthor;
    property piSupport: WideString read Get_piSupport write Set_piSupport;
    property piCopyright: WideString read Get_piCopyright write Set_piCopyright;
    property piHookPoints[WindowId: TTradeWindowIds; HandlerId: Integer]: TTradeHookStatus read Get_piHookPoints write Set_piHookPoints;
    property piCustomText[WindowId: TTradeWindowIds; TextId: Integer]: TTradeHookStatus read Get_piCustomText write Set_piCustomText;
    property Functions: ITradeFunctions read Get_Functions;
    property SystemSetup: ITradeSystemSetup read Get_SystemSetup;
    property Version: ITradeVersion read Get_Version;
    property UserProfile: ITradeUserProfile read Get_UserProfile;
  end;

// *********************************************************************//
// DispIntf:  ITradeConnectionPointDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8AE10444-4EE7-4487-89B1-1995B5D06C2E}
// *********************************************************************//
  ITradeConnectionPointDisp = dispinterface
    ['{8AE10444-4EE7-4487-89B1-1995B5D06C2E}']
    property piCustomisationSupport: WideString dispid 1;
    property piName: WideString dispid 2;
    property piVersion: WideString dispid 3;
    property piAuthor: WideString dispid 4;
    property piSupport: WideString dispid 5;
    property piCopyright: WideString dispid 6;
    property piHookPoints[WindowId: TTradeWindowIds; HandlerId: Integer]: TTradeHookStatus dispid 7;
    property piCustomText[WindowId: TTradeWindowIds; TextId: Integer]: TTradeHookStatus dispid 8;
    property Functions: ITradeFunctions readonly dispid 9;
    property SystemSetup: ITradeSystemSetup readonly dispid 10;
    property Version: ITradeVersion readonly dispid 11;
    property UserProfile: ITradeUserProfile readonly dispid 12;
  end;

// *********************************************************************//
// Interface: ITradeFunctions
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {51A850EC-D45D-4D7A-BF98-692AB243F31F}
// *********************************************************************//
  ITradeFunctions = interface(IDispatch)
    ['{51A850EC-D45D-4D7A-BF98-692AB243F31F}']
    function Get_fnTradehWnd: Integer; safecall;
    procedure entActivateClient(ClientHandle: Integer); safecall;
    function entFormatDate(const EntDateStr: WideString; const DateFormat: WideString): WideString; safecall;
    function entRound(Value: Double; Decs: Integer): Double; safecall;
    function entFormatPeriodYear(Period: Integer; Year: Integer): WideString; safecall;
    function entConvertAmount(Amount: Double; FromCurrency: Integer; ToCurrency: Integer; 
                              RateType: Integer): Double; safecall;
    function entConvertDateToPeriod(const DateString: WideString; var FinancialPeriod: Integer; 
                                    var FinancialYear: Integer): Integer; safecall;
    function entConvertAmountWithRates(Amount: Double; ConvertToBase: WordBool; 
                                       RateCurrency: Integer; CompanyRate: Double; DailyRate: Double): Double; safecall;
    procedure entOpenCashDrawer(COMPort: Integer; BaudRate: TTradeBaudRate; 
                                const KickOutCodes: WideString); safecall;
    property fnTradehWnd: Integer read Get_fnTradehWnd;
  end;

// *********************************************************************//
// DispIntf:  ITradeFunctionsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {51A850EC-D45D-4D7A-BF98-692AB243F31F}
// *********************************************************************//
  ITradeFunctionsDisp = dispinterface
    ['{51A850EC-D45D-4D7A-BF98-692AB243F31F}']
    property fnTradehWnd: Integer readonly dispid 1;
    procedure entActivateClient(ClientHandle: Integer); dispid 2;
    function entFormatDate(const EntDateStr: WideString; const DateFormat: WideString): WideString; dispid 3;
    function entRound(Value: Double; Decs: Integer): Double; dispid 4;
    function entFormatPeriodYear(Period: Integer; Year: Integer): WideString; dispid 5;
    function entConvertAmount(Amount: Double; FromCurrency: Integer; ToCurrency: Integer; 
                              RateType: Integer): Double; dispid 6;
    function entConvertDateToPeriod(const DateString: WideString; var FinancialPeriod: Integer; 
                                    var FinancialYear: Integer): Integer; dispid 7;
    function entConvertAmountWithRates(Amount: Double; ConvertToBase: WordBool; 
                                       RateCurrency: Integer; CompanyRate: Double; DailyRate: Double): Double; dispid 8;
    procedure entOpenCashDrawer(COMPort: Integer; BaudRate: TTradeBaudRate; 
                                const KickOutCodes: WideString); dispid 9;
  end;

// *********************************************************************//
// Interface: ITradeSystemSetup
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E5797518-DC56-4CB3-AFE1-2C250CF6C1EB}
// *********************************************************************//
  ITradeSystemSetup = interface(IDispatch)
    ['{E5797518-DC56-4CB3-AFE1-2C250CF6C1EB}']
    function Get_ssTradeCounter: ITradeTCMSetup; safecall;
    function Get_ssEnterprise: ITradeEntSetup; safecall;
    property ssTradeCounter: ITradeTCMSetup read Get_ssTradeCounter;
    property ssEnterprise: ITradeEntSetup read Get_ssEnterprise;
  end;

// *********************************************************************//
// DispIntf:  ITradeSystemSetupDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E5797518-DC56-4CB3-AFE1-2C250CF6C1EB}
// *********************************************************************//
  ITradeSystemSetupDisp = dispinterface
    ['{E5797518-DC56-4CB3-AFE1-2C250CF6C1EB}']
    property ssTradeCounter: ITradeTCMSetup readonly dispid 1;
    property ssEnterprise: ITradeEntSetup readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ITradeVersion
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {59CBCFF0-E3CD-4FD2-9FD0-8960432675B3}
// *********************************************************************//
  ITradeVersion = interface(IDispatch)
    ['{59CBCFF0-E3CD-4FD2-9FD0-8960432675B3}']
    function Get_verTradeCounter: WideString; safecall;
    function Get_verCustomisation: WideString; safecall;
    function Get_verModuleVersion: TTradeEntModuleVersion; safecall;
    function Get_verCurrencyVersion: TTradeEnterpriseCurrencyVersion; safecall;
    function Get_verClientServer: WordBool; safecall;
    function Get_verLicenceType: TTradeLicenceType; safecall;
    function verModules(Module: TTradeModule): TTradeModuleRelease; safecall;
    property verTradeCounter: WideString read Get_verTradeCounter;
    property verCustomisation: WideString read Get_verCustomisation;
    property verModuleVersion: TTradeEntModuleVersion read Get_verModuleVersion;
    property verCurrencyVersion: TTradeEnterpriseCurrencyVersion read Get_verCurrencyVersion;
    property verClientServer: WordBool read Get_verClientServer;
    property verLicenceType: TTradeLicenceType read Get_verLicenceType;
  end;

// *********************************************************************//
// DispIntf:  ITradeVersionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {59CBCFF0-E3CD-4FD2-9FD0-8960432675B3}
// *********************************************************************//
  ITradeVersionDisp = dispinterface
    ['{59CBCFF0-E3CD-4FD2-9FD0-8960432675B3}']
    property verTradeCounter: WideString readonly dispid 1;
    property verCustomisation: WideString readonly dispid 2;
    property verModuleVersion: TTradeEntModuleVersion readonly dispid 3;
    property verCurrencyVersion: TTradeEnterpriseCurrencyVersion readonly dispid 4;
    property verClientServer: WordBool readonly dispid 5;
    property verLicenceType: TTradeLicenceType readonly dispid 6;
    function verModules(Module: TTradeModule): TTradeModuleRelease; dispid 8;
  end;

// *********************************************************************//
// Interface: IDummy
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9FB0ED62-92CD-4E37-963F-FFC2BCB0CB89}
// *********************************************************************//
  IDummy = interface(IDispatch)
    ['{9FB0ED62-92CD-4E37-963F-FFC2BCB0CB89}']
  end;

// *********************************************************************//
// DispIntf:  IDummyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9FB0ED62-92CD-4E37-963F-FFC2BCB0CB89}
// *********************************************************************//
  IDummyDisp = dispinterface
    ['{9FB0ED62-92CD-4E37-963F-FFC2BCB0CB89}']
  end;

// *********************************************************************//
// Interface: ITradeClient
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DBE4FF07-1118-450F-8D83-5A2426115F36}
// *********************************************************************//
  ITradeClient = interface(IDispatch)
    ['{DBE4FF07-1118-450F-8D83-5A2426115F36}']
    procedure OnConfigure(const Config: ITradeConfiguration); safecall;
    procedure OnStartup(const BaseData: ITradeConnectionPoint); safecall;
    procedure OnCustomEvent(const EventData: ITradeEventData); safecall;
    procedure OnCustomText(const CustomText: ITradeCustomText); safecall;
    procedure OnShutdown; safecall;
  end;

// *********************************************************************//
// DispIntf:  ITradeClientDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DBE4FF07-1118-450F-8D83-5A2426115F36}
// *********************************************************************//
  ITradeClientDisp = dispinterface
    ['{DBE4FF07-1118-450F-8D83-5A2426115F36}']
    procedure OnConfigure(const Config: ITradeConfiguration); dispid 1;
    procedure OnStartup(const BaseData: ITradeConnectionPoint); dispid 2;
    procedure OnCustomEvent(const EventData: ITradeEventData); dispid 3;
    procedure OnCustomText(const CustomText: ITradeCustomText); dispid 4;
    procedure OnShutdown; dispid 5;
  end;

// *********************************************************************//
// Interface: ITradeEventData
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C3D93895-03AC-4FFE-A117-7948A6E53377}
// *********************************************************************//
  ITradeEventData = interface(IDispatch)
    ['{C3D93895-03AC-4FFE-A117-7948A6E53377}']
    function Get_edWindowId: TTradeWindowIds; safecall;
    function Get_edHandlerId: Integer; safecall;
    function Get_Transaction: ITradeEventTransaction; safecall;
    function Get_edBoolResult(Index: Integer): WordBool; safecall;
    procedure Set_edBoolResult(Index: Integer; Value: WordBool); safecall;
    function Get_edStringResult(Index: Integer): WideString; safecall;
    procedure Set_edStringResult(Index: Integer; const Value: WideString); safecall;
    function Get_edLongResult(Index: Integer): Integer; safecall;
    procedure Set_edLongResult(Index: Integer; Value: Integer); safecall;
    function Get_edDoubleResult(Index: Integer): Double; safecall;
    procedure Set_edDoubleResult(Index: Integer; Value: Double); safecall;
    function Get_edVariantResult(Index: Integer): OleVariant; safecall;
    procedure Set_edVariantResult(Index: Integer; Value: OleVariant); safecall;
    property edWindowId: TTradeWindowIds read Get_edWindowId;
    property edHandlerId: Integer read Get_edHandlerId;
    property Transaction: ITradeEventTransaction read Get_Transaction;
    property edBoolResult[Index: Integer]: WordBool read Get_edBoolResult write Set_edBoolResult;
    property edStringResult[Index: Integer]: WideString read Get_edStringResult write Set_edStringResult;
    property edLongResult[Index: Integer]: Integer read Get_edLongResult write Set_edLongResult;
    property edDoubleResult[Index: Integer]: Double read Get_edDoubleResult write Set_edDoubleResult;
    property edVariantResult[Index: Integer]: OleVariant read Get_edVariantResult write Set_edVariantResult;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventDataDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C3D93895-03AC-4FFE-A117-7948A6E53377}
// *********************************************************************//
  ITradeEventDataDisp = dispinterface
    ['{C3D93895-03AC-4FFE-A117-7948A6E53377}']
    property edWindowId: TTradeWindowIds readonly dispid 1;
    property edHandlerId: Integer readonly dispid 2;
    property Transaction: ITradeEventTransaction readonly dispid 5;
    property edBoolResult[Index: Integer]: WordBool dispid 10;
    property edStringResult[Index: Integer]: WideString dispid 11;
    property edLongResult[Index: Integer]: Integer dispid 12;
    property edDoubleResult[Index: Integer]: Double dispid 13;
    property edVariantResult[Index: Integer]: OleVariant dispid 14;
  end;

// *********************************************************************//
// Interface: ITradeCustomText
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F6F696FF-1872-4748-9876-52395B64E4B1}
// *********************************************************************//
  ITradeCustomText = interface(IDispatch)
    ['{F6F696FF-1872-4748-9876-52395B64E4B1}']
    function Get_ctWindowId: TTradeWindowIds; safecall;
    function Get_ctTextId: Integer; safecall;
    function Get_ctText: WideString; safecall;
    procedure Set_ctText(const Value: WideString); safecall;
    property ctWindowId: TTradeWindowIds read Get_ctWindowId;
    property ctTextId: Integer read Get_ctTextId;
    property ctText: WideString read Get_ctText write Set_ctText;
  end;

// *********************************************************************//
// DispIntf:  ITradeCustomTextDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F6F696FF-1872-4748-9876-52395B64E4B1}
// *********************************************************************//
  ITradeCustomTextDisp = dispinterface
    ['{F6F696FF-1872-4748-9876-52395B64E4B1}']
    property ctWindowId: TTradeWindowIds readonly dispid 1;
    property ctTextId: Integer readonly dispid 2;
    property ctText: WideString dispid 3;
  end;

// *********************************************************************//
// Interface: ITradeEventTransaction
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {41D740ED-BCED-4E0A-B3C2-37186F9BBC2A}
// *********************************************************************//
  ITradeEventTransaction = interface(IDispatch)
    ['{41D740ED-BCED-4E0A-B3C2-37186F9BBC2A}']
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
    function Get_thDocType: TTradeDocTypes; safecall;
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
    function Get_thDelAddress: ITradeAddress; safecall;
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
    function Get_thTagNo: Integer; safecall;
    procedure Set_thTagNo(Value: Integer); safecall;
    function Get_thNoLabels: Smallint; safecall;
    procedure Set_thNoLabels(Value: Smallint); safecall;
    function Get_thControlGL: Integer; safecall;
    procedure Set_thControlGL(Value: Integer); safecall;
    function Get_thProcess: TTradeIntrastatProcess; safecall;
    procedure Set_thProcess(Value: TTradeIntrastatProcess); safecall;
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
    function Get_thEmployeeCode: WideString; safecall;
    procedure Set_thEmployeeCode(const Value: WideString); safecall;
    function Get_thLines: ITradeEventTransLines; safecall;
    function Get_thPaymentLines: ITradeEventPaymentLines; safecall;
    function Get_thCustomer: ITradeEventCustomer; safecall;
    function Get_thTender: ITradeEventTender; safecall;
    procedure Recalculate; safecall;
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
    property thDocType: TTradeDocTypes read Get_thDocType;
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
    property thDelAddress: ITradeAddress read Get_thDelAddress;
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
    property thTagNo: Integer read Get_thTagNo write Set_thTagNo;
    property thNoLabels: Smallint read Get_thNoLabels write Set_thNoLabels;
    property thControlGL: Integer read Get_thControlGL write Set_thControlGL;
    property thProcess: TTradeIntrastatProcess read Get_thProcess write Set_thProcess;
    property thSource: Integer read Get_thSource;
    property thPostedDate: WideString read Get_thPostedDate;
    property thPORPickSOR: WordBool read Get_thPORPickSOR write Set_thPORPickSOR;
    property thBatchDiscAmount: Double read Get_thBatchDiscAmount write Set_thBatchDiscAmount;
    property thPrePost: Integer read Get_thPrePost write Set_thPrePost;
    property thOutstanding: WideString read Get_thOutstanding;
    property thFixedRate: WordBool read Get_thFixedRate write Set_thFixedRate;
    property thLongYourRef: WideString read Get_thLongYourRef write Set_thLongYourRef;
    property thEmployeeCode: WideString read Get_thEmployeeCode write Set_thEmployeeCode;
    property thLines: ITradeEventTransLines read Get_thLines;
    property thPaymentLines: ITradeEventPaymentLines read Get_thPaymentLines;
    property thCustomer: ITradeEventCustomer read Get_thCustomer;
    property thTender: ITradeEventTender read Get_thTender;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventTransactionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {41D740ED-BCED-4E0A-B3C2-37186F9BBC2A}
// *********************************************************************//
  ITradeEventTransactionDisp = dispinterface
    ['{41D740ED-BCED-4E0A-B3C2-37186F9BBC2A}']
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
    property thDocType: TTradeDocTypes readonly dispid 13;
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
    property thDelAddress: ITradeAddress readonly dispid 27;
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
    property thTagNo: Integer dispid 40;
    property thNoLabels: Smallint dispid 41;
    property thControlGL: Integer dispid 42;
    property thProcess: TTradeIntrastatProcess dispid 43;
    property thSource: Integer readonly dispid 44;
    property thPostedDate: WideString readonly dispid 45;
    property thPORPickSOR: WordBool dispid 46;
    property thBatchDiscAmount: Double dispid 47;
    property thPrePost: Integer dispid 48;
    property thOutstanding: WideString readonly dispid 49;
    property thFixedRate: WordBool dispid 50;
    property thLongYourRef: WideString dispid 51;
    property thEmployeeCode: WideString dispid 67;
    property thLines: ITradeEventTransLines readonly dispid 52;
    property thPaymentLines: ITradeEventPaymentLines readonly dispid 53;
    property thCustomer: ITradeEventCustomer readonly dispid 58;
    property thTender: ITradeEventTender readonly dispid 59;
    procedure Recalculate; dispid 54;
  end;

// *********************************************************************//
// Interface: ITradeConfiguration
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7B6B2EE4-A062-461A-9734-0E541F7A5172}
// *********************************************************************//
  ITradeConfiguration = interface(IDispatch)
    ['{7B6B2EE4-A062-461A-9734-0E541F7A5172}']
    function Get_cfEnterpriseDirectory: WideString; safecall;
    function Get_cfDataDirectory: WideString; safecall;
    function Get_cfLocalTradeDirectory: WideString; safecall;
    property cfEnterpriseDirectory: WideString read Get_cfEnterpriseDirectory;
    property cfDataDirectory: WideString read Get_cfDataDirectory;
    property cfLocalTradeDirectory: WideString read Get_cfLocalTradeDirectory;
  end;

// *********************************************************************//
// DispIntf:  ITradeConfigurationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7B6B2EE4-A062-461A-9734-0E541F7A5172}
// *********************************************************************//
  ITradeConfigurationDisp = dispinterface
    ['{7B6B2EE4-A062-461A-9734-0E541F7A5172}']
    property cfEnterpriseDirectory: WideString readonly dispid 2;
    property cfDataDirectory: WideString readonly dispid 3;
    property cfLocalTradeDirectory: WideString readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ITradeUserProfile
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {93037A36-68A8-49E5-8350-C2FE526CB0A1}
// *********************************************************************//
  ITradeUserProfile = interface(IDispatch)
    ['{93037A36-68A8-49E5-8350-C2FE526CB0A1}']
    function Get_upUserID: WideString; safecall;
    function Get_upName: WideString; safecall;
    function Get_upLockOutMins: Integer; safecall;
    function Get_upEmail: WideString; safecall;
    function Get_upDefSRICust: WideString; safecall;
    function Get_upDefPPISupp: WideString; safecall;
    function Get_upMaxSalesAuth: Double; safecall;
    function Get_upMaxPurchAuth: Double; safecall;
    function Get_upDefSalesBankGL: Integer; safecall;
    function Get_upDefPurchBankGL: Integer; safecall;
    function Get_upCCDeptRule: TTradePriorityRuleType; safecall;
    function Get_upDefCostCentre: WideString; safecall;
    function Get_upDefDepartment: WideString; safecall;
    function Get_upDefLocation: WideString; safecall;
    function Get_upDefLocRule: TTradePriorityRuleType; safecall;
    function Get_upSecurityFlags(Index: Integer): TTradeSecurityResultType; safecall;
    property upUserID: WideString read Get_upUserID;
    property upName: WideString read Get_upName;
    property upLockOutMins: Integer read Get_upLockOutMins;
    property upEmail: WideString read Get_upEmail;
    property upDefSRICust: WideString read Get_upDefSRICust;
    property upDefPPISupp: WideString read Get_upDefPPISupp;
    property upMaxSalesAuth: Double read Get_upMaxSalesAuth;
    property upMaxPurchAuth: Double read Get_upMaxPurchAuth;
    property upDefSalesBankGL: Integer read Get_upDefSalesBankGL;
    property upDefPurchBankGL: Integer read Get_upDefPurchBankGL;
    property upCCDeptRule: TTradePriorityRuleType read Get_upCCDeptRule;
    property upDefCostCentre: WideString read Get_upDefCostCentre;
    property upDefDepartment: WideString read Get_upDefDepartment;
    property upDefLocation: WideString read Get_upDefLocation;
    property upDefLocRule: TTradePriorityRuleType read Get_upDefLocRule;
    property upSecurityFlags[Index: Integer]: TTradeSecurityResultType read Get_upSecurityFlags;
  end;

// *********************************************************************//
// DispIntf:  ITradeUserProfileDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {93037A36-68A8-49E5-8350-C2FE526CB0A1}
// *********************************************************************//
  ITradeUserProfileDisp = dispinterface
    ['{93037A36-68A8-49E5-8350-C2FE526CB0A1}']
    property upUserID: WideString readonly dispid 1;
    property upName: WideString readonly dispid 2;
    property upLockOutMins: Integer readonly dispid 7;
    property upEmail: WideString readonly dispid 8;
    property upDefSRICust: WideString readonly dispid 26;
    property upDefPPISupp: WideString readonly dispid 27;
    property upMaxSalesAuth: Double readonly dispid 28;
    property upMaxPurchAuth: Double readonly dispid 29;
    property upDefSalesBankGL: Integer readonly dispid 30;
    property upDefPurchBankGL: Integer readonly dispid 31;
    property upCCDeptRule: TTradePriorityRuleType readonly dispid 36;
    property upDefCostCentre: WideString readonly dispid 37;
    property upDefDepartment: WideString readonly dispid 38;
    property upDefLocation: WideString readonly dispid 39;
    property upDefLocRule: TTradePriorityRuleType readonly dispid 40;
    property upSecurityFlags[Index: Integer]: TTradeSecurityResultType readonly dispid 41;
  end;

// *********************************************************************//
// Interface: ITradeEventTransLines
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A96A96BD-E733-4176-A59C-B1FBC8982F1E}
// *********************************************************************//
  ITradeEventTransLines = interface(IDispatch)
    ['{A96A96BD-E733-4176-A59C-B1FBC8982F1E}']
    function Get_thLine(Index: Integer): ITradeEventTransLine; safecall;
    function Get_thCurrentLine: ITradeEventTransLine; safecall;
    function Get_thLineCount: Integer; safecall;
    procedure Add; safecall;
    procedure Delete(LineNo: Integer); safecall;
    property thLine[Index: Integer]: ITradeEventTransLine read Get_thLine; default;
    property thCurrentLine: ITradeEventTransLine read Get_thCurrentLine;
    property thLineCount: Integer read Get_thLineCount;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventTransLinesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A96A96BD-E733-4176-A59C-B1FBC8982F1E}
// *********************************************************************//
  ITradeEventTransLinesDisp = dispinterface
    ['{A96A96BD-E733-4176-A59C-B1FBC8982F1E}']
    property thLine[Index: Integer]: ITradeEventTransLine readonly dispid 0; default;
    property thCurrentLine: ITradeEventTransLine readonly dispid 3;
    property thLineCount: Integer readonly dispid 4;
    procedure Add; dispid 1;
    procedure Delete(LineNo: Integer); dispid 2;
  end;

// *********************************************************************//
// Interface: ITradeEventTransLine
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2674E74B-B701-4C4B-B0E2-0A72FCFF7B8D}
// *********************************************************************//
  ITradeEventTransLine = interface(IDispatch)
    ['{2674E74B-B701-4C4B-B0E2-0A72FCFF7B8D}']
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
    function Get_tlLocation: ITradeEventLocation; safecall;
    function Get_tlChargeCurrency: Integer; safecall;
    procedure Set_tlChargeCurrency(Value: Integer); safecall;
    function Get_tlAcCode: WideString; safecall;
    function Get_tlLineType: TTradeTransLineType; safecall;
    procedure Set_tlLineType(Value: TTradeTransLineType); safecall;
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
    function Get_tlStock: ITradeEventStock; safecall;
    function Get_tlSerialNumbers: ITradeEventSerialNumbers; safecall;
    procedure Save; safecall;
    procedure Cancel; safecall;
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
    property tlLocation: ITradeEventLocation read Get_tlLocation;
    property tlChargeCurrency: Integer read Get_tlChargeCurrency write Set_tlChargeCurrency;
    property tlAcCode: WideString read Get_tlAcCode;
    property tlLineType: TTradeTransLineType read Get_tlLineType write Set_tlLineType;
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
    property tlStock: ITradeEventStock read Get_tlStock;
    property tlSerialNumbers: ITradeEventSerialNumbers read Get_tlSerialNumbers;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventTransLineDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2674E74B-B701-4C4B-B0E2-0A72FCFF7B8D}
// *********************************************************************//
  ITradeEventTransLineDisp = dispinterface
    ['{2674E74B-B701-4C4B-B0E2-0A72FCFF7B8D}']
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
    property tlLocation: ITradeEventLocation readonly dispid 26;
    property tlChargeCurrency: Integer dispid 27;
    property tlAcCode: WideString readonly dispid 28;
    property tlLineType: TTradeTransLineType dispid 29;
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
    property tlStock: ITradeEventStock readonly dispid 50;
    property tlSerialNumbers: ITradeEventSerialNumbers readonly dispid 52;
    procedure Save; dispid 53;
    procedure Cancel; dispid 54;
  end;

// *********************************************************************//
// Interface: ITradeEventCustomer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3AB7DFE7-0574-4AFA-9BCA-F4EBE9724CC2}
// *********************************************************************//
  ITradeEventCustomer = interface(IDispatch)
    ['{3AB7DFE7-0574-4AFA-9BCA-F4EBE9724CC2}']
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
    function Get_acAddress: ITradeAddress; safecall;
    function Get_acDelAddress: ITradeAddress; safecall;
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
    function Get_acAccStatus: TTradeAccountStatus; safecall;
    procedure Set_acAccStatus(Value: TTradeAccountStatus); safecall;
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
    function Get_acZIPAttachments: TTradeEmailAttachmentZIPType; safecall;
    procedure Set_acZIPAttachments(Value: TTradeEmailAttachmentZIPType); safecall;
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
    property acCode: WideString read Get_acCode write Set_acCode;
    property acCompany: WideString read Get_acCompany write Set_acCompany;
    property acArea: WideString read Get_acArea write Set_acArea;
    property acAccType: WideString read Get_acAccType write Set_acAccType;
    property acStatementTo: WideString read Get_acStatementTo write Set_acStatementTo;
    property acVATRegNo: WideString read Get_acVATRegNo write Set_acVATRegNo;
    property acAddress: ITradeAddress read Get_acAddress;
    property acDelAddress: ITradeAddress read Get_acDelAddress;
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
    property acAccStatus: TTradeAccountStatus read Get_acAccStatus write Set_acAccStatus;
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
    property acZIPAttachments: TTradeEmailAttachmentZIPType read Get_acZIPAttachments write Set_acZIPAttachments;
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
  end;

// *********************************************************************//
// DispIntf:  ITradeEventCustomerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3AB7DFE7-0574-4AFA-9BCA-F4EBE9724CC2}
// *********************************************************************//
  ITradeEventCustomerDisp = dispinterface
    ['{3AB7DFE7-0574-4AFA-9BCA-F4EBE9724CC2}']
    property acCode: WideString dispid 1;
    property acCompany: WideString dispid 2;
    property acArea: WideString dispid 3;
    property acAccType: WideString dispid 4;
    property acStatementTo: WideString dispid 5;
    property acVATRegNo: WideString dispid 6;
    property acAddress: ITradeAddress readonly dispid 7;
    property acDelAddress: ITradeAddress readonly dispid 8;
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
    property acAccStatus: TTradeAccountStatus dispid 28;
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
    property acZIPAttachments: TTradeEmailAttachmentZIPType dispid 59;
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
  end;

// *********************************************************************//
// Interface: ITradeEventTender
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {88DFC251-C075-490A-BA6E-2226AFF8A241}
// *********************************************************************//
  ITradeEventTender = interface(IDispatch)
    ['{88DFC251-C075-490A-BA6E-2226AFF8A241}']
    function Get_teCash: Double; safecall;
    procedure Set_teCash(Value: Double); safecall;
    function Get_teCheque: Double; safecall;
    procedure Set_teCheque(Value: Double); safecall;
    function Get_teCard: Double; safecall;
    procedure Set_teCard(Value: Double); safecall;
    function Get_teAccount: Double; safecall;
    function Get_teCardDetails: ITradeCardDetails; safecall;
    property teCash: Double read Get_teCash write Set_teCash;
    property teCheque: Double read Get_teCheque write Set_teCheque;
    property teCard: Double read Get_teCard write Set_teCard;
    property teAccount: Double read Get_teAccount;
    property teCardDetails: ITradeCardDetails read Get_teCardDetails;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventTenderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {88DFC251-C075-490A-BA6E-2226AFF8A241}
// *********************************************************************//
  ITradeEventTenderDisp = dispinterface
    ['{88DFC251-C075-490A-BA6E-2226AFF8A241}']
    property teCash: Double dispid 1;
    property teCheque: Double dispid 2;
    property teCard: Double dispid 3;
    property teAccount: Double readonly dispid 5;
    property teCardDetails: ITradeCardDetails readonly dispid 6;
  end;

// *********************************************************************//
// Interface: ITradeAddress
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B695FE74-5AF1-4DD7-BDFE-1C627F781329}
// *********************************************************************//
  ITradeAddress = interface(IDispatch)
    ['{B695FE74-5AF1-4DD7-BDFE-1C627F781329}']
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
    procedure AssignAddress(const Address: ITradeAddress); safecall;
    property Lines[Index: Integer]: WideString read Get_Lines write Set_Lines; default;
    property Street1: WideString read Get_Street1 write Set_Street1;
    property Street2: WideString read Get_Street2 write Set_Street2;
    property Town: WideString read Get_Town write Set_Town;
    property County: WideString read Get_County write Set_County;
    property PostCode: WideString read Get_PostCode write Set_PostCode;
  end;

// *********************************************************************//
// DispIntf:  ITradeAddressDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B695FE74-5AF1-4DD7-BDFE-1C627F781329}
// *********************************************************************//
  ITradeAddressDisp = dispinterface
    ['{B695FE74-5AF1-4DD7-BDFE-1C627F781329}']
    property Lines[Index: Integer]: WideString dispid 0; default;
    property Street1: WideString dispid 1;
    property Street2: WideString dispid 2;
    property Town: WideString dispid 3;
    property County: WideString dispid 4;
    property PostCode: WideString dispid 5;
    procedure AssignAddress(const Address: ITradeAddress); dispid 6;
  end;

// *********************************************************************//
// Interface: ITradeAccountBalance
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B23633AB-A1C7-42CB-81F4-5006B72E4DD3}
// *********************************************************************//
  ITradeAccountBalance = interface(IDispatch)
    ['{B23633AB-A1C7-42CB-81F4-5006B72E4DD3}']
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
// DispIntf:  ITradeAccountBalanceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B23633AB-A1C7-42CB-81F4-5006B72E4DD3}
// *********************************************************************//
  ITradeAccountBalanceDisp = dispinterface
    ['{B23633AB-A1C7-42CB-81F4-5006B72E4DD3}']
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
// Interface: ITradeStockCover
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {695C8C69-4090-47CE-80D0-5228119CE62F}
// *********************************************************************//
  ITradeStockCover = interface(IDispatch)
    ['{695C8C69-4090-47CE-80D0-5228119CE62F}']
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
// DispIntf:  ITradeStockCoverDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {695C8C69-4090-47CE-80D0-5228119CE62F}
// *********************************************************************//
  ITradeStockCoverDisp = dispinterface
    ['{695C8C69-4090-47CE-80D0-5228119CE62F}']
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
// Interface: ITradeStockIntrastat
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A0E237EB-7E47-466D-82F0-FBAA7142D9FC}
// *********************************************************************//
  ITradeStockIntrastat = interface(IDispatch)
    ['{A0E237EB-7E47-466D-82F0-FBAA7142D9FC}']
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
// DispIntf:  ITradeStockIntrastatDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A0E237EB-7E47-466D-82F0-FBAA7142D9FC}
// *********************************************************************//
  ITradeStockIntrastatDisp = dispinterface
    ['{A0E237EB-7E47-466D-82F0-FBAA7142D9FC}']
    property stSSDCommodityCode: WideString dispid 1;
    property stSSDSalesUnitWeight: Double dispid 2;
    property stSSDPurchaseUnitWeight: Double dispid 3;
    property stSSDUnitDesc: WideString dispid 4;
    property stSSDStockUnits: Double dispid 5;
    property stSSDDespatchUplift: Double dispid 6;
    property stSSDCountry: WideString dispid 7;
  end;

// *********************************************************************//
// Interface: ITradeStockReorder
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {199FCABB-9714-43C1-8523-B62052899E95}
// *********************************************************************//
  ITradeStockReorder = interface(IDispatch)
    ['{199FCABB-9714-43C1-8523-B62052899E95}']
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
// DispIntf:  ITradeStockReorderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {199FCABB-9714-43C1-8523-B62052899E95}
// *********************************************************************//
  ITradeStockReorderDisp = dispinterface
    ['{199FCABB-9714-43C1-8523-B62052899E95}']
    property stReorderQty: Double dispid 1;
    property stReorderCur: Smallint dispid 2;
    property stReorderPrice: Double dispid 3;
    property stReorderDate: WideString dispid 4;
    property stReorderCostCentre: WideString dispid 5;
    property stReorderDepartment: WideString dispid 6;
  end;

// *********************************************************************//
// Interface: ITradeStockSalesBand
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DA37E764-11CB-4E20-ABE7-625AB7EEDDBB}
// *********************************************************************//
  ITradeStockSalesBand = interface(IDispatch)
    ['{DA37E764-11CB-4E20-ABE7-625AB7EEDDBB}']
    function Get_stPrice: Double; safecall;
    procedure Set_stPrice(Value: Double); safecall;
    function Get_stCurrency: Integer; safecall;
    procedure Set_stCurrency(Value: Integer); safecall;
    property stPrice: Double read Get_stPrice write Set_stPrice;
    property stCurrency: Integer read Get_stCurrency write Set_stCurrency;
  end;

// *********************************************************************//
// DispIntf:  ITradeStockSalesBandDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DA37E764-11CB-4E20-ABE7-625AB7EEDDBB}
// *********************************************************************//
  ITradeStockSalesBandDisp = dispinterface
    ['{DA37E764-11CB-4E20-ABE7-625AB7EEDDBB}']
    property stPrice: Double dispid 1;
    property stCurrency: Integer dispid 2;
  end;

// *********************************************************************//
// Interface: ITradeEventStock
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5B25CC13-0431-4EC0-AE85-C4002AD36436}
// *********************************************************************//
  ITradeEventStock = interface(IDispatch)
    ['{5B25CC13-0431-4EC0-AE85-C4002AD36436}']
    function Get_stCode: WideString; safecall;
    procedure Set_stCode(const Value: WideString); safecall;
    function Get_stDesc(Index: Integer): WideString; safecall;
    procedure Set_stDesc(Index: Integer; const Value: WideString); safecall;
    function Get_stAltCode: WideString; safecall;
    procedure Set_stAltCode(const Value: WideString); safecall;
    function Get_stType: TTradeStockType; safecall;
    procedure Set_stType(Value: TTradeStockType); safecall;
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
    function Get_stCover: ITradeStockCover; safecall;
    function Get_stIntrastat: ITradeStockIntrastat; safecall;
    function Get_stReorder: ITradeStockReorder; safecall;
    function Get_stAnalysisCode: WideString; safecall;
    procedure Set_stAnalysisCode(const Value: WideString); safecall;
    function Get_stSalesBands(const Band: WideString): ITradeStockSalesBand; safecall;
    function Get_stTimeChange: WideString; safecall;
    function Get_stInclusiveVATCode: WideString; safecall;
    procedure Set_stInclusiveVATCode(const Value: WideString); safecall;
    function Get_stOperator: WideString; safecall;
    procedure Set_stOperator(const Value: WideString); safecall;
    function Get_stSupplier: WideString; safecall;
    procedure Set_stSupplier(const Value: WideString); safecall;
    function Get_stDefaultLineType: TTradeTransLineType; safecall;
    procedure Set_stDefaultLineType(Value: TTradeTransLineType); safecall;
    function Get_stValuationMethod: TTradeStockValuationType; safecall;
    procedure Set_stValuationMethod(Value: TTradeStockValuationType); safecall;
    function Get_stQtyPicked: Double; safecall;
    function Get_stLastUsed: WideString; safecall;
    function Get_stBarCode: WideString; safecall;
    procedure Set_stBarCode(const Value: WideString); safecall;
    function Get_stPricingMethod: TTradeStockPricingMethod; safecall;
    procedure Set_stPricingMethod(Value: TTradeStockPricingMethod); safecall;
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
    function Get_stQtyFree: Double; safecall;
    property stCode: WideString read Get_stCode write Set_stCode;
    property stDesc[Index: Integer]: WideString read Get_stDesc write Set_stDesc;
    property stAltCode: WideString read Get_stAltCode write Set_stAltCode;
    property stType: TTradeStockType read Get_stType write Set_stType;
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
    property stCover: ITradeStockCover read Get_stCover;
    property stIntrastat: ITradeStockIntrastat read Get_stIntrastat;
    property stReorder: ITradeStockReorder read Get_stReorder;
    property stAnalysisCode: WideString read Get_stAnalysisCode write Set_stAnalysisCode;
    property stSalesBands[const Band: WideString]: ITradeStockSalesBand read Get_stSalesBands;
    property stTimeChange: WideString read Get_stTimeChange;
    property stInclusiveVATCode: WideString read Get_stInclusiveVATCode write Set_stInclusiveVATCode;
    property stOperator: WideString read Get_stOperator write Set_stOperator;
    property stSupplier: WideString read Get_stSupplier write Set_stSupplier;
    property stDefaultLineType: TTradeTransLineType read Get_stDefaultLineType write Set_stDefaultLineType;
    property stValuationMethod: TTradeStockValuationType read Get_stValuationMethod write Set_stValuationMethod;
    property stQtyPicked: Double read Get_stQtyPicked;
    property stLastUsed: WideString read Get_stLastUsed;
    property stBarCode: WideString read Get_stBarCode write Set_stBarCode;
    property stPricingMethod: TTradeStockPricingMethod read Get_stPricingMethod write Set_stPricingMethod;
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
    property stQtyFree: Double read Get_stQtyFree;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventStockDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5B25CC13-0431-4EC0-AE85-C4002AD36436}
// *********************************************************************//
  ITradeEventStockDisp = dispinterface
    ['{5B25CC13-0431-4EC0-AE85-C4002AD36436}']
    property stCode: WideString dispid 1;
    property stDesc[Index: Integer]: WideString dispid 2;
    property stAltCode: WideString dispid 3;
    property stType: TTradeStockType dispid 4;
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
    property stCover: ITradeStockCover readonly dispid 37;
    property stIntrastat: ITradeStockIntrastat readonly dispid 38;
    property stReorder: ITradeStockReorder readonly dispid 39;
    property stAnalysisCode: WideString dispid 40;
    property stSalesBands[const Band: WideString]: ITradeStockSalesBand readonly dispid 41;
    property stTimeChange: WideString readonly dispid 42;
    property stInclusiveVATCode: WideString dispid 43;
    property stOperator: WideString dispid 44;
    property stSupplier: WideString dispid 45;
    property stDefaultLineType: TTradeTransLineType dispid 47;
    property stValuationMethod: TTradeStockValuationType dispid 52;
    property stQtyPicked: Double readonly dispid 53;
    property stLastUsed: WideString readonly dispid 54;
    property stBarCode: WideString dispid 55;
    property stPricingMethod: TTradeStockPricingMethod dispid 57;
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
    property stQtyFree: Double readonly dispid 69;
  end;

// *********************************************************************//
// Interface: ITradeEventSerialNumbers
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {479ADA2C-5B7E-44B9-B43B-86FB62C25BEB}
// *********************************************************************//
  ITradeEventSerialNumbers = interface(IDispatch)
    ['{479ADA2C-5B7E-44B9-B43B-86FB62C25BEB}']
    function Get_snUsed(Index: Integer): ITradeEventSerialNo; safecall;
    function Get_snAvailable(Index: Integer): ITradeEventSerialNo; safecall;
    function Get_snUsedCount: Integer; safecall;
    function Get_snAvailableCount: Integer; safecall;
    procedure Refresh; safecall;
    procedure Select(Index: Integer; Quantity: Integer); safecall;
    procedure Deselect(Index: Integer; Quantity: Integer); safecall;
    property snUsed[Index: Integer]: ITradeEventSerialNo read Get_snUsed;
    property snAvailable[Index: Integer]: ITradeEventSerialNo read Get_snAvailable;
    property snUsedCount: Integer read Get_snUsedCount;
    property snAvailableCount: Integer read Get_snAvailableCount;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventSerialNumbersDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {479ADA2C-5B7E-44B9-B43B-86FB62C25BEB}
// *********************************************************************//
  ITradeEventSerialNumbersDisp = dispinterface
    ['{479ADA2C-5B7E-44B9-B43B-86FB62C25BEB}']
    property snUsed[Index: Integer]: ITradeEventSerialNo readonly dispid 1;
    property snAvailable[Index: Integer]: ITradeEventSerialNo readonly dispid 2;
    property snUsedCount: Integer readonly dispid 3;
    property snAvailableCount: Integer readonly dispid 4;
    procedure Refresh; dispid 5;
    procedure Select(Index: Integer; Quantity: Integer); dispid 6;
    procedure Deselect(Index: Integer; Quantity: Integer); dispid 7;
  end;

// *********************************************************************//
// Interface: ITradeEventSerialNo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B4B2E301-4ABF-4FA3-9DA2-3A8E5E8F5413}
// *********************************************************************//
  ITradeEventSerialNo = interface(IDispatch)
    ['{B4B2E301-4ABF-4FA3-9DA2-3A8E5E8F5413}']
    function Get_snSerialNo: WideString; safecall;
    procedure Set_snSerialNo(const Value: WideString); safecall;
    function Get_snBatchNo: WideString; safecall;
    procedure Set_snBatchNo(const Value: WideString); safecall;
    function Get_snType: TTradeSerialBatchType; safecall;
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
    function Get_snBatchQtySelected: Integer; safecall;
    function Get_snBatchQtyAvailable: Integer; safecall;
    property snSerialNo: WideString read Get_snSerialNo write Set_snSerialNo;
    property snBatchNo: WideString read Get_snBatchNo write Set_snBatchNo;
    property snType: TTradeSerialBatchType read Get_snType;
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
    property snBatchQtySelected: Integer read Get_snBatchQtySelected;
    property snBatchQtyAvailable: Integer read Get_snBatchQtyAvailable;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventSerialNoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B4B2E301-4ABF-4FA3-9DA2-3A8E5E8F5413}
// *********************************************************************//
  ITradeEventSerialNoDisp = dispinterface
    ['{B4B2E301-4ABF-4FA3-9DA2-3A8E5E8F5413}']
    property snSerialNo: WideString dispid 1;
    property snBatchNo: WideString dispid 2;
    property snType: TTradeSerialBatchType readonly dispid 3;
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
    property snBatchQtySelected: Integer readonly dispid 6;
    property snBatchQtyAvailable: Integer readonly dispid 7;
  end;

// *********************************************************************//
// Interface: ITradeEventLocation
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2CEAF9AB-0FE5-4F0A-A43A-D7BC16E39670}
// *********************************************************************//
  ITradeEventLocation = interface(IDispatch)
    ['{2CEAF9AB-0FE5-4F0A-A43A-D7BC16E39670}']
    function Get_loCode: WideString; safecall;
    procedure Set_loCode(const Value: WideString); safecall;
    function Get_loName: WideString; safecall;
    procedure Set_loName(const Value: WideString); safecall;
    function Get_loAddress: ITradeAddress; safecall;
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
    function Get_loQtyInStock: Double; safecall;
    function Get_loQtyOnOrder: Double; safecall;
    function Get_loQtyAllocated: Double; safecall;
    function Get_loQtyPicked: Double; safecall;
    function Get_loQtyMin: Double; safecall;
    procedure Set_loQtyMin(Value: Double); safecall;
    function Get_loQtyMax: Double; safecall;
    procedure Set_loQtyMax(Value: Double); safecall;
    function Get_loQtyFreeze: Double; safecall;
    function Get_loReorderQty: Double; safecall;
    procedure Set_loReorderQty(Value: Double); safecall;
    function Get_loReorderCur: Smallint; safecall;
    procedure Set_loReorderCur(Value: Smallint); safecall;
    function Get_loReorderPrice: Double; safecall;
    procedure Set_loReorderPrice(Value: Double); safecall;
    function Get_loReorderDate: WideString; safecall;
    procedure Set_loReorderDate(const Value: WideString); safecall;
    function Get_loReorderCostCentre: WideString; safecall;
    procedure Set_loReorderCostCentre(const Value: WideString); safecall;
    function Get_loReorderDepartment: WideString; safecall;
    procedure Set_loReorderDepartment(const Value: WideString); safecall;
    function Get_loBinLocation: WideString; safecall;
    procedure Set_loBinLocation(const Value: WideString); safecall;
    function Get_loCostPriceCur: Integer; safecall;
    procedure Set_loCostPriceCur(Value: Integer); safecall;
    function Get_loCostPrice: Double; safecall;
    procedure Set_loCostPrice(Value: Double); safecall;
    function Get_loBelowMinLevel: WordBool; safecall;
    procedure Set_loBelowMinLevel(Value: WordBool); safecall;
    function Get_loSuppTemp: WideString; safecall;
    procedure Set_loSuppTemp(const Value: WideString); safecall;
    function Get_loSupplier: WideString; safecall;
    procedure Set_loSupplier(const Value: WideString); safecall;
    function Get_loLastUsed: WideString; safecall;
    function Get_loQtyPosted: Double; safecall;
    function Get_loQtyStockTake: Double; safecall;
    procedure Set_loQtyStockTake(Value: Double); safecall;
    function Get_loTimeChange: WideString; safecall;
    function Get_loSalesBands(const Band: WideString): ITradeStockSalesBand; safecall;
    function Get_loQtyFree: Double; safecall;
    property loCode: WideString read Get_loCode write Set_loCode;
    property loName: WideString read Get_loName write Set_loName;
    property loAddress: ITradeAddress read Get_loAddress;
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
    property loQtyInStock: Double read Get_loQtyInStock;
    property loQtyOnOrder: Double read Get_loQtyOnOrder;
    property loQtyAllocated: Double read Get_loQtyAllocated;
    property loQtyPicked: Double read Get_loQtyPicked;
    property loQtyMin: Double read Get_loQtyMin write Set_loQtyMin;
    property loQtyMax: Double read Get_loQtyMax write Set_loQtyMax;
    property loQtyFreeze: Double read Get_loQtyFreeze;
    property loReorderQty: Double read Get_loReorderQty write Set_loReorderQty;
    property loReorderCur: Smallint read Get_loReorderCur write Set_loReorderCur;
    property loReorderPrice: Double read Get_loReorderPrice write Set_loReorderPrice;
    property loReorderDate: WideString read Get_loReorderDate write Set_loReorderDate;
    property loReorderCostCentre: WideString read Get_loReorderCostCentre write Set_loReorderCostCentre;
    property loReorderDepartment: WideString read Get_loReorderDepartment write Set_loReorderDepartment;
    property loBinLocation: WideString read Get_loBinLocation write Set_loBinLocation;
    property loCostPriceCur: Integer read Get_loCostPriceCur write Set_loCostPriceCur;
    property loCostPrice: Double read Get_loCostPrice write Set_loCostPrice;
    property loBelowMinLevel: WordBool read Get_loBelowMinLevel write Set_loBelowMinLevel;
    property loSuppTemp: WideString read Get_loSuppTemp write Set_loSuppTemp;
    property loSupplier: WideString read Get_loSupplier write Set_loSupplier;
    property loLastUsed: WideString read Get_loLastUsed;
    property loQtyPosted: Double read Get_loQtyPosted;
    property loQtyStockTake: Double read Get_loQtyStockTake write Set_loQtyStockTake;
    property loTimeChange: WideString read Get_loTimeChange;
    property loSalesBands[const Band: WideString]: ITradeStockSalesBand read Get_loSalesBands;
    property loQtyFree: Double read Get_loQtyFree;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventLocationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2CEAF9AB-0FE5-4F0A-A43A-D7BC16E39670}
// *********************************************************************//
  ITradeEventLocationDisp = dispinterface
    ['{2CEAF9AB-0FE5-4F0A-A43A-D7BC16E39670}']
    property loCode: WideString dispid 1;
    property loName: WideString dispid 2;
    property loAddress: ITradeAddress readonly dispid 3;
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
    property loQtyInStock: Double readonly dispid 25;
    property loQtyOnOrder: Double readonly dispid 26;
    property loQtyAllocated: Double readonly dispid 27;
    property loQtyPicked: Double readonly dispid 28;
    property loQtyMin: Double dispid 29;
    property loQtyMax: Double dispid 30;
    property loQtyFreeze: Double readonly dispid 31;
    property loReorderQty: Double dispid 32;
    property loReorderCur: Smallint dispid 33;
    property loReorderPrice: Double dispid 34;
    property loReorderDate: WideString dispid 35;
    property loReorderCostCentre: WideString dispid 36;
    property loReorderDepartment: WideString dispid 37;
    property loBinLocation: WideString dispid 38;
    property loCostPriceCur: Integer dispid 39;
    property loCostPrice: Double dispid 40;
    property loBelowMinLevel: WordBool dispid 41;
    property loSuppTemp: WideString dispid 42;
    property loSupplier: WideString dispid 43;
    property loLastUsed: WideString readonly dispid 44;
    property loQtyPosted: Double readonly dispid 45;
    property loQtyStockTake: Double dispid 46;
    property loTimeChange: WideString readonly dispid 47;
    property loSalesBands[const Band: WideString]: ITradeStockSalesBand readonly dispid 48;
    property loQtyFree: Double readonly dispid 49;
  end;

// *********************************************************************//
// Interface: ITradeCardDetails
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {06F68D04-5782-458A-8512-6F481039B062}
// *********************************************************************//
  ITradeCardDetails = interface(IDispatch)
    ['{06F68D04-5782-458A-8512-6F481039B062}']
    function Get_cdCardType: Integer; safecall;
    procedure Set_cdCardType(Value: Integer); safecall;
    function Get_cdCardNumber: WideString; safecall;
    procedure Set_cdCardNumber(const Value: WideString); safecall;
    function Get_cdCardName: WideString; safecall;
    procedure Set_cdCardName(const Value: WideString); safecall;
    function Get_cdExpiryDate: WideString; safecall;
    procedure Set_cdExpiryDate(const Value: WideString); safecall;
    function Get_cdAuthorisationCode: WideString; safecall;
    procedure Set_cdAuthorisationCode(const Value: WideString); safecall;
    property cdCardType: Integer read Get_cdCardType write Set_cdCardType;
    property cdCardNumber: WideString read Get_cdCardNumber write Set_cdCardNumber;
    property cdCardName: WideString read Get_cdCardName write Set_cdCardName;
    property cdExpiryDate: WideString read Get_cdExpiryDate write Set_cdExpiryDate;
    property cdAuthorisationCode: WideString read Get_cdAuthorisationCode write Set_cdAuthorisationCode;
  end;

// *********************************************************************//
// DispIntf:  ITradeCardDetailsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {06F68D04-5782-458A-8512-6F481039B062}
// *********************************************************************//
  ITradeCardDetailsDisp = dispinterface
    ['{06F68D04-5782-458A-8512-6F481039B062}']
    property cdCardType: Integer dispid 1;
    property cdCardNumber: WideString dispid 2;
    property cdCardName: WideString dispid 3;
    property cdExpiryDate: WideString dispid 4;
    property cdAuthorisationCode: WideString dispid 5;
  end;

// *********************************************************************//
// Interface: ITradeTCMSetup
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2976A615-68BE-410D-BC23-CB7E5202703E}
// *********************************************************************//
  ITradeTCMSetup = interface(IDispatch)
    ['{2976A615-68BE-410D-BC23-CB7E5202703E}']
    function Get_ssTill(Index: Integer): ITradeTCMSetupTill; safecall;
    function Get_ssNoOfTills: Integer; safecall;
    function Get_ssCurrentTillNo: Integer; safecall;
    function Get_ssLocalTradeDir: WideString; safecall;
    property ssTill[Index: Integer]: ITradeTCMSetupTill read Get_ssTill;
    property ssNoOfTills: Integer read Get_ssNoOfTills;
    property ssCurrentTillNo: Integer read Get_ssCurrentTillNo;
    property ssLocalTradeDir: WideString read Get_ssLocalTradeDir;
  end;

// *********************************************************************//
// DispIntf:  ITradeTCMSetupDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2976A615-68BE-410D-BC23-CB7E5202703E}
// *********************************************************************//
  ITradeTCMSetupDisp = dispinterface
    ['{2976A615-68BE-410D-BC23-CB7E5202703E}']
    property ssTill[Index: Integer]: ITradeTCMSetupTill readonly dispid 2;
    property ssNoOfTills: Integer readonly dispid 1;
    property ssCurrentTillNo: Integer readonly dispid 3;
    property ssLocalTradeDir: WideString readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ITradeEntSetup
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C2019D7B-ED91-4B7E-92E7-6913B620B6EA}
// *********************************************************************//
  ITradeEntSetup = interface(IDispatch)
    ['{C2019D7B-ED91-4B7E-92E7-6913B620B6EA}']
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
    property ssPromptToPrintReceipt: WordBool read Get_ssPromptToPrintReceipt;
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
    property ssCurrencyRateType: TTradeCurrencyRateType read Get_ssCurrencyRateType;
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
    property ssGLCtrlCodes[Index: TTradeSystemSetupGLCtrlType]: Integer read Get_ssGLCtrlCodes;
    property ssDebtChaseDays[Index: Integer]: Smallint read Get_ssDebtChaseDays;
    property ssTermsofTrade[Index: Integer]: WideString read Get_ssTermsofTrade;
    property ssVATRates[const Index: WideString]: ITradeSystemSetupVAT read Get_ssVATRates;
    property ssCurrency[Index: Integer]: ITradeSystemSetupCurrency read Get_ssCurrency;
    property ssUserFields: ITradeSystemSetupUserFields read Get_ssUserFields;
    property ssPickingOrderAllocatesStock: WordBool read Get_ssPickingOrderAllocatesStock;
    property ssDocumentNumbers[const DocType: WideString]: Integer read Get_ssDocumentNumbers;
    property ssMaxCurrency: Integer read Get_ssMaxCurrency;
    property ssUseDosKeys: WordBool read Get_ssUseDosKeys;
    property ssHideEnterpriseLogo: WordBool read Get_ssHideEnterpriseLogo;
    property ssConserveMemory: WordBool read Get_ssConserveMemory;
    property ssProtectYourRef: WordBool read Get_ssProtectYourRef;
    property ssSDNDateIsTaxPointDate: WordBool read Get_ssSDNDateIsTaxPointDate;
    property ssAutoPostUplift: WordBool read Get_ssAutoPostUplift;
    property ssJobCosting: ITradeSystemSetupJob read Get_ssJobCosting;
    property ssTaxWord: WideString read Get_ssTaxWord;
    property ssMainCompanyDir: WideString read Get_ssMainCompanyDir;
  end;

// *********************************************************************//
// DispIntf:  ITradeEntSetupDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C2019D7B-ED91-4B7E-92E7-6913B620B6EA}
// *********************************************************************//
  ITradeEntSetupDisp = dispinterface
    ['{C2019D7B-ED91-4B7E-92E7-6913B620B6EA}']
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
    property ssPromptToPrintReceipt: WordBool readonly dispid 50;
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
    property ssCurrencyRateType: TTradeCurrencyRateType readonly dispid 63;
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
    property ssGLCtrlCodes[Index: TTradeSystemSetupGLCtrlType]: Integer readonly dispid 97;
    property ssDebtChaseDays[Index: Integer]: Smallint readonly dispid 98;
    property ssTermsofTrade[Index: Integer]: WideString readonly dispid 99;
    property ssVATRates[const Index: WideString]: ITradeSystemSetupVAT readonly dispid 95;
    property ssCurrency[Index: Integer]: ITradeSystemSetupCurrency readonly dispid 100;
    property ssUserFields: ITradeSystemSetupUserFields readonly dispid 101;
    property ssPickingOrderAllocatesStock: WordBool readonly dispid 102;
    property ssDocumentNumbers[const DocType: WideString]: Integer readonly dispid 104;
    property ssMaxCurrency: Integer readonly dispid 23;
    procedure Refresh; dispid 67;
    property ssUseDosKeys: WordBool readonly dispid 91;
    property ssHideEnterpriseLogo: WordBool readonly dispid 105;
    property ssConserveMemory: WordBool readonly dispid 106;
    property ssProtectYourRef: WordBool readonly dispid 107;
    property ssSDNDateIsTaxPointDate: WordBool readonly dispid 108;
    property ssAutoPostUplift: WordBool readonly dispid 112;
    property ssJobCosting: ITradeSystemSetupJob readonly dispid 113;
    property ssTaxWord: WideString readonly dispid 82;
    property ssMainCompanyDir: WideString readonly dispid 7;
  end;

// *********************************************************************//
// Interface: ITradeTCMSetupTill
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A5B26E62-9536-4BBB-8CB2-FCE7019A610A}
// *********************************************************************//
  ITradeTCMSetupTill = interface(IDispatch)
    ['{A5B26E62-9536-4BBB-8CB2-FCE7019A610A}']
    function Get_ssTillName: WideString; safecall;
    function Get_ssCompanyCode: WideString; safecall;
    function Get_ssAfterTender: TTradeAfterTender; safecall;
    function Get_ssDefaultAccountCode: WideString; safecall;
    function Get_ssTillCurrency: Integer; safecall;
    function Get_ssCashGLCode: Integer; safecall;
    function Get_ssChequeGLCode: Integer; safecall;
    function Get_ssSSDDeliveryTerms: WideString; safecall;
    function Get_ssSSDModeOfTransport: Integer; safecall;
    function Get_ssStockLocation: WideString; safecall;
    function Get_ssWriteOffGLCode: Integer; safecall;
    function Get_ssNonStockGLCode: Integer; safecall;
    function Get_ssCashOnlyCustType: WideString; safecall;
    function Get_ssAutoAddLine: WordBool; safecall;
    function Get_ssAllowModifyVATRate: WordBool; safecall;
    function Get_ssRoundChange: WordBool; safecall;
    function Get_ssRoundChangeTo: Double; safecall;
    function Get_ssCreateNegTransType: TTradeCreateNegTXType; safecall;
    function Get_ssDiscountType: TTradeDiscountType; safecall;
    function Get_ssUseDefaultAccountCode: WordBool; safecall;
    function Get_ssFilterSerialNoByLocation: WordBool; safecall;
    function Get_ssTakeNonStockDefaultFrom: TTradeTakeNonStockDefaultFrom; safecall;
    function Get_ssNonStockItemCode: WideString; safecall;
    function Get_ssNonStockVATCode: WideString; safecall;
    function Get_ssCCDeptMode: TTradeCCDeptMode; safecall;
    function Get_ssCostCentre: WideString; safecall;
    function Get_ssDepartment: WideString; safecall;
    function Get_ssAllowDepositsOnCashCust: WordBool; safecall;
    function Get_ssCashDrawer: ITradeTCMSetupCashDrawer; safecall;
    function Get_ssPrinting: ITradeTCMSetupPrinting; safecall;
    function Get_ssCreditCards: ITradeTCMSetupCreditCards; safecall;
    function Get_ssLocation: ITradeLocation; safecall;
    function Get_ssCompany: ITradeCompany; safecall;
    function Get_ssTransactionTagNo: Integer; safecall;
    function Get_ssCreateTransType: TTradeCreateTXType; safecall;
    property ssTillName: WideString read Get_ssTillName;
    property ssCompanyCode: WideString read Get_ssCompanyCode;
    property ssAfterTender: TTradeAfterTender read Get_ssAfterTender;
    property ssDefaultAccountCode: WideString read Get_ssDefaultAccountCode;
    property ssTillCurrency: Integer read Get_ssTillCurrency;
    property ssCashGLCode: Integer read Get_ssCashGLCode;
    property ssChequeGLCode: Integer read Get_ssChequeGLCode;
    property ssSSDDeliveryTerms: WideString read Get_ssSSDDeliveryTerms;
    property ssSSDModeOfTransport: Integer read Get_ssSSDModeOfTransport;
    property ssStockLocation: WideString read Get_ssStockLocation;
    property ssWriteOffGLCode: Integer read Get_ssWriteOffGLCode;
    property ssNonStockGLCode: Integer read Get_ssNonStockGLCode;
    property ssCashOnlyCustType: WideString read Get_ssCashOnlyCustType;
    property ssAutoAddLine: WordBool read Get_ssAutoAddLine;
    property ssAllowModifyVATRate: WordBool read Get_ssAllowModifyVATRate;
    property ssRoundChange: WordBool read Get_ssRoundChange;
    property ssRoundChangeTo: Double read Get_ssRoundChangeTo;
    property ssCreateNegTransType: TTradeCreateNegTXType read Get_ssCreateNegTransType;
    property ssDiscountType: TTradeDiscountType read Get_ssDiscountType;
    property ssUseDefaultAccountCode: WordBool read Get_ssUseDefaultAccountCode;
    property ssFilterSerialNoByLocation: WordBool read Get_ssFilterSerialNoByLocation;
    property ssTakeNonStockDefaultFrom: TTradeTakeNonStockDefaultFrom read Get_ssTakeNonStockDefaultFrom;
    property ssNonStockItemCode: WideString read Get_ssNonStockItemCode;
    property ssNonStockVATCode: WideString read Get_ssNonStockVATCode;
    property ssCCDeptMode: TTradeCCDeptMode read Get_ssCCDeptMode;
    property ssCostCentre: WideString read Get_ssCostCentre;
    property ssDepartment: WideString read Get_ssDepartment;
    property ssAllowDepositsOnCashCust: WordBool read Get_ssAllowDepositsOnCashCust;
    property ssCashDrawer: ITradeTCMSetupCashDrawer read Get_ssCashDrawer;
    property ssPrinting: ITradeTCMSetupPrinting read Get_ssPrinting;
    property ssCreditCards: ITradeTCMSetupCreditCards read Get_ssCreditCards;
    property ssLocation: ITradeLocation read Get_ssLocation;
    property ssCompany: ITradeCompany read Get_ssCompany;
    property ssTransactionTagNo: Integer read Get_ssTransactionTagNo;
    property ssCreateTransType: TTradeCreateTXType read Get_ssCreateTransType;
  end;

// *********************************************************************//
// DispIntf:  ITradeTCMSetupTillDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A5B26E62-9536-4BBB-8CB2-FCE7019A610A}
// *********************************************************************//
  ITradeTCMSetupTillDisp = dispinterface
    ['{A5B26E62-9536-4BBB-8CB2-FCE7019A610A}']
    property ssTillName: WideString readonly dispid 2;
    property ssCompanyCode: WideString readonly dispid 3;
    property ssAfterTender: TTradeAfterTender readonly dispid 1;
    property ssDefaultAccountCode: WideString readonly dispid 4;
    property ssTillCurrency: Integer readonly dispid 5;
    property ssCashGLCode: Integer readonly dispid 6;
    property ssChequeGLCode: Integer readonly dispid 7;
    property ssSSDDeliveryTerms: WideString readonly dispid 9;
    property ssSSDModeOfTransport: Integer readonly dispid 10;
    property ssStockLocation: WideString readonly dispid 11;
    property ssWriteOffGLCode: Integer readonly dispid 12;
    property ssNonStockGLCode: Integer readonly dispid 13;
    property ssCashOnlyCustType: WideString readonly dispid 14;
    property ssAutoAddLine: WordBool readonly dispid 15;
    property ssAllowModifyVATRate: WordBool readonly dispid 16;
    property ssRoundChange: WordBool readonly dispid 17;
    property ssRoundChangeTo: Double readonly dispid 18;
    property ssCreateNegTransType: TTradeCreateNegTXType readonly dispid 20;
    property ssDiscountType: TTradeDiscountType readonly dispid 21;
    property ssUseDefaultAccountCode: WordBool readonly dispid 22;
    property ssFilterSerialNoByLocation: WordBool readonly dispid 23;
    property ssTakeNonStockDefaultFrom: TTradeTakeNonStockDefaultFrom readonly dispid 24;
    property ssNonStockItemCode: WideString readonly dispid 25;
    property ssNonStockVATCode: WideString readonly dispid 26;
    property ssCCDeptMode: TTradeCCDeptMode readonly dispid 27;
    property ssCostCentre: WideString readonly dispid 28;
    property ssDepartment: WideString readonly dispid 29;
    property ssAllowDepositsOnCashCust: WordBool readonly dispid 30;
    property ssCashDrawer: ITradeTCMSetupCashDrawer readonly dispid 8;
    property ssPrinting: ITradeTCMSetupPrinting readonly dispid 31;
    property ssCreditCards: ITradeTCMSetupCreditCards readonly dispid 32;
    property ssLocation: ITradeLocation readonly dispid 33;
    property ssCompany: ITradeCompany readonly dispid 34;
    property ssTransactionTagNo: Integer readonly dispid 35;
    property ssCreateTransType: TTradeCreateTXType readonly dispid 19;
  end;

// *********************************************************************//
// Interface: ITradeTCMSetupCashDrawer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FE26B9C3-D1BD-4338-A16A-C5A78199F0EB}
// *********************************************************************//
  ITradeTCMSetupCashDrawer = interface(IDispatch)
    ['{FE26B9C3-D1BD-4338-A16A-C5A78199F0EB}']
    function Get_cdOpenOnCash: WordBool; safecall;
    function Get_cdOpenOnCheque: WordBool; safecall;
    function Get_cdOpenOnCard: WordBool; safecall;
    function Get_cdOpenOnAccount: WordBool; safecall;
    function Get_cdKickOutCodes: WideString; safecall;
    function Get_cdComPortNo: Integer; safecall;
    function Get_cdBaudRate: TTradeBaudRate; safecall;
    procedure OpenCashDrawer(COMPort: Integer; BaudRate: TTradeBaudRate; 
                             const KickOutCodes: WideString); safecall;
    property cdOpenOnCash: WordBool read Get_cdOpenOnCash;
    property cdOpenOnCheque: WordBool read Get_cdOpenOnCheque;
    property cdOpenOnCard: WordBool read Get_cdOpenOnCard;
    property cdOpenOnAccount: WordBool read Get_cdOpenOnAccount;
    property cdKickOutCodes: WideString read Get_cdKickOutCodes;
    property cdComPortNo: Integer read Get_cdComPortNo;
    property cdBaudRate: TTradeBaudRate read Get_cdBaudRate;
  end;

// *********************************************************************//
// DispIntf:  ITradeTCMSetupCashDrawerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FE26B9C3-D1BD-4338-A16A-C5A78199F0EB}
// *********************************************************************//
  ITradeTCMSetupCashDrawerDisp = dispinterface
    ['{FE26B9C3-D1BD-4338-A16A-C5A78199F0EB}']
    property cdOpenOnCash: WordBool readonly dispid 1;
    property cdOpenOnCheque: WordBool readonly dispid 2;
    property cdOpenOnCard: WordBool readonly dispid 3;
    property cdOpenOnAccount: WordBool readonly dispid 4;
    property cdKickOutCodes: WideString readonly dispid 5;
    property cdComPortNo: Integer readonly dispid 6;
    property cdBaudRate: TTradeBaudRate readonly dispid 7;
    procedure OpenCashDrawer(COMPort: Integer; BaudRate: TTradeBaudRate; 
                             const KickOutCodes: WideString); dispid 9;
  end;

// *********************************************************************//
// Interface: ITradeTCMSetupPrinting
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4CDFB008-A9BB-4289-BF02-5618493A9AB7}
// *********************************************************************//
  ITradeTCMSetupPrinting = interface(IDispatch)
    ['{4CDFB008-A9BB-4289-BF02-5618493A9AB7}']
    function Get_prReceipt: ITradeTCMSetupPrintDet; safecall;
    function Get_prInvoice: ITradeTCMSetupPrintDet; safecall;
    function Get_prOrder: ITradeTCMSetupPrintDet; safecall;
    property prReceipt: ITradeTCMSetupPrintDet read Get_prReceipt;
    property prInvoice: ITradeTCMSetupPrintDet read Get_prInvoice;
    property prOrder: ITradeTCMSetupPrintDet read Get_prOrder;
  end;

// *********************************************************************//
// DispIntf:  ITradeTCMSetupPrintingDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4CDFB008-A9BB-4289-BF02-5618493A9AB7}
// *********************************************************************//
  ITradeTCMSetupPrintingDisp = dispinterface
    ['{4CDFB008-A9BB-4289-BF02-5618493A9AB7}']
    property prReceipt: ITradeTCMSetupPrintDet readonly dispid 1;
    property prInvoice: ITradeTCMSetupPrintDet readonly dispid 2;
    property prOrder: ITradeTCMSetupPrintDet readonly dispid 3;
  end;

// *********************************************************************//
// Interface: ITradeTCMSetupPrintDet
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {06765765-7111-4795-BD01-ACAD7D30E1B1}
// *********************************************************************//
  ITradeTCMSetupPrintDet = interface(IDispatch)
    ['{06765765-7111-4795-BD01-ACAD7D30E1B1}']
    function Get_pdFormName: WideString; safecall;
    function Get_pdPrinterName: WideString; safecall;
    function Get_pdPaper: WideString; safecall;
    function Get_pdBin: WideString; safecall;
    property pdFormName: WideString read Get_pdFormName;
    property pdPrinterName: WideString read Get_pdPrinterName;
    property pdPaper: WideString read Get_pdPaper;
    property pdBin: WideString read Get_pdBin;
  end;

// *********************************************************************//
// DispIntf:  ITradeTCMSetupPrintDetDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {06765765-7111-4795-BD01-ACAD7D30E1B1}
// *********************************************************************//
  ITradeTCMSetupPrintDetDisp = dispinterface
    ['{06765765-7111-4795-BD01-ACAD7D30E1B1}']
    property pdFormName: WideString readonly dispid 1;
    property pdPrinterName: WideString readonly dispid 2;
    property pdPaper: WideString readonly dispid 3;
    property pdBin: WideString readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ITradeTCMSetupCreditCards
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C62095BE-ED82-4C84-A1D0-002A6412C1BB}
// *********************************************************************//
  ITradeTCMSetupCreditCards = interface(IDispatch)
    ['{C62095BE-ED82-4C84-A1D0-002A6412C1BB}']
    function Get_ccCard(Index: Integer): ITradeTCMSetupCreditCard; safecall;
    function Get_ccNoOfCards: Integer; safecall;
    property ccCard[Index: Integer]: ITradeTCMSetupCreditCard read Get_ccCard;
    property ccNoOfCards: Integer read Get_ccNoOfCards;
  end;

// *********************************************************************//
// DispIntf:  ITradeTCMSetupCreditCardsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C62095BE-ED82-4C84-A1D0-002A6412C1BB}
// *********************************************************************//
  ITradeTCMSetupCreditCardsDisp = dispinterface
    ['{C62095BE-ED82-4C84-A1D0-002A6412C1BB}']
    property ccCard[Index: Integer]: ITradeTCMSetupCreditCard readonly dispid 1;
    property ccNoOfCards: Integer readonly dispid 3;
  end;

// *********************************************************************//
// Interface: ITradeTCMSetupCreditCard
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5A05DD1F-7FBE-4BCE-BC8B-4C62D8327F04}
// *********************************************************************//
  ITradeTCMSetupCreditCard = interface(IDispatch)
    ['{5A05DD1F-7FBE-4BCE-BC8B-4C62D8327F04}']
    function Get_ccDescription: WideString; safecall;
    function Get_ccGLCode: Integer; safecall;
    property ccDescription: WideString read Get_ccDescription;
    property ccGLCode: Integer read Get_ccGLCode;
  end;

// *********************************************************************//
// DispIntf:  ITradeTCMSetupCreditCardDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5A05DD1F-7FBE-4BCE-BC8B-4C62D8327F04}
// *********************************************************************//
  ITradeTCMSetupCreditCardDisp = dispinterface
    ['{5A05DD1F-7FBE-4BCE-BC8B-4C62D8327F04}']
    property ccDescription: WideString readonly dispid 1;
    property ccGLCode: Integer readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ITradeLocation
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {10968605-850D-403C-84F2-8B1472E0115D}
// *********************************************************************//
  ITradeLocation = interface(IDispatch)
    ['{10968605-850D-403C-84F2-8B1472E0115D}']
    function Get_loCode: WideString; safecall;
    function Get_loName: WideString; safecall;
    function Get_loAddress: ITradeAddress; safecall;
    function Get_loPhone: WideString; safecall;
    function Get_loFax: WideString; safecall;
    function Get_loEmailAddr: WideString; safecall;
    function Get_loModem: WideString; safecall;
    function Get_loContact: WideString; safecall;
    function Get_loCurrency: Smallint; safecall;
    function Get_loArea: WideString; safecall;
    function Get_loRep: WideString; safecall;
    function Get_loTagged: WordBool; safecall;
    function Get_loCostCentre: WideString; safecall;
    function Get_loDepartment: WideString; safecall;
    function Get_loOverrideSalesPrice: WordBool; safecall;
    function Get_loOverrideGLCodes: WordBool; safecall;
    function Get_loOverrideCCDept: WordBool; safecall;
    function Get_loOverrideSupplier: WordBool; safecall;
    function Get_loOverrideBinLocation: WordBool; safecall;
    function Get_loSalesGL: Integer; safecall;
    function Get_loCostOfSalesGL: Integer; safecall;
    function Get_loPandLGL: Integer; safecall;
    function Get_loBalSheetGL: Integer; safecall;
    function Get_loWIPGL: Integer; safecall;
    property loCode: WideString read Get_loCode;
    property loName: WideString read Get_loName;
    property loAddress: ITradeAddress read Get_loAddress;
    property loPhone: WideString read Get_loPhone;
    property loFax: WideString read Get_loFax;
    property loEmailAddr: WideString read Get_loEmailAddr;
    property loModem: WideString read Get_loModem;
    property loContact: WideString read Get_loContact;
    property loCurrency: Smallint read Get_loCurrency;
    property loArea: WideString read Get_loArea;
    property loRep: WideString read Get_loRep;
    property loTagged: WordBool read Get_loTagged;
    property loCostCentre: WideString read Get_loCostCentre;
    property loDepartment: WideString read Get_loDepartment;
    property loOverrideSalesPrice: WordBool read Get_loOverrideSalesPrice;
    property loOverrideGLCodes: WordBool read Get_loOverrideGLCodes;
    property loOverrideCCDept: WordBool read Get_loOverrideCCDept;
    property loOverrideSupplier: WordBool read Get_loOverrideSupplier;
    property loOverrideBinLocation: WordBool read Get_loOverrideBinLocation;
    property loSalesGL: Integer read Get_loSalesGL;
    property loCostOfSalesGL: Integer read Get_loCostOfSalesGL;
    property loPandLGL: Integer read Get_loPandLGL;
    property loBalSheetGL: Integer read Get_loBalSheetGL;
    property loWIPGL: Integer read Get_loWIPGL;
  end;

// *********************************************************************//
// DispIntf:  ITradeLocationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {10968605-850D-403C-84F2-8B1472E0115D}
// *********************************************************************//
  ITradeLocationDisp = dispinterface
    ['{10968605-850D-403C-84F2-8B1472E0115D}']
    property loCode: WideString readonly dispid 1;
    property loName: WideString readonly dispid 2;
    property loAddress: ITradeAddress readonly dispid 3;
    property loPhone: WideString readonly dispid 4;
    property loFax: WideString readonly dispid 5;
    property loEmailAddr: WideString readonly dispid 6;
    property loModem: WideString readonly dispid 7;
    property loContact: WideString readonly dispid 8;
    property loCurrency: Smallint readonly dispid 9;
    property loArea: WideString readonly dispid 10;
    property loRep: WideString readonly dispid 11;
    property loTagged: WordBool readonly dispid 12;
    property loCostCentre: WideString readonly dispid 13;
    property loDepartment: WideString readonly dispid 14;
    property loOverrideSalesPrice: WordBool readonly dispid 15;
    property loOverrideGLCodes: WordBool readonly dispid 16;
    property loOverrideCCDept: WordBool readonly dispid 17;
    property loOverrideSupplier: WordBool readonly dispid 18;
    property loOverrideBinLocation: WordBool readonly dispid 19;
    property loSalesGL: Integer readonly dispid 20;
    property loCostOfSalesGL: Integer readonly dispid 21;
    property loPandLGL: Integer readonly dispid 22;
    property loBalSheetGL: Integer readonly dispid 23;
    property loWIPGL: Integer readonly dispid 24;
  end;

// *********************************************************************//
// Interface: ITradeCompany
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5FFB42F5-1AFB-4490-BD07-9D70E3C073FB}
// *********************************************************************//
  ITradeCompany = interface(IDispatch)
    ['{5FFB42F5-1AFB-4490-BD07-9D70E3C073FB}']
    function Get_coCode: WideString; safecall;
    function Get_coName: WideString; safecall;
    function Get_coPath: WideString; safecall;
    property coCode: WideString read Get_coCode;
    property coName: WideString read Get_coName;
    property coPath: WideString read Get_coPath;
  end;

// *********************************************************************//
// DispIntf:  ITradeCompanyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5FFB42F5-1AFB-4490-BD07-9D70E3C073FB}
// *********************************************************************//
  ITradeCompanyDisp = dispinterface
    ['{5FFB42F5-1AFB-4490-BD07-9D70E3C073FB}']
    property coCode: WideString readonly dispid 2;
    property coName: WideString readonly dispid 3;
    property coPath: WideString readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ITradeSystemSetupVAT
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {01B9893E-952E-42A3-9143-72349CA4DBD8}
// *********************************************************************//
  ITradeSystemSetupVAT = interface(IDispatch)
    ['{01B9893E-952E-42A3-9143-72349CA4DBD8}']
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
// DispIntf:  ITradeSystemSetupVATDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {01B9893E-952E-42A3-9143-72349CA4DBD8}
// *********************************************************************//
  ITradeSystemSetupVATDisp = dispinterface
    ['{01B9893E-952E-42A3-9143-72349CA4DBD8}']
    property svCode: WideString readonly dispid 1;
    property svDesc: WideString readonly dispid 2;
    property svRate: Double readonly dispid 3;
    property svInclude: WordBool readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ITradeSystemSetupCurrency
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9241557C-B198-4D37-9C47-B2CEAD7F4C4B}
// *********************************************************************//
  ITradeSystemSetupCurrency = interface(IDispatch)
    ['{9241557C-B198-4D37-9C47-B2CEAD7F4C4B}']
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
// DispIntf:  ITradeSystemSetupCurrencyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9241557C-B198-4D37-9C47-B2CEAD7F4C4B}
// *********************************************************************//
  ITradeSystemSetupCurrencyDisp = dispinterface
    ['{9241557C-B198-4D37-9C47-B2CEAD7F4C4B}']
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
// Interface: ITradeSystemSetupUserFields
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E8905360-5A1D-43A2-ADF0-D3DEE9DB39FE}
// *********************************************************************//
  ITradeSystemSetupUserFields = interface(IDispatch)
    ['{E8905360-5A1D-43A2-ADF0-D3DEE9DB39FE}']
    function Get_ufAccount1: WideString; safecall;
    function Get_ufAccount2: WideString; safecall;
    function Get_ufAccount3: WideString; safecall;
    function Get_ufAccount4: WideString; safecall;
    function Get_ufStock1: WideString; safecall;
    function Get_ufStock2: WideString; safecall;
    function Get_ufStock3: WideString; safecall;
    function Get_ufStock4: WideString; safecall;
    function Get_ufJob1: WideString; safecall;
    function Get_ufJob2: WideString; safecall;
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
    property ufAccount1: WideString read Get_ufAccount1;
    property ufAccount2: WideString read Get_ufAccount2;
    property ufAccount3: WideString read Get_ufAccount3;
    property ufAccount4: WideString read Get_ufAccount4;
    property ufStock1: WideString read Get_ufStock1;
    property ufStock2: WideString read Get_ufStock2;
    property ufStock3: WideString read Get_ufStock3;
    property ufStock4: WideString read Get_ufStock4;
    property ufJob1: WideString read Get_ufJob1;
    property ufJob2: WideString read Get_ufJob2;
    property ufADJDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufADJDesc;
    property ufADJEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufADJEnabled;
    property ufADJLineDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufADJLineDesc;
    property ufADJLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufADJLineEnabled;
    property ufCustDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufCustDesc;
    property ufEmployeeDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufEmployeeDesc;
    property ufJobDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufJobDesc;
    property ufLineTypeDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufLineTypeDesc;
    property ufNOMDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufNOMDesc;
    property ufNOMEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufNOMEnabled;
    property ufNOMLineDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufNOMLineDesc;
    property ufNOMLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufNOMLineEnabled;
    property ufPINDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufPINDesc;
    property ufPINEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufPINEnabled;
    property ufPINLineDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufPINLineDesc;
    property ufPINLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufPINLineEnabled;
    property ufPORDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufPORDesc;
    property ufPOREnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufPOREnabled;
    property ufPORLineDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufPORLineDesc;
    property ufPORLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufPORLineEnabled;
    property ufPPYDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufPPYDesc;
    property ufPPYEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufPPYEnabled;
    property ufPPYLineDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufPPYLineDesc;
    property ufPPYLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufPPYLineEnabled;
    property ufPQUDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufPQUDesc;
    property ufPQUEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufPQUEnabled;
    property ufPQULineDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufPQULineDesc;
    property ufPQULineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufPQULineEnabled;
    property ufSINDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufSINDesc;
    property ufSINEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufSINEnabled;
    property ufSINLineDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufSINLineDesc;
    property ufSINLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufSINLineEnabled;
    property ufSORDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufSORDesc;
    property ufSOREnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufSOREnabled;
    property ufSORLineDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufSORLineDesc;
    property ufSORLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufSORLineEnabled;
    property ufSQUDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufSQUDesc;
    property ufSQUEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufSQUEnabled;
    property ufSQULineDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufSQULineDesc;
    property ufSQULineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufSQULineEnabled;
    property ufSRCDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufSRCDesc;
    property usSRCEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_usSRCEnabled;
    property ufSRCLineDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufSRCLineDesc;
    property ufSRCLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufSRCLineEnabled;
    property ufStockDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufStockDesc;
    property ufSuppDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufSuppDesc;
    property ufTSHDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufTSHDesc;
    property ufTSHEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufTSHEnabled;
    property ufTSHLineDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufTSHLineDesc;
    property ufTSHLineDescEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufTSHLineDescEnabled;
    property ufWORDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufWORDesc;
    property ufWOREnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufWOREnabled;
    property ufWORLineDesc[Index: TTradeUserDefinedFieldNo]: WideString read Get_ufWORLineDesc;
    property ufWORLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool read Get_ufWORLineEnabled;
  end;

// *********************************************************************//
// DispIntf:  ITradeSystemSetupUserFieldsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E8905360-5A1D-43A2-ADF0-D3DEE9DB39FE}
// *********************************************************************//
  ITradeSystemSetupUserFieldsDisp = dispinterface
    ['{E8905360-5A1D-43A2-ADF0-D3DEE9DB39FE}']
    property ufAccount1: WideString readonly dispid 1;
    property ufAccount2: WideString readonly dispid 2;
    property ufAccount3: WideString readonly dispid 3;
    property ufAccount4: WideString readonly dispid 4;
    property ufStock1: WideString readonly dispid 9;
    property ufStock2: WideString readonly dispid 10;
    property ufStock3: WideString readonly dispid 11;
    property ufStock4: WideString readonly dispid 12;
    property ufJob1: WideString readonly dispid 17;
    property ufJob2: WideString readonly dispid 18;
    property ufADJDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 19;
    property ufADJEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 36;
    property ufADJLineDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 37;
    property ufADJLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 38;
    property ufCustDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 39;
    property ufEmployeeDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 40;
    property ufJobDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 41;
    property ufLineTypeDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 42;
    property ufNOMDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 43;
    property ufNOMEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 44;
    property ufNOMLineDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 45;
    property ufNOMLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 46;
    property ufPINDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 47;
    property ufPINEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 48;
    property ufPINLineDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 49;
    property ufPINLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 50;
    property ufPORDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 51;
    property ufPOREnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 52;
    property ufPORLineDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 53;
    property ufPORLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 54;
    property ufPPYDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 55;
    property ufPPYEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 56;
    property ufPPYLineDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 57;
    property ufPPYLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 58;
    property ufPQUDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 59;
    property ufPQUEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 60;
    property ufPQULineDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 61;
    property ufPQULineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 62;
    property ufSINDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 63;
    property ufSINEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 64;
    property ufSINLineDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 65;
    property ufSINLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 66;
    property ufSORDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 67;
    property ufSOREnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 68;
    property ufSORLineDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 69;
    property ufSORLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 70;
    property ufSQUDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 71;
    property ufSQUEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 72;
    property ufSQULineDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 73;
    property ufSQULineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 74;
    property ufSRCDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 75;
    property usSRCEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 76;
    property ufSRCLineDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 77;
    property ufSRCLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 78;
    property ufStockDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 79;
    property ufSuppDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 80;
    property ufTSHDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 81;
    property ufTSHEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 82;
    property ufTSHLineDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 83;
    property ufTSHLineDescEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 84;
    property ufWORDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 85;
    property ufWOREnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 86;
    property ufWORLineDesc[Index: TTradeUserDefinedFieldNo]: WideString readonly dispid 87;
    property ufWORLineEnabled[Index: TTradeUserDefinedFieldNo]: WordBool readonly dispid 88;
  end;

// *********************************************************************//
// Interface: ITradeSystemSetupJob
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7B6ABABE-2A15-4414-9EFC-4E5F01E7AE54}
// *********************************************************************//
  ITradeSystemSetupJob = interface(IDispatch)
    ['{7B6ABABE-2A15-4414-9EFC-4E5F01E7AE54}']
    function Get_ssUsePPIsForTimeSheets: WordBool; safecall;
    function Get_ssSplitJobBudgetsByPeriod: WordBool; safecall;
    function Get_ssPPISupAccount: WideString; safecall;
    function Get_ssJobCategory(Index: TTradeJobCategoryType): WideString; safecall;
    function Get_ssCheckJobBudget: WordBool; safecall;
    function Get_ssJobCostingGLCtrlCodes(Inde: TTradeSystemSetupJobGLCtrlType): Integer; safecall;
    property ssUsePPIsForTimeSheets: WordBool read Get_ssUsePPIsForTimeSheets;
    property ssSplitJobBudgetsByPeriod: WordBool read Get_ssSplitJobBudgetsByPeriod;
    property ssPPISupAccount: WideString read Get_ssPPISupAccount;
    property ssJobCategory[Index: TTradeJobCategoryType]: WideString read Get_ssJobCategory;
    property ssCheckJobBudget: WordBool read Get_ssCheckJobBudget;
    property ssJobCostingGLCtrlCodes[Inde: TTradeSystemSetupJobGLCtrlType]: Integer read Get_ssJobCostingGLCtrlCodes;
  end;

// *********************************************************************//
// DispIntf:  ITradeSystemSetupJobDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7B6ABABE-2A15-4414-9EFC-4E5F01E7AE54}
// *********************************************************************//
  ITradeSystemSetupJobDisp = dispinterface
    ['{7B6ABABE-2A15-4414-9EFC-4E5F01E7AE54}']
    property ssUsePPIsForTimeSheets: WordBool readonly dispid 109;
    property ssSplitJobBudgetsByPeriod: WordBool readonly dispid 110;
    property ssPPISupAccount: WideString readonly dispid 111;
    property ssJobCategory[Index: TTradeJobCategoryType]: WideString readonly dispid 1;
    property ssCheckJobBudget: WordBool readonly dispid 82;
    property ssJobCostingGLCtrlCodes[Inde: TTradeSystemSetupJobGLCtrlType]: Integer readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ITradeEventPaymentLine
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8580C6DC-D7E8-47D1-A679-191BBE9B7F32}
// *********************************************************************//
  ITradeEventPaymentLine = interface(IDispatch)
    ['{8580C6DC-D7E8-47D1-A679-191BBE9B7F32}']
    function Get_tlLineNo: Integer; safecall;
    procedure Set_tlLineNo(Value: Integer); safecall;
    function Get_tlGLCode: Integer; safecall;
    procedure Set_tlGLCode(Value: Integer); safecall;
    function Get_tlCurrency: Integer; safecall;
    procedure Set_tlCurrency(Value: Integer); safecall;
    function Get_tlCompanyRate: Double; safecall;
    procedure Set_tlCompanyRate(Value: Double); safecall;
    function Get_tlPayingInRef: WideString; safecall;
    procedure Set_tlPayingInRef(const Value: WideString); safecall;
    function Get_tlDailyRate: Double; safecall;
    procedure Set_tlDailyRate(Value: Double); safecall;
    function Get_tlCostCentre: WideString; safecall;
    procedure Set_tlCostCentre(const Value: WideString); safecall;
    function Get_tlDepartment: WideString; safecall;
    procedure Set_tlDepartment(const Value: WideString); safecall;
    function Get_tlNetValue: Double; safecall;
    procedure Set_tlNetValue(Value: Double); safecall;
    function Get_tlLineDate: WideString; safecall;
    procedure Set_tlLineDate(const Value: WideString); safecall;
    function Get_tlChequeNo: WideString; safecall;
    procedure Set_tlChequeNo(const Value: WideString); safecall;
    function Get_tlLineType: TTradeTransLineType; safecall;
    procedure Set_tlLineType(Value: TTradeTransLineType); safecall;
    function Get_tlFolioNum: Integer; safecall;
    function Get_tlLineClass: WideString; safecall;
    function Get_tlRecStatus: Smallint; safecall;
    procedure Set_tlRecStatus(Value: Smallint); safecall;
    function Get_tlABSLineNo: Integer; safecall;
    function Get_tlUserField1: WideString; safecall;
    procedure Set_tlUserField1(const Value: WideString); safecall;
    function Get_tlUserField2: WideString; safecall;
    procedure Set_tlUserField2(const Value: WideString); safecall;
    function Get_tlUserField3: WideString; safecall;
    procedure Set_tlUserField3(const Value: WideString); safecall;
    function Get_tlUserField4: WideString; safecall;
    procedure Set_tlUserField4(const Value: WideString); safecall;
    function Get_tlOurRef: WideString; safecall;
    property tlLineNo: Integer read Get_tlLineNo write Set_tlLineNo;
    property tlGLCode: Integer read Get_tlGLCode write Set_tlGLCode;
    property tlCurrency: Integer read Get_tlCurrency write Set_tlCurrency;
    property tlCompanyRate: Double read Get_tlCompanyRate write Set_tlCompanyRate;
    property tlPayingInRef: WideString read Get_tlPayingInRef write Set_tlPayingInRef;
    property tlDailyRate: Double read Get_tlDailyRate write Set_tlDailyRate;
    property tlCostCentre: WideString read Get_tlCostCentre write Set_tlCostCentre;
    property tlDepartment: WideString read Get_tlDepartment write Set_tlDepartment;
    property tlNetValue: Double read Get_tlNetValue write Set_tlNetValue;
    property tlLineDate: WideString read Get_tlLineDate write Set_tlLineDate;
    property tlChequeNo: WideString read Get_tlChequeNo write Set_tlChequeNo;
    property tlLineType: TTradeTransLineType read Get_tlLineType write Set_tlLineType;
    property tlFolioNum: Integer read Get_tlFolioNum;
    property tlLineClass: WideString read Get_tlLineClass;
    property tlRecStatus: Smallint read Get_tlRecStatus write Set_tlRecStatus;
    property tlABSLineNo: Integer read Get_tlABSLineNo;
    property tlUserField1: WideString read Get_tlUserField1 write Set_tlUserField1;
    property tlUserField2: WideString read Get_tlUserField2 write Set_tlUserField2;
    property tlUserField3: WideString read Get_tlUserField3 write Set_tlUserField3;
    property tlUserField4: WideString read Get_tlUserField4 write Set_tlUserField4;
    property tlOurRef: WideString read Get_tlOurRef;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventPaymentLineDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8580C6DC-D7E8-47D1-A679-191BBE9B7F32}
// *********************************************************************//
  ITradeEventPaymentLineDisp = dispinterface
    ['{8580C6DC-D7E8-47D1-A679-191BBE9B7F32}']
    property tlLineNo: Integer dispid 1;
    property tlGLCode: Integer dispid 2;
    property tlCurrency: Integer dispid 3;
    property tlCompanyRate: Double dispid 4;
    property tlPayingInRef: WideString dispid 8;
    property tlDailyRate: Double dispid 51;
    property tlCostCentre: WideString dispid 6;
    property tlDepartment: WideString dispid 7;
    property tlNetValue: Double dispid 11;
    property tlLineDate: WideString dispid 20;
    property tlChequeNo: WideString dispid 22;
    property tlLineType: TTradeTransLineType dispid 29;
    property tlFolioNum: Integer readonly dispid 30;
    property tlLineClass: WideString readonly dispid 31;
    property tlRecStatus: Smallint dispid 32;
    property tlABSLineNo: Integer readonly dispid 35;
    property tlUserField1: WideString dispid 36;
    property tlUserField2: WideString dispid 37;
    property tlUserField3: WideString dispid 38;
    property tlUserField4: WideString dispid 39;
    property tlOurRef: WideString readonly dispid 5;
  end;

// *********************************************************************//
// Interface: ITradeEventPaymentLines
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {479DAFA4-3F69-4512-B3F8-E66436A851F6}
// *********************************************************************//
  ITradeEventPaymentLines = interface(IDispatch)
    ['{479DAFA4-3F69-4512-B3F8-E66436A851F6}']
    function Get_thLine(Index: Integer): ITradeEventPaymentLine; safecall;
    function Get_thLineCount: Integer; safecall;
    property thLine[Index: Integer]: ITradeEventPaymentLine read Get_thLine; default;
    property thLineCount: Integer read Get_thLineCount;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventPaymentLinesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {479DAFA4-3F69-4512-B3F8-E66436A851F6}
// *********************************************************************//
  ITradeEventPaymentLinesDisp = dispinterface
    ['{479DAFA4-3F69-4512-B3F8-E66436A851F6}']
    property thLine[Index: Integer]: ITradeEventPaymentLine readonly dispid 0; default;
    property thLineCount: Integer readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ITradeEventTender2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F8A005F-17D1-4BB4-A7EA-9E4D09E83F17}
// *********************************************************************//
  ITradeEventTender2 = interface(ITradeEventTender)
    ['{9F8A005F-17D1-4BB4-A7EA-9E4D09E83F17}']
    function Get_teChange: Double; safecall;
    procedure Set_teChange(Value: Double); safecall;
    function Get_teTotalOutstanding: Double; safecall;
    procedure Set_teTotalOutstanding(Value: Double); safecall;
    function Get_teNetAmount: Double; safecall;
    procedure Set_teNetAmount(Value: Double); safecall;
    function Get_teVatAmount: Double; safecall;
    procedure Set_teVatAmount(Value: Double); safecall;
    function Get_teTotalAmount: Double; safecall;
    procedure Set_teTotalAmount(Value: Double); safecall;
    function Get_teMoneyTaken: Double; safecall;
    procedure Set_teMoneyTaken(Value: Double); safecall;
    function Get_teDepositToBeTaken: Double; safecall;
    procedure Set_teDepositToBeTaken(Value: Double); safecall;
    function Get_teSettlementToBeTaken: WordBool; safecall;
    procedure Set_teSettlementToBeTaken(Value: WordBool); safecall;
    function Get_teSettlementAmount: Double; safecall;
    procedure Set_teSettlementAmount(Value: Double); safecall;
    function Get_tePrintTo: TTradePrintTo; safecall;
    procedure Set_tePrintTo(Value: TTradePrintTo); safecall;
    property teChange: Double read Get_teChange write Set_teChange;
    property teTotalOutstanding: Double read Get_teTotalOutstanding write Set_teTotalOutstanding;
    property teNetAmount: Double read Get_teNetAmount write Set_teNetAmount;
    property teVatAmount: Double read Get_teVatAmount write Set_teVatAmount;
    property teTotalAmount: Double read Get_teTotalAmount write Set_teTotalAmount;
    property teMoneyTaken: Double read Get_teMoneyTaken write Set_teMoneyTaken;
    property teDepositToBeTaken: Double read Get_teDepositToBeTaken write Set_teDepositToBeTaken;
    property teSettlementToBeTaken: WordBool read Get_teSettlementToBeTaken write Set_teSettlementToBeTaken;
    property teSettlementAmount: Double read Get_teSettlementAmount write Set_teSettlementAmount;
    property tePrintTo: TTradePrintTo read Get_tePrintTo write Set_tePrintTo;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventTender2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9F8A005F-17D1-4BB4-A7EA-9E4D09E83F17}
// *********************************************************************//
  ITradeEventTender2Disp = dispinterface
    ['{9F8A005F-17D1-4BB4-A7EA-9E4D09E83F17}']
    property teChange: Double dispid 7;
    property teTotalOutstanding: Double dispid 9;
    property teNetAmount: Double dispid 10;
    property teVatAmount: Double dispid 11;
    property teTotalAmount: Double dispid 12;
    property teMoneyTaken: Double dispid 13;
    property teDepositToBeTaken: Double dispid 14;
    property teSettlementToBeTaken: WordBool dispid 15;
    property teSettlementAmount: Double dispid 16;
    property tePrintTo: TTradePrintTo dispid 19;
    property teCash: Double dispid 1;
    property teCheque: Double dispid 2;
    property teCard: Double dispid 3;
    property teAccount: Double readonly dispid 5;
    property teCardDetails: ITradeCardDetails readonly dispid 6;
  end;

// *********************************************************************//
// Interface: ITradeEventSerialNo2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {07CFBE13-F7D4-4532-B1FD-7F1D571BB73E}
// *********************************************************************//
  ITradeEventSerialNo2 = interface(ITradeEventSerialNo)
    ['{07CFBE13-F7D4-4532-B1FD-7F1D571BB73E}']
    function Get_snBatchQtySelectedFloat: Double; safecall;
    function Get_snBatchQtyAvailableFloat: Double; safecall;
    property snBatchQtySelectedFloat: Double read Get_snBatchQtySelectedFloat;
    property snBatchQtyAvailableFloat: Double read Get_snBatchQtyAvailableFloat;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventSerialNo2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {07CFBE13-F7D4-4532-B1FD-7F1D571BB73E}
// *********************************************************************//
  ITradeEventSerialNo2Disp = dispinterface
    ['{07CFBE13-F7D4-4532-B1FD-7F1D571BB73E}']
    property snBatchQtySelectedFloat: Double readonly dispid 15;
    property snBatchQtyAvailableFloat: Double readonly dispid 17;
    property snSerialNo: WideString dispid 1;
    property snBatchNo: WideString dispid 2;
    property snType: TTradeSerialBatchType readonly dispid 3;
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
    property snBatchQtySelected: Integer readonly dispid 6;
    property snBatchQtyAvailable: Integer readonly dispid 7;
  end;

// *********************************************************************//
// Interface: ITradeEventTransLine2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6DA20229-75BA-4E84-A5C7-18C50463638C}
// *********************************************************************//
  ITradeEventTransLine2 = interface(ITradeEventTransLine)
    ['{6DA20229-75BA-4E84-A5C7-18C50463638C}']
    function Get_tlMultiBuyDiscount: Double; safecall;
    procedure Set_tlMultiBuyDiscount(Value: Double); safecall;
    function Get_tlMultiBuyDiscountFlag: WideString; safecall;
    procedure Set_tlMultiBuyDiscountFlag(const Value: WideString); safecall;
    function Get_tlTransValueDiscount: Double; safecall;
    procedure Set_tlTransValueDiscount(Value: Double); safecall;
    function Get_tlTransValueDiscountFlag: WideString; safecall;
    procedure Set_tlTransValueDiscountFlag(const Value: WideString); safecall;
    function Get_tlTransValueDiscountType: Smallint; safecall;
    procedure Set_tlTransValueDiscountType(Value: Smallint); safecall;
    property tlMultiBuyDiscount: Double read Get_tlMultiBuyDiscount write Set_tlMultiBuyDiscount;
    property tlMultiBuyDiscountFlag: WideString read Get_tlMultiBuyDiscountFlag write Set_tlMultiBuyDiscountFlag;
    property tlTransValueDiscount: Double read Get_tlTransValueDiscount write Set_tlTransValueDiscount;
    property tlTransValueDiscountFlag: WideString read Get_tlTransValueDiscountFlag write Set_tlTransValueDiscountFlag;
    property tlTransValueDiscountType: Smallint read Get_tlTransValueDiscountType write Set_tlTransValueDiscountType;
  end;

// *********************************************************************//
// DispIntf:  ITradeEventTransLine2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6DA20229-75BA-4E84-A5C7-18C50463638C}
// *********************************************************************//
  ITradeEventTransLine2Disp = dispinterface
    ['{6DA20229-75BA-4E84-A5C7-18C50463638C}']
    property tlMultiBuyDiscount: Double dispid 55;
    property tlMultiBuyDiscountFlag: WideString dispid 56;
    property tlTransValueDiscount: Double dispid 57;
    property tlTransValueDiscountFlag: WideString dispid 58;
    property tlTransValueDiscountType: Smallint dispid 59;
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
    property tlLocation: ITradeEventLocation readonly dispid 26;
    property tlChargeCurrency: Integer dispid 27;
    property tlAcCode: WideString readonly dispid 28;
    property tlLineType: TTradeTransLineType dispid 29;
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
    property tlStock: ITradeEventStock readonly dispid 50;
    property tlSerialNumbers: ITradeEventSerialNumbers readonly dispid 52;
    procedure Save; dispid 53;
    procedure Cancel; dispid 54;
  end;

// *********************************************************************//
// The Class CoCustomisation provides a Create and CreateRemote method to          
// create instances of the default interface IDummy exposed by              
// the CoClass Customisation. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCustomisation = class
    class function Create: IDummy;
    class function CreateRemote(const MachineName: string): IDummy;
  end;

implementation

uses ComObj;

class function CoCustomisation.Create: IDummy;
begin
  Result := CreateComObject(CLASS_Customisation) as IDummy;
end;

class function CoCustomisation.CreateRemote(const MachineName: string): IDummy;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Customisation) as IDummy;
end;

end.
