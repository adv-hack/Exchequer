program Thrdtest;

uses
  Forms,
  thread1 in 'THREAD1.PAS' {frmThreadMaster},
  ExTHSu1U in 'EXTHSU1U.PAS' {ProgTForm},
  ExThrd2U in 'EXTHRD2U.PAS',
  elThred in 'elThred.pas',
  status in 'status.pas' {frmStatus};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmThreadMaster, frmThreadMaster);
  Application.CreateForm(TfrmStatus, frmStatus);
  Application.Run;
end.
