unit FDUtils;

interface

uses
  SysUtils;

function InchesToMillimeters(Inches : Double) : Double;
function MillimetersToInches(Millimeters : Double) : Double;
{$IFNDEF Win32}
function Trim(S : string) : string;
{$ENDIF}

implementation

const
  InchesPerMeter = 39.37;

function InchesToMillimeters(Inches : Double) : Double;
begin
  Result := Inches / InchesPerMeter * 1000.0;
end;

function MillimetersToInches(Millimeters : Double) : Double;
begin
  Result := Millimeters * InchesPerMeter / 1000.0;
end;

{$IFNDEF Win32}
function Trim(S : string) : string;
var
  I : Byte;
begin
  {Remove all leading spaces}
  while (Length(S) >= 1) and (S[1] = ' ') do
    Delete(S, 1, 1);

  {Remove all trailing spaces}
  for I := Length(S) downto 1 do
    if S[I] = ' ' then
      Delete(S, I, 1)
    else
      Break;

  Result := S;
end; 
{$ENDIF}

end.
