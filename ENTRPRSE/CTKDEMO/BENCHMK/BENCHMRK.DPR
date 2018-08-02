program BenchMrk;

uses
  Forms,
  MainF in 'MainF.pas' {Form3},
  USEDLLU in '..\..\EXDLLNEW\Usedllu.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
