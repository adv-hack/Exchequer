library CISIncoming;

uses
  ComServ,
  uCISReceiving in 'uCISReceiving.pas' {CISReceiving: CoClass},
  uDSRSettings in '..\DSR\uDSRSettings.pas',
  uCISCallBack in 'uCISCallBack.pas' {CISCallBack: CoClass},
  DSRIncoming_TLB in '..\DSR\Incoming\DSRIncoming_TLB.pas',
  CISIncoming_TLB in 'CISIncoming_TLB.pas',
  InternetFiling_TLB in 'C:\Develop\Borland\Delphi6\Imports\InternetFiling_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
