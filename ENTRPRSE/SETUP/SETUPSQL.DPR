{-----------------------------------------------------------------------------
 Purpose: General Sql setup routines
-----------------------------------------------------------------------------}

library SETUPSQL;

uses
  ComServ,
  uSQLFuncs in 'uSQLFuncs.pas',
  uCreateLic in 'uCreateLic.pas',
  uSQLClass in 'uSQLClass.pas',
  SQLHelperFuncs in 'SQLHelperFuncs.pas',
  SQLH_MemMap in '..\MULTCOMP\SQLHelper\SQLH_MemMap.Pas',
  WiseUtil in '..\FUNCS\WISEUTIL.PAS';

exports
  {load sql/btrieve emulator and create the database}
  SCD_CreateSQLDatabase,

  {load sql/btrieve emulator and create the company tables}
  SCD_CreateSQLCompany,

  {copy and past of createlicence from entcomp2.dll... it is here to do not mess with entcomp2.dll x sql x btrieve}
  SCD_CreateLicence,

  {copy sql data from one company to another}
  SCD_ImportCompData,

  // SQLHelperFuncs.Pas
  SQLHLPR_CreateSQLDatabase,
  SQLHLPR_CreateSQLCompany,
  SQLHLPR_SQLDataImport,
  SQLHLPR_ImportCompData,
  SQLHLPR_ImportCommonData,
  SQLHLPR_ReplicateFiles,
  SQLHLPR_InitialiseImporterJobs,
  SQLHLPR_ConvertData,
  SQLHLPR_SetupLicence,
  SQLHLPR_SetupCompanyCount,
  SQLHLPR_EntCompanyWizard,
  SQLHLPR_ReplicateLicence,
  SQLHLPR_EntDataCopy,
  SQLHLPR_CopyMainSecurity,
  SQLHLPR_CheckCompanyCount,
  SQLHLPR_CompanyExists,
  SQLHLPR_ArchiveFiles,
  SQLHLPR_GenRootLocFiles,
  SQLHLPR_GenLocFiles,
  SQLHLPR_CreateAuditTrail,
  SQLHLPR_CreateVAT100Dirs,
  // MH 07/04/2017 2017-R1 ABSEXCH-18512: Example VRW Reports
  SQLHLPR_AddDirectoryToReplicationList,
  // MH 08/01/2018 2017-R1 ABSEXCH-19316: Initialise SQL Posting Flags
  SQLHLPR_InitialiseSQLPostingFlags
  ;


{$R *.RES}

begin
end.
