program FaxMon;

uses
  Forms,
  FaxMon0 in 'FaxMon0.pas' {fFaxMon0};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfFaxMon0, fFaxMon0);
  Application.Run;
end.
