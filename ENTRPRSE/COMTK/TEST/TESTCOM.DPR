program TestCom;

uses
  Forms,
  SetupBas in '..\..\SETUP\SETUPBAS.PAS' {SetupTemplate},
  testmain in 'testmain.pas' {frmComTestForm},
  testcons in 'testcons.pas',
  testini in 'testini.pas',
  testsys in 'testsys.pas',
  TESTTK04 in 'TESTTK04.PAS',
  codelist in 'codelist.pas' {frmCodeList},
  UNCCache in '..\..\..\ExchSQL\BtrvSQL\UNCCache.pas',
  ExchequerRelease in 'w:\SBSLIB\WIN\EXCOMMON\ExchequerRelease.pas';

{$R *.RES}
{$R TestComXP.Res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmComTestForm, frmComTestForm);
  Application.Run;
end.
