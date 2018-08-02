library AuthSOR;

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
{$ALIGN 1}

uses
  ShareMem,
  SysUtils,
  Classes,
  LabelU in 'LABELU.PAS',
  ChainU in 'x:\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS',
  HandlerU in 'HANDLERU.PAS',
  EntMenuU in 'x:\ENTRPRSE\CUSTOM\DUMMY\ENTMENUU.PAS',
  AuthSORProc in 'AuthSORProc.pas',
  CommideaInt in '..\CommideaDLL\ExCommid.Dll\CommideaInt.pas',
  ReferralDialog in 'ReferralDialog.pas' {frmReferralDialog},
  Authorise in 'Authorise.pas' {frmAuthorise},
  CardDetails in 'CardDetails.pas' {frmCardDetails};

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
