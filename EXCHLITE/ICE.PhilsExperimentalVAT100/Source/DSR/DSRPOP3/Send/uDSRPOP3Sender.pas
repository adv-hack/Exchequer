Unit uDSRPOP3Sender;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, DSRPOP3Send_TLB, StdVcl, dsroutgoing_tlb, Classes,

  uInterfaces, uSMTP, uMailMessage, uMailbase
  ;

Type
  TDSRPOP3Sender = Class(TAutoObject, IDSRPOP3Sender, IDSROutgoingSystem)
  Private
    fSmtp: TSMTP;
    fMessage: TMailMessage;
    Procedure OnError(Sender: TObject; Const pWhere, pError: String);
  Protected
    Function Get_Authentication: WordBool; Safecall;
    Function Get_BCC: WideString; Safecall;
    Function Get_Body: WideString; Safecall;
    Function Get_CC: WideString; Safecall;
    Function Get_Files: WideString; Safecall;
    Function Get_OutgoingPassword: WideString; Safecall;
    Function Get_OutgoingPort: Integer; Safecall;
    Function Get_OutgoingServer: WideString; Safecall;
    Function Get_OutgoingUsername: WideString; Safecall;
    Function Get_Password: WideString; Safecall;
    Function Get_ServerType: WideString; Safecall;
    Function Get_SSLOutgoing: WordBool; Safecall;
    Function Get_Subject: WideString; Safecall;
    Function Get_To_: WideString; Safecall;
    Function Get_UserName: WideString; Safecall;
    Function Get_YourEmail: WideString; Safecall;
    Function Get_YourName: WideString; Safecall;
    Function SendMsg: LongWord; Safecall;
    Procedure Set_Authentication(Value: WordBool); Safecall;
    Procedure Set_BCC(Const Value: WideString); Safecall;
    Procedure Set_Body(Const Value: WideString); Safecall;
    Procedure Set_CC(Const Value: WideString); Safecall;
    Procedure Set_Files(Const Value: WideString); Safecall;
    Procedure Set_OutgoingPassword(Const Value: WideString); Safecall;
    Procedure Set_OutgoingPort(Value: Integer); Safecall;
    Procedure Set_OutgoingServer(Const Value: WideString); Safecall;
    Procedure Set_OutgoingUsername(Const Value: WideString); Safecall;
    Procedure Set_Password(Const Value: WideString); Safecall;
    Procedure Set_ServerType(Const Value: WideString); Safecall;
    Procedure Set_SSLOutgoing(Value: WordBool); Safecall;
    Procedure Set_Subject(Const Value: WideString); Safecall;
    Procedure Set_To_(Const Value: WideString); Safecall;
    Procedure Set_UserName(Const Value: WideString); Safecall;
    Procedure Set_YourEmail(Const Value: WideString); Safecall;
    Procedure Set_YourName(Const Value: WideString); Safecall;
  Public
    Procedure Initialize; Override;
    Destructor Destroy; Override;
  End;

Implementation

Uses ComServ, Sysutils, uBaseClass, uConsts, uMailMessageAttach, ucommon;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRPOP3Sender.Destroy;
Begin
  fSmtp.Free;
  fMessage.Free;
  Inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: Initialize
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Initialize;
Begin
  Inherited;
  fMessage := TMailMessage.Create;
  fSmtp := TSMTP.Create;
  fSmtp.OnError := OnError;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_Authentication
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_Authentication: WordBool;
Begin
  Result := fSmtp.UseAuthentication;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_BCC
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_BCC: WideString;
Begin
  Result := Trim(fMessage.BCC.CommaText);
End;

{-----------------------------------------------------------------------------
  Procedure: Get_Body
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_Body: WideString;
Begin
  Result := Trim(fMessage.Body.Text)
End;

{-----------------------------------------------------------------------------
  Procedure: Get_CC
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_CC: WideString;
Begin
  Result := Trim(fMessage.CC.CommaText)
End;

{-----------------------------------------------------------------------------
  Procedure: Get_Files
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_Files: WideString;
Begin
  Result := fMessage.AttachmentsAsStr;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_OutgoingPassword
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_OutgoingPassword: WideString;
Begin
  Result := fSmtp.SMTPLoginPassword;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_OutgoingPort
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_OutgoingPort: Integer;
Begin
  Result := fSmtp.OutgoingPort;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_OutgoingServer
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_OutgoingServer: WideString;
Begin
  Result := fSmtp.Host;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_OutgoingUsername
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_OutgoingUsername: WideString;
Begin
  Result := fsmtp.SMTPLoginUser;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_Password
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_Password: WideString;
Begin
  result := fsmtp.Password;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_ServerType
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_ServerType: WideString;
Begin
End;

{-----------------------------------------------------------------------------
  Procedure: Get_SSLOutgoing
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_SSLOutgoing: WordBool;
Begin
End;

{-----------------------------------------------------------------------------
  Procedure: Get_Subject
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_Subject: WideString;
Begin
  result := fMessage.Subject;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_To_
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_To_: WideString;
Begin
  result := trim(fMessage.To_.CommaText)
End;

{-----------------------------------------------------------------------------
  Procedure: Get_UserName
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_UserName: WideString;
Begin
  result := fsmtp.UserName;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_YourEmail
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_YourEmail: WideString;
Begin
  result := fmessage.SenderAddress;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_YourName
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.Get_YourName: WideString;
Begin
  result := fmessage.SenderName;
End;

{-----------------------------------------------------------------------------
  Procedure: SendMsg
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRPOP3Sender.SendMsg: LongWord;
Var
  lSend: Boolean;
Begin
  Result := S_OK;
  lSend := False;
  {try other variations of the authentication methods}
  fSmtp.KeepTrying := fSmtp.UseAuthentication;
  fSmtp.Connected := True;

  If fSmtp.Connected Then
  Begin
    If fMessage.AttachCount = 0 Then
      OnError(Self, 'TDSRMAPISender.SendMsg',
        'ATTENTION: No attachments being sent...');

    Try
      lSend := fSmtp.SendMail(fMessage);
    Except
      On e: exception Do
      begin
        lSend := False;
        Result := cERRORSENDINGEMAIL;
        OnError(Self, 'TDSRPOP3Sender.SendMsg', e.message);
      end;
    End;
  End
  Else
  begin
    Result := cERRORSENDINGEMAIL;
    OnError(Self, 'TDSRPOP3Sender.SendMsg', 'SMTP connection failed...');
  end;

  If Not lSend Then
    Result := cERRORSENDINGEMAIL;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_Authentication
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_Authentication(Value: WordBool);
Begin
  fSmtp.UseAuthentication := Boolean(Value)
End;

{-----------------------------------------------------------------------------
  Procedure: Set_BCC
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_BCC(Const Value: WideString);
Begin
  fMessage.BCC.CommaText := value;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_Body
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_Body(Const Value: WideString);
Begin
  fMessage.Body.Text := Value;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_CC
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_CC(Const Value: WideString);
Begin
  fMessage.CC.CommaText := value;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_Files
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_Files(Const Value: WideString);
Var
  lStr: TStringList;
  lCont: Integer;
Begin
  If Value <> '' Then
  Begin
    lStr := TStringList.Create;

    Try
      lStr.CommaText := Value;
    Except
    End;

    If lStr.Count > 0 Then
      For lCont := 0 To lStr.Count - 1 Do
        With fMessage.AddAttachment Do
          FileName := lStr[lCont];

    lStr.Free;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_OutgoingPassword
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_OutgoingPassword(Const Value: WideString);
Begin
  fSmtp.SMTPLoginPassword := Value;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_OutgoingPort
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_OutgoingPort(Value: Integer);
Begin
  fSmtp.OutgoingPort := value;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_OutgoingServer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_OutgoingServer(Const Value: WideString);
Begin
  fsmtp.Host := value;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_OutgoingUsername
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_OutgoingUsername(Const Value: WideString);
Begin
  fsmtp.SMTPLoginUser := value;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_Password
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_Password(Const Value: WideString);
Begin
  fSmtp.Password := value;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_ServerType
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_ServerType(Const Value: WideString);
Begin

End;

{-----------------------------------------------------------------------------
  Procedure: Set_SSLOutgoing
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_SSLOutgoing(Value: WordBool);
Begin
//  fsmtp.UseAuthentication := boolean(value);

End;

{-----------------------------------------------------------------------------
  Procedure: Set_Subject
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_Subject(Const Value: WideString);
Begin
  fMessage.Subject := value;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_To_
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_To_(Const Value: WideString);
Begin
  fMessage.To_.CommaText := value;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_UserName
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_UserName(Const Value: WideString);
Begin
  fsmtp.UserName := value;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_YourEmail
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_YourEmail(Const Value: WideString);
Begin
  fMessage.SenderAddress := value;
End;

{-----------------------------------------------------------------------------
  Procedure: Set_YourName
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.Set_YourName(Const Value: WideString);
Begin
  fMessage.SenderName := value;
End;

{-----------------------------------------------------------------------------
  Procedure: OnError
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRPOP3Sender.OnError(Sender: TObject; Const pWhere, pError: String);
var
  lLog: _Base;
Begin
  lLog:= _Base.Create;
  lLog.DoLogMessage(pWhere, cERRORSENDINGEMAIL, pError);
  lLog.Free;
End;

Initialization
  TAutoObjectFactory.Create(ComServer, TDSRPOP3Sender, Class_DSRPOP3Sender,
    ciMultiInstance, tmApartment);
End.

