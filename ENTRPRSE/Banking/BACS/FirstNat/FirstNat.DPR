library FirstNat;

{$REALCOMPATIBILITY ON}


uses
  ShareMem,
  LabelU in 'X:\ENTRPRSE\CUSTOM\DUMMY\Labelu.pas',
  CustAbsU in 'X:\ENTRPRSE\R&D\Custabsu.pas',
  EntMenuU in 'X:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\Chainu.pas',
  HANDLERU in 'HANDLERU.PAS';

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
