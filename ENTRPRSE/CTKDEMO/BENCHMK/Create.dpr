program Create;

uses
  Forms,
  CreateF in 'CreateF.pas' {Form1},
  PerfUtil in 'X:\ENTRPRSE\FUNCS\PerfUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
