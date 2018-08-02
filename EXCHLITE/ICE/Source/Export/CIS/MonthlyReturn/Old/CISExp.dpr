{-----------------------------------------------------------------------------
  Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
library CISExp;

uses
  ComServ,               
  CISExp_TLB in 'CISExp_TLB.pas',
  uCISExport in 'uCISExport.pas' {CISExport: CoClass},
  DSRExport_TLB in 'X:\EXCHLITE\ICE\Source\Export\CIS\DSRExport_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
