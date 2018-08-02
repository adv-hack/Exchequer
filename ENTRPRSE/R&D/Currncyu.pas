Unit CurrncyU;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 03/08/90                      }
{                                                              }
{                     Currency Control Unit                    }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,VarRec2U,VarConst;



Var
  Currency_Default,
  CurrTxlate_Def     :  Byte;   { Global Var showing current currency }



Function UseCoDayRate  :  Boolean;

Function PSymb(Cno  :  Byte)  :  Str5;

Function SSymb(Cno  :  Byte)  :  Str5;


Function CurrDesc(FCr  :  Byte)  :  Str30;

Function Show_TreeCur(NCr,NTxCr  :  Byte)  :  Str255;

Function  Conv_TCurr(Amount  :  Double;
                     Rate    :  Double;
                     RCr,
                     CMode   :  Byte;
                     Too     :  Boolean)  :  Double;


  Function  Conv_Curr(Amount  :  Double;
                      Rate    :  Double;
                      Too     :  Boolean)  :  Double;

  Procedure SetTriRec(Currency,
                      UseORate  :  Byte;
                 Var  TriRec    :  TriCurType);


  Function  Conv_VATCurr(Amount,
                         VRate,
                         IRate    :  Double;
                         ICurr,
                         CMode    :  Byte)  :  Double;

  Function Calc_BConvCXRate(InvR      :  InvRec;
                          OrigX     :  Real;
                          OrigMode  :  Boolean)  :  Double;

  Function  Currency_ConvFT(Amount  :  Double;
                            Fc,Ft   :  Byte;
                            UseRate :  Boolean)  :  Double;

  Function Currency_Txlate(Amount  :  Double;
                           Fc,Ft   :  Byte)  :  Double;

  {$IFDEF EX601}

    Function JBBCurrency_Txlate(Amount  :  Double;
                                Fc,Ft   :  Byte)  :  Double;
  {$ENDIF}
  
  Function XRate(CXRate  :  CurrTypes;
                 CurDRte :  Boolean;
                 Currency:  Byte)  :  Double;

  Function fxUseORate(Ignore,
                      ChkXRate:  Boolean;
                      CXRate  :  CurrTypes;
                      UOR,
                      Currency,
                      Mode    :  Byte)  :  Byte;

Function ITotEqL(IGTot,IVTot,
                 LDis,SDis,PDis    :  Real)  :  Real;


Function ConvCurrITotal(IRec         :  InvRec;
                        UseDayRate,
                        UseVariance,
                        UseRound     :  Boolean)  :  Real;

Function ConvCurrITotORG(IRec         :  InvRec;
                         UseDayRate,
                         UseVariance,
                         UseRound     :  Boolean)  :  Real;

Function ConvCurrICost(IRec         :  InvRec;
                       UseDayRate,
                       UseRound     :  Boolean)  :  Real;

Function ConvCurrINet(IRec         :  InvRec;
                      UseDayRate,
                      UseRound     :  Boolean)  :  Real;



Function ConsolITotal(IR  :  InvRec)  :  Real;

Function BaseTotalOs(InvR  :  InvRec)  :  Real;

Function CurrencyOS(IRec         :  InvRec;
                    UseRound,
                    SterEquiv,
                    UseCODay     :  Boolean) :  Real;

Function SettledFullCurr(InvR  :  InvRec)  :  Boolean;

Function SettledFull(InvR  :  InvRec)  :  Boolean;

Function FigCoDayDiff(Amount  :  Real;
                      CXRate  :  CurrTypes;
                      Currency:  Byte)  :  Real;

Function InvVariance(InvR  :  InvRec)  :  Real;

Function DiffHedXRate(InvR  :  InvRec;
                      IdR   :  IDetail)  :  Boolean;

//GS 06/10/2011 ABSEXCH-11367: added a default param to the method declairation
//allowing bypassing the updating of the batch records
Procedure Set_DocAlcStat(Var  InvR  :  InvRec; UpdateBatchRecords: Boolean = True);


Procedure UpdateCustBal(OI,IR  :  InvRec);


Function ReValued(InvR  :  InvRec)  :  Boolean;


Function View_Status(InvR       :  InvRec;
                     ReadOnly   :  Boolean;
                 Var ViewMsg    :  Byte)  :  Boolean;


Procedure UpdateAllBal(Bal,FullBal,
                       OwnBal       :  Double;
                       View         :  Boolean;
                       DT           :  DocTypes);

procedure ResetGlobAlloc(Mode  :  Boolean);

// Returns TRUE if the currency is used - this is determined by checking that the name is set and the rates are non-zero
Function IsCurrencyUsed (Const CurrencyNo : Byte) : Boolean;

//PR: 09/03/2012 ABSEXCH-10199 Modified version of ConvCurrItotal function, above. This returns the total of a transaction in currency,
//but, unlike ComnUnit.ITotal, includes Variance, RevalueAdj, & PostDiscAm, converted from Consolidated to transaction currency.
//This total should be identical (if translated to base) which the value returned by ConvCurrItotal.
Function CurrTotalWithVariance(IRec         :  InvRec;
                               UseDayRate,
                               UseVariance,
                               UseRound     :  Boolean)  :  Real;

//PR: 09/03/2012 ABSEXCH-10199 O/S Total in currency including variance (uses CurrTotalWithVariance)
Function CurrencyOsWithVariance(InvR  :  InvRec)  :  Real;

//PR: 20/06/2012 ABSEXCH-11528 Function to return total order value including or excluding VAT as required by system setup
Function ConvCurrOrderTotal(IRec         :  InvRec;
                            UseDayRate,
                            UseRound     :  Boolean)  :  Real;



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   SysUtils,
   VarJCStU,
   ETStrU,
   ETMiscU,
   ComnUnit,
   ComnU2,
   BTKeys1U,
   BTSupU2,
   PWarnU,

   {$IFDEF CU}
     ExWrap1U,
     Event1U,
   {$ENDIF}

   SysU1,
   SysU2;



 Const
   CurrNoItems   =   5;         { No items in currency rec }


   RLimit        =   CurrNoItems;


//-------------------------------------------------------------------------

// Returns TRUE if the currency is used - this is determined by checking that the name or symbols are set and the rates are non-zero
Function IsCurrencyUsed (Const CurrencyNo : Byte) : Boolean;
Begin // IsCurrencyUsed
  // Consolidated is always used - is the only currency for Single Currency systems
  Result := (CurrencyNo = 0);

  {$IFDEF MC_On}
    // Euro (Consolidated + 1-2) / Global (Consolidated + 1-90)
    If Not Result Then
    Begin
      // Check currency number is within valid range for licensing
      If (EuroVers And (CurrencyNo In [1..2])) Or ((Not EuroVers) And (CurrencyNo In [1..CurrencyType])) Then
      Begin
        // Valid Currency Number for licence - check for any details being set in System Setup - Currencies
        With SyssCurr.Currencies[CurrencyNo] Do
          Result := (Trim(Desc) <> '') Or (Trim(SSymb) <> '') Or (Trim(PSymb) <> '') Or (CRates[False] <> 0.0) Or (CRates[True] <> 0.0)
      End // If (EuroVers And (CurrencyNo In [1..2])) Or ((Not EuroVers) And (CurrencyNo In [1..CurrencyType]))
      Else
        // Invalid Currency Number
        Result := False;
    End; // Else
  {$ENDIF}
End; // IsCurrencyUsed

//-------------------------------------------------------------------------

{ =========== Function to Return Given Currency Symbol =========== }

Function PSymb(Cno  :  Byte)  :  Str5;


Var
  CurLEnd  :  SmallInt;

Begin
  If (EuroVers) then
    CurLEnd:=2
  else
    CurLEnd:=CurrencyType;

  If (Cno<=CurLEnd) then
    PSymb:=TxLatePound(SyssCurr.Currencies[Cno].PSymb,BOn)
  else
    PSymb:='***';
end;


{ =========== Function to Return Given Currency Symbol =========== }

Function SSymb(Cno  :  Byte)  :  Str5;

Var
  CurLEnd  :  SmallInt;

Begin
  If (EuroVers) then
    CurLEnd:=2
  else
    CurLEnd:=CurrencyType;

  If (Cno<=CurLEnd) then
    SSymb:=ExtractWords(1,1,StdCurrList[Cno])
  else
    SSymb:='***';
end;




{ =========== Function to Return Currency & Symbol ========== }

Function CurrDesc(FCr  :  Byte)  :  Str30;
Var
  CSymb  :  Str5;

Begin
  If (FCr<=CurrencyType) then
  Begin
    CSymb:=SSymb(FCr);

    With SyssCurr.Currencies[FCr] do
      CurrDesc:=CSymb+'-'+Desc+' ';
  end
  else
    CurrDesc:='Invalid Currency! ('+Form_Int(FCr,0)+')';

end; {Func..}



{ ============= Procedure to Display Currency ============== }


Function Show_TreeCur(NCr,NTxCr  :  Byte)  :  Str255;


Var
  TxMess  :  Str80;

  SMess   :  Str5;

Begin

  Result:='';

{$IFDEF MC_On}

  TxMess:='';

  If (NCr<>NTxCr) and (NTxCr<>0) then
  Begin
    SMess:=SSymb(NTxCr);

    With SyssCurr.Currencies[NTxCr] do
      TxMess:='->'+Desc+' '+SMess;
  end;

  SMess:=SSymb(NCr);

  With SyssCurr.Currencies[NCr] do
    Result:=Desc+' '+SMess+TxMess;


{$ENDIF}

end;



{ Use Company/Day Rate  - Set to True if Use Xchange rate has been chosen, False if Use Co Rate }

Function  UseCoDayRate  :  Boolean;

Begin
  UseCoDayRate:=(Syss.TotalConv=XDayCode);
end;




  Function  Conv_Curr(Amount  :  Double;
                      Rate    :  Double;
                      Too     :  Boolean)  :  Double;

  Var
    NewAmnt  :  Double;

  Begin
    NewAmnt:=0.0;

    If (Too) then
      NewAmnt:=Amount*Rate
    else
      If (Rate<>0) then
        NewAmnt:=DivWChk(Amount,Rate);


    Conv_Curr:=NewAmnt;
  end;



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
      If (SyssGCuR^.GhostRates.TriFloat[RCr]) then {* Base is participating so any floating rates must also be done via triangulation *}
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

          NewAmnt:=Conv_Curr(DivWChk(Amount,SyssGCuR^.GhostRates.TriRates[RCr]),Rate,{Not} SyssGCuR^.GhostRates.TriInvert[RCr]);

        end;
      end;

    end;


  Conv_TCurr:=NewAmnt;
end;




{ == Procedure to Store prevailing triangulation rate == }

Procedure SetTriRec(Currency,
                      UseORate  :  Byte;
                 Var  TriRec    :  TriCurType);


  Begin
    If (UseORate=0) then
    With SyssGCur^ do
    Begin
      TriRec.TriRates:=GhostRates.TriRates[Currency];
      TriRec.TriEuro:=GhostRates.TriEuro[Currency];
      TriRec.TriInvert:=GhostRates.TriInvert[Currency];
      TriRec.TriFloat:=GhostRates.TriFloat[Currency];
    end
    else
      FillChar(TriRec,Sizeof(TriRec),0);

  end;




(*  Convert from Amount to VAT currency via Base currency *)

Function  Conv_VATCurr(Amount,
                       VRate,
                       IRate    :  Double;
                       ICurr,
                       CMode    :  Byte)  :  Double;

Var
  NewAmnt  :  Double;
  VCMode   :  Byte;


Begin
  NewAmnt:=0;

  If (ICurr<>Syss.VATCurr) then
  Begin
    If (VRate=0) then
    Begin
      VRate:=SyssCurr^.Currencies[Syss.VATCurr].CRates[BOn];
      VCMode:=0;
    end
    else
      VCMode:=CMode;

    NewAmnt:=Conv_TCurr(Amount,IRate,ICurr,CMode,BOff);

    Conv_VATCurr:=Conv_TCurr(NewAmnt,VRate,Syss.VATCurr,VCMode,BOn);
  end
  else
    Conv_VATCurr:=Amount;
end;


{ == Function to substitue Doc CXRate with OldOrigRates post base conversion == }

Function Calc_BConvCXRate(InvR      :  InvRec;
                          OrigX     :  Real;
                          OrigMode  :  Boolean)  :  Double;

Var
  GenRates  :   CurrTypes;

Begin
  Result:=OrigX;

  With InvR do
  Begin
    If (OldORates[OrigMode]<>0.0) then {* We have been through a conversion, and this needs to be stated}
      Result:=OldORates[OrigMode];        {in original currency*}


  end;

end;




(* Convert to Current day rate, Selected Doc.Co/Day Rate or Current Co. *)
{ Replicated in EXREBULD\COMNUNIT }

Function XRate(CXRate  :  CurrTypes;
               CurDRte :  Boolean;
               Currency:  Byte)  :  Double;



Var
  Trate  :  Double;


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


(*  Convert from one currency via Default currency to another *)

Function  Currency_ConvFT(Amount  :  Double;
                          Fc,Ft   :  Byte;
                          UseRate :  Boolean)  :  Double;

Var
  NewAmnt  :  Double;



Begin
  With SyssCurr^.Currencies[Fc] do
    NewAmnt:=Conv_TCurr(Amount,CRates[UseRate],Fc,0,BOff);

  With SyssCurr^.Currencies[Ft] do
    Currency_ConvFT:=Conv_TCurr(NewAmnt,CRates[UseRate],Ft,0,BOn);

end;


(* Translate via day rate one currency to another *)

Function Currency_Txlate(Amount  :  Double;
                         Fc,Ft   :  Byte)  :  Double;

Var
  TriCr    :  Byte;

  NewAmnt  :  Double;
Begin
  TriCr := 0;
  If (Ft<>Fc) and (Ft<>0) then
  With SyssGCuR^.GhostRates do
  Begin
    If ((TriEuro[Fc]=Ft) and (Ft<>0)) or ((TriEuro[Ft]=Fc) and (Fc<>0)) or ((TriEuro[Fc]<>0) and (TriEuro[Ft]<>0)) then
    Begin
      NewAmnt:=Amount;

      If (TriEuro[Fc]<>0) then
        TriCr:=TriEuro[Fc]
      else
        If (TriEuro[Ft]<>0) then
          TriCr:=TriEuro[Ft];

      If (Fc<>TriCr) then
        NewAmnt:=Conv_TCurr(Amount,TriRates[Fc],0,0,BOff);

      If (Ft<>TriCr) then
        NewAmnt:=Conv_TCurr(NewAmnt,TriRates[Ft],0,0,BOn);

      Currency_Txlate:=NewAmnt;
    end
    else
      Currency_Txlate:=Currency_ConvFT(Amount,Fc,Ft,BOn)
  end
  else
    Currency_TxLate:=Amount;

end;

{$IFDEF EX601}

(* Translate via day rate one currency to another, ignore currency 0 *)

Function JBBCurrency_Txlate(Amount  :  Double;
                            Fc,Ft   :  Byte)  :  Double;

Begin
  If (Ft=0) then
    Ft:=1;

  Result:=Currency_Txlate(Amount,Fc,Ft);

end;

{$ENDIF}



{ ============== Calulate Rounded up Version of Invoice Total ============== }

Function ITotEqL(IGTot,IVTot,
                 LDis,SDis,PDis    :  Real)  :  Real;


Begin
  ITotEqL:=(Round_Up(IGTot,2)+Round_Up(IVTot,2)-Round_Up(PDis,2)-(Round_Up(LDis,2)*Ord(Syss.SepDiscounts))-Round_up(SDis,2));
end;




{ =============== Return Converted to Base Invoice Total ============== }

Function ConvCurrITotal(IRec         :  InvRec;
                        UseDayRate,
                        UseVariance,
                        UseRound     :  Boolean)  :  Real;

Var
  Rate  :  Real;
  UOR,
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

    If (InvDocHed In QuotesSet) then
      UOR:=fxUseORate(UseDayRate,BOn,CXRate,UseORate,Currency,0)
    else
      UOR:=0;


    ConvCurrItotal:=Round_Up(Conv_TCurr(InvNetVal,Rate,Currency,UOR,BOff),Dp)
                   +Round_Up(Conv_TCurr(InvVat,CXRate[BOn],Currency,UseORate,BOff),Dp)
                   -Round_Up(Conv_TCurr(DiscAmount,Rate,Currency,UOR,BOff),Dp)
                   +Round_Up((Variance*Ord(UseVariance)),Dp)
                   +Round_Up(ReValueAdj,Dp)
                   -Round_Up((Conv_TCurr(DiscSetAm,Rate,Currency,UOR,BOff)*Ord(DiscTaken)),Dp)
                   +Round_up(PostDiscAm*Ord(UseVariance),Dp);
  end;
end;


//PR: 20/06/2012 ABSEXCH-11528 Function to return total order value including or excluding VAT as required by system setup
Function ConvCurrOrderTotal(IRec         :  InvRec;
                            UseDayRate,
                            UseRound     :  Boolean)  :  Real;
begin
  if Syss.IncludeVATInCommittedBalance then
    Result := ConvCurrITotal(IRec, UseDayRate, False, UseRound)
  else
    Result := ConvCurrINet(IRec, UseDayRate, UseRound);
end;



{ =============== Return Converted to Base Invoice Total Using original Rate ============== }

Function ConvCurrITotORG(IRec         :  InvRec;
                         UseDayRate,
                         UseVariance,
                         UseRound     :  Boolean)  :  Real;

Var
  Rate  :  Real;
  DP,UOR
        :  Byte;

Begin
  Rate:=0; UOR:=0;

  With IRec do
  Begin

    If (UseRound) then
      Dp:=2
    else
      Dp:=11;

    Rate:=XRate(OrigRates,UseDayRate,Currency);

    UOR:=fxUseORate(UseDayRate,BOn,OrigRates,UseORate,Currency,0);

    ConvCurrItotORG:=Round_Up(Conv_TCurr(InvNetVal,Rate,Currency,UOR,BOff),Dp)
                    +Round_Up(Conv_TCurr(InvVat,CXRate[BOn],Currency,UOR,BOff),Dp)
                    -Round_Up(Conv_TCurr(DiscAmount,Rate,Currency,UOR,BOff),Dp)
                    -Round_Up((Conv_TCurr(DiscSetAm,Rate,Currency,UOR,BOff)*Ord(DiscTaken)),Dp);
  end;
end;


{ =============== Return Converted to Base Invoice Total ============== }

Function ConvCurrICost(IRec         :  InvRec;
                       UseDayRate,
                       UseRound     :  Boolean)  :  Real;

Var
  Rate  :  Real;
  DP,UOR
        :  Byte;

Begin
  Rate:=0; UOR:=0;

  With IRec do
  Begin

    If (UseRound) then
      Dp:=2
    else
      Dp:=11;

    Rate:=XRate(CXRate,UseDayRate,Currency);

    UOR:=fxUseORate(UseDayRate,BOn,CXRate,UseORate,Currency,0);

    ConvCurrICost:=Round_Up(Conv_TCurr(TotalCost,Rate,Currency,UOR,BOff),Dp);

  end;
end;


{ =============== Return Converted to Base Invoice Total ============== }

Function ConvCurrINet(IRec         :  InvRec;
                      UseDayRate,
                      UseRound     :  Boolean)  :  Real;

Var
  Rate  :  Real;
  DP,UOR
        :  Byte;

Begin
  Rate:=0; UOR:=0;

  With IRec do
  Begin

    If (UseRound) then
      Dp:=2
    else
      Dp:=11;

    Rate:=XRate(CXRate,UseDayRate,Currency);

    UOR:=fxUseORate(UseDayRate,BOn,CXRate,UseORate,Currency,0);

    ConvCurrINet:=Round_Up(Conv_TCurr((ITotal(IRec)-InvVAT),Rate,Currency,UOR,BOff),Dp);

  end;
end;

{ ============ Function to return Consolidated signed invoice total =========== }

Function ConsolITotal(IR  :  InvRec)  :  Real;

Begin
  With IR do
    ConsolITotal:=ConvCurrITotal(IR,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst;
end;




{ ============ Calculate Amount O/S ============ }

Function BaseTotalOs(InvR  :  InvRec)  :  Real;


Begin
  With InvR do
  Begin
    If (Not (InvDocHed In QuotesSet)) and (NomAuto) then
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
  DP,UOR
        :  Byte;

Begin
  Rate:=0;

  With IRec do
  Begin

    If (UseRound) then
      Dp:=2
    else
      Dp:=11;

    If (SterEquiv) then
    Begin
      Rate:=XRate(CXRate,UseCODay,Currency);

      UOR:=fxUseORate(UseCODay,BOn,CXRate,UseORate,Currency,0);
    end
    else
    Begin
      Rate:=1;
      UOR:=0;
    end;

    If (Not (InvDocHed In QuotesSet)) and (NomAuto) then
    Begin
      If (Not SterEquiv) then
        CurrencyOs:=Round_Up((ITotal(IRec)*DocCnst[InvDocHed]*DocNotCnst)-CurrSettled,Dp)
      else
        CurrencyOs:=Round_Up(Conv_TCurr(((ITotal(IRec)*DocCnst[InvDocHed]*DocNotCnst)-CurrSettled),Rate,Currency,UOR,BOff),Dp);
    end
    else
      CurrencyOS:=0.0;

  end;
end;




{ ============= Calculate if settled ============= }

Function SettledFull(InvR  :  InvRec)  :  Boolean;

Begin
  With InvR do
  SettledFull:=(BaseTotalOS(InvR)=0);
end;



{ ============= Calculate if settled by Currency Reckoning ============= }

Function SettledFullCurr(InvR  :  InvRec)  :  Boolean;

Begin
  SettledFullCurr:=(CurrencyOS(InvR,BOn,BOff,BOff)=0);
end;



{ ============== Calculate Difference between the Co rate version of a number,
                 and the day rate (Used for VAT diff on Direct) ============== }

Function FigCoDayDiff(Amount  :  Real;
                      CXRate  :  CurrTypes;
                      Currency:  Byte)  :  Real;

Begin
  FigCoDayDiff:=Round_Up(Conv_TCurr(Amount,CXRate[BOn],Currency,0,BOff),2)
               -Round_Up(Conv_TCurr(Amount,XRate(CXRate,BOff,Currency),Currency,0,BOff),2);
end;





{ ============= Calculate Variance - CoRate Value - Today Rate ============ }

Function InvVariance(InvR  :  InvRec)  :  Real;

Begin
  With InvR do
    InvVariance:=(Round_Up(ConvCurrITotal(InvR,BOn,BOn,BOn),2)-Round_Up(ConvCurrITotal(InvR,BOff,BOn,BOn),2));

end;


{ == Misc procedure to check if the header exchange rate is diff to a line exchange rate ==}

Function DiffHedXRate(InvR  :  InvRec;
                      IdR   :  IDetail)  :  Boolean;


Var
  TBo     :  Boolean;


Begin
  Result:=BOff;

  For TBo:=BOff to BOn do
  Begin
    Result:=InvR.CXRate[TBo]<>IdR.CXRate[TBo];

    If (Result) then
      Break;

  end;

  If (Not Result) then
  Begin
    Result:=(InvR.CurrTriR.TriRates<>IdR.CurrTriR.TriRates) or
            (InvR.CurrTriR.TriEuro<>IdR.CurrTriR.TriEuro) or
            (InvR.CurrTriR.TriInvert<>IdR.CurrTriR.TriInvert) or
            (InvR.CurrTriR.TriFloat<>IdR.CurrTriR.TriFloat);

  end;
end; {Func..}




{ ====== Set Doc Alloc Status ====== }
//GS 06/10/2011 ABSEXCH-11367: added a default param to the method
//allowing bypassing the updating of the batch records
Procedure Set_DocAlcStat(Var  InvR  :  InvRec; UpdateBatchRecords: Boolean = True);


Var
  Mode  :  Byte;
  TmpBo :  Boolean;
  Rnum  :  Real;

Begin

  Mode:=HoldSP;

  Rnum:=Round_Up(BaseTotalOS(InvR),2);


  With InvR do
  Begin

    If (InvDocHed In DocAllocSet) and (Rnum<>0) and (RunNo>=0)  then
    Begin
      TmpBo:=(InvDocHed In SalesSplit);

      AllocStat:=TradeCode[TmpBo];

      UntilDate:=NDXWeight;
      //GS 06/10/2011 ABSEXCH-11367: modified the call to 'SetHold' for
      //allowing bypassing the updating of the batch records
      If (Autho_Auto(Syss.AuthMode)) and (Not OnHold(HoldFlg)) then
        SetHold(Mode,0,0,BOff,InvR, UpdateBatchRecords);

    end
    else
    Begin

      // CJS 2016-04-14 - ABSEXCH-2704 - Filtered customer ledger includes zero value rows
      // NDXWeight in UntilDate indicates that the Transaction is unallocated.
      // For zero-value transactions this should be cleared.
      if ((RNum = 0) and (UntilDate = NDXWeight)) then
        UntilDate := '';

      AllocStat:=#0;

    end;

  end; {With..}

end;




  { ============== Procedure to update acc balance based on previois invoice ============= }

  Procedure UpdateCustBal(OI,IR  :  InvRec);

  Begin
    With IR do
    Begin
      UpdateBal(OI,(ConvCurrITotal(OI,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   (ConvCurrICost(OI,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   (ConvCurrINet(OI,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   BOn,2);

      UpdateBal(IR,(ConvCurrITotal(IR,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   (ConvCurrICost(IR,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   (ConvCurrINet(IR,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   BOff,2);
    end;
  end;



{ ================ Function to Check if something is revalued ============== }

Function ReValued(InvR  :  InvRec)  :  Boolean;

Begin
  With InvR do
    ReValued:=((XRate(CXRate,BOff,Currency)<>SyssCurr.Currencies[Currency].CRates[BOff]) and (Not UseCoDayRate)
              and (Not SBSIn) and (Not (InvDocHed In DirectSet)));
end; {Func..}






{ ================ Function to Return The Status of a Document ============= }

Function View_Status(InvR       :  InvRec;
                     ReadOnly   :  Boolean;
                 Var ViewMsg    :  Byte)  :  Boolean;


{$IFDEF CU}
  Var
    ExLocal  :  TdExLocal;
{$ENDIF}
Begin
  ViewMsg:=0;

  With InvR do
    If (RunNo>0) or (RunNo=BatchPostRunNo) or (RunNo=StkAdjRunNo) or (RunNo=OrdPSRunNo) or (RunNo=OrdPPRunNo) or (RunNo=TSTPostRunNo)
      or (RunNo=WORPPRunNo) {$IFDEF JC}  or (RunNo=JSAPRunNo) or (RunNo=JPAPRunNo) {$ENDIF}  or (RunNo=SRNPRunNo) or (RunNo=PRNPRunNo) then
      ViewMsg:=1
    else
      If (ReValued(InvR)) then
        ViewMsg:=2
      else
        If (((InvDocHed In SINExternSet) and (Syss.ExternSIN)) or ((ExternalDoc) and (Not SBSIn))) then
          ViewMsg:=3
        else
        {$IFNDEF EXDLL} // HM 05/01/05: This was breaking the checks on whether transactions could be edited

          If (PrintedDoc) and (Not PChkAllowed_In(107)) then {* Its been printed and user not allowed in *}
            ViewMsg:=4
          else
        {$ENDIF}
            If (((Round_Up(Settled,2)<>0) or (Round_Up(GlobalAllocRec^[SalesorPurch(InvDocHed)].LUnallocated,2)<>0))
               and (Not (InvDocHed In DirectSet+ NomSplit )) ) then

              {* Its not unallocated *}

              ViewMsg:=5
            else
              If ((Not EmptyKey(VATPostDate,LDateKeyLen)) and (SettledVAT<>0)
                 and (VAT_CashAcc(SyssVAT.VATRates.VATScheme))) then {* Its been through the Cash accounting system *}
                ViewMsg:=6
              else
                If (RunNo=BatchRunNo) and (Not BatchEdit) then  {* Must be a batch or Auto Item *}
                  ViewMsg:=7
                else
                  If ((InStock) or (InStockEnq)) and ((Found_DocEditNow(FolioNum)<>0)) then  {* Being viewed from stock ledger *}
                    ViewMsg:=8
                  else
                    If (Not ((BoChkAllowed_In(InvDocHed In (SalesSplit-OrderSet),03)) or
                             (BoChkAllowed_In(InvDocHed In (PurchSplit-OrderSet),12)) or
                             (BoChkAllowed_In(InvDocHed In NomSplit,26)) or
                             (BoChkAllowed_In(InvDocHed In (OrderSet-PurchSplit),156)) or
                             (BoChkAllowed_In(InvDocHed In (OrderSet-SalesSplit),166)) or
                             (BoChkAllowed_In(InvDocHed In (TSTSplit),217)) or
                             (BoChkAllowed_In(InvDocHed In (WOPSplit),376)) or
                             (BoChkAllowed_In(InvDocHed In (JAPPurchSplit),436)) or
                             (BoChkAllowed_In(InvDocHed In (JAPSalesSplit),445)) or


                             (BoChkAllowed_In(InvDocHed In (StkRETSalesSplit),578)) or
                             (BoChkAllowed_In(InvDocHed In (StkRETPurchSplit),532)) or

                             (BoChkAllowed_In(InvDocHed In (StkAdjSplit),118)))) then

                      ViewMsg:=9
                    else
                      If (ReadOnly) or ((Found_DocEditNow(FolioNum)<>0)) then  {* We only are permitting a view *}
                        ViewMsg:=9;       {* Make sure this is always the last condition tested *}


  If (ViewMsg=0) and (InvR.RunNo=0) and (Not (InvR.InvDocHed In BatchSet+StkAdjSplit+QuotesSet)) then {* Check for part post *}
    ViewMsg:=Check4PostLine(InvR);


  {$IFDEF CU}
    If (ViewMsg=0) and (ICEDFM<>0) then {* We are in dripfeed mode so check we can edit this transaction *}
    Begin
      ExLocal.Create;

      Try
        ExLocal.LInv:=InvR;

        If (Not ExecuteCustBtn(2000,158,ExLocal)) then
          ViewMSg:=9;
      finally
        ExLocal.Destroy;
      end; {Try..}

    end;
  {$ENDIF}

  View_Status:=(ViewMsg<>0);
end; {Func..}



 { ============= Update Unallocated Figure ============== }

 Procedure UpdateAllBal(Bal,FullBal,
                        OwnBal       :  Double;
                        View         :  Boolean;
                        DT           :  DocTypes);


  Begin

    With GlobalAllocRec^[SalesorPurch(DT)] do
    Begin
      LUnallocated:=LUnallocated+Bal;

      LFullUnallocated:=LFullUnallocated+FullBal;

      LFullOwnUnalloc:=LFullOwnUnalloc+OwnBal;

    end; {With..}

  end;


procedure ResetGlobAlloc(Mode  :  Boolean);

Begin

  With GlobalAllocRec^[Mode] do
  Begin
    LUnallocated:=0;  LFullUnallocated:=0;

    LFullOwnUnalloc:=0; LFullDisc:=0;

    Blank(LRemitDoc,Sizeof(LRemitDoc));

    LLastMDoc:=SIN;
  end;

end;


//PR: 09/03/2012 ABSEXCH-10199 Modified version of ConvCurrItotal function, above. This returns the total of a transaction in currency,
//but, unlike ITotal includes Variance & PostDiscAm (but not RevalueAdj), converted from Consolidated to transaction currency.
//This total should be identical (if translated to base) which the value returned by ConvCurrItotal.
Function CurrTotalWithVariance(IRec         :  InvRec;
                               UseDayRate,
                               UseVariance,
                               UseRound     :  Boolean)  :  Real;

Var
  Rate  :  Real;
  UOR,
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

    If (InvDocHed In QuotesSet) then
      UOR:=fxUseORate(UseDayRate,BOn,CXRate,UseORate,Currency,0)
    else
      UOR:=0;


    Result := InvNetVal +
              InvVat -
              DiscAmount +
              Round_Up(Conv_TCurr(Variance, Rate, Currency, UOR, True) * Ord(UseVariance),Dp) - //PR: 23/03/2012 Changed + to -
              DiscSetAm*Ord(DiscTaken) +
              Round_Up(Conv_TCurr(PostDiscAm, Rate, Currency, UOR, True) * Ord(UseVariance),Dp);
  end;
end;

//PR: 09/03/2012 ABSEXCH-10199 O/S Total in currency including variance (uses CurrTotalWithVariance)
Function CurrencyOsWithVariance(InvR  :  InvRec)  :  Real;
Begin
  With InvR do
  Begin
    If (Not (InvDocHed In QuotesSet)) and (NomAuto) then
      Result := Round_Up(((CurrTotalWithVariance(InvR,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst)-CurrSettled),2)
    else
      Result := 0.0;
  end;
end;


Begin

  CurrTxlate_Def:=0;

{$IFDEF MC_On}

  Currency_Default:=1;

{$ELSE}

  Currency_Default:=0;

{$ENDIF}


end.