program AddSor;

uses
  Forms,
  TestFormTemplate in 'W:\ENTRPRSE\COMTK\FRAMEWORK\TESTS\TEMPLATE\TESTFORMTEMPLATE.pas' {frmTestTemplate},
  Unit1 in 'Unit1.pas' {frmTestTemplate1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTestTemplate1, frmTestTemplate1);
  Application.Run;
end.
