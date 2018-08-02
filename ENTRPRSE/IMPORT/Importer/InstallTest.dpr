program InstallTest;

uses
  Forms,
  uUpdatePaths in 'w:\ENTRPRSE\IMPORT\Importer\uUpdatePaths.pas',
  Testmain in 'Testmain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
