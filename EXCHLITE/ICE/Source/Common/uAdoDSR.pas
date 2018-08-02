{-----------------------------------------------------------------------------
 Unit Name: uADODSR
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uADODSR;

Interface

Uses Classes, ADODB,

  uConsts, uBaseClass,
  uInterfaces
  ;

Type
  TDSRADOConnection = Class(TADOConnection)
  Private
  Protected
{$IFDEF DEBUG}
    Procedure DoConnect; Override;
{$ENDIF}
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
  End;

  TADODSR = Class(TADOQuery)
  Private
    fInstance: String;
    fServer, fMSSQLSERVER: String;
    fLog: _Base;
    fADOConnection: TDSRADOConnection;

    Function GetDateFormat: String;
    Function GetConnected: Boolean;
    Procedure DeleteImpPackages;
    Procedure DeleteExPackages;
    Function DateTimeToSQLDateTime(pDate: TDateTime; Const pUseTime: Boolean =
      True): String;
    Property Server: String Read fServer Write fServer;
    Property MSSQLSERVER: String Read fMSSQLSERVER Write fMSSQLSERVER;
    Property Instance: String Read fInstance Write fInstance;

    Procedure SetConnected(Const Value: Boolean);
    Procedure UpdateDatabase(Const pFile: String; Const pCreate: Boolean = False);
    Function GetVersion: String;
    Procedure UpdateVersion(Const pValue: String);
  Public
    Constructor Create(Const pServer: String; Const pStartUp: Boolean = False);
      Reintroduce;
    Destructor Destroy; Override;

    Function GetDbFileName: String;
    Function DBExists(Const pDb: String): Boolean;
    Procedure SetSystemParameter(Const pParam, pValue: String);
    Function GetSystemValue(Const pParam: String): String;

    Function CheckServiceStatus: Boolean;
    Function TestConnection(Const pStartUp: Boolean = False): Boolean;
    Procedure CheckScheduleTypes;

    Function GetAdminPassword: String;
    Procedure SetAdminPassWord(Const pPassw: String);

    Procedure DeleteIceDBLog(Const pDays: Integer = cLOGTIMELIFE);
    Function SearchPackageId(Const pXml: Widestring): Integer;
    Function RegisterPlugins: Boolean;
    Procedure RegisterEmailSystem;
    Procedure UpdateIceLog(Const pWhere, pMsg: String);
    Function GetLog: OleVariant;

    // email functions
    Function UpdateEmailAccount(pEmailAccount: TEmailAccount; pAction: TDBOption):
      Boolean;

    Function EmailExists(Const pEmail: String): Boolean;
    Function GetEmailAccounts(Out pResult: Longword): Olevariant;
    Function GetDefaultEmailAccount: String;
    Function GetDefaultAccount: TEmailAccount;
    Procedure SetDefaultEmailAccount(pEmailAccount: TEmailAccount);
    Procedure DeleteAllEmailAccounts;

    // email system
    Function UpdateEmailSystem(pSystem: TEmailSystem; pAction: TDBOption): Boolean;
    Function EmailSystemExists(Const pServerType: String): Boolean;
    Function GetEmailSystem(Out pResult: Longword): Olevariant;
    Function GetEmailSystemById(pId: Integer): TEmailSystem;
    Function GetEmailSystemByServerType(Const pServerType: String): TEmailSystem;
    Procedure DeactivateEmailSystem(Const pSystem: String = '');

    /////////// inbox functions ///////////
    Function SearchInboxEntry(pGuid: TGuid): Integer;
    {Function SearchInboxCompanyId(pGuid: TGuid): Integer;}
    Function UpdateInBox(pGuid: TGuid; pCompanyId: Integer; Const pSubj,
      pUserFrom, pUserto: WideString; pPackId: Integer; pTotal, pStatus, pMode:
      Smallint; pAction: TDBOption): Boolean;
    Function ChangeInboxGuid(pId: Longword; pNewGuid: TGuid): Boolean;

    Procedure SetInboxMessageToCompany(pGuid: TGUID; pCompany: LongWord; Out
      pResult: LongWord);

    Function GetInboxMessageStatus(pGuid: TGuid): Integer;
    Function InboxMessageStatusExists(pCompany: Longword; pStatus: Smallint):
      Boolean;
    Function InboxMessageProcessing(pCompany: Longword): Boolean;

    Function InboxMessageModeExists(pCompany: Longword; pMode: TRecordMode):
      Boolean;
    Procedure SetInboxMessageStatus(pGuid: TGuid; pStatus: Integer);
    Function GetInboxCompanyId(pGuid: TGuid): Integer;
    Function GetInboxMessage(pGuid: TGuid): TMessageInfo;
    Function GetInboxMessages(pCompany: Integer; pPackId: LongWord; pStatus:
      Smallint; pDate: TDatetime; pMaxRecords: Longword; Out pResult: LongWord;
      Const pLogMessage: Boolean = True): OleVariant;
    Function GetTotalInboxMessages(pCompany: Integer; Const pStatus: Smallint =
      0): Longword;
    Procedure SetInboxTotalDone(pGuid: TGuid; pValue: Integer);

    Function GetTotalInboxSyncMessages(pCompany: Integer): Longword;

    Function GetInboxMessagesBySql(Const pSql: String; Out pResult: Longword):
      OleVariant;
    Function GetFirstInboxMessage(pCompany: Longword): TMessageInfo;
    Function GetTopInboxMessage(pCompany: Longword): TMessageInfo;

    Procedure ProcessOldInboxMails;
    Function GetLastInboxUpdate: TDateTime;
    Procedure ChangeInboxStatus(pCompany, pFromStatus, pToStatus: Integer);

    /////////// outbox functions ///////////
    Function SearchOutboxEntry(pGuid: TGuid): Integer;
    {Function SearchOutboxCompanyId(pGuid: TGuid): Integer;}
    Function UpdateOutBox(pGuid: TGuid; pCompany: Longword; Const pSubj,
      pUserFrom, pUserto: WideString; pPackId: LongWord; pTotal:
      Smallint; Const pParam1, pParam2: WideString; pStatus, pMode: Smallint;
      pAction: TDBOption): Boolean;
    Function UpdateOutboxSentDate(pGuid: TGuid; pDate: TDateTime): Boolean;
    Function GetOutboxCompanyId(pGuid: TGuid): Integer;
    Function OutboxMessageStatusExists(pCompany: Longword; pStatus: Smallint):
      Boolean;

    Function OutboxMessageProcessing(pCompany: Longword): Boolean;

    Function GetOutboxMessageStatus(pGuid: TGuid): Integer;
    Procedure SetOutboxMessageStatus(pGuid: TGuid; pStatus: Integer);
    Function GetOutboxMessage(pGuid: TGuid): TMessageInfo;
    Function GetOutboxMessages(pCompany: Integer; pPackId: Longword; pStatus:
      Smallint; pDate: TDatetime; pMaxRecords: Longword; Out pResult: LongWord;
      Const pLogMessage: Boolean = True): OleVariant;

    Function GetCISMessageDetail(pGuid: TGuid): Olevariant;

    Function GetOutboxMessagesBySql(Const pSql: String; Out pResult: Longword):
      OleVariant;

    Function LoadRecycleMessages: Olevariant;

    Function GetOutboxScheduleMessages(pCompany: Longword; pDate: TDatetime;
      pMaxRecords: Longword; Out pResult: LongWord; Const pLogMessage: Boolean =
      True): OleVariant;

    Procedure SetOutboxMessageToCompany(pGuid: TGUID; pCompany: LongWord; Out
      pResult: LongWord);

    Function GetTotalOutboxMessages(pCompany: Integer; Const pStatus: Smallint =
      0): Longword;
    Procedure ProcessOldOutboxMails;
    Procedure ChangeOutboxStatus(pCompany, pFromStatus, pToStatus: Integer);

    Function GetOutboxMaxMode(pCompany: Longword): TRecordMode;
    Function GetInboxMaxMode(pCompany: Longword): TRecordMode;

    Function GetFirstOutboxMessage(pCompany: Longword): TMessageInfo;
    Function GetTopOutboxMessage(pCompany: Longword): TMessageInfo;
    Function GetLastOutboxUpdate: TDateTime;
    Function IsEndOfSyncRequested(pCompany: Longword): Boolean;
    Procedure SetOutboxTotalDone(pGuid: TGuid; pValue: Integer);

    /////////// company functions ///////////
    Function SearchCompany(pCompany: Longword): Boolean; Overload;
    Function SearchCompany(Const pCompanyName: String): Boolean; Overload;
    Function GetExCode(pCompany: Longword): String;
    Function GetCompanyId(Const pExCode: String): Integer;
    Function GetCompanyIdbyGuid(Const pGuid: String): Integer;
    Function GetCompanyGuid(pCompany: Longword): String; Overload;
    Function GetCompanyGuid(Const pExCode: String): String; Overload;
    Procedure SetCompanyGuid(pCompany: Longword; pGuid: TGuid);
    Procedure ClearCompanyGuid(pCompany: Longword);
    Function GetCompanyPath(pCompany: Longword): String; Overload;
    Function GetCompanyPath(Const pExCode: String): String; Overload;
    Function GetCompanyPathbyGuid(Const pGuid: String): String;
    Function CreateCompany(Const pDescription, pExCode, pPath: String; pPeriods:
      Integer): Boolean;
    Function DeleteCompany(pCompany: Longword; Const pDeleteInbox: Boolean =
      False; Const pDeleteOutBox: Boolean = False): Boolean;
//    Function GetCompanyByExCode(Const pExCode: String): Integer;
    Procedure CheckExCompanies(pCompanies: Olevariant);
    Function GetCompanies(Const pPathFilter: String = ''): OleVariant;
    Procedure SetCompanyStatus(pId: Integer; pStatus: Boolean);
    Function IsCompanyActive(pId: Integer): Boolean; Overload;
    Function IsCompanyActive(Const pExCode: String): Boolean; Overload;
    Procedure SetCompanyPeriods(pId: Integer; pPeriods: Integer);
    Function GetCompanyPeriods(pId: Integer): Integer;
    Procedure SetCompanyDirectory(pId: Integer; Const pPath: String);
    Function GetCompanyDescription(pCompany: Longword): String;
    Function CompanyHasInboxArchive(pCompany: Longword): Boolean;
    Function CompanyHasOutboxArchive(pCompany: Longword): Boolean;
    Procedure SetAllInboxMessagesStatus(pCompany, pStatus: Longword);
    Procedure SetAllOutboxMessagesStatus(pCompany, pStatus: Longword);
    Procedure RemoveAllOutboxSchedule(pCompany: Longword);
    Function GetDefaultReceiver(pCompany: Longword): String;

    /////////// general functions ///////////
    Function RecordExists(Const pSql: String; Const pCloseTable: Boolean =
      True): Boolean;
    Function GetTotalFiles(pGuid: TGuid): Integer;
    Function Exec(Const pSql: String; Const pCheckResult: Boolean = False):
      Boolean;
    Procedure CloseAndClearSql;

    // export and import packages
    Function SetExportPackage(pCompany: LongWord; Const pDescription,
      pPluginLink: WideString; pGuid: TGUID; pUserReference: Word): Boolean;
    Function SetImportPackage(pCompany: LongWord; Const pDescription,
      pPluginLink: WideString; pGuid: TGUID; pUserReference: Word): Boolean;
    Function DeleteExportPackage(pPackId: Integer): Boolean;
    Function DeleteImportPackage(PPackId: Integer): Boolean;
    Function GetExportPackages: OleVariant;
    Function GetImportPackages: OleVariant;
    Function GetExportPluginLink(pId: Integer): String;
    Function GetImportIdbyLink(Const pLink: String): Integer;
    Function GetImportCompany(pId: Integer): Integer;
    Function GetImportPackage(pId, pCompany: Integer): TPackageInfo;

    Function GetExportPackage(pId, pCompany: Integer): TPackageInfo; Overload;
    Function GetExportPackage(pCompany: Integer; Const pDesc: String): TPackageInfo;
      Overload;

    Function FindDripFeed: Boolean;

    // schedule functions
    Function SetSchedule(pGuid: TGUID; pScheduleType: Integer): Boolean;
    Function SearchScheduleEntry(pGuid: TGuid): Integer;
    Function DeleteSchedule(pGuid: TGuid): Boolean;

    Function SetDaySchedule(pGuid: TGuid; pStartDate, pEndDate, pStartTime:
      TDateTime; pAllDays, pWeekDays: Boolean; pEveryDay: Byte): Boolean;

    Function GetDaySchedule(pGuid: TGuid): Olevariant; Overload;
    Function GetDaySchedule(pId: Integer): Olevariant; Overload;

(*    Function SetWeekSchedule(pGuid: TGuid; pStartTime, pEndDate: TDateTime;
      pEveryWeek: Integer; pMon, pTue, pWed, pThu, pFri, pSat, pSun: Boolean):
      Boolean;
    Function SetMonthSchedule(pGuid: TGuid; pStartTime, pEndDate: TDateTime;
      pDay: Integer; pJan, pFeb, pMar, pApr, pMay, pJun, pJul, pAug, pSep, pOct,
      pNov, pDec: Boolean): Boolean;
    Function SetOnTimeOnlySchedule(pGuid: TGuid; pStartDate, pStartTime:
      TDateTime): Boolean;
    Function SetOnTimeOnlyScheduleStatus(pGuid: TGuid; pProcess: Boolean):
      Boolean;*)

    Function ScheduleExists(pCompany: Longword): Boolean;

    // user functions
    Function GetContacts: Olevariant;
    Function CheckUserAndPassword(Const pUser, pPassword: String): Boolean;
    Function GetUsers: Olevariant;
    Function SearchUser(Const pUserLogin: String): Boolean;
    Function SearchContact(Const pContactMail: String): Boolean;
    Function DeleteUser(Const pUserLogin: String): Boolean;
    Function DeleteContact(Const pContactMail: String): Boolean;
    Function AddNewUser(Const pUserName, pUserLogin, pPassword: String):
      Boolean;
    Function AddNewContact(Const pContactName, pContactMail: String;
      pContactCompany: Longword): Boolean;

    // CIS Functions
    Function UpdateCIS(pGuid: TGuid; Const pIrMark, pCorrelationId, pClassType,
      pRedirection, pFileGuid: String; pPollingTime: Integer; pAction: TDBOption):
      Boolean;
    Function HasCISRecord(pGuid: TGuid): Boolean;
    Procedure AddCISDefaultEmailAccount;
    Procedure RemoveCISDefaultAccount;
  Published
    Property Connected: Boolean Read GetConnected Write SetConnected;
    Property DateFormat: String Read GetDateFormat;
  End;

Function CheckDbOK(Const pServer: String): Boolean;

Implementation

Uses Windows, Sysutils, DB, Dateutils, variants, IniFiles, math,
  strutils,
  uCommon, uXmlBaseClass, uDSRDeleteDir;

Function CheckDbOK(Const pServer: String): Boolean;
Var
  lDb: TADODSR;
Begin
  Result := False;
  lDb := Nil;
  Try
    lDb := TADODSR.Create(pServer);
  Except
  End;

  If Assigned(lDb) Then
  Begin
    Result := lDb.Connected;
    lDb.Free;
  End; {If Assigned(lDb) Then}
End;

{ TDSRADOConnection }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRADOConnection.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  LoginPrompt := False;

  Self.CommandTimeout := 16;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRADOConnection.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: DoConnect
  Author:    vmoura
-----------------------------------------------------------------------------}
{$IFDEF DEBUG}
Procedure TDSRADOConnection.DoConnect;
Begin
  Try
    ConnectionObject.Open(ConnectionObject.ConnectionString, '', '',
      ord(ConnectOptions));
  Except
    On e: exception Do
    Begin
      _LogMSG('TDSRADOConnection.DoConnect :- Error connecting ADO objects. Error: '
        + e.Message);
      _LogMSG('TDSRADOConnection.DoConnect :- The application has failed connecting the database through ADO...');
    End;
  End;

  If DefaultDatabase <> '' Then
    If Assigned(ConnectionObject) Then
      ConnectionObject.DefaultDatabase := DefaultDatabase;
End;
{$ENDIF}

{ TADODSR }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TADODSR.Create(Const pServer: String; Const pStartUp: Boolean = False);
Begin
{$IFDEF debug}
  Try
    Inherited Create(Nil);
  Except
    On e: exception Do
      _LogMSG('TADODSR.Create :- Error inheriting the object. Error: ' + e.message);
  End;

{$ELSE}
  Inherited Create(Nil);
{$ENDIF}

  fLog := _Base.Create;

// CJS - 13/11/2007 - defaulted instance name (under SQL Express 2005, there
//                    must be an instance name).
{
  if Pos('\', pServer) = 0 then
    fInstance := 'IRISSOFTWARE'
  else
    fInstance := Copy(pServer, Pos('\', pServer) + 1, Length(pServer));

  fServer := Copy(pServer, 1, Pos('\', pServer) - 1);
  fMSSQLSERVER := Format(cSQLIRISSERVICE, [finstance]);
}

// CJS - 23/10/2008 - the rules have changed. The GovLink service should accept
//                    a server without an instance name (i.e. the default
//                    instance). Reinstated the original code.
  If Pos('\', pServer) > 0 Then
  Begin // installation where user typed an instance name
    fServer := Copy(pServer, 1, Pos('\', pServer) - 1);
    fInstance := Copy(pServer, Pos('\', pServer) + 1, Length(pServer));
    fMSSQLSERVER := Format(cSQLIRISSERVICE, [finstance]);
  End
  Else
  Begin // default ms sql installation
    fServer := pServer;
    fInstance := '';
    fMSSQLSERVER := cDEFAULTSQLSERVERNAME;
  End;

  {check sql server connections}
  If Not CheckServiceStatus Then
  Try
    //_ServiceStatus(cSQLIRISSERVICE, Server, True);
    _ServiceStatus(fMSSQLSERVER, Server, True);
  Except
  End;

  {create ado connection}
  Try
    fADOConnection := TDSRADOConnection.Create(Nil);
  Except
    On e: exception Do
      _LogMSG('TADODSR.Create :- Error Creating ADO connection. Error: ' +
        e.Message);
  End; {try}

  {only update when requested (ex.: starting client sync}
  If pStartUp Then
    {check if the database exists}
    If Not DBExists(cICEDATABASE) Then
    Begin
      _LogMSG('TADODSR.Create :- The IRISCommunicationEngine database does not exist.');
      _LogMSG('TADODSR.Create :- Checking Database updates...');

      If _FileSize(_GetApplicationPath + cDSRCREATEDBFILE) > 0 Then
        UpdateDatabase(_GetApplicationPath + cDSRCREATEDBFILE, True)
      Else
        _LogMSG('TADODSR.Create :- No Database updates found...');

      Try
        //_ServiceStatus(cSQLIRISSERVICE, Server, False, True);
        _ServiceStatus(fMSSQLSERVER, Server, False, True);
      Finally
        Connected := False;
        Sleep(5000);
      End;
    End; {if GetDbFileName = '' then}

  {test connection}
  Try
    TestConnection(pStartUp);
  Except
    On e: exception Do
      _LogMSG('TADODSR.Create :- Error testing connection. Error: ' + e.Message);
  End;

  {check start up and if db exists again for update }
  If pStartUp Then
    If DBExists(cICEDATABASE) Then
    Begin
      _LogMSG('TADODSR.Create :- Checking Database updates...');
      If _FileSize(_GetApplicationPath + cDSRUPDATEDBFILE) > 0 Then
      Begin
        UpdateDatabase(_GetApplicationPath + cDSRUPDATEDBFILE);

        _Delay(2000);
        Try
          //_ServiceStatus(cSQLIRISSERVICE, Server, False, True);
          _ServiceStatus(fMSSQLSERVER, Server, False, True);
        Finally
          Connected := False;
          Sleep(5000);
        End;
      End
      Else
        _LogMSG('TADODSR.Create :- No Database updates found...');
    End; {If DBExists(cICEDATABASE) Then}

  If pStartUp Then
    {retest connection}
    If Not CheckServiceStatus Or Not Connected Then
    Try
      TestConnection(pStartUp);
    Except
      On e: exception Do
        _LogMSG('TADODSR.Create :- Error testing connection. Error: ' + e.Message);
    End;

  Try
    GetDateFormat;
  Except
    On e: exception Do
      _LogMSG('Error loading DB date formats. Error: ' + e.Message);
  End;

  {init this section. i have to do this to avoid threads selecting something
  without any initialization on ado stuff}
  Try
    SearchCompany(0);
  Except
    On e: exception Do
      _LogMSG('Error searching and initializing database. Error: ' + e.Message);
  End; {try}

  {test if connected}
  If Connected Then
  Begin
    fLog.ConnectionString := fADOConnection.ConnectionString;
    {set manager password}

    If GetAdminPassword = '' Then
      SetAdminPassWord(cADMINPASS);
  End {If fADOConnection.Connected Then}
  Else
    _LogMSG('TADODSR.Create :- The Database object is not connected.');
End;

{-----------------------------------------------------------------------------
  Procedure: TestConnection
  Author:    vmoura

  test the database connection using the the connection string provided
-----------------------------------------------------------------------------}
Function TADODSR.TestConnection(Const pStartUp: Boolean = False): Boolean;
  Procedure _LogAdoErrors;
  Var
    lCont: integer;
  Begin
    If Assigned(fADOConnection) Then
      If Assigned(fADOConnection.Errors) Then
      Try
        For lCont := 0 To fADOConnection.Errors.Count - 1 Do
        Begin
          _LogMSG('TADODSR.TestConnection :- Error found connecting ADO. Error [Number]: '
            + inttostr(fADOConnection.Errors.Item[lCont].Number));
          _LogMSG('TADODSR.TestConnection :- Error found connecting ADO. Error [Source]: '
            + fADOConnection.Errors.Item[lCont].Source);
          _LogMSG('TADODSR.TestConnection :- Error found connecting ADO. Error [Description]: '
            + fADOConnection.Errors.Item[lCont].Description);
          _LogMSG('TADODSR.TestConnection :- Error found connecting ADO. Error [SQL State]: '
            + fADOConnection.Errors.Item[lCont].SQLState);
        End;
      Except
      End;
  End; {Procedure _LogAdoErrors;}

Var
  lCont: Integer;

Begin
  _CallDebugLog('Testing connection - checking service');
  Result := False;
  lCont := 0;

  {try to restart the sql service}
  If Assigned(fADOConnection) Then
  Begin
    {sometimes we get problems connecting the database because the sql server
    has not been completedly started. So rather then keep going, we will test the server
    and check for 3 times or until the connection is made}
    While (lCont < 4) And Not fADOConnection.Connected Do
    Begin
      Try
        {check the sql server service and start it if not running}
        If Not CheckServiceStatus Then
          //_ServiceStatus(cSQLIRISSERVICE, Server, True);
          _ServiceStatus(fMSSQLSERVER, Server, True);
      Except
        On e: exception Do
          _LogMSG('TADODSR.TestConnection :- Error starting SQL Server service. Error: '
            + e.Message);
      End; {try}

      If fADOConnection.Connected Then
      Try
        fADOConnection.Connected := False;
      Except
        On e: exception Do
          _LogMSG('TADODSR.TestConnection :- Error setting Database connection status. Error: '
            + e.Message);
      End;

      Try
        Try
         {try the first connection string using server}

          If Trim(Instance) = '' Then
            fADOConnection.ConnectionString := Format(cADOCONNECTIONSTR1, [Server,
              cICEDBPWD, cICEDBUSER])
          Else
            fADOConnection.ConnectionString := Format(cADOCONNECTIONSTR1, [Server +
              '\' + Instance, cICEDBPWD, cICEDBUSER]);

          _CallDebugLog('Testing connection :- trying a connection');
      {open a connection}
          Try
            fADOConnection.Connected := True;
          Except
            On E: exception Do
            Begin
              _LogMSG('TADODSR.TestConnection :- Error trying to connect ADO Object. Error: '
                + e.message);
              _LogAdoErrors;
            End; {begin}
          End; {try}
        Finally
          If Not fADOConnection.Connected Then
          Begin
        {try the connection without the slash}
            Try
              If Not CheckServiceStatus Then
                //_ServiceStatus(cSQLIRISSERVICE, Server, True);
                _ServiceStatus(fMSSQLSERVER, Server, True);
            Except
              On e: exception Do
                _LogMSG('TADODSR.TestConnection :- Error starting SQL SERVER service. Error: '
                  + e.Message);
            End;
          End; {If Not fADOConnection.Connected Then}
        End; {first try connection}
      Finally
        Result := Connected;
      End;

      _CallDebugLog('Testing connection - result connection = ' +
        inttostr(Ord(Result)));

      If Assigned(fADOConnection) Then
        ConnectionString := fADOConnection.ConnectionString;

      Inc(lCont);

      {this variable is usefull for dashboard and the dsr.dll when they are loading for the
      first time. normal objects that are just trying a connection don't need to check the database}
      If Not pStartUp Then
        Break;

      If Not Result Then
        _Delay(5000);
    End; {While (lCont < 3) Or Not fADOConnection.Connected Then}
  End {if Assigned(fADOConnection) then}
  Else
  Begin
    _LogMSG('Database ADO Object not assigned...');
    Result := False;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: CheckServiceStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.CheckServiceStatus: Boolean;
Begin
  // Result := _ServiceStatus(cSQLIRISSERVICE, Server, False) = $00000004;
  Result := _ServiceStatus(fMSSQLSERVER, Server, False) = $00000004;
End;

{-----------------------------------------------------------------------------
  Procedure: GetAdminPassword
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetAdminPassword: String;
Var
  lSql: String;
Begin
  Result := '';
  lSql := ' select value from system where description = ' + QuotedStr(cADMINUSER);
  If RecordExists(lSql, False) Then
    Result := _DecryptString(FieldByName('value').AsString);
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: SetAdminPassWord
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetAdminPassWord(Const pPassw: String);
Var
  lPass,
    lSql: String;
Begin
  lPass := GetAdminPassword;

  If lPass = '' Then
    lSql := ' insert into system (description, value) values (' +
      QuotedStr(Lowercase(cADMINUSER)) + ', ' + QuotedStr(cADMINPASS)
      + ')'
  Else
    lSql := ' update system set value = ' + QuotedStr(_EncryptString(pPassw)) +
      ' where description = ' + QuotedStr(cADMINUSER);

  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TADODSR.Destroy;
Begin
  CloseAndClearSql;
  FreeAndNil(fLog);

  Try
    //fADOConnection.Close;
    If Assigned(fADOConnection) Then
      FreeAndNil(fADOConnection);
  Except
    //FreeAndNil(fADOConnection);
  End;

  Inherited Destroy;
End;

///////////////////// GENERAL FUNCTIONS //////////////////////
{-----------------------------------------------------------------------------
  Procedure: CloseAndClearSql
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.CloseAndClearSql;
Begin
  Try
    Close;
  Except
  End;

  SQL.Clear;
End;

{-----------------------------------------------------------------------------
  Procedure: Exec
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.Exec(Const pSql: String; Const pCheckResult: Boolean =
  False): Boolean;
Begin
  // clear and close the sql
  Result := False;
  CloseAndClearSql;

  If Connected Then
  Begin
    If pSql <> '' Then
    Begin
      Try
        SQL.Add(pSql);

        If pCheckResult Then
        Begin
          Try
            Result := ExecSQL > 0
          Except
            On e: Exception Do
            Begin
              fLog.DoLogMessage('TADODSR.Exec', cUPDATINGDBERROR, 'Error: ' +
                e.Message, true, true);
              fLog.DoLogMessage('TADODSR.Exec', 0, 'SQL: ' + pSql);
              If Not CheckServiceStatus Then
                TestConnection;
            End;
          End; {try}
        End
        Else
        Begin
        { deleting a record that doesnt existe into the database, the result is zero}
          Try
            ExecSQL;
          Except
            On e: Exception Do
            Begin
              fLog.DoLogMessage('TADODSR.Exec', cUPDATINGDBERROR, 'Error: ' +
                e.Message, true, true);
              fLog.DoLogMessage('TADODSR.Exec', 0, 'SQL: ' + pSql);
              If Not CheckServiceStatus Then
                TestConnection;
            End; {begin}
          End; {try}

          Result := True;
        End;
      Except
        On e: Exception Do
        Begin
          fLog.DoLogMessage('TADODSR.Exec', cUPDATINGDBERROR, 'Error: ' +
            e.Message, true, true);
          fLog.DoLogMessage('TADODSR.Exec', 0, 'SQL: ' + pSql);
        End; {begin}
      End; {try}
    End {If pSql <> '' Then}
    Else
      fLog.DoLogMessage('TADODSR.RecordExists', cDBERROR, 'Blank Sql', True,
        True);

    CloseAndClearSql;
  End
  Else
    fLog.DoLogMessage('TADODSR.Exec', cCONNECTINGDBERROR,
      'Database not connected');

End;

{-----------------------------------------------------------------------------
  Procedure: GetTotalFiles
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetTotalFiles(pGuid: TGuid): Integer;
Var
  lSql: String;
Begin
  Result := 0;
  lSql := ' select totalitems from inbox where guid = ' +
    QuotedStr(GUIDToString(pGuid));
  If RecordExists(lSql, False) Then
  Try
    Result := Fields[0].AsInteger
  Except
    On e: Exception Do
      fLog.DologMessage('TADODSR.GetTotalFiles', cDBERROR,
        'Error Loading total files: ' + e.message, True, True);
  End;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: RecordExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.RecordExists(Const pSql: String; Const pCloseTable: Boolean):
  Boolean;
Begin
  Result := False;
  CloseAndClearSql;

  If Connected Then
  Begin
    {check the sql command}
    If pSql <> '' Then
    Begin
      Try
        {sometimes, it gets an erros adding the sql command to sql variable. so, try it!!}
        Try
          SQL.Add(pSql);
        Except
          On e: Exception Do
          Begin
            fLog.DoLogMessage('TADODSR.RecordExists', cDBERROR,
              'Error adding SQL. Class: ' + e.ClassName + '. Error: ' +
              e.Message, True, True);
            fLog.DoLogMessage('TADODSR.RecordExists', 0, 'SQL: ' + pSql);
          End; {begin}
        End; {try}

        {open the query}
        Try
          If Sql.Text <> '' Then
            Open;
        Except
          On e: exception Do
          Begin
            fLog.DoLogMessage('TADODSR.RecordExists', cDBERROR,
              'Error opening SQL. Class: ' + e.ClassName + '. Error: ' +
              e.Message, True, True);
            fLog.DoLogMessage('TADODSR.RecordExists', 0, 'SQL: ' + pSql);

            If Not CheckServiceStatus Then
              TestConnection;
          End; {begin}
        End; {try}

      { check the result}
        Result := Active And Not IsEmpty;
      Except
        On e: exception Do
        Begin
          fLog.DoLogMessage('TADODSR.RecordExists', cDBERROR,
            'Error testing SQL Active. Error: ' + e.Message, True, True);
          fLog.DoLogMessage('TADODSR.RecordExists', 0, 'SQL: ' + pSql);
        End; {begin}
      End {try}
    End {If pSql <> '' Then}
    Else
      fLog.DoLogMessage('TADODSR.RecordExists', cDBERROR, 'Blank Sql', True,
        True);

    If pCloseTable Then
      CloseAndClearSql;
  End
  Else
    fLog.DoLogMessage('TADODSR.RecordExists', cCONNECTINGDBERROR,
      'Database not connected');
End;

////////////////////////// INBOX FUNCTIONS ///////////////////////////
{-----------------------------------------------------------------------------
  Procedure: SearchInboxCompanyId
  Author:    vmoura
-----------------------------------------------------------------------------}
(*Function TADODSR.SearchInboxCompanyId(pGuid: TGuid): Integer;
Begin
  If RecordExists('select company_id from inbox where guid = ' +
    QuotedStr(GUIDToString(pGuid)), False) Then
    Result := Fieldbyname('company_id').AsInteger
  Else
    Result := -1;

  CloseAndClearSql;
End;*)

{-----------------------------------------------------------------------------
  Procedure: SearchInboxEntry
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.SearchInboxEntry(pGuid: TGuid): Integer;
Begin
  If RecordExists('select id from inbox where guid = ' +
    QuotedStr(GUIDToString(pGuid)), False) Then
    Result := fieldbyname('id').AsInteger
  Else
    Result := -1;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateInBox
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.UpdateInBox(pGuid: TGuid; pCompanyId: Integer; Const pSubj,
  pUserFrom, pUserto: WideString; pPackId: Integer; pTotal, pStatus, pMode:
  Smallint; pAction: TDBOption): Boolean;
Var
  lSql: String;
Begin
  Result := True;
  Case pAction Of
    {only update few fields of the table}
    dbDoUpdate:
      Begin
        lSql := 'update inbox ';
        lSql := lSql + ' set status = ' + inttostr(pStatus) +
          ' , lastupdate = getdate() ';

        If pTotal > 0 Then
          lSql := lSql + ' , totalitems = ' + inttostr(pTotal);

        If pCompanyId > 0 Then
          lSql := lSql + ' , company_id = ' + inttostr(pCompanyId);

        If pPackId > 0 Then
          lSql := lSql + ' , package_id = ' + inttostr(pPackId);

        If pMode >= 0 Then
          lSql := lSql + ' , mode = ' + inttostr(pMode);

        lSql := lSql + ' where guid = ' + QuotedStr(GUIDToString(pGuid));

        Result := Exec(lSql, True);
      End; {dbDoUpdate begin}
    {add an new entry}
    dbDoAdd:
      Begin
        lSql := 'insert into inbox (guid, company_id, subject, userfrom, userto,  '
          + ' package_id, totalitems, status, mode, received, lastupdate) values ';

        lSql := lSql + ' (' + QuotedStr(GUIDToString(pGuid)) + ', ' +
          inttostr(pCompanyId) + ', ' + QuotedStr(Copy(Trim(pSubj), 1, 255)) +
          ', ' + QuotedStr(Trim(pUserFrom)) + ', ' + QuotedStr(Trim(pUserto)) +
          ', ' + inttostr(pPackId) + ', ' + inttostr(pTotal) + ', ' +
          inttostr(pStatus) + ', ' + inttostr(pMode) + ', getdate(), getdate()) ';

        Result := Exec(lSql, True);
      End; {dbDoAdd begin}
      {delete an specified guid}
    dbDoDelete:
      Begin
        lSql := 'delete from inbox where guid = ' + QuotedStr(GUIDToString(pGuid));
        Result := Exec(lSql, False);
      End; {dbDoDelete begin}
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: ChangeInboxGuid
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.ChangeInboxGuid(pId: Longword; pNewGuid: TGuid): Boolean;
Var
  lSql: String;
Begin
  lSql := ' update inbox set guid = ' + QuotedStr(GUIDToString(pNewGuid));
  lSql := lSql + ' where id = ' + inttostr(pId);
  Result := Exec(lSql, True);
End;

{-----------------------------------------------------------------------------
  Procedure: GetInboxMessageStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetInboxMessageStatus(pGuid: TGuid): Integer;
Var
  lMsg: TMessageInfo;
Begin
  Result := -1;
  lMsg := GetInboxMessage(pGuid);
  If lMsg <> Nil Then
  Begin
    Result := lMsg.Status;
    FreeAndNil(lMsg);
  End; {If lMsg <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: InboxMessageStatusExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.InboxMessageStatusExists(pCompany: Longword; pStatus:
  Smallint): Boolean;
Var
  lSql: String;
Begin
  lSql := ' select id from inbox where 1=1 ';
  If pCompany > 0 Then
    lSql := lSql + ' and company_id = ' + inttostr(pCompany);

  lSql := lSql + ' and status = ' + inttostr(pStatus);
  Result := RecordExists(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: InbboxMessageProcessing
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.InboxMessageProcessing(pCompany: Longword): Boolean;
Var
  lSql: String;
Begin
  lSql := ' select id from inbox where 1=1 ';

  If pCompany > 0 Then
    lSql := lSql + ' and company_id = ' + inttostr(pCompany);

  lSql := lSql + ' and status in (' + inttostr(cLOADINGFILES) + ', ' +
    inttostr(cPOPULATING) + ', ' + inttostr(cCHECKING) + ')';

  Result := RecordExists(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: InboxMessageModeExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.InboxMessageModeExists(pCompany: Longword; pMode: TRecordMode):
  Boolean;
Var
  lSql: String;
Begin
  lSql := ' select id from inbox where company_id = ' + inttostr(pCompany);
  lSql := lSql + ' and mode = ' + IntToStr(Ord(pMode));
  lSql := lSql + ' and status not in (' + Inttostr(cARCHIVED) + ', ' +
    inttostr(cDELETED) + ') ';
  Result := RecordExists(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: SetInboxMessageStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetInboxMessageStatus(pGuid: TGuid; pStatus: Integer);
Begin
  UpdateInBox(pGuid, 0, '', '', '', 0, 0, pStatus, -1, dbDoUpdate);
End;

{-----------------------------------------------------------------------------
  Procedure: GetInboxCompanyId
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetInboxCompanyId(pGuid: TGuid): Integer;
Var
  lMsg: TMessageInfo;
Begin
  Result := 0;
  lMsg := GetInboxMessage(pGuid);

  If lMsg <> Nil Then
  Begin
    Result := lMsg.Company_Id;
    FreeAndNil(lMsg);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: GetInboxMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetInboxMessage(pGuid: TGuid): TMessageInfo;
Var
  lSql: String;
Begin
  Result := Nil;
  lSql := 'select * from inbox where guid = ' + QuotedStr(GUIDToString(pGuid));

  If RecordExists(lSql, False) Then
  Begin
    Try
      Result := TMessageInfo.Create;
      Result.Guid := _SafeStringToGuid(Fieldbyname('guid').asString);
      Result.Company_Id := Fieldbyname('company_id').Asinteger;
      Result.Subject := Fieldbyname('subject').AsString;
      Result.From := Fieldbyname('userfrom').AsString;
      Result.To_ := Fieldbyname('userto').AsString;
      Result.Pack_Id := FieldByName('package_id').AsInteger;
      Result.Status := FieldByName('status').AsInteger;
      Result.TotalItens := FieldByName('totalitems').AsInteger;
      Result.Date := FieldByName('received').AsDateTime;
      Result.Mode := FieldByName('mode').AsInteger;
      Result.TotalDone := FieldByName('totaldone').AsInteger;
    Except
      On e: exception Do
      Begin
        Result := Nil;
        fLog.DoLogMessage('TADODSR.GetInboxMessage', cDBERROR,
          'Error processing request. Error: ' + e.message, True, True);
      End;
    End;
  End;
//  Else
//    fLog.DoLogMessage('TADODSR.GetInboxMessage', cDBNORECORDFOUND, '');
End;

{-----------------------------------------------------------------------------
  Procedure: GetFirstInboxMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetFirstInboxMessage(pCompany: Longword): TMessageInfo;
Var
  lSql: String;
Begin
  Result := Nil;
  lSql := 'select top(1) * from inbox where company_id = ' + inttostr(pCompany)
    + ' order by id asc';

  If RecordExists(lSql, False) Then
  Begin
    Try
      Result := GetInboxMessage(StringToGUID(FieldByName('guid').asstring))
    Except
      On e: Exception Do
      Begin
        Result := Nil;
        fLog.DoLogMessage('TADODSR.GetFirstInboxMessage', cDBERROR,
          'Error processing request. Error: ' + e.message, True, True);
      End;
    End;
  End;
//  Else
//    fLog.DoLogMessage('TADODSR.GetFirstInboxMessage', cDBNORECORDFOUND, '');

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetTopInboxMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetTopInboxMessage(pCompany: Longword): TMessageInfo;
Var
  lSql: String;
Begin
  Result := Nil;
  lSql := 'select top(1) * from inbox where company_id = ' + inttostr(pCompany);
  //lSql := lSql + ' and status <> ' + inttostr(cARCHIVED);
  lSql := lSql + ' and status not in (' + Inttostr(cARCHIVED) + ', ' +
    inttostr(cDELETED) + ') ';

  lSql := lSql + ' order by id desc';

  If RecordExists(lSql, False) Then
  Begin
    Try
      Result := GetInboxMessage(StringToGUID(FieldByName('guid').AsString))
    Except
      On e: exception Do
      Begin
        Result := Nil;
        fLog.DoLogMessage('TADODSR.GetInboxMessage', cDBERROR,
          'Error processing request. Error: ' + e.message, True, True);
      End;
    End;
  End; {If RecordExists(lSql, False) Then}
//  Else
//    fLog.DoLogMessage('TADODSR.GetInboxMessage', cDBNORECORDFOUND, '', True, False);

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetLastInboxUpdate
  Author:    vmoura

  verify when the inbox table was updated
-----------------------------------------------------------------------------}
Function TADODSR.GetLastInboxUpdate: TDateTime;
Var
  lSql: String;
Begin
  Result := 0;
  lsql := ' select max(lastupdate) from inbox';
  If RecordExists(lsql, False) Then
  Try
    Result := Fields[0].AsDateTime;
  Except
  End;
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: ChangeInboxStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.ChangeInboxStatus(pCompany, pFromStatus, pToStatus: Integer);
Var
  lSql: String;
Begin
  lSql := ' update inbox set status = ' + inttostr(pToStatus);
  lSql := lSql + ' where 1=1 ';
  If pCompany > 0 Then
    lSql := lSql + ' and company_id = ' + inttostr(pCompany);

  lSql := lSql + ' and status = ' + inttostr(pFromStatus);
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: GetInboxMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetInboxMessages(pCompany: Integer; pPackId: Longword;
  pStatus: Smallint; pDate: TDatetime; pMaxRecords: Longword; Out pResult:
  LongWord; Const pLogMessage: Boolean): OleVariant;
Var
  lSql: String;
Begin
  Result := Null;
  pResult := S_OK;

  If pMaxRecords > 0 Then
    lSql := 'select top(' + inttostr(pMaxRecords) + ') * from inbox '
  Else
    lSql := 'select * from inbox  ';

  lSql := lsql + ' where 1=1 ';

  {get message according to status}
  If pStatus >= 0 Then
  Begin
    If pStatus = cALLNEW Then
      lSql := lSql + ' and status in (' + inttostr(cNEWENTRY) + ', ' +
        inttostr(cREADYIMPORT) + ') '
    Else If pStatus = cALLRECYCLE Then
      lSql := lSql + ' and status in (' + inttostr(cDELETED) + ', ' +
        inttostr(cFAILED) + ') '
    Else
      lSql := lSql + ' and status = ' + inttostr(pStatus);
  End
  Else
    lSql := lSql + ' and status not in (' + Inttostr(cARCHIVED) + ', ' +
      inttostr(cDELETED) + ') ';

  If pCompany >= 0 Then
    lSql := lSql + ' and company_id = ' + inttostr(pCompany);

  // test and validate date param
  If (pDate > 0) And IsValidDate(YearOf(pDate), MonthOf(pDate), DayOf(pDate)) Then
    lSql := lsql + ' and received >= ' + QuotedStr(datetimetostr(pDate));

  // test packId
  If pPackId > 0 Then
    lSql := lSql + ' and package_id = ' + inttostr(pPackId);

  lSql := lSql + ' order by received desc ';

  Result := GetInboxMessagesBySql(lSql, pResult);

  If pLogMessage And (pResult <> S_OK) Then
    If pResult <> cDBNORECORDFOUND Then
      fLog.DologMessage('TADODSR.GetInboxMessages', 0, 'No records found ' +
        lsql, True, True);

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetInboxMessagesBySql
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetInboxMessagesBySql(Const pSql: String; Out pResult:
  Longword): OleVariant;
Var
  lCount: Integer;
Begin
  Result := Null;
  pResult := S_OK;
  { find out about the records been requested}
  If RecordExists(pSql, False) Then
  Begin
    First;
    lCount := 0;
    Result := VarArrayCreate([0, RecordCount], varVariant);

    { the reason why the dsr has been using olevariant is that the server (c#) application
    get some dificulties to implement the interfaces. So, an easy and weel known
    array of variants will be enough to all kind of application}
    While Not Eof Do
    Begin
      Result[lCount] := VarArrayOf([
        fieldbyname('guid').asString,
          fieldbyname('company_id').Asinteger,
          fieldbyname('subject').AsString,
          fieldbyname('userfrom').AsString,
          fieldbyname('userto').AsString,
          FieldByName('package_id').AsInteger,
          FieldByName('status').AsInteger,
          FieldByName('totalitems').AsInteger,
          FieldByName('received').AsDateTime,
          FieldByName('mode').asInteger,
          FieldbyName('totaldone').asInteger
          ]);

      Next;
      Inc(lCount);
    End;
  End
  Else
    pResult := cDBNORECORDFOUND;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessOldInboxMails
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.ProcessOldInboxMails;
Var
  lSql: String;
  lIn: OleVariant;
  lResult: Longword;
  lCont,
    lTotal: Integer;
  lMail: TMessageInfo;
Begin
  lSql := 'select * from inbox where status in (' + inttostr(cNEWENTRY) + ', ' +
    inttostr(cRECEIVINGDATA) + ', ' + inttostr(cPROCESSING) + ', ' +
    inttostr(cPOPULATING) + ', ' + inttostr(cBULKPROCESSING) + ') ';

  lSql := lSql + ' and datediff(hh, received, getdate()) > 23 ';
//  lSql := lSql + ' and datediff(hh, lastupdate, getdate()) > 23 ';

  lIn := GetInboxMessagesBySql(lSql, lResult);
  lTotal := _GetOlevariantArraySize(lIn);

  {check the result of the query and start processing and changing the status of the message to failed}
  If (lTotal > 0) And (lResult = S_OK) Then
    For lCont := 0 To lTotal - 1 Do
    Begin
      Try
        lMail := _CreateInboxMsgInfo(lIn[lCont]);
        If Assigned(lMail) Then
          UpdateInBox(lMail.Guid, 0, '', '', '', 0, 0, cFAILED, -1, dbDoUpdate);
      Finally
        If Assigned(lMail) Then
          FreeAndNil(lMail);
      End;
    End; {For lCont := 0 To lTotal - 1 Do}

  lIn := null;
End;

{-----------------------------------------------------------------------------
  Procedure: SetInboxTotalDone
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetInboxTotalDone(pGuid: TGuid; pValue: Integer);
Var
  lSql: String;
Begin
  lSql := ' update inbox set totaldone = ' + inttostr(IfThen(pValue > 100, 100,
    pValue));
  lSql := lSql + ' , lastupdate = getdate() ';
  lSql := lSql + ' where guid = ' + QuotedStr(GUIDToString(pGuid));
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: SetOutboxTotalDone
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetOutboxTotalDone(pGuid: TGuid; pValue: Integer);
Var
  lSql: String;
Begin
  lSql := ' update outbox set totaldone = ' + inttostr(IfThen(pValue > 100, 100,
    pValue));
  lSql := lSql + ' , lastupdate = getdate() ';
  lSql := lSql + ' where guid = ' + QuotedStr(GUIDToString(pGuid));
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: SetInboxMessageToCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetTotalInboxMessages(pCompany: Integer; Const pStatus:
  Smallint = 0): Longword;
Var
  lSql: String;
Begin
  Result := 0;

  lSql := ' select count(id) from inbox where 1=1 ';
  If pCompany >= 0 Then
    lSql := lSql + ' and company_id = ' + inttostr(pCompany);

  If pStatus > 0 Then
  Begin
    If pStatus = cALLNEW Then
      lSql := lSql + ' and status in (' + inttostr(cNEWENTRY) + ', ' +
        inttostr(cREADYIMPORT) + ') '
    Else If pStatus = cALLRECYCLE Then
      lSql := lSql + ' and status in (' + inttostr(cDELETED) + ', ' +
        inttostr(cFAILED) + ') '
    Else
      lSql := lSql + ' and status = ' + inttostr(pStatus);
  End
  Else
    lSql := lSql + ' and status not in (' + Inttostr(cARCHIVED) + ', ' +
      inttostr(cDELETED) + ') ';

  If RecordExists(lSql, False) Then
    Result := Fields[0].AsInteger;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetTotalInboxSyncMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetTotalInboxSyncMessages(pCompany: Integer): Longword;
Var
  lSql: String;
Begin
  Result := 0;

  lSql := ' select count(id) from inbox where 1=1 ';
  If pCompany >= 0 Then
    lSql := lSql + ' and company_id = ' + inttostr(pCompany);

  lSql := lSql + ' and status in (' + inttostr(cSYNCDENIED) + ', ' +
    inttostr(cSYNCFAILED) + ', ' +
    inttostr(cREMOVESYNC) + ', ' +
    inttostr(cSYNCACCEPTED) + ') ';

  If RecordExists(lSql, False) Then
    Result := Fields[0].AsInteger;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: SetInboxMessageToCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetInboxMessageToCompany(pGuid: TGUID; pCompany: LongWord; Out
  pResult: LongWord);
Var
  lSql: String;
Begin
  { search for inbox entry}
  If SearchInboxEntry(pGuid) > 0 Then
  Begin
    {  the company must exists}
    If SearchCompany(pCompany) Then
    Begin
      { search if this message already has a company_id}
      lSql := 'update inbox set company_id = ' + inttostr(pCompany);
      lSql := lsql + ' where guid = ' + QuotedStr(GUIDToString(pGuid));
      { update the message}
      If Exec(lSql) Then
        pResult := S_OK
      Else
        pResult := cDBERROR;
    End; { If SearchCompany(pCompany) Then}
  End { If SearchInboxEntry(pGuid) > 0 Then}
  Else
    pResult := cDBNORECORDFOUND;
End;

///////////////////////// OUTBOX FUNCTIONS ////////////////////////

{-----------------------------------------------------------------------------
  Procedure: OutboxMessageStatusExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.OutboxMessageStatusExists(pCompany: Longword; pStatus:
  Smallint): Boolean;
Var
  lSql: String;
Begin
  lSql := ' select id from outbox where 1=1 ';

  If pCompany > 0 Then
    lSql := lSql + ' and company_id = ' + inttostr(pCompany);

  lSql := lSql + ' and status = ' + inttostr(pStatus);
  Result := RecordExists(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: OutboxMessageProcessing
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.OutboxMessageProcessing(pCompany: Longword): Boolean;
Var
  lSql: String;
Begin
  lSql := ' select id from outbox where 1=1 ';

  If pCompany > 0 Then
    lSql := lSql + ' and company_id = ' + inttostr(pCompany);

  lSql := lSql + ' and status in (' + inttostr(cBULKPROCESSING) + ', ' +
    Inttostr(cLOADINGFILES) + ', ' + Inttostr(cCHECKING) + ', ' +
    IntToStr(cSENDING) + ')';

  Result := RecordExists(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: GetOutboxCompanyId
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetOutboxCompanyId(pGuid: TGuid): Integer;
Var
  lMsg: TMessageInfo;
Begin
  Result := 0;
  lMsg := GetOutboxMessage(pGuid);

  If lMsg <> Nil Then
  Begin
    Result := lMsg.Company_Id;
    FreeAndNil(lMsg);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SearchOutboxEntry
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.SearchOutboxEntry(pGuid: TGuid): Integer;
Begin
  If RecordExists('select id from outbox where guid = ' +
    QuotedStr(GUIDToString(pGuid)), False) Then
    Result := Fieldbyname('id').AsInteger
  Else
    Result := -1;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateOutBox
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.UpdateOutBox(pGuid: TGuid; pCompany: Longword; Const pSubj,
  pUserFrom, pUserto: WideString; pPackId: LongWord; pTotal:
  Smallint; Const pParam1, pParam2: WideString; pStatus, pMode: Smallint;
  pAction: TDBOption): Boolean;
Var
  lSql: String;
  lP1, lP2: String;
Begin
  Result := True;

  // choose what option to update the database
  Case pAction Of
    dbDoUpdate:
      Begin
        lSql := 'update outbox ';
        lSql := lSql + ' set status = ' + inttostr(pStatus) +
          ' , lastupdate = getdate() ';

        If pTotal > 0 Then
          lSql := lSql + ' , totalitems = ' + inttostr(pTotal);

        If pMode >= 0 Then
          lSql := lSql + ', mode = ' + inttostr(pMode);

        If pUserto <> '' Then
          lSql := lSql + ', userto = ' + QuotedStr(pUserto);

        lSql := lSql + ' where guid = ' + QuotedStr(GUIDToString(pGuid));

        Result := Exec(lSql, True);
      End;
    dbDoAdd:
      Begin
        lP1 := Copy(pParam1, 1, 50);
        lP2 := Copy(pParam2, 1, 50);

        lSql := 'insert into outbox (guid, company_id, subject, userfrom, userto, '
          + ' package_id, totalitems, status, param1, param2, ' +
          ' mode, sent, lastupdate) values ';

        lSql := lSql + ' (' + QuotedStr(GUIDToString(pGuid)) + ', ' +
          inttostr(pCompany) + ', ' + QuotedStr(Trim(pSubj)) + ', ' +
          QuotedStr(Trim(pUserFrom)) + ', ' + QuotedStr(Copy(Trim(pUserTo), 1,
          255)) + ', ' + inttostr(pPackId) + ', ' + inttostr(pTotal) + ', ' +
          inttostr(pStatus) + ', ' + QuotedStr(lP1) + ', ' + QuotedStr(lP2) +
          ', ' + inttostr(ord(pMode)) + ', getdate(), getdate()) ';
        Result := Exec(lSql, True);
      End;
    dbDoDelete:
      Begin
        lSql := 'delete from outbox where guid = ' +
          QuotedStr(GUIDToString(pGuid));
        Result := Exec(lSql);
      End;
  End; {Case pAction Of}

End;

{-----------------------------------------------------------------------------
  Procedure: UpdateOutboxSentDate
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.UpdateOutboxSentDate(pGuid: TGuid; pDate: TDateTime): Boolean;
Var
  lSql: String;
Begin
  lSql := 'update outbox set sent = ' + QuotedStr(DateTimeToSQLDateTime(pDate));
  lSql := lSql + ' where guid = ' + QuotedStr(GUIDToString(pGuid));
  Result := Exec(lSql, True);
End;

{-----------------------------------------------------------------------------
  Procedure: GetOutboxMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetOutboxMessages(pCompany: Integer; pPackId: Longword;
  pStatus: Smallint; pDate: TDatetime; pMaxRecords: Longword; Out pResult:
  LongWord; Const pLogMessage: Boolean): OleVariant;
Var
  lSql: String;
Begin
  pResult := S_OK;
  Result := null;

  If pMaxRecords > 0 Then
    lSql := 'select top(' + inttostr(pMaxRecords) +
      ') o.*, s.id as schedule from outbox o '
  Else
    lSql := 'select o.*, s.id as schedule from outbox o ';

  lSql := lSql + ' left join schedule s on (o.guid = s.outbox_guid) ';
  lSql := lSql + ' where 1=1 ';

  If pCompany > 0 Then
    lSql := lSql + ' and o.company_id = ' + inttostr(pCompany);

  { test and validate the date param}
  If (pDate > 0) And IsValidDate(YearOf(pDate), MonthOf(pDate), DayOf(pDate)) Then
    lSql := lsql + ' and o.sent >= ' + QuotedStr(datetimetostr(pDate));

  { test message type}
  If ppackId > 0 Then
    lSql := lSql + ' and o.package_id = ' + inttostr(pPackId);

  { test status of the message}
  If pStatus > 0 Then
  Begin
    If pStatus = cALLRECYCLE Then
      lSql := lSql + ' and o.status in (' + inttostr(cDELETED) + ', ' +
        inttostr(cFAILED) + ') '
    Else
      lSql := lSql + ' and o.status = ' + inttostr(pStatus);
  End
  Else
    lSql := lSql + ' and status not in (' + Inttostr(cARCHIVED) + ', ' +
      inttostr(cDELETED) + ') ';

  lSql := lSql + ' order by o.sent desc ';

  Result := GetOutboxMessagesBySql(lSql, pResult);

  If pLogMessage And (pResult <> S_OK) Then
    fLog.DologMessage('TADODSR.GetOutboxMessages', pResult, lsql, True, True);

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetCISMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetCISMessageDetail(pGuid: TGuid): Olevariant;
Var
  lSql: String;
  lCount: Integer;
Begin
  Result := null;
  lSql := ' select ci.outbox_guid, ci.irmark, ci.correlationid, ci.classtype, '
    + ' ci.polling, ci.redirection, ci.fileguid from cis ci, outbox ou ' +
    ' where ci.outbox_guid = ou.guid ' +
    ' and ci.outbox_guid = ' + QuotedStr(GUIDToString(pGuid));

  {check for records}
  If RecordExists(lSql, False) Then
  Begin
    First;

    {create array result list}
    Result := VarArrayCreate([0, RecordCount], varVariant);
    lCount := 0;

    While Not Eof Do
    Begin
      Result[lCount] := VarArrayOf([
        Fieldbyname('outbox_guid').asString,
          Fieldbyname('irmark').asString,
          Fieldbyname('correlationid').AsString,
          FieldByName('classtype').AsString,
          Fieldbyname('polling').AsInteger,
          Fieldbyname('redirection').AsString,
          Fieldbyname('fileguid').AsString
          ]);

      Next;
      Inc(lCount);
    End; {While Not Eof Do}
  End; {if RecordExists(lSql, False) then}

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: LoadRecycleMessages
  Author:    vmoura

  the recycle frame includes both inbox and outbox tables.
  instead calling two sql commands and uptade the view, it call
  a sql command with union all to join these tables
-----------------------------------------------------------------------------}
Function TADODSR.LoadRecycleMessages: Olevariant;
Var
  lSql: String;
  lRes: Longword;
Begin
  lSql := ' select o.Id ' +
    ' ,o.Guid ,o.Company_Id ,o.Subject ,o.UserFrom ,o.UserTo ,o.Package_Id ' +
    ' ,o.Status ,o.Param1 ,o.Param2 ,o.TotalItems ,o.totaldone ,o.Sent ' +
    ' ,o.Mode ,o.LastUpdate, s.id as schedule ' +
    ' from outbox o ' +
    ' left join schedule s on (o.guid = s.outbox_guid) ' +
    ' where o.status in (' + inttostr(cDELETED) + ', ' + inttostr(cFAILED) +
    ') ';

  lSql := lSql + ' union all ';

  lSql := lSql + ' select ' +
    ' inb.Id ,inb.Guid ,inb.Company_Id ,inb.Subject ,inb.UserFrom ,inb.UserTo ' +
    ' ,inb.Package_Id ,inb.Status , '''' as Param1, '''' as Param2 ,inb.TotalItems ,inb.totaldone' +
    ' ,inb.Received ,inb.Mode ,inb.LastUpdate ,0 as schedule ' +
    ' from inbox inb ' +
    ' where inb.status in (' + inttostr(cDELETED) + ', ' + inttostr(cFAILED) +
    ') ';
  lSql := lSql + ' order by o.sent desc ';

  Result := GetOutboxMessagesBySql(lSql, lRes);
End;

{-----------------------------------------------------------------------------
  Procedure: GetOutboxMessagesBySql
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetOutboxMessagesBySql(Const pSql: String; Out pResult:
  Longword): OleVariant;
Var
  lCount: Integer;
Begin
  pResult := S_OK;
  Result := null;

  If RecordExists(pSql, False) Then
  Begin
    First;

    Result := VarArrayCreate([0, RecordCount], varVariant);
    lCount := 0;

    While Not Eof Do
    Begin
      Result[lCount] := VarArrayOf([
        Fieldbyname('guid').asString,
          Fieldbyname('company_id').Asinteger,
          Fieldbyname('subject').AsString,
          Fieldbyname('userfrom').AsString,
          Fieldbyname('userto').AsString,
          FieldByName('package_id').AsInteger,
          FieldByName('status').AsInteger,
          FieldByName('param1').AsString,
          FieldByName('param2').AsString,
          FieldByName('totalitems').AsInteger,
          FieldByName('sent').AsDateTime,
          FieldByName('schedule').asInteger,
          FieldByName('mode').asInteger,
          FieldByName('totaldone').asInteger
          ]);

      Next;
      Inc(lCount);
    End;
  End
  Else
    pResult := cDBNORECORDFOUND;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessOldOutboxMails
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.ProcessOldOutboxMails;
Var
  lSql: String;
  lOut: OleVariant;
  lResult: Longword;
  lCont,
    lTotal: Integer;
  lMail: TMessageInfo;
Begin
  {to avoid get error processing the sql result, i added this "0 as schedule" alias
  to be equal to the other sqls processing }

  lSql := 'select *, 0 as schedule from outbox where status in (' +
    inttostr(cPROCESSING) + ', ' + inttostr(cPOPULATING) + ', ' +
    inttostr(cRECEIVINGDATA) + ', ' + inttostr(cBULKPROCESSING) + ', ' +
    inttostr(cSENDING) + ') ';

  lSql := lSql + ' and datediff(hh, sent, getdate()) > 23 ';
//  lSql := lSql + ' and datediff(hh, lastupdate, getdate()) > 23 ';

  lOut := GetOutboxMessagesBySql(lSql, lResult);
  lTotal := _GetOlevariantArraySize(lOut);

  If (lTotal > 0) And (lResult = S_OK) Then
    For lCont := 0 To lTotal - 1 Do
    Begin
      Try
        lMail := _CreateOutboxMsgInfo(lOut[lCont]);
        If Assigned(lMail) Then
          UpdateOutBox(lMail.Guid, 0, '', '', '', 0, 0, '', '', cFAILED, -1,
            dbDoUpdate);
      Finally
        If Assigned(lMail) Then
          FreeAndNil(lMail);
      End;
    End; {For lCont := 0 To lTotal - 1 Do}

  lOut := null;
End;

{-----------------------------------------------------------------------------
  Procedure: ChangeOutboxStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.ChangeOutboxStatus(pCompany, pFromStatus, pToStatus: Integer);
Var
  lSql: String;
Begin
  lSql := ' update outbox set status = ' + inttostr(pToStatus);
  lSql := lSql + ' where 1=1 ';
  If pCompany > 0 Then
    lSql := lSql + ' and company_id = ' + inttostr(pCompany);

  lSql := lSql + ' and status = ' + inttostr(pFromStatus);
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: GetOutboxMaxMode
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetOutboxMaxMode(pCompany: Longword): TRecordMode;
Var
  lSql: String;
Begin
  Result := rmNormal;

  lSql := ' select max(mode) from outbox where company_id = ' + inttostr(pCompany);
  lSql := lSql + ' and status not in (' + Inttostr(cARCHIVED) + ', ' +
    inttostr(cDELETED) + ') ';

  If RecordExists(lSql, False) Then
    Result := TRecordMode(Fields[0].AsInteger);

  CloseAndClearSql
End;

{-----------------------------------------------------------------------------
  Procedure: GetInboxMaxMode
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetInboxMaxMode(pCompany: Longword): TRecordMode;
Var
  lSql: String;
Begin
  Result := rmNormal;
  lSql := ' select max(mode) from inbox where company_id = ' + inttostr(pCompany);
  lSql := lSql + ' and status not in (' + Inttostr(cARCHIVED) + ', ' +
    inttostr(cDELETED) + ') ';

  If RecordExists(lSql, False) Then
    Result := TRecordMode(Fields[0].AsInteger);

  CloseAndClearSql
End;

{-----------------------------------------------------------------------------
  Procedure: GetOutboxScheduleMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetOutboxScheduleMessages(pCompany: Longword; pDate: TDatetime;
  pMaxRecords: Longword; Out pResult: LongWord; Const pLogMessage: Boolean):
  OleVariant;
Var
  lSql: String;
Begin
  pResult := S_OK;
  Result := null;

  If pMaxRecords > 0 Then
    lSql := 'select top(' + inttostr(pMaxRecords) +
      ') o.*, s.id as schedule from outbox o '
  Else
    lSql := 'select o.*, s.id as schedule from outbox o ';

  lSql := lSql + ' right join schedule s on (s.outbox_guid = o.guid) ';
  lSql := lSql + ' where o.company_id > 0 and o.status not in (2) ';

  If pCompany > 0 Then
    lSql := lSql + ' and o.company_id = ' + inttostr(pCompany);

  { test and validate the date param}
  If (pDate > 0) And IsValidDate(YearOf(pDate), MonthOf(pDate), DayOf(pDate))
    Then
    lSql := lsql + ' and o.sent >= ' + QuotedStr(datetimetostr(pDate));

  {get only scheduled messages }
//  lSql := lSql + ' and o.guid in (select outbox_guid from schedule) ';
  lSql := lSql + ' order by o.sent desc ';

  Result := GetOutboxMessagesBySql(lSql, pResult);

  If pLogMessage And (pResult <> S_OK) Then
    fLog.DologMessage('TADODSR.GetOutboxMessages', pResult, lsql, True, True);

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetOutboxStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetOutboxMessage(pGuid: TGuid): TMessageInfo;
Var
  lSql: String;
Begin
  Result := Nil;
  //lSql := 'select * from outbox where guid = ' + QuotedStr(GUIDToString(pGuid));
  lSql := 'select o.*, s.id as schedule from outbox o ';
  lSql := lSql + ' left join schedule s on (o.guid = s.outbox_guid) ';
  lSql := lsql + ' where guid = ' + QuotedStr(GUIDToString(pGuid));

  If RecordExists(lSql, False) Then
  Begin
    Try
      Result := TMessageInfo.Create;
      Result.Guid := _SafeStringToGuid(Fieldbyname('guid').asString);
      Result.Company_Id := Fieldbyname('company_id').Asinteger;
      Result.Subject := Fieldbyname('subject').AsString;
      Result.From := Fieldbyname('userfrom').AsString;
      Result.To_ := Fieldbyname('userto').AsString;
      Result.Pack_Id := FieldByName('package_id').AsInteger;
      Result.Status := FieldByName('status').AsInteger;
      Result.Param1 := FieldByName('param1').AsString;
      Result.Param2 := FieldByName('param2').AsString;
      Result.TotalItens := FieldByName('totalitems').AsInteger;
      Result.Date := FieldByName('sent').AsDateTime;
      Result.ScheduleId := FieldByName('schedule').AsInteger;
      Result.Mode := FieldByName('mode').AsInteger;
      Result.TotalDone := FieldByName('totaldone').AsInteger;
    Except
      On e: exception Do
      Begin
        Result := Nil;
        fLog.DoLogMessage('TADODSR.GetOutboxMessage', cDBERROR,
          'Error processing request. Error: ' + e.message, True, True);
      End; {begin}
    End; {try}
  End; {If RecordExists(lSql, False) Then}
//  Else
//    fLog.DoLogMessage('TADODSR.GetOutboxMessage', cDBNORECORDFOUND, '');
End;

{-----------------------------------------------------------------------------
  Procedure: GetFirstOutboxMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetFirstOutboxMessage(pCompany: Longword): TMessageInfo;
Var
  lSql: String;
Begin
  Result := Nil;
  lSql := 'select top(1) * from outbox where company_id = ' + inttostr(pCompany)
    + ' order by id asc';

  If RecordExists(lSql, False) Then
  Begin
    Try
      Result := GetOutboxMessage(StringToGUID(fieldbyname('guid').AsString));
    Except
      On e: exception Do
      Begin
        Result := Nil;
        fLog.DoLogMessage('TADODSR.GetInboxMessage', cDBERROR,
          'Error processing request. Error: ' + e.message, True, True);
      End; {begin}
    End; {try}
  End; {If RecordExists(lSql, False) Then}
//  Else
//    fLog.DoLogMessage('TADODSR.GetInboxMessage', cDBNORECORDFOUND, '');

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetOutboxStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetTopOutboxMessage(pCompany: Longword): TMessageInfo;
Var
  lSql: String;
Begin
  Result := Nil;
  lSql := 'select top(1) * from outbox where company_id = ' +
    inttostr(pCompany);

//  lsql := lSql + ' and status <> ' + inttostr(cARCHIVED);

  lSql := lSql + ' and status not in (' + Inttostr(cARCHIVED) + ', ' +
    inttostr(cDELETED) + ') ';

  lSql := lSql + ' order by id desc';

  If RecordExists(lSql, False) Then
  Begin
    Try
      Result := GetOutboxMessage(StringToGUID(Fieldbyname('guid').asString))
    Except
      On e: exception Do
      Begin
        Result := Nil;
        fLog.DoLogMessage('TADODSR.GetInboxMessage', cDBERROR,
          'Error processing request. Error: ' + e.message, True, True);
      End; {begin}
    End; {try}
  End; {If RecordExists(lSql, False) Then}
///  Else
 //   fLog.DoLogMessage('TADODSR.GetInboxMessage', cDBNORECORDFOUND, '', True, False);

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetLastOutboxUpdate
  Author:    vmoura

  verify when the outbox table was last updated
-----------------------------------------------------------------------------}
Function TADODSR.GetLastOutboxUpdate: TDateTime;
Var
  lSql: String;
Begin
  Result := 0;
  lsql := ' select max(lastupdate) from outbox';
  RecordExists(lsql, False);
  Try
    Result := Fields[0].AsDateTime;
  Except
  End;

(*  CloseAndClearSql;

  {give another try if the result is zero}
  If Result = 0 Then
  Begin
    lSql := ' SELECT  max(STATS_DATE(i.id, i.indid)) ' +
      ' FROM sysobjects o, sysindexes i ' +
      ' WHERE o.name = ''outbox'' AND o.id = i.id ';
    RecordExists(lsql, False);
    Try
      If Fields[0].AsDateTime <> 0 Then
        Result := Fields[0].AsDateTime;
    Except
    End; {try}
  End; {If Result = 0 Then}*)

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: IsEndOfSyncRequested
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.IsEndOfSyncRequested(pCompany: Longword): Boolean;
Var
  lSql: String;
Begin
  lSql := 'select id from inbox where company_id = ' + inttostr(pCompany);
  lSql := lSql + ' and status = ' + inttostr(cREMOVESYNC);
  Result := RecordExists(lSql);

  {if not found in the outbox table, look at inbox table}
  If Not Result Then
  Begin
    lSql := 'select id from outbox where company_id = ' + inttostr(pCompany);
    lSql := lSql + ' and status = ' + inttostr(cREMOVESYNC);
    Result := RecordExists(lSql);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: GetOutboxMessageStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetOutboxMessageStatus(pGuid: TGuid): Integer;
Var
  lMsg: TMessageInfo;
Begin
  Result := -1;
  lMsg := GetOutboxMessage(pGuid);
  If lMsg <> Nil Then
  Begin
    Result := lMsg.Status;
    FreeAndNil(lMsg);
  End; {If lMsg <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: SetOutboxMessageStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetOutboxMessageStatus(pGuid: TGuid; pStatus: Integer);
Begin
  UpdateOutBox(pGuid, 0, '', '', '', 0, 0, '', '', pStatus, -1, dbDoUpdate);
End;

{-----------------------------------------------------------------------------
  Procedure: SetOutboxMessageToCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetOutboxMessageToCompany(pGuid: TGUID; pCompany: LongWord; Out
  pResult: LongWord);
Var
  lSql: String;
Begin
  // search for outbox entry. the message must exists into the outbox
  If SearchOutboxEntry(pGuid) > 0 Then
  Begin
    // the company must exists
    If SearchCompany(pCompany) Then
    Begin
      lSql := 'update outbox set company_id = ' + inttostr(pCompany);
      lSql := lsql + ' where guid = ' + QuotedStr(GUIDToString(pGuid));
      // update the message
      If Exec(lSql) Then
        pResult := S_OK
      Else
        pResult := cDBERROR;
    End // search for the company
    Else
      pResult := cDBNORECORDFOUND;
  End // searchinbox entry
  Else
    pResult := cDBNORECORDFOUND;
End;

{-----------------------------------------------------------------------------
  Procedure: SearchCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetTotalOutboxMessages(pCompany: Integer; Const pStatus:
  Smallint = 0): Longword;
Var
  lSql: String;
Begin
  Result := 0;

  lSql := ' select count(id) from outbox where 1=1';
  If pCompany > 0 Then
    lSql := lSql + ' and company_id = ' + inttostr(pCompany);

  If pStatus > 0 Then
  Begin
    If pStatus = cALLNEW Then
      lSql := lSql + ' and status in (' + inttostr(cNEWENTRY) + ', ' +
        inttostr(cREADYIMPORT) + ') '
    Else If pStatus = cALLRECYCLE Then
      lSql := lSql + ' and status in (' + inttostr(cDELETED) + ', ' +
        inttostr(cFAILED) + ') '
    Else
      lSql := lSql + ' and status = ' + inttostr(pStatus)
  End {If pStatus > 0 Then}
  Else
    lSql := lSql + ' and status not in (' + Inttostr(cARCHIVED) + ', ' +
      inttostr(cDELETED) + ') ';

  If RecordExists(lSql, False) Then
    Result := Fields[0].AsInteger;

  CloseAndClearSql;
End;

/////////////////////// COMPANY FUNCTIONS ////////////////////////
{-----------------------------------------------------------------------------
  Procedure: SearchCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.SearchCompany(pCompany: Longword): Boolean;
Begin
  Result := RecordExists(' select id from company where id = ' +
    inttostr(pCompany));
End;

{-----------------------------------------------------------------------------
  Procedure: SearchCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.SearchCompany(Const pCompanyName: String): Boolean;
Begin
  Result := RecordExists(' select id from company where description = ' +
    QuotedStr(Trim(pCompanyName)));
End;

{-----------------------------------------------------------------------------
  Procedure: GetExCode
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetExCode(pCompany: Longword): String;
Var
  lSql: String;
Begin
  Result := '';
  lSql := ' select excode from company where id = ' + inttostr(pCompany);
  If RecordExists(lSql, false) Then
    Result := FieldbyName('excode').AsString;
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetCompanyId
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetCompanyId(Const pExCode: String): Integer;
Var
  lSql: String;
Begin
  Result := 0;
  lSql := ' select id from company where excode = ' + QuotedStr(Trim(pExCode));
  If RecordExists(lSql, false) Then
    Result := FieldbyName('id').Asinteger;
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetCompanyIdbyGuid
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetCompanyIdbyGuid(Const pGuid: String): Integer;
Var
  lSql: String;
Begin
  Result := 0;
  lSql := ' select id from company where guid = ' + QuotedStr(Trim(pGuid));
  If RecordExists(lSql, false) Then
    Result := FieldbyName('id').Asinteger;
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetCompanyGuid
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetCompanyGuid(pCompany: Longword): String;
Var
  lSql: String;
Begin
  Result := '';
  lSql := ' select guid from company where id = ' + inttostr(pCompany);
  If RecordExists(lSql, false) Then
    Result := Trim(FieldbyName('guid').AsString);
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetCompanyGuid
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetCompanyGuid(Const pExCode: String): String;
Var
  lCompId: Integer;
Begin
  lCompId := GetCompanyId(Trim(pExCode));
  Result := GetCompanyGuid(lCompId);
End;

{-----------------------------------------------------------------------------
  Procedure: SetCompanyGuid
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetCompanyGuid(pCompany: Longword; pGuid: TGuid);
Var
  lSql: String;
Begin
  lSql := ' update company set guid = ' + QuotedStr(ifThen(_IsValidGuid(pGuid),
    GUIDToString(pGuid), ''));
  lSql := lSql + ' where id = ' + IntToStr(pCompany);
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: ClearCompanyGuid
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.ClearCompanyGuid(pCompany: Longword);
Var
  lGuid: TGUID;
Begin
  FillChar(lGuid, SizeOf(TGUID), 0);
  SetCompanyGuid(pCompany, lGuid);
End;

{-----------------------------------------------------------------------------
  Procedure: GetCompanyPath
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetCompanyPath(pCompany: Longword): String;
Var
  lSql: String;
Begin
  Result := '';
  lSql := ' select directory from company where id = ' + inttostr(pCompany);
  If RecordExists(lSql, false) Then
    Result := FieldbyName('directory').AsString;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetCompanyPath
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetCompanyPath(Const pExCode: String): String;
Var
  lSql: String;
Begin
  Result := '';
  lSql := ' select directory from company where excode = ' +
    QuotedStr(Trim(pExCode));
  If RecordExists(lSql, false) Then
    Result := FieldbyName('directory').AsString;
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetCompanyPathbyGuid
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetCompanyPathbyGuid(Const pGuid: String): String;
Var
  lId: Integer;
Begin
  Result := '';
  lId := GetCompanyIdbyGuid(pGuid);
  If lID > 0 Then
    Result := GetCompanyPath(lId);
End;

{-----------------------------------------------------------------------------
  Procedure: GetCompanyDescription
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetCompanyDescription(pCompany: Longword): String;
Var
  lSql: String;
Begin
  Result := '';
  lSql := ' select description from company where id = ' + inttostr(pCompany);
  If RecordExists(lSql, false) Then
    Result := FieldbyName('description').AsString;
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: CompanyHasInboxArchive
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.CompanyHasInboxArchive(pCompany: Longword): Boolean;
Var
  lSql: String;
Begin
  Result := False;
  lSql := ' select count(id) from inbox where company_id = ' +
    inttostr(pCompany);
  lSql := lSql + ' and status = ' + inttostr(cARCHIVED);
  If RecordExists(lSql, false) Then
    Result := Fields[0].AsInteger > 0;
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: CompanyHasOutboxArchive
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.CompanyHasOutboxArchive(pCompany: Longword): Boolean;
Var
  lSql: String;
Begin
  Result := False;
  lSql := ' select count(id) from outbox where company_id = ' +
    inttostr(pCompany);
  lSql := lSql + ' and status = ' + inttostr(cARCHIVED);
  If RecordExists(lSql, false) Then
    Result := Fields[0].AsInteger > 0;
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: SetAllInboxMessagesStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetAllInboxMessagesStatus(pCompany, pStatus: Longword);
Var
  lSql: String;
Begin
  lsql := ' update inbox set status = ' + inttostr(pStatus);
  lSql := lSql + ' , lastupdate = getdate() ';
  lSql := lSql + ' where company_id = ' + inttostr(pCompany);
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: SetAllOutboxMessagesStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetAllOutboxMessagesStatus(pCompany, pStatus: Longword);
Var
  lSql: String;
Begin
  lsql := ' update outbox set status = ' + inttostr(pStatus);
  lSql := lSql + ' , lastupdate = getdate() ';
  lSql := lSql + ' where company_id = ' + inttostr(pCompany);
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: RemoveAllOutboxSchedule
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.RemoveAllOutboxSchedule(pCompany: Longword);
Var
  lSql: String;
Begin
  lSql := ' delete from schedule ';
  lSql := lsql + ' where id in (select id from outbox where company_id = ' +
    inttostr(pCompany) + ')';
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: GetDefaultReceiver
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetDefaultReceiver(pCompany: Longword): String;
Var
  lSql: String;
Begin
  Result := '';
  {the default company into the database is zero}
  If pCompany > 0 Then
  Begin
    lSql := ' select contactmail from contacts where company_id = ' +
      inttostr(pCompany);
    If RecordExists(lSql, False) Then
      Result := FieldByName('contactmail').asstring;

    CloseAndClearSql;
  End; {If pCompany > 0 Then}
End;

{-----------------------------------------------------------------------------
  Procedure: CreateCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.CreateCompany(Const pDescription, pExCode, pPath: String;
  pPeriods: Integer):
  Boolean;
Var
  lSql: String;
Begin
  Result := False;
  // empty values are not allowed
  If (pDescription <> '') And (pExCode <> '') Then
  Begin
    lSql := ' insert into company (description, periods, excode, active, directory, lastupdate) '
      + ' values (' + QuotedStr(TRim(pDescription)) + ', ' +
      inttostr(pPeriods) + ', ' + QuotedStr(Trim(pExCode)) + ', 1' + ', ' +
      QuotedStr(Trim(pPath)) + ', getdate()) ';

    Result := Exec(lSql);
  End
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteCompany
  Author:    vmoura

  to delete a company, i need first take a look on messages that belong to that company.
  this include messagebody stuff and inbox/outbox tables.
  Also, i need remove the system files and directories...
-----------------------------------------------------------------------------}
Function TADODSR.DeleteCompany(pCompany: Longword; Const pDeleteInbox: Boolean =
  False; Const pDeleteOutBox: Boolean = False): Boolean;
Var
  lInboxDir,
    lOutboxDir,
    lSql: String;
Begin
  Result := False;
  lInboxDir := IncludeTrailingPathDelimiter(_GetApplicationPath + cINBOXDIR);
  lOutboxDir := IncludeTrailingPathDelimiter(_GetApplicationPath + cOUTBOXDIR);

  If pCompany > 0 Then
  Begin
    { delete from inbox}
    If pDeleteInbox Then
    Begin
      { REMOVE directories/files}
      lSql := 'select guid from inbox where company_id = ' + inttostr(pCompany);
      If RecordExists(lSql, False) Then
      Begin
        First;
        While Not Eof Do
        Begin
          //_DelDir(IncludeTrailingPathDelimiter(lInboxDir) + FieldByName('guid').AsString);
          TDSRDeleteDir.Create(lInboxDir + FieldByName('guid').AsString);
          Next;
        End; { while}
      End; { recordexists}

      { and finally delete from inbox}
      lSql := ' delete from inbox where company_id = ' + inttostr(pCompany);
      Exec(lSql);
    End;

    { delete from outbox...}
    If pDeleteOutBox Then
    Begin
      lSql := 'select guid from outbox where company_id = ' +
        inttostr(pCompany);
      If RecordExists(lSql, False) Then
      Begin
        First;
        While Not Eof Do
        Begin
          //_DelDir(IncludeTrailingPathDelimiter(lOutboxDir) + FieldByName('guid').AsString);
          TDSRDeleteDir.Create(lOutboxDir + FieldByName('guid').AsString);
          Next;
        End; { while}
      End; { recordexists}

      { delete outbox}
      lSql := ' delete from outbox where company_id = ' + inttostr(pCompany);
      Exec(lSql);
    End;

    lSql := ' delete from company where id = ' + inttostr(pCompany);
    Result := Exec(lSql);

  End; { If pCompany > 0 Then}
End;

///////////////// imp/exp packages function //////////////////////////////

{-----------------------------------------------------------------------------
  Procedure: SetExportPackage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.SetExportPackage(pCompany: LongWord; Const pDescription,
  pPluginLink: WideString; pGuid: TGUID; pUserReference: Word): Boolean;
Var
  lSql: String;
Begin
  lSql := ' select id from exppackage where fileguid = ' +
    QuotedStr(GUIDToString(pGuid));

  // verify the record
  If Not RecordExists(lsql) Then
  Begin
    lSql := 'insert into exppackage (company_id, description, fileguid, userreference, pluginlink) '
      + ' values (' + inttostr(pCompany) + ', ' + QuotedStr(Trim(pDescription))
      + ', ' + QuotedStr(GUIDToString(pGuid)) + ', ' +
      IntToStr(pUserReference) + ', ' + QuotedStr(Trim(pPluginLink)) + ')';

    Result := Exec(lSql);
  End
  Else
  Begin
    Result := False;
    fLog.DologMessage('TADODSR.SetExportPackage', 0,
      'Package already exists. Guid ' + _SafeGuidtoString(pGuid), True, True);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SetImportPackage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.SetImportPackage(pCompany: LongWord; Const pDescription,
  pPluginlink: WideString; pGuid: TGUID; pUserReference: Word): Boolean;
Var
  lSql: String;
Begin
  lSql := ' select id from imppackage where fileguid = ' +
    QuotedStr(GUIDToString(pGuid));

  If Not RecordExists(lsql) Then
  Begin
    lSql := 'insert into imppackage (company_id, description, fileguid, userreference, pluginlink) '
      + ' values (' + inttostr(pCompany) + ', ' + QuotedStr(Trim(pDescription))
      + ', ' + QuotedStr(GUIDToString(pGuid)) + ', ' +
      IntToStr(pUserReference) + ', ' + QuotedStr(Trim(pPluginLink)) + ')';

    Result := Exec(lSql);
  End
  Else
  Begin
    Result := False;
    fLog.DologMessage('TADODSR.SetExportPackage', 0,
      'Package already exists. Guid ' + _SafeGuidtoString(pGuid), True, True);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteExportPackage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.DeleteExportPackage(pPackId: Integer): Boolean;
Begin
  Result := Exec('delete from exppackage where id = ' + inttostr(pPackId),
    True);
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteImportPackage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.DeleteImportPackage(PPackId: Integer): Boolean;
Begin
  Result := Exec('delete from imppackage where id = ' + inttostr(pPackId),
    True);
End;

{-----------------------------------------------------------------------------
  Procedure: GetExportPackages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetExportPackages: OleVariant;
Var
  lSql: String;
  lCount: Integer;
Begin
  Result := null;
  lSql := 'select * from exppackage';
  If RecordExists(lsql, False) Then
  Begin
    Result := VarArrayCreate([0, RecordCount], varVariant);
    lCount := 0;
    First;
    While Not Eof Do
    Begin
      // create a new array to every single item of my result with the fields of the database
      Try
        Result[lCount] := VarArrayOf([
          FieldByName('Id').asInteger,
            FieldbyName('company_id').asinteger,
            FieldByName('Description').asString,
            FieldByName('UserReference').asInteger,
            FieldByName('FileGuid').asString,
            FieldByName('pluginlink').asString]);
      Except
        On e: exception Do
          fLog.DoLogMessage('TADODSR.GetExportPackages', 0, 'Error: ' +
            e.Message, True, True);
      End;

      Inc(lCount);
      Next;
    End;
  End // if recordexists
End;

{-----------------------------------------------------------------------------
  Procedure: GetImportPackages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetImportPackages: OleVariant;
Var
  lSql: String;
  lCount: Integer;
Begin
  Result := null;
  // select all records
  lSql := 'select * from imppackage';
  If RecordExists(lsql, False) Then
  Begin
    lCount := 0;
    // create the array of data according to the recordcount
    Result := VarArrayCreate([0, RecordCount], varVariant);
    First;
    While Not Eof Do
    Begin
      // create a new arrayu to every single item of my result with the fields of the database
      Try
        Result[lCount] := VarArrayOf([
          FieldByName('Id').asInteger,
            FieldbyName('company_id').asinteger,
            FieldByName('Description').asString,
            FieldByName('UserReference').asInteger,
            FieldByName('FileGuid').asString,
            FieldByName('pluginlink').asString
            ]);
      Except
        On e: exception Do
          fLog.DoLogMessage('TADODSR.GetExportPackages', 0, 'Error: ' +
            e.Message, True, True);
      End;

      Next;
      Inc(lCount);
    End;
  End // if recordexists
End;

{-----------------------------------------------------------------------------
  Procedure: GetImportIdbyLink
  Author:    vmoura

  if the link between the import and export is not found
  the -1 value will be use to alert the dashboard that
  a plugin is missing and the user should select a valid and new import operation
-----------------------------------------------------------------------------}
Function TADODSR.GetImportIdbyLink(Const pLink: String): Integer;
Var
  lSql: String;
Begin
  Result := -1;
  lSql := ' select id from imppackage where pluginlink = ' +
    QuotedStr(Trim(pLink));
  If RecordExists(lSql, False) Then
    Result := fieldByName('id').AsInteger;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetImportCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetImportCompany(pId: Integer): Integer;
Var
  lSql: String;
Begin
  Result := 0;
  lSql := ' select company_id from imppackage where id = ' + IntToStr(pId);
  If RecordExists(lSql, False) Then
    Result := fieldByName('company_id').AsInteger;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetCompanyByExCode
  Author:    vmoura

  get exchequer company code
-----------------------------------------------------------------------------}
(*Function TADODSR.GetCompanyByExCode(Const pExCode: String): Integer;
Var
  lSql: String;
Begin
  Result := 0;
  If pExCode <> '' Then
  Begin
    lSql := ' select id from company where excode = ' +
      QuotedStr(Trim(pExCode));
    If RecordExists(lSql, False) Then
      Result := fieldByName('id').AsInteger;
  End;

  CloseAndClearSql;
End;*)

{-----------------------------------------------------------------------------
  Procedure: GetImportPackage
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.CheckExCompanies(pCompanies: Olevariant);
Var
  lCompId: integer;
  lCode, lDesc, lPath, lCompPath: String;
  lPeriods,
    lCont, lTotal: Integer;
Begin
  _CallDebugLog('start update database with exchequer companies');

  lTotal := _GetOlevariantArraySize(pCompanies);
  _CallDebugLog('Total companies ' + inttostr(lTotal));

  If (lTotal > 0) And Connected Then
  Begin
    _CallDebugLog('updating companies');

    {change company status to false}
//    Exec('update company set active = 0');

    For lCont := 0 To lTotal - 1 Do
    Try
      If Not VarIsNull(pCompanies[lCont]) And VarIsArray(pCompanies[lCont]) Then
      Begin
      {0- exchequer code, 1- description, 2-company path}
        lCode := '';
        Try
          lCode := pCompanies[lCont][0];
        Except
          lCode := '';
        End;

        If lCode <> '' Then
        Begin
          lDesc := pCompanies[lCont][1];
          lPath := lowercase(Trim(pCompanies[lCont][2]));
          lPeriods := pCompanies[lCont][3];
          {IAAO may have similar codes}
          lCompId := GetCompanyid(lCode);
          lCompPath := lowercase(Trim(GetCompanyPath(lCode)));
          {check if this company already exists - IAO may have same code but different directories}
          //PR: 13/01/2017 ABSEXCH-11825 Only create new company record if Id is 0
          If (lCompId = 0) Then
          Begin
            CreateCompany(lDesc, lCode, lPath, lPeriods);
            lCompId := GetCompanyId(lCode);
            {set the company "identifier"}
            SetCompanyGuid(lCompId, _CreateGuid);
          End
          Else
          Begin
            SetCompanyDirectory(lCompId, lPath);
//            SetCompanyStatus(lCompId, True);
            SetCompanyPeriods(lCompId, lPeriods);
          End;
        End; {If lCode <> '' Then}
      End;
    Except
      On e: exception Do
      Begin
        _LogMSG('TADODSR.CheckExCompanies :- Error updating companies. Error: ' +
          e.message);
        UpdateIceLog('TADODSR.CheckExCompanies', 'Error updating companies. Error: '
          + e.message);
      End; {begin}
    End; {For lCont := 0 To lTotal - 1 Do}
  End {if lTotal > 0 then}
  Else
    _LogMSG('Database not connected or invalid number of companies.');

  _CallDebugLog('end updating companies');
End;

{-----------------------------------------------------------------------------
  Procedure: GetImportPackage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetImportPackage(pId, pCompany: Integer): TPackageInfo;
Var
  lSql, lExCode: String;
  lPackInfo: TPackageInfo;
Begin
  Result := Nil;
  // select all records
{
  lSql := 'select imp.*, comp.excode from imppackage imp, company comp where imp.id = '
    + inttostr(pId) + ' and imp.company_id = comp.id and comp.id = ' +
    inttostr(pCompany);
 }

  lExCode := GetExCode(pCompany);

  If lExCode <> '' Then
  Begin
    lSql := 'select * from imppackage where id = ' + inttostr(pId);

    If RecordExists(lsql, False) Then
    Try
      lPackInfo := TPackageInfo.Create;
      lPackInfo.Id := FieldByName('id').asInteger;
      lPackInfo.Description := FieldByName('description').asString;
      lPackInfo.Company_Id := FieldByName('company_id').asInteger;
      //lPackInfo.ExCode := FieldByName('excode').AsString;
      lPackInfo.ExCode := lExCode;
      lPackInfo.UserReference := FieldByName('UserReference').asInteger;
      lPackInfo.Guid := _SafeStringToGuid(FieldByName('fileguid').asString);
      lPackInfo.PluginLink := FieldByName('pluginlink').asString;
      Result := lPackInfo;
    Except
      On e: exception Do
      Begin
        fLog.DoLogMessage('TADODSR.GetImportPackage', cDBERROR, 'Error: ' +
          e.message, True, True);
      End;
    End {If RecordExists(lsql, False) Then}
  End; {if SearchCompany(pCompany) then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetExportPackage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetExportPackage(pId, pCompany: Integer): TPackageInfo;
Var
  lSql, lExCode: String;
  lPackInfo: TPackageInfo;
Begin
  Result := Nil;
  // select all records
{  lSql := 'select ex.*, comp.excode from exppackage ex, company comp where ex.id = '
    + inttostr(pId) + ' and ex.company_id = comp.id and comp.id = ' +
    inttostr(pCompany);
}

  lExCode := GetExCode(pCompany);

  If lExCode <> '' Then
  Begin
    lSql := 'select * from exppackage where id = ' + inttostr(pId);

    If RecordExists(lsql, False) Then
    Try
      lPackInfo := TPackageInfo.Create;
      lPackInfo.Id := FieldByName('id').asInteger;
      lPackInfo.Description := FieldByName('description').asString;
      lPackInfo.Company_Id := FieldByName('company_id').AsInteger;
      //lPackInfo.ExCode := FieldByName('excode').AsString;

      lPackInfo.ExCode := lExCode;

      lPackInfo.UserReference := FieldByName('userreference').asInteger;
      lPackInfo.Guid := _SafeStringToGuid(FieldByName('fileguid').asString);
      lPackInfo.PluginLink := FieldByName('pluginlink').AsString;
      Result := lPackInfo;
    Except
      On e: exception Do
      Begin
        fLog.DoLogMessage('TADODSR.GetExportPackage', cDBERROR, 'Error: ' +
          e.message, True, True);
        FreeAndNil(lPackInfo);
      End;
    End; {If RecordExists(lsql, False) Then}
  End; {if SearchCompany(pCompany) then begin}
End;

{-----------------------------------------------------------------------------
  Procedure: GetExportPackage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetExportPluginLink(pId: Integer): String;
Begin
  Result := '';
  If RecordExists('select pluginlink from exppackage where id = ' +
    inttostr(pId), False) Then
    Result := FieldByName('pluginlink').AsString;
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: FindDripFeed
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetExportPackage(pCompany: Integer; Const pDesc: String):
  TPackageInfo;
Var
  lExCode,
    lSql: String;
  lPackInfo: TPackageInfo;
Begin
  Result := Nil;
  // select all records
  //lSql := 'select ex.*, comp.excode from exppackage ex, company comp where ';
  //lSql := lSql + ' ex.company_id = comp.id and comp.id = ' + inttostr(pCompany);

  lExCode := GetExCode(pCompany);

  //If RecordExists(lsql, False) Then
  If lExCode <> '' Then
  Begin
    //First;
    lSql := 'select * from exppackage where description = ' +
      QuotedStr(Trim(pDesc));

    If RecordExists(lSql, False) Then
    Try
      lPackInfo := TPackageInfo.Create;
      lPackInfo.Id := FieldByName('Id').asInteger;
      lPackInfo.Description := FieldByName('description').asString;
      lPackInfo.Company_Id := FieldByName('company_id').AsInteger;
      //lPackInfo.ExCode := FieldByName('excode').AsString;
      lPackInfo.ExCode := lExCode;
      lPackInfo.UserReference := FieldByName('userreference').asInteger;
      lPackInfo.Guid := _SafeStringToGuid(FieldByName('fileguid').asString);
      lPackInfo.PluginLink := FieldByName('pluginlink').asString;
      Result := lPackInfo;
    Except
      On e: exception Do
      Begin
        fLog.DoLogMessage('TADODSR.GetExportPackage', cDBERROR, 'Error: ' +
          e.message, True, True);
      End;
    End;
  End; {if lExCode <> '' then}
End;

{-----------------------------------------------------------------------------
  Procedure: FindDripFeed
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.FindDripFeed: Boolean;
Begin
  {look up for drip feed mode records}
  Result := RecordExists('select id from exppackage where description = ' +
    QuotedStr(cDRIPFEED)) And
    RecordExists('select id from imppackage where description = ' +
    QuotedStr(cDRIPFEED));
End;

{-----------------------------------------------------------------------------
  Procedure: GetCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetCompanies(Const pPathFilter: String = ''): OleVariant;
Var
  lSql: String;
  lCount: Integer;
  lFilter: String;
Begin
  lFilter := pPathFilter;
  If GetSystemValue(cISVAOPARAM) = '1' Then
    lFilter := _GetEnterpriseSystemDir;

  Result := null;
  lSql := ' select * from company ';
  If Trim(lFilter) <> '' Then
    lSql := lSql + ' where upper(directory) like ' + QuotedStr(uppercase(lFilter) +
      '%');

  If RecordExists(lSql, False) Then
  Begin
    Result := VarArrayCreate([0, RecordCount], varVariant);
    lCount := 0;
    First;

    While Not Eof Do
    Begin
      Result[lCount] := VarArrayOf([
        FieldByName('id').asinteger,
          FieldByName('excode').asString,
          fieldbyname('description').asString,
          fieldbyname('active').asBoolean,
          fieldbyname('periods').asInteger,
          fieldbyname('directory').asString,
          fieldbyname('guid').asString
          ]);
      Next;
      Inc(lCount);
    End;
  End; // if recordexists
End;

{-----------------------------------------------------------------------------
  Procedure: SetCompanyPeriods
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetCompanyStatus(pId: Integer; pStatus: Boolean);
Var
  lSql: String;
Begin
  lsql := ' update company set active = ' + inttostr(Ord(pStatus)) +
    ' where id = ' + inttostr(pId);
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: IsCompanyActive
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.IsCompanyActive(pId: Integer): Boolean;
Var
  lSql: String;
Begin
  Result := False;
  lsql := ' select active from company where id = ' + inttostr(pId);
  If RecordExists(lSql, False) Then
    Result := FieldByName('active').AsBoolean;
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: IsCompanyActive
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.IsCompanyActive(Const pExCode: String): Boolean;
Var
  lSql: String;
Begin
  Result := False;
  lsql := ' select active from company where excode = ' +
    QuotedStr(Trim(pExCode));
  If RecordExists(lSql, False) Then
    Result := FieldByName('active').AsBoolean;
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: SearchScheduleEntry
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetCompanyPeriods(pId: Integer; pPeriods: Integer);
Var
  lSql: String;
Begin
  lsql := ' update company set periods = ' + inttostr(pPeriods) +
    ' where id = ' + inttostr(pId);
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: GetCompanyPeriods
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetCompanyPeriods(pId: Integer): Integer;
Var
  lSql: String;
Begin
  Result := 0;
  lSql := ' select periods from company where id = ' + inttostr(pId);
  If RecordExists(lsql, False) Then
    Result := FieldByname('periods').asinteger;
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: SetSchedule
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.SearchScheduleEntry(pGuid: TGuid): Integer;
Begin
  If RecordExists('select id from schedule where outbox_guid = ' +
    QuotedStr(GUIDToString(pGuid)), False) Then
    Result := fieldbyname('id').AsInteger
  Else
    Result := -1;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: SetCompanyDirectory
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetCompanyDirectory(pId: Integer; Const pPath: String);
Var
  lSql: String;
Begin
  lsql := ' update company set directory = ' + QuotedStr(Trim(pPath)) +
    ' where id = ' + inttostr(pId);
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteSchedule
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.SetSchedule(pGuid: TGUID; pScheduleType: Integer): Boolean;
Var
  lSql: String;
  lId: Integer;
Begin
  Result := True;
  lId := SearchOutboxEntry(pGuid);
  // search for a valid outbox entry
  If lId > 0 Then
  Begin
    // verify if this schedule is already registered
    If SearchScheduleEntry(pGuid) < 0 Then
    Begin
      lSql := ' insert into schedule (outbox_id, outbox_guid, scheduletype_id) values '
        + ' (' + inttostr(lid) +
        ', ' + QuotedStr(GUIDToString(pGuid)) +
        ', ' + inttostr(pScheduleType) + ')';
      Result := Exec(lSql, True);
    End
  End {If lId > 0 Then}
  Else
    Result := False;
End;

{-----------------------------------------------------------------------------
  Procedure: SetDaySchedule
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.DeleteSchedule(pGuid: TGuid): Boolean;
Var
  lId: Integer;
Begin
  { search for the guid entry}
  lId := SearchScheduleEntry(pGuid);

  If lId > 0 Then
    { the cascade delete in the database will get rid off the other records }
    Result := Exec('delete schedule where id = ' + inttostr(lId), True)
  Else
    Result := False;
End;

{-----------------------------------------------------------------------------
  Procedure: GetDaySchedule
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.SetDaySchedule(pGuid: TGuid; pStartDate, pEndDate, pStartTime:
  TDateTime; pAllDays, pWeekDays: Boolean; pEveryDay: Byte): Boolean;
Var
  lSql: String;
  lId: Integer;
Begin
  If Connected Then
  Begin
  { insert the new schedule}

    If SetSchedule(pGuid, cDAILYSCHEDULE) Then
    Begin
    { look up the new scheduled entry}
      lId := SearchScheduleEntry(pGuid);
      If lId > 0 Then
      Begin
      {remove an entry}
        lSql := 'delete from dayschedule where schedule_id = ' + inttostr(lId);
        Try
          Exec(lSql);
        Except
        End;

        lSql := 'insert into dayschedule (schedule_id, startdate, enddate, starttime, alldays, weekdays, everyday) values '
          + '(' + inttostr(lId) +
          ', ' + QuotedStr(DateTimeToSQLDateTime(pStartDate, False)) +
          ', ' + QuotedStr(DateTimeToSQLDateTime(pEndDate, False)) +
          ', ' + QuotedStr(DateTimeToSQLDateTime(pStartTime)) +
          ', ' + inttostr(Ord(pAllDays)) +
          ', ' + inttostr(Ord(pWeekdays)) +
          ', ' + inttostr(pEveryDay) + ')';
        Result := Exec(lSql, True);

      End
      Else
      Begin
        Result := False;
        DeleteSchedule(pGuid);
      End;
    End
    Else
    Begin
      Result := False;
      DeleteSchedule(pGuid);
    End;
  End
  Else
    Result := False;
End;

{-----------------------------------------------------------------------------
  Procedure: GetDaySchedule
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetDaySchedule(pGuid: TGuid): Olevariant;
Var
  lSql: String;
  lId: Integer;
  lMsg: TMessageInfo;
Begin
  Result := null;
  { this entry must exists into the outbox table and the schedules table and the status must be saved}

  lMsg := GetOutboxMessage(pGuid);
  If lMsg <> Nil Then
  Begin
    lId := SearchScheduleEntry(pGuid);

    {normal messages}{drip feed messages}
    If ((lId > 0) And (lMsg.Status = cSAVED)) Or ((lId > 0) And (lMsg.Mode =
      Ord(rmDripFeed)))
      Then
    Begin
      lSql := 'select * from dayschedule where schedule_id = ' + inttostr(lId);
      If RecordExists(lSql, False) Then
      Begin
        Result := VarArrayCreate([0, 1], varVariant);

        Result[0] := VarArrayOf([
          fieldbyname('startdate').asDatetime,
            FieldByName('enddate').asdatetime,
            fieldbyname('starttime').asDatetime,
            fieldbyname('alldays').asboolean,
            fieldbyname('weekdays').asBoolean,
            fieldbyname('everyday').AsInteger
            ]);
      End;

      CloseAndClearSql;
    End; {If lId > 0 Then}
  End; {If lMsg <> Nil Then}

  FreeAndNil(lMsg);
End;

{-----------------------------------------------------------------------------
  Procedure: GetDaySchedule
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetDaySchedule(pId: Integer): Olevariant;
Var
  lSql: String;
Begin
  Result := Null;
  If pId > 0 Then
  Begin
    lSql := 'select * from dayschedule where schedule_id = ' + inttostr(pId);
    If RecordExists(lSql, False) Then
    Begin
      Result := VarArrayCreate([0, 1], varVariant);

      Result[0] := VarArrayOf([
        fieldbyname('startdate').asDatetime,
          FieldByName('enddate').asdatetime,
          fieldbyname('starttime').asDatetime,
          fieldbyname('alldays').asboolean,
          fieldbyname('weekdays').asBoolean,
          fieldbyname('everyday').AsInteger
          ]);
    End;

    CloseAndClearSql;
  End; {If lId > 0 Then}
End;

{-----------------------------------------------------------------------------
  Procedure: ScheduleExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.ScheduleExists(pCompany: Longword): Boolean;
Var
  lSql: String;
Begin
  lSql := ' select outbox_guid from schedule ' +
    ' where outbox_guid in (select guid from outbox where company_id = ' +
    inttostr(pCompany) + ')';
  Result := RecordExists(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: GetContacts
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.RegisterPlugins: Boolean;
Var
  lCont: Integer;
  lFiles: TStringList;
  lSearchRec: TSearchRec;
  lRes: Longword;
  lDll,
    lAux: String;
  lCFGOk, lParams, lUpdate: Boolean;
  lIni: TIniFile;
Begin
  lCFGOk := True;
  lParams := False;
  lUpdate := False;
  lFiles := TStringList.Create;
  lAux := IncludeTrailingPathDelimiter(_GetApplicationPath + cPLUGINSDIR);

  {look up configuration files and dlls matching}
  lRes := SysUtils.FindFirst(lAux + '*.cfg', faAnyFile, lSearchRec);
  While lRes = 0 Do
  Begin
    _CallDebugLog('PLUGIN Found: ' + lSearchRec.Name);

    {look for the dll}
    With lSearchRec Do
      lDll := lAux + Copy(Name, 1, Pos(ExtractFileExt(Name), Name) - 1);

    If Not _FileSize(lDll) > 0 Then
      lCFGOk := False
    Else
      lFiles.Add(lAux + lSearchRec.Name);

    lRes := SysUtils.FindNext(lSearchRec);
  End; {While lRes = 0 Do}

  Sysutils.FindClose(lSearchRec);

  {if all cfgs have their own dll, veiry the parameters }
  If lCFGOk Then
  Begin
    _CallDebugLog('cfg files ok. Reading .ini files');

    lParams := True;
    {open the cfg files and verify theis parameters}
    For lCont := 0 To lFiles.Count - 1 Do
    Begin
      Try
        lIni := TIniFile.Create(lFiles[lCont]);
      Except
        lIni := Nil;
      End;

      If Assigned(lIni) Then
      Begin
        {the dsr MUST verify all parameters oterwise is not going to work properly}
        If (lIni.ReadString('dllinfo', 'link', '') = '') Or {validate link name}
          (Length(lIni.ReadString('dllinfo', 'link', '')) > 32) Or
         {validate link dll}
        (lIni.ReadString('dllinfo', 'description', '') = '') Or
          {validate description name}
        (Length(lIni.ReadString('dllinfo', 'description', '')) > 255) Or
          {validate description size}
        (lIni.ReadString('dllinfo', 'fileGUID', '') = '') Or
          {validate dll guid}
        (Length(lIni.ReadString('dllinfo', 'fileGUID', '')) <> 38) Or
          {validate guid size}
        Not _IsValidGuid(lIni.ReadString('dllinfo', 'fileGUID', '')) Or
          {validate guid}
        Not ((lIni.ReadString('dllinfo', 'DLLType', '') = 'E') Or
          {validate type of dll}
          (lIni.ReadString('dllinfo', 'DLLType', '') = 'I')) Then
        Begin
          _CallDebugLog('Invalid Plugin. Reason: Invalid Parameters. File: ' +
            lFiles[lCont]);
          lParams := False;
          Break;
        End; {if all ini sections are ok...}
      End; {If Assigned(lIni) Then}

      FreeAndNil(lIni);
    End; {for lCont:= 0 to lFiles.Count - 1 do}

    _CallDebugLog('cfg files ok. End Reading .ini files');
  End; {if lCFGOk then}

  {if cfg files are ok and all the parameters are ok, lets register these files into ice DB}
  If lCFGOk And lParams Then
  Begin
    lUpdate := True;

    _CallDebugLog('cfg and params ok. deleting imp packages');

    DeleteImpPackages;

    _CallDebugLog('cfg and params ok. deleting exp packages');
    DeleteExPackages;

    For lCont := 0 To lFiles.Count - 1 Do
    Begin
      Try
        lIni := TIniFile.Create(lFiles[lCont]);
      Except
        lIni := Nil;
      End;

      If Assigned(lIni) Then
      Begin
        {set export packages}
        If Lowercase(lIni.ReadString('dllinfo', 'DLLType', '')) = 'e' Then
        Begin
          If Not SetExportPackage(0,
            lIni.ReadString('dllinfo', 'description', ''),
            lIni.ReadString('dllinfo', 'link', ''),
            _SafeStringToGuid(lIni.ReadString('dllinfo', 'fileGUID', '')),
            StrToIntDef(lIni.ReadString('dllinfo', 'UserReference', '0'), 0))
            Then
            lUpdate := False;
        End
        Else If Lowercase(lIni.ReadString('dllinfo', 'DLLType', '')) = 'i' Then
          {set import packages}
        Begin
          If Not SetImportPackage(0,
            lIni.ReadString('dllinfo', 'description', ''),
            lIni.ReadString('dllinfo', 'link', ''),
            _SafeStringToGuid(lIni.ReadString('dllinfo', 'fileGUID', '')),
            StrToIntDef(lIni.ReadString('dllinfo', 'UserReference', '0'), 0))
            Then
            lUpdate := False;
        End;
      End; {If Assigned(lIni) Then}

      FreeAndNil(lIni);
    End; {for lCont := 0 to lFiles.Count - 1 do}

    _CallDebugLog('end imp exp package instalation');
  End;

  FreeAndNil(lFiles);
  Result := lCFGOk And lParams And lUpdate;
End;

{-----------------------------------------------------------------------------
  Procedure: RegisterEmailSystem
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.RegisterEmailSystem;
Var
  lCont: Integer;
  lFiles: TStringList;
  lSearchRec: TSearchRec;
  lRes: Longword;
  lAux: String;
  lIni: TIniFile;
  lESystem: TEmailSystem;
Begin
  lFiles := TStringList.Create;
  lAux := IncludeTrailingPathDelimiter(_GetApplicationPath + cEMAILSYSTEMDIR);

  {look up email system files}
  lRes := SysUtils.FindFirst(lAux + '*.cfg', faAnyFile, lSearchRec);
  While lRes = 0 Do
  Begin
    lFiles.Add(lAux + lSearchRec.Name);
    lRes := SysUtils.FindNext(lSearchRec);
  End; {While lRes = 0 Do}

  Sysutils.FindClose(lSearchRec);

  {open the cfg files and verify theis parameters}
  For lCont := lFiles.Count - 1 Downto 0 Do
  Begin
    Try
      lIni := TIniFile.Create(lFiles[lCont]);
    Except
      lIni := Nil;
    End;

    If Assigned(lIni) Then
    Begin
      {the dsr MUST verify all parameters oterwise is not going to work properly}
      If (lIni.ReadString('EmailSystem', 'servertype', '') = '') Or
        (lIni.ReadString('EmailSystem', 'Description', '') = '') Or
        (lIni.ReadString('EmailSystem', 'incomingguid', '') = '') Or
        (lIni.ReadString('EmailSystem', 'outgoingguid', '') = '') Then
        lFiles.Delete(lCont);
    End {If Assigned(lIni) Then}
    Else
      lFiles.Delete(lCont);

    FreeAndNil(lIni);
  End; {for lCont:= 0 to lFiles.Count - 1 do}

  DeactivateEmailSystem;

  {if cfg files are ok and all the parameters are ok, lets register these files into ice DB}
  If lFiles.Count > 0 Then
  Begin
    For lCont := 0 To lFiles.Count - 1 Do
    Begin
      Try
        lIni := TIniFile.Create(lFiles[lCont]);
      Except
        lIni := Nil;
      End;

      If Assigned(lIni) Then
      Begin
        lESystem := TEmailSystem.Create;

        lESystem.Active := lIni.ReadBool('EmailSystem', 'active', false);
        lESystem.ServerType := lIni.ReadString('EmailSystem', 'servertype', '');
        lESystem.Description := lIni.ReadString('EmailSystem', 'Description', '');
        lESystem.IncomingGuid := lIni.ReadString('EmailSystem', 'incomingguid', '');
        lESystem.OutgoingGuid := lIni.ReadString('EmailSystem', 'outgoingguid', '');

        If EmailSystemExists(lESystem.ServerType) Then
          UpdateEmailSystem(lESystem, dbDoUpdate)
        Else
          UpdateEmailSystem(lESystem, dbDoAdd);

        lESystem.Free;
      End; {If Assigned(lIni) Then}

      FreeAndNil(lIni);
    End; {for lCont := 0 to lFiles.Count - 1 do}
  End;

  FreeAndNil(lFiles);
End;

{-----------------------------------------------------------------------------
  Procedure: CheckUserAndPassword
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetContacts: Olevariant;
Var
  lCont: Integer;
  lSql: String;
Begin
  Result := Null;
  lSql := 'select * from contacts order by contactname asc';

  If RecordExists(lSql, false) Then
  Begin
    First;
    Result := VarArrayCreate([0, RecordCount], varVariant);
    lCont := 0;
    While Not Eof Do
    Begin
      Result[lCont] := VarArrayOf([
        fieldbyname('contactname').asString,
          Trim(fieldbyname('contactmail').asString),
          fieldbyname('company_id').asInteger
          ]);

      Next;
      Inc(lCont);
    End; {While Not Eof Do}
  End; {If RecordExists('select * from addressbook', false) Then}

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: SearchPackageId
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.CheckUserAndPassword(Const pUser, pPassword: String): Boolean;
Var
  lSql: String;
Begin
  Result := False;
  If (pUser <> '') And (pPassword <> '') Then
  Begin
    lSql := ' select password from users where userlogin = ' +
      QuotedStr(Trim(pUser));

    If RecordExists(lsql, False) Then
      Result := _DecryptString(FieldByName('password').AsString) = pPassword;

    CloseAndClearSql;
  End; {If (pUser <> '') And (pPassword <> '') Then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetUsers
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.SearchPackageId(Const pXml: Widestring): Integer;
Var
  lXmlDoc: TXMLDoc;
  lXmlHeader: TXMLHeader;
Begin
  Result := -1;

  If pXml <> '' Then
  Try
    lXmlDoc := TXMLDoc.Create;
    If lXmlDoc.LoadXml(pXml) Then
    Begin
      FillChar(lXmlHeader, SizeOF(TXMLHeader), #0);
      If _GetXmlHeader(lXmlDoc, lXmlHeader) Then
        Result := GetImportIdbyLink(lXmlHeader.Plugin);
    End; {If lXmlDoc.LoadXml(lXml) Then}
  Finally
    If Assigned(lXmlDoc) Then
      FreeAndNil(lXmlDoc);
  End; {If lXml <> '' Then}
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteExPackages
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetUsers: Olevariant;
Var
  lSql: String;
  lCont: Integer;
Begin
  Result := Null;

  lSql := ' select * from users order by username asc';
  If RecordExists(lsql, False) Then
  Begin
    Result := VarArrayCreate([0, RecordCount], varVariant);
    First;
    lCont := 0;

    While Not Eof Do
    Begin
      Result[lCont] := VarArrayOf([
        fieldbyname('username').asString,
          fieldbyname('userlogin').asString,
          _CreateFakedString(Length(FieldByName('password').asstring))
          ]);
      Next;
      Inc(lCont);
    End; {While Not Eof Do}
  End; {If RecordExists(lsql, False) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteIceDBLog
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.DeleteExPackages;
Var
  lSp: TADOStoredProc;
Begin
  If Connected Then
  Try
    lSp := TADOStoredProc.Create(Nil);
    lSp.ConnectionString := fADOConnection.ConnectionString;
    lSp.ProcedureName := 'sp_DELETE_EXPPACKAGE';

    Try
      lSp.ExecProc;
    Except
    End;

  Finally
    If Assigned(lSp) Then
      FreeAndNil(lSp);
  End; {If Connected Then}
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteIceDBLog
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.DeleteIceDBLog(Const pDays: Integer = cLOGTIMELIFE);
Var
  lSp: TADOStoredProc;
Begin
  If fADOConnection.Connected Then
  Try
    lSp := TADOStoredProc.Create(Nil);
    lSp.ConnectionString := fADOConnection.ConnectionString;
    lSp.ProcedureName := 'sp_DELETE_ICELOG';

    With lSp.Parameters.AddParameter Do
    Begin
      Name := 'pDays';
      Value := pDays;
    End; {With lSp.Parameters.AddParameter Do}

    Try
      lSp.ExecProc;
    Except
    End;
  Finally
    If Assigned(lSp) Then
      FreeAndNil(lSp);
  End; {If fADOConnection.Connected Then}
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateIceLog
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.UpdateIceLog(Const pWhere, pMsg: String);
Var
  lLog: _Base;
Begin
  If Assigned(fADOConnection) Then
  Begin
    lLog := _Base.Create;
    Try
      lLog.ConnectionString := Self.ConnectionString;
      lLog.LogToDB(_GetApplicationName + ' [' + pWhere + ']', pMsg);
    Finally
      lLog.Free;
    End;

    {also clear old logs}
    DeleteIceDBLog;
  End; {If Assigned(fADOConnection) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetLog
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetLog: OleVariant;
Var
  lSql: String;
  lCont: Integer;
Begin
  Result := Null;

  lSql := ' select * from icelog order by id desc';
  If RecordExists(lsql, False) Then
  Begin
    Result := VarArrayCreate([0, RecordCount], varVariant);
    First;
    lCont := 0;

    While Not Eof Do
    Begin
      Result[lCont] := VarArrayOf([
        fieldbyname('id').asString,
          fieldbyname('description').asString,
          FieldByName('location').asstring,
          FieldByName('lastupdate').asstring
          ]);
      Next;
      Inc(lCont);
    End; {While Not Eof Do}
  End; {If RecordExists(lsql, False) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteImpPackages
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.DeleteImpPackages;
Var
  lSp: TADOStoredProc;
Begin
  If Connected Then
  Try
    lSp := TADOStoredProc.Create(Nil);
    lSp.ConnectionString := fADOConnection.ConnectionString;
    lSp.ProcedureName := 'sp_DELETE_IMPPACKAGE';

    Try
      lSp.ExecProc;
    Except
    End;
  Finally
    If Assigned(lSp) Then
      FreeAndNil(lSp);
  End; {If Connected Then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetDateFormat
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetDateFormat: String;
Var
  lSql: String;
Begin
  lSql := 'sp_helplanguage @@LANGUAGE';
  If RecordExists(lSql, False) Then
  Begin
    Try
      Result := lowercase(FieldByName('dateformat').asstring);
    Except
      Result := 'mdy'
    End;
  End
  Else
    Result := 'mdy';

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetDbFileName
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetDbFileName: String;
Var
  lSql: String;
Begin
  Result := '';
  lSql := 'sp_helpfile ' + cICEDATABASE;
  If RecordExists(lSql, False) Then
  Try
    Result := lowercase(FieldByName('filename').asstring);
  Except
  End;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: DBExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.DBExists(Const pDb: String): Boolean;
Var
  lQry: TADOQuery;
Begin
  Result := False;
  Try
    lQry := TADOQuery.Create(Nil);
    if Trim(fInstance) = '' then
      lQry.ConnectionString := Format(cADOCONNECTIONMASTER, [fServer])
    else
      lQry.ConnectionString := Format(cADOCONNECTIONMASTER, [fServer + '\' +  fInstance]);

    lQry.SQL.Text := 'sp_helpdb ';

    {execute store procedure command}
    Try
      lQry.Open;
    Except
    End;

    {check if any database exists }
    If lQry.Active And Not lQry.IsEmpty Then
      With lQry Do
      Begin
        First;
        {check for specific database name}
        While Not eof Do
        Begin
          Result := LowerCase(Trim(fieldbyName('name').asString)) = LowerCase(pDb);
          If Result Then
            Break;
          Next;
        End; {while not eof do}
      End; {with lQry do}
  Finally
    If Assigned(lQry) Then
    Begin
      If lQry.Active Then
        lQry.Close;

      FreeAndNil(lQry);
    End; {If Assigned(lQry) Then}
  End; {If Connected Then}
End;

{-----------------------------------------------------------------------------
  Procedure: DateTimeToSQLDateTime
  Author:    vmoura

  Sql express has some problens dealing with diferente date types.
  So, this function get the default date format (see GetDateFormat)
  and use this format to create the right format
-----------------------------------------------------------------------------}
Function TADODSR.DateTimeToSQLDateTime(pDate: TDateTime; Const pUseTime: Boolean
  = True): String;
Var
  y, m, d, h, mm, s, ms: Word;
Begin
  DecodeDate(pDate, y, m, d);
  DecodeTime(pDate, h, mm, s, ms);
  If DateFormat = 'dmy' Then
    Result := IntToStr(d) + '-' + IntToStr(m) + '-' + IntToStr(y)
  Else If DateFormat = 'ymd' Then
    Result := IntToStr(y) + '-' + IntToStr(m) + '-' + IntToStr(d)
  Else If DateFormat = 'ydm' Then
    Result := IntToStr(y) + '-' + IntToStr(d) + '-' + IntToStr(m)
  Else If DateFormat = 'myd' Then
    Result := IntToStr(m) + '-' + IntToStr(y) + '-' + IntToStr(d)
  Else If DateFormat = 'dym' Then
    Result := IntToStr(d) + '-' + IntToStr(y) + '-' + IntToStr(m)
  Else
    Result := IntToStr(m) + '-' + IntToStr(d) + '-' + IntToStr(y); //mdy: ; //US

  If pUseTime Then
    Result := Result + ' ' + IntToStr(h) + ':' + IntToStr(mm) + ':' +
      IntToStr(s);
End;

{-----------------------------------------------------------------------------
  Procedure: AddNewContact
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.AddNewContact(Const pContactName, pContactMail: String;
  pContactCompany: Longword): Boolean;
Var
  lSql: String;
Begin
  lSql := 'insert into contacts (contactname, contactmail, company_id) values '
    + ' ( ' + QuotedStr(Copy(Trim(pContactName), 1, 255)) +
    ', ' + QuotedStr(Copy(Trim(pContactMail), 1, 255)) +
    ', ' + inttostr(pContactCompany) +
    ')';

  Result := Exec(lSql, True);
End;

{-----------------------------------------------------------------------------
  Procedure: AddNewUser
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.AddNewUser(Const pUserName, pUserLogin, pPassword: String):
  Boolean;
Var
  lSql, lPass: String;
Begin
  lPass := Copy(Trim(pPassword), 1, 16);
  lPass := _EncryptString(lPass);
  lSql := 'insert into users (username, userlogin, password) values ' +
    ' ( ' + QuotedStr(Copy(Trim(pUserName), 1, 32)) +
    ', ' + QuotedStr(Copy(Trim(pUserLogin), 1, 32)) +
    ', ' + QuotedStr(lPass) + ')';

  Result := Exec(lSql, True);
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteContact
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.DeleteContact(Const pContactMail: String): Boolean;
Var
  lSql: String;
Begin
  lSql := ' delete contacts where contactmail = ' +
    QuotedStr(Trim(pContactMail));
  Result := Exec(lSql, False);
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteUser
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.DeleteUser(Const pUserLogin: String): Boolean;
Var
  lSql: String;
Begin
  lSql := ' delete users where userlogin = ' + QuotedStr(Trim(pUserlogin));
  Result := Exec(lSql, False);
End;

{-----------------------------------------------------------------------------
  Procedure: SearchContact
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.SearchContact(Const pContactMail: String): Boolean;
Begin
  Result := RecordExists('select id from contacts where contactmail = ' +
    QuotedStr(Trim(pContactMail)));
End;

{-----------------------------------------------------------------------------
  Procedure: SearchUser
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.SearchUser(Const pUserLogin: String): Boolean;
Begin
  Result := RecordExists('select id from users where userlogin = ' +
    QuotedStr(Trim(pUserLogin)));
End;

{-----------------------------------------------------------------------------
  Procedure: CheckScheduleTypes
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.CheckScheduleTypes;
Var
  lSql: String;
Begin
  lSql := ' select * from scheduletype';
  If Not RecordExists(lSql) Then
  Begin
    {set the schedule types. the dsr is using only daily schedule now}

    lsql := 'insert into scheduletype (description) values (' +
      QuotedStr(cDAILYSCHEDULENAME) + ')';
    Exec(lsql);

{    lsql := 'insert into scheduletype values (' + ')';
    ExecSql(lsql);
    lsql := 'insert into scheduletype values (' + ')';
    ExecSql(lsql);
    lsql := 'insert into scheduletype values (' + ')';
    ExecSql(lsql);}
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: GetConnected
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetConnected: Boolean;
Begin
  If Assigned(fADOConnection) Then
  Begin
    Try
      Result := fADOConnection.Connected;
    Except
      On e: exception Do
      Begin
        Result := False;
        _LogMSG('TADODSR.GetConnected :- Error acessing Database Object. Error: ' +
          e.message);
      End; {begin}
    End; {try}
  End
  Else
    Result := False;
End;

{-----------------------------------------------------------------------------
  Procedure: SetConnected
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetConnected(Const Value: Boolean);
Begin
  If Assigned(fADOConnection) Then
  Begin
    Try
      fADOConnection.Connected := Value;
    Except
      On e: exception Do
        _LogMSG('TADODSR.SetConnected :- Error acessing Database Object. Error: ' +
          e.message);
    End; {try}
  End; {If Assigned(fADOConnection) Then}
End;

///////////////////////// CIS FUNCTIONS ///////////////////////////

{-----------------------------------------------------------------------------
  Procedure: UpdateCIS
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.UpdateCIS(pGuid: TGuid; Const pIrMark, pCorrelationId,
  pClassType, pRedirection, pFileGuid: String; pPollingTime: Integer; pAction:
  TDBOption): Boolean;
Var
  lSql: String;
  lId: Integer;
Begin
  Result := False;
  {get outbox entry referent to that guid}
  lId := SearchOutboxEntry(pGuid);

  Case pAction Of
    dbDoUpdate:
      Begin
        lSql := 'update cis ';
        lSql := lSql + ' set irmark = ' + QuotedStr(pIrMark);
        lSql := lSql + ' , correlationid = ' + QuotedStr(pCorrelationId);
        lSql := lSql + ' , polling = ' + inttostr(pPollingTime);
        lSql := lSql + ' , redirection = ' + QuotedStr(pRedirection);
        lSql := lSql + ' , classtype = ' + QuotedStr(pClassType);
        lSql := lSql + ' , fileguid = ' + QuotedStr(pFileGuid);
        //lSql := lSql + ' , counter = counter + 1 ';
        lSql := lSql + ' where outbox_id = ' + inttostr(lId);
        lSql := lSql + ' and outbox_guid = ' + QuotedStr(GUIDToString(pGuid));
        Result := Exec(lSql, True);
      End; {begin}
    dbDoAdd:
      Begin
        lSql :=
          'insert into cis (outbox_id, outbox_guid, irmark, correlationid, classtype, polling, redirection, fileguid) values ';
        lSql := lSql + ' (' + inttostr(lId) + ', ' +
          QuotedStr(GUIDToString(pGuid)) + ', ' + QuotedStr(pIrMark) +
          ', ' + QuotedStr(pCorrelationId) + ', ' + QuotedStr(pClassType) +
          ', ' + inttostr(pPollingTime) + ', ' + QuotedStr(pRedirection) +
          ', ' + QuotedStr(pFileGuid) + ' ) ';
        Result := Exec(lSql, True);
      End; {begin}
    dbDoDelete:
      Begin
        lSql := 'delete from cis where outbox_id = ' + inttostr(lId);
        lSql := lSql + ' or outbox_guid = ' + QuotedStr(GUIDToString(pGuid));
        Result := Exec(lSql, False);
      End; {begin}
  End; {Case pAction Of}
End;

{-----------------------------------------------------------------------------
  Procedure: HasCISRecord
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.HasCISRecord(pGuid: TGuid): Boolean;
Var
  lSql: String;
Begin
  Result := False;
  If _IsValidGuid(pGuid) Then
  Begin
    lSql := ' select id from cis where outbox_guid = ' +
      QuotedStr(GUIDToString(pGuid));
    Result := RecordExists(lSql);
  End; {if _IsValidGuid(pGuid) then}
End;

{-----------------------------------------------------------------------------
  Procedure: AddCISDefaultEmailAccount
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.AddCISDefaultEmailAccount;
Var
  lAcc: TEmailAccount;
  lESystem: TEmailSystem;
Begin
  DeleteAllEmailAccounts;
  lAcc := TEmailAccount.Create;
  lESystem := GetEmailSystemByServerType('CIS');
  If lESystem <> Nil Then
  Begin
    lAcc.EmailSystem_ID := lESystem.Id;

    lESystem.Free;

    lAcc.YourName := GetSystemValue(cCOMPANYNAMEPARAM);
    lAcc.YourEmail := lAcc.YourName;
    lAcc.ServerType := cCIS;
    lAcc.IsDefaultOutgoing := True;
  End; {if lESystem <> nil then}

  UpdateEmailAccount(lAcc, dbDoAdd);

  lAcc.Free;
End;

{-----------------------------------------------------------------------------
  Procedure: RemoveCISDefaultAccount
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.RemoveCISDefaultAccount;
Var
  lSql: String;
Begin
  lSql := ' delete from emailaccounts where servertype = ' + QuotedStr(cCIS);
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateDatabase
  Author:    vmoura

  check for the file to update ice database. this file contais lines and sql commands one by line
-----------------------------------------------------------------------------}
Procedure TADODSR.UpdateDatabase(Const pFile: String; Const pCreate: Boolean =
  False);
Const
                 { sql command ; master database; db connection; input file; output file; timeout (sec)}
  cCMDCREATEDB = 'sqlcmd -d master -S %s -i %s -o %s -t 20';
  cCMDUPDATEDB =
    'sqlcmd -d IRISCommunicationEngine -S %s -i %s -o %s -t 20';

  cRESULTCREATEFILE = 'ResultCreateDB.txt';
  cRESULTUPDATEFILE = 'ResultUpdateDB.txt';
Var
  lCmd, lServer: String;
Begin
  {check file exists}
  If _FileSize(pFile) > 0 Then
  Begin
    If Trim(fInstance) = '' Then
      lServer := fServer
    Else
      lServer := fServer + '\' + finstance;

    {format the command line for creating/updating the database}
    If pCreate Then
      lCmd := Format(cCMDCREATEDB, [lServer, pFile, _GetApplicationPath +
        cRESULTCREATEFILE])
    Else
      lCmd := Format(cCMDUPDATEDB, [lServer, pFile, _GetApplicationPath +
        cRESULTUPDATEFILE]);

    If _DecryptFile(pFile) Then
    Begin
      _LogMSG('TADODSR.UpdateDatabase :- Executing Database Update commands...');

      {run the command line...}
      _fileExec(lCmd, True, False);

      Sleep(20000);

      _LogMSG('TADODSR.UpdateDatabase :- The Database Update result can be found at '
        + ifThen(pCreate, cRESULTCREATEFILE, cRESULTUPDATEFILE));

      _DelFile(pFile);
    End
    Else
      _LogMSG('TADODSR.UpdateDatabase :- Invalid file ' + pFile +
        ' for Database updating. Error: Not valid encrypted file.');
  End
  Else
    _LogMSG('TADODSR.UpdateDatabase :- Invalid file ' + pFile +
      ' for Database updating...');
End;

{-----------------------------------------------------------------------------
  Procedure: GetVersion
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetVersion: String;
Begin
  Result := GetSystemValue('version');
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateVersion
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.UpdateVersion(Const pValue: String);
Begin
  SetSystemParameter('version', pValue);
End;

{-----------------------------------------------------------------------------
  Procedure: GetParam
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetSystemValue(Const pParam: String): String;
Var
  lSql: String;
Begin
  Result := '';
  lSql := ' select value from system where description = ' + QuotedStr(pParam);
  If RecordExists(lSql, False) Then
    Result := FieldByName('value').AsString;
  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: SetSystemParameter
  Author:    vmoura

  update system table.
-----------------------------------------------------------------------------}
Procedure TADODSR.SetSystemParameter(Const pParam, pValue: String);
Var
  lSql, lValue: String;
Begin
  {check if the version is blank and add that as the first version of the software}
  lValue := GetSystemValue(pParam);
  If lValue = '' Then
  Begin
    {quick delete}
    lSql := 'delete from system where description = ' + QuotedStr(pParam);
    Exec(lSql);

    lSql := 'insert into system (description, value) values (' + QuotedStr(pParam) +
      ', ' + QuotedStr(pValue) + ')';

    Exec(lSql);
  End {otherwise, just update}
  Else
  Begin
    lSql := 'update system set value = ' + QuotedStr(pValue);
    lSql := lSql + ' where description = ' + QuotedStr(pParam);
    Exec(lSql);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateEmailAccount
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.UpdateEmailAccount(pEmailAccount: TEmailAccount;
  pAction: TDBOption): Boolean;
Var
  lSql: String;
Begin
  Result := False;
  If pEmailAccount <> Nil Then
  Begin
    Case pAction Of
      dbDoUpdate:
        Begin
          With pEmailAccount Do
            lSql := ' update emailaccounts set ' +
              ' emailsystem_id = ' + IntToStr(EmailSystem_ID) + ', ' +
              ' yourname = ' + QuotedStr(YourName) + ', ' +
              ' servertype = ' + QuotedStr(servertype) + ', ' +
              ' isdefault = ' + Inttostr(ord(IsDefaultOutgoing)) + ', ' +
              ' incomingserver = ' + QuotedStr(IncomingServer) + ', ' +
              ' outgoingserver = ' + QuotedStr(OutgoingServer) + ', ' +
              ' username = ' + QuotedStr(UserName) + ', ' +
              ' password = ' + QuotedStr(_EncryptString(Password)) + ', ' +
              ' incomingport = ' + IntToStr(IncomingPort) + ', ' +
              ' outgoingport = ' + IntToStr(OutgoingPort) + ', ' +
              ' authentication = ' + IntToStr(Ord(Authentication)) + ', ' +
              ' outgoingusername = ' + QuotedStr(OutgoingUserName) + ', ' +
              ' outgoingpassword = ' + QuotedStr(_EncryptString(OutgoingPassword)) +
              ', ' +
              ' usesslincomingport = ' + IntToStr(Ord(UseSSLIncomingPort)) + ', ' +
              ' usessloutgoingport = ' + IntToStr(Ord(UseSSLOutgoingPort)) + ', ' +
              ' mailboxname = ' + QuotedStr(MailBoxName) + ', ' +
              ' mailboxseparator = ' + QuotedStr(Trim(MailBoxSeparator));

          lSql := lSql + ' where youremail = ' + QuotedStr(pEmailAccount.YourEmail);
        End; {case dbDoUpdate}

      dbDoAdd:
        Begin
          lSql := ' insert into emailaccounts (youremail, emailsystem_id, '
            + ' yourname, servertype, isdefault, incomingserver, outgoingserver, username, ' +
            ' password, incomingport, outgoingport, authentication, outgoingusername, ' +
            ' outgoingpassword, usesslincomingport, usessloutgoingport, mailboxname, mailboxseparator) values ';

          With pEmailAccount Do
            lSql := lSql + ' (' +
              QuotedStr(YourEmail) + ', ' +
              IntToStr(EmailSystem_ID) + ', ' +
              QuotedStr(YourName) + ', ' +
              QuotedStr(servertype) + ', ' +
              Inttostr(ord(IsDefaultOutgoing)) + ', ' +
              QuotedStr(IncomingServer) + ', ' +
              QuotedStr(OutgoingServer) + ', ' +
              QuotedStr(UserName) + ', ' +
              QuotedStr(_EncryptString(Password)) + ', ' +
              IntToStr(IncomingPort) + ', ' +
              IntToStr(OutgoingPort) + ', ' +
              IntToStr(Ord(Authentication)) + ', ' +
              QuotedStr(OutgoingUserName) + ', ' +
              QuotedStr(_EncryptString(OutgoingPassword)) + ', ' +
              IntToStr(Ord(UseSSLIncomingPort)) + ', ' +
              IntToStr(Ord(UseSSLOutgoingPort)) + ', ' +
              QuotedStr(MailBoxName) + ', ' +
              QuotedStr(Trim(MailBoxSeparator)) + ' ) ';
        End; {case dbdoadd}

      dbDoDelete:
        lSql := 'delete from emailaccounts where youremail = ' +
          QuotedStr(pEmailAccount.YourEmail);
    End; {case pAction of}

    If lSql <> '' Then
      Result := Exec(lSql, True);

    If Result Then
      If pEmailAccount.IsDefaultOutgoing Then
        SetDefaultEmailAccount(pEmailAccount);
  End; {if pEmailAccount <> nil then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetEmailAccounts
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetEmailAccounts(Out pResult: Longword): Olevariant;
Var
  lCount: Integer;
  lSql: String;
Begin
  Result := Null;
  pResult := S_OK;
  lSql := ' select * from emailaccounts ';

  { find out about the records requested}
  If RecordExists(lSql, False) Then
  Begin
    First;
    lCount := 0;
    Result := VarArrayCreate([0, RecordCount], varVariant);

    While Not Eof Do
    Begin
      Result[lCount] := VarArrayOf([
        fieldbyname('youremail').asString,
          fieldbyname('emailsystem_id').AsInteger,
          fieldbyname('yourname').AsString,
          fieldbyname('servertype').AsString,
          fieldbyname('isdefault').Asboolean,
          fieldbyname('incomingserver').AsString,
          fieldbyname('outgoingserver').AsString,
          fieldbyname('username').AsString,
          _DecryptString(fieldbyname('password').AsString),
          fieldbyname('incomingport').AsInteger,
          fieldbyname('outgoingport').AsInteger,
          fieldbyname('authentication').asBoolean,
          fieldbyname('outgoingusername').AsString,
          _DecryptString(fieldbyname('outgoingpassword').AsString),
          fieldbyname('usesslincomingport').AsBoolean,
          fieldbyname('usessloutgoingport').AsBoolean,
          fieldbyname('mailboxname').AsString,
          fieldbyname('mailboxseparator').AsString
          ]);

      Next;
      Inc(lCount);
    End;
  End
  Else
    pResult := cDBNORECORDFOUND;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: EmailExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.EmailExists(Const pEmail: String): Boolean;
Var
  lSql: String;
Begin
  lSql := ' select id from emailaccounts where youremail = ' + QuotedStr(pEmail);
  Result := RecordExists(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: GetDefaultEmailAccount
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetDefaultEmailAccount: String;
Var
  lSql: String;
  lAcc: TEmailAccount;
Begin
  Result := '';
(*  lSql := ' select youremail from emailaccounts where isdefault = 1';
  If RecordExists(lSql, False) Then
    Result := fieldbyname('youremail').asString;
  CloseAndClearSql;*)
  lAcc := GetDefaultAccount;
  If lAcc <> Nil Then
  Begin
    Result := lAcc.YourEmail;
    lAcc.Free;
  End; {if lAcc <> nil then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetDefaultAccount
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetDefaultAccount: TEmailAccount;
Var
  lSql: String;
Begin
  Result := Nil;
  lSql := ' select * from emailaccounts where isdefault = 1';
  If RecordExists(lSql, False) Then
  Try
    Result := TEmailAccount.Create;
    Result.YourEmail := fieldbyname('youremail').asString;
    Result.EmailSystem_ID := fieldbyname('emailsystem_id').AsInteger;
    Result.YourName := fieldbyname('yourname').AsString;
    Result.ServerType := fieldbyname('servertype').AsString;
    Result.IsDefaultOutgoing := fieldbyname('isdefault').Asboolean;
    Result.IncomingServer := fieldbyname('incomingserver').AsString;
    Result.OutgoingServer := fieldbyname('outgoingserver').AsString;
    Result.UserName := fieldbyname('username').AsString;
    Result.Password := _DecryptString(fieldbyname('password').AsString);
    Result.IncomingPort := fieldbyname('incomingport').AsInteger;
    Result.OutgoingPort := fieldbyname('outgoingport').AsInteger;
    Result.Authentication := fieldbyname('authentication').asBoolean;
    Result.OutgoingUserName := fieldbyname('outgoingusername').AsString;
    Result.OutgoingPassword :=
      _DecryptString(fieldbyname('outgoingpassword').AsString);
    Result.UseSSLIncomingPort := fieldbyname('usesslincomingport').AsBoolean;
    Result.UseSSLOutgoingPort := fieldbyname('usessloutgoingport').AsBoolean;
    Result.MailBoxName := fieldbyname('mailboxname').AsString;
    If fieldbyname('mailboxseparator').AsString <> '' Then
    Try
      Result.MailBoxSeparator := fieldbyname('mailboxseparator').AsString[1];
    Except
      Result.MailBoxSeparator := '/';
    End;
  Except
    On e: exception Do
    Begin
      Result := Nil;
      fLog.DoLogMessage('TADODSR.GetDefaultAccount', cDBERROR,
        'Error processing request. Error: ' + e.message, True, True);
    End;
  End;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: SetDefaultEmailAccount
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.SetDefaultEmailAccount(pEmailAccount: TEmailAccount);
Var
  lSql: String;
Begin
  lSql := ' update emailaccounts set isdefault = 0';
  Exec(lSql);

  lSql := ' update emailaccounts set isdefault = 1';
  lSql := lSql + ' where youremail = ' + QuotedStr(pEmailAccount.YourEmail);
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteAllEmailAccounts
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.DeleteAllEmailAccounts;
Var
  lSql: String;
Begin
  lSql := ' delete from emailaccounts ';
  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: EmailSystemExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.EmailSystemExists(Const pServerType: String): Boolean;
Var
  lSql: String;
Begin
  lSql := ' select id from emailsystem where servertype = ' +
    QuotedStr(pServerType);
  Result := RecordExists(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: GetEmailSystem
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetEmailSystem(Out pResult: Longword): Olevariant;
Var
  lCount: Integer;
  lSql: String;
Begin
  Result := Null;
  pResult := S_OK;
  lSql := ' select * from emailsystem where isactive = 1 ';

  { find out about the records requested}
  If RecordExists(lSql, False) Then
  Begin
    First;
    lCount := 0;
    Result := VarArrayCreate([0, RecordCount], varVariant);

    While Not Eof Do
    Begin
      Result[lCount] := VarArrayOf([
        fieldbyname('id').asInteger,
          fieldbyname('servertype').AsString,
          fieldbyname('description').AsString,
          fieldbyname('incomingguid').AsString,
          fieldbyname('outgoingguid').AsString,
          fieldbyname('isactive').AsBoolean
          ]);

      Next;
      Inc(lCount);
    End;
  End
  Else
    pResult := cDBNORECORDFOUND;

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetEmailSystem
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetEmailSystemById(pId: Integer): TEmailSystem;
Var
  lSql: String;
Begin
  Result := Nil;
  lsql := ' select * from emailsystem where id = ' + inttostr(pId);
  If RecordExists(lSql, False) Then
  Begin
    Result := TEmailSystem.Create;
    Result.Id := fieldbyname('id').asInteger;
    Result.ServerType := fieldbyname('servertype').AsString;
    REsult.Description := fieldbyname('description').AsString;
    Result.IncomingGuid := fieldbyname('incomingguid').AsString;
    REsult.OutgoingGuid := fieldbyname('outgoingguid').AsString;
    Result.Active := fieldbyname('isactive').AsBoolean;
  End; {if RecordExists(lSql) then}

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: GetEmailSystemByServerType
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.GetEmailSystemByServerType(Const pServerType: String):
  TEmailSystem;
Var
  lSql: String;
Begin
  Result := Nil;
  lsql := ' select * from emailsystem where servertype = ' + QuotedStr(pServerType);
  If RecordExists(lSql, False) Then
  Begin
    Result := TEmailSystem.Create;
    Result.Id := fieldbyname('id').asInteger;
    Result.ServerType := fieldbyname('servertype').AsString;
    REsult.Description := fieldbyname('description').AsString;
    Result.IncomingGuid := fieldbyname('incomingguid').AsString;
    REsult.OutgoingGuid := fieldbyname('outgoingguid').AsString;
    Result.Active := fieldbyname('isactive').AsBoolean;
  End; {if RecordExists(lSql) then}

  CloseAndClearSql;
End;

{-----------------------------------------------------------------------------
  Procedure: DeactivateEmailSystem
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TADODSR.DeactivateEmailSystem(Const pSystem: String = '');
Var
  lSql: String;
Begin
  lSql := ' update emailsystem set isactive = 0 ';

  If Trim(pSystem) <> '' Then
    lSql := lsql + ' where servertype = ' + QuotedStr(pSystem);

  Exec(lSql);
End;

{-----------------------------------------------------------------------------
  Procedure: UpdateEmailSystem
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TADODSR.UpdateEmailSystem(pSystem: TEmailSystem;
  pAction: TDBOption): Boolean;
Var
  lSql: String;
Begin
  Result := False;
  If pSystem <> Nil Then
  Begin
    Case pAction Of
      dbDoUpdate:
        Begin
          With pSystem Do
            lSql := ' update emailsystem set ' +
              ' description = ' + QuotedStr(Description) + ', ' +
              ' incomingguid = ' + QuotedStr(Incomingguid) + ', ' +
              ' outgoingguid = ' + QuotedStr(outgoingguid) + ', ' +
              ' isactive = ' + Inttostr(Ord(active));

          lSql := lSql + ' where servertype = ' + QuotedStr(pSystem.Servertype);
        End; {case dbDoUpdate}

      dbDoAdd:
        Begin
          lSql := ' insert into emailsystem (servertype, description, '
            + ' incomingguid, outgoingguid, isactive) values ';

          With pSystem Do
            lSql := lSql + ' (' +
              QuotedStr(ServerType) + ', ' +
              QuotedStr(Description) + ', ' +
              QuotedStr(IncomingGuid) + ', ' +
              QuotedStr(OutgoingGuid) + ', ' +
              Inttostr(ord(Active)) + ' ) ';
        End; {case dbdoadd}

      dbDoDelete:
        lSql := 'delete from emailsystem where servertype = ' +
          QuotedStr(pSystem.ServerType);
    End; {case pAction of}

    If lSql <> '' Then
      Result := Exec(lSql, True);
  End; {if pEmailAccount <> nil then}
End;

End.

