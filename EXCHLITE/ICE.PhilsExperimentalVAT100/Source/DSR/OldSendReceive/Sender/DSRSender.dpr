library DSRSender;

uses
  ComServ,
  DSRSender_TLB in 'DSRSender_TLB.pas',
  uDSREmailSender in 'uDSREmailSender.pas' {DSREmailSender: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
