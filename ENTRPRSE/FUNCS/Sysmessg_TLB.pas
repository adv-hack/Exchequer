unit Sysmessg_TLB;

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
// File generated on 02/09/2005 08:53:45 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Develop\Projects\DEBUG\Sysmessg.tlb (1)
// LIBID: {E4DAF0AB-EC64-44E3-BCF5-CA62193A8603}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
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
  SysmessgMajorVersion = 1;
  SysmessgMinorVersion = 0;

  LIBID_Sysmessg: TGUID = '{E4DAF0AB-EC64-44E3-BCF5-CA62193A8603}';

  IID_IDebugServer: TGUID = '{0B3E9681-7662-41E5-9301-FC215092217F}';
  CLASS_DebugServer: TGUID = '{AB76AB2B-1615-43A3-95CD-91BB0E3C4CFF}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDebugServer = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DebugServer = IDebugServer;


// *********************************************************************//
// Interface: IDebugServer
// Flags:     (256) OleAutomation
// GUID:      {0B3E9681-7662-41E5-9301-FC215092217F}
// *********************************************************************//
  IDebugServer = interface(IUnknown)
    ['{0B3E9681-7662-41E5-9301-FC215092217F}']
    function Clear: HResult; stdcall;
    function AddUsage: HResult; stdcall;
    function DecUsage: HResult; stdcall;
    function DisplayMsg(Group: SYSINT; const Msg: WideString): HResult; stdcall;
    function Indent(NumChars: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoDebugServer provides a Create and CreateRemote method to          
// create instances of the default interface IDebugServer exposed by              
// the CoClass DebugServer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDebugServer = class
    class function Create: IDebugServer;
    class function CreateRemote(const MachineName: string): IDebugServer;
  end;

implementation

uses ComObj;

class function CoDebugServer.Create: IDebugServer;
begin
  Result := CreateComObject(CLASS_DebugServer) as IDebugServer;
end;

class function CoDebugServer.CreateRemote(const MachineName: string): IDebugServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DebugServer) as IDebugServer;
end;

end.
