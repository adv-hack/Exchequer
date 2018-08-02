program SentServ;

{$REALCOMPATIBILITY ON}

uses
  Sharemem,
  SvcMgr,
  Servmn1 in 'Servmn1.pas' {SentimailService: TService},
  SysUtils,
  Localu in 'Localu.pas',
  VarFPOSU in '..\..\VRW\Common\VARFPOSU.PAS',
  SdiMainf in 'SdiMainf.pas' {frmEngine},
  AccountContactRoleUtil in 'w:\ENTRPRSE\R&D\AccountContacts\AccountContactRoleUtil.pas',
  ContactsManager in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManager.pas',
  oAccountContactBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactBtrieveFile.pas',
  oAccountContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactRoleBtrieveFile.pas',
  oContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oContactRoleBtrieveFile.pas',
  ContactsManagerPerv in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerPerv.pas',
  ContactsManagerSQL in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerSQL.pas',
  oOPVATPayBtrieveFile in '\Entrprse\R&D\OrderPayments\oOPVATPayBtrieveFile.pas'
;

{$R *.RES}

{$R ARROWS.RES}
var
  sParam : string;
  Res : Integer;

begin
  Application.Initialize;
  Application.Title := 'Sentimail Service';
  Application.CreateForm(TSentimailService, SentimailService);
  sParam := UpperCase(ParamStr(1));
  if (sParam <> '/INSTALL') and (sParam <> '/UNINSTALL') then
  begin
     //PR: 13/12/2013 ABSEXCH-14844 Map drive before creating the main Sentimail form
     MapDriveFromIniFile;
     Application.CreateForm(TfrmEngine, frmEngine);
  end;
  Application.Run;
end.
