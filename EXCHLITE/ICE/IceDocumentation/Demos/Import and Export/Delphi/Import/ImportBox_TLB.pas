unit ImportBox_TLB;

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
// File generated on 12/1/2005 16:26:45 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Projects\Ice\Source\ImportBox\ImportBox.tlb (1)
// LIBID: {68FD1E4D-89D6-4C61-8908-05BA8006184D}
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
  ImportBoxMajorVersion = 1;
  ImportBoxMinorVersion = 0;

  LIBID_ImportBox: TGUID = '{68FD1E4D-89D6-4C61-8908-05BA8006184D}';

  IID_IImportBoxEvents: TGUID = '{B6FCD946-DB96-4385-817A-AFDDDCC4BA6D}';
  CLASS_ImportBoxEvents: TGUID = '{A0B50757-7E93-441B-9D9D-567FFA37D491}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IImportBoxEvents = interface;
  IImportBoxEventsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ImportBoxEvents = IImportBoxEvents;


// *********************************************************************//
// Interface: IImportBoxEvents
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B6FCD946-DB96-4385-817A-AFDDDCC4BA6D}
// *********************************************************************//
  IImportBoxEvents = interface(IDispatch)
    ['{B6FCD946-DB96-4385-817A-AFDDDCC4BA6D}']
    procedure DoImport(pCompany: LongWord; pMsgType: Smallint; const pXml: WideString; 
                       out pResult: LongWord); safecall;
  end;

// *********************************************************************//
// DispIntf:  IImportBoxEventsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B6FCD946-DB96-4385-817A-AFDDDCC4BA6D}
// *********************************************************************//
  IImportBoxEventsDisp = dispinterface
    ['{B6FCD946-DB96-4385-817A-AFDDDCC4BA6D}']
    procedure DoImport(pCompany: LongWord; pMsgType: Smallint; const pXml: WideString; 
                       out pResult: LongWord); dispid 1;
  end;

// *********************************************************************//
// The Class CoImportBoxEvents provides a Create and CreateRemote method to          
// create instances of the default interface IImportBoxEvents exposed by              
// the CoClass ImportBoxEvents. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoImportBoxEvents = class
    class function Create: IImportBoxEvents;
    class function CreateRemote(const MachineName: string): IImportBoxEvents;
  end;

implementation

uses ComObj;

class function CoImportBoxEvents.Create: IImportBoxEvents;
begin
  Result := CreateComObject(CLASS_ImportBoxEvents) as IImportBoxEvents;
end;

class function CoImportBoxEvents.CreateRemote(const MachineName: string): IImportBoxEvents;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ImportBoxEvents) as IImportBoxEvents;
end;

end.
