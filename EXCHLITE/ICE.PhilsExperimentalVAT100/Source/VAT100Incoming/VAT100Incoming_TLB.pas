unit VAT100Incoming_TLB;

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
// File generated on 26/06/2013 14:26:14 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\VAT100Incoming\VAT100Incoming.tlb (1)
// LIBID: {8F89EAD0-49C5-4821-8068-8E7D58129CB6}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
//   (2) v1.0 DSRIncoming, (C:\EXCH70P\dsrincoming.dll)
//   (3) v8.8 InternetFiling, (C:\Program Files\IRIS Software Ltd\IRIS FBI SubSystem\InternetFiling.tlb)
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
  VAT100IncomingMajorVersion = 1;
  VAT100IncomingMinorVersion = 0;

  LIBID_VAT100Incoming: TGUID = '{8F89EAD0-49C5-4821-8068-8E7D58129CB6}';

  IID_IVAT100Receiving: TGUID = '{3E6A7AA5-59A5-47DB-9889-16A96D01A6F0}';
  CLASS_VAT100Receiving: TGUID = '{D130D2DC-C3BF-4758-8D71-8C57EA2BA357}';
  IID_IVAT100CallBack: TGUID = '{14C6B2B7-7973-4CBF-AA9A-FA0561292F5D}';
  CLASS_VAT100CallBack: TGUID = '{0F3F3BF9-4C3A-4DCA-91FE-DB9506012597}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IVAT100Receiving = interface;
  IVAT100ReceivingDisp = dispinterface;
  IVAT100CallBack = interface;
  IVAT100CallBackDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  VAT100Receiving = IVAT100Receiving;
  VAT100CallBack = ICallback;


// *********************************************************************//
// Interface: IVAT100Receiving
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3E6A7AA5-59A5-47DB-9889-16A96D01A6F0}
// *********************************************************************//
  IVAT100Receiving = interface(IDispatch)
    ['{3E6A7AA5-59A5-47DB-9889-16A96D01A6F0}']
  end;

// *********************************************************************//
// DispIntf:  IVAT100ReceivingDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3E6A7AA5-59A5-47DB-9889-16A96D01A6F0}
// *********************************************************************//
  IVAT100ReceivingDisp = dispinterface
    ['{3E6A7AA5-59A5-47DB-9889-16A96D01A6F0}']
  end;

// *********************************************************************//
// Interface: IVAT100CallBack
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {14C6B2B7-7973-4CBF-AA9A-FA0561292F5D}
// *********************************************************************//
  IVAT100CallBack = interface(IDispatch)
    ['{14C6B2B7-7973-4CBF-AA9A-FA0561292F5D}']
  end;

// *********************************************************************//
// DispIntf:  IVAT100CallBackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {14C6B2B7-7973-4CBF-AA9A-FA0561292F5D}
// *********************************************************************//
  IVAT100CallBackDisp = dispinterface
    ['{14C6B2B7-7973-4CBF-AA9A-FA0561292F5D}']
  end;

// *********************************************************************//
// The Class CoVAT100Receiving provides a Create and CreateRemote method to          
// create instances of the default interface IVAT100Receiving exposed by              
// the CoClass VAT100Receiving. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoVAT100Receiving = class
    class function Create: IVAT100Receiving;
    class function CreateRemote(const MachineName: string): IVAT100Receiving;
  end;

// *********************************************************************//
// The Class CoVAT100CallBack provides a Create and CreateRemote method to          
// create instances of the default interface ICallback exposed by              
// the CoClass VAT100CallBack. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoVAT100CallBack = class
    class function Create: ICallback;
    class function CreateRemote(const MachineName: string): ICallback;
  end;

implementation

uses ComObj;

class function CoVAT100Receiving.Create: IVAT100Receiving;
begin
  Result := CreateComObject(CLASS_VAT100Receiving) as IVAT100Receiving;
end;

class function CoVAT100Receiving.CreateRemote(const MachineName: string): IVAT100Receiving;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_VAT100Receiving) as IVAT100Receiving;
end;

class function CoVAT100CallBack.Create: ICallback;
begin
  Result := CreateComObject(CLASS_VAT100CallBack) as ICallback;
end;

class function CoVAT100CallBack.CreateRemote(const MachineName: string): ICallback;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_VAT100CallBack) as ICallback;
end;

end.
