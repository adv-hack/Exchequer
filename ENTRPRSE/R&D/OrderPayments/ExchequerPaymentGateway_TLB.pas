unit ExchequerPaymentGateway_TLB;

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
// File generated on 28/07/2015 12:21:53 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Develop\TFS\Exchequer v7.0\SourceCode-2015R1EA\PlugIns\CreditCardAddin\creditcardplug-in\bin\x86\Release\ExchequerPaymentGateway.tlb (1)
// LIBID: {9CFBE06E-2CCA-4698-8A50-8FC400E1F2A2}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
//   (2) v2.4 mscorlib, (C:\Windows\Microsoft.NET\Framework\v4.0.30319\mscorlib.tlb)
//   (3) v2.4 System, (C:\Windows\Microsoft.NET\Framework\v4.0.30319\System.tlb)
//   (4) v2.4 System_Windows_Forms, (C:\Windows\Microsoft.NET\Framework\v4.0.30319\System.Windows.Forms.tlb)
//   (5) v4.0 StdVCL, (C:\Windows\SysWOW64\stdvcl40.dll)
// Errors:
//   Error creating palette bitmap of (TMCMCompany) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TSourceConfig) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TCurrencyCodes) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TCompanyConfig) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TDebugView) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TRecoveryCustomDataLine) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TRecoveryCustomDataTransaction) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TEncryption2) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TRestoreLog) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TFileAssociation) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TPaymentGateway) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TExchequerTransaction) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TPaymentDefaultInformation) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TPaymentGatewayResponse) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TToolkitWrapper) : Server mscoree.dll contains no icons
//   Error creating palette bitmap of (TTransactionLine) : Server mscoree.dll contains no icons
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

interface

uses Windows, ActiveX, Classes, Graphics, mscorlib_TLB, OleServer, StdVCL, System_TLB, 
System_Windows_Forms_TLB, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ExchequerPaymentGatewayMajorVersion = 1;
  ExchequerPaymentGatewayMinorVersion = 0;

  LIBID_ExchequerPaymentGateway: TGUID = '{9CFBE06E-2CCA-4698-8A50-8FC400E1F2A2}';

  IID__MCMCompany: TGUID = '{AE3366B5-8926-3251-9CEF-C5E862873423}';
  IID__GLCodeListItem: TGUID = '{19B3086D-0C60-3315-A1BD-3BBACE24FA39}';
  IID__CostCentreDeptListItem: TGUID = '{2BDDF792-F0AF-313C-A927-F5C3292F7F25}';
  IID__SourceConfig: TGUID = '{06A02446-A713-38A8-ACD1-35FEBCD49AC3}';
  IID__CurrencyCodes: TGUID = '{2B7D8A65-6DD6-328A-8E1E-1F7E802DA7A2}';
  IID__CompanyConfig: TGUID = '{AAEFC21B-C566-325D-AFF3-91B09E560AEA}';
  IID__SiteConfig: TGUID = '{6AA803EB-8C23-3024-A3FA-8F3A59BA7300}';
  IID__DebugView: TGUID = '{CFAB91A6-FC2B-32FE-828F-CF6C87523C24}';
  IID__TextLock: TGUID = '{44E0BAF1-D398-380A-B77A-2B02E18E623A}';
  IID__DataRestorer: TGUID = '{B5EC8F89-3D63-34F7-9BD9-5B7D1634A086}';
  IID__RecoveryCustomDataLine: TGUID = '{C6D9F60C-CCE1-3A4F-9509-E6FD128062CE}';
  IID__RecoveryCustomDataTransaction: TGUID = '{DCE4FED1-952C-3B18-9D21-9D16AACD0024}';
  IID__Encryption2: TGUID = '{D8875B72-2694-356D-A850-AFA7401F6105}';
  IID__RestoreLog: TGUID = '{F5ECF719-010D-3A72-A4D3-40F973932240}';
  IID__FileAssociation: TGUID = '{B7C2C30C-7E94-3EA8-9A83-EF9CB2EB800F}';
  IID__ConfigurationForm: TGUID = '{5AC9A83F-18D7-30EC-98EF-EE10835DDE2B}';
  IID__MCMComboBoxItem: TGUID = '{E648938C-BA2E-32AF-8887-CA1FFB9530D6}';
  IID__GlobalData: TGUID = '{B3F7DFD4-9902-3C2D-BDAD-1FF10C8FE66C}';
  IID_IPaymentGatewayPlugin: TGUID = '{A4F422CF-2B78-4946-A10A-8BDC0094AF5B}';
  CLASS_PaymentGateway: TGUID = '{FBA4004E-D3D9-4AD2-803A-BB5E8BBA4237}';
  IID_IExchequerTransaction: TGUID = '{A99DE27C-C762-4947-BFB3-7C1F41FDAAD4}';
  CLASS_ExchequerTransaction: TGUID = '{F87B9216-FCCD-4FC8-B0AB-77FA787D00AD}';
  DIID_IPaymentDefaultInformation: TGUID = '{522B9B05-D665-4340-8818-70547275898A}';
  CLASS_PaymentDefaultInformation: TGUID = '{8EA84189-D7BA-4D3A-91C1-FC8147385FCD}';
  IID_IPaymentGatewayResponse: TGUID = '{C523B87C-F41E-4DD1-A2D0-B482C1424995}';
  CLASS_PaymentGatewayResponse: TGUID = '{1304F2F5-1C2F-4916-BB90-232F9C43845E}';
  IID__ctkDebugLog: TGUID = '{AE09BD79-85D6-3EAA-8300-5C1F714CC1E7}';
  IID__ToolkitWrapper: TGUID = '{36CB0AB5-C5D5-351B-8803-36013CA487D5}';
  IID_ExchequerPaymentGateway_ITransactionLine: TGUID = '{6EA13381-AAAB-47AD-AE3B-971059680A2A}';
  CLASS_TransactionLine: TGUID = '{47894B99-50BA-4DB3-8F28-772A7AAC970B}';
  IID__XMLFuncs: TGUID = '{41EBEA59-A659-366E-9E24-966A02470042}';
  CLASS_MCMCompany: TGUID = '{2568CC23-BFE8-3731-8B3F-8AB2D50812B4}';
  CLASS_GLCodeListItem: TGUID = '{1A20E6B9-63F8-3595-B465-408CE8D28544}';
  CLASS_CostCentreDeptListItem: TGUID = '{DA149BEA-9B1F-36DE-9668-1C16FD37A96A}';
  CLASS_SourceConfig: TGUID = '{5007476E-EC52-3172-8ADC-2AF794F23DFB}';
  CLASS_CurrencyCodes: TGUID = '{481E9F13-4B54-3BE9-901F-AB6981015260}';
  CLASS_CompanyConfig: TGUID = '{4CD45A53-21C9-3776-B1F8-389062213A29}';
  CLASS_SiteConfig: TGUID = '{91FB6EDC-B269-3C32-8655-FF3A010CD22E}';
  CLASS_DebugView: TGUID = '{0F0832E7-9C45-374B-9F9B-342D3066D6F4}';
  CLASS_TextLock: TGUID = '{C1365030-4F0B-33DD-8935-E7D729A90646}';
  CLASS_DataRestorer: TGUID = '{556DDBFF-C2A6-3202-852B-213104D41463}';
  CLASS_RecoveryCustomDataLine: TGUID = '{AF176E1A-D844-3B73-9CB3-CB3FD36BFD25}';
  CLASS_RecoveryCustomDataTransaction: TGUID = '{F5BDC02F-40FF-3CE3-A272-DAAD0803A345}';
  CLASS_Encryption2: TGUID = '{4AB18CB1-46AA-3F60-9745-B8E46EB6069B}';
  CLASS_RestoreLog: TGUID = '{CBAB6D96-E45D-3941-9FCD-F6D1289C5CCA}';
  CLASS_FileAssociation: TGUID = '{FE17326E-A2AE-3D36-B139-81F9C62873DA}';
  CLASS_ConfigurationForm: TGUID = '{C35AAED3-AFCE-3009-8439-EAFAC307E5A0}';
  CLASS_MCMComboBoxItem: TGUID = '{913C08D8-1C8A-310D-A0C2-26E72A759132}';
  CLASS_GlobalData: TGUID = '{683F6B8D-44F6-3E74-8713-77DCADC97CAA}';
  CLASS_ctkDebugLog: TGUID = '{2DECEF7D-E27E-3A3E-815D-5F710B8EE666}';
  CLASS_ToolkitWrapper: TGUID = '{5749018E-9CA2-39D0-A082-CBD57AB0FDD2}';
  CLASS_XMLFuncs: TGUID = '{32652A9D-EB8B-3ACB-9522-1041B500BE1E}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum ALG_ID
type
  ALG_ID = TOleEnum;
const
  ALG_ID_CALG_MD5 = $00008003;
  ALG_ID_CALG_RC4 = $00006801;

// Constants for enum severities
type
  severities = TOleEnum;
const
  severities_sevInfo = $00000000;
  severities_sevWarning = $00000001;
  severities_sevError = $00000002;
  severities_sevDebug = $00000003;

// Constants for enum configStatus
type
  configStatus = TOleEnum;
const
  configStatus_csSuccess = $00000000;
  configStatus_csFailedToRead = $00000001;
  configStatus_csFailedToSave = $00000002;
  configStatus_csConfigEmpty = $00000003;

// Constants for enum historyActions
type
  historyActions = TOleEnum;
const
  historyActions_haSaveToCSV = $00000000;
  historyActions_haRestore = $00000001;

// Constants for enum sourceColumns
type
  sourceColumns = TOleEnum;
const
  sourceColumns_scPaymentProvider = $00000000;
  sourceColumns_scMerchantId = $00000001;
  sourceColumns_scSource = $00000002;
  sourceColumns_scGLCode = $00000003;
  sourceColumns_scCostCentre = $00000004;
  sourceColumns_scDepartment = $00000005;

// Constants for enum PaymentAction
type
  PaymentAction = TOleEnum;
const
  PaymentAction_Payment = $00000000;
  PaymentAction_CardAuthentication = $00000001;
  PaymentAction_PaymentAuthorisation = $00000002;
  PaymentAction_Refund = $00000003;

// Constants for enum TToolkitStatus
type
  TToolkitStatus = TOleEnum;
const
  TToolkitStatus_tkClosed = $00000000;
  TToolkitStatus_tkOpen = $00000001;

// Constants for enum TGeneralLedgerIndex
type
  TGeneralLedgerIndex = TOleEnum;
const
  TGeneralLedgerIndex_glIdxCode = $00000000;
  TGeneralLedgerIndex_glIdxName = $00000001;
  TGeneralLedgerIndex_glIdxParent = $00000002;
  TGeneralLedgerIndex_glIdxAltCode = $00000003;
  TGeneralLedgerIndex_glIdxCodeString = $00000004;

// Constants for enum TGeneralLedgerType
type
  TGeneralLedgerType = TOleEnum;
const
  TGeneralLedgerType_glTypeProfitLoss = $00000000;
  TGeneralLedgerType_glTypeBalanceSheet = $00000001;
  TGeneralLedgerType_glTypeControl = $00000002;
  TGeneralLedgerType_glTypeCarryFwd = $00000003;
  TGeneralLedgerType_glTypeHeading = $00000004;

// Constants for enum TGeneralLedgerClass
type
  TGeneralLedgerClass = TOleEnum;
const
  TGeneralLedgerClass_glcNone = $00000000;
  TGeneralLedgerClass_glcBankAccount = $00000001;
  TGeneralLedgerClass_glcClosingStock = $00000002;
  TGeneralLedgerClass_glcFinishedGoods = $00000003;
  TGeneralLedgerClass_glcStockValue = $00000004;
  TGeneralLedgerClass_glcWOPWIP = $00000005;
  TGeneralLedgerClass_glcOverheads = $00000006;
  TGeneralLedgerClass_glMisc = $00000007;
  TGeneralLedgerClass_glcSalesReturns = $00000008;
  TGeneralLedgerClass_glcPurchaseReturns = $00000009;

// Constants for enum TCCDeptIndex
type
  TCCDeptIndex = TOleEnum;
const
  TCCDeptIndex_cdIdxCode = $00000000;
  TCCDeptIndex_cdIdxName = $00000001;

// Constants for enum TTransactionIndex
type
  TTransactionIndex = TOleEnum;
const
  TTransactionIndex_thIdxOurRef = $00000000;
  TTransactionIndex_thIdxFolio = $00000001;
  TTransactionIndex_thIdxAccount = $00000002;
  TTransactionIndex_thIdxYourRef = $00000003;
  TTransactionIndex_thIdxLongYourRef = $00000004;
  TTransactionIndex_thIdxRunNo = $00000005;
  TTransactionIndex_thIdxAccountDue = $00000006;
  TTransactionIndex_thIdxPostedDate = $00000007;
  TTransactionIndex_thIdxBatchLink = $00000008;
  TTransactionIndex_thIdxTransDate = $00000009;
  TTransactionIndex_thIdxYearPeriod = $0000000A;
  TTransactionIndex_thIdxOutstanding = $0000000B;

// Constants for enum TDocTypes
type
  TDocTypes = TOleEnum;
const
  TDocTypes_dtSIN = $00000000;
  TDocTypes_dtSRC = $00000001;
  TDocTypes_dtSCR = $00000002;
  TDocTypes_dtSJI = $00000003;
  TDocTypes_dtSJC = $00000004;
  TDocTypes_dtSRF = $00000005;
  TDocTypes_dtSRI = $00000006;
  TDocTypes_dtSQU = $00000007;
  TDocTypes_dtSOR = $00000008;
  TDocTypes_dtSDN = $00000009;
  TDocTypes_dtSBT = $0000000A;
  TDocTypes_dtPIN = $0000000B;
  TDocTypes_dtPPY = $0000000C;
  TDocTypes_dtPCR = $0000000D;
  TDocTypes_dtPJI = $0000000E;
  TDocTypes_dtPJC = $0000000F;
  TDocTypes_dtPRF = $00000010;
  TDocTypes_dtPPI = $00000011;
  TDocTypes_dtPQU = $00000012;
  TDocTypes_dtPOR = $00000013;
  TDocTypes_dtPDN = $00000014;
  TDocTypes_dtPBT = $00000015;
  TDocTypes_dtNMT = $00000016;
  TDocTypes_dtADJ = $00000017;
  TDocTypes_dtTSH = $00000018;
  TDocTypes_dtWOR = $00000019;
  TDocTypes_dtJCT = $0000001A;
  TDocTypes_dtJST = $0000001B;
  TDocTypes_dtJPT = $0000001C;
  TDocTypes_dtJSA = $0000001D;
  TDocTypes_dtJPA = $0000001E;
  TDocTypes_dtSRN = $0000001F;
  TDocTypes_dtPRN = $00000020;

// Constants for enum TCreditCardAction
type
  TCreditCardAction = TOleEnum;
const
  TCreditCardAction_ccaNone = $00000000;
  TCreditCardAction_ccaAuthorisationOnly = $00000001;
  TCreditCardAction_ccaPayment = $00000002;
  TCreditCardAction_ccaPaymentUsingAuthorisation = $00000003;
  TCreditCardAction_ccaRefund = $00000004;

// Constants for enum TAccountIndex
type
  TAccountIndex = TOleEnum;
const
  TAccountIndex_acIdxCode = $00000000;
  TAccountIndex_acIdxName = $00000001;
  TAccountIndex_acIdxAltCode = $00000002;
  TAccountIndex_acIdxVATRegNo = $00000003;
  TAccountIndex_acIdxEmail = $00000004;
  TAccountIndex_acIdxPhone = $00000005;
  TAccountIndex_acIdxPostCode = $00000006;
  TAccountIndex_acIdxOurCode = $00000007;
  TAccountIndex_acIdxInvTo = $00000008;
  TAccountIndex_acIdxSubTypeAndCode = $00000009;
  TAccountIndex_acIdxSubTypeAndLongCode = $0000000A;
  TAccountIndex_acIdxSubTypeAndName = $0000000B;
  TAccountIndex_acIdxSubTypeAndAltCode = $0000000C;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _MCMCompany = interface;
  _MCMCompanyDisp = dispinterface;
  _GLCodeListItem = interface;
  _GLCodeListItemDisp = dispinterface;
  _CostCentreDeptListItem = interface;
  _CostCentreDeptListItemDisp = dispinterface;
  _SourceConfig = interface;
  _SourceConfigDisp = dispinterface;
  _CurrencyCodes = interface;
  _CurrencyCodesDisp = dispinterface;
  _CompanyConfig = interface;
  _CompanyConfigDisp = dispinterface;
  _SiteConfig = interface;
  _SiteConfigDisp = dispinterface;
  _DebugView = interface;
  _DebugViewDisp = dispinterface;
  _TextLock = interface;
  _TextLockDisp = dispinterface;
  _DataRestorer = interface;
  _DataRestorerDisp = dispinterface;
  _RecoveryCustomDataLine = interface;
  _RecoveryCustomDataLineDisp = dispinterface;
  _RecoveryCustomDataTransaction = interface;
  _RecoveryCustomDataTransactionDisp = dispinterface;
  _Encryption2 = interface;
  _Encryption2Disp = dispinterface;
  _RestoreLog = interface;
  _RestoreLogDisp = dispinterface;
  _FileAssociation = interface;
  _FileAssociationDisp = dispinterface;
  _ConfigurationForm = interface;
  _ConfigurationFormDisp = dispinterface;
  _MCMComboBoxItem = interface;
  _MCMComboBoxItemDisp = dispinterface;
  _GlobalData = interface;
  _GlobalDataDisp = dispinterface;
  IPaymentGatewayPlugin = interface;
  IPaymentGatewayPluginDisp = dispinterface;
  IExchequerTransaction = interface;
  IExchequerTransactionDisp = dispinterface;
  IPaymentDefaultInformation = dispinterface;
  IPaymentGatewayResponse = interface;
  IPaymentGatewayResponseDisp = dispinterface;
  _ctkDebugLog = interface;
  _ctkDebugLogDisp = dispinterface;
  _ToolkitWrapper = interface;
  _ToolkitWrapperDisp = dispinterface;
  ExchequerPaymentGateway_ITransactionLine = interface;
  ExchequerPaymentGateway_ITransactionLineDisp = dispinterface;
  _XMLFuncs = interface;
  _XMLFuncsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  PaymentGateway = IPaymentGatewayPlugin;
  ExchequerTransaction = IExchequerTransaction;
  PaymentDefaultInformation = IPaymentDefaultInformation;
  PaymentGatewayResponse = IPaymentGatewayResponse;
  TransactionLine = ExchequerPaymentGateway_ITransactionLine;
  MCMCompany = _MCMCompany;
  GLCodeListItem = _GLCodeListItem;
  CostCentreDeptListItem = _CostCentreDeptListItem;
  SourceConfig = _SourceConfig;
  CurrencyCodes = _CurrencyCodes;
  CompanyConfig = _CompanyConfig;
  SiteConfig = _SiteConfig;
  DebugView = _DebugView;
  TextLock = _TextLock;
  DataRestorer = _DataRestorer;
  RecoveryCustomDataLine = _RecoveryCustomDataLine;
  RecoveryCustomDataTransaction = _RecoveryCustomDataTransaction;
  Encryption2 = _Encryption2;
  RestoreLog = _RestoreLog;
  FileAssociation = _FileAssociation;
  ConfigurationForm = _ConfigurationForm;
  MCMComboBoxItem = _MCMComboBoxItem;
  GlobalData = _GlobalData;
  ctkDebugLog = _ctkDebugLog;
  ToolkitWrapper = _ToolkitWrapper;
  XMLFuncs = _XMLFuncs;


// *********************************************************************//
// Interface: _MCMCompany
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {AE3366B5-8926-3251-9CEF-C5E862873423}
// *********************************************************************//
  _MCMCompany = interface(IDispatch)
    ['{AE3366B5-8926-3251-9CEF-C5E862873423}']
  end;

// *********************************************************************//
// DispIntf:  _MCMCompanyDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {AE3366B5-8926-3251-9CEF-C5E862873423}
// *********************************************************************//
  _MCMCompanyDisp = dispinterface
    ['{AE3366B5-8926-3251-9CEF-C5E862873423}']
  end;

// *********************************************************************//
// Interface: _GLCodeListItem
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {19B3086D-0C60-3315-A1BD-3BBACE24FA39}
// *********************************************************************//
  _GLCodeListItem = interface(IDispatch)
    ['{19B3086D-0C60-3315-A1BD-3BBACE24FA39}']
  end;

// *********************************************************************//
// DispIntf:  _GLCodeListItemDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {19B3086D-0C60-3315-A1BD-3BBACE24FA39}
// *********************************************************************//
  _GLCodeListItemDisp = dispinterface
    ['{19B3086D-0C60-3315-A1BD-3BBACE24FA39}']
  end;

// *********************************************************************//
// Interface: _CostCentreDeptListItem
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {2BDDF792-F0AF-313C-A927-F5C3292F7F25}
// *********************************************************************//
  _CostCentreDeptListItem = interface(IDispatch)
    ['{2BDDF792-F0AF-313C-A927-F5C3292F7F25}']
  end;

// *********************************************************************//
// DispIntf:  _CostCentreDeptListItemDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {2BDDF792-F0AF-313C-A927-F5C3292F7F25}
// *********************************************************************//
  _CostCentreDeptListItemDisp = dispinterface
    ['{2BDDF792-F0AF-313C-A927-F5C3292F7F25}']
  end;

// *********************************************************************//
// Interface: _SourceConfig
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {06A02446-A713-38A8-ACD1-35FEBCD49AC3}
// *********************************************************************//
  _SourceConfig = interface(IDispatch)
    ['{06A02446-A713-38A8-ACD1-35FEBCD49AC3}']
  end;

// *********************************************************************//
// DispIntf:  _SourceConfigDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {06A02446-A713-38A8-ACD1-35FEBCD49AC3}
// *********************************************************************//
  _SourceConfigDisp = dispinterface
    ['{06A02446-A713-38A8-ACD1-35FEBCD49AC3}']
  end;

// *********************************************************************//
// Interface: _CurrencyCodes
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {2B7D8A65-6DD6-328A-8E1E-1F7E802DA7A2}
// *********************************************************************//
  _CurrencyCodes = interface(IDispatch)
    ['{2B7D8A65-6DD6-328A-8E1E-1F7E802DA7A2}']
  end;

// *********************************************************************//
// DispIntf:  _CurrencyCodesDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {2B7D8A65-6DD6-328A-8E1E-1F7E802DA7A2}
// *********************************************************************//
  _CurrencyCodesDisp = dispinterface
    ['{2B7D8A65-6DD6-328A-8E1E-1F7E802DA7A2}']
  end;

// *********************************************************************//
// Interface: _CompanyConfig
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {AAEFC21B-C566-325D-AFF3-91B09E560AEA}
// *********************************************************************//
  _CompanyConfig = interface(IDispatch)
    ['{AAEFC21B-C566-325D-AFF3-91B09E560AEA}']
  end;

// *********************************************************************//
// DispIntf:  _CompanyConfigDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {AAEFC21B-C566-325D-AFF3-91B09E560AEA}
// *********************************************************************//
  _CompanyConfigDisp = dispinterface
    ['{AAEFC21B-C566-325D-AFF3-91B09E560AEA}']
  end;

// *********************************************************************//
// Interface: _SiteConfig
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6AA803EB-8C23-3024-A3FA-8F3A59BA7300}
// *********************************************************************//
  _SiteConfig = interface(IDispatch)
    ['{6AA803EB-8C23-3024-A3FA-8F3A59BA7300}']
  end;

// *********************************************************************//
// DispIntf:  _SiteConfigDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {6AA803EB-8C23-3024-A3FA-8F3A59BA7300}
// *********************************************************************//
  _SiteConfigDisp = dispinterface
    ['{6AA803EB-8C23-3024-A3FA-8F3A59BA7300}']
  end;

// *********************************************************************//
// Interface: _DebugView
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {CFAB91A6-FC2B-32FE-828F-CF6C87523C24}
// *********************************************************************//
  _DebugView = interface(IDispatch)
    ['{CFAB91A6-FC2B-32FE-828F-CF6C87523C24}']
  end;

// *********************************************************************//
// DispIntf:  _DebugViewDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {CFAB91A6-FC2B-32FE-828F-CF6C87523C24}
// *********************************************************************//
  _DebugViewDisp = dispinterface
    ['{CFAB91A6-FC2B-32FE-828F-CF6C87523C24}']
  end;

// *********************************************************************//
// Interface: _TextLock
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {44E0BAF1-D398-380A-B77A-2B02E18E623A}
// *********************************************************************//
  _TextLock = interface(IDispatch)
    ['{44E0BAF1-D398-380A-B77A-2B02E18E623A}']
  end;

// *********************************************************************//
// DispIntf:  _TextLockDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {44E0BAF1-D398-380A-B77A-2B02E18E623A}
// *********************************************************************//
  _TextLockDisp = dispinterface
    ['{44E0BAF1-D398-380A-B77A-2B02E18E623A}']
  end;

// *********************************************************************//
// Interface: _DataRestorer
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {B5EC8F89-3D63-34F7-9BD9-5B7D1634A086}
// *********************************************************************//
  _DataRestorer = interface(IDispatch)
    ['{B5EC8F89-3D63-34F7-9BD9-5B7D1634A086}']
  end;

// *********************************************************************//
// DispIntf:  _DataRestorerDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {B5EC8F89-3D63-34F7-9BD9-5B7D1634A086}
// *********************************************************************//
  _DataRestorerDisp = dispinterface
    ['{B5EC8F89-3D63-34F7-9BD9-5B7D1634A086}']
  end;

// *********************************************************************//
// Interface: _RecoveryCustomDataLine
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {C6D9F60C-CCE1-3A4F-9509-E6FD128062CE}
// *********************************************************************//
  _RecoveryCustomDataLine = interface(IDispatch)
    ['{C6D9F60C-CCE1-3A4F-9509-E6FD128062CE}']
  end;

// *********************************************************************//
// DispIntf:  _RecoveryCustomDataLineDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {C6D9F60C-CCE1-3A4F-9509-E6FD128062CE}
// *********************************************************************//
  _RecoveryCustomDataLineDisp = dispinterface
    ['{C6D9F60C-CCE1-3A4F-9509-E6FD128062CE}']
  end;

// *********************************************************************//
// Interface: _RecoveryCustomDataTransaction
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {DCE4FED1-952C-3B18-9D21-9D16AACD0024}
// *********************************************************************//
  _RecoveryCustomDataTransaction = interface(IDispatch)
    ['{DCE4FED1-952C-3B18-9D21-9D16AACD0024}']
  end;

// *********************************************************************//
// DispIntf:  _RecoveryCustomDataTransactionDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {DCE4FED1-952C-3B18-9D21-9D16AACD0024}
// *********************************************************************//
  _RecoveryCustomDataTransactionDisp = dispinterface
    ['{DCE4FED1-952C-3B18-9D21-9D16AACD0024}']
  end;

// *********************************************************************//
// Interface: _Encryption2
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {D8875B72-2694-356D-A850-AFA7401F6105}
// *********************************************************************//
  _Encryption2 = interface(IDispatch)
    ['{D8875B72-2694-356D-A850-AFA7401F6105}']
  end;

// *********************************************************************//
// DispIntf:  _Encryption2Disp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {D8875B72-2694-356D-A850-AFA7401F6105}
// *********************************************************************//
  _Encryption2Disp = dispinterface
    ['{D8875B72-2694-356D-A850-AFA7401F6105}']
  end;

// *********************************************************************//
// Interface: _RestoreLog
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {F5ECF719-010D-3A72-A4D3-40F973932240}
// *********************************************************************//
  _RestoreLog = interface(IDispatch)
    ['{F5ECF719-010D-3A72-A4D3-40F973932240}']
  end;

// *********************************************************************//
// DispIntf:  _RestoreLogDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {F5ECF719-010D-3A72-A4D3-40F973932240}
// *********************************************************************//
  _RestoreLogDisp = dispinterface
    ['{F5ECF719-010D-3A72-A4D3-40F973932240}']
  end;

// *********************************************************************//
// Interface: _FileAssociation
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {B7C2C30C-7E94-3EA8-9A83-EF9CB2EB800F}
// *********************************************************************//
  _FileAssociation = interface(IDispatch)
    ['{B7C2C30C-7E94-3EA8-9A83-EF9CB2EB800F}']
  end;

// *********************************************************************//
// DispIntf:  _FileAssociationDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {B7C2C30C-7E94-3EA8-9A83-EF9CB2EB800F}
// *********************************************************************//
  _FileAssociationDisp = dispinterface
    ['{B7C2C30C-7E94-3EA8-9A83-EF9CB2EB800F}']
  end;

// *********************************************************************//
// Interface: _ConfigurationForm
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {5AC9A83F-18D7-30EC-98EF-EE10835DDE2B}
// *********************************************************************//
  _ConfigurationForm = interface(IDispatch)
    ['{5AC9A83F-18D7-30EC-98EF-EE10835DDE2B}']
  end;

// *********************************************************************//
// DispIntf:  _ConfigurationFormDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {5AC9A83F-18D7-30EC-98EF-EE10835DDE2B}
// *********************************************************************//
  _ConfigurationFormDisp = dispinterface
    ['{5AC9A83F-18D7-30EC-98EF-EE10835DDE2B}']
  end;

// *********************************************************************//
// Interface: _MCMComboBoxItem
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {E648938C-BA2E-32AF-8887-CA1FFB9530D6}
// *********************************************************************//
  _MCMComboBoxItem = interface(IDispatch)
    ['{E648938C-BA2E-32AF-8887-CA1FFB9530D6}']
  end;

// *********************************************************************//
// DispIntf:  _MCMComboBoxItemDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {E648938C-BA2E-32AF-8887-CA1FFB9530D6}
// *********************************************************************//
  _MCMComboBoxItemDisp = dispinterface
    ['{E648938C-BA2E-32AF-8887-CA1FFB9530D6}']
  end;

// *********************************************************************//
// Interface: _GlobalData
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {B3F7DFD4-9902-3C2D-BDAD-1FF10C8FE66C}
// *********************************************************************//
  _GlobalData = interface(IDispatch)
    ['{B3F7DFD4-9902-3C2D-BDAD-1FF10C8FE66C}']
  end;

// *********************************************************************//
// DispIntf:  _GlobalDataDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {B3F7DFD4-9902-3C2D-BDAD-1FF10C8FE66C}
// *********************************************************************//
  _GlobalDataDisp = dispinterface
    ['{B3F7DFD4-9902-3C2D-BDAD-1FF10C8FE66C}']
  end;

// *********************************************************************//
// Interface: IPaymentGatewayPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A4F422CF-2B78-4946-A10A-8BDC0094AF5B}
// *********************************************************************//
  IPaymentGatewayPlugin = interface(IDispatch)
    ['{A4F422CF-2B78-4946-A10A-8BDC0094AF5B}']
    function SetCurrentCompanyCode(const aCompanyCode: WideString): WordBool; safecall;
    function GetDefaultGlCode(const SalesOrderReference: WideString; 
                              const TransactionReference: WideString; const UDF5: WideString; 
                              const UDF6: WideString; const UDF7: WideString; 
                              const UDF8: WideString; const UDF9: WideString; 
                              const UDF10: WideString): Smallint; safecall;
    function ProcessPayment(const TransactionDetails: IExchequerTransaction; aProvider: Int64; 
                            aMerchant: Int64): IPaymentGatewayResponse; safecall;
    function ProcessRefund(const TransactionDetails: IExchequerTransaction; 
                           const RefundReason: WideString): IPaymentGatewayResponse; safecall;
    function DisplayConfigurationDialog(hWnd: Integer; const aCompany: WideString; 
                                        const aUserId: WideString; aIsSuperUser: WordBool): DialogResult; safecall;
    function GetPaymentDefaults(out GLCode: Integer; out Provider: Int64; out MerchantID: Int64; 
                                out CostCentre: WideString; out Department: WideString; 
                                const UDF5: WideString; const UDF6: WideString; 
                                const UDF7: WideString; const UDF8: WideString; 
                                const UDF9: WideString; const UDF10: WideString): WordBool; safecall;
    function GetPaymentDefaultsEx(out GLCode: Integer; out Provider: Int64; out MerchantID: Int64; 
                                  out CostCentre: WideString; out Department: WideString; 
                                  out ProviderDescription: WideString; const UDF5: WideString; 
                                  const UDF6: WideString; const UDF7: WideString; 
                                  const UDF8: WideString; const UDF9: WideString; 
                                  const UDF10: WideString): WordBool; safecall;
    function IsCCEnabledForCompany(const aCompanyCode: WideString): WordBool; safecall;
    function SetParentHandle(hWnd: Integer): WordBool; safecall;
    function GetTransactionStatus(const aTransVendorTx: WideString): IPaymentGatewayResponse; safecall;
    function GetProcessedTransactionsByDateRange(startDate: TDateTime; endDate: TDateTime; 
                                                 pageNumber: Integer; out response: IUnknown): WordBool; safecall;
    function UpdateTransactionContent(const gatewayTransactionGuid: WideString; 
                                      const receiptReference: WideString; 
                                      const customData: WideString): Integer; safecall;
    function GetServiceStatus: WordBool; safecall;
    procedure CancelTransaction(const aTransactionGUID: WideString); safecall;
    procedure FreeResources; safecall;
  end;

// *********************************************************************//
// DispIntf:  IPaymentGatewayPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A4F422CF-2B78-4946-A10A-8BDC0094AF5B}
// *********************************************************************//
  IPaymentGatewayPluginDisp = dispinterface
    ['{A4F422CF-2B78-4946-A10A-8BDC0094AF5B}']
    function SetCurrentCompanyCode(const aCompanyCode: WideString): WordBool; dispid 1610743808;
    function GetDefaultGlCode(const SalesOrderReference: WideString; 
                              const TransactionReference: WideString; const UDF5: WideString; 
                              const UDF6: WideString; const UDF7: WideString; 
                              const UDF8: WideString; const UDF9: WideString; 
                              const UDF10: WideString): Smallint; dispid 1610743809;
    function ProcessPayment(const TransactionDetails: IExchequerTransaction; 
                            aProvider: {??Int64}OleVariant; aMerchant: {??Int64}OleVariant): IPaymentGatewayResponse; dispid 1610743810;
    function ProcessRefund(const TransactionDetails: IExchequerTransaction; 
                           const RefundReason: WideString): IPaymentGatewayResponse; dispid 1610743811;
    function DisplayConfigurationDialog(hWnd: Integer; const aCompany: WideString; 
                                        const aUserId: WideString; aIsSuperUser: WordBool): DialogResult; dispid 1610743812;
    function GetPaymentDefaults(out GLCode: Integer; out Provider: {??Int64}OleVariant; 
                                out MerchantID: {??Int64}OleVariant; out CostCentre: WideString; 
                                out Department: WideString; const UDF5: WideString; 
                                const UDF6: WideString; const UDF7: WideString; 
                                const UDF8: WideString; const UDF9: WideString; 
                                const UDF10: WideString): WordBool; dispid 1610743813;
    function GetPaymentDefaultsEx(out GLCode: Integer; out Provider: {??Int64}OleVariant; 
                                  out MerchantID: {??Int64}OleVariant; out CostCentre: WideString; 
                                  out Department: WideString; out ProviderDescription: WideString; 
                                  const UDF5: WideString; const UDF6: WideString; 
                                  const UDF7: WideString; const UDF8: WideString; 
                                  const UDF9: WideString; const UDF10: WideString): WordBool; dispid 1610743814;
    function IsCCEnabledForCompany(const aCompanyCode: WideString): WordBool; dispid 1610743815;
    function SetParentHandle(hWnd: Integer): WordBool; dispid 1610743816;
    function GetTransactionStatus(const aTransVendorTx: WideString): IPaymentGatewayResponse; dispid 1610743817;
    function GetProcessedTransactionsByDateRange(startDate: TDateTime; endDate: TDateTime; 
                                                 pageNumber: Integer; out response: IUnknown): WordBool; dispid 1610743818;
    function UpdateTransactionContent(const gatewayTransactionGuid: WideString; 
                                      const receiptReference: WideString; 
                                      const customData: WideString): Integer; dispid 1610743819;
    function GetServiceStatus: WordBool; dispid 1610743820;
    procedure CancelTransaction(const aTransactionGUID: WideString); dispid 1610743821;
    procedure FreeResources; dispid 1610743822;
  end;

// *********************************************************************//
// Interface: IExchequerTransaction
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A99DE27C-C762-4947-BFB3-7C1F41FDAAD4}
// *********************************************************************//
  IExchequerTransaction = interface(IDispatch)
    ['{A99DE27C-C762-4947-BFB3-7C1F41FDAAD4}']
    function Get_ExchequerCompanyCode: WideString; safecall;
    procedure Set_ExchequerCompanyCode(const pRetVal: WideString); safecall;
    function Get_SalesOrderReference: WideString; safecall;
    procedure Set_SalesOrderReference(const pRetVal: WideString); safecall;
    function Get_DescendentTransactionReference: WideString; safecall;
    procedure Set_DescendentTransactionReference(const pRetVal: WideString); safecall;
    function Get_ContactName: WideString; safecall;
    procedure Set_ContactName(const pRetVal: WideString); safecall;
    function Get_ContactPhone: WideString; safecall;
    procedure Set_ContactPhone(const pRetVal: WideString); safecall;
    function Get_ContactEmail: WideString; safecall;
    procedure Set_ContactEmail(const pRetVal: WideString); safecall;
    function Get_DeliveryAddress1: WideString; safecall;
    procedure Set_DeliveryAddress1(const pRetVal: WideString); safecall;
    function Get_DeliveryAddress2: WideString; safecall;
    procedure Set_DeliveryAddress2(const pRetVal: WideString); safecall;
    function Get_DeliveryAddress3_Town: WideString; safecall;
    procedure Set_DeliveryAddress3_Town(const pRetVal: WideString); safecall;
    function Get_DeliveryAddress4_County: WideString; safecall;
    procedure Set_DeliveryAddress4_County(const pRetVal: WideString); safecall;
    function Get_DeliveryAddress_Country: WideString; safecall;
    procedure Set_DeliveryAddress_Country(const pRetVal: WideString); safecall;
    function Get_DeliveryAddressPostCode: WideString; safecall;
    procedure Set_DeliveryAddressPostCode(const pRetVal: WideString); safecall;
    function Get_BillingAddress1: WideString; safecall;
    procedure Set_BillingAddress1(const pRetVal: WideString); safecall;
    function Get_BillingAddress2: WideString; safecall;
    procedure Set_BillingAddress2(const pRetVal: WideString); safecall;
    function Get_BillingAddress3_Town: WideString; safecall;
    procedure Set_BillingAddress3_Town(const pRetVal: WideString); safecall;
    function Get_BillingAddress4_County: WideString; safecall;
    procedure Set_BillingAddress4_County(const pRetVal: WideString); safecall;
    function Get_BillingAddress_Country: WideString; safecall;
    procedure Set_BillingAddress_Country(const pRetVal: WideString); safecall;
    function Get_BillingAddressPostCode: WideString; safecall;
    procedure Set_BillingAddressPostCode(const pRetVal: WideString); safecall;
    function Get_PaymentType: PaymentAction; safecall;
    procedure Set_PaymentType(pRetVal: PaymentAction); safecall;
    function Get_FullAmount: WordBool; safecall;
    procedure Set_FullAmount(pRetVal: WordBool); safecall;
    function Get_CurrencySymbol: WideString; safecall;
    procedure Set_CurrencySymbol(const pRetVal: WideString); safecall;
    function Get_CurrencyCode: Integer; safecall;
    procedure Set_CurrencyCode(pRetVal: Integer); safecall;
    function Get_NetTotal: Double; safecall;
    procedure Set_NetTotal(pRetVal: Double); safecall;
    function Get_VATTotal: Double; safecall;
    procedure Set_VATTotal(pRetVal: Double); safecall;
    function Get_GrossTotal: Double; safecall;
    procedure Set_GrossTotal(pRetVal: Double); safecall;
    function Get_PaymentReference: WideString; safecall;
    procedure Set_PaymentReference(const pRetVal: WideString); safecall;
    function Get_DefaultPaymentProvider: WideString; safecall;
    procedure Set_DefaultPaymentProvider(const pRetVal: WideString); safecall;
    function Get_DefaultMerchantID: WideString; safecall;
    procedure Set_DefaultMerchantID(const pRetVal: WideString); safecall;
    function Get_AuthenticationGUID: WideString; safecall;
    procedure Set_AuthenticationGUID(const pRetVal: WideString); safecall;
    procedure AddLine(const line: ExchequerPaymentGateway_ITransactionLine); safecall;
    function GetLines: PSafeArray; safecall;
    property ExchequerCompanyCode: WideString read Get_ExchequerCompanyCode;
    property SalesOrderReference: WideString read Get_SalesOrderReference;
    property DescendentTransactionReference: WideString read Get_DescendentTransactionReference;
    property ContactName: WideString read Get_ContactName;
    property ContactPhone: WideString read Get_ContactPhone;
    property ContactEmail: WideString read Get_ContactEmail;
    property DeliveryAddress1: WideString read Get_DeliveryAddress1;
    property DeliveryAddress2: WideString read Get_DeliveryAddress2;
    property DeliveryAddress3_Town: WideString read Get_DeliveryAddress3_Town;
    property DeliveryAddress4_County: WideString read Get_DeliveryAddress4_County;
    property DeliveryAddress_Country: WideString read Get_DeliveryAddress_Country;
    property DeliveryAddressPostCode: WideString read Get_DeliveryAddressPostCode;
    property BillingAddress1: WideString read Get_BillingAddress1;
    property BillingAddress2: WideString read Get_BillingAddress2;
    property BillingAddress3_Town: WideString read Get_BillingAddress3_Town;
    property BillingAddress4_County: WideString read Get_BillingAddress4_County;
    property BillingAddress_Country: WideString read Get_BillingAddress_Country;
    property BillingAddressPostCode: WideString read Get_BillingAddressPostCode;
    property PaymentType: PaymentAction read Get_PaymentType;
    property FullAmount: WordBool read Get_FullAmount;
    property CurrencySymbol: WideString read Get_CurrencySymbol;
    property CurrencyCode: Integer read Get_CurrencyCode;
    property NetTotal: Double read Get_NetTotal;
    property VATTotal: Double read Get_VATTotal;
    property GrossTotal: Double read Get_GrossTotal;
    property PaymentReference: WideString read Get_PaymentReference;
    property DefaultPaymentProvider: WideString read Get_DefaultPaymentProvider;
    property DefaultMerchantID: WideString read Get_DefaultMerchantID;
    property AuthenticationGUID: WideString read Get_AuthenticationGUID;
  end;

// *********************************************************************//
// DispIntf:  IExchequerTransactionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A99DE27C-C762-4947-BFB3-7C1F41FDAAD4}
// *********************************************************************//
  IExchequerTransactionDisp = dispinterface
    ['{A99DE27C-C762-4947-BFB3-7C1F41FDAAD4}']
    property ExchequerCompanyCode: WideString readonly dispid 1610743808;
    property SalesOrderReference: WideString readonly dispid 1610743810;
    property DescendentTransactionReference: WideString readonly dispid 1610743812;
    property ContactName: WideString readonly dispid 1610743814;
    property ContactPhone: WideString readonly dispid 1610743816;
    property ContactEmail: WideString readonly dispid 1610743818;
    property DeliveryAddress1: WideString readonly dispid 1610743820;
    property DeliveryAddress2: WideString readonly dispid 1610743822;
    property DeliveryAddress3_Town: WideString readonly dispid 1610743824;
    property DeliveryAddress4_County: WideString readonly dispid 1610743826;
    property DeliveryAddress_Country: WideString readonly dispid 1610743828;
    property DeliveryAddressPostCode: WideString readonly dispid 1610743830;
    property BillingAddress1: WideString readonly dispid 1610743832;
    property BillingAddress2: WideString readonly dispid 1610743834;
    property BillingAddress3_Town: WideString readonly dispid 1610743836;
    property BillingAddress4_County: WideString readonly dispid 1610743838;
    property BillingAddress_Country: WideString readonly dispid 1610743840;
    property BillingAddressPostCode: WideString readonly dispid 1610743842;
    property PaymentType: PaymentAction readonly dispid 1610743844;
    property FullAmount: WordBool readonly dispid 1610743846;
    property CurrencySymbol: WideString readonly dispid 1610743848;
    property CurrencyCode: Integer readonly dispid 1610743850;
    property NetTotal: Double readonly dispid 1610743852;
    property VATTotal: Double readonly dispid 1610743854;
    property GrossTotal: Double readonly dispid 1610743856;
    property PaymentReference: WideString readonly dispid 1610743858;
    property DefaultPaymentProvider: WideString readonly dispid 1610743860;
    property DefaultMerchantID: WideString readonly dispid 1610743862;
    property AuthenticationGUID: WideString readonly dispid 1610743864;
    procedure AddLine(const line: ExchequerPaymentGateway_ITransactionLine); dispid 1610743866;
    function GetLines: {??PSafeArray}OleVariant; dispid 1610743867;
  end;

// *********************************************************************//
// DispIntf:  IPaymentDefaultInformation
// Flags:     (4096) Dispatchable
// GUID:      {522B9B05-D665-4340-8818-70547275898A}
// *********************************************************************//
  IPaymentDefaultInformation = dispinterface
    ['{522B9B05-D665-4340-8818-70547275898A}']
    property Result: WordBool readonly dispid 1610743808;
    property DefaultPaymentProvider: WideString readonly dispid 1610743810;
    property DefaultMerchantID: WideString readonly dispid 1610743812;
    property DefaultGLCode: Smallint readonly dispid 1610743814;
    property DefaultCostCentre: WideString readonly dispid 1610743816;
    property DefaultDepartment: WideString readonly dispid 1610743818;
  end;

// *********************************************************************//
// Interface: IPaymentGatewayResponse
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C523B87C-F41E-4DD1-A2D0-B482C1424995}
// *********************************************************************//
  IPaymentGatewayResponse = interface(IDispatch)
    ['{C523B87C-F41E-4DD1-A2D0-B482C1424995}']
    function Get_SalesOrderReference: WideString; safecall;
    procedure Set_SalesOrderReference(const pRetVal: WideString); safecall;
    function Get_DescendentTransactionReference: WideString; safecall;
    procedure Set_DescendentTransactionReference(const pRetVal: WideString); safecall;
    function Get_authTicket: WideString; safecall;
    procedure Set_authTicket(const pRetVal: WideString); safecall;
    function Get_gatewayTransactionGuid: WideString; safecall;
    procedure Set_gatewayTransactionGuid(const pRetVal: WideString); safecall;
    function Get_GatewayStatusId: Integer; safecall;
    procedure Set_GatewayStatusId(pRetVal: Integer); safecall;
    function Get_GatewayTransactionID: WideString; safecall;
    procedure Set_GatewayTransactionID(const pRetVal: WideString); safecall;
    function Get_GatewayVendorTxCode: WideString; safecall;
    procedure Set_GatewayVendorTxCode(const pRetVal: WideString); safecall;
    function Get_ServiceResponse: WideString; safecall;
    procedure Set_ServiceResponse(const pRetVal: WideString); safecall;
    function Get_IsError: WordBool; safecall;
    procedure Set_IsError(pRetVal: WordBool); safecall;
    function Get_GatewayVendorCardType: WideString; safecall;
    procedure Set_GatewayVendorCardType(const pRetVal: WideString); safecall;
    function Get_GatewayVendorCardLast4Digits: WideString; safecall;
    procedure Set_GatewayVendorCardLast4Digits(const pRetVal: WideString); safecall;
    function Get_GatewayVendorCardExpiryDate: WideString; safecall;
    procedure Set_GatewayVendorCardExpiryDate(const pRetVal: WideString); safecall;
    function Get_AuthorizationNumber: WideString; safecall;
    procedure Set_AuthorizationNumber(const pRetVal: WideString); safecall;
    function Get_GUIDReference: WideString; safecall;
    procedure Set_GUIDReference(const pRetVal: WideString); safecall;
    function Get_MultiplePayment: WordBool; safecall;
    procedure Set_MultiplePayment(pRetVal: WordBool); safecall;
    function Get_TransactionValue: Double; safecall;
    procedure Set_TransactionValue(pRetVal: Double); safecall;
    property SalesOrderReference: WideString read Get_SalesOrderReference;
    property DescendentTransactionReference: WideString read Get_DescendentTransactionReference;
    property authTicket: WideString read Get_authTicket;
    property gatewayTransactionGuid: WideString read Get_gatewayTransactionGuid;
    property GatewayStatusId: Integer read Get_GatewayStatusId;
    property GatewayTransactionID: WideString read Get_GatewayTransactionID;
    property GatewayVendorTxCode: WideString read Get_GatewayVendorTxCode;
    property ServiceResponse: WideString read Get_ServiceResponse;
    property IsError: WordBool read Get_IsError;
    property GatewayVendorCardType: WideString read Get_GatewayVendorCardType;
    property GatewayVendorCardLast4Digits: WideString read Get_GatewayVendorCardLast4Digits;
    property GatewayVendorCardExpiryDate: WideString read Get_GatewayVendorCardExpiryDate;
    property AuthorizationNumber: WideString read Get_AuthorizationNumber;
    property GUIDReference: WideString read Get_GUIDReference;
    property MultiplePayment: WordBool read Get_MultiplePayment;
    property TransactionValue: Double read Get_TransactionValue;
  end;

// *********************************************************************//
// DispIntf:  IPaymentGatewayResponseDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C523B87C-F41E-4DD1-A2D0-B482C1424995}
// *********************************************************************//
  IPaymentGatewayResponseDisp = dispinterface
    ['{C523B87C-F41E-4DD1-A2D0-B482C1424995}']
    property SalesOrderReference: WideString readonly dispid 1610743808;
    property DescendentTransactionReference: WideString readonly dispid 1610743810;
    property authTicket: WideString readonly dispid 1610743812;
    property gatewayTransactionGuid: WideString readonly dispid 1610743814;
    property GatewayStatusId: Integer readonly dispid 1610743816;
    property GatewayTransactionID: WideString readonly dispid 1610743818;
    property GatewayVendorTxCode: WideString readonly dispid 1610743820;
    property ServiceResponse: WideString readonly dispid 1610743822;
    property IsError: WordBool readonly dispid 1610743824;
    property GatewayVendorCardType: WideString readonly dispid 1610743826;
    property GatewayVendorCardLast4Digits: WideString readonly dispid 1610743828;
    property GatewayVendorCardExpiryDate: WideString readonly dispid 1610743830;
    property AuthorizationNumber: WideString readonly dispid 1610743832;
    property GUIDReference: WideString readonly dispid 1610743834;
    property MultiplePayment: WordBool readonly dispid 1610743836;
    property TransactionValue: Double readonly dispid 1610743838;
  end;

// *********************************************************************//
// Interface: _ctkDebugLog
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {AE09BD79-85D6-3EAA-8300-5C1F714CC1E7}
// *********************************************************************//
  _ctkDebugLog = interface(IDispatch)
    ['{AE09BD79-85D6-3EAA-8300-5C1F714CC1E7}']
  end;

// *********************************************************************//
// DispIntf:  _ctkDebugLogDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {AE09BD79-85D6-3EAA-8300-5C1F714CC1E7}
// *********************************************************************//
  _ctkDebugLogDisp = dispinterface
    ['{AE09BD79-85D6-3EAA-8300-5C1F714CC1E7}']
  end;

// *********************************************************************//
// Interface: _ToolkitWrapper
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {36CB0AB5-C5D5-351B-8803-36013CA487D5}
// *********************************************************************//
  _ToolkitWrapper = interface(IDispatch)
    ['{36CB0AB5-C5D5-351B-8803-36013CA487D5}']
  end;

// *********************************************************************//
// DispIntf:  _ToolkitWrapperDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {36CB0AB5-C5D5-351B-8803-36013CA487D5}
// *********************************************************************//
  _ToolkitWrapperDisp = dispinterface
    ['{36CB0AB5-C5D5-351B-8803-36013CA487D5}']
  end;

// *********************************************************************//
// Interface: ExchequerPaymentGateway_ITransactionLine
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6EA13381-AAAB-47AD-AE3B-971059680A2A}
// *********************************************************************//
  ExchequerPaymentGateway_ITransactionLine = interface(IDispatch)
    ['{6EA13381-AAAB-47AD-AE3B-971059680A2A}']
    function Get_Description: WideString; safecall;
    procedure Set_Description(const pRetVal: WideString); safecall;
    function Get_StockCode: WideString; safecall;
    procedure Set_StockCode(const pRetVal: WideString); safecall;
    function Get_VATCode: WideString; safecall;
    procedure Set_VATCode(const pRetVal: WideString); safecall;
    function Get_Quantity: Double; safecall;
    procedure Set_Quantity(pRetVal: Double); safecall;
    function Get_VATMultiplier: Double; safecall;
    procedure Set_VATMultiplier(pRetVal: Double); safecall;
    function Get_TotalNetValue: Double; safecall;
    procedure Set_TotalNetValue(pRetVal: Double); safecall;
    function Get_TotalVATValue: Double; safecall;
    procedure Set_TotalVATValue(pRetVal: Double); safecall;
    function Get_TotalGrossValue: Double; safecall;
    procedure Set_TotalGrossValue(pRetVal: Double); safecall;
    function Get_UnitPrice: Double; safecall;
    procedure Set_UnitPrice(pRetVal: Double); safecall;
    function Get_UnitDiscount: Double; safecall;
    procedure Set_UnitDiscount(pRetVal: Double); safecall;
    function Get_TotalDiscount: Double; safecall;
    procedure Set_TotalDiscount(pRetVal: Double); safecall;
    property Description: WideString read Get_Description;
    property StockCode: WideString read Get_StockCode;
    property VATCode: WideString read Get_VATCode;
    property Quantity: Double read Get_Quantity;
    property VATMultiplier: Double read Get_VATMultiplier;
    property TotalNetValue: Double read Get_TotalNetValue;
    property TotalVATValue: Double read Get_TotalVATValue;
    property TotalGrossValue: Double read Get_TotalGrossValue;
    property UnitPrice: Double read Get_UnitPrice;
    property UnitDiscount: Double read Get_UnitDiscount;
    property TotalDiscount: Double read Get_TotalDiscount;
  end;

// *********************************************************************//
// DispIntf:  ExchequerPaymentGateway_ITransactionLineDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6EA13381-AAAB-47AD-AE3B-971059680A2A}
// *********************************************************************//
  ExchequerPaymentGateway_ITransactionLineDisp = dispinterface
    ['{6EA13381-AAAB-47AD-AE3B-971059680A2A}']
    property Description: WideString readonly dispid 1610743808;
    property StockCode: WideString readonly dispid 1610743810;
    property VATCode: WideString readonly dispid 1610743812;
    property Quantity: Double readonly dispid 1610743814;
    property VATMultiplier: Double readonly dispid 1610743816;
    property TotalNetValue: Double readonly dispid 1610743818;
    property TotalVATValue: Double readonly dispid 1610743820;
    property TotalGrossValue: Double readonly dispid 1610743822;
    property UnitPrice: Double readonly dispid 1610743824;
    property UnitDiscount: Double readonly dispid 1610743826;
    property TotalDiscount: Double readonly dispid 1610743828;
  end;

// *********************************************************************//
// Interface: _XMLFuncs
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {41EBEA59-A659-366E-9E24-966A02470042}
// *********************************************************************//
  _XMLFuncs = interface(IDispatch)
    ['{41EBEA59-A659-366E-9E24-966A02470042}']
  end;

// *********************************************************************//
// DispIntf:  _XMLFuncsDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {41EBEA59-A659-366E-9E24-966A02470042}
// *********************************************************************//
  _XMLFuncsDisp = dispinterface
    ['{41EBEA59-A659-366E-9E24-966A02470042}']
  end;

// *********************************************************************//
// The Class CoPaymentGateway provides a Create and CreateRemote method to          
// create instances of the default interface IPaymentGatewayPlugin exposed by              
// the CoClass PaymentGateway. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPaymentGateway = class
    class function Create: IPaymentGatewayPlugin;
    class function CreateRemote(const MachineName: string): IPaymentGatewayPlugin;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TPaymentGateway
// Help String      : 
// Default Interface: IPaymentGatewayPlugin
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TPaymentGatewayProperties= class;
{$ENDIF}
  TPaymentGateway = class(TOleServer)
  private
    FIntf:        IPaymentGatewayPlugin;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TPaymentGatewayProperties;
    function      GetServerProperties: TPaymentGatewayProperties;
{$ENDIF}
    function      GetDefaultInterface: IPaymentGatewayPlugin;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IPaymentGatewayPlugin);
    procedure Disconnect; override;
    function SetCurrentCompanyCode(const aCompanyCode: WideString): WordBool;
    function GetDefaultGlCode(const SalesOrderReference: WideString; 
                              const TransactionReference: WideString; const UDF5: WideString; 
                              const UDF6: WideString; const UDF7: WideString; 
                              const UDF8: WideString; const UDF9: WideString; 
                              const UDF10: WideString): Smallint;
    function ProcessPayment(const TransactionDetails: IExchequerTransaction; aProvider: Int64; 
                            aMerchant: Int64): IPaymentGatewayResponse;
    function ProcessRefund(const TransactionDetails: IExchequerTransaction; 
                           const RefundReason: WideString): IPaymentGatewayResponse;
    function DisplayConfigurationDialog(hWnd: Integer; const aCompany: WideString; 
                                        const aUserId: WideString; aIsSuperUser: WordBool): DialogResult;
    function GetPaymentDefaults(out GLCode: Integer; out Provider: Int64; out MerchantID: Int64; 
                                out CostCentre: WideString; out Department: WideString; 
                                const UDF5: WideString; const UDF6: WideString; 
                                const UDF7: WideString; const UDF8: WideString; 
                                const UDF9: WideString; const UDF10: WideString): WordBool;
    function GetPaymentDefaultsEx(out GLCode: Integer; out Provider: Int64; out MerchantID: Int64; 
                                  out CostCentre: WideString; out Department: WideString; 
                                  out ProviderDescription: WideString; const UDF5: WideString; 
                                  const UDF6: WideString; const UDF7: WideString; 
                                  const UDF8: WideString; const UDF9: WideString; 
                                  const UDF10: WideString): WordBool;
    function IsCCEnabledForCompany(const aCompanyCode: WideString): WordBool;
    function SetParentHandle(hWnd: Integer): WordBool;
    function GetTransactionStatus(const aTransVendorTx: WideString): IPaymentGatewayResponse;
    function GetProcessedTransactionsByDateRange(startDate: TDateTime; endDate: TDateTime; 
                                                 pageNumber: Integer; out response: IUnknown): WordBool;
    function UpdateTransactionContent(const gatewayTransactionGuid: WideString; 
                                      const receiptReference: WideString; 
                                      const customData: WideString): Integer;
    function GetServiceStatus: WordBool;
    procedure CancelTransaction(const aTransactionGUID: WideString);
    procedure FreeResources;
    property DefaultInterface: IPaymentGatewayPlugin read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TPaymentGatewayProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TPaymentGateway
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TPaymentGatewayProperties = class(TPersistent)
  private
    FServer:    TPaymentGateway;
    function    GetDefaultInterface: IPaymentGatewayPlugin;
    constructor Create(AServer: TPaymentGateway);
  protected
  public
    property DefaultInterface: IPaymentGatewayPlugin read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoExchequerTransaction provides a Create and CreateRemote method to          
// create instances of the default interface IExchequerTransaction exposed by              
// the CoClass ExchequerTransaction. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExchequerTransaction = class
    class function Create: IExchequerTransaction;
    class function CreateRemote(const MachineName: string): IExchequerTransaction;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TExchequerTransaction
// Help String      : 
// Default Interface: IExchequerTransaction
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TExchequerTransactionProperties= class;
{$ENDIF}
  TExchequerTransaction = class(TOleServer)
  private
    FIntf:        IExchequerTransaction;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TExchequerTransactionProperties;
    function      GetServerProperties: TExchequerTransactionProperties;
{$ENDIF}
    function      GetDefaultInterface: IExchequerTransaction;
  protected
    procedure InitServerData; override;
    function Get_ExchequerCompanyCode: WideString;
    procedure Set_ExchequerCompanyCode(const pRetVal: WideString);
    function Get_SalesOrderReference: WideString;
    procedure Set_SalesOrderReference(const pRetVal: WideString);
    function Get_DescendentTransactionReference: WideString;
    procedure Set_DescendentTransactionReference(const pRetVal: WideString);
    function Get_ContactName: WideString;
    procedure Set_ContactName(const pRetVal: WideString);
    function Get_ContactPhone: WideString;
    procedure Set_ContactPhone(const pRetVal: WideString);
    function Get_ContactEmail: WideString;
    procedure Set_ContactEmail(const pRetVal: WideString);
    function Get_DeliveryAddress1: WideString;
    procedure Set_DeliveryAddress1(const pRetVal: WideString);
    function Get_DeliveryAddress2: WideString;
    procedure Set_DeliveryAddress2(const pRetVal: WideString);
    function Get_DeliveryAddress3_Town: WideString;
    procedure Set_DeliveryAddress3_Town(const pRetVal: WideString);
    function Get_DeliveryAddress4_County: WideString;
    procedure Set_DeliveryAddress4_County(const pRetVal: WideString);
    function Get_DeliveryAddress_Country: WideString;
    procedure Set_DeliveryAddress_Country(const pRetVal: WideString);
    function Get_DeliveryAddressPostCode: WideString;
    procedure Set_DeliveryAddressPostCode(const pRetVal: WideString);
    function Get_BillingAddress1: WideString;
    procedure Set_BillingAddress1(const pRetVal: WideString);
    function Get_BillingAddress2: WideString;
    procedure Set_BillingAddress2(const pRetVal: WideString);
    function Get_BillingAddress3_Town: WideString;
    procedure Set_BillingAddress3_Town(const pRetVal: WideString);
    function Get_BillingAddress4_County: WideString;
    procedure Set_BillingAddress4_County(const pRetVal: WideString);
    function Get_BillingAddress_Country: WideString;
    procedure Set_BillingAddress_Country(const pRetVal: WideString);
    function Get_BillingAddressPostCode: WideString;
    procedure Set_BillingAddressPostCode(const pRetVal: WideString);
    function Get_PaymentType: PaymentAction;
    procedure Set_PaymentType(pRetVal: PaymentAction);
    function Get_FullAmount: WordBool;
    procedure Set_FullAmount(pRetVal: WordBool);
    function Get_CurrencySymbol: WideString;
    procedure Set_CurrencySymbol(const pRetVal: WideString);
    function Get_CurrencyCode: Integer;
    procedure Set_CurrencyCode(pRetVal: Integer);
    function Get_NetTotal: Double;
    procedure Set_NetTotal(pRetVal: Double);
    function Get_VATTotal: Double;
    procedure Set_VATTotal(pRetVal: Double);
    function Get_GrossTotal: Double;
    procedure Set_GrossTotal(pRetVal: Double);
    function Get_PaymentReference: WideString;
    procedure Set_PaymentReference(const pRetVal: WideString);
    function Get_DefaultPaymentProvider: WideString;
    procedure Set_DefaultPaymentProvider(const pRetVal: WideString);
    function Get_DefaultMerchantID: WideString;
    procedure Set_DefaultMerchantID(const pRetVal: WideString);
    function Get_AuthenticationGUID: WideString;
    procedure Set_AuthenticationGUID(const pRetVal: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IExchequerTransaction);
    procedure Disconnect; override;
    procedure AddLine(const line: ExchequerPaymentGateway_ITransactionLine);
    function GetLines: PSafeArray;
    property DefaultInterface: IExchequerTransaction read GetDefaultInterface;
    property ExchequerCompanyCode: WideString read Get_ExchequerCompanyCode write Set_ExchequerCompanyCode;
    property SalesOrderReference: WideString read Get_SalesOrderReference write Set_SalesOrderReference;
    property DescendentTransactionReference: WideString read Get_DescendentTransactionReference write Set_DescendentTransactionReference;
    property ContactName: WideString read Get_ContactName write Set_ContactName;
    property ContactPhone: WideString read Get_ContactPhone write Set_ContactPhone;
    property ContactEmail: WideString read Get_ContactEmail write Set_ContactEmail;
    property DeliveryAddress1: WideString read Get_DeliveryAddress1 write Set_DeliveryAddress1;
    property DeliveryAddress2: WideString read Get_DeliveryAddress2 write Set_DeliveryAddress2;
    property DeliveryAddress3_Town: WideString read Get_DeliveryAddress3_Town write Set_DeliveryAddress3_Town;
    property DeliveryAddress4_County: WideString read Get_DeliveryAddress4_County write Set_DeliveryAddress4_County;
    property DeliveryAddress_Country: WideString read Get_DeliveryAddress_Country write Set_DeliveryAddress_Country;
    property DeliveryAddressPostCode: WideString read Get_DeliveryAddressPostCode write Set_DeliveryAddressPostCode;
    property BillingAddress1: WideString read Get_BillingAddress1 write Set_BillingAddress1;
    property BillingAddress2: WideString read Get_BillingAddress2 write Set_BillingAddress2;
    property BillingAddress3_Town: WideString read Get_BillingAddress3_Town write Set_BillingAddress3_Town;
    property BillingAddress4_County: WideString read Get_BillingAddress4_County write Set_BillingAddress4_County;
    property BillingAddress_Country: WideString read Get_BillingAddress_Country write Set_BillingAddress_Country;
    property BillingAddressPostCode: WideString read Get_BillingAddressPostCode write Set_BillingAddressPostCode;
    property PaymentType: PaymentAction read Get_PaymentType write Set_PaymentType;
    property FullAmount: WordBool read Get_FullAmount write Set_FullAmount;
    property CurrencySymbol: WideString read Get_CurrencySymbol write Set_CurrencySymbol;
    property CurrencyCode: Integer read Get_CurrencyCode write Set_CurrencyCode;
    property NetTotal: Double read Get_NetTotal write Set_NetTotal;
    property VATTotal: Double read Get_VATTotal write Set_VATTotal;
    property GrossTotal: Double read Get_GrossTotal write Set_GrossTotal;
    property PaymentReference: WideString read Get_PaymentReference write Set_PaymentReference;
    property DefaultPaymentProvider: WideString read Get_DefaultPaymentProvider write Set_DefaultPaymentProvider;
    property DefaultMerchantID: WideString read Get_DefaultMerchantID write Set_DefaultMerchantID;
    property AuthenticationGUID: WideString read Get_AuthenticationGUID write Set_AuthenticationGUID;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TExchequerTransactionProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TExchequerTransaction
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TExchequerTransactionProperties = class(TPersistent)
  private
    FServer:    TExchequerTransaction;
    function    GetDefaultInterface: IExchequerTransaction;
    constructor Create(AServer: TExchequerTransaction);
  protected
    function Get_ExchequerCompanyCode: WideString;
    procedure Set_ExchequerCompanyCode(const pRetVal: WideString);
    function Get_SalesOrderReference: WideString;
    procedure Set_SalesOrderReference(const pRetVal: WideString);
    function Get_DescendentTransactionReference: WideString;
    procedure Set_DescendentTransactionReference(const pRetVal: WideString);
    function Get_ContactName: WideString;
    procedure Set_ContactName(const pRetVal: WideString);
    function Get_ContactPhone: WideString;
    procedure Set_ContactPhone(const pRetVal: WideString);
    function Get_ContactEmail: WideString;
    procedure Set_ContactEmail(const pRetVal: WideString);
    function Get_DeliveryAddress1: WideString;
    procedure Set_DeliveryAddress1(const pRetVal: WideString);
    function Get_DeliveryAddress2: WideString;
    procedure Set_DeliveryAddress2(const pRetVal: WideString);
    function Get_DeliveryAddress3_Town: WideString;
    procedure Set_DeliveryAddress3_Town(const pRetVal: WideString);
    function Get_DeliveryAddress4_County: WideString;
    procedure Set_DeliveryAddress4_County(const pRetVal: WideString);
    function Get_DeliveryAddress_Country: WideString;
    procedure Set_DeliveryAddress_Country(const pRetVal: WideString);
    function Get_DeliveryAddressPostCode: WideString;
    procedure Set_DeliveryAddressPostCode(const pRetVal: WideString);
    function Get_BillingAddress1: WideString;
    procedure Set_BillingAddress1(const pRetVal: WideString);
    function Get_BillingAddress2: WideString;
    procedure Set_BillingAddress2(const pRetVal: WideString);
    function Get_BillingAddress3_Town: WideString;
    procedure Set_BillingAddress3_Town(const pRetVal: WideString);
    function Get_BillingAddress4_County: WideString;
    procedure Set_BillingAddress4_County(const pRetVal: WideString);
    function Get_BillingAddress_Country: WideString;
    procedure Set_BillingAddress_Country(const pRetVal: WideString);
    function Get_BillingAddressPostCode: WideString;
    procedure Set_BillingAddressPostCode(const pRetVal: WideString);
    function Get_PaymentType: PaymentAction;
    procedure Set_PaymentType(pRetVal: PaymentAction);
    function Get_FullAmount: WordBool;
    procedure Set_FullAmount(pRetVal: WordBool);
    function Get_CurrencySymbol: WideString;
    procedure Set_CurrencySymbol(const pRetVal: WideString);
    function Get_CurrencyCode: Integer;
    procedure Set_CurrencyCode(pRetVal: Integer);
    function Get_NetTotal: Double;
    procedure Set_NetTotal(pRetVal: Double);
    function Get_VATTotal: Double;
    procedure Set_VATTotal(pRetVal: Double);
    function Get_GrossTotal: Double;
    procedure Set_GrossTotal(pRetVal: Double);
    function Get_PaymentReference: WideString;
    procedure Set_PaymentReference(const pRetVal: WideString);
    function Get_DefaultPaymentProvider: WideString;
    procedure Set_DefaultPaymentProvider(const pRetVal: WideString);
    function Get_DefaultMerchantID: WideString;
    procedure Set_DefaultMerchantID(const pRetVal: WideString);
    function Get_AuthenticationGUID: WideString;
    procedure Set_AuthenticationGUID(const pRetVal: WideString);
  public
    property DefaultInterface: IExchequerTransaction read GetDefaultInterface;
  published
    property ExchequerCompanyCode: WideString read Get_ExchequerCompanyCode write Set_ExchequerCompanyCode;
    property SalesOrderReference: WideString read Get_SalesOrderReference write Set_SalesOrderReference;
    property DescendentTransactionReference: WideString read Get_DescendentTransactionReference write Set_DescendentTransactionReference;
    property ContactName: WideString read Get_ContactName write Set_ContactName;
    property ContactPhone: WideString read Get_ContactPhone write Set_ContactPhone;
    property ContactEmail: WideString read Get_ContactEmail write Set_ContactEmail;
    property DeliveryAddress1: WideString read Get_DeliveryAddress1 write Set_DeliveryAddress1;
    property DeliveryAddress2: WideString read Get_DeliveryAddress2 write Set_DeliveryAddress2;
    property DeliveryAddress3_Town: WideString read Get_DeliveryAddress3_Town write Set_DeliveryAddress3_Town;
    property DeliveryAddress4_County: WideString read Get_DeliveryAddress4_County write Set_DeliveryAddress4_County;
    property DeliveryAddress_Country: WideString read Get_DeliveryAddress_Country write Set_DeliveryAddress_Country;
    property DeliveryAddressPostCode: WideString read Get_DeliveryAddressPostCode write Set_DeliveryAddressPostCode;
    property BillingAddress1: WideString read Get_BillingAddress1 write Set_BillingAddress1;
    property BillingAddress2: WideString read Get_BillingAddress2 write Set_BillingAddress2;
    property BillingAddress3_Town: WideString read Get_BillingAddress3_Town write Set_BillingAddress3_Town;
    property BillingAddress4_County: WideString read Get_BillingAddress4_County write Set_BillingAddress4_County;
    property BillingAddress_Country: WideString read Get_BillingAddress_Country write Set_BillingAddress_Country;
    property BillingAddressPostCode: WideString read Get_BillingAddressPostCode write Set_BillingAddressPostCode;
    property PaymentType: PaymentAction read Get_PaymentType write Set_PaymentType;
    property FullAmount: WordBool read Get_FullAmount write Set_FullAmount;
    property CurrencySymbol: WideString read Get_CurrencySymbol write Set_CurrencySymbol;
    property CurrencyCode: Integer read Get_CurrencyCode write Set_CurrencyCode;
    property NetTotal: Double read Get_NetTotal write Set_NetTotal;
    property VATTotal: Double read Get_VATTotal write Set_VATTotal;
    property GrossTotal: Double read Get_GrossTotal write Set_GrossTotal;
    property PaymentReference: WideString read Get_PaymentReference write Set_PaymentReference;
    property DefaultPaymentProvider: WideString read Get_DefaultPaymentProvider write Set_DefaultPaymentProvider;
    property DefaultMerchantID: WideString read Get_DefaultMerchantID write Set_DefaultMerchantID;
    property AuthenticationGUID: WideString read Get_AuthenticationGUID write Set_AuthenticationGUID;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoPaymentDefaultInformation provides a Create and CreateRemote method to          
// create instances of the default interface IPaymentDefaultInformation exposed by              
// the CoClass PaymentDefaultInformation. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPaymentDefaultInformation = class
    class function Create: IPaymentDefaultInformation;
    class function CreateRemote(const MachineName: string): IPaymentDefaultInformation;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TPaymentDefaultInformation
// Help String      : 
// Default Interface: IPaymentDefaultInformation
// Def. Intf. DISP? : Yes
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TPaymentDefaultInformationProperties= class;
{$ENDIF}
  TPaymentDefaultInformation = class(TOleServer)
  private
    FIntf:        IPaymentDefaultInformation;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TPaymentDefaultInformationProperties;
    function      GetServerProperties: TPaymentDefaultInformationProperties;
{$ENDIF}
    function      GetDefaultInterface: IPaymentDefaultInformation;
  protected
    procedure InitServerData; override;
    function Get_Result: WordBool;
    procedure Set_Result(Param1: WordBool);
    function Get_DefaultPaymentProvider: WideString;
    procedure Set_DefaultPaymentProvider(const Param1: WideString);
    function Get_DefaultMerchantID: WideString;
    procedure Set_DefaultMerchantID(const Param1: WideString);
    function Get_DefaultGLCode: Smallint;
    procedure Set_DefaultGLCode(Param1: Smallint);
    function Get_DefaultCostCentre: WideString;
    procedure Set_DefaultCostCentre(const Param1: WideString);
    function Get_DefaultDepartment: WideString;
    procedure Set_DefaultDepartment(const Param1: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IPaymentDefaultInformation);
    procedure Disconnect; override;
    property DefaultInterface: IPaymentDefaultInformation read GetDefaultInterface;
    property Result: WordBool read Get_Result write Set_Result;
    property DefaultPaymentProvider: WideString read Get_DefaultPaymentProvider write Set_DefaultPaymentProvider;
    property DefaultMerchantID: WideString read Get_DefaultMerchantID write Set_DefaultMerchantID;
    property DefaultGLCode: Smallint read Get_DefaultGLCode write Set_DefaultGLCode;
    property DefaultCostCentre: WideString read Get_DefaultCostCentre write Set_DefaultCostCentre;
    property DefaultDepartment: WideString read Get_DefaultDepartment write Set_DefaultDepartment;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TPaymentDefaultInformationProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TPaymentDefaultInformation
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TPaymentDefaultInformationProperties = class(TPersistent)
  private
    FServer:    TPaymentDefaultInformation;
    function    GetDefaultInterface: IPaymentDefaultInformation;
    constructor Create(AServer: TPaymentDefaultInformation);
  protected
    function Get_Result: WordBool;
    procedure Set_Result(Param1: WordBool);
    function Get_DefaultPaymentProvider: WideString;
    procedure Set_DefaultPaymentProvider(const Param1: WideString);
    function Get_DefaultMerchantID: WideString;
    procedure Set_DefaultMerchantID(const Param1: WideString);
    function Get_DefaultGLCode: Smallint;
    procedure Set_DefaultGLCode(Param1: Smallint);
    function Get_DefaultCostCentre: WideString;
    procedure Set_DefaultCostCentre(const Param1: WideString);
    function Get_DefaultDepartment: WideString;
    procedure Set_DefaultDepartment(const Param1: WideString);
  public
    property DefaultInterface: IPaymentDefaultInformation read GetDefaultInterface;
  published
    property Result: WordBool read Get_Result write Set_Result;
    property DefaultPaymentProvider: WideString read Get_DefaultPaymentProvider write Set_DefaultPaymentProvider;
    property DefaultMerchantID: WideString read Get_DefaultMerchantID write Set_DefaultMerchantID;
    property DefaultGLCode: Smallint read Get_DefaultGLCode write Set_DefaultGLCode;
    property DefaultCostCentre: WideString read Get_DefaultCostCentre write Set_DefaultCostCentre;
    property DefaultDepartment: WideString read Get_DefaultDepartment write Set_DefaultDepartment;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoPaymentGatewayResponse provides a Create and CreateRemote method to          
// create instances of the default interface IPaymentGatewayResponse exposed by              
// the CoClass PaymentGatewayResponse. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPaymentGatewayResponse = class
    class function Create: IPaymentGatewayResponse;
    class function CreateRemote(const MachineName: string): IPaymentGatewayResponse;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TPaymentGatewayResponse
// Help String      : 
// Default Interface: IPaymentGatewayResponse
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TPaymentGatewayResponseProperties= class;
{$ENDIF}
  TPaymentGatewayResponse = class(TOleServer)
  private
    FIntf:        IPaymentGatewayResponse;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TPaymentGatewayResponseProperties;
    function      GetServerProperties: TPaymentGatewayResponseProperties;
{$ENDIF}
    function      GetDefaultInterface: IPaymentGatewayResponse;
  protected
    procedure InitServerData; override;
    function Get_SalesOrderReference: WideString;
    procedure Set_SalesOrderReference(const pRetVal: WideString);
    function Get_DescendentTransactionReference: WideString;
    procedure Set_DescendentTransactionReference(const pRetVal: WideString);
    function Get_authTicket: WideString;
    procedure Set_authTicket(const pRetVal: WideString);
    function Get_gatewayTransactionGuid: WideString;
    procedure Set_gatewayTransactionGuid(const pRetVal: WideString);
    function Get_GatewayStatusId: Integer;
    procedure Set_GatewayStatusId(pRetVal: Integer);
    function Get_GatewayTransactionID: WideString;
    procedure Set_GatewayTransactionID(const pRetVal: WideString);
    function Get_GatewayVendorTxCode: WideString;
    procedure Set_GatewayVendorTxCode(const pRetVal: WideString);
    function Get_ServiceResponse: WideString;
    procedure Set_ServiceResponse(const pRetVal: WideString);
    function Get_IsError: WordBool;
    procedure Set_IsError(pRetVal: WordBool);
    function Get_GatewayVendorCardType: WideString;
    procedure Set_GatewayVendorCardType(const pRetVal: WideString);
    function Get_GatewayVendorCardLast4Digits: WideString;
    procedure Set_GatewayVendorCardLast4Digits(const pRetVal: WideString);
    function Get_GatewayVendorCardExpiryDate: WideString;
    procedure Set_GatewayVendorCardExpiryDate(const pRetVal: WideString);
    function Get_AuthorizationNumber: WideString;
    procedure Set_AuthorizationNumber(const pRetVal: WideString);
    function Get_GUIDReference: WideString;
    procedure Set_GUIDReference(const pRetVal: WideString);
    function Get_MultiplePayment: WordBool;
    procedure Set_MultiplePayment(pRetVal: WordBool);
    function Get_TransactionValue: Double;
    procedure Set_TransactionValue(pRetVal: Double);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IPaymentGatewayResponse);
    procedure Disconnect; override;
    property DefaultInterface: IPaymentGatewayResponse read GetDefaultInterface;
    property SalesOrderReference: WideString read Get_SalesOrderReference write Set_SalesOrderReference;
    property DescendentTransactionReference: WideString read Get_DescendentTransactionReference write Set_DescendentTransactionReference;
    property authTicket: WideString read Get_authTicket write Set_authTicket;
    property gatewayTransactionGuid: WideString read Get_gatewayTransactionGuid write Set_gatewayTransactionGuid;
    property GatewayStatusId: Integer read Get_GatewayStatusId write Set_GatewayStatusId;
    property GatewayTransactionID: WideString read Get_GatewayTransactionID write Set_GatewayTransactionID;
    property GatewayVendorTxCode: WideString read Get_GatewayVendorTxCode write Set_GatewayVendorTxCode;
    property ServiceResponse: WideString read Get_ServiceResponse write Set_ServiceResponse;
    property IsError: WordBool read Get_IsError write Set_IsError;
    property GatewayVendorCardType: WideString read Get_GatewayVendorCardType write Set_GatewayVendorCardType;
    property GatewayVendorCardLast4Digits: WideString read Get_GatewayVendorCardLast4Digits write Set_GatewayVendorCardLast4Digits;
    property GatewayVendorCardExpiryDate: WideString read Get_GatewayVendorCardExpiryDate write Set_GatewayVendorCardExpiryDate;
    property AuthorizationNumber: WideString read Get_AuthorizationNumber write Set_AuthorizationNumber;
    property GUIDReference: WideString read Get_GUIDReference write Set_GUIDReference;
    property MultiplePayment: WordBool read Get_MultiplePayment write Set_MultiplePayment;
    property TransactionValue: Double read Get_TransactionValue write Set_TransactionValue;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TPaymentGatewayResponseProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TPaymentGatewayResponse
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TPaymentGatewayResponseProperties = class(TPersistent)
  private
    FServer:    TPaymentGatewayResponse;
    function    GetDefaultInterface: IPaymentGatewayResponse;
    constructor Create(AServer: TPaymentGatewayResponse);
  protected
    function Get_SalesOrderReference: WideString;
    procedure Set_SalesOrderReference(const pRetVal: WideString);
    function Get_DescendentTransactionReference: WideString;
    procedure Set_DescendentTransactionReference(const pRetVal: WideString);
    function Get_authTicket: WideString;
    procedure Set_authTicket(const pRetVal: WideString);
    function Get_gatewayTransactionGuid: WideString;
    procedure Set_gatewayTransactionGuid(const pRetVal: WideString);
    function Get_GatewayStatusId: Integer;
    procedure Set_GatewayStatusId(pRetVal: Integer);
    function Get_GatewayTransactionID: WideString;
    procedure Set_GatewayTransactionID(const pRetVal: WideString);
    function Get_GatewayVendorTxCode: WideString;
    procedure Set_GatewayVendorTxCode(const pRetVal: WideString);
    function Get_ServiceResponse: WideString;
    procedure Set_ServiceResponse(const pRetVal: WideString);
    function Get_IsError: WordBool;
    procedure Set_IsError(pRetVal: WordBool);
    function Get_GatewayVendorCardType: WideString;
    procedure Set_GatewayVendorCardType(const pRetVal: WideString);
    function Get_GatewayVendorCardLast4Digits: WideString;
    procedure Set_GatewayVendorCardLast4Digits(const pRetVal: WideString);
    function Get_GatewayVendorCardExpiryDate: WideString;
    procedure Set_GatewayVendorCardExpiryDate(const pRetVal: WideString);
    function Get_AuthorizationNumber: WideString;
    procedure Set_AuthorizationNumber(const pRetVal: WideString);
    function Get_GUIDReference: WideString;
    procedure Set_GUIDReference(const pRetVal: WideString);
    function Get_MultiplePayment: WordBool;
    procedure Set_MultiplePayment(pRetVal: WordBool);
    function Get_TransactionValue: Double;
    procedure Set_TransactionValue(pRetVal: Double);
  public
    property DefaultInterface: IPaymentGatewayResponse read GetDefaultInterface;
  published
    property SalesOrderReference: WideString read Get_SalesOrderReference write Set_SalesOrderReference;
    property DescendentTransactionReference: WideString read Get_DescendentTransactionReference write Set_DescendentTransactionReference;
    property authTicket: WideString read Get_authTicket write Set_authTicket;
    property gatewayTransactionGuid: WideString read Get_gatewayTransactionGuid write Set_gatewayTransactionGuid;
    property GatewayStatusId: Integer read Get_GatewayStatusId write Set_GatewayStatusId;
    property GatewayTransactionID: WideString read Get_GatewayTransactionID write Set_GatewayTransactionID;
    property GatewayVendorTxCode: WideString read Get_GatewayVendorTxCode write Set_GatewayVendorTxCode;
    property ServiceResponse: WideString read Get_ServiceResponse write Set_ServiceResponse;
    property IsError: WordBool read Get_IsError write Set_IsError;
    property GatewayVendorCardType: WideString read Get_GatewayVendorCardType write Set_GatewayVendorCardType;
    property GatewayVendorCardLast4Digits: WideString read Get_GatewayVendorCardLast4Digits write Set_GatewayVendorCardLast4Digits;
    property GatewayVendorCardExpiryDate: WideString read Get_GatewayVendorCardExpiryDate write Set_GatewayVendorCardExpiryDate;
    property AuthorizationNumber: WideString read Get_AuthorizationNumber write Set_AuthorizationNumber;
    property GUIDReference: WideString read Get_GUIDReference write Set_GUIDReference;
    property MultiplePayment: WordBool read Get_MultiplePayment write Set_MultiplePayment;
    property TransactionValue: Double read Get_TransactionValue write Set_TransactionValue;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTransactionLine provides a Create and CreateRemote method to          
// create instances of the default interface ExchequerPaymentGateway_ITransactionLine exposed by              
// the CoClass TransactionLine. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTransactionLine = class
    class function Create: ExchequerPaymentGateway_ITransactionLine;
    class function CreateRemote(const MachineName: string): ExchequerPaymentGateway_ITransactionLine;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTransactionLine
// Help String      : 
// Default Interface: ExchequerPaymentGateway_ITransactionLine
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTransactionLineProperties= class;
{$ENDIF}
  TTransactionLine = class(TOleServer)
  private
    FIntf:        ExchequerPaymentGateway_ITransactionLine;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTransactionLineProperties;
    function      GetServerProperties: TTransactionLineProperties;
{$ENDIF}
    function      GetDefaultInterface: ExchequerPaymentGateway_ITransactionLine;
  protected
    procedure InitServerData; override;
    function Get_Description: WideString;
    procedure Set_Description(const pRetVal: WideString);
    function Get_StockCode: WideString;
    procedure Set_StockCode(const pRetVal: WideString);
    function Get_VATCode: WideString;
    procedure Set_VATCode(const pRetVal: WideString);
    function Get_Quantity: Double;
    procedure Set_Quantity(pRetVal: Double);
    function Get_VATMultiplier: Double;
    procedure Set_VATMultiplier(pRetVal: Double);
    function Get_TotalNetValue: Double;
    procedure Set_TotalNetValue(pRetVal: Double);
    function Get_TotalVATValue: Double;
    procedure Set_TotalVATValue(pRetVal: Double);
    function Get_TotalGrossValue: Double;
    procedure Set_TotalGrossValue(pRetVal: Double);
    function Get_UnitPrice: Double;
    procedure Set_UnitPrice(pRetVal: Double);
    function Get_UnitDiscount: Double;
    procedure Set_UnitDiscount(pRetVal: Double);
    function Get_TotalDiscount: Double;
    procedure Set_TotalDiscount(pRetVal: Double);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ExchequerPaymentGateway_ITransactionLine);
    procedure Disconnect; override;
    property DefaultInterface: ExchequerPaymentGateway_ITransactionLine read GetDefaultInterface;
    property Description: WideString read Get_Description write Set_Description;
    property StockCode: WideString read Get_StockCode write Set_StockCode;
    property VATCode: WideString read Get_VATCode write Set_VATCode;
    property Quantity: Double read Get_Quantity write Set_Quantity;
    property VATMultiplier: Double read Get_VATMultiplier write Set_VATMultiplier;
    property TotalNetValue: Double read Get_TotalNetValue write Set_TotalNetValue;
    property TotalVATValue: Double read Get_TotalVATValue write Set_TotalVATValue;
    property TotalGrossValue: Double read Get_TotalGrossValue write Set_TotalGrossValue;
    property UnitPrice: Double read Get_UnitPrice write Set_UnitPrice;
    property UnitDiscount: Double read Get_UnitDiscount write Set_UnitDiscount;
    property TotalDiscount: Double read Get_TotalDiscount write Set_TotalDiscount;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTransactionLineProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTransactionLine
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTransactionLineProperties = class(TPersistent)
  private
    FServer:    TTransactionLine;
    function    GetDefaultInterface: ExchequerPaymentGateway_ITransactionLine;
    constructor Create(AServer: TTransactionLine);
  protected
    function Get_Description: WideString;
    procedure Set_Description(const pRetVal: WideString);
    function Get_StockCode: WideString;
    procedure Set_StockCode(const pRetVal: WideString);
    function Get_VATCode: WideString;
    procedure Set_VATCode(const pRetVal: WideString);
    function Get_Quantity: Double;
    procedure Set_Quantity(pRetVal: Double);
    function Get_VATMultiplier: Double;
    procedure Set_VATMultiplier(pRetVal: Double);
    function Get_TotalNetValue: Double;
    procedure Set_TotalNetValue(pRetVal: Double);
    function Get_TotalVATValue: Double;
    procedure Set_TotalVATValue(pRetVal: Double);
    function Get_TotalGrossValue: Double;
    procedure Set_TotalGrossValue(pRetVal: Double);
    function Get_UnitPrice: Double;
    procedure Set_UnitPrice(pRetVal: Double);
    function Get_UnitDiscount: Double;
    procedure Set_UnitDiscount(pRetVal: Double);
    function Get_TotalDiscount: Double;
    procedure Set_TotalDiscount(pRetVal: Double);
  public
    property DefaultInterface: ExchequerPaymentGateway_ITransactionLine read GetDefaultInterface;
  published
    property Description: WideString read Get_Description write Set_Description;
    property StockCode: WideString read Get_StockCode write Set_StockCode;
    property VATCode: WideString read Get_VATCode write Set_VATCode;
    property Quantity: Double read Get_Quantity write Set_Quantity;
    property VATMultiplier: Double read Get_VATMultiplier write Set_VATMultiplier;
    property TotalNetValue: Double read Get_TotalNetValue write Set_TotalNetValue;
    property TotalVATValue: Double read Get_TotalVATValue write Set_TotalVATValue;
    property TotalGrossValue: Double read Get_TotalGrossValue write Set_TotalGrossValue;
    property UnitPrice: Double read Get_UnitPrice write Set_UnitPrice;
    property UnitDiscount: Double read Get_UnitDiscount write Set_UnitDiscount;
    property TotalDiscount: Double read Get_TotalDiscount write Set_TotalDiscount;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoMCMCompany provides a Create and CreateRemote method to          
// create instances of the default interface _MCMCompany exposed by              
// the CoClass MCMCompany. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMCMCompany = class
    class function Create: _MCMCompany;
    class function CreateRemote(const MachineName: string): _MCMCompany;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMCMCompany
// Help String      : 
// Default Interface: _MCMCompany
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMCMCompanyProperties= class;
{$ENDIF}
  TMCMCompany = class(TOleServer)
  private
    FIntf:        _MCMCompany;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMCMCompanyProperties;
    function      GetServerProperties: TMCMCompanyProperties;
{$ENDIF}
    function      GetDefaultInterface: _MCMCompany;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _MCMCompany);
    procedure Disconnect; override;
    property DefaultInterface: _MCMCompany read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMCMCompanyProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMCMCompany
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMCMCompanyProperties = class(TPersistent)
  private
    FServer:    TMCMCompany;
    function    GetDefaultInterface: _MCMCompany;
    constructor Create(AServer: TMCMCompany);
  protected
  public
    property DefaultInterface: _MCMCompany read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoGLCodeListItem provides a Create and CreateRemote method to          
// create instances of the default interface _GLCodeListItem exposed by              
// the CoClass GLCodeListItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGLCodeListItem = class
    class function Create: _GLCodeListItem;
    class function CreateRemote(const MachineName: string): _GLCodeListItem;
  end;

// *********************************************************************//
// The Class CoCostCentreDeptListItem provides a Create and CreateRemote method to          
// create instances of the default interface _CostCentreDeptListItem exposed by              
// the CoClass CostCentreDeptListItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCostCentreDeptListItem = class
    class function Create: _CostCentreDeptListItem;
    class function CreateRemote(const MachineName: string): _CostCentreDeptListItem;
  end;

// *********************************************************************//
// The Class CoSourceConfig provides a Create and CreateRemote method to          
// create instances of the default interface _SourceConfig exposed by              
// the CoClass SourceConfig. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSourceConfig = class
    class function Create: _SourceConfig;
    class function CreateRemote(const MachineName: string): _SourceConfig;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSourceConfig
// Help String      : 
// Default Interface: _SourceConfig
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSourceConfigProperties= class;
{$ENDIF}
  TSourceConfig = class(TOleServer)
  private
    FIntf:        _SourceConfig;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSourceConfigProperties;
    function      GetServerProperties: TSourceConfigProperties;
{$ENDIF}
    function      GetDefaultInterface: _SourceConfig;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _SourceConfig);
    procedure Disconnect; override;
    property DefaultInterface: _SourceConfig read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSourceConfigProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSourceConfig
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSourceConfigProperties = class(TPersistent)
  private
    FServer:    TSourceConfig;
    function    GetDefaultInterface: _SourceConfig;
    constructor Create(AServer: TSourceConfig);
  protected
  public
    property DefaultInterface: _SourceConfig read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoCurrencyCodes provides a Create and CreateRemote method to          
// create instances of the default interface _CurrencyCodes exposed by              
// the CoClass CurrencyCodes. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCurrencyCodes = class
    class function Create: _CurrencyCodes;
    class function CreateRemote(const MachineName: string): _CurrencyCodes;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TCurrencyCodes
// Help String      : 
// Default Interface: _CurrencyCodes
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TCurrencyCodesProperties= class;
{$ENDIF}
  TCurrencyCodes = class(TOleServer)
  private
    FIntf:        _CurrencyCodes;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TCurrencyCodesProperties;
    function      GetServerProperties: TCurrencyCodesProperties;
{$ENDIF}
    function      GetDefaultInterface: _CurrencyCodes;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _CurrencyCodes);
    procedure Disconnect; override;
    property DefaultInterface: _CurrencyCodes read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TCurrencyCodesProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TCurrencyCodes
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TCurrencyCodesProperties = class(TPersistent)
  private
    FServer:    TCurrencyCodes;
    function    GetDefaultInterface: _CurrencyCodes;
    constructor Create(AServer: TCurrencyCodes);
  protected
  public
    property DefaultInterface: _CurrencyCodes read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoCompanyConfig provides a Create and CreateRemote method to          
// create instances of the default interface _CompanyConfig exposed by              
// the CoClass CompanyConfig. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCompanyConfig = class
    class function Create: _CompanyConfig;
    class function CreateRemote(const MachineName: string): _CompanyConfig;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TCompanyConfig
// Help String      : 
// Default Interface: _CompanyConfig
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TCompanyConfigProperties= class;
{$ENDIF}
  TCompanyConfig = class(TOleServer)
  private
    FIntf:        _CompanyConfig;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TCompanyConfigProperties;
    function      GetServerProperties: TCompanyConfigProperties;
{$ENDIF}
    function      GetDefaultInterface: _CompanyConfig;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _CompanyConfig);
    procedure Disconnect; override;
    property DefaultInterface: _CompanyConfig read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TCompanyConfigProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TCompanyConfig
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TCompanyConfigProperties = class(TPersistent)
  private
    FServer:    TCompanyConfig;
    function    GetDefaultInterface: _CompanyConfig;
    constructor Create(AServer: TCompanyConfig);
  protected
  public
    property DefaultInterface: _CompanyConfig read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSiteConfig provides a Create and CreateRemote method to          
// create instances of the default interface _SiteConfig exposed by              
// the CoClass SiteConfig. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSiteConfig = class
    class function Create: _SiteConfig;
    class function CreateRemote(const MachineName: string): _SiteConfig;
  end;

// *********************************************************************//
// The Class CoDebugView provides a Create and CreateRemote method to          
// create instances of the default interface _DebugView exposed by              
// the CoClass DebugView. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDebugView = class
    class function Create: _DebugView;
    class function CreateRemote(const MachineName: string): _DebugView;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TDebugView
// Help String      : 
// Default Interface: _DebugView
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDebugViewProperties= class;
{$ENDIF}
  TDebugView = class(TOleServer)
  private
    FIntf:        _DebugView;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDebugViewProperties;
    function      GetServerProperties: TDebugViewProperties;
{$ENDIF}
    function      GetDefaultInterface: _DebugView;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _DebugView);
    procedure Disconnect; override;
    property DefaultInterface: _DebugView read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDebugViewProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TDebugView
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TDebugViewProperties = class(TPersistent)
  private
    FServer:    TDebugView;
    function    GetDefaultInterface: _DebugView;
    constructor Create(AServer: TDebugView);
  protected
  public
    property DefaultInterface: _DebugView read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoTextLock provides a Create and CreateRemote method to          
// create instances of the default interface _TextLock exposed by              
// the CoClass TextLock. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTextLock = class
    class function Create: _TextLock;
    class function CreateRemote(const MachineName: string): _TextLock;
  end;

// *********************************************************************//
// The Class CoDataRestorer provides a Create and CreateRemote method to          
// create instances of the default interface _DataRestorer exposed by              
// the CoClass DataRestorer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDataRestorer = class
    class function Create: _DataRestorer;
    class function CreateRemote(const MachineName: string): _DataRestorer;
  end;

// *********************************************************************//
// The Class CoRecoveryCustomDataLine provides a Create and CreateRemote method to          
// create instances of the default interface _RecoveryCustomDataLine exposed by              
// the CoClass RecoveryCustomDataLine. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRecoveryCustomDataLine = class
    class function Create: _RecoveryCustomDataLine;
    class function CreateRemote(const MachineName: string): _RecoveryCustomDataLine;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TRecoveryCustomDataLine
// Help String      : 
// Default Interface: _RecoveryCustomDataLine
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TRecoveryCustomDataLineProperties= class;
{$ENDIF}
  TRecoveryCustomDataLine = class(TOleServer)
  private
    FIntf:        _RecoveryCustomDataLine;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TRecoveryCustomDataLineProperties;
    function      GetServerProperties: TRecoveryCustomDataLineProperties;
{$ENDIF}
    function      GetDefaultInterface: _RecoveryCustomDataLine;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _RecoveryCustomDataLine);
    procedure Disconnect; override;
    property DefaultInterface: _RecoveryCustomDataLine read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TRecoveryCustomDataLineProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TRecoveryCustomDataLine
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TRecoveryCustomDataLineProperties = class(TPersistent)
  private
    FServer:    TRecoveryCustomDataLine;
    function    GetDefaultInterface: _RecoveryCustomDataLine;
    constructor Create(AServer: TRecoveryCustomDataLine);
  protected
  public
    property DefaultInterface: _RecoveryCustomDataLine read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoRecoveryCustomDataTransaction provides a Create and CreateRemote method to          
// create instances of the default interface _RecoveryCustomDataTransaction exposed by              
// the CoClass RecoveryCustomDataTransaction. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRecoveryCustomDataTransaction = class
    class function Create: _RecoveryCustomDataTransaction;
    class function CreateRemote(const MachineName: string): _RecoveryCustomDataTransaction;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TRecoveryCustomDataTransaction
// Help String      : 
// Default Interface: _RecoveryCustomDataTransaction
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TRecoveryCustomDataTransactionProperties= class;
{$ENDIF}
  TRecoveryCustomDataTransaction = class(TOleServer)
  private
    FIntf:        _RecoveryCustomDataTransaction;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TRecoveryCustomDataTransactionProperties;
    function      GetServerProperties: TRecoveryCustomDataTransactionProperties;
{$ENDIF}
    function      GetDefaultInterface: _RecoveryCustomDataTransaction;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _RecoveryCustomDataTransaction);
    procedure Disconnect; override;
    property DefaultInterface: _RecoveryCustomDataTransaction read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TRecoveryCustomDataTransactionProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TRecoveryCustomDataTransaction
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TRecoveryCustomDataTransactionProperties = class(TPersistent)
  private
    FServer:    TRecoveryCustomDataTransaction;
    function    GetDefaultInterface: _RecoveryCustomDataTransaction;
    constructor Create(AServer: TRecoveryCustomDataTransaction);
  protected
  public
    property DefaultInterface: _RecoveryCustomDataTransaction read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoEncryption2 provides a Create and CreateRemote method to          
// create instances of the default interface _Encryption2 exposed by              
// the CoClass Encryption2. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoEncryption2 = class
    class function Create: _Encryption2;
    class function CreateRemote(const MachineName: string): _Encryption2;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TEncryption2
// Help String      : 
// Default Interface: _Encryption2
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TEncryption2Properties= class;
{$ENDIF}
  TEncryption2 = class(TOleServer)
  private
    FIntf:        _Encryption2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TEncryption2Properties;
    function      GetServerProperties: TEncryption2Properties;
{$ENDIF}
    function      GetDefaultInterface: _Encryption2;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _Encryption2);
    procedure Disconnect; override;
    property DefaultInterface: _Encryption2 read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TEncryption2Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TEncryption2
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TEncryption2Properties = class(TPersistent)
  private
    FServer:    TEncryption2;
    function    GetDefaultInterface: _Encryption2;
    constructor Create(AServer: TEncryption2);
  protected
  public
    property DefaultInterface: _Encryption2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoRestoreLog provides a Create and CreateRemote method to          
// create instances of the default interface _RestoreLog exposed by              
// the CoClass RestoreLog. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRestoreLog = class
    class function Create: _RestoreLog;
    class function CreateRemote(const MachineName: string): _RestoreLog;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TRestoreLog
// Help String      : 
// Default Interface: _RestoreLog
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TRestoreLogProperties= class;
{$ENDIF}
  TRestoreLog = class(TOleServer)
  private
    FIntf:        _RestoreLog;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TRestoreLogProperties;
    function      GetServerProperties: TRestoreLogProperties;
{$ENDIF}
    function      GetDefaultInterface: _RestoreLog;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _RestoreLog);
    procedure Disconnect; override;
    property DefaultInterface: _RestoreLog read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TRestoreLogProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TRestoreLog
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TRestoreLogProperties = class(TPersistent)
  private
    FServer:    TRestoreLog;
    function    GetDefaultInterface: _RestoreLog;
    constructor Create(AServer: TRestoreLog);
  protected
  public
    property DefaultInterface: _RestoreLog read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoFileAssociation provides a Create and CreateRemote method to          
// create instances of the default interface _FileAssociation exposed by              
// the CoClass FileAssociation. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFileAssociation = class
    class function Create: _FileAssociation;
    class function CreateRemote(const MachineName: string): _FileAssociation;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TFileAssociation
// Help String      : 
// Default Interface: _FileAssociation
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TFileAssociationProperties= class;
{$ENDIF}
  TFileAssociation = class(TOleServer)
  private
    FIntf:        _FileAssociation;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TFileAssociationProperties;
    function      GetServerProperties: TFileAssociationProperties;
{$ENDIF}
    function      GetDefaultInterface: _FileAssociation;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _FileAssociation);
    procedure Disconnect; override;
    property DefaultInterface: _FileAssociation read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TFileAssociationProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TFileAssociation
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TFileAssociationProperties = class(TPersistent)
  private
    FServer:    TFileAssociation;
    function    GetDefaultInterface: _FileAssociation;
    constructor Create(AServer: TFileAssociation);
  protected
  public
    property DefaultInterface: _FileAssociation read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoConfigurationForm provides a Create and CreateRemote method to          
// create instances of the default interface _ConfigurationForm exposed by              
// the CoClass ConfigurationForm. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoConfigurationForm = class
    class function Create: _ConfigurationForm;
    class function CreateRemote(const MachineName: string): _ConfigurationForm;
  end;

// *********************************************************************//
// The Class CoMCMComboBoxItem provides a Create and CreateRemote method to          
// create instances of the default interface _MCMComboBoxItem exposed by              
// the CoClass MCMComboBoxItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMCMComboBoxItem = class
    class function Create: _MCMComboBoxItem;
    class function CreateRemote(const MachineName: string): _MCMComboBoxItem;
  end;

// *********************************************************************//
// The Class CoGlobalData provides a Create and CreateRemote method to          
// create instances of the default interface _GlobalData exposed by              
// the CoClass GlobalData. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlobalData = class
    class function Create: _GlobalData;
    class function CreateRemote(const MachineName: string): _GlobalData;
  end;

// *********************************************************************//
// The Class CoctkDebugLog provides a Create and CreateRemote method to          
// create instances of the default interface _ctkDebugLog exposed by              
// the CoClass ctkDebugLog. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoctkDebugLog = class
    class function Create: _ctkDebugLog;
    class function CreateRemote(const MachineName: string): _ctkDebugLog;
  end;

// *********************************************************************//
// The Class CoToolkitWrapper provides a Create and CreateRemote method to          
// create instances of the default interface _ToolkitWrapper exposed by              
// the CoClass ToolkitWrapper. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoToolkitWrapper = class
    class function Create: _ToolkitWrapper;
    class function CreateRemote(const MachineName: string): _ToolkitWrapper;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TToolkitWrapper
// Help String      : 
// Default Interface: _ToolkitWrapper
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TToolkitWrapperProperties= class;
{$ENDIF}
  TToolkitWrapper = class(TOleServer)
  private
    FIntf:        _ToolkitWrapper;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TToolkitWrapperProperties;
    function      GetServerProperties: TToolkitWrapperProperties;
{$ENDIF}
    function      GetDefaultInterface: _ToolkitWrapper;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ToolkitWrapper);
    procedure Disconnect; override;
    property DefaultInterface: _ToolkitWrapper read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TToolkitWrapperProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TToolkitWrapper
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TToolkitWrapperProperties = class(TPersistent)
  private
    FServer:    TToolkitWrapper;
    function    GetDefaultInterface: _ToolkitWrapper;
    constructor Create(AServer: TToolkitWrapper);
  protected
  public
    property DefaultInterface: _ToolkitWrapper read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoXMLFuncs provides a Create and CreateRemote method to          
// create instances of the default interface _XMLFuncs exposed by              
// the CoClass XMLFuncs. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoXMLFuncs = class
    class function Create: _XMLFuncs;
    class function CreateRemote(const MachineName: string): _XMLFuncs;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

implementation

uses ComObj;

class function CoPaymentGateway.Create: IPaymentGatewayPlugin;
begin
  Result := CreateComObject(CLASS_PaymentGateway) as IPaymentGatewayPlugin;
end;

class function CoPaymentGateway.CreateRemote(const MachineName: string): IPaymentGatewayPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PaymentGateway) as IPaymentGatewayPlugin;
end;

procedure TPaymentGateway.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{FBA4004E-D3D9-4AD2-803A-BB5E8BBA4237}';
    IntfIID:   '{A4F422CF-2B78-4946-A10A-8BDC0094AF5B}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TPaymentGateway.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IPaymentGatewayPlugin;
  end;
end;

procedure TPaymentGateway.ConnectTo(svrIntf: IPaymentGatewayPlugin);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TPaymentGateway.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TPaymentGateway.GetDefaultInterface: IPaymentGatewayPlugin;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TPaymentGateway.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TPaymentGatewayProperties.Create(Self);
{$ENDIF}
end;

destructor TPaymentGateway.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TPaymentGateway.GetServerProperties: TPaymentGatewayProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TPaymentGateway.SetCurrentCompanyCode(const aCompanyCode: WideString): WordBool;
begin
  Result := DefaultInterface.SetCurrentCompanyCode(aCompanyCode);
end;

function TPaymentGateway.GetDefaultGlCode(const SalesOrderReference: WideString; 
                                          const TransactionReference: WideString; 
                                          const UDF5: WideString; const UDF6: WideString; 
                                          const UDF7: WideString; const UDF8: WideString; 
                                          const UDF9: WideString; const UDF10: WideString): Smallint;
begin
  Result := DefaultInterface.GetDefaultGlCode(SalesOrderReference, TransactionReference, UDF5, 
                                              UDF6, UDF7, UDF8, UDF9, UDF10);
end;

function TPaymentGateway.ProcessPayment(const TransactionDetails: IExchequerTransaction; 
                                        aProvider: Int64; aMerchant: Int64): IPaymentGatewayResponse;
begin
  Result := DefaultInterface.ProcessPayment(TransactionDetails, aProvider, aMerchant);
end;

function TPaymentGateway.ProcessRefund(const TransactionDetails: IExchequerTransaction; 
                                       const RefundReason: WideString): IPaymentGatewayResponse;
begin
  Result := DefaultInterface.ProcessRefund(TransactionDetails, RefundReason);
end;

function TPaymentGateway.DisplayConfigurationDialog(hWnd: Integer; const aCompany: WideString; 
                                                    const aUserId: WideString; 
                                                    aIsSuperUser: WordBool): DialogResult;
begin
  Result := DefaultInterface.DisplayConfigurationDialog(hWnd, aCompany, aUserId, aIsSuperUser);
end;

function TPaymentGateway.GetPaymentDefaults(out GLCode: Integer; out Provider: Int64; 
                                            out MerchantID: Int64; out CostCentre: WideString; 
                                            out Department: WideString; const UDF5: WideString; 
                                            const UDF6: WideString; const UDF7: WideString; 
                                            const UDF8: WideString; const UDF9: WideString; 
                                            const UDF10: WideString): WordBool;
begin
  Result := DefaultInterface.GetPaymentDefaults(GLCode, Provider, MerchantID, CostCentre, 
                                                Department, UDF5, UDF6, UDF7, UDF8, UDF9, UDF10);
end;

function TPaymentGateway.GetPaymentDefaultsEx(out GLCode: Integer; out Provider: Int64; 
                                              out MerchantID: Int64; out CostCentre: WideString; 
                                              out Department: WideString; 
                                              out ProviderDescription: WideString; 
                                              const UDF5: WideString; const UDF6: WideString; 
                                              const UDF7: WideString; const UDF8: WideString; 
                                              const UDF9: WideString; const UDF10: WideString): WordBool;
begin
  Result := DefaultInterface.GetPaymentDefaultsEx(GLCode, Provider, MerchantID, CostCentre, 
                                                  Department, ProviderDescription, UDF5, UDF6, 
                                                  UDF7, UDF8, UDF9, UDF10);
end;

function TPaymentGateway.IsCCEnabledForCompany(const aCompanyCode: WideString): WordBool;
begin
  Result := DefaultInterface.IsCCEnabledForCompany(aCompanyCode);
end;

function TPaymentGateway.SetParentHandle(hWnd: Integer): WordBool;
begin
  Result := DefaultInterface.SetParentHandle(hWnd);
end;

function TPaymentGateway.GetTransactionStatus(const aTransVendorTx: WideString): IPaymentGatewayResponse;
begin
  Result := DefaultInterface.GetTransactionStatus(aTransVendorTx);
end;

function TPaymentGateway.GetProcessedTransactionsByDateRange(startDate: TDateTime; 
                                                             endDate: TDateTime; 
                                                             pageNumber: Integer; 
                                                             out response: IUnknown): WordBool;
begin
  Result := DefaultInterface.GetProcessedTransactionsByDateRange(startDate, endDate, pageNumber, 
                                                                 response);
end;

function TPaymentGateway.UpdateTransactionContent(const gatewayTransactionGuid: WideString; 
                                                  const receiptReference: WideString; 
                                                  const customData: WideString): Integer;
begin
  Result := DefaultInterface.UpdateTransactionContent(gatewayTransactionGuid, receiptReference, 
                                                      customData);
end;

function TPaymentGateway.GetServiceStatus: WordBool;
begin
  Result := DefaultInterface.GetServiceStatus;
end;

procedure TPaymentGateway.CancelTransaction(const aTransactionGUID: WideString);
begin
  DefaultInterface.CancelTransaction(aTransactionGUID);
end;

procedure TPaymentGateway.FreeResources;
begin
  DefaultInterface.FreeResources;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TPaymentGatewayProperties.Create(AServer: TPaymentGateway);
begin
  inherited Create;
  FServer := AServer;
end;

function TPaymentGatewayProperties.GetDefaultInterface: IPaymentGatewayPlugin;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoExchequerTransaction.Create: IExchequerTransaction;
begin
  Result := CreateComObject(CLASS_ExchequerTransaction) as IExchequerTransaction;
end;

class function CoExchequerTransaction.CreateRemote(const MachineName: string): IExchequerTransaction;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExchequerTransaction) as IExchequerTransaction;
end;

procedure TExchequerTransaction.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F87B9216-FCCD-4FC8-B0AB-77FA787D00AD}';
    IntfIID:   '{A99DE27C-C762-4947-BFB3-7C1F41FDAAD4}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TExchequerTransaction.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IExchequerTransaction;
  end;
end;

procedure TExchequerTransaction.ConnectTo(svrIntf: IExchequerTransaction);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TExchequerTransaction.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TExchequerTransaction.GetDefaultInterface: IExchequerTransaction;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TExchequerTransaction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TExchequerTransactionProperties.Create(Self);
{$ENDIF}
end;

destructor TExchequerTransaction.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TExchequerTransaction.GetServerProperties: TExchequerTransactionProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TExchequerTransaction.Get_ExchequerCompanyCode: WideString;
begin
    Result := DefaultInterface.ExchequerCompanyCode;
end;

procedure TExchequerTransaction.Set_ExchequerCompanyCode(const pRetVal: WideString);
  { Warning: The property ExchequerCompanyCode has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ExchequerCompanyCode := pRetVal;
end;

function TExchequerTransaction.Get_SalesOrderReference: WideString;
begin
    Result := DefaultInterface.SalesOrderReference;
end;

procedure TExchequerTransaction.Set_SalesOrderReference(const pRetVal: WideString);
  { Warning: The property SalesOrderReference has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.SalesOrderReference := pRetVal;
end;

function TExchequerTransaction.Get_DescendentTransactionReference: WideString;
begin
    Result := DefaultInterface.DescendentTransactionReference;
end;

procedure TExchequerTransaction.Set_DescendentTransactionReference(const pRetVal: WideString);
  { Warning: The property DescendentTransactionReference has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DescendentTransactionReference := pRetVal;
end;

function TExchequerTransaction.Get_ContactName: WideString;
begin
    Result := DefaultInterface.ContactName;
end;

procedure TExchequerTransaction.Set_ContactName(const pRetVal: WideString);
  { Warning: The property ContactName has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ContactName := pRetVal;
end;

function TExchequerTransaction.Get_ContactPhone: WideString;
begin
    Result := DefaultInterface.ContactPhone;
end;

procedure TExchequerTransaction.Set_ContactPhone(const pRetVal: WideString);
  { Warning: The property ContactPhone has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ContactPhone := pRetVal;
end;

function TExchequerTransaction.Get_ContactEmail: WideString;
begin
    Result := DefaultInterface.ContactEmail;
end;

procedure TExchequerTransaction.Set_ContactEmail(const pRetVal: WideString);
  { Warning: The property ContactEmail has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ContactEmail := pRetVal;
end;

function TExchequerTransaction.Get_DeliveryAddress1: WideString;
begin
    Result := DefaultInterface.DeliveryAddress1;
end;

procedure TExchequerTransaction.Set_DeliveryAddress1(const pRetVal: WideString);
  { Warning: The property DeliveryAddress1 has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DeliveryAddress1 := pRetVal;
end;

function TExchequerTransaction.Get_DeliveryAddress2: WideString;
begin
    Result := DefaultInterface.DeliveryAddress2;
end;

procedure TExchequerTransaction.Set_DeliveryAddress2(const pRetVal: WideString);
  { Warning: The property DeliveryAddress2 has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DeliveryAddress2 := pRetVal;
end;

function TExchequerTransaction.Get_DeliveryAddress3_Town: WideString;
begin
    Result := DefaultInterface.DeliveryAddress3_Town;
end;

procedure TExchequerTransaction.Set_DeliveryAddress3_Town(const pRetVal: WideString);
  { Warning: The property DeliveryAddress3_Town has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DeliveryAddress3_Town := pRetVal;
end;

function TExchequerTransaction.Get_DeliveryAddress4_County: WideString;
begin
    Result := DefaultInterface.DeliveryAddress4_County;
end;

procedure TExchequerTransaction.Set_DeliveryAddress4_County(const pRetVal: WideString);
  { Warning: The property DeliveryAddress4_County has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DeliveryAddress4_County := pRetVal;
end;

function TExchequerTransaction.Get_DeliveryAddress_Country: WideString;
begin
    Result := DefaultInterface.DeliveryAddress_Country;
end;

procedure TExchequerTransaction.Set_DeliveryAddress_Country(const pRetVal: WideString);
  { Warning: The property DeliveryAddress_Country has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DeliveryAddress_Country := pRetVal;
end;

function TExchequerTransaction.Get_DeliveryAddressPostCode: WideString;
begin
    Result := DefaultInterface.DeliveryAddressPostCode;
end;

procedure TExchequerTransaction.Set_DeliveryAddressPostCode(const pRetVal: WideString);
  { Warning: The property DeliveryAddressPostCode has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DeliveryAddressPostCode := pRetVal;
end;

function TExchequerTransaction.Get_BillingAddress1: WideString;
begin
    Result := DefaultInterface.BillingAddress1;
end;

procedure TExchequerTransaction.Set_BillingAddress1(const pRetVal: WideString);
  { Warning: The property BillingAddress1 has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BillingAddress1 := pRetVal;
end;

function TExchequerTransaction.Get_BillingAddress2: WideString;
begin
    Result := DefaultInterface.BillingAddress2;
end;

procedure TExchequerTransaction.Set_BillingAddress2(const pRetVal: WideString);
  { Warning: The property BillingAddress2 has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BillingAddress2 := pRetVal;
end;

function TExchequerTransaction.Get_BillingAddress3_Town: WideString;
begin
    Result := DefaultInterface.BillingAddress3_Town;
end;

procedure TExchequerTransaction.Set_BillingAddress3_Town(const pRetVal: WideString);
  { Warning: The property BillingAddress3_Town has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BillingAddress3_Town := pRetVal;
end;

function TExchequerTransaction.Get_BillingAddress4_County: WideString;
begin
    Result := DefaultInterface.BillingAddress4_County;
end;

procedure TExchequerTransaction.Set_BillingAddress4_County(const pRetVal: WideString);
  { Warning: The property BillingAddress4_County has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BillingAddress4_County := pRetVal;
end;

function TExchequerTransaction.Get_BillingAddress_Country: WideString;
begin
    Result := DefaultInterface.BillingAddress_Country;
end;

procedure TExchequerTransaction.Set_BillingAddress_Country(const pRetVal: WideString);
  { Warning: The property BillingAddress_Country has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BillingAddress_Country := pRetVal;
end;

function TExchequerTransaction.Get_BillingAddressPostCode: WideString;
begin
    Result := DefaultInterface.BillingAddressPostCode;
end;

procedure TExchequerTransaction.Set_BillingAddressPostCode(const pRetVal: WideString);
  { Warning: The property BillingAddressPostCode has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BillingAddressPostCode := pRetVal;
end;

function TExchequerTransaction.Get_PaymentType: PaymentAction;
begin
    Result := DefaultInterface.PaymentType;
end;

procedure TExchequerTransaction.Set_PaymentType(pRetVal: PaymentAction);
begin
  Exit;
end;

function TExchequerTransaction.Get_FullAmount: WordBool;
begin
    Result := DefaultInterface.FullAmount;
end;

procedure TExchequerTransaction.Set_FullAmount(pRetVal: WordBool);
begin
  Exit;
end;

function TExchequerTransaction.Get_CurrencySymbol: WideString;
begin
    Result := DefaultInterface.CurrencySymbol;
end;

procedure TExchequerTransaction.Set_CurrencySymbol(const pRetVal: WideString);
  { Warning: The property CurrencySymbol has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.CurrencySymbol := pRetVal;
end;

function TExchequerTransaction.Get_CurrencyCode: Integer;
begin
    Result := DefaultInterface.CurrencyCode;
end;

procedure TExchequerTransaction.Set_CurrencyCode(pRetVal: Integer);
begin
  Exit;
end;

function TExchequerTransaction.Get_NetTotal: Double;
begin
    Result := DefaultInterface.NetTotal;
end;

procedure TExchequerTransaction.Set_NetTotal(pRetVal: Double);
begin
  Exit;
end;

function TExchequerTransaction.Get_VATTotal: Double;
begin
    Result := DefaultInterface.VATTotal;
end;

procedure TExchequerTransaction.Set_VATTotal(pRetVal: Double);
begin
  Exit;
end;

function TExchequerTransaction.Get_GrossTotal: Double;
begin
    Result := DefaultInterface.GrossTotal;
end;

procedure TExchequerTransaction.Set_GrossTotal(pRetVal: Double);
begin
  Exit;
end;

function TExchequerTransaction.Get_PaymentReference: WideString;
begin
    Result := DefaultInterface.PaymentReference;
end;

procedure TExchequerTransaction.Set_PaymentReference(const pRetVal: WideString);
  { Warning: The property PaymentReference has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.PaymentReference := pRetVal;
end;

function TExchequerTransaction.Get_DefaultPaymentProvider: WideString;
begin
    Result := DefaultInterface.DefaultPaymentProvider;
end;

procedure TExchequerTransaction.Set_DefaultPaymentProvider(const pRetVal: WideString);
  { Warning: The property DefaultPaymentProvider has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultPaymentProvider := pRetVal;
end;

function TExchequerTransaction.Get_DefaultMerchantID: WideString;
begin
    Result := DefaultInterface.DefaultMerchantID;
end;

procedure TExchequerTransaction.Set_DefaultMerchantID(const pRetVal: WideString);
  { Warning: The property DefaultMerchantID has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultMerchantID := pRetVal;
end;

function TExchequerTransaction.Get_AuthenticationGUID: WideString;
begin
    Result := DefaultInterface.AuthenticationGUID;
end;

procedure TExchequerTransaction.Set_AuthenticationGUID(const pRetVal: WideString);
  { Warning: The property AuthenticationGUID has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.AuthenticationGUID := pRetVal;
end;

procedure TExchequerTransaction.AddLine(const line: ExchequerPaymentGateway_ITransactionLine);
begin
  DefaultInterface.AddLine(line);
end;

function TExchequerTransaction.GetLines: PSafeArray;
begin
  Result := DefaultInterface.GetLines;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TExchequerTransactionProperties.Create(AServer: TExchequerTransaction);
begin
  inherited Create;
  FServer := AServer;
end;

function TExchequerTransactionProperties.GetDefaultInterface: IExchequerTransaction;
begin
  Result := FServer.DefaultInterface;
end;

function TExchequerTransactionProperties.Get_ExchequerCompanyCode: WideString;
begin
    Result := DefaultInterface.ExchequerCompanyCode;
end;

procedure TExchequerTransactionProperties.Set_ExchequerCompanyCode(const pRetVal: WideString);
  { Warning: The property ExchequerCompanyCode has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ExchequerCompanyCode := pRetVal;
end;

function TExchequerTransactionProperties.Get_SalesOrderReference: WideString;
begin
    Result := DefaultInterface.SalesOrderReference;
end;

procedure TExchequerTransactionProperties.Set_SalesOrderReference(const pRetVal: WideString);
  { Warning: The property SalesOrderReference has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.SalesOrderReference := pRetVal;
end;

function TExchequerTransactionProperties.Get_DescendentTransactionReference: WideString;
begin
    Result := DefaultInterface.DescendentTransactionReference;
end;

procedure TExchequerTransactionProperties.Set_DescendentTransactionReference(const pRetVal: WideString);
  { Warning: The property DescendentTransactionReference has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DescendentTransactionReference := pRetVal;
end;

function TExchequerTransactionProperties.Get_ContactName: WideString;
begin
    Result := DefaultInterface.ContactName;
end;

procedure TExchequerTransactionProperties.Set_ContactName(const pRetVal: WideString);
  { Warning: The property ContactName has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ContactName := pRetVal;
end;

function TExchequerTransactionProperties.Get_ContactPhone: WideString;
begin
    Result := DefaultInterface.ContactPhone;
end;

procedure TExchequerTransactionProperties.Set_ContactPhone(const pRetVal: WideString);
  { Warning: The property ContactPhone has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ContactPhone := pRetVal;
end;

function TExchequerTransactionProperties.Get_ContactEmail: WideString;
begin
    Result := DefaultInterface.ContactEmail;
end;

procedure TExchequerTransactionProperties.Set_ContactEmail(const pRetVal: WideString);
  { Warning: The property ContactEmail has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ContactEmail := pRetVal;
end;

function TExchequerTransactionProperties.Get_DeliveryAddress1: WideString;
begin
    Result := DefaultInterface.DeliveryAddress1;
end;

procedure TExchequerTransactionProperties.Set_DeliveryAddress1(const pRetVal: WideString);
  { Warning: The property DeliveryAddress1 has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DeliveryAddress1 := pRetVal;
end;

function TExchequerTransactionProperties.Get_DeliveryAddress2: WideString;
begin
    Result := DefaultInterface.DeliveryAddress2;
end;

procedure TExchequerTransactionProperties.Set_DeliveryAddress2(const pRetVal: WideString);
  { Warning: The property DeliveryAddress2 has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DeliveryAddress2 := pRetVal;
end;

function TExchequerTransactionProperties.Get_DeliveryAddress3_Town: WideString;
begin
    Result := DefaultInterface.DeliveryAddress3_Town;
end;

procedure TExchequerTransactionProperties.Set_DeliveryAddress3_Town(const pRetVal: WideString);
  { Warning: The property DeliveryAddress3_Town has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DeliveryAddress3_Town := pRetVal;
end;

function TExchequerTransactionProperties.Get_DeliveryAddress4_County: WideString;
begin
    Result := DefaultInterface.DeliveryAddress4_County;
end;

procedure TExchequerTransactionProperties.Set_DeliveryAddress4_County(const pRetVal: WideString);
  { Warning: The property DeliveryAddress4_County has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DeliveryAddress4_County := pRetVal;
end;

function TExchequerTransactionProperties.Get_DeliveryAddress_Country: WideString;
begin
    Result := DefaultInterface.DeliveryAddress_Country;
end;

procedure TExchequerTransactionProperties.Set_DeliveryAddress_Country(const pRetVal: WideString);
  { Warning: The property DeliveryAddress_Country has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DeliveryAddress_Country := pRetVal;
end;

function TExchequerTransactionProperties.Get_DeliveryAddressPostCode: WideString;
begin
    Result := DefaultInterface.DeliveryAddressPostCode;
end;

procedure TExchequerTransactionProperties.Set_DeliveryAddressPostCode(const pRetVal: WideString);
  { Warning: The property DeliveryAddressPostCode has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DeliveryAddressPostCode := pRetVal;
end;

function TExchequerTransactionProperties.Get_BillingAddress1: WideString;
begin
    Result := DefaultInterface.BillingAddress1;
end;

procedure TExchequerTransactionProperties.Set_BillingAddress1(const pRetVal: WideString);
  { Warning: The property BillingAddress1 has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BillingAddress1 := pRetVal;
end;

function TExchequerTransactionProperties.Get_BillingAddress2: WideString;
begin
    Result := DefaultInterface.BillingAddress2;
end;

procedure TExchequerTransactionProperties.Set_BillingAddress2(const pRetVal: WideString);
  { Warning: The property BillingAddress2 has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BillingAddress2 := pRetVal;
end;

function TExchequerTransactionProperties.Get_BillingAddress3_Town: WideString;
begin
    Result := DefaultInterface.BillingAddress3_Town;
end;

procedure TExchequerTransactionProperties.Set_BillingAddress3_Town(const pRetVal: WideString);
  { Warning: The property BillingAddress3_Town has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BillingAddress3_Town := pRetVal;
end;

function TExchequerTransactionProperties.Get_BillingAddress4_County: WideString;
begin
    Result := DefaultInterface.BillingAddress4_County;
end;

procedure TExchequerTransactionProperties.Set_BillingAddress4_County(const pRetVal: WideString);
  { Warning: The property BillingAddress4_County has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BillingAddress4_County := pRetVal;
end;

function TExchequerTransactionProperties.Get_BillingAddress_Country: WideString;
begin
    Result := DefaultInterface.BillingAddress_Country;
end;

procedure TExchequerTransactionProperties.Set_BillingAddress_Country(const pRetVal: WideString);
  { Warning: The property BillingAddress_Country has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BillingAddress_Country := pRetVal;
end;

function TExchequerTransactionProperties.Get_BillingAddressPostCode: WideString;
begin
    Result := DefaultInterface.BillingAddressPostCode;
end;

procedure TExchequerTransactionProperties.Set_BillingAddressPostCode(const pRetVal: WideString);
  { Warning: The property BillingAddressPostCode has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BillingAddressPostCode := pRetVal;
end;

function TExchequerTransactionProperties.Get_PaymentType: PaymentAction;
begin
    Result := DefaultInterface.PaymentType;
end;

procedure TExchequerTransactionProperties.Set_PaymentType(pRetVal: PaymentAction);
begin
  Exit;
end;

function TExchequerTransactionProperties.Get_FullAmount: WordBool;
begin
    Result := DefaultInterface.FullAmount;
end;

procedure TExchequerTransactionProperties.Set_FullAmount(pRetVal: WordBool);
begin
  Exit;
end;

function TExchequerTransactionProperties.Get_CurrencySymbol: WideString;
begin
    Result := DefaultInterface.CurrencySymbol;
end;

procedure TExchequerTransactionProperties.Set_CurrencySymbol(const pRetVal: WideString);
  { Warning: The property CurrencySymbol has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.CurrencySymbol := pRetVal;
end;

function TExchequerTransactionProperties.Get_CurrencyCode: Integer;
begin
    Result := DefaultInterface.CurrencyCode;
end;

procedure TExchequerTransactionProperties.Set_CurrencyCode(pRetVal: Integer);
begin
  Exit;
end;

function TExchequerTransactionProperties.Get_NetTotal: Double;
begin
    Result := DefaultInterface.NetTotal;
end;

procedure TExchequerTransactionProperties.Set_NetTotal(pRetVal: Double);
begin
  Exit;
end;

function TExchequerTransactionProperties.Get_VATTotal: Double;
begin
    Result := DefaultInterface.VATTotal;
end;

procedure TExchequerTransactionProperties.Set_VATTotal(pRetVal: Double);
begin
  Exit;
end;

function TExchequerTransactionProperties.Get_GrossTotal: Double;
begin
    Result := DefaultInterface.GrossTotal;
end;

procedure TExchequerTransactionProperties.Set_GrossTotal(pRetVal: Double);
begin
  Exit;
end;

function TExchequerTransactionProperties.Get_PaymentReference: WideString;
begin
    Result := DefaultInterface.PaymentReference;
end;

procedure TExchequerTransactionProperties.Set_PaymentReference(const pRetVal: WideString);
  { Warning: The property PaymentReference has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.PaymentReference := pRetVal;
end;

function TExchequerTransactionProperties.Get_DefaultPaymentProvider: WideString;
begin
    Result := DefaultInterface.DefaultPaymentProvider;
end;

procedure TExchequerTransactionProperties.Set_DefaultPaymentProvider(const pRetVal: WideString);
  { Warning: The property DefaultPaymentProvider has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultPaymentProvider := pRetVal;
end;

function TExchequerTransactionProperties.Get_DefaultMerchantID: WideString;
begin
    Result := DefaultInterface.DefaultMerchantID;
end;

procedure TExchequerTransactionProperties.Set_DefaultMerchantID(const pRetVal: WideString);
  { Warning: The property DefaultMerchantID has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultMerchantID := pRetVal;
end;

function TExchequerTransactionProperties.Get_AuthenticationGUID: WideString;
begin
    Result := DefaultInterface.AuthenticationGUID;
end;

procedure TExchequerTransactionProperties.Set_AuthenticationGUID(const pRetVal: WideString);
  { Warning: The property AuthenticationGUID has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.AuthenticationGUID := pRetVal;
end;

{$ENDIF}

class function CoPaymentDefaultInformation.Create: IPaymentDefaultInformation;
begin
  Result := CreateComObject(CLASS_PaymentDefaultInformation) as IPaymentDefaultInformation;
end;

class function CoPaymentDefaultInformation.CreateRemote(const MachineName: string): IPaymentDefaultInformation;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PaymentDefaultInformation) as IPaymentDefaultInformation;
end;

procedure TPaymentDefaultInformation.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{8EA84189-D7BA-4D3A-91C1-FC8147385FCD}';
    IntfIID:   '{522B9B05-D665-4340-8818-70547275898A}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TPaymentDefaultInformation.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IPaymentDefaultInformation;
  end;
end;

procedure TPaymentDefaultInformation.ConnectTo(svrIntf: IPaymentDefaultInformation);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TPaymentDefaultInformation.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TPaymentDefaultInformation.GetDefaultInterface: IPaymentDefaultInformation;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TPaymentDefaultInformation.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TPaymentDefaultInformationProperties.Create(Self);
{$ENDIF}
end;

destructor TPaymentDefaultInformation.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TPaymentDefaultInformation.GetServerProperties: TPaymentDefaultInformationProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TPaymentDefaultInformation.Get_Result: WordBool;
begin
    Result := DefaultInterface.Result;
end;

procedure TPaymentDefaultInformation.Set_Result(Param1: WordBool);
begin
  Exit;
end;

function TPaymentDefaultInformation.Get_DefaultPaymentProvider: WideString;
begin
    Result := DefaultInterface.DefaultPaymentProvider;
end;

procedure TPaymentDefaultInformation.Set_DefaultPaymentProvider(const Param1: WideString);
  { Warning: The property DefaultPaymentProvider has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultPaymentProvider := Param1;
end;

function TPaymentDefaultInformation.Get_DefaultMerchantID: WideString;
begin
    Result := DefaultInterface.DefaultMerchantID;
end;

procedure TPaymentDefaultInformation.Set_DefaultMerchantID(const Param1: WideString);
  { Warning: The property DefaultMerchantID has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultMerchantID := Param1;
end;

function TPaymentDefaultInformation.Get_DefaultGLCode: Smallint;
begin
    Result := DefaultInterface.DefaultGLCode;
end;

procedure TPaymentDefaultInformation.Set_DefaultGLCode(Param1: Smallint);
begin
  Exit;
end;

function TPaymentDefaultInformation.Get_DefaultCostCentre: WideString;
begin
    Result := DefaultInterface.DefaultCostCentre;
end;

procedure TPaymentDefaultInformation.Set_DefaultCostCentre(const Param1: WideString);
  { Warning: The property DefaultCostCentre has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultCostCentre := Param1;
end;

function TPaymentDefaultInformation.Get_DefaultDepartment: WideString;
begin
    Result := DefaultInterface.DefaultDepartment;
end;

procedure TPaymentDefaultInformation.Set_DefaultDepartment(const Param1: WideString);
  { Warning: The property DefaultDepartment has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultDepartment := Param1;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TPaymentDefaultInformationProperties.Create(AServer: TPaymentDefaultInformation);
begin
  inherited Create;
  FServer := AServer;
end;

function TPaymentDefaultInformationProperties.GetDefaultInterface: IPaymentDefaultInformation;
begin
  Result := FServer.DefaultInterface;
end;

function TPaymentDefaultInformationProperties.Get_Result: WordBool;
begin
    Result := DefaultInterface.Result;
end;

procedure TPaymentDefaultInformationProperties.Set_Result(Param1: WordBool);
begin
  Exit;
end;

function TPaymentDefaultInformationProperties.Get_DefaultPaymentProvider: WideString;
begin
    Result := DefaultInterface.DefaultPaymentProvider;
end;

procedure TPaymentDefaultInformationProperties.Set_DefaultPaymentProvider(const Param1: WideString);
  { Warning: The property DefaultPaymentProvider has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultPaymentProvider := Param1;
end;

function TPaymentDefaultInformationProperties.Get_DefaultMerchantID: WideString;
begin
    Result := DefaultInterface.DefaultMerchantID;
end;

procedure TPaymentDefaultInformationProperties.Set_DefaultMerchantID(const Param1: WideString);
  { Warning: The property DefaultMerchantID has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultMerchantID := Param1;
end;

function TPaymentDefaultInformationProperties.Get_DefaultGLCode: Smallint;
begin
    Result := DefaultInterface.DefaultGLCode;
end;

procedure TPaymentDefaultInformationProperties.Set_DefaultGLCode(Param1: Smallint);
begin
  Exit;
end;

function TPaymentDefaultInformationProperties.Get_DefaultCostCentre: WideString;
begin
    Result := DefaultInterface.DefaultCostCentre;
end;

procedure TPaymentDefaultInformationProperties.Set_DefaultCostCentre(const Param1: WideString);
  { Warning: The property DefaultCostCentre has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultCostCentre := Param1;
end;

function TPaymentDefaultInformationProperties.Get_DefaultDepartment: WideString;
begin
    Result := DefaultInterface.DefaultDepartment;
end;

procedure TPaymentDefaultInformationProperties.Set_DefaultDepartment(const Param1: WideString);
  { Warning: The property DefaultDepartment has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultDepartment := Param1;
end;

{$ENDIF}

class function CoPaymentGatewayResponse.Create: IPaymentGatewayResponse;
begin
  Result := CreateComObject(CLASS_PaymentGatewayResponse) as IPaymentGatewayResponse;
end;

class function CoPaymentGatewayResponse.CreateRemote(const MachineName: string): IPaymentGatewayResponse;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PaymentGatewayResponse) as IPaymentGatewayResponse;
end;

procedure TPaymentGatewayResponse.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{1304F2F5-1C2F-4916-BB90-232F9C43845E}';
    IntfIID:   '{C523B87C-F41E-4DD1-A2D0-B482C1424995}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TPaymentGatewayResponse.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IPaymentGatewayResponse;
  end;
end;

procedure TPaymentGatewayResponse.ConnectTo(svrIntf: IPaymentGatewayResponse);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TPaymentGatewayResponse.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TPaymentGatewayResponse.GetDefaultInterface: IPaymentGatewayResponse;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TPaymentGatewayResponse.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TPaymentGatewayResponseProperties.Create(Self);
{$ENDIF}
end;

destructor TPaymentGatewayResponse.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TPaymentGatewayResponse.GetServerProperties: TPaymentGatewayResponseProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TPaymentGatewayResponse.Get_SalesOrderReference: WideString;
begin
    Result := DefaultInterface.SalesOrderReference;
end;

procedure TPaymentGatewayResponse.Set_SalesOrderReference(const pRetVal: WideString);
  { Warning: The property SalesOrderReference has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.SalesOrderReference := pRetVal;
end;

function TPaymentGatewayResponse.Get_DescendentTransactionReference: WideString;
begin
    Result := DefaultInterface.DescendentTransactionReference;
end;

procedure TPaymentGatewayResponse.Set_DescendentTransactionReference(const pRetVal: WideString);
  { Warning: The property DescendentTransactionReference has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DescendentTransactionReference := pRetVal;
end;

function TPaymentGatewayResponse.Get_authTicket: WideString;
begin
    Result := DefaultInterface.authTicket;
end;

procedure TPaymentGatewayResponse.Set_authTicket(const pRetVal: WideString);
  { Warning: The property authTicket has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.authTicket := pRetVal;
end;

function TPaymentGatewayResponse.Get_gatewayTransactionGuid: WideString;
begin
    Result := DefaultInterface.gatewayTransactionGuid;
end;

procedure TPaymentGatewayResponse.Set_gatewayTransactionGuid(const pRetVal: WideString);
  { Warning: The property gatewayTransactionGuid has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.gatewayTransactionGuid := pRetVal;
end;

function TPaymentGatewayResponse.Get_GatewayStatusId: Integer;
begin
    Result := DefaultInterface.GatewayStatusId;
end;

procedure TPaymentGatewayResponse.Set_GatewayStatusId(pRetVal: Integer);
begin
  Exit;
end;

function TPaymentGatewayResponse.Get_GatewayTransactionID: WideString;
begin
    Result := DefaultInterface.GatewayTransactionID;
end;

procedure TPaymentGatewayResponse.Set_GatewayTransactionID(const pRetVal: WideString);
  { Warning: The property GatewayTransactionID has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.GatewayTransactionID := pRetVal;
end;

function TPaymentGatewayResponse.Get_GatewayVendorTxCode: WideString;
begin
    Result := DefaultInterface.GatewayVendorTxCode;
end;

procedure TPaymentGatewayResponse.Set_GatewayVendorTxCode(const pRetVal: WideString);
  { Warning: The property GatewayVendorTxCode has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.GatewayVendorTxCode := pRetVal;
end;

function TPaymentGatewayResponse.Get_ServiceResponse: WideString;
begin
    Result := DefaultInterface.ServiceResponse;
end;

procedure TPaymentGatewayResponse.Set_ServiceResponse(const pRetVal: WideString);
  { Warning: The property ServiceResponse has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ServiceResponse := pRetVal;
end;

function TPaymentGatewayResponse.Get_IsError: WordBool;
begin
    Result := DefaultInterface.IsError;
end;

procedure TPaymentGatewayResponse.Set_IsError(pRetVal: WordBool);
begin
  Exit;
end;

function TPaymentGatewayResponse.Get_GatewayVendorCardType: WideString;
begin
    Result := DefaultInterface.GatewayVendorCardType;
end;

procedure TPaymentGatewayResponse.Set_GatewayVendorCardType(const pRetVal: WideString);
  { Warning: The property GatewayVendorCardType has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.GatewayVendorCardType := pRetVal;
end;

function TPaymentGatewayResponse.Get_GatewayVendorCardLast4Digits: WideString;
begin
    Result := DefaultInterface.GatewayVendorCardLast4Digits;
end;

procedure TPaymentGatewayResponse.Set_GatewayVendorCardLast4Digits(const pRetVal: WideString);
  { Warning: The property GatewayVendorCardLast4Digits has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.GatewayVendorCardLast4Digits := pRetVal;
end;

function TPaymentGatewayResponse.Get_GatewayVendorCardExpiryDate: WideString;
begin
    Result := DefaultInterface.GatewayVendorCardExpiryDate;
end;

procedure TPaymentGatewayResponse.Set_GatewayVendorCardExpiryDate(const pRetVal: WideString);
  { Warning: The property GatewayVendorCardExpiryDate has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.GatewayVendorCardExpiryDate := pRetVal;
end;

function TPaymentGatewayResponse.Get_AuthorizationNumber: WideString;
begin
    Result := DefaultInterface.AuthorizationNumber;
end;

procedure TPaymentGatewayResponse.Set_AuthorizationNumber(const pRetVal: WideString);
  { Warning: The property AuthorizationNumber has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.AuthorizationNumber := pRetVal;
end;

function TPaymentGatewayResponse.Get_GUIDReference: WideString;
begin
    Result := DefaultInterface.GUIDReference;
end;

procedure TPaymentGatewayResponse.Set_GUIDReference(const pRetVal: WideString);
  { Warning: The property GUIDReference has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.GUIDReference := pRetVal;
end;

function TPaymentGatewayResponse.Get_MultiplePayment: WordBool;
begin
    Result := DefaultInterface.MultiplePayment;
end;

procedure TPaymentGatewayResponse.Set_MultiplePayment(pRetVal: WordBool);
begin
  Exit;
end;

function TPaymentGatewayResponse.Get_TransactionValue: Double;
begin
    Result := DefaultInterface.TransactionValue;
end;

procedure TPaymentGatewayResponse.Set_TransactionValue(pRetVal: Double);
begin
  Exit;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TPaymentGatewayResponseProperties.Create(AServer: TPaymentGatewayResponse);
begin
  inherited Create;
  FServer := AServer;
end;

function TPaymentGatewayResponseProperties.GetDefaultInterface: IPaymentGatewayResponse;
begin
  Result := FServer.DefaultInterface;
end;

function TPaymentGatewayResponseProperties.Get_SalesOrderReference: WideString;
begin
    Result := DefaultInterface.SalesOrderReference;
end;

procedure TPaymentGatewayResponseProperties.Set_SalesOrderReference(const pRetVal: WideString);
  { Warning: The property SalesOrderReference has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.SalesOrderReference := pRetVal;
end;

function TPaymentGatewayResponseProperties.Get_DescendentTransactionReference: WideString;
begin
    Result := DefaultInterface.DescendentTransactionReference;
end;

procedure TPaymentGatewayResponseProperties.Set_DescendentTransactionReference(const pRetVal: WideString);
  { Warning: The property DescendentTransactionReference has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DescendentTransactionReference := pRetVal;
end;

function TPaymentGatewayResponseProperties.Get_authTicket: WideString;
begin
    Result := DefaultInterface.authTicket;
end;

procedure TPaymentGatewayResponseProperties.Set_authTicket(const pRetVal: WideString);
  { Warning: The property authTicket has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.authTicket := pRetVal;
end;

function TPaymentGatewayResponseProperties.Get_gatewayTransactionGuid: WideString;
begin
    Result := DefaultInterface.gatewayTransactionGuid;
end;

procedure TPaymentGatewayResponseProperties.Set_gatewayTransactionGuid(const pRetVal: WideString);
  { Warning: The property gatewayTransactionGuid has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.gatewayTransactionGuid := pRetVal;
end;

function TPaymentGatewayResponseProperties.Get_GatewayStatusId: Integer;
begin
    Result := DefaultInterface.GatewayStatusId;
end;

procedure TPaymentGatewayResponseProperties.Set_GatewayStatusId(pRetVal: Integer);
begin
  Exit;
end;

function TPaymentGatewayResponseProperties.Get_GatewayTransactionID: WideString;
begin
    Result := DefaultInterface.GatewayTransactionID;
end;

procedure TPaymentGatewayResponseProperties.Set_GatewayTransactionID(const pRetVal: WideString);
  { Warning: The property GatewayTransactionID has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.GatewayTransactionID := pRetVal;
end;

function TPaymentGatewayResponseProperties.Get_GatewayVendorTxCode: WideString;
begin
    Result := DefaultInterface.GatewayVendorTxCode;
end;

procedure TPaymentGatewayResponseProperties.Set_GatewayVendorTxCode(const pRetVal: WideString);
  { Warning: The property GatewayVendorTxCode has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.GatewayVendorTxCode := pRetVal;
end;

function TPaymentGatewayResponseProperties.Get_ServiceResponse: WideString;
begin
    Result := DefaultInterface.ServiceResponse;
end;

procedure TPaymentGatewayResponseProperties.Set_ServiceResponse(const pRetVal: WideString);
  { Warning: The property ServiceResponse has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ServiceResponse := pRetVal;
end;

function TPaymentGatewayResponseProperties.Get_IsError: WordBool;
begin
    Result := DefaultInterface.IsError;
end;

procedure TPaymentGatewayResponseProperties.Set_IsError(pRetVal: WordBool);
begin
  Exit;
end;

function TPaymentGatewayResponseProperties.Get_GatewayVendorCardType: WideString;
begin
    Result := DefaultInterface.GatewayVendorCardType;
end;

procedure TPaymentGatewayResponseProperties.Set_GatewayVendorCardType(const pRetVal: WideString);
  { Warning: The property GatewayVendorCardType has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.GatewayVendorCardType := pRetVal;
end;

function TPaymentGatewayResponseProperties.Get_GatewayVendorCardLast4Digits: WideString;
begin
    Result := DefaultInterface.GatewayVendorCardLast4Digits;
end;

procedure TPaymentGatewayResponseProperties.Set_GatewayVendorCardLast4Digits(const pRetVal: WideString);
  { Warning: The property GatewayVendorCardLast4Digits has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.GatewayVendorCardLast4Digits := pRetVal;
end;

function TPaymentGatewayResponseProperties.Get_GatewayVendorCardExpiryDate: WideString;
begin
    Result := DefaultInterface.GatewayVendorCardExpiryDate;
end;

procedure TPaymentGatewayResponseProperties.Set_GatewayVendorCardExpiryDate(const pRetVal: WideString);
  { Warning: The property GatewayVendorCardExpiryDate has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.GatewayVendorCardExpiryDate := pRetVal;
end;

function TPaymentGatewayResponseProperties.Get_AuthorizationNumber: WideString;
begin
    Result := DefaultInterface.AuthorizationNumber;
end;

procedure TPaymentGatewayResponseProperties.Set_AuthorizationNumber(const pRetVal: WideString);
  { Warning: The property AuthorizationNumber has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.AuthorizationNumber := pRetVal;
end;

function TPaymentGatewayResponseProperties.Get_GUIDReference: WideString;
begin
    Result := DefaultInterface.GUIDReference;
end;

procedure TPaymentGatewayResponseProperties.Set_GUIDReference(const pRetVal: WideString);
  { Warning: The property GUIDReference has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.GUIDReference := pRetVal;
end;

function TPaymentGatewayResponseProperties.Get_MultiplePayment: WordBool;
begin
    Result := DefaultInterface.MultiplePayment;
end;

procedure TPaymentGatewayResponseProperties.Set_MultiplePayment(pRetVal: WordBool);
begin
  Exit;
end;

function TPaymentGatewayResponseProperties.Get_TransactionValue: Double;
begin
    Result := DefaultInterface.TransactionValue;
end;

procedure TPaymentGatewayResponseProperties.Set_TransactionValue(pRetVal: Double);
begin
  Exit;
end;

{$ENDIF}

class function CoTransactionLine.Create: ExchequerPaymentGateway_ITransactionLine;
begin
  Result := CreateComObject(CLASS_TransactionLine) as ExchequerPaymentGateway_ITransactionLine;
end;

class function CoTransactionLine.CreateRemote(const MachineName: string): ExchequerPaymentGateway_ITransactionLine;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TransactionLine) as ExchequerPaymentGateway_ITransactionLine;
end;

procedure TTransactionLine.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{47894B99-50BA-4DB3-8F28-772A7AAC970B}';
    IntfIID:   '{6EA13381-AAAB-47AD-AE3B-971059680A2A}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTransactionLine.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ExchequerPaymentGateway_ITransactionLine;
  end;
end;

procedure TTransactionLine.ConnectTo(svrIntf: ExchequerPaymentGateway_ITransactionLine);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTransactionLine.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTransactionLine.GetDefaultInterface: ExchequerPaymentGateway_ITransactionLine;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTransactionLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTransactionLineProperties.Create(Self);
{$ENDIF}
end;

destructor TTransactionLine.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTransactionLine.GetServerProperties: TTransactionLineProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TTransactionLine.Get_Description: WideString;
begin
    Result := DefaultInterface.Description;
end;

procedure TTransactionLine.Set_Description(const pRetVal: WideString);
  { Warning: The property Description has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Description := pRetVal;
end;

function TTransactionLine.Get_StockCode: WideString;
begin
    Result := DefaultInterface.StockCode;
end;

procedure TTransactionLine.Set_StockCode(const pRetVal: WideString);
  { Warning: The property StockCode has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.StockCode := pRetVal;
end;

function TTransactionLine.Get_VATCode: WideString;
begin
    Result := DefaultInterface.VATCode;
end;

procedure TTransactionLine.Set_VATCode(const pRetVal: WideString);
  { Warning: The property VATCode has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.VATCode := pRetVal;
end;

function TTransactionLine.Get_Quantity: Double;
begin
    Result := DefaultInterface.Quantity;
end;

procedure TTransactionLine.Set_Quantity(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLine.Get_VATMultiplier: Double;
begin
    Result := DefaultInterface.VATMultiplier;
end;

procedure TTransactionLine.Set_VATMultiplier(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLine.Get_TotalNetValue: Double;
begin
    Result := DefaultInterface.TotalNetValue;
end;

procedure TTransactionLine.Set_TotalNetValue(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLine.Get_TotalVATValue: Double;
begin
    Result := DefaultInterface.TotalVATValue;
end;

procedure TTransactionLine.Set_TotalVATValue(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLine.Get_TotalGrossValue: Double;
begin
    Result := DefaultInterface.TotalGrossValue;
end;

procedure TTransactionLine.Set_TotalGrossValue(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLine.Get_UnitPrice: Double;
begin
    Result := DefaultInterface.UnitPrice;
end;

procedure TTransactionLine.Set_UnitPrice(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLine.Get_UnitDiscount: Double;
begin
    Result := DefaultInterface.UnitDiscount;
end;

procedure TTransactionLine.Set_UnitDiscount(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLine.Get_TotalDiscount: Double;
begin
    Result := DefaultInterface.TotalDiscount;
end;

procedure TTransactionLine.Set_TotalDiscount(pRetVal: Double);
begin
  Exit;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTransactionLineProperties.Create(AServer: TTransactionLine);
begin
  inherited Create;
  FServer := AServer;
end;

function TTransactionLineProperties.GetDefaultInterface: ExchequerPaymentGateway_ITransactionLine;
begin
  Result := FServer.DefaultInterface;
end;

function TTransactionLineProperties.Get_Description: WideString;
begin
    Result := DefaultInterface.Description;
end;

procedure TTransactionLineProperties.Set_Description(const pRetVal: WideString);
  { Warning: The property Description has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Description := pRetVal;
end;

function TTransactionLineProperties.Get_StockCode: WideString;
begin
    Result := DefaultInterface.StockCode;
end;

procedure TTransactionLineProperties.Set_StockCode(const pRetVal: WideString);
  { Warning: The property StockCode has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.StockCode := pRetVal;
end;

function TTransactionLineProperties.Get_VATCode: WideString;
begin
    Result := DefaultInterface.VATCode;
end;

procedure TTransactionLineProperties.Set_VATCode(const pRetVal: WideString);
  { Warning: The property VATCode has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.VATCode := pRetVal;
end;

function TTransactionLineProperties.Get_Quantity: Double;
begin
    Result := DefaultInterface.Quantity;
end;

procedure TTransactionLineProperties.Set_Quantity(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLineProperties.Get_VATMultiplier: Double;
begin
    Result := DefaultInterface.VATMultiplier;
end;

procedure TTransactionLineProperties.Set_VATMultiplier(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLineProperties.Get_TotalNetValue: Double;
begin
    Result := DefaultInterface.TotalNetValue;
end;

procedure TTransactionLineProperties.Set_TotalNetValue(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLineProperties.Get_TotalVATValue: Double;
begin
    Result := DefaultInterface.TotalVATValue;
end;

procedure TTransactionLineProperties.Set_TotalVATValue(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLineProperties.Get_TotalGrossValue: Double;
begin
    Result := DefaultInterface.TotalGrossValue;
end;

procedure TTransactionLineProperties.Set_TotalGrossValue(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLineProperties.Get_UnitPrice: Double;
begin
    Result := DefaultInterface.UnitPrice;
end;

procedure TTransactionLineProperties.Set_UnitPrice(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLineProperties.Get_UnitDiscount: Double;
begin
    Result := DefaultInterface.UnitDiscount;
end;

procedure TTransactionLineProperties.Set_UnitDiscount(pRetVal: Double);
begin
  Exit;
end;

function TTransactionLineProperties.Get_TotalDiscount: Double;
begin
    Result := DefaultInterface.TotalDiscount;
end;

procedure TTransactionLineProperties.Set_TotalDiscount(pRetVal: Double);
begin
  Exit;
end;

{$ENDIF}

class function CoMCMCompany.Create: _MCMCompany;
begin
  Result := CreateComObject(CLASS_MCMCompany) as _MCMCompany;
end;

class function CoMCMCompany.CreateRemote(const MachineName: string): _MCMCompany;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MCMCompany) as _MCMCompany;
end;

procedure TMCMCompany.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2568CC23-BFE8-3731-8B3F-8AB2D50812B4}';
    IntfIID:   '{AE3366B5-8926-3251-9CEF-C5E862873423}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMCMCompany.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _MCMCompany;
  end;
end;

procedure TMCMCompany.ConnectTo(svrIntf: _MCMCompany);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMCMCompany.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMCMCompany.GetDefaultInterface: _MCMCompany;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMCMCompany.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMCMCompanyProperties.Create(Self);
{$ENDIF}
end;

destructor TMCMCompany.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMCMCompany.GetServerProperties: TMCMCompanyProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMCMCompanyProperties.Create(AServer: TMCMCompany);
begin
  inherited Create;
  FServer := AServer;
end;

function TMCMCompanyProperties.GetDefaultInterface: _MCMCompany;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoGLCodeListItem.Create: _GLCodeListItem;
begin
  Result := CreateComObject(CLASS_GLCodeListItem) as _GLCodeListItem;
end;

class function CoGLCodeListItem.CreateRemote(const MachineName: string): _GLCodeListItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GLCodeListItem) as _GLCodeListItem;
end;

class function CoCostCentreDeptListItem.Create: _CostCentreDeptListItem;
begin
  Result := CreateComObject(CLASS_CostCentreDeptListItem) as _CostCentreDeptListItem;
end;

class function CoCostCentreDeptListItem.CreateRemote(const MachineName: string): _CostCentreDeptListItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CostCentreDeptListItem) as _CostCentreDeptListItem;
end;

class function CoSourceConfig.Create: _SourceConfig;
begin
  Result := CreateComObject(CLASS_SourceConfig) as _SourceConfig;
end;

class function CoSourceConfig.CreateRemote(const MachineName: string): _SourceConfig;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SourceConfig) as _SourceConfig;
end;

procedure TSourceConfig.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{5007476E-EC52-3172-8ADC-2AF794F23DFB}';
    IntfIID:   '{06A02446-A713-38A8-ACD1-35FEBCD49AC3}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSourceConfig.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _SourceConfig;
  end;
end;

procedure TSourceConfig.ConnectTo(svrIntf: _SourceConfig);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSourceConfig.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSourceConfig.GetDefaultInterface: _SourceConfig;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TSourceConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSourceConfigProperties.Create(Self);
{$ENDIF}
end;

destructor TSourceConfig.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSourceConfig.GetServerProperties: TSourceConfigProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSourceConfigProperties.Create(AServer: TSourceConfig);
begin
  inherited Create;
  FServer := AServer;
end;

function TSourceConfigProperties.GetDefaultInterface: _SourceConfig;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoCurrencyCodes.Create: _CurrencyCodes;
begin
  Result := CreateComObject(CLASS_CurrencyCodes) as _CurrencyCodes;
end;

class function CoCurrencyCodes.CreateRemote(const MachineName: string): _CurrencyCodes;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CurrencyCodes) as _CurrencyCodes;
end;

procedure TCurrencyCodes.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{481E9F13-4B54-3BE9-901F-AB6981015260}';
    IntfIID:   '{2B7D8A65-6DD6-328A-8E1E-1F7E802DA7A2}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCurrencyCodes.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _CurrencyCodes;
  end;
end;

procedure TCurrencyCodes.ConnectTo(svrIntf: _CurrencyCodes);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCurrencyCodes.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCurrencyCodes.GetDefaultInterface: _CurrencyCodes;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TCurrencyCodes.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TCurrencyCodesProperties.Create(Self);
{$ENDIF}
end;

destructor TCurrencyCodes.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TCurrencyCodes.GetServerProperties: TCurrencyCodesProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TCurrencyCodesProperties.Create(AServer: TCurrencyCodes);
begin
  inherited Create;
  FServer := AServer;
end;

function TCurrencyCodesProperties.GetDefaultInterface: _CurrencyCodes;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoCompanyConfig.Create: _CompanyConfig;
begin
  Result := CreateComObject(CLASS_CompanyConfig) as _CompanyConfig;
end;

class function CoCompanyConfig.CreateRemote(const MachineName: string): _CompanyConfig;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CompanyConfig) as _CompanyConfig;
end;

procedure TCompanyConfig.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{4CD45A53-21C9-3776-B1F8-389062213A29}';
    IntfIID:   '{AAEFC21B-C566-325D-AFF3-91B09E560AEA}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCompanyConfig.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _CompanyConfig;
  end;
end;

procedure TCompanyConfig.ConnectTo(svrIntf: _CompanyConfig);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCompanyConfig.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCompanyConfig.GetDefaultInterface: _CompanyConfig;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TCompanyConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TCompanyConfigProperties.Create(Self);
{$ENDIF}
end;

destructor TCompanyConfig.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TCompanyConfig.GetServerProperties: TCompanyConfigProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TCompanyConfigProperties.Create(AServer: TCompanyConfig);
begin
  inherited Create;
  FServer := AServer;
end;

function TCompanyConfigProperties.GetDefaultInterface: _CompanyConfig;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoSiteConfig.Create: _SiteConfig;
begin
  Result := CreateComObject(CLASS_SiteConfig) as _SiteConfig;
end;

class function CoSiteConfig.CreateRemote(const MachineName: string): _SiteConfig;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SiteConfig) as _SiteConfig;
end;

class function CoDebugView.Create: _DebugView;
begin
  Result := CreateComObject(CLASS_DebugView) as _DebugView;
end;

class function CoDebugView.CreateRemote(const MachineName: string): _DebugView;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DebugView) as _DebugView;
end;

procedure TDebugView.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{0F0832E7-9C45-374B-9F9B-342D3066D6F4}';
    IntfIID:   '{CFAB91A6-FC2B-32FE-828F-CF6C87523C24}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDebugView.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _DebugView;
  end;
end;

procedure TDebugView.ConnectTo(svrIntf: _DebugView);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDebugView.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDebugView.GetDefaultInterface: _DebugView;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TDebugView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDebugViewProperties.Create(Self);
{$ENDIF}
end;

destructor TDebugView.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDebugView.GetServerProperties: TDebugViewProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDebugViewProperties.Create(AServer: TDebugView);
begin
  inherited Create;
  FServer := AServer;
end;

function TDebugViewProperties.GetDefaultInterface: _DebugView;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoTextLock.Create: _TextLock;
begin
  Result := CreateComObject(CLASS_TextLock) as _TextLock;
end;

class function CoTextLock.CreateRemote(const MachineName: string): _TextLock;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TextLock) as _TextLock;
end;

class function CoDataRestorer.Create: _DataRestorer;
begin
  Result := CreateComObject(CLASS_DataRestorer) as _DataRestorer;
end;

class function CoDataRestorer.CreateRemote(const MachineName: string): _DataRestorer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DataRestorer) as _DataRestorer;
end;

class function CoRecoveryCustomDataLine.Create: _RecoveryCustomDataLine;
begin
  Result := CreateComObject(CLASS_RecoveryCustomDataLine) as _RecoveryCustomDataLine;
end;

class function CoRecoveryCustomDataLine.CreateRemote(const MachineName: string): _RecoveryCustomDataLine;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RecoveryCustomDataLine) as _RecoveryCustomDataLine;
end;

procedure TRecoveryCustomDataLine.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{AF176E1A-D844-3B73-9CB3-CB3FD36BFD25}';
    IntfIID:   '{C6D9F60C-CCE1-3A4F-9509-E6FD128062CE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TRecoveryCustomDataLine.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _RecoveryCustomDataLine;
  end;
end;

procedure TRecoveryCustomDataLine.ConnectTo(svrIntf: _RecoveryCustomDataLine);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TRecoveryCustomDataLine.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TRecoveryCustomDataLine.GetDefaultInterface: _RecoveryCustomDataLine;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TRecoveryCustomDataLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TRecoveryCustomDataLineProperties.Create(Self);
{$ENDIF}
end;

destructor TRecoveryCustomDataLine.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TRecoveryCustomDataLine.GetServerProperties: TRecoveryCustomDataLineProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TRecoveryCustomDataLineProperties.Create(AServer: TRecoveryCustomDataLine);
begin
  inherited Create;
  FServer := AServer;
end;

function TRecoveryCustomDataLineProperties.GetDefaultInterface: _RecoveryCustomDataLine;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoRecoveryCustomDataTransaction.Create: _RecoveryCustomDataTransaction;
begin
  Result := CreateComObject(CLASS_RecoveryCustomDataTransaction) as _RecoveryCustomDataTransaction;
end;

class function CoRecoveryCustomDataTransaction.CreateRemote(const MachineName: string): _RecoveryCustomDataTransaction;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RecoveryCustomDataTransaction) as _RecoveryCustomDataTransaction;
end;

procedure TRecoveryCustomDataTransaction.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F5BDC02F-40FF-3CE3-A272-DAAD0803A345}';
    IntfIID:   '{DCE4FED1-952C-3B18-9D21-9D16AACD0024}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TRecoveryCustomDataTransaction.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _RecoveryCustomDataTransaction;
  end;
end;

procedure TRecoveryCustomDataTransaction.ConnectTo(svrIntf: _RecoveryCustomDataTransaction);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TRecoveryCustomDataTransaction.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TRecoveryCustomDataTransaction.GetDefaultInterface: _RecoveryCustomDataTransaction;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TRecoveryCustomDataTransaction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TRecoveryCustomDataTransactionProperties.Create(Self);
{$ENDIF}
end;

destructor TRecoveryCustomDataTransaction.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TRecoveryCustomDataTransaction.GetServerProperties: TRecoveryCustomDataTransactionProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TRecoveryCustomDataTransactionProperties.Create(AServer: TRecoveryCustomDataTransaction);
begin
  inherited Create;
  FServer := AServer;
end;

function TRecoveryCustomDataTransactionProperties.GetDefaultInterface: _RecoveryCustomDataTransaction;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoEncryption2.Create: _Encryption2;
begin
  Result := CreateComObject(CLASS_Encryption2) as _Encryption2;
end;

class function CoEncryption2.CreateRemote(const MachineName: string): _Encryption2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Encryption2) as _Encryption2;
end;

procedure TEncryption2.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{4AB18CB1-46AA-3F60-9745-B8E46EB6069B}';
    IntfIID:   '{D8875B72-2694-356D-A850-AFA7401F6105}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TEncryption2.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _Encryption2;
  end;
end;

procedure TEncryption2.ConnectTo(svrIntf: _Encryption2);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TEncryption2.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TEncryption2.GetDefaultInterface: _Encryption2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TEncryption2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TEncryption2Properties.Create(Self);
{$ENDIF}
end;

destructor TEncryption2.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TEncryption2.GetServerProperties: TEncryption2Properties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TEncryption2Properties.Create(AServer: TEncryption2);
begin
  inherited Create;
  FServer := AServer;
end;

function TEncryption2Properties.GetDefaultInterface: _Encryption2;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoRestoreLog.Create: _RestoreLog;
begin
  Result := CreateComObject(CLASS_RestoreLog) as _RestoreLog;
end;

class function CoRestoreLog.CreateRemote(const MachineName: string): _RestoreLog;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RestoreLog) as _RestoreLog;
end;

procedure TRestoreLog.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{CBAB6D96-E45D-3941-9FCD-F6D1289C5CCA}';
    IntfIID:   '{F5ECF719-010D-3A72-A4D3-40F973932240}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TRestoreLog.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _RestoreLog;
  end;
end;

procedure TRestoreLog.ConnectTo(svrIntf: _RestoreLog);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TRestoreLog.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TRestoreLog.GetDefaultInterface: _RestoreLog;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TRestoreLog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TRestoreLogProperties.Create(Self);
{$ENDIF}
end;

destructor TRestoreLog.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TRestoreLog.GetServerProperties: TRestoreLogProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TRestoreLogProperties.Create(AServer: TRestoreLog);
begin
  inherited Create;
  FServer := AServer;
end;

function TRestoreLogProperties.GetDefaultInterface: _RestoreLog;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoFileAssociation.Create: _FileAssociation;
begin
  Result := CreateComObject(CLASS_FileAssociation) as _FileAssociation;
end;

class function CoFileAssociation.CreateRemote(const MachineName: string): _FileAssociation;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FileAssociation) as _FileAssociation;
end;

procedure TFileAssociation.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{FE17326E-A2AE-3D36-B139-81F9C62873DA}';
    IntfIID:   '{B7C2C30C-7E94-3EA8-9A83-EF9CB2EB800F}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFileAssociation.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _FileAssociation;
  end;
end;

procedure TFileAssociation.ConnectTo(svrIntf: _FileAssociation);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFileAssociation.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFileAssociation.GetDefaultInterface: _FileAssociation;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TFileAssociation.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TFileAssociationProperties.Create(Self);
{$ENDIF}
end;

destructor TFileAssociation.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TFileAssociation.GetServerProperties: TFileAssociationProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TFileAssociationProperties.Create(AServer: TFileAssociation);
begin
  inherited Create;
  FServer := AServer;
end;

function TFileAssociationProperties.GetDefaultInterface: _FileAssociation;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoConfigurationForm.Create: _ConfigurationForm;
begin
  Result := CreateComObject(CLASS_ConfigurationForm) as _ConfigurationForm;
end;

class function CoConfigurationForm.CreateRemote(const MachineName: string): _ConfigurationForm;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ConfigurationForm) as _ConfigurationForm;
end;

class function CoMCMComboBoxItem.Create: _MCMComboBoxItem;
begin
  Result := CreateComObject(CLASS_MCMComboBoxItem) as _MCMComboBoxItem;
end;

class function CoMCMComboBoxItem.CreateRemote(const MachineName: string): _MCMComboBoxItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MCMComboBoxItem) as _MCMComboBoxItem;
end;

class function CoGlobalData.Create: _GlobalData;
begin
  Result := CreateComObject(CLASS_GlobalData) as _GlobalData;
end;

class function CoGlobalData.CreateRemote(const MachineName: string): _GlobalData;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GlobalData) as _GlobalData;
end;

class function CoctkDebugLog.Create: _ctkDebugLog;
begin
  Result := CreateComObject(CLASS_ctkDebugLog) as _ctkDebugLog;
end;

class function CoctkDebugLog.CreateRemote(const MachineName: string): _ctkDebugLog;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ctkDebugLog) as _ctkDebugLog;
end;

class function CoToolkitWrapper.Create: _ToolkitWrapper;
begin
  Result := CreateComObject(CLASS_ToolkitWrapper) as _ToolkitWrapper;
end;

class function CoToolkitWrapper.CreateRemote(const MachineName: string): _ToolkitWrapper;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ToolkitWrapper) as _ToolkitWrapper;
end;

procedure TToolkitWrapper.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{5749018E-9CA2-39D0-A082-CBD57AB0FDD2}';
    IntfIID:   '{36CB0AB5-C5D5-351B-8803-36013CA487D5}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TToolkitWrapper.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ToolkitWrapper;
  end;
end;

procedure TToolkitWrapper.ConnectTo(svrIntf: _ToolkitWrapper);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TToolkitWrapper.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TToolkitWrapper.GetDefaultInterface: _ToolkitWrapper;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TToolkitWrapper.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TToolkitWrapperProperties.Create(Self);
{$ENDIF}
end;

destructor TToolkitWrapper.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TToolkitWrapper.GetServerProperties: TToolkitWrapperProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TToolkitWrapperProperties.Create(AServer: TToolkitWrapper);
begin
  inherited Create;
  FServer := AServer;
end;

function TToolkitWrapperProperties.GetDefaultInterface: _ToolkitWrapper;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoXMLFuncs.Create: _XMLFuncs;
begin
  Result := CreateComObject(CLASS_XMLFuncs) as _XMLFuncs;
end;

class function CoXMLFuncs.CreateRemote(const MachineName: string): _XMLFuncs;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XMLFuncs) as _XMLFuncs;
end;

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TPaymentGateway, TExchequerTransaction, TPaymentDefaultInformation, TPaymentGatewayResponse, 
    TTransactionLine, TMCMCompany, TSourceConfig, TCurrencyCodes, TCompanyConfig, 
    TDebugView, TRecoveryCustomDataLine, TRecoveryCustomDataTransaction, TEncryption2, TRestoreLog, 
    TFileAssociation, TToolkitWrapper]);
end;

end.
