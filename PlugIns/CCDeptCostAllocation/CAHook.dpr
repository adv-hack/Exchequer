library CAHook;

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
  Sharemem,
  Windows,
  CustWinU in 'x:\Entrprse\R&D\Custwinu.pas',
  CustAbsU in 'x:\Entrprse\R&D\Custabsu.pas',
  HANDLERU in 'HANDLERU.PAS',
  Entmenuu in 'x:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  LABELU in 'LABELU.PAS',
  ChainU in 'x:\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS',
  Select in 'Select.pas' {frmAllocSelect},
  AllcBase in 'AllcBase.pas',
  AllocVar in 'AllocVar.pas',
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas', 
  DataModule in 'DataModule.pas' {SQLDataModule: TDataModule};

{$R *.RES}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/04/2016 : : Adding PE flags release to plug-ins.  

Exports
  CustomMenus,
  CloseCustomMenus,
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,
  EntDoCustomText,
  EntGetCustomText;
end.
