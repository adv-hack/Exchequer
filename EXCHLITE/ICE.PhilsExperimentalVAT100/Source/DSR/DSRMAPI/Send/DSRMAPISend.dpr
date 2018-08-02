library DSRMAPISend;

uses
  ComServ,
  DSRMAPISend_TLB in 'DSRMAPISend_TLB.pas',
  uDSRMAPISender in 'uDSRMAPISender.pas' {DSRMAPISender: CoClass},
  DSROutgoing_TLB in 'X:\EXCHLITE\ICE\Source\DSR\Outgoing\DSROutgoing_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
