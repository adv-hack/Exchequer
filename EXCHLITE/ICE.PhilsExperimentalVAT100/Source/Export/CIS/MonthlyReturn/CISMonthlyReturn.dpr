{-----------------------------------------------------------------------------
  Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
library CISMonthlyReturn;

uses
  ComServ,
  CISMonthly_TLB in 'CISMonthly_TLB.pas',
  uCISMonthlyReturn in 'uCISMonthlyReturn.pas' {CISMonthlyReturn: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
