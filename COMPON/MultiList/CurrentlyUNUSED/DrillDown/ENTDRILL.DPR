program EntDrill;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  Forms,
  SETPATH in 'SETPATH.PAS',
  MAINF in 'MAINF.PAS' {frmMainDebug},
  Enterprise_TLB in 'Enterprise_TLB.pas',
  ODRILL in 'ODRILL.PAS' {DrillDown: CoClass},
  EntLicence in 'EntLicence.pas',
  FUNCLIST in 'FUNCLIST.PAS',
  FuncParser in 'FuncParser.pas',
  PROCFUNC in 'PROCFUNC.PAS',
  ENTDATA in 'ENTDATA.PAS',
  VARCONST in 'VARCONST.PAS',
  NOMLINEF in 'NOMLINEF.PAS' {frmGLLineDrill},
  DISPDOCF in 'DISPDOCF.PAS' {frmDisplayTransManager},
  EBGLLINE in 'EBGLLINE.PAS',
  TRANSOPF in 'TRANSOPF.PAS' {frmSOPTrans},
  VATMATRX in 'VATMATRX.PAS',
  DDLOGIN in 'DDLOGIN.PAS' {ELogFrm},
  PAYLINEU in 'PAYLINEU.PAS' {PayLine},
  SOPLINEF in 'SOPLINEF.PAS' {frmSOPLine},
  MEMMAP in 'MEMMAP.PAS',
  SRCPPYF in 'SRCPPYF.PAS' {RecepForm},
  SELDATAF in 'SELDATAF.PAS' {frmSelectData},
  SELDATAO in 'SELDATAO.PAS',
  DDABOUTF in 'DDABOUTF.PAS' {frmAbout},
  HISTORY in 'HISTORY.PAS',
  DRILLLOG in 'DRILLLOG.PAS';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  {$IFNDEF DRILLDEBUG}
    Application.ShowMainForm := False;
  {$ENDIF} // DRILLDEBUG
  Application.Title := 'Exchequer Enterprise Drill-Down Add-In';
  Application.CreateForm(TfrmMainDebug, frmMainDebug);
  Application.Run;
end.
