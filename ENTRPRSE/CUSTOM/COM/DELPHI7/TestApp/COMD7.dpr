program COMD7;

uses
  Forms,
  D7ClientF in 'D7ClientF.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
