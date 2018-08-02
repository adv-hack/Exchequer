program DemoUtility;

uses
  Forms,
  uDemoUtility in 'uDemoUtility.pas' {frmDemoUtility};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmDemoUtility, frmDemoUtility);
  Application.Run;
end.
