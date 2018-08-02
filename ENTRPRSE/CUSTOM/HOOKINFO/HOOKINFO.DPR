Library Hookinfo;

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
  Sharemem,
  SysUtils,
  Classes,
  EntMenuU in '..\DUMMY\Entmenuu.pas',
  HandlerU in 'HANDLERU.PAS',
  LabelU in '..\DUMMY\LABELU.PAS',
  Eventinf in '..\DEMOHOOK\Eventinf.pas' {Form_EventData},
  ChainU in '..\ENTCUSTM\CHAINU.PAS',
  PIMisc in 'X:\BESPOKE\FUNCS\PIMISC.PAS';

{$R *.RES}

Exports
  { EntMenuU.Pas }
  CustomMenus         Index 1,
  CloseCustomMenus    Index 2,

  { HandlerU.Pas }
  InitCustomHandler   Index 3,
  TermCustomHandler   Index 4,
  ExecCustomHandler   Index 5,

  { LabelU.Pas }
  EntDoCustomText     Index 6,
  EntGetCustomText    Index 7;
end.
