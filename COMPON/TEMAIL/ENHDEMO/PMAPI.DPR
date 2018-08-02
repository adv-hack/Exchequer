program Pmapi;

uses
  Forms,
  Umapi in 'UMAPI.PAS' {MainForm};

{$R *.RES}

begin
{$IFDEF WIN32}
  Application.Initialize;
{$ENDIF WIN32}
  Application.Title := 'TEmail Enhanced Demo Application';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
