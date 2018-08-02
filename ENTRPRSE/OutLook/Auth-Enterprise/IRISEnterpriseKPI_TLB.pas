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
// File generated on 20/11/2006 11:21:53 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\OutLook\Auth-Enterprise\IEAuth.tlb (1)
// LIBID: {453764EF-AA1A-4A2F-B43C-92A87098602E}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
//   (3) v1.0 IKPI, (C:\Develop\Entrprse\IKPIHost.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, IKPI_TLB, StdVCL, Variants;
  

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

  LIBID_IRISEnterpriseKPI: TGUID = '{453764EF-AA1A-4A2F-B43C-92A87098602E}';

  CLASS_EnterpriseAuthentication: TGUID = '{CF79C0CD-34B0-4161-9071-AB39AEB8F120}';
type

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  EnterpriseAuthentication = IAuthenticationPlugIn;


// *********************************************************************//
// The Class CoEnterpriseAuthentication provides a Create and CreateRemote method to          
// create instances of the default interface IAuthenticationPlugIn exposed by              
// the CoClass EnterpriseAuthentication. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoEnterpriseAuthentication = class
    class function Create: IAuthenticationPlugIn;
    class function CreateRemote(const MachineName: string): IAuthenticationPlugIn;
  end;

implementation

uses ComObj;

class function CoEnterpriseAuthentication.Create: IAuthenticationPlugIn;
begin
  Result := CreateComObject(CLASS_EnterpriseAuthentication) as IAuthenticationPlugIn;
end;

class function CoEnterpriseAuthentication.CreateRemote(const MachineName: string): IAuthenticationPlugIn;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_EnterpriseAuthentication) as IAuthenticationPlugIn;
end;

end.
