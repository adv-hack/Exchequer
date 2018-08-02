program Test;

uses
  Forms,
  TestF in 'TestF.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'COM Toolkit Test';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
