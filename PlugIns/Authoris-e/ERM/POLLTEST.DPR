program polltest;

uses
  Forms,
  ermtest in 'ermtest.pas' {frmPollTest},
  MsgTest in 'MsgTest.pas' {frmMsg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPollTest, frmPollTest);
  Application.Run;
end.
