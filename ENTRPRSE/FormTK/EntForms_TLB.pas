unit EntForms_TLB;

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
// File generated on 01/05/2002 11:20:01 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\FORMTK\EntForms.tlb (1)
// LIBID: {6EA7D7C7-8CE8-4675-B700-061E21B14925}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
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
  EntFormsMajorVersion = 1;
  EntFormsMinorVersion = 0;

  LIBID_EntForms: TGUID = '{6EA7D7C7-8CE8-4675-B700-061E21B14925}';

  IID_IPrintingToolkit: TGUID = '{6E80B83C-EC52-4943-A205-4D9032E3B026}';
  CLASS_PrintingToolkit: TGUID = '{0707A446-0116-455B-BD97-F3FA8DD07AC3}';
  IID_IPrintConfiguration: TGUID = '{1AB4763E-545B-4DD1-B8E7-8819F65F4E3E}';
  IID_IPrintJob: TGUID = '{F97F4296-811F-4BDC-BD75-1F1DD4F48906}';
  IID_IPrintFormsList: TGUID = '{22B1696E-3D7C-4F11-896D-E2ED3110C991}';
  IID_IPrintFormDetails: TGUID = '{3CEF3E65-778A-46B4-B37E-89B6183E9947}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TToolkitStatus
type
  TToolkitStatus = TOleEnum;
const
  tkClosed = $00000000;
  tkOpen = $00000001;

// Constants for enum TPrintFormMode
type
  TPrintFormMode = TOleEnum;
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

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IPrintingToolkit = interface;
  IPrintingToolkitDisp = dispinterface;
  IPrintConfiguration = interface;
  IPrintConfigurationDisp = dispinterface;
  IPrintJob = interface;
  IPrintJobDisp = dispinterface;
  IPrintFormsList = interface;
  IPrintFormsListDisp = dispinterface;
  IPrintFormDetails = interface;
  IPrintFormDetailsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  PrintingToolkit = IPrintingToolkit;


// *********************************************************************//
// Interface: IPrintingToolkit
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6E80B83C-EC52-4943-A205-4D9032E3B026}
// *********************************************************************//
  IPrintingToolkit = interface(IDispatch)
    ['{6E80B83C-EC52-4943-A205-4D9032E3B026}']
    function OpenPrinting: Integer; safecall;
    function ClosePrinting: Integer; safecall;
    function Get_Version: WideString; safecall;
    function Get_Configuration: IPrintConfiguration; safecall;
    function Get_PrintJob: IPrintJob; safecall;
    function Get_Status: TToolkitStatus; safecall;
    property Version: WideString read Get_Version;
    property Configuration: IPrintConfiguration read Get_Configuration;
    property PrintJob: IPrintJob read Get_PrintJob;
    property Status: TToolkitStatus read Get_Status;
  end;

// *********************************************************************//
// DispIntf:  IPrintingToolkitDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6E80B83C-EC52-4943-A205-4D9032E3B026}
// *********************************************************************//
  IPrintingToolkitDisp = dispinterface
    ['{6E80B83C-EC52-4943-A205-4D9032E3B026}']
    function OpenPrinting: Integer; dispid 1;
    function ClosePrinting: Integer; dispid 2;
    property Version: WideString readonly dispid 3;
    property Configuration: IPrintConfiguration readonly dispid 4;
    property PrintJob: IPrintJob readonly dispid 5;
    property Status: TToolkitStatus readonly dispid 6;
  end;

// *********************************************************************//
// Interface: IPrintConfiguration
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1AB4763E-545B-4DD1-B8E7-8819F65F4E3E}
// *********************************************************************//
  IPrintConfiguration = interface(IDispatch)
    ['{1AB4763E-545B-4DD1-B8E7-8819F65F4E3E}']
    function Get_cfDataDirectory: WideString; safecall;
    procedure Set_cfDataDirectory(const Value: WideString); safecall;
    function Get_cfEnterpriseDirectory: WideString; safecall;
    procedure Set_cfEnterpriseDirectory(const Value: WideString); safecall;
    property cfDataDirectory: WideString read Get_cfDataDirectory write Set_cfDataDirectory;
    property cfEnterpriseDirectory: WideString read Get_cfEnterpriseDirectory write Set_cfEnterpriseDirectory;
  end;

// *********************************************************************//
// DispIntf:  IPrintConfigurationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1AB4763E-545B-4DD1-B8E7-8819F65F4E3E}
// *********************************************************************//
  IPrintConfigurationDisp = dispinterface
    ['{1AB4763E-545B-4DD1-B8E7-8819F65F4E3E}']
    property cfDataDirectory: WideString dispid 1;
    property cfEnterpriseDirectory: WideString dispid 2;
  end;

// *********************************************************************//
// Interface: IPrintJob
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F97F4296-811F-4BDC-BD75-1F1DD4F48906}
// *********************************************************************//
  IPrintJob = interface(IDispatch)
    ['{F97F4296-811F-4BDC-BD75-1F1DD4F48906}']
    function Get_PrinterIndex: Integer; safecall;
    procedure Set_PrinterIndex(Value: Integer); safecall;
    function Get_Forms(Index: Integer): IPrintFormsList; safecall;
    property PrinterIndex: Integer read Get_PrinterIndex write Set_PrinterIndex;
    property Forms[Index: Integer]: IPrintFormsList read Get_Forms;
  end;

// *********************************************************************//
// DispIntf:  IPrintJobDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F97F4296-811F-4BDC-BD75-1F1DD4F48906}
// *********************************************************************//
  IPrintJobDisp = dispinterface
    ['{F97F4296-811F-4BDC-BD75-1F1DD4F48906}']
    property PrinterIndex: Integer dispid 1;
    property Forms[Index: Integer]: IPrintFormsList readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IPrintFormsList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {22B1696E-3D7C-4F11-896D-E2ED3110C991}
// *********************************************************************//
  IPrintFormsList = interface(IDispatch)
    ['{22B1696E-3D7C-4F11-896D-E2ED3110C991}']
    function Get_FormCount: Integer; safecall;
    function Get_Forms(Index: Integer): IPrintFormDetails; safecall;
    function Add: IPrintFormDetails; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Clear; safecall;
    property FormCount: Integer read Get_FormCount;
    property Forms[Index: Integer]: IPrintFormDetails read Get_Forms;
  end;

// *********************************************************************//
// DispIntf:  IPrintFormsListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {22B1696E-3D7C-4F11-896D-E2ED3110C991}
// *********************************************************************//
  IPrintFormsListDisp = dispinterface
    ['{22B1696E-3D7C-4F11-896D-E2ED3110C991}']
    property FormCount: Integer readonly dispid 1;
    property Forms[Index: Integer]: IPrintFormDetails readonly dispid 2;
    function Add: IPrintFormDetails; dispid 3;
    procedure Delete(Index: Integer); dispid 4;
    procedure Clear; dispid 5;
  end;

// *********************************************************************//
// Interface: IPrintFormDetails
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3CEF3E65-778A-46B4-B37E-89B6183E9947}
// *********************************************************************//
  IPrintFormDetails = interface(IDispatch)
    ['{3CEF3E65-778A-46B4-B37E-89B6183E9947}']
    function Get_fdMode: TPrintFormMode; safecall;
    procedure Set_fdMode(Value: TPrintFormMode); safecall;
    function Get_fdFormName: WideString; safecall;
    procedure Set_fdFormName(const Value: WideString); safecall;
    function Get_fdMainFileNo: Integer; safecall;
    procedure Set_fdMainFileNo(Value: Integer); safecall;
    function Get_fdMainIndexNo: Integer; safecall;
    procedure Set_fdMainIndexNo(Value: Integer); safecall;
    function Get_fdMainKeyString: Integer; safecall;
    procedure Set_fdMainKeyString(Value: Integer); safecall;
    function Get_fdTableFileNo: Integer; safecall;
    procedure Set_fdTableFileNo(Value: Integer); safecall;
    function Get_fdTableIndexNo: Integer; safecall;
    procedure Set_fdTableIndexNo(Value: Integer); safecall;
    function Get_fdTableKeyString: Integer; safecall;
    procedure Set_fdTableKeyString(Value: Integer); safecall;
    function Get_fdDescription: Integer; safecall;
    procedure Set_fdDescription(Value: Integer); safecall;
    function Get_fdLabel1: Integer; safecall;
    procedure Set_fdLabel1(Value: Integer); safecall;
    function Get_fdLabelCopies: Integer; safecall;
    procedure Set_fdLabelCopies(Value: Integer); safecall;
    function Get_fdTestMode: Integer; safecall;
    procedure Set_fdTestMode(Value: Integer); safecall;
    function Get_fdMiscFlags(Index: Integer): OleVariant; safecall;
    procedure Set_fdMiscFlags(Index: Integer; Value: OleVariant); safecall;
    property fdMode: TPrintFormMode read Get_fdMode write Set_fdMode;
    property fdFormName: WideString read Get_fdFormName write Set_fdFormName;
    property fdMainFileNo: Integer read Get_fdMainFileNo write Set_fdMainFileNo;
    property fdMainIndexNo: Integer read Get_fdMainIndexNo write Set_fdMainIndexNo;
    property fdMainKeyString: Integer read Get_fdMainKeyString write Set_fdMainKeyString;
    property fdTableFileNo: Integer read Get_fdTableFileNo write Set_fdTableFileNo;
    property fdTableIndexNo: Integer read Get_fdTableIndexNo write Set_fdTableIndexNo;
    property fdTableKeyString: Integer read Get_fdTableKeyString write Set_fdTableKeyString;
    property fdDescription: Integer read Get_fdDescription write Set_fdDescription;
    property fdLabel1: Integer read Get_fdLabel1 write Set_fdLabel1;
    property fdLabelCopies: Integer read Get_fdLabelCopies write Set_fdLabelCopies;
    property fdTestMode: Integer read Get_fdTestMode write Set_fdTestMode;
    property fdMiscFlags[Index: Integer]: OleVariant read Get_fdMiscFlags write Set_fdMiscFlags;
  end;

// *********************************************************************//
// DispIntf:  IPrintFormDetailsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3CEF3E65-778A-46B4-B37E-89B6183E9947}
// *********************************************************************//
  IPrintFormDetailsDisp = dispinterface
    ['{3CEF3E65-778A-46B4-B37E-89B6183E9947}']
    property fdMode: TPrintFormMode dispid 2;
    property fdFormName: WideString dispid 1;
    property fdMainFileNo: Integer dispid 3;
    property fdMainIndexNo: Integer dispid 4;
    property fdMainKeyString: Integer dispid 5;
    property fdTableFileNo: Integer dispid 6;
    property fdTableIndexNo: Integer dispid 7;
    property fdTableKeyString: Integer dispid 8;
    property fdDescription: Integer dispid 9;
    property fdLabel1: Integer dispid 10;
    property fdLabelCopies: Integer dispid 11;
    property fdTestMode: Integer dispid 12;
    property fdMiscFlags[Index: Integer]: OleVariant dispid 13;
  end;

// *********************************************************************//
// The Class CoPrintingToolkit provides a Create and CreateRemote method to          
// create instances of the default interface IPrintingToolkit exposed by              
// the CoClass PrintingToolkit. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPrintingToolkit = class
    class function Create: IPrintingToolkit;
    class function CreateRemote(const MachineName: string): IPrintingToolkit;
  end;

implementation

uses ComObj;

class function CoPrintingToolkit.Create: IPrintingToolkit;
begin
  Result := CreateComObject(CLASS_PrintingToolkit) as IPrintingToolkit;
end;

class function CoPrintingToolkit.CreateRemote(const MachineName: string): IPrintingToolkit;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PrintingToolkit) as IPrintingToolkit;
end;

end.
