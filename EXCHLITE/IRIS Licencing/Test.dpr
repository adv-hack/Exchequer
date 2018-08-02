program Test;

uses
  Forms,
  TestF in 'TestF.pas' {frmLicenceTest},
  oIRISLicence in 'oIRISLicence.pas',
  LicDetsF in 'LicDetsF.pas' {frmLicenceDetails};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLicenceTest, frmLicenceTest);
  Application.Run;
end.
