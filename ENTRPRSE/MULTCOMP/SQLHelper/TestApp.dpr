program TestApp;

{$ALIGN 1}

uses
  Forms,
  TestF in 'TestF.pas' {Form1},
  SQLH_MemMap in 'SQLH_MemMap.Pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
