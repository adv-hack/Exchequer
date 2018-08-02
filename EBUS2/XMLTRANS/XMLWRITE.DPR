library XmlWrite;
 {$REALCOMPATIBILITY ON}
 {$ALIGN 1}
uses
  ComServ,
  Enterprise03_TLB in 'Enterprise03_TLB.pas',
  xml_writ in 'xml_writ.pas' {XmlWriter: CoClass},
  xmSerial in 'xmSerial.pas',
  Logfile in 'Logfile.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
