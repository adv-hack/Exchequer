Library EImport;

uses
  ComServ,
  EImport_TLB in 'EImport_TLB.pas',
  uENTImport in 'uENTImport.pas' {ENTImport: CoClass},
  DSRImport_TLB in '..\ImportBox\DSRImport_TLB.pas',
  uVATImport in '..\Common\uVATImport.pas';

Exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

Begin
End.

