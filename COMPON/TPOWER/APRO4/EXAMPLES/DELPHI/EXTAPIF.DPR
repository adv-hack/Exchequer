program extapif;

uses
  Forms,
  extapif0 in 'extapif0.pas' {ExTFax};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TExTFax, ExTFax);
  Application.Run;
end.
