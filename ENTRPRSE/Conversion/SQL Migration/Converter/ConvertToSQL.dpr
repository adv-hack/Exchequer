program ConvertToSQL;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}
{$WARN SYMBOL_PLATFORM OFF}

uses
  Sharemem,
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  BaseF in 'BaseF.pas' {frmCommonBase},
  PwordF in 'PwordF.pas' {frmPasswordEntry},
  History in 'HISTORY.pas',
  oConvertOptions in 'oConvertOptions.pas',
  SQLConvertUtils in 'SQLConvertUtils.pas',
  VarConst in '..\..\..\R&D\Varconst.Pas',
  Crypto in '..\..\..\MULTCOMP\CRYPTO.PAS',
  DLLIntf in 'DLLIntf.pas',
  PervDirF in 'PervDirF.pas' {frmSelectExchPervasiveDir},
  CompanyDetailsF in 'CompanyDetailsF.pas' {frmReportingUsers},
  CompanyDetailsFrame in 'CompanyDetailsFrame.pas' {framCompanyDetails: TFrame},
  ReadyToConvertF in 'ReadyToConvertF.pas' {frmReadyToConvert},
  ConvSQLFuncs in 'ConvSQLFuncs.pas',
  SQLH_MemMap in '..\..\..\MULTCOMP\SQLHelper\SQLH_MemMap.Pas',
  CompleteF in 'CompleteF.pas' {frmConversionComplete},
  SerialU in '..\..\..\MULTCOMP\SERIALU.PAS',
  CopyFilesClass in 'CopyFilesClass.pas',
  ProgressF in 'ProgressF.pas' {frmProgressInfo},
  ProgressTreeF in 'ProgressTreeF.pas' {frmConversionProgress},
  oReadThread in 'oReadThread.pas',
  oWriteThread in 'oWriteThread.pas',
  oBaseDataWrite in 'DataWriteObjs\oBaseDataWrite.pas',
  DataConversionWarnings in 'DataConversionWarnings.pas',
  oDataPacket in 'oDataPacket.pas',
  oBtrieveFile in 'oBtrieveFile.pas',
  oGenericBtrieveFile in 'oGenericBtrieveFile.pas',
  GroupsFile in '..\..\..\MultComp\GroupsFile.pas',
  GroupCompFile in '..\..\..\MultComp\GroupCompFile.pas',
  GroupUsersFile in '..\..\..\MultComp\GroupUsersFile.pas',
  EbusVar in '..\..\..\..\Ebus2\Shared\EbusVar.pas',
  EBusLook in '..\..\..\..\Ebus2\Shared\EBusLook.pas',
  Sentimail_TLB in '..\..\..\SentMail\Sentinel\Sentimail_TLB.pas',
  ToolBTFiles in '..\..\..\..\PlugIns\Tools Menu\ToolBTFiles.pas',
  Enterprise01_TLB in '..\..\..\COMTK\Enterprise01_TLB.pas',
  GlobType in '..\..\..\FormDes2\GlobType.pas',
  FixExchDll in 'FixExchDll.pas',
  ConversionLogsF in 'ConversionLogsF.pas' {frmConversionLogs},
  EntLoggerClass in '..\..\..\Funcs\EntLoggerClass.pas',
  EntLogQueueClass in '..\..\..\Funcs\EntLogQueueClass.pas',
  EntLogWriterClass in '..\..\..\Funcs\EntLogWriterClass.pas',
  EntLogIniClass in 'EntLogIniClass.pas',
  LoggingUtils in 'LoggingUtils.Pas',
  CompanyReport in 'CompanyReport.pas',
  DataConversionWarningsF in 'DataConversionWarningsF.pas' {frmDataConversionWarnings},
  Warning_BaseFrame in 'Warning Frames\Warning_BaseFrame.pas' {WarningBaseFrame: TFrame},
  Warning_UnknownVariantFrame in 'Warning Frames\Warning_UnknownVariantFrame.pas' {TWarningUnknownVariantFrame: TFrame},
  Warning_SQLExecutionErrorFrame in 'Warning Frames\Warning_SQLExecutionErrorFrame.pas' {WarningSQLExecutionErrorFrame: TFrame},
  Warning_SQLExecutionExceptionFrame in 'Warning Frames\Warning_SQLExecutionExceptionFrame.pas' {WarningSQLExecutionExceptionFrame: TFrame},
  AuthVar in '..\..\..\..\PlugIns\Authoris-e\BASE\AuthVar.pas',
  SchedVar in '..\..\..\Scheduler\Shared\SchedVar.pas',
  DataObjs in '..\..\..\Scheduler\Shared\DataObjs.pas',
  jcvar in '..\..\..\EARNIE\JobCard\jcvar.pas',
  oAccountContactBtrieveFile in '..\..\..\R&D\AccountContacts\oAccountContactBtrieveFile.pas',
  oAccountContactRoleBtrieveFile in '..\..\..\R&D\AccountContacts\oAccountContactRoleBtrieveFile.pas',
  oOPVATPayBtrieveFile in '..\..\..\R&D\OrderPayments\oOPVATPayBtrieveFile.pas',
  oSystemSetupDataWrite in 'DataWriteObjs\oSystemSetupDataWrite.pas',
  oVAT100DataWrite in 'DataWriteObjs\oVAT100DataWrite.pas';

{$R *.res}

{$R X:\Entrprse\FormDes2\WinXPMan.Res}

begin
  Application.Initialize;
  { CJS - 2013-07-08 - ABSEXCH-14438 - update branding and copyright }
  Application.Title := 'Exchequer Pervasive To SQL Conversion Utility';
  Application.HelpFile := 'ConvertToSQL.Chm';
  Application.CreateForm(TfrmPasswordEntry, frmPasswordEntry);
  Application.Run;
end.
