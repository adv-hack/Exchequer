{-----------------------------------------------------------------------------
 Unit Name: uDSRSERVER
 Author:    vmoura
 Purpose:
 History:

                  _ Application
                 |  _ database
                 | |  _ file structure
                 | | |  _ xml changes
                 | | | |
                 | | | |
 initial version 0.0.0.0b > fixes

////////////////////////////////////////////////////////////////////////////////


 History:

 see uDashHistory.pas


There is a document explaining the functionalities and units of the DSR.

"X:\EXCHLITE\ICE\IceDocumentation\IRIS - DSR.DLL units and objects.doc"

  defines
  DEBUG = work in debug mode :)
  DELETEXML = if set, the export/import xmls will not be deleted and we can check that out

  history
         0.0.0.0k
           the checkmail thread is not a private object running since the beginning of
           the dll. Instead of it, the thread will be created every time user call for
           check mail. It gives to the dll less change of break the service if
           a access violation happen in the midle of something.

         0.0.0.0j
         ) ICE162-WJ
         ) ICE198-RH
         ) ICE100-WJ

         0.0.0.0i     03/10/2006
         1) ICE115-WJ Requested sync for period different to suggested. When going to run bulk export suggested periods displayed and not revised entered periods.
         2) ICE121-WJ Setup a scheduled dripfeed, only one line added to outbox even though run across multiple days. Should be one line added per day.
         3) Dripfeed is being applied as soon as a bulk is successfully exported
         4) ICE138-DR No indication that emails to Import from Practice have been successful or not.  Had to display the Event log to establish that an email had failed to send

  0.0.0.0h  01/09/2006
         1) ICE130-WJ TDSRMailPoll.ProcessFile:-[Invalid company while trying to remove Dripfeed mode or company already Out of Sync. Company: SYNC01
         2) ICE132-WJ When trying to End dripfeed on client, Dashboard hung with 'Invalid object or path -' message in lo
         3) ICE135-WJ When trying to set customer to dripfeed mode, 'Invalid object or path -' message in log and dripfeed no activated in Client version.

  0.0.0.0g  24/08/2006

         1) ICE100 Last Audit Date being set to todays date instead of the last day of the synced period.
         2) bulk exporting is controlled by dsr (20060823)
         3) ICE104 Unable to get Recreate Companies to work from History tab.
         4) ICE091 If a Sync Fails due to a Company Licence Exceeded, the customer sees this reason on their version. On the customer version should just same Sync Denied/Failed and not this reason.
            This is the correct behavior of the DSR

  0.0.0.0f   27/07/2006
         1) Sending and receiving messages are now com objects plug-ins.
            These COM plugins are GUID's registered via Config.
            Exchequer MAPI/SMTP/POP have their default values filled
         2) Importing is made by an external application called DSRImp.exe for
             better synchronization and error treating.
         3) fixing problem when loading XML's with UTF-8 default encoding characthers

  0.0.0.0e  10/07/2006
         1) ICE091 If a Sync Fails due to a Company Licence Exceeded, the customer sees this reason on their version. On the customer version should just same Sync Denied/Failed and not this reason.
                   That's is the correct behavior
         2) ICE090 If you deactivate a company, there is no way a reactivating it.
         3) ICE092 (Item updated/in observation) Sync Request Denied by deleting from Inbox. Unable to delete from Failed/Deleted Items

  0.0.0.0d  05/07/2006
         1) .Eml e-mails processing
         2) Added functions to change last audit date
         3) Added functions to retrieve the correct period/year using the last audit date
         4) ICE077 When you go to Sync from the Accountant Dashboard, the email address displayed is the Accountants and not the Clients
         5) ICE078 You have to stop and restart the ICE Service for Syncs to export
         6) ICE080 It is not possible to export from Period 01 to Period 13. The system thinks that Period 13 is invalid.
         7) ICE083 If you accept an Import for a company where the company code and name already exists in your company list, an error is returned in the log and the import fails.
         8) ICE086 Receiving 6 companies via email, service stopped after 3. Restarted service and then got an Invalid Pointer Operation
                   This item has been improved but more test/investigation is needed
         9) ICE087 Last Audited Date not being set on End Sync

   0.0.0.0d  27/06/2006
         1) ICE040 Set multiple companies to import sync request but one one company completed. All other companies showed as Populating Client
                [Thread added to create company. It will block any other attempt to run more than one company creation at any time]
         2) Added new guid security check when creating companies
         3) ICE048 Error 3's when exporting multiple companies from the same installation at the same time
         4) ICE049 Error 3's when importing multiple companies to the same installation at the same time

   0.0.0.0e 13/06/2006
         1) Mapi session was not been released after logon (new session)
         2) Memory leak->mapi component wasn't been freed and that was causing the problem with sessions
         3) ICE006 Changing the Polling Time does not appear to make any difference to the email polling (appears to be every 20 seconds)
         4) ICE016 When you add a new company via the Sync it is added into the root of the installation and not the new Companies Folder
         5) MapiEx -> saveAttachments bug fix -> when the filename was empty it was causing an access violation
         6) ICE044 When receiving a number of emails via Check Mail, the Dashboard goes into a Not Responding mode. Could a Receiving x of x, percentage bar or something like this be added to show that the Dashboard is doing something and not crashed.

  0.0.0.0.c 06/06/2006
         1) show the popmail internal errors
         2) add new property to delete (or not) non related dsr e-mails
         3) MAPI e-mails are now been retrieved from the server (no updates are needed using outlook)

  0.0.0.0.c 31/05/2006
         1) only two threads using fSync variable. TDSRProducer and TDSRSender.

  0.0.0.0c 26/05/2006
         1) change the inbox/outbox -> instead to delete, update to deleted status
         2) calling bulk export was setting the message status to failed

 Plugins Notes

   The plugins have the following structure:

[DllInfo]
Link= name of the file matching
Description=  description of the plugin
UserReference= an integer user reference
FileGUID=  guid of the dll
DLLType= type of plugin (E = export, I= import)

cDRIPFEED = 'Dripfeed' string must exist as string on cfg files



X:\ENTRPRSE\MULTCOMP
X:\ENTRPRSE\COMTK
X:\ENTRPRSE\DRILLDN

-----------------------------------------------------------------------------}
Unit uDSRSERVER;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, AxCtrls, DSR_TLB,

    (*uDSRExWatcher,*)

  { common units}
  uSystemConfig, uBaseClass, uDSRBaseThread, uADODSR, uDsrThreads, StdVcl

  ;

Const
  ThLimit = 200; { number of attempts to finish the thread }

Type
  TDSRSERVER = Class(TAutoObject, IConnectionPointContainer, IDSRSERVER)
  Private
    fDSRSender: TDSRSenderTh;
    fDSRProducer: TDSRProducer;

    //fDSRCheckMail: TDSRCheckMail;

    fDSRDripFeed: TDSRDripFeed;

    (*fExWatcher: TclExceptWatcher;*)

    { Private declarations }
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FEvents: IDSRSERVEREvents;
    { note: FEvents maintains a *single* event sink. For access to more
      than one event sink, use FConnectionPoint.SinkList, and iterate
      through the list of sinks. }

    fADODSR: TADODSR;
    fSystemConf: TSystemConf;
    fLog: _Base;

    fDSRId: Cardinal;

    Procedure FinishDSRThread(Var pThread: TDSRThread);
    Procedure CheckCompanies;
    Procedure CheckDSRThreads;

  Public
    Procedure Initialize; Override;
    Destructor Destroy; Override;
    Procedure AfterConstruction; Override;
  Protected

    Property ConnectionPoints: TConnectionPoints Read FConnectionPoints
      Implements IConnectionPointContainer;
    Procedure EventSinkChanged(Const EventSink: IUnknown); Override;
    Function DSR_Export(pCompany: LongWord; Const pSubj, pFrom, pTo, pParam1,
      pParam2: WideString; pPackageId: LongWord): LongWord; Safecall;
    Function DSR_Import(pCompany: LongWord; pGuid: TGUID; pPackageId: LongWord):
      LongWord; Safecall;

    Function DSR_DeleteInboxMessage(pCompany: LongWord; pGuid: TGUID): LongWord;
      Safecall;
    Function DSR_DeleteOutboxMessage(pCompany: LongWord; pGuid: TGUID):
      LongWord; Safecall;
    Function DSR_TotalOutboxMessages(pCompany: LongWord; Out pMsgCount:
      LongWord): LongWord; Safecall;
    Function DSR_TranslateErrorCode(pErrorCode: LongWord): WideString; Safecall;
    Function DSR_DeleteCompany(pCompany: LongWord): LongWord; Safecall;
    Procedure DSR_SendLog(Const pMail: WideString); Safecall;
    Function DSR_ResendOutboxMessage(pGuid: TGUID): LongWord; Safecall;
    Function DSR_GetImportPackages(Out pPackage: OleVariant): LongWord;
      Safecall;
    Function DSR_GetExportPackages(Out pPackage: OleVariant): LongWord;
      Safecall;
    Function DSR_GetOutboxMessages(pCompany, pPackageId: LongWord;
      pStatus: Shortint; pDate: TDateTime; pMaxRecords: LongWord;
      Out pMessages: OleVariant): LongWord; Safecall;
    Function DSR_GetInboxMessages(pCompany, pPackageId: LongWord;
      pStatus: Shortint; pDate: TDateTime; pMaxRecords: LongWord;
      Out pMessages: OleVariant): LongWord; Safecall;
    Function DSR_NewInboxMessage(pMaxRecords: LongWord; Out pMessages:
      OleVariant): LongWord; Safecall;
    Function DSR_GetCompanies(Out pCompany: OleVariant): LongWord; Safecall;
    Function DSR_DeleteSchedule(pGuid: TGUID): LongWord; Safecall;
    Function DSR_SetDailySchedule(pGuid: TGUID; pCompany: LongWord;
      Const pSubj, pFrom, pTo, pParam1, pParam2: WideString;
      pPackageId: LongWord; pStartDate, pEndDate, pStartTime: TDateTime;
      pAllDays, pWeekDays, pEveryDay: Shortint): LongWord; Safecall;
    Function DSR_BulkExport(pCompany: LongWord; Const pSubj, pFrom, pTo,
      pParam1, pParam2: WideString): LongWord; Safecall;
    Function DSR_CreateCompany(Const pDescription,
      pCode: WideString): LongWord; Safecall;
    Function DSR_Alive: LongWord; Safecall;
    Function DSR_AddNewContact(Const pContactName, pContactMail: WideString;
      pContactCompany: LongWord): LongWord; Safecall;
    Function DSR_AddNewUser(Const pUserName, pUserLogin,
      pPassword: WideString): LongWord; Safecall;
    Function DSR_DeleteContact(Const pContactMail: WideString): LongWord;
      Safecall;
    Function DSR_DeleteUser(Const pUserLogin: WideString): LongWord; Safecall;
    Function DSR_GetContacts(Out pContacts: OleVariant): LongWord; Safecall;
    Function DSR_GetUsers(Out pUsers: OleVariant): LongWord; Safecall;
    Function DSR_UpdateUserRule(Const pUserLogin: WideString; pRule: Word;
      pActive: Shortint): LongWord; Safecall;
    Function DSR_UpdateDSRSettings(Const pXml: WideString): LongWord; Safecall;
    Function DSR_UpdateMailSettings(Const pXml: WideString): LongWord;
      Safecall;
    Function DSR_SyncRequest(pCompany: LongWord; Const pSubj, pFrom, pTo,
      pParam1, pParam2: WideString): LongWord; Safecall;
    Function DSR_ReCreateCompany(pCompany: LongWord): LongWord; Safecall;
    Function DSR_GetDsrSettings(Out pXml: WideString): LongWord; Safecall;
    Function DSR_GetMailSettings(Out pXml: WideString): LongWord; Safecall;
    Function DSR_CheckCompanies: LongWord; Safecall;
    Function DSR_CheckMailNow: LongWord; Safecall;
    Function DSR_CheckDripFeed(pCompany: LongWord; Out pStatus: LongWord):
      LongWord; Safecall;
    Function DSR_RemoveDripFeed(pCompany: LongWord; Const pFrom, pTo,
      pSubject: WideString): LongWord; Safecall;
    Function DSR_SetAdminPassword(Const pAdminPass: WideString): LongWord;
      Safecall;
    Function DSR_GetDripFeedParams(pCompany: LongWord; Out pPeriodYear1,
      pPeriodYear2: WideString): LongWord; Safecall;
    Function DSR_DeactivateCompany(pCompany: LongWord): LongWord; Safecall;
    Function DSR_ActivateCompany(pCompany: LongWord): LongWord; Safecall;
    Function Get_DSR_Version: WideString; Safecall;
    Function DSR_Sync(pCompany: LongWord; Const pSubj, pFrom, pTo, pParam1,
      pParam2: WideString; pPackageId: LongWord): LongWord; Safecall;
    Function DSR_IsVAO: LongWord; Safecall;
    Function DSR_ExProductType: LongWord; Safecall;
    Function DSR_GetInboxXml(pGuid: TGUID; pOrder: LongWord; Out pXML:
      WideString): LongWord; Safecall;
    Function DSR_GetOutboxXml(pGuid: TGUID; pOrder: LongWord; Out pXML:
      WideString): LongWord; Safecall;
    Function DSR_ViewCISResponse(pOutboxGuid, pFileGuid: TGUID;
      Out pXml: WideString): LongWord; Safecall;

    // 24/06/2013. PKR. Added VAT 100 XML support
    Function DSR_ViewVAT100Response(pOutboxGuid, pFileGuid: TGUID;
                                    Out pXml: WideString): LongWord; Safecall;

    Function DSR_GetExPeriodYear(pCompany: LongWord; Out pPeriodYear1,
      pPeriodYear2: WideString): LongWord; Safecall;
    Function DSR_DenySyncRequest(pCompany: LongWord; pGuid: TGUID): LongWord;
      Safecall;
    Function DSR_CancelDripfeed(pCompany: LongWord; Const pFrom, pTo,
      pSubject: WideString): LongWord; Safecall;
    Function DSR_RestoreMessage(pGuid: TGUID): LongWord; Safecall;

////////////////////////////////////////////////////////////////////////////////

  End;

Implementation

Uses ComServ, Variants, Math, Dateutils, Classes, Windows, Sysutils,
  uDSRGlobal, uDSRLock, uExFunc, uInterfaces, uDSRDeleteDir, uDSRFileFunc,
  uCommon, uMCM, uDSRMail, uConsts, EntLicence, uDSRHistory, uWrapperDSRSettings
  ;

{-----------------------------------------------------------------------------
  Procedure: EventSinkChanged
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRSERVER.EventSinkChanged(Const EventSink: IUnknown);
Begin
  FEvents := EventSink As IDSRSERVEREvents;
End;

{-----------------------------------------------------------------------------
  Procedure: Initialize
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRSERVER.Initialize;
Begin
  Inherited Initialize;

  FConnectionPoints := TConnectionPoints.Create(Self);
  If AutoFactory.EventTypeInfo <> Nil Then
  Begin
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckSingle, EventConnect);
  End
  Else
    FConnectionPoint := Nil;

  CoInitialize(Nil);

  (*fExWatcher:= TclExceptWatcher.Create(nil);*)

  {create/get an identifier for this dll}
  _logMsg('***** Service Start *****');
  Sleep(10);
  fDSRId := GetTickCount;
  _logMsg('***** Service ID ' + inttostr(fDSRId) + ' *****');

{$IFDEF DEBUG}
  _logMsg('***** DEBUG MODE *****');
  _logMsg('Service Producer polling time (msec): ' + inttostr(cDSRPRODUCERINTERVAL));
  _logMsg('Service Check Mail polling time (msec): ' + inttostr(cDSRCHEKMAILINTERVAL));
  _logMsg('Service polling time (msec): ' +  inttostr(cDSRDRIPFEEDINTERVAL));
  _logMsg('Service Sender polling time (msec): ' + inttostr(cDSRINTERVAL));
{$ENDIF}

  _CallDebugLog('Creating config file');
  fSystemConf := TSystemConf.Create;

  _CallDebugLog('Creating locks and syncs');

  fLog := _Base.Create;
  fSync := TDSRSynchronizer.Create;
  fExpLock := TDSRSynchronizer.Create;

  {remove temp files}
  _DelDirFiles(fSystemConf.TempDir);
  _DelDir(fSystemConf.TempDir);

  Try
    _logMsg('Service Version ' + CommonBit + cDSRBUILD);
  except
    on e:exception do
    begin
      _logMsg('Error loading Version. Error: ' + e.Message);
    end;
  end;

  If (_FileSize(_GetApplicationPath + cDSRINI) > 0) And (fSystemConf.DBServer <> '')
    Then
    _logMsg('Service config file found and database server is ' + fSystemConf.DBServer)
  Else
  Begin
    _logMsg('The Service config file not found or dbserver not set.');
    _logMsg('The Service is setting the database server to local machine');
    //_DSRSetDBServer(_GetComputerName);
    fSystemConf.DBServer := _GetComputerName;
  End;

  _logMsg('The Service Inbox Directory is ' + fSystemConf.InboxDir);
  _logMsg('The Service Outbox Directory is ' + fSystemConf.OutboxDir);
  _logMsg('The Service Plugins Directory is ' + fSystemConf.PluginsDir);
  _logMsg('The Service XML Directory is ' + fSystemConf.XMLDir);
  _logMsg('The Service XSD directory is ' + fSystemConf.XSDDir);
  _logMsg('The Service XSL Directory is ' + fSystemConf.XSLDir);
  _logMsg('The Service temp Directory is ' + fSystemConf.TempDir);

  // directories
  ForceDirectories(fSystemConf.InboxDir);
  ForceDirectories(fSystemConf.OutboxDir);
  ForceDirectories(fSystemConf.XMLDir);
  ForceDirectories(fSystemConf.XSDDir);
  ForceDirectories(fSystemConf.XSLDir);
  ForceDirectories(fSystemConf.PluginsDir);
  ForceDirectories(fSystemConf.TempDir);
  ForceDirectories(fSystemConf.EmailSystemDir);

  _CallDebugLog('Creating schedule list');
  { global schedule }
  fSchedule := TList.Create;

  Sleep(10);

  _CallDebugLog('Connecting Database...');
  Try
    fADODSR := TADODSR.Create(fSystemConf.DBServer, True);
  Except
    On E: Exception Do
      _LogMSG('Service database error: ' + E.MEssage);
  End;

  _CallDebugLog('Db object = ' + inttostr(ord(assigned(fadodsr))));
  _CallDebugLog('Db object = ' + inttostr(ord(assigned(fadodsr))));

  If Assigned(fADODSR) Then
  Begin
    _CallDebugLog('Reponding db connection');
    If fADODSR.Connected Then
    begin
      _LogMSG('Service Database ' + fSystemConf.DBServer + ' is connected')
    end
    Else
    begin
      _LogMSG('The Service Database ' + fSystemConf.DBServer + ' is not connected');
    end;

    { check if CIS, VAO are running. The reason for this two parameters being stored into the database
      is because when dashboard is loading, it has to hide some of the screen options
      before connecting to the dsr to check if it is one of these two...}

    fADODSR.SetSystemParameter(cISVAOPARAM, inttostr(Ord(_IsVAO)));

// CJS 2011-09-14 ABSEXCH-11871 - The DSR Server is now only used for CIS so
//                                the module check, _ExCISInstalled, has been
//                                removed.
// PKR 2013-06-24               - DSR now also used for VAT 100 and may be used
//                                for other HMRC/GovLink online functions in future.
//
{$IFDEF FORCECIS}
    fADODSR.SetSystemParameter(cISCISPARAM,
      inttostr(Ord(fSystemConf.UseCISSubsystem)));
{$ELSE}
_LogMsg('uDSRServer - SetSystemParameter - CISPARAM: ' + inttostr(Ord(fSystemConf.UseCISSubsystem)));
    fADODSR.SetSystemParameter(cISCISPARAM, inttostr(Ord(fSystemConf.UseCISSubsystem
      And _ExCISInstalled)));
{$ENDIF FORCECIS}

    fADODSR.SetSystemParameter(cEXPRODTYPEPARAM, inttostr(Ord(_ExProductType)));

_LogMsg('uDSRServer - GetSystemValue - CISPARAM: ' + fADODSR.GetSystemValue(cISCISPARAM));
    if fADODSR.GetSystemValue(cISCISPARAM) = '1' then
    begin
      {only cis default account should exist...}
       fADODSR.AddCISDefaultEmailAccount;

      _logMsg('The Service is using CIS Gateway...');

      if fADODSR.GetSystemValue(cUSECISTESTPARAM) = '1' then
        _logMsg('The Service is using CIS Test Gateway...')
      else
        _logMsg('The Service is using CIS Live Gateway...')
    end
    else // remove cis default account just in case it exists...
    begin
      fADODSR.RemoveCISDefaultAccount;
    end;

    //--------------------------------------------------------------------------
    // 24/06/2013. PKR. Added support for VAT 100 XML.
    // VAT 100 is available to everyone, so we don't need to check if it is installed.
    // VAT 100 default account should exist
    fADODSR.AddVAT100DefaultEmailAccount;

    _logMsg('The Service is using VAT 100 Gateway...');

    if fADODSR.GetSystemValue(cUSEVAT100TESTPARAM) = '1' then
    begin
      _logMsg('The Service is using VAT 100 Test Gateway...')
    end
    else
    begin
      _logMsg('The Service is using VAT 100 Live Gateway...')
    end;
    //--------------------------------------------------------------------------


    _CallDebugLog('Checking service status');

    If fADODSR.CheckServiceStatus Then
    begin
      _LogMSG('The SQL Server is running...')
    end
    Else
    begin
      _LogMSG('The SQL Server has not been started...');
    end;

    _LogMSG('The Service Database date format is: ' + fADODSR.DateFormat);

    _CallDebugLog('Deleting Ice Logs');
    fADODSR.DeleteIceDBLog;
    fLog.ConnectionString := fADODSR.ConnectionString;
    fADODSR.CheckScheduleTypes;

    _CallDebugLog('The Service is about to register plugins');

    If Not fADODSR.RegisterPlugins Then
    begin
      _LogMSG('Service Error registering plugins');
    end;

    If Not fADODSR.FindDripFeed and (fADODSR.GetSystemValue(cISCISPARAM) = '0') Then
    begin
      _LogMSG('There is no "Update Link" mode entry in the database. The application might not work properly.');
    end;

    fADODSR.RegisterEmailSystem;
  End
  Else
  begin
    _LogMSG('Service Database object not assigned.');
  end;

  _LogMSG('Service init section completed.');
End;

{-----------------------------------------------------------------------------
  Procedure: AfterConstruction
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRSERVER.AfterConstruction;
Var
  lXmlError: String;
  lTempGuid: TGuid;
Begin
  Inherited;

  lXmlError := _IsMSXMLAvaiable;

  {check if microsoft xml is installed}
  If lXmlError <> '' Then
    If fADODSR.Connected Then
      fLog.DoLogMessage('TDSRSERVER.AfterConstruction', cOBJECTNOTAVAILABLE,
        'The Microsoft XML is not available. Please re-run your Exchequer CD again or call for support...',
        True, True);

  {check database connection}
  If Not Assigned(fADODSr) Or (Assigned(fADODSr) And Not fADODSr.Connected) Then
    _LogMSG('The Database object is not connected. The service will stop due a failure connecting the database...');

  If Not Assigned(fADODSr) Or (Assigned(fADODSr) And Not fADODSr.Connected) Or
    (lXmlError <> '') Then
  Begin
    _ServiceStatus(cDSRSERVICE, '', False, True);
    {try again...}
    If _ServiceStatus(cDSRSERVICE, '', False) = $00000004 Then
      _ServiceStatus(cDSRSERVICE, '', False, True);
  End
  Else
  Begin
  {check the exchequer companies against the database. Deleted companies are going
  to receive an active parameter false }
    _CallDebugLog('DSR About to check companies');

    try
      CheckCompanies;
    except
      on E:exception do
      begin
        fLog.DoLogMessage('TDSRSERVER.AfterConstruction', cERROR,
          'An exception has just occurred. Error: ' + e.Message, True, True);
      end;
    end;

    CheckDSRThreads;

    {reset messages which doesnt finish download (temp e-mails) or are still in bulk process}
    If Assigned(fADODSr) And fADODSr.Connected Then
    Begin
      FillChar(lTempGuid, SizeOf(TGUID), 0);
      {get rid of bulk processing e-mail}
      If fADODSr.OutboxMessageStatusExists(0, cBULKPROCESSING) Then
        fADODSR.ChangeOutboxStatus(0, cBULKPROCESSING, cFAILED);

      {get rid of receiving data (with blank guid) e-mails}
      If fADODSr.InboxMessageStatusExists(0, cRECEIVINGDATA) Then
      Try
        fADODSr.UpdateInBox(lTempGuid, 0, '', '', '', 0, 0, 0, 0, dbDoDelete);
      Except
      End;

      {change loading files status}
      If fADODSr.InboxMessageStatusExists(0, cLOADINGFILES) Then
        fADODSR.ChangeInboxStatus(0, cLOADINGFILES, cFAILED);

      {something has hapenned to some files}
      If fADODSr.InboxMessageStatusExists(0, cCHECKING) Then
        fADODSR.ChangeInboxStatus(0, cCHECKING, cFAILED);

      If fADODSr.OutboxMessageStatusExists(0, cCHECKING) Then
        fADODSR.ChangeOutboxStatus(0, cCHECKING, cFAILED);

      {check if the sender is working first}
      If fADODSr.OutboxMessageStatusExists(0, cSENDING) Then
        fADODSr.ProcessOldOutboxMails;

    End; {If Assigned(fADODSr) And fADODSr.Connected Then}
  End; {begin}
End;

{-----------------------------------------------------------------------------
  Procedure: CheckDSRThreads
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRSERVER.CheckDSRThreads;
Begin
  _CallDebugLog('DSR Checking threads status');

(*  If Not Assigned(fDSRCheckMail) Or (Assigned(fDSRCheckMail) And Not
    fDSRCheckMail.Alive) Then
  Begin
    FinishDSRThread(TDSRThread(fDSRCheckMail));
    fDSRCheckMail := TDSRCheckMail.Create;
  End; {If Not Assigned(fDSRCheckMail) Or (Assigned(fDSRCheckMail) And Not fDSRCheckMail.Alive) Then}
*)

  If Not Assigned(fDSRSender) Or (Assigned(fDSRSender) And Not fDSRSender.Alive)
    Then
  Begin
    FinishDSRThread(TDSRThread(fDSRSender));
    fDSRSender := TDSRSenderTh.Create;
  End; {If Not Assigned(fDSRSender) Or (Assigned(fDSRSender) And Not fDSRSender.Alive) Then}

  If Not Assigned(fDSRProducer) Or (Assigned(fDSRProducer) And Not
    fDSRProducer.Alive) Then
  Begin
    FinishDSRThread(TDSRThread(fDSRProducer));
    fDSRProducer := TDSRProducer.Create;
  End; {If Not Assigned(fDSRProducer) Or (Assigned(fDSRProducer) And Not fDSRProducer.Alive) Then}

  If Assigned(fDSRSender) And fDSRSender.Suspended Then
    fDSRSender.Resume;

(*  If Assigned(fDSRCheckMail) And fDSRCheckMail.Suspended Then
    fDSRCheckMail.Resume;*)

  If Assigned(fDSRProducer) And fDSRProducer.Suspended Then
    fDSRProducer.Resume;

  If fSystemConf.AutomaticDripFeed Then
  Begin
    If Not Assigned(fDSRDripFeed) Or (Assigned(fDSRDripFeed) And Not
      fDSRDripFeed.Alive) Then
    Begin
      FinishDSRThread(TDSRThread(fDSRDripFeed));
      fDSRDripFeed := TDSRDripFeed.Create;
    End;

    If Assigned(fDSRDripFeed) And fDSRDripFeed.Suspended Then
      fDSRDripFeed.Resume;
  End; {If fSystemConf.AutomaticDripFeed Then}
End;

{-----------------------------------------------------------------------------
  Procedure: FinishDSRThread
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRSERVER.FinishDSRThread(Var pThread: TDSRThread);
Var
  lCont: integer;
Begin
  {terminate and wait the producer thread}
  If Assigned(pThread) Then
  Begin
    Try
      lCont := 0;
      If Not pThread.Terminated Then
        pThread.Terminate;

      Sleep(100);

      Repeat
        Sleep(10);
        inc(lCont);
      Until ((Not pThread.Working) And pThread.Terminated) Or (lCont = ThLimit);
    Except
    End; {If Assigned(fDSRProducer) Then}

    If pThread.Terminated And Not pThread.Alive Then
      pThread := Nil;
  End; {If Assigned(pThread) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRSERVER.Destroy;
Var
  lCont: Integer;
  lMsg: TMessageInfo;
Begin
  Sleep(10);
  _LogMSG('***** Attention *****');
  Sleep(50);
  _LogMSG('***** Service ID: ' + inttostr(fDSRId) + ' is about to finish *****');

  FinishDSRThread(TDSRThread(fDSRProducer));

//  FinishDSRThread(TDSRThread(fDSRCheckMail));

  FinishDSRThread(TDSRThread(fDSRSender));

  FinishDSRThread(TDSRThread(fDSRDripFeed));

  { clear the remaining objects from the list }
  With fSchedule Do
  Try
    For lCont := Count - 1 Downto 0 Do
      If Items[lCont] <> Nil Then
      Begin
        lMsg := TMessageInfo(Items[lCont]);
        If Assigned(lMsg) Then
          FreeandNil(lMsg);
        Delete(lCont);
      End;
  Except
  End; {With fSchedule Do}

  FreeAndNil(fSchedule);

  Try
    If Assigned(fADODSR) Then
      fADODSR.Free;
  Except
  End;

  _DelDirFiles(fSystemConf.TempDir);
  _DelDir(fSystemConf.TempDir);

  FreeAndNil(fSystemConf);
  FreeAndNil(fLog);
  FreeAndNil(fSync);
(*  FreeAndNil(fCompLock);
  FreeAndNil(fIMPLock);*)
  FreeAndNil(fEXPLock);
(*  FreeAndNil(fEmailLock);*)

  sleep(20);
  _LogMSG('***** End of the Service *****');

  {if for some reason the service is still running The DSR will try to finish the service
    so the user can take any action...}

(*  if Assigned(fExWatcher) then
    FreeAndNil(fExWatcher);*)

  {force the ending of the running service}
  _ServiceStatus(cDSRSERVICE, '', False, True);

  CoUninitialize;

  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_Export
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_Export(pCompany: LongWord; Const pSubj, pFrom, pTo,
  pParam1, pParam2: WideString; pPackageId: LongWord): LongWord;
var
  lMode: SmallInt;
  lParam1: String;
Begin
  Result := S_OK;

  {check mandatory fields}
  If _CheckParams([pCompany, pFrom, pSubj, pTo, pSubj]) Then
  Begin
    {look for a valid company}
    If fADODSR.SearchCompany(pCompany) Then
    Begin
      {if producer or sender are dead, start those threads}
      CheckDSRThreads;

      lParam1 := pParam1;

      if Lowercase(Trim(lParam1)) = Lowercase(Trim(cCISSUBCONTRACTOR)) then
      begin
        lMode := Ord(rmCIS);
        lParam1 := '';
      end
      else
        lMode := Ord(rmNormal);

      {create a new entry into the outbox table. this entry will be picked up
      later and processed with the dsrthreads}

      If Not fADODSR.UpdateOutBox(_CreateGuid, pCompany, pSubj, pFrom, pTo,
        pPackageId, 0, lParam1, pParam2, cSAVED, lMOde, dbDoAdd) Then
        Result := cDBERROR;
    End
    Else
      Result := cINVALIDPARAM;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_Ok Then
    fLog.DoLogMessage('TDSRSERVER.DSR_Export', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany) +
      ' Subject: ' + pSubj +
      ' From: ' + pFrom +
      ' To: ' + pTo, true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_BulkExport
  Author:    vmoura

  this function is going to start a bulk export reading the information from
   the ini file and sending all packages to the address provided
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_BulkExport(pCompany: LongWord; Const pSubj, pFrom,
  pTo, pParam1, pParam2: WideString): LongWord;
Var
  lMsg: TMessageInfo;
  lBulkTh: TDSRBulkTh;
Begin
  Result := S_OK;

  { check the params}
  If _CheckParams([pCompany, pFrom, pTo, pSubj]) Then
  Begin
    If fADODSR.SearchCompany(pCompany) Then
    Begin
      {create a temp mail message}
      lMsg := TMessageInfo.Create;
      With lMsg Do
      Begin
        Company_Id := pCompany;
        Subject := pSubj;
        From := pFrom;
        To_ := pTo;
        Guid := _CreateGuid;
        Param1 := pParam1;
        Param2 := pParam2;
        Mode := Ord(rmBulk);
      End; {With lMsg Do}

      {save the e-mail to allow the dashboard get this information and refresh the screen}
      With lMsg Do
        fADODSR.UpdateOutBox(Guid, Company_Id, Subject, From, To_, 0, 0,
          Param1, Param2, cPROCESSING, Mode,
          TDBOption(IfThen(fADODSR.SearchOutboxEntry(Guid) > 0,
          ord(dbDoUpdate), Ord(dbDoAdd))));

      lBulkTh := TDSRBulkTh.Create(lMsg);
      lBulkTh.Resume;

      Sleep(2);

      {bulk is going to create its own message}
      If Assigned(lMsg) Then
        FreeAndNil(lMsg);
    End
    Else
      Result := cINVALIDPARAM;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_BulkExport', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany) +
      ' From: ' + pFrom +
      ' To: ' + pTo +
      ' Subj: ' + pSubj, true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_Import
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_Import(pCompany: LongWord; pGuid: TGUID;
  pPackageId: LongWord): LongWord;
Var
  lExe: String;
Begin
  {the details is being get from the file itself}
  If _IsValidGuid(pGuid) Then
  Begin
    {update the database for dashboard issues}
    fADODSR.UpdateInBox(pGuid, pCompany, '', '', '', 0, 0, cPROCESSING, -1,
      dbDoUpdate);
    If fADODSR.GetInboxMessageStatus(pGuid) <> cPROCESSING Then
      fADODSR.SetInboxMessageStatus(pGuid, cPROCESSING);

    {create the import thread}
    lExe := _GetApplicationPath + cDSRIMP + ' ' + IntToStr(pCompany) + ' '
      + _SafeGuidtoString(pGuid) + ' ' + IntToStr(pPackageId);

    If _FileSize(_GetApplicationPath + cDSRIMP) > 0 Then
      _fileExec(lExe, True, False)
    Else
    Begin
      fADODSR.SetInboxMessageStatus(pGuid, cFAILED);
      Result := cFILENOTFOUND;
      fLog.DoLogMessage('TDSRSERVER.DSR_Import', Result,
        'The application ' + cDSRIMP + ' could not be found.', True, True);
    End;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_Import', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany) +
      ' E-Mail ID: ' + _SafeGuidtoString(pGuid), true, true
      );
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeleteInboxMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_DeleteInboxMessage(pCompany: LongWord; pGuid: TGUID):
  LongWord;
Var
  lMsg: TMessageInfo;
//  lSubj: String;
Begin
  Result := S_OK;

  If _IsValidGuid(pGuid) Then
  Begin
    lMsg := fADODSR.GetInboxMessage(pGuid);
    { delete or update this entry}
    If lMsg <> Nil Then
    Begin
        {if already a recycle then fisically delete this message, otherwise, just apply the status}
      If lMsg.Status In [cDELETED, cARCHIVED] Then
      Begin
        TDSRDeleteDir.Create(fSystemConf.InboxDir + GUIDToString(pGuid));
        fADODSR.UpdateInBox(pGuid, -1, '', '', '', 0, 0, 0, -1, dbDoDelete);

        {double check if that message still exists}
        If fADODSR.SearchInboxEntry(pGuid) > 0 Then
          fADODSR.UpdateInBox(pGuid, -1, '', '', '', 0, 0, 0, -1, dbDoDelete);

        If (lMsg.Mode In [Ord(rmBulk), Ord(rmDripFeed), Ord(rmSync)]) And
        (lMsg.TotalItens > 0) Then
          fLog.DoLogMessage('TDSRSERVER.DSR_DeleteInboxMessage', 0,
            'The message subject "' + lMsg.Subject + '" has been deleted...', true,
            true);

(*        {Send a message back to the client in case a bulk export or a dripfeed data has been deleted}
        If (lMsg.Status = cDELETED) And (lMsg.Mode In [Ord(rmBulk), Ord(rmDripFeed)])
        And (_ExProductType = ptLITEAcct) Then
        Begin
         {format the subject of the message just in case of the company name has not been filled}
          If trim(fSystemConf.CompanyName) <> '' Then
            lSubj := 'The message subject *' + lMsg.Subject + '* from "' +
              trim(fSystemConf.CompanyName) + '" has been deleted...'
          Else
            lSubj := 'The message subject *' + lMsg.Subject +
              '* has been deleted...';

          With fADODSR, TDSRMail Do
            If SendNACK(pGuid, lMsg.To_, lMsg.From, 1, cNACKSYNCDENIED,
              GetExCode(lMsg.Company_Id), GetCompanyGuid(lMsg.Company_Id), lSubj) =
                S_OK Then
              UpdateOutBox(_CreateGuid, lMsg.Company_Id,
                'Dripfeed Request Denied Acknowledge. Subject : ' +
                lMsg.Subject, lMsg.To_, lMsg.From, 0, 1, lMsg.Param1, lMsg.Param2,
                cSENT, Ord(rmNormal), dbDoAdd)
            Else
              fADODSR.UpdateOutBox(_CreateGuid, lMsg.Company_Id,
                'Dripfeed Request Denied Acknowledge. Subject : ' +
                lMsg.Subject, lMsg.To_, lMsg.From, 0, 1, lMsg.Param1, lMsg.Param2,
                cFAILED, Ord(rmNormal), dbDoAdd);
        End;*)
      End
      Else
      Begin
        fADODSR.UpdateInBox(pGuid, -1, '', '', '', 0, 0, cDELETED, -1, dbDoUpdate);

        {verify the status and give another try just in case something goes wrong}
        If fADODSR.GetInboxMessageStatus(pGuid) <> cDELETED Then
          fADODSR.SetInboxMessageStatus(pGuid, cDELETED);

        If (lMsg.Mode In [Ord(rmBulk), Ord(rmDripFeed), Ord(rmSync)]) And
        (lMsg.TotalItens > 0) Then
          fLog.DoLogMessage('TDSRSERVER.DSR_DeleteInboxMessage', 0,
            'The message subject "' + lMsg.Subject +
            '" has been marked as deleted...', true, true);
      End; {else begin}

      FreeAndNil(lMsg);
    End {if lMsg <> nil then}
    Else
      Result := cDBNORECORDFOUND;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_DeleteInboxMessage', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany) +
      ' E-Mail ID:' + _SafeGuidtoString(pGuid), true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeleteOutboxMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_DeleteOutboxMessage(pCompany: LongWord;
  pGuid: TGUID): LongWord;
Var
  lMsg: TMessageInfo;
Begin
  Result := S_OK;

  If _IsValidGuid(pGuid) Then
  Begin
      { delete the entry}
    lMsg := fADODSR.GetOutboxMessage(pGuid);

    If lMsg <> Nil Then
    Begin
       {if in "recycle" status, fisically delete this message, otherwise, just change the status}

      If lMsg.Status In [cDELETED, cARCHIVED] Then
      Begin
        {run up thread for deleting outbox entry directory}
        TDSRDeleteDir.Create(fSystemConf.OutboxDir + GUIDToString(pGuid));
        fADODSR.UpdateOutBox(pGuid, 0, '', '', '', 0, 0, '', '', 0, -1, dbDoDelete);

        {double check if that message still exists}
        If fADODSR.SearchOutboxEntry(pGuid) > 0 Then
          fADODSR.UpdateOutBox(pGuid, 0, '', '', '', 0, 0, '', '', 0, -1,
            dbDoDelete);

        If (lMsg.Mode In [Ord(rmBulk), Ord(rmSync), Ord(rmSync)]) And
        (lMSg.TotalItens > 0) Then
          fLog.DoLogMessage('TDSRSERVER.DSR_DeleteOutboxMessage', 0,
            'The message subject "' + lMsg.Subject + '" has been deleted...', true,
            true);
      End
      Else
      Begin
        {check if dsr lock file exists under this e-mail folder and if this message is bulk/dripfeed or if this message
        is under 24 hours, otherwise, this message can be deleted}
        If _CheckDSRLockFileExists(fSystemConf.OutboxDir + _SafeGuidtoString(pGuid))
          And (lMsg.Mode In [Ord(rmBulk), Ord(rmDripFeed)]) And (HoursBetween(Now,
          lMsg.Date) <= 24) And (lMsg.Status = cSENT) Then
        Begin
          Result := cMAILLOCKED;
          fLog.DoLogMessage('TDSRSERVER.DSR_DeleteOutboxMessage', Result,
            'The message subject: "' + lMsg.Subject + '" could not be deleted.',
            True, True);
        End
        Else
        Begin
          _DeleteDSRLockFile(fSystemConf.OutboxDir + _SafeGuidtoString(pGuid));
          fADODSR.UpdateOutBox(pGuid, 0, '', '', '', 0, 0, '', '', cDELETED, -1,
            dbDoUpdate);

        {double check message status}
          If fADODSR.GetOutboxMessageStatus(pGuid) <> cDELETED Then
            fADODSR.SetOutboxMessageStatus(pGuid, cDELETED);

          If (lMsg.Mode In [Ord(rmBulk), Ord(rmDripFeed), Ord(rmSync)]) And
          (lMSg.TotalItens > 0) Then
            fLog.DoLogMessage('TDSRSERVER.DSR_DeleteOutboxMessage', 0,
              'The message subject "' + lMsg.Subject +
              '" has been marked as deleted...', true, true);
        End; {else begin}
      End; {else begin}

      FreeAndNil(lMsg);
    End {if lMsg <> nil then}
    Else
      Result := cDBNORECORDFOUND;
  End
  Else
    Result := cINVALIDPARAM;

  fADODSR.CloseAndClearSql;

  If Result <> S_OK Then
    If Result <> cMAILLOCKED Then
      fLog.DoLogMessage('TDSRSERVER.DSR_DeleteOutboxMessage', Result,
        'Parameters :- ' +
        ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
        ' Code: ' + fADODSR.GetExCode(pCompany) +
        ' E-Mail ID:' + _SafeGuidtoString(pGuid), true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_TotalOutboxMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_TotalOutboxMessages(pCompany: LongWord;
  Out pMsgCount: LongWord): LongWord;
Begin
  pMsgCount := fADODSR.GetTotalOutboxMessages(pCompany);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_TranslateErrorCode
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_TranslateErrorCode(pErrorCode: LongWord): WideString;
Begin
  Result := _TranslateErrorCode(pErrorCode);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeleteCompany
  Author:    vmoura

  the function is going to delete all message and the company itself
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_DeleteCompany(pCompany: LongWord): LongWord;
Begin
  Result := S_OK;
  { test parameter}
  If pCompany > 0 Then
  Begin
    { search for the company}
    If fADODSR.SearchCompany(pCompany) Then
    Begin
     { I am assuming if something gets wrong, it is a sql error...}
      If Not fADODSR.DeleteCompany(pCompany, True, True) Then
        Result := cDBERROR;
    End
    Else
      Result := cDBNORECORDFOUND;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_DeleteCompany', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany),
      True, True);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_SendLog
  Author:    vmoura

  to be written
  the ideia is to be able to send the log file to exchequer in case of request
-----------------------------------------------------------------------------}
Procedure TDSRSERVER.DSR_SendLog(Const pMail: WideString);
(*Var
  lLogFile: String;*)
Begin
(*  Try
    lLogFile := _GetApplicationPath + cLogDir + '\' + FormatDateTime('yyyymmdd',
      Date) + cLogFileExt;
  Except
    lLogFile := '';
  End;

  If (lLogFile <> '') And (_FileSize(lLogFile) > 0) Then
  Begin

  End;*)
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_ResendOutboxMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_ResendOutboxMessage(pGuid: TGUID): LongWord;
Var
  lMsg: TMessageInfo;
Begin
  Result := S_OK;

  If _IsValidGuid(pGuid) Then
  Begin
    lMsg := fADODSR.GetOutboxMessage(pGuid);
    If lMsg <> Nil Then
    Begin
      {start resending thread... }
      With TDSRResendMessage.Create Do
      Begin
        Msg.Assign(lMsg);
        Resume;
      End; {with TDSRResendMessage.Create do}

      If Assigned(lMsg) Then
        FreeAndNil(lMsg);
    End
    Else
    Begin
      Result := cDBNORECORDFOUND;
      fLog.DoLogMessage('TDSRSERVER.DSR_ResendOutboxMessage', Result, '', True,
        True);
    End;
  End {If _IsValidGuid(pGuid) Then}
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    With fADODSR Do
      fLog.DoLogMessage('TDSRSERVER.DSR_ResendOutboxMessage', Result,
        'Parameters :- ' +
        ' Company: ' + GetCompanyDescription(GetOutboxCompanyId(pGuid))
        + ' Code: ' + GetExCode(GetOutboxCompanyId(pGuid)) +
        ' E-Mail ID:' + _SafeGuidtoString(pGuid),
        true, true);

  fADODSR.CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetImportPackages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_GetImportPackages(Out pPackage: OleVariant): LongWord;
Var
  lRecCount: Integer;
Begin
  Result := S_OK;
  pPackage := fADODSR.GetImportPackages;
  lRecCount := _GetOlevariantArraySize(pPackage);

  If lRecCount > 0 Then
  Begin
    If VarIsNull(pPackage) Then
    Begin
      Result := cERROR;
      fLog.DoLogMessage('TDSRSERVER.DSR_GetImportPackages', 0,
        'Error retrieving Import Packages...', true, true);
    End;
  End
  Else
    Result := cDBNORECORDFOUND;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetExportPackages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_GetExportPackages(Out pPackage: OleVariant): LongWord;
Var
  lRecCount: Integer;
Begin
  Result := S_OK;
  Try
    pPackage := fADODSR.GetExportPackages;
    lRecCount := _GetOlevariantArraySize(pPackage);
  Except
    pPackage := Null;
    lRecCount := 1;
  End;

  {check the result}
  If lRecCount > 0 Then
  Begin
    If VarIsNull(pPackage) Then
    Begin
      Result := cERROR;
      fLog.DoLogMessage('TDSRSERVER.DSR_GetExportPackages', 0,
        'Error retrieving Export Packages...', true, true);
    End;
  End
  Else
    Result := cDBNORECORDFOUND;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetOutboxMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_GetOutboxMessages(pCompany, pPackageId: LongWord;
  pStatus: Shortint; pDate: TDateTime; pMaxRecords: LongWord;
  Out pMessages: OleVariant): LongWord;
Begin
  If pCompany > 0 Then
  Begin
    pMessages := fADODSR.GetOutboxMessages(pCompany, pPackageId, pStatus, pDate,
      pMaxRecords, Result);
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_GetOutboxMessages', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany),
      true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetInboxMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_GetInboxMessages(pCompany, pPackageId: LongWord;
  pStatus: Shortint; pDate: TDateTime; pMaxRecords: LongWord;
  Out pMessages: OleVariant): LongWord;
Begin
  pMessages := fADODSR.GetInboxMessages(pCompany, pPackageId, pStatus, pDate,
    pMaxRecords, Result, False);

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_GetInboxMessage', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany),
      true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_NewInboxMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_NewInboxMessage(pMaxRecords: LongWord;
  Out pMessages: OleVariant): LongWord;
Begin
  pMessages := fADODSR.GetInboxMessages(0, 0, cALLNEW, 0, pMaxRecords,
    Result, False);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_GetCompanies(Out pCompany: OleVariant): LongWord;
Begin
  Result := S_OK;
  pCompany := fADODSR.GetCompanies;
  If VarIsNull(pCompany) Then
    Result := cDBNORECORDFOUND;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeleteSchedule
  Author:    vmoura

  delete a previous registered schedule
  the schedule tables are cascade delete.
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_DeleteSchedule(pGuid: TGUID): LongWord;
Begin
  Result := S_OK;
  If _IsValidGuid(pGuid) Then
  Begin
    If Not fADODSR.DeleteSchedule(pGuid) Then
      Result := cDBERROR;

    fADODSR.UpdateOutBox(pGuid, 0, '', '', '', 0, 0, '', '', cDELETED, -1,
      dbDoUpdate);
    fLog.DoLogMessage('TDSRSERVER.DSR_DeleteSchedule', 0,
      'The schedule has been removed.',
      True, True);
  End
  Else
    Result := cINVALIDPARAM;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_SetDailySchedule
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_SetDailySchedule(pGuid: TGUID; pCompany: LongWord;
  Const pSubj, pFrom, pTo, pParam1, pParam2: WideString;
  pPackageId: LongWord; pStartDate, pEndDate, pStartTime: TDateTime;
  pAllDays, pWeekDays, pEveryDay: Shortint): LongWord;
Var
  lGuid: TGuid;
Begin
  Result := S_OK;
  If _CheckParams([pCompany, pFrom, pSubj, pTo]) Then
  Begin
    {check the guid and the entry for a new entry or updating the schedule}
    If _IsValidGuid(pGuid) And (fADODSR.SearchOutboxEntry(pGuid) > 0) Then
    Begin
      _CallDebugLog('Updating schedule message...');
      lGuid := pGuid;
      {update existing msg and avoid to picked up by the producer}
      fADODSR.UpdateOutBox(lGuid, pCompany, pSubj, pFrom, pTo, pPackageID, 0,
        pParam1, pParam2, cPROCESSING, Ord(rmDripFeed), dbDoUpdate);
    End
    Else
    Begin
      _CallDebugLog('Adding new schedule message...');
      lGuid := _CreateGuid;
      {add a new record and avoid to picked up by the producer}
      fADODSR.UpdateOutBox(lGuid, pCompany, pSubj, pFrom, pTo, pPackageID, 0,
        pParam1, pParam2, cPROCESSING, Ord(rmDripFeed), dbDoAdd);
    End;

    If Not fADODSR.SetDaySchedule(lGuid, pStartDate, pEndDate, pStartTime,
      Boolean(pAllDays), Boolean(pWeekDays), pEveryDay) Then
      Result := cDBERROR;

      {change to the right status}
    If Result = S_OK Then
      fADODSR.UpdateOutBox(lGuid, pCompany, pSubj, pFrom, pTo, pPackageID, 0,
        pParam1, pParam2, cSAVED, Ord(rmDripFeed), dbDoUpdate)
    Else
      fADODSR.UpdateOutBox(lGuid, pCompany, pSubj, pFrom, pTo, pPackageID, 0,
        pParam1, pParam2, cFailed, Ord(rmDripFeed), dbDoUpdate)
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_SetDailySchedule', Result, '', true, True);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_CreateCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_CreateCompany(Const pDescription, pCode: WideString):
  LongWord;
Begin
  Result := S_OK;
  { check for null values}
  If _CheckParams([pDescription, pCode]) Then
  Begin
    Result := CreateExCompany(pDescription, pCode);
    {load the new company}
    If Result = S_OK Then
      CheckCompanies;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_CreateCompany', Result,
      'Parameters :-' +
      ' Name: ' + pDescription +
      ' Code: ' + pCode,
      true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: CheckCompanies
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRSERVER.CheckCompanies;
Var
  lComp: Olevariant;
  lCont, lTotal: Integer;
  lPath: String;
Begin
  _GetExVersion;
  
  lComp := Null;
  {load companies from the toolkit}
  Try
    lComp := _LoadExCompanies;
  except
  end;

  {check the returned companies against the database. If not exists, it will create a new company}
  fADODSR.CheckExCompanies(lComp);

  {check the database against the exchequer MCM update companies status}
  If Not _IsVAO Then
  Begin
    lComp := Null;
    lComp := fADODSR.GetCompanies;
    lTotal := _GetOlevariantArraySize(lComp);
    For lCont := 0 To lTotal - 1 Do
    Begin
      lPath := '';
      If Not VarIsNull(lComp[lCont]) Then
      Try
        lPath := _GetExCompanyPath(lComp[lCont][1]);
        If Not _DirExists(lPath) Then
          fADODSR.SetCompanyStatus(lComp[lCont][0], FAlse);
      Except
      End
    End; {for lCont:= 0 to lTotal - 1 do}
  End; {If Not _IsVAO Then}
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_Alive
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_Alive: LongWord;
Begin
  Result := S_OK;
  CheckDSRThreads;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_AddNewContact
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_AddNewContact(Const pContactName,
  pContactMail: WideString; pContactCompany: LongWord): LongWord;
Begin
  Result := S_OK;
  If Not fADODSR.SearchContact(pContactMail) Then
  Begin
    If Not fADODSR.AddNewContact(pContactName, pContactMail, pContactCompany)
      Then
    Begin
      Result := cDBERROR;
      fLog.DoLogMessage('TDSRSERVER.DSR_AddNewContact', Result,
        'Error adding new contact...', true, true);
    End; {If Not fADODSR.AddNewContact(pContactName, pContactMail, pContactCompany) Then}
  End {If Not fADODSR.SearchContact(pContactMail) Then}
  Else
  Begin
    Result := cRECORDALREADYEXISTS;
    fLog.DoLogMessage('TDSRSERVER.DSR_AddNewContact', Result,
      'Contact "' + pContactMail + '" already exists.', true, true);
  End; {begin}
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_AddNewUser
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_AddNewUser(Const pUserName, pUserLogin,
  pPassword: WideString): LongWord;
Begin
  Result := S_OK;
  If Not fADODSR.SearchUser(pUserLogin) And
    Not (Lowercase(Trim(pUserLogin)) = Lowercase(cADMINUSER)) Then
  Begin
    If Not fADODSR.AddNewUser(pUserName, pUserLogin, pPassword) Then
    Begin
      Result := cDBERROR;
      fLog.DoLogMessage('TDSRSERVER.DSR_AddNewUser', Result,
        'Error adding new user.', true, true);
    End; {If Not fADODSR.AddNewUser(pUserName, pUserLogin, pPassword) Then}
  End {If Not fADODSR.SearchUser(pUserLogin) Then}
  Else
  Begin
    Result := cRECORDALREADYEXISTS;
    fLog.DoLogMessage('TDSRSERVER.DSR_AddNewUser', Result,
      'User "' + pUserLogin + '" already exists.', true, true);
  End; {begin}
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeleteContact
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_DeleteContact(Const pContactMail: WideString): LongWord;
Begin
  Result := S_OK;
  If Not fADODSR.DeleteContact(pContactMail) Then
    Result := cDBERROR;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeleteUser
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_DeleteUser(Const pUserLogin: WideString): LongWord;
Begin
  Result := S_OK;
  If Not fADODSR.DeleteUser(pUserLogin) Then
    Result := cDBERROR;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetUsers
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_GetContacts(Out pContacts: OleVariant): LongWord;
Begin
  Result := S_OK;
  pContacts := Null;
  pContacts := fADODSR.GetContacts;
  If _GetOlevariantArraySize(pContacts) = 0 Then
    Result := cDBNORECORDFOUND;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_UpdateUserRule
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_GetUsers(Out pUsers: OleVariant): LongWord;
Begin
  Result := S_OK;
  pUsers := null;
  pUsers := fADODSR.GetUsers;
  If _GetOlevariantArraySize(pUsers) = 0 Then
    Result := cDBNORECORDFOUND;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_UpdateDSRSettings
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_UpdateUserRule(Const pUserLogin: WideString;
  pRule: Word; pActive: Shortint): LongWord;
Begin
  {not developed yet}
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_UpdateDSRSettings
  Author:    vmoura

  get the xml settings and save
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_UpdateDSRSettings(Const pXml: WideString): LongWord;
//var
//  lPort: String;
Begin
  Result := S_OK;

  {chek the xml}
  If pXml <> '' Then
  Begin
    {decode the xml to a system variable}
    If fSystemConf.TranslateXmltoDSRSettings(pXML) Then
    Begin
      {check Dripfeed}
      If fSystemConf.AutomaticDripFeed Then
        CheckDSRThreads
      Else
        FinishDSRThread(TDSRThread(fDSRDripFeed));

      _ChangeWrapperSettings(StrToIntDef(fAdoDSR.GetSystemValue(cDSRPORTPARAM), 0));
    End
    Else
      Result := cERROR;
  End
  Else
    Result := cINVALIDXML;

  If Result <> S_Ok Then
    fLog.DoLogMessage('TDSRSERVER.DSR_UpdateDSRSettings', Result,
      'Error updating The Service settings...', true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_UpdateMailSettings
  Author:    vmoura

-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_UpdateMailSettings(Const pXml: WideString): LongWord;
Begin
  Result := S_OK;
  {the config/dashboard is dealing with adding/updating the email accounts}
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetDsrSettings
  Author:    vmoura

  translate the dsr settings to a xml
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_GetDsrSettings(Out pXml: WideString): LongWord;
Var
  lXml: WideString;
Begin
  Result := S_OK;
  If Assigned(fSystemConf) Then
  Begin
    {get the ini settings and translate to xml}
    lXml := fSystemConf.TranslateDSRSettingstoXml;
    If lXml <> '' Then
      pXml := lXml
    Else
      Result := cERROR;
  End; {If Assigned(fSystemConf) Then}

  If Result <> S_Ok Then
    fLog.DoLogMessage('TDSRSERVER.DSR_GetDsrSettings', Result,
      'Error getting The Service settings...', true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetMailSettings
  Author:    vmoura

  translate the dsr mail settings to a xml
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_GetMailSettings(Out pXml: WideString): LongWord;
//Var
//  lXml: WideString;
Begin
  Result := S_OK;
  {the config/dashboard is dealing with adding/updating the email accounts}
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_SyncRequest
  Author:    vmoura

  create a sync request from client to practice
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_SyncRequest(pCompany: LongWord; Const pSubj, pFrom,
  pTo, pParam1, pParam2: WideString): LongWord;
Var
  lMsg: TMessageInfo;
  lBulkTh: TDSRBulkTh;
Begin
  Result := S_OK;

  {check mandatory fields}
  If _CheckParams([pCompany, pFrom, pSubj, pTo, pSubj]) Then
  Begin
    {look for a valid company}
    If fADODSR.SearchCompany(pCompany) Then
    Begin
      lMsg := TMessageInfo.Create;
      With lMsg Do
      Begin
        Company_Id := pCompany;
        Subject := pSubj;
        From := pFrom;
        To_ := pTo;
        Guid := _CreateGuid;
        Param1 := pParam1;
        Param2 := pParam2;
        Mode := Ord(rmSync);
      End; {With lMsg Do}

      {update the database}
      With lMsg Do
        fADODSR.UpdateOutBox(Guid, Company_Id, Subject, From, To_, 0, 0,
          Param1, Param2, cPROCESSING, Ord(Mode),
          TDBOption(IfThen(fADODSR.SearchOutboxEntry(Guid) > 0,
          ord(dbDoUpdate), Ord(dbDoAdd))));

      lBulkTh := TDSRBulkTh.Create(lMsg, True);
      lBulkTh.Resume;

      Sleep(2);

      If Assigned(lMsg) Then
        FreeAndNil(lMsg);
    End
    Else
      Result := cINVALIDPARAM;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_SyncRequest', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany) +
      ' Subject: ' + pSubj +
      ' From: ' + pFrom +
      ' To: ' + pTo,
      true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_RebuildCompany
  Author:    vmoura

  activate the the company and import all mails again
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_ReCreateCompany(pCompany: LongWord): LongWord;
Var
  lBuild: TDSRReCreateCompany;
Begin
  Result := S_OK;

  {check mandatory fields}
  If _CheckParams([pCompany]) Then
  Begin
    lBuild := TDSRReCreateCompany.Create;
    lBuild.Company := pCompany;
    lBuild.Resume;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_ReCreateCompany', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany) +
      ' ID: ' + inttostr(pCompany), true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_CheckCompanies
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_CheckCompanies: LongWord;
Begin
  Result := S_OK;
  CheckCompanies;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_CheckMailNow
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_CheckMailNow: LongWord;
Var
//  lhandle: Thandle;
  lMail: TDSRCheckMail;
Begin
  Result := S_OK;

 {changed 20061020}
(*  If Assigned(fDSRCheckMail) Then
  Begin
    With fDSRCheckMail Do
      If Not Terminated And Not Working And Alive Then
      Begin
      {using signals to call the checking mail. the setevent is going to release
      the waitfor function that is holding the thread}
        lhandle := CreateEvent(Nil, False, False, pChar(cDSRCHECKEMAILEVENT));
        If lHandle > 0 Then
        Begin
          SetEvent(lHandle);
          CloseHandle(lHandle);
        End; {If lHandle > 0 Then}
      End {If Not Terminated And Not Working And Alive Then}
  End;*)

  lMail := TDSRCheckMail.Create;
  lMail.Resume;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_CheckDripFeed
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_CheckDripFeed(pCompany: LongWord;
  Out pStatus: LongWord): LongWord;
Var
  lPath: String;
  lRes: Boolean;
Begin
  Result := S_OK;
  pStatus := S_FALSE;

  {check for valid company number}
  If _CheckParams([pCompany]) Then
  Begin
    {get the exchequer company path from database}
    lPath := fADODSR.GetCompanyPath(pCompany);
    If Not _DirExists(lPath) Then
      lPath := _GetExCompanyPath(fADODSR.GetExCode(pCompany));

    If _DirExists(lPath) Then
    Begin
      {check dripfeed}
      lRes := _CheckExDripFeed(lPath);
      If lRes Then
        pStatus := S_OK
      Else
        pStatus := S_FALSE;
    End
    Else
      Result := cINVALIDPARAM;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_Ok Then
    fLog.DoLogMessage('TDSRSERVER.DSR_CheckDripfeed', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany) +
      ' Path: ' + lPath, True, True);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_RemoveDripFeed
  Author:    vmoura

  remove status of Dripfeed from a specified company
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_RemoveDripFeed(pCompany: LongWord; Const pFrom,
  pTo, pSubject: WideString): LongWord;
Var
  lPath: String;
Begin
  Result := S_OK;

  {check for valid company number}
  If _CheckParams([pCompany, pFrom, pTo, pSubject]) Then
  Begin
    {get the exchequer company path from database}
    lPath := fADODSR.GetCompanyPath(pCompany);
    If Not _DirExists(lPath) Then
      lPath := _GetExCompanyPath(fADODSR.GetExCode(pCompany));

    If _DirExists(lPath) Then
    Begin
      {remove dripfeed info from dripfeed.dat}
        {calling remove dripfeed thread to finish off the dripfeed mode of the company}
      Result := S_OK;

      With TDSRRemoveDripFeed.Create Do
      Begin
        Company := pCompany;
        From := pFrom;
        To_ := pTo;
        subject := pSubject;
        CompanyPath := lPath;
        Resume;
      End; {with TDSRRemoveDripFeed.Create do}
    End
    Else
      Result := cEXCHINVALIDPATH;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_Ok Then
    fLog.DoLogMessage('TDSRSERVER.DSR_RemoveDripFeed', Result,
      //'Error removing Dripfeed. ' +
      'Error removing Link. ' +
      ' Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany),
      True, True)
  Else
    fLog.DoLogMessage('TDSRSERVER.DSR_RemoveDripFeed', 0,
      //'End of Dripfeed has been applied for ' +
      'End of Link has been applied for ' +
      fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany), True, True);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_ChangeAdmin
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_SetAdminPassword(Const pAdminPass: WideString):
  LongWord;
Begin
  Result := S_OK;

  If _CheckParams([pAdminPass]) Then
  Begin
    fADODSR.SetAdminPassWord(pAdminPass);
    _LogMSG('TDSRSERVER.DSR_SetAdminPassword :- Manager password updated...');
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_SetAdminPassword', Result, '', True, True);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetDripFeedParams
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_GetDripFeedParams(pCompany: LongWord; Out pPeriodYear1,
  pPeriodYear2: WideString): LongWord;
Var
  lPath: String;
  lp1, lp2: String;
Begin
  Result := S_OK;

  {check for valid company number}
  If _CheckParams([pCompany]) Then
  Begin
    {get the exchequer company path from database}
    lPath := fADODSR.GetCompanyPath(pCompany);
    If Not _DirExists(lPath) Then
      lPath := _GetExCompanyPath(fADODSR.GetExCode(pCompany));

    If _DirExists(lPath) Then
    Begin
      _GetDripFeedPeriod(lPath, lP1, lP2);
      pPeriodYear1 := lp1;
      pPeriodYear2 := lp2;
    End
    Else
      Result := cEXCHINVALIDPATH;
  End
  Else
    Result := cINVALIDPARAM;

  If (Result <> S_Ok) And (Result <> cEXCHINVALIDPATH) Then
    fLog.DoLogMessage('TDSRSERVER.DSR_GetDripFeedParams', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany) +
      ' Path: ' + lPath,
      True, True);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DeactivateCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_DeactivateCompany(pCompany: LongWord): LongWord;
Var
  lStatus: Longword;
Begin
  Result := S_OK;
  { test parameter}
  If pCompany > 0 Then
  Begin
    lStatus := S_False;

    {check if cis is running}
    If fADODSR.GetSystemValue(cISCISPARAM) = '0' Then
    Begin
      Try
        DSR_CheckDripFeed(pCompany, lStatus);
      Except
      End;

      { search for the company}
      If fADODSR.SearchCompany(pCompany) Then
      Begin
        {check the company Dripfeed status}
        If lStatus <> S_OK Then
        Begin
          { deactivate the company}
          fADODSR.SetCompanyStatus(pCompany, False);
        End
        Else
        Begin
          Result := cEXCHERROR;
          fLog.DoLogMessage('TDSRSERVER.DSR_DeactivateCompany', 0,
            //'A company in Dripfeed mode can not be deactivated.', true, true);
            'A company in Link Mode can not be deactivated.', true, true);
        End; {begin}
      End
      Else
        Result := cDBNORECORDFOUND;
    End
    Else If fADODSR.SearchCompany(pCompany) Then
      fADODSR.SetCompanyStatus(pCompany, False);
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_DeactivateCompany', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany),
      true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_ActivateCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_ActivateCompany(pCompany: LongWord): LongWord;
Var
  lExCode: String;
Begin
  Result := S_OK;
  { test parameter}
  If pCompany > 0 Then
  Begin
    { search for the company}
    If fADODSR.SearchCompany(pCompany) Then
    Begin
      lExCode := fADODSR.GetExCode(pCompany);
      {check if this company already exists into MCM}
      If _CheckExCompCode(lExCode) Then
        fADODSR.SetCompanyStatus(pCompany, True)
      Else
        Result := cEXCHINVALIDCOMPCODE;
    End
    Else
      Result := cDBNORECORDFOUND;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
  Begin
    If Result = cEXCHINVALIDCOMPCODE Then
      fLog.DoLogMessage('TDSRSERVER.DSR_ActivateCompany', Result,
        'This company must be recreated.', true, true)
    Else
      fLog.DoLogMessage('TDSRSERVER.DSR_ActivateCompany', Result,
        'Parameters :- ' +
        ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
        ' Code: ' + fADODSR.GetExCode(pCompany),
        true, true);
  End; {If Result <> S_OK Then}
End;

{-----------------------------------------------------------------------------
  Procedure: Get_DSR_Version
  Author:    vmoura

  return the current dsr version
-----------------------------------------------------------------------------}
Function TDSRSERVER.Get_DSR_Version: WideString;
Begin
  //Result := cDSRVERSION;
  Result := CommonBit + cDSRBUILD;
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_Sync
  Author:    vmoura

  normal sync. this function just add an entry into ice database. the entry will be picked up by
  producer thread and added to the queu list and the sender thread will do the job of processing it
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_Sync(pCompany: LongWord; Const pSubj, pFrom, pTo,
  pParam1, pParam2: WideString; pPackageId: LongWord): LongWord;
Begin
  Result := S_OK;

  {check mandatory fields}
  If _CheckParams([pCompany, pFrom, pSubj, pTo, pSubj]) Then
  Begin
    {look for a valid company}
    If fADODSR.SearchCompany(pCompany) Then
    Begin
      {if producer or sender are dead, start those threads}
      CheckDSRThreads;

      {create a new entry into the outbox table. this entry will be picked up
      later and processed with the dsrthreads}

      If Not fADODSR.UpdateOutBox(_CreateGuid, pCompany, pSubj, pFrom, pTo,
        pPackageId, 0, pParam1, pParam2, cSAVED, Ord(rmDripFeed), dbDoAdd) Then
        Result := cDBERROR;
    End
    Else
      Result := cINVALIDPARAM;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_Ok Then
    fLog.DoLogMessage('TDSRSERVER.DSR_Sync', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany) +
      ' Subject: ' + pSubj +
      ' From: ' + pFrom +
      ' To: ' + pTo,
      true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_IsVAO
  Author:    vmoura

  check if iaoo is running
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_IsVAO: LongWord;
Begin
  Result := Ord(_IsVAO);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_ExProductType
  Author:    vmoura

  get the product type
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_ExProductType: LongWord;
Begin
  Result := Ord(_ExProductType);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetInboxXml
  Author:    vmoura

  the the inbox xml file.
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_GetInboxXml(pGuid: TGUID; pOrder: LongWord; Out pXML:
  WideString): LongWord;
Var
  lFile: String;
Begin
  Result := S_OK;

  If _IsValidGuid(pGuid) Then
  Begin
    lFile := IncludeTrailingPathDelimiter(fSystemConf.InboxDir +
      GUIDToString(pGuid)) + inttostr(pOrder) + cXMLEXT;
    If _FileSize(lFile) > 0 Then
    Begin
      pXml := '';
      Try
        pXml := _GetXmlFromFile(lFile);
      Except
        On e: exception Do
        Begin
          Result := cERROR;
          fLog.DoLogMessage('TDSRSERVER.DSR_GetInboxXml', Result,
            'Error loading xml. Error: ' + e.Message, true, true);
        End; {begin}
      End; {try}
    End {if _FileSize(lFile) > 0 then}
    Else
      Result := cFILENOTFOUND;
  End {If _IsValidGuid(pGuid) Then}
  Else
    Result := cINVALIDPARAM;

  If Result <> S_Ok Then
    fLog.DoLogMessage('TDSRSERVER.DSR_GetInboxXml', Result, lFile, True, True);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetOutboxXml
  Author:    vmoura

  get outbox xml file
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_GetOutboxXml(pGuid: TGUID; pOrder: LongWord; Out pXML:
  WideString): LongWord;
Var
  lFile: String;
Begin
  Result := S_OK;

  If _IsValidGuid(pGuid) Then
  Begin
    {outbox files are stored with a guid in their names, not number as inbox files}
    lFile := _GetFileByOrder(fSystemConf.OutboxDir + GUIDToString(pGuid),
      pOrder,
      True);

    If _FileSize(lFile) > 0 Then
    Begin
      pXml := '';
      Try
        pXml := _GetXmlFromFile(lFile);
      Except
        On e: exception Do
        Begin
          Result := cERROR;
          fLog.DoLogMessage('TDSRSERVER.DSR_GetOutboxXml', Result,
            'Error loading xml. Error: ' + e.Message, true, true);
        End; {begin}
      End; {try}
    End {if _FileSize(lFile) > 0 then}
    Else
      Result := cFILENOTFOUND;
  End {If _IsValidGuid(pGuid) Then}
  Else
    Result := cINVALIDPARAM;

  If Result <> S_Ok Then
    fLog.DoLogMessage('TDSRSERVER.DSR_GetOutboxXml', Result, lFile, True, True);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_ViewCISResponse
  Author:    vmoura

  get the xml returned by GGW
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_ViewCISResponse(pOutboxGuid, pFileGuid: TGUID;
  Out pXml: WideString): LongWord;
Var
  lFile: String;
  lDoc: TStringList;
Begin
  Result := S_OK;

  If _IsValidGuid(pOutboxGuid) And _IsValidGuid(pFileGuid) Then
  Begin
    lFile := IncludeTrailingPathDelimiter(fSystemConf.OutboxDir +
      GUIDToString(pOutboxGuid));
  {outbox + file directory + cisreturn directory}
    lFile := IncludeTrailingPathDelimiter(lFile + cCISRETDIR);
  {outbox + file directory + cisreturn directory + "file name.xml"}
    lFile := lFile + GUIDToString(pFileGuid) + cXMLEXT;

    If _FileSize(lFile) > 0 Then
    Begin
      lDoc := TStringList.Create;
      Try
        Try
          lDoc.LoadFromFile(lFile);
        Except
          On e: exception Do
          Begin
            Result := cLOADINGFILEERROR;
            fLog.DoLogMessage('TDSRSERVER.DSR_ViewCISResponse', Result, lFile, True,
              True);
          End; {begin}
        End; {try}

        If lDoc.Text <> '' Then
          pXML := lDoc.Text;
      Finally
        If Assigned(lDoc) Then
          lDoc.Free;
      End; {try}
    End {if _FileSize(lFile) > 0 then}
    Else
      Result := cFILENOTFOUND;
  End {If _IsValidGuid(pGuid) Then}
  Else
    Result := cINVALIDPARAM;

  If Result <> S_Ok Then
    fLog.DoLogMessage('TDSRSERVER.DSR_ViewCISResponse', Result, '', True, True);
End;

{-----------------------------------------------------------------------------
  Function    : DSR_ViewVAT100Response
  Author      : Phil Rogers
  Description : Get the XML returned by GGW for VAT 100

  Note        : This is almost identical to DSR_ViewCISResponse.  The only
                difference is the path to the directory.  If more services are
                added in future, it might pay to refactor this and pass in the
                directory as a parameter.
-----------------------------------------------------------------------------}
function TDSRSERVER.DSR_ViewVAT100Response(pOutboxGuid, pFileGuid: TGUID;
  out pXml: WideString): LongWord;
var
  lFile : string;
  lDoc  : TStringList;
begin
  Result := S_OK;

  if _IsValidGuid(pOutboxGuid) and _IsValidGuid(pFileGuid) then
  begin
    lFile := IncludeTrailingPathDelimiter(fSystemConf.OutboxDir + GUIDToString(pOutboxGuid));
    {outbox + file directory + VAT100return directory}
    lFile := IncludeTrailingPathDelimiter(lFile + cVAT100RETDIR);
    {outbox + file directory + VAT100return directory + "file name.xml"}
    lFile := lFile + GUIDToString(pFileGuid) + cXMLEXT;

    if _FileSize(lFile) > 0 then
    begin
      lDoc := TStringList.Create;
      try
        try
          lDoc.LoadFromFile(lFile);
        except
          on e: exception do
          begin
            Result := cLOADINGFILEERROR;
            fLog.DoLogMessage('TDSRSERVER.DSR_ViewVAT100Response', Result, lFile, True,
              True);
          end;
        end; {try}

        if lDoc.Text <> '' then
          pXML := lDoc.Text;
      finally
        if assigned(lDoc) then
          lDoc.Free;
      end; {try}
    end {if _FileSize(lFile) > 0 then}
    else
      Result := cFILENOTFOUND;
  end {If _IsValidGuid(pGuid) Then}
  else
    Result := cINVALIDPARAM;

  if Result <> S_Ok then
    fLog.DoLogMessage('TDSRSERVER.DSR_ViewVAT100Response', Result, '', True, True);
end;

{-----------------------------------------------------------------------------
  Procedure: DSR_GetExPeriodYear
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_GetExPeriodYear(pCompany: LongWord;
  Out pPeriodYear1, pPeriodYear2: WideString): LongWord;
Var
  lPath: String;
  lYear2,
    lP1, lP2: String;
Begin
  Result := S_OK;

  {check for valid company number}
  If _CheckParams([pCompany]) Then
  Begin
    {get the exchequer company path from database}
    lPath := fADODSR.GetCompanyPath(pCompany);
    If Not _DirExists(lPath) Then
      lPath := _GetExCompanyPath(fADODSR.GetExCode(pCompany));

    _CallDebugLog('Path to check: ' + lPath);

    If _DirExists(lPath) Then
    Begin
      {get dripfeed params}
      _CallDebugLog('loading ex dripfeed period');

      Try
        lp1 := _GetFirstDripFeedPeriodYear(lPath);
      Finally
        If (Length(lp1) = 8) Or (lP1 = '') Or (lp1 = '001900') Then
        Begin
          Try
            _GetDripFeedPeriod(lPath, lP1, lP2);
          Finally
          End;

          lp1 := _FormatPeriod(1, Now);
        End; {If (Length(lp1) = 8) Or (lP1 = '') Or (lp1 = '001900') Then}
      End; {try}

      _CallDebugLog('loading last dripfeed periodyear...');

      Try
        lYear2 := _GetYear(lp1);
      Except
        lYear2 := '';
      End;

      lP2 := _FormatPeriod(fADODSR.GetCompanyPeriods(pCompany),
        StrToIntDef(lYear2, YearOf(Now)));

      pPeriodYear1 := lp1;
      pPeriodYear2 := lP2;

    End
    Else
      Result := cINVALIDPARAM;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_Ok Then
    fLog.DoLogMessage('TDSRSERVER.DSR_GetExPeriodYear', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany) +
      ' Path: ' + lPath, True, True);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_DenySyncRequest
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_DenySyncRequest(pCompany: LongWord; pGuid: TGUID): LongWord;
Var
  lMsg: TMessageInfo;
  lComp: Integer;
  lDSRHeader: TDSRFileHeader;
  lSubj,
    lFileName: String;
Begin
  Result := S_OK;

  If _IsValidGuid(pGuid) Then
  Begin
    lComp := fADODSR.GetInboxCompanyId(pGuid);

    {can be a new message being deleted and a new message does not have company_id}
    If lComp In [pCompany, 0] Then
    Begin
      lMsg := fADODSR.GetInboxMessage(pGuid);
      { delete or update this entry}
      If lMsg <> Nil Then
      Begin
        {if already a recycle then fisically delete this message, otherwise, just apply the status}
        If lMsg.Status In [cDELETED, cARCHIVED] Then
        Begin
          TDSRDeleteDir.Create(fSystemConf.InboxDir + GUIDToString(pGuid));
          fADODSR.UpdateInBox(pGuid, 0, '', '', '', 0, 0, 0, -1, dbDoDelete);
        End
        Else
        Begin
          fADODSR.UpdateInBox(pGuid, 0, '', '', '', 0, 0, cDELETED, -1, dbDoUpdate);

          {send sync denied nack}
          If (lComp = 0) And Not (lMsg.Status In [cSYNCDENIED, cSYNCFAILED]) Then
          Begin
            fLog.DoLogMessage('TDSRSERVER.DSR_DenySyncRequest', 0,
              'The Link Request has been denied for message subject: ' +
              lMsg.Subject, True, True);

            lFileName := IncludeTrailingPathDelimiter(fSystemConf.InboxDir +
              GUIDToString(lMsg.Guid)) + cACKFILE;

            FillChar(lDSRHeader, SizeOf(TDSRFileHeader), 0);
            _GetHeaderFromFile(lDSRHeader, lFileName);

            {format the subject of the message just in case of the company name has not been filled}
            //If trim(fSystemConf.CompanyName) <> '' Then
            if fADODSR.GetSystemValue(cCOMPANYNAMEPARAM) <> '' then
              lSubj := 'Link Request denied from "' +
                fADODSR.GetSystemValue(cCOMPANYNAMEPARAM) + '" e-mail ' + lMsg.to_
            Else
              lSubj := 'Link Request denied from e-mail ' + lMsg.to_;

            If TDSRMail.SendNACK(pGuid, lMsg.To_, lMsg.From, 1, cNACKSYNCDENIED,
              lDSRHeader.ExCode, lDSRHeader.CompGuid, lSubj) = S_OK Then
              fADODSR.UpdateOutBox(_CreateGuid, lMsg.Company_Id,
                'Link Request Denied Acknowledge. Subject : ' +
                lMsg.Subject, lMsg.To_, lMsg.From, 0, 1, lMsg.Param1, lMsg.Param2,
                cSENT, Ord(rmNormal), dbDoAdd)
            Else
              fADODSR.UpdateOutBox(_CreateGuid, lMsg.Company_Id,
                'Link Request Denied Acknowledge. Subject : ' +
                lMsg.Subject, lMsg.To_, lMsg.From, 0, 1, lMsg.Param1, lMsg.Param2,
                cFAILED, Ord(rmNormal), dbDoAdd);
          End; {If lMsg.Mode = Ord(rmSync) Then}
        End; {else begin}

        FreeAndNil(lMsg);
      End; {if lMsg <> nil then}
    End {If lComp In [pCompany, 0] Then}
    Else
      Result := cDBNORECORDFOUND;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_DenySyncRequest', Result,
      'Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany) +
      ' E-Mail ID:' + _SafeGuidtoString(pGuid), true, true);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_CancelDripfeed
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_CancelDripfeed(pCompany: LongWord; Const pFrom,
  pTo, pSubject: WideString): LongWord;
Var
  lPath: String;
Begin
  Result := S_OK;

  {check for valid company number}
  If _CheckParams([pCompany, pFrom, pTo, pSubject]) Then
  Begin
    {get the exchequer company path from database}
    lPath := fADODSR.GetCompanyPath(pCompany);
    If Not _DirExists(lPath) Then
      lPath := _GetExCompanyPath(fADODSR.GetExCode(pCompany));

    If _DirExists(lPath) Then
    Begin
      {remove dripfeed info from dripfeed.dat}
        {calling remove dripfeed thread to finish off the dripfeed mode of the company}
      Result := S_OK;

      With TDSRRemoveDripFeed.Create Do
      Begin
        Company := pCompany;
        From := pFrom;
        To_ := pTo;
        subject := pSubject;
        CompanyPath := lPath;
        Cancel := True;
        Resume;
      End; {with TDSRRemoveDripFeed.Create do}
    End
    Else
      Result := cEXCHINVALIDPATH;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_Ok Then
    fLog.DoLogMessage('TDSRSERVER.DSR_CancelDripfeed', Result,
      //'Error cancelling Dripfeed. ' +
      'Error cancelling Link. ' +
      ' Parameters :- ' +
      ' Company: ' + fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany),
      True, True)
  Else
    fLog.DoLogMessage('TDSRSERVER.DSR_CancelDripfeed', 0,
      //'The Dripfeed has been cancelled for ' +
      'The Link has been cancelled for ' +
      fADODSR.GetCompanyDescription(pCompany) +
      ' Code: ' + fADODSR.GetExCode(pCompany), True, True);
End;

{-----------------------------------------------------------------------------
  Procedure: DSR_RestoreMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRSERVER.DSR_RestoreMessage(pGuid: TGUID): LongWord;
Var
  lMsg: TMessageInfo;
Begin
  Result := S_Ok;
  {check for a valid guid}
  If _IsValidGuid(pGuid) Then
  Begin
    If fADODSR.SearchInboxEntry(pGuid) > 0 Then
      lMsg := fADODSR.GetInboxMessage(pGuid)
    Else
      lMsg := fADODSR.GetOutboxMessage(pGuid);

    If lMsg <> Nil Then
    Begin
      {initiate the thread for restoring this particular item}
      With TDSRRestoreMessage.Create Do
      Begin
        Msg.Assign(lMsg);
        Resume;
      End; {with TDSRRestoreMessage.Create do}

      FreeAndNil(lMsg);
    End
    Else
      Result := cDBNORECORDFOUND;
  End
  Else
    Result := cINVALIDPARAM;

  If Result <> S_OK Then
    fLog.DoLogMessage('TDSRSERVER.DSR_RestoreMessage', Result,
      'The requested message could not be restored.', True, True);
End;

Initialization
  TAutoObjectFactory.Create(ComServer, TDSRSERVER, Class_DSRSERVER,
    ciMultiInstance, tmApartment);

End.

