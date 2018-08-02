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

// PASTLWTR : $Revision:   1.130.1.0.1.0.1.6  $
// File generated on 12/03/2018 11:45:44 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\CISIncoming\CISIncoming.tlb (1)
// LIBID: {1E0DBAA4-54E8-403E-B506-08C1592528A1}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
//   (2) v1.0 DSRIncoming, (C:\Exchequer\Compiled GovLink\DSRIncoming.dll)
//   (3) v8.8 InternetFiling, (C:\Program Files\Advanced Enterprise Software Ltd\Exchequer FBI SubSystem\InternetFiling.tlb)
//   (4) v4.0 StdVCL, (C:\Windows\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, DSRIncoming_TLB, Graphics, InternetFiling_TLB, StdVCL, Variants;
  


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

  LIBID_CISIncoming: TGUID = '{1E0DBAA4-54E8-403E-B506-08C1592528A1}';

  IID_ICISReceiving: TGUID = '{32A6002E-1402-438F-8FD8-2ACF8DC0AD9C}';
  CLASS_CISReceiving: TGUID = '{58FC0C01-6D0A-497A-A425-305C0034A841}';
  IID_ICISCallBack: TGUID = '{2F60D6B6-5342-463F-830E-9CFF756A7736}';
  CLASS_CISCallBack: TGUID = '{5018795D-D0F9-47E9-9398-3DAF0CC9A9EB}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ICISReceiving = interface;
  ICISReceivingDisp = dispinterface;
  ICISCallBack = interface;
  ICISCallBackDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CISReceiving = ICISReceiving;
  CISCallBack = ICallback;


// *********************************************************************//
// Interface: ICISReceiving
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {32A6002E-1402-438F-8FD8-2ACF8DC0AD9C}
// *********************************************************************//
  ICISReceiving = interface(IDispatch)
    ['{32A6002E-1402-438F-8FD8-2ACF8DC0AD9C}']
  end;

// *********************************************************************//
// DispIntf:  ICISReceivingDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {32A6002E-1402-438F-8FD8-2ACF8DC0AD9C}
// *********************************************************************//
  ICISReceivingDisp = dispinterface
    ['{32A6002E-1402-438F-8FD8-2ACF8DC0AD9C}']
  end;

// *********************************************************************//
// Interface: ICISCallBack
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2F60D6B6-5342-463F-830E-9CFF756A7736}
// *********************************************************************//
  ICISCallBack = interface(IDispatch)
    ['{2F60D6B6-5342-463F-830E-9CFF756A7736}']
  end;

// *********************************************************************//
// DispIntf:  ICISCallBackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2F60D6B6-5342-463F-830E-9CFF756A7736}
// *********************************************************************//
  ICISCallBackDisp = dispinterface
    ['{2F60D6B6-5342-463F-830E-9CFF756A7736}']
  end;

// *********************************************************************//
// The Class CoCISReceiving provides a Create and CreateRemote method to          
// create instances of the default interface ICISReceiving exposed by              
// the CoClass CISReceiving. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCISReceiving = class
    class function Create: ICISReceiving;
    class function CreateRemote(const MachineName: string): ICISReceiving;
  end;

// *********************************************************************//
// The Class CoCISCallBack provides a Create and CreateRemote method to          
// create instances of the default interface ICallback exposed by              
// the CoClass CISCallBack. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCISCallBack = class
    class function Create: ICallback;
    class function CreateRemote(const MachineName: string): ICallback;
  end;

implementation

uses ComObj;

class function CoCISReceiving.Create: ICISReceiving;
begin
  Result := CreateComObject(CLASS_CISReceiving) as ICISReceiving;
end;

class function CoCISReceiving.CreateRemote(const MachineName: string): ICISReceiving;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CISReceiving) as ICISReceiving;
end;

class function CoCISCallBack.Create: ICallback;
begin
  Result := CreateComObject(CLASS_CISCallBack) as ICallback;
end;

class function CoCISCallBack.CreateRemote(const MachineName: string): ICallback;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CISCallBack) as ICallback;
end;

end.
