Library ENTSECUR;

{$REALCOMPATIBILITY ON}

uses
  Comserv,
  Forms,
  Windows,
  EnterpriseSecurity_TLB in 'EnterpriseSecurity_TLB.pas',
  oEntSec in 'oEntSec.pas' {ThirdParty: CoClass},
  VAOUtil in 'X:\ENTRPRSE\FUNCS\VAOUtil.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

// MH 30/05/2014 v7.0.10 ABSEXCH-15404: Added PE Flags to force entire component to be loaded into memory
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}

end.
