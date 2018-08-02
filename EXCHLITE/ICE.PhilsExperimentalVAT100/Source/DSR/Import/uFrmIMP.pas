{-----------------------------------------------------------------------------
 Unit Name: uFrmIMP
 Author:    vmoura
 Purpose:
 History:

 the thin application will import a batch or create a new company as required
 there are some ways to this application be finished if something gets wrong...
 any exception not cacht be try/except will finish the application
 if after 30 minutes (or designed time) it did not process anything, it will close the application
 and the last change is the timer that will close the application in event of messages being diplayed or something
 

-----------------------------------------------------------------------------}
Unit uFrmIMP;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts, uDSRImport, uAdoDSR, ExtCtrls;

Const // min  sec  ms
  cTIMELIMIT = 60 * 60 * 1000;
  cKey = '{80C069BC-60A9-4759-A11C-D917F38F532D}';

Type
  TfrmImp = Class(TForm)
    AppEvents: TApplicationEvents;
    tmClose: TTimer;
    Procedure AppEventsException(Sender: TObject; E: Exception);
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure tmCloseTimer(Sender: TObject);
  Private
    fDb: TADODSR;
    fMsgGuid: String;
    Function GetMsgStatus: Integer;
    Procedure SetMsgStatus(Const Value: Integer);
  Public
    Function CallImport(Const pComp, pGuid, pPackId: String): Longword;
    Property MsgStatus: Integer Read GetMsgStatus Write SetMsgStatus;
    Property MsgGuid: String Read fMsgGuid Write fMsgGuid;
  End;

Var
  (*frmImp: TfrmImp;*)
  fStatus: Integer;

Function StartImport(Const pComp, pGuid, pPackId: String): Longword;

Implementation

Uses Activex, uCommon, uDSRSettings, uconsts;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: StartImport
  Author:    vmoura
-----------------------------------------------------------------------------}
Function StartImport(Const pComp, pGuid, pPackId: String): Longword;
Var
  lImp: TfrmImp;
  lMutex, lMutex2,
    ltargettime: Cardinal;
  lExec: Boolean;
  lStatus: Integer;
  lAppKey: String;
Begin
  Result := S_FALSE;
  lAppKey := cKey + ' ' + pComp + ' ' + pGuid;

  If OpenMutex(MUTEX_ALL_ACCESS, false, PChar(lAppKey)) = 0 Then
  Begin
    {avoid calling the application twice}
    lMutex2 := CreateMutex(Nil, False, PChar(lAppKey));

    _CallDebugLog(inttostr(Application.Handle) + ' starting');

    lImp := TfrmImp.Create(Nil);
    Sleep(3000);

    If Assigned(lImp) Then
    Begin
      _CallDebugLog(inttostr(Application.Handle) + ' get guid');
      lImp.MsgGuid := pGuid;

      ltargettime := GetTickCount + cTIMELIMIT;
      lExec := False;
      lImp.MsgStatus := cPROCESSING;
      lStatus := cPROCESSING;

      _CallDebugLog(inttostr(Application.Handle) + ' get status');

  {the app will try to import during x min. If it fails, it will close the application}
      While (ltargettime > GetTickCount) And Not lExec Do
      Begin
        lMutex := OpenMutex(MUTEX_MODIFY_STATE, false, cKey);

        If lMutex <> 0 Then
        Begin
          CloseHandle(lMutex);
          Sleep(100);
        End
        Else
        Begin
          _CallDebugLog(inttostr(Application.Handle) + ' starting timer');

        {set the clock to finish if something happens in 24h}
          lImp.tmClose.Interval := 24 * cTIMELIMIT;
          If Not lImp.tmClose.Enabled Then
            lImp.tmClose.Enabled := True;

      {create the mutex}
          lMutex := CreateMutex(Nil, false, cKey);
      {get the object to itself}
          WaitForSingleObject(lMutex, INFINITE);
      {call import}

          _CallDebugLog(inttostr(Application.Handle) + ' wait for single object');

//          Sleep(100);
          Try
            Result := lImp.CallImport(pComp, pGuid, pPackId);
          Except
            On e: exception Do
            Begin
              _LogMSG('StartImport :- An exception has occurred calling the import object. Error: '
                + e.Message);
              lImp.fDb.UpdateIceLog('StartImport',
                'An exception has occurred calling the import object. Error: ' +
                e.Message);
            End; {begin}
          End; {try}

          _CallDebugLog(inttostr(Application.Handle) + ' get status 2');
          Try
            lStatus := lImp.MsgStatus;
          Except
          End;

      {finish the loop and release the mutex}
          lExec := True;
          CloseHandle(lMutex);
        End; {begin}

        Sleep(100);

//        Application.ProcessMessages;
      End; {While (ltargettime > GetTickCount) And Not lExec Do}

      Closehandle(lMutex2);

  {chek the status of the message}
      If (lStatus = -1) Or (lStatus = cPROCESSING) Then
      Begin
        _CallDebugLog(inttostr(Application.Handle) + ' get status 3');
        Sleep(100);
        _LogMSG('The message ' + pGuid +
          ' has failed to import due a failure or timeout. The status will change to ready to import.');

        Try
          lImp.MsgStatus := cFAILED;
        Except
        End;
      End; {If (lStatus = -1) Or (lStatus = cPROCESSING) Then}
    End; {if Assigned(lImp) then}
  End
  Else
    _LogMSG('DSRImp :- The Import application is already running...');

  Application.Terminate;
End;

{-----------------------------------------------------------------------------
  Procedure: AppEventsException
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmImp.AppEventsException(Sender: TObject; E: Exception);
Begin
  _LogMSG('TfrmImp.AppEventsException :- An exception has occurred. Error: ' + e.Message);
  _LogMSG('TfrmImp.AppEventsException :- An exception has occurred. Class name: ' + e.ClassName);
  PostQuitMessage(WM_QUIT);
End;

{-----------------------------------------------------------------------------
  Procedure: CallImport
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmImp.CallImport(Const pComp, pGuid, pPackId: String): Longword;
Var
  lGuid: TGuid;
Begin
  _CallDebugLog(inttostr(Application.Handle) + ' call import');
  _CallDebugLog(inttostr(Application.Handle) + ' parameters -> Comp = ' + pComp
    + ' Guid = ' + pGuid + ' Pack = ' + pPackId);

  If _IsValidGuid(pGuid) Then
  Begin
    FillChar(lGuid, SizeOf(Tguid), 0);
    Try
      lGuid := StringToGUID(pGuid);
    Except
      on e:exception do
      begin
        _LogMSG('TfrmImp.CallImport :- Error converting E-Mail ID. Error: ' + e.Message + '. ID: ' + pGuid);
        lGuid := _SafeStringToGuid(pGuid);
      end; {begin}
    End; {try}
  End; {If _IsValidGuid(pGuid) Then}

  Result := S_FALSE;
  Try
    Result := TDSRImport.CallImport(strtoint(pComp), lGuid, strtoint(pPackId), False)
  Except
    On e: exception Do
      _LogMSG('TfrmImp.CallImport :- Error calling import method. Error: ' +
        e.message);
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: GetMsgStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmImp.GetMsgStatus: Integer;
Begin
  Result := -1;
  If Assigned(fDb) And fDb.Connected Then
  Try
    Result := fDb.GetInboxMessageStatus(_SafeStringToGuid(fMsgGuid));
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SetMsgStatus
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmImp.SetMsgStatus(Const Value: Integer);
Begin
  _CallDebugLog(inttostr(Application.Handle) + ' set status');
  If Assigned(fDb) And fDb.Connected Then
  Try
    fDb.SetInboxMessageStatus(_SafeStringToGuid(fMsgGuid), Value);
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmImp.FormCreate(Sender: TObject);
Begin
  CoInitialize(Nil);

  Try
    fDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On E: Exception Do
      _LogMSG('TfrmImp.FormCreate :- Error connecting the Database. Error: ' + E.Message);
  End;

  _LogMSG('Import application ' + inttostr(Application.Handle) +  ' is about to start...');
End;

{-----------------------------------------------------------------------------
  Procedure: FormClose
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmImp.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  _CallDebugLog(inttostr(Application.Handle) + ' form close');
  Try
    If MsgStatus In [cPROCESSING, cPOPULATING] Then
      MsgStatus := cFailed;
  Except
  End;

  If Assigned(fDb) Then
    FreeAndNil(fDb);

  CoUninitialize;
End;

{-----------------------------------------------------------------------------
  Procedure: tmCloseTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmImp.tmCloseTimer(Sender: TObject);
Begin
  tmClose.Enabled := False;
  _CallDebugLog(inttostr(Application.Handle) + ' timer event');
  Try
    MsgStatus := cFAILED;
  Except
  End;

  Application.Terminate;
End;

End.

