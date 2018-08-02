program ENPORADM;

uses
  Forms,
  Windows,
  ADMINF in 'ADMINF.PAS' {frmAdmin},
  MCMINTF in 'MCMINTF.PAS',
  USERF in 'USERF.PAS' {frmUserDetails},
  IniIntf in 'INIINTF.PAS',
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.RES}
{$R \Entrprse\FormDes2\WinXPMan.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 09/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.Title := 'Exchequer POR Security Plug-In Administrator';
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.Run;
end.
