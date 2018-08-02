unit EnterpriseTradePlugIn_TLB;

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
// File generated on 23/10/2002 15:11:15 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\EPOS\USRFIELD\UsrField.tlb (1)
// LIBID: {E44A5303-F14F-4FB6-BD8F-0EB67C5F969E}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (E:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (E:\WINNT\System32\STDVCL40.DLL)
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
  EnterpriseTradePlugInMajorVersion = 1;
  EnterpriseTradePlugInMinorVersion = 0;

  LIBID_EnterpriseTradePlugIn: TGUID = '{E44A5303-F14F-4FB6-BD8F-0EB67C5F969E}';

  IID_IUserDefinedField: TGUID = '{F230D0FD-D926-4A57-9A71-A9C999F35B9D}';
  CLASS_UserDefinedField: TGUID = '{637495C7-0508-4C8D-8B01-CA062C44F156}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IUserDefinedField = interface;
  IUserDefinedFieldDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  UserDefinedField = IUserDefinedField;


// *********************************************************************//
// Interface: IUserDefinedField
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F230D0FD-D926-4A57-9A71-A9C999F35B9D}
// *********************************************************************//
  IUserDefinedField = interface(IDispatch)
    ['{F230D0FD-D926-4A57-9A71-A9C999F35B9D}']
  end;

// *********************************************************************//
// DispIntf:  IUserDefinedFieldDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F230D0FD-D926-4A57-9A71-A9C999F35B9D}
// *********************************************************************//
  IUserDefinedFieldDisp = dispinterface
    ['{F230D0FD-D926-4A57-9A71-A9C999F35B9D}']
  end;

// *********************************************************************//
// The Class CoUserDefinedField provides a Create and CreateRemote method to          
// create instances of the default interface IUserDefinedField exposed by              
// the CoClass UserDefinedField. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoUserDefinedField = class
    class function Create: IUserDefinedField;
    class function CreateRemote(const MachineName: string): IUserDefinedField;
  end;

implementation

uses ComObj;

class function CoUserDefinedField.Create: IUserDefinedField;
begin
  Result := CreateComObject(CLASS_UserDefinedField) as IUserDefinedField;
end;

class function CoUserDefinedField.CreateRemote(const MachineName: string): IUserDefinedField;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_UserDefinedField) as IUserDefinedField;
end;

end.
