unit uDSRMAPISender;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, DSRMAPISend_TLB, StdVcl, dsroutgoing_tlb, Classes,

  uInterfaces, uMAPI, uMailMessage, uMailbase

  ;

type
  TDSRMAPISender = class(TAutoObject, IDSRMAPISender, IDSROutgoingSystem)
  private
    fMAPI: TMAPI;
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
  public
    Procedure Initialize; Override;
    Destructor Destroy; Override;
  end;

implementation

uses ComServ, Sysutils, uBaseClass, uConsts, uMailMessageAttach;

destructor TDSRMAPISender.Destroy;
begin
  fMAPI.Free;
  fMessage.Free;
  inherited;
end;

function TDSRMAPISender.Get_Authentication: WordBool;
begin

end;

function TDSRMAPISender.Get_BCC: WideString;
begin
  Result := Trim(fMessage.BCC.CommaText);
end;

function TDSRMAPISender.Get_Body: WideString;
begin
  Result := Trim(fMessage.Body.Text)
end;

function TDSRMAPISender.Get_CC: WideString;
begin
  Result := Trim(fMessage.CC.CommaText)
end;

function TDSRMAPISender.Get_Files: WideString;
begin
  Result := fMessage.AttachmentsAsStr;
end;

function TDSRMAPISender.Get_OutgoingPassword: WideString;
begin

end;

function TDSRMAPISender.Get_OutgoingPort: Integer;
begin

end;

function TDSRMAPISender.Get_OutgoingServer: WideString;
begin

end;

function TDSRMAPISender.Get_OutgoingUsername: WideString;
begin

end;

function TDSRMAPISender.Get_Password: WideString;
begin

end;

function TDSRMAPISender.Get_ServerType: WideString;
begin

end;

function TDSRMAPISender.Get_SSLOutgoing: WordBool;
begin

end;

function TDSRMAPISender.Get_Subject: WideString;
begin
  result := fMessage.Subject;
end;

function TDSRMAPISender.Get_To_: WideString;
begin
  result := trim(fMessage.To_.CommaText)
end;

function TDSRMAPISender.Get_UserName: WideString;
begin

end;

function TDSRMAPISender.Get_YourEmail: WideString;
begin
  result := fmessage.SenderAddress;
end;

function TDSRMAPISender.Get_YourName: WideString;
begin
  result := fmessage.SenderName;
end;

procedure TDSRMAPISender.Initialize;
begin
  inherited;
  fMessage := TMailMessage.Create;
  fMAPI := TMAPI.Create;
  fMAPI.OnError := OnError;
end;

procedure TDSRMAPISender.OnError(Sender: TObject; const pWhere,
  pError: String);
begin
  With _Base.Create Do
  Try
    DoLogMessage(pWhere, cERRORSENDINGEMAIL, pError);
  Finally
    Free;
  End;
end;

function TDSRMAPISender.SendMsg: LongWord;
Var
  lSend: Boolean;
Begin
  Result := S_OK;
  lSend := False;
  fMAPI.Connected := True;

  If fMAPI.Connected Then
  Begin
    if fMessage.AttachCount = 0 then
      OnError(Self, 'TDSRMAPISender.SendMsg', 'ATTENTION: No attachments being sent...');

    Try
      lSend := fMAPI.SendMail(fMessage);
    Except
      On e: exception Do
        OnError(Self, 'TDSRMAPISender.SendMsg', e.message);
    End;
  End
  Else
    OnError(Self, 'TDSRMAPISender.SendMsg', 'MAPI connection failed...');

  If Not lSend Then
    Result := cERRORSENDINGEMAIL;
end;

procedure TDSRMAPISender.Set_Authentication(Value: WordBool);
begin

end;

procedure TDSRMAPISender.Set_BCC(const Value: WideString);
begin
  fMessage.BCC.CommaText := value;
end;

procedure TDSRMAPISender.Set_Body(const Value: WideString);
begin
  fMessage.Body.Text := Value;
end;

procedure TDSRMAPISender.Set_CC(const Value: WideString);
begin
  fMessage.CC.CommaText := value;
end;

procedure TDSRMAPISender.Set_Files(const Value: WideString);
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

procedure TDSRMAPISender.Set_OutgoingPassword(const Value: WideString);
begin

end;

procedure TDSRMAPISender.Set_OutgoingPort(Value: Integer);
begin

end;

procedure TDSRMAPISender.Set_OutgoingServer(const Value: WideString);
begin

end;

procedure TDSRMAPISender.Set_OutgoingUsername(const Value: WideString);
begin

end;

procedure TDSRMAPISender.Set_Password(const Value: WideString);
begin

end;

procedure TDSRMAPISender.Set_ServerType(const Value: WideString);
begin

end;

procedure TDSRMAPISender.Set_SSLOutgoing(Value: WordBool);
begin

end;

procedure TDSRMAPISender.Set_Subject(const Value: WideString);
begin
  fMessage.Subject := value;
end;

procedure TDSRMAPISender.Set_To_(const Value: WideString);
begin
  fMessage.To_.CommaText := value;
end;

procedure TDSRMAPISender.Set_UserName(const Value: WideString);
begin

end;

procedure TDSRMAPISender.Set_YourEmail(const Value: WideString);
begin
  fMessage.SenderAddress := value;
end;

procedure TDSRMAPISender.Set_YourName(const Value: WideString);
begin
  fMessage.SenderName := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TDSRMAPISender, Class_DSRMAPISender,
    ciMultiInstance, tmApartment);
end.
