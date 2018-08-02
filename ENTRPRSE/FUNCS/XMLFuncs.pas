unit XMLFuncs;

// PKR. 09/04/2015.
// New functions added to overcome ABSEXCH-16104, but implemented as a utility unit
//  for general use. 

interface

function WebEncode(Const PlainText : ShortString) : ShortString;
function WebDecode(Const WebText : ShortString) : ShortString;
function HTTPEncode(const AStr: string): string;


implementation

uses
  SysUtils;

//------------------------------------------------------------------------------
// Please extend this as required
//
function WebEncode(Const PlainText : ShortString) : ShortString;
Var
  Index : SmallInt;
Begin
  Result := '';
  For Index := 1 To Length(PlainText) Do
  Begin
    Case PlainText[Index] Of
      '<'  : Result := Result + '&lt;';
      '>'  : Result := Result + '&gt;';
      '"'  : Result := Result + '&quot;';
      '&'  : Result := Result + '&amp;';
      '''' : Result := Result + '&apos;';
    Else
      Result := Result + PlainText[Index];
    End; // Case PlainText[Index]
  End; // For Index
End;

//------------------------------------------------------------------------------
function WebDecode(Const WebText : ShortString) : ShortString;
Begin
  Result := WebText;
  // Brute force method replaces known web encoded strings back to single characters
  Result := StringReplace(Result, '&lt;',   '<', [rfReplaceAll]);
  Result := StringReplace(Result, '&gt;',   '>', [rfReplaceAll]);
  Result := StringReplace(Result, '&quot;', '"', [rfReplaceAll]);
  Result := StringReplace(Result, '&amp;',  '&', [rfReplaceAll]);
  Result := StringReplace(Result, '&apos;', '''', [rfReplaceAll]);
End;

//------------------------------------------------------------------------------
// This version converts characters to the %XX format, where XX is the hexadecimal representation
function HTTPEncode(const AStr: string): string;
const
  NoConversion = ['A'..'Z', 'a'..'z', '*', '@', '.', '_', '-'];
var
  Sp, Rp: PChar;
begin
  SetLength(Result, Length(AStr) * 3);
  Sp := PChar(AStr);
  Rp := PChar(Result);
  while Sp^ <> #0 do
  begin
    if Sp^ in NoConversion then
      Rp^ := Sp^
    else if Sp^ = ' ' then
      Rp^ := '+'
    else
    begin
      FormatBuf(Rp^, 3, '%%%.2x', 6, [Ord(Sp^)]);
      Inc(Rp, 2);
    end;
    Inc(Rp);
    Inc(Sp);
  end;
  SetLength(Result, Rp - PChar(Result));
end;

end.
