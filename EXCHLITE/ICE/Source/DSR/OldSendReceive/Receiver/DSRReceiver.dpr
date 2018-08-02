library DSRReceiver;

uses
  ComServ,
  DSRReceiver_TLB in 'DSRReceiver_TLB.pas',
  uDSREmailSystem in 'uDSREmailSystem.pas' {DSRReceiverSystem: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
