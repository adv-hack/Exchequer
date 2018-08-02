program Config;

uses
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  uConf in 'uConf.pas' {frmConf},
  uDSRSettings in '..\DSR\uDSRSettings.pas',
  uDSRConfigFrame in '..\Dashboard\BaseFrames\uDSRConfigFrame.pas' {frmDSRConfigFrame: TFrame},
  uPopSmtpWiz in 'uPopSmtpWiz.pas' {frmPOPSMTPWiz};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Configuration';
  Application.CreateForm(TfrmConf, frmConf);
  Application.Run;
end.
