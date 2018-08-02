program Extrig;

uses
  Forms,
  Extrig0 in 'EXTRIG0.PAS' {ExTrigTest};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TExTrigTest, ExTrigTest);
  Application.Run;
end.
