program RVRepCSV;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  Forms,
  Windows,  
  Criteria in 'Criteria.PAS' {frmCriteria},
  RVProc in '..\Shared\RVProc.pas',
  PIUtils in '\ENTRPRSE\FUNCS\PIUtils.pas',
  Progress in 'Progress.pas' {frmProgress},
  Reports in 'REPORTS.PAS' {ModReports},
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.res}
{$R \Entrprse\FormDes2\WinXPMan.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.CreateForm(TfrmCriteria, frmCriteria);
  Application.CreateForm(TModReports, ModReports);
  Application.Run;
end.
