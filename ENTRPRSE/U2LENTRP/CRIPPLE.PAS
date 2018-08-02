unit Cripple;

{ prutherford440 08:53 25/03/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{ This module contains routines called by the U2L to format data  }
{ so it can call the normal Ent* functions. If these routines are }
{ placed in the U2L Crystal Reports will crash. QED - Cripple     }

Function DoubleToInt2 (Const TheDub : Double;
                       Var   Int2   : SmallInt) : SmallInt; StdCall;
Function DoubleToInt4 (Const TheDub : Double;
                       Var   Int4   : LongInt) : SmallInt; StdCall;

implementation

Uses Dialogs, SysUtils;


{ Converts a Crystal Double to a 2-Byte Integer }
Function DoubleToInt2 (Const TheDub : Double;
                       Var   Int2   : SmallInt) : SmallInt;
Const
  Min_I2 : Double = -32768.0;
  Max_I2 : Double =  32767.0;
Var
  WorkDub : Double;
Begin
  Int2 := 0;
  Result := 0;

  { Copy Into local variable for modification }
  WorkDub := TheDub / 100;

  { Check its in the correct range }
  If (WorkDub >= Min_I2) And (WorkDub <= Max_I2) Then
    Int2 := Trunc(WorkDub)
  Else
    Result := 800;
End;


{ Converts a Crystal Double to a 4-Byte Integer }
Function DoubleToInt4 (Const TheDub : Double;
                       Var   Int4   : LongInt) : SmallInt;
Const
  Min_I4 : Double = -2147483648.0;
  Max_I4 : Double =  2147483647.0;
Var
  WorkDub : Double;
Begin
  Int4 := 0;
  Result := 0;

  { Copy Into local variable for modification }
  WorkDub := TheDub / 100;

  { Check its in the correct range }
  If (WorkDub >= Min_I4) And (WorkDub <= Max_I4) Then
    Int4 := Trunc(WorkDub)
  Else
    Result := 801;
End;

end.
