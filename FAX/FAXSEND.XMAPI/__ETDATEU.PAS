Unit ETDateU;


{**************************************************************}
{                                                              }
{        ====----> General Date Routines  Unit <----===        }
{                                                              }
{                      Created : 23/07/90                      }
{                                                              }
{                                                              }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}

{O-,F-}
{$HINTS OFF}

Interface


Uses GlobVar;





Const

  { Julian Equivalent to 01/01/01 }

  JulZero       =  {17898.0;} -365.0;

  DayLimitRange =  500 ;    { No days trigger before special code is applied to Calcinvdue }
  DayLimit      =  900;     { Special No. Days 9xx = xxth of following month }
                            { Special No. Days 8xx = xxth of following 2 months }

  Monthdays : array[1..12] of integer =
    (31,29,31,30,31,30,31,31,30,31,30,31);

  UKDateFormat  =  'dd/MM/yyyy';
  USDateFormat  =  'MM/dd/yyyy';
  JADateFormat  =  'yyyy/MM/dd';

Var
  GlobPeriodsInYr  :  Byte;
  GlobDateFmt      :  Byte;
  {-$IF Defined(WWWSEC) Or Defined(WEBREL)} { Web Security COM Object / WWW RelCode Site}
//  SecBaseDate      : TDateTime;
  {-$IFEND}

Function  CalcDueDatexDays(InvDate  :  Str10;
                           NoDays   :  Integer)  :  Str10;

Function  CalcDueDate(InvDate  :  Str10;
                      NoDays   :  Integer)  :  Str10;

Function Today  :  Str10;

function NoDays(From,Too  :  Str10) : LongInt;

Function MonthDiff(IDate,TDate  :  Str10)  :  LongInt;

function dayofweek(Date2Chk  :  Str10): integer;

function caljul(d,m,y: Word): real;

procedure julcal(X:real; var day,month,year: Word);

Function StrDate(syy,smm,sdd : Word) : Str10;

Procedure DateStr(Smond       :  Str10;
              Var tdd,tmm,tyy :  Word);

Function Part_Date(Mode  :  Char;
                   D2Chk :  Str10)  :  Word;

Function POutDate(DateVar :  Str10)  :  Str10;

Function POutDateB(DateVar :  Str10)  :  Str10;

Function PBareOutDate(DateVar  : Str10)  :  Str10;

Function Date2Store(InpDate  :  Str10)  :  Str10;

Function ValidDate(Date2Chk  : Str10)  :  Boolean;

Function FullYear(Yr  :  Byte)  :  Str5;

Function StrPeriod(syy,smm : Word) : Str10;

Procedure PeriodStr(Smond       :  Str10;
                Var tmm,tyy :  Word);

Function Part_Period(Mode  :  Char;
                     D2Chk :  Str10)  :  Word;

Function SOutPeriod(TmpS,yyS  :  Word)  :  Str10;

Function POutPeriod(DateVar :  Str10)  :  Str10;

Function PBareOutPeriod(DateVar  : Str10)  :  Str10;

Function Period2Store(InpDate  :  Str10)  :  Str10;

Function ValidPeriod(Date2Chk  :  Str10;
                     MPrInYr   :  Byte)  :  Boolean;

Function TxlatePYr(FullYr  :  Byte;
                   From    :  Boolean)  :  Byte;

Function ConvTxYrVal(FullYr  :  Integer;
                     From    :  Boolean)  :  Integer;

Function TxlateYrVal(FullYr  :  Integer;
                     From    :  Boolean)  :  Integer;

Function InvFullDate(DateV : LongDate) : Str80;

Function OldPart_Date(Mode  :  Char;
                      D2Chk :  Str8)  :  Integer;

Procedure OldDateStr(Smond       :  Str8;
                 Var tdd,tmm,tyy :  Integer);

{

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses Dialogs,
     SysUtils,
     ETStrU,
     ETMiscU,
     EWinDteU,
     D4DateU;




{ ========= Return Todays date in yymmdd Format ========= }

Function Today  :  Str10;

Var
  ddw,mmw,yyw :  Word;

Begin
  {-$IF Defined(WWWSEC) Or Defined(WEBREL)} { Web Security COM Object / WWW RelCode Site}
    { Web Security COM Object - required to calculate relcodes for dates other than today }
    { WWW Release Code Site - required to calculate relcodes for dates other than today }
//    DeCodeDate(SecBaseDate,yyw,mmw,ddw);
  {-$ELSE}
    DeCodeDate(Now,yyw,mmw,ddw);
  {-$IFEND}

  Today:=StrDate(yyw,mmw,ddw);
end;





{----------------- Procedure to convert integer dd/mm/yy into str'ddmmyy' ------------ }

Function StrDate(syy,smm,sdd : Word) : Str10;

Var
dds,mms,yys : String[4];

Begin
  Str(sdd,dds);
  Str(smm,mms);
  Str(syy,yys);
  dds:=SetN(sdd);
  mms:=SetN(smm);
  yys:=SetPadNo(Form_Int(syy,0),4);
  StrDate:=yys+mms+dds;
end;



{ ------------------ Procedrue to Split a date str into individual parts ------------ }

Procedure DateStr(Smond       :  Str10;
              Var tdd,tmm,tyy :  Word);

Var
  P  :  Integer;

Begin
  val(copy(Smond,1,4),tyy,p);
  val(copy(Smond,5,2),tmm,p);
  val(copy(Smond,7,2),tdd,p);

end;


{ =================== Produce requested part of full date ================= }

Function Part_Date(Mode  :  Char;
                   D2Chk :  Str10)  :  Word;

Var
  pd,pm,py,op  :  Word;


Begin
  DateStr(D2Chk,pd,pm,py);

  Case Mode of
    'D'  :   op:=pd;
    'M'  :   op:=pm;
    'Y'  :   op:=py;
  end; {Case..}

  Part_Date:=op;
end;



{routine to calculate the actual day of the week-1 for any given date}
{value held in dayofweek variable,0..6}

procedure DMYtoDate(Day,Month,Year: Word;var Julian: Word);
  { Convert from day,month,year to a date }
  { Stored as number of days since January 1, 1900 }
  { Note that no error checking takes place in this routine -- use ValidDate }
begin
if (Year=1900) and (Month<3) then
  if Month = 1 then
    Julian := pred(Day)
  else
    Julian := Day + 30
else
  begin
    if Month > 2 then
      dec(Month,3)
    else
      begin
        inc(Month,9);
        dec(Year)
      end;
    dec(Year,1900);
    Julian := (1461*longint(Year) div 4) + ((153*Month+2) div 5) + Day + 58;
  end
end;


function dayofweek(Date2Chk  :  Str10): integer;


var
  day,month,year         : Word;
  century,WkDay          : integer;
  JD                     : Word;

begin

  DateStr(Date2Chk,Day,Month,Year);

  DMYToDate(Day,Month,Year,JD);

  WkDay:=(JD Mod 7)+1;

  If (WkDay=7) then
    WkDay:=0;

 {if month>2 then 18/06/1997 replaced as not 2000 compliant
    month := month-2
 else
     begin
          month :=month+10;
          year := pred(year)

     end;
  century :=year div 100;
  year := year mod 100;
  WkDay := (day-1+((13*month -1)div 5)+
          (5*year div 4)+ century div 4 - 2 * century + 1) mod 7;}


  DayofWeek:=WkDay;

end;



{calculates the julian equivalent of a given calender date}

function caljul(d,m,y: Word): real;

var
 x: real;

begin
 x:= int(30.57 *M)+int(365.25*y -395.25)+D;

if m>2 then

   if int(y/4)=y/4 then
   x:= x-1
   else
       x:=x-2;

If (x=1) and (y=0) then
  x:=0.5;


   caljul:=x;

end;




{procedure to convert a given julian date back to dd/mm/yy format}

procedure julcal(X:real; var day,month,year: Word);

var
d,m,y: real;
d1     :Word;

begin
  If (x>=1) then
    y:=int(x/365.26)+1
  else
    y:=0;

d:=x+int(395.25-365.25*y);

if int(y/4)*4=y then
d1:=1
else
d1:=2;

if d>(91-d1) then

d:=d+d1;

m:=int(d/30.57);

d:=Round(d-int(30.57*m));

if m>12 then

begin
     m:=1;
     y:=y+1;

end;
month:=trunc(m);
day:=trunc(d);
year:=trunc(y);

end;




{ ==== Function to return the no. of days betwix to dates === }

Function NoDays(From,Too  :  Str10) : Longint;

Var
  Ty,Tm,Td  :  Word;
  JulToo,
  JulFrom   :  Real;


Begin
  DateStr(From,Td,Tm,Ty);

  JulFrom:=CalJul(Td,Tm,Ty);

  DateStr(Too,Td,Tm,Ty);

  JulToo:=CalJul(Td,Tm,Ty);

  NoDays:=Round(JulToo-JulFrom);
end;



{ ================ Function To Calculate Calender Month Diferences  =========== }

Function MonthDiff(IDate,TDate  :  Str10)  :  LongInt;

Var
  Cd,Cm,Cy,Im,Id,Iy   :  Word;
  Diff                :  LongInt;


Begin
  Diff:=0; Iy:=0; Im:=0; Id:=0;

  DateStr(TDate,Cd,Cm,Cy);

  DateStr(IDate,Id,Im,Iy);

  If (Iy<>Cy) then
    Diff:=(((Cy-(Iy+1))*12)+((12-Im))+Cm)
  else
    Diff:=(Cm-Im);

  MonthDiff:=Diff;

end;





{ ============= Function to Calculate Invoice Due Date with special codes ============ }

Function  BaseCalcDueDate(InvDate  :  Str10;
                          NoDays   :  Integer;
                          UseCodes :  Boolean)  :  Str10;

Var
  Id,Im,Iy
               :  Word;
  NoMnths      :  Integer;

  JulInv,JulTd :  Real;


Begin
  Id:=0; Im:=0; Iy:=0;
  DateStr(InvDate,Id,Im,Iy);


  If (NoDays>=DayLimitRange) and (UseCodes) then
  Begin
    Id:=(NoDays Mod 100);

    NoMnths:=Succ((DayLimit-(NoDays-Id)) Div 100);

    AdjMnth(Im,Iy,NoMnths);

    If (Id>31) then
    Begin
      Id:=MonthDays[Im];

      if ((int(Iy/4)*4)<>Iy) and (Im=2) then  {* Adjust for leap year *}
        Id:=Pred(Id);
    end;

    NoDays:=0;
  end;

  JulInv:=CalJul(Id,Im,Iy)+NoDays;
  JulCal(JulInv,Id,Im,Iy);



  Result:=StrDate(Iy,Im,Id);

end;



{ ============= Function to Calculate Invoice Due Date ignoring any special codes, as WOP may generate large day offsets ============ }

Function  CalcDueDatexDays(InvDate  :  Str10;
                           NoDays   :  Integer)  :  Str10;


Begin

  Result:=BaseCalcDueDate(InvDate,NoDays,BOff);

end;


{ ============= Function to Calculate Invoice Due Date with special codes ============ }

Function  CalcDueDate(InvDate  :  Str10;
                      NoDays   :  Integer)  :  Str10;


Begin
  Result:=BaseCalcDueDate(InvDate,NoDays,BOn);

end;




{* Function to Output file stored dates to Printer*}

Function POutDate(DateVar :  Str10)  :  Str10;

Var
  dds,Tmps,yys : Word;
  TmpDate      : Str8;
  TmpDTyp      : TDateTime;

Begin

  If (ValidDate(DateVar)) then
  Begin
    DateStr(DateVar,dds,TmpS,yys);

    try
      TmpDTyp:=EncodeDate(yys,TmpS,dds);
      Result:=DateToStr(TmpDTyp);
    except
      On EConvertError do
      Begin
        Case GLobDateFmt of
          0  :  Result:=SetN(TmpS)+DateSeparator+SetN(dds)+DateSeparator+IntToStr(yys);
          2  :  Result:=IntToStr(yys)+DateSeparator+SetN(TmpS)+DateSeparator+SetN(dds);
          else  Result:=SetN(dds)+DateSeparator+SetN(TmpS)+DateSeparator+IntToStr(yys);
        end {case..}
      end;
    end;


  end
  else
    Case GlobDateFmt of
      0  :  Result:='mm'+DateSeparator+'dd'+DateSeparator+'yyyy';
      2  :  Result:='yyyy'+DateSeparator+'mm'+DateSeparator+'dd';
      else  Result:='dd'+DateSeparator+'mm'+DateSeparator+'yyyy';
    end; {Case..}

end; {Out Date..}


Function POutDateB(DateVar :  Str10)  :  Str10;

Begin
  If (DateVar<>'') then
    Result:=POutDate(DateVar)
  else
    Result:='';

end;

{* Function to display date without '/' *}

Function PBareOutDate(DateVar  : Str10)  :  Str10;

Begin
  Result:=Strip('A',[DateSeparator],POutDate(DateVar));
end;


{* Function to convert input date to stored date *}

Function Date2Store(InpDate  :  Str10)  :  Str10;

Type
  CopyRec  =  Record

                Ds,Dl,
                Ms,Ml,
                Ys,Yl  :  Byte;

              end; {Rec..}

Const
  DateSplits  :  Array[0..2] of CopyRec = (
                                                 (Ds:3; Dl:2; Ms:1; Ml:2; Ys:5; Yl:4),
                                                 (Ds:1; Dl:2; Ms:3; Ml:2; Ys:5; Yl:4),
                                                 (Ds:1; Dl:4; Ms:5; Ml:2; Ys:7; Yl:2));

Var
  dds,mms,yys  :  Str5;
  ddw,mmw,yyw  :  Word;


Begin

  With DateSplits[GlobDateFmt] do
  Begin
    dds:=Copy(InpDate,Ds,Dl);
    mms:=Copy(InpDate,Ms,Ml);
    yys:=Copy(InpDate,Ys,Yl);

    ddw:=IntStr(dds);
    mmw:=IntStr(mms);
    yyw:=IntStr(yys);
  end;

  Result:=StrDate(yyw,mmw,ddw);

end; {Func..}


{ ======= Function to validate Dates ====== }

Function ValidDate(Date2Chk  : Str10)  :  Boolean;

Var
 dw,mw,yw
      :  Word;


Begin
  DateStr(Date2Chk,dw,mw,yw);

  Result:=((mw>0) and (mw<=12));

  If (Result) then
  Begin
    Result:=((dw>0) and (dw<=Monthdays[mw]));

    If (Result) then
      Result:=((yw>=1900) and (yw<=9999));

    If (Result) then
    Begin
      try
        EncodeDate(yw,mw,dw);
      except
        On EConvertError do
          Result:=BOff;
      end; {try..}
    end;
  end;
end; {Func..}

{ ------------------ Various Routines for Period Manipulation ---------------- }


{ ============= FullYear - Returns 19/20 in front of Year =========== }

Function FullYear(Yr  :  Byte)  :  Str5;



Begin

  If (Yr<50) then
    FullYear:=Form_Int(2000+Yr,0)
  else
    FullYear:=Form_Int(1900+Yr,0);

end;


{----------------- Procedure to convert integer mm/yy into str'yymm' ------------ }

Function StrPeriod(syy,smm : Word) : Str10;

Var
  mms,yys : String[4];

Begin
  Str(smm,mms);
  Str(syy,yys);
  mms:=SetN(smm);
  yys:=SetPadNo(Form_Int(syy,0),4);
  StrPeriod:=yys+mms;
end;



{ ------------------ Procedrue to Split a Period str into individual parts ------------ }

Procedure PeriodStr(Smond       :  Str10;
                Var tmm,tyy :  Word);

Var
  P  :  Integer;

Begin
  val(copy(Smond,1,4),tyy,p);
  val(copy(Smond,5,2),tmm,p);
end;


{ =================== Produce requested part of full Period  ================= }

Function Part_Period(Mode  :  Char;
                     D2Chk :  Str10)  :  Word;

Var
  pm,py,op  :  Word;


Begin
  PeriodStr(D2Chk,pm,py);

  Case Mode of
    'M'  :   op:=pm;
    'Y'  :   op:=py;
  end; {Case..}

  Part_Period:=op;
end;



{* Function to Output file stored dates to Printer*}

Function SOutPeriod(TmpS,yyS  :  Word)  :  Str10;

Var
  FYear  :  Integer;

Begin
  FYear:=TxlateYrVal(yyS,BOff);

  If (ValidPeriod(StrPeriod(FYear,TmpS),99)) then
  Begin
    Result:=SetN(TmpS)+DateSeparator+SetPAdNo(Form_Int(FYear,0),4);
  end
  else
    Result:='mm'+DateSeparator+'yyyy';

end; {Out Screen Period..}

{* Function to Output file stored dates to Printer*}

Function POutPeriod(DateVar :  Str10)  :  Str10;

Var
  Tmps,yys     : Word;

Begin

  If (ValidPeriod(DateVar,99)) then
  Begin
    PeriodStr(DateVar,TmpS,yys);

    Result:=SOutPeriod(TmpS,TxlateYrVal(yyS,BOn));
  end
  else
    Result:='mm'+DateSeparator+'yyyy';

end; {Out Period..}

{* Function to display Period without '/' *}

Function PBareOutPeriod(DateVar  : Str10)  :  Str10;

Begin
  Result:=Strip('A',[DateSeparator],POutPeriod(DateVar));
end;


{* Function to convert input date to stored date *}

Function Period2Store(InpDate  :  Str10)  :  Str10;

Var
  mms,yys  :  Str5;
  mmw,yyw  :  Word;


Begin

  mms:=Copy(InpDate,1,2);

  yys:=Copy(InpDate,3,4);

  mmw:=IntStr(mms);

  yyw:=IntStr(yys);

  Result:=StrPeriod(yyw,mmw);

end; {Func..}


{ ======= Function to validate Dates ====== }

Function ValidPeriod(Date2Chk  :  Str10;
                     MPrInYr   :  Byte)  :  Boolean;

Var
 mw,yw
      :  Word;


Begin
  PeriodStr(Date2Chk,mw,yw);

  Result:=((mw>0) and (mw<=MPrInYr));

  If (Result) then
  Begin
    If (Result) then
      Result:=((yw>=1951) and (yw<=2050));
  end;
end; {Func..}


{ ==== Function to convert between Year 2000 period ===== }

Function TxlatePYr(FullYr  :  Byte;
                   From    :  Boolean)  :  Byte;



Begin

  Result:=FullYr;

  If (From) then
  Begin

    If (FullYr>99) then
      Result:=FullYr-100

  end
  else
  Begin

    If (FullYr<50) then
      Result:=FullYr+100

  end;


end;

{ ==== Function to convert between 2 digit & 4 digit ===== }

Function ConvTxYrVal(FullYr  :  Integer;
                     From    :  Boolean)  :  Integer;


Begin

  If (From) then
  Begin
    If (FullYr>1999) then
      Result:=FullYr-2000
    else
      Result:=FullYr-1900;
  end
  else
  Begin

    If (FullYr<50) then
      Result:=FullYr+2000
    else
      Result:=FullYr+1900;

  end;

end;

{ ==== Function to convert between 2 digit & 4 digit Period ===== }

Function TxlateYrVal(FullYr  :  Integer;
                     From    :  Boolean)  :  Integer;


Begin

  If (From) then
    Result:=FullYr-1900
  else
    Result:=FullYr+1900;

end;



{ ==== Function to Produce a Full Printed Date ======
       Input must be a yymmdd Str                    }


Function InvFullDate(DateV : LongDate) : Str80;

Var
  Idd,Imm,
  Rdi,L,I,Chk  :  Integer;
  TempDate     :  Str80;


Begin
  If Length(DateV)=Pred(Sizeof(LongDate)) then
  Begin
    Imm:=1; Idd:=1; Rdi:=1;
    Val(Copy(DateV,5,2),Imm,Chk);
    Val(Copy(DateV,7,2),Idd,Chk);
    Val(Copy(DateV,8,1),Rdi,Chk);

    if (rdi=0) or (rdi>3) or (Idd<14) and (Idd>10 ) then rdi:=4;

    If Idd<10 then
    Begin
      I:=1; L:=8;
    end
    else
    Begin
      I:=2; L:=7;
    end;
    TempDate:=Copy(DateV,L,I)+Rd[Rdi]+' '+MonthAry[Imm]+' '+Copy(DateV,1,4);
  end {If Length of Date OK..}
  else
  TempDate:='';
  InvFullDate:=TempDate;
end; {InvFull Date..}




{ ----------------------------------------------------------------------------------- }


{ ------------------ Procedrue to Split a date str into individual parts ------------ }

Procedure OldDateStr(Smond       :  Str8;
                 Var tdd,tmm,tyy :  Integer);

Var
  P  :  Integer;

Begin
  val(copy(Smond,5,2),tyy,p);
  val(copy(Smond,3,2),tmm,p);
  val(copy(Smond,1,2),tdd,p);

  If (tyy<50) then
  Begin
    P:=Tyy;
    Tyy:=Tdd;
    Tdd:=P;
  end;
end;


{ =================== Produce requested part of full date ================= }

Function OldPart_Date(Mode  :  Char;
                      D2Chk :  Str8)  :  Integer;

Var
  pd,pm,py,op  :  Integer;


Begin
  OldDateStr(D2Chk,pd,pm,py);

  Case Mode of
    'D'  :   op:=pd;
    'M'  :   op:=pm;
    'Y'  :   op:=py;
  end; {Case..}

  OldPart_Date:=op;
end;


{ ============ Procedure to set the ShortDate Format =============== }
Var
  GenStr  :  Str255;

Begin
  { HM 18/05/99: Added as various Win98/NT machines are reporting dates incorrectly. The }
  {              following routine has been lifted from the Delphi 4.0 source code.      }
  GetD4DateFormat;
  //SetNTShortDateFmt;

  If (UpCase(ShortDateFormat[1])='M') then
    GlobDateFmt:=0 {US}
  else
    If (UpCase(ShortDateFormat[1])='Y') then
      GlobDateFmt:=2  {Japan}
    else
      GlobDateFmt:=1; {UK}

  Case GlobDateFmt of
    0  :  ShortDateFormat:=USDateFormat;
    2  :  ShortDateFormat:=JADateFormat;
    else  ShortDateFormat:=UkDateFormat;
  end; {Case..}


  GlobPeriodsInYr:=12;

  {-$IF Defined(WWWSEC) Or Defined(WEBREL)} { Web Security COM Object / WWW RelCode Site}
//    SecBaseDate := Now;
  {-$IFEND}
end.
