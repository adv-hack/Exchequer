library entgnlro;

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
  ShareMem,
  SysUtils,
  Classes,
  HandlerU in 'HANDLERU.PAS',
  PIMisc in '..\FUNCS\PIMISC.PAS',
  ropopup in 'ropopup.pas' {frmQtyPopup},
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS',
  EntMenuU in 'X:\ENTRPRSE\CUSTOM\DUMMY\ENTMENUU.PAS',
  LabelU in 'X:\ENTRPRSE\CUSTOM\DUMMY\LABELU.PAS';

{$R *.res}

exports
  // EntMenuU.pas - menu customisation
  CustomMenus,
  CloseCustomMenus,

  // HandlerU.pas - hook customisation
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,

  // LabelU.pas - label customisation
  EntDoCustomText,
  EntGetCustomText;

begin
end.
 