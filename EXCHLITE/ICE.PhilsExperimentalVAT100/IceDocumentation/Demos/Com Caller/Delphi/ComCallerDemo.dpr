program ComCallerDemo;

uses
  Forms,
  uComCallerDemo in 'uComCallerDemo.pas' {frmComCaller},
  uSyncronization in 'uSyncronization.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmComCaller, frmComCaller);
  Application.Run;
end.
