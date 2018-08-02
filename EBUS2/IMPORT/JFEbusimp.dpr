program JFEbusimp;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  Forms,
  SysUtils,
  APIUtil,
  ImpTray in 'ImpTray.pas' {frmeBisImport},
  Debugger in '..\Shared\Debugger.pas';

{$R *.RES}

begin
  Application.ShowMainForm := false;
  IsLibrary := False;
  Application.Initialize;
  Application.Title := 'Exchequer eBis Import Module';
  Application.HelpFile := '';
  Application.CreateForm(TfrmeBisImport, frmeBisImport);
  if not IsAppAlreadyRunning(ExtractFileName(Application.EXEName)) then
    Application.Run;
end.


