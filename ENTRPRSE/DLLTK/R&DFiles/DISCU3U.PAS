Unit DiscU3U;

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 11/01/96                      }
{                                                              }
{              Account Discount Link  Controller               }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

{$IFDEF SOPDLL}
  {$DEFINE SOP}
{$ENDIF}

Uses GlobVar,
     VarConst
     {$IFDEF SOP}
       ,
       EXWrap1U;

     {$ELSE}
       ;

     {$ENDIF}


{* Reproduced in Report6U *}


Procedure Calc_UPriceDisc(TStock  :  StockRec;
                          DiscRec :  MiscRec;
                          TCurr   :  Byte;
                          TQty    :  Real;
                      Var UPrice,
                          DiscR   :  Real;
                      Var DiscCh  :  Char;
                    Const LCode   :  Str10;
                          Mode    :  Byte);


Procedure Calc_StockPrice(TStock  :  StockRec;
                          TCust   :  CustRec;
                          TCurr   :  Byte;
                          TQty    :  Real;
                          TDate :  LongDate;
                      Var UPrice,
                          DiscR   :  Real;
                      Var DiscCh  :  Char;
                    Const LCode   :  Str10;
                      Var FoundOk :  Boolean;
                          DMode   :  Byte);

{$IFDEF SOP}
  procedure QBLineVAT_Update(Var ExLocal  :  TdExLocal);
{$ENDIF}


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Forms,
   ETStrU,
   ETMiscU,
   BtrvU2,
   BTKeys1U,
   ComnUnit,
   ComnU2,
   CurrncyU,
   SysU2,
   {$IFNDEF EXDLL}
     InvListU,
   {$ENDIF}

   {$IFDEF STK}

     FIFOL2U,

     {$IFDEF SOP}
       InvLst3U,
       MiscU,
     {$ENDIF}

     {$IFDEF EXDLL}
       MLocFunc,
     {$ENDIF}

   {$ENDIF}

   BTSupU1,
   InvCT2SU;

Var
  PromoDatesFound  :  Boolean;


{=====================================================================================}
{=== These routines replicated within Report6U so they do not effect global stock === }
{== And ObjPrceU ==}
{=====================================================================================}


  { ========= Function to find Account Discount match ========== }

  Function Calc_AccDMatch(TStock  :  StockRec;
                          TCust   :  CustRec;
                          TCurr   :  Byte;
                          TDate   :  LongDate;
                          Fnum,
                          Keypath :  Integer)  :  Boolean;




  Var
    KeyS,
    KeyChk    :  Str255;

    DefFound,
    FoundOk   :  Boolean;

    TmpMisc   :  MiscRec;


  Begin
    FoundOk:=BOff; DefFound:=BOff;

    KeyChk:=FullQDKey(CDDiscCode,TCust.CustSupp,MakeCDKey(TCust.CustCode,TStock.StockCode,TCurr));

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
    With MiscRecs^.CustDiscRec do
    Begin
      FoundOk:=(Not CUseDates) or ((TDate>=CStartD) and (TDate<=CEndD));

      If (FoundOk) and (Not CUseDates) and (Not DefFound) then {* See if there are others *}
      Begin
        DefFound:=BOn;
        FoundOk:=BOff;
        TmpMisc:=MiscRecs^;
      end;

      PromoDatesFound:=(PromoDatesFound or CUseDates);

      If (Not FoundOk) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end;

    If (Not FoundOk) and (DefFound) then {* Re-instate the default one as it was the only one *}
    Begin
      MiscRecs^:=TmpMisc;
      FoundOk:=Bon;
    end;


    Result:=FoundOk;
  end;



  { ======= Function to Return next item up the tree ====== }


  Function Get_DiscTree(Scode  :  Str20)  :  Boolean;

  Begin

    If (Not EmptyKey(Scode,StkKeyLen)) then
      Get_DiscTree:=CheckRecExsists(Strip('R',[#0],Scode),StockF,StkCodeK)
    else
      Get_DiscTree:=BOff;

  end; {Func..}


  { ======= Function to Match Qty Break ======== }

  Function Calc_QtyBreak(TStock  :  StockRec;
                         TCust   :  CustRec;
                         TCurr   :  Byte;
                         TQty    :  Real;
                         TDate   :  LongDate;
                         Fnum,
                         Keypath :  Integer;
                         Mode    :  Byte)  :  Boolean;




  Var
    KeyS,
    KeyChk  :  Str255;

    DefFound,
    FoundOk :  Boolean;

    TmpMisc   :  MiscRec;


  Begin

    FoundOk:=BOff; DefFound:=BOff;

    Case Mode of

      1  :  KeyChk:=FullQDKey(QBDiscCode,QBDiscSub,FullNomKey(TStock.StockFolio)+Chr(TCurr));
      2  :  KeyChk:=FullQDKey(QBDiscCode,TCust.CustSupp,FullCDKey(TCust.CustCode,TStock.StockFolio)+Chr(TCurr));

    end; {Case..}

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
    With MiscRecs^ do
    With QtyDiscRec do
    Begin

      FoundOk:=((TQty>=FQB) and (TQty<=TQB)) and ((Mode=2) or (Not QUseDates) or ((TDate>=QStartD) and (TDate<=QEndD)));

      If (FoundOk) and (Not QUseDates) and (Not DefFound) and (Mode<>2) then {* See if there are others *}
      Begin
        DefFound:=BOn;
        FoundOk:=BOff;
        TmpMisc:=MiscRecs^;
      end;

      PromoDatesFound:=(PromoDatesFound or QUseDates);


      If (Not FoundOk) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While.}

    If (Not FoundOk) and (DefFound) then {* Re-instate the default one as it was the only one *}
    Begin
      MiscRecs^:=TmpMisc;
      FoundOk:=Bon;
    end;


    Calc_QtyBreak:=FoundOk;

  end; {Func..}



  { ======== Function to Convert Discount Record in to unit price and discount ======= }

  Procedure Calc_UPriceDisc(TStock  :  StockRec;
                            DiscRec :  MiscRec;
                            TCurr   :  Byte;
                            TQty    :  Real;
                        Var UPrice,
                            DiscR   :  Real;
                        Var DiscCh  :  Char;
                      Const LCode   :  Str10;
                            Mode    :  Byte);



  Var
    DiscTyp,
    DiscBand :  Char;
    DiscCurr :  Byte;

    SPrice,
    CPrice,
    DiscPC      ,
    DiscAM,
    DiscMU,
    Rnum    :  Real;


  Begin
    DiscTyp := #0;
    DiscBand := #0;
    DiscMU := 0;
    DiscPC := 0;
    DiscAM := 0;
    DiscCurr := 0;
    DiscR:=0;
    DiscCh:=C0;
    UPrice:=0;
    SPrice := 0;
    Rnum:=0;


    With DiscRec do
    Case Mode of

      1  :  With QtyDiscRec do
            Begin

              DiscTyp:=QBType;
              DiscBand:=QBand;

              SPrice:=QSPrice;
              DiscPC:=QDiscP;
              DiscAM:=QDiscA;
              DiscMU:=QMUMG;

              DiscCurr:=QBCurr;
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
                          Stock_LocPSubst(TStock,LCode);
                        {$ELSE}
                          // EL 21/10/02: Added Toolkit support for Locations
                          {$IFDEF EXDLL}
                            Stock_LocPSubst(TStock,LCode);
                          {$ENDIF}
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
                          Stock_LocCSubst(TStock,LCode);
                        {$ELSE}
                          // EL 21/10/02: Added Toolkit support for Locations
                          {$IFDEF EXDLL}
                            Stock_LocCSubst(TStock,LCode);
                          {$ENDIF}
                        {$ENDIF}

                        CPrice:=FIFO_GetCost(TStock,TCurr,TQty,1,LCode);

                        {* To be replaced by FIFO *}

                        UPrice:=Round_Up(Calc_IdQty(CPrice*(1+Pcnt(DiscMU)),SellUnit,Not CalcPack),Syss.NoNetDec);

                      end;

      QBMarginCode :  With TStock do
                      Begin
                        {$IFDEF SOP}
                          Stock_LocCSubst(TStock,LCode);
                        {$ELSE}
                          // EL 21/10/02: Added Toolkit support for Locations
                          {$IFDEF EXDLL}
                            Stock_LocCSubst(TStock,LCode);
                          {$ENDIF}
                        {$ENDIF}

                        Rnum:=DiscMU;

                        If (Rnum>=100) then
                          Rnum:=99.99;

                        CPrice:=FIFO_GetCost(TStock,TCurr,TQty,1,LCode);

                        UPrice:=Round_Up(Calc_IdQty(DivWChk(CPrice,(1-Pcnt(Rnum))),SellUnit,Not CalcPack),Syss.NoNetDec);

                      end;

    end; {Case..}

  end; {Proc..}



  { ============ Function to search for a matching discount ============= }

  Procedure Calc_StockPrice(TStock  :  StockRec;
                            TCust   :  CustRec;
                            TCurr   :  Byte;
                            TQty    :  Real;
                            TDate   :  LongDate;
                        Var UPrice,
                            DiscR   :  Real;
                        Var DiscCh  :  Char;
                      Const LCode   :  Str10;
                        Var FoundOk :  Boolean;
                            DMode   :  Byte);



  Const
    Fnum     =  MiscF;
    Keypath  =  MIK;


  Var
    TmpKPath,
    TmpStat   :  Integer;

    TmpRecAddr
              :  LongInt;


    Loop,
    TreeLoop,
    SetforDatesOnly,
    SetAny    :  Boolean;

    LCurr,
    Mode      :  Byte;

    FoundCode :  Str20;
    KeyS      :  Str255;

  Begin

    SetAny:=FoundOk;

    PromoDatesFound:=BOff;  SetforDatesOnly:=(DMode=11);

    FoundOk:=BOff;

    TreeLoop:=BOn;

    LCurr:=TCurr;

    Blank(KeyS,Sizeof(KeyS));

    Mode:=2;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(StockF,TmpKPath,F[StockF],TmpRecAddr,BOff,BOff);


    {$IFDEF MC_On}

      Loop:=BOff;

    {$ELSE}

      Loop:=BOn;

      LCurr:=0;

    {$ENDIF}


    Repeat

        {* Search for an exact match *}

      FoundOk:=Calc_AccDMatch(TStock,TCust,LCurr,TDate,Fnum,Keypath);

      Stock:=TStock;

      If (Not FoundOk) then {* Search for a match via the tree *}
      Repeat

        TreeLoop:=Get_DiscTree(Stock.StockCat);

        If (TreeLoop) then
        Begin

          FoundOk:=Calc_AccDMatch(Stock,TCust,LCurr,TDate,Fnum,Keypath);

        end;

      Until (Not TreeLoop) or (FoundOk);

      LCurr:=0;

      Loop:=Not Loop;  {* Repeat for Currecncy 0 *}


      Stock:=TStock;

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

          Loop:=BOff; {It seems quantity breaks in Ex set with Curr 0}

        {$ENDIF}


        Repeat

          FoundOk:=Calc_QtyBreak(TStock,TCust,LCurr,TQty,TDate,Fnum,Keypath,Mode);

          LCurr:=0;

          Loop:=Not Loop;

        Until (Not Loop) or (FoundOk);

      end; {If Supplier..}

    end {If not found..}
    else
    Begin


      If (MiscRecs^.CustDiscRec.QBType=QBQtyBCode) then {* Search for subsequent qty break *}
      Begin

        Mode:=1;

        LCurr:=TCurr;

        KeyS:=MiscRecs^.CustDiscRec.QStkCode;

        {$IFNDEF EXDLL}
        GetStock(Application.MainForm,KeyS,FoundCode,-1);
        {$ELSE}
        Global_GetMainRec(StockF, KeyS);
        {$ENDIF}

        {$IFDEF MC_On}

          Loop:=BOff;

        {$ELSE}

          Loop:=BOn;

        {$ENDIF}

        Repeat

          FoundOk:=Calc_QtyBreak(Stock,TCust,LCurr,TQty,TDate,Fnum,Keypath,2);

          LCurr:=0;

          Loop:=Not Loop;

        Until (Not Loop) or (FoundOk);

      end; {Acc Qty break}

    end; {FoundOk..}
                     {* v5.61.001. If triggered by a date change, only change price if promo date present *}
    If (FoundOk) and (PromoDatesFound or Not SetforDatesOnly) then
      Calc_UPriceDisc(TStock,MiscRecs^,TCurr,TQty,UPrice,DiscR,DiscCh,LCode,Mode)
    else
    Begin

      If (SetAny) then  {* Only set values if allowed *}
      Begin
        If (TCust.CustSupp<>TradeCode[BOff]) then
        Begin
          {$IFDEF SOP}
            Stock_LocPSubst(TStock,LCode);
          {$ELSE}
            // HM 16/05/01: Added Toolkit support for Locations as CalcPrice was
            //              ignoring them because it doesn't use the SOP directive
            {$IFDEF EXDLL}
              Stock_LocPSubst(TStock,LCode);
            {$ENDIF}
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
            Stock_LocROCPSubst(TStock,LCode);
          {$ELSE}
            // HM 16/05/01: Added Toolkit support for Locations as CalcPrice was
            //              ignoring them because it doesn't use the SOP directive
            {$IFDEF EXDLL}
              Stock_LocROCPSubst(TStock,LCode);
            {$ENDIF}
          {$ENDIF}

          DiscR:=0.0; DiscCh:=#0; {v5.52. These were being set to random figures}

          With TCust do
          Begin
            If (DiscR<>Discount) then
              DiscR:=Discount;

            If (DiscCh<>CDiscCh) then
              DiscCh:=CDiscCh;
          end;


          UPrice:=Currency_ConvFT(TStock.ROCPrice,TStock.ROCurrency,TCurr,UseCoDayRate);
        end;
      end;

    end;

    TmpStat:=Presrv_BTPos(StockF,TmpKPath,F[StockF],TmpRecAddr,BOn,BOff);


    Stock:=TStock;

  end; {Proc..}



{$IFDEF SOP}

  { == Procedure to override VAT Code & Inclusive calculation after a qty break has been applied *}
  procedure QBLineVAT_Update(Var ExLocal  :  TdExLocal);
    Var
      NewVC  :  Char;


    Begin
      With ExLocal do
        NewVC:=Correct_PVAT(LStock.VATCode,LCust.VATCode);

      If (NewVC=VATICode) and (ExLocal.LId.VATCode=VATMCode) then {*We need to re-introduce I*}
      Begin
        ExLocal.LId.VATCode:=NewVC;

        CalcVATExLocal(ExLocal,BOff,nil);

      end;

    end;

{$ENDIF}


{$IFDEF SOPDLL}
  {$UNDEF SOP}
{$ENDIF}


Initialization

PromoDatesFound:=BOff;


end.