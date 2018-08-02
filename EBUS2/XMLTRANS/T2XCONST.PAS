unit t2xconst;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Function ExtractChar(Const Value : WideString; Const ReturnChar : Char) : Char;
function LJVar(const Value : WideString; len : integer) : WideString;

implementation

// Extracts a single character from a COM WideString, Returns specified character if ''
Function ExtractChar(Const Value : WideString; Const ReturnChar : Char) : Char;
Var
  S : String[1];
Begin { ExtractChar }
  S := Copy (Value, 1, 1) + ReturnChar;
  Result := S[1];
End; { ExtractChar }

function LJVar(const Value : WideString; len : integer) : WideString;
begin
  Result := Value + StringOfChar(' ', len);
  Result := Copy(Result, 1, len);
end;


end.
