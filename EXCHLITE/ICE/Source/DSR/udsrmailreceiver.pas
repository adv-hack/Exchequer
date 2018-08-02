{-----------------------------------------------------------------------------
 Unit Name: uDSRMailPoll
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDSRMailReceiver;

Interface

Uses Classes, Windows,
  uBaseClass, uSystemConfig,

  {email system files}
  uPOP3, uMailMessage, uSMTP, uMailMessageAttach, uIMAP, uMAPI, uMailBase
  ;

Type
  {i only need the properties to connect with pop3 and imap}
  TDSRMailPoll = Class(TEmailBase)
  Private
    fLog: _Base;
    fWorking: boolean;
    fSystem: TSystemConf;

    fACKSent,
      fFile,
      fOrderRequest: TStringlist;

    Procedure DeleteSentBox(Const pFrom, pTo, pSubject, pBody: String; Var
      pCanDelete: Boolean);

    Procedure ProcessEMail(pEmail: TMailMessage; pMailer: TEmailBase);

    Procedure DeleteAttach(pList: TStringList; Const pAvoidFile: String = '');
    Function ProcessFile(Const pFile: String): Boolean;
    Procedure ProcessFiles;
    Function IsValidDSRMail(Var pMsgBody: String): Boolean;
    Function GetFirstAttach(pList: TStringList): String;
    Procedure ProcessUnreceivedMessages;
  Protected
    Procedure ClearMAPISentBox;
    Procedure DoError(Sender: TObject; Const pWhere, pError: String);
    Procedure CheckForEmails; Virtual;
    Procedure DownloadMAPIEmails; Virtual;
    Procedure DownloadPOP3Emails; Virtual;
    procedure DownloadIMAPEmails; virtual;
  Public
    Constructor Create; override;
    Destructor Destroy; Override;
  Published
    Property Working: boolean Read fWorking Write fWorking;

    Property Host;
    Property IncomingPort;
    Property UserName;
    Property Password;
    Property MailBox;
    property MailBoxSeparator;
  End;

  TCheckMAPI = class(TDSRMailPoll)
  Public
    Procedure CheckForEmails; override;
  end;

  TCheckPOP3 = class(TDSRMailPoll)
  Public
    Procedure CheckForEmails; override;
  end;

  TCheckIMAP = class(TDSRMailPoll)
  Public
    Procedure CheckForEmails; override;
  end;

Implementation

Uses
  DateUtils, StrUtils, Math, SysUtils, variants,

  uDsrMail, uDSRFileFunc, uDSRReceive, uExFunc, uDSRHistory,
  uInterfaces, uCommon, uConsts, uAdoDSR, uDsrSettings
  ;

{ TDSRMailPoll }

{-----------------------------------------------------------------------------
  Procedure: DeleteSentBox
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.DeleteSentBox(Const pFrom, pTo, pSubject, pBody: String; Var
  pCanDelete: Boolean);
Var
  lAux: String;
Begin
  lAux := Trim(pBody);
  pCanDelete := IsValidDSRMail(lAux);
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteAttach
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.DeleteAttach(pList: TStringList; Const pAvoidFile: String
  = '');
Var
  lCont: Integer;
Begin
  If Assigned(pList) Then
    For lCont := 0 To pList.Count - 1 Do
      If Lowercase(Trim(pAvoidFile)) <> Lowercase(Trim(pList[lCont])) Then
        _DelFile(Trim(pList[lCont]))
End;

{-----------------------------------------------------------------------------
  Procedure: CheckForEmails
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.CheckForEmails;
Begin
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessUnreceivedMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.ProcessUnreceivedMessages;
Var
  lDb: TADODSR; {db connection}
  lOut: Olevariant;
  lTotal, lCont, lCont2: Integer;
  lMsg: TMessageInfo;
  lPath, lFileName, lAux: String;
  lRes: Longword;
  lListProcess: TStringList;
Begin
  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
  End;

  lListProcess := TStringList.Create;

  If Assigned(lDb) And lDb.Connected Then
  Begin
    lOut := null;
    Try
      lOut := lDb.GetInboxMessages(-1, 0, cRECEIVINGDATA, 0, 10, lRes, False);
    Except
    End;

    {process one by one to avoid creating thousand of unnecessary e-mails}
    lTotal := _GetOlevariantArraySize(lOut);
    If lTotal > 0 Then
    Begin
      For lCont := 0 To lTotal - 1 Do
      Begin
        lMsg := Nil;
        Try
          lMsg := _CreateInboxMsgInfo(lOut[lCont]);
        Except
        End;

        If lMsg <> Nil Then
        Begin
        {check the number of files and if this message is a bulk or dripfeed message}
          If (lMsg.TotalItens > 0) And (lMsg.Mode In [Ord(rmBulk), ord(rmDripFeed)])
          Then
          {checking how old is this message }
            If (MinutesBetween(Now, lMsg.Date) > 5) And (HoursBetween(Now, lMsg.Date)
              < 24) Then
            Begin
              lPath := fSystem.InboxDir + _SafeGuidtoString(lMsg.Guid);
            {check directory}
              If _DirExists(lPath) Then
              Begin
                lFileName := '';
              {load the first valid file for processing}
                For lCont2 := 1 To lMsg.TotalItens Do
                Begin
                  lFileName := IncludeTrailingPathDelimiter(lPath) + inttostr(lCont2)
                    + cXMLEXT;
                  If _FileSize(lFilename) > 0 Then
                  Begin
                    If _GetXmlFromFile(lFileName) <> '' Then
                    Begin
                      lAux := ExtractFilePath(lFileName) + _CreateGuidStr;
                      CopyFile(pChar(lFileName), pChar(lAux), False);
                      lListProcess.Add(lAux);
                      Break;
                    End
                    Else
                      lFileName := '';
                  End {if _FileSize(lFilename + inttostr(lCont) + cXMLEXT) then}
                  Else
                    lFileName := '';
                End; {for lCont:= 1 to lMsg.TotalItens do}
              End; {if _DirExists(fSystem.InboxDir + _SafeGuidtoString(lMsg.Guid)) then}
            End; {if MinutesBetween(Now, lMsg.Date) > 5 then}

          lMsg.Free;
        End; {if lMsg <> nil then}
      End; {for lCont := 0 to lTotal - 1 do}
    End; {if lTotal > 0 then}
  End; {if Assigned(lDb) and lDb.Connected then}

  If lListProcess.Count > 0 Then
    For lCont := 0 To lListProcess.Count - 1 Do
      If (lListProcess[lCont] <> '') And (_FileSize(lListProcess[lCont]) > 0) Then
        ProcessFile(lListProcess[lCont]);

  If Assigned(lDb) Then
    FreeAndNil(lDb);

  lListProcess.Free;
End;

{-----------------------------------------------------------------------------
  Procedure: ClearSentBox
  Author:    vmoura

  mapi stores its sent messages into sent box in outlook. this function basicallly load the
  messages and delete then...
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.ClearMAPISentBox;
Var
  lDb: TADODSR; {db connection}
  lCont: Integer;
  lAux: String;
  lDate: TDatetime;
  lMAPI: TMAPI;
Begin
  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
  End;

  If Assigned(lDb) Then
    If lDb.Connected Then
    Begin
      lAux := lDb.GetSystemValue(cCLEARSENTBOXPARAM);
      If lAux <> '' Then
      Begin
        lDate := StrToDateTimeDef(lAux, Now);

      {check last time this process has been checked}
        If MinutesBetween(Now, lDate) > 30 Then
        Begin
          lMAPI := Nil;
          Try
            lMAPI := TMAPI.Create;
          Except
            On e: exception Do
              _LogMsg('TDSRMailPoll.ClearSentBox :- The following exception occurred whilst creating MAPI components: '
                + E.Message)
          End;

          If lMapi <> Nil Then
          Begin
            lMapi.OnDeleteSentBox := DeleteSentBox;
            lMapi.OnError := DoError;

            Try
              lMapi.INBOXLoadAttach := False;
              lMapi.SENTBOXLoadAttach := True;

              Try
                lMapi.Connected := True;
              Except
                On e: exception Do
                  _LogMSG('TDSRMailPoll.ClearSentBox :- Error activating MAPI (1). Error: '
                    + e.Message);
              End;

              If lMapi.Connected Then
              Begin
                lMapi.ClearSentBox(DateToStr(Now));
                lDb.SetSystemParameter(cCLEARSENTBOXPARAM, DateTimeToStr(Now));
              End; {if lMapi.Active then}
            Finally
              lMapi.Free;
            End; {try}
          End; {If lMapi <> Nil Then}
        End; {if MinutesBetween(Now, lDate) > 59 then}
      End
      Else
        lDb.SetSystemParameter(cCLEARSENTBOXPARAM, DateTimeToStr(Now));
    End; {if Assigned(lDb) and lDb.Connected then}

  If Assigned(lDb) Then
    FreeAndNil(lDb);
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRMailPoll.Create;
Begin
  Inherited Create;
  fLog := _Base.Create;
  fLog.ConnectionString := _DSRFormatConnectionString(_DSRGetDBServer);
  fFile := TStringList.Create;
  fACKSent := TStringList.Create;
  fOrderRequest := TStringList.Create;
  fSystem := TSystemConf.Create;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRMailPoll.Destroy;
Begin
  fWorking := False;

  If Assigned(fSystem) Then
    FreeAndNil(fSystem);

  If Assigned(fLog) Then
    FreeAndNil(fLog);

  If Assigned(fFile) Then
    FreeAndNil(fFile);

  If Assigned(fACKSent) Then
    FreeAndNil(fACKSent);

  If Assigned(fOrderRequest) Then
    FreeAndNil(fOrderRequest);

  Inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: DownloadMAPIEmails
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.DownloadMAPIEmails;
Var
  lCont: Integer;
  lMapi: TMAPI;
  lMessage: TMailMessage;
Begin
  lMapi := Nil;

  Try
    lMapi := TMAPI.Create;
  Except
    On e: exception Do
      _LogMsg('TDSRMailPoll.DownloadMAPIEmails :- The following exception occurred whilst creating MAPI components: '
        + E.Message)
  End;

  {check mapi object}
  If lMapi <> Nil Then
  Begin
    Try
      lMapi.OnError := DoError;
      lMapi.AttachDirectory := IncludeTrailingPathDelimiter(_GetApplicationPath +
        cTEMPDIR);

      lMapi.INBOXLoadAttach := True;
      lMapi.SENTBOXLoadAttach := False;

      {activate}
      Try
        lMapi.Connected := True;
      Except
        On e: exception Do
          DoError(Self, 'TDSRMailPoll.DownloadMAPIEmails',
            'Error activating MAPI. Error: ' + e.Message);
      End;

      {check mapi connection}
      If lMapi.Connected Then
      Begin
        {retrieve the total ammount of files...}
        If lMapi.MessageCount > 0 Then
        Begin
          {loop through the messages from the newest to oldest...}
          For lCont := lMapi.MessageCount - 1 Downto 0 Do
          Begin
            lMessage := lMapi[lCont];
            If lMessage <> Nil Then
            Begin
              ProcessEMail(lMessage, lMapi);
              FreeAndNil(lMessage);
            End {if lMessage <> nil then}
            Else
              DoError(Self, 'TDSRMailPoll.DownloadMAPIEmails',
                'The application could not retrieve the E-Mail (MAPI) ...');
          End; {For lCont := lTotal - 1 Downto 0 Do}

          lMapi.DeleteInboxMarkedMsgs;
        End; {if lMapi.INBOX.MessagesCount > 0 then}
      End {if lMapi.Active then}
      Else
        DoError(Self, 'TDSRMailPoll.DownloadMAPIEmails',
          'The application could not connect to a MAPI session...');
    except
      on E:exception do
        DoError(Self, 'TDSRMailPoll.DownloadMAPIEmails',
          'Error download MAPI email. Error: ' + e.Message);
    End; {try}

    if Assigned(lMapi) then
      lMapi.Free;
  End; {If lMapi <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: DownloadPOP3Emails
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.DownloadPOP3Emails;
Var
  lCont: Integer;
  lPOP3: TPOP3;
  lMessage: TMailMessage;
Begin
  lPOP3 := Nil;

  Try
    lPOP3 := TPOP3.Create;
  Except
    On e: exception Do
      DoError(Self, 'TDSRMailPoll.DownloadPOP3Emails',
        'The following exception occurred whilst creating POP3 components: ' +
        E.Message)
  End;

  {check mapi object}
  If lPOP3 <> Nil Then
  Begin
    Try
      lPOP3.Host := Host;
      lPOP3.IncomingPort := IncomingPort;
      lPOP3.UserName := UserName;
      lPOP3.Password := Password;
      lPOP3.UseAuthentication := UseAuthentication;

      lPOP3.OnError := DoError;
      lPOP3.AttachDirectory := IncludeTrailingPathDelimiter(_GetApplicationPath +
        cTEMPDIR);

      {activate}
      Try
        lPOP3.Connected := True;
      Except
        On e: exception Do
          DoError(Self, 'TDSRMailPoll.DownloadPOP3Emails',
            'Error activating POP3. Error: ' + e.Message);
      End;

      {check mapi connection}
      If lPOP3.Connected Then
      Begin
        {retrieve the total ammount of files...}
        If lPOP3.MessageCount > 0 Then
        Begin
          {loop through the messages from the newest to oldest...}
          For lCont := lPOP3.MessageCount - 1 Downto 0 Do
          Begin
            lMessage := lPOP3[lCont];
            If lMessage <> Nil Then
            Begin
              ProcessEMail(lMessage, lPOP3);
              FreeAndNil(lMessage);
            End {if lMessage <> nil then}
            Else
              DoError(Self, 'TDSRMailPoll.DownloadPOP3Emails',
                'The application could not retrieve the E-Mail (POP3) ...');
          End; {For lCont := lTotal - 1 Downto 0 Do}
        End; {if lMapi.INBOX.MessagesCount > 0 then}
      End {if lMapi.Active then}
      Else
        DoError(Self, 'TDSRMailPoll.DownloadPOP3Emails',
          'The application could not connect to a POP3 server...');
    except
      on E: Exception do
        DoError(Self, 'TDSRMailPoll.DownloadPOP3Emails',
            'Error downloading POP3 message. Error: ' + e.Message);
    End; {try}

    if Assigned(lPOP3) then
      lPOP3.Free;
  End; {If lMapi <> Nil Then}
End;

{-----------------------------------------------------------------------------
  Procedure: DownloadIMAPEmails
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TDSRMailPoll.DownloadIMAPEmails;
Var
  lCont: Integer;
  lIMAP: TIMAPReceiver;
  lMessage: TMailMessage;
Begin
  lIMAP := Nil;

  Try
    lIMAP := TIMAPReceiver.Create;
  Except
    On e: exception Do
      DoError(Self, 'TDSRMailPoll.DownloadIMAPEmails',
        'The following exception occurred whilst creating IMAP components: ' +
        E.Message)
  End;

  {check mapi object}
  If lIMAP <> Nil Then
  Begin
    Try
      lIMAP.Host := Host;
      lIMAP.IncomingPort := IncomingPort;
      lIMAP.UserName := UserName;
      lIMAP.Password := Password;
      lIMAP.UseAuthentication := UseAuthentication;
      lIMAP.MailBox := MailBox;
      lIMAP.MailBoxSeparator := MailBoxSeparator;

      lIMAP.OnError := DoError;
      lIMAP.AttachDirectory := IncludeTrailingPathDelimiter(_GetApplicationPath +
        cTEMPDIR);

      {activate}
      Try
        lIMAP.Connected := True;
      Except
        On e: exception Do
          DoError(Self, 'TDSRMailPoll.DownloadIMAPEmails',
            'Error activating IMAP. Error: ' + e.Message);
      End;

      {check mapi connection}
      If lIMAP.Connected Then
      Begin
        {MUST select a mailbox before retrieving imap messages}
        lIMAP.SelectMailBox;
        {retrieve the total ammount of files...}
        If lIMAP.MessageCount > 0 Then
        Begin
          {loop through the messages from the newest to oldest...}
          For lCont := lIMAP.MessageCount - 1 Downto 0 Do
          Begin
            lMessage := lIMAP[lCont];
            If lMessage <> Nil Then
            Begin
              ProcessEMail(lMessage, lIMAP);
              FreeAndNil(lMessage);
            End {if lMessage <> nil then}
            Else
              DoError(Self, 'TDSRMailPoll.DownloadIMAPEmails',
                'The application could not retrieve the E-Mail (IMAP) ...');
          End; {For lCont := lTotal - 1 Downto 0 Do}
        End; {if lMapi.INBOX.MessagesCount > 0 then}
      End {if lMapi.Active then}
      Else
        DoError(Self, 'TDSRMailPoll.DownloadPOP3Emails',
          'The application could not connect to an IMAP server...');
    except
      on e:exception do
        DoError(Self, 'TDSRMailPoll.DownloadPOP3Emails',
          'Error downloading IMAP message. Error: ' + e.Message);
    End; {try}

    if Assigned(lIMAP) then
      lIMAP.Free;
  End; {If lMapi <> Nil Then}
end;


{-----------------------------------------------------------------------------
  Procedure: ProcessFiles
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.ProcessFiles;
Var
  I: LongInt;
Begin { DownloadPOP3Emails }
  If Assigned(fFile) Then
  Begin
    If fFile.Count > 0 Then
      For i := 0 To fFile.Count - 1 Do
      Begin
        Try
          ProcessFile(fFile[I]);
        Except
          On e: exception Do
            DoError(Self, 'TDSRMailPoll.ProcessFiles',
              'Error processing file. Error: ' + e.Message);
        End; {try}

        Sleep(500);
      End; {For i := 0 To lFileProcess.Count - 1 Do}
  End; {if Assigned(lFileProcess) then}
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRMailPoll.ProcessFile(Const pFile: String): Boolean;

  Procedure _UpdateOutbox(pMsg: TMessageInfo; pCompany: Integer; Const pMessage:
    String; pSendResponse: Integer; pDb: TADODSR);
  Begin
    Try
      pDb.UpdateOutBox(_CreateGuid, pCompany, pMessage, pMsg.To_, pMsg.From, 0, 1,
        pMsg.Param1, pMsg.Param2, IfThen(pSendResponse = S_OK, cSENT, cFAILED),
        Ord(rmNormal), dbDoAdd);
    Except
    End;
  End; {procedure}

Var
  lDSRHeader: TDSRFileHeader; {dsr file header}
  lAck: TACK; {acknowledge record}
  lNack: TNACK; {nacknowledge record}
  lPath,
    lNackFile: String; {which file is missing}
  lMail: TMessageInfo; {mail information}
  lDb: TADODSR; {db connection}
  lOrder, {order missing}
    lComp: Longword; {company id}
  lTempGuid: TGuid; {temporary guid}
  lSyncReq: TSyncRequest; {sync request record}
  lFileName: String; {sync request file name}
  lResponse: Integer; {response for the sender}
Begin
  Result := True;

  If _FileSize(pFile) > 0 Then
  Try
    FillChar(lDSRHeader, SizeOf(TDSRFileHeader), 0);
    _GetHeaderFromFile(lDSRHeader, pFile);

    {check valid header}
    If _IsValidGuid(lDSRHeader.BatchId) And (lDSRHeader.Flags In [ord(mtData),
      ord(mTACK), ord(mtNACK), ord(mtSyncRequest)]) Then
    Begin
      lDb := TADODSR.Create(_DSRGetDBServer);

      {clear temp e-mails}
      FillChar(lTempGuid, SizeOf(TGUID), 0);
      Try
        lDb.UpdateInBox(lTempGuid, 0, '', '', '', 0, 0, 0, 0, dbDoDelete);
      Except
      End;

      {process this file according to the flag request/sent}
      Case lDSRHeader.Flags Of
        ord(mtSyncRequest):
          Begin
            {a sync request has been made by client}
            Try
              ForceDirectories(fSystem.InboxDir + lDSRHeader.BatchId);
            Except
            End;

            FillChar(lTempGuid, SizeOF(TGuid), 0);
            Try
              lTempGuid := StringToGUID(Trim(lDSRHeader.BatchId));
            Except
              lTempGuid := _CreateGuid;
            End; {try}

          {copy temp file to the right directory and ack name}
            lFileName := IncludeTrailingPathDelimiter(fSystem.InboxDir +
              lDSRHeader.BatchId) + cACKFILE;
            CopyFile(pChar(pFile), pChar(lFileName), False);

            FillChar(lSyncReq, SizeOf(TSyncRequest), 0);
            _GetSyncReqFromFile(lSyncReq, lfileName);

            With lSyncReq Do
              If lDb.SearchInboxEntry(lTempGuid) > 0 Then
                lDb.UpdateInBox(lTempGuid, 0, Subject, MailFrom, MailTo, 0, 1,
                  cREADYIMPORT, Ord(rmSync), dbDoUpdate)
              Else
                lDb.UpdateInBox(lTempGuid, 0, Subject, MailFrom, MailTo, 0, 1,
                  cREADYIMPORT, Ord(rmSync), dbDoAdd);

            lMail := Nil;
            lMail := lDb.GetInboxMessage(lTempGuid);

          {clear blank entries}
            FillChar(lTempGuid, SizeOF(TGuid), 0);
            lDb.UpdateInBox(lTempGuid, 0, '', '', '', 0, 0, 0, 0, dbDoDelete);

            fLog.DoLogMessage('TDSRReceive.Receive', 0,
              //'A Dripfeed Request subject "' + lSyncReq.Subject
              'A Link Request subject "' + lSyncReq.Subject
              + '" has been successfully received!', True, True);

            With lSyncReq Do
              lResponse := TDSRMail.SendACK(_CreateGuid, MailTo, MailFrom,
                1, rmNormal, lDSRHeader.ExCode, lDSRHeader.CompGuid,
                'Acknowledge - [** Message ' + Subject +
                ' successfully received **]');

            {write and outbox entry for the message sent}
            If Assigned(lMail) Then
            Begin
              _UpdateOutbox(lMail, 0, 'Acknowledge - [** Message ' + lSyncReq.Subject
                + ' **]', lResponse, lDb);
              FreeAndNil(lMail);
            End;
          End; {ord(mtSyncRequest)}
        ord(mtData): {normal data}
          Begin
            lMail := lDb.GetInboxMessage(StringToGUID(lDSRHeader.BatchId));
            If Assigned(lMail) Then
            Begin
               {check the missing order file}
              If Not _CheckBatchComplete(lDSRHeader, fSystem.InboxDir +
                lDSRHeader.BatchId) Then
              Begin
                lOrder := _FindMissingOrder(lDSRHeader, fSystem.InboxDir +
                  lDSRHeader.BatchId);

                {avoind sending the same order request just after processing a bunch of messages...}
                If lOrder > 0 Then
                  If fOrderRequest.IndexOf(inttostr(lOrder)) < 0 Then
                  Begin
                    TDSRMail.SendNACK(StringToGUID(lDSRHeader.BatchId),
                      lMail.To_, lMail.From, lOrder, cNACKFILEMISS,
                      lDSRHeader.ExCode,
                      lDSRHeader.CompGuid, 'Missing file request. Order: ' +
                      Inttostr(lOrder));

                    fOrderRequest.Add(Inttostr(lOrder));
                  End;
              End
              Else {file is completed. Change its status to ready to import}
              Begin
                {avoid sending nacks for all received e-mails}
                If fACKSent.IndexOf(_SafeGuidtoString(lMail.Guid)) < 0 Then
                Begin
                  lResponse := TDSRMail.SendACK(lMail.Guid, lMail.To_, lMail.From,
                    lMail.TotalItens, rmNormal, lDSRHeader.ExCode,
                    lDSRHeader.CompGuid, 'Acknowledge - [** Message ' + lMail.Subject
                    + ' successfully received **]');

                  _UpdateOutbox(lMail, lMail.Company_Id, 'Acknowledge - [** Message '
                    + lMail.Subject + ' **]', lResponse, lDb);

                  fACKSent.Add(_SafeGuidtoString(lMail.Guid));
                End;

                fLog.DoLogMessage('TDSRReceive.Receive', 0, 'Message subject "' +
                  lMail.Subject + '" successfully received!', True, True);

                Result := True;
              End; {else begin}
            End {If Assigned(lMail) Then}
            Else
              _LogMSG('TDSRMailPoll.ProcessFile :- Message ID ' + lDSRHeader.BatchId
                + ' could not be found...');
          End; {ord(mtData)}
        ord(mtACK): {acknowledge}
          Begin
            _GetACKFromFile(lAck, pFile);

            Case lAck.Mode Of
              Ord(rmNormal):
                Begin
                  With lDb Do
                    UpdateInBox(_CreateGuid,
                      lDb.GetCompanyIdbyGuid(lDSRHeader.CompGuid),
                      lAck.Msg,
                      lAck.MailTo,
                      lAck.MailFrom,
                      0, 0, cACKNOWLEDGE, ord(rmNormal), dbDoAdd);

                  {delete lock file for the batch previous negotiated}
                  _DeleteDSRLockFile(fSystem.OutboxDir + lDSRHeader.BatchId);
                End; {begin}
              Ord(rmBulk):
                Begin
              {the receipient is asking to change the mode/status of the message}
                  With lDb Do
                    UpdateInBox(_CreateGuid,
                      lDb.GetCompanyIdbyGuid(lDSRHeader.CompGuid),
                      lAck.Msg,
                      lAck.MailTo,
                      lAck.MailFrom,
                      0, 0, cSYNCACCEPTED, ord(lAck.Mode), dbDoAdd);
                End; {begin}
              Ord(rmDripFeed):
                Begin
                  lPath := lDb.GetCompanyPathbyGuid(lDSRHeader.CompGuid);

                  If Not _CheckExDripFeed(lPath) Then
                    _ApplyDripFeed(lPath);

                  With lDb Do
                    UpdateInBox(_CreateGuid,
                      lDb.GetCompanyIdbyGuid(lDSRHeader.CompGuid),
                      lAck.Msg,
                      lAck.MailTo,
                      lAck.MailFrom,
                      0, 0, cACKNOWLEDGE, ord(lAck.Mode), dbDoAdd);

                  {delete lock file for the batch previous negotiated}
                  _DeleteDSRLockFile(fSystem.OutboxDir + lDSRHeader.BatchId);
                End; {begin}
            End; {case lack.mode of}

            If Trim(lAck.Msg) <> '' Then
            Begin
              fLog.DoLogMessage('TDSRMailPoll.ProcessFile', 0, Trim(lAck.Msg));
              lDb.UpdateIceLog('TDSRMailPoll.ProcessFile', Trim(lAck.Msg));
            End; {If Trim(lAck.Msg) <> '' Then}

          End;
        ord(mtNACK): {n acknowledge}
          Begin
            {check the nack flag}
            If _GetNACKFromFile(lNack, pFile) Then
              {missing file}
              Case lNack.Flag Of
                cNACKFILEMISS:
                  Begin
                    lMail := lDb.GetoutboxMessage(StringToGUID(lDSRHeader.BatchId));
                    lNackFile := _GetFileByOrder(fSystem.OutboxDir +
                      lDSRHeader.BatchId, lNack.Order);

                    If (lNackFile <> '') And (lMail <> Nil) Then
                    Begin
                  {avoid sending messages older than one day, archived messages or messages that belong to
                  a non active company}
                      If (HoursBetween(Now, lMail.Date) <= 24) And (lMail.Status <>
                        cARCHIVED) And lDb.IsCompanyActive(lMail.Company_Id) Then
                        TDSRMail.SendMsg(lMail.From, lMail.To_, lMail.Subject, '',
                          lNackFile)
                      Else
                        TDSRMail.SendNACK(lMail.Guid, lMail.From, lMail.To_, 0,
                          cNACKFILENOTFOUND, lDSRHeader.ExCode, lDSRHeader.CompGuid,
                          'The requested file could not be found.');
                    End {If lNackFile <> '' Then}
                    Else
                    Begin
                      lDb.UpdateIceLog('TDSRMailPoll.ProcessFile',
                        'Request for missing file failed. Order: '
                        + inttostr(lNack.Order) + ifThen(lMail = Nil,
                        ' Invalid record entry ' + lDSRHeader.BatchId, ''));

                      TDSRMail.SendNACK(_SafeStringToGuid(lDSRHeader.BatchId),
                        lNack.MailTo, lNack.MailFrom, 0, cNACKFILENOTFOUND,
                        lDSRHeader.ExCode, lDSRHeader.CompGuid,
                        'The requested file could not be sent.');
                    End; {else begin}

                    If Assigned(lMail) Then
                      FreeAndNil(lMail);
                  End; {cNACKFILEMISS}
                cNACKDELETE:
                  Begin
                    lDb.DeleteSchedule(StringToGUID(lDSRHeader.BatchId));
                    //TODO: what to do beyond this?
                  End; {cNACKDELETE}
                {end of the sync}
                cNACKREMOVESYNC:
                  Begin
                    lComp := lDb.GetCompanyIdbyGuid(Trim(lDSRHeader.CompGuid));
                    lPath := lDb.GetCompanyPathbyGuid(Trim(lDSRHeader.CompGuid));
                    lTempGuid := _CreateGuid;

                    lDb.UpdateInBox(lTempGuid, lComp,
                      '[** ' +
                      UpperCase(IfThen(Trim(lNack.Reason) = '',
                      //'End of Dripfeed requested', lNack.Reason) +
                      'End of Link requested', lNack.Reason) +
                      ' **] '),
                      lNack.MailFrom,
                      lNack.MailTo,
                      0, 1, cREMOVESYNC, Ord(rmNormal), dbDoAdd);

                {check directory, company is activated and if they have the same guid}
                    If _DirExists(lPath) And
                      lDb.IsCompanyActive(lComp) And {_CheckExDripFeed(lPath) And}
                      (Lowercase(Trim(lDSRHeader.CompGuid)) =
                      Lowercase(lDb.GetCompanyGuid(lComp))) Then
                    Begin
                      lDb.SetInboxMessageStatus(lTempGuid, cREMOVESYNC);
                    End
                    Else
                    Begin
                      {update the database}
                      lDb.SetInboxMessageStatus(lTempGuid, cPROCESSED);
                      If lDb.GetInboxMessageStatus(lTempGuid) <> cPROCESSED Then
                        lDb.UpdateInBox(lTempGuid, lComp, '', '', '', 0, 0,
                          cPROCESSED, 0, dbDoUpdate);

                      fLog.DoLogMessage('TDSRMailPoll.ProcessFile', 0,
                        //'Invalid company while trying to remove Dripfeed or company is already Out of Dripfeed.' +
                        'Invalid company while trying to remove Link or company is already Out of Link.' +
                        ' Name: ' + lDb.GetCompanyDescription(lComp) +
                        ' Code: ' + lDSRHeader.ExCode,
                        True, True);

                      FillChar(lTempGuid, SizeOf(TGuid), 0);
                      If lDb.GetCompanyGuid(lComp) <> '' Then
                        lDb.SetCompanyGuid(lComp, lTempGuid);
                    End;
                  End; {cNACKREMOVESYNC}
                cNACKSYNCDENIED, cNACKSYNCFAILED:
                  Begin
                    With lDb, lDSRHeader, lNack Do
                    Begin
                      {this update has been changed to be stored inside of the inbox of the company who made the request}
                      lComp := GetCompanyIdbyGuid(lDSRHeader.CompGuid);

                      UpdateInBox(_CreateGuid, lComp,
                        '[** ' +
                        UpperCase(IfThen(Reason = '',
                        //'Dripfeed Request denied or failed', Reason)) +
                        'Link Request denied or failed', Reason)) +
                        ' **] ',
                        IfThen(Trim(MailFrom) = '', cUNKNOWMAIL, MailFrom),
                        IfThen(Trim(MailTo) = '', cUNKNOWMAIL, MailTo),
                        0, 1,
                        ifThen(lNack.Flag = cNACKSYNCDENIED, cSYNCDENIED,
                        cSYNCFAILED),
                        Ord(rmNormal), dbDoAdd);

                      fLog.DoLogMessage('TDSRMailPoll.ProcessFile', 0, Reason);
                      UpdateIceLog('TDSRMailPoll.ProcessFile', Reason);
                    End; {With lDb, lDSRHeader Do}
                  End; {cSYNCDENIED}
                cNACKBULKFAILED:
                  With lDb, lDSRHeader, lNack Do
                  Begin
                    //lComp := GetCompanyId(lDSRHeader.ExCode);
                    lComp := GetCompanyIdbyGuid(lDSRHeader.CompGuid);
                    UpdateInBox(_CreateGuid, lComp,
                      '[** ' +
                      Reason +
                      ' **] ',
                      MailFrom,
                      MailTo,
                      0, 1,
                      cBULKFAILED,
                      Ord(rmNormal), dbDoAdd);

                    fLog.DoLogMessage('TDSRMailPoll.ProcessFile', 0, Reason);
                    UpdateIceLog('TDSRMailPoll.ProcessFile', Reason);
                  End; {cNACKBULKFAILED}
                cNACKDRIPFEEDFAILED:
                  Begin
                    With lDb, lDSRHeader, lNack Do
                    Begin
                      lComp := GetCompanyIdbyGuid(lDSRHeader.CompGuid);
                      UpdateInBox(_CreateGuid, lComp,
                        '[** ' +
                        Reason +
                        ' **] ',
                        MailFrom,
                        MailTo,
                        0, 1,
                        cDRIPFEEDFAILED,
                        Ord(rmNormal), dbDoAdd);

                      fLog.DoLogMessage('TDSRMailPoll.ProcessFile', 0, Reason);
                      UpdateIceLog('TDSRMailPoll.ProcessFile', Reason);
                    End; {With lDb, lDSRHeader, lNack Do}
                  End; {cNACKDRIPFEEDFAILED}
                cNACKFILENOTFOUND:
                  Begin
                    With lDb, lDSRHeader, lNack Do
                    Begin
                      lComp := GetCompanyIdbyGuid(lDSRHeader.CompGuid);

                      UpdateInBox(_CreateGuid, lComp,
                        '[** ' +
                        Reason +
                        ' **] ',
                        MailFrom,
                        MailTo,
                        0, 1,
                        cACKNOWLEDGE,
                        Ord(rmNormal), dbDoAdd);

                      fLog.DoLogMessage('TDSRMailPoll.ProcessFile', 0, Reason);
                      UpdateIceLog('TDSRMailPoll.ProcessFile', Reason);

                      With lDb, lDSRHeader Do
                        If GetInboxMessageStatus(_SafeStringToGuid(BatchId)) =
                          cRECEIVINGDATA Then
                          SetInboxMessageStatus(_SafeStringToGuid(BatchId),
                            cFAILED);
                    End; {With lDb, lDSRHeader, lNack Do}
                  End; {cNACKFILENOTFOUND}
                cNACKCANCELSYNC:
                  Begin
                    With lDb, lDSRHeader, lNack Do
                    Begin
                      lComp := GetCompanyIdbyGuid(lDSRHeader.CompGuid);

                      UpdateInBox(_CreateGuid, lComp,
                        '[** ' +
                        Reason +
                        ' **] ',
                        MailFrom,
                        MailTo,
                        0, 1,
                        cDRIPFEEDCANCELLED,
                        Ord(rmNormal), dbDoAdd);

                      fLog.DoLogMessage('TDSRMailPoll.ProcessFile', 0, Reason);
                      UpdateIceLog('TDSRMailPoll.ProcessFile', Reason);
                    End; {With lDb, lDSRHeader, lNack Do}
                  End; {cNACKCANCELSYNC}
              End; {Case lNack.Flag Of}
          End; {ord(mtNACK)}
      End; {Case lDSRHeader.Flags Of}
    End; {If _IsValidGuid(lDSRHeader.BatchId) And (lDSRHeader.Flags In [ord(mtData), ord(mTACK), ord(mtNACK), ord(mtSyncRequest)]) Then}
  Except
    On e: exception Do
      _LogMSG('TDSRMailPoll.ProcessFile :- error processing file. Error: ' +
        e.Message);
  End; {try If _FileSize(pFile) > 0 Then}

  If Assigned(lDb) Then
    FreeAndNil(lDb);

  Try
    _DelFile(pFile);
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: IsValidDSRMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRMailPoll.IsValidDSRMail(Var pMsgBody: String): Boolean;
Var
  lMsgBody,
    lAux: String;
  lGuidNull: TGuid;
Begin
  FillChar(lGuidNull, SizeOf(Tguid), 0);

  Result := False;
  If pMsgBody <> '' Then
  Begin
    lAux := pMsgBody;
  {remove first pipe}
    _strToken(lAux, cPIPE);
  {get msg body}
    lMsgBody := _strToken(lAux, cPIPE);
    lAux := lMsgBody;
    Result := Not IsEqualGUID(lGuidNull, _SafeStringToGuid(lAux));

    If Result Then
      pMsgBody := lAux;
  End; {if pMsgBody <> '' then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetFirstAttach
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRMailPoll.GetFirstAttach(pList: TStringList): String;
Var
  lDSRHeader: TDSRFileHeader;
  lCont: Integer;
Begin
  If Assigned(pList) Then
    If pList.Count > 0 Then
      For lCont := 0 To pList.Count - 1 Do
        If _FileSize(pList[lCont]) > 0 Then
        Begin
        {verify the file extenstion}
          If _ValidExtension(pList[lCont]) Then
          Begin
            FillChar(lDSRHeader, SizeOF(TDSRFileHeader), 0);
            _GetHeaderFromFile(lDSRHeader, pList[lCont]);

        { verify header details}
            If _IsValidGuid(lDSRHeader.BatchId) And (lDSRHeader.Total > 0) And
              _IsValidDSRVersion(lDSRHeader.Version, CommonBit {cDSRVERSION}) Then
            Begin
              Result := pList[lCont];
              Break;
            End
          End; {If (lFileExt = cXMLEXT) Or}
        End; {For lCont := 0 To lFiles.Count - 1 Do}
End;

{-----------------------------------------------------------------------------
  Procedure: DoError
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.DoError(Sender: TObject; Const pWhere,
  pError: String);
Begin
  fLog.DoLogMessage(pWhere, cERROR, pError, True, True);
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessEMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.ProcessEMail(pEmail: TMailMessage; pMailer: TEmailBase);
Var
  lCont, lCont2, ltotal: Integer;
  lmsgBody, lDir, lAux, lFileName: String;
  lAtta: TStringList;
  lDSRHeader: TDSRFileHeader;
  lMessage: TMailMessage;
  lDb: TADODSR;
Begin
  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
  End;

  If Assigned(lDb) Then
  Begin
    If lDb.Connected Then
    Begin
      If pEmail <> Nil Then
      Begin
        {check for attachments}
        If pEmail.AttachCount > 0 Then
        Begin
          lMsgBody := Trim(pEmail.Body.Text);

          If IsValidDSRMail(lMsgBody) Then
          Begin
            lDir := IncludeTrailingPathDelimiter(_GetApplicationPath + cTEMPDIR);
            
            Try
              ForceDirectories(lDir);
            Except
            End;

            lAtta := TStringList.Create;
            {add to the list to be picked up later}
            lAtta.CommaText := pEmail.AttachmentsAsStr;
            lFilename := '';
            FillChar(lDSRHeader, SizeOF(TDSRFileHeader), 0);

            {process the attachements}
            Try
              If lAtta.Count > 0 Then
              Begin
                {get the first valid file and load its header}
                lFileName := GetFirstAttach(lAtta);
                _GetHeaderFromFile(lDSRHeader, lFileName);

                {double check if this batch has been already completed (for bulk and dripfeed data only)}
                If (lDSRHeader.Mode In [Ord(rmBulk), Ord(rmDripFeed)]) And
                (lDSRHeader.Flags In [ord(mtData)]) And
                _IsValidGuid(Trim(lDSRHeader.BatchId)) Then
                Begin
                   {check the all files have their crc ok and all files have been received}
                  If Not _CheckBatchCompleteEx(lDSRHeader, fSystem.InboxDir +
                    lDSRHeader.BatchId) Then
                  Begin
                    Try                        
                      TDSRReceive.Receive(pEmail.Subject, pEmail.SenderAddress,
                        Trim(pEmail.To_.Text), lAtta)
                    Except
                      On e: exception Do
                        DoError(Self, 'TDSRMailPoll.ProcessEMail',
                          'Error processing message. Error: ' + e.Message);
                    End; {try}
                  End; {check batch complete}
                End
                Else
                Begin
                  Try
                    TDSRReceive.Receive(pEmail.Subject, pEmail.SenderAddress,
                      Trim(pEmail.To_.Text), lAtta);
                  Except
                    On e: exception Do
                      DoError(self, 'TDSRMailPoll.ProcessEMail',
                        'Error processing message (2). Error: ' + e.Message);
                  End; {try}
                End; {else begin}
              End; {If lAtta.Count > 0 Then}

                {get a valid file for checking if batch is completed}
              If (lFileName <> '') And (_FileSize(lFileName) > 0) Then
              Begin
                lAux := lDir + _CreateGuidStr + ExtractFileExt(lFileName);
                If Not CopyFile(pChar(lFileName), pChar(lAux), False) Then
                  RenameFile(lFileName, lAux);

                If _FileSize(lAux) > 0 Then
                  fFile.Add(lAux)
                Else
                  fFile.Add(lFileName);

                If pMailer <> Nil Then
                  pMailer.SetMessageToDelete(pEmail.Index);

                DeleteAttach(lAtta, lFileName);
              End; {if (lFileName <> '') and (_FileSize(lFileName) > 0) then}
            Except
              On e: Exception Do
                DoError(Self, 'TDSRMailPoll.DownloadMAPIEmails',
                  'Error receiving message details. Error: ' + e.Message);
            End; {try}

            If Assigned(lAtta) Then
              FreeAndNil(lAtta);
          End {If IsValidDSRMail(lMsgBody) Then}
          Else If lDb.GetSystemValue(cDELETENONDSREMAILPARAM) = '1' Then
            If pMailer <> Nil Then
              pMailer.SetMessageToDelete(pEmail.Index);
        End; {if lMapi.INBOX.Messages[lCont].Attachments.Count > 0 then}
      End;
    End; {if lDb.Connected then}

    lDb.Free;
  End; {if Assigned(lDb) then}
End;

{ TCheckMAPI }

{-----------------------------------------------------------------------------
  Procedure: CheckForEmails
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TCheckMAPI.CheckForEmails;
begin
  fWorking := True;

  fFile.Clear;
  fACKSent.Clear;
  fOrderRequest.Clear;

  {download mapi emails}
  DownloadMAPIEmails;

  {process the files received}
  ProcessFiles;
  {process old/pending files}
  ProcessUnreceivedMessages;

  ClearMAPISentBox;

  fWorking := False;

  Sleep(2);
end;

{ TCheckPOP3 }

{-----------------------------------------------------------------------------
  Procedure: CheckForEmails
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TCheckPOP3.CheckForEmails;
begin
  fWorking := True;

  fFile.Clear;
  fACKSent.Clear;
  fOrderRequest.Clear;

  {download pop3 e-mail}
  DownloadPOP3Emails;
  {process the files received}
  ProcessFiles;
  {process old/pending files}
  ProcessUnreceivedMessages;

  fWorking := False;

  Sleep(2);
end;

{ TCheckIMAP }

{-----------------------------------------------------------------------------
  Procedure: CheckForEmails
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TCheckIMAP.CheckForEmails;
begin
  fWorking := True;

  fFile.Clear;
  fACKSent.Clear;
  fOrderRequest.Clear;

  {download imap email}
  DownloadIMAPEmails;
  {process the files received}
  ProcessFiles;
  {process old/pending files}
  ProcessUnreceivedMessages;

  fWorking := False;

  Sleep(2);
end;

End.

