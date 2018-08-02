program entSecurDemo;

uses
  Forms,
  main in 'main.pas' {frmMain},
  EnterpriseSecurity_TLB in 'W:\ENTRPRSE\CUSTOM\EntSecur\EnterpriseSecurity_TLB.pas';

{$R *.res}
{$R W:\Entrprse\FormDes2\WINXPMAN.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
