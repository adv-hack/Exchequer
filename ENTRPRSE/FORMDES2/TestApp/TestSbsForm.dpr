program TestSbsForm;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  Forms,
  TestF in 'TestF.pas' {Form1},
  DLLInt in 'X:\ENTRPRSE\FORMDES2\DLLInt.pas',
  Globtype in 'X:\ENTRPRSE\FORMDES2\GLOBTYPE.PAS';

{$R *.res}
{$R X:\Entrprse\FormDes2\WinXPMan.Res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
