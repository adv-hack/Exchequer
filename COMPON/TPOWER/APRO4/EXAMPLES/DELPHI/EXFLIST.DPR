program ExFList;

uses
  Forms,
  EXFLIST0 in 'EXFLIST0.PAS' {ExampleFList};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin          
  Application.Initialize;
  Application.CreateForm(TExampleFList, ExampleFList);
  Application.Run;
end.
