Unit uFrmDownload;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts, ExtCtrls;

Const // min  sec  ms
  cTIMELIMIT = 60 * 60 * 1000;
  cKEY = '{8EAB7C5B-1C56-4C79-9D4C-A91C28C177C3}';

Type
  TfrmDSRDownload = Class(TForm)
    AppEvents: TApplicationEvents;
    tmClose: TTimer;
    Procedure AppEventsException(Sender: TObject; E: Exception);
    Procedure tmCloseTimer(Sender: TObject);
  Private
  Public
  End;

Var
  fStatus: Integer;

Function StartDSRDownload(pAppKey: String): Longword;

Implementation

Uses
  uCommon, uDSRSettings, uConsts, uDSRDownloadEMail
  ;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: StartCISReceiver
  Author:    vmoura
-----------------------------------------------------------------------------}
Function StartDSRDownload(pAppKey: String): Longword;
Var
  lDSRDownload: TfrmDSRDownload;
  lMutex, lMutex2,
    ltargettime: Cardinal;
  lExec: Boolean;
  lAppKey: String;
  lDown: TDSRDownload;
Begin
  Result := S_FALSE;
  lAppKey := cKey + pAppKey;

  {check for more than one application running}
  If OpenMutex(MUTEX_ALL_ACCESS, false, PChar(lAppKey)) = 0 Then
  Begin
    {avoid calling the application twice}
    lMutex2 := CreateMutex(Nil, False, PChar(lAppKey));

    lDSRDownload := TfrmDSRDownload.Create(Nil);
    Sleep(1000);

    If Assigned(lDSRDownload) Then
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
          Sleep(1000);
        End
        Else
        Begin
        {set the clock to finish if something happens in 24h}
          lDSRDownload.tmClose.Interval := cTIMELIMIT;
          If Not lDSRDownload.tmClose.Enabled Then
            lDSRDownload.tmClose.Enabled := True;

          {create the mutex}
          lMutex := CreateMutex(Nil, false, cKey);
          {get the object to itself}
          WaitForSingleObject(lMutex, INFINITE);

          lDown := Nil;
          Try
            lDown := TDSRDownload.Create;

            If Assigned(lDown) Then
            Try
              lDown.Download;
            Except
              On e: exception Do
                _LogMSG('StartDSRDownload :- An exception has occurred while downloading E-Mails. Error: '
                  + e.Message);
            End;
          Finally
            If Assigned(lDown) Then
              lDown.Free;
          End;

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
    _LogMSG('StartDSRDownload :- There is already one Download System running...');

  Application.Terminate;
End;

{-----------------------------------------------------------------------------
  Procedure: AppEventsException
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRDownload.AppEventsException(Sender: TObject; E: Exception);
Begin
  _LogMSG('TfrmDSRDownload.AppEventsException :- An exception has occurred. Error: '
    + e.Message);
  _LogMSG('TfrmDSRDownload.AppEventsException :- An exception has occurred. Class name: '
    + e.ClassName);
  PostQuitMessage(WM_QUIT);
End;

{-----------------------------------------------------------------------------
  Procedure: tmCloseTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDSRDownload.tmCloseTimer(Sender: TObject);
Begin
  tmClose.Enabled := False;
  Application.Terminate;
End;

End.

