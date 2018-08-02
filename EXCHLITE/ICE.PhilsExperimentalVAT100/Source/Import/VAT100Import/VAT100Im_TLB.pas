unit VAT100Im_TLB;

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
// File generated on 31/01/2007 09:22:57 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\Import\CIS\SubContractors\CISImSubcontractor.tlb (1)
// LIBID: {CBE908E9-386C-4306-80E4-D8B18A986966}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v1.0 DSRImport, (C:\Projects\Ice\Bin\PLUGINS\DSRImport.dll)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (3) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, DSRImport_TLB, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  VAT100ImMajorVersion = 1;
  VAT100ImMinorVersion = 0;

  LIBID_VAT100Im: TGUID = '{CBE908E9-386C-4306-80E4-D8B18A986966}';

  CLASS_VAT100Im: TGUID = '{D8497301-5BF7-4FCB-916F-BCCABC95F48A}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  VAT100Im = IImportBox;


// *********************************************************************//
// The Class CoCISImportSubcontractor provides a Create and CreateRemote method to          
// create instances of the default interface IImportBox exposed by              
// the CoClass CISImportSubcontractor. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoVAT100Im = class
    class function Create: IImportBox;
    class function CreateRemote(const MachineName: string): IImportBox;
  end;

implementation

uses ComObj;

class function CoVAT100Im.Create: IImportBox;
begin
  Result := CreateComObject(CLASS_VAT100Im) as IImportBox;
end;

class function CoVAT100Im.CreateRemote(const MachineName: string): IImportBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_VAT100Im) as IImportBox;
end;

end.
