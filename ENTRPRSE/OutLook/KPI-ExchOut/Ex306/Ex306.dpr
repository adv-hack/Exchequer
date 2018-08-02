program Ex306;

uses
  Forms,
  MainF in 'MainF.pas' {frmOurRef},
  Enterprise01_TLB in '..\Common\Enterprise01_TLB.pas',
  PrntDlgF in 'PrntDlgF.pas' {frmPrintDlg},
  PreviewF in 'PreviewF.pas' {frmPreview};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmOurRef, frmOurRef);
  Application.Run;
end.
