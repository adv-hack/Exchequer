library ConvertToSQL_PSQL;

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
  Sharemem,
  SysUtils,
  Classes,
  First in 'First.pas',
  GlobVar in '..\..\..\..\R&D\GLOBVAR.PAS',
  Btrvu2 in '..\..\..\..\..\SBSLIB\WIN\WIN32\BTRVU2.PAS',
  oGenericBtrieveFile in 'oGenericBtrieveFile.pas',
  CheckPervasiveDir in 'CheckPervasiveDir.pas',
  oCompanyDat in 'oCompanyDat.pas',
  oConvertOptions in '..\oConvertOptions.pas',
  oDataConversionTask in '..\oDataConversionTask.pas',
  LoadCompanies in 'LoadCompanies.pas',
  ReadLicence in 'ReadLicence.pas',
  LicRec in '..\..\..\..\..\sbslib\win\excommon\LicRec.pas',
  SerialU in '..\..\..\..\MULTCOMP\SERIALU.PAS',
  EntLic in '..\..\..\..\MULTCOMP\ENTLIC.PAS',
  oBtrieveOnlyFile in '..\..\..\..\MULTCOMP\oBtrieveOnlyFile.pas';

{$R *.res}

Exports
  // CheckPervasiveDir.Pas
  CheckExch600PervasiveDir,

  // ReadLicence
  ReadExchLicence,
  ResetExchLicenceESN,

  // LoadCompanies.Pas
  LoadCompaniesList;
end.
