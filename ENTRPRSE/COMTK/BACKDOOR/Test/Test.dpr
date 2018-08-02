program Test;

uses
  Forms,
  TestF in 'TestF.pas' {Form1},
  SecCodes in 'X:\ENTRPRSE\COMTK\SECCODES.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
