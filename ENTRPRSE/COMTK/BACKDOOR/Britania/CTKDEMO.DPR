program CTKDemo;

uses
  Forms,
  DemoF in 'DemoF.pas' {Form1},
  CTKUtils in 'CTKUtils.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
