unit EnterpriseTradePlugIn_TLB;

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
// File generated on 03/03/2006 16:17:32 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\EPOS\PlugIns\WEEE\TCMWEEEPI.tlb (1)
// LIBID: {D456791B-BE68-4009-98AC-FE0439998A7D}
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
  EnterpriseTradePlugInMajorVersion = 1;
  EnterpriseTradePlugInMinorVersion = 0;

  LIBID_EnterpriseTradePlugIn: TGUID = '{D456791B-BE68-4009-98AC-FE0439998A7D}';

  IID_IWEEE: TGUID = '{6DBA7759-7A47-4DF2-A427-F8E8BC5FDE5C}';
  CLASS_WEEE: TGUID = '{BF402E44-59B6-4C9B-8C7B-BF820C607D23}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IWEEE = interface;
  IWEEEDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  WEEE = IWEEE;


// *********************************************************************//
// Interface: IWEEE
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6DBA7759-7A47-4DF2-A427-F8E8BC5FDE5C}
// *********************************************************************//
  IWEEE = interface(IDispatch)
    ['{6DBA7759-7A47-4DF2-A427-F8E8BC5FDE5C}']
  end;

// *********************************************************************//
// DispIntf:  IWEEEDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6DBA7759-7A47-4DF2-A427-F8E8BC5FDE5C}
// *********************************************************************//
  IWEEEDisp = dispinterface
    ['{6DBA7759-7A47-4DF2-A427-F8E8BC5FDE5C}']
  end;

// *********************************************************************//
// The Class CoWEEE provides a Create and CreateRemote method to          
// create instances of the default interface IWEEE exposed by              
// the CoClass WEEE. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoWEEE = class
    class function Create: IWEEE;
    class function CreateRemote(const MachineName: string): IWEEE;
  end;

implementation

uses ComObj;

class function CoWEEE.Create: IWEEE;
begin
  Result := CreateComObject(CLASS_WEEE) as IWEEE;
end;

class function CoWEEE.CreateRemote(const MachineName: string): IWEEE;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_WEEE) as IWEEE;
end;

end.
