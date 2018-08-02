program CounterTest;

uses
  Forms,
  CounterClasses in 'CounterClasses.pas',
  AcSubCounterClasses in 'AcSubCounterClasses.pas',
  CounterTestF in 'CounterTestF.pas' {frmCounterMain},
  BaseCounterClasses in 'BaseCounterClasses.pas',
  Counters in 'Counters.pas',
  AcCounter in 'AcCounter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCounterMain, frmCounterMain);
  Application.Run;
end.
