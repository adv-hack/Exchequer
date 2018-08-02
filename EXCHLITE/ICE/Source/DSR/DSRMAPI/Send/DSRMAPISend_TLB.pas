unit DSRMAPISend_TLB;

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
// File generated on 08/02/2007 13:13:04 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\DSR\DSRMAPI\Send\DSRMAPISend.tlb (1)
// LIBID: {186CFE3A-41AA-4061-9627-5A9D00E5D100}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
//   (3) v1.0 DSROutgoing, (C:\Projects\Ice\Bin\DSROutgoing.dll)
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
  DSRMAPISendMajorVersion = 1;
  DSRMAPISendMinorVersion = 0;

  LIBID_DSRMAPISend: TGUID = '{186CFE3A-41AA-4061-9627-5A9D00E5D100}';

  IID_IDSRMAPISender: TGUID = '{48E0E835-F927-453A-9506-513755135195}';
  CLASS_DSRMAPISender: TGUID = '{561694D9-54E1-466E-A5C9-B59F6EBF96D0}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSRMAPISender = interface;
  IDSRMAPISenderDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSRMAPISender = IDSRMAPISender;


// *********************************************************************//
// Interface: IDSRMAPISender
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {48E0E835-F927-453A-9506-513755135195}
// *********************************************************************//
  IDSRMAPISender = interface(IDispatch)
    ['{48E0E835-F927-453A-9506-513755135195}']
  end;

// *********************************************************************//
// DispIntf:  IDSRMAPISenderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {48E0E835-F927-453A-9506-513755135195}
// *********************************************************************//
  IDSRMAPISenderDisp = dispinterface
    ['{48E0E835-F927-453A-9506-513755135195}']
  end;

// *********************************************************************//
// The Class CoDSRMAPISender provides a Create and CreateRemote method to          
// create instances of the default interface IDSRMAPISender exposed by              
// the CoClass DSRMAPISender. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSRMAPISender = class
    class function Create: IDSRMAPISender;
    class function CreateRemote(const MachineName: string): IDSRMAPISender;
  end;

implementation

uses ComObj;

class function CoDSRMAPISender.Create: IDSRMAPISender;
begin
  Result := CreateComObject(CLASS_DSRMAPISender) as IDSRMAPISender;
end;

class function CoDSRMAPISender.CreateRemote(const MachineName: string): IDSRMAPISender;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSRMAPISender) as IDSRMAPISender;
end;

end.
