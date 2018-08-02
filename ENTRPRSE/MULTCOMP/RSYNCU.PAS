unit RSyncU;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses SysUtils;

Function FindLastWeekDay (Const BaseDate : Double; Const ChangeBy : SmallInt) : Double;

Function CalcRSysnc (Const PwdNo                              : Byte;
                     Const TheDate                            : TDateTime;
                           ESN1, ESN2, ESN3, ESN4, ESN5, ESN6 : Int64) : ShortString;

// Calculates the old v4.31/v4.32 Resynch Companies Password
Function CalcRSysnc432 (Const TheDate                            : TDateTime;
                              ESN1, ESN2, ESN3, ESN4, ESN5, ESN6 : Int64) : ShortString;


implementation

//---------------------------------------------------------------------------

Function FindLastWeekDay (Const BaseDate : Double; Const ChangeBy : SmallInt) : Double;
Var
  YearStart, TestDate : Double;
  WeekNo, DD, MM, YY  : Word;
begin { FindLastWeekDay }
  // split date into constituent parts
  DecodeDate (BaseDate, YY, MM, DD);

  // Determine start of year for date - allows cross year operation
  YearStart := EncodeDate (YY, 1, 1);

  // Determine week within calendar year of date
  WeekNo := Trunc(BaseDate - YearStart) Div 7;

  // Run through dates to determine end of 'week'
  TestDate := BaseDate;
  While True Do Begin
    // split date into constituent parts
    DecodeDate (TestDate, YY, MM, DD);

    // Determine start of year for date - allows cross year operation
    YearStart := EncodeDate (YY, 1, 1);

    // Determine week within calendar year of date
    If ((Trunc(TestDate - YearStart) Div 7) <> WeekNo) Then Begin
      // Week number changed - yesterday was end of week
      Result := TestDate - ChangeBy;
      Break;
    End; { If }

    TestDate := TestDate + ChangeBy;
  End; { While True }
end; { FindLastWeekDay }

//---------------------------------------------------------------------------

Function CalcRSysnc (Const PwdNo                              : Byte;
                     Const TheDate                            : TDateTime;
                           ESN1, ESN2, ESN3, ESN4, ESN5, ESN6 : Int64): ShortString;
Const
  RetChars : Array [0..33] Of Char = ('6', 'C', 'Z', 'H', 'F', '7', 'J', 'P', '3',
                                      'V', 'B', 'E', '0', 'K', 'D', '9', 'L', 'X',
                                      '5', 'Q', 'N', '1', 'Y', 'M', 'R', '8', 'W',
                                      'G', 'S', '2', 'U', 'A', '5', 'T');
Var
  Y, M, D, YearNo : Word;
  WeekNo, X : Int64;
Begin { CalcRSync }
  Result := '';

  If (ESN1 < 1) Then ESN1 := 1;
  If (ESN2 < 1) Then ESN2 := 1;
  If (ESN3 < 1) Then ESN3 := 1;
  If (ESN4 < 1) Then ESN4 := 1;
  If (ESN5 < 1) Then ESN5 := 1;
  If (ESN6 < 1) Then ESN6 := 1;

  // Decode specified date into separate elements
  DecodeDate (TheDate, Y, M, D);
  WeekNo := Trunc(TheDate - EncodeDate (Y, 1, 1)) Div 7;
  YearNo := Y - 1997;

  // Character 1
  X := (ESN1 + ESN2 + ESN3 + ESN4 + ESN5 + ESN6 + PwdNo) Mod 34;
  Result := Result + Retchars[X];

  // Character 2
  X := (ESN1 * ESN2 * ESN3 * ESN4 * ESN5 * ESN6 * PwdNo) Mod 34;
  Result := Result + Retchars[X];

  // Character 3
  X := Abs(((ESN1 * (73 - PwdNo)) + (ESN5 * (79 + PwdNo)) + (WeekNo + 2)) Mod 34);
  Result := Result + Retchars[X];

  // Character 4
  X := (((ESN3 + 104 + PwdNo) * (ESN6 + PwdNo + 37) * (M + 2)) - (YearNo + WeekNo + 1)) Mod 34;
  Result := Result + Retchars[X];

  // Character 5
  X := ((ESN2 + 35) * (ESN4 + 71) * ((M * WeekNo * PwdNo) + 2)) Mod 34;
  Result := Result + Retchars[X];

  // Character 6
  X := (M + WeekNo + PwdNo) Mod 34;
  Result := Result + Retchars[X];
End; { CalcRSync }

//---------------------------------------------------------------------------

Function CalcRSysnc432 (Const TheDate                            : TDateTime;
                              ESN1, ESN2, ESN3, ESN4, ESN5, ESN6 : Int64) : ShortString;
Var
  Y, M, D, YearNo : Word;
  WeekNo, X : Int64;
Begin { CalcRSync432 }
  Result := '';

  If (ESN1 < 1) Then ESN1 := 1;
  If (ESN2 < 1) Then ESN2 := 1;
  If (ESN3 < 1) Then ESN3 := 1;
  If (ESN4 < 1) Then ESN4 := 1;
  If (ESN5 < 1) Then ESN5 := 1;
  If (ESN6 < 1) Then ESN6 := 1;

  // Decode specified date into separate elements
  DecodeDate (TheDate, Y, M, D);
  WeekNo := Trunc(TheDate - EncodeDate (Y, 1, 1)) Div 7;
  YearNo := Y - 1997;

  // Character 1
  X := (ESN1 + ESN2 + ESN3 + ESN4 + ESN5 + ESN6) Mod 26;
  Result := Result + Chr(65 + X);

  // Character 2
  X := (ESN1 * ESN2 * ESN3 * ESN4 * ESN5 * ESN6) Mod 26;
  Result := Result + Chr(65 + X);

  // Character 3
  X := ((ESN1 * 73) + (ESN5 * 79) + (WeekNo + 2)) Mod 26;
  Result := Result + Chr(65 + X);

  // Character 4
  X := (((ESN3 + 104) * (ESN6 + 37) * (M + 2)) - (YearNo + WeekNo + 1)) Mod 24;
  Result := Result + Chr(65 + X);

  // Character 5
  X := ((ESN2 + 35) * (ESN4 + 71) * ((M * WeekNo) + 2)) Mod 24;
  Result := Result + Chr(65 + X);

  // Character 6
  X := (M + WeekNo) Mod 24;
  Result := Result + Chr(65 + X);
End; { CalcRSync432 }


end.

