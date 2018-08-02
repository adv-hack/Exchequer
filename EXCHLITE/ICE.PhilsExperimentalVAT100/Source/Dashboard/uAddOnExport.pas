{-----------------------------------------------------------------------------
 Unit Name: uExportTask
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uAddOnExport;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AdvPanel, uExportFrame, DateUtils, uInterfaces,
  uAddOnExportFrame, Menus,

  ufrmbase
  ;

Type
  //TfrmAddonExport = Class(TForm)
  TfrmAddonExport = Class(TFrmbase)
    advPanelSchedule: TAdvPanel;
    frmExportFrame: TfrmAddOnExportFrame;
    Procedure FormDestroy(Sender: TObject);
    Procedure frmExportFrameadvCloseClick(Sender: TObject);
    Procedure frmExportFrameactSendExecute(Sender: TObject);
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure frmExportFrameactCloseExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  Private
  Public
  Published
  End;

Var
  frmAddonExport: TfrmAddonExport;

Implementation

Uses uDashSettings, uDsr, uConsts, StdCtrls, strutils, uCommon;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormDestroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddonExport.FormDestroy(Sender: TObject);
Begin
  frmExportFrame.ClearComboBoxes;

  inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameadvCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddonExport.frmExportFrameadvCloseClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameactSendExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddonExport.frmExportFrameactSendExecute(Sender: TObject);
Var
  lComp,
    lPackId: Longword;
Begin
  frmExportFrame.actSendExecute(Sender);

  Refresh;

  With frmExportFrame.cbCompanies Do
    lComp := TCompany(Items.Objects[ItemIndex]).Id;

  With frmExportFrame.cbJobs Do
    lPackId := TPackageInfo(Items.Objects[ItemIndex]).Id;

  {validate the period}
  If frmExportFrame.ValidatePeriod(lComp) Then
  Begin
    TDSR.DSR_Export(
      _DashboardGetDSRServer,
      _DashboardGetDSRPort,
      lComp,
      frmExportFrame.advSubject.Text,
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

  Application.processmessages;

  ModalResult := mrOK;
End;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddonExport.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    frmExportFrameactCloseExecute(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameactCloseExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmAddonExport.frmExportFrameactCloseExecute(Sender: TObject);
Begin
  ModalResult := mrCancel;
End;

procedure TfrmAddonExport.FormCreate(Sender: TObject);
begin
  Inherited;
  //
end;

End.
