program UpdateTrader;

uses
  Forms,
  TestFormTemplate in 'W:\ENTRPRSE\COMTK\TESTFRAMEWORK\TESTS\TEMPLATE\TESTFORMTEMPLATE.pas' {frmTestTemplate},
  UpdTraderF in 'UpdTraderF.pas' {frmTestTemplate1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTestTemplate1, frmTestTemplate1);
  Application.Run;
end.
