program NFSent;

{$REALCOMPATIBILITY ON}

uses
  Forms,
  thread1 in 'THREAD1.PAS' {frmThreadMaster},
  ExTHSu1U in 'EXTHSU1U.PAS' {ProgTForm},
  ExThrd2U in 'EXTHRD2U.PAS',
  elThred in 'elThred.pas',
  status in 'status.pas' {frmStatus},
  Trayf in 'Trayf.pas' {frmElertTray},
  About in 'ABOUT.PAS' {frmAbout};

{$R *.RES}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.Title := 'Exchequer Sentimail';
  Application.CreateForm(TfrmThreadMaster, frmThreadMaster);
  Application.CreateForm(TfrmElertTray, frmElertTray);
  Application.CreateForm(TfrmStatus, frmStatus);
  Application.Run;
end.
