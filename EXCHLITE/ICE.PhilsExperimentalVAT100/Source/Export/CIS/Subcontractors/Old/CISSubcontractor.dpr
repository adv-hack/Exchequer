{-----------------------------------------------------------------------------
 Unit Name: CISSubcontractor
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}

library CISSubcontractor;

uses
  ComServ,
  CISSubcontractor_TLB in 'CISSubcontractor_TLB.pas',
  uCISSubcontractor in 'uCISSubcontractor.pas' {CISSubcontractorExport: CoClass},
  uSubcontractorExport in 'uSubcontractorExport.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
