program TestProj;

uses
  Forms,
  UfrmTree in 'UfrmTree.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmXMLBrowse, frmXMLBrowse);
  Application.Run;
end.
