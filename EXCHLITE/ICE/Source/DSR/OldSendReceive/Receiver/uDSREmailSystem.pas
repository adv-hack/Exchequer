Unit uDSREmailSystem;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, DSRReceiver_TLB, DSRIncoming_TLB, StdVcl,
  uDSRMailPoll
  ;                

Type
  TDSRReceiverSystem = Class(TAutoObject, IDSRIncomingSystem, IDSRReceiverSystem)
  Private
    fMail: TDSRMailPoll;
  Protected
    Procedure CheckNow; Safecall;
    Function Get_EmailType: Smallint; Safecall;
    Procedure Set_EmailType(Value: Smallint); Safecall;
    function Get_Password: WideString; safecall;
    function Get_POP3Server: WideString; safecall;
    function Get_POPAddress: WideString; safecall;
    function Get_SMTPServer: WideString; safecall;
    function Get_Username: WideString; safecall;
    function Get_YourName: WideString; safecall;
    procedure Set_Password(const Value: WideString); safecall;
    procedure Set_POP3Server(const Value: WideString); safecall;
    procedure Set_POPAddress(const Value: WideString); safecall;
    procedure Set_SMTPServer(const Value: WideString); safecall;
    procedure Set_Username(const Value: WideString); safecall;
    procedure Set_YourName(const Value: WideString); safecall;
    function Get_POP3Port: Integer; safecall;
    function Get_SMTPPort: Integer; safecall;
    procedure Set_POP3Port(Value: Integer); safecall;
    procedure Set_SMTPPort(Value: Integer); safecall;
  Public
    Procedure Initialize; Override;
    Destructor Destroy; Override;
  End;

Implementation

Uses ComServ, Windows, Sysutils,
  uCommon, MAILPOLL
  ;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRReceiverSystem.Destroy;
Var
  lCont: Integer;
Begin
  If Assigned(fMail) Then
  Begin
    lCont := 0;
    With fMail Do
      If Working Then
        Repeat
          Sleep(50);
          Inc(lCont);
        Until Not Working Or (lCont = 100);

    Try
      fMail.Free;
    Except
      on E:exception do
        _LogMSG('TDSREmailSystem.Destroy :- Error freeing E-Mail object. Error: ' + e.Message);
    End;
  End; {If Assigned(lMailPoll) Then}

  Inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: Initialize
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRReceiverSystem.Initialize;
Begin
  Inherited;

  Try
    fMail := TDSRMailPoll.Create;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: CheckNow
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRReceiverSystem.CheckNow;
Begin
  If Assigned(fMail) Then
  Try
    fMail.CheckNow;
  Except
    On e: exception Do
      _LogMSG('TDSREmailSystem.CheckNow :- Error checking e-mail. Error: ' +
        e.message);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_EmailType
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRReceiverSystem.Get_EmailType: Smallint;
Begin
  If Assigned(fMail) Then
    Result := Ord(fMail.EmailType);
End;

{-----------------------------------------------------------------------------
  Procedure: Set_EmailType
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRReceiverSystem.Set_EmailType(Value: Smallint);
Begin
  If Assigned(fMail) Then
    fMail.EmailType := TEmailType(Value);
End;

{-----------------------------------------------------------------------------
  Procedure: Get_Password
  Author:    vmoura
-----------------------------------------------------------------------------}
function TDSRReceiverSystem.Get_Password: WideString;
begin
  If Assigned(fMail) Then
    Result := fMail.Pop3Password;
end;

{-----------------------------------------------------------------------------
  Procedure: Get_POP3Server
  Author:    vmoura
-----------------------------------------------------------------------------}
function TDSRReceiverSystem.Get_POP3Server: WideString;
begin
  If Assigned(fMail) Then
    Result := fMail.Pop3Server;
end;

{-----------------------------------------------------------------------------
  Procedure: Get_POPAddress
  Author:    vmoura
-----------------------------------------------------------------------------}
function TDSRReceiverSystem.Get_POPAddress: WideString;
begin
  If Assigned(fMail) Then
    Result := fMail.Pop3Address;
end;

{-----------------------------------------------------------------------------
  Procedure: Get_SMTPServer
  Author:    vmoura
-----------------------------------------------------------------------------}
function TDSRReceiverSystem.Get_SMTPServer: WideString;
begin
  Result := '';
end;

{-----------------------------------------------------------------------------
  Procedure: Get_Username
  Author:    vmoura
-----------------------------------------------------------------------------}
function TDSRReceiverSystem.Get_Username: WideString;
begin
  If Assigned(fMail) Then
    Result := fMail.Pop3UserName;
end;

{-----------------------------------------------------------------------------
  Procedure: Get_YourName
  Author:    vmoura
-----------------------------------------------------------------------------}
function TDSRReceiverSystem.Get_YourName: WideString;
begin
  Result := '';
end;

{-----------------------------------------------------------------------------
  Procedure: Set_Password
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TDSRReceiverSystem.Set_Password(const Value: WideString);
begin
  If Assigned(fMail) Then
    fMail.Pop3Password := Value;
end;

{-----------------------------------------------------------------------------
  Procedure: Set_POP3Server
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TDSRReceiverSystem.Set_POP3Server(const Value: WideString);
begin
  If Assigned(fMail) Then
    fMail.Pop3Server := Value;
end;

{-----------------------------------------------------------------------------
  Procedure: Set_POPAddress
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TDSRReceiverSystem.Set_POPAddress(const Value: WideString);
begin
  If Assigned(fMail) Then
    fMail.Pop3Address := Value;
end;

{-----------------------------------------------------------------------------
  Procedure: Set_SMTPServer
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TDSRReceiverSystem.Set_SMTPServer(const Value: WideString);
begin

end;

{-----------------------------------------------------------------------------
  Procedure: Set_Username
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TDSRReceiverSystem.Set_Username(const Value: WideString);
begin
  If Assigned(fMail) Then
    fMail.Pop3UserName := Value;
end;

{-----------------------------------------------------------------------------
  Procedure: Set_YourName
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TDSRReceiverSystem.Set_YourName(const Value: WideString);
begin

end;

{-----------------------------------------------------------------------------
  Procedure: Get_POP3Port
  Author:    vmoura
-----------------------------------------------------------------------------}
function TDSRReceiverSystem.Get_POP3Port: Integer;
begin
  If Assigned(fMail) Then
    Result := fMail.POP3Port;
end;

{-----------------------------------------------------------------------------
  Procedure: Get_SMTPPort
  Author:    vmoura
-----------------------------------------------------------------------------}
function TDSRReceiverSystem.Get_SMTPPort: Integer;
begin
  If Assigned(fMail) Then
    Result := fMail.SMTPPort;
end;

{-----------------------------------------------------------------------------
  Procedure: Set_POP3Port
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TDSRReceiverSystem.Set_POP3Port(Value: Integer);
begin
  If Assigned(fMail) Then
    fMail.POP3Port := Value;
end;

{-----------------------------------------------------------------------------
  Procedure: Set_SMTPPort
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TDSRReceiverSystem.Set_SMTPPort(Value: Integer);
begin
  If Assigned(fMail) Then
    fMail.SMTPPort := Value;
end;

Initialization
  TAutoObjectFactory.Create(ComServer, TDSRReceiverSystem, Class_DSRReceiverSystem,
    ciMultiInstance, tmApartment);
End.

