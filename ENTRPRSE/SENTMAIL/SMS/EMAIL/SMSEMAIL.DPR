library SMSEmail;

uses
  ComServ,
  EnterpriseSMS_TLB in 'EnterpriseSMS_TLB.pas',
  oMain in 'oMain.pas' {SMSSender: CoClass},
  CommsInt in '..\..\..\ENTCOMMS\COMMSINT.PAS',
  Setup in 'SETUP.PAS' {frmSetup};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
