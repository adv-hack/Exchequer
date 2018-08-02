library DSRPOP3Receive;

uses
  ComServ,
  DSRPOP3Receive_TLB in 'DSRPOP3Receive_TLB.pas',
  uDSRPOP3Receiver in 'uDSRPOP3Receiver.pas' {DSRPOP3Receiver: CoClass},
  DSRIncoming_TLB in 'X:\EXCHLITE\ICE\Source\DSR\Incoming\DSRIncoming_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
