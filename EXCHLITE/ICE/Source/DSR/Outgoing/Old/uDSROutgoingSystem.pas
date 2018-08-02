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
    Function SendMsg(Const pFrom, pTo, pSubject, pBody,
      pFiles: WideString): LongWord; Safecall;
    function SendMsgEx(const pHost: WideString; pPort: Integer; const pFrom,
      pTo, pSubj, pBody, pFiles: WideString): LongWord; safecall;
    { Protected declarations }
  End;

Implementation

Uses ComServ;

Function TDSROutgoingSystem.SendMsg(Const pFrom, pTo, pSubject, pBody,
  pFiles: WideString): LongWord;
Begin

End;

function TDSROutgoingSystem.SendMsgEx(const pHost: WideString;
  pPort: Integer; const pFrom, pTo, pSubj, pBody,
  pFiles: WideString): LongWord;
begin

end;

Initialization
  TAutoObjectFactory.Create(ComServer, TDSROutgoingSystem,
    Class_DSROutgoingSystem, ciMultiInstance, tmApartment);
End.

