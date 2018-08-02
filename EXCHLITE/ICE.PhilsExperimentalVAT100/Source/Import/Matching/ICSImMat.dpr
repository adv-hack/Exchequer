library ICSImMat;

uses
  ComServ,
  DSRImport_TLB in '..\..\ImportBox\DSRImport_TLB.pas',
  IrisClientSync_TLB in 'IrisClientSync_TLB.pas',
  oImporter in 'oImporter.pas' {MatchingDataImporter: CoClass},
  uMatchingImport in '..\..\Common\uMatchingImport.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
