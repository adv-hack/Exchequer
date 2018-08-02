library SmsWap;

uses
  ComServ,
  EnterpriseSMS_TLB in 'EnterpriseSMS_TLB.pas',
  oSMS in 'oSMS.pas' {SMSSender: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
