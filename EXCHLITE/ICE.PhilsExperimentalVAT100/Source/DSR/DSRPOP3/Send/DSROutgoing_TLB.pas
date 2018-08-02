unit DSROutgoing_TLB;

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
// File generated on 13/02/2007 09:00:13 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Projects\Ice\Bin\DSROutgoing.dll (1)
// LIBID: {F061BE4B-DB67-4121-A413-0137F7A767EF}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Parent TypeLibrary:
//   (0) v1.0 DSRPOP3Send, (X:\EXCHLITE\ICE\Source\DSR\DSRPOP3\Send\DSRPOP3Send.tlb)
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
  DSROutgoingMajorVersion = 1;
  DSROutgoingMinorVersion = 0;

  LIBID_DSROutgoing: TGUID = '{F061BE4B-DB67-4121-A413-0137F7A767EF}';

  IID_IDSROutgoingSystem: TGUID = '{67C7CC27-2909-4273-B224-806A99814A6D}';
  CLASS_DSROutgoingSystem: TGUID = '{58B62A90-9EB7-43E9-8D0C-65E58B05919A}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSROutgoingSystem = interface;
  IDSROutgoingSystemDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSROutgoingSystem = IDSROutgoingSystem;


// *********************************************************************//
// Interface: IDSROutgoingSystem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {67C7CC27-2909-4273-B224-806A99814A6D}
// *********************************************************************//
  IDSROutgoingSystem = interface(IDispatch)
    ['{67C7CC27-2909-4273-B224-806A99814A6D}']
    function SendMsg: LongWord; safecall;
    function Get_ServerType: WideString; safecall;
    procedure Set_ServerType(const Value: WideString); safecall;
    function Get_OutgoingServer: WideString; safecall;
    procedure Set_OutgoingServer(const Value: WideString); safecall;
    function Get_UserName: WideString; safecall;
    procedure Set_UserName(const Value: WideString); safecall;
    function Get_Password: WideString; safecall;
    procedure Set_Password(const Value: WideString); safecall;
    function Get_OutgoingPort: Integer; safecall;
    procedure Set_OutgoingPort(Value: Integer); safecall;
    function Get_Authentication: WordBool; safecall;
    procedure Set_Authentication(Value: WordBool); safecall;
    function Get_SSLOutgoing: WordBool; safecall;
    procedure Set_SSLOutgoing(Value: WordBool); safecall;
    function Get_OutgoingUsername: WideString; safecall;
    procedure Set_OutgoingUsername(const Value: WideString); safecall;
    function Get_OutgoingPassword: WideString; safecall;
    procedure Set_OutgoingPassword(const Value: WideString); safecall;
    function Get_YourName: WideString; safecall;
    procedure Set_YourName(const Value: WideString); safecall;
    function Get_YourEmail: WideString; safecall;
    procedure Set_YourEmail(const Value: WideString); safecall;
    function Get_Subject: WideString; safecall;
    procedure Set_Subject(const Value: WideString); safecall;
    function Get_Body: WideString; safecall;
    procedure Set_Body(const Value: WideString); safecall;
    function Get_Files: WideString; safecall;
    procedure Set_Files(const Value: WideString); safecall;
    function Get_CC: WideString; safecall;
    procedure Set_CC(const Value: WideString); safecall;
    function Get_BCC: WideString; safecall;
    procedure Set_BCC(const Value: WideString); safecall;
    function Get_To_: WideString; safecall;
    procedure Set_To_(const Value: WideString); safecall;
    property ServerType: WideString read Get_ServerType write Set_ServerType;
    property OutgoingServer: WideString read Get_OutgoingServer write Set_OutgoingServer;
    property UserName: WideString read Get_UserName write Set_UserName;
    property Password: WideString read Get_Password write Set_Password;
    property OutgoingPort: Integer read Get_OutgoingPort write Set_OutgoingPort;
    property Authentication: WordBool read Get_Authentication write Set_Authentication;
    property SSLOutgoing: WordBool read Get_SSLOutgoing write Set_SSLOutgoing;
    property OutgoingUsername: WideString read Get_OutgoingUsername write Set_OutgoingUsername;
    property OutgoingPassword: WideString read Get_OutgoingPassword write Set_OutgoingPassword;
    property YourName: WideString read Get_YourName write Set_YourName;
    property YourEmail: WideString read Get_YourEmail write Set_YourEmail;
    property Subject: WideString read Get_Subject write Set_Subject;
    property Body: WideString read Get_Body write Set_Body;
    property Files: WideString read Get_Files write Set_Files;
    property CC: WideString read Get_CC write Set_CC;
    property BCC: WideString read Get_BCC write Set_BCC;
    property To_: WideString read Get_To_ write Set_To_;
  end;

// *********************************************************************//
// DispIntf:  IDSROutgoingSystemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {67C7CC27-2909-4273-B224-806A99814A6D}
// *********************************************************************//
  IDSROutgoingSystemDisp = dispinterface
    ['{67C7CC27-2909-4273-B224-806A99814A6D}']
    function SendMsg: LongWord; dispid 1;
    property ServerType: WideString dispid 2;
    property OutgoingServer: WideString dispid 3;
    property UserName: WideString dispid 4;
    property Password: WideString dispid 6;
    property OutgoingPort: Integer dispid 7;
    property Authentication: WordBool dispid 8;
    property SSLOutgoing: WordBool dispid 9;
    property OutgoingUsername: WideString dispid 10;
    property OutgoingPassword: WideString dispid 11;
    property YourName: WideString dispid 12;
    property YourEmail: WideString dispid 13;
    property Subject: WideString dispid 16;
    property Body: WideString dispid 17;
    property Files: WideString dispid 18;
    property CC: WideString dispid 19;
    property BCC: WideString dispid 20;
    property To_: WideString dispid 22;
  end;

// *********************************************************************//
// The Class CoDSROutgoingSystem provides a Create and CreateRemote method to          
// create instances of the default interface IDSROutgoingSystem exposed by              
// the CoClass DSROutgoingSystem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSROutgoingSystem = class
    class function Create: IDSROutgoingSystem;
    class function CreateRemote(const MachineName: string): IDSROutgoingSystem;
  end;

implementation

uses ComObj;

class function CoDSROutgoingSystem.Create: IDSROutgoingSystem;
begin
  Result := CreateComObject(CLASS_DSROutgoingSystem) as IDSROutgoingSystem;
end;

class function CoDSROutgoingSystem.CreateRemote(const MachineName: string): IDSROutgoingSystem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSROutgoingSystem) as IDSROutgoingSystem;
end;

end.
