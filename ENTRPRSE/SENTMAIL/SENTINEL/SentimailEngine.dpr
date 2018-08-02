program SentimailEngine;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  Previnst2 in 'Previnst2.pas',
  ChkPrntr,
  VAOUtil,
  ElVar,
  SdiMainf in 'SdiMainf.pas' {frmEngine},
  VarFPOSU in 'x:\ENTRPRSE\VRW\Common\VARFPOSU.PAS',
  GlobalTypes in '..\..\VRW\Common\GlobalTypes.pas',
  Trayf in 'TRAYF.PAS' {frmElertTray},
  AgentList in 'AgentList.pas';

{$R *.res}


begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.Title := 'Sentimail Monitor';
  Application.HelpFile := 'Sentmail.chm';
  if AppIsRunning(False) and (VAOInfo.vaoMode <> smVAO) then EXIT;
  if CheckLicenceOK and CheckPrintersOK then
  begin
    Application.CreateForm(TfrmEngine, frmEngine);
  Application.CreateForm(TfrmElertTray, frmElertTray);
  Application.Run;
  end
  else
    Application.Terminate;
end.
