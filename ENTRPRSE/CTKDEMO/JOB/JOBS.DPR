program Jobs;

uses
  Forms,
  JobListF in 'JobListF.pas' {frmJobList};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmJobList, frmJobList);
  Application.Run;
end.
