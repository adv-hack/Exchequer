program CustDisc;

uses
  Forms,
  TestFormTemplate in '\\BMTDEV1\PRUTHERFORD\67\ENTRPRSE\COMTK\TESTFRAMEWORK\TESTS\TEMPLATE\TESTFORMTEMPLATE.pas' {frmTestTemplate},
  AddDiscF in 'AddDiscF.pas' {frmTestTemplate1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTestTemplate1, frmTestTemplate1);
  Application.Run;
end.
