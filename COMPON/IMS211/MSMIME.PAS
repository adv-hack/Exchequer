(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msmime;

{$I msDef.inc}

interface

uses
  Windows, Classes, SysUtils,
{$IFDEF VCL}
  Forms,
{$ENDIF}
  msDef, msUtils;

type
  TQuotedPrintable = class
  private
    { Private declarations }
  protected
    { Protected declarations }
    Stream : TStream;
    Lines : TStrings;
    procedure ReplaceHiChars(var s : ShortString; Wrapped : boolean);
    procedure ReplaceHex(var s : ShortString);
    procedure ReformatParagraph(Buf : PChar; Len : Integer;
               TL : TStringList);
  public
    { Public declarations }
    Canceled : boolean;
    constructor Create(AStream : TStream; ALines : TStrings);
    procedure Encode;
    procedure Decode;
  end;

procedure MakeBinData(const InStr : ShortString; var OutStr : ShortString);
procedure MakeTextData(const InStr : ShortString; var OutStr : ShortString);

{$IFDEF DECODEHEADERS}  {See msdef.inc}
function DecodeHeader(const InStr : ShortString) : ShortString;
{$ENDIF}
function EncodeHeader(const InStr : ShortString) : ShortString;

implementation

const
  Table : string =
  'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
{  1234567890123456789012345678901234567890123456789012345678901234 }
{           1         2         3         4         5         6     }

{$IFNDEF OLDENCODING}

function ByteFromTable(Ch : Char) : byte;
begin
  if (Ch>='A') and (Ch<='Z') then
    Result:=Ord(Ch)-65
  else
  if (Ch>='a') and (Ch<='z') then
    Result:=Ord(Ch)-97+26
  else
  if (Ch>='0') and (Ch<='9') then
    Result:=Ord(Ch)-48+52
  else
  if Ch='+' then
    Result:=62
  else
  if Ch='/' then
    Result:=63
  else
  if Ch='=' then
    Result:=$FF
  else
   raise EInOutError.Create('Invalid Character');
end;

procedure MakeBinData(const InStr : ShortString; var OutStr : ShortString);
var
  i,j : Integer;
  l : LongInt;
  InSLen : byte absolute InStr;
  OutSLen : byte absolute OutStr;
begin
  if (InStr='') or (InStr='.') then
  begin
    OutStr:='';
    Exit;
  end;
{$IFDEF VCL}
  Application.ProcessMessages;
{$ENDIF}
  i:=1; OutStr:='';
  while i<=InSLen do
  begin
    l:=0;
    for j:=1 to 4 do
    begin
      l:=l shl 6;
      l:=ByteFromTable(InStr[i+j-1]) or l;
    end;
    for j:=2 DownTo 0 do
      OutStr:=Concat(OutStr,Char((l shr (8*j)) and $000000FF));
    Inc(i,4);
  end;
{if was padded, remove trailing zeros}
  i:=0; j:=InSLen;
  while InStr[j]='=' do
  begin
    Inc(i); Dec(j);
  end;
  Delete(OutStr,OutSLen-i+1,i);
end;

procedure MakeTextData(const InStr : ShortString; var OutStr : ShortString);
var
  i,j,k : Integer;
  l : LongInt;
  InSLen : byte absolute InStr;
  OutSLen : byte absolute OutStr;
  ss : string;
begin
{$IFDEF VCL}
  Application.ProcessMessages;
{$ENDIF}
  i:=1; OutStr:='';
  while i<=InSLen do
  begin
    l:=0;
    if i+2<=InSLen then k:=3
      else k:=(InSLen-i+1);
    for j:=1 to k do
    begin
      l:=l shl 8;
      l:=Byte(InStr[i+j-1]) or l;
    end;
    for j:=k+1 to 3 do {Pad with zeros}
      l:=4*l;
    ss:='';
    for j:=0 to k do
      ss:=Concat(ss,Table[((l shr (6*j)) and $0000003F)+1]);
    for j:=Length(ss) downto 1 do
      OutStr:=Concat(OutStr,ss[j]);
    Inc(i,k);
  end;
  while (OutSLen mod 4)<>0 do
    OutStr:=Concat(OutStr,'=');
end;

{$ELSE}

function ByteFromTable(Ch : Char) : byte;
var
  i : byte;
begin
  i:=1;
  while (Ch<>Table[i]) and (i<=64) do Inc(i);
  if i>64 then
  begin
    Result:=0;
    if Ch<>'=' then
    begin
      raise EInOutError.Create('Invalid Character');
    end
  end
  else
    Result:=i-1;
end;

procedure MakeBinData(const InStr : ShortString; var OutStr : ShortString);
var
  TheBits : TBits;
  i,j,k,l,m : Integer;
  b : byte;
  InSLen : byte absolute InStr;
  OutSLen : byte absolute OutStr;
begin
  if (InStr='') or (InStr='.') then
  begin
    OutStr:='';
    Exit;
  end;
  TheBits:=TBits.Create;
  TheBits.Size:=8*InSLen;
  k:=0;
  for i:=1 to InSLen do
  begin
    b:=ByteFromTable(InStr[i]);
    for j:=5 DownTo 0 do
    begin
      m:=1 shl j;
      if (b and m = m) then
        TheBits.Bits[k]:=true;
      Inc(k);
    end;
  end;
  OutStr:='';
  l:=k-1; k:=0;
  repeat
    b:=0;
    for j:=7 DownTo 0 do
    begin
      if TheBits.Bits[k] then b:= b or (1 shl j);
      Inc(k);
    end;
    OutStr:=Concat(OutStr,Char(b));
  until k>l;
  TheBits.Free;
  i:=InSLen;
  while InStr[i]='=' do
  begin
    Dec(OutSLen);
    Dec(i);
  end;
end;

procedure MakeTextData(const InStr : ShortString; var OutStr : ShortString);
var
  TheBits : TBits;
  i,j,k,l,m : Integer;
  b : byte;
  InSLen : byte absolute InStr;
  OutSLen : byte absolute OutStr;
begin
  TheBits:=TBits.Create;
  TheBits.Size:=8*InSLen;
  k:=0;
  for i:=1 to InSLen do
  begin
    b:=byte(InStr[i]);
    for j:=7 DownTo 0 do
    begin
      m:=1 shl j;
      if (b and m = m) then
        TheBits.Bits[k]:=true;
      Inc(k);
    end;
  end;
  l:=k-1; k:=0;
  OutStr:='';
  repeat
    b:=0;
    for j:=5 DownTo 0 do
    begin
      if (k<=l) and TheBits.Bits[k] then b:= b or (1 shl j);
      Inc(k);
    end;
    OutStr:=Concat(OutStr,Table[b+1]);
  until k>l;
  TheBits.Free;
  while (OutSLen mod 4)<>0 do
    OutStr:=Concat(OutStr,'=');
end;
{$ENDIF}

{$IFDEF DECODEHEADERS}
procedure DecodeQP(const InStr : ShortString; var OutStr : ShortString); forward;

function DecodeHeader(const InStr : ShortString) : ShortString;
var
  i,l,r : Integer;
  s1,s2,s3,s : ShortString;
  CharSet : ShortString;
  Encoding : Char;
  Found : boolean;
begin
  Result:=InStr;
  while Pos('=?',Result)<>0 do
  begin
    l:=Pos('=?',Result);
  {Find next '?=', but if it is not preceeded by ?Q or ?B}
    r:=l;
    repeat
      Found:=(r>2) and (r<=Length(Result)) and (Result[r]='?') and (Result[r+1]='=')
        and not ((Result[r-2]='?') and (Result[r-1] in ['Q','B']));
      Inc(r);
    until Found or (r=Length(Result));
    if Found then Dec(r) else Exit;
    s1:=Copy(Result,1,l-1);
    s2:=Copy(Result,r+2,Length(Result));
    s:=Copy(Result,l+2,r-l-2);
    l:=Pos('?',s);
    CharSet:=Copy(s,1,l-1);
    Delete(s,1,l);
    Encoding:=s[1];
    Delete(s,1,2);
    if UpCase(Encoding)='B' then
      MakeBinData(s,s3)
    else
    if UpCase(Encoding)='Q' then
      DecodeQP(s,s3);
    Result:=Concat(s1,s3,Trim(s2));
    for i:=1 to Length(Result) do
      if Result[i]='_' then Result[i]:=' ';
  end;
end;
{$ENDIF}
{$IFDEF DECODEHEADERS}
function EncodeHeader(const InStr : ShortString) : ShortString;
var
  s : ShortString;
begin
  if (Length(InStr)>0) and (InStr[1]=#27) then
  begin
    MakeTextData(InStr,s);
    Result:='=?ISO-2022-JP?B?'+s+'?=';
  end
  else
    Result:=InStr;
end;
{$ELSE}
function EncodeHeader(const InStr : ShortString) : ShortString;
begin
  Result:=InStr;
end;
{$ENDIF}

{-----------------------------------------------------------}
{implementation for TQuotedPrintable}
const
  BufSize=$6000;

constructor TQuotedPrintable.Create(AStream : TStream; ALines : TStrings);
begin
  Stream:=AStream;
  Lines:=ALines;
  Canceled:=false;
end;

procedure TQuotedPrintable.ReplaceHiChars(var s : ShortString; Wrapped : boolean);
var
  sLen : byte absolute s;
  s1 : ShortString;
  i,j : byte;
begin
  i:=1;
  if Wrapped then j:=sLen-1 else j:=sLen;
  while i<=j do
  begin
    if Ord(s[i]) in [0..31,61,128..255] then
    begin
      s1:=Concat('=',IntToHex(Ord(s[i]),2));
      Insert(s1,s,i+1);
      Delete(s,i,1);
      Inc(i,2);
      if Wrapped then j:=sLen-1 else j:=sLen;
    end;
    Inc(i);
  end;
end;

procedure TQuotedPrintable.ReformatParagraph(Buf : PChar; Len : Integer;
          TL : TStringList);
var
  cp,sp : PChar;
  s : ShortString;
  sLen : byte absolute s;
  Finished : boolean;
begin
  sp:=Buf;
  TL.Clear;
  repeat
    cp:=sp+Len;
    Finished:=cp>StrEnd(Buf);
    if Finished then cp:=StrEnd(Buf)
    else
    begin
      while (cp^<>' ') and (cp>sp) do Dec(cp);
      if cp=sp then
        cp:=sp+Len;
    end;
    sLen:=cp-sp;
    move(sp^,s[1],sLen);
    if not Finished then s:=Concat(s,'=');
    ReplaceHiChars(s,not Finished);
    TL.Add(s);
    sp:=cp;
  until Finished;
end;

procedure TQuotedPrintable.Encode;
var
  j : Integer;
  Ch : Char;
  Buf : PChar;
  Finished : boolean;
  TempLines : TStringList;
begin
  Buf:=StrAlloc(BufSize);
  Stream.Position:=0;
  TempLines:=TStringList.Create;
  try
    repeat
      {Read a paragraph}
      j:=0;
      FillChar(Buf^,BufSize,0);
      repeat
        if j>=BufSize then
          raise Exception.Create('Paragraph is too large');
        Stream.Read(Ch,1);
        if Stream.Position=Stream.Size then
        begin
          Finished:=true;
          move(Ch,(Buf+j)^,1);
          Inc(j);
        end
        else
        if Ch in [^M,^J] then
        begin
          Finished:=true;
          Stream.Read(Ch,1);
          if not (Ch in [^M,^J])
            then Stream.Position:=Stream.Position-1;
        end
        else
        begin
          Finished:=false;
          move(Ch,(Buf+j)^,1);
          Inc(j);
        end;
{$IFDEF VCL}
        Application.ProcessMessages;
{$ENDIF}
      until Finished;
      ReformatParagraph(Buf,65,TempLines);
      if TempLines.Count=0 then Lines.Add('')
        else Lines.AddStrings(TempLines);
    until (Stream.Position=Stream.Size) or Canceled;
  finally
    TempLines.Free;
    StrDispose(Buf);
  end;
end;

procedure TQuotedPrintable.ReplaceHex(var s : ShortString);
var
  i : byte;
  sLen : byte absolute s;
  Hex : byte;
  ss : ShortString;
begin
  i:=1;
  while i<sLen do
  begin
    if (s[i]='=') then
    begin
      try
        ss:=Copy(s,i+1,2);
        Hex:=StrToInt('$'+ss);
        Delete(s,i,3);
        Insert(Char(Hex),s,i);
      except
        on EConvertError do {Do nothing}
          else raise;
      end;
    end;
    Inc(i);
  end;
end;

procedure TQuotedPrintable.Decode;
var
  Buf, BufStart : PChar;
  i : Integer;
  Finished : boolean;
  s : ShortString;
  sLen : byte absolute s;
  BufLen : Integer;
begin
  Buf:=StrAlloc(BufSize);
  i:=-1;
  try
    repeat
      FillChar(Buf^,BufSize,0);
      BufLen:=0;
      BufStart:=Buf;
      Finished:=false;
      repeat
        Inc(i);
        if i=Lines.Count then Break;
        s:=Lines[i];
        ReplaceHex(s);
        Finished:=(sLen=0) or (s[sLen]<>'=');
        if not Finished then Dec(sLen)
        else
        if s[sLen]<>^Z then
          s:=Concat(s,^M^J);
        if BufLen+sLen+1>=BufSize then
          raise Exception.Create('Paragraph is too large');
        move(s[1],Buf^,sLen);
        Buf:=Buf+sLen;
        BufLen:=BufLen+sLen;
      until Finished;
      Stream.Write(BufStart^,BufLen);
{$IFDEF VCL}
      Application.ProcessMessages;
{$ENDIF}
      Buf:=BufStart;
    until (i>=Lines.Count-1) or Canceled;
  finally
    StrDispose(Buf);
  end;
end;

procedure DecodeQP(const InStr : ShortString; var OutStr : ShortString);
var
  QP : TQuotedPrintable;
  OutStream : TStream;
  InLines : TStrings;
begin
  OutStream:=TMemoryStream.Create;
  try
    InLines:=TStringList.Create;
    try
      InLines.Add(InStr);
      QP:=TQuotedPrintable.Create(OutStream,InLines);
      try
        QP.Decode;
      finally
        QP.Free;
      end;
      OutStream.Position:=0;
      InLines.LoadFromStream(OutStream);
      if InLines.Count>0 then
        OutStr:=InLines[0];
    finally
      InLines.Free;
    end;
  finally
    OutStream.Free;
  end;
end;

end.
