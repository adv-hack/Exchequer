unit Enterprise_TLB;

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

// PASTLWTR : 1.2
// File generated on 19/08/2005 14:25:49 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\excheqr\570Beta\ENTER1.EXE (1)
// LIBID: {95BEDB60-A8B0-11D3-A990-0080C87D89BD}
// LCID: 0
// Helpfile: 
// HelpString: Enterprise COM Customisation 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  EnterpriseMajorVersion = 1;
  EnterpriseMinorVersion = 0;

  LIBID_Enterprise: TGUID = '{95BEDB60-A8B0-11D3-A990-0080C87D89BD}';

  IID_ICOMCustomisation: TGUID = '{95BEDB61-A8B0-11D3-A990-0080C87D89BD}';
  DIID_ICOMCustomisationEvents: TGUID = '{95BEDB63-A8B0-11D3-A990-0080C87D89BD}';
  CLASS_COMCustomisation: TGUID = '{95BEDB65-A8B0-11D3-A990-0080C87D89BD}';
  IID_ICOMEventData: TGUID = '{79E43780-E3BD-11D3-A990-0050DA3DF9AD}';
  IID_ICOMCustomer: TGUID = '{C7AFCAC3-A979-11D3-A990-0080C87D89BD}';
  IID_ICOMSetup: TGUID = '{2B43B140-C73F-11D3-A990-0080C87D89BD}';
  IID_ICOMSetupCurrency: TGUID = '{B62D3641-C74A-11D3-A990-0080C87D89BD}';
  IID_ICOMSetupVAT: TGUID = '{B62D364D-C74A-11D3-A990-0080C87D89BD}';
  IID_ICOMSetupUserFields: TGUID = '{B62D3667-C74A-11D3-A990-0080C87D89BD}';
  IID_ICOMCCDept: TGUID = '{BF64DA40-C846-11D3-A990-0080C87D89BD}';
  IID_ICOMGLCode: TGUID = '{3F711180-C8CA-11D3-A990-0050DA3DF9AD}';
  IID_ICOMStock: TGUID = '{3F711189-C8CA-11D3-A990-0050DA3DF9AD}';
  IID_ICOMTransaction: TGUID = '{3F711192-C8CA-11D3-A990-0050DA3DF9AD}';
  IID_ICOMTransactionLines: TGUID = '{CCD86082-C8D8-11D3-A990-0050DA3DF9AD}';
  IID_ICOMTransactionLine: TGUID = '{CCD86084-C8D8-11D3-A990-0050DA3DF9AD}';
  IID_ICOMBatchSerial: TGUID = '{1FAA1706-C900-11D3-A990-0050DA3DF9AD}';
  IID_ICOMJob: TGUID = '{AF9CC260-D310-11D3-A990-0050DA3DF9AD}';
  IID_ICOMMiscData: TGUID = '{629744C0-DD71-11D3-A990-0050DA3DF9AD}';
  IID_ICOMEventData01: TGUID = '{45953060-E453-11D3-A990-0050DA3DF9AD}';
  IID_ICOMVersion: TGUID = '{8512EC3D-E481-11D3-A990-0050DA3DF9AD}';
  IID_ICOMSysFunc: TGUID = '{BEA7CCE0-21CC-11D4-A992-0050DA3DF9AD}';
  IID_ICOMCustomisation2: TGUID = '{79F69B60-A01C-4049-8BC5-8E0B9F439EBB}';
  IID_ICOMCustomer2: TGUID = '{5425F9BC-99CB-4771-8F4D-2339CA554551}';
  IID_ICOMTransaction2: TGUID = '{F195CC99-331C-4B48-90DE-04A1FA83C5D1}';
  IID_ICOMStock2: TGUID = '{0BF450C2-79B5-4458-87D0-A8F623635EF8}';
  IID_ICOMCustomisation3: TGUID = '{0DE773A0-DB78-4A38-83B4-96AC09B2CC80}';
  IID_ICOMUserProfile: TGUID = '{CB46487C-2F90-4FC5-9128-E33654FCE66F}';
  IID_ICOMSetupUserFields2: TGUID = '{662955BA-B1A9-4B89-99BE-6156FFDEF007}';
  IID_ICOMSetupPaperless: TGUID = '{32A082D2-6E09-43F1-8CBC-59C0C7999891}';
  IID_ICOMSetup2: TGUID = '{917B195D-6DF6-47B9-9E30-BD205FE7D09A}';
  IID_ICOMCustomisation4: TGUID = '{E4F9B3BD-33F1-499B-B540-28A168824B67}';
  IID_ICOMSetup3: TGUID = '{A452C452-C5BD-4CDF-AB9E-BCF1155CDB56}';
  IID_ICOMSetupCIS: TGUID = '{3D255120-1B32-4C4B-B2BA-40D9F96FF1C8}';
  IID_ICOMSetupCISRate: TGUID = '{80C87F5A-633E-4393-A3E7-2BEF6ED112C0}';
  IID_ICOMSetupCISVoucherCounter: TGUID = '{55C696C4-2CCD-4D08-9AD5-894C6C102B6E}';
  IID_ICOMSetupJobCosting: TGUID = '{776A4D56-9689-4737-BC50-8001EBA3C84C}';
  IID_ICOMEventData2: TGUID = '{EFC2263F-811C-40AD-B756-EA4DBD641FAF}';
  IID_ICOMCustomer3: TGUID = '{C34250A9-4AF8-4906-9E8E-732497F778AD}';
  IID_ICOMTransaction3: TGUID = '{0AC799EA-1940-4597-AC14-51916BDEC1F9}';
  IID_ICOMTelesales: TGUID = '{D751489D-B2E8-497C-B654-4ED434EE4270}';
  IID_ICOMTransactionLine2: TGUID = '{1286D1D2-75FD-4AE2-92EA-A91449DC3213}';
  IID_ICOMTelesalesLine: TGUID = '{22D35A6C-46A9-4029-B6D0-22F8615EBB2A}';
  IID_ICOMJobCosting: TGUID = '{BC3EB93E-C676-4778-8142-F7F89BB7AC2C}';
  IID_ICOMCISVoucher: TGUID = '{ECF2F0E7-9768-434E-A509-F29D3F6AE90F}';
  IID_ICOMEmployee: TGUID = '{B261653B-0A89-4A75-B7A3-7CE41DF0E1E6}';
  IID_ICOMJob2: TGUID = '{321B4CA3-D591-409B-820F-1A617B9221F8}';
  IID_ICOMJobActual: TGUID = '{78E06513-49E4-4EC0-AEFF-764FF0E328D4}';
  IID_ICOMCurrencyTriangulation: TGUID = '{2618516C-D331-4720-A585-1949E44C9C6A}';
  IID_ICOMJobBudget: TGUID = '{98376108-E871-42C4-ADFB-67E69CBE4CD0}';
  IID_ICOMJobRetention: TGUID = '{FEFDBBF0-8C82-464A-9AD7-71C01BB19112}';
  IID_ICOMJobAnalysis: TGUID = '{EC6592D4-B162-4EF1-B926-E87C39746DE6}';
  IID_ICOMTimeRate: TGUID = '{027222A0-90BA-4D78-A03B-1A3C363BA335}';
  IID_ICOMEmployee2: TGUID = '{F393D401-B2BE-4776-BBF0-46F9FA5E26FD}';
  IID_ICOMTransactionLine3: TGUID = '{E7C63D20-AA70-4212-9574-6F7EC2B2EC18}';
  IID_ICOMTransaction4: TGUID = '{4900066B-D570-45BA-A06A-45B78963DF0E}';
  IID_ICOMBatchSerial2: TGUID = '{93DC2533-BAC5-49B3-ADF8-07D4C44B8149}';
  IID_ICOMEventData3: TGUID = '{6F3207B5-4384-4AA0-B50E-88F9EE983D63}';
  IID_ICOMSetup4: TGUID = '{94FB01F0-BDBD-458C-AF75-575A9219F574}';
  IID_ICOMCustomisation5: TGUID = '{9EFB5D8F-5819-4C37-AD73-FAF9A20FC3F4}';
  IID_ICOMMultiBin: TGUID = '{2C5CE082-5B08-4CF6-9475-E754ED703B82}';
  IID_ICOMStock3: TGUID = '{088562D4-FF19-4E04-A4EE-02E9E5855454}';
  IID_ICOMTransaction5: TGUID = '{D611BE2D-7D48-44FF-AD58-016B1A62FFEF}';
  IID_ICOMTransactionLine4: TGUID = '{07C085B6-4DAF-4FA0-9396-D7046B9827E9}';
  IID_ICOMSetupCIS2: TGUID = '{8916EB6E-D59B-4051-9F76-ABBC8CE73719}';
  IID_ICOMJobAnalysis2: TGUID = '{FDE7569E-CB0A-4C9E-8F3C-1FB36397E890}';
  IID_ICOMJob3: TGUID = '{7748557F-764D-41C2-98A9-A93DFF9DF869}';
  IID_ICOMJobRetention2: TGUID = '{79713D70-17B6-494C-A292-60159C1FC636}';
  IID_ICOMJobBudget2: TGUID = '{5B426A81-A067-41F2-806A-4B35C7B90841}';
  IID_ICOMStock4: TGUID = '{FA61BF62-6323-4D67-8F8C-BD30F9C96C03}';
  IID_ICOMBatchSerial3: TGUID = '{D6D0D3FA-36EC-4A95-BA62-502534FB262E}';
  IID_ICOMTransactionLine5: TGUID = '{3458E863-6094-4BE1-A978-4C1F34E22B82}';
  IID_ICOMMultiBin2: TGUID = '{3E11579D-F3AF-4A3B-817E-9725317EC233}';
  IID_ICOMLocation: TGUID = '{8C9EB88B-364E-4F3C-8F5F-A1B62682C51B}';
  IID_ICOMStockLocation: TGUID = '{1EC27153-AB88-4526-8B2E-18AA94714EFE}';
  IID_ICOMPaperless: TGUID = '{0D819C18-E717-40E3-9F10-D172BB5EB5AC}';
  IID_ICOMPaperlessEmail: TGUID = '{14F0A5B0-0DFF-4515-93D8-28A40340E513}';
  IID_ICOMEventData4: TGUID = '{9BE5E685-069F-48E0-B49A-59804BD9382F}';
  IID_ICOMPaperlessEmailAddressArray: TGUID = '{45BE6DBF-A1BD-4C5B-91EA-00E5D0629C6C}';
  IID_ICOMPaperlessEmailAddress: TGUID = '{42347784-F201-45EA-8C7D-FCFF8EFCD1A5}';
  IID_ICOMPaperlessEmailAttachments: TGUID = '{7478AD7D-C711-444D-8FF8-0DCE3A99B798}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TAccountStatus
type
  TAccountStatus = TOleEnum;
const
  acStatusOpen = $00000000;
  acStatusNotes = $00000001;
  acStatusOnHold = $00000002;
  acStatusClosed = $00000003;

// Constants for enum TCurrencyType
type
  TCurrencyType = TOleEnum;
const
  cuConsolidated = $00000000;
  cuCurr1 = $00000001;
  cuCurr2 = $00000002;
  cuCurr3 = $00000003;
  cuCurr4 = $00000004;
  cuCurr5 = $00000005;
  cuCurr6 = $00000006;
  cuCurr7 = $00000007;
  cuCurr8 = $00000008;
  cuCurr9 = $00000009;
  cuCurr10 = $0000000A;
  cuCurr11 = $0000000B;
  cuCurr12 = $0000000C;
  cuCurr13 = $0000000D;
  cuCurr14 = $0000000E;
  cuCurr15 = $0000000F;
  cuCurr16 = $00000010;
  cuCurr17 = $00000011;
  cuCurr18 = $00000012;
  cuCurr19 = $00000013;
  cuCurr20 = $00000014;
  cuCurr21 = $00000015;
  cuCurr22 = $00000016;
  cuCurr23 = $00000017;
  cuCurr24 = $00000018;
  cuCurr25 = $00000019;
  cuCurr26 = $0000001A;
  cuCurr27 = $0000001B;
  cuCurr28 = $0000001C;
  cuCurr29 = $0000001D;
  cuCurr30 = $0000001E;
  cuCurr31 = $0000001F;
  cuCurr32 = $00000020;
  cuCurr33 = $00000021;
  cuCurr34 = $00000022;
  cuCurr35 = $00000023;
  cuCurr36 = $00000024;
  cuCurr37 = $00000025;
  cuCurr38 = $00000026;
  cuCurr39 = $00000027;
  cuCurr40 = $00000028;
  cuCurr41 = $00000029;
  cuCurr42 = $0000002A;
  cuCurr43 = $0000002B;
  cuCurr44 = $0000002C;
  cuCurr45 = $0000002D;
  cuCurr46 = $0000002E;
  cuCurr47 = $0000002F;
  cuCurr48 = $00000030;
  cuCurr49 = $00000031;
  cuCurr50 = $00000032;
  cuCurr51 = $00000033;
  cuCurr52 = $00000034;
  cuCurr53 = $00000035;
  cuCurr54 = $00000036;
  cuCurr55 = $00000037;
  cuCurr56 = $00000038;
  cuCurr57 = $00000039;
  cuCurr58 = $0000003A;
  cuCurr59 = $0000003B;
  cuCurr60 = $0000003C;
  cuCurr61 = $0000003D;
  cuCurr62 = $0000003E;
  cuCurr63 = $0000003F;
  cuCurr64 = $00000040;
  cuCurr65 = $00000041;
  cuCurr66 = $00000042;
  cuCurr67 = $00000043;
  cuCurr68 = $00000042;
  cuCurr69 = $00000045;
  cuCurr70 = $00000046;
  cuCurr71 = $00000047;
  cuCurr72 = $00000048;
  cuCurr73 = $00000049;
  cuCurr74 = $0000004A;
  cuCurr75 = $0000004B;
  cuCurr76 = $0000004C;
  cuCurr77 = $0000004D;
  cuCurr78 = $0000004E;
  cuCurr79 = $0000004F;
  cuCurr80 = $00000050;
  cuCurr81 = $00000051;
  cuCurr82 = $00000052;
  cuCurr83 = $00000053;
  cuCurr84 = $00000054;
  cuCurr85 = $00000055;
  cuCurr86 = $00000056;
  cuCurr87 = $00000057;
  cuCurr88 = $00000058;
  cuCurr89 = $00000059;

// Constants for enum TDocTypes
type
  TDocTypes = TOleEnum;
const
  cuSIN = $00000000;
  cuSRC = $00000001;
  cuSCR = $00000002;
  cuSJI = $00000003;
  cuSJC = $00000004;
  cuSRF = $00000005;
  cuSRI = $00000006;
  cuSQU = $00000007;
  cuSOR = $00000008;
  cuSDN = $00000009;
  cuSBT = $0000000A;
  cuSDG = $0000000B;
  cuNDG = $0000000C;
  cuOVT = $0000000D;
  cuDEB = $0000000E;
  cuPIN = $0000000F;
  cuPPY = $00000010;
  cuPCR = $00000011;
  cuPJI = $00000012;
  cuPJC = $00000013;
  cuPRF = $00000014;
  cuPPI = $00000015;
  cuPQU = $00000016;
  cuPOR = $00000017;
  cuPDN = $00000018;
  cuPBT = $00000019;
  cuSDT = $0000001A;
  cuNDT = $0000001B;
  cuIVT = $0000001C;
  cuCRE = $0000001D;
  cuNMT = $0000001E;
  cuRUN = $0000001F;
  cuFOL = $00000020;
  cuAFL = $00000021;
  cuADC = $00000022;
  cuADJ = $00000023;
  cuACQ = $00000024;
  cuAPI = $00000025;
  cuSKF = $00000026;
  cuJBF = $00000027;
  cuWOR = $00000028;
  cuTSH = $00000029;
  cuJRN = $0000002A;
  cuWIN = $0000002B;
  cuSRN = $0000002C;
  cuPRN = $0000002D;
  cuJCT = $0000002E;
  cuJST = $0000002F;
  cuJPT = $00000030;
  cuJSA = $00000031;
  cuJPA = $00000032;

// Constants for enum TEventStatus
type
  TEventStatus = TOleEnum;
const
  esDisabled = $00000000;
  esEnabled = $00000001;

// Constants for enum TNomCtrlType
type
  TNomCtrlType = TOleEnum;
const
  nmInVAT = $00000000;
  nmOutVAT = $00000001;
  nmDebtors = $00000002;
  nmCreditors = $00000003;
  nmDiscountGiven = $00000004;
  nmDiscountTaken = $00000005;
  nmLDiscGiven = $00000006;
  nmLDiscTaken = $00000007;
  nmProfitBF = $00000008;
  nmCurrVar = $00000009;
  nmUnRCurrVar = $0000000A;
  nmPLStart = $0000000B;
  nmPLEnd = $0000000C;
  nmFreightNC = $0000000D;
  nmNSpare5 = $0000000E;
  nmNSpare6 = $0000000F;
  nmNSpare7 = $00000010;
  nmNSpare8 = $00000011;
  nmNSpare9 = $00000012;
  nmNSpare10 = $00000013;
  nmNSpare11 = $00000014;
  nmNSpare12 = $00000015;
  nmNSpare13 = $00000016;
  nmNSpare14 = $00000017;

// Constants for enum TRecordAccessStatus
type
  TRecordAccessStatus = TOleEnum;
const
  arNotAvailable = $00000000;
  arReadOnly = $00000001;
  arReadWrite = $00000002;

// Constants for enum TTermsIndex
type
  TTermsIndex = TOleEnum;
const
  tiTerm1 = $00000001;
  tiTerm2 = $00000002;

// Constants for enum TVATIndex
type
  TVATIndex = TOleEnum;
const
  vatStandard = $00000000;
  vatExempt = $00000001;
  vatZero = $00000002;
  vatRate1 = $00000003;
  vatRate2 = $00000004;
  vatRate3 = $00000005;
  vatRate4 = $00000006;
  vatRate5 = $00000007;
  vatRate6 = $00000008;
  vatRate7 = $00000009;
  vatRate8 = $0000000A;
  vatRate9 = $0000000B;
  vatRate10 = $0000000C;
  vatRate11 = $0000000D;
  vatRate12 = $0000000E;
  vatRate13 = $0000000F;
  vatRate14 = $00000010;
  vatRate15 = $00000011;
  vatRate16 = $00000012;
  vatRate17 = $00000013;
  vatRate18 = $00000014;
  vatIAdj = $00000015;
  vatOAdj = $00000016;
  vatSpare8 = $00000017;

// Constants for enum TWindowId
type
  TWindowId = TOleEnum;
const
  wiAccount = $00018A88;
  wiTransaction = $00018E70;
  wiStock = $00019258;
  wiSerialBatch = $000192BC;
  wiTransLine = $00019640;
  wiJobRec = $00019A28;
  wiMisc = $0002E630;
  wiBACS = $00018EA2;
  wiStockDetail = $00019259;
  wiLocation = $00019E10;
  wiStockLoc = $0001A1F8;
  wiPrint = $0001A5E0;

// Constants for enum TEntMsgDlgType
type
  TEntMsgDlgType = TOleEnum;
const
  emtWarning = $00000000;
  emtError = $00000001;
  emtInformation = $00000002;
  emtConfirmation = $00000003;
  emtCustom = $00000004;

// Constants for enum TEntMsgDlgButtons
type
  TEntMsgDlgButtons = TOleEnum;
const
  embYes = $00000001;
  embNo = $00000002;
  embOK = $00000004;
  embCancel = $00000008;
  embAbort = $00000010;
  embRetry = $00000020;
  embIgnore = $00000040;
  embAll = $00000080;
  embNoToAll = $00000100;
  embYesToAll = $00000200;
  embHelp = $00000400;

// Constants for enum TentMsgDlgReturn
type
  TentMsgDlgReturn = TOleEnum;
const
  emrNone = $00000000;
  emrOk = $00000001;
  emrCancel = $00000002;
  emrAbort = $00000003;
  emrRetry = $00000004;
  emrIgnore = $00000005;
  emrYes = $00000006;
  emrNo = $00000007;
  emrAll = $00000008;
  emrNoToAll = $00000009;
  emrYesToAll = $0000000A;

// Constants for enum TCISTaxType
type
  TCISTaxType = TOleEnum;
const
  cisttConstruction = $00000000;
  cisttTechnical = $00000001;

// Constants for enum TCISVoucherType
type
  TCISVoucherType = TOleEnum;
const
  cvt23 = $00000000;
  cvt24 = $00000001;
  cvt25 = $00000002;

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
  jcSubContractLabour = $0000000A;
  jcMaterials2 = $0000000B;
  jcOverheads2 = $0000000C;
  jcSalesDeductions = $0000000D;
  jcSalesApplications = $0000000E;
  jcPurchaseApplications = $0000000F;
  jcPurchaseDeductions = $00000010;

// Constants for enum TJobGLCtrlType
type
  TJobGLCtrlType = TOleEnum;
const
  ssjGLOverhead = $00000000;
  ssjGLProdution = $00000001;
  ssjGLSubContract = $00000002;

// Constants for enum TNOMLineVATType
type
  TNOMLineVATType = TOleEnum;
const
  nlvNA = $00000000;
  nlvAuto = $00000001;
  nlvManual = $00000002;

// Constants for enum TNOMVATIOType
type
  TNOMVATIOType = TOleEnum;
const
  nvioNA = $00000000;
  nvioInput = $00000001;
  nvioOutput = $00000002;

// Constants for enum TStockWarrantyUnits
type
  TStockWarrantyUnits = TOleEnum;
const
  wpDays = $00000000;
  wpWeeks = $00000001;
  wpMonths = $00000002;
  wpYears = $00000003;

// Constants for enum TEmailPriority
type
  TEmailPriority = TOleEnum;
const
  epLow = $00000000;
  epNormal = $00000001;
  epHigh = $00000002;

// Constants for enum TStockRestockChargeType
type
  TStockRestockChargeType = TOleEnum;
const
  rcValue = $00000000;
  rcPercentage = $00000001;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ICOMCustomisation = interface;
  ICOMCustomisationDisp = dispinterface;
  ICOMCustomisationEvents = dispinterface;
  ICOMEventData = interface;
  ICOMEventDataDisp = dispinterface;
  ICOMCustomer = interface;
  ICOMCustomerDisp = dispinterface;
  ICOMSetup = interface;
  ICOMSetupDisp = dispinterface;
  ICOMSetupCurrency = interface;
  ICOMSetupCurrencyDisp = dispinterface;
  ICOMSetupVAT = interface;
  ICOMSetupVATDisp = dispinterface;
  ICOMSetupUserFields = interface;
  ICOMSetupUserFieldsDisp = dispinterface;
  ICOMCCDept = interface;
  ICOMCCDeptDisp = dispinterface;
  ICOMGLCode = interface;
  ICOMGLCodeDisp = dispinterface;
  ICOMStock = interface;
  ICOMStockDisp = dispinterface;
  ICOMTransaction = interface;
  ICOMTransactionDisp = dispinterface;
  ICOMTransactionLines = interface;
  ICOMTransactionLinesDisp = dispinterface;
  ICOMTransactionLine = interface;
  ICOMTransactionLineDisp = dispinterface;
  ICOMBatchSerial = interface;
  ICOMBatchSerialDisp = dispinterface;
  ICOMJob = interface;
  ICOMJobDisp = dispinterface;
  ICOMMiscData = interface;
  ICOMMiscDataDisp = dispinterface;
  ICOMEventData01 = interface;
  ICOMEventData01Disp = dispinterface;
  ICOMVersion = interface;
  ICOMVersionDisp = dispinterface;
  ICOMSysFunc = interface;
  ICOMSysFuncDisp = dispinterface;
  ICOMCustomisation2 = interface;
  ICOMCustomisation2Disp = dispinterface;
  ICOMCustomer2 = interface;
  ICOMCustomer2Disp = dispinterface;
  ICOMTransaction2 = interface;
  ICOMTransaction2Disp = dispinterface;
  ICOMStock2 = interface;
  ICOMStock2Disp = dispinterface;
  ICOMCustomisation3 = interface;
  ICOMCustomisation3Disp = dispinterface;
  ICOMUserProfile = interface;
  ICOMUserProfileDisp = dispinterface;
  ICOMSetupUserFields2 = interface;
  ICOMSetupUserFields2Disp = dispinterface;
  ICOMSetupPaperless = interface;
  ICOMSetupPaperlessDisp = dispinterface;
  ICOMSetup2 = interface;
  ICOMSetup2Disp = dispinterface;
  ICOMCustomisation4 = interface;
  ICOMCustomisation4Disp = dispinterface;
  ICOMSetup3 = interface;
  ICOMSetup3Disp = dispinterface;
  ICOMSetupCIS = interface;
  ICOMSetupCISDisp = dispinterface;
  ICOMSetupCISRate = interface;
  ICOMSetupCISRateDisp = dispinterface;
  ICOMSetupCISVoucherCounter = interface;
  ICOMSetupCISVoucherCounterDisp = dispinterface;
  ICOMSetupJobCosting = interface;
  ICOMSetupJobCostingDisp = dispinterface;
  ICOMEventData2 = interface;
  ICOMEventData2Disp = dispinterface;
  ICOMCustomer3 = interface;
  ICOMCustomer3Disp = dispinterface;
  ICOMTransaction3 = interface;
  ICOMTransaction3Disp = dispinterface;
  ICOMTelesales = interface;
  ICOMTelesalesDisp = dispinterface;
  ICOMTransactionLine2 = interface;
  ICOMTransactionLine2Disp = dispinterface;
  ICOMTelesalesLine = interface;
  ICOMTelesalesLineDisp = dispinterface;
  ICOMJobCosting = interface;
  ICOMJobCostingDisp = dispinterface;
  ICOMCISVoucher = interface;
  ICOMCISVoucherDisp = dispinterface;
  ICOMEmployee = interface;
  ICOMEmployeeDisp = dispinterface;
  ICOMJob2 = interface;
  ICOMJob2Disp = dispinterface;
  ICOMJobActual = interface;
  ICOMJobActualDisp = dispinterface;
  ICOMCurrencyTriangulation = interface;
  ICOMCurrencyTriangulationDisp = dispinterface;
  ICOMJobBudget = interface;
  ICOMJobBudgetDisp = dispinterface;
  ICOMJobRetention = interface;
  ICOMJobRetentionDisp = dispinterface;
  ICOMJobAnalysis = interface;
  ICOMJobAnalysisDisp = dispinterface;
  ICOMTimeRate = interface;
  ICOMTimeRateDisp = dispinterface;
  ICOMEmployee2 = interface;
  ICOMEmployee2Disp = dispinterface;
  ICOMTransactionLine3 = interface;
  ICOMTransactionLine3Disp = dispinterface;
  ICOMTransaction4 = interface;
  ICOMTransaction4Disp = dispinterface;
  ICOMBatchSerial2 = interface;
  ICOMBatchSerial2Disp = dispinterface;
  ICOMEventData3 = interface;
  ICOMEventData3Disp = dispinterface;
  ICOMSetup4 = interface;
  ICOMSetup4Disp = dispinterface;
  ICOMCustomisation5 = interface;
  ICOMCustomisation5Disp = dispinterface;
  ICOMMultiBin = interface;
  ICOMMultiBinDisp = dispinterface;
  ICOMStock3 = interface;
  ICOMStock3Disp = dispinterface;
  ICOMTransaction5 = interface;
  ICOMTransaction5Disp = dispinterface;
  ICOMTransactionLine4 = interface;
  ICOMTransactionLine4Disp = dispinterface;
  ICOMSetupCIS2 = interface;
  ICOMSetupCIS2Disp = dispinterface;
  ICOMJobAnalysis2 = interface;
  ICOMJobAnalysis2Disp = dispinterface;
  ICOMJob3 = interface;
  ICOMJob3Disp = dispinterface;
  ICOMJobRetention2 = interface;
  ICOMJobRetention2Disp = dispinterface;
  ICOMJobBudget2 = interface;
  ICOMJobBudget2Disp = dispinterface;
  ICOMStock4 = interface;
  ICOMStock4Disp = dispinterface;
  ICOMBatchSerial3 = interface;
  ICOMBatchSerial3Disp = dispinterface;
  ICOMTransactionLine5 = interface;
  ICOMTransactionLine5Disp = dispinterface;
  ICOMMultiBin2 = interface;
  ICOMMultiBin2Disp = dispinterface;
  ICOMLocation = interface;
  ICOMLocationDisp = dispinterface;
  ICOMStockLocation = interface;
  ICOMStockLocationDisp = dispinterface;
  ICOMPaperless = interface;
  ICOMPaperlessDisp = dispinterface;
  ICOMPaperlessEmail = interface;
  ICOMPaperlessEmailDisp = dispinterface;
  ICOMEventData4 = interface;
  ICOMEventData4Disp = dispinterface;
  ICOMPaperlessEmailAddressArray = interface;
  ICOMPaperlessEmailAddressArrayDisp = dispinterface;
  ICOMPaperlessEmailAddress = interface;
  ICOMPaperlessEmailAddressDisp = dispinterface;
  ICOMPaperlessEmailAttachments = interface;
  ICOMPaperlessEmailAttachmentsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  COMCustomisation = ICOMCustomisation;


// *********************************************************************//
// Interface: ICOMCustomisation
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {95BEDB61-A8B0-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMCustomisation = interface(IDispatch)
    ['{95BEDB61-A8B0-11D3-A990-0080C87D89BD}']
    function Get_ClassVersion: WideString; safecall;
    function Get_SystemSetup: ICOMSetup; safecall;
    function Get_UserName: WideString; safecall;
    function Get_VersionInfo: ICOMVersion; safecall;
    procedure AddAboutString(const AboutText: WideString); safecall;
    procedure EnableHook(WindowId: Integer; HandlerId: Integer); safecall;
    function entRound(Num: Double; Decs: Integer): Double; safecall;
    function entCalc_PcntPcnt(PAmount: Double; Pc1: Double; Pc2: Double; const PCh1: WideString; 
                              const PCh2: WideString): Double; safecall;
    function entGetTaxNo(const VCode: WideString): TVATIndex; safecall;
    function Get_SysFunc: ICOMSysFunc; safecall;
    property ClassVersion: WideString read Get_ClassVersion;
    property SystemSetup: ICOMSetup read Get_SystemSetup;
    property UserName: WideString read Get_UserName;
    property VersionInfo: ICOMVersion read Get_VersionInfo;
    property SysFunc: ICOMSysFunc read Get_SysFunc;
  end;

// *********************************************************************//
// DispIntf:  ICOMCustomisationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {95BEDB61-A8B0-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMCustomisationDisp = dispinterface
    ['{95BEDB61-A8B0-11D3-A990-0080C87D89BD}']
    property ClassVersion: WideString readonly dispid 1;
    property SystemSetup: ICOMSetup readonly dispid 2;
    property UserName: WideString readonly dispid 3;
    property VersionInfo: ICOMVersion readonly dispid 4;
    procedure AddAboutString(const AboutText: WideString); dispid 5;
    procedure EnableHook(WindowId: Integer; HandlerId: Integer); dispid 6;
    function entRound(Num: Double; Decs: Integer): Double; dispid 7;
    function entCalc_PcntPcnt(PAmount: Double; Pc1: Double; Pc2: Double; const PCh1: WideString; 
                              const PCh2: WideString): Double; dispid 8;
    function entGetTaxNo(const VCode: WideString): TVATIndex; dispid 9;
    property SysFunc: ICOMSysFunc readonly dispid 10;
  end;

// *********************************************************************//
// DispIntf:  ICOMCustomisationEvents
// Flags:     (4096) Dispatchable
// GUID:      {95BEDB63-A8B0-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMCustomisationEvents = dispinterface
    ['{95BEDB63-A8B0-11D3-A990-0080C87D89BD}']
    procedure OnHook(const EventData: ICOMEventData); dispid 1;
    procedure OnClose; dispid 2;
  end;

// *********************************************************************//
// Interface: ICOMEventData
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {79E43780-E3BD-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMEventData = interface(IDispatch)
    ['{79E43780-E3BD-11D3-A990-0050DA3DF9AD}']
    function Get_WindowId: Integer; safecall;
    function Get_HandlerId: Integer; safecall;
    function Get_Customer: ICOMCustomer; safecall;
    function Get_Supplier: ICOMCustomer; safecall;
    function Get_CostCentre: ICOMCCDept; safecall;
    function Get_Department: ICOMCCDept; safecall;
    function Get_GLCode: ICOMGLCode; safecall;
    function Get_Stock: ICOMStock; safecall;
    function Get_Transaction: ICOMTransaction; safecall;
    function Get_Job: ICOMJob; safecall;
    function Get_MiscData: ICOMMiscData; safecall;
    function Get_ValidStatus: WordBool; safecall;
    procedure Set_ValidStatus(Value: WordBool); safecall;
    function Get_BoResult: WordBool; safecall;
    procedure Set_BoResult(Value: WordBool); safecall;
    function Get_DblResult: Double; safecall;
    procedure Set_DblResult(Value: Double); safecall;
    function Get_IntResult: Integer; safecall;
    procedure Set_IntResult(Value: Integer); safecall;
    function Get_StrResult: WideString; safecall;
    procedure Set_StrResult(const Value: WideString); safecall;
    function Get_VarResult: OleVariant; safecall;
    procedure Set_VarResult(Value: OleVariant); safecall;
    function Get_InEditMode: WordBool; safecall;
    property WindowId: Integer read Get_WindowId;
    property HandlerId: Integer read Get_HandlerId;
    property Customer: ICOMCustomer read Get_Customer;
    property Supplier: ICOMCustomer read Get_Supplier;
    property CostCentre: ICOMCCDept read Get_CostCentre;
    property Department: ICOMCCDept read Get_Department;
    property GLCode: ICOMGLCode read Get_GLCode;
    property Stock: ICOMStock read Get_Stock;
    property Transaction: ICOMTransaction read Get_Transaction;
    property Job: ICOMJob read Get_Job;
    property MiscData: ICOMMiscData read Get_MiscData;
    property ValidStatus: WordBool read Get_ValidStatus write Set_ValidStatus;
    property BoResult: WordBool read Get_BoResult write Set_BoResult;
    property DblResult: Double read Get_DblResult write Set_DblResult;
    property IntResult: Integer read Get_IntResult write Set_IntResult;
    property StrResult: WideString read Get_StrResult write Set_StrResult;
    property VarResult: OleVariant read Get_VarResult write Set_VarResult;
    property InEditMode: WordBool read Get_InEditMode;
  end;

// *********************************************************************//
// DispIntf:  ICOMEventDataDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {79E43780-E3BD-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMEventDataDisp = dispinterface
    ['{79E43780-E3BD-11D3-A990-0050DA3DF9AD}']
    property WindowId: Integer readonly dispid 1;
    property HandlerId: Integer readonly dispid 2;
    property Customer: ICOMCustomer readonly dispid 3;
    property Supplier: ICOMCustomer readonly dispid 4;
    property CostCentre: ICOMCCDept readonly dispid 5;
    property Department: ICOMCCDept readonly dispid 6;
    property GLCode: ICOMGLCode readonly dispid 7;
    property Stock: ICOMStock readonly dispid 8;
    property Transaction: ICOMTransaction readonly dispid 9;
    property Job: ICOMJob readonly dispid 10;
    property MiscData: ICOMMiscData readonly dispid 11;
    property ValidStatus: WordBool dispid 12;
    property BoResult: WordBool dispid 13;
    property DblResult: Double dispid 14;
    property IntResult: Integer dispid 15;
    property StrResult: WideString dispid 16;
    property VarResult: OleVariant dispid 17;
    property InEditMode: WordBool readonly dispid 25;
  end;

// *********************************************************************//
// Interface: ICOMCustomer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C7AFCAC3-A979-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMCustomer = interface(IDispatch)
    ['{C7AFCAC3-A979-11D3-A990-0080C87D89BD}']
    function Get_acCode: WideString; safecall;
    procedure Set_acCode(const Value: WideString); safecall;
    function Get_AccessRights: TRecordAccessStatus; safecall;
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
    function Get_acDelAddr: WordBool; safecall;
    procedure Set_acDelAddr(Value: WordBool); safecall;
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
    function Get_acPhone2: WideString; safecall;
    procedure Set_acPhone2(const Value: WideString); safecall;
    function Get_acCOSGL: Integer; safecall;
    procedure Set_acCOSGL(Value: Integer); safecall;
    function Get_acDrCrGL: Integer; safecall;
    procedure Set_acDrCrGL(Value: Integer); safecall;
    function Get_acLastUsed: WideString; safecall;
    procedure Set_acLastUsed(const Value: WideString); safecall;
    function Get_acUserDef1: WideString; safecall;
    procedure Set_acUserDef1(const Value: WideString); safecall;
    function Get_acUserDef2: WideString; safecall;
    procedure Set_acUserDef2(const Value: WideString); safecall;
    function Get_acInvoiceTo: WideString; safecall;
    procedure Set_acInvoiceTo(const Value: WideString); safecall;
    function Get_acSOPAutoWOff: WordBool; safecall;
    procedure Set_acSOPAutoWOff(Value: WordBool); safecall;
    function Get_acFormSet: Smallint; safecall;
    procedure Set_acFormSet(Value: Smallint); safecall;
    function Get_acBookOrdVal: Double; safecall;
    procedure Set_acBookOrdVal(Value: Double); safecall;
    function Get_acDirDebMode: Smallint; safecall;
    procedure Set_acDirDebMode(Value: Smallint); safecall;
    function Get_acAltCode: WideString; safecall;
    procedure Set_acAltCode(const Value: WideString); safecall;
    function Get_acPostCode: WideString; safecall;
    procedure Set_acPostCode(const Value: WideString); safecall;
    function Get_acUserDef3: WideString; safecall;
    procedure Set_acUserDef3(const Value: WideString); safecall;
    function Get_acUserDef4: WideString; safecall;
    procedure Set_acUserDef4(const Value: WideString); safecall;
    function Get_acEmailAddr: WideString; safecall;
    procedure Set_acEmailAddr(const Value: WideString); safecall;
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
    function Get_acTradeTerms(Index: Integer): WideString; safecall;
    procedure Set_acTradeTerms(Index: Integer; const Value: WideString); safecall;
    function Get_acAddress(Index: Integer): WideString; safecall;
    procedure Set_acAddress(Index: Integer; const Value: WideString); safecall;
    function Get_acDelAddress(Index: Integer): WideString; safecall;
    procedure Set_acDelAddress(Index: Integer; const Value: WideString); safecall;
    property acCode: WideString read Get_acCode write Set_acCode;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property acCompany: WideString read Get_acCompany write Set_acCompany;
    property acArea: WideString read Get_acArea write Set_acArea;
    property acAccType: WideString read Get_acAccType write Set_acAccType;
    property acStatementTo: WideString read Get_acStatementTo write Set_acStatementTo;
    property acVATRegNo: WideString read Get_acVATRegNo write Set_acVATRegNo;
    property acDelAddr: WordBool read Get_acDelAddr write Set_acDelAddr;
    property acContact: WideString read Get_acContact write Set_acContact;
    property acPhone: WideString read Get_acPhone write Set_acPhone;
    property acFax: WideString read Get_acFax write Set_acFax;
    property acTheirAcc: WideString read Get_acTheirAcc write Set_acTheirAcc;
    property acOwnTradTerm: WordBool read Get_acOwnTradTerm write Set_acOwnTradTerm;
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
    property acPhone2: WideString read Get_acPhone2 write Set_acPhone2;
    property acCOSGL: Integer read Get_acCOSGL write Set_acCOSGL;
    property acDrCrGL: Integer read Get_acDrCrGL write Set_acDrCrGL;
    property acLastUsed: WideString read Get_acLastUsed write Set_acLastUsed;
    property acUserDef1: WideString read Get_acUserDef1 write Set_acUserDef1;
    property acUserDef2: WideString read Get_acUserDef2 write Set_acUserDef2;
    property acInvoiceTo: WideString read Get_acInvoiceTo write Set_acInvoiceTo;
    property acSOPAutoWOff: WordBool read Get_acSOPAutoWOff write Set_acSOPAutoWOff;
    property acFormSet: Smallint read Get_acFormSet write Set_acFormSet;
    property acBookOrdVal: Double read Get_acBookOrdVal write Set_acBookOrdVal;
    property acDirDebMode: Smallint read Get_acDirDebMode write Set_acDirDebMode;
    property acAltCode: WideString read Get_acAltCode write Set_acAltCode;
    property acPostCode: WideString read Get_acPostCode write Set_acPostCode;
    property acUserDef3: WideString read Get_acUserDef3 write Set_acUserDef3;
    property acUserDef4: WideString read Get_acUserDef4 write Set_acUserDef4;
    property acEmailAddr: WideString read Get_acEmailAddr write Set_acEmailAddr;
    property acCCStart: WideString read Get_acCCStart write Set_acCCStart;
    property acCCEnd: WideString read Get_acCCEnd write Set_acCCEnd;
    property acCCName: WideString read Get_acCCName write Set_acCCName;
    property acCCNumber: WideString read Get_acCCNumber write Set_acCCNumber;
    property acCCSwitch: WideString read Get_acCCSwitch write Set_acCCSwitch;
    property acTradeTerms[Index: Integer]: WideString read Get_acTradeTerms write Set_acTradeTerms;
    property acAddress[Index: Integer]: WideString read Get_acAddress write Set_acAddress;
    property acDelAddress[Index: Integer]: WideString read Get_acDelAddress write Set_acDelAddress;
  end;

// *********************************************************************//
// DispIntf:  ICOMCustomerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C7AFCAC3-A979-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMCustomerDisp = dispinterface
    ['{C7AFCAC3-A979-11D3-A990-0080C87D89BD}']
    property acCode: WideString dispid 1;
    property AccessRights: TRecordAccessStatus readonly dispid 2;
    property acCompany: WideString dispid 3;
    property acArea: WideString dispid 4;
    property acAccType: WideString dispid 5;
    property acStatementTo: WideString dispid 6;
    property acVATRegNo: WideString dispid 7;
    property acDelAddr: WordBool dispid 8;
    property acContact: WideString dispid 9;
    property acPhone: WideString dispid 10;
    property acFax: WideString dispid 11;
    property acTheirAcc: WideString dispid 12;
    property acOwnTradTerm: WordBool dispid 13;
    property acCurrency: Smallint dispid 14;
    property acVATCode: WideString dispid 15;
    property acPayTerms: Smallint dispid 16;
    property acCreditLimit: Double dispid 17;
    property acDiscount: Double dispid 18;
    property acCreditStatus: Smallint dispid 19;
    property acCostCentre: WideString dispid 20;
    property acDiscountBand: WideString dispid 21;
    property acDepartment: WideString dispid 22;
    property acECMember: WordBool dispid 23;
    property acStatement: WordBool dispid 24;
    property acSalesGL: Integer dispid 25;
    property acLocation: WideString dispid 26;
    property acAccStatus: TAccountStatus dispid 27;
    property acPayType: WideString dispid 28;
    property acBankSort: WideString dispid 29;
    property acBankAcc: WideString dispid 30;
    property acBankRef: WideString dispid 31;
    property acPhone2: WideString dispid 32;
    property acCOSGL: Integer dispid 33;
    property acDrCrGL: Integer dispid 34;
    property acLastUsed: WideString dispid 35;
    property acUserDef1: WideString dispid 36;
    property acUserDef2: WideString dispid 37;
    property acInvoiceTo: WideString dispid 38;
    property acSOPAutoWOff: WordBool dispid 39;
    property acFormSet: Smallint dispid 40;
    property acBookOrdVal: Double dispid 41;
    property acDirDebMode: Smallint dispid 42;
    property acAltCode: WideString dispid 43;
    property acPostCode: WideString dispid 44;
    property acUserDef3: WideString dispid 45;
    property acUserDef4: WideString dispid 46;
    property acEmailAddr: WideString dispid 47;
    property acCCStart: WideString dispid 48;
    property acCCEnd: WideString dispid 49;
    property acCCName: WideString dispid 50;
    property acCCNumber: WideString dispid 51;
    property acCCSwitch: WideString dispid 52;
    property acTradeTerms[Index: Integer]: WideString dispid 55;
    property acAddress[Index: Integer]: WideString dispid 56;
    property acDelAddress[Index: Integer]: WideString dispid 57;
  end;

// *********************************************************************//
// Interface: ICOMSetup
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2B43B140-C73F-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMSetup = interface(IDispatch)
    ['{2B43B140-C73F-11D3-A990-0080C87D89BD}']
    function Get_ssPrinYr: Smallint; safecall;
    function Get_ssUserName: WideString; safecall;
    function Get_ssAuditYr: Smallint; safecall;
    function Get_ssManROCP: WordBool; safecall;
    function Get_ssVATCurr: Smallint; safecall;
    function Get_ssNoCosDec: Smallint; safecall;
    function Get_ssCurrBase: Smallint; safecall;
    function Get_ssShowStkGP: WordBool; safecall;
    function Get_ssAutoValStk: WordBool; safecall;
    function Get_ssDelPickOnly: WordBool; safecall;
    function Get_ssUseMLoc: WordBool; safecall;
    function Get_ssEditSinSer: WordBool; safecall;
    function Get_ssWarnYRef: WordBool; safecall;
    function Get_ssUseLocDel: WordBool; safecall;
    function Get_ssPostCCGL: WordBool; safecall;
    function Get_ssAlTolVal: Double; safecall;
    function Get_ssAlTolMode: Smallint; safecall;
    function Get_ssDebtLMode: Smallint; safecall;
    function Get_ssAutoGenVar: WordBool; safecall;
    function Get_ssAutoGenDisc: WordBool; safecall;
    function Get_ssUSRCntryCode: WideString; safecall;
    function Get_ssNoNetDec: Smallint; safecall;
    function Get_ssNoInvLines: Smallint; safecall;
    function Get_ssWksODue: Smallint; safecall;
    function Get_ssCPr: Smallint; safecall;
    function Get_ssCYr: Smallint; safecall;
    function Get_ssTradeTerm: WordBool; safecall;
    function Get_ssStaSepCr: WordBool; safecall;
    function Get_ssStaAgeMthd: Smallint; safecall;
    function Get_ssStaUIDate: WordBool; safecall;
    function Get_ssQUAllocFlg: WordBool; safecall;
    function Get_ssDeadBOM: WordBool; safecall;
    function Get_ssAuthMode: WideString; safecall;
    function Get_ssIntraStat: WordBool; safecall;
    function Get_ssAnalStkDesc: WordBool; safecall;
    function Get_ssAutoStkVal: WideString; safecall;
    function Get_ssAutoBillUp: WordBool; safecall;
    function Get_ssAutoCQNo: WordBool; safecall;
    function Get_ssIncNotDue: WordBool; safecall;
    function Get_ssUseBatchTot: WordBool; safecall;
    function Get_ssUseStock: WordBool; safecall;
    function Get_ssAutoNotes: WordBool; safecall;
    function Get_ssHideMenuOpt: WordBool; safecall;
    function Get_ssUseCCDep: WordBool; safecall;
    function Get_ssNoHoldDisc: WordBool; safecall;
    function Get_ssAutoPrCalc: WordBool; safecall;
    function Get_ssStopBadDr: WordBool; safecall;
    function Get_ssUsePayIn: WordBool; safecall;
    function Get_ssUsePasswords: WordBool; safecall;
    function Get_ssPrintReciept: WordBool; safecall;
    function Get_ssExternCust: WordBool; safecall;
    function Get_ssNoQtyDec: Smallint; safecall;
    function Get_ssExternSIN: WordBool; safecall;
    function Get_ssPrevPrOff: WordBool; safecall;
    function Get_ssDefPcDisc: WordBool; safecall;
    function Get_ssTradCodeNum: WordBool; safecall;
    function Get_ssUpBalOnPost: WordBool; safecall;
    function Get_ssShowInvDisc: WordBool; safecall;
    function Get_ssSepDiscounts: WordBool; safecall;
    function Get_ssUseCreditChk: WordBool; safecall;
    function Get_ssUseCRLimitChk: WordBool; safecall;
    function Get_ssAutoClearPay: WordBool; safecall;
    function Get_ssTotalConv: WideString; safecall;
    function Get_ssDispPrAsMonths: WordBool; safecall;
    function Get_ssDirectCust: WideString; safecall;
    function Get_ssDirectSupp: WideString; safecall;
    function Get_ssGLPayFrom: Integer; safecall;
    function Get_ssGLPayToo: Integer; safecall;
    function Get_ssSettleDisc: Double; safecall;
    function Get_ssSettleDays: Smallint; safecall;
    function Get_ssNeedBMUp: WordBool; safecall;
    function Get_ssInpPack: WordBool; safecall;
    function Get_ssVATCode: WideString; safecall;
    function Get_ssPayTerms: Smallint; safecall;
    function Get_ssStaAgeInt: Smallint; safecall;
    function Get_ssQuoOwnDate: WordBool; safecall;
    function Get_ssFreeExAll: WordBool; safecall;
    function Get_ssDirOwnCount: WordBool; safecall;
    function Get_ssStaShowOS: WordBool; safecall;
    function Get_ssLiveCredS: WordBool; safecall;
    function Get_ssBatchPPY: WordBool; safecall;
    function Get_ssWarnJC: WordBool; safecall;
    function Get_ssDefBankGL: Integer; safecall;
    function Get_ssUseDefBank: WordBool; safecall;
    function Get_ssMonWk1: WideString; safecall;
    function Get_ssAuditDate: WideString; safecall;
    function Get_ssUserSort: WideString; safecall;
    function Get_ssUserAcc: WideString; safecall;
    function Get_ssUserRef: WideString; safecall;
    function Get_ssUserBank: WideString; safecall;
    function Get_ssLastExpFolio: Integer; safecall;
    function Get_ssDetailTel: WideString; safecall;
    function Get_ssDetailFax: WideString; safecall;
    function Get_ssUserVATReg: WideString; safecall;
    function Get_ssDataPath: WideString; safecall;
    function Get_ssDetailAddr(Index: Integer): WideString; safecall;
    function Get_ssGLCtrlCodes(Index: TNomCtrlType): Integer; safecall;
    function Get_ssDebtChaseDays(Index: Integer): Smallint; safecall;
    function Get_ssTermsofTrade(Index: TTermsIndex): WideString; safecall;
    function Get_ssCurrency(Index: TCurrencyType): ICOMSetupCurrency; safecall;
    function Get_ssVATRates(Index: TVATIndex): ICOMSetupVAT; safecall;
    function Get_ssUserFields: ICOMSetupUserFields; safecall;
    property ssPrinYr: Smallint read Get_ssPrinYr;
    property ssUserName: WideString read Get_ssUserName;
    property ssAuditYr: Smallint read Get_ssAuditYr;
    property ssManROCP: WordBool read Get_ssManROCP;
    property ssVATCurr: Smallint read Get_ssVATCurr;
    property ssNoCosDec: Smallint read Get_ssNoCosDec;
    property ssCurrBase: Smallint read Get_ssCurrBase;
    property ssShowStkGP: WordBool read Get_ssShowStkGP;
    property ssAutoValStk: WordBool read Get_ssAutoValStk;
    property ssDelPickOnly: WordBool read Get_ssDelPickOnly;
    property ssUseMLoc: WordBool read Get_ssUseMLoc;
    property ssEditSinSer: WordBool read Get_ssEditSinSer;
    property ssWarnYRef: WordBool read Get_ssWarnYRef;
    property ssUseLocDel: WordBool read Get_ssUseLocDel;
    property ssPostCCGL: WordBool read Get_ssPostCCGL;
    property ssAlTolVal: Double read Get_ssAlTolVal;
    property ssAlTolMode: Smallint read Get_ssAlTolMode;
    property ssDebtLMode: Smallint read Get_ssDebtLMode;
    property ssAutoGenVar: WordBool read Get_ssAutoGenVar;
    property ssAutoGenDisc: WordBool read Get_ssAutoGenDisc;
    property ssUSRCntryCode: WideString read Get_ssUSRCntryCode;
    property ssNoNetDec: Smallint read Get_ssNoNetDec;
    property ssNoInvLines: Smallint read Get_ssNoInvLines;
    property ssWksODue: Smallint read Get_ssWksODue;
    property ssCPr: Smallint read Get_ssCPr;
    property ssCYr: Smallint read Get_ssCYr;
    property ssTradeTerm: WordBool read Get_ssTradeTerm;
    property ssStaSepCr: WordBool read Get_ssStaSepCr;
    property ssStaAgeMthd: Smallint read Get_ssStaAgeMthd;
    property ssStaUIDate: WordBool read Get_ssStaUIDate;
    property ssQUAllocFlg: WordBool read Get_ssQUAllocFlg;
    property ssDeadBOM: WordBool read Get_ssDeadBOM;
    property ssAuthMode: WideString read Get_ssAuthMode;
    property ssIntraStat: WordBool read Get_ssIntraStat;
    property ssAnalStkDesc: WordBool read Get_ssAnalStkDesc;
    property ssAutoStkVal: WideString read Get_ssAutoStkVal;
    property ssAutoBillUp: WordBool read Get_ssAutoBillUp;
    property ssAutoCQNo: WordBool read Get_ssAutoCQNo;
    property ssIncNotDue: WordBool read Get_ssIncNotDue;
    property ssUseBatchTot: WordBool read Get_ssUseBatchTot;
    property ssUseStock: WordBool read Get_ssUseStock;
    property ssAutoNotes: WordBool read Get_ssAutoNotes;
    property ssHideMenuOpt: WordBool read Get_ssHideMenuOpt;
    property ssUseCCDep: WordBool read Get_ssUseCCDep;
    property ssNoHoldDisc: WordBool read Get_ssNoHoldDisc;
    property ssAutoPrCalc: WordBool read Get_ssAutoPrCalc;
    property ssStopBadDr: WordBool read Get_ssStopBadDr;
    property ssUsePayIn: WordBool read Get_ssUsePayIn;
    property ssUsePasswords: WordBool read Get_ssUsePasswords;
    property ssPrintReciept: WordBool read Get_ssPrintReciept;
    property ssExternCust: WordBool read Get_ssExternCust;
    property ssNoQtyDec: Smallint read Get_ssNoQtyDec;
    property ssExternSIN: WordBool read Get_ssExternSIN;
    property ssPrevPrOff: WordBool read Get_ssPrevPrOff;
    property ssDefPcDisc: WordBool read Get_ssDefPcDisc;
    property ssTradCodeNum: WordBool read Get_ssTradCodeNum;
    property ssUpBalOnPost: WordBool read Get_ssUpBalOnPost;
    property ssShowInvDisc: WordBool read Get_ssShowInvDisc;
    property ssSepDiscounts: WordBool read Get_ssSepDiscounts;
    property ssUseCreditChk: WordBool read Get_ssUseCreditChk;
    property ssUseCRLimitChk: WordBool read Get_ssUseCRLimitChk;
    property ssAutoClearPay: WordBool read Get_ssAutoClearPay;
    property ssTotalConv: WideString read Get_ssTotalConv;
    property ssDispPrAsMonths: WordBool read Get_ssDispPrAsMonths;
    property ssDirectCust: WideString read Get_ssDirectCust;
    property ssDirectSupp: WideString read Get_ssDirectSupp;
    property ssGLPayFrom: Integer read Get_ssGLPayFrom;
    property ssGLPayToo: Integer read Get_ssGLPayToo;
    property ssSettleDisc: Double read Get_ssSettleDisc;
    property ssSettleDays: Smallint read Get_ssSettleDays;
    property ssNeedBMUp: WordBool read Get_ssNeedBMUp;
    property ssInpPack: WordBool read Get_ssInpPack;
    property ssVATCode: WideString read Get_ssVATCode;
    property ssPayTerms: Smallint read Get_ssPayTerms;
    property ssStaAgeInt: Smallint read Get_ssStaAgeInt;
    property ssQuoOwnDate: WordBool read Get_ssQuoOwnDate;
    property ssFreeExAll: WordBool read Get_ssFreeExAll;
    property ssDirOwnCount: WordBool read Get_ssDirOwnCount;
    property ssStaShowOS: WordBool read Get_ssStaShowOS;
    property ssLiveCredS: WordBool read Get_ssLiveCredS;
    property ssBatchPPY: WordBool read Get_ssBatchPPY;
    property ssWarnJC: WordBool read Get_ssWarnJC;
    property ssDefBankGL: Integer read Get_ssDefBankGL;
    property ssUseDefBank: WordBool read Get_ssUseDefBank;
    property ssMonWk1: WideString read Get_ssMonWk1;
    property ssAuditDate: WideString read Get_ssAuditDate;
    property ssUserSort: WideString read Get_ssUserSort;
    property ssUserAcc: WideString read Get_ssUserAcc;
    property ssUserRef: WideString read Get_ssUserRef;
    property ssUserBank: WideString read Get_ssUserBank;
    property ssLastExpFolio: Integer read Get_ssLastExpFolio;
    property ssDetailTel: WideString read Get_ssDetailTel;
    property ssDetailFax: WideString read Get_ssDetailFax;
    property ssUserVATReg: WideString read Get_ssUserVATReg;
    property ssDataPath: WideString read Get_ssDataPath;
    property ssDetailAddr[Index: Integer]: WideString read Get_ssDetailAddr;
    property ssGLCtrlCodes[Index: TNomCtrlType]: Integer read Get_ssGLCtrlCodes;
    property ssDebtChaseDays[Index: Integer]: Smallint read Get_ssDebtChaseDays;
    property ssTermsofTrade[Index: TTermsIndex]: WideString read Get_ssTermsofTrade;
    property ssCurrency[Index: TCurrencyType]: ICOMSetupCurrency read Get_ssCurrency;
    property ssVATRates[Index: TVATIndex]: ICOMSetupVAT read Get_ssVATRates;
    property ssUserFields: ICOMSetupUserFields read Get_ssUserFields;
  end;

// *********************************************************************//
// DispIntf:  ICOMSetupDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2B43B140-C73F-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMSetupDisp = dispinterface
    ['{2B43B140-C73F-11D3-A990-0080C87D89BD}']
    property ssPrinYr: Smallint readonly dispid 1;
    property ssUserName: WideString readonly dispid 2;
    property ssAuditYr: Smallint readonly dispid 3;
    property ssManROCP: WordBool readonly dispid 4;
    property ssVATCurr: Smallint readonly dispid 5;
    property ssNoCosDec: Smallint readonly dispid 6;
    property ssCurrBase: Smallint readonly dispid 7;
    property ssShowStkGP: WordBool readonly dispid 8;
    property ssAutoValStk: WordBool readonly dispid 9;
    property ssDelPickOnly: WordBool readonly dispid 10;
    property ssUseMLoc: WordBool readonly dispid 11;
    property ssEditSinSer: WordBool readonly dispid 12;
    property ssWarnYRef: WordBool readonly dispid 13;
    property ssUseLocDel: WordBool readonly dispid 14;
    property ssPostCCGL: WordBool readonly dispid 15;
    property ssAlTolVal: Double readonly dispid 16;
    property ssAlTolMode: Smallint readonly dispid 17;
    property ssDebtLMode: Smallint readonly dispid 18;
    property ssAutoGenVar: WordBool readonly dispid 19;
    property ssAutoGenDisc: WordBool readonly dispid 20;
    property ssUSRCntryCode: WideString readonly dispid 21;
    property ssNoNetDec: Smallint readonly dispid 22;
    property ssNoInvLines: Smallint readonly dispid 23;
    property ssWksODue: Smallint readonly dispid 24;
    property ssCPr: Smallint readonly dispid 25;
    property ssCYr: Smallint readonly dispid 26;
    property ssTradeTerm: WordBool readonly dispid 27;
    property ssStaSepCr: WordBool readonly dispid 28;
    property ssStaAgeMthd: Smallint readonly dispid 29;
    property ssStaUIDate: WordBool readonly dispid 30;
    property ssQUAllocFlg: WordBool readonly dispid 31;
    property ssDeadBOM: WordBool readonly dispid 32;
    property ssAuthMode: WideString readonly dispid 33;
    property ssIntraStat: WordBool readonly dispid 34;
    property ssAnalStkDesc: WordBool readonly dispid 35;
    property ssAutoStkVal: WideString readonly dispid 36;
    property ssAutoBillUp: WordBool readonly dispid 37;
    property ssAutoCQNo: WordBool readonly dispid 38;
    property ssIncNotDue: WordBool readonly dispid 39;
    property ssUseBatchTot: WordBool readonly dispid 40;
    property ssUseStock: WordBool readonly dispid 41;
    property ssAutoNotes: WordBool readonly dispid 42;
    property ssHideMenuOpt: WordBool readonly dispid 43;
    property ssUseCCDep: WordBool readonly dispid 44;
    property ssNoHoldDisc: WordBool readonly dispid 45;
    property ssAutoPrCalc: WordBool readonly dispid 46;
    property ssStopBadDr: WordBool readonly dispid 47;
    property ssUsePayIn: WordBool readonly dispid 48;
    property ssUsePasswords: WordBool readonly dispid 49;
    property ssPrintReciept: WordBool readonly dispid 50;
    property ssExternCust: WordBool readonly dispid 51;
    property ssNoQtyDec: Smallint readonly dispid 52;
    property ssExternSIN: WordBool readonly dispid 53;
    property ssPrevPrOff: WordBool readonly dispid 54;
    property ssDefPcDisc: WordBool readonly dispid 55;
    property ssTradCodeNum: WordBool readonly dispid 56;
    property ssUpBalOnPost: WordBool readonly dispid 57;
    property ssShowInvDisc: WordBool readonly dispid 58;
    property ssSepDiscounts: WordBool readonly dispid 59;
    property ssUseCreditChk: WordBool readonly dispid 60;
    property ssUseCRLimitChk: WordBool readonly dispid 61;
    property ssAutoClearPay: WordBool readonly dispid 62;
    property ssTotalConv: WideString readonly dispid 63;
    property ssDispPrAsMonths: WordBool readonly dispid 64;
    property ssDirectCust: WideString readonly dispid 65;
    property ssDirectSupp: WideString readonly dispid 66;
    property ssGLPayFrom: Integer readonly dispid 67;
    property ssGLPayToo: Integer readonly dispid 68;
    property ssSettleDisc: Double readonly dispid 69;
    property ssSettleDays: Smallint readonly dispid 70;
    property ssNeedBMUp: WordBool readonly dispid 71;
    property ssInpPack: WordBool readonly dispid 72;
    property ssVATCode: WideString readonly dispid 73;
    property ssPayTerms: Smallint readonly dispid 74;
    property ssStaAgeInt: Smallint readonly dispid 75;
    property ssQuoOwnDate: WordBool readonly dispid 76;
    property ssFreeExAll: WordBool readonly dispid 77;
    property ssDirOwnCount: WordBool readonly dispid 78;
    property ssStaShowOS: WordBool readonly dispid 79;
    property ssLiveCredS: WordBool readonly dispid 80;
    property ssBatchPPY: WordBool readonly dispid 81;
    property ssWarnJC: WordBool readonly dispid 82;
    property ssDefBankGL: Integer readonly dispid 83;
    property ssUseDefBank: WordBool readonly dispid 84;
    property ssMonWk1: WideString readonly dispid 85;
    property ssAuditDate: WideString readonly dispid 86;
    property ssUserSort: WideString readonly dispid 87;
    property ssUserAcc: WideString readonly dispid 88;
    property ssUserRef: WideString readonly dispid 89;
    property ssUserBank: WideString readonly dispid 90;
    property ssLastExpFolio: Integer readonly dispid 91;
    property ssDetailTel: WideString readonly dispid 92;
    property ssDetailFax: WideString readonly dispid 93;
    property ssUserVATReg: WideString readonly dispid 94;
    property ssDataPath: WideString readonly dispid 95;
    property ssDetailAddr[Index: Integer]: WideString readonly dispid 96;
    property ssGLCtrlCodes[Index: TNomCtrlType]: Integer readonly dispid 97;
    property ssDebtChaseDays[Index: Integer]: Smallint readonly dispid 98;
    property ssTermsofTrade[Index: TTermsIndex]: WideString readonly dispid 99;
    property ssCurrency[Index: TCurrencyType]: ICOMSetupCurrency readonly dispid 100;
    property ssVATRates[Index: TVATIndex]: ICOMSetupVAT readonly dispid 101;
    property ssUserFields: ICOMSetupUserFields readonly dispid 102;
  end;

// *********************************************************************//
// Interface: ICOMSetupCurrency
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B62D3641-C74A-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMSetupCurrency = interface(IDispatch)
    ['{B62D3641-C74A-11D3-A990-0080C87D89BD}']
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
// DispIntf:  ICOMSetupCurrencyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B62D3641-C74A-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMSetupCurrencyDisp = dispinterface
    ['{B62D3641-C74A-11D3-A990-0080C87D89BD}']
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
// Interface: ICOMSetupVAT
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B62D364D-C74A-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMSetupVAT = interface(IDispatch)
    ['{B62D364D-C74A-11D3-A990-0080C87D89BD}']
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
// DispIntf:  ICOMSetupVATDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B62D364D-C74A-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMSetupVATDisp = dispinterface
    ['{B62D364D-C74A-11D3-A990-0080C87D89BD}']
    property svCode: WideString readonly dispid 1;
    property svDesc: WideString readonly dispid 2;
    property svRate: Double readonly dispid 3;
    property svInclude: WordBool readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ICOMSetupUserFields
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B62D3667-C74A-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMSetupUserFields = interface(IDispatch)
    ['{B62D3667-C74A-11D3-A990-0080C87D89BD}']
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
  end;

// *********************************************************************//
// DispIntf:  ICOMSetupUserFieldsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B62D3667-C74A-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMSetupUserFieldsDisp = dispinterface
    ['{B62D3667-C74A-11D3-A990-0080C87D89BD}']
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
  end;

// *********************************************************************//
// Interface: ICOMCCDept
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BF64DA40-C846-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMCCDept = interface(IDispatch)
    ['{BF64DA40-C846-11D3-A990-0080C87D89BD}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_DataChanged: WordBool; safecall;
    function Get_cdCode: WideString; safecall;
    procedure Set_cdCode(const Value: WideString); safecall;
    function Get_cdDescription: WideString; safecall;
    procedure Set_cdDescription(const Value: WideString); safecall;
    function Get_cdTag: WordBool; safecall;
    procedure Set_cdTag(Value: WordBool); safecall;
    function Get_cdLastAccessDate: WideString; safecall;
    procedure Set_cdLastAccessDate(const Value: WideString); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property DataChanged: WordBool read Get_DataChanged;
    property cdCode: WideString read Get_cdCode write Set_cdCode;
    property cdDescription: WideString read Get_cdDescription write Set_cdDescription;
    property cdTag: WordBool read Get_cdTag write Set_cdTag;
    property cdLastAccessDate: WideString read Get_cdLastAccessDate write Set_cdLastAccessDate;
  end;

// *********************************************************************//
// DispIntf:  ICOMCCDeptDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BF64DA40-C846-11D3-A990-0080C87D89BD}
// *********************************************************************//
  ICOMCCDeptDisp = dispinterface
    ['{BF64DA40-C846-11D3-A990-0080C87D89BD}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property cdCode: WideString dispid 3;
    property cdDescription: WideString dispid 4;
    property cdTag: WordBool dispid 5;
    property cdLastAccessDate: WideString dispid 6;
  end;

// *********************************************************************//
// Interface: ICOMGLCode
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3F711180-C8CA-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMGLCode = interface(IDispatch)
    ['{3F711180-C8CA-11D3-A990-0050DA3DF9AD}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_DataChanged: WordBool; safecall;
    function Get_GLCode: Integer; safecall;
    procedure Set_GLCode(Value: Integer); safecall;
    function Get_glName: WideString; safecall;
    procedure Set_glName(const Value: WideString); safecall;
    function Get_glParent: Integer; safecall;
    procedure Set_glParent(Value: Integer); safecall;
    function Get_glType: WideString; safecall;
    procedure Set_glType(const Value: WideString); safecall;
    function Get_glAltCode: WideString; safecall;
    procedure Set_glAltCode(const Value: WideString); safecall;
    function Get_glDefCurr: TCurrencyType; safecall;
    procedure Set_glDefCurr(Value: TCurrencyType); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property DataChanged: WordBool read Get_DataChanged;
    property GLCode: Integer read Get_GLCode write Set_GLCode;
    property glName: WideString read Get_glName write Set_glName;
    property glParent: Integer read Get_glParent write Set_glParent;
    property glType: WideString read Get_glType write Set_glType;
    property glAltCode: WideString read Get_glAltCode write Set_glAltCode;
    property glDefCurr: TCurrencyType read Get_glDefCurr write Set_glDefCurr;
  end;

// *********************************************************************//
// DispIntf:  ICOMGLCodeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3F711180-C8CA-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMGLCodeDisp = dispinterface
    ['{3F711180-C8CA-11D3-A990-0050DA3DF9AD}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property GLCode: Integer dispid 3;
    property glName: WideString dispid 4;
    property glParent: Integer dispid 5;
    property glType: WideString dispid 6;
    property glAltCode: WideString dispid 7;
    property glDefCurr: TCurrencyType dispid 8;
  end;

// *********************************************************************//
// Interface: ICOMStock
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3F711189-C8CA-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMStock = interface(IDispatch)
    ['{3F711189-C8CA-11D3-A990-0050DA3DF9AD}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_DataChanged: WordBool; safecall;
    function Get_stCode: WideString; safecall;
    procedure Set_stCode(const Value: WideString); safecall;
    function Get_stDesc(Index: Integer): WideString; safecall;
    procedure Set_stDesc(Index: Integer; const Value: WideString); safecall;
    function Get_stAltCode: WideString; safecall;
    procedure Set_stAltCode(const Value: WideString); safecall;
    function Get_stSuppTemp: WideString; safecall;
    procedure Set_stSuppTemp(const Value: WideString); safecall;
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
    function Get_stReOrderFlag: WordBool; safecall;
    procedure Set_stReOrderFlag(Value: WordBool); safecall;
    function Get_stMinFlg: WordBool; safecall;
    procedure Set_stMinFlg(Value: WordBool); safecall;
    function Get_stStockFolio: Integer; safecall;
    procedure Set_stStockFolio(Value: Integer); safecall;
    function Get_stStockCat: WideString; safecall;
    procedure Set_stStockCat(const Value: WideString); safecall;
    function Get_stStockType: WideString; safecall;
    procedure Set_stStockType(const Value: WideString); safecall;
    function Get_stUnitOfStock: WideString; safecall;
    procedure Set_stUnitOfStock(const Value: WideString); safecall;
    function Get_stUnitOfSale: WideString; safecall;
    procedure Set_stUnitOfSale(const Value: WideString); safecall;
    function Get_stUnitOfPurch: WideString; safecall;
    procedure Set_stUnitOfPurch(const Value: WideString); safecall;
    function Get_stCostPriceCur: TCurrencyType; safecall;
    procedure Set_stCostPriceCur(Value: TCurrencyType); safecall;
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
    procedure Set_stQtyInStock(Value: Double); safecall;
    function Get_stQtyPosted: Double; safecall;
    procedure Set_stQtyPosted(Value: Double); safecall;
    function Get_stQtyAllocated: Double; safecall;
    procedure Set_stQtyAllocated(Value: Double); safecall;
    function Get_stQtyOnOrder: Double; safecall;
    procedure Set_stQtyOnOrder(Value: Double); safecall;
    function Get_stQtyMin: Double; safecall;
    procedure Set_stQtyMin(Value: Double); safecall;
    function Get_stQtyMax: Double; safecall;
    procedure Set_stQtyMax(Value: Double); safecall;
    function Get_stReOrderQty: Double; safecall;
    procedure Set_stReOrderQty(Value: Double); safecall;
    function Get_stKitOnPurch: WordBool; safecall;
    procedure Set_stKitOnPurch(Value: WordBool); safecall;
    function Get_stShowAsKit: WordBool; safecall;
    procedure Set_stShowAsKit(Value: WordBool); safecall;
    function Get_stCommodCode: WideString; safecall;
    procedure Set_stCommodCode(const Value: WideString); safecall;
    function Get_stSaleUnWeight: Double; safecall;
    procedure Set_stSaleUnWeight(Value: Double); safecall;
    function Get_stPurchUnWeight: Double; safecall;
    procedure Set_stPurchUnWeight(Value: Double); safecall;
    function Get_stSSDUnit: WideString; safecall;
    procedure Set_stSSDUnit(const Value: WideString); safecall;
    function Get_stSSDSalesUnit: Double; safecall;
    procedure Set_stSSDSalesUnit(Value: Double); safecall;
    function Get_stBinLocation: WideString; safecall;
    procedure Set_stBinLocation(const Value: WideString); safecall;
    function Get_stStkFlg: WordBool; safecall;
    procedure Set_stStkFlg(Value: WordBool); safecall;
    function Get_stCovPr: Smallint; safecall;
    procedure Set_stCovPr(Value: Smallint); safecall;
    function Get_stCovPrUnit: WideString; safecall;
    procedure Set_stCovPrUnit(const Value: WideString); safecall;
    function Get_stCovMinPr: Smallint; safecall;
    procedure Set_stCovMinPr(Value: Smallint); safecall;
    function Get_stCovMinUnit: WideString; safecall;
    procedure Set_stCovMinUnit(const Value: WideString); safecall;
    function Get_stSupplier: WideString; safecall;
    procedure Set_stSupplier(const Value: WideString); safecall;
    function Get_stQtyFreeze: Double; safecall;
    procedure Set_stQtyFreeze(Value: Double); safecall;
    function Get_stCovSold: Double; safecall;
    procedure Set_stCovSold(Value: Double); safecall;
    function Get_stUseCover: WordBool; safecall;
    procedure Set_stUseCover(Value: WordBool); safecall;
    function Get_stCovMaxPr: Smallint; safecall;
    procedure Set_stCovMaxPr(Value: Smallint); safecall;
    function Get_stCovMaxUnit: WideString; safecall;
    procedure Set_stCovMaxUnit(const Value: WideString); safecall;
    function Get_stReOrderCur: Smallint; safecall;
    procedure Set_stReOrderCur(Value: Smallint); safecall;
    function Get_stReOrderPrice: Double; safecall;
    procedure Set_stReOrderPrice(Value: Double); safecall;
    function Get_stReOrderDate: WideString; safecall;
    procedure Set_stReOrderDate(const Value: WideString); safecall;
    function Get_stQtyTake: Double; safecall;
    procedure Set_stQtyTake(Value: Double); safecall;
    function Get_stStkValType: WideString; safecall;
    procedure Set_stStkValType(const Value: WideString); safecall;
    function Get_stQtyPicked: Double; safecall;
    procedure Set_stQtyPicked(Value: Double); safecall;
    function Get_stLastUsed: WideString; safecall;
    procedure Set_stLastUsed(const Value: WideString); safecall;
    function Get_stCalcPack: WordBool; safecall;
    procedure Set_stCalcPack(Value: WordBool); safecall;
    function Get_stJobAnal: WideString; safecall;
    procedure Set_stJobAnal(const Value: WideString); safecall;
    function Get_stStkUser1: WideString; safecall;
    procedure Set_stStkUser1(const Value: WideString); safecall;
    function Get_stStkUser2: WideString; safecall;
    procedure Set_stStkUser2(const Value: WideString); safecall;
    function Get_stBarCode: WideString; safecall;
    procedure Set_stBarCode(const Value: WideString); safecall;
    function Get_stROCostCentre: WideString; safecall;
    procedure Set_stROCostCentre(const Value: WideString); safecall;
    function Get_stRODepartment: WideString; safecall;
    procedure Set_stRODepartment(const Value: WideString); safecall;
    function Get_stLocation: WideString; safecall;
    procedure Set_stLocation(const Value: WideString); safecall;
    function Get_stPricePack: WordBool; safecall;
    procedure Set_stPricePack(Value: WordBool); safecall;
    function Get_stDPackQty: WordBool; safecall;
    procedure Set_stDPackQty(Value: WordBool); safecall;
    function Get_stKitPrice: WordBool; safecall;
    procedure Set_stKitPrice(Value: WordBool); safecall;
    function Get_stStkUser3: WideString; safecall;
    procedure Set_stStkUser3(const Value: WideString); safecall;
    function Get_stStkUser4: WideString; safecall;
    procedure Set_stStkUser4(const Value: WideString); safecall;
    function Get_stSerNoWAvg: Smallint; safecall;
    procedure Set_stSerNoWAvg(Value: Smallint); safecall;
    function Get_stStkSizeCol: Smallint; safecall;
    function Get_stSSDDUplift: Double; safecall;
    procedure Set_stSSDDUplift(Value: Double); safecall;
    function Get_stSSDCountry: WideString; safecall;
    procedure Set_stSSDCountry(const Value: WideString); safecall;
    function Get_stTimeChange: WideString; safecall;
    function Get_stSVATIncFlg: WideString; safecall;
    procedure Set_stSVATIncFlg(const Value: WideString); safecall;
    function Get_stSSDAUpLift: Double; safecall;
    procedure Set_stSSDAUpLift(Value: Double); safecall;
    function Get_stLastOpo: WideString; safecall;
    procedure Set_stLastOpo(const Value: WideString); safecall;
    function Get_stImageFile: WideString; safecall;
    procedure Set_stImageFile(const Value: WideString); safecall;
    function Get_stSaleBandsCur(const Index: WideString): TCurrencyType; safecall;
    procedure Set_stSaleBandsCur(const Index: WideString; Value: TCurrencyType); safecall;
    function Get_stSaleBandsPrice(const Index: WideString): Double; safecall;
    procedure Set_stSaleBandsPrice(const Index: WideString; Value: Double); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property DataChanged: WordBool read Get_DataChanged;
    property stCode: WideString read Get_stCode write Set_stCode;
    property stDesc[Index: Integer]: WideString read Get_stDesc write Set_stDesc;
    property stAltCode: WideString read Get_stAltCode write Set_stAltCode;
    property stSuppTemp: WideString read Get_stSuppTemp write Set_stSuppTemp;
    property stSalesGL: Integer read Get_stSalesGL write Set_stSalesGL;
    property stCOSGL: Integer read Get_stCOSGL write Set_stCOSGL;
    property stPandLGL: Integer read Get_stPandLGL write Set_stPandLGL;
    property stBalSheetGL: Integer read Get_stBalSheetGL write Set_stBalSheetGL;
    property stWIPGL: Integer read Get_stWIPGL write Set_stWIPGL;
    property stReOrderFlag: WordBool read Get_stReOrderFlag write Set_stReOrderFlag;
    property stMinFlg: WordBool read Get_stMinFlg write Set_stMinFlg;
    property stStockFolio: Integer read Get_stStockFolio write Set_stStockFolio;
    property stStockCat: WideString read Get_stStockCat write Set_stStockCat;
    property stStockType: WideString read Get_stStockType write Set_stStockType;
    property stUnitOfStock: WideString read Get_stUnitOfStock write Set_stUnitOfStock;
    property stUnitOfSale: WideString read Get_stUnitOfSale write Set_stUnitOfSale;
    property stUnitOfPurch: WideString read Get_stUnitOfPurch write Set_stUnitOfPurch;
    property stCostPriceCur: TCurrencyType read Get_stCostPriceCur write Set_stCostPriceCur;
    property stCostPrice: Double read Get_stCostPrice write Set_stCostPrice;
    property stSalesUnits: Double read Get_stSalesUnits write Set_stSalesUnits;
    property stPurchUnits: Double read Get_stPurchUnits write Set_stPurchUnits;
    property stVATCode: WideString read Get_stVATCode write Set_stVATCode;
    property stCostCentre: WideString read Get_stCostCentre write Set_stCostCentre;
    property stDepartment: WideString read Get_stDepartment write Set_stDepartment;
    property stQtyInStock: Double read Get_stQtyInStock write Set_stQtyInStock;
    property stQtyPosted: Double read Get_stQtyPosted write Set_stQtyPosted;
    property stQtyAllocated: Double read Get_stQtyAllocated write Set_stQtyAllocated;
    property stQtyOnOrder: Double read Get_stQtyOnOrder write Set_stQtyOnOrder;
    property stQtyMin: Double read Get_stQtyMin write Set_stQtyMin;
    property stQtyMax: Double read Get_stQtyMax write Set_stQtyMax;
    property stReOrderQty: Double read Get_stReOrderQty write Set_stReOrderQty;
    property stKitOnPurch: WordBool read Get_stKitOnPurch write Set_stKitOnPurch;
    property stShowAsKit: WordBool read Get_stShowAsKit write Set_stShowAsKit;
    property stCommodCode: WideString read Get_stCommodCode write Set_stCommodCode;
    property stSaleUnWeight: Double read Get_stSaleUnWeight write Set_stSaleUnWeight;
    property stPurchUnWeight: Double read Get_stPurchUnWeight write Set_stPurchUnWeight;
    property stSSDUnit: WideString read Get_stSSDUnit write Set_stSSDUnit;
    property stSSDSalesUnit: Double read Get_stSSDSalesUnit write Set_stSSDSalesUnit;
    property stBinLocation: WideString read Get_stBinLocation write Set_stBinLocation;
    property stStkFlg: WordBool read Get_stStkFlg write Set_stStkFlg;
    property stCovPr: Smallint read Get_stCovPr write Set_stCovPr;
    property stCovPrUnit: WideString read Get_stCovPrUnit write Set_stCovPrUnit;
    property stCovMinPr: Smallint read Get_stCovMinPr write Set_stCovMinPr;
    property stCovMinUnit: WideString read Get_stCovMinUnit write Set_stCovMinUnit;
    property stSupplier: WideString read Get_stSupplier write Set_stSupplier;
    property stQtyFreeze: Double read Get_stQtyFreeze write Set_stQtyFreeze;
    property stCovSold: Double read Get_stCovSold write Set_stCovSold;
    property stUseCover: WordBool read Get_stUseCover write Set_stUseCover;
    property stCovMaxPr: Smallint read Get_stCovMaxPr write Set_stCovMaxPr;
    property stCovMaxUnit: WideString read Get_stCovMaxUnit write Set_stCovMaxUnit;
    property stReOrderCur: Smallint read Get_stReOrderCur write Set_stReOrderCur;
    property stReOrderPrice: Double read Get_stReOrderPrice write Set_stReOrderPrice;
    property stReOrderDate: WideString read Get_stReOrderDate write Set_stReOrderDate;
    property stQtyTake: Double read Get_stQtyTake write Set_stQtyTake;
    property stStkValType: WideString read Get_stStkValType write Set_stStkValType;
    property stQtyPicked: Double read Get_stQtyPicked write Set_stQtyPicked;
    property stLastUsed: WideString read Get_stLastUsed write Set_stLastUsed;
    property stCalcPack: WordBool read Get_stCalcPack write Set_stCalcPack;
    property stJobAnal: WideString read Get_stJobAnal write Set_stJobAnal;
    property stStkUser1: WideString read Get_stStkUser1 write Set_stStkUser1;
    property stStkUser2: WideString read Get_stStkUser2 write Set_stStkUser2;
    property stBarCode: WideString read Get_stBarCode write Set_stBarCode;
    property stROCostCentre: WideString read Get_stROCostCentre write Set_stROCostCentre;
    property stRODepartment: WideString read Get_stRODepartment write Set_stRODepartment;
    property stLocation: WideString read Get_stLocation write Set_stLocation;
    property stPricePack: WordBool read Get_stPricePack write Set_stPricePack;
    property stDPackQty: WordBool read Get_stDPackQty write Set_stDPackQty;
    property stKitPrice: WordBool read Get_stKitPrice write Set_stKitPrice;
    property stStkUser3: WideString read Get_stStkUser3 write Set_stStkUser3;
    property stStkUser4: WideString read Get_stStkUser4 write Set_stStkUser4;
    property stSerNoWAvg: Smallint read Get_stSerNoWAvg write Set_stSerNoWAvg;
    property stStkSizeCol: Smallint read Get_stStkSizeCol;
    property stSSDDUplift: Double read Get_stSSDDUplift write Set_stSSDDUplift;
    property stSSDCountry: WideString read Get_stSSDCountry write Set_stSSDCountry;
    property stTimeChange: WideString read Get_stTimeChange;
    property stSVATIncFlg: WideString read Get_stSVATIncFlg write Set_stSVATIncFlg;
    property stSSDAUpLift: Double read Get_stSSDAUpLift write Set_stSSDAUpLift;
    property stLastOpo: WideString read Get_stLastOpo write Set_stLastOpo;
    property stImageFile: WideString read Get_stImageFile write Set_stImageFile;
    property stSaleBandsCur[const Index: WideString]: TCurrencyType read Get_stSaleBandsCur write Set_stSaleBandsCur;
    property stSaleBandsPrice[const Index: WideString]: Double read Get_stSaleBandsPrice write Set_stSaleBandsPrice;
  end;

// *********************************************************************//
// DispIntf:  ICOMStockDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3F711189-C8CA-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMStockDisp = dispinterface
    ['{3F711189-C8CA-11D3-A990-0050DA3DF9AD}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property stCode: WideString dispid 3;
    property stDesc[Index: Integer]: WideString dispid 81;
    property stAltCode: WideString dispid 4;
    property stSuppTemp: WideString dispid 5;
    property stSalesGL: Integer dispid 6;
    property stCOSGL: Integer dispid 7;
    property stPandLGL: Integer dispid 8;
    property stBalSheetGL: Integer dispid 9;
    property stWIPGL: Integer dispid 10;
    property stReOrderFlag: WordBool dispid 11;
    property stMinFlg: WordBool dispid 12;
    property stStockFolio: Integer dispid 13;
    property stStockCat: WideString dispid 14;
    property stStockType: WideString dispid 15;
    property stUnitOfStock: WideString dispid 16;
    property stUnitOfSale: WideString dispid 17;
    property stUnitOfPurch: WideString dispid 18;
    property stCostPriceCur: TCurrencyType dispid 19;
    property stCostPrice: Double dispid 20;
    property stSalesUnits: Double dispid 21;
    property stPurchUnits: Double dispid 22;
    property stVATCode: WideString dispid 23;
    property stCostCentre: WideString dispid 24;
    property stDepartment: WideString dispid 25;
    property stQtyInStock: Double dispid 26;
    property stQtyPosted: Double dispid 27;
    property stQtyAllocated: Double dispid 28;
    property stQtyOnOrder: Double dispid 29;
    property stQtyMin: Double dispid 30;
    property stQtyMax: Double dispid 31;
    property stReOrderQty: Double dispid 32;
    property stKitOnPurch: WordBool dispid 33;
    property stShowAsKit: WordBool dispid 34;
    property stCommodCode: WideString dispid 35;
    property stSaleUnWeight: Double dispid 36;
    property stPurchUnWeight: Double dispid 37;
    property stSSDUnit: WideString dispid 38;
    property stSSDSalesUnit: Double dispid 39;
    property stBinLocation: WideString dispid 40;
    property stStkFlg: WordBool dispid 41;
    property stCovPr: Smallint dispid 42;
    property stCovPrUnit: WideString dispid 43;
    property stCovMinPr: Smallint dispid 44;
    property stCovMinUnit: WideString dispid 45;
    property stSupplier: WideString dispid 46;
    property stQtyFreeze: Double dispid 47;
    property stCovSold: Double dispid 48;
    property stUseCover: WordBool dispid 49;
    property stCovMaxPr: Smallint dispid 50;
    property stCovMaxUnit: WideString dispid 51;
    property stReOrderCur: Smallint dispid 52;
    property stReOrderPrice: Double dispid 53;
    property stReOrderDate: WideString dispid 54;
    property stQtyTake: Double dispid 55;
    property stStkValType: WideString dispid 56;
    property stQtyPicked: Double dispid 57;
    property stLastUsed: WideString dispid 58;
    property stCalcPack: WordBool dispid 59;
    property stJobAnal: WideString dispid 60;
    property stStkUser1: WideString dispid 61;
    property stStkUser2: WideString dispid 62;
    property stBarCode: WideString dispid 63;
    property stROCostCentre: WideString dispid 64;
    property stRODepartment: WideString dispid 65;
    property stLocation: WideString dispid 66;
    property stPricePack: WordBool dispid 67;
    property stDPackQty: WordBool dispid 68;
    property stKitPrice: WordBool dispid 69;
    property stStkUser3: WideString dispid 70;
    property stStkUser4: WideString dispid 71;
    property stSerNoWAvg: Smallint dispid 72;
    property stStkSizeCol: Smallint readonly dispid 73;
    property stSSDDUplift: Double dispid 74;
    property stSSDCountry: WideString dispid 75;
    property stTimeChange: WideString readonly dispid 76;
    property stSVATIncFlg: WideString dispid 77;
    property stSSDAUpLift: Double dispid 78;
    property stLastOpo: WideString dispid 79;
    property stImageFile: WideString dispid 80;
    property stSaleBandsCur[const Index: WideString]: TCurrencyType dispid 82;
    property stSaleBandsPrice[const Index: WideString]: Double dispid 83;
  end;

// *********************************************************************//
// Interface: ICOMTransaction
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3F711192-C8CA-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMTransaction = interface(IDispatch)
    ['{3F711192-C8CA-11D3-A990-0050DA3DF9AD}']
    function LinkToCust: WordBool; safecall;
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_DataChanged: WordBool; safecall;
    function Get_thRunNo: Integer; safecall;
    procedure Set_thRunNo(Value: Integer); safecall;
    function Get_thAcCode: WideString; safecall;
    procedure Set_thAcCode(const Value: WideString); safecall;
    function Get_thNomAuto: WordBool; safecall;
    procedure Set_thNomAuto(Value: WordBool); safecall;
    function Get_thOurRef: WideString; safecall;
    procedure Set_thOurRef(const Value: WideString); safecall;
    function Get_thFolioNum: Integer; safecall;
    procedure Set_thFolioNum(Value: Integer); safecall;
    function Get_thCurrency: Smallint; safecall;
    procedure Set_thCurrency(Value: Smallint); safecall;
    function Get_thYear: Smallint; safecall;
    procedure Set_thYear(Value: Smallint); safecall;
    function Get_thPeriod: Smallint; safecall;
    procedure Set_thPeriod(Value: Smallint); safecall;
    function Get_thDueDate: WideString; safecall;
    procedure Set_thDueDate(const Value: WideString); safecall;
    function Get_thVATPostDate: WideString; safecall;
    procedure Set_thVATPostDate(const Value: WideString); safecall;
    function Get_thTransDate: WideString; safecall;
    procedure Set_thTransDate(const Value: WideString); safecall;
    function Get_thCustSupp: WideString; safecall;
    function Get_thCompanyRate: Double; safecall;
    procedure Set_thCompanyRate(Value: Double); safecall;
    function Get_thDailyRate: Double; safecall;
    procedure Set_thDailyRate(Value: Double); safecall;
    function Get_thYourRef: WideString; safecall;
    procedure Set_thYourRef(const Value: WideString); safecall;
    function Get_thBatchLink: WideString; safecall;
    procedure Set_thBatchLink(const Value: WideString); safecall;
    function Get_thAllocStat: WideString; safecall;
    procedure Set_thAllocStat(const Value: WideString); safecall;
    function Get_thInvNetVal: Double; safecall;
    function Get_thInvVat: Double; safecall;
    function Get_thDiscSetl: Double; safecall;
    procedure Set_thDiscSetl(Value: Double); safecall;
    function Get_thDiscSetAm: Double; safecall;
    procedure Set_thDiscSetAm(Value: Double); safecall;
    function Get_thDiscAmount: Double; safecall;
    procedure Set_thDiscAmount(Value: Double); safecall;
    function Get_thDiscDays: Smallint; safecall;
    procedure Set_thDiscDays(Value: Smallint); safecall;
    function Get_thDiscTaken: WordBool; safecall;
    procedure Set_thDiscTaken(Value: WordBool); safecall;
    function Get_thSettled: Double; safecall;
    procedure Set_thSettled(Value: Double); safecall;
    function Get_thAutoInc: Smallint; safecall;
    procedure Set_thAutoInc(Value: Smallint); safecall;
    function Get_thNextAutoYr: Smallint; safecall;
    procedure Set_thNextAutoYr(Value: Smallint); safecall;
    function Get_thNextAutoPr: Smallint; safecall;
    procedure Set_thNextAutoPr(Value: Smallint); safecall;
    function Get_thTransNat: Smallint; safecall;
    procedure Set_thTransNat(Value: Smallint); safecall;
    function Get_thTransMode: Smallint; safecall;
    procedure Set_thTransMode(Value: Smallint); safecall;
    function Get_thRemitNo: WideString; safecall;
    procedure Set_thRemitNo(const Value: WideString); safecall;
    function Get_thAutoIncBy: WideString; safecall;
    procedure Set_thAutoIncBy(const Value: WideString); safecall;
    function Get_thHoldFlg: Smallint; safecall;
    procedure Set_thHoldFlg(Value: Smallint); safecall;
    function Get_thAuditFlg: WordBool; safecall;
    procedure Set_thAuditFlg(Value: WordBool); safecall;
    function Get_thTotalWeight: Double; safecall;
    procedure Set_thTotalWeight(Value: Double); safecall;
    function Get_thVariance: Double; safecall;
    procedure Set_thVariance(Value: Double); safecall;
    function Get_thTotalOrdered: Double; safecall;
    procedure Set_thTotalOrdered(Value: Double); safecall;
    function Get_thTotalReserved: Double; safecall;
    procedure Set_thTotalReserved(Value: Double); safecall;
    function Get_thTotalCost: Double; safecall;
    procedure Set_thTotalCost(Value: Double); safecall;
    function Get_thTotalInvoiced: Double; safecall;
    procedure Set_thTotalInvoiced(Value: Double); safecall;
    function Get_thTransDesc: WideString; safecall;
    procedure Set_thTransDesc(const Value: WideString); safecall;
    function Get_thAutoUntilDate: WideString; safecall;
    procedure Set_thAutoUntilDate(const Value: WideString); safecall;
    function Get_thExternal: WordBool; safecall;
    procedure Set_thExternal(Value: WordBool); safecall;
    function Get_thPrinted: WordBool; safecall;
    procedure Set_thPrinted(Value: WordBool); safecall;
    function Get_thCurrVariance: Double; safecall;
    procedure Set_thCurrVariance(Value: Double); safecall;
    function Get_thCurrSettled: Double; safecall;
    procedure Set_thCurrSettled(Value: Double); safecall;
    function Get_thSettledVAT: Double; safecall;
    procedure Set_thSettledVAT(Value: Double); safecall;
    function Get_thVATClaimed: Double; safecall;
    procedure Set_thVATClaimed(Value: Double); safecall;
    function Get_thBatchPayGL: Integer; safecall;
    procedure Set_thBatchPayGL(Value: Integer); safecall;
    function Get_thAutoPost: WordBool; safecall;
    procedure Set_thAutoPost(Value: WordBool); safecall;
    function Get_thManualVAT: WordBool; safecall;
    procedure Set_thManualVAT(Value: WordBool); safecall;
    function Get_thSSDDelTerms: WideString; safecall;
    procedure Set_thSSDDelTerms(const Value: WideString); safecall;
    function Get_thUser: WideString; safecall;
    procedure Set_thUser(const Value: WideString); safecall;
    function Get_thNoLabels: Smallint; safecall;
    procedure Set_thNoLabels(Value: Smallint); safecall;
    function Get_thTagged: WordBool; safecall;
    procedure Set_thTagged(Value: WordBool); safecall;
    function Get_thPickRunNo: Integer; safecall;
    procedure Set_thPickRunNo(Value: Integer); safecall;
    function Get_thOrdMatch: WordBool; safecall;
    procedure Set_thOrdMatch(Value: WordBool); safecall;
    function Get_thDeliveryNote: WideString; safecall;
    procedure Set_thDeliveryNote(const Value: WideString); safecall;
    function Get_thVATCompanyRate: Double; safecall;
    procedure Set_thVATCompanyRate(Value: Double); safecall;
    function Get_thVATDailyRate: Double; safecall;
    procedure Set_thVATDailyRate(Value: Double); safecall;
    function Get_thPostCompanyRate: Double; safecall;
    procedure Set_thPostCompanyRate(Value: Double); safecall;
    function Get_thPostDailyRate: Double; safecall;
    procedure Set_thPostDailyRate(Value: Double); safecall;
    function Get_thPostDiscAm: Double; safecall;
    procedure Set_thPostDiscAm(Value: Double); safecall;
    function Get_thPostedDiscTaken: WordBool; safecall;
    procedure Set_thPostedDiscTaken(Value: WordBool); safecall;
    function Get_thDrCrGL: Integer; safecall;
    procedure Set_thDrCrGL(Value: Integer); safecall;
    function Get_thJobCode: WideString; safecall;
    procedure Set_thJobCode(const Value: WideString); safecall;
    function Get_thJobAnal: WideString; safecall;
    procedure Set_thJobAnal(const Value: WideString); safecall;
    function Get_thTotOrderOS: Double; safecall;
    procedure Set_thTotOrderOS(Value: Double); safecall;
    function Get_thUser1: WideString; safecall;
    procedure Set_thUser1(const Value: WideString); safecall;
    function Get_thUser2: WideString; safecall;
    procedure Set_thUser2(const Value: WideString); safecall;
    function Get_thLastLetter: Smallint; safecall;
    procedure Set_thLastLetter(Value: Smallint); safecall;
    function Get_thUnTagged: WordBool; safecall;
    procedure Set_thUnTagged(Value: WordBool); safecall;
    function Get_thUser3: WideString; safecall;
    procedure Set_thUser3(const Value: WideString); safecall;
    function Get_thUser4: WideString; safecall;
    procedure Set_thUser4(const Value: WideString); safecall;
    function Get_thInvVATAnal(Index: TVATIndex): Double; safecall;
    procedure Set_thInvVATAnal(Index: TVATIndex; Value: Double); safecall;
    function Get_thDelAddr(Index: Integer): WideString; safecall;
    procedure Set_thDelAddr(Index: Integer; const Value: WideString); safecall;
    function Get_thDocLSplit(Index: Integer): Double; safecall;
    procedure Set_thDocLSplit(Index: Integer; Value: Double); safecall;
    function Get_thInvDocHed: TDocTypes; safecall;
    procedure Set_thInvDocHed(Value: TDocTypes); safecall;
    function Get_thLines: ICOMTransactionLines; safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property DataChanged: WordBool read Get_DataChanged;
    property thRunNo: Integer read Get_thRunNo write Set_thRunNo;
    property thAcCode: WideString read Get_thAcCode write Set_thAcCode;
    property thNomAuto: WordBool read Get_thNomAuto write Set_thNomAuto;
    property thOurRef: WideString read Get_thOurRef write Set_thOurRef;
    property thFolioNum: Integer read Get_thFolioNum write Set_thFolioNum;
    property thCurrency: Smallint read Get_thCurrency write Set_thCurrency;
    property thYear: Smallint read Get_thYear write Set_thYear;
    property thPeriod: Smallint read Get_thPeriod write Set_thPeriod;
    property thDueDate: WideString read Get_thDueDate write Set_thDueDate;
    property thVATPostDate: WideString read Get_thVATPostDate write Set_thVATPostDate;
    property thTransDate: WideString read Get_thTransDate write Set_thTransDate;
    property thCustSupp: WideString read Get_thCustSupp;
    property thCompanyRate: Double read Get_thCompanyRate write Set_thCompanyRate;
    property thDailyRate: Double read Get_thDailyRate write Set_thDailyRate;
    property thYourRef: WideString read Get_thYourRef write Set_thYourRef;
    property thBatchLink: WideString read Get_thBatchLink write Set_thBatchLink;
    property thAllocStat: WideString read Get_thAllocStat write Set_thAllocStat;
    property thInvNetVal: Double read Get_thInvNetVal;
    property thInvVat: Double read Get_thInvVat;
    property thDiscSetl: Double read Get_thDiscSetl write Set_thDiscSetl;
    property thDiscSetAm: Double read Get_thDiscSetAm write Set_thDiscSetAm;
    property thDiscAmount: Double read Get_thDiscAmount write Set_thDiscAmount;
    property thDiscDays: Smallint read Get_thDiscDays write Set_thDiscDays;
    property thDiscTaken: WordBool read Get_thDiscTaken write Set_thDiscTaken;
    property thSettled: Double read Get_thSettled write Set_thSettled;
    property thAutoInc: Smallint read Get_thAutoInc write Set_thAutoInc;
    property thNextAutoYr: Smallint read Get_thNextAutoYr write Set_thNextAutoYr;
    property thNextAutoPr: Smallint read Get_thNextAutoPr write Set_thNextAutoPr;
    property thTransNat: Smallint read Get_thTransNat write Set_thTransNat;
    property thTransMode: Smallint read Get_thTransMode write Set_thTransMode;
    property thRemitNo: WideString read Get_thRemitNo write Set_thRemitNo;
    property thAutoIncBy: WideString read Get_thAutoIncBy write Set_thAutoIncBy;
    property thHoldFlg: Smallint read Get_thHoldFlg write Set_thHoldFlg;
    property thAuditFlg: WordBool read Get_thAuditFlg write Set_thAuditFlg;
    property thTotalWeight: Double read Get_thTotalWeight write Set_thTotalWeight;
    property thVariance: Double read Get_thVariance write Set_thVariance;
    property thTotalOrdered: Double read Get_thTotalOrdered write Set_thTotalOrdered;
    property thTotalReserved: Double read Get_thTotalReserved write Set_thTotalReserved;
    property thTotalCost: Double read Get_thTotalCost write Set_thTotalCost;
    property thTotalInvoiced: Double read Get_thTotalInvoiced write Set_thTotalInvoiced;
    property thTransDesc: WideString read Get_thTransDesc write Set_thTransDesc;
    property thAutoUntilDate: WideString read Get_thAutoUntilDate write Set_thAutoUntilDate;
    property thExternal: WordBool read Get_thExternal write Set_thExternal;
    property thPrinted: WordBool read Get_thPrinted write Set_thPrinted;
    property thCurrVariance: Double read Get_thCurrVariance write Set_thCurrVariance;
    property thCurrSettled: Double read Get_thCurrSettled write Set_thCurrSettled;
    property thSettledVAT: Double read Get_thSettledVAT write Set_thSettledVAT;
    property thVATClaimed: Double read Get_thVATClaimed write Set_thVATClaimed;
    property thBatchPayGL: Integer read Get_thBatchPayGL write Set_thBatchPayGL;
    property thAutoPost: WordBool read Get_thAutoPost write Set_thAutoPost;
    property thManualVAT: WordBool read Get_thManualVAT write Set_thManualVAT;
    property thSSDDelTerms: WideString read Get_thSSDDelTerms write Set_thSSDDelTerms;
    property thUser: WideString read Get_thUser write Set_thUser;
    property thNoLabels: Smallint read Get_thNoLabels write Set_thNoLabels;
    property thTagged: WordBool read Get_thTagged write Set_thTagged;
    property thPickRunNo: Integer read Get_thPickRunNo write Set_thPickRunNo;
    property thOrdMatch: WordBool read Get_thOrdMatch write Set_thOrdMatch;
    property thDeliveryNote: WideString read Get_thDeliveryNote write Set_thDeliveryNote;
    property thVATCompanyRate: Double read Get_thVATCompanyRate write Set_thVATCompanyRate;
    property thVATDailyRate: Double read Get_thVATDailyRate write Set_thVATDailyRate;
    property thPostCompanyRate: Double read Get_thPostCompanyRate write Set_thPostCompanyRate;
    property thPostDailyRate: Double read Get_thPostDailyRate write Set_thPostDailyRate;
    property thPostDiscAm: Double read Get_thPostDiscAm write Set_thPostDiscAm;
    property thPostedDiscTaken: WordBool read Get_thPostedDiscTaken write Set_thPostedDiscTaken;
    property thDrCrGL: Integer read Get_thDrCrGL write Set_thDrCrGL;
    property thJobCode: WideString read Get_thJobCode write Set_thJobCode;
    property thJobAnal: WideString read Get_thJobAnal write Set_thJobAnal;
    property thTotOrderOS: Double read Get_thTotOrderOS write Set_thTotOrderOS;
    property thUser1: WideString read Get_thUser1 write Set_thUser1;
    property thUser2: WideString read Get_thUser2 write Set_thUser2;
    property thLastLetter: Smallint read Get_thLastLetter write Set_thLastLetter;
    property thUnTagged: WordBool read Get_thUnTagged write Set_thUnTagged;
    property thUser3: WideString read Get_thUser3 write Set_thUser3;
    property thUser4: WideString read Get_thUser4 write Set_thUser4;
    property thInvVATAnal[Index: TVATIndex]: Double read Get_thInvVATAnal write Set_thInvVATAnal;
    property thDelAddr[Index: Integer]: WideString read Get_thDelAddr write Set_thDelAddr;
    property thDocLSplit[Index: Integer]: Double read Get_thDocLSplit write Set_thDocLSplit;
    property thInvDocHed: TDocTypes read Get_thInvDocHed write Set_thInvDocHed;
    property thLines: ICOMTransactionLines read Get_thLines;
  end;

// *********************************************************************//
// DispIntf:  ICOMTransactionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3F711192-C8CA-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMTransactionDisp = dispinterface
    ['{3F711192-C8CA-11D3-A990-0050DA3DF9AD}']
    function LinkToCust: WordBool; dispid 1;
    property AccessRights: TRecordAccessStatus readonly dispid 2;
    property DataChanged: WordBool readonly dispid 3;
    property thRunNo: Integer dispid 4;
    property thAcCode: WideString dispid 5;
    property thNomAuto: WordBool dispid 6;
    property thOurRef: WideString dispid 7;
    property thFolioNum: Integer dispid 8;
    property thCurrency: Smallint dispid 9;
    property thYear: Smallint dispid 10;
    property thPeriod: Smallint dispid 11;
    property thDueDate: WideString dispid 12;
    property thVATPostDate: WideString dispid 13;
    property thTransDate: WideString dispid 14;
    property thCustSupp: WideString readonly dispid 15;
    property thCompanyRate: Double dispid 16;
    property thDailyRate: Double dispid 17;
    property thYourRef: WideString dispid 18;
    property thBatchLink: WideString dispid 19;
    property thAllocStat: WideString dispid 20;
    property thInvNetVal: Double readonly dispid 22;
    property thInvVat: Double readonly dispid 23;
    property thDiscSetl: Double dispid 24;
    property thDiscSetAm: Double dispid 25;
    property thDiscAmount: Double dispid 26;
    property thDiscDays: Smallint dispid 27;
    property thDiscTaken: WordBool dispid 28;
    property thSettled: Double dispid 29;
    property thAutoInc: Smallint dispid 30;
    property thNextAutoYr: Smallint dispid 31;
    property thNextAutoPr: Smallint dispid 32;
    property thTransNat: Smallint dispid 33;
    property thTransMode: Smallint dispid 34;
    property thRemitNo: WideString dispid 35;
    property thAutoIncBy: WideString dispid 36;
    property thHoldFlg: Smallint dispid 37;
    property thAuditFlg: WordBool dispid 38;
    property thTotalWeight: Double dispid 39;
    property thVariance: Double dispid 40;
    property thTotalOrdered: Double dispid 41;
    property thTotalReserved: Double dispid 42;
    property thTotalCost: Double dispid 43;
    property thTotalInvoiced: Double dispid 44;
    property thTransDesc: WideString dispid 45;
    property thAutoUntilDate: WideString dispid 46;
    property thExternal: WordBool dispid 47;
    property thPrinted: WordBool dispid 48;
    property thCurrVariance: Double dispid 49;
    property thCurrSettled: Double dispid 50;
    property thSettledVAT: Double dispid 51;
    property thVATClaimed: Double dispid 52;
    property thBatchPayGL: Integer dispid 53;
    property thAutoPost: WordBool dispid 54;
    property thManualVAT: WordBool dispid 55;
    property thSSDDelTerms: WideString dispid 56;
    property thUser: WideString dispid 57;
    property thNoLabels: Smallint dispid 58;
    property thTagged: WordBool dispid 59;
    property thPickRunNo: Integer dispid 60;
    property thOrdMatch: WordBool dispid 61;
    property thDeliveryNote: WideString dispid 62;
    property thVATCompanyRate: Double dispid 63;
    property thVATDailyRate: Double dispid 64;
    property thPostCompanyRate: Double dispid 65;
    property thPostDailyRate: Double dispid 66;
    property thPostDiscAm: Double dispid 67;
    property thPostedDiscTaken: WordBool dispid 68;
    property thDrCrGL: Integer dispid 69;
    property thJobCode: WideString dispid 70;
    property thJobAnal: WideString dispid 71;
    property thTotOrderOS: Double dispid 72;
    property thUser1: WideString dispid 73;
    property thUser2: WideString dispid 74;
    property thLastLetter: Smallint dispid 75;
    property thUnTagged: WordBool dispid 76;
    property thUser3: WideString dispid 77;
    property thUser4: WideString dispid 78;
    property thInvVATAnal[Index: TVATIndex]: Double dispid 21;
    property thDelAddr[Index: Integer]: WideString dispid 79;
    property thDocLSplit[Index: Integer]: Double dispid 80;
    property thInvDocHed: TDocTypes dispid 81;
    property thLines: ICOMTransactionLines readonly dispid 82;
  end;

// *********************************************************************//
// Interface: ICOMTransactionLines
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCD86082-C8D8-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMTransactionLines = interface(IDispatch)
    ['{CCD86082-C8D8-11D3-A990-0050DA3DF9AD}']
    procedure AddNewLine; safecall;
    function Get_thLineCount: Integer; safecall;
    function Get_thLine(Index: Integer): ICOMTransactionLine; safecall;
    function Get_thCurrentLine: ICOMTransactionLine; safecall;
    property thLineCount: Integer read Get_thLineCount;
    property thLine[Index: Integer]: ICOMTransactionLine read Get_thLine;
    property thCurrentLine: ICOMTransactionLine read Get_thCurrentLine;
  end;

// *********************************************************************//
// DispIntf:  ICOMTransactionLinesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCD86082-C8D8-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMTransactionLinesDisp = dispinterface
    ['{CCD86082-C8D8-11D3-A990-0050DA3DF9AD}']
    procedure AddNewLine; dispid 1;
    property thLineCount: Integer readonly dispid 2;
    property thLine[Index: Integer]: ICOMTransactionLine readonly dispid 3;
    property thCurrentLine: ICOMTransactionLine readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ICOMTransactionLine
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCD86084-C8D8-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMTransactionLine = interface(IDispatch)
    ['{CCD86084-C8D8-11D3-A990-0050DA3DF9AD}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_DataChanged: WordBool; safecall;
    function Get_tlFolio: Integer; safecall;
    procedure Set_tlFolio(Value: Integer); safecall;
    function Get_tlLinePos: Integer; safecall;
    procedure Set_tlLinePos(Value: Integer); safecall;
    function Get_tlRunNo: Integer; safecall;
    procedure Set_tlRunNo(Value: Integer); safecall;
    function Get_tlGLCode: Integer; safecall;
    procedure Set_tlGLCode(Value: Integer); safecall;
    function Get_tlShowInGL: Smallint; safecall;
    procedure Set_tlShowInGL(Value: Smallint); safecall;
    function Get_tlCurrency: TCurrencyType; safecall;
    procedure Set_tlCurrency(Value: TCurrencyType); safecall;
    function Get_tlYear: Smallint; safecall;
    function Get_tlPeriod: Smallint; safecall;
    function Get_tlCostCentre: WideString; safecall;
    procedure Set_tlCostCentre(const Value: WideString); safecall;
    function Get_tlDepartment: WideString; safecall;
    procedure Set_tlDepartment(const Value: WideString); safecall;
    function Get_tlStockCode: WideString; safecall;
    procedure Set_tlStockCode(const Value: WideString); safecall;
    function Get_tlLineNo: Integer; safecall;
    procedure Set_tlLineNo(Value: Integer); safecall;
    function Get_tlLineClass: WideString; safecall;
    function Get_tlDocType: TDocTypes; safecall;
    function Get_tlQty: Double; safecall;
    procedure Set_tlQty(Value: Double); safecall;
    function Get_tlQtyMul: Double; safecall;
    procedure Set_tlQtyMul(Value: Double); safecall;
    function Get_tlNetValue: Double; safecall;
    procedure Set_tlNetValue(Value: Double); safecall;
    function Get_tlDiscount: Double; safecall;
    procedure Set_tlDiscount(Value: Double); safecall;
    function Get_tlVATCode: WideString; safecall;
    procedure Set_tlVATCode(const Value: WideString); safecall;
    function Get_tlVATAmount: Double; safecall;
    procedure Set_tlVATAmount(Value: Double); safecall;
    function Get_tlPayStatus: WideString; safecall;
    procedure Set_tlPayStatus(const Value: WideString); safecall;
    function Get_tlPrevGLBal: Double; safecall;
    procedure Set_tlPrevGLBal(Value: Double); safecall;
    function Get_tlRecStatus: Smallint; safecall;
    procedure Set_tlRecStatus(Value: Smallint); safecall;
    function Get_tlDiscFlag: WideString; safecall;
    procedure Set_tlDiscFlag(const Value: WideString); safecall;
    function Get_tlQtyWOFF: Double; safecall;
    procedure Set_tlQtyWOFF(Value: Double); safecall;
    function Get_tlQtyDel: Double; safecall;
    procedure Set_tlQtyDel(Value: Double); safecall;
    function Get_tlCost: Double; safecall;
    procedure Set_tlCost(Value: Double); safecall;
    function Get_tlAcCode: WideString; safecall;
    function Get_tlTransDate: WideString; safecall;
    procedure Set_tlTransDate(const Value: WideString); safecall;
    function Get_tlItemNo: WideString; safecall;
    procedure Set_tlItemNo(const Value: WideString); safecall;
    function Get_tlDescr: WideString; safecall;
    procedure Set_tlDescr(const Value: WideString); safecall;
    function Get_tlJobCode: WideString; safecall;
    procedure Set_tlJobCode(const Value: WideString); safecall;
    function Get_tlJobAnal: WideString; safecall;
    procedure Set_tlJobAnal(const Value: WideString); safecall;
    function Get_tlCompanyRate: Double; safecall;
    procedure Set_tlCompanyRate(Value: Double); safecall;
    function Get_tlDailyRate: Double; safecall;
    procedure Set_tlDailyRate(Value: Double); safecall;
    function Get_tlUnitWeight: Double; safecall;
    procedure Set_tlUnitWeight(Value: Double); safecall;
    function Get_tlStockDeductQty: Double; safecall;
    procedure Set_tlStockDeductQty(Value: Double); safecall;
    function Get_tlBOMKitLink: Integer; safecall;
    procedure Set_tlBOMKitLink(Value: Integer); safecall;
    function Get_tlOrderFolio: Integer; safecall;
    procedure Set_tlOrderFolio(Value: Integer); safecall;
    function Get_tlOrderLineNo: Integer; safecall;
    procedure Set_tlOrderLineNo(Value: Integer); safecall;
    function Get_tlLocation: WideString; safecall;
    procedure Set_tlLocation(const Value: WideString); safecall;
    function Get_tlQtyPicked: Double; safecall;
    procedure Set_tlQtyPicked(Value: Double); safecall;
    function Get_tlQtyPickedWO: Double; safecall;
    procedure Set_tlQtyPickedWO(Value: Double); safecall;
    function Get_tlUseQtyMul: WordBool; safecall;
    procedure Set_tlUseQtyMul(Value: WordBool); safecall;
    function Get_tlNoSerialNos: Double; safecall;
    procedure Set_tlNoSerialNos(Value: Double); safecall;
    function Get_tlCOSGL: Integer; safecall;
    procedure Set_tlCOSGL(Value: Integer); safecall;
    function Get_tlOurRef: WideString; safecall;
    function Get_tlLineType: Integer; safecall;
    procedure Set_tlLineType(Value: Integer); safecall;
    function Get_tlPriceByPack: WordBool; safecall;
    procedure Set_tlPriceByPack(Value: WordBool); safecall;
    function Get_tlQtyInPack: Double; safecall;
    procedure Set_tlQtyInPack(Value: Double); safecall;
    function Get_tlClearDate: WideString; safecall;
    procedure Set_tlClearDate(const Value: WideString); safecall;
    function Get_tlUserDef1: WideString; safecall;
    procedure Set_tlUserDef1(const Value: WideString); safecall;
    function Get_tlUserDef2: WideString; safecall;
    procedure Set_tlUserDef2(const Value: WideString); safecall;
    function Get_tlUserDef3: WideString; safecall;
    procedure Set_tlUserDef3(const Value: WideString); safecall;
    function Get_tlUserDef4: WideString; safecall;
    procedure Set_tlUserDef4(const Value: WideString); safecall;
    function entInvLTotal(UseDisc: WordBool; SetlDisc: Double): Double; safecall;
    procedure Delete; safecall;
    procedure Save; safecall;
    function LinkToStock: WordBool; safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property DataChanged: WordBool read Get_DataChanged;
    property tlFolio: Integer read Get_tlFolio write Set_tlFolio;
    property tlLinePos: Integer read Get_tlLinePos write Set_tlLinePos;
    property tlRunNo: Integer read Get_tlRunNo write Set_tlRunNo;
    property tlGLCode: Integer read Get_tlGLCode write Set_tlGLCode;
    property tlShowInGL: Smallint read Get_tlShowInGL write Set_tlShowInGL;
    property tlCurrency: TCurrencyType read Get_tlCurrency write Set_tlCurrency;
    property tlYear: Smallint read Get_tlYear;
    property tlPeriod: Smallint read Get_tlPeriod;
    property tlCostCentre: WideString read Get_tlCostCentre write Set_tlCostCentre;
    property tlDepartment: WideString read Get_tlDepartment write Set_tlDepartment;
    property tlStockCode: WideString read Get_tlStockCode write Set_tlStockCode;
    property tlLineNo: Integer read Get_tlLineNo write Set_tlLineNo;
    property tlLineClass: WideString read Get_tlLineClass;
    property tlDocType: TDocTypes read Get_tlDocType;
    property tlQty: Double read Get_tlQty write Set_tlQty;
    property tlQtyMul: Double read Get_tlQtyMul write Set_tlQtyMul;
    property tlNetValue: Double read Get_tlNetValue write Set_tlNetValue;
    property tlDiscount: Double read Get_tlDiscount write Set_tlDiscount;
    property tlVATCode: WideString read Get_tlVATCode write Set_tlVATCode;
    property tlVATAmount: Double read Get_tlVATAmount write Set_tlVATAmount;
    property tlPayStatus: WideString read Get_tlPayStatus write Set_tlPayStatus;
    property tlPrevGLBal: Double read Get_tlPrevGLBal write Set_tlPrevGLBal;
    property tlRecStatus: Smallint read Get_tlRecStatus write Set_tlRecStatus;
    property tlDiscFlag: WideString read Get_tlDiscFlag write Set_tlDiscFlag;
    property tlQtyWOFF: Double read Get_tlQtyWOFF write Set_tlQtyWOFF;
    property tlQtyDel: Double read Get_tlQtyDel write Set_tlQtyDel;
    property tlCost: Double read Get_tlCost write Set_tlCost;
    property tlAcCode: WideString read Get_tlAcCode;
    property tlTransDate: WideString read Get_tlTransDate write Set_tlTransDate;
    property tlItemNo: WideString read Get_tlItemNo write Set_tlItemNo;
    property tlDescr: WideString read Get_tlDescr write Set_tlDescr;
    property tlJobCode: WideString read Get_tlJobCode write Set_tlJobCode;
    property tlJobAnal: WideString read Get_tlJobAnal write Set_tlJobAnal;
    property tlCompanyRate: Double read Get_tlCompanyRate write Set_tlCompanyRate;
    property tlDailyRate: Double read Get_tlDailyRate write Set_tlDailyRate;
    property tlUnitWeight: Double read Get_tlUnitWeight write Set_tlUnitWeight;
    property tlStockDeductQty: Double read Get_tlStockDeductQty write Set_tlStockDeductQty;
    property tlBOMKitLink: Integer read Get_tlBOMKitLink write Set_tlBOMKitLink;
    property tlOrderFolio: Integer read Get_tlOrderFolio write Set_tlOrderFolio;
    property tlOrderLineNo: Integer read Get_tlOrderLineNo write Set_tlOrderLineNo;
    property tlLocation: WideString read Get_tlLocation write Set_tlLocation;
    property tlQtyPicked: Double read Get_tlQtyPicked write Set_tlQtyPicked;
    property tlQtyPickedWO: Double read Get_tlQtyPickedWO write Set_tlQtyPickedWO;
    property tlUseQtyMul: WordBool read Get_tlUseQtyMul write Set_tlUseQtyMul;
    property tlNoSerialNos: Double read Get_tlNoSerialNos write Set_tlNoSerialNos;
    property tlCOSGL: Integer read Get_tlCOSGL write Set_tlCOSGL;
    property tlOurRef: WideString read Get_tlOurRef;
    property tlLineType: Integer read Get_tlLineType write Set_tlLineType;
    property tlPriceByPack: WordBool read Get_tlPriceByPack write Set_tlPriceByPack;
    property tlQtyInPack: Double read Get_tlQtyInPack write Set_tlQtyInPack;
    property tlClearDate: WideString read Get_tlClearDate write Set_tlClearDate;
    property tlUserDef1: WideString read Get_tlUserDef1 write Set_tlUserDef1;
    property tlUserDef2: WideString read Get_tlUserDef2 write Set_tlUserDef2;
    property tlUserDef3: WideString read Get_tlUserDef3 write Set_tlUserDef3;
    property tlUserDef4: WideString read Get_tlUserDef4 write Set_tlUserDef4;
  end;

// *********************************************************************//
// DispIntf:  ICOMTransactionLineDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCD86084-C8D8-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMTransactionLineDisp = dispinterface
    ['{CCD86084-C8D8-11D3-A990-0050DA3DF9AD}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property tlFolio: Integer dispid 3;
    property tlLinePos: Integer dispid 4;
    property tlRunNo: Integer dispid 5;
    property tlGLCode: Integer dispid 6;
    property tlShowInGL: Smallint dispid 7;
    property tlCurrency: TCurrencyType dispid 8;
    property tlYear: Smallint readonly dispid 9;
    property tlPeriod: Smallint readonly dispid 10;
    property tlCostCentre: WideString dispid 11;
    property tlDepartment: WideString dispid 12;
    property tlStockCode: WideString dispid 13;
    property tlLineNo: Integer dispid 14;
    property tlLineClass: WideString readonly dispid 15;
    property tlDocType: TDocTypes readonly dispid 16;
    property tlQty: Double dispid 17;
    property tlQtyMul: Double dispid 18;
    property tlNetValue: Double dispid 19;
    property tlDiscount: Double dispid 20;
    property tlVATCode: WideString dispid 21;
    property tlVATAmount: Double dispid 22;
    property tlPayStatus: WideString dispid 23;
    property tlPrevGLBal: Double dispid 24;
    property tlRecStatus: Smallint dispid 25;
    property tlDiscFlag: WideString dispid 26;
    property tlQtyWOFF: Double dispid 27;
    property tlQtyDel: Double dispid 28;
    property tlCost: Double dispid 29;
    property tlAcCode: WideString readonly dispid 30;
    property tlTransDate: WideString dispid 31;
    property tlItemNo: WideString dispid 32;
    property tlDescr: WideString dispid 33;
    property tlJobCode: WideString dispid 34;
    property tlJobAnal: WideString dispid 35;
    property tlCompanyRate: Double dispid 36;
    property tlDailyRate: Double dispid 37;
    property tlUnitWeight: Double dispid 38;
    property tlStockDeductQty: Double dispid 39;
    property tlBOMKitLink: Integer dispid 40;
    property tlOrderFolio: Integer dispid 41;
    property tlOrderLineNo: Integer dispid 42;
    property tlLocation: WideString dispid 43;
    property tlQtyPicked: Double dispid 44;
    property tlQtyPickedWO: Double dispid 45;
    property tlUseQtyMul: WordBool dispid 46;
    property tlNoSerialNos: Double dispid 47;
    property tlCOSGL: Integer dispid 48;
    property tlOurRef: WideString readonly dispid 49;
    property tlLineType: Integer dispid 50;
    property tlPriceByPack: WordBool dispid 51;
    property tlQtyInPack: Double dispid 52;
    property tlClearDate: WideString dispid 53;
    property tlUserDef1: WideString dispid 54;
    property tlUserDef2: WideString dispid 55;
    property tlUserDef3: WideString dispid 56;
    property tlUserDef4: WideString dispid 57;
    function entInvLTotal(UseDisc: WordBool; SetlDisc: Double): Double; dispid 58;
    procedure Delete; dispid 59;
    procedure Save; dispid 60;
    function LinkToStock: WordBool; dispid 61;
  end;

// *********************************************************************//
// Interface: ICOMBatchSerial
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1FAA1706-C900-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMBatchSerial = interface(IDispatch)
    ['{1FAA1706-C900-11D3-A990-0050DA3DF9AD}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_DataChanged: WordBool; safecall;
    function Get_bsSerialCode: WideString; safecall;
    procedure Set_bsSerialCode(const Value: WideString); safecall;
    function Get_bsSerialNo: WideString; safecall;
    procedure Set_bsSerialNo(const Value: WideString); safecall;
    function Get_bsBatchNo: WideString; safecall;
    procedure Set_bsBatchNo(const Value: WideString); safecall;
    function Get_bsInDoc: WideString; safecall;
    procedure Set_bsInDoc(const Value: WideString); safecall;
    function Get_bsOutDoc: WideString; safecall;
    procedure Set_bsOutDoc(const Value: WideString); safecall;
    function Get_bsSold: WordBool; safecall;
    procedure Set_bsSold(Value: WordBool); safecall;
    function Get_bsDateIn: WideString; safecall;
    procedure Set_bsDateIn(const Value: WideString); safecall;
    function Get_bsSerCost: Double; safecall;
    procedure Set_bsSerCost(Value: Double); safecall;
    function Get_bsSerSell: Double; safecall;
    procedure Set_bsSerSell(Value: Double); safecall;
    function Get_bsStkFolio: Integer; safecall;
    procedure Set_bsStkFolio(Value: Integer); safecall;
    function Get_bsDateOut: WideString; safecall;
    procedure Set_bsDateOut(const Value: WideString); safecall;
    function Get_bsSoldLine: Integer; safecall;
    procedure Set_bsSoldLine(Value: Integer); safecall;
    function Get_bsCurCost: TCurrencyType; safecall;
    procedure Set_bsCurCost(Value: TCurrencyType); safecall;
    function Get_bsCurSell: TCurrencyType; safecall;
    procedure Set_bsCurSell(Value: TCurrencyType); safecall;
    function Get_bsBuyLine: Integer; safecall;
    procedure Set_bsBuyLine(Value: Integer); safecall;
    function Get_bsBatchRec: WordBool; safecall;
    procedure Set_bsBatchRec(Value: WordBool); safecall;
    function Get_bsBuyQty: Double; safecall;
    procedure Set_bsBuyQty(Value: Double); safecall;
    function Get_bsQtyUsed: Double; safecall;
    procedure Set_bsQtyUsed(Value: Double); safecall;
    function Get_bsBatchChild: WordBool; safecall;
    procedure Set_bsBatchChild(Value: WordBool); safecall;
    function Get_bsInMLoc: WideString; safecall;
    procedure Set_bsInMLoc(const Value: WideString); safecall;
    function Get_bsOutMLoc: WideString; safecall;
    procedure Set_bsOutMLoc(const Value: WideString); safecall;
    function Get_bsCompanyRate: Double; safecall;
    procedure Set_bsCompanyRate(Value: Double); safecall;
    function Get_bsDailyRate: Double; safecall;
    procedure Set_bsDailyRate(Value: Double); safecall;
    function Get_bsInOrdDoc: WideString; safecall;
    procedure Set_bsInOrdDoc(const Value: WideString); safecall;
    function Get_bsOutOrdDoc: WideString; safecall;
    procedure Set_bsOutOrdDoc(const Value: WideString); safecall;
    function Get_bsInOrdLine: Integer; safecall;
    procedure Set_bsInOrdLine(Value: Integer); safecall;
    function Get_bsOutOrdLine: Integer; safecall;
    procedure Set_bsOutOrdLine(Value: Integer); safecall;
    function Get_bsNLineCount: Integer; safecall;
    procedure Set_bsNLineCount(Value: Integer); safecall;
    function Get_bsNoteFolio: Integer; safecall;
    procedure Set_bsNoteFolio(Value: Integer); safecall;
    function Get_bsDateUseX: WideString; safecall;
    procedure Set_bsDateUseX(const Value: WideString); safecall;
    function Get_bsSUseORate: Smallint; safecall;
    procedure Set_bsSUseORate(Value: Smallint); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property DataChanged: WordBool read Get_DataChanged;
    property bsSerialCode: WideString read Get_bsSerialCode write Set_bsSerialCode;
    property bsSerialNo: WideString read Get_bsSerialNo write Set_bsSerialNo;
    property bsBatchNo: WideString read Get_bsBatchNo write Set_bsBatchNo;
    property bsInDoc: WideString read Get_bsInDoc write Set_bsInDoc;
    property bsOutDoc: WideString read Get_bsOutDoc write Set_bsOutDoc;
    property bsSold: WordBool read Get_bsSold write Set_bsSold;
    property bsDateIn: WideString read Get_bsDateIn write Set_bsDateIn;
    property bsSerCost: Double read Get_bsSerCost write Set_bsSerCost;
    property bsSerSell: Double read Get_bsSerSell write Set_bsSerSell;
    property bsStkFolio: Integer read Get_bsStkFolio write Set_bsStkFolio;
    property bsDateOut: WideString read Get_bsDateOut write Set_bsDateOut;
    property bsSoldLine: Integer read Get_bsSoldLine write Set_bsSoldLine;
    property bsCurCost: TCurrencyType read Get_bsCurCost write Set_bsCurCost;
    property bsCurSell: TCurrencyType read Get_bsCurSell write Set_bsCurSell;
    property bsBuyLine: Integer read Get_bsBuyLine write Set_bsBuyLine;
    property bsBatchRec: WordBool read Get_bsBatchRec write Set_bsBatchRec;
    property bsBuyQty: Double read Get_bsBuyQty write Set_bsBuyQty;
    property bsQtyUsed: Double read Get_bsQtyUsed write Set_bsQtyUsed;
    property bsBatchChild: WordBool read Get_bsBatchChild write Set_bsBatchChild;
    property bsInMLoc: WideString read Get_bsInMLoc write Set_bsInMLoc;
    property bsOutMLoc: WideString read Get_bsOutMLoc write Set_bsOutMLoc;
    property bsCompanyRate: Double read Get_bsCompanyRate write Set_bsCompanyRate;
    property bsDailyRate: Double read Get_bsDailyRate write Set_bsDailyRate;
    property bsInOrdDoc: WideString read Get_bsInOrdDoc write Set_bsInOrdDoc;
    property bsOutOrdDoc: WideString read Get_bsOutOrdDoc write Set_bsOutOrdDoc;
    property bsInOrdLine: Integer read Get_bsInOrdLine write Set_bsInOrdLine;
    property bsOutOrdLine: Integer read Get_bsOutOrdLine write Set_bsOutOrdLine;
    property bsNLineCount: Integer read Get_bsNLineCount write Set_bsNLineCount;
    property bsNoteFolio: Integer read Get_bsNoteFolio write Set_bsNoteFolio;
    property bsDateUseX: WideString read Get_bsDateUseX write Set_bsDateUseX;
    property bsSUseORate: Smallint read Get_bsSUseORate write Set_bsSUseORate;
  end;

// *********************************************************************//
// DispIntf:  ICOMBatchSerialDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1FAA1706-C900-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMBatchSerialDisp = dispinterface
    ['{1FAA1706-C900-11D3-A990-0050DA3DF9AD}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property bsSerialCode: WideString dispid 3;
    property bsSerialNo: WideString dispid 4;
    property bsBatchNo: WideString dispid 5;
    property bsInDoc: WideString dispid 6;
    property bsOutDoc: WideString dispid 7;
    property bsSold: WordBool dispid 8;
    property bsDateIn: WideString dispid 9;
    property bsSerCost: Double dispid 10;
    property bsSerSell: Double dispid 11;
    property bsStkFolio: Integer dispid 12;
    property bsDateOut: WideString dispid 13;
    property bsSoldLine: Integer dispid 14;
    property bsCurCost: TCurrencyType dispid 15;
    property bsCurSell: TCurrencyType dispid 16;
    property bsBuyLine: Integer dispid 17;
    property bsBatchRec: WordBool dispid 18;
    property bsBuyQty: Double dispid 19;
    property bsQtyUsed: Double dispid 20;
    property bsBatchChild: WordBool dispid 21;
    property bsInMLoc: WideString dispid 22;
    property bsOutMLoc: WideString dispid 23;
    property bsCompanyRate: Double dispid 24;
    property bsDailyRate: Double dispid 25;
    property bsInOrdDoc: WideString dispid 26;
    property bsOutOrdDoc: WideString dispid 27;
    property bsInOrdLine: Integer dispid 28;
    property bsOutOrdLine: Integer dispid 29;
    property bsNLineCount: Integer dispid 30;
    property bsNoteFolio: Integer dispid 31;
    property bsDateUseX: WideString dispid 32;
    property bsSUseORate: Smallint dispid 33;
  end;

// *********************************************************************//
// Interface: ICOMJob
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF9CC260-D310-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMJob = interface(IDispatch)
    ['{AF9CC260-D310-11D3-A990-0050DA3DF9AD}']
    function Get_jrJobCode: WideString; safecall;
    procedure Set_jrJobCode(const Value: WideString); safecall;
    function Get_jrJobDesc: WideString; safecall;
    procedure Set_jrJobDesc(const Value: WideString); safecall;
    function Get_jrJobFolio: Integer; safecall;
    function Get_jrCustCode: WideString; safecall;
    procedure Set_jrCustCode(const Value: WideString); safecall;
    function Get_jrJobCat: WideString; safecall;
    procedure Set_jrJobCat(const Value: WideString); safecall;
    function Get_jrJobAltCode: WideString; safecall;
    procedure Set_jrJobAltCode(const Value: WideString); safecall;
    function Get_jrCompleted: Integer; safecall;
    procedure Set_jrCompleted(Value: Integer); safecall;
    function Get_jrContact: WideString; safecall;
    procedure Set_jrContact(const Value: WideString); safecall;
    function Get_jrJobMan: WideString; safecall;
    procedure Set_jrJobMan(const Value: WideString); safecall;
    function Get_jrChargeType: Smallint; safecall;
    procedure Set_jrChargeType(Value: Smallint); safecall;
    function Get_jrQuotePrice: Double; safecall;
    procedure Set_jrQuotePrice(Value: Double); safecall;
    function Get_jrCurrPrice: Smallint; safecall;
    procedure Set_jrCurrPrice(Value: Smallint); safecall;
    function Get_jrStartDate: WideString; safecall;
    procedure Set_jrStartDate(const Value: WideString); safecall;
    function Get_jrEndDate: WideString; safecall;
    procedure Set_jrEndDate(const Value: WideString); safecall;
    function Get_jrRevEDate: WideString; safecall;
    procedure Set_jrRevEDate(const Value: WideString); safecall;
    function Get_jrSORRef: WideString; safecall;
    procedure Set_jrSORRef(const Value: WideString); safecall;
    function Get_jrVATCode: WideString; safecall;
    procedure Set_jrVATCode(const Value: WideString); safecall;
    function Get_jrDept: WideString; safecall;
    procedure Set_jrDept(const Value: WideString); safecall;
    function Get_jrCostCentre: WideString; safecall;
    procedure Set_jrCostCentre(const Value: WideString); safecall;
    function Get_jrJobAnal: WideString; safecall;
    procedure Set_jrJobAnal(const Value: WideString); safecall;
    function Get_jrJobType: WideString; safecall;
    procedure Set_jrJobType(const Value: WideString); safecall;
    function Get_jrJobStat: Integer; safecall;
    procedure Set_jrJobStat(Value: Integer); safecall;
    function Get_jrUserDef1: WideString; safecall;
    procedure Set_jrUserDef1(const Value: WideString); safecall;
    function Get_jrUserDef2: WideString; safecall;
    procedure Set_jrUserDef2(const Value: WideString); safecall;
    function Get_jrUserDef3: WideString; safecall;
    procedure Set_jrUserDef3(const Value: WideString); safecall;
    function Get_jrUserDef4: WideString; safecall;
    procedure Set_jrUserDef4(const Value: WideString); safecall;
    property jrJobCode: WideString read Get_jrJobCode write Set_jrJobCode;
    property jrJobDesc: WideString read Get_jrJobDesc write Set_jrJobDesc;
    property jrJobFolio: Integer read Get_jrJobFolio;
    property jrCustCode: WideString read Get_jrCustCode write Set_jrCustCode;
    property jrJobCat: WideString read Get_jrJobCat write Set_jrJobCat;
    property jrJobAltCode: WideString read Get_jrJobAltCode write Set_jrJobAltCode;
    property jrCompleted: Integer read Get_jrCompleted write Set_jrCompleted;
    property jrContact: WideString read Get_jrContact write Set_jrContact;
    property jrJobMan: WideString read Get_jrJobMan write Set_jrJobMan;
    property jrChargeType: Smallint read Get_jrChargeType write Set_jrChargeType;
    property jrQuotePrice: Double read Get_jrQuotePrice write Set_jrQuotePrice;
    property jrCurrPrice: Smallint read Get_jrCurrPrice write Set_jrCurrPrice;
    property jrStartDate: WideString read Get_jrStartDate write Set_jrStartDate;
    property jrEndDate: WideString read Get_jrEndDate write Set_jrEndDate;
    property jrRevEDate: WideString read Get_jrRevEDate write Set_jrRevEDate;
    property jrSORRef: WideString read Get_jrSORRef write Set_jrSORRef;
    property jrVATCode: WideString read Get_jrVATCode write Set_jrVATCode;
    property jrDept: WideString read Get_jrDept write Set_jrDept;
    property jrCostCentre: WideString read Get_jrCostCentre write Set_jrCostCentre;
    property jrJobAnal: WideString read Get_jrJobAnal write Set_jrJobAnal;
    property jrJobType: WideString read Get_jrJobType write Set_jrJobType;
    property jrJobStat: Integer read Get_jrJobStat write Set_jrJobStat;
    property jrUserDef1: WideString read Get_jrUserDef1 write Set_jrUserDef1;
    property jrUserDef2: WideString read Get_jrUserDef2 write Set_jrUserDef2;
    property jrUserDef3: WideString read Get_jrUserDef3 write Set_jrUserDef3;
    property jrUserDef4: WideString read Get_jrUserDef4 write Set_jrUserDef4;
  end;

// *********************************************************************//
// DispIntf:  ICOMJobDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF9CC260-D310-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMJobDisp = dispinterface
    ['{AF9CC260-D310-11D3-A990-0050DA3DF9AD}']
    property jrJobCode: WideString dispid 1;
    property jrJobDesc: WideString dispid 2;
    property jrJobFolio: Integer readonly dispid 3;
    property jrCustCode: WideString dispid 4;
    property jrJobCat: WideString dispid 5;
    property jrJobAltCode: WideString dispid 6;
    property jrCompleted: Integer dispid 7;
    property jrContact: WideString dispid 8;
    property jrJobMan: WideString dispid 9;
    property jrChargeType: Smallint dispid 10;
    property jrQuotePrice: Double dispid 11;
    property jrCurrPrice: Smallint dispid 12;
    property jrStartDate: WideString dispid 13;
    property jrEndDate: WideString dispid 14;
    property jrRevEDate: WideString dispid 15;
    property jrSORRef: WideString dispid 16;
    property jrVATCode: WideString dispid 17;
    property jrDept: WideString dispid 18;
    property jrCostCentre: WideString dispid 19;
    property jrJobAnal: WideString dispid 20;
    property jrJobType: WideString dispid 21;
    property jrJobStat: Integer dispid 22;
    property jrUserDef1: WideString dispid 23;
    property jrUserDef2: WideString dispid 24;
    property jrUserDef3: WideString dispid 25;
    property jrUserDef4: WideString dispid 26;
  end;

// *********************************************************************//
// Interface: ICOMMiscData
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {629744C0-DD71-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMMiscData = interface(IDispatch)
    ['{629744C0-DD71-11D3-A990-0050DA3DF9AD}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_DataChanged: WordBool; safecall;
    function Get_mdBoolean(Index: Integer): WordBool; safecall;
    procedure Set_mdBoolean(Index: Integer; Value: WordBool); safecall;
    function Get_mdDouble(Index: Integer): Double; safecall;
    procedure Set_mdDouble(Index: Integer; Value: Double); safecall;
    function Get_mdLongInt(Index: Integer): Integer; safecall;
    procedure Set_mdLongInt(Index: Integer; Value: Integer); safecall;
    function Get_mdString(Index: Integer): WideString; safecall;
    procedure Set_mdString(Index: Integer; const Value: WideString); safecall;
    function Get_mdVariant(Index: Integer): OleVariant; safecall;
    procedure Set_mdVariant(Index: Integer; Value: OleVariant); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property DataChanged: WordBool read Get_DataChanged;
    property mdBoolean[Index: Integer]: WordBool read Get_mdBoolean write Set_mdBoolean;
    property mdDouble[Index: Integer]: Double read Get_mdDouble write Set_mdDouble;
    property mdLongInt[Index: Integer]: Integer read Get_mdLongInt write Set_mdLongInt;
    property mdString[Index: Integer]: WideString read Get_mdString write Set_mdString;
    property mdVariant[Index: Integer]: OleVariant read Get_mdVariant write Set_mdVariant;
  end;

// *********************************************************************//
// DispIntf:  ICOMMiscDataDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {629744C0-DD71-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMMiscDataDisp = dispinterface
    ['{629744C0-DD71-11D3-A990-0050DA3DF9AD}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property mdBoolean[Index: Integer]: WordBool dispid 3;
    property mdDouble[Index: Integer]: Double dispid 4;
    property mdLongInt[Index: Integer]: Integer dispid 5;
    property mdString[Index: Integer]: WideString dispid 6;
    property mdVariant[Index: Integer]: OleVariant dispid 7;
  end;

// *********************************************************************//
// Interface: ICOMEventData01
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {45953060-E453-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMEventData01 = interface(ICOMEventData)
    ['{45953060-E453-11D3-A990-0050DA3DF9AD}']
    function Get_BatchSerial: ICOMBatchSerial; safecall;
    property BatchSerial: ICOMBatchSerial read Get_BatchSerial;
  end;

// *********************************************************************//
// DispIntf:  ICOMEventData01Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {45953060-E453-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMEventData01Disp = dispinterface
    ['{45953060-E453-11D3-A990-0050DA3DF9AD}']
    property BatchSerial: ICOMBatchSerial readonly dispid 37;
    property WindowId: Integer readonly dispid 1;
    property HandlerId: Integer readonly dispid 2;
    property Customer: ICOMCustomer readonly dispid 3;
    property Supplier: ICOMCustomer readonly dispid 4;
    property CostCentre: ICOMCCDept readonly dispid 5;
    property Department: ICOMCCDept readonly dispid 6;
    property GLCode: ICOMGLCode readonly dispid 7;
    property Stock: ICOMStock readonly dispid 8;
    property Transaction: ICOMTransaction readonly dispid 9;
    property Job: ICOMJob readonly dispid 10;
    property MiscData: ICOMMiscData readonly dispid 11;
    property ValidStatus: WordBool dispid 12;
    property BoResult: WordBool dispid 13;
    property DblResult: Double dispid 14;
    property IntResult: Integer dispid 15;
    property StrResult: WideString dispid 16;
    property VarResult: OleVariant dispid 17;
    property InEditMode: WordBool readonly dispid 25;
  end;

// *********************************************************************//
// Interface: ICOMVersion
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8512EC3D-E481-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMVersion = interface(IDispatch)
    ['{8512EC3D-E481-11D3-A990-0050DA3DF9AD}']
    function Get_AcStkAnalOn: WordBool; safecall;
    function Get_CurrencyVer: Smallint; safecall;
    function Get_EBusinessOn: WordBool; safecall;
    function Get_JobCostOn: WordBool; safecall;
    function Get_ModuleVer: Smallint; safecall;
    function Get_PaperlessOn: WordBool; safecall;
    function Get_RepWrtOn: WordBool; safecall;
    function Get_TelesalesOn: WordBool; safecall;
    function Get_VersionStr: WideString; safecall;
    property AcStkAnalOn: WordBool read Get_AcStkAnalOn;
    property CurrencyVer: Smallint read Get_CurrencyVer;
    property EBusinessOn: WordBool read Get_EBusinessOn;
    property JobCostOn: WordBool read Get_JobCostOn;
    property ModuleVer: Smallint read Get_ModuleVer;
    property PaperlessOn: WordBool read Get_PaperlessOn;
    property RepWrtOn: WordBool read Get_RepWrtOn;
    property TelesalesOn: WordBool read Get_TelesalesOn;
    property VersionStr: WideString read Get_VersionStr;
  end;

// *********************************************************************//
// DispIntf:  ICOMVersionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8512EC3D-E481-11D3-A990-0050DA3DF9AD}
// *********************************************************************//
  ICOMVersionDisp = dispinterface
    ['{8512EC3D-E481-11D3-A990-0050DA3DF9AD}']
    property AcStkAnalOn: WordBool readonly dispid 5;
    property CurrencyVer: Smallint readonly dispid 3;
    property EBusinessOn: WordBool readonly dispid 6;
    property JobCostOn: WordBool readonly dispid 7;
    property ModuleVer: Smallint readonly dispid 4;
    property PaperlessOn: WordBool readonly dispid 8;
    property RepWrtOn: WordBool readonly dispid 9;
    property TelesalesOn: WordBool readonly dispid 16;
    property VersionStr: WideString readonly dispid 1;
  end;

// *********************************************************************//
// Interface: ICOMSysFunc
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BEA7CCE0-21CC-11D4-A992-0050DA3DF9AD}
// *********************************************************************//
  ICOMSysFunc = interface(IDispatch)
    ['{BEA7CCE0-21CC-11D4-A992-0050DA3DF9AD}']
    function entMessageDlg(DialogType: TEntMsgDlgType; const Message: WideString; Buttons: Integer): TentMsgDlgReturn; safecall;
    function Get_hWnd: Integer; safecall;
    procedure entActivateClient(hWnd: Integer); safecall;
    property hWnd: Integer read Get_hWnd;
  end;

// *********************************************************************//
// DispIntf:  ICOMSysFuncDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BEA7CCE0-21CC-11D4-A992-0050DA3DF9AD}
// *********************************************************************//
  ICOMSysFuncDisp = dispinterface
    ['{BEA7CCE0-21CC-11D4-A992-0050DA3DF9AD}']
    function entMessageDlg(DialogType: TEntMsgDlgType; const Message: WideString; Buttons: Integer): TentMsgDlgReturn; dispid 1;
    property hWnd: Integer readonly dispid 2;
    procedure entActivateClient(hWnd: Integer); dispid 3;
  end;

// *********************************************************************//
// Interface: ICOMCustomisation2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {79F69B60-A01C-4049-8BC5-8E0B9F439EBB}
// *********************************************************************//
  ICOMCustomisation2 = interface(ICOMCustomisation)
    ['{79F69B60-A01C-4049-8BC5-8E0B9F439EBB}']
    procedure AddLabelCustomisation(WindowId: Integer; TextId: Integer; const Caption: WideString); safecall;
    procedure AddLabelCustomisationEx(WindowId: Integer; TextId: Integer; 
                                      const Caption: WideString; const FontName: WideString; 
                                      FontSize: Integer; FontBold: WordBool; FontItalic: WordBool; 
                                      FontUnderline: WordBool; FontStrikeOut: WordBool; 
                                      FontColorRed: Integer; FontColorGreen: Integer; 
                                      FontColorBlue: Integer); safecall;
  end;

// *********************************************************************//
// DispIntf:  ICOMCustomisation2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {79F69B60-A01C-4049-8BC5-8E0B9F439EBB}
// *********************************************************************//
  ICOMCustomisation2Disp = dispinterface
    ['{79F69B60-A01C-4049-8BC5-8E0B9F439EBB}']
    procedure AddLabelCustomisation(WindowId: Integer; TextId: Integer; const Caption: WideString); dispid 11;
    procedure AddLabelCustomisationEx(WindowId: Integer; TextId: Integer; 
                                      const Caption: WideString; const FontName: WideString; 
                                      FontSize: Integer; FontBold: WordBool; FontItalic: WordBool; 
                                      FontUnderline: WordBool; FontStrikeOut: WordBool; 
                                      FontColorRed: Integer; FontColorGreen: Integer; 
                                      FontColorBlue: Integer); dispid 12;
    property ClassVersion: WideString readonly dispid 1;
    property SystemSetup: ICOMSetup readonly dispid 2;
    property UserName: WideString readonly dispid 3;
    property VersionInfo: ICOMVersion readonly dispid 4;
    procedure AddAboutString(const AboutText: WideString); dispid 5;
    procedure EnableHook(WindowId: Integer; HandlerId: Integer); dispid 6;
    function entRound(Num: Double; Decs: Integer): Double; dispid 7;
    function entCalc_PcntPcnt(PAmount: Double; Pc1: Double; Pc2: Double; const PCh1: WideString; 
                              const PCh2: WideString): Double; dispid 8;
    function entGetTaxNo(const VCode: WideString): TVATIndex; dispid 9;
    property SysFunc: ICOMSysFunc readonly dispid 10;
  end;

// *********************************************************************//
// Interface: ICOMCustomer2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5425F9BC-99CB-4771-8F4D-2339CA554551}
// *********************************************************************//
  ICOMCustomer2 = interface(ICOMCustomer)
    ['{5425F9BC-99CB-4771-8F4D-2339CA554551}']
    function Get_acDefTagNo: Integer; safecall;
    procedure Set_acDefTagNo(Value: Integer); safecall;
    function Get_acDefSettleDisc: Double; safecall;
    procedure Set_acDefSettleDisc(Value: Double); safecall;
    function Get_acDefSettleDays: Integer; safecall;
    procedure Set_acDefSettleDays(Value: Integer); safecall;
    function Get_acDocDeliveryMode: Integer; safecall;
    procedure Set_acDocDeliveryMode(Value: Integer); safecall;
    function Get_acEbusPword: WideString; safecall;
    procedure Set_acEbusPword(const Value: WideString); safecall;
    function Get_acUseForEbus: Integer; safecall;
    procedure Set_acUseForEbus(Value: Integer); safecall;
    function Get_acWebLiveCatalog: WideString; safecall;
    procedure Set_acWebLiveCatalog(const Value: WideString); safecall;
    function Get_acWebPrevCatalog: WideString; safecall;
    procedure Set_acWebPrevCatalog(const Value: WideString); safecall;
    function Get_acInclusiveVATCode: WideString; safecall;
    procedure Set_acInclusiveVATCode(const Value: WideString); safecall;
    function Get_acLastOperator: WideString; safecall;
    procedure Set_acLastOperator(const Value: WideString); safecall;
    function Get_acSendHTML: WordBool; safecall;
    procedure Set_acSendHTML(Value: WordBool); safecall;
    function Get_acSendReader: WordBool; safecall;
    procedure Set_acSendReader(Value: WordBool); safecall;
    function Get_acZIPAttachments: Integer; safecall;
    procedure Set_acZIPAttachments(Value: Integer); safecall;
    function Get_acSSDDeliveryTerms: WideString; safecall;
    procedure Set_acSSDDeliveryTerms(const Value: WideString); safecall;
    function Get_acSSDModeOfTransport: Integer; safecall;
    procedure Set_acSSDModeOfTransport(Value: Integer); safecall;
    function Get_acTimeStamp: WideString; safecall;
    procedure Set_acTimeStamp(const Value: WideString); safecall;
    property acDefTagNo: Integer read Get_acDefTagNo write Set_acDefTagNo;
    property acDefSettleDisc: Double read Get_acDefSettleDisc write Set_acDefSettleDisc;
    property acDefSettleDays: Integer read Get_acDefSettleDays write Set_acDefSettleDays;
    property acDocDeliveryMode: Integer read Get_acDocDeliveryMode write Set_acDocDeliveryMode;
    property acEbusPword: WideString read Get_acEbusPword write Set_acEbusPword;
    property acUseForEbus: Integer read Get_acUseForEbus write Set_acUseForEbus;
    property acWebLiveCatalog: WideString read Get_acWebLiveCatalog write Set_acWebLiveCatalog;
    property acWebPrevCatalog: WideString read Get_acWebPrevCatalog write Set_acWebPrevCatalog;
    property acInclusiveVATCode: WideString read Get_acInclusiveVATCode write Set_acInclusiveVATCode;
    property acLastOperator: WideString read Get_acLastOperator write Set_acLastOperator;
    property acSendHTML: WordBool read Get_acSendHTML write Set_acSendHTML;
    property acSendReader: WordBool read Get_acSendReader write Set_acSendReader;
    property acZIPAttachments: Integer read Get_acZIPAttachments write Set_acZIPAttachments;
    property acSSDDeliveryTerms: WideString read Get_acSSDDeliveryTerms write Set_acSSDDeliveryTerms;
    property acSSDModeOfTransport: Integer read Get_acSSDModeOfTransport write Set_acSSDModeOfTransport;
    property acTimeStamp: WideString read Get_acTimeStamp write Set_acTimeStamp;
  end;

// *********************************************************************//
// DispIntf:  ICOMCustomer2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5425F9BC-99CB-4771-8F4D-2339CA554551}
// *********************************************************************//
  ICOMCustomer2Disp = dispinterface
    ['{5425F9BC-99CB-4771-8F4D-2339CA554551}']
    property acDefTagNo: Integer dispid 53;
    property acDefSettleDisc: Double dispid 54;
    property acDefSettleDays: Integer dispid 58;
    property acDocDeliveryMode: Integer dispid 59;
    property acEbusPword: WideString dispid 60;
    property acUseForEbus: Integer dispid 61;
    property acWebLiveCatalog: WideString dispid 62;
    property acWebPrevCatalog: WideString dispid 63;
    property acInclusiveVATCode: WideString dispid 64;
    property acLastOperator: WideString dispid 65;
    property acSendHTML: WordBool dispid 66;
    property acSendReader: WordBool dispid 67;
    property acZIPAttachments: Integer dispid 68;
    property acSSDDeliveryTerms: WideString dispid 69;
    property acSSDModeOfTransport: Integer dispid 70;
    property acTimeStamp: WideString dispid 71;
    property acCode: WideString dispid 1;
    property AccessRights: TRecordAccessStatus readonly dispid 2;
    property acCompany: WideString dispid 3;
    property acArea: WideString dispid 4;
    property acAccType: WideString dispid 5;
    property acStatementTo: WideString dispid 6;
    property acVATRegNo: WideString dispid 7;
    property acDelAddr: WordBool dispid 8;
    property acContact: WideString dispid 9;
    property acPhone: WideString dispid 10;
    property acFax: WideString dispid 11;
    property acTheirAcc: WideString dispid 12;
    property acOwnTradTerm: WordBool dispid 13;
    property acCurrency: Smallint dispid 14;
    property acVATCode: WideString dispid 15;
    property acPayTerms: Smallint dispid 16;
    property acCreditLimit: Double dispid 17;
    property acDiscount: Double dispid 18;
    property acCreditStatus: Smallint dispid 19;
    property acCostCentre: WideString dispid 20;
    property acDiscountBand: WideString dispid 21;
    property acDepartment: WideString dispid 22;
    property acECMember: WordBool dispid 23;
    property acStatement: WordBool dispid 24;
    property acSalesGL: Integer dispid 25;
    property acLocation: WideString dispid 26;
    property acAccStatus: TAccountStatus dispid 27;
    property acPayType: WideString dispid 28;
    property acBankSort: WideString dispid 29;
    property acBankAcc: WideString dispid 30;
    property acBankRef: WideString dispid 31;
    property acPhone2: WideString dispid 32;
    property acCOSGL: Integer dispid 33;
    property acDrCrGL: Integer dispid 34;
    property acLastUsed: WideString dispid 35;
    property acUserDef1: WideString dispid 36;
    property acUserDef2: WideString dispid 37;
    property acInvoiceTo: WideString dispid 38;
    property acSOPAutoWOff: WordBool dispid 39;
    property acFormSet: Smallint dispid 40;
    property acBookOrdVal: Double dispid 41;
    property acDirDebMode: Smallint dispid 42;
    property acAltCode: WideString dispid 43;
    property acPostCode: WideString dispid 44;
    property acUserDef3: WideString dispid 45;
    property acUserDef4: WideString dispid 46;
    property acEmailAddr: WideString dispid 47;
    property acCCStart: WideString dispid 48;
    property acCCEnd: WideString dispid 49;
    property acCCName: WideString dispid 50;
    property acCCNumber: WideString dispid 51;
    property acCCSwitch: WideString dispid 52;
    property acTradeTerms[Index: Integer]: WideString dispid 55;
    property acAddress[Index: Integer]: WideString dispid 56;
    property acDelAddress[Index: Integer]: WideString dispid 57;
  end;

// *********************************************************************//
// Interface: ICOMTransaction2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F195CC99-331C-4B48-90DE-04A1FA83C5D1}
// *********************************************************************//
  ICOMTransaction2 = interface(ICOMTransaction)
    ['{F195CC99-331C-4B48-90DE-04A1FA83C5D1}']
    function Get_thTagNo: Integer; safecall;
    procedure Set_thTagNo(Value: Integer); safecall;
    property thTagNo: Integer read Get_thTagNo write Set_thTagNo;
  end;

// *********************************************************************//
// DispIntf:  ICOMTransaction2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F195CC99-331C-4B48-90DE-04A1FA83C5D1}
// *********************************************************************//
  ICOMTransaction2Disp = dispinterface
    ['{F195CC99-331C-4B48-90DE-04A1FA83C5D1}']
    property thTagNo: Integer dispid 83;
    function LinkToCust: WordBool; dispid 1;
    property AccessRights: TRecordAccessStatus readonly dispid 2;
    property DataChanged: WordBool readonly dispid 3;
    property thRunNo: Integer dispid 4;
    property thAcCode: WideString dispid 5;
    property thNomAuto: WordBool dispid 6;
    property thOurRef: WideString dispid 7;
    property thFolioNum: Integer dispid 8;
    property thCurrency: Smallint dispid 9;
    property thYear: Smallint dispid 10;
    property thPeriod: Smallint dispid 11;
    property thDueDate: WideString dispid 12;
    property thVATPostDate: WideString dispid 13;
    property thTransDate: WideString dispid 14;
    property thCustSupp: WideString readonly dispid 15;
    property thCompanyRate: Double dispid 16;
    property thDailyRate: Double dispid 17;
    property thYourRef: WideString dispid 18;
    property thBatchLink: WideString dispid 19;
    property thAllocStat: WideString dispid 20;
    property thInvNetVal: Double readonly dispid 22;
    property thInvVat: Double readonly dispid 23;
    property thDiscSetl: Double dispid 24;
    property thDiscSetAm: Double dispid 25;
    property thDiscAmount: Double dispid 26;
    property thDiscDays: Smallint dispid 27;
    property thDiscTaken: WordBool dispid 28;
    property thSettled: Double dispid 29;
    property thAutoInc: Smallint dispid 30;
    property thNextAutoYr: Smallint dispid 31;
    property thNextAutoPr: Smallint dispid 32;
    property thTransNat: Smallint dispid 33;
    property thTransMode: Smallint dispid 34;
    property thRemitNo: WideString dispid 35;
    property thAutoIncBy: WideString dispid 36;
    property thHoldFlg: Smallint dispid 37;
    property thAuditFlg: WordBool dispid 38;
    property thTotalWeight: Double dispid 39;
    property thVariance: Double dispid 40;
    property thTotalOrdered: Double dispid 41;
    property thTotalReserved: Double dispid 42;
    property thTotalCost: Double dispid 43;
    property thTotalInvoiced: Double dispid 44;
    property thTransDesc: WideString dispid 45;
    property thAutoUntilDate: WideString dispid 46;
    property thExternal: WordBool dispid 47;
    property thPrinted: WordBool dispid 48;
    property thCurrVariance: Double dispid 49;
    property thCurrSettled: Double dispid 50;
    property thSettledVAT: Double dispid 51;
    property thVATClaimed: Double dispid 52;
    property thBatchPayGL: Integer dispid 53;
    property thAutoPost: WordBool dispid 54;
    property thManualVAT: WordBool dispid 55;
    property thSSDDelTerms: WideString dispid 56;
    property thUser: WideString dispid 57;
    property thNoLabels: Smallint dispid 58;
    property thTagged: WordBool dispid 59;
    property thPickRunNo: Integer dispid 60;
    property thOrdMatch: WordBool dispid 61;
    property thDeliveryNote: WideString dispid 62;
    property thVATCompanyRate: Double dispid 63;
    property thVATDailyRate: Double dispid 64;
    property thPostCompanyRate: Double dispid 65;
    property thPostDailyRate: Double dispid 66;
    property thPostDiscAm: Double dispid 67;
    property thPostedDiscTaken: WordBool dispid 68;
    property thDrCrGL: Integer dispid 69;
    property thJobCode: WideString dispid 70;
    property thJobAnal: WideString dispid 71;
    property thTotOrderOS: Double dispid 72;
    property thUser1: WideString dispid 73;
    property thUser2: WideString dispid 74;
    property thLastLetter: Smallint dispid 75;
    property thUnTagged: WordBool dispid 76;
    property thUser3: WideString dispid 77;
    property thUser4: WideString dispid 78;
    property thInvVATAnal[Index: TVATIndex]: Double dispid 21;
    property thDelAddr[Index: Integer]: WideString dispid 79;
    property thDocLSplit[Index: Integer]: Double dispid 80;
    property thInvDocHed: TDocTypes dispid 81;
    property thLines: ICOMTransactionLines readonly dispid 82;
  end;

// *********************************************************************//
// Interface: ICOMStock2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0BF450C2-79B5-4458-87D0-A8F623635EF8}
// *********************************************************************//
  ICOMStock2 = interface(ICOMStock)
    ['{0BF450C2-79B5-4458-87D0-A8F623635EF8}']
    function Get_stUseForEbus: WordBool; safecall;
    procedure Set_stUseForEbus(Value: WordBool); safecall;
    function Get_stWebLiveCatalog: WideString; safecall;
    procedure Set_stWebLiveCatalog(const Value: WideString); safecall;
    function Get_stWebPrevCatalog: WideString; safecall;
    procedure Set_stWebPrevCatalog(const Value: WideString); safecall;
    function Get_stWOPROLeadTime: Integer; safecall;
    procedure Set_stWOPROLeadTime(Value: Integer); safecall;
    function Get_stWOPAssemblyHours: Integer; safecall;
    procedure Set_stWOPAssemblyHours(Value: Integer); safecall;
    function Get_stWOPAssemblyMins: Integer; safecall;
    procedure Set_stWOPAssemblyMins(Value: Integer); safecall;
    function Get_stWOPAutoCalcTime: WordBool; safecall;
    procedure Set_stWOPAutoCalcTime(Value: WordBool); safecall;
    function Get_stWOPMinEconBuild: Double; safecall;
    procedure Set_stWOPMinEconBuild(Value: Double); safecall;
    function Get_stWOPIssuedWIPGL: Integer; safecall;
    procedure Set_stWOPIssuedWIPGL(Value: Integer); safecall;
    function Get_stQtyAllocWOR: Double; safecall;
    procedure Set_stQtyAllocWOR(Value: Double); safecall;
    function Get_stQtyIssuedWOR: Double; safecall;
    procedure Set_stQtyIssuedWOR(Value: Double); safecall;
    function Get_stQtyPickedWOR: Double; safecall;
    procedure Set_stQtyPickedWOR(Value: Double); safecall;
    property stUseForEbus: WordBool read Get_stUseForEbus write Set_stUseForEbus;
    property stWebLiveCatalog: WideString read Get_stWebLiveCatalog write Set_stWebLiveCatalog;
    property stWebPrevCatalog: WideString read Get_stWebPrevCatalog write Set_stWebPrevCatalog;
    property stWOPROLeadTime: Integer read Get_stWOPROLeadTime write Set_stWOPROLeadTime;
    property stWOPAssemblyHours: Integer read Get_stWOPAssemblyHours write Set_stWOPAssemblyHours;
    property stWOPAssemblyMins: Integer read Get_stWOPAssemblyMins write Set_stWOPAssemblyMins;
    property stWOPAutoCalcTime: WordBool read Get_stWOPAutoCalcTime write Set_stWOPAutoCalcTime;
    property stWOPMinEconBuild: Double read Get_stWOPMinEconBuild write Set_stWOPMinEconBuild;
    property stWOPIssuedWIPGL: Integer read Get_stWOPIssuedWIPGL write Set_stWOPIssuedWIPGL;
    property stQtyAllocWOR: Double read Get_stQtyAllocWOR write Set_stQtyAllocWOR;
    property stQtyIssuedWOR: Double read Get_stQtyIssuedWOR write Set_stQtyIssuedWOR;
    property stQtyPickedWOR: Double read Get_stQtyPickedWOR write Set_stQtyPickedWOR;
  end;

// *********************************************************************//
// DispIntf:  ICOMStock2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0BF450C2-79B5-4458-87D0-A8F623635EF8}
// *********************************************************************//
  ICOMStock2Disp = dispinterface
    ['{0BF450C2-79B5-4458-87D0-A8F623635EF8}']
    property stUseForEbus: WordBool dispid 84;
    property stWebLiveCatalog: WideString dispid 85;
    property stWebPrevCatalog: WideString dispid 86;
    property stWOPROLeadTime: Integer dispid 87;
    property stWOPAssemblyHours: Integer dispid 88;
    property stWOPAssemblyMins: Integer dispid 89;
    property stWOPAutoCalcTime: WordBool dispid 90;
    property stWOPMinEconBuild: Double dispid 91;
    property stWOPIssuedWIPGL: Integer dispid 92;
    property stQtyAllocWOR: Double dispid 93;
    property stQtyIssuedWOR: Double dispid 94;
    property stQtyPickedWOR: Double dispid 95;
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property stCode: WideString dispid 3;
    property stDesc[Index: Integer]: WideString dispid 81;
    property stAltCode: WideString dispid 4;
    property stSuppTemp: WideString dispid 5;
    property stSalesGL: Integer dispid 6;
    property stCOSGL: Integer dispid 7;
    property stPandLGL: Integer dispid 8;
    property stBalSheetGL: Integer dispid 9;
    property stWIPGL: Integer dispid 10;
    property stReOrderFlag: WordBool dispid 11;
    property stMinFlg: WordBool dispid 12;
    property stStockFolio: Integer dispid 13;
    property stStockCat: WideString dispid 14;
    property stStockType: WideString dispid 15;
    property stUnitOfStock: WideString dispid 16;
    property stUnitOfSale: WideString dispid 17;
    property stUnitOfPurch: WideString dispid 18;
    property stCostPriceCur: TCurrencyType dispid 19;
    property stCostPrice: Double dispid 20;
    property stSalesUnits: Double dispid 21;
    property stPurchUnits: Double dispid 22;
    property stVATCode: WideString dispid 23;
    property stCostCentre: WideString dispid 24;
    property stDepartment: WideString dispid 25;
    property stQtyInStock: Double dispid 26;
    property stQtyPosted: Double dispid 27;
    property stQtyAllocated: Double dispid 28;
    property stQtyOnOrder: Double dispid 29;
    property stQtyMin: Double dispid 30;
    property stQtyMax: Double dispid 31;
    property stReOrderQty: Double dispid 32;
    property stKitOnPurch: WordBool dispid 33;
    property stShowAsKit: WordBool dispid 34;
    property stCommodCode: WideString dispid 35;
    property stSaleUnWeight: Double dispid 36;
    property stPurchUnWeight: Double dispid 37;
    property stSSDUnit: WideString dispid 38;
    property stSSDSalesUnit: Double dispid 39;
    property stBinLocation: WideString dispid 40;
    property stStkFlg: WordBool dispid 41;
    property stCovPr: Smallint dispid 42;
    property stCovPrUnit: WideString dispid 43;
    property stCovMinPr: Smallint dispid 44;
    property stCovMinUnit: WideString dispid 45;
    property stSupplier: WideString dispid 46;
    property stQtyFreeze: Double dispid 47;
    property stCovSold: Double dispid 48;
    property stUseCover: WordBool dispid 49;
    property stCovMaxPr: Smallint dispid 50;
    property stCovMaxUnit: WideString dispid 51;
    property stReOrderCur: Smallint dispid 52;
    property stReOrderPrice: Double dispid 53;
    property stReOrderDate: WideString dispid 54;
    property stQtyTake: Double dispid 55;
    property stStkValType: WideString dispid 56;
    property stQtyPicked: Double dispid 57;
    property stLastUsed: WideString dispid 58;
    property stCalcPack: WordBool dispid 59;
    property stJobAnal: WideString dispid 60;
    property stStkUser1: WideString dispid 61;
    property stStkUser2: WideString dispid 62;
    property stBarCode: WideString dispid 63;
    property stROCostCentre: WideString dispid 64;
    property stRODepartment: WideString dispid 65;
    property stLocation: WideString dispid 66;
    property stPricePack: WordBool dispid 67;
    property stDPackQty: WordBool dispid 68;
    property stKitPrice: WordBool dispid 69;
    property stStkUser3: WideString dispid 70;
    property stStkUser4: WideString dispid 71;
    property stSerNoWAvg: Smallint dispid 72;
    property stStkSizeCol: Smallint readonly dispid 73;
    property stSSDDUplift: Double dispid 74;
    property stSSDCountry: WideString dispid 75;
    property stTimeChange: WideString readonly dispid 76;
    property stSVATIncFlg: WideString dispid 77;
    property stSSDAUpLift: Double dispid 78;
    property stLastOpo: WideString dispid 79;
    property stImageFile: WideString dispid 80;
    property stSaleBandsCur[const Index: WideString]: TCurrencyType dispid 82;
    property stSaleBandsPrice[const Index: WideString]: Double dispid 83;
  end;

// *********************************************************************//
// Interface: ICOMCustomisation3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0DE773A0-DB78-4A38-83B4-96AC09B2CC80}
// *********************************************************************//
  ICOMCustomisation3 = interface(ICOMCustomisation2)
    ['{0DE773A0-DB78-4A38-83B4-96AC09B2CC80}']
    function Get_UserProfile: ICOMUserProfile; safecall;
    function HookPointEnabled(WindowId: Integer; HandlerId: Integer): WordBool; safecall;
    property UserProfile: ICOMUserProfile read Get_UserProfile;
  end;

// *********************************************************************//
// DispIntf:  ICOMCustomisation3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0DE773A0-DB78-4A38-83B4-96AC09B2CC80}
// *********************************************************************//
  ICOMCustomisation3Disp = dispinterface
    ['{0DE773A0-DB78-4A38-83B4-96AC09B2CC80}']
    property UserProfile: ICOMUserProfile readonly dispid 13;
    function HookPointEnabled(WindowId: Integer; HandlerId: Integer): WordBool; dispid 14;
    procedure AddLabelCustomisation(WindowId: Integer; TextId: Integer; const Caption: WideString); dispid 11;
    procedure AddLabelCustomisationEx(WindowId: Integer; TextId: Integer; 
                                      const Caption: WideString; const FontName: WideString; 
                                      FontSize: Integer; FontBold: WordBool; FontItalic: WordBool; 
                                      FontUnderline: WordBool; FontStrikeOut: WordBool; 
                                      FontColorRed: Integer; FontColorGreen: Integer; 
                                      FontColorBlue: Integer); dispid 12;
    property ClassVersion: WideString readonly dispid 1;
    property SystemSetup: ICOMSetup readonly dispid 2;
    property UserName: WideString readonly dispid 3;
    property VersionInfo: ICOMVersion readonly dispid 4;
    procedure AddAboutString(const AboutText: WideString); dispid 5;
    procedure EnableHook(WindowId: Integer; HandlerId: Integer); dispid 6;
    function entRound(Num: Double; Decs: Integer): Double; dispid 7;
    function entCalc_PcntPcnt(PAmount: Double; Pc1: Double; Pc2: Double; const PCh1: WideString; 
                              const PCh2: WideString): Double; dispid 8;
    function entGetTaxNo(const VCode: WideString): TVATIndex; dispid 9;
    property SysFunc: ICOMSysFunc readonly dispid 10;
  end;

// *********************************************************************//
// Interface: ICOMUserProfile
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CB46487C-2F90-4FC5-9128-E33654FCE66F}
// *********************************************************************//
  ICOMUserProfile = interface(IDispatch)
    ['{CB46487C-2F90-4FC5-9128-E33654FCE66F}']
    function Get_upUserId: WideString; safecall;
    function Get_upName: WideString; safecall;
    function Get_upEmail: WideString; safecall;
    function Get_upLockOutMins: Integer; safecall;
    function Get_upDefSRICust: WideString; safecall;
    function Get_upDefPPISupp: WideString; safecall;
    function Get_upDefCostCentre: WideString; safecall;
    function Get_upDefDepartment: WideString; safecall;
    function Get_upDefCCDeptRule: Integer; safecall;
    function Get_upDefLocation: WideString; safecall;
    function Get_upDefLocRule: Integer; safecall;
    function Get_upDefSalesBankGL: Integer; safecall;
    function Get_upDefPurchBankGL: Integer; safecall;
    function Get_upMaxSalesAuth: Double; safecall;
    function Get_upMaxPurchAuth: Double; safecall;
    function Get_upReportPrinter: WideString; safecall;
    function Get_upFormPrinter: WideString; safecall;
    function Get_upPwordExpiryMode: Integer; safecall;
    function Get_upPwordExpiryDays: Integer; safecall;
    function Get_upPwordExpiryDate: WideString; safecall;
    function Get_upSecurityFlags(Index: Integer): Integer; safecall;
    property upUserId: WideString read Get_upUserId;
    property upName: WideString read Get_upName;
    property upEmail: WideString read Get_upEmail;
    property upLockOutMins: Integer read Get_upLockOutMins;
    property upDefSRICust: WideString read Get_upDefSRICust;
    property upDefPPISupp: WideString read Get_upDefPPISupp;
    property upDefCostCentre: WideString read Get_upDefCostCentre;
    property upDefDepartment: WideString read Get_upDefDepartment;
    property upDefCCDeptRule: Integer read Get_upDefCCDeptRule;
    property upDefLocation: WideString read Get_upDefLocation;
    property upDefLocRule: Integer read Get_upDefLocRule;
    property upDefSalesBankGL: Integer read Get_upDefSalesBankGL;
    property upDefPurchBankGL: Integer read Get_upDefPurchBankGL;
    property upMaxSalesAuth: Double read Get_upMaxSalesAuth;
    property upMaxPurchAuth: Double read Get_upMaxPurchAuth;
    property upReportPrinter: WideString read Get_upReportPrinter;
    property upFormPrinter: WideString read Get_upFormPrinter;
    property upPwordExpiryMode: Integer read Get_upPwordExpiryMode;
    property upPwordExpiryDays: Integer read Get_upPwordExpiryDays;
    property upPwordExpiryDate: WideString read Get_upPwordExpiryDate;
    property upSecurityFlags[Index: Integer]: Integer read Get_upSecurityFlags;
  end;

// *********************************************************************//
// DispIntf:  ICOMUserProfileDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CB46487C-2F90-4FC5-9128-E33654FCE66F}
// *********************************************************************//
  ICOMUserProfileDisp = dispinterface
    ['{CB46487C-2F90-4FC5-9128-E33654FCE66F}']
    property upUserId: WideString readonly dispid 2;
    property upName: WideString readonly dispid 3;
    property upEmail: WideString readonly dispid 4;
    property upLockOutMins: Integer readonly dispid 5;
    property upDefSRICust: WideString readonly dispid 6;
    property upDefPPISupp: WideString readonly dispid 7;
    property upDefCostCentre: WideString readonly dispid 8;
    property upDefDepartment: WideString readonly dispid 9;
    property upDefCCDeptRule: Integer readonly dispid 10;
    property upDefLocation: WideString readonly dispid 11;
    property upDefLocRule: Integer readonly dispid 12;
    property upDefSalesBankGL: Integer readonly dispid 13;
    property upDefPurchBankGL: Integer readonly dispid 14;
    property upMaxSalesAuth: Double readonly dispid 15;
    property upMaxPurchAuth: Double readonly dispid 16;
    property upReportPrinter: WideString readonly dispid 17;
    property upFormPrinter: WideString readonly dispid 18;
    property upPwordExpiryMode: Integer readonly dispid 19;
    property upPwordExpiryDays: Integer readonly dispid 20;
    property upPwordExpiryDate: WideString readonly dispid 21;
    property upSecurityFlags[Index: Integer]: Integer readonly dispid 22;
  end;

// *********************************************************************//
// Interface: ICOMSetupUserFields2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {662955BA-B1A9-4B89-99BE-6156FFDEF007}
// *********************************************************************//
  ICOMSetupUserFields2 = interface(ICOMSetupUserFields)
    ['{662955BA-B1A9-4B89-99BE-6156FFDEF007}']
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
    property ufCustDesc[FieldNo: Integer]: WideString read Get_ufCustDesc;
    property ufSuppDesc[FieldNo: Integer]: WideString read Get_ufSuppDesc;
    property ufLineTypeDesc[FieldNo: Integer]: WideString read Get_ufLineTypeDesc;
    property ufSINDesc[FieldNo: Integer]: WideString read Get_ufSINDesc;
    property ufSINEnabled[FieldNo: Integer]: WordBool read Get_ufSINEnabled;
    property ufSINLineDesc[FieldNo: Integer]: WideString read Get_ufSINLineDesc;
    property ufSINLineEnabled[FieldNo: Integer]: WordBool read Get_ufSINLineEnabled;
    property ufSRCDesc[FieldNo: Integer]: WideString read Get_ufSRCDesc;
    property ufSRCEnabled[FieldNo: Integer]: WordBool read Get_ufSRCEnabled;
    property ufSRCLineDesc[FieldNo: Integer]: WideString read Get_ufSRCLineDesc;
    property ufSRCLineEnabled[FieldNo: Integer]: WordBool read Get_ufSRCLineEnabled;
    property ufSQUDesc[FieldNo: Integer]: WideString read Get_ufSQUDesc;
    property ufSQUEnabled[FieldNo: Integer]: WordBool read Get_ufSQUEnabled;
    property ufSQULineDesc[FieldNo: Integer]: WideString read Get_ufSQULineDesc;
    property ufSQULineEnabled[FieldNo: Integer]: WordBool read Get_ufSQULineEnabled;
    property ufSORDesc[FieldNo: Integer]: WideString read Get_ufSORDesc;
    property ufSOREnabled[FieldNo: Integer]: WordBool read Get_ufSOREnabled;
    property ufSORLineDesc[FieldNo: Integer]: WideString read Get_ufSORLineDesc;
    property ufSORLineEnabled[FieldNo: Integer]: WordBool read Get_ufSORLineEnabled;
    property ufPINDesc[FieldNo: Integer]: WideString read Get_ufPINDesc;
    property ufPINEnabled[FieldNo: Integer]: WordBool read Get_ufPINEnabled;
    property ufPINLineDesc[FieldNo: Integer]: WideString read Get_ufPINLineDesc;
    property ufPINLineEnabled[FieldNo: Integer]: WordBool read Get_ufPINLineEnabled;
    property ufPPYDesc[FieldNo: Integer]: WideString read Get_ufPPYDesc;
    property ufPPYEnabled[FieldNo: Integer]: WordBool read Get_ufPPYEnabled;
    property ufPPYLineDesc[FieldNo: Integer]: WideString read Get_ufPPYLineDesc;
    property ufPPYLineEnabled[FieldNo: Integer]: WordBool read Get_ufPPYLineEnabled;
    property ufPQUDesc[FieldNo: Integer]: WideString read Get_ufPQUDesc;
    property ufPQUEnabled[FieldNo: Integer]: WordBool read Get_ufPQUEnabled;
    property ufPQULineDesc[FieldNo: Integer]: WideString read Get_ufPQULineDesc;
    property ufPQULineEnabled[FieldNo: Integer]: WordBool read Get_ufPQULineEnabled;
    property ufPORDesc[FieldNo: Integer]: WideString read Get_ufPORDesc;
    property ufPOREnabled[FieldNo: Integer]: WordBool read Get_ufPOREnabled;
    property ufPORLineDesc[FieldNo: Integer]: WideString read Get_ufPORLineDesc;
    property ufPORLineEnabled[FieldNo: Integer]: WordBool read Get_ufPORLineEnabled;
    property ufNOMDesc[FieldNo: Integer]: WideString read Get_ufNOMDesc;
    property ufNOMEnabled[FieldNo: Integer]: WordBool read Get_ufNOMEnabled;
    property ufNOMLineDesc[FieldNo: Integer]: WideString read Get_ufNOMLineDesc;
    property ufNOMLineEnabled[FieldNo: Integer]: WordBool read Get_ufNOMLineEnabled;
    property ufStockDesc[FieldNo: Integer]: WideString read Get_ufStockDesc;
    property ufADJDesc[FieldNo: Integer]: WideString read Get_ufADJDesc;
    property ufADJEnabled[FieldNo: Integer]: WordBool read Get_ufADJEnabled;
    property ufADJLineDesc[FieldNo: Integer]: WideString read Get_ufADJLineDesc;
    property ufADJLineEnabled[FieldNo: Integer]: WordBool read Get_ufADJLineEnabled;
    property ufWORDesc[FieldNo: Integer]: WideString read Get_ufWORDesc;
    property ufWOREnabled[FieldNo: Integer]: WordBool read Get_ufWOREnabled;
    property ufWORLineDesc[FieldNo: Integer]: WideString read Get_ufWORLineDesc;
    property ufWORLineEnabled[FieldNo: Integer]: WordBool read Get_ufWORLineEnabled;
    property ufJobDesc[FieldNo: Integer]: WideString read Get_ufJobDesc;
    property ufEmployeeDesc[FieldNo: Integer]: WideString read Get_ufEmployeeDesc;
    property ufTSHDesc[FieldNo: Integer]: WideString read Get_ufTSHDesc;
    property ufTSHEnabled[FieldNo: Integer]: WordBool read Get_ufTSHEnabled;
    property ufTSHLineDesc[FieldNo: Integer]: WideString read Get_ufTSHLineDesc;
    property ufTSHLineEnabled[FieldNo: Integer]: WordBool read Get_ufTSHLineEnabled;
  end;

// *********************************************************************//
// DispIntf:  ICOMSetupUserFields2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {662955BA-B1A9-4B89-99BE-6156FFDEF007}
// *********************************************************************//
  ICOMSetupUserFields2Disp = dispinterface
    ['{662955BA-B1A9-4B89-99BE-6156FFDEF007}']
    property ufCustDesc[FieldNo: Integer]: WideString readonly dispid 19;
    property ufSuppDesc[FieldNo: Integer]: WideString readonly dispid 73;
    property ufLineTypeDesc[FieldNo: Integer]: WideString readonly dispid 74;
    property ufSINDesc[FieldNo: Integer]: WideString readonly dispid 75;
    property ufSINEnabled[FieldNo: Integer]: WordBool readonly dispid 76;
    property ufSINLineDesc[FieldNo: Integer]: WideString readonly dispid 77;
    property ufSINLineEnabled[FieldNo: Integer]: WordBool readonly dispid 78;
    property ufSRCDesc[FieldNo: Integer]: WideString readonly dispid 79;
    property ufSRCEnabled[FieldNo: Integer]: WordBool readonly dispid 80;
    property ufSRCLineDesc[FieldNo: Integer]: WideString readonly dispid 28;
    property ufSRCLineEnabled[FieldNo: Integer]: WordBool readonly dispid 29;
    property ufSQUDesc[FieldNo: Integer]: WideString readonly dispid 30;
    property ufSQUEnabled[FieldNo: Integer]: WordBool readonly dispid 31;
    property ufSQULineDesc[FieldNo: Integer]: WideString readonly dispid 32;
    property ufSQULineEnabled[FieldNo: Integer]: WordBool readonly dispid 33;
    property ufSORDesc[FieldNo: Integer]: WideString readonly dispid 34;
    property ufSOREnabled[FieldNo: Integer]: WordBool readonly dispid 35;
    property ufSORLineDesc[FieldNo: Integer]: WideString readonly dispid 36;
    property ufSORLineEnabled[FieldNo: Integer]: WordBool readonly dispid 37;
    property ufPINDesc[FieldNo: Integer]: WideString readonly dispid 38;
    property ufPINEnabled[FieldNo: Integer]: WordBool readonly dispid 39;
    property ufPINLineDesc[FieldNo: Integer]: WideString readonly dispid 40;
    property ufPINLineEnabled[FieldNo: Integer]: WordBool readonly dispid 41;
    property ufPPYDesc[FieldNo: Integer]: WideString readonly dispid 42;
    property ufPPYEnabled[FieldNo: Integer]: WordBool readonly dispid 43;
    property ufPPYLineDesc[FieldNo: Integer]: WideString readonly dispid 44;
    property ufPPYLineEnabled[FieldNo: Integer]: WordBool readonly dispid 45;
    property ufPQUDesc[FieldNo: Integer]: WideString readonly dispid 46;
    property ufPQUEnabled[FieldNo: Integer]: WordBool readonly dispid 47;
    property ufPQULineDesc[FieldNo: Integer]: WideString readonly dispid 48;
    property ufPQULineEnabled[FieldNo: Integer]: WordBool readonly dispid 49;
    property ufPORDesc[FieldNo: Integer]: WideString readonly dispid 50;
    property ufPOREnabled[FieldNo: Integer]: WordBool readonly dispid 51;
    property ufPORLineDesc[FieldNo: Integer]: WideString readonly dispid 52;
    property ufPORLineEnabled[FieldNo: Integer]: WordBool readonly dispid 53;
    property ufNOMDesc[FieldNo: Integer]: WideString readonly dispid 54;
    property ufNOMEnabled[FieldNo: Integer]: WordBool readonly dispid 55;
    property ufNOMLineDesc[FieldNo: Integer]: WideString readonly dispid 56;
    property ufNOMLineEnabled[FieldNo: Integer]: WordBool readonly dispid 57;
    property ufStockDesc[FieldNo: Integer]: WideString readonly dispid 58;
    property ufADJDesc[FieldNo: Integer]: WideString readonly dispid 59;
    property ufADJEnabled[FieldNo: Integer]: WordBool readonly dispid 60;
    property ufADJLineDesc[FieldNo: Integer]: WideString readonly dispid 61;
    property ufADJLineEnabled[FieldNo: Integer]: WordBool readonly dispid 62;
    property ufWORDesc[FieldNo: Integer]: WideString readonly dispid 63;
    property ufWOREnabled[FieldNo: Integer]: WordBool readonly dispid 64;
    property ufWORLineDesc[FieldNo: Integer]: WideString readonly dispid 65;
    property ufWORLineEnabled[FieldNo: Integer]: WordBool readonly dispid 66;
    property ufJobDesc[FieldNo: Integer]: WideString readonly dispid 67;
    property ufEmployeeDesc[FieldNo: Integer]: WideString readonly dispid 68;
    property ufTSHDesc[FieldNo: Integer]: WideString readonly dispid 69;
    property ufTSHEnabled[FieldNo: Integer]: WordBool readonly dispid 70;
    property ufTSHLineDesc[FieldNo: Integer]: WideString readonly dispid 71;
    property ufTSHLineEnabled[FieldNo: Integer]: WordBool readonly dispid 72;
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
  end;

// *********************************************************************//
// Interface: ICOMSetupPaperless
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {32A082D2-6E09-43F1-8CBC-59C0C7999891}
// *********************************************************************//
  ICOMSetupPaperless = interface(IDispatch)
    ['{32A082D2-6E09-43F1-8CBC-59C0C7999891}']
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
    property ssYourEmailName: WideString read Get_ssYourEmailName;
    property ssYourEmailAddress: WideString read Get_ssYourEmailAddress;
    property ssSMTPServer: WideString read Get_ssSMTPServer;
    property ssDefaultEmailPriority: Integer read Get_ssDefaultEmailPriority;
    property ssEmailUseMAPI: WordBool read Get_ssEmailUseMAPI;
    property ssAttachMethod: Integer read Get_ssAttachMethod;
    property ssAttachPrinter: WideString read Get_ssAttachPrinter;
    property ssFaxFromName: WideString read Get_ssFaxFromName;
    property ssFaxFromTelNo: WideString read Get_ssFaxFromTelNo;
    property ssFaxPrinter: WideString read Get_ssFaxPrinter;
    property ssFaxInterfacePath: WideString read Get_ssFaxInterfacePath;
    property ssFaxUsing: Integer read Get_ssFaxUsing;
  end;

// *********************************************************************//
// DispIntf:  ICOMSetupPaperlessDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {32A082D2-6E09-43F1-8CBC-59C0C7999891}
// *********************************************************************//
  ICOMSetupPaperlessDisp = dispinterface
    ['{32A082D2-6E09-43F1-8CBC-59C0C7999891}']
    property ssYourEmailName: WideString readonly dispid 1;
    property ssYourEmailAddress: WideString readonly dispid 2;
    property ssSMTPServer: WideString readonly dispid 3;
    property ssDefaultEmailPriority: Integer readonly dispid 4;
    property ssEmailUseMAPI: WordBool readonly dispid 5;
    property ssAttachMethod: Integer readonly dispid 6;
    property ssAttachPrinter: WideString readonly dispid 7;
    property ssFaxFromName: WideString readonly dispid 8;
    property ssFaxFromTelNo: WideString readonly dispid 9;
    property ssFaxPrinter: WideString readonly dispid 10;
    property ssFaxInterfacePath: WideString readonly dispid 11;
    property ssFaxUsing: Integer readonly dispid 12;
  end;

// *********************************************************************//
// Interface: ICOMSetup2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {917B195D-6DF6-47B9-9E30-BD205FE7D09A}
// *********************************************************************//
  ICOMSetup2 = interface(ICOMSetup)
    ['{917B195D-6DF6-47B9-9E30-BD205FE7D09A}']
    function Get_ssWORAllocStockOnPick: WordBool; safecall;
    function Get_ssWOPDisableWIP: WordBool; safecall;
    function Get_ssWORCopyStkNotes: Integer; safecall;
    function Get_ssPaperless: ICOMSetupPaperless; safecall;
    property ssWORAllocStockOnPick: WordBool read Get_ssWORAllocStockOnPick;
    property ssWOPDisableWIP: WordBool read Get_ssWOPDisableWIP;
    property ssWORCopyStkNotes: Integer read Get_ssWORCopyStkNotes;
    property ssPaperless: ICOMSetupPaperless read Get_ssPaperless;
  end;

// *********************************************************************//
// DispIntf:  ICOMSetup2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {917B195D-6DF6-47B9-9E30-BD205FE7D09A}
// *********************************************************************//
  ICOMSetup2Disp = dispinterface
    ['{917B195D-6DF6-47B9-9E30-BD205FE7D09A}']
    property ssWORAllocStockOnPick: WordBool readonly dispid 103;
    property ssWOPDisableWIP: WordBool readonly dispid 104;
    property ssWORCopyStkNotes: Integer readonly dispid 105;
    property ssPaperless: ICOMSetupPaperless readonly dispid 106;
    property ssPrinYr: Smallint readonly dispid 1;
    property ssUserName: WideString readonly dispid 2;
    property ssAuditYr: Smallint readonly dispid 3;
    property ssManROCP: WordBool readonly dispid 4;
    property ssVATCurr: Smallint readonly dispid 5;
    property ssNoCosDec: Smallint readonly dispid 6;
    property ssCurrBase: Smallint readonly dispid 7;
    property ssShowStkGP: WordBool readonly dispid 8;
    property ssAutoValStk: WordBool readonly dispid 9;
    property ssDelPickOnly: WordBool readonly dispid 10;
    property ssUseMLoc: WordBool readonly dispid 11;
    property ssEditSinSer: WordBool readonly dispid 12;
    property ssWarnYRef: WordBool readonly dispid 13;
    property ssUseLocDel: WordBool readonly dispid 14;
    property ssPostCCGL: WordBool readonly dispid 15;
    property ssAlTolVal: Double readonly dispid 16;
    property ssAlTolMode: Smallint readonly dispid 17;
    property ssDebtLMode: Smallint readonly dispid 18;
    property ssAutoGenVar: WordBool readonly dispid 19;
    property ssAutoGenDisc: WordBool readonly dispid 20;
    property ssUSRCntryCode: WideString readonly dispid 21;
    property ssNoNetDec: Smallint readonly dispid 22;
    property ssNoInvLines: Smallint readonly dispid 23;
    property ssWksODue: Smallint readonly dispid 24;
    property ssCPr: Smallint readonly dispid 25;
    property ssCYr: Smallint readonly dispid 26;
    property ssTradeTerm: WordBool readonly dispid 27;
    property ssStaSepCr: WordBool readonly dispid 28;
    property ssStaAgeMthd: Smallint readonly dispid 29;
    property ssStaUIDate: WordBool readonly dispid 30;
    property ssQUAllocFlg: WordBool readonly dispid 31;
    property ssDeadBOM: WordBool readonly dispid 32;
    property ssAuthMode: WideString readonly dispid 33;
    property ssIntraStat: WordBool readonly dispid 34;
    property ssAnalStkDesc: WordBool readonly dispid 35;
    property ssAutoStkVal: WideString readonly dispid 36;
    property ssAutoBillUp: WordBool readonly dispid 37;
    property ssAutoCQNo: WordBool readonly dispid 38;
    property ssIncNotDue: WordBool readonly dispid 39;
    property ssUseBatchTot: WordBool readonly dispid 40;
    property ssUseStock: WordBool readonly dispid 41;
    property ssAutoNotes: WordBool readonly dispid 42;
    property ssHideMenuOpt: WordBool readonly dispid 43;
    property ssUseCCDep: WordBool readonly dispid 44;
    property ssNoHoldDisc: WordBool readonly dispid 45;
    property ssAutoPrCalc: WordBool readonly dispid 46;
    property ssStopBadDr: WordBool readonly dispid 47;
    property ssUsePayIn: WordBool readonly dispid 48;
    property ssUsePasswords: WordBool readonly dispid 49;
    property ssPrintReciept: WordBool readonly dispid 50;
    property ssExternCust: WordBool readonly dispid 51;
    property ssNoQtyDec: Smallint readonly dispid 52;
    property ssExternSIN: WordBool readonly dispid 53;
    property ssPrevPrOff: WordBool readonly dispid 54;
    property ssDefPcDisc: WordBool readonly dispid 55;
    property ssTradCodeNum: WordBool readonly dispid 56;
    property ssUpBalOnPost: WordBool readonly dispid 57;
    property ssShowInvDisc: WordBool readonly dispid 58;
    property ssSepDiscounts: WordBool readonly dispid 59;
    property ssUseCreditChk: WordBool readonly dispid 60;
    property ssUseCRLimitChk: WordBool readonly dispid 61;
    property ssAutoClearPay: WordBool readonly dispid 62;
    property ssTotalConv: WideString readonly dispid 63;
    property ssDispPrAsMonths: WordBool readonly dispid 64;
    property ssDirectCust: WideString readonly dispid 65;
    property ssDirectSupp: WideString readonly dispid 66;
    property ssGLPayFrom: Integer readonly dispid 67;
    property ssGLPayToo: Integer readonly dispid 68;
    property ssSettleDisc: Double readonly dispid 69;
    property ssSettleDays: Smallint readonly dispid 70;
    property ssNeedBMUp: WordBool readonly dispid 71;
    property ssInpPack: WordBool readonly dispid 72;
    property ssVATCode: WideString readonly dispid 73;
    property ssPayTerms: Smallint readonly dispid 74;
    property ssStaAgeInt: Smallint readonly dispid 75;
    property ssQuoOwnDate: WordBool readonly dispid 76;
    property ssFreeExAll: WordBool readonly dispid 77;
    property ssDirOwnCount: WordBool readonly dispid 78;
    property ssStaShowOS: WordBool readonly dispid 79;
    property ssLiveCredS: WordBool readonly dispid 80;
    property ssBatchPPY: WordBool readonly dispid 81;
    property ssWarnJC: WordBool readonly dispid 82;
    property ssDefBankGL: Integer readonly dispid 83;
    property ssUseDefBank: WordBool readonly dispid 84;
    property ssMonWk1: WideString readonly dispid 85;
    property ssAuditDate: WideString readonly dispid 86;
    property ssUserSort: WideString readonly dispid 87;
    property ssUserAcc: WideString readonly dispid 88;
    property ssUserRef: WideString readonly dispid 89;
    property ssUserBank: WideString readonly dispid 90;
    property ssLastExpFolio: Integer readonly dispid 91;
    property ssDetailTel: WideString readonly dispid 92;
    property ssDetailFax: WideString readonly dispid 93;
    property ssUserVATReg: WideString readonly dispid 94;
    property ssDataPath: WideString readonly dispid 95;
    property ssDetailAddr[Index: Integer]: WideString readonly dispid 96;
    property ssGLCtrlCodes[Index: TNomCtrlType]: Integer readonly dispid 97;
    property ssDebtChaseDays[Index: Integer]: Smallint readonly dispid 98;
    property ssTermsofTrade[Index: TTermsIndex]: WideString readonly dispid 99;
    property ssCurrency[Index: TCurrencyType]: ICOMSetupCurrency readonly dispid 100;
    property ssVATRates[Index: TVATIndex]: ICOMSetupVAT readonly dispid 101;
    property ssUserFields: ICOMSetupUserFields readonly dispid 102;
  end;

// *********************************************************************//
// Interface: ICOMCustomisation4
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E4F9B3BD-33F1-499B-B540-28A168824B67}
// *********************************************************************//
  ICOMCustomisation4 = interface(ICOMCustomisation3)
    ['{E4F9B3BD-33F1-499B-B540-28A168824B67}']
    function Get_SystemSetup2: ICOMSetup3; safecall;
    property SystemSetup2: ICOMSetup3 read Get_SystemSetup2;
  end;

// *********************************************************************//
// DispIntf:  ICOMCustomisation4Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E4F9B3BD-33F1-499B-B540-28A168824B67}
// *********************************************************************//
  ICOMCustomisation4Disp = dispinterface
    ['{E4F9B3BD-33F1-499B-B540-28A168824B67}']
    property SystemSetup2: ICOMSetup3 readonly dispid 15;
    property UserProfile: ICOMUserProfile readonly dispid 13;
    function HookPointEnabled(WindowId: Integer; HandlerId: Integer): WordBool; dispid 14;
    procedure AddLabelCustomisation(WindowId: Integer; TextId: Integer; const Caption: WideString); dispid 11;
    procedure AddLabelCustomisationEx(WindowId: Integer; TextId: Integer; 
                                      const Caption: WideString; const FontName: WideString; 
                                      FontSize: Integer; FontBold: WordBool; FontItalic: WordBool; 
                                      FontUnderline: WordBool; FontStrikeOut: WordBool; 
                                      FontColorRed: Integer; FontColorGreen: Integer; 
                                      FontColorBlue: Integer); dispid 12;
    property ClassVersion: WideString readonly dispid 1;
    property SystemSetup: ICOMSetup readonly dispid 2;
    property UserName: WideString readonly dispid 3;
    property VersionInfo: ICOMVersion readonly dispid 4;
    procedure AddAboutString(const AboutText: WideString); dispid 5;
    procedure EnableHook(WindowId: Integer; HandlerId: Integer); dispid 6;
    function entRound(Num: Double; Decs: Integer): Double; dispid 7;
    function entCalc_PcntPcnt(PAmount: Double; Pc1: Double; Pc2: Double; const PCh1: WideString; 
                              const PCh2: WideString): Double; dispid 8;
    function entGetTaxNo(const VCode: WideString): TVATIndex; dispid 9;
    property SysFunc: ICOMSysFunc readonly dispid 10;
  end;

// *********************************************************************//
// Interface: ICOMSetup3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A452C452-C5BD-4CDF-AB9E-BCF1155CDB56}
// *********************************************************************//
  ICOMSetup3 = interface(ICOMSetup2)
    ['{A452C452-C5BD-4CDF-AB9E-BCF1155CDB56}']
    function Get_ssCISSetup: ICOMSetupCIS; safecall;
    function Get_ssJobCosting: ICOMSetupJobCosting; safecall;
    property ssCISSetup: ICOMSetupCIS read Get_ssCISSetup;
    property ssJobCosting: ICOMSetupJobCosting read Get_ssJobCosting;
  end;

// *********************************************************************//
// DispIntf:  ICOMSetup3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A452C452-C5BD-4CDF-AB9E-BCF1155CDB56}
// *********************************************************************//
  ICOMSetup3Disp = dispinterface
    ['{A452C452-C5BD-4CDF-AB9E-BCF1155CDB56}']
    property ssCISSetup: ICOMSetupCIS readonly dispid 107;
    property ssJobCosting: ICOMSetupJobCosting readonly dispid 108;
    property ssWORAllocStockOnPick: WordBool readonly dispid 103;
    property ssWOPDisableWIP: WordBool readonly dispid 104;
    property ssWORCopyStkNotes: Integer readonly dispid 105;
    property ssPaperless: ICOMSetupPaperless readonly dispid 106;
    property ssPrinYr: Smallint readonly dispid 1;
    property ssUserName: WideString readonly dispid 2;
    property ssAuditYr: Smallint readonly dispid 3;
    property ssManROCP: WordBool readonly dispid 4;
    property ssVATCurr: Smallint readonly dispid 5;
    property ssNoCosDec: Smallint readonly dispid 6;
    property ssCurrBase: Smallint readonly dispid 7;
    property ssShowStkGP: WordBool readonly dispid 8;
    property ssAutoValStk: WordBool readonly dispid 9;
    property ssDelPickOnly: WordBool readonly dispid 10;
    property ssUseMLoc: WordBool readonly dispid 11;
    property ssEditSinSer: WordBool readonly dispid 12;
    property ssWarnYRef: WordBool readonly dispid 13;
    property ssUseLocDel: WordBool readonly dispid 14;
    property ssPostCCGL: WordBool readonly dispid 15;
    property ssAlTolVal: Double readonly dispid 16;
    property ssAlTolMode: Smallint readonly dispid 17;
    property ssDebtLMode: Smallint readonly dispid 18;
    property ssAutoGenVar: WordBool readonly dispid 19;
    property ssAutoGenDisc: WordBool readonly dispid 20;
    property ssUSRCntryCode: WideString readonly dispid 21;
    property ssNoNetDec: Smallint readonly dispid 22;
    property ssNoInvLines: Smallint readonly dispid 23;
    property ssWksODue: Smallint readonly dispid 24;
    property ssCPr: Smallint readonly dispid 25;
    property ssCYr: Smallint readonly dispid 26;
    property ssTradeTerm: WordBool readonly dispid 27;
    property ssStaSepCr: WordBool readonly dispid 28;
    property ssStaAgeMthd: Smallint readonly dispid 29;
    property ssStaUIDate: WordBool readonly dispid 30;
    property ssQUAllocFlg: WordBool readonly dispid 31;
    property ssDeadBOM: WordBool readonly dispid 32;
    property ssAuthMode: WideString readonly dispid 33;
    property ssIntraStat: WordBool readonly dispid 34;
    property ssAnalStkDesc: WordBool readonly dispid 35;
    property ssAutoStkVal: WideString readonly dispid 36;
    property ssAutoBillUp: WordBool readonly dispid 37;
    property ssAutoCQNo: WordBool readonly dispid 38;
    property ssIncNotDue: WordBool readonly dispid 39;
    property ssUseBatchTot: WordBool readonly dispid 40;
    property ssUseStock: WordBool readonly dispid 41;
    property ssAutoNotes: WordBool readonly dispid 42;
    property ssHideMenuOpt: WordBool readonly dispid 43;
    property ssUseCCDep: WordBool readonly dispid 44;
    property ssNoHoldDisc: WordBool readonly dispid 45;
    property ssAutoPrCalc: WordBool readonly dispid 46;
    property ssStopBadDr: WordBool readonly dispid 47;
    property ssUsePayIn: WordBool readonly dispid 48;
    property ssUsePasswords: WordBool readonly dispid 49;
    property ssPrintReciept: WordBool readonly dispid 50;
    property ssExternCust: WordBool readonly dispid 51;
    property ssNoQtyDec: Smallint readonly dispid 52;
    property ssExternSIN: WordBool readonly dispid 53;
    property ssPrevPrOff: WordBool readonly dispid 54;
    property ssDefPcDisc: WordBool readonly dispid 55;
    property ssTradCodeNum: WordBool readonly dispid 56;
    property ssUpBalOnPost: WordBool readonly dispid 57;
    property ssShowInvDisc: WordBool readonly dispid 58;
    property ssSepDiscounts: WordBool readonly dispid 59;
    property ssUseCreditChk: WordBool readonly dispid 60;
    property ssUseCRLimitChk: WordBool readonly dispid 61;
    property ssAutoClearPay: WordBool readonly dispid 62;
    property ssTotalConv: WideString readonly dispid 63;
    property ssDispPrAsMonths: WordBool readonly dispid 64;
    property ssDirectCust: WideString readonly dispid 65;
    property ssDirectSupp: WideString readonly dispid 66;
    property ssGLPayFrom: Integer readonly dispid 67;
    property ssGLPayToo: Integer readonly dispid 68;
    property ssSettleDisc: Double readonly dispid 69;
    property ssSettleDays: Smallint readonly dispid 70;
    property ssNeedBMUp: WordBool readonly dispid 71;
    property ssInpPack: WordBool readonly dispid 72;
    property ssVATCode: WideString readonly dispid 73;
    property ssPayTerms: Smallint readonly dispid 74;
    property ssStaAgeInt: Smallint readonly dispid 75;
    property ssQuoOwnDate: WordBool readonly dispid 76;
    property ssFreeExAll: WordBool readonly dispid 77;
    property ssDirOwnCount: WordBool readonly dispid 78;
    property ssStaShowOS: WordBool readonly dispid 79;
    property ssLiveCredS: WordBool readonly dispid 80;
    property ssBatchPPY: WordBool readonly dispid 81;
    property ssWarnJC: WordBool readonly dispid 82;
    property ssDefBankGL: Integer readonly dispid 83;
    property ssUseDefBank: WordBool readonly dispid 84;
    property ssMonWk1: WideString readonly dispid 85;
    property ssAuditDate: WideString readonly dispid 86;
    property ssUserSort: WideString readonly dispid 87;
    property ssUserAcc: WideString readonly dispid 88;
    property ssUserRef: WideString readonly dispid 89;
    property ssUserBank: WideString readonly dispid 90;
    property ssLastExpFolio: Integer readonly dispid 91;
    property ssDetailTel: WideString readonly dispid 92;
    property ssDetailFax: WideString readonly dispid 93;
    property ssUserVATReg: WideString readonly dispid 94;
    property ssDataPath: WideString readonly dispid 95;
    property ssDetailAddr[Index: Integer]: WideString readonly dispid 96;
    property ssGLCtrlCodes[Index: TNomCtrlType]: Integer readonly dispid 97;
    property ssDebtChaseDays[Index: Integer]: Smallint readonly dispid 98;
    property ssTermsofTrade[Index: TTermsIndex]: WideString readonly dispid 99;
    property ssCurrency[Index: TCurrencyType]: ICOMSetupCurrency readonly dispid 100;
    property ssVATRates[Index: TVATIndex]: ICOMSetupVAT readonly dispid 101;
    property ssUserFields: ICOMSetupUserFields readonly dispid 102;
  end;

// *********************************************************************//
// Interface: ICOMSetupCIS
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3D255120-1B32-4C4B-B2BA-40D9F96FF1C8}
// *********************************************************************//
  ICOMSetupCIS = interface(IDispatch)
    ['{3D255120-1B32-4C4B-B2BA-40D9F96FF1C8}']
    function Get_cisInterval: Integer; safecall;
    function Get_cisAutoSetPeriod: WordBool; safecall;
    function Get_cisReturnDate: WideString; safecall;
    function Get_cisTaxRef: WideString; safecall;
    function Get_cisDefaultVatCode: WideString; safecall;
    function Get_cisFolioNumber: Integer; safecall;
    function Get_cisVoucherCounter(VoucherType: TCISVoucherType): ICOMSetupCISVoucherCounter; safecall;
    function Get_cisRate(TaxType: TCISTaxType): ICOMSetupCISRate; safecall;
    property cisInterval: Integer read Get_cisInterval;
    property cisAutoSetPeriod: WordBool read Get_cisAutoSetPeriod;
    property cisReturnDate: WideString read Get_cisReturnDate;
    property cisTaxRef: WideString read Get_cisTaxRef;
    property cisDefaultVatCode: WideString read Get_cisDefaultVatCode;
    property cisFolioNumber: Integer read Get_cisFolioNumber;
    property cisVoucherCounter[VoucherType: TCISVoucherType]: ICOMSetupCISVoucherCounter read Get_cisVoucherCounter;
    property cisRate[TaxType: TCISTaxType]: ICOMSetupCISRate read Get_cisRate;
  end;

// *********************************************************************//
// DispIntf:  ICOMSetupCISDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3D255120-1B32-4C4B-B2BA-40D9F96FF1C8}
// *********************************************************************//
  ICOMSetupCISDisp = dispinterface
    ['{3D255120-1B32-4C4B-B2BA-40D9F96FF1C8}']
    property cisInterval: Integer readonly dispid 1;
    property cisAutoSetPeriod: WordBool readonly dispid 2;
    property cisReturnDate: WideString readonly dispid 3;
    property cisTaxRef: WideString readonly dispid 4;
    property cisDefaultVatCode: WideString readonly dispid 5;
    property cisFolioNumber: Integer readonly dispid 6;
    property cisVoucherCounter[VoucherType: TCISVoucherType]: ICOMSetupCISVoucherCounter readonly dispid 8;
    property cisRate[TaxType: TCISTaxType]: ICOMSetupCISRate readonly dispid 7;
  end;

// *********************************************************************//
// Interface: ICOMSetupCISRate
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {80C87F5A-633E-4393-A3E7-2BEF6ED112C0}
// *********************************************************************//
  ICOMSetupCISRate = interface(IDispatch)
    ['{80C87F5A-633E-4393-A3E7-2BEF6ED112C0}']
    function Get_cisrCode: WideString; safecall;
    function Get_cisrDescription: WideString; safecall;
    function Get_cisrRate: Double; safecall;
    function Get_cisrGLCode: Integer; safecall;
    function Get_cisrCostCentre: WideString; safecall;
    function Get_cisrDepartment: WideString; safecall;
    property cisrCode: WideString read Get_cisrCode;
    property cisrDescription: WideString read Get_cisrDescription;
    property cisrRate: Double read Get_cisrRate;
    property cisrGLCode: Integer read Get_cisrGLCode;
    property cisrCostCentre: WideString read Get_cisrCostCentre;
    property cisrDepartment: WideString read Get_cisrDepartment;
  end;

// *********************************************************************//
// DispIntf:  ICOMSetupCISRateDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {80C87F5A-633E-4393-A3E7-2BEF6ED112C0}
// *********************************************************************//
  ICOMSetupCISRateDisp = dispinterface
    ['{80C87F5A-633E-4393-A3E7-2BEF6ED112C0}']
    property cisrCode: WideString readonly dispid 1;
    property cisrDescription: WideString readonly dispid 2;
    property cisrRate: Double readonly dispid 3;
    property cisrGLCode: Integer readonly dispid 4;
    property cisrCostCentre: WideString readonly dispid 5;
    property cisrDepartment: WideString readonly dispid 6;
  end;

// *********************************************************************//
// Interface: ICOMSetupCISVoucherCounter
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {55C696C4-2CCD-4D08-9AD5-894C6C102B6E}
// *********************************************************************//
  ICOMSetupCISVoucherCounter = interface(IDispatch)
    ['{55C696C4-2CCD-4D08-9AD5-894C6C102B6E}']
    function Get_cvPrefix: WideString; safecall;
    function Get_cvCounter: WideString; safecall;
    property cvPrefix: WideString read Get_cvPrefix;
    property cvCounter: WideString read Get_cvCounter;
  end;

// *********************************************************************//
// DispIntf:  ICOMSetupCISVoucherCounterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {55C696C4-2CCD-4D08-9AD5-894C6C102B6E}
// *********************************************************************//
  ICOMSetupCISVoucherCounterDisp = dispinterface
    ['{55C696C4-2CCD-4D08-9AD5-894C6C102B6E}']
    property cvPrefix: WideString readonly dispid 1;
    property cvCounter: WideString readonly dispid 3;
  end;

// *********************************************************************//
// Interface: ICOMSetupJobCosting
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {776A4D56-9689-4737-BC50-8001EBA3C84C}
// *********************************************************************//
  ICOMSetupJobCosting = interface(IDispatch)
    ['{776A4D56-9689-4737-BC50-8001EBA3C84C}']
    function Get_ssUsePPIsForTimeSheets: WordBool; safecall;
    function Get_ssSplitJobBudgetsByPeriod: WordBool; safecall;
    function Get_ssPPISupAccount: WideString; safecall;
    function Get_ssCheckJobBudget: WordBool; safecall;
    function Get_ssJobCategory(Index: TJobCategoryType): WideString; safecall;
    function Get_ssJobCostingGLCtrlCodes(Index: TJobGLCtrlType): Integer; safecall;
    property ssUsePPIsForTimeSheets: WordBool read Get_ssUsePPIsForTimeSheets;
    property ssSplitJobBudgetsByPeriod: WordBool read Get_ssSplitJobBudgetsByPeriod;
    property ssPPISupAccount: WideString read Get_ssPPISupAccount;
    property ssCheckJobBudget: WordBool read Get_ssCheckJobBudget;
    property ssJobCategory[Index: TJobCategoryType]: WideString read Get_ssJobCategory;
    property ssJobCostingGLCtrlCodes[Index: TJobGLCtrlType]: Integer read Get_ssJobCostingGLCtrlCodes;
  end;

// *********************************************************************//
// DispIntf:  ICOMSetupJobCostingDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {776A4D56-9689-4737-BC50-8001EBA3C84C}
// *********************************************************************//
  ICOMSetupJobCostingDisp = dispinterface
    ['{776A4D56-9689-4737-BC50-8001EBA3C84C}']
    property ssUsePPIsForTimeSheets: WordBool readonly dispid 1;
    property ssSplitJobBudgetsByPeriod: WordBool readonly dispid 2;
    property ssPPISupAccount: WideString readonly dispid 3;
    property ssCheckJobBudget: WordBool readonly dispid 5;
    property ssJobCategory[Index: TJobCategoryType]: WideString readonly dispid 4;
    property ssJobCostingGLCtrlCodes[Index: TJobGLCtrlType]: Integer readonly dispid 6;
  end;

// *********************************************************************//
// Interface: ICOMEventData2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFC2263F-811C-40AD-B756-EA4DBD641FAF}
// *********************************************************************//
  ICOMEventData2 = interface(ICOMEventData01)
    ['{EFC2263F-811C-40AD-B756-EA4DBD641FAF}']
    function Get_Customer2: ICOMCustomer3; safecall;
    function Get_JobCosting: ICOMJobCosting; safecall;
    function Get_Supplier2: ICOMCustomer3; safecall;
    function Get_Telesales: ICOMTelesales; safecall;
    function Get_Transaction2: ICOMTransaction3; safecall;
    property Customer2: ICOMCustomer3 read Get_Customer2;
    property JobCosting: ICOMJobCosting read Get_JobCosting;
    property Supplier2: ICOMCustomer3 read Get_Supplier2;
    property Telesales: ICOMTelesales read Get_Telesales;
    property Transaction2: ICOMTransaction3 read Get_Transaction2;
  end;

// *********************************************************************//
// DispIntf:  ICOMEventData2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EFC2263F-811C-40AD-B756-EA4DBD641FAF}
// *********************************************************************//
  ICOMEventData2Disp = dispinterface
    ['{EFC2263F-811C-40AD-B756-EA4DBD641FAF}']
    property Customer2: ICOMCustomer3 readonly dispid 20;
    property JobCosting: ICOMJobCosting readonly dispid 21;
    property Supplier2: ICOMCustomer3 readonly dispid 22;
    property Telesales: ICOMTelesales readonly dispid 23;
    property Transaction2: ICOMTransaction3 readonly dispid 24;
    property BatchSerial: ICOMBatchSerial readonly dispid 37;
    property WindowId: Integer readonly dispid 1;
    property HandlerId: Integer readonly dispid 2;
    property Customer: ICOMCustomer readonly dispid 3;
    property Supplier: ICOMCustomer readonly dispid 4;
    property CostCentre: ICOMCCDept readonly dispid 5;
    property Department: ICOMCCDept readonly dispid 6;
    property GLCode: ICOMGLCode readonly dispid 7;
    property Stock: ICOMStock readonly dispid 8;
    property Transaction: ICOMTransaction readonly dispid 9;
    property Job: ICOMJob readonly dispid 10;
    property MiscData: ICOMMiscData readonly dispid 11;
    property ValidStatus: WordBool dispid 12;
    property BoResult: WordBool dispid 13;
    property DblResult: Double dispid 14;
    property IntResult: Integer dispid 15;
    property StrResult: WideString dispid 16;
    property VarResult: OleVariant dispid 17;
    property InEditMode: WordBool readonly dispid 25;
  end;

// *********************************************************************//
// Interface: ICOMCustomer3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C34250A9-4AF8-4906-9E8E-732497F778AD}
// *********************************************************************//
  ICOMCustomer3 = interface(ICOMCustomer2)
    ['{C34250A9-4AF8-4906-9E8E-732497F778AD}']
    function Get_acStateDeliveryMode: Integer; safecall;
    procedure Set_acStateDeliveryMode(Value: Integer); safecall;
    function Get_acHeadOffice: Integer; safecall;
    procedure Set_acHeadOffice(Value: Integer); safecall;
    property acStateDeliveryMode: Integer read Get_acStateDeliveryMode write Set_acStateDeliveryMode;
    property acHeadOffice: Integer read Get_acHeadOffice write Set_acHeadOffice;
  end;

// *********************************************************************//
// DispIntf:  ICOMCustomer3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C34250A9-4AF8-4906-9E8E-732497F778AD}
// *********************************************************************//
  ICOMCustomer3Disp = dispinterface
    ['{C34250A9-4AF8-4906-9E8E-732497F778AD}']
    property acStateDeliveryMode: Integer dispid 72;
    property acHeadOffice: Integer dispid 73;
    property acDefTagNo: Integer dispid 53;
    property acDefSettleDisc: Double dispid 54;
    property acDefSettleDays: Integer dispid 58;
    property acDocDeliveryMode: Integer dispid 59;
    property acEbusPword: WideString dispid 60;
    property acUseForEbus: Integer dispid 61;
    property acWebLiveCatalog: WideString dispid 62;
    property acWebPrevCatalog: WideString dispid 63;
    property acInclusiveVATCode: WideString dispid 64;
    property acLastOperator: WideString dispid 65;
    property acSendHTML: WordBool dispid 66;
    property acSendReader: WordBool dispid 67;
    property acZIPAttachments: Integer dispid 68;
    property acSSDDeliveryTerms: WideString dispid 69;
    property acSSDModeOfTransport: Integer dispid 70;
    property acTimeStamp: WideString dispid 71;
    property acCode: WideString dispid 1;
    property AccessRights: TRecordAccessStatus readonly dispid 2;
    property acCompany: WideString dispid 3;
    property acArea: WideString dispid 4;
    property acAccType: WideString dispid 5;
    property acStatementTo: WideString dispid 6;
    property acVATRegNo: WideString dispid 7;
    property acDelAddr: WordBool dispid 8;
    property acContact: WideString dispid 9;
    property acPhone: WideString dispid 10;
    property acFax: WideString dispid 11;
    property acTheirAcc: WideString dispid 12;
    property acOwnTradTerm: WordBool dispid 13;
    property acCurrency: Smallint dispid 14;
    property acVATCode: WideString dispid 15;
    property acPayTerms: Smallint dispid 16;
    property acCreditLimit: Double dispid 17;
    property acDiscount: Double dispid 18;
    property acCreditStatus: Smallint dispid 19;
    property acCostCentre: WideString dispid 20;
    property acDiscountBand: WideString dispid 21;
    property acDepartment: WideString dispid 22;
    property acECMember: WordBool dispid 23;
    property acStatement: WordBool dispid 24;
    property acSalesGL: Integer dispid 25;
    property acLocation: WideString dispid 26;
    property acAccStatus: TAccountStatus dispid 27;
    property acPayType: WideString dispid 28;
    property acBankSort: WideString dispid 29;
    property acBankAcc: WideString dispid 30;
    property acBankRef: WideString dispid 31;
    property acPhone2: WideString dispid 32;
    property acCOSGL: Integer dispid 33;
    property acDrCrGL: Integer dispid 34;
    property acLastUsed: WideString dispid 35;
    property acUserDef1: WideString dispid 36;
    property acUserDef2: WideString dispid 37;
    property acInvoiceTo: WideString dispid 38;
    property acSOPAutoWOff: WordBool dispid 39;
    property acFormSet: Smallint dispid 40;
    property acBookOrdVal: Double dispid 41;
    property acDirDebMode: Smallint dispid 42;
    property acAltCode: WideString dispid 43;
    property acPostCode: WideString dispid 44;
    property acUserDef3: WideString dispid 45;
    property acUserDef4: WideString dispid 46;
    property acEmailAddr: WideString dispid 47;
    property acCCStart: WideString dispid 48;
    property acCCEnd: WideString dispid 49;
    property acCCName: WideString dispid 50;
    property acCCNumber: WideString dispid 51;
    property acCCSwitch: WideString dispid 52;
    property acTradeTerms[Index: Integer]: WideString dispid 55;
    property acAddress[Index: Integer]: WideString dispid 56;
    property acDelAddress[Index: Integer]: WideString dispid 57;
  end;

// *********************************************************************//
// Interface: ICOMTransaction3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0AC799EA-1940-4597-AC14-51916BDEC1F9}
// *********************************************************************//
  ICOMTransaction3 = interface(ICOMTransaction2)
    ['{0AC799EA-1940-4597-AC14-51916BDEC1F9}']
    function Get_thCISTaxDue: Double; safecall;
    procedure Set_thCISTaxDue(Value: Double); safecall;
    function Get_thCISTaxDeclared: Double; safecall;
    procedure Set_thCISTaxDeclared(Value: Double); safecall;
    function Get_thCISManualTax: WordBool; safecall;
    procedure Set_thCISManualTax(Value: WordBool); safecall;
    function Get_thCISDate: WideString; safecall;
    procedure Set_thCISDate(const Value: WideString); safecall;
    function Get_thCISEmployee: WideString; safecall;
    procedure Set_thCISEmployee(const Value: WideString); safecall;
    function Get_thCISTotalGross: Double; safecall;
    procedure Set_thCISTotalGross(Value: Double); safecall;
    function Get_thCISSource: Integer; safecall;
    procedure Set_thCISSource(Value: Integer); safecall;
    function Get_thTotalCostApport: Double; safecall;
    procedure Set_thTotalCostApport(Value: Double); safecall;
    property thCISTaxDue: Double read Get_thCISTaxDue write Set_thCISTaxDue;
    property thCISTaxDeclared: Double read Get_thCISTaxDeclared write Set_thCISTaxDeclared;
    property thCISManualTax: WordBool read Get_thCISManualTax write Set_thCISManualTax;
    property thCISDate: WideString read Get_thCISDate write Set_thCISDate;
    property thCISEmployee: WideString read Get_thCISEmployee write Set_thCISEmployee;
    property thCISTotalGross: Double read Get_thCISTotalGross write Set_thCISTotalGross;
    property thCISSource: Integer read Get_thCISSource write Set_thCISSource;
    property thTotalCostApport: Double read Get_thTotalCostApport write Set_thTotalCostApport;
  end;

// *********************************************************************//
// DispIntf:  ICOMTransaction3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0AC799EA-1940-4597-AC14-51916BDEC1F9}
// *********************************************************************//
  ICOMTransaction3Disp = dispinterface
    ['{0AC799EA-1940-4597-AC14-51916BDEC1F9}']
    property thCISTaxDue: Double dispid 84;
    property thCISTaxDeclared: Double dispid 85;
    property thCISManualTax: WordBool dispid 86;
    property thCISDate: WideString dispid 88;
    property thCISEmployee: WideString dispid 89;
    property thCISTotalGross: Double dispid 90;
    property thCISSource: Integer dispid 91;
    property thTotalCostApport: Double dispid 92;
    property thTagNo: Integer dispid 83;
    function LinkToCust: WordBool; dispid 1;
    property AccessRights: TRecordAccessStatus readonly dispid 2;
    property DataChanged: WordBool readonly dispid 3;
    property thRunNo: Integer dispid 4;
    property thAcCode: WideString dispid 5;
    property thNomAuto: WordBool dispid 6;
    property thOurRef: WideString dispid 7;
    property thFolioNum: Integer dispid 8;
    property thCurrency: Smallint dispid 9;
    property thYear: Smallint dispid 10;
    property thPeriod: Smallint dispid 11;
    property thDueDate: WideString dispid 12;
    property thVATPostDate: WideString dispid 13;
    property thTransDate: WideString dispid 14;
    property thCustSupp: WideString readonly dispid 15;
    property thCompanyRate: Double dispid 16;
    property thDailyRate: Double dispid 17;
    property thYourRef: WideString dispid 18;
    property thBatchLink: WideString dispid 19;
    property thAllocStat: WideString dispid 20;
    property thInvNetVal: Double readonly dispid 22;
    property thInvVat: Double readonly dispid 23;
    property thDiscSetl: Double dispid 24;
    property thDiscSetAm: Double dispid 25;
    property thDiscAmount: Double dispid 26;
    property thDiscDays: Smallint dispid 27;
    property thDiscTaken: WordBool dispid 28;
    property thSettled: Double dispid 29;
    property thAutoInc: Smallint dispid 30;
    property thNextAutoYr: Smallint dispid 31;
    property thNextAutoPr: Smallint dispid 32;
    property thTransNat: Smallint dispid 33;
    property thTransMode: Smallint dispid 34;
    property thRemitNo: WideString dispid 35;
    property thAutoIncBy: WideString dispid 36;
    property thHoldFlg: Smallint dispid 37;
    property thAuditFlg: WordBool dispid 38;
    property thTotalWeight: Double dispid 39;
    property thVariance: Double dispid 40;
    property thTotalOrdered: Double dispid 41;
    property thTotalReserved: Double dispid 42;
    property thTotalCost: Double dispid 43;
    property thTotalInvoiced: Double dispid 44;
    property thTransDesc: WideString dispid 45;
    property thAutoUntilDate: WideString dispid 46;
    property thExternal: WordBool dispid 47;
    property thPrinted: WordBool dispid 48;
    property thCurrVariance: Double dispid 49;
    property thCurrSettled: Double dispid 50;
    property thSettledVAT: Double dispid 51;
    property thVATClaimed: Double dispid 52;
    property thBatchPayGL: Integer dispid 53;
    property thAutoPost: WordBool dispid 54;
    property thManualVAT: WordBool dispid 55;
    property thSSDDelTerms: WideString dispid 56;
    property thUser: WideString dispid 57;
    property thNoLabels: Smallint dispid 58;
    property thTagged: WordBool dispid 59;
    property thPickRunNo: Integer dispid 60;
    property thOrdMatch: WordBool dispid 61;
    property thDeliveryNote: WideString dispid 62;
    property thVATCompanyRate: Double dispid 63;
    property thVATDailyRate: Double dispid 64;
    property thPostCompanyRate: Double dispid 65;
    property thPostDailyRate: Double dispid 66;
    property thPostDiscAm: Double dispid 67;
    property thPostedDiscTaken: WordBool dispid 68;
    property thDrCrGL: Integer dispid 69;
    property thJobCode: WideString dispid 70;
    property thJobAnal: WideString dispid 71;
    property thTotOrderOS: Double dispid 72;
    property thUser1: WideString dispid 73;
    property thUser2: WideString dispid 74;
    property thLastLetter: Smallint dispid 75;
    property thUnTagged: WordBool dispid 76;
    property thUser3: WideString dispid 77;
    property thUser4: WideString dispid 78;
    property thInvVATAnal[Index: TVATIndex]: Double dispid 21;
    property thDelAddr[Index: Integer]: WideString dispid 79;
    property thDocLSplit[Index: Integer]: Double dispid 80;
    property thInvDocHed: TDocTypes dispid 81;
    property thLines: ICOMTransactionLines readonly dispid 82;
  end;

// *********************************************************************//
// Interface: ICOMTelesales
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D751489D-B2E8-497C-B654-4ED434EE4270}
// *********************************************************************//
  ICOMTelesales = interface(IDispatch)
    ['{D751489D-B2E8-497C-B654-4ED434EE4270}']
    function Get_teCustCode: WideString; safecall;
    procedure Set_teCustCode(const Value: WideString); safecall;
    function Get_teCurrency: Integer; safecall;
    procedure Set_teCurrency(Value: Integer); safecall;
    function Get_teCompanyRate: Double; safecall;
    procedure Set_teCompanyRate(Value: Double); safecall;
    function Get_teDailyRate: Double; safecall;
    procedure Set_teDailyRate(Value: Double); safecall;
    function Get_teYourRef: WideString; safecall;
    procedure Set_teYourRef(const Value: WideString); safecall;
    function Get_teAltRef: WideString; safecall;
    procedure Set_teAltRef(const Value: WideString); safecall;
    function Get_teCostCentre: WideString; safecall;
    procedure Set_teCostCentre(const Value: WideString); safecall;
    function Get_teDepartment: WideString; safecall;
    procedure Set_teDepartment(const Value: WideString); safecall;
    function Get_teLocation: WideString; safecall;
    procedure Set_teLocation(const Value: WideString); safecall;
    function Get_teJobCode: WideString; safecall;
    procedure Set_teJobCode(const Value: WideString); safecall;
    function Get_teJobAnal: WideString; safecall;
    procedure Set_teJobAnal(const Value: WideString); safecall;
    function Get_teDelAddr(Index: Integer): WideString; safecall;
    procedure Set_teDelAddr(Index: Integer; const Value: WideString); safecall;
    function Get_teTransDate: WideString; safecall;
    procedure Set_teTransDate(const Value: WideString); safecall;
    function Get_teDueDate: WideString; safecall;
    procedure Set_teDueDate(const Value: WideString); safecall;
    function Get_teNetTotal: Double; safecall;
    procedure Set_teNetTotal(Value: Double); safecall;
    function Get_teVATTotal: Double; safecall;
    procedure Set_teVATTotal(Value: Double); safecall;
    function Get_teTotalDiscount: Double; safecall;
    procedure Set_teTotalDiscount(Value: Double); safecall;
    function Get_teUser: WideString; safecall;
    procedure Set_teUser(const Value: WideString); safecall;
    function Get_teInProgress: WordBool; safecall;
    procedure Set_teInProgress(Value: WordBool); safecall;
    function Get_teTransportNature: Integer; safecall;
    procedure Set_teTransportNature(Value: Integer); safecall;
    function Get_teTransportMode: Integer; safecall;
    procedure Set_teTransportMode(Value: Integer); safecall;
    function Get_teSSDDelTerms: WideString; safecall;
    procedure Set_teSSDDelTerms(const Value: WideString); safecall;
    function Get_teControlGL: Integer; safecall;
    procedure Set_teControlGL(Value: Integer); safecall;
    function Get_teVATCode: WideString; safecall;
    procedure Set_teVATCode(const Value: WideString); safecall;
    function Get_teHistoryAnalysisMode: Integer; safecall;
    procedure Set_teHistoryAnalysisMode(Value: Integer); safecall;
    function Get_teListScaleMode: Integer; safecall;
    procedure Set_teListScaleMode(Value: Integer); safecall;
    function Get_teWasNew: WordBool; safecall;
    procedure Set_teWasNew(Value: WordBool); safecall;
    function Get_teUseORate: Integer; safecall;
    procedure Set_teUseORate(Value: Integer); safecall;
    function Get_teDefaultGLCode: Integer; safecall;
    procedure Set_teDefaultGLCode(Value: Integer); safecall;
    function Get_teInclusiveVATCode: WideString; safecall;
    procedure Set_teInclusiveVATCode(const Value: WideString); safecall;
    function Get_teDefSettleDisc: Double; safecall;
    procedure Set_teDefSettleDisc(Value: Double); safecall;
    function Get_teTransactionType: Integer; safecall;
    procedure Set_teTransactionType(Value: Integer); safecall;
    function Get_teSalesLine: ICOMTelesalesLine; safecall;
    function Get_AccessRights: TRecordAccessStatus; safecall;
    property teCustCode: WideString read Get_teCustCode write Set_teCustCode;
    property teCurrency: Integer read Get_teCurrency write Set_teCurrency;
    property teCompanyRate: Double read Get_teCompanyRate write Set_teCompanyRate;
    property teDailyRate: Double read Get_teDailyRate write Set_teDailyRate;
    property teYourRef: WideString read Get_teYourRef write Set_teYourRef;
    property teAltRef: WideString read Get_teAltRef write Set_teAltRef;
    property teCostCentre: WideString read Get_teCostCentre write Set_teCostCentre;
    property teDepartment: WideString read Get_teDepartment write Set_teDepartment;
    property teLocation: WideString read Get_teLocation write Set_teLocation;
    property teJobCode: WideString read Get_teJobCode write Set_teJobCode;
    property teJobAnal: WideString read Get_teJobAnal write Set_teJobAnal;
    property teDelAddr[Index: Integer]: WideString read Get_teDelAddr write Set_teDelAddr;
    property teTransDate: WideString read Get_teTransDate write Set_teTransDate;
    property teDueDate: WideString read Get_teDueDate write Set_teDueDate;
    property teNetTotal: Double read Get_teNetTotal write Set_teNetTotal;
    property teVATTotal: Double read Get_teVATTotal write Set_teVATTotal;
    property teTotalDiscount: Double read Get_teTotalDiscount write Set_teTotalDiscount;
    property teUser: WideString read Get_teUser write Set_teUser;
    property teInProgress: WordBool read Get_teInProgress write Set_teInProgress;
    property teTransportNature: Integer read Get_teTransportNature write Set_teTransportNature;
    property teTransportMode: Integer read Get_teTransportMode write Set_teTransportMode;
    property teSSDDelTerms: WideString read Get_teSSDDelTerms write Set_teSSDDelTerms;
    property teControlGL: Integer read Get_teControlGL write Set_teControlGL;
    property teVATCode: WideString read Get_teVATCode write Set_teVATCode;
    property teHistoryAnalysisMode: Integer read Get_teHistoryAnalysisMode write Set_teHistoryAnalysisMode;
    property teListScaleMode: Integer read Get_teListScaleMode write Set_teListScaleMode;
    property teWasNew: WordBool read Get_teWasNew write Set_teWasNew;
    property teUseORate: Integer read Get_teUseORate write Set_teUseORate;
    property teDefaultGLCode: Integer read Get_teDefaultGLCode write Set_teDefaultGLCode;
    property teInclusiveVATCode: WideString read Get_teInclusiveVATCode write Set_teInclusiveVATCode;
    property teDefSettleDisc: Double read Get_teDefSettleDisc write Set_teDefSettleDisc;
    property teTransactionType: Integer read Get_teTransactionType write Set_teTransactionType;
    property teSalesLine: ICOMTelesalesLine read Get_teSalesLine;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
  end;

// *********************************************************************//
// DispIntf:  ICOMTelesalesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D751489D-B2E8-497C-B654-4ED434EE4270}
// *********************************************************************//
  ICOMTelesalesDisp = dispinterface
    ['{D751489D-B2E8-497C-B654-4ED434EE4270}']
    property teCustCode: WideString dispid 1;
    property teCurrency: Integer dispid 2;
    property teCompanyRate: Double dispid 3;
    property teDailyRate: Double dispid 4;
    property teYourRef: WideString dispid 5;
    property teAltRef: WideString dispid 6;
    property teCostCentre: WideString dispid 7;
    property teDepartment: WideString dispid 8;
    property teLocation: WideString dispid 9;
    property teJobCode: WideString dispid 10;
    property teJobAnal: WideString dispid 11;
    property teDelAddr[Index: Integer]: WideString dispid 12;
    property teTransDate: WideString dispid 13;
    property teDueDate: WideString dispid 14;
    property teNetTotal: Double dispid 15;
    property teVATTotal: Double dispid 16;
    property teTotalDiscount: Double dispid 17;
    property teUser: WideString dispid 18;
    property teInProgress: WordBool dispid 19;
    property teTransportNature: Integer dispid 20;
    property teTransportMode: Integer dispid 21;
    property teSSDDelTerms: WideString dispid 22;
    property teControlGL: Integer dispid 23;
    property teVATCode: WideString dispid 24;
    property teHistoryAnalysisMode: Integer dispid 25;
    property teListScaleMode: Integer dispid 26;
    property teWasNew: WordBool dispid 27;
    property teUseORate: Integer dispid 28;
    property teDefaultGLCode: Integer dispid 29;
    property teInclusiveVATCode: WideString dispid 30;
    property teDefSettleDisc: Double dispid 31;
    property teTransactionType: Integer dispid 32;
    property teSalesLine: ICOMTelesalesLine readonly dispid 33;
    property AccessRights: TRecordAccessStatus readonly dispid 34;
  end;

// *********************************************************************//
// Interface: ICOMTransactionLine2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1286D1D2-75FD-4AE2-92EA-A91449DC3213}
// *********************************************************************//
  ICOMTransactionLine2 = interface(ICOMTransactionLine)
    ['{1286D1D2-75FD-4AE2-92EA-A91449DC3213}']
    function Get_tlLineSource: Integer; safecall;
    procedure Set_tlLineSource(Value: Integer); safecall;
    function Get_tlCISRateCode: WideString; safecall;
    procedure Set_tlCISRateCode(const Value: WideString); safecall;
    function Get_tlCISRate: Double; safecall;
    procedure Set_tlCISRate(Value: Double); safecall;
    function Get_tlCostApport: Double; safecall;
    procedure Set_tlCostApport(Value: Double); safecall;
    function Get_tlVATInclValue: Double; safecall;
    procedure Set_tlVATInclValue(Value: Double); safecall;
    property tlLineSource: Integer read Get_tlLineSource write Set_tlLineSource;
    property tlCISRateCode: WideString read Get_tlCISRateCode write Set_tlCISRateCode;
    property tlCISRate: Double read Get_tlCISRate write Set_tlCISRate;
    property tlCostApport: Double read Get_tlCostApport write Set_tlCostApport;
    property tlVATInclValue: Double read Get_tlVATInclValue write Set_tlVATInclValue;
  end;

// *********************************************************************//
// DispIntf:  ICOMTransactionLine2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1286D1D2-75FD-4AE2-92EA-A91449DC3213}
// *********************************************************************//
  ICOMTransactionLine2Disp = dispinterface
    ['{1286D1D2-75FD-4AE2-92EA-A91449DC3213}']
    property tlLineSource: Integer dispid 62;
    property tlCISRateCode: WideString dispid 63;
    property tlCISRate: Double dispid 64;
    property tlCostApport: Double dispid 65;
    property tlVATInclValue: Double dispid 66;
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property tlFolio: Integer dispid 3;
    property tlLinePos: Integer dispid 4;
    property tlRunNo: Integer dispid 5;
    property tlGLCode: Integer dispid 6;
    property tlShowInGL: Smallint dispid 7;
    property tlCurrency: TCurrencyType dispid 8;
    property tlYear: Smallint readonly dispid 9;
    property tlPeriod: Smallint readonly dispid 10;
    property tlCostCentre: WideString dispid 11;
    property tlDepartment: WideString dispid 12;
    property tlStockCode: WideString dispid 13;
    property tlLineNo: Integer dispid 14;
    property tlLineClass: WideString readonly dispid 15;
    property tlDocType: TDocTypes readonly dispid 16;
    property tlQty: Double dispid 17;
    property tlQtyMul: Double dispid 18;
    property tlNetValue: Double dispid 19;
    property tlDiscount: Double dispid 20;
    property tlVATCode: WideString dispid 21;
    property tlVATAmount: Double dispid 22;
    property tlPayStatus: WideString dispid 23;
    property tlPrevGLBal: Double dispid 24;
    property tlRecStatus: Smallint dispid 25;
    property tlDiscFlag: WideString dispid 26;
    property tlQtyWOFF: Double dispid 27;
    property tlQtyDel: Double dispid 28;
    property tlCost: Double dispid 29;
    property tlAcCode: WideString readonly dispid 30;
    property tlTransDate: WideString dispid 31;
    property tlItemNo: WideString dispid 32;
    property tlDescr: WideString dispid 33;
    property tlJobCode: WideString dispid 34;
    property tlJobAnal: WideString dispid 35;
    property tlCompanyRate: Double dispid 36;
    property tlDailyRate: Double dispid 37;
    property tlUnitWeight: Double dispid 38;
    property tlStockDeductQty: Double dispid 39;
    property tlBOMKitLink: Integer dispid 40;
    property tlOrderFolio: Integer dispid 41;
    property tlOrderLineNo: Integer dispid 42;
    property tlLocation: WideString dispid 43;
    property tlQtyPicked: Double dispid 44;
    property tlQtyPickedWO: Double dispid 45;
    property tlUseQtyMul: WordBool dispid 46;
    property tlNoSerialNos: Double dispid 47;
    property tlCOSGL: Integer dispid 48;
    property tlOurRef: WideString readonly dispid 49;
    property tlLineType: Integer dispid 50;
    property tlPriceByPack: WordBool dispid 51;
    property tlQtyInPack: Double dispid 52;
    property tlClearDate: WideString dispid 53;
    property tlUserDef1: WideString dispid 54;
    property tlUserDef2: WideString dispid 55;
    property tlUserDef3: WideString dispid 56;
    property tlUserDef4: WideString dispid 57;
    function entInvLTotal(UseDisc: WordBool; SetlDisc: Double): Double; dispid 58;
    procedure Delete; dispid 59;
    procedure Save; dispid 60;
    function LinkToStock: WordBool; dispid 61;
  end;

// *********************************************************************//
// Interface: ICOMTelesalesLine
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {22D35A6C-46A9-4029-B6D0-22F8615EBB2A}
// *********************************************************************//
  ICOMTelesalesLine = interface(IDispatch)
    ['{22D35A6C-46A9-4029-B6D0-22F8615EBB2A}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_telCustCode: WideString; safecall;
    procedure Set_telCustCode(const Value: WideString); safecall;
    function Get_telStockCode: WideString; safecall;
    procedure Set_telStockCode(const Value: WideString); safecall;
    function Get_telRepeatQty: Double; safecall;
    procedure Set_telRepeatQty(Value: Double); safecall;
    function Get_telLastSaleDate: WideString; safecall;
    procedure Set_telLastSaleDate(const Value: WideString); safecall;
    function Get_telDisplayOrder: Integer; safecall;
    procedure Set_telDisplayOrder(Value: Integer); safecall;
    function Get_telLastPrice: Double; safecall;
    procedure Set_telLastPrice(Value: Double); safecall;
    function Get_telLastPriceCurr: Integer; safecall;
    procedure Set_telLastPriceCurr(Value: Integer); safecall;
    function Get_telJobCode: WideString; safecall;
    procedure Set_telJobCode(const Value: WideString); safecall;
    function Get_telJobAnal: WideString; safecall;
    procedure Set_telJobAnal(const Value: WideString); safecall;
    function Get_telLocation: WideString; safecall;
    procedure Set_telLocation(const Value: WideString); safecall;
    function Get_telGLCode: Integer; safecall;
    procedure Set_telGLCode(Value: Integer); safecall;
    function Get_telCostCentre: WideString; safecall;
    procedure Set_telCostCentre(const Value: WideString); safecall;
    function Get_telDepartment: WideString; safecall;
    procedure Set_telDepartment(const Value: WideString); safecall;
    function Get_telQty: Double; safecall;
    procedure Set_telQty(Value: Double); safecall;
    function Get_telNetValue: Double; safecall;
    procedure Set_telNetValue(Value: Double); safecall;
    function Get_telDiscount: Double; safecall;
    procedure Set_telDiscount(Value: Double); safecall;
    function Get_telVATCode: WideString; safecall;
    procedure Set_telVATCode(const Value: WideString); safecall;
    function Get_telCost: Double; safecall;
    procedure Set_telCost(Value: Double); safecall;
    function Get_telDescr(Index: Integer): WideString; safecall;
    procedure Set_telDescr(Index: Integer; const Value: WideString); safecall;
    function Get_telVATAmount: Double; safecall;
    procedure Set_telVATAmount(Value: Double); safecall;
    function Get_telPriceByPack: WordBool; safecall;
    procedure Set_telPriceByPack(Value: WordBool); safecall;
    function Get_telQtyInPack: Double; safecall;
    procedure Set_telQtyInPack(Value: Double); safecall;
    function Get_telQtyMul: Double; safecall;
    procedure Set_telQtyMul(Value: Double); safecall;
    function Get_telDiscFlag: WideString; safecall;
    procedure Set_telDiscFlag(const Value: WideString); safecall;
    function Get_telEntered: WordBool; safecall;
    procedure Set_telEntered(Value: WordBool); safecall;
    function Get_telCalcPack: WordBool; safecall;
    procedure Set_telCalcPack(Value: WordBool); safecall;
    function Get_telShowAsPacks: WordBool; safecall;
    procedure Set_telShowAsPacks(Value: WordBool); safecall;
    function Get_telLineType: Integer; safecall;
    procedure Set_telLineType(Value: Integer); safecall;
    function Get_telPriceMultiplier: Double; safecall;
    procedure Set_telPriceMultiplier(Value: Double); safecall;
    function Get_telInclusiveVATCode: WideString; safecall;
    procedure Set_telInclusiveVATCode(const Value: WideString); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property telCustCode: WideString read Get_telCustCode write Set_telCustCode;
    property telStockCode: WideString read Get_telStockCode write Set_telStockCode;
    property telRepeatQty: Double read Get_telRepeatQty write Set_telRepeatQty;
    property telLastSaleDate: WideString read Get_telLastSaleDate write Set_telLastSaleDate;
    property telDisplayOrder: Integer read Get_telDisplayOrder write Set_telDisplayOrder;
    property telLastPrice: Double read Get_telLastPrice write Set_telLastPrice;
    property telLastPriceCurr: Integer read Get_telLastPriceCurr write Set_telLastPriceCurr;
    property telJobCode: WideString read Get_telJobCode write Set_telJobCode;
    property telJobAnal: WideString read Get_telJobAnal write Set_telJobAnal;
    property telLocation: WideString read Get_telLocation write Set_telLocation;
    property telGLCode: Integer read Get_telGLCode write Set_telGLCode;
    property telCostCentre: WideString read Get_telCostCentre write Set_telCostCentre;
    property telDepartment: WideString read Get_telDepartment write Set_telDepartment;
    property telQty: Double read Get_telQty write Set_telQty;
    property telNetValue: Double read Get_telNetValue write Set_telNetValue;
    property telDiscount: Double read Get_telDiscount write Set_telDiscount;
    property telVATCode: WideString read Get_telVATCode write Set_telVATCode;
    property telCost: Double read Get_telCost write Set_telCost;
    property telDescr[Index: Integer]: WideString read Get_telDescr write Set_telDescr;
    property telVATAmount: Double read Get_telVATAmount write Set_telVATAmount;
    property telPriceByPack: WordBool read Get_telPriceByPack write Set_telPriceByPack;
    property telQtyInPack: Double read Get_telQtyInPack write Set_telQtyInPack;
    property telQtyMul: Double read Get_telQtyMul write Set_telQtyMul;
    property telDiscFlag: WideString read Get_telDiscFlag write Set_telDiscFlag;
    property telEntered: WordBool read Get_telEntered write Set_telEntered;
    property telCalcPack: WordBool read Get_telCalcPack write Set_telCalcPack;
    property telShowAsPacks: WordBool read Get_telShowAsPacks write Set_telShowAsPacks;
    property telLineType: Integer read Get_telLineType write Set_telLineType;
    property telPriceMultiplier: Double read Get_telPriceMultiplier write Set_telPriceMultiplier;
    property telInclusiveVATCode: WideString read Get_telInclusiveVATCode write Set_telInclusiveVATCode;
  end;

// *********************************************************************//
// DispIntf:  ICOMTelesalesLineDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {22D35A6C-46A9-4029-B6D0-22F8615EBB2A}
// *********************************************************************//
  ICOMTelesalesLineDisp = dispinterface
    ['{22D35A6C-46A9-4029-B6D0-22F8615EBB2A}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property telCustCode: WideString dispid 2;
    property telStockCode: WideString dispid 3;
    property telRepeatQty: Double dispid 4;
    property telLastSaleDate: WideString dispid 5;
    property telDisplayOrder: Integer dispid 6;
    property telLastPrice: Double dispid 7;
    property telLastPriceCurr: Integer dispid 8;
    property telJobCode: WideString dispid 9;
    property telJobAnal: WideString dispid 10;
    property telLocation: WideString dispid 11;
    property telGLCode: Integer dispid 12;
    property telCostCentre: WideString dispid 13;
    property telDepartment: WideString dispid 14;
    property telQty: Double dispid 15;
    property telNetValue: Double dispid 16;
    property telDiscount: Double dispid 17;
    property telVATCode: WideString dispid 18;
    property telCost: Double dispid 19;
    property telDescr[Index: Integer]: WideString dispid 20;
    property telVATAmount: Double dispid 21;
    property telPriceByPack: WordBool dispid 22;
    property telQtyInPack: Double dispid 23;
    property telQtyMul: Double dispid 24;
    property telDiscFlag: WideString dispid 25;
    property telEntered: WordBool dispid 26;
    property telCalcPack: WordBool dispid 27;
    property telShowAsPacks: WordBool dispid 28;
    property telLineType: Integer dispid 29;
    property telPriceMultiplier: Double dispid 30;
    property telInclusiveVATCode: WideString dispid 31;
  end;

// *********************************************************************//
// Interface: ICOMJobCosting
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BC3EB93E-C676-4778-8142-F7F89BB7AC2C}
// *********************************************************************//
  ICOMJobCosting = interface(IDispatch)
    ['{BC3EB93E-C676-4778-8142-F7F89BB7AC2C}']
    function Get_CISVoucher: ICOMCISVoucher; safecall;
    function Get_Employee: ICOMEmployee; safecall;
    function Get_Job2: ICOMJob2; safecall;
    function Get_JobAnalysis: ICOMJobAnalysis; safecall;
    function Get_TimeRate: ICOMTimeRate; safecall;
    property CISVoucher: ICOMCISVoucher read Get_CISVoucher;
    property Employee: ICOMEmployee read Get_Employee;
    property Job2: ICOMJob2 read Get_Job2;
    property JobAnalysis: ICOMJobAnalysis read Get_JobAnalysis;
    property TimeRate: ICOMTimeRate read Get_TimeRate;
  end;

// *********************************************************************//
// DispIntf:  ICOMJobCostingDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BC3EB93E-C676-4778-8142-F7F89BB7AC2C}
// *********************************************************************//
  ICOMJobCostingDisp = dispinterface
    ['{BC3EB93E-C676-4778-8142-F7F89BB7AC2C}']
    property CISVoucher: ICOMCISVoucher readonly dispid 1;
    property Employee: ICOMEmployee readonly dispid 2;
    property Job2: ICOMJob2 readonly dispid 3;
    property JobAnalysis: ICOMJobAnalysis readonly dispid 4;
    property TimeRate: ICOMTimeRate readonly dispid 5;
  end;

// *********************************************************************//
// Interface: ICOMCISVoucher
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ECF2F0E7-9768-434E-A509-F29D3F6AE90F}
// *********************************************************************//
  ICOMCISVoucher = interface(IDispatch)
    ['{ECF2F0E7-9768-434E-A509-F29D3F6AE90F}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_cvNumber: WideString; safecall;
    procedure Set_cvNumber(const Value: WideString); safecall;
    function Get_cvEmployee: WideString; safecall;
    procedure Set_cvEmployee(const Value: WideString); safecall;
    function Get_cvDate: WideString; safecall;
    procedure Set_cvDate(const Value: WideString); safecall;
    function Get_cvTransaction: WideString; safecall;
    procedure Set_cvTransaction(const Value: WideString); safecall;
    function Get_cvFolio: Integer; safecall;
    function Get_cvCertificateNo: WideString; safecall;
    procedure Set_cvCertificateNo(const Value: WideString); safecall;
    function Get_cvGrossTotal: Double; safecall;
    procedure Set_cvGrossTotal(Value: Double); safecall;
    function Get_cvType: Integer; safecall;
    procedure Set_cvType(Value: Integer); safecall;
    function Get_cvAutoTotalTax: Double; safecall;
    procedure Set_cvAutoTotalTax(Value: Double); safecall;
    function Get_cvManualTax: WordBool; safecall;
    procedure Set_cvManualTax(Value: WordBool); safecall;
    function Get_cvTaxableTotal: Double; safecall;
    procedure Set_cvTaxableTotal(Value: Double); safecall;
    function Get_cvCurrency: Integer; safecall;
    procedure Set_cvCurrency(Value: Integer); safecall;
    function Get_cvAddress(Index: Integer): WideString; safecall;
    procedure Set_cvAddress(Index: Integer; const Value: WideString); safecall;
    function Get_cvBehalf: WideString; safecall;
    procedure Set_cvBehalf(const Value: WideString); safecall;
    function Get_cvCorrection: WordBool; safecall;
    procedure Set_cvCorrection(Value: WordBool); safecall;
    function Get_cvTaxDue: Double; safecall;
    procedure Set_cvTaxDue(Value: Double); safecall;
    function Get_cvSupplier: WideString; safecall;
    procedure Set_cvSupplier(const Value: WideString); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property cvNumber: WideString read Get_cvNumber write Set_cvNumber;
    property cvEmployee: WideString read Get_cvEmployee write Set_cvEmployee;
    property cvDate: WideString read Get_cvDate write Set_cvDate;
    property cvTransaction: WideString read Get_cvTransaction write Set_cvTransaction;
    property cvFolio: Integer read Get_cvFolio;
    property cvCertificateNo: WideString read Get_cvCertificateNo write Set_cvCertificateNo;
    property cvGrossTotal: Double read Get_cvGrossTotal write Set_cvGrossTotal;
    property cvType: Integer read Get_cvType write Set_cvType;
    property cvAutoTotalTax: Double read Get_cvAutoTotalTax write Set_cvAutoTotalTax;
    property cvManualTax: WordBool read Get_cvManualTax write Set_cvManualTax;
    property cvTaxableTotal: Double read Get_cvTaxableTotal write Set_cvTaxableTotal;
    property cvCurrency: Integer read Get_cvCurrency write Set_cvCurrency;
    property cvAddress[Index: Integer]: WideString read Get_cvAddress write Set_cvAddress;
    property cvBehalf: WideString read Get_cvBehalf write Set_cvBehalf;
    property cvCorrection: WordBool read Get_cvCorrection write Set_cvCorrection;
    property cvTaxDue: Double read Get_cvTaxDue write Set_cvTaxDue;
    property cvSupplier: WideString read Get_cvSupplier write Set_cvSupplier;
  end;

// *********************************************************************//
// DispIntf:  ICOMCISVoucherDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ECF2F0E7-9768-434E-A509-F29D3F6AE90F}
// *********************************************************************//
  ICOMCISVoucherDisp = dispinterface
    ['{ECF2F0E7-9768-434E-A509-F29D3F6AE90F}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property cvNumber: WideString dispid 2;
    property cvEmployee: WideString dispid 3;
    property cvDate: WideString dispid 4;
    property cvTransaction: WideString dispid 5;
    property cvFolio: Integer readonly dispid 6;
    property cvCertificateNo: WideString dispid 7;
    property cvGrossTotal: Double dispid 8;
    property cvType: Integer dispid 9;
    property cvAutoTotalTax: Double dispid 10;
    property cvManualTax: WordBool dispid 11;
    property cvTaxableTotal: Double dispid 12;
    property cvCurrency: Integer dispid 13;
    property cvAddress[Index: Integer]: WideString dispid 14;
    property cvBehalf: WideString dispid 15;
    property cvCorrection: WordBool dispid 16;
    property cvTaxDue: Double dispid 17;
    property cvSupplier: WideString dispid 18;
  end;

// *********************************************************************//
// Interface: ICOMEmployee
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B261653B-0A89-4A75-B7A3-7CE41DF0E1E6}
// *********************************************************************//
  ICOMEmployee = interface(IDispatch)
    ['{B261653B-0A89-4A75-B7A3-7CE41DF0E1E6}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_emCode: WideString; safecall;
    procedure Set_emCode(const Value: WideString); safecall;
    function Get_emSupplier: WideString; safecall;
    procedure Set_emSupplier(const Value: WideString); safecall;
    function Get_emName: WideString; safecall;
    procedure Set_emName(const Value: WideString); safecall;
    function Get_emAddress(Index: Integer): WideString; safecall;
    procedure Set_emAddress(Index: Integer; const Value: WideString); safecall;
    function Get_emPhone: WideString; safecall;
    procedure Set_emPhone(const Value: WideString); safecall;
    function Get_emFax: WideString; safecall;
    procedure Set_emFax(const Value: WideString); safecall;
    function Get_emMobile: WideString; safecall;
    procedure Set_emMobile(const Value: WideString); safecall;
    function Get_emType: Integer; safecall;
    procedure Set_emType(Value: Integer); safecall;
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
    function Get_emUserField3: WideString; safecall;
    procedure Set_emUserField3(const Value: WideString); safecall;
    function Get_emUserField4: WideString; safecall;
    procedure Set_emUserField4(const Value: WideString); safecall;
    function Get_emCostCentre: WideString; safecall;
    procedure Set_emCostCentre(const Value: WideString); safecall;
    function Get_emDepartment: WideString; safecall;
    procedure Set_emDepartment(const Value: WideString); safecall;
    function Get_emOwnTimeRatesOnly: WordBool; safecall;
    procedure Set_emOwnTimeRatesOnly(Value: WordBool); safecall;
    function Get_emSelfBilling: WordBool; safecall;
    procedure Set_emSelfBilling(Value: WordBool); safecall;
    function Get_emGroupCertificate: WordBool; safecall;
    procedure Set_emGroupCertificate(Value: WordBool); safecall;
    function Get_emCertificateType: Integer; safecall;
    procedure Set_emCertificateType(Value: Integer); safecall;
    function Get_emNationalInsuranceNo: WideString; safecall;
    procedure Set_emNationalInsuranceNo(const Value: WideString); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property emCode: WideString read Get_emCode write Set_emCode;
    property emSupplier: WideString read Get_emSupplier write Set_emSupplier;
    property emName: WideString read Get_emName write Set_emName;
    property emAddress[Index: Integer]: WideString read Get_emAddress write Set_emAddress;
    property emPhone: WideString read Get_emPhone write Set_emPhone;
    property emFax: WideString read Get_emFax write Set_emFax;
    property emMobile: WideString read Get_emMobile write Set_emMobile;
    property emType: Integer read Get_emType write Set_emType;
    property emPayrollNumber: WideString read Get_emPayrollNumber write Set_emPayrollNumber;
    property emCertificateNumber: WideString read Get_emCertificateNumber write Set_emCertificateNumber;
    property emCertificateExpiry: WideString read Get_emCertificateExpiry write Set_emCertificateExpiry;
    property emUserField1: WideString read Get_emUserField1 write Set_emUserField1;
    property emUserField2: WideString read Get_emUserField2 write Set_emUserField2;
    property emUserField3: WideString read Get_emUserField3 write Set_emUserField3;
    property emUserField4: WideString read Get_emUserField4 write Set_emUserField4;
    property emCostCentre: WideString read Get_emCostCentre write Set_emCostCentre;
    property emDepartment: WideString read Get_emDepartment write Set_emDepartment;
    property emOwnTimeRatesOnly: WordBool read Get_emOwnTimeRatesOnly write Set_emOwnTimeRatesOnly;
    property emSelfBilling: WordBool read Get_emSelfBilling write Set_emSelfBilling;
    property emGroupCertificate: WordBool read Get_emGroupCertificate write Set_emGroupCertificate;
    property emCertificateType: Integer read Get_emCertificateType write Set_emCertificateType;
    property emNationalInsuranceNo: WideString read Get_emNationalInsuranceNo write Set_emNationalInsuranceNo;
  end;

// *********************************************************************//
// DispIntf:  ICOMEmployeeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B261653B-0A89-4A75-B7A3-7CE41DF0E1E6}
// *********************************************************************//
  ICOMEmployeeDisp = dispinterface
    ['{B261653B-0A89-4A75-B7A3-7CE41DF0E1E6}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property emCode: WideString dispid 2;
    property emSupplier: WideString dispid 3;
    property emName: WideString dispid 4;
    property emAddress[Index: Integer]: WideString dispid 5;
    property emPhone: WideString dispid 6;
    property emFax: WideString dispid 7;
    property emMobile: WideString dispid 8;
    property emType: Integer dispid 9;
    property emPayrollNumber: WideString dispid 10;
    property emCertificateNumber: WideString dispid 11;
    property emCertificateExpiry: WideString dispid 12;
    property emUserField1: WideString dispid 13;
    property emUserField2: WideString dispid 14;
    property emUserField3: WideString dispid 15;
    property emUserField4: WideString dispid 16;
    property emCostCentre: WideString dispid 17;
    property emDepartment: WideString dispid 18;
    property emOwnTimeRatesOnly: WordBool dispid 19;
    property emSelfBilling: WordBool dispid 20;
    property emGroupCertificate: WordBool dispid 21;
    property emCertificateType: Integer dispid 22;
    property emNationalInsuranceNo: WideString dispid 23;
  end;

// *********************************************************************//
// Interface: ICOMJob2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {321B4CA3-D591-409B-820F-1A617B9221F8}
// *********************************************************************//
  ICOMJob2 = interface(ICOMJob)
    ['{321B4CA3-D591-409B-820F-1A617B9221F8}']
    function Get_jrActual: ICOMJobActual; safecall;
    function Get_jrBudget: ICOMJobBudget; safecall;
    function Get_jrRetention: ICOMJobRetention; safecall;
    property jrActual: ICOMJobActual read Get_jrActual;
    property jrBudget: ICOMJobBudget read Get_jrBudget;
    property jrRetention: ICOMJobRetention read Get_jrRetention;
  end;

// *********************************************************************//
// DispIntf:  ICOMJob2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {321B4CA3-D591-409B-820F-1A617B9221F8}
// *********************************************************************//
  ICOMJob2Disp = dispinterface
    ['{321B4CA3-D591-409B-820F-1A617B9221F8}']
    property jrActual: ICOMJobActual readonly dispid 27;
    property jrBudget: ICOMJobBudget readonly dispid 28;
    property jrRetention: ICOMJobRetention readonly dispid 29;
    property jrJobCode: WideString dispid 1;
    property jrJobDesc: WideString dispid 2;
    property jrJobFolio: Integer readonly dispid 3;
    property jrCustCode: WideString dispid 4;
    property jrJobCat: WideString dispid 5;
    property jrJobAltCode: WideString dispid 6;
    property jrCompleted: Integer dispid 7;
    property jrContact: WideString dispid 8;
    property jrJobMan: WideString dispid 9;
    property jrChargeType: Smallint dispid 10;
    property jrQuotePrice: Double dispid 11;
    property jrCurrPrice: Smallint dispid 12;
    property jrStartDate: WideString dispid 13;
    property jrEndDate: WideString dispid 14;
    property jrRevEDate: WideString dispid 15;
    property jrSORRef: WideString dispid 16;
    property jrVATCode: WideString dispid 17;
    property jrDept: WideString dispid 18;
    property jrCostCentre: WideString dispid 19;
    property jrJobAnal: WideString dispid 20;
    property jrJobType: WideString dispid 21;
    property jrJobStat: Integer dispid 22;
    property jrUserDef1: WideString dispid 23;
    property jrUserDef2: WideString dispid 24;
    property jrUserDef3: WideString dispid 25;
    property jrUserDef4: WideString dispid 26;
  end;

// *********************************************************************//
// Interface: ICOMJobActual
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {78E06513-49E4-4EC0-AEFF-764FF0E328D4}
// *********************************************************************//
  ICOMJobActual = interface(IDispatch)
    ['{78E06513-49E4-4EC0-AEFF-764FF0E328D4}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_jaAnalysisCode: WideString; safecall;
    procedure Set_jaAnalysisCode(const Value: WideString); safecall;
    function Get_jaCurrency: Integer; safecall;
    procedure Set_jaCurrency(Value: Integer); safecall;
    function Get_jaPeriod: Integer; safecall;
    procedure Set_jaPeriod(Value: Integer); safecall;
    function Get_jaPosted: WordBool; safecall;
    procedure Set_jaPosted(Value: WordBool); safecall;
    function Get_jaLineFolio: Integer; safecall;
    procedure Set_jaLineFolio(Value: Integer); safecall;
    function Get_jaLineNumber: Integer; safecall;
    procedure Set_jaLineNumber(Value: Integer); safecall;
    function Get_jaDocRef: WideString; safecall;
    procedure Set_jaDocRef(const Value: WideString); safecall;
    function Get_jaStockCode: WideString; safecall;
    procedure Set_jaStockCode(const Value: WideString); safecall;
    function Get_jaDate: WideString; safecall;
    procedure Set_jaDate(const Value: WideString); safecall;
    function Get_jaQty: Double; safecall;
    procedure Set_jaQty(Value: Double); safecall;
    function Get_jaCost: Double; safecall;
    procedure Set_jaCost(Value: Double); safecall;
    function Get_jaCharge: Double; safecall;
    procedure Set_jaCharge(Value: Double); safecall;
    function Get_jaInvoiced: WordBool; safecall;
    procedure Set_jaInvoiced(Value: WordBool); safecall;
    function Get_jaInvoiceRef: WideString; safecall;
    procedure Set_jaInvoiceRef(const Value: WideString); safecall;
    function Get_jaEmployeeCode: WideString; safecall;
    procedure Set_jaEmployeeCode(const Value: WideString); safecall;
    function Get_jaAnalysisType: Integer; safecall;
    procedure Set_jaAnalysisType(Value: Integer); safecall;
    function Get_jaPostedRun: Integer; safecall;
    procedure Set_jaPostedRun(Value: Integer); safecall;
    function Get_jaReverseWIP: WordBool; safecall;
    procedure Set_jaReverseWIP(Value: WordBool); safecall;
    function Get_jaReconciled: WordBool; safecall;
    procedure Set_jaReconciled(Value: WordBool); safecall;
    function Get_jaDocType: TDocTypes; safecall;
    procedure Set_jaDocType(Value: TDocTypes); safecall;
    function Get_jaChargeCurrency: Integer; safecall;
    procedure Set_jaChargeCurrency(Value: Integer); safecall;
    function Get_jaAccountCode: WideString; safecall;
    procedure Set_jaAccountCode(const Value: WideString); safecall;
    function Get_jaHoldFlag: Integer; safecall;
    procedure Set_jaHoldFlag(Value: Integer); safecall;
    function Get_jaPostedToStock: WordBool; safecall;
    procedure Set_jaPostedToStock(Value: WordBool); safecall;
    function Get_jaCompanyRate: Double; safecall;
    procedure Set_jaCompanyRate(Value: Double); safecall;
    function Get_jaDailyRate: Double; safecall;
    procedure Set_jaDailyRate(Value: Double); safecall;
    function Get_jaTagged: WordBool; safecall;
    procedure Set_jaTagged(Value: WordBool); safecall;
    function Get_jaGLCode: Integer; safecall;
    procedure Set_jaGLCode(Value: Integer); safecall;
    function Get_jaUseORate: Integer; safecall;
    procedure Set_jaUseORate(Value: Integer); safecall;
    function Get_jaTriangulation: ICOMCurrencyTriangulation; safecall;
    function Get_jaPriceMultiplier: Double; safecall;
    procedure Set_jaPriceMultiplier(Value: Double); safecall;
    function Get_jaYear: Integer; safecall;
    procedure Set_jaYear(Value: Integer); safecall;
    function Get_jaUpliftTotal: Double; safecall;
    procedure Set_jaUpliftTotal(Value: Double); safecall;
    function Get_jaUpliftGL: Integer; safecall;
    procedure Set_jaUpliftGL(Value: Integer); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property jaAnalysisCode: WideString read Get_jaAnalysisCode write Set_jaAnalysisCode;
    property jaCurrency: Integer read Get_jaCurrency write Set_jaCurrency;
    property jaPeriod: Integer read Get_jaPeriod write Set_jaPeriod;
    property jaPosted: WordBool read Get_jaPosted write Set_jaPosted;
    property jaLineFolio: Integer read Get_jaLineFolio write Set_jaLineFolio;
    property jaLineNumber: Integer read Get_jaLineNumber write Set_jaLineNumber;
    property jaDocRef: WideString read Get_jaDocRef write Set_jaDocRef;
    property jaStockCode: WideString read Get_jaStockCode write Set_jaStockCode;
    property jaDate: WideString read Get_jaDate write Set_jaDate;
    property jaQty: Double read Get_jaQty write Set_jaQty;
    property jaCost: Double read Get_jaCost write Set_jaCost;
    property jaCharge: Double read Get_jaCharge write Set_jaCharge;
    property jaInvoiced: WordBool read Get_jaInvoiced write Set_jaInvoiced;
    property jaInvoiceRef: WideString read Get_jaInvoiceRef write Set_jaInvoiceRef;
    property jaEmployeeCode: WideString read Get_jaEmployeeCode write Set_jaEmployeeCode;
    property jaAnalysisType: Integer read Get_jaAnalysisType write Set_jaAnalysisType;
    property jaPostedRun: Integer read Get_jaPostedRun write Set_jaPostedRun;
    property jaReverseWIP: WordBool read Get_jaReverseWIP write Set_jaReverseWIP;
    property jaReconciled: WordBool read Get_jaReconciled write Set_jaReconciled;
    property jaDocType: TDocTypes read Get_jaDocType write Set_jaDocType;
    property jaChargeCurrency: Integer read Get_jaChargeCurrency write Set_jaChargeCurrency;
    property jaAccountCode: WideString read Get_jaAccountCode write Set_jaAccountCode;
    property jaHoldFlag: Integer read Get_jaHoldFlag write Set_jaHoldFlag;
    property jaPostedToStock: WordBool read Get_jaPostedToStock write Set_jaPostedToStock;
    property jaCompanyRate: Double read Get_jaCompanyRate write Set_jaCompanyRate;
    property jaDailyRate: Double read Get_jaDailyRate write Set_jaDailyRate;
    property jaTagged: WordBool read Get_jaTagged write Set_jaTagged;
    property jaGLCode: Integer read Get_jaGLCode write Set_jaGLCode;
    property jaUseORate: Integer read Get_jaUseORate write Set_jaUseORate;
    property jaTriangulation: ICOMCurrencyTriangulation read Get_jaTriangulation;
    property jaPriceMultiplier: Double read Get_jaPriceMultiplier write Set_jaPriceMultiplier;
    property jaYear: Integer read Get_jaYear write Set_jaYear;
    property jaUpliftTotal: Double read Get_jaUpliftTotal write Set_jaUpliftTotal;
    property jaUpliftGL: Integer read Get_jaUpliftGL write Set_jaUpliftGL;
  end;

// *********************************************************************//
// DispIntf:  ICOMJobActualDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {78E06513-49E4-4EC0-AEFF-764FF0E328D4}
// *********************************************************************//
  ICOMJobActualDisp = dispinterface
    ['{78E06513-49E4-4EC0-AEFF-764FF0E328D4}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property jaAnalysisCode: WideString dispid 2;
    property jaCurrency: Integer dispid 3;
    property jaPeriod: Integer dispid 4;
    property jaPosted: WordBool dispid 5;
    property jaLineFolio: Integer dispid 6;
    property jaLineNumber: Integer dispid 7;
    property jaDocRef: WideString dispid 8;
    property jaStockCode: WideString dispid 9;
    property jaDate: WideString dispid 10;
    property jaQty: Double dispid 11;
    property jaCost: Double dispid 12;
    property jaCharge: Double dispid 13;
    property jaInvoiced: WordBool dispid 14;
    property jaInvoiceRef: WideString dispid 15;
    property jaEmployeeCode: WideString dispid 16;
    property jaAnalysisType: Integer dispid 17;
    property jaPostedRun: Integer dispid 18;
    property jaReverseWIP: WordBool dispid 19;
    property jaReconciled: WordBool dispid 20;
    property jaDocType: TDocTypes dispid 21;
    property jaChargeCurrency: Integer dispid 22;
    property jaAccountCode: WideString dispid 23;
    property jaHoldFlag: Integer dispid 25;
    property jaPostedToStock: WordBool dispid 26;
    property jaCompanyRate: Double dispid 27;
    property jaDailyRate: Double dispid 28;
    property jaTagged: WordBool dispid 29;
    property jaGLCode: Integer dispid 30;
    property jaUseORate: Integer dispid 31;
    property jaTriangulation: ICOMCurrencyTriangulation readonly dispid 32;
    property jaPriceMultiplier: Double dispid 33;
    property jaYear: Integer dispid 34;
    property jaUpliftTotal: Double dispid 35;
    property jaUpliftGL: Integer dispid 36;
  end;

// *********************************************************************//
// Interface: ICOMCurrencyTriangulation
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2618516C-D331-4720-A585-1949E44C9C6A}
// *********************************************************************//
  ICOMCurrencyTriangulation = interface(IDispatch)
    ['{2618516C-D331-4720-A585-1949E44C9C6A}']
    function Get_tcRate: Double; safecall;
    procedure Set_tcRate(Value: Double); safecall;
    function Get_tcEuro: Integer; safecall;
    procedure Set_tcEuro(Value: Integer); safecall;
    function Get_tcInvert: WordBool; safecall;
    procedure Set_tcInvert(Value: WordBool); safecall;
    function Get_tcFloat: WordBool; safecall;
    procedure Set_tcFloat(Value: WordBool); safecall;
    property tcRate: Double read Get_tcRate write Set_tcRate;
    property tcEuro: Integer read Get_tcEuro write Set_tcEuro;
    property tcInvert: WordBool read Get_tcInvert write Set_tcInvert;
    property tcFloat: WordBool read Get_tcFloat write Set_tcFloat;
  end;

// *********************************************************************//
// DispIntf:  ICOMCurrencyTriangulationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2618516C-D331-4720-A585-1949E44C9C6A}
// *********************************************************************//
  ICOMCurrencyTriangulationDisp = dispinterface
    ['{2618516C-D331-4720-A585-1949E44C9C6A}']
    property tcRate: Double dispid 1;
    property tcEuro: Integer dispid 2;
    property tcInvert: WordBool dispid 3;
    property tcFloat: WordBool dispid 4;
  end;

// *********************************************************************//
// Interface: ICOMJobBudget
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {98376108-E871-42C4-ADFB-67E69CBE4CD0}
// *********************************************************************//
  ICOMJobBudget = interface(IDispatch)
    ['{98376108-E871-42C4-ADFB-67E69CBE4CD0}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_jbType: Integer; safecall;
    procedure Set_jbType(Value: Integer); safecall;
    function Get_jbUnitPrice: Double; safecall;
    procedure Set_jbUnitPrice(Value: Double); safecall;
    function Get_jbOriginalQty: Double; safecall;
    procedure Set_jbOriginalQty(Value: Double); safecall;
    function Get_jbRevisedQty: Double; safecall;
    procedure Set_jbRevisedQty(Value: Double); safecall;
    function Get_jbOriginalValue: Double; safecall;
    procedure Set_jbOriginalValue(Value: Double); safecall;
    function Get_jbRevisedValue: Double; safecall;
    procedure Set_jbRevisedValue(Value: Double); safecall;
    function Get_jbOriginalValuation: Double; safecall;
    procedure Set_jbOriginalValuation(Value: Double); safecall;
    function Get_jbRevisedValuation: Double; safecall;
    procedure Set_jbRevisedValuation(Value: Double); safecall;
    function Get_jbUplift: Double; safecall;
    procedure Set_jbUplift(Value: Double); safecall;
    function Get_jbBudgetType: Integer; safecall;
    procedure Set_jbBudgetType(Value: Integer); safecall;
    function Get_jbJobCode: WideString; safecall;
    procedure Set_jbJobCode(const Value: WideString); safecall;
    function Get_jbStockCode: WideString; safecall;
    procedure Set_jbStockCode(const Value: WideString); safecall;
    function Get_jbAnalysisCode: WideString; safecall;
    procedure Set_jbAnalysisCode(const Value: WideString); safecall;
    function Get_jbRecharge: WordBool; safecall;
    procedure Set_jbRecharge(Value: WordBool); safecall;
    function Get_jbCostOverhead: Double; safecall;
    procedure Set_jbCostOverhead(Value: Double); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property jbType: Integer read Get_jbType write Set_jbType;
    property jbUnitPrice: Double read Get_jbUnitPrice write Set_jbUnitPrice;
    property jbOriginalQty: Double read Get_jbOriginalQty write Set_jbOriginalQty;
    property jbRevisedQty: Double read Get_jbRevisedQty write Set_jbRevisedQty;
    property jbOriginalValue: Double read Get_jbOriginalValue write Set_jbOriginalValue;
    property jbRevisedValue: Double read Get_jbRevisedValue write Set_jbRevisedValue;
    property jbOriginalValuation: Double read Get_jbOriginalValuation write Set_jbOriginalValuation;
    property jbRevisedValuation: Double read Get_jbRevisedValuation write Set_jbRevisedValuation;
    property jbUplift: Double read Get_jbUplift write Set_jbUplift;
    property jbBudgetType: Integer read Get_jbBudgetType write Set_jbBudgetType;
    property jbJobCode: WideString read Get_jbJobCode write Set_jbJobCode;
    property jbStockCode: WideString read Get_jbStockCode write Set_jbStockCode;
    property jbAnalysisCode: WideString read Get_jbAnalysisCode write Set_jbAnalysisCode;
    property jbRecharge: WordBool read Get_jbRecharge write Set_jbRecharge;
    property jbCostOverhead: Double read Get_jbCostOverhead write Set_jbCostOverhead;
  end;

// *********************************************************************//
// DispIntf:  ICOMJobBudgetDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {98376108-E871-42C4-ADFB-67E69CBE4CD0}
// *********************************************************************//
  ICOMJobBudgetDisp = dispinterface
    ['{98376108-E871-42C4-ADFB-67E69CBE4CD0}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property jbType: Integer dispid 2;
    property jbUnitPrice: Double dispid 3;
    property jbOriginalQty: Double dispid 4;
    property jbRevisedQty: Double dispid 5;
    property jbOriginalValue: Double dispid 6;
    property jbRevisedValue: Double dispid 7;
    property jbOriginalValuation: Double dispid 8;
    property jbRevisedValuation: Double dispid 9;
    property jbUplift: Double dispid 10;
    property jbBudgetType: Integer dispid 11;
    property jbJobCode: WideString dispid 12;
    property jbStockCode: WideString dispid 13;
    property jbAnalysisCode: WideString dispid 14;
    property jbRecharge: WordBool dispid 15;
    property jbCostOverhead: Double dispid 16;
  end;

// *********************************************************************//
// Interface: ICOMJobRetention
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FEFDBBF0-8C82-464A-9AD7-71C01BB19112}
// *********************************************************************//
  ICOMJobRetention = interface(IDispatch)
    ['{FEFDBBF0-8C82-464A-9AD7-71C01BB19112}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_jrtAnalysisCode: WideString; safecall;
    procedure Set_jrtAnalysisCode(const Value: WideString); safecall;
    function Get_jrtOriginalCurrency: Integer; safecall;
    procedure Set_jrtOriginalCurrency(Value: Integer); safecall;
    function Get_jrtYear: Integer; safecall;
    procedure Set_jrtYear(Value: Integer); safecall;
    function Get_jrtPeriod: Integer; safecall;
    procedure Set_jrtPeriod(Value: Integer); safecall;
    function Get_jrtPosted: WordBool; safecall;
    procedure Set_jrtPosted(Value: WordBool); safecall;
    function Get_jrtPercent: Double; safecall;
    procedure Set_jrtPercent(Value: Double); safecall;
    function Get_jrtCurrency: Integer; safecall;
    procedure Set_jrtCurrency(Value: Integer); safecall;
    function Get_jrtValue: Double; safecall;
    procedure Set_jrtValue(Value: Double); safecall;
    function Get_jrtJobCode: WideString; safecall;
    procedure Set_jrtJobCode(const Value: WideString); safecall;
    function Get_jrtCreditDoc: WideString; safecall;
    procedure Set_jrtCreditDoc(const Value: WideString); safecall;
    function Get_jrtExpiryDate: WideString; safecall;
    procedure Set_jrtExpiryDate(const Value: WideString); safecall;
    function Get_jrtInvoiced: WordBool; safecall;
    procedure Set_jrtInvoiced(Value: WordBool); safecall;
    function Get_jrtAcCode: WideString; safecall;
    procedure Set_jrtAcCode(const Value: WideString); safecall;
    function Get_jrtEntryDate: WideString; safecall;
    procedure Set_jrtEntryDate(const Value: WideString); safecall;
    function Get_jrtCostCentre: WideString; safecall;
    procedure Set_jrtCostCentre(const Value: WideString); safecall;
    function Get_jrtDepartment: WideString; safecall;
    procedure Set_jrtDepartment(const Value: WideString); safecall;
    function Get_jrtDefVATCode: WideString; safecall;
    procedure Set_jrtDefVATCode(const Value: WideString); safecall;
    function Get_jrtTransaction: WideString; safecall;
    procedure Set_jrtTransaction(const Value: WideString); safecall;
    function Get_jrtCISTax: Double; safecall;
    procedure Set_jrtCISTax(Value: Double); safecall;
    function Get_jrtCISGross: Double; safecall;
    procedure Set_jrtCISGross(Value: Double); safecall;
    function Get_jrtCISEmployee: WideString; safecall;
    procedure Set_jrtCISEmployee(const Value: WideString); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property jrtAnalysisCode: WideString read Get_jrtAnalysisCode write Set_jrtAnalysisCode;
    property jrtOriginalCurrency: Integer read Get_jrtOriginalCurrency write Set_jrtOriginalCurrency;
    property jrtYear: Integer read Get_jrtYear write Set_jrtYear;
    property jrtPeriod: Integer read Get_jrtPeriod write Set_jrtPeriod;
    property jrtPosted: WordBool read Get_jrtPosted write Set_jrtPosted;
    property jrtPercent: Double read Get_jrtPercent write Set_jrtPercent;
    property jrtCurrency: Integer read Get_jrtCurrency write Set_jrtCurrency;
    property jrtValue: Double read Get_jrtValue write Set_jrtValue;
    property jrtJobCode: WideString read Get_jrtJobCode write Set_jrtJobCode;
    property jrtCreditDoc: WideString read Get_jrtCreditDoc write Set_jrtCreditDoc;
    property jrtExpiryDate: WideString read Get_jrtExpiryDate write Set_jrtExpiryDate;
    property jrtInvoiced: WordBool read Get_jrtInvoiced write Set_jrtInvoiced;
    property jrtAcCode: WideString read Get_jrtAcCode write Set_jrtAcCode;
    property jrtEntryDate: WideString read Get_jrtEntryDate write Set_jrtEntryDate;
    property jrtCostCentre: WideString read Get_jrtCostCentre write Set_jrtCostCentre;
    property jrtDepartment: WideString read Get_jrtDepartment write Set_jrtDepartment;
    property jrtDefVATCode: WideString read Get_jrtDefVATCode write Set_jrtDefVATCode;
    property jrtTransaction: WideString read Get_jrtTransaction write Set_jrtTransaction;
    property jrtCISTax: Double read Get_jrtCISTax write Set_jrtCISTax;
    property jrtCISGross: Double read Get_jrtCISGross write Set_jrtCISGross;
    property jrtCISEmployee: WideString read Get_jrtCISEmployee write Set_jrtCISEmployee;
  end;

// *********************************************************************//
// DispIntf:  ICOMJobRetentionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FEFDBBF0-8C82-464A-9AD7-71C01BB19112}
// *********************************************************************//
  ICOMJobRetentionDisp = dispinterface
    ['{FEFDBBF0-8C82-464A-9AD7-71C01BB19112}']
    property AccessRights: TRecordAccessStatus readonly dispid 2;
    property jrtAnalysisCode: WideString dispid 3;
    property jrtOriginalCurrency: Integer dispid 4;
    property jrtYear: Integer dispid 5;
    property jrtPeriod: Integer dispid 6;
    property jrtPosted: WordBool dispid 7;
    property jrtPercent: Double dispid 8;
    property jrtCurrency: Integer dispid 9;
    property jrtValue: Double dispid 10;
    property jrtJobCode: WideString dispid 11;
    property jrtCreditDoc: WideString dispid 12;
    property jrtExpiryDate: WideString dispid 13;
    property jrtInvoiced: WordBool dispid 14;
    property jrtAcCode: WideString dispid 15;
    property jrtEntryDate: WideString dispid 17;
    property jrtCostCentre: WideString dispid 18;
    property jrtDepartment: WideString dispid 19;
    property jrtDefVATCode: WideString dispid 20;
    property jrtTransaction: WideString dispid 21;
    property jrtCISTax: Double dispid 22;
    property jrtCISGross: Double dispid 23;
    property jrtCISEmployee: WideString dispid 24;
  end;

// *********************************************************************//
// Interface: ICOMJobAnalysis
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EC6592D4-B162-4EF1-B926-E87C39746DE6}
// *********************************************************************//
  ICOMJobAnalysis = interface(IDispatch)
    ['{EC6592D4-B162-4EF1-B926-E87C39746DE6}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_anCode: WideString; safecall;
    procedure Set_anCode(const Value: WideString); safecall;
    function Get_anDescription: WideString; safecall;
    procedure Set_anDescription(const Value: WideString); safecall;
    function Get_anType: Integer; safecall;
    procedure Set_anType(Value: Integer); safecall;
    function Get_anCategory: Integer; safecall;
    procedure Set_anCategory(Value: Integer); safecall;
    function Get_anWIPGL: Integer; safecall;
    procedure Set_anWIPGL(Value: Integer); safecall;
    function Get_anPandLGL: Integer; safecall;
    procedure Set_anPandLGL(Value: Integer); safecall;
    function Get_anLineType: Integer; safecall;
    procedure Set_anLineType(Value: Integer); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property anCode: WideString read Get_anCode write Set_anCode;
    property anDescription: WideString read Get_anDescription write Set_anDescription;
    property anType: Integer read Get_anType write Set_anType;
    property anCategory: Integer read Get_anCategory write Set_anCategory;
    property anWIPGL: Integer read Get_anWIPGL write Set_anWIPGL;
    property anPandLGL: Integer read Get_anPandLGL write Set_anPandLGL;
    property anLineType: Integer read Get_anLineType write Set_anLineType;
  end;

// *********************************************************************//
// DispIntf:  ICOMJobAnalysisDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EC6592D4-B162-4EF1-B926-E87C39746DE6}
// *********************************************************************//
  ICOMJobAnalysisDisp = dispinterface
    ['{EC6592D4-B162-4EF1-B926-E87C39746DE6}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property anCode: WideString dispid 2;
    property anDescription: WideString dispid 3;
    property anType: Integer dispid 4;
    property anCategory: Integer dispid 5;
    property anWIPGL: Integer dispid 6;
    property anPandLGL: Integer dispid 7;
    property anLineType: Integer dispid 8;
  end;

// *********************************************************************//
// Interface: ICOMTimeRate
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {027222A0-90BA-4D78-A03B-1A3C363BA335}
// *********************************************************************//
  ICOMTimeRate = interface(IDispatch)
    ['{027222A0-90BA-4D78-A03B-1A3C363BA335}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_trRateCode: WideString; safecall;
    procedure Set_trRateCode(const Value: WideString); safecall;
    function Get_trEmployeeCode: WideString; safecall;
    procedure Set_trEmployeeCode(const Value: WideString); safecall;
    function Get_trCostCurrency: Integer; safecall;
    procedure Set_trCostCurrency(Value: Integer); safecall;
    function Get_trTimeCost: Double; safecall;
    procedure Set_trTimeCost(Value: Double); safecall;
    function Get_trChargeCurrency: Integer; safecall;
    procedure Set_trChargeCurrency(Value: Integer); safecall;
    function Get_trTimeCharge: Double; safecall;
    procedure Set_trTimeCharge(Value: Double); safecall;
    function Get_trAnalysisCode: WideString; safecall;
    procedure Set_trAnalysisCode(const Value: WideString); safecall;
    function Get_trDescription: WideString; safecall;
    procedure Set_trDescription(const Value: WideString); safecall;
    function Get_trPayFactor: Integer; safecall;
    procedure Set_trPayFactor(Value: Integer); safecall;
    function Get_trPayRate: Integer; safecall;
    procedure Set_trPayRate(Value: Integer); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property trRateCode: WideString read Get_trRateCode write Set_trRateCode;
    property trEmployeeCode: WideString read Get_trEmployeeCode write Set_trEmployeeCode;
    property trCostCurrency: Integer read Get_trCostCurrency write Set_trCostCurrency;
    property trTimeCost: Double read Get_trTimeCost write Set_trTimeCost;
    property trChargeCurrency: Integer read Get_trChargeCurrency write Set_trChargeCurrency;
    property trTimeCharge: Double read Get_trTimeCharge write Set_trTimeCharge;
    property trAnalysisCode: WideString read Get_trAnalysisCode write Set_trAnalysisCode;
    property trDescription: WideString read Get_trDescription write Set_trDescription;
    property trPayFactor: Integer read Get_trPayFactor write Set_trPayFactor;
    property trPayRate: Integer read Get_trPayRate write Set_trPayRate;
  end;

// *********************************************************************//
// DispIntf:  ICOMTimeRateDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {027222A0-90BA-4D78-A03B-1A3C363BA335}
// *********************************************************************//
  ICOMTimeRateDisp = dispinterface
    ['{027222A0-90BA-4D78-A03B-1A3C363BA335}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property trRateCode: WideString dispid 2;
    property trEmployeeCode: WideString dispid 3;
    property trCostCurrency: Integer dispid 4;
    property trTimeCost: Double dispid 5;
    property trChargeCurrency: Integer dispid 6;
    property trTimeCharge: Double dispid 7;
    property trAnalysisCode: WideString dispid 8;
    property trDescription: WideString dispid 9;
    property trPayFactor: Integer dispid 10;
    property trPayRate: Integer dispid 11;
  end;

// *********************************************************************//
// Interface: ICOMEmployee2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F393D401-B2BE-4776-BBF0-46F9FA5E26FD}
// *********************************************************************//
  ICOMEmployee2 = interface(ICOMEmployee)
    ['{F393D401-B2BE-4776-BBF0-46F9FA5E26FD}']
    function Get_emLabourViaPL: WordBool; safecall;
    procedure Set_emLabourViaPL(Value: WordBool); safecall;
    property emLabourViaPL: WordBool read Get_emLabourViaPL write Set_emLabourViaPL;
  end;

// *********************************************************************//
// DispIntf:  ICOMEmployee2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F393D401-B2BE-4776-BBF0-46F9FA5E26FD}
// *********************************************************************//
  ICOMEmployee2Disp = dispinterface
    ['{F393D401-B2BE-4776-BBF0-46F9FA5E26FD}']
    property emLabourViaPL: WordBool dispid 24;
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property emCode: WideString dispid 2;
    property emSupplier: WideString dispid 3;
    property emName: WideString dispid 4;
    property emAddress[Index: Integer]: WideString dispid 5;
    property emPhone: WideString dispid 6;
    property emFax: WideString dispid 7;
    property emMobile: WideString dispid 8;
    property emType: Integer dispid 9;
    property emPayrollNumber: WideString dispid 10;
    property emCertificateNumber: WideString dispid 11;
    property emCertificateExpiry: WideString dispid 12;
    property emUserField1: WideString dispid 13;
    property emUserField2: WideString dispid 14;
    property emUserField3: WideString dispid 15;
    property emUserField4: WideString dispid 16;
    property emCostCentre: WideString dispid 17;
    property emDepartment: WideString dispid 18;
    property emOwnTimeRatesOnly: WordBool dispid 19;
    property emSelfBilling: WordBool dispid 20;
    property emGroupCertificate: WordBool dispid 21;
    property emCertificateType: Integer dispid 22;
    property emNationalInsuranceNo: WideString dispid 23;
  end;

// *********************************************************************//
// Interface: ICOMTransactionLine3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E7C63D20-AA70-4212-9574-6F7EC2B2EC18}
// *********************************************************************//
  ICOMTransactionLine3 = interface(ICOMTransactionLine2)
    ['{E7C63D20-AA70-4212-9574-6F7EC2B2EC18}']
    function Get_tlNOMVATType: TNOMLineVATType; safecall;
    procedure Set_tlNOMVATType(Value: TNOMLineVATType); safecall;
    property tlNOMVATType: TNOMLineVATType read Get_tlNOMVATType write Set_tlNOMVATType;
  end;

// *********************************************************************//
// DispIntf:  ICOMTransactionLine3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E7C63D20-AA70-4212-9574-6F7EC2B2EC18}
// *********************************************************************//
  ICOMTransactionLine3Disp = dispinterface
    ['{E7C63D20-AA70-4212-9574-6F7EC2B2EC18}']
    property tlNOMVATType: TNOMLineVATType dispid 67;
    property tlLineSource: Integer dispid 62;
    property tlCISRateCode: WideString dispid 63;
    property tlCISRate: Double dispid 64;
    property tlCostApport: Double dispid 65;
    property tlVATInclValue: Double dispid 66;
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property tlFolio: Integer dispid 3;
    property tlLinePos: Integer dispid 4;
    property tlRunNo: Integer dispid 5;
    property tlGLCode: Integer dispid 6;
    property tlShowInGL: Smallint dispid 7;
    property tlCurrency: TCurrencyType dispid 8;
    property tlYear: Smallint readonly dispid 9;
    property tlPeriod: Smallint readonly dispid 10;
    property tlCostCentre: WideString dispid 11;
    property tlDepartment: WideString dispid 12;
    property tlStockCode: WideString dispid 13;
    property tlLineNo: Integer dispid 14;
    property tlLineClass: WideString readonly dispid 15;
    property tlDocType: TDocTypes readonly dispid 16;
    property tlQty: Double dispid 17;
    property tlQtyMul: Double dispid 18;
    property tlNetValue: Double dispid 19;
    property tlDiscount: Double dispid 20;
    property tlVATCode: WideString dispid 21;
    property tlVATAmount: Double dispid 22;
    property tlPayStatus: WideString dispid 23;
    property tlPrevGLBal: Double dispid 24;
    property tlRecStatus: Smallint dispid 25;
    property tlDiscFlag: WideString dispid 26;
    property tlQtyWOFF: Double dispid 27;
    property tlQtyDel: Double dispid 28;
    property tlCost: Double dispid 29;
    property tlAcCode: WideString readonly dispid 30;
    property tlTransDate: WideString dispid 31;
    property tlItemNo: WideString dispid 32;
    property tlDescr: WideString dispid 33;
    property tlJobCode: WideString dispid 34;
    property tlJobAnal: WideString dispid 35;
    property tlCompanyRate: Double dispid 36;
    property tlDailyRate: Double dispid 37;
    property tlUnitWeight: Double dispid 38;
    property tlStockDeductQty: Double dispid 39;
    property tlBOMKitLink: Integer dispid 40;
    property tlOrderFolio: Integer dispid 41;
    property tlOrderLineNo: Integer dispid 42;
    property tlLocation: WideString dispid 43;
    property tlQtyPicked: Double dispid 44;
    property tlQtyPickedWO: Double dispid 45;
    property tlUseQtyMul: WordBool dispid 46;
    property tlNoSerialNos: Double dispid 47;
    property tlCOSGL: Integer dispid 48;
    property tlOurRef: WideString readonly dispid 49;
    property tlLineType: Integer dispid 50;
    property tlPriceByPack: WordBool dispid 51;
    property tlQtyInPack: Double dispid 52;
    property tlClearDate: WideString dispid 53;
    property tlUserDef1: WideString dispid 54;
    property tlUserDef2: WideString dispid 55;
    property tlUserDef3: WideString dispid 56;
    property tlUserDef4: WideString dispid 57;
    function entInvLTotal(UseDisc: WordBool; SetlDisc: Double): Double; dispid 58;
    procedure Delete; dispid 59;
    procedure Save; dispid 60;
    function LinkToStock: WordBool; dispid 61;
  end;

// *********************************************************************//
// Interface: ICOMTransaction4
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4900066B-D570-45BA-A06A-45B78963DF0E}
// *********************************************************************//
  ICOMTransaction4 = interface(ICOMTransaction3)
    ['{4900066B-D570-45BA-A06A-45B78963DF0E}']
    function Get_thNOMVATIO: TNOMVATIOType; safecall;
    procedure Set_thNOMVATIO(Value: TNOMVATIOType); safecall;
    property thNOMVATIO: TNOMVATIOType read Get_thNOMVATIO write Set_thNOMVATIO;
  end;

// *********************************************************************//
// DispIntf:  ICOMTransaction4Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4900066B-D570-45BA-A06A-45B78963DF0E}
// *********************************************************************//
  ICOMTransaction4Disp = dispinterface
    ['{4900066B-D570-45BA-A06A-45B78963DF0E}']
    property thNOMVATIO: TNOMVATIOType dispid 87;
    property thCISTaxDue: Double dispid 84;
    property thCISTaxDeclared: Double dispid 85;
    property thCISManualTax: WordBool dispid 86;
    property thCISDate: WideString dispid 88;
    property thCISEmployee: WideString dispid 89;
    property thCISTotalGross: Double dispid 90;
    property thCISSource: Integer dispid 91;
    property thTotalCostApport: Double dispid 92;
    property thTagNo: Integer dispid 83;
    function LinkToCust: WordBool; dispid 1;
    property AccessRights: TRecordAccessStatus readonly dispid 2;
    property DataChanged: WordBool readonly dispid 3;
    property thRunNo: Integer dispid 4;
    property thAcCode: WideString dispid 5;
    property thNomAuto: WordBool dispid 6;
    property thOurRef: WideString dispid 7;
    property thFolioNum: Integer dispid 8;
    property thCurrency: Smallint dispid 9;
    property thYear: Smallint dispid 10;
    property thPeriod: Smallint dispid 11;
    property thDueDate: WideString dispid 12;
    property thVATPostDate: WideString dispid 13;
    property thTransDate: WideString dispid 14;
    property thCustSupp: WideString readonly dispid 15;
    property thCompanyRate: Double dispid 16;
    property thDailyRate: Double dispid 17;
    property thYourRef: WideString dispid 18;
    property thBatchLink: WideString dispid 19;
    property thAllocStat: WideString dispid 20;
    property thInvNetVal: Double readonly dispid 22;
    property thInvVat: Double readonly dispid 23;
    property thDiscSetl: Double dispid 24;
    property thDiscSetAm: Double dispid 25;
    property thDiscAmount: Double dispid 26;
    property thDiscDays: Smallint dispid 27;
    property thDiscTaken: WordBool dispid 28;
    property thSettled: Double dispid 29;
    property thAutoInc: Smallint dispid 30;
    property thNextAutoYr: Smallint dispid 31;
    property thNextAutoPr: Smallint dispid 32;
    property thTransNat: Smallint dispid 33;
    property thTransMode: Smallint dispid 34;
    property thRemitNo: WideString dispid 35;
    property thAutoIncBy: WideString dispid 36;
    property thHoldFlg: Smallint dispid 37;
    property thAuditFlg: WordBool dispid 38;
    property thTotalWeight: Double dispid 39;
    property thVariance: Double dispid 40;
    property thTotalOrdered: Double dispid 41;
    property thTotalReserved: Double dispid 42;
    property thTotalCost: Double dispid 43;
    property thTotalInvoiced: Double dispid 44;
    property thTransDesc: WideString dispid 45;
    property thAutoUntilDate: WideString dispid 46;
    property thExternal: WordBool dispid 47;
    property thPrinted: WordBool dispid 48;
    property thCurrVariance: Double dispid 49;
    property thCurrSettled: Double dispid 50;
    property thSettledVAT: Double dispid 51;
    property thVATClaimed: Double dispid 52;
    property thBatchPayGL: Integer dispid 53;
    property thAutoPost: WordBool dispid 54;
    property thManualVAT: WordBool dispid 55;
    property thSSDDelTerms: WideString dispid 56;
    property thUser: WideString dispid 57;
    property thNoLabels: Smallint dispid 58;
    property thTagged: WordBool dispid 59;
    property thPickRunNo: Integer dispid 60;
    property thOrdMatch: WordBool dispid 61;
    property thDeliveryNote: WideString dispid 62;
    property thVATCompanyRate: Double dispid 63;
    property thVATDailyRate: Double dispid 64;
    property thPostCompanyRate: Double dispid 65;
    property thPostDailyRate: Double dispid 66;
    property thPostDiscAm: Double dispid 67;
    property thPostedDiscTaken: WordBool dispid 68;
    property thDrCrGL: Integer dispid 69;
    property thJobCode: WideString dispid 70;
    property thJobAnal: WideString dispid 71;
    property thTotOrderOS: Double dispid 72;
    property thUser1: WideString dispid 73;
    property thUser2: WideString dispid 74;
    property thLastLetter: Smallint dispid 75;
    property thUnTagged: WordBool dispid 76;
    property thUser3: WideString dispid 77;
    property thUser4: WideString dispid 78;
    property thInvVATAnal[Index: TVATIndex]: Double dispid 21;
    property thDelAddr[Index: Integer]: WideString dispid 79;
    property thDocLSplit[Index: Integer]: Double dispid 80;
    property thInvDocHed: TDocTypes dispid 81;
    property thLines: ICOMTransactionLines readonly dispid 82;
  end;

// *********************************************************************//
// Interface: ICOMBatchSerial2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {93DC2533-BAC5-49B3-ADF8-07D4C44B8149}
// *********************************************************************//
  ICOMBatchSerial2 = interface(ICOMBatchSerial)
    ['{93DC2533-BAC5-49B3-ADF8-07D4C44B8149}']
    function Get_bsBinCode: WideString; safecall;
    procedure Set_bsBinCode(const Value: WideString); safecall;
    property bsBinCode: WideString read Get_bsBinCode write Set_bsBinCode;
  end;

// *********************************************************************//
// DispIntf:  ICOMBatchSerial2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {93DC2533-BAC5-49B3-ADF8-07D4C44B8149}
// *********************************************************************//
  ICOMBatchSerial2Disp = dispinterface
    ['{93DC2533-BAC5-49B3-ADF8-07D4C44B8149}']
    property bsBinCode: WideString dispid 34;
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property bsSerialCode: WideString dispid 3;
    property bsSerialNo: WideString dispid 4;
    property bsBatchNo: WideString dispid 5;
    property bsInDoc: WideString dispid 6;
    property bsOutDoc: WideString dispid 7;
    property bsSold: WordBool dispid 8;
    property bsDateIn: WideString dispid 9;
    property bsSerCost: Double dispid 10;
    property bsSerSell: Double dispid 11;
    property bsStkFolio: Integer dispid 12;
    property bsDateOut: WideString dispid 13;
    property bsSoldLine: Integer dispid 14;
    property bsCurCost: TCurrencyType dispid 15;
    property bsCurSell: TCurrencyType dispid 16;
    property bsBuyLine: Integer dispid 17;
    property bsBatchRec: WordBool dispid 18;
    property bsBuyQty: Double dispid 19;
    property bsQtyUsed: Double dispid 20;
    property bsBatchChild: WordBool dispid 21;
    property bsInMLoc: WideString dispid 22;
    property bsOutMLoc: WideString dispid 23;
    property bsCompanyRate: Double dispid 24;
    property bsDailyRate: Double dispid 25;
    property bsInOrdDoc: WideString dispid 26;
    property bsOutOrdDoc: WideString dispid 27;
    property bsInOrdLine: Integer dispid 28;
    property bsOutOrdLine: Integer dispid 29;
    property bsNLineCount: Integer dispid 30;
    property bsNoteFolio: Integer dispid 31;
    property bsDateUseX: WideString dispid 32;
    property bsSUseORate: Smallint dispid 33;
  end;

// *********************************************************************//
// Interface: ICOMEventData3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6F3207B5-4384-4AA0-B50E-88F9EE983D63}
// *********************************************************************//
  ICOMEventData3 = interface(ICOMEventData2)
    ['{6F3207B5-4384-4AA0-B50E-88F9EE983D63}']
    function Get_BatchSerial2: ICOMBatchSerial2; safecall;
    function Get_Bin: ICOMMultiBin; safecall;
    function Get_Stock3: ICOMStock3; safecall;
    property BatchSerial2: ICOMBatchSerial2 read Get_BatchSerial2;
    property Bin: ICOMMultiBin read Get_Bin;
    property Stock3: ICOMStock3 read Get_Stock3;
  end;

// *********************************************************************//
// DispIntf:  ICOMEventData3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6F3207B5-4384-4AA0-B50E-88F9EE983D63}
// *********************************************************************//
  ICOMEventData3Disp = dispinterface
    ['{6F3207B5-4384-4AA0-B50E-88F9EE983D63}']
    property BatchSerial2: ICOMBatchSerial2 readonly dispid 18;
    property Bin: ICOMMultiBin readonly dispid 19;
    property Stock3: ICOMStock3 readonly dispid 26;
    property Customer2: ICOMCustomer3 readonly dispid 20;
    property JobCosting: ICOMJobCosting readonly dispid 21;
    property Supplier2: ICOMCustomer3 readonly dispid 22;
    property Telesales: ICOMTelesales readonly dispid 23;
    property Transaction2: ICOMTransaction3 readonly dispid 24;
    property BatchSerial: ICOMBatchSerial readonly dispid 37;
    property WindowId: Integer readonly dispid 1;
    property HandlerId: Integer readonly dispid 2;
    property Customer: ICOMCustomer readonly dispid 3;
    property Supplier: ICOMCustomer readonly dispid 4;
    property CostCentre: ICOMCCDept readonly dispid 5;
    property Department: ICOMCCDept readonly dispid 6;
    property GLCode: ICOMGLCode readonly dispid 7;
    property Stock: ICOMStock readonly dispid 8;
    property Transaction: ICOMTransaction readonly dispid 9;
    property Job: ICOMJob readonly dispid 10;
    property MiscData: ICOMMiscData readonly dispid 11;
    property ValidStatus: WordBool dispid 12;
    property BoResult: WordBool dispid 13;
    property DblResult: Double dispid 14;
    property IntResult: Integer dispid 15;
    property StrResult: WideString dispid 16;
    property VarResult: OleVariant dispid 17;
    property InEditMode: WordBool readonly dispid 25;
  end;

// *********************************************************************//
// Interface: ICOMSetup4
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {94FB01F0-BDBD-458C-AF75-575A9219F574}
// *********************************************************************//
  ICOMSetup4 = interface(ICOMSetup3)
    ['{94FB01F0-BDBD-458C-AF75-575A9219F574}']
    function Get_ssFilterSNoByBinLoc: WordBool; safecall;
    function Get_ssKeepBinHistory: WordBool; safecall;
    function Get_ssBinMask: WideString; safecall;
    property ssFilterSNoByBinLoc: WordBool read Get_ssFilterSNoByBinLoc;
    property ssKeepBinHistory: WordBool read Get_ssKeepBinHistory;
    property ssBinMask: WideString read Get_ssBinMask;
  end;

// *********************************************************************//
// DispIntf:  ICOMSetup4Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {94FB01F0-BDBD-458C-AF75-575A9219F574}
// *********************************************************************//
  ICOMSetup4Disp = dispinterface
    ['{94FB01F0-BDBD-458C-AF75-575A9219F574}']
    property ssFilterSNoByBinLoc: WordBool readonly dispid 109;
    property ssKeepBinHistory: WordBool readonly dispid 110;
    property ssBinMask: WideString readonly dispid 111;
    property ssCISSetup: ICOMSetupCIS readonly dispid 107;
    property ssJobCosting: ICOMSetupJobCosting readonly dispid 108;
    property ssWORAllocStockOnPick: WordBool readonly dispid 103;
    property ssWOPDisableWIP: WordBool readonly dispid 104;
    property ssWORCopyStkNotes: Integer readonly dispid 105;
    property ssPaperless: ICOMSetupPaperless readonly dispid 106;
    property ssPrinYr: Smallint readonly dispid 1;
    property ssUserName: WideString readonly dispid 2;
    property ssAuditYr: Smallint readonly dispid 3;
    property ssManROCP: WordBool readonly dispid 4;
    property ssVATCurr: Smallint readonly dispid 5;
    property ssNoCosDec: Smallint readonly dispid 6;
    property ssCurrBase: Smallint readonly dispid 7;
    property ssShowStkGP: WordBool readonly dispid 8;
    property ssAutoValStk: WordBool readonly dispid 9;
    property ssDelPickOnly: WordBool readonly dispid 10;
    property ssUseMLoc: WordBool readonly dispid 11;
    property ssEditSinSer: WordBool readonly dispid 12;
    property ssWarnYRef: WordBool readonly dispid 13;
    property ssUseLocDel: WordBool readonly dispid 14;
    property ssPostCCGL: WordBool readonly dispid 15;
    property ssAlTolVal: Double readonly dispid 16;
    property ssAlTolMode: Smallint readonly dispid 17;
    property ssDebtLMode: Smallint readonly dispid 18;
    property ssAutoGenVar: WordBool readonly dispid 19;
    property ssAutoGenDisc: WordBool readonly dispid 20;
    property ssUSRCntryCode: WideString readonly dispid 21;
    property ssNoNetDec: Smallint readonly dispid 22;
    property ssNoInvLines: Smallint readonly dispid 23;
    property ssWksODue: Smallint readonly dispid 24;
    property ssCPr: Smallint readonly dispid 25;
    property ssCYr: Smallint readonly dispid 26;
    property ssTradeTerm: WordBool readonly dispid 27;
    property ssStaSepCr: WordBool readonly dispid 28;
    property ssStaAgeMthd: Smallint readonly dispid 29;
    property ssStaUIDate: WordBool readonly dispid 30;
    property ssQUAllocFlg: WordBool readonly dispid 31;
    property ssDeadBOM: WordBool readonly dispid 32;
    property ssAuthMode: WideString readonly dispid 33;
    property ssIntraStat: WordBool readonly dispid 34;
    property ssAnalStkDesc: WordBool readonly dispid 35;
    property ssAutoStkVal: WideString readonly dispid 36;
    property ssAutoBillUp: WordBool readonly dispid 37;
    property ssAutoCQNo: WordBool readonly dispid 38;
    property ssIncNotDue: WordBool readonly dispid 39;
    property ssUseBatchTot: WordBool readonly dispid 40;
    property ssUseStock: WordBool readonly dispid 41;
    property ssAutoNotes: WordBool readonly dispid 42;
    property ssHideMenuOpt: WordBool readonly dispid 43;
    property ssUseCCDep: WordBool readonly dispid 44;
    property ssNoHoldDisc: WordBool readonly dispid 45;
    property ssAutoPrCalc: WordBool readonly dispid 46;
    property ssStopBadDr: WordBool readonly dispid 47;
    property ssUsePayIn: WordBool readonly dispid 48;
    property ssUsePasswords: WordBool readonly dispid 49;
    property ssPrintReciept: WordBool readonly dispid 50;
    property ssExternCust: WordBool readonly dispid 51;
    property ssNoQtyDec: Smallint readonly dispid 52;
    property ssExternSIN: WordBool readonly dispid 53;
    property ssPrevPrOff: WordBool readonly dispid 54;
    property ssDefPcDisc: WordBool readonly dispid 55;
    property ssTradCodeNum: WordBool readonly dispid 56;
    property ssUpBalOnPost: WordBool readonly dispid 57;
    property ssShowInvDisc: WordBool readonly dispid 58;
    property ssSepDiscounts: WordBool readonly dispid 59;
    property ssUseCreditChk: WordBool readonly dispid 60;
    property ssUseCRLimitChk: WordBool readonly dispid 61;
    property ssAutoClearPay: WordBool readonly dispid 62;
    property ssTotalConv: WideString readonly dispid 63;
    property ssDispPrAsMonths: WordBool readonly dispid 64;
    property ssDirectCust: WideString readonly dispid 65;
    property ssDirectSupp: WideString readonly dispid 66;
    property ssGLPayFrom: Integer readonly dispid 67;
    property ssGLPayToo: Integer readonly dispid 68;
    property ssSettleDisc: Double readonly dispid 69;
    property ssSettleDays: Smallint readonly dispid 70;
    property ssNeedBMUp: WordBool readonly dispid 71;
    property ssInpPack: WordBool readonly dispid 72;
    property ssVATCode: WideString readonly dispid 73;
    property ssPayTerms: Smallint readonly dispid 74;
    property ssStaAgeInt: Smallint readonly dispid 75;
    property ssQuoOwnDate: WordBool readonly dispid 76;
    property ssFreeExAll: WordBool readonly dispid 77;
    property ssDirOwnCount: WordBool readonly dispid 78;
    property ssStaShowOS: WordBool readonly dispid 79;
    property ssLiveCredS: WordBool readonly dispid 80;
    property ssBatchPPY: WordBool readonly dispid 81;
    property ssWarnJC: WordBool readonly dispid 82;
    property ssDefBankGL: Integer readonly dispid 83;
    property ssUseDefBank: WordBool readonly dispid 84;
    property ssMonWk1: WideString readonly dispid 85;
    property ssAuditDate: WideString readonly dispid 86;
    property ssUserSort: WideString readonly dispid 87;
    property ssUserAcc: WideString readonly dispid 88;
    property ssUserRef: WideString readonly dispid 89;
    property ssUserBank: WideString readonly dispid 90;
    property ssLastExpFolio: Integer readonly dispid 91;
    property ssDetailTel: WideString readonly dispid 92;
    property ssDetailFax: WideString readonly dispid 93;
    property ssUserVATReg: WideString readonly dispid 94;
    property ssDataPath: WideString readonly dispid 95;
    property ssDetailAddr[Index: Integer]: WideString readonly dispid 96;
    property ssGLCtrlCodes[Index: TNomCtrlType]: Integer readonly dispid 97;
    property ssDebtChaseDays[Index: Integer]: Smallint readonly dispid 98;
    property ssTermsofTrade[Index: TTermsIndex]: WideString readonly dispid 99;
    property ssCurrency[Index: TCurrencyType]: ICOMSetupCurrency readonly dispid 100;
    property ssVATRates[Index: TVATIndex]: ICOMSetupVAT readonly dispid 101;
    property ssUserFields: ICOMSetupUserFields readonly dispid 102;
  end;

// *********************************************************************//
// Interface: ICOMCustomisation5
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9EFB5D8F-5819-4C37-AD73-FAF9A20FC3F4}
// *********************************************************************//
  ICOMCustomisation5 = interface(ICOMCustomisation4)
    ['{9EFB5D8F-5819-4C37-AD73-FAF9A20FC3F4}']
    function Get_SystemSetup3: ICOMSetup4; safecall;
    property SystemSetup3: ICOMSetup4 read Get_SystemSetup3;
  end;

// *********************************************************************//
// DispIntf:  ICOMCustomisation5Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9EFB5D8F-5819-4C37-AD73-FAF9A20FC3F4}
// *********************************************************************//
  ICOMCustomisation5Disp = dispinterface
    ['{9EFB5D8F-5819-4C37-AD73-FAF9A20FC3F4}']
    property SystemSetup3: ICOMSetup4 readonly dispid 16;
    property SystemSetup2: ICOMSetup3 readonly dispid 15;
    property UserProfile: ICOMUserProfile readonly dispid 13;
    function HookPointEnabled(WindowId: Integer; HandlerId: Integer): WordBool; dispid 14;
    procedure AddLabelCustomisation(WindowId: Integer; TextId: Integer; const Caption: WideString); dispid 11;
    procedure AddLabelCustomisationEx(WindowId: Integer; TextId: Integer; 
                                      const Caption: WideString; const FontName: WideString; 
                                      FontSize: Integer; FontBold: WordBool; FontItalic: WordBool; 
                                      FontUnderline: WordBool; FontStrikeOut: WordBool; 
                                      FontColorRed: Integer; FontColorGreen: Integer; 
                                      FontColorBlue: Integer); dispid 12;
    property ClassVersion: WideString readonly dispid 1;
    property SystemSetup: ICOMSetup readonly dispid 2;
    property UserName: WideString readonly dispid 3;
    property VersionInfo: ICOMVersion readonly dispid 4;
    procedure AddAboutString(const AboutText: WideString); dispid 5;
    procedure EnableHook(WindowId: Integer; HandlerId: Integer); dispid 6;
    function entRound(Num: Double; Decs: Integer): Double; dispid 7;
    function entCalc_PcntPcnt(PAmount: Double; Pc1: Double; Pc2: Double; const PCh1: WideString; 
                              const PCh2: WideString): Double; dispid 8;
    function entGetTaxNo(const VCode: WideString): TVATIndex; dispid 9;
    property SysFunc: ICOMSysFunc readonly dispid 10;
  end;

// *********************************************************************//
// Interface: ICOMMultiBin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C5CE082-5B08-4CF6-9475-E754ED703B82}
// *********************************************************************//
  ICOMMultiBin = interface(IDispatch)
    ['{2C5CE082-5B08-4CF6-9475-E754ED703B82}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_brBinCode: WideString; safecall;
    procedure Set_brBinCode(const Value: WideString); safecall;
    function Get_brStockFolio: Integer; safecall;
    procedure Set_brStockFolio(Value: Integer); safecall;
    function Get_brPickingPriority: WideString; safecall;
    procedure Set_brPickingPriority(const Value: WideString); safecall;
    function Get_brUseByDate: WideString; safecall;
    procedure Set_brUseByDate(const Value: WideString); safecall;
    function Get_brUnitOfMeasurement: WideString; safecall;
    procedure Set_brUnitOfMeasurement(const Value: WideString); safecall;
    function Get_brAutoPickMode: Integer; safecall;
    procedure Set_brAutoPickMode(Value: Integer); safecall;
    function Get_brTagNo: Integer; safecall;
    procedure Set_brTagNo(Value: Integer); safecall;
    function Get_brQty: Double; safecall;
    procedure Set_brQty(Value: Double); safecall;
    function Get_brQtyUsed: Double; safecall;
    procedure Set_brQtyUsed(Value: Double); safecall;
    function Get_brCapacity: Double; safecall;
    procedure Set_brCapacity(Value: Double); safecall;
    function Get_brCostPrice: Double; safecall;
    procedure Set_brCostPrice(Value: Double); safecall;
    function Get_brCostPriceCurrency: Integer; safecall;
    procedure Set_brCostPriceCurrency(Value: Integer); safecall;
    function Get_brSalesPrice: Double; safecall;
    procedure Set_brSalesPrice(Value: Double); safecall;
    function Get_brSalesPriceCurrency: Integer; safecall;
    procedure Set_brSalesPriceCurrency(Value: Integer); safecall;
    function Get_brInDate: WideString; safecall;
    procedure Set_brInDate(const Value: WideString); safecall;
    function Get_brInOrderRef: WideString; safecall;
    procedure Set_brInOrderRef(const Value: WideString); safecall;
    function Get_brInOrderLine: Integer; safecall;
    procedure Set_brInOrderLine(Value: Integer); safecall;
    function Get_brInDocRef: WideString; safecall;
    procedure Set_brInDocRef(const Value: WideString); safecall;
    function Get_brInDocLine: Integer; safecall;
    procedure Set_brInDocLine(Value: Integer); safecall;
    function Get_brInLocation: WideString; safecall;
    procedure Set_brInLocation(const Value: WideString); safecall;
    function Get_brUsedRec: WordBool; safecall;
    procedure Set_brUsedRec(Value: WordBool); safecall;
    function Get_brSold: WordBool; safecall;
    procedure Set_brSold(Value: WordBool); safecall;
    function Get_brOutDate: WideString; safecall;
    procedure Set_brOutDate(const Value: WideString); safecall;
    function Get_brOutOrderRef: WideString; safecall;
    procedure Set_brOutOrderRef(const Value: WideString); safecall;
    function Get_brOutOrderLine: Integer; safecall;
    procedure Set_brOutOrderLine(Value: Integer); safecall;
    function Get_brOutDocRef: WideString; safecall;
    procedure Set_brOutDocRef(const Value: WideString); safecall;
    function Get_brOutDocLine: Integer; safecall;
    procedure Set_brOutDocLine(Value: Integer); safecall;
    function Get_brOutLocation: WideString; safecall;
    procedure Set_brOutLocation(const Value: WideString); safecall;
    function Get_brCompanyRate: Double; safecall;
    procedure Set_brCompanyRate(Value: Double); safecall;
    function Get_brDailyRate: Double; safecall;
    procedure Set_brDailyRate(Value: Double); safecall;
    function Get_brUseORate: Smallint; safecall;
    procedure Set_brUseORate(Value: Smallint); safecall;
    function Get_brTriangulation: ICOMCurrencyTriangulation; safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property brBinCode: WideString read Get_brBinCode write Set_brBinCode;
    property brStockFolio: Integer read Get_brStockFolio write Set_brStockFolio;
    property brPickingPriority: WideString read Get_brPickingPriority write Set_brPickingPriority;
    property brUseByDate: WideString read Get_brUseByDate write Set_brUseByDate;
    property brUnitOfMeasurement: WideString read Get_brUnitOfMeasurement write Set_brUnitOfMeasurement;
    property brAutoPickMode: Integer read Get_brAutoPickMode write Set_brAutoPickMode;
    property brTagNo: Integer read Get_brTagNo write Set_brTagNo;
    property brQty: Double read Get_brQty write Set_brQty;
    property brQtyUsed: Double read Get_brQtyUsed write Set_brQtyUsed;
    property brCapacity: Double read Get_brCapacity write Set_brCapacity;
    property brCostPrice: Double read Get_brCostPrice write Set_brCostPrice;
    property brCostPriceCurrency: Integer read Get_brCostPriceCurrency write Set_brCostPriceCurrency;
    property brSalesPrice: Double read Get_brSalesPrice write Set_brSalesPrice;
    property brSalesPriceCurrency: Integer read Get_brSalesPriceCurrency write Set_brSalesPriceCurrency;
    property brInDate: WideString read Get_brInDate write Set_brInDate;
    property brInOrderRef: WideString read Get_brInOrderRef write Set_brInOrderRef;
    property brInOrderLine: Integer read Get_brInOrderLine write Set_brInOrderLine;
    property brInDocRef: WideString read Get_brInDocRef write Set_brInDocRef;
    property brInDocLine: Integer read Get_brInDocLine write Set_brInDocLine;
    property brInLocation: WideString read Get_brInLocation write Set_brInLocation;
    property brUsedRec: WordBool read Get_brUsedRec write Set_brUsedRec;
    property brSold: WordBool read Get_brSold write Set_brSold;
    property brOutDate: WideString read Get_brOutDate write Set_brOutDate;
    property brOutOrderRef: WideString read Get_brOutOrderRef write Set_brOutOrderRef;
    property brOutOrderLine: Integer read Get_brOutOrderLine write Set_brOutOrderLine;
    property brOutDocRef: WideString read Get_brOutDocRef write Set_brOutDocRef;
    property brOutDocLine: Integer read Get_brOutDocLine write Set_brOutDocLine;
    property brOutLocation: WideString read Get_brOutLocation write Set_brOutLocation;
    property brCompanyRate: Double read Get_brCompanyRate write Set_brCompanyRate;
    property brDailyRate: Double read Get_brDailyRate write Set_brDailyRate;
    property brUseORate: Smallint read Get_brUseORate write Set_brUseORate;
    property brTriangulation: ICOMCurrencyTriangulation read Get_brTriangulation;
  end;

// *********************************************************************//
// DispIntf:  ICOMMultiBinDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2C5CE082-5B08-4CF6-9475-E754ED703B82}
// *********************************************************************//
  ICOMMultiBinDisp = dispinterface
    ['{2C5CE082-5B08-4CF6-9475-E754ED703B82}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property brBinCode: WideString dispid 2;
    property brStockFolio: Integer dispid 3;
    property brPickingPriority: WideString dispid 4;
    property brUseByDate: WideString dispid 5;
    property brUnitOfMeasurement: WideString dispid 6;
    property brAutoPickMode: Integer dispid 7;
    property brTagNo: Integer dispid 8;
    property brQty: Double dispid 9;
    property brQtyUsed: Double dispid 10;
    property brCapacity: Double dispid 11;
    property brCostPrice: Double dispid 12;
    property brCostPriceCurrency: Integer dispid 13;
    property brSalesPrice: Double dispid 14;
    property brSalesPriceCurrency: Integer dispid 15;
    property brInDate: WideString dispid 16;
    property brInOrderRef: WideString dispid 17;
    property brInOrderLine: Integer dispid 18;
    property brInDocRef: WideString dispid 19;
    property brInDocLine: Integer dispid 20;
    property brInLocation: WideString dispid 21;
    property brUsedRec: WordBool dispid 22;
    property brSold: WordBool dispid 23;
    property brOutDate: WideString dispid 24;
    property brOutOrderRef: WideString dispid 25;
    property brOutOrderLine: Integer dispid 26;
    property brOutDocRef: WideString dispid 27;
    property brOutDocLine: Integer dispid 28;
    property brOutLocation: WideString dispid 29;
    property brCompanyRate: Double dispid 30;
    property brDailyRate: Double dispid 31;
    property brUseORate: Smallint dispid 32;
    property brTriangulation: ICOMCurrencyTriangulation readonly dispid 33;
  end;

// *********************************************************************//
// Interface: ICOMStock3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {088562D4-FF19-4E04-A4EE-02E9E5855454}
// *********************************************************************//
  ICOMStock3 = interface(ICOMStock2)
    ['{088562D4-FF19-4E04-A4EE-02E9E5855454}']
    function Get_stUsesBins: WordBool; safecall;
    procedure Set_stUsesBins(Value: WordBool); safecall;
    property stUsesBins: WordBool read Get_stUsesBins write Set_stUsesBins;
  end;

// *********************************************************************//
// DispIntf:  ICOMStock3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {088562D4-FF19-4E04-A4EE-02E9E5855454}
// *********************************************************************//
  ICOMStock3Disp = dispinterface
    ['{088562D4-FF19-4E04-A4EE-02E9E5855454}']
    property stUsesBins: WordBool dispid 96;
    property stUseForEbus: WordBool dispid 84;
    property stWebLiveCatalog: WideString dispid 85;
    property stWebPrevCatalog: WideString dispid 86;
    property stWOPROLeadTime: Integer dispid 87;
    property stWOPAssemblyHours: Integer dispid 88;
    property stWOPAssemblyMins: Integer dispid 89;
    property stWOPAutoCalcTime: WordBool dispid 90;
    property stWOPMinEconBuild: Double dispid 91;
    property stWOPIssuedWIPGL: Integer dispid 92;
    property stQtyAllocWOR: Double dispid 93;
    property stQtyIssuedWOR: Double dispid 94;
    property stQtyPickedWOR: Double dispid 95;
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property stCode: WideString dispid 3;
    property stDesc[Index: Integer]: WideString dispid 81;
    property stAltCode: WideString dispid 4;
    property stSuppTemp: WideString dispid 5;
    property stSalesGL: Integer dispid 6;
    property stCOSGL: Integer dispid 7;
    property stPandLGL: Integer dispid 8;
    property stBalSheetGL: Integer dispid 9;
    property stWIPGL: Integer dispid 10;
    property stReOrderFlag: WordBool dispid 11;
    property stMinFlg: WordBool dispid 12;
    property stStockFolio: Integer dispid 13;
    property stStockCat: WideString dispid 14;
    property stStockType: WideString dispid 15;
    property stUnitOfStock: WideString dispid 16;
    property stUnitOfSale: WideString dispid 17;
    property stUnitOfPurch: WideString dispid 18;
    property stCostPriceCur: TCurrencyType dispid 19;
    property stCostPrice: Double dispid 20;
    property stSalesUnits: Double dispid 21;
    property stPurchUnits: Double dispid 22;
    property stVATCode: WideString dispid 23;
    property stCostCentre: WideString dispid 24;
    property stDepartment: WideString dispid 25;
    property stQtyInStock: Double dispid 26;
    property stQtyPosted: Double dispid 27;
    property stQtyAllocated: Double dispid 28;
    property stQtyOnOrder: Double dispid 29;
    property stQtyMin: Double dispid 30;
    property stQtyMax: Double dispid 31;
    property stReOrderQty: Double dispid 32;
    property stKitOnPurch: WordBool dispid 33;
    property stShowAsKit: WordBool dispid 34;
    property stCommodCode: WideString dispid 35;
    property stSaleUnWeight: Double dispid 36;
    property stPurchUnWeight: Double dispid 37;
    property stSSDUnit: WideString dispid 38;
    property stSSDSalesUnit: Double dispid 39;
    property stBinLocation: WideString dispid 40;
    property stStkFlg: WordBool dispid 41;
    property stCovPr: Smallint dispid 42;
    property stCovPrUnit: WideString dispid 43;
    property stCovMinPr: Smallint dispid 44;
    property stCovMinUnit: WideString dispid 45;
    property stSupplier: WideString dispid 46;
    property stQtyFreeze: Double dispid 47;
    property stCovSold: Double dispid 48;
    property stUseCover: WordBool dispid 49;
    property stCovMaxPr: Smallint dispid 50;
    property stCovMaxUnit: WideString dispid 51;
    property stReOrderCur: Smallint dispid 52;
    property stReOrderPrice: Double dispid 53;
    property stReOrderDate: WideString dispid 54;
    property stQtyTake: Double dispid 55;
    property stStkValType: WideString dispid 56;
    property stQtyPicked: Double dispid 57;
    property stLastUsed: WideString dispid 58;
    property stCalcPack: WordBool dispid 59;
    property stJobAnal: WideString dispid 60;
    property stStkUser1: WideString dispid 61;
    property stStkUser2: WideString dispid 62;
    property stBarCode: WideString dispid 63;
    property stROCostCentre: WideString dispid 64;
    property stRODepartment: WideString dispid 65;
    property stLocation: WideString dispid 66;
    property stPricePack: WordBool dispid 67;
    property stDPackQty: WordBool dispid 68;
    property stKitPrice: WordBool dispid 69;
    property stStkUser3: WideString dispid 70;
    property stStkUser4: WideString dispid 71;
    property stSerNoWAvg: Smallint dispid 72;
    property stStkSizeCol: Smallint readonly dispid 73;
    property stSSDDUplift: Double dispid 74;
    property stSSDCountry: WideString dispid 75;
    property stTimeChange: WideString readonly dispid 76;
    property stSVATIncFlg: WideString dispid 77;
    property stSSDAUpLift: Double dispid 78;
    property stLastOpo: WideString dispid 79;
    property stImageFile: WideString dispid 80;
    property stSaleBandsCur[const Index: WideString]: TCurrencyType dispid 82;
    property stSaleBandsPrice[const Index: WideString]: Double dispid 83;
  end;

// *********************************************************************//
// Interface: ICOMTransaction5
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D611BE2D-7D48-44FF-AD58-016B1A62FFEF}
// *********************************************************************//
  ICOMTransaction5 = interface(ICOMTransaction4)
    ['{D611BE2D-7D48-44FF-AD58-016B1A62FFEF}']
    function Get_thTSHExported: WordBool; safecall;
    procedure Set_thTSHExported(Value: WordBool); safecall;
    property thTSHExported: WordBool read Get_thTSHExported write Set_thTSHExported;
  end;

// *********************************************************************//
// DispIntf:  ICOMTransaction5Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D611BE2D-7D48-44FF-AD58-016B1A62FFEF}
// *********************************************************************//
  ICOMTransaction5Disp = dispinterface
    ['{D611BE2D-7D48-44FF-AD58-016B1A62FFEF}']
    property thTSHExported: WordBool dispid 93;
    property thNOMVATIO: TNOMVATIOType dispid 87;
    property thCISTaxDue: Double dispid 84;
    property thCISTaxDeclared: Double dispid 85;
    property thCISManualTax: WordBool dispid 86;
    property thCISDate: WideString dispid 88;
    property thCISEmployee: WideString dispid 89;
    property thCISTotalGross: Double dispid 90;
    property thCISSource: Integer dispid 91;
    property thTotalCostApport: Double dispid 92;
    property thTagNo: Integer dispid 83;
    function LinkToCust: WordBool; dispid 1;
    property AccessRights: TRecordAccessStatus readonly dispid 2;
    property DataChanged: WordBool readonly dispid 3;
    property thRunNo: Integer dispid 4;
    property thAcCode: WideString dispid 5;
    property thNomAuto: WordBool dispid 6;
    property thOurRef: WideString dispid 7;
    property thFolioNum: Integer dispid 8;
    property thCurrency: Smallint dispid 9;
    property thYear: Smallint dispid 10;
    property thPeriod: Smallint dispid 11;
    property thDueDate: WideString dispid 12;
    property thVATPostDate: WideString dispid 13;
    property thTransDate: WideString dispid 14;
    property thCustSupp: WideString readonly dispid 15;
    property thCompanyRate: Double dispid 16;
    property thDailyRate: Double dispid 17;
    property thYourRef: WideString dispid 18;
    property thBatchLink: WideString dispid 19;
    property thAllocStat: WideString dispid 20;
    property thInvNetVal: Double readonly dispid 22;
    property thInvVat: Double readonly dispid 23;
    property thDiscSetl: Double dispid 24;
    property thDiscSetAm: Double dispid 25;
    property thDiscAmount: Double dispid 26;
    property thDiscDays: Smallint dispid 27;
    property thDiscTaken: WordBool dispid 28;
    property thSettled: Double dispid 29;
    property thAutoInc: Smallint dispid 30;
    property thNextAutoYr: Smallint dispid 31;
    property thNextAutoPr: Smallint dispid 32;
    property thTransNat: Smallint dispid 33;
    property thTransMode: Smallint dispid 34;
    property thRemitNo: WideString dispid 35;
    property thAutoIncBy: WideString dispid 36;
    property thHoldFlg: Smallint dispid 37;
    property thAuditFlg: WordBool dispid 38;
    property thTotalWeight: Double dispid 39;
    property thVariance: Double dispid 40;
    property thTotalOrdered: Double dispid 41;
    property thTotalReserved: Double dispid 42;
    property thTotalCost: Double dispid 43;
    property thTotalInvoiced: Double dispid 44;
    property thTransDesc: WideString dispid 45;
    property thAutoUntilDate: WideString dispid 46;
    property thExternal: WordBool dispid 47;
    property thPrinted: WordBool dispid 48;
    property thCurrVariance: Double dispid 49;
    property thCurrSettled: Double dispid 50;
    property thSettledVAT: Double dispid 51;
    property thVATClaimed: Double dispid 52;
    property thBatchPayGL: Integer dispid 53;
    property thAutoPost: WordBool dispid 54;
    property thManualVAT: WordBool dispid 55;
    property thSSDDelTerms: WideString dispid 56;
    property thUser: WideString dispid 57;
    property thNoLabels: Smallint dispid 58;
    property thTagged: WordBool dispid 59;
    property thPickRunNo: Integer dispid 60;
    property thOrdMatch: WordBool dispid 61;
    property thDeliveryNote: WideString dispid 62;
    property thVATCompanyRate: Double dispid 63;
    property thVATDailyRate: Double dispid 64;
    property thPostCompanyRate: Double dispid 65;
    property thPostDailyRate: Double dispid 66;
    property thPostDiscAm: Double dispid 67;
    property thPostedDiscTaken: WordBool dispid 68;
    property thDrCrGL: Integer dispid 69;
    property thJobCode: WideString dispid 70;
    property thJobAnal: WideString dispid 71;
    property thTotOrderOS: Double dispid 72;
    property thUser1: WideString dispid 73;
    property thUser2: WideString dispid 74;
    property thLastLetter: Smallint dispid 75;
    property thUnTagged: WordBool dispid 76;
    property thUser3: WideString dispid 77;
    property thUser4: WideString dispid 78;
    property thInvVATAnal[Index: TVATIndex]: Double dispid 21;
    property thDelAddr[Index: Integer]: WideString dispid 79;
    property thDocLSplit[Index: Integer]: Double dispid 80;
    property thInvDocHed: TDocTypes dispid 81;
    property thLines: ICOMTransactionLines readonly dispid 82;
  end;

// *********************************************************************//
// Interface: ICOMTransactionLine4
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {07C085B6-4DAF-4FA0-9396-D7046B9827E9}
// *********************************************************************//
  ICOMTransactionLine4 = interface(ICOMTransactionLine3)
    ['{07C085B6-4DAF-4FA0-9396-D7046B9827E9}']
    function Get_tlCISAdjustments: Double; safecall;
    procedure Set_tlCISAdjustments(Value: Double); safecall;
    function Get_tlAppsDeductType: Integer; safecall;
    procedure Set_tlAppsDeductType(Value: Integer); safecall;
    property tlCISAdjustments: Double read Get_tlCISAdjustments write Set_tlCISAdjustments;
    property tlAppsDeductType: Integer read Get_tlAppsDeductType write Set_tlAppsDeductType;
  end;

// *********************************************************************//
// DispIntf:  ICOMTransactionLine4Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {07C085B6-4DAF-4FA0-9396-D7046B9827E9}
// *********************************************************************//
  ICOMTransactionLine4Disp = dispinterface
    ['{07C085B6-4DAF-4FA0-9396-D7046B9827E9}']
    property tlCISAdjustments: Double dispid 68;
    property tlAppsDeductType: Integer dispid 69;
    property tlNOMVATType: TNOMLineVATType dispid 67;
    property tlLineSource: Integer dispid 62;
    property tlCISRateCode: WideString dispid 63;
    property tlCISRate: Double dispid 64;
    property tlCostApport: Double dispid 65;
    property tlVATInclValue: Double dispid 66;
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property tlFolio: Integer dispid 3;
    property tlLinePos: Integer dispid 4;
    property tlRunNo: Integer dispid 5;
    property tlGLCode: Integer dispid 6;
    property tlShowInGL: Smallint dispid 7;
    property tlCurrency: TCurrencyType dispid 8;
    property tlYear: Smallint readonly dispid 9;
    property tlPeriod: Smallint readonly dispid 10;
    property tlCostCentre: WideString dispid 11;
    property tlDepartment: WideString dispid 12;
    property tlStockCode: WideString dispid 13;
    property tlLineNo: Integer dispid 14;
    property tlLineClass: WideString readonly dispid 15;
    property tlDocType: TDocTypes readonly dispid 16;
    property tlQty: Double dispid 17;
    property tlQtyMul: Double dispid 18;
    property tlNetValue: Double dispid 19;
    property tlDiscount: Double dispid 20;
    property tlVATCode: WideString dispid 21;
    property tlVATAmount: Double dispid 22;
    property tlPayStatus: WideString dispid 23;
    property tlPrevGLBal: Double dispid 24;
    property tlRecStatus: Smallint dispid 25;
    property tlDiscFlag: WideString dispid 26;
    property tlQtyWOFF: Double dispid 27;
    property tlQtyDel: Double dispid 28;
    property tlCost: Double dispid 29;
    property tlAcCode: WideString readonly dispid 30;
    property tlTransDate: WideString dispid 31;
    property tlItemNo: WideString dispid 32;
    property tlDescr: WideString dispid 33;
    property tlJobCode: WideString dispid 34;
    property tlJobAnal: WideString dispid 35;
    property tlCompanyRate: Double dispid 36;
    property tlDailyRate: Double dispid 37;
    property tlUnitWeight: Double dispid 38;
    property tlStockDeductQty: Double dispid 39;
    property tlBOMKitLink: Integer dispid 40;
    property tlOrderFolio: Integer dispid 41;
    property tlOrderLineNo: Integer dispid 42;
    property tlLocation: WideString dispid 43;
    property tlQtyPicked: Double dispid 44;
    property tlQtyPickedWO: Double dispid 45;
    property tlUseQtyMul: WordBool dispid 46;
    property tlNoSerialNos: Double dispid 47;
    property tlCOSGL: Integer dispid 48;
    property tlOurRef: WideString readonly dispid 49;
    property tlLineType: Integer dispid 50;
    property tlPriceByPack: WordBool dispid 51;
    property tlQtyInPack: Double dispid 52;
    property tlClearDate: WideString dispid 53;
    property tlUserDef1: WideString dispid 54;
    property tlUserDef2: WideString dispid 55;
    property tlUserDef3: WideString dispid 56;
    property tlUserDef4: WideString dispid 57;
    function entInvLTotal(UseDisc: WordBool; SetlDisc: Double): Double; dispid 58;
    procedure Delete; dispid 59;
    procedure Save; dispid 60;
    function LinkToStock: WordBool; dispid 61;
  end;

// *********************************************************************//
// Interface: ICOMSetupCIS2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8916EB6E-D59B-4051-9F76-ABBC8CE73719}
// *********************************************************************//
  ICOMSetupCIS2 = interface(ICOMSetupCIS)
    ['{8916EB6E-D59B-4051-9F76-ABBC8CE73719}']
    function Get_cisContractorCertNo: WideString; safecall;
    function Get_cisContractorCertExpiry: WideString; safecall;
    function Get_cisContractorCertType: Integer; safecall;
    property cisContractorCertNo: WideString read Get_cisContractorCertNo;
    property cisContractorCertExpiry: WideString read Get_cisContractorCertExpiry;
    property cisContractorCertType: Integer read Get_cisContractorCertType;
  end;

// *********************************************************************//
// DispIntf:  ICOMSetupCIS2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8916EB6E-D59B-4051-9F76-ABBC8CE73719}
// *********************************************************************//
  ICOMSetupCIS2Disp = dispinterface
    ['{8916EB6E-D59B-4051-9F76-ABBC8CE73719}']
    property cisContractorCertNo: WideString readonly dispid 9;
    property cisContractorCertExpiry: WideString readonly dispid 10;
    property cisContractorCertType: Integer readonly dispid 11;
    property cisInterval: Integer readonly dispid 1;
    property cisAutoSetPeriod: WordBool readonly dispid 2;
    property cisReturnDate: WideString readonly dispid 3;
    property cisTaxRef: WideString readonly dispid 4;
    property cisDefaultVatCode: WideString readonly dispid 5;
    property cisFolioNumber: Integer readonly dispid 6;
    property cisVoucherCounter[VoucherType: TCISVoucherType]: ICOMSetupCISVoucherCounter readonly dispid 8;
    property cisRate[TaxType: TCISTaxType]: ICOMSetupCISRate readonly dispid 7;
  end;

// *********************************************************************//
// Interface: ICOMJobAnalysis2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FDE7569E-CB0A-4C9E-8F3C-1FB36397E890}
// *********************************************************************//
  ICOMJobAnalysis2 = interface(ICOMJobAnalysis)
    ['{FDE7569E-CB0A-4C9E-8F3C-1FB36397E890}']
    function Get_anDeductType: Integer; safecall;
    procedure Set_anDeductType(Value: Integer); safecall;
    function Get_anCalcDeductBeforeRetent: WordBool; safecall;
    procedure Set_anCalcDeductBeforeRetent(Value: WordBool); safecall;
    function Get_anDeductAnalysisMode: Integer; safecall;
    procedure Set_anDeductAnalysisMode(Value: Integer); safecall;
    function Get_anDeductCalcMode: Integer; safecall;
    procedure Set_anDeductCalcMode(Value: Integer); safecall;
    function Get_anPayrollDeductCode: WideString; safecall;
    procedure Set_anPayrollDeductCode(const Value: WideString); safecall;
    function Get_anRetentionType: Integer; safecall;
    procedure Set_anRetentionType(Value: Integer); safecall;
    function Get_anRetentionPercentage: Double; safecall;
    procedure Set_anRetentionPercentage(Value: Double); safecall;
    function Get_anRetentionExpiryMode: Integer; safecall;
    procedure Set_anRetentionExpiryMode(Value: Integer); safecall;
    function Get_anRetentionExpiryInterval: Integer; safecall;
    procedure Set_anRetentionExpiryInterval(Value: Integer); safecall;
    function Get_anPreserveToRetention: WordBool; safecall;
    procedure Set_anPreserveToRetention(Value: WordBool); safecall;
    property anDeductType: Integer read Get_anDeductType write Set_anDeductType;
    property anCalcDeductBeforeRetent: WordBool read Get_anCalcDeductBeforeRetent write Set_anCalcDeductBeforeRetent;
    property anDeductAnalysisMode: Integer read Get_anDeductAnalysisMode write Set_anDeductAnalysisMode;
    property anDeductCalcMode: Integer read Get_anDeductCalcMode write Set_anDeductCalcMode;
    property anPayrollDeductCode: WideString read Get_anPayrollDeductCode write Set_anPayrollDeductCode;
    property anRetentionType: Integer read Get_anRetentionType write Set_anRetentionType;
    property anRetentionPercentage: Double read Get_anRetentionPercentage write Set_anRetentionPercentage;
    property anRetentionExpiryMode: Integer read Get_anRetentionExpiryMode write Set_anRetentionExpiryMode;
    property anRetentionExpiryInterval: Integer read Get_anRetentionExpiryInterval write Set_anRetentionExpiryInterval;
    property anPreserveToRetention: WordBool read Get_anPreserveToRetention write Set_anPreserveToRetention;
  end;

// *********************************************************************//
// DispIntf:  ICOMJobAnalysis2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FDE7569E-CB0A-4C9E-8F3C-1FB36397E890}
// *********************************************************************//
  ICOMJobAnalysis2Disp = dispinterface
    ['{FDE7569E-CB0A-4C9E-8F3C-1FB36397E890}']
    property anDeductType: Integer dispid 9;
    property anCalcDeductBeforeRetent: WordBool dispid 10;
    property anDeductAnalysisMode: Integer dispid 11;
    property anDeductCalcMode: Integer dispid 12;
    property anPayrollDeductCode: WideString dispid 13;
    property anRetentionType: Integer dispid 14;
    property anRetentionPercentage: Double dispid 15;
    property anRetentionExpiryMode: Integer dispid 16;
    property anRetentionExpiryInterval: Integer dispid 17;
    property anPreserveToRetention: WordBool dispid 18;
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property anCode: WideString dispid 2;
    property anDescription: WideString dispid 3;
    property anType: Integer dispid 4;
    property anCategory: Integer dispid 5;
    property anWIPGL: Integer dispid 6;
    property anPandLGL: Integer dispid 7;
    property anLineType: Integer dispid 8;
  end;

// *********************************************************************//
// Interface: ICOMJob3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7748557F-764D-41C2-98A9-A93DFF9DF869}
// *********************************************************************//
  ICOMJob3 = interface(ICOMJob2)
    ['{7748557F-764D-41C2-98A9-A93DFF9DF869}']
    function Get_jrDefRetentionCcy: Integer; safecall;
    procedure Set_jrDefRetentionCcy(Value: Integer); safecall;
    function Get_jrJPTRef: WideString; safecall;
    procedure Set_jrJPTRef(const Value: WideString); safecall;
    function Get_jrJSTRef: WideString; safecall;
    procedure Set_jrJSTRef(const Value: WideString); safecall;
    function Get_jrQSCode: WideString; safecall;
    procedure Set_jrQSCode(const Value: WideString); safecall;
    property jrDefRetentionCcy: Integer read Get_jrDefRetentionCcy write Set_jrDefRetentionCcy;
    property jrJPTRef: WideString read Get_jrJPTRef write Set_jrJPTRef;
    property jrJSTRef: WideString read Get_jrJSTRef write Set_jrJSTRef;
    property jrQSCode: WideString read Get_jrQSCode write Set_jrQSCode;
  end;

// *********************************************************************//
// DispIntf:  ICOMJob3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7748557F-764D-41C2-98A9-A93DFF9DF869}
// *********************************************************************//
  ICOMJob3Disp = dispinterface
    ['{7748557F-764D-41C2-98A9-A93DFF9DF869}']
    property jrDefRetentionCcy: Integer dispid 30;
    property jrJPTRef: WideString dispid 31;
    property jrJSTRef: WideString dispid 32;
    property jrQSCode: WideString dispid 33;
    property jrActual: ICOMJobActual readonly dispid 27;
    property jrBudget: ICOMJobBudget readonly dispid 28;
    property jrRetention: ICOMJobRetention readonly dispid 29;
    property jrJobCode: WideString dispid 1;
    property jrJobDesc: WideString dispid 2;
    property jrJobFolio: Integer readonly dispid 3;
    property jrCustCode: WideString dispid 4;
    property jrJobCat: WideString dispid 5;
    property jrJobAltCode: WideString dispid 6;
    property jrCompleted: Integer dispid 7;
    property jrContact: WideString dispid 8;
    property jrJobMan: WideString dispid 9;
    property jrChargeType: Smallint dispid 10;
    property jrQuotePrice: Double dispid 11;
    property jrCurrPrice: Smallint dispid 12;
    property jrStartDate: WideString dispid 13;
    property jrEndDate: WideString dispid 14;
    property jrRevEDate: WideString dispid 15;
    property jrSORRef: WideString dispid 16;
    property jrVATCode: WideString dispid 17;
    property jrDept: WideString dispid 18;
    property jrCostCentre: WideString dispid 19;
    property jrJobAnal: WideString dispid 20;
    property jrJobType: WideString dispid 21;
    property jrJobStat: Integer dispid 22;
    property jrUserDef1: WideString dispid 23;
    property jrUserDef2: WideString dispid 24;
    property jrUserDef3: WideString dispid 25;
    property jrUserDef4: WideString dispid 26;
  end;

// *********************************************************************//
// Interface: ICOMJobRetention2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {79713D70-17B6-494C-A292-60159C1FC636}
// *********************************************************************//
  ICOMJobRetention2 = interface(ICOMJobRetention)
    ['{79713D70-17B6-494C-A292-60159C1FC636}']
    function Get_jrtAppMode: Integer; safecall;
    procedure Set_jrtAppMode(Value: Integer); safecall;
    property jrtAppMode: Integer read Get_jrtAppMode write Set_jrtAppMode;
  end;

// *********************************************************************//
// DispIntf:  ICOMJobRetention2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {79713D70-17B6-494C-A292-60159C1FC636}
// *********************************************************************//
  ICOMJobRetention2Disp = dispinterface
    ['{79713D70-17B6-494C-A292-60159C1FC636}']
    property jrtAppMode: Integer dispid 1;
    property AccessRights: TRecordAccessStatus readonly dispid 2;
    property jrtAnalysisCode: WideString dispid 3;
    property jrtOriginalCurrency: Integer dispid 4;
    property jrtYear: Integer dispid 5;
    property jrtPeriod: Integer dispid 6;
    property jrtPosted: WordBool dispid 7;
    property jrtPercent: Double dispid 8;
    property jrtCurrency: Integer dispid 9;
    property jrtValue: Double dispid 10;
    property jrtJobCode: WideString dispid 11;
    property jrtCreditDoc: WideString dispid 12;
    property jrtExpiryDate: WideString dispid 13;
    property jrtInvoiced: WordBool dispid 14;
    property jrtAcCode: WideString dispid 15;
    property jrtEntryDate: WideString dispid 17;
    property jrtCostCentre: WideString dispid 18;
    property jrtDepartment: WideString dispid 19;
    property jrtDefVATCode: WideString dispid 20;
    property jrtTransaction: WideString dispid 21;
    property jrtCISTax: Double dispid 22;
    property jrtCISGross: Double dispid 23;
    property jrtCISEmployee: WideString dispid 24;
  end;

// *********************************************************************//
// Interface: ICOMJobBudget2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5B426A81-A067-41F2-806A-4B35C7B90841}
// *********************************************************************//
  ICOMJobBudget2 = interface(ICOMJobBudget)
    ['{5B426A81-A067-41F2-806A-4B35C7B90841}']
    function Get_jbOrigValuation: Double; safecall;
    procedure Set_jbOrigValuation(Value: Double); safecall;
    function Get_jbRevValuation: Double; safecall;
    procedure Set_jbRevValuation(Value: Double); safecall;
    function Get_jbValuationPercentage: Double; safecall;
    procedure Set_jbValuationPercentage(Value: Double); safecall;
    function Get_jbValuationBasis: Integer; safecall;
    procedure Set_jbValuationBasis(Value: Integer); safecall;
    property jbOrigValuation: Double read Get_jbOrigValuation write Set_jbOrigValuation;
    property jbRevValuation: Double read Get_jbRevValuation write Set_jbRevValuation;
    property jbValuationPercentage: Double read Get_jbValuationPercentage write Set_jbValuationPercentage;
    property jbValuationBasis: Integer read Get_jbValuationBasis write Set_jbValuationBasis;
  end;

// *********************************************************************//
// DispIntf:  ICOMJobBudget2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5B426A81-A067-41F2-806A-4B35C7B90841}
// *********************************************************************//
  ICOMJobBudget2Disp = dispinterface
    ['{5B426A81-A067-41F2-806A-4B35C7B90841}']
    property jbOrigValuation: Double dispid 17;
    property jbRevValuation: Double dispid 18;
    property jbValuationPercentage: Double dispid 19;
    property jbValuationBasis: Integer dispid 20;
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property jbType: Integer dispid 2;
    property jbUnitPrice: Double dispid 3;
    property jbOriginalQty: Double dispid 4;
    property jbRevisedQty: Double dispid 5;
    property jbOriginalValue: Double dispid 6;
    property jbRevisedValue: Double dispid 7;
    property jbOriginalValuation: Double dispid 8;
    property jbRevisedValuation: Double dispid 9;
    property jbUplift: Double dispid 10;
    property jbBudgetType: Integer dispid 11;
    property jbJobCode: WideString dispid 12;
    property jbStockCode: WideString dispid 13;
    property jbAnalysisCode: WideString dispid 14;
    property jbRecharge: WordBool dispid 15;
    property jbCostOverhead: Double dispid 16;
  end;

// *********************************************************************//
// Interface: ICOMStock4
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FA61BF62-6323-4D67-8F8C-BD30F9C96C03}
// *********************************************************************//
  ICOMStock4 = interface(ICOMStock3)
    ['{FA61BF62-6323-4D67-8F8C-BD30F9C96C03}']
    function Get_stSalesWarrantyLength: Integer; safecall;
    procedure Set_stSalesWarrantyLength(Value: Integer); safecall;
    function Get_stSalesWarrantyUnits: TStockWarrantyUnits; safecall;
    procedure Set_stSalesWarrantyUnits(Value: TStockWarrantyUnits); safecall;
    function Get_stManufacturerWarrantyLength: Integer; safecall;
    procedure Set_stManufacturerWarrantyLength(Value: Integer); safecall;
    function Get_stManufacturerWarrantyUnits: TStockWarrantyUnits; safecall;
    procedure Set_stManufacturerWarrantyUnits(Value: TStockWarrantyUnits); safecall;
    function Get_stSalesReturnGL: Integer; safecall;
    procedure Set_stSalesReturnGL(Value: Integer); safecall;
    function Get_stPurchaseReturnGL: Integer; safecall;
    procedure Set_stPurchaseReturnGL(Value: Integer); safecall;
    function Get_stSalesReturnQty: Double; safecall;
    procedure Set_stSalesReturnQty(Value: Double); safecall;
    function Get_stPurchaseReturnQty: Double; safecall;
    procedure Set_stPurchaseReturnQty(Value: Double); safecall;
    function Get_stRestockCharge: Double; safecall;
    procedure Set_stRestockCharge(Value: Double); safecall;
    function Get_stRestockFlag: TStockRestockChargeType; safecall;
    procedure Set_stRestockFlag(Value: TStockRestockChargeType); safecall;
    property stSalesWarrantyLength: Integer read Get_stSalesWarrantyLength write Set_stSalesWarrantyLength;
    property stSalesWarrantyUnits: TStockWarrantyUnits read Get_stSalesWarrantyUnits write Set_stSalesWarrantyUnits;
    property stManufacturerWarrantyLength: Integer read Get_stManufacturerWarrantyLength write Set_stManufacturerWarrantyLength;
    property stManufacturerWarrantyUnits: TStockWarrantyUnits read Get_stManufacturerWarrantyUnits write Set_stManufacturerWarrantyUnits;
    property stSalesReturnGL: Integer read Get_stSalesReturnGL write Set_stSalesReturnGL;
    property stPurchaseReturnGL: Integer read Get_stPurchaseReturnGL write Set_stPurchaseReturnGL;
    property stSalesReturnQty: Double read Get_stSalesReturnQty write Set_stSalesReturnQty;
    property stPurchaseReturnQty: Double read Get_stPurchaseReturnQty write Set_stPurchaseReturnQty;
    property stRestockCharge: Double read Get_stRestockCharge write Set_stRestockCharge;
    property stRestockFlag: TStockRestockChargeType read Get_stRestockFlag write Set_stRestockFlag;
  end;

// *********************************************************************//
// DispIntf:  ICOMStock4Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FA61BF62-6323-4D67-8F8C-BD30F9C96C03}
// *********************************************************************//
  ICOMStock4Disp = dispinterface
    ['{FA61BF62-6323-4D67-8F8C-BD30F9C96C03}']
    property stSalesWarrantyLength: Integer dispid 97;
    property stSalesWarrantyUnits: TStockWarrantyUnits dispid 98;
    property stManufacturerWarrantyLength: Integer dispid 99;
    property stManufacturerWarrantyUnits: TStockWarrantyUnits dispid 100;
    property stSalesReturnGL: Integer dispid 101;
    property stPurchaseReturnGL: Integer dispid 102;
    property stSalesReturnQty: Double dispid 103;
    property stPurchaseReturnQty: Double dispid 104;
    property stRestockCharge: Double dispid 105;
    property stRestockFlag: TStockRestockChargeType dispid 106;
    property stUsesBins: WordBool dispid 96;
    property stUseForEbus: WordBool dispid 84;
    property stWebLiveCatalog: WideString dispid 85;
    property stWebPrevCatalog: WideString dispid 86;
    property stWOPROLeadTime: Integer dispid 87;
    property stWOPAssemblyHours: Integer dispid 88;
    property stWOPAssemblyMins: Integer dispid 89;
    property stWOPAutoCalcTime: WordBool dispid 90;
    property stWOPMinEconBuild: Double dispid 91;
    property stWOPIssuedWIPGL: Integer dispid 92;
    property stQtyAllocWOR: Double dispid 93;
    property stQtyIssuedWOR: Double dispid 94;
    property stQtyPickedWOR: Double dispid 95;
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property stCode: WideString dispid 3;
    property stDesc[Index: Integer]: WideString dispid 81;
    property stAltCode: WideString dispid 4;
    property stSuppTemp: WideString dispid 5;
    property stSalesGL: Integer dispid 6;
    property stCOSGL: Integer dispid 7;
    property stPandLGL: Integer dispid 8;
    property stBalSheetGL: Integer dispid 9;
    property stWIPGL: Integer dispid 10;
    property stReOrderFlag: WordBool dispid 11;
    property stMinFlg: WordBool dispid 12;
    property stStockFolio: Integer dispid 13;
    property stStockCat: WideString dispid 14;
    property stStockType: WideString dispid 15;
    property stUnitOfStock: WideString dispid 16;
    property stUnitOfSale: WideString dispid 17;
    property stUnitOfPurch: WideString dispid 18;
    property stCostPriceCur: TCurrencyType dispid 19;
    property stCostPrice: Double dispid 20;
    property stSalesUnits: Double dispid 21;
    property stPurchUnits: Double dispid 22;
    property stVATCode: WideString dispid 23;
    property stCostCentre: WideString dispid 24;
    property stDepartment: WideString dispid 25;
    property stQtyInStock: Double dispid 26;
    property stQtyPosted: Double dispid 27;
    property stQtyAllocated: Double dispid 28;
    property stQtyOnOrder: Double dispid 29;
    property stQtyMin: Double dispid 30;
    property stQtyMax: Double dispid 31;
    property stReOrderQty: Double dispid 32;
    property stKitOnPurch: WordBool dispid 33;
    property stShowAsKit: WordBool dispid 34;
    property stCommodCode: WideString dispid 35;
    property stSaleUnWeight: Double dispid 36;
    property stPurchUnWeight: Double dispid 37;
    property stSSDUnit: WideString dispid 38;
    property stSSDSalesUnit: Double dispid 39;
    property stBinLocation: WideString dispid 40;
    property stStkFlg: WordBool dispid 41;
    property stCovPr: Smallint dispid 42;
    property stCovPrUnit: WideString dispid 43;
    property stCovMinPr: Smallint dispid 44;
    property stCovMinUnit: WideString dispid 45;
    property stSupplier: WideString dispid 46;
    property stQtyFreeze: Double dispid 47;
    property stCovSold: Double dispid 48;
    property stUseCover: WordBool dispid 49;
    property stCovMaxPr: Smallint dispid 50;
    property stCovMaxUnit: WideString dispid 51;
    property stReOrderCur: Smallint dispid 52;
    property stReOrderPrice: Double dispid 53;
    property stReOrderDate: WideString dispid 54;
    property stQtyTake: Double dispid 55;
    property stStkValType: WideString dispid 56;
    property stQtyPicked: Double dispid 57;
    property stLastUsed: WideString dispid 58;
    property stCalcPack: WordBool dispid 59;
    property stJobAnal: WideString dispid 60;
    property stStkUser1: WideString dispid 61;
    property stStkUser2: WideString dispid 62;
    property stBarCode: WideString dispid 63;
    property stROCostCentre: WideString dispid 64;
    property stRODepartment: WideString dispid 65;
    property stLocation: WideString dispid 66;
    property stPricePack: WordBool dispid 67;
    property stDPackQty: WordBool dispid 68;
    property stKitPrice: WordBool dispid 69;
    property stStkUser3: WideString dispid 70;
    property stStkUser4: WideString dispid 71;
    property stSerNoWAvg: Smallint dispid 72;
    property stStkSizeCol: Smallint readonly dispid 73;
    property stSSDDUplift: Double dispid 74;
    property stSSDCountry: WideString dispid 75;
    property stTimeChange: WideString readonly dispid 76;
    property stSVATIncFlg: WideString dispid 77;
    property stSSDAUpLift: Double dispid 78;
    property stLastOpo: WideString dispid 79;
    property stImageFile: WideString dispid 80;
    property stSaleBandsCur[const Index: WideString]: TCurrencyType dispid 82;
    property stSaleBandsPrice[const Index: WideString]: Double dispid 83;
  end;

// *********************************************************************//
// Interface: ICOMBatchSerial3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D6D0D3FA-36EC-4A95-BA62-502534FB262E}
// *********************************************************************//
  ICOMBatchSerial3 = interface(ICOMBatchSerial2)
    ['{D6D0D3FA-36EC-4A95-BA62-502534FB262E}']
    function Get_bsReturned: WordBool; safecall;
    procedure Set_bsReturned(Value: WordBool); safecall;
    function Get_bsReturnOurRef: WideString; safecall;
    procedure Set_bsReturnOurRef(const Value: WideString); safecall;
    function Get_bsBatchReturnedQty: Double; safecall;
    procedure Set_bsBatchReturnedQty(Value: Double); safecall;
    function Get_bsReturnLineNo: Integer; safecall;
    procedure Set_bsReturnLineNo(Value: Integer); safecall;
    property bsReturned: WordBool read Get_bsReturned write Set_bsReturned;
    property bsReturnOurRef: WideString read Get_bsReturnOurRef write Set_bsReturnOurRef;
    property bsBatchReturnedQty: Double read Get_bsBatchReturnedQty write Set_bsBatchReturnedQty;
    property bsReturnLineNo: Integer read Get_bsReturnLineNo write Set_bsReturnLineNo;
  end;

// *********************************************************************//
// DispIntf:  ICOMBatchSerial3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D6D0D3FA-36EC-4A95-BA62-502534FB262E}
// *********************************************************************//
  ICOMBatchSerial3Disp = dispinterface
    ['{D6D0D3FA-36EC-4A95-BA62-502534FB262E}']
    property bsReturned: WordBool dispid 35;
    property bsReturnOurRef: WideString dispid 36;
    property bsBatchReturnedQty: Double dispid 37;
    property bsReturnLineNo: Integer dispid 38;
    property bsBinCode: WideString dispid 34;
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property bsSerialCode: WideString dispid 3;
    property bsSerialNo: WideString dispid 4;
    property bsBatchNo: WideString dispid 5;
    property bsInDoc: WideString dispid 6;
    property bsOutDoc: WideString dispid 7;
    property bsSold: WordBool dispid 8;
    property bsDateIn: WideString dispid 9;
    property bsSerCost: Double dispid 10;
    property bsSerSell: Double dispid 11;
    property bsStkFolio: Integer dispid 12;
    property bsDateOut: WideString dispid 13;
    property bsSoldLine: Integer dispid 14;
    property bsCurCost: TCurrencyType dispid 15;
    property bsCurSell: TCurrencyType dispid 16;
    property bsBuyLine: Integer dispid 17;
    property bsBatchRec: WordBool dispid 18;
    property bsBuyQty: Double dispid 19;
    property bsQtyUsed: Double dispid 20;
    property bsBatchChild: WordBool dispid 21;
    property bsInMLoc: WideString dispid 22;
    property bsOutMLoc: WideString dispid 23;
    property bsCompanyRate: Double dispid 24;
    property bsDailyRate: Double dispid 25;
    property bsInOrdDoc: WideString dispid 26;
    property bsOutOrdDoc: WideString dispid 27;
    property bsInOrdLine: Integer dispid 28;
    property bsOutOrdLine: Integer dispid 29;
    property bsNLineCount: Integer dispid 30;
    property bsNoteFolio: Integer dispid 31;
    property bsDateUseX: WideString dispid 32;
    property bsSUseORate: Smallint dispid 33;
  end;

// *********************************************************************//
// Interface: ICOMTransactionLine5
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3458E863-6094-4BE1-A978-4C1F34E22B82}
// *********************************************************************//
  ICOMTransactionLine5 = interface(ICOMTransactionLine4)
    ['{3458E863-6094-4BE1-A978-4C1F34E22B82}']
    function Get_tlSerialReturnQty: Double; safecall;
    procedure Set_tlSerialReturnQty(Value: Double); safecall;
    function Get_tlBinReturnQty: Double; safecall;
    procedure Set_tlBinReturnQty(Value: Double); safecall;
    property tlSerialReturnQty: Double read Get_tlSerialReturnQty write Set_tlSerialReturnQty;
    property tlBinReturnQty: Double read Get_tlBinReturnQty write Set_tlBinReturnQty;
  end;

// *********************************************************************//
// DispIntf:  ICOMTransactionLine5Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3458E863-6094-4BE1-A978-4C1F34E22B82}
// *********************************************************************//
  ICOMTransactionLine5Disp = dispinterface
    ['{3458E863-6094-4BE1-A978-4C1F34E22B82}']
    property tlSerialReturnQty: Double dispid 70;
    property tlBinReturnQty: Double dispid 71;
    property tlCISAdjustments: Double dispid 68;
    property tlAppsDeductType: Integer dispid 69;
    property tlNOMVATType: TNOMLineVATType dispid 67;
    property tlLineSource: Integer dispid 62;
    property tlCISRateCode: WideString dispid 63;
    property tlCISRate: Double dispid 64;
    property tlCostApport: Double dispid 65;
    property tlVATInclValue: Double dispid 66;
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property DataChanged: WordBool readonly dispid 2;
    property tlFolio: Integer dispid 3;
    property tlLinePos: Integer dispid 4;
    property tlRunNo: Integer dispid 5;
    property tlGLCode: Integer dispid 6;
    property tlShowInGL: Smallint dispid 7;
    property tlCurrency: TCurrencyType dispid 8;
    property tlYear: Smallint readonly dispid 9;
    property tlPeriod: Smallint readonly dispid 10;
    property tlCostCentre: WideString dispid 11;
    property tlDepartment: WideString dispid 12;
    property tlStockCode: WideString dispid 13;
    property tlLineNo: Integer dispid 14;
    property tlLineClass: WideString readonly dispid 15;
    property tlDocType: TDocTypes readonly dispid 16;
    property tlQty: Double dispid 17;
    property tlQtyMul: Double dispid 18;
    property tlNetValue: Double dispid 19;
    property tlDiscount: Double dispid 20;
    property tlVATCode: WideString dispid 21;
    property tlVATAmount: Double dispid 22;
    property tlPayStatus: WideString dispid 23;
    property tlPrevGLBal: Double dispid 24;
    property tlRecStatus: Smallint dispid 25;
    property tlDiscFlag: WideString dispid 26;
    property tlQtyWOFF: Double dispid 27;
    property tlQtyDel: Double dispid 28;
    property tlCost: Double dispid 29;
    property tlAcCode: WideString readonly dispid 30;
    property tlTransDate: WideString dispid 31;
    property tlItemNo: WideString dispid 32;
    property tlDescr: WideString dispid 33;
    property tlJobCode: WideString dispid 34;
    property tlJobAnal: WideString dispid 35;
    property tlCompanyRate: Double dispid 36;
    property tlDailyRate: Double dispid 37;
    property tlUnitWeight: Double dispid 38;
    property tlStockDeductQty: Double dispid 39;
    property tlBOMKitLink: Integer dispid 40;
    property tlOrderFolio: Integer dispid 41;
    property tlOrderLineNo: Integer dispid 42;
    property tlLocation: WideString dispid 43;
    property tlQtyPicked: Double dispid 44;
    property tlQtyPickedWO: Double dispid 45;
    property tlUseQtyMul: WordBool dispid 46;
    property tlNoSerialNos: Double dispid 47;
    property tlCOSGL: Integer dispid 48;
    property tlOurRef: WideString readonly dispid 49;
    property tlLineType: Integer dispid 50;
    property tlPriceByPack: WordBool dispid 51;
    property tlQtyInPack: Double dispid 52;
    property tlClearDate: WideString dispid 53;
    property tlUserDef1: WideString dispid 54;
    property tlUserDef2: WideString dispid 55;
    property tlUserDef3: WideString dispid 56;
    property tlUserDef4: WideString dispid 57;
    function entInvLTotal(UseDisc: WordBool; SetlDisc: Double): Double; dispid 58;
    procedure Delete; dispid 59;
    procedure Save; dispid 60;
    function LinkToStock: WordBool; dispid 61;
  end;

// *********************************************************************//
// Interface: ICOMMultiBin2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3E11579D-F3AF-4A3B-817E-9725317EC233}
// *********************************************************************//
  ICOMMultiBin2 = interface(ICOMMultiBin)
    ['{3E11579D-F3AF-4A3B-817E-9725317EC233}']
    function Get_brReturned: WordBool; safecall;
    procedure Set_brReturned(Value: WordBool); safecall;
    property brReturned: WordBool read Get_brReturned write Set_brReturned;
  end;

// *********************************************************************//
// DispIntf:  ICOMMultiBin2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3E11579D-F3AF-4A3B-817E-9725317EC233}
// *********************************************************************//
  ICOMMultiBin2Disp = dispinterface
    ['{3E11579D-F3AF-4A3B-817E-9725317EC233}']
    property brReturned: WordBool dispid 34;
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property brBinCode: WideString dispid 2;
    property brStockFolio: Integer dispid 3;
    property brPickingPriority: WideString dispid 4;
    property brUseByDate: WideString dispid 5;
    property brUnitOfMeasurement: WideString dispid 6;
    property brAutoPickMode: Integer dispid 7;
    property brTagNo: Integer dispid 8;
    property brQty: Double dispid 9;
    property brQtyUsed: Double dispid 10;
    property brCapacity: Double dispid 11;
    property brCostPrice: Double dispid 12;
    property brCostPriceCurrency: Integer dispid 13;
    property brSalesPrice: Double dispid 14;
    property brSalesPriceCurrency: Integer dispid 15;
    property brInDate: WideString dispid 16;
    property brInOrderRef: WideString dispid 17;
    property brInOrderLine: Integer dispid 18;
    property brInDocRef: WideString dispid 19;
    property brInDocLine: Integer dispid 20;
    property brInLocation: WideString dispid 21;
    property brUsedRec: WordBool dispid 22;
    property brSold: WordBool dispid 23;
    property brOutDate: WideString dispid 24;
    property brOutOrderRef: WideString dispid 25;
    property brOutOrderLine: Integer dispid 26;
    property brOutDocRef: WideString dispid 27;
    property brOutDocLine: Integer dispid 28;
    property brOutLocation: WideString dispid 29;
    property brCompanyRate: Double dispid 30;
    property brDailyRate: Double dispid 31;
    property brUseORate: Smallint dispid 32;
    property brTriangulation: ICOMCurrencyTriangulation readonly dispid 33;
  end;

// *********************************************************************//
// Interface: ICOMLocation
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8C9EB88B-364E-4F3C-8F5F-A1B62682C51B}
// *********************************************************************//
  ICOMLocation = interface(IDispatch)
    ['{8C9EB88B-364E-4F3C-8F5F-A1B62682C51B}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_loCode: WideString; safecall;
    procedure Set_loCode(const Value: WideString); safecall;
    function Get_loName: WideString; safecall;
    procedure Set_loName(const Value: WideString); safecall;
    function Get_loAddress(Index: Integer): WideString; safecall;
    procedure Set_loAddress(Index: Integer; const Value: WideString); safecall;
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
    function Get_loCurrency: TCurrencyType; safecall;
    procedure Set_loCurrency(Value: TCurrencyType); safecall;
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
    function Get_loSalesReturnGL: Integer; safecall;
    procedure Set_loSalesReturnGL(Value: Integer); safecall;
    function Get_loPurchaseReturnGL: Integer; safecall;
    procedure Set_loPurchaseReturnGL(Value: Integer); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property loCode: WideString read Get_loCode write Set_loCode;
    property loName: WideString read Get_loName write Set_loName;
    property loAddress[Index: Integer]: WideString read Get_loAddress write Set_loAddress;
    property loPhone: WideString read Get_loPhone write Set_loPhone;
    property loFax: WideString read Get_loFax write Set_loFax;
    property loEmailAddr: WideString read Get_loEmailAddr write Set_loEmailAddr;
    property loModem: WideString read Get_loModem write Set_loModem;
    property loContact: WideString read Get_loContact write Set_loContact;
    property loCurrency: TCurrencyType read Get_loCurrency write Set_loCurrency;
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
    property loSalesReturnGL: Integer read Get_loSalesReturnGL write Set_loSalesReturnGL;
    property loPurchaseReturnGL: Integer read Get_loPurchaseReturnGL write Set_loPurchaseReturnGL;
  end;

// *********************************************************************//
// DispIntf:  ICOMLocationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8C9EB88B-364E-4F3C-8F5F-A1B62682C51B}
// *********************************************************************//
  ICOMLocationDisp = dispinterface
    ['{8C9EB88B-364E-4F3C-8F5F-A1B62682C51B}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property loCode: WideString dispid 2;
    property loName: WideString dispid 3;
    property loAddress[Index: Integer]: WideString dispid 4;
    property loPhone: WideString dispid 5;
    property loFax: WideString dispid 6;
    property loEmailAddr: WideString dispid 7;
    property loModem: WideString dispid 8;
    property loContact: WideString dispid 9;
    property loCurrency: TCurrencyType dispid 10;
    property loArea: WideString dispid 11;
    property loRep: WideString dispid 12;
    property loTagged: WordBool dispid 13;
    property loCostCentre: WideString dispid 14;
    property loDepartment: WideString dispid 15;
    property loOverrideSalesPrice: WordBool dispid 16;
    property loOverrideGLCodes: WordBool dispid 17;
    property loOverrideCCDept: WordBool dispid 18;
    property loOverrideSupplier: WordBool dispid 19;
    property loOverrideBinLocation: WordBool dispid 20;
    property loSalesGL: Integer dispid 21;
    property loCostOfSalesGL: Integer dispid 22;
    property loPandLGL: Integer dispid 23;
    property loBalSheetGL: Integer dispid 24;
    property loWIPGL: Integer dispid 25;
    property loSalesReturnGL: Integer dispid 27;
    property loPurchaseReturnGL: Integer dispid 28;
  end;

// *********************************************************************//
// Interface: ICOMStockLocation
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1EC27153-AB88-4526-8B2E-18AA94714EFE}
// *********************************************************************//
  ICOMStockLocation = interface(IDispatch)
    ['{1EC27153-AB88-4526-8B2E-18AA94714EFE}']
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_slStockCode: WideString; safecall;
    procedure Set_slStockCode(const Value: WideString); safecall;
    function Get_slLocationCode: WideString; safecall;
    procedure Set_slLocationCode(const Value: WideString); safecall;
    function Get_slQtyInStock: Double; safecall;
    procedure Set_slQtyInStock(Value: Double); safecall;
    function Get_slQtyOnOrder: Double; safecall;
    procedure Set_slQtyOnOrder(Value: Double); safecall;
    function Get_slQtyAllocated: Double; safecall;
    procedure Set_slQtyAllocated(Value: Double); safecall;
    function Get_slQtyPicked: Double; safecall;
    procedure Set_slQtyPicked(Value: Double); safecall;
    function Get_slQtyMin: Double; safecall;
    procedure Set_slQtyMin(Value: Double); safecall;
    function Get_slQtyMax: Double; safecall;
    procedure Set_slQtyMax(Value: Double); safecall;
    function Get_slQtyFreeze: Double; safecall;
    procedure Set_slQtyFreeze(Value: Double); safecall;
    function Get_slReorderQty: Double; safecall;
    procedure Set_slReorderQty(Value: Double); safecall;
    function Get_slReorderCur: TCurrencyType; safecall;
    procedure Set_slReorderCur(Value: TCurrencyType); safecall;
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
    function Get_slCostPriceCur: TCurrencyType; safecall;
    procedure Set_slCostPriceCur(Value: TCurrencyType); safecall;
    function Get_slCostPrice: Double; safecall;
    procedure Set_slCostPrice(Value: Double); safecall;
    function Get_slBelowMinLevel: WordBool; safecall;
    procedure Set_slBelowMinLevel(Value: WordBool); safecall;
    function Get_slSuppTemp: WideString; safecall;
    procedure Set_slSuppTemp(const Value: WideString); safecall;
    function Get_slSupplier: WideString; safecall;
    procedure Set_slSupplier(const Value: WideString); safecall;
    function Get_slLastUsed: WideString; safecall;
    procedure Set_slLastUsed(const Value: WideString); safecall;
    function Get_slQtyPosted: Double; safecall;
    procedure Set_slQtyPosted(Value: Double); safecall;
    function Get_slQtyStockTake: Double; safecall;
    procedure Set_slQtyStockTake(Value: Double); safecall;
    function Get_slTimeChange: WideString; safecall;
    procedure Set_slTimeChange(const Value: WideString); safecall;
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
    function Get_slSaleBandsCur(const Index: WideString): TCurrencyType; safecall;
    procedure Set_slSaleBandsCur(const Index: WideString; Value: TCurrencyType); safecall;
    function Get_slSaleBandsPrice(const Index: WideString): Double; safecall;
    procedure Set_slSaleBandsPrice(const Index: WideString; Value: Double); safecall;
    function Get_slQtyFree: Double; safecall;
    function Get_slPurchaseReturnGL: Integer; safecall;
    procedure Set_slPurchaseReturnGL(Value: Integer); safecall;
    function Get_slPurchaseReturnQty: Double; safecall;
    procedure Set_slPurchaseReturnQty(Value: Double); safecall;
    function Get_slManufacturerWarrantyLength: Integer; safecall;
    procedure Set_slManufacturerWarrantyLength(Value: Integer); safecall;
    function Get_slManufacturerWarrantyUnits: TStockWarrantyUnits; safecall;
    procedure Set_slManufacturerWarrantyUnits(Value: TStockWarrantyUnits); safecall;
    function Get_slRestockCharge: Double; safecall;
    procedure Set_slRestockCharge(Value: Double); safecall;
    function Get_slSalesReturnGL: Integer; safecall;
    procedure Set_slSalesReturnGL(Value: Integer); safecall;
    function Get_slSalesReturnQty: Double; safecall;
    procedure Set_slSalesReturnQty(Value: Double); safecall;
    function Get_slSalesWarrantyLength: Integer; safecall;
    procedure Set_slSalesWarrantyLength(Value: Integer); safecall;
    function Get_slSalesWarrantyUnits: TStockWarrantyUnits; safecall;
    procedure Set_slSalesWarrantyUnits(Value: TStockWarrantyUnits); safecall;
    property AccessRights: TRecordAccessStatus read Get_AccessRights;
    property slStockCode: WideString read Get_slStockCode write Set_slStockCode;
    property slLocationCode: WideString read Get_slLocationCode write Set_slLocationCode;
    property slQtyInStock: Double read Get_slQtyInStock write Set_slQtyInStock;
    property slQtyOnOrder: Double read Get_slQtyOnOrder write Set_slQtyOnOrder;
    property slQtyAllocated: Double read Get_slQtyAllocated write Set_slQtyAllocated;
    property slQtyPicked: Double read Get_slQtyPicked write Set_slQtyPicked;
    property slQtyMin: Double read Get_slQtyMin write Set_slQtyMin;
    property slQtyMax: Double read Get_slQtyMax write Set_slQtyMax;
    property slQtyFreeze: Double read Get_slQtyFreeze write Set_slQtyFreeze;
    property slReorderQty: Double read Get_slReorderQty write Set_slReorderQty;
    property slReorderCur: TCurrencyType read Get_slReorderCur write Set_slReorderCur;
    property slReorderPrice: Double read Get_slReorderPrice write Set_slReorderPrice;
    property slReorderDate: WideString read Get_slReorderDate write Set_slReorderDate;
    property slReorderCostCentre: WideString read Get_slReorderCostCentre write Set_slReorderCostCentre;
    property slReorderDepartment: WideString read Get_slReorderDepartment write Set_slReorderDepartment;
    property slCostCentre: WideString read Get_slCostCentre write Set_slCostCentre;
    property slDepartment: WideString read Get_slDepartment write Set_slDepartment;
    property slBinLocation: WideString read Get_slBinLocation write Set_slBinLocation;
    property slCostPriceCur: TCurrencyType read Get_slCostPriceCur write Set_slCostPriceCur;
    property slCostPrice: Double read Get_slCostPrice write Set_slCostPrice;
    property slBelowMinLevel: WordBool read Get_slBelowMinLevel write Set_slBelowMinLevel;
    property slSuppTemp: WideString read Get_slSuppTemp write Set_slSuppTemp;
    property slSupplier: WideString read Get_slSupplier write Set_slSupplier;
    property slLastUsed: WideString read Get_slLastUsed write Set_slLastUsed;
    property slQtyPosted: Double read Get_slQtyPosted write Set_slQtyPosted;
    property slQtyStockTake: Double read Get_slQtyStockTake write Set_slQtyStockTake;
    property slTimeChange: WideString read Get_slTimeChange write Set_slTimeChange;
    property slSalesGL: Integer read Get_slSalesGL write Set_slSalesGL;
    property slCostOfSalesGL: Integer read Get_slCostOfSalesGL write Set_slCostOfSalesGL;
    property slPandLGL: Integer read Get_slPandLGL write Set_slPandLGL;
    property slBalSheetGL: Integer read Get_slBalSheetGL write Set_slBalSheetGL;
    property slWIPGL: Integer read Get_slWIPGL write Set_slWIPGL;
    property slSaleBandsCur[const Index: WideString]: TCurrencyType read Get_slSaleBandsCur write Set_slSaleBandsCur;
    property slSaleBandsPrice[const Index: WideString]: Double read Get_slSaleBandsPrice write Set_slSaleBandsPrice;
    property slQtyFree: Double read Get_slQtyFree;
    property slPurchaseReturnGL: Integer read Get_slPurchaseReturnGL write Set_slPurchaseReturnGL;
    property slPurchaseReturnQty: Double read Get_slPurchaseReturnQty write Set_slPurchaseReturnQty;
    property slManufacturerWarrantyLength: Integer read Get_slManufacturerWarrantyLength write Set_slManufacturerWarrantyLength;
    property slManufacturerWarrantyUnits: TStockWarrantyUnits read Get_slManufacturerWarrantyUnits write Set_slManufacturerWarrantyUnits;
    property slRestockCharge: Double read Get_slRestockCharge write Set_slRestockCharge;
    property slSalesReturnGL: Integer read Get_slSalesReturnGL write Set_slSalesReturnGL;
    property slSalesReturnQty: Double read Get_slSalesReturnQty write Set_slSalesReturnQty;
    property slSalesWarrantyLength: Integer read Get_slSalesWarrantyLength write Set_slSalesWarrantyLength;
    property slSalesWarrantyUnits: TStockWarrantyUnits read Get_slSalesWarrantyUnits write Set_slSalesWarrantyUnits;
  end;

// *********************************************************************//
// DispIntf:  ICOMStockLocationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1EC27153-AB88-4526-8B2E-18AA94714EFE}
// *********************************************************************//
  ICOMStockLocationDisp = dispinterface
    ['{1EC27153-AB88-4526-8B2E-18AA94714EFE}']
    property AccessRights: TRecordAccessStatus readonly dispid 1;
    property slStockCode: WideString dispid 2;
    property slLocationCode: WideString dispid 3;
    property slQtyInStock: Double dispid 4;
    property slQtyOnOrder: Double dispid 5;
    property slQtyAllocated: Double dispid 6;
    property slQtyPicked: Double dispid 7;
    property slQtyMin: Double dispid 8;
    property slQtyMax: Double dispid 9;
    property slQtyFreeze: Double dispid 10;
    property slReorderQty: Double dispid 11;
    property slReorderCur: TCurrencyType dispid 12;
    property slReorderPrice: Double dispid 13;
    property slReorderDate: WideString dispid 14;
    property slReorderCostCentre: WideString dispid 15;
    property slReorderDepartment: WideString dispid 16;
    property slCostCentre: WideString dispid 17;
    property slDepartment: WideString dispid 18;
    property slBinLocation: WideString dispid 19;
    property slCostPriceCur: TCurrencyType dispid 20;
    property slCostPrice: Double dispid 21;
    property slBelowMinLevel: WordBool dispid 22;
    property slSuppTemp: WideString dispid 23;
    property slSupplier: WideString dispid 24;
    property slLastUsed: WideString dispid 25;
    property slQtyPosted: Double dispid 26;
    property slQtyStockTake: Double dispid 27;
    property slTimeChange: WideString dispid 28;
    property slSalesGL: Integer dispid 29;
    property slCostOfSalesGL: Integer dispid 30;
    property slPandLGL: Integer dispid 31;
    property slBalSheetGL: Integer dispid 32;
    property slWIPGL: Integer dispid 33;
    property slSaleBandsCur[const Index: WideString]: TCurrencyType dispid 34;
    property slSaleBandsPrice[const Index: WideString]: Double dispid 35;
    property slQtyFree: Double readonly dispid 36;
    property slPurchaseReturnGL: Integer dispid 37;
    property slPurchaseReturnQty: Double dispid 38;
    property slManufacturerWarrantyLength: Integer dispid 39;
    property slManufacturerWarrantyUnits: TStockWarrantyUnits dispid 40;
    property slRestockCharge: Double dispid 41;
    property slSalesReturnGL: Integer dispid 42;
    property slSalesReturnQty: Double dispid 43;
    property slSalesWarrantyLength: Integer dispid 44;
    property slSalesWarrantyUnits: TStockWarrantyUnits dispid 45;
  end;

// *********************************************************************//
// Interface: ICOMPaperless
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0D819C18-E717-40E3-9F10-D172BB5EB5AC}
// *********************************************************************//
  ICOMPaperless = interface(IDispatch)
    ['{0D819C18-E717-40E3-9F10-D172BB5EB5AC}']
    function Get_Email: ICOMPaperlessEmail; safecall;
    property Email: ICOMPaperlessEmail read Get_Email;
  end;

// *********************************************************************//
// DispIntf:  ICOMPaperlessDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0D819C18-E717-40E3-9F10-D172BB5EB5AC}
// *********************************************************************//
  ICOMPaperlessDisp = dispinterface
    ['{0D819C18-E717-40E3-9F10-D172BB5EB5AC}']
    property Email: ICOMPaperlessEmail readonly dispid 1;
  end;

// *********************************************************************//
// Interface: ICOMPaperlessEmail
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {14F0A5B0-0DFF-4515-93D8-28A40340E513}
// *********************************************************************//
  ICOMPaperlessEmail = interface(IDispatch)
    ['{14F0A5B0-0DFF-4515-93D8-28A40340E513}']
    function Get_emSenderName: WideString; safecall;
    procedure Set_emSenderName(const Value: WideString); safecall;
    function Get_emSenderAddress: WideString; safecall;
    procedure Set_emSenderAddress(const Value: WideString); safecall;
    function Get_emToRecipients: ICOMPaperlessEmailAddressArray; safecall;
    function Get_emCCRecipients: ICOMPaperlessEmailAddressArray; safecall;
    function Get_emBCCRecipients: ICOMPaperlessEmailAddressArray; safecall;
    function Get_emSubject: WideString; safecall;
    procedure Set_emSubject(const Value: WideString); safecall;
    function Get_emMessageText: WideString; safecall;
    procedure Set_emMessageText(const Value: WideString); safecall;
    function Get_emAttachments: ICOMPaperlessEmailAttachments; safecall;
    function Get_emPriority: TEmailPriority; safecall;
    procedure Set_emPriority(Value: TEmailPriority); safecall;
    function Get_emCoverSheet: WideString; safecall;
    procedure Set_emCoverSheet(const Value: WideString); safecall;
    function Get_emSendReader: WordBool; safecall;
    procedure Set_emSendReader(Value: WordBool); safecall;
    property emSenderName: WideString read Get_emSenderName write Set_emSenderName;
    property emSenderAddress: WideString read Get_emSenderAddress write Set_emSenderAddress;
    property emToRecipients: ICOMPaperlessEmailAddressArray read Get_emToRecipients;
    property emCCRecipients: ICOMPaperlessEmailAddressArray read Get_emCCRecipients;
    property emBCCRecipients: ICOMPaperlessEmailAddressArray read Get_emBCCRecipients;
    property emSubject: WideString read Get_emSubject write Set_emSubject;
    property emMessageText: WideString read Get_emMessageText write Set_emMessageText;
    property emAttachments: ICOMPaperlessEmailAttachments read Get_emAttachments;
    property emPriority: TEmailPriority read Get_emPriority write Set_emPriority;
    property emCoverSheet: WideString read Get_emCoverSheet write Set_emCoverSheet;
    property emSendReader: WordBool read Get_emSendReader write Set_emSendReader;
  end;

// *********************************************************************//
// DispIntf:  ICOMPaperlessEmailDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {14F0A5B0-0DFF-4515-93D8-28A40340E513}
// *********************************************************************//
  ICOMPaperlessEmailDisp = dispinterface
    ['{14F0A5B0-0DFF-4515-93D8-28A40340E513}']
    property emSenderName: WideString dispid 1;
    property emSenderAddress: WideString dispid 2;
    property emToRecipients: ICOMPaperlessEmailAddressArray readonly dispid 3;
    property emCCRecipients: ICOMPaperlessEmailAddressArray readonly dispid 4;
    property emBCCRecipients: ICOMPaperlessEmailAddressArray readonly dispid 5;
    property emSubject: WideString dispid 6;
    property emMessageText: WideString dispid 7;
    property emAttachments: ICOMPaperlessEmailAttachments readonly dispid 8;
    property emPriority: TEmailPriority dispid 9;
    property emCoverSheet: WideString dispid 10;
    property emSendReader: WordBool dispid 11;
  end;

// *********************************************************************//
// Interface: ICOMEventData4
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9BE5E685-069F-48E0-B49A-59804BD9382F}
// *********************************************************************//
  ICOMEventData4 = interface(ICOMEventData3)
    ['{9BE5E685-069F-48E0-B49A-59804BD9382F}']
    function Get_BatchSerial3: ICOMBatchSerial3; safecall;
    function Get_Bin2: ICOMMultiBin2; safecall;
    function Get_Location: ICOMLocation; safecall;
    function Get_Paperless: ICOMPaperless; safecall;
    function Get_Stock4: ICOMStock4; safecall;
    function Get_StockLocation: ICOMStockLocation; safecall;
    property BatchSerial3: ICOMBatchSerial3 read Get_BatchSerial3;
    property Bin2: ICOMMultiBin2 read Get_Bin2;
    property Location: ICOMLocation read Get_Location;
    property Paperless: ICOMPaperless read Get_Paperless;
    property Stock4: ICOMStock4 read Get_Stock4;
    property StockLocation: ICOMStockLocation read Get_StockLocation;
  end;

// *********************************************************************//
// DispIntf:  ICOMEventData4Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9BE5E685-069F-48E0-B49A-59804BD9382F}
// *********************************************************************//
  ICOMEventData4Disp = dispinterface
    ['{9BE5E685-069F-48E0-B49A-59804BD9382F}']
    property BatchSerial3: ICOMBatchSerial3 readonly dispid 27;
    property Bin2: ICOMMultiBin2 readonly dispid 28;
    property Location: ICOMLocation readonly dispid 29;
    property Paperless: ICOMPaperless readonly dispid 30;
    property Stock4: ICOMStock4 readonly dispid 31;
    property StockLocation: ICOMStockLocation readonly dispid 32;
    property BatchSerial2: ICOMBatchSerial2 readonly dispid 18;
    property Bin: ICOMMultiBin readonly dispid 19;
    property Stock3: ICOMStock3 readonly dispid 26;
    property Customer2: ICOMCustomer3 readonly dispid 20;
    property JobCosting: ICOMJobCosting readonly dispid 21;
    property Supplier2: ICOMCustomer3 readonly dispid 22;
    property Telesales: ICOMTelesales readonly dispid 23;
    property Transaction2: ICOMTransaction3 readonly dispid 24;
    property BatchSerial: ICOMBatchSerial readonly dispid 37;
    property WindowId: Integer readonly dispid 1;
    property HandlerId: Integer readonly dispid 2;
    property Customer: ICOMCustomer readonly dispid 3;
    property Supplier: ICOMCustomer readonly dispid 4;
    property CostCentre: ICOMCCDept readonly dispid 5;
    property Department: ICOMCCDept readonly dispid 6;
    property GLCode: ICOMGLCode readonly dispid 7;
    property Stock: ICOMStock readonly dispid 8;
    property Transaction: ICOMTransaction readonly dispid 9;
    property Job: ICOMJob readonly dispid 10;
    property MiscData: ICOMMiscData readonly dispid 11;
    property ValidStatus: WordBool dispid 12;
    property BoResult: WordBool dispid 13;
    property DblResult: Double dispid 14;
    property IntResult: Integer dispid 15;
    property StrResult: WideString dispid 16;
    property VarResult: OleVariant dispid 17;
    property InEditMode: WordBool readonly dispid 25;
  end;

// *********************************************************************//
// Interface: ICOMPaperlessEmailAddressArray
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {45BE6DBF-A1BD-4C5B-91EA-00E5D0629C6C}
// *********************************************************************//
  ICOMPaperlessEmailAddressArray = interface(IDispatch)
    ['{45BE6DBF-A1BD-4C5B-91EA-00E5D0629C6C}']
    function Get_adCount: Integer; safecall;
    function Get_adItems(Index: Integer): ICOMPaperlessEmailAddress; safecall;
    procedure AddAddress(const Name: WideString; const Address: WideString); safecall;
    procedure Clear; safecall;
    procedure Delete(Index: Integer); safecall;
    property adCount: Integer read Get_adCount;
    property adItems[Index: Integer]: ICOMPaperlessEmailAddress read Get_adItems;
  end;

// *********************************************************************//
// DispIntf:  ICOMPaperlessEmailAddressArrayDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {45BE6DBF-A1BD-4C5B-91EA-00E5D0629C6C}
// *********************************************************************//
  ICOMPaperlessEmailAddressArrayDisp = dispinterface
    ['{45BE6DBF-A1BD-4C5B-91EA-00E5D0629C6C}']
    property adCount: Integer readonly dispid 1;
    property adItems[Index: Integer]: ICOMPaperlessEmailAddress readonly dispid 2;
    procedure AddAddress(const Name: WideString; const Address: WideString); dispid 3;
    procedure Clear; dispid 4;
    procedure Delete(Index: Integer); dispid 5;
  end;

// *********************************************************************//
// Interface: ICOMPaperlessEmailAddress
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {42347784-F201-45EA-8C7D-FCFF8EFCD1A5}
// *********************************************************************//
  ICOMPaperlessEmailAddress = interface(IDispatch)
    ['{42347784-F201-45EA-8C7D-FCFF8EFCD1A5}']
    function Get_eaName: WideString; safecall;
    procedure Set_eaName(const Value: WideString); safecall;
    function Get_eaAddress: WideString; safecall;
    procedure Set_eaAddress(const Value: WideString); safecall;
    property eaName: WideString read Get_eaName write Set_eaName;
    property eaAddress: WideString read Get_eaAddress write Set_eaAddress;
  end;

// *********************************************************************//
// DispIntf:  ICOMPaperlessEmailAddressDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {42347784-F201-45EA-8C7D-FCFF8EFCD1A5}
// *********************************************************************//
  ICOMPaperlessEmailAddressDisp = dispinterface
    ['{42347784-F201-45EA-8C7D-FCFF8EFCD1A5}']
    property eaName: WideString dispid 1;
    property eaAddress: WideString dispid 2;
  end;

// *********************************************************************//
// Interface: ICOMPaperlessEmailAttachments
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7478AD7D-C711-444D-8FF8-0DCE3A99B798}
// *********************************************************************//
  ICOMPaperlessEmailAttachments = interface(IDispatch)
    ['{7478AD7D-C711-444D-8FF8-0DCE3A99B798}']
    function Get_atItems(Index: Integer): WideString; safecall;
    procedure Set_atItems(Index: Integer; const Value: WideString); safecall;
    function Get_atCount: Integer; safecall;
    procedure Add(const Filename: WideString); safecall;
    procedure Clear; safecall;
    procedure Delete(Index: Integer); safecall;
    property atItems[Index: Integer]: WideString read Get_atItems write Set_atItems;
    property atCount: Integer read Get_atCount;
  end;

// *********************************************************************//
// DispIntf:  ICOMPaperlessEmailAttachmentsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7478AD7D-C711-444D-8FF8-0DCE3A99B798}
// *********************************************************************//
  ICOMPaperlessEmailAttachmentsDisp = dispinterface
    ['{7478AD7D-C711-444D-8FF8-0DCE3A99B798}']
    property atItems[Index: Integer]: WideString dispid 1;
    property atCount: Integer readonly dispid 2;
    procedure Add(const Filename: WideString); dispid 3;
    procedure Clear; dispid 4;
    procedure Delete(Index: Integer); dispid 5;
  end;

// *********************************************************************//
// The Class CoCOMCustomisation provides a Create and CreateRemote method to          
// create instances of the default interface ICOMCustomisation exposed by              
// the CoClass COMCustomisation. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCOMCustomisation = class
    class function Create: ICOMCustomisation;
    class function CreateRemote(const MachineName: string): ICOMCustomisation;
  end;

  TCOMCustomisationOnHook = procedure(ASender: TObject; const EventData: ICOMEventData) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TCOMCustomisation
// Help String      : COMCustomisation Object
// Default Interface: ICOMCustomisation
// Def. Intf. DISP? : No
// Event   Interface: ICOMCustomisationEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TCOMCustomisationProperties= class;
{$ENDIF}
  TCOMCustomisation = class(TOleServer)
  private
    FOnHook: TCOMCustomisationOnHook;
    FOnClose: TNotifyEvent;
    FIntf:        ICOMCustomisation;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TCOMCustomisationProperties;
    function      GetServerProperties: TCOMCustomisationProperties;
{$ENDIF}
    function      GetDefaultInterface: ICOMCustomisation;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_ClassVersion: WideString;
    function Get_SystemSetup: ICOMSetup;
    function Get_UserName: WideString;
    function Get_VersionInfo: ICOMVersion;
    function Get_SysFunc: ICOMSysFunc;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ICOMCustomisation);
    procedure Disconnect; override;
    procedure AddAboutString(const AboutText: WideString);
    procedure EnableHook(WindowId: Integer; HandlerId: Integer);
    function entRound(Num: Double; Decs: Integer): Double;
    function entCalc_PcntPcnt(PAmount: Double; Pc1: Double; Pc2: Double; const PCh1: WideString; 
                              const PCh2: WideString): Double;
    function entGetTaxNo(const VCode: WideString): TVATIndex;
    property DefaultInterface: ICOMCustomisation read GetDefaultInterface;
    property ClassVersion: WideString read Get_ClassVersion;
    property SystemSetup: ICOMSetup read Get_SystemSetup;
    property UserName: WideString read Get_UserName;
    property VersionInfo: ICOMVersion read Get_VersionInfo;
    property SysFunc: ICOMSysFunc read Get_SysFunc;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TCOMCustomisationProperties read GetServerProperties;
{$ENDIF}
    property OnHook: TCOMCustomisationOnHook read FOnHook write FOnHook;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TCOMCustomisation
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TCOMCustomisationProperties = class(TPersistent)
  private
    FServer:    TCOMCustomisation;
    function    GetDefaultInterface: ICOMCustomisation;
    constructor Create(AServer: TCOMCustomisation);
  protected
    function Get_ClassVersion: WideString;
    function Get_SystemSetup: ICOMSetup;
    function Get_UserName: WideString;
    function Get_VersionInfo: ICOMVersion;
    function Get_SysFunc: ICOMSysFunc;
  public
    property DefaultInterface: ICOMCustomisation read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoCOMCustomisation.Create: ICOMCustomisation;
begin
  Result := CreateComObject(CLASS_COMCustomisation) as ICOMCustomisation;
end;

class function CoCOMCustomisation.CreateRemote(const MachineName: string): ICOMCustomisation;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_COMCustomisation) as ICOMCustomisation;
end;

procedure TCOMCustomisation.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{95BEDB65-A8B0-11D3-A990-0080C87D89BD}';
    IntfIID:   '{95BEDB61-A8B0-11D3-A990-0080C87D89BD}';
    EventIID:  '{95BEDB63-A8B0-11D3-A990-0080C87D89BD}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCOMCustomisation.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as ICOMCustomisation;
  end;
end;

procedure TCOMCustomisation.ConnectTo(svrIntf: ICOMCustomisation);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TCOMCustomisation.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TCOMCustomisation.GetDefaultInterface: ICOMCustomisation;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TCOMCustomisation.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TCOMCustomisationProperties.Create(Self);
{$ENDIF}
end;

destructor TCOMCustomisation.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TCOMCustomisation.GetServerProperties: TCOMCustomisationProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TCOMCustomisation.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    1: if Assigned(FOnHook) then
         FOnHook(Self, IUnknown(TVarData(Params[0]).VPointer) as ICOMEventData {const ICOMEventData});
    2: if Assigned(FOnClose) then
         FOnClose(Self);
  end; {case DispID}
end;

function TCOMCustomisation.Get_ClassVersion: WideString;
begin
    Result := DefaultInterface.ClassVersion;
end;

function TCOMCustomisation.Get_SystemSetup: ICOMSetup;
begin
    Result := DefaultInterface.SystemSetup;
end;

function TCOMCustomisation.Get_UserName: WideString;
begin
    Result := DefaultInterface.UserName;
end;

function TCOMCustomisation.Get_VersionInfo: ICOMVersion;
begin
    Result := DefaultInterface.VersionInfo;
end;

function TCOMCustomisation.Get_SysFunc: ICOMSysFunc;
begin
    Result := DefaultInterface.SysFunc;
end;

procedure TCOMCustomisation.AddAboutString(const AboutText: WideString);
begin
  DefaultInterface.AddAboutString(AboutText);
end;

procedure TCOMCustomisation.EnableHook(WindowId: Integer; HandlerId: Integer);
begin
  DefaultInterface.EnableHook(WindowId, HandlerId);
end;

function TCOMCustomisation.entRound(Num: Double; Decs: Integer): Double;
begin
  Result := DefaultInterface.entRound(Num, Decs);
end;

function TCOMCustomisation.entCalc_PcntPcnt(PAmount: Double; Pc1: Double; Pc2: Double; 
                                            const PCh1: WideString; const PCh2: WideString): Double;
begin
  Result := DefaultInterface.entCalc_PcntPcnt(PAmount, Pc1, Pc2, PCh1, PCh2);
end;

function TCOMCustomisation.entGetTaxNo(const VCode: WideString): TVATIndex;
begin
  Result := DefaultInterface.entGetTaxNo(VCode);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TCOMCustomisationProperties.Create(AServer: TCOMCustomisation);
begin
  inherited Create;
  FServer := AServer;
end;

function TCOMCustomisationProperties.GetDefaultInterface: ICOMCustomisation;
begin
  Result := FServer.DefaultInterface;
end;

function TCOMCustomisationProperties.Get_ClassVersion: WideString;
begin
    Result := DefaultInterface.ClassVersion;
end;

function TCOMCustomisationProperties.Get_SystemSetup: ICOMSetup;
begin
    Result := DefaultInterface.SystemSetup;
end;

function TCOMCustomisationProperties.Get_UserName: WideString;
begin
    Result := DefaultInterface.UserName;
end;

function TCOMCustomisationProperties.Get_VersionInfo: ICOMVersion;
begin
    Result := DefaultInterface.VersionInfo;
end;

function TCOMCustomisationProperties.Get_SysFunc: ICOMSysFunc;
begin
    Result := DefaultInterface.SysFunc;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TCOMCustomisation]);
end;

end.
