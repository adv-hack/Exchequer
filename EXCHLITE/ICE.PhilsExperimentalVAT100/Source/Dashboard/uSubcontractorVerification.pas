unit uSubcontractorVerification;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExportFrame, StdCtrls,
  ufrmbase
  ;

type
  //TfrmSubVerification = class(TForm)
  TfrmSubVerification = class(TFrmbase)
    frmExportFrame: TfrmExportFrame;
    procedure frmExportFrameactCancelExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure frmExportFrameactSendExecute(Sender: TObject);
  private
  public
  end;

var
  frmSubVerification: TfrmSubVerification;

implementation

uses uConsts, uDsr, uCommon, uInterfaces, uDashSettings;


{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameactCancelExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmSubVerification.frmExportFrameactCancelExecute(
  Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmSubVerification.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    frmExportFrameactCancelExecute(Sender);
end;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmSubVerification.FormCreate(Sender: TObject);
begin
  Inherited;
  
  frmExportFrame.HidePeriods;
  frmExportFrame.actSend.Caption := '&Verify';
  frmExportFrame.actAddressBook.Enabled := False;
  frmExportFrame.advTo.Text := cCISRECIPIENT;
  frmExportFrame.advTo.Enabled := False;
end;

{-----------------------------------------------------------------------------
  Procedure: FormDestroy
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmSubVerification.FormDestroy(Sender: TObject);
begin
  frmExportFrame.ClearComboBoxes;

  Inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: frmExportFrameactSendExecute
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmSubVerification.frmExportFrameactSendExecute(
  Sender: TObject);
Var
  lResult: Longword;
  lComp, lPAck: Integer;
  lSubj, lFrom: String;
Begin
  frmExportFrame.actSendExecute(Sender);

  frmExportFrame.lblSending.Caption := '';
  frmExportFrame.lblSending.Caption := 'Sending Verification...';
  frmExportFrame.lblSending.Visible := True;
  _Delay(100);

  With frmExportFrame Do
  Begin
    lComp := TCompany(cbCompanies.Items.Objects[cbCompanies.ItemIndex]).Id;
    lPack := TPackageInfo(cbJobs.Items.Objects[cbJobs.ItemIndex]).Id;
    lSubj := advSubject.Text;
  End; {With frmExportFrame Do}

  //lFrom := frmExportFrame.DB.GetSystemValue(cDEFAULTEMAILPARAM);
  lFrom := frmExportFrame.DB.GetDefaultEmailAccount;
  if Trim(lFrom) = '' then
    lFrom := frmExportFrame.DB.GetSystemValue(cCOMPANYNAMEPARAM);

  lResult := S_FALSE;

  _Delay(1000);

  lResult := TDSR.DSR_Export(
    _DashboardGetDSRServer,
    _DashboardGetDSRPort,
    lComp, {fMailInfo.Company_Id,}
    lSubj, { frmExportFrame.advSubject.Text,}
    lFrom,
    frmExportFrame.advTo.Text, {fMailInfo.To_,}
    cCISSUBCONTRACTOR,
    '',
    lPack
    );

  Application.ProcessMessages;
  _Delay(2000);

  frmExportFrame.lblSending.Caption := '';
  frmExportFrame.lblSending.Visible := False;

  If lResult = S_Ok Then
    ModalResult := mrOK;
end;

end.
