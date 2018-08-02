library EXSECPWD;

uses
  ComServ,
  Exchequer_TLB in 'Exchequer_TLB.pas',
  oSecPwrd in 'OSECPWRD.PAS' {SecPwords: CoClass},
  VarRec2U in 'VarRec2U.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
