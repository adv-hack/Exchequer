library IEAuth;

{$REALCOMPATIBILITY ON}

uses
  ComServ,
  IRISEnterpriseKPI_TLB in 'IRISEnterpriseKPI_TLB.pas',
  oEnterpriseAuthentication in 'oEnterpriseAuthentication.pas' {EnterpriseAuthentication: CoClass},
  oAuthenticationState in 'oAuthenticationState.pas',
  LoginF in 'LoginF.pas' {frmEnterpriseLogin},
  Brand in 'W:\entrprse\FUNCS\Brand.pas',
  EntLicence in 'W:\entrprse\DRILLDN\EntLicence.pas',
  SerialU in 'W:\entrprse\MULTCOMP\SERIALU.PAS',
  EntLic in 'W:\entrprse\MULTCOMP\ENTLIC.PAS',
  Crypto in 'W:\entrprse\MULTCOMP\CRYPTO.PAS',
  LicFuncU in 'W:\SBSLIB\WIN\EXCOMMON\LICFUNCU.PAS',
  CTKUTIL in 'W:\entrprse\funcs\CTKUtil.pas',
  SecCodes in 'W:\entrprse\COMTK\SECCODES.PAS',
  IKPIHost_TLB in 'IKPIHost_TLB.pas',
  LicRec in 'W:\SBSLIB\WIN\EXCOMMON\LicRec.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
