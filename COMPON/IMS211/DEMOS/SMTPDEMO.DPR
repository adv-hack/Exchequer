program smtpdemo;

uses
  Forms,
  smtpmain in 'smtpmain.pas' {SMTPForm},
  smtpsu in 'smtpsu.pas' {SetupDlg},
  msabout in 'msabout.pas' {AboutDlg};

{$R *.RES}

begin
  Application.CreateForm(TSMTPForm, SMTPForm);
  Application.Run;
end.
