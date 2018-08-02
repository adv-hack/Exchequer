program smtpindy10;

uses
  Forms,
  uSMTPindy10 in 'uSMTPindy10.pas' {Form1},
  uExMail in 'uExMail.pas',
  uMailBase in 'uMailBase.pas',
  uMailMessage in 'uMailMessage.pas',
  uMailMessageAttach in 'uMailMessageAttach.pas',
  uPOP3 in 'uPOP3.pas',
  uSMTP in 'uSMTP.pas',
  uIMAP in 'uIMAP.pas',
  uMAPI in 'uMAPI.pas',
  uFTP in 'uFTP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
