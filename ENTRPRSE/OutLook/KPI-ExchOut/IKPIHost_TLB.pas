unit IKPIHost_TLB;

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

// PASTLWTR : $Revision:   1.130.1.0.1.0.1.6  $
// File generated on 02/12/2013 10:14:56 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\EXCH708S\KPI\IKPIHost.Dll (1)
// LIBID: {F2C97C48-284D-4412-B2B6-C3F9447BCF98}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v1.0 stdole, (C:\Windows\system32\stdole32.tlb)
// Parent TypeLibrary:
//   (0) v1.0 IRISEnterpriseKPI, (W:\ENTRPRSE\OutLook\KPI-ExchOut\ExchOut.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
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
  IKPIHostMajorVersion = 1;
  IKPIHostMinorVersion = 0;

  LIBID_IKPIHost: TGUID = '{F2C97C48-284D-4412-B2B6-C3F9447BCF98}';

  IID_IKPIAddin: TGUID = '{90CA9530-3134-4419-8551-BCE9C381C441}';
  CLASS_KPIAddin: TGUID = '{612BA9CF-8817-4A50-B7EA-3A76966A9D4A}';
  IID_IDataPlugin: TGUID = '{F85E545E-1312-4F81-A109-E3BA2DB12433}';
  IID_IDataListPlugin: TGUID = '{87DF5EB7-6C04-46DD-90FE-63E2E67D4A0C}';
  IID_IAuthenticationPlugIn: TGUID = '{ABB91B65-1378-42E8-9A34-AC81ABE07FA7}';
  IID_IChartPlugin: TGUID = '{3032885B-F2E5-4025-B9DA-BACD0B8AA8A7}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum EnumDataPlugInDisplayType
type
  EnumDataPlugInDisplayType = TOleEnum;
const
  dtDataList = $00000000;
  dtChart = $00000001;

// Constants for enum EnumDataPlugInStatus
type
  EnumDataPlugInStatus = TOleEnum;
const
  psConfigError = $00000000;
  psAuthenticationError = $00000001;
  psReady = $00000002;
  psNotAvailable = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IKPIAddin = interface;
  IKPIAddinDisp = dispinterface;
  IDataPlugin = interface;
  IDataPluginDisp = dispinterface;
  IDataListPlugin = interface;
  IDataListPluginDisp = dispinterface;
  IAuthenticationPlugIn = interface;
  IAuthenticationPlugInDisp = dispinterface;
  IChartPlugin = interface;
  IChartPluginDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  KPIAddin = IKPIAddin;


// *********************************************************************//
// Interface: IKPIAddin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {90CA9530-3134-4419-8551-BCE9C381C441}
// *********************************************************************//
  IKPIAddin = interface(IDispatch)
    ['{90CA9530-3134-4419-8551-BCE9C381C441}']
  end;

// *********************************************************************//
// DispIntf:  IKPIAddinDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {90CA9530-3134-4419-8551-BCE9C381C441}
// *********************************************************************//
  IKPIAddinDisp = dispinterface
    ['{90CA9530-3134-4419-8551-BCE9C381C441}']
  end;

// *********************************************************************//
// Interface: IDataPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F85E545E-1312-4F81-A109-E3BA2DB12433}
// *********************************************************************//
  IDataPlugin = interface(IDispatch)
    ['{F85E545E-1312-4F81-A109-E3BA2DB12433}']
    procedure CheckIDPFile(const IDPPath: WideString); safecall;
    function Configure(HostHandle: Integer): WordBool; safecall;
    function DrillDown(HostHandle: Integer; MessageHandle: Integer; const UniqueID: WideString): WordBool; safecall;
    procedure Authenticate(const AuthenticationInfo: WideString); safecall;
    function Get_dpPluginID: WideString; safecall;
    function Get_dpAuthenticationID: WideString; safecall;
    function Get_dpDisplayType: EnumDataPlugInDisplayType; safecall;
    function Get_dpCaption: WideString; safecall;
    function Get_dpAuthenticationRequest: WideString; safecall;
    function Get_dpConfiguration: WideString; safecall;
    procedure Set_dpConfiguration(const Value: WideString); safecall;
    function Get_dpSupportsConfiguration: WordBool; safecall;
    function Get_dpSupportsDrillDown: WordBool; safecall;
    function Get_dpStatus: EnumDataPlugInStatus; safecall;
    function Get_dpMessageID: Integer; safecall;
    procedure Set_dpMessageID(Value: Integer); safecall;
    procedure Set_dpHostPath(const Param1: WideString); safecall;
    procedure Set_dpHostVersion(const Param1: WideString); safecall;
    property dpPluginID: WideString read Get_dpPluginID;
    property dpAuthenticationID: WideString read Get_dpAuthenticationID;
    property dpDisplayType: EnumDataPlugInDisplayType read Get_dpDisplayType;
    property dpCaption: WideString read Get_dpCaption;
    property dpAuthenticationRequest: WideString read Get_dpAuthenticationRequest;
    property dpConfiguration: WideString read Get_dpConfiguration write Set_dpConfiguration;
    property dpSupportsConfiguration: WordBool read Get_dpSupportsConfiguration;
    property dpSupportsDrillDown: WordBool read Get_dpSupportsDrillDown;
    property dpStatus: EnumDataPlugInStatus read Get_dpStatus;
    property dpMessageID: Integer read Get_dpMessageID write Set_dpMessageID;
    property dpHostPath: WideString write Set_dpHostPath;
    property dpHostVersion: WideString write Set_dpHostVersion;
  end;

// *********************************************************************//
// DispIntf:  IDataPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F85E545E-1312-4F81-A109-E3BA2DB12433}
// *********************************************************************//
  IDataPluginDisp = dispinterface
    ['{F85E545E-1312-4F81-A109-E3BA2DB12433}']
    procedure CheckIDPFile(const IDPPath: WideString); dispid 1;
    function Configure(HostHandle: Integer): WordBool; dispid 2;
    function DrillDown(HostHandle: Integer; MessageHandle: Integer; const UniqueID: WideString): WordBool; dispid 3;
    procedure Authenticate(const AuthenticationInfo: WideString); dispid 4;
    property dpPluginID: WideString readonly dispid 5;
    property dpAuthenticationID: WideString readonly dispid 6;
    property dpDisplayType: EnumDataPlugInDisplayType readonly dispid 7;
    property dpCaption: WideString readonly dispid 9;
    property dpAuthenticationRequest: WideString readonly dispid 10;
    property dpConfiguration: WideString dispid 11;
    property dpSupportsConfiguration: WordBool readonly dispid 12;
    property dpSupportsDrillDown: WordBool readonly dispid 13;
    property dpStatus: EnumDataPlugInStatus readonly dispid 14;
    property dpMessageID: Integer dispid 15;
    property dpHostPath: WideString writeonly dispid 8;
    property dpHostVersion: WideString writeonly dispid 16;
  end;

// *********************************************************************//
// Interface: IDataListPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {87DF5EB7-6C04-46DD-90FE-63E2E67D4A0C}
// *********************************************************************//
  IDataListPlugin = interface(IDispatch)
    ['{87DF5EB7-6C04-46DD-90FE-63E2E67D4A0C}']
    function GetData: WideString; safecall;
    function Get_dlpColumns: WideString; safecall;
    property dlpColumns: WideString read Get_dlpColumns;
  end;

// *********************************************************************//
// DispIntf:  IDataListPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {87DF5EB7-6C04-46DD-90FE-63E2E67D4A0C}
// *********************************************************************//
  IDataListPluginDisp = dispinterface
    ['{87DF5EB7-6C04-46DD-90FE-63E2E67D4A0C}']
    function GetData: WideString; dispid 1;
    property dlpColumns: WideString readonly dispid 2;
  end;

// *********************************************************************//
// Interface: IAuthenticationPlugIn
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ABB91B65-1378-42E8-9A34-AC81ABE07FA7}
// *********************************************************************//
  IAuthenticationPlugIn = interface(IDispatch)
    ['{ABB91B65-1378-42E8-9A34-AC81ABE07FA7}']
    procedure CheckIAPFile(const IAPPath: WideString); safecall;
    function Login(var AuthData: WideString; HostHandle: Integer): WordBool; safecall;
    function CheckLogin(var AuthData: WideString): WordBool; safecall;
    function Get_apAuthenticationId: WideString; safecall;
    function Get_apAuthenticationState: WideString; safecall;
    procedure Set_apAuthenticationState(const Value: WideString); safecall;
    property apAuthenticationId: WideString read Get_apAuthenticationId;
    property apAuthenticationState: WideString read Get_apAuthenticationState write Set_apAuthenticationState;
  end;

// *********************************************************************//
// DispIntf:  IAuthenticationPlugInDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ABB91B65-1378-42E8-9A34-AC81ABE07FA7}
// *********************************************************************//
  IAuthenticationPlugInDisp = dispinterface
    ['{ABB91B65-1378-42E8-9A34-AC81ABE07FA7}']
    procedure CheckIAPFile(const IAPPath: WideString); dispid 1;
    function Login(var AuthData: WideString; HostHandle: Integer): WordBool; dispid 2;
    function CheckLogin(var AuthData: WideString): WordBool; dispid 3;
    property apAuthenticationId: WideString readonly dispid 4;
    property apAuthenticationState: WideString dispid 5;
  end;

// *********************************************************************//
// Interface: IChartPlugin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3032885B-F2E5-4025-B9DA-BACD0B8AA8A7}
// *********************************************************************//
  IChartPlugin = interface(IDispatch)
    ['{3032885B-F2E5-4025-B9DA-BACD0B8AA8A7}']
    function GetData: WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IChartPluginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3032885B-F2E5-4025-B9DA-BACD0B8AA8A7}
// *********************************************************************//
  IChartPluginDisp = dispinterface
    ['{3032885B-F2E5-4025-B9DA-BACD0B8AA8A7}']
    function GetData: WideString; dispid 1;
  end;

// *********************************************************************//
// The Class CoKPIAddin provides a Create and CreateRemote method to          
// create instances of the default interface IKPIAddin exposed by              
// the CoClass KPIAddin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoKPIAddin = class
    class function Create: IKPIAddin;
    class function CreateRemote(const MachineName: string): IKPIAddin;
  end;

implementation

uses ComObj;

class function CoKPIAddin.Create: IKPIAddin;
begin
  Result := CreateComObject(CLASS_KPIAddin) as IKPIAddin;
end;

class function CoKPIAddin.CreateRemote(const MachineName: string): IKPIAddin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_KPIAddin) as IKPIAddin;
end;

end.
