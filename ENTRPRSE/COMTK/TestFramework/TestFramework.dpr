program TestFramework;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  MainF in 'MainF.pas' {frmMain},
  SQLCallerU in '..\..\Funcs\SQLCallerU.pas',
  CompareIntf in 'CompareIntf.pas',
  CompareSQLU in 'CompareSQLU.pas',
  CompareIniFile in 'CompareIniFile.pas',
  CompareSQLDb in 'CompareSQLDb.pas',
  FrameworkUtils in 'FrameworkUtils.pas',
  ResultF in 'ResultF.pas' {frmShowResult},
  TestList in 'TestList.pas',
  TestItemF in 'TestItemF.pas' {frmTestItem},
  TestConst in 'TestConst.pas',
  RowCompare in 'RowCompare.pas',
  ShowTableDiff in 'ShowTableDiff.pas' {frmShowTableDifferences},
  FrameworkIni in 'FrameworkIni.pas',
  SetupDb in 'SetupDb.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmShowResult, frmShowResult);
  Application.CreateForm(TfrmTestItem, frmTestItem);
  Application.CreateForm(TfrmShowTableDifferences, frmShowTableDifferences);
  Application.Run;
end.
