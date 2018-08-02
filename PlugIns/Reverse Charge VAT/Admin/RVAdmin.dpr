program RVAdmin;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  Forms,
  Windows,  
  ADMIN in 'ADMIN.PAS' {frmAdmin},
  RVProc in '..\Shared\RVProc.pas',
  PIUtils in 'X:\ENTRPRSE\FUNCS\PIUtils.pas',
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.res}
{$R \Entrprse\FormDes2\WinXPMan.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.Run;
end.
