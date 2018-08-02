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
// File generated on 09/05/2006 12:44:36 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\Import\Transactions\ICSImTra.tlb (1)
// LIBID: {3DA4C27C-CA25-476B-9E52-3BE4E4483CD9}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v1.0 DSRImport, (C:\IAOAcct\PlugIns\dsrimport.dll)
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

  LIBID_IrisClientSync: TGUID = '{3DA4C27C-CA25-476B-9E52-3BE4E4483CD9}';

  CLASS_TransactionDataImporter: TGUID = '{E5802D61-729E-4A5F-BC84-3E80A6F4A581}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  TransactionDataImporter = IImportBox;


// *********************************************************************//
// The Class CoTransactionDataImporter provides a Create and CreateRemote method to          
// create instances of the default interface IImportBox exposed by              
// the CoClass TransactionDataImporter. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTransactionDataImporter = class
    class function Create: IImportBox;
    class function CreateRemote(const MachineName: string): IImportBox;
  end;

implementation

uses ComObj;

class function CoTransactionDataImporter.Create: IImportBox;
begin
  Result := CreateComObject(CLASS_TransactionDataImporter) as IImportBox;
end;

class function CoTransactionDataImporter.CreateRemote(const MachineName: string): IImportBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TransactionDataImporter) as IImportBox;
end;

end.
