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
// File generated on 27/02/2006 12:31:08 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\Export\Matching\ICSExMat.tlb (1)
// LIBID: {FFC4FC4B-C7E2-4C39-A6C1-C0BF62860E8A}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
//   (3) v1.0 DSRExport, (C:\ICE\dsrexport.dll)
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

  LIBID_IrisClientSync: TGUID = '{FFC4FC4B-C7E2-4C39-A6C1-C0BF62860E8A}';

  CLASS_MatchingDataExporter: TGUID = '{D80E392D-C94B-4C7A-A2E9-BB21F73186BB}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  MatchingDataExporter = IExportBox;


// *********************************************************************//
// The Class CoMatchingDataExporter provides a Create and CreateRemote method to          
// create instances of the default interface IExportBox exposed by              
// the CoClass MatchingDataExporter. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMatchingDataExporter = class
    class function Create: IExportBox;
    class function CreateRemote(const MachineName: string): IExportBox;
  end;

implementation

uses ComObj;

class function CoMatchingDataExporter.Create: IExportBox;
begin
  Result := CreateComObject(CLASS_MatchingDataExporter) as IExportBox;
end;

class function CoMatchingDataExporter.CreateRemote(const MachineName: string): IExportBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MatchingDataExporter) as IExportBox;
end;

end.
