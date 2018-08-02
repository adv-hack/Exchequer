library Payaway;

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
  LabelU in 'x:\ENTRPRSE\CUSTOM\DUMMY\LABELU.PAS',
  CustAbsU in 'X:\ENTRPRSE\R&D\CUSTABSU.PAS',
  EntMenuU in 'x:\ENTRPRSE\CUSTOM\DUMMY\ENTMENUU.PAS',
  HANDLERU in 'HANDLERU.PAS',
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS';

{$R *.RES}

{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

Exports
  CustomMenus,
  CloseCustomMenus,
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,
  EntDoCustomText,
  EntGetCustomText;

end.
