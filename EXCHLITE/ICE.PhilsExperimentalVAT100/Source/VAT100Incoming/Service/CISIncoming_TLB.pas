unit CISIncoming_TLB;

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
// File generated on 15/08/2006 12:12:08 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\CISIncoming\CISIncoming.tlb (1)
// LIBID: {7E8397B3-2FE4-4FBD-BB2E-6730954D1B18}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
//   (3) v8.7 InternetFiling, (\\FRANKIE\VOL1\DEV\ENTERPRISE560\SOURCECODE\EXCHLITE\ICE\Source\CIS_TLB\InternetFiling.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, Graphics, InternetFiling_TLB, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  CISIncomingMajorVersion = 1;
  CISIncomingMinorVersion = 0;

  LIBID_CISIncoming: TGUID = '{7E8397B3-2FE4-4FBD-BB2E-6730954D1B18}';

  IID_ICISCallBack: TGUID = '{1C240C87-BBA0-4360-BDD4-C699ED43D745}';
  CLASS_CISCallBack: TGUID = '{675802CC-B7EF-4EFF-982A-98C8DE5B38AE}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ICISCallBack = interface;
  ICISCallBackDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CISCallBack = ICISCallBack;


// *********************************************************************//
// Interface: ICISCallBack
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1C240C87-BBA0-4360-BDD4-C699ED43D745}
// *********************************************************************//
  ICISCallBack = interface(IDispatch)
    ['{1C240C87-BBA0-4360-BDD4-C699ED43D745}']
  end;

// *********************************************************************//
// DispIntf:  ICISCallBackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1C240C87-BBA0-4360-BDD4-C699ED43D745}
// *********************************************************************//
  ICISCallBackDisp = dispinterface
    ['{1C240C87-BBA0-4360-BDD4-C699ED43D745}']
  end;

// *********************************************************************//
// The Class CoCISCallBack provides a Create and CreateRemote method to          
// create instances of the default interface ICISCallBack exposed by              
// the CoClass CISCallBack. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCISCallBack = class
    class function Create: ICISCallBack;
    class function CreateRemote(const MachineName: string): ICISCallBack;
  end;

implementation

uses ComObj;

class function CoCISCallBack.Create: ICISCallBack;
begin
  Result := CreateComObject(CLASS_CISCallBack) as ICISCallBack;
end;

class function CoCISCallBack.CreateRemote(const MachineName: string): ICISCallBack;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CISCallBack) as ICISCallBack;
end;

end.
