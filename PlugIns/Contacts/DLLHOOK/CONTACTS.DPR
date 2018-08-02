library Contacts;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  SysUtils,
  Classes,
  Windows,
  handleru in 'handleru.pas',
  LabelU in 'LabelU.Pas',
  Company in 'Company.pas',
  ContDet in 'CONTDET.PAS' {frmContactDetails},
  ContSel in 'CONTSEL.PAS' {frmSelectContact},
  VarConst in 'Varconst.pas',
  ContProc in 'ContProc.pas',
  EntMenuU in 'x:\ENTRPRSE\CUSTOM\DUMMY\ENTMENUU.PAS',
  EntLicence in 'x:\ENTRPRSE\DRILLDN\EntLicence.pas',
  ChainU in 'x:\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS',
  PickAcc in 'PickAcc.pas' {frmPickAccount},
  DataModule in 'DataModule.pas' {SQLDataModule: TDataModule},
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.RES}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP} //RJ 17/02/2016 2016-R1 ABSEXCH-17247: Adding PE flags release to plug-ins.

Exports
  { HandlerU.Pas }
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,

  { LabelU.Pas }
  EntDoCustomText,
  EntGetCustomText,

  { EntMenuU.Pas }
  CustomMenus,
  CloseCustomMenus,

  ShowContactAdmin;

end.
