unit uDSRHistory;

interface

uses uConsts;

Function CommonBit : ShortString;

implementation

uses EntLicence;

Function CommonBit : ShortString;
Begin // CommonBit
  If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]) Then
    // IRIS Accounts Office / LITE
    Result := cIAOVERSION
  Else
    // Exchequer
    Result := cEXVERSION
End; // CommonBit


end.
