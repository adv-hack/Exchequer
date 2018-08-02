{-----------------------------------------------------------------------------
 Unit Name: uDSRSend
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDSRSend;

Interface

Uses Windows, Sysutils, uConsts;

Type
  TDSRSend = Class
  Public
    Class Function Send(Const pUserFrom, pUserTo, pSubject, pBody, pFiles:
      String; Const pHost: String = ''; Const pPort: Integer = cSMTPDEFAULTPORT):
      Longword;
  End;

Implementation

Uses Classes, uSystemConfig,
  emailfax, COMMSINT,
  uCommon

  ;

{ TSend }

{-----------------------------------------------------------------------------
  Procedure: Send
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSRSend.Send(Const pUserFrom, pUserTo, pSubject, pBody,
  pFiles: String; Const pHost: String = ''; Const pPort: Integer =
    cSMTPDEFAULTPORT): Longword;
Var
  lSystem: TSystemConf;
  lTo: TStringlist;
  lIndex: integer;
  lMail: EmailInfoType;
  lText: pChar;
  lError: integer;
  lCryptMsg: String;
Begin
  Result := S_OK;
  lSystem := TSystemConf.Create;
  lTo := TStringList.Create;
  _strTokenToStrings(Trim(pUserto), ';', lTo);

  lIndex := 0;
  Try
    lIndex := lTo.IndexOf(pUserFrom);
  Except
  End;

  _CallDebugLog('TDSRSend.Send :- Sending e-mail to : ' + lTo.CommaText);

  {avoid to send an e-mail to same user from}
  If lIndex > 0 Then
    lTo.Delete(lIndex);

  If lTo.Count > 0 Then
  Begin
    FillChar(lMail, SizeOf(lMail), #0);
    Try
      {the message body will indicate to the destination that this is an
      ice e-mail }

      If Trim(pBody) = '' Then
        lCryptMsg := cPIPE + GUIDToString(_CreateGuid) + cPIPE
      Else
        lCryptMsg := pBody;

      lText := StrNew(pChar(lCryptMsg));

      With lMail Do
      Begin
        emSuppressMessages := True;
        If lSystem.UseMapi Then
        Begin
          emUseMAPI := True;
          emSMTPServer := '';
        End
        Else
        Begin
          emUseMAPI := False;
          if Trim(pHost) = '' then
            emSMTPServer := lSystem.DefaultSMTPServer
          else
            emSMTPServer := pHost;

          emPort := lSystem.DefaultSMTPPort;
        End; {begin}

        emPriority := 1;
        emSender := Trim(pUserFrom);
        emTo := TStringList.Create;
        emAttachments := TStringList.Create;
        emCC := TStringList.Create;
        emBCC := TStringList.Create;
        emHeaders := TStringList.Create;
        Emto.CommaText := lTo.CommaText;
        emSubject := Trim(pSubject);
        emAttachments.CommaText := pFiles;
        emTextPChar := lText;
      End; {With lMail Do}

      lError := ECSENDEMAIL(lMail);

      If lError <> 0 Then
      Begin
        _LogMsg('TDSRSend.Send :- Error sending mail: ' + inttostr(lError) +
          ' Description: ' + ErrString);
        _LogMsg('TDSRSend.Send :- From ' + pUserFrom + ' to ' + pUserTo);
        Result := cError;
      End; {If lError <> 0 Then}

      With lMail Do
      Begin
        If Assigned(emCC) Then
          FreeAndNil(emCC);

        If Assigned(emBCC) Then
          FreeAndNil(emBCC);

        If Assigned(emHeaders) Then
          FreeAndNil(emHeaders);

        If Assigned(emTo) Then
          FreeAndNil(emTo);

        If Assigned(emAttachments) Then
          FreeAndNil(emAttachments);
      End; {With lMail Do}

      Try
        StrDispose(lText);
      Except
      End;
    Except
      On e: exception Do
      Begin
        Result := cERROR;
        _LogMsg('TDSRSend.Send :- General error sending mail. Error: ' +
          e.message);
      End; {begin}
    End; {try}
  End
  Else
  Begin
    Result := cERROR;
    _LogMsg('TDSRSend.Send :- No user added to send mail subject : ' +
      pSubject);
    If lIndex > 0 Then
      _LogMsg('TDSRSend.Send :- Trying to send email from: ' + pUserFrom +
        ' to: ' + pUserTo);
  End;

  FreeAndNil(lTo);
  FreeAndNil(lSystem);

  _CallDebugLog('TDSRSend.Send :- finish Sending e-mail');
End;

End.

