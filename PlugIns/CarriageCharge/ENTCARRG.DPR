library ENTCARRG;

{$REALCOMPATIBILITY ON}

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  ShareMem,
  Windows,
  HandlerU in 'HANDLERU.PAS',
  EntMenuU in 'x:\ENTRPRSE\CUSTOM\DUMMY\Entmenuu.pas',
  IniU in 'INIU.PAS',
  Carriage in 'CARRIAGE.PAS' {frmCarriage},
  ChainU in 'x:\ENTRPRSE\CUSTOM\ENTCUSTM\CHAINU.PAS',
  LabelU in 'x:\ENTRPRSE\CUSTOM\DUMMY\LABELU.PAS',
  EntLicence in 'X:\ENTRPRSE\DRILLDN\EntLicence.pas',
  SerialU in 'X:\ENTRPRSE\MULTCOMP\SERIALU.PAS',
  EntLic in 'X:\ENTRPRSE\MULTCOMP\ENTLIC.PAS',
  ExchequerRelease in '\SBSLib\Win\ExCommon\ExchequerRelease.pas',
  Crypto in 'X:\ENTRPRSE\MULTCOMP\CRYPTO.PAS';
 {$R *.RES}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}//RJ 16/02/2016 2016-R1 ABSEXCH-17247: Added PE flags release to plug-ins. 
Exports
  { CustomU.Pas - Menu Customisation }
  CustomMenus,
  CloseCustomMenus,

  { HandlerU.Pas - Customisation Hooks }
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,

  { LabelU.Pas - Label Customisation }
  EntDoCustomText,
  EntGetCustomText;
end.
