library ExFuncs;

uses
  ComServ,
  ExFuncs_TLB in 'ExFuncs_TLB.pas',
  oExFuncs in 'oExFuncs.pas' {ExchequerFunctions: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
