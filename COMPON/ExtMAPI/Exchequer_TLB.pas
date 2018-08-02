unit Exchequer_TLB;

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

// $Rev: 52393 $
// File generated on 02/02/2017 15:30:36 from Type Library described below.

// ************************************************************************  //
// Type Lib: W:\COMPON\ExtMAPI\Exchequer (1)
// LIBID: {9508999E-20DE-4168-A719-721AE591B204}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
//   (2) v4.0 StdVCL, (stdvcl40.dll)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$IFNDEF VER140}
  {$VARPROPSETTER ON}
{$ENDIF VER140}
{$ALIGN 4}

interface

{$IFNDEF VER140}
uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;
{$ELSE}
uses Windows, Classes, Variants, StdVCL, Graphics, OleServer, ActiveX;
{$ENDIF VER140}
// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ExchequerMajorVersion = 1;
  ExchequerMinorVersion = 0;

  LIBID_Exchequer: TGUID = '{9508999E-20DE-4168-A719-721AE591B204}';

  IID_IMapi64: TGUID = '{5F8BA48F-9F74-41B6-AA90-0BEDA4703915}';
  CLASS_Mapi64: TGUID = '{5F77EDBB-0AE5-40D5-A9A9-A1BD1F3070FF}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IMapi64 = interface;
  IMapi64Disp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  Mapi64 = IMapi64;


// *********************************************************************//
// Interface: IMapi64
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5F8BA48F-9F74-41B6-AA90-0BEDA4703915}
// *********************************************************************//
  IMapi64 = interface(IDispatch)
    ['{5F8BA48F-9F74-41B6-AA90-0BEDA4703915}']
    function Get_emVersion: WideString; safecall;
    function Get_emRecipient: WideString; safecall;
    procedure Set_emRecipient(const Value: WideString); safecall;
    function Get_emCC: WideString; safecall;
    procedure Set_emCC(const Value: WideString); safecall;
    function Get_emBCC: WideString; safecall;
    procedure Set_emBCC(const Value: WideString); safecall;
    function Get_emAttachment: WideString; safecall;
    procedure Set_emAttachment(const Value: WideString); safecall;
    function Get_emSubject: WideString; safecall;
    procedure Set_emSubject(const Value: WideString); safecall;
    function Get_emMessage: WideString; safecall;
    procedure Set_emMessage(const Value: WideString); safecall;
    function Logon: Integer; safecall;
    function Logoff: Integer; safecall;
    function SendMail: Integer; safecall;
    function GetFirstUnread: Integer; safecall;
    function GetNextUnread: Integer; safecall;
    procedure SetMessageAsRead; safecall;
    procedure DeleteReadMessages; safecall;
    procedure DeleteMessage; safecall;
    function Get_emProfile: WideString; safecall;
    procedure Set_emProfile(const Value: WideString); safecall;
    function Get_emPassword: WideString; safecall;
    procedure Set_emPassword(const Value: WideString); safecall;
    function Get_emDeleteAfterRead: WordBool; safecall;
    procedure Set_emDeleteAfterRead(Value: WordBool); safecall;
    function Get_emService: WordBool; safecall;
    procedure Set_emService(Value: WordBool); safecall;
    function Get_emUseDefaultProfile: WordBool; safecall;
    procedure Set_emUseDefaultProfile(Value: WordBool); safecall;
    function Get_emShowDialog: WordBool; safecall;
    procedure Set_emShowDialog(Value: WordBool); safecall;
    function Get_emHandle: Integer; safecall;
    procedure Set_emHandle(Value: Integer); safecall;
    function Get_emLeaveUnread: WordBool; safecall;
    procedure Set_emLeaveUnread(Value: WordBool); safecall;
    function Get_emOriginator: WideString; safecall;
    function Get_emOriginatorAddress: WideString; safecall;
    property emVersion: WideString read Get_emVersion;
    property emRecipient: WideString read Get_emRecipient write Set_emRecipient;
    property emCC: WideString read Get_emCC write Set_emCC;
    property emBCC: WideString read Get_emBCC write Set_emBCC;
    property emAttachment: WideString read Get_emAttachment write Set_emAttachment;
    property emSubject: WideString read Get_emSubject write Set_emSubject;
    property emMessage: WideString read Get_emMessage write Set_emMessage;
    property emProfile: WideString read Get_emProfile write Set_emProfile;
    property emPassword: WideString read Get_emPassword write Set_emPassword;
    property emDeleteAfterRead: WordBool read Get_emDeleteAfterRead write Set_emDeleteAfterRead;
    property emService: WordBool read Get_emService write Set_emService;
    property emUseDefaultProfile: WordBool read Get_emUseDefaultProfile write Set_emUseDefaultProfile;
    property emShowDialog: WordBool read Get_emShowDialog write Set_emShowDialog;
    property emHandle: Integer read Get_emHandle write Set_emHandle;
    property emLeaveUnread: WordBool read Get_emLeaveUnread write Set_emLeaveUnread;
    property emOriginator: WideString read Get_emOriginator;
    property emOriginatorAddress: WideString read Get_emOriginatorAddress;
  end;

// *********************************************************************//
// DispIntf:  IMapi64Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5F8BA48F-9F74-41B6-AA90-0BEDA4703915}
// *********************************************************************//
  IMapi64Disp = dispinterface
    ['{5F8BA48F-9F74-41B6-AA90-0BEDA4703915}']
    property emVersion: WideString readonly dispid 201;
    property emRecipient: WideString dispid 202;
    property emCC: WideString dispid 203;
    property emBCC: WideString dispid 204;
    property emAttachment: WideString dispid 205;
    property emSubject: WideString dispid 206;
    property emMessage: WideString dispid 207;
    function Logon: Integer; dispid 208;
    function Logoff: Integer; dispid 209;
    function SendMail: Integer; dispid 210;
    function GetFirstUnread: Integer; dispid 211;
    function GetNextUnread: Integer; dispid 212;
    procedure SetMessageAsRead; dispid 213;
    procedure DeleteReadMessages; dispid 214;
    procedure DeleteMessage; dispid 215;
    property emProfile: WideString dispid 216;
    property emPassword: WideString dispid 217;
    property emDeleteAfterRead: WordBool dispid 218;
    property emService: WordBool dispid 219;
    property emUseDefaultProfile: WordBool dispid 220;
    property emShowDialog: WordBool dispid 221;
    property emHandle: Integer dispid 222;
    property emLeaveUnread: WordBool dispid 223;
    property emOriginator: WideString readonly dispid 224;
    property emOriginatorAddress: WideString readonly dispid 225;
  end;

// *********************************************************************//
// The Class CoMapi64 provides a Create and CreateRemote method to
// create instances of the default interface IMapi64 exposed by
// the CoClass Mapi64. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoMapi64 = class
    class function Create: IMapi64;
    class function CreateRemote(const MachineName: string): IMapi64;
  end;

implementation

{$IFNDEF VER140}
uses System.Win.ComObj;
{$ELSE}
uses ComObj;
{$ENDIF VER140}
class function CoMapi64.Create: IMapi64;
begin
  Result := CreateComObject(CLASS_Mapi64) as IMapi64;
end;

class function CoMapi64.CreateRemote(const MachineName: string): IMapi64;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Mapi64) as IMapi64;
end;

end.

