program BankStatementTest;

uses
  Forms,
  TestFormTemplate in 'W:\ENTRPRSE\COMTK\TESTFRAMEWORK\TESTS\TEMPLATE\TESTFORMTEMPLATE.pas' {frmTestTemplate},
  BankStatementTestF in 'BankStatementTestF.pas' {frmTestTemplate1},
  AddBankStatement in 'AddBankStatement.pas';
{$R *.res}
         
begin
  Application.Initialize;
  Application.CreateForm(TfrmTestTemplate1, frmTestTemplate1);
  Application.Run;
end.
