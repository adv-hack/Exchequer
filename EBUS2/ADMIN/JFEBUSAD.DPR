program JFEbusad;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  Forms,
  Mainf in 'MAINF.PAS' {MainForm},
  TKitUtil in 'TKitUtil.pas';

{$R ARROWS.RES}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer eBusiness Admin Module';
  Application.HelpFile := '';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
