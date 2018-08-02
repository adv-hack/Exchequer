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
// File generated on 15/02/2006 15:03:11 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\Import\System\ICSImSys.tlb (1)
// LIBID: {4E1F30D4-6E02-4D1E-BF99-1A1B2603CB36}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v1.0 DSRImport, (C:\ICE\dsrimport.dll)
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
  IrisClientSyncMajorVersion = 1;
  IrisClientSyncMinorVersion = 0;

  LIBID_IrisClientSync: TGUID = '{4E1F30D4-6E02-4D1E-BF99-1A1B2603CB36}';

  CLASS_SystemDataImporter: TGUID = '{65518A8E-58AC-4B07-B5C0-FAE66725F556}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SystemDataImporter = IImportBox;


// *********************************************************************//
// The Class CoSystemDataImporter provides a Create and CreateRemote method to          
// create instances of the default interface IImportBox exposed by              
// the CoClass SystemDataImporter. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSystemDataImporter = class
    class function Create: IImportBox;
    class function CreateRemote(const MachineName: string): IImportBox;
  end;

implementation

uses ComObj;

class function CoSystemDataImporter.Create: IImportBox;
begin
  Result := CreateComObject(CLASS_SystemDataImporter) as IImportBox;
end;

class function CoSystemDataImporter.CreateRemote(const MachineName: string): IImportBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SystemDataImporter) as IImportBox;
end;

end.
