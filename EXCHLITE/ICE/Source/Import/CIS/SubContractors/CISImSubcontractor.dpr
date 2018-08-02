{-----------------------------------------------------------------------------
 Unit Name: CISImSubcontractor
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
library CISImSubcontractor;

uses
  ComServ,
  CISImSubcontractor_TLB in 'CISImSubcontractor_TLB.pas',
  uCISImSubcontractor in 'uCISImSubcontractor.pas' {CISImportSubcontractor: CoClass},
  uSubcontractorImport in 'uSubcontractorImport.pas',
  DSRUtility_TLB in 'X:\EXCHLITE\ICE\Source\DSRUtility\DSRUtility_TLB.pas',
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
