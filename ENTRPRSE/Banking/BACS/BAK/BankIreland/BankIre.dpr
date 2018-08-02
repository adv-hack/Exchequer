library BankIre;

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
  SysUtils,
  Classes,
  ChainU in 'E:\custom\Delphi\BaseFile\Chainu.pas',
  CustAbsU in 'E:\custom\Delphi\BaseFile\Custabsu.pas',
  EntMenuU in 'E:\custom\Delphi\BaseFile\Entmenuu.pas',
  Handleru in 'Handleru.pas',
  LabelU in 'E:\custom\Delphi\BaseFile\Labelu.pas',
  BankIObj in 'BankIObj.pas';

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
