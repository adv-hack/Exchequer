library UsrFDlg;

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
  Sharemem,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  SysUtils,
  Classes,
  Windows,
  USERFPOP in 'USERFPOP.PAS' {frmPopupList},
  UDefProc in '..\COMMON\UDEFPROC.PAS',
  DateErr in 'DateErr.pas' {FrmDateError},
  BTProc in '..\COMMON\BTPROC.PAS',
  VarConst in '..\COMMON\VARCONST.PAS',
  DataModule in '..\COMMON\DataModule.pas' {SQLDataModule: TDataModule};

{$R *.res}
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}//RJ 16/02/2016 2016-R1 ABSEXCH-17247: Added PE flags release to plug-ins. 

exports
  ExecutePlugIn index 1,
  ExecuteTXPlugIn index 2,
  OpenFiles index 3,
  CloseFiles index 4,
  RunConversion index 5,
  DisconnectADO index 6,
  ExecutePlugIn_V63 index 7,
  ExecuteTXPlugIn_V63 index 8,
  OpenFiles_V63 index 9,
  RunConversion_V63 index 10,
  ExecuteTXPlugIn_DotNet index 11
  ;

begin
end.
