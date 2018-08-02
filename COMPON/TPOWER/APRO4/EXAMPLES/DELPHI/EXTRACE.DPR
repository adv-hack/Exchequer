program Extrace;

uses
  Forms,
  Extrace0 in 'EXTRACE0.PAS' {ExampleTrace};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TExampleTrace, ExampleTrace);
  Application.Run;
end.
