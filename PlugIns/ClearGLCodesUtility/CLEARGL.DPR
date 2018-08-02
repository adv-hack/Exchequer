program CLEARGL;

{$ALIGN 1}  { Variable Alignment Disabled }
{$REALCOMPATIBILITY ON}

uses
  Forms,
  Windows,  
  Main in 'MAIN.PAS' {frmMain},
  Progress in 'Progress.pas' {frmProgress};

{$R *.RES}

{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
