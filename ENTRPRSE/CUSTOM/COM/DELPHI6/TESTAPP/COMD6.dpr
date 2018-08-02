program COMD6;

uses
  Forms,
  D6ClientF in 'D6ClientF.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
