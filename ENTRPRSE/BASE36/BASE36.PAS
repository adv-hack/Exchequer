unit Base36;

interface

Const
  MaxB36Num = (36 * 36 * 36 * 36) - 1;

{ Encodes a longint as a four digit base-36 number }
Function Encode36 (Const LongNum : LongInt;
                   Var   B36Str  : ShortString) : Boolean;

{ Decodes a four digit base36 string into a longint }
Function Decode36 (Const B36Str  : ShortString;
                   Var   LongNum : LongInt) : Boolean;

implementation

Const
  B36Num2  = 36;
  B36Num3  = 36 * 36;
  B36Num4  = 36 * 36 * 36;

  B36Set   = ['0'..'9', 'A'..'Z'];
  B36Chars : Array [0..35] Of Char =
             ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
              'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
              'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
              'U', 'V', 'W', 'X', 'Y', 'Z');

{ Encodes a longint as a four digit base-36 number }
Function Encode36 (Const LongNum : LongInt;
                   Var   B36Str  : ShortString) : Boolean;
Var
  CalcNum, I : LongInt;
Begin { Encode36 }
  B36Str := '0000';
  Result := False;

  If (LongNum >= 0) And (LongNum <= MaxB36Num) Then Begin
    CalcNum := LongNum;

    If (CalcNum >= B36Num4) Then Begin
      I := CalcNum Div B36Num4;
      B36Str[1] := B36Chars[I];
      CalcNum := CalcNum Mod B36Num4;
    End; { If }

    If (CalcNum >= B36Num3) Then Begin
      I := CalcNum Div B36Num3;
      B36Str[2] := B36Chars[I];
      CalcNum := CalcNum Mod B36Num3;
    End; { If }

    If (CalcNum >= B36Num2) Then Begin
      I := CalcNum Div B36Num2;
      B36Str[3] := B36Chars[I];
      CalcNum := CalcNum Mod B36Num2;
    End; { If }

    If (CalcNum >= 0) And (CalcNum < 36) Then Begin
      B36Str[4] := B36Chars[CalcNum];

      Result := True;
    End { If }
    Else Begin
      { Something has cocked up }
      Result := False;
    End; { Else }
  End; { If }
End; { Encode36 }


{ Decodes a four digit base36 string into a longint }
Function Decode36 (Const B36Str  : ShortString;
                   Var   LongNum : LongInt) : Boolean;

  Function CharToB36 (Const TheChar : Char) : LongInt;
  Begin { CharToB36 }
    If (TheChar In ['0'..'9']) Then
      Result := Ord (TheChar) - Ord('0')
    Else
      Result := 10 + Ord (TheChar) - Ord('A');
  End; { CharToB36 }

Begin { Decode36 }
  Result := False;
  LongNum := 0;

  If (Length(B36Str) = 4) Then Begin
    { Got right number of characters - a good start }
    If (B36Str[1] In B36Set) And (B36Str[2] In B36Set) And
       (B36Str[3] In B36Set) And (B36Str[4] In B36Set) Then Begin

       LongNum :=           (CharToB36 (B36Str[1]) * B36Num4);
       LongNum := LongNum + (CharToB36 (B36Str[2]) * B36Num3);
       LongNum := LongNum + (CharToB36 (B36Str[3]) * B36Num2);
       LongNum := LongNum +  CharToB36 (B36Str[4]);

       Result := True;
    End; { If }
  End; { If }

  { Debugging to test error detection }
  {If (LongNum = 42572) Then LongNum := 98;}
End; { Decode36 }



end.
