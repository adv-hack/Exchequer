library Unity;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  LabelU in 'x:\ENTRPRSE\CUSTOM\DUMMY\Labelu.pas',
  CustAbsU in 'X:\ENTRPRSE\R&D\Custabsu.pas',
  EntMenuU in 'x:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\Chainu.pas',
  Handleru in 'Handleru.pas';

{$R *.res}

Exports
  CustomMenus,
  CloseCustomMenus,
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,
  EntDoCustomText,
  EntGetCustomText;

end.
