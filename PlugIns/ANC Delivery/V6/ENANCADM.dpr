program ENANCADM;

uses
  Forms,
  Windows,  
  AdminF in 'AdminF.pas' {frmAdminMain},
  DefaultF in 'DefaultF.pas' {frmDefaultDetail},
  ServiceF in 'SERVICEF.PAS' {frmServiceDetail},
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas',
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
