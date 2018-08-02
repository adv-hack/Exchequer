unit DemoImport_TLB;

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
// File generated on 1/25/2006 09:48:25 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Projects\Ice\IceDocumentation\Demos\Import and Export\Delphi\Import\DemoImport.tlb (1)
// LIBID: {99B022BA-B843-4E4A-B536-CD09CCF80CF7}
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
  DemoImportMajorVersion = 1;
  DemoImportMinorVersion = 0;

  LIBID_DemoImport: TGUID = '{99B022BA-B843-4E4A-B536-CD09CCF80CF7}';

  IID_INewImport: TGUID = '{7624B52A-31D3-4F14-B87D-9AFE5D099C87}';
  CLASS_NewImport: TGUID = '{F029B9CC-9225-4AFD-8DF5-A8EABA3C9B8A}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  INewImport = interface;
  INewImportDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  NewImport = INewImport;


// *********************************************************************//
// Interface: INewImport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7624B52A-31D3-4F14-B87D-9AFE5D099C87}
// *********************************************************************//
  INewImport = interface(IDispatch)
    ['{7624B52A-31D3-4F14-B87D-9AFE5D099C87}']
    function DoImport(pCompany: LongWord; const pPath: WideString; pMultiCurr: Shortint; 
                      const pXML: WideString; const pXSL: WideString; const pXSD: WideString; 
                      pUserReference: LongWord): LongWord; safecall;
  end;

// *********************************************************************//
// DispIntf:  INewImportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7624B52A-31D3-4F14-B87D-9AFE5D099C87}
// *********************************************************************//
  INewImportDisp = dispinterface
    ['{7624B52A-31D3-4F14-B87D-9AFE5D099C87}']
    function DoImport(pCompany: LongWord; const pPath: WideString; 
                      pMultiCurr: {??Shortint}OleVariant; const pXML: WideString; 
                      const pXSL: WideString; const pXSD: WideString; pUserReference: LongWord): LongWord; dispid 1;
  end;

// *********************************************************************//
// The Class CoNewImport provides a Create and CreateRemote method to          
// create instances of the default interface INewImport exposed by              
// the CoClass NewImport. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNewImport = class
    class function Create: INewImport;
    class function CreateRemote(const MachineName: string): INewImport;
  end;

implementation

uses ComObj;

class function CoNewImport.Create: INewImport;
begin
  Result := CreateComObject(CLASS_NewImport) as INewImport;
end;

class function CoNewImport.CreateRemote(const MachineName: string): INewImport;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NewImport) as INewImport;
end;

end.
