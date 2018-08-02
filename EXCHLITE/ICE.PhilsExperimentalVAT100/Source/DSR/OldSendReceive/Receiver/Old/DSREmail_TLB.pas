unit DSREmail_TLB;

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
// File generated on 26/07/2006 12:52:46 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\DSR\Receiver\DSRReceiver.tlb (1)
// LIBID: {EEDFBC9C-374B-42F4-B9CE-0DB5C79FF1B1}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v1.0 DSRIncoming, (C:\Projects\Ice\Bin\DSRIncoming.dll)
//   (3) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, DSRIncoming_TLB, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  DSREmailMajorVersion = 1;
  DSREmailMinorVersion = 0;

  LIBID_DSREmail: TGUID = '{EEDFBC9C-374B-42F4-B9CE-0DB5C79FF1B1}';

  IID_IDSREmailSystem: TGUID = '{5144DEFB-C207-4F53-870A-71DC8D7AA76D}';
  CLASS_DSREmailSystem: TGUID = '{E3D204B8-390E-4B99-9575-309E5FEE3598}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSREmailSystem = interface;
  IDSREmailSystemDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSREmailSystem = IDSREmailSystem;


// *********************************************************************//
// Interface: IDSREmailSystem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5144DEFB-C207-4F53-870A-71DC8D7AA76D}
// *********************************************************************//
  IDSREmailSystem = interface(IDispatch)
    ['{5144DEFB-C207-4F53-870A-71DC8D7AA76D}']
  end;

// *********************************************************************//
// DispIntf:  IDSREmailSystemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5144DEFB-C207-4F53-870A-71DC8D7AA76D}
// *********************************************************************//
  IDSREmailSystemDisp = dispinterface
    ['{5144DEFB-C207-4F53-870A-71DC8D7AA76D}']
  end;

// *********************************************************************//
// The Class CoDSREmailSystem provides a Create and CreateRemote method to          
// create instances of the default interface IDSREmailSystem exposed by              
// the CoClass DSREmailSystem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSREmailSystem = class
    class function Create: IDSREmailSystem;
    class function CreateRemote(const MachineName: string): IDSREmailSystem;
  end;

implementation

uses ComObj;

class function CoDSREmailSystem.Create: IDSREmailSystem;
begin
  Result := CreateComObject(CLASS_DSREmailSystem) as IDSREmailSystem;
end;

class function CoDSREmailSystem.CreateRemote(const MachineName: string): IDSREmailSystem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSREmailSystem) as IDSREmailSystem;
end;

end.
