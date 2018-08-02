library ENTCOMP2;

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
  ControlsAtomFix in '\Entrprse\Funcs\ControlsAtomFix.pas',
  Dialogs,
  SysUtils,
  Classes,
  EntRegU in 'Entregu.pas',
  regprog in 'Regprog.pas' {RegisterProgress},
  DLLWise in 'Dllwise.pas',
  EntInitU in 'EntInitU.pas',
  VarConst in 'Varconst.pas',
  CompWiz1 in 'COMPWIZ1.PAS' {CompDetail1},
  CompWiz2 in 'Compwiz2.pas' {CompDetail2},
  CompWiz3 in 'Compwiz3.pas' {CompDetail3},
  Compwiz4 in 'Compwiz4.pas' {CompDetail4},
  CompWiz5 in 'Compwiz5.pas' {CompDetail5},
  DllComp in 'Dllcomp.pas',
  CompDlg in 'Compdlg.pas' {CompanyDialog},
  CompOpt in 'Compopt.pas' {frmCompOpt},
  CompUtil in 'Computil.pas',
  EntReplU in 'Entreplu.pas',
  CompDelt in 'Compdelt.pas' {DeleteCompany},
  CompDet in 'Compdet.pas' {frmCompDet},
  DiskU in 'X:\Entrprse\R&D\Disku.pas',
  SetupBas in 'X:\Entrprse\SETUP\SETUPBAS.PAS' {SetupTemplate},
  Btrvu2 in 'X:\SBSLIB\WIN\WIN32\Btrvu2.pas',
  EntOdbcU in 'Entodbcu.pas',
  DiskUtil in 'X:\Entrprse\Funcs\Diskutil.pas',
  ChkCurrV in 'ChkCurrV.pas',
  DllFunc in 'DllFunc.pas',
  Dllwise2 in 'Dllwise2.pas',
  ChkDelet in 'Chkdelet.pas',
  ModRels in 'ModRels.pas',
  WLicFile in 'X:\Entrprse\CD\Wlicfile.pas',
  EntLic in 'EntLic.Pas',
  SetupReg in 'SetupReg.pas',
  BtFuncs in 'BtFuncs.pas',
  secwarn in 'Secwarn.pas' {SecurityWarning},
  SecWarn2 in 'Secwarn2.pas' {frmSecWarn},
  CommsInt in 'X:\Entrprse\ENTCOMMS\Commsint.pas',
  SecWarn3 in 'Secwarn3.pas' {frmSecWarn2},
  ERC in 'X:\Entrprse\LICENCE\Erc.pas',
  GlobExcH in 'GlobExcH.pas',
  SysCode in 'SysCode.pas',
  Base34 in '..\BASE36\Base34.pas',
  ReplSysF in 'ReplSysF.pas',
  TCompObj in 'TCompObj.pas',
  wsData in 'wsData.pas',
  SerialU in 'Serialu.pas',
  rpcommon in 'X:\Entrprse\FORMDES2\Rpcommon.pas',
  Globtype in 'X:\Entrprse\FORMDES2\Globtype.pas',
  formutil in 'X:\Entrprse\FORMDES2\Formutil.pas',
  CustDets in 'Custdets.pas' {frmCustDets},
  ReBuildF in 'ReBuildF.pas' {frmConfirmRebuild},
  HookSec in 'HOOKSEC.PAS',
  ConvData in 'ConvData.pas',
  ENTLIC2 in 'ENTLIC2.PAS',
  LicRec in 'X:\sbslib\win\excommon\LicRec.pas',
  CompSec in 'CompSec.pas',
  ESNCHECK in 'ESNCHECK.PAS' {frmESNWarning},
  UcTestF in 'UcTestF.pas' {frmUCountTest},
  UserSec in 'UserSec.pas',
  Phonetic in 'X:\Entrprse\FUNCS\Phonetic.pas',
  ESNPWF in 'ESNPWF.PAS' {frmESNPassword},
  ChkComp in 'ChkComp.pas',
  APIUtil in 'X:\Entrprse\FUNCS\APIUTIL.PAS',
  ProgF in 'ProgF.PAS' {frmProgress},
  CHK4USER in 'CHK4USER.PAS' {dmCheckForUsersRep: TDataModule},
  SetModU in 'SETMODU.PAS' {SetModRec},
  HKSECURE in 'HKSECURE.PAS',
  SecFrame in 'SecFrame.pas' {PlugInSecFrame: TFrame},
  PWGELocF in 'PWGELocF.pas',
  EntLicence in 'X:\Entrprse\DRILLDN\EntLicence.pas',
  LogUtil in 'X:\Entrprse\FUNCS\LogUtil.pas',
  WGEConfig in 'WGEConfig.pas',
  ICSCompany in 'ICSCompany.pas',
  RegComF in 'RegComF.pas' {frmCOMRegistration},
  RegCom in 'RegCom.pas',
  BtrDel in 'BtrDel.pas' {frmDeleteBetrieve},
  CreateLicence in 'CreateLicence.pas',

  //PR: 28/11/2014 Order Payments
  EnterpriseSecurity_TLB in '..\CUSTOM\EntSecur\EnterpriseSecurity_TLB.pas',
  PlugInSec in 'PLUGINSEC.PAS',

  IntrastatXML in '\Entrprse\R&D\Intrastat\IntrastatXML.pas',
  DebugU in '\ExchLite\CD\DebugU.pas',

  // Pervasive File Encryption ------------------------------
  MainF in '\Entrprse\DataEncryption\MainF.pas' {TfrmMain},
  oBtrieveFile in 'oBtrieveFile.pas',
  oCompanyFile in '..\DataEncryption\oCompanyFile.pas',
  EncryptionThread in '..\DataEncryption\EncryptionThread.pas',
  ConfirmF in '..\DataEncryption\ConfirmF.pas' {frmConfirmation},
  ProgressF in '..\DataEncryption\ProgressF.pas' {frmEncryptProgress},

  uSQLClass in 'X:\ENTRPRSE\SETUP\uSQLClass.pas',

  // MH 16/04/2018 2018-R1 ABSEXCH-20406: Initialise SystemSetup DataVersionNo for New MSSQL Installations
  AddSystemSetupFields in '\Entrprse\MultComp\Upgrades\AddSystemSetupFields.pas';

{$R Arrows.RES}
{$R *.RES}

Exports
  { DllComp.Pas }
  InitCompMan,
  ShowCompMan,
  InitCompDll,
  InitCompDllEx,
  InitCompDllEx2,
  TermCompDll,
  TermCompDll2,
  TermCompDll3,
  //MDICompMan,

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
  SCD_SetupLocalBtrieve,
  SCD_EntRunBtrieve,
  SCD_SetupWorkstation,
  SCD_SetupWorkstationBtrieve,
  SCD_SetupV8Engine,
  SCD_SetupWorkgroupCOM,
  SCD_Setupv8WGEReg,

  { ReplSysF.Pas }
  SCD_ReplicateLicence,
  REPLICATEENTLICENCE,

  { WsData.Pas }
  SCD_LoadWSOptions,
  SCD_StoreWSOptions,
  SCD_CalcExchLocal,

  { SecWarn2.Pas }
  MCM_SECWIZARD,

  { HookSec.Pas }
  CheckHookSecurity,

  { ConvData.Pas }
  SCD_ConvertData,

  { CompSec.Pas - Company Count Security Functions }
  SCD_SetupCompanyCount,
  Setup_CheckCompCount,
  GetActualCompanyCount,
  GetLicencedCompanyCount,

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
  LockControlRec,
  UnlockControlRec,

  { HkSecure.Pas - Enterprise v5.00 Hook Security }
  hsGetSRC,

  { PWGELocF.Pas - Pervasive.SQL Worgkroup Engine Locator File functions }
  SCD_GenRootLocFiles,
  SCD_GenLocFiles,

  // WGEConfig
  iaoConfigureWorkgroupEngine,

  // ICSCompany
  icsGetCommandLineParams,
  icsSendInfoMsg,

  // RegComF
  RegisterCOMObjects,

  { DLLFunc.Pas }
  EX_GETCOMPANY,
  EX_GETCOMPANY2,

  // CreateLicence.Pas
  SCD_CreateLicence,

  {btrdel.pas   VM 13/04/2007 removing old btrieve references }
  SCD_DeleteOldBtrieveFiles,


  //PR: 28/11/2014 Order Payments. COM Toolkit needs to check if Credit Card plug-in is licenced
  // PlugInSec.Pas
  CheckPlugInLicence

  ;

begin
end.
