unit SchedulerPlugIn_TLB;

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
// File generated on 05/06/2007 16:31:08 from Type Library described below.

// ************************************************************************  //
// Type Lib: U:\BESPOKE\EXCHEQR\ReverseChargeVAT\Scheduler\RVSched.tlb (1)
// LIBID: {BF31D588-1986-40EC-8ED0-E3C4EAA86295}
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
  SchedulerPlugInMajorVersion = 1;
  SchedulerPlugInMinorVersion = 0;

  LIBID_SchedulerPlugIn: TGUID = '{BF31D588-1986-40EC-8ED0-E3C4EAA86295}';

  IID_IReverseVATUpdateTX: TGUID = '{62732CD8-CF8C-4030-A347-0CF3A16B7E6F}';
  CLASS_ReverseVATUpdateTX: TGUID = '{99CDE377-BB5F-43FA-BD58-3A0B84DC30E5}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IReverseVATUpdateTX = interface;
  IReverseVATUpdateTXDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ReverseVATUpdateTX = IReverseVATUpdateTX;


// *********************************************************************//
// Interface: IReverseVATUpdateTX
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {62732CD8-CF8C-4030-A347-0CF3A16B7E6F}
// *********************************************************************//
  IReverseVATUpdateTX = interface(IDispatch)
    ['{62732CD8-CF8C-4030-A347-0CF3A16B7E6F}']
  end;

// *********************************************************************//
// DispIntf:  IReverseVATUpdateTXDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {62732CD8-CF8C-4030-A347-0CF3A16B7E6F}
// *********************************************************************//
  IReverseVATUpdateTXDisp = dispinterface
    ['{62732CD8-CF8C-4030-A347-0CF3A16B7E6F}']
  end;

// *********************************************************************//
// The Class CoReverseVATUpdateTX provides a Create and CreateRemote method to          
// create instances of the default interface IReverseVATUpdateTX exposed by              
// the CoClass ReverseVATUpdateTX. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoReverseVATUpdateTX = class
    class function Create: IReverseVATUpdateTX;
    class function CreateRemote(const MachineName: string): IReverseVATUpdateTX;
  end;

implementation

uses ComObj;

class function CoReverseVATUpdateTX.Create: IReverseVATUpdateTX;
begin
  Result := CreateComObject(CLASS_ReverseVATUpdateTX) as IReverseVATUpdateTX;
end;

class function CoReverseVATUpdateTX.CreateRemote(const MachineName: string): IReverseVATUpdateTX;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ReverseVATUpdateTX) as IReverseVATUpdateTX;
end;

end.
