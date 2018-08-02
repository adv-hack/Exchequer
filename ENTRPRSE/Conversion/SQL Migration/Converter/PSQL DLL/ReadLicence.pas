unit ReadLicence;

interface

Uses LicRec;

// Reads and returns the specified Exchequer licence file (entrprse.dat)
Function ReadExchLicence (Const SecParam : ShortString; Const LicenceFile : ShortString; Var LicenceRec : EntLicenceRecType) : Boolean; StdCall; Export;

// Updates the specified licence file with the specified ESN
Function ResetExchLicenceESN (Const SecParam : ShortString; Const LicenceFile : ShortString; Const NewESN : ESNByteArrayType) : Boolean; StdCall; Export;

implementation

Uses EntLic;

//=========================================================================

// Reads and returns the specified Exchequer licence file (entrprse.dat)
Function ReadExchLicence (Const SecParam : ShortString; Const LicenceFile : ShortString; Var LicenceRec : EntLicenceRecType) : Boolean;
Begin // ReadExchLicence
  If (SecParam = 'S*6Wq21') Then
    Result := ReadEntLic (LicenceFile, LicenceRec)
  Else
    Result := False;
End; // ReadExchLicence

//-------------------------------------------------------------------------

// Updates the specified licence file with the specified ESN
Function ResetExchLicenceESN (Const SecParam : ShortString; Const LicenceFile : ShortString; Const NewESN : ESNByteArrayType) : Boolean;
Var
  LicenceRec : EntLicenceRecType;
Begin // ResetExchLicenceESN
  If (SecParam = 'USG6_WF$') Then
  Begin
    Result := ReadEntLic (LicenceFile, LicenceRec);
    If Result Then
    Begin
      LicenceRec.licISN := NewESN;
      Result := WriteEntLic (LicenceFile, LicenceRec);
    End; // If Result
  End // If (SecParam = 'USG6_WF$')
  Else
    Result := False;
End; // ResetExchLicenceESN

//=========================================================================

end.
