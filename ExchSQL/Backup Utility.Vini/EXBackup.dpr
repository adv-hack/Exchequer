program EXBackup;

uses
  Forms,
  uExBackup in 'uExBackup.pas' {frmExBackup},
  uWait in 'uWait.pas' {frmWait};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Backup';
  Application.CreateForm(TfrmExBackup, frmExBackup);
  Application.Run;
end.
