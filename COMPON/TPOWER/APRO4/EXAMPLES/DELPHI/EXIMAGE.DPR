program Eximage;

uses
  Forms,
  Eximage0 in 'EXIMAGE0.PAS' {MainForm};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin               
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

