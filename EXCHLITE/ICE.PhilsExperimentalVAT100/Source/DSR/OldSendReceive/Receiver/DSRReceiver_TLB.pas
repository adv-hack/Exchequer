unit DSRReceiver_TLB;

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
// File generated on 02/10/2006 12:44:35 from Type Library described below.

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
  DSRReceiverMajorVersion = 1;
  DSRReceiverMinorVersion = 0;

  LIBID_DSRReceiver: TGUID = '{EEDFBC9C-374B-42F4-B9CE-0DB5C79FF1B1}';

  IID_IDSRReceiverSystem: TGUID = '{5144DEFB-C207-4F53-870A-71DC8D7AA76D}';
  CLASS_DSRReceiverSystem: TGUID = '{E3D204B8-390E-4B99-9575-309E5FEE3598}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSRReceiverSystem = interface;
  IDSRReceiverSystemDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSRReceiverSystem = IDSRIncomingSystem;


// *********************************************************************//
// Interface: IDSRReceiverSystem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5144DEFB-C207-4F53-870A-71DC8D7AA76D}
// *********************************************************************//
  IDSRReceiverSystem = interface(IDispatch)
    ['{5144DEFB-C207-4F53-870A-71DC8D7AA76D}']
  end;

// *********************************************************************//
// DispIntf:  IDSRReceiverSystemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5144DEFB-C207-4F53-870A-71DC8D7AA76D}
// *********************************************************************//
  IDSRReceiverSystemDisp = dispinterface
    ['{5144DEFB-C207-4F53-870A-71DC8D7AA76D}']
  end;

// *********************************************************************//
// The Class CoDSRReceiverSystem provides a Create and CreateRemote method to          
// create instances of the default interface IDSRIncomingSystem exposed by              
// the CoClass DSRReceiverSystem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSRReceiverSystem = class
    class function Create: IDSRIncomingSystem;
    class function CreateRemote(const MachineName: string): IDSRIncomingSystem;
  end;

implementation

uses ComObj;

class function CoDSRReceiverSystem.Create: IDSRIncomingSystem;
begin
  Result := CreateComObject(CLASS_DSRReceiverSystem) as IDSRIncomingSystem;
end;

class function CoDSRReceiverSystem.CreateRemote(const MachineName: string): IDSRIncomingSystem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSRReceiverSystem) as IDSRIncomingSystem;
end;

end.
