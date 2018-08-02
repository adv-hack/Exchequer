program FaxClnt;
{$REALCOMPATIBILITY ON}
uses
  ShareMem,
  Forms,
  Windows,
  SysUtils,
  Dialogs,
  APIUtil,
  VarFPOSU in '..\..\entrprse\r&d\VarFPOSU.PAS',
  VarConst,
  FaxCForm in 'FaxCForm.pas' {frmFaxClient},
  BTSupU1 in '..\shared\Btsupu1.pas',
  about in 'About.pas' {frmAbout},
  FaxUtils in '..\shared\FaxUtils.pas',
  UFaxBtrv in '..\shared\Ufaxbtrv.pas',
  ActiveX,
    D6OnHelpFix,
    conHTMLHelp,
  SQLUtils in 'X:\ENTRPRSE\FUNCS\SQLUtils.pas';

{$R *.RES}

begin
  Application.ShowMainForm := false;
  IsLibrary := False;
  Application.Title := 'Exchequer Fax Client';
  Application.HelpFile := 'EntFax.chm';
  if not IsAppAlreadyRunning(ExtractFileName(Application.EXEName))then begin
    CoInitialize(nil);
    Application.CreateForm(TfrmFaxClient, frmFaxClient);
  Application.Run;
  end;{if}
end.


