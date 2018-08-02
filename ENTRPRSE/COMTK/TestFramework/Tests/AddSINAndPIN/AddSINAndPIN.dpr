program AddSINAndPIN;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  TestFormTemplate in '..\TEMPLATE\TESTFORMTEMPLATE.pas' {frmTestTemplate},
  SinAndPinF in 'SinAndPinF.pas' {frmTestTemplate1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTestTemplate1, frmTestTemplate1);
  Application.Run;
end.
