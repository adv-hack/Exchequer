library BoASepa;

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

{$REALCOMPATIBILITY ON}

uses
  Sharemem,
  Windows,
  HANDLERU in 'HANDLERU.PAS',
  Entmenuu in '..\..\..\CUSTOM\DUMMY\Entmenuu.pas',
  LabelU in '..\..\GENERAL\LABELU.PAS',
  ChainU in '..\..\..\CUSTOM\ENTCUSTM\CHAINU.PAS',
  BankOfAmericaSepaObj in '..\..\OBJECTS\BankOfAmericaSepaObj.pas';

{$R *.RES}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 09/05/2016 : : Added PE flag release to plug-ins.


Exports
  CustomMenus,
  CloseCustomMenus,
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,
  EntDoCustomText,
  EntGetCustomText;
end.
