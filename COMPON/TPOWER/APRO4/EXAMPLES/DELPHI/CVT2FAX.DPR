program Cvt2fax;

uses
  WinTypes,
  WinProcs,
  Forms,
  CVTMAIN in 'CVTMAIN.PAS' {CvtMainForm},
  Cvtopt in 'CVTOPT.PAS' {CvtOptionsForm},
  Cvtprog in 'CVTPROG.PAS' {CvtProgressForm};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}


{$R EXICON.RES}

begin
  SetErrorMode(SEM_FAILCRITICALERRORS);
  Application.Initialize;
  Application.CreateForm(TCvtMainForm, CvtMainForm);
  Application.CreateForm(TCvtProgressForm, CvtProgressForm);
  Application.CreateForm(TCvtOptionsForm, CvtOptionsForm);
  Application.Run;
end.
