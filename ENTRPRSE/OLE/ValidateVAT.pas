unit ValidateVAT;

interface

Uses StrUtils, SysUtils, GlobVar, VarConst;

Type
  TVATObjectType = (votCustomer, votSupplier, votStock);

function IfThen(AValue: Boolean; const ATrue, AFalse : TVATObjectType): TVATObjectType; overload


// Returns the VAT Code / Inclusive VAT Code description string
Function GetVATCodeDesc (Const VATCode, InclVATCode : Char) : ShortString;

// Validates a VATCodes string and returns the identified VAT Code and Inclusive
// VAT Code, one of the following statii is returned:-
//
//   0   AOK
//   1   Cannot be blank
//   2   The Inclusive VAT Code must be specified using the format "IS"
//   3   Invalid Inclusive VAT Code
//   4   The VAT Code must be specified using the format "S"
//   5   Invalid VAT Code
//
Function ValidateVATCodeString (Const ObjectType : TVATObjectType;
                                      VATCodes   : ShortString;
                                Const ECMember   : Boolean;
                                Var   VATCode, InclVATCode : Char) : Byte;

implementation

//-------------------------------------------------------------------------

function IfThen(AValue: Boolean; const ATrue, AFalse : TVATObjectType): TVATObjectType;
Begin // IfThen
  If AValue Then Result := ATrue Else Result := AFalse;
End; // IfThen

//-------------------------------------------------------------------------

// Returns the VAT Code / Inclusive VAT Code description string
Function GetVATCodeDesc (Const VATCode, InclVATCode : Char) : ShortString;
Begin // GetVATCodeDesc
  If (VATCode <> 'I') Then
    Result := VATCode
  Else
    Result := VATCode + InclVATCode;
End; // GetVATCodeDesc

//-------------------------------------------------------------------------

// Validates a VATCodes string and returns the identified VAT Code and Inclusive
// VAT Code, one of the following statii is returned:-
//
//   0   AOK
//   1   Cannot be blank
//   2   The Inclusive VAT Code must be specified using the format "IS"
//   3   Invalid Inclusive VAT Code
//   4   The VAT Code must be specified using the format "S"
//   5   Invalid VAT Code
//
Function ValidateVATCodeString (Const ObjectType : TVATObjectType;
                                      VATCodes   : ShortString;
                                Const ECMember   : Boolean;
                                Var   VATCode, InclVATCode : Char) : Byte;
Var
  ValidVATCodes : CharSet;
Begin // ValidateVATCodeString
  VATCodes := UpperCase(Trim(VATCodes));

  If (VATCodes <> '') Then
  Begin
    // Check for Inclusive VAT in which case we need a 2 char string in the format 'IS'
    If (VATCodes[1] = VATICode) Then
    Begin
      If (Length(VATCodes) = 2) Then
      Begin
        // Inclusive VAT Code must be a valid VAT Code excluding I/M and the intrastat codes A/D
        If (VATCodes[2] In (VATSet - VATEqStd - VATEECSet)) Then
        Begin
          Result := 0;
          VATCode := VATCodes[1];
          InclVATCode := VATCodes[2];
        End // If (VATCodes[2] In (VATSet - VATEqStd - VATEECSet))
        Else
          Result := 3; // Invalid Inclusive VAT Code
      End // (Length(VATCodes) = 2)
      Else
        Result := 2; // The Inclusive VAT Code must be specified using the format "IS"
    End // If (VATCodes[1] = VATICode)
    Else
    Begin
      // Must be a standard single character VAT Code
      If (Length(VATCodes) = 1) Then
      Begin
        // VAT Code must be a valid VAT Code excluding I/M, if Intrastat is on then the intrastat
        // codes A/D can also be used where applicable
        ValidVATCodes := VATSet - VATEqStd;
        If (Not Syss.IntraStat) Then
          ValidVATCodes := ValidVATCodes - VATEECSet
        Else
        Begin
          Case ObjectType Of
            // Customers cannot be A and can only be D if an EC Member
            votCustomer : If ECMember Then
                            ValidVATCodes := ValidVATCodes - [VATEECCode]
                          Else
                            ValidVATCodes := ValidVATCodes - VATEECSet;
            // Customers cannot be D and can only be A if an EC Member
            votSupplier : If ECMember Then
                            ValidVATCodes := ValidVATCodes - [VATECDCode]
                          Else
                            ValidVATCodes := ValidVATCodes - VATEECSet;
            // Stock cannot be either A or D
            votStock    : ValidVATCodes := ValidVATCodes - VATEECSet;
          End; // Case ObjectType
        End; // Else

        If (VATCodes[1] In ValidVATCodes) Then
        Begin
          Result := 0;
          VATCode := VATCodes[1];
          //InclVATCode := VATZCode; - Exchequer leaves previous value intact
        End // If (VATCodes[1] In ValidVATCodes)
        Else
          Result := 5; // Invalid VAT Code
      End // (Length(VATCodes) = 1)
      Else
        Result := 4; // The VAT Code must be specified using the format "S"
    End; // Else
  End // If (VATCodes <> '')
  Else
    Result := 1;  // Cannot be blank
End; // ValidateVATCodeString

//-------------------------------------------------------------------------

end.
