program FaxClnt;
{$REALCOMPATIBILITY ON}
uses
  ShareMem,
  Forms,
  Windows,
  SysUtils,
  Dialogs,
  APIUtil,
  FileUtil,
  VarFPOSU in '..\..\entrprse\r&d\VarFPOSU.PAS',
  VarConst,
  FaxCForm in 'FaxCForm.pas' {frmFaxClient},
  BTSupU1 in '..\shared\Btsupu1.pas',
  about in 'About.pas' {frmAbout},
  FaxUtils in '..\shared\FaxUtils.pas',
  UFaxBtrv in '..\shared\Ufaxbtrv.pas',
  OoMisc in 'X:\COMPON\TPOWER\APRO4\OOMISC.PAS';

{$R *.RES}

begin
  Application.ShowMainForm := false;
  IsLibrary := False;
  Application.Title := 'Exchequer Fax Client';
  Application.HelpFile := 'EntFax.HLP';
  if not IsAppAlreadyRunning(ExtractFileName(Application.EXEName))then begin
    SetPipename;
    Application.CreateForm(TfrmFaxClient, frmFaxClient);
  Application.Run;
  end;{if}
end.


