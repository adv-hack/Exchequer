program ElManage;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  ElManF in 'ELMANF.PAS' {frmELManager},
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
  selfld2 in 'SELFLD2.PAS' {Form_SelectField2},
  AccountContactRoleUtil in 'w:\ENTRPRSE\R&D\AccountContacts\AccountContactRoleUtil.pas',
  ContactsManager in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManager.pas',
  oAccountContactBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactBtrieveFile.pas',
  oAccountContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactRoleBtrieveFile.pas',
  oContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oContactRoleBtrieveFile.pas',
  ContactsManagerPerv in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerPerv.pas',
  ContactsManagerSQL in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerSQL.pas',
  oOPVATPayBtrieveFile in '\Entrprse\R&D\OrderPayments\oOPVATPayBtrieveFile.pas',
  oOPPreviousVATTracker in 'W:\ENTRPRSE\FormDes2\oOPPreviousVATTracker.pas';


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
