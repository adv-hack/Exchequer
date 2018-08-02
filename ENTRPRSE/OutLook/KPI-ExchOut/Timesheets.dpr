program Timesheets;

uses
  Forms,
  TSComunit in 'TSComunit.pas' {Form1},
  IRISTimesheets_TLB in 'IRISTimesheets_TLB.pas',
  TSCom2 in 'TSCom2.pas' {ODDTimesheets: CoClass},
  windows,
  sysutils,
  EnterpriseSecurity_TLB in 'w:\ENTRPRSE\CUSTOM\EntSecur\EnterpriseSecurity_TLB.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := false;
  Application.CreateForm(TForm1, Form1);
  Application.Run;


//  MessageBox(GetDesktopWindow, 'Closing Timesheets COM Server', 'ODD Timesheets', MB_OK);

end.
