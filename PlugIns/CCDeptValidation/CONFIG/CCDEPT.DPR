program CCDept;

uses
  Forms,
  Windows,
  Main in 'MAIN.PAS' {frmMain},
  AddEdit in 'AddEdit.pas' {frmAddEdit},
  Test in 'Test.pas' {frmTest},
  CopyComp in 'CopyComp.pas' {frmCopy},
  AddGLCod in 'AddGLCod.pas' {FrmAddGLCode},
  CCDeptU in '..\COMMON\CCDEPTU.PAS',
  CopyGl in 'CopyGl.pas' {frmCopyGLCode},
  BTFile in '..\COMMON\BTFile.PAS',
  SystemSetup in 'SystemSetup.pas' {FrmSystemSetup},
  Import in 'Import.pas',
  DataModule in '..\COMMON\DataModule.pas' {SQLDataModule: TDataModule},
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.RES}
{$R \Entrprse\FormDes2\WinXPMan.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP} //RJ 17/02/2016 2016-R1 ABSEXCH-17247: Adding PE flags release to plug-ins.

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmTest, frmTest);
  Application.CreateForm(TFrmSystemSetup, FrmSystemSetup);
  Application.Run;
end.
