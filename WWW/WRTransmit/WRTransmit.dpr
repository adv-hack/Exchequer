program WRTransmit;

uses
  Forms,
  uWRTransmit in 'uWRTransmit.pas' {frmClient: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'WRTransmit';
  Application.CreateForm(TfrmClient, frmClient);
  Application.Run;
end.
