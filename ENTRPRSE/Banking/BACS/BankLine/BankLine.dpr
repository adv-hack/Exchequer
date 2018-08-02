library BankLine;

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
  ShareMem,
  Windows,
  LabelU in 'X:\ENTRPRSE\CUSTOM\DUMMY\Labelu.pas',
  CustAbsU in 'X:\ENTRPRSE\R&D\Custabsu.pas',
  EntMenuU in 'X:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  Handleru in 'Handleru.pas',
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\Chainu.pas';

{$R *.RES}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/04/2016 : : Adding PE flags release to plug-ins. 

Exports
  { CustomU.Pas - Menu Customisation }
  CustomMenus,
  CloseCustomMenus,

  { HandlerU.Pas - Customisation Hooks }
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,

  { LabelU.Pas - Label Customisation }
  EntDoCustomText,
  EntGetCustomText;

end.
