program SENTINEL;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  Previnst2 in 'Previnst2.pas',
  ChkPrntr,
  VAOUtil,
  ElVar,
  SdiMainf in 'SdiMainf.pas' {frmEngine},
  VarFPOSU in 'x:\ENTRPRSE\VRW\Common\VARFPOSU.PAS',
  GlobalTypes in '..\..\VRW\Common\GlobalTypes.pas',
  Trayf in 'TRAYF.PAS' {frmElertTray},
  AgentList in 'AgentList.pas',
  AccountContactRoleUtil in 'w:\ENTRPRSE\R&D\AccountContacts\AccountContactRoleUtil.pas',
  ContactsManager in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManager.pas',
  oAccountContactBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactBtrieveFile.pas',
  oAccountContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oAccountContactRoleBtrieveFile.pas',
  oContactRoleBtrieveFile in 'w:\ENTRPRSE\R&D\AccountContacts\oContactRoleBtrieveFile.pas',
  ContactsManagerPerv in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerPerv.pas',
  ContactsManagerSQL in 'w:\ENTRPRSE\R&D\AccountContacts\ContactsManagerSQL.pas',
  oOPVATPayBtrieveFile in '\Entrprse\R&D\OrderPayments\oOPVATPayBtrieveFile.pas'
  ;

{$R *.res}


begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.Title := 'Sentimail Monitor';
  Application.HelpFile := 'Sentmail.chm';
  if AppIsRunning(False) and (VAOInfo.vaoMode <> smVAO) then EXIT;
  if CheckLicenceOK and CheckPrintersOK then
  begin
    Application.CreateForm(TfrmEngine, frmEngine);
  Application.CreateForm(TfrmElertTray, frmElertTray);
  Application.Run;
  end
  else
    Application.Terminate;
end.
