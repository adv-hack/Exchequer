{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit NDRVStrings;

interface

{$I NDDefines.inc}

uses
	Classes;

// Procs
  function AddBackSlash(const S: string): string;
  function ElimNullChars(const AData: string): string;
  function FilterChars(const AInput, AFilter: string): string;
  function FilterCharsAlphaNumeric(const AInput: string): string;
  function FilterCharsText(const AInput: string): string;
  function InvParseCommaString(slst: TStrings):string;
  function LastChar(const AValue: string): string;
  procedure ParseCommaString(slst:TStrings;const strIn:string);
  function Pluck(const psSearchIn: string; psStart, psEnd: String; const pbIgnoreCase: boolean): String;
  function TrimWhiteSpace(const psString: string): string;
  //
  function Fetch(var s1: string; const asDelim: string = ' '; const ADelete: Boolean = true): string;
  function Pad(const s: string; piCount: Integer; const pcPadChar: Char = ' '): string;
{$IFDEF VER120}
  function SameText(S1,S2: string): boolean;
{$ENDIF}

implementation

uses
  SysUtils;

var
  gsTextFilter: string;

function ElimNullChars(const AData: string): string;
var
  nPos: integer;
begin
  result := AData;
  repeat
    nPos := Pos(#0, result);
    if nPos = 0 then begin
      break;
    end;
    Delete(result, nPos, 1);
  until false;
end;

function LastChar(const AValue: string): string;
begin
  result := Copy(AValue, Length(AValue), 1);
end;

function InvParseCommaString(slst: TStrings):string;
var
	intIndex:integer;
begin
  // Take a stringlist and returns a string seperating items with commas
	result := '' ;
	for intIndex := 0 to Pred ( slst.Count ) do
  	result := result + slst.Strings[intIndex] + ',' ;
  result := Copy ( result, 1, Length (result) - 1 );
end ;

procedure ParseCommaString(slst:TStrings;const strIn:string);
var
    intStart,
    intEnd,
		intQuote,
    intPos,
    intLength : integer ;
    strTemp : string ;
begin
    intQuote := 0;
    intPos := 1 ;
    intLength := Length ( strIn ) ;
    slst.Clear ;
    while ( intPos <= intLength ) do
    	begin
      	intStart := intPos ;
        intEnd := intStart ;
        while ( intPos <= intLength ) do
        	begin
          	if strIn [ intPos ] = '"' then
            	inc(intQuote);
          	if strIn[ intPos ]= ',' then
            	if intQuote <> 1 then
              	break;
						inc ( intEnd ) ;
            inc ( intPos ) ;
          end ;
      strTemp := Trim ( Copy ( strIn , intStart , intEnd - intStart ) ) ;
      if strTemp <> '' then
      	slst.Add ( strTemp );
      intPos := intEnd + 1 ;
      intQuote := 0 ;
    end ;
end;

function Pluck;
var
  iStart, iEnd: integer;
  s: string;
begin
  if pbIgnoreCase then begin
    s := Uppercase(psSearchIn);
    psStart := Uppercase(psStart);
    psEnd := Uppercase(psEnd);
  end else begin
    s := psSearchIn;
  end;

  Result := '';
  iStart := Pos(psStart, s);

	iEnd := Pos(psEnd, Copy(s, iStart + Length(psStart), MaxInt)) + iStart;
  if iStart + iEnd > 0 then
 		Result := Copy(psSearchIn, iStart +  Length(psStart), iEnd - iStart-length(psEnd));
end;

function Pad;
begin
  if piCount < Length(S) then begin
    piCount := Length(S);
  end;
  SetLength(Result, piCount);
  FillChar(Result[1], piCount, pcPadChar);
  Move(S[1], Result[1], Length(S));
end;

function AddBackSlash(const S: string): string;
begin
  Result := S;
  if Copy(Result, Length(Result), 1) <> '\' then begin
    Result := Result + '\';
  end;
end;

Function Fetch;
var
	iPos: Integer;
begin
	iPos := Pos(asDelim, s1);
	if iPos = 0 then begin
		Result := s1;
    if ADelete then begin
    	s1 := '';
    end;
	end else begin
		result := Copy(s1, 1, iPos - 1);
    if ADelete then begin
			Delete(s1, 1, iPos + Length(asDelim) - 1);
    end;
	end;
end;

function TrimWhitespace;
begin
  result := psString;
  {TODO Improve this - too many delets/setlenghts}
  while length(result) > 0 do begin
    if Ord(result[1]) < 33 then
      Delete(result, 1, 1)
    else
      break;
  end;
  while length(result) > 0 do begin
    if Ord(result[Length(result)]) < 33 then
      SetLength(result, Length(result) - 1)
    else
      break;
  end;
end;

function FilterCharsAlphaNumeric(const AInput: string): string;
begin
  result := FilterChars(AInput, 'ABCDDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890 ');
end;

function FilterChars(const AInput, AFilter: string): string;
{TODO Improve this, this is not very efficient}
var
	i: integer;
begin
  result := AInput;
	for i := Length(AInput) downto 1 do begin
  	if Pos(result[i], AFilter) = 0 then begin
      Delete(result, i, 1);
    end;
  end;
end;

function FilterCharsText(const AInput: string): string;
var
  i: integer;
begin
  if length(gsTextFilter) = 0 then begin
    for i := 32 to 127 do begin
      SetLength(gsTextFilter, 127 - 32 + 1);
      gsTextFilter[i - 31] := Chr(i);
    end;
  end;
  result := FilterChars(AInput, gsTextFilter);
end;

{$IFDEF VER120}
function SameText(S1,S2: string): boolean;
begin { SameText }
  Result := (CompareText(S1,S2) = 0);
end;  { SameText }
{$ENDIF}

end.