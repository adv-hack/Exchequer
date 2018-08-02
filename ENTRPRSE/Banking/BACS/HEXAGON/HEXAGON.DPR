library Hexagon;

{$REALCOMPATIBILITY ON}


uses
  ShareMem,
  Windows,
  LabelU in 'x:\ENTRPRSE\CUSTOM\DUMMY\Labelu.pas',
  CustAbsU in 'X:\ENTRPRSE\R&D\Custabsu.pas',
  Handleru in 'Handleru.pas',
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\Chainu.pas',
  EntMenuU in 'x:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas';

{$R *.RES}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/04/2016 : : Adding PE flags release to plug-ins.  

Exports
  CustomMenus,
  CloseCustomMenus,
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,
  EntDoCustomText,
  EntGetCustomText;
end.
