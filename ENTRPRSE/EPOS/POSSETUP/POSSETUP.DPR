program PosSetup;

{$REALCOMPATIBILITY ON}

uses
  Sharemem,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  first,
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  SSetup in 'SSetup.pas' {FrmSetup},
  EposComn in '..\Shared\EposComn.pas',
  EposCnst in '..\Shared\EPOSCNST.PAS',
  Startup in 'Startup.pas',
  Login in 'Login.pas' {FrmLogin},
  EPOSProc in '..\Shared\Eposproc.pas',
  EditCard in 'EditCard.pas' {FrmCardDetails},
  ValCfg in '..\Shared\ValCfg.pas',
  MainF in 'MAINF.PAS' {frmMain},
  TXRep in 'TXRep.pas' {frmTXReport},
  CentData in '..\SHARED\CentData.pas',
  TillList in 'TILLLIST.PAS' {FrmTillList},
  about in 'About.pas' {frmAbout},
  PSProc in 'PSProc.pas',
  VarConst in '..\SHARED\VARCONST.PAS',
  LayList in '..\SHARED\LAYLIST.PAS' {frmLayaways},
  EODRep in 'EODREP.PAS' {frmEODReport},
  TillName in '..\SHARED\TILLNAME.PAS',
  Prntdlg in 'PRNTDLG.PAS' {PrintDlg};

{$R *.RES}
{$R POSSETUP.EXE.RES}
{$R ARROWS.RES}

begin
  Application.Initialize;
  Application.HelpFile := 'trade.chm';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
