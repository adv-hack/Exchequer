program UserHAdm;

uses
  D6OnHelpFix,
  conHTMLHelp,
  Windows,
  Forms,
  MainF in 'MainF.pas' {frmUserDefList},
  DetailF in 'DETAILF.PAS' {frmDetails},
  UDefProc in '..\COMMON\UDefProc.pas',
  DateForm in 'DateForm.pas' {frmDateFormat},
  VarConst in '..\COMMON\VARCONST.PAS',
  BTProc in '..\COMMON\BTProc.pas',
  EntLicence in 'x:\ENTRPRSE\DRILLDN\EntLicence.pas',
  DataModule in '..\COMMON\DataModule.pas' {SQLDataModule: TDataModule},
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.RES}
{$R \Entrprse\FormDes2\WinXPMan.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP} //RJ 17/02/2016 2016-R1 ABSEXCH-17247: Adding PE flags release to plug-ins.

begin
  Application.Initialize;
  Application.Title := 'User Field Plug-In Configuration';
  Application.HelpFile := 'USERDEF.CHM';
  Application.CreateForm(TfrmUserDefList, frmUserDefList);
  Application.Run;
end.
