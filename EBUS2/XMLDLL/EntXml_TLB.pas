unit EntXml_TLB;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


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

// PASTLWTR : $Revision:   1.88.1.0.1.0  $
// File generated on 08/05/2001 14:24:15 from Type Library described below.

// ************************************************************************ //
// Type Lib: X:\EBUS2\XMLDLL\TRAN2XML.tlb (1)
// IID\LCID: {2E8FC903-C118-4D49-A451-B4BDDE28992D}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  EntXmlMajorVersion = 1;
  EntXmlMinorVersion = 0;

  LIBID_EntXml: TGUID = '{2E8FC903-C118-4D49-A451-B4BDDE28992D}';

  IID_IXmlTransaction: TGUID = '{9EB29EC9-2D0C-4D8E-B94D-780508A46E27}';
  CLASS_XmlTransaction: TGUID = '{B9D562D0-A7B7-462D-850D-FFA63AFE21BB}';
  IID_IAddress: TGUID = '{709D0EDC-5CCE-4E8B-AD5C-7CC7804A05CF}';
  IID_ITransactionLine: TGUID = '{0B605F0F-F53E-4D85-BDA5-0EFC16CA444F}';
  IID_ITransactionLines: TGUID = '{D5C0DE14-A708-4EFB-99C9-6FB31BA33851}';
  IID_INarrative: TGUID = '{3C6F2B89-073C-47F1-9195-3527B84CBD51}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
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

// Constants for enum TTransactionLineType
type
  TTransactionLineType = TOleEnum;
const
  tlTypeNormal = $00000000;
  tlTypeLabour = $00000001;
  tlTypeMaterials = $00000002;
  tlTypeFreight = $00000003;
  tlTypeDiscount = $00000004;

// Constants for enum TNotesType
type
  TNotesType = TOleEnum;
const
  ntTypeGeneral = $00000000;
  ntTypeDated = $00000001;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IXmlTransaction = interface;
  IXmlTransactionDisp = dispinterface;
  IAddress = interface;
  IAddressDisp = dispinterface;
  ITransactionLine = interface;
  ITransactionLineDisp = dispinterface;
  ITransactionLines = interface;
  ITransactionLinesDisp = dispinterface;
  INarrative = interface;
  INarrativeDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  XmlTransaction = IXmlTransaction;


// *********************************************************************//
// Interface: IXmlTransaction
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9EB29EC9-2D0C-4D8E-B94D-780508A46E27}
// *********************************************************************//
  IXmlTransaction = interface(IDispatch)
    ['{9EB29EC9-2D0C-4D8E-B94D-780508A46E27}']
    function  Get_thOurRef: WideString; safecall;
    procedure Set_thOurRef(const Value: WideString); safecall;
    function  Get_thYourRef: WideString; safecall;
    procedure Set_thYourRef(const Value: WideString); safecall;
    function  Get_thAcCode: WideString; safecall;
    procedure Set_thAcCode(const Value: WideString); safecall;
    function  Get_thRunNo: Integer; safecall;
    function  Get_thFolioNum: Integer; safecall;
    procedure Set_thFolioNum(Value: Integer); safecall;
    function  Get_thCurrency: Smallint; safecall;
    procedure Set_thCurrency(Value: Smallint); safecall;
    function  Get_thYear: Smallint; safecall;
    procedure Set_thYear(Value: Smallint); safecall;
    function  Get_thPeriod: Smallint; safecall;
    procedure Set_thPeriod(Value: Smallint); safecall;
    function  Get_thTransDate: WideString; safecall;
    procedure Set_thTransDate(const Value: WideString); safecall;
    function  Get_thDueDate: WideString; safecall;
    procedure Set_thDueDate(const Value: WideString); safecall;
    function  Get_thCompanyRate: Double; safecall;
    procedure Set_thCompanyRate(Value: Double); safecall;
    function  Get_thDailyRate: Double; safecall;
    procedure Set_thDailyRate(Value: Double); safecall;
    function  Get_thNetValue: Double; safecall;
    procedure Set_thNetValue(Value: Double); safecall;
    function  Get_thTotalVAT: Double; safecall;
    procedure Set_thTotalVAT(Value: Double); safecall;
    function  Get_thSettleDiscPerc: Double; safecall;
    procedure Set_thSettleDiscPerc(Value: Double); safecall;
    function  Get_thSettleDiscAmount: Double; safecall;
    procedure Set_thSettleDiscAmount(Value: Double); safecall;
    function  Get_thTotalLineDiscount: Double; safecall;
    procedure Set_thTotalLineDiscount(Value: Double); safecall;
    function  Get_thSettleDiscDays: Smallint; safecall;
    procedure Set_thSettleDiscDays(Value: Smallint); safecall;
    function  Get_thSettleDiscTaken: WordBool; safecall;
    procedure Set_thSettleDiscTaken(Value: WordBool); safecall;
    function  Get_thAmountSettled: Double; safecall;
    function  Get_thTransportNature: Smallint; safecall;
    procedure Set_thTransportNature(Value: Smallint); safecall;
    function  Get_thTransportMode: Smallint; safecall;
    procedure Set_thTransportMode(Value: Smallint); safecall;
    function  Get_thHoldFlag: Smallint; safecall;
    procedure Set_thHoldFlag(Value: Smallint); safecall;
    function  Get_thTotalWeight: Double; safecall;
    procedure Set_thTotalWeight(Value: Double); safecall;
    function  Get_thDelAddress: IAddress; safecall;
    function  Get_thTotalCost: Double; safecall;
    procedure Set_thTotalCost(Value: Double); safecall;
    function  Get_thPrinted: WordBool; safecall;
    function  Get_thManualVAT: WordBool; safecall;
    procedure Set_thManualVAT(Value: WordBool); safecall;
    function  Get_thDeliveryTerms: WideString; safecall;
    procedure Set_thDeliveryTerms(const Value: WideString); safecall;
    function  Get_thOperator: WideString; safecall;
    procedure Set_thOperator(const Value: WideString); safecall;
    function  Get_thJobCode: WideString; safecall;
    procedure Set_thJobCode(const Value: WideString); safecall;
    function  Get_thAnalysisCode: WideString; safecall;
    procedure Set_thAnalysisCode(const Value: WideString); safecall;
    function  Get_thTotalOrderOS: Double; safecall;
    procedure Set_thTotalOrderOS(Value: Double); safecall;
    function  Get_thUserField1: WideString; safecall;
    procedure Set_thUserField1(const Value: WideString); safecall;
    function  Get_thUserField2: WideString; safecall;
    procedure Set_thUserField2(const Value: WideString); safecall;
    function  Get_thUserField3: WideString; safecall;
    procedure Set_thUserField3(const Value: WideString); safecall;
    function  Get_thUserField4: WideString; safecall;
    procedure Set_thUserField4(const Value: WideString); safecall;
    function  Get_thTagged: WordBool; safecall;
    procedure Set_thTagged(Value: WordBool); safecall;
    function  Get_thNoLabels: Smallint; safecall;
    procedure Set_thNoLabels(Value: Smallint); safecall;
    function  Get_thControlGL: Integer; safecall;
    procedure Set_thControlGL(Value: Integer); safecall;
    function  Get_thSource: Integer; safecall;
    function  Get_thPostedDate: WideString; safecall;
    function  Get_thPORPickSOR: WordBool; safecall;
    procedure Set_thPORPickSOR(Value: WordBool); safecall;
    function  Get_thBatchDiscAmount: Double; safecall;
    procedure Set_thBatchDiscAmount(Value: Double); safecall;
    function  Get_thPrePost: Integer; safecall;
    procedure Set_thPrePost(Value: Integer); safecall;
    function  Get_thOutstanding: WideString; safecall;
    function  Get_thFixedRate: WordBool; safecall;
    procedure Set_thFixedRate(Value: WordBool); safecall;
    function  Get_thLongYourRef: WideString; safecall;
    procedure Set_thLongYourRef(const Value: WideString); safecall;
    function  Get_thEmployeeCode: WideString; safecall;
    procedure Set_thEmployeeCode(const Value: WideString); safecall;
    function  Get_thDocType: TDocTypes; safecall;
    procedure Set_thDocType(Value: TDocTypes); safecall;
    function  Get_thLines: ITransactionLines; safecall;
    procedure WriteXML; safecall;
    function  Get_thXmlOutputDir: WideString; safecall;
    procedure Set_thXmlOutputDir(const Value: WideString); safecall;
    function  Get_thCustSuppAddress: IAddress; safecall;
    function  Get_thOurAddress: IAddress; safecall;
    function  Get_thCustSuppName: WideString; safecall;
    procedure Set_thCustSuppName(const Value: WideString); safecall;
    function  Get_thOurName: WideString; safecall;
    procedure Set_thOurName(const Value: WideString); safecall;
    function  Get_thOurVatReg: WideString; safecall;
    procedure Set_thOurVatReg(const Value: WideString); safecall;
    function  Get_thUseCCDept: WordBool; safecall;
    procedure Set_thUseCCDept(Value: WordBool); safecall;
    function  Get_thXslUrl: WideString; safecall;
    procedure Set_thXslUrl(const Value: WideString); safecall;
    function  Get_thCurrencyCode: WideString; safecall;
    procedure Set_thCurrencyCode(const Value: WideString); safecall;
    function  Get_thCurrencyName: WideString; safecall;
    procedure Set_thCurrencyName(const Value: WideString); safecall;
    function  Get_thContactName: WideString; safecall;
    procedure Set_thContactName(const Value: WideString); safecall;
    function  Get_thContactPhone: WideString; safecall;
    procedure Set_thContactPhone(const Value: WideString); safecall;
    function  Get_thContactFax: WideString; safecall;
    procedure Set_thContactFax(const Value: WideString); safecall;
    function  Get_thPriceDecPlaces: Integer; safecall;
    procedure Set_thPriceDecPlaces(Value: Integer); safecall;
    function  Get_thCostDecPlaces: Integer; safecall;
    procedure Set_thCostDecPlaces(Value: Integer); safecall;
    function  Get_thQuantDecPlaces: Integer; safecall;
    procedure Set_thQuantDecPlaces(Value: Integer); safecall;
    function  Get_thNarrative: INarrative; safecall;
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
    property thSource: Integer read Get_thSource;
    property thPostedDate: WideString read Get_thPostedDate;
    property thPORPickSOR: WordBool read Get_thPORPickSOR write Set_thPORPickSOR;
    property thBatchDiscAmount: Double read Get_thBatchDiscAmount write Set_thBatchDiscAmount;
    property thPrePost: Integer read Get_thPrePost write Set_thPrePost;
    property thOutstanding: WideString read Get_thOutstanding;
    property thFixedRate: WordBool read Get_thFixedRate write Set_thFixedRate;
    property thLongYourRef: WideString read Get_thLongYourRef write Set_thLongYourRef;
    property thEmployeeCode: WideString read Get_thEmployeeCode write Set_thEmployeeCode;
    property thDocType: TDocTypes read Get_thDocType write Set_thDocType;
    property thLines: ITransactionLines read Get_thLines;
    property thXmlOutputDir: WideString read Get_thXmlOutputDir write Set_thXmlOutputDir;
    property thCustSuppAddress: IAddress read Get_thCustSuppAddress;
    property thOurAddress: IAddress read Get_thOurAddress;
    property thCustSuppName: WideString read Get_thCustSuppName write Set_thCustSuppName;
    property thOurName: WideString read Get_thOurName write Set_thOurName;
    property thOurVatReg: WideString read Get_thOurVatReg write Set_thOurVatReg;
    property thUseCCDept: WordBool read Get_thUseCCDept write Set_thUseCCDept;
    property thXslUrl: WideString read Get_thXslUrl write Set_thXslUrl;
    property thCurrencyCode: WideString read Get_thCurrencyCode write Set_thCurrencyCode;
    property thCurrencyName: WideString read Get_thCurrencyName write Set_thCurrencyName;
    property thContactName: WideString read Get_thContactName write Set_thContactName;
    property thContactPhone: WideString read Get_thContactPhone write Set_thContactPhone;
    property thContactFax: WideString read Get_thContactFax write Set_thContactFax;
    property thPriceDecPlaces: Integer read Get_thPriceDecPlaces write Set_thPriceDecPlaces;
    property thCostDecPlaces: Integer read Get_thCostDecPlaces write Set_thCostDecPlaces;
    property thQuantDecPlaces: Integer read Get_thQuantDecPlaces write Set_thQuantDecPlaces;
    property thNarrative: INarrative read Get_thNarrative;
  end;

// *********************************************************************//
// DispIntf:  IXmlTransactionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9EB29EC9-2D0C-4D8E-B94D-780508A46E27}
// *********************************************************************//
  IXmlTransactionDisp = dispinterface
    ['{9EB29EC9-2D0C-4D8E-B94D-780508A46E27}']
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
    property thSource: Integer readonly dispid 44;
    property thPostedDate: WideString readonly dispid 45;
    property thPORPickSOR: WordBool dispid 46;
    property thBatchDiscAmount: Double dispid 47;
    property thPrePost: Integer dispid 48;
    property thOutstanding: WideString readonly dispid 49;
    property thFixedRate: WordBool dispid 50;
    property thLongYourRef: WideString dispid 51;
    property thEmployeeCode: WideString dispid 67;
    property thDocType: TDocTypes dispid 13;
    property thLines: ITransactionLines readonly dispid 14;
    procedure WriteXML; dispid 43;
    property thXmlOutputDir: WideString dispid 52;
    property thCustSuppAddress: IAddress readonly dispid 53;
    property thOurAddress: IAddress readonly dispid 54;
    property thCustSuppName: WideString dispid 55;
    property thOurName: WideString dispid 56;
    property thOurVatReg: WideString dispid 57;
    property thUseCCDept: WordBool dispid 58;
    property thXslUrl: WideString dispid 59;
    property thCurrencyCode: WideString dispid 60;
    property thCurrencyName: WideString dispid 61;
    property thContactName: WideString dispid 62;
    property thContactPhone: WideString dispid 63;
    property thContactFax: WideString dispid 64;
    property thPriceDecPlaces: Integer dispid 65;
    property thCostDecPlaces: Integer dispid 66;
    property thQuantDecPlaces: Integer dispid 68;
    property thNarrative: INarrative readonly dispid 69;
  end;

// *********************************************************************//
// Interface: IAddress
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {709D0EDC-5CCE-4E8B-AD5C-7CC7804A05CF}
// *********************************************************************//
  IAddress = interface(IDispatch)
    ['{709D0EDC-5CCE-4E8B-AD5C-7CC7804A05CF}']
    function  Get_Lines(Index: Integer): WideString; safecall;
    procedure Set_Lines(Index: Integer; const Value: WideString); safecall;
    function  Get_Street1: WideString; safecall;
    procedure Set_Street1(const Value: WideString); safecall;
    function  Get_Street2: WideString; safecall;
    procedure Set_Street2(const Value: WideString); safecall;
    function  Get_Town: WideString; safecall;
    procedure Set_Town(const Value: WideString); safecall;
    function  Get_County: WideString; safecall;
    procedure Set_County(const Value: WideString); safecall;
    function  Get_PostCode: WideString; safecall;
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
// GUID:      {709D0EDC-5CCE-4E8B-AD5C-7CC7804A05CF}
// *********************************************************************//
  IAddressDisp = dispinterface
    ['{709D0EDC-5CCE-4E8B-AD5C-7CC7804A05CF}']
    property Lines[Index: Integer]: WideString dispid 0; default;
    property Street1: WideString dispid 1;
    property Street2: WideString dispid 2;
    property Town: WideString dispid 3;
    property County: WideString dispid 4;
    property PostCode: WideString dispid 5;
    procedure AssignAddress(const Address: IAddress); dispid 6;
  end;

// *********************************************************************//
// Interface: ITransactionLine
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0B605F0F-F53E-4D85-BDA5-0EFC16CA444F}
// *********************************************************************//
  ITransactionLine = interface(IDispatch)
    ['{0B605F0F-F53E-4D85-BDA5-0EFC16CA444F}']
    function  Get_tlLineNo: Integer; safecall;
    procedure Set_tlLineNo(Value: Integer); safecall;
    function  Get_tlGLCode: Integer; safecall;
    procedure Set_tlGLCode(Value: Integer); safecall;
    function  Get_tlCurrency: Integer; safecall;
    procedure Set_tlCurrency(Value: Integer); safecall;
    function  Get_tlCompanyRate: Double; safecall;
    procedure Set_tlCompanyRate(Value: Double); safecall;
    function  Get_tlDailyRate: Double; safecall;
    procedure Set_tlDailyRate(Value: Double); safecall;
    function  Get_tlCostCentre: WideString; safecall;
    procedure Set_tlCostCentre(const Value: WideString); safecall;
    function  Get_tlDepartment: WideString; safecall;
    procedure Set_tlDepartment(const Value: WideString); safecall;
    function  Get_tlStockCode: WideString; safecall;
    procedure Set_tlStockCode(const Value: WideString); safecall;
    function  Get_tlQty: Double; safecall;
    procedure Set_tlQty(Value: Double); safecall;
    function  Get_tlQtyMul: Double; safecall;
    procedure Set_tlQtyMul(Value: Double); safecall;
    function  Get_tlNetValue: Double; safecall;
    procedure Set_tlNetValue(Value: Double); safecall;
    function  Get_tlDiscount: Double; safecall;
    procedure Set_tlDiscount(Value: Double); safecall;
    function  Get_tlDiscFlag: WideString; safecall;
    procedure Set_tlDiscFlag(const Value: WideString); safecall;
    function  Get_tlVATCode: WideString; safecall;
    procedure Set_tlVATCode(const Value: WideString); safecall;
    function  Get_tlVATAmount: Double; safecall;
    procedure Set_tlVATAmount(Value: Double); safecall;
    function  Get_tlPayment: WordBool; safecall;
    procedure Set_tlPayment(Value: WordBool); safecall;
    function  Get_tlQtyWOFF: Double; safecall;
    procedure Set_tlQtyWOFF(Value: Double); safecall;
    function  Get_tlQtyDel: Double; safecall;
    procedure Set_tlQtyDel(Value: Double); safecall;
    function  Get_tlCost: Double; safecall;
    procedure Set_tlCost(Value: Double); safecall;
    function  Get_tlLineDate: WideString; safecall;
    procedure Set_tlLineDate(const Value: WideString); safecall;
    function  Get_tlItemNo: WideString; safecall;
    procedure Set_tlItemNo(const Value: WideString); safecall;
    function  Get_tlDescr: WideString; safecall;
    procedure Set_tlDescr(const Value: WideString); safecall;
    function  Get_tlJobCode: WideString; safecall;
    procedure Set_tlJobCode(const Value: WideString); safecall;
    function  Get_tlAnalysisCode: WideString; safecall;
    procedure Set_tlAnalysisCode(const Value: WideString); safecall;
    function  Get_tlUnitWeight: Double; safecall;
    procedure Set_tlUnitWeight(Value: Double); safecall;
    function  Get_tlLocation: WideString; safecall;
    procedure Set_tlLocation(const Value: WideString); safecall;
    function  Get_tlChargeCurrency: Integer; safecall;
    procedure Set_tlChargeCurrency(Value: Integer); safecall;
    function  Get_tlAcCode: WideString; safecall;
    function  Get_tlLineType: TTransactionLineType; safecall;
    procedure Set_tlLineType(Value: TTransactionLineType); safecall;
    function  Get_tlFolioNum: Integer; safecall;
    function  Get_tlLineClass: WideString; safecall;
    function  Get_tlRecStatus: Smallint; safecall;
    procedure Set_tlRecStatus(Value: Smallint); safecall;
    function  Get_tlSOPFolioNum: Integer; safecall;
    procedure Set_tlSOPFolioNum(Value: Integer); safecall;
    function  Get_tlSOPABSLineNo: Integer; safecall;
    procedure Set_tlSOPABSLineNo(Value: Integer); safecall;
    function  Get_tlABSLineNo: Integer; safecall;
    function  Get_tlUserField1: WideString; safecall;
    procedure Set_tlUserField1(const Value: WideString); safecall;
    function  Get_tlUserField2: WideString; safecall;
    procedure Set_tlUserField2(const Value: WideString); safecall;
    function  Get_tlUserField3: WideString; safecall;
    procedure Set_tlUserField3(const Value: WideString); safecall;
    function  Get_tlUserField4: WideString; safecall;
    procedure Set_tlUserField4(const Value: WideString); safecall;
    function  Get_tlSSDUpliftPerc: Double; safecall;
    procedure Set_tlSSDUpliftPerc(Value: Double); safecall;
    function  Get_tlSSDCommodCode: WideString; safecall;
    procedure Set_tlSSDCommodCode(const Value: WideString); safecall;
    function  Get_tlSSDSalesUnit: Double; safecall;
    procedure Set_tlSSDSalesUnit(Value: Double); safecall;
    function  Get_tlSSDUseLineValues: WordBool; safecall;
    procedure Set_tlSSDUseLineValues(Value: WordBool); safecall;
    function  Get_tlPriceMultiplier: Double; safecall;
    procedure Set_tlPriceMultiplier(Value: Double); safecall;
    function  Get_tlQtyPicked: Double; safecall;
    procedure Set_tlQtyPicked(Value: Double); safecall;
    function  Get_tlQtyPickedWO: Double; safecall;
    procedure Set_tlQtyPickedWO(Value: Double); safecall;
    function  Get_tlSSDCountry: WideString; safecall;
    procedure Set_tlSSDCountry(const Value: WideString); safecall;
    function  Get_tlInclusiveVATCode: WideString; safecall;
    procedure Set_tlInclusiveVATCode(const Value: WideString); safecall;
    function  Get_tlBOMKitLink: Integer; safecall;
    procedure Set_tlBOMKitLink(Value: Integer); safecall;
    function  Get_tlOurRef: WideString; safecall;
    procedure Save; safecall;
    function  Get_tlVatRate: Double; safecall;
    procedure Set_tlVatRate(Value: Double); safecall;
    function  Get_tlWeight: Double; safecall;
    procedure Set_tlWeight(Value: Double); safecall;
    function  Get_tlUOMQuantityDesc: WideString; safecall;
    procedure Set_tlUOMQuantityDesc(const Value: WideString); safecall;
    function  Get_tlUOMPriceDesc: WideString; safecall;
    procedure Set_tlUOMPriceDesc(const Value: WideString); safecall;
    function  Get_tlLineTotal: Double; safecall;
    procedure Set_tlLineTotal(Value: Double); safecall;
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
    property tlVatRate: Double read Get_tlVatRate write Set_tlVatRate;
    property tlWeight: Double read Get_tlWeight write Set_tlWeight;
    property tlUOMQuantityDesc: WideString read Get_tlUOMQuantityDesc write Set_tlUOMQuantityDesc;
    property tlUOMPriceDesc: WideString read Get_tlUOMPriceDesc write Set_tlUOMPriceDesc;
    property tlLineTotal: Double read Get_tlLineTotal write Set_tlLineTotal;
  end;

// *********************************************************************//
// DispIntf:  ITransactionLineDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0B605F0F-F53E-4D85-BDA5-0EFC16CA444F}
// *********************************************************************//
  ITransactionLineDisp = dispinterface
    ['{0B605F0F-F53E-4D85-BDA5-0EFC16CA444F}']
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
    procedure Save; dispid 52;
    property tlVatRate: Double dispid 53;
    property tlWeight: Double dispid 50;
    property tlUOMQuantityDesc: WideString dispid 54;
    property tlUOMPriceDesc: WideString dispid 55;
    property tlLineTotal: Double dispid 56;
  end;

// *********************************************************************//
// Interface: ITransactionLines
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D5C0DE14-A708-4EFB-99C9-6FB31BA33851}
// *********************************************************************//
  ITransactionLines = interface(IDispatch)
    ['{D5C0DE14-A708-4EFB-99C9-6FB31BA33851}']
    function  Get_thLine(Index: Integer): ITransactionLine; safecall;
    function  Get_thLineCount: Integer; safecall;
    procedure Delete(Index: Integer); safecall;
    function  Add: ITransactionLine; safecall;
    property thLine[Index: Integer]: ITransactionLine read Get_thLine; default;
    property thLineCount: Integer read Get_thLineCount;
  end;

// *********************************************************************//
// DispIntf:  ITransactionLinesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D5C0DE14-A708-4EFB-99C9-6FB31BA33851}
// *********************************************************************//
  ITransactionLinesDisp = dispinterface
    ['{D5C0DE14-A708-4EFB-99C9-6FB31BA33851}']
    property thLine[Index: Integer]: ITransactionLine readonly dispid 0; default;
    property thLineCount: Integer readonly dispid 1;
    procedure Delete(Index: Integer); dispid 2;
    function  Add: ITransactionLine; dispid 4;
  end;

// *********************************************************************//
// Interface: INarrative
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3C6F2B89-073C-47F1-9195-3527B84CBD51}
// *********************************************************************//
  INarrative = interface(IDispatch)
    ['{3C6F2B89-073C-47F1-9195-3527B84CBD51}']
    function  Get_ntLine(Index: Integer): WideString; safecall;
    function  Get_ntLineCount: Integer; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Add(const Value: WideString); safecall;
    property ntLine[Index: Integer]: WideString read Get_ntLine;
    property ntLineCount: Integer read Get_ntLineCount;
  end;

// *********************************************************************//
// DispIntf:  INarrativeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3C6F2B89-073C-47F1-9195-3527B84CBD51}
// *********************************************************************//
  INarrativeDisp = dispinterface
    ['{3C6F2B89-073C-47F1-9195-3527B84CBD51}']
    property ntLine[Index: Integer]: WideString readonly dispid 1;
    property ntLineCount: Integer readonly dispid 2;
    procedure Delete(Index: Integer); dispid 3;
    procedure Add(const Value: WideString); dispid 4;
  end;

// *********************************************************************//
// The Class CoXmlTransaction provides a Create and CreateRemote method to          
// create instances of the default interface IXmlTransaction exposed by              
// the CoClass XmlTransaction. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoXmlTransaction = class
    class function Create: IXmlTransaction;
    class function CreateRemote(const MachineName: string): IXmlTransaction;
  end;

implementation

uses ComObj;

class function CoXmlTransaction.Create: IXmlTransaction;
begin
  Result := CreateComObject(CLASS_XmlTransaction) as IXmlTransaction;
end;

class function CoXmlTransaction.CreateRemote(const MachineName: string): IXmlTransaction;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XmlTransaction) as IXmlTransaction;
end;

end.
