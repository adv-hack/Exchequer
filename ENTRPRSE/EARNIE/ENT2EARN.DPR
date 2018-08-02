program Ent2Earn;

uses
  Forms,
  CmnEarnie32 in 'CmnEarnie32.pas',
  main in 'main.pas' {FrmMain},
  Configuration in 'Configuration.pas' {FrmConfiguration},
  Directory in 'Directory.pas' {FrmDirectory},
  logFileRtn in 'logFileRtn.pas',
  LogFiles in 'LogFiles.pas' {FrmLogFiles},
  LogFileViewer in 'LogFileViewer.pas' {FrmLogFileViewer},
  ExpEarn in 'ExpEarn.pas' {frmDoExport},
  Crypto in 'X:\ENTRPRSE\MULTCOMP\CRYPTO.PAS';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmConfiguration, FrmConfiguration);
  Application.Run;
end.
