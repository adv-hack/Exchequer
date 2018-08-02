{program }library SMSMMC;

{$REALCOMPATIBILITY ON}

uses
  ComServ,
  Forms,
  oMain in 'oMain.pas' {SMSSender: CoClass},
  EnterpriseSMS_TLB in 'EnterpriseSMS_TLB.pas',
  Setup in 'x:\ENTRPRSE\SENTMAIL\SMS\MMCSOAP\SETUP.PAS' {frmSetup};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
{  Application.Initialize;
  Application.Title := 'Card COM Toolkit b?';
  Application.CreateForm(TForm1, Form1);
  Application.Run;}
end.

