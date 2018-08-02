library FAXBTRV2;

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
  SysUtils,
  Classes,
  VarFPOSU in 'x:\entrprse\r&d\VarFPOSU.PAS',
  VarConst,
  UFaxBtrv in '..\shared\Ufaxbtrv.pas';

exports
  OpenFaxFile index 1,
  OpenFaxFileWithPath index 2,
  CloseFaxFile index 3,
  MakeFaxFile index 4,

  SetNextFaxCounter index 5,
  GetUniqueRef index 6,

  ReadFaxParams index 7,
  WriteFaxParams index 8,

  UnlockFaxDetails index 9,
  FindFaxDetails index 10,
  FindAndLockFaxDetails index 11,
  InsertFaxDetails index 12,
  UpdateFaxDetails index 13,
  DeleteFaxDetails index 14,
  FindFirstFaxDetails index 15,
  FindNextFaxDetails index 16,

  LogFaxServerAsRunning index 17,
  CheckFaxServerRunning index 18;

begin
end.
