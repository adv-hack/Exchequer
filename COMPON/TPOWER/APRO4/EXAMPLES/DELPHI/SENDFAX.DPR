program SendFax;

uses
  Forms,
  Sendfax0 in 'SENDFAX0.PAS' {sfMain},
  Sendfax1 in 'SENDFAX1.PAS' {sfFaxList};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TsfMain, sfMain);
  Application.CreateForm(TsfFaxList, sfFaxList);
  Application.Run;
end.
