program PurchaseOrderTest;

uses
  Forms,
  TestFormTemplate in 'W:\ENTRPRSE\COMTK\TESTFRAMEWORK\TESTS\TEMPLATE\TESTFORMTEMPLATE.pas' {frmTestTemplate},
  PurchaseOrderTestF in 'PurchaseOrderTestF.pas' {frmTestTemplate1},
  AddPurchaseOrder in 'AddPurchaseOrder.pas';
{$R *.res}
         
begin
  Application.Initialize;
  Application.CreateForm(TfrmTestTemplate1, frmTestTemplate1);
  Application.Run;
end.
