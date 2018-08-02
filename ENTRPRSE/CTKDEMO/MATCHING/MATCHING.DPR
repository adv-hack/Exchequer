program Matching;

uses
  Forms,
  MatchF in 'MatchF.pas' {frmMatchDemo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMatchDemo, frmMatchDemo);
  Application.Run;
end.
