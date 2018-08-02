{-----------------------------------------------------------------------------
 Unit Name: uDSREmailSender
 Author:    vmoura
 Purpose:   send e-mails via dsr system
 History:
-----------------------------------------------------------------------------}
Unit uDSREmailSender;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, Sysutils, ActiveX, DSRSender_TLB, DSROutgoing_TLB, StdVcl;
                  
Type
  TDSREmailSender = Class(TAutoObject, IDSREmailSender, IDSROutgoingSystem)
  Private
  Protected
    Function SendMsg(Const pFrom, pTo, pSubject, pBody, pFiles: WideString):
      LongWord; Safecall;
    function SendMsgEx(const pHost: WideString; pPort: Integer; const pFrom,
      pTo, pSubj, pBody, pFiles: WideString): LongWord; safecall;
  Public
    Procedure Initialize; Override;
    Destructor Destroy; Override;
  End;

Implementation

Uses ComServ,
  uDSRSettings,
  uBaseclass,
  uConsts,
  uCommon,
  uDSRSend
  ;

{-----------------------------------------------------------------------------
  Procedure: SendMsg
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSREmailSender.Destroy;
Begin
  CoUninitialize;
  Inherited;
End;

Procedure TDSREmailSender.Initialize;
Begin
  Inherited;
  CoInitialize(Nil);
End;

{-----------------------------------------------------------------------------
  Procedure: SendMsg
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSREmailSender.SendMsg(Const pFrom, pTo, pSubject, pBody, pFiles:
  WideString): LongWord;
Var
  lCont: Integer;
  lLog: _Base;
Begin
  lCont := 0;
  Result := S_OK;

  lLog := _Base.Create;
  lLog.ConnectionString := _DSRFormatConnectionString(_DSRGetDBServer);

  While lCont < 3 Do
  Begin
    Try
      Result := TDSRSend.Send(pFrom, pTo, pSubject, pBody, pFiles);
    Except
      On e: Exception Do
      Begin
        Result := cERRORSENDINGEMAIL;
        lLog.DoLogMessage('TDSREmailSender.SendMsg', Result,
          'Error sending E-Mail. Error: ' + e.Message, True, True);
      End; {begin}
    End; {try}

    Inc(lCont);

    If Result = S_OK Then
      break
    Else
    Begin
      Result := cERRORSENDINGEMAIL;
      lLog.DoLogMessage('TDSREmailSender.SendMsg', 0,
        'Message could not be sent. The system will retry once again...', True, True);
      Sleep(2 * cDEFAULTPAUSE);
    End; {begin}
  End; {While lCont < 3 Do}

  lLog.Free;
End;

{-----------------------------------------------------------------------------
  Procedure: SendMsgEx
  Author:    vmoura
-----------------------------------------------------------------------------}
function TDSREmailSender.SendMsgEx(const pHost: WideString; pPort: Integer;
  const pFrom, pTo, pSubj, pBody, pFiles: WideString): LongWord;
Var
  lCont: Integer;
  lLog: _Base;
Begin
  lCont := 0;

  lLog := _Base.Create;
  lLog.ConnectionString := _DSRFormatConnectionString(_DSRGetDBServer);

  While lCont < 3 Do
  Begin
    Try
      Result := TDSRSend.Send(pFrom, pTo, pSubj, pBody, pFiles, pHost, pPort);
    Except
      On e: Exception Do
      Begin
        Result := cERRORSENDINGEMAIL;
        lLog.DoLogMessage('TDSREmailSender.SendMsg', Result,
          'Error sending e-mail. Error: ' + e.Message, True, True);
      End; {begin}
    End; {try}

    Inc(lCont);

    If Result = S_OK Then
      break
    Else
    Begin
      Result := cERRORSENDINGEMAIL;
      lLog.DoLogMessage('TDSREmailSender.SendMsg', 0,
        'Message could not be sent. The system will retry once again...', True, True);
      Sleep(2 * cDEFAULTPAUSE);
    End; {begin}
  End; {While lCont < 3 Do}

  lLog.Free;
end;

Initialization
  TAutoObjectFactory.Create(ComServer, TDSREmailSender, Class_DSREmailSender,
    ciMultiInstance, tmApartment);
End.

