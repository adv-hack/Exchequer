{-----------------------------------------------------------------------------
 Unit Name: VAT100Im
 Author:    Phil Rogers
 Purpose:
 History:
-----------------------------------------------------------------------------}
library VAT100Im;

uses
  ComServ,
  VAT100Im_TLB in 'VAT100Im_TLB.pas',
  uVAT100Im in 'uVAT100Im.pas' {VAT100Im: CoClass},
  uVAT100Import in 'uVAT100Import.pas',
  DSRUtility_TLB in 'X:\EXCHLITE\ICE\Source\DSRUtility\DSRUtility_TLB.pas',
  CISXCnst in 'X:\ENTRPRSE\CISXML\CISXCnst.pas',
  VATXMLConst in 'X:\ENTRPRSE\R&D\VATXMLConst.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
