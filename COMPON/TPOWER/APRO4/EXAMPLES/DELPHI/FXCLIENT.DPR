program Fxclient;

uses
  Forms,
  FxClnt0 in 'FXCLNT0.PAS' {frmFaxClient0};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFaxClient0, frmFaxClient0);
  Application.Run;
end.
