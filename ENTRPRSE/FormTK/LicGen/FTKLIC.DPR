program FTKLic;

uses
  Forms,
  LicF in 'LicF.pas' {Form1},
  oFTKLic in 'oFTKLic.pas',
  Base34 in 'X:\ENTRPRSE\BASE36\BASE34.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Forms Toolkit Licence Generator';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
