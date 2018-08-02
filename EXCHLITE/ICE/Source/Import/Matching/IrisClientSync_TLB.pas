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
// File generated on 28/02/2006 10:59:39 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\Import\Matching\ICSImMat.tlb (1)
// LIBID: {24B3D550-C2FE-4108-9A52-FA6BB463826A}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
//   (3) v1.0 DSRImport, (C:\ICE\dsrimport.dll)
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
  IrisClientSyncMajorVersion = 1;
  IrisClientSyncMinorVersion = 0;

  LIBID_IrisClientSync: TGUID = '{24B3D550-C2FE-4108-9A52-FA6BB463826A}';

  CLASS_MatchingDataImporter: TGUID = '{661F8945-3180-4CD4-ADCD-2014E110EBF7}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  MatchingDataImporter = IImportBox;


// *********************************************************************//
// The Class CoMatchingDataImporter provides a Create and CreateRemote method to          
// create instances of the default interface IImportBox exposed by              
// the CoClass MatchingDataImporter. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMatchingDataImporter = class
    class function Create: IImportBox;
    class function CreateRemote(const MachineName: string): IImportBox;
  end;

implementation

uses ComObj;

class function CoMatchingDataImporter.Create: IImportBox;
begin
  Result := CreateComObject(CLASS_MatchingDataImporter) as IImportBox;
end;

class function CoMatchingDataImporter.CreateRemote(const MachineName: string): IImportBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MatchingDataImporter) as IImportBox;
end;

end.
