library PPDCredt;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

uses
  Sharemem,
  SysUtils,
  Classes,
  EntMenuU in '..\..\ENTRPRSE\CUSTOM\DUMMY\ENTMENUU.PAS',
  HANDLERU in 'HANDLERU.PAS',
  LABELU in 'LABELU.PAS',
  ChainU in '..\..\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS',
  TakePPDF in 'TakePPDF.pas' {frmTakePPD},
  oIni in 'oIni.pas',
  GlobType in '\Entrprse\FormDes2\GlobType.pas',
  CreateCreditNote in 'CreateCreditNote.pas';

{$R *.res}

Exports
  // EntMenuU.pas
  CustomMenus,
  CloseCustomMenus,

  // LabelU.pas
  EntDoCustomText,
  EntGetCustomText,

  // HandlerU.pas
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler;
end.
