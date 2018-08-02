program COMD5;

uses
  Forms,
  D5ClientF in 'D5ClientF.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
