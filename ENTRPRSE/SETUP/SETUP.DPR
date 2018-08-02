library setup;

{$REALCOMPATIBILITY ON}

uses
  D6OnHelpFix,
  conHTMLHelp,
  Dialogs,
  Forms,
  Windows,
  SetupU in 'SetupU.pas',
  setupbas in 'SETUPBAS.PAS' {SetupTemplate},
  DIRDLG4 in 'DIRDLG4.PAS' {frmSCDDirDlg},
  DiskU in 'X:\Entrprse\R&D\Disku.pas',
  wstcfg in 'Wstcfg.pas' {frmWStationConfig},
  Finddlg3 in 'Finddlg3.pas' {frmFindDlg},
  CDVerU in 'Cdveru.pas',
  Crypto in 'X:\Entrprse\MULTCOMP\Crypto.pas',
  PaperCfg in 'PaperCfg.pas' {frmPaperConfig},
  WsStart in 'WsStart.pas' {frmWsStartup},
  Licence in 'Licence.pas' {frmLicence},
  WsReady in 'WsReady.pas' {frmWSReady},
  LicFuncs in 'LicFuncs.pas',
  WLicFile in 'X:\Entrprse\CD\Wlicfile.pas',
  EntLic in 'X:\Entrprse\MULTCOMP\Entlic.pas',
  CompUtil in 'X:\Entrprse\multcomp\COMPUTIL.PAS',
  EntMods in 'Entmods.pas' {frmEntModules},
  EntReady in 'Entready.pas' {frmEntReady},
  InstMeth in 'Instmeth.pas' {frmEntInstMeth},
  Crystal in 'Crystal.pas',
  SerialU in 'X:\Entrprse\MULTCOMP\Serialu.pas',
  setupdi2 in 'Setupdi2.pas' {DirectoryDialog},
  LocalU in 'Localu.pas',
  CompType in 'Comptype.pas' {frmCompanyType},
  InstType in 'Insttype.pas' {frmInstallType},
  PaperWS in 'PaperWS.pas' {frmPaperWS},
  Paperws2 in 'Paperws2.pas' {frmPaperWSAdv},
  Import in 'Import.pas',
  CalWinF in 'CalWinF.pas' {frmDLLWarning},
  Version in 'Version.pas',
  DiskUtil in 'X:\Entrprse\Funcs\Diskutil.pas',
  EBusBeta in 'EBusBeta.pas' {frmEbusBeta},
  OutlookAddInsF in 'OutlookAddInsF.PAS' {frmOutlookAddIns},
  WGEUtil in 'WGEUtil.PAS' {frmWGEOpts},
  LicRec in 'X:\sbslib\win\excommon\LicRec.pas',
  ENRENAME in 'ENRENAME.PAS' {frmRenameError},
  AddInfoF in 'AddInfoF.pas' {frmAdditionalInfo},
  eBusIcon in 'EBUSICON.PAS' {frmEBusIcons},
  ClSvrVer in 'CLSVRVER.PAS' {frmCSEngineVer},
  Brand in 'X:\Entrprse\FUNCS\Brand.pas',
  WStationSetupF in 'WStationSetupF.pas' {frmWorkstationSetup},
  GLTemplateF in 'GLTemplateF.pas' {frmSelectGLTemplate},
  ProgramGroupF in 'ProgramGroupF.pas' {frmSelectProgramGroup},
  IAOICEF in 'IAOICEF.pas' {frmIAOInstallICE},
  WGEServerF in 'WGEServerF.pas' {frmWorkgroupServerWarning},
  CompleteF in 'CompleteF.pas' {frmSetupComplete},
  WelcomeF in 'WelcomeF.pas' {frmWelcome},
  PreReqs in 'X:\EXCHLITE\CD\PreReqs.pas',
  DebugU in 'X:\EXCHLITE\CD\DebugU.pas',
  CISDBPreReqF in 'CISDBPreReqF.pas' {frmDashbPreRequisits},
  OSChecks in 'X:\EXCHLITE\CD\OSChecks.pas',
  IRISLicU in 'IRISLicU.pas',
  iaoOSChecksF in 'iaoOSChecksF.pas' {frmIAOOSChecks},
  OSErrorFrame in 'X:\EXCHLITE\CD\OSErrorFrame.pas' {fraOSError: TFrame},
  wsData in 'X:\Entrprse\MULTCOMP\WSDATA.PAS',
  LocalDrv in 'LocalDrv.pas',
  InstallServiceF in 'InstallServiceF.pas' {frmInstallService},
  ServiceManager in 'X:\Entrprse\FUNCS\ServiceManager.pas',
  NetworkUtil in 'X:\Entrprse\FUNCS\NetworkUtil.pas',
  WGEServerNameF in 'WGEServerNameF.pas' {frmServerPCName},
  StartStopServiceF in 'StartStopServiceF.pas' {frmStartStopService},
  SQLPreReqF in 'SQLPreReqF.pas' {frmSQLPreRequisits},
  SentIcon in 'SentIcon.PAS' {frmSentimailIcons},
  SQLICONS in 'SQLICONS.PAS' {frmSQLIcons},
  OutlookUtil in 'X:\Entrprse\FUNCS\OutlookUtil.pas',
  WSCISDBPreReqF in 'WSCISDBPreReqF.pas' {frmWSDashbPreRequisits},
  uMSXMLUtil in 'uMSXMLUtil.pas',
  uFontUtil in 'uFontUtil.pas',
  uGetCompanyDetail in 'uGetCompanyDetail.pas' {frmGetCompDetail},
  uGetSQLServerMachine in 'uGetSQLServerMachine.pas' {frmGetSQLServerMachine},
  uGetBtrieveDetail in 'uGetBtrieveDetail.pas',
  SQLUtils in 'X:\Entrprse\FUNCS\SQLUtils.pas',
  HTMLHelpPath in 'X:\Entrprse\MULTCOMP\HTMLHelpPath.pas',
  VistaPermissions in 'VistaPermissions.pas',
  uSQLReadOnlyInfo in 'uSQLReadOnlyInfo.pas' {frmSQLReadOnlyInfo},
  SQLH_MemMap in 'X:\Entrprse\MULTCOMP\SQLHelper\SQLH_MemMap.Pas',
  Win64Info in 'Win64Info.pas',
  PathFuncs in 'PathFuncs.pas',
  IRISLicenceDLL in 'X:\COMPON\IRISLicence\IRISLicenceDLL.pas';

(*
procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: MemMap_OpenSharedData;
    DLL_PROCESS_DETACH: MemMap_CloseSharedData;
  end;
end;
*)

// MH 08/07/2013 v7.0.5: Re-instated RES file in order to allow file version info
{$R *.RES}

exports
  { SetupU.Pas }
  GetEnterDir,
  CheckForFonts,
  GetConnectFlags,
  GetCDVer,
  GetWStationOpts,
  GetCompCreateMethod,
  GetLastEntDir,
  SetScalableSQL,
  GetDriveSno,
  SCD_GetLastEntDir,
  SCD_SetEnvPath,
  SCD_DieBtrieveDie,
  SCD_CheckForBtrieve,
  SCD_SetEnterprisePath,
  SCD_SetPVSWPath,
  SCD_SetEnterpriseFaxingPath,

  // CompType.Pas
  iaoGetCompanyType,

  { WstCfg.Pas }
  SCD_GetWStationConfig,
  SCD_CheckPath,

  { EntMods.Pas }
  GetEntModules,

  { InstMeth.Pas }
  GetEntInstallMethod,

  { Licence.Pas }
  DispEntLicence,

  { EntReady.Pas }
  SCD_ReadyDlg,

  { WsReady.Pas }
  SCD_WSReadyDlg,

  { WsStart.Pas }
  SCD_WSStartRepl,

  { Crystal.Pas }
  SCD_FindCrystalDir,

  { DirDlg3.Pas }
  SCD_GetEnterDir,

  { LocalU.Pas }
  SCD_CheckLocalDir,
  SCD_CalcLocalParams,

  { InstType.Pas }
  SCD_GetInstallType,

  { PaperCfg.Pas }
  SCD_GotPaperless,
  SCD_PaperlessConfig,

  { PaperWS.Pas }
  SCD_PaperlessWS,
  SCD_CheckForDriver,

  { eBusIcon.Pas }
  SCD_EBusIcons,

  { SentIcon.Pas }
  SCD_SentimailIcons,

  { StorInfo.Pas }
  //SCD_StoreSetupInfo,

  { Import.Pas }
  SCD_InitImport,
  SCD_InitExchDll,

  { CalWinF.Pas }
  SCD_DLLChecks,

  { Version.Pas }
  SCD_IsWin2000,

  { EBusBeta.Pas }
  SCD_EBusBeta,

  { ClSvrVer.Pas }
  SCD_GetCSEngineDefaults,
  SCD_GetCSEngineVer,

  { EnRename.Pas }
  SCD_EntRenameCheck,

  { AddInfoF.Pas }
  SCD_InfoDialog,

  // WelcomeF.Pas
  DispWelcome,

  // GLTemplateF.Pas
  SelectGLTemplate,

  // CompleteF.Pas
  SCD_SetupComplete,

  // WGEUtil.Pas - Workgroup Engine Functions
  SCD_GetPCName,
  SCD_GetWGEInstallInfo,
  SCD_GetWGEOptions,
  SCD_CheckForKosherWGE,

  // WGEServerF - Workgroup Engine Server PC Warning
  DisplayWGEServerWarning,

  // WStationSetupF
  DisplayWorkstationSetupQuery,

  // ProgramGroupF - Program Group dialog
  SelectGroup,

  // CISDBPreReqF
  DashbCheckForPreReqs,

  // WSCISDBPreReqF
  SCD_DotNet20Missing,
  SCD_VCCRedistMissing,
  SCD_WorkstationCISDBPreReqs,
  // MH 29/01/2013 v7.1 ABSEXCH-13793: Added Pre-Reqs for VAT 100
  SCD_WorkstationVAT100PreReqs,

  // IRISLicU
  iaoGetIRISClientInstallerDir,

  // IAOICEF.Pas
  iaoAskInstallICE,

  // iaoOSChecksF
  iaoCheckSupportedOS,

  // wsData
  SCD_LoadWSOptions,
  SCD_StoreWSOptions,
  SCD_CalcExchLocal,

  // LocalDrv.Pas
  IsNotLocalDrive,

  // InstallServiceF.Pas
  InstallService,

  // StartStopServiceF.Pas
  StartService,
  StopService,

  // WGEServerNameF.Pas
  GetServerPCName,

  // OutlookAddInsF.Pas
  SCD_OutlookAddIns,

  { LicFuncs.Pas }
  SCD_ProcessLicF,
  SCD_SetInstModRights,
  SCD_SetAutoModRights,
  SCD_SetUpgModRights,
  SCD_SetWSInstDets,
  SCD_GetIRISLicFilename,

  {uMSXMLUtils.pas}
  IsMSXMLInstalled,

  {uFontutil.pas}
  CheckFontIsInstalled,

  {uGetCompanyDetail.pas VM 01/05/2007 we need company code and name before setting up sql and btr.sql company info}
  SCD_EntGetCompanyDetail,

  {uGetSqlServerMachine.pas VM 09/05/2007 needed for locationg sql server machines...}
  SCD_EntGetSQLServerMachine,

  {uGetBtrieveDetail.pas VM 14/05/2007 loading the btrieve info details}
  SCD_GetBtrieveDetails,

  {usqlreadonlyinfo.pas VM 26/06/2007 load sql read only user/password and the database name}
  SCD_EntGetSQLReadOnlyInfo,

  {setupu.dll VM29/06/2007 set the dbtype for chris' btrieve emulator}
  SCD_SetEnterpriseDBTYPE,

  // VistaPermissions.Pas
  SCD_SetVistaDirPermissions,

  // SQLPreReqF.Pas
  SCD_CheckForPreReqs,

  // wsData.Pas
  SCD_LoadWSOptions,
  SCD_StoreWSOptions,

  // Win64Info.Pas
  SCD_CheckForWin64,

  // SQLIcons
  SCD_SQLIcons,

  // PathFuncs
  SCD_AddToPath,

  // HTMLHelpPath
  SCD_SetHTMLPath,
  SCD_LoadHTMLHelpContextId
  ;

begin
  { First, assign the procedure to the DLLProc variable }
  {DllProc := @DLLEntryPoint;}
  { Now invoke the procedure to reflect that the DLL is attaching
    to the process }
  {DLLEntryPoint(DLL_PROCESS_ATTACH);}
end.

