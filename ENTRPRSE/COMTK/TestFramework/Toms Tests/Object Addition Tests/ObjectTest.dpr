program ObjectTest;

uses
  Forms,
  TestFormTemplate in 'W:\ENTRPRSE\COMTK\TESTFRAMEWORK\TESTS\TEMPLATE\TESTFORMTEMPLATE.pas' {frmTestTemplate},
  ObjectTestF in 'ObjectTestF.pas' {frmTestTemplate1},
  AddObject in 'AddObject.pas',
  AddTransaction in 'AddTransaction.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTestTemplate1, frmTestTemplate1);
  Application.Run;
end.
