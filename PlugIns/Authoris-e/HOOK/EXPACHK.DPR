program ExPaChk;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  Forms,
  comu in 'COMU.PAS' {Form1},
  test in '..\BASE\test.pas',
  pmsg in 'Pmsg.pas' {PMsgForm},
  commsg in 'commsg.pas' {frmComMsg},
  PISecure in 'X:\BESPOKE\FUNCS\PISECURE.PAS',
  PIMisc in 'X:\BESPOKE\FUNCS\PIMISC.PAS',
  appcode in 'appcode.pas' {frmAppCode};

{$R *.RES}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
