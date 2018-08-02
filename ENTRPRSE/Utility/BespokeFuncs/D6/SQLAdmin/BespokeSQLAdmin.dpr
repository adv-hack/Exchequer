program BespokeSQLAdmin;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  Main in 'Main.pas' {frmBespokeSQLAdmin},
  Login in 'Login.pas' {frmLogin},
  BespokeXML in '..\Shared\BespokeXML.pas',
  BespokeBlowfish in '..\Shared\BespokeBlowfish.pas',
  ScriptDetails in 'ScriptDetails.pas' {frmScriptDetails},
  Tables in 'Tables.pas' {frmTables},
  DatabaseDetails in 'DatabaseDetails.pas' {frmDatabaseDetails},
  DataModule in '..\Shared\DataModule.pas' {SQLDataModule: TDataModule},
  SQLLogin in '..\Shared\SQLLogin.pas' {frmSQLLogin},
  TableDetails in 'TableDetails.pas' {frmTableDetails},
  uMessages in 'uMessages.pas' {frmMessages},
  BespokeFuncsInterface in '..\FUNCS\BespokeFuncsInterface.pas',
  SpecialPassword in '..\FUNCS\SpecialPassword.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmBespokeSQLAdmin, frmBespokeSQLAdmin);
  Application.CreateForm(TfrmMessages, frmMessages);
  Application.Run;
end.
