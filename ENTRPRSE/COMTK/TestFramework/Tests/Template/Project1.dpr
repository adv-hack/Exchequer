program Project1;

uses
  Forms,
  TestFormTemplate in 'TestFormTemplate.pas' {frmTestTemplate};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTestTemplate, frmTestTemplate);
  Application.Run;
end.
