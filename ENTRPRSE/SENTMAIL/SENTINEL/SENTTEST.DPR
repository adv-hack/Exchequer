program SENTTEST;

uses
  Forms,
  ELHOOKT in 'ELHOOKT.PAS' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
