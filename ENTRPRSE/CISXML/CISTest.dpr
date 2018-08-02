program CISTest;

uses
  Forms,
  TestF in 'TestF.pas' {Form1},
  CISWrite in 'CISWrite.pas',
  CISXCnst in 'CISXCnst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
