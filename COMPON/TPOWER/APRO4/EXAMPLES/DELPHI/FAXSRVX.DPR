program FaxSrvx;

uses
  Forms,
  FaxSrvx0 in 'FaxSrvx0.PAS' {fsMain},
  FaxSrvx1 in 'FaxSrvx1.PAS' {fsFaxList};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfsMain, fsMain);
  Application.CreateForm(TfsFaxList, fsFaxList);
  Application.Run;
end.
