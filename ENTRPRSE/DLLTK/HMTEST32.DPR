program hmTest32;

uses
  ShareMem,
  Forms,
  TestDLLU;



{$R *.RES}

begin
  Application.Title := 'Enterprise DLL - Example Program (32-Bit)';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

