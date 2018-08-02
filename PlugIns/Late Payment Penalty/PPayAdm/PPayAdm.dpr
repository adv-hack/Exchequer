program PPayAdm;

uses
  Forms,
  Windows,  
  Admin in 'ADMIN.PAS' {FrmAdmin},
  BTFILE in '..\Shared\BTFILE.PAS',
  PPayProc in '..\SHARED\PPayProc.pas',
  CustDet in 'CustDet.pas' {frmCustDetails},
  Reports in 'REPORTS.PAS' {ModReports},
  prntprev in 'PRNTPREV.PAS' {FrmPrintPreview},
  Key in 'KEY.PAS',
  Debt in 'DEBT.PAS' {frmDebt},
  DebtDet in 'DEBTDET.PAS' {frmDebtDetails},
  SysSetup in 'SysSetup.pas' {frmSystemSetup},
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.res}
{$R \Entrprse\FormDes2\WinXPMan.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.CreateForm(TFrmAdmin, FrmAdmin);
  Application.CreateForm(TModReports, ModReports);
  Application.Run;
end.
