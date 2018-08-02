program ExPaErm;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
//  MemCheck,
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  SysUtils,
  APIUtil,
  Trayform in 'TRAYFORM.PAS' {frmeEARTray},
  About in '..\BASE\About.pas' {frmAbout};

{$R *.RES}
{$R PAERMXP.RES}

begin
//  MemChk;
  Application.ShowMainForm := false;
  IsLibrary := False;
  Application.Initialize;
  Application.Title := 'Exchequer Authoris-e EAR Monitor';
  Application.HelpFile := 'authoris.chm';
  Application.CreateForm(TfrmeEARTray, frmeEARTray);
  if not IsAppAlreadyRunning(ExtractFileName(Application.EXEName)) then
    Application.Run;
end.
