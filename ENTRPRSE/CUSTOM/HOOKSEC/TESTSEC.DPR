program TestSec;

uses
  Forms,
  TestF in 'TestF.pas' {Form1},
  ChainU in 'X:\ENTRPRSE\CUSTOM\STANDARD\CHAINU.PAS',
  CheckSec in 'X:\ENTRPRSE\CUSTOM\STANDARD\CHECKSEC.PAS';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
