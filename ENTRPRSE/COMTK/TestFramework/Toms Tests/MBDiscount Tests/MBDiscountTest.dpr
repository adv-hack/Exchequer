program MBDiscountTest;

uses
  Forms,
  TestFormTemplate in 'W:\ENTRPRSE\COMTK\TESTFRAMEWORK\TESTS\TEMPLATE\TESTFORMTEMPLATE.pas' {frmTestTemplate},
  MBDiscountTestF in 'MBDiscountTestF.pas' {frmTestTemplate1},
  AddMBDiscount in 'AddMBDiscount.pas';
{$R *.res}
         
begin
  Application.Initialize;
  Application.CreateForm(TfrmTestTemplate1, frmTestTemplate1);
  Application.Run;
end.
