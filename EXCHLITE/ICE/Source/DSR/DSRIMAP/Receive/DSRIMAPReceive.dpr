library DSRIMAPReceive;

uses
  ComServ,
  DSRIMAPReceive_TLB in 'DSRIMAPReceive_TLB.pas',
  uDSRIMAPReceiver in 'uDSRIMAPReceiver.pas' {DSRIMAPReceiver: CoClass},
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
