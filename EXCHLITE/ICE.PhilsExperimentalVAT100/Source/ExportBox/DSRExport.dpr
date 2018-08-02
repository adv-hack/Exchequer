Library DSRExport;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

Uses
  ComServ,
  DSRExport_TLB In 'DSRExport_TLB.pas',
  uExportBox In 'uExportBox.pas' {ExportBox: CoClass};

Exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

Begin
End.

