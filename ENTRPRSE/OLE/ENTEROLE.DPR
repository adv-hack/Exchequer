program enterole;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  D6OnHelpFix,
  conHTMLHelp,
  Dialogs,
  Forms,
  PrevInst in 'PrevInst.pas',
  oleservr in 'Oleservr.pas',
  entservf in 'ENTSERVF.pas' {Form_EnterpriseOleServer},
  GlobVar in '..\R&D\Globvar.pas',
  VarConst in '..\MULTCOMP\Varconst.pas',
  BtrListO in 'BtrListO.pas',
  CompInfO in 'CompInfO.pas',
  SysU2 in '..\R&D\SYSU2.PAS',
  OleStatU in 'Olestatu.pas',
  Btrvu2 in '..\..\SBSLIB\WIN\WIN32\Btrvu2.pas',
  LoginWar in 'LOGINWAR.PAS' {Form_LogonWarn},
  OLEProgr in 'OLEPROGR.PAS' {frmOLEProgress},
  SalePric in 'SalePric.pas',
  OLEBtrO in 'OLEBtrO.pas',
  Crypto in '..\MULTCOMP\Crypto.pas',
  MemMap in 'MEMMAP.PAS',
  History in 'HISTORY.PAS',
  EntLicence in '..\DRILLDN\EntLicence.pas',
  AppsVals in 'AppsVals.pas',
  ValidateVAT in 'ValidateVAT.pas',
  SQLCallerU in '..\..\Entrprse\Funcs\SQLCallerU.pas',
  SQLRep_Config in '..\..\ENTRPRSE\R&D\SQLRep_Config.Pas',

  // Exchequer 2016-R1 Intrastat mods
  IntrastatXML in '\Entrprse\R&D\Intrastat\IntrastatXML.pas',

  // GDPR
  GDPRConst in '\Entrprse\R&D\GDPR\GDPRConst.pas',

  MemoryMap in 'Exch365\Common\MemoryMap.pas';


{$R *.RES}
{$R \Entrprse\FormDes2\WinXPMan.Res}

begin
  Application.Initialize;
  Application.Title := 'OLE Server';
  Application.HelpFile := 'EnterOle.Chm';
  Application.CreateForm(TForm_EnterpriseOleServer, Form_EnterpriseOleServer);
  Application.Run;
end.
