library eBusSet;

{$REALCOMPATIBILITY ON}

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
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  Setintf in 'Setintf.pas',
  SysSetup in 'Syssetup.pas' {frmSystemSetup},
  EBusVar in '..\Shared\Ebusvar.pas',
  EBusBtrv in '..\Shared\Ebusbtrv.pas',
  AddComp in 'Addcomp.pas' {frmAddCompany},
  TextFile in 'TextFile.pas' {frmEditTextFiles},
  Selfile in 'Selfile.pas' {FrmSelectFile};

{$R *.RES}
{$R ARROWS.RES}

exports
  ShowSetupScreen index 1,
  UseBasda309 index 2;

begin
  Application.HelpFile := '';
  end.
