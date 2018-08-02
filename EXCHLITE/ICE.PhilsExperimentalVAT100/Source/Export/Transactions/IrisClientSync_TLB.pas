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
// File generated on 13/04/2006 16:01:35 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\Export\Transactions\ICSExTra.tlb (1)
// LIBID: {588946B8-1B7D-4E48-B6C2-99AA5F7F0F4E}
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

  LIBID_IrisClientSync: TGUID = '{588946B8-1B7D-4E48-B6C2-99AA5F7F0F4E}';

  CLASS_TransactionDataExporter: TGUID = '{79AB33FA-5B0A-4F79-9485-AF35DB035386}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  TransactionDataExporter = IExportBox;


// *********************************************************************//
// The Class CoTransactionDataExporter provides a Create and CreateRemote method to          
// create instances of the default interface IExportBox exposed by              
// the CoClass TransactionDataExporter. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTransactionDataExporter = class
    class function Create: IExportBox;
    class function CreateRemote(const MachineName: string): IExportBox;
  end;

implementation

uses ComObj;

class function CoTransactionDataExporter.Create: IExportBox;
begin
  Result := CreateComObject(CLASS_TransactionDataExporter) as IExportBox;
end;

class function CoTransactionDataExporter.CreateRemote(const MachineName: string): IExportBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TransactionDataExporter) as IExportBox;
end;

end.
