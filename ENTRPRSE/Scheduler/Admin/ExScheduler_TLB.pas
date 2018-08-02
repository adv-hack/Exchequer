unit ExScheduler_TLB;

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
// File generated on 28/09/2006 08:58:17 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\Scheduler\Admin\ExSched.tlb (1)
// LIBID: {6D199F83-5804-4E94-928A-55BFE33795D1}
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
  ExSchedulerMajorVersion = 1;
  ExSchedulerMinorVersion = 0;

  LIBID_ExScheduler: TGUID = '{6D199F83-5804-4E94-928A-55BFE33795D1}';

  IID_IScheduledTask: TGUID = '{189E3608-99BC-4D2C-A3A0-7C80B956A0CF}';
  DIID_IScheduledTaskEvents: TGUID = '{738BB823-3C96-4804-A1DB-015338361C48}';
  CLASS_ScheduledTask: TGUID = '{CB764C99-FD41-4825-BA4E-5942D9C363AE}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IScheduledTask = interface;
  IScheduledTaskDisp = dispinterface;
  IScheduledTaskEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ScheduledTask = IScheduledTask;


// *********************************************************************//
// Interface: IScheduledTask
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {189E3608-99BC-4D2C-A3A0-7C80B956A0CF}
// *********************************************************************//
  IScheduledTask = interface(IDispatch)
    ['{189E3608-99BC-4D2C-A3A0-7C80B956A0CF}']
    function Get_stType: WideString; safecall;
    function Get_stName: WideString; safecall;
    procedure Set_stName(const Value: WideString); safecall;
    procedure Run; safecall;
    procedure ShowDetails(DisplayWindow: Integer); safecall;
    procedure FreeDetails; safecall;
    procedure Load; safecall;
    procedure Save; safecall;
    function Get_stFirstControl: Integer; safecall;
    function Get_stNextControl: Integer; safecall;
    procedure Set_stNextControl(Value: Integer); safecall;
    function Get_stPrevControl: Integer; safecall;
    procedure Set_stPrevControl(Value: Integer); safecall;
    function Get_stLastControl: Integer; safecall;
    function Get_stDataPath: WideString; safecall;
    procedure Set_stDataPath(const Value: WideString); safecall;
    property stType: WideString read Get_stType;
    property stName: WideString read Get_stName write Set_stName;
    property stFirstControl: Integer read Get_stFirstControl;
    property stNextControl: Integer read Get_stNextControl write Set_stNextControl;
    property stPrevControl: Integer read Get_stPrevControl write Set_stPrevControl;
    property stLastControl: Integer read Get_stLastControl;
    property stDataPath: WideString read Get_stDataPath write Set_stDataPath;
  end;

// *********************************************************************//
// DispIntf:  IScheduledTaskDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {189E3608-99BC-4D2C-A3A0-7C80B956A0CF}
// *********************************************************************//
  IScheduledTaskDisp = dispinterface
    ['{189E3608-99BC-4D2C-A3A0-7C80B956A0CF}']
    property stType: WideString readonly dispid 1;
    property stName: WideString dispid 2;
    procedure Run; dispid 3;
    procedure ShowDetails(DisplayWindow: Integer); dispid 4;
    procedure FreeDetails; dispid 5;
    procedure Load; dispid 6;
    procedure Save; dispid 7;
    property stFirstControl: Integer readonly dispid 8;
    property stNextControl: Integer dispid 9;
    property stPrevControl: Integer dispid 10;
    property stLastControl: Integer readonly dispid 11;
    property stDataPath: WideString dispid 12;
  end;

// *********************************************************************//
// DispIntf:  IScheduledTaskEvents
// Flags:     (4096) Dispatchable
// GUID:      {738BB823-3C96-4804-A1DB-015338361C48}
// *********************************************************************//
  IScheduledTaskEvents = dispinterface
    ['{738BB823-3C96-4804-A1DB-015338361C48}']
    procedure OnProgress(const sMessage: WideString; iPercent: Integer); dispid 1;
  end;

// *********************************************************************//
// The Class CoScheduledTask provides a Create and CreateRemote method to          
// create instances of the default interface IScheduledTask exposed by              
// the CoClass ScheduledTask. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoScheduledTask = class
    class function Create: IScheduledTask;
    class function CreateRemote(const MachineName: string): IScheduledTask;
  end;

implementation

uses ComObj;

class function CoScheduledTask.Create: IScheduledTask;
begin
  Result := CreateComObject(CLASS_ScheduledTask) as IScheduledTask;
end;

class function CoScheduledTask.CreateRemote(const MachineName: string): IScheduledTask;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ScheduledTask) as IScheduledTask;
end;

end.
