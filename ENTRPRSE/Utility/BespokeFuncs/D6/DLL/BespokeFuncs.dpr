library BespokeFuncs;

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
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  SysUtils,
  Classes,
  BSQLExports in 'BSQLExports.pas',
  BespokeBlowfish in '..\Shared\BespokeBlowfish.pas',
  BespokeXML in '..\Shared\BespokeXML.pas',
  DataModule in '..\Shared\DataModule.pas' {SQLDataModule: TDataModule},
  SQLLogin in '..\Shared\SQLLogin.pas' {frmSQLLogin},
  AdminProc in '..\SQLAdmin\AdminProc.pas',
  SpecialPassword in '..\FUNCS\SpecialPassword.pas',
  BespokeFuncsInterface in '..\FUNCS\BespokeFuncsInterface.pas';

{SpecialPassword in 'u:\BESPOKE\FUNCS\SpecialPassword.pas';}
{$R *.res}

exports
  A index 1 Name ''
  , B index 2 Name ''
  , C index 3 Name ''
  , D index 4 Name ''
  , E index 5 Name ''
  , F index 6 Name ''
  , G index 7 Name ''
  , H index 8 Name ''
  , I index 9 Name ''
  , J index 10 Name ''
  , K index 11 Name ''
  , L index 12 Name ''
  , M index 13 Name ''
  , N index 14 Name ''
  , O index 15 Name ''
  , P index 16 Name ''
  , Q index 17 Name ''
  , R index 18 Name ''
  , S index 19 Name ''
  , T index 20 Name ''
  , U index 21 Name ''
  , V index 22 Name ''
  ;
{  SQLGetExchequerDatabaseProperties index 1 Name ''
  , SQLSetUsername index 2 Name ''
  , SQLSetUserPassword index 3 Name ''
  , SQLGetUsername index 4 Name ''
  , SQLGetUserPassword index 5 Name ''
  , SQLGetBespokeDatabaseNameForCode index 6 Name ''
  , SQLBuildBespokeConnectionString index 7 Name ''
  , SQLBuildAdminConnectionString index 8 Name ''
  , SQLBuildStandardConnectionString index 9 Name ''
  , SQLAddDefaultUser index 10 Name ''
  , SQLDatabaseExists index 11 Name ''
  , SQLTableExists index 12 Name ''
  , SQLDatabaseDelete index 13 Name ''
  , SQLDatabaseCreate index 14 Name ''
  , SQLLoginExists index 15 Name ''
  , SQLUserExistsForDatabase index 16 Name ''
  , SQLLoginCreate index 17 Name ''
  , SQLAddDatabaseUser index 18 Name ''
  , SQLExecute index 19 Name ''
  , SQLGetServerNamePervasive index 20 Name ''
  , SQLExchVersionSQL index 21 Name ''
  ;}
end.

