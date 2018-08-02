library tran2xml;

uses
  ComServ,
  EntXml_TLB in 'EntXml_TLB.pas',
  T2XML in '..\XMLTRANS\T2XML.PAS' {XmlTransaction: CoClass},
  t2xadd in '..\XMLTRANS\t2xadd.pas',
  t2xlines in '..\XMLTRANS\t2xlines.pas',
  t2xline in '..\XMLTRANS\t2xline.pas',
  t2xconst in '..\XMLTRANS\t2xconst.pas',
  t2xWrite in '..\XMLTRANS\T2XWRITE.PAS',
  xnarrtve in '..\XMLTRANS\xnarrtve.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
