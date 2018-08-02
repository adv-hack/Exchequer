Unit uSMTP;

Interface

Uses Windows, Sysutils, Classes,
  uMailBase, uMailMessage,
  IdSMTP, IdSSLOpenSSL, IdSASLLogin, IdUserPassProvider, IdMessage, IdAttachmentFile

  ;

Const
  // at default seems to be the first option...
  cSMTPAUTH_TYPE: Array[1..3] Of TIdSMTPAuthenticationType = (atDefault, atNone,
    atSASL);

Type
  TSMTP = Class(TEmailBase)
  Private
    fSMTP: TIdSMTP;
    fAuthType: TIdSMTPAuthenticationType;

    fHandler: TIdSSLIOHandlerSocketOpenSSL;
    fLogin: TIdSASLLogin;
    fUserPass: TIdUserPassProvider;

    fSMTPLoginUser: String;
    fSMTPLoginPassword: String;
    Function GetSMTPLoginPassword: String;
    Function GetSMTPLoginUser: String;
  Protected
    Function GetConnected: Boolean; Override;
    Procedure SetConnected(Const Value: Boolean); Override;
  Public
    Constructor Create; Override;
    Destructor Destroy; Override;
    Function SendMail(pMail: TMailMessage): Boolean; Override;
  Published
    Property Host;
    Property OutgoingPort;
    Property UserName;
    Property Password;
    Property UseTLS;
    Property SSLVersion;
    Property PassThrough;
    Property UseIndySASL;
    Property Timeout;

    Property AuthType: TIdSMTPAuthenticationType Read fAuthType Write fAuthType;
    Property SMTPLoginUser: String Read GetSMTPLoginUser Write fSMTPLoginUser;
    Property SMTPLoginPassword: String Read GetSMTPLoginPassword Write
      fSMTPLoginPassword;
  End;

Implementation

Uses IdBaseComponent, IdEMailAddress;

{ TSMTP }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TSMTP.Create;
Begin
  Inherited Create;

  fSMTP := TIdSMTP.Create(Nil);

  fHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
  fHandler.ConnectTimeout := Timeout;
  fLogin := TIdSASLLogin.Create;
  fUserPass := TIdUserPassProvider.Create;
  fLogin.UserPassProvider := fUserPass;
  fAuthType := atDefault;
  UseTLS := cUSE_TLS[2];
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TSMTP.Destroy;
Begin
  If fSMTP.Connected Then
  Try
    fSMTP.Disconnect;
  Except
  End;

  fHandler.Free;
  fUserPass.Free;
  fLogin.Free;
  fSMTP.Free;

  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: GetConnected
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSMTP.GetConnected: Boolean;
Begin
  Result := False;

  Try
    Result := fSMTP.Connected;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: GetSMTPLoginPassword
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSMTP.GetSMTPLoginPassword: String;
Begin
  Result := fSMTPLoginPassword;

  If Trim(Result) = '' Then
  Begin
    fSMTPLoginPassword := Password;
    Result := fSMTPLoginPassword;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: GetSMTPLoginUser
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSMTP.GetSMTPLoginUser: String;
Begin
  Result := fSMTPLoginUser;

  If Trim(Result) = '' Then
  Begin
    fSMTPLoginUser := UserName;
    Result := fSMTPLoginUser;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SendMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSMTP.SendMail(pMail: TMailMessage): Boolean;
Var
  lMessage: TIdMessage;
  lCanSend: Boolean;
Begin
  Result := False;

  If pMail <> Nil Then
    If Connected Then
    Begin
      lCanSend := True;
      {if authentication is being used, i double check if certification has already been done before start the sending process}
      If UseAuthentication Then
      Begin
        If Not fSMTP.DidAuthenticate Then
        Try
          fSMTP.Authenticate;
        Except
          On e: exception Do
            DoErrorMessage('TSMTP.SendMail', 'Error doing authentication: ' +
              e.Message);
        End; {try}

        lCanSend := fSMTP.DidAuthenticate;
      End; {if UseAuthentication then}

      If lCanSend Then
      Begin
        lMessage := Nil;
        {convert mail message to an indy formated message}
        Try
          lMessage := pMail.MailMsgToIndyMsg;
        Except
          On e: exception Do
          Begin
            DoErrorMessage('TSMTP.SendMail', e.Message);
            If lMessage <> Nil Then
              FreeAndNil(lMessage);
          End;
        End;

        {send the message}
        If lMessage <> Nil Then
        Begin
          If Assigned(OnBeforeSend) Then
            OnBeforeSend(Self, pMail, lCanSend);

          If lCanSend Then
          Try
            fSMTP.Send(lMessage);
            Result := True;
          Except
            On e: exception Do
            begin
              DoErrorMessage('TSMTP.SendMail', e.Message);
            end;
          End;

          lMessage.Free;

          If Assigned(OnAfterSend) Then
            OnAfterSend(Self);
        End {if lMessage <> nil then}
        Else
        Begin
          Result := False;
          DoErrorMessage('TSMTP.SendMail', 'Nil translated message returned...');
        End;
      End {if lCanSend then}
      Else
        DoErrorMessage('TSMTP.SendMail', 'Authentication failure...');

      {disconnect to send straight away}
      Try
        Connected := False;
      Except
      End;
    End {if Connected then}
    else
      DoErrorMessage('TSMTP.SendMail', 'SMTP is not connected...');
End;

{-----------------------------------------------------------------------------
  Procedure: SetConnected
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TSMTP.SetConnected(Const Value: Boolean);
Var
  lCont1, lCont2: Integer;
Begin
  {check if pop3 is connected}
  If Value And Not Connected Then
  Begin
    fSMTP.Host := Host;
    fSMTP.Username := UserName;
    fSMTP.Password := Password;
    fSMTP.Port := OutgoingPort;
    fSMTP.AuthType := fAuthType;

    {********* ATTENTION *******}
    {if no timeout is set, indy component will stay in an infinite loop...}
    fSMTP.ReadTimeout := Timeout;

    {set authentication properties}
    If UseAuthentication Then
    Begin
      fSMTP.IOHandler := fHandler;
      fHandler.Port := fSMTP.Port;
      fHandler.PassThrough := PassThrough;
      fHandler.SSLOptions.Method := SSLVersion;
      fSMTP.UseTLS := UseTLS; // Ex:. gmail

      {if SMTPLoginUser/SMTPLoginPassword is not set, it will get the username/password. }
      fUserPass.Username := SMTPLoginUser;
      fUserPass.Password := SMTPLoginPassword;

      fSMTP.SASLMechanisms.Clear;
      With fSMTP.SASLMechanisms.Add Do
        SASL := fLogin;
    End; {If UseAuthentication Then}

    {try a connection}
    Try
      fSMTP.Connect();
    Except
      On E: exception Do
        DoErrorMessage('TSMTP.SetConnected.', E.Message);
    End; {try}

    Delay(1000);

    {maybe there is a variation of what should be used to connect, them, try them all}
    If Not Connected And UseAuthentication And KeepTrying Then
    Begin
      {from this point on, the component will try to connect using a variation of authtype and usetls}
      For lCont1 := Low(cSMTPAUTH_TYPE) To High(cSMTPAUTH_TYPE) Do
      Begin
        For lCont2 := Low(cUSE_TLS) To High(cUSE_TLS) Do
        Begin
          Try
            fSMTP.Disconnect;
          Except
          End;

          {set authentication type and tls type}
          fSMTP.AuthType := cSMTPAUTH_TYPE[lCont1];
          fSMTP.UseTLS := cUSE_TLS[lCont2];

          Try
            fSMTP.Connect();
          Except
            On E: exception Do
              DoErrorMessage('TSMTP.SetConnected..', E.Message);
          End; {try}

          If Connected Then
            Break;
        End; {for lCont2:= Low(cUSE_TLS) to High(cUSE_TLS) do}

        If Connected Then
          Break;
      End; {For lCont1 := Low(cAUTH_TYPE) To High(cAUTH_TYPE) Do}
    End; {if not Connected and UseAuthentication then}

    If Connected Then
      If Assigned(OnAfterConnect) Then
        OnAfterConnect(Self);
  End
  Else If Not Value Then
  Try
    fSMTP.Disconnect;
  Except
  End;
End;

End.

