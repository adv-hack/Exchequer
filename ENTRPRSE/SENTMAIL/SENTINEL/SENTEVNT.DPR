library SentEvnt;

uses
  ComServ,
  Sentimail_TLB in 'Sentimail_TLB.pas',
  Sevent in 'SEVENT.PAS' {SentimailEvent: CoClass},
  eventfnc in 'eventfnc.pas',
  trigger in 'trigger.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
