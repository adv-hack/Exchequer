unit EnterpriseTradePlugIn_TLB;

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
// File generated on 20/01/2004 15:02:17 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\EPOS\PlugIns\PDQWedge\PDQWedge.tlb (1)
// LIBID: {67730D4F-EF6C-4607-A962-3E20EFCE4DAC}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (E:\WINNT\system32\Stdole2.tlb)
//   (2) v4.0 StdVCL, (E:\WINNT\System32\STDVCL40.DLL)
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
  EnterpriseTradePlugInMajorVersion = 1;
  EnterpriseTradePlugInMinorVersion = 0;

  LIBID_EnterpriseTradePlugIn: TGUID = '{67730D4F-EF6C-4607-A962-3E20EFCE4DAC}';

  IID_IPDQWedge: TGUID = '{B716978F-A29F-41EC-8EF8-FCAB6C4263E2}';
  CLASS_PDQWedge: TGUID = '{0490521C-013C-4C26-9AC1-CB9E75EC38BA}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IPDQWedge = interface;
  IPDQWedgeDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  PDQWedge = IPDQWedge;


// *********************************************************************//
// Interface: IPDQWedge
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B716978F-A29F-41EC-8EF8-FCAB6C4263E2}
// *********************************************************************//
  IPDQWedge = interface(IDispatch)
    ['{B716978F-A29F-41EC-8EF8-FCAB6C4263E2}']
  end;

// *********************************************************************//
// DispIntf:  IPDQWedgeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B716978F-A29F-41EC-8EF8-FCAB6C4263E2}
// *********************************************************************//
  IPDQWedgeDisp = dispinterface
    ['{B716978F-A29F-41EC-8EF8-FCAB6C4263E2}']
  end;

// *********************************************************************//
// The Class CoPDQWedge provides a Create and CreateRemote method to          
// create instances of the default interface IPDQWedge exposed by              
// the CoClass PDQWedge. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPDQWedge = class
    class function Create: IPDQWedge;
    class function CreateRemote(const MachineName: string): IPDQWedge;
  end;

implementation

uses ComObj;

class function CoPDQWedge.Create: IPDQWedge;
begin
  Result := CreateComObject(CLASS_PDQWedge) as IPDQWedge;
end;

class function CoPDQWedge.CreateRemote(const MachineName: string): IPDQWedge;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PDQWedge) as IPDQWedge;
end;

end.
