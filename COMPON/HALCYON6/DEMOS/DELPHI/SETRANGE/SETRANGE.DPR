program SetRange;

uses
  Forms,
  SetRang1 in 'SetRang1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
