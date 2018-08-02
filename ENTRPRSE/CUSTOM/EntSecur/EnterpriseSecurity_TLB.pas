unit EnterpriseSecurity_TLB;

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
// File generated on 28/02/2011 10:28:17 from Type Library described below.

// ************************************************************************  //
// Type Lib: W:\ENTRPRSE\CUSTOM\EntSecur\ENTSECUR.tlb (1)
// LIBID: {CE970523-6BB4-41DD-8418-C67EBBF8DEBF}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\Windows\SysWOW64\stdvcl40.dll)
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
  EnterpriseSecurityMajorVersion = 1;
  EnterpriseSecurityMinorVersion = 0;

  LIBID_EnterpriseSecurity: TGUID = '{CE970523-6BB4-41DD-8418-C67EBBF8DEBF}';

  IID_IThirdParty: TGUID = '{B3CF3EE2-367E-4A8F-AECD-9DD89D7604E6}';
  CLASS_ThirdParty: TGUID = '{EC37AF35-0A80-487E-979E-C6188CB109F8}';
  IID_IThirdParty2: TGUID = '{42C0EDDF-0C78-499B-93FC-0BBE03DDBBD6}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TSecurityType
type
  TSecurityType = TOleEnum;
const
  SecSystemOnly = $00000000;
  SecUserCountOnly = $00000001;
  SecSystemAndUser = $00000002;

// Constants for enum TSystemSecurityStatus
type
  TSystemSecurityStatus = TOleEnum;
const
  SysExpired = $00000000;
  Sys30Day = $00000001;
  SysReleased = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IThirdParty = interface;
  IThirdPartyDisp = dispinterface;
  IThirdParty2 = interface;
  IThirdParty2Disp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ThirdParty = IThirdParty;


// *********************************************************************//
// Interface: IThirdParty
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B3CF3EE2-367E-4A8F-AECD-9DD89D7604E6}
// *********************************************************************//
  IThirdParty = interface(IDispatch)
    ['{B3CF3EE2-367E-4A8F-AECD-9DD89D7604E6}']
    function Get_Version: WideString; safecall;
    function Get_tpSystemIdCode: WideString; safecall;
    procedure Set_tpSystemIdCode(const Value: WideString); safecall;
    function Get_tpSecurityCode: WideString; safecall;
    procedure Set_tpSecurityCode(const Value: WideString); safecall;
    function Get_tpDescription: WideString; safecall;
    procedure Set_tpDescription(const Value: WideString); safecall;
    function Get_tpSecurityType: TSecurityType; safecall;
    procedure Set_tpSecurityType(Value: TSecurityType); safecall;
    function Get_tpSystemStatus: TSystemSecurityStatus; safecall;
    function Get_tpUserCount: Integer; safecall;
    function Get_tpCurrentUsers: Integer; safecall;
    function ReadSecurity: Integer; safecall;
    function AddUserCount: Integer; safecall;
    function RemoveUserCount: Integer; safecall;
    function ResetUserCount: Integer; safecall;
    function Get_LastErrorString: WideString; safecall;
    function Get_ExchequerSiteNumber: WideString; safecall;
    function Get_tpMessage: WideString; safecall;
    procedure Set_tpMessage(const Value: WideString); safecall;
    property Version: WideString read Get_Version;
    property tpSystemIdCode: WideString read Get_tpSystemIdCode write Set_tpSystemIdCode;
    property tpSecurityCode: WideString read Get_tpSecurityCode write Set_tpSecurityCode;
    property tpDescription: WideString read Get_tpDescription write Set_tpDescription;
    property tpSecurityType: TSecurityType read Get_tpSecurityType write Set_tpSecurityType;
    property tpSystemStatus: TSystemSecurityStatus read Get_tpSystemStatus;
    property tpUserCount: Integer read Get_tpUserCount;
    property tpCurrentUsers: Integer read Get_tpCurrentUsers;
    property LastErrorString: WideString read Get_LastErrorString;
    property ExchequerSiteNumber: WideString read Get_ExchequerSiteNumber;
    property tpMessage: WideString read Get_tpMessage write Set_tpMessage;
  end;

// *********************************************************************//
// DispIntf:  IThirdPartyDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B3CF3EE2-367E-4A8F-AECD-9DD89D7604E6}
// *********************************************************************//
  IThirdPartyDisp = dispinterface
    ['{B3CF3EE2-367E-4A8F-AECD-9DD89D7604E6}']
    property Version: WideString readonly dispid 1;
    property tpSystemIdCode: WideString dispid 2;
    property tpSecurityCode: WideString dispid 3;
    property tpDescription: WideString dispid 4;
    property tpSecurityType: TSecurityType dispid 5;
    property tpSystemStatus: TSystemSecurityStatus readonly dispid 6;
    property tpUserCount: Integer readonly dispid 7;
    property tpCurrentUsers: Integer readonly dispid 8;
    function ReadSecurity: Integer; dispid 9;
    function AddUserCount: Integer; dispid 10;
    function RemoveUserCount: Integer; dispid 11;
    function ResetUserCount: Integer; dispid 12;
    property LastErrorString: WideString readonly dispid 13;
    property ExchequerSiteNumber: WideString readonly dispid 14;
    property tpMessage: WideString dispid 15;
  end;

// *********************************************************************//
// Interface: IThirdParty2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {42C0EDDF-0C78-499B-93FC-0BBE03DDBBD6}
// *********************************************************************//
  IThirdParty2 = interface(IThirdParty)
    ['{42C0EDDF-0C78-499B-93FC-0BBE03DDBBD6}']
    function Get_tpExpiryDate: WideString; safecall;
    property tpExpiryDate: WideString read Get_tpExpiryDate;
  end;

// *********************************************************************//
// DispIntf:  IThirdParty2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {42C0EDDF-0C78-499B-93FC-0BBE03DDBBD6}
// *********************************************************************//
  IThirdParty2Disp = dispinterface
    ['{42C0EDDF-0C78-499B-93FC-0BBE03DDBBD6}']
    property tpExpiryDate: WideString readonly dispid 16;
    property Version: WideString readonly dispid 1;
    property tpSystemIdCode: WideString dispid 2;
    property tpSecurityCode: WideString dispid 3;
    property tpDescription: WideString dispid 4;
    property tpSecurityType: TSecurityType dispid 5;
    property tpSystemStatus: TSystemSecurityStatus readonly dispid 6;
    property tpUserCount: Integer readonly dispid 7;
    property tpCurrentUsers: Integer readonly dispid 8;
    function ReadSecurity: Integer; dispid 9;
    function AddUserCount: Integer; dispid 10;
    function RemoveUserCount: Integer; dispid 11;
    function ResetUserCount: Integer; dispid 12;
    property LastErrorString: WideString readonly dispid 13;
    property ExchequerSiteNumber: WideString readonly dispid 14;
    property tpMessage: WideString dispid 15;
  end;

// *********************************************************************//
// The Class CoThirdParty provides a Create and CreateRemote method to          
// create instances of the default interface IThirdParty exposed by              
// the CoClass ThirdParty. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoThirdParty = class
    class function Create: IThirdParty;
    class function CreateRemote(const MachineName: string): IThirdParty;
  end;

implementation

uses ComObj;

class function CoThirdParty.Create: IThirdParty;
begin
  Result := CreateComObject(CLASS_ThirdParty) as IThirdParty;
end;

class function CoThirdParty.CreateRemote(const MachineName: string): IThirdParty;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ThirdParty) as IThirdParty;
end;

end.
