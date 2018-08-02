library ICSImSys;

uses
  ComServ,
  DSRImport_TLB in '..\..\ImportBox\DSRImport_TLB.pas',
  IrisClientSync_TLB in 'IrisClientSync_TLB.pas',
  oImporter in 'oImporter.pas' {SystemDataImporter: CoClass},
  uImportBaseClass in '..\..\Common\uImportBaseClass.pas',
  uCurrencyImport in '..\..\Common\uCurrencyImport.pas',
  uCCDeptImport in '..\..\Common\uCCDeptImport.pas',
  uDocNumberImport in '..\..\Common\uDocNumberImport.pas',
  uGLCodeImport in '..\..\Common\uGLCodeImport.pas',
  uSystemSettingsImport in '..\..\Common\uSystemSettingsImport.pas',
  uVATImport in '..\..\Common\uVATImport.pas',
  uPeriodImport in '..\..\Common\uPeriodImport.pas',
  uVersionImport in '..\..\Common\uVersionImport.pas',
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
