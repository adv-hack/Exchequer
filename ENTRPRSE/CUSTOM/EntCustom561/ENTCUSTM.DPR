library EntCustm;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  ShareMem,
  SysUtils,
  Classes,
  EntMenuU in 'EntMenuU.pas',
  LabelU in 'LABELU.PAS',
  HANDLERU in 'HANDLERU.PAS',
  MenuDesigner in 'MenuDesigner.pas' {frmMenuDesigner},
  ToolBTFiles in 'ToolBTFiles.PAS',
  ToolProc in 'ToolProc.pas',
  uEntMenu in 'uEntMenu.pas',
  SystemSetup in 'SystemSetup.pas' {frmSystemSetup},
  Login in 'Login.pas' {frmLogin},
  PickReport in 'PickReport.pas' {frmPickReport},
  ReportProgress in 'ReportProgress.pas' {frmReportProgress},
  IncludeCustMenu in 'IncludeCustMenu.pas',
  ChainU in 'CHAINU.PAS';

{ Resource file containing standard customisable labels }
{ R EntText.Res}


Exports
  { CustomU.Pas - Menu Customisation }
  CustomMenus,
  CloseCustomMenus,

  { HandlerU.Pas - Customisation Hooks }
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,

  { LabelU - Label Customisation }
  EntDoCustomText,
  EntGetCustomText,
  AddCustomText;
end.
