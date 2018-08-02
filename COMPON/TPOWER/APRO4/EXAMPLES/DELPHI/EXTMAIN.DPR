program Extmain;

uses
  Forms,
  Extmain0 in 'EXTMAIN0.PAS' {EXTMainForm};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TEXTMainForm, EXTMainForm);
  Application.Run;
end.
