library ExchOut;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  ComServ,
  IKPIHost_TLB in '..\ADX\IKPIHost_TLB.pas',
  oAuthenticationState in '..\Auth-Enterprise\oAuthenticationState.pas',
  Crypto in '..\..\MULTCOMP\CRYPTO.PAS',
  IRISEnterpriseKPI_TLB in 'IRISEnterpriseKPI_TLB.pas',
  KPIPlugin in 'KPIPlugin.pas' {ExchequerOut: CoClass},
  Enterprise_TLB in '..\..\DRILLDN\Enterprise_TLB.pas',
  TOutlookControlClass in 'TOutlookControlClass.pas',
  AccountForm in 'AccountForm.pas' {frmAccount},
  TDaybookTotalsClass in 'TDaybookTotalsClass.pas',
  TimesheetEntryForm in 'TimesheetEntryForm.pas' {frmEnterTimesheets},
  TimesheetListForm in 'TimesheetListForm.pas' {frmTimesheetList},
  DaybookTotalsConfigForm in 'DaybookTotalsConfigForm.pas' {frmConfigureDaybookTotals},
  TAccountStatusClass in 'TAccountStatusClass.pas',
  AuthoriseeForm in 'AuthoriseeForm.pas' {frmAuth},
  AuthoriseeInterface in 'AuthoriseeInterface.pas',
  TAuthoriseeClass in 'TAuthoriseeClass.pas',
  TSentimailClass in 'TSentimailClass.pas',
  SentimailForm in 'SentimailForm.pas' {frmMail},
  SentimailConfigForm in 'SentimailConfigForm.pas' {frmConfigureSentimail},
  Sentimail_TLB in '..\..\SENTMAIL\SENTINEL\Sentimail_TLB.pas',
  CalendarConfigForm in 'CalendarConfigForm.pas' {frmConfigureCalendar},
  TCalendarClass in 'TCalendarClass.pas',
  TLinksClass in 'TLinksClass.pas',
  LinksConfigForm in 'LinksConfigForm.pas' {frmConfigureLinks},
  MessagesConfigForm in 'MessagesConfigForm.pas' {frmConfigureMessages},
  TMessagesClass in 'TMessagesClass.pas',
  StockForm in 'StockForm.pas' {frmStock},
  TExchequerNotesClass in 'TExchequerNotesClass.pas',
  TTasksClass in 'TTasksClass.pas',
  TasksConfigForm in 'TasksConfigForm.pas' {frmConfigureTasks},
  TTopAccountsClass in 'TTopAccountsClass.pas',
  TopAccountsConfigForm in 'TopAccountsConfigForm.pas' {frmConfigureTopAccounts},
  TTopProductsClass in 'TTopProductsClass.pas',
  TopProductsConfigForm in 'TopProductsConfigForm.pas' {frmConfigureTopProducts},
  GmXml in '..\..\..\COMPON\TGMXML\GmXML.pas',
  KPICommon in 'KPICommon.pas',
  TTimesheetClass in 'TTimesheetClass.pas',
  DrillDownForm in 'DrillDownForm.pas' {frmDrillDown},
  AccountStatusConfigForm in 'AccountStatusConfigForm.pas' {frmConfigureAccountStatus},
  AuthoriseeConfigForm in 'AuthoriseeConfigForm.pas' {frmConfigureAuthorisee},
  DaybookTotalsForm in 'DaybookTotalsForm.pas' {frmTotals},
  TimesheetConfigForm in 'TimesheetConfigForm.pas' {frmConfigureTimesheets},
  TTimesheetIniClass in 'TTimesheetIniClass.pas',
  TTimesheetDataClass in 'TTimesheetDataClass.pas',
  TimesheetLineFrame in 'TimesheetLineFrame.pas' {FrameTimesheetLine: TFrame},
  TEmployeeRateClass in 'TEmployeeRateClass.pas',
  TNoteDataClass in 'TNoteDataClass.pas',
  PrntDlgF in 'Ex306\PrntDlgF.pas' {frmPrintDlg},
  PreviewF in 'Ex306\PreviewF.pas',
  TUDPeriodClass in 'TUDPeriodClass.pas',
  PERUTIL in 'PERUTIL.PAS',
  NotesConfigForm in 'NotesConfigForm.pas' {frmConfigureNotes},
  VRWConfigForm in 'VRWConfigForm.pas' {frmConfigureVRW},
  VRWSelectForm in 'VRWSelectForm.pas' {frmSelectVRW},
  VRWCOM_TLB in '..\KPI-VRWCom\VRWCOM_TLB.pas',
  EntLicence in '..\..\DRILLDN\EntLicence.pas',
  TVRWReportsClass in 'TVRWReportsClass.pas',
  entPrevX_TLB in '..\..\FormTK\ACTIVEX\entPrevX_TLB.pas',
  ConfigureDaybookTotalsFrameU in 'ConfigureDaybookTotalsFrameU.pas' {ConfigureDaybookTotalsFrame: TFrame},
  TransactionForm in 'TransactionForm.pas' {TransactionFrm},
  TransactionLineForm in 'TransactionLineForm.pas' {TransactionLineFrm};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
