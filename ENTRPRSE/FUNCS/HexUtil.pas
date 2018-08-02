unit HexUtil;

interface

type
  T8Bits = array [1..8] of Boolean;

  function HexStrToDecInt(sHex : string) : integer;
  function HexStrTo8Bits(sHex : string) : T8Bits;

implementation
uses
  Math, SysUtils;

function HexStrToDecInt(sHex : string) : integer;
var
  iPos, iNumber, iPower : integer;
  rResult : extended;
begin
  rResult := 0;
  For iPos := 1 to Length(sHex) do
  begin
    iPower := Length(sHex) - iPos;
    case sHex[iPos] of
      '0'..'9' : iNumber := StrToInt(sHex[iPos]);
      'A', 'a' : iNumber := 10;
      'B', 'b' : iNumber := 11;
      'C', 'c' : iNumber := 12;
      'D', 'd' : iNumber := 13;
      'E', 'e' : iNumber := 14;
      'F', 'f' : iNumber := 15;
    end;{case}
    rResult := rResult + (iNumber * (Power(16, iPower)));
  end;{for}
  Result := Round(rResult);
end;

function HexStrTo8Bits(sHex : string) : T8Bits;
var
  iDec, iRem, iPos, iFlag : integer;
begin
  iDec := HexStrToDecInt(sHex);
  iRem := iDec;
  For iPos := 8 downto 1 do
  begin
     iFlag := Round(Power(2, iPos - 1));
     if iRem >= iFlag then
     begin
       iRem := iRem - iFlag;
       Result[iPos] := TRUE;
     end else
     begin
       Result[iPos] := FALSE;
     end;{if}
  end;{for}
end;

end.
