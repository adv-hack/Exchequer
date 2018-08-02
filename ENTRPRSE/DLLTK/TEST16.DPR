program Test16;

uses
  Forms,
  Usedllu in 'USEDLLU.PAS',
  Testdllu in 'TESTDLLU.PAS' {Form1};

{$R *.RES}

begin
  Application.Title := 'DLL Test Program - Exchequer Enterprise';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

