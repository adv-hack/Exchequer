program ExCf;

uses
  Forms,
  uCfMain in 'uCfMain.pas' {fmCfMain},
  uCfGenDg in 'uCfGenDg.pas' {frmCfGenDlg},
  uCfNewDg in 'uCfNewDg.pas' {frmCfNewDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmCfMain, fmCfMain);
  Application.CreateForm(TfrmCfGenDlg, frmCfGenDlg);
  Application.CreateForm(TfrmCfNewDlg, frmCfNewDlg);
  Application.Run;
end.
