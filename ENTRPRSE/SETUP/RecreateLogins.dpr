program RecreateLogins;

uses
  Forms,
  SetupBas in 'X:\ENTRPRSE\SETUP\SETUPBAS.PAS' {SetupTemplate},
  RecreateLoginsFrmU in 'RecreateLoginsFrmU.pas' {RecreateLoginsFrm},
  SQLH_MemMap in 'X:\ENTRPRSE\MULTCOMP\SQLHelper\SQLH_MemMap.Pas',
  DebugLogU in 'W:\ExchSQL\BtrvSQL\DebugLogU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TRecreateLoginsFrm, RecreateLoginsFrm);
  Application.Run;
end.
