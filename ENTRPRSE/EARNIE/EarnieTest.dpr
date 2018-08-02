program EarnieTest;

uses
  Forms,
  EarnieTst in 'EarnieTst.pas' {Form1},
  ExpEarnie in 'ExpEarnie.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
