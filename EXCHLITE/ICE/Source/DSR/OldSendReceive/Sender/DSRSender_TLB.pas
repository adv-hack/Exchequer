unit DSRSender_TLB;

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
// File generated on 02/10/2006 13:06:19 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\DSR\Sender\DSRSender.tlb (1)
// LIBID: {F9679B68-2908-47BD-9795-BD639A29E4E6}
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
  DSRSenderMajorVersion = 1;
  DSRSenderMinorVersion = 0;

  LIBID_DSRSender: TGUID = '{F9679B68-2908-47BD-9795-BD639A29E4E6}';

  IID_IDSREmailSender: TGUID = '{E18890DB-78E5-4479-99BE-8823882E0439}';
  CLASS_DSREmailSender: TGUID = '{B53DD5E9-35A8-4B03-990F-7E4CD88D16E1}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSREmailSender = interface;
  IDSREmailSenderDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSREmailSender = IDSREmailSender;


// *********************************************************************//
// Interface: IDSREmailSender
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E18890DB-78E5-4479-99BE-8823882E0439}
// *********************************************************************//
  IDSREmailSender = interface(IDispatch)
    ['{E18890DB-78E5-4479-99BE-8823882E0439}']
  end;

// *********************************************************************//
// DispIntf:  IDSREmailSenderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E18890DB-78E5-4479-99BE-8823882E0439}
// *********************************************************************//
  IDSREmailSenderDisp = dispinterface
    ['{E18890DB-78E5-4479-99BE-8823882E0439}']
  end;

// *********************************************************************//
// The Class CoDSREmailSender provides a Create and CreateRemote method to          
// create instances of the default interface IDSREmailSender exposed by              
// the CoClass DSREmailSender. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSREmailSender = class
    class function Create: IDSREmailSender;
    class function CreateRemote(const MachineName: string): IDSREmailSender;
  end;

implementation

uses ComObj;

class function CoDSREmailSender.Create: IDSREmailSender;
begin
  Result := CreateComObject(CLASS_DSREmailSender) as IDSREmailSender;
end;

class function CoDSREmailSender.CreateRemote(const MachineName: string): IDSREmailSender;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSREmailSender) as IDSREmailSender;
end;

end.
