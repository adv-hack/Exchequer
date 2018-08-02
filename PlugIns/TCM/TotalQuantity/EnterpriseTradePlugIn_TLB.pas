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
// File generated on 30/11/2005 11:16:40 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\EPOS\PlugIns\JandJWines\TotalQuantity\TotQtyPI.tlb (1)
// LIBID: {ED41D2F7-43E0-4A66-8802-F0FAFD7EB782}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
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

  LIBID_EnterpriseTradePlugIn: TGUID = '{ED41D2F7-43E0-4A66-8802-F0FAFD7EB782}';

  IID_ITotalQuantity: TGUID = '{8C91A2DF-087E-4B1F-93C2-3BF203B38813}';
  CLASS_TotalQuantity: TGUID = '{F9CBABB9-2A55-49F7-AB70-A43ADA394579}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ITotalQuantity = interface;
  ITotalQuantityDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  TotalQuantity = ITotalQuantity;


// *********************************************************************//
// Interface: ITotalQuantity
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8C91A2DF-087E-4B1F-93C2-3BF203B38813}
// *********************************************************************//
  ITotalQuantity = interface(IDispatch)
    ['{8C91A2DF-087E-4B1F-93C2-3BF203B38813}']
  end;

// *********************************************************************//
// DispIntf:  ITotalQuantityDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8C91A2DF-087E-4B1F-93C2-3BF203B38813}
// *********************************************************************//
  ITotalQuantityDisp = dispinterface
    ['{8C91A2DF-087E-4B1F-93C2-3BF203B38813}']
  end;

// *********************************************************************//
// The Class CoTotalQuantity provides a Create and CreateRemote method to          
// create instances of the default interface ITotalQuantity exposed by              
// the CoClass TotalQuantity. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTotalQuantity = class
    class function Create: ITotalQuantity;
    class function CreateRemote(const MachineName: string): ITotalQuantity;
  end;

implementation

uses ComObj;

class function CoTotalQuantity.Create: ITotalQuantity;
begin
  Result := CreateComObject(CLASS_TotalQuantity) as ITotalQuantity;
end;

class function CoTotalQuantity.CreateRemote(const MachineName: string): ITotalQuantity;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TotalQuantity) as ITotalQuantity;
end;

end.
