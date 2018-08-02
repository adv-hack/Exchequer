program TimeDemo;

uses
  Forms,
  TimeMain in 'TimeMain.pas' {TimeForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TTimeForm, TimeForm);
  Application.Run;
end.
