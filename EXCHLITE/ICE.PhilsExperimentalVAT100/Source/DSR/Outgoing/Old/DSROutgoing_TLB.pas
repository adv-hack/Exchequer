unit DSROutgoing_TLB;

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
// File generated on 26/01/2007 12:51:32 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\DSR\Outgoing\DSROutgoing.tlb (1)
// LIBID: {F061BE4B-DB67-4121-A413-0137F7A767EF}
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
  DSROutgoingMajorVersion = 1;
  DSROutgoingMinorVersion = 0;

  LIBID_DSROutgoing: TGUID = '{F061BE4B-DB67-4121-A413-0137F7A767EF}';

  IID_IDSROutgoingSystem: TGUID = '{67C7CC27-2909-4273-B224-806A99814A6D}';
  CLASS_DSROutgoingSystem: TGUID = '{58B62A90-9EB7-43E9-8D0C-65E58B05919A}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSROutgoingSystem = interface;
  IDSROutgoingSystemDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSROutgoingSystem = IDSROutgoingSystem;


// *********************************************************************//
// Interface: IDSROutgoingSystem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {67C7CC27-2909-4273-B224-806A99814A6D}
// *********************************************************************//
  IDSROutgoingSystem = interface(IDispatch)
    ['{67C7CC27-2909-4273-B224-806A99814A6D}']
    function SendMsg(const pFrom: WideString; const pTo: WideString; const pSubject: WideString; 
                     const pBody: WideString; const pFiles: WideString): LongWord; safecall;
    function SendMsgEx(const pHost: WideString; pPort: Integer; const pFrom: WideString; 
                       const pTo: WideString; const pSubj: WideString; const pBody: WideString; 
                       const pFiles: WideString): LongWord; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDSROutgoingSystemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {67C7CC27-2909-4273-B224-806A99814A6D}
// *********************************************************************//
  IDSROutgoingSystemDisp = dispinterface
    ['{67C7CC27-2909-4273-B224-806A99814A6D}']
    function SendMsg(const pFrom: WideString; const pTo: WideString; const pSubject: WideString; 
                     const pBody: WideString; const pFiles: WideString): LongWord; dispid 1;
    function SendMsgEx(const pHost: WideString; pPort: Integer; const pFrom: WideString; 
                       const pTo: WideString; const pSubj: WideString; const pBody: WideString; 
                       const pFiles: WideString): LongWord; dispid 2;
  end;

// *********************************************************************//
// The Class CoDSROutgoingSystem provides a Create and CreateRemote method to          
// create instances of the default interface IDSROutgoingSystem exposed by              
// the CoClass DSROutgoingSystem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSROutgoingSystem = class
    class function Create: IDSROutgoingSystem;
    class function CreateRemote(const MachineName: string): IDSROutgoingSystem;
  end;

implementation

uses ComObj;

class function CoDSROutgoingSystem.Create: IDSROutgoingSystem;
begin
  Result := CreateComObject(CLASS_DSROutgoingSystem) as IDSROutgoingSystem;
end;

class function CoDSROutgoingSystem.CreateRemote(const MachineName: string): IDSROutgoingSystem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSROutgoingSystem) as IDSROutgoingSystem;
end;

end.
