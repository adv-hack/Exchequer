Library DSROutgoing;

uses
  ComServ,
  DSROutgoing_TLB in 'DSROutgoing_TLB.pas',
  uDSROutgoingSystem in 'uDSROutgoingSystem.pas' {DSROutgoingSystem: CoClass};

Exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

Begin
End.

