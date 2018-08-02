unit Phonetic;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;

{ Converts a single character to its phonetic equivalent }
Function CharToPhonetic (TheChar : Char) : ShortString;

{ Converts a String to its phonetic equivalent }
Function StringToPhonetic (TheStr : ShortString) : ShortString;

implementation

{ Converts a single character to its phonetic equivalent }
Function CharToPhonetic (TheChar : Char) : ShortString;
Begin { CharToPhonetic }
  { Convert to Uppercase }
  TheChar := UpCase (TheChar);

  Case TheChar Of
    'A' : Result := 'Alpha';
    'B' : Result := 'Bravo';
    'C' : Result := 'Charlie';
    'D' : Result := 'Delta';
    'E' : Result := 'Echo';
    'F' : Result := 'Foxtrot';
    'G' : Result := 'Golf';
    'H' : Result := 'Hotel';
    'I' : Result := 'India';
    'J' : Result := 'Juliet';
    'K' : Result := 'Kilo';
    'L' : Result := 'Lima';
    'M' : Result := 'Mike';
    'N' : Result := 'November';
    'O' : Result := 'Oscar';
    'P' : Result := 'Papa';
    'Q' : Result := 'Quebec';
    'R' : Result := 'Romeo';
    'S' : Result := 'Sierra';
    'T' : Result := 'Tango';
    'U' : Result := 'Uniform';
    'V' : Result := 'Victor';
    'W' : Result := 'Whisky';
    'X' : Result := 'X-ray';
    'Y' : Result := 'Yankee';
    'Z' : Result := 'Zebra';     // NOTE: Changed as Zulu too close to Zero
    '0' : Result := 'Zero';
    '1' : Result := 'One';
    '2' : Result := 'Two';
    '3' : Result := 'Three';
    '4' : Result := 'Four';
    '5' : Result := 'Five';
    '6' : Result := 'Six';
    '7' : Result := 'Seven';
    '8' : Result := 'Eight';
    '9' : Result := 'Nine';
  Else
    Result := TheChar;
  End; { Case TheChar }
End; { CharToPhonetic }

{ Converts a String to its phonetic equivalent }
Function StringToPhonetic (TheStr : ShortString) : ShortString;
Var
  I : SmallInt;
Begin { StringToPhonetic }
  Result := '';

  { Remove any leading/trailing spaces }
  TheStr := Trim(TheStr);

  { Convert string (if there is one) }
  If (Length(TheStr) > 0) Then
    For I := 1 To Length (TheStr) Do
      Result := Result + CharToPhonetic(TheStr[I]) + '  ';

  { Remove trailing blank }
  Result := Trim(Result);
End; { StringToPhonetic }

end.
