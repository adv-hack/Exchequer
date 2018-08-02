unit DSRPOP3Receive_TLB;

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
// File generated on 08/02/2007 13:43:06 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\DSR\DSRPOP3\Receive\DSRPOP3Receive.tlb (1)
// LIBID: {FEF10215-191A-4EEB-B730-0A8F980F5F6D}
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
  DSRPOP3ReceiveMajorVersion = 1;
  DSRPOP3ReceiveMinorVersion = 0;

  LIBID_DSRPOP3Receive: TGUID = '{FEF10215-191A-4EEB-B730-0A8F980F5F6D}';

  IID_IDSRPOP3Receiver: TGUID = '{A4B490B2-34FB-48D7-8E7B-121000A322B3}';
  CLASS_DSRPOP3Receiver: TGUID = '{3125A204-77B9-4005-9430-21602D3C1175}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSRPOP3Receiver = interface;
  IDSRPOP3ReceiverDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSRPOP3Receiver = IDSRPOP3Receiver;


// *********************************************************************//
// Interface: IDSRPOP3Receiver
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A4B490B2-34FB-48D7-8E7B-121000A322B3}
// *********************************************************************//
  IDSRPOP3Receiver = interface(IDispatch)
    ['{A4B490B2-34FB-48D7-8E7B-121000A322B3}']
  end;

// *********************************************************************//
// DispIntf:  IDSRPOP3ReceiverDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A4B490B2-34FB-48D7-8E7B-121000A322B3}
// *********************************************************************//
  IDSRPOP3ReceiverDisp = dispinterface
    ['{A4B490B2-34FB-48D7-8E7B-121000A322B3}']
  end;

// *********************************************************************//
// The Class CoDSRPOP3Receiver provides a Create and CreateRemote method to          
// create instances of the default interface IDSRPOP3Receiver exposed by              
// the CoClass DSRPOP3Receiver. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSRPOP3Receiver = class
    class function Create: IDSRPOP3Receiver;
    class function CreateRemote(const MachineName: string): IDSRPOP3Receiver;
  end;

implementation

uses ComObj;

class function CoDSRPOP3Receiver.Create: IDSRPOP3Receiver;
begin
  Result := CreateComObject(CLASS_DSRPOP3Receiver) as IDSRPOP3Receiver;
end;

class function CoDSRPOP3Receiver.CreateRemote(const MachineName: string): IDSRPOP3Receiver;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSRPOP3Receiver) as IDSRPOP3Receiver;
end;

end.
