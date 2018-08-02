unit EnterpriseForms_TLB;

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
// File generated on 22/10/2015 09:48:03 from Type Library described below.

// ************************************************************************  //
// Type Lib: W:\ENTRPRSE\FormTK\ENTFORMS.tlb (1)
// LIBID: {6EA7D7C7-8CE8-4675-B700-061E21B14925}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\Windows\SysWOW64\stdvcl40.dll)
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
  EnterpriseFormsMajorVersion = 1;
  EnterpriseFormsMinorVersion = 0;

  LIBID_EnterpriseForms: TGUID = '{6EA7D7C7-8CE8-4675-B700-061E21B14925}';

  IID_IEFPrintingToolkit: TGUID = '{6E80B83C-EC52-4943-A205-4D9032E3B026}';
  CLASS_PrintingToolkit: TGUID = '{0707A446-0116-455B-BD97-F3FA8DD07AC3}';
  IID_IEFConfiguration: TGUID = '{1AB4763E-545B-4DD1-B8E7-8819F65F4E3E}';
  IID_IEFPrinters: TGUID = '{9D8DCCDD-583F-4AC0-88A4-B12749480659}';
  IID_IEFPrinterDetail: TGUID = '{ABA3035F-9E74-4719-B907-F101E19AAA2B}';
  IID_IEFStringListReadOnly: TGUID = '{28DA19DF-F83D-4395-98CD-12F7F8E50CE6}';
  IID_IEFPrintFormsList: TGUID = '{1F000752-7743-4B7C-AB87-70C3F72632A8}';
  IID_IEFPrintFormDetails: TGUID = '{8BB70307-BD62-42D6-A2C5-A6A11AE7E554}';
  IID_IEFPreviewConfiguration: TGUID = '{10EE8D45-3F40-46AE-8A71-0A5C5A17FC01}';
  IID_IEFFunctions: TGUID = '{D541320F-9C2B-4BA4-98D8-6D37A392339B}';
  IID_IEFPrintJob: TGUID = '{25ABFDD7-3C70-463A-911F-FAC8637E2C01}';
  IID_IEFPrintJobEmailInfo: TGUID = '{6F1E266B-ACCA-45BF-9D2D-FC87A57B682D}';
  IID_IEFPrintJobFaxInfo: TGUID = '{D5520E7D-AEBA-4D35-AEE8-0BCD44FA69E0}';
  IID_IEFPrintJobFileInfo: TGUID = '{C7776E8F-C508-43CC-9EBD-7477BA445D36}';
  IID_IEFPrintTempFile: TGUID = '{FD5B3033-02E9-470A-B12B-2A0D7E6D2DDF}';
  IID_IEFEmailAddressArray: TGUID = '{CEE29433-313A-431F-8864-F6AADB455442}';
  IID_IEFEmailAddress: TGUID = '{DDBECA5A-C113-4000-934A-E86698606C2F}';
  IID_IEFStringListReadWrite: TGUID = '{C59D7991-30E9-4D63-A23B-B2ABDE36019C}';
  IID_IEFFormDefInfo: TGUID = '{2875ACE3-E4E3-4B52-82E1-DF29A5C1DE60}';
  IID_IEFImportDefaults: TGUID = '{F3B2E301-B487-489D-A4B6-120ED65635ED}';
  IID_IEFCustomData: TGUID = '{668DDA2C-1112-4A65-B66B-3700DC6EAFCB}';
  IID_IEFPrintingToolkit2: TGUID = '{DF2C249D-DED7-4FDD-8060-861E0A570E0F}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TEFToolkitStatus
type
  TEFToolkitStatus = TOleEnum;
const
  tkClosed = $00000000;
  tkOpen = $00000001;

// Constants for enum TEFPrintFormMode
type
  TEFPrintFormMode = TOleEnum;
const
  fmNormalDocs = $00000001;
  fmRemittanceAdvice = $00000002;
  fmStatement = $00000003;
  fmDebtChaseLetters = $00000004;
  fmTradeHistory = $00000005;
  fmBatchDocs = $00000006;
  fmNomTransfer = $00000007;
  fmAccountDetails = $00000008;
  fmStockDetails = $0000000B;
  fmStockAdjustment = $0000000C;
  fmPickListConsolidated = $0000000D;
  fmPickListSingle = $0000000E;
  fmConsignmentNote = $0000000F;
  fmStockNotes = $00000011;
  fmAgedStatement = $00000016;
  fmTimeSheet = $00000017;
  fmJobBackingSheet = $00000018;
  fmJobDetails = $00000019;
  fmLabel = $0000001A;
  fmSerialLabel = $0000001B;
  fmTransNotes = $0000001C;
  fmCustomTradeHistory = $0000001D;
  fmOrderPaymentsVATReceipt = $0000001F;

// Constants for enum TEFTempFileDestination
type
  TEFTempFileDestination = TOleEnum;
const
  tfdPrinter = $00000000;
  tfdEmail = $00000001;
  tfdFax = $00000002;

// Constants for enum TEFPreviewType
type
  TEFPreviewType = TOleEnum;
const
  ptNonModal = $00000001;
  ptEDFReader = $00000002;

// Constants for enum TEFEmailType
type
  TEFEmailType = TOleEnum;
const
  emtMAPI = $00000000;
  emtSMTP = $00000001;

// Constants for enum TEFEmailPriority
type
  TEFEmailPriority = TOleEnum;
const
  empLow = $00000000;
  empNormal = $00000001;
  empHigh = $00000002;

// Constants for enum TEFAttachmentType
type
  TEFAttachmentType = TOleEnum;
const
  atInternalEDF = $00000000;
  atInternalPDF = $00000001;
  atAdobePDF = $00000002;

// Constants for enum TEFFormCompression
type
  TEFFormCompression = TOleEnum;
const
  fcNone = $00000000;
  fcZIP = $00000001;
  fcEDZ = $00000002;

// Constants for enum TEFFaxType
type
  TEFFaxType = TOleEnum;
const
  ftEnterpriseEComms = $00000000;
  ftMAPI = $00000001;
  ftThirdParty = $00000002;

// Constants for enum TEFFaxPriority
type
  TEFFaxPriority = TOleEnum;
const
  fpUrgent = $00000000;
  fpNormal = $00000001;
  fpOffPeak = $00000002;

// Constants for enum TEFFormType
type
  TEFFormType = TOleEnum;
const
  ftPCC = $00000000;
  ftEFDForm = $00000001;
  ftEFDLabel = $00000002;

// Constants for enum TEFSaveAsType
type
  TEFSaveAsType = TOleEnum;
const
  saEDF = $00000000;
  saEDZ = $00000001;
  saPDF = $00000002;

// Constants for enum TEFImportDefaultsType
type
  TEFImportDefaultsType = TOleEnum;
const
  deftypeNone = $00000001;
  deftypeSalesInvoice = $00000002;
  deftypeSalesInvoiceWithReceipt = $00000003;
  deftypeSalesCreditNote = $00000004;
  deftypeSalesRefund = $00000005;
  deftypeSalesQuote = $00000006;
  deftypeSalesOrder = $00000007;
  deftypeSalesProForma = $00000008;
  deftypeSalesDeliveryNote = $00000009;
  deftypeSalesReceipt = $0000000A;
  deftypeSalesJournalInvoice = $0000000B;
  deftypeSalesJournalCredit = $0000000C;
  deftypeSalesReceiptDetails = $0000000D;
  deftypePurchaseInvoice = $0000000E;
  deftypePurchasePayment = $0000000F;
  deftypePurchaseCreditNote = $00000010;
  deftypePurchaseQuotation = $00000011;
  deftypePurchaseOrder = $00000012;
  deftypePurchaseDeliveryNote = $00000013;
  deftypePurchaseJournalInvoice = $00000014;
  deftypePurchaseJournalCredit = $00000015;
  deftypePurchasePaymentWithInvoice = $00000016;
  deftypePurchaseRefund = $00000017;
  deftypePurchasePaymentDebitNote = $00000018;
  deftypeTimesheet = $00000019;
  deftypeWorksIssueNote = $0000001A;
  deftypeWorksOrder = $0000001B;
  deftypeNominalTransfer = $0000001C;
  deftypeBatch = $0000001D;
  deftypeStockAdjustment = $0000001E;
  deftypeDeliveryLabel = $0000001F;
  defTypeProductLabel = $00000020;
  defTypeStockLabel = $00000021;
  defTypeTransSerialLabels = $00000022;
  defTypeTransProductLabels = $00000023;
  defTypeConsignmentNote = $00000024;
  defTypePickingList = $00000025;
  defTypeConsolidatedPickingList = $00000026;
  defTypeTransNotes = $00000027;
  defTypeTransLineSerialLabels = $00000028;
  defTypeJobWithNotes = $00000029;
  defTypeJCBackingSheet = $0000002A;
  defTypeStockWithBOM = $0000002B;
  defTypeStockWithNotes = $0000002C;
  defTypeAccountWithNotes = $0000002D;
  defTypeAccountStatement = $0000002E;
  defTypeAccountTradingLedger = $0000002F;
  defTypeAccountLabel = $00000030;
  defTypeJobPurchaseTerms = $00000031;
  defTypeJobSalesTerms = $00000032;
  defTypeJobContractTerms = $00000033;
  defTypeJobPurchaseApplication = $00000034;
  defTypeJobSalesApplication = $00000035;
  defTypeJobPurchaseApplicationCertified = $00000036;
  defTypeJobSalesApplicationCertified = $00000037;
  defTypeSalesReturnNote = $00000038;
  defTypePurchaseReturnNote = $00000039;
  defTypeSRNAsRepairQuote = $0000003A;
  defTypePaymentSRCAsVATReceipt = $0000003B;
  defTypeRefundSRCAsVATReceipt = $0000003C;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IEFPrintingToolkit = interface;
  IEFPrintingToolkitDisp = dispinterface;
  IEFConfiguration = interface;
  IEFConfigurationDisp = dispinterface;
  IEFPrinters = interface;
  IEFPrintersDisp = dispinterface;
  IEFPrinterDetail = interface;
  IEFPrinterDetailDisp = dispinterface;
  IEFStringListReadOnly = interface;
  IEFStringListReadOnlyDisp = dispinterface;
  IEFPrintFormsList = interface;
  IEFPrintFormsListDisp = dispinterface;
  IEFPrintFormDetails = interface;
  IEFPrintFormDetailsDisp = dispinterface;
  IEFPreviewConfiguration = interface;
  IEFPreviewConfigurationDisp = dispinterface;
  IEFFunctions = interface;
  IEFFunctionsDisp = dispinterface;
  IEFPrintJob = interface;
  IEFPrintJobDisp = dispinterface;
  IEFPrintJobEmailInfo = interface;
  IEFPrintJobEmailInfoDisp = dispinterface;
  IEFPrintJobFaxInfo = interface;
  IEFPrintJobFaxInfoDisp = dispinterface;
  IEFPrintJobFileInfo = interface;
  IEFPrintJobFileInfoDisp = dispinterface;
  IEFPrintTempFile = interface;
  IEFPrintTempFileDisp = dispinterface;
  IEFEmailAddressArray = interface;
  IEFEmailAddressArrayDisp = dispinterface;
  IEFEmailAddress = interface;
  IEFEmailAddressDisp = dispinterface;
  IEFStringListReadWrite = interface;
  IEFStringListReadWriteDisp = dispinterface;
  IEFFormDefInfo = interface;
  IEFFormDefInfoDisp = dispinterface;
  IEFImportDefaults = interface;
  IEFImportDefaultsDisp = dispinterface;
  IEFCustomData = interface;
  IEFCustomDataDisp = dispinterface;
  IEFPrintingToolkit2 = interface;
  IEFPrintingToolkit2Disp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  PrintingToolkit = IEFPrintingToolkit;


// *********************************************************************//
// Interface: IEFPrintingToolkit
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6E80B83C-EC52-4943-A205-4D9032E3B026}
// *********************************************************************//
  IEFPrintingToolkit = interface(IDispatch)
    ['{6E80B83C-EC52-4943-A205-4D9032E3B026}']
    function OpenPrinting(const ProductName: WideString; const LicenceNo: WideString): Integer; safecall;
    function ClosePrinting: Integer; safecall;
    function Get_Version: WideString; safecall;
    function Get_Configuration: IEFConfiguration; safecall;
    function Get_PrintJob: IEFPrintJob; safecall;
    function Get_Status: TEFToolkitStatus; safecall;
    function Get_Printers: IEFPrinters; safecall;
    function Get_Functions: IEFFunctions; safecall;
    function Get_LastErrorString: WideString; safecall;
    property Version: WideString read Get_Version;
    property Configuration: IEFConfiguration read Get_Configuration;
    property PrintJob: IEFPrintJob read Get_PrintJob;
    property Status: TEFToolkitStatus read Get_Status;
    property Printers: IEFPrinters read Get_Printers;
    property Functions: IEFFunctions read Get_Functions;
    property LastErrorString: WideString read Get_LastErrorString;
  end;

// *********************************************************************//
// DispIntf:  IEFPrintingToolkitDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6E80B83C-EC52-4943-A205-4D9032E3B026}
// *********************************************************************//
  IEFPrintingToolkitDisp = dispinterface
    ['{6E80B83C-EC52-4943-A205-4D9032E3B026}']
    function OpenPrinting(const ProductName: WideString; const LicenceNo: WideString): Integer; dispid 1;
    function ClosePrinting: Integer; dispid 2;
    property Version: WideString readonly dispid 3;
    property Configuration: IEFConfiguration readonly dispid 4;
    property PrintJob: IEFPrintJob readonly dispid 5;
    property Status: TEFToolkitStatus readonly dispid 6;
    property Printers: IEFPrinters readonly dispid 7;
    property Functions: IEFFunctions readonly dispid 8;
    property LastErrorString: WideString readonly dispid 9;
  end;

// *********************************************************************//
// Interface: IEFConfiguration
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1AB4763E-545B-4DD1-B8E7-8819F65F4E3E}
// *********************************************************************//
  IEFConfiguration = interface(IDispatch)
    ['{1AB4763E-545B-4DD1-B8E7-8819F65F4E3E}']
    function Get_cfDataDirectory: WideString; safecall;
    procedure Set_cfDataDirectory(const Value: WideString); safecall;
    function Get_cfEnterpriseDirectory: WideString; safecall;
    procedure Set_cfEnterpriseDirectory(const Value: WideString); safecall;
    function Get_cfDeleteTempFiles: WordBool; safecall;
    procedure Set_cfDeleteTempFiles(Value: WordBool); safecall;
    property cfDataDirectory: WideString read Get_cfDataDirectory write Set_cfDataDirectory;
    property cfEnterpriseDirectory: WideString read Get_cfEnterpriseDirectory write Set_cfEnterpriseDirectory;
    property cfDeleteTempFiles: WordBool read Get_cfDeleteTempFiles write Set_cfDeleteTempFiles;
  end;

// *********************************************************************//
// DispIntf:  IEFConfigurationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1AB4763E-545B-4DD1-B8E7-8819F65F4E3E}
// *********************************************************************//
  IEFConfigurationDisp = dispinterface
    ['{1AB4763E-545B-4DD1-B8E7-8819F65F4E3E}']
    property cfDataDirectory: WideString dispid 1;
    property cfEnterpriseDirectory: WideString dispid 2;
    property cfDeleteTempFiles: WordBool dispid 3;
  end;

// *********************************************************************//
// Interface: IEFPrinters
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9D8DCCDD-583F-4AC0-88A4-B12749480659}
// *********************************************************************//
  IEFPrinters = interface(IDispatch)
    ['{9D8DCCDD-583F-4AC0-88A4-B12749480659}']
    function Get_prPrinters(Index: Integer): IEFPrinterDetail; safecall;
    function Get_prCount: Integer; safecall;
    function Get_prDefaultPrinter: Integer; safecall;
    function IndexOf(const SearchText: WideString): Integer; safecall;
    property prPrinters[Index: Integer]: IEFPrinterDetail read Get_prPrinters; default;
    property prCount: Integer read Get_prCount;
    property prDefaultPrinter: Integer read Get_prDefaultPrinter;
  end;

// *********************************************************************//
// DispIntf:  IEFPrintersDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9D8DCCDD-583F-4AC0-88A4-B12749480659}
// *********************************************************************//
  IEFPrintersDisp = dispinterface
    ['{9D8DCCDD-583F-4AC0-88A4-B12749480659}']
    property prPrinters[Index: Integer]: IEFPrinterDetail readonly dispid 0; default;
    property prCount: Integer readonly dispid 1;
    property prDefaultPrinter: Integer readonly dispid 2;
    function IndexOf(const SearchText: WideString): Integer; dispid 3;
  end;

// *********************************************************************//
// Interface: IEFPrinterDetail
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ABA3035F-9E74-4719-B907-F101E19AAA2B}
// *********************************************************************//
  IEFPrinterDetail = interface(IDispatch)
    ['{ABA3035F-9E74-4719-B907-F101E19AAA2B}']
    function Get_pdName: WideString; safecall;
    function Get_pdPapers: IEFStringListReadOnly; safecall;
    function Get_pdBins: IEFStringListReadOnly; safecall;
    function Get_pdDefaultPaper: Integer; safecall;
    function Get_pdDefaultBin: Integer; safecall;
    function Get_pdSupportsPapers: WordBool; safecall;
    function Get_pdSupportsBins: WordBool; safecall;
    property pdName: WideString read Get_pdName;
    property pdPapers: IEFStringListReadOnly read Get_pdPapers;
    property pdBins: IEFStringListReadOnly read Get_pdBins;
    property pdDefaultPaper: Integer read Get_pdDefaultPaper;
    property pdDefaultBin: Integer read Get_pdDefaultBin;
    property pdSupportsPapers: WordBool read Get_pdSupportsPapers;
    property pdSupportsBins: WordBool read Get_pdSupportsBins;
  end;

// *********************************************************************//
// DispIntf:  IEFPrinterDetailDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ABA3035F-9E74-4719-B907-F101E19AAA2B}
// *********************************************************************//
  IEFPrinterDetailDisp = dispinterface
    ['{ABA3035F-9E74-4719-B907-F101E19AAA2B}']
    property pdName: WideString readonly dispid 0;
    property pdPapers: IEFStringListReadOnly readonly dispid 1;
    property pdBins: IEFStringListReadOnly readonly dispid 2;
    property pdDefaultPaper: Integer readonly dispid 3;
    property pdDefaultBin: Integer readonly dispid 4;
    property pdSupportsPapers: WordBool readonly dispid 5;
    property pdSupportsBins: WordBool readonly dispid 6;
  end;

// *********************************************************************//
// Interface: IEFStringListReadOnly
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {28DA19DF-F83D-4395-98CD-12F7F8E50CE6}
// *********************************************************************//
  IEFStringListReadOnly = interface(IDispatch)
    ['{28DA19DF-F83D-4395-98CD-12F7F8E50CE6}']
    function Get_Strings(Index: Integer): WideString; safecall;
    function Get_Count: Integer; safecall;
    function IndexOf(const SearchText: WideString): Integer; safecall;
    property Strings[Index: Integer]: WideString read Get_Strings; default;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IEFStringListReadOnlyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {28DA19DF-F83D-4395-98CD-12F7F8E50CE6}
// *********************************************************************//
  IEFStringListReadOnlyDisp = dispinterface
    ['{28DA19DF-F83D-4395-98CD-12F7F8E50CE6}']
    property Strings[Index: Integer]: WideString readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    function IndexOf(const SearchText: WideString): Integer; dispid 2;
  end;

// *********************************************************************//
// Interface: IEFPrintFormsList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F000752-7743-4B7C-AB87-70C3F72632A8}
// *********************************************************************//
  IEFPrintFormsList = interface(IDispatch)
    ['{1F000752-7743-4B7C-AB87-70C3F72632A8}']
    function Get_pfForms(Index: Integer): IEFPrintFormDetails; safecall;
    function Get_pfCount: Integer; safecall;
    function Add: IEFPrintFormDetails; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Clear; safecall;
    property pfForms[Index: Integer]: IEFPrintFormDetails read Get_pfForms; default;
    property pfCount: Integer read Get_pfCount;
  end;

// *********************************************************************//
// DispIntf:  IEFPrintFormsListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1F000752-7743-4B7C-AB87-70C3F72632A8}
// *********************************************************************//
  IEFPrintFormsListDisp = dispinterface
    ['{1F000752-7743-4B7C-AB87-70C3F72632A8}']
    property pfForms[Index: Integer]: IEFPrintFormDetails readonly dispid 0; default;
    property pfCount: Integer readonly dispid 1;
    function Add: IEFPrintFormDetails; dispid 2;
    procedure Delete(Index: Integer); dispid 3;
    procedure Clear; dispid 4;
  end;

// *********************************************************************//
// Interface: IEFPrintFormDetails
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8BB70307-BD62-42D6-A2C5-A6A11AE7E554}
// *********************************************************************//
  IEFPrintFormDetails = interface(IDispatch)
    ['{8BB70307-BD62-42D6-A2C5-A6A11AE7E554}']
    function Get_fdMode: TEFPrintFormMode; safecall;
    procedure Set_fdMode(Value: TEFPrintFormMode); safecall;
    function Get_fdFormName: WideString; safecall;
    procedure Set_fdFormName(const Value: WideString); safecall;
    function Get_fdMainFileNo: Integer; safecall;
    procedure Set_fdMainFileNo(Value: Integer); safecall;
    function Get_fdMainIndexNo: Integer; safecall;
    procedure Set_fdMainIndexNo(Value: Integer); safecall;
    function Get_fdMainKeyString: WideString; safecall;
    procedure Set_fdMainKeyString(const Value: WideString); safecall;
    function Get_fdTableFileNo: Integer; safecall;
    procedure Set_fdTableFileNo(Value: Integer); safecall;
    function Get_fdTableIndexNo: Integer; safecall;
    procedure Set_fdTableIndexNo(Value: Integer); safecall;
    function Get_fdTableKeyString: WideString; safecall;
    procedure Set_fdTableKeyString(const Value: WideString); safecall;
    function Get_fdDescription: WideString; safecall;
    procedure Set_fdDescription(const Value: WideString); safecall;
    function Get_fdLabelCopies: Integer; safecall;
    procedure Set_fdLabelCopies(Value: Integer); safecall;
    function Save: Integer; safecall;
    function Get_fdSerialPos: Integer; safecall;
    procedure Set_fdSerialPos(Value: Integer); safecall;
    function Get_fdCustomDataCount: Integer; safecall;
    function Get_fdCustomData(Index: Integer): IEFCustomData; safecall;
    function AddCustomData(FileNo: Integer; IndexNo: Integer; RecPosition: Integer; 
                           const SortKey: WideString): IEFCustomData; safecall;
    procedure DeleteCustomData(Index: Integer); safecall;
    procedure ClearCustomData; safecall;
    property fdMode: TEFPrintFormMode read Get_fdMode write Set_fdMode;
    property fdFormName: WideString read Get_fdFormName write Set_fdFormName;
    property fdMainFileNo: Integer read Get_fdMainFileNo write Set_fdMainFileNo;
    property fdMainIndexNo: Integer read Get_fdMainIndexNo write Set_fdMainIndexNo;
    property fdMainKeyString: WideString read Get_fdMainKeyString write Set_fdMainKeyString;
    property fdTableFileNo: Integer read Get_fdTableFileNo write Set_fdTableFileNo;
    property fdTableIndexNo: Integer read Get_fdTableIndexNo write Set_fdTableIndexNo;
    property fdTableKeyString: WideString read Get_fdTableKeyString write Set_fdTableKeyString;
    property fdDescription: WideString read Get_fdDescription write Set_fdDescription;
    property fdLabelCopies: Integer read Get_fdLabelCopies write Set_fdLabelCopies;
    property fdSerialPos: Integer read Get_fdSerialPos write Set_fdSerialPos;
    property fdCustomDataCount: Integer read Get_fdCustomDataCount;
    property fdCustomData[Index: Integer]: IEFCustomData read Get_fdCustomData;
  end;

// *********************************************************************//
// DispIntf:  IEFPrintFormDetailsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8BB70307-BD62-42D6-A2C5-A6A11AE7E554}
// *********************************************************************//
  IEFPrintFormDetailsDisp = dispinterface
    ['{8BB70307-BD62-42D6-A2C5-A6A11AE7E554}']
    property fdMode: TEFPrintFormMode dispid 2;
    property fdFormName: WideString dispid 1;
    property fdMainFileNo: Integer dispid 3;
    property fdMainIndexNo: Integer dispid 4;
    property fdMainKeyString: WideString dispid 5;
    property fdTableFileNo: Integer dispid 6;
    property fdTableIndexNo: Integer dispid 7;
    property fdTableKeyString: WideString dispid 8;
    property fdDescription: WideString dispid 9;
    property fdLabelCopies: Integer dispid 11;
    function Save: Integer; dispid 10;
    property fdSerialPos: Integer dispid 12;
    property fdCustomDataCount: Integer readonly dispid 13;
    property fdCustomData[Index: Integer]: IEFCustomData readonly dispid 14;
    function AddCustomData(FileNo: Integer; IndexNo: Integer; RecPosition: Integer; 
                           const SortKey: WideString): IEFCustomData; dispid 15;
    procedure DeleteCustomData(Index: Integer); dispid 16;
    procedure ClearCustomData; dispid 17;
  end;

// *********************************************************************//
// Interface: IEFPreviewConfiguration
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {10EE8D45-3F40-46AE-8A71-0A5C5A17FC01}
// *********************************************************************//
  IEFPreviewConfiguration = interface(IDispatch)
    ['{10EE8D45-3F40-46AE-8A71-0A5C5A17FC01}']
    function Get_pcPreviewMode: Integer; safecall;
    procedure Set_pcPreviewMode(Value: Integer); safecall;
    function Get_pcPreviewHandle: Integer; safecall;
    property pcPreviewMode: Integer read Get_pcPreviewMode write Set_pcPreviewMode;
    property pcPreviewHandle: Integer read Get_pcPreviewHandle;
  end;

// *********************************************************************//
// DispIntf:  IEFPreviewConfigurationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {10EE8D45-3F40-46AE-8A71-0A5C5A17FC01}
// *********************************************************************//
  IEFPreviewConfigurationDisp = dispinterface
    ['{10EE8D45-3F40-46AE-8A71-0A5C5A17FC01}']
    property pcPreviewMode: Integer dispid 1;
    property pcPreviewHandle: Integer readonly dispid 2;
  end;

// *********************************************************************//
// Interface: IEFFunctions
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D541320F-9C2B-4BA4-98D8-6D37A392339B}
// *********************************************************************//
  IEFFunctions = interface(IDispatch)
    ['{D541320F-9C2B-4BA4-98D8-6D37A392339B}']
    function fnPadString(const StrKey: WideString; PadLen: Integer): WideString; safecall;
    function fnIntegerKey(IntVal: Integer): WideString; safecall;
    procedure fnDeleteTempFiles; safecall;
    function fnGetFormInfo(const FormName: WideString): IEFFormDefInfo; safecall;
  end;

// *********************************************************************//
// DispIntf:  IEFFunctionsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D541320F-9C2B-4BA4-98D8-6D37A392339B}
// *********************************************************************//
  IEFFunctionsDisp = dispinterface
    ['{D541320F-9C2B-4BA4-98D8-6D37A392339B}']
    function fnPadString(const StrKey: WideString; PadLen: Integer): WideString; dispid 1;
    function fnIntegerKey(IntVal: Integer): WideString; dispid 2;
    procedure fnDeleteTempFiles; dispid 3;
    function fnGetFormInfo(const FormName: WideString): IEFFormDefInfo; dispid 4;
  end;

// *********************************************************************//
// Interface: IEFPrintJob
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {25ABFDD7-3C70-463A-911F-FAC8637E2C01}
// *********************************************************************//
  IEFPrintJob = interface(IDispatch)
    ['{25ABFDD7-3C70-463A-911F-FAC8637E2C01}']
    function Get_pjForms: IEFPrintFormsList; safecall;
    function Get_pjPrinterIndex: Integer; safecall;
    procedure Set_pjPrinterIndex(Value: Integer); safecall;
    function Get_pjPaperIndex: Integer; safecall;
    procedure Set_pjPaperIndex(Value: Integer); safecall;
    function Get_pjBinIndex: Integer; safecall;
    procedure Set_pjBinIndex(Value: Integer); safecall;
    function Get_pjCopies: Integer; safecall;
    procedure Set_pjCopies(Value: Integer); safecall;
    function Get_pjTestMode: WordBool; safecall;
    procedure Set_pjTestMode(Value: WordBool); safecall;
    function Get_pjLabel1: Integer; safecall;
    procedure Set_pjLabel1(Value: Integer); safecall;
    function Get_pjUserId: WideString; safecall;
    procedure Set_pjUserId(const Value: WideString); safecall;
    function Get_pjEmailInfo: IEFPrintJobEmailInfo; safecall;
    function Get_pjFaxInfo: IEFPrintJobFaxInfo; safecall;
    function Get_pjFileInfo: IEFPrintJobFileInfo; safecall;
    procedure Initialise(FormMode: TEFPrintFormMode); safecall;
    function PrinterSetupDialog: WordBool; safecall;
    function PrintToPrinter: Integer; safecall;
    function PrintToTempFile(Destination: TEFTempFileDestination): IEFPrintTempFile; safecall;
    function Get_pjTitle: WideString; safecall;
    procedure Set_pjTitle(const Value: WideString); safecall;
    function Get_pjMode: TEFPrintFormMode; safecall;
    function ImportDefaults: IEFImportDefaults; safecall;
    property pjForms: IEFPrintFormsList read Get_pjForms;
    property pjPrinterIndex: Integer read Get_pjPrinterIndex write Set_pjPrinterIndex;
    property pjPaperIndex: Integer read Get_pjPaperIndex write Set_pjPaperIndex;
    property pjBinIndex: Integer read Get_pjBinIndex write Set_pjBinIndex;
    property pjCopies: Integer read Get_pjCopies write Set_pjCopies;
    property pjTestMode: WordBool read Get_pjTestMode write Set_pjTestMode;
    property pjLabel1: Integer read Get_pjLabel1 write Set_pjLabel1;
    property pjUserId: WideString read Get_pjUserId write Set_pjUserId;
    property pjEmailInfo: IEFPrintJobEmailInfo read Get_pjEmailInfo;
    property pjFaxInfo: IEFPrintJobFaxInfo read Get_pjFaxInfo;
    property pjFileInfo: IEFPrintJobFileInfo read Get_pjFileInfo;
    property pjTitle: WideString read Get_pjTitle write Set_pjTitle;
    property pjMode: TEFPrintFormMode read Get_pjMode;
  end;

// *********************************************************************//
// DispIntf:  IEFPrintJobDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {25ABFDD7-3C70-463A-911F-FAC8637E2C01}
// *********************************************************************//
  IEFPrintJobDisp = dispinterface
    ['{25ABFDD7-3C70-463A-911F-FAC8637E2C01}']
    property pjForms: IEFPrintFormsList readonly dispid 1;
    property pjPrinterIndex: Integer dispid 2;
    property pjPaperIndex: Integer dispid 3;
    property pjBinIndex: Integer dispid 4;
    property pjCopies: Integer dispid 5;
    property pjTestMode: WordBool dispid 6;
    property pjLabel1: Integer dispid 7;
    property pjUserId: WideString dispid 8;
    property pjEmailInfo: IEFPrintJobEmailInfo readonly dispid 9;
    property pjFaxInfo: IEFPrintJobFaxInfo readonly dispid 10;
    property pjFileInfo: IEFPrintJobFileInfo readonly dispid 11;
    procedure Initialise(FormMode: TEFPrintFormMode); dispid 12;
    function PrinterSetupDialog: WordBool; dispid 13;
    function PrintToPrinter: Integer; dispid 14;
    function PrintToTempFile(Destination: TEFTempFileDestination): IEFPrintTempFile; dispid 15;
    property pjTitle: WideString dispid 16;
    property pjMode: TEFPrintFormMode readonly dispid 17;
    function ImportDefaults: IEFImportDefaults; dispid 18;
  end;

// *********************************************************************//
// Interface: IEFPrintJobEmailInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6F1E266B-ACCA-45BF-9D2D-FC87A57B682D}
// *********************************************************************//
  IEFPrintJobEmailInfo = interface(IDispatch)
    ['{6F1E266B-ACCA-45BF-9D2D-FC87A57B682D}']
    function Get_emType: TEFEmailType; safecall;
    function Get_emSenderName: WideString; safecall;
    procedure Set_emSenderName(const Value: WideString); safecall;
    function Get_emSenderAddress: WideString; safecall;
    procedure Set_emSenderAddress(const Value: WideString); safecall;
    function Get_emToRecipients: IEFEmailAddressArray; safecall;
    function Get_emCCRecipients: IEFEmailAddressArray; safecall;
    function Get_emBCCRecipients: IEFEmailAddressArray; safecall;
    function Get_emSubject: WideString; safecall;
    procedure Set_emSubject(const Value: WideString); safecall;
    function Get_emMessageText: WideString; safecall;
    procedure Set_emMessageText(const Value: WideString); safecall;
    function Get_emAttachments: IEFStringListReadWrite; safecall;
    function Get_emPriority: TEFEmailPriority; safecall;
    procedure Set_emPriority(Value: TEFEmailPriority); safecall;
    function Get_emCoverSheet: WideString; safecall;
    procedure Set_emCoverSheet(const Value: WideString); safecall;
    function Get_emSMTPServer: WideString; safecall;
    function Get_emFormCompression: TEFFormCompression; safecall;
    procedure Set_emFormCompression(Value: TEFFormCompression); safecall;
    function Get_emSendReader: WordBool; safecall;
    procedure Set_emSendReader(Value: WordBool); safecall;
    property emType: TEFEmailType read Get_emType;
    property emSenderName: WideString read Get_emSenderName write Set_emSenderName;
    property emSenderAddress: WideString read Get_emSenderAddress write Set_emSenderAddress;
    property emToRecipients: IEFEmailAddressArray read Get_emToRecipients;
    property emCCRecipients: IEFEmailAddressArray read Get_emCCRecipients;
    property emBCCRecipients: IEFEmailAddressArray read Get_emBCCRecipients;
    property emSubject: WideString read Get_emSubject write Set_emSubject;
    property emMessageText: WideString read Get_emMessageText write Set_emMessageText;
    property emAttachments: IEFStringListReadWrite read Get_emAttachments;
    property emPriority: TEFEmailPriority read Get_emPriority write Set_emPriority;
    property emCoverSheet: WideString read Get_emCoverSheet write Set_emCoverSheet;
    property emSMTPServer: WideString read Get_emSMTPServer;
    property emFormCompression: TEFFormCompression read Get_emFormCompression write Set_emFormCompression;
    property emSendReader: WordBool read Get_emSendReader write Set_emSendReader;
  end;

// *********************************************************************//
// DispIntf:  IEFPrintJobEmailInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6F1E266B-ACCA-45BF-9D2D-FC87A57B682D}
// *********************************************************************//
  IEFPrintJobEmailInfoDisp = dispinterface
    ['{6F1E266B-ACCA-45BF-9D2D-FC87A57B682D}']
    property emType: TEFEmailType readonly dispid 1;
    property emSenderName: WideString dispid 2;
    property emSenderAddress: WideString dispid 3;
    property emToRecipients: IEFEmailAddressArray readonly dispid 4;
    property emCCRecipients: IEFEmailAddressArray readonly dispid 5;
    property emBCCRecipients: IEFEmailAddressArray readonly dispid 6;
    property emSubject: WideString dispid 7;
    property emMessageText: WideString dispid 8;
    property emAttachments: IEFStringListReadWrite readonly dispid 9;
    property emPriority: TEFEmailPriority dispid 10;
    property emCoverSheet: WideString dispid 11;
    property emSMTPServer: WideString readonly dispid 13;
    property emFormCompression: TEFFormCompression dispid 14;
    property emSendReader: WordBool dispid 12;
  end;

// *********************************************************************//
// Interface: IEFPrintJobFaxInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D5520E7D-AEBA-4D35-AEE8-0BCD44FA69E0}
// *********************************************************************//
  IEFPrintJobFaxInfo = interface(IDispatch)
    ['{D5520E7D-AEBA-4D35-AEE8-0BCD44FA69E0}']
    function Get_fxType: TEFFaxType; safecall;
    function Get_fxFaxPrinterIndex: Integer; safecall;
    function Get_fxSenderName: WideString; safecall;
    procedure Set_fxSenderName(const Value: WideString); safecall;
    function Get_fxSenderFaxNumber: WideString; safecall;
    procedure Set_fxSenderFaxNumber(const Value: WideString); safecall;
    function Get_fxRecipientName: WideString; safecall;
    procedure Set_fxRecipientName(const Value: WideString); safecall;
    function Get_fxRecipientFaxNumber: WideString; safecall;
    procedure Set_fxRecipientFaxNumber(const Value: WideString); safecall;
    function Get_fxFaxingPath: WideString; safecall;
    function Get_fxCoverSheet: WideString; safecall;
    procedure Set_fxCoverSheet(const Value: WideString); safecall;
    function Get_fxPriority: TEFFaxPriority; safecall;
    procedure Set_fxPriority(Value: TEFFaxPriority); safecall;
    function Get_fxMessageText: WideString; safecall;
    procedure Set_fxMessageText(const Value: WideString); safecall;
    function Get_fxFaxDescription: WideString; safecall;
    procedure Set_fxFaxDescription(const Value: WideString); safecall;
    property fxType: TEFFaxType read Get_fxType;
    property fxFaxPrinterIndex: Integer read Get_fxFaxPrinterIndex;
    property fxSenderName: WideString read Get_fxSenderName write Set_fxSenderName;
    property fxSenderFaxNumber: WideString read Get_fxSenderFaxNumber write Set_fxSenderFaxNumber;
    property fxRecipientName: WideString read Get_fxRecipientName write Set_fxRecipientName;
    property fxRecipientFaxNumber: WideString read Get_fxRecipientFaxNumber write Set_fxRecipientFaxNumber;
    property fxFaxingPath: WideString read Get_fxFaxingPath;
    property fxCoverSheet: WideString read Get_fxCoverSheet write Set_fxCoverSheet;
    property fxPriority: TEFFaxPriority read Get_fxPriority write Set_fxPriority;
    property fxMessageText: WideString read Get_fxMessageText write Set_fxMessageText;
    property fxFaxDescription: WideString read Get_fxFaxDescription write Set_fxFaxDescription;
  end;

// *********************************************************************//
// DispIntf:  IEFPrintJobFaxInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D5520E7D-AEBA-4D35-AEE8-0BCD44FA69E0}
// *********************************************************************//
  IEFPrintJobFaxInfoDisp = dispinterface
    ['{D5520E7D-AEBA-4D35-AEE8-0BCD44FA69E0}']
    property fxType: TEFFaxType readonly dispid 1;
    property fxFaxPrinterIndex: Integer readonly dispid 2;
    property fxSenderName: WideString dispid 3;
    property fxSenderFaxNumber: WideString dispid 4;
    property fxRecipientName: WideString dispid 5;
    property fxRecipientFaxNumber: WideString dispid 6;
    property fxFaxingPath: WideString readonly dispid 7;
    property fxCoverSheet: WideString dispid 8;
    property fxPriority: TEFFaxPriority dispid 9;
    property fxMessageText: WideString dispid 10;
    property fxFaxDescription: WideString dispid 11;
  end;

// *********************************************************************//
// Interface: IEFPrintJobFileInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C7776E8F-C508-43CC-9EBD-7477BA445D36}
// *********************************************************************//
  IEFPrintJobFileInfo = interface(IDispatch)
    ['{C7776E8F-C508-43CC-9EBD-7477BA445D36}']
    function Get_fiAttachmentType: TEFAttachmentType; safecall;
    function Get_fiAttachmentPrinterIndex: Integer; safecall;
    property fiAttachmentType: TEFAttachmentType read Get_fiAttachmentType;
    property fiAttachmentPrinterIndex: Integer read Get_fiAttachmentPrinterIndex;
  end;

// *********************************************************************//
// DispIntf:  IEFPrintJobFileInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C7776E8F-C508-43CC-9EBD-7477BA445D36}
// *********************************************************************//
  IEFPrintJobFileInfoDisp = dispinterface
    ['{C7776E8F-C508-43CC-9EBD-7477BA445D36}']
    property fiAttachmentType: TEFAttachmentType readonly dispid 1;
    property fiAttachmentPrinterIndex: Integer readonly dispid 2;
  end;

// *********************************************************************//
// Interface: IEFPrintTempFile
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FD5B3033-02E9-470A-B12B-2A0D7E6D2DDF}
// *********************************************************************//
  IEFPrintTempFile = interface(IDispatch)
    ['{FD5B3033-02E9-470A-B12B-2A0D7E6D2DDF}']
    function Get_pfType: TEFTempFileDestination; safecall;
    function Get_pfFileName: WideString; safecall;
    function DisplayPreviewWindow(PreviewType: TEFPreviewType): Integer; safecall;
    function SendToDestination: Integer; safecall;
    function Get_pfPages: Integer; safecall;
    function Get_pfStartPage: Integer; safecall;
    procedure Set_pfStartPage(Value: Integer); safecall;
    function Get_pfFinishPage: Integer; safecall;
    procedure Set_pfFinishPage(Value: Integer); safecall;
    function Get_pfCopies: Integer; safecall;
    procedure Set_pfCopies(Value: Integer); safecall;
    function Get_pfStatus: Integer; safecall;
    function SaveAsFile(const FilePath: WideString; FileType: TEFSaveAsType): Integer; safecall;
    property pfType: TEFTempFileDestination read Get_pfType;
    property pfFileName: WideString read Get_pfFileName;
    property pfPages: Integer read Get_pfPages;
    property pfStartPage: Integer read Get_pfStartPage write Set_pfStartPage;
    property pfFinishPage: Integer read Get_pfFinishPage write Set_pfFinishPage;
    property pfCopies: Integer read Get_pfCopies write Set_pfCopies;
    property pfStatus: Integer read Get_pfStatus;
  end;

// *********************************************************************//
// DispIntf:  IEFPrintTempFileDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FD5B3033-02E9-470A-B12B-2A0D7E6D2DDF}
// *********************************************************************//
  IEFPrintTempFileDisp = dispinterface
    ['{FD5B3033-02E9-470A-B12B-2A0D7E6D2DDF}']
    property pfType: TEFTempFileDestination readonly dispid 1;
    property pfFileName: WideString readonly dispid 2;
    function DisplayPreviewWindow(PreviewType: TEFPreviewType): Integer; dispid 3;
    function SendToDestination: Integer; dispid 4;
    property pfPages: Integer readonly dispid 7;
    property pfStartPage: Integer dispid 8;
    property pfFinishPage: Integer dispid 9;
    property pfCopies: Integer dispid 10;
    property pfStatus: Integer readonly dispid 5;
    function SaveAsFile(const FilePath: WideString; FileType: TEFSaveAsType): Integer; dispid 6;
  end;

// *********************************************************************//
// Interface: IEFEmailAddressArray
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CEE29433-313A-431F-8864-F6AADB455442}
// *********************************************************************//
  IEFEmailAddressArray = interface(IDispatch)
    ['{CEE29433-313A-431F-8864-F6AADB455442}']
    function Get_eaItems(Index: Integer): IEFEmailAddress; safecall;
    function Get_eaCount: Integer; safecall;
    function AddAddress(const Name: WideString; const Address: WideString): Integer; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Clear; safecall;
    property eaItems[Index: Integer]: IEFEmailAddress read Get_eaItems; default;
    property eaCount: Integer read Get_eaCount;
  end;

// *********************************************************************//
// DispIntf:  IEFEmailAddressArrayDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CEE29433-313A-431F-8864-F6AADB455442}
// *********************************************************************//
  IEFEmailAddressArrayDisp = dispinterface
    ['{CEE29433-313A-431F-8864-F6AADB455442}']
    property eaItems[Index: Integer]: IEFEmailAddress readonly dispid 0; default;
    property eaCount: Integer readonly dispid 1;
    function AddAddress(const Name: WideString; const Address: WideString): Integer; dispid 2;
    procedure Delete(Index: Integer); dispid 3;
    procedure Clear; dispid 4;
  end;

// *********************************************************************//
// Interface: IEFEmailAddress
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DDBECA5A-C113-4000-934A-E86698606C2F}
// *********************************************************************//
  IEFEmailAddress = interface(IDispatch)
    ['{DDBECA5A-C113-4000-934A-E86698606C2F}']
    function Get_emlName: WideString; safecall;
    procedure Set_emlName(const Value: WideString); safecall;
    function Get_emlAddress: WideString; safecall;
    procedure Set_emlAddress(const Value: WideString); safecall;
    property emlName: WideString read Get_emlName write Set_emlName;
    property emlAddress: WideString read Get_emlAddress write Set_emlAddress;
  end;

// *********************************************************************//
// DispIntf:  IEFEmailAddressDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DDBECA5A-C113-4000-934A-E86698606C2F}
// *********************************************************************//
  IEFEmailAddressDisp = dispinterface
    ['{DDBECA5A-C113-4000-934A-E86698606C2F}']
    property emlName: WideString dispid 1;
    property emlAddress: WideString dispid 2;
  end;

// *********************************************************************//
// Interface: IEFStringListReadWrite
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C59D7991-30E9-4D63-A23B-B2ABDE36019C}
// *********************************************************************//
  IEFStringListReadWrite = interface(IDispatch)
    ['{C59D7991-30E9-4D63-A23B-B2ABDE36019C}']
    function Get_Strings(Index: Integer): WideString; safecall;
    procedure Set_Strings(Index: Integer; const Value: WideString); safecall;
    function Get_Count: Integer; safecall;
    function Add(const AddString: WideString): Integer; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Clear; safecall;
    property Strings[Index: Integer]: WideString read Get_Strings write Set_Strings;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IEFStringListReadWriteDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C59D7991-30E9-4D63-A23B-B2ABDE36019C}
// *********************************************************************//
  IEFStringListReadWriteDisp = dispinterface
    ['{C59D7991-30E9-4D63-A23B-B2ABDE36019C}']
    property Strings[Index: Integer]: WideString dispid 1;
    property Count: Integer readonly dispid 2;
    function Add(const AddString: WideString): Integer; dispid 3;
    procedure Delete(Index: Integer); dispid 4;
    procedure Clear; dispid 5;
  end;

// *********************************************************************//
// Interface: IEFFormDefInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2875ACE3-E4E3-4B52-82E1-DF29A5C1DE60}
// *********************************************************************//
  IEFFormDefInfo = interface(IDispatch)
    ['{2875ACE3-E4E3-4B52-82E1-DF29A5C1DE60}']
    function Get_fiType: TEFFormType; safecall;
    function Get_fiDescription: WideString; safecall;
    function Get_fiCopies: Integer; safecall;
    function Get_fiPaperWidth: Integer; safecall;
    function Get_fiPaperHeight: Integer; safecall;
    function Get_fiPortrait: WordBool; safecall;
    function Get_fiContinuation: WideString; safecall;
    function Get_fiPrinterIndex: Integer; safecall;
    function Get_fiBinIndex: Integer; safecall;
    function Get_fiPaperIndex: Integer; safecall;
    function Get_fiLabelTop: Integer; safecall;
    function Get_fiLabelLeft: Integer; safecall;
    function Get_fiLabelWidth: Integer; safecall;
    function Get_fiLabelHeight: Integer; safecall;
    function Get_fiLabelNoCols: Integer; safecall;
    function Get_fiLabelNorows: Integer; safecall;
    function Get_fiLabelInterColGap: Integer; safecall;
    function Get_fiLabelInterRowGap: Integer; safecall;
    property fiType: TEFFormType read Get_fiType;
    property fiDescription: WideString read Get_fiDescription;
    property fiCopies: Integer read Get_fiCopies;
    property fiPaperWidth: Integer read Get_fiPaperWidth;
    property fiPaperHeight: Integer read Get_fiPaperHeight;
    property fiPortrait: WordBool read Get_fiPortrait;
    property fiContinuation: WideString read Get_fiContinuation;
    property fiPrinterIndex: Integer read Get_fiPrinterIndex;
    property fiBinIndex: Integer read Get_fiBinIndex;
    property fiPaperIndex: Integer read Get_fiPaperIndex;
    property fiLabelTop: Integer read Get_fiLabelTop;
    property fiLabelLeft: Integer read Get_fiLabelLeft;
    property fiLabelWidth: Integer read Get_fiLabelWidth;
    property fiLabelHeight: Integer read Get_fiLabelHeight;
    property fiLabelNoCols: Integer read Get_fiLabelNoCols;
    property fiLabelNorows: Integer read Get_fiLabelNorows;
    property fiLabelInterColGap: Integer read Get_fiLabelInterColGap;
    property fiLabelInterRowGap: Integer read Get_fiLabelInterRowGap;
  end;

// *********************************************************************//
// DispIntf:  IEFFormDefInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2875ACE3-E4E3-4B52-82E1-DF29A5C1DE60}
// *********************************************************************//
  IEFFormDefInfoDisp = dispinterface
    ['{2875ACE3-E4E3-4B52-82E1-DF29A5C1DE60}']
    property fiType: TEFFormType readonly dispid 1;
    property fiDescription: WideString readonly dispid 2;
    property fiCopies: Integer readonly dispid 3;
    property fiPaperWidth: Integer readonly dispid 4;
    property fiPaperHeight: Integer readonly dispid 5;
    property fiPortrait: WordBool readonly dispid 6;
    property fiContinuation: WideString readonly dispid 7;
    property fiPrinterIndex: Integer readonly dispid 8;
    property fiBinIndex: Integer readonly dispid 9;
    property fiPaperIndex: Integer readonly dispid 10;
    property fiLabelTop: Integer readonly dispid 11;
    property fiLabelLeft: Integer readonly dispid 12;
    property fiLabelWidth: Integer readonly dispid 13;
    property fiLabelHeight: Integer readonly dispid 14;
    property fiLabelNoCols: Integer readonly dispid 15;
    property fiLabelNorows: Integer readonly dispid 16;
    property fiLabelInterColGap: Integer readonly dispid 17;
    property fiLabelInterRowGap: Integer readonly dispid 18;
  end;

// *********************************************************************//
// Interface: IEFImportDefaults
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F3B2E301-B487-489D-A4B6-120ED65635ED}
// *********************************************************************//
  IEFImportDefaults = interface(IDispatch)
    ['{F3B2E301-B487-489D-A4B6-120ED65635ED}']
    function Get_idType: TEFImportDefaultsType; safecall;
    procedure Set_idType(Value: TEFImportDefaultsType); safecall;
    function Get_idMainFileNo: Integer; safecall;
    procedure Set_idMainFileNo(Value: Integer); safecall;
    function Get_idMainIndexNo: Integer; safecall;
    procedure Set_idMainIndexNo(Value: Integer); safecall;
    function Get_idMainKeyString: WideString; safecall;
    procedure Set_idMainKeyString(const Value: WideString); safecall;
    function Get_idTableFileNo: Integer; safecall;
    procedure Set_idTableFileNo(Value: Integer); safecall;
    function Get_idTableIndexNo: Integer; safecall;
    procedure Set_idTableIndexNo(Value: Integer); safecall;
    function Get_idTableKeyString: WideString; safecall;
    procedure Set_idTableKeyString(const Value: WideString); safecall;
    procedure ImportDefaults; safecall;
    function Get_idAcCode: WideString; safecall;
    procedure Set_idAcCode(const Value: WideString); safecall;
    procedure AddLabels; safecall;
    property idType: TEFImportDefaultsType read Get_idType write Set_idType;
    property idMainFileNo: Integer read Get_idMainFileNo write Set_idMainFileNo;
    property idMainIndexNo: Integer read Get_idMainIndexNo write Set_idMainIndexNo;
    property idMainKeyString: WideString read Get_idMainKeyString write Set_idMainKeyString;
    property idTableFileNo: Integer read Get_idTableFileNo write Set_idTableFileNo;
    property idTableIndexNo: Integer read Get_idTableIndexNo write Set_idTableIndexNo;
    property idTableKeyString: WideString read Get_idTableKeyString write Set_idTableKeyString;
    property idAcCode: WideString read Get_idAcCode write Set_idAcCode;
  end;

// *********************************************************************//
// DispIntf:  IEFImportDefaultsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F3B2E301-B487-489D-A4B6-120ED65635ED}
// *********************************************************************//
  IEFImportDefaultsDisp = dispinterface
    ['{F3B2E301-B487-489D-A4B6-120ED65635ED}']
    property idType: TEFImportDefaultsType dispid 1;
    property idMainFileNo: Integer dispid 2;
    property idMainIndexNo: Integer dispid 3;
    property idMainKeyString: WideString dispid 4;
    property idTableFileNo: Integer dispid 5;
    property idTableIndexNo: Integer dispid 6;
    property idTableKeyString: WideString dispid 7;
    procedure ImportDefaults; dispid 8;
    property idAcCode: WideString dispid 10;
    procedure AddLabels; dispid 9;
  end;

// *********************************************************************//
// Interface: IEFCustomData
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {668DDA2C-1112-4A65-B66B-3700DC6EAFCB}
// *********************************************************************//
  IEFCustomData = interface(IDispatch)
    ['{668DDA2C-1112-4A65-B66B-3700DC6EAFCB}']
    function Get_cdFileNo: Integer; safecall;
    procedure Set_cdFileNo(Value: Integer); safecall;
    function Get_cdIndexNo: Integer; safecall;
    procedure Set_cdIndexNo(Value: Integer); safecall;
    function Get_cdSortKey: WideString; safecall;
    procedure Set_cdSortKey(const Value: WideString); safecall;
    function Get_cdPosition: Integer; safecall;
    procedure Set_cdPosition(Value: Integer); safecall;
    property cdFileNo: Integer read Get_cdFileNo write Set_cdFileNo;
    property cdIndexNo: Integer read Get_cdIndexNo write Set_cdIndexNo;
    property cdSortKey: WideString read Get_cdSortKey write Set_cdSortKey;
    property cdPosition: Integer read Get_cdPosition write Set_cdPosition;
  end;

// *********************************************************************//
// DispIntf:  IEFCustomDataDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {668DDA2C-1112-4A65-B66B-3700DC6EAFCB}
// *********************************************************************//
  IEFCustomDataDisp = dispinterface
    ['{668DDA2C-1112-4A65-B66B-3700DC6EAFCB}']
    property cdFileNo: Integer dispid 1;
    property cdIndexNo: Integer dispid 2;
    property cdSortKey: WideString dispid 3;
    property cdPosition: Integer dispid 4;
  end;

// *********************************************************************//
// Interface: IEFPrintingToolkit2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DF2C249D-DED7-4FDD-8060-861E0A570E0F}
// *********************************************************************//
  IEFPrintingToolkit2 = interface(IEFPrintingToolkit)
    ['{DF2C249D-DED7-4FDD-8060-861E0A570E0F}']
    procedure Reset; safecall;
    function Get_MemoryUsage: Integer; safecall;
    property MemoryUsage: Integer read Get_MemoryUsage;
  end;

// *********************************************************************//
// DispIntf:  IEFPrintingToolkit2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DF2C249D-DED7-4FDD-8060-861E0A570E0F}
// *********************************************************************//
  IEFPrintingToolkit2Disp = dispinterface
    ['{DF2C249D-DED7-4FDD-8060-861E0A570E0F}']
    procedure Reset; dispid 10;
    property MemoryUsage: Integer readonly dispid 11;
    function OpenPrinting(const ProductName: WideString; const LicenceNo: WideString): Integer; dispid 1;
    function ClosePrinting: Integer; dispid 2;
    property Version: WideString readonly dispid 3;
    property Configuration: IEFConfiguration readonly dispid 4;
    property PrintJob: IEFPrintJob readonly dispid 5;
    property Status: TEFToolkitStatus readonly dispid 6;
    property Printers: IEFPrinters readonly dispid 7;
    property Functions: IEFFunctions readonly dispid 8;
    property LastErrorString: WideString readonly dispid 9;
  end;

// *********************************************************************//
// The Class CoPrintingToolkit provides a Create and CreateRemote method to          
// create instances of the default interface IEFPrintingToolkit exposed by              
// the CoClass PrintingToolkit. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPrintingToolkit = class
    class function Create: IEFPrintingToolkit;
    class function CreateRemote(const MachineName: string): IEFPrintingToolkit;
  end;

implementation

uses ComObj;

class function CoPrintingToolkit.Create: IEFPrintingToolkit;
begin
  Result := CreateComObject(CLASS_PrintingToolkit) as IEFPrintingToolkit;
end;

class function CoPrintingToolkit.CreateRemote(const MachineName: string): IEFPrintingToolkit;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PrintingToolkit) as IEFPrintingToolkit;
end;

end.
