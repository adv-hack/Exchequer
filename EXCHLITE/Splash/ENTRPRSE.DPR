program Entrprse;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  Forms,
  SysUtils,
  Windows,
  SplashF in 'SplashF.pas' {EnterSplash},
  DiskUtil in '..\..\ENTRPRSE\RIGHTS\Diskutil.pas',
  SETUPBAS in 'SETUPBAS.PAS' {SetupTemplate},
  spfixReg in '..\..\ENTRPRSE\MULTCOMP\spfixReg.pas' {frmWSConfig},
  CompUtil in '..\..\ENTRPRSE\MULTCOMP\CompUtil.pas',
  CDVerU in '..\..\ENTRPRSE\SETUP\Cdveru.pas',
  EntLic in '..\..\ENTRPRSE\MULTCOMP\ENTLIC.PAS',
  LicRec in '..\..\SBSLIB\WIN\EXCOMMON\LICREC.PAS',
  ChkPrntr in '..\..\ENTRPRSE\MULTCOMP\ChkPrntr.pas' {frmInvalidPrinter},
  VAOUtil in '..\..\ENTRPRSE\FUNCS\VAOUtil.pas',
  Brand in '..\..\ENTRPRSE\FUNCS\Brand.pas',
  OSChecks in 'X:\EXCHLITE\CD\OSChecks.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'IRIS Accounts Office';
  Application.HelpFile := 'MCM.HLP';
  Application.CreateForm(TEnterSplash, EnterSplash);
  Application.Run;
end.
