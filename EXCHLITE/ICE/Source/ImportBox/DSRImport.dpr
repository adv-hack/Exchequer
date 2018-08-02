Library DSRImport;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  ComServ,
  DSRImport_TLB in 'DSRImport_TLB.pas',
  uImportBox in 'uImportBox.pas' {ImportBox: CoClass};

Exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

Begin
End.

