program Fxsrvr;

uses
  Forms,
  FxSrvr0 in 'FXSRVR0.PAS' {frmFxSrv0};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFxSrv0, frmFxSrv0);
  Application.Run;
end.
