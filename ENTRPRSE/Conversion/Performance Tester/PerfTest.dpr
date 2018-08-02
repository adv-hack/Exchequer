program PerfTest;

{$REALCOMPATIBILITY ON}

uses
  Forms,
  MainF in 'MainF.pas' {frmMain},
  LeagueTableF in 'LeagueTableF.pas' {frmLeagueTable},
  History in 'History.pas';

{$R *.res}
{$R PerfTest.Exe.Res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer v6.00 Pre-Conversion Performance Tester';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
