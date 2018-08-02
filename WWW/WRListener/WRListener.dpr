program WRListener;

uses
  SvcMgr,
  uWRListener in 'uWRListener.pas' {frmListener: TService},
  uSMSPoller in 'uSMSPoller.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'WRListener';
  Application.CreateForm(TfrmListener, frmListener);
  Application.Run;
end.
