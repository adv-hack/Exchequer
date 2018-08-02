library CustHold;

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
  CustWinU in 'X:\Entrprse\R&D\Custwinu.pas',
  CustAbsU in 'X:\Entrprse\R&D\Custabsu.pas',
  HANDLERU in 'HANDLERU.PAS',
  Entmenuu in 'X:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  LABELU in 'LABELU.PAS',
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS',
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.RES}


Exports
  CustomMenus,
  CloseCustomMenus,
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,
  EntDoCustomText,
  EntGetCustomText;
end.
