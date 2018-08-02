library Bacs1;

{$REALCOMPATIBILITY ON}

uses
  SysUtils,
  Classes,
  LabelU in 'E:\custom\Delphi\BaseFile\Labelu.pas',
  CustAbsU in 'E:\custom\Delphi\BaseFile\Custabsu.pas',
  Entmenuu in '..\General\Entmenuu.pas',
  Handleru in 'Handleru.pas',
  ChainU in 'E:\custom\Delphi\BaseFile\Chainu.pas',
  bacs00 in 'bacs00.pas',
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
