Unit ETMiscU;

{**************************************************************}
{                                                              }
{         ====----> General Misc Routines  Unit <----===       }
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

const
  // Constant to allow for floating-point discrepancies.
  RoundingDiscrepancy: Double = 0.000000001;

Type
  NodePtr    =   ^Node;

  Node       =   Record
                   LItem  :  Pointer;
                   LPrev  :  NodePtr;
                   LNext  :  NodePtr;
                 end;

  GenPtr     =   Pointer;

  ListPtr    =   ^List;

  List       =   Object
                   LastNode,
                   FirstNode   :   NodePtr;

                   Constructor  Init;

                   Destructor Done;

                   Procedure Add(AItem  :  Pointer);

                   Function GetFirst  :  NodePtr;
                   Function GetLast  :  NodePtr;
                   Function GetNext(CPtr  :  NodePtr)  :  NodePtr;
                   Function GetPrev(Cptr  :  NodePtr)  :  NodePtr;
                   Function GetNextCycle(Cptr  :  NodePtr)  :  NodePtr;

                   Function GetPrevCycle(Cptr  :  NodePtr)  :  NodePtr;


                   Function InsAfterItem(InsPtr  :  NodePtr;
                                         AITem   :  Pointer)  :  NodePtr;

                   Function InsB4Item(InsPtr  :  NodePtr;
                                      AITem   :  Pointer)  :  NodePtr;


                   Function DelItem(DelPtr  :  NodePtr)  :  NodePtr;


                 end; {Object..}





Function Round_Up(Num :  Double;
                  Dp  :  Integer)  :  Double;

Function Round_Dn(Num  :  Double;
                  Dp   :  Integer)  :  Double;

Function Power(P  :  Double;
               N  :  Integer)  :  Double;


Function TrueReal(RealN  :  Double;
                  Dp     :  Byte) :  Double;

function TrueTrunc(Value: Double): Int64;

Function ForceRound(Num :  Double;
                  Dp  :  Integer)  :  Double;

Function ForceNearestWhole(Num :  Double;
                           Dp  :  Byte)  :  Double;

Procedure StrReal(StrNum    : Str30;
                  Var StrOK : Boolean;
                  Var RNum  : Real48);
Procedure StrDouble(    StrNum : Str30;
                    Var StrOK  : Boolean;
                    Var RNum   : Double);

Function RealSTR(Str2Conv  :  Str30) : Real;
Function DoubleSTR (Str2Conv : Str30) : Double;

Procedure StrInt(StrNum : Str30;
                  Var StrOK : Boolean;
                  Var INum : Integer);

Procedure StrLInt(StrNum : Str30;
                  Var StrOK : Boolean;
                  Var INum : LongInt);

Function IntSTR(Str2Conv  :  Str30) : LongInt;

Function LIntSTR(Str2Conv  :  Str30) : LongInt;

Function Pcnt(Inum  :  Real):Real;

Function DivWChk(Divide,Divisor  :  Real)  :  Real;

Function Calc_Pcnt(C,S  :  Real)  :  Real;

Function Pcnt2Full(Inum  :  Real):Real;

Function AdjYr(AYr  :  Integer;
               ID   :  Boolean)  :  Integer;

Procedure AdjMnth(Var AMnth,AYr  :  Word;
                      NoMnths    :  Integer);


Procedure GrandTotal(Var  GT  :  Totals;
                          TT  :  Totals);

Procedure GrandAgedTotal(Var  GT  :  AgedTyp;
                              TT  :  AgedTyp);

Procedure ConvNumBase(InStr  :  Str255;
                      Base   :  Byte;
                  Var Err    :  Byte;
                  Var Lnum   :  Longint);

Function Dec2Hex(D  :  LongInt)  :  Str255;


Function IOError(IONo  :  Integer)  :  Str30;

Procedure GetCurrTime(Var TimeR  :  TimeTyp);

{

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses SysUtils, Math;

Const
  HexNumR  :  String[16] = '0123456789ABCDEF';

  { ======= IO Error Constants ========== }

  IOErrors   :  Array[100..126]  Of Str25 = (
                              {100} 'Disk Read Error (100)',
                              {101} 'Disk Full Error (101)',
                              {102} 'File Error (102)',
                              {103} 'File Not Open (103)',
                              {104} 'File R/O Error (104)',
                              {105} 'File W/O Error (105)',
                              {106} 'File Data Error (106)',
                              {107} 'Write Protect Error ',
                              {108} 'Unknown Unit Error',
                              {109} 'Drive Not Ready Error',
                              {110} 'Unknown Command Error',
                              {111} 'CRC Data Error',
                              {112} 'Bad Drive Error',
                              {113} 'Disk Seek Error',
                              {114} 'Unknown Media Error',
                              {115} 'Sector Read Error',
                              {116} 'Device Failure Error',
                              {117} 'Invalid Function Call (1)',
                              {118} 'File Not Found! (2)',
                              {119} 'Path Not Found! (3)',
                              {120} 'Too Many Open Files (4)',
                              {121} 'File Access Denied! (5)',
                              {122} 'Invalid File Handle (6)',
                              {123} 'Invalid File Access (12)',
                              {124} 'Invalid Drive No. (15)',
                              {125} 'Cannot Remove Dir (16)',
                              {126} 'Cannot Rename File (17)'


                                   );


  { ---------------------------------------------------------------- }

  {  List Methods }

  { ---------------------------------------------------------------- }





  Constructor  List.Init;

  Begin
    LastNode:=Nil;
    FirstNode:=Nil;
  end;


  Destructor List.Done;

  Var
  N  :  NodePtr;

  Begin
    While (LastNode<>Nil) do
    Begin
      N:=LastNode;

      If (N^.LItem <> Nil) Then
        Dispose(N^.LItem);

      LastNode:=N^.LPrev;

      Dispose(N);
    end;
  end;


  Procedure List.Add(AItem  :  Pointer);

  Var
  N  :  NodePtr;


  Begin
    New(N);

    N^.LItem:=AItem;
    N^.LPrev:=LastNode;
    N^.LNext:=Nil;


    If (LastNode<>Nil) then
      LastNode^.LNext:=N
    else
      FirstNode:=N;

    LastNode:=N;
  end;


  { ========== Return First Item ============ }

  Function List.GetFirst  :  NodePtr;

  Begin
    GetFirst:=FirstNode;
  end;


  { ========== Return Last Item ============ }

  Function List.GetLast  :  NodePtr;

  Begin
    GetLast:=LastNode;
  end;


  { =========== Get Next Item =========== }

  Function List.GetNext(CPtr  :  NodePtr)  :  NodePtr;

  Begin
    If (CPtr^.LNext<>Nil) then
      GetNext:=Cptr^.LNext
    else
      GetNext:=Nil;
  end;

  { ========== Get Prevoius Item ====== }

  Function List.GetPrev(Cptr  :  NodePtr)  :  NodePtr;

  Begin
    If (Cptr^.LPrev<>Nil) then
      GetPrev:=Cptr^.LPrev
    else
      GetPrev:=Nil;
  end;


  { ========== Get Next, goto First if Nil ========= }

  Function List.GetNextCycle(Cptr  :  NodePtr)  :  NodePtr;

  Var
    n  :  NodePtr;

  Begin
    n:=GetNext(Cptr);

    If (n=Nil) then
      n:=GetFirst;

    GetNextCycle:=n;

  end;


  { ========== Get Prev , goto Last if Nil ========= }

  Function List.GetPrevCycle(Cptr  :  NodePtr)  :  NodePtr;

  Var
    n  :  NodePtr;

  Begin
    n:=GetPrev(Cptr);

    If (n=Nil) then
      n:=GetLast;

    GetPrevCycle:=n;
  end;


  { ========== Insert Item in middle of List ========== }


  Function List.InsAfterItem(InsPtr  :  NodePtr;
                             AITem   :  Pointer)  :  NodePtr;

  Var
  N  :  NodePtr;


  Begin
    New(N);

    N^.LItem:=AItem;
    N^.LPrev:=Nil;
    N^.LNext:=Nil;


    { ** Connect N to Prior ** }

    If (InsPtr<>Nil) then
      N^.LPrev:=InsPtr;

    { ** Point to Next Record ** }

    N^.LNext:=InsPtr^.LNext;


    { ** Point to New Record ** }

    InsPtr^.LNext:=N;

    { ** Select Next Record ** }

    InsPtr:=N^.LNext;

    If (InsPtr<>Nil) then
      { ** Make Prev Point to New Record ** }

      InsPtr^.LPrev:=N
    else
      LastNode:=N;

    InsAfterItem:=N;

  end;



  Function List.InsB4Item(InsPtr  :  NodePtr;
                          AITem   :  Pointer)  :  NodePtr;

  Var
  N  :  NodePtr;


  Begin
    New(N);

    N^.LItem:=AItem;
    N^.LPrev:=Nil;
    N^.LNext:=Nil;


    { ** Connect N to Next ** }

    If (InsPtr<>Nil) then
      N^.LNext:=InsPtr;


    { ** Point N prior to Insptr ** }

    If (InsPtr^.LPrev<>Nil) then
      N^.LPrev:=InsPtr^.LPrev
    else
      FirstNode:=N;


    { ** Point Old Rec back to new rec **}

    InsPtr^.LPrev:=N;


    { ** Select Prev Record ** }

    InsPtr:=N^.LPrev;

    If (InsPtr<>Nil) then
      InsPtr^.LNext:=N;


    InsB4Item:=N;

  end;



  Function List.DelItem(DelPtr  :  NodePtr)  :  NodePtr;


  Var
    N  :  NodePtr;


  Begin
    N:=nil;

    If (DelPtr^.LPrev<>Nil) then
    Begin

    { ** Point to Dels Prev ** }

      N:=DelPtr^.LPrev;


    { ** Make Del Prev Point to Dels Next ** }

      N^.LNext:=DelPtr^.LNext;
    end
    else
      FirstNode:=DelPtr^.LNext;


    If (DelPtr^.LNext<>Nil) then
    Begin

    { ** Point to Dels Next ** }

      N:=DelPtr^.LNext;


    { ** Make Dels Next Point to Dels Prev ** }

      N^.LPrev:=DelPtr^.LPrev;
    end
    else
      LastNode:=DelPtr^.LPrev;



    Dispose(DelPtr);  {  Run Items Own Desturct }

    If (GetLast<>Nil) or (GetFirst<>Nil) then
      DelItem:=N
    else
      DelItem:=NIL;

  end;





{ ============= Return the Power of a number ============== }

Function Power(P  :  Double;
               N  :  Integer)  :  Double;

Var
  Tp  :  Double;
  m   :  Integer;


Begin
  Tp:=1;

  If (n<>0) then
    For m:=1 to n do
      Tp:=(Tp*p);

  Power:=Tp;

end; {Func..}



{ ================= Routine to enable accurate storage of 2 dec plac. reals ===== }
Function TrueReal(RealN  :  Double;
                  Dp     :  Byte) :  Double;

Var
  TmpStr   :  String;
  Chk      :  Integer;
  TmpReal  :  Double;

Begin
  TmpReal:=0;
  Str(RealN:1:Dp,TmpStr);

  Val(TmpStr,TMpReal,Chk);
  TrueReal:=TmpReal
end;

{ ================= Routine to Trunc very large values ===== }

Function TruncDouble(RealN  :  Double)  :  Double; {*EN431PRD*}

Var
  TmpStr   :  String;
  Chk      :  Integer;
  TmpReal  :  Double;
  Dp       :  Byte;

Begin
  TmpReal:=0.0;


  Str(RealN:1:11,TmpStr);

  Dp:=Pos('.',TmpStr);

  If (Dp<>0) then
  Begin
    Val(Copy(TmpStr,1,Pred(Dp)),TMpReal,Chk);

    If (Chk<>0) then
      TmpReal:=RealN;
  end
  else
    TmpReal:=RealN;

  TruncDouble:=TmpReal;
end;

{ ========= Function to Round to Dp no of places ========== }

{ ========= If DP+1 = 5 force to 6 to ensure correct rounding ======= }

Function Round_Up(Num :  Double;
                  Dp  :  Integer)  :  Double;


Var
  NumStr  :  String;
  Minus   :  Boolean;

  MinCnst :  Integer;

  TRnum   :  Double;


Begin

  Minus:=BOff;

  MinCnst:=1;


  Begin

    Minus:=(Num<0);

    If (Minus) then
      MinCnst:=-1;

    If (Num>=MinLInt) and (Num<=MaxLInt) then
      TRnum:=TrueReal((Num-Trunc(Num)),10) {* True Real introduced here because this subtraction causing 17.325-17
                                             to equal 0.32499999998, by using truereal here to 10 dec places this error
                                             is corrected *}
    else
      TRnum:=TrueReal((Num-TruncDouble(Num)),10);


    Str(Trnum:1:11,NumStr);  {* Changed back from Succ(Dp) because -0.00499 to 2 dec was working out @ -0.005 *}

    If (Length(NumStr)>=Dp+(3+Ord(Minus))) then
      If (IntStr(NumStr[Dp+(3+Ord(Minus))])=5) then
        Num:=Num+(DivWChk(0.1,Power(10,Dp))*MinCnst);
  end;

  Round_Up:=TrueReal(Num,Dp);
end;


{ ====== Function to Round_Down!! Tight Gits ====== }

Function Round_Dn(Num  :  Double;
                  Dp   :  Integer)  :  Double;

Var
  TStr  :  String;
  TNum  :  Double;

Begin

  Tnum:=(Num-Trunc(Num));

  Str(TNum:0:12,TStr);

  Round_Dn:=Trunc(Num)+RealStr(Copy(TStr,1,(DP+2)));

end; {Func..}


{ Numbers which are represented inaccurately, such as 2.0 as 1.999999999, will
  be truncated erroneously. This function adjusts the value before truncating
  it, to try to prevent these issues. }
function TrueTrunc(Value: Double): Int64;
begin
  Result := Trunc(Value + RoundingDiscrepancy);
end;

{ Rounds up to the specified number of decimal places, attempting to adjust for
  floating-point inaccuracies. }
function ForceRound(Num: Double; Dp: Integer): Double;
var
  AdjustmentFactor: Double;
  RoundingBoundary: Double;
begin
  // Sanity-check -- no negative decimal places!
  if (Dp < 0) then Dp := 0;
  // Multiply the number by a factor large enough to push all the decimal places
  // into the integer part (e.g. left-shift it by the number of decimal places).
  AdjustmentFactor := IntPower(10, Dp);
  Num := Num * AdjustmentFactor;
  // Calculate a boundary value to allow for floating-point discrepancies.
  RoundingBoundary := RoundingDiscrepancy * AdjustmentFactor;
  // Adjust it to the next highest integer, then right-shift it back to the
  // correct number of decimal places.
  if (Abs(Num - TrueTrunc(Num)) > RoundingBoundary) then
    Num := Num + 1;
  Result := TrueTrunc(Num) / AdjustmentFactor;
end;

{ ========== Procedure to Force Rounding up if [Dp] Digit >0 ========= }

(*
Function ForceRound(Num :  Double;
                  Dp  :  Integer)  :  Double;


Const
  Rnd_Const  :  Array[0..3] of Double = (0,0.006,0.0006,0.00006);

Var
  NumStr  :  String;


Begin
{$R+}
  If Dp<0 then Dp:=0;
  Str((Num-Trunc(Num)):1:11,NumStr);
  If (IntStr(NumStr[Dp+3])>0) then
    Num:=Num+Rnd_Const[Dp-1];
{$R-}
  ForceRound:=TrueReal(Num,Dp);
end;
*)


{ ========== Procedure to Force Doube to nearest whole ========= }

Function ForceNearestWhole(Num :  Double;
                           Dp  :  Byte)  :  Double;



Var
  NumStr  :  String;


Begin
  Str((Num-Trunc(Num)):1:Dp,NumStr);

  If (Round(DoubleStr(NumStr)*100)>0) then
    Result:=Trunc(Num)+1
  else
    Result:=Trunc(Num);
end;


Procedure StrReal(StrNum    : Str30;
                  Var StrOK : Boolean;
                  Var RNum  : Real48);

Var
  Chk  :  Integer;

Begin
  StrOK:=FALSE;  Rnum:=0;
  StrNum := Trim(StrNum);
  If (StrNum<>'') then
  Begin
    Val(StrNum,Rnum,Chk);
    StrOK:=(Chk=0);
  end
  else
  StrOK:=True;
end;

{ MH: Added 21/03/96 }
Procedure StrDouble(    StrNum : Str30;
                    Var StrOK  : Boolean;
                    Var RNum   : Double);
Var
  Chk  :  Integer;
Begin
  StrOK:=FALSE;
  Rnum:=0;

  StrNum := Trim(StrNum);

  { remove any 000's commas as they cause problems }
  If (Length(StrNum) > 0) Then
    While (Pos(',', StrNum) > 0) Do
      Delete (StrNum, Pos(',', StrNum), 1);

  If (StrNum <> '') Then Begin
    Val (StrNum, Rnum, Chk);
    StrOK := (Chk = 0);
  end
  else
    StrOK:=True;
end;



{ ============= Function to Temporarily Conver Str Value to Real ======== }

Function RealSTR(Str2Conv  :  Str30) : Real;

Var
  Flg  :  Boolean;
  Rnum :  Real48;

Begin
  StrReal(Str2Conv,Flg,Rnum);
  RealStr:=Rnum;
end;

{ MH: Added 21/03/96 }
Function DoubleSTR (Str2Conv : Str30) : Double;
Var
  Flg  : Boolean;
  Rnum : Double;
Begin
  StrDouble(Str2Conv, Flg, Rnum);
  Result := Rnum;
end;


Procedure StrInt(StrNum : Str30;
                  Var StrOK : Boolean;
                  Var INum : Integer);

Var
  Chk  :  Integer;

Begin
  StrOK:=FALSE; Inum:=0;
  If (StrNum<>'') then
  Begin
    Val(StrNum,Inum,Chk);
    StrOK:=(Chk=0);

  end
  else
    StrOK:=True;
end;







{ ========= Longint - String ========= }


Procedure StrLInt(StrNum : Str30;
                  Var StrOK : Boolean;
                  Var INum : LongInt);

Var
  Chk  :  Integer;

Begin
  StrOK:=FALSE; Inum:=0;
  StrNum := Trim(StrNum);
  If (StrNum<>'') then
  Begin
    Val(StrNum,Inum,Chk);
    StrOk:=(Chk=0);
  end
  else
  StrOK:=True;
end;


{ ============= Function to Temporarily Convert Str Value to Int ======== }

Function IntSTR(Str2Conv  :  Str30) : LongInt;

Var
  Flg  :  Boolean;
  Inum :  LongInt;

Begin
  StrLInt(Str2Conv,Flg,Inum );
  IntStr:=Inum;
end;


{ ============= Function to Temporarily Convert Str Value to Int ======== }

Function LIntSTR(Str2Conv  :  Str30) : LongInt;

Var
  Flg  :  Boolean;
  Inum :  LongInt;

Begin
  StrLInt(Str2Conv,Flg,Inum);
  LIntStr:=Inum;
end;



{ ==== Function to convert % whole no into frac ==== }


Function Pcnt(Inum  :  Real):Real;

Begin
  PCnt:=Inum/100;
end;




{ ==== Function to convert frac inti Whole no==== }


Function Pcnt2Full(Inum  :  Real):Real;

Begin
  PCnt2Full:=Inum*100;
end;


{ ===== Function Divide One Numeber Into Another ===== }

Function DivWChk(Divide,Divisor  :  Real)  :  Real;

Begin
  If (Divisor<>0) then
    DivWChk:=Divide/Divisor
  else
    DivWChk:=0;
end; {Func..}


{ ==== Function to Calculate 1 no. as a % of another ==== }


Function Calc_Pcnt(C,S  :  Real)  :  Real;

Begin
  If (C=0) then
    C:=ABS(S);

  Calc_Pcnt:=Round_Up((DivWChk(S,C)*100),1);

end; {Func..}



Function AdjYr(AYr  :  Integer;
               ID   :  Boolean)  :  Integer;

Begin
  If (ID) then
    Inc(AYr)
  else
    Dec(AYr);

  If (Ayr<0) then  {* This check was commented out,
                      but in so going, balances b/f
                      from 2000 were not correct. Restored  b431.099/v4.31.003}
    Ayr:=99;

  AdjYr:=AYr;
end;


{ ========= Function to Inc/Dec Mnth ======== }

Procedure LAdjMnth(Var AMnth,AYr :  Integer;
                      NoMnths    :  Integer);

Var
  Cnst  :  Integer;
  ID    :  Boolean;


Begin
  ID:=(NoMnths>=0);

  If (ID) then
    Cnst:=1
  else
    Cnst:=-1;

  Amnth:=Amnth+NoMnths;

  If (AMnth>12) or (AMnth<1) then
  Begin
    AMnth:=(Amnth-(12*Cnst));

    AYr:=AdjYr(AYr,ID);

    If (Amnth>12) or (Amnth<1) then
    Begin
      Amnth:=(Amnth-(1*Cnst));

      LAdjMnth(Amnth,Ayr,Cnst);
    end;
  end;
end;


{ ========= Function to Inc/Dec Mnth ======== }

Procedure AdjMnth(Var AMnth,AYr  :  Word;
                      NoMnths    :  Integer);

Var
  LAMnth,
  LAyr  :  Integer;

Begin
  LAMnth:=AMnth; LAYr:=AYr;

  LAdjMnth(LAMnth,LAYr,NoMnths);

  If (LAMnth>=0) and (LAYr>=0) then
  Begin
    AMnth:=LAMnth; AYr:=LAYr;
  end;

end;





{ ============== Procedure to Add One set of Totals to another ============= }

Procedure GrandTotal(Var  GT  :  Totals;
                          TT  :  Totals);

Var
  n   :  Byte;

Begin
  For n:=1 to NoTotals do
    GT[n]:=GT[n]+TT[n];
end;


{ ============== Procedure to Add One set of Totals to another ============= }

Procedure GrandAgedTotal(Var  GT  :  AgedTyp;
                              TT  :  AgedTyp);

Var
  n   :  Byte;

Begin
  For n:=1 to NoAgedTyps do
    GT[n]:=GT[n]+TT[n];
end;


{ ======== Various Routines for Hex-Dec converions ======== }

Procedure ConvNumBase(InStr  :  Str255;
                      Base   :  Byte;
                  Var Err    :  Byte;
                  Var Lnum   :  Longint);




Var
  I  :  Integer;


Begin

  Lnum:=0;

  Err:=0;

  If (Base<=16) and (Base>=2) then
  Begin

    For I:=1 to Length(InStr) do
      If (InStr[I] In ['0'..'9','A'..'F']) and (Pos(InStr[I],HexNumR)-1 <Base) then
        Lnum:=Lnum * Base + Pos(InStr[I],HexNumR) -1
      else
        Err:=1;
  end {If..}
  else
    Err:=2;

end; {Proc..}



{ ====== Procedure to display conversion ===== }


Procedure PutNum(Lnum  :  LongInt;
                 Base  :  Byte;
             Var OutStr:  Str255);



Begin

  If (Lnum>=1) then
  Begin

    PutNum(Trunc(Lnum/Base),Base,OutStr);

    OutStr:=OutStr + (HexNumR[Round((Lnum/Base - INT(Lnum/Base)) * Base)+1]);

  end;

end;


{ ======= Function Dec2Hex ======= }

Function Dec2Hex(D  :  LongInt)  :  Str255;


Var

  Err     :  Byte;
  Lnum    :  LongInt;
  TmpStr  :  Str255;


Begin


  Str(D:0,TmpStr);

  ConvNumBase(TmpStr,10,Err,Lnum);

  TmpStr:='';

  If (Err=0) then
    PutNum(Lnum,16,TmpStr)
  else
    TmpStr:='';


  While (Length(TmpStr)<4) do
    TmpStr:='0'+TmpStr;

  Dec2Hex:=TmpStr;

end;



{ ========= Function to Return IOError ========== }

Function IOError(IONo  :  Integer)  :  Str30;


Begin
  If (IONo In [100..106]) then
    IOError:=IOErrors[IONo]
  else
    If (IONo In [150..158]) then
      IOError:=IOErrors[IONo-43]
    else
      If (IONo In [1..6]) then
        IOError:=IOErrors[IONo+116]
      else
        If (IONo In [12]) then
          IOError:=IOErrors[123]
      else
        If (IONo In [15..17]) then
          IOError:=IOErrors[IOno+109]
        else
          IOError:=IOErrors[116];
end; {Func..}


{ ======== Procedure to Return Current Time in TimeTyp Rec  ======== }
Procedure GetCurrTime(Var TimeR  :  TimeTyp);
Var
  HH, MM, SS, MSec : Word;
Begin
  DecodeTime(Time, HH, MM, SS, MSec);
  TimeR.HH := HH;
  TimeR.MM := MM;
  TimeR.SS := SS;
end;



end.
