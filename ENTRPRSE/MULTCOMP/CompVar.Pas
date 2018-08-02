Const
  {$IFNDEF V431CNV}
    {$IFNDEF COMTK}
      CompF    =  21;
    {$ELSE}
      CompF    = ReportF;
    {$ENDIF}
  {$ELSE}
    CompF      =  CompCnvF;
  {$ENDIF}

  CompNofKeys =  2;
  CompCodeK   =  0;
  CompPathK   =  1;     { Only use for company details records }

  CompNofSegs =  4;

  // Record Prefixes for Company.Dat
  cmCompDet        = 'C';      { Company Details }
  cmSetup          = 'S';      { MCM Setup & Licencing }
  cmUserCount      = 'U';      { Enterprise Global User Count }
  cmTKUserCount    = 'T';      { Toolkit Global User Count }
  cmTradeUserCount = 'R';      { Trade Counter Global User Count }
  cmPlugInSecurity = 'H';      { Plug-In Security }
  cmAccessControl  = 'A';      // User Count Access Control Record

  // Fixed Record Codes
  CmSetupCode = 'SETUP ';      { Code for MCM Setup & Licencing record }

  CompCodeLen = 6;
  CompNameLen = 45;
  CompPathLen = 100;

Type
  {$IF DEFINED(BTRVSQL_DLL) OR DEFINED(SQLConversion)}
  ISNArrayType   = Array[1..8] of Byte;
  {$IFEND}

  CompanyDetRec = record
    CompCode      : String[CompCodeLen];    { Company Code  }
    CompName      : String[CompNameLen];    { Company Name  }
    CompPath      : String[CompPathLen];    { Company Path - Short DOS 8.3 Format }

    { HM 13/01/01 (v4.40): Added Company Id for new v4.40 Security }
    CompId        : LongInt;

    // MH 29/11/06: Added Demo Data flag for IAO so that Demo Datasets are excluded from the company count
    CompDemoData  : Boolean;                // TRUE = Demo Data, FALSE = Blank/Live Data

    // MH 09/01/2013 v7.0.2 ABSEXCH-13857: Added export flag for Analytics
    CompExportToAnalytics : Boolean;        // Indicates whether the Analytics ETL process should include this company

    CompSpare     : Array [1..1353] Of Char;

    { HM 26/07/01: Added for in-memory analysis of company data for company List }
    CompDemoSys   : Boolean;                { Demo / Reseller system }
    CompTKUCount  : SmallInt;               { Number of Toolkit users logged into Data Set }
    CompTrdUCount : SmallInt;               { Number of Trade Counter users logged into Data Set }
    CompSysESN    : ISNArrayType;           { ESN from SysR in ExchQss.Dat }
    CompModId     : LongInt;                { CompanyId from ModRR in ExchQss.Dat }
    CompModSynch  : Byte;                   { CompanySynch from ModRR in ExchQss.Dat }
    CompUCount    : SmallInt;               { Current Logged in User Count in ExchqSS.Dat }
    CompAnal      : SmallInt;               { NOTE: Must always be 0 }
  End; { CompanyDetRec }

  CompOptRelCodeType = Record
    rcSecurity  : String[10];       // Current Security Code
    rcUserCount : SmallInt;         // User Count from last successfull Release Code
    rcExpiry    : Real48;           // Expiry Date for 30-Day user counts
  End; { CompOptRelCodeType }

  CompanyOptions = Record
    OptCode              : String[CompCodeLen];    { Index }
    OptName              : String[CompNameLen];    { Company Name  }
    OptPath              : String[CompPathLen];    { Company Path - Short DOS 8.3 Format }
    OptPWord             : String[8];              { Password }
    OptBackup            : String[200];            { Backup command line }
    OptRestore           : String[200];            { Restore command line }
    OptHidePath          : Boolean;                { Hide Paths if no Password }
    OptHideBackup        : Boolean;                { Hide Backup if no password }

    { HM 20/04/99: Added command files for P.SQL7 Btrieve in a Box }
    OptWin9xCmd          : String[8];
    OptWinNTCmd          : String[8];

    { HM 21/07/00: Added security on Check For Users }
    OptShowCheckUsr      : Boolean;               { Show Check for Users all the time }

    { HM 23/07/01 (v4.40): Added ESN to integrate Company.Dat into the security structure }
    optSystemESN         : ISNArrayType;           { System ESN this Company.Dat is linked to }

    // Enterprise Global User Count
    OptEntUserSecurity   : String[10];
    OptEntUserRelease    : String[10];
    OptEntUserExpiry     : Real48;                 { Not used - maintained just in case! }

    // User Count Security
    //   ucCompanies      1     Company Count for MCM
    //   ucToolkit30      2     Toolkit DLL - 30-day User Count
    //   ucToolkitFull    3     Toolkit DLL - Full User Count
    //   ucTradeCounter   4     Trade Counter User Count
    //   ucElerts         5     Available Elerts
    //
    //   ucEnterprise     21    Enterprise 30-Day User Count
    OptSecurity          : Array [1..21] Of CompOptRelCodeType;

    // HM 04/02/03: Added Option to hide Exchequer in the MCM
    OptShowExch          : Boolean;

    // HM 03/02/04: Added Bureau Module flag
    OptBureauModule      : Boolean;
    OptBureauAdminPWord  : String[10];

    // MH 11/05/07: Added Show View Company flag for v6.00
    OptShowViewCompany   : Boolean;

    OptSpare             : Array [1..500] Of Char;
  End; { CompanyOptions }

  HookSecurityRecType = Record
    hkCode         : String[CompCodeLen];    { Code (Unique Index) }
    hkName         : String[CompNameLen];    { Name }
    hkPath         : String[CompPathLen];    { Path (Unique Index) }

    hkId           : String[16];             { Hook Id }
    hkSecCode      : String[16];             { Hook Security Id }
    hkDesc         : String[100];            { Textual Description }

    hkSecType      : Byte;                   { Security Type - 0-System Rel Code, 1=User Count, 2=System + User Count }

    { System Release Code - None/30-Day/Full }
    hkSysSecurity  : String[10];             { System Security Code }
    hkSysRelStatus : Byte;                   { System Released Status }
    hkSysExpiry    : Real48;                 { System Release Code Expiry Date }

    { User Count Security }
    hkUCSecurity   : String[10];             { User Count Security Code }
    hkLicUCount    : SmallInt;               { Licenced User Count }
    hkCurrUCount   : SmallInt;               { Current User Count }

    { HM 12/11/01: Added message field for contact details }
    hkMessage      : String[100];

    hkVersion      : SmallInt;
    hkEncryptedCode: String[16];

    hkSpare        : Array [1..1092] Of Byte; { Pad to 1023 }
  End; { HookSecurityRecType }

  { User by the global user count security for keeping track of who is logged in where }
  UserCountXRefType = Record
    ucCode       : String[CompCodeLen];  { Code (Unique Index) }
    ucName       : String[CompNameLen];  { Name }
    ucPath       : String[CompPathLen];  { Path (Unique Index) }

    ucCompanyId  : LongInt;              { Company Id that User is logged into }
    ucWStationId : String[40];           { Computer Name that user is logged in on }
    ucUserId     : String[40];           { Windows User Name of logged in user }
    ucRefCount   : SmallInt;             { Reference Count for this record }

    ucSpare      : Array [1..1293] Of Byte; { Pad to 1023 }
  End; { UserCountXRefType }

  // Used by the Toolkit User Countng mechanism to prevent multiple login/logouts in parallel
  AccessControlType = Record
    acCode       : String[CompCodeLen];  // Idx0: System Id padded with spaces
    acNotUsed    : String[CompNameLen];  // Non-Index field
    acPath       : String[CompPathLen];  // Idx1: System Id padded with spaces

    acSystemId   : Char;

    acSpare      : Array [1..1380] Of Byte; { Pad to 1023 }
  End; // AccessControlType

  CompRec = record
    RecPFix  : Char;
    Case Byte Of
      1  : (CompDet       : CompanyDetRec);
      2  : (CompOpt       : CompanyOptions);
      3  : (UserRef       : UserCountXRefType);
      4  : (PlugInSec     : HookSecurityRecType);
      5  : (AccessControl : AccessControlType);

      99 : (Misc    : Array [1..1535] Of Char);
  End; { CompRec }

//{$IFNDEF BTRVSQL_DLL}
  Comp_FileDef = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..CompNofSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  End; { Comp_FileDef }
//{$ENDIF}
