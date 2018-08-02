Unit FIFOL2U;

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 11/01/96                      }
{                                                              }
{               FIFO List Management Control Unit              }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst,
     Dialogs,
     ExBtth1U;


  //PR: 08/09/2014 Order Payments T056 Allow ExLocal to be passed to procedure
  Procedure FIFO_Add(IdR     :  IDetail;
                   QtyCr,
                   UCost   :  Real;
                   SFolio  :  LongInt;
                   DocNo   :  Str10;
                   Deduct,
                   ShowQty :  Boolean;
                   Fnum,
                   Keypath :  Integer;
                   FMode   :  Byte;
                   ExLocal : TdPostExLocalPtr = nil);

  //PR: 08/09/2014 Order Payments T056 Allow ExLocal to be passed to procedure
  Procedure FIFO_Control(Var IdR     :  IDetail;
                         Var StockR  :  StockRec;
                             LInv    :  InvRec;
                             QtyCr   :  Real;
                             Mode    :  Byte;
                             Deduct  :  Boolean;
                             ExLocal : TdPostExLocalPtr = nil);

  Function FIFO_GetCost(StockR  :  StockRec;
                        FCurr   :  Byte;
                        QtyCr,
                        QtyM    :  Real;
                        LocFilt :  Str10)  :  Real;

  Function FIFO_GetAVCost(StockR  :  StockRec;
                          LocFilt :  Str10)  :  Real;

  Procedure FIFO_RenPDN(StockR  :  StockRec;
                        PDNId,
                        PINId   :  Idetail;
                        Fnum,
                        Keypath :  Integer);


  {$IFNDEF EXDLL}

    Procedure FIFO_MoveNegs(StockR  :  StockRec;
                            Fnum,
                            Keypath :  Integer);

    Procedure FIFO_Tidy(StkCode :  Str20;
                        LocFilt :  Str10);
  {$ENDIF}

  Procedure FIFO_AvgVal(Var  StockR  :  StockRec;
                             IdR     :  IDetail;
                             QtyUsed :  Real);

  {$IFDEF SOP}
    //PR: 11/09/2014 Order Payments T056 Allow ExLocal to be passed to procedure
    Procedure FIFO_SERUp(Var StockR  :  StockRec;
                             IdR     :  IDetail;
                             ExLocal : TdPostExLocalPtr = nil);

    //PR: 11/09/2014 Order Payments T056 Allow ExLocal to be passed to procedure
    Function FIFO_AvSNO(Var StockR  :  StockRec;
                            LocFilt :  Str10;
                            ExLocal : TdPostExLocalPtr = nil)  :  Real;

  {$ENDIF}

  {$IFDEF EXDLL}
   var
     IsUpdate : Boolean;
  {$ENDIF}


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   ETStrU,
   ETMiscU,
   ETDateU,
   BtrvU2,
   BTKeys1U,
   ComnUnit,
   ComnU2,
   CurrncyU,
   SysU2,
   {$IFDEF DBD}
     Dialogs,
   {$ENDIF}
   {$IFDEF SOP}
     StkSerNU,
     InvLst3U,
   {$ENDIF}

   {$IFNDEF EXDLL}
   InvListU,
   {$ELSE}
   Profile,
   {$ENDIF}
   {$IFDEF EXSQL}
   SQLUtils,
   {$ENDIF}

   BTSupU1;




{ ========= Function to Return Cost valuation ======== }
{ ========= Fmode 254 used by average cost when no average calcs are possible due to -ve stock qty's }
{ ========= Fmode 40 used by average calcs to distinguish when handling sales credits ===== }


Function FIFO_SetCPrice(IdR    :  IDetail;
                        FMode  :  Byte):  Real;

Var
  Rnum  :  Real;
  QtyDiv,
  RetCost,
  RetNet
        :  Double;


Begin
  RetCost:=0.0;

  With IdR do                {vThis check added v4.31.004 as purchases need to use qtypack}
   If (PrxPack) and (ShowCase or (IdDocHed In PurchSplit)) and (QtyPack<>0) and (Not (FMode In [2,3])) then
     QtyDiv:=QtyPack
   else
     QtyDiv:=QtyMul;

  If (IdR.IdDocHed In SalesSplit+[ADJ]) then
  Begin
    {* Use whole cost price when reversing out average back using credits *}
    {* EL v5.71.001. Switched to use Calc_StkCP for SCR's as otherwise Average stock records which use fractional units of sales or purch do not work correctly *}
    If (IdR.IdDocHed = ADJ) {Removed for v5.71.001 or ((IdR.IdDocHed In SalesCreditSet) and (FMode=40))} then
      FIFO_SetCPrice:=IdR.CostPrice
    else                                              //PR: 04/06/2009 Added Stock.PricePack to check, otherwise didnt't work for SplitPacks
                                                      //PR: 16/06/2009 Ok, that broke other stuff - check specifically for SCR + FMode = 40
      FIFO_SetCPrice:=Calc_StkCP(IdR.CostPrice,QtyDiv,IdR.UsePack or (Stock.PricePack and (IdR.IdDocHed In SalesCreditSet) and (FMode=40)));

  end
  else
  With IdR do
  Begin

    If (Syss.SepDiscounts) then {* Do not include discount, as being posted seperately *}
      Rnum:=0.0
    else
      // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts
      //Rnum:=Calc_PAmount(Round_Up(NetValue,Syss.NoCosDec),Discount,DiscountChr);
      Rnum := Calc_PAmountAD (Round_Up(NetValue,Syss.NoCosDec),
                              Discount, DiscountChr,
                              Discount2, Discount2Chr,
                              Discount3, Discount3Chr);

    RetNet:=NetValue;

    If (Not (IdR.IdDocHed In StkRetPurchSplit)) then {* Ignore cost price on a Purch Return as it is not uplift *}
      RetCost:=CostPrice
    else
      RetNet:=CostPrice;

    {*Used to be like this pre b381, but uplift was being divided down again even though it is unit price *}
    If (Not ShowCase) then
      FIFO_SetCPrice:=Round_Up(Calc_StkCP(Round_Up((RetNet+RetCost),Syss.NoCosDec)-Rnum,QtyDiv,(UsePack or (FMode=254))),
                               Syss.NoCosDec)
    else
      FIFO_SetCPrice:=Round_Up(Calc_StkCP(Round_Up((RetNet),Syss.NoCosDec)-Rnum,QtyDiv,(UsePack or (FMode=254)))+RetCost,
                               Syss.NoCosDec);

  end;

end; {Func..}




{ ========= Procedure to Set Id details ========= }


Procedure FIFO_SetId(     IdR   :  IDetail;
                     Var  TMisc :  MiscRec;
                          FMode :  Byte);

Var
  Rnum  :  Real;


Begin

  Rnum:=0;

  With TMisc.FIFORec do
  Begin

    FIFODate:=Idr.PDate;


    FIFOCurr:=IdR.Currency;

    FIFOCost:=FIFO_SetCPrice(IdR,FMode);

    FIFOCRates:=IdR.CXRate;

    {* v4.40 If we have original rate for cost price, use that *}
    
    If (IdR.COSConvRate<>0.0) and (IdR.IdDocHed In SalesSplit) then
      FIFOCRates[UseCoDayRate]:=IdR.COSConvRate;



    FIFOTriR:=IdR.CurrTriR;
    FUseORate:=IdR.UseORate;

    If (FIFOCRates[BOff]=0.0) then
    Begin
      FIFOCRates[BOff]:=SyssCurr^.Currencies[FIFOCurr].CRates[BOff];
      SetTriRec(FIFOCurr,FUseORate,FIFOTriR);
    end;

    
    FIFOCust:=IdR.CustCode;

    FIFOMLoc:=IdR.MLocStk;

    FIFOCode:=MakeFIKey(StkFolio,FIFODate);

  end; {With..}

end; {Proc..}



{ ========= Procedure to Add New FIFO Entry ======== }
//PR: 08/09/2014 Order Payments T056 Allow ExLocal to be passed to procedure
Procedure FIFO_Add(IdR     :  IDetail;
                   QtyCr,
                   UCost   :  Real;
                   SFolio  :  LongInt;
                   DocNo   :  Str10;
                   Deduct,
                   ShowQty :  Boolean;
                   Fnum,
                   Keypath :  Integer;
                   FMode   :  Byte;
                   ExLocal : TdPostExLocalPtr = nil);



Var
  Rnum  :  Real;
  KeyS : Str255;

Begin
{$IFDEF EXDLL}
Profiler.StartFunc('FIFO_Add');
{$ENDIF}
  Rnum:=0;

  ResetRec(Fnum);

  MiscRecs^.RecMfix:=MFIFOCode;
  MiscRecs^.Subtype:=MFIFOSub;

  With MiscRecs^.FIFORec do
  Begin



    StkFolio:=SFolio;

    DocRef:=DocNo;

    DocABSNo:=IdR.ABSLineNo;

    FIFO_SetId(IdR,MiscRecs^,FMode*Ord(ShowQty));

    If (Not Deduct) then
    Begin

      Case FMode of

        2  :  FIFODate:=MinUntilDate;

        3  :  FIFODate:=MaxUntilDate;

      end; {Case..}

      FIFOCode:=MakeFIKey(StkFolio,FIFODate);

    end; {Mode..}


    If (FIFOCost=0) and (IdR.LineNo=StkLineNo) then {* if BOM line substitute current cost *}
      FIFOCost:=UCost;

    FIFOQty:=QtyCr;

    QtyLeft:=QtyCr;

    //GS 09/02/2012 ABSEXCH-10450: Default the Fifo record currency rates
    //PR: 26/04/2012 removed this fix as it was overwriting rates which had been set from the line in Fifo_SetID above. ABSESCH-12881
    //Amended StRoCtl.Gen_AutoAdjLineEx to set the line rates correctly from the header
//    FIFOCRates:=SyssCurr^.Currencies[FIFOCurr].CRates;

    DocFolioK:=MakeFIDocKey(DocRef,SFolio,DocABSNo);

    //PR: 08/09/2014 Order Payments T056 use ExLocal if assigned to stay within DB Transaction
    if Assigned(ExLocal) then
    begin
      ExLocal.LMiscRecs^ := MiscRecs^;

      Status := ExLocal.LAdd_Rec(FNum, KeyPath);
    end
    else
      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    Report_BError(Fnum,Status);

  end; {With..}
{$IFDEF EXDLL}
Profiler.EndFunc('FIFO_Add');
{$ENDIF}
end; {Proc..}




{ ======= Procedure to Edit a FIFO record, with autodelete ====== }


Procedure FIFO_Edit(Var IdR    :  IDetail;
                    Var QtyCr  :  Real;
                        QtyDed :  Real;
                        Fnum,
                        Keypath:  Integer;
                        Mode   :  Byte;
                        GoNeg,
                        DelZero:  Boolean);


Var
  OWCost,
  Locked  :  Boolean;


  LastCost,
  QtyUsed :  Real;

  LAddr   :  LongInt;



Begin
{$IFDEF EXDLL}
Profiler.StartFunc('FIFO_Edit');
{$ENDIF}
  Locked:=BOff;

  OWCost:=BOff;

{$IFDEF EXDLL}
Profiler.StartFunc('FIFO_Edit.GetMultiRecAddr');
  if SQLUtils.UsingSQL then
    UseVariantForNextCall(F[FNum]);

  Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyF,KeyPath,Fnum,BOn,Locked,LAddr);
Profiler.EndFunc('FIFO_Edit.GetMultiRecAddr');
{$ELSE}
  Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyF,KeyPath,Fnum,BOn,Locked,LAddr);
{$ENDIF}
  If (Ok) and (GlobLocked) then
  With MiscRecs^.FIFORec do
  Begin

    QtyUsed:=QtyCr;

    QtyLeft:=QtyLeft+QtyCr;

    If (QtyLeft<0) and (Not GoNeg) then
    Begin
      QtyCr:=QtyLeft;
      QtyLeft:=0;
    end
    else
      QtyCr:=0;

    {* This check here is for the edit of the same line, to restore the fifo line back again
       This was causing a problem when temporary lines were created during an edit, as their
       values were being overwritten from the lines value rather then them setting the lines
       value. this was correct for a straight exit, but not for a deduct *}


    {* 05/02/1997. OwCost moved here and extended for LIFO so that when editing the same line,
                   The cost stored with the line originaly is used rather than the current cost which
                   may have been overwritten by the edit of the line *}

    OWCost:=((FIFODate=MinUntilDate) or (FIFODate=MaxUntilDate)) and ((QtyDed<=0) or (Not (IdR.IdDocHed In StkAdjSplit)));

    If (QtyLeft<>0) and (Mode=1) then
    Begin
      LastCost:=FIFOCost;
{$IFDEF EXDLL}
Profiler.StartFunc('FIFO_Edit.FIFO_SetId');
      FIFO_SetId(IdR,MiscRecs^,0);
Profiler.EndFunc('FIFO_Edit.FIFO_SetId');
{$ELSE}
      FIFO_SetId(IdR,MiscRecs^,0);
{$ENDIF}
      If (OWCost) then
        FIFOCost:=LastCost;

    end;

    {* OWCost checked for here so the temorary lines generated during an edit set the line cost being put back.
       This will work fine for lines which reduce the qty needed, but those lines which have actualy increased, will not be correct becuase
       this part of the cost will not be included within the FIFO_SQL calculation. To do this properly, LastCP needs to be pased in here,
       and if there is any residual qty needed which involces dipping into the FIFO, lastCP will include this cost, so the running average
       is not distorted. I ran out of time to follow this through *}
    {* v4.23, cost price not set on purch transactions, as otherwise, an edit causes an uplift *}

    If ((Mode=1) and ((IdR.IdDocHed In StkAdjSplit) and (IdR.LineNo=StkLineNo)) or
        ((OWCost) and (Not (IdR.IdDocHed In PurchSplit+StkRetPurchSplit)))) then  {* Update cost price from FIFOCost *}
    Begin
      
      If (IdR.IdDocHed In SalesSplit) and (IdR.QtyMul<>1.0) then
      With IdR do
        CostPrice:=Round_up(Calc_IdQty(FIFOCost,QtyMul,Not UsePack),Syss.NoCosDec)
      else
        IdR.CostPrice:=FIFOCost;

    end;


    FIFOQty:=FIFOQty+QtyDed;


    If (Mode In [0..1]) then
    Begin
      If (Round_Up(QtyLeft,Syss.NoQtyDec)<>0) or (Not DelZero) then
      begin
        {$IFDEF EXDLL}
        Profiler.StartFunc('FIFO_Edit.PutRec');
        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);
        Profiler.EndFunc('FIFO_Edit.PutRec');
        {$ELSE}
        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);
        {$ENDIF}
      end
      else
        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);


      Report_BError(Fnum,Status);

    end;

    Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

  end; {If Locked..}
{$IFDEF EXDLL}
Profiler.EndFunc('FIFO_Edit');
{$ENDIF}
end; {Proc..}






{ ======== Procedure to Scan FIFO and Process / Return Cost Price ======= }
{ This function is replicated within RevalU2U for thread safe operation  }


Function FIFO_CalcCrCost(StockR  :  StockRec;
                         TMisc   :  MiscRec)  :  Double;


Var
  UseRate  :  Boolean;
  NewAmnt  :  Double;


Begin
  UseRate:=UseCoDayRate;
  NewAmnt:=0.0;

  With TMisc.FIFORec do
  Begin
    {$IFDEF MC_On}
      If (Not RevalueStk(StockR.NomCodes[4])) and (FIFOCRates[UseRate]<>0.0) then
      Begin
        NewAmnt:=Conv_TCurr(FIFOCost,FIFOCRates[UseRate],FIFOCurr,FUseORate,BOff);

        With SyssCurr^.Currencies[StockR.PCurrency] do
          FIFO_CalcCrCost:=Conv_TCurr(NewAmnt,CRates[UseRate],StockR.PCurrency,0,BOn);


      end
      else
    {$ENDIF}

        FIFO_CalcCrCost:=Currency_ConvFT(FIFOCost,FIFOCurr,StockR.PCurrency,UseRate);


  end;
end;

{Mode:  0 Is normal deduct when FIFO movement taking place
        1 Sames a 0 but for LIFO
        2 Collect price only
        7 Part of an attemopt to tidy up by requesting a zero amount on stock
          codes where the stock level is >0 so any stray negative lines are accounted for*}

//PR: 08/09/2014 Order Payments T056 Allow ExLocal to be passed as parameter
Procedure FIFO_SQL(StockR  :  StockRec;
               Var QtyCr,
                   CPrice  :  Real;
                   Fnum,
                   Keypath :  Integer;
                   Mode,
                   FMode   :  Byte;
                   LocFilt :  Str10;
                   ExLocal : TdPostExLocalPtr = nil);




Var
  AVQty,
  AVPrice,
  AVCalc,
  TmpQty,
  QtyUsed,
  QtyNeed    :  Real;

  KeyS,
  KeyChk     :  Str255;

  TmpId      :  IDetail;

  B_Start,
  B_Func     :  Integer;

  FoundSome  :  Boolean;


  Begin
{$IFDEF EXDLL}
Profiler.StartFunc('FIFO_SQL');
{$ENDIF}
    AVQty:=0; AVPrice:=0;  AVCalc:=0;

    QtyUsed:=QtyCr;

    QtyNeed:=QtyCr*DocNotCnst;

    TmpQty:=0;

    FoundSome:=BOff;

    Blank(TmpId,Sizeof(TmpId));

    B_Start:=B_GetGEq;

    B_Func:=B_GetNext;

    Case Mode of

      0..2,7
           :  Begin

                KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,FullNomKey(StockR.StockFolio));

                KeyS:=KeyChk;

                If (FMode=3) then {* Its LIFO *}
                Begin

                  KeyS:=KeyS+NdxWeight;

                  B_Start:=B_GetLessEq;
                  B_Func:=B_GetPrev;

                end;

                {$IFDEF EXSQL}
                // MH 05/06/2008: Added SQL optimisation
                If SQLUtils.UsingSQLAlternateFuncs Then UseVariantForNextCall(F[Fnum]);
                {$ENDIF}
                if Assigned(ExLocal) then
                begin
                  //PR: 08/09/2014 Order Payments T056 use ExLocal if assigned as emulator seems to prevent reading
                  //                                   from file after record added in db transaction
                  Status:=ExLocal.LFind_Rec(B_Start,Fnum,Keypath,KeyS);
                  MiscRecs.FifoRec := ExLocal.LMiscRecs.FifoRec;
                end
                else
                  Status:=Find_Rec(B_Start,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

                While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and ((QtyUsed<>0) or (Mode=7)) do
                With MiscRecs^.FIFORec do
                Begin


                  {* Average Calculations... Only use +ve FIFO Lines *}

                  {$B-}

                  If (Not Syss.UseMLoc) or (CheckKey(FIFOMLoc,LocFilt,Length(LocFilt),BOff)) then
                  Begin

                  {$B+}

                    If (Not FoundSome) then
                    Begin
                      FoundSome:=BOn;

                      If (Mode=7) then  {* Should only last once, to get in here *}
                        Mode:=0;
                    end;

                    If (Mode=2) then
                    Begin
                      If (QtyLeft>0) then
                        TmpQty:=QtyLeft
                      else
                        TmpQty:=0.0;
                    end
                    else
                    Begin
                      If (QtyLeft>0) then
                        TmpQty:=QtyLeft
                      else
                        TmpQty:=0.0;

                      If (TmpQty>(QtyUsed*DocNotCnst)) then
                        TmpQty:=(QtyLeft-(QtyLeft-(QtyUsed*DocNotCnst)));
                    end;


                    AvQty:=AvQty+TmpQty;

                    {* Convert currency *}

                    {AvCalc:=(TmpQty*Currency_ConvFT(FIFOCost,FIFOCurr,StockR.PCurrency,UseCoDayRate));}

                    AvCalc:=(TmpQty*FIFO_CalcCrCost(StockR,MiscRecs^));

                    AvPrice:=AvPrice+AvCalc;

                    Case Mode of

                      0  :  FIFO_Edit(TmpId,QtyUsed,0,Fnum,Keypath,Mode,BOff,BOn);
                      1  :  Begin

                              QtyUsed:=QtyUsed+QtyLeft;

                              If (QtyUsed>0) then
                                QtyUsed:=0;
                            end;
                    end;
                  end;

                  If (QtyUsed<>0) or (Mode=7) then
                  begin
                    {$IFDEF EXSQL}
                    // MH 05/06/2008: Added SQL optimisation
                    If SQLUtils.UsingSQLAlternateFuncs Then UseVariantForNextCall(F[Fnum]);
                    {$ENDIF}
                    if Assigned(ExLocal) then
                    begin
                      //PR: 08/09/2014 Order Payments T056
                      Status:=ExLocal.LFind_Rec(B_Func,Fnum,Keypath,KeyS);
                      MiscRecs.FifoRec := ExLocal.LMiscRecs.FifoRec;
                    end
                    else
                      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
                  End; // If (QtyUsed<>0) or (Mode=7)

                end; {While..}

                Case Mode of

                  2  :  If (FoundSome) then
                          CPrice:=Round_Up(DivWChk(AvPrice,AvQty),Syss.NoCosDec);

                  else  Begin

                          AvCalc:=QtyNeed;

                          If (QtyNeed>AVQty) then
                            AVPrice:=AVPrice+((QtyNeed-AVQty)*CPrice)
                          else
                            If (QtyNeed<AVQty) then
                              AvCalc:=AvQty;

                          If (FoundSome) or (Mode<>1) then {* v5.61 Only set price if we have top of FIFO present, or its duff *}
                            CPrice:=Round_Up(DivWChk(AvPrice,AvCalc),Syss.NoCosDec);
                        end;

                end;{case..}
              end;

    end; {Case..}

    QtyCr:=QtyUsed;

{$IFDEF EXDLL}
Profiler.EndFunc('FIFO_SQL');
{$ENDIF}
  end; {Proc..}


  { ======= Procedure to Control FIFO Update ======= }

  Procedure FIFO_Control(Var IdR     :  IDetail;
                         Var StockR  :  StockRec;
                             LInv    :  InvRec;
                             QtyCr   :  Real;
                             Mode    :  Byte;
                             Deduct  :  Boolean;
                             ExLocal : TdPostExLocalPtr = nil);





  Const
    Fnum     =  MiscF;
    Keypath  =  MIK;



  Var
    FMode    :  Byte;
    TmpKPath,
    TmpStat  :  Integer;

    RecAddr,
    TmpRecAddr
             :  LongInt;

    TmpMisc  :  MiscRec;
    TmpInv   :  InvRec;

    DocNo    :  Str10;
    IncFIFO,
    UpdateStk:  Boolean;
    QtyUsed,
    Rnum,
    StkUCost,
    LastCP   :  Real;
    KeyS,
    KeyChk   :  Str255;


  Begin
{$IFDEF EXDLL}
Profiler.StartFunc('FIFO_Control');
{$ENDIF}

{$IFDEF EXDLL}
Profiler.StartFunc('FIFO_Control - 748');
{$ENDIF}
    DocNo:='';
    TmpMisc:=MiscRecs^;

    IncFIFO:=(QtyCr>=0);

    RecAddr:=0;

    TmpInv:=Inv;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(InvF,TmpKPath,F[InvF],TmpRecAddr,BOff,BOff);

    QtyUsed:=0;  Rnum:=0;

    LastCP:=0;

    Status:=GetPos(F[Fnum],Fnum,RecAddr);

    FMode:=FIFO_Mode(StockR.StkValType);

{$IFDEF EXDLL}
Profiler.EndFunc('FIFO_Control - 748');
{$ENDIF}
    If (StatusOk) or (RecAddr=0) then
    Begin
{$IFDEF EXDLL}
Profiler.StartFunc('FIFO_Control - 777');
{$ENDIF}
      If (LInv.FolioNum<>IdR.FolioRef) then
      Begin
        If (CheckRecExsists(Strip('B',[#0],FullNomKey(IdR.FolioRef)),InvF,InvFolioK)) then
          DocNo:=Inv.OurRef
        else
          DocNo:=LInv.OurRef;
      end
      else
        DocNo:=LInv.OurRef;

      QtyUsed:=QtyCr;

      {* Convert current stock price to line currency *}

      StkUCost:=Currency_ConvFT(Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,StockR.CalcPack),
                                StockR.PCurrency,IdR.Currency,UseCoDayRate);

      {* Calculate currenct Unit cost *}

      LastCP:=Round_up(Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,StockR.CalcPack),Syss.NoCosDec);

{$IFDEF EXDLL}
Profiler.EndFunc('FIFO_Control - 777');
{$ENDIF}
      If (IdR.IdDocHed In SalesSplit+StkAdjSplit+PurchCreditSet+ StkRetPurchSplit ) and (Not IncFIFO) then
      Begin
{$IFDEF EXDLL}
Profiler.StartFunc('FIFO_Control - 806');
        //PR: 02/02/2010 This section only applies if we're updating a transaction line - IsUpdate is set
        //in DllTh_Up.pas to indicate if we're updating, so ignore it if we're not - gives some performance
        //improvement under MS-SQL
        if IsUpdate then
        begin
{$ENDIF}
          KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,Strip('B',[#0],MakeFIDocKey(DocNo,StockR.StockFolio,IdR.ABSLineNo)));

          KeyS:=KeyChk;

          Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,MiscNdxK,KeyS);

          Ok:=((StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))
            and ((Not Syss.UseMLoc) or CheckKey(MiscRecs^.FIFORec.FIFOMLoc,IdR.MLocStk,Length(IdR.MLocStk),BOff)));

{$IFDEF EXDLL}
        end
        else
          Ok := False;
Profiler.EndFunc('FIFO_Control - 806');
{$ENDIF}
        If (Ok) then
          FIFO_Edit(IdR,QtyUsed,QtyCr,Fnum,MiscNdxK,Ord(Deduct),BOff,BOn); {* Do not allow negative *}


        Rnum:=LastCP;

        If (QtyUsed<>0) then
        Begin

          FIFO_SQL(StockR,QtyUsed,Rnum,Fnum,Keypath,0,FMode,IdR.MLocStk);

{$IFDEF EXDLL}
Profiler.StartFunc('FIFO_Control - 830');
{$ENDIF}
          With StockR do
            If (Mode=0) and (Deduct)
              and ((((Not ShowAsKit) or (StockType<>StkBillCode))
              and  (Idr.LineNo<>StkLineNo))
              and (Not (IdR.IdDocHed In PurchCreditSet))
              or ((IdR.IdDocHed In StkAdjSplit) and (IdR.LineNo=StkLineNo))
              or ((IdR.IdDocHed In SalesSplit) and (IdR.LineNo=StkLineNo))) then

                                                {* Only attribute costprice to Non B/M items,
                                                   & non kit items, and generated lines will never
                                                   have a costprice, as this is accounted for in the B/M
                                                   Header *}
            Begin

              // CJS 2014-05-20 - ABSEXCH-15080 - ADJ item cost with pack quantity
              // - removed erroneous 'NOT' from before Idr.UsePack

              //PR: 04/06/2014 ABSEXCH-15415 Unfortunately, the 'NOT' is needed for sales/purchase transactions.
              //                             ADJs don't care about sales or purchase units, so we need to treat them
              //                             as a special case and put the 'NOT' back in for sales & purchase.
              if LInv.InvDocHed = ADJ then
                IdR.CostPrice:=Round_up(Currency_ConvFT(Calc_IdQty(Rnum,IdR.QtyMul,IdR.UsePack),
                                        PCurrency,Idr.Currency,UseCoDayRate),Syss.NoCosDec)
              else
                IdR.CostPrice:=Round_up(Currency_ConvFT(Calc_IdQty(Rnum,IdR.QtyMul,not IdR.UsePack),
                                        PCurrency,Idr.Currency,UseCoDayRate),Syss.NoCosDec);


            end;
{$IFDEF EXDLL}
Profiler.EndFunc('FIFO_Control - 830');
{$ENDIF}
        end;

        If (QtyUsed<>0) then
          FIFO_Add(IdR,QtyUsed,StkUCost,StockR.StockFolio,DocNo,Deduct,BOn,Fnum,Keypath,FMode, ExLocal);

      end
      else
      Begin

{$IFDEF EXDLL}
Profiler.StartFunc('FIFO_Control - 865');
{$ENDIF}
        //PR: 02/02/2010 This section only applies if we're updating a transaction line - IsUpdate is set
        //in DllTh_Up.pas to indicate if we're updating, so ignore it if we're not - gives some performance
        //improvement under MS-SQL
        {$IFDEF EXDLL}
        if IsUpdate then
        begin
        {$ENDIF}
          KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,Strip('B',[#0],MakeFIDocKey(DocNo,StockR.StockFolio,IdR.ABSLineNo)));

          KeyS:=KeyChk;

          Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,MiscNdxK,KeyS);

          Ok:=((StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))
              and ((Not Syss.UseMLoc) or CheckKey(MiscRecs^.FIFORec.FIFOMLoc,IdR.MLocStk,Length(IdR.MLocStk),BOff)));
        {$IFDEF EXDLL}
        end
        else
          Ok := False;
        {$ENDIF}
        {$B-} {* v5.61.001. When returning deduct lines, preserve each one separatly if the cost differs, as they could each be from different
                            batches of FIFO so cost needs to be kept seperate *}
        If (OK) and ((IdR.IdDocHed In StkAdjSplit) and (IdR.LineNo=StkLineNo)) and (Not Deduct) and (MiscRecs^.FIFORec.FIFOCost<>IDr.CostPrice) then
          Ok:=Not Ok;

        {$B+}

{$IFDEF EXDLL}
Profiler.EndFunc('FIFO_Control - 865');
{$ENDIF}
        If (Ok) then
          FIFO_Edit(IdR,QtyUsed,QtyCr,Fnum,MiscNdxK,Ord(Deduct),BOn,BOn) {* Use Deduct as last parameter,
                                                                          if you do not want auto delete on 0. *}
        else
          FIFO_Add(IdR,QtyUsed,StkUCost,StockR.StockFolio,DocNo,Deduct,(IdR.IdDocHed In SalesSplit),Fnum,Keypath,Fmode, ExLocal);

      end;




      If (Mode=0) and (Deduct) then {==== Update Stock Costprice... ====}
      With StockR do
      Begin

        Rnum:=LastCP;

        {* Get Next Cost Price *}

        StkUCost:=1; {* Temp Var *}

        // CJS 2014-05-20 - ABSEXCH-15080 - ADJ item cost with pack quantity
        FIFO_SQL(StockR,StkUCost,Rnum,Fnum,Keypath,1,FMode,IdR.MLocStk, ExLocal);

        If (Rnum<>LastCP) then
          Update_UpChange(BOn);


        If (Rnum>=0) then
          CostPrice:=Round_Up(Calc_IdQty(Rnum,BuyUnit,Not CalcPack ),Syss.NoCosDec);

      end;


{$IFDEF EXDLL}
Profiler.StartFunc('FIFO_Control - 920');
{$ENDIF}

      SetDataRecOfs(Fnum,RecAddr);

      If (RecAddr<>0) then
        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

      MiscRecs^:=TmpMisc;

{$IFDEF EXDLL}
Profiler.EndFunc('FIFO_Control - 920');
{$ENDIF}
    end; {If Locked ok..}

    TmpStat:=Presrv_BTPos(InvF,TmpKPath,F[InvF],TmpRecAddr,BOn,BOff);

    Inv:=TmpInv;

{$IFDEF EXDLL}
Profiler.EndFunc('FIFO_Control');
{$ENDIF}
  end; {Proc..}




  { ========== Return Cost Price based on averages ========= }


  Function FIFO_GetCost(StockR  :  StockRec;
                        FCurr   :  Byte;
                        QtyCr,
                        QtyM    :  Real;
                        LocFilt :  Str10)  :  Real;

  Var
    Rnum     :  Real;

    TmpKPath,
    TmpStat  :  Integer;

    TmpRecAddr
             :  LongInt;

    TmpMisc  :  MiscRec;


  Begin

    TmpMisc:=MiscRecs^;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOff,BOff);

    {$IFDEF SOP}
      If (LocOCPrice(LocFilt)) then
      Begin
        Stock_LocLinkSubst(StockR,LocFilt);

      end;
    {$ENDIF}

    Rnum:=Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,StockR.CalcPack);

    QtyCr:=QtyCr*DocNotCnst;

    If (Is_FIFO(StockR.StkValType)) then
      FIFO_SQL(StockR,QtyCr,Rnum,MiscF,MIK,1,FIFO_Mode(StockR.StkValType),LocFilt);


    FIFO_GetCost:=Currency_ConvFT(Calc_IdQty(Rnum,QtyM,Not StockR.CalcPack),StockR.PCurrency,FCurr,UseCoDayRate);

    TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOn,BOff);

    MiscRecs^:=TmpMisc;

  end; {Func..}


 { ========== Return Cost Price based on averages of all remaining FIFOS ========= }
 { This function is replicated within RevalU2U for thread safe operation  }


  Function FIFO_GetAVCost(StockR  :  StockRec;
                          LocFilt :  Str10)  :  Real;


  Var
    Rnum,
    Rnum2    :  Real;


    TmpKPath,
    TmpStat  :  Integer;

    TmpRecAddr
             :  LongInt;

    TmpMisc  :  MiscRec;


  Begin

    TmpMisc:=MiscRecs^;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOff,BOff);

    Rnum:=Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,StockR.CalcPack);

    Rnum2:=1;

    If (Is_FIFO(StockR.StkValType)) then
      FIFO_SQL(StockR,Rnum2,Rnum,MiscF,MIK,2,FIFO_Mode(StockR.StkValType),LocFilt);


    FIFO_GetAVCost:=Currency_ConvFT(Rnum,StockR.PCurrency,0,UseCoDayRate);

    TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOn,BOff);

    MiscRecs^:=TmpMisc;

  end; {Func..}

  { ========== Attempt to tidy up negative FIFO by moving negative to top of fifo ========= }

  Procedure FIFO_RenPDN(StockR  :  StockRec;
                        PDNId,
                        PINId   :  Idetail;
                        Fnum,
                        Keypath :  Integer);

  Var

    KeyS,
    KeyChk     :  Str255;

    TmpId      :  IDetail;

    B_Func     :  Integer;

    TmpKPath,
    TmpStat  :  Integer;

    TmpRecAddr
             :  LongInt;

    TmpMisc  :  MiscRec;


  Begin
    If (Is_FIFO(StockR.StkValType)) then
    Begin

      TmpMisc:=MiscRecs^;

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,Strip('B',[#0],MakeFIDocKey(PDNId.DocPRef,StockR.StockFolio,PDNId.ABSLineNo)));

      KeyS:=KeyChk;


      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With MiscRecs^.FIFORec do
      Begin
        DocRef:=PINID.DocPRef;

        DocABSNo:=PINId.ABSLineNo;

        DocFolioK:=MakeFIDocKey(DocRef,StkFolio,DocABSNo);

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        Report_BError(Fnum,Status);

        If (StatusOk) then
          B_Func:=B_GetGEq
        else
          B_Func:=B_GetNext;

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
      end;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      MiscRecs^:=TmpMisc;
    end;
  end;

  {$IFNDEF EXDLL}
    { ========== Attempt to tidy up negative FIFO by moving negative to top of fifo ========= }

    Procedure FIFO_MoveNegs(StockR  :  StockRec;
                            Fnum,
                            Keypath :  Integer);

    Var

      KeyS,
      KeyChk     :  Str255;

      TmpId      :  IDetail;

      NewFDate,
      EarlyDate  :  LongDate;

      B_Func     :  Integer;

      TmpKPath,
      TmpStat  :  Integer;

      TmpRecAddr
               :  LongInt;

      TmpMisc  :  MiscRec;


    Begin
      If (Is_FIFO(StockR.StkValType)) and (StockR.QtyInStock>=0) then
      Begin

        TmpMisc:=MiscRecs^;

        TmpKPath:=GetPosKey;

        TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);


        KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,FullNomKey(StockR.StockFolio));

        KeyS:=KeyChk;

        Blank(NewFDate,Sizeof(NewFDate));

        Blank(EarlyDate,Sizeof(EarlyDate));

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
        With MiscRecs^.FIFORec do
        Begin
          If (EarlyDate='') and (FIFODate<>'') then
          Begin
            EarlyDate:=FIFODate;
            NewFDate:=CalcDueDate(FIFODate,-1);
          end;

          If (QtyLeft<0) and ((EarlyDate<FIFODate) or ((FIFODate='') and (EarlyDate<>''))) and (NewFDate<>'') then
          Begin

            FIFODate:=NewFDate;
            FIFOCode:=MakeFIKey(StkFolio,FIFODate);

            Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

            Report_BError(Fnum,Status);

            B_Func:=B_GetGEq;
          end
          else
            B_Func:=B_GetNext;

          {$IFDEF DXXXBD}
            ShowMessage(DOCRef+'. '+POutDate(FIFODate));

          {$ENDIF}

          Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
        end;

        TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

        MiscRecs^:=TmpMisc;
      end;
    end;

    
  
  Procedure FIFO_Tidy(StkCode :  Str20;
                      LocFilt :  Str10);

  Var
    LOK      :  Boolean;

    QtyCr,
    Rnum     :  Real;

    TmpKPath,
    TmpStat  :  Integer;

    TmpRecAddr
             :  LongInt;

    TmpMisc  :  MiscRec;

    StockR   :  StockRec;


  Begin
    LOK:=BOff;

    TmpMisc:=MiscRecs^;

    TmpKPath:=GetPosKey;

    StockR:=Stock;

    If (Stock.StockCode<>StkCode) then
    Begin
      LOK:=Global_GetMainRec(StockF,STkCode);

    end
    else
      LOK:=BOn;

    TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOff,BOff);

    Rnum:=0.0;

    QtyCr:=0.0;

    If (Is_FIFO(Stock.StkValType)) and (Stock.QtyInStock>=0) and (LOK) then
    Begin

      FIFO_SQL(Stock,QtyCr,Rnum,MiscF,MIK,7,FIFO_Mode(Stock.StkValType),LocFilt);

    end;


    TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOn,BOff);

    MiscRecs^:=TmpMisc;

    Stock:=StockR;

  end; {Func..}

{$ENDIF}

  { =========== Procedure to Re-Evaluate Average Cost Price ========= }

  Procedure FIFO_AvgVal(Var  StockR  :  StockRec;
                             IdR     :  IDetail;
                             QtyUsed :  Real);


  Var
    Rnum,
    TotQ,
    TotA,
    OldQ,
    NegTotA,
    LastCP  :  Real;

    UOR     :  Byte;



  Begin
    UOR:=0;

    With StockR do
    Begin

      LastCP:=CostPrice;

      With IdR do
      Begin
        UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);
                                        
        Rnum:=Conv_TCurr(FIFO_SetCPrice(IdR,40),XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

      end;


      Rnum:=Currency_ConvFT(Rnum,0,PCurrency,UseCoDayRate);

      TotQ:=QtyInStock; {* Already includes new figure *}

      OldQ:=TotQ-QtyUsed;

      If (TotQ>=0) and (OldQ>=0) then {* Only use weighted average if all qtys are +ve *}
        {TotA:=((OldQ*CostPrice)+(QtyUsed*Calc_IdQty(Rnum,BuyUnit,Not CalcPack and Not DPackQty)))}
        {* Altered sames as Ex in v4.30b as with split packs kept decreasing *}
        TotA:=((OldQ*CostPrice)+(QtyUsed*Calc_IdQty(Rnum,BuyUnit,(Not CalcPack))))
      else  {* Replace latest cost as average cost *}
      Begin
        If (IdR.IdDocHed=ADJ) then
          NegTotA:=Calc_IdQty(IdR.CostPrice,BuyUnit,(Not CalcPack))
        else
          NegTotA:=FIFO_SetCPrice(IdR,254);

        With IdR do
        Begin

          TotA:=Conv_TCurr(NegTotA,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

        end;

        TotA:=Currency_ConvFT(TotA,0,PCurrency,UseCoDayRate);

        TotQ:=1;
      end;

      CostPrice:=Round_Up(DivWChk(TotA,TotQ),Syss.NoCosDec);

      If (LastCP<>CostPrice) then
        Update_UpChange(BOn);

    end; {With..}

  end; {Proc..}



  {$IFDEF SOP}

    { ========== Return Cost Price based on averages ========= }


    Procedure FIFO_SERUp(Var StockR  :  StockRec;
                             IdR     :  IDetail;
                             ExLocal : TdPostExLocalPtr = nil);

    Const
      Fnum     =  MiscF;
      Keypath  =  MIK;



    Var
      FoundOk  :  Boolean;
      KeyChk,
      KeyS     :  Str255;

      TmpKPath,
      TmpStat  :  Integer;

      TmpRecAddr
             :  LongInt;

      TmpMisc
             :  MiscRec;


    Begin

      TmpMisc:=MiscRecs^;

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      FoundOk:=BOff;

      With StockR do
      Begin

        KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(StockFolio)+#0);

        KeyS:=KeyChk;

        //PR: 11/09/2014 Order Payments T056 Use ExLocal if assigned
        if Assigned(ExLocal) then
        begin
          Status:=ExLocal.LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);
          MiscRecs^.SerialRec := ExLocal.LMiscRecs^.SerialRec;
        end
        else
          Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

        {$B-}
        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
        With MiscRecs^.SerialRec do
        Begin
        {$B+}
          FoundOk:=(Not Syss.UseMLoc) or (CheckKey(Idr.MLocStk,InMLoc,Length(Idr.MLocStk),BOff));

          If (FoundOk) then
            CostPrice:=Round_Up(Calc_IdQty(Ser_CalcCrCost(PCurrency,MiscRecs^),BuyUnit,Not CalcPack ),
                              Syss.NoCosDec)
          else
          begin
            //PR: 11/09/2014 Order Payments T056 Use ExLocal if assigned
            if Assigned(ExLocal) then
            begin
              Status := ExLocal.LFind_Rec(B_GetNext,Fnum,Keypath,KeyS);
              MiscRecs^.SerialRec := ExLocal.LMiscRecs^.SerialRec;
            end
            else
              Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
          end;


        end;

      end; {With..}


      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      MiscRecs^:=TmpMisc;

    end; {Proc..}


    { ========== Return Cost Price based on averages ========= }
    { This function is replicated within RevalU2U for thread safe operation  }


    Function FIFO_AvSNO(Var StockR  :  StockRec;
                            LocFilt :  Str10;
                            ExLocal : TdPostExLocalPtr = nil)  :  Real;

    Const
      Fnum     =  MiscF;
      Keypath  =  MIK;



    Var
      KeyChk,
      KeyS     :  Str255;

      TmpKPath,
      TmpStat  :  Integer;

      TmpRecAddr
               :  LongInt;

      Rnum2,
      Rnum,
      Qty      :  Real;

      TmpMisc  :  MiscRec;


    Begin

      TmpMisc:=MiscRecs^;

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      Rnum:=0.0;  Rnum2:=0.0;

      Qty:=0.0;

      With StockR do
      Begin

        KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(StockFolio)+#0);

        KeyS:=KeyChk;

        if Assigned(ExLocal) then
        begin
          Status:= ExLocal.LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);
          MiscRecs^.SerialRec := ExLocal.LMiscRecs^.SerialRec;
        end
        else
          Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
        With MiscRecs^.SerialRec do
        Begin

          If (Not Sold) and (Not Syss.UseMLoc or CheckKey(InMLoc,LocFilt,Length(LocFilt),BOff)) then
          Begin

            If (BatchRec) then
            Begin
              Rnum2:=BuyQty-QtyUsed;

              Qty:=Qty+Rnum2;
            end
            else
            Begin
              Qty:=Qty+1.0;
              Rnum2:=1.0;
            end;


            Rnum:=Rnum+Round_Up(Calc_IdQty(Ser_CalcCrCost(0,MiscRecs^),BuyUnit,Not CalcPack)*Rnum2,
                                Syss.NoCosDec);
          end;


          if Assigned(ExLocal) then
          begin
            Status:=ExLocal.LFind_Rec(B_GetNext,Fnum,Keypath,KeyS);
            MiscRecs^.SerialRec := ExLocal.LMiscRecs^.SerialRec;
          end
          else
            Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

        end;

      end; {With..}


      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      MiscRecs^:=TmpMisc;

      If (Qty=0.0) and (Rnum=0.0) then {* Substitute record cost price *}
      Begin
        Rnum:=Currency_ConvFT(Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,StockR.CalcPack),StockR.PCurrency,0,UseCoDayRate);

        Qty:=1.0;
      end;


      FIFO_AvSNO:=Round_Up(DivWChk(Rnum,Qty),Syss.NoCosDec);

    end; {Proc..}

  {$ENDIF}







end.
