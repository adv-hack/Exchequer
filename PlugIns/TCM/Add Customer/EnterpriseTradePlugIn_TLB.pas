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
// File generated on 28/07/2003 16:06:23 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\EPOS\PLUGINS\ADDCUST\AddCust.tlb (1)
// LIBID: {F7E2D05E-0513-4487-806F-AF5CD7477607}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (E:\WINNT\System32\Stdole2.tlb)
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

  LIBID_EnterpriseTradePlugIn: TGUID = '{F7E2D05E-0513-4487-806F-AF5CD7477607}';

  IID_IAddCustomer: TGUID = '{030CDE21-B48A-4691-B2AF-481F7DA371FA}';
  CLASS_AddCustomer: TGUID = '{EC9F9526-19E9-4797-A7EC-52B7D992F243}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IAddCustomer = interface;
  IAddCustomerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  AddCustomer = IAddCustomer;


// *********************************************************************//
// Interface: IAddCustomer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {030CDE21-B48A-4691-B2AF-481F7DA371FA}
// *********************************************************************//
  IAddCustomer = interface(IDispatch)
    ['{030CDE21-B48A-4691-B2AF-481F7DA371FA}']
  end;

// *********************************************************************//
// DispIntf:  IAddCustomerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {030CDE21-B48A-4691-B2AF-481F7DA371FA}
// *********************************************************************//
  IAddCustomerDisp = dispinterface
    ['{030CDE21-B48A-4691-B2AF-481F7DA371FA}']
  end;

// *********************************************************************//
// The Class CoAddCustomer provides a Create and CreateRemote method to          
// create instances of the default interface IAddCustomer exposed by              
// the CoClass AddCustomer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAddCustomer = class
    class function Create: IAddCustomer;
    class function CreateRemote(const MachineName: string): IAddCustomer;
  end;

implementation

uses ComObj;

class function CoAddCustomer.Create: IAddCustomer;
begin
  Result := CreateComObject(CLASS_AddCustomer) as IAddCustomer;
end;

class function CoAddCustomer.CreateRemote(const MachineName: string): IAddCustomer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AddCustomer) as IAddCustomer;
end;

end.
