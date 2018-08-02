{-----------------------------------------------------------------------------
 Unit Name: uBulkExport
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uBulkExport;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, AdvPanel, uExportFrame, uInterfaces,

  ufrmbase
  ;

Type
  //TfrmBulkExport = Class(TForm)
  TfrmBulkExport = Class(TFrmbase)
    frmExportFrame: TfrmExportFrame;
    Procedure FormDestroy(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure frmExportFrameactSendExecute(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    procedure frmExportFrameactCancelExecute(Sender: TObject);
  Private
    fMailInfo: TMessageInfo;
  Public
    Procedure AfterConstruction; Override;
  Published
    Property MailInfo: TMessageInfo Read fMailInfo Write fMailInfo;
  End;

Var
  frmBulkExport: TfrmBulkExport;

Implementation

Uses uDsr, uCommon, uDashSettings, uConsts;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: AfterConstruction
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmBulkExport.AfterConstruction;
Begin
  Inherited;
  If frmExportFrame <> Nil Then
    frmExportFrame.BulkExport := True;
End;

{-----------------------------------------------------------------------------
  Procedure: FormDestroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmBulkExport.FormDestroy(Sender: TObject);
Begin
  frmExportFrame.ClearComboBoxes;
  FreeAndNil(fMailInfo);

  inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmBulkExport.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    frmExportFrameactCancelExecute(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameactSendExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmBulkExport.frmExportFrameactSendExecute(Sender: TObject);
Var
  lResult: Longword;
  lComp: Integer;
  lSubj: String;
Begin
  frmExportFrame.actSendExecute(Sender);

  frmExportFrame.lblSending.Caption := '';
  frmExportFrame.lblSending.Caption := 'Sending Bulk Export Data...';
  frmExportFrame.lblSending.Visible := True;
  _Delay(100);

  With frmExportFrame Do
  Begin
    lComp := TCompany(cbCompanies.Items.Objects[cbCompanies.ItemIndex]).Id;

    //lSubj := 'Bulk Export from ' + _DashboardGetCompanyName +
    lSubj := 'Bulk Export from ' + DB.GetSystemValue(cCOMPANYNAMEPARAM) +
      ' [' + cbCompanies.Text + ']' + ' for ' + edtStartPeriod.EditText + ' to ' +
        edtEndPeriod.EditText;
  End; {With frmExportFrame Do}

  lResult := S_FALSE;

  If fMailInfo <> Nil Then
  Begin
    {validate the period}
    //If frmExportFrame.ValidatePeriod(fMailInfo.Company_Id) Then
    If frmExportFrame.ValidatePeriod(lComp) Then
    Begin
      _Delay(1000);

      lResult := TDSR.DSR_BulkExport(
        _DashboardGetDSRServer,
        _DashboardGetDSRPort,
        lComp, {fMailInfo.Company_Id,}
        lSubj, { frmExportFrame.advSubject.Text,}
        //_DashboardGetCompanyMail, {fMailInfo.From,}
        //_DashboardGetDefaultMail,
        //frmExportFrame.DB.GetSystemValue(cDEFAULTEMAILPARAM),
        frmExportFrame.DB.GetDefaultEmailAccount,
        frmExportFrame.advTo.Text, {fMailInfo.To_,}
        frmExportFrame.edtStartPeriod.Text,
        frmExportFrame.edtEndPeriod.text
        );

        Application.ProcessMessages;
        _Delay(2000);
    End; {if frmExportFrame.ValidatePeriod(fMailInfo.Company_Id) then}
  End; {If fMailInfo <> Nil Then}

  frmExportFrame.lblSending.Caption := '';
  frmExportFrame.lblSending.Visible := False;

  //Application.ProcessMessages;
  If lResult = S_Ok Then
    ModalResult := mrOK;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmBulkExport.FormCreate(Sender: TObject);
Begin
  Inherited;
  fMailInfo := TMessageInfo.Create;
End;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameactCancelExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmBulkExport.frmExportFrameactCancelExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

End.

