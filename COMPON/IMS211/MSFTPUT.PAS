(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msftput;

interface

function DosFTPDateTimeToDateTime(const s : string) : TDateTime;
function UnixFTPDateTimeToDateTime(const s : string) : TDateTime;
function GetMonthNumber(const s : string) : Integer;
function LastPos(SubStr : string; Str : string) : Integer;
function PickLinkPtr(const s: string): string;

implementation

uses
  SysUtils, msUtils;

function DosFTPDateTimeToDateTime(const s : string) : TDateTime;
var
  SaveShortDateFormat : string[15];
  SaveShortTimeFormat : string[15];
  SaveDateSeparator : Char;
  SaveTimeSeparator : Char;
  SaveTimeAMString : string[7];
  SaveTimePMString : string[7];
begin
  SaveShortDateFormat:=ShortDateFormat;
  SaveShortTimeFormat:=ShortTimeFormat;
  SaveDateSeparator:=DateSeparator;
  SaveTimeSeparator:=TimeSeparator;
  SaveTimeAMString:=TimeAMString;
  SaveTimePMString:=TimePMString;
  try
    DateSeparator:='-';
    TimeSeparator:=':';
    TimeAMString:='AM';
    TimePMString:='PM';
    ShortDateFormat:='MM-DD-YYYY';
    ShortTimeFormat:='HH:MM';
  try
    Result:=StrToDateTime(s);
  except
    Result:=EncodeDate(0,0,0)+EncodeTime(0,0,0,0);
  end;
  finally
    ShortDateFormat:=SaveShortDateFormat;
    ShortTimeFormat:=SaveShortTimeFormat;
    DateSeparator:=SaveDateSeparator;
    TimeSeparator:=SaveTimeSeparator;
    TimeAMString:=SaveTimeAMString;
    TimePMString:=SaveTimePMString;
  end;
end;

function GetMonthNumber(const s : string) : Integer;
const
  Months : array[1..12] of string[3]=
     ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct',
      'Nov','Dec');
var
  i : Integer;
  Found : boolean;
begin
  i:=0; Result:=-1;
  repeat
    Inc(i);
    Found:=s=Months[i];
  until (i=12) or Found;
  if Found then
    Result:=i;
end;

function UnixFTPDateTimeToDateTime(const s : string) : TDateTime;
var
  s1 : string;
  i : Word;
  Day, Month, Year, Hour, Min, Sec, MSec : Word;
begin
  Hour:=0; Min:=0; Sec:=0; MSec:=0;
  DecodeDate(Now, Year, Month, Day);
  s1:=PickString(s,0,true);
  i:=GetMonthNumber(s1);
  if i<>Word(-1) then
    Month:=i;
  i:=PickNumber(s,1);
  if i<>Word(-1) then
    Day:=i;
  s1:=PickString(s,2,true);
  i:=Pos(':',s1);
  if i>0 {if time} then
  begin
    Hour:=StrToIntDef(Copy(s1,1,i-1),0);
    Min:=StrToIntDef(Copy(s1,i+1,Length(s1)),0);
  end
  else
  begin
    i:=PickNumber(s,2);
    if i<>Word(-1) then
      Year:=i;
  end;
  Result:=EncodeDate(Year, Month, Day)+EncodeTime(Hour, Min, Sec, MSec);
end;

function LastPos(SubStr : string; Str : string) : Integer;
var
  Match : boolean;
begin
  Result:=Length(Str);
  repeat
    Match:=Copy(Str,Result,Length(SubStr))=SubStr;
    Dec(Result);
  until Match or (Result=0);
  if Match then
    Inc(Result);
end;

function PickLinkPtr(const s: string): string;
var
  i: Integer;
begin
  i:=Pos('->',s);
  if i>0 then
    Result:=Trim(Copy(s,i+2,Length(s)))
  else
    Result:=s;
end;

end.
