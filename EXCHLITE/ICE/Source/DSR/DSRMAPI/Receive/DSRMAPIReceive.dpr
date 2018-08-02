library DSRMAPIReceive;

uses
  ComServ,
  DSRMAPIReceive_TLB in 'DSRMAPIReceive_TLB.pas',
  uDSRMAPIReceiver in 'uDSRMAPIReceiver.pas' {DSRMAPIReceiver: CoClass},
  DSRIncoming_TLB in 'X:\EXCHLITE\ICE\Source\DSR\Incoming\DSRIncoming_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
