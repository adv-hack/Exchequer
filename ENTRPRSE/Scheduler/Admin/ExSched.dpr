program ExSched;
{$REALCOMPATIBILITY ON}
{$ALIGN 1}
uses
  Forms,
  D6OnHelpFix,
  conHTMLHelp,
  SchedLst in 'SchedLst.pas' {frmTaskList},
  ConfigF in 'ConfigF.pas' {frmSchedulerSettings},
  DataObjs in '..\Shared\DataObjs.pas',
  SchedWiz in 'SchedWiz.pas' {frmTaskWizard},
  ExScheduler_TLB in 'ExScheduler_TLB.pas',
  Custom in 'Custom.pas' {ScheduledTask: CoClass},
  ComServ in 'ComServ.pas',
  //ELoginU in '..\..\SENTMAIL\SENTINEL\ELOGINU.PAS' {ELogFrm},
  EntLicence in 'w:\ENTRPRSE\DRILLDN\EntLicence.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Task Scheduler';
  Application.HelpFile := 'ExSched.chm';
  Application.CreateForm(TfrmTaskList, frmTaskList);
  Application.Run;
end.
