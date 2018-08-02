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

// PASTLWTR : $Revision:   1.130.3.0.1.0  $
// File generated on 15/11/2002 16:45:18 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\OLE\ENTDATAQ.tlb (1)
// LIBID: {AAA15A4E-F82B-46B7-AD9A-702447F7EE77}
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
  EnterpriseMajorVersion = 1;
  EnterpriseMinorVersion = 0;

  LIBID_Enterprise: TGUID = '{AAA15A4E-F82B-46B7-AD9A-702447F7EE77}';

  IID_IDataQuery: TGUID = '{DC864DEB-7725-4439-ABCB-E8D2DCF92160}';
  DIID_IDataQueryEvents: TGUID = '{DA42C1F2-518E-48A5-8216-9E76EEE718E9}';
  CLASS_DataQuery: TGUID = '{96E43BC8-343B-42B5-907B-09A36E2D0310}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TDataQueryMode
type
  TDataQueryMode = TOleEnum;
const
  dqmCostCentre = $00000000;
  dqmCustomer = $00000001;
  dqmDepartment = $00000002;
  dqmGLCode = $00000003;
  dqmJob = $00000004;
  dqmLocation = $00000005;
  dqmStock = $00000006;
  dqmSupplier = $00000007;

// Constants for enum TDataQueryDirection
type
  TDataQueryDirection = TOleEnum;
const
  dqoHorizontalRight = $00000000;
  dqoVerticalDown = $00000001;

// Constants for enum TDataQueryLicencing
type
  TDataQueryLicencing = TOleEnum;
const
  dqlStock = $00000000;
  dqlJobCosting = $00000001;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDataQuery = interface;
  IDataQueryDisp = dispinterface;
  IDataQueryEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DataQuery = IDataQuery;


// *********************************************************************//
// Interface: IDataQuery
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DC864DEB-7725-4439-ABCB-E8D2DCF92160}
// *********************************************************************//
  IDataQuery = interface(IDispatch)
    ['{DC864DEB-7725-4439-ABCB-E8D2DCF92160}']
    function Get_dqVersion: WideString; safecall;
    function Execute(DataType: TDataQueryMode): Integer; safecall;
    function Get_dqMode: TDataQueryMode; safecall;
    function Get_dqExcelStartCol: Integer; safecall;
    procedure Set_dqExcelStartCol(Value: Integer); safecall;
    function Get_dqExcelStartRow: Integer; safecall;
    procedure Set_dqExcelStartRow(Value: Integer); safecall;
    function Get_dqImportDirection: TDataQueryDirection; safecall;
    procedure Set_dqImportDirection(Value: TDataQueryDirection); safecall;
    function Get_dqResultCount: Integer; safecall;
    function Get_dqResults(Index: Integer): WideString; safecall;
    procedure ExecuteAbout(const AddInVer: WideString); safecall;
    function Get_dqLicencing(Index: TDataQueryLicencing): WordBool; safecall;
    property dqVersion: WideString read Get_dqVersion;
    property dqMode: TDataQueryMode read Get_dqMode;
    property dqExcelStartCol: Integer read Get_dqExcelStartCol write Set_dqExcelStartCol;
    property dqExcelStartRow: Integer read Get_dqExcelStartRow write Set_dqExcelStartRow;
    property dqImportDirection: TDataQueryDirection read Get_dqImportDirection write Set_dqImportDirection;
    property dqResultCount: Integer read Get_dqResultCount;
    property dqResults[Index: Integer]: WideString read Get_dqResults;
    property dqLicencing[Index: TDataQueryLicencing]: WordBool read Get_dqLicencing;
  end;

// *********************************************************************//
// DispIntf:  IDataQueryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DC864DEB-7725-4439-ABCB-E8D2DCF92160}
// *********************************************************************//
  IDataQueryDisp = dispinterface
    ['{DC864DEB-7725-4439-ABCB-E8D2DCF92160}']
    property dqVersion: WideString readonly dispid 1;
    function Execute(DataType: TDataQueryMode): Integer; dispid 2;
    property dqMode: TDataQueryMode readonly dispid 4;
    property dqExcelStartCol: Integer dispid 5;
    property dqExcelStartRow: Integer dispid 6;
    property dqImportDirection: TDataQueryDirection dispid 7;
    property dqResultCount: Integer readonly dispid 8;
    property dqResults[Index: Integer]: WideString readonly dispid 9;
    procedure ExecuteAbout(const AddInVer: WideString); dispid 3;
    property dqLicencing[Index: TDataQueryLicencing]: WordBool readonly dispid 10;
  end;

// *********************************************************************//
// DispIntf:  IDataQueryEvents
// Flags:     (4096) Dispatchable
// GUID:      {DA42C1F2-518E-48A5-8216-9E76EEE718E9}
// *********************************************************************//
  IDataQueryEvents = dispinterface
    ['{DA42C1F2-518E-48A5-8216-9E76EEE718E9}']
  end;

// *********************************************************************//
// The Class CoDataQuery provides a Create and CreateRemote method to          
// create instances of the default interface IDataQuery exposed by              
// the CoClass DataQuery. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDataQuery = class
    class function Create: IDataQuery;
    class function CreateRemote(const MachineName: string): IDataQuery;
  end;

implementation

uses ComObj;

class function CoDataQuery.Create: IDataQuery;
begin
  Result := CreateComObject(CLASS_DataQuery) as IDataQuery;
end;

class function CoDataQuery.CreateRemote(const MachineName: string): IDataQuery;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DataQuery) as IDataQuery;
end;

end.
