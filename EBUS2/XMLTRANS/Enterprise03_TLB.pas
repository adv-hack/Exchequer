unit Enterprise03_TLB;

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
// File generated on 05/06/2015 15:48:55 from Type Library described below.

// ************************************************************************  //
// Type Lib: W:\EBUS2\XMLTRANS\XMLWRITE.tlb (1)
// LIBID: {6771452B-98B8-4DF4-892B-A1F57BDEADB8}
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
  Enterprise03MajorVersion = 1;
  Enterprise03MinorVersion = 0;

  LIBID_Enterprise03: TGUID = '{6771452B-98B8-4DF4-892B-A1F57BDEADB8}';

  IID_IXmlWriter: TGUID = '{3FCDC51F-DBA1-4C0F-AFE7-894AE90012EB}';
  IID_IXmlNarrative: TGUID = '{821E3B23-D2CD-4F3B-A5CD-D814EED8CE87}';
  IID_IXmlTransactionLine: TGUID = '{C977929F-5508-4BDF-8E44-8A13BC5CB216}';
  IID_IXmlTransactionLines: TGUID = '{3761A5F8-8461-45D5-A65B-6CE65D4A4BAF}';
  IID_IxmlAddress: TGUID = '{37485C57-34BF-4214-B358-D8D9115F68EE}';
  CLASS_XmlWriter: TGUID = '{519A061F-C5E3-4492-8B19-04242964E46D}';
  IID_IXmlTransaction: TGUID = '{37A5C19A-C57B-4985-93F0-7B658B34C503}';
  IID_IXmlSerialBatchDetails: TGUID = '{E088C6A2-67CF-4D7A-9D42-03C5DB5DBB74}';
  IID_IXmlSerialBatch: TGUID = '{F0EDD7AC-E2A9-48B1-934F-C57643DE9F65}';
  IID_IXmlConfiguration: TGUID = '{92FBDC61-80E2-4763-AA70-0EC865F47A9B}';
  IID_IXmlTransaction2: TGUID = '{7A22B160-30D0-47DC-942A-9B40FEDA05A4}';
  IID_IXMLConfiguration2: TGUID = '{CA3C0B75-AC9C-420E-9762-75FDDB44D272}';
  IID_IXMLConfiguration3: TGUID = '{E178B4F9-C61D-4DE4-9D0B-1F7636CF7BD1}';
  IID_IXMLTransaction3: TGUID = '{C3B337FC-AF72-45F6-93C6-750DB62A52B2}';
  IID_IXMLTransaction4: TGUID = '{F6A602C8-A6E6-4163-9955-FC4349E4071B}';
  IID_IXMLTransaction5: TGUID = '{1FBE4D20-8C01-43BB-828D-20A72FEA1042}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TXmlTransactionLineType
type
  TXmlTransactionLineType = TOleEnum;
const
  tlTypeNormal = $00000000;
  tlTypeLabour = $00000001;
  tlTypeMaterials = $00000002;
  tlTypeFreight = $00000003;
  tlTypeDiscount = $00000004;

// Constants for enum TxmlDocTypes
type
  TxmlDocTypes = TOleEnum;
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

// Constants for enum TxmlSerialBatchType
type
  TxmlSerialBatchType = TOleEnum;
const
  snTypeSerial = $00000000;
  snTypeBatch = $00000001;

// Constants for enum TxmlTransferMode
type
  TxmlTransferMode = TOleEnum;
const
  xrExchange = $00000000;
  xrReplication = $00000001;

// Constants for enum TPPDTakenMode
type
  TPPDTakenMode = TOleEnum;
const
  ptPPDNotTaken = $00000000;
  ptPPDTaken = $00000001;
  ptPPDTakenOutsideTerms = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IXmlWriter = interface;
  IXmlWriterDisp = dispinterface;
  IXmlNarrative = interface;
  IXmlNarrativeDisp = dispinterface;
  IXmlTransactionLine = interface;
  IXmlTransactionLineDisp = dispinterface;
  IXmlTransactionLines = interface;
  IXmlTransactionLinesDisp = dispinterface;
  IxmlAddress = interface;
  IxmlAddressDisp = dispinterface;
  IXmlTransaction = interface;
  IXmlTransactionDisp = dispinterface;
  IXmlSerialBatchDetails = interface;
  IXmlSerialBatchDetailsDisp = dispinterface;
  IXmlSerialBatch = interface;
  IXmlSerialBatchDisp = dispinterface;
  IXmlConfiguration = interface;
  IXmlConfigurationDisp = dispinterface;
  IXmlTransaction2 = interface;
  IXmlTransaction2Disp = dispinterface;
  IXMLConfiguration2 = interface;
  IXMLConfiguration2Disp = dispinterface;
  IXMLConfiguration3 = interface;
  IXMLConfiguration3Disp = dispinterface;
  IXMLTransaction3 = interface;
  IXMLTransaction3Disp = dispinterface;
  IXMLTransaction4 = interface;
  IXMLTransaction4Disp = dispinterface;
  IXMLTransaction5 = interface;
  IXMLTransaction5Disp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  XmlWriter = IXmlWriter;


// *********************************************************************//
// Interface: IXmlWriter
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3FCDC51F-DBA1-4C0F-AFE7-894AE90012EB}
// *********************************************************************//
  IXmlWriter = interface(IDispatch)
    ['{3FCDC51F-DBA1-4C0F-AFE7-894AE90012EB}']
    function Get_Transaction: IXmlTransaction; safecall;
    function Get_Version: WideString; safecall;
    function Get_Configuration: IXmlConfiguration; safecall;
    property Transaction: IXmlTransaction read Get_Transaction;
    property Version: WideString read Get_Version;
    property Configuration: IXmlConfiguration read Get_Configuration;
  end;

// *********************************************************************//
// DispIntf:  IXmlWriterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3FCDC51F-DBA1-4C0F-AFE7-894AE90012EB}
// *********************************************************************//
  IXmlWriterDisp = dispinterface
    ['{3FCDC51F-DBA1-4C0F-AFE7-894AE90012EB}']
    property Transaction: IXmlTransaction readonly dispid 0;
    property Version: WideString readonly dispid 1;
    property Configuration: IXmlConfiguration readonly dispid 2;
  end;

// *********************************************************************//
// Interface: IXmlNarrative
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {821E3B23-D2CD-4F3B-A5CD-D814EED8CE87}
// *********************************************************************//
  IXmlNarrative = interface(IDispatch)
    ['{821E3B23-D2CD-4F3B-A5CD-D814EED8CE87}']
    function Get_ntLine(Index: Integer): WideString; safecall;
    function Get_ntLineCount: Integer; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Add(const Value: WideString); safecall;
    property ntLine[Index: Integer]: WideString read Get_ntLine;
    property ntLineCount: Integer read Get_ntLineCount;
  end;

// *********************************************************************//
// DispIntf:  IXmlNarrativeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {821E3B23-D2CD-4F3B-A5CD-D814EED8CE87}
// *********************************************************************//
  IXmlNarrativeDisp = dispinterface
    ['{821E3B23-D2CD-4F3B-A5CD-D814EED8CE87}']
    property ntLine[Index: Integer]: WideString readonly dispid 1;
    property ntLineCount: Integer readonly dispid 2;
    procedure Delete(Index: Integer); dispid 3;
    procedure Add(const Value: WideString); dispid 4;
  end;

// *********************************************************************//
// Interface: IXmlTransactionLine
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C977929F-5508-4BDF-8E44-8A13BC5CB216}
// *********************************************************************//
  IXmlTransactionLine = interface(IDispatch)
    ['{C977929F-5508-4BDF-8E44-8A13BC5CB216}']
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
    function Get_tlLineType: TXmlTransactionLineType; safecall;
    procedure Set_tlLineType(Value: TXmlTransactionLineType); safecall;
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
    procedure Save; safecall;
    function Get_tlVatRate: Double; safecall;
    procedure Set_tlVatRate(Value: Double); safecall;
    function Get_tlUOMQuantityDesc: WideString; safecall;
    procedure Set_tlUOMQuantityDesc(const Value: WideString); safecall;
    function Get_tlUOMPriceDesc: WideString; safecall;
    procedure Set_tlUOMPriceDesc(const Value: WideString); safecall;
    function Get_tlLineTotal: Double; safecall;
    procedure Set_tlLineTotal(Value: Double); safecall;
    function Get_tlXmlSerialBatch: IXmlSerialBatch; safecall;
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
    property tlLineType: TXmlTransactionLineType read Get_tlLineType write Set_tlLineType;
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
    property tlUOMQuantityDesc: WideString read Get_tlUOMQuantityDesc write Set_tlUOMQuantityDesc;
    property tlUOMPriceDesc: WideString read Get_tlUOMPriceDesc write Set_tlUOMPriceDesc;
    property tlLineTotal: Double read Get_tlLineTotal write Set_tlLineTotal;
    property tlXmlSerialBatch: IXmlSerialBatch read Get_tlXmlSerialBatch;
  end;

// *********************************************************************//
// DispIntf:  IXmlTransactionLineDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C977929F-5508-4BDF-8E44-8A13BC5CB216}
// *********************************************************************//
  IXmlTransactionLineDisp = dispinterface
    ['{C977929F-5508-4BDF-8E44-8A13BC5CB216}']
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
    property tlLineType: TXmlTransactionLineType dispid 29;
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
    property tlUOMQuantityDesc: WideString dispid 54;
    property tlUOMPriceDesc: WideString dispid 55;
    property tlLineTotal: Double dispid 56;
    property tlXmlSerialBatch: IXmlSerialBatch readonly dispid 50;
  end;

// *********************************************************************//
// Interface: IXmlTransactionLines
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3761A5F8-8461-45D5-A65B-6CE65D4A4BAF}
// *********************************************************************//
  IXmlTransactionLines = interface(IDispatch)
    ['{3761A5F8-8461-45D5-A65B-6CE65D4A4BAF}']
    function Get_thLine(Index: Integer): IXmlTransactionLine; safecall;
    function Get_thLineCount: Integer; safecall;
    procedure Delete(Index: Integer); safecall;
    function Add: IXmlTransactionLine; safecall;
    property thLine[Index: Integer]: IXmlTransactionLine read Get_thLine; default;
    property thLineCount: Integer read Get_thLineCount;
  end;

// *********************************************************************//
// DispIntf:  IXmlTransactionLinesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3761A5F8-8461-45D5-A65B-6CE65D4A4BAF}
// *********************************************************************//
  IXmlTransactionLinesDisp = dispinterface
    ['{3761A5F8-8461-45D5-A65B-6CE65D4A4BAF}']
    property thLine[Index: Integer]: IXmlTransactionLine readonly dispid 0; default;
    property thLineCount: Integer readonly dispid 1;
    procedure Delete(Index: Integer); dispid 2;
    function Add: IXmlTransactionLine; dispid 4;
  end;

// *********************************************************************//
// Interface: IxmlAddress
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {37485C57-34BF-4214-B358-D8D9115F68EE}
// *********************************************************************//
  IxmlAddress = interface(IDispatch)
    ['{37485C57-34BF-4214-B358-D8D9115F68EE}']
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
    procedure AssignAddress(const Address: IxmlAddress); safecall;
    property Lines[Index: Integer]: WideString read Get_Lines write Set_Lines; default;
    property Street1: WideString read Get_Street1 write Set_Street1;
    property Street2: WideString read Get_Street2 write Set_Street2;
    property Town: WideString read Get_Town write Set_Town;
    property County: WideString read Get_County write Set_County;
    property PostCode: WideString read Get_PostCode write Set_PostCode;
  end;

// *********************************************************************//
// DispIntf:  IxmlAddressDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {37485C57-34BF-4214-B358-D8D9115F68EE}
// *********************************************************************//
  IxmlAddressDisp = dispinterface
    ['{37485C57-34BF-4214-B358-D8D9115F68EE}']
    property Lines[Index: Integer]: WideString dispid 0; default;
    property Street1: WideString dispid 1;
    property Street2: WideString dispid 2;
    property Town: WideString dispid 3;
    property County: WideString dispid 4;
    property PostCode: WideString dispid 5;
    procedure AssignAddress(const Address: IxmlAddress); dispid 6;
  end;

// *********************************************************************//
// Interface: IXmlTransaction
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {37A5C19A-C57B-4985-93F0-7B658B34C503}
// *********************************************************************//
  IXmlTransaction = interface(IDispatch)
    ['{37A5C19A-C57B-4985-93F0-7B658B34C503}']
    function Get_thOurRef: WideString; safecall;
    procedure Set_thOurRef(const Value: WideString); safecall;
    function Get_thYourRef: WideString; safecall;
    procedure Set_thYourRef(const Value: WideString); safecall;
    function Get_thAcCode: WideString; safecall;
    procedure Set_thAcCode(const Value: WideString); safecall;
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
    function Get_thDelAddress: IxmlAddress; safecall;
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
    function Get_thDocType: TxmlDocTypes; safecall;
    procedure Set_thDocType(Value: TxmlDocTypes); safecall;
    function Get_thLines: IXmlTransactionLines; safecall;
    procedure WriteXML(const APath: WideString); safecall;
    function Get_thCustSuppAddress: IxmlAddress; safecall;
    function Get_thOurAddress: IxmlAddress; safecall;
    function Get_thCustSuppName: WideString; safecall;
    procedure Set_thCustSuppName(const Value: WideString); safecall;
    function Get_thOurName: WideString; safecall;
    procedure Set_thOurName(const Value: WideString); safecall;
    function Get_thOurVatReg: WideString; safecall;
    procedure Set_thOurVatReg(const Value: WideString); safecall;
    function Get_thUseCCDept: WordBool; safecall;
    procedure Set_thUseCCDept(Value: WordBool); safecall;
    function Get_thXslUrl: WideString; safecall;
    procedure Set_thXslUrl(const Value: WideString); safecall;
    function Get_thCurrencyCode: WideString; safecall;
    procedure Set_thCurrencyCode(const Value: WideString); safecall;
    function Get_thCurrencyName: WideString; safecall;
    procedure Set_thCurrencyName(const Value: WideString); safecall;
    function Get_thContactName: WideString; safecall;
    procedure Set_thContactName(const Value: WideString); safecall;
    function Get_thContactPhone: WideString; safecall;
    procedure Set_thContactPhone(const Value: WideString); safecall;
    function Get_thContactFax: WideString; safecall;
    procedure Set_thContactFax(const Value: WideString); safecall;
    function Get_thPriceDecPlaces: Integer; safecall;
    procedure Set_thPriceDecPlaces(Value: Integer); safecall;
    function Get_thCostDecPlaces: Integer; safecall;
    procedure Set_thCostDecPlaces(Value: Integer); safecall;
    function Get_thQuantDecPlaces: Integer; safecall;
    procedure Set_thQuantDecPlaces(Value: Integer); safecall;
    function Get_thNarrative: IXmlNarrative; safecall;
    procedure Clear; safecall;
    function Get_thContactPhone2: WideString; safecall;
    procedure Set_thContactPhone2(const Value: WideString); safecall;
    function Get_thTheirCodeForUs: WideString; safecall;
    procedure Set_thTheirCodeForUs(const Value: WideString); safecall;
    property thOurRef: WideString read Get_thOurRef write Set_thOurRef;
    property thYourRef: WideString read Get_thYourRef write Set_thYourRef;
    property thAcCode: WideString read Get_thAcCode write Set_thAcCode;
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
    property thDelAddress: IxmlAddress read Get_thDelAddress;
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
    property thDocType: TxmlDocTypes read Get_thDocType write Set_thDocType;
    property thLines: IXmlTransactionLines read Get_thLines;
    property thCustSuppAddress: IxmlAddress read Get_thCustSuppAddress;
    property thOurAddress: IxmlAddress read Get_thOurAddress;
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
    property thNarrative: IXmlNarrative read Get_thNarrative;
    property thContactPhone2: WideString read Get_thContactPhone2 write Set_thContactPhone2;
    property thTheirCodeForUs: WideString read Get_thTheirCodeForUs write Set_thTheirCodeForUs;
  end;

// *********************************************************************//
// DispIntf:  IXmlTransactionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {37A5C19A-C57B-4985-93F0-7B658B34C503}
// *********************************************************************//
  IXmlTransactionDisp = dispinterface
    ['{37A5C19A-C57B-4985-93F0-7B658B34C503}']
    property thOurRef: WideString dispid 1;
    property thYourRef: WideString dispid 2;
    property thAcCode: WideString dispid 3;
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
    property thDelAddress: IxmlAddress readonly dispid 27;
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
    property thDocType: TxmlDocTypes dispid 13;
    property thLines: IXmlTransactionLines readonly dispid 14;
    procedure WriteXML(const APath: WideString); dispid 43;
    property thCustSuppAddress: IxmlAddress readonly dispid 53;
    property thOurAddress: IxmlAddress readonly dispid 54;
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
    property thNarrative: IXmlNarrative readonly dispid 69;
    procedure Clear; dispid 70;
    property thContactPhone2: WideString dispid 71;
    property thTheirCodeForUs: WideString dispid 4;
  end;

// *********************************************************************//
// Interface: IXmlSerialBatchDetails
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E088C6A2-67CF-4D7A-9D42-03C5DB5DBB74}
// *********************************************************************//
  IXmlSerialBatchDetails = interface(IDispatch)
    ['{E088C6A2-67CF-4D7A-9D42-03C5DB5DBB74}']
    function Get_snType: TxmlSerialBatchType; safecall;
    procedure Set_snType(Value: TxmlSerialBatchType); safecall;
    function Get_snSerialNo: WideString; safecall;
    procedure Set_snSerialNo(const Value: WideString); safecall;
    function Get_snBatchNo: WideString; safecall;
    procedure Set_snBatchNo(const Value: WideString); safecall;
    function Get_snQtyUsed: Double; safecall;
    procedure Set_snQtyUsed(Value: Double); safecall;
    property snType: TxmlSerialBatchType read Get_snType write Set_snType;
    property snSerialNo: WideString read Get_snSerialNo write Set_snSerialNo;
    property snBatchNo: WideString read Get_snBatchNo write Set_snBatchNo;
    property snQtyUsed: Double read Get_snQtyUsed write Set_snQtyUsed;
  end;

// *********************************************************************//
// DispIntf:  IXmlSerialBatchDetailsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E088C6A2-67CF-4D7A-9D42-03C5DB5DBB74}
// *********************************************************************//
  IXmlSerialBatchDetailsDisp = dispinterface
    ['{E088C6A2-67CF-4D7A-9D42-03C5DB5DBB74}']
    property snType: TxmlSerialBatchType dispid 1;
    property snSerialNo: WideString dispid 2;
    property snBatchNo: WideString dispid 3;
    property snQtyUsed: Double dispid 4;
  end;

// *********************************************************************//
// Interface: IXmlSerialBatch
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F0EDD7AC-E2A9-48B1-934F-C57643DE9F65}
// *********************************************************************//
  IXmlSerialBatch = interface(IDispatch)
    ['{F0EDD7AC-E2A9-48B1-934F-C57643DE9F65}']
    function Get_sbLine(Index: Integer): IXmlSerialBatchDetails; safecall;
    function Get_sbLineCount: Integer; safecall;
    procedure Delete(Index: Integer); safecall;
    function Add: IXmlSerialBatchDetails; safecall;
    property sbLine[Index: Integer]: IXmlSerialBatchDetails read Get_sbLine;
    property sbLineCount: Integer read Get_sbLineCount;
  end;

// *********************************************************************//
// DispIntf:  IXmlSerialBatchDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F0EDD7AC-E2A9-48B1-934F-C57643DE9F65}
// *********************************************************************//
  IXmlSerialBatchDisp = dispinterface
    ['{F0EDD7AC-E2A9-48B1-934F-C57643DE9F65}']
    property sbLine[Index: Integer]: IXmlSerialBatchDetails readonly dispid 1;
    property sbLineCount: Integer readonly dispid 2;
    procedure Delete(Index: Integer); dispid 3;
    function Add: IXmlSerialBatchDetails; dispid 4;
  end;

// *********************************************************************//
// Interface: IXmlConfiguration
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92FBDC61-80E2-4763-AA70-0EC865F47A9B}
// *********************************************************************//
  IXmlConfiguration = interface(IDispatch)
    ['{92FBDC61-80E2-4763-AA70-0EC865F47A9B}']
    function Get_DefaultOutputDirectory: WideString; safecall;
    procedure Set_DefaultOutputDirectory(const Value: WideString); safecall;
    function Get_XslUrl: WideString; safecall;
    procedure Set_XslUrl(const Value: WideString); safecall;
    property DefaultOutputDirectory: WideString read Get_DefaultOutputDirectory write Set_DefaultOutputDirectory;
    property XslUrl: WideString read Get_XslUrl write Set_XslUrl;
  end;

// *********************************************************************//
// DispIntf:  IXmlConfigurationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92FBDC61-80E2-4763-AA70-0EC865F47A9B}
// *********************************************************************//
  IXmlConfigurationDisp = dispinterface
    ['{92FBDC61-80E2-4763-AA70-0EC865F47A9B}']
    property DefaultOutputDirectory: WideString dispid 1;
    property XslUrl: WideString dispid 2;
  end;

// *********************************************************************//
// Interface: IXmlTransaction2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7A22B160-30D0-47DC-942A-9B40FEDA05A4}
// *********************************************************************//
  IXmlTransaction2 = interface(IXmlTransaction)
    ['{7A22B160-30D0-47DC-942A-9B40FEDA05A4}']
    function Get_thTagNo: Integer; safecall;
    procedure Set_thTagNo(Value: Integer); safecall;
    property thTagNo: Integer read Get_thTagNo write Set_thTagNo;
  end;

// *********************************************************************//
// DispIntf:  IXmlTransaction2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7A22B160-30D0-47DC-942A-9B40FEDA05A4}
// *********************************************************************//
  IXmlTransaction2Disp = dispinterface
    ['{7A22B160-30D0-47DC-942A-9B40FEDA05A4}']
    property thTagNo: Integer dispid 52;
    property thOurRef: WideString dispid 1;
    property thYourRef: WideString dispid 2;
    property thAcCode: WideString dispid 3;
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
    property thDelAddress: IxmlAddress readonly dispid 27;
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
    property thDocType: TxmlDocTypes dispid 13;
    property thLines: IXmlTransactionLines readonly dispid 14;
    procedure WriteXML(const APath: WideString); dispid 43;
    property thCustSuppAddress: IxmlAddress readonly dispid 53;
    property thOurAddress: IxmlAddress readonly dispid 54;
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
    property thNarrative: IXmlNarrative readonly dispid 69;
    procedure Clear; dispid 70;
    property thContactPhone2: WideString dispid 71;
    property thTheirCodeForUs: WideString dispid 4;
  end;

// *********************************************************************//
// Interface: IXMLConfiguration2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CA3C0B75-AC9C-420E-9762-75FDDB44D272}
// *********************************************************************//
  IXMLConfiguration2 = interface(IXmlConfiguration)
    ['{CA3C0B75-AC9C-420E-9762-75FDDB44D272}']
    function Get_Debug: WordBool; safecall;
    procedure Set_Debug(Value: WordBool); safecall;
    property Debug: WordBool read Get_Debug write Set_Debug;
  end;

// *********************************************************************//
// DispIntf:  IXMLConfiguration2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CA3C0B75-AC9C-420E-9762-75FDDB44D272}
// *********************************************************************//
  IXMLConfiguration2Disp = dispinterface
    ['{CA3C0B75-AC9C-420E-9762-75FDDB44D272}']
    property Debug: WordBool dispid 3;
    property DefaultOutputDirectory: WideString dispid 1;
    property XslUrl: WideString dispid 2;
  end;

// *********************************************************************//
// Interface: IXMLConfiguration3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E178B4F9-C61D-4DE4-9D0B-1F7636CF7BD1}
// *********************************************************************//
  IXMLConfiguration3 = interface(IDispatch)
    ['{E178B4F9-C61D-4DE4-9D0B-1F7636CF7BD1}']
    function Get_TransferMode: TxmlTransferMode; safecall;
    procedure Set_TransferMode(Value: TxmlTransferMode); safecall;
    property TransferMode: TxmlTransferMode read Get_TransferMode write Set_TransferMode;
  end;

// *********************************************************************//
// DispIntf:  IXMLConfiguration3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E178B4F9-C61D-4DE4-9D0B-1F7636CF7BD1}
// *********************************************************************//
  IXMLConfiguration3Disp = dispinterface
    ['{E178B4F9-C61D-4DE4-9D0B-1F7636CF7BD1}']
    property TransferMode: TxmlTransferMode dispid 1;
  end;

// *********************************************************************//
// Interface: IXMLTransaction3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C3B337FC-AF72-45F6-93C6-750DB62A52B2}
// *********************************************************************//
  IXMLTransaction3 = interface(IXmlTransaction2)
    ['{C3B337FC-AF72-45F6-93C6-750DB62A52B2}']
    function Get_thUserField5: WideString; safecall;
    procedure Set_thUserField5(const Value: WideString); safecall;
    function Get_thUserField6: WideString; safecall;
    procedure Set_thUserField6(const Value: WideString); safecall;
    function Get_thUserField7: WideString; safecall;
    procedure Set_thUserField7(const Value: WideString); safecall;
    function Get_thUserField8: WideString; safecall;
    procedure Set_thUserField8(const Value: WideString); safecall;
    function Get_thUserField9: WideString; safecall;
    procedure Set_thUserField9(const Value: WideString); safecall;
    function Get_thUserField10: WideString; safecall;
    procedure Set_thUserField10(const Value: WideString); safecall;
    property thUserField5: WideString read Get_thUserField5 write Set_thUserField5;
    property thUserField6: WideString read Get_thUserField6 write Set_thUserField6;
    property thUserField7: WideString read Get_thUserField7 write Set_thUserField7;
    property thUserField8: WideString read Get_thUserField8 write Set_thUserField8;
    property thUserField9: WideString read Get_thUserField9 write Set_thUserField9;
    property thUserField10: WideString read Get_thUserField10 write Set_thUserField10;
  end;

// *********************************************************************//
// DispIntf:  IXMLTransaction3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C3B337FC-AF72-45F6-93C6-750DB62A52B2}
// *********************************************************************//
  IXMLTransaction3Disp = dispinterface
    ['{C3B337FC-AF72-45F6-93C6-750DB62A52B2}']
    property thUserField5: WideString dispid 5;
    property thUserField6: WideString dispid 72;
    property thUserField7: WideString dispid 73;
    property thUserField8: WideString dispid 74;
    property thUserField9: WideString dispid 75;
    property thUserField10: WideString dispid 76;
    property thTagNo: Integer dispid 52;
    property thOurRef: WideString dispid 1;
    property thYourRef: WideString dispid 2;
    property thAcCode: WideString dispid 3;
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
    property thDelAddress: IxmlAddress readonly dispid 27;
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
    property thDocType: TxmlDocTypes dispid 13;
    property thLines: IXmlTransactionLines readonly dispid 14;
    procedure WriteXML(const APath: WideString); dispid 43;
    property thCustSuppAddress: IxmlAddress readonly dispid 53;
    property thOurAddress: IxmlAddress readonly dispid 54;
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
    property thNarrative: IXmlNarrative readonly dispid 69;
    procedure Clear; dispid 70;
    property thContactPhone2: WideString dispid 71;
    property thTheirCodeForUs: WideString dispid 4;
  end;

// *********************************************************************//
// Interface: IXMLTransaction4
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F6A602C8-A6E6-4163-9955-FC4349E4071B}
// *********************************************************************//
  IXMLTransaction4 = interface(IXMLTransaction3)
    ['{F6A602C8-A6E6-4163-9955-FC4349E4071B}']
    function Get_thDeliveryPostcode: WideString; safecall;
    procedure Set_thDeliveryPostcode(const Value: WideString); safecall;
    property thDeliveryPostcode: WideString read Get_thDeliveryPostcode write Set_thDeliveryPostcode;
  end;

// *********************************************************************//
// DispIntf:  IXMLTransaction4Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F6A602C8-A6E6-4163-9955-FC4349E4071B}
// *********************************************************************//
  IXMLTransaction4Disp = dispinterface
    ['{F6A602C8-A6E6-4163-9955-FC4349E4071B}']
    property thDeliveryPostcode: WideString dispid 77;
    property thUserField5: WideString dispid 5;
    property thUserField6: WideString dispid 72;
    property thUserField7: WideString dispid 73;
    property thUserField8: WideString dispid 74;
    property thUserField9: WideString dispid 75;
    property thUserField10: WideString dispid 76;
    property thTagNo: Integer dispid 52;
    property thOurRef: WideString dispid 1;
    property thYourRef: WideString dispid 2;
    property thAcCode: WideString dispid 3;
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
    property thDelAddress: IxmlAddress readonly dispid 27;
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
    property thDocType: TxmlDocTypes dispid 13;
    property thLines: IXmlTransactionLines readonly dispid 14;
    procedure WriteXML(const APath: WideString); dispid 43;
    property thCustSuppAddress: IxmlAddress readonly dispid 53;
    property thOurAddress: IxmlAddress readonly dispid 54;
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
    property thNarrative: IXmlNarrative readonly dispid 69;
    procedure Clear; dispid 70;
    property thContactPhone2: WideString dispid 71;
    property thTheirCodeForUs: WideString dispid 4;
  end;

// *********************************************************************//
// Interface: IXMLTransaction5
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1FBE4D20-8C01-43BB-828D-20A72FEA1042}
// *********************************************************************//
  IXMLTransaction5 = interface(IXMLTransaction4)
    ['{1FBE4D20-8C01-43BB-828D-20A72FEA1042}']
    function Get_thPPDPercentage: Double; safecall;
    procedure Set_thPPDPercentage(Value: Double); safecall;
    function Get_thPPDDays: Smallint; safecall;
    procedure Set_thPPDDays(Value: Smallint); safecall;
    function Get_thPPDGoodsValue: Double; safecall;
    procedure Set_thPPDGoodsValue(Value: Double); safecall;
    function Get_thPPDVATValue: Double; safecall;
    procedure Set_thPPDVATValue(Value: Double); safecall;
    function Get_thPPDTaken: TPPDTakenMode; safecall;
    procedure Set_thPPDTaken(Value: TPPDTakenMode); safecall;
    property thPPDPercentage: Double read Get_thPPDPercentage write Set_thPPDPercentage;
    property thPPDDays: Smallint read Get_thPPDDays write Set_thPPDDays;
    property thPPDGoodsValue: Double read Get_thPPDGoodsValue write Set_thPPDGoodsValue;
    property thPPDVATValue: Double read Get_thPPDVATValue write Set_thPPDVATValue;
    property thPPDTaken: TPPDTakenMode read Get_thPPDTaken write Set_thPPDTaken;
  end;

// *********************************************************************//
// DispIntf:  IXMLTransaction5Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1FBE4D20-8C01-43BB-828D-20A72FEA1042}
// *********************************************************************//
  IXMLTransaction5Disp = dispinterface
    ['{1FBE4D20-8C01-43BB-828D-20A72FEA1042}']
    property thPPDPercentage: Double dispid 78;
    property thPPDDays: Smallint dispid 79;
    property thPPDGoodsValue: Double dispid 80;
    property thPPDVATValue: Double dispid 81;
    property thPPDTaken: TPPDTakenMode dispid 82;
    property thDeliveryPostcode: WideString dispid 77;
    property thUserField5: WideString dispid 5;
    property thUserField6: WideString dispid 72;
    property thUserField7: WideString dispid 73;
    property thUserField8: WideString dispid 74;
    property thUserField9: WideString dispid 75;
    property thUserField10: WideString dispid 76;
    property thTagNo: Integer dispid 52;
    property thOurRef: WideString dispid 1;
    property thYourRef: WideString dispid 2;
    property thAcCode: WideString dispid 3;
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
    property thDelAddress: IxmlAddress readonly dispid 27;
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
    property thDocType: TxmlDocTypes dispid 13;
    property thLines: IXmlTransactionLines readonly dispid 14;
    procedure WriteXML(const APath: WideString); dispid 43;
    property thCustSuppAddress: IxmlAddress readonly dispid 53;
    property thOurAddress: IxmlAddress readonly dispid 54;
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
    property thNarrative: IXmlNarrative readonly dispid 69;
    procedure Clear; dispid 70;
    property thContactPhone2: WideString dispid 71;
    property thTheirCodeForUs: WideString dispid 4;
  end;

// *********************************************************************//
// The Class CoXmlWriter provides a Create and CreateRemote method to          
// create instances of the default interface IXmlWriter exposed by              
// the CoClass XmlWriter. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoXmlWriter = class
    class function Create: IXmlWriter;
    class function CreateRemote(const MachineName: string): IXmlWriter;
  end;

implementation

uses ComObj;

class function CoXmlWriter.Create: IXmlWriter;
begin
  Result := CreateComObject(CLASS_XmlWriter) as IXmlWriter;
end;

class function CoXmlWriter.CreateRemote(const MachineName: string): IXmlWriter;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XmlWriter) as IXmlWriter;
end;

end.
