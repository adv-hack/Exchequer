unit SetupReg;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

interface

Uses Classes, Dialogs, FileCtrl, Forms, IniFiles, Registry, SysUtils,
     Windows, ShellAPI, StdCtrls, APIUtil;


Type
  TSetupEntRegistry = Class;

  {-----------------------}

  {$IFDEF REG}
    TProgressFunc = Procedure (Const Msg : ShortString) Of Object;
  {$ENDIF}

  {-----------------------}

  // HM 13/06/01: New section added as have found that the following registry entry has
  //              been corrupted on at least one machine, and potentially a lot more:-
  //
  //              Btrieve Technologies\Microkernel Engine\Version  6.15\Microkernel Interface\Settings\Target Engine
  //
  //              This problem usually surfaces as an error 10120 (Err 20 - Company.Dat) when
  //              upgrading Exchequer.
  TBtrieve615MKIntF = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO   : TRegistry;
  Protected
    Function  GetLocalProp(Index : Integer) : SmallInt;
    Procedure SetLocalProp(Index : Integer; Value : SmallInt);
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btTargetEngine : SmallInt Index 1 Read GetLocalProp Write SetLocalProp;
  End; { TBtrieve615MKIntF }

  {-----------------------}

  TBtrieve615IntF = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO : TRegistry;
  Protected
    Function  GetLocalProp(Index : Integer) : SmallInt;
    Procedure SetLocalProp(Index : Integer; Value : SmallInt);
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btLocal : SmallInt Index 1 Read GetLocalProp Write SetLocalProp;
    Property btRequester : SmallInt Index 2 Read GetLocalProp Write SetLocalProp;
    Property btLoadRetries : SmallInt Index 3 Read GetLocalProp Write SetLocalProp;
  End; { TBtrieve615Intf }

  {-----------------------}

  TBtrieve615Settings = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO : TRegistry;
  Protected
    Function  GetLocalPropI(Index : Integer) : LongInt;
    Procedure SetLocalPropI(Index : Integer; Value : LongInt);
    Function  GetLocalPropS(Index : Integer) : String;
    Procedure SetLocalPropS(Index : Integer; Value : String);
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btBackgroundThreads : LongInt Index 1 Read GetLocalPropI Write SetLocalPropI;
    Property btCompressBuffer : LongInt Index 2 Read GetLocalPropI Write SetLocalPropI;
    Property btCreate5xFiles : String Index 1 Read GetLocalPropS Write SetLocalPropS;
    Property btDiskWaitLimit : LongInt Index 3 Read GetLocalPropI Write SetLocalPropI;
    Property btExtendedBuffer : LongInt Index 12 Read GetLocalPropI Write SetLocalPropI;
    Property btFileShareOnLocal : String Index 2 Read GetLocalPropS Write SetLocalPropS;
    Property btFileShareRemote : String Index 3 Read GetLocalPropS Write SetLocalPropS;
    Property btHideIcon : String Index 4 Read GetLocalPropS Write SetLocalPropS;
    Property btMaxClients : LongInt Index 4 Read GetLocalPropI Write SetLocalPropI;
    Property btMaxFiles : LongInt Index 5 Read GetLocalPropI Write SetLocalPropI;
    Property btMaxHandles : LongInt Index 6 Read GetLocalPropI Write SetLocalPropI;
    Property btMaxLocks : LongInt Index 7 Read GetLocalPropI Write SetLocalPropI;
    Property btMaxTrans : LongInt Index 8 Read GetLocalPropI Write SetLocalPropI;
    Property btStartupLogo : String Index 5 Read GetLocalPropS Write SetLocalPropS;
    Property btSystransBundleLimit : LongInt Index 9 Read GetLocalPropI Write SetLocalPropI;
    Property btSystransTimeLimit : LongInt Index 10 Read GetLocalPropI Write SetLocalPropI;
    Property btDeleteTmp : String Index 6 Read GetLocalPropS Write SetLocalPropS;
    Property btWorkerThreads : LongInt Index 11 Read GetLocalPropI Write SetLocalPropI;

    // MH 25/07/06: Added to allow Homey to be set to root of windows drive
    Property btHomeDirectory : String Index 7 Read GetLocalPropS Write SetLocalPropS;
  End; { TBtrieve615Settings }

  {-----------------------}

  TBtrieve615Registry = Class(TObject)
  Private
    FIntF     : TBtrieve615Intf;
    FMainO    : TSetupEntRegistry;
    FSettings : TBtrieve615Settings;

    // HM 13/06/01: Added Microkernel Engine\Interface\Settings
    FMKISet   : TBtrieve615MKIntF;
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property MKInterface : TBtrieve615IntF Read FIntF Write FIntF;
    Property Settings : TBtrieve615Settings Read FSettings Write FSettings;

    // HM 13/06/01: Added Microkernel Engine settings
    Property MKISettings : TBtrieve615MKIntF Read FMKISet Write FMKISet;
  End; { TBtrieve615Registry }

  {-----------------------}

  TPerv7MKRouter7 = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO : TRegistry;
  Protected
    Function  GetLocalPropI(Index : Integer) : LongInt;
    Procedure SetLocalPropI(Index : Integer; Value : LongInt);
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btLocal : LongInt Index 1 Read GetLocalPropI Write SetLocalPropI;
    Property btRequester : LongInt Index 2 Read GetLocalPropI Write SetLocalPropI;
    Property btTargetEngine : LongInt Index 3 Read GetLocalPropI Write SetLocalPropI;
  End; { TPerv7MKRouter7 }

  {-----------------------}

  TPerv7MKRouter70 = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO : TRegistry;
  Protected
    Function  GetLocalPropI(Index : Integer) : LongInt;
    Procedure SetLocalPropI(Index : Integer; Value : LongInt);
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btLocal : LongInt Index 1 Read GetLocalPropI Write SetLocalPropI;
    Property btRequester : LongInt Index 2 Read GetLocalPropI Write SetLocalPropI;
    Property btTargetEngine : LongInt Index 3 Read GetLocalPropI Write SetLocalPropI;
  End; { TPerv7MKRouter70 }

  {-----------------------}

  TPerv7MKRouter701 = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO : TRegistry;
  Protected
    Function  GetLocalPropI(Index : Integer) : LongInt;
    Procedure SetLocalPropI(Index : Integer; Value : LongInt);
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btLoadRetries : LongInt Index 1 Read GetLocalPropI Write SetLocalPropI;
    Property btLocal : LongInt Index 2 Read GetLocalPropI Write SetLocalPropI;
    Property btRequester : LongInt Index 3 Read GetLocalPropI Write SetLocalPropI;
    Property btTargetEng : LongInt Index 4 Read GetLocalPropI Write SetLocalPropI;
  End; { TPerv7MKRouter701 }

  {-----------------------}

  TPervMKRouter8 = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO : TRegistry;
  Protected
    Function  GetLocalPropI(Index : Integer) : LongInt;
    Procedure SetLocalPropI(Index : Integer; Value : LongInt);
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btLocal : LongInt Index 1 Read GetLocalPropI Write SetLocalPropI;
    Property btRequester : LongInt Index 2 Read GetLocalPropI Write SetLocalPropI;
    Property btTargetEng : LongInt Index 3 Read GetLocalPropI Write SetLocalPropI;
    Property btUseCacheEngine : LongInt Index 4 Read GetLocalPropI Write SetLocalPropI;
  End; { TPervMKRouter8 }

  {-----------------------}

  TPervWorkgroup8 = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO : TRegistry;
  Protected
    Function  GetLocalPropS(Index : Integer) : String;
    Procedure SetLocalPropS(Index : Integer; Value : String);
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btFileVersion : String Index 1 Read GetLocalPropS Write SetLocalPropS;
    Property btTraceFile : String Index 2 Read GetLocalPropS Write SetLocalPropS;
    Property btTransLogDir : String Index 3 Read GetLocalPropS Write SetLocalPropS;
  End; { TPervWorkgroup8 }

  {-----------------------}

  TPerv7BtrReq7 = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO : TRegistry;
  Protected
    Function  GetLocalPropI(Index : Integer) : LongInt;
    Procedure SetLocalPropI(Index : Integer; Value : LongInt);
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btSplashScreen : LongInt Index 1 Read GetLocalPropI Write SetLocalPropI;
  End; { TPerv7BtrReq7 }

  {-----------------------}

  TPerv7BtrReq70 = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO : TRegistry;
  Protected
    Function  GetLocalPropI(Index : Integer) : LongInt;
    Procedure SetLocalPropI(Index : Integer; Value : LongInt);
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btSplashScreen : LongInt Index 1 Read GetLocalPropI Write SetLocalPropI;
  End; { TPerv7BtrReq70 }

  {-----------------------}

  TPSQLBtrReqSettings = Class(TObject)
  Private
    FMainO  : TSetupEntRegistry;
    RegO    : TRegistry;
    FRegKey : ShortString;
  Protected
    Function  GetLocalPropI(Index : Integer) : LongInt;
    Procedure SetLocalPropI(Index : Integer; Value : LongInt);
  Public
    Constructor Create(MainO : TSetupEntRegistry; Const RegKey : ShortString);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btSplashScreen : LongInt Index 1 Read GetLocalPropI Write SetLocalPropI;
  End; { TPSQLBtrReqSettings }

  {-----------------------}

  TPerv7CommReq7 = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO : TRegistry;
  Protected
    Function  GetLocalPropI(Index : Integer) : LongInt;
    Procedure SetLocalPropI(Index : Integer; Value : LongInt);
    Function  GetLocalPropS(Index : Integer) : String;
    Procedure SetLocalPropS(Index : Integer; Value : String);
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btTCPTimeout : LongInt Index 1 Read GetLocalPropI Write SetLocalPropI;
    Property btSupportedProtocols : String Index 1 Read GetLocalPropS Write SetLocalPropS;
    Property btRuntimeServer : String Index 2 Read GetLocalPropS Write SetLocalPropS;
    Property btNumSatEntries : LongInt Index 2 Read GetLocalPropI Write SetLocalPropI;
  End; { TPerv7CommReq7 }

  {-----------------------}

  TPerv7SSQL4 = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO : TRegistry;
  Protected
    Function  GetLocalPropI(Index : Integer) : LongInt;
    Procedure SetLocalPropI(Index : Integer; Value : LongInt);
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btRequester : LongInt Index 1 Read GetLocalPropI Write SetLocalPropI;
    Property btLocal : LongInt Index 2 Read GetLocalPropI Write SetLocalPropI;
    Property btTargetEng : LongInt Index 3 Read GetLocalPropI Write SetLocalPropI;
    Property btLogins : LongInt Index 4 Read GetLocalPropI Write SetLocalPropI;
  End; { TPerv7SSQL4 }

  {-----------------------}

  TPerv7SSQL401 = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO : TRegistry;
  Protected
    Function  GetLocalPropI(Index : Integer) : LongInt;
    Procedure SetLocalPropI(Index : Integer; Value : LongInt);
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property btRequester : LongInt Index 1 Read GetLocalPropI Write SetLocalPropI;
    Property btLocal : LongInt Index 2 Read GetLocalPropI Write SetLocalPropI;
    Property btTargetEng : LongInt Index 3 Read GetLocalPropI Write SetLocalPropI;
    Property btLogins : LongInt Index 4 Read GetLocalPropI Write SetLocalPropI;
  End; { TPerv7SSQL401 }

  {-----------------------}

  TPSQLProductEntry = Class(TObject)
  Private
    FMainO : TSetupEntRegistry;
    RegO : TRegistry;

    FRegKey     : ShortString;
    FVerLevel   : ShortString;
    FBuildLevel : ShortString;
    FPatchLevel : ShortString;
  Protected
    Function  GetLocalProp (Index : Integer) : ShortString;
    Procedure SetLocalProp (Index : Integer; Value : ShortString);
  Public
    Constructor Create(MainO : TSetupEntRegistry; Const RegKey, VerLevel, BuildLevel, PatchLevel : ShortString);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property pcBuildLevel : ShortString Index 1 Read GetLocalProp Write SetLocalProp;
    Property pcInstallDir : ShortString Index 2 Read GetLocalProp Write SetLocalProp;
    Property pcInstallIniName : ShortString Index 3 Read GetLocalProp Write SetLocalProp;
    Property pcPatchLevel : ShortString Index 4 Read GetLocalProp Write SetLocalProp;
    Property pcSystemDir : ShortString Index 5 Read GetLocalProp Write SetLocalProp;
    Property pcVersionLevel : ShortString Index 6 Read GetLocalProp Write SetLocalProp;
  End; { TPSQLClientProduct }

  {-----------------------}

  TPerv7Registry = Class(TObject)
  Private
    FBtr7          : TPerv7BtrReq7;
    FBtr70         : TPerv7BtrReq70;
    FBtr8          : TPSQLBtrReqSettings;
    FCommReq7      : TPerv7CommReq7;
    FMainO         : TSetupEntRegistry;
    FMKRouter7     : TPerv7MKRouter7;
    FMKRouter70    : TPerv7MKRouter70;
    FMKRouter701   : TPerv7MKRouter701;
    FMKRouter8     : TPervMKRouter8;
    FSSQL4         : TPerv7SSQL4;
    FSSQL401       : TPerv7SSQL401;
    FSQLClientProd : TPSQLProductEntry;
    FSQLWGEProd    : TPSQLProductEntry;
    FWorkgroup8    : TPervWorkgroup8;
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniF : TIniFile);
    Procedure WriteToIni(IniF : TIniFile);
  Published
    Property Btrieve7 : TPerv7BtrReq7 Read FBtr7 Write FBtr7;
    Property Btrieve70 : TPerv7BtrReq70 Read FBtr70 Write FBtr70;
    Property Btrieve8 : TPSQLBtrReqSettings Read FBtr8;
    Property CommReq7 : TPerv7CommReq7 Read FCommReq7 Write FCommReq7;
    Property MKRouter70 : TPerv7MKRouter70 Read FMKRouter70 Write FMKRouter70;
    Property MKRouter701 : TPerv7MKRouter701 Read FMKRouter701 Write FMKRouter701;
    Property MKRouter8 : TPervMKRouter8 Read FMKRouter8;
    Property SSQL4 : TPerv7SSQL4 Read FSSQL4 Write FSSQL4;
    Property SSQL401 : TPerv7SSQL401 Read FSSQL401 Write FSSQL401;
    Property PSQLClientProd : TPSQLProductEntry Read FSQLClientProd;
    Property PSQLWGEProd : TPSQLProductEntry Read FSQLWGEProd;
    Property Workgroup8 : TPervWorkgroup8 Read FWorkgroup8;
  End; { TPerv7Registry }

  {-----------------------}

  TBtrieveRegistry = Class(TObject)
  Private
    FBtrieve615 : TBtrieve615Registry;
    FMainO      : TSetupEntRegistry;
    FPervasive7 : TPerv7Registry;
    FIncludeSQLReg : Boolean;
  Public
    Constructor Create(MainO : TSetupEntRegistry);
    Destructor Destroy; Override;

    Procedure ReadFromIni(IniPath : String);
    Procedure WriteToIni(IniPath : String);
  Published
    Property Btrieve615 : TBtrieve615Registry Read FBtrieve615 Write FBtrieve615;
    Property Pervasive7 : TPerv7Registry Read FPervasive7 Write FPervasive7;

    // MH 25/07/06: Added so that for IAO we can ignore the P.SQL settings and just set the Btrieve settings
    Property IncludeSQLReg : Boolean Read FIncludeSQLReg Write FIncludeSQLReg;
  End; { TBtrieveRegistry }

  {-----------------------}

  TSetupEntRegistry = Class(TObject)
  Private
    FClientServer     : Boolean;
    FClientServerODBC : Boolean;
    FDataDir          : TFileName;
    FEntDir           : TFileName;
    FRegSettings      : TBtrieveRegistry;
    FUserCount        : LongInt;
    FPervVersion      : SmallInt;   // Pervasive.SQL Version Number - 0=6.15,1=7.x,2=2000,3=8.x
    FPervWGEVer       : SmallInt;   // Pervasive.SQL Workgroup Version Number - 0=None, 1=v8,
  Protected
    Procedure SetEntDir (Value : TFileName);

    Function GetDataDir : TFileName;
    Procedure SetDataDir (Value : TFileName);

    Procedure RegisterBtrieve615;
  Public
    {$IFDEF REG}
      // EntReg - Exchequer Configuration and Registration Utility
      DispProgress : TProgressFunc;
    {$ENDIF}

    Constructor Create;
    Destructor Destroy; OverRide;

    Procedure SetupBtrieve615 (Const IncludeSQL : Boolean = True);
    Procedure SetupCOMCustom;
    Procedure SetupCOMTK;
    Procedure SetupGraph;
    Procedure SetupOLESvr;
    Procedure SetupSecuritySvr;
    Procedure SetupDBFWriter;
    Procedure SetupPreviewAX;
    Procedure SetupDataQuery;
    Procedure SetupDrillDown;

    // HM 18/07/02: Added Form Printing Toolkit support
    Procedure SetupFormsTK;

    Procedure SetupEntLib;

    Procedure SetupExchScheduler;

    Procedure SetupSpellCheck(Const LongEntDir : ShortString);

    // HM 05/08/04: Added SystemDir value into HKEY_CURRENT_USER\Software\Exchequer\Enterprise for VAO
    Procedure SetupSystemDir(Const LongEntDir : ShortString);
  Published
    Property RegSettings : TBtrieveRegistry Read FRegSettings Write FRegSettings;
    Property ClientServer : Boolean Read FClientServer Write FClientServer;
    Property EntDir : TFileName Read FEntDir Write SetEntDir;
    Property DataDir : TFileName Read GetDataDir Write SetDataDir;
    Property UserCount : LongInt Read FUserCount Write FUserCount;

    { HM 09/02/00: Added as no Client-Server ODBC flag }
    Property ClientServerODBC : Boolean Read FClientServerODBC Write FClientServerODBC;

    // HM 17/07/03: Added Pervasive version so V8 can be identified and correctly registered
    Property PervasiveVersion : SmallInt Read FPervVersion Write FPervVersion;

    // HM 08/10/03: Added Pervasive Workgrooup version so V8 WGE can be identified and correctly registered
    Property PSQLWorkgroupVer : SmallInt Read FPervWGEVer Write FPervWGEVer;
  End; { TSetupEntRegistry }

// Tries to find the RegSvr32 supplied with OS if possible - may reduce problems
// otherwise returns path to one supplied with Exchequer
Function FindRegSvr32 (EntDir : ShortString) : ANSIString;

function GetLongPathName(lpszShortPath: PChar; lpszLongPath: PChar; cchBuffer: DWORD): DWORD; stdcall;

implementation

{$IFNDEF WCA}
Uses CompUtil, EntLic, LicRec, ComObj;
{$ELSE}
Uses CompUtil, ComObj;
{$ENDIF}

Const
  { Registry Key Constants }
  RK_SoftBtrieve      = '\SOFTWARE\Btrieve Technologies';
  RK_Btr615MKSett     = RK_SoftBtrieve + '\Microkernel Engine\Version  6.15';
  RK_Btr615BaseKey    = RK_SoftBtrieve + '\Microkernel Workstation Engine\Version  6.15';
  RK_Btr615IntFSett   = '\Microkernel Interface\Settings';
  RK_Btr615Settings   = '\Settings';
  RK_Perv7MK7Sett     = 'SOFTWARE\Pervasive Software\Microkernel Router\Version 7\Settings';
  RK_Perv7MK70Sett    = 'SOFTWARE\Pervasive Software\Microkernel Router\Version 7.0\Settings';
  RK_Perv7MK701Sett   = 'SOFTWARE\Pervasive Software\Microkernel Router\Version 7.01\Settings';
  RK_Perv7Btr7Sett    = 'SOFTWARE\Pervasive Software\Btrieve Requester\Version 7\Settings';
  RK_Perv7Btr70Sett   = 'SOFTWARE\Pervasive Software\Btrieve Requester\Version 7.0\Settings';
  RK_Perv7CommR7Sett  = 'SOFTWARE\Pervasive Software\Communications Requester\Version 7.00\Settings';
  RK_Perv7SSQL4Sett   = 'SOFTWARE\Pervasive Software\Scalable SQL Requester\Version 4.00\Settings';
  RK_Perv7SSQL401Sett = 'SOFTWARE\Pervasive Software\Scalable SQL Requester\Version 4.01\Settings';

  RK_PervClientProd   = 'SOFTWARE\Pervasive Software\Products\Pervasive.SQL Client\InstallInfo';
  RK_PervWorkgrpProd  = 'SOFTWARE\Pervasive Software\Products\Pervasive.SQL Workgroup\InstallInfo';

  RK_PervMK8Sett      = 'SOFTWARE\Pervasive Software\Microkernel Router\Version 8\Settings';
  RK_PervWGE8Sett     = 'SOFTWARE\Pervasive Software\MicroKernel Workgroup Engine\Version 8\Settings';

  { Registry Value constants }
  RV_Local           = 'Local';
  RV_Requester       = 'Requester';

  RV_MaxFiles        = 'Max Files';
  RV_MaxHandles      = 'Max Handles';
  RV_MaxLocks        = 'Max Locks';
  RV_Create5xFiles   = 'Create 5x Files';
  RV_MaxTrans        = 'Max Transactions';
  RV_MaxClients      = 'Max Clients';
  RV_WorkerThreads   = 'Worker Threads';
  RV_BackThreads     = 'Background Threads';
  RV_CompressBuffer  = 'Compression Buffer Size';
  RV_SysTransBundle  = 'Systrans Bundle Limit';
  RV_SysTransTime    = 'Systrans Time Limit';
  RV_DiskWait        = 'Disk Wait Limit';
  RV_ShareLocal      = 'File Sharing On Local Drives';
  RV_ShareRemote     = 'File Sharing On Remote Drives';
  RV_StartupLogo     = 'Startup Logo';
  RV_HideIcon        = 'Hide Icon';
  RV_DeleteTmp       = 'Delete Tmp Files';
  RV_ExtBuffer       = 'Extended Buffer Size';

  RV_TargetEng       = 'Target Engine';

  RV_LoadRetries     = 'Load Retries';

  RV_Splash          = 'Splash Screen';

  RV_TCPIPTimout     = 'TCP connect timeout';
  RV_SupProtocols    = 'Supported protocols';
  RV_RuntimeSvr      = 'Runtime server';
  RV_NumStatEnt      = 'NumSatEntries';

  RV_Logins          = 'logins';

  RV_BuildLevel     = 'BuildLevel';
  RV_InstallDir     = 'InstallDir';
  RV_InstallIniName = 'InstallIniName';
  RV_PatchLevel     = 'PatchLevel';
  RV_SystemDir      = 'SystemDir';
  RV_VersionLevel   = 'VersionLevel';

  RV_UseCacheEngine = 'Use Cache Engine';

  RV_HomeDir        = 'Home Directory';

  { Ini File sections }
  Btr6MKIntF         = 'Soft\BtrTech\MicroEng\V6.15\MicroIntf\Settings';
  Btr6IntF           = 'Soft\BtrTech\MicroWorkEng\V6.15\MicroIntf\Settings';
  Btr6Sett           = 'Soft\BtrTech\MicroWorkEng\V6.15\Settings';
  Perv7MK7Sett       = 'Soft\PervSoft\MicroRoutr\V7\Settings';
  Perv7MK70Sett      = 'Soft\PervSoft\MicroRoutr\V70\Settings';
  Perv7MK701Sett     = 'Soft\PervSoft\MicroRoutr\V701\Settings';
  Perv7Btr7Sett      = 'Soft\PervSoft\BtrReq\V7\Settings';
  Perv7Btr70Sett     = 'Soft\PervSoft\BtrReq\V70\Settings';
  Perv7CommR7Sett    = 'Soft\PervSoft\CommReq\V700\Settings';
  Perv7SSql4Sett     = 'Soft\PervSoft\SSQLReq\V400\Settings';
  Perv7SSql401Sett   = 'Soft\PervSoft\SSQLReq\V401\Settings';

//-------------------------------------------------------------------------

function GetLongPathName; external kernel32 name 'GetLongPathNameA';

{
Name:         WinAPI_GetLongPathName
Description:  Obtains the long form of the filename given by ShortName
}
Function WinAPI_GetLongPathName(Const ShortName : ANSIString) : ANSIString;
Begin // WinAPI_GetLongPathName
  SetLength(Result, MAX_PATH);
  SetLength(Result, GetLongPathName(pchar(ShortName), pchar(Result), MAX_PATH));
End; // WinAPI_GetLongPathName

{----------------------------------------------------------------------------}

{ Returns time in seconds }
Function TimeVal : LongInt;
Var
  Hour, Min, Sec, MSec : Word;
begin
  DecodeTime(Now, Hour, Min, Sec, MSec);

  Result := Sec + (60 * (Min + (Hour * 60)));
end;

{----------------------------------------------------------------------------}

// HM 26/08/03: Restored because of weird pathing problems using the RegisterComServer
//              method for the graph control
// HM 25/01/02: Switched from REGSVR32.EXE to Delphi Command
//
// Tries to find the RegSvr32 supplied with OS if possible - may reduce problems
// otherwise returns path to one supplied with Exchequer
Function FindRegSvr32 (EntDir : ShortString) : ANSIString;
Var
  pSystemDir      : PChar;
  SysDir          : ShortString;
  Res             : LongInt;
Begin
  // Get path of System/System32 directory from Windows
  pSystemDir := StrAlloc(Max_Path);
  Res := GetSystemDirectory(pSystemDir, StrBufSize(pSystemDir));
  If (Res > 0) Then Begin
    // Got Path - Format nicely
    SysDir := IncludeTrailingBackslash(pSystemDir);

    // Check to see if RegSvr32.EXe actually exists
    If FileExists (SysDir + 'REGSVR32.EXE') Then
      Result := SysDir + 'REGSVR32.EXE'
    Else
      Result := IncludeTrailingBackSlash (EntDir) + 'REGSVR32.EXE';
  End { If (Res > 0) }
  Else
    Result := IncludeTrailingBackSlash (EntDir) + 'REGSVR32.EXE';
End;

//-------------------------------------------------------------------------

Constructor TBtrieve615MKIntF.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FMainO := MainO;
  RegO   := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;
End; { Create }

Destructor TBtrieve615MKIntF.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TBtrieve615MKIntF.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  btTargetEngine := IniF.ReadInteger (Btr6MKIntF, RV_TargetEng, 0);
End; { ReadFromIni }

Procedure TBtrieve615MKIntF.WriteToIni(IniF : TIniFile);
Begin { WriteToIni }
  IniF.WriteInteger (Btr6MKIntF, RV_TargetEng, btTargetEngine);
End; { WriteToIni }

Function TBtrieve615MKIntF.GetLocalProp(Index : Integer) : SmallInt;
Begin { GetLocalProp }
  Result := 0;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Btr615MKSett + RK_Btr615IntFSett) Then Begin
          { open it }
          If OpenKey(RK_Btr615MKSett + RK_Btr615IntFSett, False) Then Begin
            { Key opened ok }
            Case Index Of
              { Local }
              1  : Begin
                     Result := ReadInteger (RV_TargetEng);

                     // Check for corrupted value
                     If (Result < 0) Or (Result > 1) Then
                       // Default to correct workstation value
                       Result := 0;
                   End;
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := 0;
  End;
End; { GetLocalProp }

Procedure TBtrieve615MKIntF.SetLocalProp(Index : Integer; Value : SmallInt);
Begin { SetLocalProp }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Create key if doesn't exist - sometimes doesn't get created by Btrieve }
        If (Not KeyExists(RK_Btr615MKSett + RK_Btr615IntFSett)) Then
          CreateKey (RK_Btr615MKSett + RK_Btr615IntFSett);

        { Check to see if registry key exists }
        If KeyExists(RK_Btr615MKSett + RK_Btr615IntFSett) Then Begin
          { open it }
          If OpenKey(RK_Btr615MKSett + RK_Btr615IntFSett, True) Then Begin
            { Key opened ok }
            Case Index Of
              { Target Engine }
              1  : WriteInteger (RV_TargetEng, Value);
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalProp }

{----------------------------------------------------------------------------}

Constructor TBtrieve615IntF.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FMainO := MainO;
  RegO   := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;
End; { Create }

Destructor TBtrieve615IntF.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TBtrieve615IntF.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  btLocal := IniF.ReadInteger (Btr6IntF, RV_Local, 1);
  If FMainO.ClientServer Then
    btRequester := IniF.ReadInteger (Btr6IntF, RV_Requester, 1)
  Else
    btRequester := IniF.ReadInteger (Btr6IntF, RV_Requester, 0);

  // HM 09/07/03: Added missing property
  btLoadRetries := IniF.ReadInteger (Btr6IntF, RV_LoadRetries, 5);
End; { ReadFromIni }

Procedure TBtrieve615IntF.WriteToIni(IniF : TIniFile);
Begin { WriteToIni }
  IniF.WriteInteger (Btr6IntF, RV_Local,     btLocal);
  IniF.WriteInteger (Btr6IntF, RV_Requester, btRequester);

  // HM 09/07/03: Added missing property
  If (btLoadRetries <> -1) Then IniF.WriteInteger (Btr6IntF, RV_LoadRetries, btLoadRetries);
End; { WriteToIni }

Function TBtrieve615IntF.GetLocalProp(Index : Integer) : SmallInt;
Begin { GetLocalProp }
  Result := 0;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Btr615BaseKey + RK_Btr615IntFSett) Then Begin
          { open it }
          If OpenKey(RK_Btr615BaseKey + RK_Btr615IntFSett, False) Then Begin
            { Key opened ok }
            Case Index Of
              { Local }
              1  : Result := ReadInteger (RV_Local);

              { Requester }
              2  : Result := ReadInteger (RV_Requester);

              // HM 09/07/03: Added missing property
              { Load Retries }
              3 : If ValueExists (RV_Local) Then
                    Result := ReadInteger (RV_LoadRetries);
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := 0;
  End;
End; { GetLocalProp }

Procedure TBtrieve615IntF.SetLocalProp(Index : Integer; Value : SmallInt);
Begin { SetLocalProp }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { HM 20/02/01: Create key if doesn't exist - sometimes doesn't get created by Btrieve }
        If (Not KeyExists(RK_Btr615BaseKey + RK_Btr615IntFSett)) Then
          CreateKey (RK_Btr615BaseKey + RK_Btr615IntFSett);

        { Check to see if registry key exists }
        If KeyExists(RK_Btr615BaseKey + RK_Btr615IntFSett) Then Begin
          { open it }
          If OpenKey(RK_Btr615BaseKey + RK_Btr615IntFSett, True) Then Begin
            { Key opened ok }
            Case Index Of
              { Local }
              1  : WriteInteger (RV_Local, Value);

              { Requester }
              2  : WriteInteger (RV_Requester, Value);

              // HM 09/07/03: Added missing property
              { Load Retries }
              3 : WriteInteger (RV_LoadRetries, Value);
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalProp }

{----------------------------------------------------------------------------}

Constructor TBtrieve615Settings.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FMainO := MainO;
  RegO := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;
End; { Create }

Destructor TBtrieve615Settings.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TBtrieve615Settings.ReadFromIni(IniF : TIniFile);
Var
  DefHomeDir : ShortString;
Begin { ReadFromIni }
  btBackgroundThreads   := IniF.ReadInteger (Btr6Sett, RV_BackThreads,    18);
  // MH 06/09/06: Increased Compression Buffer size for TAS Books compatibility
  btCompressBuffer      := IniF.ReadInteger (Btr6Sett, RV_CompressBuffer, 8192); //6144);
  btMaxClients          := IniF.ReadInteger (Btr6Sett, RV_MaxClients,     200);
  btMaxFiles            := IniF.ReadInteger (Btr6Sett, RV_MaxFiles,       200);
  btMaxHandles          := IniF.ReadInteger (Btr6Sett, RV_MaxHandles,     1000);
  btMaxLocks            := IniF.ReadInteger (Btr6Sett, RV_MaxLocks,       1000);
  btMaxTrans            := IniF.ReadInteger (Btr6Sett, RV_MaxTrans,       15);
  btWorkerThreads       := IniF.ReadInteger (Btr6Sett, RV_WorkerThreads,  4);
  btExtendedBuffer      := IniF.ReadInteger (Btr6Sett, RV_ExtBuffer,      6144);

  If (FMainO.UserCount > 1) Then Begin
    { Multi-User }
    btDiskWaitLimit       := IniF.ReadInteger (Btr6Sett, RV_DiskWait,       0);
    btSystransBundleLimit := IniF.ReadInteger (Btr6Sett, RV_SysTransBundle, 25);
    btSystransTimeLimit   := IniF.ReadInteger (Btr6Sett, RV_SysTransTime,   400);
  End { If }
  Else Begin
    { Single User }
    btDiskWaitLimit       := IniF.ReadInteger (Btr6Sett, RV_DiskWait,       1000);
    btSystransBundleLimit := IniF.ReadInteger (Btr6Sett, RV_SysTransBundle, 1000);
    btSystransTimeLimit   := IniF.ReadInteger (Btr6Sett, RV_SysTransTime,   2000);
  End; { Else }

  {$IFDEF WCA}
    btCreate5xFiles    := IniF.ReadString  (Btr6Sett, RV_Create5xFiles,  '1');
  {$ELSE}
    btCreate5xFiles    := IniF.ReadString  (Btr6Sett, RV_Create5xFiles,  '0');
  {$ENDIF}
  btFileShareOnLocal := IniF.ReadString  (Btr6Sett, RV_ShareLocal,     '1');
  btFileShareRemote  := IniF.ReadString  (Btr6Sett, RV_ShareRemote,    '1');
  btStartupLogo      := IniF.ReadString  (Btr6Sett, RV_StartupLogo,    '0');
  btHideIcon         := IniF.ReadString  (Btr6Sett, RV_HideIcon,       '1');
  btDeleteTmp        := IniF.ReadString  (Btr6Sett, RV_DeleteTmp,      '0');

  // Calculate default home directory
  DefHomeDir := Copy(WinGetWindowsDir, 1, 3);
  btHomeDirectory    := IniF.ReadString  (Btr6Sett, RV_HomeDir, DefHomeDir);
End; { ReadFromIni }

Procedure TBtrieve615Settings.WriteToIni(IniF : TIniFile);
Begin { WriteToIni }
  IniF.WriteInteger (Btr6Sett, RV_BackThreads,    btBackgroundThreads);
  IniF.WriteInteger (Btr6Sett, RV_CompressBuffer, btCompressBuffer);
  IniF.WriteInteger (Btr6Sett, RV_DiskWait,       btDiskWaitLimit);
  IniF.WriteInteger (Btr6Sett, RV_MaxClients,     btMaxClients);
  IniF.WriteInteger (Btr6Sett, RV_MaxFiles,       btMaxFiles);
  IniF.WriteInteger (Btr6Sett, RV_MaxHandles,     btMaxHandles);
  IniF.WriteInteger (Btr6Sett, RV_MaxLocks,       btMaxLocks);
  IniF.WriteInteger (Btr6Sett, RV_MaxTrans,       btMaxTrans);
  IniF.WriteInteger (Btr6Sett, RV_SysTransBundle, btSystransBundleLimit);
  IniF.WriteInteger (Btr6Sett, RV_SysTransTime,   btSystransTimeLimit);
  IniF.WriteInteger (Btr6Sett, RV_WorkerThreads,  btWorkerThreads);
  IniF.WriteInteger (Btr6Sett, RV_ExtBuffer,      btExtendedBuffer);

  IniF.WriteString  (Btr6Sett, RV_Create5xFiles,  btCreate5xFiles);
  IniF.WriteString  (Btr6Sett, RV_ShareLocal,     btFileShareOnLocal);
  IniF.WriteString  (Btr6Sett, RV_ShareRemote,    btFileShareRemote);
  IniF.WriteString  (Btr6Sett, RV_StartupLogo,    btStartupLogo);
  IniF.WriteString  (Btr6Sett, RV_HideIcon,       btHideIcon);
  IniF.WriteString  (Btr6Sett, RV_DeleteTmp,      btDeleteTmp);

  IniF.WriteString  (Btr6Sett, RV_HomeDir,        btHomeDirectory);
End; { WriteToIni }

Function TBtrieve615Settings.GetLocalPropI(Index : Integer) : LongInt;
Begin { GetLocalPropI }
  Result := 0;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Btr615BaseKey + RK_Btr615Settings) Then Begin
          { open it }
          If OpenKey(RK_Btr615BaseKey + RK_Btr615Settings, False) Then Begin
            { Key opened ok }
            Case Index Of
              { BackGround Threads }
              1  : Result := ReadInteger (RV_BackThreads);
              { Compression Buffer }
              2  : Result := ReadInteger (RV_CompressBuffer);
              { Disk Wait Limit }
              3  : Result := ReadInteger (RV_DiskWait);
              { Max Clients }
              4  : Result := ReadInteger (RV_MaxClients);
              { Max Files }
              5  : Result := ReadInteger (RV_MaxFiles);
              { Max Handles }
              6  : Result := ReadInteger (RV_MaxHandles);
              { Max Locks }
              7  : Result := ReadInteger (RV_MaxLocks);
              { Max Transactions }
              8  : Result := ReadInteger (RV_MaxTrans);
              { SysTrans Bundle Limit }
              9  : Result := ReadInteger (RV_SysTransBundle);
              { SysTrans Time Limit }
              10 : Result := ReadInteger (RV_SysTransTime);
              { Worker Threads }
              11 : Result := ReadInteger (RV_WorkerThreads);
              { Extended Buffer Size }
              12 : Result := ReadInteger (RV_ExtBuffer);
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := 0;
  End;
End; { GetLocalPropI }

Procedure TBtrieve615Settings.SetLocalPropI(Index : Integer; Value : LongInt);
Begin { SetLocalPropI }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Btr615BaseKey + RK_Btr615Settings) Then Begin
          { open it }
          If OpenKey(RK_Btr615BaseKey + RK_Btr615Settings, True) Then Begin
            { Key opened ok }
            Case Index Of
              { BackGround Threads }
              1  : WriteInteger (RV_BackThreads, Value);
              { Compression Buffer }
              2  : WriteInteger (RV_CompressBuffer, Value);
              { Disk Wait Limit }
              3  : WriteInteger (RV_DiskWait, Value);
              { Max Clients }
              4  : WriteInteger (RV_MaxClients, Value);
              { Max Files }
              5  : WriteInteger (RV_MaxFiles, Value);
              { Max Handles }
              6  : WriteInteger (RV_MaxHandles, Value);
              { Max Locks }
              7  : WriteInteger (RV_MaxLocks, Value);
              { Max Transactions }
              8  : WriteInteger (RV_MaxTrans, Value);
              { SysTrans Bundle Limit }
              9  : WriteInteger (RV_SysTransBundle, Value);
              { SysTrans Time Limit }
              10 : WriteInteger (RV_SysTransTime, Value);
              { Worker Threads }
              11 : WriteInteger (RV_WorkerThreads, Value);
              { Extended Buffer Size }
              12 : WriteInteger (RV_ExtBuffer, Value);
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropI }

Function TBtrieve615Settings.GetLocalPropS(Index : Integer) : String;
Begin { GetLocalPropS }
  Result := '';

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Btr615BaseKey + RK_Btr615Settings) Then Begin
          { open it }
          If OpenKey(RK_Btr615BaseKey + RK_Btr615Settings, False) Then Begin
            { Key opened ok }
            Case Index Of
              { Create 5x Files }
              1  : Result := ReadString (RV_Create5xFiles);
              { File Sharing On Local Drives }
              2  : Result := ReadString (RV_ShareLocal);
              { File Sharing On Remote Drives }
              3  : Result := ReadString (RV_ShareRemote);
              { Hide Icon }
              4  : Result := ReadString (RV_HideIcon);
              { Startup Logo }
              5  : Result := ReadString (RV_StartupLogo);
              { Delete Tmp Files }
              6  : Result := ReadString (RV_DeleteTmp);
              // Home Directory
              7  : Result := ReadString (RV_HomeDir);
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := '';
  End;
End; { GetLocalPropS }

Procedure TBtrieve615Settings.SetLocalPropS(Index : Integer; Value : String);
Begin { SetLocalPropS}
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Btr615BaseKey + RK_Btr615Settings) Then Begin
          { open it }
          If OpenKey(RK_Btr615BaseKey + RK_Btr615Settings, True) Then Begin
            { Key opened ok }
            Case Index Of
              { Create 5x Files }
              1  : WriteString (RV_Create5xFiles, Value);
              { File Sharing On Local Drives }
              2  : WriteString (RV_ShareLocal, Value);
              { File Sharing On Remote Drives }
              3  : WriteString (RV_ShareRemote, Value);
              { Hide Icon }
              4  : WriteString (RV_HideIcon, Value);
              { Startup Logo }
              5  : WriteString (RV_StartupLogo, Value);
              { Delete Tmp Files }
              6  : WriteString (RV_DeleteTmp, Value);
              // Home Directory
              7  : WriteString (RV_HomeDir, Value);
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropS}

{----------------------------------------------------------------------------}

Constructor TBtrieve615Registry.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FIntF     := TBtrieve615Intf.Create(MainO);
  FMainO    := MainO;
  FSettings := TBtrieve615Settings.Create(MainO);
  FMKISet   := TBtrieve615MKIntF.Create(MainO);
End; { Create }

Destructor TBtrieve615Registry.Destroy;
Begin { Destroy }
  FIntF.Free;
  FSettings.Free;
  FMKISet.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TBtrieve615Registry.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  FIntF.ReadFromIni(IniF);
  FSettings.ReadFromIni(IniF);
  FMKISet.ReadFromIni(IniF);
End; { ReadFromIni }

Procedure TBtrieve615Registry.WriteToIni(IniF : TIniFile);
Begin { ReadFromIni }
  FIntF.WriteToIni(IniF);
  FSettings.WriteToIni(IniF);
  FMKISet.WriteToIni(IniF);
End; { WriteToIni }

{----------------------------------------------------------------------------}

Constructor TPerv7MKRouter7.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FMainO := MainO;
  RegO   := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;
End; { Create }

Destructor TPerv7MKRouter7.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TPerv7MKRouter7.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  btTargetEngine := IniF.ReadInteger (Perv7MK7Sett, RV_TargetEng, 2);
  btLocal        := IniF.ReadInteger (Perv7MK7Sett, RV_Local,     1);

  { HM 09/02/00: changed as CS flag not being used }
  If FMainO.ClientServer Then
    btRequester := IniF.ReadInteger (Perv7MK7Sett, RV_Requester, 1)
  Else
    btRequester := IniF.ReadInteger (Perv7MK7Sett, RV_Requester, 0);
End; { ReadFromIni }

Procedure TPerv7MKRouter7.WriteToIni(IniF : TIniFile);
Begin { ReadFromIni }
  If (btTargetEngine <> -1) Then IniF.WriteInteger (Perv7MK7Sett, RV_TargetEng, btTargetEngine);
  If (btLocal <> -1) Then IniF.WriteInteger (Perv7MK7Sett, RV_Local, btLocal);
  If (btRequester <> -1) Then IniF.WriteInteger (Perv7MK7Sett, RV_Requester, btRequester);
End; { WriteToIni }

Function TPerv7MKRouter7.GetLocalPropI(Index : Integer) : LongInt;
Begin { GetLocalPropI }
  Result := -1;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Perv7MK7Sett) Then Begin
          { open it }
          If OpenKey(RK_Perv7MK7Sett, False) Then Begin
            { Key opened ok }
            Case Index Of
              { Local - Can be either integer or string }
              1 : If ValueExists(RV_Local) Then Begin
                    If (GetDataType(RV_Local) = rdString) Then Begin
                      If (UpperCase(ReadString(RV_Local)) = 'NO') Then
                        Result := 0
                      Else
                        Result := 1;
                    End { If }
                    Else
                      Result := ReadInteger (RV_Local);
                  End;

              { Requester - Can be either integer or string }
              2 : If ValueExists(RV_Requester) Then Begin
                    If (GetDataType(RV_Requester) = rdString) Then Begin
                      If (UpperCase(ReadString(RV_Requester)) = 'NO') Then
                        Result := 0
                      Else
                        Result := 1;
                    End { If }
                    Else
                      Result := ReadInteger (RV_Requester);
                  End;

              { Target Engine }
              3 : If ValueExists(RV_Requester) Then
                    Result := ReadInteger (RV_TargetEng);
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := -1;
  End;
End; { GetLocalPropI }

Procedure TPerv7MKRouter7.SetLocalPropI(Index : Integer; Value : LongInt);
Begin { SetLocalPropI }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if value is set }
        If (Value >= 0) Then Begin
          { Check to see if registry key exists }
          If KeyExists(RK_Perv7MK7Sett) Then Begin
            { open it }
            If OpenKey(RK_Perv7MK7Sett, True) Then Begin
              { Key opened ok }
              Case Index Of
                { Local - Can be either integer or string }
                1 : If ValueExists(RV_Local) Then Begin
                      { Write as same type as existing value }
                      If (GetDataType(RV_Local) = rdString) Then Begin
                        If (Value = 0) Then
                          WriteString (RV_Local, 'No')
                        Else
                          WriteString (RV_Local, 'Yes');
                      End { If }
                      Else
                        WriteInteger (RV_Local, Value);
                    End; { If }

                { Requester - Can be either integer or string }
                2 : If ValueExists(RV_Requester) Then Begin
                      { Write as same type as existing value }
                      If (GetDataType(RV_Requester) = rdString) Then Begin
                        If (Value = 0) Then
                          WriteString (RV_Requester, 'No')
                        Else
                          WriteString (RV_Requester, 'Yes');
                      End { If }
                      Else
                        WriteInteger (RV_Requester, Value);
                    End; { If }

                { Target Engine }
                3 : WriteInteger (RV_TargetEng, Value);
              End; { Case Index }
            End; { If OpenKey... }
          End; { If KeyExists... }
        End; { If (Value >= 0) }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropI }

{----------------------------------------------------------------------------}

Constructor TPerv7MKRouter70.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FMainO    := MainO;
  RegO := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;
End; { Create }

Destructor TPerv7MKRouter70.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TPerv7MKRouter70.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  btTargetEngine := IniF.ReadInteger (Perv7MK70Sett, RV_TargetEng, 2);
  btLocal        := IniF.ReadInteger (Perv7MK70Sett, RV_Local,     1);

  { HM 09/02/00: changed as CS flag not being used }
  If FMainO.ClientServer Then
    btRequester := IniF.ReadInteger (Perv7MK70Sett, RV_Requester, 1)
  Else
    btRequester := IniF.ReadInteger (Perv7MK70Sett, RV_Requester, 0);
End; { ReadFromIni }

Procedure TPerv7MKRouter70.WriteToIni(IniF : TIniFile);
Begin { ReadFromIni }
  If (btTargetEngine <> -1) Then IniF.WriteInteger (Perv7MK70Sett, RV_TargetEng, btTargetEngine);
  If (btLocal <> -1) Then IniF.WriteInteger (Perv7MK70Sett, RV_Local, btLocal);
  If (btRequester <> -1) Then IniF.WriteInteger (Perv7MK70Sett, RV_Requester, btRequester);
End; { WriteToIni }

Function TPerv7MKRouter70.GetLocalPropI(Index : Integer) : LongInt;
Begin { GetLocalPropI }
  Result := -1;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Perv7MK70Sett) Then Begin
          { open it }
          If OpenKey(RK_Perv7MK70Sett, False) Then Begin
            { Key opened ok }
            Case Index Of
              { Local - Can be either integer or string }
              1 : If ValueExists(RV_Local) Then Begin
                    If (GetDataType(RV_Local) = rdString) Then Begin
                      If (UpperCase(ReadString(RV_Local)) = 'NO') Then
                        Result := 0
                      Else
                        Result := 1;
                    End { If }
                    Else
                      Result := ReadInteger (RV_Local);
                  End;

              { Requester - Can be either integer or string }
              2 : If ValueExists(RV_Requester) Then Begin
                    If (GetDataType(RV_Requester) = rdString) Then Begin
                      If (UpperCase(ReadString(RV_Requester)) = 'NO') Then
                        Result := 0
                      Else
                        Result := 1;
                    End { If }
                    Else
                      Result := ReadInteger (RV_Requester);
                  End;

              { Target Engine }
              3 : If ValueExists(RV_Requester) Then
                    Result := ReadInteger (RV_TargetEng);
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := -1;
  End;
End; { GetLocalPropI }

Procedure TPerv7MKRouter70.SetLocalPropI(Index : Integer; Value : LongInt);
Begin { SetLocalPropI }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if value is set }
        If (Value >= 0) Then Begin
          { Check to see if registry key exists }
          If KeyExists(RK_Perv7MK70Sett) Then Begin
            { open it }
            If OpenKey(RK_Perv7MK70Sett, True) Then Begin
              { Key opened ok }
              Case Index Of
                { Local - Can be either integer or string }
                1 : If ValueExists(RV_Local) Then Begin
                      { Write as same type as existing value }
                      If (GetDataType(RV_Local) = rdString) Then Begin
                        If (Value = 0) Then
                          WriteString (RV_Local, 'No')
                        Else
                          WriteString (RV_Local, 'Yes');
                      End { If }
                      Else
                        WriteInteger (RV_Local, Value);
                    End; { If }

                { Requester - Can be either integer or string }
                2 : If ValueExists(RV_Requester) Then Begin
                      { Write as same type as existing value }
                      If (GetDataType(RV_Requester) = rdString) Then Begin
                        If (Value = 0) Then
                          WriteString (RV_Requester, 'No')
                        Else
                          WriteString (RV_Requester, 'Yes');
                      End { If }
                      Else
                        WriteInteger (RV_Requester, Value);
                    End; { If }

                { Target Engine }
                3 : WriteInteger (RV_TargetEng, Value);
              End; { Case Index }
            End; { If OpenKey... }
          End; { If KeyExists... }
        End; { If (Value >= 0) }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropI }

{----------------------------------------------------------------------------}

Constructor TPerv7MKRouter701.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FMainO    := MainO;
  RegO := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;
End; { Create }

Destructor TPerv7MKRouter701.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TPerv7MKRouter701.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  btLoadRetries := IniF.ReadInteger (Perv7MK701Sett, RV_LoadRetries, 5);
  btLocal       := IniF.ReadInteger (Perv7MK701Sett, RV_Local,       1);
  btTargetEng   := IniF.ReadInteger (Perv7MK701Sett, RV_TargetEng,   2);

  { HM 09/02/00: changed as CS flag not being used }
  If FMainO.ClientServer Then
    btRequester := IniF.ReadInteger (Perv7MK701Sett, RV_Requester, 1)
  Else
    btRequester := IniF.ReadInteger (Perv7MK701Sett, RV_Requester, 0);
End; { ReadFromIni }

Procedure TPerv7MKRouter701.WriteToIni(IniF : TIniFile);
Begin { ReadFromIni }
  If (btLoadRetries <> -1) Then IniF.WriteInteger (Perv7MK701Sett, RV_LoadRetries, btLoadRetries);
  If (btLocal <> -1) Then IniF.WriteInteger (Perv7MK701Sett, RV_Local, btLocal);
  If (btRequester <> -1) Then IniF.WriteInteger (Perv7MK701Sett, RV_Requester, btRequester);
  If (btTargetEng <> -1) Then IniF.WriteInteger (Perv7MK701Sett, RV_TargetEng, btTargetEng);
End; { WriteToIni }

Function TPerv7MKRouter701.GetLocalPropI(Index : Integer) : LongInt;
Begin { GetLocalPropI }
  Result := -1;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Perv7MK701Sett) Then Begin
          { open it }
          If OpenKey(RK_Perv7MK701Sett, False) Then Begin
            { Key opened ok }
            Case Index Of
              { Load Retries }
              1 : If ValueExists (RV_Local) Then Begin
                    Result := ReadInteger (RV_LoadRetries);
                  End; { If }
              { Local }
              2 : If ValueExists (RV_Local) Then Begin
                    If (UpperCase(ReadString(RV_Local)) = 'NO') Then
                      Result := 0
                    Else
                      Result := 1;
                  End;
              { Requester }
              3 : If ValueExists (RV_Requester) Then Begin
                    If (UpperCase(ReadString(RV_Requester)) = 'NO') Then
                      Result := 0
                    Else
                      Result := 1;
                  End;
              { Target Engine }
              4 : Result := ReadInteger (RV_TargetEng);
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := -1;
  End;
End; { GetLocalPropI }

Procedure TPerv7MKRouter701.SetLocalPropI(Index : Integer; Value : LongInt);
Begin { SetLocalPropI }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if value is set }
        If (Value >= 0) Then Begin
          { Check to see if registry key exists }
          If KeyExists(RK_Perv7MK701Sett) Then Begin
            { open it }
            If OpenKey(RK_Perv7MK701Sett, True) Then Begin
              { Key opened ok }
              Case Index Of
                { Load Retries }
                1 : WriteInteger (RV_LoadRetries, Value);
                { Local }
                2 : If (Value = 0) Then
                      WriteString (RV_Local, 'no')
                    Else
                      WriteString (RV_Local, 'yes');
                { Requester }
                3 : If (Value = 0) Then
                      WriteString (RV_Requester, 'no')
                    Else
                      WriteString (RV_Requester, 'yes');
                { Target Engine }
                4 : WriteInteger (RV_TargetEng, Value);
              End; { Case Index }
            End; { If OpenKey... }
          End; { If KeyExists... }
        End; { If (Value >= 0) }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropI }

{----------------------------------------------------------------------------}

Constructor TPervMKRouter8.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FMainO    := MainO;
  RegO := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;
End; { Create }

Destructor TPervMKRouter8.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TPervMKRouter8.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  btLocal          := IniF.ReadInteger (RK_PervMK8Sett, RV_Local,     1);
  btRequester      := IniF.ReadInteger (RK_PervMK8Sett, RV_Requester, 1);
  btTargetEng      := IniF.ReadInteger (RK_PervMK8Sett, RV_TargetEng, 2);
  If FMainO.ClientServer Then
    btUseCacheEngine := IniF.ReadInteger (RK_PervMK8Sett, RV_UseCacheEngine, 0)
  Else
    btUseCacheEngine := IniF.ReadInteger (RK_PervMK8Sett, RV_UseCacheEngine, 1);
End; { ReadFromIni }

Procedure TPervMKRouter8.WriteToIni(IniF : TIniFile);
Begin { ReadFromIni }
  If (btLocal <> -1) Then IniF.WriteInteger (RK_PervMK8Sett, RV_Local, btLocal);
  If (btRequester <> -1) Then IniF.WriteInteger (RK_PervMK8Sett, RV_Requester, btRequester);
  If (btTargetEng <> -1) Then IniF.WriteInteger (RK_PervMK8Sett, RV_TargetEng, btTargetEng);
  If (btUseCacheEngine <> -1) Then IniF.WriteInteger (RK_PervMK8Sett, RV_UseCacheEngine, btUseCacheEngine);
End; { WriteToIni }

Function TPervMKRouter8.GetLocalPropI(Index : Integer) : LongInt;
Begin { GetLocalPropI }
  Result := -1;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_PervMK8Sett) Then Begin
          { open it }
          If OpenKey(RK_PervMK8Sett, False) Then Begin
            { Key opened ok }
            Case Index Of
              { Local }
              1 : If ValueExists (RV_Local) Then Begin
                    If (UpperCase(ReadString(RV_Local)) = 'NO') Then
                      Result := 0
                    Else
                      Result := 1;
                  End;
              { Requester }
              2 : If ValueExists (RV_Requester) Then Begin
                    If (UpperCase(ReadString(RV_Requester)) = 'NO') Then
                      Result := 0
                    Else
                      Result := 1;
                  End;
              { Target Engine }
              3 : Result := ReadInteger (RV_TargetEng);
              { Use Cache Engine }
              4 : If ValueExists (RV_UseCacheEngine) Then Begin
                    If (UpperCase(ReadString(RV_UseCacheEngine)) = 'NO') Then
                      Result := 0
                    Else
                      Result := 1;
                  End;
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := -1;
  End;
End; { GetLocalPropI }

Procedure TPervMKRouter8.SetLocalPropI(Index : Integer; Value : LongInt);
Begin { SetLocalPropI }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if value is set }
        If (Value >= 0) Then Begin
          { open it }
          If OpenKey(RK_PervMK8Sett, True) Then Begin
            { Key opened ok }
            Case Index Of
              { Local }
              1 : If (Value = 0) Then
                    WriteString (RV_Local, 'no')
                  Else
                    WriteString (RV_Local, 'yes');
              { Requester }
              2 : If (Value = 0) Then
                    WriteString (RV_Requester, 'no')
                  Else
                    WriteString (RV_Requester, 'yes');
              { Target Engine }
              3 : WriteInteger (RV_TargetEng, Value);
              { Use Cache Engine }
              4 : If (Value = 0) Then
                    WriteString (RV_UseCacheEngine, 'no')
                  Else
                    WriteString (RV_UseCacheEngine, 'yes');
            End; { Case Index }
          End; { If OpenKey... }
        End; { If (Value >= 0) }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropI }

{----------------------------------------------------------------------------}

Constructor TPervWorkgroup8.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FMainO    := MainO;
  RegO := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;
End; { Create }

Destructor TPervWorkgroup8.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TPervWorkgroup8.ReadFromIni(IniF : TIniFile);
Var
  V_ExchLocal : ShortString;
Begin { ReadFromIni }
  V_ExchLocal := WinGetWindowsDir[1] + ':\Excheqr\MKDE\';

  btFileVersion := IniF.ReadString (RK_PervWGE8Sett, 'File Version', '0600');
  btTraceFile   := IniF.ReadString (RK_PervWGE8Sett, 'Trace File', V_ExchLocal + 'MKDE.TRA');
  btTransLogDir := IniF.ReadString (RK_PervWGE8Sett, 'Transaction Log Directory', V_ExchLocal + 'Log');
End; { ReadFromIni }

Procedure TPervWorkgroup8.WriteToIni(IniF : TIniFile);
Begin { ReadFromIni }
  If (btFileVersion <> #255) Then IniF.WriteString (RK_PervWGE8Sett, 'File Version', btFileVersion);
  If (btTraceFile <> #255) Then IniF.WriteString (RK_PervWGE8Sett, 'Trace File', btTraceFile);
  If (btTransLogDir <> #255) Then IniF.WriteString (RK_PervWGE8Sett, 'Transaction Log Directory', btTransLogDir);
End; { WriteToIni }

Function TPervWorkgroup8.GetLocalPropS(Index : Integer) : String;
Begin { GetLocalPropS }
  Result := #255;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_PervWGE8Sett) Then Begin
          { open it }
          If OpenKey(RK_PervWGE8Sett, False) Then Begin
            { Key opened ok }
            Case Index Of
              { File Version }
              1 : If ValueExists ('File Version') Then Begin
                    Result := ReadString('File Version');
                  End;

              { Trace File }
              2 : If ValueExists ('Trace File') Then Begin
                    Result := ReadString('Trace File');
                  End;

              { Transaction Log Directory }
              3 : If ValueExists ('Transaction Log Directory') Then Begin
                    Result := ReadString('Transaction Log Directory');
                  End;
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := #255;
  End;
End; { GetLocalPropS }

Procedure TPervWorkgroup8.SetLocalPropS(Index : Integer; Value : String);
Begin { SetLocalPropS }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if value is set }
        If (Value <> #255) Then Begin
          { open it }
          If OpenKey(RK_PervWGE8Sett, True) Then Begin
            { Key opened ok }
            Case Index Of
              { File Version }
              1 : WriteString('File Version', Value);
              { Trace File }
              2 : WriteString('Trace File', Value);
              { Transaction Log Directory }
              3 : WriteString('Transaction Log Directory', Value);
            End; { Case Index }
          End; { If OpenKey... }
        End; { If (Value >= 0) }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropS }

{----------------------------------------------------------------------------}

Constructor TPerv7BtrReq7.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FMainO    := MainO;
  RegO := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;
End; { Create }

Destructor TPerv7BtrReq7.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TPerv7BtrReq7.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  btSplashScreen := IniF.ReadInteger (Perv7Btr7Sett, RV_Splash, 0);
End; { ReadFromIni }

Procedure TPerv7BtrReq7.WriteToIni(IniF : TIniFile);
Begin { ReadFromIni }
  If (btSplashScreen <> -1) Then IniF.WriteInteger (Perv7Btr7Sett, RV_Splash, btSplashScreen);
End; { WriteToIni }

Function TPerv7BtrReq7.GetLocalPropI(Index : Integer) : LongInt;
Begin { GetLocalPropI }
  Result := -1;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Perv7Btr7Sett) Then Begin
          { open it }
          If OpenKey(RK_Perv7Btr7Sett, False) Then Begin
            { Key opened ok }
            Case Index Of
              { Splash Screen }
              1 : If ValueExists (RV_Splash) Then Begin
                    If (UpperCase(ReadString(RV_Splash)) = 'NO') Then
                      Result := 0
                    Else
                      Result := 1;
                  End;
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := -1;
  End;
End; { GetLocalPropI }

Procedure TPerv7BtrReq7.SetLocalPropI(Index : Integer; Value : LongInt);
Begin { SetLocalPropI }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if value is set }
        If (Value >= 0) Then Begin
          { Check to see if registry key exists }
          If KeyExists(RK_Perv7Btr7Sett) Then Begin
            { open it }
            If OpenKey(RK_Perv7Btr7Sett, True) Then Begin
              { Key opened ok }
              Case Index Of
                { Splash Screen }
                1 : If (Value = 0) Then
                      WriteString (RV_Splash, 'no')
                    Else
                      WriteString (RV_Splash, 'yes');
              End; { Case Index }
            End; { If OpenKey... }
          End; { If KeyExists... }
        End; { If (Value >= 0) }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropI }

{----------------------------------------------------------------------------}

Constructor TPerv7BtrReq70.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FMainO    := MainO;
  RegO := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;
End; { Create }

Destructor TPerv7BtrReq70.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TPerv7BtrReq70.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  btSplashScreen := IniF.ReadInteger (Perv7Btr70Sett, RV_Splash, 0);
End; { ReadFromIni }

Procedure TPerv7BtrReq70.WriteToIni(IniF : TIniFile);
Begin { ReadFromIni }
  If (btSplashScreen <> -1) Then IniF.WriteInteger (Perv7Btr70Sett, RV_Splash, btSplashScreen);
End; { WriteToIni }

Function TPerv7BtrReq70.GetLocalPropI(Index : Integer) : LongInt;
Begin { GetLocalPropI }
  Result := -1;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Perv7Btr70Sett) Then Begin
          { open it }
          If OpenKey(RK_Perv7Btr70Sett, False) Then Begin
            { Key opened ok }
            Case Index Of
              { Splash Screen }
              1 : If ValueExists (RV_Splash) Then Begin
                    If (UpperCase(ReadString(RV_Splash)) = 'NO') Then
                      Result := 0
                    Else
                      Result := 1;
                  End;
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := -1;
  End;
End; { GetLocalPropI }

Procedure TPerv7BtrReq70.SetLocalPropI(Index : Integer; Value : LongInt);
Begin { SetLocalPropI }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if value is set }
        If (Value >= 0) Then Begin
          { Check to see if registry key exists }
          If KeyExists(RK_Perv7Btr70Sett) Then Begin
            { open it }
            If OpenKey(RK_Perv7Btr70Sett, True) Then Begin
              { Key opened ok }
              Case Index Of
                { Splash Screen }
                1 : If (Value = 0) Then
                      WriteString (RV_Splash, 'no')
                    Else
                      WriteString (RV_Splash, 'yes');
              End; { Case Index }
            End; { If OpenKey... }
          End; { If KeyExists... }
        End; { If (Value >= 0) }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropI }

//-------------------------------------------------------------------------

Constructor TPSQLBtrReqSettings.Create(MainO : TSetupEntRegistry; Const RegKey : ShortString);
Begin { Create }
  Inherited Create;

  FMainO    := MainO;
  RegO := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;

  FRegKey := RegKey;
End; { Create }

Destructor TPSQLBtrReqSettings.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TPSQLBtrReqSettings.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  btSplashScreen := IniF.ReadInteger (FRegKey, RV_Splash, 0);
End; { ReadFromIni }

Procedure TPSQLBtrReqSettings.WriteToIni(IniF : TIniFile);
Begin { ReadFromIni }
  If (btSplashScreen <> -1) Then IniF.WriteInteger (FRegKey, RV_Splash, btSplashScreen);
End; { WriteToIni }

Function TPSQLBtrReqSettings.GetLocalPropI(Index : Integer) : LongInt;
Begin { GetLocalPropI }
  Result := -1;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(FRegKey) Then Begin
          { open it }
          If OpenKey(FRegKey, False) Then Begin
            { Key opened ok }
            Case Index Of
              { Splash Screen }
              1 : If ValueExists (RV_Splash) Then Begin
                    If (UpperCase(ReadString(RV_Splash)) = 'NO') Then
                      Result := 0
                    Else
                      Result := 1;
                  End;
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := -1;
  End;
End; { GetLocalPropI }

Procedure TPSQLBtrReqSettings.SetLocalPropI(Index : Integer; Value : LongInt);
Begin { SetLocalPropI }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if value is set }
        If (Value >= 0) Then Begin
          { Check to see if registry key exists }
          If KeyExists(FRegKey) Then Begin
            { open it }
            If OpenKey(FRegKey, True) Then Begin
              { Key opened ok }
              Case Index Of
                { Splash Screen }
                1 : If (Value = 0) Then
                      WriteString (RV_Splash, 'no')
                    Else
                      WriteString (RV_Splash, 'yes');
              End; { Case Index }
            End; { If OpenKey... }
          End; { If KeyExists... }
        End; { If (Value >= 0) }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropI }

{----------------------------------------------------------------------------}

Constructor TPerv7CommReq7.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FMainO    := MainO;
  RegO := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;
End; { Create }

Destructor TPerv7CommReq7.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TPerv7CommReq7.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  btTCPTimeout         := IniF.ReadInteger (Perv7CommR7Sett, RV_TCPIPTimout,  $F);
  btSupportedProtocols := IniF.ReadString  (Perv7CommR7Sett, RV_SupProtocols, 'SPX,TCPIP');
  btRuntimeServer      := IniF.ReadString  (Perv7CommR7Sett, RV_RuntimeSvr,   'Yes');
  btNumSatEntries      := IniF.ReadInteger (Perv7CommR7Sett, RV_NumStatEnt,   0);
End; { ReadFromIni }

Procedure TPerv7CommReq7.WriteToIni(IniF : TIniFile);
Begin { ReadFromIni }
  If (btTCPTimeout <> -1) Then IniF.WriteInteger (Perv7CommR7Sett, RV_TCPIPTimout, btTCPTimeout);
  If (btSupportedProtocols <> #255) Then IniF.WriteString  (Perv7CommR7Sett, RV_SupProtocols, btSupportedProtocols);
  If (btRuntimeServer <> #255) Then IniF.WriteString  (Perv7CommR7Sett, RV_RuntimeSvr, btRuntimeServer);
  If (btNumSatEntries <> -1) Then IniF.WriteInteger (Perv7CommR7Sett, RV_NumStatEnt, btNumSatEntries);
End; { WriteToIni }

Function TPerv7CommReq7.GetLocalPropI(Index : Integer) : LongInt;
Begin { GetLocalPropI }
  Result := -1;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Perv7CommR7Sett) Then Begin
          { open it }
          If OpenKey(RK_Perv7CommR7Sett, False) Then Begin
            { Key opened ok }
            Case Index Of
              { TCP connect timeout }
              1 : If ValueExists (RV_TCPIPTimout) Then Begin
                    Result := ReadInteger(RV_TCPIPTimout);
                  End;

              { NumSatEntries }
              2 : If ValueExists (RV_NumStatEnt) Then Begin
                    Result := ReadInteger(RV_NumStatEnt);
                  End;
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := -1;
  End;
End; { GetLocalPropI }

Procedure TPerv7CommReq7.SetLocalPropI(Index : Integer; Value : LongInt);
Begin { SetLocalPropI }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if value is set }
        If (Value >= 0) Then Begin
          { Check to see if registry key exists }
          If KeyExists(RK_Perv7CommR7Sett) Then Begin
            { open it }
            If OpenKey(RK_Perv7CommR7Sett, True) Then Begin
              { Key opened ok }
              Case Index Of
                { TCP connect timeout }
                1 : WriteInteger(RV_TCPIPTimout, Value);

                { NumSatEntries }
                2 : WriteInteger(RV_NumStatEnt, Value);
              End; { Case Index }
            End; { If OpenKey... }
          End; { If KeyExists... }
        End; { If (Value >= 0) }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropI }

Function TPerv7CommReq7.GetLocalPropS(Index : Integer) : String;
Begin { GetLocalPropS }
  Result := #255;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Perv7CommR7Sett) Then Begin
          { open it }
          If OpenKey(RK_Perv7CommR7Sett, False) Then Begin
            { Key opened ok }
            Case Index Of
              { Supported protocols }
              1 : If ValueExists (RV_SupProtocols) Then Begin
                    Result := ReadString(RV_SupProtocols);
                  End;

              { Runtime server }
              2 : If ValueExists (RV_RuntimeSvr) Then Begin
                    Result := ReadString(RV_RuntimeSvr);
                  End;
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := #255;
  End;
End; { GetLocalPropS }

Procedure TPerv7CommReq7.SetLocalPropS(Index : Integer; Value : String);
Begin { SetLocalPropS }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if value is set }
        If (Value <> #255) Then Begin
          { Check to see if registry key exists }
          If KeyExists(RK_Perv7CommR7Sett) Then Begin
            { open it }
            If OpenKey(RK_Perv7CommR7Sett, True) Then Begin
              { Key opened ok }
              Case Index Of
                { Supported protocols }
                1 : WriteString(RV_SupProtocols, Value);
                { Runtime server }
                2 : WriteString(RV_RuntimeSvr, Value);
              End; { Case Index }
            End; { If OpenKey... }
          End; { If KeyExists... }
        End; { If (Value >= 0) }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropS }

{----------------------------------------------------------------------------}

Constructor TPerv7SSQL4.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FMainO    := MainO;
  RegO := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;
End; { Create }

Destructor TPerv7SSQL4.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TPerv7SSQL4.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  { HM 09/02/00: changed as CS flag not being used }
  If FMainO.ClientServerODBC Then
    btRequester := IniF.ReadInteger (Perv7SSql4Sett, RV_Requester, 1)
  Else
    btRequester := IniF.ReadInteger (Perv7SSql4Sett, RV_Requester, 0);

  btLocal     := IniF.ReadInteger (Perv7SSql4Sett, RV_Local, 1);
  btTargetEng := IniF.ReadInteger (Perv7SSql4Sett, RV_TargetEng, 0);
  btLogins    := IniF.ReadInteger (Perv7SSql4Sett, RV_Logins, $A);
End; { ReadFromIni }

Procedure TPerv7SSQL4.WriteToIni(IniF : TIniFile);
Begin { ReadFromIni }
  If (btRequester <> -1) Then IniF.WriteInteger (Perv7SSql4Sett, RV_Requester, btRequester);
  If (btLocal <> -1) Then     IniF.WriteInteger (Perv7SSql4Sett, RV_Local, btLocal);
  If (btTargetEng <> -1) Then IniF.WriteInteger (Perv7SSql4Sett, RV_TargetEng, btTargetEng);
  If (btLogins <> -1) Then    IniF.WriteInteger (Perv7SSql4Sett, RV_Logins, btLogins);
End; { WriteToIni }

Function TPerv7SSQL4.GetLocalPropI(Index : Integer) : LongInt;
Begin { GetLocalPropI }
  Result := -1;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Perv7SSQL4Sett) Then Begin
          { open it }
          If OpenKey(RK_Perv7SSQL4Sett, False) Then Begin
            { Key opened ok }
            Case Index Of
              { requester }
              1 : If ValueExists (RV_Requester) Then Begin
                    If (UpperCase(ReadString(RV_Requester)) = 'NO') Then
                      Result := 0
                    Else
                      Result := 1;
                  End;
              { local }
              2 : If ValueExists (RV_Local) Then Begin
                    If (UpperCase(ReadString(RV_Local)) = 'NO') Then
                      Result := 0
                    Else
                      Result := 1;
                  End;
              { target engine }
              3 : If ValueExists (RV_TargetEng) Then Begin
                    Result := ReadInteger(RV_TargetEng);
                  End;
              { logins }
              4 : If ValueExists (RV_Logins) Then Begin
                    Result := ReadInteger(RV_Logins);
                  End;
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := -1;
  End;
End; { GetLocalPropI }

Procedure TPerv7SSQL4.SetLocalPropI(Index : Integer; Value : LongInt);
Begin { SetLocalPropI }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if value is set }
        If (Value >= 0) Then Begin
          { Check to see if registry key exists }
          If KeyExists(RK_Perv7SSQL4Sett) Then Begin
            { open it }
            If OpenKey(RK_Perv7SSQL4Sett, True) Then Begin
              { Key opened ok }
              Case Index Of
                { requester }
                1 : If (Value = 0) Then
                      WriteString (RV_Requester, 'no')
                    Else
                      WriteString (RV_Requester, 'yes');
                { local }
                2 : If (Value = 0) Then
                      WriteString (RV_Local, 'no')
                    Else
                      WriteString (RV_Local, 'yes');
                { target engine }
                3 : WriteInteger(RV_TargetEng, Value);
                { logins }
                4 : WriteInteger(RV_Logins, Value);
              End; { Case Index }
            End; { If OpenKey... }
          End; { If KeyExists... }
        End; { If (Value >= 0) }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropI }

{----------------------------------------------------------------------------}

Constructor TPerv7SSQL401.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FMainO    := MainO;
  RegO := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;
End; { Create }

Destructor TPerv7SSQL401.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TPerv7SSQL401.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  If FMainO.ClientServerODBC Then
    btRequester := IniF.ReadInteger (Perv7SSql4Sett, RV_Requester, 1)
  Else
    btRequester := IniF.ReadInteger (Perv7SSql4Sett, RV_Requester, 0);

  btLocal     := IniF.ReadInteger (Perv7SSql4Sett, RV_Local, 1);
  btTargetEng := IniF.ReadInteger (Perv7SSql4Sett, RV_TargetEng, 0);
  btLogins    := IniF.ReadInteger (Perv7SSql4Sett, RV_Logins, $A);
End; { ReadFromIni }

Procedure TPerv7SSQL401.WriteToIni(IniF : TIniFile);
Begin { ReadFromIni }
  If (btRequester <> -1) Then IniF.WriteInteger (Perv7SSql4Sett, RV_Requester, btRequester);
  If (btLocal <> -1) Then     IniF.WriteInteger (Perv7SSql4Sett, RV_Local, btLocal);
  If (btTargetEng <> -1) Then IniF.WriteInteger (Perv7SSql4Sett, RV_TargetEng, btTargetEng);
  If (btLogins <> -1) Then    IniF.WriteInteger (Perv7SSql4Sett, RV_Logins, btLogins);
End; { WriteToIni }

Function TPerv7SSQL401.GetLocalPropI(Index : Integer) : LongInt;
Begin { GetLocalPropI }
  Result := -1;

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(RK_Perv7SSQL401Sett) Then Begin
          { open it }
          If OpenKey(RK_Perv7SSQL401Sett, False) Then Begin
            { Key opened ok }
            Case Index Of
              { requester }
              1 : If ValueExists (RV_Requester) Then Begin
                    If (UpperCase(ReadString(RV_Requester)) = 'NO') Then
                      Result := 0
                    Else
                      Result := 1;
                  End;
              { local }
              2 : If ValueExists (RV_Local) Then Begin
                    If (UpperCase(ReadString(RV_Local)) = 'NO') Then
                      Result := 0
                    Else
                      Result := 1;
                  End;
              { target engine }
              3 : If ValueExists (RV_TargetEng) Then Begin
                    Result := ReadInteger(RV_TargetEng);
                  End;
              { logins }
              4 : If ValueExists (RV_Logins) Then Begin
                    Result := ReadInteger(RV_Logins);
                  End;
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := -1;
  End;
End; { GetLocalPropI }

Procedure TPerv7SSQL401.SetLocalPropI(Index : Integer; Value : LongInt);
Begin { SetLocalPropI }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if value is set }
        If (Value >= 0) Then Begin
          { Check to see if registry key exists }
          If KeyExists(RK_Perv7SSQL401Sett) Then Begin
            { open it }
            If OpenKey(RK_Perv7SSQL401Sett, True) Then Begin
              { Key opened ok }
              Case Index Of
                { requester }
                1 : If (Value = 0) Then
                      WriteString (RV_Requester, 'no')
                    Else
                      WriteString (RV_Requester, 'yes');
                { local }
                2 : If (Value = 0) Then
                      WriteString (RV_Local, 'no')
                    Else
                      WriteString (RV_Local, 'yes');
                { target engine }
                3 : WriteInteger(RV_TargetEng, Value);
                { logins }
                4 : WriteInteger(RV_Logins, Value);
              End; { Case Index }
            End; { If OpenKey... }
          End; { If KeyExists... }
        End; { If (Value >= 0) }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalPropI }

//-------------------------------------------------------------------------

Constructor TPSQLProductEntry.Create(MainO : TSetupEntRegistry; Const RegKey, VerLevel, BuildLevel, PatchLevel : ShortString);
Begin { Create }
  Inherited Create;

  FMainO := MainO;
  RegO := TRegistry.Create;
  RegO.Access := KEY_READ or KEY_WRITE;

  FRegKey     := RegKey;
  FVerLevel   := VerLevel;
  FBuildLevel := BuildLevel;
  FPatchLevel := PatchLevel;
End; { Create }

Destructor TPSQLProductEntry.Destroy;
Begin { Destroy }
  RegO.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TPSQLProductEntry.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  pcBuildLevel     := IniF.ReadString (RK_PervClientProd, RV_BuildLevel, FBuildLevel);
  pcInstallDir     := IniF.ReadString (RK_PervClientProd, RV_InstallDir, FMainO.EntDir);
  pcInstallIniName := IniF.ReadString (RK_PervClientProd, RV_InstallIniName, 'PTKSETUP.INI');
  pcPatchLevel     := IniF.ReadString (RK_PervClientProd, RV_PatchLevel, FPatchLevel);
  pcSystemDir      := IniF.ReadString (RK_PervClientProd, RV_SystemDir, WinGetWindowsSystemDir);
  pcVersionLevel   := IniF.ReadString (RK_PervClientProd, RV_VersionLevel, FVerLevel);
End; { ReadFromIni }

Procedure TPSQLProductEntry.WriteToIni(IniF : TIniFile);
Begin { ReadFromIni }
  IniF.WriteString (RK_PervClientProd, RV_BuildLevel,     pcBuildLevel);
  IniF.WriteString (RK_PervClientProd, RV_InstallDir,     pcInstallDir);
  IniF.WriteString (RK_PervClientProd, RV_InstallIniName, pcInstallIniName);
  IniF.WriteString (RK_PervClientProd, RV_PatchLevel,     pcPatchLevel);
  IniF.WriteString (RK_PervClientProd, RV_SystemDir,      pcSystemDir);
  IniF.WriteString (RK_PervClientProd, RV_VersionLevel,   pcVersionLevel);
End; { WriteToIni }

Function TPSQLProductEntry.GetLocalProp(Index : Integer) : ShortString;
Begin { GetLocalProp }
  Result := '';

  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { Check to see if registry key exists }
        If KeyExists(FRegKey) Then Begin
          { open it }
          If OpenKey(FRegKey, False) Then Begin
            { Key opened ok }
            Case Index Of
              // Build Level
              1 : If ValueExists (RV_BuildLevel) Then
                    Result := ReadString (RV_BuildLevel);
              // Install Dir
              2 : If ValueExists (RV_InstallDir) Then
                    Result := ReadString (RV_InstallDir);
              // Install Ini Name
              3 : If ValueExists (RV_InstallIniName) Then
                    Result := ReadString (RV_InstallIniName);
              // Patch Level
              4 : If ValueExists (RV_PatchLevel) Then
                    Result := ReadString (RV_PatchLevel);
              // System Dir
              5 : If ValueExists (RV_SystemDir) Then
                    Result := ReadString (RV_SystemDir);
              // Version Level
              6 : If ValueExists (RV_VersionLevel) Then
                    Result := ReadString (RV_VersionLevel);
            End; { Case Index }
          End; { If OpenKey... }
        End; { If KeyExists... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      Result := '';
  End;
End; { GetLocalProp }

Procedure TPSQLProductEntry.SetLocalProp(Index : Integer; Value : ShortString);
Begin { SetLocalProp }
  Try
    With RegO Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;

        { open key (creating if required) }
        If OpenKey(FRegKey, True) Then Begin
          { Key opened ok }
          Case Index Of
            // Build Level
            1 : WriteString (RV_BuildLevel, Value);
            // Install Dir
            2 : WriteString (RV_InstallDir, Value);
            // Install Ini Name
            3 : WriteString (RV_InstallIniName, Value);
            // Patch Level
            4 : WriteString (RV_PatchLevel, Value);
            // System Dir
            5 : WriteString (RV_SystemDir, Value);
            // Version Level
            6 : WriteString (RV_VersionLevel, Value);
          End; { Case Index }
        End; { If OpenKey... }
      Finally
        CloseKey;
      End;
    End; { With RegO }
  Except
    On Ex:Exception Do
      ;
  End;
End; { SetLocalProp }

//-------------------------------------------------------------------------

Constructor TPerv7Registry.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FBtr7          := TPerv7BtrReq7.Create(MainO);
  FBtr70         := TPerv7BtrReq70.Create(MainO);
  FCommReq7      := TPerv7CommReq7.Create(MainO);
  FMainO         := MainO;
  FMKRouter7     := TPerv7MKRouter7.Create(Maino);
  FMKRouter70    := TPerv7MKRouter70.Create(Maino);
  FMKRouter701   := TPerv7MKRouter701.Create(Maino);
  FSSQL4         := TPerv7SSQL4.Create(MainO);
  FSSQL401       := TPerv7SSQL401.Create(MainO);

  FSQLClientProd := TPSQLProductEntry.Create(MainO, RK_PervClientProd, '8.10', '117', '1');
  FSQLWGEProd    := TPSQLProductEntry.Create(MainO, RK_PervWorkgrpProd, '8.10', '117', '1');
  FMKRouter8     := TPervMKRouter8.Create(MainO);
  FWorkgroup8    := TPervWorkgroup8.Create (MainO);
  FBtr8          := TPSQLBtrReqSettings.Create(MainO, 'SOFTWARE\Pervasive Software\Btrieve Requester\Version 8\Settings');
End; { Create }

Destructor TPerv7Registry.Destroy;
Begin { Destroy }
  FBtr7.Free;
  FBtr70.Free;
  FCommReq7.Free;
  FMKRouter7.Free;
  FMKRouter70.Free;
  FMKRouter701.Free;
  FSSQL4.Free;
  FSSQL401.Free;
  FreeAndNIL(FSQLClientProd);
  FreeAndNIL(FSQLWGEProd);
  FreeAndNIL(FMKRouter8);
  FreeAndNIL(FWorkgroup8);
  FreeAndNIL(FBtr8);

  Inherited Destroy;
End; { Destroy }

Procedure TPerv7Registry.ReadFromIni(IniF : TIniFile);
Begin { ReadFromIni }
  FBtr7.ReadFromIni(IniF);
  FBtr70.ReadFromIni(IniF);
  FBtr8.ReadFromIni(IniF);
  FCommReq7.ReadFromIni(IniF);
  FMKRouter7.ReadFromIni(IniF);
  FMKRouter70.ReadFromIni(IniF);
  FMKRouter701.ReadFromIni(IniF);
  FMKRouter8.ReadFromIni(IniF);
  FSSQL4.ReadFromIni(IniF);
  FSSQL401.ReadFromIni(IniF);

  If FMainO.ClientServer And (FMainO.PervasiveVersion = 3) Then
    // P.SQL v8 Client-Server
    FSQLClientProd.ReadFromIni(IniF)
  Else
    If (Not FMainO.ClientServer) And (FMainO.PSQLWorkgroupVer = 1) Then
    Begin
      // P.SQL v8 Workgroup
      FWorkgroup8.ReadFromIni(IniF);  // Workgroup Settings
      FSQLWGEProd.ReadFromIni(IniF);  // Product Entry
    End; // If (Not FMainO.ClientServer) And (FMainO.PSQLWorkgroupVer = 1)
End; { ReadFromIni }

Procedure TPerv7Registry.WriteToIni(IniF : TIniFile);
Begin { WriteToIni }
  FBtr7.WriteToIni(IniF);
  FBtr70.WriteToIni(IniF);
  FBtr8.WriteToIni(IniF);
  FCommReq7.WriteToIni(IniF);
  FMKRouter7.WriteToIni(IniF);
  FMKRouter70.WriteToIni(IniF);
  FMKRouter701.WriteToIni(IniF);
  FMKRouter8.WriteToIni(IniF);
  FSSQL4.WriteToIni(IniF);
  FSSQL401.WriteToIni(IniF);

  If FMainO.ClientServer And (FMainO.PervasiveVersion = 3) Then
    // P.SQL v8 Client-Server
    FSQLClientProd.WriteToIni(IniF)
  Else
    If (Not FMainO.ClientServer) And (FMainO.PSQLWorkgroupVer = 1) Then
    Begin
      // P.SQL v8 Workgroup
      FWorkgroup8.WriteToIni(IniF);  // Workgroup Settings
      FSQLWGEProd.WriteToIni(IniF);  // Product Entry
    End; // If (Not FMainO.ClientServer) And (FMainO.PSQLWorkgroupVer = 1)
End; { WriteToIni }

{----------------------------------------------------------------------------}

Constructor TBtrieveRegistry.Create(MainO : TSetupEntRegistry);
Begin { Create }
  Inherited Create;

  FBtrieve615 := TBtrieve615Registry.Create(MainO);
  FMainO      := MainO;
  FPervasive7 := TPerv7Registry.Create(MainO);
  FIncludeSQLReg    := True;
End; { Create }

Destructor TBtrieveRegistry.Destroy;
Begin { Destroy }
  FBtrieve615.Free;
  FPervasive7.Free;

  Inherited Destroy;
End; { Destroy }

Procedure TBtrieveRegistry.ReadFromIni(IniPath : String);
Var
  IniF : TIniFile;
Begin { ReadFromIni }
  { Check it exists }
  IniF := TIniFile.Create(IniPath);
  Try
    FBtrieve615.ReadFromIni(IniF);
    If FIncludeSQLReg Then FPervasive7.ReadFromIni(IniF);
  Finally
    IniF.Free;
  End;
End; { ReadFromIni }

Procedure TBtrieveRegistry.WriteToIni(IniPath : String);
Var
  IniF : TIniFile;
Begin { WriteToIni }
  IniF := TIniFile.Create(IniPath);
  Try
    FBtrieve615.WriteToIni(IniF);
    If FIncludeSQLReg Then FPervasive7.WriteToIni(IniF);
  Finally
    IniF.Free;
  End;
End; { WriteToIni }

{----------------------------------------------------------------------------}

Constructor TSetupEntRegistry.Create;
Begin { Create }
  Inherited Create;

  FClientServer     := False;
  FClientServerODBC := False;
  FEntDir           := '';
  FRegSettings      := TBtrieveRegistry.Create(Self);
  FUserCount        := 1;
End; { Create }

Destructor TSetupEntRegistry.Destroy;
Begin { Destroy }
  FRegSettings.Free;

  Inherited Destroy;
End; { Destroy }

//-----------------------------------------

{ Run W32MKDE.EXE with -REGSERVER parameter to ensure all entries are setup correctly }
Procedure TSetupEntRegistry.RegisterBtrieve615;
Var
  MaxTime : LongInt;
  Cmd     : PChar;
Begin { RegisterBtrieve615 }
  Cmd := StrAlloc (255);

  StrPCopy (Cmd, FEntDir + 'W32MKDE.EXE -REGSERVER');
  //WinExec  (Cmd, SW_SHOW);
RunApp (Cmd, True);

  StrDispose (Cmd);

  { Wait for 2 seconds to allow program to setup the registry }
  MaxTime := TimeVal + 2;
  Repeat
    Application.ProcessMessages;
  Until (TimeVal > MaxTime);
End; { RegisterBtrieve615 }

//-----------------------------------------

Procedure TSetupEntRegistry.SetupBtrieve615 (Const IncludeSQL : Boolean = True);
Begin { SetupBtrieve615 }
  { Run W32MKDE.EXE with -REGSERVER parameter to ensure all entries are installed correctly }
  RegisterBtrieve615;

  If FClientServer And (FPervVersion = 3) And FileExists (FEntDir + 'BIN\MKC.DLL') Then
    // HM 17/07/03: Register MKC.DLL for Pervasive.SQL v8
    RegisterCOMServer (FEntDir + 'BIN\MKC.DLL');

  { Setup Btrieve entries for Exchequer requirements from Default Settings }
  FRegSettings.IncludeSQLReg := IncludeSQL;
  FRegSettings.ReadFromIni('z.z');

  { HM 01/02/00: Used for testing only }
  {FRegSettings.WriteToIni(FentDir + 'WSTATION\ENTBTRWS.INI');}
End; { SetupBtrieve615 }

//-----------------------------------------

Procedure TSetupEntRegistry.SetEntDir (Value : TFileName);
Var
  {$IFNDEF WCA}
  LicR    : EntLicenceRecType;
  {$ENDIF}
Begin { SetEntDir }
  { Check for changes }
//  TmpStr := Value;
//  FixPath(TmpStr);  // convert to short filename and add trailing \ if neccessary
//  Value := TmpStr;

  // MH 16/11/06: Modified to allow COM Objects to be registered to the long filename,
  //              causes problems under Windows Vista otherwise
  Value := IncludeTrailingPathDelimiter(Value);

  If (FEntDir <> Value) Then Begin
    { Check directory exists }
    If DirectoryExists (Value) Then Begin
      FEntDir := Value;

      {$IFNDEF WCA}
      { Load licence from Exchequer directory, if there! }
      If FileExists (FEntDir + EntLicFName) Then Begin
        { Licence Exists - load details }
        If ReadEntLic (FEntDir + EntLicFName, LicR) Then Begin
          { Init values from licence }
          ClientServer := (LicR.licEntClSvr = 1);
          UserCount := LicR.licUserCnt;
        End; { If ReadEntLic }
      End; { If }
      {$ENDIF}
    End; { If }
  End; { If }
End; { SetEntDir }

Function TSetupEntRegistry.GetDataDir : TFileName;
Begin { GetDataDir }
  If FDataDir <> '' Then
    Result := FDataDir
  Else
    Result := FEntDir;
End; { GetDataDir }

//-----------------------------------------

Procedure TSetupEntRegistry.SetDataDir (Value : TFileName);
Var
  TmpStr  : String;
Begin { SetDataDir }
  { Check for changes }
  TmpStr := Value;
  FixPath(TmpStr);
  Value := TmpStr;
  If (FDataDir <> Value) Then Begin
    { Check directory exists }
    If DirectoryExists (Value) Then
      FDataDir := Value;
  End; { If }
End; { SetDataDir }

//-----------------------------------------

Procedure TSetupEntRegistry.SetupOLESvr;
Var
  cmdFile, cmdPath, cmdParams : PChar;
  //Flags                       : SmallInt;
Begin { SetupOLESvr }
  {$IFDEF REG}  // EntReg - Exchequer Configuration and Registration Utility
    DispProgress ('');
    DispProgress ('  Registering OLE Server');
  {$ENDIF}

  If FileExists (FEntDir + 'ENTEROLE.EXE') Then Begin
    cmdFile   := StrAlloc(255);
    cmdPath   := StrAlloc(255);
    cmdParams := StrAlloc(255);

    StrPCopy (cmdParams, '/REGSERVER');
    StrPCopy (cmdFile,   FEntDir + 'ENTEROLE.EXE');
    StrPCopy (cmdPath,   FEntDir);

    //Flags := SW_SHOWMINIMIZED;
    //Res := ShellExecute (0, NIL, cmdFile, cmdParams, cmdPath, Flags);
RunApp (cmdFile + ' ' + cmdParams, True);

    StrDispose(cmdFile);
    StrDispose(cmdPath);
    StrDispose(cmdParams);
  End; { If }
End; { SetupOLESvr }

//-----------------------------------------

Procedure TSetupEntRegistry.SetupGraph;
Var
  cmdFile, cmdPath, cmdParams : PChar;
  //Flags                       : SmallInt;
Begin { SetupGraph }
  {$IFDEF REG}  // EntReg - Exchequer Configuration and Registration Utility
    DispProgress ('');
    DispProgress ('  Registering Graph Control');
  {$ENDIF}

// HM 26/08/03: Restored because of weird pathing problems using the RegisterComServer
//              method for the graph control
  (*** HM 25/01/02: Switched from REGSVR32.EXE to Delphi Command
  *)
  cmdFile := StrAlloc(255);
  StrPCopy (cmdFile, FindRegSvr32(FEntDir));

  If FileExists (cmdFile) And FileExists (FEntDir + 'VCFI32.OCX') Then Begin
    cmdPath   := StrAlloc(255);
    cmdParams := StrAlloc(255);

    StrPCopy (cmdParams, '/s ' + FEntDir + 'VCFI32.OCX');
    StrPCopy (cmdPath,   FEntDir);

    //Flags := SW_SHOWMINIMIZED;
    //Res := ShellExecute (0, NIL, cmdFile, cmdParams, cmdPath, Flags);
RunApp (cmdFile + ' ' + cmdParams, True);

    StrDispose(cmdPath);
    StrDispose(cmdParams);
  End; { If }

  StrDispose(cmdFile);
(*  ***)

//  If FileExists (FEntDir + 'VCFI32.OCX') Then
//    RegisterCOMServer (FEntDir + 'VCFI32.OCX');
End; { SetupGraph }

//-----------------------------------------

Procedure TSetupEntRegistry.SetupCOMCustom;
Var
  cmdFile, cmdPath, cmdParams : PChar;
  Flags                       : SmallInt;
Begin { SetupCOMCustom }
  {$IFDEF REG}  // EntReg - Exchequer Configuration and Registration Utility
    DispProgress ('');
    DispProgress ('  Registering COM Customisation with Windows');
  {$ENDIF}

//ShowMessage ('EntComp2.SetupReg.TSetupEntRegistry.SetupCOMCustom: FEntDir = ' + WinAPI_GetLongPathName(FEntDir));
//FEntDir := WinAPI_GetLongPathName(FEntDir);

  If FileExists (FEntDir + 'ENTER1.EXE') Then Begin
    cmdFile   := StrAlloc(255);
    cmdPath   := StrAlloc(255);
    cmdParams := StrAlloc(255);

    StrPCopy (cmdParams, '/REGSERVER /DIR: ' + FDataDir);
    StrPCopy (cmdFile,   FEntDir + 'ENTER1.EXE');
    StrPCopy (cmdPath,   FEntDir);

    Flags := SW_SHOWMINIMIZED;
    //Res := ShellExecute (0, NIL, cmdFile, cmdParams, cmdPath, Flags);
RunApp (cmdFile + ' ' + cmdParams, True);

    StrDispose(cmdFile);
    StrDispose(cmdPath);
    StrDispose(cmdParams);
  End; { If }
End; { SetupCOMCustom }

//-----------------------------------------

Procedure TSetupEntRegistry.SetupCOMTK;
{Var
  cmdFile, cmdPath, cmdParams : PChar;
  Flags                       : SmallInt;
  Res                         : LongInt;}

  procedure UnregisterComServer(const DLLName: string);
  type
    TRegProc = function: HResult; stdcall;
  const
    RegProcName = 'DllUnregisterServer'; { Do not localize }
  var
    Handle: THandle;
    RegProc: TRegProc;
  begin
    Handle := SafeLoadLibrary(DLLName);
    if Handle <= HINSTANCE_ERROR then
      raise Exception.CreateFmt('%s: %s', [SysErrorMessage(GetLastError), DLLName]);
    try
      RegProc := GetProcAddress(Handle, RegProcName);
      if Assigned(RegProc) then OleCheck(RegProc) else RaiseLastOSError;
    finally
      FreeLibrary(Handle);
    end;
  end;

Begin { SetupCOMTK }
  {$IFDEF REG}  // EntReg - Exchequer Configuration and Registration Utility
    DispProgress ('');
    DispProgress ('  Registering COM Toolkit with Windows');
  {$ENDIF}

  (*** HM 25/01/02: Switched from REGSVR32.EXE to Delphi Command
  cmdFile := StrAlloc(255);
  StrPCopy (cmdFile, FindRegSvr32);

  If FileExists (cmdFile) And FileExists (FEntDir + 'ENTTOOLK.DLL') Then Begin
    cmdPath   := StrAlloc(255);
    cmdParams := StrAlloc(255);

    StrPCopy (cmdParams, '/s ' + FEntDir + 'ENTTOOLK.DLL');
    StrPCopy (cmdPath,   FEntDir);

    Flags := SW_SHOWMINIMIZED;
    //Res := ShellExecute (0, NIL, cmdFile, cmdParams, cmdPath, Flags);
RunApp (cmdFile + ' ' + cmdParams, True);

    StrDispose(cmdPath);
    StrDispose(cmdParams);
  End; { If }

  StrDispose(cmdFile);
  ***)

  // MH 25/01/06: Added registration of out-of-process com toolkit
  If FileExists (FEntDir + 'ENTTOOLK.EXE') Then
  Begin
    // Unregister .DLL and register .EXE 
    If FileExists (FEntDir + 'ENTTOOLK.DLL') Then
    Begin
      UnregisterComServer(FEntDir + 'ENTTOOLK.DLL');
    End; // If FileExists (FEntDir + 'ENTTOOLK.DLL')
    RunApp (FEntDir + 'ENTTOOLK.EXE /REGSERVER', True);
  End // If FileExists (FEntDir + 'ENTTOOLK.EXE')
  Else If FileExists (FEntDir + 'ENTTOOLK.DLL') Then
    // Just register .DLL as that overrides the .EXE
    RegisterCOMServer (FEntDir + 'ENTTOOLK.DLL');
End; { SetupCOMTK }

//-----------------------------------------

Procedure TSetupEntRegistry.SetupEntLib;
Begin // SetupEntLib
  {$IFDEF REG}  // EntReg - Exchequer Configuration and Registration Utility
    DispProgress ('');
    DispProgress ('  Registering COM Toolkit Components with Windows');
  {$ENDIF}

  If FileExists (FEntDir + 'ENTLIB.001') Then
    RegisterCOMServer (FEntDir + 'ENTLIB.001');
End; // SetupEntLib

//------------------------------

Procedure TSetupEntRegistry.SetupExchScheduler;
Begin // SetupExchScheduler
  {$IFDEF REG}  // EntReg - Exchequer Configuration and Registration Utility
    DispProgress ('');
    DispProgress ('  Registering Exchequer Scheduler with Windows');
  {$ENDIF}

  If FileExists (FEntDir + 'EXSCHED.EXE') Then
    RunApp (FEntDir + 'EXSCHED.EXE /REGSERVER', True);
End; // SetupExchScheduler

//------------------------------

Procedure TSetupEntRegistry.SetupFormsTK;
Begin { SetupFormsTK }
  {$IFDEF REG}  // EntReg - Exchequer Configuration and Registration Utility
    DispProgress ('');
    DispProgress ('  Registering Forms Toolkit with Windows');
  {$ENDIF}

  If FileExists (FEntDir + 'ENTFORMS.EXE') Then
    RunApp (FEntDir + 'ENTFORMS.EXE /REGSERVER', True);
End; { SetupFormsTK }

//-----------------------------------------

Procedure TSetupEntRegistry.SetupPreviewAX;
Begin { SetupPreviewAX }
  {$IFDEF REG}  // EntReg - Exchequer Configuration and Registration Utility
    DispProgress ('');
    DispProgress ('  Registering SDK Form Components with Windows');
  {$ENDIF}

  If FileExists (FEntDir + 'EntPrevX.Ocx') Then
    RegisterCOMServer (FEntDir + 'EntPrevX.Ocx');
End; { SetupPreviewAX }

//-----------------------------------------

Procedure TSetupEntRegistry.SetupDataQuery;
Begin { SetupDataQuery }
  {$IFDEF REG}  // EntReg - Exchequer Configuration and Registration Utility
    DispProgress ('');
    DispProgress ('  Registering Excel Data Query Components');
  {$ENDIF}

  If FileExists (FEntDir + 'EntDataQ.Dll') Then
    RegisterCOMServer (FEntDir + 'EntDataQ.Dll');
End; { SetupDataQuery }

//-----------------------------------------

Procedure TSetupEntRegistry.SetupDrillDown;
Begin { SetupDrillDown }
  {$IFDEF REG}  // EntReg - Exchequer Configuration and Registration Utility
    DispProgress ('');
    DispProgress ('  Registering Excel Drill-Down Components');
  {$ENDIF}

  If FileExists (FEntDir + 'ENTDRILL.EXE') Then
    RunApp (FEntDir + 'ENTDRILL.EXE /REGSERVER', True);
End; { SetupDrillDown }

//-----------------------------------------

Procedure TSetupEntRegistry.SetupDBFWriter;
Begin { SetupDBFWriter }
  {$IFDEF REG}  // EntReg - Exchequer Configuration and Registration Utility
    DispProgress ('');
    DispProgress ('  Registering DBF Writer with Windows');
  {$ENDIF}

  If FileExists (FEntDir + 'DBFWrite.DLL') Then
    RegisterCOMServer (FEntDir + 'DBFWrite.DLL');
End; { SetupDBFWriter }

//-----------------------------------------

Procedure TSetupEntRegistry.SetupSecuritySvr;
{Var
  cmdFile, cmdPath, cmdParams : PChar;
  Flags                       : SmallInt;
  Res                         : LongInt;}
Begin { SetupSecuritySvr }
  {$IFDEF REG}  // EntReg - Exchequer Configuration and Registration Utility
    DispProgress ('');
    DispProgress ('  Registering Security Server with Windows');
  {$ENDIF}

  (*** HM 25/01/02: Switched from REGSVR32.EXE to Delphi Command
  cmdFile := StrAlloc(255);
  StrPCopy (cmdFile, FindRegSvr32);

  If FileExists (cmdFile) And FileExists (FEntDir + 'ENTSECUR.DLL') Then Begin
    cmdPath   := StrAlloc(255);
    cmdParams := StrAlloc(255);

    StrPCopy (cmdParams, '/s ' + FEntDir + 'ENTSECUR.DLL');
    StrPCopy (cmdPath,   FEntDir);

    Flags := SW_SHOWMINIMIZED;
    //Res := ShellExecute (0, NIL, cmdFile, cmdParams, cmdPath, Flags);
    RunApp (cmdFile + ' ' + cmdParams, True);

    StrDispose(cmdPath);
    StrDispose(cmdParams);
  End; { If }

  StrDispose(cmdFile);
  ***)

  If FileExists (FEntDir + 'ENTSECUR.DLL') Then
    RegisterCOMServer (FEntDir + 'ENTSECUR.DLL');
End; { SetupSecuritySvr }

{----------------------------------------------------------------------------}

// HM 05/08/04: Added SystemDir value into HKEY_CURRENT_USER\Software\Exchequer\Enterprise
// for VAO, note LongEntDir is the long filename path
Procedure TSetupEntRegistry.SetupSystemDir(Const LongEntDir : ShortString);
Begin // SetupSystemDir
  With TRegistry.Create Do
  Begin
    Try
      Access := KEY_WRITE;
      RootKey := HKEY_CURRENT_USER;

      If OpenKey ('Software\Exchequer\Enterprise\', True) Then
      Begin
        WriteString('SystemDir', LongEntDir);
      End; // If OpenKey ('Software\Exchequer\Enterprise\')
    Finally
      Free;
    End; // Try..Finally
  End; // With TRegistry.Create
End; // SetupSystemDir

//-------------------------------------------------------------------------

Procedure TSetupEntRegistry.SetupSpellCheck(Const LongEntDir : ShortString);
Begin // SetupSpellCheck
  With TRegistry.Create Do
  Begin
    Try
      Access := KEY_WRITE;
      RootKey := HKEY_LOCAL_MACHINE;

      If OpenKey ('SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\ISpell.exe', True) Then
      Begin
        WriteString('', LongEntDir + 'Spell\ISpell.Exe');
        WriteString('Path', LongEntDir + 'Spell\');
      End; // If OpenKey ('SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\ISpell.exe', True)
    Finally
      Free;
    End; // Try..Finally
  End; // With TRegistry.Create
End; // SetupSpellCheck

//-------------------------------------------------------------------------

end.
