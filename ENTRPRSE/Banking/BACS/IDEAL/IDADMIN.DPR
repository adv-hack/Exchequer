program IDAdmin;

uses
  Forms,
  Windows,  
  ConfigF in 'w:\Entrprse\Banking\GENERAL\CONFIGF.pas' {frmBacsConfig},
  idconfig in 'idconfig.pas' {frmIdealConfig};

{$R *.res}

{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.CreateForm(TfrmIdealConfig, frmIdealConfig);
  Application.Run;
end.
