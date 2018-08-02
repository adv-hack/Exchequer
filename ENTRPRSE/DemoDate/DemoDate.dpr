program DemoDate;
{$REALCOMPATIBILITY ON}

{$ALIGN 1}
uses
  Forms,
  Dialogs,
  ddmain in 'ddmain.pas' {frmMain},
  ddobjs in 'ddobjs.pas',
  ddLog in 'ddLog.pas',
  Previnst2 in '..\SENTMAIL\SENTINEL\Previnst2.pas',
  oGenericBtrieveFile in 'X:\ENTRPRSE\Conversion\v600 Converter\oGenericBtrieveFile.pas',
  oBtrieveFile in 'X:\ENTRPRSE\Conversion\v600 Converter\oBtrieveFile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Demo Data Date Updater';
  if AppIsRunning(False) then
  begin
    ShowMessage('This program is already running');
    Exit;
  end;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
