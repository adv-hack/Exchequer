unit uDSRPOP3Receiver;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, DSRPOP3Receive_TLB, StdVcl, dsrincoming_tlb, udsrmailreceiver;

type
  TDSRPOP3Receiver = class(TAutoObject, IDSRPOP3Receiver, IDSRIncomingSystem)
  private
    fPOP3: TCheckPOP3;
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

function TDSRPOP3Receiver.Get_Authentication: WordBool;
begin
  Result := fPOP3.UseAuthentication;
end;

function TDSRPOP3Receiver.Get_IncomingPort: Integer;
begin
  Result := fPOP3.IncomingPort;
end;

function TDSRPOP3Receiver.Get_IncomingServer: WideString;
begin
  Result := fPOP3.Host;
end;

function TDSRPOP3Receiver.Get_MailBoxName: WideString;
begin

end;

function TDSRPOP3Receiver.Get_MailBoxSeparator: WideString;
begin

end;

function TDSRPOP3Receiver.Get_Password: WideString;
begin
  Result := fPOP3.Password;
end;

function TDSRPOP3Receiver.Get_ServerType: WideString;
begin

end;

function TDSRPOP3Receiver.Get_UserName: WideString;
begin
  Result := fPOP3.UserName;
end;

function TDSRPOP3Receiver.Get_YourName: WideString;
begin

end;

procedure TDSRPOP3Receiver.CheckNow;
begin
  Try
    fPOP3.CheckForEmails;
  Except
    On e: exception Do
      _LogMSG('TDSRPOP3Receiver.CheckNow :- Error checking e-mails. Error: ' +
        e.message);
  End;
end;

procedure TDSRPOP3Receiver.Set_Authentication(Value: WordBool);
begin
  fPOP3.UseAuthentication := Boolean(Value);
end;

procedure TDSRPOP3Receiver.Set_IncomingPort(Value: Integer);
begin
  fPOP3.IncomingPort := VAlue;
end;

procedure TDSRPOP3Receiver.Set_IncomingServer(const Value: WideString);
begin
  fPOP3.Host := Value;
end;

procedure TDSRPOP3Receiver.Set_MailBoxName(const Value: WideString);
begin

end;

procedure TDSRPOP3Receiver.Set_MailBoxSeparator(const Value: WideString);
begin

end;

procedure TDSRPOP3Receiver.Set_Password(const Value: WideString);
begin
  fPOP3.Password := Value;
end;

procedure TDSRPOP3Receiver.Set_ServerType(const Value: WideString);
begin

end;

procedure TDSRPOP3Receiver.Set_UserName(const Value: WideString);
begin
  fPOP3.UserName := Value;
end;

procedure TDSRPOP3Receiver.Set_YourName(const Value: WideString);
begin

end;

destructor TDSRPOP3Receiver.Destroy;
var
  lCont: Integer;
begin
  If Assigned(fPop3) Then
  Begin
    lCont := 0;
    With fPop3 Do
      If Working Then
        Repeat
          Sleep(50);
          Inc(lCont);
        Until Not Working Or (lCont = 100);

    Try
      fPop3.Free;
    Except
      on E:exception do
        _LogMSG('TDSRPOP3Receiver.Destroy :- Error freeing POP3 object. Error: ' + e.Message);
    End;
  End; {If Assigned(fPop3) Then}

  inherited;
end;

procedure TDSRPOP3Receiver.Initialize;
begin
  inherited;
  fPOP3:= TCheckPOP3.Create;
end;

function TDSRPOP3Receiver.Get_YourEmail: WideString;
begin

end;

procedure TDSRPOP3Receiver.Set_YourEmail(const Value: WideString);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TDSRPOP3Receiver, Class_DSRPOP3Receiver,
    ciMultiInstance, tmApartment);
end.
