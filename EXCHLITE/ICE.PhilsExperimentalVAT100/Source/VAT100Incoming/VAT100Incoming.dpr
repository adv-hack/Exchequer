library VAT100Incoming;

uses
  ComServ,
  uVAT100Receiving in 'uVAT100Receiving.pas' {VAT100Receiving: CoClass},
  uDSRSettings in '..\DSR\uDSRSettings.pas',
  uVAT100CallBack in 'uVAT100CallBack.pas' {VAT100CallBack: CoClass},
  DSRIncoming_TLB in '..\DSR\Incoming\DSRIncoming_TLB.pas',
  VATXMLConst in '..\..\..\..\ENTRPRSE\R&D\VATXMLConst.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
