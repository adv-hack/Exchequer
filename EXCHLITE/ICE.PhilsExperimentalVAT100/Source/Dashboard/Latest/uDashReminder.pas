{-----------------------------------------------------------------------------
 Unit Name: uDashReminder
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDashReminder;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, AdvGlowButton, AdvPanel, uMailBoxBaseFrame,
  uInboxFrame, AdvOutlookList, OutlookGroupedList,

  uAdoDSR;

Type
  TfrmReminder = Class(TForm)
    advPanel: TAdvPanel;
    btnCancel: TAdvGlowButton;
    Panel1: TPanel;
    lblInfo: TLabel;
    frmInboxFrame: TfrmInboxFrame;
    lblCompany: TLabel;
    Procedure btnCancelClick(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure FormCreate(Sender: TObject);
    Procedure frmInboxFrameAdvOutlookItemClick(Sender: TObject;
      Item: POGLItem; Column: Integer);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure frmInboxFrametmBoxTimer(Sender: TObject);
    Procedure frmInboxFrameAdvOutlookSelectionChange(Sender: TObject);
  Private
    fDb: TADODSR;
    Procedure LoadMessages;
  Public
    Function CheckReminder: Boolean;
  End;

Var
  frmReminder: TfrmReminder;

Implementation

Uses strutils,
  uDashSettings, uCommon, uDashGlobal, uConsts, uInterfaces;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: btnCancelClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmReminder.btnCancelClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmReminder.FormKeyDown(Sender: TObject; Var Key: Word; Shift:
  TShiftState);
Begin
  If Key = VK_ESCAPE Then
    btnCancelClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: CheckReminder
  Author:    vmoura

  if there is any reminder available, the user can see the messages from here
-----------------------------------------------------------------------------}
Function TfrmReminder.CheckReminder: Boolean;
Begin
  Result := frmInboxFrame.Count > 0;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmReminder.FormCreate(Sender: TObject);
Begin
  frmInboxFrame.ResizeHeaders;
  frmInboxFrame.TimerActive := False;
  frmInboxFrame.Company := 0;
  frmInboxFrame.MenuActive := True;
  frmInboxFrame.AdvOutlook.DragDropSetting := ddDisabled;
  frmInboxFrame.PaneVisible := False;

  Try
    fDb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On e: exception Do
    Begin
      _LogMSG('TfrmReminder.FormCreate :- Error creating database connection. Error: '
        + e.message);
    End;
  End; {try}

  LoadMessages;

  frmInboxFrame.TimerActive := True;
End;

{-----------------------------------------------------------------------------
  Procedure: frmInboxFrameAdvOutlookItemClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmReminder.frmInboxFrameAdvOutlookItemClick(Sender: TObject;
  Item: POGLItem; Column: Integer);
Begin
  frmInboxFrame.AdvOutlookItemClick(Sender, Item, Column);

  frmInboxFrame.tmChangeStatus.Enabled := False;
//  frmInboxFrameAdvOutlookSelectionChange(Sender)
End;

{-----------------------------------------------------------------------------
  Procedure: FormClose
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmReminder.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDb);
End;

{-----------------------------------------------------------------------------
  Procedure: frmInboxFrametmBoxTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmReminder.frmInboxFrametmBoxTimer(Sender: TObject);
Begin
  frmInboxFrame.TimerActive := False;

  LoadMessages;

  frmInboxFrame.TimerActive := True;
End;

{-----------------------------------------------------------------------------
  Procedure: LoadMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmReminder.LoadMessages;
Var
  lReady, lDenied, lFailed, lRemove: OleVariant;
  lRes: Longword;
Begin
  If Assigned(fDb) And fDb.Connected Then
  Begin
    Application.ProcessMessages;

      {load new entries}
    lReady := null;
    lReady := fDb.GetInboxMessages(-1, 0, cREADYIMPORT, 0, 0, lRes, False);

      {load sync requests}
    lDenied := null;
    lDenied := fDb.GetInboxMessages(-1, 0, cSYNCDENIED, 0, 0, lRes, False);

      {load sync denied}
    lFailed := null;
    lFailed := fDb.GetInboxMessages(-1, 0, cSYNCFAILED, 0, 0, lRes, False);

      {load remove sync entries}
    lRemove := null;
    lRemove := fDb.GetInboxMessages(-1, 0, cREMOVESYNC, 0, 0, lRes, False);

    {check if update/refresh screen is necessary}
    If frmInboxFrame.Count <> (_GetOlevariantArraySize(lReady) +
      _GetOlevariantArraySize(lDenied) + _GetOlevariantArraySize(lFailed) +
      _GetOlevariantArraySize(lRemove)) Then
    Begin
      frmInboxFrame.ClearItems;
      frmInboxFrame.ClearItemsAllowed := False;
      frmInboxFrame.LoadMessages(lReady);
      frmInboxFrame.LoadMessages(lDenied);
      frmInboxFrame.LoadMessages(lFailed);
      frmInboxFrame.LoadMessages(lRemove);
    End;
  End; {if Assigned(fDb) and fDb.Connected then}

  If frmInboxFrame.Count = 0 Then
    frmInboxFrame.PanelCaption := 'There are no reminders to show.'
  Else If frmInboxFrame.Count = 1 Then
    frmInboxFrame.PanelCaption := 'There is one reminder to show.'
  Else
    frmInboxFrame.PanelCaption := 'There are ' + inttostr(frmInboxFrame.Count) +
      ' reminders to show.';

  If frmInboxFrame.Count > 0 Then
  begin
    frmInboxFrame.SetFirstValidItem;
    frmInboxFrameAdvOutlookSelectionChange(frmInboxFrame.AdvOutlook);
//    frmInboxFrameAdvOutlookItemClick();
  end;
End;

{-----------------------------------------------------------------------------
  Procedure: frmInboxFrameAdvOutlookSelectionChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmReminder.frmInboxFrameAdvOutlookSelectionChange(Sender: TObject);
Var
  lMsg: TMessageInfo;
  lAux: String;
Begin
  frmInboxFrame.AdvOutlookSelectionChange(Sender);
  lblCompany.Caption := 'No company description available!';
  lMsg := frmInboxFrame.GetMailInfo;
  If Assigned(lMsg) And Assigned(fDb) Then
    If fDb.Connected Then
    Begin
      lAux := fDb.GetCompanyDescription(lMsg.Company_Id);
      If lAux <> '' Then
        lblCompany.Caption := 'Company name: ' + lAux;
    End;
End;

End.

