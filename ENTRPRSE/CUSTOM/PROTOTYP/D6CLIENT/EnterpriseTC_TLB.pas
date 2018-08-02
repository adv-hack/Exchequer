unit EnterpriseTC_TLB;

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
// File generated on 09/08/2002 10:30:45 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\CUSTOM\PROTOTYP\D6CLIENT\D6CLIENT.tlb (1)
// LIBID: {D9C54208-4A40-4F4D-9F24-98447E06FFB9}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
//   (3) v1.0 EnterpriseTrade, (\\SBS_SERVER\VOL2\ENT500\ENTRPRSE\CUSTOM\PROTOTYP\ENTTRADE.EXE)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, EnterpriseTrade_TLB, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  EnterpriseTCMajorVersion = 1;
  EnterpriseTCMinorVersion = 0;

  LIBID_EnterpriseTC: TGUID = '{D9C54208-4A40-4F4D-9F24-98447E06FFB9}';

  IID_ID6Client: TGUID = '{CD913156-53DE-4FE4-9241-05594447D7A6}';
  CLASS_D6Client: TGUID = '{8830B81A-B68E-428F-9F4D-98FB4A9AB120}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ID6Client = interface;
  ID6ClientDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  D6Client = ID6Client;


// *********************************************************************//
// Interface: ID6Client
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CD913156-53DE-4FE4-9241-05594447D7A6}
// *********************************************************************//
  ID6Client = interface(IDispatch)
    ['{CD913156-53DE-4FE4-9241-05594447D7A6}']
  end;

// *********************************************************************//
// DispIntf:  ID6ClientDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CD913156-53DE-4FE4-9241-05594447D7A6}
// *********************************************************************//
  ID6ClientDisp = dispinterface
    ['{CD913156-53DE-4FE4-9241-05594447D7A6}']
  end;

// *********************************************************************//
// The Class CoD6Client provides a Create and CreateRemote method to          
// create instances of the default interface ID6Client exposed by              
// the CoClass D6Client. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoD6Client = class
    class function Create: ID6Client;
    class function CreateRemote(const MachineName: string): ID6Client;
  end;

implementation

uses ComObj;

class function CoD6Client.Create: ID6Client;
begin
  Result := CreateComObject(CLASS_D6Client) as ID6Client;
end;

class function CoD6Client.CreateRemote(const MachineName: string): ID6Client;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_D6Client) as ID6Client;
end;

end.
