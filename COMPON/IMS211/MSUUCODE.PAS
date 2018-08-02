(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msuucode;

{$I msdef.inc}

interface

uses SysUtils, Classes,
{$IFDEF VCL}
     Forms,
{$ENDIF}
     msUtils;

function IsUUCodeStart(s : string) : boolean;
function UUPickFileName(s : string) : string;
procedure UUMakeBinData(const InStr : ShortString; var OutStr : ShortString);
procedure UUMakeTextData(const InStr : ShortString; var OutStr : ShortString);

implementation

{$IFNDEF WIN32}
uses ms16utls;
{$ENDIF}

const
  Table : string =
  '`!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';
  {12345678901234567890123456789012345678901234567890123456789012345}
  {         1         2         3         4         5         6     }

const
  MaxChars = 45;

function IsUUCodeStart(s : string) : boolean;
{ i.e. if the line is:
begin 666 filename.ext}
begin
  Result:=false;
  if (Copy(UpperCase(s),1,5)='BEGIN') and (Length(s)>=9) then
  begin
    Delete(s,1,5);
    s:=Trim(s);
    try
      StrToInt(Copy(s,1,3));
      Result:=true;
    except
      {Do Nothing}
    end;
  end;
end;

function UUPickFileName(s : string) : string;
var
  i : Integer;
begin
  Delete(s,1,10);
  if s[1]='"' then {if contains quotes}
  begin
    Delete(s,1,1);
    i:=Pos('"',s);
    if i>0 then
      Result:=Copy(s,1,i-1)
    else
      Result:='';
  end
  else
  begin
(*
    i:=Pos(' ',s);
    if i>0 then
      Result:=Copy(s,1,i-1)
    else
*)
      Result:=s;
  end;
end;

function ByteFromTable(Ch : Char) : byte;
var
  i : byte;
begin
  i:=1;
  while (Ch<>Table[i]) and (i<=64) do Inc(i);
  if i>64 then
  begin
    Result:=0;
    if Ch<>' ' then
      raise EInOutError.Create('Invalid Character');
  end
  else
   Result:=i-1;
end;

procedure UUMakeBinData(const InStr : ShortString; var OutStr : ShortString);
var
  i,j,k,b,m : word;
  InSLen : byte absolute InStr;
  ActualLen : byte;
  TheBits : TBits;
begin
  TheBits:=TBits.Create;
  TheBits.Size:=8*MaxChars+1;
  k:=0;
  ActualLen:=4*ByteFromTable(InStr[1]) div 3;
  if ActualLen<>(4*MaxChars div 3) then
    ActualLen:=InSLen-1;
  for i:=2 to ActualLen+1 do
  begin
    b:=ByteFromTable(InStr[i]);
    for j:=5 DownTo 0 do
    begin
      m:=1 shl j;
      if (b and m = m) then
        TheBits[k]:=true;
      Inc(k);
    end;
  end;
  k:=0;
  OutStr:='';
  for i:=1 to MaxChars do
  begin
    b:=0;
    for j:=7 DownTo 0 do
    begin
      if TheBits[k] then b:= b or (1 shl j);
      Inc(k);
    end;
    OutStr:=Concat(OutStr,Char(b));
  end;
  SetLength(OutStr,ByteFromTable(InStr[1]));
  TheBits.Free;
end;

procedure UUMakeTextData(const InStr : ShortString; var OutStr : ShortString);
var
  i,j,k,b,m : Integer;
{
  CheckSum : word;
}
  TheBits : TBits;
  s : string;
begin
  k:=0;
  TheBits:=TBits.Create;
  TheBits.Size:=8*MaxChars+1;
  for i:=1 to MaxChars do
  begin
    b:=Byte(InStr[i]);
    for j:=7 DownTo 0 do
    begin
      m:=1 shl j;
      if (b and m = m) then
        TheBits[k]:=true;
      Inc(k);
    end;
  end;
  s:=''; k:=0; m:=4*(MaxChars div 3);
  OutStr:='';
{
  CheckSum:=0;
}
  for i:=1 to m do
  begin
    b:=0;
    for j:=5 DownTo 0 do
    begin
      if TheBits[k] then b:= b or (1 shl j);
      Inc(k);
    end;
    OutStr:=Concat(OutStr,Table[b+1]);
{
    if FCheckSums then
      Inc(CheckSum,b);
}
  end;
  if Length(InStr)=MaxChars then SetLength(OutStr,4*MaxChars div 3)
    else SetLength(OutStr,4*Length(InStr) div 3 + 1);
{
  if FCheckSums then
    s:=Concat(s,Table[CheckSum mod 64 + 1]);
}
  OutStr:=Concat(Table[Length(InStr)+1],OutStr);
  TheBits.Free;
end;

end.
