library Clyde13;

{$REALCOMPATIBILITY ON}
//PR: 12/03/2013 ABSEXGENERIC-803 New EFT format for Clydesdale bank.
uses
  ShareMem,
  LabelU in 'X:\ENTRPRSE\CUSTOM\DUMMY\Labelu.pas',
  CustAbsU in 'X:\ENTRPRSE\R&D\Custabsu.pas',
  EntMenuU in 'X:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\Chainu.pas',
  Handleru in 'Handleru.pas',
  Clyde2013Obj in '..\..\OBJECTS\Clyde2013Obj.pas';

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
