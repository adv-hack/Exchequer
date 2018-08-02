(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msSmtp;

{$I msdef.inc}

interface
               
uses
  Windows,
{$IFDEF VCL}
  Forms,
  Dialogs,
  Graphics,
  Controls,
{$ENDIF}
  Messages, SysUtils, Classes, msDef, msWSock,
  Mssocket, msMsg, msCls;

type
  TmsSMTPClient = class(TmsClientSocket)
  private
    { Private declarations }
    FMailMessage : TmsMessage;
    FOnPreparing : TNotifyEvent;
    FOnSending : TNotifyEvent;
    FOnSent : TNotifyEvent;
    FOnAddressRejected : TmsAddressRejectEvent;
    FEnvelopeSender: string;
    FEnvelopeRecipients : TStrings;
    FData: TStream;
    FActualLocalHost : string;
    FRejectedRecipients: Integer;
    FUserName: string;
    FPassword: string;
    function GetTotalRecipients: Integer;
    procedure SetEnvelopeRecipients(Value : TStrings);
    procedure DoAddressRejected(Sender : TObject; const TheAddress,
       ServerReply : string; var Proceed : boolean);
    procedure DoPreparing(Sender : TObject);
    procedure DoSending(Sender : TObject);
    procedure DoSent(Sender : TObject);
    procedure SendData;
  protected
    { Protected declarations }
    TempFileStream : TmsTempFileStream;
    procedure Verify;
    procedure SendEnvelope;
    procedure SendMailMessage;
    procedure PrepareMessage;
    function GetServerReplyCode(const s : string) : Integer; override;
{$IFDEF VCL}
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
{$ENDIF}
  public
    { Public declarations }
    procedure Connect; override;
    procedure Login;
    procedure Logout;
    procedure Reset;
    function ProcessSMTPCommand(const Cmd: string): Integer;
{$IFDEF VCL}
    constructor Create(AOwner : TComponent); override;
{$ELSE}
    constructor Create; override;
{$ENDIF}
    destructor Destroy; override;
    procedure SendMail;
    procedure Send;
    property EnvelopeSender: string read FEnvelopeSender write FEnvelopeSender;
    property EnvelopeRecipients : TStrings read FEnvelopeRecipients
      write SetEnvelopeRecipients;
    property Data: TStream read FData write FData;
    property ActualLocalHost : string read FActualLocalHost write FActualLocalHost;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
{$IFDEF VCL}
  published
    { Published declarations }
{$ENDIF}
    property MailMessage : TmsMessage read FMailMessage write FMailMessage;
    property Port default 25;
    property OnPreparing : TNotifyEvent read FOnPreparing write FOnPreparing;
    property OnSending : TNotifyEvent read FOnSending write FOnSending;
    property OnSent : TNotifyEvent read FOnSent write FOnSent;
    property OnAddressRejected : TmsAddressRejectEvent read FOnAddressRejected
       write FOnAddressRejected;
  end;

implementation

uses msMime;

{$IFDEF VCL}
constructor TmsSMTPClient.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Port:=25;
  FDefaultPort:=Port;
  FEnvelopeRecipients:=TStringList.Create;
end;
{$ELSE}
constructor TmsSMTPClient.Create;
begin
  inherited Create;
  Port:=25;
  FDefaultPort:=Port;
  FEnvelopeRecipients:=TStringList.Create;
end;
{$ENDIF}

destructor TmsSMTPClient.Destroy;
begin
  FEnvelopeRecipients.Free;
  inherited Destroy;
end;

function TmsSMTPClient.GetTotalRecipients: Integer;
begin
  if FEnvelopeRecipients.Count>0 then
    Result:=FEnvelopeRecipients.Count
  else
  if Assigned(FMailMessage) then
    Result:=FMailMessage.Recipients.Count+FMailMessage.CC.Count+
      FMailMessage.BCC.Count
  else
    Result:=0;
end;

procedure TmsSMTPClient.SetEnvelopeRecipients(Value : TStrings);
begin
  FEnvelopeRecipients.Assign(Value);
end;

procedure TmsSMTPClient.DoPreparing(Sender : TObject);
begin
  if Assigned(FOnPreparing) then
    FOnPreparing(Self);
end;

procedure TmsSMTPClient.DoSending(Sender : TObject);
begin
  if Assigned(FOnSending) then
    FOnSending(Self);
end;

procedure TmsSMTPClient.DoSent(Sender : TObject);
begin
  if Assigned(FOnSent) then
    FOnSent(Sender);
end;

procedure TmsSMTPClient.DoAddressRejected(Sender : TObject; const TheAddress,
  ServerReply : string; var Proceed : boolean);
begin
  Inc(FRejectedRecipients);
  if Assigned(FOnAddressRejected) then
    FOnAddressRejected(Sender, TheAddress, ServerReply, Proceed);
end;

{$IFDEF VCL}
procedure TmsSMTPClient.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation=opRemove) and (AComponent=FMailMessage) then
    FMailMessage:=nil;
end;
{$ENDIF}

procedure TmsSMTPClient.Verify;
begin
//  if not Assigned(FMailMessage) then
//    raise EmsError.Create('MailMessage property must be assigned');
  if (Host='') then
    raise EmsError.Create('Host property must be assigned');
end;

procedure TmsSMTPClient.Connect;
begin
  Verify;
  inherited Connect;
end;

procedure TmsSMTPClient.Login;
var
  rs : Integer;
  s1: ShortString;
begin
  Connect;
  rs:=iRecvLines;
  if rs<>220 then
    raise EmsServerError.Create(TempS);
  if FActualLocalHost<>'' then
    SendLine('EHLO '+FActualLocalHost)
  else
    SendLine('EHLO '+msWinsock.LocalName);
  rs:=iRecvLines;
  if (rs<>250) then
  begin
    if FActualLocalHost<>'' then
      SendLine('HELO '+FActualLocalHost)
    else
      SendLine('HELO '+msWinsock.LocalName);
    rs:=iRecvLines;
    if (rs<200) and (rs>300) then
      raise EmsServerError.Create(TempS);
  end;
//Authentication
  if FUserName<>'' then
  begin
    SendLine('auth login');
    rs:=iRecvLines;
    if (rs<300) and (rs>=400) then
      raise EmsServerError.Create('Error while authenticating');
    MakeTextData(FUserName,s1);
    SendLine(s1);
    rs:=iRecvLines;
    if (rs<300) and (rs>=400) then
      raise EmsServerError.Create('Error while sending username');
    MakeTextData(FPassword,s1);
    SendLine(s1);
    if (rs<300) and (rs>=400) then
      raise EmsServerError.Create('Error while sending password');
    rs:=iRecvLines;
    if (rs<200) and (rs>300) then
      raise EmsServerError.Create(TempS);
  end;
end;

procedure TmsSMTPClient.Logout;
var
  rs : Integer;
begin
  SendLine('QUIT');
  rs:=iRecvLines;
  if rs<>221 then
    raise EmsServerError.Create(TempS);
  Disconnect;
end;

procedure TmsSMTPClient.Reset;
var
  rs: Integer;
begin
  SendLine('RSET');
  rs:=iRecvLines;
  if (rs div 100)<>2 then
    raise EmsServerError.Create(TempS);
end;

procedure TmsSMTPClient.PrepareMessage;
begin
  DoPreparing(Self);
  FMailMessage.SaveToStream(TempFileStream);
end;

procedure TmsSMTPClient.SendEnvelope;
var
  rs,i : Integer;
  Proceed : boolean;
begin
  DoSending(Self);
  FRejectedRecipients:=0;
  if FEnvelopeSender<>'' then
    SendLine('MAIL FROM:<'+Trim(FEnvelopeSender)+'>')
  else
    SendLine('MAIL FROM:<'+FMailMessage.Sender.Address+'>');
  rs:=iRecvLines;
  if rs<>250 then
    raise EmsServerError.Create(TempS);
  if FEnvelopeRecipients.Count>0 then
  begin
    for i:=0 to FEnvelopeRecipients.Count-1 do
    begin
      Proceed:=false;
      SendLine('RCPT TO:<'+FEnvelopeRecipients[i]+'>');
      rs:=iRecvLines;
      if (rs<>250) and (rs<>251) then
      begin
        DoAddressRejected(Self,FEnvelopeRecipients[i],TempS,Proceed);
        if not Proceed then
          raise EmsServerError.Create(TempS);
      end;
    end;
  end
  else
  begin
    for i:=0 to FMailMessage.Recipients.Count-1 do
    begin
      Proceed:=false;
      SendLine('RCPT TO:<'+FMailMessage.Recipients[i].Address+'>');
      rs:=iRecvLines;
      if (rs<>250) and (rs<>251) then
      begin
        DoAddressRejected(Self,FMailMessage.Recipients[i].Address,TempS,Proceed);
        if not Proceed then
          raise EmsServerError.Create(TempS);
      end;
    end;
    for i:=0 to FMailMessage.CC.Count-1 do
    begin
      Proceed:=false;
      SendLine('RCPT TO:<'+FMailMessage.CC[i].Address+'>');
      rs:=iRecvLines;
      if (rs<>250) and (rs<>251) then
      begin
        DoAddressRejected(Self,FMailMessage.CC[i].Address,TempS,Proceed);
        if not Proceed then
          raise EmsServerError.Create(TempS);
      end;
    end;
    for i:=0 to FMailMessage.BCC.Count-1 do
    begin
      Proceed:=false;
      SendLine('RCPT TO:<'+FMailMessage.BCC[i].Address+'>');
      rs:=iRecvLines;
      if (rs<>250) and (rs<>251) then
      begin
        DoAddressRejected(Self,FMailMessage.BCC[i].Address,TempS,Proceed);
        if not Proceed then
          raise EmsServerError.Create(TempS);
      end;
    end;
  end;
end;

procedure TmsSMTPClient.SendData;
var
  rs: Integer;
begin
  SendLine('DATA');
  rs:=iRecvLines;
  if rs<>354 then
    raise EmsServerError.Create(TempS);
  FData.Position:=0;
  SendStream(FData,0);
  SendLine('');
  SendLine('.');
  rs:=iRecvLines;
  if (rs<>250) then
    raise EmsServerError.Create(TempS);
  DoSent(Self);
end;

procedure TmsSMTPClient.SendMailMessage;
var
  rs : Integer;
begin
  if Debug then
  begin
    SendLine('RSET');
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
  end
  else
  begin
    SendLine('DATA');
    rs:=iRecvLines;
    if rs<>354 then
      raise EmsServerError.Create(TempS);
    TempFileStream.Position:=0;
    SendStream
    (TempFileStream,0);
    SendLine('');
    SendLine('.');
    rs:=iRecvLines;
    if (rs<>250) then
      raise EmsServerError.Create(TempS);
  end;
  DoSent(Self);
end;

function TmsSMTPClient.GetServerReplyCode(const s : string) : Integer;
begin
  Result:=StrToIntDef(Copy(s,1,3),-1);
end;

procedure TmsSMTPClient.SendMail;
begin
  TempFileStream:=TmsTempFileStream.Create;
  try
    if Assigned(FMailMessage) then
      PrepareMessage;
    SendEnvelope;
    if FRejectedRecipients<GetTotalRecipients then
    begin
      if Assigned(FData) then
        SendData
      else
        SendMailMessage;
    end;
  finally
    TempFileStream.Free;
  end;
end;

procedure TmsSMTPClient.Send;
begin
  Login;
  try
    SendMail;
    Logout;
  except
    on EmsServerError do
    begin
      Logout;
      raise;
    end
    else
      raise;
  end;
end;

function TmsSMTPClient.ProcessSMTPCommand(const Cmd: string): Integer;
var
  s: string;
begin
  SendLine(Cmd);
  Result:=iRecvLine(s);
end;

end.
