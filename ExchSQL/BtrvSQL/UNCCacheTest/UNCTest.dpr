program UNCTest;

uses
  Forms,
  TestF in 'TestF.pas' {Form1},
  UNCCache in '..\UNCCache.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
