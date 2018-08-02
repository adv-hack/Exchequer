program ENTREGX;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  Dialogs,
  Forms,
  SetupBas in '..\SETUP\SETUPBAS.PAS' {SetupTemplate},
  Entreg2u in 'Entreg2u.pas' {SetupTemplate1},
  CompUtil in '..\MULTCOMP\Computil.pas',
  LicRec in '..\..\SBSLIB\WIN\EXCOMMON\LICREC.PAS',
  EntLic in '..\MULTCOMP\ENTLIC.PAS',
  SerialU in '..\MULTCOMP\SERIALU.PAS',
  LicFuncU in '..\..\SBSLIB\WIN\EXCOMMON\LICFUNCU.PAS',
  HISTORY in 'HISTORY.pas',
  WGEConfig in '..\MULTCOMP\WGEConfig.pas',
  EntLicence in '..\DRILLDN\EntLicence.pas',
  RegCom in '..\MULTCOMP\RegCom.pas',
  HTMLHelpPath in '..\MULTCOMP\HTMLHelpPath.pas',
  FileVirtualisation in 'X:\ENTRPRSE\FUNCS\FileVirtualisation.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Component Setup';
  Application.CreateForm(TSetupTemplate1, SetupTemplate1);
  Application.Run;
end.
