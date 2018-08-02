unit IRISTimesheets_TLB;

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
// File generated on 23/01/2009 10:24:33 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Dev\KPI-ExchOut\Timesheets.tlb (1)
// LIBID: {1F2CDBE9-38F5-4B6B-A5BA-A793AF23867E}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
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
  IRISTimesheetsMajorVersion = 1;
  IRISTimesheetsMinorVersion = 0;

  LIBID_IRISTimesheets: TGUID = '{1F2CDBE9-38F5-4B6B-A5BA-A793AF23867E}';

  IID_IODDTimesheets: TGUID = '{DACC5838-75C2-4785-941D-D74642781654}';
  CLASS_ODDTimesheets: TGUID = '{88738FD0-7BEE-4B6C-9C06-E4582F210B6C}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IODDTimesheets = interface;
  IODDTimesheetsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ODDTimesheets = IODDTimesheets;


// *********************************************************************//
// Interface: IODDTimesheets
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DACC5838-75C2-4785-941D-D74642781654}
// *********************************************************************//
  IODDTimesheets = interface(IDispatch)
    ['{DACC5838-75C2-4785-941D-D74642781654}']
    procedure Startup(const A: WideString; const B: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IODDTimesheetsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DACC5838-75C2-4785-941D-D74642781654}
// *********************************************************************//
  IODDTimesheetsDisp = dispinterface
    ['{DACC5838-75C2-4785-941D-D74642781654}']
    procedure Startup(const A: WideString; const B: WideString); dispid 1;
  end;

// *********************************************************************//
// The Class CoODDTimesheets provides a Create and CreateRemote method to          
// create instances of the default interface IODDTimesheets exposed by              
// the CoClass ODDTimesheets. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoODDTimesheets = class
    class function Create: IODDTimesheets;
    class function CreateRemote(const MachineName: string): IODDTimesheets;
  end;

implementation

uses ComObj;

class function CoODDTimesheets.Create: IODDTimesheets;
begin
  Result := CreateComObject(CLASS_ODDTimesheets) as IODDTimesheets;
end;

class function CoODDTimesheets.CreateRemote(const MachineName: string): IODDTimesheets;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ODDTimesheets) as IODDTimesheets;
end;

end.
