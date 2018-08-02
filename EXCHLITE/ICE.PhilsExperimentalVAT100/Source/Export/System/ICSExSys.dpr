library ICSExSys;

uses
  ComServ,
  IrisClientSync_TLB in 'IrisClientSync_TLB.pas',
  oExporter in 'oExporter.pas' {SystemDataExporter: CoClass},
  uEXCHBaseClass in '..\..\Common\uEXCHBaseClass.pas',
  uExportBaseClass in '..\..\Common\uExportBaseClass.pas',
  uVATExport in '..\..\Common\uVATExport.pas',
  uCCDeptExport in '..\..\Common\uCCDeptExport.pas',
  uCurrencyExport in '..\..\Common\uCurrencyExport.pas',
  uDocNumberExport in '..\..\Common\uDocNumberExport.pas',
  uGLCodeExport in '..\..\Common\uGLCodeExport.pas',
  DSRExport_TLB in '..\..\ExportBox\DSRExport_TLB.pas',
  uSystemExportManager in '..\..\Common\uSystemExportManager.pas',
  MSXML2_TLB in 'C:\Program Files\Borland\Delphi6\Imports\MSXML2_TLB.pas',
  uSystemSettingsExport in '..\..\Common\uSystemSettingsExport.pas',
  uPeriodExport in '..\..\Common\uPeriodExport.pas',
  uVersionExport in '..\..\Common\uVersionExport.pas',
  EntLicence in 'X:\ENTRPRSE\DRILLDN\EntLicence.pas',
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
