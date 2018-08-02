program TestUp;
{$REALCOMPATIBILITY ON}    {* Delphi 2 to 5 *}

{* This is the test program for updating transactions *}

uses
  ShareMem,
  Forms,
  TestEdit,
  Crypto in '..\MULTCOMP\Crypto.pas';

{Form1}

{$R *.RES}

begin
  Application.Title := 'Enterprise DLL - Example Program (32-Bit)';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

