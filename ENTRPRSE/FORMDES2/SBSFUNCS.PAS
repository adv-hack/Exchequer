unit sbsfuncs;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Function IIF (Const EvalBool : Boolean; Const TrueRes, FalseRes : Variant) : Variant;

implementation

Function IIF (Const EvalBool : Boolean; Const TrueRes, FalseRes : Variant) : Variant;
Begin { IIF }
  If EvalBool Then
    Result := TrueRes
  Else
    Result := FalseRes;
End;  { IIF }

end.
