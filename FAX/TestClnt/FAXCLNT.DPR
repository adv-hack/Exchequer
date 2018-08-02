program FaxClnt;
{$REALCOMPATIBILITY ON}
uses
  ShareMem,
  RunFirst in 'x:\FAX\TESTCLNT\RUNFIRST.PAS',
  Forms,
  Windows,
  SysUtils,
  Dialogs,
  APIUtil,
  VarFPOSU in '..\..\entrprse\r&d\VarFPOSU.PAS',
  VarConst,
  FaxCForm in 'FaxCForm.pas' {frmFaxClient},
  UFaxBtrv in '..\shared\Ufaxbtrv.pas';

{$R *.RES}

begin
  Application.ShowMainForm := false;
  IsLibrary := False;
  Application.Title := 'Exchequer Fax Client';
  Application.HelpFile := 'EntFax.HLP';
  if not IsAppAlreadyRunning(ExtractFileName(Application.EXEName))then begin
    Application.CreateForm(TfrmFaxClient, frmFaxClient);
  Application.Run;
  end;{if}
end.


