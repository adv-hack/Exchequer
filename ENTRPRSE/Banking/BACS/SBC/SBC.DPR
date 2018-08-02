library sbc;

{$REALCOMPATIBILITY ON}


uses
  ShareMem,
  LabelU in 'E:\custom\Delphi\BaseFile\Labelu.pas',
  CustAbsU in 'E:\custom\Delphi\BaseFile\Custabsu.pas',
  EntMenuU in 'E:\custom\Delphi\BaseFile\Entmenuu.pas',
  Handleru in 'Handleru.pas',
  ChainU in 'E:\custom\Delphi\BaseFile\Chainu.pas',
  ScbObj in 'ScbObj.pas',
  scb01 in 'scb01.pas';

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
