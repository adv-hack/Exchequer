program UpdTrans;

uses
  Forms,
  TestFormTemplate in '..\TEMPLATE\TESTFORMTEMPLATE.pas' {frmTestTemplate},
  UpdateTransF in 'UpdateTransF.pas' {frmTestTemplate1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTestTemplate1, frmTestTemplate1);
  Application.Run;
end.
