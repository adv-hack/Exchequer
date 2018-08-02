unit VAT100Outgoing_TLB;

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

// PASTLWTR : $Revision:   1.130.1.0.1.0.1.6  $
// File generated on 26/06/2013 14:25:06 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\VAT100Outgoing\VAT100Outgoing.tlb (1)
// LIBID: {667FD24E-0FF9-47B6-AF73-22F8979F95EB}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
//   (2) v1.0 DSROutgoing, (C:\EXCH70P\DSROutgoing.dll)
//   (3) v4.0 StdVCL, (C:\Windows\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
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
  VAT100OutgoingMajorVersion = 1;
  VAT100OutgoingMinorVersion = 0;

  LIBID_VAT100Outgoing: TGUID = '{667FD24E-0FF9-47B6-AF73-22F8979F95EB}';

  IID_IVAT100Sending: TGUID = '{65D11710-C861-4697-BD86-82FA83AAE337}';
  CLASS_VAT100Sending: TGUID = '{D8213C1E-2EEB-4171-82D9-53984109B526}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IVAT100Sending = interface;
  IVAT100SendingDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  VAT100Sending = IVAT100Sending;


// *********************************************************************//
// Interface: IVAT100Sending
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {65D11710-C861-4697-BD86-82FA83AAE337}
// *********************************************************************//
  IVAT100Sending = interface(IDispatch)
    ['{65D11710-C861-4697-BD86-82FA83AAE337}']
  end;

// *********************************************************************//
// DispIntf:  IVAT100SendingDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {65D11710-C861-4697-BD86-82FA83AAE337}
// *********************************************************************//
  IVAT100SendingDisp = dispinterface
    ['{65D11710-C861-4697-BD86-82FA83AAE337}']
  end;

// *********************************************************************//
// The Class CoVAT100Sending provides a Create and CreateRemote method to          
// create instances of the default interface IVAT100Sending exposed by              
// the CoClass VAT100Sending. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoVAT100Sending = class
    class function Create: IVAT100Sending;
    class function CreateRemote(const MachineName: string): IVAT100Sending;
  end;

implementation

uses ComObj;

class function CoVAT100Sending.Create: IVAT100Sending;
begin
  Result := CreateComObject(CLASS_VAT100Sending) as IVAT100Sending;
end;

class function CoVAT100Sending.CreateRemote(const MachineName: string): IVAT100Sending;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_VAT100Sending) as IVAT100Sending;
end;

end.
