program VIEWFAX;

uses
  Forms,
  VIEWMAIN in 'VIEWMAIN.PAS' {MainForm},
  Wcomp in 'WCOMP.PAS' {WhitespaceCompForm},
  Percent in 'PERCENT.PAS' {PercentForm};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

