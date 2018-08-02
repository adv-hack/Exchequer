unit ComCaller_TLB;

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
// File generated on 1/3/2006 09:41:41 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Projects\Ice\Source\DsrComCaller\ComCaller.tlb (1)
// LIBID: {9E4DA3AD-10F0-45F0-8112-2BBB4AA2E385}
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
  ComCallerMajorVersion = 1;
  ComCallerMinorVersion = 0;

  LIBID_ComCaller: TGUID = '{9E4DA3AD-10F0-45F0-8112-2BBB4AA2E385}';

  IID_IDSRCOMCaller: TGUID = '{45B77751-B90C-4B66-934A-4224BDA8759C}';
  DIID_IDSRCOMCallerEvents: TGUID = '{21B82125-36E9-4208-A00D-77DA76D73B99}';
  CLASS_DSRCOMCaller: TGUID = '{5E77F3CE-95DD-417F-9496-EA9979F8E855}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSRCOMCaller = interface;
  IDSRCOMCallerDisp = dispinterface;
  IDSRCOMCallerEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSRCOMCaller = IDSRCOMCaller;


// *********************************************************************//
// Interface: IDSRCOMCaller
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {45B77751-B90C-4B66-934A-4224BDA8759C}
// *********************************************************************//
  IDSRCOMCaller = interface(IDispatch)
    ['{45B77751-B90C-4B66-934A-4224BDA8759C}']
    procedure BExport(pCompany: LongWord; pGuid: TGUID; const pSubj: WideString; 
                      const pFrom: WideString; const pTo: WideString; const pMsgBody: WideString; 
                      pMsgType: Smallint; pPeriodFrom: TDateTime; pPeriodTo: TDateTime; 
                      out pResult: LongWord); safecall;
    procedure BImport(pCompany: LongWord; pGuid: TGUID; pMsgType: Smallint; out pResult: LongWord); safecall;
    procedure GGW_PreparePacket(pCompany: LongWord; pGuid: TGUID; const pSubj: WideString; 
                                const pFrom: WideString; const pTo: WideString; 
                                const pMsgBody: WideString; const pXml: WideString; 
                                const pIRMark: WideString; out pResult: LongWord); safecall;
    procedure GGW_SendPacket(pCompany: LongWord; pGuid: TGUID; const pIRMark: WideString; 
                             out pResult: LongWord); safecall;
    procedure GGW_GetPending(pCompany: LongWord; pDate: TDateTime; out pMessages: OleVariant; 
                             out pCount: LongWord; out pResult: LongWord); safecall;
    procedure TranslateErrorCode(pErrorCode: LongWord; out pTranslation: WideString); safecall;
    procedure DeleteInboxMessage(pCompany: LongWord; pGuid: TGUID; out pResult: LongWord); safecall;
    procedure DeleteOutboxMessage(pCompany: LongWord; pGuid: TGUID; out pResult: LongWord); safecall;
    procedure GetInboxMessageDetail(pGuid: TGUID; out pMessage: OleVariant; out pResult: LongWord); safecall;
    procedure GetOutboxMessageDetail(pGuid: TGUID; out pMessage: OleVariant; out pResult: LongWord); safecall;
    procedure GetInboxMessages(pCompany: LongWord; pMsgType: Smallint; pDate: TDateTime; 
                               out pMessages: OleVariant; out pCount: LongWord; 
                               out pResult: LongWord); safecall;
    procedure GetOutboxMessages(pCompany: LongWord; pMsgType: Smallint; pDate: TDateTime; 
                                out pMessages: OleVariant; out pCount: LongWord; 
                                out pResult: LongWord); safecall;
    procedure SetTimerInterval(pInterval: Word; out pResult: LongWord); safecall;
    procedure ActivateTimer(pActivate: Shortint; out pResult: LongWord); safecall;
    procedure IsTimerActive(out pTimerActive: Shortint; out pResult: LongWord); safecall;
  end;

// *********************************************************************//
// DispIntf:  IDSRCOMCallerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {45B77751-B90C-4B66-934A-4224BDA8759C}
// *********************************************************************//
  IDSRCOMCallerDisp = dispinterface
    ['{45B77751-B90C-4B66-934A-4224BDA8759C}']
    procedure BExport(pCompany: LongWord; pGuid: {??TGUID}OleVariant; const pSubj: WideString; 
                      const pFrom: WideString; const pTo: WideString; const pMsgBody: WideString; 
                      pMsgType: Smallint; pPeriodFrom: TDateTime; pPeriodTo: TDateTime; 
                      out pResult: LongWord); dispid 1;
    procedure BImport(pCompany: LongWord; pGuid: {??TGUID}OleVariant; pMsgType: Smallint; 
                      out pResult: LongWord); dispid 4;
    procedure GGW_PreparePacket(pCompany: LongWord; pGuid: {??TGUID}OleVariant; 
                                const pSubj: WideString; const pFrom: WideString; 
                                const pTo: WideString; const pMsgBody: WideString; 
                                const pXml: WideString; const pIRMark: WideString; 
                                out pResult: LongWord); dispid 2;
    procedure GGW_SendPacket(pCompany: LongWord; pGuid: {??TGUID}OleVariant; 
                             const pIRMark: WideString; out pResult: LongWord); dispid 12;
    procedure GGW_GetPending(pCompany: LongWord; pDate: TDateTime; out pMessages: OleVariant; 
                             out pCount: LongWord; out pResult: LongWord); dispid 13;
    procedure TranslateErrorCode(pErrorCode: LongWord; out pTranslation: WideString); dispid 14;
    procedure DeleteInboxMessage(pCompany: LongWord; pGuid: {??TGUID}OleVariant; 
                                 out pResult: LongWord); dispid 15;
    procedure DeleteOutboxMessage(pCompany: LongWord; pGuid: {??TGUID}OleVariant; 
                                  out pResult: LongWord); dispid 16;
    procedure GetInboxMessageDetail(pGuid: {??TGUID}OleVariant; out pMessage: OleVariant; 
                                    out pResult: LongWord); dispid 17;
    procedure GetOutboxMessageDetail(pGuid: {??TGUID}OleVariant; out pMessage: OleVariant; 
                                     out pResult: LongWord); dispid 18;
    procedure GetInboxMessages(pCompany: LongWord; pMsgType: Smallint; pDate: TDateTime; 
                               out pMessages: OleVariant; out pCount: LongWord; 
                               out pResult: LongWord); dispid 19;
    procedure GetOutboxMessages(pCompany: LongWord; pMsgType: Smallint; pDate: TDateTime; 
                                out pMessages: OleVariant; out pCount: LongWord; 
                                out pResult: LongWord); dispid 20;
    procedure SetTimerInterval(pInterval: {??Word}OleVariant; out pResult: LongWord); dispid 3;
    procedure ActivateTimer(pActivate: {??Shortint}OleVariant; out pResult: LongWord); dispid 5;
    procedure IsTimerActive(out pTimerActive: {??Shortint}OleVariant; out pResult: LongWord); dispid 6;
  end;

// *********************************************************************//
// DispIntf:  IDSRCOMCallerEvents
// Flags:     (4096) Dispatchable
// GUID:      {21B82125-36E9-4208-A00D-77DA76D73B99}
// *********************************************************************//
  IDSRCOMCallerEvents = dispinterface
    ['{21B82125-36E9-4208-A00D-77DA76D73B99}']
    procedure SyncInbox(out pNewMsgs: LongWord); dispid 1;
    procedure SyncOutbox(out pTotalMsgs: LongWord); dispid 2;
  end;

// *********************************************************************//
// The Class CoDSRCOMCaller provides a Create and CreateRemote method to          
// create instances of the default interface IDSRCOMCaller exposed by              
// the CoClass DSRCOMCaller. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSRCOMCaller = class
    class function Create: IDSRCOMCaller;
    class function CreateRemote(const MachineName: string): IDSRCOMCaller;
  end;

implementation

uses ComObj;

class function CoDSRCOMCaller.Create: IDSRCOMCaller;
begin
  Result := CreateComObject(CLASS_DSRCOMCaller) as IDSRCOMCaller;
end;

class function CoDSRCOMCaller.CreateRemote(const MachineName: string): IDSRCOMCaller;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSRCOMCaller) as IDSRCOMCaller;
end;

end.
