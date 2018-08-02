program Extcap;

uses
  Forms,
  Extcap0 in 'EXTCAP0.PAS' {ExtCapExample};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TExtCapExample, ExtCapExample);
  Application.Run;
end.
