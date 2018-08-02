program ENANCADM;

uses
  Forms,
  Windows,  
  AdminF in 'AdminF.pas' {frmAdminMain},
  DefaultF in 'DefaultF.pas' {frmDefaultDetail},
  Contkey in 'W:\ENTRPRSE\LICENCE\DistRel\CONTKEY.PAS',
  ServiceF in 'SERVICEF.PAS' {frmServiceDetail},
  VerInfo in 'VerInfo.pas';

{$R *.res}

{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.Title := 'Exchequer ANC Delivery Link Administrator';
  Application.CreateForm(TfrmAdminMain, frmAdminMain);
  Application.Run;
end.
