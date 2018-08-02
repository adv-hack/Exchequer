program Counters;

uses
  Forms,
  TestFormTemplate in 'W:\ENTRPRSE\COMTK\TESTFRAMEWORK\TESTS\TEMPLATE\TESTFORMTEMPLATE.pas' {frmTestTemplate},
  CounterF in 'CounterF.pas' {frmTestTemplate1},
  CounterClasses in 'CounterClasses.pas',
  CounterClasses2 in 'CounterClasses2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTestTemplate1, frmTestTemplate1);
  Application.Run;
end.
