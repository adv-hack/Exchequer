library ICSImSta;

uses
  ComServ,
  DSRImport_TLB in '..\..\ImportBox\DSRImport_TLB.pas',
  IrisClientSync_TLB in 'IrisClientSync_TLB.pas',
  oImporter in 'oImporter.pas' {StaticDataImporter: CoClass},
  uGLStructureImport in '..\..\Common\uGLStructureImport.pas',
  uEXCHBaseClass in '..\..\Common\uEXCHBaseClass.pas',
  uImportBaseClass in '..\..\Common\uImportBaseClass.pas',
  uCustImport in '..\..\Common\uCustImport.pas',
  uStockImport in '..\..\Common\uStockImport.pas',
  uBtrieveThread in '..\..\Common\uBtrieveThread.pas',
  uHistory in '..\..\Common\uHistory.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
