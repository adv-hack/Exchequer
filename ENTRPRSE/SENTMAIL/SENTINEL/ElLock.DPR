program ElLock;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  LockELMANF in 'LockELMANF.PAS' {frmELManager},
  elRepDel in 'elRepDel.pas' {frmRepDelivery},
  debuglog in 'debuglog.pas',
  thingU in 'thingU.pas',
  Sentu in 'Sentu.pas',
  SentEx1u in 'SentEx1u.pas',
  smsedit in 'smsedit.pas' {frmEditSMS},
  testu in 'testu.pas' {frmTestOutput},
  emailed in 'emailed.pas' {frmEmailEdit},
  linedbug in 'linedbug.pas' {frmLineDebug},
  KeyForm in 'KeyForm.pas' {frmEventKey},
  RepFNO1U in 'REPFNO1U.PAS',
  selectf in 'selectf.pas' {frmSelectSent},
  paramf in 'paramf.pas' {frmParams},
  StypeF in 'StypeF.pas' {Form1},
  DatePick in 'DatePick.pas' {frmDatePick},
  newfold in 'newfold.pas' {frmNewFolder},
  elVar,
  enginef in 'enginef.pas' {frmEngines},
  REPPASS in 'REPPASS.PAS' {frmRepPass},
  PurgeOpt in 'PurgeOpt.pas' {frmPurgeOpts},
  addrec in 'addrec.pas' {frmAddRecs},
  selfld2 in 'SELFLD2.PAS' {Form_SelectField2};

{$R *.RES}
{$R '..\bitmaps\sentpics.res'}
{$R ElManxp.res}

begin
  Application.Initialize;
  Application.Title := 'Sentimail Sentinel Manager';
  Application.HelpFile := 'SentMail.chm';
  if CheckLicenceOK then
  begin
    Application.CreateForm(TfrmELManager, frmELManager);
  Application.CreateForm(TfrmSelectSent, frmSelectSent);
  Application.CreateForm(TfrmParams, frmParams);
  Application.CreateForm(TForm_SelectField2, Form_SelectField2);
  Application.Run;
  end
  else
    Application.Terminate;
end.
