program Sms_Acc;

uses
  Forms,
  LicForm in 'LICFORM.PAS' {frmSmsAccounts};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSmsAccounts, frmSmsAccounts);
  Application.Run;
end.
