program AltStockCodeTest;

uses
  Forms,
  TestFormTemplate in 'W:\ENTRPRSE\COMTK\TESTFRAMEWORK\TESTS\TEMPLATE\TESTFORMTEMPLATE.pas' {frmTestTemplate},
  AltStockCodeTestF in 'AltStockCodeTestF.pas' {frmTestTemplate1},
  AddAltStockCode in 'AddAltStockCode.pas';
{$R *.res}
         
begin
  Application.Initialize;
  Application.CreateForm(TfrmTestTemplate1, frmTestTemplate1);
  Application.Run;
end.
