program CSBackup;

uses
  D6OnHelpFix,
  conHTMLHelp,

  Forms,
  uClientSyncBackup in 'uClientSyncBackup.pas' {frmCSBackup};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Client Sync Backup';
  Application.CreateForm(TfrmCSBackup, frmCSBackup);
  Application.Run;
end.
