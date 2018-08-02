program cdserno;

uses
  Forms,
  cdserf in 'cdserf.pas' {Form1},
  SerialU in '..\MULTCOMP\SERIALU.PAS',
  IssueU in '..\CD\ISSUEU.PAS';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'CD Serial Number';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
