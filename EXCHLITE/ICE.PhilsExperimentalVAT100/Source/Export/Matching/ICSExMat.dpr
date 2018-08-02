library ICSExMat;

uses
  ComServ,
  DSRExport_TLB in '..\..\ExportBox\DSRExport_TLB.pas',
  IrisClientSync_TLB in 'IrisClientSync_TLB.pas',
  oExporter in 'oExporter.pas' {MatchingDataExporter: CoClass},
  uEXCHBaseClass in 'X:\EXCHLITE\ICE\Source\Common\uEXCHBaseClass.pas',
  uBaseClass in 'X:\EXCHLITE\ICE\Source\Common\uBaseClass.pas',
  uExportBaseClass in 'X:\EXCHLITE\ICE\Source\Common\uExportBaseClass.pas',
  uMatchingExportManager in '..\..\Common\uMatchingExportManager.pas',
  uMatchingExport in '..\..\Common\uMatchingExport.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
