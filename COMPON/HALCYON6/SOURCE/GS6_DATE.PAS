unit gs6_date;
{-----------------------------------------------------------------------------
                             Date Processor
       gs6_date Copyright (c) 1998 Griffin Solutions, Inc.

       Date
          21 Mar 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit handles date conversion for dBase Julian Dates. It will
       convert between Julian Date and the TDateTime type.

       An astronomers' Julian day number is a calendar system which is useful
       over a very large span of time.  (January 1, 1988 A.D. is 2,447,162 in
       this system.) This dating system is used by xBase applications.

       By assigning a longint julian date, computing differences between
       dates, adding days to an existing date, and other mathematical actions
       become much easier.

   Changes:
------------------------------------------------------------------------------}
interface

Uses
   gs6_glbl,
   Sysutils;

const
   gsDateJulInv  =  -1;             {constant for invalid Julian day}
   gsDateJulMty  = 0;               {constant for blank julian entry}

type
   TgsDBFDate = class(TObject)
   (*The TgsDBFDate class is used to create Julian dates in the same way
    as is done in xBase.  An astronomers' Julian day number is a calendar
    system which is useful over a very large span of time.
    (January 1, 1988 A.D. is 2,447,162 in this system.

    This class allows the programmer to convert between these longint values
    and string results using xBase-style functions such as CTOD, DTOC, and
    DTOS.*)

   private
      FJulOffset: longint;
      FForceCentury: boolean;
   protected
      function DBLoad(const sdate: string): longint;
   public
      constructor Create;
               (*Creates an instance of TgsDBFDate*)
      function Date: longint;
               (*Returns the Julian date for the current day.  Julian dates are of
                type longint.*)
      function DOW(nv : longint): integer;
               (*Converts a Julian Date to the day of the week (Sun=1, Sat=7).*)
      function DTOS(nv : longint): string;
               (*Converts a Julian Date to a string in format YYYYMMDD.*)
      function DTOC(nv: longint): string;
               (*Converts a Julian Date to a string based in ShortDateFormat.
               The century will be added regardless of the ShortDateFormat unless
               ForceCentury is set false. ShortDateFormat is set in Delphi based
               on Windows Date information*)
      function CTOD(const sdate: string): longint;
               (*Converts a string date in ShortDateFormat or YYYYMMDD to a Julian date.
               ShortDateFormat is set in Delphi based on Windows Date information*)
      function MDY2Jul(month, day, year : word): longint;
               (*Returns a Julian date for a Month, day, and year argument set.*)
      procedure Jul2MDY(jul: longint; var month, day, year: word);
               (*Returns Month, day, and year for a Julian date.*)
      property ForceCentury: boolean read FForceCentury write FForceCentury;
               (*Forces century to be displayed in DTOC command, regardless of
                 the ShortDateFormat.  Default is true.*)
      property JulianOffset: longint read FJulOffset;
               (*Returns number of days difference between the date portion of
               TDateTime and a Julian Date.  This is different in Delphi 1
               and Delphi 2/3.*)
   end;

var
   DBFDate: TgsDBFDate;
   (*DBFDate provides an instance of TgsDBFDate that can be used by the
   programmer without creating a specific instance of the class.*)

function CTOD(strn : string) : longint;
function CurDate: longint;
function DTOC(jul : longint) : string;
function DTOS(jul : longint) : string;

implementation



function CTOD(strn : string) : longint;
var
   v : longint;
begin
   v := DBFDate.CTOD(strn);
   if v > 0 then
      CTOD := v
   else
      CTOD := 0;
end;

Function CurDate: longint;
begin
   CurDate := DBFDate.Date;
end;

function DTOC(jul : longint) : string;
begin
   DTOC := DBFDate.DTOC(jul);
end;

function DTOS(jul : longint) : string;
begin
   DTOS := DBFDate.DTOS(jul);
end;


constructor TgsDBFDate.Create;
begin
   inherited Create;
   FForceCentury := true;
   FJulOffset := dBaseJul19800101-trunc(EncodeDate(1980,1,1));
end;

function TgsDBFDate.DBLoad(const sdate: string): longint;
var
   td: TDateTime;
begin
   td := EncodeDate(StrToInt(copy(sdate,1,4)),StrToInt(copy(sdate,5,2)),
                    StrToInt(copy(sdate,7,2)));
   Result := Trunc(td);
end;

function TgsDBFDate.MDY2Jul(month, day, year: word) : longint;
begin
   Result := trunc(EncodeDate(year, month, day))+ FJulOffset;
end;

procedure TgsDBFDate.Jul2MDY(jul : longint; var month, day, year: word);
var
   td: TDateTime;
begin
   jul := jul - FJulOffset;
   td := jul;
   DecodeDate(td, year, month, day);
end;

function TgsDBFDate.Date: longint;
begin
   Result := trunc(SysUtils.Date)+ FJulOffset;
end;

function TgsDBFDate.DOW(nv : longint): integer;
var
   td: TDateTime;
begin
   if nv <= 0 then
   begin
      Result := 0;
      exit;
   end;
   td := nv;
   td := td - FJulOffset;
   Result := DayOfWeek(td);
end;

function TgsDBFDate.DTOS(nv : longint): string;
var
   td: TDateTime;
begin
   if nv <= 0 then
   begin
      Result := '        ';
      exit;
   end;
   td := nv;
   td := td - FJulOffset;
   Result := FormatDateTime('yyyymmdd',td);
end;

function TgsDBFDate.DTOC(nv: longint): string;
var
   td: TDateTime;
   sdf: string;
   psn: integer;
begin
   sdf := UpperCase(ShortDateFormat);
   if FForceCentury then
   begin
      psn := pos('Y',sdf);
      while pos('YYYY',sdf) = 0 do
         System.Insert('Y',sdf,psn);
   end;
   if nv > 0 then
   begin
      td := nv;
      td := td - FJulOffset;
      Result := FormatDateTime(sdf,td);
   end
   else
   begin
      Result := sdf;
      for psn := 1 to length(sdf) do Result[psn] := ' ';
   end;
end;

function TgsDBFDate.CTOD(const sdate: string): longint;
var
   t: string;
   td: TDateTime;
   StorFmt: boolean;
   rsl: integer;
   i: integer;
begin
   t := TrimRight(sdate);
   if (length(t) = 0) or (sdate = '00000000') then
   begin
      Result := gsDateJulMty;
      exit;
   end;
   td := 0;
   StorFmt := false;
   if length(t) = 8 then
   begin
      rsl := 0;
      for i := 1 to length(t) do
      begin
         if not (t[i] in ['0'..'9']) then rsl := i;
      end;
      if rsl = 0 then      {yyyymmdd format}
      begin
         try
            td := EncodeDate(StrToInt(copy(t,1,4)),StrToInt(copy(t,5,2)),
                          StrToInt(copy(t,7,2)));
         except
            td := 0;
         end;
         StorFmt := true;
      end;
   end;
   if not StorFmt then
   begin
      td := StrToDate(t);
   end;
   td := td + FJulOffset;
   Result := trunc(td);
end;

{------------------------------------------------------------------------------
                           Setup and Exit Routines
------------------------------------------------------------------------------}
{$IFDEF WIN32}
initialization
   DBFDate := TgsDBFDate.Create;

finalization
begin
   DBFDate.Free;
end;

{$ELSE}
var
   ExitSave      : pointer;

{$F+}
procedure ExitHandler;
begin
   DBFDate.Free;
   ExitProc := ExitSave;
end;
{$F-}

begin
   ExitSave := ExitProc;
   ExitProc := @ExitHandler;
   DBFDate := TgsDBFDate.Create;
{$ENDIF}

end.
