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
  cKey = '{3547F306-B2D5-49D1-A387-E954470D6A44}';

Type
  TfrmVAT100Receiver = Class(TForm)
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

Function StartVAT100Receiver(pAppKey: String): Longword;

Implementation

Uses ComObj, Activex,
  uCommon, uDSRSettings, uconsts,
  VAT100Incoming_TLB, dsrIncoming_tlb;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: StartVAT100Receiver
  Author:    vmoura Arr. Phil Rogers
  Description: This is called from the Project code when the app is created.
-----------------------------------------------------------------------------}
Function StartVAT100Receiver(pAppKey: String): Longword;
Var
  lVAT100Receiver: TfrmVAT100Receiver;
  lMutex, lMutex2,
    ltargettime, lVAT100Time: Cardinal;
  lExec: Boolean;
  lAppKey: String;
  lSender: IDSRIncomingSystem;
Begin
  Result := S_FALSE;
  lAppKey := cKey + pAppKey;

  // Only one instance ofthis application can be run at any time.
  // Check to see if a mutex exists for this app.
  If OpenMutex(MUTEX_ALL_ACCESS, false, PChar(lAppKey)) = 0 Then
  Begin
    // Create a mutex to stop another instance of the app from being created.
    lMutex2 := CreateMutex(Nil, False, PChar(lAppKey));

    // Create the form, which is invisible.  It's just a placeholder for a
    //  timer and application events handler.
    lVAT100Receiver := TfrmVAT100Receiver.Create(Nil);
    // Wait for 3 seconds, which is more than enough time for the app to be created.
    Sleep(3000);

    If Assigned(lVAT100Receiver) Then
    Begin
      // Calculate the target time from the current tick, plus the time limit
      // (Nominally set to 1 hour)
      ltargettime := GetTickCount + cTIMELIMIT;
      lExec := False;

      // Wait until we've passed the target time.
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
          // Set the shutdown timer to twice the time limit.
          lVAT100Receiver.tmClose.Interval := 2 * cTIMELIMIT;
          // Start the timer if it's not already running.
          If Not lVAT100Receiver.tmClose.Enabled Then
            lVAT100Receiver.tmClose.Enabled := True;

          // Create the mutex for this application (cKey is the GUID)
          lMutex := CreateMutex(Nil, false, cKey);
          WaitForSingleObject(lMutex, INFINITE);

          Try
            // Create VAT 100 wrapper receiver object
            Try
              lSender := CreateComObject(CLASS_VAT100Receiving) As IDSRIncomingSystem;
            Except
              On e: exception Do
              Begin
                Result := cERROR;
                _LogMsg('StartVAT100Receiver :- Exception loading VAT100 Receiver. Error: '
                  + e.Message);
              End; {begin}
            End; {try}

            // Limit processing to the time limit (1 hour)
            lVAT100Time := GetTickCount + cTIMELIMIT;

            // Process VAT 100 pending message while such messages exist in the system
            // NB. cCISSENT used deliberately to avoid duplication of consants.
            While lVAT100Receiver.fDb.OutboxMessageStatusExists(0, cCISSENT) And
                  (lVAT100Time > GetTickCount) Do
            Begin
              Try
                If Assigned(lSender) Then
                Begin
                  // This calls CheckNow in the VAT100Receiving COM object.
                  //  See VAT100Incoming.dll - uVAT100Receiving.pas
                  lSender.CheckNow;
                  // Wait for 10 seconds
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
                  _LogMSG('StartVAT100Receiver :- An exception has occurred ' +
                          'calling the VAT100 receiver object. Error: ' +
                          e.Message);
                  lVAT100Receiver.fDb.UpdateIceLog('StartVAT100Receiver',
                    'An exception has occurred calling the VAT100 receiver object. Error: ' +
                    e.Message);
                  Break;
                End; {begin}
              End; {try}
            End; {While lVAT100Receiver.fDb.InboxMessageStatusExists(-1, cPENDING) Do}
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
    End; {if Assigned(lVAT100Receiver) then}
  End
  Else
    _LogMSG('uFrmReceiver :- There is already a VAT100Receiver running...');

  Application.Terminate;
End;

{-----------------------------------------------------------------------------
  Procedure: AppEventsException
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmVAT100Receiver.AppEventsException(Sender: TObject; E: Exception);
Begin
  Sleep(100);
  _LogMSG('TfrmVAT100Receiver.AppEventsException :- An exception has occurred. Error: '
    + e.Message);
  Sleep(200);
  _LogMSG('TfrmVAT100Receiver.AppEventsException :- An exception has occurred. Class name: '
    + e.ClassName);
  PostQuitMessage(WM_QUIT);
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmVAT100Receiver.FormCreate(Sender: TObject);
Begin
  CoInitialize(Nil);

  Try
    fDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On E: Exception Do
      _LogMSG('DSR database error: ' + E.Message);
  End;

  _LogMSG('VAT100 Receiver application ' + inttostr(Application.Handle) +
    ' is about to start...');
End;

{-----------------------------------------------------------------------------
  Procedure: FormClose
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmVAT100Receiver.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  _LogMSG('VAT100 Receiver application ' + inttostr(Application.Handle) +
    ' is about to finish...');

  If Assigned(fDb) Then
    FreeAndNil(fDb);

  CoUninitialize;
End;

{-----------------------------------------------------------------------------
  Procedure: tmCloseTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmVAT100Receiver.tmCloseTimer(Sender: TObject);
Begin
  tmClose.Enabled := False;
  Application.Terminate;
End;

End.

