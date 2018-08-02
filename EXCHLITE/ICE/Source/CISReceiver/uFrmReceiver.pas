{-----------------------------------------------------------------------------
 Unit Name: uFrmReceiver
 Author:    vmoura
 Purpose:
 History:

 the thin application will import a batch or create a new company as required
 there are some ways to this application be finished if something gets wrong...
 any exception not cacht be try/except will finish the application
 if after 30 minutes (or designed time) it did not process anything, it will close the application
 and the last change is the timer that will close the application in event of messages being diplayed or something
 

-----------------------------------------------------------------------------}
Unit uFrmReceiver;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts, uAdoDSR, ExtCtrls;

Const // min  sec  ms
  cTIMELIMIT = 60 * 60 * 1000;
  cKey = '{1015975A-A38F-4E05-911A-6AD9277D5103}';

Type
  TfrmCISReceiver = Class(TForm)
    AppEvents: TApplicationEvents;
    tmClose: TTimer;
    Procedure AppEventsException(Sender: TObject; E: Exception);
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure tmCloseTimer(Sender: TObject);
  Private
    fDb: TADODSR;
  Public
  End;

Var
  fStatus: Integer;

Function StartCISReceiver(pAppKey: String): Longword;

Implementation

Uses ComObj, Activex,
  uCommon, uDSRSettings, uconsts,
  CISIncoming_TLB, dsrIncoming_tlb;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: StartCISReceiver
  Author:    vmoura
-----------------------------------------------------------------------------}
Function StartCISReceiver(pAppKey: String): Longword;
Var
  lCISReceiver: TfrmCISReceiver;
  lMutex, lMutex2,
    ltargettime, lCISTime: Cardinal;
  lExec: Boolean;
  lAppKey: String;
  lSender: IDSRIncomingSystem;
Begin
  Result := S_FALSE;
  lAppKey := cKey + pAppKey;

  {check for more than one application running}
  If OpenMutex(MUTEX_ALL_ACCESS, false, PChar(lAppKey)) = 0 Then
  Begin
    {avoid calling the application twice}
    lMutex2 := CreateMutex(Nil, False, PChar(lAppKey));

    lCISReceiver := TfrmCISReceiver.Create(Nil);
    Sleep(3000);

    If Assigned(lCISReceiver) Then
    Begin
      ltargettime := GetTickCount + cTIMELIMIT;
      lExec := False;

  {the app will try to import during x min. If it fails, it will close the application}
      While (ltargettime > GetTickCount) And Not lExec Do
      Begin
        lMutex := OpenMutex(MUTEX_MODIFY_STATE, false, cKey);

        If lMutex <> 0 Then
        Begin
          CloseHandle(lMutex);
          Sleep(100);
          Application.ProcessMessages;
        End
        Else
        Begin
        {set the clock to finish if something happens in 2h}
          lCISReceiver.tmClose.Interval := 2 * cTIMELIMIT;
          If Not lCISReceiver.tmClose.Enabled Then
            lCISReceiver.tmClose.Enabled := True;

          {create the mutex}
          lMutex := CreateMutex(Nil, false, cKey);
          {get the object to itself}
          WaitForSingleObject(lMutex, INFINITE);

          Try
            {create CIS wrapper receiver object}
            Try
              lSender := CreateComObject(CLASS_CISReceiving) As IDSRIncomingSystem;
            Except
              On e: exception Do
              Begin
                Result := cERROR;
                _LogMsg('StartCISReceiver :- Exception loading CIS Receiver. Error: '
                  + e.Message);
              End; {begin}
            End; {try}

            {avoiding infinite loop}
            lCISTime := GetTickCount + cTIMELIMIT;

            {process cis pending message while those messages exist into the system}
            While lCISReceiver.fDb.OutboxMessageStatusExists(0, cCISSENT) And
              (lCISTime > GetTickCount) Do
            Begin
              Try
                If Assigned(lSender) Then
                Begin
                  lSender.CheckNow;
                  Sleep(10000);
                End
                Else
                Begin
                  Result := cOBJECTNOTAVAILABLE;
                  Break;
                End;
              Except
                On e: Exception Do
                Begin
                  _LogMSG('StartCISReceiver :- An exception has occurred calling the CIS receiver object. Error: '
                    + e.Message);
                  lCISReceiver.fDb.UpdateIceLog('StartCISReceiver',
                    'An exception has occurred calling the CIS receiver object. Error: ' +
                    e.Message);
                  Break;
                End; {begin}
              End; {try}
            End; {While lCISReceiver.fDb.InboxMessageStatusExists(-1, cPENDING) Do}
          Finally
            If Assigned(lSender) Then
            Try
              lSender := Nil;
            Except
            End;
          End; {try}

          {finish the loop and release the mutex}
          lExec := True;
          CloseHandle(lMutex);
        End; {begin}

        Sleep(100);
      End; {While (ltargettime > GetTickCount) And Not lExec Do}

      Closehandle(lMutex2);
    End; {if Assigned(lCISReceiver) then}
  End
  Else
    _LogMSG('uFrmReceiver :- There is already one CISReceiver running...');

  Application.Terminate;
End;

{-----------------------------------------------------------------------------
  Procedure: AppEventsException
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCISReceiver.AppEventsException(Sender: TObject; E: Exception);
Begin
  Sleep(100);
  _LogMSG('TfrmCISReceiver.AppEventsException :- An exception has occurred. Error: '
    + e.Message);
  Sleep(200);
  _LogMSG('TfrmCISReceiver.AppEventsException :- An exception has occurred. Class name: '
    + e.ClassName);
  PostQuitMessage(WM_QUIT);
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCISReceiver.FormCreate(Sender: TObject);
Begin
  CoInitialize(Nil);

  Try
    fDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On E: Exception Do
      _LogMSG('DSR database error: ' + E.Message);
  End;

  _LogMSG('CIS Receiver application ' + inttostr(Application.Handle) +
    ' is about to start...');
End;

{-----------------------------------------------------------------------------
  Procedure: FormClose
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCISReceiver.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  _LogMSG('CIS Receiver application ' + inttostr(Application.Handle) +
    ' is about to finish...');

  If Assigned(fDb) Then
    FreeAndNil(fDb);

  CoUninitialize;
End;

{-----------------------------------------------------------------------------
  Procedure: tmCloseTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCISReceiver.tmCloseTimer(Sender: TObject);
Begin
  tmClose.Enabled := False;
  Application.Terminate;
End;

End.

