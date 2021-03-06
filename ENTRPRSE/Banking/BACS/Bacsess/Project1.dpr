library Project1;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  ShareMem,
  LabelU in '..\..\..\..\ENTRPRSE\CUSTOM\DUMMY\Labelu.pas',
  CustAbsU in '..\..\..\..\ENTRPRSE\R&D\Custabsu.pas',
  EntMenuU in '..\..\..\..\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  ChainU in '..\..\..\..\ENTRPRSE\CUSTOM\ENTCUSTM\Chainu.pas',
  HANDLERU in '..\..\Bacsess\HANDLERU.PAS',
  BacssOBJ in '..\..\Bacsess\BacssOBJ.PAS';

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
