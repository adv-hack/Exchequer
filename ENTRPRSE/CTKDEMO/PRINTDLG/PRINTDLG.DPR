program PrintDlg;

uses
  Forms,
  PrntDlgF in 'PrntDlgF.pas' {frmPrintDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'COM Toolkit Print Dialog Demo';
  Application.CreateForm(TfrmPrintDlg, frmPrintDlg);
  Application.Run;
end.
