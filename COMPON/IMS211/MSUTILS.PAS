(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msutils;

{$I msDef.inc}

interface

uses
{$IFDEF WIN32}
  Windows,
{$ELSE}
  WinProcs,
{$ENDIF}
  Classes, SysUtils,
{$IFDEF WIN32}
  Registry,
{$ENDIF}
{$IFDEF VCL}
  Dialogs,
{$ENDIF}
  msDef,
  msMsgCls;

type
  TEncMethod = (emNone,emBase64,emQtPrn);

procedure TrimStrings(SL : TStrings);
function MakeBoundary : string;
function GetParameter(const p : string; s : string) : string;
function AddBackSlash(const DirName : string) : string;
procedure PickMailAddress(s : string; TheMailAddress : TmsMailAddress);
procedure SplitAddress(const s : string; var Addr, Name : string);
function GetFirstPart(const s : string) : string;
function GetContentType(const FileName : string) : string;
procedure MailDateToDateTime(s : string; var DT : TDateTime; var TZ : ShortString);
function DateTimeToMailDate(DT : TDateTime; const TZ : string) : string;
function DefaultTimeZoneString : string;
function ValidTimeZone(TZ : string) : boolean;
function TimeZone(const TZ : string) : TDateTime;
function MailDateToGMT(const s : string) : TDateTime;
function MakeTimeDifferential(Diff : Integer) : string;
function TrimQuotes(const s : string) : string;
function PickString(s : string; Position : Integer; RightTrim : boolean) : string;
function PickNumber(s : string; Position : Integer) : LongInt;
function PickLastPart(s: string): string;
function ConcatIfNotBlank(const s1,s2 : string) : string;
{$IFDEF WIN32}
procedure SLSaveToFile(SL : TStrings; const FileName : string);
{$ENDIF}
{$IFNDEF WIN32}
function Trim(s : string) : string;
procedure SetLength(var s : string; Len : byte);
{$ENDIF}

implementation

procedure TrimStrings(SL : TStrings);
begin
  while (SL.Count>0) and (Trim(SL[SL.Count-1])='') do
    SL.Delete(SL.Count-1);
end;

function MakeBoundary : string;
var
  i : Integer;
begin
  Result:='';
  for i:=1 to 8 do
    Result:=Concat(Result,IntToStr(Random(9)));
end;

function TrimQuotes(const s : string) : string;
begin
  Result:=Trim(s);
  while (Length(Result)>0) and (Result[1]='"') do
    Delete(Result,1,1);
  while (Length(Result)>0) and (Result[Length(Result)]='"') do
    Delete(Result,Length(Result),1);
end;

function PickString(s : string; Position : Integer; RightTrim : boolean) : string;
var
  sp : Integer;
  i : Integer;
begin
  Result:=''; sp:=-1;
  for i:=1 to Position do
  begin
    sp:=Pos(' ',s);
    if sp<>0 then
    begin
      Delete(s,1,sp);
      s:=Trim(s);
    end
    else
    begin
      Result:='';
      Break;
    end;
  end;
  if (sp<>0) then
  begin
    if RightTrim then
    begin
      sp:=Pos(' ',s);
      if sp>0 then
        s:=Trim(Copy(s,1,sp-1))
      else
        s:=Trim(s);
    end;
    Result:=Trim(s);
  end;
end;

function PickNumber(s : string; Position : Integer) : LongInt;
begin
  Result:=StrToIntDef(PickString(s,Position,true),-1);
end;

function PickLastPart(s: string): string;
var
  i: Integer;
begin
  s:=Trim(s);
  i:=Length(s);
  while (Copy(s,i,1)<>' ') and (i>0) do
    Dec(i);
  Result:=Trim(Copy(s,i,Length(s)));
end;

function GetParameter(const p : string; s : string) : string;
var
  i : Integer;
  LastCh : Char;
begin
  Result:='';
  i:=Pos(UpperCase(p),UpperCase(s));
  if i<>0 then
  begin
    Result:='';
    Delete(s,1,i+Length(p));
    s:=Trim(s);
    if Copy(s,1,1)='=' then
    begin
      Delete(s,1,1);
      s:=Trim(s);
    end;
    if s[1]='"' then
    begin
      LastCh:='"';
      i:=2;
    end
    else
    begin
      LastCh:=' ';
      i:=1;
    end;
    while (i<=Length(s)) and (s[i]<>LastCh) do
    begin
      Result:=Concat(Result,s[i]);
      Inc(i);
    end;
    if (Length(Result)>0) and (Result[Length(Result)]=';') then
      Delete(Result,Length(Result),1);
    Result:=Trim(Result);
  end;
end;

function AddBackSlash(const DirName : string) : string;
begin
  if (Length(DirName)>0) and (DirName[Length(DirName)]<>'\')
    then Result:=Concat(DirName,'\')
  else
    Result:=DirName;
end;

procedure PickMailAddress(s : string; TheMailAddress : TmsMailAddress);
{Improved in v1.7}
var
  i,j : Integer;
begin
{First search for <}
  i:=Pos('<',s);
  if i>0 then
  begin
    j:=Pos('>',s);
    if (j=0) or (j<i) then {Something is very wrong...}
      Exception.Create('Unable to parse email address');
    TheMailAddress.Address:=TrimQuotes(Copy(s,i+1,j-i-1));
    Delete(s,i,j-i+1);
    TheMailAddress.Name:=TrimQuotes(s);
    Exit;
  end;
{Now search for (}
  i:=Pos('(',s);
  if i>0 then {In this case reverse}
  begin
    TheMailAddress.Address:=TrimQuotes(Copy(s,1,i-1));
    TheMailAddress.Name:=TrimQuotes(Copy(s,i+1,Length(s)-i-1));
    Exit;
  end;
{if we are here, assume all is the address}
  TheMailAddress.Address:=s;
  TheMailAddress.Name:='';
end;

procedure SplitAddress(const s : string; var Addr, Name : string);
var
  MA : TmsMailAddress;
begin
  MA:=TmsMailAddress.Create;
  try
    PickMailAddress(s,MA);
    Addr:=MA.Address;
    Name:=MA.Name;
  finally
    MA.Free;
  end;
end;

function GetFirstPart(const s : string) : string;
{Gets first part of the Header line, where descr is truncated}
var
  sLen : Integer;
  i : byte;
begin
  Result:='';
  sLen:=Length(s);
  i:=1;
  while (i<=sLen) and not (s[i] in [' ',';']) do
  begin
    Result:=Concat(Result,s[i]);
    Inc(i);
  end;
  Result:=Trim(Result);
end;

function ConcatIfNotBlank(const s1,s2 : string) : string;
begin
  Result:=s1;
  if s2<>'' then
    Result:=Concat(s1,' ',s2);
end;

{$IFDEF WIN32}
function GetContentType(const FileName : string) : string;
var
  Key : string;
begin
  Result:='';
  with TRegistry.Create do
  try
    RootKey:=HKEY_CLASSES_ROOT;
    Key:=ExtractFileExt(FileName);
    if KeyExists(Key) then
    begin
      OpenKey(Key,false);
      Result:=ReadString('Content Type');
      CloseKey;
    end;
  finally
    if Result='' then
      Result:='application/octet-stream';
    free;
  end;
end;
{$ELSE}
function GetContentType(const FileName : string) : string;
var
  Ext : string[4];
begin
  Ext:=UpperCase(ExtractFileExt(FileName));
  if Ext='.AIF' then result:='audio/aiff'
  else
  if (Ext='.AU') or (Ext='.SND') then result:='audio/basic'
  else
  if Ext='.GIF' then result:='image/gif'
  else
  if Ext='.JPG' then result:='image/jpeg'
  else
  if Ext='.AVI' then result:='video/avi'
  else
  if Ext='.RTF' then result:='text/rtf'
  else
  if Ext='.HTM' then result:='text/html'
  else
  if Ext='.TXT' then result:='text/plain'
  else
    result:='application/octet-stream';
end;
{$ENDIF}

procedure MailDateToDateTime(s : string; var DT : TDateTime; var TZ : ShortString);
{Cannot use ShortMonthNames global var, because they always must be english}
const
  Months : array[1..12] of string[3]=
           ('JAN','FEB','MAR','APR','MAY','JUN',
            'JUL','AUG','SEP','OCT','NOV','DEC');
  Digits : set of char = ['0'..'9'];
var
  Day, Month, Year, i : Word;
  TempS : string;
  DT1,DT2 : TDateTime;
begin
  DT:=0; TZ:='';
  s:=TrimQuotes(s);
  s:=UpperCase(s);
  if Length(s)=0 then Exit;
  try
    i:=1;
    {if there is DOW ignore it}
    while (i<=Length(s)) and (not (s[i] in Digits)) do Inc(i);
    if i=Length(s) then Exit;
    Delete(s,1,i-1);
    {Now string should be '04 AUG 96 22:45:22 GMT'}
    s:=Trim(s);
    {Pick up the day}
    i:=1;
    while (i<=Length(s)) and (s[i]<>' ') do Inc(i);
    if i=Length(s) then Exit;
    TempS:=Trim(Copy(s,1,i));
    Day:=StrToInt(TempS);
    {Find the name of the month}
    Delete(s,1,i);
    s:=Trim(s);
    Month:=1;
    repeat
      i:=Pos(Months[Month],s);
      inc(Month);
    until (Month=13) or (i>0);
    if i=0 then Exit;
    Dec(Month);
    {Pick up the year}
    s:=Trim(s);
    i:=1;
    while (i<=Length(s)) and (not (s[i] in Digits)) do Inc(i);
    if i=Length(s) then Exit;
    Delete(s,1,i-1);
    s:=Trim(s);
    i:=1;
    while (i<=Length(s)) and (s[i]<>' ') do Inc(i);
    if i=Length(s) then Exit;
    TempS:=Trim(Copy(s,1,i));
    Year:=StrToInt(TempS);
    if (Year>50) and (Year<100) then
      Year:=1900+Year
    else
    if Year<=50 then
      Year:=2000+Year;
{Pick up time}
    Delete(s,1,i);
    s:=Trim(s);
    while (i<=Length(s)) and (s[i]<>' ') do Inc(i);
    if i=Length(s) then Exit;
    TempS:=Trim(Copy(s,1,i));
    if TempS[Length(TempS)]=',' then  {Some servers are putting comma}
      Delete(TempS,Length(TempS),1);
    DT1:=SysUtils.EncodeDate(Year,Month,Day);
    try
      DT2:=StrToTime(TempS);
    except
      DT2:=0;
    end;
    DT:=DT1+DT2;
{Assume the rest is TimeZone}
    Delete(s,1,i);
    TZ:=Trim(s);
  except
    DT:=0; TZ:='';
  end;
end;

function DateTimeToMailDate(DT : TDateTime; const TZ : string): string;
const
  DayOfWeekStr : array[1..7] of string[3] = ('Sun','Mon','Tue','Wed','Thu',
                                             'Fri','Sat');
  MonthStr : array[1..12] of string[3] = ('Jan','Feb','Mar','Apr','May','Jun',
                                          'Jul','Aug','Sep','Oct','Nov','Dec');
var
  Day, Month, Year : word;
begin
  Result:=Concat(DayOfWeekStr[DayOfWeek(DT)],',');
  DecodeDate(DT,Year,Month,Day);
  Result:=Concat(Result,' ',IntToStr(Day),' ',MonthStr[Month],' ',IntToStr(Year));
  Result:=Concat(Result,' ',FormatDateTime('hh":"mm":"ss',DT));
  Result:=Concat(Result,' ',TZ);
end;

function MakeTimeDifferential(Diff : Integer) : string;
var
  Hour,Min : Integer;
  Neg : boolean;
begin
  Neg:=Diff<0;
  if Neg then Diff:=-Diff;
  Hour:=Diff div 60;
  Min:=Diff mod 60;
  Result:=IntToStr(Min);
  if Length(Result)=1 then
    Result:=Concat('0',Result);
  Result:=Concat(IntToStr(Hour),Result);
  if Length(Result)=3 then
    Result:=Concat('0',Result);
  if Neg then
    Result:=Concat('-',Result)
  else
    Result:=Concat('+',Result);
end;

{$IFDEF WIN32}
function DefaultTimeZoneString : string;
var
  TZI : TTimeZoneInformation;
  rc : DWord;
begin
  Result:='GMT';
  FillChar(TZI,SizeOf(TTimeZoneInformation),0);
  rc:=GetTimeZoneInformation(TZI);
  if rc=1 then
    Result:=MakeTimeDifferential(-(TZI.Bias+TZI.StandardBias))
  else
  if rc=2 then
    Result:=MakeTimeDifferential(-(TZI.Bias+TZI.DaylightBias));
end;
{$ELSE}
function DefaultTimeZoneString : string;
begin
  Result:='GMT';
end;
{$ENDIF}

function ValidTimeZone(TZ : string) : boolean;
begin
  if (TZ='GMT') or (TZ='UT') then
    Result:=true
  else
  if (Length(TZ)=3) and (TZ[1] in ['E','C','M','P']) and (TZ[2] in ['S','D'])
     and (TZ[3]='T') then
    Result:=true
  else
  if (Length(TZ)=1) and (TZ[1] in ['A'..'I','K'..'Z']) then
    Result:=true
  else
  if (Length(TZ)=5) and (StrToIntDef(TZ,-1)<>-1) then
    Result:=true
  else
    Result:=false;
end;

function TimeZone(const TZ : string) : TDateTime; {Returns the difference in TDateTime}
var
  s : string;
  i : Integer;
  Hours, Mins : Integer;
  Negative : boolean;
begin
  Result:=0;
  Hours:=-25; Mins:=0;
  s:=UpperCase(TZ);
  if s='UT' then
    Hours:=0
  else
  if s='GMT' then
    Hours:=0
  else
  if s='EST' then
    Hours:=-5
  else
  if s='EDT' then
    Hours:=-4
  else
  if s='CST' then
    Hours:=-6
  else
  if s='CDT' then
    Hours:=-5
  else
  if s='MST' then
    Hours:=-7
  else
  if s='MDT' then
    Hours:=-6
  else
  if s='PST' then
    Hours:=-8
  else
  if s='PDT' then
    Hours:=-7;
  if Hours=-25 then
  begin  {Check if it is time differential}
    i:=StrToIntDef(s,-1);
    if i<>-1 then
    begin
      Hours:=(i div 100);
      Mins:=(i mod 100);
    end;
  end;
  if (Hours=-25) and (Length(TZ)=1) then
  begin {Military standard}
    if TZ[1]='Z' then
      Hours:=0
    else
    if (TZ[1] in ['A'..'I']) then
      Hours:=-(Ord(TZ[1])-Ord('A')+1)
    else
    if (TZ[1] in ['K'..'M']) then
      Hours:=-(Ord(TZ[1])-Ord('K')+10)
    else
    if (TZ[1] in ['N'..'Y']) then
      Hours:=Ord(TZ[1])-Ord('N')+1;
  end;
  if Hours<>-25 then
  begin
    Negative:=Hours<0;
    if Negative then
    begin
      Hours:=-Hours;
      Mins:=-Mins;
    end;
    Result:=EncodeTime(Hours,Mins,0,0);
    if Negative then
      Result:=-Result;
  end;
end;

function MailDateToGMT(const s : string) : TDateTime;
var
  TZ : ShortString;
  DT, DT1 : TDateTime;
begin
  MailDateToDateTime(s,DT,TZ);
  DT1:=TimeZone(TZ);
  Result:=DT-DT1;
end;

{$IFDEF WIN32}
procedure SLSaveToFile(SL : TStrings; const FileName : string);
var
  F : TextFile;
begin
  AssignFile(F,FileName);
  Rewrite(F);
  try
    Write(F,SL.Text);
  finally
    CloseFile(F);
  end;
end;
{$ENDIF}

{$IFNDEF WIN32}
function Trim(s : string) : string;
var
  i : Integer;
begin
  while (Length(s)>0) and (s[1]=' ') do
    Delete(s,1,1);
  while (Length(s)>0) and (s[Length(s)]=' ') do
    Delete(s,Length(s),1);
  Result:=s;
end;

procedure SetLength(var s : string; Len : byte);
begin
  s[0]:=Char(Len);
end;
{$ENDIF}

initialization
  LocalTimeZoneString:=DefaultTimeZoneString;
  Randomize;
end.
