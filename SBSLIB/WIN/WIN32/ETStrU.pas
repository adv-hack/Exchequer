Unit ETStrU;


{**************************************************************}
{                                                              }
{       ====----> General Str255 Routines  Unit <----===       }
{                                                              }
{                      Created : 23/07/90                      }
{                                                              }
{                                                              }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}

{O-,F-,H-}
{$HINTS OFF}

Interface

Uses GlobVar;


Const


  { Word Separator for WordCnt,ExtractWords & LocPos }

  DELIMCHAR  :  Char  =  #32;




function ConstStr(C :  Char; N : Integer) : AnyStr;

Procedure Blank(Var UntStr; Size  :  Integer);

Function Spc(N  :  Integer): AnyStr;

function UpcaseStr(S : Str80) : Str80;

function UpcaseStrList(S     : Str80;
                       AsIs  : Boolean) : Str80;

Function LowCaseStr(Str:Str255):Str255;

Function Strip(L  :  char;
               C  :  CharSet;
               Str:  str255):str255;

Function PosWord(Wordno:byte;Str:Str255):byte;

Function LastPos(C:Char;Str:Str255):byte;

Function WordCnt(Str:Str255):byte;

Function ExtractWords(StartWord,NoWords:byte;Str:Str255):Str255;

Function Time2RealStr(TStr  :  Str255)  :  Str255;

Function PadCenter(Str:Str255;Size:byte;Pad:char):Str255;


Function LJ(Str2Pad  :  AnyStr;
            PadLen   :  Integer) :  AnyStr;

Function LJVar(Str2Pad  :  AnyStr;
               PadLen   :  Integer) :  AnyStr;

Function RJVar(Str2Pad  :  AnyStr;
               PadLen   :  Integer) :  AnyStr;

Function Form_Real(Rnum    :  Real;
                   Dig,Dec : Integer)  :  Str20;

Function Form_BReal(Rnum    :  Real;
                    Dig,Dec : Integer)  :  Str20;

Function Form_Int (Inum    :  LongInt;
                   Dig     :  Integer)  :  Str20;

Function Form_BInt (Inum    :  LongInt;
                    Dig     :  Integer)  :  Str20;

Function SetN(Inum  :  Integer) :  Str5;

Function SetPadNo(Ino  :  Str20;
                  Digit:  Byte) :  Str255;


Function  YNBo(YNFlg  :  Boolean)  :  Char;

Function  BoYN(YNStr  :  Str5)  :  Boolean;

Function  YesNoBo(YNFlg  :  Boolean)  :  Str5;

Function  YesNoBlnk(YNFlg  :  Boolean)  :  Str5;

Function SetCR(Rnum  :  Real)  :  Str5;

Function EINum(KeyRef  :  Str255)  :  Boolean;

Function EmptyKeyS(Key2C  :  Str255;
                   Imask  :  Byte;
                   Chk4Z  :  Boolean)  :  Boolean;

Function EmptyKey(Key2C  :  Str255;
                  Imask  :  Byte)  :  Boolean;

Function Match_Glob(Fno         :  Integer;
                    Compare     :  Str30;
                Var CompWith;
                Var Abort       :  Boolean)  : Boolean;

Function CurrTimeStr(TimeR  :  TimeTyp)  :  Str10;

Function  TimeNowStr  :  Str10;


Function DoubleAmpers (Const InStr : String) : String;

{

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETMiscU;

Const

  NumISet  : CharSet = ['0'..'9','-','.','%'];



(*  ConstStr returns a Str255 with N characters of value C *)

function ConstStr(C :  Char; N : Integer) : AnyStr;
var
  S : AnyStr;
begin
  if N < 0 then
    N := 0;
  S[0] := Chr(N);
  FillChar(S[1],N,C);
  ConstStr := S;
end;



{ ======== Procedure to Completely Blank ANY Given Variable ======= }


Procedure Blank(Var UntStr; Size  :  Integer);

Type
  Bytes  =  Array[0..65535] of Byte;

Begin
  Fillchar(Bytes(UntStr),Size,0);
end;




{* Function to Send N Spaces *}

Function Spc(N  :  Integer): AnyStr;


Begin
  If N>255 then N:=255;
  Spc:=ConstStr(' ',N);
end;



(*  UpcaseStr converts a Str255 to upper case *)

function UpcaseStr(S : Str80) : Str80;
var
  P : Integer;
begin
  for P := 1 to Length(S) do
    S[P] := Upcase(S[P]);
  UpcaseStr := S;
end;

function UpcaseStrList(S     : Str80;
                       AsIs  : Boolean) : Str80;


Begin
  If (AsIs) then
    UpCaseStrList:=S
  else
    UpCaseStrList:=UpCaseStr(S);
end; {Func..}



Function LowCaseStr(Str:Str255):Str255;
var
  I : integer;
begin
    For I := 1 to length(Str) do
        If ord(Str[I]) in [65..90] then
           Str[I] := chr(ord(Str[I]) + 32);
    LowCaseStr := Str;
end;  {Func Lower}


{ Function to Remove all occurrences of 'C' char in Str Str255....


  Legal Values for L are...:-


  L    =   Left of Str Only
  R    =   Right of "   "
  B    =   Beginning & End of Str, ie L & R
  A    =   Remove all Occurrences of Char C

}

Function Strip(L  :  char;
               C  :  CharSet;
               Str:  Str255):Str255;

var I :  byte;
begin
    Case Upcase(L) of
    'L' : begin       {Left}
              While (Str[1] In C) and (Length(Str)<>0) do
                    Delete(Str,1,1);
          end;
    'R' : begin       {Right}
              While  (Str[length(Str)] In C) and (Length(Str)<>0)  do
                    Delete(Str,length(Str),1);
          end;
    'B' : begin       {Both left and right}
              While (Str[1] In C) and (Str<>'')  do
                    Delete(Str,1,1);
              While (Str[length(Str)] In C) and (Length(Str)<>0) do
                    Delete(Str,length(Str),1);
          end;
    'A' : begin       {All}
              I := 1;
              Repeat
                   If Str[I] In C then
                      Delete(Str,I,1)
                   else
                      I := succ(I);
              Until (I > length(Str)) or (Length(Str)=0);
          end;
    end;
    Strip := Str;
end;  {Func Strip}


{Various Str255 Mainpuation Procedures:

 PosWord n      : Returns Byte Value of Char pos of n Word
 ExtractWord nw : Returns w words starting @ n
 Wordcnt        : Returns value of no of words in given Str

}

Function LocWord(StartAT,Wordno:byte;Str:Str255):byte;
{local proc used by PosWord and Extract word}
var
  W,L: integer;
  Spacebefore: boolean;
begin
    If (Length(Str)=0) or (wordno < 1) or (StartAT > length(Str)) then
    begin
        LocWord := 0;
        exit;
    end;
    SpaceBefore := true;
    W := 0;
    L := length(Str);
    StartAT := pred(StartAT);
    While (W < Wordno) and (StartAT <= length(Str)) do
    begin
        StartAT := succ(StartAT);
        If SpaceBefore and (Str[StartAT] <> DELIMChar) then
        begin
            W := succ(W);
            SpaceBefore := false;
        end
        else
            If (SpaceBefore = false) and (Str[StartAT] = DELIMChar) then
                SpaceBefore := true;
    end;
    If W = Wordno then
       LocWord := StartAT
    else
       LocWord := 0;
end;

Function PosWord(Wordno:byte;Str:Str255):byte;
begin
    PosWord := LocWord(1,wordno,Str);
end;  {Func Word}

Function WordCnt(Str:Str255):byte;
var
  W,I: integer;
  SpaceBefore: boolean;
begin
    If Length(Str)=0 then
    begin
        WordCnt := 0;
        exit;
    end;
    SpaceBefore := true;
    W := 0;
    For  I :=  1 to length(Str) do
    begin
        If SpaceBefore and (Str[I] <> DELIMChar) then
        begin
            W := succ(W);
            SpaceBefore := false;
        end
        else
            If (SpaceBefore = false) and (Str[I] = DELIMChar) then
                SpaceBefore := true;
    end;
    WordCnt := W;
end;


Function ExtractWords(StartWord,NoWords:byte;Str:Str255):Str255;
var Start, finish : integer;
begin
    If Length(Str)=0 then
    begin
        ExtractWords := '';
        exit;
    end;
    Start := LocWord(1,StartWord,Str);
    If Start <> 0 then
       finish := LocWord(Start,succ(NoWords),Str)
    else
    begin
        ExtractWords := '';
        exit;
    end;
    If finish <> 0 then
       Repeat
           finish := pred(finish);
       Until Str[finish] <> DELIMChar
    else
       finish := length(Str);
    ExtractWords := copy(Str,Start,succ(finish-Start));
end;  {Func ExtractWords}



Function LastPos(C:Char;Str:Str255):byte;
Var I : byte;
begin
    I := succ(Length(Str));
    Repeat
         I := Pred(I);
    Until (I = 0) or (Str[I] = C);
    LastPos := I;
end;  {Func LastPos}



Function PadCenter(Str:Str255;Size:byte;Pad:char):Str255;
var temp : Str255;
L : byte;
begin
    Fillchar(Temp[1],Size,Pad);
    SetLength(Temp,Size);
    L := length(Str);
    If L <= Size then
       Move(Str[1],Temp[((Size - L) div 2) + 1],L)
    else
       Move(Str[((L - Size) div 2) + 1],Temp[1],Size);
    PadCenter := temp;
end; {center}



{ =========== Function to return HH:MM Str255 to HH.MM Str255,
              to be processed as normal real str                ========== }

Function Time2RealStr(TStr  :  Str255)  :  Str255;


Const
  Colon  =  ':';
  Dot    =  '.';


Var
  ColPos  :  Byte;


Begin
  ColPos:=LastPos(Colon,TStr);

  If (ColPos<>0) then
    TStr[ColPos]:=Dot;

  Time2RealStr:=TStr;
end;




{ Pad Str to Given No. of Places }

Function LJ(Str2Pad  :  AnyStr;
            PadLen   :  Integer) :  AnyStr;

Var
  LJCh  :  Char;

Begin

  If (Not BlindOn) then
    LJch:=#32
  else
    LJch:='_';

  If (Length(Str2Pad)<PadLen) then
    LJ:=Str2Pad+ConstStr(LJCh,PadLen-Length(Str2Pad))
  else
    LJ:=Copy(Str2Pad,1,PadLen);
end;


{ Pad Text Prompt Str to Given No. of Places }

Function LJVar(Str2Pad  :  AnyStr;
               PadLen   :  Integer) :  AnyStr;


Begin
  If (Length(Str2Pad)<PadLen) then
    LJVar:=Str2Pad+ConstStr(' ',(PadLen-Length(Str2Pad)))
  else
    LJVar:=Copy(Str2Pad,1,PadLen);
end;



{ Pad Text RJ Prompt Str to Given No. of Places }

Function RJVar(Str2Pad  :  AnyStr;
               PadLen   :  Integer) :  AnyStr;


Begin
  If (Length(Str2Pad)<PadLen) then
    RJVar:=ConstStr(' ',(PadLen-Length(Str2Pad)))+Str2Pad
  else
    RJVar:=Copy(Str2Pad,1,PadLen);
end;


{ ====== Function to Format a Real No. & return in Str Format ===== }

Function Form_Real(Rnum    :  Real;
                   Dig,Dec : Integer)  :  Str20;

Var
  TmpStr  :  Str20;

Begin
  TmpStr:='';
  Str(Rnum:Dig:Dec,TmpStr);
  Form_Real:=TmpStr;
end;


{ === Blank version of above === }

Function Form_BReal(Rnum    :  Real;
                    Dig,Dec : Integer)  :  Str20;

Var
  TmpStr  :  Str20;

Begin
  If (Rnum<>0) then
    TmpStr:=Form_Real(Rnum,Dig,Dec)
  else
    TmpStr:=LJVar('',Dig);

  Form_BReal:=TmpStr;
end;



{ ====== Function to Format an Integer No. & return in Str Format ===== }

Function Form_Int (Inum    :  LongInt;
                   Dig     :  Integer)  :  Str20;

Var
  TmpStr  :  Str20;

Begin
  TmpStr:='';
  Str(Inum:Dig,TmpStr);
  Form_Int:=TmpStr;
end;


{ ======= Blank Version of above ======= }


Function Form_BInt (Inum    :  LongInt;
                    Dig     :  Integer)  :  Str20;

Var
  TmpStr  :  Str20;

Begin
  If (Inum<>0) then
    TmpStr:=Form_Int(Inum,Dig)
  else
    TmpStr:=LJVar('',Dig);

  Form_BInt:=TmpStr;
end;




{* Function to return YN depending on Boolean State *}

Function  YNBo(YNFlg  :  Boolean)  :  Char;

Begin
  if (YNFlg) then
    YNBo:='Y'
  else
    YNBo:='N';
end;


{* Function to return Bo depending on YN State *}

Function  BoYN(YNStr  :  Str5)  :  Boolean;

Begin
  BoYN:=(YNStr='Y');
end;

{* Function to return YesNo depending on Boolean State *}

Function  YesNoBo(YNFlg  :  Boolean)  :  Str5;

Begin
  if (YNFlg) then
    Result:='Yes'
  else
    Result:='No ';
end;


{* Function to return YesBlnk depending on Boolean State *}

Function  YesNoBlnk(YNFlg  :  Boolean)  :  Str5;

Begin
  if (YNFlg) then
    Result:='Yes'
  else
    Result:=' ';
end;


{ =================== Set No to Str, and Padd out with '0' if necc ================= }

Function SetN(Inum  :  Integer) :  Str5;

Var
  TmpStr  :  Str5;

Begin
  Str(Inum:1,TmpStr);
  If (Length(TmpStr)<2) then
    TmpStr:='0'+TmpStr;
  SetN:=TmpStr;
end;



{ ================== Pad Number with Digits*'0's =============== }

Function SetPadNo(Ino  :  Str20;
                  Digit:  Byte) :  Str255;

Begin
  SetPadNo:=(ConstStr('0',(Digit-Length(Ino)))+Ino);
end;




{ ================ Set CR if Value passed is -ve =============== }

Function SetCR(Rnum  :  Real)  :  Str5;

Const
  CRVal = 'CR';

Begin
  If (Rnum<0) then
    SETCR:=CRVal
  else
    SETCR:='';
end;


{ ============== Function to Check If Str ends in a number ============ }

Function EINum(KeyRef  :  Str255)  :  Boolean;

Var
  LNum   :  LongInt;
  NumFlg :  Boolean;

Begin
  KeyRef:=Strip('B',[#32],KeyRef);

  If (Length(KeyRef)<>0) then
    StrLInt(KeyRef[Length(KeyRef)],NumFlg,LNum)
  else
    NumFlg:=BOff;

  EINum:=NumFlg;
end; {Func..}

{ ========== Function to Return if Str255 is empty ====== }


{ ==============  Function to Return if Input Key Empty ========== }

Function EmptyKeyS(Key2C  :  Str255;
                   Imask  :  Byte;
                   Chk4Z  :  Boolean)  :  Boolean;


Begin
  Result:=(Length(Key2c)=0);

  Result:=((Result) or ((Key2c=ConstStr('0',Imask)) and (Chk4Z))) ;

  Result:=((Result) or (Key2c=LJVar('',Imask)));
end;


{ ==============  Function to Return if Input Key Empty ========== }

Function EmptyKey(Key2C  :  Str255;
                  Imask  :  Byte)  :  Boolean;


Begin
  Result:=EmptyKeyS(Key2C,IMask,BOn);

end;


{ =========== Procedure to Compare an untyped record, with a specified search Str ========== }

Function Match_Glob(Fno         :  Integer;
                    Compare     :  Str30;
                Var CompWith;
                Var Abort       :  Boolean)  : Boolean;

Const
  WildChar  :  CharSet = ['?','*'];

Var
  n,Sn  :  Integer;
  Fok   :  Boolean;
  Found :  GenAry;

Begin
  n:=1; Sn:=1; Fok:=BOff;

  Blank(Found,Sizeof(Found));

  Move(CompWith,Found,Fno);

  While (n<=Fno) and (Not Fok) do
  Begin
    If (UpCase(Compare[1])=Upcase(Found[n])) then
    Begin
      Sn:=1; Fok:=BOn;
      While (Sn<=Length(Compare)) and (Fok) do
      Begin

        Fok:=((Upcase(Compare[Sn])=Upcase(Found[n+Sn-1])) or (Compare[Sn] In WildChar));

        Sn:=Succ(Sn);

      end; {While..}
    end;

    n:=Succ(n);

  end; {While..}

  Match_Glob:=Fok;

end;


{ ============= Function to Return String Equiv of TimeTyp =========== }
Function CurrTimeStr(TimeR  :  TimeTyp)  :  Str10;
Begin
  With TimeR do
    CurrTimeStr:=SetN(HH)+':'+SetN(MM);
end; {Func..}


{ ============= Function to Return String Equiv of TimeTyp =========== }

Function  TimeNowStr  :  Str10;

Var
  TimeR  :  TimeTyp;

Begin
  GetCurrTime(TimeR);

  With TimeR do
    TimeNowStr:=SetN(HH)+SetN(MM)+SetN(SS);
end; {Func..}



{ Function to double up '&' characters for display in menu options & labels }
Function DoubleAmpers (Const InStr : String) : String;
Var
  I : LongInt;
Begin
  If (Pos ('&', InStr) > 0) Then Begin
    Result := '';

    For I := 1 To Length(InStr) Do Begin
      Result := Result + InStr[I];

      If (InStr[I] = '&') Then Result := Result + '&';
    End { For }
  End { If }
  Else
    { no ampersands }
    Result := InStr;
End;

end.
