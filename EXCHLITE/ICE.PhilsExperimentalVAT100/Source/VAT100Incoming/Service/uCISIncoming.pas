{-----------------------------------------------------------------------------
 Unit Name: uCISIncoming
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uCISIncoming;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr

  ;

Type
  TCISService = Class(TService)
    Procedure ServiceStart(Sender: TService; Var Started: Boolean);
    Procedure ServiceStop(Sender: TService; Var Stopped: Boolean);
    Procedure ServiceExecute(Sender: TService);
  Private
    Procedure ProcessGGWPendingMessages;
  Public
    Function GetServiceController: TServiceController; Override;
  End;

Var
  CISService: TCISService;

Implementation

Uses Activex,
  uCommon,
  uInterfaces,
  uConsts,
  uADODSR,
  uDSRSettings
  ;

{$R *.DFM}

{-----------------------------------------------------------------------------
  Procedure: ServiceController
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure ServiceController(CtrlCode: DWord); Stdcall;
Begin
  CISService.Controller(CtrlCode);
End;

{-----------------------------------------------------------------------------
  Procedure: GetServiceController
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TCISService.GetServiceController: TServiceController;
Begin
  Result := ServiceController;
End;

{-----------------------------------------------------------------------------
  Procedure: ServiceStart
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISService.ServiceStart(Sender: TService; Var Started: Boolean);
Begin
  CoInitialize(Nil);
End;

{-----------------------------------------------------------------------------
  Procedure: ServiceStop
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISService.ServiceStop(Sender: TService; Var Stopped: Boolean);
Begin
  CoUninitialize;
End;

{-----------------------------------------------------------------------------
  Procedure: ServiceExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISService.ServiceExecute(Sender: TService);
Begin
  While Not Terminated Do
  Begin
    ServiceThread.ProcessRequests(False);

    {$IFDEF DEBUG}
     Sleep(15000);
    {$ENDIF}


//    ProcessGGWPendingMessages;

    // avoid half cpu processing...
    Sleep(2);
  End; {While Not Terminated Do}
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessGGWPendingMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISService.ProcessGGWPendingMessages;
Var
  lPend: Olevariant; {get ggw pending messages}
  lRes: Longword;
  lCont, lTotal: Integer;
  lMsg: TMessageInfo; {outbox message}
  lCisMsg: TCISMessage; {cis message info}
  lDb: TADODSR;
Begin
  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On e: exception Do
      _LogMSG('TCISService.ProcessGGWPendingMessages :- Error connection database. Error: '
        + e.Message);
  End; {try}

  If Assigned(lDb) And lDb.Connected Then
  Begin
    lPend := lDb.GetOutboxMessages(-1, 0, cPENDING, 0, 0, lRes, False);
    lTotal := _GetOlevariantArraySize(lPend);
    {check the result}
    If lTotal > 0 Then
    Begin
      For lCont := 0 To lTotal - 1 Do
      Begin
        lMsg := _CreateOutboxMsgInfo(lPend[lCont]);
        If Assigned(lMsg) Then
        Begin
          {load a cis message detail}
          lCisMsg := _CreateCISMsgInfo(lDb.GetCISMessageDetail(lMsg.Guid));
          If Assigned(lCisMsg) Then
          Begin

            FreeAndNil(lCisMsg);
          End; {if Assigned(lCisMsg) then}

          FreeAndNil(lMsg);
        End; {if Assigned(lMsg) then}
      End; {for lCont:= 0 to lTotal - 1 do}
    End; {if _GetOlevariantArraySize(lPend) > 0 then}

    lDb.Free;
  End {if Assigned(fDb) and fDb.Connected then}
  Else
    _LogMSG('TCISReceiving.ProcessGGWPendingMessages :- Could not process GGW Pending messages. Db is not connected...')
End;

End.

