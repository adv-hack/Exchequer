{-----------------------------------------------------------------------------
 Unit Name: uDSRThreads
 Author:    vmoura
 Purpose:
 History:

   0.0.0.0d
   30/05/2006
     - i let only TDSRProducer and TDSRSEnder use the lock because the other thread
       dont have any interacion with the global stack

   Main Threads

   TDSRProducer :- get messages from the database and insert into a list of objects
   TDSRThread :- keep checking the list of the messages. if there is something new
                 it loads the right plugin and send if off
   TDSRChekMail :- keep checking the mail list to delete completed messages or
                   messages that are not finished yet and are pending for more
                   than 24 hours
-----------------------------------------------------------------------------}
Unit uDSRThreads;

Interface

Uses Classes,
  {ice units}
  uAdoDSR, uInterfaces, uSystemConfig, uDSRBaseThread

  ;

Type
  {get the stored mails (scheduled or about to go) and try to send it}
  TDSRProducer = Class(TDSRThread)
  Private
    fSystem: TSystemConf;
    fDB: TADODSR;
    Procedure PopulateList;
    Function FindMsg(pMail: TMessageInfo): Boolean;
    Procedure ProcessOutboxList(pMsgs: Olevariant);
    Function ProcessScheduleList(pMsgs: Olevariant): Boolean;
  Protected
    Procedure DoPause; Override;
    Procedure DoReading; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End;

  {get items from the list and call the sender}
  TDSRSenderTh = Class(TDSRThread)
  Protected
    Procedure DoPause; Override;
    Procedure DoWriting; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End;

  {keep polling the mail configuration}
  TDSRCheckMail = Class(TThread)
  Private
    fSystemConf: TSystemConf;
    fDb: TADODSR;
    fChecking: Boolean;
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  Published
    Property Checking: Boolean Read fChecking Write fChecking Default False;
  End;

  {restore an outbox message from deleted to ready to import}
  TDSRRestoreMessage = Class(TThread)
  Private
    fMsg: TMessageInfo;
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Property Msg: TMessageInfo Read fMsg Write fMsg;
  End;

  {resend an outbox message}
  TDSRResendMessage = Class(TThread)
  Private
    fMsg: TMessageInfo;
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Property Msg: TMessageInfo Read fMsg Write fMsg;
  End;

  {make the bulk export work}
  TDSRBulkTh = Class(TDSRThread)
  Private
    fMsgInfo: TMessageInfo;
    fBulkRequest: Boolean;
    Procedure MakeSyncRequest;
    Procedure MakeBulk;
  Protected
    Procedure DoPause; Override;
    Procedure DoWriting; Override;
  Public
    Constructor Create(pMsgInfo: TMessageInfo; Const pBulkRequest: Boolean =
      False); Reintroduce;
    Destructor Destroy; Override;
  Published
    Property BulkRequest: Boolean Read fBulkRequest Write fBulkRequest;
  End;

  {rebuild a deleted company based on xml packates}
  TDSRReCreateCompany = Class(TDSRThread)
  Private
    fCompany: Longword;
  Protected
    Procedure DoWriting; Override;
    Procedure DoPause; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  Published
    Property Company: Longword Read fCompany Write fCompany;
  End;

  {call export methods}
  TDSRExportTh = Class(TDSRThread)
  Private
    fMsgInfo: TMessageInfo;
  Protected
    Procedure DoPause; Override;
    Procedure DoWriting; Override;
  Public
    Constructor Create(pMsgInfo: TMessageInfo); Reintroduce;
    Destructor Destroy; Override;
  End;

  {thread that works when the automatic Dripfeed option is set
  send the new/updated records automatically}
  TDSRDripFeed = Class(TDSRThread)
  Private
    fSystem: TSystemConf;
    fDb: TADODSR;
    Procedure ProcessDripFeed;
  Protected
    Procedure DoPause; Override;
    Procedure DoWriting; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End;

  {remove the dripfeed settings from exchequer}
  TDSRRemoveDripFeed = Class(TDSRThread)
  Private
    fCompanyPath: String;
    fCompany: Longword;
    fTo_: String;
    fSubject: String;
    fFrom: String;
    fCancel: Boolean;
  Protected
    Procedure DoPause; Override;
    Procedure DoWriting; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  Published
    Property Company: Longword Read fCompany Write fCompany;
    Property CompanyPath: String Read fCompanyPath Write fCompanyPath;
    Property From: String Read fFrom Write fFrom;
    Property To_: String Read fTo_ Write fTo_;
    Property subject: String Read fSubject Write fSubject;
    Property Cancel: Boolean Read fCancel Write fCancel Default False;
  End;

Implementation

Uses Variants, IniFiles, Math, Sysutils, Activex, strutils,
   {exchequer}
  EntLicence,
  {ice}
  uDSRGlobal, uDSRSettings, uDSRExport, uDSRImport, uDSRLock, uXmlList, uDSRHistory,
  uMcm, uExFunc, uDsrMail, uCommon, uConsts, uBaseClass, uDSRCIS, uDSRFileFunc
  {, uDSRDownloadEmail}
  ;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRSenderTh.Create;
Begin
  Inherited Create;
  ThreadType := ttWrite;
  Priority := tpLower;
End;

{-----------------------------------------------------------------------------
  Procedure: DoPause
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRSenderTh.DoPause;
Begin
  Sleep(cDSRINTERVAL);
End;

{-----------------------------------------------------------------------------
  Procedure: DoWriting
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRSenderTh.DoWriting;
Var
  lMsg: TMessageInfo;
  lCont: Integer;
Begin
  If Assigned(fSync) Then
  Begin
    fSync.BeginWrite;

  { lock the thread list to perform an export operation}

    Try
      If Assigned(fSchedule) Then
        With fSchedule Do
        Try
    { check if there is an item avaiable}
          If Count > 0 Then
          Begin
            For lCont := Count - 1 Downto 0 Do
            Begin
        { check whether the objects is ok and the thread is still running}
              If Items[lCont] <> Nil Then
              Begin
                fExpLock.BeginWrite;

                Try
                  TDSRExport.CallExport(TMessageInfo(Items[lCont]));
                Finally
                  fExpLock.EndWrite;
                End; {try}

                Sleep(15000);
          { remove the first item of the list}
                lMsg := TMessageInfo(Items[lCont]);
                If Assigned(lMsg) Then
                  FreeAndNil(lMsg);

                Delete(lCont);
              End; {If Items[lCont] <> Nil Then}
            End; {For lCont := Count - 1 Downto 0 Do}
          End; {If Count > 0 Then}

        Except
        End; {try}

      DoPause;
    Finally
      fSync.EndWrite;
    End; {try}
  End; {If Assigned(fSync) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRSenderTh.Destroy;
Begin
  Inherited Destroy;
End;

{ TDSRProducer }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRProducer.Create;
Begin
  Inherited Create;
  Priority := tpLower;
  ThreadType := ttRead;

  Try
    fDB := TADODSR.Create(_DSRGetDBServer);
  Except
    On E: Exception Do
      _LogMSG('TDSRProducer.Create :- Error creating database. Error: ' +
        E.MEssage);
  End; {try}

  fSystem := TSystemConf.Create;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRProducer.Destroy;
Begin
  If Assigned(fDB) Then
    FreeAndNil(fDB);

  If assigned(fSystem) Then
    FreeAndNil(fSystem);

  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: DoPause
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRProducer.DoPause;
Begin
  Sleep(cDSRPRODUCERINTERVAL);
End;

{-----------------------------------------------------------------------------
  Procedure: DoReading
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRProducer.DoReading;
Begin
  If Assigned(fSync) Then
  Begin
    {lock for reading}
    fSync.BeginRead;

    Try
      Try
        If Not Terminated Then
        Begin
          {check database connection}
          If Not fDB.Connected Then
            fDB.TestConnection;

          {get entries from database and add to a list}
          PopulateList;
        End; {If Not Terminated Then}
      Except
      End; {try}

      DoPause;
    Finally
      fSync.EndRead; {release lock}
    End; {try}
  End; {If Assigned(fSync) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRProducer.PopulateList;
Var
  lRes: Longword;
  lOut: OleVariant;
Begin
  lOut := Null;
  {get the scheduled messages, verify if is time to be sent}
  If Not Terminated Then
  Begin
    lOut := fDB.GetOutboxScheduleMessages(0, 0, 0, lRes, False);
    If (lRes = S_OK) And Not Terminated Then
      ProcessScheduleList(lOut);
  End; {If Not terminated Then}

  lOut := Null;
  If Not Terminated Then
  Begin
    {get the messages into the outbox table that must be sent now}
    lOut := fDB.GetOutboxMessages(0, 0, cSAVED, 0, 0, lRes, False);
    If (lRes = S_OK) And Not Terminated Then
      ProcessOutboxList(lOut);
  End; {If Not terminated Then}

  {get entries written by the CIS thread}
  lOut := Null;
  If Not Terminated Then
    // fSystem.UseCISSubsystem and _ExCISInstalled
    If fDb.GetSystemValue(cISCISPARAM) = '1' Then
    Begin
      lOut := fDb.GetOutboxMessages(0, 0, cPENDING, 0, 0, lRes, False);
      If (lRes = S_OK) And Not Terminated Then
        ProcessOutboxList(lOut);

      {create cis thread that will check for new xmls}
      With TDSRCIS.Create Do
        Resume;
    End; {If fSystem.UseCISSubsystem Then}
End;

{-----------------------------------------------------------------------------
  Procedure: FindMsg
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRProducer.FindMsg(pMail: TMessageInfo): Boolean;
Var
  lCont: Integer;
Begin
  Result := False;

  If pMail <> Nil Then
    //With fSchedule.LockList Do
    With fSchedule Do
    Try
      For lCont := Count - 1 Downto 0 Do
        If (Items[lCont] <> Nil) And Not Terminated Then
          If IsEqualGUID(TMessageInfo(Items[lCont]).Guid, pMail.Guid) Then
          Begin
            Result := True;
            Break;
          End; {If Items[lCont] <> Nil Then}
    Finally
      //  fSchedule.UnlockList;
    End;

End;

{-----------------------------------------------------------------------------
  Procedure: ProcessScheduleList
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRProducer.ProcessOutboxList(pMsgs: Olevariant);
Var
  lMsg: TMessageInfo;
  lCont,
    lTotal: Integer;
Begin
  Try
    If VarIsArray(pMsgs) Then
    Begin
      {get total of messages}
      lTotal := _GetOlevariantArraySize(pMsgs);
      If (lTotal > 0) And Not Terminated Then
        For lCont := 0 To lTotal - 1 Do
        Begin
          {create a message object based on olevariant array}
          lMsg := _CreateOutboxMsgInfo(pMsgs[lCont]);
          If lMsg <> Nil Then
          Begin
            If lMsg.ScheduleId = 0 Then
            Begin
                {there is another function processing only scheduled messages}
              If Not FindMsg(lMsg) And Not Terminated Then
              Begin
                _CallDebugLog('TDSRProducer.ProcessOutboxList :- ' +
                  Datetimetostr(Now));

                fSchedule.Add(lMsg);
              End
              Else
              Begin
                FreeAndNil(lMsg);

                If Terminated Then
                  Break;
              End; {else begin}
            End {If lMsg.ScheduleId = 0 Then}
            Else
              FreeAndNil(lMsg);
          End; {If lMsg <> Nil Then}

          Sleep(1);
        End; {For lCont := 0 To lTotal - 1 Do}
    End; {If VarIsArray(lOut) Then}
  Except
    On E: Exception Do
      _LogMSG('TDSRProducer.ProcessOutboxList :- Error processing Outbox E-Mails. Error: '
        + E.Message);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRProducer.ProcessScheduleList(pMsgs: Olevariant): Boolean;
Var
  lMsg1, lMsg2: TMessageInfo;
  lCont,
    lTotal: Integer;
  lSchedule: Olevariant;
  lDaily: TDailySchedule;
  lPath: String;
Begin
  Result := False;
  Try
    lTotal := _GetOlevariantArraySize(pMsgs);
    If (lTotal > 0) And Not Terminated Then
    Begin
      For lCont := 0 To lTotal - 1 Do
      Begin
        {daily schedules messages}
        lMsg1 := _CreateOutboxMsgInfo(pMsgs[lCont]);
        If lMsg1 <> Nil Then
        Begin
          {check if this company is active or it is in history tab}
          If fDb.IsCompanyActive(lMsg1.Company_Id) Then
          Begin
        {get the company path to check if Dripfeed is active}
            lPath := fDB.GetCompanyPath(lMsg1.Company_Id);
            If Not _DirExists(lPath) Then
              lPath := _GetExCompanyPath(fDB.GetExCode(lMsg1.Company_Id));

            If _CheckExDripFeed(lPath) Then
            Begin
          {check the mode of the message and if the company is already in Dripfeed mode}
              If (lMsg1.ScheduleId > 0) And (lMsg1.Mode = Ord(rmDripFeed)) And
                Not (lMsg1.Status = cARCHIVED) Then
              Begin
                lSchedule := fDB.GetDaySchedule(lMsg1.Guid);
                If Not VarIsNull(lSchedule) And VarIsArray(lSchedule) Then
                Begin
                  lDaily := _CreateDailySchedule(lSchedule);
              {i need to make a join between schedule and daily schedule}
                  If lDaily <> Nil Then
                  Begin
                    If _VerifyDailySchedule(lDaily) Then
                    Begin
                      If Not FindMsg(lMsg1) And Not Terminated Then
                      Begin
                        _CallDebugLog('TDSRProducer.ProcessOutboxList :- ' +
                          Datetimetostr(Now));

                        lMsg2 := TMessageInfo.Create;
                        lMsg2.Assign(lMsg1);
                        lMsg2.Guid := _CreateGuid;
                        With lMsg2 Do
                          fDb.UpdateOutBox(Guid, Company_Id, Subject, From, To_,
                            Pack_Id, TotalItens, Param1, Param2, Status, Mode,
                            dbDoAdd);

                      {the only place where lmsg is not deleted and will be picked up
                      later by the processing export thread}
                        fSchedule.Add(lMsg2);
                        lMsg1.Free;
                      End
                      Else
                      Begin
                        FreeAndNil(lMsg1);
                        If Terminated Then
                          Break;
                      End; {begin}

                      Result := True;
                    End {If _VerifyDailySchedule(lDaily) Then}
                    Else
                      FreeAndNil(lMsg1);
                  End {if lDaily <> nil then}
                  Else
                    FreeAndNil(lMsg1);

                  If Assigned(lDaily) Then
                    FreeAndNil(lDaily);
                End {If VarIsArray(lSchedule) Then}
                Else
                  FreeAndNil(lMsg1);
              End {if lMsg.ScheduleId > 0 then}
              Else
                FreeAndNil(lMsg1);
            End {If _CheckExDripFeed(lPath) Then}
            Else
              FreeAndNil(lMsg1);
          End {If fDb.IsCompanyActive(lMsg1.Company_Id) Then}
          Else
            FreeAndNil(lMsg1);
        End; {If lMsg <> Nil Then}

        Sleep(1);
      End; {For lCont := 0 To lTotal - 1 Do}
    End; {If (lTotal > 0) And Not Terminated Then}
  Except
    On E: Exception Do
      _LogMSG('TDSRProducer.ProcessScheduleList :- Error processing Scheduled E-Mails. Error: '
        + E.Message);
  End; {If VarIsArray(lOut) Then}
End;

{ TDSRCheckMail }

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRCheckMail.Create;
Begin
  Inherited Create(True);
  FreeOnTerminate := True;
//  ThreadType := ttWrite;
  fSystemConf := TSystemConf.Create;
  Priority := tpLower;
End;

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRCheckMail.Destroy;
Begin
  If Assigned(fSystemConf) Then
    FreeAndNil(fSystemConf);
  If Assigned(fDB) Then
    FreeAndNil(fDb);

  ///Working := False;
  Checking := False;
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: DoWriting
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRCheckMail.Execute;
Begin
(*  If Assigned(fEmailLock) Then
  Begin*)

    {an external call might have happened}
  If Not Checking Then
  Begin
    Checking := True;
      (*fEmailLock.BeginWrite;*)

    Try
      fDB := TADODSR.Create(_DSRGetDBServer);
    Except
      On E: Exception Do
        _LogMSG('TDSRCheckMail.Execute :- Error connecting database. Error: ' +
          E.MEssage);
    End; {try}

    Try
  {get rid of emails older than one day and not processed}
      Try
    {get rid of mails older than one day}
        If (fDb <> Nil) And Not Terminated Then
        Begin
          If fDb.Connected Then
          Begin
            fDb.ProcessOldInboxMails;
            Sleep(1);
            fDb.ProcessOldOutboxMails;
          End
          Else If (fDb <> Nil) Then
            fDb.TestConnection;
        End;
      Except
        On e: exception Do
          _LogMSG('TDSRCheckMail.DoWriting :- Error processing old Inbox/Outbox e-mails. Error: '
            + e.Message);
      End;

      {if not cis is set...}
      If fDb.GetSystemValue(cISCISPARAM) = '0' Then
      Begin
        Try
        {check incoming mail system}
          If _FileSize(_GetApplicationPath + cDSRDOWNLOAD) > 0 Then
            _fileExec(_GetApplicationPath + cDSRDOWNLOAD + ' ' + cDSRDOWNLOADGUID,
              True, False)
          Else
            _LogMSG('TDSRCheckMail.DoWriting :- Download E-Mails application not found. Application name: '
              + cDSRDOWNLOAD);
        Except
          On e: Exception Do
            _LogMSG('TDSRCheckMail.DoWriting :- Error processing mail list. Error: '
              + e.message);
        End; {try}
      End; {If fDb.GetSystemValue(cISCISPARAM) = '0' Then}

      {load the cis incoming application}
      If fDb.GetSystemValue(cISCISPARAM) = '1' Then
      Begin
        If fDb.OutboxMessageStatusExists(0, cCISSENT) Then
          If _FileSize(_GetApplicationPath + cCISRECEIVER) > 0 Then
          Begin
            _fileExec(_GetApplicationPath + cCISRECEIVER + ' ' + cCISRECEIVERGUID,
              True, False)
          End
          Else
            _LogMSG('TDSRCheckMail.DoWriting :- CIS Receiver application not found. Application name: '
              + cCISRECEIVER);
      End; {If fDb.GetSystemValue(cISCISPARAM) = '1' Then}

        //DoPause;
    Except
        (*fEmailLock.EndWrite;*)
      On e: exception Do
        _LogMSG('TDSRCheckMail.DoWriting :- General processing e-mail error. Error: '
          + e.Message);
    End;

    Checking := False;
  End; {If Not Checking Then}
  (*End; {If Assigned(fEmailLock) Then}*)

  Terminate;
End;

{ TDSRBulkExport }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRBulkTh.Create(pMsgInfo: TMessageInfo; Const pBulkRequest:
  Boolean);
Begin
  Inherited Create;
  fMsgInfo := TMessageInfo.Create;
  fMsgInfo.Assign(pMsgInfo);
  fBulkRequest := pBulkRequest;
  ThreadType := ttWrite;
  Priority := tpLower;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRBulkTh.Destroy;
Begin
  If Assigned(fMsgInfo) Then
    FreeAndNil(fMsgInfo);
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: DoPause
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRBulkTh.DoPause;
Begin
  Sleep(cDEFAULTPAUSE);
End;

{-----------------------------------------------------------------------------
  Procedure: DoWriting
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRBulkTh.DoWriting;
Begin
  {Makesync send a ack packet asking to accept the new sync
  Make bulk get the system, static packets and send these off}

  If Assigned(fExpLock) Then
  Begin
    fExpLock.BeginWrite;

    Try
      Try
        If BulkRequest Then
          MakeSyncRequest
        Else
          MakeBulk;
      Except
      End;

      DoPause;
    Finally
      fExpLock.EndWrite;
    End;
  End; {If Assigned(fxpSync) Then}

  Terminate;
End;

{-----------------------------------------------------------------------------
  Procedure: MakeBulk
  Author:    vmoura

  make a sync request to the practice end user
-----------------------------------------------------------------------------}
Procedure TDSRBulkTh.MakeSyncRequest;
  Procedure _CreateSyncReq(pDSRHeader: TDSRFileHeader; pReq: TSyncRequest; Const
    pFile: String);
  Var
    lHeader: TDSRFileHeader;
    lFile: TMemoryStream;
  Begin
    lFile := TMemoryStream.Create;
    lFile.Write(pDSRHeader, SizeOf(TDSRFileHeader));
    lFile.Write(pReq, SizeOf(TSyncRequest));
    lFile.SaveToFile(pFile);
    FreeAndNil(lFile);

    Sleep(100);

    FillChar(lHeader, SizeOf(TDSRFileHeader), 0);
     {double check file header}
    _GetHeaderFromFile(lHeader, pFile);
    If (lHeader.Mode <> Ord(rmSync)) Or (lHeader.Flags <> ord(mtSyncRequest)) Then
    Begin
      _DelFile(pFile);
      {create the memory file that will be sent}
      lFile := TMemoryStream.Create;

      With pDSRHeader Do
      Begin
        Flags := Ord(mtSyncRequest);
        Mode := Ord(rmSync);
      End; {With pDSRHeader Do}

      lFile.Write(pDSRHeader, SizeOf(TDSRFileHeader));
      lFile.Write(pReq, SizeOf(TSyncRequest));
      lFile.SaveToFile(pFile);
      FreeAndNil(lFile);
    End; {if (lHeader.Mode <> Ord(rmSync)) or (lHeader.Flags <> ord(mtSyncRequest))then}
  End;

Var
  lDSRHeader: TDSRFileHeader;
  lCompSync: TSyncRequest;
  lSys: TSystemConf;
  lAux: String;
  lDb: TADODSR;
  lResult: Longword;
Begin
  lSys := TSystemConf.Create;

  lDb := Nil;

  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On e: Exception Do
      _LogMSG('TDSRBulkTh.MakeSyncRequest :- Error connecting db. Error: ' +
        e.message)
  End; {try}

  If lDb <> Nil Then
  Begin
    {add new entry to outbox}
    With fMsgInfo Do
      lDb.UpdateOutBox(Guid, Company_Id, Subject, From, To_, 0, 0, Param1,
        Param2, cPROCESSING, Mode,
        TDBOption(IfThen(lDb.SearchOutboxEntry(fMsgInfo.Guid) > 0,
        ord(dbDoUpdate), Ord(dbDoAdd))));

    {set company guid value in case it was deleted by an end of dripfeed...}
    lDb.SetCompanyGuid(fMsgInfo.Company_Id, _CreateGuid);

    FillChar(lDSRHeader, SizeOf(TDSRFileHeader), 0);
    {fill record header}
    With lDSRHeader Do
    Begin
      ProductType := Ord(_ExProductType);
      Version := CommonBit; // cDSRVERSION;
      BatchId := GUIDToString(fMsgInfo.Guid);
      ExCode := lDb.GetExCode(fMsgInfo.Company_Id);
      CompGuid := lDB.GetCompanyGuid(fMsgInfo.Company_Id);
      CheckSum := 0;
      SplitCheckSum := 0;
      Order := 1;
      Total := 1;
      Split := 0;
      SplitTotal := 0;
      Flags := Ord(mtSyncRequest);
      Mode := Ord(rmSync);
    End; {With lDSRHeader Do}

    FillChar(lCompSync, SizeOf(TSyncRequest), 0);
    {get eschequer company code and description}
    With lCompSync Do
    Begin
      ExCode := lDSRHeader.ExCode;
      Desc := lDb.GetCompanyDescription(fMsgInfo.Company_Id);
      Guid := lDSRHeader.CompGuid;
      MailFrom := fMsgInfo.From;
      MailTo := fMsgInfo.To_;
      Subject := fMsgInfo.Subject;
    End; {With lCompSync Do}

    {create the bulk request file}
    lAux := IncludeTrailingPathDelimiter(lSys.OutboxDir +
      GUIDToString(fMsgInfo.Guid)) + _CreateGuidStr + cACKEXT;
    ForceDirectories(ExtractFilePath(lAux));

    _CreateSyncReq(lDSRHeader, lCompSync, lAux);

    {send}
    Try
      With TDSRMail, fMsgInfo Do
        lResult := SendMsg(From, To_, cACKSUBJECT + ' ' + DateTimeToStr(Now), '', lAux);
    Finally
      Sleep(100);
//      _DelFile(lAux)
    End;

    {update database}
    If lResult <> S_Ok Then
    Begin
      With fMsgInfo Do
        lDb.UpdateOutBox(Guid, 0, '', '', '', 0, 1, '', '', cFAILED, Ord(rmSync),
          dbDoUpdate);
    End {If lResult <> S_Ok Then}
    Else
    Begin
      lDb.UpdateOutBox(fMsgInfo.Guid, 0, '', '', '', 0, 1, '', '', cSENT,
        Ord(rmSync), dbDoUpdate);

      With fMsgInfo Do
      Begin
        Try
          _SetDripFeedPeriod(lDb.GetCompanyPath(Company_Id),
            Byte(StrToInt(_GetPeriod(Param1))),
            Byte(StrToInt(_GetYear(Param1))),
            Byte(StrToInt(_GetPeriod(Param2))),
            Byte(StrToInt(_GetYear(Param2)))
            );
        Except
          On E: exception Do
            //_LogMSG('TDSRBulkTh.MakeSyncRequest :- Error setting Dripfeed params. Error: '
            _LogMSG('TDSRBulkTh.MakeSyncRequest :- Error setting Link params. Error: '
              + e.Message);
        End; {try}
      End; {With fMsgInfo Do}
    End; {begin}

    lDB.UpdateIceLog('TDSRBulkTh.MakeBulkRequest', _TranslateErrorCode(lResult));

    FreeAndNil(lDb);
  End; {If lDb <> Nil Then}

  lSys.Free;
End;

{-----------------------------------------------------------------------------
  Procedure: MakeBulk
  Author:    vmoura

  create a set of start up xmls (the bulk files) and send to practice end user
-----------------------------------------------------------------------------}
Procedure TDSRBulkTh.MakeBulk;
Const

  cBULKSYSTEMEXPORT = 'System Export';
  cBULKSTATICEXPORT = 'Static Export';
  cBULKTRANSACTIONEXPORT = 'Transaction Export';

Var
  lIni: TIniFile;
  lXmlList: TXMLList;
  lStr: TStringlist;
  lCont: Integer;
  lPack: TPackageInfo;
  lDb: TADODSR;
  lLog: _Base;
  lResult: Longword;
  lPath: String;
  lSys: TSystemConf;
Begin
  lResult := S_OK;
  lLog := _Base.Create;
  lSys := TSystemConf.Create;

  lDb := Nil;
  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On e: exception Do
    Begin
      _LogMSG('TDSRBulkTh.MakeBulk :- Error connecting database. Error: ' +
        e.message);
      lResult := cDBERROR;
    End;
  End; {try}

  If Assigned(lDb) And Not Terminated Then
  Try
    lLog.ConnectionString := lDb.ConnectionString;

      { write a new export bulk entry into the database if the mail info is
      just a memory information. Otherwise, just update}
    With fMsgInfo Do
      lDb.UpdateOutBox(Guid, Company_Id, Subject, From, To_, 0, 0,
        Param1, Param2, cLOADINGFILES {cBULKPROCESSING}, Mode,
        TDBOption(IfThen(lDb.SearchOutboxEntry(fMsgInfo.Guid) > 0,
        ord(dbDoUpdate), Ord(dbDoAdd))));

    lPath := lDb.GetCompanyPath(fMsgInfo.Company_Id);
    If Not _DirExists(lPath) Then
      lPath := _GetExCompanyPath(lDb.GetExCode(fMsgInfo.Company_Id));

    {check if there are transactions available to start a sync request}
    If _CheckTransaction(lPath) Then
    Begin
    {check the bulk ini files}
      If _FileSize(_GetApplicationPath + cBULKEXPORTINI) > 0 Then
        lIni := TIniFile.Create(_GetApplicationPath + cBULKEXPORTINI);

      If Assigned(lIni) Then
      Begin
        _CallDebugLog('making bulk... Entry found, Status processing...');

        lDb.SetOutboxTotalDone(fMsgInfo.Guid, 0);

      {check the sections}
        lStr := TStringlist.Create;
        lXmlList := TXMLList.Create(Nil);
        lini.ReadSection('BULK', lStr);
        If lStr.Count > 0 Then
        Begin
          For lCont := 0 To lStr.Count - 1 Do
          Begin
            Try
              lDb.SetOutboxTotalDone(fMsgInfo.Guid, Trunc(((lCont + 1) / lStr.Count)
                * 100));
            Except
            End;

            {load the right package to be used}
            lPack := lDb.GetExportPackage(fMsgInfo.Company_Id,
              lIni.ReadString('BULK', lStr[lCont], ''));

          {package found}
            If lPack <> Nil Then
            Begin
              {get the xmls from the plugin and add to the common list}
              lResult := TDSRExport.CallExportPlugin(lPack, fMsgInfo.Param1,
                fMsgInfo.Param2, lDb.GetCompanyPath(fMsgInfo.Company_Id),
                lXmlList);

              If (lowercase(Trim(lIni.ReadString('BULK', lStr[lCont], ''))) =
                Lowercase(cBULKTRANSACTIONEXPORT)) And (lResult =
                cNODATATOBEEXPORTED) Then
              Begin
                lResult := cEXCHNOTRANSACTIONSAVAILABLE;
                lXmlList.Clear;
                Break;
              End; {If (lowercase(lStr[Cont]) = 'transaction export') And
                lResult = cNODATATOBEEXPORTED Then}

              If (lResult <> S_OK) And (lResult <> cNODATATOBEEXPORTED) Then
              Begin
                lXmlList.Clear;
                Break;
              End {If (lResult <> S_OK) And (lResult <> cNODATATOBEEXPORTED) Then}
              Else
                lResult := S_OK;

              FreeAndNil(lPack);
            End {if lPack <> nil then}
            Else
            Begin
              lLog.DoLogMessage('TDSRBulkTh.MakeBulk', 0,
                'Could not find the plugin ' + lIni.ReadString('BULK',
                lStr[lCont], '') + ' Bulk operation aborted!', True, True);
              lXmlList.Clear;
              Break;
            End;

            {check thread still running}
            If Terminated Then
            Begin
              lDb.SetOutboxTotalDone(fMsgInfo.Guid, 0);
              lResult := S_FALSE;
              Break;
            End; {If Terminated Then}

            Sleep(1000);
          End; {for lCont:= 0 to lStr.Count - 1 do}

          lDb.SetOutboxTotalDone(fMsgInfo.Guid, 0);

          {after load the exported xml for all plugins, send them off}
          If (lXmlList.Count > 0) And (lResult = S_OK) Then
          Begin
            lResult := TDSRExport.PrepareFilesAndSend(fMsgInfo, lXmlList, rmBulk);

            With fMsgInfo Do
              lDb.UpdateOutBox(Guid, Company_Id, Subject, From, To_, 0,
                lXmlList.Count, Param1, Param2, ifThen(lResult = S_OK, cSENT,
                cFAILED), Mode, dbDoUpdate)
          End
          Else
            With fMsgInfo Do
              lDb.SetOutboxMessageStatus(Guid, ifthen((lResult = cNODATATOBEEXPORTED)
                Or (lResult = cEXCHNOTRANSACTIONSAVAILABLE), cNODATASENT, cFAILED));
        End {if lStr.Count > 0 then}
        Else
        Begin
          lResult := cFILEANDXMLERROR;

          With fMsgInfo Do
            lDb.SetOutboxMessageStatus(Guid, cFAILED);
        End;
      End {if Assigned(lIni) then }
      Else
      Begin
        lResult := cFILENOTFOUND;
        lLog.DoLogMessage('TDSRBulkTh.MakeBulk', lResult,
          'Bulk operation file not found!', True, True);

        With fMsgInfo Do
          lDb.SetOutboxMessageStatus(Guid, cFAILED);
      End;

      FreeAndNil(lIni);
    End
    Else
    Begin
      lResult := cEXCHNOTRANSACTIONSAVAILABLE;
      With fMsgInfo Do
        lDb.SetOutboxMessageStatus(Guid, cNODATASENT);
    End;
  Except
    On e: Exception Do
    Begin
      lResult := cERROR;
      lLog.DoLogMessage('TDSRBulkTh.MakeBulk', lResult,
        'An exception has occured. Error:  ' + e.message, True, True)
    End; {begin}
  End; {try}

  {update the total done}
  lDb.SetOutboxTotalDone(fMsgInfo.Guid, 0);

  If lResult = S_OK Then
  Begin
    lLog.DoLogMessage('TDSRBulkTh.MakeBulk', 0, 'Bulk operation completed. Company: '
      + lDb.GetCompanyDescription(fMsgInfo.Company_Id), True, True);

    If Not _CheckExDripFeed(lPath) Then
      _ApplyDripFeed(lPath);
  End
  Else
  Begin
    Try
      _DeleteDSRLockFile(lSys.OutboxDir + GUIDToString(fMsgInfo.Guid));
    Except
    End;

    _RemoveDripFeed(lPath);

    If Assigned(lDb) Then
      lLog.DoLogMessage('TDSRBulkTh.MakeBulk', lResult,
        'Bulk operation not completed. Company: ' +
        lDb.GetCompanyDescription(fMsgInfo.Company_Id), True, True)
    Else
      lLog.DoLogMessage('TDSRBulkTh.MakeBulk', lResult,
        'Bulk operation not completed. Company path: ' + lPath, True, True);
  End; {begin}

  If Assigned(lXmlList) Then
    FreeAndNil(lXmlList);

  If Assigned(lStr) Then
    FreeAndNil(lStr);

  If Assigned(lIni) Then
    FreeAndNil(lIni);

  If Assigned(lDb) Then
    FreeAndNil(lDb);

  If Assigned(lLog) Then
    FreeAndNil(lLog);

  If Assigned(lSys) Then
    FreeAndNil(lSys);
End;

{ TDSRExportTh }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRExportTh.Create(pMsgInfo: TMessageInfo);
Begin
  Inherited Create;
  fMsgInfo := TMessageInfo.Create;
  fMsgInfo.Assign(pMsgInfo);
  ThreadType := ttWrite;
  Priority := tpLower;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRExportTh.Destroy;
Begin
  If Assigned(fMsgInfo) Then
    FreeAndNil(fMsgInfo);
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: DoPause
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRExportTh.DoPause;
Begin
  Sleep(cDEFAULTPAUSE);
End;

{-----------------------------------------------------------------------------
  Procedure: DoWriting
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRExportTh.DoWriting;
Begin
  If Assigned(fExpLock) Then
  Begin
    fExpLock.BeginWrite;

    Try
      Try
        TDSRExport.CallExport(fMsgInfo);
      Except
      End;

      DoPause;
    Finally
      fExpLock.EndWrite;
    End;
  End; {If Assigned(fExpLock) Then}

  Terminate;
End;

{ TDSRRebuildCompany }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRReCreateCompany.Create;
Begin
  Inherited Create;
  Priority := tpLower;
  ThreadType := ttWrite;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRReCreateCompany.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: DoPause
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRReCreateCompany.DoPause;
Begin
  Sleep(cDEFAULTPAUSE);
End;

{-----------------------------------------------------------------------------
  Procedure: DoWriting
  Author:    vmoura

  get the inbox messages of the company and start the import again
-----------------------------------------------------------------------------}
Procedure TDSRReCreateCompany.DoWriting;
Var
  lDb: TADODSR;
  lMsgs {, lComps}: OleVariant; {olevariant result of the query}
  lRes: Longword; {result of the query}
  lNewCompCode, {the new company code }
    lCont,
    lTotal: Integer;
  lMsg: TMessageInfo;
  lPath,
    lFileName, {checking the file to be imported}
    lExCode: String;
  lDSRHeader: TDSRFileHeader;
  lSys: TSystemConf;
Begin
(*  If Assigned(fIMPLock) Then
  Begin*)
  lDb := Nil;
(*    fIMPLock.BeginWrite;*)

  _CallDebugLog('Recreate the company starting point');

  Try
    lSys := TSystemConf.Create;

    Try
        { if not the .ini file is set, the usual computer will be the server...}
      lDb := TADODSR.Create(_DSRGetDBServer);
    Except
      On E: Exception Do
        _LogMSG('TDSRReCreateCompany.DoWriting: Error connecting the database. Error: '
          + E.MEssage);
    End;

    If Assigned(lDb) And lDb.Connected Then
    Begin
      _CallDebugLog('About to recreate the company: ' + inttostr(Self.Company));

//      lRes := CreateExCompany(lDb.GetCompanyDescription(Self.Company),
//        lDb.GetExCode(Self.Company));

      lExCode := lDb.GetExCode(Self.Company);
      TDSRImport.CreateCompany(GUID_NULL, lDb.GetCompanyDescription(Self.Company),
        lDb.GetCompanyGuid(Self.company), lExCode, lRes);

      _CallDebugLog('The result was: ' + inttostr(lRes));

      If lRes = cEXCHCOMPALREADYEXISTS Then
        lRes := 0;

        {Create the new company}
      If lRes = S_Ok Then
      Begin
        lDb.UpdateIceLog('TDSRReCreateCompany.DoWriting',
          'Company successfully created. ' +
          ' Company: ' + lDb.GetCompanyDescription(Self.Company) +
          ' New Code: ' + lExCode);

        lDb.ClearCompanyGuid(Self.Company);
        lNewCompCode := ldb.GetCompanyId(lExCode);
        lMsgs := null;
        {get all inbox messages}
        lMsgs := lDb.GetInboxMessages(Self.Company, 0, -1, 0, 0, lRes, False);
        lTotal := _GetOlevariantArraySize(lMsgs);
        {check array size}
        If lTotal > 0 Then
        Begin
            {start from the first message}
          For lCont := lTotal - 1 Downto 0 Do
          Begin
            lMsg := _CreateInboxMsgInfo(lMsgs[lCont]);
            If lMsg <> Nil Then
            Begin
              {check if it is not a sync request}
              If (lMsg.TotalItens > 0) And (lMsg.Mode In [Ord(rmBulk),
                Ord(rmDripFeed)]) Then
              Begin
                {reimport this message to the company}
                With lMsg, TDSRImport Do
                Begin
                {the user might be deleting messages meanwhile}
                  If lDb.SearchInboxEntry(Guid) > 0 Then
                  Begin
                    {if there is files to be imported, it will start with 1.xml}
                    lFileName := IncludeTrailingPathDelimiter(lSys.InboxDir +
                      GUIDToString(lMsg.Guid)) + '1.xml';

                    FillChar(lDSRHeader, SizeOf(TDSRFileHeader), 0);
                    _GetHeaderFromFile(lDSRHeader, lFileName);

                    {look for read data files, not acks, nacks or syn requests}
                    If lDSRHeader.Flags = Ord(mtData) Then
                    Try
                      CallImport(lNewCompCode, Guid, 0, True);
                    Except
                    End;
                  End; {If lDb.SearchInboxEntry(Guid) > 0 Then}
                End; {With lMsg, TDSRImport Do}
              End; {If lMsg.Mode <> rmSync Then}

              FreeAndNil(lMsg);
            End;
            Sleep(2);
          End; {for lCont := 0 to lTotal - 1 do}
        End; {if lTotal > 0 then}

        lPath := lDb.GetCompanyPath(Self.Company);
        If Not _DirExists(lPath) Then
          lPath := _GetExCompanyPath(lDb.GetExCode(Self.Company));
        _RemoveDripFeed(lPath);

        ldb.SetCompanyStatus(Self.Company, False);

          {update the database}
        lPath := '';
        ldb.SetCompanyStatus(lNewCompCode, True);
        lPath := lDb.GetCompanyPath(lNewCompCode);
        If Not _DirExists(lPath) Then
          lPath := _GetExCompanyPath(lDb.GetExCode(lNewCompCode));
        _RemoveDripFeed(lPath);
      End {        If CreateCompany(lDb.GetCompanyDescription(Self.Company), lDb.GetExCode(Self.Company)) = S_Ok Then}
      Else
      Begin
        _LogMSG('TDSRReCreateCompany.DoWriting :- Error recreating company. Error: '
          + _TranslateErrorCode(lRes));

        lDb.UpdateIceLog('TDSRReCreateCompany.DoWriting',
          'An error has been reported while recreating company. Error: ' +
          _TranslateErrorCode(lRes) +
          ' Company: ' + lDb.GetCompanyDescription(Self.Company) +
          ' Code: ' + lDb.GetExCode(Self.Company));
      End;
    End; {if Assigned(lDb) then}

    DoPause;
  Finally
    If Assigned(lDb) Then
      FreeAndNil(lDb);
    If Assigned(lSys) Then
      FreeAndNil(lSys);
(*      fIMPLock.EndWrite;*)
  End;
(*  End; {If Assigned(fIMPLock) Then}*)

  Terminate;
End;

{ TDSRDripFeed }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRDripFeed.Create;
Begin
  Inherited Create;
  ThreadType := ttWrite;
  Priority := tpLower;
  fSystem := TSystemConf.Create;

  Try
    fDB := TADODSR.Create(_DSRGetDBServer);
  Except
    On E: Exception Do
      _LogMSG('TDSRProducer DB error: Error connecting the Database. Error: ' +
        E.MEssage);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRDripFeed.Destroy;
Begin
  If Assigned(fDB) Then
    FreeAndNil(fDB);

  If Assigned(fSystem) Then
    FreeAndNil(fSystem);
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: DoPause
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRDripFeed.DoPause;
Begin
  Sleep(cDSRDRIPFEEDINTERVAL);
End;

{-----------------------------------------------------------------------------
  Procedure: DoWriting
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRDripFeed.DoWriting;
Begin
  If Assigned(fExpLock) Then
  Begin
    fExpLock.BeginWrite;

    Try
      Try
        ProcessDripFeed;
      Except
      End;

      DoPause;
    Finally
      fExpLock.EndWrite;
    End;
  End; {If Assigned(fExpLock) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessDripFeed
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRDripFeed.ProcessDripFeed;
Var
  lComp: TCompany;
  lOut: Olevariant;
  lMail: TMessageInfo;
  lCont,
    lTotal: Integer;
  lPack: TPackageInfo;
  lXmlList: TXMLList;
  lRes: Longword;
  lPeriod1, lPeriod2,
    lDefaultReceiver: String;
Begin
  _CallDebugLog('Starting Dripfeed process');

  If Assigned(fDb) Then
  Try
    If Not fDb.Connected Then
    Try
      fDb.TestConnection;
    Except
    End;

    {test the connection}
    If fDb.Connected And Not Terminated Then
    Begin
      //If (fSystem.CompanyName <> '') {And (fSystem.CompanyMail <> '')} Then
      if fDb.GetSystemValue(cCOMPANYNAMEPARAM) <> '' then
      Begin
      {load companies}
        lOut := fDb.GetCompanies;
        lTotal := _GetOlevariantArraySize(lOut);
        If lTotal > 0 Then
          For lCont := 0 To lTotal - 1 Do
          Begin
            lComp := _CreateCompanyObj(lOut[lCont]);
            If lComp <> Nil Then
            Begin
            {check if still working}
              If lComp.Active And Not Terminated Then
              Begin
              {check the Dripfeed mode and if some user has requested the end of Dripfeed}
                If _CheckExDripFeed(lComp.Directory) And
                  Not fDb.IsEndOfSyncRequested(lComp.Id) And Not Terminated Then
                Begin
                  {check for a default sender e-mail}
                  lDefaultReceiver := fDb.GetDefaultReceiver(lComp.Id);

                  If (Trim(lDefaultReceiver) <> '') And Not Terminated Then
                  Begin
                  {get the Dripfeed package info}
                    lPack := fDb.GetExportPackage(lComp.Id, cDRIPFEED);

                    {chek if it is a valid Dripfeed package}
                    If (lPack <> Nil) And Not Terminated Then
                    Begin
                      lXmlList := TXMLList.Create(Nil);
                      lRes := S_FALSE;

                      _GetDripFeedPeriod(lComp.Directory, lPeriod1, lPeriod2);

                    {check for new updates}
                      Try
                        lRes := TDSRExport.CallExportPlugin(lPack, lPeriod1,
                          lPeriod2, fdb.GetCompanyPath(lComp.Id), lXmlList);
                      Except
                      End; {try}

                      {check number of files returned}
                      If (lXmlList.Count > 0) And (lRes = S_OK) And Not
                        Terminated Then
                      Begin
                        {fill mail properties that will be used by preparefilesandsend}
                        lMail := TMessageInfo.Create;
                        With lMail Do
                        Begin
                          Guid := _CreateGuid;
                          Company_Id := lComp.Id;
                          Param1 := lPeriod1;
                          Param2 := lPeriod2;
                          Mode := Ord(rmDripFeed);
                          from := fDb.GetDefaultEmailAccount;
                          To_ := lDefaultReceiver;
                          TotalItens := lXmlList.Count;
                          Subject := 'Automatic Sync from ' +
                            //fSystem.CompanyName + ' [' + lComp.Desc + '] at: ' +
                            fDb.GetSystemValue(cCOMPANYNAMEPARAM) + ' [' + lComp.Desc + '] at: ' +
                            DateTimeToStr(Now);
                        End; {with lMail do}

                        {add a new entry}
                        With lMail Do
                          fDb.UpdateOutBox(Guid, Company_Id, Subject, From,
                            To_, 0, TotalItens, Param1, Param2, cPROCESSING,
                            Mode, dbDoAdd);

                        lRes := S_FALSE;
                        Try
                          lRes := TDSRExport.PrepareFilesAndSend(lMail,
                            lXmlList, rmDripFeed);
                        Except
                        End;

                      {if in Dripfeed and the e-mail was sent off, update the send date because next time the dsr
                      is going to export date from this date until the current date}
                        If lRes = S_OK Then
                          fDb.UpdateOutBox(lMail.Guid, 0, '', '', '', 0,
                            lXmlList.Count, '', '', cSENT, Ord(rmDripFeed),
                            dbDoUpdate)
                        Else
                          fDb.UpdateOutBox(lMail.Guid, 0, '', '', '', 0,
                            lXmlList.Count, '', '', cFAILED, Ord(rmDripFeed),
                            dbDoUpdate);

                        If Assigned(lMail) Then
                          FreeAndNil(lMail);
                      End; {If (lXmlList.Count > 0) And (lRes = S_OK) Then}

                      If Assigned(lXmlList) Then
                        FreeAndNil(lXmlList);
                    End; {If lPack <> Nil Then}

                    If Assigned(lPack) Then
                      FreeAndNil(lPack);
                  End; {If (lMail <> Nil) And Not Terminated Then}
                End; {If _CheckExDripFeed(lComp.Directory) Then}
              End; {if lComp.Active then}
            End; {If lComp <> Nil Then}

            If Assigned(lComp) Then
              FreeAndNil(lComp);

            Sleep(cDEFAULTPAUSE);

            If Terminated Then
              break;
          End; {for lCont := 0 To lTotal - 1 do}
      End {if (fSystem.CompanyName <> '') and (fSystem.CompanyMail <> '') then}
      Else
        _LogMSG('TDSRDripFeed.ProcessDripFeed :- Invalid Company settings. Company name: ' +
          //+ fSystem.CompanyName);
          fDb.GetSystemValue(cCOMPANYNAMEPARAM));
    End; {if fDb.Connected then}
  Except
    On e: exception Do
    Begin
      //_LogMSG('TDSRDripFeed.ProcessDripFeed :- An error has been reported while processing Dripfeed data. Error: '
      _LogMSG('TDSRDripFeed.ProcessDripFeed :- An error has been reported while processing Linked data. Error: '
        + e.Message);

      fDb.UpdateIceLog('TDSRDripFeed.ProcessDripFeed',
        //'An error has been reported while processing Dripfeed data. Error: ' +
        'An error has been reported while processing Linked data. Error: ' +
        e.Message);
    End;
  End; {if Assigned(fDb) then}

  _CallDebugLog('end of Dripfeed');
End;

{ TDSRRemoveDripFeed }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRRemoveDripFeed.Create;
Begin
  Inherited Create;
  ThreadType := ttWrite;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRRemoveDripFeed.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: DoPause
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRRemoveDripFeed.DoPause;
Begin
  Sleep(cDEFAULTPAUSE);
End;

{-----------------------------------------------------------------------------
  Procedure: DoWriting
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRRemoveDripFeed.DoWriting;
Var
  lDb: TADODSR;
  lGuid: TGuid;
  lCont: Integer;
  lPath: String;
Begin
  lDb := Nil;
  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On E: Exception Do
      _LogMSG('TDSRRemoveDripFeed.DoWriting :- Error connecting the Database. Error: '
        + E.Message);
  End;

  If Assigned(lDb) Then
  Begin
    _CallDebugLog('Setting last audit date');
    lPath := fCompanyPath;

    {double check company path}
    If Not _DirExists(lPath) Then
      lPath := lDb.GetCompanyPath(fCompany);

    {only remove dripfeed and setlastaudit date for company that has changed their status to dripfeed}
    If _CheckExDripFeed(lPath) Then
    Begin
      lCont := 0;
      Repeat
        _RemoveDripFeed(lPath);
        Sleep(50);
        Inc(lCont);
      Until Not _CheckExDripFeed(lPath) Or (lCont > 5);

      {apply last sync period date to last audited date for that specific company}
      _SetLastAuditDate(lPath, _GetLastSyncPeriodDate(lPath));
    End;

    lGuid := _CreateGuid;

    {check parameters for sending naknowlodge back to customer}
    If (fFrom <> '') And (fTo_ <> '') And (fSubject <> '') Then
    Begin
      {send acknowledge according to the type of message}
      With TDSRMail, lDb Do
      Begin
        SendNACK(lGuid, fFrom, fTo_, 1, ifThen(fCancel, cNACKCANCELSYNC,
          cNACKREMOVESYNC), GetExCode(fCompany), GetCompanyGuid(fCompany),
          fSubject);

      {create a new db entry as a record for this operation}
        UpdateOutBox(lGuid, fCompany, fSubject, fFrom, fTo_, 0, 1, '',
          '', cSENT, Ord(rmNormal), dbDoAdd);
      End; {With TDSRMail, lDb Do}
    End; {If (pFrom <> '') And (pTo <> '') And (pSubject <> '') Then}

    {set inbox as archived}
    lDb.SetAllInboxMessagesStatus(fCompany, cARCHIVED);
    {remove schedule syncs}
    lDb.RemoveAllOutboxSchedule(fCompany);
    {set outbox as archive}
    lDb.SetAllOutboxMessagesStatus(fCompany, cARCHIVED);
    _CallDebugLog('getting version');
    {remove the guid from the company previuos created if this is a practice version}
    lDb.SetCompanyGuid(fCompany, GUID_NULL);

    lDb.Free;
  End
  Else
    _LogMSG('TDSRRemoveDripFeed.DoWriting :- Database Object is not valid...');

  Terminate;
End;

{ TDSRRestoreMessage }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRRestoreMessage.Create;
Begin
  Inherited Create(True);
  FreeOnTerminate := True;
  Priority := tpLower;
  fMsg := TMessageInfo.Create;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRRestoreMessage.Destroy;
Begin
  If Assigned(fMsg) Then
    FreeAndNil(fMsg);
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRRestoreMessage.Execute;
Var
  lDb: TADODSR; {db connection}
  lText, {text to be written}
    lCompPath, {company path}
    lDir,
    lFilename: String; {first file to load and check}
  lSys: TSystemConf; {system configuration file}
  lrec: TSearchRec; {search rec file}
  lFiles: TStringList;
  lOldStatus,
    lCount: Integer;
  lIsInbox, lEoD: Boolean;
Begin
  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On e: Exception Do
      _LogMSG('TDSRRestoreMessage.Execute :- Error connecting database. Error: ' +
        e.message)
  End; {try}

  {check db connection}
  If (lDb <> Nil) And lDb.Connected Then
  Begin
      {check if this particular message meets the requirements to change its status to ready to import }
    If (fMsg.Status = cDELETED) And (fMsg.Mode In [ord(rmDripfeed), ord(rmBulk)])
    And (fMsg.TotalItens > 0) And ((lDb.SearchInboxEntry(fMsg.Guid) > 0) Or
      (lDb.SearchOutboxEntry(fMsg.Guid) > 0)) And (fMsg.Company_Id > 0) And
      lDb.IsCompanyActive(fMsg.Company_Id) Then
    Begin
      Try
        lCompPath := lDb.GetCompanyPath(fMsg.Company_Id);
        If Not _DirExists(lCompPath) Then
          lCompPath := _GetExCompanyPath(lDb.GetExCode(fMsg.Company_Id));

      {check if this company exists into MCM}
        If _DirExists(lCompPath) Then
        Begin
        {create the system parameter to load the outbox dir}
          lSys := TSystemConf.Create;
          lFiles := TStringList.Create;
          lCount := 0;

          lIsInbox := lDb.SearchInboxEntry(fMsg.Guid) > 0;

          {get the right directory}
          If lIsInbox Then
          Begin
            lDir := IncludeTrailingPathDelimiter(lSys.InboxDir +
              GUIDToString(fMsg.Guid));
            {load the old status in case of failure}
            lOldStatus := lDb.GetInboxMessageStatus(fMsg.Guid);
            lDb.SetInboxMessageStatus(fMsg.Guid, cLOADINGFILES);
          End
          Else
          Begin
            lDir := IncludeTrailingPathDelimiter(lSys.OutboxDir +
              GUIDToString(fMsg.Guid));
            lOldStatus := lDb.GetOutboxMessageStatus(fMsg.Guid);
            lDb.SetOutboxMessageStatus(fMsg.Guid, cLOADINGFILES);
          End; {else begin}

          {load files from specific directory}
          If FindFirst(lDir + '*.*', faAnyFile, lRec) = 0 Then
            Repeat
             // Exclude directories from the list of files.
              Sleep(1);
              If ((lRec.Attr And faDirectory) <> faDirectory) Then
              Begin
                lFilename := lDir + lRec.Name;
                If (lRec.Name <> cDSRLOCKFILE) And (_FileSize(lFilename) > 0) Then
                Begin
                  lFiles.Add(lFilename);
                  Inc(lCount);

                  lEoD := lDb.IsEndOfSyncRequested(fMsg.Company_Id);

                  {end of sync has been requested}
                  If lEoD Then
                    Break;

                  Try
                    If lIsInbox Then
                      lDb.SetInboxTotalDone(fMsg.Guid, Trunc((lCount /
                        fMsg.TotalItens) * 100))
                    Else
                      lDb.SetOutboxTotalDone(fMsg.Guid, Trunc((lCount /
                        fMsg.TotalItens) * 100));
                  Except
                  End;
                End; {If (lRec.Name <> cDSRLOCKFILE) And (_FileSize(lFilename) > 0) Then}
              End; {If ((lRec.Attr And faDirectory) <> faDirectory) Then}
            Until FindNext(lRec) <> 0;

          {reset status and %}
          If lIsInbox Then
          Begin
            lDb.SetInboxMessageStatus(fMsg.Guid, cCHECKING);
            lDb.SetInboxTotalDone(fMsg.Guid, 30)
          End
          Else
          Begin
            lDb.SetOutboxMessageStatus(fMsg.Guid, cCHECKING);
            lDb.SetOutboxTotalDone(fMsg.Guid, 30);
          End; {else begin}

          {verify batch integraty}
          If Not lEoD And _CheckBatchCompleteEx(lFiles) Then
          Begin
            {set final status}
            If lIsInbox Then
            Begin
              lDb.SetInboxMessageStatus(fMsg.Guid, cREADYIMPORT);
              lDb.SetInboxTotalDone(fMsg.Guid, 100);
            End
            Else
            Begin
              lDb.SetOutboxMessageStatus(fMsg.Guid, cRESTORED);
              lDb.SetOutboxTotalDone(fMsg.Guid, 100);
            End; {else begin}

            lText := 'The message subject "' + fMsg.Subject +
              '" has been restored.';
          End {if _CheckBatchCompleteEx(lHeader, ExtractFilePath(lFilename)) then}
          Else
          Begin
            {return the old status to the message}
            If lIsInbox Then
            Begin
              lDb.SetInboxMessageStatus(fMsg.Guid, lOldStatus);
              lDb.SetInboxTotalDone(fMsg.Guid, 100);
            End
            Else
            Begin
              lDb.SetOutboxMessageStatus(fMsg.Guid, lOldStatus);
              lDb.SetOutboxTotalDone(fMsg.Guid, 100);
            End; {else begin}

            If lEoD Then
              lText := 'The message subject "' + fMsg.Subject +
                //'" could not be restored [Error: End of Dripfeed requested].'
                '" could not be restored [Error: End of Link requested].'
            Else
              lText := 'The message subject "' + fMsg.Subject +
                '" could not be restored [Error: Batch not completed].';
          End; {else begin}

          lSys.Free;
          lFiles.Free;
        End
        Else
          lText := 'The message subject "' + fMsg.Subject +
            '" could not be restored [Error: Invalid Company].';
      Except
        On E: Exception Do
        Begin
          lText := 'The message subject "' + fMsg.Subject +
            '" could not be restored. Error: ' + e.Message;

          If Assigned(lSys) Then
            lSys.Free;
          If Assigned(lFiles) Then
            lFiles.Free;
        End; {On E: Exception Do}
      End; {try}
    End
    Else
      lText := 'The message subject "' + fMsg.Subject +
        '" could not be restored [Error: Invalid Message].';

    lDb.UpdateIceLog('TDSRRestoreMessage.Execute', lText);
    _LogMSG('TDSRRestoreMessage.Execute :- ' + lText);

    FreeAndNil(lDb);
  End; {If lDb <> Nil Then}

  Terminate;
End;

{ TDSRResendMessage }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRResendMessage.Create;
Begin
  Inherited Create(True);
  FreeOnTerminate := True;
  Priority := tpLowest;
  fMsg := TMessageInfo.Create;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRResendMessage.Destroy;
Begin
  If Assigned(fMsg) Then
    FreeAndNil(fMsg);

  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRResendMessage.Execute;
Var
  lrec: TSearchRec;
  lDir, lFile, lCompPath: String;
  lFilesToSend: TStringList;
  lSys: TSystemConf;
  lDb: TADODSR;
  lRes: Longword;
  lDSRHeader: TDSRFileHeader;
  lLog: _Base;
  lCount: Integer; {total number of files and current files added in}
Begin
  Sleep(100);

  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On e: Exception Do
      _LogMSG('TDSRResendMessage.Execute :- Error connecting database. Error: ' +
        e.message)
  End; {try}

  {check db connection}
  If (lDb <> Nil) And lDb.Connected Then
  Begin
    lLog := _Base.Create;
    lLog.ConnectionString := lDb.ConnectionString;
    lDb.SetOutboxMessageStatus(fMsg.Guid, cLOADINGFILES);
    lDb.SetOutboxTotalDone(fMsg.Guid, 0);

    Try
      lRes := cNOFILESTOBESENT;

      If fMsg.TotalItens > 0 Then
      Begin
      {check if this company is active and exists into mcm}
        If lDb.IsCompanyActive(fMsg.Company_Id) Then
        Begin
          lCompPath := lDb.GetCompanyPath(fMsg.Company_Id);
          If Not _DirExists(lCompPath) Then
            lCompPath := _GetExCompanyPath(lDb.GetExCode(fMsg.Company_Id));

      {check ex company directory}
          If _DirExists(lCompPath) Then
          Begin
            lSys := TSystemConf.Create;
            lFilesToSend := TStringList.Create;
            fillChar(lDSRHeader, SizeOf(TDSRFileHeader), 0);

            Try
              lDir := IncludeTrailingPathDelimiter(lSys.OutboxDir +
                GUIDToString(fMsg.Guid));
              lCount := 0;

      {load files from specific directory}
              If FindFirst(lDir + '*.*', faAnyFile, lRec) = 0 Then
                Repeat
        // Exclude directories from the list of files.
                  Sleep(1);
                  If ((lRec.Attr And faDirectory) <> faDirectory) Then
                  Begin
                    lFile := lDir + lRec.Name;
                    If (lRec.Name <> cDSRLOCKFILE) And (_FileSize(lFile) > 0) Then
                    Begin
                      lFilesToSend.Add(lFile);
                      Inc(lCount);

                      Try
                        lDb.SetOutboxTotalDone(fMsg.Guid, Trunc((lCount /
                          fMsg.TotalItens) * 100));
                      Except
                      End;
                    End; {If (lRec.Name <> cDSRLOCKFILE) And (_FileSize(lFile) > 0) Then}
                  End; {If ((lRec.Attr And faDirectory) <> faDirectory) Then}
                Until FindNext(lRec) <> 0;

              lDb.SetOutboxTotalDone(fMsg.Guid, 100);

              {check number of files and load the firt one }
              If lFilesToSend.Count > 0 Then
              Begin
                If _CheckBatchCompleteEx(lFilestoSend) Then
                 {call send files from dsrexport object only...}
                  With TDSRExport, fMsg Do
                    lRes := SendFiles(Guid, From, To_, Subject, lFilesToSend)
              End; {If lFilesToSend.Count > 0 Then}
            Finally
              FindClose(lRec);
              lSys.Free;
              lFilesToSend.Free;
            End;

            lDb.SetOutboxTotalDone(fMsg.Guid, 100);

          End {If _DirExists(lCompPath) Then}
          Else
            lLog.DoLogMessage('TDSRResendMessage.Execute', cEXCHINVALIDPATH,
              'Company path does not exist. Company: ' +
              lDb.GetCompanyDescription(fMsg.Company_Id) + '. Code: ' +
              lDb.GetExCode(fMsg.Company_Id), True, True);
        End
        Else
          lLog.DoLogMessage('TDSRResendMessage.Execute', cERROR,
            'Company is not active. Company: ' +
            lDb.GetCompanyDescription(fMsg.Company_Id) + '. Code: ' +
            lDb.GetExCode(fMsg.Company_Id), True, True);
      End
      Else
        lLog.DoLogMessage('TDSRResendMessage.Execute', cERROR,
          'Invalid number of files to be sent. Company: ' +
          lDb.GetCompanyDescription(fMsg.Company_Id) + '. Code: ' +
          lDb.GetExCode(fMsg.Company_Id) +
          '. Message Id: ' + _SafeGuidtoString(fMsg.Guid), True, True);
    Finally
      If lRes = S_OK Then
        lDb.SetOutboxMessageStatus(fMsg.Guid, cSENT)
      Else
        lDb.SetOutboxMessageStatus(fMsg.Guid, cFAILED);

      lLog.Free;
      lDb.Free;
    End; {try..finally}
  End
  Else
    _LogMSG('TDSRResendMessage.Execute :- Error connecting database.');

  Terminate;
End;

End.

