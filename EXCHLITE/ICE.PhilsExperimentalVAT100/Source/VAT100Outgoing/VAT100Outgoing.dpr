{-----------------------------------------------------------------------------
 Unit Name: VAT100Outgoing
 Author:    Phil Rogers
 Purpose:
 History:
-----------------------------------------------------------------------------}
library VAT100Outgoing;

uses
  ComServ,
  DSROutgoing_TLB in '..\DSR\Outgoing\DSROutgoing_TLB.pas',
  uDSRSettings in '..\DSR\uDSRSettings.pas',
  uDSRFileFunc in '..\DSR\uDSRFileFunc.pas',
  VAT100Outgoing_TLB in 'VAT100Outgoing_TLB.pas',
  VATXMLConst in '..\..\..\..\ENTRPRSE\R&D\VATXMLConst.pas',
  uVAT100Sending in 'uVAT100Sending.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
