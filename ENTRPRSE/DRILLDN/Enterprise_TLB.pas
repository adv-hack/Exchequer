unit Enterprise_TLB;

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
// File generated on 03/04/2006 16:47:37 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\DRILLDN\ENTDRILL.tlb (1)
// LIBID: {4DEA2BF7-2A78-4372-BEEA-0D15145CDB5A}
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
  EnterpriseMajorVersion = 1;
  EnterpriseMinorVersion = 0;

  LIBID_Enterprise: TGUID = '{4DEA2BF7-2A78-4372-BEEA-0D15145CDB5A}';

  IID_IDrillDown: TGUID = '{8DA9932E-DD1C-447A-8A0B-BDEFDF0E437F}';
  DIID_IDrillDownEvents: TGUID = '{C75D88F5-4684-4B22-906E-4AEBB338ACC8}';
  CLASS_DrillDown: TGUID = '{F47B5CB4-6F14-4E63-A2FE-172C5D8A6575}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TDrillDownResult
type
  TDrillDownResult = TOleEnum;
const
  ddNoAction = $00000000;
  ddUpdateCellFormula = $00000001;
  ddDrillDownExecuted = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDrillDown = interface;
  IDrillDownDisp = dispinterface;
  IDrillDownEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DrillDown = IDrillDown;


// *********************************************************************//
// Interface: IDrillDown
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8DA9932E-DD1C-447A-8A0B-BDEFDF0E437F}
// *********************************************************************//
  IDrillDown = interface(IDispatch)
    ['{8DA9932E-DD1C-447A-8A0B-BDEFDF0E437F}']
    function DrillDown(const DrillStr: WideString): TDrillDownResult; safecall;
    procedure DisplayAbout(const AddInVer: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IDrillDownDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8DA9932E-DD1C-447A-8A0B-BDEFDF0E437F}
// *********************************************************************//
  IDrillDownDisp = dispinterface
    ['{8DA9932E-DD1C-447A-8A0B-BDEFDF0E437F}']
    function DrillDown(const DrillStr: WideString): TDrillDownResult; dispid 1;
    procedure DisplayAbout(const AddInVer: WideString); dispid 2;
  end;

// *********************************************************************//
// DispIntf:  IDrillDownEvents
// Flags:     (4096) Dispatchable
// GUID:      {C75D88F5-4684-4B22-906E-4AEBB338ACC8}
// *********************************************************************//
  IDrillDownEvents = dispinterface
    ['{C75D88F5-4684-4B22-906E-4AEBB338ACC8}']
    procedure OnResolveCellReference(const CellRef: WideString; var CellValue: WideString; 
                                     var CellFormula: WideString; var OK: WordBool); dispid 1;
    procedure OnChangeCellFormula(const NewFormula: WideString); dispid 2;
    procedure OnSetWindowFocus(hWnd: Integer); dispid 3;
  end;

// *********************************************************************//
// The Class CoDrillDown provides a Create and CreateRemote method to          
// create instances of the default interface IDrillDown exposed by              
// the CoClass DrillDown. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDrillDown = class
    class function Create: IDrillDown;
    class function CreateRemote(const MachineName: string): IDrillDown;
  end;

implementation

uses ComObj;

class function CoDrillDown.Create: IDrillDown;
begin
  Result := CreateComObject(CLASS_DrillDown) as IDrillDown;
end;

class function CoDrillDown.CreateRemote(const MachineName: string): IDrillDown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DrillDown) as IDrillDown;
end;

end.
