unit Base34;

interface

// 0..9 + A..Z less I and O to stop confusion with 1 and 0

{ Encodes a SmallInt as a two digit base-34 number }
Function Encode34I (Const IntNum : SmallInt;
                    Var   B34Str : ShortString) : Boolean;

{ Decodes a two digit base34 string into a smallint }
Function Decode34I (Const B34Str : ShortString;
                    Var   IntNum : SmallInt) : Boolean;

{ Encodes a Byte as a single digit base-34 number }
Function Encode34B (Const ByteNum : Byte;
                    Var   B34Str  : ShortString) : Boolean;

{ Decodes a single digit base34 string into a Byte }
Function Decode34B (Const B34Str  : ShortString;
                    Var   ByteNum : Byte) : Boolean;

{ Encodes a LongInt as a four digit base-34 number - max LongInt Value = 1,336,335 }
Function Encode34LI (Const LongNum : LongInt;
                     Var   B34Str  : ShortString) : Boolean;

{ Decodes a four digit base34 string into a LongInt }
Function Decode34LI (Const B34Str  : ShortString;
                     Var   LongNum : LongInt) : Boolean;

implementation

Const
  B34Num2  = 34;
  B34Num3  = 34 * 34;
  B34Num4  = 34 * 34 * 34;
  B34Num5  = 34 * 34 * 34 * 34;

  B34Set   = ['0'..'9', 'A'..'H', 'J'..'N', 'P'..'Z'];

  {$IFNDEF B34RAND}
    // Sequential character changes
    B34Chars : Array [0..33] Of Char =
               ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K',
                'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
                'W', 'X', 'Y', 'Z');
  {$ELSE}
    // Random Character sequence
    B34RandChars = '0NQ5DH7GK9VB1T3CWP8ZU4SE6XF2YJMRAL';

    B34Chars : Array [0..33] Of Char =
               ('0', 'N', 'Q', '5', 'D', 'H', '7', 'G', 'K', '9',
                'V', 'B', '1', 'T', '3', 'C', 'W', 'P', '8', 'Z',
                'U', '4', 'S', 'E', '6', 'X', 'F', '2', 'Y', 'J',
                'M', 'R', 'A', 'L');
  {$ENDIF}


Function CharToB34 (Const TheChar : Char) : LongInt;
Begin { CharToB34 }
  Result := 0;

  {$IFNDEF B34RAND}
    // Sequential character changes
    Case TheChar Of
      '0'..'9' : Result := Ord (TheChar) - Ord('0');

      'A'..'H' : Result := 10 + Ord (TheChar) - Ord('A');

      'J'..'N' : Result := 10 + Ord (TheChar) - Ord('A') - 1;

      'P'..'Z' : Result := 10 + Ord (TheChar) - Ord('A') - 2;
    End; { Case }
  {$ELSE}
    // Random Character sequence
    Result := Pos (TheChar, B34RandChars) - 1;         
  {$ENDIF}
End; { CharToB34 }

//------------------------------------------------------------------------

{ Encodes a SmallInt as a two digit base-34 number }
Function Encode34I (Const IntNum : SmallInt;
                    Var   B34Str : ShortString) : Boolean;
Var
  CalcNum, I : LongInt;
Begin { Encode34I }
  B34Str := '00';
  Result := False;

  If (IntNum >= 0) And (IntNum < B34Num3) Then Begin
    CalcNum := IntNum;

    If (CalcNum >= B34Num2) Then Begin
      I := CalcNum Div B34Num2;
      B34Str[1] := B34Chars[I];
      CalcNum := CalcNum Mod B34Num2;
    End; { If }

    If (CalcNum >= 0) And (CalcNum < 34) Then Begin
      B34Str[2] := B34Chars[CalcNum];

      Result := True;
    End { If }
    Else Begin
      { Something has cocked up }
      Result := False;
    End; { Else }
  End; { If }
End; { Encode34I }


{ Decodes a two digit base34 string into a smallint }
Function Decode34I (Const B34Str : ShortString;
                    Var   IntNum : SmallInt) : Boolean;
Begin { Decode34 }
  Result := False;
  intnum := 0;

  If (Length(B34Str) = 2) Then Begin
    { Got right number of characters - a good start }
    If (B34Str[1] In B34Set) And (B34Str[2] In B34Set) Then Begin
       intnum :=           (CharToB34 (B34Str[1]) * B34Num2);
       intnum := intnum + (CharToB34 (B34Str[2]));

       Result := True;
    End; { If }
  End; { If }
End; { Decode34 }

//------------------------------------------------------------------------

{ Encodes a Byte as a single digit base-34 number }
Function Encode34B (Const ByteNum : Byte;
                    Var   B34Str  : ShortString) : Boolean;
Begin { Encode34B }
  B34Str := '0';
  Result := False;

  If {(ByteNum >= 0) And} (ByteNum < 34) Then Begin
    // HM 16/010/02: Changed Idx from 2 to 1 as it was WRONG
    B34Str[1] := B34Chars[ByteNum];

    Result := True;
  End; { If }
End; { Encode34B }

{ Decodes a single digit base34 string into a Byte }
Function Decode34B (Const B34Str  : ShortString;
                    Var   ByteNum : Byte) : Boolean;
Begin { Decode34B}
  Result := False;
  ByteNum := 0;

  If (Length(B34Str) = 1) Then Begin
    { Got right number of characters - a good start }
    If (B34Str[1] In B34Set) Then Begin
       ByteNum := CharToB34 (B34Str[1]);

       Result := True;
    End; { If }
  End; { If }
End; { Decode34B}

//------------------------------------------------------------------------

{ Encodes a LongInt as a four digit base-34 number - max LongInt Value = 1,336,335 }
Function Encode34LI (Const LongNum : LongInt;
                     Var   B34Str  : ShortString) : Boolean;
Var
  CalcNum, I : LongInt;
Begin { Encode34LI }
  B34Str := '0000';
  Result := False;

  If (LongNum >= 0) And (LongNum < B34Num5) Then Begin
    CalcNum := LongNum;

    If (CalcNum >= B34Num4) Then Begin
      I := CalcNum Div B34Num4;
      B34Str[1] := B34Chars[I];
      CalcNum := CalcNum Mod B34Num4;
    End; { If }

    If (CalcNum >= B34Num3) Then Begin
      I := CalcNum Div B34Num3;
      B34Str[2] := B34Chars[I];
      CalcNum := CalcNum Mod B34Num3;
    End; { If }

    If (CalcNum >= B34Num2) Then Begin
      I := CalcNum Div B34Num2;
      B34Str[3] := B34Chars[I];
      CalcNum := CalcNum Mod B34Num2;
    End; { If }

    If (CalcNum >= 0) And (CalcNum < 34) Then Begin
      B34Str[4] := B34Chars[CalcNum];

      Result := True;
    End { If }
    Else
      { Something has cocked up }
      Result := False;
  End; { If }
End; { Encode34LI }

{ Decodes a four digit base34 string into a LongInt }
Function Decode34LI (Const B34Str  : ShortString;
                     Var   LongNum : LongInt) : Boolean;
Begin { Decode34LI }
  Result := False;
  LongNum := 0;

  If (Length(B34Str) = 4) Then Begin
    { Got right number of characters - a good start }
    If (B34Str[1] In B34Set) And (B34Str[2] In B34Set) And (B34Str[3] In B34Set) And (B34Str[4] In B34Set) Then Begin
       LongNum :=           (CharToB34 (B34Str[1]) * B34Num4);
       LongNum := LongNum + (CharToB34 (B34Str[2]) * B34Num3);
       LongNum := LongNum + (CharToB34 (B34Str[3]) * B34Num2);
       LongNum := LongNum + (CharToB34 (B34Str[4]));

       Result := True;
    End; { If }
  End; { If }
End; { Decode34LI }

//------------------------------------------------------------------------

end.
