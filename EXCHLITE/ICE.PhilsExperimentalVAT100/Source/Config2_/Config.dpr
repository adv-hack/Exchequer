program Config;

uses
  Forms,
  uDSRConfigFrame in 'x:\EXCHLITE\ICE\Source\Dashboard\BaseFrames\uDSRConfigFrame.pas' {frmDSRConfigFrame: TFrame},
  uDashConfig in 'X:\EXCHLITE\ICE\Source\Dashboard\uDashConfig.pas' {frmConfiguration};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmConfiguration, frmConfiguration);
  Application.Run;
end.
