program faxadmin;
{$REALCOMPATIBILITY ON}
uses
  Forms,
  Main in 'MAIN.PAS' {frmMain},
  about in 'about.pas' {frmAbout},
  FaxStat in 'Faxstat.pas' {frmFaxStatus},
  VarFPOSU in '..\..\entrprse\r&d\VarFPOSU.PAS',
  VarConst in '..\shared\VarConst.pas',
  FaxClass in 'Faxclass.pas',
  UFaxBtrv in '..\shared\Ufaxbtrv.pas',
  FaxUtils in '..\shared\Faxutils.pas',
  ViewMain in 'ViewMain.pas' {frmViewFax},
  ChangeNo in 'ChangeNo.pas' {frmChangeNo},
  Password in '..\shared\Password.pas' {frmPassword},
  BTSupU1 in '..\shared\Btsupu1.pas',
  UserList in 'UserList.pas' {frmUserList},
  UserDet in 'Userdet.pas' {frmUserDetails},
  ClntUser in 'ClntUser.pas' {frmClientLoginList},
  D6OnHelpFix,
  conHTMLHelp,
  Crypto in 'x:\ENTRPRSE\MULTCOMP\CRYPTO.PAS',
  GfxUtil in 'X:\ENTRPRSE\FUNCS\GFXUTIL.PAS';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Fax Administrator';
  Application.HelpFile := 'EntFax.Chm';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
