library TCMSetup;

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

uses
  SysUtils,
  Classes,
  SetupU in 'Setupu.pas',
  SetupBas in 'SETUPBAS.PAS' {SetupTemplate},
  EntDir in 'EntDir.pas' {frmGetEnterpriseDir},
  SetupReg in 'x:\entrprse\MULTCOMP\Setupreg.pas',
  RegBtrv in 'RegBtrv.pas' {frmRegisterBtrieve},
  Ready in 'Ready.pas' {FrmReadyToInstall},
  TillDesc in 'TillDesc.pas' {frmGetTillDesc},
  GetDir in 'Getdir.pas' {frmGetInstallDir},
  SetupSec in 'SetupSec.pas',
  VarConst in '..\..\SHARED\VARCONST.PAS';

{$R *.RES}

exports GetInstallDir, GetEnterpriseDir, RegisterBtrieve, RegisterCustomisation, ShowReady, GetTillDesc
, AddTillName, CheckSecurity;

begin
end.
