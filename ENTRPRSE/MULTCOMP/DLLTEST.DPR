program dlltest;

uses
  ShareMem,
  Forms,
  EntRegU in 'EntRegU.pas',
  mditestf in 'mditestf.pas' {Form2},
  testform in 'testform.pas' {Form1},
  regprog in 'regprog.pas' {RegisterProgress},
  EntInitU in 'Entinitu.pas',
  VarConst in 'Varconst.pas',
  CompWiz1 in 'CompWiz1.pas' {CompDetail1},
  CompWiz2 in 'CompWiz2.pas' {CompDetail2},
  CompWiz3 in 'CompWiz3.pas' {CompDetail3},
  Compwiz4 in 'Compwiz4.pas' {CompDetail4},
  CompWiz5 in 'CompWiz5.pas' {CompDetail5},
  CompList in 'Complist.pas' {Form_CompanyList},
  CompDelt in 'Compdelt.pas' {DeleteCompany},
  CompDet in 'Compdet.pas' {frmCompDet},
  CompDlg in 'Compdlg.pas' {CompanyDialog},
  CompOpt in 'Compopt.pas' {frmCompOpt},
  CompUtil in 'Computil.pas',
  EntReplU in 'EntReplU.pas',
  MDICompL in 'MDICompL.pas' {Form_MDICompList},
  EntDataU in 'EntDataU.pas',
  CopyDatF in 'CopyDatF.pas' {CopyDataWiz1},
  CopyOptF in 'Copyoptf.pas' {CopyDataWiz2},
  DiskU in '\ENTRPRSE\R&D\Disku.pas',
  secwarn in 'secwarn.pas' {SecurityWarning},
  SetupBas in '\ENTRPRSE\SETUP\Setupbas.pas' {SetupTemplate},
  rexsave in 'rexsave.pas' {Form_REXWarn},
  EntOdbcU in 'EntOdbcU.pas',
  DiskUtil in '\ENTRPRSE\RIGHTS\Diskutil.pas',
  TestF2 in 'TestF2.pas' {Form3};

{$R *.RES}
{$R Arrows.RES}

begin
  Application.Initialize;
  Application.Title := 'EntComp.DLL Test Utility';
  Application.HelpFile := 'ENTRPRSE.HLP';
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TSecurityWarning, SecurityWarning);
  Application.CreateForm(TSetupTemplate, SetupTemplate);
  Application.CreateForm(TForm_REXWarn, Form_REXWarn);
  Application.Run;
end.
