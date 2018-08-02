library ENPorSec;

{$REALCOMPATIBILITY ON}

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Windows,
  Classes,
  HANDLERU in 'HANDLERU.PAS',
  INIINTF in 'INIINTF.PAS',
  SELDEPTF in 'SELDEPTF.PAS' {frmSelectDept},
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS',
  LabelU in 'X:\ENTRPRSE\CUSTOM\DUMMY\LABELU.PAS',
  EntMenuU in 'X:\ENTRPRSE\CUSTOM\DUMMY\ENTMENUU.PAS',
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.RES}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 09/05/2016 : : Added PE flag release to plug-ins.

Exports
  { LabelU.Pas }
  EntDoCustomText,
  EntGetCustomText,

  { HandlerU.Pas }
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,

  { EntMenuU.Pas }
  CustomMenus,
  CloseCustomMenus;
end.
