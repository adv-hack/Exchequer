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
// File generated on 26/07/2006 12:58:41 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\DSR\ProcessFile\DSRProcessMail.tlb (1)
// LIBID: {AA932A26-12EC-44E8-924E-E511DE6349CE}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
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
  DSRReceiverMajorVersion = 1;
  DSRReceiverMinorVersion = 0;

  LIBID_DSRReceiver: TGUID = '{AA932A26-12EC-44E8-924E-E511DE6349CE}';

  IID_IDSRReceiverSystem: TGUID = '{DFFF3635-6EB6-4898-89D7-164E3198F96D}';
  CLASS_DSRReceiverSystem: TGUID = '{22C24140-A999-403A-9760-61D7C0035048}';
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
  DSRReceiverSystem = IDSRReceiverSystem;


// *********************************************************************//
// Interface: IDSRReceiverSystem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DFFF3635-6EB6-4898-89D7-164E3198F96D}
// *********************************************************************//
  IDSRReceiverSystem = interface(IDispatch)
    ['{DFFF3635-6EB6-4898-89D7-164E3198F96D}']
    function Receive(const pSubject: WideString; const pSender: WideString; const pTo: WideString; 
                     const pFiles: WideString): LongWord; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDSRReceiverSystemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DFFF3635-6EB6-4898-89D7-164E3198F96D}
// *********************************************************************//
  IDSRReceiverSystemDisp = dispinterface
    ['{DFFF3635-6EB6-4898-89D7-164E3198F96D}']
    function Receive(const pSubject: WideString; const pSender: WideString; const pTo: WideString; 
                     const pFiles: WideString): LongWord; dispid 1;
  end;

// *********************************************************************//
// The Class CoDSRReceiverSystem provides a Create and CreateRemote method to          
// create instances of the default interface IDSRReceiverSystem exposed by              
// the CoClass DSRReceiverSystem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSRReceiverSystem = class
    class function Create: IDSRReceiverSystem;
    class function CreateRemote(const MachineName: string): IDSRReceiverSystem;
  end;

implementation

uses ComObj;

class function CoDSRReceiverSystem.Create: IDSRReceiverSystem;
begin
  Result := CreateComObject(CLASS_DSRReceiverSystem) as IDSRReceiverSystem;
end;

class function CoDSRReceiverSystem.CreateRemote(const MachineName: string): IDSRReceiverSystem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSRReceiverSystem) as IDSRReceiverSystem;
end;

end.
