unit IRISEnterpriseKPI_TLB;

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
// File generated on 10/03/2010 16:32:05 from Type Library described below.

// ************************************************************************  //
// Type Lib: W:\ENTRPRSE\OutLook\KPI-ExchOut\ExchOut.tlb (1)
// LIBID: {B00EB940-F8E8-4932-8A1B-2C47BCBD107E}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v1.0 IKPIHost, (\\bmtfs1\QADEV\CD Updates\Exchequer\Exch63\Outlook Today\KPI\IKPIHOST.dll)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (3) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, IKPIHost_TLB, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  IRISEnterpriseKPIMajorVersion = 1;
  IRISEnterpriseKPIMinorVersion = 0;

  LIBID_IRISEnterpriseKPI: TGUID = '{B00EB940-F8E8-4932-8A1B-2C47BCBD107E}';

  CLASS_ExchequerOut: TGUID = '{00ACEE3B-44D6-4F55-98B5-C87201A77483}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ExchequerOut = IDataPlugin;


// *********************************************************************//
// The Class CoExchequerOut provides a Create and CreateRemote method to          
// create instances of the default interface IDataPlugin exposed by              
// the CoClass ExchequerOut. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExchequerOut = class
    class function Create: IDataPlugin;
    class function CreateRemote(const MachineName: string): IDataPlugin;
  end;

implementation

uses ComObj;

class function CoExchequerOut.Create: IDataPlugin;
begin
  Result := CreateComObject(CLASS_ExchequerOut) as IDataPlugin;
end;

class function CoExchequerOut.CreateRemote(const MachineName: string): IDataPlugin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ExchequerOut) as IDataPlugin;
end;

end.
