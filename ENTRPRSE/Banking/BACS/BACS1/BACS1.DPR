library Bacs1;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  Windows,  
  LabelU in 'x:\ENTRPRSE\CUSTOM\DUMMY\LABELU.PAS',
  CustAbsU in 'X:\ENTRPRSE\R&D\Custabsu.pas',
  Entmenuu in 'X:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  Handleru in 'Handleru.pas',
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\Chainu.pas';

{$R *.RES}

{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}
// PS - 06/05/2016 : : Added PE flag release to plug-ins.

Exports
  CustomMenus,
  CloseCustomMenus,
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,
  EntDoCustomText,
  EntGetCustomText;

end.
