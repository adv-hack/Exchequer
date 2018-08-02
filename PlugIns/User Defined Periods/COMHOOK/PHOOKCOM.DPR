program PHookCOM;

uses
  Forms,
  PerHook in 'PerHook.pas' {frmPeriodHook},
  PerUtil in '..\Shared\PerUtil.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer User-Defined Period Plug-In';
  Application.ShowMainForm := False;
  Application.CreateForm(TfrmPeriodHook, frmPeriodHook);
  Application.Run;
end.
