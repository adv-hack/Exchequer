program CDGenrat;

{$REALCOMPATIBILITY ON}

uses
  Forms,
  lwCust in 'lwCust.pas' {frmLicWiz8},
  lwSerial in 'lwSerial.pas' {frmLicWiz6},
  MainF in 'MainF.pas' {frmMain},
  lwModule in 'lwModule.pas' {frmLicWiz4},
  WriteLic in 'WriteLic.pas',
  LWWorkg in 'LWWorkg.PAS' {frmLicWorkgroup},
  DiskUtil in '..\FUNCS\Diskutil.pas',
  lwEntVer in 'lwEntVer.pas' {frmLicWiz2},
  oLicence in 'oLicence.pas',
  Crypto in '..\MULTCOMP\Crypto.pas',
  lwType in 'lwType.pas' {frmLicWiz1},
  SerialU in '..\MULTCOMP\Serialu.pas',
  lwOption in 'lwOption.pas' {frmLicWizOptions},
  RSyncU in '..\MULTCOMP\Rsyncu.pas',
  LicRec in '..\..\SBSLIB\WIN\EXCOMMON\LicRec.pas',
  LicVar in 'LicVar.PAS',
  LicFuncU in '..\..\SBSLIB\WIN\EXCOMMON\LicFuncU.pas',
  ESNImpU in 'ESNImpU.pas',
  APIUtil in '..\FUNCS\APIUTIL.PAS',
  lwConfrm in 'LWCONFRM.PAS' {frmLicWiz5},
  LWMODDET in 'LWMODDET.pas' {frmModSettings},
  ESNPW in 'ESNPW.pas' {frmESNPasswords},
  Phonetic in '..\FUNCS\PHONETIC.PAS',
  StrUtil in '..\FUNCS\STRUTIL.PAS',
  History in 'History.pas',
  lwClSvr in 'LWCLSVR.PAS' {frmLicWiz7};

{$R *.RES}
{$R x:\entrprse\formdes2\winxpman.res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer v7.x CD Licence Generator';
  Application.HelpFile := 'CDGEN.HLP';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
