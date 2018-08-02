library tran2xml;

uses
  ComServ,
  EntXml_TLB in 'EntXml_TLB.pas',
  T2XML in 'T2XML.PAS' {XmlTransaction: CoClass},
  t2xadd in 't2xadd.pas',
  t2xlines in 't2xlines.pas',
  t2xline in 't2xline.pas',
  t2xconst in 't2xconst.pas',
  t2xWrite in 'T2XWRITE.PAS',
  xnarrtve in 'xnarrtve.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
