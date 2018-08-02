library ENTCOMM2;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$REALCOMPATIBILITY ON}

uses
  //ShareMem,       Removed as causes WISE Scripts to crash 'n burn
  ControlsAtomFix in '\Entrprse\Funcs\ControlsAtomFix.pas',
  SysUtils,
  Classes,
  Windows,
  CommsInt in 'CommsInt.pas',
  Compress in 'Compress.pas' {frmPKZIP},
  EmailFax in 'EmailFax.pas' {frmEmail};

// MH 30/05/2014 v7.0.10 ABSEXCH-15404: Added PE Flags to force entire component to be loaded into memory
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}

Exports
  { EmailFax.Pas }
  ECSENDEMAIL      Index 1,
  ECMAPIAVAILABLE  Index 3,

  { Compress.Pas }
{  ECBUILDZIP       Index 2,}
  ECEXTRACTFILES   Index 4,
  ECZIPGETFILELIST Index 5;
end.
