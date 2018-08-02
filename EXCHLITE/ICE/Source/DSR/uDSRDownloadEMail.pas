{-----------------------------------------------------------------------------
 Unit Name: uDSRDownloadEMail
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDSRDownloadEMail;

Interface

Uses Classes, Sysutils;

Type
  {thread for calling the email com object}
  TDSRDownloadMail = Class(TThread)
  Private
    Procedure CheckMailList;
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End;

  TDSRDownload = Class
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Download;
  End;

Implementation

Uses Windows, ComObj, Activex,
  uCommon, uBaseClass, DSRIncoming_TLB, uDSRSettings, uInterfaces,
  uConsts, uAdoDSR;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRDownloadMail.Create;
Begin
  Inherited Create(True);
  FreeOnTerminate := True;
  Priority := tpLower;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRDownloadMail.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRDownloadMail.Execute;
Const
  cKey = '{9C7591AC-5254-4F08-B456-EADB04263ED7}';
Var
  lMutex,
    ltargettime: Cardinal;
Begin
  ltargettime := GetTickCount + 5000;

  {check for how long the thread will try to download the message}
  While (ltargettime > GetTickCount) And Not Terminated Do
  Begin
    lMutex := OpenMutex(MUTEX_MODIFY_STATE, false, cKey);

    {test if there is more than one thread trying to download the e-mails}
    If lMutex <> 0 Then
    Begin
      CloseHandle(lMutex);
      Sleep(1000);
    End
    Else
    Begin
      {create the mutex}
      lMutex := CreateMutex(Nil, false, cKey);
      {get the object to itself}
      WaitForSingleObject(lMutex, INFINITE);

      Try
        CheckMailList;
      Except
        On e: exception Do
        Begin
          _LogMSG('TDSRDownloadMail.Execute :- Error downloading e-mails. Error: ' +
            e.Message);
          Terminate;
        End; {begin}
      End; {try}

      {finish the loop and release the mutex}
      CloseHandle(lMutex);
      Terminate;
    End; {begin}
  End; {While (ltargettime > GetTickCount) And Not lExec Do}

  Terminate;
End;

{-----------------------------------------------------------------------------
  Procedure: CheckMailList
  Author:    vmoura
-----------------------------------------------------------------------------}
(*Procedure TDSRDownloadMail.CheckMailList;
Var
  lCont: Integer;
  lMailPoll: IDSRIncomingSystem;
  lSystem: TSystemConf;
  lLog: _Base;
Begin
  CoInitialize(Nil);

  _CallDebugLog('CheckMail :- ' + DateTimeToStr(Now));
  lSystem := TSystemConf.Create;
  lLog := _Base.Create;
  lLog.ConnectionString := _DSRFormatConnectionString(_DSRGetDBServer);

  Try
    If _IsValidGuid(lSystem.IncomingGuid) Then
      lMailPoll := CreateComObject(Stringtoguid(lSystem.IncomingGuid)) As
        IDSRIncomingSystem
    Else
    Begin
      _LogMSG('TDSRCheckMail.CheckMailList :- Invalid Incoming COM object Guid "' +
        lSystem.IncomingGuid + '"');
      lLog.DoLogMessage('TDSRDownloadMail.CheckMailList', cINVALIDGUID,
        'Invalid Incoming COM Object Guid "' + lSystem.IncomingGuid + '"', True, True);
    End;
  Except
    On e: exception Do
      lLog.DoLogMessage('TDSRChekMail.CheckMailList', cERROR,
        'Error creating incoming object. Error: ' + e.Message, True, True);
  End; {try}

  {check incoming availability}
  If Assigned(lMailPoll) Then
  Try
    If lSystem.UseMapi Then
    Begin
      //TEmailType = (emlMAPI, emlSMTP);
      lMailPoll.EmailType := 0;
      Try
        lMailPoll.CheckNow;
      Except
        On e: Exception Do
          lLog.DoLogMessage('TDSRChekMail.CheckMailList', cMAILPARAMERROR,
            'Error checking E-Mail using mapi. Error: ' + e.Message, True, True);
      End;
    End {If fSystemConf.UseMapi Then}
    Else
    Begin
      Try
        //TEmailType = (emlMAPI, emlSMTP);
        lMailPoll.EmailType := 1;

        {load the pop3 list to check}
        lSystem.LoadPop3List;

        For lCont := 0 To lSystem.POP3.Count - 1 Do
        Try
          lMailPoll.POP3Server := lSystem.POP3[lCont].POP3Server;
          lMailPoll.Username := lSystem.POP3[lCont].UserName;
          lMailPoll.Password := lSystem.POP3[lCont].VisiblePass;
          lMailPoll.POPAddress := lSystem.POP3[lCont].PopAddress;
          lMailPoll.POP3Port := lSystem.POP3[lCont].POP3Port;
          lMailPoll.CheckNow;
        Except
          On e: Exception Do
            lLog.DoLogMessage('TDSRChekMail.CheckMailList', cMAILPARAMERROR,
              'Error checking E-Mmail. Error: ' + e.Message, True, True);
        End;
      Except
        On e: Exception Do
          lLog.DoLogMessage('TDSRChekMail.CheckMailList', cMAILPARAMERROR,
            'Error checking E-Mail. Error: ' + e.Message, true, true);
      End; {For lCont := 0 To fSystemConf.POP3.Count - 1 Do}
    End; {begin}

    _Delay(500);

    {check if still running...}
    If Assigned(lMailPoll) Then
      lMailPoll := Nil;

    Try
      _DelDirFiles(lSystem.TempDir);
    Except
    End;
  Except
    On e: Exception Do
      lLog.DoLogMessage('TDSRChekMail.CheckMailList', cMAILPARAMERROR,
        'An exception has occurred checking E-Mails. Error: ' + e.Message, True,
        True);
  End; {If Assigned(lMailPoll) Then}

  If Assigned(lSystem) Then
    lSystem.Free;
  If Assigned(lLog) Then
    lLog.Free;

  CoUninitialize;
End;*)

{-----------------------------------------------------------------------------
  Procedure: CheckMailList
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRDownloadMail.CheckMailList;
Var
  lCont, lTotal: Integer;
  lDb: TADODSR;
  lResult: Longword;
  lAccs: Olevariant;
  lEAcc: TEmailAccount;
  lESystem: TEmailSystem;
  lMailPoll: IDSRIncomingSystem;
  lLog: _Base;
Begin
  CoInitialize(Nil);

  _CallDebugLog('CheckMail :- ' + DateTimeToStr(Now));
  lLog := _Base.Create;
  lLog.ConnectionString := _DSRFormatConnectionString(_DSRGetDBServer);
  lDb := Nil;
  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On e: exception Do
      lLog.DoLogMessage('TDSRChekMail.CheckMailList', cERROR,
        'Error creating Database Object. Error: ' + e.Message, True, True);
  End;

  {check db connection}
  If Assigned(lDb) Then
  Begin
    If lDb.Connected Then
    Try
      {load email accounts}
      lAccs := lDb.GetEmailAccounts(lResult);
      lTotal := _GetOlevariantArraySize(lAccs);

      If lTotal > 0 Then
      Begin
        {loop through the accounts}
        For lCont := 0 To lTotal - 1 Do
        Begin
          {retrieve email account object}
          lEAcc := _CreateEmailAccount(lAccs[lCont]);
          If lEAcc <> Nil Then
          Begin
            {retrieve which email system to use}
            lESystem := lDb.GetEmailSystemById(lEacc.EmailSystem_ID);
            If lESystem <> Nil Then
            Begin
              {create email wrapper object}
              Try
                lMailPoll := Nil;

                If _IsValidGuid(lESystem.IncomingGuid) Then
                  lMailPoll := CreateComObject(Stringtoguid(lESystem.IncomingGuid))
                    As IDSRIncomingSystem
                Else
                Begin
                  _LogMSG('TDSRCheckMail.CheckMailList :- Invalid Incoming COM object Guid "'
                    + lESystem.IncomingGuid + '"');
                  lLog.DoLogMessage('TDSRDownloadMail.CheckMailList', cINVALIDGUID,
                    'Invalid Incoming COM Object Guid "' + lESystem.IncomingGuid +
                    '"', True, True);
                End;
              Except
                On e: exception Do
                  lLog.DoLogMessage('TDSRChekMail.CheckMailList', cERROR,
                    'Error creating incoming object. Guid: ' + lESystem.IncomingGuid
                    + '. Error: ' + e.Message, True, True);
              End; {try}

              {check incoming availability}
              If Assigned(lMailPoll) Then
              Begin
                Try
                  lMailPoll.YourName := lEAcc.YourName;
                  lMailPoll.YourEmail := lEAcc.YourEmail;
                  lMailPoll.ServerType := lEAcc.ServerType;
                  lMailPoll.IncomingServer := lEAcc.IncomingServer;
                  lMailPoll.UserName := lEAcc.UserName;
                  lMailPoll.Password := lEAcc.Password;
                  lMailPoll.IncomingPort := lEAcc.IncomingPort;
                  lMailPoll.Authentication := lEAcc.Authentication Or
                    lEAcc.UseSSLIncomingPort;
                  lMailPoll.MailBoxName := lEAcc.MailBoxName;
                  lMailPoll.MailBoxSeparator := lEAcc.MailBoxSeparator;

                  Try
                    lMailPoll.CheckNow;
                  Except
                    On e: exception Do
                      lLog.DoLogMessage('TDSRChekMail.CheckMailList', cError,
                        'Error checking E-Mmail account ' + lEAcc.YourEmail +
                        '. Error: ' + e.Message, True, True);
                  End; {try}

                  _Delay(500);

                  {check if still running...}
                  If Assigned(lMailPoll) Then
                    lMailPoll := Nil;

                  _DeleteTempFiles;
                Except
                  On e: Exception Do
                    lLog.DoLogMessage('TDSRChekMail.CheckMailList', cMAILPARAMERROR,
                      'An exception has occurred checking E-Mails. Error: ' +
                      e.Message, True,
                      True);
                End; {If Assigned(lMailPoll) Then}
              End; {If Assigned(lMailPoll) Then}

              FreeAndNil(lESystem);
            End
            Else
              lLog.DoLogMessage('TDSRChekMail.CheckMailList', cERROR,
                'E-Mail Server Type not found. Id: ' + inttostr(lEAcc.EmailSystem_ID)
                + ' Account: ' + lEAcc.YourEmail, True, True);

            FreeAndNil(lEAcc);
          End; {if lEAcc <> nil then}
        End; {for lCont:= 0 to lTotal - 1 do}
      End {if lTotal > 0 then}
      Else
        lLog.DoLogMessage('TDSRChekMail.CheckMailList', cERROR,
          'No E-Mail accounts to check...', True, True);
    Finally
      If Assigned(lDb) Then
        lDb.Free;
    End
    Else
      lLog.DoLogMessage('TDSRChekMail.CheckMailList', cCONNECTINGDBERROR,
        'Database connection Failed. Server: ' + _DSRGetDBServer, True, True);
  End
  Else
    lLog.DoLogMessage('TDSRChekMail.CheckMailList', cASSIGINGOBJECTERROR,
      'Error creating Database Object. Server: ' + _DSRGetDBServer, True, True);

  If Assigned(lLog) Then
    lLog.Free;

  CoUninitialize;
End;

{ TDSRDownload }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRDownload.Create;
Begin
  Inherited Create;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRDownload.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: Download
  Author:    vmoura

  this functions only creates the thread for download the e-mail from the server...
-----------------------------------------------------------------------------}
Procedure TDSRDownload.Download;
Var
  lDown: TDSRDownloadMail;
Begin
  lDown := TDSRDownloadMail.Create;
  lDown.Resume;

  Repeat
    Sleep(500);
  Until lDown.Terminated;
End;

End.

