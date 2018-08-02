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
  uDsr,
  comobj,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  ComCtrls, Buttons, ExtCtrls, Spin
  ;

Const
  cCompany = 1;
  cMachine = 'P002957';
  cPort = 6505;

Type
  TfrmDSRCOM = Class(TForm)
    btnExport: TButton;
    btnImport: TButton;
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
    sbInfo: TStatusBar;
    lblDate: TLabel;
    btnGGWSendPacket: TButton;
    btnGGWGetPending: TButton;
    btnGGWPreparePacket: TButton;
    Label12: TLabel;
    edtIrMark: TEdit;
    btnActivateTimer: TButton;
    seTimer: TSpinEdit;
    Label13: TLabel;
    Label14: TLabel;
    tmMsg: TTimer;
    btnExport1000: TButton;
    Procedure btnExportClick(Sender: TObject);
    Procedure btnImportClick(Sender: TObject);
    Procedure btnDeleteInboxClick(Sender: TObject);
    Procedure btnDeleteOutboxClick(Sender: TObject);
    Procedure btnLoadInboxMsgsClick(Sender: TObject);
    Procedure btnLoadOutboxMsgsClick(Sender: TObject);
    Procedure btnGetOutboxDetailClick(Sender: TObject);
    Procedure btnGetInboxDetailClick(Sender: TObject);
    Procedure btnGGWGetPendingClick(Sender: TObject);
    Procedure btnGGWSendPacketClick(Sender: TObject);
    Procedure btnGGWPreparePacketClick(Sender: TObject);
    Procedure btnActivateTimerClick(Sender: TObject);
    Procedure tmMsgTimer(Sender: TObject);
    Procedure btnExport1000Click(Sender: TObject);
  Private
    fResult: Longword;

    // clear the visual variables
    Procedure Clear;
    // do something if a new inbox message arrives
    Procedure TranslateError(pResult: Longword);
  Public
  End;

Var
  frmDSRCOM: TfrmDSRCOM;

Implementation

{$R *.dfm}

Procedure TfrmDSRCOM.btnExportClick(Sender: TObject);
Var
  // declare a result variable
  lGuid: TGuid;
  lMsgBody: WideString;
Begin

  fResult := S_OK;
  // create a new GUID to be used as a key reference
  lGuid := StringToGUID(CreateClassID);
  lMsgBody := 'This is a new test';

  // call com caller export function...
  TDSR.DSR_Export('P002957', 6505, cCompany, lGuid, 'Export Customers',
    'yourmail@mail.com', 'targetmail@mail.com', lMsgBody, 1,
    strtodate('01/10/2005'), Date, fResult);

  // get the error message if something got wrong...
  TranslateError(fResult);
End;

Procedure TfrmDSRCOM.btnImportClick(Sender: TObject);
Begin
  If lvInbox.Selected <> Nil Then
  Begin
    fResult := S_OK;
  // call com caller import function
    TDSR.DSR_Import(cMachine, cPort, cCompany,
      StringToGUID(lvInbox.Selected.Caption), 1, fResult);

  // get the error message if something got wrong...
    If fResult = S_OK Then
      ShowMessage('Sucess!')
    Else
      TranslateError(fResult);
  End; // if assigned and <> nil
End;

Procedure TfrmDSRCOM.btnDeleteInboxClick(Sender: TObject);
Begin
  If lvInbox.Selected <> Nil Then
  Begin
    fResult := S_OK;

  // call com caller delete inbox
    TDSR.DSR_DeleteInboxMessage(cMachine, cPort, cCompany,
      StringToGUID(lvInbox.Selected.Caption),
      fResult);

  // get the error message if something got wrong...
    TranslateError(fResult);
  End; // if assigned and <> nil
End;

Procedure TfrmDSRCOM.btnDeleteOutboxClick(Sender: TObject);
Begin
  If lvOutbox.Selected <> Nil Then
  Begin
    fResult := S_OK;

  // call com caller delete outbox
    TDSR.DSR_DeleteOutboxMessage(cMachine, cPort, cCompany,
      StringToGUID(lvOutbox.Selected.Caption), fResult);

  // get the error message if something got wrong...
    If fResult <> 0 Then
      TranslateError(fResult)
    Else
      btnLoadOutboxMsgsClick(Sender);
  End; // if assigned and <> nil
End;

Procedure TfrmDSRCOM.btnLoadInboxMsgsClick(Sender: TObject);
Var
  // declare a result variable
  I,
    lCount: Longword;
  lGuids: OleVariant;
Begin
  fResult := S_OK;
  lvInbox.Clear;

  // call com caller delete outbox
  TDSR.DSR_GetInboxMessages(cMachine, cPort, cCompany, 1, -1, 0, lGuids, lCount,
    fResult);

  // get the error message if something got wrong...
  If fResult <> 0 Then
    TranslateError(fResult)
  Else
  Begin
      // update the inbox list
    If VarIsArray(lGuids) Then
    Begin
      lvInbox.Items.BeginUpdate;
      For I := 0 To lCount - 1 Do
        With lvInbox.Items.Add Do
          Caption := lGuids[I];

      lvInbox.Items.EndUpdate;
    End; // if varisarray
  End;
End;

Procedure TfrmDSRCOM.btnLoadOutboxMsgsClick(Sender: TObject);
Var
  // declare a result variable
  lGuids: OleVariant;
  i,
    lCount: Longword;
Begin
  fResult := S_OK;
  lvOutbox.Clear;

  // call com caller delete outbox
  TDSR.DSR_GetOutboxMessages('P002957', 6505, cCompany, 1, -1, 0, lGuids,
    lCount, fResult);

  // get the error message if something got wrong...
  If fResult <> 0 Then
    TranslateError(fResult)
  Else
  Begin
      // update the outbox list and test the olevariant type
    If VarIsArray(lGuids) Then
    Begin
      lvOutbox.Items.BeginUpdate;
      For i := 0 To lCount - 1 Do
        With lvOutbox.Items.Add Do
          Caption := lGuids[i];

      lvOutbox.Items.EndUpdate;
    End; // if varisarray
  End;
End;

Procedure TfrmDSRCOM.btnGetOutboxDetailClick(Sender: TObject);
Var
  // the result array containing message information
  lMessage: Olevariant;
Begin
  // get the right guid...
  If lvOutbox.Selected <> Nil Then
  Begin
    fResult := S_OK;

  // call com caller delete outbox
    TDSR.DSR_GetOutBoxMessageDetail(cMachine, cPort,
      StringToGUID(lvOutbox.Selected.Caption),
      lMessage, fResult);

  // get the error message if something got wrong...
    If fResult <> 0 Then
      TranslateError(fResult)
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

Procedure TfrmDSRCOM.btnGetInboxDetailClick(Sender: TObject);
Var
  lMessage: OleVariant;
Begin
  If lvInbox.Selected <> Nil Then
  Begin
    fResult := S_OK;

  // call com caller delete outbox
    TDSR.DSR_GetInboxMessageDetail(cMachine, cPort,
      StringToGUID(lvInbox.Selected.Caption), lMessage, fResult);

  // get the error message if something got wrong...
    If fResult <> 0 Then
      TranslateError(fResult)
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

Procedure TfrmDSRCOM.Clear;
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

Procedure TfrmDSRCOM.btnGGWGetPendingClick(Sender: TObject);
Var
  // the result array of guids
  lGuids: OleVariant;
  i,
    lCount: Longword;
Begin
  fResult := S_OK;
  lvOutbox.Clear;

  // call com caller delete outbox
  TDSR.DSR_GGW_GetPending(cMachine, cPort, cCompany, 0, lGuids, lCount,
    fResult);

  // get the error message if something got wrong...
  If fResult <> 0 Then
    TranslateError(fResult)
  Else
  Begin
    // update the outbox list
    If VarIsArray(lGuids) Then
    Begin
      lvOutbox.Items.BeginUpdate;
      For i := 0 To lCount - 1 Do
        With lvOutbox.Items.Add Do
          Caption := lGuids[i];

      lvOutbox.Items.EndUpdate;
    End; // if varisarray
  End;
End;

Procedure TfrmDSRCOM.btnGGWSendPacketClick(Sender: TObject);
Begin
  // get the guid that should be sent...
  If lvOutbox.Selected <> Nil Then
  Begin
    fResult := S_OK;

    // get the irmark to this message first and then send...
    TDSR.DSR_GGW_SendPacket(cMachine, cPort, cCompany,
      StringToGUID(lvOutbox.Selected.Caption), edtIrMark.Text, fResult);

  // get the error message if something got wrong...
    TranslateError(fResult);
  End; // <> nil
End;

Procedure TfrmDSRCOM.btnGGWPreparePacketClick(Sender: TObject);
Var
  lGuid: TGuid;
Begin
  fResult := S_OK;
  lGuid := StringToGUID(CreateClassID);

  TDSR.DSR_GGW_PreparePacket(cMachine, cPort, cCompany, lGuid, 'GGW Message',
    'mycompany@mycompany.com', 'ggwmail@ggw.gov.uk', '', 20, 1, 1,
    'c:\taxreturns\tax2005.xml', '', fResult);

  // get the error message if something got wrong...
  TranslateError(fResult);
End;

Procedure TfrmDSRCOM.btnActivateTimerClick(Sender: TObject);
Begin
  If btnActivateTimer.Caption = 'Enable Timer' Then
  Begin
    tmMsg.Enabled := False;
    tmMsg.Interval := seTimer.Value * 60 * 1000;
    tmMsg.Enabled := True;
    btnActivateTimer.Caption := 'Disable Timer';
  End
  Else
  Begin
    tmMsg.Enabled := False;
    btnActivateTimer.Caption := 'Enable Timer'
  End;
End;

Procedure TfrmDSRCOM.TranslateError(pResult: Longword);
Var
  lTranslation: WideString;
Begin
  If pResult <> S_OK Then
  Begin
    TDSR.DSR_TranslateErrorCode(cMachine, cPort, pResult, lTranslation);
    ShowMessage(lTranslation);
  End;
End;

Procedure TfrmDSRCOM.tmMsgTimer(Sender: TObject);
Var
  lNewMsg: Longword;
Begin
  tmMsg.Enabled := False;

  TDSR.DSR_NewInboxMessage(cMachine, cPort, lNewMsg);
  If lNewMsg > 0 Then
  Begin
    btnLoadInboxMsgsClick(Sender);
    sbInfo.Panels[0].Text := inttostr(lNewMsg) + ' new message(s)';
  End;

  TDSR.DSR_TotalOutboxMessages(cMachine, cPort, lNewMsg);

  If lNewMsg <> lvOutbox.Items.Count Then
    btnLoadOutboxMsgsClick(Sender);

  tmMsg.Enabled := True;
End;

Procedure TfrmDSRCOM.btnExport1000Click(Sender: TObject);
Var
  lCont: Integer;
Begin
  For lCont := 1 To 100 Do
  Begin
    btnExportClick(Sender);
    Application.ProcessMessages;
  End;

  ShowMessage('End of test');
End;

End.

