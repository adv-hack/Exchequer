unit IrisClientSync_TLB;

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
// File generated on 14/02/2006 08:31:31 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\Export\System\ICSExSys.tlb (1)
// LIBID: {B8B8DDB4-51D0-420D-8C1F-F4B11488BB01}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v1.0 DSRExport, (C:\ICE\dsrexport.dll)
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
  IrisClientSyncMajorVersion = 1;
  IrisClientSyncMinorVersion = 0;

  LIBID_IrisClientSync: TGUID = '{B8B8DDB4-51D0-420D-8C1F-F4B11488BB01}';

  CLASS_SystemDataExporter: TGUID = '{F46E0597-98E6-41C3-96F2-160FF03F1094}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SystemDataExporter = IExportBox;


// *********************************************************************//
// The Class CoSystemDataExporter provides a Create and CreateRemote method to          
// create instances of the default interface IExportBox exposed by              
// the CoClass SystemDataExporter. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSystemDataExporter = class
    class function Create: IExportBox;
    class function CreateRemote(const MachineName: string): IExportBox;
  end;

implementation

uses ComObj;

class function CoSystemDataExporter.Create: IExportBox;
begin
  Result := CreateComObject(CLASS_SystemDataExporter) as IExportBox;
end;

class function CoSystemDataExporter.CreateRemote(const MachineName: string): IExportBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SystemDataExporter) as IExportBox;
end;

end.
