library Coutts;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  LabelU in 'X:\ENTRPRSE\CUSTOM\DUMMY\Labelu.pas',
  CustAbsU in 'X:\ENTRPRSE\R&D\Custabsu.pas',
  EntMenuU in 'X:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\Chainu.pas',
  Handleru in 'Handleru.pas';

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
 