library Bbm;
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
  CustWinU in 'x:\Entrprse\R&D\Custwinu.pas',
  CustAbsU in 'x:\Entrprse\R&D\Custabsu.pas',
  HandlerU in 'Handleru.pas',
  Entmenuu in 'x:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  ChainU in 'x:\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS',
  LabelU in '..\GENERAL\LABELU.PAS',
  BbmObj in '..\OBJECTS\BbmObj.pas',
  db_accss in 'db_accss.pas' {dm1: TDataModule},
  bbmconst in 'bbmconst.pas';

{$R *.res}

Exports
  CustomMenus,
  CloseCustomMenus,
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,
  EntDoCustomText,
  EntGetCustomText;
end.
 