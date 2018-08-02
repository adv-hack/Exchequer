program CAAdmin;

{$REALCOMPATIBILITY ON}

uses
  Forms,
  Windows,
  AdmnForm in 'AdmnForm.pas' {frmCAAdmin},
  AllocVar in 'AllocVar.pas',
  AllcBase in 'AllcBase.pas',
  LineForm in 'LineForm.pas' {frmLine},
  ccLook in 'ccLook.pas' {frmCCLookup},
  DataModule in 'DataModule.pas' {SQLDataModule: TDataModule};

{$R *.res}
{$R \Entrprse\FormDes2\WinXPMan.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/04/2016 : : Adding PE flags release to plug-ins.  

begin
  Application.Initialize;
  Application.CreateForm(TfrmCAAdmin, frmCAAdmin);
  Application.Run;
end.
