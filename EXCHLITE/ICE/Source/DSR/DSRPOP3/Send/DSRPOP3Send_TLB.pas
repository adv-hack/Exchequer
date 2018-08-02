unit DSRPOP3Send_TLB;

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
// File generated on 13/02/2007 09:00:13 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\DSR\DSRPOP3\Send\DSRPOP3Send.tlb (1)
// LIBID: {CB459DF4-607C-4277-88AC-18487D2739D9}
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
  DSRPOP3SendMajorVersion = 1;
  DSRPOP3SendMinorVersion = 0;

  LIBID_DSRPOP3Send: TGUID = '{CB459DF4-607C-4277-88AC-18487D2739D9}';

  IID_IDSRPOP3Sender: TGUID = '{3B656EAC-2D27-404C-B3AD-71ED56AB86EF}';
  CLASS_DSRPOP3Sender: TGUID = '{0FBAC6CD-148A-432B-B11A-F21FF160CFD2}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSRPOP3Sender = interface;
  IDSRPOP3SenderDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSRPOP3Sender = IDSRPOP3Sender;


// *********************************************************************//
// Interface: IDSRPOP3Sender
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3B656EAC-2D27-404C-B3AD-71ED56AB86EF}
// *********************************************************************//
  IDSRPOP3Sender = interface(IDispatch)
    ['{3B656EAC-2D27-404C-B3AD-71ED56AB86EF}']
  end;

// *********************************************************************//
// DispIntf:  IDSRPOP3SenderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3B656EAC-2D27-404C-B3AD-71ED56AB86EF}
// *********************************************************************//
  IDSRPOP3SenderDisp = dispinterface
    ['{3B656EAC-2D27-404C-B3AD-71ED56AB86EF}']
  end;

// *********************************************************************//
// The Class CoDSRPOP3Sender provides a Create and CreateRemote method to          
// create instances of the default interface IDSRPOP3Sender exposed by              
// the CoClass DSRPOP3Sender. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSRPOP3Sender = class
    class function Create: IDSRPOP3Sender;
    class function CreateRemote(const MachineName: string): IDSRPOP3Sender;
  end;

implementation

uses ComObj;

class function CoDSRPOP3Sender.Create: IDSRPOP3Sender;
begin
  Result := CreateComObject(CLASS_DSRPOP3Sender) as IDSRPOP3Sender;
end;

class function CoDSRPOP3Sender.CreateRemote(const MachineName: string): IDSRPOP3Sender;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSRPOP3Sender) as IDSRPOP3Sender;
end;

end.
