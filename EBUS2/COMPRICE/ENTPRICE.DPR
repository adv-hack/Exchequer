library EntPrice;

uses
  ComServ,
  Enterprise02_TLB in 'Enterprise02_TLB.pas',
  PriceClc in 'PriceClc.pas' {COMPricing: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
