library EntLib;

uses
  ComServ,
  EnterpriseBeta_TLB in 'EnterpriseBeta_TLB.pas',
  eBeta in 'eBeta.pas' {Test: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
