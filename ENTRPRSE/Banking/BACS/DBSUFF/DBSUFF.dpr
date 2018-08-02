library DBSUFF;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  LabelU in 'x:\ENTRPRSE\CUSTOM\DUMMY\Labelu.pas',
  CustAbsU in 'X:\ENTRPRSE\R&D\Custabsu.pas',
  EntMenuU in 'x:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  Handleru in 'Handleru.pas',
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\Chainu.pas';

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

