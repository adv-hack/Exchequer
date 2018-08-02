Program EntDataQ;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  Forms,
  D6OnHelpFix,
  conHTMLHelp,
  MainF in 'MainF.pas',
  Enterprise_TLB in 'Enterprise_TLB.pas',
  oDataQ in '..\oDataQ.pas' {DataQuery: CoClass},
  ImportF3 in '..\IMPORTF3.PAS' {frmMiscOptions},
  ImportF2 in '..\IMPORTF2.PAS' {frmFilterCritera},
  ImportF1 in '..\IMPORTF1.PAS' {frmSelectCompany},
  DQHist in '..\DQHist.pas',
  StrUtil in '..\..\FUNCS\STRUTIL.PAS',
  DQAboutF in '..\DQABOUTF.PAS' {frmAbout},
  VAOUtil in 'x:\ENTRPRSE\FUNCS\VAOUtil.pas',
  UA_Const in '\Entrprse\R&D\UA_Const.pas';

{$R *.TLB}

{$R *.RES}
{$R \Entrprse\Formdes2\winxpman.res}

begin
  Application.Initialize;
  {$IFNDEF DRILLDEBUG}
    Application.ShowMainForm := False;
  {$ENDIF} // DRILLDEBUG
  Application.Title := 'Exchequer Data Query Add-In';
  Application.HelpFile := 'EnterOLE.Chm';
  Application.CreateForm(TfrmDataQueryExe, frmDataQueryExe);
  Application.Run;
end.
