{-----------------------------------------------------------------------------
 Unit Name: uDSRIncomingSystem
 Author:    vmoura
 Purpose:
 History:

 Encapsulates necessary parameters for calling the incoming system
-----------------------------------------------------------------------------}
Unit uDSRIncomingSystem;

{$WARN SYMBOL_PLATFORM OFF}

Interface        

Uses
  ComObj, ActiveX, DSRIncoming_TLB, StdVcl;

Type
  TDSRIncomingSystem = Class(TAutoObject, IDSRIncomingSystem)
  Protected
    Procedure CheckNow; Safecall;
    function Get_Authentication: WordBool; safecall;
    function Get_IncomingPort: Integer; safecall;
    function Get_IncomingServer: WideString; safecall;
    function Get_MailBoxName: WideString; safecall;
    function Get_MailBoxSeparator: WideString; safecall;
    function Get_Password: WideString; safecall;
    function Get_ServerType: WideString; safecall;
    function Get_UserName: WideString; safecall;
    function Get_YourName: WideString; safecall;
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
  End;

Implementation

Uses ComServ;

Procedure TDSRIncomingSystem.CheckNow;
Begin

End;

function TDSRIncomingSystem.Get_Authentication: WordBool;
begin

end;

function TDSRIncomingSystem.Get_IncomingPort: Integer;
begin

end;

function TDSRIncomingSystem.Get_IncomingServer: WideString;
begin

end;

function TDSRIncomingSystem.Get_MailBoxName: WideString;
begin

end;

function TDSRIncomingSystem.Get_MailBoxSeparator: WideString;
begin

end;

function TDSRIncomingSystem.Get_Password: WideString;
begin

end;

function TDSRIncomingSystem.Get_ServerType: WideString;
begin

end;

function TDSRIncomingSystem.Get_UserName: WideString;
begin

end;

function TDSRIncomingSystem.Get_YourName: WideString;
begin

end;

procedure TDSRIncomingSystem.Set_Authentication(Value: WordBool);
begin

end;

procedure TDSRIncomingSystem.Set_IncomingPort(Value: Integer);
begin

end;

procedure TDSRIncomingSystem.Set_IncomingServer(const Value: WideString);
begin

end;

procedure TDSRIncomingSystem.Set_MailBoxName(const Value: WideString);
begin

end;

procedure TDSRIncomingSystem.Set_MailBoxSeparator(const Value: WideString);
begin

end;

procedure TDSRIncomingSystem.Set_Password(const Value: WideString);
begin

end;

procedure TDSRIncomingSystem.Set_ServerType(const Value: WideString);
begin

end;

procedure TDSRIncomingSystem.Set_UserName(const Value: WideString);
begin

end;

procedure TDSRIncomingSystem.Set_YourName(const Value: WideString);
begin

end;

function TDSRIncomingSystem.Get_YourEmail: WideString;
begin

end;

procedure TDSRIncomingSystem.Set_YourEmail(const Value: WideString);
begin

end;

Initialization
  TAutoObjectFactory.Create(ComServer, TDSRIncomingSystem,
    Class_DSRIncomingSystem, ciMultiInstance, tmApartment);
End.

