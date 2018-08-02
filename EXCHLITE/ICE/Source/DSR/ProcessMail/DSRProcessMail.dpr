library DSRProcessMail;

uses
  ComServ,
  DSRProcessMail_TLB in 'DSRProcessMail_TLB.pas',
  uDSRReceiverSystem in 'uDSRReceiverSystem.pas' {DSRProcessMailSystem: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
