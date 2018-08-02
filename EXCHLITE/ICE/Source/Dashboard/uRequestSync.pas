{-----------------------------------------------------------------------------
 Unit Name: uBulkExport
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uRequestSync;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExportFrame,
  StdCtrls, ComCtrls, ExtCtrls, AdvPanel,

  ufrmbase
  ;

Type
  //TfrmRequestSync = Class(TForm)
  TfrmRequestSync = Class(TFrmbase)
    advPanelExport: TAdvPanel;
    frmExportFrame: TfrmExportFrame;
    Procedure FormDestroy(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure frmExportFrameactSendExecute(Sender: TObject);
    Procedure frmExportFrameactCloseExecute(Sender: TObject);
  Private
  Public
    Procedure AfterConstruction; Override;
  End;

Var
  frmRequestSync: TfrmRequestSync;

Implementation

Uses uDsr, uCommon, uInterfaces, uconsts, uDashSettings;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: AfterConstruction
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRequestSync.AfterConstruction;
Begin
  Inherited;
  If frmExportFrame <> Nil Then
    frmExportFrame.DripfeedRequest := True;
End;

{-----------------------------------------------------------------------------
  Procedure: FormDestroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRequestSync.FormDestroy(Sender: TObject);
Begin
  frmExportFrame.ClearComboBoxes;

  inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRequestSync.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    frmExportFrameactCloseExecute(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameactSendExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRequestSync.frmExportFrameactSendExecute(Sender: TObject);
Var
  lComp: Integer;
  lSubj: String;
Begin
  frmExportFrame.actSendExecute(Sender);

  frmExportFrame.lblSending.Caption := '';
  //frmExportFrame.lblSending.Caption := 'Sending Dripfeed Request...';
  frmExportFrame.lblSending.Caption := 'Sending Link Request...';
  frmExportFrame.lblSending.Visible := True;
  _Delay(500);

  With frmExportFrame Do
    lSubj := advSubject.Text + ' for ' + edtStartPeriod.EditText + ' to ' +
      edtEndPeriod.EditText;

  With frmExportFrame Do
    lComp := TCompany(cbCompanies.Items.Objects[cbCompanies.ItemIndex]).Id;

//  {$ifdef DEBUG}
//  ShowMessage('Default email sender: ' + frmExportFrame.DB.GetSystemValue(cDEFAULTEMAILPARAM));
//  {$ENDIF}

  TDSR.DSR_SyncRequest(
    _DashboardGetDSRServer,
    _DashboardGetDSRPort,
    lComp,
    lSubj,
    //_DashboardGetCompanyMail,
    //_DashboardGetDefaultMail,
    //frmExportFrame.DB.GetSystemValue(cDEFAULTEMAILPARAM),
    frmExportFrame.DB.GetDefaultEmailAccount,
    frmExportFrame.advTo.Text,
    frmExportFrame.edtStartPeriod.Text,
    frmExportFrame.edtEndPeriod.text);

  Application.ProcessMessages;
  _Delay(6000);
  frmExportFrame.lblSending.Visible := False;

  ModalResult := mrOk;
End;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameactCloseExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmRequestSync.frmExportFrameactCloseExecute(Sender: TObject);
Begin
  ModalResult := mrCancel;
End;

End.
