Unit RevalU2U;



{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 19/01/94                      }
{                                                              }
{               Currency Revaluation Support Unit              }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst,
     VARRec2U,
     ExBtTh1U;


Const
  AutoNomHedTit  :  Array[0..9] of String[20] = ('Auto Re-Valuation','Stock Valuation','Stock Adjustment',
                                                 'Auto Closure','','Time sheet auto WIP','Stock Val','Accrual','Self Billing Invoice','Retrn Adj');


Procedure Create_NTHedInv(Var  Abort,
                               InitBo  :  Boolean;
                               HDesc   :  Str80;
                               Mode    :  Byte;
                               BInv    :  InvRec;
                               ExLocal :  TdPostExLocalPtr;
                               UseSystemDate: Boolean = False;
                               UseTransactionRates: Boolean = FALSE);

Procedure Create_NTHed(Var  Abort,
                            InitBo  :  Boolean;
                            HDesc   :  Str80;
                            Mode    :  Byte;
                            ExLocal :  TdPostExLocalPtr);

Procedure Create_NomTxfrLines(Var  Idr      :  IDetail;
                                   ExLocal  :  TdPostExLocalPtr);


{$IFDEF STK}

  Procedure Add_StockValue(BSNCode,
                           PLNCode :  LongInt;
                           STKValue
                                   :  Real;
                           LocFilt,
                           ORStr   :  Str10;
                           RCCDep,
                           OCCDep  :  CCDepType;
                           MultiLine
                                   :  Boolean;
                      Var  Abort   :  Boolean;
                           ExLocal :  tdPostExLocalPtr);


  

  Function RevalueStkCid(NCode  :  LongInt;
                         ExLocal:  tdPostExLocalPtr)  :  Boolean;

  {$IFDEF SOP}
    Function Ser_CalcCrCostCid(ICr      :  Byte;
                               TMisc    :  MiscRec;
                               ExLocal  :  tdPostExLocalPtr)  :  Double;
  {$ENDIF}

  Function StkCalc_AVCost(StockR    :  StockRec;
                          Locn      :  Str10;
                          ExLocal   :  tdPostExLocalPtr)  :  Real;


{$ENDIF}


  Procedure Reset_NomTxfrLines(InvR      :  InvRec;
                               ExLocal   :  tdPostExLocalPtr);


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   {EWinSBS,}
   Forms,
   ETMiscU,
   ETDateU,
   ETStrU,
   BtrvU2,

   {$IFDEF JC}
     VarJCStU,

   {$ENDIF}

   BTSupU1,
   BTKeys1U,
   ComnUnit,
   ComnU2,
   CurrncyU,
   Event1U,
   {$IFDEF STK}

     {$IFDEF PF_On}

       FIFOL2U,

     {$ENDIF}

   {$ENDIF}

   SysU2,
   SysU1,

   { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
   TransactionOriginator,

   AuditNotes;






{ ========================= Create Nominal Transfer Header ===================== }

Procedure Create_NTHedInv(Var  Abort,
                               InitBo  :  Boolean;
                               HDesc   :  Str80;
                               Mode    :  Byte;
                               BInv    :  InvRec;
                               ExLocal :  TdPostExLocalPtr;
                               UseSystemDate: Boolean;
                               UseTransactionRates: Boolean);



Const
  Fnum       =  InvF;
  Keypath    =  InvRNoK;



Begin

  With ExLocal^ do
  Begin
    LResetRec(Fnum);

    With LInv do
    Begin

      NomAuto:=BOn;

      InvDocHed:=NMT;




      Case Mode of
        3  :  TransDesc:=dbFormatName(HDesc,AutoNomHedTit[Mode]);
        4  :  TransDesc:=HDesc;
        7  :  TransDesc:='Auto '+Copy(DocGroup[Ord(BInv.InvDocHed In Salessplit)+1],1,5)+' '+AutoNomHedTit[Mode];
        else  TransDesc:=AutoNomHedTit[Mode]+HDesc;

      end; {Case..}


      If (Mode In [6,9]) then
      Begin
        if (UseSystemDate) then
          TransDate := Today
        else
          TransDate:=BInv.TransDate;
        AcPr:=BInv.ACPr; AcYr:=BInv.ACYr;
        TransDesc:=TransDesc+'. '+BInv.OurRef;
        ExternalDoc:=BOn;

        If (Mode=9) then
        Begin
          Currency:=BInv.Currency;

          If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
            Date2Pr(TransDate,ACPr,ACYr,nil);
        end;
      end;


      If (Not (Mode In [6,9])) or (AcPr=0) or (AcYr=0) then
      Begin
        TransDate:=Today;

        AcPr:=GetLocalPr(0).CPr;
        AcYr:=GetLocalPr(0).CYr;

        If (Mode=6) then
          Currency:=0

      end;

      OpName:=EntryRec^.LogIn;

      { CJS - 2013-10-25 - MRD2.6.02 - Transaction Originator }
      TransactionOriginator.SetOriginator(LInv);

      if UseTransactionRates then
      begin
        CXRate := BInv.CXRate;
        SOPKeepRate := True;
      end
      else
      begin
        CXrate:=SyssCurr.Currencies[Currency].CRates;
        SOPKeepRate := False;
      end;

      SetTriRec(Currency,UseORate,CurrTriR);

      LSetNextDocNos(LInv,BOn);

      ILineCount:=1;
      NLineCount:=1;

      Untagged:=(Mode=7);

      LStatus:=LAdd_Rec(Fnum,KeyPath);

      //GS 04/11/2011 add an audit note to the newly created NOM transaction header
      if LStatus = 0 then
      begin
        TAuditNote.WriteAuditNote(anTransaction, anCreate, ExLocal^);
      end;
      
      LReport_BError(Fnum,LStatus);

      Abort:=Not LStatusOk;

      InitBo:=Not Abort;

    end; {With..}
  end; {With..}
end; {Proc..}

{ ========================= Create Nominal Transfer Header ===================== }

Procedure Create_NTHed(Var  Abort,
                            InitBo  :  Boolean;
                            HDesc   :  Str80;
                            Mode    :  Byte;
                            ExLocal :  TdPostExLocalPtr);


Var
  BInv  :  InvRec;


Begin
  Blank(BInv,Sizeof(BInv));


  Create_NTHedInv(Abort,InitBo,HDesc,Mode,BInv,ExLocal);
end; {Proc..}


{ ======== Create De_fault Nominal Txfr Lines  ======== }


Procedure Create_NomTxfrLines(Var  Idr      :  IDetail;
                                   ExLocal  :  TdPostExLocalPtr);

Var
  TCCDep  :  CCDepType;

Begin
  With ExLocal^ do
  Begin
    TCCDep:=Idr.CCDep;

    LResetRec(IDetailF);

    With Idr do
    Begin

      FolioRef:=LInv.FolioNum;

      DocPRef:=LInv.OurRef;

      LineNo:=RecieptCode;

      Qty:=1;

      Currency:=LInv.Currency;

      CCDep:=TCCDep;
      
      CXRate:=LInv.CXRate;

      CurrTriR:=LInv.CurrTriR;

      PYr:=LInv.ACYr;
      PPr:=LInv.AcPr;

      Payment:=SetRPayment(LInv.InvDocHed);

      If (Syss.AutoClearPay) then
        Reconcile:=ReconC;


      IDDocHed:=LInv.InvDocHed;

      CustCode:=LInv.CustCode;

      PDate:=LInv.TransDate;
    end; {With..}
  end; {With..}
end; {Proc..}


{$IFDEF STK}


  { ========================= Store Valuation Lines  ===================== }

  Procedure Add_StockValue(BSNCode,
                           PLNCode :  LongInt;
                           STKValue
                                   :  Real;
                           LocFilt,
                           ORStr   :  Str10;
                           RCCDep,
                           OCCDep  :  CCDepType;
                           MultiLine
                                   :  Boolean;
                      Var  Abort   :  Boolean;
                           ExLocal :  tdPostExLocalPtr);

  Const
    Fnum    =  IDetailF;
    Keypath =  IdRunK;


  Var
    FoundOk,
    Done   :  Boolean;

    KeyChk,
    KeyS   :  Str255;

    TNCode :  LongInt;


  Begin

    With ExLocal^ do
    Begin
      Done:=BOn;

      TNCode:=BSNCode;

      Repeat

        If (Not MultiLine) then {*EN422}
        Begin
          KeyS:=FullRunNoKey(StkValVRunNo,TNCode);

          KeyChk:=Strip('R',[#0],KeyS);

          LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

          If (Syss.UseCCDep) then {V5. Search for matching cc/dep}
          Begin
            FoundOk:=BOff;

            While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
            Begin
              FoundOk:=(RCCDep[BOff]=LId.CCDep[BOff]) and (RCCDep[BOn]=LId.CCDep[BOn]);

              If (Not FoundOk) then
                LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
            end; {While..}

            If (Not FoundOk) then
              LStatus:=4;
          end;

        end
        else
          LStatus:=4;  {* Force a not found for each line *}

        If (LStatusOk) and ((RCCDep[BOff]=LId.CCDep[BOff]) and (RCCDep[BOn]=LId.CCDep[BOn]) or (Not Syss.UseCCDep)) then
        Begin

          LId.NetValue:=LId.NetValue+StkValue;


          LStatus:=LPut_Rec(Fnum,KeyPath);

        end
        else
        Begin
          
          Create_NomTxfrLines(LId,ExLocal);

          With LId do
          Begin

            NomCode:=TNCode;

            If (MultiLine) then
            Begin
              Desc:=Copy(ORStr+': '+Strip('R',[#32],LStock.StockCode)+'. '+LInv.TransDesc,1,50);
            end
            else
              Desc:=LInv.TransDesc;

            If (LocFilt<>'') then
              Desc:=Desc+'. Locn : '+LocFilt;

            PostedRun:=StkValVRunNo;

            NetValue:=StkValue;



            CCDep:=RCCDep;

            LStatus:=LAdd_Rec(Fnum,KeyPath);
          end; {With..}

        end; {If Add needed}


        LReport_BError(Fnum,LStatus);

        Abort:=Not LStatusOk;

        Done:=Not Done;

        TNCode:=PLNCode;
        RCCDep:=OCCDep;

        StkValue:=StkValue*DocNotCnst;

        {$IFDEF SOP}
          If (Not Done) and (LastInv.InvDocHed=ADJ) and (LastInv.DelTerms<>'') then {* v5.70 Its a loc transfer, use in loc as text *}
            LocFilt:=LastInv.DelTerms;
        {$ENDIF}

      Until (Done) or (Abort);
    end; {With..}
  end; {Proc..}





  { ======== Procedure to Scan FIFO and Process / Return Cost Price ======= }
  { These routines have been replicated for thread safe operation from FIFOL2U }



Function RevalueStkCid(NCode  :  LongInt;
                       ExLocal:  tdPostExLocalPtr)  :  Boolean;

  Const
    Fnum    =  NomF;
    KPath2  =  NomCodeK;


  Var
    TmpNom  :  NominalRec;

    LastStat,
    TmpStat,
    Keypath :  Integer;
    TmpRecAddr,
    NC      :  LongInt;

    KeyS    :  Str255;

  Begin
    With ExLocal^ do
    Begin
      LastStat:=LStatus;
      TmpNom:=LNom;
      Keypath:=GetPosKey;

      LResetRec(Fnum);

      TmpStat:=LPresrv_BTPos(Fnum,KeyPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      //PR: 24/03/2016 v2016 R2 ABSEXCH-17390 Assume that we should look for NCOde rather than undefined NC
      KeyS:=FullNomKey(NCode);

      LStatus:=LFind_Rec(B_GetEq,Fnum,Kpath2,KeyS);

      RevalueStkCid:=(LStatusOk and LNom.Revalue);

      TmpStat:=LPresrv_BTPos(Fnum,KeyPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

      LNom:=TmpNom;
      LStatus:=LastStat;
    end;
  end;



Function FIFO_CalcCrCostCid(StockR  :  StockRec;
                            TMisc   :  MiscRec;
                            ExLocal
                                    :  tdPostExLocalPtr) :  Double;


Var
  UseRate  :  Boolean;
  NewAmnt  :  Double;


Begin
  UseRate:=UseCoDayRate;
  NewAmnt:=0.0;

  With TMisc.FIFORec do
  Begin
    {$IFDEF MC_On}
      If (Not RevalueStkCid(StockR.NomCodes[4],ExLocal)) and (FIFOCRates[UseRate]<>0.0) then
      Begin
        NewAmnt:=Conv_TCurr(FIFOCost,FIFOCRates[UseRate],FIFOCurr,FUseORate,BOff);

        With SyssCurr^.Currencies[StockR.PCurrency] do
          FIFO_CalcCrCostCid:=Conv_TCurr(NewAmnt,CRates[UseRate],StockR.PCurrency,0,BOn);


      end
      else
    {$ENDIF}

        FIFO_CalcCrCostCid:=Currency_ConvFT(FIFOCost,FIFOCurr,StockR.PCurrency,UseRate);


  end;
end;


Procedure FIFO_SQLCId(StockR  :  StockRec;
                  Var QtyCr,
                      CPrice  :  Real;
                      Fnum,
                      Keypath :  Integer;
                      Mode,
                      FMode   :  Byte;
                      LocFilt :  Str10;
                      ExLocal
                              :  tdPostExLocalPtr);





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

    AVQty:=0; AVPrice:=0;  AVCalc:=0;

    QtyUsed:=QtyCr;

    QtyNeed:=QtyCr*DocNotCnst;

    TmpQty:=0; FoundSome:=BOff;


    Blank(TmpId,Sizeof(TmpId));

    B_Start:=B_GetGEq;

    B_Func:=B_GetNext;

    With ExLocal^ do
    Case Mode of

      0..2
           :  Begin

                KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,FullNomKey(StockR.StockFolio));

                KeyS:=KeyChk;

                If (FMode=3) then {* Its LIFO *}
                Begin

                  KeyS:=KeyS+NdxWeight;

                  B_Start:=B_GetLessEq;
                  B_Func:=B_GetPrev;

                end;

                LStatus:=LFind_Rec(B_Start,Fnum,Keypath,KeyS);

                While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (QtyUsed<>0) do
                With LMiscRecs^.FIFORec do
                Begin

                  {* Average Calculations... Only use +ve FIFO Lines *}

                  {$B-}

                  If (Not Syss.UseMLoc) or (CheckKey(FIFOMLoc,LocFilt,Length(LocFilt),BOff)) then
                  Begin

                  {$B+}

                    If (Not FoundSome) then
                      FoundSome:=BOn;

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

                    AvCalc:=(TmpQty*FIFO_CalcCrCostCid(StockR,LMiscRecs^,ExLocal));


                    AvPrice:=AvPrice+AvCalc;

                    {Case Mode of

                      0  :  FIFO_Edit(TmpId,QtyUsed,0,Fnum,Keypath,Mode,BOff,BOn);
                      1  :  Begin

                              QtyUsed:=QtyUsed+QtyLeft;

                              If (QtyUsed>0) then
                                QtyUsed:=0;
                            end;
                    end;}
                  end;

                  If (QtyUsed<>0) then
                    LStatus:=LFind_Rec(B_Func,Fnum,Keypath,KeyS);

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

                          CPrice:=Round_Up(DivWChk(AvPrice,AvCalc),Syss.NoCosDec);
                        end;

                end;{case..}
              end;

    end; {Case..}

    QtyCr:=QtyUsed;

  end; {Proc..}

  Function FIFO_GetAVCostCId(StockR  :  StockRec;
                             LocFilt :  Str10;
                             ExLocal :  tdPostExLocalPtr)  :  Real;


  Var
    Rnum,
    Rnum2    :  Real;


    TmpKPath,
    TmpStat  :  Integer;

    TmpRecAddr
             :  LongInt;

    TmpMisc  :  MiscRec;


  Begin

    With ExLocal^ do
    Begin

      TmpMisc:=LMiscRecs^;

      TmpKPath:=GetPosKey;

      TmpStat:=LPresrv_BTPos(MiscF,TmpKPath,LocalF^[MiscF],TmpRecAddr,BOff,BOff);

      Rnum:=Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,StockR.CalcPack);

      Rnum2:=1;

      If (Is_FIFO(StockR.StkValType)) then
        FIFO_SQLCId(StockR,Rnum2,Rnum,MiscF,MIK,2,FIFO_Mode(StockR.StkValType),LocFilt,ExLocal);


      FIFO_GetAVCostCId:=Currency_ConvFT(Rnum,StockR.PCurrency,0,UseCoDayRate);

      TmpStat:=LPresrv_BTPos(MiscF,TmpKPath,LocalF^[MiscF],TmpRecAddr,BOn,BOff);

      LMiscRecs^:=TmpMisc;

    end; {With..}
  end; {Func..}



  {$IFDEF SOP}


  Function GetStkBNCCid(TMisc   :  MiscRec;
                        ExLocal :  tdPostExLocalPtr)  :  LongInt;

  Const
    Fnum    =  StockF;
    KPath2  =  StkFolioK;


  Var
    TmpStk  :  StockRec;

    LastStat,
    TmpStat,
    Keypath :  Integer;
    TmpRecAddr
            :  Longint;

    KeyS    :  Str255;


  Begin

    With ExLocal^ do
    Begin
      If (LStock.StockFolio=TMisc.SerialRec.StkFolio) then
        GetStkBNCCid:=LStock.NomCodes[4]
      else
      Begin
        LastStat:=LStatus;
        TmpStk:=LStock;
        Keypath:=GetPosKey;

        TmpStat:=LPresrv_BTPos(Fnum,KeyPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        KeyS:=FullNomKey(TMisc.SerialRec.StkFolio);

        LStatus:=LFind_Rec(B_GetEq,Fnum,Kpath2,KeyS);

        If (LStatusOk) then
          GetStkBNCCid:=LStock.NomCodes[4]
        else
          GetStkBNCCid:=0;

        TmpStat:=LPresrv_BTPos(Fnum,KeyPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

        LStock:=TmpStk;
        LStatus:=LastStat;
      end;
    end;
  end;


  Function Ser_CalcCrCostCid(ICr      :  Byte;
                             TMisc    :  MiscRec;
                             ExLocal  :  tdPostExLocalPtr)  :  Double;


  Var
    UseRate  :  Boolean;
    NewAmnt  :  Double;


  Begin
    UseRate:=UseCoDayRate;
    NewAmnt:=0.0;

    With TMisc.SerialRec do
    Begin
      {$IFDEF MC_On}
        If (Not RevalueStkCid(GetStkBNCCid(TMisc,ExLocal),ExLocal)) and (SerCRates[UseRate]<>0.0) then
        Begin
          NewAmnt:=Conv_TCurr(SerCost,SerCRates[UseRate],CurCost,SUseORate,BOff);

          With SyssCurr^.Currencies[ICr] do
            Ser_CalcCrCostCid:=Conv_TCurr(NewAmnt,CRates[UseRate],ICr,0,BOn);


        end
        else
      {$ENDIF}

          Ser_CalcCrCostCid:=Currency_ConvFT(SerCost,CurCost,ICr,UseRate);


    end;
  end;

  { ========== Return Cost Price based on averages ========= }



    Function FIFO_AvSNOCId(Var StockR    :  StockRec;
                               LocFilt   :  Str10;
                               ExLocal   :  tdPostExLocalPtr)  :  Real;

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

      With ExLocal^ do
      Begin

        TmpMisc:=LMiscRecs^;

        TmpKPath:=GetPosKey;

        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        Rnum:=0.0;  Rnum2:=0.0;

        Qty:=0.0;

        With StockR do
        Begin

          KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(StockFolio)+#0);

          KeyS:=KeyChk;

          LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);


          While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
          With LMiscRecs^.SerialRec do
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


              {Rnum:=Rnum+Round_Up(Calc_IdQty(Ser_CalcCrCostCid(0,LMiscRecs^,ExLocal),BuyUnit,Not CalcPack)*Rnum2,
                                  Syss.NoCosDec);
              EL: v5.01. b500.192. 04/11/2002. This line replaced without Calc_Idqty as price stored against serial record is unit price regardless
              of any pack qty. A serial item with the pricing set to split pack and show qty split pack was not dividing down the
              cost into the pack qty in the stock valuation report}



              Rnum:=Rnum+Round_Up(Ser_CalcCrCostCid(0,LMiscRecs^,ExLocal)*Rnum2,
                                  Syss.NoCosDec);
            end;


            LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyS);

          end;

        end; {With..}


        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

        LMiscRecs^:=TmpMisc;

        If (Qty=0.0) and (Rnum=0.0) then {* Substitute record cost price *}
        Begin
          Rnum:=Currency_ConvFT(Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,StockR.CalcPack),StockR.PCurrency,0,UseCoDayRate);
          Qty:=1.0;
        end;

        FIFO_AvSNOCid:=Round_Up(DivWChk(Rnum,Qty),Syss.NoCosDec);
      end; {With..}
    end; {Proc..}

  {$ENDIF}



  { ========= Get Stock Last Cost ========= }

  Function StkCalc_AVCost(StockR    :  StockRec;
                          Locn      :  Str10;
                          ExLocal   :  tdPostExLocalPtr)  :  Real;


  Var
    KeyS,
    KeyChk  :  Str255;

    Rnum    :  Real;

    FIFOMode:  Byte;


  Begin

    Rnum:=0;

    With StockR do
    Begin
      {$IFDEF Pf_On}

        FIFOMode:=FIFO_Mode(SetStkVal(StkValType,SerNoWAvg,BOn));

        Case FIFOMode of

          1,4,6
            :  Rnum:=Round_up(Currency_ConvFT(Calc_StkCP(CostPrice,BuyUnit,CalcPack),PCurrency,0,UseCoDayRate),
                              Syss.NoCosDec);

          2,3
            :  Rnum:=Round_Up(FIFO_GetAvCostCId(StockR,Locn,ExLocal),Syss.NoCosDec);

          {$IFDEF SOP}

            5 :  Rnum:=Round_Up(FIFO_AvSNoCId(StockR,Locn,ExLocal),Syss.NoCosDec);

          {$ENDIF}

        end; {Case..}

      {$ELSE}

        Rnum:=Round_up(Currency_ConvFT(Calc_StkCP(CostPrice,BuyUnit,CalcPack),PCurrency,0,UseCoDayRate),Syss.NoCosDec);

      {$ENDIF}

    end; {With..}

    StkCalc_AVCost:=Rnum;

  end; {Func..}


{$ENDIF}



  { ========= Procedure to reset Nom Txfr Lines Run No, in line with header ========= }

  Procedure Reset_NomTxfrLines(InvR      :  InvRec;
                               ExLocal   :  tdPostExLocalPtr);

  Const
    Fnum     =  IDetailF;
    Keypath  =  IDFolioK;


  Var
    KeyS,
    KeyChk   :  Str255;
    TempRunNo:  LongInt;



  Begin
    TempRunNo:=0;

    With ExLocal^ do
    Begin

      KeyChk:=FullNomKey(InvR.FolioNum);

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      Begin
        Application.ProcessMessages;

        With LId do
        Begin
          {$IFDEF JC}
            If (TempRunNo=0) and ((PostedRun=CloseJobRunNo) or (PostedRun=TSTTempRunNo) or (PostedRun=JCSelfBillRunNo)) then
              TempRunNo:=PostedRun;
          {$ENDIF}


          PostedRun:=InvR.RunNo;

          LStatus:=LPut_Rec(Fnum,KeyPath);

          LReport_BError(Fnum,LStatus);

        end; {If Ok to Use..}

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}

      {* Mop up any stray lines from other runs *}


      {$IFDEF NEVERUSETHIS}

      This has been disabled as the possibility of user conflict is too great v4.32
      It would be better to use SF4 to mop these up automatically.
      The compiler will stop here should the def ever be set!

        If (TempRunNo<>0) then
        Begin
          KeyS:=FullNomKey(TempRunNo);

          {$IFDEF JC}
            If (TempRunNo<>JCSelfBillRunNo) then {*Do not delete Self Billing as there could be others...}
          {$ENDIF}
            LDeleteLinks(KeyS,IDetailF,Length(KeyS),IdRunK,BOff);

        end
        else
        Begin
          KeyS:=FullNomKey(StkValVRunNo);

          LDeleteLinks(KeyS,IDetailF,Length(KeyS),IdRunK,BOff);

          KeyS:=FullNomKey(StkValRRunNo);

          LDeleteLinks(KeyS,IDetailF,Length(KeyS),IdRunK,BOff);
        end;
      {$ENDIF}


    end; {With..}

    
  end; {Proc..}










end.