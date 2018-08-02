library HookTest;

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
  LabelU in 'LABELU.PAS',
  ChainU in 'x:\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS',
  HandlerU in 'HANDLERU.PAS',
  HookProc in 'HookProc.pas',
  Account in 'Account.pas' {FrmAccount},
  SystemInfo in 'SystemInfo.pas' {frmSystem},
  Stock in 'Stock.pas' {frmStock},
  Transaction in 'Transaction.pas' {FrmTransaction},
  TransactionLine in 'TransactionLine.pas' {FrmTransactionLine},
  SerialBatch in 'SerialBatch.pas' {FrmSerialBatch},
  MultiBin in 'MultiBin.pas' {FrmMultiBin},
  Email in 'Email.pas' {FrmEmail},
  EntMenuU in 'X:\ENTRPRSE\CUSTOM\DUMMY\ENTMENUU.PAS';

{$R *.RES}

Exports
  { HandlerU.Pas }
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,

  { LabelU.Pas }
  EntDoCustomText,
  EntGetCustomText,

  { EntMenuU.Pas }
  CustomMenus,
  CloseCustomMenus;
end.
