unit DSRIMAPReceive_TLB;

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
// File generated on 08/02/2007 22:33:13 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\DSR\DSRIMAP\Receive\DSRIMAPReceive.tlb (1)
// LIBID: {C8E35CAF-921B-414E-B7A6-0B187C8CDD0D}
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
  DSRIMAPReceiveMajorVersion = 1;
  DSRIMAPReceiveMinorVersion = 0;

  LIBID_DSRIMAPReceive: TGUID = '{C8E35CAF-921B-414E-B7A6-0B187C8CDD0D}';

  IID_IDSRIMAPReceiver: TGUID = '{F30C88B1-D5C1-4054-BE82-81E36103045B}';
  CLASS_DSRIMAPReceiver: TGUID = '{CCF5CF74-2E5E-48D0-B27C-FF5B32F5CCB2}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSRIMAPReceiver = interface;
  IDSRIMAPReceiverDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSRIMAPReceiver = IDSRIMAPReceiver;


// *********************************************************************//
// Interface: IDSRIMAPReceiver
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F30C88B1-D5C1-4054-BE82-81E36103045B}
// *********************************************************************//
  IDSRIMAPReceiver = interface(IDispatch)
    ['{F30C88B1-D5C1-4054-BE82-81E36103045B}']
  end;

// *********************************************************************//
// DispIntf:  IDSRIMAPReceiverDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F30C88B1-D5C1-4054-BE82-81E36103045B}
// *********************************************************************//
  IDSRIMAPReceiverDisp = dispinterface
    ['{F30C88B1-D5C1-4054-BE82-81E36103045B}']
  end;

// *********************************************************************//
// The Class CoDSRIMAPReceiver provides a Create and CreateRemote method to          
// create instances of the default interface IDSRIMAPReceiver exposed by              
// the CoClass DSRIMAPReceiver. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSRIMAPReceiver = class
    class function Create: IDSRIMAPReceiver;
    class function CreateRemote(const MachineName: string): IDSRIMAPReceiver;
  end;

implementation

uses ComObj;

class function CoDSRIMAPReceiver.Create: IDSRIMAPReceiver;
begin
  Result := CreateComObject(CLASS_DSRIMAPReceiver) as IDSRIMAPReceiver;
end;

class function CoDSRIMAPReceiver.CreateRemote(const MachineName: string): IDSRIMAPReceiver;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSRIMAPReceiver) as IDSRIMAPReceiver;
end;

end.
