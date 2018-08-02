program AutoSett;

uses
  Forms,
  Windows,  
  mainform in 'mainform.pas' {frmMainForm},
  Enterprise01_TLB in '..\..\ENTRPRSE\COMTK\Enterprise01_TLB.pas';

{$R *.res}

{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.Title := 'Auto Settle Plug-in.';
  Application.CreateForm(TfrmMainForm, frmMainForm);
  Application.Run;
end.
