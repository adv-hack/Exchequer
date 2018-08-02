program FaxSend;
{$REALCOMPATIBILITY ON}
uses
  ShareMem,
  Forms,
  Dialogs,
  SysUtils,
  APIUtil,
  VarFPOSU in '..\..\entrprse\r&d\VarFPOSU.PAS',
  VarConst,
  FaxStat in 'FaxStat.pas' {frmFaxStatus},
  about in 'About.pas' {frmAbout},
  FaxClass in 'FaxClass.pas',
  FaxParam in 'Faxparam.pas' {frmServerParams},
  Password in '..\shared\Password.pas' {frmPassword},
  BTSupU1 in '..\shared\Btsupu1.pas',
  ModTest in 'ModTest.pas' {frmModemTest},
  PortReg in 'PortReg.pas',
    D6OnHelpFix,
    conHTMLHelp,
  ModemSelect in 'ModemSelect.pas' {frmModemSelect};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Fax Sender';
  Application.HelpFile := 'EntFax.chm';
  if IsAppAlreadyRunning(ExtractFileName(Application.EXEName))
  then MsgBox('The Fax Sender is already running, and cannot be run again.'
  ,mtInformation,[mbOK],mbOK,ExtractFileName(Application.EXEName))
  else begin
    Application.CreateForm(TfrmFaxStatus, frmFaxStatus);
  Application.CreateForm(TfrmServerParams, frmServerParams);
  Application.CreateForm(TfrmPassword, frmPassword);
  Application.CreateForm(TfrmModemTest, frmModemTest);
  Application.Run;
  end;{if}
end.
