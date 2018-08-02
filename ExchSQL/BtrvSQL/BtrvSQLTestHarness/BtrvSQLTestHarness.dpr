program BtrvSQLTestHarness;
{$REALCOMPATIBILITY ON}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  SQLCompany in '..\SQLCompany.pas',
  BtrvSQLU in '..\BtrvSQLU.pas',
  DebugLogU in '..\DebugLogU.pas',
  ClientIdU in '..\ClientIdU.pas',
  SQLCallerU in '..\SQLCallerU.pas',
  SQLCache in '..\SQLCache.pas',
  SQLLockU in '..\SQLLockU.pas',
  SQLVariantsU in '..\SQLVariantsU.pas',
  SQLStructuresU in '..\SQLStructuresU.pas',
  GlobVar in '..\..\..\ENTRPRSE\R&D\GLOBVAR.PAS',
  SQLRedirectorU in '..\SQLRedirectorU.pas',
  TestUnit in 'TestUnit.pas',
  TemporaryTablesU in '\\bmtdev1\csandow\v6.4\ExchSQL\BtrvSQL\BtrvSQLTestHarness\TemporaryTablesU.pas',
  CompanyU in '\\bmtdev1\csandow\v6.4\ExchSQL\BtrvSQL\BtrvSQLTestHarness\CompanyU.pas',
  DriveSetupU in '\\bmtdev1\csandow\v6.4\ExchSQL\BtrvSQL\BtrvSQLTestHarness\DriveSetupU.pas';

{$R *.res}

begin
  Application.Initialize;
  if System.IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.
