library HSBC103;

{$REALCOMPATIBILITY ON}

//------------------------------------------------------------------------------
//HV 09/05/2018 2018-R1.1 ABSEXCH-20015: Thomas Pink - HSBC-MT103 Priority Payments (XML Foramt)
//------------------------------------------------------------------------------

uses
  ShareMem,
  Windows,  
  LabelU in 'X:\ENTRPRSE\CUSTOM\DUMMY\Labelu.pas',
  CustAbsU in 'X:\ENTRPRSE\R&D\Custabsu.pas',
  EntMenuU in 'X:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  ChainU in 'X:\ENTRPRSE\CUSTOM\ENTCUSTM\Chainu.pas',
  HANDLERU in 'HANDLERU.PAS',
  HSBCMT103PPXMLObj in '..\..\OBJECTS\HSBCMT103PPXMLObj.pas';

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
