program BtrvSQLUnitTests;

uses
  Forms,
  MainFormU in 'MainFormU.pas' {MainForm},
  ClientIdU in '..\ClientIdU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
