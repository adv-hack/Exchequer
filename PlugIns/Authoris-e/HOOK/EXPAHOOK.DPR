library ExPAHOOK;

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
  HANDLERU in 'HANDLERU.PAS',
  LABELU in 'LABELU.PAS',
  HookFunc in 'HookFunc.pas',
  UserForm in '..\BASE\UserForm.pas' {frmPaUserID},
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS',
  EntMenuU in 'X:\ENTRPRSE\CUSTOM\DUMMY\ENTMENUU.PAS',
  CustAbsU in 'X:\ENTRPRSE\R&D\CUSTABSU.PAS';

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
