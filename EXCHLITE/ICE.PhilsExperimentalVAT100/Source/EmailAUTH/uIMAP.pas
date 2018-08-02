Unit uIMAP;

Interface

Uses Windows, Sysutils, Classes, uSmtp,
  uMailMessage, uMailBase,

  IdIMAP4, IdSSLOpenSSL, IdSASLLogin, IdUserPassProvider, IdMessage, IdAttachmentFile
  ;

Const
  // at default seems to be the first option...
  cSMTPAUTH_TYPE: Array[1..2] Of TIdIMAP4AuthenticationType = (atUserPass, atSASL);

Type
  TIMAPType = (tiIncoming, tiOutgoing);

  _IMAP = Class(TEmailBase)
  Private
    fIMAP: TIdIMAP4;
    fAuthType: TIdIMAP4AuthenticationType;

    fHandler: TIdSSLIOHandlerSocketOpenSSL;
    fLogin: TIdSASLLogin;
    fUserPass: TIdUserPassProvider;
    fIMAPType: TIMAPType;
    fMailBoxSelected: Boolean;
  Protected
    Function GetConnected: Boolean; Override;
    Procedure SetConnected(Const Value: Boolean); Override;
  Public
    Constructor Create; Override;
    Destructor Destroy; Override;

    Procedure SelectMailBox;
  Published
    Property Host;
    Property IncomingPort;
    Property OutgoingPort;
    Property UserName;
    Property Password;
    Property UseTLS;
    Property SSLVersion;
    Property PassThrough;
    Property UseIndySASL;
    Property Timeout;
    Property MailBox;
    property MailBoxSeparator;
    Property IMAPType: TIMAPType Read fIMAPType Write fIMAPType;

    Property AuthType: TIdIMAP4AuthenticationType Read fAuthType Write fAuthType;
    Property MailBoxSelected: Boolean Read fMailBoxSelected Write fMailBoxSelected;
  End;

  {according to some websites, imap use the same protocol as smtp to send messages...}
  //TIMAPSender = Class(_IMAP)
  TIMAPSender = Class(TSMTP)
  Public
    Constructor Create; Override;
    Destructor Destroy; Override;

//    Function SendMail(pMail: TMailMessage): Boolean; Override;
  End;

  TIMAPReceiver = Class(_IMAP)
  Public
    Constructor Create; Override;
    Destructor Destroy; Override;

    Function GetMail(Index: Integer): TMailMessage; Override;
    Function GetMessageCount: Integer; Virtual;
    Function DeleteMail(Index: Integer): Boolean; Override;
    Procedure SetMessageToDelete(index: Integer); override;

    Property Mail;
  Published
    Property MessageCount: Integer Read GetMessageCount;
  End;

Implementation

{ TIMAP }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor _IMAP.Create;
Begin
  Inherited Create;

  fIMAP := TIdIMAP4.Create(Nil);

  fHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
  fHandler.ConnectTimeout := Timeout;
  fLogin := TIdSASLLogin.Create;
  fUserPass := TIdUserPassProvider.Create;
  fLogin.UserPassProvider := fUserPass;
  fAuthType := atUserPass;
  fIMAPType := tiOutgoing;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor _IMAP.Destroy;
Begin
  If fMailBoxSelected Then
  Try
    fIMAP.CloseMailBox;
  Except
  End;

  If fIMAP.Connected Then
  Try
    fIMAP.Disconnect;
  Except
  End;

  fHandler.Free;
  fUserPass.Free;
  fLogin.Free;
  fIMAP.Free;

  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: GetConnected
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _IMAP.GetConnected: Boolean;
Begin
  Result := False;
  Try
    Result := fIMAP.Connected;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SelectMailBox
  Author:    vmoura

  This function MUST be called after loading messages from a mail box...
  that is part of the specification of IMAP
-----------------------------------------------------------------------------}
Procedure _IMAP.SelectMailBox;
Begin
  fMailBoxSelected := False;

  Try
    fMailBoxSelected := fIMAP.SelectMailBox(MailBox);
  Except
    On e: exception Do
      DoErrorMessage('_IMAP.SelectMailBox', e.Message + '. MailBox: "' + MailBox +
        '"');
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SetConnected
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _IMAP.SetConnected(Const Value: Boolean);
Var
  lCont1, lCont2: Integer;
Begin
  {check if pop3 is connected}
  If Value And Not Connected Then
  Begin
    fIMAP.Host := Host;
    fIMAP.Username := UserName;
    fIMAP.Password := Password;
    fIMAP.MailBoxSeparator := MailBoxSeparator;

    If IMAPType = tiOutgoing Then
      fIMAP.Port := OutgoingPort
    Else
      fIMAP.Port := IncomingPort;

    fIMAP.AuthType := fAuthType;

    {********* ATTENTION *******}
    {if no timeout is set, indy component will stay in an infinite loop...}
    fIMAP.ReadTimeout := Timeout;

    {set authentication properties}
    If UseAuthentication Then
    Begin
      fIMAP.IOHandler := fHandler;
      fHandler.Port := fIMAP.Port;
      fHandler.PassThrough := PassThrough;
      fHandler.SSLOptions.Method := SSLVersion;
      fIMAP.UseTLS := UseTLS;

//      If UseIndySASL Then
//      Begin
        fUserPass.Username := UserName;
        fUserPass.Password := Password;
        fIMAP.SASLMechanisms.Clear;
        With fIMAP.SASLMechanisms.Add Do
          SASL := fLogin;
//      End; {If UseIndySASL Then}
    End; {If UseAuthentication Then}

    {try a connection}
    Try
      fIMAP.Connect(True);
    Except
      On E: exception Do
        DoErrorMessage('TIMAP.SetConnected', E.Message);
    End; {try}

    Delay(1000);

    {maybe there is a variation of what should be used to connect, them, try them all}
    If Not Connected And UseAuthentication and KeepTrying Then
    Begin
      {from this point on, the component will try to connect using a variation of authtype and usetls}
      For lCont1 := Low(cSMTPAUTH_TYPE) To High(cSMTPAUTH_TYPE) Do
      Begin
        For lCont2 := Low(cUSE_TLS) To High(cUSE_TLS) Do
        Begin
          Try
            fIMAP.Disconnect;
          Except
          End;

          {set authentication type and tls type}
          fIMAP.AuthType := cSMTPAUTH_TYPE[lCont1];
          fIMAP.UseTLS := cUSE_TLS[lCont2];

          Try
            fIMAP.Connect(True);
          Except
            On E: exception Do
              DoErrorMessage('TIMAP.SetConnected', E.Message);
          End; {try}

          If Connected Then
            Break;
        End; {for lCont2:= Low(cUSE_TLS) to High(cUSE_TLS) do}

        If Connected Then
          Break;
      End; {For lCont1 := Low(cAUTH_TYPE) To High(cAUTH_TYPE) Do}
    End; {if not Connected and UseAuthentication then}

    if Connected then
      if Assigned(OnAfterConnect) then
        OnAfterConnect(Self);
  End
  Else If Not Value Then
  Try
    fIMAP.Disconnect;
  Except
  End;
End;

{ TIMAPReceiver }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TIMAPReceiver.Create;
Begin
  Inherited Create;
  IMAPType := tiIncoming;
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TIMAPReceiver.DeleteMail(Index: Integer): Boolean;
Begin
  Result := False;
  If Connected Then
  Begin
    {mark message to be deleted}
    If MailBoxSelected Then
    Begin
      Try
        Result := fIMap.DeleteMsgs([Index]);
      Except
        On E: Exception Do
          DoErrorMessage('TIMAPReceiver.DeleteMail', E.Message);
      End; {try}

      Try
        Result := fIMap.ExpungeMailBox;
      Except
        On E: Exception Do
          DoErrorMessage('TIMAPReceiver.DeleteMail', E.Message);
      End;
    End
    Else
      DoErrorMessage('TIMAPReceiver.DeleteMail',
        'No Mailbox has been selected. MailBox: "' + MailBox + '"');
  End; {If Connected Then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TIMAPReceiver.GetMail(Index: Integer): TMailMessage;
Var
  lMessage: TIdMessage;
  lRetrieved: Boolean;
Begin
  Result := Nil;

  If Connected Then
  Begin
    {mark message to be deleted}
    If MailBoxSelected Then
    Begin
      If (Index >= 0) And (Index < MessageCount) Then
      Begin
        lMessage := TIdMessage.Create(Nil);
        lRetrieved := False;

        {retrieve and check the result - ATTENTION - counter starts from 1!}
        Try
          lRetrieved := fImap.Retrieve(Index + 1, lMessage);
        Except
          On E: exception Do
            DoErrorMessage('TIMAPReceiver.GetMail', e.Message);
        End; {try}

        If lRetrieved Then
        Begin
          {fill mailmessage details}
          Result := TMailMessage.Create;
          Result.OutputDir := AttachDirectory;
          Result.Index := Index + 1;
          Result.IndyMsgToMailMsg(lMessage);

          If Result.ErrorString <> '' Then
            DoErrorMessage('TIMAPReceiver.GetMail', Result.ErrorString);
        End; {if lRetrieved then}

        lMessage.Free;
      End {if (Index >= 0) and (Index < MessageCount) then}
      Else
        DoErrorMessage('TIMAPReceiver.DeleteMail', 'Invalid Index: ' +
          inttostr(Index));
    End
    Else
      DoErrorMessage('TIMAPReceiver.DeleteMail',
        'No Mailbox has been selected. MailBox: "' + MailBox + '"');
  End; {If Connected Then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetMessageCount
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TIMAPReceiver.GetMessageCount: Integer;
Begin
  Result := -1;
  If Connected Then
  Begin
    if not MailBoxSelected then
    try
      SelectMailBox;
    except
      On e: exception Do
        DoErrorMessage('TIMAPReceiver.GetMessageCount', e.Message);
    end;
    
    {mark message to be deleted}
    If MailBoxSelected Then
    Begin
      Try
        Result := fIMAP.MailBox.TotalMsgs;
      Except
        On e: exception Do
          DoErrorMessage('TIMAPReceiver.GetMessageCount', e.Message);
      End;
    End
    Else
      DoErrorMessage('TIMAPReceiver.GetMessageCount',
        'No Mailbox has been selected. MailBox: "' + MailBox + '"');
  End; {If Connected Then}
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TIMAPReceiver.Destroy;
Begin
  Inherited Destroy;
End;

{ TIMAPSender }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TIMAPSender.Create;
Begin
  Inherited Create;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TIMAPSender.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: SetMessageToDelete
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TIMAPReceiver.SetMessageToDelete(index: Integer);
begin
  DeleteMail(Index)
end;

End.

