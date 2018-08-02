Unit ComnU2;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 14/08/90                      }
{                                                              }
{                     Common Overlaid Unit                     }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


Interface

Uses GlobVar,
     BtrvU2,
     VarConst;





Function GetDocGroup(DocHed  :  DocTypes)  :  Byte;

Function SalesorPurch(DocHed  :  DocTypes)  :  Boolean;

Function SetFilterfromDoc(DocHed  :  DocTypes)  :  Str10;

Function GetDocType(DocNo  :  Str20)  :  DocTypes;


Function Pr_OurRef(InvR  :  InvRec)  :  Str10;

Function Calc_PAmount(FullAmount,DiscAmnt  :  Real;
                      DiscCh               :  Char)  :  Real;

// MH 24/03/2009: Created extended version with support for extra Advanced Discounts fields
Function Calc_PAmountAD (FullAmount, DiscAmnt :  Real;
                         DiscCh               :  Char;
                         Disc2Amnt            :  Real;
                         Disc2Ch              :  Char;
                         Disc3Amnt            :  Real;
                         Disc3Ch              :  Char)  :  Real;

Function Calc_OrigfromPcnt(PAmount,DiscAmount  :  Real;
                           Pch                 :  Char) :  Real;

Function Calc_PcntPcnt(PAmount,Pc1,Pc2  :  Real;
                       PCh1,PCh2        :  Char)  :  Real;

Function Calc_PcntPcntAD(PAmount,
                         LineDisc      : Real;
                         LineDiscChr   : Char;
                         LineDisc2     : Real;
                         LineDisc2Chr  : Char;
                         LineDisc3     : Real;
                         LineDisc3Chr  : Char;
                         SettleDisc    : Real;
                         SettleDiscChr : Char)  :  Real;


Function CalcTotalVAT(InvR  :  InvRec)  :  Real;


Function Is_FullStkCode(SCode  :  Str20)  :  Boolean;



Function TotalOs(InvR  :  InvRec)  :  Real;



Function SetRPayment(DocHed  :  DocTypes)  :  Char;

Function LineCnst(P  :  Char)  :  Integer;

Function DetLTotalND(IDr        :  IDetail;
                     UseDisc,
                     UseSetl,
                     ShowDec    :  Boolean;
                     SetlDisc   :  Double)  :  Double;

Function DetLTotal(IDr        :  IDetail;
                   UseDisc,
                   UseSetl    :  Boolean;
                   SetlDisc   :  Double)  :  Double;

Function PPR_Pr(Period  :  Byte)  :  String;

Function PPR_OutPr(Period,Yr  :  Byte)  :  String;

Function Autho_Auto(AuthCode  :  Char)  : Boolean;

Function EmptyAddr(Add2Chk  :  AddrTyp):  Boolean;

Function GetVATCode(VNo  :  Byte)  :  VATType;

Function DrCrVLen(FLen  :  Byte;
                  DOn   :  Boolean)  :  Byte;


Function Ok2DelStk(Mode    :  Byte;
                   StockR  :  StockRec) :  Boolean;

Function Ok2DelNom(Mode  :  Integer;
                   NomR  :  NominalRec)  :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  SysUtils,
  ETMiscU,
  ETDateU,
  ETStrU,
  ComnUnit,
  BTSupU1,
  SysU1,
  BTKeys1U;








{ ================== Return True of Doc as a value from 1-3, Purch/Sales/Nom ============ }

Function GetDocGroup(DocHed  :  DocTypes)  :  Byte;

Var
  Tmp  :  Byte;

Begin
  Tmp:=4;

  If (DocHed In NomSplit) then
    Tmp:=3
  else
    If (DocHed In SalesSplit) then
      Tmp:=2
    else
      If (DocHed In PurchSplit) then
        Tmp:=1
      else
        If (DocHed In WOPSplit) then
          Tmp:=5
        else
          If (DocHed = TSH) then
            Tmp:=6
          else
            If (DocHed = SRN) then
              Tmp:=15
            else
              If (DocHed = PRN) then
                Tmp:=16;


  GetDocGroup:=Tmp;
end;



{ ================== Return True of Doc in Sales Set, False All Others ============ }

Function SalesorPurch(DocHed  :  DocTypes)  :  Boolean;

Begin
  SalesorPurch:=(DocHed In SalesSplit);
end;




{ ================== Return Char Depending on Doc Type =========== }

Function SetFilterfromDoc(DocHed  :  DocTypes)  :  Str10;


Begin
  SetFilterfromDoc:=TradeCode[SalesorPurch(DocHed)];
end;



{ ================== Return Doc Type Based on Doc Number ============= }

Function GetDocType(DocNo  :  Str20)  :  DocTypes;

Var
  DocCount  :  DocTypes;


Begin
  DocCount:=SalesStart;

  {$B-}

  While (DocCount<=FOL) and (Copy(DocNo,1,Length(DocCodes[DocCount]))<>DocCodes[DocCount]) do
    Inc(DocCount);

  GetDocType:=DocCount;
end;


{ ========== Function to return OurRef based on Auto Item ========== }

Function Pr_OurRef(InvR  :  InvRec)  :  Str10;


Begin
  With InvR do
    If (NomAuto) or (EmptyKey(OurRef,DocKeyLen)) or (InvDocHed In BatchSet) or (RunNo=BatchRunNo) then
      Pr_OurRef:=OurRef
    else
      Pr_OurRef:=DocCodes[InvDocHed]+'-AUTO';
end; {Func..}

{ ================== Function to Calculate Discount Amount ============== }

Function Calc_PAmount(FullAmount,DiscAmnt  :  Real;
                      DiscCh               :  Char)  :  Real;


Begin
  If (DiscCh=PcntChr) then
    Calc_PAmount:=(FullAmount*DiscAmnt)
  else
    Calc_PAmount:=DiscAmnt;
end;

// MH 24/03/2009: Created extended version with support for extra Advanced Discounts fields
Function Calc_PAmountAD (FullAmount, DiscAmnt :  Real;
                         DiscCh               :  Char;
                         Disc2Amnt            :  Real;
                         Disc2Ch              :  Char;
                         Disc3Amnt            :  Real;
                         Disc3Ch              :  Char)  :  Real;
Var
  NewDiscBasis : Real;
Begin
  // MH 25/03/2009: Removed rounding as EL doesn't use rounding when calculating Line Discount + Settle Discount

  Result := {Round_Up(}Calc_PAmount(FullAmount, DiscAmnt, DiscCh){, RoundDecs)};

  // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts
  If (Disc2Amnt <> 0.0) Then
  Begin
    NewDiscBasis := {Round_Up(}FullAmount - Result{, RoundDecs)};
    Result := Result + {Round_Up(}Calc_PAmount(NewDiscBasis, Disc2Amnt, Disc2Ch){, RoundDecs)};
  End; // If (Disc2Amnt <> 0.0)
  If (Disc3Amnt <> 0.0) Then
  Begin
    NewDiscBasis := {Round_Up(}FullAmount - Result{, RoundDecs)};
    Result := Result + {Round_Up(}Calc_PAmount(NewDiscBasis, Disc3Amnt, Disc3Ch){, RoundDecs)};
  End; // If (Disc3Amnt <> 0.0)
end;


{ ============= Function to Return original value from discounted result & % ==========}

Function Calc_OrigfromPcnt(PAmount,DiscAmount  :  Real;
                           Pch                 :  Char) :  Real;


Begin
  If (Pch=PcntChr) then
    Calc_OrigfromPcnt:=(Pamount/(1-DiscAmount))
  else
    Calc_OrigfromPcnt:=Pamount+DiscAmount;
end;



{ ============== Function to Calculate Total VAT Based on InvVatAnal =========== }

Function CalcTotalVAT(InvR  :  InvRec)  :  Real;

Var
  n    :  VatType;
  Rnum :  Real;


Begin
  Rnum:=0;

  For n:=Vstart to VEnd do
    Rnum:=Rnum+Round_Up(InvR.InvVatAnal[n],2);

  CalcTotalVAT:=Rnum;
end;


{ ================= Function Calculate pcnt pcnt of Value ============== }


Function Calc_PcntPcnt(PAmount,Pc1,Pc2  :  Real;
                       PCh1,PCh2        :  Char)  :  Real;

Var
  Rnum  :  Real;

Begin
  Rnum:=Calc_PAmount(PAmount,Pc1,PCh1);

  Calc_PcntPcnt:=Rnum+Calc_PAmount(PAmount-Rnum,Pc2,PCh2);
end;

Function Calc_PcntPcntAD(PAmount,
                         LineDisc      : Real;
                         LineDiscChr   : Char;
                         LineDisc2     : Real;
                         LineDisc2Chr  : Char;
                         LineDisc3     : Real;
                         LineDisc3Chr  : Char;
                         SettleDisc    : Real;
                         SettleDiscChr : Char)  :  Real;
Begin
  Result := Calc_PAmountAD (PAmount,
                            LineDisc,LineDiscChr,
                            LineDisc2,LineDisc2Chr,
                            LineDisc3,LineDisc3Chr);

  Result := Result + Calc_PAmount(PAmount-Result, SettleDisc, SettleDiscChr);
end;



{ ======== Function to Check for empty Stock Line ======== }

Function Is_FullStkCode(SCode  :  Str20)  :  Boolean;

Begin

  Is_FullStkCode:=((Not EmptyKey(SCode,StkKeyLen)) and (Not IS_PayInLine(SCode)));

end;




{ ============ Calculate Amount O/S ============ }

Function TotalOs(InvR  :  InvRec)  :  Real;


Begin
  With InvR do
  Begin
    TotalOs:=Round_Up((Itotal(InvR)-Settled),2);
  end;
end;


{ ================= Procedure to Set Reciept Payment Types ================ }

{ (JC) replicated }

Function SetRPayment(DocHed  :  DocTypes)  :  Char;

Var
  TCh  :  Char;

Begin
  TCh:=DocPayType[DocHed];

  If (DocHed In DirectSet) then
    If (TCh=DocPayType[SIN]) then
      TCh:=DocPayType[SRC]
    else
      TCh:=DocPayType[SIN];

  SetRPayment:=TCh;
end;



{ ============== Function to Return Line Cnst Based on Payment Type =========== }

Function LineCnst(P  :  Char)  :  Integer;

Begin
  If (P=DocPayType[SIN]) then
    Result:=-1
  else
    Result:=1;
end;



{Idr Contains the line to be processed.
  UseDisc determines if any line discount needs to be taken into account
  UseSetl determines if any settlement discount needs to be taken into account
  ShowDec True applies the sales or cost no of decimal places to the result, False defaults to 2 decimal places
  SetlDisc is the percentage amount of header level settlement discount to be applied if UseDisc is True.

  }


 { ==================== Calculate One Line of Invoice ================= }

Function DetLTotalND(IDr        :  IDetail;
                     UseDisc,
                     UseSetl,
                     ShowDec    :  Boolean;
                     SetlDisc   :  Double)  :  Double;

Var
  Rnum,
  WithDisc
        :  Double;

  Cnst  :  Integer;

  LineQty,
  CalcNetValue,
  DiscBasis,
  NewDiscBasis,
  PriceEach
        :  Double;

  FinDecs,
  UseDecs,
  UseQDecs
        :  Byte;


Begin
  With Idr do
  Begin
    Cnst:=LineCnst(Payment);

    RNum:=0; WithDisc:=0;  CalcNetValue:=0.0; DiscBasis:=0.0;

    UseQDecs:=Syss.NoQtyDec;

    If (IdDocHed In SalesSplit) then  {* No Dec places determines rounding effect on Purch/Sales *}
      UseDecs:=Syss.NoNetDec
    else
      UseDecs:=Syss.NoCosDec;

    If (ShowDec) then
      FinDecs:=UseDecs
    else
      FinDecs:=2;

    {* Ability to affect unit price factor *}

    If (Round_Up(PriceMulX,FinDecs)<>0.0) then
      CalcNetValue:=(NetValue*PriceMulX)
    else
      CalcNetValue:=NetValue;


    LineQty:=Calc_IdQty(Qty,QtyMul,UsePack);

    If (PrxPack) and (QtyPack<>0) and (QtyMul<>0) then
    Begin
      If (ShowCase) then
      Begin
        PriceEach:=CalcNetValue;
        LineQty:=DivWChk(Qty,QtyPack);

        UseQDecs:=12;  {* If we are using split pack with cases, we cannot round up as it is a factor.. *}
      end
      else
        PriceEach:=(DivWChk(QtyMul,QtyPack)*CalcNetValue);

    end
    else
      PriceEach:=CalcNetValue;

    If (IncNetValue<>0.0) and (VATcode='M') then  {* v5.00.003 Discount is based on original inclusive VAT value *}
      DiscBasis:=IncNetValue
    else
      DiscBasis:=PriceEach;

    // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts
    //Rnum:=Calc_PAmount(Round_Up(DiscBasis,UseDecs),Discount,DiscountChr);
    Rnum:=Calc_PAmountAD(Round_Up(DiscBasis,UseDecs),Discount,DiscountChr, Discount2, Discount2Chr, Discount3, Discount3Chr);

    WithDisc:=Round_Up(Round_Up(LineQty,UseQDecs)*(Round_Up(PriceEach,UseDecs)-Rnum),FinDecs);

    WithDisc:=Round_Up(WithDisc-Calc_PAmount(WithDisc,(SetlDisc*Ord(UseSetl)),PcntChr),FinDecs);

    If (UseDisc) then
      DetLTotalND:=(WithDisc*Cnst)
    else
      DetLTotalND:=Round_Up((Round_Up(LineQty,UseQDecs)*Round_Up(PriceEach,UseDecs)*Cnst),FinDecs);
  end;{With..}
end;




Function DetLTotal(IDr        :  IDetail;
                   UseDisc,
                   UseSetl    :  Boolean;
                   SetlDisc   :  Double)  :  Double;


Begin
  DetLTotal:=DetLTotalND(IdR,UseDisc,UseSetl,BOff,SetlDisc);
end;




{ ====================== Functions to Control Display & Input of Periods ================= }

Function PPR_Pr(Period  :  Byte)  :  String;


Var
  GenStr  :  String;

Begin
  GenStr:='';

  Begin
    If (Not GetLocalPr(0).DispPrAsMonths) then
      GenStr:=SetN(Period)
    else
      GenStr:=LJVar(MonthAry[Pr2Mnth(Period)],3);

  end; {with..}
  PPR_Pr:=GenStr;
end; {Func..}


{ ====================== Functions to Control Display & Input of Periods ================= }

Function PPR_OutPr(Period,Yr  :  Byte)  :  String;

Var
  GenStr  :  Str255;

Begin
  If (Period = YTD) then
    GenStr := 'CTD'
  Else If (Period = YTDNCF) then
    GenStr:=YTDStr
  else
    GenStr:=PPr_Pr(Period);

  Result:=GenStr+DateSeparator+SetPAdNo(Form_Int(ConvTxYrVal(Yr,BOff),0),4);
end; {Func..}



Function Autho_Auto(AuthCode  :  Char)  : Boolean;

Begin

  Autho_Auto:=(AuthCode In ['A']);

end; {Func..}


{ =============== Function to Check if Empty Address ============ }

Function EmptyAddr(Add2Chk  :  AddrTyp):  Boolean;

Var
  n       :  Byte;

Begin
  Result:=BOn;

  For n:=1 to NofAddrLines do
    If (Add2Chk[n]<>'') then
      Result:=BOff;

end;


  { ============== Quickly return vattype from no..  ============= }

  Function GetVATCode(VNo  :  Byte)  :  VATType;

  Var
    TGC  :  VATType;
    n    :  Byte;

  Begin
    TGC:=Standard;

    For n:=1 to Vno do
      Inc(TGC);

    GetVATCode:=Pred(TGC);
  end; {Func..}


{ ======== Function to Return DrCr Equiv Space ========= }
Function DrCrVLen(FLen  :  Byte;
                  DOn   :  Boolean)  :  Byte;
Begin
  DrCrVLen:=Flen+(Succ(FLen)*Ord(DOn));
end; {Func..}


{=== Generic Stk delete function ==== }

Function Ok2DelStk(Mode    :  Byte;
                   StockR  :  StockRec) :  Boolean;

Var
  Purch,
  Sales,
  Cleared  :  Double;

Begin
  Purch:=0; Sales:=0;  Cleared:=0;

  Result:=BOff;


  With StockR do

    If (Mode=99) then {* Only Check for Profit *}
      Result:=(Profit_To_Date(StockType,FullNomKey(StockFolio),0,GetLocalPr(0).CYr,YTD,Purch,Sales,Cleared,BOn)=0)
    else
      Result:=(Profit_To_Date(StockType,FullNomKey(StockFolio),0,GetLocalPr(0).CYr,YTD,Purch,Sales,Cleared,BOn)=0) and
                 (Not CheckExsists(StockCode,StockF,StkCatK)
                 and (Not CheckExsists(StockCode,IDetailF,IdStkK)));


end;


{* This routine is duplicated inside PostSp2U for thread safe operation *}
Function Ok2DelNom(Mode  :  Integer;
                   NomR  :  NominalRec)  :  Boolean;

Var
  Purch,
  Sales,
  Cleared  :  Double;

Begin
  Purch:=0; Sales:=0;  Cleared:=0;

  {$B-}

  With NomR do

    If (Mode=99) then {* Only Check for Profit *}
      Ok2DelNom:=(Profit_To_Date(NomType,FullNomKey(NomCode),0,GetLocalPr(0).CYr,YTD,Purch,Sales,Cleared,BOn)=0)
    else
      Ok2DelNom:=((Profit_To_Date(NomType,FullNomKey(NomCode),0,GetLocalPr(0).CYr,YTD,Purch,Sales,Cleared,BOn)=0) and
                 (Not CheckExsists(FullNomKey(NomCode),NomF,NomCatK)) and
                 (Not CheckExsists(FullNomKey(NomCode),IDetailF,IdNomK)) and
                 (Not CheckExsists(Strip('R',[#0],FullRunNoKey(0,NomCode)),IDetailF,IdRunK)));

  {$B+}
end;



end.