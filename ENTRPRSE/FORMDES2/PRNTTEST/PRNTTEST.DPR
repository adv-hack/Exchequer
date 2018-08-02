program PrntTest;

uses
  Forms,
  MainU in 'MainU.pas' {Form1},
  PreviewU in 'PreviewU.pas' {Form2},
  RPDevice in 'X:\COMPON\RAVE4\SOURCE\RPDEVICE.PAS';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Printing Test Utility';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
