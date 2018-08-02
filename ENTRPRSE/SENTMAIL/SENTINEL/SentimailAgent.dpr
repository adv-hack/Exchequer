program SentimailAgent;

uses
//  Sharemem,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  SentU,
  ElVar,
  SysUtils,
  Dialogs,
  VarFPOSU in 'x:\ENTRPRSE\VRW\Common\VARFPOSU.PAS',
  GlobalTypes in '..\..\VRW\Common\GlobalTypes.pas',
  SentimailAgentClass in 'SentimailAgentClass.pas',
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
  function CheckParameters : Boolean;
  begin
    Result := ParamCount > 4;
    if Result and (TSentinelPurpose(StrToInt(ParamStr(5))) = spVisualReport) then
      Result := ParamCount = 6;
  end;

begin
  Application.Initialize;
  Application.Title := 'Sentimail Agent';


  if CheckParameters then //If not correct no of parameters then don't do anything.
  with TSentimailAgent.Create do
  Try
    DataPath := ParamStr(1);
    StartId := ParamStr(2);
    SentinelCode := ParamStr(3);
    UserId := ParamStr(4);
    Purpose := TSentinelPurpose(StrToInt(ParamStr(5)));
    ReportName := ParamStr(6);

    Execute;
  Finally
    Free;
  End;

  Application.Run;
end.
