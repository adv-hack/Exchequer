{-----------------------------------------------------------------------------
 Unit Name: uDSRMailPoll
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDSRMailPoll_;

Interface

Uses Classes, Windows,
  mailpoll, msmsg, vkmapi,
  uBaseClass, uSystemConfig;

Type

  TDSRMailPoll = Class(TEmailPoller)
  Private
    fLog: _Base;
    fWorking: boolean;
    fSystem: TSystemConf;
    {fNackList: TNackList;}

    fACKSent,
      fFile,
      fMailProcess,
      fOrderRequest: TStringlist;

    fPOP3Port: Integer;
    fSMTPPort: Integer;

    Procedure LogError(Const pMsg: ShortString);
    Procedure DeleteAttach(pList: TStringList; Const pAvoidFile: String = '');
    Function ProcessFile(Const pFile: String): Boolean;
    Procedure ProcessMAPIEmails;
    Procedure ProcessSimpleMAPIEmails;
    Procedure ProcessPOP3Emails;
    Function IsValidDSRMail(Var pMsgBody: String): Boolean;
    Function GetFirstAttach(pList: TStringList): String;
    Function GetFirstValidAttach: String;
    Function CreateSMTPPOP3ValidFile(pMailMessage: TmsMessage; Const pGetAll: Boolean
      = False): String;
    Function GetSmtpOnline: Boolean;
    Procedure ProcessEmlFile(Var lList: TStringList; Const pFile: String);
    Procedure SavePOP3Attach(pMemoryStream: TMemoryStream; Const pFile: String);
    //Function ReceiveSMTPPOP3(pMailMessage: TmsMessage): Longword;
    Procedure ProcessUnreceivedMessages;
    Procedure ClearMAPISentBox;
  Protected
    Procedure CheckForEmails; Override;
    Procedure CheckForEmailsEx; Virtual;
    Procedure GotMessage; Override;
    Procedure DownloadMAPIEmails; Override;
    Procedure DownloadSimpleMAPIEmails; Override;
    Procedure DownloadPOP3Emails; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure SMTPLogOff;
  Published
    Property Working: boolean Read fWorking Write fWorking;
    Property SMTPOnline: Boolean Read GetSmtpOnline;
    Property POP3Port: Integer Read fPOP3Port Write fPOP3Port;
    Property SMTPPort: Integer Read fSMTPPort Write fSMTPPort;
  End;

Implementation

Uses
  DateUtils, StrUtils, Math, SysUtils, variants,

  uDsrMail, uDSRFileFunc, uDSRReceive, uExFunc,
  uInterfaces, uCommon, uConsts, uAdoDSR, uDsrSettings, MapiEx, Mssocket,
  Mspop
  ;

{ TDSRMailPoll }

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
Var
  lNoError: boolean;
Begin
  fWorking := True;

  {simple mapi}
  If Assigned(EmailS) Then
  Begin
    EmailS.DownLoadFirst := True;
    EmailS.NewSession := False;
    EmailS.TruncAttFN := False;
    EmailS.UseDefProfile := True;
    EmailS.UnreadOnly := True;
    EmailS.LeaveUnread := False;
  End;

(*  changed to VKMAPI
  {extended mapi}
  If Assigned(Email1) Then
  Begin
    Email1.UseDefProfile := True;
    Email1.LeaveUnread := True;
    {$IFDEF DEBUG}
    Email1.InService := False;
    {$ELSE}
    //Email1.InService := true;
    Email1.InService := False;
    {$ENDIF}
  End; {If Assigned(Email1) Then}
*)

  fMailProcess.Clear;
  fFile.Clear;
  fACKSent.Clear;
  fOrderRequest.Clear;
  lNoError := True;

  {check the new messages}
  Try
    //Inherited CheckForEmails;
    CheckForEmailsEx;
  Except
    On e: exception Do
    Begin
      lNoError := False;
      _LogMSG('TDSRMailPoll.CheckForEmails -: Exception whilst checking E-Mails. Error: '
        + e.Message);
    End;
  End; {try}

  {process old mails}
  If lNoError Then
    Case EmailType Of
      emlMAPI:
        If Assigned(EmailS) Or Assigned(Email1) Then
        Try
        { Logon to MAPI and download all emails to inbox }
          If Not Assigned(Email1) Then
            ProcessSimpleMAPIEmails
          Else
          Begin
            //ProcessMAPIEmails;
            ProcessPOP3Emails;
          End;
        Except
          On Ex: Exception Do
            _LogMsg('TDSRMailPoll.CheckForEmails -: Exception whilst checking for MAPI E-Mail:'
              + Ex.Message);
        End;

      emlSMTP:
        Try
          ProcessPOP3Emails;
        Except
          On Ex: Exception Do
            _LogMsg('TDSRMailPoll.CheckForEmails :- Exception whilst checking for SMTP/POP3 E-Mail:'
              + Ex.Message);
        End;
    End; // case

  ProcessUnreceivedMessages;

  if EmailType = emlMAPI then
    ClearMAPISentBox;

  fWorking := False;

  Sleep(2);
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
  lMapi: TMAPISession;
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

          Try
            lMapi := TMAPISession.Create(Nil);
          Except
            On e: exception Do
              _LogMsg('TDSRMailPoll.ClearSentBox :- The following exception occurred whilst creating MAPI components: '
                + E.Message)
          End;

          If lMapi <> Nil Then
          Begin
            Try
              lMapi.INBOX.LoadAttach := False;

        {set mapi logon parameters}
              With lMapi.LogonFlags Do
              Begin
                LOGON_UI := False;
                NEW_SESSION := True;
                ALLOW_OTHERS := True;
                EXPLICIT_PROFILE := False;
                EXTENDED := True;
                FORCE_DOWNLOAD := False;
                SERVICE_UI_ALWAYS := False;
                NO_MAIL := False;
                NT_SERVICE := True;
                PASSWORD_UI := False;
                TIMEOUT_SHORT := False;
                USE_DEFAULT := True;
              End; {with lMapi.LogonFlags do}

              Try
          {activate}
                Try
                  lMapi.Active := True;
                Except
                  On e: exception Do
                    _LogMSG('TDSRMailPoll.ClearSentBox :- Error activating MAPI (1). Error: '
                      + e.Message);
                End;
              Finally
          {if something goes wrong, might be because the ntservice flag}
                If Not lMapi.Active Then
                Begin
                  lMapi.LogonFlags.NT_SERVICE := False;
                  Try
                    lMapi.Active := True;
                  Except
                    On e: exception Do
                      _LogMSG('TDSRMailPoll.ClearSentBox :- Error activating MAPI (2). Error: '
                        + e.Message);
                  End; {try}
                End; {if not lMapi.Active then}
              End; {try}

              If lMapi.Active Then
              Begin
                With lMapi.SENTBOX Do
                  If MessagesCount > 0 Then
                    For lCont := MessagesCount - 1 Downto 0 Do
                      If MinutesBetween(Now, MAPIMessage[lCont].MessageDeliveryTime)
                        > 60 Then
                      Begin
                        lAux := Trim(MAPIMessage[lCont].BODY);
                        If IsValidDSRMail(lAux) Then
                          DeleteMessage(lCont);
                      End; {If MinutesBetween()}
                      
                Try
                  lMapi.FlushQs;
                Finally
                End;

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
  Procedure: CheckForEmailsEx
  Author:    vmoura

  a modified version of mailpoll.CheckForEmails
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.CheckForEmailsEx;
Var
  NumWaiting: longint;
//  OldText: String;
//  WasMessages: Boolean;
  Res: Integer;
  lLogin: Boolean;
Begin
//  WasMessages := False;

  Case EmailType Of
    emlMAPI:
      Try
        { Logon to MAPI and download all emails to inbox }
        If Assigned(EMailS) Then
        Begin
          EmailS.UseDefProfile := True;

          Try
            Res := -1;
            Try
              Res := EmailS.Logon;
            Except
              On e: exception Do
                _LogMSG('TDSRMailPoll.CheckForEmailsEx :- Error doing SIMPLE MAPI logon. Error: '
                  + e.message);
            End; {try}

            { Count unread emails }
            If Res = 0 Then
            Begin
              NumWaiting := EmailS.CountUnread;
              If NumWaiting > 0 Then // Process e-mails
                DownloadSimpleMAPIEmails;
            End; {If Res = 0 Then}
          Finally
            { Logoff MAPI }
            Try
              EmailS.LogOff;
            Except
            End; {try..except}
          End; {try..finally}
        End {If Assigned(EMailS) Then}
        Else
        Begin
          DownloadMAPIEmails;

(*      changed to vkmapi
           Email1.UseDefProfile := True;
          Try
            Res := -1;
            Try
              Res := Email1.Logon;
            Except
              On e: exception Do
                fLog.DoLogMessage('TDSRMailPoll.CheckForEmailsEx', 0,
                  'Error doing MAPI logon. Error: ' + e.message);
            End; {try}

            If Res = 0 Then
              DownloadMAPIEmails;
            Finally
            Try
              Email1.Logoff;
            Except
            End; {try}
          End; {try}*)
        End; {else begin}
      Except
        On Ex: Exception Do
          fLog.DoLogMessage('TDSRMailPoll.CheckForEmailsEx', 0,
            'Exception whilst checking for MAPI E-Mail: ' + Ex.Message);
      End; {try}

    emlSMTP:
      Begin
        Try
          With MSPop1 Do
          Begin
            Host := POP3Server;
            UserName := POP3UserName;
            Password := POP3PassWord;
            Port := POP3Port;
          { Connect to Server }

            Try
              Try
                Login;
                lLogin := True;
              Except
                On e: exception Do
                Begin
                  fLog.DoLogMessage('TDSRMailPoll.CheckForEmailsEx', 0,
                    'POP3 login error. Error: ' + e.message);
                  lLogin := False;
                End;
              End;

            { Check for outstanding messages }
              If lLogin Then
                If TotalMessages > 0 Then
                Try
                  DownloadPOP3Emails;
                Except
                End;
            Finally
              SMTPLogOff;
            End; {try}
          End; // with
        Except
          On Ex: Exception Do
            fLog.DoLogMessage('TDSRMailPoll.CheckForEmailsEx', 0,
              'Exception whilst checking for SMTP/POP3 E-Mail:' + Ex.Message);
        End; {try}
      End;
  End; // case
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
  SuppressErrorMessages := True;
  fMailProcess := TStringlist.Create;
  fFile := TStringList.Create;
  fACKSent := TStringList.Create;
  fOrderRequest := TStringList.Create;

  fSystem := TSystemConf.Create;

  OnErrorMessage := LogError;

  If Assigned(EmailS) Then
    EmailS.LeaveUnread := True;

  If Assigned(Email1) Then
  Begin
    Email1.UseDefProfile := True;
    Email1.DeleteAfterRead := False;
    Email1.LeaveUnread := True;
  End; {If Assigned(Email1) Then}
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

  If Assigned(fMailProcess) Then
    FreeAndNil(fMailProcess);

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
//  Messages: TStringList;
//  MsgCnt, MsgPos: SmallInt;
//  I: SmallInt;
//  ErrStr: ShortString;
  Res: Integer;

  // new
  lCont, lCont2, lIndex: Integer;
  lMapi: TMAPISession;
  lMailTo, lmsgBody, lDir, lAux, lFileName: String;
  lAtta: TStringList;
  lDSRHeader: TDSRFileHeader;
Begin { DownLoadEmails }
(* changed to vkmapi
   Try { Except }
    Res := Email1.GetFirstUnread;

    While Res = 0 Do
    Begin
      GotMessage;
      Res := Email1.GetNextUnread;
    End; {while Res = 0 do}
  Except
    On E: Exception Do
    Begin
      _LogMsg('TDSRMailPoll.DownloadMAPIEmails :- The following exception occurred whilst reading the messages: '
        + E.Message)
    End {begin}
  End; {try}*)

  Try
    lMapi := TMAPISession.Create(Nil);
  Except
    On e: exception Do
      _LogMsg('TDSRMailPoll.DownloadMAPIEmails :- The following exception occurred whilst creating MAPI components: '
        + E.Message)
  End;

  If lMapi <> Nil Then
  Begin
    Try
      lMapi.AttachTempDirectory := IncludeTrailingPathDelimiter(_GetApplicationPath
        + cTEMPDIR);
      lMapi.INBOX.LoadAttach := True;
      lMapi.OUTBOX.LoadAttach := False;
      lMapi.WASTEBOX.LoadAttach := False;
      lMapi.SENTBOX.LoadAttach := False;

      {set mapi logon parameters}
      With lMapi.LogonFlags Do
      Begin
        LOGON_UI := False;
        NEW_SESSION := True;
        ALLOW_OTHERS := True;
        EXPLICIT_PROFILE := False;
        EXTENDED := True;
        FORCE_DOWNLOAD := False;
        SERVICE_UI_ALWAYS := False;
        NO_MAIL := False;
        NT_SERVICE := True;
        PASSWORD_UI := False;
        TIMEOUT_SHORT := False;
        USE_DEFAULT := True;
      End; {with lMapi.LogonFlags do}

      Try
        _CallDebugLog('About to connect mapi 1');
        {activate}
        Try
          lMapi.Active := True;
        Except
          On e: exception Do
            _LogMSG('TDSRMailPoll.DownloadMAPIEmails :- Error activating MAPI (1). Error: '
              + e.Message);
        End;
      Finally
        {if something goes wrong, might be because the ntservice flag}
        If Not lMapi.Active Then
        Begin
          lMapi.LogonFlags.NT_SERVICE := False;
          Try
            _CallDebugLog('About to connect mapi 2');
            lMapi.Active := True;
          Except
            On e: exception Do
              _LogMSG('TDSRMailPoll.DownloadMAPIEmails :- Error activating MAPI (2). Error: '
                + e.Message);
          End; {try}
        End; {if not lMapi.Active then}
      End; {try}

      If lMapi.Active Then
      Begin
        _CallDebugLog('MAPI connected');
        If lMapi.INBOX.MessagesCount > 0 Then
        Begin
          _CallDebugLog('there is(are) ' + inttostr(lMapi.INBOX.MessagesCount) + ' message(s) to process');
          
          {loop through the messages}
          For lCont := lMapi.INBOX.MessagesCount - 1 Downto 0 Do
          Begin
            _CallDebugLog('MAPI processing message ' + inttostr(lCont));
            
            {check for attachments}
            If lMapi.INBOX.Messages[lCont].Attachments.Count > 0 Then
            Begin
              With lMapi.INBOX.Messages[lCont], TDSRReceive Do
              Begin
                Try
                  lMsgBody := trim(BODY);
                Except
                End;

                If IsValidDSRMail(lMsgBody) Then
                Begin
                  lDir := IncludeTrailingPathDelimiter(_GetApplicationPath +
                    cTEMPDIR);
                  Try
                    ForceDirectories(lDir);
                  Except
                  End;

                  lAtta := TStringList.Create;
                  {add to the list to be picked up later}
                  lIndex := fMailProcess.Add(lMsgBody);

                  For lCont2 := 0 To Attachments.Count - 1 Do
                    If _ValidExtension(Trim(Attachments.Items[lCont2].FileName))
                      Then
                    Begin
                      //lFileName := lDir + _CreateGuidStr +
                      //  ExtractFileExt(Attachments.Items[lCont2].FileName);

                      //Try
                      //  If Attachments.Items[lCont2] <> Nil Then
                      //    If Attachments.Items[lCont2].MemoryStream <> Nil Then
                      //      Attachments.Items[lCont2].MemoryStream.SaveToFile(lFileName);
                      //Except
                      //  On e: exception Do
                      //    _LogMSG('TDSRMailPoll.DownloadMAPIEmails :- Error saving MAPI message. Error: '
                      //      + e.Message);
                      //End;

                      lFileName := Attachments.Items[lCont2].FileName;

                      If _FileSize(lFileName) > 0 Then
                        lAtta.Add(lFileName);
                    End; {If _ValidExtension(Trim(Attachments.Items[lCont2].FileName)) then}

                  lFilename := '';
                  FillChar(lDSRHeader, SizeOF(TDSRFileHeader), 0);

                  lMailTo := ifThen(Trim(REPRESENTING_MAPI_EMAIL_TO) <> '',
                    Trim(REPRESENTING_MAPI_EMAIL_TO), REPRESENTING_NAME_EMAIL_TO);

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
                          _CallDebugLog('Calling receive function. Subject: ' + Subject + ' from ' + REPRESENTING_EMAIL_FROM +
                          ' mail to : ' + lMailTo + ' count attachment: ' + inttostr(lAtta.Count));
                          
                          Try
                            Receive(Subject, REPRESENTING_EMAIL_FROM, lMailTo, lAtta)
                          Except
                            On e: exception Do
                              _LogMSG('TDSRMailPoll.DownloadMAPIEmails :- Error processing MAPI message. Error: '
                                + e.Message);
                          End; {try}
                        End; {check batch complete}
                      End
                      Else
                      Begin
                        Try
                          Receive(Subject, REPRESENTING_EMAIL_FROM, lMailTo, lAtta);
                        Except
                          On e: exception Do
                            _LogMSG('TDSRMailPoll.DownloadMAPIEmails :- Error processing MAPI message (2). Error: '
                              + e.Message);
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

                      MessageFlags.CAN_DELETE := True;

(*                      try
                        lMapi.INBOX.DeleteMessage(lCont);
                      except
                        on e:exception do
                          _LogMSG('TDSRMailPoll.DownloadMAPIEmails :- Error deleting MAPI message. Error: '
                            + e.Message);
                      end;*)
                    End; {if (lFileName <> '') and (_FileSize(lFileName) > 0) then}
                  Except
                    On e: Exception Do
                    Begin
                      _LogMSG('TDSRMailPoll.DownloadMAPIEmails :- Error receiving MAPI message. Error: '
                        + e.Message);

                    {if something happened, remove message from the list to be processed later}
                      If lIndex > 0 Then
                      Try
                        If fMailProcess.Count > 0 Then
                          fMailProcess.Delete(lIndex);
                      Except
                      End; {try}
                    End; {begin}
                  End; {try}

                  If Assigned(lAtta) Then
                    FreeAndNil(lAtta);
                End {If IsValidDSRMail(lMsgBody) Then}
                Else If fSystem.DeleteNonDSR Then
                  lMapi.INBOX.Messages[lCont].MessageFlags.CAN_DELETE := True;
              End; {With Email1 Do}
            End; {if lMapi.INBOX.Messages[lCont].Attachments.Count > 0 then}
          End; {For lCont := lMapi.INBOX.MessagesCount - 1 Downto 0 Do}

          For lCont := lMapi.INBOX.MessagesCount - 1 Downto 0 Do
            If lMapi.INBOX.Messages[lCont].MessageFlags.CAN_DELETE Then
            Try
              lMapi.INBOX.DeleteMessage(lCont);
            Except
            End;

        End; {if lMapi.INBOX.MessagesCount > 0 then}
      End {if lMapi.Active then}
      else
        _LogMSG('TDSRMailPoll.DownloadMAPIEmails :- The application could not connect to a MAPI session...');

    Finally
      Try
        lMapi.FlushQs;
      Finally
      End;

      lMapi.Free;
    End; {try}
  End; {If lMapi <> Nil Then}

End;

{-----------------------------------------------------------------------------
  Procedure: DownloadPOP3Emails
  Author:    vmoura
  Arguments: None
  Result:    None

  i am override because the original function delete the mail after processing it
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.DownloadPOP3Emails;
Var
  i: Integer;
  lRetrieve: Boolean;
Begin { DownloadPOP3Emails }
  Try { Except }
    If Assigned(msPOP1) Then
      With msPOP1 Do
      Begin
      { Download all messages }
        For I := 0 To Pred(TotalMessages) Do
        Begin
          CurrentMessage := i;
          Sleep(100);
          lRetrieve := True;

          Try
            If Not msPop1.ConnectionReset Then
            Try
              Retrieve;
            Except
              On E: Exception Do
              Begin
                lRetrieve := False;
                _LogMsg('TDSRMailPoll.DownloadPOP3Emails :- Error retrieving message. Error: '
                  + E.Message);
              End; {begin}
            End {try}
            Else
              lRetrieve := False;

            {if the message was retrieved}
            Sleep(300);
            If lRetrieve And Not msPop1.ConnectionReset Then
              GotMessage
            Else
              Break;
          Except
            On E: Exception Do
              _LogMsg('TDSRMailPoll.DownloadPOP3Emails :- Error downloading the E-Mail. Error: '
                + E.Message);
          End; {try}
        End; { For }
      End; { With msPOP1 }
  Except
    On E: Exception Do
      _LogMsg('TDSRMailPoll.DownloadPOP3Emails :- The following exception occurred whilst reading the messages: '
        + E.Message);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessEmlFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.ProcessEmlFile(Var lList: TStringList; Const pFile: String);
Var
  lMessage: TmsMessage;
  lDir,
    lFileName: String;
  lCont: Integer;
Begin
  If (_FileSize(pFile) > 0) And Assigned(lList) Then
  Begin
    lMessage := Nil;
    Try
      lMessage := TmsMessage.Create(Nil);
    Except
    End;

    If Assigned(lMessage) Then
    Try
      With lMessage Do
      Begin
        Try
          LoadFromFile(pFile);
        Except
        End;

        lDir := IncludeTrailingPathDelimiter(_GetApplicationPath + cTEMPDIR);
        Try
          ForceDirectories(lDir);
        Except
        End;

        {laod the attachements inside the eml file}
        If Attachments.Count > 0 Then
          For lCont := 0 To Attachments.Count - 1 Do
          Begin
            lFileName := '';
            If Assigned(Attachments.Items[lCont]) Then
              With Attachments.Items[lCont] Do
              Begin
                lFileName := lDir + ExtractFileName(FileName);

                Try
                  SavePOP3Attach(Contents, lFileName);
                Except
                End;
              End; {With Attachments.Items[lCont] Do}

            If (lFileName <> '') And (_FileSize(lFileName) > 0) Then
              If _ValidExtension(lFileName) Then
                If lList.IndexOf(lFileName) = -1 Then
                  lList.Add(lFileName)
          End; {For lCont := 0 To Attachments.Count - 1 Do}
      End; {With lMessage Do}
    Finally
      FreeAndNil(lMessage);
    End; {If Assigned(lMessage) Then}
  End; {if _FileSize(pFile) > 0 then}
End;

{-----------------------------------------------------------------------------
  Procedure: SavePOP3Attach
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.SavePOP3Attach(pMemoryStream: TMemoryStream; Const pFile:
  String);
Begin
  If Assigned(pMemoryStream) Then
  Begin
    If _FileSize(pFile) = 0 Then
    Begin
//      _DelFile(pFile);

      Try
        If _ValidExtension(pFile) Then
          pMemoryStream.SaveToFile(pFile);
      Except
        On e: exception Do
        Begin
          _DelFile(pFile);
          _LogMSG('TDSRMailPoll.SavePOP3Attach :- Error saving POP3 attachment. Error: '
            + e.Message);
        End;
      End; {try}
    End; {If _FileSize(pFile) = 0 Then}
  End; {if Assigned(pMemoryStream) then}
End;

{-----------------------------------------------------------------------------
  Procedure: DownloadSimpleMAPIEmails
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.DownloadSimpleMAPIEmails;
Var
  Messages: TStringList;
Begin { DownLoadEmails }
  { Create list to store Message ID's in }
  Messages := TStringList.Create;

  Try { Finally }
    If Assigned(EmailS) Then
    Try { Except }
      { Download all Message ID's into local list }

      EmailS.GetNextMessageId;

      While (Length(EmailS.MessageId) <> 0) And (Not WantToClose) Do
      Begin
        Messages.Add(EmailS.MessageId);

        EmailS.GetNextMessageID;
      End; { While (Length(EmailS.MessageId) <> 0) }

      { Process downloaded messages -have to do this way otherwise positioning }
      { is lost in message queue and it starts looping, etc...                 }
      While (Messages.Count > 0) And (Not WantToClose) Do
      Begin
        With EmailS Do
        Begin
          { Set Message ID from list }
          MessageId := Messages[0];
          LeaveUnread := False;

          { fetch the specified message }
          ReadMail;

          GotMessage;
        End; { With Email1 }

        { Remove Message ID from list }
        If Messages.Count > 0 Then
          Messages.Delete(0);
      End; { While (Messages.Count > 0) }
    Except
      On Ex: Exception Do
        _LogMsg('The following exception occurred whilst reading the messages:'
          + Ex.Message);
    End;
  Finally
    FreeAndNil(Messages);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: GotMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.GotMessage;
Var
  lRec, lAtta: TStringList;
  lMsgBody, lDir, lSender,
    lFileName: String;
  lIndex,
    lCont: Integer;
  lDSRHeader: TDSRFileHeader;
Begin
  Case EmailType Of
    emlMAPI
      :
      If Assigned(Email1) Then
      Begin
(*        With Email1, TDSRReceive Do
        Begin
          Try
            lMsgBody := trim(GetLongText);
          Except
          End;

          If IsValidDSRMail(lMsgBody) Then
          Begin
            lAtta := TStringList.Create;
            {add to the list to be picked up later}
            lIndex := fMailProcess.Add(lMsgBody);

            For lCont := 0 To Attachment.Count - 1 Do
              If Trim(Attachment[lCont]) <> '' Then
                If _ValidExtension(Trim(Attachment[lCont])) Then
                  lAtta.Add(Trim(Attachment[lCont]));

            Try
              Receive(Subject, OrigAddress, Recipient.Text, lAtta.CommaText);
            Except
              On e: Exception Do
              Begin
                _LogMSG('TDSRMailPoll.GotMessage :- Error receiving MAPI message. Error: '
                  + e.Message);

              {if something happened, remove message from the list to be processed later}
                If lIndex > 0 Then
                Try
                  If fMailProcess.Count > 0 Then
                    fMailProcess.Delete(lIndex);
                Except
                End; {try}
              End; {begin}
            End; {try}

            If Assigned(lAtta) Then
              FreeAndNil(lAtta);
          End; {If IsValidDSRMail(lMsgBody) Then}
        End; {With Email1 Do}*)
      End {If Assigned(Email1) Then}
      Else If Assigned(EmailS) Then
      Begin
        With EmailS, TDSRReceive Do
        Begin
          Try
            lMsgBody := Trim(GetLongText);
          Except
          End;

          If IsValidDSRMail(lMsgBody) Then
          Begin
            lAtta := TStringList.Create;

            For lCont := 0 To AttPathNames.Count - 1 Do
              If Trim(AttPathNames[lCont]) <> '' Then
                If _ValidExtension(Trim(AttPathNames[lCont])) Then
                  lAtta.Add(Trim(AttPathNames[lCont]));

            {add to the list to be picked up later}
            lIndex := fMailProcess.Add(lMsgBody);
            Try
              Receive(Subject, IfThen(Originator = '', OrigAddress, Originator),
                Recipient.Text, lAtta);
            Except
              On e: exception Do
              Begin
                _LogMSG('TDSRMailPoll.GotMessage :- Error receiving SIMPLEMAPI message. Error: '
                  + e.Message);
                {if something happened, remove message from the list to be processed later}
                If lIndex > 0 Then
                Try
                  If fMailProcess.Count > 0 Then
                    fMailProcess.Delete(lIndex);
                Except
                End; {try}
              End; {begin}
            End; {try}

            If Assigned(lAtta) Then
              FreeAndNil(lAtta);
          End; {If IsValidDSRMail(lMsgBody) Then}
        End; {With EmailS Do}
      End; {If Assigned(EmailS) Then}

    emlSMTP
      :
      If Assigned(msPop1) And Assigned(msPop1.MailMessage) Then
      Begin
        With msPop1.MailMessage, TDSRReceive Do
        Try
          Try
            lMsgBody := Trim(Body.Text);
          Except
          End;

          {check if this is a valid dsr e-mail}
          If IsValidDSRMail(lMsgBody) Then
          Try
            {delete  test message}
            If Trim(lowercase(Subject)) = cCLIENTSYNCEMAILTEST Then
            Begin
              Try
                msPOP1.Delete;
              Except
              End;
            End
            Else
            Begin

            {add to the list to be picked up later}
              lIndex := fMailProcess.Add(lMsgBody);

              lRec := TStringList.Create;
              lAtta := TStringList.Create;

            {load recipients to a list }
              If Assigned(Recipients) Then
                For lCont := 0 To Recipients.Count - 1 Do
                  lRec.Add(Recipients[lCont].Address);

              lDir := IncludeTrailingPathDelimiter(_GetApplicationPath + cTEMPDIR);
              Try
                ForceDirectories(lDir);
              Except
              End;

            {create a list of attachments to be processed}
              lAtta.CommaText := CreateSMTPPOP3ValidFile(msPOP1.MailMessage, True);
              lFilename := '';
              FillChar(lDSRHeader, SizeOF(TDSRFileHeader), 0);
            {process the attachements}
              Try
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
                    Receive(Subject, Sender.Address, lRec.Text, lAtta);
                End
                Else
                  Receive(Subject, Sender.Address, lRec.Text, lAtta);

              {get a valid file for checking if batch is completed}
              //lFileName := CreateSMTPPOP3ValidFile(msPop1.MailMessage);
                If (lFileName <> '') And (_FileSize(lFileName) > 0) Then
                Begin
                  fFile.Add(lFilename);
                  msPOP1.Delete;
                End; {if (lFileName <> '') and (_FileSize(lFileName) > 0) then}
              Except
                On E: Exception Do
                Begin
                  _LogMSG('TDSRMailPoll.GotMessage :- Error receiving SMTP message. Error: '
                    + e.Message);

                {if something happened, remove message from the list to be processed later}
                  If lIndex > 0 Then
                  Try
                    If fMailProcess.Count > 0 Then
                      fMailProcess.Delete(lIndex);
                  Except
                  End; {try}
                End; {begin}
              End; {try}

              DeleteAttach(lAtta, lFileName);
            End; {else begin  test message}
          Finally
            If Assigned(lRec) Then
              FreeAndNil(lRec);
            If Assigned(lAtta) Then
              FreeAndNil(lAtta);
          End {If IsValidDSRMail(lMsgBody) Then}
          Else
          Begin
            If fSystem.DeleteNonDSR Then
            Begin
              _LogMSG('TDSRMailPoll.ProcessMAPIEmails :- Invalid E-Mail. Subject: '
                + msPop1.MailMessage.Subject);
              msPOP1.Delete;
            End;
          End;
        Except
          On e: exception Do
            _LogMsg('TDSRMailPoll.GotMessage :- The following exception occurred whilst reading the messages:'
              + e.Message);
        End; {try}

        If Assigned(lRec) Then
          FreeAndNil(lRec);
        If Assigned(lAtta) Then
          FreeAndNil(lAtta);
      End; {If Assigned(msPop1) Then}
  End; {case}
End;

{-----------------------------------------------------------------------------
  Procedure: ReceiveSMTPPOP3
  Author:    vmoura
-----------------------------------------------------------------------------}
(*Function TDSRMailPoll.ReceiveSMTPPOP3(pMailMessage: TmsMessage): Longword;
Var
  lRec, lAtta: TStringList;
  lMsgBody, lDir, lSender,
    lFileName: String;
  lIndex,
    lCont: Integer;
  lStream: TFileStream;
Begin
  Result := S_FALSE;
  If Assigned(pMailMessage) Then
  Begin
    With pMailMessage, TDSRReceive Do
    Try
      Try
        lMsgBody := Trim(Body.Text);
      Except
      End;

      {check if this is a valid dsr e-mail}
      If IsValidDSRMail(lMsgBody) Then
      Try
        {add to the list to be picked up later}
        lIndex := fMailProcess.Add(lMsgBody);

        lRec := TStringList.Create;
        lAtta := TStringList.Create;

        {load recipients to a list }
        If Assigned(Recipients) Then
          For lCont := 0 To Recipients.Count - 1 Do
            lRec.Add(Recipients[lCont].Address);

        lDir := IncludeTrailingPathDelimiter(_GetApplicationPath + cTEMPDIR);
        Try
          ForceDirectories(lDir);
        Except
        End;

        lAtta.CommaText := CreateSMTPPOP3ValidFile(pMailMessage, True);
        {process the attachements}
        Try
          Result := Receive(Subject, Sender.Address, lRec.Text, lAtta.CommaText);
        Except
          On e: exception Do
          Begin
            Result := S_FALSE;
            _LogMSG('TDSRMailPoll.GotMessage :- Error receiving SMTP message. Error: '
              + e.Message);

            {if something happened, remove message from the list to be processed later}
            If lIndex > 0 Then
            Try
              If fMailProcess.Count > 0 Then
                fMailProcess.Delete(lIndex);
            Except
            End; {try}
          End; {begin}
        End; {try}

        DeleteAttach(lAtta);
      Finally
        If Assigned(lRec) Then
          FreeAndNil(lRec);
        If Assigned(lAtta) Then
          FreeAndNil(lAtta);
      End; {If IsValidDSRMail(lMsgBody) Then}
    Except
      On e: exception Do
      Begin
        _LogMsg('TDSRMailPoll.GotMessage :- The following exception occurred whilst reading the messages:'
          + e.Message);
        Result := S_FALSE;
      End;
    End; {try}

    If Assigned(lRec) Then
      FreeAndNil(lRec);
    If Assigned(lAtta) Then
      FreeAndNil(lAtta);
  End; {If Assigned(msPop1) Then}
End;*)

{-----------------------------------------------------------------------------
  Procedure: ProcessMAPIEmails
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.ProcessMAPIEmails;
Var
  latta: TStringList;
  lCont: Integer;
  lRes: Integer;
  lMsgBody,
    lFile: String;
Begin { DownLoadEmails }

  Try { Finally }
    If Assigned(Email1) Then
    Try { Except }
{$IFDEF DEBUG}
      Email1.InService := False;
{$ELSE}
      //Email1.InService := true;
      Email1.InService := False;
{$ENDIF}

      Email1.UseDefProfile := True;
      Email1.LeaveUnread := False;

      Try
        lRes := Email1.Logon;
      Except
        On e: exception Do
        Begin
          lRes := -1;
          _LogMSG('TDSRMailPoll.ProcessMAPIEmails :- Logon error: ' +
            e.Message);
        End;
      End;

      If Not lRes In [0, 9] Then
        _LogMSG('Error MAPI logon. Error: ' + inttostr(lRes));

      { Download all Message ID's into local list }
      Try
        lRes := Email1.GetFirstUnread;
      Except
        On e: exception Do
        Begin
          lRes := -1;
          _LogMSG('TDSRMailPoll.ProcessMAPIEmails :- Get next unread message. Error: '
            + e.Message);
        End;
      End;

      If Not lRes In [0, 9] Then
        _LogMSG('Error downloading MAPI E-Mails. Error: ' + inttostr(lRes));

      { Process downloaded messages -have to do this way otherwise positioning }
      { is lost in message queue and it starts looping, etc...                 }
      While (lRes = 0) And (Not WantToClose) Do
      Begin

        With Email1 Do
        Begin
          lMsgBody := '';
          Try
            lMsgBody := Trim(GetLongText);
          Except
          End;

          If IsValidDSRMail(lMsgBody) Then
          Begin
            {get only mails that have been processed before}
            If fMailProcess.IndexOf(lMsgBody) >= 0 Then
          {only process mails with attachments}
              {If Attachment.Count > 0 Then}
            Begin
              Try
                lFile := GetFirstValidAttach;

                If _FileSize(lFile) > 0 Then
                  ProcessFile(lFile);
                    //SetMessageAsRead;

                lAtta := TStringList.Create;
                For lCont := 0 To Attachment.Count - 1 Do
                  lAtta.Add(Attachment[lCont]);

                DeleteAttach(lAtta);
                FreeAndNil(lAtta);

                Try
                  DeleteMessage;
                Except
                  On e: exception Do
                    _LogMSG('TDSRMailPoll.ProcessMAPIEmails :- Error deleting MAPI e-mail. Error: '
                      + e.message);
                End;
              Except
              End;
            End;
          End {If IsValidDSRMail(Trim(GetLongText)) Then}
          Else
          Begin
            Try
              If fSystem.DeleteNonDSR Then
              Begin
                _LogMSG('TDSRMailPoll.ProcessMAPIEmails :- Invalid E-Mail. Subject: '
                  + email1.Subject);
                DeleteMessage;
              End;
            Except
              On e: exception Do
                _LogMSG('TDSRMailPoll.ProcessMAPIEmails :- Error deleting MAPI e-mail. Error: '
                  + e.message);
            End;
          End; {begin}
        End; { With Email1 }

        Try
          lRes := Email1.GetNextUnread;
        Except
          On E: exception Do
          Begin
            lRes := -1;
            _LogMSG('TDSRMailPoll.ProcessMAPIEmails :- Get next unread message. Error: '
              + e.Message);
          End;
        End;
      End; { While (lRes = 0) }
    Except
      On Ex: Exception Do
        _LogMsg('TDSRMailPoll.ProcessMAPIEmails :- The following exception occurred whilst reading the messages: '
          + Ex.Message);
    End;
  Finally
    If Assigned(Email1) Then
    Begin
      If fSystem.DeleteNonDSR Then
      Try
        Email1.DeleteReadMessages;
      Except
      End;

      Try
        Email1.Logoff;
      Except
      End;
    End; {If Assigned(Email1) Then}
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessPOP3Emails
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.ProcessPOP3Emails;
Var
  lFileProcess: TStringlist;
  lRetrOK: Boolean;
  I: LongInt;
  lMsgBody,
    lFile: String;
  lLogin: Boolean;
  lMsgId: String;
Begin { DownloadPOP3Emails }

(*
  lFileProcess := TStringlist.Create;

  Try { Except }
    If Assigned(lPOP) Then
      With lPOP Do
      Try
        _CallDebugLog('TDSRMailPoll.ProcessPOP3Emails disconnect');

        Host := POP3Server;
        UserName := POP3UserName;
        Password := POP3PassWord;
        Port := POP3Port;

        _CallDebugLog('TDSRMailPoll.ProcessPOP3Emails Login');
        Try
          Login;
          lLogin := True;
        Except
          On e: exception Do
          Begin
            fLog.DoLogMessage('TDSRMailPoll.ProcessPOP3Emails', 0,
              'POP3 login error. User: ' + Pop3UserName +
              ' Server: ' + Pop3Server +
              ' Error: ' + e.message);
            lLogin := False;
          End; {begin}
        End; {try}

      { Download all messages }
        If lLogin Then
        Begin
          For I := 0 To Pred(TotalMessages) Do
          Begin
            CurrentMessage := i;

            lRetrOK := True;

            {if something goes wrong, load everything again and process in the slowly way...}
            Try
              If Not lPOP.ConnectionReset Then
              Begin
                try
                  Retrieve;
                except
                  lRetrOK := False;
                end;
              End; {If Not lPOP.ConnectionReset Then}
            Except
              On e: exception Do
              Begin
                fLog.DoLogMessage('TDSRMailPoll.ProcessPOP3Emails', 0,
                  'Error retrieving E-Mail. Error: ' + e.message);
                lRetrOK := False;
                Break;
              End; {begin}
            End; {try}

            If lRetrOK And Assigned(MailMessage) Then
            Begin
              With MailMessage Do
              Begin
                lMsgBody := '';
                Try
                  If Assigned(MailMessage) Then
                    lMsgBody := Trim(Body.Text);
                Except
                End;

                {check for dsr valid mail}
                If IsValidDSRMail(lMsgBody) Then
                Begin
                  Try
                    {get only mails that have been processed before}
                    If fMailProcess.IndexOf(lMsgBody) >= 0 Then
                    Begin
                      Try
                        //lFile := GetFirstValidAttach;
                        lFile := CreateSMTPPOP3ValidFile(MailMessage);

                        If lFile <> '' Then
                          lFileProcess.Add(lFile);

                        Try
                          If Not lPOP.ConnectionReset Then
                            lPOP.Delete;
                        Except
                          On e: exception Do
                            fLog.DoLogMessage('TDSRMailPoll.ProcessPOP3Emails',
                              0, 'Error deleting E-Mail. Error: ' + e.message);
                        End;
                      Except
                        On e: exception Do
                          fLog.DoLogMessage('TDSRMailPoll.ProcessPOP3Emails', 0,
                            'Error processing file. Error: ' + e.message);
                      End;
                    End; {If fMailProcess.IndexOf(lMsgBody) >= 0 Then}
                  Except
                  End;
                End {If IsValidDSRMail(Trim(Body.Text)) Then}
                Else
                Begin
                  Try
                    {if non related dsr mail...}
                    If fSystem.DeleteNonDSR Then
                      If Not lPOP.ConnectionReset Then
                        lPOP.Delete;
                  Except
                    On e: exception Do
                      fLog.DoLogMessage('TDSRMailPoll.ProcessPOP3Emails', 0,
                        'Error deleting E-Mail. Error: ' + e.message);
                  End; {try}
                End; {begin}
              End; { With Msg }
            End {If lRetrOK Then}
            Else
              Break;

            Sleep(1);
          End; { For I := Pred(lTotal) Downto 0 Do }
        End; {If Online Then}
      Except
        On Ex: Exception Do
          _LogMsg('TDSRMailPoll.ProcessPOP3Emails :- The following exception occurred whilst reading the messages:'
            + Ex.Message);
      End;
  Finally
    SMTPLogOff;

    _CallDebugLog('TDSRMailPoll.ProcessPOP3Emails Logout');
  End;

  {clear mail message object}
  If Assigned(lMessage) Then
  Begin
    FreeAndNil(lMessage);
    If Assigned(lPop) Then
      lPop.MailMessage := Nil;
  End; {If Assigned(lMessage) Then}

  If Assigned(lPop) Then
    FreeAndNil(lPop);

  {give "plenty" of time to logoff}
  Sleep(500);

  {process files that has been downloaded}
  If Assigned(lFileProcess) Then
  Begin
    If lFileProcess.Count > 0 Then
      For i := 0 To lFileProcess.Count - 1 Do
      Begin
        Try
          ProcessFile(lFileProcess[I]);
        Except
          On e: exception Do
            _LogMSG('TDSRMailPoll.ProcessPOP3Emails :- Error processing file. Error: '
              + e.Message);
        End; {try}
      End; {For i := 0 To lFileProcess.Count - 1 Do}

    FreeAndNil(lFileProcess);
  End; {if Assigned(lFileProcess) then}*)

  If Assigned(fFile) Then
  Begin
    If fFile.Count > 0 Then
      For i := 0 To fFile.Count - 1 Do
      Begin
        Try
          ProcessFile(fFile[I]);
        Except
          On e: exception Do
            _LogMSG('TDSRMailPoll.ProcessPOP3Emails :- Error processing file. Error: '
              + e.Message);
        End; {try}
      End; {For i := 0 To lFileProcess.Count - 1 Do}
  End; {if Assigned(lFileProcess) then}
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessSimpleMAPIEmails
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.ProcessSimpleMAPIEmails;
Var
  lProcessFile,
    lAtta,
    Messages: TStringList;
  lCont,
    lCont1: Integer;
  lMsgBody,
    lFile: String;
Begin { DownLoadEmails }
  { Create list to store Message ID's in }
  Messages := TStringList.Create;
  lProcessFile := TStringList.Create;
  lAtta := TStringList.Create;

  Try { Finally }
    If Assigned(EmailS) Then
    Try { Except }
      _CallDebugLog('ProcessSimpleMAPIEmails');

      EmailS.UnreadOnly := False;
      EmailS.UseDefProfile := True;
      EmailS.LeaveUnread := False;

      EmailS.Logon;

      _CallDebugLog('ProcessSimpleMAPIEmails :- Logon');

      { Download all Message ID's into local list }
      EmailS.GetNextMessageId;

      While (Length(EmailS.MessageId) <> 0) And (Not WantToClose) Do
      Begin
        Messages.Add(EmailS.MessageId);
        EmailS.GetNextMessageID;
      End; { While (Length(EmailS.MessageId) <> 0) }

      { Process downloaded messages -have to do this way otherwise positioning }
      { is lost in message queue and it starts looping, etc...                 }
      While (Messages.Count > 0) And (Not WantToClose) Do
      Begin
        _LogMsg('ProcessSimpleMAPIEmails :- Start loop');

        With EmailS Do
        Begin
          _LogMsg('ProcessSimpleMAPIEmails :- set msg id ' + Messages[0]);

          { Set Message ID from list }
          MessageId := Messages[0];

          Try
            ReadMail;
          Except
          End;

          _LogMsg('ProcessSimpleMAPIEmails :- read email');

          lMsgBody := '';
          Try
            lMsgBody := Trim(GetLongText);
          Except
          End;

          If IsValidDSRMail(lMsgBody) Then
          Begin
            If fMailProcess.IndexOf(lMsgBody) >= 0 Then
              (*If AttPathNames.Count > 0 Then*)
            Begin
              Try
                lFile := GetFirstValidAttach;

                _CallDebugLog('ProcessSimpleMAPIEmails :- Process file ' +
                  lFile);

                If _FileSize(lFile) > 0 Then
                  lProcessFile.Add(lFile);

                For lCont1 := 0 To AttPathNames.Count - 1 Do
                  lAtta.Add(AttPathNames[lCont1]);

                Try
                  DeleteMail;
                Except
                  On E: exception Do
                    _LogMSG('Error deleting Simple Mapi e-mail. Error: ' +
                      e.Message);
                End;
              Except
              End;
            End; {If Attachment.Count > 0 Then}

          End {If IsValidDSRMail(Trim(GetLongText)) Then}
          Else
          Begin
            Try
              If fSystem.DeleteNonDSR Then
              Begin
                _LogMSG('TDSRMailPoll.ProcessMAPIEmails :- Invalid E-Mail. Subject: '
                  + emails.Subject);
                DeleteMail;
              End;
            Except
              On E: exception Do
                _LogMSG('Error deleting Simple Mapi e-mail. Error: ' +
                  e.Message);
            End; {try}
          End; {begin}
        End; { With Email1 }

        { Remove Message ID from list }
        If Messages.Count > 0 Then
          Messages.Delete(0);

        _LogMsg('ProcessSimpleMAPIEmails :- End loop');

      End; { While (Messages.Count > 0) }
    Except
      On Ex: Exception Do
        _LogMsg('TDSRMailPoll.ProcessSimpleMAPIEmails :- The following exception occurred whilst reading the messages:'
          + Ex.Message);
    End;
  Finally
    If Assigned(EmailS) Then
    Try
      EmailS.Logoff;
    Except
    End;
  End;

  Sleep(500);

  If Assigned(Messages) Then
    FreeAndNil(Messages);

  If Assigned(lProcessFile) Then
  Begin
    If lProcessFile.Count > 0 Then
      For lCont := 0 To lProcessFile.Count - 1 Do
        If _FileSize(lProcessFile[lCont]) > 0 Then
          ProcessFile(lProcessFile[lCont]);

    FreeAndNil(lProcessFile);
  End; {If Assigned(lProcessFile) Then}

  If lAtta.Count > 0 Then
    DeleteAttach(lAtta);

  If Assigned(lAtta) Then
    FreeAndNil(lAtta);
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
                        TDSRMail.SendMsg(lMail.From, lMail.To_, lMail.Subject,
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
  Procedure: GetFirstValidAttach
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRMailPoll.GetFirstValidAttach: String;
Var
  lFiles: TStringList;
  lDir,
    lFileName: String;
  lDSRHeader: TDSRFileHeader;
  lCont: Integer;
Begin
  Result := '';
  lFiles := TStringList.Create;

  _CallDebugLog('GetFirstValidAttach');

  {mapi previous save its file into disk.
  smptp/pop use memory stream to work with}
  Case EmailType Of
    emlMAPI:
      If Assigned(Email1) Then
      Begin
        For lCont := 0 To Email1.Attachment.Count - 1 Do
          If _ValidExtension(Email1.Attachment[lCont]) Then
            lFiles.Add(Email1.Attachment[lCont])
      End
      Else If Assigned(EmailS) Then
      Begin
        For lCont := 0 To Emails.AttPathNames.Count - 1 Do
          If _ValidExtension(EmailS.AttPathNames[lCont]) Then
            lFiles.Add(EmailS.AttPathNames[lCont])
      End;
    emlSMTP
      :
      If Assigned(msPop1) And Assigned(msPop1.MailMessage) Then
        lFiles.CommaText := CreateSMTPPOP3ValidFile(msPop1.MailMessage);
        (*With msPop1.MailMessage Do
        Begin
          lDir := IncludeTrailingPathDelimiter(_GetApplicationPath + cTEMPDIR);
          Try
            ForceDirectories(lDir);
          Except
          End;

          For lCont := 0 To Attachments.Count - 1 Do
          Begin
            lFileName := '';

            If Assigned(Attachments.Items[lCont]) Then
              With Attachments.Items[lCont] Do
              Begin
                lFileName := lDir + ExtractFileName(FileName);

                Try
                  SavePOP3Attach(Contents, lFileName);
                Except
                End;
              End; {With Attachments.Items[lCont] Do}

            {i am not going to save all files because i just need one valid}
            If (lFileName <> '') And (_FileSize(lFileName) > 0) Then
            Begin
              If _ValidExtension(lFilename) Then
                lFiles.Add(lFileName)
              Else If lowercase(ExtractFileExt(lFilename)) = '.eml' Then
                ProcessEmlFile(lFiles, lFileName);
            End; {If (lFileName <> '') And (_FileSize(lFileName) > 0) Then}
          End; {For lCont := 0 To Attachments.Count - 1 Do}
        End; {With msPop1.MailMessage Do}*)
  End; {case}

  Result := GetFirstAttach(lFiles);

  (*If lFiles.Count > 0 Then
    For lCont := 0 To lFiles.Count - 1 Do
      If _FileSize(lFiles[lCont]) > 0 Then
      Begin
        {verify the file extenstion}
        If _ValidExtension(lFiles[lCont]) Then
        Begin
          FillChar(lDSRHeader, SizeOF(TDSRFileHeader), 0);
          _GetHeaderFromFile(lDSRHeader, lFiles[lCont]);

        { verify header details}
          If _IsValidGuid(lDSRHeader.BatchId) And (lDSRHeader.Total > 0) And
            _IsValidDSRVersion(lDSRHeader.Version, cDSRVERSION) Then
          Begin
            Result := lFiles[lCont];
            Break;
          End
          Else
            _LogMSG('TDSRMailPoll.GetFirstValidAttach :- No valid file found...');

        End; {If (lFileExt = cXMLEXT) Or}
      End; {For lCont := 0 To lFiles.Count - 1 Do}*)

  _CallDebugLog('The attach is ' + Result);

  If EmailType = emlSMTP Then
    DeleteAttach(lFiles, Result);

  FreeAndNil(lFiles);
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
              _IsValidDSRVersion(lDSRHeader.Version, cDSRVERSION) Then
            Begin
              Result := pList[lCont];
              Break;
            End
          End; {If (lFileExt = cXMLEXT) Or}
        End; {For lCont := 0 To lFiles.Count - 1 Do}
End;

{-----------------------------------------------------------------------------
  Procedure: CreateSMTPPOP3ValidFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRMailPoll.CreateSMTPPOP3ValidFile(pMailMessage: TmsMessage; Const
  pGetAll: Boolean = False): String;
Var
  lFiles: TStringList;
  lDir,
    lFileName: String;
  lCont: Integer;
Begin
  If Assigned(pMailMessage) Then
    With pMailMessage Do
    Try
      lFiles := TStringList.Create;

      lDir := IncludeTrailingPathDelimiter(_GetApplicationPath + cTEMPDIR);
      Try
        ForceDirectories(lDir);
      Except
      End;

      {extract xmls from mail file}
      For lCont := 0 To Attachments.Count - 1 Do
      Begin
        lFileName := '';

        If Assigned(Attachments.Items[lCont]) Then
          With Attachments.Items[lCont] Do
          Begin
            lFileName := lDir + ExtractFileName(FileName);

            Try
              SavePOP3Attach(Contents, lFileName);
            Except
            End;
          End; {With Attachments.Items[lCont] Do}

        {i am not going to save all files because i just need one valid}
        If (lFileName <> '') And (_FileSize(lFileName) > 0) Then
        Begin
          If _ValidExtension(lFilename) Then
          Begin
            lFiles.Add(lFileName);

            {load all files to the list }
            If Not pGetAll Then
            Begin
            {stop the process if the first file is already a valid one}
              lFileName := GetFirstAttach(lFiles);
              If (lFileName <> '') And (_FileSize(lFileName) > 0) Then
                Break;
            End; {If Not pGetAll Then}
          End
          Else If lowercase(ExtractFileExt(lFilename)) = '.eml' Then
            ProcessEmlFile(lFiles, lFileName);
        End; {If (lFileName <> '') And (_FileSize(lFileName) > 0) Then}
      End; {For lCont := 0 To Attachments.Count - 1 Do}

      Result := lFiles.CommaText;
    Finally
      If Assigned(lFiles) Then
        lFiles.Free;
    End; {With msPop1.MailMessage Do}
End;

{-----------------------------------------------------------------------------
  Procedure: LogError
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.LogError(Const pMsg: ShortString);
Begin
  _LogMSG('Internal MAIL error : ' + pMsg);
End;

{-----------------------------------------------------------------------------
  Procedure: GetSmtpOnline
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRMailPoll.GetSmtpOnline: Boolean;
Begin
  Result := False;
  Try
    If Assigned(msPOP1) Then
      Result := msPOP1.Online;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SMTPLogOff
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRMailPoll.SMTPLogOff;
Begin
  If SmtpOnline Then
    If Assigned(msPOP1) Then
    Begin
      Try
        msPOP1.Logout;
      Except
        Try
          msPOP1.Disconnect;
        Except
        End;
      End;
    End; {If Assigned(msPOP1) Then}
End;

End.

