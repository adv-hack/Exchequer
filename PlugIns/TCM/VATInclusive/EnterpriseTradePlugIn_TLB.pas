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
// File generated on 12/03/2003 10:47:19 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\EPOS\PLUGINS\VATINC\VATInc.tlb (1)
// LIBID: {932A7235-D80E-4DE0-AC89-FDBCCBAA635C}
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

  LIBID_EnterpriseTradePlugIn: TGUID = '{932A7235-D80E-4DE0-AC89-FDBCCBAA635C}';

  IID_IVATInclusive: TGUID = '{DF0F1DF6-D28E-41EE-9483-71B8B25B8F6A}';
  CLASS_VATInclusive: TGUID = '{B68338A1-C104-42DA-86D0-9BEC7C89F922}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IVATInclusive = interface;
  IVATInclusiveDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  VATInclusive = IVATInclusive;


// *********************************************************************//
// Interface: IVATInclusive
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DF0F1DF6-D28E-41EE-9483-71B8B25B8F6A}
// *********************************************************************//
  IVATInclusive = interface(IDispatch)
    ['{DF0F1DF6-D28E-41EE-9483-71B8B25B8F6A}']
  end;

// *********************************************************************//
// DispIntf:  IVATInclusiveDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DF0F1DF6-D28E-41EE-9483-71B8B25B8F6A}
// *********************************************************************//
  IVATInclusiveDisp = dispinterface
    ['{DF0F1DF6-D28E-41EE-9483-71B8B25B8F6A}']
  end;

// *********************************************************************//
// The Class CoVATInclusive provides a Create and CreateRemote method to          
// create instances of the default interface IVATInclusive exposed by              
// the CoClass VATInclusive. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoVATInclusive = class
    class function Create: IVATInclusive;
    class function CreateRemote(const MachineName: string): IVATInclusive;
  end;

implementation

uses ComObj;

class function CoVATInclusive.Create: IVATInclusive;
begin
  Result := CreateComObject(CLASS_VATInclusive) as IVATInclusive;
end;

class function CoVATInclusive.CreateRemote(const MachineName: string): IVATInclusive;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_VATInclusive) as IVATInclusive;
end;

end.
