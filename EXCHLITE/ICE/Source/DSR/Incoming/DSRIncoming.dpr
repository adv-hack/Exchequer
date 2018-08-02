library DSRIncoming;

uses
  ComServ,
  DSRIncoming_TLB in 'DSRIncoming_TLB.pas',
  uDSRIncomingSystem in 'uDSRIncomingSystem.pas' {DSRIncomingSystem: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
