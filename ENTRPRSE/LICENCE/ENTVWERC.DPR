program EntVwErc;

{$REALCOMPATIBILITY ON}

uses
  Forms,
  VwErcF in 'VwErcF.pas' {Form1},
  ERC in 'Erc.pas',
  Crypto in '..\MULTCOMP\Crypto.pas',
  GlobExcH in '..\MULTCOMP\Globexch.pas',
  SerialU in '..\MULTCOMP\Serialu.pas',
  Base34 in '..\BASE36\Base34.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Enterprise ERC Viewer';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
