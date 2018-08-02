unit DSRIncoming_TLB;

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
// File generated on 26/06/2013 14:26:13 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\EXCH70P\dsrincoming.dll (1)
// LIBID: {D0EE77AF-A44C-4E67-9512-3C5AB1398DD3}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
// Parent TypeLibrary:
//   (0) v1.0 VAT100Incoming, (X:\EXCHLITE\ICE\Source\VAT100Incoming\VAT100Incoming.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
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
  DSRIncomingMajorVersion = 1;
  DSRIncomingMinorVersion = 0;

  LIBID_DSRIncoming: TGUID = '{D0EE77AF-A44C-4E67-9512-3C5AB1398DD3}';

  IID_IDSRIncomingSystem: TGUID = '{ACA48414-72B5-44AC-8B6E-8205DF84E73B}';
  CLASS_DSRIncomingSystem: TGUID = '{BFFDC826-4A6D-405E-9142-5E958E68F185}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSRIncomingSystem = interface;
  IDSRIncomingSystemDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSRIncomingSystem = IDSRIncomingSystem;


// *********************************************************************//
// Interface: IDSRIncomingSystem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ACA48414-72B5-44AC-8B6E-8205DF84E73B}
// *********************************************************************//
  IDSRIncomingSystem = interface(IDispatch)
    ['{ACA48414-72B5-44AC-8B6E-8205DF84E73B}']
    procedure CheckNow; safecall;
    function Get_YourName: WideString; safecall;
    procedure Set_YourName(const Value: WideString); safecall;
    function Get_ServerType: WideString; safecall;
    procedure Set_ServerType(const Value: WideString); safecall;
    function Get_IncomingServer: WideString; safecall;
    procedure Set_IncomingServer(const Value: WideString); safecall;
    function Get_UserName: WideString; safecall;
    procedure Set_UserName(const Value: WideString); safecall;
    function Get_Password: WideString; safecall;
    procedure Set_Password(const Value: WideString); safecall;
    function Get_IncomingPort: Integer; safecall;
    procedure Set_IncomingPort(Value: Integer); safecall;
    function Get_Authentication: WordBool; safecall;
    procedure Set_Authentication(Value: WordBool); safecall;
    function Get_MailBoxName: WideString; safecall;
    procedure Set_MailBoxName(const Value: WideString); safecall;
    function Get_MailBoxSeparator: WideString; safecall;
    procedure Set_MailBoxSeparator(const Value: WideString); safecall;
    function Get_YourEmail: WideString; safecall;
    procedure Set_YourEmail(const Value: WideString); safecall;
    property YourName: WideString read Get_YourName write Set_YourName;
    property ServerType: WideString read Get_ServerType write Set_ServerType;
    property IncomingServer: WideString read Get_IncomingServer write Set_IncomingServer;
    property UserName: WideString read Get_UserName write Set_UserName;
    property Password: WideString read Get_Password write Set_Password;
    property IncomingPort: Integer read Get_IncomingPort write Set_IncomingPort;
    property Authentication: WordBool read Get_Authentication write Set_Authentication;
    property MailBoxName: WideString read Get_MailBoxName write Set_MailBoxName;
    property MailBoxSeparator: WideString read Get_MailBoxSeparator write Set_MailBoxSeparator;
    property YourEmail: WideString read Get_YourEmail write Set_YourEmail;
  end;

// *********************************************************************//
// DispIntf:  IDSRIncomingSystemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ACA48414-72B5-44AC-8B6E-8205DF84E73B}
// *********************************************************************//
  IDSRIncomingSystemDisp = dispinterface
    ['{ACA48414-72B5-44AC-8B6E-8205DF84E73B}']
    procedure CheckNow; dispid 1;
    property YourName: WideString dispid 11;
    property ServerType: WideString dispid 12;
    property IncomingServer: WideString dispid 13;
    property UserName: WideString dispid 14;
    property Password: WideString dispid 15;
    property IncomingPort: Integer dispid 19;
    property Authentication: WordBool dispid 20;
    property MailBoxName: WideString dispid 21;
    property MailBoxSeparator: WideString dispid 22;
    property YourEmail: WideString dispid 2;
  end;

// *********************************************************************//
// The Class CoDSRIncomingSystem provides a Create and CreateRemote method to          
// create instances of the default interface IDSRIncomingSystem exposed by              
// the CoClass DSRIncomingSystem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSRIncomingSystem = class
    class function Create: IDSRIncomingSystem;
    class function CreateRemote(const MachineName: string): IDSRIncomingSystem;
  end;

implementation

uses ComObj;

class function CoDSRIncomingSystem.Create: IDSRIncomingSystem;
begin
  Result := CreateComObject(CLASS_DSRIncomingSystem) as IDSRIncomingSystem;
end;

class function CoDSRIncomingSystem.CreateRemote(const MachineName: string): IDSRIncomingSystem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSRIncomingSystem) as IDSRIncomingSystem;
end;

end.
