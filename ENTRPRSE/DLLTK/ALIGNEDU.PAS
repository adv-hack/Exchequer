unit AlignedU;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{ ALIGN 1}  { Variable Alignment Disabled }


interface

Function GetAlignedInfo (Const InfoNum : Word) : LongInt;
Function CalcRecPos (Const RecPtr, FieldPtr : Pointer) : LongInt;

implementation

{$A2}
{$I ExchDll.Inc}
{$A-}

Function CalcRecPos (Const RecPtr, FieldPtr : Pointer) : LongInt;
Begin
  Result := LongInt (FieldPtr) - LongInt (RecPtr) + 1;
End;

{$I RecInfo.Inc}

Function GetAlignedInfo (Const InfoNum : Word) : LongInt;
Begin
  Result := RecInfo(InfoNum);
End;

end.
