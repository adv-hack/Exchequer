unit Exchequer_TLB;

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
// File generated on 16/05/2002 15:50:54 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\LICENCE\COMSecO\EXSECPWD.tlb (1)
// LIBID: {5716F0F4-6968-434B-BADF-69DCA1C5FDED}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ExchequerMajorVersion = 1;
  ExchequerMinorVersion = 0;

  LIBID_Exchequer: TGUID = '{5716F0F4-6968-434B-BADF-69DCA1C5FDED}';

  IID_ISecPwords: TGUID = '{26EE029C-89D2-4C83-8F7D-62C9E879119B}';
  CLASS_SecPwords: TGUID = '{D5B9FF3E-2394-433E-AC33-1F9BFD742E7F}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ISecPwords = interface;
  ISecPwordsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SecPwords = ISecPwords;


// *********************************************************************//
// Interface: ISecPwords
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {26EE029C-89D2-4C83-8F7D-62C9E879119B}
// *********************************************************************//
  ISecPwords = interface(IDispatch)
    ['{26EE029C-89D2-4C83-8F7D-62C9E879119B}']
    function Get_Version: WideString; safecall;
    function Get_PlugInToday: WideString; safecall;
    function Get_PlugInTomorrow: WideString; safecall;
    property Version: WideString read Get_Version;
    property PlugInToday: WideString read Get_PlugInToday;
    property PlugInTomorrow: WideString read Get_PlugInTomorrow;
  end;

// *********************************************************************//
// DispIntf:  ISecPwordsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {26EE029C-89D2-4C83-8F7D-62C9E879119B}
// *********************************************************************//
  ISecPwordsDisp = dispinterface
    ['{26EE029C-89D2-4C83-8F7D-62C9E879119B}']
    property Version: WideString readonly dispid 1;
    property PlugInToday: WideString readonly dispid 2;
    property PlugInTomorrow: WideString readonly dispid 3;
  end;

// *********************************************************************//
// The Class CoSecPwords provides a Create and CreateRemote method to          
// create instances of the default interface ISecPwords exposed by              
// the CoClass SecPwords. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSecPwords = class
    class function Create: ISecPwords;
    class function CreateRemote(const MachineName: string): ISecPwords;
  end;

implementation

uses ComObj;

class function CoSecPwords.Create: ISecPwords;
begin
  Result := CreateComObject(CLASS_SecPwords) as ISecPwords;
end;

class function CoSecPwords.CreateRemote(const MachineName: string): ISecPwords;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SecPwords) as ISecPwords;
end;

end.
