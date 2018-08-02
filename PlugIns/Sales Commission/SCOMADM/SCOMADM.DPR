program SComAdm;

{$ALIGN 1}  { Variable Alignment Disabled }

uses
  Forms,
  Windows,
  Admin in 'ADMIN.PAS' {FrmAdmin},
  SysSetup in 'SYSSETUP.PAS' {frmSystemSetup},
  CommDet in 'COMMDET.PAS' {FrmCommissionDetails},
  SCTDet in 'SCTDet.pas' {FrmSCTDetails},
  SComProc in 'SCOMPROC.PAS',
  RepWiz in 'REPWIZ.PAS' {frmRepWizard},
  Reports in 'REPORTS.PAS' {ModReports},
  prntprev in 'PRNTPREV.PAS' {FrmPrintPreview},
  Prntdlg in 'PRNTDLG.PAS' {PrintDlg},
  VarConst in '..\shared\VARCONST.PAS',
  KEY in 'KEY.PAS',
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.res}
{$R \Entrprse\FormDes2\WinXPMan.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP} //RJ 17/02/2016 2016-R1 ABSEXCH-17247: Adding PE flags release to plug-ins.

begin
  Application.Initialize;
  Application.CreateForm(TFrmAdmin, FrmAdmin);
  Application.CreateForm(TModReports, ModReports);
  Application.Run;
end.
