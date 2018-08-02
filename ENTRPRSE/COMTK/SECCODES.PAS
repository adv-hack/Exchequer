unit SecCodes;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses SysUtils;

// Converts an OpCode into three encoded Long Integers which can be
// internally validated and decoded using the DecodeOpCode function below
Procedure EncodeOpCode (Const OpCode : Byte; Var Long1, Long2, Long3 : LongInt); StdCall;

// Extracts and validates an encoded OpCode stored in three encoded
// Long Integers which was encoded using the EncodeOpCode function above
Function DecodeOpCode (Var OpCode : Byte; Const Long1, Long2, Long3 : LongInt) : Boolean; StdCall;


implementation

Type
  RemapType = Packed Array [1..3, 1..4] Of Byte;

//-------------------------------------------------------------------------

// Calculates the total value of today's date as a string and stores
// it in the module variable CalcDateVal : Byte;
Function CalcDateVal (Const TheDate : TDateTime) : Byte;
Var
  DateStr : ShortString;
Begin // CalcDateVal
  // Format date into a string
  DateStr := FormatDateTime ('DD/MM/YYYY', TheDate);

  // Sum the numbers within that date string
  Result := StrToInt(DateStr[1]) +    // D
            StrToInt(DateStr[2]) +    // D
            StrToInt(DateStr[4]) +    // M
            StrToInt(DateStr[5]) +    // M
            StrToInt(DateStr[7]) +    // Y
            StrToInt(DateStr[8]) +    // Y
            StrToInt(DateStr[9]) +    // Y
            StrToInt(DateStr[10]);    // Y
End; // CalcDateVal

//----------------------------------------------------------------------------

// Converts an OpCode into three encoded Long Integers which can be
// internally validated and decoded using the DecodeOpCode function below
Procedure EncodeOpCode (Const OpCode : Byte; Var Long1, Long2, Long3 : LongInt);
Var
  LongArray : Packed Array [1..3] Of LongInt;
  ByteArray : ^RemapType;
  TmpByte   : Byte;
begin { EncodeOpCode }
  If (OpCode <= 220) Then Begin
    // Overlay ByteArray on top of LongArray
    ByteArray := @LongArray;

    Randomize;

    // LongArray[1]
    ByteArray^[1,1] := Random(255);                             // Rnd1
    ByteArray^[1,2] := Random(200);                             // Rnd2
    ByteArray^[1,3] := Random(255);                             // Rnd3
    ByteArray^[1,4] := Random(30) + OpCode;                     // Rnd4 + OpCode

    // LongArray[2]
    ByteArray^[2,1] := ByteArray^[1,2] + CalcDateVal(Now);      // Rnd2 + DateVal
    ByteArray^[2,2] := ByteArray^[1,1] OR ByteArray^[1,3];      // Rnd1 OR Rnd3
    ByteArray^[2,3] := ByteArray^[1,2] AND ByteArray^[1,4];     // Rnd2 AND OpCode
    ByteArray^[2,4] := ByteArray^[1,4] - OpCode;                // Rnd4

    // LongArray[3]
    ByteArray^[3,1] := NOT (ByteArray^[1,3] AND ByteArray^[1,4]); // Not (Rnd3 Or (Rnd4 + OpCode))

    // HM 29/08/01: Moved calculation into local byte as compiler as using integer
    //              which was causing a range check error
    TmpByte := ByteArray^[1,4] - ByteArray^[2,4];
    ByteArray^[3,2] := NOT TmpByte;   // NOT (OpCode)

    ByteArray^[3,3] := ByteArray^[1,1] AND ByteArray^[1,3];       // Rnd1 AND Rnd3
    ByteArray^[3,4] := ByteArray^[3,1] AND ByteArray^[3,2] AND ByteArray^[3,3];

    // Return Longs in parameters
    Long1 := LongArray[1];
    Long2 := LongArray[2];
    Long3 := LongArray[3];
  End { If }
  Else
    Raise Exception.Create ('Invalid OpCode ' + IntToStr(OpCode));
end; { EncodeOpCode }

//----------------------------------------------------------------------------

// Extracts and validates an encoded OpCode stored in three encoded
// Long Integers which was encoded using the EncodeOpCode function above
Function DecodeOpCode (Var OpCode : Byte; Const Long1, Long2, Long3 : LongInt) : Boolean;

  Function Decode (Var OpCode : Byte; Const Long1, Long2, Long3 : LongInt; Const DateVal : Byte) : Boolean;
  Var
    LongArray : Packed Array [1..3] Of LongInt;
    ByteArray : ^RemapType;
  begin { Decode }
    // Copy Long parameters into LongArray
    LongArray[1] := Long1;
    LongArray[2] := Long2;
    LongArray[3] := Long3;

    // Overlay ByteArray on top of LongArray
    ByteArray := @LongArray;

    // Extract OpCode
    OpCode := NOT ByteArray^[3,2];

    // --------------------------  Validate integers  ---------------------------

              // ByteArray^[2,1] := ByteArray^[1,2] + DateVal
    Result := (ByteArray^[2,1] = (ByteArray^[1,2] + DateVal));

    If Result Then
      // ByteArray^[2,2] := ByteArray^[1,1] OR ByteArray^[1,3]
      Result := (ByteArray^[2,2] = (ByteArray^[1,1] OR ByteArray^[1,3]));

    If Result Then
      // ByteArray^[2,3] := ByteArray^[1,2] AND ByteArray^[1,4]
      Result := (ByteArray^[2,3] = (ByteArray^[1,2] AND ByteArray^[1,4]));

    If Result Then
      // ByteArray^[2,4] := ByteArray^[1,4] - OpCode
      Result := (ByteArray^[2,4] = (ByteArray^[1,4] - OpCode));

    If Result Then
      // ByteArray^[3,1] := NOT (ByteArray^[1,3] AND ByteArray^[1,4])
      Result := (ByteArray^[3,1] = NOT (ByteArray^[1,3] AND ByteArray^[1,4]));

    // ByteArray^[3,2] := NOT (ByteArray^[1,4] - ByteArray^[2,4])
    // Already done as OpCode

    If Result Then
      // ByteArray^[3,3] := ByteArray^[1,1] AND ByteArray^[1,3]
      Result := (ByteArray^[3,3] = (ByteArray^[1,1] AND ByteArray^[1,3]));

    If Result Then
      // ByteArray^[3,4] := ByteArray^[3,1] AND ByteArray^[3,2] AND ByteArray^[3,3]
      Result := (ByteArray^[3,4] = ByteArray^[3,1] AND ByteArray^[3,2] AND ByteArray^[3,3]);
  end; { Decode }

Begin // DecodeOpCode
  // Try decoding for today's date
  Result := Decode (OpCode, Long1, Long2, Long3, CalcDateVal(Now));

  // If failed try for yesterday - just in case we passed over midnight between encoding and decoding
  If (Not Result) Then Result := Decode (OpCode, Long1, Long2, Long3, CalcDateVal(Now-1));
End; // DecodeOpCode

//----------------------------------------------------------------------------

end.
