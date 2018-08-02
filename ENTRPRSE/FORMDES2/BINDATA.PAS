unit BinData;

interface

Uses SysUtils;

Function ConvertAsciiText (InText : ANSIString) : ANSIString;

implementation

// Example InText:-
//
//  aB[32][58]C[45][41]d
//
Function ConvertAsciiText (InText : ANSIString) : ANSIString;
Var
  SBText          : ShortString;
  CurrCh          : Char;
  I               : SmallInt;
  InSB            : Boolean;
  ChrVal, ErrCode : Integer;
Begin { ConvertAsciiText }
  Result := '';
  SBText := '';
  InSB   := False;

  If (Length(InText) > 0) Then
    // Remove any leading '*' - used by FormDes to indicate a Binary char sequence
    If (InText[1] = '*') Then
      Delete (InText, 1, 1);

  If (Length(InText) > 0) Then Begin
    // Run through the characters processing them
    For I := 1 To Length(InText) Do Begin
      CurrCh := InText[I];

      // Check to see if within a [123] section
      If InSB Then Begin
        If (CurrCh In ['0'..'9']) Then
          SBText := SBText + CurrCh
        Else
          If (CurrCh = ']') And (Trim(SBText) <> '') Then Begin
            // End of brackets - convert number to character and write out
            Val (SBText, ChrVal, ErrCode);
            If (ErrCode = 0) And ((ChrVal >= 0) And (ChrVal <= 255)) Then Begin
              Result := Result + Chr(ChrVal);
              InSB := False;
            End { If (ErrCode = 0) And ((ChrVal >= 0) (ChrVal <= 255)) }
            Else
              // Invalid character value
              Raise Exception.Create (Format('Invalid character value "%s" at position %d', [SBText, I - Length(SBText)]));
          End { If (CurrCh = ']') }
          Else
            // Unsupported character
            Raise Exception.Create (Format('Invalid character "%s" at position %d', [CurrCh, I]));
      End { If InSB }
      Else Begin
        // Check for start of [123] section
        If (CurrCh = '[') Then Begin
          InSB := True;
          SBText := '';
        End { If (CurrCh = '[') }
        Else
          // Check for character to pass directly through
          If (CurrCh In [' '..'Z', '\', 'a'..'z', '{', '}']) Then
            Result := Result + CurrCh
          Else
            // Unsupported character
            Raise Exception.Create (Format('Invalid character "%s" at position %d', [CurrCh, I]));
      End; { Else }
    End; { For I }

    If InSB Then
      // Unterminated brackets
      Raise Exception.Create ('The last character sequence was not terminated with a "]"');
  End; { If (Length(InText) > 0) }
End; { ConvertAsciiText }


end.
