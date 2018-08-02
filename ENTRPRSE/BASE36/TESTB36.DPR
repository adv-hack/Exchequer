program TestB36;

uses
  Forms,
  TestF in 'TestF.pas' {Form1},
  Base36 in 'Base36.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
