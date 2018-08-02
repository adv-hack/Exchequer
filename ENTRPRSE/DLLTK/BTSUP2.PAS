unit Btsup2;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{F+}


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 21/07/93                      }
{                                                              }
{                     Internal Export Modeule                  }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses
  GlobVar,
  VarConst,
  VarCnst3;

(*
Function Fin_Yr(IDate  :  Str8)  :  SmallInt;

Function Fin_Pr(IDate  :  Str8)  :  Byte;

*)

Function ITotal(IRec  :  InvRec)  :  Real;

Function  UseCoDayRate  :  Boolean;

Function XRate(CXRate  :  CurrTypes;
               CurDRte :  Boolean;
               Currency:  Byte)  :  Real;

{* 02.02.99 New Conv_TCurr has been used. New parameter CMode has been added *}
Function  Conv_TCurr(Amount  :  Double;
                     Rate    :  Double;
                     RCr,
                     CMode   :  Byte;
                     Too     :  Boolean)  :  Double;
(*
Function  Conv_TCurr(Amount  :  Double;
                     Rate    :  Double;
                     RCr     :  Byte;
                     Too     :  Boolean)  :  Double;
*)

Function  Conv_Curr(Amount  :  Real;
                    Rate    :  Real;
                    Too     :  Boolean)  :  Real;

Function  Currency_ConvFT(Amount  :  Real;
                          Fc,Ft   :  Byte;
                          UseRate :  Boolean)  :  Real;

Function ConvCurrITotal(IRec         :  InvRec;
                        UseDayRate,
                        UseVariance,
                        UseRound     :  Boolean)  :  Real;

Function ConvCurrICost(IRec         :  InvRec;
                       UseDayRate,
                       UseRound     :  Boolean)  :  Real;

Function ConvCurrINet(IRec         :  InvRec;
                      UseDayRate,
                      UseRound     :  Boolean)  :  Real;

Function BaseTotalOs(InvR  :  InvRec)  :  Real;


Function CurrencyOS(IRec         :  InvRec;
                    UseRound,
                    SterEquiv,
                    UseCODay     :  Boolean) :  Real;

Function Is_FullStkCode(SCode  :  Str20)  :  Boolean;

Function fxUseORate(Ignore,
                    ChkXRate:  Boolean;
                    CXRate  :  CurrTypes;
                    UOR,
                    Currency,
                    Mode    :  Byte)  :  Byte;

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   SysUtils,
   ETStrU,
   ETDateU,
   ETMiscU,
   BtrvU16,
   BtSup1,
   FIFOLU;


Const
  StkAdjCnst     :  Array[BOff..BOn] of Integer    = (-1, 1);
  StkOpoSet      =  [SCR,SJC,SRF,PIN,PJI,PPI,PDN];        {* Docs crediting Stock *}
  StkPUpSet      =  [PIN,PPI,PJI,PDN];   {* Docs which update the Last cost price *}




{ =========== Calculate Period from Month ============== }

Function Mnth2Pr(Mnth  :  Byte)  :  Byte;
Var
  Tpr  :  Integer;
  TmpMnth  :  Integer;

Begin

  Tpr:=0; TmpMnth:=0;

  TmpMnth:=Part_Date('M',Syss.MonWk1);

  Tpr:=Succ(Mnth - TmpMnth);

  {Tpr:=Succ((Mnth-Part_Date('M',Syss.MonWk1)));}

  If (Tpr<1) then
    Mnth2Pr:=(Tpr+12)
  else
    Mnth2Pr:=Tpr;
end;


{ =========== Calculate Mnth from Period No. ============ }

Function Pr2Mnth(Pr  :  Byte)  :  Byte;
Var
  TPr  :  Integer;
Begin
  If (Pr>0) then

    Tpr:=Pred(Pr)+Part_Date('M',Syss.MonWk1)

  else
    TPr:=0;

  If (TPr>12) then
    TPr:=(Tpr-12);

  If (TPr>12) then {** Not Monthly Periods! **}
    TPr:=0;

  Pr2Mnth:=TPr;
end;



{ =========== Return Correct Financial Yr ============= }


Function Proper_FinYr(CurrMnth,CYr  :  SmallInt)  :  SmallInt;
Var
  Pyr  :  Integer;
Begin
  If (CurrMnth-Pr2Mnth(1)<0) then
      PYr:=Pred(CYr)
    else
      PYr:=CYr;

  If (PYr<0) then
    PYr:=99;

  Proper_FinYr:=PYr;
end; {Func..}





{ ========= Return Correct Financial Yr based on Full Date ======= }


Function Fin_Yr(IDate  :  Str8)  :  SmallInt;


Var
  Fy,Fm,Fd :  Word;



Begin

  {Old}DateStr(IDate,Fd,Fm,Fy);

  Fin_Yr:=Proper_FinYr(Fm,Fy);
end;



{ ========= Return Correct Financial Pr based on Full Date ======= }


Function Fin_Pr(IDate  :  Str8)  :  Byte;


Var
  Fy,Fm,Fd :  Word;



Begin

  {Old}DateStr(IDate,Fd,Fm,Fy);

  Fin_Pr:=Mnth2Pr(Fm);
end;


  { =============== Return Invoice Total ============== }

Function ITotal(IRec  :  InvRec)  :  Real;

  Begin

    With IRec do
      ITotal:=(InvNetVal+InvVat)-DiscAmount-(DiscSetAm*Ord(DiscTaken));
  end;



{ Use Company/Day Rate  - Set to True if Use Xchange rate has been chosen, False if Use Co Rate }

Function  UseCoDayRate  :  Boolean;

Begin
  UseCoDayRate:=(Syss.TotalConv=XDayCode);
end;


(* Convert to Current day rate, Selected Doc.Co/Day Rate or Current Co. *)

Function XRate(CXRate  :  CurrTypes;
               CurDRte :  Boolean;
               Currency:  Byte)  :  Real;



Var
  Trate  :  Real;


Begin
  Trate:=0;

  With SyssCurr^.Currencies[Currency] do
  Begin

    If (CurDRte) then
      Trate:=CRates[BOn]
    else
      If (CXRate[UseCoDayRate]<>0) then
        Trate:=CXRate[UseCoDayRate]
      else
        Trate:=CRates[BOff];
  end; {With..}

  XRate:=Trate;
end; {Func..}


(*
Function  Conv_TCurr(Amount  :  Double;
                     Rate    :  Double;
                     RCr     :  Byte;
                     Too     :  Boolean)  :  Double;

Var
  NewAmnt  :  Double;



Begin
  NewAmnt:=0;

    NewAmnt:=0;

    If (RCr In [0,1]) or ((SyssGCuR^.GhostRates.TriEuro[RCr]=0) and (Not SyssGCuR^.GhostRates.TriFloat[RCr])) then
    Begin

      If (SyssGCuR^.GhostRates.TriInvert[RCr]) then
        Too:=Not Too;

      NewAmnt:=Conv_Curr(Amount,Rate,Too);


    end
    else
    Begin
      If (SyssGCuR^.GhostRates.TriFloat[RCr]) then
      {* Base is participating so any floating rates must also be done via triangulation *}
      Begin

        If (Too) then
        Begin
          NewAmnt:=Conv_Curr(DivWChk(Amount,SyssGCuR^.GhostRates.TriRates[RCr]),Rate,Not SyssGCuR^.GhostRates.TriInvert[RCr]);

        end
        else
        Begin
          NewAmnt:=Conv_Curr(Amount,Rate,SyssGCuR^.GhostRates.TriInvert[RCr])*SyssGCuR^.GhostRates.TriRates[RCr];

        end;
      end
      else
      Begin
        If (Too) then
        Begin
          NewAmnt:=Conv_Curr(Amount,Rate,Not SyssGCuR^.GhostRates.TriInvert[RCr])*SyssGCuR^.GhostRates.TriRates[RCr];
        end
        else
        Begin
          {* The not changed v4.23p as otherwise base equivalent of triangulated currencies was not right *}

          NewAmnt:=Conv_Curr(DivWChk(Amount,SyssGCuR^.GhostRates.TriRates[RCr]),Rate,
                             {Not} SyssGCuR^.GhostRates.TriInvert[RCr]);

        end;
      end;

    end;

  Conv_TCurr:=NewAmnt;

end;
*)
Function  Conv_TCurr(Amount  :  Double;
                     Rate    :  Double;
                     RCr,
                     CMode   :  Byte;
                     Too     :  Boolean)  :  Double;

Var
  NewAmnt  :  Double;



Begin
  NewAmnt:=0;

    If (RCr In [0,1]) or ((SyssGCuR^.GhostRates.TriEuro[RCr]=0) and (Not SyssGCuR^.GhostRates.TriFloat[RCr]))
    or (CMode=1) then
    Begin

      If (SyssGCuR^.GhostRates.TriInvert[RCr]) and (CMode<>1) then
        Too:=Not Too;

      NewAmnt:=Conv_Curr(Amount,Rate,Too);


    end
    else
    Begin
      {* Base is participating so any floating rates must also be done via triangulation *}
      If (SyssGCuR^.GhostRates.TriFloat[RCr]) then
      Begin

        If (Too) then
        Begin
          NewAmnt:=Conv_Curr(DivWChk(Amount,SyssGCuR^.GhostRates.TriRates[RCr]),Rate,Not SyssGCuR^.GhostRates.TriInvert[RCr]);

        end
        else
        Begin
          NewAmnt:=Conv_Curr(Amount,Rate,SyssGCuR^.GhostRates.TriInvert[RCr])*SyssGCuR^.GhostRates.TriRates[RCr];

        end;
      end
      else
      Begin
        If (Too) then
        Begin
          NewAmnt:=Conv_Curr(Amount,Rate,Not SyssGCuR^.GhostRates.TriInvert[RCr])*SyssGCuR^.GhostRates.TriRates[RCr];
        end
        else
        Begin
          {* The not changed v4.23p as otherwise base equivalent of triangulated currencies was not right *}

          NewAmnt:=Conv_Curr(DivWChk(Amount,SyssGCuR^.GhostRates.TriRates[RCr]),
                                     Rate,{Not} SyssGCuR^.GhostRates.TriInvert[RCr]);

        end;
      end;

    end;


  Conv_TCurr:=NewAmnt;
end;




(*  Convert from one currency to another *)

Function  Conv_Curr(Amount  :  Real;
                    Rate    :  Real;
                    Too     :  Boolean)  :  Real;

Var
  NewAmnt  :  Real;



Begin

  NewAmnt:=0.0;

  If (Too) then
    NewAmnt:=Amount*Rate
  else
    If (Rate<>0) then
      NewAmnt:=DivWChk(Amount,Rate);

  Conv_Curr:=NewAmnt;

end;

(*  Convert from one currency via Default currency to another *)

Function  Currency_ConvFT(Amount  :  Real;
                          Fc,Ft   :  Byte;
                          UseRate :  Boolean)  :  Real;

Var
  NewAmnt  :  Real;



Begin
  With SyssCurr^.Currencies[Fc] do
    NewAmnt:=Conv_TCurr(Amount,CRates[UseRate],Fc,0,BOff);

  With SyssCurr^.Currencies[Ft] do
    Currency_ConvFT:=Conv_TCurr(NewAmnt,CRates[UseRate],Ft,0,BOn);

end;



{ =============== Return Converted to Base Invoice Total ============== }

Function ConvCurrITotal(IRec         :  InvRec;
                        UseDayRate,
                        UseVariance,
                        UseRound     :  Boolean)  :  Real;

Var
  Rate  :  Real;
  DP    :  Byte;
  TmpVal:  Real;

Begin
  Rate:=0;

  With IRec do
  Begin

    If (UseRound) then
      Dp:=2
    else
      Dp:=11;

    Rate:=XRate(CXRate,UseDayRate,Currency);

    ConvCurrItotal:=Round_Up(Conv_TCurr(InvNetVal,Rate,Currency,0,BOff),Dp)
                   +Round_Up(Conv_TCurr(InvVat,CXRate[BOn],Currency,0,BOff),Dp)
                   -Round_Up(Conv_TCurr(DiscAmount,Rate,Currency,0,BOff),Dp)
                   +Round_Up((Variance*Ord(UseVariance)),Dp)
                   +Round_Up(ReValueAdj,Dp)
                   -Round_Up((Conv_TCurr(DiscSetAm,Rate,Currency,0,BOff)*Ord(DiscTaken)),Dp)
                   +Round_up(PostDiscAm*Ord(UseVariance),Dp);
  end;
end;

{ =============== Return Converted to Base Invoice Total ============== }

Function ConvCurrICost(IRec         :  InvRec;
                       UseDayRate,
                       UseRound     :  Boolean)  :  Real;

Var
  Rate  :  Real;
  DP    :  Byte;

Begin
  Rate:=0;

  With IRec do
  Begin

    If (UseRound) then
      Dp:=2
    else
      Dp:=11;

    Rate:=XRate(CXRate,UseDayRate,Currency);

    ConvCurrICost:=Round_Up(Conv_TCurr(TotalCost,Rate,Currency,0,BOff),Dp);

  end;

end;


{ =============== Return Converted to Base Invoice Total ============== }

Function ConvCurrINet(IRec         :  InvRec;
                      UseDayRate,
                      UseRound     :  Boolean)  :  Real;

Var
  Rate  :  Real;
  DP    :  Byte;

Begin
  Rate:=0;

  With IRec do
  Begin

    If (UseRound) then
      Dp:=2
    else
      Dp:=11;

    Rate:=XRate(CXRate,UseDayRate,Currency);

    ConvCurrINet:=Round_Up(Conv_TCurr((ITotal(IRec)-InvVAT),Rate,Currency,0,BOff),Dp);

  end;

end;



{ ============ Function to determine if line is a paymode line ========== }

Function IS_PayInLine(PayRef  :  Str20)  :  Boolean;

Begin

  IS_PayInLine:=((Length(PayRef)>0) and (PayRef[1] In [PayInCode,PayOutCode]));

end; {Func..}


{ ======== Function to Check for empty Stock Line ======== }

Function Is_FullStkCode(SCode  :  Str20)  :  Boolean;

Begin

  Is_FullStkCode:=((Not EmptyKey(SCode,StkLen)) and (Not IS_PayInLine(SCode)));

end;

{ ============ Calculate Amount O/S ============ }

Function BaseTotalOs(InvR  :  InvRec)  :  Real;


Begin
  With InvR do
  Begin
    If (Not (InvDocHed In QuotesSet)) then
      BaseTotalOs:=Round_Up(((ConvCurrITotal(InvR,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst)-Settled),2)
    else
      BaseTotalOS:=0.0;
  end;

end;

{ =============== Return Own Currency O/S Total ============== }

Function CurrencyOS(IRec         :  InvRec;
                    UseRound,
                    SterEquiv,
                    UseCODay     :  Boolean) :  Real;

Var
  Rate  :  Real;
  DP    :  Byte;

Begin
  Rate:=0;

  With IRec do
  Begin

    If (UseRound) then
      Dp:=2
    else
      Dp:=11;

    If (SterEquiv) then
      Rate:=XRate(CXRate,UseCODay,Currency)
    else
      Rate:=1;

    {* Copied from CurrencyU - 05.01.99 *}
    If (Not (InvDocHed In QuotesSet)) then
    Begin
      If (Not SterEquiv) then
        CurrencyOs:=Round_Up((ITotal(IRec)*DocCnst[InvDocHed]*DocNotCnst)-CurrSettled,Dp)
      else
        CurrencyOs:=Round_Up(Conv_TCurr(((ITotal(IRec)*DocCnst[InvDocHed]*DocNotCnst)-CurrSettled),Rate,Currency,0,BOff),Dp);
    end
    else
      CurrencyOS:=0.0;

    { Closed on 05.01.99 ...
    If (Not (InvDocHed In QuotesSet)) then
      CurrencyOs:=Round_Up(Conv_TCurr(((ITotal(IRec)*DocCnst[InvDocHed]*DocNotCnst)-CurrSettled),Rate,Currency,BOff),Dp)
    else
      CurrencyOS:=0.0;
    }
  end;
end;

{== Function to return the UseORate flag depending on certain factors ==}


Function fxUseORate(Ignore,
                    ChkXRate:  Boolean;
                    CXRate  :  CurrTypes;
                    UOR,
                    Currency,
                    Mode    :  Byte)  :  Byte;



Begin
  Result:=0;

  If (Not Ignore) then
  Begin
    If (ChkXRate) then {* If rate used not 0, then set flag *}
    Begin
      If (CXRate[UseCoDayRate]<>0.0) then
        Result:=UOR;

    end
    else
      Result:=UOR;
  end;

end;




end.

