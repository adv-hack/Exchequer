unit CISSubcontractor_TLB;

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
// File generated on 01/12/2006 15:24:02 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\Export\CIS\Subcontractors\CISSubcontractor.tlb (1)
// LIBID: {6AB17F7C-FF56-4A47-B3FB-12F3B14D6157}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v1.0 DSRExport, (C:\Projects\Ice\Bin\PLUGINS\DSRExport.dll)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (3) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, DSRExport_TLB, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  CISSubcontractorMajorVersion = 1;
  CISSubcontractorMinorVersion = 0;

  LIBID_CISSubcontractor: TGUID = '{6AB17F7C-FF56-4A47-B3FB-12F3B14D6157}';

  CLASS_CISSubcontractorExport: TGUID = '{8B1A84D1-B536-4B37-B5D4-416B0F9FC9D8}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CISSubcontractorExport = IExportBox;


// *********************************************************************//
// The Class CoCISSubcontractorExport provides a Create and CreateRemote method to          
// create instances of the default interface IExportBox exposed by              
// the CoClass CISSubcontractorExport. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCISSubcontractorExport = class
    class function Create: IExportBox;
    class function CreateRemote(const MachineName: string): IExportBox;
  end;

implementation

uses ComObj;

class function CoCISSubcontractorExport.Create: IExportBox;
begin
  Result := CreateComObject(CLASS_CISSubcontractorExport) as IExportBox;
end;

class function CoCISSubcontractorExport.CreateRemote(const MachineName: string): IExportBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CISSubcontractorExport) as IExportBox;
end;

end.
