program ConfigSQL;

uses
  Forms,
  TestF in 'TestF.pas' {Form1},
  ServiceManager in 'X:\ENTRPRSE\FUNCS\ServiceManager.pas',
  APIUtil in 'X:\ENTRPRSE\FUNCS\APIUTIL.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
