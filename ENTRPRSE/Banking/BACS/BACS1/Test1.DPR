library Test1;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  LabelU in '..\..\..\..\ENTRPRSE\CUSTOM\DUMMY\LABELU.PAS',
  CustAbsU in '..\..\..\..\ENTRPRSE\R&D\Custabsu.pas',
  Entmenuu in '..\..\..\..\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  TestHand in 'TestHand.PAS',
  ChainU in '..\..\..\..\ENTRPRSE\CUSTOM\ENTCUSTM\Chainu.pas',
  ExpRep in '..\General\ExpRep.pas' {frmExportReport},
  ExpMsg in '..\General\ExpMsg.pas' {frmExportMsg};

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
