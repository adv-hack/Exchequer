unit SalePric;

{ markd6 12:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{ eald6  11:51 12/08/2004: Added support for Date sensitive pricing }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses GlobVar, VarConst, VarRec2U, ExBtTh1U,QtyBreakVar;

Procedure Calc_StockPrice(      BtrObj  : TdPostExLocalPtr;
                                TStock  : StockRec;
                                TCust   :  CustRec;
                                TCurr   :  Byte;
                                TQty    :  Real;
                                TDate  :  LongDate;
                          Var   UPrice,
                                DiscR   :  Real;
                          Var   DiscCh  :  Char;
                          Const LCode   :  Str10;
                          Var   FoundOk :  Boolean);

Procedure SetROUpdate(    StockR   :  StockRec;
                      Var TStkLoc  :  MStkLocType);

Procedure SetROConsts(StockR   :  StockRec;
                  Var TStkLoc  :  MStkLocType;
                      TLocLoc  :  MLocLocType);

Procedure SetTakeUpdate(    StockR   :  StockRec;
                        Var TStkLoc  :  MStkLocType);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses ETStrU,
     ETMiscU,
     BtrvU2,
     BtSupU1,
     BtKeys1U,
     ComnUnit,
     Comnu2,
     CurrncyU;

Var
  PromoDatesFound  :  Boolean;


Procedure SetTakeUpdate(    StockR   :  StockRec;
                        Var TStkLoc  :  MStkLocType);

Begin
  With StockR, TStkLoc do
  Begin
    lsQtyFreeze:=QtyFreeze;
    lsQtyTake:=QtyTake;
    lsStkFlg:=StkFlg;
  end;
end;


Function Calc_AccDMatch(BtrObj  : TdPostExLocalPtr;
                        TStock  :  StockRec;
                        TCust   :  CustRec;
                        TCurr   :  Byte;
                        TDate  :  LongDate;
                        Fnum,
                        Keypath :  Integer)  :  Boolean;
var
  KeyChk, KeyMS : Str255;
  FoundOK, DefFound : Boolean;
  TmpMisc : MiscRec;
Begin
  FoundOk:=BOff; DefFound:=BOff;

  KeyChk:=FullQDKey(CDDiscCode,TCust.CustSupp,MakeCDKey(TCust.CustCode,TStock.StockCode,TCurr));

  KeyMS:=KeyChk;

  With BtrObj^ do
  Begin
    LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyMS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyMS,Length(KeyChk),BOn)) and (Not FoundOk) do
    With LMiscRecs^.CustDiscRec do
    Begin
      FoundOk:=(Not CUseDates) or ((TDate>=CStartD) and (TDate<=CEndD));

      If (FoundOk) and (Not CUseDates) and (Not DefFound) then {* See if there are others *}
      Begin
        DefFound:=BOn;
        FoundOk:=BOff;
        TmpMisc:=LMiscRecs^;
      end;

      If (Not FoundOk) then
        LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyMS);

    end;
    If (Not FoundOk) and (DefFound) then {* Re-instate the default one as it was the only one *}
    Begin
      LMiscRecs^:=TmpMisc;
      FoundOk:=Bon;
    end;

  end; {With..}


  Result:=FoundOk;
end;



  Function Get_DiscTree(BtrObj  : TdPostExLocalPtr;Scode  :  Str20)  :  Boolean;
  Begin
    If (Not EmptyKey(Scode,StkKeyLen)) then
      With BtrObj^ do
        Get_DiscTree:=LCheckRecExsists(Strip('R',[#0],Scode),StockF,StkCodeK)
    else
      Get_DiscTree:=BOff;

  end; {Func..}

  
  { ======= Function to Match Qty Break ========
    SS:17/08/2016:ABSEXCH-14877 Function to use new Qty Breaks file.}

  Function Calc_QtyBreak(BtrObj  : TdPostExLocalPtr;
                         TStock  :  StockRec;
                         TCust   :  CustRec;
                         TCurr   :  Byte;
                         TQty    :  Real;
                         TDate   :  LongDate;
                         Fnum,
                         Keypath :  Integer;
                         Mode    :  Byte;
                         QBFolio : longint = 0)  :  Boolean;

  Var
    KeyS,
    KeyChk  :  Str255;
    DefFound,
    FoundOk :  Boolean;
    TmpQtyBreak   :  TQtyBreakRec;
  Begin

    FoundOk:=BOff;
    DefFound:=BOff;
     

    Case Mode of
      1  :  begin
              KeyChk := QtyBreakStartKey('', TStock.StockFolio, False) + Char(TCurr);
              KeyPath := qbAcCodeIdx;
            end;
      2  :  begin
              KeyChk := FullNomKey(QBFolio);
              KeyPath := qbFolioIdx;
            end; 
    end; {Case..}

    KeyS:=KeyChk;

    With BtrObj^ do
    Begin

      lStatus:=lFind_Rec(B_GetGEq,QtyBreakF,Keypath,KeyS);

      While (lStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
      With LQtyBreakRec do
      Begin

        FoundOk:=((TQty >= qbQtyFrom) and (TQty <= qbQtyTo)) and ((Not qbUseDates) or ((TDate >= qbStartDate) and (TDate <= qbEndDate)));

        If (FoundOk) and (not qbUseDates) and (Not DefFound) then {* See if there are others *}
        Begin
          DefFound:=BOn;
          FoundOk:=BOff;
          TmpQtyBreak := LQtyBreakRec;
        end;

        PromoDatesFound:=(PromoDatesFound or qbUseDates);

        If (Not FoundOk) then
          lStatus:=lFind_Rec(B_GetNext,QtyBreakF,Keypath,KeyS);

      end; {While.}

      If (Not FoundOk) and (DefFound) then {* Re-instate the default one as it was the only one *}
      Begin
        LQtyBreakRec := TmpQtyBreak;
        FoundOk:=Bon;
      end;
    end;

    Calc_QtyBreak:=FoundOk;
  end; {Func..}






{ ==== Function to Return Correct Stock Selling Price based on band ==== }
Function Get_StkPrice(PBands  :  SaleBandAry;
                      DiscR   :  Real;
                      DiscCh  :  Char;
                      Currency:  Byte;
                      SellU,
                      QtyM    :  Real;
                      UP      :  Boolean)  :  Real;
Var
  Rnum  :  Real;
  FCurr :  Byte;
Begin

  Rnum:=0;

  FCurr:=0;

  If (DiscCh In StkBandSet) then
  With PBands[Succ(Ord(DiscCh)-Ord('A'))] do
  Begin
    Rnum:=SalesPrice;
    FCurr:=Currency;
  end
  else
  Begin
    Rnum:=PBands[1].SalesPrice;
    FCurr:=PBands[1].Currency;
  end;


  Rnum:=Calc_IdQty(Calc_StkCP(Currency_ConvFT(Rnum,FCurr,Currency,UseCoDayRate),SellU,UP),QtyM,Not UP);

  Rnum:=Round_Up(Rnum,Syss.NoNetDec);


  Get_StkPrice:=Rnum;

end; {Func..}


Procedure Calc_UPriceDisc(      BtrObj  : TdPostExLocalPtr;
                                TStock  :  StockRec;
                                DiscRec :  MiscRec;
                                TCurr   :  Byte;
                                TQty    :  Real;
                          Var   UPrice,
                                DiscR   :  Real;
                          Var   DiscCh  :  Char;
                          Const LCode   :  Str10;
                                Mode    :  Byte);
Var
  DiscTyp,
  DiscBand :  Char;
  DiscCurr :  Byte;

  SPrice,
  CPrice,
  DiscPC,
  DiscAM,
  DiscMU,
  Rnum    :  Real;
Begin                    
    DiscR:=0;
    DiscCh:=C0;
    DiscTyp:=C0;
    DiscBand:=C0;
    UPrice:=0;
    SPrice:=0;

    DiscMU:=0;
    DiscPC:=0;
    DiscAM:=0;

    Rnum:=0;

    With DiscRec do
    Case Mode of  

      {SS 17/08/2016 2016-R3
    	 ABSEXCH-14877:EntSuppSalesPrice & EntCustSalesPrice do not respect qty break discounts.
       -Useing Qty Break record to initialize the discount variables.}
                   
      1  :  With BtrObj.LQtyBreakRec do
            Begin
              DiscTyp := DiscountCharFromBreakType(qbBreakType);
              DiscBand:= qbPriceBand;

              SPrice:= qbSpecialPrice;
              DiscPC:= qbDiscountPercent;
              DiscAM:= qbDiscountAmount;
              DiscMU:= qbMarginOrMarkup;

              DiscCurr := qbCurrency;
            end;

      2  :  With CustDiscRec do
            Begin

              DiscTyp:=QBType;
              DiscBand:=QBand;

              SPrice:=QSPrice;
              DiscPC:=QDiscP;
              DiscAM:=QDiscA;
              DiscMU:=QMUMG;
              DiscCurr:=QBCurr;

            end;

    end; {Case..}

    Case DiscTyp of

      QBPriceCode  :  Begin
                        UPrice:=Currency_ConvFT(SPrice,DiscCurr,TCurr,UseCoDayRate);
                      end;

      QBBandCode   :  Begin
                        {$IFDEF SOP}
                          BtrObj^.LStock_LocPSubst(TStock,LCode);
                        {$ENDIF}

                        UPrice:=Get_StkPrice(TStock.SaleBands,0,DiscBand,TCurr,1,1,TStock.CalcPack);

                        If (DiscPC<>0) or (DiscAm<>0) then
                        Begin
                          If (DiscPC<>0) then
                          Begin
                            DiscCh:=PcntChr;
                            DiscR:=Pcnt(DiscPC);
                          end
                          else
                            DiscR:=DiscAM;
                        end
                        else
                          DiscCh:=DiscBand;

                      end;

      QBMarkUpCode :  With TStock do
                      Begin
                        {$IFDEF SOP}
                          BtrObj^.LStock_LocCSubst(TStock,LCode);
                        {$ENDIF}

                        {CPrice:=FIFO_GetCost(TStock,TCurr,TQty,1); Cannot use this here, as would effect main thread}

                        CPrice:=Calc_StkCP(TStock.CostPrice,TStock.BuyUnit,TStock.CalcPack);

                        CPrice:=Currency_ConvFT(Calc_IdQty(CPrice,1,Not TStock.CalcPack),TStock.PCurrency,TCurr,UseCoDayRate);

                        {* To be replaced by FIFO *}

                        UPrice:=Round_Up(Calc_IdQty(CPrice*(1+Pcnt(DiscMU)),SellUnit,Not CalcPack),Syss.NoNetDec);

                      end;

      QBMarginCode :  With TStock do
                      Begin
                        {$IFDEF SOP}
                          BtrObj^.LStock_LocCSubst(TStock,LCode);
                        {$ENDIF}

                        Rnum:=DiscMU;

                        If (Rnum>=100) then
                          Rnum:=99.99;

                        {CPrice:=FIFO_GetCost(TStock,TCurr,TQty,1);}

                        CPrice:=Calc_StkCP(TStock.CostPrice,TStock.BuyUnit,TStock.CalcPack);

                        CPrice:=Currency_ConvFT(Calc_IdQty(CPrice,1,Not TStock.CalcPack),TStock.PCurrency,TCurr,UseCoDayRate);

                        UPrice:=Round_Up(Calc_IdQty(DivWChk(CPrice,(1-Pcnt(Rnum))),SellUnit,Not CalcPack),Syss.NoNetDec);

                      end;

    end; {Case..}

  end; {Proc..}




  Procedure Calc_StockPrice(      BtrObj  : TdPostExLocalPtr;
                                  TStock  : StockRec;
                                  TCust   : CustRec;
                                  TCurr   : Byte;
                                  TQty    : Real;
                                  TDate   : LongDate;
                            Var   UPrice,
                                  DiscR   : Real;
                            Var   DiscCh  : Char;
                            Const LCode   : Str10;
                            Var   FoundOk : Boolean);
  
  Const
    Fnum     =  MiscF;
    Keypath  =  MIK;
 Var
    Loop,
    TreeLoop,
    SetAny :  Boolean;
    LCurr,
    Mode      :  Byte;
    FoundCode :  Str20;
    KeyS2      :  Str255;
  Begin

    SetAny:=FoundOk;

    FoundOk:=BOff;

    TreeLoop:=BOn;

    LCurr:=TCurr;

    Blank(KeyS2,Sizeof(KeyS2));

    Mode:=2;      

    {$IFDEF MC_On}

      Loop:=BOff;

    {$ELSE}

      Loop:=BOn;

      LCurr:=0;

    {$ENDIF}

    With BtrObj^ do
    Begin  

      Repeat
          {* Search for an exact match *}

        FoundOk:=Calc_AccDMatch(BtrObj,TStock,TCust,LCurr,TDate,Fnum,Keypath);

        LStock:=TStock;

        If (Not FoundOk) then {* Search for a match via the tree *}
        Repeat

          TreeLoop:=Get_DiscTree(BtrObj,LStock.StockCat);

          If (TreeLoop) then
          Begin

            FoundOk:=Calc_AccDMatch(BtrObj,LStock,TCust,LCurr,TDate,Fnum,Keypath);

          end;

        Until (Not TreeLoop) or (FoundOk);

        LCurr:=0;

        Loop:=Not Loop;  {* Repeat for Currecncy 0 *}


        LStock:=TStock;

      Until (FoundOk) or (Not Loop);


      If (Not FoundOk) then {* Search for product QB match *}
      Begin


        If (TCust.CustSupp=TradeCode[BOn]) then
        Begin

          Mode:=1;

          LCurr:=TCurr;


          {$IFDEF MC_On}

            Loop:=BOff;

          {$ELSE}

            Loop:=BOn;

          {$ENDIF}


          Repeat

            {SS 17/08/2016 2016-R3
            ABSEXCH-14877:EntSuppSalesPrice & EntCustSalesPrice do not respect qty break discounts.}
            FoundOk:=Calc_QtyBreak(BtrObj,TStock,TCust,LCurr,TQty,TDate,Fnum,Keypath,Mode);

            LCurr:=0;

            Loop:=Not Loop;

          Until (Not Loop) or (FoundOk);

        end; {If Supplier..}

      end {If not found..}
      else
      Begin


        If (LMiscRecs^.CustDiscRec.QBType=QBQtyBCode) then {* Search for subsequent qty break *}
        Begin

          Mode:=1;

          LCurr:=TCurr;

          KeyS2:=LMiscRecs^.CustDiscRec.QStkCode;

          LGetMainRec(StockF,KeyS2);

          {$IFDEF MC_On}

            Loop:=BOff;

          {$ELSE}

            Loop:=BOn;

          {$ENDIF}

          Repeat

           {SS 17/08/2016 2016-R3
            ABSEXCH-14877:EntSuppSalesPrice & EntCustSalesPrice do not respect qty break discounts.}
            FoundOk:=Calc_QtyBreak(BtrObj,TStock,TCust,LCurr,TQty,TDate,Fnum,Keypath,2,BtrObj^.LMiscRecs^.CustDiscRec.QtyBreakFolio);

            LCurr:=0;

            Loop:=Not Loop;

          Until (Not Loop) or (FoundOk);

        end; {Acc Qty break}

      end; {FoundOk..}

      If (FoundOk) then
      begin
        Calc_UPriceDisc(BtrObj,TStock,LMiscRecs^,TCurr,TQty,UPrice,DiscR,DiscCh,LCode,Mode);
      end
      else
      Begin

        If (SetAny) then  {* Only set values if allowed *}
        Begin
          If (TCust.CustSupp<>TradeCode[BOff]) then
          Begin
            {$IFDEF SOP}
              BtrObj^.LStock_LocPSubst(TStock,LCode);
            {$ENDIF}



            With TCust do
            Begin
              If (DiscR<>Discount) then
                DiscR:=Discount;

              If (DiscCh<>CDiscCh) then
                DiscCh:=CDiscCh;
            end;

            UPrice:=Get_StkPrice(TStock.SaleBands,DiscR,DiscCh,TCurr,1,1,TStock.CalcPack);

          end
          else
          Begin
            {$IFDEF SOP}
              BtrObj^.LStock_LocROCPSubst(TStock,LCode);
            {$ENDIF}

            UPrice:=Currency_ConvFT(TStock.ROCPrice,TStock.ROCurrency,TCurr,UseCoDayRate);
          end;
        end;

      end;


      LStock:=TStock;
    end; {With..}
  end; {Proc..}


Procedure SetROUpdate(StockR   :  StockRec;
                  Var TStkLoc  :  MStkLocType);

Begin
  With StockR, TStkLoc do
  Begin
    lsROPrice:=ROCPrice;
    lsRODate:=RODate;
    lsROQty:=ROQty;
    lsROCurrency:=ROCurrency;
    lsROCCDep:=ROCCDep;

    lsROFlg:=ROFlg;

  end;
end;


Procedure SetROConsts(StockR   :  StockRec;
                  Var TStkLoc  :  MStkLocType;
                      TLocLoc  :  MLocLocType);
Begin
  With StockR, TLocLoc, TStkLoc do
  Begin
    lsROPrice:=ROCPrice;
    lsRODate:=RODate;
    lsROCurrency:=ROCurrency;
    lsROCCDep:=ROCCDep;
    lsCostPrice:=CostPrice;
    lsPCurrency:=PCurrency;

    lsQtyMax:=QtyMax;
    lsQtyMin:=QtyMin;

    lsBinLoc:=BinLoc;

    lsCostPrice:=CostPrice;
    lsPCurrency:=PCurrency;

    lsStkCode:=StockR.StockCode;
    lsStkFolio:=StockR.StockFolio;

    lsDefNom:=TLocLoc.loNominal;
    lsCCDep:=TLocLoc.loCCDep;

    lsSaleBands:=StockR.SaleBands;

    lsCode1:=Full_MLocSKey(lsLocCode,lsStkCode);
    lsCode2:=Full_MLocLKey(lsLocCode,lsStkCode);

    SetROUpDate(StockR,TStkLoc);
  end;
end;

end.
