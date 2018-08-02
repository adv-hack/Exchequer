unit PlugTest_TLB;

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
// File generated on 25/09/2006 15:36:27 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Temp\SchedPlug\PlugTest.tlb (1)
// LIBID: {7F82AC96-34C1-49C6-8C5B-5DEE6536B95B}
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
  PlugTestMajorVersion = 1;
  PlugTestMinorVersion = 0;

  LIBID_PlugTest: TGUID = '{7F82AC96-34C1-49C6-8C5B-5DEE6536B95B}';

  IID_IScheduleTest: TGUID = '{088E3E08-1228-4F93-9761-EBF1646FE1CA}';
  CLASS_ScheduleTest: TGUID = '{2A9C77B8-10E0-411E-A5A9-24ED7D69A291}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IScheduleTest = interface;
  IScheduleTestDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ScheduleTest = IScheduleTest;


// *********************************************************************//
// Interface: IScheduleTest
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {088E3E08-1228-4F93-9761-EBF1646FE1CA}
// *********************************************************************//
  IScheduleTest = interface(IDispatch)
    ['{088E3E08-1228-4F93-9761-EBF1646FE1CA}']
    function Test: WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IScheduleTestDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {088E3E08-1228-4F93-9761-EBF1646FE1CA}
// *********************************************************************//
  IScheduleTestDisp = dispinterface
    ['{088E3E08-1228-4F93-9761-EBF1646FE1CA}']
    function Test: WideString; dispid 1;
  end;

// *********************************************************************//
// The Class CoScheduleTest provides a Create and CreateRemote method to          
// create instances of the default interface IScheduleTest exposed by              
// the CoClass ScheduleTest. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoScheduleTest = class
    class function Create: IScheduleTest;
    class function CreateRemote(const MachineName: string): IScheduleTest;
  end;

implementation

uses ComObj;

class function CoScheduleTest.Create: IScheduleTest;
begin
  Result := CreateComObject(CLASS_ScheduleTest) as IScheduleTest;
end;

class function CoScheduleTest.CreateRemote(const MachineName: string): IScheduleTest;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ScheduleTest) as IScheduleTest;
end;

end.
