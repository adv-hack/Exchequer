program E365Demo;

uses
  Forms,
  DemoF in 'DemoF.pas' {frmDemo},
  E365UtilIntf in '..\Common\E365UtilIntf.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'E365Util Demo';
  Application.CreateForm(TfrmDemo, frmDemo);
  Application.Run;
end.
