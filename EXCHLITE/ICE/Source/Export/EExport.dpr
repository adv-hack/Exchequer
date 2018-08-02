Library EExport;


{$REALCOMPATIBILITY ON}
{$ALIGN 1}


uses
  ComServ,
  EExport_TLB in 'EExport_TLB.pas',
  uENTExport in 'uENTExport.pas' {ENTExport: CoClass},
  DSRExport_TLB in '..\ExportBox\DSRExport_TLB.pas';

Exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

Begin
End.

