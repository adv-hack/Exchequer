Library DSRUtility;

Uses
  ComServ,
  DSRUtility_TLB In 'DSRUtility_TLB.pas',
  uDSRUtil In 'uDSRUtil.pas' {DSRUtil: CoClass};

Exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

Begin
End.

