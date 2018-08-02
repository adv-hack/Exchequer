program DBUtility;

uses
  Forms,
  uDBUtility in 'uDBUtility.pas' {frmDbUtility};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmDbUtility, frmDbUtility);
  Application.Run;
end.
