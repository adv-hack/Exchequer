library UDPeriod;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

  {$REALCOMPATIBILITY ON}
  {$ALIGN 1}


uses
//  ShareMem,
  SysUtils,
  Classes,
  Windows,
  UDPProc in 'UDPProc.pas',
  PerUtil in 'W:\PlugIns\User Defined Periods\COMMON\PERUTIL.PAS';

{$R *.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}//RJ 16/02/2016 2016-R1 ABSEXCH-17247: Added PE flags release to plug-ins. 

exports
  GetUDPeriodYear index 1,
  GetDateFromUDPY index 2,
  GetUDPeriodYear_Ext index 3,
  GetDateFromUDPY_Ext index 4,
  UseUDPeriods index 5,
  SuppressErrorMessages index 6,
  GetEndDateOfUDPY index 7;

begin
end.
