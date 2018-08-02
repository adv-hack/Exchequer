program WrdAlign;

uses
  Forms,
  AlignU in 'AlignU.pas' {Form1},
  AlignedU in 'AlignedU.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Toolkit DLL - Word Alignment Testing Utility';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
