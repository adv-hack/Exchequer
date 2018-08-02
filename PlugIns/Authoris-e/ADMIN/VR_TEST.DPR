program vr_test;

uses
  Forms,
  vr1 in 'vr1.pas' {frmVrTest};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmVrTest, frmVrTest);
  Application.Run;
end.
