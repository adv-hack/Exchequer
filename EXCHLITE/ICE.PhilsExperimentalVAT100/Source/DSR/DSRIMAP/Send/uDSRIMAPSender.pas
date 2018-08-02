unit uDSRIMAPSender;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, DSRIMAPSEND_TLB, StdVcl, dsroutgoing_tlb, Classes,

  uInterfaces, uIMAP, uMailMessage, uMailbase


  ;

type
  TDSRIMAPSender = class(TAutoObject, IDSRIMAPSender, IDSROutgoingSystem)
  Private
    fIMAP: TIMAPSender;
    fMessage: TMailMessage;
    Procedure OnError(Sender: TObject; Const pWhere, pError: String);
  protected
    function Get_Authentication: WordBool; safecall;
    function Get_BCC: WideString; safecall;
    function Get_Body: WideString; safecall;
    function Get_CC: WideString; safecall;
    function Get_Files: WideString; safecall;
    function Get_OutgoingPassword: WideString; safecall;
    function Get_OutgoingPort: Integer; safecall;
    function Get_OutgoingServer: WideString; safecall;
    function Get_OutgoingUsername: WideString; safecall;
    function Get_Password: WideString; safecall;
    function Get_ServerType: WideString; safecall;
    function Get_SSLOutgoing: WordBool; safecall;
    function Get_Subject: WideString; safecall;
    function Get_To_: WideString; safecall;
    function Get_UserName: WideString; safecall;
    function Get_YourEmail: WideString; safecall;
    function Get_YourName: WideString; safecall;
    function SendMsg: LongWord; safecall;
    procedure Set_Authentication(Value: WordBool); safecall;
    procedure Set_BCC(const Value: WideString); safecall;
    procedure Set_Body(const Value: WideString); safecall;
    procedure Set_CC(const Value: WideString); safecall;
    procedure Set_Files(const Value: WideString); safecall;
    procedure Set_OutgoingPassword(const Value: WideString); safecall;
    procedure Set_OutgoingPort(Value: Integer); safecall;
    procedure Set_OutgoingServer(const Value: WideString); safecall;
    procedure Set_OutgoingUsername(const Value: WideString); safecall;
    procedure Set_Password(const Value: WideString); safecall;
    procedure Set_ServerType(const Value: WideString); safecall;
    procedure Set_SSLOutgoing(Value: WordBool); safecall;
    procedure Set_Subject(const Value: WideString); safecall;
    procedure Set_To_(const Value: WideString); safecall;
    procedure Set_UserName(const Value: WideString); safecall;
    procedure Set_YourEmail(const Value: WideString); safecall;
    procedure Set_YourName(const Value: WideString); safecall;
  Public
    Procedure Initialize; Override;
    Destructor Destroy; Override;
  end;

implementation

uses ComServ, Sysutils, uBaseClass, uConsts, uMailMessageAttach;

destructor TDSRIMAPSender.Destroy;
begin
  fIMAP.Free;
  fMessage.Free;
  inherited;
end;

procedure TDSRIMAPSender.Initialize;
begin
  inherited;
  fMessage := TMailMessage.Create;
  fIMAP := TIMAPSender.Create;
  fIMAP.OnError := OnError;
end;


function TDSRIMAPSender.Get_Authentication: WordBool;
begin
  Result := fImap.UseAuthentication;
end;

function TDSRIMAPSender.Get_BCC: WideString;
begin
  Result := Trim(fMessage.BCC.CommaText);
end;

function TDSRIMAPSender.Get_Body: WideString;
begin
  Result := Trim(fMessage.Body.Text)
end;

function TDSRIMAPSender.Get_CC: WideString;
begin
  Result := Trim(fMessage.CC.CommaText)
end;

function TDSRIMAPSender.Get_Files: WideString;
begin
  Result := fMessage.AttachmentsAsStr;
end;

function TDSRIMAPSender.Get_OutgoingPassword: WideString;
begin
  Result := fImap.SMTPLoginPassword;
end;

function TDSRIMAPSender.Get_OutgoingPort: Integer;
begin
  Result := fIMAP.OutgoingPort;
end;

function TDSRIMAPSender.Get_OutgoingServer: WideString;
begin
  Result := fIMAP.Host;
end;

function TDSRIMAPSender.Get_OutgoingUsername: WideString;
begin
  Result := fIMAP.SMTPLoginUser;
end;

function TDSRIMAPSender.Get_Password: WideString;
begin
  result := fIMAP.Password;
end;

function TDSRIMAPSender.Get_ServerType: WideString;
begin

end;

function TDSRIMAPSender.Get_SSLOutgoing: WordBool;
begin
  result := fIMAP.UseAuthentication
end;

function TDSRIMAPSender.Get_Subject: WideString;
begin
  result := fMessage.Subject;
end;

function TDSRIMAPSender.Get_To_: WideString;
begin
  result := trim(fMessage.To_.CommaText)
end;

function TDSRIMAPSender.Get_UserName: WideString;
begin
  result := fImap.UserName;
end;

function TDSRIMAPSender.Get_YourEmail: WideString;
begin
  result := fmessage.SenderAddress;
end;

function TDSRIMAPSender.Get_YourName: WideString;
begin
  result := fmessage.SenderName;
end;

procedure TDSRIMAPSender.OnError(Sender: TObject; const pWhere,
  pError: String);
begin
  With _Base.Create Do
  Try
    DoLogMessage(pWhere, cERRORSENDINGEMAIL, pError);
  Finally
    Free;
  End;
end;

function TDSRIMAPSender.SendMsg: LongWord;
Var
  lSend: Boolean;
Begin
  Result := S_OK;
  lSend := False;
  {try other variations of the authentication methods}
  fIMAP.KeepTrying := fIMAP.UseAuthentication;
  fIMAP.Connected := True;

  If fIMAP.Connected Then
  Begin
    If fMessage.AttachCount = 0 Then
      OnError(Self, 'TDSRIMAPSender.SendMsg',
        'ATTENTION: No attachments being sent...');

    Try
      lSend := fIMAP.SendMail(fMessage);
    Except
      On e: exception Do
        OnError(Self, 'TDSRIMAPSender.SendMsg', e.message);
    End;
  End
  Else
    OnError(Self, 'TDSRIMAPSender.SendMsg', 'IMAP connection failed...');

  If Not lSend Then
    Result := cERRORSENDINGEMAIL;
end;

procedure TDSRIMAPSender.Set_Authentication(Value: WordBool);
begin
  fImap.UseAuthentication := Boolean(VAlue)
end;

procedure TDSRIMAPSender.Set_BCC(const Value: WideString);
begin
  fMessage.BCC.CommaText := value;
end;

procedure TDSRIMAPSender.Set_Body(const Value: WideString);
begin
  fMessage.Body.Text := Value;
end;

procedure TDSRIMAPSender.Set_CC(const Value: WideString);
begin
  fMessage.CC.CommaText := value;
end;

procedure TDSRIMAPSender.Set_Files(const Value: WideString);
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
end;

procedure TDSRIMAPSender.Set_OutgoingPassword(const Value: WideString);
begin
  fImap.SMTPLoginPassword := Value;
end;

procedure TDSRIMAPSender.Set_OutgoingPort(Value: Integer);
begin
  fImap.OutgoingPort := value;
end;

procedure TDSRIMAPSender.Set_OutgoingServer(const Value: WideString);
begin
  fImap.Host := value;
end;

procedure TDSRIMAPSender.Set_OutgoingUsername(const Value: WideString);
begin
  fImap.SMTPLoginUser := value;
end;

procedure TDSRIMAPSender.Set_Password(const Value: WideString);
begin
  fImap.Password := value;
end;

procedure TDSRIMAPSender.Set_ServerType(const Value: WideString);
begin

end;

procedure TDSRIMAPSender.Set_SSLOutgoing(Value: WordBool);
begin
  fImap.UseAuthentication := boolean(value);
end;

procedure TDSRIMAPSender.Set_Subject(const Value: WideString);
begin
  fMessage.Subject := value;
end;

procedure TDSRIMAPSender.Set_To_(const Value: WideString);
begin
  fMessage.To_.CommaText := value;
end;

procedure TDSRIMAPSender.Set_UserName(const Value: WideString);
begin
  fImap.UserName := value;
end;

procedure TDSRIMAPSender.Set_YourEmail(const Value: WideString);
begin
  fMessage.SenderAddress := value;
end;

procedure TDSRIMAPSender.Set_YourName(const Value: WideString);
begin
  fMessage.SenderName := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TDSRIMAPSender, Class_DSRIMAPSender,
    ciMultiInstance, tmApartment);
end.
