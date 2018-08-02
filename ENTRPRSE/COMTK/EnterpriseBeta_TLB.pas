unit EnterpriseBeta_TLB;

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
// File generated on 25/01/2018 10:05:21 from Type Library described below.

// ************************************************************************  //
// Type Lib: W:\ENTRPRSE\COMTK\EntLib.tlb (1)
// LIBID: {D9F0BD72-D68F-47A7-A86C-69255FFE368F}
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
  EnterpriseBetaMajorVersion = 1;
  EnterpriseBetaMinorVersion = 0;

  LIBID_EnterpriseBeta: TGUID = '{D9F0BD72-D68F-47A7-A86C-69255FFE368F}';

  IID_ITest: TGUID = '{A495E5B5-339F-474E-94EA-F2F5C999F4FD}';
  CLASS_Test: TGUID = '{17CFCBAB-6355-4EB2-8453-D5FA577533DE}';
  IID_IBetaTransaction: TGUID = '{BF7A751F-2BDB-4766-8E13-1162D663213C}';
  IID_IBetaTransactionLine: TGUID = '{BA5ED2A7-0BE4-4C48-A20C-321A7B829630}';
  IID_IBetaMatching: TGUID = '{D7A21598-72E9-4E70-AF90-B54B657C6A0B}';
  IID_IDatabaseFunctions: TGUID = '{FF540358-F021-45F2-ABCF-6B93CFAE0C35}';
  IID_IBetaConfig: TGUID = '{FF7C9EA1-B8CA-472E-AE02-828756205A15}';
  IID_IBetaConfig2: TGUID = '{85E3AAE2-ABBE-4EF3-A6BA-DFD1DE49EDF1}';
  IID_IBetaTransaction2: TGUID = '{50E98F86-BFAA-47B1-8A1D-088F3BE178DB}';
  IID_IBetaOP: TGUID = '{2B7B4C7B-4412-4A18-BDE4-974084FAC5ED}';
  IID_IVAT100: TGUID = '{079D7A4D-ADD3-46E2-ABC8-319AB6F4378F}';
  IID_ICSNFToolkit: TGUID = '{8758ADE2-1C2F-43F7-BF9E-34F26B5EAA2A}';
  IID_IBetaTransaction3: TGUID = '{B66C2393-477B-4E0C-992D-084E107CF942}';
  IID_IHashFunctions: TGUID = '{8B7772B3-EAA9-440B-8065-349D26F6EBEE}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TStockReOrderMode
type
  TStockReOrderMode = TOleEnum;
const
  sr65 = $00000000;
  sr66 = $00000001;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ITest = interface;
  ITestDisp = dispinterface;
  IBetaTransaction = interface;
  IBetaTransactionDisp = dispinterface;
  IBetaTransactionLine = interface;
  IBetaTransactionLineDisp = dispinterface;
  IBetaMatching = interface;
  IBetaMatchingDisp = dispinterface;
  IDatabaseFunctions = interface;
  IDatabaseFunctionsDisp = dispinterface;
  IBetaConfig = interface;
  IBetaConfigDisp = dispinterface;
  IBetaConfig2 = interface;
  IBetaConfig2Disp = dispinterface;
  IBetaTransaction2 = interface;
  IBetaTransaction2Disp = dispinterface;
  IBetaOP = interface;
  IBetaOPDisp = dispinterface;
  IVAT100 = interface;
  IVAT100Disp = dispinterface;
  ICSNFToolkit = interface;
  ICSNFToolkitDisp = dispinterface;
  IBetaTransaction3 = interface;
  IBetaTransaction3Disp = dispinterface;
  IHashFunctions = interface;
  IHashFunctionsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Test = ITest;


// *********************************************************************//
// Interface: ITest
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A495E5B5-339F-474E-94EA-F2F5C999F4FD}
// *********************************************************************//
  ITest = interface(IDispatch)
    ['{A495E5B5-339F-474E-94EA-F2F5C999F4FD}']
  end;

// *********************************************************************//
// DispIntf:  ITestDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A495E5B5-339F-474E-94EA-F2F5C999F4FD}
// *********************************************************************//
  ITestDisp = dispinterface
    ['{A495E5B5-339F-474E-94EA-F2F5C999F4FD}']
  end;

// *********************************************************************//
// Interface: IBetaTransaction
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BF7A751F-2BDB-4766-8E13-1162D663213C}
// *********************************************************************//
  IBetaTransaction = interface(IDispatch)
    ['{BF7A751F-2BDB-4766-8E13-1162D663213C}']
    function Get_LineCount: Integer; safecall;
    procedure Set_thSource(Param1: Integer); safecall;
    function Get_thOutstanding: WideString; safecall;
    procedure Set_thOutstanding(const Value: WideString); safecall;
    function Get_thDeliveryRunNo: WideString; safecall;
    procedure Set_thDeliveryRunNo(const Value: WideString); safecall;
    function Get_thOrdMatch: WordBool; safecall;
    procedure Set_thOrdMatch(Value: WordBool); safecall;
    function Get_thAutoPost: WordBool; safecall;
    procedure Set_thZeroLineNos(Param1: WordBool); safecall;
    procedure Set_thAllowCtrlCodes(Param1: WordBool); safecall;
    function Get_thTotalReserved: Double; safecall;
    procedure Set_thTotalReserved(Value: Double); safecall;
    function Get_thPostDiscAmount: Double; safecall;
    procedure Set_thPostDiscAmount(Value: Double); safecall;
    function Get_thTotalInvoiced: Double; safecall;
    procedure Set_thTotalInvoiced(Value: Double); safecall;
    function Get_thVariance: Double; safecall;
    procedure Set_thVariance(Value: Double); safecall;
    function Get_thTotalOrdered: Double; safecall;
    procedure Set_thTotalOrdered(Value: Double); safecall;
    function Get_thRevalueAdj: Double; safecall;
    procedure Set_thRevalueAdj(Value: Double); safecall;
    property LineCount: Integer read Get_LineCount;
    property thSource: Integer write Set_thSource;
    property thOutstanding: WideString read Get_thOutstanding write Set_thOutstanding;
    property thDeliveryRunNo: WideString read Get_thDeliveryRunNo write Set_thDeliveryRunNo;
    property thOrdMatch: WordBool read Get_thOrdMatch write Set_thOrdMatch;
    property thAutoPost: WordBool read Get_thAutoPost;
    property thZeroLineNos: WordBool write Set_thZeroLineNos;
    property thAllowCtrlCodes: WordBool write Set_thAllowCtrlCodes;
    property thTotalReserved: Double read Get_thTotalReserved write Set_thTotalReserved;
    property thPostDiscAmount: Double read Get_thPostDiscAmount write Set_thPostDiscAmount;
    property thTotalInvoiced: Double read Get_thTotalInvoiced write Set_thTotalInvoiced;
    property thVariance: Double read Get_thVariance write Set_thVariance;
    property thTotalOrdered: Double read Get_thTotalOrdered write Set_thTotalOrdered;
    property thRevalueAdj: Double read Get_thRevalueAdj write Set_thRevalueAdj;
  end;

// *********************************************************************//
// DispIntf:  IBetaTransactionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BF7A751F-2BDB-4766-8E13-1162D663213C}
// *********************************************************************//
  IBetaTransactionDisp = dispinterface
    ['{BF7A751F-2BDB-4766-8E13-1162D663213C}']
    property LineCount: Integer readonly dispid 1;
    property thSource: Integer writeonly dispid 4;
    property thOutstanding: WideString dispid 2;
    property thDeliveryRunNo: WideString dispid 3;
    property thOrdMatch: WordBool dispid 6;
    property thAutoPost: WordBool readonly dispid 7;
    property thZeroLineNos: WordBool writeonly dispid 8;
    property thAllowCtrlCodes: WordBool writeonly dispid 9;
    property thTotalReserved: Double dispid 10;
    property thPostDiscAmount: Double dispid 11;
    property thTotalInvoiced: Double dispid 12;
    property thVariance: Double dispid 5;
    property thTotalOrdered: Double dispid 13;
    property thRevalueAdj: Double dispid 14;
  end;

// *********************************************************************//
// Interface: IBetaTransactionLine
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA5ED2A7-0BE4-4C48-A20C-321A7B829630}
// *********************************************************************//
  IBetaTransactionLine = interface(IDispatch)
    ['{BA5ED2A7-0BE4-4C48-A20C-321A7B829630}']
    procedure Set_tlAbsLineNo(Param1: Integer); safecall;
    procedure Set_tlB2BLineNo(Param1: Integer); safecall;
    procedure Set_tlB2BLinkFolio(Param1: Integer); safecall;
    procedure Set_tlCosDailyRate(Param1: Double); safecall;
    procedure Set_tlNominalMode(Param1: Integer); safecall;
    procedure Set_tlQtyPack(Param1: Double); safecall;
    procedure Set_tlStockDeductQty(Param1: Double); safecall;
    procedure Set_tlUseQtyMul(Param1: WordBool); safecall;
    procedure Set_tlBinQty(Param1: Double); safecall;
    function Get_tlReconciliationDate: WideString; safecall;
    procedure Set_tlReconciliationDate(const Value: WideString); safecall;
    property tlAbsLineNo: Integer write Set_tlAbsLineNo;
    property tlB2BLineNo: Integer write Set_tlB2BLineNo;
    property tlB2BLinkFolio: Integer write Set_tlB2BLinkFolio;
    property tlCosDailyRate: Double write Set_tlCosDailyRate;
    property tlNominalMode: Integer write Set_tlNominalMode;
    property tlQtyPack: Double write Set_tlQtyPack;
    property tlStockDeductQty: Double write Set_tlStockDeductQty;
    property tlUseQtyMul: WordBool write Set_tlUseQtyMul;
    property tlBinQty: Double write Set_tlBinQty;
    property tlReconciliationDate: WideString read Get_tlReconciliationDate write Set_tlReconciliationDate;
  end;

// *********************************************************************//
// DispIntf:  IBetaTransactionLineDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA5ED2A7-0BE4-4C48-A20C-321A7B829630}
// *********************************************************************//
  IBetaTransactionLineDisp = dispinterface
    ['{BA5ED2A7-0BE4-4C48-A20C-321A7B829630}']
    property tlAbsLineNo: Integer writeonly dispid 1;
    property tlB2BLineNo: Integer writeonly dispid 2;
    property tlB2BLinkFolio: Integer writeonly dispid 3;
    property tlCosDailyRate: Double writeonly dispid 4;
    property tlNominalMode: Integer writeonly dispid 5;
    property tlQtyPack: Double writeonly dispid 6;
    property tlStockDeductQty: Double writeonly dispid 8;
    property tlUseQtyMul: WordBool writeonly dispid 9;
    property tlBinQty: Double writeonly dispid 7;
    property tlReconciliationDate: WideString dispid 10;
  end;

// *********************************************************************//
// Interface: IBetaMatching
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D7A21598-72E9-4E70-AF90-B54B657C6A0B}
// *********************************************************************//
  IBetaMatching = interface(IDispatch)
    ['{D7A21598-72E9-4E70-AF90-B54B657C6A0B}']
    function Get_maAllowOversettling: WordBool; safecall;
    procedure Set_maAllowOversettling(Value: WordBool); safecall;
    property maAllowOversettling: WordBool read Get_maAllowOversettling write Set_maAllowOversettling;
  end;

// *********************************************************************//
// DispIntf:  IBetaMatchingDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D7A21598-72E9-4E70-AF90-B54B657C6A0B}
// *********************************************************************//
  IBetaMatchingDisp = dispinterface
    ['{D7A21598-72E9-4E70-AF90-B54B657C6A0B}']
    property maAllowOversettling: WordBool dispid 1;
  end;

// *********************************************************************//
// Interface: IDatabaseFunctions
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF540358-F021-45F2-ABCF-6B93CFAE0C35}
// *********************************************************************//
  IDatabaseFunctions = interface(IDispatch)
    ['{FF540358-F021-45F2-ABCF-6B93CFAE0C35}']
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
    function Get_Index: Integer; safecall;
    procedure Set_Index(Value: Integer); safecall;
    function Get_KeyString2: WideString; safecall;
    property Position: Integer read Get_Position write Set_Position;
    property Index: Integer read Get_Index write Set_Index;
    property KeyString2: WideString read Get_KeyString2;
  end;

// *********************************************************************//
// DispIntf:  IDatabaseFunctionsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF540358-F021-45F2-ABCF-6B93CFAE0C35}
// *********************************************************************//
  IDatabaseFunctionsDisp = dispinterface
    ['{FF540358-F021-45F2-ABCF-6B93CFAE0C35}']
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
    property Index: Integer dispid 1;
    property KeyString2: WideString readonly dispid 2;
  end;

// *********************************************************************//
// Interface: IBetaConfig
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF7C9EA1-B8CA-472E-AE02-828756205A15}
// *********************************************************************//
  IBetaConfig = interface(IDispatch)
    ['{FF7C9EA1-B8CA-472E-AE02-828756205A15}']
    function Get_UserID: WideString; safecall;
    procedure Set_UserID(const Value: WideString); safecall;
    property UserID: WideString read Get_UserID write Set_UserID;
  end;

// *********************************************************************//
// DispIntf:  IBetaConfigDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF7C9EA1-B8CA-472E-AE02-828756205A15}
// *********************************************************************//
  IBetaConfigDisp = dispinterface
    ['{FF7C9EA1-B8CA-472E-AE02-828756205A15}']
    property UserID: WideString dispid 1;
  end;

// *********************************************************************//
// Interface: IBetaConfig2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {85E3AAE2-ABBE-4EF3-A6BA-DFD1DE49EDF1}
// *********************************************************************//
  IBetaConfig2 = interface(IBetaConfig)
    ['{85E3AAE2-ABBE-4EF3-A6BA-DFD1DE49EDF1}']
    function Get_StockReOrderMode: TStockReOrderMode; safecall;
    procedure Set_StockReOrderMode(Value: TStockReOrderMode); safecall;
    property StockReOrderMode: TStockReOrderMode read Get_StockReOrderMode write Set_StockReOrderMode;
  end;

// *********************************************************************//
// DispIntf:  IBetaConfig2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {85E3AAE2-ABBE-4EF3-A6BA-DFD1DE49EDF1}
// *********************************************************************//
  IBetaConfig2Disp = dispinterface
    ['{85E3AAE2-ABBE-4EF3-A6BA-DFD1DE49EDF1}']
    property StockReOrderMode: TStockReOrderMode dispid 2;
    property UserID: WideString dispid 1;
  end;

// *********************************************************************//
// Interface: IBetaTransaction2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {50E98F86-BFAA-47B1-8A1D-088F3BE178DB}
// *********************************************************************//
  IBetaTransaction2 = interface(IBetaTransaction)
    ['{50E98F86-BFAA-47B1-8A1D-088F3BE178DB}']
    function AddAuditNote(const Text: WideString): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IBetaTransaction2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {50E98F86-BFAA-47B1-8A1D-088F3BE178DB}
// *********************************************************************//
  IBetaTransaction2Disp = dispinterface
    ['{50E98F86-BFAA-47B1-8A1D-088F3BE178DB}']
    function AddAuditNote(const Text: WideString): Integer; dispid 15;
    property LineCount: Integer readonly dispid 1;
    property thSource: Integer writeonly dispid 4;
    property thOutstanding: WideString dispid 2;
    property thDeliveryRunNo: WideString dispid 3;
    property thOrdMatch: WordBool dispid 6;
    property thAutoPost: WordBool readonly dispid 7;
    property thZeroLineNos: WordBool writeonly dispid 8;
    property thAllowCtrlCodes: WordBool writeonly dispid 9;
    property thTotalReserved: Double dispid 10;
    property thPostDiscAmount: Double dispid 11;
    property thTotalInvoiced: Double dispid 12;
    property thVariance: Double dispid 5;
    property thTotalOrdered: Double dispid 13;
    property thRevalueAdj: Double dispid 14;
  end;

// *********************************************************************//
// Interface: IBetaOP
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2B7B4C7B-4412-4A18-BDE4-974084FAC5ED}
// *********************************************************************//
  IBetaOP = interface(IDispatch)
    ['{2B7B4C7B-4412-4A18-BDE4-974084FAC5ED}']
    function Get_SRCRef: WideString; safecall;
    procedure Set_SRCRef(const Value: WideString); safecall;
    function Get_SRCYear: Integer; safecall;
    procedure Set_SRCYear(Value: Integer); safecall;
    function Get_SRCPeriod: Integer; safecall;
    procedure Set_SRCPeriod(Value: Integer); safecall;
    function Get_SRCTransDate: WideString; safecall;
    procedure Set_SRCTransDate(const Value: WideString); safecall;
    property SRCRef: WideString read Get_SRCRef write Set_SRCRef;
    property SRCYear: Integer read Get_SRCYear write Set_SRCYear;
    property SRCPeriod: Integer read Get_SRCPeriod write Set_SRCPeriod;
    property SRCTransDate: WideString read Get_SRCTransDate write Set_SRCTransDate;
  end;

// *********************************************************************//
// DispIntf:  IBetaOPDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2B7B4C7B-4412-4A18-BDE4-974084FAC5ED}
// *********************************************************************//
  IBetaOPDisp = dispinterface
    ['{2B7B4C7B-4412-4A18-BDE4-974084FAC5ED}']
    property SRCRef: WideString dispid 1;
    property SRCYear: Integer dispid 2;
    property SRCPeriod: Integer dispid 3;
    property SRCTransDate: WideString dispid 4;
  end;

// *********************************************************************//
// Interface: IVAT100
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {079D7A4D-ADD3-46E2-ABC8-319AB6F4378F}
// *********************************************************************//
  IVAT100 = interface(IDatabaseFunctions)
    ['{079D7A4D-ADD3-46E2-ABC8-319AB6F4378F}']
    function Get_vatCorrelationId: WideString; safecall;
    procedure Set_vatCorrelationId(const Value: WideString); safecall;
    function Get_vatIRMark: WideString; safecall;
    procedure Set_vatIRMark(const Value: WideString); safecall;
    function Get_vatDateSubmitted: WideString; safecall;
    procedure Set_vatDateSubmitted(const Value: WideString); safecall;
    function Get_vatDocumentType: WideString; safecall;
    procedure Set_vatDocumentType(const Value: WideString); safecall;
    function Get_vatPeriod: WideString; safecall;
    procedure Set_vatPeriod(const Value: WideString); safecall;
    function Get_vatUserName: WideString; safecall;
    procedure Set_vatUserName(const Value: WideString); safecall;
    function Get_vatStatus: Smallint; safecall;
    procedure Set_vatStatus(Value: Smallint); safecall;
    function Get_vatPollingInterval: Integer; safecall;
    procedure Set_vatPollingInterval(Value: Integer); safecall;
    function Get_vatDueOnOutputs: Double; safecall;
    procedure Set_vatDueOnOutputs(Value: Double); safecall;
    function Get_vatDueOnECAcquisitions: Double; safecall;
    procedure Set_vatDueOnECAcquisitions(Value: Double); safecall;
    function Get_vatTotal: Double; safecall;
    procedure Set_vatTotal(Value: Double); safecall;
    function Get_vatReclaimedOnInputs: Double; safecall;
    procedure Set_vatReclaimedOnInputs(Value: Double); safecall;
    function Get_vatNet: Double; safecall;
    procedure Set_vatNet(Value: Double); safecall;
    function Get_vatNetSalesAndOutputs: Double; safecall;
    procedure Set_vatNetSalesAndOutputs(Value: Double); safecall;
    function Get_vatNetPurchasesAndInputs: Double; safecall;
    procedure Set_vatNetPurchasesAndInputs(Value: Double); safecall;
    function Get_vatNetECSupplies: Double; safecall;
    procedure Set_vatNetECSupplies(Value: Double); safecall;
    function Get_vatNetECAcquisition: Double; safecall;
    procedure Set_vatNetECAcquisition(Value: Double); safecall;
    function Get_vatHMRCNarrative: WideString; safecall;
    procedure Set_vatHMRCNarrative(const Value: WideString); safecall;
    function Get_vatNotifyEmail: WideString; safecall;
    procedure Set_vatNotifyEmail(const Value: WideString); safecall;
    function Save: Integer; safecall;
    function Add: IVAT100; safecall;
    function Clone: IVAT100; safecall;
    function Update: IVAT100; safecall;
    procedure Cancel; safecall;
    function Get_vatPollingURL: WideString; safecall;
    procedure Set_vatPollingURL(const Value: WideString); safecall;
    property vatCorrelationId: WideString read Get_vatCorrelationId write Set_vatCorrelationId;
    property vatIRMark: WideString read Get_vatIRMark write Set_vatIRMark;
    property vatDateSubmitted: WideString read Get_vatDateSubmitted write Set_vatDateSubmitted;
    property vatDocumentType: WideString read Get_vatDocumentType write Set_vatDocumentType;
    property vatPeriod: WideString read Get_vatPeriod write Set_vatPeriod;
    property vatUserName: WideString read Get_vatUserName write Set_vatUserName;
    property vatStatus: Smallint read Get_vatStatus write Set_vatStatus;
    property vatPollingInterval: Integer read Get_vatPollingInterval write Set_vatPollingInterval;
    property vatDueOnOutputs: Double read Get_vatDueOnOutputs write Set_vatDueOnOutputs;
    property vatDueOnECAcquisitions: Double read Get_vatDueOnECAcquisitions write Set_vatDueOnECAcquisitions;
    property vatTotal: Double read Get_vatTotal write Set_vatTotal;
    property vatReclaimedOnInputs: Double read Get_vatReclaimedOnInputs write Set_vatReclaimedOnInputs;
    property vatNet: Double read Get_vatNet write Set_vatNet;
    property vatNetSalesAndOutputs: Double read Get_vatNetSalesAndOutputs write Set_vatNetSalesAndOutputs;
    property vatNetPurchasesAndInputs: Double read Get_vatNetPurchasesAndInputs write Set_vatNetPurchasesAndInputs;
    property vatNetECSupplies: Double read Get_vatNetECSupplies write Set_vatNetECSupplies;
    property vatNetECAcquisition: Double read Get_vatNetECAcquisition write Set_vatNetECAcquisition;
    property vatHMRCNarrative: WideString read Get_vatHMRCNarrative write Set_vatHMRCNarrative;
    property vatNotifyEmail: WideString read Get_vatNotifyEmail write Set_vatNotifyEmail;
    property vatPollingURL: WideString read Get_vatPollingURL write Set_vatPollingURL;
  end;

// *********************************************************************//
// DispIntf:  IVAT100Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {079D7A4D-ADD3-46E2-ABC8-319AB6F4378F}
// *********************************************************************//
  IVAT100Disp = dispinterface
    ['{079D7A4D-ADD3-46E2-ABC8-319AB6F4378F}']
    property vatCorrelationId: WideString dispid 4;
    property vatIRMark: WideString dispid 5;
    property vatDateSubmitted: WideString dispid 6;
    property vatDocumentType: WideString dispid 7;
    property vatPeriod: WideString dispid 8;
    property vatUserName: WideString dispid 9;
    property vatStatus: Smallint dispid 10;
    property vatPollingInterval: Integer dispid 11;
    property vatDueOnOutputs: Double dispid 12;
    property vatDueOnECAcquisitions: Double dispid 13;
    property vatTotal: Double dispid 14;
    property vatReclaimedOnInputs: Double dispid 15;
    property vatNet: Double dispid 16;
    property vatNetSalesAndOutputs: Double dispid 17;
    property vatNetPurchasesAndInputs: Double dispid 18;
    property vatNetECSupplies: Double dispid 19;
    property vatNetECAcquisition: Double dispid 20;
    property vatHMRCNarrative: WideString dispid 21;
    property vatNotifyEmail: WideString dispid 22;
    function Save: Integer; dispid 3;
    function Add: IVAT100; dispid 23;
    function Clone: IVAT100; dispid 24;
    function Update: IVAT100; dispid 25;
    procedure Cancel; dispid 26;
    property vatPollingURL: WideString dispid 27;
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
    property Index: Integer dispid 1;
    property KeyString2: WideString readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ICSNFToolkit
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8758ADE2-1C2F-43F7-BF9E-34F26B5EAA2A}
// *********************************************************************//
  ICSNFToolkit = interface(IDispatch)
    ['{8758ADE2-1C2F-43F7-BF9E-34F26B5EAA2A}']
    function Get_VAT100: IVAT100; safecall;
    property VAT100: IVAT100 read Get_VAT100;
  end;

// *********************************************************************//
// DispIntf:  ICSNFToolkitDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8758ADE2-1C2F-43F7-BF9E-34F26B5EAA2A}
// *********************************************************************//
  ICSNFToolkitDisp = dispinterface
    ['{8758ADE2-1C2F-43F7-BF9E-34F26B5EAA2A}']
    property VAT100: IVAT100 readonly dispid 2;
  end;

// *********************************************************************//
// Interface: IBetaTransaction3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B66C2393-477B-4E0C-992D-084E107CF942}
// *********************************************************************//
  IBetaTransaction3 = interface(IBetaTransaction2)
    ['{B66C2393-477B-4E0C-992D-084E107CF942}']
    procedure SetPrintedStatus(Value: WordBool); safecall;
  end;

// *********************************************************************//
// DispIntf:  IBetaTransaction3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B66C2393-477B-4E0C-992D-084E107CF942}
// *********************************************************************//
  IBetaTransaction3Disp = dispinterface
    ['{B66C2393-477B-4E0C-992D-084E107CF942}']
    procedure SetPrintedStatus(Value: WordBool); dispid 16;
    function AddAuditNote(const Text: WideString): Integer; dispid 15;
    property LineCount: Integer readonly dispid 1;
    property thSource: Integer writeonly dispid 4;
    property thOutstanding: WideString dispid 2;
    property thDeliveryRunNo: WideString dispid 3;
    property thOrdMatch: WordBool dispid 6;
    property thAutoPost: WordBool readonly dispid 7;
    property thZeroLineNos: WordBool writeonly dispid 8;
    property thAllowCtrlCodes: WordBool writeonly dispid 9;
    property thTotalReserved: Double dispid 10;
    property thPostDiscAmount: Double dispid 11;
    property thTotalInvoiced: Double dispid 12;
    property thVariance: Double dispid 5;
    property thTotalOrdered: Double dispid 13;
    property thRevalueAdj: Double dispid 14;
  end;

// *********************************************************************//
// Interface: IHashFunctions
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8B7772B3-EAA9-440B-8065-349D26F6EBEE}
// *********************************************************************//
  IHashFunctions = interface(IDispatch)
    ['{8B7772B3-EAA9-440B-8065-349D26F6EBEE}']
    function HashText(const HashSalt: WideString; const HashText: WideString): WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IHashFunctionsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8B7772B3-EAA9-440B-8065-349D26F6EBEE}
// *********************************************************************//
  IHashFunctionsDisp = dispinterface
    ['{8B7772B3-EAA9-440B-8065-349D26F6EBEE}']
    function HashText(const HashSalt: WideString; const HashText: WideString): WideString; dispid 1;
  end;

// *********************************************************************//
// The Class CoTest provides a Create and CreateRemote method to          
// create instances of the default interface ITest exposed by              
// the CoClass Test. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTest = class
    class function Create: ITest;
    class function CreateRemote(const MachineName: string): ITest;
  end;

implementation

uses ComObj;

class function CoTest.Create: ITest;
begin
  Result := CreateComObject(CLASS_Test) as ITest;
end;

class function CoTest.CreateRemote(const MachineName: string): ITest;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Test) as ITest;
end;

end.
