program GLTree;

uses
  Forms,
  GLTreeF in 'GLTreeF.pas' {frmGeneralLedger},
  GLDetlF in 'GLDetlF.pas' {frmGLDetail};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Enterprise COM Toolkit - General Ledger Demo';
  Application.CreateForm(TfrmGeneralLedger, frmGeneralLedger);
  Application.Run;
end.
