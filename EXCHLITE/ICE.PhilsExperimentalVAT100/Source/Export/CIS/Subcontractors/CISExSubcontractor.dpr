{-----------------------------------------------------------------------------
 Unit Name: CISExSubcontractor
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}

library CISExSubcontractor;

uses
  ComServ,
  CISExSubcontractor_TLB in 'CISExSubcontractor_TLB.pas',
  uCISExSubcontractor in 'uCISExSubcontractor.pas' {CISSubcontractorExport: CoClass},
  uSubcontractorExport in 'uSubcontractorExport.pas',
  DSRUtility_TLB in 'X:\EXCHLITE\ICE\Source\DSRUtility\DSRUtility_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
