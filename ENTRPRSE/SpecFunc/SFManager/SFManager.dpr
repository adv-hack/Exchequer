program SFManager;

uses
  Forms,
  SFManagerDlgU in 'SFManagerDlgU.pas' {SFManagerDlg},
  SFManagerU in '..\SFManagerU.pas',
  SFHeaderU in '..\SFHeaderU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSFManagerDlg, SFManagerDlg);
  Application.Run;
end.
