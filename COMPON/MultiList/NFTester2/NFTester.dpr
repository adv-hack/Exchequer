program NFTester;

uses
  Forms,
  ftoolopt in 'FTOOLOPT.PAS' {ToolsOptions},
  ToolDetF in 'TOOLDETF.PAS' {ToolDetails},
  FontProc in 'x:\ENTRPRSE\FUNCS\FontProc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TToolsOptions, ToolsOptions);
  Application.Run;
end.
