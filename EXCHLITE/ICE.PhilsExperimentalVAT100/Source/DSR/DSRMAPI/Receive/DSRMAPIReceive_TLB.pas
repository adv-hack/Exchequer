unit DSRMAPIReceive_TLB;

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
// File generated on 08/02/2007 17:40:42 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\DSR\DSRMAPI\Receive\DSRMAPIReceive.tlb (1)
// LIBID: {302FAC76-960E-440A-82E7-EAADC2287D49}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
//   (3) v1.0 DSRIncoming, (C:\Projects\Ice\Bin\dsrincoming.dll)
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
  DSRMAPIReceiveMajorVersion = 1;
  DSRMAPIReceiveMinorVersion = 0;

  LIBID_DSRMAPIReceive: TGUID = '{302FAC76-960E-440A-82E7-EAADC2287D49}';

  IID_IDSRMAPIReceiver: TGUID = '{E5DC37AF-42F7-4D36-909B-192C0E814AB0}';
  CLASS_DSRMAPIReceiver: TGUID = '{853711E2-67B3-4757-BF42-FD3BE49B74F7}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSRMAPIReceiver = interface;
  IDSRMAPIReceiverDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSRMAPIReceiver = IDSRMAPIReceiver;


// *********************************************************************//
// Interface: IDSRMAPIReceiver
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E5DC37AF-42F7-4D36-909B-192C0E814AB0}
// *********************************************************************//
  IDSRMAPIReceiver = interface(IDispatch)
    ['{E5DC37AF-42F7-4D36-909B-192C0E814AB0}']
  end;

// *********************************************************************//
// DispIntf:  IDSRMAPIReceiverDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E5DC37AF-42F7-4D36-909B-192C0E814AB0}
// *********************************************************************//
  IDSRMAPIReceiverDisp = dispinterface
    ['{E5DC37AF-42F7-4D36-909B-192C0E814AB0}']
  end;

// *********************************************************************//
// The Class CoDSRMAPIReceiver provides a Create and CreateRemote method to          
// create instances of the default interface IDSRMAPIReceiver exposed by              
// the CoClass DSRMAPIReceiver. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSRMAPIReceiver = class
    class function Create: IDSRMAPIReceiver;
    class function CreateRemote(const MachineName: string): IDSRMAPIReceiver;
  end;

implementation

uses ComObj;

class function CoDSRMAPIReceiver.Create: IDSRMAPIReceiver;
begin
  Result := CreateComObject(CLASS_DSRMAPIReceiver) as IDSRMAPIReceiver;
end;

class function CoDSRMAPIReceiver.CreateRemote(const MachineName: string): IDSRMAPIReceiver;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSRMAPIReceiver) as IDSRMAPIReceiver;
end;

end.
