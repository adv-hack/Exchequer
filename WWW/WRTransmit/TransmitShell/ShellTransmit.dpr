program ShellTransmit;

uses
  Forms,
  uMain in 'uMain.pas' {frmShellTest};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'WRTransmit Shell';
  Application.CreateForm(TfrmShellTest, frmShellTest);
  Application.Run;
end.
