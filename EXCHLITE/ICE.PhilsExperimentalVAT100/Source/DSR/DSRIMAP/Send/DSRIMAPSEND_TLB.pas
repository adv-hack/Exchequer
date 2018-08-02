unit DSRIMAPSEND_TLB;

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
// File generated on 08/02/2007 13:25:05 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\DSR\DSRIMAP\Send\DSRIMAPSEND.tlb (1)
// LIBID: {29E8AB1C-A69B-47EF-B283-94A6B0E04D89}
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
  DSRIMAPSENDMajorVersion = 1;
  DSRIMAPSENDMinorVersion = 0;

  LIBID_DSRIMAPSEND: TGUID = '{29E8AB1C-A69B-47EF-B283-94A6B0E04D89}';

  IID_IDSRIMAPSender: TGUID = '{B9E52B19-4B2A-4A69-B71E-F972B98F52D1}';
  CLASS_DSRIMAPSender: TGUID = '{CD30597C-2A09-491B-BA48-7655F701EFF7}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSRIMAPSender = interface;
  IDSRIMAPSenderDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSRIMAPSender = IDSRIMAPSender;


// *********************************************************************//
// Interface: IDSRIMAPSender
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B9E52B19-4B2A-4A69-B71E-F972B98F52D1}
// *********************************************************************//
  IDSRIMAPSender = interface(IDispatch)
    ['{B9E52B19-4B2A-4A69-B71E-F972B98F52D1}']
  end;

// *********************************************************************//
// DispIntf:  IDSRIMAPSenderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B9E52B19-4B2A-4A69-B71E-F972B98F52D1}
// *********************************************************************//
  IDSRIMAPSenderDisp = dispinterface
    ['{B9E52B19-4B2A-4A69-B71E-F972B98F52D1}']
  end;

// *********************************************************************//
// The Class CoDSRIMAPSender provides a Create and CreateRemote method to          
// create instances of the default interface IDSRIMAPSender exposed by              
// the CoClass DSRIMAPSender. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSRIMAPSender = class
    class function Create: IDSRIMAPSender;
    class function CreateRemote(const MachineName: string): IDSRIMAPSender;
  end;

implementation

uses ComObj;

class function CoDSRIMAPSender.Create: IDSRIMAPSender;
begin
  Result := CreateComObject(CLASS_DSRIMAPSender) as IDSRIMAPSender;
end;

class function CoDSRIMAPSender.CreateRemote(const MachineName: string): IDSRIMAPSender;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSRIMAPSender) as IDSRIMAPSender;
end;

end.
