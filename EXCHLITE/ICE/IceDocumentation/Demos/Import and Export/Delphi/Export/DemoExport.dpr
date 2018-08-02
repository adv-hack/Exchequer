Library DemoExport;

Uses
  ComServ,
  DemoExport_TLB In 'DemoExport_TLB.pas',
  uNewExport In 'uNewExport.pas' {NewExport: CoClass};

Exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

Begin
End.

