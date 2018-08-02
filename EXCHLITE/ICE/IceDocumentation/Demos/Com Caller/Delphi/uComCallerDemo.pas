{-----------------------------------------------------------------------------
 Unit Name: uComCallerDemo
 Author:
 Purpose: Example of Com Caller
 History:
-----------------------------------------------------------------------------}
Unit uComCallerDemo;

Interface

Uses
  // add the com caller and sync objects
  ComCaller_TLB, uSyncronization,
  comobj,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  ComCtrls, Buttons, ExtCtrls, Spin
  ;

Const
  cCompany = 1;

Type
  TfrmComCaller = Class(TForm)
    btnExport: TButton;
    btnImport: TButton;
    btnCreate: TButton;
    btnDestroy: TButton;
    Label1: TLabel;
    lvInbox: TListView;
    Label2: TLabel;
    lvOutbox: TListView;
    btnDeleteInbox: TButton;
    btnDeleteOutbox: TButton;
    btnGetInboxDetail: TButton;
    btnGetOutboxDetail: TButton;
    btnLoadInboxMsgs: TButton;
    btnLoadOutboxMsgs: TButton;
    mmBody: TMemo;
    Label3: TLabel;
    edtSubj: TEdit;
    Label4: TLabel;
    edtFrom: TEdit;
    Label5: TLabel;
    edtTo: TEdit;
    Label6: TLabel;
    edtMsgType: TEdit;
    Label7: TLabel;
    edtStatus: TEdit;
    Label8: TLabel;
    edtTotal: TEdit;
    Label9: TLabel;
    edtPeriodFrom: TEdit;
    Label10: TLabel;
    edtPeriodTo: TEdit;
    Label11: TLabel;
    btnShowTab: TButton;
    BtnHideTab: TButton;
    sbInfo: TStatusBar;
    lblDate: TLabel;
    btnGGWSendPacket: TButton;
    btnGGWGetPending: TButton;
    btnGGWPreparePacket: TButton;
    Label12: TLabel;
    edtIrMark: TEdit;
    btnActivateTimer: TButton;
    btnSetTimer: TButton;
    seTimer: TSpinEdit;
    Label13: TLabel;
    Label14: TLabel;
    Procedure btnCreateClick(Sender: TObject);
    Procedure btnDestroyClick(Sender: TObject);
    Procedure btnExportClick(Sender: TObject);
    Procedure btnImportClick(Sender: TObject);
    Procedure btnDeleteInboxClick(Sender: TObject);
    Procedure btnDeleteOutboxClick(Sender: TObject);
    Procedure btnLoadInboxMsgsClick(Sender: TObject);
    Procedure btnLoadOutboxMsgsClick(Sender: TObject);
    Procedure btnGetOutboxDetailClick(Sender: TObject);
    Procedure btnGetInboxDetailClick(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure btnShowTabClick(Sender: TObject);
    Procedure BtnHideTabClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure btnGGWGetPendingClick(Sender: TObject);
    Procedure btnGGWSendPacketClick(Sender: TObject);
    Procedure btnGGWPreparePacketClick(Sender: TObject);
    Procedure btnSetTimerClick(Sender: TObject);
    Procedure btnActivateTimerClick(Sender: TObject);
  Private
    fSink: TDSRSink;
    FSinkCookie: Longint;
    fResult: Longword;

    // The COM Caller Object
    fCaller: IDSRCOMCaller;

    // clear the visual variables
    Procedure Clear;
    // do something if a new inbox message arrives
    Procedure NewInboxMessage(pNewMessage: Longword);
    Procedure OutboxMessages(pTotal: Longword);
    Procedure TranslateMessage(pResult: Longword);
  Public
  End;

Var
  frmComCaller: TfrmComCaller;

Implementation

{$R *.dfm}

Procedure TfrmComCaller.btnCreateClick(Sender: TObject);
Begin
  // create the com caller object
  fCaller := CoDSRCOMCaller.Create;

  If Assigned(fCaller) Then
  Begin
  //Create event sink
    fSink := TDSRSink.Create;
  //Set up event sink event handlers
    fSink.OnUpdateInbox := NewInboxMessage;
    fSink.OnUpdateOutbox := OutboxMessages;
  //Connect to server
    InterfaceConnect(fCaller, IDSRCOMCallerEvents, fSink, FSinkCookie)
  End;
End;

Procedure TfrmComCaller.btnDestroyClick(Sender: TObject);
Begin
  If Assigned(fCaller) Then
  Begin
  // disconect from the server...
    InterfaceDisconnect(fCaller, IDSRCOMCallerEvents, FSinkCookie);

    // free the objects
    fSink := Nil;
    fCaller := Nil;
  End;
End;

Procedure TfrmComCaller.btnExportClick(Sender: TObject);
Var
  // declare a result variable
  lGuid: TGuid;
  lMsgBody: WideString;
Begin
  If Assigned(fCaller) Then
  Begin
    fResult := S_OK;
  // create a new GUID to be used as a key reference
    lGuid := StringToGUID(CreateClassID);
    lMsgBody := 'This is a new test';

  // call com caller export function...
    fCaller.BExport(cCompany, lGuid, 'Export Customers', 'yourmail@mail.com',
      'targetmail@mail.com', lMsgBody, 1, strtodate('01/10/2005'),
      Date, fResult);

  // get the error message if something got wrong...
    TranslateMessage(fResult);
  End; // if assigned and <> nil
End;

Procedure TfrmComCaller.btnImportClick(Sender: TObject);
Begin
  If Assigned(fCaller) And (lvInbox.Selected <> Nil) Then
  Begin
    fResult := S_OK;
  // call com caller import function
    fCaller.BImport(cCompany, StringToGUID(lvInbox.Selected.Caption), 1,
      fResult);

  // get the error message if something got wrong...
   TranslateMessage(fResult);
  End; // if assigned and <> nil
End;

Procedure TfrmComCaller.btnDeleteInboxClick(Sender: TObject);
Begin
  If Assigned(fCaller) And (lvInbox.Selected <> Nil) Then
  Begin
    fResult := S_OK;

  // call com caller delete inbox
    fCaller.DeleteInboxMessage(cCompany, StringToGUID(lvInbox.Selected.Caption),
      fResult);

  // get the error message if something got wrong...
    TranslateMessage(fResult);
  End; // if assigned and <> nil
End;

Procedure TfrmComCaller.btnDeleteOutboxClick(Sender: TObject);
Begin
  If Assigned(fCaller) And (lvOutbox.Selected <> Nil) Then
  Begin
    fResult := S_OK;

  // call com caller delete outbox
    fCaller.DeleteOutboxMessage(cCompany,
      StringToGUID(lvOutbox.Selected.Caption), fResult);

  // get the error message if something got wrong...
    If fResult <> 0 Then
      TranslateMessage(fResult)
    Else
      btnLoadOutboxMsgsClick(Sender);
  End; // if assigned and <> nil
End;

Procedure TfrmComCaller.btnLoadInboxMsgsClick(Sender: TObject);
Var
  // declare a result variable
  I,
    lCount: Longword;
  lGuids: OleVariant;
Begin
  If Assigned(fCaller) Then
  Begin
    fResult := S_OK;
    lvInbox.Clear;

  // call com caller delete outbox
    fCaller.GetInboxMessages(cCompany, 1, 0, lGuids, lCount, fResult);

  // get the error message if something got wrong...
    If fResult <> 0 Then
      TranslateMessage(fResult)
    Else
    Begin
      // update the inbox list
      lvInbox.Items.BeginUpdate;
      For I := 0 To lCount - 1 Do
        With lvInbox.Items.Add Do
          Caption := lGuids[I];

      lvInbox.Items.EndUpdate;
    End;
  End; // if assigned
End;

Procedure TfrmComCaller.btnLoadOutboxMsgsClick(Sender: TObject);
Var
  // declare a result variable
  lGuids: OleVariant;
  i,
    lCount: Longword;
Begin
  If Assigned(fCaller) Then
  Begin
    fResult := S_OK;
    lvOutbox.Clear;

  // call com caller delete outbox
    fCaller.GetOutboxMessages(cCompany, 1, 0, lGuids, lCount, fResult);

  // get the error message if something got wrong...
    If fResult <> 0 Then
      TranslateMessage(fResult)
    Else
    Begin
      // update the outbox list
      lvOutbox.Items.BeginUpdate;
      For i := 0 To lCount - 1 Do
        With lvOutbox.Items.Add Do
          Caption := lGuids[i];

      lvOutbox.Items.EndUpdate;
    End;
  End; // if assigned
End;

Procedure TfrmComCaller.btnGetOutboxDetailClick(Sender: TObject);
Var
  // the result array containing message information
  lMessage: Olevariant;
Begin
  // get the right guid...
  If Assigned(fCaller) And (lvOutbox.Selected <> Nil) Then
  Begin
    fResult := S_OK;

  // call com caller delete outbox
    fCaller.GetOutboxMessageDetail(StringToGUID(lvOutbox.Selected.Caption),
      lMessage, fResult);

  // get the error message if something got wrong...
    If fResult <> 0 Then
      TranslateMessage(fResult)
    Else
    Begin
      // clear fields
      Clear;

      edtSubj.Text := lMessage[0];
      edtFrom.Text := lMessage[1];
      edtTo.Text := lMessage[2];
      mmBody.Text := lMessage[3];
      edtMsgType.Text := IntToStr(lMessage[4]);
      edtStatus.Text := IntToStr(lMessage[5]);
      edtPeriodFrom.Text := DateToStr(lMessage[6]);
      edtPeriodTo.Text := DateToStr(lMessage[7]);
      edtTotal.Text := IntToStr(lMessage[8]);
      edtIrMark.Text := lMessage[9];
      lblDate.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss', lMessage[10]);
    End; // if lresult <> 0
  End; // if assigned and <> nil
End;

Procedure TfrmComCaller.btnGetInboxDetailClick(Sender: TObject);
Var
  lMessage: OleVariant;
Begin
  If Assigned(fCaller) And (lvInbox.Selected <> Nil) Then
  Begin
    fResult := S_OK;

  // call com caller delete outbox
    fCaller.GetInboxMessageDetail(StringToGUID(lvInbox.Selected.Caption),
      lMessage, fResult);

  // get the error message if something got wrong...
    If fResult <> 0 Then
      TranslateMessage(fResult)
    Else
    Begin
      // clear fields
      Clear;

      // fill fields with the returned values
      edtSubj.Text := lMessage[0];
      edtFrom.Text := lMessage[1];
      edtTo.Text := lMessage[2];
      mmBody.Text := lMessage[3];
      edtMsgType.Text := lMessage[4];
      edtStatus.Text := lMessage[5];
      edtTotal.Text := lMessage[6];
      lblDate.Caption := FormatDateTime('dd/mm/yyyy hh:mm:ss', lMessage[7]);
    End; // lresult <> 0
  End; // if assigned and <> nil
End;

Procedure TfrmComCaller.FormClose(Sender: TObject;
  Var Action: TCloseAction);
Begin
  If Assigned(fCaller) Then
  Begin
    // disconnect the sink object
    InterfaceDisconnect(fCaller, IDSRCOMCallerEvents, FSinkCookie);
    fCaller := Nil;
  End;
End;

Procedure TfrmComCaller.btnShowTabClick(Sender: TObject);
Begin
  self.Height := 643;
End;

Procedure TfrmComCaller.BtnHideTabClick(Sender: TObject);
Begin
  self.Height := 367;
End;

Procedure TfrmComCaller.Clear;
Begin
  mmBody.Clear;
  edtSubj.Clear;
  edtFrom.Clear;
  edtTo.Clear;
  edtMsgType.Clear;
  edtStatus.Clear;
  edtTotal.Clear;
  edtPeriodFrom.Clear;
  edtPeriodTo.Clear;
  lblDate.Caption := '';
End;

Procedure TfrmComCaller.NewInboxMessage(pNewMessage: Longword);
Begin
  // if there are new messages
  If pNewMessage > 0 Then
  Begin
    // load the list...
    btnLoadInboxMsgsClick(Self);
    sbInfo.Panels[0].Text := 'New Inbox Message(s) :- ' + inttostr(pNewMessage);
  End;
End;

Procedure TfrmComCaller.OutboxMessages(pTotal: Longword);
Begin
  // if the outbox list is different from the list into the mailbox, update screen
  If (pTotal > 0) And (pTotal <> lvOutbox.Items.Count) Then
  Begin
    // load the list...
    btnLoadOutboxMsgsClick(Self);
    sbInfo.Panels[0].Text := 'Outbox Message(s) :- ' + inttostr(pTotal);
  End;
End;

Procedure TfrmComCaller.FormCreate(Sender: TObject);
Begin
  BtnHideTabClick(Sender);
End;

Procedure TfrmComCaller.btnGGWGetPendingClick(Sender: TObject);
Var
  // the result array of guids
  lGuids: OleVariant;
  i,
    lCount: Longword;
Begin
  If Assigned(fCaller) Then
  Begin
    fResult := S_OK;
    lvOutbox.Clear;

  // call com caller delete outbox
    fCaller.GGW_GetPending(cCompany, 0, lGuids, lCount, fResult);

  // get the error message if something got wrong...
    If fResult <> 0 Then
      TranslateMessage(fResult)
    Else
    Begin
      // update the outbox list
      lvOutbox.Items.BeginUpdate;
      For i := 0 To lCount - 1 Do
        With lvOutbox.Items.Add Do
          Caption := lGuids[i];

      lvOutbox.Items.EndUpdate;
    End;
  End; // if assigned
End;

Procedure TfrmComCaller.btnGGWSendPacketClick(Sender: TObject);
Begin
  // get the guid that should be sent...
  If Assigned(fCaller) And (lvOutbox.Selected <> Nil) Then
  Begin
    fResult := S_OK;

    // get the irmark to this message first and then send...
    fCaller.GGW_SendPacket(cCompany, StringToGUID(lvOutbox.Selected.Caption),
      edtIrMark.Text, fResult);

  // get the error message if something got wrong...
    TranslateMessage(fResult);
  End; // <> nil
End;

Procedure TfrmComCaller.btnGGWPreparePacketClick(Sender: TObject);
Var
  lGuid: TGuid;
Begin
  If Assigned(fCaller) Then
  Begin
    fResult := S_OK;
    lGuid := StringToGUID(CreateClassID);

    fCaller.GGW_PreparePacket(cCompany, lGuid, 'GGW Message',
      'mycompany@mycompany.com', 'ggwmail@ggw.gov.uk', '',
      'c:\taxreturns\tax2005.xml', '', fResult);

  // get the error message if something got wrong...
    TranslateMessage(fResult);
  End; // if assigned
End;

Procedure TfrmComCaller.btnSetTimerClick(Sender: TObject);
Begin
  If Assigned(fCaller) Then
  Begin
    fResult := S_OK;
    fCaller.SetTimerInterval(seTimer.Value, fResult);
    TranslateMessage(fResult);
  End
End;

Procedure TfrmComCaller.btnActivateTimerClick(Sender: TObject);
Var
  lActive: Shortint;
Begin
  If Assigned(fCaller) Then
  Begin
    fResult := S_OK;
    lActive := 0;
    // set this value here...
    fCaller.IsTimerActive(lActive, fResult);

    fCaller.ActivateTimer(Shortint(Not Boolean(lActive)), fResult);
    fCaller.IsTimerActive(lActive, fResult);

    If Boolean(lActive) Then
      btnActivateTimer.Caption := 'Disable Timer'
    Else
      btnActivateTimer.Caption := 'Enable Timer'
  End;
End;

Procedure TfrmComCaller.TranslateMessage(pResult: Longword);
Var
  lTranslation: WideString;
Begin
  If pResult <> S_OK Then
    If Assigned(fCaller) Then
    Begin
      fCaller.TranslateErrorCode(pResult, lTranslation);
      ShowMessage(lTranslation);
    End;
End;

End.

