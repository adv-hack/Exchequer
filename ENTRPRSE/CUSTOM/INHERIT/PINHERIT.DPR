program PInHerit;

uses
  Forms,
  Inherit in 'Inherit.pas' {Form1},
  InhAbstr in 'InhAbstr.pas',
  InhImpl in 'InhImpl.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
