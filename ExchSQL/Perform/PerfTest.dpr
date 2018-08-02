program PerfTest;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}
uses
  Sharemem,
  Forms,
  Mainf in 'Mainf.pas' {frmMain},
  TestObj in 'TestObj.pas',
  ExWrap1U in '..\..\ENTRPRSE\SENTMAIL\SENTINEL\EXWRAP1U.PAS',
  ExtObj in 'ExtObj.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Performance Tester';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
