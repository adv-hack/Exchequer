{-----------------------------------------------------------------------------
 Unit Name: uDSROutgoingSystem
 Author:    vmoura
 Purpose: wrapper around the outgoing system...
 History:
-----------------------------------------------------------------------------}
Unit uDSROutgoingSystem;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, DSROutgoing_TLB, StdVcl;

Type
  TDSROutgoingSystem = Class(TAutoObject, IDSROutgoingSystem)
  Protected
    function SendMsg: LongWord; safecall;
    function Get_Authentication: WordBool; safecall;
    function Get_OutgoingPassword: WideString; safecall;
    function Get_OutgoingPort: Integer; safecall;
    function Get_OutgoingServer: WideString; safecall;
    function Get_OutgoingUsername: WideString; safecall;
    function Get_Password: WideString; safecall;
    function Get_ServerType: WideString; safecall;
    function Get_SSLOutgoing: WordBool; safecall;
    function Get_UserName: WideString; safecall;
    procedure Set_Authentication(Value: WordBool); safecall;
    procedure Set_OutgoingPassword(const Value: WideString); safecall;
    procedure Set_OutgoingPort(Value: Integer); safecall;
    procedure Set_OutgoingServer(const Value: WideString); safecall;
    procedure Set_OutgoingUsername(const Value: WideString); safecall;
    procedure Set_Password(const Value: WideString); safecall;
    procedure Set_ServerType(const Value: WideString); safecall;
    procedure Set_SSLOutgoing(Value: WordBool); safecall;
    procedure Set_UserName(const Value: WideString); safecall;
    function Get_YourEmail: WideString; safecall;
    function Get_YourName: WideString; safecall;
    procedure Set_YourEmail(const Value: WideString); safecall;
    procedure Set_YourName(const Value: WideString); safecall;
    function Get_BCC: WideString; safecall;
    function Get_Body: WideString; safecall;
    function Get_CC: WideString; safecall;
    function Get_Files: WideString; safecall;
    function Get_Subject: WideString; safecall;
    function Get_To_: WideString; safecall;
    procedure Set_BCC(const Value: WideString); safecall;
    procedure Set_Body(const Value: WideString); safecall;
    procedure Set_CC(const Value: WideString); safecall;
    procedure Set_Files(const Value: WideString); safecall;
    procedure Set_Subject(const Value: WideString); safecall;
    procedure Set_To_(const Value: WideString); safecall;
  End;

Implementation

Uses ComServ;

function TDSROutgoingSystem.SendMsg: LongWord;
Begin

End;

function TDSROutgoingSystem.Get_Authentication: WordBool;
begin

end;

function TDSROutgoingSystem.Get_OutgoingPassword: WideString;
begin

end;

function TDSROutgoingSystem.Get_OutgoingPort: Integer;
begin

end;

function TDSROutgoingSystem.Get_OutgoingServer: WideString;
begin

end;

function TDSROutgoingSystem.Get_OutgoingUsername: WideString;
begin

end;

function TDSROutgoingSystem.Get_Password: WideString;
begin

end;

function TDSROutgoingSystem.Get_ServerType: WideString;
begin

end;

function TDSROutgoingSystem.Get_SSLOutgoing: WordBool;
begin

end;

function TDSROutgoingSystem.Get_UserName: WideString;
begin

end;

procedure TDSROutgoingSystem.Set_Authentication(Value: WordBool);
begin

end;

procedure TDSROutgoingSystem.Set_OutgoingPassword(const Value: WideString);
begin

end;

procedure TDSROutgoingSystem.Set_OutgoingPort(Value: Integer);
begin

end;

procedure TDSROutgoingSystem.Set_OutgoingServer(const Value: WideString);
begin

end;

procedure TDSROutgoingSystem.Set_OutgoingUsername(const Value: WideString);
begin

end;

procedure TDSROutgoingSystem.Set_Password(const Value: WideString);
begin

end;

procedure TDSROutgoingSystem.Set_ServerType(const Value: WideString);
begin

end;

procedure TDSROutgoingSystem.Set_SSLOutgoing(Value: WordBool);
begin

end;

procedure TDSROutgoingSystem.Set_UserName(const Value: WideString);
begin

end;

function TDSROutgoingSystem.Get_YourEmail: WideString;
begin

end;

function TDSROutgoingSystem.Get_YourName: WideString;
begin

end;

procedure TDSROutgoingSystem.Set_YourEmail(const Value: WideString);
begin

end;

procedure TDSROutgoingSystem.Set_YourName(const Value: WideString);
begin

end;

function TDSROutgoingSystem.Get_BCC: WideString;
begin

end;

function TDSROutgoingSystem.Get_Body: WideString;
begin

end;

function TDSROutgoingSystem.Get_CC: WideString;
begin

end;

function TDSROutgoingSystem.Get_Files: WideString;
begin

end;

function TDSROutgoingSystem.Get_Subject: WideString;
begin

end;

function TDSROutgoingSystem.Get_To_: WideString;
begin

end;

procedure TDSROutgoingSystem.Set_BCC(const Value: WideString);
begin

end;

procedure TDSROutgoingSystem.Set_Body(const Value: WideString);
begin

end;

procedure TDSROutgoingSystem.Set_CC(const Value: WideString);
begin

end;

procedure TDSROutgoingSystem.Set_Files(const Value: WideString);
begin

end;

procedure TDSROutgoingSystem.Set_Subject(const Value: WideString);
begin

end;

procedure TDSROutgoingSystem.Set_To_(const Value: WideString);
begin

end;

Initialization
  TAutoObjectFactory.Create(ComServer, TDSROutgoingSystem,
    Class_DSROutgoingSystem, ciMultiInstance, tmApartment);
End.

