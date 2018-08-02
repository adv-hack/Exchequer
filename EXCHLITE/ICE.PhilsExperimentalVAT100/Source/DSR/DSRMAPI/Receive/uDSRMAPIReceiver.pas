unit uDSRMAPIReceiver;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, DSRMAPIReceive_TLB, StdVcl, dsrincoming_tlb, udsrmailreceiver;

type
  TDSRMAPIReceiver = class(TAutoObject, IDSRMAPIReceiver, IDSRIncomingSystem)
  private
    fMapi: TCheckMAPI;
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

function TDSRMAPIReceiver.Get_Authentication: WordBool;
begin

end;

function TDSRMAPIReceiver.Get_IncomingPort: Integer;
begin

end;

function TDSRMAPIReceiver.Get_IncomingServer: WideString;
begin

end;

function TDSRMAPIReceiver.Get_MailBoxName: WideString;
begin

end;

function TDSRMAPIReceiver.Get_MailBoxSeparator: WideString;
begin

end;

function TDSRMAPIReceiver.Get_Password: WideString;
begin

end;

function TDSRMAPIReceiver.Get_ServerType: WideString;
begin

end;

function TDSRMAPIReceiver.Get_UserName: WideString;
begin

end;

function TDSRMAPIReceiver.Get_YourName: WideString;
begin

end;

procedure TDSRMAPIReceiver.CheckNow;
begin
  Try
    fMAPI.CheckForEmails;
  Except
    On e: exception Do
      _LogMSG('TDSRPOP3Receiver.CheckNow :- Error checking e-mails. Error: ' +
        e.message);
  End;
end;

procedure TDSRMAPIReceiver.Set_Authentication(Value: WordBool);
begin

end;

procedure TDSRMAPIReceiver.Set_IncomingPort(Value: Integer);
begin

end;

procedure TDSRMAPIReceiver.Set_IncomingServer(const Value: WideString);
begin

end;

procedure TDSRMAPIReceiver.Set_MailBoxName(const Value: WideString);
begin

end;

procedure TDSRMAPIReceiver.Set_MailBoxSeparator(const Value: WideString);
begin

end;

procedure TDSRMAPIReceiver.Set_Password(const Value: WideString);
begin
  fMapi.Password := Value;
end;

procedure TDSRMAPIReceiver.Set_ServerType(const Value: WideString);
begin

end;

procedure TDSRMAPIReceiver.Set_UserName(const Value: WideString);
begin
  fMapi.UserName := VAlue;
end;

procedure TDSRMAPIReceiver.Set_YourName(const Value: WideString);
begin

end;

destructor TDSRMAPIReceiver.Destroy;
var
  lCont: Integer;
begin
  If Assigned(fMapi) Then
  Begin
    lCont := 0;
    With fMapi Do
      If Working Then
        Repeat
          Sleep(50);
          Inc(lCont);
        Until Not Working Or (lCont = 100);

    Try
      fMapi.Free;
    Except
      on E:exception do
        _LogMSG('TDSRPOP3Receiver.Destroy :- Error freeing POP3 object. Error: ' + e.Message);
    End;
  End; {If Assigned(fPop3) Then}

  inherited;
end;

procedure TDSRMAPIReceiver.Initialize;
begin
  inherited;
  fMapi := TCheckMAPI.Create;
end;

function TDSRMAPIReceiver.Get_YourEmail: WideString;
begin

end;

procedure TDSRMAPIReceiver.Set_YourEmail(const Value: WideString);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TDSRMAPIReceiver, Class_DSRMAPIReceiver,
    ciMultiInstance, tmApartment);
end.
