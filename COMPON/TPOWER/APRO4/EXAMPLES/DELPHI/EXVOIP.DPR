program exVoIP;

uses
  Forms,
  ExVoIP0 in 'ExVoIP0.pas' {frmExVoIP};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmExVoIP, frmExVoIP);
  Application.Run;
end.
