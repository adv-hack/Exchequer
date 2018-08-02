library ConvertToSQL_MSSQL;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  SysUtils,
  Classes,
  ResetCompanyPaths in 'ResetCompanyPaths.pas',
  oCompanyDat in '..\PSQL DLL\oCompanyDat.pas',
  oConvertOptions in '..\oConvertOptions.pas',
  oBtrieveFile in '..\..\..\..\MULTCOMP\oBtrieveFile.pas',
  ReCalcSQLLicences in 'ReCalcSQLLicences.pas',
  GlobVar in '..\..\..\..\R&D\GLOBVAR.PAS',
  VarConst in '..\..\..\..\MULTCOMP\VARCONST.PAS',
  SetupBas in 'X:\ENTRPRSE\SETUP\SETUPBAS.PAS' {SetupTemplate},
  CommsInt in 'X:\ENTRPRSE\ENTCOMMS\COMMSINT.PAS',
  ERC in 'X:\ENTRPRSE\LICENCE\ERC.PAS',
  Base34 in 'X:\ENTRPRSE\BASE36\BASE34.PAS',
  WLicFile in 'X:\ENTRPRSE\CD\WLICFILE.PAS',
  EntLicence in 'X:\ENTRPRSE\DRILLDN\EntLicence.pas',
  SecWarn2 in 'SecWarn2.pas',

  // MH 16/04/2018 2018-R1 ABSEXCH-20406: Initialise SystemSetup DataVersionNo for New MSSQL Installations
  AddSystemSetupFields in '\Entrprse\MultComp\Upgrades\AddSystemSetupFields.pas';

{$R *.res}

Exports
  // ReCalcSQLLicences
  ReApplySQLLicenses,

  // ResetCompanyPaths
  ResetMCMPaths;
end.
