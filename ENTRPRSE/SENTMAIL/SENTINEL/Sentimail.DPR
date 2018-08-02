library Sentimail;

uses
  ComServ,
  ElEvent_TLB in 'ElEvent_TLB.pas',
  Sevent in 'SEVENT.PAS' {SentimailEvent: CoClass},
  eventfnc in 'eventfnc.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
