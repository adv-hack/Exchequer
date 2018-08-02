unit ExpUtil;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface
  function CheckFilter(Filter, Value : string; Flag : byte) : boolean;

implementation
uses
  SysUtils;

function CheckFilter(Filter, Value : string; Flag : byte) : boolean;
begin
  Filter := UpperCase(Filter);
  Value := UpperCase(Value);
  case Flag of
    0 : Result := TRUE;
    1 : Result := Value = Filter;
    2 : Result := not (Value = Filter);
    3 : Result := Pos(Filter, Value) <> 0;
    4 : Result := Pos(Filter, Value) = 0;
    else Result := FALSE;
  end;{case}
end;


end.
 