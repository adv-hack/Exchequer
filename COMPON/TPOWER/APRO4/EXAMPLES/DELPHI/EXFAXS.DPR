program Exfaxs;

uses
  Forms,
  EXFAXS0 in 'EXFAXS0.PAS' {Form1};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin        
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
