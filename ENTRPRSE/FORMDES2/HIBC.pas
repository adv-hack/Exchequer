unit HIBC;

interface

Uses Classes, Dialogs, SysUtils;

Function CalcHIBCCheckChar(Const BCText : ShortString) : ShortString;

implementation

//-------------------------------------------------------------------------

Function CalcHIBCCheckChar(Const BCText : ShortString) : ShortString;
Var
  I, ChkSum : SmallInt;

  //------------------------------

  Function ConvCharToCheckVal (Const TheChar : Char) : Byte;
  Begin // ConvCharToCheckVal
    Case TheChar Of
      '0'..'9' : Result := Ord(TheChar) - 48;   // '0'=0, '1'=1, ...
      'A'..'Z' : Result := Ord(TheChar) - 55;   // 'A'=10, 'B'=11, ...
      '-'      : Result := 36;
      '.'      : Result := 37;
      ' '      : Result := 38;
      '$'      : Result := 39;
      '/'      : Result := 40;
      '+'      : Result := 41;
      '%'      : Result := 42;
    Else
      Raise Exception.Create ('CalcHIBCCheckChar - Illegal character ' + QuotedStr(TheChar) + ' in HIBC string');
    End; // Case TheChar
  End; // ConvCharToCheckVal

  //------------------------------

  Function ConvCheckValToChar (Const CheckVal : Byte) : Char;
  Begin // ConvCheckValToChar
    Case CheckVal Of
      0..9     : Result := Chr(CheckVal + 48);   // '0'=0, '1'=1, ...
      10..35   : Result := Chr(CheckVal + 55);   // 'A'=10, 'B'=11, ...
      36       : Result := '-';
      37       : Result := '.';
      38       : Result := ' ';
      39       : Result := '$';
      40       : Result := '/';
      41       : Result := '+';
      42       : Result := '%';
    Else
      Raise Exception.Create ('CalcHIBCCheckChar - Illegal CheckSum Value (' + IntToStr(CheckVal) + ') for HIBC string ' + QuotedStr(BCText));
    End; // Case CheckVal
  End; // ConvCheckValToChar

  //------------------------------

Begin // CalcHIBCCheckChar
  // Calculate the checksum for the string
  ChkSum := 0;
  If (Length(BCText) > 0) Then
  Begin
    For I := 1 To Length(BCText) Do
    Begin
      ChkSum := ChkSum + ConvCharToCheckVal(BCText[I]);
    End; // For I
  End; // If (Length(BCText) > 0)

  // Calculate the Modulus 43 checksum and convert that to a character
  // using the same rule as for the checksum calculation
  Result := BCText + ConvCheckValToChar(ChkSum Mod 43);
End; // CalcHIBCCheckChar

end.
