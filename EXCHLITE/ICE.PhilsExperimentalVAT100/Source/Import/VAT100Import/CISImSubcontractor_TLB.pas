unit CISImSubcontractor_TLB;

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

// PASTLWTR : $Revision:   1.130.1.0.1.0.1.6  $
// File generated on 27/06/2013 14:51:43 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\Import\VAT100Import\VAT100Im.tlb (1)
// LIBID: {CBE908E9-386C-4306-80E4-D8B18A986966}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v1.0 DSRImport, (C:\Projects\Ice\Bin\DSRImport.dll)
//   (2) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
//   (3) v4.0 StdVCL, (C:\Windows\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
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
  CISImSubcontractorMajorVersion = 1;
  CISImSubcontractorMinorVersion = 0;

  LIBID_CISImSubcontractor: TGUID = '{CBE908E9-386C-4306-80E4-D8B18A986966}';

  CLASS_CISImportSubcontractor: TGUID = '{D8497301-5BF7-4FCB-916F-BCCABC95F48A}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CISImportSubcontractor = IImportBox;


// *********************************************************************//
// The Class CoCISImportSubcontractor provides a Create and CreateRemote method to          
// create instances of the default interface IImportBox exposed by              
// the CoClass CISImportSubcontractor. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCISImportSubcontractor = class
    class function Create: IImportBox;
    class function CreateRemote(const MachineName: string): IImportBox;
  end;

implementation

uses ComObj;

class function CoCISImportSubcontractor.Create: IImportBox;
begin
  Result := CreateComObject(CLASS_CISImportSubcontractor) as IImportBox;
end;

class function CoCISImportSubcontractor.CreateRemote(const MachineName: string): IImportBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CISImportSubcontractor) as IImportBox;
end;

end.
