unit FBITestHarness_TLB;

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

// PASTLWTR : $Revision:   1.130  $
// File generated on 26/07/2006 12:06:34 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Repository\POC\NON SOURCE CONTROLLED\Delphi_FBI_TestHarness\FBITestHarness.tlb (1)
// LIBID: {DB5FE9F0-3B59-4DCB-A956-AC151A90A12A}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\STDOLE2.TLB)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses ActiveX, Classes, Graphics, StdVCL, Variants, Windows;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  FBITestHarnessMajorVersion = 1;
  FBITestHarnessMinorVersion = 0;

  LIBID_FBITestHarness: TGUID = '{DB5FE9F0-3B59-4DCB-A956-AC151A90A12A}';

  IID_IFBI_Callback: TGUID = '{3BF6C6BC-D132-4F6D-AD92-4F9D9CCA7F2E}';
  CLASS_FBI_Callback: TGUID = '{98418CFF-F437-481D-87D0-B9179808ABFF}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IFBI_Callback = interface;
  IFBI_CallbackDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  FBI_Callback = IFBI_Callback;


// *********************************************************************//
// Interface: IFBI_Callback
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3BF6C6BC-D132-4F6D-AD92-4F9D9CCA7F2E}
// *********************************************************************//
  IFBI_Callback = interface(IDispatch)
    ['{3BF6C6BC-D132-4F6D-AD92-4F9D9CCA7F2E}']
  end;

// *********************************************************************//
// DispIntf:  IFBI_CallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3BF6C6BC-D132-4F6D-AD92-4F9D9CCA7F2E}
// *********************************************************************//
  IFBI_CallbackDisp = dispinterface
    ['{3BF6C6BC-D132-4F6D-AD92-4F9D9CCA7F2E}']
  end;

// *********************************************************************//
// The Class CoFBI_Callback provides a Create and CreateRemote method to          
// create instances of the default interface IFBI_Callback exposed by              
// the CoClass FBI_Callback. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFBI_Callback = class
    class function Create: IFBI_Callback;
    class function CreateRemote(const MachineName: string): IFBI_Callback;
  end;

implementation

uses ComObj;

class function CoFBI_Callback.Create: IFBI_Callback;
begin
  Result := CreateComObject(CLASS_FBI_Callback) as IFBI_Callback;
end;

class function CoFBI_Callback.CreateRemote(const MachineName: string): IFBI_Callback;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FBI_Callback) as IFBI_Callback;
end;

end.
