{-----------------------------------------------------------------------------
 Unit Name: CISOutgoing
 Author:    vmoura
 Purpose:
 History:           
-----------------------------------------------------------------------------}
library CISOutgoing;

uses
  ComServ,
  CISOutgoing_TLB in 'CISOutgoing_TLB.pas',
  uCISSending in 'uCISSending.pas' {CISSending: CoClass},
  DSROutgoing_TLB in 'X:\EXCHLITE\ICE\Source\DSR\Outgoing\DSROutgoing_TLB.pas',
  uDSRSettings in 'X:\EXCHLITE\ICE\Source\DSR\uDSRSettings.pas',
  uDSRFileFunc in 'X:\EXCHLITE\ICE\Source\DSR\uDSRFileFunc.pas',
  CISXCnst in 'X:\ENTRPRSE\CISXML\CISXCnst.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
