library DSREmail;

uses
  ComServ,
  DSREmail_TLB in 'DSREmail_TLB.pas',
  uDSREmailSystem in 'uDSREmailSystem.pas' {DSREmailSystem: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
