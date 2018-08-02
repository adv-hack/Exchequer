library AddNom;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  SysUtils,
  Classes,
  LABELU in 'LABELU.PAS',
  HANDLERU in 'HANDLERU.PAS',
  EntMenuU in '..\CUSTOM\DUMMY\ENTMENUU.PAS',
  ChainU in '..\CUSTOM\ENTCUSTM\CHAINU.PAS',
  CustAbsU in '..\R&D\CUSTABSU.PAS',
  Enterprise01_TLB in '..\COMTK\Enterprise01_TLB.pas',
  AddNomWizard in 'AddNomWizard.pas' {frmAddNomWizard},
  NomLine in 'NomLine.pas' {fNomLine: TFrame},
  AddNomPROC in 'AddNomPROC.PAS';

{$R *.res}

Exports
  // LabelU
  EntDoCustomText,
  EntGetCustomText,

  // HandlerU
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,

  // EntMenuU
  CustomMenus,
  CloseCustomMenus;
end.
