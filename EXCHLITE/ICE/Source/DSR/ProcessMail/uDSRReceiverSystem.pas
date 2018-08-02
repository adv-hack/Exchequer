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
  ComObj, ActiveX, DSRProcessMail_TLB, StdVcl;
              
Type
  TDSRProcessMailSystem = Class(TAutoObject, IDSRProcessMailSystem)
  Protected
    Function Receive(Const pSubject, pSender, pTo, pFiles: WideString):
      LongWord; Safecall;
  End;

Implementation

Uses ComServ, SysUtils, Classes,
  uConsts,
  uCommon,
  uDSRReceive
  ;

{-----------------------------------------------------------------------------
  Procedure: Receive
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRProcessMailSystem.Receive(Const pSubject, pSender, pTo,
  pFiles: WideString): LongWord;
var
  lFiles: TStringList;
Begin
  lFiles:= TStringList.Create;
  try
    if pFiles <> '' then
      lFiles.CommaText := pFiles;

    Try
      Result := TDSRReceive.Receive(pSubject, pSender, pTo, lFiles);
    Except
      On e: Exception Do
      Begin
        Result := cERROR;
        _LogMSG('TDSRProcessMailSystem.Receive :- Error processing message. Error: ' +
          e.Message);
      End; {begin}
    End; {try}
  finally
    lFiles.Free;
  end;
End;

Initialization
  TAutoObjectFactory.Create(ComServer, TDSRProcessMailSystem,
    Class_DSRProcessMailSystem, ciMultiInstance, tmApartment);
End.

