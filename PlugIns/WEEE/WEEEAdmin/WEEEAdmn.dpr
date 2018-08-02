program WEEEAdmn;

uses
  Forms,
  Windows,  
  SysSetup in 'SysSetup.pas' {frmWEEESetup},
  BTFiles in '..\common\BTFiles.pas',
  WEEEProc in '..\common\WEEEPROC.PAS',
  ReportCatDetails in 'ReportCatDetails.pas' {frmReportCatDetails},
  Import in 'Import.pas' {frmImport},
  prntprev in 'PRNTPREV.PAS' {FrmPrintPreview},
  ReportCriteria in 'ReportCriteria.pas' {frmReportCriteria},
  Reports in 'REPORTS.PAS' {ModReports},
  Prntdlg in 'PRNTDLG.PAS' {PrintDlg},
  PageDlg in 'PAGEDLG.PAS' {PageSetupDlg},
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.res}
{$R \Entrprse\FormDes2\WinXPMan.res}

{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.Title := 'WEEE Plug-In Setup';
  Application.CreateForm(TfrmWEEESetup, frmWEEESetup);
  Application.CreateForm(TModReports, ModReports);
  Application.Run;
end.
