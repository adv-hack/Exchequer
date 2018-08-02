unit uDSRIMAPReceiver;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, DSRIMAPReceive_TLB, StdVcl, dsrincoming_tlb, udsrmailreceiver;

type

  TDSRIMAPReceiver = class(TAutoObject, IDSRIMAPReceiver, IDSRIncomingSystem)
  private
    fIMAP: TCheckIMAP;
  protected
    function Get_Authentication: WordBool; safecall;
    function Get_IncomingPort: Integer; safecall;
    function Get_IncomingServer: WideString; safecall;
    function Get_MailBoxName: WideString; safecall;
    function Get_MailBoxSeparator: WideString; safecall;
    function Get_Password: WideString; safecall;
    function Get_ServerType: WideString; safecall;
    function Get_UserName: WideString; safecall;
    function Get_YourName: WideString; safecall;
    procedure CheckNow; safecall;
    procedure Set_Authentication(Value: WordBool); safecall;
    procedure Set_IncomingPort(Value: Integer); safecall;
    procedure Set_IncomingServer(const Value: WideString); safecall;
    procedure Set_MailBoxName(const Value: WideString); safecall;
    procedure Set_MailBoxSeparator(const Value: WideString); safecall;
    procedure Set_Password(const Value: WideString); safecall;
    procedure Set_ServerType(const Value: WideString); safecall;
    procedure Set_UserName(const Value: WideString); safecall;
    procedure Set_YourName(const Value: WideString); safecall;
    function Get_YourEmail: WideString; safecall;
    procedure Set_YourEmail(const Value: WideString); safecall;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

implementation

uses ComServ, Sysutils,
  uCommon
  ;
function TDSRIMAPReceiver.Get_Authentication: WordBool;
begin
  REsult := fIMAP.UseAuthentication;
end;

function TDSRIMAPReceiver.Get_IncomingPort: Integer;
begin
  Result := fIMAP.IncomingPort;
end;

function TDSRIMAPReceiver.Get_IncomingServer: WideString;
begin
  Result := fIMAP.Host;
end;

function TDSRIMAPReceiver.Get_MailBoxName: WideString;
begin
  Result := fIMAP.MailBox;
end;

function TDSRIMAPReceiver.Get_MailBoxSeparator: WideString;
begin
  Result := fImap.MailBoxSeparator;                                  
end;

function TDSRIMAPReceiver.Get_Password: WideString;
begin
  Result := fIMAP.Password;
end;

function TDSRIMAPReceiver.Get_ServerType: WideString;
begin

end;

function TDSRIMAPReceiver.Get_UserName: WideString;
begin
  Result := fIMAP.UserName;
end;

function TDSRIMAPReceiver.Get_YourName: WideString;
begin

end;

procedure TDSRIMAPReceiver.CheckNow;
begin
  Try
    fImap.CheckForEmails;
  Except
    On e: exception Do
      _LogMSG('TDSRIMAPReceiver.CheckNow :- Error checking e-mails. Error: ' +
        e.message);
  End;
end;

procedure TDSRIMAPReceiver.Set_Authentication(Value: WordBool);
begin
  fIMAP.UseAuthentication := Boolean(Value);
end;

procedure TDSRIMAPReceiver.Set_IncomingPort(Value: Integer);
begin
  fIMAP.IncomingPort := Value;
end;

procedure TDSRIMAPReceiver.Set_IncomingServer(const Value: WideString);
begin
  fIMAP.Host := Value;
end;

procedure TDSRIMAPReceiver.Set_MailBoxName(const Value: WideString);
begin
  fIMAP.MailBox := Value;  
end;

procedure TDSRIMAPReceiver.Set_MailBoxSeparator(const Value: WideString);
begin                         
  if Trim(Value) <> '' then
  try
    fIMAP.MailBoxSeparator := String(Value)[1];
  except
    fIMAP.MailBoxSeparator := '/';
  end;
end;

procedure TDSRIMAPReceiver.Set_Password(const Value: WideString);
begin
  fIMAP.Password := value;
end;

procedure TDSRIMAPReceiver.Set_ServerType(const Value: WideString);
begin

end;

procedure TDSRIMAPReceiver.Set_UserName(const Value: WideString);
begin
  fIMAP.UserName := Value;
end;

procedure TDSRIMAPReceiver.Set_YourName(const Value: WideString);
begin

end;

destructor TDSRIMAPReceiver.Destroy;
var
  lCont: Integer;
begin
  If Assigned(fIMAP) Then
  Begin
    lCont := 0;
    With fIMAP Do
      If Working Then
        Repeat
          Sleep(50);
          Inc(lCont);
        Until Not Working Or (lCont = 100);

    Try
      fIMAP.Free;
    Except
      on E:exception do
        _LogMSG('TDSRIMAPReceiver.Destroy :- Error freeing IMAP object. Error: ' + e.Message);
    End;
  End; {If Assigned(fPop3) Then}

  inherited;
end;

procedure TDSRIMAPReceiver.Initialize;
begin
  inherited;
  fIMAP:= TCheckIMAP.Create;
end;

function TDSRIMAPReceiver.Get_YourEmail: WideString;
begin

end;

procedure TDSRIMAPReceiver.Set_YourEmail(const Value: WideString);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TDSRIMAPReceiver, Class_DSRIMAPReceiver,
    ciMultiInstance, tmApartment);
end.
