library EntSMS;

uses
  ComServ,
  EnterpriseSMS_TLB in 'EnterpriseSMS_TLB.pas',
  oMain in 'oMain.pas' {SMSSender: CoClass},
  setup in 'setup.pas' {frmSetup},
  smslic in 'smslic.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
