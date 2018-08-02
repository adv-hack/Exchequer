library EntUserF;

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
  SysUtils,
  Windows,
  Classes,
  Handleru in 'HANDLERU.PAS',
  EntMenuU in 'x:\ENTRPRSE\CUSTOM\DUMMY\ENTMENUU.PAS',
  LabelU in 'x:\ENTRPRSE\CUSTOM\DUMMY\LABELU.PAS',
  ChainU in 'x:\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS',
  UDefProc in '..\COMMON\UDEFPROC.PAS',
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.RES}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP} //RJ 17/02/2016 2016-R1 ABSEXCH-17247: Adding PE flags release to plug-ins.

Exports
  { LabelU.Pas }
  EntDoCustomText,
  EntGetCustomText,

  { EntMenuU.Pas }
  CustomMenus,
  CloseCustomMenus,

  { HandlerU.Pas }
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler;
end.
