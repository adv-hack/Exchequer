program CabView;

uses
  Forms,
  CabView1 in 'CabView1.PAS' {Form1};

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
