{-----------------------------------------------------------------------------
 Unit Name: uDSR
 Author:    vmoura
 Purpose:
 History:

 client interface for WrapperDSRService

 , mtError, [mbok], 0);
-----------------------------------------------------------------------------}
Unit uDSR;

Interface

Uses Classes, Windows, SysUtils, Dialogs, RemotingClientLib_TLB
  ;

Const
  GENERIC_FAIL: LongWord = 10000;

Type
  TDSRError = Class(Exception)
  Private
    fErrorCode: Longword;
  Public
    Constructor Create(Const Msg: String; ErrorCode: Longword);
  Published
    Property ErrorCode: Longword Read fErrorCode Write fErrorCode;
  End;

  TDSRService = class(TDSRError);

  TDSR = Class
  Private
  Protected
  Public
    Class Function DSR_Export(Const MachineName: WideString; PortNumber:
      Integer; pCompany: LongWord; Const pSubj: WideString; Const pFrom:
      WideString; Const pTo: WideString; Const pParam1: WideString; Const
      pParam2: WideString; pPackageId: LongWord): LongWord;

    Class Function DSR_Sync(Const MachineName: WideString; PortNumber:
      Integer; pCompany: LongWord; Const pSubj: WideString; Const pFrom:
      WideString; Const pTo: WideString; Const pParam1: WideString; Const
      pParam2: WideString; pPackageId: LongWord): LongWord;

    Class Function DSR_Import(Const MachineName: WideString; PortNumber:
      Integer; pCompany: LongWord; pGuid: TGUID; pPackageId: LongWord):
      LongWord;

    Class Function DSR_DeleteInboxMessage(Const MachineName: WideString;
      PortNumber: Integer; pCompany: LongWord; pGuid: TGUID): LongWord;

    Class Function DSR_DeleteOutboxMessage(Const MachineName: WideString;
      PortNumber: Integer; pCompany: LongWord; pGuid: TGUID): LongWord;

    Class Function DSR_GetInboxMessages(Const MachineName: WideString;
      PortNumber: Integer; pCompany: LongWord; pPackageId: LongWord; pStatus:
      Shortint; pDate: TDateTime; pMaxRecords: LongWord; Out pMessages:
      OleVariant): LongWord;

    Class Function DSR_GetOutboxMessages(Const MachineName: WideString;
      PortNumber: Integer; pCompany: LongWord; pPackageId: LongWord; pStatus:
      Shortint; pDate: TDateTime; pMaxRecords: LongWord; Out pMessages:
      OleVariant): LongWord;

    Class Function DSR_NewInboxMessage(Const MachineName: WideString;
      PortNumber: Integer; pMaxRecords: LongWord; Out pMessages: OleVariant):
      LongWord;

    Class Function DSR_TotalOutboxMessages(Const MachineName: WideString;
      PortNumber: Integer; pCompany: LongWord; Out pMsgCount: LongWord):
      LongWord;

    Class Function DSR_TranslateErrorCode(Const MachineName: WideString;
      PortNumber: Integer; pErrorCode: LongWord): WideString;

    Class Function DSR_ResendOutboxMessage(Const MachineName: WideString;
      PortNumber: Integer; pGuid: TGUID): LongWord;

    Class Function DSR_GetExportPackages(Const MachineName: WideString;
      PortNumber: Integer; Out pPackage: OleVariant): LongWord;

    Class Function DSR_GetImportPackages(Const MachineName: WideString;
      PortNumber: Integer; Out pPackage: OleVariant): LongWord;

    Class Procedure DSR_SendLog(Const MachineName: WideString; PortNumber:
      Integer; Const pMail: WideString);

    Class Function DSR_DeleteCompany(Const MachineName: WideString; PortNumber:
      Integer; pCompany: LongWord): LongWord;

    Class Function DSR_GetCompanies(Const MachineName: WideString; PortNumber:
      Integer; Out pCompany: OleVariant): LongWord;

    Class Function DSR_DeleteSchedule(Const MachineName: WideString; PortNumber:
      Integer; pGuid: TGUID): LongWord;

    Class Function DSR_SetDailySchedule(Const MachineName: WideString;
      PortNumber: Integer; pGuid: TGuid; pCompany: LongWord; Const pSubj:
      WideString; Const pFrom: WideString; Const pTo: WideString;
      Const pParam1: WideString; Const pParam2: WideString;
      pPackageId: LongWord; pStartDate: TDateTime; pEndDate: TDateTime;
      pStartTime: TDateTime; pAllDays: Shortint; pWeekDays: Shortint;
      pEveryDay: Shortint): LongWord;

    Class Function DSR_BulkExport(Const MachineName: WideString; PortNumber:
      Integer; pCompany: LongWord; Const pSubj: WideString;
      Const pFrom: WideString; Const pTo: WideString; Const pParam1: WideString;
      Const pParam2: WideString): LongWord;

    Class Function DSR_SyncRequest(Const MachineName: WideString;
      PortNumber: Integer; pCompany: LongWord; Const pSubj, pFrom, pTo, pParam1,
      pParam2: WideString): LongWord;

    Class Function DSR_CreateCompany(Const MachineName: WideString; PortNumber:
      Integer; Const pCompanyName, pCompanyCode: Widestring): Longword;

    Class Function DSR_ReCreateCompany(Const MachineName: WideString;
      PortNumber: Integer; pCompany: Longword): Longword;

    Class Function DSR_AddNewUser(Const MachineName: WideString; PortNumber:
      Integer; Const pUserName, pUserLogin, pUserPassword: WideString):
      Longword;

    Class Function DSR_DeleteUser(Const MachineName: WideString; PortNumber:
      Integer; Const pUserLogin: WideString): Longword;

    Class Function DSR_GetUsers(Const MachineName: WideString; PortNumber:
      Integer; Out pUsers: OleVariant): LongWord;

    Class Function DSR_GetContacts(Const MachineName: WideString; PortNumber:
      Integer; Out pContacts: OleVariant): LongWord;

    Class Function DSR_DeleteContact(Const MachineName: WideString; PortNumber:
      Integer; Const pContactMail: Widestring): LongWord;

    Class Function DSR_AddNewContact(Const MachineName: WideString; PortNumber:
      Integer; Const pContactName, pContatMail: WideString; pContactCompany:
      Longword): LongWord;

    Class Function DSR_UpdateDSRSettings(Const MachineName: WideString;
      PortNumber: Integer; Const pXml: WideString): LongWord;

    Class Function DSR_UpdateMailSettings(Const MachineName: WideString;
      PortNumber: Integer; Const pXml: WideString): LongWord;

    Class Function DSR_GetDsrSettings(Const MachineName: WideString; PortNumber:
      Integer; Out pXml: WideString): LongWord;

    Class Function DSR_GetMailSettings(Const MachineName: WideString;
      PortNumber: Integer; Out pXml: WideString): LongWord;

    Class Function DSR_Alive(Const MachineName: WideString; PortNumber:
      Integer): Longword;

    Class Function DSR_CheckCompanies(Const MachineName: WideString; PortNumber:
      Integer): Longword;

    Class Function DSR_CheckMailNow(Const MachineName: WideString; PortNumber:
      Integer): Longword;

    Class Function DSR_CheckDripFeed(Const MachineName: WideString; PortNumber:
      Integer; pCompany: LongWord; Out pStatus: LongWord): LongWord;

    Class Function DSR_RemoveDripFeed(Const MachineName: WideString; PortNumber:
      Integer; pCompany: LongWord; Const pFrom, pTo, pSubject: WideString):
      LongWord;

    Class Function DSR_CancelDripfeed(Const MachineName: WideString; PortNumber:
      Integer;
      pCompany: LongWord; Const pFrom: WideString; Const pTo: WideString;
      Const pSubject: WideString): LongWord;

    Class Function DSR_SetAdminPassword(Const MachineName: WideString;
      PortNumber: Integer; Const pAdminPass: WideString): LongWord;

    Class Function DSR_GetDripFeedParams(Const MachineName: WideString;
      PortNumber: Integer; pCompany: LongWord; Out pPeriodYear1: WideString;
      Out pPeriodYear2: WideString): LongWord;

    Class Function DSR_DeactivateCompany(Const MachineName: WideString;
      PortNumber: Integer; pCompany: LongWord): LongWord;

    Class Function DSR_ActivateCompany(Const MachineName: WideString;
      PortNumber: Integer; pCompany: LongWord): LongWord;

    Class Function DSR_Version(Const MachineName: WideString;
      PortNumber: Integer): WideString;

    Class Function DSR_IsVAO(Const MachineName: WideString; PortNumber:
      Integer): LongWord;

    Class Function DSR_ExProductType(Const MachineName: WideString; PortNumber:
      Integer): LongWord;

    Class Function DSR_GetInboxXml(Const MachineName: WideString; PortNumber:
      Integer; pGuid: TGUID; pOrder: LongWord; Out pXml: WideString): LongWord;

    Class Function DSR_GetOutboxXml(Const MachineName: WideString; PortNumber:
      Integer; pGuid: TGUID; pOrder: LongWord; Out pXml: WideString): LongWord;

    Class Function DSR_ViewCISResponse(Const MachineName: WideString;
      PortNumber: Integer; pOutboxGuid, pFileGuid: TGUID; Out pXml: WideString):
      LongWord;

    // 24/06/2013. PKR. Added support for VAT 100 XML.
    Class Function DSR_ViewVAT100Response(Const MachineName: WideString;
      PortNumber: Integer; pOutboxGuid, pFileGuid: TGUID; Out pXml: WideString):
      LongWord;

    Class Function DSR_GetExPeriodYear(Const MachineName: WideString;
      PortNumber: Integer; pCompany: LongWord; Out pPeriodYear1: WideString;
      Out pPeriodYear2: WideString): LongWord;

    Class Function DSR_DenySyncRequest(Const MachineName: WideString; PortNumber:
      Integer; pCompany: LongWord; pGuid: TGUID): LongWord;

    Class Function DSR_RestoreMessage(Const MachineName: WideString; PortNumber:
      Integer; pGuid: TGUID): LongWord;

  End;

Function CreateDSR: IDSRClient;

Implementation

Uses
  ImageHlp, uCommon, ComObj, strutils, Forms;

{ TDSR }

Function CreateDSR: IDSRClient;
Begin
  Result := Nil;

  // Create an instance of the remoting client object
  Try
    Result := CoDSRClient.Create() As IDSRClient;
  Except
    On E: exception Do
      _LogMSG('CreateDSR :- Error creating Service object. Error: ' + E.Message);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_Export
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_Export(Const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; Const pSubj, pFrom,
  pTo, pParam1, pParam2: WideString; pPackageId: LongWord): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_Export(MachineName, PortNumber, pCompany, pSubj,
      pFrom, pTo, pParam1, pParam2, pPackageId);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_Sync
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_Sync(Const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; Const pSubj, pFrom,
  pTo, pParam1, pParam2: WideString; pPackageId: LongWord): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR;

  Try
    Result := dsrCaller.DSR_Sync(MachineName, PortNumber, pCompany, pSubj,
      pFrom, pTo, pParam1, pParam2, pPackageId);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_TranslateErrorCode
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_TranslateErrorCode(Const MachineName: WideString;
  PortNumber: Integer; pErrorCode: LongWord): WideString;
Var
  dsrCaller: IDSRClient;
Begin
  Result := '';
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_TranslateErrorCode(MachineName, PortNumber,
      pErrorCode);
  Except
    On E: Exception Do
      _LogMSG('DSR_TranslateErrorCode :- An exception has occurred:' + E.Message);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetOutboxMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_GetOutboxMessages(Const MachineName: WideString;
  PortNumber: Integer; pCompany, pPackageId: LongWord; pStatus: Shortint;
  pDate: TDateTime; pMaxRecords: LongWord; Out pMessages: OleVariant): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_GetOutboxMessages(MachineName, PortNumber, pCompany,
      pPackageId, pStatus, pDate, pMaxRecords, pMessages);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_NewInboxMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_NewInboxMessage(Const MachineName: WideString;
  PortNumber: Integer; pMaxRecords: LongWord; Out pMessages: OleVariant):
  LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_NewInboxMessage(MachineName, PortNumber,
      pMaxRecords, pMessages);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetImportPackages
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_GetImportPackages(Const MachineName: WideString;
  PortNumber: Integer; Out pPackage: OleVariant): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_GetImportPackages(MachineName, PortNumber,
      pPackage);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetInboxMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_GetInboxMessages(Const MachineName: WideString;
  PortNumber: Integer; pCompany, pPackageId: LongWord; pStatus: Shortint;
  pDate: TDateTime; pMaxRecords: LongWord; Out pMessages: OleVariant): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_GetInboxMessages(MachineName, PortNumber, pCompany,
      pPackageId, pStatus, pDate, pMaxRecords, pMessages);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_Import
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_Import(Const MachineName: WideString; PortNumber:
  Integer; pCompany: LongWord; pGuid: TGUID; pPackageId: LongWord): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_Import(MachineName, PortNumber, pCompany, pGuid,
      pPackageId);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeleteOutboxMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_DeleteOutboxMessage(Const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; pGuid: TGUID): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_DeleteOutboxMessage(MachineName, PortNumber,
      pCompany, pGuid);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_ResendOutboxMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_ResendOutboxMessage(Const MachineName: WideString;
  PortNumber: Integer; pGuid: TGUID): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_ResendOutboxMessage(MachineName, PortNumber, pGuid);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeleteInboxMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_DeleteInboxMessage(Const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; pGuid: TGUID): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_DeleteInboxMessage(MachineName, PortNumber,
      pCompany, pGuid);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_TotalOutboxMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_TotalOutboxMessages(Const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; Out pMsgCount: LongWord): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_TotalOutboxMessages(MachineName, PortNumber,
      pCompany, pMsgCount);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetExportPackages
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_GetExportPackages(Const MachineName: WideString;
  PortNumber: Integer; Out pPackage: OleVariant): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_GetExportPackages(MachineName, PortNumber,
      pPackage);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetCompanies
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_GetCompanies(Const MachineName: WideString;
  PortNumber: Integer; Out pCompany: OleVariant): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_GetCompanies(MachineName, PortNumber, pCompany);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_SetDailySchedule
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_SetDailySchedule(Const MachineName: WideString;
  PortNumber: Integer; pGuid: TGuid; pCompany: LongWord; Const pSubj, pFrom,
  pTo, pParam1, pParam2: WideString; pPackageId: LongWord; pStartDate, pEndDate,
  pStartTime: TDateTime; pAllDays, pWeekDays, pEveryDay: Shortint): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_SetDailySchedule(MachineName, PortNumber, pGuid,
      pCompany, pSubj, pFrom, pTo, pParam1, pParam2, pPackageId, pStartDate,
      pEndDate, pStartTime, pAllDays, pWeekDays, pEveryDay);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeleteCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_DeleteCompany(Const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_DeleteCompany(MachineName, PortNumber, pCompany);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeleteSchedule
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_DeleteSchedule(Const MachineName: WideString;
  PortNumber: Integer; pGuid: TGUID): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_DeleteSchedule(MachineName, PortNumber, pGuid);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_SendLog
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Procedure TDSR.DSR_SendLog(Const MachineName: WideString;
  PortNumber: Integer; Const pMail: WideString);
Var
  dsrCaller: IDSRClient;
Begin
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    dsrCaller.DSR_SendLog(MachineName, PortNumber, pMail);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, GENERIC_FAIL);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_BulkExport
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_BulkExport(Const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; Const pSubj, pFrom, pTo, pParam1,
  pParam2: WideString): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_BulkExport(MachineName, PortNumber, pCompany, pSubj,
      pFrom, pTo, pParam1, pParam2);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_SyncRequest
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_SyncRequest(Const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; Const pSubj, pFrom, pTo, pParam1,
  pParam2: WideString): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    dsrCaller.DSR_SyncRequest(MachineName, PortNumber, pCompany, pSubj,
      pFrom, pTo, pParam1, pParam2);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_CreateCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_CreateCompany(Const MachineName: WideString; PortNumber:
  Integer; Const pCompanyName, pCompanyCode: Widestring): Longword;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_CreateCompany(MachineName, PortNumber, pCompanyName,
      pCompanyCode);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_ReCreateCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_ReCreateCompany(Const MachineName: WideString;
  PortNumber: Integer; pCompany: Longword): Longword;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_ReCreateCompany(MachineName, PortNumber, pCompany);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_AddNewUser
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_AddNewUser(Const MachineName: WideString; PortNumber:
  Integer; Const pUserName, pUserLogin, pUserPassword: WideString): Longword;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_AddNewUser(MachineName, PortNumber, pUserName,
      pUserLogin, pUserPassword);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeleteUser
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_DeleteUser(Const MachineName: WideString; PortNumber:
  Integer; Const pUserLogin: WideString): Longword;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_DeleteUser(MachineName, PortNumber, pUserLogin);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetUsers
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_GetUsers(Const MachineName: WideString; PortNumber:
  Integer; Out pUsers: OleVariant): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_GetUsers(MachineName, PortNumber, pUsers);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetContacts
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_GetContacts(Const MachineName: WideString; PortNumber:
  Integer; Out pContacts: OleVariant): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_GetContacts(MachineName, PortNumber, pContacts);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeleteContact
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_DeleteContact(Const MachineName: WideString; PortNumber:
  Integer; Const pContactMail: Widestring): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_DeleteContact(MachineName, PortNumber, pContactMail)
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_AddNewContact
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_AddNewContact(Const MachineName: WideString; PortNumber:
  Integer; Const pContactName, pContatMail: WideString; pContactCompany:
  Longword): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_AddNewContact(MachineName, PortNumber, pContactName,
      pContatMail, pContactCompany);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_UpdateDSRSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_UpdateDSRSettings(Const MachineName: WideString;
  PortNumber: Integer; Const pXml: WideString): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_UpdateDSRSettings(MachineName, PortNumber, pXml)
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_UpdateMailSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_UpdateMailSettings(Const MachineName: WideString;
  PortNumber: Integer; Const pXml: WideString): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_UpdateMailSettings(MachineName, PortNumber, pXml)
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetDsrSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_GetDsrSettings(Const MachineName: WideString;
  PortNumber: Integer; Out pXml: WideString): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_GetDsrSettings(MachineName, PortNumber, pXml)
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetMailSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_GetMailSettings(Const MachineName: WideString;
  PortNumber: Integer; Out pXml: WideString): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_GetMailSettings(MachineName, PortNumber, pXml)
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_Alive
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_Alive(Const MachineName: WideString; PortNumber:
  Integer): Longword;
Var
  //dsrCaller: IDSRClient;
  dsrCaller: TDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := Nil;

  Try
    Try
    //CreateComObject(CLASS_DSRClient) as IDSRClient

//    dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

    //dsrCaller := CreateOLEObject('RemotingClientLib.DSRClient') As IDSRClient;
      dsrCaller := TDSRClient.Create(Nil);
    Except
      On E: exception Do
      Begin
        _LogMSG('DSR_Alive :- Error Client Sync Service Object. Error: ' +
          E.Message);
        _LogMSG('DSR_Alive :- Machine ' + MachineName + ' Port: ' +
          inttostr(PortNumber));
      End; {begin}
    End; {try}

  {just checking the connection. no message is needed}
    Try
      If Assigned(dsrCaller) And Not Application.Terminated Then
      begin
        Result := dsrCaller.DSR_Alive(MachineName, PortNumber);
      end;
    Except
      On E: exception Do
      Begin
        _LogMSG('DSR_Alive :- Error checking Service. Error: ' + E.Message);
        _LogMSG('DSR_Alive :- Machine ' + MachineName + ' Port: ' +
          inttostr(PortNumber));
        Raise TDSRError.Create(E.Message, Result);
      End; {begin}
    End; {try}
  Finally
    If Assigned(dsrCaller) Then
      dsrCaller.Free;
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_CheckCompanies
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_CheckCompanies(Const MachineName: WideString;
  PortNumber: Integer): Longword;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_CheckCompanies(MachineName, PortNumber);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_CheckMailNow
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_CheckMailNow(Const MachineName: WideString; PortNumber:
  Integer): Longword;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_CheckMailNow(MachineName, PortNumber);
  Except
    On E: Exception Do
    Begin
      _LogMSG('DSR_CheckMailNow :- An exception has occurred:' + E.Message);
//      Raise TDSRError.Create(E.message, Result);
      raise TDSRService.Create(E.Message, Result);
    End; {begin}
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_CheckDripFeed
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_CheckDripFeed(Const MachineName: WideString; PortNumber:
  Integer; pCompany: LongWord; Out pStatus: LongWord): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_CheckDripFeed(MachineName, PortNumber, pCompany,
      pStatus);
  Except
    On E: Exception Do
    Begin
      _LogMSG('DSR_CheckDripFeed :- An exception has occurred:' + E.Message);
      Raise TDSRError.Create(E.message, Result);
    End; {begin}
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_RemoveDripFeed
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_RemoveDripFeed(Const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; Const pFrom, pTo, pSubject:
  WideString): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_RemoveDripFeed(MachineName, PortNumber, pCompany,
      pFrom, pTo, pSubject);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

Class Function TDSR.DSR_CancelDripfeed(Const MachineName: WideString; PortNumber:
  Integer;
  pCompany: LongWord; Const pFrom: WideString; Const pTo: WideString;
  Const pSubject: WideString): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_CancelDripfeed(MachineName, PortNumber, pCompany,
      pFrom, pTo, pSubject);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_SetAdminPassword
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_SetAdminPassword(Const MachineName: WideString;
  PortNumber: Integer; Const pAdminPass: WideString): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() As IDSRClient;

  Try
    Result := dsrCaller.DSR_SetAdminPassword(MachineName, PortNumber,
      pAdminPass);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetDripFeedParams
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_GetDripFeedParams(Const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; Out pPeriodYear1: WideString; Out
  pPeriodYear2: WideString): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() as IDSRClient;

  Try
    If Assigned(dsrCaller) And Not Application.Terminated Then
      Result := dsrCaller.DSR_GetDripFeedParams(MachineName, PortNumber, pCompany,
        pPeriodYear1, pPeriodYear2);
  Except
    On E: Exception Do
      _LogMSG('DSR_GetDripFeedParams :- An exception has occurred:' + E.Message);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeactivateCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_DeactivateCompany(Const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() as IDSRClient;

  Try
    Result := dsrCaller.DSR_DeactivateCompany(MachineName, PortNumber, pCompany);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_ActivateCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_ActivateCompany(Const MachineName: WideString;
  PortNumber:
  Integer; pCompany: LongWord): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  Result := GENERIC_FAIL;
  dsrCaller := CreateDSR; //CoDSRClient.Create() as IDSRClient;

  Try
    Result := dsrCaller.DSR_ActivateCompany(MachineName, PortNumber, pCompany);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, Result);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_Version
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_Version(Const MachineName: WideString;
  PortNumber: Integer): WideString;
Var
  dsrCaller: IDSRClient;
Begin
  Result := '';
  dsrCaller := CreateDSR; //CoDSRClient.Create() as IDSRClient;

  Try
    Result := dsrCaller.DSR_Version(MachineName, PortNumber);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, GENERIC_FAIL);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_IsVAO
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_IsVAO(Const MachineName: WideString; PortNumber:
  Integer): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  dsrCaller := CreateDSR; //CoDSRClient.Create() as IDSRClient;

  Try
    Result := dsrCaller.DSR_IsVAO(MachineName, PortNumber);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, GENERIC_FAIL);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_ExProductType
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_ExProductType(Const MachineName: WideString; PortNumber:
  Integer): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  dsrCaller := CreateDSR; //CoDSRClient.Create() as IDSRClient;

  Try
    Result := dsrCaller.DSR_ExProductType(MachineName, PortNumber)
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, GENERIC_FAIL);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetInboxXml
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_GetInboxXml(Const MachineName: WideString; PortNumber:
  Integer; pGuid: TGUID; pOrder: LongWord; Out pXml: WideString): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  dsrCaller := CreateDSR; //CoDSRClient.Create() as IDSRClient;

  Try
    Result := dsrCaller.DSR_GetInboxXml(MachineName, PortNumber, pGuid, pOrder,
      pXml);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, GENERIC_FAIL);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetOutboxXml
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_GetOutboxXml(Const MachineName: WideString; PortNumber:
  Integer; pGuid: TGUID; pOrder: LongWord; Out pXml: WideString): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  dsrCaller := CreateDSR; //CoDSRClient.Create() as IDSRClient;

  Try
    Result := dsrCaller.DSR_GetOutboxXml(MachineName, PortNumber, pGuid, pOrder,
      pXml);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, GENERIC_FAIL);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_ViewCISResponse
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_ViewCISResponse(Const MachineName: WideString;
  PortNumber: Integer; pOutboxGuid, pFileGuid: TGUID; Out pXml: WideString):
  LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  dsrCaller := CreateDSR; //CoDSRClient.Create() as IDSRClient;

  Try
    Result := dsrCaller.DSR_ViewCISResponse(MachineName, PortNumber, pOutboxGuid,
      pFileGuid, pXml);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, GENERIC_FAIL);
  End;
End;

//------------------------------------------------------------------------------
// Added for VAT 100 XML support.
// 
// Procedure: DSR_ViewVAT100Response
// Author:    Phil Rogers
//------------------------------------------------------------------------------
Class Function TDSR.DSR_ViewVAT100Response(Const MachineName: WideString;
  PortNumber: Integer; pOutboxGuid, pFileGuid: TGUID; Out pXml: WideString):
  LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  dsrCaller := CreateDSR; //CoDSRClient.Create() as IDSRClient;

  Try
    Result := dsrCaller.DSR_ViewVAT100Response(MachineName,
                                               PortNumber,
                                               pOutboxGuid,
                                               pFileGuid,
                                               pXml);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, GENERIC_FAIL);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetExPeriodYear
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_GetExPeriodYear(Const MachineName: WideString;
  PortNumber: Integer; pCompany: LongWord; Out pPeriodYear1: WideString;
  Out pPeriodYear2: WideString): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  dsrCaller := CreateDSR;

  Try
    Result := dsrCaller.DSR_GetExPeriodYear(MachineName, PortNumber, pCompany,
      pPeriodYear1, pPeriodYear2);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, GENERIC_FAIL);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DenySyncRequest
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSR.DSR_DenySyncRequest(Const MachineName: WideString; PortNumber:
  Integer; pCompany: LongWord; pGuid: TGUID): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  dsrCaller := CreateDSR;

  Try
    Result := dsrCaller.DSR_DenySyncRequest(MachineName, PortNumber, pCompany,
      pGuid);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, GENERIC_FAIL);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_RestoreMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
class function TDSR.DSR_RestoreMessage(const MachineName: WideString;
  PortNumber: Integer; pGuid: TGUID): LongWord;
Var
  dsrCaller: IDSRClient;
Begin
  dsrCaller := CreateDSR;

  Try
    Result := dsrCaller.DSR_RestoreMessage(MachineName, PortNumber, pGuid);
  Except On E: Exception Do
      Raise TDSRError.Create(E.message, GENERIC_FAIL);
  End;
end;


{ TDSRError }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRError.Create(Const Msg: String; ErrorCode: Longword);
Begin
  Inherited Create(Msg);
  fErrorCode := ErrorCode;
End;

End.

