library Entcomp;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  ControlsAtomFix in '..\Funcs\ControlsAtomFix.pas',
  D6OnHelpFix,
  conHTMLHelp,
  Dialogs,
  SysUtils,
  Classes,
  Windows,
  EntRegU in 'Entregu.pas',
  regprog in 'Regprog.pas' {RegisterProgress},
  DLLWise in 'Dllwise.pas',
  EntInitU in 'EntInitU.pas',
  VarConst in 'VARCONST.PAS',
  CompWiz1 in 'COMPWIZ1.PAS' {CompDetail1},
  CompWiz2 in 'Compwiz2.pas' {CompDetail2},
  CompWiz3 in 'Compwiz3.pas' {CompDetail3},
  Compwiz4 in 'Compwiz4.pas' {CompDetail4},
  CompWiz5 in 'Compwiz5.pas' {CompDetail5},
  DllComp in 'Dllcomp.pas',
  CompDlg in 'Compdlg.pas' {CompanyDialog},
  CompOpt in 'COMPOPT.PAS' {frmCompOpt},
  CompUtil in 'Computil.pas',
  EntReplU in 'Entreplu.pas',
  CompDelt in 'Compdelt.pas' {DeleteCompany},
  CompDet in 'COMPDET.PAS' {frmCompDet},
  DiskU in '..\R&D\Disku.pas',
  SetupBas in '..\SETUP\SETUPBAS.PAS' {SetupTemplate},
  Btrvu2 in '..\..\SBSLIB\WIN\WIN32\Btrvu2.pas',
  EntOdbcU in 'ENTODBCU.PAS',
  DiskUtil in '..\Funcs\Diskutil.pas',
  ChkCurrV in 'CHKCURRV.PAS',
  DllFunc in 'DllFunc.pas',
  Dllwise2 in 'Dllwise2.pas',
  ChkDelet in 'Chkdelet.pas',
  ModRels in 'ModRels.pas',
  WLicFile in '..\CD\Wlicfile.pas',
  EntLic in 'EntLic.Pas',
  SetupReg in 'SetupReg.pas',
  secwarn in 'Secwarn.pas' {SecurityWarning},
  SecWarn2 in 'SECWARN2.PAS' {frmSecWarn},
  CommsInt in '..\ENTCOMMS\Commsint.pas',
  SecWarn3 in 'Secwarn3.pas' {frmSecWarn2},
  ERC in '..\LICENCE\Erc.pas',
  GlobExcH in 'GlobExcH.pas',
  SysCode in 'SysCode.pas',
  Base34 in '..\BASE36\Base34.pas',
  ReplSysF in 'ReplSysF.pas',
  TCompObj in 'TCompObj.pas',
  SerialU in 'Serialu.pas',
  rpcommon in '..\FORMDES2\Rpcommon.pas',
  Globtype in '..\FORMDES2\Globtype.pas',
  CustDets in 'Custdets.pas' {frmCustDets},
  ReBuildF in 'ReBuildF.pas' {frmConfirmRebuild},
  HookSec in 'HOOKSEC.PAS',
  ConvData in 'ConvData.pas',
  ENTLIC2 in 'ENTLIC2.PAS',
  LicRec in '..\..\sbslib\win\excommon\LicRec.pas',
  CompSec in 'CompSec.pas',
  ESNCHECK in 'ESNCHECK.PAS' {frmESNWarning},
  UcTestF in 'UcTestF.pas' {frmUCountTest},
  UserSec in 'USERSEC.PAS',
  PlugInSec in 'PLUGINSEC.PAS',
  Phonetic in '..\FUNCS\Phonetic.pas',
  ESNPWF in 'ESNPWF.PAS' {frmESNPassword},
  ChkComp in 'ChkComp.pas',
  APIUtil in '..\FUNCS\APIUTIL.PAS',
  ProgF in 'ProgF.PAS' {frmProgress},
  CHK4USER in 'CHK4USER.PAS' {dmCheckForUsersRep: TDataModule},
  SetModU in 'SETMODU.PAS' {SetModRec},
  SecFrame in 'SecFrame.pas' {PlugInSecFrame: TFrame},
  MUREL2 in 'MUREL2.pas' {frmEntUserCount},
  CHKSIZEF in 'CHKSIZEF.PAS' {frmCheckFileSize},
  History in 'HISTORY.PAS',
  GroupListF in 'GroupListF.pas' {frmGroupList},
  GroupsFile in 'GroupsFile.pas',
  GroupDetailF in 'GroupDetailF.pas' {frmGroupDetail},
  SavePos in '..\FUNCS\SavePos.pas',
  MCMFindF in 'MCMFindF.pas' {frmAdvancedFind},
  LinkCompaniesF in 'LinkCompaniesF.pas' {frmLinkCompanies},
  GroupCompFile in 'GroupCompFile.pas',
  MaintainCompaniesF in 'MaintainCompaniesF.pas' {frmMaintainCompanies},
  EntLicence in '..\DRILLDN\EntLicence.pas',
  CompListMCMF in 'CompListMCMF.pas' {frmStandardMCM},
  CommonMCM in 'CommonMCM.pas',
  CompListBureauF in 'CompListBureauF.pas' {frmBureauMCM},
  BureauLoginF in 'BureauLoginF.pas' {frmBureauLogin},
  BureauSecurity in 'BureauSecurity.pas',
  GroupUsersFile in 'GroupUsersFile.pas',
  UserDetailF in 'UserDetailF.pas' {frmUserDetail},
  ChangeUserPWord in 'ChangeUserPWord.pas',
  RepGroupsInputF in 'RepGroupsInputF.pas' {frmGroupsReportFilter},
  PrintToF in 'PrintToF.pas' {frmPrintTo},
  RepGroups in 'RepGroups.pas' {dmGroupsReport: TDataModule},
  IRISLicF in 'IRISLicF.pas' {frmIRISLicence},
  WizdMsg in '..\..\EXCHLITE\CD\WizdMsg.pas',
  oIRISLicence in '..\..\EXCHLITE\IRIS Licencing\oIRISLicence.pas',
  ActivateF in 'ActivateF.pas' {frmActivateSystem},
  CompInfo in 'CompInfo.pas',
  ExScreen in '..\FORMDES2\ExScreen.pas',
  EnterpriseSecurity_TLB in '..\CUSTOM\EntSecur\EnterpriseSecurity_TLB.pas',
  ResetWorkstationUserCounts in 'ResetWorkstationUserCounts.pas',
  ResetUserCountsF in 'ResetUserCountsF.pas' {frmResetUserCounts},
  MainF in '..\DataEncryption\MainF.pas' {frmMain},
  oBtrieveFile in 'oBtrieveFile.pas',
  oCompanyFile in '..\DataEncryption\oCompanyFile.pas',
  EncryptionThread in '..\DataEncryption\EncryptionThread.pas',
  ConfirmF in '..\DataEncryption\ConfirmF.pas' {frmConfirmation},
  ProgressF in '..\DataEncryption\ProgressF.pas' {frmEncryptProgress},

  // MH 16/04/2018 2018-R1 ABSEXCH-20406: Initialise SystemSetup DataVersionNo for New MSSQL Installations
  AddSystemSetupFields in '\Entrprse\MultComp\Upgrades\AddSystemSetupFields.pas';

{$R Arrows.RES}
{$R *.RES}

// MH 30/05/2014 v7.0.10 ABSEXCH-15404: Added PE Flags to force entire component to be loaded into memory
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}

Exports
  { DllComp.Pas }
  InitCompMan,
  ShowCompMan,
  // MH 15/02/2013 v7.0.2 ABSEXCH-13994: Added new function with flags for resetting Workstation's User Counts
  ShowCompManEx,
  InitCompDll,
  InitCompDllEx,
  InitCompDllEx2,
  TermCompDll,
  TermCompDll2,
  TermCompDll3,
  EntComp_ShareScreen,

  { DLLWise.Pas }
  EntClientServer,
  EntDataCopy,
  EntRunBtrieve,
  EntInitCompany,
  EntRegister,
  EntRegConnect,
  //EntCompanyWiz,
  EntRegDataSources,
  EntModRexBat,

  { DLLWise2.Pas - functions added for Single CD Setup }
  //SCD_EntSet30DaySec,
  SCD_EntCompanyWizard,
  SCD_EntCopyMainSecurity,
  SCD_EntDataCopy,
  //SCD_SetULC,

  { EntReplU.Pas }
  EntReplicate,
  SCD_ReplicateFiles,

  { ModRels.Pas }
  SCD_SetupLicence,

  { BtFuncs.Pas }
  //SCD_SetupLocalBtrieve,
  //SCD_EntRunBtrieve,
  //SCD_SetupWorkstation,
  //SCD_SetupV8Engine,

  { ReplSysF.Pas }
  SCD_ReplicateLicence,
  REPLICATEENTLICENCE,

  { WsData.Pas }
  //SCD_LoadWSOptions,
  //SCD_StoreWSOptions,

  { SecWarn2.Pas }
  MCM_SECWIZARD,

  { HookSec.Pas }
  CheckHookSecurity,

  { ConvData.Pas }
  SCD_ConvertData,

  { CompSec.Pas - Company Count Security Functions }
  SCD_SetupCompanyCount,
  Setup_CheckCompCount,

  { UserSec.Pas }
  GetCurrentUserCounts,
  GetSystemUserInstances,
  RemoveCIDLoginRef,
  RemoveCIDLoginRefEx,
  AddLoginRef,
  AddLoginRefWithCoCode,
  RemoveLoginRef,
  RemoveLoginRefEx,
  CheckForUserLogin,

  // V5SECREL HM 11/01/02: Removed as security mechanism integrated into EntSecur.DLL Com Object
  { HkSecure.Pas - Enterprise v5.00 Hook Security }
  //hsGetSRC,

  // PlugInSec.Pas
  CheckPlugInLicence,

  { DLLFunc.Pas }
  EX_GETCOMPANY2,
  EX_GETCOMPANY;

begin
end.
