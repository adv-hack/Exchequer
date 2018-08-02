unit ExFuncsOop_TLB;

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
// File generated on 08/09/2008 12:42:34 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\COMTK\ExFuncs\ExFuncsOop.tlb (1)
// LIBID: {A4446651-77CB-4D90-8F30-09786BAB1634}
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
  ExFuncsOopMajorVersion = 1;
  ExFuncsOopMinorVersion = 0;

  LIBID_ExFuncsOop: TGUID = '{A4446651-77CB-4D90-8F30-09786BAB1634}';

  IID_IExchquerFunctions: TGUID = '{BD5286E9-2E44-422B-8F5B-D5D328499E02}';
  CLASS_ExchquerFunctions: TGUID = '{1E5FCF15-062B-49C7-BDE1-2654ED4F67B1}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IExchquerFunctions = interface;
  IExchquerFunctionsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ExchquerFunctions = IExchquerFunctions;


// *********************************************************************//
// Interface: IExchquerFunctions
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BD5286E9-2E44-422B-8F5B-D5D328499E02}
// *********************************************************************//
  IExchquerFunctions = interface(IDispatch)
    ['{BD5286E9-2E44-422B-8F5B-D5D328499E02}']
    function exRound(Valu: Double; DecPlaces: Integer): Double; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExchquerFunctionsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BD5286E9-2E44-422B-8F5B-D5D328499E02}
// *********************************************************************//
  IExchquerFunctionsDisp = dispinterface
    ['{BD5286E9-2E44-422B-8F5B-D5D328499E02}']
    function exRound(Valu: Double; DecPlaces: Integer): Double; dispid 1;
  end;

// *********************************************************************//
// The Class CoExchquerFunctions provides a Create and CreateRemote method to          
// create instances of the default interface IExchquerFunctions exposed by              
// the CoClass ExchquerFunctions. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExchquerFunctions = class
    class function Create: IExchquerFunctions;
    class function CreateRemote(const MachineName: string): IExchquerFunctions;
  end;

implementation

uses ComObj;

class function CoExchquerFunctions.Create: IExchquerFunctions;
begin
  Result := CreateComObject(CLASS_ExchquerFunctions) as IExchquerFunctions;
end;

class function CoExchquerFunctions.CreateRemote(const MachineName: string): IExchquerFunctions;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExchquerFunctions) as IExchquerFunctions;
end;

end.
