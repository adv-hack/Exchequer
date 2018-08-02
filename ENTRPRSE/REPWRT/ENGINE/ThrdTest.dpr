program ThrdTest;

uses
  Forms,
  MAIN in 'MAIN.PAS' {MainForm},
  CHILDWIN in 'CHILDWIN.PAS' {MDIChild},
  about in 'about.pas' {AboutBox},
  ExTHSu1U in 'X:\ENTRPRSE\REPWRT\ENGINE\EXTHSU1U.PAS' {ProgTForm},
  ExThredU in 'X:\ENTRPRSE\REPWRT\ENGINE\EXTHREDU.PAS',
  ExThrd2U in 'X:\ENTRPRSE\REPWRT\ENGINE\EXTHRD2U.PAS',
  ShowRepF in 'ShowRepF.pas' {frmReport},
  RepThrd1 in '..\..\SENTMAIL\SENTINEL\RepThrd1.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TfrmReport, frmReport);
  Application.Run;
end.
