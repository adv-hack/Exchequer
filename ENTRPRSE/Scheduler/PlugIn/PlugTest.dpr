program PlugTest;

uses
  Forms,
  testform in 'testform.pas' {Form1},
  PlugTest_TLB in 'PlugTest_TLB.pas',
  TestMain in 'TestMain.pas' {ScheduleTest: CoClass},
  DetailsF in 'DetailsF.pas' {frmDetails},
  Silencer in 'Silencer.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.ShowMainForm := False;
  Application.Run;
end.
