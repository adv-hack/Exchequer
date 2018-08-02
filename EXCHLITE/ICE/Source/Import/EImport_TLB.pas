unit EImport_TLB;

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
// File generated on 2/1/2006 08:32:52 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\Import\EImport.tlb (1)
// LIBID: {7FEA0833-12F4-4E8F-83AC-545EB10E5F36}
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
  EImportMajorVersion = 1;
  EImportMinorVersion = 0;

  LIBID_EImport: TGUID = '{7FEA0833-12F4-4E8F-83AC-545EB10E5F36}';

  IID_IENTImport: TGUID = '{332C216A-01C7-447B-A0CB-C9BB861889C6}';
  CLASS_ENTImport: TGUID = '{FDC1B564-3F58-462B-8B86-D144D4B9EEA2}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IENTImport = interface;
  IENTImportDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ENTImport = IENTImport;


// *********************************************************************//
// Interface: IENTImport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {332C216A-01C7-447B-A0CB-C9BB861889C6}
// *********************************************************************//
  IENTImport = interface(IDispatch)
    ['{332C216A-01C7-447B-A0CB-C9BB861889C6}']
    function DoImport(const pDataPath: WideString; const pXML: WideString; const pXSL: WideString; 
                      const pXSD: WideString; pUserReference: LongWord): LongWord; safecall;
  end;

// *********************************************************************//
// DispIntf:  IENTImportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {332C216A-01C7-447B-A0CB-C9BB861889C6}
// *********************************************************************//
  IENTImportDisp = dispinterface
    ['{332C216A-01C7-447B-A0CB-C9BB861889C6}']
    function DoImport(const pDataPath: WideString; const pXML: WideString; const pXSL: WideString; 
                      const pXSD: WideString; pUserReference: LongWord): LongWord; dispid 1;
  end;

// *********************************************************************//
// The Class CoENTImport provides a Create and CreateRemote method to          
// create instances of the default interface IENTImport exposed by              
// the CoClass ENTImport. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoENTImport = class
    class function Create: IENTImport;
    class function CreateRemote(const MachineName: string): IENTImport;
  end;

implementation

uses ComObj;

class function CoENTImport.Create: IENTImport;
begin
  Result := CreateComObject(CLASS_ENTImport) as IENTImport;
end;

class function CoENTImport.CreateRemote(const MachineName: string): IENTImport;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ENTImport) as IENTImport;
end;

end.
