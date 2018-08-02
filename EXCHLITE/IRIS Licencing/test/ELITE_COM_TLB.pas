unit ELITE_COM_TLB;

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
// File generated on 14/02/2006 08:55:38 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\IRISSoftwareLtd\Licencing Tools\ELITE COM.tlb (1)
// LIBID: {7CE6F013-D6C2-4D9E-9552-76A4B3A14BB7}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v2.0 mscorlib, (C:\WINNT\Microsoft.NET\Framework\v2.0.50727\mscorlib.tlb)
//   (3) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, Graphics, mscorlib_TLB, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ELITE_COMMajorVersion = 1;
  ELITE_COMMinorVersion = 0;

  LIBID_ELITE_COM: TGUID = '{7CE6F013-D6C2-4D9E-9552-76A4B3A14BB7}';

  DIID_IEliteCom: TGUID = '{5FAF6D4C-590E-426F-9BC5-DE3DD823EA1B}';
  CLASS_LicensingInterface: TGUID = '{28917157-6C6B-4A86-BA99-DB1F6294E749}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IEliteCom = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  LicensingInterface = IEliteCom;


// *********************************************************************//
// DispIntf:  IEliteCom
// Flags:     (4096) Dispatchable
// GUID:      {5FAF6D4C-590E-426F-9BC5-DE3DD823EA1B}
// *********************************************************************//
  IEliteCom = dispinterface
    ['{5FAF6D4C-590E-426F-9BC5-DE3DD823EA1B}']
    function DecodeCDKey(const CDKey: WideString): WideString; dispid 1610743808;
    function GetLicenceCodes(const CDKey: WideString): WideString; dispid 1610743809;
    function DecodeLicenceCode(const CDKeyText: WideString; const LicenceCodeText: WideString): WideString; dispid 1610743810;
    function ClearLicenceLimits: WordBool; dispid 1610743811;
    function AddLicenceLimit(RestrictionID: Integer; LimitID: Integer; const LimitValue: WideString): WordBool; dispid 1610743812;
    function ValidateLicence(const CDKeyText: WideString; const LicenceCode: WideString): WordBool; dispid 1610743813;
    function LicenceLimitsCount: Integer; dispid 1610743814;
    function ActivateFromWS(const CDKey: WideString; CheckStatus: WordBool): WideString; dispid 1610743815;
    function ActivateCDKey(const CDKey: WideString; const ActivationCode: WideString): WordBool; dispid 1610743816;
    function InitialiseLocalDatabase: WordBool; dispid 1610743817;
    function GetLicenceRestrictionsWS(const CDKey: WideString; const LicenceCode: WideString): WideString; dispid 1610743818;
  end;

// *********************************************************************//
// The Class CoLicensingInterface provides a Create and CreateRemote method to          
// create instances of the default interface IEliteCom exposed by              
// the CoClass LicensingInterface. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoLicensingInterface = class
    class function Create: IEliteCom;
    class function CreateRemote(const MachineName: string): IEliteCom;
  end;

implementation

uses ComObj;

class function CoLicensingInterface.Create: IEliteCom;
begin
  Result := CreateComObject(CLASS_LicensingInterface) as IEliteCom;
end;

class function CoLicensingInterface.CreateRemote(const MachineName: string): IEliteCom;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_LicensingInterface) as IEliteCom;
end;

end.
