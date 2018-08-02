program DBUpdate;

uses
  Forms,
  uDBUpdate in 'uDBUpdate.pas' {frmDBUpdate};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmDBUpdate, frmDBUpdate);
  Application.Run;
end.
