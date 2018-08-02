program LinkTest;

uses
  Forms,
  TestFormTemplate in 'W:\ENTRPRSE\COMTK\TESTFRAMEWORK\TESTS\TEMPLATE\TESTFORMTEMPLATE.pas' {frmTestTemplate},
  LinkTestF in 'LinkTestF.pas' {frmTestTemplate1},
  AddLink in 'AddLink.pas';
{$R *.res}
         
begin
  Application.Initialize;
  Application.CreateForm(TfrmTestTemplate1, frmTestTemplate1);
  Application.Run;
end.
