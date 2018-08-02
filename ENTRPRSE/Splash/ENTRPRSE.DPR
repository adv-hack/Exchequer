program Entrprse;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  SysUtils,
  Windows,
  SplashF in 'SplashF.pas' {EnterSplash},
  DiskUtil in '..\FUNCS\Diskutil.pas',
  SetupBas in '..\SETUP\SETUPBAS.PAS' {SetupTemplate},
  spfixReg in 'spfixReg.pas' {frmWSConfig},
  CompUtil in '..\MULTCOMP\CompUtil.pas',
  EntLic in '..\MULTCOMP\ENTLIC.PAS',
  LicRec in '..\..\SBSLIB\WIN\EXCOMMON\LICREC.PAS',
  CheckPrinterF in 'CheckPrinterF.pas' {frmInvalidPrinter},
  VAOUtil in '..\FUNCS\VAOUtil.pas',
  EntLicence in '..\DRILLDN\EntLicence.pas',
  LicFuncU in '..\..\SBSLIB\WIN\EXCOMMON\LicFuncU.pas',
  SerialU in '..\MULTCOMP\SERIALU.PAS',
  Crypto in '..\MULTCOMP\CRYPTO.PAS',
  FileVirtualisation in 'X:\ENTRPRSE\FUNCS\FileVirtualisation.pas',
  CheckForExchComponents in 'CheckForExchComponents.pas';

{$R *.RES}
{$R EntrprXP.Res}

begin
  Application.Initialize;
  Application.Title := 'Exchequer';
  Application.HelpFile := 'MCM.CHM';
  Application.CreateForm(TEnterSplash, EnterSplash);
  Application.Run;
end.
