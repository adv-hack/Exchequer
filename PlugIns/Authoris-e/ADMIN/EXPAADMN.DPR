program EXPAADMN;

{$REALCOMPATIBILITY ON}

uses
  shareMem,
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  admnform in 'ADMNFORM.PAS' {frmAuthAdmin},
  pword in 'pword.pas' {frmAdminPassword},
  AuthSlct in '..\HOOK\AuthSlct.pas' {frmSelectAuth},
  TreeSet in 'TreeSet.pas',
  FindReq in 'FindReq.pas' {frmFindReq};

{$R *.RES}
{$R PaAdmnXP.res}

begin
  Application.Initialize;
  Application.HelpFile := 'authoris.chm';
  Application.Title := 'Authoris-e administration';
  Application.CreateForm(TfrmAuthAdmin, frmAuthAdmin);
  Application.Run;
end.
