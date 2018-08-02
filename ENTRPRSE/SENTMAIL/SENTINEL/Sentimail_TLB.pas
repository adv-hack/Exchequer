unit Sentimail_TLB;

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
// File generated on 23/11/2006 15:25:27 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\SENTMAIL\SENTINEL\SENTEVNT.tlb (1)
// LIBID: {E338D718-81F3-4C10-B609-912488B4D0B3}
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
  SentimailMajorVersion = 1;
  SentimailMinorVersion = 0;

  LIBID_Sentimail: TGUID = '{E338D718-81F3-4C10-B609-912488B4D0B3}';

  IID_ISentimailEvent: TGUID = '{1519E4AF-221B-43FF-8837-E7206EAC6650}';
  CLASS_SentimailEvent: TGUID = '{5F2AEB35-E289-4A1F-8452-5FFD065FF805}';
  IID_ITriggeredEvent: TGUID = '{78FCD024-C601-4ADA-9AD7-5AB947C9CAA8}';
  CLASS_TriggeredEvent: TGUID = '{B42D7988-55A3-4979-A8D4-F479D19A7F4F}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TEventDataType
type
  TEventDataType = TOleEnum;
const
  edtCustomer = $00000000;
  edtSupplier = $00000001;
  edtTransaction = $00000002;
  edtStock = $00000003;
  edtJob = $00000004;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ISentimailEvent = interface;
  ISentimailEventDisp = dispinterface;
  ITriggeredEvent = interface;
  ITriggeredEventDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SentimailEvent = ISentimailEvent;
  TriggeredEvent = ITriggeredEvent;


// *********************************************************************//
// Interface: ISentimailEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1519E4AF-221B-43FF-8837-E7206EAC6650}
// *********************************************************************//
  ISentimailEvent = interface(IDispatch)
    ['{1519E4AF-221B-43FF-8837-E7206EAC6650}']
    function Get_seWindowID: Integer; safecall;
    procedure Set_seWindowID(Value: Integer); safecall;
    function Get_seHandlerID: Integer; safecall;
    procedure Set_seHandlerID(Value: Integer); safecall;
    function Get_seKey: WideString; safecall;
    procedure Set_seKey(const Value: WideString); safecall;
    function Get_seDataType: TEventDataType; safecall;
    procedure Set_seDataType(Value: TEventDataType); safecall;
    function Save: Integer; safecall;
    function Get_seDataPath: WideString; safecall;
    procedure Set_seDataPath(const Value: WideString); safecall;
    property seWindowID: Integer read Get_seWindowID write Set_seWindowID;
    property seHandlerID: Integer read Get_seHandlerID write Set_seHandlerID;
    property seKey: WideString read Get_seKey write Set_seKey;
    property seDataType: TEventDataType read Get_seDataType write Set_seDataType;
    property seDataPath: WideString read Get_seDataPath write Set_seDataPath;
  end;

// *********************************************************************//
// DispIntf:  ISentimailEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1519E4AF-221B-43FF-8837-E7206EAC6650}
// *********************************************************************//
  ISentimailEventDisp = dispinterface
    ['{1519E4AF-221B-43FF-8837-E7206EAC6650}']
    property seWindowID: Integer dispid 1;
    property seHandlerID: Integer dispid 2;
    property seKey: WideString dispid 3;
    property seDataType: TEventDataType dispid 4;
    function Save: Integer; dispid 5;
    property seDataPath: WideString dispid 6;
  end;

// *********************************************************************//
// Interface: ITriggeredEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {78FCD024-C601-4ADA-9AD7-5AB947C9CAA8}
// *********************************************************************//
  ITriggeredEvent = interface(IDispatch)
    ['{78FCD024-C601-4ADA-9AD7-5AB947C9CAA8}']
    function Get_teUser: WideString; safecall;
    function Get_teSentinel: WideString; safecall;
    function Get_teLineCount: Integer; safecall;
    function Get_teDataPath: WideString; safecall;
    procedure Set_teDataPath(const Value: WideString); safecall;
    function Get_teLine(Index: Integer): WideString; safecall;
    function Get_teEmailAddress(Index: Integer): WideString; safecall;
    function Get_teSMSNumber(Index: Integer): WideString; safecall;
    function GetFirst(const User: WideString): Integer; safecall;
    function GetNext: Integer; safecall;
    function GetEqual(const User: WideString; const Sentinel: WideString; Instance: Integer): Integer; safecall;
    function Delete: Integer; safecall;
    function Get_teEmailSubject: WideString; safecall;
    function Get_teEmailAddressCount: Integer; safecall;
    function Get_teSMSNumberCount: Integer; safecall;
    function Get_teInstance: Integer; safecall;
    function Get_teVersion: WideString; safecall;
    property teUser: WideString read Get_teUser;
    property teSentinel: WideString read Get_teSentinel;
    property teLineCount: Integer read Get_teLineCount;
    property teDataPath: WideString read Get_teDataPath write Set_teDataPath;
    property teLine[Index: Integer]: WideString read Get_teLine;
    property teEmailAddress[Index: Integer]: WideString read Get_teEmailAddress;
    property teSMSNumber[Index: Integer]: WideString read Get_teSMSNumber;
    property teEmailSubject: WideString read Get_teEmailSubject;
    property teEmailAddressCount: Integer read Get_teEmailAddressCount;
    property teSMSNumberCount: Integer read Get_teSMSNumberCount;
    property teInstance: Integer read Get_teInstance;
    property teVersion: WideString read Get_teVersion;
  end;

// *********************************************************************//
// DispIntf:  ITriggeredEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {78FCD024-C601-4ADA-9AD7-5AB947C9CAA8}
// *********************************************************************//
  ITriggeredEventDisp = dispinterface
    ['{78FCD024-C601-4ADA-9AD7-5AB947C9CAA8}']
    property teUser: WideString readonly dispid 1;
    property teSentinel: WideString readonly dispid 2;
    property teLineCount: Integer readonly dispid 3;
    property teDataPath: WideString dispid 4;
    property teLine[Index: Integer]: WideString readonly dispid 5;
    property teEmailAddress[Index: Integer]: WideString readonly dispid 6;
    property teSMSNumber[Index: Integer]: WideString readonly dispid 7;
    function GetFirst(const User: WideString): Integer; dispid 8;
    function GetNext: Integer; dispid 9;
    function GetEqual(const User: WideString; const Sentinel: WideString; Instance: Integer): Integer; dispid 10;
    function Delete: Integer; dispid 11;
    property teEmailSubject: WideString readonly dispid 12;
    property teEmailAddressCount: Integer readonly dispid 13;
    property teSMSNumberCount: Integer readonly dispid 14;
    property teInstance: Integer readonly dispid 15;
    property teVersion: WideString readonly dispid 16;
  end;

// *********************************************************************//
// The Class CoSentimailEvent provides a Create and CreateRemote method to          
// create instances of the default interface ISentimailEvent exposed by              
// the CoClass SentimailEvent. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSentimailEvent = class
    class function Create: ISentimailEvent;
    class function CreateRemote(const MachineName: string): ISentimailEvent;
  end;

// *********************************************************************//
// The Class CoTriggeredEvent provides a Create and CreateRemote method to          
// create instances of the default interface ITriggeredEvent exposed by              
// the CoClass TriggeredEvent. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTriggeredEvent = class
    class function Create: ITriggeredEvent;
    class function CreateRemote(const MachineName: string): ITriggeredEvent;
  end;

implementation

uses ComObj;

class function CoSentimailEvent.Create: ISentimailEvent;
begin
  Result := CreateComObject(CLASS_SentimailEvent) as ISentimailEvent;
end;

class function CoSentimailEvent.CreateRemote(const MachineName: string): ISentimailEvent;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SentimailEvent) as ISentimailEvent;
end;

class function CoTriggeredEvent.Create: ITriggeredEvent;
begin
  Result := CreateComObject(CLASS_TriggeredEvent) as ITriggeredEvent;
end;

class function CoTriggeredEvent.CreateRemote(const MachineName: string): ITriggeredEvent;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TriggeredEvent) as ITriggeredEvent;
end;

end.
