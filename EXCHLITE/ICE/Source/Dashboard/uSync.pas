{-----------------------------------------------------------------------------
 Unit Name: uSync
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uSync;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AdvPanel, uExportFrame, DateUtils, uInterfaces,
  ufrmbase
  ;

Type
  //TfrmDripfeed = Class(TForm)
  TfrmDripfeed = Class(TFrmBase)
    advPanelSchedule: TAdvPanel;
    frmExportFrame: TfrmExportFrame;
    Procedure FormDestroy(Sender: TObject);
    Procedure frmExportFrameadvCloseClick(Sender: TObject);
    Procedure frmExportFrameactSendExecute(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure frmExportFrameactCloseExecute(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure frmExportFrameAdvToolButton1Click(Sender: TObject);
  Private
    fMailInfo: TMessageInfo;
  Public
  Published
    Property MailInfo: TMessageInfo Read fMailInfo Write fMailInfo;
  End;

Var
  frmDripfeed: TfrmDripfeed;

Implementation

Uses uDashSettings, uDsr, uConsts, StdCtrls, strutils, uCommon;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormDestroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDripfeed.FormDestroy(Sender: TObject);
Begin
  frmExportFrame.ClearComboBoxes;
  If Assigned(fMailInfo) Then
    FreeAndNil(fMailInfo);

  inherited;  
End;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameadvCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDripfeed.frmExportFrameadvCloseClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameactSendExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDripfeed.frmExportFrameactSendExecute(Sender: TObject);
Var
  lComp,
    lPackId: Longword;
  lSubj: String;
Begin
  frmExportFrame.actSendExecute(Sender);

  frmExportFrame.lblSending.Caption := '';
  //frmExportFrame.lblSending.Caption := 'Sending Dripfeed Data...';
  frmExportFrame.lblSending.Caption := 'Sending Linked Data...';
  frmExportFrame.lblSending.Visible := True;
  _Delay(100);

  With frmExportFrame.cbCompanies Do
    lComp := TCompany(Items.Objects[ItemIndex]).Id;

  With frmExportFrame.cbJobs Do
    lPackId := TPackageInfo(Items.Objects[ItemIndex]).Id;
       
  With frmExportFrame Do
    //lSubj := 'Dripfeed from ' + DB.GetSystemValue(cCOMPANYNAMEPARAM) + ' ['
    lSubj := 'Update Link from ' + DB.GetSystemValue(cCOMPANYNAMEPARAM) + ' ['
      + cbCompanies.Text + '] for ' + edtStartPeriod.EditText + ' to ' +
      edtEndPeriod.EditText + ' at ' + Datetimetostr(Now);

  {validate the period}
  If frmExportFrame.ValidatePeriod(lComp) Then
  Begin
    TDSR.DSR_Sync(
      _DashboardGetDSRServer,
      _DashboardGetDSRPort,
      lComp,
      lSubj, {frmExportFrame.advSubject.Text,}
      //_DashboardGetCompanyMail,
      //_DashboardGetDefaultMail,
      //frmExportFrame.DB.GetSystemValue(cDEFAULTEMAILPARAM),
      frmExportFrame.DB.GetDefaultEmailAccount,
      frmExportFrame.advTo.Text,
      frmExportFrame.edtStartPeriod.Text,
      frmExportFrame.edtEndPeriod.Text,
//      frmExportFrame.edtStartDate.EditText,
//      frmExportFrame.edtEndDate.EditText,
      lPackId);
  End; {if frmExportFrame.ValidatePeriod(lComp) then}

  frmExportFrame.lblSending.Caption := '';
  frmExportFrame.lblSending.Visible := False;
  Application.processmessages;
  _Delay(1500);

  ModalResult := mrOK;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDripfeed.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    frmExportFrameactCloseExecute(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameactCloseExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDripfeed.frmExportFrameactCloseExecute(Sender: TObject);
Begin
  ModalResult := mrCancel;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDripfeed.FormCreate(Sender: TObject);
Begin
  Inherited;
  fMailInfo := TMessageInfo.Create;
End;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameAdvToolButton1Click
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDripfeed.frmExportFrameAdvToolButton1Click(
  Sender: TObject);
Begin
  frmExportFrame.actAddressBookExecute(Sender);
End;

End.

