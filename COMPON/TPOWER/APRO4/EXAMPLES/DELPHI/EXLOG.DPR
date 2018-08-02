program Exlog;

uses
  Forms,
  Exlog0 in 'EXLOG0.PAS' {ExampleLog};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin                
  Application.Initialize;
  Application.CreateForm(TExampleLog, ExampleLog);
  Application.Run;
end.
