program EbusImp;

{$REALCOMPATIBILITY ON}

uses
  Forms,
  D6OnHelpFix,
  conHTMLHelp,
  SysUtils,
  APIUtil,
  ImpTray in 'ImpTray.pas' {frmeBisImport},
  Debugger in '..\Shared\Debugger.pas';

{$R *.RES}

begin
  Application.ShowMainForm := false;
  IsLibrary := False;
  Application.Initialize;
  Application.Title := 'Exchequer eBusiness Import Module';
  Application.HelpFile := 'Ebus.chm';
  Application.CreateForm(TfrmeBisImport, frmeBisImport);
  if not IsAppAlreadyRunning(ExtractFileName(Application.EXEName)) then
    Application.Run;
end.


