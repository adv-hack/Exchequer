program AibAdmin;

uses
  Forms,
  Windows,
  ConfigF in '..\..\GENERAL\CONFIGF.PAS' {frmBacsConfig},
  AIBCONFG in 'AIBCONFG.PAS' {frmAibConfig};

{$R *.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.CreateForm(TfrmAibConfig, frmAibConfig);
  Application.Run;
end.
