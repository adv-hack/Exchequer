program Setup;

{$REALCOMPATIBILITY ON}

uses
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  mainf in 'mainf.pas' {frmMain},
  DiskUtil in 'X:\Entrprse\Funcs\Diskutil.pas',
  ReadLicF in 'ReadLicF.pas' {frmReadLic},
  oLicence in 'X:\Entrprse\LICENCE\Olicence.pas',
  Crypto in 'X:\Entrprse\MULTCOMP\Crypto.pas',
  WLicFile in 'WLicFile.pas',
  SerialU in 'X:\Entrprse\MULTCOMP\Serialu.pas',
  LicRec in 'X:\SBSLIB\WIN\EXCOMMON\LICREC.PAS',
  IssueU in 'ISSUEU.PAS',
  StrUtil in 'X:\Entrprse\FUNCS\STRUTIL.PAS',
  History in 'History.pas';

{$R *.RES}
{$R WINXPMAN.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer CD ROM';
  Application.HelpFile := 'SETUP.CHM';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
