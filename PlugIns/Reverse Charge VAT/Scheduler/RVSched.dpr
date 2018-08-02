program RVSched;

uses
  Forms,
  Windows,  
  oMain in 'oMain.pas' {Form1},
  SchedulerPlugIn_TLB in 'SchedulerPlugIn_TLB.pas',
  oClient in 'oClient.pas' {ReverseVATUpdateTX: CoClass},
  ExScheduler_TLB in 'x:\ENTRPRSE\Scheduler\Admin\ExScheduler_TLB.pas',
  Silencer in 'x:\ENTRPRSE\Scheduler\PlugIn\Silencer.pas',
  RVProc in '..\Shared\RVProc.pas',
  RSCLProc in 'RSCLProc.pas';

{$R *.TLB}

{$R *.res}

{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.ShowMainForm := FALSE;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
