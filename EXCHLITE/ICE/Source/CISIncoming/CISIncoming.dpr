library CISIncoming;

uses
  ComServ,
  CISIncoming_TLB in 'CISIncoming_TLB.pas',
  uCISReceiving in 'uCISReceiving.pas' {CISReceiving: CoClass},
  uDSRSettings in 'X:\EXCHLITE\ICE\Source\DSR\uDSRSettings.pas',
  uCISCallBack in 'uCISCallBack.pas' {CISCallBack: CoClass},
  DSRIncoming_TLB in 'X:\EXCHLITE\ICE\Source\DSR\Incoming\DSRIncoming_TLB.pas',
  mscorlib_TLB in 'X:\EXCHLITE\ICE\Source\Common\mscorlib_TLB.pas',
  CISXCnst in '\Entrprse\CISXML\CISXCnst.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
