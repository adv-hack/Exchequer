Library DemoImport;

Uses
  ComServ,
  DemoImport_TLB In 'DemoImport_TLB.pas',
  uNewImport In 'uNewImport.pas' {NewImport: CoClass};

Exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

Begin
End.

