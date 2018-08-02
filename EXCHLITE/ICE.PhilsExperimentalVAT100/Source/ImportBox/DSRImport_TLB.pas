unit DSRImport_TLB;

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
// File generated on 13/06/2006 09:09:26 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\ImportBox\DSRImport.tlb (1)
// LIBID: {27F189FB-A04E-44F6-965D-6A19D94A1754}
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
  DSRImportMajorVersion = 1;
  DSRImportMinorVersion = 0;

  LIBID_DSRImport: TGUID = '{27F189FB-A04E-44F6-965D-6A19D94A1754}';

  IID_IImportBox: TGUID = '{7FBEC9A4-A725-4098-BDD4-93CB25EED2E0}';
  CLASS_ImportBox: TGUID = '{76811143-B180-42F7-9A6F-ABEDDC426466}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IImportBox = interface;
  IImportBoxDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ImportBox = IImportBox;


// *********************************************************************//
// Interface: IImportBox
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7FBEC9A4-A725-4098-BDD4-93CB25EED2E0}
// *********************************************************************//
  IImportBox = interface(IDispatch)
    ['{7FBEC9A4-A725-4098-BDD4-93CB25EED2E0}']
    function DoImport(const pCompanyCode: WideString; const pDataPath: WideString; 
                      const pXML: WideString; const pXSL: WideString; const pXSD: WideString; 
                      pUserReference: LongWord): LongWord; safecall;
  end;

// *********************************************************************//
// DispIntf:  IImportBoxDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7FBEC9A4-A725-4098-BDD4-93CB25EED2E0}
// *********************************************************************//
  IImportBoxDisp = dispinterface
    ['{7FBEC9A4-A725-4098-BDD4-93CB25EED2E0}']
    function DoImport(const pCompanyCode: WideString; const pDataPath: WideString; 
                      const pXML: WideString; const pXSL: WideString; const pXSD: WideString; 
                      pUserReference: LongWord): LongWord; dispid 1;
  end;

// *********************************************************************//
// The Class CoImportBox provides a Create and CreateRemote method to          
// create instances of the default interface IImportBox exposed by              
// the CoClass ImportBox. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoImportBox = class
    class function Create: IImportBox;
    class function CreateRemote(const MachineName: string): IImportBox;
  end;

implementation

uses ComObj;

class function CoImportBox.Create: IImportBox;
begin
  Result := CreateComObject(CLASS_ImportBox) as IImportBox;
end;

class function CoImportBox.CreateRemote(const MachineName: string): IImportBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ImportBox) as IImportBox;
end;

end.
