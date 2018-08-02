program Test;

uses
  Forms,
  TestRead in 'TestRead.pas' {Form1},
  oPlugLic in '..\OPLUGLIC.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Enterprise Plug-In Release Code Licence Viewer';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
