program QMail32;

uses
  Forms,
  MailForm in 'MailForm.pas' {frmMail},
  AboutForm in 'AboutForm.pas' {frmAbout};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMail, frmMail);
  Application.Run;
end.
