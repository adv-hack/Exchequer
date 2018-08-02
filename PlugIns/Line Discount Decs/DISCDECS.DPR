library DiscDecs;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  ShareMem,
  SysUtils,
  Classes,
  Handleru in 'Handleru.pas',
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS',
  LabelU in 'X:\ENTRPRSE\CUSTOM\DUMMY\LABELU.PAS',
  EntMenuU in 'X:\ENTRPRSE\CUSTOM\DUMMY\ENTMENUU.PAS',
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

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
