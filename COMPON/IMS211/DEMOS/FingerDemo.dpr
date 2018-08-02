program FingerDemo;

uses
  Forms,
  FingerDemoMain in 'FingerDemoMain.pas' {FingerForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFingerForm, FingerForm);
  Application.Run;
end.
