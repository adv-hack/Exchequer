library BarcInet;

{$REALCOMPATIBILITY ON}

{Standard Bacs format (no date) without a contra record}
uses
  ShareMem,
  LabelU in 'X:\ENTRPRSE\CUSTOM\DUMMY\Labelu.pas',
  CustAbsU in 'X:\ENTRPRSE\R&D\Custabsu.pas',
  EntMenuU in 'X:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  HANDLERU in 'HANDLERU.PAS',
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
