program entVwLic;

{$REALCOMPATIBILITY ON}

uses
  Forms,
  oLicence in 'Olicence.pas',
  ViewLicF in 'ViewLicF.pas' {frmViewLicence},
  Crypto in '..\MULTCOMP\Crypto.pas',
  SerialU in '..\MULTCOMP\Serialu.pas',
  LicRec in '..\..\SBSLIB\WIN\EXCOMMON\LICREC.PAS',
  LicFuncU in '..\..\SBSLIB\WIN\EXCOMMON\LICFUNCU.PAS',
  StrUtil in 'X:\ENTRPRSE\FUNCS\STRUTIL.PAS',
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Licence Viewer';
  Application.CreateForm(TfrmViewLicence, frmViewLicence);
  Application.Run;
end.
