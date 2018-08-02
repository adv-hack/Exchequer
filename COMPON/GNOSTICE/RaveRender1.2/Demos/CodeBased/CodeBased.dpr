program CodeBased;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  MainDataMod in 'MainDataMod.pas' {dmMain: TDataModule},
  ChartTest in 'ChartTest.PAS' {frmTChartTest},
  Adhocprn in 'Adhocprn.PAS' {frmAdhocprn},
  EMailData in 'EMailData.pas' {frmEMailData};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmMain, dmMain);
  Application.Run;
end.
