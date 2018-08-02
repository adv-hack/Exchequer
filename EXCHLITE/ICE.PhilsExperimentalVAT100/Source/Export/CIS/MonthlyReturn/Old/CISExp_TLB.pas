unit CISExp_TLB;

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
// File generated on 30/11/2006 16:10:52 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\Export\CIS\MonthlyReturn\CISMonthlyReturn.tlb (1)
// LIBID: {25D23038-8448-48E4-BD37-E905061C4441}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
//   (3) v1.0 DSRExport, (C:\Projects\Ice\Bin\PLUGINS\DSRExport.dll)
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
  CISExpMajorVersion = 1;
  CISExpMinorVersion = 0;

  LIBID_CISExp: TGUID = '{25D23038-8448-48E4-BD37-E905061C4441}';

  CLASS_CISMonthlyReturn: TGUID = '{5F48D0D8-7636-4E3A-8FB0-7BEB09DDC054}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CISMonthlyReturn = IExportBox;


// *********************************************************************//
// The Class CoCISMonthlyReturn provides a Create and CreateRemote method to          
// create instances of the default interface IExportBox exposed by              
// the CoClass CISMonthlyReturn. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCISMonthlyReturn = class
    class function Create: IExportBox;
    class function CreateRemote(const MachineName: string): IExportBox;
  end;

implementation

uses ComObj;

class function CoCISMonthlyReturn.Create: IExportBox;
begin
  Result := CreateComObject(CLASS_CISMonthlyReturn) as IExportBox;
end;

class function CoCISMonthlyReturn.CreateRemote(const MachineName: string): IExportBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CISMonthlyReturn) as IExportBox;
end;

end.
