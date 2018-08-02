unit ExportBox_TLB;

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
// File generated on 12/1/2005 16:16:21 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Projects\Ice\Source\ExportBox\ExportBox.tlb (1)
// LIBID: {E7CD3578-4D40-4CA2-AA8D-290BD4BCD13B}
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
  ExportBoxMajorVersion = 1;
  ExportBoxMinorVersion = 0;

  LIBID_ExportBox: TGUID = '{E7CD3578-4D40-4CA2-AA8D-290BD4BCD13B}';

  IID_IExportBoxEvents: TGUID = '{2CBC3E91-C63E-4B2C-A431-CCDEC42CC8B2}';
  CLASS_ExportBoxEvents: TGUID = '{E1257A62-E0B5-4E57-9FAB-0DD52B52427F}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IExportBoxEvents = interface;
  IExportBoxEventsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ExportBoxEvents = IExportBoxEvents;


// *********************************************************************//
// Interface: IExportBoxEvents
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2CBC3E91-C63E-4B2C-A431-CCDEC42CC8B2}
// *********************************************************************//
  IExportBoxEvents = interface(IDispatch)
    ['{2CBC3E91-C63E-4B2C-A431-CCDEC42CC8B2}']
    procedure DoExport(pCompany: LongWord; pMsgType: Smallint; pFrom: TDateTime; pTo: TDateTime; 
                       out pResult: LongWord); safecall;
    function Get_XmlList(Index: Integer): WideString; safecall;
    function Get_XmlCount: Integer; safecall;
    property XmlList[Index: Integer]: WideString read Get_XmlList;
    property XmlCount: Integer read Get_XmlCount;
  end;

// *********************************************************************//
// DispIntf:  IExportBoxEventsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2CBC3E91-C63E-4B2C-A431-CCDEC42CC8B2}
// *********************************************************************//
  IExportBoxEventsDisp = dispinterface
    ['{2CBC3E91-C63E-4B2C-A431-CCDEC42CC8B2}']
    procedure DoExport(pCompany: LongWord; pMsgType: Smallint; pFrom: TDateTime; pTo: TDateTime; 
                       out pResult: LongWord); dispid 1;
    property XmlList[Index: Integer]: WideString readonly dispid 2;
    property XmlCount: Integer readonly dispid 3;
  end;

// *********************************************************************//
// The Class CoExportBoxEvents provides a Create and CreateRemote method to          
// create instances of the default interface IExportBoxEvents exposed by              
// the CoClass ExportBoxEvents. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExportBoxEvents = class
    class function Create: IExportBoxEvents;
    class function CreateRemote(const MachineName: string): IExportBoxEvents;
  end;

implementation

uses ComObj;

class function CoExportBoxEvents.Create: IExportBoxEvents;
begin
  Result := CreateComObject(CLASS_ExportBoxEvents) as IExportBoxEvents;
end;

class function CoExportBoxEvents.CreateRemote(const MachineName: string): IExportBoxEvents;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExportBoxEvents) as IExportBoxEvents;
end;

end.
