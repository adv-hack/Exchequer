library CuButtns;

{$ALIGN 1}
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
  SysUtils,
  Classes,
  LABELU in 'LABELU.PAS',
  HANDLERU in 'HANDLERU.PAS',
  EntMenuU in '..\DUMMY\ENTMENUU.PAS',
  ChainU in '..\ENTCUSTM.ReallyOld\CHAINU.PAS',
  CustAbsU in '..\..\R&D\CUSTABSU.PAS',
  EnableButtonsF in 'EnableButtonsF.pas' {frmEnablecustomButtons};

{$R *.res}

Exports
  // LabelU.Pas
  EntDoCustomText,
  EntGetCustomText,

  // HandlerU.Pas
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,

  // EntMenuU.Pas
  CustomMenus,
  CloseCustomMenus;
end.
