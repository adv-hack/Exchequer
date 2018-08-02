{-----------------------------------------------------------------------------
 Unit Name: uEndofSyncRequest
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uEndofSyncRequest;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExportFrame,
  ufrmbase
  ;

Type
  //TfrmEndofSyncRequest = Class(TForm)
  TfrmEndofSyncRequest = Class(TFrmbase)
    frmExportFrame: TfrmExportFrame;
    Procedure FormCreate(Sender: TObject);
    Procedure frmExportFrameactCloseExecute(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure frmExportFrameactSendExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  Private
    fCancelDripFeed: Boolean;
    Procedure SetCancelDripFeed(Const Value: Boolean);
  Public
  Published
    Property CancelDripfeed: Boolean Read fCancelDripFeed Write SetCancelDripFeed
      Default False;
  End;

Var
  frmEndofSyncRequest: TfrmEndofSyncRequest;

Implementation

Uses uDsr, uDashSettings, uInterfaces, uCommon, uConsts, udashGlobal;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmEndofSyncRequest.FormCreate(Sender: TObject);
Begin
  Inherited;
  
  With frmExportFrame Do
  Begin
    HidePeriods;
    actSend.Caption := '&Apply';
  End; {with frmExportFrame do}
End;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameactCloseExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmEndofSyncRequest.frmExportFrameactCloseExecute(Sender: TObject);
Begin
  ModalResult := MrCancel;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmEndofSyncRequest.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    frmExportFrameactCloseExecute(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameactSendExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmEndofSyncRequest.frmExportFrameactSendExecute(Sender: TObject);
Var
  lComp,
    lRes: Longword;
//  lTrans: WideString;
Begin
  frmExportFrame.actSendExecute(Sender);

  frmExportFrame.lblSending.Caption := '';
  If fCancelDripFeed Then
    //frmExportFrame.lblSending.Caption := 'Cancelling Dripfeed mode...'
    frmExportFrame.lblSending.Caption := 'Cancelling Linked Mode...'
  Else
    //frmExportFrame.lblSending.Caption := 'Removing Dripfeed mode...';
    frmExportFrame.lblSending.Caption := 'Removing Linked Mode...';
  frmExportFrame.lblSending.Visible := True;
  _Delay(100);

  With frmExportFrame.cbCompanies Do
    lComp := TCompany(Items.Objects[ItemIndex]).Id;

  {call remove drip feed/cancel}
  If fCancelDripFeed Then
    lRes := TDSR.DSR_CancelDripfeed(_DashboardGetDSRServer,
      _DashboardGetDSRPort,
      lComp,
      //_DashboardGetDefaultMail,
      //frmExportFrame.DB.GetSystemValue(cDEFAULTEMAILPARAM),
      frmExportFrame.DB.GetDefaultEmailAccount,
      frmExportFrame.advTo.Text,
      frmExportFrame.advSubject.Text)
  Else
    lRes := TDSR.DSR_RemoveDripFeed(_DashboardGetDSRServer,
      _DashboardGetDSRPort,
      lComp,
      //_DashboardGetDefaultMail,
      //frmExportFrame.DB.GetSystemValue(cDEFAULTEMAILPARAM),
      frmExportFrame.DB.GetDefaultEmailAccount,
      frmExportFrame.advTo.Text,
      frmExportFrame.advSubject.Text);

  _Delay(4000);
  frmExportFrame.lblSending.Caption := '';
  Application.ProcessMessages;

  {check the answer}
  If lRes = S_OK Then
  Begin
    If fCancelDripFeed Then
      //ShowDashboardDialog('Dripfeed mode successfully cancelled!', mtInformation, [mbok])
      ShowDashboardDialog('Linked Mode successfully cancelled!', mtInformation, [mbok])
    Else
      //ShowDashboardDialog('Dripfeed mode successfully removed!', mtInformation, [mbok]);
      ShowDashboardDialog('Linked Mode successfully removed!', mtInformation, [mbok]);

    {delete bulk request file if that exists...}
    Try
      With frmExportFrame.cbCompanies Do
        _CompanyDeleteBulk(TCompany(Items.Objects[ItemIndex]).Guid);
    Except
    End;

    ModalResult := mrOK;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SetCancelDripFeed
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmEndofSyncRequest.SetCancelDripFeed(Const Value: Boolean);
Begin
  fCancelDripFeed := Value;

  {aply captions to the form and buttons}
  If fCancelDripFeed Then
  begin
    //Caption := 'Cancel Dripfeed';
    Caption := 'Cancel Link';
    frmExportFrame.btnCancel.Caption := '&Close'
  end
  Else
  begin
    //Caption := 'End of Dripfeed';
    Caption := 'End of Link';
    frmExportFrame.btnCancel.Caption := '&Cancel'
  end;
End;

procedure TfrmEndofSyncRequest.FormDestroy(Sender: TObject);
begin
  frmExportFrame.ClearComboBoxes;

  inherited;
end;

End.

