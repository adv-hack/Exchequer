unit DSR_TLB;

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
// File generated on 04/07/2013 11:20:35 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\EXCHLITE\ICE\Source\DSR\DSR.tlb (1)
// LIBID: {127B447F-2B6E-45B1-A76A-006D443D8C59}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\Windows\system32\stdvcl40.dll)
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
  DSRMajorVersion = 1;
  DSRMinorVersion = 0;

  LIBID_DSR: TGUID = '{127B447F-2B6E-45B1-A76A-006D443D8C59}';

  IID_IDSRSERVER: TGUID = '{61BFF091-15C9-4394-A26D-2D94A6F542F3}';
  CLASS_DSRSERVER: TGUID = '{2888CA49-03C5-47A2-B2E5-F954C7AB0A4B}';
  DIID_IDSRSERVEREvents: TGUID = '{D916A6E4-46E0-4D5D-8CB2-C7152F507C78}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDSRSERVER = interface;
  IDSRSERVERDisp = dispinterface;
  IDSRSERVEREvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DSRSERVER = IDSRSERVER;


// *********************************************************************//
// Interface: IDSRSERVER
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {61BFF091-15C9-4394-A26D-2D94A6F542F3}
// *********************************************************************//
  IDSRSERVER = interface(IDispatch)
    ['{61BFF091-15C9-4394-A26D-2D94A6F542F3}']
    function DSR_Export(pCompany: LongWord; const pSubj: WideString; const pFrom: WideString; 
                        const pTo: WideString; const pParam1: WideString; 
                        const pParam2: WideString; pPackageId: LongWord): LongWord; safecall;
    function DSR_Import(pCompany: LongWord; pGuid: TGUID; pPackageId: LongWord): LongWord; safecall;
    function DSR_DeleteInboxMessage(pCompany: LongWord; pGuid: TGUID): LongWord; safecall;
    function DSR_DeleteOutboxMessage(pCompany: LongWord; pGuid: TGUID): LongWord; safecall;
    function DSR_TotalOutboxMessages(pCompany: LongWord; out pMsgCount: LongWord): LongWord; safecall;
    function DSR_TranslateErrorCode(pErrorCode: LongWord): WideString; safecall;
    function DSR_DeleteCompany(pCompany: LongWord): LongWord; safecall;
    procedure DSR_SendLog(const pMail: WideString); safecall;
    function DSR_ResendOutboxMessage(pGuid: TGUID): LongWord; safecall;
    function DSR_GetImportPackages(out pPackage: OleVariant): LongWord; safecall;
    function DSR_GetExportPackages(out pPackage: OleVariant): LongWord; safecall;
    function DSR_GetOutboxMessages(pCompany: LongWord; pPackageId: LongWord; pStatus: Shortint; 
                                   pDate: TDateTime; pMaxRecords: LongWord; 
                                   out pMessages: OleVariant): LongWord; safecall;
    function DSR_GetInboxMessages(pCompany: LongWord; pPackageId: LongWord; pStatus: Shortint; 
                                  pDate: TDateTime; pMaxRecords: LongWord; out pMessages: OleVariant): LongWord; safecall;
    function DSR_NewInboxMessage(pMaxRecords: LongWord; out pMessages: OleVariant): LongWord; safecall;
    function DSR_GetCompanies(out pCompany: OleVariant): LongWord; safecall;
    function DSR_DeleteSchedule(pGuid: TGUID): LongWord; safecall;
    function DSR_SetDailySchedule(pGuid: TGUID; pCompany: LongWord; const pSubj: WideString; 
                                  const pFrom: WideString; const pTo: WideString; 
                                  const pParam1: WideString; const pParam2: WideString; 
                                  pPackageId: LongWord; pStartDate: TDateTime; pEndDate: TDateTime; 
                                  pStartTime: TDateTime; pAllDays: Shortint; pWeekDays: Shortint; 
                                  pEveryDay: Shortint): LongWord; safecall;
    function DSR_BulkExport(pCompany: LongWord; const pSubj: WideString; const pFrom: WideString; 
                            const pTo: WideString; const pParam1: WideString; 
                            const pParam2: WideString): LongWord; safecall;
    function DSR_CreateCompany(const pDescription: WideString; const pCode: WideString): LongWord; safecall;
    function DSR_Alive: LongWord; safecall;
    function DSR_AddNewUser(const pUserName: WideString; const pUserLogin: WideString; 
                            const pPassword: WideString): LongWord; safecall;
    function DSR_DeleteUser(const pUserLogin: WideString): LongWord; safecall;
    function DSR_GetUsers(out pUsers: OleVariant): LongWord; safecall;
    function DSR_AddNewContact(const pContactName: WideString; const pContactMail: WideString; 
                               pContactCompany: LongWord): LongWord; safecall;
    function DSR_DeleteContact(const pContactMail: WideString): LongWord; safecall;
    function DSR_GetContacts(out pContacts: OleVariant): LongWord; safecall;
    function DSR_UpdateUserRule(const pUserLogin: WideString; pRule: Word; pActive: Shortint): LongWord; safecall;
    function DSR_UpdateDSRSettings(const pXml: WideString): LongWord; safecall;
    function DSR_UpdateMailSettings(const pXml: WideString): LongWord; safecall;
    function DSR_SyncRequest(pCompany: LongWord; const pSubj: WideString; const pFrom: WideString; 
                             const pTo: WideString; const pParam1: WideString; 
                             const pParam2: WideString): LongWord; safecall;
    function DSR_ReCreateCompany(pCompany: LongWord): LongWord; safecall;
    function DSR_GetDsrSettings(out pXml: WideString): LongWord; safecall;
    function DSR_GetMailSettings(out pXml: WideString): LongWord; safecall;
    function DSR_CheckCompanies: LongWord; safecall;
    function DSR_CheckMailNow: LongWord; safecall;
    function DSR_CheckDripFeed(pCompany: LongWord; out pStatus: LongWord): LongWord; safecall;
    function DSR_RemoveDripFeed(pCompany: LongWord; const pFrom: WideString; const pTo: WideString; 
                                const pSubject: WideString): LongWord; safecall;
    function DSR_SetAdminPassword(const pAdminPass: WideString): LongWord; safecall;
    function DSR_GetDripFeedParams(pCompany: LongWord; out pPeriodYear1: WideString; 
                                   out pPeriodYear2: WideString): LongWord; safecall;
    function DSR_DeactivateCompany(pCompany: LongWord): LongWord; safecall;
    function DSR_ActivateCompany(pCompany: LongWord): LongWord; safecall;
    function Get_DSR_Version: WideString; safecall;
    function DSR_Sync(pCompany: LongWord; const pSubj: WideString; const pFrom: WideString; 
                      const pTo: WideString; const pParam1: WideString; const pParam2: WideString; 
                      pPackageId: LongWord): LongWord; safecall;
    function DSR_IsVAO: LongWord; safecall;
    function DSR_ExProductType: LongWord; safecall;
    function DSR_GetInboxXml(pGuid: TGUID; pOrder: LongWord; out pXml: WideString): LongWord; safecall;
    function DSR_GetOutboxXml(pGuid: TGUID; pOrder: LongWord; out pXml: WideString): LongWord; safecall;
    function DSR_ViewCISResponse(pOutboxGuid: TGUID; pFileGuid: TGUID; out pXml: WideString): LongWord; safecall;
    function DSR_GetExPeriodYear(pCompany: LongWord; out pPeriodYear1: WideString; 
                                 out pPeriodYear2: WideString): LongWord; safecall;
    function DSR_DenySyncRequest(pCompany: LongWord; pGuid: TGUID): LongWord; safecall;
    function DSR_CancelDripfeed(pCompany: LongWord; const pFrom: WideString; const pTo: WideString; 
                                const pSubject: WideString): LongWord; safecall;
    function DSR_RestoreMessage(pGuid: TGUID): LongWord; safecall;
    function DSR_ViewVAT100Response(pOutboxGuid: TGUID; pFileGuid: TGUID; out pXml: WideString): LongWord; safecall;
    property DSR_Version: WideString read Get_DSR_Version;
  end;

// *********************************************************************//
// DispIntf:  IDSRSERVERDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {61BFF091-15C9-4394-A26D-2D94A6F542F3}
// *********************************************************************//
  IDSRSERVERDisp = dispinterface
    ['{61BFF091-15C9-4394-A26D-2D94A6F542F3}']
    function DSR_Export(pCompany: LongWord; const pSubj: WideString; const pFrom: WideString; 
                        const pTo: WideString; const pParam1: WideString; 
                        const pParam2: WideString; pPackageId: LongWord): LongWord; dispid 0;
    function DSR_Import(pCompany: LongWord; pGuid: {??TGUID}OleVariant; pPackageId: LongWord): LongWord; dispid 2;
    function DSR_DeleteInboxMessage(pCompany: LongWord; pGuid: {??TGUID}OleVariant): LongWord; dispid 8;
    function DSR_DeleteOutboxMessage(pCompany: LongWord; pGuid: {??TGUID}OleVariant): LongWord; dispid 9;
    function DSR_TotalOutboxMessages(pCompany: LongWord; out pMsgCount: LongWord): LongWord; dispid 15;
    function DSR_TranslateErrorCode(pErrorCode: LongWord): WideString; dispid 17;
    function DSR_DeleteCompany(pCompany: LongWord): LongWord; dispid 20;
    procedure DSR_SendLog(const pMail: WideString); dispid 21;
    function DSR_ResendOutboxMessage(pGuid: {??TGUID}OleVariant): LongWord; dispid 23;
    function DSR_GetImportPackages(out pPackage: OleVariant): LongWord; dispid 25;
    function DSR_GetExportPackages(out pPackage: OleVariant): LongWord; dispid 26;
    function DSR_GetOutboxMessages(pCompany: LongWord; pPackageId: LongWord; 
                                   pStatus: {??Shortint}OleVariant; pDate: TDateTime; 
                                   pMaxRecords: LongWord; out pMessages: OleVariant): LongWord; dispid 27;
    function DSR_GetInboxMessages(pCompany: LongWord; pPackageId: LongWord; 
                                  pStatus: {??Shortint}OleVariant; pDate: TDateTime; 
                                  pMaxRecords: LongWord; out pMessages: OleVariant): LongWord; dispid 30;
    function DSR_NewInboxMessage(pMaxRecords: LongWord; out pMessages: OleVariant): LongWord; dispid 31;
    function DSR_GetCompanies(out pCompany: OleVariant): LongWord; dispid 10;
    function DSR_DeleteSchedule(pGuid: {??TGUID}OleVariant): LongWord; dispid 1;
    function DSR_SetDailySchedule(pGuid: {??TGUID}OleVariant; pCompany: LongWord; 
                                  const pSubj: WideString; const pFrom: WideString; 
                                  const pTo: WideString; const pParam1: WideString; 
                                  const pParam2: WideString; pPackageId: LongWord; 
                                  pStartDate: TDateTime; pEndDate: TDateTime; 
                                  pStartTime: TDateTime; pAllDays: {??Shortint}OleVariant; 
                                  pWeekDays: {??Shortint}OleVariant; 
                                  pEveryDay: {??Shortint}OleVariant): LongWord; dispid 11;
    function DSR_BulkExport(pCompany: LongWord; const pSubj: WideString; const pFrom: WideString; 
                            const pTo: WideString; const pParam1: WideString; 
                            const pParam2: WideString): LongWord; dispid 6;
    function DSR_CreateCompany(const pDescription: WideString; const pCode: WideString): LongWord; dispid 7;
    function DSR_Alive: LongWord; dispid 16;
    function DSR_AddNewUser(const pUserName: WideString; const pUserLogin: WideString; 
                            const pPassword: WideString): LongWord; dispid 19;
    function DSR_DeleteUser(const pUserLogin: WideString): LongWord; dispid 22;
    function DSR_GetUsers(out pUsers: OleVariant): LongWord; dispid 24;
    function DSR_AddNewContact(const pContactName: WideString; const pContactMail: WideString; 
                               pContactCompany: LongWord): LongWord; dispid 33;
    function DSR_DeleteContact(const pContactMail: WideString): LongWord; dispid 34;
    function DSR_GetContacts(out pContacts: OleVariant): LongWord; dispid 35;
    function DSR_UpdateUserRule(const pUserLogin: WideString; pRule: {??Word}OleVariant; 
                                pActive: {??Shortint}OleVariant): LongWord; dispid 36;
    function DSR_UpdateDSRSettings(const pXml: WideString): LongWord; dispid 37;
    function DSR_UpdateMailSettings(const pXml: WideString): LongWord; dispid 38;
    function DSR_SyncRequest(pCompany: LongWord; const pSubj: WideString; const pFrom: WideString; 
                             const pTo: WideString; const pParam1: WideString; 
                             const pParam2: WideString): LongWord; dispid 3;
    function DSR_ReCreateCompany(pCompany: LongWord): LongWord; dispid 4;
    function DSR_GetDsrSettings(out pXml: WideString): LongWord; dispid 5;
    function DSR_GetMailSettings(out pXml: WideString): LongWord; dispid 12;
    function DSR_CheckCompanies: LongWord; dispid 13;
    function DSR_CheckMailNow: LongWord; dispid 14;
    function DSR_CheckDripFeed(pCompany: LongWord; out pStatus: LongWord): LongWord; dispid 18;
    function DSR_RemoveDripFeed(pCompany: LongWord; const pFrom: WideString; const pTo: WideString; 
                                const pSubject: WideString): LongWord; dispid 28;
    function DSR_SetAdminPassword(const pAdminPass: WideString): LongWord; dispid 39;
    function DSR_GetDripFeedParams(pCompany: LongWord; out pPeriodYear1: WideString; 
                                   out pPeriodYear2: WideString): LongWord; dispid 29;
    function DSR_DeactivateCompany(pCompany: LongWord): LongWord; dispid 32;
    function DSR_ActivateCompany(pCompany: LongWord): LongWord; dispid 40;
    property DSR_Version: WideString readonly dispid 43;
    function DSR_Sync(pCompany: LongWord; const pSubj: WideString; const pFrom: WideString; 
                      const pTo: WideString; const pParam1: WideString; const pParam2: WideString; 
                      pPackageId: LongWord): LongWord; dispid 41;
    function DSR_IsVAO: LongWord; dispid 42;
    function DSR_ExProductType: LongWord; dispid 44;
    function DSR_GetInboxXml(pGuid: {??TGUID}OleVariant; pOrder: LongWord; out pXml: WideString): LongWord; dispid 45;
    function DSR_GetOutboxXml(pGuid: {??TGUID}OleVariant; pOrder: LongWord; out pXml: WideString): LongWord; dispid 46;
    function DSR_ViewCISResponse(pOutboxGuid: {??TGUID}OleVariant; pFileGuid: {??TGUID}OleVariant; 
                                 out pXml: WideString): LongWord; dispid 48;
    function DSR_GetExPeriodYear(pCompany: LongWord; out pPeriodYear1: WideString; 
                                 out pPeriodYear2: WideString): LongWord; dispid 47;
    function DSR_DenySyncRequest(pCompany: LongWord; pGuid: {??TGUID}OleVariant): LongWord; dispid 49;
    function DSR_CancelDripfeed(pCompany: LongWord; const pFrom: WideString; const pTo: WideString; 
                                const pSubject: WideString): LongWord; dispid 50;
    function DSR_RestoreMessage(pGuid: {??TGUID}OleVariant): LongWord; dispid 51;
    function DSR_ViewVAT100Response(pOutboxGuid: {??TGUID}OleVariant; 
                                    pFileGuid: {??TGUID}OleVariant; out pXml: WideString): LongWord; dispid 52;
  end;

// *********************************************************************//
// DispIntf:  IDSRSERVEREvents
// Flags:     (4096) Dispatchable
// GUID:      {D916A6E4-46E0-4D5D-8CB2-C7152F507C78}
// *********************************************************************//
  IDSRSERVEREvents = dispinterface
    ['{D916A6E4-46E0-4D5D-8CB2-C7152F507C78}']
  end;

// *********************************************************************//
// The Class CoDSRSERVER provides a Create and CreateRemote method to          
// create instances of the default interface IDSRSERVER exposed by              
// the CoClass DSRSERVER. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDSRSERVER = class
    class function Create: IDSRSERVER;
    class function CreateRemote(const MachineName: string): IDSRSERVER;
  end;

implementation

uses ComObj;

class function CoDSRSERVER.Create: IDSRSERVER;
begin
  Result := CreateComObject(CLASS_DSRSERVER) as IDSRSERVER;
end;

class function CoDSRSERVER.CreateRemote(const MachineName: string): IDSRSERVER;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSRSERVER) as IDSRSERVER;
end;

end.
