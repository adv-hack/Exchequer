unit ExFuncs_TLB;

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
// File generated on 29/08/2008 14:59:45 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\COMTK\ExFuncs\ExFuncs.tlb (1)
// LIBID: {C507F35E-132C-4D91-8D51-8748A2398C65}
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
  ExFuncsMajorVersion = 1;
  ExFuncsMinorVersion = 0;

  LIBID_ExFuncs: TGUID = '{C507F35E-132C-4D91-8D51-8748A2398C65}';

  IID_IExchequerFunctions: TGUID = '{A5A754FC-F4B3-41C1-8E7B-9DF0DC963ACA}';
  CLASS_ExchequerFunctions: TGUID = '{93B2007F-227F-4B61-B826-1E7C243E4269}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IExchequerFunctions = interface;
  IExchequerFunctionsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ExchequerFunctions = IExchequerFunctions;


// *********************************************************************//
// Interface: IExchequerFunctions
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A5A754FC-F4B3-41C1-8E7B-9DF0DC963ACA}
// *********************************************************************//
  IExchequerFunctions = interface(IDispatch)
    ['{A5A754FC-F4B3-41C1-8E7B-9DF0DC963ACA}']
    function exRound(Value: Double; DecPlaces: Integer): Double; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExchequerFunctionsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A5A754FC-F4B3-41C1-8E7B-9DF0DC963ACA}
// *********************************************************************//
  IExchequerFunctionsDisp = dispinterface
    ['{A5A754FC-F4B3-41C1-8E7B-9DF0DC963ACA}']
    function exRound(Value: Double; DecPlaces: Integer): Double; dispid 1;
  end;

// *********************************************************************//
// The Class CoExchequerFunctions provides a Create and CreateRemote method to          
// create instances of the default interface IExchequerFunctions exposed by              
// the CoClass ExchequerFunctions. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExchequerFunctions = class
    class function Create: IExchequerFunctions;
    class function CreateRemote(const MachineName: string): IExchequerFunctions;
  end;

implementation

uses ComObj;

class function CoExchequerFunctions.Create: IExchequerFunctions;
begin
  Result := CreateComObject(CLASS_ExchequerFunctions) as IExchequerFunctions;
end;

class function CoExchequerFunctions.CreateRemote(const MachineName: string): IExchequerFunctions;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExchequerFunctions) as IExchequerFunctions;
end;

end.
