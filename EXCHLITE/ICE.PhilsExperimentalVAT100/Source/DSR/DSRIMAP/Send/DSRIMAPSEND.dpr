library DSRIMAPSEND;

uses
  ComServ,
  DSRIMAPSEND_TLB in 'DSRIMAPSEND_TLB.pas',
  uDSRIMAPSender in 'uDSRIMAPSender.pas' {DSRIMAPSender: CoClass},
  DSROutgoing_TLB in 'x:\EXCHLITE\ICE\Source\DSR\Outgoing\DSROutgoing_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
