program Project1;

uses
  Forms,
  TTDF in 'TTDF.pas' {Form1},
  DiscF in 'DiscF.pas' {Form2},
  MultiBuyF in 'MultiBuyF.pas' {Form3},
  TransLineF in 'TransLineF.pas' {Form4},
  NewLineF in 'NewLineF.pas' {Form5},
  NewLine2F in 'NewLine2F.pas' {Form6};

{$R *.res}
{$R X:\Entrprse\Formdes2\WinXPMan.Res}

begin
  Application.Initialize;
  Application.CreateForm(TForm6, Form6);
  Application.Run;
end.
