/////////////////////////////////////////////////
// Unit containing common Mathmatical routines //
/////////////////////////////////////////////////
unit MathUtil;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }
{$REALCOMPATIBILITY ON}

interface

  function SafeDiv(rNumToDiv, rDivider : real) : real;
  function ZeroFloat(Value : extended; iDP : byte = 3) : boolean;
  function LesserOf(i1, i2 : integer) : integer;
  function GreaterRealOf(r1, r2 : real) : real;
  procedure RealInc(var rReal : real; rIncBy : real = 1);
  procedure RealDec(var rReal : real; rDecBy : real = 1);
  procedure IntInc(var iInteger : integer; iIncBy : integer = 1);
  procedure IntDec(var iInteger : integer; iDecBy : integer = 1);
  function ZeroIfBool(rReal : Real; bBoolean : boolean) : real;
  function NumberIn(iNo : integer; aNos : array of integer) : boolean;
  function BitIsSet(iBitField : integer; iBit : longint) : boolean;
  function GetRealIf(bCondition : boolean; rTrue, rFalse : real) : real;

implementation
uses
  Math;

function SafeDiv(rNumToDiv, rDivider : real) : real;
// Divides one float by another. If the divider is zero it returns zero.
// Avoids divide by zero errors.
//
// rNumToDiv : the number to be divided.
// rDivider : the number to divide by.
begin
  if ZeroFloat(rDivider) then Result := 0
  else Result := rNumToDiv / rDivider;
end;

function ZeroFloat(Value : extended; iDP : byte = 3) : boolean;
// Post : Returns true if the floating point value is zero
//        to specifed number of decimal places
//const
//  DEC_PLACES = 3;
begin
  Result := round(Value * Power(10, iDP)) = 0;
end;

function LesserOf(i1, i2 : integer) : integer;
begin
  if i1 < i2 then Result := i1
  else Result := i2;
end;

function GreaterRealOf(r1, r2 : real) : real;
begin
  if r1 > r2 then Result := r1
  else Result := r2;
end;

procedure RealInc(var rReal : real; rIncBy : real);
begin
  rReal := rReal + rIncBy;
end;

procedure RealDec(var rReal : real; rDecBy : real);
begin
  rReal := rReal - rDecBy;
end;

procedure IntInc(var iInteger : integer; iIncBy : integer);
begin
  iInteger := iInteger + iIncBy;
end;

procedure IntDec(var iInteger : integer; iDecBy : integer);
begin
  iInteger := iInteger - iDecBy;
end;

function ZeroIfBool(rReal : Real; bBoolean : boolean) : real;
begin
  if bBoolean then Result := 0
  else Result := rReal;
end;

function NumberIn(iNo : integer; aNos : array of integer) : boolean;
// use this instead of the "in" function when using numbers larger than 255
// works out whether a number is in an array of numbers
var
  iPos : integer;
begin
  Result := FALSE;
  for iPos := Low(aNos) to High(aNos) do
  begin
    if iNo = aNos[iPos] then
    begin
      Result := TRUE;
      break;
    end;{if}
  end;{for}
end;

function BitIsSet(iBitField : integer; iBit : longint) : boolean;
begin
  Result := (iBitField AND iBit) = iBit;
end;

function GetRealIf(bCondition : boolean; rTrue, rFalse : real) : real;
begin
  if bCondition then Result := rTrue
  else Result := rFalse;
end;


end.

