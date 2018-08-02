program ExtSrchAdmin;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  Forms,
  AdminF in 'AdminF.pas' {frmAdmin},
  History in '..\Common\History.pas',
  ExchequerRelease in 'X:\SBSLIB\WIN\EXCOMMON\ExchequerRelease.pas',
  oSettings in '..\Common\oSettings.pas';

{$R *.res}
{$R w:\Entrprse\FormDes2\WinXPMan.Res}


begin
  Application.Initialize;
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.Run;
end.
