{-----------------------------------------------------------------------------
 Unit Name: uDSRReceiverSystem
 Author:    vmoura
 Purpose: process an incoming email
 History:

-----------------------------------------------------------------------------}
Unit uDSRReceiverSystem;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, DSRReceiver_TLB, StdVcl;

Type
  TDSRReceiverSystem = Class(TAutoObject, IDSRReceiverSystem)
  Protected
    Function Receive(Const pSubject, pSender, pTo, pFiles: WideString):
      LongWord; Safecall;
  End;

Implementation

Uses ComServ, SysUtils,
  uConsts,
  uCommon,
  uDSRReceive
  ;

{-----------------------------------------------------------------------------
  Procedure: Receive
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRReceiverSystem.Receive(Const pSubject, pSender, pTo,
  pFiles: WideString): LongWord;
Begin
  Try
    Result := TDSRReceive.Receive(pSubject, pSender, pTo, pFiles);
  Except
    On e: Exception Do
    Begin
      Result := cERROR;
      _LogMSG('TDSRReceiverSystem.Receive :- Error processing message. Error: ' +
        e.Message);
    End; {begin}
  End; {try}
End;

Initialization
  TAutoObjectFactory.Create(ComServer, TDSRReceiverSystem,
    Class_DSRReceiverSystem, ciMultiInstance, tmApartment);
End.

