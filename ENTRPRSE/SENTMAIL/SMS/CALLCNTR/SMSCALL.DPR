{program }library SMSCall;

{$REALCOMPATIBILITY ON}

uses
  ComServ,
  Forms,
  oMain in 'oMain.pas' {SMSSender: CoClass},
  EnterpriseSMS_TLB in 'EnterpriseSMS_TLB.pas',
  PortReg in '..\..\..\..\FAX\FAXSEND\PORTREG.PAS',
  Setup in 'SETUP.PAS' {frmSetup},
  RegUtil in '..\..\..\FUNCS\RegUtil.pas';

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

