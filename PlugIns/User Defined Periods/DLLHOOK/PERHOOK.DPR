library PerHook;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  ShareMem,
  Windows,
  HandlerU in 'HANDLERU.PAS',
  LabelU in 'x:\ENTRPRSE\CUSTOM\DUMMY\LABELU.PAS',
  UDPInt in '..\UDPERIOD\UDPInt.pas',
  MenuProc in 'MenuProc.pas',
  UDPeriodAdmin in 'UDPeriodAdmin.PAS' {frmPeriodList},
  PerSet in 'PERSET.PAS' {frmPeriodSet},
  EntMenuU in 'EntMenuU.pas',
  ChainU in 'CHAINU.PAS',
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas';

{$R *.RES}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP} //RJ 17/02/2016 2016-R1 ABSEXCH-17247: Adding PE flags release to plug-ins.

exports
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,

  // Standard stub routines in LabelU
  EntDoCustomText,
  EntGetCustomText,

  // Standard stub routines in EntMenuU
  CustomMenus,
  CloseCustomMenus;
begin
end.
