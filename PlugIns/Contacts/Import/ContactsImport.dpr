program ContactsImport;

uses
  Forms,
  Windows,
  MainForm in 'MainForm.pas' {frmMain},
  VarConst in '\Plugins\CONTACTS\DLLHOOK\Varconst.pas',
  Company in '\Plugins\CONTACTS\DLLHOOK\Company.pas',
  ContProc in '\Plugins\CONTACTS\DLLHOOK\ContProc.pas',
  DataModule in '..\DLLHOOK\DataModule.pas' {SQLDataModule: TDataModule},
  PickAcc in '..\DLLHOOK\PickAcc.pas' {frmPickAccount},
  ContSel in '..\DLLHOOK\CONTSEL.PAS' {frmSelectContact},
  ContDet in '..\DLLHOOK\CONTDET.PAS' {frmContactDetails};

{$R *.res}
{$R \Entrprse\FormDes2\WinXPMan.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}//RJ 16/02/2016 2016-R1 ABSEXCH-17247: Added PE flags release to plug-ins. 

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TSQLDataModule, SQLDataModule);
  Application.Run;
end.
