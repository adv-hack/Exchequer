program Test;

uses
  Forms,
  TestF in 'TestF.pas' {Form1},
  XMLFUNCS in 'XMLFUNCS.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
