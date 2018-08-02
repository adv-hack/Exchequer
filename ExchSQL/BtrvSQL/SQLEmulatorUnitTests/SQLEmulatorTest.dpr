program SQLEmulatorTest;

uses
  Forms,
  DriveSetupU in 'DriveSetupU.pas',
  MainForm in 'MainForm.pas' {MainFrm},
  SQLUtils in '..\..\..\ENTRPRSE\FUNCS\SQLUtils.pas',
  CompanyU in 'CompanyU.pas',
  TemporaryTablesU in 'TemporaryTablesU.pas',
  SQLLockU in '..\SQLLockU.pas',
  DebugLogU in '..\DebugLogU.pas',
  GlobVar in '..\..\..\ENTRPRSE\R&D\GlobVar.pas',
  SQLVariantsU in '..\SQLVariantsU.pas',
  ClientIdU in '..\ClientIdU.pas',
  SQLRedirectorU in '..\SQLRedirectorU.pas',
  SQLStructuresU in '..\SQLStructuresU.pas',
  SQLFields in '..\..\..\ENTRPRSE\FUNCS\SQLFields.pas',
  SQLCompany in '\\bmtdev1\csandow\v6.3\ExchSQL\BtrvSQL\SQLCompany.pas';

{$R *.res}

begin

  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
