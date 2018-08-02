program Exmdi;

uses
  Forms,
  Exmdi0 in 'EXMDI0.PAS' {EXMDIF0},
  Exmdi1 in 'EXMDI1.PAS' {EXMDIF1},
  Exmdi2 in 'EXMDI2.PAS' {EXMDIF2};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin      
  Application.Initialize;
  Application.CreateForm(TEXMDIF0, EXMDIF0);
  Application.CreateForm(TEXMDIF1, EXMDIF1);
  Application.CreateForm(TEXMDIF2, EXMDIF2);
  Application.Run;
end.
