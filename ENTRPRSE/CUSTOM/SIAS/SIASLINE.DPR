library SiasLine;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  ShareMem,
  HandlerU in 'HandlerU.pas',
  CustAbsU in '\ENTRPRSE\R&D\Custabsu.pas',
  EntMenuU in '\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  LabelU in '\ENTRPRSE\CUSTOM\STANDARD\Labelu.pas',
  ChainU in '\ENTRPRSE\CUSTOM\STANDARD\Chainu.pas',
  LineDlg in 'LineDlg.pas' {frmSIASLine};


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
