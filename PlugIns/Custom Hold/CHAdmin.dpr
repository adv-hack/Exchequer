program CHAdmin;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}
uses
  Forms,
  Holdform in 'Holdform.pas' {frmHoldAdmin},
  pass2 in 'pass2.pas' {frmPassWord},
  pass1 in 'pass1.pas' {frmPass1},
  Shared in 'Shared.pas';

{$R *.res}
{$R \Entrprse\FormDes2\WinXPMan.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPass1, frmPass1);
  Application.Run;
end.
