library ICSExSta;

uses
  ComServ,
  DSRExport_TLB in '..\..\ExportBox\DSRExport_TLB.pas',
  uEXCHBaseClass in '..\..\Common\uEXCHBaseClass.pas',
  uExportBaseClass in '..\..\Common\uExportBaseClass.pas',
  IrisClientSync_TLB in 'IrisClientSync_TLB.pas',
  oExporter in 'oExporter.pas' {StaticDataExporter: CoClass},
  uGLStructureExport in '..\..\Common\uGLStructureExport.pas',
  uCustExport in '..\..\Common\uCustExport.pas',
  uStockExport in '..\..\Common\uStockExport.pas',
  uBaseExportManager in '..\..\Common\uBaseExportManager.pas',
  uStaticExportManager in '..\..\Common\uStaticExportManager.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
