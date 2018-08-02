library IKPIHost;

uses
  ComServ,
  IKPIHost_TLB in 'IKPIHost_TLB.pas',
  IKPIHost_IMPL in 'IKPIHost_IMPL.pas' {AddInModule: TAddInModule} {KPIAddin: CoClass},
  KPIFormU in 'KPIFormU.pas' {KPIForm: TadxOlForm},
  KPICOMUtils in 'KPICOMUtils.pas',
  KPIAvailablePluginsU in 'KPIAvailablePluginsU.pas',
  KPICommon in 'KPICommon.pas',
  MessageF in 'MessageF.pas' {frmOCXMessaging},
  KPIHostControlU in 'KPIHostControlU.pas',
  KPIBasePanelU in 'KPIBasePanelU.pas',
  KPIChartPanelU in 'KPIChartPanelU.pas',
  KPIDataPanelU in 'KPIDataPanelU.pas',
  KPIUtils in 'KPIUtils.pas',
  KPIAuthenticationPluginsU in 'KPIAuthenticationPluginsU.pas',
  KPILayoutManagerU in 'KPILayoutManagerU.pas',
  KPIActivePluginsU in 'KPIActivePluginsU.pas',
  KPIManagerU in 'KPIManagerU.pas',
  KPISelectPluginsDlgU in 'KPISelectPluginsDlgU.pas' {KPISelectPluginsDlg},
  KPIUpdateIntervalDlgU in 'KPIUpdateIntervalDlgU.pas' {KPIUpdateIntervalDlg},
  SerialU in 'W:\ENTRPRSE\MULTCOMP\SERIALU.PAS',
  EntLic in 'W:\ENTRPRSE\MULTCOMP\ENTLIC.PAS',
  Crypto in 'W:\ENTRPRSE\MULTCOMP\CRYPTO.PAS',
  History in 'History.pas',
  GmXml in 'W:\COMPON\TGMXML\GmXML.pas',
  KPIIniFileClass in 'KPIIniFileClass.pas',
  BannerConfigForm in 'BannerConfigForm.pas' {frmConfigureBanner},
  EntLicence in '..\..\DRILLDN\EntLicence.pas',
  Enterprise01_TLB in '..\..\COMTK\Enterprise01_TLB.pas',
  SecCodes in '..\..\COMTK\SECCODES.PAS',
  KPIConfigLabelFormU in 'KPIConfigLabelFormU.pas' {KPIConfigLabelForm};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin

end.
