library SentDlHk;

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
  CustWinU in 'X:\Entrprse\R&D\Custwinu.pas',
  CustAbsU in 'X:\Entrprse\R&D\Custabsu.pas',
  HandlerU in 'Handleru.pas',
  Entmenuu in 'x:\entrprse\CUSTOM\DUMMY\Entmenuu.pas',
  LabelU in 'x:\entrprse\CUSTOM\DUMMY\Labelu.pas',
  ChainU in 'x:\entrprse\CUSTOM\ENTCUSTM\CHAINU.PAS';

{$R *.RES}

// MH 10/04/2017  2017-R1 ABSEXCH-18453: Added PE Flags to force entire component to be loaded into memory
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}

Exports
  CustomMenus,
  CloseCustomMenus,
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,
  EntDoCustomText,
  EntGetCustomText;
end.

