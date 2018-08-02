unit CISOutgoing_TLB;

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
// File generated on 09/02/2007 08:31:21 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\CISOutgoing\CISOutgoing.tlb (1)
// LIBID: {AB099B5F-33B0-4880-919D-1D7BA7974ADC}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v1.0 DSROutgoing, (C:\Projects\Ice\Bin\DSROutgoing.dll)
//   (3) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, DSROutgoing_TLB, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  CISOutgoingMajorVersion = 1;
  CISOutgoingMinorVersion = 0;

  LIBID_CISOutgoing: TGUID = '{AB099B5F-33B0-4880-919D-1D7BA7974ADC}';

  IID_ICISSending: TGUID = '{311210FF-4850-4862-80FE-BC72E95A1BC0}';
  CLASS_CISSending: TGUID = '{D27B5042-0761-4F73-A233-9BAF7D01159D}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ICISSending = interface;
  ICISSendingDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CISSending = ICISSending;


// *********************************************************************//
// Interface: ICISSending
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {311210FF-4850-4862-80FE-BC72E95A1BC0}
// *********************************************************************//
  ICISSending = interface(IDispatch)
    ['{311210FF-4850-4862-80FE-BC72E95A1BC0}']
  end;

// *********************************************************************//
// DispIntf:  ICISSendingDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {311210FF-4850-4862-80FE-BC72E95A1BC0}
// *********************************************************************//
  ICISSendingDisp = dispinterface
    ['{311210FF-4850-4862-80FE-BC72E95A1BC0}']
  end;

// *********************************************************************//
// The Class CoCISSending provides a Create and CreateRemote method to          
// create instances of the default interface ICISSending exposed by              
// the CoClass CISSending. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCISSending = class
    class function Create: ICISSending;
    class function CreateRemote(const MachineName: string): ICISSending;
  end;

implementation

uses ComObj;

class function CoCISSending.Create: ICISSending;
begin
  Result := CreateComObject(CLASS_CISSending) as ICISSending;
end;

class function CoCISSending.CreateRemote(const MachineName: string): ICISSending;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CISSending) as ICISSending;
end;

end.
