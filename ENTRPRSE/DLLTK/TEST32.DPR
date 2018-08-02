program Test32;
{$REALCOMPATIBILITY ON}    {* Delphi 2 to 5 *}

uses
  ShareMem,
  Forms,
  TestDLLU in 'TestDLLU.pas'; {Form1}

{$R *.RES}

begin
  Application.Title := 'Enterprise DLL - Example Program (32-Bit)';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

