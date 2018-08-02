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

// PASTLWTR : $Revision:   1.130.3.0.1.0  $
// File generated on 02/10/2006 12:44:35 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Projects\Ice\Bin\DSRIncoming.dll (1)
// LIBID: {D0EE77AF-A44C-4E67-9512-3C5AB1398DD3}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Parent TypeLibrary:
//   (0) v1.0 DSRReceiver, (X:\EXCHLITE\ICE\Source\DSR\Receiver\DSRReceiver.tlb)
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
    function Get_EmailType: Smallint; safecall;
    procedure Set_EmailType(Value: Smallint); safecall;
    function Get_SMTPServer: WideString; safecall;
    procedure Set_SMTPServer(const Value: WideString); safecall;
    function Get_Username: WideString; safecall;
    procedure Set_Username(const Value: WideString); safecall;
    function Get_Password: WideString; safecall;
    procedure Set_Password(const Value: WideString); safecall;
    function Get_POPAddress: WideString; safecall;
    procedure Set_POPAddress(const Value: WideString); safecall;
    function Get_YourName: WideString; safecall;
    procedure Set_YourName(const Value: WideString); safecall;
    function Get_POP3Server: WideString; safecall;
    procedure Set_POP3Server(const Value: WideString); safecall;
    function Get_POP3Port: Integer; safecall;
    procedure Set_POP3Port(Value: Integer); safecall;
    function Get_SMTPPort: Integer; safecall;
    procedure Set_SMTPPort(Value: Integer); safecall;
    property EmailType: Smallint read Get_EmailType write Set_EmailType;
    property SMTPServer: WideString read Get_SMTPServer write Set_SMTPServer;
    property Username: WideString read Get_Username write Set_Username;
    property Password: WideString read Get_Password write Set_Password;
    property POPAddress: WideString read Get_POPAddress write Set_POPAddress;
    property YourName: WideString read Get_YourName write Set_YourName;
    property POP3Server: WideString read Get_POP3Server write Set_POP3Server;
    property POP3Port: Integer read Get_POP3Port write Set_POP3Port;
    property SMTPPort: Integer read Get_SMTPPort write Set_SMTPPort;
  end;

// *********************************************************************//
// DispIntf:  IDSRIncomingSystemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ACA48414-72B5-44AC-8B6E-8205DF84E73B}
// *********************************************************************//
  IDSRIncomingSystemDisp = dispinterface
    ['{ACA48414-72B5-44AC-8B6E-8205DF84E73B}']
    procedure CheckNow; dispid 1;
    property EmailType: Smallint dispid 2;
    property SMTPServer: WideString dispid 3;
    property Username: WideString dispid 4;
    property Password: WideString dispid 5;
    property POPAddress: WideString dispid 6;
    property YourName: WideString dispid 7;
    property POP3Server: WideString dispid 9;
    property POP3Port: Integer dispid 10;
    property SMTPPort: Integer dispid 11;
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
