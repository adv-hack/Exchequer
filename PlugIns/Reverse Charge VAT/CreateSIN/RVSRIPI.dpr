program RVSRIPI;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  Forms,
  Windows,  
  Criteria in 'Criteria.PAS' {frmCriteria},
  RVProc in '..\Shared\RVProc.pas',
  PIUtils in '..\..\..\FUNCS\PIUtils.pas',
  Progress in 'Progress.pas' {frmProgress};

{$R *.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.CreateForm(TfrmCriteria, frmCriteria);
  Application.CreateForm(TfrmProgress, frmProgress);
  Application.Run;
end.
