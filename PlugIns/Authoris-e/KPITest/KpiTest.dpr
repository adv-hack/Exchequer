program KpiTest;

uses
  Forms,
  TestF in 'TestF.pas' {Form1},
  KpiInt in '..\ADMIN\KpiInt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
