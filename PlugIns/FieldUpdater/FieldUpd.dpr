program FieldUpd;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  Forms,
  Windows,  
  ADMIN in 'ADMIN.PAS' {frmAdmin},
  FUPROC in 'FUPROC.PAS',
  AddNote in 'AddNote.pas' {frmAddNote},
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.res}
{$R \Entrprse\FormDes2\WinXPMan.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

begin
  Application.Initialize;
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.CreateForm(TfrmAddNote, frmAddNote);
  Application.Run;
end.
