Unit uPOP3;

Interface

Uses Windows, Sysutils, Classes,

  uMailBase, uMailMessage,
  {indy components}
  IdPOP3, IdSSLOpenSSL, IdSASLLogin, IdUserPassProvider, IdMessage, IdAttachment,
  IdAttachmentFile
  ;

Const
  cPOP3AUTH_TYPE: Array[1..3] Of TIdPOP3AuthenticationType = (atUserPass, atAPOP,
    atSASL);

Type
  TPOP3 = Class(TEmailBase)
  Private
    fPOP3: TIdPOP3;
    fHandler: TIdSSLIOHandlerSocketOpenSSL;
    fAuthType: TIdPOP3AuthenticationType;
    fLogin: TIdSASLLogin;
    fUserPass: TIdUserPassProvider;
  Public
    Constructor Create; Override;
    Destructor Destroy; Override;

    Function GetMail(Index: Integer): TMailMessage; Override;
    Function GetConnected: Boolean; Override;
    Procedure SetConnected(Const Value: Boolean); Override;
    Function GetMessageCount: Integer; Virtual;
    Function DeleteMail(Index: Integer): Boolean; Override;
    Procedure SetMessageToDelete(index: Integer); override;

    Property Mail;
  Published
    Property Host;
    Property IncomingPort;
    Property UserName;
    Property Password;
    Property UseTLS;
    Property SSLVersion;
    Property PassThrough;
    Property UseIndySASL;
    Property Timeout;

    Property AuthType: TIdPOP3AuthenticationType Read fAuthType Write fAuthType;
    Property MessageCount: Integer Read GetMessageCount;
  End;

Implementation

Uses uMailMessageAttach;

{ TPOPSMTP }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TPOP3.Create;
Begin
  Inherited Create;

  fPOP3 := TIdPOP3.Create(Nil);
  fHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
  fHandler.ConnectTimeout := Timeout;
  fLogin := TIdSASLLogin.Create;
  fUserPass := TIdUserPassProvider.Create;
  fLogin.UserPassProvider := fUserPass;
  fAuthType := atUserPass;
  UseTLS := cUSE_TLS[2];
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TPOP3.DeleteMail(Index: Integer): Boolean;
Begin
  Result := False;
  If Connected Then
  Try
    Result := fPOP3.Delete(Index)
  Except
    On E: Exception Do
      DoErrorMessage('TPOP3.DeleteMail', E.Message);
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TPOP3.Destroy;
Begin
  If fPOP3.Connected Then
  Try
    fPOP3.Disconnect;
  Except
  End;

  fHandler.Free;
  fUserPass.Free;
  fLogin.Free;
  fPOP3.Free;

  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: GetConnected
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TPOP3.GetConnected: Boolean;
Begin
  Result := False;
  Try
    Result := fPOP3.Connected;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: GetMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TPOP3.GetMail(Index: Integer): TMailMessage;
Var
  lMessage: TIdMessage;
  lRetrieved: Boolean;
Begin
  Result := Nil;
  If Connected Then
    If (Index >= 0) And (Index < MessageCount) Then
    Begin
      lMessage := TIdMessage.Create(Nil);
      lRetrieved := False;

      {retrieve and check the result... ATTENTION - POP3 counter starts in 1!!! }
      Try
        lRetrieved := fPOP3.Retrieve(Index + 1, lMessage);
      Except
        On E: exception Do
          DoErrorMessage('TPOP3.GetMail', e.Message);
      End; {try}

      If lRetrieved Then
      Begin
        {fill mailmessage details}
        Result := TMailMessage.Create;
        Result.OutputDir := AttachDirectory;
        Result.Index := Index + 1;
        Result.IndyMsgToMailMsg(lMessage);

        If Result.ErrorString <> '' Then
          DoErrorMessage('TPOP3.GetMail', Result.ErrorString);
      End; {if lRetrieved then}

      lMessage.Free;
    End {if (Index >= 0) and (Index < MessageCount) then}
    Else
      DoErrorMessage('TPOP3.GetMail', 'Invalid Index: ' + inttostr(Index));
End;

{-----------------------------------------------------------------------------
  Procedure: GetMessageCount
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TPOP3.GetMessageCount: Integer;
Begin
  Result := 0;
  If Connected Then
  Try
    Result := fPOP3.CheckMessages;
  Except
    On E: Exception Do
      DoErrorMessage('TPOP3.GetMessageCount', E.Message);
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: SetConnected
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TPOP3.SetConnected(Const Value: Boolean);
Var
  lCont1, lCont2: Integer;
Begin
  {check if pop3 is connected}
  If Value And Not Connected Then
  Begin
    fPOP3.Host := Host;
    fPOP3.Username := UserName;
    fPOP3.Password := Password;
    fPOP3.Port := IncomingPort;
    fPOP3.AuthType := fAuthType;

    {set authentication properties}
    If UseAuthentication  Then
    Begin
      fPOP3.IOHandler := fHandler;
      fHandler.Port := fPOP3.Port;
      fHandler.PassThrough := PassThrough;
      fHandler.SSLOptions.Method := SSLVersion;
      fPOP3.UseTLS := UseTLS; // Ex:. gmail

//      If UseIndySASL Then
//      Begin
        fUserPass.Username := UserName;
        fUserPass.Password := Password;
        fPOP3.SASLMechanisms.Clear;
        With fPOP3.SASLMechanisms.Add Do
          SASL := fLogin;
//      End; {If UseIndySASL Then}
    End; {If UseAuthentication Then}

    {try a connection}
    Try
      fPOP3.Connect();
    Except
      On E: exception Do
        DoErrorMessage('TPOP3.SetConnected', E.Message);
    End; {try}

    Delay(1000);

    {maybe there is a variation of what should be used to connect, them, try them all}
    If Not Connected And UseAuthentication and KeepTrying Then
    Begin
      {from this point on, the component will try to connect using a variation of authtype and usetls}
      For lCont1 := Low(cPOP3AUTH_TYPE) To High(cPOP3AUTH_TYPE) Do
      Begin
        For lCont2 := Low(cUSE_TLS) To High(cUSE_TLS) Do
        Begin
          Try
            fPOP3.Disconnect;
          Except
          End;

          {set authentication type and tls type}
          fPOP3.AuthType := cPOP3AUTH_TYPE[lCont1];
          fPOP3.UseTLS := cUSE_TLS[lCont2];

          Try
            fPOP3.Connect();
          Except
            On E: exception Do
              DoErrorMessage('TPOP3.SetConnected', E.Message);
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
    fPOP3.Disconnect;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SetMessageToDelete
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TPOP3.SetMessageToDelete(index: Integer);
begin
  DeleteMail(Index)
end;

End.

