Library EntSetup;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SetFuncs in 'SetFuncs.pas',
  WiseUtil in '..\..\FUNCS\WiseUtil.pas',
  WiseIntf in 'WiseIntf.pas',
  PILICNCE in 'PILICNCE.PAS',
  SetupBas in '..\..\SETUP\SETUPBAS.PAS' {SetupTemplate},
  SQLUtils in '..\..\FUNCS\SQLUtils.pas',
  SQLDataReplication in '..\..\MULTCOMP\SQLDataReplication.pas',
  VarConst in 'X:\ENTRPRSE\MULTCOMP\VarConst.pas',
  GlobVar in 'X:\ENTRPRSE\R&D\GLOBVAR.PAS',
  Btrvu2 in 'X:\SBSLIB\WIN\WIN32\BTRVU2.PAS',
  VarFPOSU in 'X:\ENTRPRSE\R&D\VARFPOSU.PAS',
  uSQLClass in 'X:\ENTRPRSE\SETUP\uSQLClass.pas',
  BtKeys1U in 'X:\ENTRPRSE\R&D\BTKeys1U.pas';

{$R *.RES}

Exports
  // Returns the current Enterprise directory as configured on
  // the workstation.
  GetEnterpriseDir,
  Wise7_GetEnterpriseDir,

  // Adds a COM Plug-In into EntCustm.Ini
  AddCOMPlugIn,
  Wise7_AddCOMPlugIn,

  // Adds a Delphi DLL Plug-In into EntCustm.Ini, Note DLLName should be the
  // name of the DLL excluding any path and extension information.
  AddDLLPlugIn,
  Wise7_AddDLLPlugIn,

  // Adds a new item into the Enterprise Tools menu
  AddToToolsMenu,
  Wise7_AddToToolsMenu,

  // Displays the Licence Agreement Dialog
  DisplayLicence,
  Wise7_DisplayLicence,

  // Removes COM Plugins from EntCustm.ini
  RemoveCOMPlugIn,
  Wise7_RemoveCOMPlugIn,

  // Removes DLL Plugins from EntCustm.ini
  RemoveDLLPlugIn,
  Wise7_RemoveDLLPlugIn,

  // Adds an LST File to REPLFILE.LST
  AddLSTFileToReplFile,
  Wise7_AddLSTFileToReplFile,

  // Adds a TCM Plug-In into TCCustom.Ini
  AddTCMPlugIn,
  Wise7_AddTCMPlugIn,

  // Adds a new entry in the entsetup.dat ini file to add a new option into the system setup menu in enterprise
  AddToSysSetupMenu,
  Wise7_AddToSysSetupMenu,

  // Checks for an SQL Version
  IsSQLVersion,
  Wise7_IsSQLVersion,

  // SQL Data Import - for adding SQL Tables
  SCD_SQLDataImport;

end.
