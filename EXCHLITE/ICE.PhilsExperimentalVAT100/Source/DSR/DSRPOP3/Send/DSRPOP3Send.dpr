library DSRPOP3Send;

uses
  ComServ,
  DSRPOP3Send_TLB in 'DSRPOP3Send_TLB.pas',
  uDSRPOP3Sender in 'uDSRPOP3Sender.pas' {DSRPOP3Sender: CoClass},
  DSROutgoing_TLB in 'X:\EXCHLITE\ICE\Source\DSR\Outgoing\DSROutgoing_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
