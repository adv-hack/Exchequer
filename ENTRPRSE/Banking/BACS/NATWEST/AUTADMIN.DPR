program AutAdmin;

uses
  Forms,
  Windows,  
  ConfigF in 'w:\entrprse\banking\GENERAL\CONFIGF.pas' {frmBacsConfig},
  auconfig in 'auconfig.pas' {frmAutopayConfig};

{$R *.res}

{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.CreateForm(TfrmAutopayConfig, frmAutopayConfig);
  Application.Run;
end.
